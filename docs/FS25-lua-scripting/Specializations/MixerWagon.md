## MixerWagon

**Description**

> Specialization for forage mixer wagons creating forage from bales, chaff, straw and/or hay

**Functions**

- [addFillUnitFillLevel](#addfillunitfilllevel)
- [getConsumingLoad](#getconsumingload)
- [getDischargeFillType](#getdischargefilltype)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getFillUnitAllowsFillType](#getfillunitallowsfilltype)
- [getIsBaleAutoLoadable](#getisbaleautoloadable)
- [getIsPowerTakeOffActive](#getispowertakeoffactive)
- [initSpecialization](#initspecialization)
- [mixerWagonBaleTriggerCallback](#mixerwagonbaletriggercallback)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onMixerWagonBaleDeleted](#onmixerwagonbaledeleted)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [updateDebugValues](#updatedebugvalues)

### addFillUnitFillLevel

**Description**

**Definition**

> addFillUnitFillLevel()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | farmId           |
| any | fillUnitIndex    |
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |

**Code**

```lua
function MixerWagon:addFillUnitFillLevel(superFunc, farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    local spec = self.spec_mixerWagon

    if fillUnitIndex ~ = spec.fillUnitIndex then
        return superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    end

    if #spec.mixerWagonFillTypes = = 0 then
        if fillLevelDelta ~ = 0 and self:getIsSynchronized() then
            spec.activeTimer = spec.activeTimerMax
        end

        return superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    end

    local oldFillLevel = self:getFillUnitFillLevel(fillUnitIndex)

    local mixerWagonFillType = spec.fillTypeToMixerWagonFillType[fillTypeIndex]

    -- allow to put forage back to mixer.Split it up into valid forage mixing ratios
    if fillTypeIndex = = FillType.FORAGE and fillLevelDelta > 0 then
        for _, entry in pairs(spec.mixerWagonFillTypes) do
            local delta = fillLevelDelta * entry.ratio
            self:addFillUnitFillLevel(farmId, fillUnitIndex, delta, next(entry.fillTypes), toolType, fillPositionData)
        end

        return fillLevelDelta
    end

    if mixerWagonFillType = = nil then
        -- used for discharge
            if fillLevelDelta < 0 and oldFillLevel > 0 then
                -- remove values from all fill types such that the ratio doesn't change
                fillLevelDelta = math.max(fillLevelDelta, - oldFillLevel)

                local newFillLevel = 0
                for _, entry in pairs(spec.mixerWagonFillTypes) do
                    local entryDelta = fillLevelDelta * (entry.fillLevel / oldFillLevel)
                    entry.fillLevel = math.max(entry.fillLevel + entryDelta, 0 )
                    newFillLevel = newFillLevel + entry.fillLevel
                end

                if newFillLevel < 0.1 then
                    for _, entry in pairs(spec.mixerWagonFillTypes) do
                        entry.fillLevel = 0
                    end
                    fillLevelDelta = - oldFillLevel
                end

                self:raiseDirtyFlags(spec.dirtyFlag)
                local ret = superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
                return ret
            end

            return 0
        end

        local capacity = self:getFillUnitCapacity(fillUnitIndex)
        local free = capacity - oldFillLevel

        if fillLevelDelta > 0 then
            mixerWagonFillType.fillLevel = mixerWagonFillType.fillLevel + math.min(free, fillLevelDelta)

            if self:getIsSynchronized() then
                spec.activeTimer = spec.activeTimerMax
            end
        else
                mixerWagonFillType.fillLevel = math.max( 0 , mixerWagonFillType.fillLevel + fillLevelDelta)
            end

            local newFillLevel = 0
            for _, fillType in pairs(spec.mixerWagonFillTypes) do
                newFillLevel = newFillLevel + fillType.fillLevel
            end
            newFillLevel = math.clamp(newFillLevel, 0 , self:getFillUnitCapacity(fillUnitIndex))

            local newFillType = FillType.UNKNOWN
            local isSingleFilled = false
            local isForageOk = false

            for _, fillType in pairs(spec.mixerWagonFillTypes) do
                if newFillLevel = = fillType.fillLevel then
                    isSingleFilled = true
                    newFillType = next(mixerWagonFillType.fillTypes)
                    break
                end
            end

            if not isSingleFilled then
                isForageOk = true
                for _, fillType in pairs(spec.mixerWagonFillTypes) do
                    if fillType.fillLevel < fillType.minPercentage * newFillLevel - 0.01 or fillType.fillLevel > fillType.maxPercentage * newFillLevel + 0.01 then
                        isForageOk = false
                        break
                    end
                end
            end

            if isForageOk then
                newFillType = FillType.FORAGE
            elseif not isSingleFilled then
                    newFillType = FillType.FORAGE_MIXING
                end

                self:raiseDirtyFlags(spec.dirtyFlag)

                self:setFillUnitFillType(fillUnitIndex, newFillType)

                return superFunc( self , farmId, fillUnitIndex, newFillLevel - oldFillLevel, newFillType, toolType, fillPositionData)
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
function MixerWagon:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local loadPercentage = 0
    if self.spec_mixerWagon.activeTimer > 0 then
        loadPercentage = 1
    end

    return value + loadPercentage, count + 1
end

```

### getDischargeFillType

**Description**

**Definition**

> getDischargeFillType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function MixerWagon:getDischargeFillType(superFunc, dischargeNode)
    local spec = self.spec_mixerWagon
    local fillUnitIndex = dischargeNode.fillUnitIndex

    if fillUnitIndex = = spec.fillUnitIndex then
        local currentFillType = self:getFillUnitFillType(fillUnitIndex)
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)

        if currentFillType = = FillType.FORAGE_MIXING and fillLevel > 0 then
            for _, entry in pairs(spec.mixerWagonFillTypes) do
                if entry.fillLevel > 0 then
                    currentFillType = next(entry.fillTypes)
                    break
                end
            end
        end

        return currentFillType, 1
    end

    return superFunc( self , dischargeNode)
end

```

### getDoConsumePtoPower

**Description**

> Returns if should consume pto power

**Definition**

> getDoConsumePtoPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | consume | consumePtoPower |
|-----|---------|-----------------|

**Code**

```lua
function MixerWagon:getDoConsumePtoPower(superFunc)
    if self.spec_mixerWagon.activeTimer > 0 then
        return true
    end

    return superFunc( self )
end

```

### getFillUnitAllowsFillType

**Description**

**Definition**

> getFillUnitAllowsFillType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | fillTypeIndex |

**Code**

```lua
function MixerWagon:getFillUnitAllowsFillType(superFunc, fillUnitIndex, fillTypeIndex)
    local spec = self.spec_mixerWagon

    if spec.fillUnitIndex = = fillUnitIndex and #spec.mixerWagonFillTypes > 0 then
        local mixerWagonFillType = spec.fillTypeToMixerWagonFillType[fillTypeIndex]
        if mixerWagonFillType ~ = nil then
            return true
        end
    end

    return superFunc( self , fillUnitIndex, fillTypeIndex)
end

```

### getIsBaleAutoLoadable

**Description**

**Definition**

> getIsBaleAutoLoadable()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | bale      |

**Code**

```lua
function MixerWagon:getIsBaleAutoLoadable(superFunc, bale)
    local spec = self.spec_mixerWagon
    if not self:getIsTurnedOn() then
        return false
    end

    for i = 1 , #spec.baleTriggers do
        local baleTrigger = spec.baleTriggers[i]
        -- only allow picking up of the next bale after the last bale has been consumed fully
        if next(baleTrigger.balesInTrigger) ~ = nil then
            return false
        end
    end

    local loadedFillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
    if loadedFillTypeIndex ~ = FillType.UNKNOWN and bale:getFillType() ~ = loadedFillTypeIndex then
        return false
    end

    if self:getFillUnitFreeCapacity(spec.fillUnitIndex) < = 0 then
        return false
    end

    return superFunc( self , bale)
end

```

### getIsPowerTakeOffActive

**Description**

**Definition**

> getIsPowerTakeOffActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function MixerWagon:getIsPowerTakeOffActive(superFunc)
    return self.spec_mixerWagon.activeTimer > 0 or superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function MixerWagon.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "MixerWagon" )

    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.mixerWagon.mixAnimationNodes" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.mixerWagon.pickupAnimationNodes" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.mixerWagon.baleTriggers.baleTrigger(?)#node" , "Bale trigger node" )
    schema:register(XMLValueType.FLOAT, "vehicle.mixerWagon.baleTriggers.baleTrigger(?)#pickupSpeed" , "Bale pickup speed in liter per second" , 500 )
    schema:register(XMLValueType.BOOL, "vehicle.mixerWagon.baleTriggers.baleTrigger(?)#needsSetIsTurnedOn" , "Vehicle needs to be turned on to pickup bales with this trigger" , false )
    schema:register(XMLValueType.BOOL, "vehicle.mixerWagon.baleTriggers.baleTrigger(?)#useEffect" , "Filling effect is played while picking up a bale" , false )

        schema:register(XMLValueType.TIME, "vehicle.mixerWagon#mixingTime" , "Mixing time after the fill level was changed" , 5 )
        schema:register(XMLValueType.INT, "vehicle.mixerWagon#fillUnitIndex" , "Fill unit index" , 1 )
        schema:register(XMLValueType.STRING, "vehicle.mixerWagon#recipe" , "Recipe fill type name" )

        EffectManager.registerEffectXMLPaths(schema, "vehicle.mixerWagon.fillEffect" )

        schema:setXMLSpecializationType()

        local schemaSavegame = Vehicle.xmlSchemaSavegame
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).mixerWagon.fillType(?)#fillLevel" , "Fill level" , 0 )
    end

```

### mixerWagonBaleTriggerCallback

**Description**

> Trigger callback

**Definition**

> mixerWagonBaleTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean
> onStay, integer otherShapeId)

**Arguments**

| integer | triggerId    | id of trigger     |
|---------|--------------|-------------------|
| integer | otherActorId | id of other actor |
| boolean | onEnter      | on enter          |
| boolean | onLeave      | on leave          |
| boolean | onStay       | on stay           |
| integer | otherShapeId | id of other shape |

**Code**

```lua
function MixerWagon:mixerWagonBaleTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    -- this happens if a compound child of a deleted compound is entering
        if otherActorId ~ = 0 then
            local bale = g_currentMission:getNodeObject(otherActorId)
            if bale ~ = nil then
                if bale:isa( Bale ) then
                    local spec = self.spec_mixerWagon

                    if self:getFillUnitSupportsFillType(spec.fillUnitIndex, bale:getFillType()) then
                        for i = 1 , #spec.baleTriggers do
                            local baleTrigger = spec.baleTriggers[i]
                            if baleTrigger.node = = triggerId then
                                if onEnter then
                                    baleTrigger.balesInTrigger[bale] = (baleTrigger.balesInTrigger[bale] or 0 ) + 1
                                    if baleTrigger.balesInTrigger[bale] = = 1 then
                                        bale:addDeleteListener( self , self.onMixerWagonBaleDeleted)
                                    end
                                elseif onLeave then
                                        baleTrigger.balesInTrigger[bale] = (baleTrigger.balesInTrigger[bale] or 1 ) - 1
                                        if baleTrigger.balesInTrigger[bale] = = 0 then
                                            baleTrigger.balesInTrigger[bale] = nil
                                            bale:removeDeleteListener( self , self.onMixerWagonBaleDeleted)
                                        end
                                    end
                                end
                            end
                        else
                                if onEnter and otherActorId = = bale.nodeId then
                                    g_currentMission:broadcastEventToFarm( MixerWagonBaleNotAcceptedEvent.new(), self:getOwnerFarmId(), true )
                                end
                            end
                        end
                    end
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
function MixerWagon:onDelete()
    local spec = self.spec_mixerWagon
    if spec.baleTriggers ~ = nil then
        for _, baleTrigger in ipairs(spec.baleTriggers) do
            removeTrigger(baleTrigger.node)

            for bale, _ in pairs(baleTrigger.balesInTrigger) do
                if bale.removeDeleteListener ~ = nil then
                    bale:removeDeleteListener( self , self.onMixerWagonBaleDeleted)
                end
            end
            table.clear(baleTrigger.balesInTrigger)
        end
        table.clear(spec.baleTriggers)
    end

    g_animationManager:deleteAnimations(spec.mixAnimationNodes)
    g_animationManager:deleteAnimations(spec.pickupAnimationNodes)
    g_effectManager:deleteEffects(spec.fillEffects)

    if spec.hudExtension ~ = nil then
        g_currentMission.hud:removeInfoExtension(spec.hudExtension)
        spec.hudExtension:delete()
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
function MixerWagon:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_mixerWagon

    if spec.fillUnitIndex = = fillUnitIndex then
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
        if fillLevel = = 0 then
            for _, entry in pairs(spec.mixerWagonFillTypes) do
                entry.fillLevel = 0
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
function MixerWagon:onLoad(savegame)

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonBaleTrigger#index" , "vehicle.mixerWagon.baleTrigger#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagon.baleTrigger#index" , "vehicle.mixerWagon.baleTrigger#node" ) --FS19 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonPickupStartSound" , "vehicle.turnOnVehicle.sounds.start" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonPickupStopSound" , "vehicle.turnOnVehicle.sounds.stop" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonPickupSound" , "vehicle.turnOnVehicle.sounds.work" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonRotatingParts.mixerWagonRotatingPart#type" , "vehicle.mixerWagon.mixAnimationNodes.animationNode" , "mixerWagonMix" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonRotatingParts.mixerWagonRotatingPart#type" , "vehicle.mixerWagon.pickupAnimationNodes.animationNode" , "mixerWagonPickup" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagonRotatingParts.mixerWagonScroller" , "vehicle.mixerWagon.pickupAnimationNodes.pickupAnimationNode" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mixerWagon.baleTrigger#node" , "vehicle.mixerWagon.baleTriggers.baleTrigger#node" ) --FS19 to FS22

    local spec = self.spec_mixerWagon

    if self.isClient then
        spec.mixAnimationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.mixerWagon.mixAnimationNodes" , self.components, self , self.i3dMappings)
        spec.pickupAnimationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.mixerWagon.pickupAnimationNodes" , self.components, self , self.i3dMappings)

        spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.mixerWagon.fillEffect" , self.components, self , self.i3dMappings)
        spec.fillEffectsFillType = FillType.UNKNOWN
        spec.fillEffectsState = false
    end

    if self.isServer then
        spec.baleTriggers = { }
        self.xmlFile:iterate( "vehicle.mixerWagon.baleTriggers.baleTrigger" , function (_, key)
            local baleTrigger = { }
            baleTrigger.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            if baleTrigger.node ~ = nil then
                addTrigger(baleTrigger.node, "mixerWagonBaleTriggerCallback" , self )

                baleTrigger.pickupSpeed = self.xmlFile:getValue(key .. "#pickupSpeed" , 500 ) / 1000
                baleTrigger.needsSetIsTurnedOn = self.xmlFile:getValue(key .. "#needsSetIsTurnedOn" , false )
                baleTrigger.useEffect = self.xmlFile:getValue(key .. "#useEffect" , false )
                baleTrigger.balesInTrigger = { }
                table.insert(spec.baleTriggers, baleTrigger)
            end
        end )
    end

    spec.activeTimerMax = self.xmlFile:getValue( "vehicle.mixerWagon#mixingTime" , 5 )
    spec.activeTimer = 0

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.mixerWagon#fillUnitIndex" , 1 )

    spec.mixerWagonFillTypes = { }
    spec.fillTypeToMixerWagonFillType = { }

    local recipeFillTypeName = self.xmlFile:getValue( "vehicle.mixerWagon#recipe" )
    if recipeFillTypeName ~ = nil then
        local recipeFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(recipeFillTypeName)
        if recipeFillTypeIndex = = nil then
            Logging.xmlError( self.xmlFile, "MixerWagon recipe '%s' not defined!" , recipeFillTypeName)
        end

        local recipe = g_currentMission.animalFoodSystem:getRecipeByFillTypeIndex(recipeFillTypeIndex)
        if recipe = = nil then
            Logging.xmlWarning( self.xmlFile, "MixerWagon recipe '%s' not defined!" , recipeFillTypeName)
        end

        if recipe ~ = nil then
            for _, ingredient in ipairs(recipe.ingredients) do
                local entry = { }
                entry.fillLevel = 0
                entry.fillTypes = { }
                entry.name = ingredient.name
                entry.minPercentage = ingredient.minPercentage
                entry.maxPercentage = ingredient.maxPercentage
                entry.ratio = ingredient.ratio

                for _, fillTypeIndex in ipairs(ingredient.fillTypes) do
                    entry.fillTypes[fillTypeIndex] = true
                    spec.fillTypeToMixerWagonFillType[fillTypeIndex] = entry
                end

                table.insert(spec.mixerWagonFillTypes, entry)
            end
        end
    end

    -- saving and sync of fill level will be handled by the mixer wagon
    -- in case we don't have a recipe defined the fill unit will take care of it
    if #spec.mixerWagonFillTypes > 0 then
        local fillUnit = self:getFillUnitByIndex(spec.fillUnitIndex)
        if fillUnit ~ = nil then
            fillUnit.needsSaving = false
            fillUnit.synchronizeFillLevel = false
        end
    end

    spec.dirtyFlag = self:getNextDirtyFlag()
    spec.effectDirtyFlag = self:getNextDirtyFlag()

    spec.hudExtension = MixerWagonHUDExtension.new( self )
end

```

### onMixerWagonBaleDeleted

**Description**

**Definition**

> onMixerWagonBaleDeleted()

**Arguments**

| any | bale |
|-----|------|

**Code**

```lua
function MixerWagon:onMixerWagonBaleDeleted(bale)
    local spec = self.spec_mixerWagon
    for i = 1 , #spec.baleTriggers do
        local baleTrigger = spec.baleTriggers[i]
        baleTrigger.balesInTrigger[bale] = nil
    end
end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function MixerWagon:onPostLoad(savegame)
    if savegame ~ = nil then
        local spec = self.spec_mixerWagon
        for i, entry in ipairs(spec.mixerWagonFillTypes) do
            local fillTypeKey = savegame.key .. string.format( ".mixerWagon.fillType(%d)#fillLevel" , i - 1 )
            local fillLevel = savegame.xmlFile:getValue(fillTypeKey, 0 )

            if fillLevel > 0 then
                self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, fillLevel, next(entry.fillTypes), ToolType.UNDEFINED, nil )
            end
        end
    end

    if self.spec_hudInfoTrigger = = nil or self.spec_hudInfoTrigger.triggerNode = = nil then
        Logging.xmlDevWarning( self.xmlFile, "Missing hudInfoTrigger for mixer wagon.Required for external mixer wagon hud visibility!" )
        end
    end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function MixerWagon:onReadStream(streamId, connection)
    local spec = self.spec_mixerWagon
    for _, entry in ipairs(spec.mixerWagonFillTypes) do
        local fillLevel = streamReadFloat32(streamId)
        if fillLevel > 0 then
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, fillLevel, next(entry.fillTypes), ToolType.UNDEFINED, nil )
        end
    end

    spec.fillEffectsFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
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
function MixerWagon:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_mixerWagon
        if streamReadBool(streamId) then
            for _, entry in ipairs(spec.mixerWagonFillTypes) do
                local fillLevel = streamReadFloat32(streamId)
                local delta = fillLevel - entry.fillLevel
                if delta ~ = 0 then
                    self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, delta, next(entry.fillTypes), ToolType.UNDEFINED, nil )
                end
            end
        end

        if streamReadBool(streamId) then
            spec.fillEffectsFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        end
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function MixerWagon:onTurnedOff()
    if self.isClient then
        local spec = self.spec_mixerWagon
        g_animationManager:stopAnimations(spec.pickupAnimationNodes)
    end
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function MixerWagon:onTurnedOn()
    if self.isClient then
        local spec = self.spec_mixerWagon
        g_animationManager:startAnimations(spec.pickupAnimationNodes)
    end
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function MixerWagon:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_mixerWagon

    local tipState = self:getTipState()
    local isTurnedOn = self:getIsTurnedOn()
    local isDischarging = tipState = = Trailer.TIPSTATE_OPENING or tipState = = Trailer.TIPSTATE_OPEN

    if self:getIsPowered() and(spec.activeTimer > 0 or isTurnedOn or isDischarging) then
        spec.activeTimer = spec.activeTimer - dt
        g_animationManager:startAnimations(spec.mixAnimationNodes)
    else
            g_animationManager:stopAnimations(spec.mixAnimationNodes)
        end

        if self.isServer then
            local fillEffectsFillType = FillType.UNKNOWN
            if self:getFillUnitFreeCapacity(spec.fillUnitIndex) > 0 then
                for i = 1 , #spec.baleTriggers do
                    local baleTrigger = spec.baleTriggers[i]
                    if not baleTrigger.needsSetIsTurnedOn or self:getIsTurnedOn() then
                        for bale, _ in pairs(baleTrigger.balesInTrigger) do
                            local baleFillLevel = bale:getFillLevel()
                            local deltaFillLevel = math.min(baleTrigger.pickupSpeed * dt, baleFillLevel)
                            local fillType = bale:getFillType()

                            deltaFillLevel = self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, deltaFillLevel, fillType, ToolType.BALE, nil )

                            baleFillLevel = baleFillLevel - deltaFillLevel
                            bale:setFillLevel(baleFillLevel)
                            if baleFillLevel < 0.01 then
                                bale:delete()
                                baleTrigger.balesInTrigger[bale] = nil
                            end

                            if baleTrigger.useEffect then
                                fillEffectsFillType = fillType
                            end
                        end
                    end
                end
            end

            if fillEffectsFillType = = FillType.UNKNOWN then
                if self.getIsShovelEffectState ~ = nil then
                    local state, fillType = self:getIsShovelEffectState()
                    if state then
                        fillEffectsFillType = fillType
                    end
                end
            end

            if spec.fillEffectsFillType ~ = fillEffectsFillType then
                spec.fillEffectsFillType = fillEffectsFillType
                self:raiseDirtyFlags(spec.effectDirtyFlag)
            end
        end

        if self.isClient then
            local state = spec.fillEffectsFillType ~ = FillType.UNKNOWN
            if state ~ = spec.fillEffectsState then
                if state then
                    g_effectManager:setEffectTypeInfo(spec.fillEffects, spec.fillEffectsFillType)
                    g_effectManager:startEffects(spec.fillEffects)
                else
                        g_effectManager:stopEffects(spec.fillEffects)
                    end

                    spec.fillEffectsState = state
                end
            end
        end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function MixerWagon:onWriteStream(streamId, connection)
    local spec = self.spec_mixerWagon
    for _, entry in ipairs(spec.mixerWagonFillTypes) do
        streamWriteFloat32(streamId, entry.fillLevel)
    end

    streamWriteUIntN(streamId, spec.fillEffectsFillType, FillTypeManager.SEND_NUM_BITS)
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
function MixerWagon:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_mixerWagon
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            for _, entry in ipairs(spec.mixerWagonFillTypes) do
                streamWriteFloat32(streamId, entry.fillLevel)
            end
        end

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, spec.fillEffectsFillType, FillTypeManager.SEND_NUM_BITS)
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
function MixerWagon.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Trailer , specializations) and SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
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
function MixerWagon.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , MixerWagon )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , MixerWagon )
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
function MixerWagon.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "mixerWagonBaleTriggerCallback" , MixerWagon.mixerWagonBaleTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onMixerWagonBaleDeleted" , MixerWagon.onMixerWagonBaleDeleted)
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
function MixerWagon.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addFillUnitFillLevel" , MixerWagon.addFillUnitFillLevel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitAllowsFillType" , MixerWagon.getFillUnitAllowsFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDischargeFillType" , MixerWagon.getDischargeFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsBaleAutoLoadable" , MixerWagon.getIsBaleAutoLoadable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , MixerWagon.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , MixerWagon.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPowerTakeOffActive" , MixerWagon.getIsPowerTakeOffActive)
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
function MixerWagon:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_mixerWagon

    for i, fillType in ipairs(spec.mixerWagonFillTypes) do
        local fillTypeKey = string.format( "%s.fillType(%d)" , key, i - 1 )
        xmlFile:setValue(fillTypeKey .. "#fillLevel" , fillType.fillLevel)
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
function MixerWagon:updateDebugValues(values)
    local spec = self.spec_mixerWagon

    table.insert(values, { name = "Forage isOK" , value = tostring( self:getFillUnitFillType(spec.fillUnitIndex) = = FillType.FORAGE) } )

    for _, mixerWagonFillType in ipairs(spec.mixerWagonFillTypes) do
        local fillTypes = ""
        for fillTypeIndex, _ in pairs(mixerWagonFillType.fillTypes) do
            fillTypes = fillTypes .. " " .. tostring(g_fillTypeManager:getFillTypeNameByIndex(fillTypeIndex))
        end
        table.insert(values, { name = fillTypes, value = mixerWagonFillType.fillLevel } )
    end
end

```