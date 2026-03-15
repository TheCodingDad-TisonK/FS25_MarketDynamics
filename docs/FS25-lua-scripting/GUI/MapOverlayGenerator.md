## MapOverlayGenerator

**Description**

> Generator
> Provides density map based data overlays on top of an in-game map.

**Functions**

- [adjustedOverlayResolution](#adjustedoverlayresolution)
- [buildFarmlandsMapOverlay](#buildfarmlandsmapoverlay)
- [buildFieldsOverlay](#buildfieldsoverlay)
- [buildFruitTypeMapOverlay](#buildfruittypemapoverlay)
- [buildGrowthStateMapOverlay](#buildgrowthstatemapoverlay)
- [buildSingleFarmlandsMapOverlay](#buildsinglefarmlandsmapoverlay)
- [buildSoilStateMapOverlay](#buildsoilstatemapoverlay)
- [checkOverlayFinished](#checkoverlayfinished)
- [delete](#delete)
- [generateFarmlandOverlay](#generatefarmlandoverlay)
- [generateFieldsOverlay](#generatefieldsoverlay)
- [generateFruitTypeOverlay](#generatefruittypeoverlay)
- [generateGrowthStateOverlay](#generategrowthstateoverlay)
- [generateOverlay](#generateoverlay)
- [generateSingleFarmlandOverlay](#generatesinglefarmlandoverlay)
- [generateSoilStateOverlay](#generatesoilstateoverlay)
- [getDisplayCropTypes](#getdisplaycroptypes)
- [getDisplayGrowthStates](#getdisplaygrowthstates)
- [getDisplaySoilStates](#getdisplaysoilstates)
- [new](#new)
- [reset](#reset)
- [setColorBlindMode](#setcolorblindmode)
- [setMissionFruitTypes](#setmissionfruittypes)
- [update](#update)

### adjustedOverlayResolution

**Description**

> Update the map resolution depending on machine quality (settings)

**Definition**

> adjustedOverlayResolution()

**Arguments**

| any | default    |
|-----|------------|
| any | limitToTwo |

**Code**

```lua
function MapOverlayGenerator:adjustedOverlayResolution(default, limitToTwo)
    local profileClass = Utils.getPerformanceClassId()

    if profileClass < = GS_PROFILE_LOW then
        return default

        -- Do not go too big on servers to keep latency low within the engine; also avoid high memory use on consoles & mobile
    elseif profileClass > = GS_PROFILE_HIGH and not limitToTwo and not Platform.isMobile and not(g_currentMission ~ = nil and g_currentMission.missionDynamicInfo.isMultiplayer and g_currentMission:getIsServer()) then
            return { default[ 1 ] * 4 , default[ 2 ] * 4 }
        else
                return { default[ 1 ] * 2 , default[ 2 ] * 2 }
            end
        end

```

### buildFarmlandsMapOverlay

**Description**

> Build the map overlay for farm lands.

**Definition**

> buildFarmlandsMapOverlay()

**Arguments**

| any | selectedFarmland |
|-----|------------------|

**Code**

```lua
function MapOverlayGenerator:buildFarmlandsMapOverlay(selectedFarmland)
    local map = self.farmlandManager:getLocalMap()
    local farmlands = self.farmlandManager:getFarmlands()

    setOverlayColor( self.farmlandStateOverlay, 1 , 1 , 1 , MapOverlayGenerator.FARMLANDS_ALPHA)

    for k, farmland in pairs(farmlands) do
        local ownerFarmId = self.farmlandManager:getFarmlandOwner(farmland.id)

        if ownerFarmId ~ = FarmlandManager.NOT_BUYABLE_FARM_ID then
            if selectedFarmland ~ = nil and farmland.id = = selectedFarmland.id then
                setDensityMapVisualizationOverlayStateColor( self.farmlandStateOverlay, map, 0 , 0 , 0 , getBitVectorMapNumChannels(map), k, unpack( MapOverlayGenerator.COLOR.FIELD_SELECTED))
            else
                    local color = MapOverlayGenerator.COLOR.FIELD_UNOWNED
                    if farmland.isOwned then -- assign farm color
                        local ownerFarm = self.farmManager:getFarmById(ownerFarmId)
                        if ownerFarm ~ = nil then
                            color = ownerFarm:getColor()
                        end
                    end

                    setDensityMapVisualizationOverlayStateColor( self.farmlandStateOverlay, map, 0 , 0 , 0 , getBitVectorMapNumChannels(map), k, unpack(color))
                end
            end
        end

        -- No borders on small maps
        local profileClass = Utils.getPerformanceClassId()
        if profileClass > = GS_PROFILE_HIGH then
            setDensityMapVisualizationOverlayStateBorderColor( self.farmlandStateOverlay, map, 0 , getBitVectorMapNumChannels(map), MapOverlayGenerator.FARMLANDS_BORDER_THICKNESS, FarmlandManager.NOT_BUYABLE_FARM_ID, unpack( MapOverlayGenerator.COLOR.FIELD_BORDER))
        end

        self:buildFieldMapOverlay( self.farmlandStateOverlay)
    end

```

### buildFieldsOverlay

**Description**

> Build the map overlay for minimap

**Definition**

> buildFieldsOverlay()

**Arguments**

| any | fruitTypeFilter |
|-----|-----------------|

**Code**

```lua
function MapOverlayGenerator:buildFieldsOverlay(fruitTypeFilter)
    self:buildFieldMapOverlay( self.fieldsOverlay)
end

```

### buildFruitTypeMapOverlay

**Description**

> Build the map overlay for fruit types.

**Definition**

> buildFruitTypeMapOverlay()

**Arguments**

| any | fruitTypeFilter |
|-----|-----------------|

**Code**

```lua
function MapOverlayGenerator:buildFruitTypeMapOverlay(fruitTypeFilter)
    for _, displayCropType in ipairs( self.displayCropTypes) do
        if fruitTypeFilter[displayCropType.fruitTypeIndex] then
            local foliageId = displayCropType.foliageId
            if foliageId ~ = nil and foliageId ~ = 0 then
                local color = displayCropType.colors[ self.isColorBlindMode]
                local r, g, b = color:unpack()
                setDensityMapVisualizationOverlayTypeColor( self.foliageStateOverlay, foliageId, r, g, b)
            end
        end
    end
end

```

### buildGrowthStateMapOverlay

**Description**

> Build the map overlay for growth states.

**Definition**

> buildGrowthStateMapOverlay()

**Arguments**

| any | growthStateFilter |
|-----|-------------------|
| any | fruitTypeFilter   |

**Code**

```lua
function MapOverlayGenerator:buildGrowthStateMapOverlay(growthStateFilter, fruitTypeFilter)
    for _, displayCropType in ipairs( self.displayCropTypes) do
        if fruitTypeFilter[displayCropType.fruitTypeIndex] then
            local foliageId = displayCropType.foliageId
            local desc = self.fruitTypeManager:getFruitTypeByIndex(displayCropType.fruitTypeIndex)

            if desc.maxHarvestingGrowthState > = 0 then
                if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.WITHERED] then
                    if desc.witheredState ~ = nil then
                        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.WITHERED].colors[ self.isColorBlindMode][ 1 ]
                        setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, foliageId, desc.witheredState, color[ 1 ], color[ 2 ], color[ 3 ])
                    end
                end

                if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVESTED] then
                    local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVESTED].colors[ self.isColorBlindMode][ 1 ]

                    for _, cutState in pairs(desc.harvestTransitions) do
                        setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, foliageId, cutState, color[ 1 ], color[ 2 ], color[ 3 ])
                    end
                end

                if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.GROWING] then
                    local maxGrowingState = desc.minHarvestingGrowthState - 1
                    if desc.minPreparingGrowthState > = 0 then
                        maxGrowingState = math.min(maxGrowingState, desc.minPreparingGrowthState - 1 )
                    end

                    local colors = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.GROWING].colors[ self.isColorBlindMode]
                    for i = 1 , maxGrowingState do
                        -- Spready states across colors as different fruits have a different number of growth states
                        local index = math.max( math.floor(#colors / maxGrowingState * i), 1 )
                        setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, foliageId, i, colors[index][ 1 ], colors[index][ 2 ], colors[index][ 3 ])
                    end
                end

                if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.TOPPING] then
                    if desc.minPreparingGrowthState > = 0 then
                        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.TOPPING].colors[ self.isColorBlindMode][ 1 ]
                        for i = desc.minPreparingGrowthState, desc.maxPreparingGrowthState do
                            setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, foliageId, i, color[ 1 ], color[ 2 ], color[ 3 ])
                        end
                    end
                end

                if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVEST] then
                    local colors = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVEST].colors[ self.isColorBlindMode]
                    for i = desc.minHarvestingGrowthState, desc.maxHarvestingGrowthState do
                        local index = math.min(i - desc.minHarvestingGrowthState + 1 , #colors)
                        setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, foliageId, i, colors[index][ 1 ], colors[index][ 2 ], colors[index][ 3 ])
                    end
                end
            end
        end
    end

    local mission = g_currentMission
    local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)

    -- local fieldMask = 15
    local fieldMask = bit32.lshift(bit32.lshift( 1 , groundTypeNumChannels) - 1 , groundTypeFirstChannel)
    if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.CULTIVATED] then
        local cultivatorValue = FieldGroundType.getValueByType(FieldGroundType.CULTIVATED)
        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.CULTIVATED].colors[ self.isColorBlindMode][ 1 ]
        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, groundTypeMapId, 0 , fieldMask, groundTypeFirstChannel, groundTypeNumChannels, cultivatorValue, color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.PLOWED] then
        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.PLOWED].colors[ self.isColorBlindMode][ 1 ]
        local plowValue = FieldGroundType.getValueByType(FieldGroundType.PLOWED)
        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, groundTypeMapId, 0 , fieldMask, groundTypeFirstChannel, groundTypeNumChannels, plowValue, color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.STUBBLE_TILLAGE] then
        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.STUBBLE_TILLAGE].colors[ self.isColorBlindMode][ 1 ]
        local stubbleTillageValue = FieldGroundType.getValueByType(FieldGroundType.STUBBLE_TILLAGE)
        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, groundTypeMapId, 0 , fieldMask, groundTypeFirstChannel, groundTypeNumChannels, stubbleTillageValue, color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if growthStateFilter[ MapOverlayGenerator.GROWTH_STATE_INDEX.SEEDBED] then
        local color = self.displayGrowthStates[ MapOverlayGenerator.GROWTH_STATE_INDEX.SEEDBED].colors[ self.isColorBlindMode][ 1 ]
        local seedBedValue = FieldGroundType.getValueByType(FieldGroundType.SEEDBED)
        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, groundTypeMapId, 0 , fieldMask, groundTypeFirstChannel, groundTypeNumChannels, seedBedValue, color[ 1 ], color[ 2 ], color[ 3 ])
        local rolledSeedBedValue = FieldGroundType.getValueByType(FieldGroundType.ROLLED_SEEDBED)
        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, groundTypeMapId, 0 , fieldMask, groundTypeFirstChannel, groundTypeNumChannels, rolledSeedBedValue, color[ 1 ], color[ 2 ], color[ 3 ])
    end
end

```

### buildSingleFarmlandsMapOverlay

**Description**

> Build the map overlay for farm lands, where only single selected farmland is highlighted, and nothing else is
> shown/changed

**Definition**

> buildSingleFarmlandsMapOverlay()

**Arguments**

| any | selectedFarmland |
|-----|------------------|

**Code**

```lua
function MapOverlayGenerator:buildSingleFarmlandsMapOverlay(selectedFarmland)
    if selectedFarmland = = nil then
        return
    end

    local map = self.farmlandManager:getLocalMap()
    local farmlands = self.farmlandManager:getFarmlands()

    setOverlayColor( self.farmlandStateOverlay, 1 , 1 , 1 , MapOverlayGenerator.FARMLANDS_ALPHA)

    for k, farmland in pairs(farmlands) do
        if farmland.id = = selectedFarmland.id then
            setDensityMapVisualizationOverlayStateColor( self.farmlandStateOverlay, map, 0 , 0 , 0 , getBitVectorMapNumChannels(map), k, unpack( MapOverlayGenerator.COLOR.FIELD_SELECTED))
        end
    end

    self:buildFieldMapOverlay( self.farmlandStateOverlay)
end

```

### buildSoilStateMapOverlay

**Description**

> Build the map overlay for soil states.

**Definition**

> buildSoilStateMapOverlay()

**Arguments**

| any | soilStateFilter |
|-----|-----------------|

**Code**

```lua
function MapOverlayGenerator:buildSoilStateMapOverlay(soilStateFilter)
    local mission = g_currentMission
    local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)
    -- local fieldMask = 15
    local fieldMask = bit32.lshift(bit32.lshift( 1 , groundTypeNumChannels) - 1 , groundTypeFirstChannel)

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.WEEDS] and mission.missionInfo.weedsEnabled then
        local weedSystem = mission.weedSystem
        if weedSystem ~ = nil and weedSystem:getMapHasWeed() then
            local weedMapId, _, _ = weedSystem:getDensityMapData()

            local mapColor, mapColorBlind = weedSystem:getColors()
            local colors = self.isColorBlindMode and mapColorBlind or mapColor

            for k, data in ipairs(colors) do
                local stateColor = data.color
                for _, state in ipairs(data.states) do
                    setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, weedMapId, state, stateColor[ 1 ], stateColor[ 2 ], stateColor[ 3 ])
                end
            end
        end
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.STONES] and mission.missionInfo.stonesEnabled then
        local stoneSystem = mission.stoneSystem
        if stoneSystem ~ = nil and stoneSystem:getMapHasStones() then
            local stoneMapId, _, _ = stoneSystem:getDensityMapData()

            local mapColor, mapColorBlind = stoneSystem:getColors()
            local colors = self.isColorBlindMode and mapColorBlind or mapColor

            for k, data in ipairs(colors) do
                local stateColor = data.color
                for _, state in ipairs(data.states) do
                    setDensityMapVisualizationOverlayGrowthStateColor( self.foliageStateOverlay, stoneMapId, state, stateColor[ 1 ], stateColor[ 2 ], stateColor[ 3 ])
                end
            end
        end
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_PLOWING] and mission.missionInfo.plowingRequiredEnabled then
        local color = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_PLOWING].colors[ self.isColorBlindMode][ 1 ]
        local mapId, plowLevelFirstChannel, plowLevelNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.PLOW_LEVEL)

        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, mapId, groundTypeMapId, fieldMask, plowLevelFirstChannel, plowLevelNumChannels, 0 , color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_ROLLING] then
        local color = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_ROLLING].colors[ self.isColorBlindMode][ 1 ]
        local mapId, rollerLevelFirstChannel, rollerLevelNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.ROLLER_LEVEL)

        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, mapId, 0 , fieldMask, rollerLevelFirstChannel, rollerLevelNumChannels, 1 , color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.MULCHED] then
        local color = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.MULCHED].colors[ self.isColorBlindMode][ 1 ]
        local mapId, mulchFirstChannel, mulchNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.STUBBLE_SHRED_LEVEL)

        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, mapId, 0 , fieldMask, mulchFirstChannel, mulchNumChannels, 1 , color[ 1 ], color[ 2 ], color[ 3 ])
    end

    if not Platform.isMobile then
        if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_LIME] and mission.missionInfo.limeRequired then
            local color = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_LIME].colors[ self.isColorBlindMode][ 1 ]
            local mapId, limeLevelFirstChannel, limeLevelNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.LIME_LEVEL)

            setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, mapId, groundTypeMapId, fieldMask, limeLevelFirstChannel, limeLevelNumChannels, 0 , color[ 1 ], color[ 2 ], color[ 3 ])
        end
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.FERTILIZED] then
        local colors = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.FERTILIZED].colors[ self.isColorBlindMode]
        local sprayMapId, sprayLevelFirstChannel, sprayLevelNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.SPRAY_LEVEL)
        local maxSprayLevel = mission.fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
        for level = 1 , maxSprayLevel do
            local color = colors[ math.min(level, #colors)]
            setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, sprayMapId, 0 , fieldMask, sprayLevelFirstChannel, sprayLevelNumChannels, level, color[ 1 ], color[ 2 ], color[ 3 ])
        end
    end

    if soilStateFilter[ MapOverlayGenerator.SOIL_STATE_INDEX.WATERED] then
        local color = self.displaySoilStates[ MapOverlayGenerator.SOIL_STATE_INDEX.WATERED].colors[ self.isColorBlindMode][ 1 ]
        local mapId, firstChannel, numChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.WATER_LEVEL)

        setDensityMapVisualizationOverlayStateColor( self.foliageStateOverlay, mapId, 0 , fieldMask, firstChannel, numChannels, 1 , color[ 1 ], color[ 2 ], color[ 3 ])
    end
end

```

### checkOverlayFinished

**Description**

> Check if any overlay is currently being generated and triggers a callback when it's finished.

**Definition**

> checkOverlayFinished()

**Code**

```lua
function MapOverlayGenerator:checkOverlayFinished()
    if self.currentOverlayHandle ~ = nil then
        if getIsDensityMapVisualizationOverlayReady( self.currentOverlayHandle) then
            self.overlayFinishedCallback( self.currentOverlayHandle)
            self.currentOverlayHandle = nil
        end
    end
end

```

### delete

**Description**

> Delete this instance and any used overlays.

**Definition**

> delete()

**Code**

```lua
function MapOverlayGenerator:delete()
    self:reset()
    delete( self.foliageStateOverlay)
    delete( self.farmlandStateOverlay)
    delete( self.fieldsOverlay)
end

```

### generateFarmlandOverlay

**Description**

> Generate a farm land overlay.

**Definition**

> generateFarmlandOverlay(function finishedCallback, table mapPosition)

**Arguments**

| function        | finishedCallback | Called when generation is finished, signature: function(overlayId)                          |
|-----------------|------------------|---------------------------------------------------------------------------------------------|
| table           | mapPosition      | Map position vector of a selection position. If the position is within a farm land, it will |
 be highlighted. |

**Code**

```lua
function MapOverlayGenerator:generateFarmlandOverlay(finishedCallback, mapPosition)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.FARMLANDS, finishedCallback, mapPosition)
end

```

### generateFieldsOverlay

**Description**

> Generate ovrlay for minimap

**Definition**

> generateFieldsOverlay(function finishedCallback, table fruitTypeFilter)

**Arguments**

| function | finishedCallback | Called when generation is finished, signature: function(overlayId)                             |
|----------|------------------|------------------------------------------------------------------------------------------------|
| table    | fruitTypeFilter  | Map of fruit type indices to booleans. If the value is true, the fruit type will be displayed. |

**Return Values**

| table | True | if overlay generation has started, false if generation is already in progress or an invalid overlay
type has been provided |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:generateFieldsOverlay(finishedCallback)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.FIELDS, finishedCallback)
end

```

### generateFruitTypeOverlay

**Description**

> Generate a fruit type overlay.

**Definition**

> generateFruitTypeOverlay(function finishedCallback, table fruitTypeFilter)

**Arguments**

| function | finishedCallback | Called when generation is finished, signature: function(overlayId)                             |
|----------|------------------|------------------------------------------------------------------------------------------------|
| table    | fruitTypeFilter  | Map of fruit type indices to booleans. If the value is true, the fruit type will be displayed. |

**Return Values**

| table | True | if overlay generation has started, false if generation is already in progress or an invalid overlay
type has been provided |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:generateFruitTypeOverlay(finishedCallback, fruitTypeFilter)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.CROPS, finishedCallback, fruitTypeFilter)
end

```

### generateGrowthStateOverlay

**Description**

> Generate a growth state overlay.

**Definition**

> generateGrowthStateOverlay(function finishedCallback, table fruitTypeFilter, )

**Arguments**

| function                                                            | finishedCallback | Called when generation is finished, signature: function(overlayId)              |
|---------------------------------------------------------------------|------------------|---------------------------------------------------------------------------------|
| table                                                               | fruitTypeFilter  | Map of growth state indices (MapOverlayGenerator.GROWTH_STATE_INDEX members) to |
 booleans. If the value is true, the growth state will be displayed. |
| any                                                                 | fruitTypeFilter  |                                                                                 |

**Return Values**

| any | True | if overlay generation has started, false if generation is already in progress or an invalid overlay
type has been provided |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:generateGrowthStateOverlay(finishedCallback, growthStateFilter, fruitTypeFilter)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.GROWTH, finishedCallback, growthStateFilter, fruitTypeFilter)
end

```

### generateOverlay

**Description**

> Generate a map overlay of a given type.
> This is an internal generic interfacing method and should not be called externally. Consumers should use one of the
> specific public methods instead, e.g. MapOverlayGenerator:generateFruitTypeOverlay().

**Definition**

> generateOverlay(integer mapOverlayType, function finishedCallback, table overlayState, )

**Arguments**

| integer                                  | mapOverlayType   | Overlay type as one of MapOverlayGenerator.OVERLAY_TYPE.[CROPS                  | GROWTH | SOIL | FARMLANDS] |
|------------------------------------------|------------------|---------------------------------------------------------------------------------|--------|------|------------|
| function                                 | finishedCallback | Function which is called with the overlay ID as its argument when processing is |        |      |            |
 finished, signature: function(overlayId) |
| table                                    | overlayState     | Overlay state data which defines parameters (e.g. colors) of the map overlays.  |
| any                                      | overlayState2    |                                                                                 |

**Return Values**

| any | True | if overlay generation has started, false if generation is already in progress or an invalid overlay
type has been provided |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:generateOverlay(mapOverlayType, finishedCallback, overlayState, overlayState2)
    local success = true
    if self.overlayTypeCheckHash[mapOverlayType] = = nil then
        Logging.warning( "Tried generating a map overlay with an invalid overlay type: [%s]" , tostring(mapOverlayType))
        success = false
    else
            local overlayHandle = self.overlayHandles[mapOverlayType]
            self.overlayFinishedCallback = finishedCallback or NO_CALLBACK
            resetDensityMapVisualizationOverlay(overlayHandle) -- clear any previous overlay state

            self.currentOverlayHandle = overlayHandle

            local builderFunction = self.typeBuilderFunctionMap[mapOverlayType]

            builderFunction( self , overlayState, overlayState2)

            -- generate the map overlay based on the settings made in the build methods
            generateDensityMapVisualizationOverlay(overlayHandle)
            self:checkOverlayFinished() -- check now, might already be done
        end

        return success
    end

```

### generateSingleFarmlandOverlay

**Description**

> Generate a farm land overlay.

**Definition**

> generateSingleFarmlandOverlay(function finishedCallback, table mapPosition)

**Arguments**

| function        | finishedCallback | Called when generation is finished, signature: function(overlayId)                          |
|-----------------|------------------|---------------------------------------------------------------------------------------------|
| table           | mapPosition      | Map position vector of a selection position. If the position is within a farm land, it will |
 be highlighted. |

**Code**

```lua
function MapOverlayGenerator:generateSingleFarmlandOverlay(finishedCallback, mapPosition)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.FARMLAND_SINGLE, finishedCallback, mapPosition)
end

```

### generateSoilStateOverlay

**Description**

> Generate a soil state overlay.

**Definition**

> generateSoilStateOverlay(function finishedCallback, table fruitTypeFilter)

**Arguments**

| function                                                          | finishedCallback | Called when generation is finished, signature: function(overlayId)          |
|-------------------------------------------------------------------|------------------|-----------------------------------------------------------------------------|
| table                                                             | fruitTypeFilter  | Map of soil state indices (MapOverlayGenerator.SOIL_STATE_INDEX members) to |
 booleans. If the value is true, the soil state will be displayed. |

**Return Values**

| table | True | if overlay generation has started, false if generation is already in progress or an invalid overlay
type has been provided |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:generateSoilStateOverlay(finishedCallback, soilStateFilter)
    return self:generateOverlay( MapOverlayGenerator.OVERLAY_TYPE.SOIL, finishedCallback, soilStateFilter)
end

```

### getDisplayCropTypes

**Description**

> Get display information for crop types.
> Override to add new crop types or change information.

**Definition**

> getDisplayCropTypes()

**Return Values**

| table | list | of display information, {i={colors={true=[{r,g,b,a} colorblind], false=[{r,g,b,a} default],
iconFilename=path,
iconUVs={u1, v1, u2, v2, u3, v3, u4, v4}, description=text, fruitTypeIndex=index}} |
| Type | Parameter |
| |

**Code**

```lua
function MapOverlayGenerator:getDisplayCropTypes()
    local cropTypes = { }
    -- load crop type icon definitions in order of map configuration
    for _, fruitType in ipairs( self.missionFruitTypes) do
        if fruitType.shownOnMap then
            local fillableIndex = self.fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitType.fruitTypeIndex)
            local fillable = self.fillTypeManager:getFillTypeByIndex(fillableIndex)

            local iconFilename = fillable.hudOverlayFilename
            local iconUVs = Overlay.DEFAULT_UVS -- default crop type icons are separate files, use full texture
            local description = fillable.title

            table.insert(cropTypes, {
            colors = { [ false ] = fruitType.defaultColor, [ true ] = fruitType.colorBlindColor } ,
            iconFilename = iconFilename,
            iconUVs = iconUVs,
            description = description,
            fruitTypeIndex = fruitType.fruitTypeIndex,
            foliageId = fruitType.foliageId
            } )
        end
    end

    return cropTypes
end

```

### getDisplayGrowthStates

**Description**

> Get display information for growth states.
> Growth states can be represented in multiple colors per state, so colors are defined in arrays per color blind mode.
> Override to add new growth states or change information.

**Definition**

> getDisplayGrowthStates()

**Return Values**

| table | list | of display information, {i={colors={true={i={r,g,b,a}}, false={i={r,g,b,a}}}, description=text}} |
|-------|------|--------------------------------------------------------------------------------------------------|

**Code**

```lua
function MapOverlayGenerator:getDisplayGrowthStates()
    local res = {
    -- indices are contiguous, so this definition is a valid array:
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.CULTIVATED] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_CULTIVATED[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_CULTIVATED[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_CULTIVATED)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.STUBBLE_TILLAGE] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_STUBBLE_TILLAGE[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_STUBBLE_TILLAGE[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_STUBBLE_TILLAGE)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.SEEDBED] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_SEEDBED[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_SEEDBED[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_SEEDBED)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.GROWING] = {
    colors = MapOverlayGenerator.FRUIT_COLORS_GROWING,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_GROWING)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVEST] = {
    colors = MapOverlayGenerator.FRUIT_COLORS_HARVEST,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_HARVEST)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.HARVESTED] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_CUT } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_CUT }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_HARVESTED)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.TOPPING] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_REMOVE_TOPS[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_REMOVE_TOPS[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_TOPPING)
    } ,
    [ MapOverlayGenerator.GROWTH_STATE_INDEX.PLOWED] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_PLOWED[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_PLOWED[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_PLOWED)
    }
    }

    if Platform.gameplay.supportsWithering then
        res[ MapOverlayGenerator.GROWTH_STATE_INDEX.WITHERED] = {
        colors = {
        [ true ] = { MapOverlayGenerator.FRUIT_COLOR_WITHERED[ true ] } ,
        [ false ] = { MapOverlayGenerator.FRUIT_COLOR_WITHERED[ false ] }
        } ,
        description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.GROWTH_MAP_WITHERED)
        }
    end

    return res
end

```

### getDisplaySoilStates

**Description**

> Get display information for soil states.
> Soil states can be represented in multiple colors per state, so colors are defined in arrays per color blind mode.
> Override to add new soil states or change information.

**Definition**

> getDisplaySoilStates()

**Return Values**

| table | list | of display information, {i={colors={true={i={r,g,b,a}}, false={i={r,g,b,a}}}, description=text}} |
|-------|------|--------------------------------------------------------------------------------------------------|

**Code**

```lua
function MapOverlayGenerator:getDisplaySoilStates()
    local fertilizerColors = { [ true ] = { } , [ false ] = { } }
    local mission = g_currentMission

    local maxFertilizerStates = mission.fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
    for colorBlind, colors in pairs( MapOverlayGenerator.FRUIT_COLORS_FERTILIZED) do
        for i = #colors, 1 , - 1 do
            local color = colors[i]
            table.insert(fertilizerColors[colorBlind], 1 , color)

            if #fertilizerColors[colorBlind] = = maxFertilizerStates then
                break
            end
        end
    end

    local res = {
    [ MapOverlayGenerator.SOIL_STATE_INDEX.FERTILIZED] = {
    colors = fertilizerColors,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_FERTILIZED),
    isActive = true
    } ,
    }

    if Platform.gameplay.usePlowCounter and mission.missionInfo.plowingRequiredEnabled then
        res[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_PLOWING] = {
        colors = {
        [ true ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_PLOWING[ true ] } ,
        [ false ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_PLOWING[ false ] }
        } ,
        description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_NEED_PLOWING),
        isActive = mission.missionInfo.plowingRequiredEnabled
        }
    end

    if Platform.gameplay.useLimeCounter and mission.missionInfo.limeRequired then
        res[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_LIME] = {
        colors = {
        [ true ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_LIME[ true ] } ,
        [ false ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_LIME[ false ] }
        } ,
        description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_NEED_LIME),
        isActive = mission.missionInfo.limeRequired
        }
    end

    if Platform.gameplay.useRolling then
        res[ MapOverlayGenerator.SOIL_STATE_INDEX.NEEDS_ROLLING] = {
        colors = {
        [ true ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_ROLLING[ true ] } ,
        [ false ] = { MapOverlayGenerator.FRUIT_COLOR_NEEDS_ROLLING[ false ] }
        } ,
        description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_NEED_ROLLING),
        isActive = true
        }
    end

    if Platform.gameplay.useStubbleShred then
        res[ MapOverlayGenerator.SOIL_STATE_INDEX.MULCHED] = {
        colors = {
        [ true ] = { MapOverlayGenerator.FRUIT_COLOR_MULCHED[ true ] } ,
        [ false ] = { MapOverlayGenerator.FRUIT_COLOR_MULCHED[ false ] }
        } ,
        description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_MULCHED),
        isActive = true
        }
    end

    res[ MapOverlayGenerator.SOIL_STATE_INDEX.WATERED] = {
    colors = {
    [ true ] = { MapOverlayGenerator.FRUIT_COLOR_WATERED[ true ] } ,
    [ false ] = { MapOverlayGenerator.FRUIT_COLOR_WATERED[ false ] }
    } ,
    description = self.l10n:getText( MapOverlayGenerator.L10N_SYMBOL.SOIL_MAP_WATERED),
    isActive = true
    }

    local weedSystem = mission.weedSystem
    if weedSystem ~ = nil and weedSystem:getMapHasWeed() and mission.missionInfo.weedsEnabled then
        local mapColor, mapColorBlind = weedSystem:getColors()
        local description = weedSystem:getTitle() or ""

        local colors = { [ true ] = { } , [ false ] = { } }
        for k, data in ipairs(mapColor) do
            table.insert(colors[ true ], mapColorBlind[k].color)
            table.insert(colors[ false ], data.color)
        end

        res[ MapOverlayGenerator.SOIL_STATE_INDEX.WEEDS] = {
        colors = colors,
        description = description,
        isActive = mission.missionInfo.weedsEnabled
        }
    end

    local stoneSystem = mission.stoneSystem
    if stoneSystem ~ = nil and stoneSystem:getMapHasStones() and mission.missionInfo.stonesEnabled then
        local mapColor, mapColorBlind = stoneSystem:getColors()
        local description = stoneSystem:getTitle() or ""

        local colors = { [ true ] = { } , [ false ] = { } }
        for k, data in ipairs(mapColor) do
            table.insert(colors[ true ], mapColorBlind[k].color)
            table.insert(colors[ false ], data.color)
        end

        res[ MapOverlayGenerator.SOIL_STATE_INDEX.STONES] = {
        colors = colors,
        description = description,
        isActive = mission.missionInfo.stonesEnabled
        }
    end

    return res
end

```

### new

**Description**

> Create a MapOverlayGenerator instance.

**Definition**

> new(table l10n, table fruitTypeManager, table fillTypeManager, table farmlandManager, table farmManager, table
> weedSystem)

**Arguments**

| table | l10n             | I18N reference for text localization                      |
|-------|------------------|-----------------------------------------------------------|
| table | fruitTypeManager | FruitTypeManager reference for fruit type resolution      |
| table | fillTypeManager  | FillTypeManager reference for fruit fill type resolution  |
| table | farmlandManager  | FarmlandManager reference for farm land data access       |
| table | farmManager      | FarmManager reference for farm land ownership data access |
| table | weedSystem       |                                                           |

**Return Values**

| table | self |
|-------|------|

**Code**

```lua
function MapOverlayGenerator.new(l10n, fruitTypeManager, fillTypeManager, farmlandManager, farmManager, weedSystem)
    local self = setmetatable( { } , MapOverlayGenerator _mt)

    self.l10n = l10n
    self.fruitTypeManager = fruitTypeManager
    self.fillTypeManager = fillTypeManager
    self.farmlandManager = farmlandManager
    self.farmManager = farmManager

    self.missionFruitTypes = { }
    self.isColorBlindMode = nil

    self.foliageStateOverlay = createDensityMapVisualizationOverlay( "foliageState" , unpack( self:adjustedOverlayResolution( MapOverlayGenerator.OVERLAY_RESOLUTION.FOLIAGE_STATE)))
    self.farmlandStateOverlay = createDensityMapVisualizationOverlay( "farmlandState" , unpack( self:adjustedOverlayResolution( MapOverlayGenerator.OVERLAY_RESOLUTION.FARMLANDS, true )))
    self.fieldsOverlay = createDensityMapVisualizationOverlay( "fields" , unpack( self:adjustedOverlayResolution( MapOverlayGenerator.OVERLAY_RESOLUTION.FIELDS)))

    self.typeBuilderFunctionMap = {
    [ MapOverlayGenerator.OVERLAY_TYPE.CROPS] = self.buildFruitTypeMapOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.GROWTH] = self.buildGrowthStateMapOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.SOIL] = self.buildSoilStateMapOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.FARMLANDS] = self.buildFarmlandsMapOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.FIELDS] = self.buildFieldsOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.FARMLAND_SINGLE] = self.buildSingleFarmlandsMapOverlay,
    }

    self.overlayHandles = {
    [ MapOverlayGenerator.OVERLAY_TYPE.CROPS] = self.foliageStateOverlay, -- re-use this handle, these types are mutually exclusive
    [ MapOverlayGenerator.OVERLAY_TYPE.GROWTH] = self.foliageStateOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.SOIL] = self.foliageStateOverlay,
    [ MapOverlayGenerator.OVERLAY_TYPE.FARMLANDS] = self.farmlandStateOverlay, -- farmlands are separate
    [ MapOverlayGenerator.OVERLAY_TYPE.FIELDS] = self.fieldsOverlay, -- farmlands are separate
    [ MapOverlayGenerator.OVERLAY_TYPE.FARMLAND_SINGLE] = self.farmlandStateOverlay, -- farmlands are separate
    }

    self.currentOverlayHandle = nil -- handle of overlay which is currently being generated or nil if none is processing
        self.overlayFinishedCallback = NO_CALLBACK

        self.overlayTypeCheckHash = { }
        for k, v in pairs( MapOverlayGenerator.OVERLAY_TYPE) do
            self.overlayTypeCheckHash[v] = k
        end

        self.fieldColor = MapOverlayGenerator.FIELD_COLOR
        self.grassFieldColor = MapOverlayGenerator.FIELD_GRASS_COLOR

        self.fieldsRefreshTimer = 0
        self.fieldsOverlayUpdating = false

        return self
    end

```

### reset

**Description**

> Reset overlay generation state.

**Definition**

> reset()

**Code**

```lua
function MapOverlayGenerator:reset()
    resetDensityMapVisualizationOverlay( self.foliageStateOverlay)
    resetDensityMapVisualizationOverlay( self.farmlandStateOverlay)
    resetDensityMapVisualizationOverlay( self.fieldsOverlay)
    self.currentOverlayHandle = nil
end

```

### setColorBlindMode

**Description**

> Set the color blind mode for overlay creation.

**Definition**

> setColorBlindMode()

**Arguments**

| any | isColorBlindMode |
|-----|------------------|

**Code**

```lua
function MapOverlayGenerator:setColorBlindMode(isColorBlindMode)
    self.isColorBlindMode = isColorBlindMode
end

```

### setMissionFruitTypes

**Description**

> Set the valid fruit types of the current mission.

**Definition**

> setMissionFruitTypes()

**Arguments**

| any | missionFruitTypes |
|-----|-------------------|

**Code**

```lua
function MapOverlayGenerator:setMissionFruitTypes(missionFruitTypes)
    self.missionFruitTypes = { }
    for _, fruitType in ipairs(missionFruitTypes) do
        -- transfer to new data structure used to display filters:
        table.insert( self.missionFruitTypes, {
        foliageId = fruitType.terrainDataPlaneId,
        fruitTypeIndex = fruitType.index,
        shownOnMap = fruitType.shownOnMap,
        defaultColor = fruitType.defaultMapColor,
        colorBlindColor = fruitType.colorBlindMapColor
        } )
    end

    self.displayCropTypes = self:getDisplayCropTypes()
    self.displayGrowthStates = self:getDisplayGrowthStates()
    self.displaySoilStates = self:getDisplaySoilStates()
end

```

### update

**Description**

> Update the state each frame.
> Checks the overlay generation state.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function MapOverlayGenerator:update(dt)
    if not self.fieldsOverlayUpdating and g_ time > self.fieldsRefreshTimer then
        self.fieldsOverlayUpdating = true

        self:generateFieldsOverlay( function (overlayId)
            self.fieldsOverlay = overlayId
            self.fieldsOverlayIsReady = true
            self.fieldsOverlayUpdating = false
            self.fieldsRefreshTimer = g_ time + MapOverlayGenerator.FIELD_REFRESH_INTERVAL
        end )
    end

    self:checkOverlayFinished()
end

```