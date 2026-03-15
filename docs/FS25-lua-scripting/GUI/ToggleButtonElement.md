## ToggleButtonElement

**Description**

> TODO: Refactor child display element retrieval
> Used layers: "image" for the background.

**Parent**

> [BitmapElement](?version=script&category=43&class=507)

**Functions**

- [addElement](#addelement)
- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [getFocusTarget](#getfocustarget)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [mouseEvent](#mouseevent)
- [new](#new)
- [onButtonClicked](#onbuttonclicked)
- [onFocusActivate](#onfocusactivate)
- [onFocusEnter](#onfocusenter)
- [onFocusLeave](#onfocusleave)
- [setIsChecked](#setischecked)

### addElement

**Description**

**Definition**

> addElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function ToggleButtonElement:addElement(element)
    ToggleButtonElement:superClass().addElement( self , element)
    if # self.elements < = 2 then
        element.target = self
        element:setCallback( "onClickCallback" , "onButtonClicked" )
        self:setIsChecked( self.isChecked)
        self:setDisabled( self.disabled)
    end
end

```

### canReceiveFocus

**Description**

> Focus methods

**Definition**

> canReceiveFocus()

**Code**

```lua
function ToggleButtonElement:canReceiveFocus()
    return not( self.disabled or not self:getIsVisible())
end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function ToggleButtonElement:copyAttributes(src)
    ToggleButtonElement:superClass().copyAttributes( self , src)
    self.isChecked = src.isChecked
    self.onClickCallback = src.onClickCallback
end

```

### getFocusTarget

**Description**

> Get the actual focus target of this element.

**Definition**

> getFocusTarget()

**Code**

```lua
function ToggleButtonElement:getFocusTarget()
    -- shadow parent behavior, always focus self
    return self
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
function ToggleButtonElement:loadFromXML(xmlFile, key)
    ToggleButtonElement:superClass().loadFromXML( self , xmlFile, key)

    self:addCallback(xmlFile, key .. "#onClick" , "onClickCallback" )
    self:setIsChecked( Utils.getNoNil(getXMLBool(xmlFile, key .. "#isChecked" ), self.isChecked))
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
function ToggleButtonElement:loadProfile(profile, applyProfile)
    ToggleButtonElement:superClass().loadProfile( self , profile, applyProfile)

    self:setIsChecked(profile:getBool( "isChecked" , self.isChecked))
end

```

### mouseEvent

**Description**

**Definition**

> mouseEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | button    |
| any | eventUsed |

**Code**

```lua
function ToggleButtonElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        -- check if button is highlighted
            if not eventUsed and GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ]) then
                FocusManager:setHighlight( self )
            else
                    FocusManager:unsetHighlight( self )
                end
                -- check for other mouse actions
                    return ToggleButtonElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed)
                end
                return false
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
function ToggleButtonElement.new(target, custom_mt)
    if custom_mt = = nil then
        custom_mt = ToggleButtonElement _mt
    end
    local self = BitmapElement.new(target, custom_mt)

    self.isChecked = false

    return self
end

```

### onButtonClicked

**Description**

**Definition**

> onButtonClicked()

**Code**

```lua
function ToggleButtonElement:onButtonClicked()
    self:setIsChecked( not self.isChecked)
    if self.onClickCallback ~ = nil then
        if self.target ~ = nil then
            self.onClickCallback( self.target, self , self.isChecked)
        else
                self.onClickCallback( self , self.isChecked)
            end
        end
    end

```

### onFocusActivate

**Description**

**Definition**

> onFocusActivate()

**Code**

```lua
function ToggleButtonElement:onFocusActivate()
    self:onButtonClicked()
end

```

### onFocusEnter

**Description**

**Definition**

> onFocusEnter()

**Code**

```lua
function ToggleButtonElement:onFocusEnter()
    if self.elements[ 1 ] ~ = nil then
        self.elements[ 1 ]:onFocusEnter()
    end
    if self.elements[ 2 ] ~ = nil then
        self.elements[ 2 ]:onFocusEnter()
    end
end

```

### onFocusLeave

**Description**

**Definition**

> onFocusLeave()

**Code**

```lua
function ToggleButtonElement:onFocusLeave()
    if self.elements[ 1 ] ~ = nil then
        self.elements[ 1 ]:onFocusLeave()
    end
    if self.elements[ 2 ] ~ = nil then
        self.elements[ 2 ]:onFocusLeave()
    end
end

```

### setIsChecked

**Description**

**Definition**

> setIsChecked()

**Arguments**

| any | isChecked |
|-----|-----------|

**Code**

```lua
function ToggleButtonElement:setIsChecked(isChecked)
    self.isChecked = isChecked
    if self.elements[ 1 ] ~ = nil then
        self.elements[ 1 ]:setVisible( self.isChecked)
    end
    if self.elements[ 2 ] ~ = nil then
        self.elements[ 2 ]:setVisible( not self.isChecked)
    end
end

```