-- AdminCommands.lua
-- In-game developer console commands for testing and debugging MDM.
-- Commands are registered against the g_MarketDynamics coordinator instance
-- so FS25's console calls them as coordinator:cmdMdmXxx(arg).
--
-- Registered in MarketDynamics:onMissionLoaded via MDMAdminCommands_register().
-- Removed in MarketDynamics:delete()         via MDMAdminCommands_remove().
--
-- Available commands (open console with the tilde key):
--   mdmStatus              system health, active events, price count
--   mdmEvent  <eventId>    force-fire a registered event at full intensity
--   mdmExpire <eventId>    force-expire an active event immediately
--   mdmPrice  <cropName>   show current vs base price for a crop (e.g. mdmPrice wheat)
--   mdmEvents              list all registered events with status and cooldown
--   mdmBCMode [on|off]     toggle BetterContracts integration
--   mdmUPMode [on|off]     toggle UsedPlus integration
--   mdmHud                 toggle the debug HUD overlay (TEMP)
--
-- Author: tison (dev-1)

-- ---------------------------------------------------------------------------
-- Command handlers
-- Stored as methods on g_MarketDynamics at registration time so the console
-- can call them as coordinator:cmdMdmXxx(arg). 'self' = coordinator instance.
-- ---------------------------------------------------------------------------

