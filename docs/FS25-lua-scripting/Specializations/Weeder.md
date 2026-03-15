## Weeder

**Description**

> Specialization for weeder tool used to remove growing weeds on fields

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadGroundParticleMapping](#loadgroundparticlemapping)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onPostAttach](#onpostattach)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onStateChange](#onstatechange)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [processWeederArea](#processweederarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateWeederAIRequirements](#updateweederairequirements)

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
function Weeder:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or self:getIsImplementChainLowered()
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
function Weeder.getDefaultSpeedLimit()
    return 15
end

```

### getDirtMultiplier

**Description**

> Returns current dirt multiplier

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current dirt multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Weeder:getDirtMultiplier(superFunc)
    local spec = self.spec_weeder
    local multiplier = superFunc( self )

    if spec.isWorking then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
end

```

### getIsWorkAreaActive

**Description**

> Returns true if work area is active

**Definition**

> getIsWorkAreaActive(table workArea, )

**Arguments**

| table | workArea | workArea |
|-------|----------|----------|
| any   | workArea |          |

**Return Values**

| any | isActive | work area is active |
|-----|----------|---------------------|

**Code**

```lua
function Weeder:getIsWorkAreaActive(superFunc, workArea)
    if workArea.type = = WorkAreaType.WEEDER then
        local isActive = true
        if workArea.requiresGroundContact and workArea.groundReferenceNode ~ = nil then
            isActive = isActive and self:getIsGroundReferenceNodeActive(workArea.groundReferenceNode)
        end
        if isActive and workArea.disableBackwards then
            isActive = isActive and self.movingDirection > 0
        end
        return isActive
    end

    return superFunc( self , workArea)
end

```

### getWearMultiplier

**Description**

> Returns current wear multiplier

**Definition**

> getWearMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Weeder:getWearMultiplier(superFunc)
    local spec = self.spec_weeder
    local multiplier = superFunc( self )

    if spec.isWorking then
        local stoneMultiplier = 1
        if spec.stoneLastState ~ = 0 and spec.stoneWearMultiplierData ~ = nil then
            stoneMultiplier = spec.stoneWearMultiplierData[spec.stoneLastState] or 1
        end

        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit * stoneMultiplier
    end

    return multiplier
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Weeder.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "weeder" , true , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Weeder" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.weeder.sounds" , "work(?)" )
    schema:register(XMLValueType.BOOL, "vehicle.weeder#isHoe" , "Is hoe weeder" , false )
    schema:register(XMLValueType.BOOL, "vehicle.weeder#isGrasslandWeeder" , "Is a grassland weeder(grass fertilizer state + grass growth reset)" , false )

    schema:register(XMLValueType.BOOL, WorkParticles.PARTICLE_MAPPING_XML_PATH .. "#adjustColor" , "Adjust color" , false )

    schema:setXMLSpecializationType()
end

```

### loadGroundParticleMapping

**Description**

> Load ground particle mapping from xml file

**Definition**

> loadGroundParticleMapping(XMLFile xmlFile, string key, table mapping, integer index, integer i3dNode, )

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| string  | key     | key              |
| table   | mapping | mapping          |
| integer | index   | index            |
| integer | i3dNode | id of i3d node   |
| any     | i3dNode |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Weeder:loadGroundParticleMapping(superFunc, xmlFile, key, mapping, index, i3dNode)
    if not superFunc( self , xmlFile, key, mapping, index, i3dNode) then
        return false
    end

    mapping.adjustColor = xmlFile:getValue(key .. "#adjustColor" , false )
    if mapping.adjustColor then
        local spec = self.spec_weeder
        if spec.colorParticleSystems = = nil then
            spec.colorParticleSystems = { }
        end
        mapping.lastColor = { }

        table.insert(spec.colorParticleSystems, mapping)
    end

    return true
end

```

### loadWorkAreaFromXML

**Description**

> Loads work areas from xml

**Definition**

> loadWorkAreaFromXML(table workArea, integer xmlFile, string key, )

**Arguments**

| table   | workArea | workArea         |
|---------|----------|------------------|
| integer | xmlFile  | id of xml object |
| string  | key      | key              |
| any     | key      |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Weeder:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.WEEDER
    end

    return superFunc( self , workArea, xmlFile, key)
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Weeder:onDeactivate()
    if self.isClient then
        local spec = self.spec_weeder
        g_soundManager:stopSamples(spec.samples.work)
        spec.isWorkSamplePlaying = false
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Weeder:onDelete()
    local spec = self.spec_weeder
    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.work)
    end
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt           |
|-----|--------------|
| any | hasProcessed |

