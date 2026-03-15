--
-- FS22 - TSStockCheck - LocationFrame
--
-- @Interface: 1.0.0.0
-- @Author: Time Wasting Productions
-- @Date: 18.11.2024
-- @Version: 1.0.0.0
--
-- Changelog:
-- 	v1.0.0.0 (18.11.2024):
--      - Initial Release

LocationFrame = {}
local LocationFrame_mt = Class(LocationFrame, MessageDialog)

function LocationFrame.new(target, custom_mt)
	local self = MessageDialog.new(target, custom_mt or LocationFrame_mt)
	self.i18n = g_i18n
	return self
end

function LocationFrame:onCreate()
	LocationFrame:superClass().onCreate(self)    
end

function LocationFrame:onGuiSetupFinished()
	LocationFrame:superClass().onGuiSetupFinished(self)
	self.TSStockCheckLocationTable:setDataSource(self)
	self.TSStockCheckLocationTable:setDelegate(self)
end

function LocationFrame:onOpen()
	LocationFrame:superClass().onOpen(self)
	FocusManager:setFocus(self.TSStockCheckLocationTable)
end

function LocationFrame:setStockData(stockData)   
	if self.dialogTitleElement ~= nil then
        local headerText = string.format(g_i18n:getText("ui_locationFrame_header"), stockData.title)
		self.dialogTitleElement:setText(Utils.getNoNil(headerText, "No title"))
	end

    self.currentLocations = {}
	for _, stockLocation in pairs(stockData.stockLevels) do
		table.insert(self.currentLocations, stockLocation)
	end

	self.TSStockCheckLocationTable:reloadData()    
end

function LocationFrame:getNumberOfSections()
	return 1
end

function LocationFrame:getNumberOfItemsInSection(list, section)
	return #self.currentLocations
end

function LocationFrame:populateCellForItemInSection(list, section, index, cell)
	local locationData = self.currentLocations[index]    
	cell:getAttribute("location"):setText(locationData.name)
	cell:getAttribute("storage"):setText(g_i18n:formatVolume(locationData.level, 0))
	if locationData.extraText ~= nill and locationData.extraText ~= "" then
		cell:getAttribute("location"):applyProfile("ingameMenuTSStockLocationCheckRowCell", true)
		cell:getAttribute("extratext"):setText(locationData.extraText)
		cell:getAttribute("extratext"):setVisible(true)
	else
		cell:getAttribute("location"):applyProfile("ingameMenuTSStockLocationCheckRowCell1", true)
		cell:getAttribute("extratext"):setText("")
		cell:getAttribute("extratext"):setVisible(false)
		-- cell:getAttribute("location"):updateSize()
	end
end

function LocationFrame:onListSelectionChanged(list, section, index)
    self.mapHotSpot = self.currentLocations[index].mapHotSpot
    if self.mapHotSpot ~= nil then
        self.dialogButtonTag.disabled = false
        if self.mapHotSpot == g_currentMission.currentMapTargetHotspot then
            self.dialogButtonTag.text = string.upper(self.i18n:getText("action_untag"))
        else
            self.dialogButtonTag.text = string.upper(self.i18n:getText("action_tag"))
        end
    else
        self.dialogButtonTag.disabled = true
    end
end

function LocationFrame:onTagLocation(sender)
    local hotspot     = self.mapHotSpot

    if hotspot ~= nil then
        if hotspot == g_currentMission.currentMapTargetHotspot then
            self.dialogButtonTag.text = string.upper(self.i18n:getText("action_tag"))
            g_currentMission:setMapTargetHotspot()
        else
            self.dialogButtonTag.text = string.upper(self.i18n:getText("action_untag"))
            g_currentMission:setMapTargetHotspot(hotspot)
        end
    end
end

function LocationFrame:onClose()
	LocationFrame:superClass().onClose(self)
end

function LocationFrame:onClickBack(sender)
	self:close()
end