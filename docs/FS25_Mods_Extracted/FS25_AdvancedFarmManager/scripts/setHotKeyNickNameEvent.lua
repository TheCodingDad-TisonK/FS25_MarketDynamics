---@class SetHotKeyNickNameEvent
SetHotKeyNickNameEvent = {}
local SetHotKeyNickNameEvent_mt = Class(SetHotKeyNickNameEvent, Event)

InitEventClass(SetHotKeyNickNameEvent, "SetHotKeyNickNameEvent")

function SetHotKeyNickNameEvent.emptyNew()
	return Event.new(SetHotKeyNickNameEvent_mt)
end

function SetHotKeyNickNameEvent.new(vehicle, vehicleNickName)
	local self = SetHotKeyNickNameEvent.emptyNew()
  self.vehicle = vehicle
  self.vehicleNickName = vehicleNickName
	return self
end

function SetHotKeyNickNameEvent:readStream(streamId, connection)
  -- Get data from clients
  self.vehicle = NetworkUtil.readNodeObject(streamId)
  self.vehicleNickName = streamReadString(streamId)
	self:run(connection)
end

function SetHotKeyNickNameEvent:writeStream(streamId, connection)
  -- Send data out to clients
  NetworkUtil.writeNodeObject(streamId, self.vehicle)
  streamWriteString(streamId, self.vehicleNickName)
end

function SetHotKeyNickNameEvent:run(connection)
    afmDebug(' Info: SetHotKeyNickNameEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: SetHotKeyNickNameEvent:run:notServer')
        g_server:broadcastEvent(SetHotKeyNickNameEvent.new(self.vehicle, self.vehicleNickName))
    end

    self:updateHotKey(self.vehicle, self.vehicleNickName)
end

function SetHotKeyNickNameEvent.sendEvent(vehicle, vehicleNickName)
  if g_currentMission.missionDynamicInfo.isMultiplayer then 
      if g_server ~= nil then
          g_server:broadcastEvent(SetHotKeyNickNameEvent.new(vehicle, vehicleNickName))
      else
          g_client:getServerConnection():sendEvent(SetHotKeyNickNameEvent.new(vehicle, vehicleNickName))
      end
  else
      SetHotKeyNickNameEvent:updateHotKey(vehicle, vehicleNickName)
  end
end

function SetHotKeyNickNameEvent:updateHotKey(vehicle, vehicleNickName)
    afmDebug(' Info: SetHotKeyNickNameEvent:washVehicle')
    afmDebug(vehicleNickName)
    if vehicle ~= nil then
        if vehicleNickName:len() == 0 then
            vehicleNickName = ""
        end
        vehicle:setHotKeyNickName(vehicleNickName)
    end
end