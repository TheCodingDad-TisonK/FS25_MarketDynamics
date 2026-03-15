EmployeeManager = {}

local EmployeeManager_mt = Class(EmployeeManager)

---@param mission table
---@return table
function EmployeeManager:new(mission)
    local self = setmetatable({}, EmployeeManager_mt)
    self.mission = mission
    self.employees = {}
    
    self.courseManager = CourseManager:new(mission)
    self.cropManager = CropManager:new(mission)
    self.jobManager = JobManager:new(mission)

    self.employees = {}
    self.fieldConfigs = {}
    self.employeeTemplates = {}

    self.nextEmployeeId = 1

    self.lastPoolRefreshDay = 0
    self.POOL_REFRESH_DAYS = 3
    self.POOL_MIN = 8
    self.POOL_MAX = 12
    self.lastDayChecked = 0

    self.lastPaymentPeriod = 0
    self.payrollRetryCount = 0

    CustomUtils:debug("[EmployeeManager] Initialized")
    return self
end

function EmployeeManager:onMissionInitialize(baseDirectory)
    CustomUtils:info("[EmployeeManager] Mission initialized. Registering console commands...")

    if g_commandManager then
        g_commandManager:add('emAssignVehicle', 'Assigns a vehicle to an employee', 'emAssignVehicle <id> <vehId>', 'consoleAssignVehicle', self)
        g_commandManager:add('emUnassignVehicle', 'Unassigns a vehicle from an employee', 'emUnassignVehicle <id>', 'consoleUnassignVehicle', self)
        g_commandManager:add('emDebugVehicles', 'List all vehicles owned by the farm', 'emDebugVehicles', 'consoleDebugVehicles', self)
        g_commandManager:add('emHireRandom', 'Generates a new candidate from templates', 'emHireRandom', 'consoleGenerateCandidate', self)
        g_commandManager:add('emList', 'Lists all employees', 'emList', 'consoleListEmployees', self)
        g_commandManager:add('emStartTask', 'Starts a task for an employee', 'emStartTask <id> <taskName> [fieldId]', 'consoleStartTask', self)
        g_commandManager:add('emSetCrop', 'Sets target crop/field for an employee', 'emSetCrop <id> <fieldId> <cropName>', 'consoleSetTargetCrop', self)

        g_commandManager:add('emStatus', 'Checks the status of employees and jobs', 'emStatus', 'consoleStatus', self)
        g_commandManager:add('emStartFieldWork', 'Starts a field work job', 'emStartFieldWork <id> <fieldId> <type>', 'consoleStartFieldWork', self)
        g_commandManager:add('emStartJob', 'Starts full autonomy for an employee (Requires target crop)', 'emStartJob <id> [fieldId] [cropName]', 'consoleStartJob', self)
        g_commandManager:add('emStopJob', 'Stops the current job', 'emStopJob <id>', 'consoleStopJob', self)
        g_commandManager:add('emSetTargetCrop', 'Sets a target crop for an employee on a field for full autonomy', 'emSetTargetCrop <id> <fieldId> <cropName>', 'consoleSetTargetCrop', self)
        g_commandManager:add('emListCrops', 'Lists all supported target crops', 'emListCrops', 'consoleListCrops', self)

        g_commandManager:add('emHire', 'Hires a candidate by ID', 'emHire <id>', 'consoleHire', self)
        g_commandManager:add('emFire', 'Fires an employee by ID', 'emFire <id>', 'consoleFire', self)
        g_commandManager:add('emListCandidates', 'Lists available candidates for hire', 'emListCandidates', 'consoleListCandidates', self)
        g_commandManager:add('emListFields', 'Lists all fields owned by your farm', 'emListFields', 'consoleListFields', self)
        g_commandManager:add('emRentVehicle', 'Rents a vehicle for an employee by store item name', 'emRentVehicle <empId> <storeItemName>', 'consoleRentVehicle', self)
        g_commandManager:add('emClearAll', 'Clears all employees (DEBUG)', 'emClearAll', 'consoleClearAll', self)
        g_commandManager:add('emTrain', 'Trains an employee skill', 'emTrain <id> <skillName>', 'consoleTrain', self)

        g_commandManager:add('emParkingAdd', 'Adds a parking spot at player position', 'emParkingAdd <name>', 'consoleParkingAdd', self)
        g_commandManager:add('emParkingList', 'Lists all parking spots', 'emParkingList', 'consoleParkingList', self)
        g_commandManager:add('emParkingRemove', 'Removes a parking spot', 'emParkingRemove <id>', 'consoleParkingRemove', self)
        g_commandManager:add('emParkingAssign', 'Assigns a vehicle to a parking spot', 'emParkingAssign <spotId> <vehicleId>', 'consoleParkingAssign', self)
    else
        CustomUtils:error("[EmployeeManager] CommandManager not found!")
    end
end

