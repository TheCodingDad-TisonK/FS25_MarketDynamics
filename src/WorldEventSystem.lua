-- WorldEventSystem.lua
-- Manages the registry, scheduling, and firing of world events that affect prices.
--
-- Events register themselves via MDM_pendingRegistrations (a standalone global
-- set by each events/*.lua file before MarketDynamics exists). The coordinator
-- drains that table in MarketDynamics:_registerDefaultEvents().
--
-- Event descriptor shape:
--   id            string   unique identifier (e.g. "drought")
--   name          string   human-readable name (shown in HUD/console)
--   probability   number   0-1 chance of firing per CHECK_INTERVAL tick
--   minIntensity  number   0-1 lower bound for intensity roll
--   maxIntensity  number   0-1 upper bound for intensity roll
--   cooldownMs    number   minimum gap between firings of this event (ms)
--   minDurationMs number   minimum active duration (ms)
--   maxDurationMs number   maximum active duration (ms)
--   onFire(intensity)    function   called when event fires
--   onExpire(intensity)  function   called when event expires
--
-- Public API:
--   registerEvent(event)              — add an event descriptor to the registry
--   update(dt)                        — advance timer, expire events, roll for new ones
--   getActiveEvents()                 — list of active event summaries for GUI
--   forceFireEvent(id, intensity)     — fire immediately (admin/testing)
--   forceExpireEvent(id)              — expire immediately (admin/testing)
--
-- Author: tison (dev-1)

WorldEventSystem = {}
WorldEventSystem.__index = WorldEventSystem

local CHECK_INTERVAL_MS = 5 * 60 * 1000   -- check for new events every 5 in-game minutes
local MIN_COOLDOWN_MS   = 20 * 60 * 1000  -- fallback if event descriptor omits cooldownMs

function WorldEventSystem.new()
    local self = setmetatable({}, WorldEventSystem)

    -- { [id] = event descriptor (with lastFiredAt added at registration) }
    self.registry = {}
    -- { [id] = { event, endsAt, intensity } }  — currently active events
    self.active   = {}
    self.timer    = 0

    MDMLog.info("WorldEventSystem initialized")
    return self
end

-- Register a new event type. Rejects duplicate IDs.
function WorldEventSystem:registerEvent(event)
    if self.registry[event.id] then
        MDMLog.warn("WorldEventSystem: duplicate event id '" .. event.id .. "' — ignored")
        return
    end
    -- lastFiredAt starts at -math.huge so the first roll is never blocked by cooldown.
    event.lastFiredAt = -math.huge
    self.registry[event.id] = event
    MDMLog.info("WorldEventSystem: registered event '" .. event.id .. "'")
end

-- Restore an active event from savegame.
-- Called by MarketSerializer:load() after all events are registered.
function WorldEventSystem:loadActiveEvent(id, endsAt, intensity)
    local event = self.registry[id]
    if not event then
        MDMLog.warn("WorldEventSystem: cannot restore unknown event '" .. tostring(id) .. "'")
        return
    end

    self.active[id] = { event = event, endsAt = endsAt, intensity = intensity }
    
    -- Re-trigger onFire to re-apply modifiers to the MarketEngine
    if event.onFire then
        event.onFire(intensity)
    end
    
    MDMLog.info("WorldEventSystem: restored active event '" .. id .. "' (ends in " .. 
        string.format("%.1f", (endsAt - (g_currentMission.time or 0)) / 60000) .. "m)")
end

-- Advance the event tick timer, expire any events past their endsAt, and
-- probabilistically roll for new events when CHECK_INTERVAL elapses.
-- dt is in-game milliseconds.
function WorldEventSystem:update(dt)
    self.timer = self.timer + dt

    -- Tick active events — expire any that have passed their end time
    local now = g_currentMission and g_currentMission.time or 0
    for id, active in pairs(self.active) do
        if now >= active.endsAt then
            self:_expireEvent(id)
        end
    end

    -- Probabilistic event roll on a fixed interval
    if self.timer >= CHECK_INTERVAL_MS then
        self.timer = 0
        self:_rollForEvents()
    end
end

-- Returns a list of active event summaries for the HUD and GUI.
-- Each entry: { id, name, intensity, endsAt }
function WorldEventSystem:getActiveEvents()
    local result = {}
    for id, active in pairs(self.active) do
        table.insert(result, {
            id        = id,
            name      = self.registry[id] and self.registry[id].name or id,
            intensity = active.intensity,
            endsAt    = active.endsAt,
        })
    end
    return result
end

-- Force-fire a registered event at a given intensity (0-1). Admin/testing only.
-- intensity defaults to 1.0 (maximum) if omitted.
-- Returns true on success; false + reason string on failure.
function WorldEventSystem:forceFireEvent(id, intensity)
    local event = self.registry[id]
    if not event then
        return false, "unknown event id '" .. tostring(id) .. "'"
    end
    if self.active[id] then
        return false, "event '" .. id .. "' is already active"
    end

    intensity = math.max(0, math.min(1, intensity or 1.0))
    local now    = g_currentMission and g_currentMission.time or 0
    local minDur = event.minDurationMs or (5  * 60 * 1000)
    local maxDur = event.maxDurationMs or (15 * 60 * 1000)
    local duration = minDur + math.random() * (maxDur - minDur)

    event.lastFiredAt = now
    self.active[id]   = { event = event, endsAt = now + duration, intensity = intensity }

    MDMLog.info("WorldEventSystem: FORCED '" .. id .. "' intensity=" .. string.format("%.2f", intensity))

    if event.onFire then
        event.onFire(intensity)
    end

    return true, nil
end

-- Force-expire an active event immediately. Admin/testing only.
-- Returns true on success; false + reason string if the event is not active.
function WorldEventSystem:forceExpireEvent(id)
    if not self.active[id] then
        return false, "event '" .. tostring(id) .. "' is not active"
    end
    self:_expireEvent(id)
    return true, nil
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

-- Iterate all registered events and roll each one for firing.
-- An event is eligible if: not currently active AND cooldown has elapsed.
function WorldEventSystem:_rollForEvents()
    local now = g_currentMission and g_currentMission.time or 0

    for id, event in pairs(self.registry) do
        if not self.active[id] then
            local cooldown = event.cooldownMs or MIN_COOLDOWN_MS
            if (now - event.lastFiredAt) >= cooldown then
                if math.random() < event.probability then
                    self:_fireEvent(event, now)
                end
            end
        end
    end
end

-- Fire an event: roll intensity and duration, record in active table, call onFire.
function WorldEventSystem:_fireEvent(event, now)
    local intensity = event.minIntensity + math.random() * (event.maxIntensity - event.minIntensity)
    local minDur    = event.minDurationMs or (5  * 60 * 1000)
    local maxDur    = event.maxDurationMs or (15 * 60 * 1000)
    local duration  = minDur + math.random() * (maxDur - minDur)

    event.lastFiredAt         = now
    self.active[event.id]     = { event = event, endsAt = now + duration, intensity = intensity }

    MDMLog.info("WorldEventSystem: firing '" .. event.id ..
        "' intensity=" .. string.format("%.2f", intensity))

    if event.onFire then
        event.onFire(intensity)
    end
end

-- Expire an active event: call onExpire, remove from active table.
function WorldEventSystem:_expireEvent(id)
    local active = self.active[id]
    if not active then return end

    MDMLog.info("WorldEventSystem: event '" .. id .. "' expired")

    local event = self.registry[id]
    if event and event.onExpire then
        event.onExpire(active.intensity)
    end

    self.active[id] = nil
end
