AIOverrideExtension = {}

function AIOverrideExtension.init()
    local mission = g_currentMission
    if mission ~= nil then
        AIOverrideExtension.hookSpecialization("aiVehicle")
        AIOverrideExtension.hookSpecialization("aiJobVehicle")
    end
end

function AIOverrideExtension.hookSpecialization(specName)
    local spec = g_specializationManager:getSpecializationByName(specName)
    if spec == nil then return end

    local originalRegisterActionEvents = spec.registerActionEvents
    if originalRegisterActionEvents == nil then return end
    
    spec.registerActionEvents = function(self, isActive, ...)
        originalRegisterActionEvents(self, isActive, ...)
        
        if isActive then
            local specData = self["spec_" .. specName]
            if specData and specData.actionEvents then
                local actionEvent = specData.actionEvents[InputAction.TOGGLE_AI]
                if actionEvent ~= nil then
                    g_inputBinding:removeActionEvent(actionEvent.actionEventId)
                end
            end
            
            local _, eventId = g_inputBinding:registerActionEvent(InputAction.TOGGLE_AI, self, AIOverrideExtension.onToggleAI, false, true, false, true)
            g_inputBinding:setActionEventTextPriority(eventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(eventId, g_i18n:getText("action_toggleEmployeeAI") or "Hire/Dismiss Employee")
        end
    end
end

function AIOverrideExtension.onToggleAI(vehicle, actionName, inputValue, callbackState, isAnalog)
    if vehicle == nil then return end

    local employee = g_employeeManager:getEmployeeByVehicle(vehicle)

    if employee ~= nil then
        if employee.currentJob ~= nil or vehicle:getIsAIActive() then
            g_employeeManager:consoleStopJob(employee.id)
            g_currentMission:showBlinkingWarning(string.format(g_i18n:getText("em_employee_stopped") or "Employee %s stopped.", employee.name), 2000)
        else
            g_gui:showGui("MenuEmployeeManager")
        end
    else
        -- No employee assigned: open EM menu (vanilla AI is disabled)
        g_gui:showGui("MenuEmployeeManager")
    end
end
