## SmartAttachActivatable

**Description**

> This is the activable class for smartAttach

**Functions**

- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

### getIsActivatable

**Description**

> Returns if is activateable

**Definition**

> getIsActivatable()

**Return Values**

| any | isActivateable | is activateable |
|-----|----------------|-----------------|

**Code**

```lua
function SmartAttachActivatable:getIsActivatable()
    return self.smartAttachVehicle:getCanBeSmartAttached()
end

```

### new

**Description**

> Returns new instance of class

**Definition**

> new(table smartAttachVehicle)

**Arguments**

| table | smartAttachVehicle | object of smartAttachVehicle |
|-------|--------------------|------------------------------|

**Return Values**

| table | self | new instance |
|-------|------|--------------|

**Code**

```lua
function SmartAttachActivatable.new(smartAttachVehicle)
    local self = setmetatable( { } , SmartAttachActivatable _mt)

    self.smartAttachVehicle = smartAttachVehicle
    self.activateText = ""

    return self
end

```

### run

**Description**

> Called on activate object

**Definition**

> run()

**Code**

```lua
function SmartAttachActivatable:run()
    local vehicle = self.smartAttachVehicle
    local spec = vehicle.spec_smartAttach
    vehicle:doSmartAttach(spec.targetVehicle, spec.inputJointDescIndex, spec.jointDescIndex)
end

```