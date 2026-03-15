## InfoDialog

**Description**

> Basic information dialog with text and confirmation.

**Parent**

> [MessageDialog](?version=script&category=&class=)

**Functions**

- [inputEvent](#inputevent)
- [show](#show)

### inputEvent

**Description**

**Definition**

> inputEvent()

**Arguments**

| any | action    |
|-----|-----------|
| any | value     |
| any | eventUsed |

**Code**

```lua
function InfoDialog:inputEvent(action, value, eventUsed)
    eventUsed = InfoDialog:superClass().inputEvent( self , action, value, eventUsed)

    if Platform.isAndroid and self.inputDisableTime < = 0 then
        if action = = InputAction.MENU_BACK then
            self:onClickOk()

            -- always consume event to avoid triggering any other focused elements
            eventUsed = true
        end
    end

    return eventUsed
end

```

### show

**Description**

**Definition**

> show(string text, function? callback, table? target, integer? dialogType, string? okText, string? buttonAction, any
> callbackArgs, boolean? disableOpenSound)

**Arguments**

| string    | text             |                                                             |
|-----------|------------------|-------------------------------------------------------------|
| function? | callback         |                                                             |
| table?    | target           |                                                             |
| integer?  | dialogType       | one of DialogElement.TYPE_, default DialogElement.TYPE_INFO |
| string?   | okText           |                                                             |
| string?   | buttonAction     |                                                             |
| any       | callbackArgs     |                                                             |
| boolean?  | disableOpenSound |                                                             |

**Code**

```lua
function InfoDialog.show(text, callback, target, dialogType, okText, buttonAction, callbackArgs, disableOpenSound)
    if InfoDialog.INSTANCE ~ = nil then
        local dialog = InfoDialog.INSTANCE

        dialog:setCallback(callback, target, callbackArgs)
        dialog:setDialogType( Utils.getNoNil(dialogType, DialogElement.TYPE_INFO))
        dialog:setButtonTexts(okText)
        dialog:setButtonAction(buttonAction)
        dialog:setText(text)
        dialog:setDisableOpenSound(disableOpenSound)

        g_gui:showDialog( "InfoDialog" )
    end
end

```