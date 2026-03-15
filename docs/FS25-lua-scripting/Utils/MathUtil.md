## MathUtil

**Description**

> Util for mathematic operations

**Functions**

- [directionToPitchYaw](#directiontopitchyaw)
- [eulerToDirection](#eulertodirection)

### directionToPitchYaw

**Description**

> Calculates the pitch and yaw in radians of the given direction.

**Definition**

> directionToPitchYaw(float directionX, float directionY, float directionZ)

**Arguments**

| float | directionX | The x axis of the direction. |
|-------|------------|------------------------------|
| float | directionY | The y axis of the direction. |
| float | directionZ | The z axis of the direction. |

**Return Values**

| float | pitch | The pitch (x axis) of the rotation. |
|-------|-------|-------------------------------------|
| float | yaw   | The yaw (y axis) of the rotation.   |

**Code**

```lua
function MathUtil.directionToPitchYaw(directionX, directionY, directionZ)
    return math.asin( - directionY), math.atan2(directionX, directionZ)
end

```

### eulerToDirection

**Description**

> Converts the given euler yaw and pitch into a direction vector.

**Definition**

> eulerToDirection(float yaw, float pitch)

**Arguments**

| float | yaw   | The yaw (y rotation) of the euler.   |
|-------|-------|--------------------------------------|
| float | pitch | The pitch (x rotation) of the euler. |

**Return Values**

| float | x | The x axis of the direction. |
|-------|---|------------------------------|
| float | y | The y axis of the direction. |
| float | z | The z axis of the direction. |

**Code**

```lua
function MathUtil.eulerToDirection(yaw, pitch)

    -- The length of the x and y axis.When the direction is pointing straight up or down; this will be 0.
    local xzLength = math.cos( - pitch)

    -- Rotate the node around the y axis.
    return xzLength * math.sin(yaw), math.sin( - pitch), xzLength * math.cos(yaw)
end

```