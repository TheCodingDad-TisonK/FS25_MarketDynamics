VehicleSnapshotManager = {}

local VehicleSnapshotManager_mt = Class(VehicleSnapshotManager)

---@return VehicleSnapshotManager
function VehicleSnapshotManager:new()
    local self = setmetatable({}, VehicleSnapshotManager_mt)
    self.snapshots = {}
    CustomUtils:debug("[SnapshotManager] Initialized")
    return self
end

---Captures a snapshot of the vehicle and all attached tools' positions
---@param employee table
---@param vehicle table
function VehicleSnapshotManager:captureSnapshot(employee, vehicle)
    if not employee or not vehicle or not vehicle.rootNode then
        CustomUtils:warning("[SnapshotManager] Cannot capture snapshot: invalid employee or vehicle")
        return
    end

    local vx, vy, vz = getWorldTranslation(vehicle.rootNode)
    local dx, _, dz = localDirectionToWorld(vehicle.rootNode, 0, 0, 1)
    local angle = MathUtil.getYRotationFromDirection(dx, dz)

    local snapshot = {
        employeeId = employee.id,
        timestamp = g_currentMission.time,
        vehicle = {
            id = vehicle.id,
            name = vehicle:getName(),
            x = vx,
            y = vy,
            z = vz,
            angle = angle
        },
        tools = {}
    }

    -- Capture all attached implements
    if vehicle.getAttachedImplements then
        local implements = vehicle:getAttachedImplements()
        for _, implement in ipairs(implements) do
            local obj = implement.object
            if obj and obj.rootNode then
                local tx, ty, tz = getWorldTranslation(obj.rootNode)
                local tdx, _, tdz = localDirectionToWorld(obj.rootNode, 0, 0, 1)
                local tAngle = MathUtil.getYRotationFromDirection(tdx, tdz)

                table.insert(snapshot.tools, {
                    id = obj.id,
                    name = obj:getName(),
                    x = tx,
                    y = ty,
                    z = tz,
                    angle = tAngle
                })
            end
        end
    end

    self.snapshots[employee.id] = snapshot
    CustomUtils:info("[SnapshotManager] Captured snapshot for employee %s: vehicle '%s' at (%.1f, %.1f, %.1f), %d tools",
        employee.name, snapshot.vehicle.name, vx, vy, vz, #snapshot.tools)
end

---Returns the snapshot for a given employee, or nil
---@param employeeId number
---@return table|nil
function VehicleSnapshotManager:getSnapshot(employeeId)
    return self.snapshots[employeeId]
end

---Clears the snapshot for a given employee
---@param employeeId number
function VehicleSnapshotManager:clearSnapshot(employeeId)
    if self.snapshots[employeeId] then
        CustomUtils:debug("[SnapshotManager] Cleared snapshot for employee %d", employeeId)
        self.snapshots[employeeId] = nil
    end
end

---Restores all tools from a snapshot to their original positions
---@param snapshot table
function VehicleSnapshotManager:restoreTools(snapshot)
    if not snapshot or not snapshot.tools then return end

    for _, toolData in ipairs(snapshot.tools) do
        local tool = g_employeeManager:getVehicleById(toolData.id)
        if tool and tool.rootNode then
            -- Teleport tool to its original position
            if tool.removeFromPhysics then
                tool:removeFromPhysics()
            end

            local rx, ry, rz = 0, toolData.angle, 0
            setWorldTranslation(tool.rootNode, toolData.x, toolData.y, toolData.z)
            setRotation(tool.rootNode, rx, ry, rz)

            if tool.addToPhysics then
                tool:addToPhysics()
            end

            CustomUtils:info("[SnapshotManager] Restored tool '%s' to (%.1f, %.1f, %.1f)",
                toolData.name, toolData.x, toolData.y, toolData.z)
        else
            CustomUtils:warning("[SnapshotManager] Tool '%s' (ID: %d) no longer exists, skipping restore",
                toolData.name or "unknown", toolData.id or 0)
        end
    end
end

---Serializes all snapshots to a plain table for persistence
---@return table
function VehicleSnapshotManager:toTable()
    local data = {}
    for empId, snapshot in pairs(self.snapshots) do
        data[tostring(empId)] = {
            employeeId = snapshot.employeeId,
            timestamp = snapshot.timestamp,
            vehicle = snapshot.vehicle,
            tools = snapshot.tools
        }
    end
    return data
end

---Loads snapshots from a previously serialized table
---@param data table
function VehicleSnapshotManager:fromTable(data)
    self.snapshots = {}
    if not data then return end

    for empIdStr, snapshot in pairs(data) do
        local empId = tonumber(empIdStr)
        if empId and snapshot.vehicle then
            self.snapshots[empId] = {
                employeeId = snapshot.employeeId or empId,
                timestamp = snapshot.timestamp or 0,
                vehicle = snapshot.vehicle,
                tools = snapshot.tools or {}
            }
        end
    end

    local count = 0
    for _ in pairs(self.snapshots) do count = count + 1 end
    if count > 0 then
        CustomUtils:info("[SnapshotManager] Loaded %d snapshots from persistence", count)
    end
end
