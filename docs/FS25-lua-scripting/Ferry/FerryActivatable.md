## FerryActivatable

**Functions**

- [getDistance](#getdistance)
- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

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
function FerryActivatable:getDistance(posX, posY, posZ)
    local x, _, z = getWorldTranslation( self.trigger)
    local distance = MathUtil.vector2Length(posX - x, posZ - z)
    return distance
end

```

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function FerryActivatable:getIsActivatable()
    if self.ferry:getCanActivateDriving() then
        return true
    end

    return false
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | ferry |
|-----|-------|

**Code**

```lua
function FerryActivatable.new(ferry)
    local self = setmetatable( { } , FerryActivatable _mt)

    self.ferry = ferry
    self.trigger = nil

    self.activateText = g_i18n:getText( "action_startFerry" )

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function FerryActivatable:run()
    self.ferry:start()
end

```