## CheckedOptionElement

**Description**

> Two-value on/off state input element.

**Parent**

> [MultiTextOptionElement](?version=script&category=43&class=432)

**Functions**

- [addElement](#addelement)
- [getIsChecked](#getischecked)
- [new](#new)
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
function CheckedOptionElement:addElement(element)
    CheckedOptionElement:superClass().addElement( self , element)

    if # self.elements = = 3 then
        self:setTexts( { g_i18n:getText( "ui_off" ), g_i18n:getText( "ui_on" ) } )
        self:setIsChecked( self.isChecked)
    end
end

```

### getIsChecked

**Description**

> Get whether the element is checked

**Definition**

> getIsChecked()

**Code**

```lua
function CheckedOptionElement:getIsChecked()
    return self.state = = CheckedOptionElement.STATE_CHECKED
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
function CheckedOptionElement.new(target, custom_mt)
    local self = MultiTextOptionElement.new(target, custom_mt or CheckedOptionElement _mt)

    return self
end

```

### setIsChecked

**Description**

> Set whether the element is checked

**Definition**

> setIsChecked()

**Arguments**

| any | isChecked |
|-----|-----------|

**Code**

```lua
function CheckedOptionElement:setIsChecked(isChecked)
    if isChecked then
        self:setState( CheckedOptionElement.STATE_CHECKED)
    else
            self:setState( CheckedOptionElement.STATE_UNCHECKED)
        end
    end

```