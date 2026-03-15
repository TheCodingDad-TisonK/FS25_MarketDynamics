--
-- FS22 - TSStockCheck - InGameMenuStockCheck
--
-- @Interface: 1.0.0.1
-- @Author: Time Wasting Productions
-- @Date: 18.11.2024
-- @Version: 1.0.0.0
--
-- Changelog:
-- 	v1.0.0.0 (18.11.2024):
--      - Initial Release
-- 	v1.0.0.1 (24.11.2024):
--      - Fixed main screen table size
-- 	v1.0.0.2 (27.01.2025):
--      - Fixed Object Storage suplication of fermenting bales

InGameMenuStockCheck = {}
InGameMenuStockCheck.stockData = {}
InGameMenuStockCheck.inStockData = {}
InGameMenuStockCheck.alreadyAdded = {}
InGameMenuStockCheck._mt = Class(InGameMenuStockCheck, TabbedMenuFrameElement)
InGameMenuStockCheck.debug = false
InGameMenuStockCheck.oldCollectionMethod = false
InGameMenuStockCheck.showAllItems = true
InGameMenuStockCheck.headerSortedBy = nil
InGameMenuStockCheck.sortingAsc = true
InGameMenuStockCheck.dir = g_currentModDirectory
InGameMenuStockCheck.sortingFunction = function (k1, k2) return k1.title < k2.title end
InGameMenuStockCheck.priceGuideColours = {}

InGameMenuStockCheck.priceGuideColours = {
        great = { 
            [false] = {0,1,0,1}, 
            [true] = {0.0470,0.4823,0.8627,1}
        },
        over = {
            [false] = {0.9,0.9,0.1,1}, 
            [true] = {0,0.6196,0.4509,1}
        },
        up = {
            [false] = {0.3763,0.6038,0.0782,1}, 
            [true] = {1,0.7607,0.0392,1}
        }, 
        normal = {
            [false] = {1,1,1,1}, --white
            [true] = {1,1,1,1} --white
        }
    }


InGameMenuStockCheck.color = {
	brightgreen = {0,1,0,1}, --green
	normal = {1,1,1,1}, --white
	over = {0.9,0.9,0.1,1}, --yellow
	up = {0.3763,0.6038,0.0782,1}, --green
	down = {0.8069,0.0097,0.0097,1}, --red
	great = {0.0742,0.4341,0.6939,1}, --blue
	transparent = {0,0,0,0}
}

InGameMenuStockCheck.goodPriceThreshold = 0.9
InGameMenuStockCheck.vGoodPriceThreshold = 0.95
InGameMenuStockCheck.GlobalTransportPallet = "FS22_GlobalTransportPallet.globalpallet"
InGameMenuStockCheck.GlobalTransportPalletLiquids = "FS22_GlobalTransportPallet.globalpallet_liquids"

function InGameMenuStockCheck.new(i18n, messageCenter)
	local self = InGameMenuStockCheck:superClass().new(nil, InGameMenuStockCheck._mt)

    self.name = "InGameMenuStockCheck"
    self.i18n = i18n
    self.messageCenter = messageCenter
    
	self.dataBindings = {}

    self.backButtonInfo = {
		inputAction = InputAction.MENU_BACK
	}
	self.btnShowLocationUi = {
		text = string.format(self.i18n:getText("ui_location_btn"), self.i18n:getText("category_storages")),
		inputAction = InputAction.MENU_ACTIVATE,
        disabled = true,
		callback = function ()
			self:showLocationUi()
		end
	}    
    self.hotspotButtonInfo = {
        disabled = true,
        inputAction = InputAction.MENU_ACCEPT,
        text        = string.upper(self.i18n:getText("action_tag")),
        callback    = function ()
            self:onButtonHotspotPlaceable()
        end
    }
    self.allSellpointButtonInfo = {
        disabled = true,
        inputAction = InputAction.MENU_CANCEL,
        text        = string.format(self.i18n:getText("ui_allsellpoint_btn"),self.i18n:getText("ui_stations")),
        callback    = function ()
            self:onButtonAllSellPoint()
        end
    }
    self.toggleFilterButtonInfo = {
        disabled = false,
        inputAction = InputAction.MENU_EXTRA_1,
        text = self.showAllItems and self.i18n:getText("ui_hide_all_items") or
            self.i18n:getText("ui_show_all_items"),
        callback = function() self:onToggleShowAllItems() end
    }

    self:setMenuButtonInfo({
        self.backButtonInfo,
        self.btnShowLocationUi,
        self.hotspotButtonInfo,
        self.allSellpointButtonInfo,
        self.toggleFilterButtonInfo
    })

    return self
end

function InGameMenuStockCheck:delete()
	InGameMenuStockCheck:superClass().delete(self)
end

function InGameMenuStockCheck:copyAttributes(src)
    InGameMenuStockCheck:superClass().copyAttributes(self, src)
    self.i18n = src.i18n
end

function InGameMenuStockCheck:onGuiSetupFinished()
	InGameMenuStockCheck:superClass().onGuiSetupFinished(self)
	self.stockCheckTable:setDataSource(self)
	self.stockCheckTable:setDelegate(self)
end

function InGameMenuStockCheck:initialize()
end

function InGameMenuStockCheck:onFrameOpen()
	InGameMenuStockCheck:superClass().onFrameOpen(self)   
    self:updateContent()
	FocusManager:setFocus(self.stockCheckTable)
end

function InGameMenuStockCheck:onFrameClose()
	InGameMenuStockCheck:superClass().onFrameClose(self)   
end

