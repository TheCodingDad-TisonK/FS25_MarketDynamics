cmNPCManager = {}

function cmNPCManager:loadNPC(xmlFile, helperName, missionInfo, baseDirectory)
    if ContractorMod.debug then print("cmNPCManager:loadNPC") end
	local xmlFilename = Utils.getFilename("$dataS2/npc/helper/helper.xml", baseDirectory)
	if xmlFilename == nil then
		Logging.xmlWarning(xmlFile, "Missing xmlFilename for npc \'%s\'", key)
		return
	else
		local upperName = helperName:upper()
		if g_npcManager.nameToNPC[upperName] == nil then
			local npc, isDLCMissing = NPCUtil.createFromXML(xmlFilename)
			if not isDLCMissing then
				if npc ~= nil then
					table.insert(g_npcManager.npcs, npc)
					g_npcManager.nameToNPC[upperName] = npc
					g_npcManager.nameToIndex[upperName] = #g_npcManager.npcs
					npc.name = upperName
					npc.index = #g_npcManager.npcs
					npc:register(true)
					g_currentMission.onCreateObjectSystem:add(npc)
					return true
				end
				Logging.xmlWarning(xmlFile, "Could not create NPC from file \'%s\' for \'%s\'!", xmlFilename, key)
			end
		else
			Logging.xmlWarning(xmlFile, "NPC with name \'%s\' already exists for \'%s\'!", name, key)
			return
		end
	end
end

function cmNPCManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    print("cmNPCManager:loadMapData")
    NPCManager:superClass().loadMapData(self)
	for i = 1, 8 do
		local npcName = "HELPER"..i
		cmNPCManager:loadNPC(nil, npcName, missionInfo, baseDirectory)
	end
	for _, spot in pairs(g_npcManager.uniqueIdToSpot) do
		spot:activate()
	end
end
NPCManager.loadMapData = Utils.appendedFunction(NPCManager.loadMapData, cmNPCManager.loadMapData)
