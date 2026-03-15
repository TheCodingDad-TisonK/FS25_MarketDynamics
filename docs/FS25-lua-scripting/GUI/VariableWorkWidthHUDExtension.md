## VariableWorkWidthHUDExtension

**Description**

> Custom HUD drawing extension for VariableWorkWidth
> Displays the active partial sections

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of VariableWorkWidthHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function VariableWorkWidthHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or VariableWorkWidthHUDExtension _mt)

    self.priority = GS_PRIO_HIGH

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.background = g_overlayManager:createOverlay( "gui.shortcutBox2" , 0 , 0 , 0 , 0 )
    self.background:setColor(r, g, b, a)

    self.bar = ThreePartOverlay.new()
    self.bar:setLeftPart( "gui.progressbar_left" , 0 , 0 )
    self.bar:setMiddlePart( "gui.progressbar_middle" , 0 , 0 )
    self.bar:setRightPart( "gui.progressbar_right" , 0 , 0 )

    self.separator = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.separator:setColor( 1 , 1 , 1 , 0.25 )

    self.title = utf8ToUpper(g_i18n:getText( "info_partialWorkingWidth" ))

    self.vehicle = vehicle
    self.variableWorkWidth = vehicle.spec_variableWorkWidth
    self.numSections = # self.variableWorkWidth.sections

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```