function InGameMenuStockCheck:updateContent()  
    -- local spawnPoints = {}
    local fillTypes = {}
    local alreadyAdded = {}
    local uniqueIDsAlreadyCounted = {}

    self.economicDifficulty = g_currentMission.missionInfo.economicDifficulty
    self.priceMultiplier = EconomyManager.getPriceMultiplier()

    if self.debug then
        print("---- My Farm ID - "..tostring(g_currentMission:getFarmId()))
    end

    self.stockData = {}
    if self.debug then
        print("---- Get Filltypes")
    end
    -- Get FillTypes
    for _,filltype in pairs(g_fillTypeManager.fillTypes) do
        if self.alreadyAdded[filltype.index] == nil then
            if self.debug then
                print("---- Filltype "..tostring(filltype.index).." - "..tostring(filltype.name))
                --DebugUtil.printTableRecursively(filltype)
            end
            local max = 0
            local mean = 0
            local maxmonth = SeasonPeriod.EARLY_SPRING
            max, mean, maxmonth = self:getMaxMeanAndMonth(filltype)
            self.stockData[filltype.index] = {
                index = filltype.index,
                name = filltype.name,
                title = filltype.title,
                pricePerLiter = filltype.pricePerLiter * self.priceMultiplier,
                maxPricePerLiter = max * self.priceMultiplier,
                bestMonth = maxmonth,
                meanPricePerLiter = mean * self.priceMultiplier,
                bestPriceScale = 1.0, 
                noSellPoint = true,
                bestBuyingPricePerLiter = 0.0,
                bestBuyingStation = "",
                bestBuyingStationIndex = 0,
                greatDemand = false,
                currentStockLevel = 0,
                hudOverlayFilename = filltype.hudOverlayFilename,
                priceTrend = 0,
                mapHotSpot = nil,
                stockLevels = {},
                sellPoints = {}
            }
            self.alreadyAdded[filltype.name] = true
        end
    end

    if self.debug then
        print("---- Get Prices")
    end
    -- Get Best Prices for FillTypes and where to sell

    for _, station in pairs(g_currentMission.storageSystem:getUnloadingStations()) do
        -- if self.debug and (station:getName() == "Aunt Emma Shop" or station:getName() == "Marissonne") then
        --     print("---- "..tostring(station:getName()))
        --     DebugUtil.printTableRecursively(station)
        -- end

		if station:isa(SellingStation) and not station.hideFromPricesMenu then
            local foundHotSpot  = nil
            if not foundHotSpot and station.owningPlaceable ~= nil and station.owningPlaceable.spec_hotspots ~= nil and station.owningPlaceable.spec_hotspots.mapHotspots ~= nil then
                for _, mapHotSpot in ipairs(station.owningPlaceable.spec_hotspots.mapHotspots) do
                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                        foundHotSpot = mapHotSpot
                    end
                end
            end
            if not foundHotSpot and station.spec_sellingStation ~= nil and station.spec_sellingStation.spec_hotspots ~= nil and station.spec_sellingStation.spec_hotspots.mapHotspots ~= nil then
                for _, mapHotSpot in ipairs(station.spec_sellingStation.spec_hotspots.mapHotspots) do
                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                        foundHotSpot = mapHotSpot
                    end
                end
            end
            
            if station.owningPlaceable ~= nil and station.owningPlaceable.xmlFile ~= nil then
                --self:checkForStationPriceScale(station, station.owningPlaceable.storeItem.xmlFilename, station.acceptedFillTypes)
                self:checkForStationPriceScale(station, station.owningPlaceable.xmlFile)
            end

            for fillType,isAccepted in pairs(station.acceptedFillTypes) do
				if isAccepted == true and station.ownerFarmId ~= g_currentMission:getFarmId() then
				
					local price = station:getEffectiveFillTypePrice(fillType)
					local greatDemand = false
					if station.greatDemandFillType ~= nil and station.greatDemandFillType == fillType then
						greatDemand = true
					end

                    local index = 1
                    if self.stockData[fillType].sellPoints ~= nil then
                        index = #self.stockData[fillType].sellPoints
                        if self.debug then
                            print("---- Index is " ..tostring(index))
                        end
                    end 
                    self.stockData[fillType].sellPoints[index + 1] = {
                        name = station:getName(),
                        price = price,
                        mapHotSpot = foundHotSpot,
                        greatDemand = greatDemand,
                        priceTrend = station:getCurrentPricingTrend(fillType),
                        distance = calcDistanceFrom(g_localPlayer:getCurrentRootNode(), station.rootNode)
                    }

                    if price > self.stockData[fillType].bestBuyingPricePerLiter then
                        self.stockData[fillType].noSellPoint = false
                        self.stockData[fillType].bestBuyingPricePerLiter = price
                        self.stockData[fillType].bestBuyingStation = station:getName()
                        self.stockData[fillType].greatDemand = greatDemand
                        self.stockData[fillType].priceTrend = station:getCurrentPricingTrend(fillType)
                        self.stockData[fillType].mapHotSpot = foundHotSpot
                    end 
				end
			end
		end
	end
 
    -- Get Silo Stock Levels
     for v=1, #g_currentMission.placeableSystem.placeables do
         local thisPlaceable = g_currentMission.placeableSystem.placeables[v]
        if self.debug then 
            --print("--- Placeable")
            print("--- Placeable - "..tostring(thisPlaceable:getName()))
            -- if thisPlaceable:getName() == "Grain Mill" then
            --     DebugUtil.printTableRecursively(thisPlaceable)
            -- end
        end
        
        --Silo
        if thisPlaceable.spec_silo ~= nil and (thisPlaceable.ownerFarmId == g_currentMission:getFarmId() or thisPlaceable.ownerFarmId == 0) then
            if self.oldCollectionMethod then
                for fillTypeIndex, fillLevel in pairs(thisPlaceable.spec_silo.loadingStation:getAllFillLevels(g_currentMission:getFarmId())) do
                    if fillLevel > 0 and fillTypeIndex ~= nil then
                        self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                        if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                            self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                        else
                            local foundHotSpot  = nil
                            if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                        foundHotSpot = mapHotSpot
                                    end
                                end
                            end
                            self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v),name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                        end
                    end
                end
            else
                for storenum=1, #thisPlaceable.spec_silo.storages do
                    local thisStorage = thisPlaceable.spec_silo.storages[storenum]
                    if (thisStorage.ownerFarmId) == g_currentMission:getFarmId() then
                        for fillTypeIndex, fillLevel in pairs(thisStorage.fillLevels) do
                            if fillLevel > 0 then
                                self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                                if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                                    self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                                else
                                    local foundHotSpot  = nil
                                    if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                        for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                            if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                                foundHotSpot = mapHotSpot
                                            end
                                        end
                                    end
                                    self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v),name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                                end
                            end
                        end
                    end
                end
            end
        end

        --Silo Extension
        if thisPlaceable.spec_siloExtension ~= nil and (thisPlaceable.ownerFarmId == g_currentMission:getFarmId() or thisPlaceable.ownerFarmId == 0) then
            if self.oldCollectionMethod == false then
                local thisStorage = thisPlaceable.spec_siloExtension.storage
                if (thisStorage.ownerFarmId) == g_currentMission:getFarmId() then
                    for fillTypeIndex, fillLevel in pairs(thisStorage.fillLevels) do
                        if fillLevel > 0 then
                            self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                            if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                                self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                            else
                                local foundHotSpot  = nil
                                if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                    for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                        if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                            foundHotSpot = mapHotSpot
                                        end
                                    end
                                end
                                self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v),name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                            end
                        end
                    end
                end
            end
        end


        -- Animal Husbandry Outputs
        if thisPlaceable.spec_husbandry ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() and thisPlaceable.spec_husbandry.storage ~= nil then
            for fillTypeIndex, fillLevel in pairs(thisPlaceable.spec_husbandry.storage.fillLevels) do
                if fillLevel > 0 and fillTypeIndex ~= nil and thisPlaceable.spec_husbandry.loadingStation ~= nil and thisPlaceable.spec_husbandry.loadingStation.supportedFillTypes[fillTypeIndex] == true then
	 			    self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                    if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                        self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                    else
                        local foundHotSpot  = nil
                        if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                            for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                    foundHotSpot = mapHotSpot
                                end
                            end
                        end
                        self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v), name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                    end
	 	    	end
            end
        end

        -- Husbandry Pallets
        -- if thisPlaceable.spec_husbandryPallets ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() then
        --     if self.debug and thisPlaceable:getName() == "Chicken Coop" then
        --         print("--- Got Chicken Coop")
        --         DebugUtil.printTableRecursively(thisPlaceable)
        --     end
        --     --thisPlaceable.updatePalletInfo()
        --     local fillTypeIndex = thisPlaceable.spec_husbandryPallets.fillTypeIndex
        --     local fillLevel = thisPlaceable.spec_husbandryPallets.fillLevel
        --     if fillLevel > 0 then
        --         self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
        --         if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nill then
        --             self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
        --         else
        --             local foundHotSpot  = nil
        --             if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
        --                 for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
        --                     if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
        --                         foundHotSpot = mapHotSpot
        --                     end
        --                 end
        --             end
        --             self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v), name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
        --         end
        --     end
        -- end

        -- Beehive Pallets
        if thisPlaceable.spec_beehivePalletSpawner ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() then
            -- if self.debug and thisPlaceable:getName() == "Beehive Honey Pallet Location" then
            --     print("--- Got Beehive Honey Pallet Location")
            --     DebugUtil.printTableRecursively(thisPlaceable)
            --     print("--- Got Beehive Honey Pallet Location spec_beehivePalletSpawner")
            --     DebugUtil.printTableRecursively(thisPlaceable.spec_beehivePalletSpawner)
            -- end
            local fillTypeIndex = thisPlaceable.spec_beehivePalletSpawner.fillType
            local fillLevel = thisPlaceable.spec_beehivePalletSpawner.pendingLiters
            if fillLevel > 0 and fillTypeIndex ~= nil then
                self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                    self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                else
                    local foundHotSpot  = nil
                    if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                        for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                            if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                foundHotSpot = mapHotSpot
                            end
                        end
                    end
                    self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v), name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                end
            end
        end

        -- Manure Heaps
        if thisPlaceable.spec_manureHeap ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() and thisPlaceable.spec_manureHeap.manureHeap ~= nil then
            for fillTypeIndex, fillLevel in pairs(thisPlaceable.spec_manureHeap.manureHeap.fillLevels) do
                if fillLevel > 0 and fillTypeIndex ~= nil then
	 			    self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                    if self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] ~= nil then
                        self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)].level + fillLevel
                    else
                        local foundHotSpot  = nil
                        if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                            for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                    foundHotSpot = mapHotSpot
                                end
                            end
                        end
                        self.stockData[fillTypeIndex].stockLevels["Silo"..tostring(v)] = {tag = "Silo"..tostring(v), name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                    end
	 	    	end
            end
        end

        -- Bunker Silo
        if thisPlaceable.spec_bunkerSilo ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() and thisPlaceable.spec_bunkerSilo.bunkerSilo ~= nil then
            local bunkerSilo = thisPlaceable.spec_bunkerSilo.bunkerSilo
            local inputFillType = bunkerSilo.inputFillType
            local fillLevel = bunkerSilo.fillLevel
            local fermentingPercent = bunkerSilo.fermentingPercent
            local outputFillType = bunkerSilo.outputFillType
            local compactedPercent = bunkerSilo.compactedPercent
            local fillLevel = fillLevel
            local fillTypeIndex = inputFillType
            local extratext = ""

            local outputFillTypeName = ""
		    local fillType = g_fillTypeManager:getFillTypeByIndex(outputFillType)
            if fillType ~= nil then
                outputFillTypeName = fillType.title
            end
        
            if bunkerSilo.state == BunkerSilo.STATE_FILL then
                extratext = g_i18n:getText("info_compacting") .. string.format(" %d%%", compactedPercent)
            elseif bunkerSilo.state == BunkerSilo.STATE_CLOSED then
                extratext = g_i18n:getText("info_fermenting") .. string.format(" %s: %d%%", outputFillTypeName, math.ceil(fermentingPercent * 100))
            elseif bunkerSilo.state == BunkerSilo.STATE_DRAIN or bunkerSilo.state == BunkerSilo.STATE_FERMENTED then
                fillTypeIndex = outputFillType
            end
            if fillLevel > 0 and fillTypeIndex ~= nil then
                self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                if self.stockData[fillTypeIndex].stockLevels["BunkerSilo"..tostring(v)] ~= nil then
                    self.stockData[fillTypeIndex].stockLevels["BunkerSilo"..tostring(v)].level = self.stockData[fillTypeIndex].stockLevels["BunkerSilo"..tostring(v)].level + fillLevel
                else
                    local foundHotSpot  = nil
                    if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                        for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                            if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                foundHotSpot = mapHotSpot
                            end
                        end
                    end
                    self.stockData[fillTypeIndex].stockLevels["BunkerSilo"..tostring(v)] = {tag = "BunkerSilo"..tostring(v), name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot, extraText = extratext}
                end
            end
        end

        -- Object Stroage
        if thisPlaceable.spec_objectStorageMod ~= nil and thisPlaceable.spec_objectStorageMod.objectStorage ~= nil and thisPlaceable.spec_objectStorageMod.objectStorage.ownerFarmId == g_currentMission:getFarmId() then
            -- if self.debug then
            --     --print("--- Placeable")
            --     print("--- Object Storage - "..tostring(thisPlaceable:getName()))
            --     DebugUtil.printTableRecursively(thisPlaceable.spec_objectStorageMod.objectStorage)
            -- end
            local thisOS = thisPlaceable.spec_objectStorageMod.objectStorage
            local extratext = ""
            for fillTypeIndex, _ in pairs(thisOS.storageAreasByFillType) do
                local fillTypeTable = thisOS.storageAreasByFillType[fillTypeIndex]
                for someNum, _ in pairs(fillTypeTable) do
                    if fillTypeTable[someNum].objects ~= nil then
                        local objects = fillTypeTable[someNum].objects
                        for x=1, #objects do
                            local storageArrayTag = "OS"..tostring(v)
                            local object = objects[x]
                            local fillType = fillTypeIndex
                            if object.fillType ~= nil then
                                fillType = object.fillType
                            end
                            local fillLevel = object.fillLevel
                            if object.isFermenting ~= nil and object.isFermenting then
                                local fermentPcent = object.fermentingPercentage
                                if fermentPcent < 0.33 then
                                    storageArrayTag = storageArrayTag.."Ferment0"
                                    extratext = g_i18n:getText("info_fermenting").." 0 - 33%"
                                elseif fermentPcent < 0.66 then
                                    extratext = g_i18n:getText("info_fermenting").." 33 - 66%"
                                    storageArrayTag = storageArrayTag.."Ferment33"
                                elseif fermentPcent < 1 then
                                    storageArrayTag = storageArrayTag .. "Ferment66"
                                    extratext = g_i18n:getText("info_fermenting").." 66 - 99%"
                                end
                            end
                            if fillLevel > 0 and fillType ~= nil then
                                self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                                if self.stockData[fillType].stockLevels[storageArrayTag] ~= nil then
                                     self.stockData[fillType].stockLevels[storageArrayTag].level = self.stockData[fillType].stockLevels[storageArrayTag].level + fillLevel
                                else
                                    local foundHotSpot  = nil
                                    if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                        for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                            if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                                foundHotSpot = mapHotSpot
                                            end
                                        end
                                    end
                                    if not foundHotSpot and thisPlaceable.owningPlaceable ~= nil and thisPlaceable.owningPlaceable.spec_hotspots ~= nil and thisPlaceable.owningPlaceable.spec_hotspots.mapHotspots ~= nil then
                                        for _, mapHotSpot in ipairs(thisPlaceable.owningPlaceable.spec_hotspots.mapHotspots) do
                                            if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                                foundHotSpot = mapHotSpot
                                            end
                                        end
                                    end
                                    self.stockData[fillType].stockLevels[storageArrayTag] = {tag = storageArrayTag, name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot, extraText = extratext}
                                end
                            end
                        end
                    else
                        for w=1, #fillTypeTable[someNum] do
                            local fillTypeTableTable = fillTypeTable[someNum][w]
                            if fillTypeTableTable ~= nil and fillTypeTableTable.objects ~= nil then
                                local objects = fillTypeTableTable.objects
                                for x=1, #objects do
                                    local storageArrayTag = "OS"..tostring(v)
                                    local object = objects[x]
                                    local fillType = fillTypeIndex
                                    if object.fillType ~= nil then
                                        fillType = object.fillType
                                    end
                                    local fillLevel = object.fillLevel
                                    if object.isFermenting ~= nil and object.isFermenting then
                                        local fermentPcent = object.fermentingPercentage
                                        if fermentPcent < 0.33 then
                                            storageArrayTag = storageArrayTag.."Ferment0"
                                            extratext = g_i18n:getText("info_fermenting").." 0 - 33%"
                                        elseif fermentPcent < 0.66 then
                                            extratext = g_i18n:getText("info_fermenting").." 33 - 66%"
                                            storageArrayTag = storageArrayTag.."Ferment33"
                                        elseif fermentPcent < 1 then
                                            storageArrayTag = storageArrayTag .. "Ferment66"
                                            extratext = g_i18n:getText("info_fermenting").." 66 - 99%"
                                        end
                                    end
                                    if fillLevel > 0 and fillType ~= nil then
                                        self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                                        if self.stockData[fillType].stockLevels[storageArrayTag] ~= nil then
                                             self.stockData[fillType].stockLevels[storageArrayTag].level = self.stockData[fillType].stockLevels[storageArrayTag].level + fillLevel
                                        else
                                            local foundHotSpot  = nil
                                            if not foundHotSpot and thisOS.spec_hotspots ~= nil and thisOS.spec_hotspots.mapHotspots ~= nil then
                                                for _, mapHotSpot in ipairs(thisOS.spec_hotspots.mapHotspots) do
                                                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                                        foundHotSpot = mapHotSpot
                                                    end
                                                end
                                            end
                                            if not foundHotSpot and thisOS.owningPlaceable ~= nil and thisOS.owningPlaceable.spec_hotspots ~= nil and thisOS.owningPlaceable.spec_hotspots.mapHotspots ~= nil then
                                                for _, mapHotSpot in ipairs(thisOS.owningPlaceable.spec_hotspots.mapHotspots) do
                                                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                                        foundHotSpot = mapHotSpot
                                                    end
                                                end
                                            end
                                            self.stockData[fillType].stockLevels[storageArrayTag] = {tag = storageArrayTag, name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot, extraText = extratext}
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Giants Object Storage
        if thisPlaceable.spec_objectStorage ~= nil and thisPlaceable.spec_objectStorage.objectInfos ~= nil and thisPlaceable.ownerFarmId == g_currentMission:getFarmId() then
            for obi=1, #thisPlaceable.spec_objectStorage.objectInfos do
                local objectInfo = thisPlaceable.spec_objectStorage.objectInfos[obi]
                if self.debug then
                    print("--- Giants Object Storage")
                    DebugUtil.printTableRecursively(objectInfo)
                end
                if #objectInfo.objects == 1 and objectInfo.numObjects ~= 1 then
                    if self.debug then
                        print("--- Giants Object Storage probably on a server")
                    end
                    local numObjects = objectInfo.numObjects
                    local storageArrayTag = "Silo"..tostring(v)
                    local fillTypeIndex = 0
                    local fillLevel = 0
                    local extratext = ""
                    if objectInfo.objects[1].baleAttributes ~= nil then
                        fillLevel = objectInfo.objects[1].baleAttributes.fillLevel * numObjects
                        fillTypeIndex = objectInfo.objects[1].baleAttributes.fillType
                    elseif objectInfo.objects[1].baleObject ~= nil then
                        fillLevel = objectInfo.objects[1].baleObject.fillLevel * numObjects
                        fillTypeIndex = objectInfo.objects[1].baleObject.fillType
                        if objectInfo.objects[1].baleObject.isFermenting then
                            local fermentPcent = objectInfo.objects[1].baleObject.fermentingPercentage
                            if fermentPcent < 0.33 then
                                storageArrayTag = storageArrayTag.."Ferment0"
                                extratext = g_i18n:getText("info_fermenting").." 0 - 33%"
                            elseif fermentPcent < 0.66 then
                                extratext = g_i18n:getText("info_fermenting").." 33 - 66%"
                                storageArrayTag = storageArrayTag.."Ferment33"
                            elseif fermentPcent < 1 then
                                storageArrayTag = storageArrayTag .. "Ferment66"
                                extratext = g_i18n:getText("info_fermenting").." 66 - 99%"
                            end
                        end
                    elseif objectInfo.objects[1].palletAttributes ~= nil then
                        fillLevel = objectInfo.objects[1].palletAttributes.fillLevel * numObjects
                        fillTypeIndex = objectInfo.objects[1].palletAttributes.fillType
                    end
                    if fillLevel > 0 and fillTypeIndex ~= nil then
                        -- Try this to avoid storage extensions
                        -- local myFillLevel = thisPlaceable.spec_silo.storage:getFillLevel(fillTypeIndex)
                        self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                        if self.stockData[fillTypeIndex].stockLevels[storageArrayTag] ~= nil then
                            self.stockData[fillTypeIndex].stockLevels[storageArrayTag].level = self.stockData[fillTypeIndex].stockLevels[storageArrayTag].level + fillLevel
                        else
                            local foundHotSpot  = nil
                            if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                    if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                        foundHotSpot = mapHotSpot
                                    end
                                end
                            end
                            self.stockData[fillTypeIndex].stockLevels[storageArrayTag] = {tag = storageArrayTag ,name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot, extraText = extratext}
                        end
                    end
                else
                    if self.debug then
                        print("--- Giants Object Storage not on a server")
                    end
                    for x=1, #objectInfo.objects do
                        local storageArrayTag = "Silo"..tostring(v)
                        local object = objectInfo.objects[x]
                        local fillTypeIndex = 0
                        local fillLevel = 0
                        local extratext = ""
                        local uniqueID = nil

                        -- if self.debug then
                        --     print("--- Giants Object Storage objects")
                        --     DebugUtil.printTableRecursively(object)
                        -- end

                        if object.baleAttributes ~= nil and object.baleAttributes.farmId == g_currentMission:getFarmId() then
                            fillLevel = object.baleAttributes.fillLevel
                            fillTypeIndex = object.baleAttributes.fillType
                            if object.baleAttributes.uniqueId ~= nil then
                                uniqueID = object.baleAttributes.uniqueId
                            end
                        elseif object.baleObject ~= nil and object.baleObject.ownerFarmId == g_currentMission:getFarmId() then
                            fillLevel = object.baleObject.fillLevel
                            fillTypeIndex = object.baleObject.fillType
                            if object.baleObject.isFermenting then
                                local fermentPcent = object.baleObject.fermentingPercentage
                                if fermentPcent < 0.33 then
                                    storageArrayTag = storageArrayTag.."Ferment0"
                                    extratext = g_i18n:getText("info_fermenting").." 0 - 33%"
                                elseif fermentPcent < 0.66 then
                                    extratext = g_i18n:getText("info_fermenting").." 33 - 66%"
                                    storageArrayTag = storageArrayTag.."Ferment33"
                                elseif fermentPcent < 1 then
                                    storageArrayTag = storageArrayTag .. "Ferment66"
                                    extratext = g_i18n:getText("info_fermenting").." 66 - 99%"
                                end
                            end
                            if object.baleObject.uniqueId ~= nil then
                                uniqueID = object.baleObject.uniqueId
                            end
                        elseif object.palletAttributes ~= nil and object.palletAttributes.ownerFarmId == g_currentMission:getFarmId() then
                            fillLevel = object.palletAttributes.fillLevel
                            fillTypeIndex = object.palletAttributes.fillType
                            -- if object.baleAttributes.uniqueId ~= nil then
                            --     uniqueID = object.baleAttributes.uniqueId
                            -- end
                        end
    
                        local addItem = true

                        if uniqueID ~= nill then
                            for k=1, #uniqueIDsAlreadyCounted do
                                if uniqueIDsAlreadyCounted[k] == uniqueID then
                                    addItem = false
                                    break
                                end
                            end
                        end

                        if fillLevel > 0 and fillTypeIndex ~= nil and addItem == true then
                        -- Try this to avoid storage extensions
                            -- local myFillLevel = thisPlaceable.spec_silo.storage:getFillLevel(fillTypeIndex)
                            self.stockData[fillTypeIndex].currentStockLevel = self.stockData[fillTypeIndex].currentStockLevel + fillLevel
                            if self.stockData[fillTypeIndex].stockLevels[storageArrayTag] ~= nil then
                                self.stockData[fillTypeIndex].stockLevels[storageArrayTag].level = self.stockData[fillTypeIndex].stockLevels[storageArrayTag].level + fillLevel
                            else
                                local foundHotSpot  = nil
                                if not foundHotSpot and thisPlaceable.spec_hotspots ~= nil and thisPlaceable.spec_hotspots.mapHotspots ~= nil then
                                    for _, mapHotSpot in ipairs(thisPlaceable.spec_hotspots.mapHotspots) do
                                        if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                            foundHotSpot = mapHotSpot
                                        end
                                    end
                                end
                                self.stockData[fillTypeIndex].stockLevels[storageArrayTag] = {tag = storageArrayTag ,name = thisPlaceable:getName(), level = fillLevel, mapHotSpot = foundHotSpot, extraText = extratext}
                            end
                            if uniqueID ~=nil then
                                table.insert(uniqueIDsAlreadyCounted, uniqueID)
                            end
                        end
                    end
                end
            end
        end
    end

    if self.debug then
        print("--- Giants Object Storage listig uniqueIDs")
        DebugUtil.printTableRecursively(uniqueIDsAlreadyCounted)
    end

     -- Get Production Outputs
    if g_currentMission ~= nil and g_currentMission.productionChainManager ~= nil then
		local thesePoints = g_currentMission.productionChainManager.productionPoints
        for v=1, #g_currentMission.productionChainManager.productionPoints do
            local thisProd         = g_currentMission.productionChainManager.productionPoints[v]
            local ownedBy          = thisProd:getOwnerFarmId()
			local isMine           = ownedBy == g_currentMission:getFarmId()

            -- if self.debug and (thisProd:getName() == "Grain Mill") then
            --     print("--- Production - "..tostring(thisProd:getName()))
            --     DebugUtil.printTableRecursively(thisProd)
            --     print("--- Production productionPoint- "..tostring(thisProd:getName()))
            --     DebugUtil.printTableRecursively(thisProd.productionPoint)
            --     print("--- Production productionPoint.palletSpawner- "..tostring(thisProd:getName()))
            --     DebugUtil.printTableRecursively(thisProd.productionPoint.palletSpawner)
            -- end
            for x = 1, #thisProd.outputFillTypeIdsArray do
				local fillType  = thisProd.outputFillTypeIdsArray[x]
				local fillLevel = MathUtil.round(thisProd.storage:getFillLevel(fillType))
				local fillCap   = thisProd.storage:getCapacity(fillType)
				local fillPerc  = MathUtil.getFlooredPercent(fillLevel, fillCap)
				local fillDest  = thisProd:getOutputDistributionMode(fillType)

				if fillLevel > 0 and fillType ~= nil and isMine then
                    self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                    if self.stockData[fillType].stockLevels["Prod"..tostring(v)] ~= nil then
                         self.stockData[fillType].stockLevels["Prod"..tostring(v)].level = self.stockData[fillType].stockLevels["Prod"..tostring(v)].level + fillLevel
                    else
                        local foundHotSpot  = nil
                        if not foundHotSpot and thisProd.spec_hotspots ~= nil and thisProd.spec_hotspots.mapHotspots ~= nil then
                            for _, mapHotSpot in ipairs(thisProd.spec_hotspots.mapHotspots) do
                                if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                    foundHotSpot = mapHotSpot
                                end
                            end
                        end
                        if not foundHotSpot and thisProd.owningPlaceable ~= nil and thisProd.owningPlaceable.spec_hotspots ~= nil and thisProd.owningPlaceable.spec_hotspots.mapHotspots ~= nil then
                            for _, mapHotSpot in ipairs(thisProd.owningPlaceable.spec_hotspots.mapHotspots) do
                                if not foundHotSpot and mapHotSpot.worldX ~= nil and mapHotSpot.worldZ ~= nil then
                                    foundHotSpot = mapHotSpot
                                end
                            end
                        end
                        self.stockData[fillType].stockLevels["Prod"..tostring(v)] = {tag = "Prod"..tostring(v), name = thisProd:getName(), level = fillLevel, mapHotSpot = foundHotSpot}
                    end
				end
			end
        end
    end


    local shippingContainterNum = 1

-- Pallets, Shipping Containers & Global Transport Pallets
    if g_currentMission ~= nil and g_currentMission.vehicleSystem ~= nil and g_currentMission.vehicleSystem.vehicles ~= nil then
        for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do
            if vehicle.ownerFarmId == g_currentMission:getFarmId() and vehicle.typeName ~= nil and (vehicle.typeName == InGameMenuStockCheck.GlobalTransportPallet or vehicle.typeName == InGameMenuStockCheck.GlobalTransportPalletLiquids) then
                if vehicle.spec_fillUnit ~= nil and vehicle.spec_fillUnit.fillUnits ~=nil and #vehicle.spec_fillUnit.fillUnits > 0 then
                    local fillType = vehicle.spec_fillUnit.fillUnits[1].fillType
                    local fillLevel = vehicle.spec_fillUnit.fillUnits[1].fillLevel
                    local foundHotSpot  = nil
                    local storageName = ""
                    local storageArrayTag = ""
                    storageName = vehicle:getName()
                    storageArrayTag = "GlobalPallet"..tostring(shippingContainterNum)
                    shippingContainterNum = shippingContainterNum + 1
                    if not foundHotSpot and vehicle.mapHotspot ~= nil then
                        foundHotSpot = vehicle.mapHotspot
                    end
                    if fillLevel > 0 and fillType ~= nil then
                        self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                        if self.stockData[fillType].stockLevels[storageArrayTag] ~= nil then
                                self.stockData[fillType].stockLevels[storageArrayTag].level = self.stockData[fillType].stockLevels[storageArrayTag].level + fillLevel
                        else
                            self.stockData[fillType].stockLevels[storageArrayTag] = {tag = storageArrayTag, name = storageName, level = fillLevel, mapHotSpot = foundHotSpot}
                        end
                    end
                end
            elseif vehicle.isPallet and vehicle.ownerFarmId == g_currentMission:getFarmId() then
                if vehicle.spec_fillUnit ~= nil and vehicle.spec_fillUnit.fillUnits ~=nil and #vehicle.spec_fillUnit.fillUnits > 0 then
                    -- if self.debug  then
                    --     print("--- Got Pallet spec_fillUnit.fillUnits")
                    -- end
                    local fillType = vehicle.spec_fillUnit.fillUnits[1].fillType
                    local fillLevel = vehicle.spec_fillUnit.fillUnits[1].fillLevel
                    -- if self.debug  then
                    --     print("--- Got Pallet vehicle.spec_fillUnit.fillUnits - "..tostring(fillType).." - "..tostring(fillLevel))
                    -- end
                    local foundHotSpot  = nil
                    local storageName = ""
                    local storageArrayTag = ""
                    if vehicle.spec_woodContainer ~= nil then
                        storageName = self.i18n:getText("ui_text_shippingcontainer")
                        storageArrayTag = "ShipCont"..tostring(shippingContainterNum)
                        shippingContainterNum = shippingContainterNum + 1
                        -- local x,y,z = 		getWorldTranslation(vehicle.rootNode)
                        -- foundHotSpot = PlaceableHotspot.new()
                        if not foundHotSpot and vehicle.mapHotspot ~= nil then
                            foundHotSpot = vehicle.mapHotspot
                        end
                    else
                        storageName = self.i18n:getText("category_pallets")
                        storageArrayTag = "LoosePallets"
                    end
                    if fillLevel > 0 and fillType ~= nil then
                        self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                        if self.stockData[fillType].stockLevels[storageArrayTag] ~= nil then
                                self.stockData[fillType].stockLevels[storageArrayTag].level = self.stockData[fillType].stockLevels[storageArrayTag].level + fillLevel
                        else
                            self.stockData[fillType].stockLevels[storageArrayTag] = {tag = storageArrayTag, name = storageName, level = fillLevel, mapHotSpot = foundHotSpot}
                        end
                    end
                end
            end
        end
    end

    -- Bales
    for _, item in pairs (g_currentMission.itemSystem.itemsToSave) do
        local bale = item.item
        if bale.isa ~= nill and bale:isa(Bale) and bale.ownerFarmId == g_currentMission:getFarmId() then
            local fillType = bale.fillType
            local fillLevel = bale.fillLevel
            local storageName = ""
            local storageArrayTag = ""
            local fermenting = false
            local extratext = ""

            local alreadyAdded = false
            if bale.uniqueId ~= nil then
                if self.debug then
                    print("--- Giants Object Storage listig uniqueIDs testing " .. bale.uniqueId)
                end
                for k=1, #uniqueIDsAlreadyCounted do
                    if uniqueIDsAlreadyCounted[k] == bale.uniqueId then
                        alreadyAdded = true
                        break
                    end
                end
            end

            if alreadyAdded == false then
                storageName = self.i18n:getText("category_bales")
                if bale.isFermenting ~= nil and bale.isFermenting then
                    fermenting = true
                    storageName = g_i18n:getText("info_fermenting").." "..self.i18n:getText("category_bales")
                end
                storageArrayTag = "LooseBales"
                
                if fermenting then
                    local fermentPcent = bale.fermentingPercentage
                    if fermentPcent < 0.33 then
                        storageArrayTag = "LooseBalesFerment0"
                        extratext = "0 - 33%"
                    elseif fermentPcent < 0.66 then
                        extratext = "33 - 66%"
                        storageArrayTag = "LooseBalesFerment33"
                    elseif fermentPcent < 1 then
                        storageArrayTag = "LooseBalesFerment66"
                        extratext = "66 - 99%"
                    end
                end

                if fillLevel > 0 and fillType ~= nil then
                    self.stockData[fillType].currentStockLevel = self.stockData[fillType].currentStockLevel + fillLevel
                    if self.stockData[fillType].stockLevels[storageArrayTag] ~= nil then
                            self.stockData[fillType].stockLevels[storageArrayTag].level = self.stockData[fillType].stockLevels[storageArrayTag].level + fillLevel
                    else
                        self.stockData[fillType].stockLevels[storageArrayTag] = {tag = storageArrayTag, name = storageName, level = fillLevel, mapHotSpot = nil, extraText = extratext}
                    end
                    if uniqueID ~=nil then
                        table.insert(uniqueIDsAlreadyCounted, uniqueID)
                    end
                end
            end
        end
    end
    self.sortingAsc = true
    self.headerSortedBy = self.goodsHeader
    self.iconGoodAscending:setVisible(true)
    self.iconGoodDescending:setVisible(false)
    self.iconValueAscending:setVisible(false)
    self.iconValueDescending:setVisible(false)
    self.iconBValueAscending:setVisible(false)
    self.iconBValueDescending:setVisible(false)
    self.iconBMonthAscending:setVisible(false)
    self.iconBMonthDescending:setVisible(false)
self:populateAndSort_inStockData()
end    

function InGameMenuStockCheck:populateAndSort_inStockData()
     self.inStockData = {}
     local ftotalStorage = 0.0
     local ftotalValue = 0.0
     local fbestTotalValue = 0.0

     for _, stockData in pairs(self.stockData) do
        if stockData.currentStockLevel > 0 and (self.showAllItems or not stockData.noSellPoint) then
            table.insert(self.inStockData, stockData)
            ftotalStorage = ftotalStorage + stockData.currentStockLevel
            if stockData.noSellPoint == false then
                ftotalValue = ftotalValue + (stockData.currentStockLevel * stockData.bestBuyingPricePerLiter)
            end
            fbestTotalValue = fbestTotalValue + (stockData.maxPricePerLiter * stockData.currentStockLevel * stockData.bestPriceScale)
        end
     end

    -- if self.debug then
    --     print("--- Got Prices")
    --     DebugUtil.printTableRecursively(self.inStockData)
    -- end
    table.sort(self.inStockData, InGameMenuStockCheck.sortingFunction)
    
    self.currentBalanceText:setText(g_i18n:formatMoney(g_currentMission:getMoney(), tue, true))
	self.stockCheckTable:reloadData()
    self.totalStorage:setText(g_i18n:formatVolume(ftotalStorage, 0))    
    self.totalValue:setText(g_i18n:formatMoney(ftotalValue, 0, true, true))    
    self.bestTotalValue:setText(g_i18n:formatMoney(fbestTotalValue, 0, true, true))    
end

function InGameMenuStockCheck:checkForStationPriceScale(station, xmlFile)
    if self.debug then
        print("--- InGameMenuStockCheck:checkForStationPriceScale ".. tostring(station:getName()))
    end
    local key ="placeable.sellingStation"
	xmlFile:iterate(key .. ".fillType", function (_, fillTypeKey)
		local fillTypeStr = xmlFile:getValue(fillTypeKey .. "#name")
		local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeStr)

		if fillTypeIndex ~= nil then
            if self.debug then
			    Logging.xmlInfo(xmlFile, "Valid fillType '%s' in '%s'", fillTypeStr, fillTypeKey)
            end
            if self.stockData[fillTypeIndex] ~= nil then
                local priceScale = xmlFile:getValue(fillTypeKey .. "#priceScale", 1)
                if self.stockData[fillTypeIndex].noSellPoint == true then
                    self.stockData[fillTypeIndex].bestPriceScale = priceScale
                    self.stockData[fillTypeIndex].noSellPoint = false
                    if self.debug then
                        Logging.info("Initial Price Scale '%s' is '%f'", fillTypeStr, priceScale)
                    end
                elseif priceScale > self.stockData[fillTypeIndex].bestPriceScale then
                    self.stockData[fillTypeIndex].bestPriceScale = priceScale
                    if self.debug then
                        Logging.info("Updated Price Scale '%s' is '%f'", fillTypeStr, priceScale)
                    end
                end
            end
        else
            if self.debug then
                Logging.xmlWarning(xmlFile, "Invalid fillType '%s' in '%s'", fillTypeStr, fillTypeKey)
            end
		end
	end)

