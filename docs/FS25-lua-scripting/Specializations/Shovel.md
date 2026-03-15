## Shovel

**Description**

> Specialization for shovels providing functionality to pick up filltypes from the ground

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getCanShovelAtPosition](#getcanshovelatposition)
- [getCanToggleDischargeToGround](#getcantoggledischargetoground)
- [getCanToggleDischargeToObject](#getcantoggledischargetoobject)
- [getDischargeNodeEmptyFactor](#getdischargenodeemptyfactor)
- [getIsDischargeNodeActive](#getisdischargenodeactive)
- [getIsShovelEffectState](#getisshoveleffectstate)
- [getShovelNodeIsActive](#getshovelnodeisactive)
- [getShovelTipFactor](#getshoveltipfactor)
- [getWearMultiplier](#getwearmultiplier)
- [handleDischarge](#handledischarge)
- [handleDischargeOnEmpty](#handledischargeonempty)
- [handleDischargeRaycast](#handledischargeraycast)
- [initSpecialization](#initspecialization)
- [loadShovelNode](#loadshovelnode)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateDebugValues](#updatedebugvalues)

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
function Shovel:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self.spec_shovel.useSpeedLimit and( self.getIsTurnedOn = = nil or self:getIsTurnedOn()))
end

```

### getCanShovelAtPosition

**Description**

**Definition**

> getCanShovelAtPosition()

**Arguments**

| any | shovelNode |
|-----|------------|

**Code**

```lua
function Shovel:getCanShovelAtPosition(shovelNode)
    if shovelNode = = nil then
        return false
    end

    if shovelNode.ignoreFarmlandState then
        return true
    end

    local sx,_,sz = localToWorld(shovelNode.node, - shovelNode.width * 0.5 , 0 , 0 )
    local activeFarm = self:getActiveFarm()

    local ex,_,ez = localToWorld(shovelNode.node, shovelNode.width * 0.5 , 0 , 0 )

    if g_densityMapHeightManager:getIsInFreeAccessArea(sx, sz, ex, ez) then
        return true
    end

    local isStartOwned = g_currentMission.accessHandler:canFarmAccessLand(activeFarm, sx, sz)
    if not isStartOwned then
        return false
    end

    return g_currentMission.accessHandler:canFarmAccessLand(activeFarm, ex, ez)
end

```

### getCanToggleDischargeToGround

**Description**

**Definition**

> getCanToggleDischargeToGround()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Shovel:getCanToggleDischargeToGround(superFunc)
    if self.spec_shovel.shovelDischargeInfo.node ~ = nil then
        return false
    end

    return superFunc( self )
end

```

### getCanToggleDischargeToObject

**Description**

**Definition**

> getCanToggleDischargeToObject()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Shovel:getCanToggleDischargeToObject(superFunc)
    if self.spec_shovel.shovelDischargeInfo.node ~ = nil then
        return false
    end

    return superFunc( self )
end

```

### getDischargeNodeEmptyFactor

**Description**

**Definition**

> getDischargeNodeEmptyFactor()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Shovel:getDischargeNodeEmptyFactor(superFunc, dischargeNode)
    local spec = self.spec_shovel

    local parentFactor = superFunc( self , dischargeNode)

    local info = spec.shovelDischargeInfo
    if info.node ~ = nil then
        if info.dischargeNodeIndex = = dischargeNode.index then
            return parentFactor * self:getShovelTipFactor()
        end
    end

    return parentFactor
end

```

### getIsDischargeNodeActive

**Description**

**Definition**

> getIsDischargeNodeActive()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Shovel:getIsDischargeNodeActive(superFunc, dischargeNode)
    local spec = self.spec_shovel

    local info = spec.shovelDischargeInfo
    if info.node ~ = nil then
        if info.dischargeNodeIndex = = dischargeNode.index then
            if self:getShovelTipFactor() = = 0 then
                return false
            end
        end
    end

    return superFunc( self , dischargeNode)
end

```

### getIsShovelEffectState

**Description**

> Returns if shovel effect is active

**Definition**

> getIsShovelEffectState()

**Return Values**

| any | isActive | shovel effect is active |
|-----|----------|-------------------------|

**Code**

```lua
function Shovel:getIsShovelEffectState()
    local spec = self.spec_shovel
    return spec.loadingFillType ~ = FillType.UNKNOWN, spec.loadingFillType
end

```

### getShovelNodeIsActive

**Description**

**Definition**

> getShovelNodeIsActive()

**Arguments**

| any | shovelNode |
|-----|------------|

**Code**

```lua
function Shovel:getShovelNodeIsActive(shovelNode)
    local isActive = true

    if shovelNode.needsMovement then
        local x,y,z = getWorldTranslation(shovelNode.node)
        local _,_,dz = worldToLocal(shovelNode.node, shovelNode.lastPosition[ 1 ], shovelNode.lastPosition[ 2 ], shovelNode.lastPosition[ 3 ])
        isActive = isActive and dz < 0

        shovelNode.lastPosition[ 1 ] = x
        shovelNode.lastPosition[ 2 ] = y
        shovelNode.lastPosition[ 3 ] = z
    end

    if shovelNode.maxPickupAngle ~ = nil then
        local _,dy,_ = localDirectionToWorld(shovelNode.node, 0 , 0 , 1 )
        local angle = math.acos(dy)
        if angle > shovelNode.maxPickupAngle then
            return false
        end
    end

    if shovelNode.needsAttacherVehicle then
        if self.getAttacherVehicle ~ = nil and self:getAttacherVehicle() = = nil then
            return false
        end
    end

    return isActive
end

```

### getShovelTipFactor

**Description**

**Definition**

> getShovelTipFactor()

**Code**

```lua
function Shovel:getShovelTipFactor()
    local spec = self.spec_shovel

    local info = spec.shovelDischargeInfo
    if info.node ~ = nil then
        local _,dy,_ = localDirectionToWorld(info.node, 0 , 0 , 1 )
        local angle = math.acos(dy)
        if angle > info.minSpeedAngle then
            return math.max( 0 , math.min( 1.0 , (angle - info.minSpeedAngle) / (info.maxSpeedAngle - info.minSpeedAngle)))
        end
    end

    return 0
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

| any | wearMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Shovel:getWearMultiplier(superFunc)
    local spec = self.spec_shovel
    local multiplier = superFunc( self )

    if spec.loadingFillType ~ = FillType.UNKNOWN then
        multiplier = multiplier + self:getWorkWearMultiplier()
    end

    return multiplier
end

```

### handleDischarge

**Description**

**Definition**

> handleDischarge()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | dischargeNode       |
| any | dischargedLiters    |
| any | minDropReached      |
| any | hasMinDropFillLevel |

**Code**

```lua
function Shovel:handleDischarge(superFunc, dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
    local spec = self.spec_shovel
    -- do nothing if it is shovel dischargenode
        if dischargeNode.index ~ = spec.shovelDischargeInfo.dischargeNodeIndex or spec.shovelDischargeInfo.node = = nil then
            superFunc( self , dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
        end
    end

```

### handleDischargeOnEmpty

**Description**

**Definition**

> handleDischargeOnEmpty()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | dischargedLiters    |
| any | minDropReached      |
| any | hasMinDropFillLevel |

**Code**

```lua
function Shovel:handleDischargeOnEmpty(superFunc, dischargedLiters, minDropReached, hasMinDropFillLevel)
    if self.spec_shovel.shovelDischargeInfo.node = = nil then
        superFunc( self , dischargedLiters, minDropReached, hasMinDropFillLevel)
    end
end

```

### handleDischargeRaycast

**Description**

**Definition**

> handleDischargeRaycast()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | dischargeNode    |
| any | hitObject        |
| any | hitShape         |
| any | hitDistance      |
| any | hitFillUnitIndex |
| any | hitTerrain       |

**Code**

```lua
function Shovel:handleDischargeRaycast(superFunc, dischargeNode, hitObject, hitShape, hitDistance, hitFillUnitIndex, hitTerrain)
    local spec = self.spec_shovel
    if spec.shovelDischargeInfo.node ~ = nil and spec.shovelDischargeInfo.dischargeNodeIndex = = dischargeNode.index then
        if hitObject ~ = nil then
            local fillType = self:getDischargeFillType(dischargeNode)
            local allowFillType = hitObject:getFillUnitAllowsFillType(hitFillUnitIndex, fillType)
            if allowFillType and hitObject:getFillUnitFreeCapacity(hitFillUnitIndex, fillType, self:getOwnerFarmId()) > 0 then
                self:setDischargeState( Dischargeable.DISCHARGE_STATE_OBJECT, true )
            else
                    if self:getDischargeState() = = Dischargeable.DISCHARGE_STATE_OBJECT then
                        self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF, true )
                    end
                end
            else
                    local fillLevel = self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
                    if fillLevel > 0 and self:getShovelTipFactor() > 0 then
                        if self:getCanDischargeToGround(dischargeNode) then
                            if self:getCanDischargeToLand(dischargeNode) then
                                if self:getCanDischargeAtPosition(dischargeNode) then
                                    self:setDischargeState( Dischargeable.DISCHARGE_STATE_GROUND, true )
                                else
                                        if self.isActiveForInputIgnoreSelectionIgnoreAI then
                                            local warning = self:getDischargeNotAllowedWarning(dischargeNode)
                                            g_currentMission:showBlinkingWarning(warning, 500 )
                                        end
                                    end
                                else
                                        if self.isActiveForInputIgnoreSelectionIgnoreAI then
                                            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_youDontHaveAccessToThisLand" ), 500 )
                                        end
                                    end
                                end
                            end
                        end
                    else
                            superFunc( self , dischargeNode, hitObject, hitShape, hitDistance, hitFillUnitIndex, hitTerrain)
                        end
                    end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Shovel.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Shovel" )

    schema:register(XMLValueType.BOOL, "vehicle.shovel#ignoreFillUnitFillType" , "Ignore fill unit fill type" , false )
    schema:register(XMLValueType.BOOL, "vehicle.shovel#useSpeedLimit" , "Use speed limit while shovel is turned on" , false )

        schema:register(XMLValueType.NODE_INDEX, Shovel.SHOVEL_NODE_XML_KEY .. "#node" , "Shovel node" )
        schema:register(XMLValueType.INT, Shovel.SHOVEL_NODE_XML_KEY .. "#fillUnitIndex" , "Fill unit index" , 1 )
        schema:register(XMLValueType.INT, Shovel.SHOVEL_NODE_XML_KEY .. "#loadInfoIndex" , "Load info index" , 1 )
        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#width" , "Shovel node width" , 1 )
        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#length" , "Shovel node length" , 0.5 )
        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#yOffset" , "Shovel node y offset" , 0 )
        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#zOffset" , "Shovel node z offset" , 0 )
        schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. "#needsMovement" , "Needs movement" , true )
        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#fillLitersPerSecond" , "Fill liters per second" , "inf." )
        schema:register(XMLValueType.ANGLE, Shovel.SHOVEL_NODE_XML_KEY .. "#maxPickupAngle" , "Max.pickup angle" )
        schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. "#needsAttacherVehicle" , "Needs attacher vehicle connected" , true )
        schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. "#resetFillLevel" , "Reset fill level to zero while the shovel node is not active" , false )
            schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. "#ignoreFillLevel" , "Ignore fill level of the fill unit while filling" , false )
                schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. "#ignoreFarmlandState" , "Ignore farmland state for pickup" , false )
                    schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. ".smoothing#allowed" , "Leveler smoothes while driving backward" , false )
                        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. ".smoothing#radius" , "Smooth ground radius" , 0.5 )
                        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. ".smoothing#overlap" , "Radius overlap" , 1.7 )

                        schema:register(XMLValueType.INT, "vehicle.shovel.dischargeInfo#dischargeNodeIndex" , "Discharge node index" , 1 )
                        schema:register(XMLValueType.NODE_INDEX, "vehicle.shovel.dischargeInfo#node" , "Discharge info node" )

                        schema:register(XMLValueType.ANGLE, "vehicle.shovel.dischargeInfo#minSpeedAngle" , "Discharge info min.speed angle" )
                        schema:register(XMLValueType.ANGLE, "vehicle.shovel.dischargeInfo#maxSpeedAngle" , "Discharge info max.speed angle" )

                        EffectManager.registerEffectXMLPaths(schema, "vehicle.shovel.fillEffect" )

                        schema:setXMLSpecializationType()
                    end

```

### loadShovelNode

**Description**

**Definition**

> loadShovelNode()

**Arguments**

| any | xmlFile    |
|-----|------------|
| any | key        |
| any | shovelNode |

**Code**

```lua
function Shovel:loadShovelNode(xmlFile, key, shovelNode)
    shovelNode.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if shovelNode.node = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing 'node' for shovelNode '%s'!" , key)
            return false
        end

        shovelNode.fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" , 1 )
        shovelNode.loadInfoIndex = xmlFile:getValue(key .. "#loadInfoIndex" , 1 )

        shovelNode.width = xmlFile:getValue(key .. "#width" , 1 )
        shovelNode.length = xmlFile:getValue(key .. "#length" , 0.5 )
        shovelNode.yOffset = xmlFile:getValue(key .. "#yOffset" , 0 )
        shovelNode.zOffset = xmlFile:getValue(key .. "#zOffset" , 0 )

        shovelNode.needsMovement = xmlFile:getValue(key .. "#needsMovement" , true )
        shovelNode.lastPosition = { 0 , 0 , 0 }

        shovelNode.fillLitersPerSecond = xmlFile:getValue(key .. "#fillLitersPerSecond" , math.huge) / 1000
        shovelNode.maxPickupAngle = xmlFile:getValue(key .. "#maxPickupAngle" )

        shovelNode.needsAttacherVehicle = xmlFile:getValue(key .. "#needsAttacherVehicle" , true )

        shovelNode.resetFillLevel = xmlFile:getValue(key .. "#resetFillLevel" , false )
        shovelNode.ignoreFillLevel = xmlFile:getValue(key .. "#ignoreFillLevel" , false )
        shovelNode.ignoreFarmlandState = xmlFile:getValue(key .. "#ignoreFarmlandState" , false )

        shovelNode.allowsSmoothing = xmlFile:getValue(key .. ".smoothing#allowed" , false )
        shovelNode.smoothGroundRadius = xmlFile:getValue(key .. ".smoothing#radius" , 0.5 )
        shovelNode.smoothOverlap = xmlFile:getValue(key .. ".smoothing#overlap" , 1.7 )

        return true
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Shovel:onDelete()
    local spec = self.spec_shovel
    g_effectManager:deleteEffects(spec.fillEffects)
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
function Shovel:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer then
        local spec = self.spec_shovel
        for _,shovelNode in pairs(spec.shovelNodes) do
            if shovelNode.fillUnitIndex = = fillUnitIndex then
                if shovelNode.capacityChanged then
                    local fillUnit = self:getFillUnitByIndex(fillUnitIndex)

                    if fillUnit.fillLevel < = fillUnit.defaultCapacity then
                        self:setFillUnitCapacity(fillUnitIndex, fillUnit.defaultCapacity)
                        shovelNode.capacityChanged = false
                    end
                end
            end
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
function Shovel:onLoad(savegame)
    local spec = self.spec_shovel

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpNode" , "vehicle.shovel.shovelNode#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpWidth" , "vehicle.shovel.shovelNode#width" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpLength" , "vehicle.shovel.shovelNode#length" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpYOffset" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpRequiresMovement" , "vehicle.shovel.shovelNode#needsMovement" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.shovel#pickUpNeedsToBeTurnedOn" , "vehicle.shovel.shovelNode#needsActivation" ) --FS17 to FS19

    spec.ignoreFillUnitFillType = self.xmlFile:getValue( "vehicle.shovel#ignoreFillUnitFillType" , false )
    spec.useSpeedLimit = self.xmlFile:getValue( "vehicle.shovel#useSpeedLimit" , false )

    spec.shovelNodes = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.shovel.shovelNode(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local shovelNode = { }

        if self:loadShovelNode( self.xmlFile, key, shovelNode) then
            table.insert(spec.shovelNodes, shovelNode)
        end
        i = i + 1
    end

    spec.shovelDischargeInfo = { }
    spec.shovelDischargeInfo.dischargeNodeIndex = self.xmlFile:getValue( "vehicle.shovel.dischargeInfo#dischargeNodeIndex" , 1 )
    spec.shovelDischargeInfo.node = self.xmlFile:getValue( "vehicle.shovel.dischargeInfo#node" , nil , self.components, self.i3dMappings)

    if spec.shovelDischargeInfo.node ~ = nil then
        local minSpeedAngle = self.xmlFile:getValue( "vehicle.shovel.dischargeInfo#minSpeedAngle" )
        local maxSpeedAngle = self.xmlFile:getValue( "vehicle.shovel.dischargeInfo#maxSpeedAngle" )
        if minSpeedAngle = = nil or maxSpeedAngle = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing 'minSpeedAngle' or 'maxSpeedAngle' for dischargeNode 'vehicle.shovel.dischargeInfo'" )
                return false
            end
            spec.shovelDischargeInfo.minSpeedAngle = minSpeedAngle
            spec.shovelDischargeInfo.maxSpeedAngle = maxSpeedAngle
        end

        if self.isClient then
            spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.shovel.fillEffect" , self.components, self , self.i3dMappings)
            spec.fillEffectTime = 0
        end

        spec.effectDirtyFlag = self:getNextDirtyFlag()
        spec.loadingFillType = FillType.UNKNOWN
        spec.lastValidFillType = FillType.UNKNOWN
        spec.smoothAccumulation = 0

        if #spec.shovelNodes = = 0 then
            SpecializationUtil.removeEventListener( self , "onReadStream" , Shovel )
            SpecializationUtil.removeEventListener( self , "onWriteStream" , Shovel )
            SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , Shovel )
            SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , Shovel )
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , Shovel )
            SpecializationUtil.removeEventListener( self , "onFillUnitFillLevelChanged" , Shovel )
        end

        return true
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
function Shovel:onReadStream(streamId, connection)
    local spec = self.spec_shovel
    spec.loadingFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
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
function Shovel:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_shovel

        if streamReadBool(streamId) then
            spec.loadingFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
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
function Shovel:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_shovel

    if self.isServer then
        local validPickupFillType = FillType.UNKNOWN
        for _, shovelNode in pairs(spec.shovelNodes) do
            if self:getShovelNodeIsActive(shovelNode) then
                local fillLevel = self:getFillUnitFillLevel(shovelNode.fillUnitIndex)
                local capacity = self:getFillUnitCapacity(shovelNode.fillUnitIndex)

                local freeCapacity = math.huge
                if not shovelNode.ignoreFillLevel then
                    -- use the getFillUnitFreeCapacity if it's lower as the default free capacity
                        -- this can be the case if the weight limit stops the shovel from getting full
                            freeCapacity = math.min(capacity - fillLevel, self:getFillUnitFreeCapacity(shovelNode.fillUnitIndex))
                        end
                        freeCapacity = math.min(freeCapacity, shovelNode.fillLitersPerSecond * dt)
                        if freeCapacity > 0 then
                            local pickupFillType = self:getFillUnitFillType(shovelNode.fillUnitIndex)
                            if fillLevel / capacity < self:getFillTypeChangeThreshold() then
                                pickupFillType = FillType.UNKNOWN
                            end
                            local minValidLiter = g_densityMapHeightManager:getMinValidLiterValue(pickupFillType) or 0
                            local sx,sy,sz = localToWorld(shovelNode.node, - shovelNode.width * 0.5 , shovelNode.yOffset, shovelNode.zOffset)
                            local ex,ey,ez = localToWorld(shovelNode.node, shovelNode.width * 0.5 , shovelNode.yOffset, shovelNode.zOffset)
                            local innerRadius = shovelNode.length
                            local radius = nil

                            if self:getCanShovelAtPosition(shovelNode) then
                                if pickupFillType = = FillType.UNKNOWN or spec.ignoreFillUnitFillType then
                                    pickupFillType = DensityMapHeightUtil.getFillTypeAtLine(sx,sy,sz, ex,ey,ez, innerRadius)
                                end

                                if pickupFillType ~ = FillType.UNKNOWN and self:getFillUnitSupportsFillType(shovelNode.fillUnitIndex, pickupFillType) and self:getFillUnitAllowsFillType(shovelNode.fillUnitIndex, pickupFillType) then
                                    local fillDelta, lineOffset = DensityMapHeightUtil.tipToGroundAroundLine( self , - freeCapacity - minValidLiter, pickupFillType, sx,sy,sz, ex,ey,ez, innerRadius, radius, shovelNode.lineOffset, true , nil )
                                    shovelNode.lineOffset = lineOffset

                                    if not shovelNode.ignoreFillLevel and - fillDelta > freeCapacity then
                                        self:setFillUnitCapacity(shovelNode.fillUnitIndex, fillLevel - fillDelta)
                                        shovelNode.capacityChanged = true
                                    end

                                    if fillDelta < 0 then
                                        local loadInfo = self:getFillVolumeLoadInfo(shovelNode.loadInfoIndex)
                                        self:addFillUnitFillLevel( self:getOwnerFarmId(), shovelNode.fillUnitIndex, - fillDelta, pickupFillType, ToolType.UNDEFINED, loadInfo)
                                        validPickupFillType = pickupFillType

                                        -- call fill level changed callack to inform bunker silo about change
                                        self:notifiyBunkerSilo(fillDelta, pickupFillType, (sx + ex) * 0.5 , (sy + ey) * 0.5 , (sz + ez) * 0.5 )
                                    end
                                end
                            end
                        end
                    elseif shovelNode.resetFillLevel then
                            local fillLevel = self:getFillUnitFillLevel(shovelNode.fillUnitIndex)
                            if fillLevel > 0 then
                                self:addFillUnitFillLevel( self:getOwnerFarmId(), shovelNode.fillUnitIndex, - fillLevel, self:getFillUnitFillType(shovelNode.fillUnitIndex), ToolType.UNDEFINED)
                            end
                        end

                        if shovelNode.allowsSmoothing then
                            local _,dy,_ = localDirectionToWorld(shovelNode.node, 0 , 0 , 1 )
                            local angle = math.acos(dy)
                            if angle > shovelNode.maxPickupAngle then
                                local smoothAmount = 0
                                if self.lastSpeedReal > 0.0002 then -- start smoothing if driving faster than 0.7km/h
                                    smoothAmount = spec.smoothAccumulation + math.max( self.lastMovedDistance * 0.5 , 0.0003 * dt) -- smooth 1.2m per meter driving or at least 0.3m/s
                                    local rounded = DensityMapHeightUtil.getRoundedHeightValue(smoothAmount)
                                    spec.smoothAccumulation = smoothAmount - rounded
                                else
                                        spec.smoothAccumulation = 0
                                    end

                                    if smoothAmount > 0 then
                                        DensityMapHeightUtil.smoothAroundLine(shovelNode.node, shovelNode.width, shovelNode.smoothGroundRadius, shovelNode.smoothOverlap, smoothAmount, true )
                                    end
                                end
                            end
                        end

                        if validPickupFillType = = FillType.UNKNOWN then
                            spec.fillEffectTime = spec.fillEffectTime - dt
                            if spec.fillEffectTime > 0 then
                                validPickupFillType = spec.loadingFillType
                            end
                        else
                                spec.fillEffectTime = 500
                            end

                            if spec.loadingFillType ~ = validPickupFillType then
                                spec.loadingFillType = validPickupFillType
                                self:raiseDirtyFlags(spec.effectDirtyFlag)
                            end
                        end

                        if self.isClient then
                            if spec.loadingFillType ~ = FillType.UNKNOWN then
                                g_effectManager:setEffectTypeInfo(spec.fillEffects, spec.loadingFillType)
                                g_effectManager:startEffects(spec.fillEffects)
                            else
                                    g_effectManager:stopEffects(spec.fillEffects)
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
function Shovel:onWriteStream(streamId, connection)
    local spec = self.spec_shovel
    streamWriteUIntN(streamId, spec.loadingFillType, FillTypeManager.SEND_NUM_BITS)
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
function Shovel:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_shovel

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, spec.loadingFillType, FillTypeManager.SEND_NUM_BITS)
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
function Shovel.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and SpecializationUtil.hasSpecialization( FillVolume , specializations) and SpecializationUtil.hasSpecialization( Dischargeable , specializations) and SpecializationUtil.hasSpecialization( BunkerSiloInteractor , specializations)
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
function Shovel.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Shovel )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Shovel )
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
function Shovel.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadShovelNode" , Shovel.loadShovelNode)
    SpecializationUtil.registerFunction(vehicleType, "getShovelNodeIsActive" , Shovel.getShovelNodeIsActive)
    SpecializationUtil.registerFunction(vehicleType, "getCanShovelAtPosition" , Shovel.getCanShovelAtPosition)
    SpecializationUtil.registerFunction(vehicleType, "getShovelTipFactor" , Shovel.getShovelTipFactor)
    SpecializationUtil.registerFunction(vehicleType, "getIsShovelEffectState" , Shovel.getIsShovelEffectState)
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
function Shovel.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsDischargeNodeActive" , Shovel.getIsDischargeNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDischargeNodeEmptyFactor" , Shovel.getDischargeNodeEmptyFactor)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleDischarge" , Shovel.handleDischarge)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleDischargeOnEmpty" , Shovel.handleDischargeOnEmpty)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleDischargeRaycast" , Shovel.handleDischargeRaycast)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleDischargeToObject" , Shovel.getCanToggleDischargeToObject)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleDischargeToGround" , Shovel.getCanToggleDischargeToGround)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Shovel.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Shovel.doCheckSpeedLimit)
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
function Shovel:updateDebugValues(values)
    local spec = self.spec_shovel

    local info = spec.shovelDischargeInfo
    if info.node ~ = nil then
        local _,dy,_ = localDirectionToWorld(info.node, 0 , 0 , 1 )
        local angle = math.acos(dy)
        table.insert(values, { name = "angle" , value = math.deg(angle) } )
        table.insert(values, { name = "minSpeedAngle" , value = math.deg(info.minSpeedAngle) } )
        table.insert(values, { name = "maxSpeedAngle" , value = math.deg(info.maxSpeedAngle) } )

        if angle > info.minSpeedAngle then
            local factor = math.max( 0 , math.min( 1.0 , (angle - info.minSpeedAngle) / (info.maxSpeedAngle - info.minSpeedAngle)))
            table.insert(values, { name = "factor" , value = factor } )
        else
                table.insert(values, { name = "factor" , value = "Out of Range - 0" } )
            end
        end
    end

```