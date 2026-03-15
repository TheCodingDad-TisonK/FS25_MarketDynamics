## GuiTopDownCursor

**Description**

> Top-down cursor

**Functions**

- [activate](#activate)
- [deactivate](#deactivate)
- [delete](#delete)
- [mouseEvent](#mouseevent)
- [onInputModeChanged](#oninputmodechanged)
- [registerActionEvents](#registeractionevents)
- [removeActionEvents](#removeactionevents)

### activate

**Description**

> Activate the cursor. This will show the cursor and take some input.

**Definition**

> activate()

**Code**

```lua
function GuiTopDownCursor:activate()
    self.isActive = true
    self:onInputModeChanged( { g_inputBinding:getLastInputMode() } )

    if not self.shapesLoaded then
        self:loadShapes()
    end

    if self.rootNode ~ = nil then
        setVisibility( self.rootNode, self.isVisible)
    end

    self:registerActionEvents()
    g_messageCenter:subscribe(MessageType.INPUT_MODE_CHANGED, self.onInputModeChanged, self )
end

```

### deactivate

**Description**

> Deactivate the cursor. This will hide the cursor and stop any grabbing of input.

**Definition**

> deactivate()

**Code**

```lua
function GuiTopDownCursor:deactivate()
    if self.rootNode ~ = nil then
        setVisibility( self.rootNode, false )
    end

    g_messageCenter:unsubscribeAll( self )
    self:removeActionEvents()

    self.isActive = false
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function GuiTopDownCursor:delete()
    if self.isActive then
        self:deactivate()
    end

    if self.cursorOverlay ~ = nil then
        self.cursorOverlay:delete()
        self.cursorOverlay = nil
    end

    if self.rootNode ~ = nil then
        delete( self.rootNode)
    end

    if self.loadRequestId ~ = nil then
        g_i3DManager:cancelStreamI3DFile( self.loadRequestId)
        self.loadRequestId = nil
    end
end

```

### mouseEvent

**Description**

> Handle mouse moves that are not caught by actions.

**Definition**

> mouseEvent()

**Arguments**

| any | posX   |
|-----|--------|
| any | posY   |
| any | isDown |
| any | isUp   |
| any | button |

**Code**

```lua
function GuiTopDownCursor:mouseEvent(posX, posY, isDown, isUp, button)
    if self.mouseDisabled then
        return
    end

    -- if self.isMouseMode and not self.isCatchingCursor then
        -- self.mousePosX = posX
        -- self.mousePosY = posY
        -- end

        if self.lastActionFrame > = g_ time then
            return
        end

        -- Mouse move only happens when other actions did not
        if self.isCatchingCursor then
            self.isCatchingCursor = false
            g_inputBinding:setShowMouseCursor( true , true )

            wrapMousePosition( self.lockedMousePosX, self.lockedMousePosY)

            g_inputBinding.mousePosXLast, g_inputBinding.mousePosYLast = self.lockedMousePosX, self.lockedMousePosY

            self.mousePosX = self.lockedMousePosX
            self.mousePosY = self.lockedMousePosY
        else
                if self.isMouseMode then
                    self.mousePosX = posX
                    self.mousePosY = posY
                end
            end
        end

```

### onInputModeChanged

**Description**

> Called when the mouse input mode changes.

**Definition**

> onInputModeChanged()

**Arguments**

| any | inputMode |
|-----|-----------|

**Code**

```lua
function GuiTopDownCursor:onInputModeChanged(inputMode)
    self.isMouseMode = inputMode[ 1 ] = = GS_INPUT_HELP_MODE_KEYBOARD

    -- Reset to center of screen
    if not self.isMouseMode then
        self.mousePosX = 0.5
        self.mousePosY = 0.5
    end
end

```

### registerActionEvents

**Description**

> Register required action events for the cursor.

**Definition**

> registerActionEvents()

**Code**

```lua
function GuiTopDownCursor:registerActionEvents()
    local _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_CONSTRUCTION_CURSOR_ROTATE, self , self.onRotate, false , false , true , false )
    self.rotateEventId = eventId

    g_inputBinding:setActionEventActive( self.rotateEventId, self.rotationEnabled)
    g_inputBinding:setActionEventTextPriority( self.rotateEventId, GS_PRIO_NORMAL)
end

```

### removeActionEvents

**Description**

> Remove action events registered for the cursor.

**Definition**

> removeActionEvents()

**Code**

```lua
function GuiTopDownCursor:removeActionEvents()
    self.rotateEventId = nil

    g_inputBinding:removeActionEventsByTarget( self )
end

```