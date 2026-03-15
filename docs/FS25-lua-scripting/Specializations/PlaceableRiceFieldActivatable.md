## PlaceableRiceFieldActivatable

**Functions**

- [getDistance](#getdistance)
- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)
- [setRiceFieldIndex](#setricefieldindex)

### getDistance

**Description**

**Definition**

> getDistance()

**Arguments**

| any | posX |
|-----|------|
| any | posY |
| any | posZ |

**Code**

```lua
function PlaceableRiceFieldActivatable:getDistance(posX, posY, posZ)
    if self.fieldIndex ~ = nil then
        local field = self.riceFieldPlaceable:getFieldByIndex( self.fieldIndex)
        if field.playerTriggerNode ~ = nil then
            local x, _, z = getWorldTranslation(field.playerTriggerNode)
            local distance = MathUtil.vector2Length(posX - x, posZ - z)
            return distance
        end
    end

    return math.huge
end

```

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function PlaceableRiceFieldActivatable:getIsActivatable()
    if self.fieldIndex = = nil then
        return false
    end
    local field = self.riceFieldPlaceable:getFieldByIndex( self.fieldIndex)
    if field = = nil then
        return false
    end
    local x, _, z = getWorldTranslation(field.playerTriggerNode)
    return g_currentMission.accessHandler:canFarmAccessLand(g_localPlayer.farmId, x, z)
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | riceFieldPlaceable |
|-----|--------------------|

**Code**

```lua
function PlaceableRiceFieldActivatable.new(riceFieldPlaceable)
    local self = setmetatable( { } , PlaceableRiceFieldActivatable _mt)

    self.riceFieldPlaceable = riceFieldPlaceable
    self.fieldIndex = nil

    self.activateText = g_i18n:getText( "action_interact" )

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function PlaceableRiceFieldActivatable:run()
    local callback = function (_, args)
        if args.isAccepted then
            local spec = self.riceFieldPlaceable.spec_riceField
            local targetHeight = spec.waterMaxLevel * args.fillLevelPercentage
            self.riceFieldPlaceable:setWaterHeightTarget( self.fieldIndex, targetHeight)
        end
    end

    RiceFieldDialog.show(callback, self.riceFieldPlaceable, g_i18n:getText( "ui_riceManageField" ), self.fieldIndex)
end

```

### setRiceFieldIndex

**Description**

**Definition**

> setRiceFieldIndex()

**Arguments**

| any | fieldIndex |
|-----|------------|

**Code**

```lua
function PlaceableRiceFieldActivatable:setRiceFieldIndex(fieldIndex)
    self.fieldIndex = fieldIndex
end

```