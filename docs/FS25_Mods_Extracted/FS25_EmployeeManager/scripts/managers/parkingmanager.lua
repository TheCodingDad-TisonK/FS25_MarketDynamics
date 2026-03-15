ParkingManager = {}

local ParkingManager_mt = Class(ParkingManager)

function ParkingManager:new()
    local self = setmetatable({}, ParkingManager_mt)
    self.spots = {}
    self.nextSpotId = 1
    CustomUtils:debug("[ParkingManager] Initialized")
    return self
end

---Adds a parking spot
---@param name string
---@param x number
---@param y number
---@param z number
---@param angle number Rotation angle in radians
---@return number spotId
function ParkingManager:addSpot(name, x, y, z, angle)
    local spot = {
        id = self.nextSpotId,
        name = name or ("Spot_" .. tostring(self.nextSpotId)),
        x = x,
        y = y,
        z = z,
        angle = angle or 0,
        vehicleId = nil,
    }
    table.insert(self.spots, spot)
    self.nextSpotId = self.nextSpotId + 1
    CustomUtils:info("[ParkingManager] Added spot '%s' (ID: %d) at %.1f, %.1f, %.1f", spot.name, spot.id, x, y, z)
    return spot.id
end

---Removes a parking spot by id
---@param id number
---@return boolean
function ParkingManager:removeSpot(id)
    for i, spot in ipairs(self.spots) do
        if spot.id == id then
            table.remove(self.spots, i)
            CustomUtils:info("[ParkingManager] Removed spot %d", id)
            return true
        end
    end
    return false
end

---Assigns a vehicle to a parking spot
---@param spotId number
---@param vehicleId number
---@return boolean
function ParkingManager:assignVehicle(spotId, vehicleId)
    for _, spot in ipairs(self.spots) do
        if spot.vehicleId == vehicleId then
            spot.vehicleId = nil
        end
    end

    for _, spot in ipairs(self.spots) do
        if spot.id == spotId then
            spot.vehicleId = vehicleId
            CustomUtils:info("[ParkingManager] Vehicle %d assigned to spot '%s' (ID: %d)", vehicleId, spot.name, spot.id)
            return true
        end
    end
    return false
end

---Returns the parking spot assigned to a vehicle
---@param vehicleId number
---@return table|nil spot
function ParkingManager:getSpotForVehicle(vehicleId)
    if vehicleId == nil then return nil end
    for _, spot in ipairs(self.spots) do
        if spot.vehicleId == vehicleId then
            return spot
        end
    end
    return nil
end

---Finds the nearest available (no vehicle assigned) spot
---@param x number
---@param z number
---@return table|nil spot
function ParkingManager:findNearestAvailableSpot(x, z)
    local best = nil
    local bestDist = math.huge

    for _, spot in ipairs(self.spots) do
        if spot.vehicleId == nil then
            local dx = spot.x - x
            local dz = spot.z - z
            local dist = math.sqrt(dx * dx + dz * dz)
            if dist < bestDist then
                bestDist = dist
                best = spot
            end
        end
    end
    return best
end

---Searches parking spots for a tool matching the given store category
---@param categoryName string
---@return table|nil vehicle, table|nil spot
function ParkingManager:findToolInParking(categoryName)
    if not g_currentMission or not g_currentMission.vehicleSystem then return nil, nil end

    for _, spot in ipairs(self.spots) do
        if spot.vehicleId then
            local vehicle = nil
            for _, v in ipairs(g_currentMission.vehicleSystem.vehicles) do
                if v.id == spot.vehicleId then
                    vehicle = v
                    break
                end
            end

            if vehicle and vehicle.storeItem and vehicle.storeItem.categoryName == categoryName then
                return vehicle, spot
            end
        end
    end
    return nil, nil
end

---Auto-creates a parking spot at the vehicle's current position
---@param vehicleId number
function ParkingManager:autoRecordSpot(vehicleId)
    if vehicleId == nil then return end

    if self:getSpotForVehicle(vehicleId) ~= nil then return end

    local vehicle = nil
    if g_currentMission and g_currentMission.vehicleSystem then
        for _, v in ipairs(g_currentMission.vehicleSystem.vehicles) do
            if v.id == vehicleId then
                vehicle = v
                break
            end
        end
    end

    if vehicle == nil or vehicle.rootNode == nil then return end

    local x, y, z = getWorldTranslation(vehicle.rootNode)
    local dx, _, dz = localDirectionToWorld(vehicle.rootNode, 0, 0, 1)
    local angle = MathUtil.getYRotationFromDirection(dx, dz)

    local name = vehicle:getName() or ("Vehicle_" .. tostring(vehicleId))
    local spotId = self:addSpot(name, x, y, z, angle)
    self:assignVehicle(spotId, vehicleId)
    CustomUtils:info("[ParkingManager] Auto-recorded spot for %s at %.1f, %.1f, %.1f", name, x, y, z)
end

function ParkingManager:saveToXMLFile(xmlFile, key)
    for i, spot in ipairs(self.spots) do
        local base = string.format("%s.spot(%d)", key, i - 1)
        setXMLInt(xmlFile, base .. "#id", spot.id)
        setXMLString(xmlFile, base .. "#name", spot.name)
        setXMLFloat(xmlFile, base .. "#x", spot.x)
        setXMLFloat(xmlFile, base .. "#y", spot.y)
        setXMLFloat(xmlFile, base .. "#z", spot.z)
        setXMLFloat(xmlFile, base .. "#angle", spot.angle or 0)
        setXMLInt(xmlFile, base .. "#vehicleId", spot.vehicleId or 0)
    end
    setXMLInt(xmlFile, key .. "#nextSpotId", self.nextSpotId)
end

function ParkingManager:loadFromXMLFile(xmlFile, key)
    self.spots = {}
    self.nextSpotId = Utils.getNoNil(getXMLInt(xmlFile, key .. "#nextSpotId"), 1)

    local i = 0
    while true do
        local base = string.format("%s.spot(%d)", key, i)
        local id = getXMLInt(xmlFile, base .. "#id")
        if id == nil then break end

        local spot = {
            id = id,
            name = getXMLString(xmlFile, base .. "#name") or ("Spot_" .. tostring(id)),
            x = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#x"), 0),
            y = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#y"), 0),
            z = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#z"), 0),
            angle = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#angle"), 0),
            vehicleId = nil,
        }

        local vId = getXMLInt(xmlFile, base .. "#vehicleId")
        if vId and vId ~= 0 then
            spot.vehicleId = vId
        end

        table.insert(self.spots, spot)
        i = i + 1
    end

    CustomUtils:info("[ParkingManager] Loaded %d parking spots", #self.spots)
end
