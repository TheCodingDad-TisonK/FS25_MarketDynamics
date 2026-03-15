-- ParkVehicle
--
-- @author  Grisu118 - VertexDezign.net
-- @history     v1.0.0.0 - 2017-09-15 - Initial implementation
--              v1.0.1.0 - 2017-10-15 - Fix random toggle
--              v2.0.0.0 - 2018-12-03 - FS19
--              v2.1.0.0 - 2019-04-01 - Support all enterable vehicles, create modSettings folder
--              v3.0.0.0 - 2021-11-19 - FS22
--              v3.1.0.0 - 2022-04-23 - Add possibiltiy to unpark all, fix issue with registration in loader
--              v4.0.0.0 - 2024-11-09 - FS25
-- @Descripion: Allows temporary disabling of the tab function
-- @web: https://grisu118.ch or https://vertexdezign.net
-- Copyright (C) Grisu118, All Rights Reserved.

---@class ParkVehicle
ParkVehicle = {}
ParkVehicle.inputName = "parkVehicle"
ParkVehicle.modDir = g_parkVehicleSystem.modDir

function ParkVehicle.prerequisitesPresent(specializations)
  return SpecializationUtil.hasSpecialization(Enterable, specializations)
end

function ParkVehicle.registerFunctions(vehicleType)
  SpecializationUtil.registerFunction(vehicleType, "getParkVehicleState", ParkVehicle.getParkVehicleState)
  SpecializationUtil.registerFunction(vehicleType, "setParkVehicleState", ParkVehicle.setParkVehicleState)
  SpecializationUtil.registerFunction(vehicleType, "parkVehicleRender", ParkVehicle.parkVehicleRender)
end

function ParkVehicle.registerEventListeners(vehicleType)
  SpecializationUtil.registerEventListener(vehicleType, "onLoad", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onUpdate", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onWriteStream", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onReadStream", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents", ParkVehicle)
  SpecializationUtil.registerEventListener(vehicleType, "onDelete", ParkVehicle)
end

function ParkVehicle:onLoad(savegame)
  self.spec_parkvehicle = {}
  local spec = self.spec_parkvehicle

  if g_dedicatedServerInfo == nil then
    local modSettingsDir = getUserProfileAppPath() .. "modSettings"
    local xmlFile = modSettingsDir .. "/parkVehicle.xml"
    local id = g_currentMission.playerNickname
    if not fileExists(xmlFile) then
      createFolder(modSettingsDir)
      local xml = createXMLFile("ParkVehicle", xmlFile, "ParkVehicle")
      if id == nil then
        id = ParkVehicle.randomString(25)
      end
      setXMLString(xml, "ParkVehicle#uniqueUserId", id)
      saveXMLFile(xml)
      delete(xml)
    else
      local xml = loadXMLFile("ParkVehicle", xmlFile)
      id = getXMLString(xml, "ParkVehicle#uniqueUserId")
      delete(xml)
    end
    spec.uniqueUserId = id
  else
    spec.uniqueUserId = "dedi"
  end

  spec.inputPressed = false
  spec.registrationKey = nil
  spec.actionEvents = {}
  spec.icon = createImageOverlay(ParkVehicle.modDir .. "icon.png")
  spec.overlay = createImageOverlay(ParkVehicle.modDir .. "overlay.png")
  spec.dirtyFlag = self:getNextDirtyFlag()

  spec.state = {}

  local isEmpty = true
  if savegame ~= nil then
    local i = 0
    while true do

      local legacykey = string.format("%s.ParkVehicle.player(%d)", savegame.key, i) -- TODO Remove with next release
      local key = string.format("%s.%s.ParkVehicle.player(%d)", savegame.key, g_parkVehicleSystem.modName, i)
      if not hasXMLProperty(savegame.xmlFile.handle, key) then
        key = legacykey
      end
      if not hasXMLProperty(savegame.xmlFile.handle, key) then
        break
      end
      local id = getXMLString(savegame.xmlFile.handle, key .. "#id")
      local value = getXMLBool(savegame.xmlFile.handle, key .. "#isParked")
      if id ~= nil and value ~= nil then
        spec.state[id] = value
        isEmpty = false
      end
      i = i + 1
    end
  end

  if isEmpty or spec.state[spec.uniqueUserId] == nil then
    spec.state[spec.uniqueUserId] = false
  end

  self.spec_enterable:setIsTabbable(not spec.state[spec.uniqueUserId])
  spec.registrationKey = g_parkVehicleSystem:registerInstance(self)
end

function ParkVehicle:onUpdate(dt, isActiveForInput, isSelected)
  if self.isClient then
    local spec = self.spec_parkvehicle
    if spec.inputPressed then
      local newValue = not self:getParkVehicleState()
      self:setParkVehicleState(newValue)
      spec.inputPressed = false
    end
  end
end

