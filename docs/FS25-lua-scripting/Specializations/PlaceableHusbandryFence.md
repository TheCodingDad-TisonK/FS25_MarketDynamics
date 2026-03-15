## PlaceableHusbandryFence

**Description**

> Specialization for placeables

**Functions**

- [getCanBePlacedAt](#getcanbeplacedat)
- [getFence](#getfence)
- [getHasCustomizableFence](#gethascustomizablefence)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFenceI3DLoaded](#onfencei3dloaded)
- [onLoad](#onload)
- [onPreFinalizePlacement](#onprefinalizeplacement)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setPreviewPosition](#setpreviewposition)
- [updateHusbandryFence](#updatehusbandryfence)

### getCanBePlacedAt

**Description**

**Definition**

> getCanBePlacedAt()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |
| any | farmId    |

**Code**

```lua
function PlaceableHusbandryFence:getCanBePlacedAt(superFunc, x, y, z, farmId)
    local spec = self.spec_husbandryFence
    if not self.spec_husbandryFence.canBePlaced then
        local lastError = spec.lastFenceError
        local errorMessageLocaKey = ConstructionBrushNewFence.SEGMENT_ERROR_TO_MESSAGE[lastError] or "warning_canNotPlaceFence"

        return false , g_i18n:getText(errorMessageLocaKey)
    end

    return superFunc( self , x, y, z, farmId)
end

```

### getFence

**Description**

**Definition**

> getFence()

**Code**

```lua
function PlaceableHusbandryFence:getFence()
    local spec = self.spec_husbandryFence
    return spec.fence
end

```

### getHasCustomizableFence

**Description**

**Definition**

> getHasCustomizableFence()

**Code**

```lua
function PlaceableHusbandryFence:getHasCustomizableFence()
    local spec = self.spec_husbandryFence
    return spec.hasCustomizableFence
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile(XMLFile xmlFile, string key)

**Arguments**

| XMLFile | xmlFile |
|---------|---------|
| string  | key     |

**Code**

```lua
function PlaceableHusbandryFence:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_husbandryFence
    if spec.fence ~ = nil then
        if xmlFile:hasProperty(key .. ".fence" ) then
            spec.fence:loadFromXMLFile(xmlFile, key .. ".fence" )
        end
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHusbandryFence:onDelete()
    local spec = self.spec_husbandryFence

    if self.fenceXmlFile ~ = nil then
        self.fenceXmlFile:delete()
        self.fenceXmlFile = nil
    end

    if spec.previewSegments ~ = nil then
        for _, segment in ipairs(spec.previewSegments) do
            segment:delete()
        end
        spec.previewSegments = nil
    end

    if spec.fence ~ = nil then
        spec.fence:delete()
        spec.fence = nil
    end

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
        spec.sharedLoadRequestId = nil
    end
end

```

### onFenceI3DLoaded

**Description**

**Definition**

> onFenceI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableHusbandryFence:onFenceI3DLoaded(i3dNode, failedReason, args)
    local spec = self.spec_husbandryFence

    local fenceI3dFilename = args.fenceI3dFilename
    local loadingTask = args.loadingTask

    if i3dNode ~ = 0 then
        local components = I3DUtil.loadI3DComponents(i3dNode)
        local i3dMappings = I3DUtil.loadI3DMapping( self.fenceXmlFile, "placeable" , components)

        spec.fence = Fence.new( self.fenceXmlFile, "placeable.fence" , fenceI3dFilename, components, i3dMappings, self )
        if spec.fence:load( self.fenceXmlFile, "placeable.fence" ) then

            -- load default fence from placeable config
            spec.fenceSegmentsData = { }

            for _, sectionKey in self.xmlFile:iterator( "placeable.husbandry.fence.sections.section" ) do
                if spec.hasCustomizableFence then
                    Logging.xmlError( self.xmlFile, "Customizable section needs to be the last section.No more section definitions allowed: %q" , sectionKey)
                    break
                end

                local sectionSegmentId = self.xmlFile:getValue(sectionKey .. "#segmentId" )
                if sectionSegmentId = = nil then
                    Logging.xmlError( self.xmlFile, "Missing segment id for %q" , sectionKey)
                        continue
                    end
                    if spec.fence:getSegmentTemplateById(sectionSegmentId) = = nil then
                        Logging.xmlError( self.xmlFile, "Segment id %q does not exist in %q" , sectionSegmentId, self.fenceXmlFile:getFilename())
                        continue
                    end

                    local isReversed = self.xmlFile:getValue(sectionKey .. "#isReversed" )
                    local customizable = self.xmlFile:getValue(sectionKey .. "#customizable" )

                    local sectionNodes = { }
                    for _, sectionNodeKey in self.xmlFile:iterator(sectionKey .. ".node" ) do
                        local node = self.xmlFile:getValue(sectionNodeKey .. "#node" , nil , self.components, self.i3dMappings)

                        table.insert(sectionNodes, node)
                    end

                    table.insert(spec.fenceSegmentsData, {
                    segmentId = sectionSegmentId,
                    nodes = sectionNodes,
                    isReversed = isReversed,
                    isCustomizable = customizable
                    } )

                    if customizable then
                        spec.hasCustomizableFence = true
                    end
                end

                spec.hasFence = #spec.fenceSegmentsData > 0

                if self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
                    self:createDefaultFence()
                end
            end

            delete(i3dNode)
        end

        if self.fenceXmlFile ~ = nil then
            self.fenceXmlFile:delete()
            self.fenceXmlFile = nil
        end

        self:finishLoadingTask(loadingTask)
    end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableHusbandryFence:onLoad(savegame)
    local spec = self.spec_husbandryFence

    spec.userIsCustomizing = false
    spec.hasCustomizableFence = nil
    spec.canBePlaced = true

    -- do not include fences in icon generation as the user can customize them
        if _G[ "g_iconGenerator" ] ~ = nil then
            return
        end

        local fenceXmlFilename = self.xmlFile:getValue( "placeable.husbandry.fence#xmlFilename" )
        if fenceXmlFilename = = nil then
            return
        end

        fenceXmlFilename = Utils.getFilename(fenceXmlFilename, self.baseDirectory)

        if fenceXmlFilename = = nil then
            Logging.xmlWarning( self.xmlFile, "No fence xml filename defined at %q" , "placeable.husbandry.fence.xmlFilename" )
            return
        end

        self.fenceXmlFile = XMLFile.load( "placeableHusbandryfence" , fenceXmlFilename, Fence.xmlSchema)
        if self.fenceXmlFile = = nil then
            Logging.xmlWarning( self.xmlFile, "Could not load fence xml file" )
            return
        end

        local fenceI3dFilename = self.fenceXmlFile:getString( "placeable.base.filename" )
        if string.isNilOrWhitespace(fenceI3dFilename) then
            Logging.xmlWarning( self.fenceXmlFile, "No fence i3d file defined at %q" , "placeable.base.filename" )
            self.fenceXmlFile:delete()
            self.fenceXmlFile = nil
            return
        end

        fenceI3dFilename = Utils.getFilename(fenceI3dFilename, self.baseDirectory)
        local loadingTask = self:createLoadingTask()
        local arguments = {
        fenceI3dFilename = fenceI3dFilename,
        loadingTask = loadingTask
        }

        spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(fenceI3dFilename, false , false , self.onFenceI3DLoaded, self , arguments)
    end

```

### onPreFinalizePlacement

**Description**

**Definition**

> onPreFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryFence:onPreFinalizePlacement()
    local spec = self.spec_husbandryFence

    if spec.fence = = nil then
        Logging.devInfo( "PlaceableHusbandryFence:onPreFinalizePlacement() fence nil, return" )
        return
    end

    if self.isServer then
        if not self.isLoadedFromSavegame then
            self:createDefaultFence()

            for _, segment in ipairs(spec.previewSegments) do
                Logging.devInfo( "PlaceableHusbandryFence.finalizeHusbandryFence:Finalize segments" )
                segment:finalize()
            end

            Logging.devInfo( "PlaceableHusbandryFence.finalizeHusbandryFence:Finalize fence" )
            spec.fence:finalize()
        end
    end
end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableHusbandryFence:onReadStream(streamId, connection)
    local spec = self.spec_husbandryFence
    if spec.fence ~ = nil then
        -- delete any existing fence
        for _, segment in ipairs _reverse(spec.fence:getSegments()) do
            segment:delete()
        end

        spec.fence:readStream(streamId, connection)

        for _, segment in ipairs(spec.fence:getSegments()) do
            segment.husbandryFenceIsCustomizable = streamReadBool(streamId)
            segment.husbandryFenceIsDefaultSegment = streamReadBool(streamId)
        end

        self:finalizeHusbandryFence()

        spec.userIsCustomizing = streamReadBool(streamId)
        if spec.userIsCustomizing then
            self:hideDefaultFence()
        end
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableHusbandryFence:onWriteStream(streamId, connection)
    local spec = self.spec_husbandryFence
    if spec.fence ~ = nil then
        spec.fence:writeStream(streamId, connection)

        for _, segment in ipairs(spec.fence:getSegments()) do
            streamWriteBool(streamId, Utils.getNoNil(segment.husbandryFenceIsCustomizable, false ))
            streamWriteBool(streamId, Utils.getNoNil(segment.husbandryFenceIsDefaultSegment, false ))
        end

        streamWriteBool(streamId, spec.userIsCustomizing)
    end
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
function PlaceableHusbandryFence.prerequisitesPresent(specializations)
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
function PlaceableHusbandryFence.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryFence )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHusbandryFence )
    SpecializationUtil.registerEventListener(placeableType, "onPreFinalizePlacement" , PlaceableHusbandryFence )
    SpecializationUtil.registerEventListener(placeableType, "onPostFinalizePlacement" , PlaceableHusbandryFence )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableHusbandryFence )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableHusbandryFence )
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
function PlaceableHusbandryFence.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getHasCustomizableFence" , PlaceableHusbandryFence.getHasCustomizableFence)
    SpecializationUtil.registerFunction(placeableType, "getFence" , PlaceableHusbandryFence.getFence)
    SpecializationUtil.registerFunction(placeableType, "getCustomizeableSectionStartAndEndPositions" , PlaceableHusbandryFence.getCustomizeableSectionStartAndEndPositions)
    SpecializationUtil.registerFunction(placeableType, "getDefaultFenceOrientation" , PlaceableHusbandryFence.getDefaultFenceOrientation)
    SpecializationUtil.registerFunction(placeableType, "getFenceContourPositions" , PlaceableHusbandryFence.getFenceContourPositions)
    SpecializationUtil.registerFunction(placeableType, "updateHusbandryFence" , PlaceableHusbandryFence.updateHusbandryFence)
    SpecializationUtil.registerFunction(placeableType, "finalizeHusbandryFence" , PlaceableHusbandryFence.finalizeHusbandryFence)
    SpecializationUtil.registerFunction(placeableType, "createDefaultFence" , PlaceableHusbandryFence.createDefaultFence)
    SpecializationUtil.registerFunction(placeableType, "deleteCustomizableSegments" , PlaceableHusbandryFence.deleteCustomizableSegments)
    SpecializationUtil.registerFunction(placeableType, "onFenceI3DLoaded" , PlaceableHusbandryFence.onFenceI3DLoaded)
    SpecializationUtil.registerFunction(placeableType, "startFenceCustomization" , PlaceableHusbandryFence.startFenceCustomization)
    SpecializationUtil.registerFunction(placeableType, "finishFenceCustomization" , PlaceableHusbandryFence.finishFenceCustomization)
    SpecializationUtil.registerFunction(placeableType, "onHusbandryFenceUserRemoved" , PlaceableHusbandryFence.onHusbandryFenceUserRemoved)
    SpecializationUtil.registerFunction(placeableType, "hideDefaultFence" , PlaceableHusbandryFence.hideDefaultFence)
    SpecializationUtil.registerFunction(placeableType, "restoreDefaultFence" , PlaceableHusbandryFence.restoreDefaultFence)
    SpecializationUtil.registerFunction(placeableType, "tryFinalizeFence" , PlaceableHusbandryFence.tryFinalizeFence)
    SpecializationUtil.registerFunction(placeableType, "getAllowFenceSegmentDeletion" , PlaceableHusbandryFence.getAllowFenceSegmentDeletion)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableHusbandryFence.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setPreviewPosition" , PlaceableHusbandryFence.setPreviewPosition)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getCanBePlacedAt" , PlaceableHusbandryFence.getCanBePlacedAt)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "createNavigationMesh" , PlaceableHusbandryFence.createNavigationMesh)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableHusbandryFence.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    Fence.registerSavegameXMLPaths(schema, basePath .. ".fence" )
    schema:setXMLSpecializationType()
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function PlaceableHusbandryFence.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.fence"
    schema:register(XMLValueType.STRING, basePath .. "#xmlFilename" , "Fence xml filename" )
    schema:register(XMLValueType.STRING, basePath .. ".sections.section(?)#segmentId" , "segment id from fence xml to use for this section" , nil , true )
        schema:register(XMLValueType.BOOL, basePath .. ".sections.section(?)#isReversed" , "Reverse segment(gate)" )
        schema:register(XMLValueType.BOOL, basePath .. ".sections.section(?)#customizable" , "User has the option to place this section manually" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".sections.section(?).node(?)#node" , "Fence node" )
        schema:setXMLSpecializationType()
    end

