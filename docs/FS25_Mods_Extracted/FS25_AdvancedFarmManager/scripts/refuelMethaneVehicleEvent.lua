RefuelMethaneVehicleEvent = {}
local RefuelMethaneVehicleEvent_mt = Class(RefuelMethaneVehicleEvent, Event)

InitEventClass(RefuelMethaneVehicleEvent, "RefuelMethaneVehicleEvent")

function RefuelMethaneVehicleEvent.emptyNew()
    afmDebug(' Info: RefuelMethaneVehicleEvent:emptyNew')
    return Event.new(RefuelMethaneVehicleEvent_mt)
end

function RefuelMethaneVehicleEvent.new(farmId, vehicle)
    afmDebug(' Info: RefuelMethaneVehicleEvent:new')
    local self = RefuelMethaneVehicleEvent.emptyNew()

    self.farmId = farmId
    self.vehicle = vehicle

    return self
end

function RefuelMethaneVehicleEvent:readStream(streamId, connection)
    afmDebug(' Info: RefuelMethaneVehicleEvent:readStream')

    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self:run(connection)
end

function RefuelMethaneVehicleEvent:writeStream(streamId, connection)
    afmDebug(' Info: RefuelMethaneVehicleEvent:writeStream')

    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function RefuelMethaneVehicleEvent:run(connection)
    afmDebug(' Info: RefuelMethaneVehicleEvent:run') 

    if not connection:getIsServer() then
        afmDebug(' Info: RefuelMethaneVehicleEvent:run:notServer')
        g_server:broadcastEvent(RefuelMethaneVehicleEvent.new(self.farmId, self.vehicle))
    end

    self:refuelVehicle(self.farmId, self.vehicle)
end

function RefuelMethaneVehicleEvent.sendEvent(farmId, vehicle)
    afmDebug(' Info: RefuelMethaneVehicleEvent:sendEvent')
    if g_currentMission.missionDynamicInfo.isMultiplayer then 
        if g_server ~= nil then
            g_server:broadcastEvent(RefuelMethaneVehicleEvent.new(farmId, vehicle))
        else
            g_client:getServerConnection():sendEvent(RefuelMethaneVehicleEvent.new(farmId, vehicle))
        end
    else
        RefuelMethaneVehicleEvent:refuelVehicle(farmId, vehicle)
    end
end

function RefuelMethaneVehicleEvent:refuelVehicle(farmId, vehicle)
    afmDebug(' Info: RefuelMethaneVehicleEvent:refuelVehicle')
    -- Convert the argument to a number, default to 10 billion if invalid
    local desiredFuelLevel = 10000000000

    -- Check if vehicle can consume fuel
    if vehicle.getConsumerFillUnitIndex == nil then
        return "Vehicle has no consumer"
    end

    -- Try to get the fill unit index for supported fuel types
    local fillUnitIndex = vehicle:getConsumerFillUnitIndex(FillType.METHANE)

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