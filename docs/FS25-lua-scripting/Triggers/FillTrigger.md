## FillTrigger

**Description**

> Class for fill triggers

**Functions**

- [delete](#delete)
- [fillTriggerCallback](#filltriggercallback)
- [fillVehicle](#fillvehicle)
- [getIsActivatable](#getisactivatable)
- [new](#new)
- [onCreate](#oncreate)
- [onVehicleDeleted](#onvehicledeleted)

### delete

**Description**

> Delete fill trigger

**Definition**

> delete()

**Code**

```lua
function FillTrigger:delete()
    -- remove the gas stations from all vehicles that are triggered by this trigger
    for vehicle,count in pairs( self.vehiclesTriggerCount) do
        if count > 0 then
            if vehicle.removeFillUnitTrigger ~ = nil then
                vehicle:removeFillUnitTrigger( self )
            end
        end
    end

    g_soundManager:deleteSample( self.sample)

    removeTrigger( self.triggerId)
end

```

### fillTriggerCallback

**Description**

> Trigger callback

**Definition**

> fillTriggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger |
|---------|-----------|---------------|
| integer | otherId   | id of actor   |
| boolean | onEnter   | on enter      |
| boolean | onLeave   | on leave      |
| boolean | onStay    | on stay       |

**Code**

```lua
function FillTrigger:fillTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and(onEnter or onLeave) then
        local vehicle = g_currentMission:getNodeObject(otherId)
        if vehicle ~ = nil and vehicle.addFillUnitTrigger ~ = nil and vehicle.removeFillUnitTrigger ~ = nil and vehicle ~ = self and vehicle ~ = self.sourceObject then
            local count = Utils.getNoNil( self.vehiclesTriggerCount[vehicle], 0 )
            if onEnter then
                local fillType = self:getCurrentFillType()

                local fillUnitIndex = vehicle:getFillUnitIndexFromNode(otherId)
                if fillUnitIndex ~ = nil then
                    if not vehicle:getFillUnitCanBeFilled(fillUnitIndex, fillType) then
                        fillUnitIndex = nil
                    end
                end

                if fillUnitIndex ~ = nil then
                    self.vehiclesTriggerCount[vehicle] = count + 1
                    if self.vehicleToFillUnitIndices[vehicle] = = nil then
                        self.vehicleToFillUnitIndices[vehicle] = { }
                    end
                    self.vehicleToFillUnitIndices[vehicle][otherId] = fillUnitIndex

                    if count = = 0 then
                        vehicle:addFillUnitTrigger( self , fillType, fillUnitIndex)
                    end
                end
            else
                    self.vehiclesTriggerCount[vehicle] = count - 1

                    if self.vehicleToFillUnitIndices[vehicle] ~ = nil then
                        self.vehicleToFillUnitIndices[vehicle][otherId] = nil

                        if next( self.vehicleToFillUnitIndices[vehicle]) = = nil then
                            self.vehicleToFillUnitIndices[vehicle] = nil
                        end
                    end

                    if count < = 1 then
                        self.vehiclesTriggerCount[vehicle] = nil
                        vehicle:removeFillUnitTrigger( self )

                        if self.moneyChangeType ~ = nil then
                            g_currentMission:showMoneyChange( self.moneyChangeType, nil , false , vehicle:getActiveFarm())
                        end
                    end
                end
            end
        end
    end

```

### fillVehicle

**Description**

> Fill vehicle

**Definition**

> fillVehicle(table vehicle, float delta, )

**Arguments**

| table | vehicle | vehicle to fill |
|-------|---------|-----------------|
| float | delta   | delta           |
| any   | dt      |                 |

**Return Values**

| any | delta | real delta |
|-----|-------|------------|

**Code**

```lua
function FillTrigger:fillVehicle(vehicle, delta, dt)
    if self.fillLitersPerSecond ~ = nil then
        delta = math.min(delta, self.fillLitersPerSecond * 0.001 * dt)
    end

    local farmId = vehicle:getActiveFarm()

    if self.sourceObject ~ = nil then
        local sourceFuelFillLevel = self.sourceObject:getFillUnitFillLevel( self.fillUnitIndex)
        if sourceFuelFillLevel > 0 and g_currentMission.accessHandler:canFarmAccess(farmId, self.sourceObject) then
            delta = math.min(delta, sourceFuelFillLevel)
            if delta < = 0 then
                return 0
            end
        else
                return 0
            end
        end

        local fillType = self:getCurrentFillType()

        local fillUnitIndex
        if self.vehicleToFillUnitIndices[vehicle] ~ = nil then
            for _, _fillUnitIndex in pairs( self.vehicleToFillUnitIndices[vehicle]) do
                if vehicle:getFillUnitCanBeFilled(_fillUnitIndex, fillType) then
                    fillUnitIndex = _fillUnitIndex
                    break
                end
            end
        end

        if fillUnitIndex = = nil then
            return 0
        end

        if vehicle.getCustomFillTriggerSpeedFactor ~ = nil then
            delta = delta * vehicle:getCustomFillTriggerSpeedFactor( self , fillUnitIndex, fillType)
        end

        delta = vehicle:addFillUnitFillLevel(farmId, fillUnitIndex, delta, fillType, ToolType.TRIGGER, nil )

        if delta > 0 then
            if self.sourceObject ~ = nil then
                self.sourceObject:addFillUnitFillLevel(farmId, self.fillUnitIndex, - delta, fillType, ToolType.TRIGGER, nil )
            else
                    local price = delta * g_currentMission.economyManager:getPricePerLiter(fillType)
                    g_farmManager:updateFarmStats(farmId, "expenses" , price)
                    g_currentMission:addMoney( - price, farmId, self.moneyChangeType, true )
                end
            end

            return delta
        end

```

### getIsActivatable

**Description**

> Returns true if is activateable

**Definition**

> getIsActivatable(table vehicle)

**Arguments**

| table | vehicle | vehicle |
|-------|---------|---------|

**Return Values**

| table | isActivateable | is activateable |
|-------|----------------|-----------------|

**Code**

```lua
function FillTrigger:getIsActivatable(vehicle)
    if self.sourceObject ~ = nil then
        if self.sourceObject:getFillUnitFillLevel( self.fillUnitIndex) > 0 and g_currentMission.accessHandler:canFarmAccess(vehicle:getActiveFarm(), self.sourceObject) then
            return true
        end
    end

    return false
end

```

### new

**Description**

> Create fill trigger object

**Definition**

> new(integer id, table sourceObject, integer fillUnitIndex, table? customMt, , )

**Arguments**

| integer | id              | id of trigger node          |
|---------|-----------------|-----------------------------|
| table   | sourceObject    | sourceObject                |
| integer | fillUnitIndex   | fillUnitIndex               |
| table?  | customMt        | custom metatable (optional) |
| any     | defaultFillType |                             |
| any     | customMt        |                             |

**Return Values**

| any | instance | instance of gas station trigger |
|-----|----------|---------------------------------|

**Code**

```lua
function FillTrigger.new(id, sourceObject, fillUnitIndex, fillLitersPerSecond, defaultFillType, customMt)
    local self = setmetatable( { } , customMt or FillTrigger _mt)

    self.customEnvironment = g_currentMission.loadingMapModName

    self.triggerId = id
    --#debug local colPreset = CollisionPreset.FILL_TRIGGER
    --#debug local group, mask = getCollisionFilter(id)
    --#debug if group ~ = colPreset.group then
        --#debug Logging.i3dWarning(id, "collision filter group for trigger does not match the 'FILL_TRIGGER' preset")
            --#debug end
            --#debug if mask ~ = colPreset.mask then
                --#debug Logging.i3dWarning(id, "collision filter mask for trigger does not match the 'FILL_TRIGGER' preset")
                    --#debug end
                    addTrigger(id, "fillTriggerCallback" , self )

                    -- place sound at the same position as the trigger
                    self.soundNode = createTransformGroup( "fillTriggerSoundNode" )
                    link(getParent(id), self.soundNode)
                    setTranslation( self.soundNode, getTranslation(id))

                    self.sourceObject = sourceObject
                    self.vehiclesTriggerCount = { }
                    self.vehicleToFillUnitIndices = { }
                    self.fillUnitIndex = fillUnitIndex
                    self.fillLitersPerSecond = fillLitersPerSecond
                    self.isEnabled = true

                    self.fillTypeIndex = FillType.DIESEL

                    return self
                end

```

### onCreate

**Description**

> On create fill trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | id of trigger node |
|---------|----|--------------------|

**Code**

```lua
function FillTrigger:onCreate(id)
    local fillTrigger = FillTrigger.new(id)
    -- we can register this on client and server because onCreate is called on map load only
    local moneyChangeType = MoneyType.register( "other" , "finance_purchaseFuel" )
    fillTrigger:setMoneyChangeType(moneyChangeType)
    g_currentMission:addNonUpdateable(fillTrigger)
end

```

### onVehicleDeleted

**Description**

> Called if vehicle gets out of trigger

**Definition**

> onVehicleDeleted(table vehicle)

**Arguments**

| table | vehicle | vehicle |
|-------|---------|---------|

**Code**

```lua
function FillTrigger:onVehicleDeleted(vehicle)
    self.vehiclesTriggerCount[vehicle] = nil

    if self.moneyChangeType ~ = nil then
        g_currentMission:showMoneyChange( self.moneyChangeType, nil , false , vehicle:getActiveFarm())
    end
end

```