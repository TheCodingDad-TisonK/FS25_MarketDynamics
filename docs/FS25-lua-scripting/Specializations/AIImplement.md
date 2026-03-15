## AIImplement

**Description**

> Specialization for extending implements with AI functionality

**Functions**

- [addAIDensityHeightTypeRequirement](#addaidensityheighttyperequirement)
- [addAIFruitProhibitions](#addaifruitprohibitions)
- [addAIFruitRequirement](#addaifruitrequirement)
- [addAIGroundTypeRequirements](#addaigroundtyperequirements)
- [addAITerrainDetailProhibitedRange](#addaiterraindetailprohibitedrange)
- [addAITerrainDetailRequiredRange](#addaiterraindetailrequiredrange)
- [addVehicleToAIImplementList](#addvehicletoaiimplementlist)
- [aiImplementEndLine](#aiimplementendline)
- [aiImplementStartLine](#aiimplementstartline)
- [calcAIMarkerAttacherJointOffset](#calcaimarkerattacherjointoffset)
- [checkMovingPartDirtyUpdateNode](#checkmovingpartdirtyupdatenode)
- [clearAIDensityHeightTypeRequirements](#clearaidensityheighttyperequirements)
- [clearAIFruitProhibitions](#clearaifruitprohibitions)
- [clearAIFruitRequirements](#clearaifruitrequirements)
- [clearAITerrainDetailProhibitedRange](#clearaiterraindetailprohibitedrange)
- [clearAITerrainDetailRequiredRange](#clearaiterraindetailrequiredrange)
- [compareFieldCropsQuery](#comparefieldcropsquery)
- [createFieldCropsQuery](#createfieldcropsquery)
- [getAIAllowTurnBackward](#getaiallowturnbackward)
- [getAIAreaOverlap](#getaiareaoverlap)
- [getAIBlockTurnBackward](#getaiblockturnbackward)
- [getAIDensityHeightTypeRequirements](#getaidensityheighttyperequirements)
- [getAIFruitProhibitions](#getaifruitprohibitions)
- [getAIFruitRequirements](#getaifruitrequirements)
- [getAIHasNoFullCoverageArea](#getaihasnofullcoveragearea)
- [getAIImplementCollisionTrigger](#getaiimplementcollisiontrigger)
- [getAIImplementCollisionTriggers](#getaiimplementcollisiontriggers)
- [getAIImplementSideOffset](#getaiimplementsideoffset)
- [getAIImplementUseVineSegment](#getaiimplementusevinesegment)
- [getAIInvertMarkersOnTurn](#getaiinvertmarkersonturn)
- [getAIIsVineyardTool](#getaiisvineyardtool)
- [getAILookAheadSize](#getailookaheadsize)
- [getAILowerIfAnyIsLowered](#getailowerifanyislowered)
- [getAIMarkerAttacherJointOffset](#getaimarkerattacherjointoffset)
- [getAIMarkers](#getaimarkers)
- [getAIMinTurningRadius](#getaiminturningradius)
- [getAINeedsLowering](#getaineedslowering)
- [getAINeedsRootAlignment](#getaineedsrootalignment)
- [getAIRowAlignment](#getairowalignment)
- [getAISizeMarkers](#getaisizemarkers)
- [getAITerrainDetailProhibitedRange](#getaiterraindetailprohibitedrange)
- [getAITerrainDetailRequiredRange](#getaiterraindetailrequiredrange)
- [getAIToolReverserDirectionNode](#getaitoolreverserdirectionnode)
- [getAITurnRadiusLimitation](#getaiturnradiuslimitation)
- [getAllowTireTracks](#getallowtiretracks)
- [getCanAIImplementContinueWork](#getcanaiimplementcontinuework)
- [getCanImplementBeUsedForAI](#getcanimplementbeusedforai)
- [getCustomAIImplementBaseSetup](#getcustomaiimplementbasesetup)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getFieldCropsQuery](#getfieldcropsquery)
- [getImplementAllowAutomaticSteering](#getimplementallowautomaticsteering)
- [getIsAIImplementInLine](#getisaiimplementinline)
- [initSpecialization](#initspecialization)
- [loadAICollisionTriggerFromXML](#loadaicollisiontriggerfromxml)
- [loadAIImplementBaseSetupFromXML](#loadaiimplementbasesetupfromxml)
- [onLoad](#onload)
- [onPostAIFieldCourseSettingsInitialized](#onpostaifieldcoursesettingsinitialized)
- [onPostLoad](#onpostload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerAICollisionTriggerXMLPaths](#registeraicollisiontriggerxmlpaths)
- [registerAIImplementBaseXMLPaths](#registeraiimplementbasexmlpaths)
- [registerAIImplementXMLPaths](#registeraiimplementxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setAIDensityHeightTypeRequirements](#setaidensityheighttyperequirements)
- [setAIFruitProhibitions](#setaifruitprohibitions)
- [setAIFruitRequirements](#setaifruitrequirements)
- [setAIImplementVariableSideOffset](#setaiimplementvariablesideoffset)
- [setAIMarkersInverted](#setaimarkersinverted)
- [updateAIMarkerWidth](#updateaimarkerwidth)
- [updateFieldCropsQuery](#updatefieldcropsquery)

### addAIDensityHeightTypeRequirement

**Description**

**Definition**

> addAIDensityHeightTypeRequirement()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function AIImplement:addAIDensityHeightTypeRequirement(fillType)
    local spec = self.spec_aiImplement

    table.insert(spec.requiredDensityHeightTypes, { fillType = fillType or 0 } )
    self:updateFieldCropsQuery()
end

```

### addAIFruitProhibitions

**Description**

**Definition**

> addAIFruitProhibitions()

**Arguments**

| any | fruitType             |
|-----|-----------------------|
| any | minGrowthState        |
| any | maxGrowthState        |
| any | customMapId           |
| any | customMapStartChannel |
| any | customMapNumChannels  |

**Code**

```lua
function AIImplement:addAIFruitProhibitions(fruitType, minGrowthState, maxGrowthState, customMapId, customMapStartChannel, customMapNumChannels)
    local spec = self.spec_aiImplement

    table.insert(spec.prohibitedFruitTypes, { fruitType = fruitType or 0 ,
    minGrowthState = minGrowthState or 0 ,
    maxGrowthState = maxGrowthState or 0 ,
    customMapId = customMapId,
    customMapStartChannel = customMapStartChannel,
    customMapNumChannels = customMapNumChannels } )

    self:updateFieldCropsQuery()
end

```

### addAIFruitRequirement

**Description**

**Definition**

> addAIFruitRequirement()

**Arguments**

| any | fruitType             |
|-----|-----------------------|
| any | minGrowthState        |
| any | maxGrowthState        |
| any | customMapId           |
| any | customMapStartChannel |
| any | customMapNumChannels  |

**Code**

```lua
function AIImplement:addAIFruitRequirement(fruitType, minGrowthState, maxGrowthState, customMapId, customMapStartChannel, customMapNumChannels)
    local spec = self.spec_aiImplement

    table.insert(spec.requiredFruitTypes, { fruitType = fruitType or 0 ,
    minGrowthState = minGrowthState or 0 ,
    maxGrowthState = maxGrowthState or 0 ,
    customMapId = customMapId,
    customMapStartChannel = customMapStartChannel,
    customMapNumChannels = customMapNumChannels } )
    self:updateFieldCropsQuery()
end

```

### addAIGroundTypeRequirements

**Description**

**Definition**

> addAIGroundTypeRequirements()

**Arguments**

| any | groundTypes   |
|-----|---------------|
| any | excludedType1 |
| any | excludedType2 |
| any | excludedType3 |
| any | excludedType4 |
| any | excludedType5 |
| any | excludedType6 |

**Code**

```lua
function AIImplement:addAIGroundTypeRequirements(groundTypes, excludedType1, excludedType2, excludedType3, excludedType4, excludedType5, excludedType6)
    local spec = self.spec_aiImplement
    for i = 1 , #groundTypes do
        local groundType = groundTypes[i]
        if groundType ~ = excludedType1
            and groundType ~ = excludedType2
            and groundType ~ = excludedType3
            and groundType ~ = excludedType4
            and groundType ~ = excludedType5
            and groundType ~ = excludedType6 then
            local value = FieldGroundType.getValueByType(groundType)
            table.insert(spec.terrainDetailRequiredValueRanges, { value, value, spec.groundTypeFirstChannel, spec.groundTypeNumChannels } )
        end
    end

    self:updateFieldCropsQuery()
end

```

### addAITerrainDetailProhibitedRange

**Description**

**Definition**

> addAITerrainDetailProhibitedRange()

**Arguments**

| any | detailType1 |
|-----|-------------|
| any | detailType2 |
| any | minState    |
| any | maxState    |

**Code**

```lua
function AIImplement:addAITerrainDetailProhibitedRange(detailType1, detailType2, minState, maxState)
    table.insert( self.spec_aiImplement.terrainDetailProhibitedValueRanges, { detailType1, detailType2, minState, maxState } )
    self:updateFieldCropsQuery()
end

```

### addAITerrainDetailRequiredRange

**Description**

**Definition**

> addAITerrainDetailRequiredRange()

**Arguments**

| any | detailType1 |
|-----|-------------|
| any | detailType2 |
| any | minState    |
| any | maxState    |

**Code**

```lua
function AIImplement:addAITerrainDetailRequiredRange(detailType1, detailType2, minState, maxState)
    local spec = self.spec_aiImplement
    table.insert(spec.terrainDetailRequiredValueRanges, { detailType1, detailType2, minState or spec.groundTypeFirstChannel, maxState or spec.groundTypeNumChannels } )
    self:updateFieldCropsQuery()
end

```

### addVehicleToAIImplementList

**Description**

**Definition**

> addVehicleToAIImplementList()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | list      |

**Code**

```lua
function AIImplement:addVehicleToAIImplementList(superFunc, list)
    if self:getCanImplementBeUsedForAI() then
        table.insert(list, { object = self } )
    end

    superFunc( self , list)
end

```

### aiImplementEndLine

**Description**

**Definition**

> aiImplementEndLine()

**Code**

```lua
function AIImplement:aiImplementEndLine()
    self.spec_aiImplement.isLineStarted = false
    SpecializationUtil.raiseEvent( self , "onAIImplementEndLine" )

    local actionController = self.rootVehicle.actionController
    if actionController ~ = nil then
        self.rootVehicle.actionController:onAIEvent( self , "onAIImplementEndLine" )
    end
end

```

### aiImplementStartLine

**Description**

**Definition**

> aiImplementStartLine()

**Code**

```lua
function AIImplement:aiImplementStartLine()
    self.spec_aiImplement.isLineStarted = true
    SpecializationUtil.raiseEvent( self , "onAIImplementStartLine" )

    local actionController = self.rootVehicle.actionController
    if actionController ~ = nil then
        self.rootVehicle.actionController:onAIEvent( self , "onAIImplementStartLine" )
    end
end

```

### calcAIMarkerAttacherJointOffset

**Description**

**Definition**

> calcAIMarkerAttacherJointOffset()

**Arguments**

| any | leftMarker  |
|-----|-------------|
| any | rightMarker |
| any | backMarker  |

**Code**

```lua
function AIImplement:calcAIMarkerAttacherJointOffset(leftMarker, rightMarker, backMarker)
    local spec = self.spec_aiImplement

    if self.getInputAttacherJoints ~ = nil then
        for i, inputAttacherJoint in ipairs( self:getInputAttacherJoints()) do
            local markerOffset = { }
            markerOffset.leftMarker = leftMarker

            local frontOffsetLeft, _, _ = localToLocal(leftMarker, inputAttacherJoint.node, 0 , 0 , 0 )
            local frontOffsetRight, _, _ = localToLocal(rightMarker, inputAttacherJoint.node, 0 , 0 , 0 )
            local limitFunc = frontOffsetLeft > 0 and math.min or math.max
            markerOffset.frontOffset = limitFunc(frontOffsetLeft, frontOffsetRight)

            markerOffset.backOffset, _, _ = localToLocal(backMarker, inputAttacherJoint.node, 0 , 0 , 0 )

            if spec.inputAttacherJointToMarkerOffset[i] = = nil then
                spec.inputAttacherJointToMarkerOffset[i] = { }
            end
            table.insert(spec.inputAttacherJointToMarkerOffset[i], markerOffset)
        end
    end
end

```

### checkMovingPartDirtyUpdateNode

**Description**

**Definition**

> checkMovingPartDirtyUpdateNode()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | node       |
| any | movingPart |

**Code**

```lua
function AIImplement:checkMovingPartDirtyUpdateNode(superFunc, node, movingPart)
    superFunc( self , node, movingPart)

    local spec = self.spec_aiImplement
    if node = = spec.leftMarker or node = = spec.rightMarker or node = = spec.backMarker then
        Logging.xmlError( self.xmlFile, "Found ai marker node '%s' in active dirty moving part '%s' with limited update distance.Remove limit or adjust hierarchy for correct function. (maxUpdateDistance = '-')" , getName(node), getName(movingPart.node))
        end
        if node = = spec.sizeLeftMarker or node = = spec.sizeRightMarker or node = = spec.sizeBackMarker then
            Logging.xmlError( self.xmlFile, "Found ai size marker node '%s' in active dirty moving part '%s' with limited update distance.Remove limit or adjust hierarchy for correct function. (maxUpdateDistance = '-')" , getName(node), getName(movingPart.node))
            end
            if spec.collisionTrigger ~ = nil then
                if node = = spec.collisionTrigger.node then
                    Logging.xmlError( self.xmlFile, "Found ai collision trigger '%s' in active dirty moving part '%s' with limited update distance.Remove limit or adjust hierarchy for correct function. (maxUpdateDistance = '-')" , getName(node), getName(movingPart.node))
                    end
                end
            end

```

### clearAIDensityHeightTypeRequirements

**Description**

**Definition**

> clearAIDensityHeightTypeRequirements()

**Code**

```lua
function AIImplement:clearAIDensityHeightTypeRequirements()
    local spec = self.spec_aiImplement
    if #spec.requiredDensityHeightTypes > 0 then
        spec.requiredDensityHeightTypes = { }
    end
    self:updateFieldCropsQuery()
end

```

### clearAIFruitProhibitions

**Description**

**Definition**

> clearAIFruitProhibitions()

**Code**

```lua
function AIImplement:clearAIFruitProhibitions()
    local spec = self.spec_aiImplement
    if #spec.prohibitedFruitTypes > 0 then
        spec.prohibitedFruitTypes = { }
    end
    self:updateFieldCropsQuery()
end

```

### clearAIFruitRequirements

**Description**

**Definition**

> clearAIFruitRequirements()

**Code**

```lua
function AIImplement:clearAIFruitRequirements()
    local spec = self.spec_aiImplement
    if #spec.requiredFruitTypes > 0 then
        spec.requiredFruitTypes = { }
    end
    self:updateFieldCropsQuery()
end

```

### clearAITerrainDetailProhibitedRange

**Description**

**Definition**

> clearAITerrainDetailProhibitedRange()

**Code**

```lua
function AIImplement:clearAITerrainDetailProhibitedRange()
    self.spec_aiImplement.terrainDetailProhibitedValueRanges = { }
    self:updateFieldCropsQuery()
end

```

### clearAITerrainDetailRequiredRange

**Description**

**Definition**

> clearAITerrainDetailRequiredRange()

**Code**

```lua
function AIImplement:clearAITerrainDetailRequiredRange()
    self.spec_aiImplement.terrainDetailRequiredValueRanges = { }
    self:updateFieldCropsQuery()
end

```

### compareFieldCropsQuery

**Description**

> Returns if the field crops querys of the given vehicle is identical with our own

**Definition**

> compareFieldCropsQuery()

**Arguments**

| any | otherVehicle |
|-----|--------------|

**Code**

```lua
function AIImplement:compareFieldCropsQuery(otherVehicle)
    if otherVehicle.getAIFruitRequirements = = nil then
        return false
    end

    local fruitRequirements = self:getAIFruitRequirements()
    local otherFruitRequirements = otherVehicle:getAIFruitRequirements()

    for _, fruitRequirement in ipairs(fruitRequirements) do
        local found = false
        for _, otherFruitRequirement in ipairs(otherFruitRequirements) do
            if fruitRequirement.fruitType = = otherFruitRequirement.fruitType
                and fruitRequirement.minGrowthState = = otherFruitRequirement.minGrowthState
                and fruitRequirement.maxGrowthState = = otherFruitRequirement.maxGrowthState
                and fruitRequirement.customMapId = = otherFruitRequirement.customMapId
                and fruitRequirement.customMapStartChannel = = otherFruitRequirement.customMapStartChannel
                and fruitRequirement.customMapNumChannels = = otherFruitRequirement.customMapNumChannels then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    local fruitProhibitions = self:getAIFruitProhibitions()
    local otherFruitProhibitions = otherVehicle:getAIFruitProhibitions()

    for _, fruitProhibition in ipairs(fruitProhibitions) do
        local found = false
        for _, otherFruitProhibition in ipairs(otherFruitProhibitions) do
            if fruitProhibition.fruitType = = otherFruitProhibition.fruitType
                and fruitProhibition.minGrowthState = = otherFruitProhibition.minGrowthState
                and fruitProhibition.maxGrowthState = = otherFruitProhibition.maxGrowthState
                and fruitProhibition.customMapId = = otherFruitProhibition.customMapId
                and fruitProhibition.customMapStartChannel = = otherFruitProhibition.customMapStartChannel
                and fruitProhibition.customMapNumChannels = = otherFruitProhibition.customMapNumChannels then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    local terrainDetailRequiredValueRanges = self:getAITerrainDetailRequiredRange()
    local otherTerrainDetailRequiredValueRanges = otherVehicle:getAITerrainDetailRequiredRange()

    for _, valueRange in ipairs(terrainDetailRequiredValueRanges) do
        local found = false
        for _, otherValueRange in ipairs(otherTerrainDetailRequiredValueRanges) do
            if valueRange[ 1 ] = = otherValueRange[ 1 ]
                and valueRange[ 2 ] = = otherValueRange[ 2 ]
                and valueRange[ 3 ] = = otherValueRange[ 3 ]
                and valueRange[ 4 ] = = otherValueRange[ 4 ] then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    local terrainDetailProhibitedValueRanges = self:getAITerrainDetailProhibitedRange()
    local otherTerrainDetailProhibitedValueRanges = otherVehicle:getAITerrainDetailProhibitedRange()

    for _, valueRange in ipairs(terrainDetailProhibitedValueRanges) do
        local found = false
        for _, otherValueRange in ipairs(otherTerrainDetailProhibitedValueRanges) do
            if valueRange[ 1 ] = = otherValueRange[ 1 ]
                and valueRange[ 2 ] = = otherValueRange[ 2 ]
                and valueRange[ 3 ] = = otherValueRange[ 3 ]
                and valueRange[ 4 ] = = otherValueRange[ 4 ] then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    return true
end

```

### createFieldCropsQuery

**Description**

> Creates field crops query

**Definition**

> createFieldCropsQuery()

**Code**

```lua
function AIImplement:createFieldCropsQuery()
    local mission = g_currentMission
    local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)
    if groundTypeMapId ~ = nil then
        local spec = self.spec_aiImplement
        spec.fieldCropyQueryValid = false

        local query = FieldCropsQuery.new(groundTypeMapId)
        local fruitRequirements = self:getAIFruitRequirements()

        for i = 1 , #fruitRequirements do
            local fruitRequirement = fruitRequirements[i]
            if fruitRequirement.customMapId = = nil and fruitRequirement.fruitType ~ = FruitType.UNKNOWN then
                local desc = g_fruitTypeManager:getFruitTypeByIndex(fruitRequirement.fruitType)
                if desc.terrainDataPlaneId ~ = nil then
                    query:addRequiredCropType(desc.terrainDataPlaneId, fruitRequirement.minGrowthState, fruitRequirement.maxGrowthState, desc.startStateChannel, desc.numStateChannels, groundTypeFirstChannel, groundTypeNumChannels)
                end
            elseif fruitRequirement.customMapId ~ = nil then
                    query:addRequiredDensityMapValue(fruitRequirement.customMapId, fruitRequirement.minGrowthState, fruitRequirement.maxGrowthState, fruitRequirement.customMapStartChannel, fruitRequirement.customMapNumChannels)
                end
                spec.fieldCropyQueryValid = true
            end

            local fruitProhibitions = self:getAIFruitProhibitions()
            for i = 1 , #fruitProhibitions do
                local fruitProhibition = fruitProhibitions[i]
                if fruitProhibition.customMapId = = nil and fruitProhibition.fruitType ~ = FruitType.UNKNOWN then
                    local desc = g_fruitTypeManager:getFruitTypeByIndex(fruitProhibition.fruitType)
                    query:addProhibitedCropType(desc.terrainDataPlaneId, fruitProhibition.minGrowthState, fruitProhibition.maxGrowthState, desc.startStateChannel, desc.numStateChannels, groundTypeFirstChannel, groundTypeNumChannels)
                elseif fruitProhibition.customMapId ~ = nil then
                        query:addProhibitedDensityMapValue(fruitProhibition.customMapId, fruitProhibition.minGrowthState, fruitProhibition.maxGrowthState, fruitProhibition.customMapStartChannel, fruitProhibition.customMapNumChannels)
                    end
                    spec.fieldCropyQueryValid = true
                end

                local terrainDetailRequiredValueRanges = self:getAITerrainDetailRequiredRange()
                for i = 1 , #terrainDetailRequiredValueRanges do
                    local valueRange = terrainDetailRequiredValueRanges[i]
                    query:addRequiredGroundValue(valueRange[ 1 ], valueRange[ 2 ], valueRange[ 3 ], valueRange[ 4 ])
                    spec.fieldCropyQueryValid = true
                end

                local terrainDetailProhibitValueRanges = self:getAITerrainDetailProhibitedRange()
                for i = 1 , #terrainDetailProhibitValueRanges do
                    local valueRange = terrainDetailProhibitValueRanges[i]
                    query:addProhibitedGroundValue(valueRange[ 1 ], valueRange[ 2 ], valueRange[ 3 ], valueRange[ 4 ])
                    spec.fieldCropyQueryValid = true
                end

                spec.fieldCropyQuery = query

                --#debug if spec.fieldCropyQueryValid or #spec.requiredDensityHeightTypes > 0 then
                    --#debug spec.debugArea = DebugBitVectorMap.newSimple(15, 0.5, false, 0.05, 0.1)
                    --#debug spec.debugArea:createWithAIVehicle(self)
                    --#debug end
                end
            end

```

### getAIAllowTurnBackward

**Description**

**Definition**

> getAIAllowTurnBackward()

**Code**

```lua
function AIImplement:getAIAllowTurnBackward()
    return self.spec_aiImplement.allowTurnBackward
end

```

### getAIAreaOverlap

**Description**

**Definition**

> getAIAreaOverlap()

**Code**

```lua
function AIImplement:getAIAreaOverlap()
    return self.spec_aiImplement.overlap
end

```

### getAIBlockTurnBackward

**Description**

**Definition**

> getAIBlockTurnBackward()

**Code**

```lua
function AIImplement:getAIBlockTurnBackward()
    return self.spec_aiImplement.blockTurnBackward
end

```

### getAIDensityHeightTypeRequirements

**Description**

**Definition**

> getAIDensityHeightTypeRequirements()

**Code**

```lua
function AIImplement:getAIDensityHeightTypeRequirements()
    return self.spec_aiImplement.requiredDensityHeightTypes
end

```

### getAIFruitProhibitions

**Description**

**Definition**

> getAIFruitProhibitions()

**Code**

```lua
function AIImplement:getAIFruitProhibitions()
    return self.spec_aiImplement.prohibitedFruitTypes
end

```

### getAIFruitRequirements

**Description**

**Definition**

> getAIFruitRequirements()

**Code**

```lua
function AIImplement:getAIFruitRequirements()
    return self.spec_aiImplement.requiredFruitTypes
end

```

### getAIHasNoFullCoverageArea

**Description**

**Definition**

> getAIHasNoFullCoverageArea()

**Code**

```lua
function AIImplement:getAIHasNoFullCoverageArea()
    return self.spec_aiImplement.hasNoFullCoverageArea, self.spec_aiImplement.hasNoFullCoverageAreaOffset
end

```

### getAIImplementCollisionTrigger

**Description**

**Definition**

> getAIImplementCollisionTrigger()

**Code**

```lua
function AIImplement:getAIImplementCollisionTrigger()
    local spec = self.spec_aiImplement

    local aiSetup = self:getCustomAIImplementBaseSetup()
    if aiSetup = = nil or aiSetup.collisionTrigger = = nil then
        aiSetup = spec
    end

    return aiSetup.collisionTrigger
end

```

### getAIImplementCollisionTriggers

**Description**

**Definition**

> getAIImplementCollisionTriggers()

**Arguments**

| any | collisionTriggers |
|-----|-------------------|

**Code**

```lua
function AIImplement:getAIImplementCollisionTriggers(collisionTriggers)
    local collisionTrigger = self:getAIImplementCollisionTrigger()
    if collisionTrigger ~ = nil then
        collisionTriggers[ self ] = collisionTrigger
    end
end

```

### getAIImplementSideOffset

**Description**

**Definition**

> getAIImplementSideOffset()

**Code**

```lua
function AIImplement:getAIImplementSideOffset()
    local spec = self.spec_aiImplement

    local aiSetup = self:getCustomAIImplementBaseSetup()
    if aiSetup = = nil or aiSetup.sideOffset = = nil then
        aiSetup = spec
    end

    return aiSetup.sideOffset or 0 , spec.variableSideOffset
end

```

### getAIImplementUseVineSegment

**Description**

**Definition**

> getAIImplementUseVineSegment()

**Arguments**

| any | placeable   |
|-----|-------------|
| any | segment     |
| any | segmentSide |

**Code**

```lua
function AIImplement:getAIImplementUseVineSegment(placeable, segment, segmentSide)
    return true
end

```

### getAIInvertMarkersOnTurn

**Description**

**Definition**

> getAIInvertMarkersOnTurn()

**Arguments**

| any | turnLeft |
|-----|----------|

**Code**

```lua
function AIImplement:getAIInvertMarkersOnTurn(turnLeft)
    return false
end

```

### getAIIsVineyardTool

**Description**

**Definition**

> getAIIsVineyardTool()

**Code**

```lua
function AIImplement:getAIIsVineyardTool()
    return self.spec_aiImplement.isVineyardTool
end

```

### getAILookAheadSize

**Description**

**Definition**

> getAILookAheadSize()

**Code**

```lua
function AIImplement:getAILookAheadSize()
    return self.spec_aiImplement.lookAheadSize
end

```

### getAILowerIfAnyIsLowered

**Description**

**Definition**

> getAILowerIfAnyIsLowered()

**Code**

```lua
function AIImplement:getAILowerIfAnyIsLowered()
    return self.spec_aiImplement.lowerIfAnyIsLowered
end

```

### getAIMarkerAttacherJointOffset

**Description**

**Definition**

> getAIMarkerAttacherJointOffset()

**Arguments**

| any | leftMarker |
|-----|------------|

**Code**

```lua
function AIImplement:getAIMarkerAttacherJointOffset(leftMarker)
    if self.getActiveInputAttacherJointDescIndex ~ = nil then
        local inputAttacherJointIndex = self:getActiveInputAttacherJointDescIndex()
        local markerOffsets = self.spec_aiImplement.inputAttacherJointToMarkerOffset[inputAttacherJointIndex]
        if markerOffsets ~ = nil then
            for _, markerOffset in ipairs(markerOffsets) do
                if markerOffset.leftMarker = = leftMarker then
                    return markerOffset
                end
            end
        end
    end

    return nil
end

```

### getAIMarkers

**Description**

**Definition**

> getAIMarkers()

**Code**

```lua
function AIImplement:getAIMarkers()
    local spec = self.spec_aiImplement
    if spec.useAttributesOfAttachedImplement then
        if self.getAttachedImplements ~ = nil then
            for _, implement in ipairs( self:getAttachedImplements()) do
                if implement.object.getAIMarkers ~ = nil then
                    return implement.object:getAIMarkers()
                end
            end
        end
    end

    local aiSetup = self:getCustomAIImplementBaseSetup()
    if aiSetup = = nil or aiSetup.rightMarker = = nil then
        aiSetup = spec
    end

    if spec.aiMarkersInverted then
        return aiSetup.rightMarker, aiSetup.leftMarker, aiSetup.backMarker, true , aiSetup.aiMarkerWidth, aiSetup.aiMarkerValidityOffset
    else
            return aiSetup.leftMarker, aiSetup.rightMarker, aiSetup.backMarker, false , aiSetup.aiMarkerWidth, aiSetup.aiMarkerValidityOffset
        end
    end

```

### getAIMinTurningRadius

**Description**

**Definition**

> getAIMinTurningRadius()

**Code**

```lua
function AIImplement:getAIMinTurningRadius()
    return self.spec_aiImplement.minTurningRadius
end

```

### getAINeedsLowering

**Description**

**Definition**

> getAINeedsLowering()

**Code**

```lua
function AIImplement:getAINeedsLowering()
    return self.spec_aiImplement.needsLowering
end

```

### getAINeedsRootAlignment

**Description**

**Definition**

> getAINeedsRootAlignment()

**Code**

```lua
function AIImplement:getAINeedsRootAlignment()
    return self.spec_aiImplement.needsRootAlignment
end

```

### getAIRowAlignment

**Description**

**Definition**

> getAIRowAlignment()

**Code**

```lua
function AIImplement:getAIRowAlignment()
    local spec = self.spec_aiImplement
    if spec.rowAlignment ~ = nil then
        return true , spec.rowAlignment.spacing, spec.rowAlignment.snapAngle, spec.rowAlignment.offset
    end

    return false , 0 , 0 , 0
end

```

### getAISizeMarkers

**Description**

**Definition**

> getAISizeMarkers()

**Code**

```lua
function AIImplement:getAISizeMarkers()
    local spec = self.spec_aiImplement

    local aiSetup = self:getCustomAIImplementBaseSetup()
    if aiSetup = = nil or aiSetup.sizeLeftMarker = = nil then
        aiSetup = spec
    end

    return aiSetup.sizeLeftMarker, aiSetup.sizeRightMarker, aiSetup.sizeBackMarker
end

```

### getAITerrainDetailProhibitedRange

**Description**

**Definition**

> getAITerrainDetailProhibitedRange()

**Code**

```lua
function AIImplement:getAITerrainDetailProhibitedRange()
    local spec = self.spec_aiImplement

    if spec.useAttributesOfAttachedImplement then
        if self.getAttachedImplements ~ = nil then
            for _, implement in ipairs( self:getAttachedImplements()) do
                if implement.object.getAITerrainDetailProhibitedRange ~ = nil then
                    return implement.object:getAITerrainDetailProhibitedRange()
                end
            end
        end
    end

    return spec.terrainDetailProhibitedValueRanges
end

```

### getAITerrainDetailRequiredRange

**Description**

**Definition**

> getAITerrainDetailRequiredRange()

**Code**

```lua
function AIImplement:getAITerrainDetailRequiredRange()
    local spec = self.spec_aiImplement

    if spec.useAttributesOfAttachedImplement then
        if self.getAttachedImplements ~ = nil then
            for _, implement in ipairs( self:getAttachedImplements()) do
                if implement.object.getAITerrainDetailRequiredRange ~ = nil then
                    return implement.object:getAITerrainDetailRequiredRange()
                end
            end
        end
    end

    return spec.terrainDetailRequiredValueRanges
end

```

### getAIToolReverserDirectionNode

**Description**

**Definition**

> getAIToolReverserDirectionNode()

**Code**

```lua
function AIImplement:getAIToolReverserDirectionNode()
    return self.spec_aiImplement.toolReverserDirectionNode
end

```

### getAITurnRadiusLimitation

**Description**

**Definition**

> getAITurnRadiusLimitation()

**Code**

```lua
function AIImplement:getAITurnRadiusLimitation()
    local turningRadiusLimitation = self.spec_aiImplement.turningRadiusLimitation
    return turningRadiusLimitation.radius, turningRadiusLimitation.rotationJoint, turningRadiusLimitation.wheels, turningRadiusLimitation.rotLimitFactor, turningRadiusLimitation.initialTurnRadiusFactor
end

```

### getAllowTireTracks

**Description**

**Definition**

> getAllowTireTracks()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIImplement:getAllowTireTracks(superFunc)
    return superFunc( self ) and not self:getIsAIActive()
end

```

### getCanAIImplementContinueWork

**Description**

**Definition**

> getCanAIImplementContinueWork()

**Arguments**

| any | isTurning |
|-----|-----------|

**Code**

```lua
function AIImplement:getCanAIImplementContinueWork(isTurning)
    return true , false , nil
end

```

### getCanImplementBeUsedForAI

**Description**

**Definition**

> getCanImplementBeUsedForAI()

**Code**

```lua
function AIImplement:getCanImplementBeUsedForAI()
    local leftMarker, rightMarker, backMarker, _, _ = self:getAIMarkers()
    if leftMarker = = nil or rightMarker = = nil or backMarker = = nil then
        return false
    end

    return true
end

```

### getCustomAIImplementBaseSetup

**Description**

**Definition**

> getCustomAIImplementBaseSetup()

**Code**

```lua
function AIImplement:getCustomAIImplementBaseSetup()
    local spec = self.spec_aiImplement

    for _, aiBaseSetup in ipairs(spec.aiBaseSetups) do
        if aiBaseSetup.availableFunc( self ) then
            return aiBaseSetup
        end
    end

    return nil
end

```

### getDoConsumePtoPower

**Description**

**Definition**

> getDoConsumePtoPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIImplement:getDoConsumePtoPower(superFunc)
    -- do not consume power during headland to avoid slow turning
        local rootVehicle = self.rootVehicle
        if rootVehicle.getAIFieldWorkerIsTurning ~ = nil then
            if rootVehicle:getAIFieldWorkerIsTurning() then
                return false
            end
        end

        return superFunc( self )
    end

```

### getFieldCropsQuery

**Description**

> Returns field crops query and creates it on first run

**Definition**

> getFieldCropsQuery()

**Code**

```lua
function AIImplement:getFieldCropsQuery()
    local spec = self.spec_aiImplement
    if spec.fieldCropyQuery = = nil then
        self:createFieldCropsQuery()
    end

    return spec.fieldCropyQuery, spec.fieldCropyQueryValid
end

```

### getImplementAllowAutomaticSteering

**Description**

**Definition**

> getImplementAllowAutomaticSteering()

**Code**

```lua
function AIImplement:getImplementAllowAutomaticSteering()
    return false
end

```

### getIsAIImplementInLine

**Description**

**Definition**

> getIsAIImplementInLine()

**Code**

```lua
function AIImplement:getIsAIImplementInLine()
    return self.spec_aiImplement.isLineStarted
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AIImplement.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "ai" , g_i18n:getText( "configuration_design" ), "ai" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AIImplement" )

    AIImplement.registerAIImplementXMLPaths(schema, "vehicle.ai" )
    AIImplement.registerAIImplementXMLPaths(schema, "vehicle.ai.aiConfigurations.aiConfiguration(?)" )

    schema:setXMLSpecializationType()
end

```

### loadAICollisionTriggerFromXML

**Description**

**Definition**

> loadAICollisionTriggerFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AIImplement:loadAICollisionTriggerFromXML(xmlFile, key)
    local collisionTrigger = { }
    collisionTrigger.node = xmlFile:getValue(key .. ".collisionTrigger#node" , nil , self.components, self.i3dMappings)
    if collisionTrigger.node ~ = nil then
        if getHasClassId(collisionTrigger.node, ClassIds.SHAPE) then
            Logging.xmlWarning(xmlFile, "Obsolete ai collision trigger ground.Please replace with empty transform group and add size attributes. '%s'" , key .. ".collisionTrigger#node" )
        end

        collisionTrigger.width = xmlFile:getValue(key .. ".collisionTrigger#width" , 4 )
        collisionTrigger.height = xmlFile:getValue(key .. ".collisionTrigger#height" , 3 )
        collisionTrigger.length = xmlFile:getValue(key .. ".collisionTrigger#length" , 5 )

        collisionTrigger.backNode = xmlFile:getValue(key .. ".collisionTrigger#backNode" , nil , self.components, self.i3dMappings)

        if collisionTrigger.backNode = = nil then
            local linkNode = self.spec_aiImplement.backMarker or self.spec_aiImplement.sizeBackMarker or self.rootNode

            collisionTrigger.backNode = createTransformGroup( "aiCollisionNodeBack" )
            link(linkNode, collisionTrigger.backNode)
            setTranslation(collisionTrigger.backNode, self.size.widthOffset, 0 , - self.size.length * 0.5 + self.size.lengthOffset)
            setRotation(collisionTrigger.backNode, 0 , math.pi, 0 )
        end
    else
            if xmlFile:getValue(key .. ".collisionTrigger#useSize" , false ) then
                collisionTrigger.node = createTransformGroup( "aiCollisionTrigger" )
                link( self.rootNode, collisionTrigger.node)
                setTranslation(collisionTrigger.node, self.size.widthOffset, 0 , self.size.length * 0.5 + self.size.lengthOffset)

                collisionTrigger.width = xmlFile:getValue(key .. ".collisionTrigger#width" , self.size.width)
                collisionTrigger.height = xmlFile:getValue(key .. ".collisionTrigger#height" , self.size.height)
                collisionTrigger.length = xmlFile:getValue(key .. ".collisionTrigger#length" , 5 )

                collisionTrigger.backNode = createTransformGroup( "aiCollisionNodeBack" )
                link( self.rootNode, collisionTrigger.backNode)
                setTranslation(collisionTrigger.backNode, self.size.widthOffset, 0 , - self.size.length * 0.5 + self.size.lengthOffset)
                setRotation(collisionTrigger.backNode, 0 , math.pi, 0 )
            else
                    return nil
                end
            end

            return collisionTrigger
        end

```

### loadAIImplementBaseSetupFromXML

**Description**

**Definition**

> loadAIImplementBaseSetupFromXML()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | key           |
| any | availableFunc |

**Code**

```lua
function AIImplement:loadAIImplementBaseSetupFromXML(xmlFile, key, availableFunc)
    local target = self.spec_aiImplement
    if availableFunc ~ = nil then
        target = { }
    end

    target.leftMarker = xmlFile:getValue(key .. ".areaMarkers#leftNode" , nil , self.components, self.i3dMappings)
    target.rightMarker = xmlFile:getValue(key .. ".areaMarkers#rightNode" , nil , self.components, self.i3dMappings)
    target.backMarker = xmlFile:getValue(key .. ".areaMarkers#backNode" , nil , self.components, self.i3dMappings)
    target.aiMarkersInverted = false

    target.sideOffset = xmlFile:getValue(key .. ".areaMarkers#sideOffset" )
    target.sideOffsetHeadlandAlternate = xmlFile:getValue(key .. ".areaMarkers#sideOffsetHeadlandAlternate" )
    target.aiMarkerWidth = xmlFile:getValue(key .. ".areaMarkers#width" )
    target.aiMarkerValidityOffset = xmlFile:getValue(key .. ".areaMarkers#validityOffset" )
    target.variableSideOffset = false

    if target.aiMarkerWidth = = nil then
        if target.leftMarker ~ = nil and target.rightMarker ~ = nil then
            target.aiMarkerWidth = calcDistanceFrom(target.leftMarker, target.rightMarker)
        else
                target.aiMarkerWidth = 0
            end
        end

        target.sizeLeftMarker = xmlFile:getValue(key .. ".sizeMarkers#leftNode" , nil , self.components, self.i3dMappings)
        target.sizeRightMarker = xmlFile:getValue(key .. ".sizeMarkers#rightNode" , nil , self.components, self.i3dMappings)
        target.sizeBackMarker = xmlFile:getValue(key .. ".sizeMarkers#backNode" , nil , self.components, self.i3dMappings)

        target.collisionTrigger = self:loadAICollisionTriggerFromXML(xmlFile, key)

        if availableFunc ~ = nil then
            target.availableFunc = availableFunc
            table.insert( self.spec_aiImplement.aiBaseSetups, target)
        end

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
function AIImplement:onLoad(savegame)
    local spec = self.spec_aiImplement

    local baseName = "vehicle.ai"

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".areaMarkers#leftIndex" , baseName .. ".areaMarkers#leftNode" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".areaMarkers#rightIndex" , baseName .. ".areaMarkers#rightNode" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".areaMarkers#backIndex" , baseName .. ".areaMarkers#backNode" ) -- FS17 to FS 19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".sizeMarkers#leftIndex" , baseName .. ".sizeMarkers#leftNode" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".sizeMarkers#rightIndex" , baseName .. ".sizeMarkers#rightNode" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".sizeMarkers#backIndex" , baseName .. ".sizeMarkers#backNode" ) -- FS17 to FS 19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".trafficCollisionTrigger#index" , baseName .. ".collisionTrigger#node" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".trafficCollisionTrigger#node" , baseName .. ".collisionTrigger#node" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".collisionTrigger#index" , baseName .. ".collisionTrigger#node" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.aiLookAheadSize#value" , baseName .. ".lookAheadSize#value" ) -- FS17 to FS 19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".toolReverserDirectionNode#index" , baseName .. ".toolReverserDirectionNode#node" ) -- FS17 to FS 19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".turningRadiusLimiation" , baseName .. ".turningRadiusLimitation" ) -- FS17 to FS 19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".forceTurnNoBackward#value" , baseName .. ".allowTurnBackward#value(inverted)" ) -- FS17 to FS 19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseName .. ".needsLowering#lowerIfAnyIsLowerd" , baseName .. ".allowTurnBackward#lowerIfAnyIsLowered" ) -- FS19 to FS22

    local aiConfigurationId = Utils.getNoNil( self.configurations[ "ai" ], 1 )
    local configKey = string.format( "vehicle.ai.aiConfigurations.aiConfiguration(%d)" , aiConfigurationId - 1 )

    if self.xmlFile:hasProperty(configKey) then
        baseName = configKey
    end

    spec.minTurningRadius = self.xmlFile:getValue(baseName .. ".minTurningRadius#value" )

    spec.inputAttacherJointToMarkerOffset = { }
    spec.aiBaseSetups = { }
    self:loadAIImplementBaseSetupFromXML( self.xmlFile, baseName, nil )

    spec.needsLowering = self.xmlFile:getValue(baseName .. ".needsLowering#value" , true )
    spec.lowerIfAnyIsLowered = self.xmlFile:getValue(baseName .. ".needsLowering#lowerIfAnyIsLowered" , false )
    spec.needsRootAlignment = self.xmlFile:getValue(baseName .. ".needsRootAlignment#value" , true )

    spec.allowTurnBackward = self.xmlFile:getValue(baseName .. ".allowTurnBackward#value" , true )
    spec.blockTurnBackward = self.xmlFile:getValue(baseName .. ".blockTurnBackward#value" , false )

    spec.straighteningSegmentLength = self.xmlFile:getValue(baseName .. ".allowTurnBackward#straighteningSegmentLength" )
    spec.straighteningAlwaysActive = self.xmlFile:getValue(baseName .. ".allowTurnBackward#straighteningAlwaysActive" , false )

    spec.isVineyardTool = self.xmlFile:getValue(baseName .. ".isVineyardTool#value" , false )
    spec.isVineyardToolBetweenRows = self.xmlFile:getValue(baseName .. ".isVineyardTool#betweenRows" , false )

    spec.toolReverserDirectionNode = self.xmlFile:getValue(baseName .. ".toolReverserDirectionNode#node" , nil , self.components, self.i3dMappings)

    spec.turningRadiusLimitation = { }
    spec.turningRadiusLimitation.rotationJoint = self.xmlFile:getValue(baseName .. ".turningRadiusLimitation#rotationJointNode" , nil , self.components, self.i3dMappings)
    if spec.turningRadiusLimitation.rotationJoint ~ = nil then
        spec.turningRadiusLimitation.wheelIndices = self.xmlFile:getValue(baseName .. ".turningRadiusLimitation#wheelIndices" , nil , true )
    end

    spec.turningRadiusLimitation.radius = self.xmlFile:getValue(baseName .. ".turningRadiusLimitation#radius" )
    spec.turningRadiusLimitation.initialTurnRadiusFactor = self.xmlFile:getValue(baseName .. ".turningRadiusLimitation#initialTurnRadiusFactor" )
    spec.turningRadiusLimitation.rotLimitFactor = self.xmlFile:getValue(baseName .. ".turningRadiusLimitation#rotLimitFactor" , 1 )

    spec.lookAheadSize = self.xmlFile:getValue(baseName .. ".lookAheadSize#value" , 2 )
    spec.useAttributesOfAttachedImplement = self.xmlFile:getValue(baseName .. ".useAttributesOfAttachedImplement#value" , false )

    spec.hasNoFullCoverageArea = self.xmlFile:getValue(baseName .. ".hasNoFullCoverageArea#value" , false )
    spec.hasNoFullCoverageAreaOffset = self.xmlFile:getValue(baseName .. ".hasNoFullCoverageArea#offset" , 0 )

    spec.headlandTailAvoidanceEnabled = self.xmlFile:getValue(baseName .. ".headlandTailAvoidance#enabled" , false )
    spec.minNumHeadlands = self.xmlFile:getValue(baseName .. ".headland#minNumHeadlands" )
    spec.cornerCutOutSupported = self.xmlFile:getValue(baseName .. ".headland#cornerCutOutSupported" )
    spec.headlandForcedDirection = self.xmlFile:getValue(baseName .. ".headland#forcedDirection" , 1 )

    spec.overlap = self.xmlFile:getValue(baseName .. ".overlap#value" )

    local spacing, snapAngle, foliageOffset
    local fruitTypeName = self.xmlFile:getValue(baseName .. ".rowAlignment#fruitTypeName" )
    if fruitTypeName ~ = nil then
        local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
        if fruitTypeDesc ~ = nil then
            spacing = fruitTypeDesc.plantSpacing

            if fruitTypeDesc.directionSnapAngle ~ = 0 then
                snapAngle = fruitTypeDesc.directionSnapAngle
            end

            if fruitTypeDesc.plantOffset ~ = nil then
                foliageOffset = fruitTypeDesc.plantOffset[ 1 ]
            end
        else
                Logging.xmlWarning( self.xmlFile, "Unknown fruit type '%s' defined in '%s'" , fruitTypeName, baseName .. ".rowAlignment#fruitTypeName" )
            end
        end

        spacing = self.xmlFile:getValue(baseName .. ".rowAlignment#spacing" , spacing)
        if spacing ~ = nil then
            spec.rowAlignment = { }
            spec.rowAlignment.spacing = spacing
            spec.rowAlignment.snapAngle = self.xmlFile:getValue(baseName .. ".rowAlignment#snapAngle" ) or snapAngle or 0
            spec.rowAlignment.offset = self.xmlFile:getValue(baseName .. ".rowAlignment#offset" , 0 ) + (foliageOffset or 0 )
        end

        spec.terrainDetailRequiredValueRanges = { }
        spec.terrainDetailProhibitedValueRanges = { }

        spec.requiredFruitTypes = { }
        spec.prohibitedFruitTypes = { }

        spec.requiredDensityHeightTypes = { }

        local _
        spec.fieldGroundSystem = g_currentMission.fieldGroundSystem
        _, spec.groundTypeFirstChannel, spec.groundTypeNumChannels = spec.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)

        spec.fieldCropyQuery = nil
        spec.fieldCropyQueryValid = false -- query is valid if at least one parameter is set, otherwise it will return always valid ground if nothing is set -> in this case we skip the query and directly return "0"

            spec.isLineStarted = false
        end

```

### onPostAIFieldCourseSettingsInitialized

**Description**

**Definition**

> onPostAIFieldCourseSettingsInitialized()

**Arguments**

| any | fieldCourseSettings |
|-----|---------------------|

**Code**

```lua
function AIImplement:onPostAIFieldCourseSettingsInitialized(fieldCourseSettings)
    -- onPost function is called after the automatic setting based on other specializations are done
        -- so we can manually overwrite them here if needed by values defined in the XML file

            local spec = self.spec_aiImplement
            if spec.isVineyardTool then
                fieldCourseSettings.isVineyardTool = true
            end
            if spec.isVineyardToolBetweenRows then
                fieldCourseSettings.isVineyardRowTool = true
            end
            if spec.headlandTailAvoidanceEnabled then
                fieldCourseSettings.headlandTailAvoidance = true
            end

            if spec.straighteningSegmentLength ~ = nil then
                fieldCourseSettings.toolStraighteningSegmentLength = spec.straighteningSegmentLength
            end

            if spec.straighteningAlwaysActive then
                fieldCourseSettings.toolStraighteningAlwaysActive = true
            end

            local aiSetup = self:getCustomAIImplementBaseSetup()
            if aiSetup = = nil or aiSetup.sideOffsetHeadlandAlternate = = nil then
                aiSetup = spec
            end

            if aiSetup.sideOffsetHeadlandAlternate ~ = nil then
                fieldCourseSettings.sideOffsetHeadlandAlternate = aiSetup.sideOffsetHeadlandAlternate
            end

            if spec.minNumHeadlands ~ = nil then
                fieldCourseSettings.numHeadlands = math.max(spec.minNumHeadlands, fieldCourseSettings.numHeadlands)
            end

            if spec.cornerCutOutSupported ~ = nil then
                fieldCourseSettings.cornerCutOutSupported = spec.cornerCutOutSupported
            end

            if spec.headlandForcedDirection ~ = 0 then
                fieldCourseSettings.headlandForcedDirection = spec.headlandForcedDirection
            end
        end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function AIImplement:onPostLoad(savegame)
    local spec = self.spec_aiImplement
    if self.getWheels ~ = nil then
        if spec.turningRadiusLimitation.wheelIndices ~ = nil then
            spec.turningRadiusLimitation.wheels = { }
            local wheels = self:getWheels()
            for _, index in ipairs(spec.turningRadiusLimitation.wheelIndices) do
                local wheel = wheels[index]
                if wheel ~ = nil then
                    table.insert(spec.turningRadiusLimitation.wheels, wheels[index])
                else
                        Logging.xmlWarning( self.xmlFile, "Unknown wheel index '%s' defined in '%s'" , index, "vehicle.ai.turningRadiusLimitation#wheelIndices" )
                    end
                end
            end
        end

        if spec.leftMarker ~ = nil and spec.backMarker ~ = nil then
            self:calcAIMarkerAttacherJointOffset(spec.leftMarker, spec.rightMarker, spec.backMarker)
        end

        if spec.aiBaseSetups ~ = nil then
            for _, aiBaseSetup in ipairs(spec.aiBaseSetups) do
                if aiBaseSetup.leftMarker ~ = nil and aiBaseSetup.backMarker ~ = nil then
                    self:calcAIMarkerAttacherJointOffset(aiBaseSetup.leftMarker, aiBaseSetup.rightMarker, aiBaseSetup.backMarker)
                end
            end
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
function AIImplement.prerequisitesPresent(specializations)
    return true
end

```

### registerAICollisionTriggerXMLPaths

**Description**

**Definition**

> registerAICollisionTriggerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AIImplement.registerAICollisionTriggerXMLPaths(schema, basePath)
    schema:register(XMLValueType.BOOL, basePath .. ".collisionTrigger#useSize" , "Use vehicle size box to calculate the ai collision box(will be placed in front of it)" , false )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".collisionTrigger#node" , "Collision trigger node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".collisionTrigger#backNode" , "Collision trigger node while driving backwards(Z-Axis pointing backwards)" )
        schema:register(XMLValueType.FLOAT, basePath .. ".collisionTrigger#width" , "Width of ai collision trigger" , 4 )
        schema:register(XMLValueType.FLOAT, basePath .. ".collisionTrigger#height" , "Width of ai collision trigger" , 3 )
        schema:register(XMLValueType.FLOAT, basePath .. ".collisionTrigger#length" , "Max.length of ai collision trigger" , 5 )
    end

```

### registerAIImplementBaseXMLPaths

**Description**

**Definition**

> registerAIImplementBaseXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AIImplement.registerAIImplementBaseXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".areaMarkers#leftNode" , "AI area left node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".areaMarkers#rightNode" , "AI area right node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".areaMarkers#backNode" , "AI area back node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".areaMarkers#sideOffset" , "Side offset of the ai markers to the center of the leading vehicle" , 0 )
    schema:register(XMLValueType.BOOL, basePath .. ".areaMarkers#sideOffsetHeadlandAlternate" , "Alternate the side offset during headland work" , false )
    schema:register(XMLValueType.FLOAT, basePath .. ".areaMarkers#width" , "Working width of the ai implement" , "automatically calculated based on distance between ai markers while activating the ai" )
        schema:register(XMLValueType.FLOAT, basePath .. ".areaMarkers#validityOffset" , "Side offset on the validity checks of the segments" , 0 )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".sizeMarkers#leftNode" , "Size area left node" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".sizeMarkers#rightNode" , "Size area right node" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".sizeMarkers#backNode" , "Size area back node" )

        AIImplement.registerAICollisionTriggerXMLPaths(schema, basePath)
    end

```

### registerAIImplementXMLPaths

**Description**

**Definition**

> registerAIImplementXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AIImplement.registerAIImplementXMLPaths(schema, basePath)
    schema:register(XMLValueType.FLOAT, basePath .. ".minTurningRadius#value" , "Min turning radius" )

    AIImplement.registerAIImplementBaseXMLPaths(schema, basePath)

    schema:register(XMLValueType.BOOL, basePath .. ".needsLowering#value" , "AI needs to lower this tool" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".needsLowering#lowerIfAnyIsLowered" , "Lower tool of any attached ai tool is lowered" , false )
    schema:register(XMLValueType.BOOL, basePath .. ".needsRootAlignment#value" , "Tool needs to point in the same direction as the root while working" , true )
        schema:register(XMLValueType.BOOL, basePath .. ".allowTurnBackward#value" , "Worker is allowed the turn backward with this tool" , true )
        schema:register(XMLValueType.FLOAT, basePath .. ".allowTurnBackward#straighteningSegmentLength" , "Controls the length of the extra straightening segment after the turn to get the tool straight again" )
        schema:register(XMLValueType.BOOL, basePath .. ".allowTurnBackward#straighteningAlwaysActive" , "Additional straightening segment is also added when we are allowed to turn backward, to make sure we are correctly in the line" , false )
        schema:register(XMLValueType.BOOL, basePath .. ".blockTurnBackward#value" , "Can be used for non ai tools to block ai from driving backward" , false )
            schema:register(XMLValueType.BOOL, basePath .. ".isVineyardTool#value" , "Field work AI for this tool can only be used in vine yards" , false )
                schema:register(XMLValueType.BOOL, basePath .. ".isVineyardTool#betweenRows" , "Defines if the tool is used to work between the vine yard rows" , false )

                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".toolReverserDirectionNode#node" , "Reverser direction node, target node if driving backward" )
                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".turningRadiusLimitation#rotationJointNode" , "Turn radius limitation joint node" )
                        schema:register(XMLValueType.VECTOR_N, basePath .. ".turningRadiusLimitation#wheelIndices" , "Turn radius limitation wheel indices" )
                        schema:register(XMLValueType.FLOAT, basePath .. ".turningRadiusLimitation#radius" , "Turn radius limitation radius" )
                        schema:register(XMLValueType.FLOAT, basePath .. ".turningRadiusLimitation#initialTurnRadiusFactor" , "Increase or decrease the turn radius while the tool is still folded(initial drive to the first segment)" , 1 )
                            schema:register(XMLValueType.FLOAT, basePath .. ".turningRadiusLimitation#rotLimitFactor" , "Changes the rot limit of attacher joint or component joint for turning radius calculation" , 1 )

                                schema:register(XMLValueType.FLOAT, basePath .. ".lookAheadSize#value" , "Look a head size to check ground in front of tool" , 2 )
                                schema:register(XMLValueType.BOOL, basePath .. ".useAttributesOfAttachedImplement#value" , "Use AI attributes(area & fruit/ground requirements) of first attached implement" , false )
                                schema:register(XMLValueType.BOOL, basePath .. ".hasNoFullCoverageArea#value" , "Tool as a no full coverage area(e.g.plows)" , false )
                                schema:register(XMLValueType.FLOAT, basePath .. ".hasNoFullCoverageArea#offset" , "Non full coverage area offset" , 0 )

                                schema:register(XMLValueType.BOOL, basePath .. ".headlandTailAvoidance#enabled" , "Course generation setting to help long vehicles to stay inside field boundaries(sugarbeet harvesters for example)" , false )
                                    schema:register(XMLValueType.INT, basePath .. ".headland#minNumHeadlands" , "Try to use this amount of headlands at least" )
                                    schema:register(XMLValueType.BOOL, basePath .. ".headland#cornerCutOutSupported" , "Use corner cut out in the corners of the headland" , "Defined by vehicle type" )
                                    schema:register(XMLValueType.INT, basePath .. ".headland#forcedDirection" , "Forces a fixed direction for headlands.Starting headland loop direction still depends on the vehicle orientation. (1:clockwise, -1:counter-clockwise, 0:any)" , 1 )

                                        schema:register(XMLValueType.FLOAT, basePath .. ".overlap#value" , "Defines the ai line to line overlap" , AIVehicleUtil.AREA_OVERLAP)

                                        schema:register(XMLValueType.STRING, basePath .. ".rowAlignment#fruitTypeName" , "AI lines snap to the crop spacing of this type" )
                                        schema:register(XMLValueType.FLOAT, basePath .. ".rowAlignment#spacing" , "Spacing between the rows to snap to in meter(if fruitTypeName is not defined)" )
                                            schema:register(XMLValueType.ANGLE, basePath .. ".rowAlignment#snapAngle" , "Snap the lines to this angle in degrees(if fruitTypeName is not defined)" )
                                                schema:register(XMLValueType.FLOAT, basePath .. ".rowAlignment#offset" , "Side offset in the row for this tool" , 0 )
                                                end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIImplement.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AIImplement )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AIImplement )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAIFieldCourseSettingsInitialized" , AIImplement )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIImplement.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementStart" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementActive" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementEnd" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementPrepareForWork" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementStartLine" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementEndLine" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementStartTurn" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementTurnProgress" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementEndTurn" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementSideOffsetChanged" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementBlock" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementContinue" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementPrepareForTransport" )

    SpecializationUtil.registerEvent(vehicleType, "onAIImplementJobVehicleBlock" )
    SpecializationUtil.registerEvent(vehicleType, "onAIImplementJobVehicleContinue" )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIImplement.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadAICollisionTriggerFromXML" , AIImplement.loadAICollisionTriggerFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadAIImplementBaseSetupFromXML" , AIImplement.loadAIImplementBaseSetupFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getCustomAIImplementBaseSetup" , AIImplement.getCustomAIImplementBaseSetup)
    SpecializationUtil.registerFunction(vehicleType, "getCanAIImplementContinueWork" , AIImplement.getCanAIImplementContinueWork)
    SpecializationUtil.registerFunction(vehicleType, "getCanImplementBeUsedForAI" , AIImplement.getCanImplementBeUsedForAI)
    SpecializationUtil.registerFunction(vehicleType, "getAIMinTurningRadius" , AIImplement.getAIMinTurningRadius)
    SpecializationUtil.registerFunction(vehicleType, "getAIMarkers" , AIImplement.getAIMarkers)
    SpecializationUtil.registerFunction(vehicleType, "updateAIMarkerWidth" , AIImplement.updateAIMarkerWidth)
    SpecializationUtil.registerFunction(vehicleType, "setAIMarkersInverted" , AIImplement.setAIMarkersInverted)
    SpecializationUtil.registerFunction(vehicleType, "calcAIMarkerAttacherJointOffset" , AIImplement.calcAIMarkerAttacherJointOffset)
    SpecializationUtil.registerFunction(vehicleType, "getAIMarkerAttacherJointOffset" , AIImplement.getAIMarkerAttacherJointOffset)
    SpecializationUtil.registerFunction(vehicleType, "getAIInvertMarkersOnTurn" , AIImplement.getAIInvertMarkersOnTurn)
    SpecializationUtil.registerFunction(vehicleType, "getAISizeMarkers" , AIImplement.getAISizeMarkers)
    SpecializationUtil.registerFunction(vehicleType, "getAILookAheadSize" , AIImplement.getAILookAheadSize)
    SpecializationUtil.registerFunction(vehicleType, "getAIHasNoFullCoverageArea" , AIImplement.getAIHasNoFullCoverageArea)
    SpecializationUtil.registerFunction(vehicleType, "getAIAreaOverlap" , AIImplement.getAIAreaOverlap)
    SpecializationUtil.registerFunction(vehicleType, "getAIRowAlignment" , AIImplement.getAIRowAlignment)

    SpecializationUtil.registerFunction(vehicleType, "getImplementAllowAutomaticSteering" , AIImplement.getImplementAllowAutomaticSteering)

    SpecializationUtil.registerFunction(vehicleType, "getAIImplementCollisionTrigger" , AIImplement.getAIImplementCollisionTrigger)
    SpecializationUtil.registerFunction(vehicleType, "getAIImplementCollisionTriggers" , AIImplement.getAIImplementCollisionTriggers)

    SpecializationUtil.registerFunction(vehicleType, "getAINeedsLowering" , AIImplement.getAINeedsLowering)
    SpecializationUtil.registerFunction(vehicleType, "getAILowerIfAnyIsLowered" , AIImplement.getAILowerIfAnyIsLowered)
    SpecializationUtil.registerFunction(vehicleType, "getAINeedsRootAlignment" , AIImplement.getAINeedsRootAlignment)
    SpecializationUtil.registerFunction(vehicleType, "getAIAllowTurnBackward" , AIImplement.getAIAllowTurnBackward)
    SpecializationUtil.registerFunction(vehicleType, "getAIBlockTurnBackward" , AIImplement.getAIBlockTurnBackward)
    SpecializationUtil.registerFunction(vehicleType, "getAIIsVineyardTool" , AIImplement.getAIIsVineyardTool)
    SpecializationUtil.registerFunction(vehicleType, "getAIToolReverserDirectionNode" , AIImplement.getAIToolReverserDirectionNode)
    SpecializationUtil.registerFunction(vehicleType, "getAITurnRadiusLimitation" , AIImplement.getAITurnRadiusLimitation)

    SpecializationUtil.registerFunction(vehicleType, "setAIImplementVariableSideOffset" , AIImplement.setAIImplementVariableSideOffset)
    SpecializationUtil.registerFunction(vehicleType, "getAIImplementSideOffset" , AIImplement.getAIImplementSideOffset)

    SpecializationUtil.registerFunction(vehicleType, "setAIFruitProhibitions" , AIImplement.setAIFruitProhibitions)
    SpecializationUtil.registerFunction(vehicleType, "addAIFruitProhibitions" , AIImplement.addAIFruitProhibitions)
    SpecializationUtil.registerFunction(vehicleType, "clearAIFruitProhibitions" , AIImplement.clearAIFruitProhibitions)
    SpecializationUtil.registerFunction(vehicleType, "getAIFruitProhibitions" , AIImplement.getAIFruitProhibitions)

    SpecializationUtil.registerFunction(vehicleType, "setAIFruitRequirements" , AIImplement.setAIFruitRequirements)
    SpecializationUtil.registerFunction(vehicleType, "addAIFruitRequirement" , AIImplement.addAIFruitRequirement)
    SpecializationUtil.registerFunction(vehicleType, "clearAIFruitRequirements" , AIImplement.clearAIFruitRequirements)
    SpecializationUtil.registerFunction(vehicleType, "getAIFruitRequirements" , AIImplement.getAIFruitRequirements)

    SpecializationUtil.registerFunction(vehicleType, "setAIDensityHeightTypeRequirements" , AIImplement.setAIDensityHeightTypeRequirements)
    SpecializationUtil.registerFunction(vehicleType, "addAIDensityHeightTypeRequirement" , AIImplement.addAIDensityHeightTypeRequirement)
    SpecializationUtil.registerFunction(vehicleType, "clearAIDensityHeightTypeRequirements" , AIImplement.clearAIDensityHeightTypeRequirements)
    SpecializationUtil.registerFunction(vehicleType, "getAIDensityHeightTypeRequirements" , AIImplement.getAIDensityHeightTypeRequirements)

    SpecializationUtil.registerFunction(vehicleType, "getAIImplementUseVineSegment" , AIImplement.getAIImplementUseVineSegment)

    SpecializationUtil.registerFunction(vehicleType, "addAITerrainDetailRequiredRange" , AIImplement.addAITerrainDetailRequiredRange)
    SpecializationUtil.registerFunction(vehicleType, "addAIGroundTypeRequirements" , AIImplement.addAIGroundTypeRequirements)
    SpecializationUtil.registerFunction(vehicleType, "clearAITerrainDetailRequiredRange" , AIImplement.clearAITerrainDetailRequiredRange)
    SpecializationUtil.registerFunction(vehicleType, "getAITerrainDetailRequiredRange" , AIImplement.getAITerrainDetailRequiredRange)

    SpecializationUtil.registerFunction(vehicleType, "addAITerrainDetailProhibitedRange" , AIImplement.addAITerrainDetailProhibitedRange)
    SpecializationUtil.registerFunction(vehicleType, "clearAITerrainDetailProhibitedRange" , AIImplement.clearAITerrainDetailProhibitedRange)
    SpecializationUtil.registerFunction(vehicleType, "getAITerrainDetailProhibitedRange" , AIImplement.getAITerrainDetailProhibitedRange)

    SpecializationUtil.registerFunction(vehicleType, "getFieldCropsQuery" , AIImplement.getFieldCropsQuery)
    SpecializationUtil.registerFunction(vehicleType, "updateFieldCropsQuery" , AIImplement.updateFieldCropsQuery)
    SpecializationUtil.registerFunction(vehicleType, "compareFieldCropsQuery" , AIImplement.compareFieldCropsQuery)
    SpecializationUtil.registerFunction(vehicleType, "createFieldCropsQuery" , AIImplement.createFieldCropsQuery)

    SpecializationUtil.registerFunction(vehicleType, "getIsAIImplementInLine" , AIImplement.getIsAIImplementInLine)

    SpecializationUtil.registerFunction(vehicleType, "aiImplementStartLine" , AIImplement.aiImplementStartLine)
    SpecializationUtil.registerFunction(vehicleType, "aiImplementEndLine" , AIImplement.aiImplementEndLine)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIImplement.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addVehicleToAIImplementList" , AIImplement.addVehicleToAIImplementList)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowTireTracks" , AIImplement.getAllowTireTracks)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , AIImplement.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "checkMovingPartDirtyUpdateNode" , AIImplement.checkMovingPartDirtyUpdateNode)
end

```

### setAIDensityHeightTypeRequirements

**Description**

**Definition**

> setAIDensityHeightTypeRequirements()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function AIImplement:setAIDensityHeightTypeRequirements(fillType)
    self:clearAIDensityHeightTypeRequirements()
    self:addAIDensityHeightTypeRequirement(fillType)
end

```

### setAIFruitProhibitions

**Description**

**Definition**

> setAIFruitProhibitions()

**Arguments**

| any | fruitType      |
|-----|----------------|
| any | minGrowthState |
| any | maxGrowthState |

**Code**

```lua
function AIImplement:setAIFruitProhibitions(fruitType, minGrowthState, maxGrowthState)
    self:clearAIFruitProhibitions()
    self:addAIFruitProhibitions(fruitType, minGrowthState, maxGrowthState)
end

```

### setAIFruitRequirements

**Description**

**Definition**

> setAIFruitRequirements()

**Arguments**

| any | fruitType      |
|-----|----------------|
| any | minGrowthState |
| any | maxGrowthState |

**Code**

```lua
function AIImplement:setAIFruitRequirements(fruitType, minGrowthState, maxGrowthState)
    self:clearAIFruitRequirements()
    self:addAIFruitRequirement(fruitType, minGrowthState, maxGrowthState)
end

```

### setAIImplementVariableSideOffset

**Description**

**Definition**

> setAIImplementVariableSideOffset()

**Arguments**

| any | variableSideOffset |
|-----|--------------------|

**Code**

```lua
function AIImplement:setAIImplementVariableSideOffset(variableSideOffset)
    self.spec_aiImplement.variableSideOffset = variableSideOffset
end

```

### setAIMarkersInverted

**Description**

**Definition**

> setAIMarkersInverted()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function AIImplement:setAIMarkersInverted(state)
    local spec = self.spec_aiImplement
    spec.aiMarkersInverted = not spec.aiMarkersInverted
end

```

### updateAIMarkerWidth

**Description**

**Definition**

> updateAIMarkerWidth()

**Code**

```lua
function AIImplement:updateAIMarkerWidth()
    local spec = self.spec_aiImplement

    if spec.leftMarker ~ = nil and spec.backMarker ~ = nil then
        if spec.aiMarkerWidth = = nil then
            if spec.leftMarker ~ = nil and spec.rightMarker ~ = nil then
                spec.aiMarkerWidth = calcDistanceFrom(spec.leftMarker, spec.rightMarker)
            else
                    spec.aiMarkerWidth = 0
                end
            end
        end

        if spec.aiBaseSetups ~ = nil then
            for _, aiBaseSetup in ipairs(spec.aiBaseSetups) do
                if aiBaseSetup.aiMarkerWidth = = nil then
                    if aiBaseSetup.leftMarker ~ = nil and aiBaseSetup.rightMarker ~ = nil then
                        aiBaseSetup.aiMarkerWidth = calcDistanceFrom(aiBaseSetup.leftMarker, aiBaseSetup.rightMarker)
                    else
                            aiBaseSetup.aiMarkerWidth = 0
                        end
                    end
                end
            end
        end

```

### updateFieldCropsQuery

**Description**

> Recreate if the Field crops query already exists (= if it was already used)

**Definition**

> updateFieldCropsQuery()

**Code**

```lua
function AIImplement:updateFieldCropsQuery()
    local spec = self.spec_aiImplement
    if spec.fieldCropyQuery ~ = nil then
        self:createFieldCropsQuery()
    end
end

```