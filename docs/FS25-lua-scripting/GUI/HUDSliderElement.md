## HUDSliderElement

**Description**

> Slider Element
> Slider for touch devices
> Creates a touch area from an overlay which is slideable

**Parent**

> [HUDElement](?version=script&category=43&class=456)

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of FrameElement.

**Definition**

> new(float posX, float posY, float width, float height, table? parent, , , , , )

**Arguments**

| float  | posX        | Initial X position in screen space                                              |
|--------|-------------|---------------------------------------------------------------------------------|
| float  | posY        | Initial Y position in screen space                                              |
| float  | width       | Frame width in screen space                                                     |
| float  | height      | Frame height in screen space                                                    |
| table? | parent      | [optional] Parent HUDElement which will receive this frame as its child element |
| any    | transAxis   |                                                                                 |
| any    | minTrans    |                                                                                 |
| any    | centerTrans |                                                                                 |
| any    | maxTrans    |                                                                                 |
| any    | lockTrans   |                                                                                 |

**Code**

```lua
function HUDSliderElement.new(overlay, backgroundOverlay, touchAreaOffsetX, touchAreaOffsetY, touchAreaPressedGain, transAxis, minTrans, centerTrans, maxTrans, lockTrans)
    local self = HUDSliderElement:superClass().new(overlay, nil , HUDSliderElement _mt)

    self.position = { overlay.x, overlay.y }
    self.size = { overlay.width, overlay.height }
    self.transAxis = transAxis
    self.minTrans = minTrans
    self.centerTrans = centerTrans
    self.maxTrans = maxTrans
    self.lockTrans = lockTrans
    self.speed = 0.0002

    self.backgroundOverlay = backgroundOverlay
    self.overlay = overlay

    self.moveToCenterPosition = false
    self.moveToCenterSpeedFactor = 1

    self.snapPositions = { }

    self.touchAreaDown = g_touchHandler:registerTouchAreaOverlay(backgroundOverlay, touchAreaOffsetX, touchAreaOffsetY, TouchHandler.TRIGGER_DOWN, self.onSliderDown, self )
    self.touchAreaAlways = g_touchHandler:registerTouchAreaOverlay(backgroundOverlay, touchAreaOffsetX, touchAreaOffsetY, TouchHandler.TRIGGER_ALWAYS, self.onSliderAlways, self )
    self.touchAreaUp = g_touchHandler:registerTouchAreaOverlay(backgroundOverlay, touchAreaOffsetX, touchAreaOffsetY, TouchHandler.TRIGGER_UP, self.onSliderUp, self )

    g_touchHandler:setAreaPressedSizeGain( self.touchAreaDown, touchAreaPressedGain)
    g_touchHandler:setAreaPressedSizeGain( self.touchAreaAlways, touchAreaPressedGain)
    g_touchHandler:setAreaPressedSizeGain( self.touchAreaUp, touchAreaPressedGain)

    return self
end

```