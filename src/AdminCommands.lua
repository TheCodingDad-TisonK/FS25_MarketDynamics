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
--   mdmContracts           open market screen → Contracts tab → New Contract dialog
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

local function cmdUPTest(self, outcome)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    if not UPIntegration.isAvailable() then
        print("[MDM] FS25_UsedPlus is not installed — cannot test")
        return
    end

    if not UPIntegration.isEnabled() then
        print("[MDM] UP mode is OFF — run 'mdmUPMode on' first")
        return
    end

    outcome = outcome or "fulfill"
    if outcome ~= "fulfill" and outcome ~= "default" then
        print("[MDM] Usage: mdmUPTest [fulfill|default]")
        return
    end

    -- Create a synthetic contract directly (bypasses UI, uses farmId 1)
    local farmId = g_currentMission and g_currentMission.player and
        g_currentMission.player.farmId or 1

    -- Diagnostics: confirm what's visible in our mod's environment
    print("[MDM] UPTest: UsedPlusAPI type = " .. type(UsedPlusAPI))
    -- Cross-mod global visibility probe: if g_rvbMenu is readable here, FS25 globals
    -- are shared across mods and rawset(_G,...) should work. If nil, sandbox is real.
    print("[MDM] UPTest: g_rvbMenu visible = " .. tostring(g_rvbMenu ~= nil))
    print("[MDM] UPTest: rawget(_G,'UsedPlusAPI') = " .. tostring(rawget(_G, "UsedPlusAPI") ~= nil))
    if type(UsedPlusAPI) == "table" then
        print("[MDM] UPTest: UsedPlusAPI.isReady = " .. tostring(UsedPlusAPI.isReady and UsedPlusAPI.isReady()))
        print("[MDM] UPTest: registerExternalDeal = " .. type(UsedPlusAPI.registerExternalDeal))
    end

    print("[MDM] UPTest: creating test futures contract (wheat, 10000L, farmId=" .. farmId .. ")")

    local contractId = g_MarketDynamics.futuresMarket:createContract({
        farmId        = farmId,
        fillTypeIndex = 1,
        fillTypeName  = "Wheat",
        quantity      = 10000,
        lockedPrice   = 1.50,
        deliveryTimeMs = (g_currentMission and g_currentMission.time or 0) + 60000,
    })

    print("[MDM] UPTest: contract #" .. contractId .. " created — settling as: " .. outcome)

    if outcome == "fulfill" then
        g_MarketDynamics.futuresMarket.contracts[contractId].delivered = 10000
        g_MarketDynamics.futuresMarket:_fulfillContract(contractId)
        print("[MDM] UPTest: fulfilled — check log for UPIntegration deal report")
    else
        g_MarketDynamics.futuresMarket:_defaultContract(contractId)
        print("[MDM] UPTest: defaulted — check log for UPIntegration default report")
    end

    -- Show credit score after settlement
    local score = UPIntegration.getCreditScore(farmId)
    if score then
        print("[MDM] UPTest: credit score for farm " .. farmId .. " = " .. score)
    else
        print("[MDM] UPTest: credit score unavailable (not server or UP not responding)")
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

local function cmdContracts(self)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end
    -- Set flag so onOpen() auto-navigates to contracts tab and opens the dialog
    g_MarketDynamics._autoOpenContracts = true
    MDMMarketScreen.show()
    print("[MDM] Opening market screen → Contracts tab → New Contract dialog")
end

