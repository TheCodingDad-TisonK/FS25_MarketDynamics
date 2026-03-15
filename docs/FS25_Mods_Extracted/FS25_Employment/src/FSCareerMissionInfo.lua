Employment_FSCareerMissionInfo = {}

function Employment_FSCareerMissionInfo:saveToXMLFile()
    if self.xmlFile ~= nil and g_currentMission ~= nil and g_currentMission.employmentSystem ~= nil then
        g_currentMission.employmentSystem:saveToXMLFile(self.savegameDirectory .. "/employment.xml")
    end
end

FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, Employment_FSCareerMissionInfo.saveToXMLFile)