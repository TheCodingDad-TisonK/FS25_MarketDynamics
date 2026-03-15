--
-- AdvancedFarmManager - HotKey Vehicle
--


HotKeyVehicle = {}
HotKeyVehicle.inputName  = "HotKeyVehicle"
HotKeyVehicle.modDir     = g_HotKeyVehicleSystem.modDir
HotKeyVehicle.debugMulti = false


function HotKeyVehicle.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(Enterable, specializations)
end


function HotKeyVehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getHotKeyVehicleState", HotKeyVehicle.getHotKeyVehicleState)
    SpecializationUtil.registerFunction(vehicleType, "setHotKeyNickName", HotKeyVehicle.setHotKeyNickName)
    SpecializationUtil.registerFunction(vehicleType, "setHotKeyVehicleState", HotKeyVehicle.setHotKeyVehicleState)
    SpecializationUtil.registerFunction(vehicleType, "getHKParkVehicleState", HotKeyVehicle.getHKParkVehicleState)
    SpecializationUtil.registerFunction(vehicleType, "setHKParkVehicleState", HotKeyVehicle.setHKParkVehicleState)
end


function HotKeyVehicle.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getName", HotKeyVehicle.getName)
end


function HotKeyVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad", HotKeyVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream", HotKeyVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream", HotKeyVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream", HotKeyVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream", HotKeyVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onDelete", HotKeyVehicle)
end


function HotKeyVehicle:onLoad(savegame)
    self.spec_hotKeyVehicle = {}
    local spec = self.spec_hotKeyVehicle

    if g_dedicatedServerInfo == nil then
        local modSettingsDir = getUserProfileAppPath() .. "modSettings"
        local xmlFile        = modSettingsDir .. "/HotKeyVehicle.xml"
        local id             = nil

        if not fileExists(xmlFile) then
            createFolder(modSettingsDir)
            local xml = createXMLFile("HotKeyVehicle", xmlFile, "HotKeyVehicle")
            id        = HotKeyVehicle.randomString(25)
            setXMLString(xml, "HotKeyVehicle#uniqueUserId", id)
            saveXMLFile(xml)
            delete(xml)
        else
            local xml = loadXMLFile("HotKeyVehicle", xmlFile)
            id        = getXMLString(xml, "HotKeyVehicle#uniqueUserId")
            delete(xml)
        end
        spec.uniqueUserId = id
        if g_HotKeyVehicleSystem ~= nil then
            g_HotKeyVehicleSystem:setLocalUniqueUserId(id)
        end
    else
        spec.uniqueUserId = "dedi"
    end

    spec.dirtyFlag = self:getNextDirtyFlag()
    spec.state     = {}
    spec.parked    = false

    local isEmpty  = true

    if savegame ~= nil then
        local i = 0
        while true do

            local key = string.format("%s.%s.HotKeyVehicle.player(%d)", savegame.key, g_HotKeyVehicleSystem.modName, i)

            if not hasXMLProperty(savegame.xmlFile.handle, key) then
                break
            end
            local id     = getXMLString(savegame.xmlFile.handle, key .. "#id")
            local value  = getXMLInt(savegame.xmlFile.handle, key .. "#hotKeyIndex")
            if id ~= nil and value ~= nil then
                spec.state[id] = value
                isEmpty        = false
            end
            i = i + 1
        end

        local nickKey = string.format("%s.%s.HotKeyVehicle", savegame.key, g_HotKeyVehicleSystem.modName)
        spec.nickname = Utils.getNoNil(getXMLString(savegame.xmlFile.handle, nickKey .. "#nickname"), "")

        if not g_currentMission.missionDynamicInfo.isMultiplayer then
            local parkKey = string.format("%s.%s.HotKeyVehicle", savegame.key, g_HotKeyVehicleSystem.modName)
            spec.parked   = Utils.getNoNil(getXMLBool(savegame.xmlFile.handle, parkKey .. "#isParked"), false)
        else
            spec.parked   = false
        end
    end

    if isEmpty or spec.state[spec.uniqueUserId] == nil then
        spec.state[spec.uniqueUserId] = 0
    end

    if spec.parked == nil then
        spec.parked = not self.spec_enterable:getIsTabbable()
    end

    if spec.nickname == nil then
        spec.nickname = ""
    end

    if not g_currentMission.missionDynamicInfo.isMultiplayer and self.getParkVehicleState == nil then
        -- only no MP, park mod not loaded
        self.spec_enterable:setIsTabbable(not spec.parked)
    end

    spec.registrationKey = g_HotKeyVehicleSystem:registerInstance(self)
end


