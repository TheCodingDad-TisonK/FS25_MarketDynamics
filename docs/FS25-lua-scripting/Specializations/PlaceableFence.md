## PlaceableFence

**Description**

> Specialization for placeables

**Functions**

- [addPickingNodesForSegment](#addpickingnodesforsegment)
- [addSegment](#addsegment)
- [addSegmentShapesToUpdate](#addsegmentshapestoupdate)
- [collectPickObjects](#collectpickobjects)
- [createSegment](#createsegment)
- [deletePanel](#deletepanel)
- [deleteSegment](#deletesegment)
- [doDeletePanel](#dodeletepanel)
- [fakeRandomValueForPosition](#fakerandomvalueforposition)
- [findRaycastInfo](#findraycastinfo)
- [generateSegmentPoles](#generatesegmentpoles)
- [getAllowExtendingOnly](#getallowextendingonly)
- [getBoundingCheckWidth](#getboundingcheckwidth)
- [getDestructionMethod](#getdestructionmethod)
- [getGate](#getgate)
- [getHasParallelSnapping](#gethasparallelsnapping)
- [getIsPanelLengthFixed](#getispanellengthfixed)
- [getMaxCornerAngle](#getmaxcornerangle)
- [getMaxVerticalAngle](#getmaxverticalangle)
- [getMaxVerticalAngleAndYForPreview](#getmaxverticalangleandyforpreview)
- [getMaxVerticalGateAngle](#getmaxverticalgateangle)
- [getNodesToDeleteForPanel](#getnodestodeleteforpanel)
- [getNumSequments](#getnumsequments)
- [getPanelLength](#getpanellength)
- [getPoleNear](#getpolenear)
- [getPoleNearOverlapCallback](#getpolenearoverlapcallback)
- [getPolePosition](#getpoleposition)
- [getPoleShapeForPreview](#getpoleshapeforpreview)
- [getPreviewSegment](#getpreviewsegment)
- [getSegment](#getsegment)
- [getSegmentLength](#getsegmentlength)
- [getSnapCheckDistance](#getsnapcheckdistance)
- [getSnapDistance](#getsnapdistance)
- [getSupportsParallelSnapping](#getsupportsparallelsnapping)
- [isPoleInAnySegment](#ispoleinanysegment)
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
- [setPreviewSegment](#setpreviewsegment)
- [updateDirtyAreas](#updatedirtyareas)
- [updateSegmentShapes](#updatesegmentshapes)
- [updateSegmentUpdateQueue](#updatesegmentupdatequeue)

### addPickingNodesForSegment

**Description**

**Definition**

> addPickingNodesForSegment()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableFence:addPickingNodesForSegment(segment)
    if segment = = self.spec_fence.previewSegment then
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

### addSegment

**Description**

**Definition**

> addSegment()

**Arguments**

| any | segment |
|-----|---------|
| any | sync    |

**Code**

```lua
function PlaceableFence:addSegment(segment, sync)
    local spec = self.spec_fence
    spec.segments[#spec.segments + 1 ] = segment

    self:generateSegmentPoles(segment, sync)
end

```

### addSegmentShapesToUpdate

**Description**

**Definition**

> addSegmentShapesToUpdate()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableFence:addSegmentShapesToUpdate(segment)
    local spec = self.spec_fence
    spec.segmentsToUpdate[#spec.segmentsToUpdate + 1 ] = segment

    self:raiseActive()
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
function PlaceableFence:collectPickObjects(superFunc, node)
    ---Default picking objects is disabled
end

```

### createSegment

**Description**

**Definition**

> createSegment()

**Arguments**

| any | x1          |
|-----|-------------|
| any | z1          |
| any | x2          |
| any | z2          |
| any | renderFirst |
| any | gateIndex   |

**Code**

```lua
function PlaceableFence:createSegment(x1, z1, x2, z2, renderFirst, gateIndex)
    return {
    x1 = x1,
    z1 = z1,
    x2 = x2,
    z2 = z2,
    renderFirst = renderFirst, -- whether to render the first pole
    renderLast = true ,
    gateIndex = gateIndex,
    poles = { } , -- list of pole positions
    }
end

```

### deletePanel

**Description**

> Called by server or client directly on click

**Definition**

> deletePanel()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PlaceableFence:deletePanel(node)
    if node = = nil or node = = 0 or getCollisionFilterMask(node) = = 0 then
        return
    end

    local spec = self.spec_fence
    local panel, _, segment, _, poleIndex = self:findRaycastInfo(node)
    if panel = = nil then
        return nil
    end

    local segmentIndex = 1
    for i = 1 , #spec.segments do
        if spec.segments[i] = = segment then
            segmentIndex = i
            break
        end
    end

    if self.isServer then
        self:doDeletePanel(segment, segmentIndex, poleIndex)

        g_server:broadcastEvent( PlaceableFenceRemoveSegmentEvent.new( self , segmentIndex, poleIndex), false )
    else
            -- Set collision mask so we cannot hit it again while it is in transport
                setCollisionFilterMask(node, 0 )

                -- Request change on server
                g_client:getServerConnection():sendEvent( PlaceableFenceRemoveSegmentEvent.new( self , segmentIndex, poleIndex))
            end

            return true
        end

```

### deleteSegment

**Description**

> Delete a segment with its nodes.

**Definition**

> deleteSegment()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableFence:deleteSegment(segment)
    local spec = self.spec_fence
    if segment.animatedObject ~ = nil then
        segment.animatedObject:delete()
        segment.animatedObject = nil
    end

    if segment.group ~ = nil then
        delete(segment.group)
        segment.group = nil
    end

    if segment.pendingUpdateTimer ~ = nil then
        segment.pendingUpdateTimer:delete()
        segment.pendingUpdateTimer = nil
    end

    if self.cellIdToSegments ~ = nil then
        local terrainDeformationSyncer = g_currentMission.terrainDeformationSyncer
        for cellId, segments in pairs( self.cellIdToSegments) do
            segments[segment] = nil
            if next(segments) = = nil then
                self.cellIdToSegments[cellId] = nil

                local cellX, cellZ = terrainDeformationSyncer:getCellIndicesById(cellId)
                terrainDeformationSyncer:removeCellUpdateListener( self , cellX, cellZ)
            end
        end
    end

    table.removeElement(spec.segments, segment)

    self:updateDirtyAreas(segment.x1, segment.z1, segment.x2, segment.z2)
end

```

### doDeletePanel

**Description**

**Definition**

> doDeletePanel()

**Arguments**

| any | segment      |
|-----|--------------|
| any | segmentIndex |
| any | poleIndex    |

**Code**

```lua
function PlaceableFence:doDeletePanel(segment, segmentIndex, poleIndex)
    if segment = = nil or poleIndex > #segment.poles then
        return
    end

    if segment.pendingUpdateTimer ~ = nil then
        segment.pendingUpdateTimer:delete()
        segment.pendingUpdateTimer = nil
    end

    if self.cellIdToSegments ~ = nil then
        local terrainDeformationSyncer = g_currentMission.terrainDeformationSyncer
        for cellId, segments in pairs( self.cellIdToSegments) do
            segments[segment] = nil
            if next(segments) = = nil then
                self.cellIdToSegments[cellId] = nil

                local cellX, cellZ = terrainDeformationSyncer:getCellIndicesById(cellId)
                terrainDeformationSyncer:removeCellUpdateListener( self , cellX, cellZ)
            end
        end
    end

    -- We mark any poles we delete as deleted when they might cause a
    -- non-rendered pole in another segment.
    local deletedPoles = { }

    local x1OrigSeg, x2OrigSeg, z1OrigSeg, z2OrigSeg = segment.x1, segment.x2, segment.z1, segment.z2

    local segmentSizeChanged = false

    -- Start of segment:delete the pole by moving segment start to next pole
    if poleIndex = = 1 then
        if segment.renderFirst then
            deletedPoles[#deletedPoles + 1 ] = segment.poles[ 1 ]
            deletedPoles[#deletedPoles + 1 ] = segment.poles[ 2 ]
        end

        -- If there is only 1 more pole, delete
        if poleIndex + 2 = = #segment.poles - 1 then
            if segment.renderLast then
                deletedPoles[#deletedPoles + 1 ] = segment.poles[ 3 ]
                deletedPoles[#deletedPoles + 1 ] = segment.poles[ 4 ]
            end

            self:removePickingNodesForSegment(segment)
            self:deleteSegment(segment)
        else
                segment.x1 = segment.poles[ 3 ]
                segment.z1 = segment.poles[ 4 ]

                segmentSizeChanged = true
                segment.renderFirst = true
            end

            -- Next pole is last in line(this is the last panel)
        elseif poleIndex + 2 = = #segment.poles - 1 then
                -- Shorten the segment

                if segment.renderLast then
                    deletedPoles[#deletedPoles + 1 ] = segment.poles[#segment.poles - 1 ]
                    deletedPoles[#deletedPoles + 1 ] = segment.poles[#segment.poles]
                end

                segment.x2 = segment.poles[#segment.poles - 3 ]
                segment.z2 = segment.poles[#segment.poles - 2 ]

                segment.renderLast = true

                segmentSizeChanged = true
            else
                    -- Create second part
                    local newSegment = self:createSegment(segment.poles[poleIndex + 2 ], segment.poles[poleIndex + 3 ], segment.x2, segment.z2, true , nil )
                    newSegment.renderLast = segment.renderLast -- copy
                    newSegment.renderFirst = true -- we moved the start to an existing pole, so enable this pole

                    -- Adjust first part
                    segment.x2 = segment.poles[poleIndex]
                    segment.z2 = segment.poles[poleIndex + 1 ]
                    segment.renderLast = true

                    self:addSegment(newSegment)
                    self:registerTerrainHeightChangeCallbacks(newSegment)
                    segmentSizeChanged = true

                    -- Note:no poles were removed as only the panel visually is gone.
                end

                -- Do not update gates! They cannot resize anyway
                if segmentSizeChanged then
                    self:generateSegmentPoles(segment, true )
                    self:registerTerrainHeightChangeCallbacks(segment)
                end

                -- For any pole that has changed, find if it matches the start or end of another segment
                -- If it does mark that segment as needing to render the pole again.Only the first segment we find though
                for i = 1 , #deletedPoles, 2 do
                    local x, z = deletedPoles[i], deletedPoles[i + 1 ]
                    local neighborSegment, isStart = self:isPoleInAnySegment(x, z, segment)

                    if neighborSegment ~ = nil then
                        if isStart then
                            neighborSegment.renderFirst = true
                        else
                                neighborSegment.renderLast = true
                            end

                            self:generateSegmentPoles(neighborSegment, true )
                        end
                    end

                    -- We need to update areas where panels are not anymore
                    self:updateDirtyAreas(x1OrigSeg, z1OrigSeg, x2OrigSeg, z2OrigSeg)

                    return true
                end

```

### fakeRandomValueForPosition

**Description**

> Generate a value [0,1] for a position that is always consistent but highly affected by the position

**Definition**

> fakeRandomValueForPosition()

**Arguments**

| any | x |
|-----|---|
| any | y |
| any | z |
| any | n |

**Code**

```lua
function PlaceableFence:fakeRandomValueForPosition(x, y, z, n)
    local alpha = (x * 0.13 + z * 0.23 ) % 1

    if n = = nil then
        return alpha
    end

    -- Integer from 1 to n(inclusive)
    return math.floor(alpha * (n - 1 ) + 0.5 ) + 1
end

```

### findRaycastInfo

**Description**

**Definition**

> findRaycastInfo()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PlaceableFence:findRaycastInfo(node)
    local spec = self.spec_fence
    -- Raycasts hit collisions.Find the visual
    -- This collision could be a pole or a panel! If it is the pole, just return the pole info

    local collision = node
    local panel = getParent(collision)

    local panelVisuals = getChildAt(panel, 1 )

    -- Find which segment this is.We'll also find if the node was actually a panel
        local segment = nil

        -- Each panel has as parent the pole
        local pole = getParent(panel)

        -- Each pole has as parent the segment group
        local sGroup = getParent(pole)
        for si = 1 , #spec.segments do
            local seg = spec.segments[si]
            if seg.group = = sGroup then
                segment = seg
                break

                -- Special case are gates because of doors or pole selection
            elseif seg.group = = pole and seg.gateIndex ~ = nil then
                    segment = seg

                    -- The pole is actually the group
                    sGroup = pole

                    -- Thus update all references
                    pole = panel
                    -- First nodes are poles, last one is panel.
                    panel = getChildAt(sGroup, getNumOfChildren(sGroup) - 1 )
                    panelVisuals = getChildAt(panel, 1 ) -- first is col, second is visuals

                    break
                end
            end

            -- No segment then the requested node was not a panel
            if segment = = nil then
                -- Try to find information assuming the node is a pole instead
                collision = node
                --panel = getChildAt(collision, 0)
                pole = getParent(collision)

                sGroup = getParent(pole)
                for si = 1 , #spec.segments do
                    local seg = spec.segments[si]
                    if seg.group = = sGroup then
                        segment = seg
                        break
                    end
                end

                if segment = = nil then
                    return nil
                end

                local poleIndex = getChildIndex(pole) * 2 + 1
                return nil , nil , segment, pole, poleIndex
            end

            local poleIndex
            if segment.gateIndex ~ = nil then
                poleIndex = 1
            else
                    poleIndex = getChildIndex(pole) * 2 + 1
                end

                return panel, panelVisuals, segment, pole, poleIndex
            end

```

### generateSegmentPoles

**Description**

> Generate all poles for the segment
> In this setup, we add as many as possible whole-size elements. Then for the last, we
> make the fences equally sized.

**Definition**

> generateSegmentPoles()

**Arguments**

| any | segment |
|-----|---------|
| any | sync    |

**Code**

```lua
function PlaceableFence:generateSegmentPoles(segment, sync)
    local spec = self.spec_fence
    local totalDistance = MathUtil.getPointPointDistance(segment.x1, segment.z1, segment.x2, segment.z2)
    local numWholeFences = math.max( math.floor(totalDistance / spec.panelLength) - 1 , 0 )

    for i = 1 , #segment.poles do
        segment.poles[i] = nil
    end

    if totalDistance < 0.01 then
        return
    end

    -- For gates we only show first and last pole
    if segment.gateIndex ~ = nil then
        segment.poles[ 1 ] = segment.x1
        segment.poles[ 2 ] = segment.z1
        segment.poles[ 3 ] = segment.x2
        segment.poles[ 4 ] = segment.z2
    else
            local nextPole = 1
            for j = 0 , numWholeFences do
                local alpha = (spec.panelLength * j) / totalDistance

                segment.poles[nextPole] = MathUtil.lerp(segment.x1, segment.x2, alpha)
                segment.poles[nextPole + 1 ] = MathUtil.lerp(segment.z1, segment.z2, alpha)
                nextPole = nextPole + 2
            end

            -- Final 2 posts
            local restDistance = totalDistance - (numWholeFences * spec.panelLength)
            local numRestFences = restDistance < = spec.panelLength * 1.2 and 1 or 2
            local restFenceSize = restDistance / numRestFences

            for j = 0 , numRestFences - 1 do
                local alpha = ((numWholeFences * spec.panelLength) + (j + 1 ) * restFenceSize) / totalDistance

                segment.poles[nextPole] = MathUtil.lerp(segment.x1, segment.x2, alpha)
                segment.poles[nextPole + 1 ] = MathUtil.lerp(segment.z1, segment.z2, alpha)
                nextPole = nextPole + 2
            end
        end

        if sync then
            self:removePickingNodesForSegment(segment)
            self:updateSegmentShapes(segment)
            self:addPickingNodesForSegment(segment)
        else
                self:addSegmentShapesToUpdate(segment)
            end

            -- Segment was updated, tell dependent systems
            if spec.previewSegment ~ = segment then
                self:updateDirtyAreas(segment.x1, segment.z1, segment.x2, segment.z2)
            end
        end

```

### getAllowExtendingOnly

**Description**

**Definition**

> getAllowExtendingOnly()

**Code**

```lua
function PlaceableFence:getAllowExtendingOnly()
    return self.spec_fence.allowExtendingOnly
end

```

### getBoundingCheckWidth

**Description**

**Definition**

> getBoundingCheckWidth()

**Code**

```lua
function PlaceableFence:getBoundingCheckWidth()
    return self.spec_fence.boundingCheckWidth
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
function PlaceableFence:getDestructionMethod(superFunc)
    return Placeable.DESTRUCTION.PER_NODE
end

```

### getGate

**Description**

**Definition**

> getGate()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function PlaceableFence:getGate(index)
    local spec = self.spec_fence
    return spec.gates[index]
end

```

### getHasParallelSnapping

**Description**

**Definition**

> getHasParallelSnapping()

**Code**

```lua
function PlaceableFence:getHasParallelSnapping()
    return false
end

```

### getIsPanelLengthFixed

**Description**

**Definition**

> getIsPanelLengthFixed()

**Code**

```lua
function PlaceableFence:getIsPanelLengthFixed()
    return self.spec_fence.panelLengthFixed
end

```

### getMaxCornerAngle

**Description**

**Definition**

> getMaxCornerAngle()

**Code**

```lua
function PlaceableFence:getMaxCornerAngle()
    return self.spec_fence.maxCornerAngle
end

```

### getMaxVerticalAngle

**Description**

**Definition**

> getMaxVerticalAngle()

**Code**

```lua
function PlaceableFence:getMaxVerticalAngle()
    local spec = self.spec_fence
    return spec.maxVerticalAngle
end

```

### getMaxVerticalAngleAndYForPreview

**Description**

> Get the difference in height and the angle

**Definition**

> getMaxVerticalAngleAndYForPreview()

**Code**

```lua
function PlaceableFence:getMaxVerticalAngleAndYForPreview()
    local spec = self.spec_fence
    local segment = spec.previewSegment
    local maxAngle = 0
    local minY, maxY = 1000 , - 1000

    for i = 1 , #segment.poles - 2 , 2 do
        local x1 = segment.poles[i]
        local z1 = segment.poles[i + 1 ]
        local x2 = segment.poles[i + 2 ]
        local z2 = segment.poles[i + 3 ]

        local horizontalDifference = MathUtil.getPointPointDistance(x1, z1, x2, z2)

        local y1 = getTerrainHeightAtWorldPos(g_terrainNode, x1, 0 , z1)
        local y2 = getTerrainHeightAtWorldPos(g_terrainNode, x2, 0 , z2)
        local heightDifference = math.abs(y1 - y2)

        minY = math.min(minY, y1, y2)
        maxY = math.max(maxY, y1, y2)

        if horizontalDifference > 0 then
            local angle = math.atan(heightDifference / horizontalDifference)
            if angle > maxAngle then
                maxAngle = angle
            end
        end
    end

    return maxAngle, minY, maxY
end

```

### getMaxVerticalGateAngle

**Description**

**Definition**

> getMaxVerticalGateAngle()

**Code**

```lua
function PlaceableFence:getMaxVerticalGateAngle()
    local spec = self.spec_fence
    return spec.maxVerticalGateAngle
end

```

### getNodesToDeleteForPanel

**Description**

> Get the nodes that would be deleted if the given panel node would be
> Used for previewing

**Definition**

> getNodesToDeleteForPanel()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PlaceableFence:getNodesToDeleteForPanel(node)
    local spec = self.spec_fence
    local panel, panelVisuals, segment, pole, poleIndex = self:findRaycastInfo(node)
    if panel = = nil or node = = 0 then
        return nil
    end

    -- Collect nodes
    local nodes = {
    }

    if segment.gateIndex ~ = nil then
        -- Add all doors
        local gateInfo = spec.gates[segment.gateIndex]
        for _, door in ipairs(gateInfo.doors) do
            local doorNode = getChildAt(panel, door.node)
            nodes[#nodes + 1 ] = getChildAt(doorNode, 0 ) -- visual
        end
    else
            -- Add the panel
            nodes[ 1 ] = panelVisuals
        end

        local function addPole(poleNode, x, z)
            if self:isPoleInAnySegment(x, z, segment) = = nil then
                local visualPole = getChildAt(poleNode, 1 )
                if visualPole ~ = 0 then
                    table.insert(nodes, visualPole)
                end
            end
        end

        -- If the pole of the panel is the first pole it would become lonely and should be removed
        if poleIndex = = 1 and segment.renderFirst then
            addPole(pole, segment.poles[ 1 ], segment.poles[ 2 ])
        end

        -- If the pole after the panel-pole is the last pole, also delete it
        if poleIndex + 2 = = #segment.poles - 1 and segment.renderLast then
            addPole(getChildAt(segment.group, #segment.poles / 2 - 1 ), segment.poles[#segment.poles - 1 ], segment.poles[#segment.poles])
        end

        return nodes
    end

```

### getNumSequments

**Description**

**Definition**

> getNumSequments()

**Code**

```lua
function PlaceableFence:getNumSequments()
    local spec = self.spec_fence
    return #spec.segments
end

```

### getPanelLength

**Description**

**Definition**

> getPanelLength()

**Code**

```lua
function PlaceableFence:getPanelLength()
    return self.spec_fence.panelLength
end

```

### getPoleNear

**Description**

> Get a pole that is near given position or nil if none.

**Definition**

> getPoleNear()

**Arguments**

| any | x           |
|-----|-------------|
| any | y           |
| any | z           |
| any | maxDistance |

**Return Values**

| Type | Return Value |
|------|--------------|
| any  |              |

**Code**

```lua
function PlaceableFence:getPoleNear(x, y, z, maxDistance)
    local spec = self.spec_fence
    spec.getPoleNearResult = nil
    spec.getPoleNearResultSegment = nil
    spec.getPoleNearResultDistance = math.huge
    spec.getPoleNearResultPosition = { x, y, z }

    overlapSphere(x, y, z, maxDistance, "getPoleNearOverlapCallback" , self , CollisionFlag.STATIC_OBJECT, false , false , true , true )

    if spec.getPoleNearResult ~ = nil then
        local pole_x, pole_y, pole_z = getWorldTranslation(spec.getPoleNearResult)
        return pole_x, pole_y, pole_z, spec.getPoleNearResult, spec.getPoleNearResultSegment
    end

    return nil
end

```

### getPoleNearOverlapCallback

**Description**

**Definition**

> getPoleNearOverlapCallback()

**Arguments**

| any | hitObjectId |
|-----|-------------|

**Code**

```lua
function PlaceableFence:getPoleNearOverlapCallback(hitObjectId)
    if hitObjectId = = 0 or hitObjectId = = g_terrainNode then
        return
    end

    local sGroup = getParent(getParent(hitObjectId))
    local spec = self.spec_fence
    local x, y, z = getWorldTranslation(hitObjectId)
    local distance = MathUtil.vector3Length(x - spec.getPoleNearResultPosition[ 1 ], y - spec.getPoleNearResultPosition[ 2 ], z - spec.getPoleNearResultPosition[ 3 ])
    if distance < spec.getPoleNearResultDistance then
        for _, segment in ipairs(spec.segments) do
            if segment.group = = sGroup then
                -- A gate has at least 3 parts:trigger, 1 gate, and gate-visuals(hinges)
                -- We need to ignore gates so we attach to poles only
                if getNumOfChildren(hitObjectId) < 3 then
                    spec.getPoleNearResult = hitObjectId
                    spec.getPoleNearResultSegment = segment
                    spec.getPoleNearResultDistance = distance
                end
            end
        end
    end

    return true
end

```

### getPolePosition

**Description**

> Get whether the node is a fence pole and if so, get its position

**Definition**

> getPolePosition()

**Arguments**

| any | node       |
|-----|------------|
| any | allowPanel |

**Code**

```lua
function PlaceableFence:getPolePosition(node, allowPanel)
    local spec = self.spec_fence
    local collision = node
    local item = getParent(collision)

    -- Parent of item can be a segment(for poles), or a pole(for panels)
        local parent = getParent(item)

        -- Panels are children of poles
        local parent2
        if allowPanel and parent ~ = getRootNode() then
            parent2 = getParent(parent)
        end

        for i = 1 , #spec.segments do
            local segment = spec.segments[i]

            -- If group matches, the node is part of this fence
            if parent = = segment.group then
                -- pole
                local x, y, z = getWorldTranslation(item)
                return x, y, z, segment
            elseif parent2 = = segment.group then
                    -- panel
                    local x, y, z = getWorldTranslation(parent) -- the pole
                    return x, y, z, segment
                end
            end

            return nil
        end

```

### getPoleShapeForPreview

**Description**

> Get a pole shape for previewing. Caller must delete

**Definition**

> getPoleShapeForPreview()

**Code**

```lua
function PlaceableFence:getPoleShapeForPreview()
    local spec = self.spec_fence
    if spec.hasInvisiblePoles then
        return nil
    end

    if #spec.poles > 0 then
        if getNumOfChildren(spec.poles[ 1 ]) = = 0 then
            return nil
        end

        local pole = clone(spec.poles[ 1 ], false , false , false )
        if pole = = 0 then
            return nil
        end

        return pole
    else
            return nil
        end
    end

```

### getPreviewSegment

**Description**

**Definition**

> getPreviewSegment()

**Code**

```lua
function PlaceableFence:getPreviewSegment()
    local spec = self.spec_fence
    return spec.previewSegment
end

```

### getSegment

**Description**

**Definition**

> getSegment()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function PlaceableFence:getSegment(index)
    local spec = self.spec_fence
    return spec.segments[index]
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
function PlaceableFence:getSegmentLength(segment)
    return MathUtil.getPointPointDistance(segment.x1, segment.z1, segment.x2, segment.z2)
end

```

### getSnapCheckDistance

**Description**

**Definition**

> getSnapCheckDistance()

**Code**

```lua
function PlaceableFence:getSnapCheckDistance()
    return self.spec_fence.snapCheckDistance
end

```

### getSnapDistance

**Description**

**Definition**

> getSnapDistance()

**Code**

```lua
function PlaceableFence:getSnapDistance()
    return self.spec_fence.snapDistance
end

```

### getSupportsParallelSnapping

**Description**

**Definition**

> getSupportsParallelSnapping()

**Code**

```lua
function PlaceableFence:getSupportsParallelSnapping()
    return self.spec_fence.supportsParallelSnapping
end

```

### isPoleInAnySegment

**Description**

> Get whether given exact pole position is in any segment. Only checks start and end of segment

**Definition**

> isPoleInAnySegment()

**Arguments**

| any | x             |
|-----|---------------|
| any | z             |
| any | ignoreSegment |

**Code**

```lua
function PlaceableFence:isPoleInAnySegment(x, z, ignoreSegment)
    local spec = self.spec_fence
    for i = 1 , #spec.segments do
        local segment = spec.segments[i]

        if segment ~ = ignoreSegment then
            if math.abs(segment.x1 - x) < PlaceableFence.EPSILON and math.abs(segment.z1 - z) < PlaceableFence.EPSILON then
                return segment, true , false
            elseif math.abs(segment.x2 - x) < PlaceableFence.EPSILON and math.abs(segment.z2 - z) < PlaceableFence.EPSILON then
                    return segment, false , true
                end
            end
        end

        return nil
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
function PlaceableFence:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_fence

    xmlFile:iterate(key .. ".segments.segment" , function (index, segmentKey)
        local x1, z1 = xmlFile:getValue(segmentKey .. "#start" )
        local x2, z2 = xmlFile:getValue(segmentKey .. "#end" )

        if x1 ~ = nil and z1 ~ = nil and x2 ~ = nil and z2 ~ = nil then
            local segment = {
            x1 = x1,
            z1 = z1,
            x2 = x2,
            z2 = z2,
            renderFirst = xmlFile:getValue(segmentKey .. "#first" , true ),
            renderLast = xmlFile:getValue(segmentKey .. "#last" , true ),
            gateIndex = xmlFile:getValue(segmentKey .. "#gateIndex" ),
            poles = { } , -- generated
            segmentKey = segmentKey
            }

            table.insert(spec.segments, segment)
        else
                Logging.xmlError(xmlFile, "Invalid segment position for '%s'.Ignoring segment!" , segmentKey)
                end
            end )

            -- Rebuild the fence
            for i = 1 , #spec.segments do
                local segment = spec.segments[i]

                self:generateSegmentPoles(segment, true )

                if segment.gateIndex ~ = nil and segment.animatedObject ~ = nil then
                    segment.animatedObject:loadFromXMLFile(xmlFile, segment.segmentKey .. ".animatedObject" )
                end

                segment.segmentKey = nil
            end
        end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableFence:onDelete()
    local spec = self.spec_fence

    if spec.segments ~ = nil then
        for _, segment in pairs(spec.segments) do
            if segment.pendingUpdateTimer ~ = nil then
                segment.pendingUpdateTimer:delete()
                segment.pendingUpdateTimer = nil
            end
        end
    end

    if self.cellIdToSegments ~ = nil then
        local terrainDeformationSyncer = g_currentMission.terrainDeformationSyncer
        if terrainDeformationSyncer ~ = nil then
            for cellId in pairs( self.cellIdToSegments) do
                local cellX, cellZ = terrainDeformationSyncer:getCellIndicesById(cellId)
                terrainDeformationSyncer:removeCellUpdateListener( self , cellX, cellZ)
            end
        end
        self.cellIdToSegments = nil
    end

    if spec.animatedObjects ~ = nil then
        for _, animatedObject in ipairs(spec.animatedObjects) do
            animatedObject:delete()
        end
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
function PlaceableFence:onLoad(savegame)
    local spec = self.spec_fence
    local xmlFile = self.xmlFile

    spec.pickObjects = { }
    spec.segments = { }
    spec.segmentsToUpdate = { }
    spec.animatedObjects = { }
    spec.previewSegment = nil
    spec.panelLength = xmlFile:getValue( "placeable.fence.panels#length" )
    spec.panelLengthFixed = xmlFile:getValue( "placeable.fence.panels#fixedLength" )
    spec.maxVerticalAngle = xmlFile:getValue( "placeable.fence#maxVerticalAngle" , 35 )
    spec.maxVerticalGateAngle = xmlFile:getValue( "placeable.fence#maxVerticalGateAngle" , 5 )
    spec.hasInvisiblePoles = xmlFile:getValue( "placeable.fence#hasInvisiblePoles" , false )
    spec.supportsParallelSnapping = xmlFile:getValue( "placeable.fence#supportsParallelSnapping" , false )

    spec.boundingCheckWidth = xmlFile:getValue( "placeable.fence#boundingCheckWidth" , 0.25 )
    spec.snapDistance = xmlFile:getValue( "placeable.fence#snapDistance" , nil )
    spec.snapAngle = xmlFile:getValue( "placeable.fence#snapAngle" , nil )
    spec.snapCheckDistance = xmlFile:getValue( "placeable.fence#snapCheckDistance" , 0.25 )
    spec.allowExtendingOnly = xmlFile:getValue( "placeable.fence#extendingOnly" , false )
    spec.maxCornerAngle = xmlFile:getValue( "placeable.fence#maxCornerAngle" , 180 )

    spec.poles = { }
    local polesNode = xmlFile:getValue( "placeable.fence.poles#node" , nil , self.components, self.i3dMappings)
    if polesNode ~ = nil then
        for i = 1 , getNumOfChildren(polesNode) do
            spec.poles[i] = getChildAt(polesNode, i - 1 )
        end
    end

    spec.panels = { }
    local panelsNode = xmlFile:getValue( "placeable.fence.panels#node" , nil , self.components, self.i3dMappings)
    if panelsNode ~ = nil then
        for i = 1 , getNumOfChildren(panelsNode) do
            spec.panels[i] = getChildAt(panelsNode, i - 1 )
        end
    end

    spec.gates = { }
    xmlFile:iterate( "placeable.fence.gate" , function (_, key)
        local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            local doors = { }
            xmlFile:iterate(key .. ".door" , function (_, doorKey)
                local doorNode = xmlFile:getValue(doorKey .. "#node" )
                if doorNode ~ = nil then
                    table.insert(doors, {
                    node = doorNode,
                    rotation = xmlFile:getValue(doorKey .. "#openRotation" , nil , true ),
                    translation = xmlFile:getValue(doorKey .. "#openTranslation" , nil , true ),
                    } )
                else
                        Logging.xmlWarning(xmlFile, "Door node does not exist at %s" , doorKey)
                    end
                end )

                table.insert(spec.gates, {
                node = node,
                length = xmlFile:getValue(key .. "#length" , 1 ),
                triggerNode = xmlFile:getValue(key .. "#triggerNode" ),
                openText = xmlFile:getValue(key .. "#openText" , "action_openGate" ),
                closeText = xmlFile:getValue(key .. "#closeText" , "action_closeGate" ),
                animationDuration = xmlFile:getValue(key .. "#openDuration" , 3 ),
                doors = doors,
                } )
            else
                    Logging.xmlWarning(xmlFile, "Gate node does not exist at %s" , key)
                end
            end )
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
function PlaceableFence:onReadStream(streamId, connection)
    local spec = self.spec_fence

    local numSegments = streamReadInt32(streamId)
    for i = 1 , numSegments do
        local segment = { }
        segment.x1 = streamReadFloat32(streamId)
        segment.z1 = streamReadFloat32(streamId)
        segment.x2 = streamReadFloat32(streamId)
        segment.z2 = streamReadFloat32(streamId)

        segment.gateIndex = streamReadUInt8(streamId)
        if segment.gateIndex = = 0 then
            segment.gateIndex = nil
        end

        segment.renderFirst = streamReadBool(streamId)
        segment.renderLast = streamReadBool(streamId)

        segment.poles = { } -- generated

        table.insert(spec.segments, segment)
    end

    -- Rebuild the fence
    for i = 1 , numSegments do
        local segment = spec.segments[i]

        self:generateSegmentPoles(segment, true )

        if segment.gateIndex ~ = nil and segment.animatedObject ~ = nil then
            local animatedObject = segment.animatedObject

            local animatedObjectId = NetworkUtil.readNodeObjectId(streamId)
            animatedObject:readStream(streamId, connection)
            g_client:finishRegisterObject(animatedObject, animatedObjectId)
        end

        self:registerTerrainHeightChangeCallbacks(segment)
    end
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
function PlaceableFence:onUpdate(dt)
    self:updateSegmentUpdateQueue()
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
function PlaceableFence:onWriteStream(streamId, connection)
    local spec = self.spec_fence

    local numSegments = #spec.segments
    streamWriteInt32(streamId, numSegments)
    for i = 1 , numSegments do
        local segment = spec.segments[i]

        streamWriteFloat32(streamId, segment.x1)
        streamWriteFloat32(streamId, segment.z1)
        streamWriteFloat32(streamId, segment.x2)
        streamWriteFloat32(streamId, segment.z2)

        streamWriteUInt8(streamId, segment.gateIndex or 0 )
        streamWriteBool(streamId, segment.renderFirst)
        streamWriteBool(streamId, segment.renderLast)
    end

    for i = 1 , numSegments do
        local segment = spec.segments[i]

        if segment.gateIndex ~ = nil and segment.animatedObject ~ = nil then
            local animatedObject = segment.animatedObject

            NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(animatedObject))
            animatedObject:writeStream(streamId, connection)
            g_server:registerObjectInStream(connection, animatedObject)
        end
    end
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
function PlaceableFence:performNodeDestruction(superFunc, node)
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
function PlaceableFence.prerequisitesPresent(specializations)
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
function PlaceableFence:previewNodeDestructionNodes(superFunc, node)
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
function PlaceableFence:recursivelyAddPickingNodes(objects, node)
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
function PlaceableFence.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableFence )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableFence )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableFence )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableFence )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableFence )
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
function PlaceableFence.registerEvents(placeableType)
    SpecializationUtil.registerEvent(placeableType, "onCreateSegmentPanel" )
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
function PlaceableFence.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "addSegment" , PlaceableFence.addSegment)
    SpecializationUtil.registerFunction(placeableType, "addSegmentShapesToUpdate" , PlaceableFence.addSegmentShapesToUpdate)
    SpecializationUtil.registerFunction(placeableType, "createSegment" , PlaceableFence.createSegment)
    SpecializationUtil.registerFunction(placeableType, "deletePanel" , PlaceableFence.deletePanel)
    SpecializationUtil.registerFunction(placeableType, "deleteSegment" , PlaceableFence.deleteSegment)
    SpecializationUtil.registerFunction(placeableType, "doDeletePanel" , PlaceableFence.doDeletePanel)
    SpecializationUtil.registerFunction(placeableType, "fakeRandomValueForPosition" , PlaceableFence.fakeRandomValueForPosition)
    SpecializationUtil.registerFunction(placeableType, "findRaycastInfo" , PlaceableFence.findRaycastInfo)
    SpecializationUtil.registerFunction(placeableType, "generateSegmentPoles" , PlaceableFence.generateSegmentPoles)
    SpecializationUtil.registerFunction(placeableType, "getGate" , PlaceableFence.getGate)
    SpecializationUtil.registerFunction(placeableType, "getMaxVerticalAngle" , PlaceableFence.getMaxVerticalAngle)
    SpecializationUtil.registerFunction(placeableType, "getMaxVerticalAngleAndYForPreview" , PlaceableFence.getMaxVerticalAngleAndYForPreview)
    SpecializationUtil.registerFunction(placeableType, "getMaxVerticalGateAngle" , PlaceableFence.getMaxVerticalGateAngle)
    SpecializationUtil.registerFunction(placeableType, "getNodesToDeleteForPanel" , PlaceableFence.getNodesToDeleteForPanel)
    SpecializationUtil.registerFunction(placeableType, "getNumSequments" , PlaceableFence.getNumSequments)
    SpecializationUtil.registerFunction(placeableType, "getPanelLength" , PlaceableFence.getPanelLength)
    SpecializationUtil.registerFunction(placeableType, "getIsPanelLengthFixed" , PlaceableFence.getIsPanelLengthFixed)
    SpecializationUtil.registerFunction(placeableType, "getPoleNear" , PlaceableFence.getPoleNear)
    SpecializationUtil.registerFunction(placeableType, "getPoleNearOverlapCallback" , PlaceableFence.getPoleNearOverlapCallback)
    SpecializationUtil.registerFunction(placeableType, "getPolePosition" , PlaceableFence.getPolePosition)
    SpecializationUtil.registerFunction(placeableType, "getPoleShapeForPreview" , PlaceableFence.getPoleShapeForPreview)
    SpecializationUtil.registerFunction(placeableType, "getPreviewSegment" , PlaceableFence.getPreviewSegment)
    SpecializationUtil.registerFunction(placeableType, "getSegment" , PlaceableFence.getSegment)
    SpecializationUtil.registerFunction(placeableType, "getSegmentLength" , PlaceableFence.getSegmentLength)
    SpecializationUtil.registerFunction(placeableType, "isPoleInAnySegment" , PlaceableFence.isPoleInAnySegment)
    SpecializationUtil.registerFunction(placeableType, "recursivelyAddPickingNodes" , PlaceableFence.recursivelyAddPickingNodes)
    SpecializationUtil.registerFunction(placeableType, "addPickingNodesForSegment" , PlaceableFence.addPickingNodesForSegment)
    SpecializationUtil.registerFunction(placeableType, "removePickingNodesForSegment" , PlaceableFence.removePickingNodesForSegment)
    SpecializationUtil.registerFunction(placeableType, "setPreviewSegment" , PlaceableFence.setPreviewSegment)
    SpecializationUtil.registerFunction(placeableType, "updatePanelVisuals" , PlaceableFence.updatePanelVisuals)
    SpecializationUtil.registerFunction(placeableType, "updateSegmentShapes" , PlaceableFence.updateSegmentShapes)
    SpecializationUtil.registerFunction(placeableType, "updateSegmentUpdateQueue" , PlaceableFence.updateSegmentUpdateQueue)
    SpecializationUtil.registerFunction(placeableType, "updateDirtyAreas" , PlaceableFence.updateDirtyAreas)
    SpecializationUtil.registerFunction(placeableType, "getSupportsParallelSnapping" , PlaceableFence.getSupportsParallelSnapping)

    SpecializationUtil.registerFunction(placeableType, "getBoundingCheckWidth" , PlaceableFence.getBoundingCheckWidth)
    SpecializationUtil.registerFunction(placeableType, "getSnapDistance" , PlaceableFence.getSnapDistance)
    SpecializationUtil.registerFunction(placeableType, "getSnapAngle" , PlaceableFence.getSnapAngle)
    SpecializationUtil.registerFunction(placeableType, "getSnapCheckDistance" , PlaceableFence.getSnapCheckDistance)
    SpecializationUtil.registerFunction(placeableType, "getAllowExtendingOnly" , PlaceableFence.getAllowExtendingOnly)
    SpecializationUtil.registerFunction(placeableType, "getMaxCornerAngle" , PlaceableFence.getMaxCornerAngle)
    SpecializationUtil.registerFunction(placeableType, "getHasParallelSnapping" , PlaceableFence.getHasParallelSnapping)

    SpecializationUtil.registerFunction(placeableType, "registerTerrainHeightChangeCallbacks" , PlaceableFence.registerTerrainHeightChangeCallbacks)
    SpecializationUtil.registerFunction(placeableType, "onTerrainDeformationSyncerUpdate" , PlaceableFence.onTerrainDeformationSyncerUpdate)
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
function PlaceableFence.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableFence.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getDestructionMethod" , PlaceableFence.getDestructionMethod)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "performNodeDestruction" , PlaceableFence.performNodeDestruction)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "previewNodeDestructionNodes" , PlaceableFence.previewNodeDestructionNodes)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableFence.setOwnerFarmId)
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
function PlaceableFence.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".segments.segment(?)#start" , "Segment start position" )
    schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".segments.segment(?)#end" , "Segment end position" )
    schema:register(XMLValueType.BOOL, basePath .. ".segments.segment(?)#first" , "Segment has first pole visible" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".segments.segment(?)#last" , "Segment has last pole visible" , true )
    schema:register(XMLValueType.INT, basePath .. ".segments.segment(?)#gateIndex" , "Gate index" )
    AnimatedObject.registerSavegameXMLPaths(schema, basePath .. ".segments.segment(?).animatedObject" )
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
function PlaceableFence.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".fence.poles#node" , "Group of pole variants" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".fence.panels#node" , "Group of panel variants" )
    schema:register(XMLValueType.FLOAT, basePath .. ".fence.panels#length" , "Length of the panels" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. ".fence.panels#fixedLength" , "Panel length is fixed" , false )
    schema:register(XMLValueType.ANGLE, basePath .. ".fence#maxVerticalAngle" , "Maximum angle for vertical offset" )
        schema:register(XMLValueType.ANGLE, basePath .. ".fence#maxVerticalGateAngle" , "Maximum angle for vertical offset with gates" )
            schema:register(XMLValueType.FLOAT, basePath .. ".fence#boundingCheckWidth" , "Width of the bounding box used to check collision" , 0.25 )
            schema:register(XMLValueType.FLOAT, basePath .. ".fence#snapDistance" , "Snap distance" , nil )
            schema:register(XMLValueType.INT, basePath .. ".fence#snapAngle" , "Snap angle in degrees" , nil )
            schema:register(XMLValueType.FLOAT, basePath .. ".fence#snapCheckDistance" , "Snap distance" , nil )
            schema:register(XMLValueType.BOOL, basePath .. ".fence#extendingOnly" , "Whether to only allow extending a segment and no attaching to the center" , false )
            schema:register(XMLValueType.ANGLE, basePath .. ".fence#maxCornerAngle" , "Maximum angle between two connected segments" , 180 )
            schema:register(XMLValueType.BOOL, basePath .. ".fence#supportsParallelSnapping" , "Whether parallel snapping is an option" , false )
            schema:register(XMLValueType.BOOL, basePath .. ".fence#hasInvisiblePoles" , "Poles are not visible so another display method is used" , false )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".fence.gate(?)#node" , "Gate node" )
            schema:register(XMLValueType.FLOAT, basePath .. ".fence.gate(?)#length" , "Length of the gate from pole to pole" , 1 )
            schema:register(XMLValueType.INT, basePath .. ".fence.gate(?)#triggerNode" , "Gate trigger node index from gate node" )
            schema:register(XMLValueType.STRING, basePath .. ".fence.gate(?)#openText" , "Action open text" )
            schema:register(XMLValueType.STRING, basePath .. ".fence.gate(?)#closeText" , "Action close text" )
            schema:register(XMLValueType.FLOAT, basePath .. ".fence.gate(?)#openDuration" , "Duration of animation in seconds" )
            schema:register(XMLValueType.INT, basePath .. ".fence.gate(?).door(?)#node" , "Node of the door" )
            schema:register(XMLValueType.VECTOR_ROT, basePath .. ".fence.gate(?).door(?)#openRotation" , "Rotation of the node when fully open" )
            schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".fence.gate(?).door(?)#openTranslation" , "Translation of the node when fully open" )
            AnimatedObjectBuilder.registerXMLPaths(schema, basePath .. ".fence.gate(?)" )
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
function PlaceableFence:removePickingNodesForSegment(segment)
    if segment = = self.spec_fence.previewSegment then
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
function PlaceableFence:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_fence

    xmlFile:setTable(key .. ".segments.segment" , spec.segments, function (path, segment, _)
        xmlFile:setValue(path .. "#start" , segment.x1, segment.z1)
        xmlFile:setValue(path .. "#end" , segment.x2, segment.z2)

        if segment.gateIndex ~ = nil then
            xmlFile:setValue(path .. "#gateIndex" , segment.gateIndex)
            if segment.animatedObject ~ = nil then
                segment.animatedObject:saveToXMLFile(xmlFile, path .. ".animatedObject" , usedModNames)
            end
        end

        -- No need to save default value
        if not segment.renderFirst then
            xmlFile:setValue(path .. "#first" , false )
        end
        if not segment.renderLast then
            xmlFile:setValue(path .. "#last" , false )
        end
    end )
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
function PlaceableFence:setOwnerFarmId(superFunc, ownerFarmId, noEventSend)
    local spec = self.spec_fence

    superFunc( self , ownerFarmId, noEventSend)

    if spec.animatedObjects ~ = nil then
        for _, animatedObject in ipairs(spec.animatedObjects) do
            animatedObject:setOwnerFarmId(ownerFarmId, true )
        end
    end
end

```

### setPreviewSegment

**Description**

**Definition**

> setPreviewSegment()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableFence:setPreviewSegment(segment)
    local spec = self.spec_fence

    -- Delete old preview nodes
    if spec.previewSegment ~ = nil and spec.previewSegment.group ~ = nil and segment ~ = spec.previewSegment then
        delete(spec.previewSegment.group)
        spec.previewSegment.group = nil
    end

    spec.previewSegment = segment

    if segment ~ = nil then
        self:generateSegmentPoles(segment, false )
    end
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
function PlaceableFence:updateDirtyAreas(x1, z1, x2, z2)
    local minX = math.min(x1, x2)
    local maxX = math.max(x1, x2)
    local minZ = math.min(z1, z2)
    local maxZ = math.max(z1, z2)

    g_densityMapHeightManager:setCollisionMapAreaDirty(minX, minZ, maxX, maxZ, true )
    g_currentMission.aiSystem:setAreaDirty(minX, maxX, minZ, maxZ)
end

```

### updateSegmentShapes

**Description**

**Definition**

> updateSegmentShapes()

**Arguments**

| any | segment |
|-----|---------|

**Code**

```lua
function PlaceableFence:updateSegmentShapes(segment)
    local spec = self.spec_fence
    local isPreviewSegment = segment = = spec.previewSegment
    local enablePhysics = not isPreviewSegment

    -- Delete AO before deleting nodes so trigger is handled correctly and no double-delete occurs
    local gateTime
    if segment.animatedObject ~ = nil then
        gateTime = segment.animatedObject.animation.time
        segment.animatedObject:delete()
        segment.animatedObject = nil
    end

    -- Create a group for all segment nodes so we can delete them at once when re-generating
        if segment.group ~ = nil then
            delete(segment.group)
        end
        segment.group = createTransformGroup( "fence_segment" )
        link( self.rootNode, segment.group)

        -- Create a pole for every xz pair.
            for i = 1 , #segment.poles, 2 do
                local x, z = segment.poles[i], segment.poles[i + 1 ]
                local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)

                -- If there is a first pole, use the shape.Otherwise use an empty TG so we can still rotate
                local pole
                local poleIsFake = false
                if #spec.poles > 0 and(i > 1 or segment.renderFirst) and(i < #segment.poles - 2 or segment.renderLast) then
                    local poleIndex = self:fakeRandomValueForPosition(x, y, z, #spec.poles)
                    pole = clone(spec.poles[poleIndex], false , false , false )
                else
                        pole = createTransformGroup( "fence_firstPole" )
                        poleIsFake = true
                    end
                    link(segment.group, pole)

                    -- Set position
                    setWorldTranslation(pole, x, y, z)

                    if segment.gateIndex ~ = nil then
                        -- Poles for gates:always rotate to the other side
                            local prevX, prevZ = segment.poles[(i + 2 ) % 4 ], segment.poles[(i + 2 ) % 4 + 1 ]
                            local dx, dz = x - prevX, z - prevZ
                            local rotY = math.atan2(dx, dz) + math.pi

                            setWorldRotation(pole, 0 , rotY, 0 )

                            if enablePhysics and not poleIsFake then
                                addToPhysics(getChildAt(pole, 0 ))
                            end
                        elseif i < #segment.poles - 2 then
                                -- Next pole exists:connect it with a panel and rotate this one properly, but not if these are gate poles
                                    -- Find position of the next pole so we can match it visually
                                    local nextX, nextZ = segment.poles[i + 2 ], segment.poles[i + 3 ]
                                    local nextY = getTerrainHeightAtWorldPos(g_terrainNode, nextX, 0 , nextZ)

                                    local dx, dy, dz = x - nextX, y - nextY, z - nextZ
                                    local rotY = math.atan2(dx, dz) + math.pi

                                    -- Pole rotates into direction of fence
                                    setWorldRotation(pole, 0 , rotY, 0 )

                                    -- Find a panel and connect
                                    local panelIndex = self:fakeRandomValueForPosition(x, y, z, #spec.panels)
                                    local panel = clone(spec.panels[panelIndex], false , false , false )
                                    link(pole, panel)

                                    -- Scale fence to fit next pole.This is length on XZ plane only, as shader will transform along Y
                                    local fenceLength = MathUtil.getPointPointDistance(x, z, nextX, nextZ)

                                    -- Adjust panel distortion to match height of next fence
                                    self:updatePanelVisuals(panel, dy, segment, i, fenceLength)

                                    -- Adjust collision by rotating it to match terrain inclination
                                    local col = getChildAt(panel, 0 )

                                    local xDir, yDir, zDir = 0 , - dy, fenceLength
                                    xDir, yDir, zDir = MathUtil.vector3Normalize(xDir, yDir, zDir)
                                    local length = math.sqrt(dx * dx + dy * dy + dz * dz)

                                    local offset = (length - fenceLength) * 0.5
                                    local colX, colY, colZ = getTranslation(col)
                                    colX = colX + xDir * offset
                                    colY = colY + yDir * offset
                                    colZ = colZ + zDir * offset

                                    setDirection(col, xDir, yDir, zDir, 0 , 1 , 0 )
                                    setTranslation(col, colX, colY, colZ)

                                    if enablePhysics then
                                        addToPhysics(col)
                                    end

                                    SpecializationUtil.raiseEvent( self , "onCreateSegmentPanel" , isPreviewSegment, segment, panel, i, dy)

                                    if enablePhysics and not poleIsFake then
                                        addToPhysics(getChildAt(pole, 0 ))
                                    end
                                elseif segment.renderLast then
                                        -- End of the segment.We could look up the next segment but that is expensive
                                        -- Instead, just align to the previous pole.If no previous pole, it is a single
                                        -- pole and any rotation is fine so we can leave it.
                                        if i > 2 then
                                            local prevX, prevZ = segment.poles[i - 2 ], segment.poles[i - 1 ]
                                            local dx, dz = x - prevX, z - prevZ
                                            local rotY = math.atan2(dx, dz) + math.pi

                                            setWorldRotation(pole, 0 , rotY, 0 )

                                            if enablePhysics and not poleIsFake then
                                                addToPhysics(getChildAt(pole, 0 ))
                                            end
                                        end
                                    end
                                end

                                if segment.gateIndex ~ = nil then
                                    local gateInfo = spec.gates[segment.gateIndex]

                                    local gate = clone(gateInfo.node, false , false , false )
                                    link(segment.group, gate)

                                    local segmentTerrainY = getTerrainHeightAtWorldPos(g_terrainNode, segment.x1, 0 , segment.z1)
                                    setWorldTranslation(gate, segment.x1, segmentTerrainY, segment.z1)

                                    local dx, dz = segment.x1 - segment.x2, segment.z1 - segment.z2
                                    local rotY = math.atan2(dx, dz) + math.pi
                                    setWorldRotation(gate, 0 , rotY, 0 )

                                    -- Only build animation on final placement
                                    if not isPreviewSegment then
                                        local animatedObject = AnimatedObject.new( self.isServer, self.isClient)
                                        animatedObject:setOwnerFarmId( self:getOwnerFarmId(), false )

                                        -- Note:two gates can start from the same pole, and then their end node can be at the same x or z.So need all 4
                                        local saveId = string.format( "AnimatedObject_%s_gate_%d_%d_%d_%d" , self.configFileName, segment.x1, segment.z1, segment.x2, segment.x2)
                                        local builder = animatedObject:builder( self.configFileName, saveId)

                                        for _, door in ipairs(gateInfo.doors) do
                                            local doorNode = getChildAt(gate, door.node)
                                            builder:addSimplePart(doorNode, door.rotation, door.translation)
                                            addToPhysics(doorNode)
                                        end

                                        local triggerNode = getChildAt(gate, gateInfo.triggerNode)
                                        builder:setTrigger(triggerNode)
                                        addToPhysics(triggerNode)

                                        builder:setActions( "ACTIVATE_HANDTOOL" , gateInfo.openText, nil , gateInfo.closeText)
                                        builder:setDuration(gateInfo.animationDuration * 1000 )

                                        if self.xmlFile = = nil then
                                            self.xmlFile = XMLFile.load( "placeableFence" , self.configFileName)
                                        end
                                        builder:setSounds( self.xmlFile.handle, string.format( "placeable.fence.gate(%d).sounds" , segment.gateIndex - 1 ), gate)

                                        if not builder:build() then
                                            animatedObject:delete()
                                        else
                                                animatedObject:register( true )

                                                table.insert(spec.animatedObjects, animatedObject)
                                                segment.animatedObject = animatedObject

                                                if gateTime ~ = nil then
                                                    animatedObject:setAnimTime(gateTime, true )
                                                end

                                                if self.isServer then
                                                    -- Send one event to all clients with new AO so it is synced
                                                    for i = 1 , #spec.segments do
                                                        if spec.segments[i] = = segment then
                                                            g_server:broadcastEvent( PlaceableFenceAddGateEvent.new( self , i, animatedObject), false , nil , self )
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        else
                                                -- In preview we show the gate at a slightly open angle to indicate open/close direction
                                                for _, door in ipairs(gateInfo.doors) do
                                                    local doorNode = getChildAt(gate, door.node)

                                                    local alpha = 0.3

                                                    if door.translation ~ = nil then
                                                        local x1, y1, z1 = getTranslation(doorNode)
                                                        local x2, y2, z2 = unpack(door.translation)

                                                        setTranslation(doorNode, x1 + (x2 - x1) * alpha, y1 + (y2 - y1) * alpha, z1 + (z2 - z1) * alpha)
                                                    end
                                                    if door.rotation ~ = nil then
                                                        local x1, y1, z1 = getRotation(doorNode)
                                                        local x2, y2, z2 = unpack(door.rotation)

                                                        setRotation(doorNode, x1 + (x2 - x1) * alpha, y1 + (y2 - y1) * alpha, z1 + (z2 - z1) * alpha)
                                                    end
                                                end
                                            end
                                        end

                                        -- if enablePhysics then
                                            -- addToPhysics(segment.group)
                                            -- end
                                        end

```

### updateSegmentUpdateQueue

**Description**

**Definition**

> updateSegmentUpdateQueue()

**Code**

```lua
function PlaceableFence:updateSegmentUpdateQueue()
    local spec = self.spec_fence
    if #spec.segmentsToUpdate > 0 then
        local segment = spec.segmentsToUpdate[ 1 ]
        table.remove(spec.segmentsToUpdate, 1 )

        self:removePickingNodesForSegment(segment)
        self:updateSegmentShapes(segment)
        self:addPickingNodesForSegment(segment)

        self:raiseActive()
    end
end

```