**Code**

```lua
function Weeder:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_weeder

    if self.isServer then
        if spec.workAreaParameters.lastStatsArea > 0 then
            self:updateLastWorkedArea(spec.workAreaParameters.lastStatsArea)
        end
    end

    if self.isClient then
        if spec.isWorking then
            if not spec.isWorkSamplePlaying then
                g_soundManager:playSamples(spec.samples.work)
                spec.isWorkSamplePlaying = true
            end
        else
                if spec.isWorkSamplePlaying then
                    g_soundManager:stopSamples(spec.samples.work)
                    spec.isWorkSamplePlaying = false
                end
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
function Weeder:onLoad(savegame)
    local spec = self.spec_weeder

    if self.isClient then
        spec.samples = { }
        spec.samples.work = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.weeder.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isWorkSamplePlaying = false
    end

    spec.startActivationTimeout = 2000
    spec.startActivationTime = 0

    spec.isHoeWeeder = self.xmlFile:getValue( "vehicle.weeder#isHoe" , false )
    spec.isGrasslandWeeder = self.xmlFile:getValue( "vehicle.weeder#isGrasslandWeeder" , false )

    spec.workAreaParameters = { }
    spec.workAreaParameters.lastArea = 0
    spec.workAreaParameters.lastStatsArea = 0

    spec.isWorking = false

    spec.stoneLastState = 0
    spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "WEEDER" )

    self:updateWeederAIRequirements()
end

```

### onPostAttach

**Description**

> Called if vehicle gets attached

**Definition**

> onPostAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                            |
|---------|---------------------|---------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint               |
| integer | jointDescIndex      | index of attacher joint it gets attached to |

**Code**

```lua
function Weeder:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_weeder
    spec.startActivationTime = g_currentMission.time + spec.startActivationTimeout
end

```

### onStartWorkAreaProcessing

**Description**

**Definition**

> onStartWorkAreaProcessing()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Weeder:onStartWorkAreaProcessing(dt)
    local spec = self.spec_weeder
    spec.isWorking = false
    spec.workAreaParameters.lastArea = 0
    spec.workAreaParameters.lastStatsArea = 0
end

```

### onStateChange

**Description**

**Definition**

> onStateChange()

**Arguments**

| any | state |
|-----|-------|
| any | data  |

**Code**

```lua
function Weeder:onStateChange(state, data)
    if state = = VehicleStateChange.ATTACH or state = = VehicleStateChange.DETACH then
        self:updateWeederAIRequirements()
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Weeder:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_weeder

    if spec.isWorking then
        if spec.colorParticleSystems ~ = nil then
            for _, mapping in ipairs(spec.colorParticleSystems) do
                local wx, wy, wz = getWorldTranslation(mapping.node)

                local isOnField, densityBits = FSDensityMapUtil.getFieldDataAtWorldPosition(wx, wy, wz)

                if isOnField then
                    mapping.lastColor[ 1 ], mapping.lastColor[ 2 ], mapping.lastColor[ 3 ], _ = g_currentMission.fieldGroundSystem:getFieldGroundTyreTrackColor(densityBits)
                else
                        mapping.lastColor[ 1 ], mapping.lastColor[ 2 ], mapping.lastColor[ 3 ], _, _ = getTerrainAttributesAtWorldPos(g_terrainNode, wx, wy, wz, true , true , true , true , false )
                    end

                    -- interpolate between different ground colors to avoid unrealisitic particle color changes
                    if mapping.targetColor = = nil then
                        mapping.targetColor = { mapping.lastColor[ 1 ],mapping.lastColor[ 2 ],mapping.lastColor[ 3 ] }
                        mapping.currentColor = { mapping.lastColor[ 1 ],mapping.lastColor[ 2 ],mapping.lastColor[ 3 ] }
                        mapping.alpha = 1
                    end

                    if mapping.alpha ~ = 1 then
                        mapping.alpha = math.min(mapping.alpha + dt / 1000 , 1 )
                        mapping.currentColor = { MathUtil.vector3ArrayLerp(mapping.lastColor, mapping.targetColor, mapping.alpha) }
                        if mapping.alpha = = 1 then
                            mapping.lastColor = { mapping.currentColor[ 1 ], mapping.currentColor[ 2 ], mapping.currentColor[ 3 ] }
                        end
                    end

                    if mapping.alpha = = 1 and mapping.lastColor[ 1 ] ~ = mapping.targetColor[ 1 ] and mapping.lastColor[ 2 ] ~ = mapping.targetColor[ 2 ] and mapping.lastColor[ 3 ] ~ = mapping.targetColor[ 3 ] then
                        mapping.alpha = 0
                        mapping.targetColor = { mapping.lastColor[ 1 ], mapping.lastColor[ 2 ], mapping.lastColor[ 3 ] }
                    end

                    setShaderParameter(mapping.particleSystem.shape, "psColor" , mapping.currentColor[ 1 ], mapping.currentColor[ 2 ], mapping.currentColor[ 3 ], 1 , false )
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
function Weeder.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and
    SpecializationUtil.hasSpecialization( AttacherJoints , specializations)