end

function InGameMenuStockCheck:getMaxMeanAndMonth(fillType)
	local max = 0
	local maxmonth = SeasonPeriod.EARLY_SPRING
	local mean = 0;
	local total = 0;

	for period = SeasonPeriod.EARLY_SPRING, SeasonPeriod.LATE_WINTER do
		local periodprice = (fillType.pricePerLiter or 0.0) * (fillType.economy.factors[period] or 1.0)
		total = total + periodprice
		if periodprice > max then
			max = periodprice
			maxmonth = period
		end
    end
	mean = total / 12
	return max, mean, maxmonth
end

function InGameMenuStockCheck:getNumberOfSections()
	return 1
end

function InGameMenuStockCheck:getNumberOfItemsInSection(list, section)
        return #self.inStockData
end

function InGameMenuStockCheck:getTitleForSectionHeader(list, section)
    if section == 1 then
	    return "Stock Levels"
    else
        return "Totals"
    end
end

function InGameMenuStockCheck:populateCellForItemInSection(list, section, index, cell)
        local currentMonth = g_currentMission.environment.currentPeriod
        local stockData = self.inStockData[index]   
        local isColourBlindMode = g_gameSettings:getValue(GameSettings.SETTING.USE_COLORBLIND_MODE) or false 

        cell:getAttribute("icon"):setImageFilename(stockData.hudOverlayFilename)
        cell:getAttribute("good"):setText(stockData.title)
        cell:getAttribute("storage"):setText(g_i18n:formatVolume(stockData.currentStockLevel, 0))
        if stockData.noSellPoint == true then
            cell:getAttribute("price"):setText("-")
            cell:getAttribute("value"):setText("-")
            cell:getAttribute("trend"):applyProfile("ingameMenuTSStockCheckRowCellArrow")
            cell:getAttribute("value").textColor = self.color.normal
        else
            local curValue = stockData.currentStockLevel * stockData.bestBuyingPricePerLiter
            local MaxPrice = stockData.maxPricePerLiter * stockData.currentStockLevel * stockData.bestPriceScale
            cell:getAttribute("price"):setText(g_i18n:formatMoney(stockData.bestBuyingPricePerLiter * 1000, 0, true, true))
            cell:getAttribute("value"):setText(g_i18n:formatMoney(stockData.currentStockLevel * stockData.bestBuyingPricePerLiter, 0, true, true))
            if curValue >= MaxPrice then
                cell:getAttribute("value").textColor = InGameMenuStockCheck.priceGuideColours.great[isColourBlindMode] --self.color.brightgreen
            elseif curValue >= (MaxPrice * self.vGoodPriceThreshold) then 
                cell:getAttribute("value").textColor = InGameMenuStockCheck.priceGuideColours.up[isColourBlindMode]
            elseif curValue >= (MaxPrice * self.goodPriceThreshold) then 
                cell:getAttribute("value").textColor = InGameMenuStockCheck.priceGuideColours.over[isColourBlindMode]
            else
                cell:getAttribute("value").textColor = InGameMenuStockCheck.priceGuideColours.normal[isColourBlindMode]
            end
            if Utils.isBitSet(stockData.priceTrend, SellingStation.PRICE_FALLING) then        
                cell:getAttribute("trend"):applyProfile("ingameMenuTSStockCheckRowCellArrowFalling")
            elseif Utils.isBitSet(stockData.priceTrend, SellingStation.PRICE_CLIMBING) then
                cell:getAttribute("trend"):applyProfile("ingameMenuTSStockCheckRowCellArrowClimbing")
            elseif Utils.isBitSet(stockData.priceTrend, SellingStation.PRICE_GREAT_DEMAND) then
                cell:getAttribute("trend"):applyProfile("ingameMenuTSStockCheckRowCellArrowGreatDemand")
            else
                cell:getAttribute("trend"):applyProfile("ingameMenuTSStockCheckRowCellArrow")
            end
        end
        if stockData.noSellPoint == true then
            cell:getAttribute("sellat"):setText(self.i18n:getText("ui_noSellPointsForThisFillType"))
        else
            cell:getAttribute("sellat"):setText(stockData.bestBuyingStation)
        end
        cell:getAttribute("bestprice"):setText(g_i18n:formatMoney(stockData.maxPricePerLiter * 1000 * stockData.bestPriceScale, 0, true, true))
        cell:getAttribute("bestvalue"):setText(g_i18n:formatMoney(stockData.maxPricePerLiter * stockData.currentStockLevel * stockData.bestPriceScale, 0, true, true))
        cell:getAttribute("bestmonth"):setText(g_i18n:formatPeriod(stockData.bestMonth, true))
        --print("Current Month - "..tostring(currentMonth))    
        if currentMonth == stockData.bestMonth then
            cell:getAttribute("bestmonth").textColor = InGameMenuStockCheck.priceGuideColours.great[isColourBlindMode]
        else
            cell:getAttribute("bestmonth").textColor = InGameMenuStockCheck.priceGuideColours.normal[isColourBlindMode]
        end
