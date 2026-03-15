## YesNoDialog

**Description**

> Binary decision dialog.
> Base class for dialogs which require confirmation or cancellation of an action.

**Parent**

> [MessageDialog](?version=script&category=&class=)

**Functions**

- [inputEvent](#inputevent)

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
function YesNoDialog:inputEvent(action, value, eventUsed)
    eventUsed = YesNoDialog:superClass().inputEvent( self , action, value, eventUsed)

    if Platform.isAndroid and self.inputDisableTime < = 0 then
        if action = = InputAction.MENU_BACK then
            self:onNo()

            -- always consume event to avoid triggering any other focused elements
            eventUsed = true
        end
    end

    return eventUsed
end

```