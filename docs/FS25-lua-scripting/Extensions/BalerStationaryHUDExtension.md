## BalerStationaryHUDExtension

**Description**

> Displays the fill levels and bale state of the stationary baler

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of BalerStationaryHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function BalerStationaryHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or BalerStationaryHUDExtension _mt)

    self.priority = GS_PRIO_HIGH

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop = g_overlayManager:createOverlay( "gui.hudExtension_top" , 0 , 0 , 0 , 0 )
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundScale = g_overlayManager:createOverlay( "gui.hudExtension_middle" , 0 , 0 , 0 , 0 )
    self.backgroundScale:setColor(r, g, b, a)
    self.backgroundBottom = g_overlayManager:createOverlay( "gui.hudExtension_bottom" , 0 , 0 , 0 , 0 )
    self.backgroundBottom:setColor(r, g, b, a)

    self.vehicleIcon = g_overlayManager:createOverlay( "gui.icon_goeweil" , 0 , 0 , 0 , 0 )
    self.baleIcon = g_overlayManager:createOverlay( "gui.icon_goeweil_bale" , 0 , 0 , 0 , 0 )
    self.grassIcon = g_overlayManager:createOverlay( "gui.icon_goeweil_grass" , 0 , 0 , 0 , 0 )
    self.wrappedBaleIcon = g_overlayManager:createOverlay( "gui.icon_goeweil_wrappedBale" , 0 , 0 , 0 , 0 )

    self.vehicle = vehicle
    self.baler = vehicle.spec_baler
    self.baleWrapper = vehicle.spec_baleWrapper

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```