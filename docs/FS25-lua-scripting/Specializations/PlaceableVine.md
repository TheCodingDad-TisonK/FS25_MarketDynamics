## PlaceableVine

**Description**

> Specialization for placeables

**Functions**

- [deleteSegment](#deletesegment)
- [destroyVineArea](#destroyvinearea)
- [doDeletePanel](#dodeletepanel)
- [generateSegmentPoles](#generatesegmentpoles)
- [getCanBePlacedAt](#getcanbeplacedat)
- [getHasSegmentTargetGrowthState](#gethassegmenttargetgrowthstate)
- [getSectionFactor](#getsectionfactor)
- [getSegmentSideArea](#getsegmentsidearea)
- [getVineAreaByNode](#getvineareabynode)
- [getVineFruitType](#getvinefruittype)
- [getVineFruitTypeIndex](#getvinefruittypeindex)
- [harvestVine](#harvestvine)
- [onCreateSegmentPanel](#oncreatesegmentpanel)
- [onLoad](#onload)
- [prepareVine](#preparevine)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setShakingFactor](#setshakingfactor)
- [updateVineNode](#updatevinenode)
- [updateVineVisuals](#updatevinevisuals)

### deleteSegment

**Description**

**Definition**

> deleteSegment()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | segment   |

**Code**

```lua
function PlaceableVine:deleteSegment(superFunc, segment)
    local spec = self.spec_vine

    local data = spec.vineSegments[segment]
    if data ~ = nil then
        spec.vineSegments[segment] = nil
    end

    superFunc( self , segment)
end

```

### destroyVineArea

**Description**

**Definition**

> destroyVineArea()

**Arguments**

| any | data |
|-----|------|

**Code**

```lua
function PlaceableVine:destroyVineArea(data)
    local spec = self.spec_vine

    if self.isServer then
        for i = 1 , spec.numSections do
            local section = data.sections[i]
            FSDensityMapUtil.destroyVineArea(spec.fruitType.index, section[ 1 ], section[ 2 ], section[ 3 ], section[ 4 ], section[ 5 ], section[ 6 ])

            -- local debugArea = data.sectionDebugAreas[i]
            -- if debugArea ~ = nil then
                -- debugArea:delete()
                -- g_debugManager:removeElement(debugArea)
                -- end
            end
        end
    end

```

### doDeletePanel

**Description**

**Definition**

> doDeletePanel()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | segment      |
| any | segmentIndex |
| any | poleIndex    |

**Code**

```lua
function PlaceableVine:doDeletePanel(superFunc, segment, segmentIndex, poleIndex)
    if segment = = nil or poleIndex > #segment.poles then
        return
    end

    local previewSegment = self:getPreviewSegment()
    local isPreviewSegment = segment = = previewSegment

    if not isPreviewSegment then
        local spec = self.spec_vine

        local segmentData = spec.vineSegments[segment]
        if segmentData ~ = nil then
            for k, data in ipairs(segmentData) do
                if data.poleIndex = = poleIndex then
                    spec.nodes[data.node] = nil
                    table.remove(segmentData, k)

                    g_currentMission.vineSystem:removeElement( self , data.node, spec.width, spec.length)
                    self:destroyVineArea(data)

                    break
                end
            end
        end
    end

    superFunc( self , segment, segmentIndex, poleIndex)
end

```

### generateSegmentPoles

**Description**

**Definition**

> generateSegmentPoles()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | segment   |
| any | sync      |

**Code**

```lua
function PlaceableVine:generateSegmentPoles(superFunc, segment, sync)

    local previewSegment = self:getPreviewSegment()
    local isPreviewSegment = segment = = previewSegment

    if not isPreviewSegment then
        local spec = self.spec_vine
        local segmentData = spec.vineSegments[segment]
        if segmentData ~ = nil then
            for _, data in ipairs(segmentData) do
                g_currentMission.vineSystem:removeElement( self , data.node, spec.width, spec.length)
                spec.nodes[data.node] = nil
                --
                -- for _, debugArea in pairs(data.sectionDebugAreas) do
                    -- debugArea:delete()
                    -- g_debugManager:removeElement(debugArea)
                    -- end
                end
            end

            spec.vineSegments[segment] = { }
        end

        superFunc( self , segment, sync)
    end

```

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
function PlaceableVine:getCanBePlacedAt(superFunc, x, y, z, farmId)
    local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex( self:getVineFruitTypeIndex())
    local isPlantingSeason = fruitDesc:getIsPlantableInPeriod(g_currentMission.missionInfo.growthMode, g_currentMission.environment.currentPeriod)

    if not isPlantingSeason then
        return false , string.format(g_i18n:getText( "warning_theSelectedFruitTypeCantBePlantedInThisPeriod" ), g_i18n:formatPeriod())
    end

    return superFunc( self , x, y, z)
end

```

### getHasSegmentTargetGrowthState

**Description**

**Definition**

> getHasSegmentTargetGrowthState()

**Arguments**

| any | segment          |
|-----|------------------|
| any | fruitTypeIndex   |
| any | useHarvestStates |
| any | usePrepareStates |

**Code**

```lua
function PlaceableVine:getHasSegmentTargetGrowthState(segment, fruitTypeIndex, useHarvestStates, usePrepareStates)
    local spec = self.spec_vine
    local minState, maxState

    if fruitTypeIndex ~ = self.spec_vine.fruitType.index then
        return false
    end

    local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex( self.spec_vine.fruitType.index)
    if usePrepareStates then
        minState, maxState = fruitTypeDesc.witheredState, fruitTypeDesc.witheredState
    elseif useHarvestStates then
            minState, maxState = fruitTypeDesc.minHarvestingGrowthState, fruitTypeDesc.maxHarvestingGrowthState
        else
                return false
            end

            if minState = = nil or maxState = = nil then
                return false
            end

            local data = spec.vineSegments[segment]
            if data ~ = nil then
                for i = 1 , #data do
                    local growthValues = data[i].growthValues
                    for j = 1 , #growthValues do
                        for targetState = minState, maxState do
                            local area = growthValues[j].values[targetState]
                            if area > 0 then
                                return true
                            end
                        end
                    end
                end
            end

            return false
        end

```

### getSectionFactor

**Description**

**Definition**

> getSectionFactor()

**Arguments**

| any | node     |
|-----|----------|
| any | i        |
| any | startX   |
| any | startY   |
| any | startZ   |
| any | currentX |
| any | currentY |
| any | currentZ |

**Code**

```lua
function PlaceableVine:getSectionFactor(node, i, startX, startY, startZ, currentX, currentY, currentZ)
    local spec = self.spec_vine

    local factor = 0
    local sectionStart = spec.sectionLength * (i - 1 )
    local sectionEnd = spec.sectionLength * i

    -- convert to local space
    local _, _, localStartZ = worldToLocal(node, startX, startY, startZ)
    local _, _, localCurrentZ = worldToLocal(node, currentX, currentY, currentZ)

    if localStartZ > localCurrentZ then
        localStartZ, localCurrentZ = localCurrentZ, localStartZ
    end

    if localStartZ < sectionEnd and localCurrentZ > sectionStart then
        local checkStart = math.max(localStartZ, sectionStart)
        local checkEnd = math.min(localCurrentZ, sectionEnd)

        local checkDistance = math.abs(checkStart - checkEnd)
        factor = checkDistance / spec.sectionLength
    end

    return factor
end

```

### getSegmentSideArea

**Description**

**Definition**

> getSegmentSideArea()

**Arguments**

| any | segment     |
|-----|-------------|
| any | segmentSide |

**Code**

```lua
function PlaceableVine:getSegmentSideArea(segment, segmentSide)
    local snapDistance = self:getSnapDistance()

    segmentSide = segmentSide or 1
    local dirX, dirZ = MathUtil.vector2Normalize(segment.x2 - segment.x1, segment.z2 - segment.z1)

    local startWorldX, startWorldZ = segment.x1 + dirZ * segmentSide * snapDistance * 0.5 , segment.z1 - dirX * segmentSide * snapDistance * 0.5
    local widthWorldX, widthWorldZ = segment.x1 + dirZ * segmentSide * snapDistance * 0.4 , segment.z1 - dirX * segmentSide * snapDistance * 0.4
    local heightWorldX, heightWorldZ = segment.x2 + dirZ * segmentSide * snapDistance * 0.5 , segment.z2 - dirX * segmentSide * snapDistance * 0.5

    return startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ
end

```

### getVineAreaByNode

**Description**

**Definition**

> getVineAreaByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PlaceableVine:getVineAreaByNode(node)
    local spec = self.spec_vine
    local x, _, z = getWorldTranslation(node)
    local dirX, _, dirZ = localDirectionToWorld(node, 0 , 0 , 1 )
    local normX, _, normZ = MathUtil.crossProduct(dirX, 0 , dirZ, 0 , 1 , 0 )
    local sizeHalfX = spec.width * 0.5
    local startX = x + normX * - sizeHalfX
    local startZ = z + normZ * - sizeHalfX
    local widthX = startX + normX * spec.width
    local widthZ = startZ + normZ * spec.width
    local heightX = startX + dirX * spec.length
    local heightZ = startZ + dirZ * spec.length

    return startX, startZ, widthX, widthZ, heightX, heightZ
end

```

### getVineFruitType

**Description**

**Definition**

> getVineFruitType()

**Code**

```lua
function PlaceableVine:getVineFruitType()
    return self.spec_vine.fruitType.index
end

```

### getVineFruitTypeIndex

**Description**

**Definition**

> getVineFruitTypeIndex()

**Code**

```lua
function PlaceableVine:getVineFruitTypeIndex()
    return self.spec_vine.fruitType.index
end

```

### harvestVine

**Description**

**Definition**

> harvestVine()

**Arguments**

| any | node     |
|-----|----------|
| any | startX   |
| any | startY   |
| any | startZ   |
| any | currentX |
| any | currentY |
| any | currentZ |
| any | callback |
| any | target   |

**Code**

```lua
function PlaceableVine:harvestVine(node, startX, startY, startZ, currentX, currentY, currentZ, callback, target)
    if not self.isServer then
        return
    end

    local spec = self.spec_vine
    local data = spec.nodes[node]
    if data = = nil then
        return
    end

    local needsUpdate = false
    for i = 1 , spec.numSections do
        local factor = self:getSectionFactor(node, i, startX, startY, startZ, currentX, currentY, currentZ)

        if factor > spec.thresholdFactor then
            local section = data.sections[i]

            local area, totalArea, weedFactor, sprayFactor, plowFactor = FSDensityMapUtil.updateVineCutArea(spec.fruitType.index, section[ 1 ], section[ 2 ], section[ 3 ], section[ 4 ], section[ 5 ], section[ 6 ])

            if area > 0 then
                callback(target, self , area, totalArea, weedFactor, sprayFactor, plowFactor, spec.sectionLength)

                needsUpdate = true
            end
        end
    end

    if needsUpdate then
        self:updateVineNode(node, false )
    end
end

```

### onCreateSegmentPanel

**Description**

**Definition**

> onCreateSegmentPanel()

**Arguments**

| any | isPreview |
|-----|-----------|
| any | segment   |
| any | panel     |
| any | poleIndex |
| any | dy        |
| any | pole      |

**Code**

```lua
function PlaceableVine:onCreateSegmentPanel(isPreview, segment, panel, poleIndex, dy, pole)
    local spec = self.spec_vine

    if not getAllowFoliageShadows() then
        local function disableShadows(node)
            if getHasClassId(node, ClassIds.SHAPE) then
                setShapeCastShadowmap(node, false )
            end
        end

        I3DUtil.iterateRecursively(panel, disableShadows)
        if pole ~ = nil then
            I3DUtil.iterateRecursively(pole, disableShadows)
        end
    end

    if not isPreview then
        local node = getChildAt(panel, 0 )

        local data = { node = node, poleIndex = poleIndex }
        spec.nodes[node] = data
        table.insert(spec.vineSegments[segment], data)

        local x, _, z = getWorldTranslation(panel)
        local dirX, _, dirZ = localDirectionToWorld(panel, 0 , 0 , 1 )
        dirX, dirZ = MathUtil.vector2Normalize(dirX, dirZ)

        local normX, _, normZ = MathUtil.crossProduct(dirX, 0 , dirZ, 0 , 1 , 0 )
        normX, normZ = MathUtil.vector2Normalize(normX, normZ)
        local sizeHalfX = spec.width * 0.5

        data.growthStates = { }
        for nodeIndex, foliageStates in pairs(spec.growthStates) do
            local stateNode = I3DUtil.indexToObject(panel, nodeIndex)
            if stateNode = = nil then
                Logging.warning( "Failed to get vine panel growth state node('%s')" , nodeIndex)
                return
            end

            data.growthStates[stateNode] = { foliageStates = foliageStates, value = 0 , sectionStates = { } }
            setVisibility(stateNode, false )

            -- check if node has custom lod1 with children
                for i = 0 , getNumOfChildren(stateNode) - 1 do
                    local lodNode = getChildAt(stateNode, i)
                    if getNumOfChildren(lodNode) > 1 then
                        for j = 0 , getNumOfChildren(lodNode) - 1 do
                            local lodChildNode = getChildAt(lodNode, j)
                            local lodX, lodY, lodZ = getTranslation(lodChildNode)
                            local distanceFactor = lodZ / spec.length

                            lodY = lodY + distanceFactor * - dy
                            setTranslation(lodChildNode, lodX, lodY, lodZ)

                            if spec.numLODOffsets > 0 and getHasShaderParameter(lodChildNode, "uvOffset" ) then
                                local uvOffset = math.random( 0 , spec.numLODOffsets - 1 ) * ( 1 / spec.numLODOffsets)
                                setShaderParameter(lodChildNode, "uvOffset" , uvOffset, 0 , 0 , 0 , false )
                            end
                        end
                    end
                end
            end

            local maxState = 1
            local maxPixels = 0
            data.sections = { }
            -- data.sectionDebugAreas = {}
            data.growthValues = { }

            local sectionLength = spec.sectionLength

            for i = 1 , spec.numSections do
                local startX = x + dirX * sectionLength * (i - 1 ) + normX * - sizeHalfX
                local startZ = z + dirZ * sectionLength * (i - 1 ) + normZ * - sizeHalfX
                local widthX = startX + normX * spec.width
                local widthZ = startZ + normZ * spec.width
                local heightX = startX + dirX * sectionLength
                local heightZ = startZ + dirZ * sectionLength

                data.sections[i] = { startX, startZ, widthX, widthZ, heightX, heightZ }

                -- local debugArea = DebugPlane.newSimple(true, false, Color.new(0, 0.7 * (i / spec.numSections), 0, 0.1))
                -- debugArea:createWithPositions(startX, 0, startZ, widthX, 0, widthZ, heightX, 0, heightZ)
                -- data.sectionDebugAreas[i] = debugArea
                -- g_debugManager:addElement(debugArea)

                data.growthValues[i] = { totalArea = 0 , values = { } }
                for stateNode, growthStateData in pairs(data.growthStates) do
                    for _, foliageData in ipairs(growthStateData.foliageStates) do
                        data.growthValues[i].values[foliageData.state] = 0
                    end
                end

                data.growthValues[i].totalArea = FSDensityMapUtil.updateVineAreaValues(spec.fruitType.index, startX, startZ, widthX, widthZ, heightX, heightZ, data.growthValues[i].values)

                for state, value in pairs(data.growthValues[i].values) do
                    if value > maxPixels then
                        maxPixels = value
                        maxState = state
                    end
                end
            end

            if not self.isLoadingFromSavegameXML or spec.startGrowthState ~ = nil then
                if spec.startGrowthState ~ = nil then
                    maxState = spec.startGrowthState
                end
                for i = 1 , spec.numSections do
                    local section = data.sections[i]
                    FSDensityMapUtil.createVineArea(spec.fruitType.index, section[ 1 ], section[ 2 ], section[ 3 ], section[ 4 ], section[ 5 ], section[ 6 ], maxState)
                end
            end

            g_currentMission.vineSystem:addElement( self , node, spec.width, spec.length)
            self:updateVineNode(node, false )
        else
                local states = getChildAt(panel, 1 )
                for i = 0 , getNumOfChildren(states) - 1 do
                    setVisibility(getChildAt(states, i), i = = spec.previewNodeIndex)
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
function PlaceableVine:onLoad(savegame)
    local spec = self.spec_vine
    local xmlFile = self.xmlFile

    local fruitTypeName = xmlFile:getValue( "placeable.vine#fruitType" )
    if fruitTypeName = = nil then
        Logging.xmlWarning(xmlFile, "Missing fruit type name" )
        return
    end

    local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
    if fruitType = = nil then
        Logging.xmlWarning(xmlFile, "Fruit type '%s' not defined" , fruitTypeName)
        return
    end

    spec.fruitType = fruitType
    spec.length = xmlFile:getValue( "placeable.vine#length" , 1 )
    spec.width = xmlFile:getValue( "placeable.vine#width" , 1 )
    spec.thresholdFactor = xmlFile:getValue( "placeable.vine#thresholdFactor" , 0.5 )
    spec.numLODOffsets = xmlFile:getValue( "placeable.vine#numLODOffsets" , 0 )
    spec.numSections = math.max(xmlFile:getValue( "placeable.vine#numSections" , 1 ), 1 )
    spec.sectionLength = spec.length / spec.numSections
    spec.vineSegments = { }
    spec.nodes = { }
    spec.growthStates = { }

    xmlFile:iterate( "placeable.vine.growthStates.growthState" , function (_, key)
        local nodeIndex = xmlFile:getValue(key .. "#nodeIndex" )
        if nodeIndex = = nil then
            Logging.xmlWarning(xmlFile, "Missing growth state nodeIndex for '%s'" , key)
                return
            end

            local foliageStates = { }

            xmlFile:iterate(key .. ".foliage" , function (_, foliageKey)
                local state = xmlFile:getValue(foliageKey .. "#state" )
                if state = = nil then
                    Logging.xmlWarning(xmlFile, "Missing foliage state for '%s'" , foliageKey)
                        return
                    end

                    if state < 0 or state > (fruitType.numStateChannels ^ 2 - 1 ) then
                        Logging.xmlWarning(xmlFile, "Invalid foliage state for '%s'" , foliageKey)
                            return
                        end

                        local sectionState = xmlFile:getValue(foliageKey .. "#sectionState" )
                        if sectionState = = nil then
                            Logging.xmlWarning(xmlFile, "Missing foliage sectionState for '%s'" , foliageKey)
                                return
                            end

                            table.insert(foliageStates, { state = state, sectionState = sectionState } )
                        end )

                        if #foliageStates = = 0 then
                            Logging.xmlWarning(xmlFile, "Missing foliage states for growthstate '%s'" , key)
                                return
                            end

                            spec.growthStates[nodeIndex] = foliageStates
                        end )

                        spec.previewNodeIndex = xmlFile:getValue( "placeable.vine.growthStates#previewNodeIndex" , 0 )

                        spec.resetStates = { }
                        xmlFile:iterate( "placeable.vine.resetStates.resetState" , function (_, key)
                            local state = xmlFile:getValue(key .. "#state" )
                            if state = = nil then
                                Logging.xmlWarning(xmlFile, "Missing reset state for '%s'" , key)
                                    return
                                end
                                local targetState = xmlFile:getValue(key .. "#targetState" )
                                if targetState = = nil then
                                    Logging.xmlWarning(xmlFile, "Missing reset target state for '%s'" , key)
                                        return
                                    end
                                    local threshold = xmlFile:getValue(key .. "#threshold" )
                                    if threshold = = nil then
                                        Logging.xmlWarning(xmlFile, "Missing reset state threshold for '%s'" , key)
                                            return
                                        end

                                        local resetState = { }
                                        resetState.state = state
                                        resetState.targetState = targetState
                                        resetState.values = { }
                                        resetState.values[state] = 0
                                        resetState.threshold = threshold

                                        table.insert(spec.resetStates, resetState)
                                    end )

                                    spec.startGrowthState = nil
                                    if savegame ~ = nil then
                                        spec.startGrowthState = savegame.xmlFile:getValue(savegame.key .. ".vine#startGrowthState" )
                                    end
                                end

```

### prepareVine

**Description**

**Definition**

> prepareVine()

**Arguments**

| any | node     |
|-----|----------|
| any | startX   |
| any | startY   |
| any | startZ   |
| any | currentX |
| any | currentY |
| any | currentZ |

**Code**

```lua
function PlaceableVine:prepareVine(node, startX, startY, startZ, currentX, currentY, currentZ)
    if not self.isServer then
        return 0
    end

    local spec = self.spec_vine
    local data = spec.nodes[node]
    if data = = nil then
        return 0
    end

    local area = 0

    for i = 1 , spec.numSections do
        local factor = self:getSectionFactor(node, i, startX, startY, startZ, currentX, currentY, currentZ)

        if factor > spec.thresholdFactor then
            local section = data.sections[i]
            local currentArea, _ = FSDensityMapUtil.updateVinePrepareArea(spec.fruitType.index, section[ 1 ], section[ 2 ], section[ 3 ], section[ 4 ], section[ 5 ], section[ 6 ])
            area = area + currentArea
        end
    end

    if area > 0 then
        self:updateVineNode(node, false )
    end

    return area
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
function PlaceableVine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableFence , specializations)
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
function PlaceableVine.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableVine )
    SpecializationUtil.registerEventListener(placeableType, "onCreateSegmentPanel" , PlaceableVine )
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
function PlaceableVine.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateVineNode" , PlaceableVine.updateVineNode)
    SpecializationUtil.registerFunction(placeableType, "updateVineVisuals" , PlaceableVine.updateVineVisuals)
    SpecializationUtil.registerFunction(placeableType, "destroyVineArea" , PlaceableVine.destroyVineArea)
    SpecializationUtil.registerFunction(placeableType, "getVineFruitTypeIndex" , PlaceableVine.getVineFruitTypeIndex)
    SpecializationUtil.registerFunction(placeableType, "setShakingFactor" , PlaceableVine.setShakingFactor)
    SpecializationUtil.registerFunction(placeableType, "harvestVine" , PlaceableVine.harvestVine)
    SpecializationUtil.registerFunction(placeableType, "prepareVine" , PlaceableVine.prepareVine)
    SpecializationUtil.registerFunction(placeableType, "getVineFruitType" , PlaceableVine.getVineFruitType)
    SpecializationUtil.registerFunction(placeableType, "getHasSegmentTargetGrowthState" , PlaceableVine.getHasSegmentTargetGrowthState)
    SpecializationUtil.registerFunction(placeableType, "getSegmentSideArea" , PlaceableVine.getSegmentSideArea)
    SpecializationUtil.registerFunction(placeableType, "getSectionFactor" , PlaceableVine.getSectionFactor)
    SpecializationUtil.registerFunction(placeableType, "getVineAreaByNode" , PlaceableVine.getVineAreaByNode)
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
function PlaceableVine.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "doDeletePanel" , PlaceableVine.doDeletePanel)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "generateSegmentPoles" , PlaceableVine.generateSegmentPoles)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "deleteSegment" , PlaceableVine.deleteSegment)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getCanBePlacedAt" , PlaceableVine.getCanBePlacedAt)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getHasParallelSnapping" , PlaceableVine.getHasParallelSnapping)
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
function PlaceableVine.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Vine" )
    schema:register(XMLValueType.INT, basePath .. "#startGrowthState" , "Vineyard start growth state" )
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
function PlaceableVine.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Vine" )
    schema:register(XMLValueType.STRING, basePath .. ".vine#fruitType" , "Vine fruit type" )
    schema:register(XMLValueType.FLOAT, basePath .. ".vine#width" , "Vine width" )
    schema:register(XMLValueType.FLOAT, basePath .. ".vine#length" , "Vine length" )
    schema:register(XMLValueType.FLOAT, basePath .. ".vine#thresholdFactor" , "Section work threshold factor" )
    schema:register(XMLValueType.INT, basePath .. ".vine#numLODOffsets" , "Vine num lod offsets" )
    schema:register(XMLValueType.INT, basePath .. ".vine#numSections" , "Vine num sub sections" )
    schema:register(XMLValueType.INT, basePath .. ".vine.growthStates#previewNodeIndex" , "Node index of preview node" )
    schema:register(XMLValueType.STRING, basePath .. ".vine.growthStates.growthState(?)#nodeIndex" , "Growthstate node index.Relative to panel rootnode" )
    schema:register(XMLValueType.INT, basePath .. ".vine.growthStates.growthState(?).foliage(?)#state" , "Growthstate" )
    schema:register(XMLValueType.INT, basePath .. ".vine.growthStates.growthState(?).foliage(?)#sectionState" , "SectionState" )
    schema:register(XMLValueType.INT, basePath .. ".vine.resetStates.resetState(?)#state" , "Reset state" )
    schema:register(XMLValueType.INT, basePath .. ".vine.resetStates.resetState(?)#targetState" , "Reset target state" )
    schema:register(XMLValueType.FLOAT, basePath .. ".vine.resetStates.resetState(?)#threshold" , "Threshold to apply reset" )
    schema:setXMLSpecializationType()
end

```

### setShakingFactor

**Description**

**Definition**

> setShakingFactor()

**Arguments**

| any | node      |
|-----|-----------|
| any | worldX    |
| any | worldY    |
| any | worldZ    |
| any | intensity |

**Code**

```lua
function PlaceableVine:setShakingFactor(node, worldX, worldY, worldZ, intensity)
    local spec = self.spec_vine
    local data = spec.nodes[node]
    if data = = nil then
        return
    end

    for stateNode, _ in pairs(data.growthStates) do
        I3DUtil.setShaderParameterRec(stateNode, "harvestPosition" , worldX, worldY, worldZ, intensity)
    end
end

```

### updateVineNode

**Description**

**Definition**

> updateVineNode()

**Arguments**

| any | node      |
|-----|-----------|
| any | isGrowing |

**Code**

```lua
function PlaceableVine:updateVineNode(node, isGrowing)
    local spec = self.spec_vine

    local data = spec.nodes[node]
    if data = = nil then
        return
    end

    if not entityExists(node) then
        return
    end

    if isGrowing then
        -- check if an area needs to be reset
            -- e.g.only a small part of was prepared for new growing
                -- in that case we need to reset the whole are to make sure that vine is regrowing completly

                local startX, startZ, widthX, widthZ, heightX, heightZ = self:getVineAreaByNode(node)

                for _, resetState in ipairs(spec.resetStates) do
                    local totalArea = FSDensityMapUtil.updateVineAreaValues(spec.fruitType.index, startX, startZ, widthX, widthZ, heightX, heightZ, resetState.values)

                    local factor = 0
                    if totalArea > 0 then
                        factor = resetState.values[resetState.state] / totalArea
                    end
                    if self.isServer and factor < 1 and factor > resetState.threshold then
                        FSDensityMapUtil.resetVineArea(spec.fruitType.index, startX, startZ, widthX, widthZ, heightX, heightZ, resetState.targetState)

                        break
                    end
                end
            end

            data.totalArea = 0
            if data.growthValues = = nil then
                data.growthValues = { }
            end

            for i = 1 , spec.numSections do
                local section = data.sections[i]
                if data.growthValues[i] = = nil then
                    data.growthValues[i] = { totalArea = 0 , values = { } }
                    for stateNode, growthStateData in pairs(data.growthStates) do
                        for _, foliageData in ipairs(growthStateData.foliageStates) do
                            data.growthValues[i].values[foliageData.state] = 0
                        end
                    end
                end

                data.growthValues[i].totalArea = FSDensityMapUtil.updateVineAreaValues(spec.fruitType.index, section[ 1 ], section[ 2 ], section[ 3 ], section[ 4 ], section[ 5 ], section[ 6 ], data.growthValues[i].values)
            end

            self:updateVineVisuals(data)
        end

```

### updateVineVisuals

**Description**

**Definition**

> updateVineVisuals()

**Arguments**

| any | data |
|-----|------|

**Code**

```lua
function PlaceableVine:updateVineVisuals(data)
    local spec = self.spec_vine
    local maxValue = 0
    local growthStateNode = nil

    for stateNode, growthStateData in pairs(data.growthStates) do
        setVisibility(stateNode, false )
        growthStateData.value = 0
        for i = 1 , spec.numSections do
            local maxSectionValue = 0
            growthStateData.sectionStates[i] = 1

            for _, foliageState in ipairs(growthStateData.foliageStates) do
                local value = data.growthValues[i].values[foliageState.state]
                growthStateData.value = growthStateData.value + value

                if value > = maxSectionValue then
                    growthStateData.sectionStates[i] = foliageState.sectionState
                    maxSectionValue = value
                end
            end
        end

        if growthStateData.value > maxValue then
            if growthStateNode ~ = nil then
                setVisibility(growthStateNode, false )
            end

            maxValue = growthStateData.value
            setVisibility(stateNode, true )
            growthStateNode = stateNode

            local sectionStates = growthStateData.sectionStates
            I3DUtil.setShaderParameterRec(stateNode, "hideSectionStates" , sectionStates[ 1 ], sectionStates[ 2 ], sectionStates[ 3 ], spec.sectionLength)
        end
    end
end

```