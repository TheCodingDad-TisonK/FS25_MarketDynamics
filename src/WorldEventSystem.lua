-- WorldEventSystem.lua
-- Manages the registry, scheduling, and firing of world events that affect prices.
-- Events register themselves; the system fires them probabilistically on a tick.
--
-- Author: tison (dev-1)

WorldEventSystem = {}
WorldEventSystem.__index = WorldEventSystem

local CHECK_INTERVAL_MS = 5 * 60 * 1000  -- check for new events every 5 in-game minutes
local MIN_COOLDOWN_MS   = 20 * 60 * 1000 -- minimum gap between events of the same type

function WorldEventSystem.new()
    local self = setmetatable({}, WorldEventSystem)

    -- { [id] = { id, name, probability, minIntensity, maxIntensity, cooldownMs, lastFiredAt, onFire } }
    self.registry  = {}
    self.active    = {}   -- currently active events { [id] = { event, endsAt, intensity } }
    self.timer     = 0

    MDMLog.info("WorldEventSystem initialized")
    return self
end

-- Register a new event type
-- event = { id, name, probability (0-1), minIntensity, maxIntensity, cooldownMs, onFire(intensity) }
function WorldEventSystem:registerEvent(event)
    if self.registry[event.id] then
        MDMLog.warn("WorldEventSystem: duplicate event id '" .. event.id .. "'")
        return
    end
    event.lastFiredAt = -math.huge
    self.registry[event.id] = event
    MDMLog.info("WorldEventSystem: registered event '" .. event.id .. "'")
end

function WorldEventSystem:update(dt)
    self.timer = self.timer + dt

    -- Tick active events — remove expired ones
    local now = g_currentMission and g_currentMission.time or 0
    for id, active in pairs(self.active) do
        if now >= active.endsAt then
            self:_expireEvent(id)
        end
    end

    -- Probabilistic event check
    if self.timer >= CHECK_INTERVAL_MS then
        self.timer = 0
        self:_rollForEvents()
    end
end

-- Returns a list of active event summaries for the HUD/GUI
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

-- Force-fire a registered event at a given intensity (0-1). For admin/testing only.
-- Returns true on success, false + reason string on failure.
function WorldEventSystem:forceFireEvent(id, intensity)
    local event = self.registry[id]
    if not event then
        return false, "unknown event id '" .. tostring(id) .. "'"
    end
    if self.active[id] then
        return false, "event '" .. id .. "' is already active"
    end

    intensity = math.max(0, math.min(1, intensity or 1.0))
    local now = g_currentMission and g_currentMission.time or 0

    local minDur = event.minDurationMs or (5  * 60 * 1000)
    local maxDur = event.maxDurationMs or (15 * 60 * 1000)
    local duration = minDur + math.random() * (maxDur - minDur)

    event.lastFiredAt = now
    self.active[id] = { event = event, endsAt = now + duration, intensity = intensity }

    MDMLog.info("WorldEventSystem: FORCED '" .. id .. "' intensity=" .. string.format("%.2f", intensity))

    if event.onFire then
        event.onFire(intensity)
    end

    return true, nil
end

-- Force-expire an active event immediately. For admin/testing only.
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

function WorldEventSystem:_fireEvent(event, now)
    local intensity = event.minIntensity + math.random() * (event.maxIntensity - event.minIntensity)
    local minDur    = event.minDurationMs or (5  * 60 * 1000)
    local maxDur    = event.maxDurationMs or (15 * 60 * 1000)
    local duration  = minDur + math.random() * (maxDur - minDur)

    event.lastFiredAt = now
    self.active[event.id] = { event = event, endsAt = now + duration, intensity = intensity }

    MDMLog.info("WorldEventSystem: firing '" .. event.id .. "' intensity=" .. string.format("%.2f", intensity))

    if event.onFire then
        event.onFire(intensity)
    end
end

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
