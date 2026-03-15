## FieldState

**Description**

> This class wraps all Field state

**Functions**

- [new](#new)

### new

**Description**

> Create ai field definition object

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | Instance of object |
|-----|----------|--------------------|

**Code**

```lua
function FieldState.new(customMt)
    local self = setmetatable( { } , customMt or FieldState _mt)

    self.isValid = false
    self.fruitTypeIndex = FruitType.UNKNOWN
    self.growthState = 0
    self.lastGrowthState = 0
    self.weedState = 0
    self.weedFactor = 0
    self.stoneLevel = 0
    self.groundType = FieldGroundType.NONE
    self.sprayLevel = 0
    self.sprayType = 0
    self.limeLevel = 0
    self.rollerLevel = 0
    self.plowLevel = 0
    self.stubbleShredLevel = 0
    self.waterLevel = 0

    self.farmlandId = 0
    self.ownerFarmId = AccessHandler.NOBODY

    return self
end

```