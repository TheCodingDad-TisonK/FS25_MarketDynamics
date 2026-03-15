RepairVehicleEvent = {}
local RepairVehicleEvent_mt = Class(RepairVehicleEvent, Event)

InitEventClass(RepairVehicleEvent, "RepairVehicleEvent")

function RepairVehicleEvent.emptyNew()
    afmDebug(' Info: RepairVehicleEvent:emptyNew')
    return Event.new(RepairVehicleEvent_mt)
end

function RepairVehicleEvent.new(vehicle)
    afmDebug(' Info: RepairVehicleEvent:new')
    local self = RepairVehicleEvent.emptyNew()

    self.vehicle = vehicle

    return self
end

function RepairVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: RepairVehicleEvent:readStream')

    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function RepairVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: RepairVehicleEvent:writeStream')

    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function RepairVehicleEvent:run(connection)
    afmDebug(' Info: RepairVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: RepairVehicleEvent:run:notServer')
        g_server:broadcastEvent(RepairVehicleEvent.new(self.vehicle))
    end

    self:repairVehicle(self.vehicle)
end

function RepairVehicleEvent.sendEvent(vehicle)
    afmDebug(' Info: RepairVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(RepairVehicleEvent.new(vehicle))
        else
            g_client:getServerConnection():sendEvent(RepairVehicleEvent.new(vehicle))
        end
    else
        RepairVehicleEvent:repairVehicle(vehicle)
    end
end

function RepairVehicleEvent:repairVehicle(vehicle)
    afmDebug(' Info: RepairVehicleEvent:repairVehicle')
    if vehicle ~= nil and vehicle.spec_wearable ~= nil and vehicle.spec_wearable.wearableNodes ~= nil then
        for _, nodeData in ipairs(vehicle.spec_wearable.wearableNodes) do
            vehicle:setDamageAmount(0)
        end
        g_farmManager:updateFarmStats(vehicle:getOwnerFarmId(), "repairVehicleCount", 1)
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