function HotKeyVehicle:setHotKeyNickName(newValue)
    local spec = self.spec_hotKeyVehicle

    spec.nickname = newValue
    self:raiseDirtyFlags(spec.dirtyFlag)
    self:raiseActive()
end


function HotKeyVehicle:setHKParkVehicleState(newValue)
    local spec = self.spec_hotKeyVehicle

    if self.getParkVehicleState ~= nil and self.setParkVehicleState ~= nil then
        if AdvancedFarmManager.debug then
            print("~~ AdvancedFarmManager Debug ... parkedVehicles mod detected, using")
        end
        self:setParkVehicleState(not self:getParkVehicleState())
    else
        if AdvancedFarmManager.debug then
            print("~~ AdvancedFarmManager Debug ... parkedVehicles mod NOT detected, internal")
        end
        self.spec_enterable:setIsTabbable(not newValue)
    end

    spec.parked = newValue
    self:raiseDirtyFlags(spec.dirtyFlag)
end


function HotKeyVehicle:getHKParkVehicleState()
    local spec            = self.spec_hotKeyVehicle
    local currentIsParked = false

    if self.getParkVehicleState ~= nil then
        return self:getParkVehicleState()
    end

    if self.spec_enterable.getIsTabbable == nil then
        currentIsParked = false
    end

    currentIsParked = not self.spec_enterable:getIsTabbable()

    if currentIsParked ~= spec.parked then
        self:setHKParkVehicleState(currentIsParked)
    end

    return currentIsParked
end


function HotKeyVehicle:setHotKeyVehicleState(newValue, uniqueUserId)
    local spec = self.spec_hotKeyVehicle

    spec.state[uniqueUserId] = newValue
    self:raiseDirtyFlags(spec.dirtyFlag)
end


function HotKeyVehicle:getHotKeyVehicleState(uniqueUserId)
    local spec = self.spec_hotKeyVehicle

    if spec.state[uniqueUserId] == nil then
        return 0
    end

    return spec.state[uniqueUserId]
end


function HotKeyVehicle:getName(superFunc)
    local spec         = self.spec_hotKeyVehicle
    local originalName = superFunc(self)

    if spec ~= nil and spec.nickname ~= nil and spec.nickname ~= "" then
        originalName = originalName .. " [" .. spec.nickname .. "]"
    end

    return originalName
end


function HotKeyVehicle:onDelete()
    local spec = self.spec_hotKeyVehicle
    if spec ~= nil and spec.registrationKey ~= nil then
      g_HotKeyVehicleSystem:unregisterInstance(spec.registrationKey)
    end
end


--Called on server side on join
function HotKeyVehicle:onWriteStream(streamId, connection)
    local spec  = self.spec_hotKeyVehicle
    local count = 0

    if HotKeyVehicle.debugMulti then
        print(" ~~HKV | processing vehicle: " .. self:getName())
        DebugUtil.printTableRecursively(spec, " ~~HKV | spec[onWriteStream]:", 0, 1)
    end

    for k in pairs(spec.state) do
        count = count + 1
    end
    streamWriteInt32(streamId, count)
    for k, v in pairs(spec.state) do
        streamWriteString(streamId, k)
        streamWriteInt32(streamId, v)
    end

    if streamWriteBool(streamId, spec.nickname ~= nil) then
        streamWriteString(streamId, spec.nickname)
    end

    if streamWriteBool(streamId, spec.parked ~= nil) then
        if g_currentMission.missionDynamicInfo.isMultiplayer then
            streamWriteBool(streamId, false)
        else
            streamWriteBool(streamId, spec.parked)
        end
    end
end


--Called on client side on join
function HotKeyVehicle:onReadStream(streamId, connection)
    local spec   = self.spec_hotKeyVehicle
    local state  = {}
    local count  = streamReadInt32(streamId)
    local i      = 0

    while i < count do
        local id     = streamReadString(streamId)
        local value  = streamReadInt32(streamId)

        if HotKeyVehicle.debugMulti then
            print(" ~~HKV | Got info::id:" .. tostring(id) .. " val:" .. tostring(value))
        end

        state[id]    = value
        i            = i + 1
    end

    if HotKeyVehicle.debugMulti then
        DebugUtil.printTableRecursively(state, " ~~HKV | state table:", 0, 1)
    end

    spec.state    = state

    if streamReadBool(streamId) then
        spec.nickname = streamReadString(streamId)
        if HotKeyVehicle.debugMulti then
            print(" ~~HKV | Got NickName: (" .. tostring(spec.nickname) .. ")")
        end
    else
        spec.nickname = ""
    end

    if streamReadBool(streamId) then
        spec.parked = streamReadBool(streamId)
        if HotKeyVehicle.debugMulti then
            print(" ~~HKV | Got Parked: (" .. tostring(spec.parked) .. ")")
        end
        if not g_currentMission.missionDynamicInfo.isMultiplayer then
            self.spec_enterable:setIsTabbable(not spec.parked)
        end
    end

    if HotKeyVehicle.debugMulti then
        DebugUtil.printTableRecursively(spec, " ~~HKV | spec[onReadStream]:", 0, 1)
    end