local function cmdStatus(self)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System is not active")
        return
    end

    local mdm = g_MarketDynamics
    local priceCount = 0
    for _ in pairs(mdm.marketEngine.prices) do priceCount = priceCount + 1 end

    local activeEvents  = mdm.worldEvents:getActiveEvents()
    local registryCount = 0
    for _ in pairs(mdm.worldEvents.registry) do registryCount = registryCount + 1 end

    print("=== MDM Status ===")
    print("  Active:         " .. tostring(mdm.isActive))
    print("  Prices tracked: " .. priceCount .. " fill types")
    print("  Events:         " .. #activeEvents .. " active / " .. registryCount .. " registered")

    if #activeEvents > 0 then
        local now = g_currentMission and g_currentMission.time or 0
        for _, ev in ipairs(activeEvents) do
            local remaining = math.max(0, ev.endsAt - now)
            local mins      = math.floor(remaining / 60000)
            print(string.format("    [ACTIVE] %-20s  intensity=%.2f  ~%d min remaining",
                ev.name, ev.intensity, mins))
        end
    end
    print("==================")
end

local function cmdEvent(self, eventId)
    if not eventId or eventId == "" then
        print("[MDM] Usage: mdmEvent <eventId>")
        print("[MDM] Run 'mdmEvents' to see available IDs")
        return
    end
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    local ok, err = g_MarketDynamics.worldEvents:forceFireEvent(eventId, 1.0)
    if ok then
        print("[MDM] Fired event '" .. eventId .. "' at full intensity")
    else
        print("[MDM] Failed: " .. (err or "unknown error"))
    end
end

local function cmdExpire(self, eventId)
    if not eventId or eventId == "" then
        print("[MDM] Usage: mdmExpire <eventId>")
        return
    end
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    local ok, err = g_MarketDynamics.worldEvents:forceExpireEvent(eventId)
    if ok then
        print("[MDM] Expired event '" .. eventId .. "'")
    else
        print("[MDM] Failed: " .. (err or "unknown error"))
    end
end

local function cmdPrice(self, cropName)
    if not cropName or cropName == "" then
        print("[MDM] Usage: mdmPrice <cropName>  (e.g. mdmPrice wheat)")
        return
    end
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
    if not fillType then
        print("[MDM] Unknown crop: '" .. cropName .. "'")
        return
    end

    local entry = g_MarketDynamics.marketEngine.prices[fillType.index]
    if not entry then
        print("[MDM] No price data for '" .. cropName .. "' (fillTypeIndex=" .. fillType.index .. ")")
        return
    end

    local changePct = g_MarketDynamics.marketEngine:getPriceChangePercent(fillType.index)
    local modCount  = #entry.modifiers
    print(string.format("[MDM] %s — base: $%.2f  current: $%.2f  (%+.1f%%)  volatility: %.3f  event mods: %d",
        cropName:upper(), entry.base, entry.current, changePct, entry.volatilityFactor, modCount))
end

local function cmdEvents(self)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    local now = g_currentMission and g_currentMission.time or 0
    print("=== MDM Registered Events ===")
    for id, event in pairs(g_MarketDynamics.worldEvents.registry) do
        local active = g_MarketDynamics.worldEvents.active[id]
        local status
        if active then
            local mins = math.floor(math.max(0, active.endsAt - now) / 60000)
            status = string.format("ACTIVE (%.2f intensity, ~%d min left)", active.intensity, mins)
        else
            local cooldownLeft = math.max(0, (event.lastFiredAt + (event.cooldownMs or 0)) - now)
            if cooldownLeft > 0 then
                status = string.format("cooldown (~%d min)", math.floor(cooldownLeft / 60000))
            else
                status = "ready"
            end
        end
        print(string.format("  %-22s  p=%.2f  %s", id, event.probability, status))
    end
    print("=============================")
end

local function cmdBCMode(self, arg)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    if not BCIntegration.isAvailable() then
        print("[MDM] BetterContracts is not installed — BC mode unavailable")
        return
    end

    if arg == "on" or arg == "1" or arg == "true" then
        BCIntegration.setEnabled(true)
        print("[MDM] BC mode ON — supply reactions active, MDM futures UI suppressed")
    elseif arg == "off" or arg == "0" or arg == "false" then
        BCIntegration.setEnabled(false)
        print("[MDM] BC mode OFF — MDM futures system active")
    else
        local state = BCIntegration.isEnabled() and "ON" or "OFF"
        print("[MDM] BC mode is currently: " .. state)
        print("[MDM] Usage: mdmBCMode on | off")
    end
end

local function cmdUPMode(self, arg)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    if not UPIntegration.isAvailable() then
        print("[MDM] FS25_UsedPlus is not installed — UP mode unavailable")
        return
    end

    if arg == "on" or arg == "1" or arg == "true" then
        UPIntegration.setEnabled(true)
        print("[MDM] UP mode ON — futures contracts will affect credit score (stubs active)")
    elseif arg == "off" or arg == "0" or arg == "false" then
        UPIntegration.setEnabled(false)
        print("[MDM] UP mode OFF")
    else
        local state = UPIntegration.isEnabled() and "ON" or "OFF"
        print("[MDM] UP mode is currently: " .. state)
        print("[MDM] Usage: mdmUPMode on | off")
    end
end

local function cmdHud(self)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    if g_MDMHud then
        g_MDMHud = nil
        print("[MDM] Debug HUD: OFF")
    else
        g_MDMHud = g_MarketDynamics._debugHud
        print("[MDM] Debug HUD: ON")
    end
end

-- ---------------------------------------------------------------------------
-- Registration / removal — called from MarketDynamics lifecycle
-- ---------------------------------------------------------------------------

function MDMAdminCommands_register()
    -- Attach handlers to the coordinator instance first — console resolves
    -- "cmdMdmXxx" as a method lookup on the target object passed below.
    g_MarketDynamics.cmdMdmStatus  = cmdStatus
    g_MarketDynamics.cmdMdmEvent   = cmdEvent
    g_MarketDynamics.cmdMdmExpire  = cmdExpire
    g_MarketDynamics.cmdMdmPrice   = cmdPrice
    g_MarketDynamics.cmdMdmEvents  = cmdEvents
    g_MarketDynamics.cmdMdmBCMode  = cmdBCMode
    g_MarketDynamics.cmdMdmUPMode  = cmdUPMode
    g_MarketDynamics.cmdMdmHud     = cmdHud

    addConsoleCommand("mdmStatus",  "MDM: system health and active events",             "cmdMdmStatus",  g_MarketDynamics)
    addConsoleCommand("mdmEvent",   "MDM: force-fire event (arg: eventId)",             "cmdMdmEvent",   g_MarketDynamics)
    addConsoleCommand("mdmExpire",  "MDM: force-expire active event (arg: eventId)",    "cmdMdmExpire",  g_MarketDynamics)
    addConsoleCommand("mdmPrice",   "MDM: show price for a crop (arg: cropName)",       "cmdMdmPrice",   g_MarketDynamics)
    addConsoleCommand("mdmEvents",  "MDM: list all registered events and status",       "cmdMdmEvents",  g_MarketDynamics)
    addConsoleCommand("mdmBCMode",  "MDM: toggle BetterContracts integration (on/off)", "cmdMdmBCMode",  g_MarketDynamics)
    addConsoleCommand("mdmUPMode",  "MDM: toggle UsedPlus integration (on/off)",        "cmdMdmUPMode",  g_MarketDynamics)
    addConsoleCommand("mdmHud",     "MDM: toggle debug HUD overlay (TEMP)",             "cmdMdmHud",     g_MarketDynamics)

    MDMLog.info("AdminCommands: registered 8 console commands")
end

function MDMAdminCommands_remove()
    removeConsoleCommand("mdmStatus")
    removeConsoleCommand("mdmEvent")
    removeConsoleCommand("mdmExpire")
    removeConsoleCommand("mdmPrice")
    removeConsoleCommand("mdmEvents")
    removeConsoleCommand("mdmBCMode")
    removeConsoleCommand("mdmUPMode")
    removeConsoleCommand("mdmHud")
end
