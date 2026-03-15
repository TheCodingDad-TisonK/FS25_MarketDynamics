## InfoDisplay

**Description**

> HUD player information

**Parent**

> [HUDDisplay](?version=script&category=&class=)

**Functions**

- [getDisplayHeight](#getdisplayheight)
- [setScale](#setscale)
- [storeScaledValues](#storescaledvalues)

### getDisplayHeight

**Description**

**Definition**

> getDisplayHeight()

**Code**

```lua
function InfoDisplay:getDisplayHeight()
    if self.isEnabled then
        return self.totalHeight
    else
            return 0
        end
    end

```

### setScale

**Description**

> Set this element's UI scale factor.

**Definition**

> setScale(float uiScale)

**Arguments**

| float | uiScale | UI scale factor |
|-------|---------|-----------------|

**Code**

```lua
function InfoDisplay:setScale(uiScale)
    InfoDisplay:superClass().setScale( self , uiScale)

    for _, box in ipairs( self.boxes) do
        box:setScale(uiScale)
    end
end

```

### storeScaledValues

**Description**

> Store scaled position and size values.

**Definition**

> storeScaledValues()

**Code**

```lua
function InfoDisplay:storeScaledValues()
    self:setPosition(g_hudAnchorRight, g_hudAnchorBottom)

    self.boxMarginY = self:scalePixelToScreenHeight( 5 )
end

```