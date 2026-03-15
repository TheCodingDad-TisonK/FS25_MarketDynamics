--
-- AdvancedFarmManager - Placeable Page
--

AFMGuiPlaceableFrame = {}

local AFMGuiPlaceableFrame_mt = Class(AFMGuiPlaceableFrame, TabbedMenuFrameElement)

AFMGuiPlaceableFrame.COLUMN_NAME = 1
AFMGuiPlaceableFrame.COLUMN_CATEGORY = 2
AFMGuiPlaceableFrame.COLUMN_LOCATION = 3
AFMGuiPlaceableFrame.SORT_ORDER_DESC = 1
AFMGuiPlaceableFrame.SORT_ORDER_ASC = 2

function AFMGuiPlaceableFrame:new(l10n)
    local self = TabbedMenuFrameElement.new(nil,AFMGuiPlaceableFrame_mt)

    self.messageCenter      = g_messageCenter
    self.l10n               = l10n
    self.placeables         = {}
    self.sortByColumn       = AFMGuiPlaceableFrame.COLUMN_NAME
	  self.sortOrder          = AFMGuiPlaceableFrame.SORT_ORDER_ASC
    self.sortIcons          = {}
    self.isMPGame           = g_currentMission.missionDynamicInfo.isMultiplayer
    self.clonedElements     = {}
    self.marqueeBoxes       = {}
    self.detailsCache       = {}
    self.clonesInCache      = {}
    self.detailsTemplates   = {}
    self.costFactor         = 1.2

    return self
end


function AFMGuiPlaceableFrame:copyAttributes(src)
    AFMGuiPlaceableFrame:superClass().copyAttributes(self, src)

    self.ui   = src.ui
    self.l10n = src.l10n
end


function AFMGuiPlaceableFrame:initialize()
    afmDebug("AFMGuiPlaceableFrame:initialize")
    self.backButtonInfo = {inputAction = InputAction.MENU_BACK}

    self.activateButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = self.l10n:getText("afm_warp_loc"),
        callback    = function ()
            self:onButtonWarpPlaceable()
        end
    }
    self.cancelButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_CANCEL,
        text        = self.l10n:getText("button_sell"),
        callback    = function ()
            self:onButtonSellPlaceable()
        end
    }
    self.extra1ButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_1,
        text        = self.l10n:getText("afm_sell_animals"),
        callback    = function ()
            self:onButtonSellAnimals()
        end
    }
    self.hotspotButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACCEPT,
        text        = self.l10n:getText("action_tag"),
        callback    = function ()
            self:onButtonHotspotPlaceable()
        end
    }
    self.hotspotButtonInfo2 = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACCEPT,
        text        = self.l10n:getText("action_untag"),
        callback    = function ()
            self:onButtonHotspotPlaceable()
        end
    }

    self:buildCellDatabase()
end


function AFMGuiPlaceableFrame:onGuiSetupFinished()
    AFMGuiPlaceableFrame:superClass().onGuiSetupFinished(self)
    self.placeableList:setDataSource(self)
    self.placeableDetail:setDataSource(self)
end

function AFMGuiPlaceableFrame:update(dt)
	AFMGuiPlaceableFrame:superClass().update(self, dt)
	self:updateMarqueeAnimation(dt)
end

function AFMGuiPlaceableFrame:delete()
    AFMGuiPlaceableFrame:superClass().delete(self)
    self.messageCenter:unsubscribeAll(self)
    for idx, element in pairs(self.clonedElements) do
        element:delete()
        self.clonedElements[idx] = nil
    end
    for idx, element in pairs(self.detailsTemplates) do
        element:delete()
        self.detailsTemplates[idx] = nil
    end
end


function AFMGuiPlaceableFrame:updateMenuButtons()
    local selectedIndex = self.placeableList.selectedIndex
    if self.placeables[selectedIndex] ~= nil and self.placeables[selectedIndex].placeable ~= nil then 
        local thisPlaceable = self.placeables[selectedIndex].placeable

        if thisPlaceable ~= nil then

            self.menuButtonInfo = {
                {
                    inputAction = InputAction.MENU_BACK
                }
            }

            if selectedIndex > 0 then
                if thisPlaceable.storeItem.categoryName ~= "FENCES" then
                    table.insert(self.menuButtonInfo, self.activateButtonInfo)
                end

                if thisPlaceable.getSellPrice ~= nil and thisPlaceable:canBeSold() and g_currentMission:getHasPlayerPermission("farmManager") then
                    local sellPrice     = math.floor(thisPlaceable:getSellPrice())
                    self.cancelButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("button_sell"),
                        g_i18n:formatMoney(sellPrice, 0, true, true)
                    )
                    table.insert(self.menuButtonInfo, self.cancelButtonInfo)
                end

                local animalSellPrice = self:getTotalAnimalValue(thisPlaceable, true)
                if animalSellPrice >= 1 then
                    self.extra1ButtonInfo.text = string.format(
                            "%s (%s)",
                            g_i18n:getText("afm_sell_animals"),
                            g_i18n:formatMoney(animalSellPrice, 0, true, true)
                        )
                    table.insert(self.menuButtonInfo, self.extra1ButtonInfo)
                end

                if self:getHotspot() ~= nil or thisPlaceable.storeItem.categoryName ~= "FENCES" then
                    if g_currentMission.currentMapTargetHotspot ~= nil and g_currentMission.currentMapTargetHotspot == self:getHotspot() then
                        table.insert(self.menuButtonInfo, self.hotspotButtonInfo2)
                    else
                        table.insert(self.menuButtonInfo, self.hotspotButtonInfo)
                    end
                end
            end

        end
    end
    self:setMenuButtonInfoDirty()
end


function AFMGuiPlaceableFrame:onFrameOpen()
    self.itemDetailsMap:setIngameMap(g_currentMission.hud:getIngameMap())
    AFMGuiPlaceableFrame:superClass().onFrameOpen(self)

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiPlaceableFrame:onFrameOpen")
    end

    self.placeableIcon:setVisible(false)

    self:rebuildTable()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.placeableList)
    self:setSoundSuppressed(false)

    self:onMoneyChange()

    self.messageCenter:subscribe(MessageType.HUSBANDRY_SYSTEM_ADDED_PLACEABLE, self.onRefreshEvent, self)
    self.messageCenter:subscribe(MessageType.HUSBANDRY_SYSTEM_REMOVED_PLACEABLE, self.onRefreshEvent, self)
    self.messageCenter:subscribe(MessageType.FARM_PROPERTY_CHANGED, self.onRefreshEvent, self) -- update when someone buys or sells farmland
    self.messageCenter:subscribe(MessageType.MONEY_CHANGED, self.onMoneyChange, self) -- Update anytime there is a money change
    self.messageCenter:subscribe(SellPlaceableEvent, self.onRefreshEvent, self)
end


function AFMGuiPlaceableFrame:onRefreshEvent()
    self:rebuildTable()
end


function AFMGuiPlaceableFrame:onFrameClose()
    AFMGuiPlaceableFrame:superClass().onFrameClose(self)

    self.placeables = {}
    self.itemDetailsMap:onClose()
    self.messageCenter:unsubscribeAll(self)
end

