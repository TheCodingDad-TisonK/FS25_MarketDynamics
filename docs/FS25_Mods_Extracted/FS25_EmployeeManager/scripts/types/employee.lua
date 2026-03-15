Employee = {}

local Employee_mt = Class(Employee)

Employee.TRAITS = TraitSystem.TRAITS
Employee.XP_RATES = SkillSystem.XP_RATES

function Employee.new(id, name, skills)
    local self = setmetatable({}, Employee_mt)
    self.id = id or 0
    self.name = name or ("Employee_" .. tostring(self.id))
    self.skills = skills or { driving = 1, harvesting = 1, technical = 1 }
    self.skillXP = { driving = 0, harvesting = 0, technical = 0 }

    self.isHired = false
    self.assignedVehicle = nil
    self.assignedVehicleId = nil
    self.assignedField = nil
    self.workTime = 0
    self.kmDriven = 0
    self.currentJob = nil
    self.targetCrop = nil
    self.targetFieldId = nil
    self.isRenting = false
    self.isAutonomous = false
    self.taskQueue = {}
    self.currentTaskIndex = 1
    self.shiftStart = 6
    self.shiftEnd = 18

    self.traits = {}
    self.lastTrainingDay = 0
    self.totalWagesPaid = 0
    self.tasksCompleted = 0
    self.pendingWages = 0
    self.isUnpaid = false
    self.milestoneWageMult = 1.0

    self.lastVehicleX = nil
    self.lastVehicleZ = nil

    self.age = 30
    self.nationality = "FR"
    self.gender = "male"
    self.bioKey = nil
    self.personalityKey = nil
    self.experienceKey = nil
    self.quoteKey = nil

    self.dailyHoursWorked = 0
    self.fatigueLevel = 0
    self.isOnBreak = false
    self.breakEndTime = nil
    self.breakTakenToday = false

    return self
end

function Employee:addExperience(skillName, amount)
    return SkillSystem.addExperience(self, skillName, amount)
end

function Employee:assignVehicle(vehicle)
    if vehicle ~= nil then
        self.assignedVehicle = vehicle
        self.assignedVehicleId = vehicle.id
        return true
    end
    return false
end

function Employee:unassignVehicle()
    self.assignedVehicle = nil
    self.assignedVehicleId = nil
end

function Employee:getDailyWage()
    return self:getHourlyWage() * 12
end

function Employee:getBaseHourlyWage()
    return 5 + ((self.skills.driving or 0) * 0.8) + ((self.skills.harvesting or 0) * 0.8) + ((self.skills.technical or 0) * 0.4)
end

function Employee:getHourlyWage()
    local base = self:getBaseHourlyWage()
    local traitMult = SkillEffects.getWageTraitMultiplier(self)
    local expMult = math.min(1.25, 1.0 + (self.workTime / 500))
    return base * traitMult * expMult * self.milestoneWageMult
end

function Employee:getTechnicalMultiplier()
    return SkillEffects.getWearMultiplier(self)
end

function Employee:getTraitMultiplier(property)
    return TraitSystem.getMultiplier(self.traits, property)
end

function Employee:getTraitName()
    return TraitSystem.getTraitNames(self.traits)
end

function Employee:getTrainingCost(skillName)
    local currentLevel = self.skills[skillName] or 1
    return math.floor(500 * SkillSystem.XP_EXPONENT ^ (currentLevel - 1))
end

function Employee:getTrainingCooldown()
    local maxLevel = 0
    for _, skillName in ipairs(SkillSystem.SKILL_NAMES) do
        local level = self.skills[skillName] or 1
        if level > maxLevel then maxLevel = level end
    end
    return maxLevel >= 6 and 3 or 2
end

function Employee:canTrain(skillName, currentDay)
    local level = self.skills[skillName]
    if level == nil or level >= SkillSystem.MAX_LEVEL then return false, "max_level" end
    local cooldown = self:getTrainingCooldown()
    if (currentDay - self.lastTrainingDay) < cooldown then return false, "cooldown" end
    return true, "ok"
end

function Employee:train(skillName, currentDay)
    if self.skills[skillName] == nil or self.skills[skillName] >= SkillSystem.MAX_LEVEL then return false end
    self.skills[skillName] = self.skills[skillName] + 1
    self.skillXP[skillName] = 0
    self.lastTrainingDay = currentDay
    CustomUtils:info("[Employee] %s trained %s to level %d", self.name, skillName, self.skills[skillName])
    g_messageCenter:publish(MessageType.EMPLOYEE_SKILL_LEVELUP, self, skillName, self.skills[skillName])
    return true
end

function Employee:updateWorkTime(dt)
    if self.isHired and self.currentJob ~= nil then
        local hours = dt / (1000 * 60 * 60)
        self.workTime = self.workTime + hours
        self.dailyHoursWorked = self.dailyHoursWorked + hours
        self.fatigueLevel = math.min(100, self.dailyHoursWorked / 8 * 100)
        return hours
    end
    return 0
