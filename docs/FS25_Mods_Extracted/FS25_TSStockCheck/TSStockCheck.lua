--
-- FS22 - TSStockCheck
--
-- @Interface: 1.0.0.0
-- @Author: Time Wasting Productions
-- @Date: 25.10.2022
-- @Version: 1.0.0.1
--
-- Changelog:
-- 	v1.0.0.0 (20.10.2022):
--      - Initial Release
-- 	v1.0.0.1 (25.10.2022):
--      - Add support Animal Pen Pallets (Eggs/Wool)
--      - Add German Translations
--      - ModHub Release

TSStockCheck = {}
TSStockCheck.dir = g_currentModDirectory
TSStockCheck.modName = g_currentModName
TSStockCheck.debug = false

source(TSStockCheck.dir .. "gui/InGameMenuTSStockCheck.lua")
source(TSStockCheck.dir .. "gui/StorageLocationFrame.lua")
source(TSStockCheck.dir .. "gui/AllSellPointFrame.lua")

function TSStockCheck:loadMap()
	local ui = g_currentMission.inGameMenu

	-- if TSStockCheck.debug then
	-- 	print("--- TSStockCheck "..g_currentMission.missionInfo.savegameDirectory.."/guiProfiles.xml")
	-- 	local xmlFile = loadXMLFile("Temp", "dataS/guiProfiles.xml")
	-- 	saveXMLFileTo(xmlFile, g_currentMission.missionInfo.savegameDirectory.."/guiProfiles.xml")
	-- 	delete(xmlFile);
	-- end

    g_gui:loadProfiles(TSStockCheck.dir .. "gui/guiProfiles.xml")

	local guiTSStockCheck = InGameMenuStockCheck.new(g_i18n) 
	g_gui:loadGui(TSStockCheck.dir .. "gui/InGameMenuTSStockCheck.xml", "ingameMenuTSStockCheck", guiTSStockCheck, true)
	
	local locationFrame = LocationFrame.new(g_i18n) 
	g_gui:loadGui(TSStockCheck.dir .. "gui/StorageLocationFrame.xml", "StorageLocationFrame", locationFrame)

	local allSellPointsFrame = AllSellPointFrame.new(g_i18n) 
	g_gui:loadGui(TSStockCheck.dir .. "gui/AllSellPointFrame.xml", "AllSellPointFrame", allSellPointsFrame)
	
	TSStockCheck.fixInGameMenu(guiTSStockCheck,"ingameMenuTSStockCheck", {0,0,1024,1024}, 2, TSStockCheck:makeIsTSStockCheckEnabledPredicate())

	guiTSStockCheck:initialize()	

end

function TSStockCheck:makeIsTSStockCheckEnabledPredicate()
	return function () return true end
end

-- from Courseplay
function TSStockCheck.fixInGameMenu(frame,pageName,uvs,position,predicateFunc)
	local inGameMenu = g_gui.screenControllers[InGameMenu]
	local abovePrices = 0;

	if TSStockCheck.debug then
		print("--- TSStockCheck.fixInGameMenu")
		DebugUtil.printTableRecursively(inGameMenu.pagingElement)
	end

	-- remove all to avoid warnings
	for k, v in pairs({pageName}) do
		inGameMenu.controlIDs[v] = nil
	end

	for i = 1, #inGameMenu.pagingElement.elements do
		local child = inGameMenu.pagingElement.elements[i]
		if child == inGameMenu["pageStatistics"] then
			abovePrices = i;
			if TSStockCheck.debug then
				print("--- found Statistics position - "..tostring(abovePrices))
			end
		end
	end

	if abovePrices == 0 then
		abovePrices = position
	end
	
	inGameMenu[pageName] = frame
	inGameMenu.pagingElement:addElement(inGameMenu[pageName])

	inGameMenu:exposeControlsAsFields(pageName)

	for i = 1, #inGameMenu.pagingElement.elements do
		local child = inGameMenu.pagingElement.elements[i]
		if child == inGameMenu[pageName] then
			table.remove(inGameMenu.pagingElement.elements, i)
			table.insert(inGameMenu.pagingElement.elements, abovePrices, child)
			break
		end
	end

	for i = 1, #inGameMenu.pagingElement.pages do
		local child = inGameMenu.pagingElement.pages[i]
		if child.element == inGameMenu[pageName] then
			table.remove(inGameMenu.pagingElement.pages, i)
			table.insert(inGameMenu.pagingElement.pages, abovePrices, child)
			break
		end
	end

	inGameMenu.pagingElement:updateAbsolutePosition()
	inGameMenu.pagingElement:updatePageMapping()
	
	inGameMenu:registerPage(inGameMenu[pageName], position, predicateFunc)
	local iconFileName = Utils.getFilename('images/menuIcon.dds', TSStockCheck.dir)
	inGameMenu:addPageTab(inGameMenu[pageName],iconFileName, GuiUtils.getUVs(uvs))
--	inGameMenu[pageName]:applyScreenAlignment()
--	inGameMenu[pageName]:updateAbsolutePosition()

	for i = 1, #inGameMenu.pageFrames do
		local child = inGameMenu.pageFrames[i]
		if child == inGameMenu[pageName] then
			table.remove(inGameMenu.pageFrames, i)
			table.insert(inGameMenu.pageFrames, abovePrices, child)
			break
		end
	end

	inGameMenu:rebuildTabList()
end

addModEventListener(TSStockCheck)
