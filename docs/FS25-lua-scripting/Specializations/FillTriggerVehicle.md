## FillTriggerVehicle

**Description**

> Specialization for vehicles with a fill trigger (e.g. fuel/milk/water/liquid manure transport trailers)

**Functions**

- [getDrawFirstFillText](#getdrawfirstfilltext)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getDrawFirstFillText

**Description**

**Definition**

> getDrawFirstFillText()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FillTriggerVehicle:getDrawFirstFillText(superFunc)
    local spec = self.spec_fillTriggerVehicle
    if self.isClient then
        if spec.fillUnitIndex ~ = nil and self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 and self:getFillUnitCapacity(spec.fillUnitIndex) ~ = 0 then
            return true
        end
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
function FillTriggerVehicle.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FillTriggerVehicle" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.fillTriggerVehicle#triggerNode" , "Fill trigger node" )
    schema:register(XMLValueType.INT, "vehicle.fillTriggerVehicle#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.fillTriggerVehicle#litersPerSecond" , "Liter per second" , 200 )

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
function FillTriggerVehicle:onDelete()
    local spec = self.spec_fillTriggerVehicle

    if spec.fillTrigger ~ = nil then
        spec.fillTrigger:delete()
        spec.fillTrigger = nil
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
function FillTriggerVehicle:onLoad(savegame)
    local spec = self.spec_fillTriggerVehicle

    local triggerNode = self.xmlFile:getValue( "vehicle.fillTriggerVehicle#triggerNode" , nil , self.components, self.i3dMappings)
    if triggerNode ~ = nil then
        spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.fillTriggerVehicle#fillUnitIndex" , 1 )
        spec.litersPerSecond = self.xmlFile:getValue( "vehicle.fillTriggerVehicle#litersPerSecond" , 200 )
        spec.fillTrigger = FillTrigger.new(triggerNode, self , spec.fillUnitIndex, spec.litersPerSecond)

        if self:getPropertyState() ~ = VehiclePropertyState.SHOP_CONFIG then
            if self.isServer then
                local moneyChangeType = MoneyType.register( "other" , "finance_purchaseFuel" )
                spec.fillTrigger:setMoneyChangeType(moneyChangeType)
            end
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
function FillTriggerVehicle:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_fillTriggerVehicle
        if spec.fillTrigger ~ = nil then
            streamWriteUInt16(streamId, spec.fillTrigger.moneyChangeType.id)
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
function FillTriggerVehicle.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
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
function FillTriggerVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FillTriggerVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , FillTriggerVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , FillTriggerVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , FillTriggerVehicle )
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
function FillTriggerVehicle.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDrawFirstFillText" , FillTriggerVehicle.getDrawFirstFillText)
end

```