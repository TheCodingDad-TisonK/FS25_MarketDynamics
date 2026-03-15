## MultiOptionDialog

**Description**

> Option Dialog with up to four actions, corresponding to MENU\_ACTIVATE, MENU\_ACCEPT, MENU\_BACK and MENU\_CANCEL

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
function MultiOptionDialog:inputEvent(action, value, eventUsed)
    eventUsed = MultiOptionDialog:superClass().inputEvent( self , action, value, eventUsed)

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