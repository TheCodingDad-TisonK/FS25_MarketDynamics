## FruitTypeDesc

**Description**

> FruitType

**Functions**

- [delete](#delete)
- [getAreaLiters](#getarealiters)
- [getDataPlaneInfo](#getdataplaneinfo)
- [getFilter](#getfilter)
- [getGrowthStateByName](#getgrowthstatebyname)
- [getGrowthStateGroundType](#getgrowthstategroundtype)
- [getGrowthStateName](#getgrowthstatename)
- [getHaulmLayerName](#gethaulmlayername)
- [getHaulmModifier](#gethaulmmodifier)
- [getIsCatchCrop](#getiscatchcrop)
- [getIsCut](#getiscut)
- [getIsGrowing](#getisgrowing)
- [getIsHarvestable](#getisharvestable)
- [getIsHarvestableInPeriod](#getisharvestableinperiod)
- [getIsHarvestReady](#getisharvestready)
- [getIsHoeable](#getishoeable)
- [getIsPlantableInPeriod](#getisplantableinperiod)
- [getIsPreparable](#getispreparable)
- [getIsWeedable](#getisweedable)
- [getIsWithered](#getiswithered)
- [getLayerName](#getlayername)
- [getMinHarvestingGrowthState](#getminharvestinggrowthstate)
- [getModifier](#getmodifier)
- [getNonSeasonalGrowthData](#getnonseasonalgrowthdata)
- [getRandomInitialState](#getrandominitialstate)
- [getSeasonalGrowthData](#getseasonalgrowthdata)
- [getStatsText](#getstatstext)
- [getWeedingStateText](#getweedingstatetext)
- [loadFromFoliageXMLFile](#loadfromfoliagexmlfile)
- [loadGrowth](#loadgrowth)
- [new](#new)
- [setFoliageTransformGroup](#setfoliagetransformgroup)
- [setTerrainDataPlane](#setterraindataplane)
- [setTerrainDataPlaneHaulm](#setterraindataplanehaulm)
- [setTerrainDataPlaneHaulmIndex](#setterraindataplanehaulmindex)
- [setTerrainDataPlaneIndex](#setterraindataplaneindex)
- [updatePlantSpacing](#updateplantspacing)

### delete

**Description**

**Definition**

> delete()

### getAreaLiters

**Description**

**Definition**

> getAreaLiters(integer area, boolean? windrow)

**Arguments**

| integer  | area    | area in px |
|----------|---------|------------|
| boolean? | windrow |            |

**Return Values**

| boolean? | liters |
|----------|--------|

### getDataPlaneInfo

**Description**

**Definition**

> getDataPlaneInfo()

**Return Values**

| boolean? | terrainDataPlaneId |
|----------|--------------------|
| boolean? | startStateChannel  |
| boolean? | numStateChannels   |

### getFilter

**Description**

> Get and cache DensityMapFilter for fruit type

**Definition**

> getFilter()

**Return Values**

| boolean? | fruitTypeDensityMapFilter |
|----------|---------------------------|

### getGrowthStateByName

**Description**

**Definition**

> getGrowthStateByName(string name)

**Arguments**

| string | name |
|--------|------|

**Return Values**

| string | growthState |
|--------|-------------|

### getGrowthStateGroundType

**Description**

**Definition**

> getGrowthStateGroundType(integer growthState)

**Arguments**

| integer | growthState |
|---------|-------------|

**Return Values**

| integer | groundTypeChangeType |
|---------|----------------------|

### getGrowthStateName

**Description**

**Definition**

> getGrowthStateName(integer state)

**Arguments**

| integer | state |
|---------|-------|

**Return Values**

| integer | growthStateName |
|---------|-----------------|

### getHaulmLayerName

**Description**

**Definition**

> getHaulmLayerName()

**Return Values**

| integer | haulmLayerName |
|---------|----------------|

### getHaulmModifier

**Description**

**Definition**

> getHaulmModifier()

**Return Values**

| integer | haulmModifier |
|---------|---------------|

### getIsCatchCrop

**Description**

> Defines if a fruit type is catch crop

**Definition**

> getIsCatchCrop()

**Return Values**

| integer | isCatchCrop | if a fruit type is a catch crop |
|---------|-------------|---------------------------------|

### getIsCut

**Description**

> Checks that the given growth state is equal to the cut state.

**Definition**

> getIsCut(integer growthState)

**Arguments**

| integer | growthState | The current growth state of the fruit. |
|---------|-------------|----------------------------------------|

**Return Values**

| integer | isCut | Is true if the fruit's growth state is cut; otherwise false. |
|---------|-------|--------------------------------------------------------------|

### getIsGrowing

**Description**

> Checks that the given growth state is within the growing state

**Definition**

> getIsGrowing(integer growthState)

**Arguments**

| integer | growthState | The current growth state of the fruit. |
|---------|-------------|----------------------------------------|

**Return Values**

| integer | isGrowing | Is true if the fruit's growth state is growing; otherwise false. |
|---------|-----------|------------------------------------------------------------------|

### getIsHarvestable

**Description**

> Checks that the given growth state is within the harvestable state

**Definition**

> getIsHarvestable(integer growthState)

**Arguments**

| integer | growthState | The current growth state of the fruit. |
|---------|-------------|----------------------------------------|

**Return Values**

| integer | isHarvestable | Is true if the fruit's growth state is harvestable; otherwise false. |
|---------|---------------|----------------------------------------------------------------------|

### getIsHarvestableInPeriod

**Description**

**Definition**

> getIsHarvestableInPeriod(integer growthMode, integer seasonPeriod)

**Arguments**

| integer | growthMode   | one of enum GrowthMode   |
|---------|--------------|--------------------------|
| integer | seasonPeriod | one of enum SeasonPeriod |

**Return Values**

| integer | isHarvestable |
|---------|---------------|

### getIsHarvestReady

**Description**

**Definition**

> getIsHarvestReady(integer growthState)

**Arguments**

| integer | growthState |
|---------|-------------|

**Return Values**

| integer | isHarvestReady |
|---------|----------------|

### getIsHoeable

**Description**

**Definition**

> getIsHoeable(integer growthState)

**Arguments**

| integer | growthState |
|---------|-------------|

**Return Values**

| integer | isWeedable |
|---------|------------|

### getIsPlantableInPeriod

**Description**

**Definition**

> getIsPlantableInPeriod(integer growthMode, integer seasonPeriod)

**Arguments**

| integer | growthMode   | one of enum GrowthMode   |
|---------|--------------|--------------------------|
| integer | seasonPeriod | one of enum SeasonPeriod |

**Return Values**

| integer | isPlantable |
|---------|-------------|

### getIsPreparable

**Description**

> Checks that the given growth state is within the harvest preparation state.

**Definition**

> getIsPreparable(integer growthState)

**Arguments**

| integer | growthState | The current growth state of the fruit. |
|---------|-------------|----------------------------------------|

**Return Values**

| integer | isPreparableForHarvest | Is true if the fruit's growth state is preparable for harvest; otherwise false. |
|---------|------------------------|---------------------------------------------------------------------------------|

### getIsWeedable

**Description**

**Definition**

> getIsWeedable(integer growthState)

**Arguments**

| integer | growthState |
|---------|-------------|

**Return Values**

| integer | isWeedable |
|---------|------------|

### getIsWithered

**Description**

> Checks that the given growth state is withered

**Definition**

> getIsWithered(integer growthState)

**Arguments**

| integer | growthState | The current growth state of the fruit. |
|---------|-------------|----------------------------------------|

**Return Values**

| integer | isWithered | Is true if the fruit's growth state is withered; otherwise false. |
|---------|------------|-------------------------------------------------------------------|

### getLayerName

**Description**

**Definition**

> getLayerName()

**Return Values**

| integer | layerName |
|---------|-----------|

### getMinHarvestingGrowthState

**Description**

**Definition**

> getMinHarvestingGrowthState()

**Return Values**

| integer | minHarvestingGrowthState |
|---------|--------------------------|

### getModifier

**Description**

**Definition**

> getModifier()

**Return Values**

| integer | modifier |
|---------|----------|

### getNonSeasonalGrowthData

**Description**

**Definition**

> getNonSeasonalGrowthData()

**Return Values**

| integer | growthDataNonSeasonal |
|---------|-----------------------|

### getRandomInitialState

**Description**

**Definition**

> getRandomInitialState(integer growthMode)

**Arguments**

| integer | growthMode | one of enum GrowthMode |
|---------|------------|------------------------|

**Return Values**

| integer | grwothState |
|---------|-------------|

### getSeasonalGrowthData

**Description**

**Definition**

> getSeasonalGrowthData()

**Return Values**

| integer | growthDataSeasonal |
|---------|--------------------|

### getStatsText

**Description**

**Definition**

> getStatsText()

**Return Values**

| integer | statsText |
|---------|-----------|

### getWeedingStateText

**Description**

**Definition**

> getWeedingStateText()

**Return Values**

| integer | stateText |
|---------|-----------|

### loadFromFoliageXMLFile

**Description**

**Definition**

> loadFromFoliageXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename |
|--------|-------------|

**Return Values**

| string | success |
|--------|---------|

**Code**

```lua
function FruitTypeDesc:loadFromFoliageXMLFile(xmlFilename)
    local xmlFile = XMLFile.load( "foliageXml" , xmlFilename)
    if xmlFile = = nil then
        return false
    end

    local key = "foliageType.fruitType"
    local foliageKey = "foliageType.foliageLayer(0)"

    local name = xmlFile:getString(key .. "#name" )
    if name = = nil then
        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Missing fruitType name" )
        xmlFile:delete()
        return false
    end

    if not ClassUtil.getIsValidIndexName(name) then
        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile: '%s' is not a valid name for a fruitType.Ignoring fruitType!" , self.name)
            xmlFile:delete()
            return false
        end

        local upperName = string.upper(name)
        self.xmlFilename = xmlFilename
        self.name = upperName
        self.layerName = name

        local fillType = g_fillTypeManager:getFillTypeByName(upperName)
        if fillType = = nil then
            Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Missing fillType '%s' for fruitType definition.Ignoring fruitType!" , name)
                xmlFile:delete()
                return false
            end

            self.fillType = fillType

            self.shownOnMap = xmlFile:getBool(key .. "#shownOnMap" , true )
            self.useForFieldMissions = xmlFile:getBool(key .. "#useForFieldMissions" , true )
            self.missionMultiplier = xmlFile:getFloat(key .. "#missionMultiplier" , 1 )
            self.isCatchCrop = xmlFile:getBool(key .. "#isCatchCrop" )
            self.defaultMapColor = Color.parseFromString(xmlFile:getString(key .. ".mapColors#default" , "1 1 1 1" ))
            self.colorBlindMapColor = Color.parseFromString(xmlFile:getString(key .. ".mapColors#colorBlind" , "1 1 1 1" ))

            self.startStateChannel = xmlFile:getInt(foliageKey .. "#densityMapChannelOffset" , 0 )
            self.numStateChannels = xmlFile:getInt(foliageKey .. "#numDensityMapChannels" , 4 )
            self.alignsToSun = xmlFile:getBool(foliageKey .. "#alignsToSun" , false )

            self.numBlocksPerUnit = xmlFile:getFloat(foliageKey .. "#numBlocksPerUnit" )
            self.plantSeparation = xmlFile:getVector(foliageKey .. "#plantSeparation" , nil , 2 )
            self.plantOffset = xmlFile:getVector(foliageKey .. "#plantOffset" , nil , 2 )

            self:updatePlantSpacing()

            local startStateChannelHaulm = xmlFile:getInt( "foliageType.foliageLayer(1)#densityMapChannelOffset" , nil )
            if startStateChannelHaulm ~ = nil then
                self.startStateChannelHaulm = startStateChannelHaulm - self.numStateChannels
                self.numStateChannelsHaulm = xmlFile:getInt( "foliageType.foliageLayer(1)#numDensityMapChannels" , 1 )
            end

            self.fieldCourseLineHeightByGrowthState = { }

            local numGrowthStates = 0
            local cultivationStates = { }
            local hasProhibitedCultivationStates = false
            for k, foliageStateKey in xmlFile:iterator(foliageKey .. ".foliageState" ) do
                local foliageStateName = xmlFile:getString(foliageStateKey .. "#name" )
                self.growthStateToName[k] = foliageStateName
                self.nameToGrowthState[ string.upper(foliageStateName)] = k

                if xmlFile:getBool(foliageStateKey .. "#isHarvestReady" ) then
                    if self.minHarvestingGrowthState = = 0 then
                        self.minHarvestingGrowthState = k
                    end
                    self.maxHarvestingGrowthState = k
                    self.yieldScales[k] = xmlFile:getFloat(foliageStateKey .. "#yieldScale" , 1 )
                end

                if xmlFile:getBool(foliageStateKey .. "#isForageReady" ) then
                    if self.minForageGrowthState = = 0 then
                        self.minForageGrowthState = k
                    end
                    self.maxForageGrowthState = k
                end

                if xmlFile:getBool(foliageStateKey .. "#isCut" ) then
                    self.cutStates[k] = true
                    self.cutState = k
                end

                if xmlFile:getBool(foliageStateKey .. "#isWithered" ) then
                    if self.witheredState ~ = nil then
                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:WitheredState already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.witheredState], foliageStateName)
                        end
                        self.witheredState = k
                    end

                    if xmlFile:getBool(foliageStateKey .. "#isGrowing" ) then
                        numGrowthStates = numGrowthStates + 1
                    end

                    local groundTypeName = xmlFile:getString(foliageStateKey .. "#groundType" )
                    if groundTypeName ~ = nil then
                        local groundType = FieldGroundType.getByName(groundTypeName)
                        if groundType ~ = nil then
                            if self.groundTypeChangeGrowthState ~ = - 1 then
                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:GroundType change already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.groundTypeChangeGrowthState], foliageStateName)
                                end

                                self.groundTypeChangeGrowthState = k
                                self.groundTypeChangeType = groundType
                            else
                                    Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Invalid groundType name '%s' for foliage state '%s'.Ignoring it!" , groundTypeName, foliageStateName)
                                    end
                                end

                                local groundTypeChangeMaskString = xmlFile:getString(foliageStateKey .. "#groundTypeMask" )
                                if groundTypeChangeMaskString ~ = nil then
                                    local groundTypeChangeMaskList = groundTypeChangeMaskString:split( " " )
                                    for _, groundTypeMaskName in ipairs(groundTypeChangeMaskList) do
                                        local groundType = FieldGroundType.getByName(groundTypeMaskName)
                                        if groundType ~ = nil then
                                            table.insert( self.groundTypeChangeMaskTypes, groundType)
                                        else
                                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Invalid groundTypeChangeMask name '%s' for foliage state '%s'.Ignoring it!" , groundTypeMaskName, foliageStateName)
                                                end
                                            end
                                        end

                                        if xmlFile:getBool(foliageStateKey .. "#allowsWeeding" ) then
                                            if self.minWeederState = = 0 then
                                                self.minWeederState = k
                                            end
                                            self.maxWeederState = k
                                        end

                                        if xmlFile:getBool(foliageStateKey .. "#allowsHoeing" ) then
                                            if self.minWeederHoeState = = 0 then
                                                self.minWeederHoeState = k
                                            end
                                            self.maxWeederHoeState = k
                                        end

                                        if xmlFile:getBool(foliageStateKey .. "#regrowthStart" ) then
                                            if self.regrows then
                                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:RegrowthStart already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.firstRegrowthState], foliageStateName)
                                                end
                                                self.firstRegrowthState = k
                                                self.regrows = true
                                            end

                                            if xmlFile:getBool(foliageStateKey .. "#isDestructibleByWheel" ) then
                                                if self.minWheelDestructionState = = nil then
                                                    self.minWheelDestructionState = k
                                                end
                                                self.maxWheelDestructionState = k
                                            end

                                            if xmlFile:getBool(foliageStateKey .. "#isDestructedByWheel" ) then
                                                if self.wheelDestructionState ~ = nil then
                                                    Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Wheel destructed state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.wheelDestructionState], foliageStateName)
                                                    end
                                                    self.wheelDestructionState = k
                                                end

                                                if xmlFile:getBool(foliageStateKey .. "#isDestructibleByDisaster" ) then
                                                    if self.minDisasterDestructionState = = nil then
                                                        self.minDisasterDestructionState = k
                                                    end
                                                    self.maxDisasterDestructionState = k
                                                end

                                                if xmlFile:getBool(foliageStateKey .. "#isDestructedByDisaster" ) then
                                                    if self.disasterDestructionState ~ = 0 then
                                                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Disaster destructed state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.disasterDestructionState], foliageStateName)
                                                        end
                                                        self.disasterDestructionState = k
                                                    end

                                                    if xmlFile:getBool(foliageStateKey .. "#isPreparable" ) then
                                                        if self.minPreparingGrowthState = = - 1 then
                                                            self.minPreparingGrowthState = k
                                                        end
                                                        self.maxPreparingGrowthState = k
                                                    end

                                                    if xmlFile:getBool(foliageStateKey .. "#isPrepared" ) then
                                                        if self.preparedGrowthState ~ = - 1 then
                                                            Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Prepared state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.preparedGrowthState], foliageStateName)
                                                            end
                                                            self.preparedGrowthState = k
                                                        end

                                                        if xmlFile:getBool(foliageStateKey .. "#isWeed" ) then
                                                            if self.harvestWeedState ~ = - 1 then
                                                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Harvested weed state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.harvestWeedState], foliageStateName)
                                                                end
                                                                self.harvestWeedState = k
                                                            end

                                                            if xmlFile:getBool(foliageStateKey .. "#isMulched" ) then
                                                                if self.mulchedState ~ = 0 then
                                                                    Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Mulched state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.mulchedState], foliageStateName)
                                                                    end
                                                                    self.mulchedState = k
                                                                end

                                                                if xmlFile:getBool(foliageStateKey .. "#isRolledCut" ) then
                                                                    if self.rolledCutState ~ = 0 then
                                                                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Rolled cut state already defined for foliage state '%s'.Overwriting it with '%s'!" , self.growthStateToName[ self.rolledCutState], foliageStateName)
                                                                        end
                                                                        self.rolledCutState = k
                                                                    end

                                                                    if xmlFile:getBool(foliageStateKey .. "#isCultivatable" , true ) then
                                                                        table.insert(cultivationStates, k)
                                                                    else
                                                                            hasProhibitedCultivationStates = true
                                                                        end

                                                                        local minWaterLitersPerSqm = xmlFile:getFloat(foliageStateKey .. "#minWaterLitersPerSqm" )
                                                                        if minWaterLitersPerSqm ~ = nil then
                                                                            self.minWaterLitersPerSqm = self.minWaterLitersPerSqm or { }
                                                                            self.minWaterLitersPerSqm[k] = minWaterLitersPerSqm
                                                                        end
                                                                        local maxWaterLitersPerSqm = xmlFile:getFloat(foliageStateKey .. "#maxWaterLitersPerSqm" )
                                                                        if maxWaterLitersPerSqm ~ = nil then
                                                                            self.maxWaterLitersPerSqm = self.maxWaterLitersPerSqm or { }
                                                                            self.maxWaterLitersPerSqm[k] = maxWaterLitersPerSqm
                                                                        end

                                                                        local penaltyStateName = xmlFile:getString(foliageStateKey .. "#penaltyStateName" )
                                                                        if penaltyStateName ~ = nil then
                                                                            self.penaltyStateName = self.penaltyStateName or { }
                                                                            self.penaltyStateName[k] = penaltyStateName
                                                                        end

                                                                        local penaltyPercentage = xmlFile:getFloat(foliageStateKey .. "#penaltyPercentage" )
                                                                        if penaltyPercentage ~ = nil then
                                                                            self.penaltyPercentage = self.penaltyPercentage or { }
                                                                            self.penaltyPercentage[k] = penaltyPercentage
                                                                        end

                                                                        local fieldCourseLineHeight = xmlFile:getFloat(foliageStateKey .. "#fieldCourseLineHeight" )
                                                                        self.fieldCourseLineHeightByGrowthState[k] = fieldCourseLineHeight
                                                                    end

                                                                    self.numGrowthStates = numGrowthStates
                                                                    self.numFoliageStates = # self.growthStateToName

                                                                    if hasProhibitedCultivationStates then
                                                                        self.cultivationStates = cultivationStates
                                                                    end

                                                                    -- valiade wheel destruction has a target state
                                                                    if self.maxWheelDestructionState ~ = nil and self.wheelDestructionState = = nil then
                                                                        Logging.xmlWarning(xmlFile, "Fruit has states where 'isDestructibleByWheel' is true but does not specify a state where 'isDestructedByWheel' (state to change to when destruction occurs) is true" )
                                                                        self.minWheelDestructionState = nil
                                                                        self.maxWheelDestructionState = nil
                                                                    end

                                                                    -- validate disaster destruction has a target state
                                                                    if self.maxDisasterDestructionState ~ = nil and self.disasterDestructionState = = nil then
                                                                        Logging.xmlWarning(xmlFile, "Fruit has states where 'isDestructibleByDisaster' is true but does not specify a state where 'isDestructedByDisaster' (state to change to when disaster occurs) is true" )
                                                                        self.minDisasterDestructionState = nil
                                                                        self.maxDisasterDestructionState = nil
                                                                    end

                                                                    self.literPerSqm = xmlFile:getFloat(key .. ".harvest#litersPerSqm" , 0 )
                                                                    self.cutHeight = xmlFile:getFloat(key .. ".harvest#cutHeight" , 0.15 )
                                                                    self.forageCutHeight = xmlFile:getFloat(key .. ".harvest#forageCutHeight" , self.forageCutHeight)
                                                                    self.beeYieldBonusPercentage = xmlFile:getFloat(key .. ".harvest#beeYieldBonusPercentage" , 0 )

                                                                    local harvestGroundTypeName = xmlFile:getString(key .. ".harvest#groundType" )
                                                                    if harvestGroundTypeName ~ = nil then
                                                                        local groundType = FieldGroundType.getByName(harvestGroundTypeName)
                                                                        if groundType ~ = nil then
                                                                            self.harvestGroundType = groundType
                                                                        else
                                                                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Invalid harvest ground type name '%s'" , harvestGroundTypeName)
                                                                            end
                                                                        end

                                                                        -- TODO refactor ChopperType
                                                                        local chopperGroundTypeName = xmlFile:getString(key .. ".harvest#chopperType" )
                                                                        if chopperGroundTypeName ~ = nil then
                                                                            local chopperType = FieldChopperType.getByName(chopperGroundTypeName)
                                                                            if chopperType ~ = nil then
                                                                                self.chopperType = chopperType
                                                                            else
                                                                                    Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Invalid chopperType name '%s'" , chopperGroundTypeName)
                                                                                end
                                                                            end

                                                                            self.chopperUseHaulm = xmlFile:getBool(key .. ".harvest#chopperUseHaulm" , false )

                                                                            self.resetsSpray = xmlFile:getBool(key .. ".growth#resetsSpray" , true )
                                                                            self.growthRequiresLime = xmlFile:getBool(key .. ".growth#requiresLime" , true )

                                                                            self.increasesSoilDensity = xmlFile:getBool(key .. ".soil#increasesDensity" , false )
                                                                            self.lowSoilDensityRequired = xmlFile:getBool(key .. ".soil#lowDensityRequired" , true )
                                                                            self.consumesLime = xmlFile:getBool(key .. ".soil#consumesLime" , true )
                                                                            self.startSprayLevel = xmlFile:getInt(key .. ".soil#startSprayLevel" , 0 )

                                                                            self.seedUsagePerSqm = xmlFile:getFloat(key .. ".seeding#litersPerSqm" , 0.1 )
                                                                            self.allowsSeeding = xmlFile:getBool(key .. ".seeding#isAvailable" , true )
                                                                            self.needsRolling = xmlFile:getBool(key .. ".seeding#needsRolling" , true )
                                                                            self.directionSnapAngle = math.rad(xmlFile:getFloat(key .. ".seeding#directionSnapAngle" , 0 ))
                                                                            self.plantsWeed = xmlFile:getBool(key .. ".seeding#plantsWeed" , true )
                                                                            self.defaultSowingGroundType = xmlFile:getString(key .. ".seeding#defaultSowingGroundType" )

                                                                            local requiredFieldType = xmlFile:getString(key .. ".seeding#requiredFieldType" , nil )
                                                                            local fieldType = FieldType.getByName(requiredFieldType)
                                                                            if fieldType ~ = nil then
                                                                                self.seedRequiredFieldType = fieldType
                                                                            end

                                                                            self.isCultivationAllowed = xmlFile:getBool(key .. ".cultivation#isAllowed" , true )

                                                                            self.limitDestructionToField = xmlFile:getBool(key .. ".destruction#limitToField" , true )

                                                                            local windrowFillTypeName = xmlFile:getString(key .. ".windrow#fillType" )
                                                                            if windrowFillTypeName ~ = nil then
                                                                                local windrowFillType = g_fillTypeManager:getFillTypeByName(windrowFillTypeName)
                                                                                if windrowFillType ~ = nil then
                                                                                    self.hasWindrow = true
                                                                                    self.windrowFillType = windrowFillType
                                                                                    self.windrowName = windrowFillType.name
                                                                                else
                                                                                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:FruitType windrow fillType '%s' not defined for '%s'.Ignoring windrow!" , windrowFillTypeName, key)
                                                                                        end
                                                                                    end

                                                                                    local windrowCutFillTypeName = xmlFile:getString(key .. ".windrow#cutFillType" )
                                                                                    if windrowCutFillTypeName ~ = nil then
                                                                                        local windrowCutFillType = g_fillTypeManager:getFillTypeByName(windrowCutFillTypeName)
                                                                                        if windrowCutFillType ~ = nil then
                                                                                            self.windrowCutFillType = windrowCutFillType
                                                                                            self.windrowCutFactor = xmlFile:getFloat(key .. ".windrow#windrowCutFactor" , 1 )
                                                                                        else
                                                                                                Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:FruitType windrow cut fillType '%s' not defined for '%s'.Ignoring windrow!" , windrowCutFillTypeName, key)
                                                                                                end
                                                                                            end

                                                                                            -- liters per sqm independent of fillType, as we might have the cutted version as fill type that is available with the windrower
                                                                                            self.windrowLiterPerSqm = xmlFile:getFloat(key .. ".windrow#litersPerSqm" )

                                                                                            local mulcherChopperTypeName = xmlFile:getString(key .. ".mulcher#chopperType" )
                                                                                            if mulcherChopperTypeName ~ = nil then
                                                                                                local mulcherChopperType = FieldChopperType.getByName(mulcherChopperTypeName)
                                                                                                if mulcherChopperType ~ = nil then
                                                                                                    self.mulcherChopperType = mulcherChopperType
                                                                                                else
                                                                                                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:Invalid mulcher chopperTypeName name '%s'" , mulcherChopperTypeName)
                                                                                                    end
                                                                                                end

                                                                                                self.haulmLayerName = xmlFile:getString(key .. ".haulm#layerName" )

                                                                                                local transitions
                                                                                                for _, transitionKey in xmlFile:iterator(key .. ".harvest.transition" ) do
                                                                                                    local srcStateName = xmlFile:getString(transitionKey .. "#src" )
                                                                                                    local targetStateName = xmlFile:getString(transitionKey .. "#target" )

                                                                                                    local srcState = self:getGrowthStateByName(srcStateName)
                                                                                                    if srcState = = nil then
                                                                                                        Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:foliage state '%s' is not defined for harvest transition '%s'" , srcStateName, transitionKey)
                                                                                                            break
                                                                                                        end
                                                                                                        local targetState = self:getGrowthStateByName(targetStateName)
                                                                                                        if targetState = = nil then
                                                                                                            Logging.xmlWarning(xmlFile, "FruitTypeDesc.loadFromFoliageXMLFile:foliage state '%s' is not defined for harvest transition '%s'" , targetStateName, transitionKey)
                                                                                                                break
                                                                                                            end

                                                                                                            if srcState ~ = nil and targetState ~ = nil then
                                                                                                                if transitions = = nil then
                                                                                                                    transitions = { }
                                                                                                                end

                                                                                                                transitions[srcState] = targetState
                                                                                                            end
                                                                                                        end

                                                                                                        if transitions = = nil then
                                                                                                            --#debug assert(self.minForageGrowthState ~ = 0 or self.minHarvestingGrowthState ~ = 0, string.format("FruitTypeDesc:No growthState with 'isForageReady' or 'isHarvestable' attribute defined for fruit '%s'!", self.name))

                                                                                                                transitions = { }
                                                                                                                if self.minForageGrowthState ~ = 0 then
                                                                                                                    for i = self.minForageGrowthState, self.maxForageGrowthState do
                                                                                                                        transitions[i] = self.cutState
                                                                                                                    end
                                                                                                                end

                                                                                                                if self.minHarvestingGrowthState ~ = 0 then
                                                                                                                    for i = self.minHarvestingGrowthState, self.maxHarvestingGrowthState do
                                                                                                                        transitions[i] = self.cutState
                                                                                                                    end
                                                                                                                end
                                                                                                            end

                                                                                                            local harvestReadyTransitions = { }
                                                                                                            if self.minHarvestingGrowthState ~ = 0 then
                                                                                                                for i = self.minHarvestingGrowthState, self.maxHarvestingGrowthState do
                                                                                                                    harvestReadyTransitions[i] = self.cutState
                                                                                                                end
                                                                                                            end

                                                                                                            self.harvestTransitions = transitions
                                                                                                            self.harvestReadyTransitions = harvestReadyTransitions

                                                                                                            self:loadGrowth(xmlFile, "foliageType.growth" )

                                                                                                            xmlFile:delete()

                                                                                                            return true
                                                                                                        end

```

### loadGrowth

**Description**

**Definition**

> loadGrowth(XMLFile xmlFile, string key)

**Arguments**

| XMLFile | xmlFile |
|---------|---------|
| string  | key     |

### new

**Description**

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function FruitTypeDesc.new(customMt)
    local self = setmetatable( { } , customMt or FruitTypeDesc _mt)

    self.index = nil -- set by FruitTypeManager

    self.modifier = nil

    self.name = nil
    self.layerName = nil
    self.shownOnMap = false
    self.useForFieldMissions = true
    self.missionMultiplier = 1
    self.growthStateToName = { }
    self.nameToGrowthState = { }
    self.startStateChannel = 0
    self.numStateChannels = 4
    self.startStateChannelHaulm = 0
    self.numStateChannelsHaulm = 1
    self.alignsToSun = false
    self.plantSpacing = 1
    self.fillType = nil
    self.defaultSowingGroundType = nil

    self.isCatchCrop = false

    self.yieldScales = { }
    self.minHarvestingGrowthState = 0
    self.maxHarvestingGrowthState = 0
    self.minForageGrowthState = 0
    self.maxForageGrowthState = 0
    self.cutState = 0
    self.cutStates = { }
    self.witheredState = nil
    self.harvestWeedState = - 1
    self.mulchedState = 0
    self.rolledCutState = 0

    self.minWheelDestructionState = nil
    self.maxWheelDestructionState = nil
    self.wheelDestructionState = nil

    self.minDisasterDestructionState = nil
    self.maxDisasterDestructionState = nil
    self.disasterDestructionState = 0

    self.minPreparingGrowthState = - 1
    self.maxPreparingGrowthState = - 1
    self.preparedGrowthState = - 1

    self.groundTypeChangeGrowthState = - 1
    self.groundTypeChangeType = nil
    self.groundTypeChangeMaskTypes = { }

    self.minWeederState = 0
    self.maxWeederState = 0
    self.minWeederHoeState = 0
    self.maxWeederHoeState = 0

    self.regrows = false
    self.firstRegrowthState = 1

    return self
end

```

### setFoliageTransformGroup

**Description**

**Definition**

> setFoliageTransformGroup(entityId id)

**Arguments**

| entityId | id |
|----------|----|

### setTerrainDataPlane

**Description**

**Definition**

> setTerrainDataPlane(entityId id)

**Arguments**

| entityId | id |
|----------|----|

### setTerrainDataPlaneHaulm

**Description**

**Definition**

> setTerrainDataPlaneHaulm(entityId id)

**Arguments**

| entityId | id |
|----------|----|

### setTerrainDataPlaneHaulmIndex

**Description**

**Definition**

> setTerrainDataPlaneHaulmIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

### setTerrainDataPlaneIndex

**Description**

**Definition**

> setTerrainDataPlaneIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

### updatePlantSpacing

**Description**

**Definition**

> updatePlantSpacing()