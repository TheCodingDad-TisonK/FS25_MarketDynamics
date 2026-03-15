HelperNameExtension = {}

HelperNameExtension.originalNames = {}

function HelperNameExtension.init()
    local originalStart = AIJob.start
    AIJob.start = function(self, farmId)
        originalStart(self, farmId)
        HelperNameExtension.onJobStart(self)
    end

    local originalStop = AIJob.stop
    AIJob.stop = function(self, aiMessage)
        HelperNameExtension.onJobStop(self)
        originalStop(self, aiMessage)
    end

    CustomUtils:info("[HelperNameExtension] Initialized - AI helpers will show employee names")
end

function HelperNameExtension.onJobStart(aiJob)
    if not g_employeeManager or not g_helperManager then return end

    local vehicle = nil
    if aiJob.vehicleParameter and aiJob.vehicleParameter.getVehicle then
        vehicle = aiJob.vehicleParameter:getVehicle()
    end
    if not vehicle then return end

    local employee = g_employeeManager:getEmployeeByVehicle(vehicle)
    if not employee then return end

    local helper = g_helperManager:getHelperByIndex(aiJob.helperIndex)
    if not helper then return end

    HelperNameExtension.originalNames[aiJob.helperIndex] = {
        name = helper.name,
        title = helper.title,
    }

    local empName = string.upper(employee.name)
    helper.name = empName
    helper.title = empName

    CustomUtils:info("[HelperNameExtension] Helper %d renamed to '%s' for employee '%s'",
        aiJob.helperIndex, empName, employee.name)
end

function HelperNameExtension.onJobStop(aiJob)
    if not g_helperManager then return end
    if not aiJob.helperIndex then return end

    local original = HelperNameExtension.originalNames[aiJob.helperIndex]
    if not original then return end

    local helper = g_helperManager:getHelperByIndex(aiJob.helperIndex)
    if helper then
        helper.name = original.name
        helper.title = original.title
        CustomUtils:info("[HelperNameExtension] Helper %d name restored to '%s'",
            aiJob.helperIndex, original.name)
    end

    HelperNameExtension.originalNames[aiJob.helperIndex] = nil
end
