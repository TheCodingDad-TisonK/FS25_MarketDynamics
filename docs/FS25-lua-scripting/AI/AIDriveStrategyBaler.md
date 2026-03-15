## AIDriveStrategyBaler

**Description**

> drive strategy to
> - automatic bale dropping while ai is active
    > Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Parent**

> [AIDriveStrategy](?version=script&category=4&class=147)

**Functions**

- [getDriveData](#getdrivedata)
- [new](#new)
- [setAIVehicle](#setaivehicle)
- [update](#update)
- [updateDriving](#updatedriving)

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
function AIDriveStrategyBaler:getDriveData(dt, vX,vY,vZ)
    local allowedToDrive = true
    local maxSpeed = math.huge

    for _, baler in pairs( self.balers) do
        local spec = baler.spec_baler

        if not spec.nonStopBaling then
            local fillLevel = baler:getFillUnitFillLevel(spec.fillUnitIndex)
            local capacity = baler:getFillUnitCapacity(spec.fillUnitIndex)

            local freeFillLevel = capacity - fillLevel
            if freeFillLevel < self.slowDownFillLevel then
                -- we want to drive at least 2 km/h to avoid baler stops too early
                maxSpeed = 2 + (freeFillLevel / self.slowDownFillLevel) * self.slowDownStartSpeed

                if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                    self.vehicle:addAIDebugText( string.format( "BALER -> Slow down because nearly full: %.2f" , maxSpeed))
                end
            end

            if fillLevel = = capacity or spec.unloadingState ~ = Baler.UNLOADING_CLOSED then
                allowedToDrive = false
            end
        else
                if spec.platformDropInProgress then
                    maxSpeed = spec.platformAIDropSpeed

                    if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                        self.vehicle:addAIDebugText( string.format( "BALER -> Platform dropping active, reducing speed to %.1f km/h" , spec.platformAIDropSpeed))
                    end
                end
            end
        end

        if not allowedToDrive then
            return 0 , 1 , true , 0 , math.huge
        else
                return nil , nil , nil , maxSpeed, nil
            end
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
function AIDriveStrategyBaler.new(reconstructionData, customMt)
    local self = AIDriveStrategy.new(reconstructionData, customMt or AIDriveStrategyBaler _mt)

    self.balers = { }

    self.slowDownFillLevel = 200
    self.slowDownStartSpeed = 20

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
function AIDriveStrategyBaler:setAIVehicle(vehicle)
    AIDriveStrategyBaler:superClass().setAIVehicle( self , vehicle)

    if SpecializationUtil.hasSpecialization( Baler , self.vehicle.specializations) then
        table.insert( self.balers, self.vehicle)
    end
    for _,implement in pairs( self.vehicle:getAttachedAIImplements()) do
        if SpecializationUtil.hasSpecialization( Baler , implement.object.specializations) then
            table.insert( self.balers, implement.object)
        end
    end
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
function AIDriveStrategyBaler:update(dt)
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
function AIDriveStrategyBaler:updateDriving(dt)
end

```