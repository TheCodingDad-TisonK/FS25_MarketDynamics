## HUDDisplayElement

**Description**

> HUD display element whose subclasses implement more complex HUD display subsystems.

**Parent**

> [HUDElement](?version=script&category=43&class=452)

**Functions**

- [animateHide](#animatehide)
- [animateShow](#animateshow)
- [animationSetPositionX](#animationsetpositionx)
- [animationSetPositionY](#animationsetpositiony)
- [getHidingTranslation](#gethidingtranslation)
- [new](#new)
- [onAnimateVisibilityFinished](#onanimatevisibilityfinished)
- [setScale](#setscale)
- [setVisible](#setvisible)
- [storeOriginalPosition](#storeoriginalposition)

### animateHide

**Description**

> Animate this element on hiding.

**Definition**

> animateHide()

**Code**

```lua
function HUDDisplayElement:animateHide()
    local transX, transY = self:getHidingTranslation()
    local startX, startY = self:getPosition()

    local sequence = TweenSequence.new( self )
    sequence:insertTween( MultiValueTween.new( self.setPosition, { startX, startY } , { startX + transX, startY + transY } , HUDDisplayElement.MOVE_ANIMATION_DURATION), 0 )
    sequence:addCallback( self.onAnimateVisibilityFinished, false )
    sequence:start()
    self.animation = sequence
end

```

### animateShow

**Description**

> Animate this element on showing.

**Definition**

> animateShow()

**Code**

```lua
function HUDDisplayElement:animateShow()
    HUDDisplayElement:superClass().setVisible( self , true )

    local startX, startY = self:getPosition()

    local sequence = TweenSequence.new( self )
    sequence:insertTween( MultiValueTween.new( self.setPosition, { startX, startY } , { self.origX, self.origY } , HUDDisplayElement.MOVE_ANIMATION_DURATION), 0 )
    sequence:addCallback( self.onAnimateVisibilityFinished, true )
    sequence:start()
    self.animation = sequence
end

```

### animationSetPositionX

**Description**

> Animation setter function for X position.

**Definition**

> animationSetPositionX()

**Arguments**

| any | x |
|-----|---|

**Code**

```lua
function HUDDisplayElement:animationSetPositionX(x)
    self:setPosition(x, nil )
end

```

### animationSetPositionY

**Description**

> Animation setter function for Y position.

**Definition**

> animationSetPositionY()

**Arguments**

| any | y |
|-----|---|

**Code**

```lua
function HUDDisplayElement:animationSetPositionY(y)
    self:setPosition( nil , y)
end

```

### getHidingTranslation

**Description**

> Get the screen space translation for hiding.
> Override in sub-classes if a different translation is required.

**Definition**

> getHidingTranslation()

**Return Values**

| any | Screen | space X translation |
|-----|--------|---------------------|
| any | Screen | space Y translation |

**Code**

```lua
function HUDDisplayElement:getHidingTranslation()
    return 0 , - 0.5
end

```

### new

**Description**

> Create a new HUD display element.

**Definition**

> new(table subClass, table overlay, table? parentHudElement)

**Arguments**

| table  | subClass         | Subclass metatable for inheritance                             |
|--------|------------------|----------------------------------------------------------------|
| table  | overlay          | Wrapped Overlay instance                                       |
| table? | parentHudElement | [optional] Parent HUD element of the newly created HUD element |

**Return Values**

| table? | HUDDisplayElement | instance |
|--------|-------------------|----------|

**Code**

```lua
function HUDDisplayElement.new(overlay, parentHudElement, customMt)
    local self = HUDDisplayElement:superClass().new(overlay, parentHudElement, customMt or HUDDisplayElement _mt)

    self.origX, self.origY = 0 , 0 -- original positions, stored to support stable animation states
    self.animationState = nil

    return self
end

```

### onAnimateVisibilityFinished

**Description**

> Called when a hiding or showing animation has finished.

**Definition**

> onAnimateVisibilityFinished()

**Arguments**

| any | isVisible |
|-----|-----------|

**Code**

```lua
function HUDDisplayElement:onAnimateVisibilityFinished(isVisible)
    if not isVisible then -- delayed call when hiding
        HUDDisplayElement:superClass().setVisible( self , isVisible)
    end
end

```

### setScale

**Description**

> Simplification of scale setter because these high-level elements always use a uniform scale.

**Definition**

> setScale()

**Arguments**

| any | uiScale |
|-----|---------|

**Code**

```lua
function HUDDisplayElement:setScale(uiScale)
    HUDDisplayElement:superClass().setScale( self , uiScale, uiScale)
end

```

### setVisible

**Description**

> Set this element's visibility with optional animation.

**Definition**

> setVisible(boolean isVisible, boolean animate)

**Arguments**

| boolean | isVisible | True is visible, false is not.                                                     |
|---------|-----------|------------------------------------------------------------------------------------|
| boolean | animate   | If true, the element will play an animation before applying the visibility change. |

**Code**

```lua
function HUDDisplayElement:setVisible(isVisible, animate)
    if animate and self.animation:getFinished() then
        if isVisible then
            self:animateShow()
        else
                self:animateHide()
            end
        else
                self.animation:stop()
                HUDDisplayElement:superClass().setVisible( self , isVisible)

                local posX, posY = self:getPosition()
                local transX, transY = self:getHidingTranslation()
                if isVisible then
                    self:setPosition( self.origX, self.origY)
                else
                        self:setPosition(posX + transX, posY + transY)
                    end
                end

                self.animationState = isVisible
            end

```

### storeOriginalPosition

**Description**

> Store the current element position as its original positions.

**Definition**

> storeOriginalPosition()

**Code**

```lua
function HUDDisplayElement:storeOriginalPosition()
    self.origX, self.origY = self:getPosition()
end

```