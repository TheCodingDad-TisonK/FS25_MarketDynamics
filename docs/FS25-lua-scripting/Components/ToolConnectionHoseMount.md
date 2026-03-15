## ToolConnectionHoseMount

**Description**

> Class to handle the shared tool connection hose mountings

**Functions**

- [addHoseTarget](#addhosetarget)
- [createToolConnectionHoses](#createtoolconnectionhoses)
- [delete](#delete)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onFinished](#onfinished)
- [onI3DLoaded](#oni3dloaded)
- [registerExternalXMLPaths](#registerexternalxmlpaths)
- [setCallback](#setcallback)
- [setLength](#setlength)
- [setLinkNode](#setlinknode)
- [setReferenceTargets](#setreferencetargets)

### addHoseTarget

**Description**

**Definition**

> addHoseTarget()

**Arguments**

| any | node         |
|-----|--------------|
| any | sourceTarget |
| any | newType      |

**Code**

```lua
function ToolConnectionHoseMount:addHoseTarget(node, sourceTarget, newType)
    local spec = self.vehicle.spec_connectionHoses

    local hoseTarget = { }
    hoseTarget.node = node
    hoseTarget.attacherJointIndices = sourceTarget.attacherJointIndices
    hoseTarget.type = newType
    hoseTarget.straighteningFactor = sourceTarget.straighteningFactor
    hoseTarget.adapterName = sourceTarget.adapterName
    hoseTarget.adapter = { }
    hoseTarget.adapter.node = node
    hoseTarget.adapter.refNode = node
    hoseTarget.objectChanges = { }

    table.insert(spec.targetNodes, hoseTarget)
    hoseTarget.index = #spec.targetNodes

    if spec.targetNodesByType[hoseTarget.type ] = = nil then
        spec.targetNodesByType[hoseTarget.type ] = { }
    end
    table.insert(spec.targetNodesByType[hoseTarget.type ], hoseTarget)

    return hoseTarget.index
end

```

### createToolConnectionHoses

**Description**

**Definition**

> createToolConnectionHoses()

**Code**

```lua
function ToolConnectionHoseMount:createToolConnectionHoses()
    local spec = self.vehicle.spec_connectionHoses

    for _, target in ipairs( self.targetNodes) do
        local frontTargetIndex = self:addHoseTarget(target.frontNode, self.startTarget, target.typeName)
        local backTargetIndex = self:addHoseTarget(target.backNode, self.endTarget, target.typeName)

        local newToolConnectionHose = { }
        newToolConnectionHose.startTargetNodeIndex = frontTargetIndex
        newToolConnectionHose.endTargetNodeIndex = backTargetIndex
        newToolConnectionHose.mountingNode = self.node

        newToolConnectionHose.moveNodes = target.moveNodes
        newToolConnectionHose.additionalHose = target.createHose
        newToolConnectionHose.additionalHoseOffset = target.hoseOffset

        newToolConnectionHose.parentToolConnectionHose = self.parentToolConnectionHose

        newToolConnectionHose.objectChanges = { }
        newToolConnectionHose.objectChangesTarget = self.vehicle

        newToolConnectionHose.additionalHoses = self.additionalHoses

        setVisibility( self.node, false )

        table.insert(spec.toolConnectorHoses, newToolConnectionHose)
        spec.targetNodeToToolConnection[newToolConnectionHose.startTargetNodeIndex] = newToolConnectionHose
        spec.targetNodeToToolConnection[newToolConnectionHose.endTargetNodeIndex] = newToolConnectionHose
    end
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function ToolConnectionHoseMount:delete()
    if self.xmlFile ~ = nil then
        self.xmlFile:delete()
        self.xmlFile = nil
    end

    if self.node ~ = nil then
        delete( self.node)
        self.node = nil
    end

    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
        self.sharedLoadRequestId = nil
    end
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFilename   |
|-----|---------------|
| any | baseDirectory |

**Code**

```lua
function ToolConnectionHoseMount:loadFromXML(xmlFilename, baseDirectory)
    if self.startTarget = = nil or self.endTarget = = nil then
        Logging.warning( "Missing start or end target for tool connection hose mount!" )
        self:onFinished( false )
        return false
    end

    if self.linkNode = = nil then
        Logging.warning( "Missing link node for tool connection hose mount!" )
            self:onFinished( false )
            return false
        end

        self.xmlFile = XMLFile.loadIfExists( "toolConnectionHoseMount" , xmlFilename, ToolConnectionHoseMount.xmlSchema)
        if self.xmlFile = = nil then
            Logging.warning( "Failed to load tool connection hose mount XML file: %s" , xmlFilename)
            self:onFinished( false )
            return false
        end

        local filename = self.xmlFile:getValue( "toolConnectionHoseMount.filename" )
        if filename = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing toolConnectionHoseMount i3d filename!" )
            self.xmlFile:delete()
            self.xmlFile = nil

            self:onFinished( false )
            return false
        end

        self.filename = Utils.getFilename(filename, baseDirectory)

        if self.vehicle ~ = nil and self.vehicle.loadSubSharedI3DFile ~ = nil then
            self.sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( self.filename, false , false , self.onI3DLoaded, self , nil )
        else
                self.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync( self.filename, false , false , self.onI3DLoaded, self , nil )
            end

            return true
        end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | customMt |

**Code**

```lua
function ToolConnectionHoseMount.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or ToolConnectionHoseMount _mt)

    self.vehicle = vehicle

    self.components = { }
    self.i3dMappings = { }

    return self
end

```

### onFinished

**Description**

**Definition**

> onFinished()

**Arguments**

| any | success |
|-----|---------|

**Code**

```lua
function ToolConnectionHoseMount:onFinished(success)
    if self.callback ~ = nil then
        if self.callbackTarget ~ = nil then
            self.callback( self.callbackTarget, success)
        else
                self.callback(success)
            end
        end
    end

```

### onI3DLoaded

**Description**

**Definition**

> onI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function ToolConnectionHoseMount:onI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        I3DUtil.loadI3DComponents(i3dNode, self.components)
        I3DUtil.loadI3DMapping( self.xmlFile, "toolConnectionHoseMount" , self.components, self.i3dMappings)

        self.node = self.xmlFile:getValue( "toolConnectionHoseMount.rootNode#node" , "0" , self.components, self.i3dMappings)

        if self.node ~ = nil then
            self.length = self.xmlFile:getValue( "toolConnectionHoseMount.rootNode#length" , 3 )

            self.targetNodes = { }
            self.xmlFile:iterate( "toolConnectionHoseMount.target" , function (_, baseKey)
                local target = { }
                target.backNode = self.xmlFile:getValue(baseKey .. "#backNode" , nil , self.components, self.i3dMappings)
                target.frontNode = self.xmlFile:getValue(baseKey .. "#frontNode" , nil , self.components, self.i3dMappings)

                if target.backNode ~ = nil and target.frontNode ~ = nil then
                    target.typeName = self.xmlFile:getValue(baseKey .. "#typeName" )
                    if target.typeName ~ = nil then
                        target.createHose = self.xmlFile:getValue(baseKey .. "#createHose" , true )
                        target.moveNodes = self.xmlFile:getValue(baseKey .. "#moveNodes" , true )
                        target.hoseOffset = self.xmlFile:getValue(baseKey .. "#hoseOffset" , 0 )

                        table.insert( self.targetNodes, target)
                    else
                            Logging.xmlWarning( self.xmlFile, "Missing type name for tool connection hose mount target at '%s'!" , baseKey)
                            end
                        else
                                Logging.xmlWarning( self.xmlFile, "Missing back or front node for tool connection hose mount target at '%s'!" , baseKey)
                                end
                            end )

                            self.additionalHoses = { }
                            self.xmlFile:iterate( "toolConnectionHoseMount.hose" , function (_, baseKey)
                                local additionalHose = { }
                                additionalHose.startNode = self.xmlFile:getValue(baseKey .. "#startNode" , nil , self.components, self.i3dMappings)
                                additionalHose.endNode = self.xmlFile:getValue(baseKey .. "#endNode" , nil , self.components, self.i3dMappings)

                                if additionalHose.startNode ~ = nil and additionalHose.endNode ~ = nil then
                                    table.insert( self.additionalHoses, additionalHose)
                                else
                                        Logging.xmlWarning( self.xmlFile, "Missing start or end node for tool connection hose mount hose at '%s'!" , baseKey)
                                    end
                                end )

                                self.adjustNodes = { }
                                self.xmlFile:iterate( "toolConnectionHoseMount.adjustNodes" , function (_, baseKey)
                                    local adjustNode = { }
                                    adjustNode.node = self.xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
                                    if adjustNode.node ~ = nil then
                                        adjustNode.startTranslation = { getTranslation(adjustNode.node) }
                                        table.insert( self.adjustNodes, adjustNode)
                                    end
                                end )

                                self.scaleNodes = { }
                                self.xmlFile:iterate( "toolConnectionHoseMount.scaleNodes" , function (_, baseKey)
                                    local scaleNode = { }
                                    scaleNode.node = self.xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
                                    if scaleNode.node ~ = nil then
                                        table.insert( self.scaleNodes, scaleNode)
                                    end
                                end )

                                link( self.linkNode, self.node)
                                setTranslation( self.node, self.translation[ 1 ], self.translation[ 2 ], self.translation[ 3 ])
                                setRotation( self.node, self.rotation[ 1 ], self.rotation[ 2 ], self.rotation[ 3 ])

                                self:createToolConnectionHoses()

                                if self.lengthToSet ~ = nil then
                                    self:setLength( self.lengthToSet)
                                end
                            end

                            delete(i3dNode)
                        end

                        self.xmlFile:delete()
                        self.xmlFile = nil
                        self:onFinished( self.node ~ = nil )
                    end

```

### registerExternalXMLPaths

**Description**

**Definition**

> registerExternalXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function ToolConnectionHoseMount.registerExternalXMLPaths(schema)
    schema:register(XMLValueType.STRING, "toolConnectionHoseMount.filename" , "Path to i3d file" , nil , true )
    schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.rootNode#node" , "Node index" , "0" )
    schema:register(XMLValueType.FLOAT, "toolConnectionHoseMount.rootNode#length" , "Length of the mount inside the file" , 3 )

    schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.target(?)#backNode" , "Node for the back tool to connection to" )
        schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.target(?)#frontNode" , "Node for the front tool to connection to" )
            schema:register(XMLValueType.STRING, "toolConnectionHoseMount.target(?)#typeName" , "Name of the hose type" )
            schema:register(XMLValueType.BOOL, "toolConnectionHoseMount.target(?)#createHose" , "Create local hose between the front and back node" )
            schema:register(XMLValueType.BOOL, "toolConnectionHoseMount.target(?)#moveNodes" , "Move nodes up by the radius of the hose" )
            schema:register(XMLValueType.FLOAT, "toolConnectionHoseMount.target(?)#hoseOffset" , "Offset for the hose creation" , 0 )

                schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.hose(?)#startNode" , "Start node of the local hose" )
                schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.hose(?)#endNode" , "End node of the local hose" )

                schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.adjustNodes(?)#node" , "Node that is adjusted to the length of the mount" )

                schema:register(XMLValueType.NODE_INDEX, "toolConnectionHoseMount.scaleNodes(?)#node" , "Node that is scaled based on the length of the mount" )

                I3DUtil.registerI3dMappingXMLPaths(schema, "toolConnectionHoseMount" )
            end

```

### setCallback

**Description**

**Definition**

> setCallback()

**Arguments**

| any | callback       |
|-----|----------------|
| any | callbackTarget |

**Code**

```lua
function ToolConnectionHoseMount:setCallback(callback, callbackTarget)
    self.callback = callback
    self.callbackTarget = callbackTarget
end

```

### setLength

**Description**

**Definition**

> setLength()

**Arguments**

| any | length |
|-----|--------|

**Code**

```lua
function ToolConnectionHoseMount:setLength(length)
    if self.node = = nil then
        self.lengthToSet = length
        return
    else
            self.lengthToSet = nil
        end

        local scale = length / self.length

        for _, adjustNode in ipairs( self.adjustNodes) do
            setTranslation(adjustNode.node, adjustNode.startTranslation[ 1 ], adjustNode.startTranslation[ 2 ], adjustNode.startTranslation[ 3 ] * scale)
        end

        for _, scaleNode in ipairs( self.scaleNodes) do
            setScale(scaleNode.node, 1 , 1 , scale)
        end
    end

```

### setLinkNode

**Description**

**Definition**

> setLinkNode()

**Arguments**

| any | linkNode |
|-----|----------|
| any | x        |
| any | y        |
| any | z        |
| any | rx       |
| any | ry       |
| any | rz       |

**Code**

```lua
function ToolConnectionHoseMount:setLinkNode(linkNode, x, y, z, rx, ry, rz)
    self.linkNode = linkNode
    self.translation = { x or 0 , y or 0 , z or 0 }
    self.rotation = { rx or 0 , ry or 0 , rz or 0 }
end

```

### setReferenceTargets

**Description**

**Definition**

> setReferenceTargets()

**Arguments**

| any | startTarget |
|-----|-------------|
| any | endTarget   |

**Code**

```lua
function ToolConnectionHoseMount:setReferenceTargets(startTarget, endTarget)
    self.startTarget = startTarget
    self.endTarget = endTarget

    local toolConnectionHose = self.vehicle.spec_connectionHoses.targetNodeToToolConnection[startTarget.index]
    self.parentToolConnectionHose = toolConnectionHose
end

```