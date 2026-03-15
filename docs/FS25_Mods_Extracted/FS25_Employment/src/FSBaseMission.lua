Employment_FSBaseMission = {}

function Employment_FSBaseMission:onStartMission()

    EmploymentDialog.register(g_currentMission.employmentSystem)
    WorkHoursDialog.register(g_currentMission.employmentSystem)
    EducationDialog.register(g_currentMission.employmentSystem)

end

FSBaseMission.onStartMission = Utils.prependedFunction(FSBaseMission.onStartMission, Employment_FSBaseMission.onStartMission)