end

function InGameMenuStockCheck:onListSelectionChanged(list, section, index)
        self.currentStock = self.inStockData[index]
        self.mapHotSpot = self.inStockData[index].mapHotSpot
        self.btnShowLocationUi.disabled = false
        self.allSellpointButtonInfo.disabled = true
        if self.currentStock.sellPoints ~= nil and #self.currentStock.sellPoints > 1 then
            if self.debug then
                print("---- Enabling sellpoints button")
            end
            self.allSellpointButtonInfo.disabled = false
        else
            if self.debug then
                print("---- Not Enabling sellpoints button "..tostring(#self.currentStock.sellPoints))
            end
        end
        if self.mapHotSpot ~= nil then
            self.hotspotButtonInfo.disabled = false
            if self.mapHotSpot == g_currentMission.currentMapTargetHotspot then
                self.hotspotButtonInfo.text = string.upper(self.i18n:getText("action_untag"))
            else
                self.hotspotButtonInfo.text = string.upper(self.i18n:getText("action_tag"))
            end
        else
            self.hotspotButtonInfo.disabled = true
        end
     self:setMenuButtonInfoDirty()
end

function InGameMenuStockCheck:showLocationUi()
    local dialog = g_gui:showDialog("StorageLocationFrame")
    if dialog ~= nil then
        dialog.target:setStockData(self.currentStock)
    end
end

function InGameMenuStockCheck:onButtonAllSellPoint()
    local dialog = g_gui:showDialog("AllSellPointFrame")
    if dialog ~= nil then
        dialog.target:setStockData(self.currentStock)
    end
end

function InGameMenuStockCheck:onButtonHotspotPlaceable()
    local hotspot     = self.mapHotSpot

    if hotspot ~= nil then
        if hotspot == g_currentMission.currentMapTargetHotspot then
            self.hotspotButtonInfo.text = string.upper(self.i18n:getText("action_tag"))
            g_currentMission:setMapTargetHotspot()
            self:setMenuButtonInfoDirty()
        else
            self.hotspotButtonInfo.text = string.upper(self.i18n:getText("action_untag"))
            g_currentMission:setMapTargetHotspot(hotspot)
            self:setMenuButtonInfoDirty()
        end
    end
end

function InGameMenuStockCheck:onClickGoodsHeader(element)
    if self.debug then
        print("---- TSStockCheck - onClickGoodsHeader")
    end
	self:playSample(GuiSoundPlayer.SOUND_SAMPLES.CLICK)

    if InGameMenuStockCheck.headerSortedBy ~= nil and InGameMenuStockCheck.headerSortedBy ~= element then
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = true
        self.iconGoodAscending:setVisible(false)
        self.iconGoodDescending:setVisible(false)
        self.iconValueAscending:setVisible(false)
        self.iconValueDescending:setVisible(false)
        self.iconBValueAscending:setVisible(false)
        self.iconBValueDescending:setVisible(false)
        self.iconBMonthAscending:setVisible(false)
        self.iconBMonthDescending:setVisible(false)
    else
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = not self.sortingAsc
    end

    if self.sortingAsc then
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return string.lower(k1.title) < string.lower(k2.title) end
        self.iconGoodAscending:setVisible(true)
        self.iconGoodDescending:setVisible(false)
    else
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return string.lower(k1.title) > string.lower(k2.title) end
        self.iconGoodAscending:setVisible(false)
        self.iconGoodDescending:setVisible(true)
    end

    table.sort(self.inStockData,  InGameMenuStockCheck.sortingFunction)

    if self.debug then
        print("---- TSStockCheck - onClickGoodsHeader order Ascending - "..tostring(self.sortingAsc))
    end

    self.stockCheckTable:reloadData() 
end

function InGameMenuStockCheck:onClickValueHeader(element)
    if self.debug then
        print("---- TSStockCheck - onClickValueHeader")
    end
	self:playSample(GuiSoundPlayer.SOUND_SAMPLES.CLICK)

    if InGameMenuStockCheck.headerSortedBy ~= nil and InGameMenuStockCheck.headerSortedBy ~= element then
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = true
        self.iconGoodAscending:setVisible(false)
        self.iconGoodDescending:setVisible(false)
        self.iconValueAscending:setVisible(false)
        self.iconValueDescending:setVisible(false)
        self.iconBValueAscending:setVisible(false)
        self.iconBValueDescending:setVisible(false)
        self.iconBMonthAscending:setVisible(false)
        self.iconBMonthDescending:setVisible(false)
    else
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = not self.sortingAsc
    end


    if self.sortingAsc then
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return k1.currentStockLevel * k1.bestBuyingPricePerLiter < k2.currentStockLevel * k2.bestBuyingPricePerLiter end
        self.iconValueAscending:setVisible(true)
        self.iconValueDescending:setVisible(false)
    else 
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return k1.currentStockLevel * k1.bestBuyingPricePerLiter > k2.currentStockLevel * k2.bestBuyingPricePerLiter end
        self.iconValueAscending:setVisible(false)
        self.iconValueDescending:setVisible(true)
    end

    table.sort(self.inStockData,  InGameMenuStockCheck.sortingFunction)

    if self.debug then
        print("---- TSStockCheck - onClickValueHeader order Ascending - "..tostring(self.sortingAsc))
    end

    self.stockCheckTable:reloadData() 
end

function InGameMenuStockCheck:onClickBestValueHeader(element)
    if self.debug then
        print("---- TSStockCheck - onClickBestValueHeader")
    end
	self:playSample(GuiSoundPlayer.SOUND_SAMPLES.CLICK)

    if InGameMenuStockCheck.headerSortedBy ~= nil and InGameMenuStockCheck.headerSortedBy ~= element then
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = true
        self.iconGoodAscending:setVisible(false)
        self.iconGoodDescending:setVisible(false)
        self.iconValueAscending:setVisible(false)
        self.iconValueDescending:setVisible(false)
        self.iconBValueAscending:setVisible(false)
        self.iconBValueDescending:setVisible(false)
        self.iconBMonthAscending:setVisible(false)
        self.iconBMonthDescending:setVisible(false)
    else
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = not self.sortingAsc
    end


    if self.sortingAsc then
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return k1.maxPricePerLiter * k1.currentStockLevel * k1.bestPriceScale < k2.maxPricePerLiter * k2.currentStockLevel * k2.bestPriceScale end
        self.iconBValueAscending:setVisible(true)
        self.iconBValueDescending:setVisible(false)
    else
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return k1.maxPricePerLiter * k1.currentStockLevel * k1.bestPriceScale > k2.maxPricePerLiter * k2.currentStockLevel * k2.bestPriceScale end
        self.iconBValueAscending:setVisible(false)
        self.iconBValueDescending:setVisible(true)
    end

    table.sort(self.inStockData,  InGameMenuStockCheck.sortingFunction)

    if self.debug then
        print("---- TSStockCheck - onClickBestValueHeader order Ascending - "..tostring(self.sortingAsc))
    end

    self.stockCheckTable:reloadData() 
end

function InGameMenuStockCheck:onClickBestMonthHeader(element)
    if self.debug then
        print("---- TSStockCheck - onClickBestMonthHeader")
    end
	self:playSample(GuiSoundPlayer.SOUND_SAMPLES.CLICK)

    if InGameMenuStockCheck.headerSortedBy ~= nil and InGameMenuStockCheck.headerSortedBy ~= element then
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = true
        self.iconGoodAscending:setVisible(false)
        self.iconGoodDescending:setVisible(false)
        self.iconValueAscending:setVisible(false)
        self.iconValueDescending:setVisible(false)
        self.iconBValueAscending:setVisible(false)
        self.iconBValueDescending:setVisible(false)
        self.iconBMonthAscending:setVisible(false)
        self.iconBMonthDescending:setVisible(false)
    else
        InGameMenuStockCheck.headerSortedBy = element
        self.sortingAsc = not self.sortingAsc
    end


    if self.sortingAsc then
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return InGameMenuStockCheck:getTrueMonthNumber(k1.bestMonth) < InGameMenuStockCheck:getTrueMonthNumber(k2.bestMonth) end
        self.iconBMonthAscending:setVisible(true)
        self.iconBMonthDescending:setVisible(false)
    else
        InGameMenuStockCheck.sortingFunction = function (k1, k2) return InGameMenuStockCheck:getTrueMonthNumber(k1.bestMonth) > InGameMenuStockCheck:getTrueMonthNumber(k2.bestMonth) end
        self.iconBMonthAscending:setVisible(false)
        self.iconBMonthDescending:setVisible(true)
    end

    table.sort(self.inStockData,  InGameMenuStockCheck.sortingFunction)

    if self.debug then
        print("---- TSStockCheck - onClickBestMonthHeader order Ascending - "..tostring(self.sortingAsc))
    end

    self.stockCheckTable:reloadData() 
end

function InGameMenuStockCheck:getTrueMonthNumber(periodNum)
    local MonthText = g_i18n:formatPeriod(periodNum, true)
    local trueMonthNum = 0

    if MonthText == g_i18n:getText("ui_month1_short") then
        trueMonthNum = 1
    elseif MonthText == g_i18n:getText("ui_month2_short") then
        trueMonthNum = 2
    elseif MonthText == g_i18n:getText("ui_month3_short") then
        trueMonthNum = 3
    elseif MonthText == g_i18n:getText("ui_month4_short") then
        trueMonthNum = 4
    elseif MonthText == g_i18n:getText("ui_month5_short") then
        trueMonthNum = 5
    elseif MonthText == g_i18n:getText("ui_month6_short") then
        trueMonthNum = 6
    elseif MonthText == g_i18n:getText("ui_month7_short") then
        trueMonthNum = 7
    elseif MonthText == g_i18n:getText("ui_month8_short") then
        trueMonthNum = 8
    elseif MonthText == g_i18n:getText("ui_month9_short") then
        trueMonthNum = 9
    elseif MonthText == g_i18n:getText("ui_month10_short") then
        trueMonthNum = 10
    elseif MonthText == g_i18n:getText("ui_month11_short") then
        trueMonthNum = 11
    elseif MonthText == g_i18n:getText("ui_month12_short") then
        trueMonthNum = 12
    end
    return trueMonthNum
end

function InGameMenuStockCheck:onToggleShowAllItems()
    self.showAllItems = not self.showAllItems

    if self.showAllItems then
        self.toggleFilterButtonInfo.text = self.i18n:getText("ui_hide_all_items")
    else
        self.toggleFilterButtonInfo.text = self.i18n:getText("ui_show_all_items")
    end
    self:setMenuButtonInfoDirty()

    self:populateAndSort_inStockData()
end
