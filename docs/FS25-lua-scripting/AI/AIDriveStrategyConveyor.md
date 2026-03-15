## AIDriveStrategyConveyor

**Description**

> Class for a drive strategy for driving forward and backward
> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Parent**

> [AIDriveStrategy](?version=script&category=4&class=149)

**Functions**

- [getDriveData](#getdrivedata)
- [new](#new)
- [setAIVehicle](#setaivehicle)
- [update](#update)

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
function AIDriveStrategyConveyor:getDriveData(dt, vX, vY, vZ)
    local _, y, z = localToLocal( self.vehicle.wheels[ self.vehicle.aiConveyorBelt.backWheelIndex].repr, self.vehicle.components[ 1 ].node, 0 , 0 , 0 )
    local worldCX, worldCY, worldCZ = localToWorld( self.vehicle.components[ 1 ].node, 0 , y, z)
    local distanceMoved = MathUtil.vector2Length(worldCX - self.lastPos[ 1 ], worldCZ - self.lastPos[ 3 ])

    self.distanceMoved = self.distanceMoved + distanceMoved
    self.lastPos = { worldCX, worldCY, worldCZ }

    if self.distanceMoved > = self.distanceToMove then
        if self.fistTimeChange then
            self.distanceToMove = self.distanceToMove * 2
            self.fistTimeChange = false
        end

        self.distanceMoved = 0
        if self.currentTarget = = 1 then
            self.currentTarget = 2
        else
                self.currentTarget = 1
            end
        end

        local speedFactor = math.clamp( math.sin( self.distanceMoved / self.distanceToMove * 3.14 ), 0.1 , 0.5 ) * 2

        local dir = true
        if self.currentTarget = = 2 then
            dir = not dir
        end
        return self.worldTarget[ self.currentTarget][ 1 ], self.worldTarget[ self.currentTarget][ 3 ], dir, self.vehicle.aiConveyorBelt.speed * speedFactor, 100
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
function AIDriveStrategyConveyor.new(reconstructionData, customMt)
    local self = AIDriveStrategy.new(reconstructionData, customMt or AIDriveStrategyConveyor _mt)

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
function AIDriveStrategyConveyor:setAIVehicle(vehicle)
    AIDriveStrategyConveyor:superClass().setAIVehicle( self , vehicle)

    local _, y, z = localToLocal( self.vehicle.wheels[ self.vehicle.aiConveyorBelt.backWheelIndex].repr, self.vehicle.components[ 1 ].node, 0 , 0 , 0 )
    local x1, y1, z1 = localToWorld( self.vehicle.components[ 1 ].node, 0 , y, z)
    local x2, y2, z2 = getWorldTranslation( self.vehicle.wheels[ self.vehicle.aiConveyorBelt.centerWheelIndex].repr)

    local length = MathUtil.vector3Length(x1 - x2, y1 - y2, z1 - z2)
    local width = length * math.sin( math.rad( self.vehicle.aiConveyorBelt.currentAngle / 2 ))
    local length2 = math.sqrt( math.pow(length, 2 ) - math.pow(width, 2 ))

    self.distanceToMove = math.rad( self.vehicle.aiConveyorBelt.currentAngle) * length / 2

    self.currentTarget = 1

    self.worldTarget = { }
    self.worldTarget[ 1 ] = { localToWorld( self.vehicle.wheels[ self.vehicle.aiConveyorBelt.centerWheelIndex].repr, width, 0 , - length2) }
    self.worldTarget[ 2 ] = { localToWorld( self.vehicle.wheels[ self.vehicle.aiConveyorBelt.centerWheelIndex].repr, - width, 0 , - length2) }

    self.lastPos = { x1, y1, z1 }

    self.distanceMoved = 0
    self.fistTimeChange = true
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
function AIDriveStrategyConveyor:update(dt)
end

```