function EmployeeManager:update(dt)
    if self.jobManager then
        self.jobManager:update(dt)
    end
    if self.courseManager then
        self.courseManager:update(dt)
    end

    local marketMult = self:getMarketMultiplier()

    for _, employee in ipairs(self.employees) do
        if employee.isHired and employee.isUnpaid then
            if employee.currentJob then
                self.jobManager:stopJob(employee)
                CustomUtils:info("[EmployeeManager] %s stopped working (unpaid)", employee.name)
            end
        elseif employee.isHired and employee.currentJob ~= nil then
            local effectiveDt = math.min(dt, 200) -- Cap at 200ms: prevent wage inflation during time acceleration
            local hoursWorked = employee:updateWorkTime(effectiveDt)
            if hoursWorked > 0 then
                local fatigueMult = employee:getFatigueMultiplier()
                local wage = employee:getHourlyWage() * marketMult * hoursWorked
                employee.pendingWages = (employee.pendingWages or 0) + wage

                local workType = employee.currentJob.workType or "DEFAULT"
                local xpRates = SkillSystem.getXPRates(workType)
                for skill, rate in pairs(xpRates) do
                    if rate > 0 then
                        employee:addExperience(skill, hoursWorked * rate * fatigueMult)
                    end
                end

                self:trackVehicleDistance(employee)
            end
        end

        if employee.isHired and not employee.isUnpaid and employee.isAutonomous and employee.currentJob == nil and employee.targetCrop ~= nil and employee.targetFieldId ~= nil then
            if not employee:canWork() then
                -- skip: on break or exhausted
            elseif g_currentMission and g_currentMission.environment and not employee:isWithinShift(g_currentMission.environment.currentHour or 0) then
                -- skip: outside shift
            else
                employee.decisionTimer = (employee.decisionTimer or 0) + dt

                if employee.decisionTimer > 5000 then
                    employee.decisionTimer = 0

                    local field = g_fieldManager:getFieldById(employee.targetFieldId)
                    if field then
                        local nextStep, reason = self.cropManager:getNextStep(field, employee.targetCrop)
                        if nextStep ~= nil and nextStep ~= "WAIT" then
                            CustomUtils:info("[EmployeeManager] %s deciding next step for %s on field %d: %s (%s)",
                                employee.name, employee.targetCrop, employee.targetFieldId, nextStep, reason)

                            self.jobManager:startFieldWork(employee, employee.targetFieldId, nextStep)
                        else
                            CustomUtils:debug("[EmployeeManager] %s is WAITING on field %d (%s): %s",
                                employee.name, employee.targetFieldId, employee.targetCrop, reason or "No action needed")
                        end
                    else
                        CustomUtils:error("[EmployeeManager] Target field %d not found for employee %s", employee.targetFieldId, employee.name)
                        employee.isAutonomous = false
                    end
                end
            end
        end

        -- Task-queue-based autonomous restart (no targetCrop, uses taskQueue instead)
        if employee.isHired and not employee.isUnpaid and employee.isAutonomous
           and employee.currentJob == nil
           and (employee.targetCrop == nil or employee.targetCrop == "")
           and employee.taskQueue and #employee.taskQueue > 0
           and employee.targetFieldId ~= nil then

            if not employee:canWork() then
                -- skip: on break or exhausted
            elseif g_currentMission and g_currentMission.environment and not employee:isWithinShift(g_currentMission.environment.currentHour or 0) then
                -- skip: outside shift
            else
                employee.decisionTimer = (employee.decisionTimer or 0) + dt
                if employee.decisionTimer > 5000 then
                    employee.decisionTimer = 0
                    local idx = employee.currentTaskIndex or 1
                    if idx <= #employee.taskQueue then
                        local task = employee.taskQueue[idx]
                        CustomUtils:info("[EmployeeManager] %s resuming task %d/%d: %s",
                            employee.name, idx, #employee.taskQueue, task)
                        local success = self.jobManager:startFieldWork(employee, employee.targetFieldId, task)
                        if not success then
                            CustomUtils:warning("[EmployeeManager] %s auto-start FAILED for task %s on field %d",
                                employee.name, task, employee.targetFieldId)
                        end
                    end
                end
            end
        end

        -- Diagnostic: autonomous employees that SHOULD be working but aren't
        if employee.isHired and employee.isAutonomous and employee.currentJob == nil
           and employee.taskQueue and #employee.taskQueue > 0 then
            employee.diagTimer = (employee.diagTimer or 0) + dt
            if employee.diagTimer > 60000 then
                employee.diagTimer = 0
                local hour = (g_currentMission and g_currentMission.environment) and g_currentMission.environment.currentHour or 0
                local reasons = {}
                if employee.isUnpaid then table.insert(reasons, "UNPAID") end
                if not employee:canWork() then table.insert(reasons, "CANNOT_WORK (break/exhausted)") end
                if not employee:isWithinShift(hour) then table.insert(reasons, string.format("OUTSIDE_SHIFT (%d:00, shift %d-%d)", hour, employee.shiftStart or 6, employee.shiftEnd or 18)) end
                if not employee.targetFieldId then table.insert(reasons, "NO_FIELD") end
                if employee.targetCrop and employee.targetCrop ~= "" then table.insert(reasons, "HAS_TARGET_CROP (using crop-based path)") end
                if #reasons > 0 then
                    CustomUtils:debug("[EmployeeManager] %s idle but autonomous: %s", employee.name, table.concat(reasons, ", "))
                end
            end
        end
    end

    self:checkPoolRefresh()
end

function EmployeeManager:getMarketMultiplier()
    local available = #self:getAvailableEmployees()
    local maxPool = #self.employeeTemplates
    if maxPool == 0 then return 1.0 end
    return 1.0 + 0.3 * (1 - available / maxPool)
end

function EmployeeManager:checkPoolRefresh()
    if g_currentMission == nil or g_currentMission.environment == nil then return end
    local currentDay = g_currentMission.environment.currentDay or 0
    if currentDay == self.lastDayChecked then return end
    self.lastDayChecked = currentDay

    if self.lastPoolRefreshDay == 0 then
        self.lastPoolRefreshDay = currentDay
        return
    end

    if (currentDay - self.lastPoolRefreshDay) >= self.POOL_REFRESH_DAYS then
        self:refreshCandidatePool()
        self.lastPoolRefreshDay = currentDay
    end
end

function EmployeeManager:subscribeEvents()
    g_messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.onPeriodChanged, self)
    g_messageCenter:subscribe(MessageType.DAY_CHANGED, self.onDayChanged, self)
    g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.onHourChanged, self)
    CustomUtils:info("[EmployeeManager] Subscribed to PERIOD_CHANGED, DAY_CHANGED, and HOUR_CHANGED events")
end

function EmployeeManager:unsubscribeEvents()
    g_messageCenter:unsubscribe(MessageType.PERIOD_CHANGED, self)
    g_messageCenter:unsubscribe(MessageType.DAY_CHANGED, self)
    g_messageCenter:unsubscribe(MessageType.HOUR_CHANGED, self)
    CustomUtils:info("[EmployeeManager] Unsubscribed from events")
end

function EmployeeManager:onPeriodChanged(period)
    if g_server == nil then return end
    self.lastPaymentPeriod = period or 0
    self.payrollRetryCount = 0
    self:processMonthlyPayroll()
end

function EmployeeManager:onDayChanged(day)
    if g_server == nil then return end

    for _, emp in ipairs(self.employees) do
        if emp.isHired then
            emp:resetDailyFatigue()
        end
    end

    local hasUnpaid = false
    for _, emp in ipairs(self.employees) do
        if emp.isHired and emp.isUnpaid then
            hasUnpaid = true
            break
        end
    end
    if hasUnpaid and self.payrollRetryCount < 3 then
        self.payrollRetryCount = self.payrollRetryCount + 1
        CustomUtils:info("[EmployeeManager] Payroll retry %d/3", self.payrollRetryCount)
        self:processMonthlyPayroll()
    end
