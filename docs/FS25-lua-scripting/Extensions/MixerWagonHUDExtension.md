## MixerWagonHUDExtension

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of MixerWagonHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function MixerWagonHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or MixerWagonHUDExtension _mt)

    self.priority = GS_PRIO_HIGH

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop = g_overlayManager:createOverlay( "gui.hudExtension_top" , 0 , 0 , 0 , 0 )
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundScale = g_overlayManager:createOverlay( "gui.hudExtension_middle" , 0 , 0 , 0 , 0 )
    self.backgroundScale:setColor(r, g, b, a)
    self.backgroundBottom = g_overlayManager:createOverlay( "gui.hudExtension_bottom" , 0 , 0 , 0 , 0 )
    self.backgroundBottom:setColor(r, g, b, a)

    self.bar = ThreePartOverlay.new()
    self.bar:setLeftPart( "gui.progressbar_left" , 0 , 0 )
    self.bar:setMiddlePart( "gui.progressbar_middle" , 0 , 0 )
    self.bar:setRightPart( "gui.progressbar_right" , 0 , 0 )

    self.marker = g_overlayManager:createOverlay( "gui.tmr_marker" , 0 , 0 , 0 , 0 )

    self.vehicle = vehicle
    self.mixerWagon = vehicle.spec_mixerWagon
    self.numFillTypes = # self.mixerWagon.mixerWagonFillTypes

    self.fillTypeStatus = { }
    for _, mixerWagonFillType in ipairs( self.mixerWagon.mixerWagonFillTypes) do
        local firstFilltype = next(mixerWagonFillType.fillTypes)
        local fillType = g_fillTypeManager:getFillTypeByIndex(firstFilltype)

        if fillType ~ = nil then
            local icon = Overlay.new(fillType.hudOverlayFilename, 0 , 0 , 0 , 0 )

            local status = {
            icon = icon,
            fillLevel = 0 ,
            minPercentage = mixerWagonFillType.minPercentage,
            maxPercentage = mixerWagonFillType.maxPercentage
            }

            table.insert( self.fillTypeStatus, status )
        end
    end

    self.badMixColor = { 0.8069 , 0.0097 , 0.0097 , 1 }

    self.title = utf8ToUpper( string.format( "%s - %s" , g_i18n:getText( "info_mixingRatio" ), vehicle:getFullName()))

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```