## MainScreen

**Description**

> Main Menu Screen.

**Parent**

> [ScreenElement](?version=script&category=43&class=473)

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
function MainScreen:inputEvent(action, value, eventUsed)
    eventUsed = MainScreen:superClass().inputEvent( self , action, value, eventUsed)

    if Platform.isAndroid then
        if action = = InputAction.MENU_BACK then
            local text = g_i18n:getText( InGameMenu.L10N_SYMBOL.END_GAME)
            YesNoDialog.show( self.onYesNoEnd, self , text)

            -- always consume event to avoid triggering any other focused elements
            eventUsed = true
        end
    end

    return eventUsed
end

```