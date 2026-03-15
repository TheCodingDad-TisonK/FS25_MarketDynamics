## ConveyorBelt

**Description**

> Class for conveyor belts to control unloading start time and unloading effects

**Functions**

- [getConveyorBeltFillLevel](#getconveyorbeltfilllevel)
- [getConveyorBeltTargetObject](#getconveyorbelttargetobject)
- [getDischargeNodeEmptyFactor](#getdischargenodeemptyfactor)
- [getFillUnitAllowsFillType](#getfillunitallowsfilltype)
- [getFillUnitFreeCapacity](#getfillunitfreecapacity)
- [getHasConveyorBeltLoop](#gethasconveyorbeltloop)
- [getIsEnterable](#getisenterable)
- [getLoadTriggerMaxFillSpeed](#getloadtriggermaxfillspeed)
- [handleDischarge](#handledischarge)
- [handleDischargeOnEmpty](#handledischargeonempty)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onMovingToolChanged](#onmovingtoolchanged)
- [onPostLoad](#onpostload)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdateTick](#onupdatetick)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateDebugValues](#updatedebugvalues)

### getConveyorBeltFillLevel

**Description**

**Definition**

> getConveyorBeltFillLevel()

**Code**

```lua
function ConveyorBelt:getConveyorBeltFillLevel()
    local spec = self.spec_conveyorBelt
    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
    if self.getCurrentDischargeNode ~ = nil then
        local currentDischargeNode = self:getCurrentDischargeNode()
        local object = currentDischargeNode.dischargeHitObject
        if object ~ = nil and object.getConveyorBeltFillLevel ~ = nil then
            fillLevel = fillLevel + object:getConveyorBeltFillLevel()
        end
    end

    return fillLevel
end

```

### getConveyorBeltTargetObject

**Description**

**Definition**

> getConveyorBeltTargetObject()

**Code**

```lua
function ConveyorBelt:getConveyorBeltTargetObject()
    if self.getCurrentDischargeNode ~ = nil then
        local currentDischargeNode = self:getCurrentDischargeNode()
        local object, targetFillUnitIndex = currentDischargeNode.dischargeHitObject, currentDischargeNode.dischargeHitObjectUnitIndex
        if object ~ = nil then
            if object.getConveyorBeltTargetObject ~ = nil then
                return object:getConveyorBeltTargetObject()
            else
                    return object, targetFillUnitIndex
                end
            end
        end

        return nil
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
function ConveyorBelt:getDischargeNodeEmptyFactor(superFunc, dischargeNode)
    local spec = self.spec_conveyorBelt
    local parentFactor = superFunc( self , dischargeNode)

    if spec.dischargeNodeIndex = = dischargeNode.index then
        if spec.morphEndPos = = 1 then
            return spec.emptyFactor
        else
                return 0
            end
        end

        return parentFactor
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
| any | fillType      |

**Code**

```lua
function ConveyorBelt:getFillUnitAllowsFillType(superFunc, fillUnitIndex, fillType)
    if not superFunc( self , fillUnitIndex, fillType) then
        return false
    end

    if not ConveyorBelt.getHasConveyorBeltLoop( self , self , fillUnitIndex) then
        if self.getCurrentDischargeNode ~ = nil then
            local currentDischargeNode = self:getCurrentDischargeNode()
            if currentDischargeNode.fillUnitIndex = = fillUnitIndex then
                local object, targetFillUnitIndex = currentDischargeNode.dischargeHitObject, currentDischargeNode.dischargeHitObjectUnitIndex
                if object ~ = nil and object.getFillUnitAllowsFillType ~ = nil and targetFillUnitIndex ~ = nil then
                    if currentDischargeNode.fillTypeConverter ~ = nil then
                        local conversion = currentDischargeNode.fillTypeConverter[fillType]
                        if conversion ~ = nil then
                            if object:getFillUnitAllowsFillType(targetFillUnitIndex, conversion.targetFillTypeIndex) then
                                return true
                            end
                        end
                    end

                    return object:getFillUnitAllowsFillType(targetFillUnitIndex, fillType)
                end
            end
        end
    end

    return true
end

```

### getFillUnitFreeCapacity

**Description**

**Definition**

> getFillUnitFreeCapacity()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | fillTypeIndex |
| any | farmId        |

**Code**

```lua
function ConveyorBelt:getFillUnitFreeCapacity(superFunc, fillUnitIndex, fillTypeIndex, farmId)
    local freeCapacity = superFunc( self , fillUnitIndex, fillTypeIndex, farmId)

    if not ConveyorBelt.getHasConveyorBeltLoop( self , self , fillUnitIndex) then
        if self.getCurrentDischargeNode ~ = nil then
            local currentDischargeNode = self:getCurrentDischargeNode()
            if currentDischargeNode.fillUnitIndex = = fillUnitIndex then
                local object, targetFillUnitIndex = currentDischargeNode.dischargeHitObject, currentDischargeNode.dischargeHitObjectUnitIndex
                if object ~ = nil and object.getFillUnitFreeCapacity ~ = nil and targetFillUnitIndex ~ = nil then
                    return freeCapacity + object:getFillUnitFreeCapacity(targetFillUnitIndex, fillTypeIndex, farmId)
                end
            end
        end
    end

    return freeCapacity
end

```

### getHasConveyorBeltLoop

**Description**

**Definition**

> getHasConveyorBeltLoop()

**Arguments**

| any | rootVehicle   |
|-----|---------------|
| any | vehicle       |
| any | fillUnitIndex |

**Code**

```lua
function ConveyorBelt.getHasConveyorBeltLoop(rootVehicle, vehicle, fillUnitIndex)
    if vehicle.getCurrentDischargeNode ~ = nil then
        local currentDischargeNode = vehicle:getCurrentDischargeNode()
        if currentDischargeNode.fillUnitIndex = = fillUnitIndex then
            local object, targetFillUnitIndex = currentDischargeNode.dischargeHitObject, currentDischargeNode.dischargeHitObjectUnitIndex
            if object ~ = nil and object.spec_conveyorBelt ~ = nil and targetFillUnitIndex ~ = nil then
                if object = = rootVehicle then
                    return true
                end

                return ConveyorBelt.getHasConveyorBeltLoop(rootVehicle, object, targetFillUnitIndex)
            end
        end
    end

    return false
end

```

### getIsEnterable

**Description**

**Definition**

> getIsEnterable()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ConveyorBelt:getIsEnterable(superFunc)
    return( self.getAttacherVehicle = = nil or self:getAttacherVehicle() = = nil ) and superFunc( self )
end

```

### getLoadTriggerMaxFillSpeed

**Description**

**Definition**

> getLoadTriggerMaxFillSpeed()

**Code**

```lua
function ConveyorBelt:getLoadTriggerMaxFillSpeed()
    local maxSpeed = math.huge
    if self.getCurrentDischargeNode ~ = nil then
        local currentDischargeNode = self:getCurrentDischargeNode()
        maxSpeed = currentDischargeNode.emptySpeed
        local object = currentDischargeNode.dischargeHitObject
        if object ~ = nil then
            if object.getLoadTriggerMaxFillSpeed ~ = nil then
                maxSpeed = math.min(object:getLoadTriggerMaxFillSpeed(), maxSpeed)
            end
        end
    end

    return maxSpeed
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
function ConveyorBelt:handleDischarge(superFunc, dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
    local spec = self.spec_conveyorBelt
    -- do nothing if it is conveyor dischargenode
        if dischargeNode.index ~ = spec.dischargeNodeIndex then
            superFunc( self , dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
        end
    end

```

### handleDischargeOnEmpty

**Description**

**Definition**

> handleDischargeOnEmpty()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function ConveyorBelt:handleDischargeOnEmpty(superFunc, dischargeNode)
    local spec = self.spec_conveyorBelt
    -- do nothing if conveyorBelt dischargenode is empty
        if dischargeNode.index ~ = spec.dischargeNodeIndex then
            superFunc( self , dischargeNode)
        end
    end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ConveyorBelt.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ConveyorBelt" )

    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.conveyorBelt.animationNodes" )
    EffectManager.registerEffectXMLPaths(schema, "vehicle.conveyorBelt.effects" )

    schema:register(XMLValueType.INT, "vehicle.conveyorBelt#dischargeNodeIndex" , "Discharge node index" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.conveyorBelt#startPercentage" , "Start unloading percentage" , 0.9 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.conveyorBelt.offset(?)#movingToolNode" , "Moving tool node" )
    schema:register(XMLValueType.INT, "vehicle.conveyorBelt.offset(?).effect(?)#index" , "Index of effect" , 0 )
    schema:register(XMLValueType.FLOAT, "vehicle.conveyorBelt.offset(?).effect(?)#minOffset" , "Min.offset" , 0 )
    schema:register(XMLValueType.FLOAT, "vehicle.conveyorBelt.offset(?).effect(?)#maxOffset" , "Max.offset" , 1 )
    schema:register(XMLValueType.BOOL, "vehicle.conveyorBelt.offset(?).effect(?)#inverted" , "Is inverted" , false )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.conveyorBelt.sounds" , "belt" )

    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function ConveyorBelt:onDelete()
    local spec = self.spec_conveyorBelt
    g_effectManager:deleteEffects(spec.effects)
    g_animationManager:deleteAnimations(spec.animationNodes)
    g_soundManager:deleteSamples(spec.samples)
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
| any | fillType         |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function ConveyorBelt:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_conveyorBelt
    if spec.fillUnitIndex = = fillUnitIndex then
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)

        if self.isServer then
            local isFilling, isScrolling = false , false
            if fillLevelDelta > 0 then
                spec.morphStartPos = 0
                spec.morphEndPos = math.max(spec.morphEndPos, fillLevel / self:getFillUnitCapacity(fillUnitIndex))
                spec.isEffectDirty = true
                isFilling = true
            end

            if fillLevelDelta ~ = 0 then
                spec.scrollUpdateTime = 100
                isScrolling = true
            end

            if isFilling ~ = spec.isFilling or isScrolling ~ = spec.isScrolling then
                spec.isFilling = isFilling
                spec.isScrolling = isScrolling
                self:raiseDirtyFlags(spec.dirtyFlag)
            end
        end

        if fillLevel = = 0 then
            g_effectManager:stopEffects(spec.effects)
            spec.morphStartPos = 0
            spec.morphEndPos = 0
            spec.isEffectDirty = true
        else
                g_effectManager:setEffectTypeInfo(spec.effects, fillType)
                for _, effect in pairs(spec.effects) do
                    g_effectManager:startEffect(effect, true )
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
function ConveyorBelt:onLoad(savegame)
    local spec = self.spec_conveyorBelt

    if self.isClient then
        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.conveyorBelt.animationNodes" , self.components, self , self.i3dMappings)

        spec.samples = { }
        spec.samples.belt = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.conveyorBelt.sounds" , "belt" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.conveyorBelt.effects" , self.components, self , self.i3dMappings)
    spec.currentDelay = 0.0001
    table.sort(spec.effects, function (effect1, effect2) return effect1.startDelay < effect2.startDelay end )

    for _, effect in pairs(spec.effects) do
        if effect.planeFadeTime ~ = nil then
            spec.currentDelay = spec.currentDelay + effect.planeFadeTime
        end
        if effect.setScrollUpdate ~ = nil then
            effect:setScrollUpdate( false )
        end
    end
    spec.maxDelay = spec.currentDelay

    spec.morphStartPos = 0
    spec.morphEndPos = 0
    spec.isEffectDirty = true
    spec.emptyFactor = 1
    spec.scrollUpdateTime = 0
    spec.lastScrollUpdate = false

    spec.fillUnitIndex = 1
    spec.startFillLevel = 0

    spec.dischargeNodeIndex = self.xmlFile:getValue( "vehicle.conveyorBelt#dischargeNodeIndex" , 1 )
    self:setCurrentDischargeNodeIndex(spec.dischargeNodeIndex)
    local dischargeNode = self:getDischargeNodeByIndex(spec.dischargeNodeIndex)
    if dischargeNode ~ = nil then
        local capacity = self:getFillUnitCapacity(dischargeNode.fillUnitIndex)
        spec.fillUnitIndex = dischargeNode.fillUnitIndex
        spec.startFillLevel = capacity * self.xmlFile:getValue( "vehicle.conveyorBelt#startPercentage" , 0.9 )
    end

    local i = 0
    while true do
        local key = string.format( "vehicle.conveyorBelt.offset(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local movingToolNode = self.xmlFile:getValue(key .. "#movingToolNode" , nil , self.components, self.i3dMappings)
        if movingToolNode ~ = nil then
            if spec.offsets = = nil then
                spec.offsets = { }
            end

            local offset = { }
            offset.lastState = nil
            offset.movingToolNode = movingToolNode
            offset.effects = { }
            local j = 0
            while true do
                local effectKey = string.format(key .. ".effect(%d)" , j)
                if not self.xmlFile:hasProperty(effectKey) then
                    break
                end

                local effectIndex = self.xmlFile:getValue(effectKey .. "#index" , 0 )
                local effect = spec.effects[effectIndex]
                if effect ~ = nil and effect.setOffset ~ = nil then
                    local entry = { }
                    entry.effect = effect
                    entry.minValue = self.xmlFile:getValue(effectKey .. "#minOffset" , 0 ) * 1000
                    entry.maxValue = self.xmlFile:getValue(effectKey .. "#maxOffset" , 1 ) * 1000
                    entry.inverted = self.xmlFile:getValue(effectKey .. "#inverted" , false )
                    table.insert(offset.effects, entry)
                else
                        Logging.xmlWarning( self.xmlFile, "Effect index '%d' not found at '%s'!" , effectIndex, effectKey)
                    end
                    j = j + 1
                end

                table.insert(spec.offsets, offset)
            else
                    Logging.xmlWarning( self.xmlFile, "Missing movingToolNode for conveyor offset '%s'!" , key)
                    end
                    i = i + 1
                end

                spec.isFilling = false
                spec.isScrolling = false

                spec.dirtyFlag = self:getNextDirtyFlag()
            end

```

### onMovingToolChanged

**Description**

**Definition**

> onMovingToolChanged()

**Arguments**

| any | movingTool |
|-----|------------|
| any | speed      |
| any | dt         |

**Code**

```lua
function ConveyorBelt:onMovingToolChanged(movingTool, speed, dt)
    local spec = self.spec_conveyorBelt
    if spec.offsets ~ = nil and spec.movingToolToOffset ~ = nil then
        local offset = spec.movingToolToOffset[movingTool]

        if offset ~ = nil then
            local state = Cylindered.getMovingToolState( self , movingTool)
            if state ~ = offset.lastState then
                local updateDelay = false

                for _, entry in pairs(offset.effects) do
                    local effectState = state
                    if entry.inverted then
                        effectState = 1 - effectState
                    end

                    entry.effect:setOffset( MathUtil.lerp(entry.minValue, entry.maxValue, effectState))
                    updateDelay = true
                    spec.isEffectDirty = true
                end

                if updateDelay then
                    spec.currentDelay = 0
                    for _, effect in pairs(spec.effects) do
                        if effect.planeFadeTime ~ = nil then
                            spec.currentDelay = spec.currentDelay + effect.planeFadeTime - effect.offset
                        end
                    end
                end

                offset.lastState = state
            end
        end
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
function ConveyorBelt:onPostLoad(savegame)
    local spec = self.spec_conveyorBelt

    -- we need to check movingTool in post load to avoid order dependencies
    if spec.offsets ~ = nil then
        if self.getMovingToolByNode ~ = nil then
            spec.movingToolToOffset = { }
            for i = #spec.offsets, 1 , - 1 do
                local offset = spec.offsets[i]
                local movingTool = self:getMovingToolByNode(offset.movingToolNode)
                if movingTool ~ = nil then
                    offset.movingTool = movingTool
                    spec.movingToolToOffset[movingTool] = offset
                    ConveyorBelt.onMovingToolChanged( self , movingTool, 0 , 0 )
                else
                        Logging.xmlWarning( self.xmlFile, "No movingTool node '%s' defined for conveyor offset '%d'!" , getName(offset.movingToolNode), i)
                            table.remove(spec.offsets, i)
                        end
                    end

                    if #spec.offsets = = 0 then
                        spec.offsets = nil
                        spec.movingToolToOffset = nil
                    end
                else
                        Logging.xmlError( self.xmlFile, "'Cylindered' specialization is required to use conveyorBelt offsets!" )
                        spec.offsets = nil
                    end
                end
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
function ConveyorBelt:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spec = self.spec_conveyorBelt
            spec.isFilling = streamReadBool(streamId)
            spec.isScrolling = streamReadBool(streamId)
        end
    end
end

```

### onUpdateTick

**Description**

> Called on update tick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function ConveyorBelt:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_conveyorBelt

    if not self.isServer then
        if spec.isFilling then
            spec.morphStartPos = 0
            spec.morphEndPos = math.max(spec.morphEndPos, self:getFillUnitFillLevelPercentage(spec.fillUnitIndex))
            spec.isEffectDirty = true
        end

        if spec.isScrolling then
            spec.scrollUpdateTime = 100
        end
    end

    local doScrollUpdate = spec.scrollUpdateTime > 0
    if doScrollUpdate ~ = spec.lastScrollUpdate then
        if self.isClient then
            if doScrollUpdate then
                g_animationManager:startAnimations(spec.animationNodes)
                g_soundManager:playSample(spec.samples.belt)
            else
                    g_animationManager:stopAnimations(spec.animationNodes)
                    g_soundManager:stopSample(spec.samples.belt)
                end

                for _, effect in pairs(spec.effects) do
                    if effect.setScrollUpdate ~ = nil then
                        effect:setScrollUpdate(doScrollUpdate)
                    end
                end
            end

            spec.lastScrollUpdate = doScrollUpdate
        end
        spec.scrollUpdateTime = math.max(spec.scrollUpdateTime - dt, 0 )

        local isBeltActive = self:getDischargeState() ~ = Dischargeable.DISCHARGE_STATE_OFF
        if isBeltActive then
            local fillFactor = self:getFillUnitFillLevelPercentage(spec.fillUnitIndex)
            if fillFactor > 0.0001 then
                local movedFactor = dt / spec.currentDelay
                spec.morphStartPos = math.clamp(spec.morphStartPos + movedFactor, 0 , 1 )
                spec.morphEndPos = math.clamp(spec.morphEndPos + movedFactor, 0 , 1 )

                -- we calculate the empty factor based on visual effect mesh and filllevel to get a smooth transition
                local visualFactor = spec.morphEndPos - spec.morphStartPos

                spec.emptyFactor = 1
                if visualFactor > fillFactor then
                    spec.emptyFactor = math.clamp(fillFactor / math.max(visualFactor, 0.001 ), 0 , 1 )
                else
                        local offset = fillFactor - visualFactor
                        spec.offset = offset
                        spec.morphStartPos = math.clamp(spec.morphStartPos - (offset / math.max(( 1 - spec.morphStartPos) * spec.currentDelay, 0.001 )) * dt, 0 , 1 )
                    end

                    spec.isEffectDirty = true
                    spec.scrollUpdateTime = dt * 3
                end
            end

            if doScrollUpdate then
                self:raiseActive()
            end

            if self.isClient then
                if spec.isEffectDirty then
                    for _, effect in pairs(spec.effects) do
                        if effect.setMorphPosition ~ = nil then
                            local effectStart = effect.startDelay / spec.currentDelay
                            local effectEnd = (effect.startDelay + effect.planeFadeTime - effect.offset) / spec.currentDelay
                            local offsetFactor = effect.offset / effect.planeFadeTime

                            local startMorphFactor = (spec.morphStartPos - effectStart) / (effectEnd - effectStart)
                            local startMorph = math.clamp(offsetFactor + startMorphFactor * ( 1 - offsetFactor), offsetFactor, 1 )

                            local endMorphFactor = (spec.morphEndPos - effectStart) / (effectEnd - effectStart)
                            local endMorph = math.clamp(offsetFactor + endMorphFactor * ( 1 - offsetFactor), offsetFactor, 1 )

                            --renderText(0.6, 0.8-i*0.015, 0.012, string.format("%d:effectStart %.4f effectEnd %.4f -> startMorph %.4f endMorph %.4f | offset %.4f | %.4f %.4f", i, effectStart, effectEnd, startMorph, endMorph, effect.offset/effect.planeFadeTime, (spec.morphStartPos-effectStart)/(effectEnd-effectStart), (spec.morphEndPos-effectStart)/(effectEnd-effectStart)))
                            effect:setMorphPosition(startMorph, endMorph)
                        end
                    end
                    spec.isEffectDirty = false
                end
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
function ConveyorBelt:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_conveyorBelt
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteBool(streamId, spec.isFilling)
            streamWriteBool(streamId, spec.isScrolling)
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
function ConveyorBelt.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Dischargeable , specializations)
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
function ConveyorBelt.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , ConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onMovingToolChanged" , ConveyorBelt )
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
function ConveyorBelt.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getConveyorBeltFillLevel" , ConveyorBelt.getConveyorBeltFillLevel)
    SpecializationUtil.registerFunction(vehicleType, "getConveyorBeltTargetObject" , ConveyorBelt.getConveyorBeltTargetObject)
    SpecializationUtil.registerFunction(vehicleType, "getLoadTriggerMaxFillSpeed" , ConveyorBelt.getLoadTriggerMaxFillSpeed)
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
function ConveyorBelt.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDischargeNodeEmptyFactor" , ConveyorBelt.getDischargeNodeEmptyFactor)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleDischargeOnEmpty" , ConveyorBelt.handleDischargeOnEmpty)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleDischarge" , ConveyorBelt.handleDischarge)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsEnterable" , ConveyorBelt.getIsEnterable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitAllowsFillType" , ConveyorBelt.getFillUnitAllowsFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitFreeCapacity" , ConveyorBelt.getFillUnitFreeCapacity)
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
function ConveyorBelt:updateDebugValues(values)
    local spec = self.spec_conveyorBelt

    table.insert(values, { name = "fillFactor" , value = self:getFillUnitFillLevelPercentage(spec.fillUnitIndex) } )
    table.insert(values, { name = "visualFactor" , value = spec.morphEndPos - spec.morphStartPos } )
    table.insert(values, { name = "currentDelay" , value = spec.currentDelay } )
    table.insert(values, { name = "offset" , value = spec.offset } )
    table.insert(values, { name = "morphStartPos" , value = spec.morphStartPos } )
    table.insert(values, { name = "morphEndPos" , value = spec.morphEndPos } )
end

```