function AFMGuiPlaceableFrame:rebuildTable()

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiPlaceableFrame:rebuildTable")
    end

    self.placeables = {}

    for _, placeable in pairs(g_currentMission.placeableSystem.placeables) do
        local hasStoreItem = placeable.configFileName ~= nil
        if hasStoreItem and placeable.ownerFarmId == afmGetPlayerFarmId() and placeable.ownerFarmId ~= FarmManager.SPECTATOR_FARM_ID and not placeable.markedForDeletion and not placeable.isDeleted and not placeable.isDeleteing then
            
            -- Setup placeable Sorting Stuff
            local placeableEntry = {
              ["placeable"] = placeable,
              ["columns"] = {}
            }

            local placeableName = placeable:getName()
            placeableEntry.columns[AFMGuiPlaceableFrame.COLUMN_NAME] = {
              ["text"] = placeableName,
              ["value"] = placeableName
            }

            local storeItem = g_storeManager:getItemByXMLFilename(placeable.configFileName)
            local getPlaceableCategory = g_storeManager:getCategoryByName(storeItem.categoryName)
            local placeableCategory = getPlaceableCategory.title
            placeableEntry.columns[AFMGuiPlaceableFrame.COLUMN_CATEGORY] = {
              ["text"] = placeableCategory,
              ["value"] = placeableCategory
            }

            local placeableLocation = self:getLocation(placeable)
            placeableEntry.columns[AFMGuiPlaceableFrame.COLUMN_LOCATION] = {
              ["text"] = placeableLocation,
              ["value"] = placeableLocation
            }
            
            -- Check to see what all needs loaded
            local rowIndexes = {}
            local curIndex = 0
            local detailText = {}
            local statusBar = {}
            local thisRawAmount = 0
            local icon = nil
            local iconProduct = nil
            local iconProfile = nil

            -- Build data for the details bar
            -- afmDebug("placeable data")
            -- afmDebug(placeable)

            -- Check if vehicle has ownership
            if placeable.getName ~= nil then
                curIndex = curIndex + 1
                detailText = {
                  title = g_i18n:getText("afm_name"),
                  level = placeable:getName()
                }
                iconProfile = "afm_icon_ownership"
                table.insert(rowIndexes, {item = "name", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- Output the map compass location
            local vehicleCompassLocation = self:getCompassLocation(placeable)
            if vehicleCompassLocation ~= nil then
                curIndex = curIndex + 1
                detailText = {
                  title = g_i18n:getText("afm_location"),
                  level = vehicleCompassLocation
                }
                iconProfile = "afm_icon_dirt"
                table.insert(rowIndexes, {item = "compass", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- Sell Value
            if placeable.getSellPrice ~= nil then
                local sellPrice   = math.floor(placeable:getSellPrice())
                if sellPrice ~= nil and sellPrice > 0 then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_sellValue"),
                      level = g_i18n:formatMoney(sellPrice,0,true,true)
                    }
                    iconProfile = "afm_icon_cost"
                    table.insert(rowIndexes, {item = "sellValue", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end
            end

            -- list daily upkeep
            local dailyUpkeep = placeable:getDailyUpkeep()
            if dailyUpkeep ~= nil and dailyUpkeep > 0 then
                curIndex = curIndex + 1
                detailText = {
                  title = g_i18n:getText("afm_dailyUpkeep"),
                  level = g_i18n:formatMoney(dailyUpkeep,0,true,true)
                }
                iconProfile = "afm_icon_cost"
                table.insert(rowIndexes, {item = "dailyUpkeep", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- list animals value
            local animalSellPrice = self:getTotalAnimalValue(placeable, false)
            if animalSellPrice ~= nil and animalSellPrice > 0 then
                curIndex = curIndex + 1
                detailText = {
                  title = g_i18n:getText("afm_animalsValue"),
                  level = g_i18n:formatMoney(animalSellPrice,0,true,true)
                }
                iconProfile = "afm_icon_cost"
                table.insert(rowIndexes, {item = "animalsValue", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- list if pre placed
            local preplaced = placeable:getIsPreplaced()
            if preplaced ~= nil and preplaced == true then
                curIndex = curIndex + 1
                detailText = {
                  title = g_i18n:getText("afm_prePlaced"),
                  level = g_i18n:getText("afm_mapDefault")
                }
                iconProfile = "afm_icon_ownership"
                table.insert(rowIndexes, {item = "preplaced", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- Get placeable age
            if placeable.age ~= nil then
                curIndex = curIndex + 1
                detailText = {
                    title   = g_i18n:getText("afm_age"),
                    level   = self:formatAge(placeable.age)
                }
                iconProfile = "afm_icon_time"
                table.insert(rowIndexes, {item = "age", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
            end

            -- Load the brand
            if placeable.storeItem ~= nil and placeable.storeItem.brandIndex ~= nil then
                local brand = g_brandManager:getBrandByIndex(storeItem.brandIndex)
                if brand ~= nil and brand.name ~= "NONE" then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_brand"),
                      level = brand.title
                    }
                    iconProfile = "afm_icon_brand"
                    table.insert(rowIndexes, {item = "brand", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end
            end

            -- Get placeable income per hour
            if placeable.getIncomePerHour ~= nil then
                local incomePerHour = placeable:getIncomePerHour()
                if incomePerHour ~= nil and incomePerHour > 0 then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_incomePerHour"),
                      level = g_i18n:formatMoney(incomePerHour,0,true,true)
                    }
                    iconProfile = "afm_icon_cost"
                    table.insert(rowIndexes, {item = "leasingCost", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end
            end

            -- Get Constructible data
            if placeable.spec_constructible ~= nil and placeable.spec_constructible.stateMachine ~= nil then            
                
                -- this one is going to be fun to figure out
                local currentState = placeable.spec_constructible.stateIndex
                local totalStates = #placeable.spec_constructible.stateMachine

                -- Get the current state of the construction
                local statePercent = currentState / totalStates
                curIndex = curIndex + 1
                detailText = {
                    title   = g_i18n:getText("afm_constructionState"),
                    level   = string.format("%d of %d", currentState, totalStates)
                }
                statusBar = {
                    value       = self:formatPercentToBar(statePercent), 
                    rawValue    = self:formatPercentToBar(statePercent)
                }
                iconProfile = "afm_icon_info"
                table.insert(rowIndexes, {item = "fermented", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})

                -- Current State Data
                if placeable.spec_constructible.stateMachine ~= nil and placeable.spec_constructible.stateMachine[currentState] ~= nil and placeable.spec_constructible.stateMachine[currentState].inputs ~= nil then

                    for _, input in pairs(placeable.spec_constructible.stateMachine[currentState].inputs) do
                        local fillTypeData = input.fillType
                        local usagePerHour = input.usagePerSecond * 60 * 60
                        local totalNeeded = input.amount
                        local totalAdded = input.amount - input.remainingAmount
                        local percentage = totalAdded / totalNeeded

                        curIndex = curIndex + 1
                        detailText = {
                            title   = fillTypeData.title,
                            level   = string.format("%sl of %sl (%sl/h)",g_i18n:formatNumber(math.floor(totalAdded)), g_i18n:formatNumber(math.floor(totalNeeded)), g_i18n:formatNumber(math.floor(usagePerHour)))
                        }
                        statusBar = {
                            value       = self:formatPercentToBar(percentage), 
                            rawValue    = self:formatPercentToBar(percentage)
                        }
                        icon = fillTypeData.hudOverlayFilename
                        table.insert(rowIndexes, {item = "fill1", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, icon = icon})

                    end

                    -- Get the input data for each state to get some overall stats
                    local inputsTotals = {}
                    local maxUsageTime = 0
                    local maxRemainingTime = 0

                    for _, stateData in pairs(placeable.spec_constructible.stateMachine) do

                        if stateData.inputs ~= nil then
                            for _, inputData in pairs(stateData.inputs) do

                                local usageTime = 0
                                local remainingTime = 0 

                                if inputData.amount ~= nil and inputData.amount > 0 and inputData.usagePerSecond ~= nil and inputData.usagePerSecond > 0 then
                                    usageTime = inputData.amount / inputData.usagePerSecond
                                    remainingTime = inputData.remainingAmount / inputData.usagePerSecond
                                end

                                -- Check to see if input already added, if not add it to the mix
                                if inputsTotals[inputData.fillType.index] ~= nil then
                                    -- Input already exists, lets add to the last.
                                    local prevInputsTotals = inputsTotals[inputData.fillType.index]
                                    inputsTotals[inputData.fillType.index] = {
                                        fillType = inputData.fillType,
                                        hudOverlayFilename = inputData.fillType.hudOverlayFilename,
                                        amount = inputData.amount + prevInputsTotals.amount,
                                        remainingAmount = inputData.remainingAmount + prevInputsTotals.remainingAmount,
                                        usageTime = usageTime + prevInputsTotals.usageTime,
                                        remainingTime = remainingTime + prevInputsTotals.remainingTime
                                    }
                                else
                                    -- Input does not exist yet, add it
                                    inputsTotals[inputData.fillType.index] = {
                                        fillType = inputData.fillType,
                                        hudOverlayFilename = inputData.fillType.hudOverlayFilename,
                                        amount = inputData.amount,
                                        remainingAmount = inputData.remainingAmount,
                                        usageTime = usageTime,
                                        remainingTime = remainingTime
                                    }
                                end

                                if inputsTotals[inputData.fillType.index].usageTime > maxUsageTime then
                                    maxUsageTime = inputsTotals[inputData.fillType.index].usageTime
                                end

                                if inputsTotals[inputData.fillType.index].remainingTime > maxRemainingTime then
                                    maxRemainingTime = inputsTotals[inputData.fillType.index].remainingTime
                                end

                            end
                        end

                    end

                    -- Build Time Est
                    -- if maxUsageTime > 0 then
                    --     curIndex = curIndex + 1
                    --     detailText = {
                    --         title   = g_i18n:getText("afm_estBuildTime"),
                    --         level   = self:formatTime(maxUsageTime)
                    --     }
                    --     iconProfile = "afm_icon_time"
                    --     table.insert(rowIndexes, {item = "age", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                    -- end

                    -- Build Time Est
                    if maxRemainingTime > 0 then
                        curIndex = curIndex + 1
                        detailText = {
                            title   = g_i18n:getText("afm_estBuildTimeRemaining"),
                            level   = self:formatTime(maxRemainingTime)
                        }
                        iconProfile = "afm_icon_time"
                        table.insert(rowIndexes, {item = "age", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                    end

                    -- Header bar for storage totals
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("afm_materialsInStorage"),
                        level   = g_i18n:getText("afm_totals")
                    }
                    iconProfile = "afm_icon_info"
                    table.insert(rowIndexes, {item = "fermented", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

                    -- Get the total good in storage
                    if placeable.spec_constructible.storage ~= nil then

                        for fillTypeIndex, fillLevel in pairs(placeable.spec_constructible.storage.fillLevels) do
                            local fillTypeData = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

                            local totalCapacity = placeable.spec_constructible.storage.capacities[fillTypeIndex]
                            local percentage = 0
                            if fillLevel == 0 then
                              percentage = 0
                            else
                              percentage = fillLevel / totalCapacity
                            end

                            curIndex = curIndex + 1
                            detailText = {
                                title   = fillTypeData.title,
                                level   = string.format("%sl",g_i18n:formatNumber(math.floor(fillLevel), 1, true))
                            }
                            statusBar = {
                                value       = self:formatPercentToBar(percentage), 
                                rawValue    = self:formatPercentToBar(percentage)
                            }
                            icon = fillTypeData.hudOverlayFilename
                            table.insert(rowIndexes, {item = "fill1", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, icon = icon})
                        end

                    end

                end

            end

            -- Get bunker silo data
            if placeable.spec_bunkerSilo ~= nil and placeable.spec_bunkerSilo.bunkerSilo ~= nil then
                -- Load Bunker Fill Amount
                if placeable.spec_bunkerSilo.bunkerSilo.fillLevel ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_fillLevel"),
                      level = string.format("%sl",g_i18n:formatNumber(math.floor(placeable.spec_bunkerSilo.bunkerSilo.fillLevel), 1, true))
                    }
                    iconProfile = "afm_icon_capacity"
                    table.insert(rowIndexes, {item = "fillLevel", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Load Bunker Compact Level
                if placeable.spec_bunkerSilo.bunkerSilo.compactedPercent ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("afm_compacted"),
                        level   = self:formatPercent(placeable.spec_bunkerSilo.bunkerSilo.compactedPercent)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(placeable.spec_bunkerSilo.bunkerSilo.compactedPercent),
                        rawValue    = self:formatPercentToBar(placeable.spec_bunkerSilo.bunkerSilo.compactedPercent)
                    }
                    iconProfile = "afm_icon_tireName"
                    table.insert(rowIndexes, {item = "compacted", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
                end

                -- Load Bunker Compact Level
                if placeable.spec_bunkerSilo.bunkerSilo.fermentingPercent ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("afm_fermented"),
                        level   = self:formatPercent(placeable.spec_bunkerSilo.bunkerSilo.fermentingPercent)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(placeable.spec_bunkerSilo.bunkerSilo.fermentingPercent), 
                        rawValue    = self:formatPercentToBar(placeable.spec_bunkerSilo.bunkerSilo.fermentingPercent)
                    }
                    iconProfile = "afm_icon_info"
                    table.insert(rowIndexes, {item = "fermented", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
                end
            end

            -- Get silo capacity with the fill icon
            if placeable.spec_silo ~= nil then
            
                local siloFillLevels   = {}
                local rawFillLevels    = {}
                local cleanFillLevels  = {}
                local totalFill        = 0
                local capacity         = 0
                local playerFarmId     = afmGetPlayerFarmId()
                local thisFillLevels   = placeable:getFillLevels(playerFarmId)
                local spec             = placeable.spec_silo


                for _, sourceStorage in pairs(spec.loadingStation.sourceStorages) do
                  if spec.loadingStation:hasFarmAccessToStorage(playerFarmId, sourceStorage) then
                    capacity = capacity + sourceStorage.capacity
                  end
                end

                for fillType, fillLevel in pairs(thisFillLevels) do
                  rawFillLevels[fillType] = (rawFillLevels[fillType] or 0) + fillLevel
                end

                for fillType, fillLevel in pairs(rawFillLevels) do

                  local curFreeCapacity = 0
                  local curFillLevel = 0

                  for _, storage in ipairs(spec.storages) do
                    curFreeCapacity = storage:getFreeCapacity(fillType)

                    if curFreeCapacity > 0 then
                      curFillLevel = storage:getFillLevel(fillType)
                    end
                  end

                  if fillLevel > 0 then
                    local roundFillLevel = MathUtil.round(fillLevel)
                    table.insert(cleanFillLevels, {
                      fillType    = g_fillTypeManager:getFillTypeNameByIndex(fillType),
                      level       = roundFillLevel,
                      fillLevel   = curFillLevel,
                      freeCapacity = curFreeCapacity
                    })
                    totalFill = totalFill + roundFillLevel
                  end
                end

                table.insert(siloFillLevels, {
                  percent    = MathUtil.getFlooredPercent(totalFill, capacity),
                  totalFill  = totalFill,
                  capacity   = capacity,
                  fillLevels = cleanFillLevels
                })

                -- Load Fill data
                if siloFillLevels ~= nil then
                    for _, fillData in pairs(siloFillLevels) do
                        -- Get fill percentage
                        local fillPercentage = fillData.percent
                        local normalizedValue = fillPercentage / 100

                        -- Display the capacity for the silo
                        curIndex = curIndex + 1
                        detailText = {
                          title = g_i18n:getText("afm_capacity"),
                          level = string.format("%sl",g_i18n:formatNumber(math.floor(fillData.capacity), 1, true))
                        }
                        iconProfile = "afm_icon_capacity2"
                        table.insert(rowIndexes, {item = "capacity", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})


                        curIndex = curIndex + 1
                        detailText = {
                            title   = g_i18n:getText("afm_fillLevel"),
                            level   = self:formatPercent(fillData.percent)
                        }
                        statusBar = {
                            value       = self:formatPercentToBar(normalizedValue), 
                            rawValue    = self:formatPercentToBar(normalizedValue)
                        }
                        iconProfile = "afm_icon_capacity"
                        table.insert(rowIndexes, {item = "totalFillLevel", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})

                        -- Get fill levels for each product in silo
                        if fillData.fillLevels ~= nil then
                            for _, fillLevels in pairs(fillData.fillLevels) do
                                local fillTypeData = g_fillTypeManager:getFillTypeByName(fillLevels.fillType)

                                local totalCapacity = fillLevels.fillLevel + fillLevels.freeCapacity
                                local percentage = 0
                                if fillLevels.freeCapacity == 0 then
                                  percentage = 1
                                else
                                  percentage = fillLevels.fillLevel / totalCapacity
                                end

                                curIndex = curIndex + 1
                                detailText = {
                                    title   = fillTypeData.title,
                                    level   = string.format("%sl",g_i18n:formatNumber(math.floor(fillLevels.level), 1, true))
                                }
                                statusBar = {
                                    value       = self:formatPercentToBar(percentage), 
                                    rawValue    = self:formatPercentToBar(percentage)
                                }
                                icon = fillTypeData.hudOverlayFilename
                                table.insert(rowIndexes, {item = "fill1", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, icon = icon})
                            end
                        end
                    end
                end 
            end

            -- Get object storage data
            if placeable.spec_objectStorage ~= nil then

                local infoTable         = {}
                local spec              = placeable.spec_objectStorage
                local capacity          = spec.capacity
                local numStoredObjects  = spec.numStoredObjects
                local numObjectInfos    = spec.objectInfos

                for _, objectInfo in pairs(numObjectInfos) do       
                  if objectInfo.objects[1] ~= nil then
                    local title = objectInfo.objects[1]:getDialogText()

                    if string.len(title) > 32 then
                      title = string.sub(title, 0, 32) .. "..."
                    end

                    local fillType = 0
                    if objectInfo.objects[1].baleAttributes ~= nil then
                        fillType = objectInfo.objects[1].baleAttributes.fillType
                    elseif objectInfo.objects[1].palletAttributes ~= nil then
                        fillType = objectInfo.objects[1].palletAttributes.fillType
                    end

                    table.insert(infoTable, {
                      item        = title,
                      numObjects  = tostring(objectInfo.numObjects),
                      fillType    = fillType,

                    })
                  end
                end

                local objectStorageData = {
                  capacity          = capacity,
                  numStoredObjects  = numStoredObjects,
                  infoTable         = infoTable,
                }

                if objectStorageData.capacity ~= nil and objectStorageData.capacity > 0 then
                    -- Display the capacity for the silo
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_capacity"),
                      level = string.format("%sl",g_i18n:formatNumber(math.floor(objectStorageData.capacity), 1, true))
                    }
                    iconProfile = "afm_icon_capacity2"
                    table.insert(rowIndexes, {item = "capacity", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

                    -- Display current fill level
                    local fillPercent = objectStorageData.numStoredObjects / objectStorageData.capacity
                    local fillPercentText = fillPercent * 100
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("afm_fillLevel"),
                        level   = self:formatPercent(fillPercentText)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(fillPercent), 
                        rawValue    = self:formatPercentToBar(fillPercent)
                    }
                    iconProfile = "afm_icon_capacity"
                    table.insert(rowIndexes, {item = "totalFillLevel", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})

                    -- -- Get stuff that is in the object storage
                    if objectStorageData.infoTable ~= nil then
                        for _, objects in pairs(objectStorageData.infoTable) do
                            local fillTypeData = g_fillTypeManager:getFillTypeByIndex(objects.fillType)

                            curIndex = curIndex + 1
                            detailText = {
                                title   = objects.item,
                                level   = string.format("%s",g_i18n:formatNumber(math.floor(objects.numObjects), 1, true))
                            }
                            iconProduct = fillTypeData.hudOverlayFilename
                            table.insert(rowIndexes, {item = "fill1", rowIndex = curIndex, detailText = detailText, iconProduct = iconProduct})
                        end
                    end
                end
            end

            -- Get manure heap data if any
            if placeable.spec_manureHeap ~= nil and placeable.spec_manureHeap.manureHeap ~= nil then
                local specMH            = placeable.spec_manureHeap.manureHeap
                local capacity          = specMH.capacity
                local fillType          = g_fillTypeManager:getFillTypeNameByIndex(specMH.fillTypeIndex)
                local fillLevel         = math.floor(specMH.fillLevels[specMH.fillTypeIndex])

                local percentage = fillLevel / capacity

                curIndex = curIndex + 1
                detailText = {
                  title = fillType.title,
                  level = string.format("%sl",g_i18n:formatNumber(math.floor(fillLevel), 1, true))
                }
                statusBar = {
                    value       = self:formatPercentToBar(percentage), 
                    rawValue    = self:formatPercentToBar(percentage)
                }
                iconProduct = fillType.hudOverlayFilename
                table.insert(rowIndexes, {item = "fillLevel", rowIndex = curIndex, detailText = detailText, iconProduct = iconProduct, statusBar = statusBar})

            end

            -- Display husbandry animal totals per cluster
            if placeable.spec_husbandryAnimals ~= nil and placeable.spec_husbandryAnimals.clusterSystem ~= nil then
                -- afmDebug("Husbandry Animals")
                -- afmDebug(placeable.spec_husbandryAnimals)
                
                local clusters = placeable.spec_husbandryAnimals.clusterSystem:getClusters()
                if clusters ~= nil then
                    for _, cluster in ipairs(clusters) do
                        local animalItem = AnimalItemStock.new(cluster)
                        local pricePerAnimal = animalItem:getPrice()
                        local count = animalItem:getNumAnimals()

                        local formattedAge = self:formatAge(animalItem.cluster.age) 

                        curIndex = curIndex + 1
                        detailText = {
                          title = animalItem.title,
                          level = string.format("%d @ %s",count, formattedAge)
                        }
                        iconProfile = "afm_icon_animals"
                        table.insert(rowIndexes, {item = "animalCount", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

                    end
                end
            end


            -- Display husbandry fill data 
            if placeable.getFoodInfos ~= nil then
                -- afmDebug("Husbandry Animals Fills")
                local thisFood = placeable:getFoodInfos()
                for _, thisFoodInfo in ipairs(thisFood) do
                    local fillTypeName = thisFoodInfo.title:match("^(.-)%s*%b()")
                    if fillTypeName == "Total Mixed Ration" then
                      fillTypeName = "FORAGE"
                    elseif fillTypeName == "Grass" then
                      fillTypeName = "GRASS_WINDROW"
                    elseif fillTypeName == "Meadow" then
                      fillTypeName = "GRASS"
                    elseif fillTypeName == "Hay" then
                      fillTypeName = "DRYGRASS_WINDROW"
                    end
                    local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                    local fillTypeName = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                    local foodData = {
                        title     = thisFoodInfo.title,
                        percent   = math.ceil(thisFoodInfo.ratio * 100),
                        capacity  = thisFoodInfo.capacity,
                        fillLevel = math.floor(thisFoodInfo.value),
                        fillType = fillTypeName
                    }
                    curIndex = curIndex + 1
                    detailText = {
                      title = foodData.title,
                      level = string.format("%sl",g_i18n:formatNumber(math.floor(foodData.fillLevel), 1, true))
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(foodData.percent), 
                        rawValue    = self:formatPercentToBar(foodData.percent)
                    }

                    if foodData.fillType ~= nil then
                        iconProduct = foodData.fillType.hudOverlayFilename
                        table.insert(rowIndexes, {item = "foodLevel", rowIndex = curIndex, detailText = detailText, iconProduct = iconProduct, statusBar = statusBar})
                    else
                        iconProfile = "afm_icon_capacity"
                        table.insert(rowIndexes, {item = "foodLevel", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile, statusBar = statusBar})
                    end

                end
            end


            -- Add all of the rows for placeable details display
            placeable.rowIndexes = rowIndexes

            -- Add placeable to table data
            table.insert(self.placeables, placeableEntry)

        end
    end

    if self.placeables ~= nil and #self.placeables > 0 then
        self.mainBox:setVisible(true)
        self.itemDetailsMap:setVisible(true)
        self.attributesLayout:setVisible(true)
        self.mainBoxEmpty:setVisible(false)

        self:applySorting(self.sortByColumn, self.sortOrder)

        self.placeableList:reloadData()
        self.placeableDetail:reloadData()
    else
        -- Farm does not own any placeables, so let's hid stuff so it does not look broken.
        self.mainBox:setVisible(false)
        self.itemDetailsMap:setVisible(false)
        self.attributesLayout:setVisible(false)
        -- Show Empty Info
        self.mainBoxEmpty:setVisible(true)
    end
    self:updateView()
end

function AFMGuiPlaceableFrame:getNumberOfItemsInSection(list, section)
    local selectedIndex = self.placeableList:getSelectedIndexInSection()
    if selectedIndex ~= nil then
        if list == self.placeableList and self.placeables ~= nil then
            return #self.placeables
        elseif self.placeables ~= nil and #self.placeables > 0 and self.placeables[selectedIndex] ~= nil and self.placeables[selectedIndex].placeable ~= nil and self.placeables[selectedIndex].placeable.rowIndexes ~= nil then
            -- Total number or rows for placeable details.
            return #self.placeables[selectedIndex].placeable.rowIndexes
        else
            return 0
        end
    else
        return 0
    end
end

function AFMGuiPlaceableFrame:populateCellForItemInSection(list, section, index, cell)
    if list == self.placeableList then
        local thisPlace   = self.placeables[index].placeable
        local thisColor   = { 1, 1, 1, 1 }
        local name        = thisPlace:getName()

        if thisPlace.brand ~= nil and thisPlace.brand.title ~= nil and thisPlace.brand.title ~= "None" then
            name = thisPlace.brand.title .. " " .. name
        end
        if not thisPlace:canBeSold() then
            name = name .. " [" .. g_i18n:getText("afm_nonSell") .. "]"
        end

        local farm = g_farmManager:getFarmById(thisPlace.ownerFarmId)

        cell:getAttribute("dotBg").color = { 0.02956, 0.02956, 0.02956, 0.5 }
        cell:getAttribute("dot").color = farm:getColor()
        cell:getAttribute("title"):setText(name)
        cell:getAttribute("title").textColor = thisColor
        cell:getAttribute("type"):setText(self:typeString(thisPlace, true))
        cell:getAttribute("location"):setText(self:getLocation(thisPlace))
    else
        local selectedIndex      = self.placeableList.selectedIndex
        local thisPlaceable        = self.placeables[selectedIndex].placeable

        if thisPlaceable ~= nil then
            self.placeableIcon:setVisible(true)
            self.placeableDetail:setVisible(true)
            self.afmInfoSubVeh:setVisible(true)

            local rowIndexes = thisPlaceable.rowIndexes

            -- Load up the placeable details display
            if rowIndexes ~= nil and rowIndexes[index] ~= nil then

                local nukeBar = true
                if rowIndexes[index].statusBar ~= nil and rowIndexes[index].statusBar.value ~= nil and rowIndexes[index].statusBar.rawValue ~= nil then
                    self:setStatusBarValue(cell:getAttribute("detailBar"), rowIndexes[index].statusBar.value, rowIndexes[index].statusBar.rawValue, rowIndexes[index].statusBar.levelGood, rowIndexes[index].statusBar.levelWarn)
                    nukeBar = false
                end

                if rowIndexes[index].detailText ~= nil and rowIndexes[index].detailText.title ~= nil and rowIndexes[index].detailText.level ~= nil then
                    self:setDetailText(cell, nukeBar,rowIndexes[index].detailText.title,rowIndexes[index].detailText.level)
                end

                if rowIndexes[index].icon ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIcon")
                    cell:getAttribute("fillIcon"):setImageFilename(rowIndexes[index].icon)
                    cell:getAttribute("fillIcon"):setVisible(true)
                    cell:getAttribute("itemIcon"):setVisible(false)
                elseif rowIndexes[index].iconProfile ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIcon")
                    cell:getAttribute("itemIcon"):applyProfile(rowIndexes[index].iconProfile)
                    cell:getAttribute("itemIcon"):setVisible(true)
                    cell:getAttribute("fillIcon"):setVisible(false)
                elseif rowIndexes[index].iconProduct ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIconProduct")
                    cell:getAttribute("fillIcon"):setImageFilename(rowIndexes[index].iconProduct)
                    cell:getAttribute("fillIcon"):applyProfile("afmMenuVehicleDetailIconNoBar")
                    cell:getAttribute("fillIcon"):setVisible(true)
                    cell:getAttribute("itemIcon"):setVisible(false)
                else
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitle")
                    cell:getAttribute("fillIcon"):setVisible(false)
                    cell:getAttribute("itemIcon"):setVisible(false)
                end

                cell:setVisible(true)
            else
                -- Clear out any cells from previous selection
                cell:setVisible(false)
            end

        else
            -- hide UI, no placeable
            self.placeableIcon:setVisible(false)
            self.placeableDetail:setVisible(false)
            self.afmInfoSubVeh:setVisible(false)
        end
    end
end

function AFMGuiPlaceableFrame:setDetailText(cell, nukeBar, title, level)
    cell:getAttribute("detailBarBG"):setVisible(true)
    cell:getAttribute("detailBar"):setVisible(true)

    if title == "" then
        cell:getAttribute("detailTitle"):setText("")
    else
        cell:getAttribute("detailTitle"):setText(title)
    end

    cell:getAttribute("detailLevel"):setText(level)

    if nukeBar then
        cell:getAttribute("detailLevel"):applyProfile("afmMenuVehicleDetailLevelNoBar")
        cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleNoBar")
        cell:getAttribute("detailBarBG"):setVisible(false)
        cell:getAttribute("detailBar"):setVisible(false)
    end
end

function AFMGuiPlaceableFrame:setStatusBarValue(statusBarElement, value, rawValue, levelGood, levelWarn)
    if levelGood ~= nil and levelWarn ~= nil then
      if rawValue < levelGood then
          statusBarElement:applyProfile("afmMenuVehicleDetailBar")
      elseif rawValue < levelWarn then
          statusBarElement:applyProfile("afmMenuVehicleDetailBarWarning")
      else
          statusBarElement:applyProfile("afmMenuVehicleDetailBarDanger")
      end
    else
        statusBarElement:applyProfile("afmMenuVehicleDetailBar")
    end

    local fullWidth = statusBarElement.parent.absSize[1] - statusBarElement.margin[1] * 2
    local minSize = 0

    if statusBarElement.startSize ~= nil then
        minSize = statusBarElement.startSize[1] + statusBarElement.endSize[1]
    end

    -- Clamp value to 1 (100%) max
    local clampedValue = math.max(0, math.min(1, value))

    statusBarElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function AFMGuiPlaceableFrame:onListSelectionChanged(list, section, index)
    if list == self.placeableList then
        if self.placeables[index] ~= nil and self.placeables[index].vehicle ~= nil then
            local thisPlaceable = self.placeables[index].placeable

            if thisPlaceable ~= nil then

                if index > 0 and thisPlaceable.getImageFilename ~= nil then
                    local imageFilename = thisPlaceable:getImageFilename()
                    self.placeableIcon:setVisible(true)
                    self.placeableIcon:setImageFilename(imageFilename)
                else
                    self.placeableIcon:setVisible(false)
                end

            end
        end
    end

    self:updateMenuButtons()

    if list == self.placeableList then
        if self.placeables[index] ~= nil and self.placeables[index].placeable ~= nil then

            local thisPlaceable = self.placeables[index].placeable

            if thisPlaceable ~= nil then

                if thisPlaceable.getImageFilename ~= nil then
                    local imageFilename = thisPlaceable:getImageFilename()
                    self.placeableIcon:setImageFilename(imageFilename)
                else
                    self.placeableIcon:setVisible(false)
                end

                local centerU, _, centerV = getWorldTranslation(thisPlaceable.rootNode)

                self.itemDetailsMap:setCenterToWorldPosition(centerU, centerV)
                self.itemDetailsMap:setMapZoom(7)
                self.itemDetailsMap:setMapAlpha(1)

                local storeItem = g_storeManager:getItemByXMLFilename(thisPlaceable.configFileName)
                local displayItem = g_shopController:makeDisplayItem(storeItem, thisPlaceable, thisPlaceable.configurations)

                -- Get custom inputs/outputs and insert them into the displayItem for icons display
                displayItem.customInputIconFilenames = {}
                displayItem.customOutputIconFilenames = {}

                -- Check if placeable is a silo then get the allowed fill types
                if thisPlaceable.spec_silo ~= nil and thisPlaceable.spec_silo.loadingStation ~= nil and thisPlaceable.spec_silo.loadingStation.supportedFillTypes ~= nil then
                    for fillTypeIndex, _ in pairs(thisPlaceable.spec_silo.loadingStation.supportedFillTypes) do
                        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                        if fillType ~= nil and fillType.hudOverlayFilename ~= nil then
                            table.insert(displayItem.customInputIconFilenames, fillType.hudOverlayFilename)
                        end
                    end
                end

                -- Get bunker silo accepted fill types
                if thisPlaceable.spec_bunkerSilo ~= nil and thisPlaceable.spec_bunkerSilo.bunkerSilo ~= nil and thisPlaceable.spec_bunkerSilo.bunkerSilo.acceptedFillTypes ~= nil then
                    for fillTypeIndex, _ in pairs(thisPlaceable.spec_bunkerSilo.bunkerSilo.acceptedFillTypes) do
                        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                        if fillType ~= nil and fillType.hudOverlayFilename ~= nil then
                            table.insert(displayItem.customInputIconFilenames, fillType.hudOverlayFilename)
                        end
                    end
                end

                -- Get bunker silo accepted fill types
                if thisPlaceable.spec_bunkerSilo ~= nil and thisPlaceable.spec_bunkerSilo.bunkerSilo ~= nil and thisPlaceable.spec_bunkerSilo.bunkerSilo.outputFillType ~= nil then
                    local fillType = g_fillTypeManager:getFillTypeByIndex(thisPlaceable.spec_bunkerSilo.bunkerSilo.outputFillType)
                    if fillType ~= nil and fillType.hudOverlayFilename ~= nil then
                        table.insert(displayItem.customOutputIconFilenames, fillType.hudOverlayFilename)
                    end
                end

                if displayItem ~= nil and self:getIsVisible() then
                  self:assignItemAttributeData(displayItem)
                end

                self.placeableDetail:reloadData()

            end
        end
    end

    self:updateMenuButtons()

end

function AFMGuiPlaceableFrame:typeString(placeable, noBrace)
    local storeItem = g_storeManager:getItemByXMLFilename(placeable.configFileName)

    local category = g_storeManager:getCategoryByName(storeItem.categoryName)

    local returnText = category.title

    if noBrace == nil or noBrace == false then
        return " [" .. returnText .. "]"
    end

    return returnText
end

function AFMGuiPlaceableFrame:getLocation(placeable)
    if placeable.rootNode == nil then return false end

    local x, _, z   = getWorldTranslation(placeable.rootNode)

    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)
    if farmlandId ~= nil then

        return string.format("F-%03d", farmlandId)
        
    end

    return "--"
end

function AFMGuiPlaceableFrame:getCompassLocation(placeable)
    if placeable.rootNode == nil then return false end

    local wx, _, wz   = getWorldTranslation(placeable.rootNode)

    local thirdTerrainSize = g_currentMission.terrainSize / 6

    if wx == 0 and wz == 0 then
        return "--"
    end

    if math.abs(wx) < thirdTerrainSize and math.abs(wz) < thirdTerrainSize then
        return g_i18n:getText("afm_locate_center")
    end

    if math.abs(wx) < thirdTerrainSize then
        if wz < 1 then
            return g_i18n:getText("afm_locate_n")
        end
        return g_i18n:getText("afm_locate_s")
    end

    if math.abs(wz) < thirdTerrainSize then
        if wx < 1 then
            return g_i18n:getText("afm_locate_w")
        end
        return g_i18n:getText("afm_locate_e")
    end

    if wx < 1 then
        if wz < 1 then
            return(g_i18n:getText("afm_locate_nw"))
        end
        return g_i18n:getText("afm_locate_sw")
    end

    if wz < 1 then
        return g_i18n:getText("afm_locate_ne")
    end

    return g_i18n:getText("afm_locate_se")
end

function AFMGuiPlaceableFrame:onButtonWarpPlaceable()
    local dropHeight    = 1.2
    local thisPlace     = self.placeables[self.placeableList.selectedIndex].placeable
    local foundHotSpot  = nil
    local warpX, warpZ

    if thisPlace.storeItem.categoryName == "FENCES" then 
        return
    end

    if thisPlace.spec_hotspots ~= nil and thisPlace.spec_hotspots.mapHotspots ~= nil then
        for _, mapHotSpot in ipairs(thisPlace.spec_hotspots.mapHotspots) do
            if not foundHotSpot and mapHotSpot.teleportWorldX ~= nil and mapHotSpot.teleportWorldZ ~= nil then
                foundHotSpot = "warpHotSpot"
                warpX        = mapHotSpot.teleportWorldX
                warpZ        = mapHotSpot.teleportWorldZ
            end
        end
    end
    if not foundHotSpot and thisPlace.spec_clearAreas ~= nil and thisPlace.spec_clearAreas.areas ~= nil then
        for _, thisArea in ipairs(thisPlace.spec_clearAreas.areas) do
            if not foundHotSpot and thisArea.start ~= nil then
                foundHotSpot    = "clearArea"
                warpX, _, warpZ = getWorldTranslation(thisArea.start)
            end
        end
    end
    if not foundHotSpot and thisPlace.spec_placement ~= nil and thisPlace.spec_placement.testAreas ~= nil then
        for _, thisArea in ipairs(thisPlace.spec_placement.testAreas) do
            if not foundHotSpot and thisArea.startNode ~= nil then
                foundHotSpot    = "testArea"
                warpX, _, warpZ = getWorldTranslation(thisArea.startNode)
            end
        end
    end
    if not foundHotSpot then
        foundHotSpot    = "fallback"
        warpX, _, warpZ = localToWorld(thisPlace.rootNode, 5, 0, 5)
    end

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... warpToPlaceable: " .. tostring(foundHotSpot) .. " " .. tostring(math.floor(warpX)) ..  " / " .. tostring(math.floor(warpZ)))
    end

    local playerDropHeight = getTerrainHeightAtWorldPos(g_terrainNode, warpX, 0, warpZ) + dropHeight

    g_localPlayer:leaveVehicle()

    if not g_currentMission.controlPlayer and g_currentMission.controlledVehicle ~= nil then
        g_currentMission:onLeaveVehicle(warpX, playerDropHeight, warpZ, false, false)
    else
        g_localPlayer:teleportTo(warpX, playerDropHeight, warpZ, false, false)
    end

    g_gui:showGui("")
end


function AFMGuiPlaceableFrame:onButtonSellPlaceable()
    local thisPlace   = self.placeables[self.placeableList.selectedIndex].placeable
    local sellPrice   = math.floor(thisPlace:getSellPrice())
    local name        = thisPlace:getName()

    if thisPlace.brand ~= nil and thisPlace.brand.title ~= nil and thisPlace.brand.title ~= "None" then
        name = thisPlace.brand.title .. " " .. name
    end

    YesNoDialog.show(
        self.onYesNoSellDialog,
        self,
        string.format(g_i18n:getText("ui_constructionSellConfirmation"), name, g_i18n:formatMoney(sellPrice))
    )
end


function AFMGuiPlaceableFrame:onYesNoSellDialog(yes)
    if yes then
        local thisPlace = self.placeables[self.placeableList.selectedIndex].placeable

        g_client:getServerConnection():sendEvent(SellPlaceableEvent.new(thisPlace, false, false, true))

        self:rebuildTable()
    end
end

function AFMGuiPlaceableFrame:onButtonSellAnimals()
    afmDebug("Sell Animals")

    local thisPlace   = self.placeables[self.placeableList.selectedIndex].placeable
    local animalSellPrice = self:getTotalAnimalValue(thisPlace, true)
    local name        = thisPlace:getName()

    if thisPlace.brand ~= nil and thisPlace.brand.title ~= nil and thisPlace.brand.title ~= "None" then
        name = thisPlace.brand.title .. " " .. name
    end

    YesNoDialog.show(
        self.onYesNoSellAnimalsDialog,
        self,
        string.format(g_i18n:getText("afm_sellAnimalsConfirm"), g_i18n:formatMoney(animalSellPrice))
    )
end


function AFMGuiPlaceableFrame:onYesNoSellAnimalsDialog(yes)
    if yes then
        afmDebug("Sell Animals Confirmed")

        local thisPlace = self.placeables[self.placeableList.selectedIndex].placeable
        local animalSellPrice = self:getTotalAnimalValue(thisPlace, true)
        
        self:sellAllAnimalsInHusbandry(thisPlace)

        MoneyPaymentEvent.sendEvent(thisPlace.ownerFarmId, animalSellPrice, MoneyType.SOLD_ANIMALS)

        self:rebuildTable()
    end
end

function AFMGuiPlaceableFrame:getTotalAnimalValue(thisPlaceable, transportFee)
    local totalValue = 0

    if thisPlaceable.spec_husbandryAnimals ~= nil and thisPlaceable.spec_husbandryAnimals.clusterSystem ~= nil then
        
        local clusters = thisPlaceable.spec_husbandryAnimals.clusterSystem:getClusters()
        if clusters ~= nil then
            for _, cluster in ipairs(clusters) do
                local animalItem = AnimalItemStock.new(cluster)
                local pricePerAnimal = animalItem:getPrice()
                local count = animalItem:getNumAnimals()
                totalValue = totalValue + (pricePerAnimal * count)
            end
        end
    end

    -- Add 500 transport fee if enabled
    if transportFee and totalValue > 500 then
      totalValue = totalValue - 500
    end

    return totalValue
end

function AFMGuiPlaceableFrame:sellAllAnimalsInHusbandry(thisPlaceable)
    afmDebug("AFMGuiPlaceableFrame:sellAllAnimalsInHusbandry")
    
    local clusters = thisPlaceable.spec_husbandryAnimals.clusterSystem:getClusters()
    if clusters == nil then return end

    for _, cluster in ipairs(clusters) do
        local stock   = AnimalItemStock.new(cluster)     -- wrapper used by the shop UI
        local num     = stock:getNumAnimals()            -- how many animals are in the cluster
        if num > 0 then
            local pricePerAnimal = stock:getPrice()      -- positive value (money you get)
            local totalPrice     = pricePerAnimal * num  -- full revenue for the cluster
            local fee            = -stock:getTranportationFee(num) -- negative number = cost

            local clusterId = stock:getClusterId()

            -- make sure the sale is allowed (same test the UI uses)
            local err = AnimalSellEvent.validate(
                            thisPlaceable,     -- which barn
                            clusterId,     -- which cluster
                            num,           -- how many to sell
                            totalPrice,    -- money that changes hands
                            fee)           -- transport fee
            if err == nil then
                -- fire the event → server handles money & animal removal
                g_client:getServerConnection():sendEvent(
                    AnimalSellEvent.new(
                        thisPlaceable,      -- barn
                        clusterId,      -- cluster
                        num,            -- amount
                        totalPrice,     -- price
                        fee))           -- fee
            else
                -- optional: translate error code to a readable text
                local txt = AnimalScreenDealerFarm.SELL_ERROR_CODE_MAPPING[err]
                print(("Could not sell cluster %s – %s"):format(clusterId,
                      txt and g_i18n:getText(txt.text) or tostring(err)))
            end
        end
    end

    self:rebuildTable()
end



function AFMGuiPlaceableFrame:getHotspot()
    local thisPlace     = self.placeables[self.placeableList.selectedIndex].placeable
    local foundHotSpot  = nil

    if thisPlace.spec_hotspots ~= nil and thisPlace.spec_hotspots.mapHotspots ~= nil then
        for _, mapHotSpot in ipairs(thisPlace.spec_hotspots.mapHotspots) do
            if not foundHotSpot and mapHotSpot.teleportWorldX ~= nil and mapHotSpot.teleportWorldZ ~= nil then
                foundHotSpot = mapHotSpot
            end
        end
    end

    return foundHotSpot
end

function AFMGuiPlaceableFrame:onButtonHotspotPlaceable()
    local hotspot     = self:getHotspot()

    if hotspot ~= nil then
        if hotspot == g_currentMission.currentMapTargetHotspot then
            g_currentMission:setMapTargetHotspot()
        else
            g_currentMission:setMapTargetHotspot(hotspot)
        end
    end

    self:rebuildTable()
end


function AFMGuiPlaceableFrame.updateView(self)
    local sortByColumn = self.sortByColumn
    local sortOrder = self.sortOrder

    -- Update sorting icons
    for columnIndex, iconSet in pairs(self.sortIcons) do
        local isCurrentSortColumn = columnIndex == sortByColumn
        local descendingIcon = iconSet[AFMGuiPlaceableFrame.SORT_ORDER_DESC]
        local showDescendingIcon

        if isCurrentSortColumn then
            showDescendingIcon = sortOrder == AFMGuiPlaceableFrame.SORT_ORDER_DESC
        else
            showDescendingIcon = false
        end

        descendingIcon:setVisible(showDescendingIcon)

        local ascendingIcon = iconSet[AFMGuiPlaceableFrame.SORT_ORDER_ASC]
        local showAscendingIcon = isCurrentSortColumn and sortOrder == AFMGuiPlaceableFrame.SORT_ORDER_ASC

        ascendingIcon:setVisible(showAscendingIcon)
    end

    -- Sort the placeable list
    table.sort(self.placeables, function(placeableA, placeableB)
        local valueA = placeableA.columns[sortByColumn].value
        local valueB = placeableB.columns[sortByColumn].value

        if valueA == valueB then
            -- If primary sort values are equal, sort by name
            valueA = placeableA.columns[AFMGuiPlaceableFrame.COLUMN_NAME].value
            valueB = placeableB.columns[AFMGuiPlaceableFrame.COLUMN_NAME].value
            
            -- if valueA == valueB then
            --     -- If names are also equal, sort by a secondary value column
            --     valueA = placeableA.columns[AFMGuiPlaceableFrame.COLUMN_VALUE].value
            --     valueB = placeableB.columns[AFMGuiPlaceableFrame.COLUMN_VALUE].value
            -- end
        end

        if sortOrder == AFMGuiPlaceableFrame.SORT_ORDER_DESC then
            return valueB < valueA -- Descending order
        else
            return valueA < valueB -- Ascending order
        end
    end)

    -- Refresh the placeable list and UI elements
    self.placeableList:reloadData()
    self.placeableDetail:reloadData()
    self:updateMenuButtons()
end


function AFMGuiPlaceableFrame.applySorting(self, column, sortOrder)
    if sortOrder == nil then
        if self.sortByColumn == column and self.sortOrder ~= AFMGuiPlaceableFrame.SORT_ORDER_ASC then
            self.sortOrder = AFMGuiPlaceableFrame.SORT_ORDER_ASC
        else
            self.sortOrder = AFMGuiPlaceableFrame.SORT_ORDER_DESC
        end
    else
        self.sortOrder = sortOrder
    end
    self.sortByColumn = column
    self:updateView()
end

function AFMGuiPlaceableFrame.onClickButtonSortByPlaceables(self)
	  self:applySorting(AFMGuiPlaceableFrame.COLUMN_NAME)
end
function AFMGuiPlaceableFrame.onClickButtonSortByCategory(self)
	  self:applySorting(AFMGuiPlaceableFrame.COLUMN_CATEGORY)
end
function AFMGuiPlaceableFrame.onClickButtonSortByLocation(self)
	  self:applySorting(AFMGuiPlaceableFrame.COLUMN_LOCATION)
end

function AFMGuiPlaceableFrame.onCreateButtonSortByPlaceables(self, button)
    self.sortIcons[AFMGuiPlaceableFrame.COLUMN_NAME] = {
        [AFMGuiPlaceableFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiPlaceableFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiPlaceableFrame.onCreateButtonSortByCategory(self, button)
    self.sortIcons[AFMGuiPlaceableFrame.COLUMN_CATEGORY] = {
        [AFMGuiPlaceableFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiPlaceableFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiPlaceableFrame.onCreateButtonSortByLocation(self, button)
    self.sortIcons[AFMGuiPlaceableFrame.COLUMN_LOCATION] = {
        [AFMGuiPlaceableFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiPlaceableFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiPlaceableFrame.assignItemAttributeData(self, item)
    for idx, clonedElement in pairs(self.clonedElements) do
      clonedElement:delete()
      self.clonedElements[idx] = nil
    end
    for idx2, _ in pairs(self.marqueeBoxes) do
      self.marqueeBoxes[idx2] = nil
    end
    for idx3 = #self.attributesLayout.elements, 1, -1 do
      self:queueDetailsCell(self.attributesLayout.elements[idx3])
    end

    self:assignItemFillTypesData("shopListAttributeIconInput", item.fillTypeIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconInput", item.foodFillTypeIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconInput", item.prodPointInputFillTypeIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconOutput", item.prodPointOutputFillTypeIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconInput", item.sellingStationFillTypesIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconOutput", item.buyingStationFillTypesIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconInput", item.objectStorageFillTypesIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconInput", item.customInputIconFilenames)
    self:assignItemFillTypesData("shopListAttributeIconOutput", item.customOutputIconFilenames)

    self.attributesLayout:invalidateLayout()
end

function AFMGuiPlaceableFrame.assignItemFillTypesData(self, iconProfile, fillTypeIcons)
    if fillTypeIcons ~= nil and #fillTypeIcons > 0 then
        local detailCell = self:dequeueDetailsCell("fillTypesTemplate")
        local mainIcon = detailCell:getDescendantByName("icon")
        local iconsLayout = detailCell:getDescendantByName("iconsLayout")

        mainIcon:applyProfile(iconProfile)

        local totalWidth = 0

        for _, fillTypeIcon in pairs(fillTypeIcons) do
            local clonedIcon = self.fruitIconTemplate:clone(iconsLayout)
            clonedIcon:setVisible(true)

            table.insert(self.clonedElements, clonedIcon)
            clonedIcon:applyProfile("fs25_itemDetailsFruitIcon")
            clonedIcon:setImageFilename(fillTypeIcon)

            totalWidth = totalWidth + clonedIcon.absSize[1] + clonedIcon.margin[1] + clonedIcon.margin[3]
        end

        local maxAllowedWidth = self.attributesLayout.absSize[1] * 0.91
        local finalWidth = math.min(maxAllowedWidth, totalWidth)
        local combinedWidth = finalWidth + mainIcon.absSize[1] + mainIcon.margin[1]

        iconsLayout:setSize(totalWidth, nil)
        iconsLayout:setPosition(0, nil)
        iconsLayout.parent:setSize(finalWidth, nil)
        detailCell:setSize(combinedWidth, nil)
        iconsLayout:invalidateLayout()

        if combinedWidth < totalWidth then
            self.marqueeBoxes[iconsLayout] = 0
            return
        end

        self.marqueeBoxes[iconsLayout] = nil
    end
end


function AFMGuiPlaceableFrame.updateMarqueeAnimation(self, dt)
    for marqueeElement, position in pairs(self.marqueeBoxes) do
        local elementWidth = marqueeElement.absSize[1] -- Width of the marquee element
        local parentWidth = marqueeElement.parent.absSize[1] -- Width of the parent container
        local overflowWidth = elementWidth - parentWidth -- Extra width that needs to scroll
        local scrollSpeed = 5000 * (elementWidth / parentWidth) -- Scrolling speed based on size ratio
        local newPosition = position + dt -- Update position based on time

        if scrollSpeed <= newPosition then
            newPosition = -scrollSpeed -- Reset position if it exceeds the scroll limit
        end

        marqueeElement:setPosition(-(overflowWidth * MathUtil.smoothstep(0.1, 0.9, math.abs(newPosition) / scrollSpeed)))
        self.marqueeBoxes[marqueeElement] = newPosition -- Store updated position
    end
end


function AFMGuiPlaceableFrame.dequeueDetailsCell(self, templateKey)
    if self.detailsTemplates[templateKey] == nil then
        return nil
    end

    local cachedCells = self.detailsCache[templateKey]
    local cell

    if #cachedCells > 0 then
        cell = cachedCells[#cachedCells] -- Retrieve the last cached cell
        cachedCells[#cachedCells] = nil -- Remove it from cache
    else
        cell = self.detailsTemplates[templateKey]:clone() -- Clone a new cell if cache is empty
    end

    self.attributesLayout:addElement(cell)
    return cell
end

function AFMGuiPlaceableFrame.queueDetailsCell(self, cell)
    local cellCache = self.detailsCache[cell.name]
    cellCache[#cellCache + 1] = cell -- Add cell to cache

    local clonesInCache = self.clonesInCache
    table.insert(clonesInCache, cell) -- Keep track of clones

    self.attributesLayout:removeElement(cell)
    cell:unlinkElement()
end

function AFMGuiPlaceableFrame.buildCellDatabase(self)
	for idx, template in pairs(self.detailsTemplates) do
		template:delete()
		self.detailsTemplates[idx] = nil
	end
	self.detailsTemplates = {}
	for idx2 = #self.attributesLayout.elements, 1, -1 do
		local element = self.attributesLayout.elements[idx2]
		local name = element.name
		self.detailsTemplates[name] = element:clone()
		self.detailsCache[name] = {}
	end
end

function AFMGuiPlaceableFrame.onMoneyChange(self)
	if g_localPlayer ~= nil then
		local farm = g_farmManager:getFarmById(afmGetPlayerFarmId())
		if farm.money <= -1 then
			self.currentBalanceText:applyProfile("afm_moneyNeg", nil, true)
		else
			self.currentBalanceText:applyProfile("afm_money", nil, true)
		end
		local moneyText = g_i18n:formatMoney(farm.money, 0, true, true)
		self.currentBalanceText:setText(moneyText)
		if self.moneyBox ~= nil then
			self.moneyBox:invalidateLayout()
			self.moneyBoxBg:setSize(self.moneyBox.flowSizes[1] + 50 * g_pixelSizeScaledX)
		end
	end
end

function AFMGuiPlaceableFrame:rawToPerc(value, invert)
    if not invert then
        return math.ceil((value)*100) .. " %"
    end
    return math.ceil((1 - value)*100) .. " %"
end

function AFMGuiPlaceableFrame:formatPercent(value)
    return math.ceil(value) .. " %"
end

function AFMGuiPlaceableFrame:formatPercentToBar(value)
    return value
end

function AFMGuiPlaceableFrame:formatTime(seconds)
    local days = math.floor(seconds / 86400)  -- 1 day = 86400 seconds
    local hours = math.floor((seconds % 86400) / 3600)  -- 1 hour = 3600 seconds

    -- Generate formatted string
    local timeStr = ""
    if days > 0 then
        local daysString = days == 1 and "ui_day" or "ui_days"
        timeStr = string.format("%dd", days)
    end
    if hours > 0 then
        if timeStr ~= "" then
            timeStr = timeStr .. ", "  -- Add comma if both days and hours exist
        end
        timeStr = timeStr .. " " .. string.format("%dh", hours)
    end

    return timeStr
end

function AFMGuiPlaceableFrame:formatAge(months)
    local years = math.floor(months / 12)
    local remainingMonths = months % 12

    local parts = {}

    if years > 0 then
        table.insert(parts, years .. (years == 1 and " " .. g_i18n:getText("afm_year") or " " .. g_i18n:getText("afm_years")))
    end

    if remainingMonths > 0 or years == 0 then
        table.insert(parts, remainingMonths .. (remainingMonths == 1 and " " .. g_i18n:getText("afm_month") or " " .. g_i18n:getText("afm_months")))
    end

    return table.concat(parts, " ")
end
