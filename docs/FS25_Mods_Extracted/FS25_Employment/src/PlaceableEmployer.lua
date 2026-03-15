PlaceableEmployer = {}

function PlaceableEmployer.prerequisitesPresent(_)
    return true
end


function PlaceableEmployer.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateJob", PlaceableEmployer.updateJob)
    SpecializationUtil.registerFunction(placeableType, "quitJob", PlaceableEmployer.quitJob)
    SpecializationUtil.registerFunction(placeableType, "getJobs", PlaceableEmployer.getJobs)
    SpecializationUtil.registerFunction(placeableType, "getCanApplyAtBusiness", PlaceableEmployer.getCanApplyAtBusiness)
    SpecializationUtil.registerFunction(placeableType, "updateDistance", PlaceableEmployer.updateDistance)
end


function PlaceableEmployer.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad", PlaceableEmployer)
end


function PlaceableEmployer:updateDistance(_)

    local px, py, pz = getWorldTranslation(g_localPlayer.rootNode)
    local sx, sy, sz = getWorldTranslation(self.rootNode)

    local distance = MathUtil.vector3Length(px - sx, py - sy, pz - sz)

    local employmentSystem = g_currentMission.employmentSystem

    if distance < 20 and not employmentSystem.isShowingInput and employmentSystem:getCallbackPlaceable() ~= self then
        employmentSystem.isShowingInput = true
        employmentSystem:setCallbackPlaceable(self)
        employmentSystem:setCallbackPlayer(g_localPlayer.uniqueUserId)
        g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, true)
    elseif distance >= 20 and employmentSystem.isShowingInput and employmentSystem:getCallbackPlaceable() == self then
        employmentSystem.isShowingInput = false
        employmentSystem:setCallbackPlaceable(nil)
        employmentSystem:setCallbackPlayer(nil)
        g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, false)
    end

end


function PlaceableEmployer:onLoad(savegame)

    local spec = self.spec_employer
    local employmentSystem = g_currentMission.employmentSystem

    if employmentSystem == nil then return end

    local name = self.configFileNameClean or ""
    local businessType = EmploymentSystem.CONFIG_FILENAME_TO_BUSINESS_TYPE[name]

    spec.type = businessType or name

    local business = EmploymentSystem.BUSINESS_TYPE_TO_BUSINESS[spec.type]

    if business == nil then return end

    if self.spec_productionPoint ~= nil then

        local productionPoint = self.spec_productionPoint.productionPoint
        productionPoint.activatableEmployer = ProductionPointActivatable.new(productionPoint)

    elseif self.spec_factory ~= nil then

        self.spec_factory.activatableEmployer = FactoryActivatable.new(self)

    else

        table.insert(employmentSystem.updateables, self)

    end

    if savegame ~= nil and savegame.xmlFile ~= nil then

        local xmlFile = savegame.xmlFile
        local key = savegame.key .. ".employer"

        spec.prosperity = xmlFile:getFloat(key .. "#prosperity", math.clamp((math.random(85, 115) / 100) * business.prosperity, 0.25, 1.75))
        spec.tolerance = xmlFile:getFloat(key .. "#tolerance", nil)
        spec.satisfaction = xmlFile:getFloat(key .. "#satisfaction", 1)
        spec.firedPlayers = {}

        xmlFile:iterate(key .. ".firedPlayers.firedPlayer", function (_, firedPlayersKey)
            local firedPlayer = {
                userId = xmlFile:getString(firedPlayersKey .. "#userId", "0")
            }

            spec.firedPlayers[firedPlayer.userId] = firedPlayer
        end)

    else

        spec.prosperity = math.clamp((math.random(85, 115) / 100) * business.prosperity, 0.25, 1.75)
        spec.satisfaction = 1
        spec.firedPlayers = {}

    end

    spec.jobs = business.jobs

    if spec.tolerance == nil then

        local factor = math.random()
        if factor <= 0.05 then
            spec.tolerance = math.random(25, 35) / 100
        elseif factor <= 0.25 then
            spec.tolerance = math.random(35, 75) / 100
        elseif factor <= 0.75 then
            spec.tolerance = math.random(75, 125) / 100
        elseif factor <= 0.95 then
            spec.tolerance = math.random(125, 165) / 100
        else
            spec.tolerance = math.random(165, 175) / 100
        end

    end

end


function PlaceableEmployer.saveToXMLFile(placeable, xmlFile, key, _)

    local spec = placeable.spec_employer
    if spec == nil then return end

    if spec.prosperity ~= nil then xmlFile:setFloat(key .. "#prosperity", spec.prosperity) end
    if spec.tolerance ~= nil then xmlFile:setFloat(key .. "#tolerance", spec.tolerance) end
    if spec.satisfaction ~= nil then xmlFile:setFloat(key .. "#satisfaction", spec.satisfaction) end
    if spec.firedPlayers ~= nil then
        xmlFile:setTable(key .. ".firedPlayers.firedPlayer", spec.firedPlayers, function (firedPlayersKey, firedPlayer)
            xmlFile:setString(firedPlayersKey .. "#userId", firedPlayer.userId)
        end)
    end

