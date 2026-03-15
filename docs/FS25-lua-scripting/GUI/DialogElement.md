## DialogElement

**Description**

> Base element for modal dialogs.
> Dialogs are a specialization of ScreenElement, but work mostly the same in terms of loading and configuration. Much
> like screens, dialogs are controlled and configured by correspondingly named [dialogName]Dialog.lua and
> [dialogName]Dialog.xml files.

**Parent**

> [ScreenElement](?version=script&category=43&class=436)

**Functions**

- [close](#close)
- [new](#new)
- [onClickBack](#onclickback)
- [setDialogType](#setdialogtype)
- [setIsCloseAllowed](#setiscloseallowed)

### close

**Description**

**Definition**

> close()

**Code**

```lua
function DialogElement:close()
    g_gui:closeDialogByName( self.name)
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
function DialogElement.new(target, custom_mt)
    local self = ScreenElement.new(target, custom_mt or DialogElement _mt)

    self.isCloseAllowed = true

    return self
end

```

### onClickBack

**Description**

**Definition**

> onClickBack()

**Arguments**

| any | forceBack      |
|-----|----------------|
| any | usedMenuButton |

**Code**

```lua
function DialogElement:onClickBack(forceBack, usedMenuButton)
    if ( self.isCloseAllowed or forceBack) and not usedMenuButton then
        self:close()
        return false -- event used
    else
            return true -- event unused
        end
    end

```

### setDialogType

**Description**

**Definition**

> setDialogType()

**Arguments**

| any | dialogType |
|-----|------------|

**Code**

```lua
function DialogElement:setDialogType(dialogType)
    dialogType = dialogType or DialogElement.TYPE_WARNING
    self.dialogType = dialogType

    -- apply element visibility based on dialog type
    for dt, id in pairs(TYPE_ICON_ID_MAPPING) do
        local typeElement = self [id]
        if typeElement then
            typeElement:setVisible(dt = = dialogType)
        end
    end

    if self.dialogCircle ~ = nil then
        self.dialogCircle:setVisible(dialogType ~ = DialogElement.TYPE_LOADING)

        -- apply circle profile
        if dialogType = = DialogElement.TYPE_WARNING then
            self.dialogCircle:applyProfile( DialogElement.DIALOG_CIRCLE_PROFILE_WARNING)
        else
                self.dialogCircle:applyProfile( DialogElement.DIALOG_CIRCLE_PROFILE)
            end
        end
    end

```

### setIsCloseAllowed

**Description**

**Definition**

> setIsCloseAllowed()

**Arguments**

| any | isAllowed |
|-----|-----------|

**Code**

```lua
function DialogElement:setIsCloseAllowed(isAllowed)
    self.isCloseAllowed = isAllowed
end

```