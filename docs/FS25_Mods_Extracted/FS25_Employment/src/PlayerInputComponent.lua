Employment_PlayerInputComponent = {}
Employment_PlayerInputComponent.EmploymentEventId = nil
Employment_PlayerInputComponent.EducationEventId = nil

function Employment_PlayerInputComponent:registerGlobalPlayerActionEvents()

    local _, eventId = g_inputBinding:registerActionEvent(InputAction.Employment, EmploymentSystem, EmploymentSystem.inputCallback, false, true, false, true, nil, true)
    local _, educationEventId = g_inputBinding:registerActionEvent(InputAction.Education, EmploymentSystem, EmploymentSystem.educationInputCallback, false, true, false, true, nil, true)

    g_inputBinding:setActionEventTextVisibility(eventId, false)
    g_inputBinding:setActionEventTextVisibility(educationEventId, false)

    Employment_PlayerInputComponent.EmploymentEventId = eventId
    Employment_PlayerInputComponent.EducationEventId = educationEventId

    if g_currentMission.employmentSystem ~= nil then g_currentMission.employmentSystem.eventId = eventId end
    if g_currentMission.employmentSystem ~= nil then g_currentMission.employmentSystem.educationEventId = educationEventId end

end


PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerGlobalPlayerActionEvents, Employment_PlayerInputComponent.registerGlobalPlayerActionEvents)