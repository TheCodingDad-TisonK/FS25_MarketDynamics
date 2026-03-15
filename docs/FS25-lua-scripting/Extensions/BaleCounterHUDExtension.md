## BaleCounterHUDExtension

**Description**

> Displays the current bale counters

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of BaleCounterHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function BaleCounterHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or BaleCounterHUDExtension _mt)

    self.priority = GS_PRIO_NORMAL

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.background = g_overlayManager:createOverlay( "gui.shortcutBox1" , 0 , 0 , 0 , 0 )
    self.background:setColor(r, g, b, a)

    self.sessionOverlay = g_overlayManager:createOverlay( "gui.baleCount_session" , 0 , 0 , 0 , 0 )
    self.sessionOverlay:setColor( 1 , 1 , 1 , 1 )

    self.lifetimeOverlay = g_overlayManager:createOverlay( "gui.baleCount_lifetime" , 0 , 0 , 0 , 0 )
    self.lifetimeOverlay:setColor( 1 , 1 , 1 , 1 )

    self.title = utf8ToUpper(g_i18n:getText( "info_baleCounter" ))

    self.vehicle = vehicle

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```