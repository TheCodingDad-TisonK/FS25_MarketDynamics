## AIDriveStrategy

**Description**

> Base class for a drive strategy
> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Functions**

- [debugPrint](#debugprint)
- [delete](#delete)
- [getDriveData](#getdrivedata)
- [new](#new)
- [setAIVehicle](#setaivehicle)
- [update](#update)
- [updateDriving](#updatedriving)

### debugPrint

**Description**

**Definition**

> debugPrint()

**Arguments**

| any | text |
|-----|------|
| any | ...  |

**Code**

```lua
function AIDriveStrategy:debugPrint(text, .. .)
    if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
        print( string.format( "AI DEBUG: %s" , string.format(text, .. .)))
    end
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AIDriveStrategy:delete()
end

```

### getDriveData

**Description**

**Definition**

> getDriveData()

**Arguments**

| any | dt |
|-----|----|
| any | vX |
| any | vY |
| any | vZ |

**Code**

```lua
function AIDriveStrategy:getDriveData(dt, vX,vY,vZ)
    return nil , nil , nil , nil , nil
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | reconstructionData |
|-----|--------------------|
| any | customMt           |

**Code**

```lua
function AIDriveStrategy.new(reconstructionData, customMt)
    local self = setmetatable( { } , customMt or AIDriveStrategy _mt)

    return self
end

```

### setAIVehicle

**Description**

**Definition**

> setAIVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIDriveStrategy:setAIVehicle(vehicle)
    self.vehicle = vehicle
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AIDriveStrategy:update(dt)
end

```

### updateDriving

**Description**

**Definition**

> updateDriving()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AIDriveStrategy:updateDriving(dt)
end

```