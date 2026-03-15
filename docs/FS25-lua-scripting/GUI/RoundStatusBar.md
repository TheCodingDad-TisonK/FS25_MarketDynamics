## RoundStatusBar

**Functions**

- [delete](#delete)
- [new](#new)
- [render](#render)
- [setPosition](#setposition)
- [setValue](#setvalue)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function RoundStatusBar:delete()
    if self.overlayFront ~ = nil then
        self.overlayFront:delete()
    end
    if self.overlayBackground1 ~ = nil then
        self.overlayBackground1:delete()
    end
    if self.overlayBackground2 ~ = nil then
        self.overlayBackground2:delete()
    end
    if self.overlayValue1 ~ = nil then
        self.overlayValue1:delete()
    end
    if self.overlayValue2 ~ = nil then
        self.overlayValue2:delete()
    end
    if self.overlayMarker ~ = nil then
        self.overlayMarker:delete()
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | frontSliceId  |
|-----|---------------|
| any | valueSliceId  |
| any | markerSliceId |
| any | x             |
| any | y             |
| any | width         |
| any | height        |
| any | valueWidth    |
| any | valueHeight   |
| any | radius        |
| any | color         |
| any | bgColor       |
| any | valueColor    |
| any | markerSize    |
| any | custom_mt     |

**Code**

```lua
function RoundStatusBar.new(frontSliceId, valueSliceId, markerSliceId, x, y, width, height, valueWidth, valueHeight, radius, color, bgColor, valueColor, markerSize, custom_mt)
    if custom_mt = = nil then
        custom_mt = RoundStatusBar _mt
    end
    local self = setmetatable( { } , custom_mt)

    self.value = 0
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.radius = radius
    self.offsetX = (width - valueWidth) / 2
    self.offsetY = (height - valueHeight) / 2

    if frontSliceId ~ = nil then
        self.overlayBackground = g_overlayManager:createOverlay(frontSliceId, x, y, width, height)
    end

    self.overlayBackground1 = g_overlayManager:createOverlay(valueSliceId, x + self.offsetX, y + self.offsetY, valueWidth, valueHeight)
    self.overlayBackground1:setColor( unpack(bgColor))

    self.overlayBackground2 = g_overlayManager:createOverlay(valueSliceId, x + self.offsetX, y + self.offsetY, valueWidth, valueHeight)
    self.overlayBackground2:setColor( unpack(bgColor))

    self.overlayValue1 = g_overlayManager:createOverlay(valueSliceId, x + self.offsetX, y + self.offsetY, valueWidth, valueHeight)
    self.overlayValue1:setColor( unpack(valueColor))

    self.overlayValue2 = g_overlayManager:createOverlay(valueSliceId, x + self.offsetX, y + self.offsetY, valueWidth, valueHeight)
    self.overlayValue2:setColor( unpack(valueColor))

    if markerSliceId ~ = nil then
        self.overlayMarker = g_overlayManager:createOverlay(valueSliceId, x, y, markerSize[ 1 ], markerSize[ 2 ])
        self.overlayMarker:setColor( unpack(valueColor))
    end

    self.overlayValue2:setRotation( math.rad( 180 ), self.overlayValue2.width * 0.5 , self.overlayValue2.height * 0.5 )
    self:setValue( 0 )

    return self
end

```

### render

**Description**

**Definition**

> render()

**Code**

```lua
function RoundStatusBar:render()
    if self.value > 0.5 then
        self.overlayBackground2:render()
    end
    self.overlayValue1:render()

    if self.value > 0.5 then
        self.overlayValue2:render()
    else
            self.overlayBackground2:render()
            self.overlayBackground1:render()
        end
        if self.overlayFront ~ = nil then
            self.overlayFront:render()
        end
        if self.overlayMarker ~ = nil then
            self.overlayMarker:render()
        end
    end

```

### setPosition

**Description**

**Definition**

> setPosition()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function RoundStatusBar:setPosition(x, y)
    self.x = Utils.getNoNil(x, self.x)
    self.y = Utils.getNoNil(y, self.y)

    self.overlayValue1:setPosition( self.x + self.offsetX, self.y + self.offsetY)
    self.overlayValue2:setPosition( self.x + self.offsetX, self.y + self.offsetY)
    self.overlayBackground1:setPosition( self.x + self.offsetX, self.y + self.offsetY)
    self.overlayBackground2:setPosition( self.x + self.offsetX, self.y + self.offsetY)
    if self.overlayFront ~ = nil then
        self.overlayFront:setPosition( self.x, self.y)
    end
end

```

### setValue

**Description**

**Definition**

> setValue()

**Arguments**

| any | newValue |
|-----|----------|

**Code**

```lua
function RoundStatusBar:setValue(newValue)
    self.value = math.clamp(newValue, 0 , 1 )
    self.overlayValue1:setRotation( math.rad((( 1 - self.value) * 360 )), self.overlayValue1.width * 0.5 , self.overlayValue1.height * 0.5 )
    self.overlayBackground1:setRotation( math.rad( 180 + ( - self.value * 360 )), self.overlayBackground1.width * 0.5 , self.overlayBackground1.height * 0.5 )

    if self.overlayMarker ~ = nil then
        local markerPosX = math.cos( math.rad((( 1 - self.value) * 360 ) + 90 )) * self.radius[ 1 ]
        local markerPosY = math.sin( math.rad((( 1 - self.value) * 360 ) + 90 )) * self.radius[ 2 ]
        self.overlayMarker:setPosition( self.x + self.width / 2 - self.overlayMarker.width / 2 + markerPosX, self.y + self.height / 2 - self.overlayMarker.height / 2 + markerPosY)
    end
end

```