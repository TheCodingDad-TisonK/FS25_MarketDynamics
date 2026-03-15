## IngameMap

**Description**

> In-game map display element.
> This class is used to display the game map both in the HUD as well as in the in-game menu.

**Parent**

> [HUDElement](?version=script&category=43&class=465)

**Functions**

- [addMapHotspot](#addmaphotspot)
- [createBackground](#createbackground)
- [createComponents](#createcomponents)
- [createToggleMapSizeGlyph](#createtogglemapsizeglyph)
- [delete](#delete)
- [drawHotspot](#drawhotspot)
- [drawLatencyToServer](#drawlatencytoserver)
- [drawPlayersCoordinates](#drawplayerscoordinates)
- [getBackgroundPosition](#getbackgroundposition)
- [loadMap](#loadmap)
- [new](#new)
- [removeMapHotspot](#removemaphotspot)
- [resetSettings](#resetsettings)
- [setAllowToggle](#setallowtoggle)
- [setFullscreen](#setfullscreen)
- [setScale](#setscale)
- [setSelectedHotspot](#setselectedhotspot)
- [setWorldSize](#setworldsize)
- [storeScaledValues](#storescaledvalues)
- [toggleSize](#togglesize)

### addMapHotspot

**Description**

**Definition**

> addMapHotspot()

**Arguments**

| any | mapHotspot |
|-----|------------|

**Code**

```lua
function IngameMap:addMapHotspot(mapHotspot)
    table.addElement( self.hotspots, mapHotspot)

    self:sortHotspots()

    self:resetHotspotSorting()

    mapHotspot:addRenderStateChangedListener( self )

    return mapHotspot
end

```

### createBackground

**Description**

> Create the empty background overlay.

**Definition**

> createBackground()

**Code**

```lua
function IngameMap:createBackground()
    local width, height = getNormalizedScreenValues( unpack( IngameMap.SIZE.SELF))
    local posX, posY = self:getBackgroundPosition()

    local overlay = g_overlayManager:createOverlay( IngameMap.SLICE_IDS.BACKGROUND_ROUND, posX, posY, width, height)
    overlay:setColor( 0 , 0 , 0 , 0.75 )

    return overlay
end

```

### createComponents

**Description**

> Create required display components.

**Definition**

> createComponents()

**Code**

```lua
function IngameMap:createComponents()
    local baseX, baseY = self:getPosition()
    local width, height = self:getWidth(), self:getHeight()

    self:createToggleMapSizeGlyph(baseX, baseY, width, height)
end

```

### createToggleMapSizeGlyph

**Description**

> Create the input glyph for map size toggling.

**Definition**

> createToggleMapSizeGlyph()

**Arguments**

| any | baseX      |
|-----|------------|
| any | baseY      |
| any | baseWidth  |
| any | baseHeight |

**Code**

```lua
function IngameMap:createToggleMapSizeGlyph(baseX, baseY, baseWidth, baseHeight)
    local width, height = getNormalizedScreenValues( unpack( IngameMap.SIZE.INPUT_ICON))
    local offX, offY = getNormalizedScreenValues( unpack( IngameMap.POSITION.INPUT_ICON))

    local element = InputGlyphElement.new(g_inputDisplayManager, width, height)
    local posX, posY = baseX + offX, baseY + offY

    element:setPosition(posX, posY)
    element:setKeyboardGlyphColor( IngameMap.COLOR.INPUT_ICON)
    element:setAction(InputAction.TOGGLE_MAP_SIZE)

    self.toggleMapSizeGlyph = element
    self:addChild(element)
end

```

### delete

**Description**

> Delete this element and all of its components.

**Definition**

> delete()

**Code**

```lua
function IngameMap:delete()
    g_inputBinding:removeActionEventsByTarget( self )

    self.mapElement:delete()
    self:setSelectedHotspot( nil )

    for _, layout in ipairs( self.layouts) do
        layout:delete()
    end

    IngameMap:superClass().delete( self )
end

```

### drawHotspot

**Description**

> Draw a single hotspot on the map.

**Definition**

> drawHotspot()

**Arguments**

| any | hotspot      |
|-----|--------------|
| any | smallVersion |
| any | scale        |
| any | doDebug      |

**Code**

```lua
function IngameMap:drawHotspot(hotspot, smallVersion, scale, doDebug)
    if hotspot = = nil then
        return
    end

    local layout = self.layout
    local worldX, worldZ = hotspot:getWorldPosition()
    local rotation = hotspot:getWorldRotation()

    local objectX = (worldX + self.worldCenterOffsetX) / self.worldSizeX * self.mapExtensionScaleFactor + self.mapExtensionOffsetX
    local objectZ = (worldZ + self.worldCenterOffsetZ) / self.worldSizeZ * self.mapExtensionScaleFactor + self.mapExtensionOffsetZ

    if hotspot.scale ~ = scale then
        hotspot:setScale(scale)
    end

    local width, height = hotspot:getDimension()
    local x, y, yRot, visible = layout:getMapObjectPosition(objectX, objectZ, width, height, rotation, hotspot:getIsPersistent())

    if not visible then
        return
    end

    -- extra clipping for mobile version
        if self.clipHotspots and self.clipX1 ~ = nil then
            if x < self.clipX1 or(x + width) > self.clipX2 or y < self.clipY1 or(y + height) > self.clipY2 then
                return
            end
        end

        hotspot.lastScreenPositionX = x
        hotspot.lastScreenPositionY = y
        hotspot.lastScreenRotation = yRot
        hotspot.lastScreenLayout = layout

        hotspot:render(x, y, yRot, smallVersion)
    end

```

### drawLatencyToServer

**Description**

> Draw current latency to server as text.

**Definition**

> drawLatencyToServer()

**Code**

```lua
function IngameMap:drawLatencyToServer()
    local missionDynamicInfo = g_currentMission.missionDynamicInfo
    if g_client ~ = nil and g_client.currentLatency ~ = nil and missionDynamicInfo.isMultiplayer and missionDynamicInfo.isClient then
        local color
        if g_client.currentLatency < = 50 then
            color = IngameMap.COLOR.LATENCY_GOOD
        elseif g_client.currentLatency < 100 then
                color = IngameMap.COLOR.LATENCY_MEDIUM
            else
                    color = IngameMap.COLOR.LATENCY_BAD
                end

                self.layout:drawLatency( string.format( "%dms" , math.max(g_client.currentLatency, 10 )), color)
            end
        end

```

### drawPlayersCoordinates

**Description**

> Draw the player's current coordinates as text.

**Definition**

> drawPlayersCoordinates()

**Code**

```lua
function IngameMap:drawPlayersCoordinates()
    local rotation = math.deg( math.abs( self.playerRotation - math.pi))
    local renderString = string.format( "%.1f°, %d, %d" , rotation, self.normalizedPlayerPosX * self.worldSizeX, self.normalizedPlayerPosZ * self.worldSizeZ)

    self.layout:drawCoordinates(renderString)
end

```

### getBackgroundPosition

**Description**

> Get the base position of the entire element.

**Definition**

> getBackgroundPosition()

**Code**

```lua
function IngameMap:getBackgroundPosition()
    return g_safeFrameOffsetX, g_safeFrameOffsetY
end

```

### loadMap

**Description**

**Definition**

> loadMap()

**Arguments**

| any | filename        |
|-----|-----------------|
| any | worldSizeX      |
| any | worldSizeZ      |
| any | fieldColor      |
| any | grassFieldColor |

**Code**

```lua
function IngameMap:loadMap(filename, worldSizeX, worldSizeZ, fieldColor, grassFieldColor)
    self.mapElement:delete() -- will also delete the wrapped Overlay

    self:setWorldSize(worldSizeX, worldSizeZ)

    self.mapOverlay = Overlay.new(filename, 0 , 0 , 1 , 1 )

    self.mapElement = HUDElement.new( self.mapOverlay)
    self:addChild( self.mapElement)

    self:setScale( self.uiScale)
end

```

### new

**Description**

> Create a new instance of IngameMap.

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt | custom meta table |
|--------|----------|-------------------|

**Return Values**

| table? | self | IngameMap instance |
|--------|------|--------------------|

**Code**

```lua
function IngameMap.new(customMt)
    local self = IngameMap:superClass().new( nil , nil , customMt or IngameMap _mt)
    self.overlay = self:createBackground()

    self.uiScale = 1.0

    self.isVisible = true
    self.clipHotspots = false

    self.fullScreenLayout = IngameMapLayoutFullscreen.new()
    self.layouts = {
    IngameMapLayoutNone.new(),
    IngameMapLayoutCircle.new(),
    IngameMapLayoutSquare.new(),
    IngameMapLayoutSquareLarge.new(),
    self.fullScreenLayout,
    }
    self.state = 1
    self.numToggleStates = 4
    self.layout = self.layouts[ self.state]

    self.mapOverlay = Overlay.new( nil , 0 , 0 , 1 , 1 ) -- null-object, obsoletes defensive checks
    self.mapElement = HUDElement.new( self.mapOverlay) -- null-object

    self:createComponents()
    for _, layout in ipairs( self.layouts) do
        layout:createComponents( self )
    end

    local function setDefaultValue(filter, category)
        filter[category] = not Utils.isBitSet(g_gameSettings:getValue(GameSettings.SETTING.INGAME_MAP_FILTER), category)
    end

    self.filter = { }
    setDefaultValue( self.filter, MapHotspot.CATEGORY_FIELD)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_ANIMAL)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_MISSION)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_TOUR)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_STEERABLE)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_COMBINE)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_TRAILER)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_TOOL)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_UNLOADING)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_LOADING)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_PRODUCTION)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_OTHER)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_SHOP)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_AI)
    setDefaultValue( self.filter, MapHotspot.CATEGORY_PLAYER)

    self.currentFilter = self.filter

    self:setWorldSize( 2048 , 2048 )

    self.hotspots = { }
    self.selectedHotspot = nil

    self.mapExtensionOffsetX = 0.25
    self.mapExtensionOffsetZ = 0.25
    self.mapExtensionScaleFactor = 0.5

    self.allowToggle = true

    self.hotspotsDirty = true
    self.hotspotsRegular = { }
    self.hotspotsRenderLast = { }
    self.hotspotsPersistent = { }
    self.hotspotsPersistentRenderLast = { }
    self.hotspotsPostUpdate = { }

    self.topDownCamera = nil -- set by screen views which use a top down view, used for map position update

        return self
    end

```

### removeMapHotspot

**Description**

**Definition**

> removeMapHotspot()

**Arguments**

| any | mapHotspot |
|-----|------------|

**Code**

```lua
function IngameMap:removeMapHotspot(mapHotspot)
    if mapHotspot ~ = nil then
        table.removeElement( self.hotspots, mapHotspot)

        if self.selectedHotspot = = mapHotspot then
            self:setSelectedHotspot( nil )
        end

        if g_currentMission ~ = nil then
            if g_currentMission.currentMapTargetHotspot = = mapHotspot then
                g_currentMission:setMapTargetHotspot( nil )
            end
        end

        mapHotspot:removeRenderStateChangedListener( self )

        self:resetHotspotSorting()
    end
end

```

### resetSettings

**Description**

**Definition**

> resetSettings()

**Code**

```lua
function IngameMap:resetSettings()
    if self.overlay = = nil then
        return -- instance has been deleted, ignore reset
    end

    -- self:setScale(self.uiScale) -- resets scaled values

    -- local baseX, baseY = self:getBackgroundPosition()
    -- self:setPosition(baseX + self.mapOffsetX, baseY + self.mapOffsetY)
    -- self:setSize(self.mapWidth, self.mapHeight)

    self:setSelectedHotspot( nil )
end

```

### setAllowToggle

**Description**

**Definition**

> setAllowToggle()

**Arguments**

| any | isAllowed |
|-----|-----------|

**Code**

```lua
function IngameMap:setAllowToggle(isAllowed)
    self.allowToggle = isAllowed
end

```

### setFullscreen

**Description**

> Set full-screen mode (for map overview) without affecting the mini-map state.

**Definition**

> setFullscreen()

**Arguments**

| any | isFullscreen |
|-----|--------------|

**Code**

```lua
function IngameMap:setFullscreen(isFullscreen)
    if self.isFullscreen = = isFullscreen then
        return
    end

    self.isFullscreen = isFullscreen

    local newLayout = self.layouts[ self.state]
    if isFullscreen then
        newLayout = self.fullScreenLayout
    end

    self:setLayout(newLayout)
end

```

### setScale

**Description**

> Set this element's scale.

**Definition**

> setScale(float uiScale)

**Arguments**

| float | uiScale | Current UI scale applied to both width and height of elements |
|-------|---------|---------------------------------------------------------------|

**Code**

```lua
function IngameMap:setScale(uiScale)
    IngameMap:superClass().setScale( self , uiScale, uiScale)
    self.uiScale = uiScale

    self:storeScaledValues(uiScale)
end

```

### setSelectedHotspot

**Description**

**Definition**

> setSelectedHotspot()

**Arguments**

| any | hotspot |
|-----|---------|

**Code**

```lua
function IngameMap:setSelectedHotspot(hotspot)
    if self.selectedHotspot ~ = nil then
        self.selectedHotspot:setSelected( false )
    end
    self.selectedHotspot = hotspot
    if self.selectedHotspot ~ = nil then
        self.selectedHotspot:setSelected( true )
    end
end

```

### setWorldSize

**Description**

**Definition**

> setWorldSize()

**Arguments**

| any | worldSizeX |
|-----|------------|
| any | worldSizeZ |

**Code**

```lua
function IngameMap:setWorldSize(worldSizeX, worldSizeZ)
    self.worldSizeX = worldSizeX
    self.worldSizeZ = worldSizeZ
    self.worldCenterOffsetX = self.worldSizeX * 0.5
    self.worldCenterOffsetZ = self.worldSizeZ * 0.5

    for _, layout in ipairs( self.layouts) do
        layout:setWorldSize(worldSizeX, worldSizeZ)
    end
end

```

### storeScaledValues

**Description**

> Store scaled positioning, size and offset values.

**Definition**

> storeScaledValues()

**Arguments**

| any | uiScale |
|-----|---------|

**Code**

```lua
function IngameMap:storeScaledValues(uiScale)
    for _, layout in ipairs( self.layouts) do
        layout:storeScaledValues( self , uiScale)
    end

    self.helpAnchorOffsetX, self.helpAnchorOffsetY = self:scalePixelValuesToScreenVector( 0 , 15 )
end

```

### toggleSize

**Description**

**Definition**

> toggleSize()

**Arguments**

| any | state |
|-----|-------|
| any | force |

**Code**

```lua
function IngameMap:toggleSize(state, force)
    --#profile RemoteProfiler.zoneBeginN("IngameMap_toggleSize")

    if state ~ = nil then
        self.state = math.max( math.min(state, self.numToggleStates), 1 )
    else
            self.state = ( self.state % self.numToggleStates) + 1
        end
        g_gameSettings:setValue( "ingameMapState" , self.state)

        self:setLayout( self.layouts[ self.state])

        --#profile RemoteProfiler.zoneEnd()
    end

```