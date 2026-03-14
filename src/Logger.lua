-- Logger.lua — [MDM] prefixed log helper
-- Uses Logging.info/warning/error so output appears in log.txt

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

function MDMLog.debug(msg)
    if MDMLog.debugEnabled then
        Logging.info(PREFIX .. "DEBUG: " .. tostring(msg))
    end
end

MDMLog.debugEnabled = false
