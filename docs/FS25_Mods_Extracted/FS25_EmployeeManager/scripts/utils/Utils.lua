CustomUtils = {}

local _print = print

CustomUtils.showDebug = true

CustomUtils.tag = {
    INFO = "INFO",
    ERROR = "ERROR",
    DEBUG = "DEBUG",
    WARNING = "WARNING"
}

local function formatWithArgs(message, ...)
    local numArgs = select('#', ...)
    if numArgs > 0 then
        local args = {...}
        for i = 1, numArgs do
            if args[i] == nil then
                args[i] = "nil"
            end
        end

        local success, result = pcall(string.format, message, unpack(args))
        if success then
            return result
        else
            return message .. " [Format Error: " .. result .. "]"
        end
    end

    return tostring(message)
end

function CustomUtils:_log(tag, message, ...)
    if not self.showDebug then
        return
    end

    local msg = formatWithArgs(message, ...)
    local modName = g_modName or "FS25_EmployeeManager"

    if tag and tag ~= "" then
        _print(string.format('[%s] %s: %s', modName, tag, msg))
    else
        _print(string.format('[%s] %s', modName, msg))
    end
end

function CustomUtils:info(message, ...)
    self:_log(self.tag.INFO, message, ...)
end

function CustomUtils:error(message, ...)
    self:_log(self.tag.ERROR, message, ...)
end

function CustomUtils:warning(message, ...)
    self:_log(self.tag.WARNING, message, ...)
end

function CustomUtils:debug(message, ...)
    self:_log(self.tag.DEBUG, message, ...)
end

function CustomUtils:print(message, ...)
    if not self.showDebug then
        return
    end

    local msg = formatWithArgs(message, ...)
    local modName = g_modName or "FS25_EmployeeManager"
    _print(string.format('[%s] %s', modName, msg))
end
