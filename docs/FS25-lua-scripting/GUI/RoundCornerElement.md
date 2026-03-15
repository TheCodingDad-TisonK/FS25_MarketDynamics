## RoundCornerElement

**Parent**

> [GuiElement](?version=script&category=43&class=487)

**Functions**

- [copyAttributes](#copyattributes)
- [draw](#draw)
- [getColor](#getcolor)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function RoundCornerElement:copyAttributes(src)
    RoundCornerElement:superClass().copyAttributes( self , src)

    self.color = table.copyIndex(src.color)

    if src.colorDisabled ~ = nil then
        self.colorDisabled = table.copyIndex(src.colorDisabled)
    end
    if src.colorFocused ~ = nil then
        self.colorFocused = table.copyIndex(src.colorFocused)
    end
    if src.colorSelected ~ = nil then
        self.colorSelected = table.copyIndex(src.colorSelected)
    end
    if src.colorPressed ~ = nil then
        self.colorPressed = table.copyIndex(src.colorPressed)
    end
    if src.colorHighlighted ~ = nil then
        self.colorHighlighted = table.copyIndex(src.colorHighlighted)
    end

    self.cornerSize = src.cornerSize
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function RoundCornerElement:draw(clipX1, clipY1, clipX2, clipY2)
    local color = self:getColor()
    drawFilledRectRound( self.absPosition[ 1 ], self.absPosition[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ], self.cornerSize, color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ], clipX1, clipY1, clipX2, clipY2)

    RoundCornerElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
end

```

### getColor

**Description**

**Definition**

> getColor()

**Code**

```lua
function RoundCornerElement:getColor()
    local returnColor
    if self:getIsDisabled() then
        returnColor = self.colorDisabled
    elseif self.getIsPressed ~ = nil and self:getIsPressed() then
            returnColor = self.colorPressed
        elseif self:getIsSelected() then
                returnColor = self.colorSelected
            elseif self:getIsFocused() then
                    returnColor = self.colorFocused
                elseif self:getIsHighlighted() then
                        returnColor = self.colorHighlighted
                    end

                    return returnColor or self.color
                end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function RoundCornerElement:loadFromXML(xmlFile, key)
    RoundCornerElement:superClass().loadFromXML( self , xmlFile, key)

    local color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#color" ))
    if color ~ = nil then
        self.color = color
    end

    color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#colorDisabled" ))
    if color ~ = nil then
        self.colorDisabled = color
    end

    color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#colorHighlighted" ))
    if color ~ = nil then
        self.colorHighlighted = color
    end

    color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#colorSelected" ))
    if color ~ = nil then
        self.colorSelected = color
    end

    color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#colorFocused" ))
    if color ~ = nil then
        self.colorFocused = color
    end

    color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#colorPressed" ))
    if color ~ = nil then
        self.colorPressed = color
    end

    self.cornerSize = getXMLFloat(xmlFile, key .. "#cornerSize" ) or self.cornerSize
end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function RoundCornerElement:loadProfile(profile, applyProfile)
    RoundCornerElement:superClass().loadProfile( self , profile, applyProfile)

    local color = GuiUtils.getColorGradientArray(profile:getValue( "color" ))
    if color ~ = nil then
        self.color = color
    end

    color = GuiUtils.getColorGradientArray(profile:getValue( "colorDisabled" ))
    if color ~ = nil then
        self.colorDisabled = color
    end

    color = GuiUtils.getColorGradientArray(profile:getValue( "colorFocused" ))
    if color ~ = nil then
        self.colorFocused = color
    end

    color = GuiUtils.getColorGradientArray(profile:getValue( "colorSelected" ))
    if color ~ = nil then
        self.colorSelected = color
    end

    color = GuiUtils.getColorGradientArray(profile:getValue( "colorHighlighted" ))
    if color ~ = nil then
        self.colorHighlighted = color
    end

    color = GuiUtils.getColorGradientArray(profile:getValue( "colorPressed" ))
    if color ~ = nil then
        self.colorPressed = color
    end

    self.cornerSize = tonumber(profile:getValue( "cornerSize" , self.cornerSize))
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function RoundCornerElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or RoundCornerElement _mt)

    self.color = { 1 , 1 , 1 , 1 }

    self.cornerSize = 1 -- 1 equals 20px

    return self
end

```