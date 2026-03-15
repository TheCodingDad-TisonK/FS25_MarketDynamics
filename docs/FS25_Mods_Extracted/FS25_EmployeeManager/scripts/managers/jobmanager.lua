JobManager = {}

JobManager.WORK_TYPE_TO_CATEGORY = {
    PLOW = "PLOWS",
    CULTIVATE = "CULTIVATORS",
    SOW = "SEEDERS",
    HARVEST = "COMBINES",
    MOW = "MOWERS",
    FERTILIZE = "SPRAYERS",
    LIME = "SALT_SPREADERS",
    MULCH = "MULCHERS",
    STONES = "STONE_PICKERS",
    ROLL = "ROLLERS",
    WEED = "WEEDERS",
    RIDGING = "PLANTERS",
    MULCH_LEAVES = "MULCHERS",
    TEDDER = "TEDDERS",
    WINDROWER = "WINDROWERS"
}

local JobManager_mt = Class(JobManager)

---@param mission table
---@return JobManager
function JobManager:new(mission)
    local self = setmetatable({}, JobManager_mt)
    self.mission = mission
    self.activeJobs = {}

    CustomUtils:debug("[JobManager] Initialized")
    return self
end

---Starts a field work job for an employee with 100% autonomy
---@param employee table
---@param fieldId number
---@param workType string (e.g. "PLOW", "SOW", "HARVEST")
---@return boolean Success
function JobManager:startFieldWork(employee, fieldId, workType)
    CustomUtils:info("[JobManager] Attempting to start job for %s on Field %d (%s)", employee.name, fieldId, workType)

    if not employee or not employee.isHired then
        CustomUtils:error("[JobManager] Invalid employee or employee not hired")
        return false
    end

    local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
    if not vehicle then
        CustomUtils:error("[JobManager] No assigned vehicle for employee %s", employee.name)
        return false
    end

    local field = g_fieldManager:getFieldById(fieldId)
    if not field then
        CustomUtils:error("[JobManager] Field ID %d not found", fieldId)
        return false
    end

    if workType == "HARVEST" then
        if not vehicle.spec_combine then
            local msg = string.format("Employee %s cannot harvest with a %s. A self-propelled harvester is required.",
                employee.name, vehicle:getName())
            CustomUtils:error("[JobManager] " .. msg)
            g_currentMission:showBlinkingWarning(msg, 5000)
            return false
        end
    end

    local req = EMWorkflowFrame.TASK_REQUIREMENTS[workType]
    if req then
        local level = employee.skills[req.skill] or 1
        if level < req.level then
            CustomUtils:error("[JobManager] Employee %s does not have enough %s skill for %s (Current: %d, Required: %d)",
                employee.name, req.skill, workType, level, req.level)
            return false
        end
    end

    employee.currentJob = {
        type = "PREPARING",
        fieldId = fieldId,
        workType = workType
    }

    -- Capture vehicle+tools origin snapshot (only on first task, not mid-workflow transitions)
    if g_snapshotManager and not g_snapshotManager:getSnapshot(employee.id) then
        g_snapshotManager:captureSnapshot(employee, vehicle)
    end

    CustomUtils:debug("[JobManager] Preparing vehicle %s (ID: %d) for job...", vehicle:getName(), vehicle.id)

    if vehicle.startMotor and not vehicle:getIsMotorStarted() then
        CustomUtils:debug("[JobManager] Starting motor for %s", vehicle:getName())
        vehicle:startMotor()
    end
    if vehicle.setBrakePedalInput then
        vehicle:setBrakePedalInput(0)
    end
    if vehicle.setCruiseControlState then
        vehicle:setCruiseControlState(Drivable.CRUISECONTROL_STATE_OFF)
    end

    if vehicle.stopAIJob then
        CustomUtils:debug("[JobManager] Stopping any existing AI job")
        vehicle:stopAIJob()
    end

    self:ensureEquipment(vehicle, workType, function(result, data)
        if result == true then
            -- Tier 1 (already attached) or close-proximity native attach succeeded
            CustomUtils:info("[JobManager] Equipment ensured. Deferring start via EQUIPMENT_READY state...")
            employee.currentJob = {
                type = "EQUIPMENT_READY",
                fieldId = fieldId,
                workType = workType,
                readyFrame = 0,
                readyTime = g_currentMission.time + 1000
            }
        elseif result == "DRIVE_TO_TOOL" then
            -- Tier 2: owned tool found but needs driving to
            CustomUtils:info("[JobManager] Owned tool found. Starting drive-to-tool for %s...", employee.name)
            self:startDriveToTool(employee, vehicle, data.tool, fieldId, workType)
        else
            local msg = string.format(g_i18n:getText("em_error_equipment_failed"), employee.name, workType)
            CustomUtils:error("[JobManager] " .. msg)
            g_currentMission:showBlinkingWarning(msg, 5000)
            employee.currentJob = nil
        end
    end)

    return true
end

