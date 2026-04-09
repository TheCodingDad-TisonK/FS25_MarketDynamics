-- Logger.lua
-- [MDM]-prefixed logging helper. Wraps FS25's Logging.* functions so all
-- mod output is consistently prefixed and easy to grep in log.txt.
--
-- Usage:
--   MDMLog.info("message")    -> [MDM] message
--   MDMLog.warn("message")    -> [MDM] message          (Logging.warning)
--   MDMLog.error("message")   -> [MDM] message          (Logging.error)
--   MDMLog.debug("message")   -> [MDM] DEBUG: message   (only when debugEnabled)
--
-- MDMLog.debugEnabled is toggled by SettingsUI and mirrored in
-- coordinator.settings.debugMode so it survives save/load.
--
-- Author: tison (dev-1)

MDMLog = {}

local PREFIX = "[MDM] "

function MDMLog.info(msg)
    Logging.info(PREFIX .. tostring(msg))
end

function MDMLog.warn(msg)
    Logging.warning(PREFIX .. tostring(msg))
end

function MDMLog.error(msg)
    Logging.error(PREFIX .. tostring(msg))
end

-- Debug lines are only emitted when debugEnabled = true.
-- Toggle via ESC > Settings > Market Dynamics > Debug Logging,
-- or the 'mdmStatus' console command shows the current state.
function MDMLog.debug(msg)
    if MDMLog.debugEnabled then
        Logging.info(PREFIX .. "DEBUG: " .. tostring(msg))
    end
end

-- Off by default. Enabled by SettingsUI callback or loaded from save via MarketSerializer.
MDMLog.debugEnabled = false

-- ---------------------------------------------------------------------------
-- MDMUtil — shared utilities available to all MDM modules
-- ---------------------------------------------------------------------------
MDMUtil = {}

-- Returns absolute game-world time in milliseconds.
--
-- WHY NOT g_currentMission.time?
--   g_currentMission.time is session-elapsed time — it resets to 0 on every
--   load. Any value written to a savegame using .time as a base (contract
--   deadlines, event endsAt, cooldown lastFiredAt, history timestamps) will
--   be compared against a completely different .time value after reload,
--   causing incorrect expiry, wrong time-remaining display, and broken
--   cooldown logic.
--
-- The correct base is absolute game-world time:
--   (currentDay - 1) * 86400000 + dayTime
-- This is stable across saves and reloads.
function MDMUtil.getGameTime()
    local env = g_currentMission and g_currentMission.environment
    if not env then return 0 end
    local currentDay = env.currentDay or 1
    local dayTime    = env.dayTime    or 0
    return (currentDay - 1) * 86400000 + dayTime
end
