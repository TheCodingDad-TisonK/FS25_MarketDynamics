-- Logger.lua — [MDM] prefixed log helper

MDMLog = {}

local PREFIX = "[MDM] "

function MDMLog.info(msg)
    print(PREFIX .. tostring(msg))
end

function MDMLog.warn(msg)
    print(PREFIX .. "WARN: " .. tostring(msg))
end

function MDMLog.error(msg)
    print(PREFIX .. "ERROR: " .. tostring(msg))
end

function MDMLog.debug(msg)
    if MDMLog.debugEnabled then
        print(PREFIX .. "DEBUG: " .. tostring(msg))
    end
end

MDMLog.debugEnabled = false