---@param newValue boolean
function ParkVehicle:setParkVehicleState(newValue)
  local spec = self.spec_parkvehicle
  self.spec_enterable:setIsTabbable(not newValue)
  spec.state[spec.uniqueUserId] = newValue
  self:raiseDirtyFlags(spec.dirtyFlag)
end

---@return boolean
function ParkVehicle:getParkVehicleState()
  local spec = self.spec_parkvehicle
  return spec.state[spec.uniqueUserId]
end

function ParkVehicle:parkVehicleRender()
  if self.isClient and self:getIsActive() then
    local spec = self.spec_parkvehicle
    local uiScale = g_gameSettings:getValue("uiScale")
    local speedMeter = g_currentMission.hud.speedMeter

    local iconWidth = 0.011 * uiScale
    local iconHeight = iconWidth * g_screenAspectRatio

    local startX = speedMeter.x + speedMeter.aiIconOffsetX - (iconWidth * 1.5)
    local startY = speedMeter.y + speedMeter.aiIconOffsetY + (iconHeight / 4)

    renderOverlay(spec.icon, startX, startY, iconWidth, iconHeight)
    if spec.state[spec.uniqueUserId] then
      renderOverlay(spec.overlay, startX, startY, iconWidth, iconHeight)
    end
  end
end

function ParkVehicle:onDelete()
  local spec = self.spec_parkvehicle
  if spec ~= nil then
    g_parkVehicleSystem:unregisterInstance(spec.registrationKey)
  end
end

--Called on server side on join
-- @param integer streamId streamId
-- @param integer connection connection
function ParkVehicle:onWriteStream(streamId, connection)
  local spec = self.spec_parkvehicle
  local count = 0
  for k in pairs(spec.state) do
    count = count + 1
  end
  streamWriteInt32(streamId, count)
  for k, v in pairs(spec.state) do
    streamWriteString(streamId, k)
    streamWriteBool(streamId, v)
  end
end

--Called on client side on join
-- @param integer streamId streamId
-- @param integer connection connection
function ParkVehicle:onReadStream(streamId, connection)
  local spec = self.spec_parkvehicle
  local state = {}
  local count = streamReadInt32(streamId)
  local i = 0
  while i < count do
    local id = streamReadString(streamId)
    local value = streamReadBool(streamId)
    state[id] = value
    if id == spec.uniqueUserId then
      self.spec_enterable:setIsTabbable(not value)
    end
    i = i + 1
  end
  spec.state = state
end

function ParkVehicle:onWriteUpdateStream(streamId, connection, dirtyMask)
  if connection:getIsServer() then
    local spec = self.spec_parkvehicle
    if streamWriteBool(streamId, bitAND(dirtyMask, spec.dirtyFlag) ~= 0) then
      streamWriteString(streamId, spec.uniqueUserId)
      streamWriteBool(streamId, spec.state[spec.uniqueUserId])
    end
  end
end

function ParkVehicle:onReadUpdateStream(streamId, timestamp, connection)
  if not connection:getIsServer() then
    local spec = self.spec_parkvehicle
    if streamReadBool(streamId) then
      local id = streamReadString(streamId)
      local value = streamReadBool(streamId)
      if id == spec.uniqueUserId then
        self.spec_enterable:setIsTabbable(not value)
      end
      spec.state[id] = value
    end
  end
end

function ParkVehicle:onRegisterActionEvents(isActiveForInput)
  if self.isClient then
    local spec = self.spec_parkvehicle
    self:clearActionEventsTable(spec.actionEvents)

    if self:getIsActiveForInput(true) then
      local _, actionEventId =
        self:addActionEvent(
        spec.actionEvents,
        "PARKVEHICLE_01",
        self,
        ParkVehicle.actionEventParkVehicle,
        false,
        true,
        false,
        true,
        nil
      )

      g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)

      local _, unparkAllEventId =
      self:addActionEvent(
          spec.actionEvents,
          "PARKVEHICLE_UNPARK_ALL",
          self,
          ParkVehicle.actionEventUnparkAll,
          false,
          true,
          false,
          true,
          nil
      )

      g_inputBinding:setActionEventTextPriority(unparkAllEventId, GS_PRIO_VERY_LOW)
    end
  end
end

function ParkVehicle:actionEventUnparkAll(self)
  g_parkVehicleSystem:unparkAll()
end

function ParkVehicle.actionEventParkVehicle(self, actionName, inputValue, callbackState, isAnalog)
  local spec = self.spec_parkvehicle
  spec.inputPressed = true
end

function ParkVehicle:saveToXMLFile(xmlFile, path)
  local spec = self.spec_parkvehicle
  local i = 0
  for id, value in pairs(spec.state) do
    setXMLString(xmlFile.handle, string.format("%s.player(%d)#id", path, i), id)
    setXMLBool(xmlFile.handle, string.format("%s.player(%d)#isParked", path, i), value)
    i = i + 1
  end
end

function ParkVehicle.randomString(length)
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
    return randomString(length - 1) .. charset[math.random(1, #charset)]
  end

  return randomString(length)
end
