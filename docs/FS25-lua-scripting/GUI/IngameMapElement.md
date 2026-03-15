## IngameMapElement

**Description**

> In-game map element.
> Controls input on the map in the in-game menu with objectives, vehicles, etc. The actual map rendering is deferred to
> the map component of the current mission. The map reference and terrain size must be set during mission
> initialization via the setIngameMap() and setTerrainSize() methods.

**Parent**

> [GuiElement](?version=script&category=43&class=466)

**Functions**

- [addCursorDeadzone](#addcursordeadzone)
- [checkAndResetMouse](#checkandresetmouse)
- [clearCursorDeadzones](#clearcursordeadzones)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getLocalPointerTarget](#getlocalpointertarget)
- [getLocalPosition](#getlocalposition)
- [isInputInDeadzones](#isinputindeadzones)
- [isPointVisible](#ispointvisible)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [localToWorldPos](#localtoworldpos)
- [mouseEvent](#mouseevent)
- [moveCenter](#movecenter)
- [new](#new)
- [onAccept](#onaccept)
- [onClickMap](#onclickmap)
- [onClose](#onclose)
- [onGuiSetupFinished](#onguisetupfinished)
- [onHorizontalCursorInput](#onhorizontalcursorinput)
- [onOpen](#onopen)
- [onPinchEvent](#onpinchevent)
- [onVerticalCursorInput](#onverticalcursorinput)
- [onZoomInput](#onzoominput)
- [panToHotspot](#pantohotspot)
- [registerActionEvents](#registeractionevents)
- [removeActionEvents](#removeactionevents)
- [reset](#reset)
- [resetFrameInputState](#resetframeinputstate)
- [selectHotspotAt](#selecthotspotat)
- [selectHotspotFrom](#selecthotspotfrom)
- [setIngameMap](#setingamemap)
- [setTerrainSize](#setterrainsize)
- [touchEvent](#touchevent)
- [update](#update)
- [updateCursor](#updatecursor)
- [zoom](#zoom)

### addCursorDeadzone

**Description**

> Add a dead zone wherein the map will not react to cursor inputs.
> Used this to designate areas where other controls should receive cursor input which would otherwise be used up by
> the map (e.g. in full-screen mode in the map overview screen in-game). The deadzones will also restrict cursor
> movement.

**Definition**

> addCursorDeadzone()

**Arguments**

| any | screenX |
|-----|---------|
| any | screenY |
| any | width   |
| any | height  |

**Code**

```lua
function IngameMapElement:addCursorDeadzone(screenX, screenY, width, height)
    table.insert( self.cursorDeadzones, { screenX, screenY, width, height } )
end

```

### checkAndResetMouse

**Description**

> Check if mouse input was active before a bound input was triggered and queue a reset of the mouse state for the next
> frame.
> Mouse input continuously sets the mouse input flag (self.useMouse) but does not receive any events when the mouse
> is inert. Therefore we need to set and reset the state each frame to make sure we can seamlessly switch between mouse
> and gamepad input on the map element while at the same time preventing any player bindings from interfering with the
> custom mouse input logic of this class.

**Definition**

> checkAndResetMouse()

**Code**

```lua
function IngameMapElement:checkAndResetMouse()
    local useMouse = self.useMouse
    if useMouse then
        self.resetMouseNextFrame = true
    end

    return useMouse
end

```

### clearCursorDeadzones

**Description**

> Clear cursor dead zones.

**Definition**

> clearCursorDeadzones()

**Code**

```lua
function IngameMapElement:clearCursorDeadzones()
    self.cursorDeadzones = { }
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
function IngameMapElement:copyAttributes(src)
    IngameMapElement:superClass().copyAttributes( self , src)

    self.mapZoom = src.mapZoom
    self.mapAlpha = src.mapAlpha
    self.cursorId = src.cursorId
    self.limitMapWidth = src.limitMapWidth
    self.limitCursorMovement = src.limitCursorMovement
    self.onDrawPreIngameMapCallback = src.onDrawPreIngameMapCallback
    self.onDrawPostIngameMapCallback = src.onDrawPostIngameMapCallback
    self.onDrawPostIngameMapHotspotsCallback = src.onDrawPostIngameMapHotspotsCallback
    self.onClickHotspotCallback = src.onClickHotspotCallback
    self.onClickMapCallback = src.onClickMapCallback
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function IngameMapElement:delete()
    GuiOverlay.deleteOverlay( self.overlay)
    self.ingameMap = nil

    IngameMapElement:superClass().delete( self )
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function IngameMapElement:draw(clipX1, clipY1, clipX2, clipY2)
    self:raiseCallback( "onDrawPreIngameMapCallback" , self , self.ingameMap)
    self.ingameMap:drawMapOnly()
    self:raiseCallback( "onDrawPostIngameMapCallback" , self , self.ingameMap)

    self.ingameMap:drawHotspotsOnly()

    self:raiseCallback( "onDrawPostIngameMapHotspotsCallback" , self , self.ingameMap)
    IngameMapElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
end

```

### getLocalPointerTarget

**Description**

**Definition**

> getLocalPointerTarget()

**Code**

```lua
function IngameMapElement:getLocalPointerTarget()
    if self.useMouse then
        return self:getLocalPosition( self.lastInputPosX[ self.lastInputIndex], self.lastInputPosY[ self.lastInputIndex])
    elseif self.cursorElement then
            local posX = self.cursorElement.absPosition[ 1 ] + self.cursorElement.size[ 1 ] * 0.5
            local posY = self.cursorElement.absPosition[ 2 ] + self.cursorElement.size[ 2 ] * 0.5

            return self:getLocalPosition(posX, posY)
        end

        return 0 , 0
    end

```

### getLocalPosition

**Description**

**Definition**

> getLocalPosition()

**Arguments**

| any | posX |
|-----|------|
| any | posY |

**Code**

```lua
function IngameMapElement:getLocalPosition(posX, posY)
    local width, height = self.ingameMap.fullScreenLayout:getMapSize()
    local offX, offY = self.ingameMap.fullScreenLayout:getMapPosition()

    -- offset with map poisition, then conver to 0-1 and adjust for minimap being doubled in size
        -- from actual map.
        local x, y

        if Platform.isMobile then
            x = (posX - offX) / width
            y = (posY - offY) / height
        else
                x = ((posX - offX) / width - 0.25 ) * 2
                y = ((posY - offY) / height - 0.25 ) * 2
            end

            return x, y
        end

```

### isInputInDeadzones

**Description**

> Check if a cursor position is within one of the stored deadzones.

**Definition**

> isInputInDeadzones()

**Arguments**

| any | inputScreenX |
|-----|--------------|
| any | inputScreenY |

**Code**

```lua
function IngameMapElement:isInputInDeadzones(inputScreenX, inputScreenY)
    for _, zone in pairs( self.cursorDeadzones) do
        if GuiUtils.checkOverlayOverlap(inputScreenX, inputScreenY, zone[ 1 ], zone[ 2 ], zone[ 3 ], zone[ 4 ]) then
            return true
        end
    end

    return false
end

```

### isPointVisible

**Description**

**Definition**

> isPointVisible()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function IngameMapElement:isPointVisible(x, z)
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
function IngameMapElement:loadFromXML(xmlFile, key)
    IngameMapElement:superClass().loadFromXML( self , xmlFile, key)

    self.cursorId = getXMLString(xmlFile, key .. "#cursorId" )
    self.mapAlpha = getXMLFloat(xmlFile, key .. "#mapAlpha" ) or self.mapAlpha
    self.limitMapWidth = Utils.getNoNil(getXMLBool(xmlFile, key .. "#limitMapWidth" ), self.limitMapWidth)
    self.limitCursorMovement = Utils.getNoNil(getXMLBool(xmlFile, key .. "#limitCursorMovement" ), self.limitCursorMovement)

    self:addCallback(xmlFile, key .. "#onDrawPreIngameMap" , "onDrawPreIngameMapCallback" )
    self:addCallback(xmlFile, key .. "#onDrawPostIngameMap" , "onDrawPostIngameMapCallback" )
    self:addCallback(xmlFile, key .. "#onDrawPostIngameMapHotspots" , "onDrawPostIngameMapHotspotsCallback" )
    self:addCallback(xmlFile, key .. "#onClickHotspot" , "onClickHotspotCallback" )
    self:addCallback(xmlFile, key .. "#onClickMap" , "onClickMapCallback" )
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
function IngameMapElement:loadProfile(profile, applyProfile)
    IngameMapElement:superClass().loadProfile( self , profile, applyProfile)

    self.mapAlpha = profile:getNumber( "mapAlpha" , self.mapAlpha)
    self.limitMapWidth = profile:getBool( "limitMapWidth" , self.limitMapWidth)
    self.limitCursorMovement = profile:getBool( "limitCursorMovement" , self.limitCursorMovement)
end

```

### localToWorldPos

**Description**

**Definition**

> localToWorldPos()

**Arguments**

| any | localPosX |
|-----|-----------|
| any | localPosY |

**Code**

```lua
function IngameMapElement:localToWorldPos(localPosX, localPosY)
    local worldPosX = localPosX * self.terrainSize
    local worldPosZ = - localPosY * self.terrainSize

    -- move world positions to range -1024 to 1024 on a 2k map
    worldPosX = worldPosX - self.terrainSize * 0.5
    worldPosZ = worldPosZ + self.terrainSize * 0.5

    return worldPosX, worldPosZ
end

```

### mouseEvent

**Description**

> Custom mouse event handling for the in-game map.
> Directly handles zoom, click and drag events on the map. See input events and IngameMapElement:checkAndResetMouse()
> for the state checking code required to bypass player mouse input bindings.

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
function IngameMapElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        eventUsed = IngameMapElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed)
        self.lastInputIndex = 0
        local index = 0

        if not GS_IS_CONSOLE_VERSION and(isDown or isUp or posX ~ = self.lastInputPosX[index] or posY ~ = self.lastInputPosY[index]) then
            self.useMouse = true

            if self.cursorElement then
                self.cursorElement:setVisible( false )
            end
            self.isCursorActive = false
        end

        -- On mobile we have touch input.Touch does not give us a position until there is a touch.
        -- This means on the first touch-begin, the lastMousePos is wrong and has a big offset.
        -- We set it when the touch begins so it becomes a drag action
        if Platform.isMobile and self.useMouse then
            if isDown then
                self.lastInputPosX[index] = posX
                self.lastInputPosY[index] = posY
            end
        end

        if not eventUsed then
            if isDown and button = = Input.MOUSE_BUTTON_LEFT and not self:isInputInDeadzones(posX, posY) then
                eventUsed = true
                if not self.inputDown then
                    self.inputDown = true
                end
            end
        end

        if self.inputDown and self.lastInputPosX[index] ~ = nil then
            local distX = self.lastInputPosX[index] - posX
            local distY = posY - self.lastInputPosY[index]

            if self.isFixedHorizontal then
                distX = 0
            end

            if math.abs(distX) > self.minDragDistanceX or math.abs(distY) > self.minDragDistanceY then
                local factorX = - distX
                local factorY = distY

                self:moveCenter(factorX, factorY)

                self.hasDragged = true
            end
        end

        if isUp and button = = Input.MOUSE_BUTTON_LEFT then
            if not eventUsed and self.inputDown and not self.hasDragged then
                local localX, localY = self:getLocalPosition(posX, posY)

                -- save state locally to avoid issues if activating/deactivating selection in the onClickMap callback
                    local isHotspotSelectionActive = self.isHotspotSelectionActive

                    self:onClickMap(localX, localY)

                    if isHotspotSelectionActive then
                        -- Trigger hot spot selection after map clicking because it's the more specific event
                        self:selectHotspotAt(posX, posY)
                    end

                    eventUsed = true
                end

                self.inputDown = false
                self.hasDragged = false
            end

            self.lastInputPosX[index] = posX
            self.lastInputPosY[index] = posY
        end

        return eventUsed
    end

```

### moveCenter

**Description**

> Move center of the map

**Definition**

> moveCenter()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function IngameMapElement:moveCenter(x, y)
    local width, height = self.ingameMap.fullScreenLayout:getMapSize()

    if Platform.isMobile then
        local maxCenterOffsetX = (width - self.ingameMap.fullScreenLayout.width) * 0.5
        local maxCenterOffsetY = (height - 1 ) * 0.5

        self.mapCenterX = math.clamp( self.mapCenterX + x, self.originalMapCenterX - maxCenterOffsetX, self.originalMapCenterX + maxCenterOffsetX)
        self.mapCenterY = math.clamp( self.mapCenterY + y, self.originalMapCenterY - maxCenterOffsetY, self.originalMapCenterY + maxCenterOffsetY)
    else
            self.mapCenterX = math.clamp( self.mapCenterX + x, width * - 0.5 + self.originalMapCenterX, width * 0.5 + self.originalMapCenterX)

            if self.limitCursorMovement then
                local minValue = ( self.absPosition[ 2 ] + self.absSize[ 2 ]) - height * 0.5
                local maxValue = self.absPosition[ 2 ] + height * 0.5
                self.mapCenterY = math.clamp( self.mapCenterY + y, minValue, maxValue)
            else
                    self.mapCenterY = math.clamp( self.mapCenterY + y, height * - 0.5 + self.originalMapCenterY, height * 0.5 + self.originalMapCenterY)
                end
            end

            self.ingameMap.fullScreenLayout:setMapCenter( self.mapCenterX, self.mapCenterY)
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
function IngameMapElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or IngameMapElement _mt)

    self.ingameMap = nil

    -- cursor
    self.cursorId = nil

    self.inputMode = GS_INPUT_HELP_MODE_GAMEPAD

    -- map attributes
    self.terrainSize = 0
    self.mapAlpha = 1
    self.zoomMin = 1
    self.zoomMax = 8
    self.zoomDefault = Platform.ingameMap.zoomDefault

    self.mapCenterX = 0.5
    self.mapCenterY = 0.5

    self.mapZoom = self.zoomDefault

    -- horizontal cursor input since last frame
    self.accumHorizontalInput = 0
    -- vertical cursor input since last frame
    self.accumVerticalInput = 0
    -- zoom input since last frame
    self.accumZoomInput = 0
    -- mouse input flag to override potential double binding on cursor movement
    self.useMouse = false
    -- reset flag for mouse input flag to avoid catching input in the current frame
        self.resetMouseNextFrame = false
        -- screen space rectangle definitions {x, y, w, h} where the cursor/mouse should not go and react to input
        self.cursorDeadzones = { }

        self.limitMapWidth = false
        self.limitCursorMovement = false
        self.mapMovementLocked = false

        self.zoomSpeedFactor = Platform.ingameMap.zoomSpeedFactor
        ---Minimum mouse movement distance in pixels before dragging is started.Used to distinguish between drags and clicks.
        self.dragStartDistance = Platform.ingameMap.dragStartDistance

        self.minDragDistanceX = self.dragStartDistance * g_pixelSizeX
        self.minDragDistanceY = self.dragStartDistance * g_pixelSizeY
        self.hasDragged = false -- drag state flag to avoid triggering a click event on a dragging mouse up

        self.minimalHotspotSize = getNormalizedScreenValues( 9 , 1 )

        self.isHotspotSelectionActive = true
        self.isCursorAvailable = true

        self.cursorOffsetX = 0
        self.cursorOffsetY = 0

        self.originalMapCenterX = 0.5
        self.originalMapCenterY = 0.5

        self.isPinching = false

        self.isTouchPickingRotation = false

        self.lastInputPosX = { }
        self.lastInputPosY = { }
        self.lastInputIndex = 0

        return self
    end

```

### onAccept

**Description**

> Event function for gamepad cursor accept input bound to InputAction.INGAMEMAP\_ACCEPT.

**Definition**

> onAccept()

**Code**

```lua
function IngameMapElement:onAccept()
    if self.cursorElement then
        local cursorElement = self.cursorElement
        local posX, posY = cursorElement.absPosition[ 1 ] + cursorElement.size[ 1 ] * 0.5 , cursorElement.absPosition[ 2 ] + cursorElement.size[ 2 ] * 0.5
        local localX, localY = self:getLocalPointerTarget()

        -- save state locally to avoid issues if activating/deactivating selection in the onClickMap callback
            local isHotspotSelectionActive = self.isHotspotSelectionActive

            self:onClickMap(localX, localY)

            if isHotspotSelectionActive then
                -- trigger hot spot selection after map clicking because it's the more specific event
                self:selectHotspotAt(posX, posY)
            end
        end
    end

```

### onClickMap

**Description**

**Definition**

> onClickMap()

**Arguments**

| any | localPosX |
|-----|-----------|
| any | localPosY |

**Code**

```lua
function IngameMapElement:onClickMap(localPosX, localPosY)
    local worldPosX, worldPosZ = self:localToWorldPos(localPosX, localPosY)

    self:raiseCallback( "onClickMapCallback" , self , worldPosX, worldPosZ)
end

```

### onClose

**Description**

**Definition**

> onClose()

**Code**

```lua
function IngameMapElement:onClose()
    IngameMapElement:superClass().onClose( self )

    self:removeActionEvents()

    self.ingameMap:setFullscreen( false )
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function IngameMapElement:onGuiSetupFinished()
    IngameMapElement:superClass().onGuiSetupFinished( self )

    if self.cursorId ~ = nil then
        if self.target[ self.cursorId] ~ = nil then
            self.cursorElement = self.target[ self.cursorId]
        else
                printWarning( "Warning:CursorId '" .. self.cursorId .. "' not found for '" .. self.target.name .. "'!" )
                end
            end
        end

```

### onHorizontalCursorInput

**Description**

> Event function for horizontal cursor input bound to InputAction.AXIS\_LOOK\_LEFTRIGHT\_VEHICLE.

**Definition**

> onHorizontalCursorInput()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function IngameMapElement:onHorizontalCursorInput(_, inputValue)
    if not self:checkAndResetMouse() and not self.isFixedHorizontal then
        self.accumHorizontalInput = self.accumHorizontalInput + inputValue

        if math.abs(inputValue) > 0.05 then
            g_inGameMenu.pageMapOverview.lastInputTime = g_ time
        end
    end
end

```

### onOpen

**Description**

**Definition**

> onOpen()

**Code**

```lua
function IngameMapElement:onOpen()
    IngameMapElement:superClass().onOpen( self )

    if self.cursorElement ~ = nil then
        self.cursorElement:setVisible( false )
    end
    self.isCursorActive = false

    if self.largestSize = = nil then
        self.largestSize = self.size
    end

    self.ingameMap:setFullscreen( true )

    if Platform.ingameMap.resetZoomOnOpen then
        self:zoom( 0 )
    end
end

```

### onPinchEvent

**Description**

> Event function for map zoom input triggered by pinching via touch input.

**Definition**

> onPinchEvent(float offset, pinchCenterX x, pinchCenterY y, float distance)

**Arguments**

| float        | offset   | offset between new distance and distance of last pinch event |
|--------------|----------|--------------------------------------------------------------|
| pinchCenterX | x        | position of the center point of the pinch                    |
| pinchCenterY | y        | position of the center point of the pinch                    |
| float        | distance | distance between both touch positions                        |

**Code**

```lua
function IngameMapElement:onPinchEvent(offset, pinchCenterX, pinchCenterY, distance)
    self.oldCursorX = self.cursorElement.absPosition[ 1 ]
    self.oldCursorY = self.cursorElement.absPosition[ 2 ]
    self.cursorElement.absPosition[ 1 ] = pinchCenterX
    self.cursorElement.absPosition[ 2 ] = pinchCenterY

    self.accumZoomInput = self.accumZoomInput + offset * 100

    self.isPinching = true
end

```

### onVerticalCursorInput

**Description**

> Event function for vertical cursor input bound to InputAction.AXIS\_LOOK\_UPDOWN\_VEHICLE.

**Definition**

> onVerticalCursorInput()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function IngameMapElement:onVerticalCursorInput(_, inputValue)
    if not self:checkAndResetMouse() then
        self.accumVerticalInput = self.accumVerticalInput + inputValue

        if math.abs(inputValue) > 0.05 then
            g_inGameMenu.pageMapOverview.lastInputTime = g_ time
        end
    end
end

```

### onZoomInput

**Description**

> Event function for map zoom input bound to InputAction.AXIS\_ACCELERATE\_VEHICLE and InputAction.AXIS\_BRAKE\_VEHICLE.

**Definition**

> onZoomInput(inputValue Zoom, direction Zoom, )

**Arguments**

| inputValue | Zoom      | input value                                      |
|------------|-----------|--------------------------------------------------|
| direction  | Zoom      | input sign value, 1 for zoom in, -1 for zoom out |
| any        | direction |                                                  |

**Code**

```lua
function IngameMapElement:onZoomInput(_, inputValue, direction)
    if not self:isInputInDeadzones(g_lastMousePosX, g_lastMousePosY) or not self.useMouse then
        self.accumZoomInput = self.accumZoomInput - direction * inputValue
    end
end

```

### panToHotspot

**Description**

> Pan to a hotpspot, if possible the hotspot will end up at the center of the screen, or if it is near the map border it
> will be centered as much as possible

**Definition**

> panToHotspot(hotspot the, )

**Arguments**

| hotspot | the          | hotspot that gets centered |
|---------|--------------|----------------------------|
| any     | extraOffsetX |                            |

**Code**

```lua
function IngameMapElement:panToHotspot(hotspot, extraOffsetX)
    if hotspot ~ = nil then
        if Platform.isMobile then
            local hotspotX, hotspotY = self:worldToScreenPos(hotspot:getWorldPosition())
            local cursorOffsetX = - hotspotX + self.mapCenterX + self.originalMapCenterX
            local cursorOffsetY = - hotspotY + self.mapCenterY + self.originalMapCenterY

            self.cursorOffsetX = cursorOffsetX - self.mapCenterX
            self.cursorOffsetY = cursorOffsetY - self.mapCenterY
        else
                local ingameMap = self.ingameMap
                local hotspotX, hotspotY = hotspot:getWorldPosition()
                local objectX = (hotspotX + ingameMap.worldCenterOffsetX) / ingameMap.worldSizeX * ingameMap.mapExtensionScaleFactor + ingameMap.mapExtensionOffsetX
                local objectZ = (hotspotY + ingameMap.worldCenterOffsetZ) / ingameMap.worldSizeZ * ingameMap.mapExtensionScaleFactor + ingameMap.mapExtensionOffsetZ
                hotspotX, hotspotY = ingameMap.layout:getMapObjectPosition(objectX, objectZ, 0 , 0 )

                local offsetX = self.originalMapCenterX - hotspotX
                local offsetY = self.originalMapCenterY - hotspotY
                self:moveCenter(offsetX, offsetY)
            end
        end
    end

```

### registerActionEvents

**Description**

> Register non-GUI input action events.

**Definition**

> registerActionEvents()

**Code**

```lua
function IngameMapElement:registerActionEvents()
    g_inputBinding:registerActionEvent(InputAction.AXIS_MAP_SCROLL_LEFT_RIGHT, self , self.onHorizontalCursorInput, false , false , true , true )
    g_inputBinding:registerActionEvent(InputAction.AXIS_MAP_SCROLL_UP_DOWN, self , self.onVerticalCursorInput, false , false , true , true )
    g_inputBinding:registerActionEvent(InputAction.INGAMEMAP_ACCEPT, self , self.onAccept, false , true , false , true )
    g_inputBinding:registerActionEvent(InputAction.AXIS_MAP_ZOOM_OUT, self , self.onZoomInput, false , false , true , true , - 1 ) -- -1 = = zoom out
    g_inputBinding:registerActionEvent(InputAction.AXIS_MAP_ZOOM_IN, self , self.onZoomInput, false , false , true , true , 1 ) -- 1 = = zoom in

    if g_touchHandler ~ = nil then
        self.touchListenerPinch = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_PINCH, self.onPinchEvent, self )
    end
end

```

### removeActionEvents

**Description**

> Remove non-GUI input action events.

**Definition**

> removeActionEvents()

**Code**

```lua
function IngameMapElement:removeActionEvents()
    g_inputBinding:removeActionEventsByTarget( self )

    if g_touchHandler ~ = nil then
        g_touchHandler:removeGestureListener( self.touchListenerPinch)
    end
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function IngameMapElement:reset()
    IngameMapElement:superClass().reset( self )

    self.mapCenterX = 0.5
    self.mapCenterY = 0.5
    self.mapZoom = self.zoomDefault

    -- self.ingameMap:resetSettings()
end

```

### resetFrameInputState

**Description**

**Definition**

> resetFrameInputState()

**Code**

```lua
function IngameMapElement:resetFrameInputState()
    self.accumZoomInput = 0
    self.accumHorizontalInput = 0
    self.accumVerticalInput = 0
    if self.resetMouseNextFrame then
        self.useMouse = false
        self.resetMouseNextFrame = false
    end

    if Platform.isMobile and self.isPinching then
        self.cursorElement.absPosition[ 1 ] = self.originalMapCenterX + self.cursorOffsetX
        self.cursorElement.absPosition[ 2 ] = self.originalMapCenterY + self.cursorOffsetY

        self.isPinching = false
    end
end

```

### selectHotspotAt

**Description**

**Definition**

> selectHotspotAt()

**Arguments**

| any | posX |
|-----|------|
| any | posY |

**Code**

```lua
function IngameMapElement:selectHotspotAt(posX, posY)
    if self.isHotspotSelectionActive then
        self.ingameMap:updateHotspotSorting()
        local sortedHotspots = self.ingameMap.hotspotsSorted

        if sortedHotspots ~ = nil then
            local playerHotspot = self:getPlayerHotspot(sortedHotspots[ true ])
            local prioritizePlayerHotspot = not Platform.isMobile or playerHotspot:getVehicle() ~ = nil

            if not self:selectHotspotFrom(sortedHotspots[prioritizePlayerHotspot], posX, posY) then
                if prioritizePlayerHotspot then
                    self:selectHotspotFrom(sortedHotspots[ false ], posX, posY)
                end
            end

            return
        end

        self:selectHotspotFrom( self.ingameMap.hotspots, posX, posY)
    end
end

```

### selectHotspotFrom

**Description**

**Definition**

> selectHotspotFrom()

**Arguments**

| any | hotspots |
|-----|----------|
| any | posX     |
| any | posY     |

**Code**

```lua
function IngameMapElement:selectHotspotFrom(hotspots, posX, posY)
    local minDistance = math.huge
    local minHotspot
    for i = #hotspots, 1 , - 1 do
        local hotspot = hotspots[i]

        if self.ingameMap.filter[hotspot:getCategory()] and hotspot:getIsVisible() then
            local isInRange, distance = hotspot:hasMouseOverlap(posX, posY)
            if isInRange then
                if minHotspot ~ = nil then
                    if hotspot:getSortingValue() < minHotspot:getSortingValue() then
                        if distance < minDistance then
                            minDistance = distance
                            minHotspot = hotspot
                        end
                    else
                            minDistance = distance
                            minHotspot = hotspot
                        end
                    else
                            minDistance = distance
                            minHotspot = hotspot
                        end
                    end
                end
            end

            if minHotspot ~ = nil then
                self:raiseCallback( "onClickHotspotCallback" , self , minHotspot)
                return true
            end

            return false
        end

```

### setIngameMap

**Description**

> Set the IngameMap reference to use for display.

**Definition**

> setIngameMap()

**Arguments**

| any | ingameMap |
|-----|-----------|

**Code**

```lua
function IngameMapElement:setIngameMap(ingameMap)
    self.ingameMap = ingameMap
    if self.limitMapWidth and self.ingameMap ~ = nil then
        self.ingameMap.fullScreenLayout:setMapWidth( self.absSize[ 1 ])
    end
end

```

### setTerrainSize

**Description**

> Set the current map's terrain size for map display.

**Definition**

> setTerrainSize()

**Arguments**

| any | terrainSize |
|-----|-------------|

**Code**

```lua
function IngameMapElement:setTerrainSize(terrainSize)
    self.terrainSize = terrainSize
end

```

### touchEvent

**Description**

> Custom touch event handling for the in-game map.
> Directly handles zoom, click and drag events on the map.

**Definition**

> touchEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | touchId   |
| any | eventUsed |

**Code**

```lua
function IngameMapElement:touchEvent(posX, posY, isDown, isUp, touchId, eventUsed)
    if self:getIsActive() then
        eventUsed = IngameMapElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, touchId, eventUsed)
        self.lastInputIndex = touchId

        if isDown or isUp or posX ~ = self.lastInputPosX[touchId] or posY ~ = self.lastInputPosY[touchId] then
            if self.cursorElement then
                self.cursorElement:setVisible( false )
            end
            self.isCursorActive = false
        end

        -- On mobile we have touch input.Touch does not give us a position until there is a touch.
        -- This means on the first touch-begin, the lastMousePos is wrong and has a big offset.
        -- We set it when the touch begins so it becomes a drag action
        if isDown then
            self.lastInputPosX[touchId] = posX
            self.lastInputPosY[touchId] = posY
        end

        if not eventUsed then
            if isDown and not self:isInputInDeadzones(posX, posY) then
                eventUsed = true
                if not self.inputDown then
                    self.inputDown = true
                end
            end
        end

        if self.inputDown and self.lastInputPosX[touchId] ~ = nil then
            local distX = self.lastInputPosX[touchId] - posX
            local distY = posY - self.lastInputPosY[touchId]

            if self.isFixedHorizontal then
                distX = 0
            end

            if self.isTouchPickingRotation then
                local aiButton = self.target.buttonConfirmAITarget
                local clickInButton = GuiUtils.checkOverlayOverlap(posX, posY, aiButton.absPosition[ 1 ], aiButton.absPosition[ 2 ], aiButton.size[ 1 ], aiButton.size[ 2 ])

                if not clickInButton then
                    local localX, localY = self:getLocalPosition(posX, posY)
                    self:onClickMap(localX, localY)
                end
            else
                    if math.abs(distX) > self.minDragDistanceX or math.abs(distY) > self.minDragDistanceY then
                        local factorX = - distX
                        local factorY = distY

                        self:moveCenter(factorX, factorY)

                        self.hasDragged = true
                    end
                end
            end

            if isUp then
                if not eventUsed and self.inputDown and not self.hasDragged then
                    local localX, localY = self:getLocalPosition(posX, posY)

                    -- save state locally to avoid issues if activating/deactivating selection in the onClickMap callback
                        local isHotspotSelectionActive = self.isHotspotSelectionActive

                        self:onClickMap(localX, localY)

                        if isHotspotSelectionActive then
                            -- Trigger hot spot selection after map clicking because it's the more specific event
                            self:selectHotspotAt(posX, posY)
                        end

                        eventUsed = true
                    end

                    self.inputDown = false
                    self.hasDragged = false
                end

                self.lastInputPosX[touchId] = posX
                self.lastInputPosY[touchId] = posY
            end

            return eventUsed
        end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function IngameMapElement:update(dt)
    IngameMapElement:superClass().update( self , dt)

    self.inputMode = g_inputBinding:getLastInputMode()

    if not g_gui:getIsDialogVisible() then
        if not self.alreadyClosed then
            local zoomFactor = self.accumZoomInput
            if not self.isPinching then
                zoomFactor = math.clamp(zoomFactor, - 1 , 1 )
            end

            if zoomFactor ~ = 0 then
                self:zoom(zoomFactor * - 0.015 * dt)
            end

            if self.cursorElement ~ = nil then
                self.isCursorActive = self.inputMode = = GS_INPUT_HELP_MODE_GAMEPAD
                self.cursorElement:setVisible( self.isCursorAvailable and self.isCursorActive)
                self:updateCursor( self.accumHorizontalInput, - self.accumVerticalInput, dt)
                self.useMouse = false
            end
        end
    end

    self:resetFrameInputState()
end

```

### updateCursor

**Description**

**Definition**

> updateCursor()

**Arguments**

| any | deltaX |
|-----|--------|
| any | deltaY |
| any | dt     |

**Code**

```lua
function IngameMapElement:updateCursor(deltaX, deltaY, dt)
    if self.cursorElement ~ = nil then
        local speed = IngameMapElement.CURSOR_SPEED_FACTOR

        local diffX = deltaX * speed * dt / g_screenAspectRatio
        local diffY = deltaY * speed * dt

        if Platform.isMobile or self.mapMovementLocked then
            diffX = diffX - self.cursorOffsetX
            diffY = diffY - self.cursorOffsetY

            local oldX = self.mapCenterX
            local oldY = self.mapCenterY

            if not self.mapMovementLocked then
                self:moveCenter( - diffX, - diffY)
            end

            local newX = self.mapCenterX
            local newY = self.mapCenterY

            local cursorSize = self.cursorElement.absSize
            local _, width = self.ingameMap.fullScreenLayout:getMapSize()

            self.cursorOffsetX = oldX - newX - diffX
            self.cursorOffsetX = math.max( math.min( self.cursorOffsetX, width * 0.5 - cursorSize[ 1 ] * 0.5 ), - width * 0.5 + cursorSize[ 1 ] * 0.5 )
            self.cursorOffsetY = oldY - newY - diffY
            self.cursorOffsetY = math.max( math.min( self.cursorOffsetY, 0.5 - cursorSize[ 2 ] * 0.5 ), - 0.5 + cursorSize[ 2 ] * 0.5 )

            if not Platform.isMobile and self.mapMovementLocked then
                local maxOffset = 250
                self.cursorOffsetX = math.clamp( self.cursorOffsetX, - maxOffset * g_pixelSizeScaledX, maxOffset * g_pixelSizeScaledX)
                self.cursorOffsetY = math.clamp( self.cursorOffsetY, - maxOffset * g_pixelSizeScaledY, maxOffset * g_pixelSizeScaledY)
            end

            local cursor = self.cursorElement

            cursor.absPosition[ 1 ] = self.originalMapCenterX - self.cursorOffsetX - cursor.absSize[ 1 ] * 0.5
            cursor.absPosition[ 2 ] = self.originalMapCenterY - self.cursorOffsetY - cursor.absSize[ 2 ] * 0.5
        else
                self:moveCenter( - diffX, - diffY)
            end
        end
    end

```

### zoom

**Description**

**Definition**

> zoom(zoomTarget if, )

**Arguments**

| zoomTarget | if         | set, instead of zooming with predefined speed, map will instantly zoom in to that zoom level |
|------------|------------|----------------------------------------------------------------------------------------------|
| any        | zoomTarget |                                                                                              |

**Code**

```lua
function IngameMapElement:zoom(direction, zoomTarget)
    -- No zooming if plaform does not support it
        if not Platform.ingameMap.canZoom then
            return
        end

        -- Find the location pointed at by the cursor so we can zoom towards it
        local targetX, targetZ = self:localToWorldPos( self:getLocalPointerTarget())

        local width, height = self.ingameMap.fullScreenLayout:getMapSize()

        -- Zoom by a set factor, or instantly to specified level if zoomTarget is set
            local oldZoom = self.mapZoom
            local speed = self.zoomSpeedFactor * direction * width -- multiply by size to mimic a constant scroll

            if zoomTarget ~ = nil then
                self.mapZoom = math.clamp(zoomTarget, self.zoomMin, self.zoomMax)
            else
                    self.mapZoom = math.clamp( self.mapZoom + speed, self.zoomMin, self.zoomMax)
                end

                self.ingameMap.fullScreenLayout:setMapZoom( self.mapZoom)

                -- Size depends on zoom, center bounds depend on size.So clamp the center
                self:moveCenter( 0 , 0 )

                -- Do not change focus position if we did not change zoom
                    if oldZoom ~ = self.mapZoom then
                        -- Find the location the mouseis pointing at now
                        local newTargetX, newTargetZ = self:localToWorldPos( self:getLocalPointerTarget())

                        -- Above location is wrong.We want it to point at the same location as before, so find the different for moving
                            local diffX, diffZ = newTargetX - targetX, newTargetZ - targetZ

                            -- The diff is in world coordinates.Transform it to screenspace.
                            local dx, dy = diffX / self.terrainSize * 0.5 * width, - diffZ / self.terrainSize * 0.5 * height

                            self.cursorOffsetX = self.cursorOffsetX + dx
                            self.cursorOffsetY = self.cursorOffsetY + dy

                            local mapLayout = self.ingameMap.fullScreenLayout

                            local centerX, centerY = mapLayout.mapCenterX, mapLayout.mapCenterY

                            self:moveCenter(dx, dy)

                            local newCenterX, newCenterY = mapLayout.mapCenterX, mapLayout.mapCenterY

                            if direction < 0 then
                                self.cursorOffsetX = self.cursorOffsetX - newCenterX + centerX + dx
                                self.cursorOffsetY = self.cursorOffsetY - newCenterY + centerY + dy
                            end
                        end
                    end

```