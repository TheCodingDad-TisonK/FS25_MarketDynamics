RepaintVehicleEvent = {}
local RepaintVehicleEvent_mt = Class(RepaintVehicleEvent, Event)

InitEventClass(RepaintVehicleEvent, "RepaintVehicleEvent")

function RepaintVehicleEvent.emptyNew()
    afmDebug(' Info: RepaintVehicleEvent:emptyNew')
    return Event.new(RepaintVehicleEvent_mt)
end

function RepaintVehicleEvent.new(vehicle)
    afmDebug(' Info: RepaintVehicleEvent:new')
    local self = RepaintVehicleEvent.emptyNew()

    self.vehicle = vehicle

    return self
end

function RepaintVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: RepaintVehicleEvent:readStream')

    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function RepaintVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: RepaintVehicleEvent:writeStream')

    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function RepaintVehicleEvent:run(connection)
    afmDebug(' Info: RepaintVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: RepaintVehicleEvent:run:notServer')
        g_server:broadcastEvent(RepaintVehicleEvent.new(self.vehicle))
    end

    self:repaintVehicle(self.vehicle)
end

function RepaintVehicleEvent.sendEvent(vehicle)
    afmDebug(' Info: RepaintVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(RepaintVehicleEvent.new(vehicle))
        else
            g_client:getServerConnection():sendEvent(RepaintVehicleEvent.new(vehicle))
        end
    else
        RepaintVehicleEvent:repaintVehicle(vehicle)
    end
end

function RepaintVehicleEvent:repaintVehicle(vehicle)
    afmDebug(' Info: RepaintVehicleEvent:repaintVehicle')
    if vehicle ~= nil and vehicle.spec_wearable ~= nil and vehicle.spec_wearable.wearableNodes ~= nil then
        for _, wearNode in ipairs(vehicle.spec_wearable.wearableNodes) do
            vehicle:setNodeWearAmount(wearNode, 0, true)
        end
        g_farmManager:updateFarmStats(vehicle:getOwnerFarmId(), "repaintVehicleCount", 1)
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