-- mdmContract: directly open the contract dialog (bypasses MarketScreen entirely)
local function cmdContract(self)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then
        print("[MDM] System not active")
        return
    end

    print("[MDM] mdmContract: directly calling MDMDialogLoader.show ...")

    -- Build minimal commodity list from engine so the dialog has real data
    local commodities = {}
    if g_MarketDynamics.marketEngine then
        for fillTypeIndex, entry in pairs(g_MarketDynamics.marketEngine.prices) do
            local ft = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
            local isCrop = g_fruitTypeManager ~= nil
                and g_fruitTypeManager.getFruitTypeByFillTypeIndex ~= nil
                and g_fruitTypeManager:getFruitTypeByFillTypeIndex(fillTypeIndex) ~= nil
            if ft and isCrop then
                local changePct = g_MarketDynamics.marketEngine:getPriceChangePercent(fillTypeIndex)
                table.insert(commodities, {
                    idx       = fillTypeIndex,
                    name      = ft.name,
                    title     = ft.title or ft.name,
                    current   = entry.current,
                    base      = entry.base,
                    changePct = changePct,
                })
            end
        end
        table.sort(commodities, function(a, b) return a.title < b.title end)
    end

    print("[MDM] mdmContract: built " .. #commodities .. " commodity entries")
    print("[MDM] mdmContract: loader registry size = " .. (function()
        local n = 0
        for _ in pairs(MDMDialogLoader._registry) do n = n + 1 end
        return n
    end)())

    local entry = MDMDialogLoader._registry["MDMContractDialog"]
    if not entry then
        print("[MDM] mdmContract: ERROR — 'MDMContractDialog' not in loader registry!")
        return
    end
    print("[MDM] mdmContract: registry entry found, loaded=" .. tostring(entry.loaded))

    local ok, err = pcall(function()
        MDMDialogLoader.show("MDMContractDialog", "setData", {
            commodities = commodities,
            selectedIdx = 1,
            onConfirmed = function(crop, qty, delivDays)
                print("[MDM] mdmContract: confirmed — " .. tostring(crop and crop.title) .. " " .. tostring(qty) .. "L " .. tostring(delivDays) .. "d")
            end,
        })
    end)

    if not ok then
        print("[MDM] mdmContract: pcall ERROR: " .. tostring(err))
    else
        print("[MDM] mdmContract: show() call completed (check log for loader msgs)")
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
    g_MarketDynamics.cmdMdmUPTest  = cmdUPTest
    g_MarketDynamics.cmdMdmHud       = cmdHud
    g_MarketDynamics.cmdMdmContracts = cmdContracts
    g_MarketDynamics.cmdMdmContract  = cmdContract

    addConsoleCommand("mdmStatus",    "MDM: system health and active events",              "cmdMdmStatus",    g_MarketDynamics)
    addConsoleCommand("mdmEvent",     "MDM: force-fire event (arg: eventId)",              "cmdMdmEvent",     g_MarketDynamics)
    addConsoleCommand("mdmExpire",    "MDM: force-expire active event (arg: eventId)",     "cmdMdmExpire",    g_MarketDynamics)
    addConsoleCommand("mdmPrice",     "MDM: show price for a crop (arg: cropName)",        "cmdMdmPrice",     g_MarketDynamics)
    addConsoleCommand("mdmEvents",    "MDM: list all registered events and status",        "cmdMdmEvents",    g_MarketDynamics)
    addConsoleCommand("mdmBCMode",    "MDM: toggle BetterContracts integration (on/off)",  "cmdMdmBCMode",    g_MarketDynamics)
    addConsoleCommand("mdmUPMode",    "MDM: toggle UsedPlus integration (on/off)",         "cmdMdmUPMode",    g_MarketDynamics)
    addConsoleCommand("mdmUPTest",    "MDM: test UP contract lifecycle (fulfill|default)",  "cmdMdmUPTest",    g_MarketDynamics)
    addConsoleCommand("mdmHud",       "MDM: toggle debug HUD overlay",                     "cmdMdmHud",       g_MarketDynamics)
    addConsoleCommand("mdmContracts", "MDM: open market screen → Contracts → New dialog",  "cmdMdmContracts", g_MarketDynamics)
    addConsoleCommand("mdmContract",  "MDM: directly open contract dialog (debug)",        "cmdMdmContract",  g_MarketDynamics)

    MDMLog.info("AdminCommands: registered 11 console commands")
end

function MDMAdminCommands_remove()
    removeConsoleCommand("mdmStatus")
    removeConsoleCommand("mdmEvent")
    removeConsoleCommand("mdmExpire")
    removeConsoleCommand("mdmPrice")
    removeConsoleCommand("mdmEvents")
    removeConsoleCommand("mdmBCMode")
    removeConsoleCommand("mdmUPMode")
    removeConsoleCommand("mdmUPTest")
    removeConsoleCommand("mdmHud")
    removeConsoleCommand("mdmContracts")
    removeConsoleCommand("mdmContract")
end
