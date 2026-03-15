lu = require("luaunit")
package.path = package.path .. ";../?.lua;../util/?.lua"
require('CpObject')
require('CpUtil')
require('Logger')

---- Mocks (wish we had Mockito...) ----------------------------------------
---
local lastOutput = nil
local originalPrint = print
function print(...)
    lastOutput = select(1, ...)
    originalPrint(...)
end

-- mock the date/time functions for both standalone and in-game mode to just 0, so we can compare the output
function os.date()
    return '2025-01-04T12:00:00'
end

function getTimeSec()
    return 0.0
end

g_updateLoopIndex = 1

CpUtil.try = function(func, ...)
    return func(...)
end

CpDebug = {
    getText = function(self, channel)
        return string.format('channel %d', channel)
    end
}

local function setRunningInGame(runningInGame)
    CourseGenerator = {
        isRunningInGame = function()
            return runningInGame
        end
    }
end

---@param expectedText string
---@param expectedChannel number
local function assertLastOutput(expectedText, expectedChannel)
    if expectedText == nil then
        lu.assertEquals(lastOutput, nil)
    elseif CourseGenerator.isRunningInGame() then
        -- timestamp is seconds since game start, update loop index is mod 100
        lu.assertEquals(lastOutput, '0.000' .. ' [' .. CpDebug:getText(expectedChannel) .. ' 01] ' .. expectedText)
    else
        lu.assertEquals(lastOutput, os.date() .. ' ' .. expectedText)
    end
    lastOutput = nil
end

function testStandalone()
    setRunningInGame(false)
    local logger = Logger(nil, Logger.level.trace)
    logger:info("Info")
    assertLastOutput("[INFO]: Info")
    logger:trace("Trace")
    assertLastOutput("[TRACE]: Trace")
    logger:debug("Debug")
    assertLastOutput("[DEBUG]: Debug")
    logger:warning("Warning")
    assertLastOutput("[WARNING]: Warning")
    logger:error("Error")
    assertLastOutput("[ERROR]: Error")
end

function testLevels()
    setRunningInGame(false)
    local logger = Logger(nil, Logger.level.debug)
    logger:info("Info")
    assertLastOutput("[INFO]: Info")
    logger:trace("Trace")
    assertLastOutput(nil)
    logger:setLevel(Logger.level.warning)
    logger:debug("Debug")
    assertLastOutput(nil)
    logger:setLevel(Logger.level.error)
    logger:warning("Warning")
    assertLastOutput(nil)
    logger:error("Error")
    assertLastOutput("[ERROR]: Error")
end

function testPrefixStandalone()
    setRunningInGame(false)
    local logger = Logger('Prefix', Logger.level.debug)
    logger:debug("Debug")
    assertLastOutput("[DEBUG] Prefix: Debug")
end

function testChannelStandalone()
    setRunningInGame(false)
    local logger = Logger('Channel', Logger.level.debug, 42)
    logger:debug("ignored")
    assertLastOutput("[DEBUG] Channel: ignored")
end

local function setChannelActive(channel, isActive)
    CpDebug.isChannelActive = function(self, c)
        return c == channel and isActive
    end
end

function testChannelInGame()
    setRunningInGame(true)
    local myChannel = 23
    local logger = Logger('Prefix', Logger.level.trace, myChannel)
    setChannelActive(myChannel, true)
    logger:debug('Debug')
    assertLastOutput("[DEBUG] Prefix: Debug", myChannel)
    setChannelActive(myChannel, false)
    logger:debug('Debug 2')
    -- no output with inactive channel
    assertLastOutput(nil)
end

local function setVehicleActive(vehicle, isActive)
    CpDebug.isVehicleDebugActive = function(self, v)
        return v == vehicle and isActive
    end
end

CpUtil.getName = function(vehicle)
    return 'vehicle'
end

function testVehicleInGame()
    setRunningInGame(true)
    local myChannel = 23
    local logger = Logger('Prefix', Logger.level.trace, myChannel)
    setChannelActive(myChannel, true)
    local vehicle = {}
    setVehicleActive(vehicle, true)
    logger:debug(vehicle, 'Debug')
    assertLastOutput("[DEBUG] [vehicle] Prefix: Debug", myChannel)
    setVehicleActive(vehicle, false)
    assertLastOutput(nil)
end

os.exit(lu.LuaUnit.run())
