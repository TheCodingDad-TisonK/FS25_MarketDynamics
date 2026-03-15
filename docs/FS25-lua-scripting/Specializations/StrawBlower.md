## StrawBlower

**Description**

> Specialization for straw blowers providing functionality to dissipate a bale to lose straw

**Functions**

- [addFillUnitFillLevel](#addfillunitfilllevel)
- [getAllowDynamicMountFillLevelInfo](#getallowdynamicmountfilllevelinfo)
- [getDrawFirstFillText](#getdrawfirstfilltext)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onDeleteStrawBlowerObject](#ondeletestrawblowerobject)
- [onDischargeStateChanged](#ondischargestatechanged)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [strawBlowerBaleTriggerCallback](#strawblowerbaletriggercallback)

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
function StrawBlower:addFillUnitFillLevel(superFunc, farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    local spec = self.spec_strawBlower
    if fillUnitIndex = = spec.fillUnitIndex then
        self:setFillUnitCapacity(fillUnitIndex, math.max( self:getFillUnitCapacity(fillUnitIndex), self:getFillUnitFillLevel(fillUnitIndex) + fillLevelDelta))
    end

    return superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
end

```

### getAllowDynamicMountFillLevelInfo

**Description**

**Definition**

> getAllowDynamicMountFillLevelInfo()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function StrawBlower:getAllowDynamicMountFillLevelInfo(superFunc)
    return false
end

```

### getDrawFirstFillText

**Description**

**Definition**

> getDrawFirstFillText()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function StrawBlower:getDrawFirstFillText(superFunc)
    local spec = self.spec_strawBlower
    return superFunc( self ) or self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function StrawBlower.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "StrawBlower" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.strawBlower.baleTrigger#node" , "Bale trigger node" )

    schema:register(XMLValueType.INT, "vehicle.strawBlower#fillUnitIndex" , "Fill unit index" , 1 )

    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.strawBlower.animationNodes" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.strawBlower.sounds" , "start" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.strawBlower.sounds" , "stop" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.strawBlower.sounds" , "work" )

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
function StrawBlower:onDelete()
    local spec = self.spec_strawBlower

    if spec.triggerId ~ = nil then
        removeTrigger(spec.triggerId)
    end

    if spec.triggeredBales ~ = nil then
        for bale, _ in pairs(spec.triggeredBales) do
            if entityExists(bale.nodeId) then
                I3DUtil.wakeUpObject(bale.nodeId)
                bale.allowPickup = true
            end
            if bale.removeDeleteListener ~ = nil then
                bale:removeDeleteListener( self , "onDeleteStrawBlowerObject" )
            end
        end
        table.clear(spec.triggeredBales)
    end

    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)
end

```

### onDeleteStrawBlowerObject

**Description**

**Definition**

> onDeleteStrawBlowerObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function StrawBlower:onDeleteStrawBlowerObject(object)
    local spec = self.spec_strawBlower

    if spec.triggeredBales[object] ~ = nil then
        spec.triggeredBales[object] = nil

        if object = = spec.currentBale then
            spec.currentBale = nil
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, self:getFillUnitFillType(spec.fillUnitIndex), ToolType.UNDEFINED)
        end
    end
end

```

### onDischargeStateChanged

**Description**

> Called on discharge state change

**Definition**

> onDischargeStateChanged()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function StrawBlower:onDischargeStateChanged(state)
    local spec = self.spec_strawBlower
    local samples = spec.samples
    if self.isClient then
        if state ~ = Dischargeable.DISCHARGE_STATE_OFF then
            g_soundManager:stopSample(samples.work)
            g_soundManager:stopSample(samples.stop)
            g_soundManager:playSample(samples.start)
            g_soundManager:playSample(samples.work, 0 , samples.start)
            g_animationManager:startAnimations(spec.animationNodes)
        else
                g_soundManager:stopSample(samples.start)
                g_soundManager:stopSample(samples.work)
                g_soundManager:playSample(samples.stop)
                g_animationManager:stopAnimations(spec.animationNodes)
            end
        end
    end

```

### onFillUnitFillLevelChanged

**Description**

> Set unit fill level

**Definition**

> onFillUnitFillLevelChanged(integer fillUnitIndex, float fillLevel, integer fillType, boolean force, table fillInfo, )

**Arguments**

| integer | fillUnitIndex | index of fill unit        |
|---------|---------------|---------------------------|
| float   | fillLevel     | new fill level            |
| integer | fillType      | fill type                 |
| boolean | force         | force action              |
| table   | fillInfo      | fill info for fill volume |
| any     | appliedDelta  |                           |

**Code**

```lua
function StrawBlower:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_strawBlower
    if fillUnitIndex = = spec.fillUnitIndex then
        local newFillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)

        if self.isServer then
            local bale = spec.currentBale
            if bale ~ = nil then
                if newFillLevel < = 0.01 then
                    if self.removeDynamicMountedObject ~ = nil then
                        self:removeDynamicMountedObject(bale)
                    end

                    local baleOwner = bale:getOwnerFarmId()

                    bale:delete()
                    spec.currentBale = nil
                    spec.triggeredBales[bale] = nil

                    self:setFillUnitCapacity(spec.fillUnitIndex, 1 )
                    self:addFillUnitFillLevel(baleOwner, spec.fillUnitIndex, - math.huge, FillType.UNKNOWN, ToolType.UNDEFINED)
                elseif newFillLevel < bale:getFillLevel() and fillTypeIndex = = bale:getFillType() then
                        bale:setFillLevel(newFillLevel)
                    end
                end
            else
                    if newFillLevel < = 0 then
                        self:setFillUnitCapacity(spec.fillUnitIndex, 1 )
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
function StrawBlower:onLoad(savegame)
    local spec = self.spec_strawBlower

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.strawBlower.baleTrigger#index" , "vehicle.strawBlower.baleTrigger#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.strawBlower.doorAnimation#name" , "vehicle.foldable.foldingParts.foldingPart.animationName" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.strawBlower.balePickupTrigger" , "vehicle.autoLoaderBales.trigger" ) --FS22 to FS25

    spec.triggeredBales = { }

    if self.isServer then
        spec.triggerId = self.xmlFile:getValue( "vehicle.strawBlower.baleTrigger#node" , nil , self.components, self.i3dMappings)
        if spec.triggerId ~ = nil then
            addTrigger(spec.triggerId, "strawBlowerBaleTriggerCallback" , self )
        end
    end

    if self.isClient then
        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.strawBlower.animationNodes" , self.components, self , self.i3dMappings)

        spec.samples = { }
        spec.samples.start = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.strawBlower.sounds" , "start" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.stop = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.strawBlower.sounds" , "stop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.strawBlower.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.strawBlower#fillUnitIndex" , 1 )

    -- we need to send the full fill level rather than percentages since we change the capacity
    local fillUnit = self:getFillUnitByIndex(spec.fillUnitIndex)
    fillUnit.synchronizeFullFillLevel = true
    fillUnit.needsSaving = false

    if savegame ~ = nil and not savegame.resetVehicles then
        self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, FillType.UNKNOWN, ToolType.UNDEFINED)
    end

    if not self.isServer then
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , StrawBlower )
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
function StrawBlower:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_strawBlower
    if spec.currentBale = = nil and self:getFillUnitSupportsToolType(spec.fillUnitIndex, ToolType.BALE) then
        local bale = next(spec.triggeredBales)
        if bale ~ = nil then
            self:setFillUnitCapacity(spec.fillUnitIndex, bale:getFillLevel())
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, FillType.UNKNOWN, ToolType.UNDEFINED)
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, bale:getFillLevel(), bale:getFillType(), ToolType.BALE)
            spec.currentBale = bale
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
function StrawBlower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
    and SpecializationUtil.hasSpecialization( Trailer , specializations)
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
function StrawBlower.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , StrawBlower )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , StrawBlower )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , StrawBlower )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , StrawBlower )
    SpecializationUtil.registerEventListener(vehicleType, "onDischargeStateChanged" , StrawBlower )
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
function StrawBlower.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "strawBlowerBaleTriggerCallback" , StrawBlower.strawBlowerBaleTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onDeleteStrawBlowerObject" , StrawBlower.onDeleteStrawBlowerObject)
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
function StrawBlower.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDrawFirstFillText" , StrawBlower.getDrawFirstFillText)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowDynamicMountFillLevelInfo" , StrawBlower.getAllowDynamicMountFillLevelInfo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addFillUnitFillLevel" , StrawBlower.addFillUnitFillLevel)
end