```

### setPreviewPosition

**Description**

**Definition**

> setPreviewPosition()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |
| any | rotX      |
| any | rotY      |
| any | rotZ      |

**Code**

```lua
function PlaceableHusbandryFence:setPreviewPosition(superFunc, x, y, z, rotX, rotY, rotZ)
    superFunc( self , x, y, z, rotX, rotY, rotZ)

    local spec = self.spec_husbandryFence
    spec.canBePlaced = true
    local canBePlaced = self:updateHusbandryFence()
    spec.canBePlaced = spec.canBePlaced and canBePlaced
end

```

### updateHusbandryFence

**Description**

**Definition**

> updateHusbandryFence()

**Return Values**

| any | success | false if a segment could not be placed or is blocked |
|-----|---------|------------------------------------------------------|

**Code**

```lua
function PlaceableHusbandryFence:updateHusbandryFence()
    local spec = self.spec_husbandryFence

    if spec.fenceSegmentsData = = nil then
        return true
    end

    spec.lastFenceError = nil

    local hitNodes = { }
    local isBlocked = false

    local segmentIndex = 1
    local segments = spec.previewSegments
    for _, section in ipairs(spec.fenceSegmentsData) do
        for nodeIndex, node in ipairs(section.nodes) do
            if nodeIndex = = #section.nodes then
                break -- no segment for last node as its just the end of the previous segment
            end

            local segment = segments[segmentIndex]
            segment:setStartPos(getWorldTranslation(node))
            segment:setEndPos(getWorldTranslation(section.nodes[nodeIndex + 1 ]))

            if not segment:updateMeshes() then
                spec.lastFenceError = segment.lastError
                return false
            end

            segment:checkOverlap(hitNodes)

            if segment:getHasBlockingOverlap( self.ownerFarmId) then
                isBlocked = true
            end

            -- do not exit loop early to still update all visible fence meshes to the current position

                segmentIndex = segmentIndex + 1
            end
        end

        for node in pairs(hitNodes) do
            DebugShapeOutline.render(node)
        end

        local hasOverlap = next(hitNodes) ~ = nil
        return not hasOverlap and not isBlocked
    end

```