end


function PlaceableEmployer:getJobs()

    return self.spec_employer.jobs or {}

end


function PlaceableEmployer:updateJob(employee)

    local spec = self.spec_employer

    local job = employee.job
    local baseJob = EmploymentSystem.JOB_INDEX_TO_JOB[job.index]

    if job.workedHours < baseJob.hours then
        if job.workedHours == 0 then
            spec.satisfaction = spec.satisfaction - 0.03 * (baseJob.hours + 1) * (1.85 - spec.tolerance)
        else
            spec.satisfaction = spec.satisfaction - 0.03 * (job.workedHours / baseJob.hours) * (1.85 - spec.tolerance)
        end
    else
        spec.satisfaction = spec.satisfaction + 0.1 * (job.workedHours / baseJob.hours) * spec.tolerance
    end

    spec.satisfaction = math.clamp(spec.satisfaction, 0, 1)
    local seniority = job.seniority
    local subPromotions = EmploymentSystem.SUB_PROMOTION_INDEX_TO_SUB_PROMOTIONS[baseJob.subPromotionIndex or 1]

    if job.actionCooldown ~= nil then job.actionCooldown = math.max(job.actionCooldown - 1, 0) end
    local actionCooldown = job.actionCooldown or 0
    local currentYear, currentMonth = g_currentMission.employmentSystem:getCurrentYear(), g_currentMission.employmentSystem:getCurrentMonth()
    local totalMonths = (currentYear * 12 + currentMonth) - (job.startYear * 12 + job.startMonth)

    if spec.satisfaction * spec.tolerance <= 0.05 and math.random() * spec.tolerance <= 0.25 then

        -- FIRED

        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText("employment_ui_fired"), (job.seniority ~= 0 and (subPromotions[job.seniority].title .. " ") or "") .. baseJob.title, EmploymentSystem.BUSINESS_TYPE_TO_BUSINESS[spec.type].title))
        employee.job = nil
        spec.firedPlayers[employee.userId] = { userId = employee.userId }

    elseif totalMonths >= 12 and actionCooldown <= 0 and spec.satisfaction >= 0.65 and math.random() * (spec.tolerance / 1.3) >= 0.75 then

        -- PROMOTION

        local promotionIndex = 1
        for i, j in ipairs(spec.jobs) do
            if j == job.index then
                promotionIndex = i + 1
                break
            end
        end

        if spec.jobs[promotionIndex] ~= nil then
            local promotion = EmploymentSystem.JOB_INDEX_TO_JOB[spec.jobs[promotionIndex]]

            if promotion.education <= employee.education and promotion.experience <= employee.experience then

                job.workedHours = 0
                job.seniority = 0
                job.startMonth = g_currentMission.employmentSystem:getCurrentMonth()
                job.startYear = g_currentMission.employmentSystem:getCurrentYear()
                job.index = promotion.index
                job.actionCooldown = 6
                local oldSalary = job.salary * 1

                if job.salary < promotion.salary then job.salary = promotion.salary end

                local factor = math.clamp(math.random(115, 125) * (spec.tolerance / 20), 110, 135) / 100
                job.salary = job.salary * factor
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText("employment_ui_promotion"), promotion.title, ((job.salary / oldSalary) - 1) * 100))
                employee.job = job
            end
        end

    elseif totalMonths >= 8 and actionCooldown <= 0 and seniority < #subPromotions and spec.satisfaction >= 0.65 and math.random() * (spec.tolerance / 1.25) >= 0.75 then

        -- SUBPROMOTION

        job.seniority = seniority + 1
        local factor = math.clamp(math.random(110, 125) * (spec.tolerance / 20), 105, 135) / 100
        job.salary = job.salary * factor
        job.actionCooldown = 4
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText("employment_ui_subpromotion"), subPromotions[job.seniority].title, baseJob.title, (factor - 1) * 100))
        employee.job = job

    elseif totalMonths >= 6 and actionCooldown <= 0 and spec.satisfaction >= 0.5 and math.random() * (spec.tolerance / 1.2) >= 0.75 then

        -- RAISE

        local factor = math.clamp(math.random(101, 110) * (spec.tolerance / 20), 101, 115) / 100
        local newPay = job.salary * factor
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText("employment_ui_raise"), (factor - 1) * 100))
        job.salary = newPay
        job.actionCooldown = 3
        employee.job = job

    end

end


function PlaceableEmployer:quitJob()

    local spec = self.spec_employer
    spec.satisfaction = math.clamp(spec.satisfaction - 0.1 * (1.85 - spec.tolerance), 0, 1)

end


function PlaceableEmployer:getCanApplyAtBusiness(applicant)

    local spec = self.spec_employer

    return spec.firedPlayers == nil or spec.firedPlayers[applicant.userId] == nil

end