## ForageWagon

**Description**

> Specialization for a forage wagon, expands functions of FillUnit, Pickup and WorkArea by adding a fillEffect

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [fillForageWagon](#fillforagewagon)
- [getConsumingLoad](#getconsumingload)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getFillVolumeUVScrollSpeed](#getfillvolumeuvscrollspeed)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [initSpecialization](#initspecialization)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onTurnedOff](#onturnedoff)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processForageWagonArea](#processforagewagonarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setFillEffectActive](#setfilleffectactive)

### doCheckSpeedLimit

**Description**

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ForageWagon:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and self:getIsLowered())
end

```

### fillForageWagon

**Description**

**Definition**

> fillForageWagon()

**Code**

```lua
function ForageWagon:fillForageWagon()
    local spec = self.spec_forageWagon

    local loadInfo = self:getFillVolumeLoadInfo(spec.loadInfoIndex)
    local filledLiters = self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, spec.workAreaParameters.litersToFill, spec.lastFillType, ToolType.UNDEFINED, loadInfo)

    if filledLiters + 0.01 < spec.workAreaParameters.litersToFill then
        self:setIsTurnedOn( false )
        self:setPickupState( false )
    end

    spec.workAreaParameters.litersToFill = spec.workAreaParameters.litersToFill - filledLiters
    if spec.workAreaParameters.litersToFill < 0.01 then
        spec.workAreaParameters.litersToFill = 0
    end
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
function ForageWagon:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local spec = self.spec_forageWagon
    local loadPercentage = spec.pickUpLitersBuffer:get( 1000 ) / spec.maxPickupLitersPerSecond

    return value + loadPercentage, count + 1
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function ForageWagon.getDefaultSpeedLimit()
    return 20
end