---Internal helper to start the actual fieldwork job
function JobManager:startFieldWorkJob(employee, vehicle, fieldId, workType)
    local aiJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.FIELDWORK)
    if not aiJob then 
            CustomUtils:error("[JobManager] Failed to create FIELDWORK job type.")
            employee.currentJob = nil
        return 
    end

    local field = g_fieldManager:getFieldById(fieldId)
    local farmId = g_currentMission:getFarmId()

    local x, z = field:getCenterOfFieldWorldPosition()

    -- Field state snapshot for debugging
    if field.fieldState == nil then
        field.fieldState = FieldState.new()
    end
    field.fieldState:update(x, z)
    local fs = field.fieldState

    local fruitName = "NONE"
    if fs.fruitTypeIndex ~= FruitType.UNKNOWN then
        local ft = g_fruitTypeManager:getFruitTypeByIndex(fs.fruitTypeIndex)
        fruitName = ft and ft.name or "UNKNOWN"
    end
    local groundName = FieldGroundType.getName(fs.groundType) or "UNKNOWN"

    CustomUtils:info("[JobManager] Field %d state before %s:", fieldId, workType)
    CustomUtils:info("  Fruit: %s (%d) | Growth: %d | Ground: %s (%d)",
        fruitName, fs.fruitTypeIndex, fs.growthState, groundName, fs.groundType)
    CustomUtils:info("  Plow: %d | Lime: %d | Stones: %d | Spray: %d | SprayType: %d",
        fs.plowLevel, fs.limeLevel, fs.stoneLevel, fs.sprayLevel, fs.sprayType or 0)
    CustomUtils:info("  Stubble: %d | Weed: %d | Roller: %d",
        fs.stubbleShredLevel, fs.weedState, fs.rollerLevel)

    -- Never use isDirectStart for automated workflows.
    -- isDirectStart=true skips the drive-to task and starts from the vehicle's
    -- current edge position, which causes the AI to terminate instantly when it
    -- can't generate valid work rows from there.
    aiJob.isDirectStart = false

    aiJob:applyCurrentState(vehicle, g_currentMission, farmId, false)
    aiJob.positionAngleParameter:setPosition(x, z)

    aiJob:setValues()

    local validateSuccess, errorMessage = aiJob:validate(farmId)

    if validateSuccess then
        CustomUtils:info("[JobManager] AI Job validated successfully. Executing startJob...")
        g_currentMission.aiSystem:startJob(aiJob, farmId)

        if vehicle:getIsAIActive() then
            CustomUtils:info("[JobManager] SUCCESS: Vehicle AI is now ACTIVE.")
        else
            CustomUtils:warning("[JobManager] WARNING: startJob called but Vehicle AI is NOT active immediately. This might be async or failed silently.")
        end

        employee.currentJob = {
            aiJobId = aiJob.jobId,
            type = "FIELDWORK",
            fieldId = fieldId,
            workType = workType,
            startTime = g_currentMission.time
        }
        employee.pendingJob = nil
        CustomUtils:info("[JobManager] Employee %s is now autonomously working on field %d (%s)", employee.name, fieldId, workType)
    else
        CustomUtils:error("[JobManager] AI Job validation failed: %s", tostring(errorMessage))
        employee.currentJob = nil
    end
end

---Detaches all implements from a vehicle
---@param vehicle table
function JobManager:detachAllImplements(vehicle)
    if not vehicle or not vehicle.getAttachedImplements then return end

    local attachedImplements = vehicle:getAttachedImplements()
    -- Iterate in reverse to avoid index shifting
    for i = #attachedImplements, 1, -1 do
        local implement = attachedImplements[i]
        if implement and implement.object then
            CustomUtils:info("[JobManager] Detaching %s from %s", implement.object:getName(), vehicle:getName())
            if vehicle.detachImplementByObject then
                vehicle:detachImplementByObject(implement.object)
            end
        end
    end
end

---Checks if vehicle has required tool via three-tier search: attached → owned → rental
---Callback receives (true) for ready, ("DRIVE_TO_TOOL", data) for owned tool needing drive, or (false) for failure
function JobManager:ensureEquipment(vehicle, workType, callback)
    -- Defensive cleanup: return any lingering rental before equipping for new task
    local employee = g_employeeManager:getEmployeeByVehicle(vehicle)
    if employee and employee.temporaryRental then
        CustomUtils:warning("[JobManager] ensureEquipment: cleaning up lingering rental for %s", employee.name)
        g_employeeManager:returnRentedEquipment(employee)
    end

    local categoryName = JobManager.WORK_TYPE_TO_CATEGORY[workType]
    if not categoryName then
        callback(true)
        return
    end

    local attachedImplements = vehicle:getAttachedImplements()

    -- Tier 1: Check if the currently attached tool already supports this work type
    for _, implement in ipairs(attachedImplements) do
        local obj = implement.object
        if obj ~= nil then
            local storeItem = g_storeManager:getItemByXMLFilename(obj.configFileName)
            if storeItem and storeItem.categoryName == categoryName then
                CustomUtils:info("[JobManager] Tier 1: Vehicle already has correct tool (%s) for %s", obj:getName(), workType)
                callback(true)
                return
            end
        end
    end

    -- Detach any existing implements before attaching a new one (1 tool at a time!)
    if #attachedImplements > 0 then
        CustomUtils:info("[JobManager] Detaching existing implements before attaching tool for %s", workType)
        self:detachAllImplements(vehicle)
    end

    -- Tier 2: Search ALL owned vehicles on the farm for a matching tool
    local ownedTool = self:findOwnedTool(categoryName, vehicle)
    if ownedTool then
        local tx, _, tz = getWorldTranslation(ownedTool.rootNode)
        local vx, _, vz = getWorldTranslation(vehicle.rootNode)
        local dist = MathUtil.vector2Length(vx - tx, vz - tz)

        if dist < 10 then
            -- Tool is close — try native attach directly
            CustomUtils:info("[JobManager] Tier 2: Owned tool %s is nearby (%.1fm). Attempting native attach...",
                ownedTool:getName(), dist)
            self:attemptNativeAttach(vehicle, ownedTool, callback)
        else
            -- Tool is far — employee needs to drive to it
            CustomUtils:info("[JobManager] Tier 2: Found owned tool %s at %.1fm away. Employee must drive to it.",
                ownedTool:getName(), dist)
            callback("DRIVE_TO_TOOL", { tool = ownedTool, toolX = tx, toolZ = tz })
        end
        return
    end

    -- Tier 3: Rent from store as last resort
    CustomUtils:info("[JobManager] Tier 3: No owned tool found for %s. Renting equipment...", workType)
    local storeItem = self:findSuitableTool(categoryName)
    if storeItem then
        self:rentAndAttach(vehicle, storeItem, callback)
    else
        CustomUtils:error("[JobManager] No suitable tool found in category %s", categoryName)
        callback(false)
    end
end

