## HumanSounds

**Functions**

- [new](#new)

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | baseDirectory |
|-----|---------------|
| any | customMt      |

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function HumanSounds.new(baseDirectory, customMt)
    local self = setmetatable( { } , customMt or HumanSounds _mt)

    self.isLoaded = false
    self.baseDirectory = baseDirectory
    self.raycastMask = bit32.bor(
    CollisionFlag.STATIC_OBJECT,
    CollisionFlag.WATER,
    CollisionFlag.TERRAIN,
    CollisionFlag.TERRAIN_DELTA,
    CollisionFlag.ROAD,
    CollisionFlag.BUILDING,
    CollisionFlag.VEHICLE -- e.g.player standing on a boat
    )

    return self
end

```