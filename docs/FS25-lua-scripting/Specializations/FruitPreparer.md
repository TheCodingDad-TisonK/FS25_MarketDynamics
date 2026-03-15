## FruitPreparer

**Description**

> Specialization for tools preparing the fruits for harvesting e.g. potato haulm toppers and sugar beet defoliators

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAllowCutterAIFruitRequirements](#getallowcutteraifruitrequirements)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDoGroundManipulation](#getdogroundmanipulation)
- [getIsRandomlyMovingPartActive](#getisrandomlymovingpartactive)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadRandomlyMovingPartFromXML](#loadrandomlymovingpartfromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onReadUpdateStream](#onreadupdatestream)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processFruitPreparerArea](#processfruitpreparerarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### doCheckSpeedLimit

**Description**

> Returns if speed limit should be checked

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | checkSpeedlimit | check speed limit |
|-----|-----------------|-------------------|

**Code**

```lua
function FruitPreparer:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and( self.getIsImplementChainLowered = = nil or self:getIsImplementChainLowered()))
end

```

### getAllowCutterAIFruitRequirements

**Description**

**Definition**

> getAllowCutterAIFruitRequirements()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FruitPreparer:getAllowCutterAIFruitRequirements(superFunc)
    return false
end

```

### getDefaultSpeedLimit

**Description**

> Returns default speed limit

**Definition**

> getDefaultSpeedLimit()

**Return Values**

| any | speedLimit | speed limit |
|-----|------------|-------------|

**Code**

```lua
function FruitPreparer.getDefaultSpeedLimit()
    return 15
end

```

### getDirtMultiplier

**Description**

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FruitPreparer:getDirtMultiplier(superFunc)
    local spec = self.spec_fruitPreparer

    if spec.isWorking then
        return superFunc( self ) + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return superFunc( self )
end

```

### getDoGroundManipulation

**Description**

> Returns if tool does ground manipulation

**Definition**

> getDoGroundManipulation()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | doGroundManipulation | do ground manipulation |
|-----|----------------------|------------------------|

**Code**

```lua
function FruitPreparer:getDoGroundManipulation(superFunc)
    local spec = self.spec_fruitPreparer
    return superFunc( self ) and spec.isWorking
end

```

### getIsRandomlyMovingPartActive

**Description**

**Definition**

> getIsRandomlyMovingPartActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | part      |

**Code**

```lua
function FruitPreparer:getIsRandomlyMovingPartActive(superFunc, part)
    local retValue = superFunc( self , part)

    if part.moveOnlyIfPreparerCut then
        retValue = retValue and self.spec_fruitPreparer.isWorking
    end

    return retValue
end

```

### getWearMultiplier

**Description**

**Definition**

> getWearMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FruitPreparer:getWearMultiplier(superFunc)
    local spec = self.spec_fruitPreparer

    if spec.isWorking then
        return superFunc( self ) + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function FruitPreparer.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "fruitPreparer" , false , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FruitPreparer" )

    schema:register(XMLValueType.STRING, "vehicle.fruitPreparer#fruitType" , "Fruit type" )
    schema:register(XMLValueType.STRING_LIST, "vehicle.fruitPreparer#fruitTypes" , "List of preparing fruit types separated by whitespace" )
    schema:register(XMLValueType.BOOL, "vehicle.fruitPreparer#aiUsePreparedState" , "AI uses prepared state instead of unprepared state" , "true if vehicle has also the Cutter specialization" )

        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".fruitPreparer#dropWorkAreaIndex" , "Drop area index" )
        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".fruitPreparer#dropWorkAreaIndex" , "Drop area index" )

        AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.fruitPreparer.animationNodes" )
        SoundManager.registerSampleXMLPaths(schema, "vehicle.fruitPreparer.sounds" , "work" )

        schema:register(XMLValueType.BOOL, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#moveOnlyIfPreparerCut" , "Move only if fruit preparer cuts something" , false )

            schema:setXMLSpecializationType()
        end

```

### loadRandomlyMovingPartFromXML

**Description**

**Definition**

> loadRandomlyMovingPartFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | part      |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function FruitPreparer:loadRandomlyMovingPartFromXML(superFunc, part, xmlFile, key)
    local retValue = superFunc( self , part, xmlFile, key)

    part.moveOnlyIfPreparerCut = xmlFile:getValue(key .. "#moveOnlyIfPreparerCut" , false )

    return retValue
end

```

### loadWorkAreaFromXML

**Description**

> Loads work areas from xml

**Definition**

> loadWorkAreaFromXML(table workArea, XMLFile xmlFile, string key, )

**Arguments**

| table   | workArea | workArea         |
|---------|----------|------------------|
| XMLFile | xmlFile  | XMLFile instance |
| string  | key      | key              |
| any     | key      |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function FruitPreparer:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.FRUITPREPARER then
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#dropStartIndex" , key .. ".fruitPreparer#dropWorkAreaIndex" ) -- FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#dropWidthIndex" , key .. ".fruitPreparer#dropWorkAreaIndex" ) -- FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#dropHeightIndex" , key .. ".fruitPreparer#dropWorkAreaIndex" ) -- FS17 to FS19

        workArea.dropWorkAreaIndex = xmlFile:getValue(key .. ".fruitPreparer#dropWorkAreaIndex" )
    end

    return retValue
end

```

### onAIFieldCourseSettingsInitialized

**Description**

**Definition**

> onAIFieldCourseSettingsInitialized()

**Arguments**

| any | fieldCourseSettings |
|-----|---------------------|

**Code**

```lua
function FruitPreparer:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function FruitPreparer:onDelete()
    local spec = self.spec_fruitPreparer
    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function FruitPreparer:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local spec = self.spec_fruitPreparer
        local isWorking = g_ time - spec.lastWorkTime < 500
        if isWorking ~ = spec.isWorking then
            self:raiseDirtyFlags(spec.dirtyFlag)
            spec.isWorking = isWorking
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
function FruitPreparer:onLoad(savegame)
    local spec = self.spec_fruitPreparer

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnOnAnimation#name" , "vehicle.turnOnVehicle.turnedAnimation#name" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnOnAnimation#speed" , "vehicle.turnOnVehicle.turnedAnimation#turnOnSpeedScale" ) -- FS15 to FS17

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fruitPreparer#useReelStateToTurnOn" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fruitPreparer#onlyActiveWhenLowered" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.vehicle.fruitPreparerSound" , "vehicle.fruitPreparer.sounds.work" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode" , "vehicle.fruitPreparer.animationNodes.animationNode" , "fruitPreparer" ) -- FS17 to FS19

    if self.isClient then
        spec.samples = { }
        spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.fruitPreparer.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.fruitPreparer.animationNodes" , self.components, self , self.i3dMappings)
    end

    spec.fruitTypes = { }
    local fruitTypes = self.xmlFile:getValue( "vehicle.fruitPreparer#fruitTypes" , { } , true )

    local fruitType = self.xmlFile:getValue( "vehicle.fruitPreparer#fruitType" )
    if fruitType ~ = nil then
        table.insert(fruitTypes, fruitType)
    end

    if #fruitTypes > 0 then
        for _, fruitType in ipairs(fruitTypes) do
            local desc = g_fruitTypeManager:getFruitTypeByName(fruitType)
            if desc ~ = nil then
                table.insert(spec.fruitTypes, desc.index)

                if self.setAIFruitRequirements ~ = nil then
                    if desc.minPreparingGrowthState ~ = - 1 then
                        self:setAIFruitRequirements(desc.index, desc.minPreparingGrowthState, desc.maxPreparingGrowthState)

                        local aiUsePreparedState = self.xmlFile:getValue( "vehicle.fruitPreparer#aiUsePreparedState" , self.spec_cutter ~ = nil )
                        if aiUsePreparedState then
                            self:addAIFruitRequirement(desc.index, desc.preparedGrowthState, desc.preparedGrowthState)
                        end
                    else
                            local minState = spec.allowsForageGrowthState and desc.minForageGrowthState or desc.minHarvestingGrowthState
                            self:addAIFruitRequirement(desc.index, minState, desc.maxHarvestingGrowthState)
                        end
                    end
                else
                        Logging.xmlWarning( self.xmlFile, "Unable to find fruitType '%s' in fruitPreparer" , fruitType)
                    end
                end
            else
                    Logging.xmlWarning( self.xmlFile, "Missing fruitType in fruitPreparer" )
                end

                spec.isWorking = false
                spec.lastWorkTime = - math.huge

                spec.dirtyFlag = self:getNextDirtyFlag()
            end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function FruitPreparer:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_fruitPreparer
        spec.isWorking = streamReadBool(streamId)
    end
end

```

### onTurnedOff

**Description**

> Called on turn off

**Definition**

> onTurnedOff(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function FruitPreparer:onTurnedOff()
    if self.isClient then
        local spec = self.spec_fruitPreparer
        g_soundManager:stopSamples(spec.samples)
        g_animationManager:stopAnimations(spec.animationNodes)
    end
end

```

### onTurnedOn

**Description**

> Called on turn on

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function FruitPreparer:onTurnedOn()
    if self.isClient then
        local spec = self.spec_fruitPreparer
        g_soundManager:playSample(spec.samples.work)
        g_animationManager:startAnimations(spec.animationNodes)
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function FruitPreparer:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_fruitPreparer
        streamWriteBool(streamId, spec.isWorking)
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
function FruitPreparer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
end

```

### processFruitPreparerArea

**Description**

**Definition**

> processFruitPreparerArea()

**Arguments**

| any | workArea |
|-----|----------|

**Code**

```lua
function FruitPreparer:processFruitPreparerArea(workArea)
    local spec = self.spec_fruitPreparer
    local workAreaSpec = self.spec_workArea

    if not self.isServer and self.currentUpdateDistance > FruitPreparer.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)

    local dxs, dzs = xs, zs
    local dxw, dzw = xw, zw
    local dxh, dzh = xh, zh
    local limitToFruit = true

    if workArea.dropWorkAreaIndex ~ = nil then
        local dropArea = workAreaSpec.workAreas[workArea.dropWorkAreaIndex]
        if dropArea ~ = nil then
            dxs, _, dzs = getWorldTranslation(dropArea.start)
            dxw, _, dzw = getWorldTranslation(dropArea.width)
            dxh, _, dzh = getWorldTranslation(dropArea.height)
            limitToFruit = false -- as the drop area can be offset, we don't check for fruit below
            end
        end

        local workedArea = 0
        for _, fruitType in ipairs(spec.fruitTypes) do
            local area = FSDensityMapUtil.updateFruitPreparerArea(fruitType, xs,zs, xw,zw, xh,zh, dxs,dzs, dxw,dzw, dxh,dzh, limitToFruit)
            if area > 0 then
                spec.lastWorkTime = g_ time
                workedArea = area
            end
        end

        return 0 , workedArea
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
function FruitPreparer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , FruitPreparer )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , FruitPreparer )
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
function FruitPreparer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processFruitPreparerArea" , FruitPreparer.processFruitPreparerArea)
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
function FruitPreparer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , FruitPreparer.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoGroundManipulation" , FruitPreparer.getDoGroundManipulation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , FruitPreparer.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowCutterAIFruitRequirements" , FruitPreparer.getAllowCutterAIFruitRequirements)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , FruitPreparer.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , FruitPreparer.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadRandomlyMovingPartFromXML" , FruitPreparer.loadRandomlyMovingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsRandomlyMovingPartActive" , FruitPreparer.getIsRandomlyMovingPartActive)
end

```