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
