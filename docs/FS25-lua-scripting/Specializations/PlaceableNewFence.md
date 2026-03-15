## PlaceableNewFence

**Description**

> Specialization for placeables

**Functions**

- [addPickingNodesForSegment](#addpickingnodesforsegment)
- [collectPickObjects](#collectpickobjects)
- [getAllowExtendingOnly](#getallowextendingonly)
- [getDestructionMethod](#getdestructionmethod)
- [getHasParallelSnapping](#gethasparallelsnapping)
- [getIsPanelLengthFixed](#getispanellengthfixed)
- [getMaxCornerAngle](#getmaxcornerangle)
- [getMaxVerticalAngle](#getmaxverticalangle)
- [getMaxVerticalGateAngle](#getmaxverticalgateangle)
- [getNumSequments](#getnumsequments)
- [getPanelLength](#getpanellength)
- [getSegmentLength](#getsegmentlength)
- [getSnapCheckDistance](#getsnapcheckdistance)
- [getSnapDistance](#getsnapdistance)
- [getSupportsParallelSnapping](#getsupportsparallelsnapping)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [performNodeDestruction](#performnodedestruction)
- [prerequisitesPresent](#prerequisitespresent)
- [previewNodeDestructionNodes](#previewnodedestructionnodes)
- [recursivelyAddPickingNodes](#recursivelyaddpickingnodes)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [removePickingNodesForSegment](#removepickingnodesforsegment)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)
- [updateDirtyAreas](#updatedirtyareas)

### addPickingNodesForSegment

**Description**

**Definition**

> addPickingNodesForSegment()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableNewFence:addPickingNodesForSegment(segment)
    if segment = = self.spec_newFence.previewSegment then
        return
    end

    if segment.group ~ = nil then
        local objects = { }
        self:recursivelyAddPickingNodes(objects, segment.group)

        for i = 1 , #objects do
            g_currentMission:addNodeObject(objects[i], self )
        end
    end

    -- Reset
    self.overlayColorNodes = nil
end

```

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableNewFence:collectPickObjects(superFunc, node)
    ---Default picking objects is disabled
end

```

### getAllowExtendingOnly

**Description**

**Definition**

> getAllowExtendingOnly()

**Code**

```lua
function PlaceableNewFence:getAllowExtendingOnly()
    return self.spec_newFence.allowExtendingOnly
end

```

### getDestructionMethod

**Description**

> Deletion is in pieces so not instantly

**Definition**

> getDestructionMethod()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableNewFence:getDestructionMethod(superFunc)
    return Placeable.DESTRUCTION.PER_NODE
end

```

### getHasParallelSnapping

**Description**

**Definition**

> getHasParallelSnapping()

**Code**

```lua
function PlaceableNewFence:getHasParallelSnapping()
    return false
end

```

### getIsPanelLengthFixed

**Description**

**Definition**

> getIsPanelLengthFixed()

**Code**

```lua
function PlaceableNewFence:getIsPanelLengthFixed()
    return self.spec_newFence.panelLengthFixed
end

```

### getMaxCornerAngle

**Description**

**Definition**

> getMaxCornerAngle()

**Code**

```lua
function PlaceableNewFence:getMaxCornerAngle()
    return self.spec_newFence.maxCornerAngle
end

```

### getMaxVerticalAngle

**Description**

**Definition**

> getMaxVerticalAngle()

**Code**

```lua
function PlaceableNewFence:getMaxVerticalAngle()
    local spec = self.spec_newFence
    return spec.maxVerticalAngle
end

```

### getMaxVerticalGateAngle

**Description**

**Definition**

> getMaxVerticalGateAngle()

**Code**

```lua
function PlaceableNewFence:getMaxVerticalGateAngle()
    local spec = self.spec_newFence
    return spec.maxVerticalGateAngle
end

```

### getNumSequments

**Description**

**Definition**

> getNumSequments()

**Code**

```lua
function PlaceableNewFence:getNumSequments()
    local spec = self.spec_newFence
    return spec.fence:getNumSegments()
end

```

### getPanelLength

**Description**

**Definition**

> getPanelLength()

**Code**

```lua
function PlaceableNewFence:getPanelLength()
    return self.spec_newFence.panelLength
end

```

### getSegmentLength

**Description**

> Get the length of a segment

**Definition**

> getSegmentLength()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableNewFence:getSegmentLength(segment)
    return MathUtil.getPointPointDistance(segment.x1, segment.z1, segment.x2, segment.z2)
end

```

### getSnapCheckDistance

**Description**

**Definition**

> getSnapCheckDistance()

**Code**

```lua
function PlaceableNewFence:getSnapCheckDistance()
    return self.spec_newFence.snapCheckDistance
end

```

### getSnapDistance

**Description**

**Definition**

> getSnapDistance()

**Code**

```lua
function PlaceableNewFence:getSnapDistance()
    return self.spec_newFence.snapDistance
end

```

### getSupportsParallelSnapping

**Description**

**Definition**

> getSupportsParallelSnapping()

**Code**

```lua
function PlaceableNewFence:getSupportsParallelSnapping()
    return false
    -- return self.spec_newFence.supportsParallelSnapping
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableNewFence:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_newFence
    local fence = spec.fence

    if spec.existingPlaceableInstance ~ = nil then
        fence = spec.existingPlaceableInstance:getFence()
        Logging.info( "Merging savegame data into existing fence instance" )
    end

    fence:loadFromXMLFile(xmlFile, key)
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableNewFence:onDelete()
    local spec = self.spec_newFence

    if spec.fence ~ = nil then
        spec.fence:delete()
        spec.fence = nil
    end
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
function PlaceableNewFence:onLoad(savegame)
    local spec = self.spec_newFence
    local xmlFile = self.xmlFile

    local i3dFilename = xmlFile:getValue( "placeable.base.filename" )
    if string.isNilOrWhitespace(i3dFilename) then
        Logging.xmlError(xmlFile, "Unable to load fence, no i3d filename given at 'placeable.base.filename'!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    spec.existingPlaceableInstance = g_currentMission.placeableSystem:getExistingPlaceableByXMLFilename( self.configFileName)
    if spec.existingPlaceableInstance ~ = nil then
        Logging.info( "Instance of fence '%s' found.Starting merge process .. ." , self.configFileName)
        return
    end

    i3dFilename = Utils.getFilename(i3dFilename, self.baseDirectory)

    spec.segmentsNode = createTransformGroup( "segments" )
    link( self.rootNode, spec.segmentsNode)
    spec.fence = Fence.new(xmlFile, "placeable.fence" , i3dFilename, self.components, self.i3dMappings, self , spec.segmentsNode)

    if not spec.fence:load(xmlFile, "placeable.fence" ) then
        Logging.xmlError(xmlFile, "Unable to load fence!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    if self:getIsPreplaced() then
        local preplacedParent = getParent( self.rootNode)
        if preplacedParent ~ = 0 then
            local fenceSegmentIndex = getUserAttribute(preplacedParent, "fenceSegments" )
            local fenceSegmentsNode = I3DUtil.indexToObject(preplacedParent, fenceSegmentIndex)
            if fenceSegmentsNode ~ = nil then
                for i = getNumOfChildren(fenceSegmentsNode) - 1 , 0 , - 1 do
                    delete(getChildAt(fenceSegmentsNode, i))
                end
            end

            local staticFenceIndex = getUserAttribute(preplacedParent, "staticFence" )
            local staticFenceNode = I3DUtil.indexToObject(preplacedParent, staticFenceIndex)
            if staticFenceNode ~ = nil then
                for i = getNumOfChildren(staticFenceNode) - 1 , 0 , - 1 do
                    delete(getChildAt(staticFenceNode, i))
                end
            end
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
function PlaceableNewFence:onReadStream(streamId, connection)
    local spec = self.spec_newFence

    spec.fence:readStream(streamId, connection)
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PlaceableNewFence:onUpdate(dt)
    local spec = self.spec_newFence
    if spec.fence ~ = nil then
        spec.fence:update(dt)
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
function PlaceableNewFence:onWriteStream(streamId, connection)
    local spec = self.spec_newFence

    spec.fence:writeStream(streamId, connection)
end

```

### performNodeDestruction

**Description**

**Definition**

> performNodeDestruction()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableNewFence:performNodeDestruction(superFunc, node)
    local destroyedNode = self:deletePanel(node)
    local destroyPlaceable = self:getNumSequments() = = 0
    return destroyedNode, destroyPlaceable
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
function PlaceableNewFence.prerequisitesPresent(specializations)
    return true
end

```

### previewNodeDestructionNodes

**Description**

**Definition**

> previewNodeDestructionNodes()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableNewFence:previewNodeDestructionNodes(superFunc, node)
    return self:getNodesToDeleteForPanel(node)
end

```

### recursivelyAddPickingNodes

**Description**

**Definition**

> recursivelyAddPickingNodes()

**Arguments**

| any | objects |
|-----|---------|
| any | node    |

**Code**

```lua
function PlaceableNewFence:recursivelyAddPickingNodes(objects, node)
    if getRigidBodyType(node) ~ = RigidBodyType.NONE then
        table.insert(objects, node)
    end

    local numChildren = getNumOfChildren(node)
    for i = 1 , numChildren do
        self:recursivelyAddPickingNodes(objects, getChildAt(node, i - 1 ))
    end
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
function PlaceableNewFence.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableNewFence )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableNewFence )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableNewFence )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableNewFence )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableNewFence )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableNewFence )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableNewFence.registerEvents(placeableType)
    SpecializationUtil.registerEvent(placeableType, "onCreateSegment" )
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
function PlaceableNewFence.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getFence" , PlaceableNewFence.getFence)
    SpecializationUtil.registerFunction(placeableType, "onSegmentCreated" , PlaceableNewFence.onSegmentCreated)
    SpecializationUtil.registerFunction(placeableType, "getNumSequments" , PlaceableNewFence.getNumSequments)
    SpecializationUtil.registerFunction(placeableType, "getPanelLength" , PlaceableNewFence.getPanelLength)
    SpecializationUtil.registerFunction(placeableType, "getIsPanelLengthFixed" , PlaceableNewFence.getIsPanelLengthFixed)
    SpecializationUtil.registerFunction(placeableType, "updateDirtyAreas" , PlaceableNewFence.updateDirtyAreas)
    SpecializationUtil.registerFunction(placeableType, "getSupportsParallelSnapping" , PlaceableNewFence.getSupportsParallelSnapping)
    SpecializationUtil.registerFunction(placeableType, "getSnapDistance" , PlaceableNewFence.getSnapDistance)
    SpecializationUtil.registerFunction(placeableType, "getSnapAngle" , PlaceableNewFence.getSnapAngle)
    SpecializationUtil.registerFunction(placeableType, "getSnapCheckDistance" , PlaceableNewFence.getSnapCheckDistance)
    SpecializationUtil.registerFunction(placeableType, "getAllowExtendingOnly" , PlaceableNewFence.getAllowExtendingOnly)
    SpecializationUtil.registerFunction(placeableType, "getMaxCornerAngle" , PlaceableNewFence.getMaxCornerAngle)
    SpecializationUtil.registerFunction(placeableType, "getHasParallelSnapping" , PlaceableNewFence.getHasParallelSnapping)
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
function PlaceableNewFence.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getIsOnFarmland" , PlaceableNewFence.getIsOnFarmland)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableNewFence.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getDestructionMethod" , PlaceableNewFence.getDestructionMethod)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "performNodeDestruction" , PlaceableNewFence.performNodeDestruction)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "previewNodeDestructionNodes" , PlaceableNewFence.previewNodeDestructionNodes)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableNewFence.setOwnerFarmId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getOwnerFarmId" , PlaceableNewFence.getOwnerFarmId)
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
function PlaceableNewFence.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    Fence.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType()
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
function PlaceableNewFence.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    Fence.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType()
end

```

### removePickingNodesForSegment

**Description**

**Definition**

> removePickingNodesForSegment()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableNewFence:removePickingNodesForSegment(segment)
    if segment = = self.spec_newFence.previewSegment then
        return
    end

    if segment.group ~ = nil then
        local objects = { }
        self:recursivelyAddPickingNodes(objects, segment.group)

        for i = 1 , #objects do
            g_currentMission:removeNodeObject(objects[i])
        end
    end
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function PlaceableNewFence:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_newFence

    spec.fence:saveToXMLFile(xmlFile, key, usedModNames)
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | ownerFarmId |
| any | noEventSend |

**Code**

```lua
function PlaceableNewFence:setOwnerFarmId(superFunc, ownerFarmId, noEventSend)
    -- we never set the farmid for a fence.It is always based on the farmland
    end

```

### updateDirtyAreas

**Description**

> Sets collision map and AI navigationmap dirty for AABB of given line

**Definition**

> updateDirtyAreas()

**Arguments**

| any | x1 |
|-----|----|
| any | z1 |
| any | x2 |
| any | z2 |

**Code**

```lua
function PlaceableNewFence:updateDirtyAreas(x1, z1, x2, z2)
    local minX = math.min(x1, x2)
    local maxX = math.max(x1, x2)
    local minZ = math.min(z1, z2)
    local maxZ = math.max(z1, z2)

    g_densityMapHeightManager:setCollisionMapAreaDirty(minX, minZ, maxX, maxZ, true )
    g_currentMission.aiSystem:setAreaDirty(minX, maxX, minZ, maxZ)
end

```