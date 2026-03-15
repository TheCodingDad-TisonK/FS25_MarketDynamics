## IngameMapMobile

**Description**

> IngameMap Mobile
> Subclass for mobile ingame map

**Parent**

> [IngameMap](?version=script&category=43&class=467)

**Functions**

- [setScale](#setscale)

### setScale

**Description**

> Set this element's scale.

**Definition**

> setScale()

**Arguments**

| any | uiScale |
|-----|---------|

**Code**

```lua
function IngameMapMobile:setScale(uiScale)
    IngameMapMobile:superClass().setScale( self , uiScale, uiScale)

    local posX, posY = self:getBackgroundPosition(uiScale)
    self:setPosition(posX, posY)
end

```