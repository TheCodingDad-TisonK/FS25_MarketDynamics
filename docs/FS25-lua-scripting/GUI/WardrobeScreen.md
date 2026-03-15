## WardrobeScreen

**Description**

> Character Selection Screen.

**Parent**

> [TabbedMenuWithDetails](?version=script&category=43&class=513)

**Functions**

- [removeActionEvents](#removeactionevents)

### removeActionEvents

**Description**

> Remove non-GUI input action events.

**Definition**

> removeActionEvents()

**Code**

```lua
function WardrobeScreen:removeActionEvents()
    g_inputBinding:removeActionEvent( self.eventIdLeftRightController)
    self.eventIdLeftRightController = nil
end

```