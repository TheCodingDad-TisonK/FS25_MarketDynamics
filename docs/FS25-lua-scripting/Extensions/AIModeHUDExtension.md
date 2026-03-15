## AIModeHUDExtension

**Functions**

- [new](#new)

### new

**Description**

> Create a new instance of AIModeHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function AIModeHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or AIModeHUDExtension _mt)

    self.priority = GS_PRIO_VERY_HIGH

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.background = g_overlayManager:createOverlay( "gui.shortcutBox2" , 0 , 0 , 0 , 0 )
    self.background:setColor(r, g, b, a)

    self.separatorHorizontal = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.separatorHorizontal:setColor( 1 , 1 , 1 , 0.25 )

    self.aiModeText = g_i18n:getText( "action_aiModeSelected" )
    self.aiModeHoldText = utf8ToUpper(g_i18n:getText( "input_holdButton" ))

    self.vehicle = vehicle
    self.spec = vehicle.spec_aiModeSelection
    self.specDrivable = vehicle.spec_aiDrivable

    self.textWorkerDeactivate = g_i18n:getText( "ai_modeWorker_deactivate" )
    self.textWorkerActivate = g_i18n:getText( "ai_modeWorker_activate" )
    self.textSteeringAssistDeactivate = g_i18n:getText( "ai_modeSteeringAssist_deactivate" )
    self.textSteeringAssistActivate = g_i18n:getText( "ai_modeSteeringAssist_activate" )
    self.textSteeringAssistDisabled = g_i18n:getText( "ai_modeSteeringAssist_noLane" )

    self.textAIState = g_i18n:getText( "ai_state" )
    self.textAIStateDriving = g_i18n:getText( "ai_stateDriving" )
    self.textAIStatePlanning = g_i18n:getText( "ai_statePlanning" )
    self.textAIStateBlocked = g_i18n:getText( "ai_stateBlocked" )
    self.textAIStateTargetReached = g_i18n:getText( "ai_stateTargetReached" )
    self.textAIStateNotReachable = g_i18n:getText( "ai_stateNotReachable" )

    self.aiElement = nil

    self:storeScaledValues()

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    return self
end

```