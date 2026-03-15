## VehicleBuyingStationActivatable

**Functions**

- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function VehicleBuyingStationActivatable:getIsActivatable()
    return g_currentMission.accessHandler:canPlayerAccess( self.placeable)
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | placeable    |
|-----|--------------|
| any | callbackFunc |
| any | text         |

**Code**

```lua
function VehicleBuyingStationActivatable.new(placeable, callbackFunc, text)
    local self = setmetatable( { } , VehicleBuyingStationActivatable _mt)

    self.placeable = placeable
    self.callbackFunc = callbackFunc
    self.activateText = text

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function VehicleBuyingStationActivatable:run()
    self.callbackFunc()
end

```