---Searches ALL farm vehicles for an unattached, unused tool matching the category
---@param categoryName string
---@param vehicle table The tractor that needs the tool
---@return table|nil The found tool vehicle, or nil
function JobManager:findOwnedTool(categoryName, vehicle)
    if not g_currentMission or not g_currentMission.vehicleSystem then return nil end

    local farmId = g_currentMission:getFarmId()
    local vehicles = g_currentMission.vehicleSystem.vehicles

    for _, v in ipairs(vehicles) do
        if v ~= vehicle and v.ownerFarmId == farmId then
            local storeItem = g_storeManager:getItemByXMLFilename(v.configFileName)
            if storeItem and storeItem.categoryName == categoryName then
                if not self:isAttachedToAnyVehicle(v) and not self:isToolInUseByEmployee(v.id) then
                    CustomUtils:debug("[JobManager] findOwnedTool: Match found — %s (ID: %d)", v:getName(), v.id)
                    return v
                end
            end
        end
    end

    return nil
end

---Checks if a tool is currently attached to any vehicle
---@param tool table
---@return boolean
function JobManager:isAttachedToAnyVehicle(tool)
    if tool.getAttacherVehicle and tool:getAttacherVehicle() ~= nil then
        return true
    end
    return false
end

---Checks if a tool is currently rented/in-use by another employee
---@param toolId number
---@return boolean
function JobManager:isToolInUseByEmployee(toolId)
    if not g_employeeManager then return false end

    for _, employee in ipairs(g_employeeManager.employees) do
        if employee.isHired and employee.temporaryRental == toolId then
            return true
        end
    end
    return false
end

---Teleports an owned tool to align with the vehicle's rear attacher joint
---Positions the tool so its input attacher joint meets the vehicle's rear attacher joint
---@param tool table
---@param vehicle table
function JobManager:positionToolNearVehicle(tool, vehicle)
    local vx, vy, vz = getWorldTranslation(vehicle.rootNode)

    -- Find the vehicle's rear attacher joint world position
    local rearJointX, rearJointY, rearJointZ = vx, vy, vz
    if vehicle.spec_attacherJoints then
        local joints = vehicle:getAttacherJoints()
        if joints then
            for _, joint in ipairs(joints) do
                if joint.jointTransform then
                    local _, _, lz = localToLocal(joint.jointTransform, vehicle.rootNode, 0, 0, 0)
                    if lz < -0.2 then
                        rearJointX, rearJointY, rearJointZ = getWorldTranslation(joint.jointTransform)
                        break
                    end
                end
            end
        end
    end

    -- Calculate offset from tool's center to its input attacher joint
    local toolJointOffsetX, toolJointOffsetZ = 0, 0
    local inputJoints = tool.getInputAttacherJoints and tool:getInputAttacherJoints()
    if inputJoints and #inputJoints > 0 then
        local joint = inputJoints[1]
        if joint.node then
            local lx, _, lz = localToLocal(joint.node, tool.rootNode, 0, 0, 0)
            toolJointOffsetX, toolJointOffsetZ = lx, lz
        end
    end

    -- Get vehicle's backward direction to align tool behind it
    local backDirX, _, backDirZ = localDirectionToWorld(vehicle.rootNode, 0, 0, -1)
    local backRightX, _, backRightZ = localDirectionToWorld(vehicle.rootNode, 1, 0, 0)

    -- Target position: rear joint position, offset by tool's joint-to-center distance
    -- Tool needs to be placed so its input joint aligns with the vehicle's rear joint
    local targetX = rearJointX - backRightX * toolJointOffsetX - backDirX * toolJointOffsetZ
    local targetY = rearJointY + 0.3
    local targetZ = rearJointZ - backRightZ * toolJointOffsetX - backDirZ * toolJointOffsetZ

    -- Get vehicle's Y rotation so tool faces the same direction
    local vDirX, _, vDirZ = localDirectionToWorld(vehicle.rootNode, 0, 0, 1)
    local vehicleRotY = MathUtil.getYRotationFromDirection(vDirX, vDirZ)

    if tool.setAbsolutePosition then
        tool:setAbsolutePosition(targetX, targetY, targetZ, 0, vehicleRotY, 0)
        CustomUtils:debug("[JobManager] Positioned %s at (%.1f, %.1f, %.1f) rot=%.1f° via setAbsolutePosition",
            tool:getName(), targetX, targetY, targetZ, math.deg(vehicleRotY))
    elseif tool.rootNode then
        setWorldTranslation(tool.rootNode, targetX, targetY, targetZ)
        setWorldRotation(tool.rootNode, 0, vehicleRotY, 0)
        CustomUtils:debug("[JobManager] Positioned %s at (%.1f, %.1f, %.1f) rot=%.1f° via setWorldTranslation",
            tool:getName(), targetX, targetY, targetZ, math.deg(vehicleRotY))
    else
        CustomUtils:warning("[JobManager] Cannot position tool %s — no positioning method available", tool:getName())
    end
end

---Attempts native FS25 attach when tool is close to the vehicle
---@param vehicle table
---@param tool table
---@param callback function
function JobManager:attemptNativeAttach(vehicle, tool, callback)
    -- Try scanning for attachable using base game system
    if vehicle.spec_attacherJoints then
        AttacherJoints.updateVehiclesInAttachRange(vehicle,
            AttacherJoints.MAX_ATTACH_DISTANCE_SQ or 100,
            AttacherJoints.MAX_ATTACH_ANGLE or 1.0, true)

        local info = vehicle.spec_attacherJoints.attachableInfo
        if info and info.attachable == tool then
            CustomUtils:info("[JobManager] Native attach: Tool %s detected in range. Attaching via base game...", tool:getName())
            vehicle:attachImplementFromInfo(info)
            callback(true)
            return
        end
    end

    -- Fallback: position and direct attach (legacy method)
    CustomUtils:info("[JobManager] Native attach scan missed. Falling back to position + attachImplement for %s", tool:getName())
    self:positionToolNearVehicle(tool, vehicle)

    local vJointIdx, tJointIdx = self:findCompatibleJoints(vehicle, tool)
    if vehicle.attachImplement then
        vehicle:attachImplement(tool, tJointIdx, vJointIdx)
    end
    callback(true)
