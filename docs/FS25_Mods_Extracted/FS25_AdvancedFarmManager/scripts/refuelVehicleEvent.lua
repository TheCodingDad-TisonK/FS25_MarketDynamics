RefuelVehicleEvent = {}
local RefuelVehicleEvent_mt = Class(RefuelVehicleEvent, Event)

InitEventClass(RefuelVehicleEvent, "RefuelVehicleEvent")

function RefuelVehicleEvent.emptyNew()
    afmDebug(' Info: RefuelVehicleEvent:emptyNew')
    return Event.new(RefuelVehicleEvent_mt)
end

function RefuelVehicleEvent.new(farmId, vehicle)
    afmDebug(' Info: RefuelVehicleEvent:new')
    local self = RefuelVehicleEvent.emptyNew()

    self.farmId = farmId
    self.vehicle = vehicle

    return self
end

function RefuelVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: RefuelVehicleEvent:readStream')

    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function RefuelVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: RefuelVehicleEvent:writeStream')

    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function RefuelVehicleEvent:run(connection)
    afmDebug(' Info: RefuelVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: RefuelVehicleEvent:run:notServer')
        g_server:broadcastEvent(RefuelVehicleEvent.new(self.farmId, self.vehicle))
    end

    self:refuelVehicle(self.farmId, self.vehicle)
end

function RefuelVehicleEvent.sendEvent(farmId, vehicle)
    afmDebug(' Info: RefuelVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(RefuelVehicleEvent.new(farmId, vehicle))
        else
            g_client:getServerConnection():sendEvent(RefuelVehicleEvent.new(farmId, vehicle))
        end
    else
        RefuelVehicleEvent:refuelVehicle(farmId, vehicle)
    end
end

function RefuelVehicleEvent:refuelVehicle(farmId, vehicle)
    afmDebug(' Info: RefuelVehicleEvent:refuelVehicle')
    -- Convert the argument to a number, default to 10 billion if invalid
    local desiredFuelLevel = 10000000000

    -- Check if vehicle can consume fuel
    if vehicle.getConsumerFillUnitIndex == nil then
        return "Vehicle has no consumer"
    end

    -- Try to get the fill unit index for supported fuel types
    local fillUnitIndex =
        vehicle:getConsumerFillUnitIndex(FillType.DIESEL) or
        vehicle:getConsumerFillUnitIndex(FillType.ELECTRICCHARGE) or
        vehicle:getConsumerFillUnitIndex(FillType.METHANE)

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