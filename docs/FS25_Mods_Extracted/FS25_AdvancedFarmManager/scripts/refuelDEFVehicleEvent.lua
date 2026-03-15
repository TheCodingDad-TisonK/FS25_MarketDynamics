RefuelDEFVehicleEvent = {}
local RefuelDEFVehicleEvent_mt = Class(RefuelDEFVehicleEvent, Event)

InitEventClass(RefuelDEFVehicleEvent, "RefuelDEFVehicleEvent")

function RefuelDEFVehicleEvent.emptyNew()
    afmDebug(' Info: RefuelDEFVehicleEvent:emptyNew')
    return Event.new(RefuelDEFVehicleEvent_mt)
end

function RefuelDEFVehicleEvent.new(farmId, vehicle)
    afmDebug(' Info: RefuelDEFVehicleEvent:new')
    local self = RefuelDEFVehicleEvent.emptyNew()

    self.farmId = farmId
    self.vehicle = vehicle

    return self
end

function RefuelDEFVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: RefuelDEFVehicleEvent:readStream')

    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function RefuelDEFVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: RefuelDEFVehicleEvent:writeStream')

    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function RefuelDEFVehicleEvent:run(connection)
    afmDebug(' Info: RefuelDEFVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: RefuelDEFVehicleEvent:run:notServer')
        g_server:broadcastEvent(RefuelDEFVehicleEvent.new(self.farmId, self.vehicle))
    end

    self:refuelVehicle(self.farmId, self.vehicle)
end

function RefuelDEFVehicleEvent.sendEvent(farmId, vehicle)
    afmDebug(' Info: RefuelDEFVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(RefuelDEFVehicleEvent.new(farmId, vehicle))
        else
            g_client:getServerConnection():sendEvent(RefuelDEFVehicleEvent.new(farmId, vehicle))
        end
    else
        RefuelDEFVehicleEvent:refuelVehicle(farmId, vehicle)
    end
end

function RefuelDEFVehicleEvent:refuelVehicle(farmId, vehicle)
    afmDebug(' Info: RefuelDEFVehicleEvent:refuelVehicle')
    -- Convert the argument to a number, default to 10 billion if invalid
    local desiredFuelLevel = 10000000000

    -- Check if vehicle can consume fuel
    if vehicle.getConsumerFillUnitIndex == nil then
        return "Vehicle has no consumer"
    end

    -- Try to get the fill unit index for supported fuel types
    local fillUnitIndex = vehicle:getConsumerFillUnitIndex(FillType.DEF)

    if fillUnitIndex == nil then
        return "No Fuel fillType supported!"
    end

    -- Calculate the difference and add fuel accordingly
    local currentLevel = vehicle:getFillUnitFillLevel(fillUnitIndex)
    local fuelToAdd = desiredFuelLevel - currentLevel

    vehicle:addFillUnitFillLevel(
        farmId,
        fillUnitIndex,
        fuelToAdd,
        vehicle:getFillUnitFirstSupportedFillType(fillUnitIndex),
        ToolType.UNDEFINED,
        nil
    )

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