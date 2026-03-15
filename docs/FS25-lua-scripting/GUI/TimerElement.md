## TimerElement

**Description**

> Timer element for a clock-like display.
> Used layers: "image" for a foreground image, "bgImage" for a background image, "valueImage" for a value display,
> "markerImage" for a marker display.
> TODO: This element is not in use. Do we need to retain the code?

**Parent**

> [GuiElement](?version=script&category=43&class=506)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setValue](#setvalue)
- [updateUVs](#updateuvs)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function TimerElement:copyAttributes(src)
    TimerElement:superClass().copyAttributes( self , src)

    self.timerSize = { src.timerSize[ 1 ], src.timerSize[ 2 ] }
    self.markerSize = { src.markerSize[ 1 ], src.markerSize[ 2 ] }
    self.timerOffset = { src.timerOffset[ 1 ], src.timerOffset[ 2 ] }
    self.radius = { src.radius[ 1 ], src.radius[ 2 ] }
    self.value = src.value

    GuiOverlay.copyOverlay( self.overlayFront, src.overlayFront)
    GuiOverlay.copyOverlay( self.overlayBackground1, src.overlayBackground1)
    GuiOverlay.copyOverlay( self.overlayBackground2, src.overlayBackground2)
    GuiOverlay.copyOverlay( self.overlayValue1, src.overlayValue1)
    GuiOverlay.copyOverlay( self.overlayValue2, src.overlayValue2)
    GuiOverlay.copyOverlay( self.overlayMarker, src.overlayMarker)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function TimerElement:delete()
    GuiOverlay.deleteOverlay( self.overlayFront)
    GuiOverlay.deleteOverlay( self.overlayBackground1)
    GuiOverlay.deleteOverlay( self.overlayBackground2)
    GuiOverlay.deleteOverlay( self.overlayValue1)
    GuiOverlay.deleteOverlay( self.overlayValue2)
    GuiOverlay.deleteOverlay( self.overlayMarker)
    TimerElement:superClass().delete( self )
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
function TimerElement:draw(clipX1, clipY1, clipX2, clipY2)
    TimerElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)

    local state = GuiOverlay.STATE_NORMAL
    if self.disabled then
        state = GuiOverlay.STATE_DISABLED
    end

    if self.value > 0.5 then
        GuiOverlay.renderOverlay( self.overlayBackground2, self.absPosition[ 1 ] + self.timerOffset[ 1 ], self.absPosition[ 2 ] + self.timerOffset[ 2 ], self.timerSize[ 1 ], self.timerSize[ 2 ], state)
    end
    GuiOverlay.renderOverlay( self.overlayValue1, self.absPosition[ 1 ] + self.timerOffset[ 1 ], self.absPosition[ 2 ] + self.timerOffset[ 2 ], self.timerSize[ 1 ], self.timerSize[ 2 ], state)

    if self.value > 0.5 then
        GuiOverlay.renderOverlay( self.overlayValue2, self.absPosition[ 1 ] + self.timerOffset[ 1 ], self.absPosition[ 2 ] + self.timerOffset[ 2 ], self.timerSize[ 1 ], self.timerSize[ 2 ], state)
    else
            GuiOverlay.renderOverlay( self.overlayBackground2, self.absPosition[ 1 ] + self.timerOffset[ 1 ], self.absPosition[ 2 ] + self.timerOffset[ 2 ], self.timerSize[ 1 ], self.timerSize[ 2 ], state)
            GuiOverlay.renderOverlay( self.overlayBackground1, self.absPosition[ 1 ] + self.timerOffset[ 1 ], self.absPosition[ 2 ] + self.timerOffset[ 2 ], self.timerSize[ 1 ], self.timerSize[ 2 ], state)
        end
        GuiOverlay.renderOverlay( self.overlayFront, self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ], state)

        local markerPosX = math.cos( math.rad((( 1 - self.value) * 360 ) + 90 )) * self.radius[ 1 ]
        local markerPosY = math.sin( math.rad((( 1 - self.value) * 360 ) + 90 )) * self.radius[ 2 ]
        GuiOverlay.renderOverlay( self.overlayMarker, self.absPosition[ 1 ] + self.size[ 1 ] / 2 - self.markerSize[ 1 ] / 2 + markerPosX, self.absPosition[ 2 ] + self.size[ 2 ] / 2 - self.markerSize[ 2 ] / 2 + markerPosY, self.markerSize[ 1 ], self.markerSize[ 2 ], state)
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
function TimerElement:loadFromXML(xmlFile, key)
    TimerElement:superClass().loadFromXML( self , xmlFile, key)

    GuiOverlay.loadOverlay( self , self.overlayFront, "image" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.overlayBackground1, "bgImage" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.overlayBackground2, "bgImage" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.overlayValue1, "valueImage" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.overlayValue2, "valueImage" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.overlayMarker, "markerImage" , self.imageSize, nil , xmlFile, key)

    self.timerSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#timerSize" ), self.timerSize)
    self.markerSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#markerSize" ), self.markerSize)
    self.value = Utils.getNoNil(getXMLFloat(xmlFile, key .. "#value" ), self.value)

    local radius = getXMLString(xmlFile, key .. "#radius" )
    if radius ~ = nil then
        self.radius = GuiUtils.getNormalizedScreenValues(radius .. " " .. radius, self.radius)
    end

    GuiOverlay.createOverlay( self.overlayFront)
    GuiOverlay.createOverlay( self.overlayBackground1)
    GuiOverlay.createOverlay( self.overlayBackground2)
    GuiOverlay.createOverlay( self.overlayValue1)
    GuiOverlay.createOverlay( self.overlayValue2)
    GuiOverlay.createOverlay( self.overlayMarker)

    self:updateUVs( self.overlayValue2, math.rad( 180 ))
    self:setValue( self.value)
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
function TimerElement:loadProfile(profile, applyProfile)
    TimerElement:superClass().loadProfile( self , profile, applyProfile)

    GuiOverlay.loadOverlay( self , self.overlayFront, "image" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.overlayBackground1, "bgImage" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.overlayBackground2, "bgImage" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.overlayValue1, "valueImage" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.overlayValue2, "valueImage" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.overlayMarker, "markerImage" , self.imageSize, profile, nil , nil )

    self.timerSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "timerSize" ), self.timerSize)
    self.markerSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "markerSize" ), self.markerSize)
    self.value = profile:getNumber( "value" , self.value)

    local radius = profile:getValue( "radius" )
    if radius ~ = nil then
        self.radius = GuiUtils.getNormalizedScreenValues(radius .. " " .. radius, self.outputSize)
    end
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
function TimerElement.new(target, custom_mt)
    if custom_mt = = nil then
        custom_mt = TimerElement _mt
    end
    local self = GuiElement.new(target, custom_mt)

    self.value = 0
    self.timerSize = { 1 , 1 }
    self.markerSize = { 1 , 1 }
    self.radius = 1
    self.timerOffset = nil

    self.overlayFront = { }
    self.overlayBackground1 = { }
    self.overlayBackground2 = { }
    self.overlayValue1 = { }
    self.overlayValue2 = { }
    self.overlayMarker = { }

    return self
