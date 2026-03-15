WashVehicleEvent = {}
local WashVehicleEvent_mt = Class(WashVehicleEvent, Event)

InitEventClass(WashVehicleEvent, "WashVehicleEvent")

function WashVehicleEvent.emptyNew()
    afmDebug(' Info: WashVehicleEvent:emptyNew')
    return Event.new(WashVehicleEvent_mt)
end

function WashVehicleEvent.new(vehicle)
    afmDebug(' Info: WashVehicleEvent:new')
    local self = WashVehicleEvent.emptyNew()

    self.vehicle = vehicle

    return self
end

function WashVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: WashVehicleEvent:readStream')

    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function WashVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: WashVehicleEvent:writeStream')

    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function WashVehicleEvent:run(connection)
    afmDebug(' Info: WashVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: WashVehicleEvent:run:notServer')
        g_server:broadcastEvent(WashVehicleEvent.new(self.vehicle))
    end

    self:washVehicle(self.vehicle)
end

function WashVehicleEvent.sendEvent(vehicle)
    afmDebug(' Info: WashVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(WashVehicleEvent.new(vehicle))
        else
            g_client:getServerConnection():sendEvent(WashVehicleEvent.new(vehicle))
        end
    else
        WashVehicleEvent:washVehicle(vehicle)
    end
end

function WashVehicleEvent:washVehicle(vehicle)
    afmDebug(' Info: WashVehicleEvent:washVehicle')
    if vehicle ~= nil and vehicle.spec_washable ~= nil and vehicle.spec_washable.washableNodes ~= nil then
        for _, nodeData in ipairs(vehicle.spec_washable.washableNodes) do
            vehicle.spec_washable:setNodeDirtAmount(nodeData, 0, true)
        end
    end

    -- Reload the table for the player
    if g_gui.currentGui ~= nil and g_gui.currentGui.target ~= nil then 
        if g_gui.currentGui.target.pageAFMVehicles ~= nil then
            g_gui.currentGui.target.pageAFMVehicles:rebuildTable()
        end
        if g_gui.currentGui.target.pageAFMImplements ~= nil then
            g_gui.currentGui.target.pageAFMImplements:rebuildTable()
        end
    end
end