## TourDialog

**Description**

> Basic information dialog with text and confirmation.

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
function TourDialog:inputEvent(action, value, eventUsed)
    eventUsed = TourDialog:superClass().inputEvent( self , action, value, eventUsed)

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