end

function EmployeeManager:trackVehicleDistance(employee)
    local vehicle = self:getVehicleById(employee.assignedVehicleId)
    if vehicle == nil or vehicle.rootNode == nil then
        employee.lastVehicleX = nil
        employee.lastVehicleZ = nil
        return
    end

    local vx, _, vz = getWorldTranslation(vehicle.rootNode)
    if employee.lastVehicleX ~= nil and employee.lastVehicleZ ~= nil then
        local dx = vx - employee.lastVehicleX
        local dz = vz - employee.lastVehicleZ
        local dist = math.sqrt(dx * dx + dz * dz)

        if dist > 0.5 and dist < 500 then
            local km = dist / 1000
            employee.kmDriven = (employee.kmDriven or 0) + km
            employee:addExperience("driving", km)
        end
    end

    employee.lastVehicleX = vx
    employee.lastVehicleZ = vz
end

function EmployeeManager:onHourChanged()
    if g_server == nil then return end
    if g_currentMission == nil or g_currentMission.environment == nil then return end

    local currentHour = g_currentMission.environment.currentHour or 0

    for _, employee in ipairs(self.employees) do
        -- if not employee.isHired then
        if employee.isOnBreak then
            if employee.breakEndTime ~= nil and g_currentMission.time >= employee.breakEndTime then
                employee.isOnBreak = false
                employee.breakEndTime = nil
                CustomUtils:info("[EmployeeManager] %s break is over, ready to work", employee.name)
            end
        elseif employee.currentJob == nil and employee.isAutonomous and currentHour == (employee.shiftStart or 6) then
            CustomUtils:info("[EmployeeManager] Shift start: %s is autonomous and idle at %d:00 (shift %d-%d), update() will auto-start",
                employee.name, currentHour, employee.shiftStart or 6, employee.shiftEnd or 18)
        elseif employee.currentJob ~= nil then
            local jobType = employee.currentJob.type
            if jobType ~= "TRANSIT" and jobType ~= "RETURN_TO_PARKING" and jobType ~= "PREPARING" and jobType ~= "EQUIPMENT_READY" then
                if not employee:isWithinShift(currentHour) then
                    self.jobManager:stopJob(employee)
                    CustomUtils:info("[EmployeeManager] %s stopped: outside shift hours (%d:00, shift %d-%d)",
                        employee.name, currentHour, employee.shiftStart, employee.shiftEnd)
                end

                if employee.dailyHoursWorked >= 4 and not employee.breakTakenToday then
                    employee.breakTakenToday = true
                    employee.isOnBreak = true
                    employee.breakEndTime = g_currentMission.time + (30 * 60 * 1000)
                    self.jobManager:stopJob(employee)
                    CustomUtils:info("[EmployeeManager] %s taking 30min break after %.1fh worked", employee.name, employee.dailyHoursWorked)
                end

                if employee.dailyHoursWorked >= 8 then
                    self.jobManager:stopJob(employee)
                    CustomUtils:info("[EmployeeManager] %s exhausted after %.1fh, stopping until tomorrow", employee.name, employee.dailyHoursWorked)
                end
            end
        end

        -- Hourly state dump for ALL hired employees
        if employee.isHired then
            local jobDesc = "NONE"
            if employee.currentJob then
                jobDesc = string.format("%s (field %s)", employee.currentJob.type or "?", tostring(employee.currentJob.fieldId or "?"))
            end
            local queueDesc = "empty"
            if employee.taskQueue and #employee.taskQueue > 0 then
                queueDesc = string.format("%d tasks, idx=%d", #employee.taskQueue, employee.currentTaskIndex or 1)
            end
            CustomUtils:info(
                "[EmployeeManager] HOURLY[%d:00] %s | autonomous=%s | job=%s | field=%s | vehicle=%s | crop=%s | queue=%s | shift=%d-%d | inShift=%s | canWork=%s | unpaid=%s | hoursWorked=%.1f",
                currentHour,
                employee.name,
                tostring(employee.isAutonomous),
                jobDesc,
                tostring(employee.targetFieldId),
                tostring(employee.assignedVehicleId),
                tostring(employee.targetCrop),
                queueDesc,
                employee.shiftStart or 6,
                employee.shiftEnd or 18,
                tostring(employee:isWithinShift(currentHour)),
                tostring(employee:canWork()),
                tostring(employee.isUnpaid),
                employee.dailyHoursWorked or 0
            )
        end
    end
end

function EmployeeManager:processMonthlyPayroll()
    if g_server == nil then return end

    local farmId = g_currentMission:getFarmId()
    local balance = g_currentMission:getMoney(farmId)
    local totalPending = 0

    for _, emp in ipairs(self.employees) do
        if emp.isHired then
            totalPending = totalPending + (emp.pendingWages or 0)
        end
    end

    if totalPending <= 0 then return end

    if balance >= totalPending then
        local moneyType = MoneyType.WORKER_WAGES or MoneyType.OTHER
        g_currentMission:addMoney(-totalPending, farmId, moneyType, true)

        for _, emp in ipairs(self.employees) do
            if emp.isHired then
                emp.totalWagesPaid = (emp.totalWagesPaid or 0) + (emp.pendingWages or 0)
                emp.pendingWages = 0
                emp.isUnpaid = false
            end
        end

        CustomUtils:info("[EmployeeManager] Monthly payroll: $%.2f deducted", totalPending)
        if g_currentMission.hud ~= nil then
            g_currentMission:showBlinkingWarning(string.format(g_i18n:getText("em_payroll_success"), g_i18n:formatMoney(totalPending, 0, true, false)), 5000)
        end
    else
        for _, emp in ipairs(self.employees) do
            if emp.isHired then
                emp.isUnpaid = true
            end
        end

        CustomUtils:warning("[EmployeeManager] Payroll FAILED: need $%.2f, have $%.2f", totalPending, balance)
        if g_currentMission.hud ~= nil then
            g_currentMission:showBlinkingWarning(g_i18n:getText("em_payroll_failed"), 8000)
        end
    end
end

function EmployeeManager:refreshCandidatePool()
    local available = self:getAvailableEmployees()
    local removeCount = math.min(#available, math.random(1, 2))

    for i = 1, removeCount do
        if #available <= 0 then break end
        local idx = math.random(#available)
        local emp = available[idx]
        for j, e in ipairs(self.employees) do
            if e.id == emp.id then
                table.remove(self.employees, j)
                break
            end
        end
        table.remove(available, idx)
    end

    local currentAvailable = #self:getAvailableEmployees()
    local target = math.random(self.POOL_MIN, self.POOL_MAX)
    local toGenerate = math.max(0, target - currentAvailable)
    for _ = 1, toGenerate do
        self:generateEmployeeFromTemplate()
    end

    CustomUtils:info("[EmployeeManager] Pool refreshed: removed %d, generated %d. Available: %d",
        removeCount, toGenerate, #self:getAvailableEmployees())
    g_messageCenter:publish(MessageType.EMPLOYEE_ADDED)
end

function EmployeeManager:getDaysUntilPoolRefresh()
    if g_currentMission == nil or g_currentMission.environment == nil then return 0 end
    local currentDay = g_currentMission.environment.currentDay or 0
    local daysSince = currentDay - (self.lastPoolRefreshDay or currentDay)
    return math.max(0, self.POOL_REFRESH_DAYS - daysSince)
end

function EmployeeManager:trainEmployee(empId, skillName)
    local employee = self:getEmployeeById(empId)
    if employee == nil then return false, "Employee not found" end
    if not employee.isHired then return false, "Employee not hired" end

    local currentDay = 0
    if g_currentMission and g_currentMission.environment then
        currentDay = g_currentMission.environment.currentDay or 0
    end

    local canDo, reason = employee:canTrain(skillName, currentDay)
    if not canDo then return false, reason end

    local cost = employee:getTrainingCost(skillName)
    local farmId = g_currentMission:getFarmId()
    local balance = g_currentMission:getMoney(farmId)
    if balance < cost then return false, "not_enough_money" end

    g_currentMission:addMoney(-cost, farmId, MoneyType.OTHER, true)
    employee:train(skillName, currentDay)
    return true, "ok"
end

function EmployeeManager:onJobCompleted(employee)
    if employee then
        employee.tasksCompleted = (employee.tasksCompleted or 0) + 1
    end
end

---Returns list of hired employees
---@return table
function EmployeeManager:getHiredEmployees()
    local hired = {}
    for _, e in ipairs(self.employees) do
        if e.isHired then
            table.insert(hired, e)
        end
    end
    return hired
end

---Returns list of available (not hired) employees
---@return table
function EmployeeManager:getAvailableEmployees()
    local available = {}
    for _, e in ipairs(self.employees) do
        if not e.isHired then
            table.insert(available, e)
        end
    end
    return available
end

---Finds an employee by ID
---@param id number
---@return table|nil
function EmployeeManager:getEmployeeById(id)
    for _, e in ipairs(self.employees) do
        if e.id == id then
            return e
        end
    end
    return nil
end

---Finds a hired employee assigned to a specific vehicle
---@param vehicle table
---@return table|nil
function EmployeeManager:getEmployeeByVehicle(vehicle)
    if vehicle == nil then return nil end
    for _, e in ipairs(self.employees) do
        if e.isHired and e.assignedVehicleId == vehicle.id then
            return e
        end
    end
    return nil
end

---Returns rented equipment for an employee
---@param employee table
function EmployeeManager:returnRentedEquipment(employee)
    if not employee or not employee.temporaryRental then return end
    
    local toolId = employee.temporaryRental
    local tool = self:getVehicleById(toolId)
    
    if tool then
        CustomUtils:info("[EmployeeManager] Returning rented equipment %s (ID: %d) for employee %s", tool:getName(), toolId, employee.name)

        local vehicle = self:getVehicleById(employee.assignedVehicleId)
        if vehicle and vehicle.detachImplementByObject then
            vehicle:detachImplementByObject(tool)
        end

        if g_currentMission.removeSaleableItem then
            pcall(g_currentMission.removeSaleableItem, g_currentMission, tool)
        end

        local ok, err = pcall(tool.delete, tool)
        if not ok then
            CustomUtils:warning("[EmployeeManager] Error deleting rented tool ID %d: %s", toolId, tostring(err))
        end
    else
        CustomUtils:warning("[EmployeeManager] Rented tool ID %d not found (already deleted?), clearing reference for %s", toolId, employee.name)
    end

    employee.temporaryRental = nil
    employee.isRenting = false
end

---Hires an employee by ID
---@param id number
---@return table|nil The hired employee or nil
function EmployeeManager:hireEmployee(id)
    local employee = self:getEmployeeById(id)
    if employee then
        employee.isHired = true
        g_messageCenter:publish(MessageType.EMPLOYEE_ADDED)
        CustomUtils:info("[EmployeeManager] Hired employee %d (%s)", id, employee.name)
        return employee
    end
    CustomUtils:error("[EmployeeManager] Failed to hire employee: ID %d not found", id)
    return nil
end

---Fires an employee by ID
---@param id number
---@return boolean Success
function EmployeeManager:fireEmployee(id)
    local employee = self:getEmployeeById(id)
    if employee then
        if employee.currentJob then
            self.jobManager:stopJob(employee)
        end

        self:returnRentedEquipment(employee)

        if (employee.pendingWages or 0) > 0 then
            local farmId = g_currentMission:getFarmId()
            local moneyType = MoneyType.WORKER_WAGES or MoneyType.OTHER
            g_currentMission:addMoney(-employee.pendingWages, farmId, moneyType, true)
            employee.totalWagesPaid = (employee.totalWagesPaid or 0) + employee.pendingWages
            CustomUtils:info("[EmployeeManager] Paid $%.2f pending wages to %s on termination", employee.pendingWages, employee.name)
            employee.pendingWages = 0
        end

        employee.isHired = false
        employee.isUnpaid = false
        employee:unassignVehicle()
        employee.assignedField = nil
        employee.workTime = 0
        g_messageCenter:publish(MessageType.EMPLOYEE_REMOVED)
        CustomUtils:info("[EmployeeManager] Fired employee %d (%s)", id, employee.name)
        return true
    end
    CustomUtils:error("[EmployeeManager] Failed to fire employee: ID %d not found", id)
    return false
end

---Loads employee templates from xml/data/employees.xml
---@param modDirectory string The mod's base directory path
function EmployeeManager:loadEmployeeTemplates(modDirectory)
    self.employeeTemplates = {}
    local xmlPath = modDirectory .. "xml/data/employees.xml"
    local xmlFile = loadXMLFile("employeeTemplates", xmlPath)

    if xmlFile == nil or xmlFile == 0 then
        CustomUtils:error("[EmployeeManager] Failed to load employee templates from: %s", xmlPath)
        return
    end

    local i = 0
    while true do
        local key = string.format("employees.employee(%d)", i)
        local firstName = getXMLString(xmlFile, key .. "#firstName")
        if firstName == nil then
            break
        end

        local lastName = getXMLString(xmlFile, key .. "#lastName") or ""
        local skillsKey = key .. ".skills"

        local traitsStr = getXMLString(xmlFile, key .. "#traits")
        local possibleTraits = {}
        if traitsStr then
            for trait in traitsStr:gmatch("[^,]+") do
                trait = trait:match("^%s*(.-)%s*$")
                if TraitSystem.TRAITS[trait] then
                    table.insert(possibleTraits, trait)
                end
            end
        end

        local template = {
            firstName = firstName,
            lastName = lastName,
            drivingMin = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#drivingMin"), 1),
            drivingMax = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#drivingMax"), 3),
            harvestingMin = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#harvestingMin"), 1),
            harvestingMax = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#harvestingMax"), 3),
            technicalMin = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#technicalMin"), 1),
            technicalMax = Utils.getNoNil(getXMLInt(xmlFile, skillsKey .. "#technicalMax"), 3),
            possibleTraits = possibleTraits,
            age = Utils.getNoNil(getXMLInt(xmlFile, key .. "#age"), 30),
            nationality = Utils.getNoNil(getXMLString(xmlFile, key .. "#nationality"), "FR"),
            gender = Utils.getNoNil(getXMLString(xmlFile, key .. "#gender"), "male"),
            bioKey = getXMLString(xmlFile, key .. "#bio"),
            personalityKey = getXMLString(xmlFile, key .. "#personality"),
            experienceKey = getXMLString(xmlFile, key .. "#experience"),
            quoteKey = getXMLString(xmlFile, key .. "#quote"),
        }

        table.insert(self.employeeTemplates, template)
        i = i + 1
    end

    delete(xmlFile)
    CustomUtils:info("[EmployeeManager] Loaded %d employee templates", #self.employeeTemplates)
end

---Returns template names already used by current employees
---@return table Set of "FirstName LastName" strings
function EmployeeManager:getUsedTemplateNames()
    local used = {}
    for _, e in ipairs(self.employees) do
        used[e.name] = true
    end
    return used
end

---Generates one employee from an unused template
---@return table|nil The new employee, or nil if no templates available
function EmployeeManager:generateEmployeeFromTemplate()
    if #self.employeeTemplates == 0 then
        CustomUtils:warning("[EmployeeManager] No templates loaded, cannot generate employee")
        return nil
    end

    local usedNames = self:getUsedTemplateNames()
    local available = {}
    for _, tpl in ipairs(self.employeeTemplates) do
        local fullName = tpl.firstName .. " " .. tpl.lastName
        if not usedNames[fullName] then
            table.insert(available, tpl)
        end
    end

    if #available == 0 then
        CustomUtils:warning("[EmployeeManager] All templates already in use (%d/%d)", #self.employees, #self.employeeTemplates)
        return nil
    end

    local template = available[math.random(#available)]
    local id = self.nextEmployeeId
    self.nextEmployeeId = self.nextEmployeeId + 1
    local name = template.firstName .. " " .. template.lastName

    local skills = {
        driving = math.random(template.drivingMin, template.drivingMax),
        harvesting = math.random(template.harvestingMin, template.harvestingMax),
        technical = math.random(template.technicalMin, template.technicalMax),
    }

    local employee = Employee.new(id, name, skills)

    if template.possibleTraits and #template.possibleTraits > 0 then
        employee.traits = TraitSystem.selectTraits(template.possibleTraits)
    end

    employee.age = (template.age or 30) + math.random(0, 5)
    employee.nationality = template.nationality or "FR"
    employee.gender = template.gender or "male"
    employee.bioKey = template.bioKey
    employee.personalityKey = template.personalityKey
    employee.experienceKey = template.experienceKey
    employee.quoteKey = template.quoteKey

    table.insert(self.employees, employee)
    local traitLog = (#employee.traits > 0) and table.concat(employee.traits, ",") or "none"
    CustomUtils:info("[EmployeeManager] Generated employee from template: %s (ID: %d) [D:%d H:%d T:%d] Traits:%s",
        name, id, skills.driving, skills.harvesting, skills.technical, traitLog)

    g_messageCenter:publish(MessageType.EMPLOYEE_ADDED)
    return employee
end

---Generates an initial pool of employees from templates
---@param count number Number of employees to generate
function EmployeeManager:generateInitialPool(count)
    local generated = 0
    for _ = 1, count do
        local emp = self:generateEmployeeFromTemplate()
        if emp == nil then
            break
        end
        generated = generated + 1
    end
    CustomUtils:info("[EmployeeManager] Generated initial pool: %d employees", generated)
end

---Console command wrapper for generating a new candidate
function EmployeeManager:consoleGenerateCandidate()
    local emp = self:generateEmployeeFromTemplate()
    if emp then
        return string.format("Generated candidate: %s (ID: %d) [D:%d H:%d T:%d]",
            emp.name, emp.id, emp.skills.driving, emp.skills.harvesting, emp.skills.technical)
    end
    return "Failed to generate candidate (all templates may be in use)"
end

function EmployeeManager:setFieldConfig(fieldId, cropName, assignments)
    self.fieldConfigs[fieldId] = {
        cropName = cropName,
        assignments = assignments or {}
    }
    CustomUtils:info("[EmployeeManager] Configured workflow for Field %d: %s", fieldId, cropName)
end

function EmployeeManager:setFieldTargetCrop(fieldId, cropName)
    if not self.fieldConfigs[fieldId] then
        self.fieldConfigs[fieldId] = {}
    end
    self.fieldConfigs[fieldId].cropName = cropName
    CustomUtils:info("[EmployeeManager] Set target crop for Field %d to %s", fieldId, cropName)
end

function EmployeeManager:getFieldTargetCrop(fieldId)
    local config = self.fieldConfigs[fieldId]
    return config and config.cropName or nil
end

function EmployeeManager:getAssignedEmployeeForStep(fieldId, stepName)
    local config = self.fieldConfigs[fieldId]
    if config and config.assignments then
        local empId = config.assignments[stepName]
        if empId then
            return self:getEmployeeById(empId)
        end
    end
    return nil
end

function EmployeeManager:assignVehicleToEmployee(employeeId, vehicleId)
    local employee = self:getEmployeeById(employeeId)
    local vehicle = self:getVehicleById(vehicleId)

    if employee and vehicle then
        employee:assignVehicle(vehicle)

        if g_parkingManager then
            g_parkingManager:autoRecordSpot(vehicleId)
        end
        CustomUtils:info("[EmployeeManager] Assigned vehicle %s to employee %s", vehicle:getName(), employee.name)
        return true
    end
    return false
end

function EmployeeManager:getVehicleById(vehicleId)
    if g_currentMission.vehicleSystem ~= nil and g_currentMission.vehicleSystem.vehicles ~= nil then
        for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do
            if vehicle.id == vehicleId then
                return vehicle
            end
        end
    end
    return nil
end

function EmployeeManager:consoleAssignVehicle(id, vehId)
    id = tonumber(id)
    vehId = tonumber(vehId)
    if self:assignVehicleToEmployee(id, vehId) then
        return "Vehicle assigned successfully"
    end
    return "Failed to assign vehicle (invalid ID or vehicle not found)"
end

function EmployeeManager:consoleUnassignVehicle(id)
    id = tonumber(id)
    local emp = self:getEmployeeById(id)
    if emp then
        emp:unassignVehicle()
        return "Vehicle unassigned"
    end
    return "Employee not found"
end

function EmployeeManager:consoleListEmployees()
    print("--- Employee List ---")
    for _, e in ipairs(self.employees) do
        local status = e.isHired and "HIRED" or "AVAILABLE"
        local job = e.currentJob and e.currentJob.type or "IDLE"
        local traitStr = (#(e.traits or {}) > 0) and table.concat(e.traits, ",") or "none"
        local wage = e:getHourlyWage()
        local fatigueStr = ""
        if e.isHired then
            fatigueStr = string.format(" | Km: %.1f | Fatigue: %.0f%% | DayH: %.1fh",
                e.kmDriven or 0, e.fatigueLevel or 0, e.dailyHoursWorked or 0)
            if e.isOnBreak then fatigueStr = fatigueStr .. " [BREAK]" end
        end
        print(string.format("[%d] %s | %s | Job: %s | Trait: %s | Wage: $%.1f/h%s",
            e.id, e.name, status, job, traitStr, wage, fatigueStr))
    end
    return "End of list"
end

function EmployeeManager:consoleTrain(id, skillName)
    id = tonumber(id)
    if id == nil or skillName == nil then
        return "Usage: emTrain <id> <skillName> (driving/harvesting/technical)"
    end
    local ok, reason = self:trainEmployee(id, skillName)
    if ok then
        local emp = self:getEmployeeById(id)
        return string.format("Trained %s's %s to level %d", emp.name, skillName, emp.skills[skillName])
    end
    return "Training failed: " .. tostring(reason)
end

function EmployeeManager:consoleParkingAdd(name)
    if not g_parkingManager then return "Parking manager not loaded" end
    if not name or name == "" then return "Usage: emParkingAdd <name>" end

    local player = g_localPlayer
    if player == nil then return "Player not found" end

    local x, y, z = getWorldTranslation(player.rootNode)
    local dx, _, dz = localDirectionToWorld(player.rootNode, 0, 0, 1)
    local angle = MathUtil.getYRotationFromDirection(dx, dz)

    local id = g_parkingManager:addSpot(name, x, y, z, angle)
    return string.format("Parking spot '%s' added (ID: %d) at %.1f, %.1f, %.1f", name, id, x, y, z)
end

function EmployeeManager:consoleParkingList()
    if not g_parkingManager then return "Parking manager not loaded" end
    print("--- Parking Spots ---")
    local spots = g_parkingManager.spots or {}
    if #spots == 0 then
        print("No parking spots defined.")
    else
        for _, spot in ipairs(spots) do
            local vehicleName = "empty"
            if spot.vehicleId then
                local v = self:getVehicleById(spot.vehicleId)
                vehicleName = v and v:getName() or ("ID:" .. tostring(spot.vehicleId))
            end
            print(string.format("[%d] %s | Pos: %.0f,%.0f,%.0f | Vehicle: %s",
                spot.id, spot.name, spot.x, spot.y, spot.z, vehicleName))
        end
    end
    return "End of list"
end

function EmployeeManager:consoleParkingRemove(id)
    if not g_parkingManager then return "Parking manager not loaded" end
    id = tonumber(id)
    if id == nil then return "Usage: emParkingRemove <id>" end
    if g_parkingManager:removeSpot(id) then
        return string.format("Parking spot %d removed", id)
    end
    return "Spot not found"
end

function EmployeeManager:consoleParkingAssign(spotId, vehicleId)
    if not g_parkingManager then return "Parking manager not loaded" end
    spotId = tonumber(spotId)
    vehicleId = tonumber(vehicleId)
    if spotId == nil or vehicleId == nil then return "Usage: emParkingAssign <spotId> <vehicleId>" end
    if g_parkingManager:assignVehicle(spotId, vehicleId) then
        return string.format("Vehicle %d assigned to spot %d", vehicleId, spotId)
    end
    return "Failed (invalid spot or vehicle ID)"
end

function EmployeeManager:consoleStartTask(id, taskName, fieldId)
    id = tonumber(id)
    fieldId = tonumber(fieldId)
    local emp = self:getEmployeeById(id)
    if not emp then return "Employee not found" end
    
    if self.jobManager:startFieldWork(emp, fieldId, taskName) then
        return string.format("Task %s started for %s on Field %d", taskName, emp.name, fieldId)
    end
    return "Failed to start task"
end

function EmployeeManager:consoleSetTargetCrop(id, fieldId, cropName)
    id = tonumber(id)
    fieldId = tonumber(fieldId)
    local emp = self:getEmployeeById(id)
    if emp then
        emp.targetFieldId = fieldId
        emp.targetCrop = cropName
        return "Target crop set"
    end
    return "Employee not found"
end

function EmployeeManager:consoleDebugVehicles()
    local farmId = g_currentMission:getFarmId()
    print("--- Farm Vehicles ---")
    for _, v in pairs(g_currentMission.vehicleSystem.vehicles) do
        if v.ownerFarmId == farmId then
            print(string.format("ID: %d | %s", v.id, v:getName()))
        end
    end
    return "End of list"
end

function EmployeeManager:saveToXMLFile(xmlFile, key)
    CustomUtils:debug("[EmployeeManager] Saving employees to XML...")
    local empKey = key .. ".employees"
    for i, e in ipairs(self.employees) do
        local base = string.format("%s.employee(%d)", empKey, i - 1)
        setXMLInt(xmlFile, base .. "#id", e.id)
        setXMLString(xmlFile, base .. "#name", e.name)
        setXMLBool(xmlFile, base .. "#isHired", e.isHired)
        setXMLFloat(xmlFile, base .. "#workTime", e.workTime)
        setXMLFloat(xmlFile, base .. "#kmDriven", e.kmDriven)
        setXMLInt(xmlFile, base .. "#assignedVehicleId", e.assignedVehicleId or 0)

        setXMLInt(xmlFile, base .. ".skills#driving", e.skills.driving)
        setXMLInt(xmlFile, base .. ".skills#harvesting", e.skills.harvesting)
        setXMLInt(xmlFile, base .. ".skills#technical", e.skills.technical)
        setXMLFloat(xmlFile, base .. ".skills#drivingXP", e.skillXP.driving)
        setXMLFloat(xmlFile, base .. ".skills#harvestingXP", e.skillXP.harvesting)
        setXMLFloat(xmlFile, base .. ".skills#technicalXP", e.skillXP.technical)

        if e.currentJob ~= nil then
            setXMLString(xmlFile, base .. ".currentJob#jobType", e.currentJob.type)
            setXMLInt(xmlFile, base .. ".currentJob#fieldId", e.currentJob.fieldId or 0)
        end

        if e.targetCrop ~= nil then
            setXMLString(xmlFile, base .. "#targetCrop", e.targetCrop)
        end
        setXMLInt(xmlFile, base .. "#targetFieldId", e.targetFieldId or 0)
        setXMLBool(xmlFile, base .. "#isAutonomous", e.isAutonomous or false)
        setXMLInt(xmlFile, base .. "#currentTaskIndex", e.currentTaskIndex or 1)

        setXMLInt(xmlFile, base .. "#shiftStart", e.shiftStart or 6)
        setXMLInt(xmlFile, base .. "#shiftEnd", e.shiftEnd or 18)

        local traitsStr = TraitSystem.serialize(e.traits)
        if traitsStr ~= "" then
            setXMLString(xmlFile, base .. "#traits", traitsStr)
        end
        setXMLInt(xmlFile, base .. "#lastTrainingDay", e.lastTrainingDay or 0)
        setXMLFloat(xmlFile, base .. "#totalWagesPaid", e.totalWagesPaid or 0)
        setXMLInt(xmlFile, base .. "#tasksCompleted", e.tasksCompleted or 0)
        setXMLFloat(xmlFile, base .. "#pendingWages", e.pendingWages or 0)
        setXMLBool(xmlFile, base .. "#isUnpaid", e.isUnpaid or false)

        setXMLFloat(xmlFile, base .. "#dailyHoursWorked", e.dailyHoursWorked or 0)
        setXMLFloat(xmlFile, base .. "#fatigueLevel", e.fatigueLevel or 0)
        setXMLBool(xmlFile, base .. "#isOnBreak", e.isOnBreak or false)
        setXMLFloat(xmlFile, base .. "#milestoneWageMult", e.milestoneWageMult or 1.0)

        setXMLInt(xmlFile, base .. "#age", e.age or 30)
        setXMLString(xmlFile, base .. "#nationality", e.nationality or "FR")
        setXMLString(xmlFile, base .. "#gender", e.gender or "male")
        if e.bioKey then setXMLString(xmlFile, base .. "#bioKey", e.bioKey) end
        if e.personalityKey then setXMLString(xmlFile, base .. "#personalityKey", e.personalityKey) end
        if e.experienceKey then setXMLString(xmlFile, base .. "#experienceKey", e.experienceKey) end
        if e.quoteKey then setXMLString(xmlFile, base .. "#quoteKey", e.quoteKey) end

        local queue = e.taskQueue or {}
        for qi, taskName in ipairs(queue) do
            local taskKey = string.format("%s.taskQueue.task(%d)", base, qi - 1)
            setXMLString(xmlFile, taskKey .. "#name", taskName)
        end
    end

    setXMLInt(xmlFile, key .. ".poolState#nextEmployeeId", self.nextEmployeeId)
    setXMLInt(xmlFile, key .. ".poolState#lastRefreshDay", self.lastPoolRefreshDay or 0)
    setXMLInt(xmlFile, key .. ".poolState#lastPaymentPeriod", self.lastPaymentPeriod or 0)

    if g_parkingManager then
        g_parkingManager:saveToXMLFile(xmlFile, key .. ".parking")
    end

    return true
end

function EmployeeManager:loadFromXMLFile(xmlFile, key)
    CustomUtils:debug("[EmployeeManager] Loading employees from XML...")
    self.employees = {}

    local empKey = key .. ".employees"
    local i = 0
    while true do
        local base = string.format("%s.employee(%d)", empKey, i)
        local id = getXMLInt(xmlFile, base .. "#id")
        if id == nil then
            break
        end

        local name = getXMLString(xmlFile, base .. "#name") or ("Employee_" .. tostring(id))
        local driving = Utils.getNoNil(getXMLInt(xmlFile, base .. ".skills#driving"), 1)
        local harvesting = Utils.getNoNil(getXMLInt(xmlFile, base .. ".skills#harvesting"), 1)
        local technical = Utils.getNoNil(getXMLInt(xmlFile, base .. ".skills#technical"), 1)

        local emp = Employee.new(id, name, { driving = driving, harvesting = harvesting, technical = technical })
        emp.skillXP.driving = Utils.getNoNil(getXMLFloat(xmlFile, base .. ".skills#drivingXP"), 0)
        emp.skillXP.harvesting = Utils.getNoNil(getXMLFloat(xmlFile, base .. ".skills#harvestingXP"), 0)
        emp.skillXP.technical = Utils.getNoNil(getXMLFloat(xmlFile, base .. ".skills#technicalXP"), 0)

        emp.isHired = Utils.getNoNil(getXMLBool(xmlFile, base .. "#isHired"), false)
        emp.workTime = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#workTime"), 0)
        emp.kmDriven = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#kmDriven"), 0)

        local assignedVehicleId = getXMLInt(xmlFile, base .. "#assignedVehicleId")
        if assignedVehicleId and assignedVehicleId ~= 0 then
            local vehicle = self:getVehicleById(assignedVehicleId)
            if vehicle then
                emp:assignVehicle(vehicle)
            else
                emp.assignedVehicleId = assignedVehicleId 
            end
        end

        local jobType = getXMLString(xmlFile, base .. ".currentJob#jobType")
        local fieldId = getXMLInt(xmlFile, base .. ".currentJob#fieldId")
        if jobType ~= nil then
            emp.currentJob = { type = jobType }
            if fieldId ~= nil then emp.currentJob.fieldId = fieldId end
        end

        emp.targetCrop = getXMLString(xmlFile, base .. "#targetCrop")
        emp.targetFieldId = getXMLInt(xmlFile, base .. "#targetFieldId")
        if emp.targetFieldId == 0 then emp.targetFieldId = nil end
        emp.isAutonomous = Utils.getNoNil(getXMLBool(xmlFile, base .. "#isAutonomous"), false)
        emp.shiftStart = Utils.getNoNil(getXMLInt(xmlFile, base .. "#shiftStart"), 6)
        emp.shiftEnd = Utils.getNoNil(getXMLInt(xmlFile, base .. "#shiftEnd"), 18)

        local traitsStr = getXMLString(xmlFile, base .. "#traits")
        local singleTrait = getXMLString(xmlFile, base .. "#trait")
        if traitsStr then
            emp.traits = TraitSystem.deserialize(traitsStr)
        elseif singleTrait then
            emp.traits = { singleTrait }
        else
            emp.traits = {}
        end
        emp.lastTrainingDay = Utils.getNoNil(getXMLInt(xmlFile, base .. "#lastTrainingDay"), 0)
        emp.totalWagesPaid = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#totalWagesPaid"), 0)
        emp.tasksCompleted = Utils.getNoNil(getXMLInt(xmlFile, base .. "#tasksCompleted"), 0)
        emp.pendingWages = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#pendingWages"), 0)
        emp.isUnpaid = Utils.getNoNil(getXMLBool(xmlFile, base .. "#isUnpaid"), false)

        emp.dailyHoursWorked = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#dailyHoursWorked"), 0)
        emp.fatigueLevel = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#fatigueLevel"), 0)
        emp.isOnBreak = Utils.getNoNil(getXMLBool(xmlFile, base .. "#isOnBreak"), false)
        emp.milestoneWageMult = Utils.getNoNil(getXMLFloat(xmlFile, base .. "#milestoneWageMult"), 1.0)

        emp.age = Utils.getNoNil(getXMLInt(xmlFile, base .. "#age"), 30)
        emp.nationality = Utils.getNoNil(getXMLString(xmlFile, base .. "#nationality"), "FR")
        emp.gender = Utils.getNoNil(getXMLString(xmlFile, base .. "#gender"), "male")
        emp.bioKey = getXMLString(xmlFile, base .. "#bioKey")
        emp.personalityKey = getXMLString(xmlFile, base .. "#personalityKey")
        emp.experienceKey = getXMLString(xmlFile, base .. "#experienceKey")
        emp.quoteKey = getXMLString(xmlFile, base .. "#quoteKey")

        emp.taskQueue = {}
        local qi = 0
        while true do
            local taskKey = string.format("%s.taskQueue.task(%d)", base, qi)
            local taskName = getXMLString(xmlFile, taskKey .. "#name")
            if taskName == nil then break end
            table.insert(emp.taskQueue, taskName)
            qi = qi + 1
        end
        emp.currentTaskIndex = Utils.getNoNil(getXMLInt(xmlFile, base .. "#currentTaskIndex"), 1)

        table.insert(self.employees, emp)
        i = i + 1
    end

    -- Compute max ID from loaded employees as safety fallback
    local maxId = 0
    for _, emp in ipairs(self.employees) do
        if emp.id > maxId then maxId = emp.id end
    end
    self.nextEmployeeId = Utils.getNoNil(getXMLInt(xmlFile, key .. ".poolState#nextEmployeeId"), maxId + 1)
    -- Ensure nextEmployeeId is always above any loaded ID (guards against stale save data)
    if self.nextEmployeeId <= maxId then
        self.nextEmployeeId = maxId + 1
    end

    self.lastPoolRefreshDay = Utils.getNoNil(getXMLInt(xmlFile, key .. ".poolState#lastRefreshDay"), 0)
    self.lastPaymentPeriod = Utils.getNoNil(getXMLInt(xmlFile, key .. ".poolState#lastPaymentPeriod"), 0)

    if g_parkingManager then
        g_parkingManager:loadFromXMLFile(xmlFile, key .. ".parking")
    end

    local hiredCount = 0
    for _, emp in ipairs(self.employees) do
        if emp.isHired then hiredCount = hiredCount + 1 end
    end
    CustomUtils:info("[EmployeeManager] Loaded %d employees (%d hired), nextEmployeeId=%d", #self.employees, hiredCount, self.nextEmployeeId)

    local numToGenerate = 10 - #self.employees
    if numToGenerate > 0 then
        CustomUtils:info("[EmployeeManager] Filling pool: generating %d candidates from templates", numToGenerate)
        self:generateInitialPool(numToGenerate)
    end
end

function EmployeeManager:writeStream(streamId, connection)
    streamWriteInt32(streamId, #self.employees)
    for _, employee in ipairs(self.employees) do
        employee:writeStream(streamId, connection)
    end
end

function EmployeeManager:readStream(streamId, connection)
    local numEmployees = streamReadInt32(streamId)
    self.employees = {}
    for _ = 1, numEmployees do
        local employee = Employee.new(0, "", {})
        employee:readStream(streamId, connection)
        
        if employee.assignedVehicleId then
            local vehicle = self:getVehicleById(employee.assignedVehicleId)
            if vehicle then
                employee:assignVehicle(vehicle)
            end
        end
        
        table.insert(self.employees, employee)
    end
end