end

function Employee:canWork()
    if self.isOnBreak then return false end
    if self.dailyHoursWorked >= 8 then return false end
    return true
end

function Employee:isWithinShift(currentHour)
    local s = self.shiftStart or 6
    local e = self.shiftEnd or 18
    if s < e then
        return currentHour >= s and currentHour < e
    else
        return currentHour >= s or currentHour < e
    end
end

function Employee:getFatigueMultiplier()
    if self.dailyHoursWorked <= 6 then
        return 1.0
    end
    local overtime = math.min(2, self.dailyHoursWorked - 6)
    return 1.0 - (overtime * 0.075)
end

function Employee:resetDailyFatigue()
    self.dailyHoursWorked = 0
    self.fatigueLevel = 0
    self.isOnBreak = false
    self.breakEndTime = nil
    self.breakTakenToday = false
end

function Employee:getFullName()
    return self.name
end

function Employee:setJob(jobTable)
    self.currentJob = jobTable
end

function Employee:clearJob()
    self.currentJob = nil
end

function Employee:toTable()
    return {
        id = self.id,
        name = self.name,
        skills = self.skills,
        skillXP = self.skillXP,
        isHired = self.isHired,
        assignedVehicleId = self.assignedVehicleId,
        currentJob = self.currentJob,
        isRenting = self.isRenting,
        workTime = self.workTime,
        kmDriven = self.kmDriven,
        targetCrop = self.targetCrop,
        targetFieldId = self.targetFieldId,
        isAutonomous = self.isAutonomous,
        taskQueue = self.taskQueue,
        currentTaskIndex = self.currentTaskIndex,
        shiftStart = self.shiftStart,
        shiftEnd = self.shiftEnd,
        traits = self.traits,
        lastTrainingDay = self.lastTrainingDay,
        totalWagesPaid = self.totalWagesPaid,
        tasksCompleted = self.tasksCompleted,
        pendingWages = self.pendingWages,
        isUnpaid = self.isUnpaid,
        milestoneWageMult = self.milestoneWageMult,
        dailyHoursWorked = self.dailyHoursWorked,
        fatigueLevel = self.fatigueLevel,
        isOnBreak = self.isOnBreak,
        age = self.age,
        nationality = self.nationality,
        gender = self.gender,
        bioKey = self.bioKey,
        personalityKey = self.personalityKey,
        experienceKey = self.experienceKey,
        quoteKey = self.quoteKey,
    }
end

function Employee.fromTable(data)
    if data == nil then
        return nil
    end
    local e = Employee.new(data.id, data.name, data.skills)
    if data.skillXP and type(data.skillXP) == "table" then
        e.skillXP = { driving = data.skillXP.driving or 0, harvesting = data.skillXP.harvesting or 0, technical = data.skillXP.technical or 0 }
    end
    e.isHired = data.isHired or false
    e.workTime = data.workTime or 0
    e.kmDriven = data.kmDriven or 0
    e.targetCrop = data.targetCrop
    e.targetFieldId = data.targetFieldId
    e.isAutonomous = data.isAutonomous or false
    e.currentJob = data.currentJob
    e.isRenting = data.isRenting
    e.assignedVehicleId = data.assignedVehicleId
    e.taskQueue = data.taskQueue or {}
    e.currentTaskIndex = data.currentTaskIndex or 1
    e.shiftStart = data.shiftStart or 6
    e.shiftEnd = data.shiftEnd or 18
    if data.traits and type(data.traits) == "table" then
        e.traits = data.traits
    elseif data.trait and type(data.trait) == "string" then
        e.traits = { data.trait }
    else
        e.traits = {}
    end
    e.lastTrainingDay = data.lastTrainingDay or 0
    e.totalWagesPaid = data.totalWagesPaid or 0
    e.tasksCompleted = data.tasksCompleted or 0
    e.pendingWages = data.pendingWages or 0
    e.isUnpaid = data.isUnpaid or false
    e.milestoneWageMult = data.milestoneWageMult or 1.0
    e.dailyHoursWorked = data.dailyHoursWorked or 0
    e.fatigueLevel = data.fatigueLevel or 0
    e.isOnBreak = data.isOnBreak or false
    e.age = data.age or 30
    e.nationality = data.nationality or "FR"
    e.gender = data.gender or "male"
    e.bioKey = data.bioKey
    e.personalityKey = data.personalityKey
    e.experienceKey = data.experienceKey
    e.quoteKey = data.quoteKey
    return e
end