end

```

### setValue

**Description**

**Definition**

> setValue()

**Arguments**

| any | newValue |
|-----|----------|

**Code**

```lua
function TimerElement:setValue(newValue)
    self.value = math.clamp(newValue, 0 , 1 )
    self:updateUVs( self.overlayValue1, math.rad((( 1 - self.value) * 360 )))
    self:updateUVs( self.overlayBackground1, math.rad( 180 + ( - self.value * 360 )))
end

```

### updateUVs

**Description**

**Definition**

> updateUVs()

**Arguments**

| any | overlay  |
|-----|----------|
| any | rotation |

**Code**

```lua
function TimerElement:updateUVs(overlay, rotation)
    local uvs = GuiOverlay.getOverlayUVs(overlay)
    uvs[ 1 ] = - 0.5 * math.cos( - rotation) + 0.5 * math.sin( - rotation) + 0.5
    uvs[ 2 ] = - 0.5 * math.sin( - rotation) - 0.5 * math.cos( - rotation) + 0.5
    uvs[ 3 ] = - 0.5 * math.cos( - rotation) - 0.5 * math.sin( - rotation) + 0.5
    uvs[ 4 ] = - 0.5 * math.sin( - rotation) + 0.5 * math.cos( - rotation) + 0.5
    uvs[ 5 ] = 0.5 * math.cos( - rotation) + 0.5 * math.sin( - rotation) + 0.5
    uvs[ 6 ] = 0.5 * math.sin( - rotation) - 0.5 * math.cos( - rotation) + 0.5
    uvs[ 7 ] = 0.5 * math.cos( - rotation) - 0.5 * math.sin( - rotation) + 0.5
    uvs[ 8 ] = 0.5 * math.sin( - rotation) + 0.5 * math.cos( - rotation) + 0.5
end

```