end


function HotKeyVehicle:onWriteUpdateStream(streamId, connection, dirtyMask)
    if connection:getIsServer() then
        local spec = self.spec_hotKeyVehicle

        -- DebugUtil.printTableRecursively(spec, " ~~HKV | spec[onWriteUpdateStream]:", 0, 1)

        if streamWriteBool(streamId, bitAND(dirtyMask, spec.dirtyFlag) ~= 0) then
            streamWriteString(streamId, spec.uniqueUserId)
            streamWriteInt32(streamId, Utils.getNoNil(spec.state[spec.uniqueUserId],0))
            streamWriteBool(streamId, Utils.getNoNil(spec.parked,false))
            streamWriteString(streamId, Utils.getNoNil(spec.nickname, ""))
        end
    end
end


function HotKeyVehicle:onReadUpdateStream(streamId, timestamp, connection)
    if not connection:getIsServer() then
        local spec = self.spec_hotKeyVehicle

        -- DebugUtil.printTableRecursively(spec, " ~~HKV | spec[onReadUpdateStream][pre]:", 0, 1)

        if streamReadBool(streamId) then
            local id        = streamReadString(streamId)
            local value     = streamReadInt32(streamId)
            spec.state[id]  = value
            if not g_currentMission.missionDynamicInfo.isMultiplayer then
                spec.parked     = streamReadBool(streamId)
            end
            spec.nickname   = streamReadString(streamId)
        end

        g_server:broadcastEvent(HotKeyNameChangeEvent.new(self), false)

        -- DebugUtil.printTableRecursively(spec, " ~~HKV | spec[onReadUpdateStream][post]:", 0, 1)
    end
end


function HotKeyVehicle:saveToXMLFile(xmlFile, path)
    local spec = self.spec_hotKeyVehicle
    local i    = 0
    for id, value in pairs(spec.state) do
        setXMLString(xmlFile.handle, string.format("%s.player(%d)#id", path, i), id)
        setXMLInt(xmlFile.handle, string.format("%s.player(%d)#hotKeyIndex", path, i), value)
        i = i + 1
    end
    setXMLString(xmlFile.handle, string.format("%s#nickname", path), (spec.nickname or ""))
    setXMLBool(xmlFile.handle, string.format("%s#isParked", path), (spec.parked or false))
end


function HotKeyVehicle.randomString(length)
    local charset = {} -- [0-9a-zA-Z]
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end

    local function randomString(length)
        if not length or length <= 0 then
            return ""
        end
        math.randomseed(getDate("%d%m%y%H%M%S"))
        return randomString(length - 1) .. charset[math.random(1, #charset)]
    end

    return randomString(length)
end



HotKeyNameChangeEvent = {}
local HotKeyNameChangeEvent_mt = Class(HotKeyNameChangeEvent, Event)

InitEventClass(HotKeyNameChangeEvent, "HotKeyNameChangeEvent")


function HotKeyNameChangeEvent.emptyNew()
    local self = Event.new(HotKeyNameChangeEvent_mt)

    return self
end


function HotKeyNameChangeEvent.new(thisVehicle)
    local self = HotKeyNameChangeEvent.emptyNew()

    assert(g_server ~= nil, "Server->client event")

    self.thisVehicle = thisVehicle

    return self
end


function HotKeyNameChangeEvent:readStream(streamId, connection)
    self.thisVehicle = NetworkUtil.readNodeObject(streamId)

    if ( self.thisVehicle.spec_hotKeyVehicle ~= nil ) then
        self.thisVehicle.spec_hotKeyVehicle.nickname = streamReadString(streamId)
    end

    self:run(connection)
end


function HotKeyNameChangeEvent:writeStream(streamId, connection)
    local spec = self.thisVehicle.spec_hotKeyVehicle

    NetworkUtil.writeNodeObject(streamId, self.thisVehicle)
    streamWriteString(streamId, Utils.getNoNil(spec.nickname, ""))
end


function HotKeyNameChangeEvent:run(connection)
    if g_gui.currentGui ~= nil  and g_gui.currentGui.name == "AFMGui" and g_gui.currentGui.target.currentPageName == "AFMGuiVehicle" then
        g_gui.currentGui.target.pageAFMVehicles:rebuildTable()
    end
end
