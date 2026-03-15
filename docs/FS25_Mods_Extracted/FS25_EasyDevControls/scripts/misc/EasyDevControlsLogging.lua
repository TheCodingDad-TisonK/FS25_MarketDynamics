--
-- Author: GtX | Andy
-- Date: 07.05.2019
-- Revision: FS25-01
--

EasyDevControlsLogging = {}

function EasyDevControlsLogging.info(message, ...)
    print(string.format("  Info: [Easy Development Controls] " .. message, ...))
end

function EasyDevControlsLogging.warning(message, ...)
    printWarning(string.format("  Warning: [Easy Development Controls] " .. message, ...))
end

function EasyDevControlsLogging.error(message, ...)
    printError(string.format("  Error: [Easy Development Controls] " .. message, ...))
end

function EasyDevControlsLogging.dedicatedServerInfo(message, ...)
    if g_dedicatedServer ~= nil and message ~= nil then
        print(string.format("  Info: " .. message, ...))
    end
end

function EasyDevControlsLogging.devInfo(message, ...)
    -- if g_easyDevControlsDebugLevel > 0 then
    if g_easyDevControlsDevelopmentMode then
        print(string.format("  DevInfo: [Easy Development Controls] " .. message, ...))
    end
end

function EasyDevControlsLogging.devWarning(message, ...)
    -- if g_easyDevControlsDebugLevel > 1 then
    if g_easyDevControlsDevelopmentMode then
        printWarning(string.format("  DevWarning: [Easy Development Controls] " .. message, ...))
    end
end

function EasyDevControlsLogging.devError(message, ...)
    -- if g_easyDevControlsDebugLevel > 2 then
    if g_easyDevControlsDevelopmentMode then
        printError(string.format("  DevError: [Easy Development Controls] " .. message, ...))
    end
end

function EasyDevControlsLogging.devCallstackError(message, ...)
    -- if g_easyDevControlsDebugLevel > 2 then
    if g_easyDevControlsDevelopmentMode then
        printError(string.format("  DevError: [Easy Development Controls] " .. message, ...))
        printCallstack()
    end
end

function EasyDevControlsLogging.xmlDevError(xmlFile, message, ...)
    -- if g_easyDevControlsDebugLevel > 2 then
    if g_easyDevControlsDevelopmentMode then
        local filename = ""
        local typeStr = type(xmlFile)

        if typeStr == "number" then
            filename = " (" .. getXMLFilename(xmlFile) .. ") "
        elseif typeStr == "table" then
            filename = " (" .. xmlFile:getFilename() .. ") "
        else
            filename = " (" .. tostring(xmlFile) .. ") "
        end

        printError(string.format("  DevError: [Easy Development Controls]%s" .. message, filename, ...))
    end
end

function EasyDevControlsLogging.devHitTarget(targetName, targetText)
    -- if g_easyDevControlsDebugLevel > 3 and g_showDevelopmentWarnings then
    if g_easyDevControlsDevelopmentMode and g_showDevelopmentWarnings then
        if targetText ~= nil then
            targetText = " (" .. tostring(targetText) .. ")"
        end

        print(`  HitTarget: [Easy Development Controls] {targetName or "unknown"}{targetText or ""}`)
    end
end
