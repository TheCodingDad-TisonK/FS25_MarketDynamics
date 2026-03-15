## InfoDisplayBox

**Description**

> Info box

**Functions**

- [canDraw](#candraw)
- [delete](#delete)
- [draw](#draw)
- [new](#new)
- [setScale](#setscale)
- [storeScaledValues](#storescaledvalues)

### canDraw

**Description**

**Definition**

> canDraw()

**Code**

```lua
function InfoDisplayBox:canDraw()
    return true
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function InfoDisplayBox:delete()
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | posX |
|-----|------|
| any | posY |

**Code**

```lua
function InfoDisplayBox:draw(posX, posY)
    return posX, posY
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | infoDisplay |
|-----|-------------|
| any | uiScale     |
| any | customMt    |

**Code**

```lua
function InfoDisplayBox.new(infoDisplay, uiScale, customMt)
    local self = setmetatable( { } , customMt or InfoDisplayBox _mt)

    self.infoDisplay = infoDisplay
    self.uiScale = uiScale

    return self
end

```

### setScale

**Description**

**Definition**

> setScale()

**Arguments**

| any | uiScale |
|-----|---------|

**Code**

```lua
function InfoDisplayBox:setScale(uiScale)
    self.uiScale = uiScale
    self:storeScaledValues()
end

```

### storeScaledValues

**Description**

**Definition**

> storeScaledValues()

**Code**

```lua
function InfoDisplayBox:storeScaledValues()
end

```