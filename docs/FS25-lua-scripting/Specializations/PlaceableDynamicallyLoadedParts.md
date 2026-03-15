## PlaceableDynamicallyLoadedParts

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onDynamicallyPartI3DLoaded](#ondynamicallyparti3dloaded)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableDynamicallyLoadedParts:onDelete()
    local spec = self.spec_dynamicallyLoadedParts

    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
    end

    if spec.parts ~ = nil then
        for _, part in pairs(spec.parts) do
            delete(part.node)
        end
    end
end

```

### onDynamicallyPartI3DLoaded

**Description**

**Definition**

> onDynamicallyPartI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableDynamicallyLoadedParts:onDynamicallyPartI3DLoaded(i3dNode, failedReason, args)
    local spec = self.spec_dynamicallyLoadedParts

    local loadingTask = args.loadingTask
    local filename = args.filename
    local xmlFile = args.xmlFile
    local partKey = args.key

    if i3dNode = = 0 then
        Logging.xmlError(xmlFile, "Could not load load part %q at %q!" , filename, partKey)
        self:finishLoadingTask(loadingTask)
        return false
    end

    local node = xmlFile:getValue(partKey .. "#node" , "0" , i3dNode)
    if node = = nil then
        Logging.xmlWarning(xmlFile, "Failed to load dynamicallyLoadedPart '%s'.Unable to find node in loaded i3d" , partKey)
        self:finishLoadingTask(loadingTask)
        delete(i3dNode)
        return false
    end

    -- get set of all skinned shapes of the node to be linked
    local linkedSkinnedShapes
    I3DUtil.iterateRecursively(node, function (toBeLinkedNode)
        if getHasClassId(toBeLinkedNode, ClassIds.SHAPE) and getShapeIsSkinned(toBeLinkedNode) then

            linkedSkinnedShapes = linkedSkinnedShapes or { }
            linkedSkinnedShapes[toBeLinkedNode] = true
        end
    end )

    -- get set of all bones of the dynamically loaded i3d to check skinned shape against
    local linkedBones
    I3DUtil.iterateRecursively(i3dNode, function (loadedNode)
        if getHasClassId(loadedNode, ClassIds.SHAPE) and getShapeIsSkinned(loadedNode) then
            local numBones = getNumOfShapeBones(loadedNode)
            for boneIndex = 0 , numBones - 1 do
                local bone = getShapeBone(loadedNode, boneIndex)

                linkedBones = linkedBones or { }
                linkedBones[bone] = loadedNode -- keep skinned node ref for printing error
                end
            end
        end )

        -- if skinned nodes or bones are present do further checks
            if linkedSkinnedShapes ~ = nil or linkedBones ~ = nil then

                -- set of shapes referenced by linked bones
                local missingShapesForBones

                -- remove all linked bones from the list to see if any required bones are not linked
                    I3DUtil.iterateRecursively(node, function (toBeLinkedNode)
                        local shape = linkedBones[toBeLinkedNode]
                        if shape ~ = nil then
                            linkedBones[toBeLinkedNode] = nil

                            -- create set of shapes which there are linked bones for
                                if linkedSkinnedShapes = = nil or linkedSkinnedShapes[shape] = = nil then
                                    missingShapesForBones = missingShapesForBones or { }
                                    missingShapesForBones[shape] = toBeLinkedNode -- shape to bone mapping
                                end
                            end
                        end )

                        -- warn if bones are present but their shape is not
                            if missingShapesForBones ~ = nil then
                                for shape, bone in pairs(missingShapesForBones) do
                                    Logging.xmlWarning( self.xmlFile, "Node %q at %q do not contain the skinned shape %q for bone %q, ignoring" , getName(node), partKey .. "#node" , getName(shape), getName(bone))
                                    end

                                    self:finishLoadingTask(loadingTask)
                                    delete(i3dNode)
                                    return false
                                end

                                -- if bones are left in the list they are not part of the linked noes, raise error and skip as this crashes the engine otherwise
                                    if next(linkedBones) ~ = nil then
                                        for bone, shape in pairs(linkedBones) do
                                            if linkedSkinnedShapes = = nil or linkedSkinnedShapes[shape] ~ = nil then
                                                Logging.xmlWarning( self.xmlFile, "Node %q at %q does not contain all bones of the skinned shape %q and cannot be linked on their own, ignoring" , getName(node), partKey .. "#node" , getName(shape))

                                                -- remove this shape from the list to avoid duplicate warnings
                                                for bone2, shape2 in pairs(linkedBones) do
                                                    if shape = = shape2 then
                                                        linkedBones[bone2] = nil
                                                    end
                                                end

                                                if linkedSkinnedShapes ~ = nil then
                                                    linkedSkinnedShapes[shape] = nil -- do not raise an error for this shape again
                                                    end
                                                end
                                            end

                                            self:finishLoadingTask(loadingTask)
                                            delete(i3dNode)
                                            return false
                                        end
                                    end

                                    local linkNode = xmlFile:getValue(partKey .. "#linkNode" , "0>" , self.components, self.i3dMappings)
                                    if linkNode = = nil then
                                        Logging.xmlWarning(xmlFile, "Failed to load dynamicallyLoadedPart '%s'.Unable to find linkNode" , partKey)
                                        self:finishLoadingTask(loadingTask)
                                        delete(i3dNode)
                                        return false
                                    end

                                    removeFromPhysics(node)

                                    local x, y, z = xmlFile:getValue(partKey .. "#position" )
                                    if x ~ = nil and y ~ = nil and z ~ = nil then
                                        setTranslation(node, x,y,z)
                                    end

                                    local rotationNode = xmlFile:getValue(partKey .. "#rotationNode" , node, i3dNode)
                                    local rotX, rotY, rotZ = xmlFile:getValue(partKey .. "#rotation" )
                                    if rotX ~ = nil and rotY ~ = nil and rotZ ~ = nil then
                                        setRotation(rotationNode, rotX, rotY, rotZ)
                                    end

                                    local shaderParameterName = xmlFile:getValue(partKey .. "#shaderParameterName" )
                                    local sx, sy, sz, sw = xmlFile:getValue(partKey .. "#shaderParameter" )
                                    if shaderParameterName ~ = nil and sx ~ = nil and sy ~ = nil and sz ~ = nil and sw ~ = nil then
                                        setShaderParameter(node, shaderParameterName, sx, sy, sz, sw, false )
                                    end

                                    local objectChanges = ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, partKey, nil , i3dNode, nil )
                                    ObjectChangeUtil.setObjectChanges(objectChanges, true , nil )

                                    link(linkNode, node)
                                    delete(i3dNode)

                                    local dynamicallyLoadedPart = { }
                                    dynamicallyLoadedPart.filename = filename
                                    dynamicallyLoadedPart.node = node

                                    table.insert(spec.parts, dynamicallyLoadedPart)
                                    self:finishLoadingTask(loadingTask)

                                    return true
                                end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function PlaceableDynamicallyLoadedParts:onLoad(savegame)
    local spec = self.spec_dynamicallyLoadedParts

    spec.sharedLoadRequestIds = { }
    spec.parts = { }

    self.xmlFile:iterate( "placeable.dynamicallyLoadedParts.dynamicallyLoadedPart" , function (_, partKey)
        local filename = self.xmlFile:getValue(partKey .. "#filename" )
        if filename ~ = nil then
            filename = Utils.getFilename(filename, self.baseDirectory)

            local args = {
            xmlFile = self.xmlFile,
            key = partKey,
            loadingTask = self:createLoadingTask(spec),
            filename = filename
            }

            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, true , true , self.onDynamicallyPartI3DLoaded, self , args)
            table.insert(spec.sharedLoadRequestIds, sharedLoadRequestId)
        else
                Logging.xmlWarning( self.xmlFile, "Missing filename for dynamically loaded part '%s'" , partKey)
                end
            end )
        end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function PlaceableDynamicallyLoadedParts.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableDynamicallyLoadedParts.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableDynamicallyLoadedParts )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableDynamicallyLoadedParts )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableDynamicallyLoadedParts )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableDynamicallyLoadedParts.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onDynamicallyPartI3DLoaded" , PlaceableDynamicallyLoadedParts.onDynamicallyPartI3DLoaded)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableDynamicallyLoadedParts.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "DynamicallyLoadedParts" )

    basePath = basePath .. ".dynamicallyLoadedParts.dynamicallyLoadedPart(?)"

    schema:register(XMLValueType.STRING, basePath .. "#filename" , "Filename to i3d file" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Node in external i3d file" , "0" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#linkNode" , "Link node" , "0>" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#position" , "Position" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#rotationNode" , "Rotation node" , "node" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. "#rotation" , "Rotation node rotation" )
    schema:register(XMLValueType.STRING, basePath .. "#shaderParameterName" , "Shader parameter name" )
    schema:register(XMLValueType.VECTOR_ 4 , basePath .. "#shaderParameter" , "Shader parameter to apply" )

    ObjectChangeUtil.registerObjectChangeSingleXMLPaths(schema, basePath)

    schema:setXMLSpecializationType()
end

```