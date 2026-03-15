## Cutter

**Description**

> Specialization for cutters providing cutter effects; requires WorkArea specialization

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAllowCutterAIFruitRequirements](#getallowcutteraifruitrequirements)
- [getCombine](#getcombine)
- [getConsumingLoad](#getconsumingload)
- [getCutterLoad](#getcutterload)
- [getCutterStoneMultiplier](#getcutterstonemultiplier)
- [getCutterTiltDelta](#getcuttertiltdelta)
- [getCutterTiltIsActive](#getcuttertiltisactive)
- [getCutterTiltIsAvailable](#getcuttertiltisavailable)
- [getDefaultAllowComponentMassReduction](#getdefaultallowcomponentmassreduction)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getFruitExtraObjectTypeData](#getfruitextraobjecttypedata)
- [getIsGroundReferenceNodeThreshold](#getisgroundreferencenodethreshold)
- [getIsRandomlyMovingPartActive](#getisrandomlymovingpartactive)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [isAttachAllowed](#isattachallowed)
- [loadCutterTiltFromXML](#loadcuttertiltfromxml)
- [loadInputAttacherJoint](#loadinputattacherjoint)
- [loadRandomlyMovingPartFromXML](#loadrandomlymovingpartfromxml)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onAIImplementStart](#onaiimplementstart)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processCutterArea](#processcutterarea)
- [processHaulmDropArea](#processhaulmdroparea)
- [processPickupCutterArea](#processpickupcutterarea)
- [readCutterFromStream](#readcutterfromstream)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setCutterCutHeight](#setcuttercutheight)
- [tiltRaycastDetectionCallbackLeft](#tiltraycastdetectioncallbackleft)
- [tiltRaycastDetectionCallbackRight](#tiltraycastdetectioncallbackright)
- [updateDebugValues](#updatedebugvalues)
- [writeCutterToStream](#writecuttertostream)

### doCheckSpeedLimit

**Description**

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Cutter:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and( self.getIsLowered = = nil or self:getIsLowered()))
end

```

### getAllowCutterAIFruitRequirements

**Description**

**Definition**

> getAllowCutterAIFruitRequirements()

**Code**

```lua
function Cutter:getAllowCutterAIFruitRequirements()
    return true
end

```

### getCombine

**Description**

**Definition**

> getCombine()

**Arguments**

| any | fruitTypeIndex      |
|-----|---------------------|
| any | outputFillTypeIndex |

**Code**

```lua
function Cutter:getCombine(fruitTypeIndex, outputFillTypeIndex)
    local spec = self.spec_cutter

    if self.verifyCombine ~ = nil then
        return self:verifyCombine(fruitTypeIndex or spec.currentInputFruitType, outputFillTypeIndex or spec.currentOutputFillType)
    else
            if self.getAttacherVehicle ~ = nil then
                local attacherVehicle = self:getAttacherVehicle()
                if attacherVehicle ~ = nil then
                    if attacherVehicle.verifyCombine ~ = nil then
                        return attacherVehicle:verifyCombine(fruitTypeIndex or spec.currentInputFruitType, outputFillTypeIndex or spec.currentOutputFillType)
                    end
                end
            end
        end

        return nil
    end

```

### getConsumingLoad

**Description**

**Definition**

> getConsumingLoad()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Cutter:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local loadPercentage = self:getCutterLoad()

    return value + loadPercentage, count + 1
end

```

### getCutterLoad

**Description**

**Definition**

> getCutterLoad()

**Code**

```lua
function Cutter:getCutterLoad()
    local speedLimitFactor = math.clamp( self:getLastSpeed() / self.speedLimit, 0 , 1 ) * 0.75 + 0.25
    return self.spec_cutter.cutterLoad * speedLimitFactor
end

```

### getCutterStoneMultiplier

**Description**

**Definition**

> getCutterStoneMultiplier()

**Code**

```lua
function Cutter:getCutterStoneMultiplier()
    local spec = self.spec_cutter

    if spec.stoneLastState ~ = 0 and spec.stoneWearMultiplierData ~ = nil then
        return spec.stoneWearMultiplierData[spec.stoneLastState] or 1
    end

    return 1
end

```

### getCutterTiltDelta

**Description**

> Returns current cutter tilt delta and active state

**Definition**

> getCutterTiltDelta()

**Return Values**

| any | delta    | tilt delta in deg                     |
|-----|----------|---------------------------------------|
| any | isActive | cutter tilt is active                 |
| any | doReset  | reset header tilt to initial position |

**Code**

```lua
function Cutter:getCutterTiltDelta()
    local spec = self.spec_cutter
    local isActive, doReset = self:getCutterTiltIsActive(spec.automaticTilt)
    return isActive and spec.automaticTilt.currentDelta or 0 , isActive, doReset
end

```

### getCutterTiltIsActive

**Description**

> Returns if cutter tilt is active

**Definition**

> getCutterTiltIsActive()

**Arguments**

| any | automaticTilt |
|-----|---------------|

**Return Values**

| any | isActive | cutter tilt is active                 |
|-----|----------|---------------------------------------|
| any | doReset  | reset header tilt to initial position |

**Code**

```lua
function Cutter:getCutterTiltIsActive(automaticTilt)
    if not automaticTilt.isAvailable or not self.isActive then
        return false , false
    end

    if not self:getIsLowered( true ) or not( self.getAttacherVehicle = = nil or self:getAttacherVehicle() ~ = nil ) then
        return false , true
    end

    return true , false
end

```

### getCutterTiltIsAvailable

**Description**

> Returns if cutter tilt is available

**Definition**

> getCutterTiltIsAvailable()

**Return Values**

| any | isAvailable | cutter tilt is available |
|-----|-------------|--------------------------|

**Code**

```lua
function Cutter:getCutterTiltIsAvailable()
    return self.spec_cutter.automaticTilt.isAvailable
end

```

### getDefaultAllowComponentMassReduction

**Description**

**Definition**

> getDefaultAllowComponentMassReduction()

**Code**

```lua
function Cutter:getDefaultAllowComponentMassReduction()
    return true
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function Cutter.getDefaultSpeedLimit()
    return 10
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
function Cutter:getDirtMultiplier(superFunc)
    local spec = self.spec_cutter

    if spec.isWorking then
        return superFunc( self ) + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return superFunc( self )
end

```

### getFruitExtraObjectTypeData

**Description**

**Definition**

> getFruitExtraObjectTypeData()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Cutter:getFruitExtraObjectTypeData(superFunc)
    return self.spec_cutter.lastValidInputFruitType, nil
end

```

### getIsGroundReferenceNodeThreshold

**Description**

**Definition**

> getIsGroundReferenceNodeThreshold()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | groundReferenceNode |

**Code**

```lua
function Cutter:getIsGroundReferenceNodeThreshold(superFunc, groundReferenceNode)
    local threshold = superFunc( self , groundReferenceNode)

    threshold = threshold + self.spec_cutter.currentCutHeight

    return threshold
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
function Cutter:getIsRandomlyMovingPartActive(superFunc, part)
    local retValue = superFunc( self , part)

    if part.moveOnlyIfCut then
        retValue = retValue and( self.spec_cutter.lastAreaBiggerZeroTime > = (g_currentMission.time - 150 ))
    end

    return retValue
end

```

### getIsSpeedRotatingPartActive

**Description**

**Definition**

> getIsSpeedRotatingPartActive()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |

**Code**

```lua
function Cutter:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    if speedRotatingPart.rotateIfTurnedOn and not self:getIsTurnedOn() then
        return false
    end

    return superFunc( self , speedRotatingPart)
end

```

### getIsWorkAreaActive

**Description**

**Definition**

> getIsWorkAreaActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |

**Code**

```lua
function Cutter:getIsWorkAreaActive(superFunc, workArea)
    if workArea.type = = WorkAreaType.CUTTER then
        local spec = self.spec_cutter
        if self.getAllowsLowering = = nil or self:getAllowsLowering() then
            if not spec.allowCuttingWhileRaised and not self:getIsLowered( true ) then
                return false
            end
        end
    end

    return superFunc( self , workArea)
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
function Cutter:getWearMultiplier(superFunc)
    local spec = self.spec_cutter

    if spec.isWorking then
        local stoneMultiplier = 1
        if spec.stoneLastState ~ = 0 and spec.stoneWearMultiplierData ~ = nil then
            stoneMultiplier = spec.stoneWearMultiplierData[spec.stoneLastState] or 1
        end

        return superFunc( self ) + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit * stoneMultiplier
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Cutter.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "cutter" , false , true , true )
    g_workAreaTypeManager:addWorkAreaType( "haulmDrop" , false , false , false )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Cutter" )

    schema:register(XMLValueType.STRING, "vehicle.cutter#fruitTypes" , "List with supported fruit types" )
    schema:register(XMLValueType.STRING, "vehicle.cutter#fruitTypeCategories" , "List with supported fruit types categories" )
    schema:register(XMLValueType.STRING, "vehicle.cutter#fruitTypeConverter" , "Name of fruit type converter" )
    schema:register(XMLValueType.STRING, "vehicle.cutter#fillTypeConverter" , "Name of fill type converter(defines the supported fill types for pickup headers)" )
        schema:register(XMLValueType.BOOL, "vehicle.cutter#supportsPickupAI" , "AI works for pickup from the ground as well" , false )

            AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.cutter.animationNodes" )

            EffectManager.registerEffectXMLPaths(schema, "vehicle.cutter.effect" )
            EffectManager.registerEffectXMLPaths(schema, "vehicle.cutter.fillEffect" )

            schema:register(XMLValueType.NODE_INDEX, Cutter.CUTTER_TILT_XML_KEY .. ".automaticTiltNode(?)#node" , "Automatic tilt node" )
            schema:register(XMLValueType.ANGLE, Cutter.CUTTER_TILT_XML_KEY .. ".automaticTiltNode(?)#minAngle" , "Min.angle" , - 5 )
            schema:register(XMLValueType.ANGLE, Cutter.CUTTER_TILT_XML_KEY .. ".automaticTiltNode(?)#maxAngle" , "Max.angle" , 5 )
            schema:register(XMLValueType.ANGLE, Cutter.CUTTER_TILT_XML_KEY .. ".automaticTiltNode(?)#maxSpeed" , "Max.angle change per second" , 1 )
            schema:register(XMLValueType.NODE_INDEX, Cutter.CUTTER_TILT_XML_KEY .. "#raycastNode1" , "Raycast node 1" )
            schema:register(XMLValueType.NODE_INDEX, Cutter.CUTTER_TILT_XML_KEY .. "#raycastNode2" , "Raycast node 2" )

            schema:register(XMLValueType.BOOL, "vehicle.cutter#allowsForageGrowthState" , "Allows forage growth state" , false )
            schema:register(XMLValueType.BOOL, "vehicle.cutter#allowCuttingWhileRaised" , "Allow cutting while raised" , false )
                schema:register(XMLValueType.INT, "vehicle.cutter#movingDirection" , "Moving direction" , 1 )
                schema:register(XMLValueType.FLOAT, "vehicle.cutter#strawRatio" , "Straw ratio" , 1 )
                schema:register(XMLValueType.TIME, "vehicle.cutter.haulmDrop#delay" , "Delay between pickup and haulm drop" , 0 )

                schema:register(XMLValueType.NODE_INDEX, "vehicle.cutter.spikedDrums.spikedDrum(?)#node" , "Spiked drum node(Needs to rotate on X axis)" )
                schema:register(XMLValueType.NODE_INDEX, "vehicle.cutter.spikedDrums.spikedDrum(?)#spline" , "Reference spline" )
                schema:register(XMLValueType.NODE_INDEX, "vehicle.cutter.spikedDrums.spikedDrum(?).spike(?)#node" , "Spike that is translated on Y axis depending on spline" )

                SoundManager.registerSampleXMLPaths(schema, "vehicle.cutter.sounds" , "cut" )

                schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".chopperArea#index" , "Chopper area index" )
                schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".chopperArea#index" , "Chopper area index" )
                schema:register(XMLValueType.BOOL, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#moveOnlyIfCut" , "Move only if cutters cuts something" , false )
                    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#rotateIfTurnedOn" , "Rotate only if turned on" , false )

                        schema:register(XMLValueType.BOOL, Attachable.INPUT_ATTACHERJOINT_XML_KEY .. "#useFruitCutHeight" , "The lower distance to ground is used from the cutHeight defined in the current fruit type" , true )
                        schema:register(XMLValueType.BOOL, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY .. "#useFruitCutHeight" , "The lower distance to ground is used from the cutHeight defined in the current fruit type" , true )

                        schema:setXMLSpecializationType()

                        local schemaSavegame = Vehicle.xmlSchemaSavegame
                        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).cutter#cutHeight" , "Last used cut height" )
                    end

```

### isAttachAllowed

**Description**

> Returns true if attaching the vehicle is allowed

**Definition**

> isAttachAllowed(integer farmId, table attacherVehicle, )

**Arguments**

| integer | farmId          | farmId of attacher vehicle |
|---------|-----------------|----------------------------|
| table   | attacherVehicle | attacher vehicle           |
| any     | attacherVehicle |                            |

**Return Values**

| any | detachAllowed | detach is allowed                  |
|-----|---------------|------------------------------------|
| any | warning       | [optional] warning text to display |

**Code**

```lua
function Cutter:isAttachAllowed(superFunc, farmId, attacherVehicle)
    local spec = self.spec_cutter

    if attacherVehicle.spec_combine ~ = nil then
        if not attacherVehicle:getIsCutterCompatible(spec.outputFillTypes) then
            return false , g_i18n:getText( "warning_cutterNotCompatible" )
        end
    end

    return superFunc( self , farmId, attacherVehicle)
end

```

### loadCutterTiltFromXML

**Description**

> Loads header tilt from xml file

**Definition**

> loadCutterTiltFromXML(table xmlFile, string key, )

**Arguments**

| table  | xmlFile | xml file object  |
|--------|---------|------------------|
| string | key     | key to load from |
| any    | target  |                  |

**Return Values**

| any | success | successfully loaded |
|-----|---------|---------------------|

**Code**

```lua
function Cutter:loadCutterTiltFromXML(xmlFile, key, target)
    target.nodes = { }
    xmlFile:iterate(key .. ".automaticTiltNode" , function (index, nodeKey)
        local entry = { }
        entry.node = xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
        if entry.node ~ = nil then
            entry.minAngle = xmlFile:getValue(nodeKey .. "#minAngle" , - 5 )
            entry.maxAngle = xmlFile:getValue(nodeKey .. "#maxAngle" , 5 )

            entry.maxSpeed = xmlFile:getValue(nodeKey .. "#maxSpeed" , 2 ) / 1000

            table.insert(target.nodes, entry)
        end
    end )

    target.raycastNode1 = xmlFile:getValue(key .. "#raycastNode1" , nil , self.components, self.i3dMappings)
    target.raycastNode2 = xmlFile:getValue(key .. "#raycastNode2" , nil , self.components, self.i3dMappings)
    if target.raycastNode1 ~ = nil and target.raycastNode2 ~ = nil then
        local x1, _, _ = localToLocal(target.raycastNode1, self.rootNode, 0 , 0 , 0 )
        local x2, _, _ = localToLocal(target.raycastNode2, self.rootNode, 0 , 0 , 0 )
        if x1 < x2 then
            local raycastNode1 = target.raycastNode1
            target.raycastNode1 = target.raycastNode2
            target.raycastNode2 = raycastNode1
        end
    else
            return false
        end

        return true
    end

```

### loadInputAttacherJoint

**Description**

> Called on loading

**Definition**

> loadInputAttacherJoint(table savegame, , , , )

**Arguments**

| table | savegame           | savegame |
|-------|--------------------|----------|
| any   | xmlFile            |          |
| any   | key                |          |
| any   | inputAttacherJoint |          |
| any   | i                  |          |

**Code**

```lua
function Cutter:loadInputAttacherJoint(superFunc, xmlFile, key, inputAttacherJoint, i)
    if not superFunc( self , xmlFile, key, inputAttacherJoint, i) then
        return false
    end

    inputAttacherJoint.useFruitCutHeight = xmlFile:getValue(key .. "#useFruitCutHeight" , true )

    return true
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
function Cutter:loadRandomlyMovingPartFromXML(superFunc, part, xmlFile, key)
    local retValue = superFunc( self , part, xmlFile, key)

    part.moveOnlyIfCut = xmlFile:getValue(key .. "#moveOnlyIfCut" , false )

    return retValue
end

```

### loadSpeedRotatingPartFromXML

**Description**

**Definition**

> loadSpeedRotatingPartFromXML()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |
| any | xmlFile           |
| any | key               |

**Code**

```lua
function Cutter:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.rotateIfTurnedOn = xmlFile:getValue(key .. "#rotateIfTurnedOn" , false )

    return true
end

```

### loadWorkAreaFromXML

**Description**

**Definition**

> loadWorkAreaFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function Cutter:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    workArea.chopperAreaIndex = xmlFile:getValue(key .. ".chopperArea#index" )

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
function Cutter:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true
    fieldCourseSettings.cornerCutOutSupported = true
end

```

### onAIImplementStart

**Description**

**Definition**

> onAIImplementStart()

**Code**

```lua
function Cutter:onAIImplementStart()
    -- clear ai fruit requirements on start of ai vehicle to get the newest fruit type in front of the cutter
    if self:getAllowCutterAIFruitRequirements() then
        self:clearAIFruitRequirements()

        -- default require all fruit types the cutter can handle so we don't get other fruit types
        local spec = self.spec_cutter
        for _, fruitTypeIndex in ipairs(spec.fruitTypeIndices) do
            local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
            if fruitType ~ = nil then
                local outputFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
                if spec.fruitTypeConverters[fruitTypeIndex] ~ = nil then
                    outputFillType = spec.fruitTypeConverters[fruitTypeIndex].fillTypeIndex
                end

                -- combine might have a different fill type already loaded, so we only allow this one
                if self:getCombine(fruitTypeIndex, outputFillType) ~ = nil then
                    local minState = spec.allowsForageGrowthState and fruitType.minForageGrowthState or fruitType.minHarvestingGrowthState
                    self:addAIFruitRequirement(fruitType.index, minState, fruitType.maxHarvestingGrowthState)
                end
            end
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
function Cutter:onDelete()
    local spec = self.spec_cutter
    g_effectManager:deleteEffects(spec.cutterEffects)
    g_effectManager:deleteEffects(spec.fillEffects)
    g_animationManager:deleteAnimations(spec.animationNodes)
    g_soundManager:deleteSamples(spec.samples)
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
function Cutter:onEndWorkAreaProcessing(dt, hasProcessed)
    if self.isServer then
        local spec = self.spec_cutter

        local lastArea = spec.workAreaParameters.lastArea
        local lastLiters = spec.workAreaParameters.lastLiters

        spec.lastAreaBiggerZero = false

        if lastArea > 0 or lastLiters > 0 then
            if spec.workAreaParameters.combineVehicle ~ = nil then
                local inputFruitType = spec.workAreaParameters.lastFruitType

                -- always use the same input fruit type while the ai is active to prevent situations where the combine is unable to unload a different fruit type
                    if self:getIsAIActive() then
                        local requirements = self:getAIFruitRequirements()
                        -- Assume there is only 1 requirement, because we can't quickly test if all requirements have the same fruit type
                            -- and having more than 1 fruit type makes it uncertain which fruit we should be using here.
                            local requirement = requirements[ 1 ]
                            if #requirements = = 1 and requirement ~ = nil and requirement.fruitType ~ = FruitType.UNKNOWN then
                                inputFruitType = requirement.fruitType
                            end
                        end

                        local liters = g_fruitTypeManager:getFruitTypeAreaLiters(inputFruitType, spec.workAreaParameters.lastMultiplierArea, false )
                        liters = liters + lastLiters

                        -- take fill type conversion into consideration
                        local outputFillType = spec.currentOutputFillType

                        local targetOutputFillType = outputFillType

                        if spec.lastOutputFillTypes[outputFillType] = = nil then
                            spec.lastOutputFillTypes[outputFillType] = lastArea
                        else
                                spec.lastOutputFillTypes[outputFillType] = spec.lastOutputFillTypes[outputFillType] + lastArea
                            end

                            if spec.lastPrioritizedOutputType ~ = FillType.UNKNOWN then
                                outputFillType = spec.lastPrioritizedOutputType
                            end

                            local conversionFactor = (spec.currentConversionFactor or 1 )

                            liters = liters * conversionFactor

                            local farmId = self:getLastTouchedFarmlandFarmId()
                            local appliedDelta = spec.workAreaParameters.combineVehicle:addCutterArea(lastArea, liters, inputFruitType, outputFillType, spec.strawRatio * ( 1 / conversionFactor), farmId, self:getCutterLoad())
                            if appliedDelta > 0 and outputFillType = = targetOutputFillType then
                                spec.lastValidInputFruitType = inputFruitType
                            end
                        end

                        local ha = MathUtil.areaToHa(lastArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
                        g_farmManager:updateFarmStats( self:getLastTouchedFarmlandFarmId(), "threshedHectares" , ha)
                        self:updateLastWorkedArea(lastArea)

                        spec.lastAreaBiggerZero = lastArea > 0 or lastLiters > 0

                        if spec.currentInputFruitType ~ = spec.currentInputFruitTypeSent then
                            self:raiseDirtyFlags(spec.effectDirtyFlag)
                            spec.currentInputFruitTypeSent = spec.currentInputFruitType
                        end

                        if spec.currentInputFillType ~ = spec.currentInputFillTypeSent then
                            self:raiseDirtyFlags(spec.effectDirtyFlag)
                            spec.currentInputFillTypeSent = spec.currentInputFillType
                        end

                        if self:getAllowCutterAIFruitRequirements() then
                            if self.setAIFruitRequirements ~ = nil then
                                if not spec.useWindrow then
                                    -- we do not allow changes of the required type while working, just on ai start(if the cutter has more than one requirement or no requirement -> only one requirement allowed at the time)
                                        -- prevents fruit type changes on field borders
                                        local requirements = self:getAIFruitRequirements()
                                        local requirement = requirements[ 1 ]
                                        if #requirements > 1 or requirement = = nil or requirement.fruitType = = FruitType.UNKNOWN then
                                            local fruitType = g_fruitTypeManager:getFruitTypeByIndex(spec.currentInputFruitTypeAI)
                                            if fruitType ~ = nil then
                                                local minState = spec.allowsForageGrowthState and fruitType.minForageGrowthState or fruitType.minHarvestingGrowthState
                                                self:setAIFruitRequirements(spec.currentInputFruitTypeAI, minState, fruitType.maxHarvestingGrowthState)
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if spec.lastAreaBiggerZero then
                            spec.lastAreaBiggerZeroTime = g_currentMission.time
                        end
                        if spec.lastAreaBiggerZero ~ = spec.lastAreaBiggerZeroSent then
                            self:raiseDirtyFlags(spec.dirtyFlag)
                            spec.lastAreaBiggerZeroSent = spec.lastAreaBiggerZero
                        end
                    end
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
function Cutter:onLoad(savegame)
    local spec = self.spec_cutter

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.cutter.animationNodes.animationNode" , "cutter" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnScrollers" , "vehicle.cutter.animationNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter.turnedOnScrollers" , "vehicle.cutter.animationNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter.reelspikes" , "vehicle.cutter.rotationNodes.rotationNode or vehicle.turnOnVehicle.turnedOnAnimation" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter.threshingParticleSystems.threshingParticleSystem" , "vehicle.cutter.fillEffect.effectNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter.threshingParticleSystems.emitterShape" , "vehicle.cutter.fillEffect.effectNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter#convertedFillTypeCategories" , "vehicle.cutter#fruitTypeConverter" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter#startAnimationName" , "vehicle.turnOnVehicle.turnOnAnimation#name" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter.testAreas" , "vehicle.workAreas.workArea.testAreas" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cutter#useWindrowed" , "Windrows are now picked up if a fillTypeConverter is defined and the work area uses 'processPickupCutterArea'" ) --FS19 to FS22

        -- load fruitTypes
        local fruitTypeIndices = nil
        local fruitTypeNames = self.xmlFile:getValue( "vehicle.cutter#fruitTypes" )
        local fruitTypeCategories = self.xmlFile:getValue( "vehicle.cutter#fruitTypeCategories" )
        if fruitTypeCategories ~ = nil and fruitTypeNames = = nil then
            fruitTypeIndices = g_fruitTypeManager:getFruitTypeIndicesByCategoryNames(fruitTypeCategories, "Warning:Cutter has invalid fruitTypeCategory '%s' in '" .. self.configFileName .. "'" )
        elseif fruitTypeCategories = = nil and fruitTypeNames ~ = nil then
                fruitTypeIndices = g_fruitTypeManager:getFruitTypeIndicesByNames(fruitTypeNames, "Warning:Cutter has invalid fruitType '%s' in '" .. self.configFileName .. "'" )
            end

            spec.currentCutHeight = 0

            spec.outputFillTypes = { }

            spec.fruitTypeConverters = { }
            local category = self.xmlFile:getValue( "vehicle.cutter#fruitTypeConverter" )
            if category ~ = nil then
                local data = g_fruitTypeManager:getConverterDataByName(category)
                if data ~ = nil then
                    for input , converter in pairs(data) do
                        spec.fruitTypeConverters[ input ] = converter
                    end
                else
                        Logging.xmlWarning( self.xmlFile, "Cutter has invalid fruitTypeConverter '%s'" , category)
                    end
                end

                if fruitTypeIndices ~ = nil then
                    spec.fruitTypeIndices = { }
                    for _, fruitTypeIndex in pairs(fruitTypeIndices) do
                        table.insert(spec.fruitTypeIndices, fruitTypeIndex)

                        if #spec.fruitTypeIndices = = 1 then
                            local cutHeight = g_fruitTypeManager:getCutHeightByFruitTypeIndex(fruitTypeIndex, spec.allowsForageGrowthState)
                            self:setCutterCutHeight(cutHeight)
                        end
                    end

                    for _, fruitTypeIndex in ipairs(spec.fruitTypeIndices) do
                        if spec.fruitTypeConverters[fruitTypeIndex] ~ = nil then
                            table.insert(spec.outputFillTypes, spec.fruitTypeConverters[fruitTypeIndex].fillTypeIndex)
                        else
                                local fillTypeIndex = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
                                if fillTypeIndex ~ = nil then
                                    table.insert(spec.outputFillTypes, fillTypeIndex)
                                end
                            end
                        end
                    end

                    spec.fillTypeConverter = nil
                    local fillTypeConverterName = self.xmlFile:getValue( "vehicle.cutter#fillTypeConverter" )
                    if fillTypeConverterName ~ = nil then
                        local fillTypeConverter = g_fillTypeManager:getConverterDataByName(fillTypeConverterName)
                        if fillTypeConverter ~ = nil then
                            spec.fillTypeConverter = fillTypeConverter

                            for _, outputData in pairs(fillTypeConverter) do
                                table.insert(spec.outputFillTypes, outputData.targetFillTypeIndex)
                            end
                        else
                                Logging.xmlWarning( self.xmlFile, "Cutter has invalid fillTypeConverter '%s'" , fillTypeConverterName)
                            end
                        end

                        if #spec.outputFillTypes = = 0 then
                            Logging.xmlWarning( self.xmlFile, "Cutter has no valid fruit/fill type definition(requires either fruitTypes/fruitTypeCategories or fillTypeConverter attribute)" )
                        end

                        if self.isClient then
                            spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.cutter.animationNodes" , self.components, self , self.i3dMappings)

                            spec.spikedDrums = { }
                            self.xmlFile:iterate( "vehicle.cutter.spikedDrums.spikedDrum" , function (index, key)
                                local entry = { }
                                entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                                if entry.node ~ = nil then
                                    entry.spline = self.xmlFile:getValue(key .. "#spline" , nil , self.components, self.i3dMappings)
                                    if entry.spline ~ = nil then
                                        setVisibility(entry.spline, false )

                                        entry.spikes = { }
                                        self.xmlFile:iterate(key .. ".spike" , function (_, spikeKey)
                                            local spike = { }
                                            spike.node = self.xmlFile:getValue(spikeKey .. "#node" , nil , self.components, self.i3dMappings)
                                            if spike.node ~ = nil then
                                                local parent = createTransformGroup(getName(spike.node) .. "Parent" )
                                                link(getParent(spike.node), parent, getChildIndex(spike.node))
                                                setTranslation(parent, getTranslation(spike.node))
                                                setRotation(parent, getRotation(spike.node))
                                                link(parent, spike.node)
                                                setTranslation(spike.node, 0 , 0 , 0 )
                                                setRotation(spike.node, 0 , 0 , 0 )

                                                local _, y, z = localToLocal(spike.node, entry.node, 0 , 0 , 0 )
                                                local angle = - MathUtil.getYRotationFromDirection(y, z)
                                                local initalTime = angle / ( 2 * math.pi)
                                                if initalTime < 0 then
                                                    initalTime = initalTime + 1
                                                end

                                                spike.initalTime = initalTime
                                                table.insert(entry.spikes, spike)
                                            end
                                        end )

                                        local splineTimes = { }
                                        for t = 0 , 1 , 0.01 do
                                            local x, y, z = getSplinePosition(entry.spline, t)
                                            local _
                                            _, y, z = worldToLocal(entry.node, x, y, z)
                                            local angle = - MathUtil.getYRotationFromDirection(y, z)

                                            local alpha = angle / ( 2 * math.pi)
                                            if alpha < 0 then
                                                alpha = alpha + 1
                                            end
                                            table.insert(splineTimes, { alpha = alpha, time = t } )
                                        end

                                        table.insert(splineTimes, { alpha = splineTimes[ 1 ].alpha - 0.000001 , time = 1 } )

                                        table.sort(splineTimes, function (a, b)
                                            return a.alpha < b.alpha
                                        end )

                                        entry.splineCurve = AnimCurve.new(linearInterpolator1)
                                        for j = 1 , #splineTimes do
                                            entry.splineCurve:addKeyframe( { splineTimes[j].time , time = splineTimes[j].alpha } )
                                        end

                                        for j = 1 , #spec.animationNodes do
                                            local animationNode = spec.animationNodes[j]
                                            if animationNode.rootNode = = entry.node then
                                                entry.animationNode = animationNode
                                            end
                                        end

                                        if entry.animationNode ~ = nil then
                                            table.insert(spec.spikedDrums, entry)
                                        else
                                                Logging.xmlWarning( self.xmlFile, "Could not find animation node for spikedDrum '%s'" , getName(entry.node))
                                                end
                                            else
                                                    Logging.xmlWarning( self.xmlFile, "No spline defined for spiked drum '%s'" , key)
                                                    end
                                                else
                                                        Logging.xmlWarning( self.xmlFile, "No drum node defined for spiked drum '%s'" , key)
                                                        end
                                                    end )

                                                    spec.cutterEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.cutter.effect" , self.components, self , self.i3dMappings)
                                                    spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.cutter.fillEffect" , self.components, self , self.i3dMappings)

                                                    spec.samples = { }
                                                    spec.samples.cut = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.cutter.sounds" , "cut" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                                end

                                                spec.lastAutomaticTiltRaycastPosition = { 0 , 0 , 0 }

                                                spec.automaticTilt = { }
                                                spec.automaticTilt.isAvailable = false
                                                spec.automaticTilt.hasNodes = false
                                                if self:loadCutterTiltFromXML( self.xmlFile, Cutter.CUTTER_TILT_XML_KEY, spec.automaticTilt) then
                                                    spec.automaticTilt.currentDelta = 0
                                                    spec.automaticTilt.lastHit1 = { 0 , 0 , 0 }
                                                    spec.automaticTilt.lastHit2 = { 0 , 0 , 0 }
                                                    spec.automaticTilt.raycastHit = true
                                                    spec.automaticTilt.isAvailable = true
                                                    spec.automaticTilt.hasNodes = #spec.automaticTilt.nodes > 0
                                                end

                                                if not Platform.gameplay.allowAutomaticHeaderTilt then
                                                    if spec.automaticTilt.hasNodes then
                                                        Logging.xmlWarning( self.xmlFile, "Automatic header tilt is not allowed on this platform!" )
                                                        spec.automaticTilt.hasNodes = false
                                                    end
                                                end

                                                spec.allowsForageGrowthState = self.xmlFile:getValue( "vehicle.cutter#allowsForageGrowthState" , false )
                                                spec.allowCuttingWhileRaised = self.xmlFile:getValue( "vehicle.cutter#allowCuttingWhileRaised" , false )
                                                spec.movingDirection = math.sign( self.xmlFile:getValue( "vehicle.cutter#movingDirection" , 1 ))
                                                spec.strawRatio = self.xmlFile:getValue( "vehicle.cutter#strawRatio" , 1 )

                                                spec.delay = self.xmlFile:getValue( "vehicle.cutter.haulmDrop#delay" , 0 )
                                                if spec.delay ~ = 0 then
                                                    spec.valueDelay = ValueDelay.new(spec.delay)
                                                end

                                                spec.useWindrow = false
                                                spec.currentInputFillType = FillType.UNKNOWN
                                                spec.currentInputFillTypeSent = FillType.UNKNOWN
                                                spec.currentInputFruitType = FruitType.UNKNOWN
                                                spec.currentInputFruitTypeAI = FruitType.UNKNOWN
                                                spec.lastValidInputFruitType = FruitType.UNKNOWN
                                                spec.currentInputFruitTypeSent = FruitType.UNKNOWN
                                                spec.currentOutputFillType = FillType.UNKNOWN
                                                spec.currentConversionFactor = 1
                                                spec.currentGrowthStateTime = 0
                                                spec.currentGrowthStateTimer = 0
                                                spec.currentGrowthState = 0

                                                spec.lastAreaBiggerZero = false
                                                spec.lastAreaBiggerZeroSent = false
                                                spec.lastAreaBiggerZeroTime = - 1

                                                spec.workAreaParameters = { }
                                                spec.workAreaParameters.lastLiters = 0 -- additional liters that we harvested(e.g.pickup header)
                                                spec.workAreaParameters.lastArea = 0 -- area in px where we harvested something(only for regular headers, not pickup headers)
                                                    spec.workAreaParameters.lastMultiplierArea = 0 -- area in px where we harvested something multiplied by the harvest multiplier(only for regular headers, not pickup headers)

                                                        spec.workAreaParameters.fruitTypeIndicesToUse = { }
                                                        spec.workAreaParameters.lastFruitTypeToUse = { }
                                                        spec.workAreaParameters.lastOutputFillType = nil

                                                        spec.lastOutputFillTypes = { }
                                                        spec.lastPrioritizedOutputType = FillType.UNKNOWN
                                                        spec.lastOutputTime = 0

                                                        spec.cutterLoad = 0
                                                        spec.isWorking = false

                                                        spec.stoneLastState = 0
                                                        spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "CUTTER" )

                                                        spec.workAreaParameters.countArea = true

                                                        if self.xmlFile:getValue( "vehicle.cutter#supportsPickupAI" , false ) then
                                                            if self.addAIDensityHeightTypeRequirement ~ = nil then
                                                                for inputFillTypeIndex, _ in pairs(spec.fillTypeConverter) do
                                                                    self:addAIDensityHeightTypeRequirement(inputFillTypeIndex)
                                                                end
                                                            end
                                                        end

                                                        if savegame ~ = nil and not savegame.resetVehicles then
                                                            spec.currentCutHeight = savegame.xmlFile:getValue(savegame.key .. ".cutter#cutHeight" , spec.currentCutHeight)
                                                        end

                                                        spec.dirtyFlag = self:getNextDirtyFlag()
                                                        spec.effectDirtyFlag = self:getNextDirtyFlag()
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
function Cutter:onPostLoad(savegame)
    if self.addCutterToCombine ~ = nil then
        self:addCutterToCombine( self )
    end

    self:setCutterCutHeight( self.spec_cutter.currentCutHeight)
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
function Cutter:onReadStream(streamId, connection)
    self:readCutterFromStream(streamId, connection)

    local spec = self.spec_cutter
    spec.lastAreaBiggerZero = streamReadBool(streamId)
    if spec.lastAreaBiggerZero then
        spec.lastAreaBiggerZeroTime = g_currentMission.time
    end

    self:setTestAreaRequirements(spec.currentInputFruitType, nil , spec.allowsForageGrowthState)
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function Cutter:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_cutter

        if streamReadBool(streamId) then
            self:readCutterFromStream(streamId, connection)
        end

        spec.lastAreaBiggerZero = streamReadBool(streamId)
        if spec.lastAreaBiggerZero then
            spec.lastAreaBiggerZeroTime = g_currentMission.time
        end

        self:setTestAreaRequirements(spec.currentInputFruitType, nil , spec.allowsForageGrowthState)
    end
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
function Cutter:onStartWorkAreaProcessing(dt)
    local spec = self.spec_cutter

    local combineVehicle, alternativeCombine, requiredFillType = self:getCombine()

    if combineVehicle = = nil and requiredFillType ~ = nil then
        combineVehicle = alternativeCombine
    end

    spec.workAreaParameters.combineVehicle = combineVehicle

    spec.workAreaParameters.lastLiters = 0
    spec.workAreaParameters.lastArea = 0
    spec.workAreaParameters.lastMultiplierArea = 0

    if spec.workAreaParameters.lastFruitType = = nil then
        spec.workAreaParameters.fruitTypeIndicesToUse = spec.fruitTypeIndices
    else
            for i = 1 , #spec.workAreaParameters.lastFruitTypeToUse do
                spec.workAreaParameters.lastFruitTypeToUse[i] = nil
            end

            spec.workAreaParameters.lastFruitTypeToUse[ 1 ] = spec.workAreaParameters.lastFruitType
            spec.workAreaParameters.fruitTypeIndicesToUse = spec.workAreaParameters.lastFruitTypeToUse
        end

        -- if the combine could not be found cause a different fruit type is loaded then the last picked up fruit type,
            -- we use all fruit types that can result in the fill type the combine has loaded
            if requiredFillType ~ = nil then
                for i = 1 , #spec.workAreaParameters.lastFruitTypeToUse do
                    spec.workAreaParameters.lastFruitTypeToUse[i] = nil
                end

                local fruitType = g_fruitTypeManager:getFruitTypeIndexByFillTypeIndex(requiredFillType)

                for inputFruitType, fruitTypeConverter in pairs(spec.fruitTypeConverters) do
                    if fruitTypeConverter.fillTypeIndex = = requiredFillType then
                        table.insert(spec.workAreaParameters.lastFruitTypeToUse, inputFruitType)
                        fruitType = nil
                    end
                end

                if fruitType ~ = nil then
                    table.insert(spec.workAreaParameters.lastFruitTypeToUse, fruitType)
                end

                spec.workAreaParameters.fruitTypeIndicesToUse = spec.workAreaParameters.lastFruitTypeToUse
            end

            spec.workAreaParameters.lastFruitType = nil
            spec.isWorking = false
        end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function Cutter:onTurnedOff()
    local spec = self.spec_cutter
    if self.isClient then
        g_animationManager:stopAnimations(spec.animationNodes)
    end

    spec.currentInputFruitType = FruitType.UNKNOWN
    spec.currentInputFruitTypeSent = FruitType.UNKNOWN
    spec.currentInputFruitTypeAI = FruitType.UNKNOWN
    spec.currentInputFillType = FillType.UNKNOWN
    spec.currentOutputFillType = FillType.UNKNOWN
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function Cutter:onTurnedOn()
    if self.isClient then
        local spec = self.spec_cutter
        g_animationManager:startAnimations(spec.animationNodes)
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Cutter:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cutter
    if spec.automaticTilt.hasNodes then
        local currentDelta, isActive, doReset = self:getCutterTiltDelta()
        currentDelta = - currentDelta -- inverted on cutter side since we rotate the cutter itself

        if self.isActive then
            for i = 1 , #spec.automaticTilt.nodes do
                local automaticTiltNode = spec.automaticTilt.nodes[i]

                local _, _, curZ = getRotation(automaticTiltNode.node)
                if not isActive and doReset then
                    currentDelta = - curZ -- return to idle is not active
                end

                if math.abs(currentDelta) > 0.00001 then
                    local speedScale = math.min( math.pow( math.abs(currentDelta) / 0.01745 , 2 ), 1 ) * math.sign(currentDelta)
                    local rotSpeed = speedScale * automaticTiltNode.maxSpeed * dt

                    local newRotZ = math.clamp(curZ + rotSpeed, automaticTiltNode.minAngle, automaticTiltNode.maxAngle)
                    setRotation(automaticTiltNode.node, 0 , 0 , newRotZ)

                    if self.setMovingToolDirty ~ = nil then
                        self:setMovingToolDirty(automaticTiltNode.node)
                    end
                end
            end
        end
    end

    if self.isClient then
        for i = 1 , #spec.spikedDrums do
            local spikedDrum = spec.spikedDrums[i]
            if spikedDrum.animationNode.state ~ = RotationAnimation.STATE_OFF then
                local rot, _, _ = getRotation(spikedDrum.node)
                if rot < 0 then
                    rot = rot + 2 * math.pi
                end
                local alpha = rot / ( 2 * math.pi)

                local numSpikes = #spikedDrum.spikes
                for j = 1 , numSpikes do
                    local spike = spikedDrum.spikes[j]
                    local splineTime = spikedDrum.splineCurve:get((alpha + spike.initalTime) % 1 )

                    local x, y, z = getSplinePosition(spikedDrum.spline, splineTime)
                    local _, spikeY, _ = worldToLocal(getParent(spike.node), x, y, z)
                    setTranslation(spike.node, 0 , spikeY, 0 )
                end
            end
        end
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
function Cutter:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cutter
    local isTurnedOn = self:getIsTurnedOn()

    local isEffectActive = isTurnedOn
    and self.movingDirection = = spec.movingDirection
    and self:getLastSpeed() > 0.5
    and(spec.allowCuttingWhileRaised or self:getIsLowered( true ))
    and spec.workAreaParameters.combineVehicle ~ = nil

    if isEffectActive then
        local currentTestAreaMinX, currentTestAreaMaxX, testAreaMinX, testAreaMaxX, isValid = self:getTestAreaWidthByWorkAreaIndex( 1 )
        local testAreaCharge = self:getTestAreaChargeByWorkAreaIndex( 1 )

        if not spec.useWindrow then
            spec.cutterLoad = spec.cutterLoad * 0.95 + testAreaCharge * 0.05
        end

        local reset = false
        if currentTestAreaMinX = = - math.huge and currentTestAreaMaxX = = math.huge then
            currentTestAreaMinX = 0
            currentTestAreaMaxX = 0
            reset = true
        else
                if not isValid then
                    if spec.lastAreaBiggerZeroTime + 300 < g_currentMission.time then
                        currentTestAreaMinX = 0
                        currentTestAreaMaxX = 0
                        reset = true
                    end
                end
            end

            if spec.movingDirection > 0 then
                currentTestAreaMinX = currentTestAreaMinX * - 1
                currentTestAreaMaxX = currentTestAreaMaxX * - 1
                if currentTestAreaMaxX < currentTestAreaMinX then
                    local t = currentTestAreaMinX
                    currentTestAreaMinX = currentTestAreaMaxX
                    currentTestAreaMaxX = t
                end
            end

            local testAreaMinAlpha = 0
            if testAreaMinX ~ = 0 then
                testAreaMinAlpha = currentTestAreaMinX / testAreaMinX
            end

            local testAreaMaxAlpha = 0
            if testAreaMaxX ~ = 0 then
                testAreaMaxAlpha = currentTestAreaMaxX / testAreaMaxX
            end

            local inputFruitType = spec.currentInputFruitType
            if inputFruitType ~ = spec.lastValidInputFruitType then
                -- if we pickup a different fruit type than we are able to proceed to the combine we won't display the effect
                    inputFruitType = nil
                end

                if inputFruitType ~ = nil then
                    self:updateFruitExtraObjects()
                end

                local isCollecting = spec.lastAreaBiggerZeroTime + 300 > g_currentMission.time
                local fillType = spec.currentInputFillType

                if spec.useWindrow then
                    if isCollecting then
                        spec.cutterLoad = spec.cutterLoad * 0.95 + 0.05
                    else
                            spec.cutterLoad = spec.cutterLoad * 0.9
                        end
                    end

                    if self.isClient then
                        local cutSoundActive = false
                        if fillType ~ = nil and fillType ~ = FillType.UNKNOWN and isCollecting then
                            g_effectManager:setEffectTypeInfo(spec.fillEffects, fillType)
                            g_effectManager:setMinMaxWidth(spec.fillEffects, currentTestAreaMinX, currentTestAreaMaxX, testAreaMinAlpha, testAreaMaxAlpha, reset)
                            g_effectManager:startEffects(spec.fillEffects)

                            cutSoundActive = true
                        else
                                g_effectManager:stopEffects(spec.fillEffects)
                            end

                            if inputFruitType ~ = nil and inputFruitType ~ = FruitType.UNKNOWN and not reset then
                                g_effectManager:setEffectTypeInfo(spec.cutterEffects, fillType, inputFruitType, spec.currentGrowthState)
                                g_effectManager:setMinMaxWidth(spec.cutterEffects, currentTestAreaMinX, currentTestAreaMaxX, testAreaMinAlpha, testAreaMaxAlpha, reset)
                                g_effectManager:startEffects(spec.cutterEffects)

                                cutSoundActive = true
                            else
                                    g_effectManager:stopEffects(spec.cutterEffects)
                                end

                                if cutSoundActive then
                                    if not g_soundManager:getIsSamplePlaying(spec.samples.cut) then
                                        g_soundManager:playSample(spec.samples.cut)
                                    end
                                else
                                        if g_soundManager:getIsSamplePlaying(spec.samples.cut) then
                                            g_soundManager:stopSample(spec.samples.cut)
                                        end
                                    end
                                end
                            else
                                    if self.isClient then
                                        g_effectManager:stopEffects(spec.cutterEffects)
                                        g_effectManager:stopEffects(spec.fillEffects)
                                        g_soundManager:stopSample(spec.samples.cut)
                                    end

                                    spec.cutterLoad = spec.cutterLoad * 0.9
                                end

                                -- lastPrioritizedOutputType is always the fill type that was the most significant fill type of the last 500ms
                                -- this fill type is transfered to the combine to avoid quick changes of the fill type if we harvester 2 different fruit types at the same time
                                    -- e.g.on field borders if can happen that a bit of grass if collected from the cutter
                                        spec.lastOutputTime = spec.lastOutputTime + dt
                                        if spec.lastOutputTime > 500 then
                                            spec.lastPrioritizedOutputType = FillType.UNKNOWN

                                            local max = 0
                                            for i, _ in pairs(spec.lastOutputFillTypes) do
                                                if spec.lastOutputFillTypes[i] > max then
                                                    spec.lastPrioritizedOutputType = i
                                                    max = spec.lastOutputFillTypes[i]
                                                end

                                                spec.lastOutputFillTypes[i] = 0
                                            end

                                            spec.lastOutputTime = 0
                                        end

                                        local automaticTilt = spec.automaticTilt
                                        local isActive, _ = self:getCutterTiltIsActive(automaticTilt)
                                        if isActive then
                                            if automaticTilt ~ = nil and automaticTilt.raycastNode1 ~ = nil and automaticTilt.raycastNode2 ~ = nil then
                                                automaticTilt.currentDelta = 0

                                                automaticTilt.lastHit1[ 1 ], automaticTilt.lastHit1[ 2 ], automaticTilt.lastHit1[ 3 ] = localToWorld(automaticTilt.raycastNode1, 0 , - 1 , 0 )
                                                automaticTilt.lastHit2[ 1 ], automaticTilt.lastHit2[ 2 ], automaticTilt.lastHit2[ 3 ] = localToWorld(automaticTilt.raycastNode2, 0 , - 1 , 0 )

                                                -- raycast 1
                                                local rx, ry, rz = localToWorld(automaticTilt.raycastNode1, 0 , 1 , 0 )
                                                local rDirX, rDirY, rDirZ = localDirectionToWorld(automaticTilt.raycastNode1, 0 , - 1 , 0 )
                                                raycastAllAsync(rx, ry, rz, rDirX, rDirY, rDirZ, 2 , "tiltRaycastDetectionCallbackLeft" , self , Cutter.AUTO_TILT_COLLISION_MASK)

                                                --raycast 2
                                                rx, ry, rz = localToWorld(automaticTilt.raycastNode2, 0 , 1 , 0 )
                                                rDirX, rDirY, rDirZ = localDirectionToWorld(automaticTilt.raycastNode2, 0 , - 1 , 0 )
                                                raycastAllAsync(rx, ry, rz, rDirX, rDirY, rDirZ, 2 , "tiltRaycastDetectionCallbackRight" , self , Cutter.AUTO_TILT_COLLISION_MASK)
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
function Cutter:onWriteStream(streamId, connection)
    self:writeCutterToStream(streamId, connection)

    local spec = self.spec_cutter
    streamWriteBool(streamId, spec.lastAreaBiggerZeroSent)
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function Cutter:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_cutter

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
            self:writeCutterToStream(streamId, connection)
        end

        streamWriteBool(streamId, spec.lastAreaBiggerZeroSent)
    end
end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function Cutter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and SpecializationUtil.hasSpecialization( TestAreas , specializations) and SpecializationUtil.hasSpecialization(FruitExtraObjects, specializations)
end

```

### processCutterArea

**Description**

**Definition**

> processCutterArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Cutter:processCutterArea(workArea, dt)
    local spec = self.spec_cutter

    if not self.isServer and self.currentUpdateDistance > Cutter.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    if spec.workAreaParameters.combineVehicle ~ = nil then
        local fieldGroundSystem = g_currentMission.fieldGroundSystem

        local xs, _, zs = getWorldTranslation(workArea.start)
        local xw, _, zw = getWorldTranslation(workArea.width)
        local xh, _, zh = getWorldTranslation(workArea.height)

        local lastArea = 0
        local lastMultiplierArea = 0
        local lastTotalArea = 0

        for _, fruitTypeIndex in ipairs(spec.workAreaParameters.fruitTypeIndicesToUse) do
            local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
            local excludedSprayType = fieldGroundSystem:getChopperTypeValue(fruitTypeDesc.chopperType)
            local area, totalArea, sprayFactor, plowFactor, limeFactor, weedFactor, stubbleFactor, rollerFactor, beeYieldBonusPerc, growthState, _, terrainDetailPixelsSum = FSDensityMapUtil.cutFruitArea(fruitTypeIndex, xs,zs, xw,zw, xh,zh, true , spec.allowsForageGrowthState, excludedSprayType)

            if area > 0 then
                lastTotalArea = lastTotalArea + totalArea

                if self.isServer then
                    if growthState ~ = spec.currentGrowthState then
                        spec.currentGrowthStateTimer = spec.currentGrowthStateTimer + dt
                        if spec.currentGrowthStateTimer > 500 or spec.currentGrowthStateTime + 1000 < g_ time then
                            spec.currentGrowthState = growthState
                            spec.currentGrowthStateTimer = 0
                        end
                    else
                            spec.currentGrowthStateTimer = 0
                            spec.currentGrowthStateTime = g_ time
                        end

                        if fruitTypeIndex ~ = spec.currentInputFruitType then
                            spec.currentInputFruitType = fruitTypeIndex
                            spec.currentGrowthState = growthState

                            spec.currentOutputFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.currentInputFruitType)
                            if spec.fruitTypeConverters[spec.currentInputFruitType] ~ = nil then
                                spec.currentOutputFillType = spec.fruitTypeConverters[spec.currentInputFruitType].fillTypeIndex
                                spec.currentConversionFactor = spec.fruitTypeConverters[spec.currentInputFruitType].conversionFactor
                            end

                            local cutHeight = g_fruitTypeManager:getCutHeightByFruitTypeIndex(fruitTypeIndex, spec.allowsForageGrowthState)
                            self:setCutterCutHeight(cutHeight)
                        end

                        self:setTestAreaRequirements(fruitTypeIndex, nil , spec.allowsForageGrowthState)

                        -- ai only works on terrain detail, so we do not allow the ai to require fruits that are out of a field
                            if terrainDetailPixelsSum > 0 then
                                spec.currentInputFruitTypeAI = fruitTypeIndex
                            end
                            spec.currentInputFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
                            spec.useWindrow = false
                        end

                        local multiplier = g_currentMission:getHarvestScaleMultiplier(fruitTypeIndex, sprayFactor, plowFactor, limeFactor, weedFactor, stubbleFactor, rollerFactor, beeYieldBonusPerc)

                        lastArea = area
                        lastMultiplierArea = area * multiplier

                        spec.workAreaParameters.lastFruitType = fruitTypeIndex
                        break
                    end
                end

                if lastArea > 0 then
                    if workArea.chopperAreaIndex ~ = nil and spec.workAreaParameters.lastFruitType ~ = nil then
                        local chopperWorkArea = self:getWorkAreaByIndex(workArea.chopperAreaIndex)
                        if chopperWorkArea ~ = nil then
                            xs, _, zs = getWorldTranslation(chopperWorkArea.start)
                            xw, _, zw = getWorldTranslation(chopperWorkArea.width)
                            xh, _, zh = getWorldTranslation(chopperWorkArea.height)

                            local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(spec.workAreaParameters.lastFruitType)
                            if fruitTypeDesc.chopperType ~ = nil then
                                local strawGroundType = FieldChopperType.getValueByType(fruitTypeDesc.chopperType)
                                if strawGroundType ~ = nil then
                                    FSDensityMapUtil.setGroundTypeLayerArea(xs, zs, xw, zw, xh, zh, strawGroundType)
                                end
                            elseif fruitTypeDesc.chopperUseHaulm then
                                    local area = FSDensityMapUtil.updateFruitHaulmArea(spec.workAreaParameters.lastFruitType, xs, zs, xw, zw, xh, zh)

                                    if area > 0 then
                                        -- remove tireTracks since the haulm drops on top of it
                                        FSDensityMapUtil.eraseTireTrack(xs, zs, xw, zw, xh, zh)
                                    end
                                end
                            else
                                    Logging.xmlWarning( self.xmlFile, "Invalid chopperAreaIndex '%d' for workArea '%d'!" , workArea.chopperAreaIndex, workArea.index)
                                        workArea.chopperAreaIndex = nil
                                    end
                                end

                                spec.stoneLastState = FSDensityMapUtil.getStoneArea(xs, zs, xw, zw, xh, zh)
                                spec.isWorking = true
                            end

                            spec.workAreaParameters.lastArea = spec.workAreaParameters.lastArea + lastArea
                            spec.workAreaParameters.lastMultiplierArea = spec.workAreaParameters.lastMultiplierArea + lastMultiplierArea

                            return spec.workAreaParameters.lastArea, lastTotalArea
                        end

                        return 0 , 0
                    end

```

### processHaulmDropArea

**Description**

**Definition**

> processHaulmDropArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Cutter:processHaulmDropArea(workArea, dt)
    local spec = self.spec_cutter

    if not self.isServer and self.currentUpdateDistance > Cutter.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    if spec.valueDelay ~ = nil then
        local isCutting = spec.lastAreaBiggerZeroTime > = (g_currentMission.time - 150 )
        local value = spec.valueDelay:add(isCutting and 1 or 0 , dt)
        if value = = 0 then
            return 0 , 0
        end
    end

    local fruitType = spec.currentInputFruitType
    if fruitType ~ = nil and fruitType ~ = FruitType.UNKNOWN then
        local sx, _, sz = getWorldTranslation(workArea.start)
        local wx, _, wz = getWorldTranslation(workArea.width)
        local hx, _, hz = getWorldTranslation(workArea.height)

        local area = FSDensityMapUtil.updateFruitHaulmArea(fruitType, sx, sz, wx, wz, hx, hz)

        if area > 0 then
            -- remove tireTracks since the haulm drops on top of it
            FSDensityMapUtil.eraseTireTrack(sx, sz, wx, wz, hx, hz)
        end

        return area, area
    end

    return 0 , 0
end

```

### processPickupCutterArea

**Description**

**Definition**

> processPickupCutterArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Cutter:processPickupCutterArea(workArea, dt)
    local spec = self.spec_cutter

    if not self.isServer and self.currentUpdateDistance > Cutter.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    if spec.workAreaParameters.combineVehicle ~ = nil then
        local hasPickedUp = false

        local sx, sy, sz = getWorldTranslation(workArea.start)
        local wx, wy, wz = getWorldTranslation(workArea.width)
        local hx, hy, hz = getWorldTranslation(workArea.height)

        local lsx, lsy, lsz, lex, ley, lez, lineRadius = DensityMapHeightUtil.getLineByAreaDimensions(sx, sy, sz, wx, wy, wz, hx, hy, hz)

        for inputFillTypeIndex, outputData in pairs(spec.fillTypeConverter) do
            if spec.workAreaParameters.lastOutputFillType = = nil or outputData.targetFillTypeIndex = = spec.workAreaParameters.lastOutputFillType then

                local pickedUpLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, inputFillTypeIndex, lsx, lsy, lsz, lex, ley, lez, lineRadius, nil , nil , false , nil )

                if self.isServer then
                    if pickedUpLiters > 0 then
                        spec.currentOutputFillType = outputData.targetFillTypeIndex
                        spec.currentConversionFactor = outputData.conversionFactor

                        spec.useWindrow = true
                        spec.currentInputFillType = inputFillTypeIndex

                        pickedUpLiters = g_fruitTypeManager:getCutWindrowHarvestFillLevel(inputFillTypeIndex, pickedUpLiters)

                        spec.workAreaParameters.lastLiters = pickedUpLiters
                        spec.workAreaParameters.lastOutputFillType = outputData.targetFillTypeIndex

                        spec.stoneLastState = FSDensityMapUtil.getStoneArea(sx, sz, wx, wz, hx, hz)
                        spec.isWorking = true

                        self:setTestAreaRequirements( nil , inputFillTypeIndex, nil )

                        hasPickedUp = true
                        break
                    end
                end
            end
        end

        if not self.isServer then
            if spec.lastAreaBiggerZeroTime + 300 > g_currentMission.time then
                hasPickedUp = true
            end
        end

        -- next frame we check all fill types again
        if not hasPickedUp then
            spec.workAreaParameters.lastOutputFillType = nil
        else
                -- as we are picking up on a line, we dont really have a pixel area
                return 1 , 1
            end
        end

        return 0 , 0
    end

```

### readCutterFromStream

**Description**

**Definition**

> readCutterFromStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Cutter:readCutterFromStream(streamId, connection)
    local spec = self.spec_cutter

    spec.currentGrowthState = streamReadUIntN(streamId, 4 )

    spec.currentInputFruitType = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
    if streamReadBool(streamId) then
        spec.lastValidInputFruitType = spec.currentInputFruitType
    else
            spec.currentInputFruitType = FruitType.UNKNOWN
        end

        spec.currentOutputFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.currentInputFruitType)
        if spec.fruitTypeConverters[spec.currentInputFruitType] ~ = nil then
            spec.currentOutputFillType = spec.fruitTypeConverters[spec.currentInputFruitType].fillTypeIndex
            spec.currentConversionFactor = spec.fruitTypeConverters[spec.currentInputFruitType].conversionFactor
        end

        spec.useWindrow = streamReadBool(streamId)
        if spec.useWindrow then
            spec.currentInputFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        else
                spec.currentInputFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.currentInputFruitType)
            end
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
function Cutter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementStart" , Cutter )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , Cutter )
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
function Cutter.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "readCutterFromStream" , Cutter.readCutterFromStream)
    SpecializationUtil.registerFunction(vehicleType, "writeCutterToStream" , Cutter.writeCutterToStream)
    SpecializationUtil.registerFunction(vehicleType, "getCombine" , Cutter.getCombine)
    SpecializationUtil.registerFunction(vehicleType, "getAllowCutterAIFruitRequirements" , Cutter.getAllowCutterAIFruitRequirements)
    SpecializationUtil.registerFunction(vehicleType, "processCutterArea" , Cutter.processCutterArea)
    SpecializationUtil.registerFunction(vehicleType, "processPickupCutterArea" , Cutter.processPickupCutterArea)
    SpecializationUtil.registerFunction(vehicleType, "processHaulmDropArea" , Cutter.processHaulmDropArea)
    SpecializationUtil.registerFunction(vehicleType, "getCutterLoad" , Cutter.getCutterLoad)
    SpecializationUtil.registerFunction(vehicleType, "getCutterStoneMultiplier" , Cutter.getCutterStoneMultiplier)
    SpecializationUtil.registerFunction(vehicleType, "loadCutterTiltFromXML" , Cutter.loadCutterTiltFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getCutterTiltIsAvailable" , Cutter.getCutterTiltIsAvailable)
    SpecializationUtil.registerFunction(vehicleType, "getCutterTiltIsActive" , Cutter.getCutterTiltIsActive)
    SpecializationUtil.registerFunction(vehicleType, "getCutterTiltDelta" , Cutter.getCutterTiltDelta)
    SpecializationUtil.registerFunction(vehicleType, "tiltRaycastDetectionCallbackLeft" , Cutter.tiltRaycastDetectionCallbackLeft)
    SpecializationUtil.registerFunction(vehicleType, "tiltRaycastDetectionCallbackRight" , Cutter.tiltRaycastDetectionCallbackRight)
    SpecializationUtil.registerFunction(vehicleType, "setCutterCutHeight" , Cutter.setCutterCutHeight)
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
function Cutter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , Cutter.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , Cutter.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadRandomlyMovingPartFromXML" , Cutter.loadRandomlyMovingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsRandomlyMovingPartActive" , Cutter.getIsRandomlyMovingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Cutter.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Cutter.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Cutter.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Cutter.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Cutter.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isAttachAllowed" , Cutter.isAttachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , Cutter.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsGroundReferenceNodeThreshold" , Cutter.getIsGroundReferenceNodeThreshold)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDefaultAllowComponentMassReduction" , Cutter.getDefaultAllowComponentMassReduction)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadInputAttacherJoint" , Cutter.loadInputAttacherJoint)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFruitExtraObjectTypeData" , Cutter.getFruitExtraObjectTypeData)
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
function Cutter:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_cutter
    xmlFile:setValue(key .. "#cutHeight" , spec.currentCutHeight)
end

```

### setCutterCutHeight

**Description**

> Sets cutter cut height

**Definition**

> setCutterCutHeight()

**Arguments**

| any | cutHeight |
|-----|-----------|

**Return Values**

| any | height | cut height |
|-----|--------|------------|

**Code**

```lua
function Cutter:setCutterCutHeight(cutHeight)
    if cutHeight ~ = nil then
        self.spec_cutter.currentCutHeight = cutHeight

        if self.spec_attachable ~ = nil then
            local inputAttacherJoint = self:getActiveInputAttacherJoint()
            if inputAttacherJoint ~ = nil and inputAttacherJoint.useFruitCutHeight then
                if inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_CUTTER
                    or inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_CUTTERHARVESTER then
                    inputAttacherJoint.lowerDistanceToGround = cutHeight
                end
            else
                    local inputAttacherJoints = self:getInputAttacherJoints()
                    for i = 1 , #inputAttacherJoints do
                        inputAttacherJoint = inputAttacherJoints[i]
                        if inputAttacherJoint.useFruitCutHeight then
                            if inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_CUTTER
                                or inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_CUTTERHARVESTER then
                                inputAttacherJoint.lowerDistanceToGround = cutHeight
                            end
                        end
                    end
                end
            end
        end
    end

```

### tiltRaycastDetectionCallbackLeft

**Description**

**Definition**

> tiltRaycastDetectionCallbackLeft()

**Arguments**

| any | hitObjectId   |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |
| any | distance      |
| any | nx            |
| any | ny            |
| any | nz            |
| any | subShapeIndex |
| any | hitShapeId    |
| any | isLast        |

**Code**

```lua
function Cutter:tiltRaycastDetectionCallbackLeft(hitObjectId, x, y, z, distance, nx, ny, nz, subShapeIndex, hitShapeId, isLast)
    if hitObjectId ~ = 0 and getRigidBodyType(hitObjectId) = = RigidBodyType.STATIC then
        local automaticTilt = self.spec_cutter.automaticTilt
        automaticTilt.lastHit1[ 1 ] = x
        automaticTilt.lastHit1[ 2 ] = y
        automaticTilt.lastHit1[ 3 ] = z

        return false
    end

    return true
end

```

### tiltRaycastDetectionCallbackRight

**Description**

**Definition**

> tiltRaycastDetectionCallbackRight()

**Arguments**

| any | hitObjectId   |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |
| any | distance      |
| any | nx            |
| any | ny            |
| any | nz            |
| any | subShapeIndex |
| any | hitShapeId    |
| any | isLast        |

**Code**

```lua
function Cutter:tiltRaycastDetectionCallbackRight(hitObjectId, x, y, z, distance, nx, ny, nz, subShapeIndex, hitShapeId, isLast)
    if self.isDeleted or self.isDeleting then
        return
    end

    local automaticTilt = self.spec_cutter.automaticTilt

    if hitObjectId ~ = 0 and getRigidBodyType(hitObjectId) = = RigidBodyType.STATIC then
        automaticTilt.lastHit2[ 1 ] = x
        automaticTilt.lastHit2[ 2 ] = y
        automaticTilt.lastHit2[ 3 ] = z
    end

    if isLast then
        local rDirX, rDirY, rDirZ = localDirectionToWorld(automaticTilt.raycastNode1, 0 , - 1 , 0 )

        local hit1X, hit1Y, hit1Z = automaticTilt.lastHit1[ 1 ], automaticTilt.lastHit1[ 2 ], automaticTilt.lastHit1[ 3 ]
        local node1X, node1Y, node1Z = getWorldTranslation(automaticTilt.raycastNode1)

        local hit2X, hit2Y, hit2Z = automaticTilt.lastHit2[ 1 ], automaticTilt.lastHit2[ 2 ], automaticTilt.lastHit2[ 3 ]
        local node2X, node2Y, node2Z = getWorldTranslation(automaticTilt.raycastNode2)

        -- calaculate ground angle
        local gHeight = hit1Y - hit2Y
        local gRefX, gRefY, gRefZ = hit2X + rDirX * gHeight, hit2Y + rDirY * gHeight, hit2Z + rDirZ * gHeight
        local gDistance = MathUtil.vector3Length(hit1X - gRefX, hit1Y - gRefY, hit1Z - gRefZ)
        local gDirection = (hit2Y > hit1Y and - 1 or 1 )
        local gAngle = math.atan( math.abs(gHeight) / gDistance) * gDirection

        -- calculate current cutter angle
        local cHeight = node2Y - node1Y
        --#debug local cRefX, cRefY, cRefZ = node2X + rDirX * cHeight, node2Y + rDirY * cHeight, node2Z + rDirZ * cHeight
        local cDistance = MathUtil.vector3Length(node1X - node2X, node1Y - node2Y, node1Z - node2Z)
        local cDirection = (node2Y > node1Y and - 1 or 1 )
        local cAngle = math.atan( math.abs(cHeight) / cDistance) * cDirection

        --#debug if VehicleDebug.state = = VehicleDebug.DEBUG then
            --#debug DebugGizmo.renderAtPositionSimple(hit1X, hit1Y, hit1Z, "r1")
            --#debug DebugGizmo.renderAtPositionSimple(hit2X, hit2Y, hit2Z, "r2")
            --#debug drawDebugLine(hit1X, hit1Y, hit1Z, 0, 1, 0, gRefX, gRefY, gRefZ, 0, 1, 0)
            --#debug drawDebugLine(hit1X, hit1Y, hit1Z, 1, 1, 0, hit2X, hit2Y, hit2Z, 1, 1, 0)
            --#debug drawDebugLine(node1X, node1Y, node1Z, 0, 1, 0, cRefX, cRefY, cRefZ, 0, 1, 0)
            --#debug drawDebugLine(node1X, node1Y, node1Z, 1, 1, 0, node2X, node2Y, node2Z, 1, 1, 0)
            --#debug end

            if not MathUtil.isNan(gAngle) and not MathUtil.isNan(cAngle) then
                automaticTilt.currentDelta = gAngle - cAngle
            end
        end
    end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function Cutter:updateDebugValues(values)
    local spec = self.spec_cutter
    table.insert(values, { name = "lastPrioritizedOutputType" , value = string.format( "%s" , g_fillTypeManager:getFillTypeNameByIndex(spec.lastPrioritizedOutputType)) } )
    table.insert(values, { name = "currentCutHeight" , value = string.format( "%.2f" , spec.currentCutHeight) } )

    local sum = 0
    for fillType, value in pairs(spec.lastOutputFillTypes) do
        sum = sum + value
    end

    for fillType, value in pairs(spec.lastOutputFillTypes) do
        table.insert(values, { name = string.format( "buffer(%s)" , g_fillTypeManager:getFillTypeNameByIndex(fillType)), value = string.format( "%.0f%%" , value / math.max(sum, 0.01 ) * 100 ) } )
    end
end

```

### writeCutterToStream

**Description**

**Definition**

> writeCutterToStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Cutter:writeCutterToStream(streamId, connection)
    local spec = self.spec_cutter

    streamWriteUIntN(streamId, spec.currentGrowthState, 4 )
    streamWriteUIntN(streamId, spec.currentInputFruitType, FruitTypeManager.SEND_NUM_BITS)
    streamWriteBool(streamId, spec.currentInputFruitType = = spec.lastValidInputFruitType)

    if streamWriteBool(streamId, spec.useWindrow) then
        streamWriteUIntN(streamId, spec.currentInputFillType, FillTypeManager.SEND_NUM_BITS)
    end
end

```