end

---Calculates optimal approach position for a vehicle to reach a tool for attaching
---Returns a point roughly 8m in front of the tool's input attacher joint direction
---@param vehicle table
---@param tool table
---@return number approachX, number approachZ, number approachAngle
function JobManager:calculateApproachPosition(vehicle, tool)
    local tx, _, tz = getWorldTranslation(tool.rootNode)

    -- Try to get orientation from the tool's input attacher joint
    local inputJoints = tool.getInputAttacherJoints and tool:getInputAttacherJoints()
    if inputJoints and #inputJoints > 0 then
        local joint = inputJoints[1]
        if joint.node then
            -- Get the joint's world-space direction (forward = Z axis of the joint)
            local jdx, _, jdz = localDirectionToWorld(joint.node, 0, 0, 1)
            local jointLen = math.sqrt(jdx * jdx + jdz * jdz)
            if jointLen > 0.001 then
                jdx = jdx / jointLen
                jdz = jdz / jointLen
                -- Approach point: 8m in front of the joint along its forward direction
                local approachX = tx + jdx * 8
                local approachZ = tz + jdz * 8
                -- Angle: vehicle should face TOWARD the tool (opposite direction)
                local approachAngle = MathUtil.getYRotationFromDirection(-jdx, -jdz)
                return approachX, approachZ, approachAngle
            end
        end
    end

    -- Fallback: approach from the vehicle's current direction
    local vx, _, vz = getWorldTranslation(vehicle.rootNode)
    local dx = tx - vx
    local dz = tz - vz
    local dist = math.sqrt(dx * dx + dz * dz)
    if dist > 0.001 then
        dx = dx / dist
        dz = dz / dist
    else
        dx, dz = 0, 1
    end
    -- Position 8m before the tool, facing toward it
    local approachX = tx - dx * 8
    local approachZ = tz - dz * 8
    local approachAngle = MathUtil.getYRotationFromDirection(dx, dz)
    return approachX, approachZ, approachAngle
end

---Starts a GOTO AI job to drive the vehicle to a tool for attachment
---@param employee table
---@param vehicle table
---@param tool table
---@param fieldId number
---@param workType string
function JobManager:startDriveToTool(employee, vehicle, tool, fieldId, workType)
    local approachX, approachZ, approachAngle = self:calculateApproachPosition(vehicle, tool)

    local aiJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.GOTO)
    if not aiJob then
        CustomUtils:error("[JobManager] Failed to create GOTO job for drive-to-tool. Falling back to teleport.")
        self:fallbackTeleportAttach(employee, vehicle, tool, fieldId, workType)
        return
    end

    local farmId = g_currentMission:getFarmId()
    aiJob:applyCurrentState(vehicle, g_currentMission, farmId, false)
    aiJob.positionAngleParameter:setPosition(approachX, approachZ)
    aiJob.positionAngleParameter:setAngle(approachAngle)
    aiJob:setValues()

    local validateSuccess, errorMessage = aiJob:validate(farmId)
    if validateSuccess then
        g_currentMission.aiSystem:startJob(aiJob, farmId)
        employee.currentJob = {
            type = "DRIVING_TO_TOOL",
            aiJobId = aiJob.jobId,
            fieldId = fieldId,
            workType = workType,
            targetToolId = tool.id,
            startTime = g_currentMission.time
        }
        CustomUtils:info("[JobManager] %s is now driving to tool %s (ID: %d)", employee.name, tool:getName(), tool.id)
    else
        CustomUtils:error("[JobManager] Drive-to-tool GOTO failed validation: %s. Falling back to teleport.", tostring(errorMessage))
        self:fallbackTeleportAttach(employee, vehicle, tool, fieldId, workType)
    end
end

---Attempts to attach the tool directly if in range, otherwise teleports it
---@param employee table
---@param vehicle table
---@param tool table
---@param fieldId number
---@param workType string
function JobManager:tryDirectAttachOrTeleport(employee, vehicle, tool, fieldId, workType)
    -- Check if already in attach range
    if vehicle.spec_attacherJoints then
        AttacherJoints.updateVehiclesInAttachRange(vehicle,
            AttacherJoints.MAX_ATTACH_DISTANCE_SQ or 100,
            AttacherJoints.MAX_ATTACH_ANGLE or 1.0, true)

        local info = vehicle.spec_attacherJoints.attachableInfo
        if info and info.attachable == tool then
            CustomUtils:info("[JobManager] %s: Tool %s in attach range! Attaching directly...", employee.name, tool:getName())
            vehicle:attachImplementFromInfo(info)
            employee.currentJob = {
                type = "ATTACHING_TOOL",
                fieldId = fieldId,
                workType = workType,
                targetToolId = tool.id,
                attachStartTime = g_currentMission.time
            }
            return
        end
    end

    -- Not in range — teleport tool to vehicle's rear
    CustomUtils:warning("[JobManager] %s: Tool not in attach range. Teleporting tool to vehicle rear.", employee.name)
    self:fallbackTeleportAttach(employee, vehicle, tool, fieldId, workType)
end

---Fallback: teleport tool near vehicle and attach directly (used when GOTO fails or timeout)
---@param employee table
---@param vehicle table
---@param tool table
---@param fieldId number
---@param workType string
function JobManager:fallbackTeleportAttach(employee, vehicle, tool, fieldId, workType)
    CustomUtils:warning("[JobManager] FALLBACK: Teleporting tool %s to vehicle %s", tool:getName(), vehicle:getName())

    -- Remove tool from physics before repositioning to prevent collision forces
    if tool.removeFromPhysics then
        tool:removeFromPhysics()
    end

    self:positionToolNearVehicle(tool, vehicle)

    -- Re-enable tool physics before attaching
    if tool.addToPhysics then
        tool:addToPhysics()
    end

    local vJointIdx, tJointIdx = self:findCompatibleJoints(vehicle, tool)
    if vehicle.attachImplement then
        vehicle:attachImplement(tool, tJointIdx, vJointIdx)
    end

    -- Stabilize vehicle to prevent flip/roll from teleport collision
    self:stabilizeVehicle(vehicle)

    employee.currentJob = {
        type = "EQUIPMENT_READY",
        fieldId = fieldId,
        workType = workType,
        readyFrame = 0,
        readyTime = g_currentMission.time + 2000
    }
