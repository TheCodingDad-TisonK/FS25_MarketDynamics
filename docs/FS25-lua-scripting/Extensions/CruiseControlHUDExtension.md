## CruiseControlHUDExtension

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of CruiseControlHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function CruiseControlHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or CruiseControlHUDExtension _mt)

    self.priority = GS_PRIO_VERY_LOW

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.background = g_overlayManager:createOverlay( "gui.shortcutBox2" , 0 , 0 , 0 , 0 )
    self.background:setColor(r, g, b, a)

    self.separatorHorizontal = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.separatorHorizontal:setColor( 1 , 1 , 1 , 0.25 )

    self.changeSpeedText = utf8ToUpper(g_i18n:getText( "action_changeSpeed" ))

    self.vehicle = vehicle

    self.toggleElement = nil
    self.changeElement = nil

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```