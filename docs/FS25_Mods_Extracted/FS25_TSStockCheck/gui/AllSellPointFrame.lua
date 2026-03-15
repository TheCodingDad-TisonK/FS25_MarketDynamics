--
-- FS22 - TSStockCheck - AllSellPointFrame
--
-- @Interface: 1.0.0.0
-- @Author: Time Wasting Productions
-- @Date: 18.11.2024
-- @Version: 1.0.0.0
--
-- Changelog:
-- 	v1.0.0.0 (18.11.2024):
--      - Initial Release

AllSellPointFrame = {}

AllSellPointFrame.color = {
        brightgreen = {0,1,0,1}, --green
        normal = {1,1,1,1}, --white
        over = {0.9,0.9,0.1,1}, --yellow
        up = {0.3763,0.6038,0.0782,1}, --green
        down = {0.8069,0.0097,0.0097,1}, --red
        great = {0.0742,0.4341,0.6939,1}, --blue
        transparent = {0,0,0,0}
    }
    
AllSellPointFrame.goodPriceThreshold = 0.9
AllSellPointFrame.vGoodPriceThreshold = 0.95

local AllSellPointFrame_mt = Class(AllSellPointFrame, MessageDialog)

function AllSellPointFrame.new(target, custom_mt)
	local self = MessageDialog.new(target, custom_mt or AllSellPointFrame_mt)
	self.i18n = g_i18n
	return self
end

function AllSellPointFrame:onCreate()
	AllSellPointFrame:superClass().onCreate(self)    
end

function AllSellPointFrame:onGuiSetupFinished()
	AllSellPointFrame:superClass().onGuiSetupFinished(self)
	self.TSStockCheckAllSellpointTable:setDataSource(self)
	self.TSStockCheckAllSellpointTable:setDelegate(self)
end

function AllSellPointFrame:onOpen()
	AllSellPointFrame:superClass().onOpen(self)
	FocusManager:setFocus(self.TSStockCheckAllSellpointTable)
end

function AllSellPointFrame:setStockData(stockData)   
	if self.allDialogTitleElement ~= nil then
        local headerText = string.format(g_i18n:getText("ui_allSellPointFrame_header"), g_i18n:formatVolume(stockData.currentStockLevel, 0), stockData.title)
		self.allDialogTitleElement:setText(Utils.getNoNil(headerText, "No title"))
	end

    self.allLocations = {}
    self.stockData = stockData
	for _, sellPoint in pairs(stockData.sellPoints) do
		table.insert(self.allLocations, sellPoint)
	end
    table.sort(self.allLocations, function (k1, k2) return k1.price > k2.price end )

	self.TSStockCheckAllSellpointTable:reloadData()    
end

function AllSellPointFrame:getNumberOfSections()
	return 1
end

function AllSellPointFrame:getNumberOfItemsInSection(list, section)
	return #self.allLocations
end

function AllSellPointFrame:populateCellForItemInSection(list, section, index, cell)
	local locationData = self.allLocations[index]
    local isColourBlindMode = g_gameSettings:getValue(GameSettings.SETTING.USE_COLORBLIND_MODE) or false 

	cell:getAttribute("alllocation"):setText(locationData.name)
	-- cell:getAttribute("alldistance"):setText(string.format("%s %s", g_i18n:formatNumber(g_i18n:getDistance(locationData.distance), 0), g_i18n:getMeasuringUnit(false)))
	cell:getAttribute("allprice"):setText(g_i18n:formatMoney(locationData.price * 1000, 0, true, true))
    if Utils.isBitSet(locationData.priceTrend, SellingStation.PRICE_FALLING) then        
        cell:getAttribute("alltrend"):applyProfile("ingameMenuTSStockCheckRowCellArrowFalling")
    elseif Utils.isBitSet(locationData.priceTrend, SellingStation.PRICE_CLIMBING) then
        cell:getAttribute("alltrend"):applyProfile("ingameMenuTSStockCheckRowCellArrowClimbing")
    elseif Utils.isBitSet(locationData.priceTrend, SellingStation.PRICE_GREAT_DEMAND) then
        cell:getAttribute("alltrend"):applyProfile("ingameMenuTSStockCheckRowCellArrowGreatDemand")
    else
        cell:getAttribute("alltrend"):applyProfile("ingameMenuTSStockCheckRowCellArrow")
    end
    local curValue = self.stockData.currentStockLevel * locationData.price
    local MaxPrice = self.stockData.maxPricePerLiter * self.stockData.currentStockLevel * self.stockData.bestPriceScale
    cell:getAttribute("allvalue"):setText(g_i18n:formatMoney(self.stockData.currentStockLevel * locationData.price, 0, true, true))
    if curValue >= MaxPrice then
        cell:getAttribute("allvalue").textColor = InGameMenuStockCheck.priceGuideColours.great[isColourBlindMode]
    elseif curValue >= (MaxPrice * self.vGoodPriceThreshold) then 
        cell:getAttribute("allvalue").textColor = InGameMenuStockCheck.priceGuideColours.up[isColourBlindMode]
    elseif curValue >= (MaxPrice * self.goodPriceThreshold) then 
        cell:getAttribute("allvalue").textColor = InGameMenuStockCheck.priceGuideColours.over[isColourBlindMode]
    else
        cell:getAttribute("allvalue").textColor = InGameMenuStockCheck.priceGuideColours.normal[isColourBlindMode]
    end
end

function AllSellPointFrame:onListSelectionChanged(list, section, index)
    self.mapHotSpot = self.allLocations[index].mapHotSpot
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

function AllSellPointFrame:onTagLocation(sender)
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

function AllSellPointFrame:onClose()
	AllSellPointFrame:superClass().onClose(self)
end

function AllSellPointFrame:onClickBack(sender)
	self:close()
end