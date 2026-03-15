## YarderTowerHUDExtension

**Description**

> Custom HUD drawing extension to display the current state of the yarder (player position, carriage position and if
> it's loaded)

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of YarderTowerHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function YarderTowerHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or YarderTowerHUDExtension _mt)

    self.priority = GS_PRIO_HIGH

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop = g_overlayManager:createOverlay( "gui.hudExtension_top" , 0 , 0 , 0 , 0 )
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundScale = g_overlayManager:createOverlay( "gui.hudExtension_middle" , 0 , 0 , 0 , 0 )
    self.backgroundScale:setColor(r, g, b, a)
    self.backgroundBottom = g_overlayManager:createOverlay( "gui.hudExtension_bottom" , 0 , 0 , 0 , 0 )
    self.backgroundBottom:setColor(r, g, b, a)

    self.iconCarriage = g_overlayManager:createOverlay( "gui.icon_carriage" , 0 , 0 , 0 , 0 )
    self.iconPlayer = g_overlayManager:createOverlay( "gui.icon_position" , 0 , 0 , 0 , 0 )
    self.iconPosition = g_overlayManager:createOverlay( "gui.icon_position" , 0 , 0 , 0 , 0 )
    self.iconTree = g_overlayManager:createOverlay( "gui.icon_tree" , 0 , 0 , 0 , 0 )
    self.iconYarder = g_overlayManager:createOverlay( "gui.icon_yarder" , 0 , 0 , 0 , 0 )

    self.text = string.format( "%s - %s" , g_i18n:getText( "ui_yarder" ), vehicle:getName())

    self.vehicle = vehicle

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```