```

### strawBlowerBaleTriggerCallback

**Description**

> Trigger callback

**Definition**

> strawBlowerBaleTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean
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
function StrawBlower:strawBlowerBaleTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_strawBlower

    if onEnter then
        -- this happens if a compound child of a deleted compound is entering
            if otherActorId ~ = 0 then
                local object = g_currentMission:getNodeObject(otherActorId)
                if object ~ = nil then
                    if object:isa( Bale ) and g_currentMission.accessHandler:canFarmAccess( self:getActiveFarm(), object) and object:getAllowPickup() then
                        if self:getFillUnitSupportsFillType(spec.fillUnitIndex, object:getFillType()) then
                            spec.triggeredBales[object] = Utils.getNoNil(spec.triggeredBales[object], 0 ) + 1
                            object.allowPickup = false

                            if spec.triggeredBales[object] = = 1 then
                                if object.addDeleteListener ~ = nil then
                                    object:addDeleteListener( self , "onDeleteStrawBlowerObject" )
                                end
                            end
                        end
                    end
                end
            end
        elseif onLeave then
                if otherActorId ~ = 0 then
                    local object = g_currentMission:getNodeObject(otherActorId)
                    if object ~ = nil then
                        local triggerCount = spec.triggeredBales[object]
                        if triggerCount ~ = nil then
                            if triggerCount = = 1 then
                                spec.triggeredBales[object] = nil
                                object.allowPickup = true
                                if object = = spec.currentBale then
                                    spec.currentBale = nil
                                    self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, self:getFillUnitFillType(spec.fillUnitIndex), ToolType.UNDEFINED)
                                end

                                if object.removeDeleteListener ~ = nil then
                                    object:removeDeleteListener( self , "onDeleteStrawBlowerObject" )
                                end
                            else
                                    spec.triggeredBales[object] = triggerCount - 1
                                end
                            end
                        end
                    end
                end
            end

```