function Employee:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.id)
    streamWriteString(streamId, self.name)
    streamWriteBool(streamId, self.isHired)
    streamWriteInt32(streamId, self.assignedVehicleId or 0)
    local queue = self.taskQueue or {}
    streamWriteInt32(streamId, #queue)
    for _, taskName in ipairs(queue) do
        streamWriteString(streamId, taskName)
    end
    streamWriteInt32(streamId, self.shiftStart or 6)
    streamWriteInt32(streamId, self.shiftEnd or 18)
    streamWriteInt32(streamId, self.currentTaskIndex or 1)

    streamWriteInt8(streamId, 4)
    local traitsStr = TraitSystem.serialize(self.traits)
    streamWriteString(streamId, traitsStr)

    streamWriteInt32(streamId, self.lastTrainingDay or 0)
    streamWriteFloat32(streamId, self.totalWagesPaid or 0)
    streamWriteInt32(streamId, self.tasksCompleted or 0)
    streamWriteFloat32(streamId, self.pendingWages or 0)
    streamWriteBool(streamId, self.isUnpaid or false)

    streamWriteFloat32(streamId, self.workTime or 0)
    streamWriteFloat32(streamId, self.kmDriven or 0)
    streamWriteFloat32(streamId, self.skillXP.driving or 0)
    streamWriteFloat32(streamId, self.skillXP.harvesting or 0)
    streamWriteFloat32(streamId, self.skillXP.technical or 0)

    streamWriteFloat32(streamId, self.dailyHoursWorked or 0)
    streamWriteFloat32(streamId, self.fatigueLevel or 0)
    streamWriteBool(streamId, self.isOnBreak or false)

    streamWriteFloat32(streamId, self.milestoneWageMult or 1.0)

    -- v4: autonomous state
    streamWriteBool(streamId, self.isAutonomous or false)

    -- v3: personal info
    streamWriteInt8(streamId, self.age or 30)
    streamWriteString(streamId, self.nationality or "FR")
    streamWriteString(streamId, self.gender or "male")
    streamWriteString(streamId, self.bioKey or "")
    streamWriteString(streamId, self.personalityKey or "")
    streamWriteString(streamId, self.experienceKey or "")
    streamWriteString(streamId, self.quoteKey or "")
end

function Employee:readStream(streamId, connection)
    self.id = streamReadInt32(streamId)
    self.name = streamReadString(streamId)
    self.isHired = streamReadBool(streamId)
    local assignedVehicleId = streamReadInt32(streamId)
    if assignedVehicleId > 0 then
        self.assignedVehicleId = assignedVehicleId
    else
        self.assignedVehicleId = nil
    end
    local queueCount = streamReadInt32(streamId)
    self.taskQueue = {}
    for _ = 1, queueCount do
        table.insert(self.taskQueue, streamReadString(streamId))
    end
    self.shiftStart = streamReadInt32(streamId)
    self.shiftEnd = streamReadInt32(streamId)
    self.currentTaskIndex = streamReadInt32(streamId)

    local streamVersion = streamReadInt8(streamId)
    if streamVersion >= 2 then
        local traitsStr = streamReadString(streamId)
        self.traits = TraitSystem.deserialize(traitsStr)
    else
        local trait = streamReadString(streamId)
        self.traits = (trait ~= "") and { trait } or {}
    end

    self.lastTrainingDay = streamReadInt32(streamId)
    self.totalWagesPaid = streamReadFloat32(streamId)
    self.tasksCompleted = streamReadInt32(streamId)
    self.pendingWages = streamReadFloat32(streamId)
    self.isUnpaid = streamReadBool(streamId)

    self.workTime = streamReadFloat32(streamId)
    self.kmDriven = streamReadFloat32(streamId)
    self.skillXP.driving = streamReadFloat32(streamId)
    self.skillXP.harvesting = streamReadFloat32(streamId)
    self.skillXP.technical = streamReadFloat32(streamId)

    self.dailyHoursWorked = streamReadFloat32(streamId)
    self.fatigueLevel = streamReadFloat32(streamId)
    self.isOnBreak = streamReadBool(streamId)

    if streamVersion >= 2 then
        self.milestoneWageMult = streamReadFloat32(streamId)
    else
        self.milestoneWageMult = 1.0
    end

    if streamVersion >= 4 then
        self.isAutonomous = streamReadBool(streamId)
    else
        self.isAutonomous = false
    end

    if streamVersion >= 3 then
        self.age = streamReadInt8(streamId)
        self.nationality = streamReadString(streamId)
        self.gender = streamReadString(streamId)
        local bioKey = streamReadString(streamId)
        self.bioKey = (bioKey ~= "") and bioKey or nil
        local personalityKey = streamReadString(streamId)
        self.personalityKey = (personalityKey ~= "") and personalityKey or nil
        local experienceKey = streamReadString(streamId)
        self.experienceKey = (experienceKey ~= "") and experienceKey or nil
        local quoteKey = streamReadString(streamId)
        self.quoteKey = (quoteKey ~= "") and quoteKey or nil
    else
        self.age = 30
        self.nationality = "FR"
        self.gender = "male"
    end
end

return Employee