end

---Stabilizes a vehicle after tool teleport to prevent flip/roll
---Preserves position and heading but resets pitch and roll to upright
---@param vehicle table
function JobManager:stabilizeVehicle(vehicle)
    if not vehicle or not vehicle.rootNode then
        return
    end

    local vx, _, vz = getWorldTranslation(vehicle.rootNode)
    local _, yRot, _ = getWorldRotation(vehicle.rootNode)

    -- Remove from physics, reposition upright, re-add
    if vehicle.removeFromPhysics then
        vehicle:removeFromPhysics()
    end

    -- setRelativePosition(x, offsetY, z, yRot) auto-gets terrain height, resets pitch/roll to 0
    if vehicle.setRelativePosition then
        vehicle:setRelativePosition(vx, 0.5, vz, yRot)
        CustomUtils:debug("[JobManager] Stabilized vehicle %s at (%.1f, %.1f) heading %.1f°", vehicle:getName(), vx, vz, math.deg(yRot))
    end

    if vehicle.addToPhysics then
        vehicle:addToPhysics()
    end
end

---Starts a GOTO job to return the current tool to its parking spot before switching tools
---@param employee table
---@param vehicle table
---@param tool table The tool to return
---@param nextFieldId number
---@param nextWorkType string
function JobManager:startReturnTool(employee, vehicle, tool, nextFieldId, nextWorkType)
    -- Since the tool is attached, we can just detach it in place after the fieldwork is done.
    -- The vehicle is already near the field edge. Simply detach and proceed to next task.
    CustomUtils:info("[JobManager] %s: Detaching tool %s at field edge before switching to %s",
        employee.name, tool:getName(), nextWorkType)
    self:detachAllImplements(vehicle)
    employee.currentJob = nil
    self:startFieldWork(employee, nextFieldId, nextWorkType)
end

---Starts a GOTO job to return the current tool to a specific parking spot
---Used when the employee needs to drive the tool back to its original location
---@param employee table
---@param vehicle table
---@param parkingX number
---@param parkingZ number
---@param nextFieldId number
---@param nextWorkType string
function JobManager:startReturnToolToSpot(employee, vehicle, parkingX, parkingZ, nextFieldId, nextWorkType)
    local aiJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.GOTO)
    if not aiJob then
        CustomUtils:error("[JobManager] Failed to create GOTO job for tool return. Detaching in place.")
        self:detachAllImplements(vehicle)
        employee.currentJob = nil
        self:startFieldWork(employee, nextFieldId, nextWorkType)
        return
    end

    local farmId = g_currentMission:getFarmId()
    aiJob:applyCurrentState(vehicle, g_currentMission, farmId, false)
    aiJob.positionAngleParameter:setPosition(parkingX, parkingZ)
    aiJob:setValues()

    local validateSuccess, errorMessage = aiJob:validate(farmId)
    if validateSuccess then
        g_currentMission.aiSystem:startJob(aiJob, farmId)
        employee.currentJob = {
            type = "RETURNING_TOOL",
            aiJobId = aiJob.jobId,
            nextFieldId = nextFieldId,
            nextWorkType = nextWorkType,
            startTime = g_currentMission.time
        }
        CustomUtils:info("[JobManager] %s is returning tool to parking before switching to %s",
            employee.name, nextWorkType)
    else
        CustomUtils:error("[JobManager] Tool return GOTO failed validation: %s. Detaching in place.", tostring(errorMessage))
        self:detachAllImplements(vehicle)
        employee.currentJob = nil
        self:startFieldWork(employee, nextFieldId, nextWorkType)
    end
end

---Gets the first attached implement on a vehicle
---@param vehicle table
---@return table|nil implement object
function JobManager:getFirstAttachedImplement(vehicle)
    if not vehicle or not vehicle.getAttachedImplements then return nil end
    local implements = vehicle:getAttachedImplements()
    if #implements > 0 and implements[1].object then
        return implements[1].object
    end
    return nil
end

---Checks if the vehicle has the correct tool for a given category
---@param vehicle table
---@param categoryName string
---@return boolean
function JobManager:hasCorrectTool(vehicle, categoryName)
    if not vehicle or not categoryName then return false end
    local attachedImplements = vehicle:getAttachedImplements()
    for _, implement in ipairs(attachedImplements) do
        local obj = implement.object
        if obj then
            local storeItem = g_storeManager:getItemByXMLFilename(obj.configFileName)
            if storeItem and storeItem.categoryName == categoryName then
                return true
            end
        end
    end
    return false
end