end

```

### processWeederArea

**Description**

**Definition**

> processWeederArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Weeder:processWeederArea(workArea, dt)
    local spec = self.spec_weeder

    if not self.isServer and self.currentUpdateDistance > Weeder.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)
    local area = FSDensityMapUtil.updateWeederArea(xs,zs, xw,zw, xh,zh, spec.isHoeWeeder)

    if spec.isGrasslandWeeder then
        local _area = FSDensityMapUtil.updateGrassRollerArea(xs, zs, xw, zw, xh, zh, false )
        area = math.max(area, _area)
    end

    spec.workAreaParameters.lastArea = spec.workAreaParameters.lastArea + area
    spec.workAreaParameters.lastStatsArea = spec.workAreaParameters.lastStatsArea + area

    spec.isWorking = self:getLastSpeed() > 0.5
    if spec.isWorking then
        spec.stoneLastState = FSDensityMapUtil.getStoneArea(xs, zs, xw, zw, xh, zh)
    else
            spec.stoneLastState = 0
        end

        return area, area
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
function Weeder.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Weeder )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , Weeder )
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
function Weeder.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processWeederArea" , Weeder.processWeederArea)
    SpecializationUtil.registerFunction(vehicleType, "updateWeederAIRequirements" , Weeder.updateWeederAIRequirements)
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
function Weeder.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Weeder.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Weeder.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Weeder.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Weeder.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Weeder.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadGroundParticleMapping" , Weeder.loadGroundParticleMapping)
end

```

### updateWeederAIRequirements

**Description**

**Definition**

> updateWeederAIRequirements()

**Code**

```lua
function Weeder:updateWeederAIRequirements()
    local spec = self.spec_weeder
    if self.addAITerrainDetailRequiredRange ~ = nil then
        local hasSowingMachine = false
        local vehicles = self.rootVehicle:getChildVehicles()
        for i = 1 , #vehicles do
            if SpecializationUtil.hasSpecialization( SowingMachine , vehicles[i].specializations) then
                if vehicles[i]:getUseSowingMachineAIRequirements() then
                    hasSowingMachine = true
                end
            end
        end

        self:clearAIFruitRequirements()

        -- if we also have a active sowing machine attached the sowingMachine is fully handling it
            if not hasSowingMachine then
                local weedSystem = g_currentMission.weedSystem
                if weedSystem ~ = nil then
                    local weedMapId, weedFirstChannel, weedNumChannels = weedSystem:getDensityMapData()
                    local replacementData = weedSystem:getWeederReplacements(spec.isHoeWeeder)
                    if replacementData.weed ~ = nil then
                        local startState, lastState = - 1 , - 1
                        for sourceState, targetState in pairs(replacementData.weed.replacements) do
                            if startState = = - 1 then
                                startState = sourceState
                            else
                                    if sourceState ~ = lastState + 1 then
                                        self:addAIFruitRequirement( nil , startState, lastState, weedMapId, weedFirstChannel, weedNumChannels)
                                        startState = sourceState
                                    end
                                end

                                lastState = sourceState
                            end

                            if startState ~ = - 1 then
                                self:addAIFruitRequirement( nil , startState, lastState, weedMapId, weedFirstChannel, weedNumChannels)
                            end
                        end
                    end

                    -- temporary disabled until we can set the query requirements as OR(#)
                    -- so currently the grassland weeders cannot be used with the AI
                    --if spec.isGrasslandWeeder then
                        -- local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(FruitType.GRASS)
                        -- if fruitTypeDesc.terrainDataPlaneId ~ = nil then
                            -- self:addAIFruitRequirement(fruitTypeDesc.index, 2, fruitTypeDesc.cutState + 1)
                            -- end
                            --end
                        end
                    end
                end

```