```

### getFillVolumeUVScrollSpeed

**Description**

**Definition**

> getFillVolumeUVScrollSpeed()

**Arguments**

| any | superFunc       |
|-----|-----------------|
| any | fillVolumeIndex |

**Code**

```lua
function ForageWagon:getFillVolumeUVScrollSpeed(superFunc, fillVolumeIndex)
    local spec = self.spec_forageWagon

    if spec.isFilling then
        return spec.loadUVScrollSpeed[ 1 ], spec.loadUVScrollSpeed[ 2 ], spec.loadUVScrollSpeed[ 3 ]
    end

    if self:getDischargeState() ~ = Dischargeable.DISCHARGE_STATE_OFF then
        return spec.dischargeUVScrollSpeed[ 1 ], spec.dischargeUVScrollSpeed[ 2 ], spec.dischargeUVScrollSpeed[ 3 ]
    end

    return superFunc( self , fillVolumeIndex)
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
function ForageWagon:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    local spec = self.spec_forageWagon

    if speedRotatingPart.rotateOnlyIfFillLevelIncreased ~ = nil then
        if speedRotatingPart.rotateOnlyIfFillLevelIncreased and not spec.isFilling then
            return false
        end
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
function ForageWagon:getIsWorkAreaActive(superFunc, workArea)
    local spec = self.spec_forageWagon

    local forageWagonArea = self.spec_workArea.workAreas[spec.workAreaIndex]
    if forageWagonArea ~ = nil and workArea = = forageWagonArea then
        if not self:getIsTurnedOn() or not self:allowPickingUp() then
            return false
        end
    end

    return superFunc( self , workArea)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ForageWagon.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "forageWagon" , false , false , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ForageWagon" )

    schema:register(XMLValueType.INT, "vehicle.forageWagon#workAreaIndex" , "Work area index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.forageWagon#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.forageWagon#loadInfoIndex" , "Load info index" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.forageWagon#maxPickupLitersPerSecond" , "Max.pickup liters per second" , 500 )

    schema:register(XMLValueType.INT, "vehicle.forageWagon.additives#fillUnitIndex" , "Additives fill unit index" )
    schema:register(XMLValueType.FLOAT, "vehicle.forageWagon.additives#usage" , "Usage per picked up liter" , 0.0000275 )
    schema:register(XMLValueType.STRING, "vehicle.forageWagon.additives#fillTypes" , "Fill types to apply additives" , "GRASS_WINDROW" )

    schema:register(XMLValueType.FLOAT, "vehicle.forageWagon.startFillEffect#fillStartDelay" , "if defined the filling of the fill unit will be delayed until this time has passed" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.forageWagon.startFillEffect#fillStartFadeOff" , "Fade out fill level for start fill effect(fillLevel 0:density 1 | fillLevel at fillStartFadeOff:density 0)" , 0 )

            schema:register(XMLValueType.VECTOR_ 3 , "vehicle.forageWagon.fillVolume#loadScrollSpeed" , "Scroll speed while loading" , "0 0 0" )
                schema:register(XMLValueType.VECTOR_ 3 , "vehicle.forageWagon.fillVolume#dischargeScrollSpeed" , "Scroll speed while unloading" , "0 0 0" )

                    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#rotateOnlyIfFillLevelIncreased" , "Rotate only if fill level increased" , false )

                        EffectManager.registerEffectXMLPaths(schema, "vehicle.forageWagon.fillEffect" )
                        EffectManager.registerEffectXMLPaths(schema, "vehicle.forageWagon.startFillEffect" )

                        schema:setXMLSpecializationType()
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
function ForageWagon:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.rotateOnlyIfFillLevelIncreased = xmlFile:getValue(key .. "#rotateOnlyIfFillLevelIncreased" , false )

    return true
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function ForageWagon:onDeactivate()
    if self.isClient then
        local spec = self.spec_forageWagon
        spec.fillTimer = 0
        self:setFillEffectActive( false )
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function ForageWagon:onDelete()
    local spec = self.spec_forageWagon
    g_effectManager:deleteEffects(spec.fillEffects)
    g_effectManager:deleteEffects(spec.startFillEffect)
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
function ForageWagon:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_forageWagon

    if self.isServer then
        if spec.workAreaParameters.lastPickupLiters > 0 then
            local allowToFill = true
            if spec.fillStartEffectTimer > 0 then
                spec.fillStartEffectTimer = spec.fillStartEffectTimer - dt
                if spec.fillStartEffectTimer > 0 then
                    allowToFill = false
                end
            end

            if allowToFill then
                self:fillForageWagon()
            end

            spec.fillTimer = 500
        end
    end
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function ForageWagon:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isClient then
        local spec = self.spec_forageWagon
        local density = 1
        if spec.fillStartEffectFadeOff > 0 then
            density = 1 - math.min( self:getFillUnitFillLevel(spec.fillUnitIndex) / spec.fillStartEffectFadeOff, 1 )
        end
        g_effectManager:setDensity(spec.startFillEffect, density)
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
function ForageWagon:onLoad(savegame)
    local spec = self.spec_forageWagon

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.forageWagon#turnedOnTipScrollerSpeedFactor" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.turnOnVehicle.rotationNodes.rotationNode" , "forageWagon" ) -- FS17 to FS19

    spec.isFilling = false
    spec.isFillingSent = false
    spec.lastFillType = FillType.UNKNOWN
    spec.lastFillTypeSent = FillType.UNKNOWN
    spec.fillTimer = 0

    spec.workAreaIndex = self.xmlFile:getValue( "vehicle.forageWagon#workAreaIndex" , 1 )
    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.forageWagon#fillUnitIndex" , 1 )
    spec.loadInfoIndex = self.xmlFile:getValue( "vehicle.forageWagon#loadInfoIndex" , 1 )

    spec.additives = { }
    spec.additives.fillUnitIndex = self.xmlFile:getValue( "vehicle.forageWagon.additives#fillUnitIndex" )
    spec.additives.available = self:getFillUnitByIndex(spec.additives.fillUnitIndex) ~ = nil
    spec.additives.usage = self.xmlFile:getValue( "vehicle.forageWagon.additives#usage" , 0.0000275 )
    local additivesFillTypeNames = self.xmlFile:getValue( "vehicle.forageWagon.additives#fillTypes" , "GRASS_WINDROW" )
    spec.additives.fillTypes = g_fillTypeManager:getFillTypesByNames(additivesFillTypeNames, "Warning: '" .. self.xmlFile:getFilename() .. "' has invalid fillType '%s'." )

    spec.loadUVScrollSpeed = self.xmlFile:getValue( "vehicle.forageWagon.fillVolume#loadScrollSpeed" , "0 0 0" , true )
    spec.dischargeUVScrollSpeed = self.xmlFile:getValue( "vehicle.forageWagon.fillVolume#dischargeScrollSpeed" , "0 0 0" , true )

    spec.maxPickupLitersPerSecond = self.xmlFile:getValue( "vehicle.forageWagon#maxPickupLitersPerSecond" , 500 )

    if self.isClient then
        spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.forageWagon.fillEffect" , self.components, self , self.i3dMappings)
        spec.startFillEffect = g_effectManager:loadEffect( self.xmlFile, "vehicle.forageWagon.startFillEffect" , self.components, self , self.i3dMappings)
    end

    spec.fillStartEffectDelay = self.xmlFile:getValue( "vehicle.forageWagon.startFillEffect#fillStartDelay" , 0 ) * 0.001
    spec.fillStartEffectTimer = 0
    spec.fillStartEffectFadeOff = self.xmlFile:getValue( "vehicle.forageWagon.startFillEffect#fillStartFadeOff" , 0 )

    spec.workAreaParameters = { }
    spec.workAreaParameters.forcedFillType = FillType.UNKNOWN
    spec.workAreaParameters.lastPickupLiters = 0
    spec.workAreaParameters.litersToFill = 0

    spec.pickUpLitersBuffer = ValueBuffer.new( 750 )

    if spec.startFillEffect = = nil or #spec.startFillEffect = = 0 then
        SpecializationUtil.removeEventListener( self , "onFillUnitFillLevelChanged" , ForageWagon )
    end

    spec.dirtyFlag = self:getNextDirtyFlag()
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
function ForageWagon:onReadStream(streamId, connection)
    local spec = self.spec_forageWagon
    spec.isFilling = streamReadBool(streamId)
    spec.lastFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
    self:setFillEffectActive(spec.isFilling)
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
function ForageWagon:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spec = self.spec_forageWagon
            spec.isFilling = streamReadBool(streamId)
            spec.lastFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
            self:setFillEffectActive(spec.isFilling)
        end
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
function ForageWagon:onStartWorkAreaProcessing(dt)
    local spec = self.spec_forageWagon

    spec.workAreaParameters.forcedFillType = FillType.UNKNOWN
    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
    if fillLevel > self:getFillTypeChangeThreshold(spec.fillUnitIndex) then
        spec.workAreaParameters.forcedFillType = self:getFillUnitFillType(spec.fillUnitIndex)
    end

    if fillLevel = = 0 and spec.fillStartEffectDelay > 0 and spec.fillStartEffectTimer < = 0 then
        spec.fillStartEffectTimer = spec.fillStartEffectDelay
    end

    spec.workAreaParameters.lastPickupLiters = 0
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function ForageWagon:onTurnedOff()
    local spec = self.spec_forageWagon

    if self.isClient then
        spec.fillTimer = 0
        self:setFillEffectActive( false )
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
function ForageWagon:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_forageWagon

    if self.isServer then
        local isFilling = false
        if spec.fillTimer > 0 then
            spec.fillTimer = spec.fillTimer - dt
            isFilling = true
        end
        spec.isFilling = isFilling

        if spec.isFilling ~ = spec.isFillingSent then
            self:raiseDirtyFlags(spec.dirtyFlag)
            spec.isFillingSent = spec.isFilling
            self:setFillEffectActive(spec.isFilling)
        end

        spec.pickUpLitersBuffer:add(spec.workAreaParameters.lastPickupLiters)
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
function ForageWagon:onWriteStream(streamId, connection)
    local spec = self.spec_forageWagon
    streamWriteBool(streamId, spec.isFillingSent)
    streamWriteUIntN(streamId, spec.lastFillType, FillTypeManager.SEND_NUM_BITS)
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
function ForageWagon:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_forageWagon
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteBool(streamId, spec.isFillingSent)
            streamWriteUIntN(streamId, spec.lastFillType, FillTypeManager.SEND_NUM_BITS)
        end
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
function ForageWagon.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and
    SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations) and
    SpecializationUtil.hasSpecialization( Pickup , specializations) and
    SpecializationUtil.hasSpecialization( WorkArea , specializations)
end

```

### processForageWagonArea

**Description**

**Definition**

> processForageWagonArea()

**Arguments**

| any | workArea |
|-----|----------|

**Code**

```lua
function ForageWagon:processForageWagonArea(workArea)
    local spec = self.spec_forageWagon

    local radius = 0.5
    local lsx, lsy, lsz, lex, ley, lez = DensityMapHeightUtil.getLineByArea(workArea.start, workArea.width, workArea.height)
    local pickupLiters = 0

    if spec.workAreaParameters.forcedFillType ~ = FillType.UNKNOWN then
        pickupLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, spec.workAreaParameters.forcedFillType, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )

        if spec.workAreaParameters.forcedFillType = = FillType.GRASS_WINDROW then
            pickupLiters = pickupLiters - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, FillType.DRYGRASS_WINDROW, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )
        elseif spec.workAreaParameters.forcedFillType = = FillType.DRYGRASS_WINDROW then
                pickupLiters = pickupLiters - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, FillType.GRASS_WINDROW, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )
            end
        else
                local supportedFillTypes = self:getFillUnitSupportedFillTypes(spec.fillUnitIndex)
                if supportedFillTypes ~ = nil then
                    for fillType,state in pairs(supportedFillTypes) do
                        if state then
                            pickupLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, fillType, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )
                            if pickupLiters > 0 then
                                spec.workAreaParameters.forcedFillType = fillType
                                break
                            end
                        end
                    end
                end
            end

            if self.isServer then
                if spec.additives.available then
                    local fillTypeSupported = false
                    for i = 1 , #spec.additives.fillTypes do
                        if spec.workAreaParameters.forcedFillType = = spec.additives.fillTypes[i] then
                            fillTypeSupported = true
                            break
                        end
                    end

                    if fillTypeSupported then
                        local additivesFillLevel = self:getFillUnitFillLevel(spec.additives.fillUnitIndex)
                        if additivesFillLevel > 0 then
                            local usage = spec.additives.usage * pickupLiters
                            if usage > 0 then
                                local availableUsage = math.min(additivesFillLevel / usage, 1 )

                                pickupLiters = pickupLiters * ( 1 + 0.05 * availableUsage)

                                self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.additives.fillUnitIndex, - usage, self:getFillUnitFillType(spec.additives.fillUnitIndex), ToolType.UNDEFINED)
                            end
                        end
                    end
                end
            end

            workArea.lastPickUpLiters = pickupLiters
            workArea.pickupParticlesActive = pickupLiters > 0
            spec.workAreaParameters.lastPickupLiters = spec.workAreaParameters.lastPickupLiters + pickupLiters
            spec.workAreaParameters.litersToFill = spec.workAreaParameters.litersToFill + pickupLiters
            if spec.workAreaParameters.forcedFillType ~ = FillType.UNKNOWN then
                spec.lastFillType = spec.workAreaParameters.forcedFillType
                if spec.lastFillType ~ = spec.lastFillTypeSent then
                    spec.lastFillTypeSent = spec.lastFillType
                    self:raiseDirtyFlags(spec.dirtyFlag)
                end
            end

            local realArea, area = 0 , 0

            if self.movingDirection = = 1 then
                local width = MathUtil.vector3Length(lsx - lex, lsy - ley, lsz - lez)
                area = width * self.lastMovedDistance
                realArea = area
            end

            return realArea, area
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
function ForageWagon.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , ForageWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , ForageWagon )
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
function ForageWagon.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processForageWagonArea" , ForageWagon.processForageWagonArea)
    SpecializationUtil.registerFunction(vehicleType, "setFillEffectActive" , ForageWagon.setFillEffectActive)
    SpecializationUtil.registerFunction(vehicleType, "fillForageWagon" , ForageWagon.fillForageWagon)
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
function ForageWagon.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , ForageWagon.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , ForageWagon.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , ForageWagon.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , ForageWagon.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , ForageWagon.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillVolumeUVScrollSpeed" , ForageWagon.getFillVolumeUVScrollSpeed)
end

```

### setFillEffectActive

**Description**

**Definition**

> setFillEffectActive()

**Arguments**

| any | isActive |
|-----|----------|

**Code**

```lua
function ForageWagon:setFillEffectActive(isActive)
    local spec = self.spec_forageWagon
    if isActive then
        g_effectManager:setEffectTypeInfo(spec.fillEffects, spec.lastFillType)
        g_effectManager:setEffectTypeInfo(spec.startFillEffect, spec.lastFillType)
        g_effectManager:startEffects(spec.fillEffects)
        g_effectManager:startEffects(spec.startFillEffect)
    else
            g_effectManager:stopEffects(spec.fillEffects)
            g_effectManager:stopEffects(spec.startFillEffect)
        end
    end

```