---Finds compatible rear attacher joints between a vehicle and a tool
---@param vehicle table
---@param tool table
---@return number vehicleJointIndex, number toolJointIndex
function JobManager:findCompatibleJoints(vehicle, tool)
    local vehicleJointIndex = 1
    local toolJointIndex = 1

    if vehicle.getAttacherJoints and tool.getInputAttacherJoints then
        local vJoints = vehicle:getAttacherJoints()
        local tJoints = tool:getInputAttacherJoints()

        local rearIndices = {}
        for i, joint in ipairs(vJoints) do
            local lx, ly, lz = localToLocal(joint.jointTransform, vehicle.rootNode, 0, 0, 0)
            if joint.attacherJointDirection == -1 or lz < -0.2 then
                table.insert(rearIndices, i)
            end
        end

        local found = false
        for _, vIdx in ipairs(#rearIndices > 0 and rearIndices or {1}) do
            local vJoint = vJoints[vIdx]
            for tIdx, tJoint in ipairs(tJoints) do
                if vJoint.jointType == tJoint.jointType then
                    vehicleJointIndex = vIdx
                    toolJointIndex = tIdx
                    found = true
                    break
                end
            end
            if found then break end
        end
    end

    return vehicleJointIndex, toolJointIndex
end

function JobManager:findSuitableTool(categoryName)
    local items = g_storeManager:getItems()
    for _, item in pairs(items) do
        if item.categoryName == categoryName then
            return item
        end
    end
    return nil
end

function JobManager:rentAndAttach(vehicle, storeItem, callback)
    local farmId = g_currentMission:getFarmId()

    local rentalFee = storeItem.price * 0.05
    g_currentMission:addMoney(-rentalFee, farmId, MoneyType.SHOP_VEHICLE_BUY, true)

    local function asyncCallback(target, vehicles, vehicleLoadState, arguments)
        if vehicleLoadState == VehicleLoadingState.OK then
            local tool = vehicles[1]

            local vehicleJointIndex, toolJointIndex = self:findCompatibleJoints(vehicle, tool)

            CustomUtils:debug("[JobManager] Attaching %s (Joint: %d) to %s (Joint: %d)",
                tool:getName(), toolJointIndex, vehicle:getName(), vehicleJointIndex)

            if vehicle.attachImplement then
                vehicle:attachImplement(tool, toolJointIndex, vehicleJointIndex)
            end

            local employee = arguments.employee
            if employee then
                if employee.assignedVehicleId == vehicle.id then
                    employee.temporaryRental = tool.id
                    employee.isRenting = true
                else
                    CustomUtils:error("[JobManager] Unauthorized rental attempt for employee %s", employee.name)
                    callback(false)
                    return
                end
            end

            CustomUtils:info("[JobManager] Successfully rented and attached %s (Rear Joint: %d)", tool:getName(), vehicleJointIndex)
            callback(true)
        else
            callback(false)
        end
    end

    local data = VehicleLoadingData.new()
    local x, y, z = getWorldTranslation(vehicle.rootNode)

    local dx, dy, dz = localDirectionToWorld(vehicle.rootNode, 0, 0, -5)
    data:setStoreItem(storeItem)
    data:setPosition(x + dx, y + 1, z + dz)
    data:setPropertyState(VehiclePropertyState.LEASED)
    data:setOwnerFarmId(farmId)

    local employee = g_employeeManager:getEmployeeByVehicle(vehicle)

    data:load(asyncCallback, self, { employee = employee })
end

---Stops a job for an employee
---@param employee table
---@return boolean Success
function JobManager:stopJob(employee)
    if not employee or not employee.currentJob then
        return false
    end

    local aiJobId = employee.currentJob.aiJobId
    if aiJobId then
        g_currentMission.aiSystem:stopJobById(aiJobId, AIMessageErrorUnknown.new())
    end

    employee.currentJob = nil

    -- Clear origin snapshot on manual stop
    if g_snapshotManager then
        g_snapshotManager:clearSnapshot(employee.id)
    end

    if employee.temporaryRental then
        g_employeeManager:returnRentedEquipment(employee)
    end

    CustomUtils:info("[JobManager] Stopped job for employee %s", employee.name)
    return true
end

function JobManager:handleFieldworkCompletion(employee)
    -- Return rented equipment from completed task
    if employee.temporaryRental then
        g_employeeManager:returnRentedEquipment(employee)
    end

    if g_employeeManager then
        g_employeeManager:onJobCompleted(employee)
    end

    -- Task-queue chaining: check for next task
    local queue = employee.taskQueue or {}
    local currentIdx = employee.currentTaskIndex or 1
    local nextIdx = currentIdx + 1

    if employee.isAutonomous and nextIdx <= #queue then
        local nextTask = queue[nextIdx]
        local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)

        -- Check if the current tool works for the next task
        local nextCategory = JobManager.WORK_TYPE_TO_CATEGORY[nextTask]
        local currentToolOk = vehicle and self:hasCorrectTool(vehicle, nextCategory)

        if not currentToolOk and vehicle then
            -- Need to swap tools — return the current one first
            local currentTool = self:getFirstAttachedImplement(vehicle)
            if currentTool then
                CustomUtils:info("[JobManager] %s needs tool swap: current tool won't work for %s. Returning tool first.",
                    employee.name, nextTask)
                employee.currentTaskIndex = nextIdx
                self:startReturnTool(employee, vehicle, currentTool, employee.targetFieldId, nextTask)
                return
            end
        end

        -- Tool is already correct or no tool to return — advance directly
        employee.currentTaskIndex = nextIdx
        CustomUtils:info("[JobManager] %s advancing to task %d/%d: %s",
            employee.name, nextIdx, #queue, nextTask)
        employee.currentJob = nil
        self:startFieldWork(employee, employee.targetFieldId, nextTask)
        return
    end

    -- All tasks complete (or no queue) — workflow finished
    if #queue > 0 then
        CustomUtils:info("[JobManager] %s completed all %d tasks in workflow", employee.name, #queue)
        employee.currentTaskIndex = 1
        employee.isAutonomous = false  -- Queue exhausted, stop autonomous mode
        local msg = string.format(g_i18n:getText("em_workflow_queue_complete"), employee.name)
        g_currentMission:showBlinkingWarning(msg, 5000)
    end

    -- Attempt return-to-origin via snapshot (preferred) or parking spot (fallback)
    local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
    local snapshot = g_snapshotManager and g_snapshotManager:getSnapshot(employee.id)

    if snapshot and vehicle and vehicle.rootNode then
        -- Detach all tools, then restore them to their original positions
        self:detachAllImplements(vehicle)
        g_snapshotManager:restoreTools(snapshot)

        -- Create a spot-like object from the snapshot vehicle data for GOTO
        local snapshotSpot = {
            id = 0,
            name = "origin",
            x = snapshot.vehicle.x,
            z = snapshot.vehicle.z,
            angle = snapshot.vehicle.angle
        }

        local vx, _, vz = getWorldTranslation(vehicle.rootNode)
        local dx = vx - snapshotSpot.x
        local dz = vz - snapshotSpot.z
        local dist = math.sqrt(dx * dx + dz * dz)

        if dist > 20 then
            CustomUtils:info("[JobManager] %s returning to origin (%.0fm away)", employee.name, dist)
            self:startReturnToParking(employee, vehicle, snapshotSpot)
            return
        else
            -- Already close to origin, just clear and finish
            g_snapshotManager:clearSnapshot(employee.id)
            employee.currentJob = nil
            return
        end
    end

    -- Fallback: parking spot return (no snapshot available)
    if g_parkingManager and employee.assignedVehicleId then
        local spot = g_parkingManager:getSpotForVehicle(employee.assignedVehicleId)
        if spot and vehicle and vehicle.rootNode then
            local vx, _, vz = getWorldTranslation(vehicle.rootNode)
            local dx = vx - spot.x
            local dz = vz - spot.z
            local dist = math.sqrt(dx * dx + dz * dz)

            if dist > 20 then
                CustomUtils:info("[JobManager] %s returning to parking '%s' (%.0fm away)",
                    employee.name, spot.name, dist)
                self:startReturnToParking(employee, vehicle, spot)
                return
            end
        end
    end

    employee.currentJob = nil
end

function JobManager:startReturnToParking(employee, vehicle, spot)
    local aiJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.GOTO)
    if not aiJob then
        CustomUtils:error("[JobManager] Failed to create GOTO job for parking return")
        employee.currentJob = nil
        return
    end

    local farmId = g_currentMission:getFarmId()
    aiJob:applyCurrentState(vehicle, g_currentMission, farmId, false)
    aiJob.positionAngleParameter:setPosition(spot.x, spot.z)
    aiJob.positionAngleParameter:setAngle(spot.angle or 0)
    aiJob:setValues()

    local validateSuccess, errorMessage = aiJob:validate(farmId)
    if validateSuccess then
        g_currentMission.aiSystem:startJob(aiJob, farmId)
        employee.currentJob = {
            aiJobId = aiJob.jobId,
            type = "RETURN_TO_PARKING",
            spotId = spot.id,
            startTime = g_currentMission.time,
        }
        CustomUtils:info("[JobManager] %s is now returning to parking '%s'", employee.name, spot.name)
    else
        CustomUtils:error("[JobManager] Parking return GOTO failed validation: %s", tostring(errorMessage))
        employee.currentJob = nil
    end
end

function JobManager:handleParkingArrival(employee)
    local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
    if vehicle then
        if vehicle.stopMotor and vehicle:getIsMotorStarted() then
            vehicle:stopMotor()
            CustomUtils:info("[JobManager] %s arrived at parking, motor stopped", employee.name)
        end
    end

    -- Clear origin snapshot now that we've arrived
    if g_snapshotManager then
        g_snapshotManager:clearSnapshot(employee.id)
    end

    employee.currentJob = nil
    if g_employeeManager then
        g_employeeManager:onJobCompleted(employee)
    end
end


function JobManager:update(dt)
    for _, employee in ipairs(g_employeeManager.employees) do
        if employee.currentJob and employee.currentJob.aiJobId then
            local aiJob = g_currentMission.aiSystem:getJobById(employee.currentJob.aiJobId)

            employee.debugTimer = (employee.debugTimer or 0) + dt
            if employee.debugTimer > 5000 then
                employee.debugTimer = 0
                local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
                local speed = vehicle and vehicle:getLastSpeed() or 0
                local isAIActive = vehicle and vehicle:getIsAIActive() or false

                if aiJob then
                    CustomUtils:debug("[JobMonitor] %s: Job %d (Type: %s) | AI Active: %s | Speed: %.1f km/h | Status: RUNNING", 
                        employee.name, aiJob.jobId, employee.currentJob.type, tostring(isAIActive), speed)
                else
                    CustomUtils:warning("[JobMonitor] %s: Job %d stored in employee but NOT found in AI System!", employee.name, employee.currentJob.aiJobId)
                end
            end

            if not aiJob then
                CustomUtils:info("[JobManager] Job %d for employee %s finished or removed", employee.currentJob.aiJobId, employee.name)

                if employee.currentJob.type == "TRANSIT" and employee.pendingJob then
                    CustomUtils:info("[JobManager] Transit complete. Deferring fieldwork start via EQUIPMENT_READY...")
                    local pending = employee.pendingJob
                    employee.pendingJob = nil
                    employee.currentJob = {
                        type = "EQUIPMENT_READY",
                        fieldId = pending.fieldId,
                        workType = pending.workType,
                        readyFrame = 0,
                        readyTime = g_currentMission.time + 500
                    }
                elseif employee.currentJob.type == "DRIVING_TO_TOOL" then
                    -- GOTO completed — try direct attach or teleport (no alignment step)
                    CustomUtils:info("[JobManager] %s arrived near tool. Attempting attach or teleport...", employee.name)
                    local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
                    local tool = g_employeeManager:getVehicleById(employee.currentJob.targetToolId)
                    if vehicle and tool then
                        self:tryDirectAttachOrTeleport(employee, vehicle, tool, employee.currentJob.fieldId, employee.currentJob.workType)
                    else
                        CustomUtils:error("[JobManager] Vehicle or tool lost after DRIVING_TO_TOOL for %s", employee.name)
                        employee.currentJob = nil
                    end
                elseif employee.currentJob.type == "RETURNING_TOOL" then
                    -- GOTO to return position completed — detach tool and start next task
                    CustomUtils:info("[JobManager] %s arrived at drop-off point. Detaching tool...", employee.name)
                    local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
                    if vehicle then
                        self:detachAllImplements(vehicle)
                    end
                    local nextFieldId = employee.currentJob.nextFieldId
                    local nextWorkType = employee.currentJob.nextWorkType
                    employee.currentJob = nil
                    self:startFieldWork(employee, nextFieldId, nextWorkType)
                elseif employee.currentJob.type == "RETURN_TO_PARKING" then
                    self:handleParkingArrival(employee)
                elseif employee.currentJob.type == "FIELDWORK" then
                    -- Rapid-finish guard: detect instant completions (field already done)
                    local elapsed = g_currentMission.time - (employee.currentJob.startTime or 0)
                    if elapsed < 2000 then
                        employee.rapidFailCount = (employee.rapidFailCount or 0) + 1
                        CustomUtils:warning("[JobManager] %s: FIELDWORK finished instantly (%dms). Rapid fail #%d",
                            employee.name, elapsed, employee.rapidFailCount)
                        if employee.rapidFailCount >= 3 then
                            CustomUtils:warning("[JobManager] %s: Too many rapid fails. Pausing autonomous mode.", employee.name)
                            employee.isAutonomous = false
                            employee.rapidFailCount = 0
                            employee.currentJob = nil
                            if employee.temporaryRental then
                                g_employeeManager:returnRentedEquipment(employee)
                            end
                        else
                            self:handleFieldworkCompletion(employee)
                        end
                    else
                        employee.rapidFailCount = 0
                        self:handleFieldworkCompletion(employee)
                    end
                else
                    employee.currentJob = nil
                    if g_employeeManager then
                        g_employeeManager:onJobCompleted(employee)
                    end
                    if employee.temporaryRental then
                        g_employeeManager:returnRentedEquipment(employee)
                    end
                end
            end
        elseif employee.currentJob and employee.currentJob.type == "EQUIPMENT_READY" then
            local job = employee.currentJob
            job.readyFrame = (job.readyFrame or 0) + 1

            if job.readyFrame >= 3 and g_currentMission.time >= (job.readyTime or 0) then
                CustomUtils:info("[JobManager] EQUIPMENT_READY matured for %s (frames: %d). Evaluating distance...",
                    employee.name, job.readyFrame)

                local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
                local field = g_fieldManager:getFieldById(job.fieldId)

                if vehicle and field then
                    local x, z = field:getCenterOfFieldWorldPosition()
                    local vx, _, vz = getWorldTranslation(vehicle.rootNode)
                    local distance = MathUtil.vector2Length(vx - x, vz - z)

                    CustomUtils:info("[JobManager] Distance to Field %d: %.1f m", job.fieldId, distance)

                    if distance > 150 then
                        CustomUtils:info("[JobManager] Field is far. Starting TRANSIT (GOTO) job.")
                        local aiJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.GOTO)
                        if aiJob then
                            local farmId = g_currentMission:getFarmId()
                            aiJob:applyCurrentState(vehicle, g_currentMission, farmId, false)
                            aiJob.positionAngleParameter:setPosition(x, z)

                            local dx, dz = x - vx, z - vz
                            local angle = MathUtil.getYRotationFromDirection(dx, dz)
                            aiJob.positionAngleParameter:setAngle(angle)
                            aiJob:setValues()

                            local validateSuccess, errorMessage = aiJob:validate(farmId)
                            if validateSuccess then
                                g_currentMission.aiSystem:startJob(aiJob, farmId)
                                employee.currentJob = {
                                    aiJobId = aiJob.jobId,
                                    type = "TRANSIT",
                                    fieldId = job.fieldId,
                                    workType = job.workType,
                                    startTime = g_currentMission.time
                                }
                                employee.pendingJob = {
                                    fieldId = job.fieldId,
                                    workType = job.workType
                                }
                                CustomUtils:info("[JobManager] %s is now in TRANSIT to field %d", employee.name, job.fieldId)
                            else
                                CustomUtils:error("[JobManager] Transit GOTO failed validation: %s", tostring(errorMessage))
                                employee.currentJob = nil
                            end
                        else
                            CustomUtils:error("[JobManager] Failed to create GOTO job")
                            employee.currentJob = nil
                        end
                    else
                        CustomUtils:info("[JobManager] Starting FIELDWORK for %s (close proximity).", employee.name)
                        self:startFieldWorkJob(employee, vehicle, job.fieldId, job.workType)
                    end
                else
                    CustomUtils:error("[JobManager] EQUIPMENT_READY: vehicle or field not found for %s", employee.name)
                    employee.currentJob = nil
                end
            else
                -- Debug logging for EQUIPMENT_READY wait
                employee.debugTimer = (employee.debugTimer or 0) + dt
                if employee.debugTimer > 5000 then
                    employee.debugTimer = 0
                    CustomUtils:debug("[JobMonitor] %s: EQUIPMENT_READY (frame %d, waiting for stabilization)...",
                        employee.name, job.readyFrame or 0)
                end
            end
        elseif employee.currentJob and employee.currentJob.type == "ATTACHING_TOOL" then
            -- Wait for attachment animation to complete
            local vehicle = g_employeeManager:getVehicleById(employee.assignedVehicleId)
            if vehicle then
                local allDone = true
                local implements = vehicle:getAttachedImplements()
                for _, impl in ipairs(implements) do
                    if impl.attachingIsInProgress then
                        allDone = false
                    end
                end

                if allDone then
                    local job = employee.currentJob
                    CustomUtils:info("[JobManager] %s: Tool attachment complete! Proceeding to EQUIPMENT_READY.",
                        employee.name)
                    employee.currentJob = {
                        type = "EQUIPMENT_READY",
                        fieldId = job.fieldId,
                        workType = job.workType,
                        readyFrame = 0,
                        readyTime = g_currentMission.time + 1000
                    }
                end
            else
                CustomUtils:error("[JobManager] ATTACHING_TOOL: vehicle lost for %s", employee.name)
                employee.currentJob = nil
            end
        elseif employee.currentJob and employee.currentJob.type == "PREPARING" then
            employee.debugTimer = (employee.debugTimer or 0) + dt
            if employee.debugTimer > 5000 then
                employee.debugTimer = 0
                CustomUtils:debug("[JobMonitor] %s: Job PREPARING (Waiting for equipment/start)...", employee.name)
            end
        end
    end
end
