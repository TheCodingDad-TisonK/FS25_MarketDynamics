--
-- AdvancedFarmManager - Vehicle Page
--

AFMGuiImplementFrame = {}

local AFMGuiImplementFrame_mt = Class(AFMGuiImplementFrame, TabbedMenuFrameElement)

AFMGuiImplementFrame.COLUMN_NAME = 1
AFMGuiImplementFrame.COLUMN_CATEGORY = 2
AFMGuiImplementFrame.COLUMN_LOCATION = 3
AFMGuiImplementFrame.SORT_ORDER_DESC = 1
AFMGuiImplementFrame.SORT_ORDER_ASC = 2

function AFMGuiImplementFrame:new(l10n)
    local self = TabbedMenuFrameElement.new(nil,AFMGuiImplementFrame_mt)

    self.messageCenter      = g_messageCenter
    self.l10n               = l10n
    self.vehicles           = {}
    self.sortByColumn       = AFMGuiImplementFrame.COLUMN_NAME
	  self.sortOrder          = AFMGuiImplementFrame.SORT_ORDER_ASC
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


function AFMGuiImplementFrame:copyAttributes(src)
    AFMGuiImplementFrame:superClass().copyAttributes(self, src)

    self.ui   = src.ui
    self.l10n = src.l10n
end


function AFMGuiImplementFrame:initialize()
    self.backButtonInfo = {inputAction = InputAction.MENU_BACK}

    self.activateButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = self.l10n:getText("afm_warp_tool"),
        callback    = function ()
            self:onButtonWarpVehicle()
        end
    }
    self.acceptButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_2,
        text        = self.l10n:getText("button_clean"),
        callback    = function ()
            self:onButtonCleanVehicle()
        end
    }
    self.cancelButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_CANCEL,
        text        = self.l10n:getText("button_sell"),
        callback    = function ()
            self:onButtonSellVehicle()
        end
    }
    self.extra1ButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_1,
        text        = self.l10n:getText("button_repair"),
        callback    = function ()
            self:onButtonRepairVehicle()
        end
    }
    self.extra2ButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACCEPT,
        text        = self.l10n:getText("button_repaint"),
        callback    = function ()
            self:onButtonRepaintVehicle()
        end
    }

    self:buildCellDatabase()
end


function AFMGuiImplementFrame:onGuiSetupFinished()
    AFMGuiImplementFrame:superClass().onGuiSetupFinished(self)
    self.vehicleList:setDataSource(self)
    self.vehicleDetail:setDataSource(self)
end


function AFMGuiImplementFrame:delete()
    AFMGuiImplementFrame:superClass().delete(self)
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

function AFMGuiImplementFrame:update(dt)
	AFMGuiImplementFrame:superClass().update(self, dt)
	self:updateMarqueeAnimation(dt)
end

function AFMGuiImplementFrame:updateMenuButtons()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle = nil

    if self.vehicles[selectedIndex] ~= nil and self.vehicles[selectedIndex].vehicle ~= nil then
        thisVehicle   = self.vehicles[selectedIndex].vehicle
    end

    self.menuButtonInfo = {}
    self.menuButtonInfo = {
        {
            inputAction = InputAction.MENU_BACK
        }
    }

    if thisVehicle ~= nil then
        local repairPrice   = self:vehicleRepairPrice(thisVehicle)
        local repaintPrice  = self:vehicleRepaintPrice(thisVehicle)
        local cleanPrice    = self:vehicleCleanCost(thisVehicle)
        local isLeased      = thisVehicle.propertyState == VehiclePropertyState.LEASED
        local isBorrowed    = thisVehicle.propertyState == VehiclePropertyState.MISSION
        local ownerFarmId   = thisVehicle:getOwnerFarmId()
        local playerFarmId  = afmGetPlayerFarmId()
        local canReset      = thisVehicle:getCanBeReset()
        local sellPrice     = self:vehicleSellPrice(thisVehicle)

        table.insert(self.menuButtonInfo, self.activateButtonInfo)

        if g_currentMission:getHasPlayerPermission("farmManager") and not isBorrowed then
            if ownerFarmId == playerFarmId then
                if not isLeased then
                    self.cancelButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("button_sell"),
                        g_i18n:formatMoney(sellPrice, 0, true, true)
                    )
                else
                    self.cancelButtonInfo.text  = g_i18n:getText("button_return")
                end
                table.insert(self.menuButtonInfo, self.cancelButtonInfo)
            end

            if repairPrice >= 1 then
                self.extra1ButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("button_repair"),
                        g_i18n:formatMoney(repairPrice, 0, true, true)
                    )
                table.insert(self.menuButtonInfo, self.extra1ButtonInfo)
            end

            if repaintPrice >= 1 then
                self.extra2ButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("button_repaint"),
                        g_i18n:formatMoney(repaintPrice, 0, true, true)
                    )
                table.insert(self.menuButtonInfo, self.extra2ButtonInfo)
            end

            if cleanPrice >= 1 then
                self.acceptButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("button_clean"),
                        g_i18n:formatMoney(cleanPrice, 0, true, true)
                    )
                table.insert(self.menuButtonInfo, self.acceptButtonInfo)
            end

        end

        table.insert(self.menuButtonInfo, self.parkButtonInfo)
    end

    self:setMenuButtonInfoDirty()
end


function AFMGuiImplementFrame:onFrameOpen()
    self.itemDetailsMap:setIngameMap(g_currentMission.hud:getIngameMap())
    AFMGuiImplementFrame:superClass().onFrameOpen(self)

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiImplementFrame:onFrameOpen")
    end

    self:rebuildTable()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.vehicleList)
    self:setSoundSuppressed(false)

    self:onMoneyChange()

    self.messageCenter:subscribe(MessageType.VEHICLE_REMOVED, self.onRefreshEvent, self) -- update when someone sells a vehicle
    self.messageCenter:subscribe(MessageType.VEHICLE_ADDED, self.onRefreshEvent, self) -- update when someone buys a vehicle
    self.messageCenter:subscribe(MessageType.VEHICLE_REPAIRED, self.onRefreshEvent, self) -- update when vehicle is repaired
    self.messageCenter:subscribe(MessageType.VEHICLE_REPAINTED, self.onRefreshEvent, self) -- update when vehicle is painted
    self.messageCenter:subscribe(MotorSetTurnedOnEvent, self.onRefreshEvent, self) -- Update table when another user starts a vehicle
    self.messageCenter:subscribe(MessageType.MONEY_CHANGED, self.onMoneyChange, self) -- Update anytime there is a money change
end


function AFMGuiImplementFrame:onRefreshEvent()
    self:rebuildTable()
end


function AFMGuiImplementFrame:onFrameClose()
    AFMGuiImplementFrame:superClass().onFrameClose(self)

    self.vehicles = {}
    self.itemDetailsMap:onClose()
    self.messageCenter:unsubscribeAll(self)
end

function AFMGuiImplementFrame:rebuildTable()
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiImplementFrame:rebuildTable")
    end

    self.vehicles = {}

    if g_localPlayer ~= nil and g_currentMission.vehicleSystem.vehicles ~= nil and #g_currentMission.vehicleSystem.vehicles > 0 then
        for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do

            local hasStoreItem     = vehicle.configFileName ~= nil
            local isSelling        = (vehicle.isDeleted ~= nil and vehicle.isDeleted) or (vehicle.isDeleting ~= nil and vehicle.isDeleting)
            local hasAccess        = g_currentMission.accessHandler:canPlayerAccess(vehicle)
            local showVehicle      = vehicle:getShowInVehiclesOverview()
            local isProperty       = vehicle.propertyState == VehiclePropertyState.OWNED or vehicle.propertyState == VehiclePropertyState.LEASED or vehicle.propertyState == VehiclePropertyState.MISSION
            local isPallet         = vehicle.typeName == "pallet" or vehicle.typeName == "treeSaplingPallet" or vehicle.typeName == "bigBag"
            local isTrain          = vehicle.typeName == "locomotive"
            local isBelt           = vehicle.typeName == "conveyorBelt" or vehicle.typeName == "pickupConveyorBelt"
            local isRidable        = SpecializationUtil.hasSpecialization(Rideable, vehicle.specializations)
            local isSteerImplement = vehicle.spec_attachable ~= nil

            local skippable        = isTrain or isBelt or isRidable or isPallet

            if hasStoreItem and not isSelling and not skippable and isSteerImplement and hasAccess and showVehicle and vehicle.getSellPrice ~= nil and vehicle.price ~= nil and isProperty then

                -- Setup Vehicle Sorting Stuff
                local vehicleEntry = {
                  ["vehicle"] = vehicle,
                  ["columns"] = {}
                }
                local vehicleName = vehicle:getFullName()
                vehicleEntry.columns[AFMGuiImplementFrame.COLUMN_NAME] = {
                  ["text"] = vehicleName,
                  ["value"] = vehicleName
                }

                local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
                local getVehicleCategory = g_storeManager:getCategoryByName(storeItem.categoryName)
                local vehicleCategory = getVehicleCategory.title

                vehicleEntry.columns[AFMGuiImplementFrame.COLUMN_CATEGORY] = {
                  ["text"] = vehicleCategory,
                  ["value"] = vehicleCategory
                }

                local vehicleLocation = self:getLocation(vehicle)
                vehicleEntry.columns[AFMGuiImplementFrame.COLUMN_LOCATION] = {
                  ["text"] = vehicleLocation,
                  ["value"] = vehicleLocation
                }

                -- Check to see what all needs loaded
                local rowIndexes = {}
                local curIndex = 0
                local detailText = {}
                local statusBar = {}
                local thisRawAmount = 0
                local icon = nil
                local iconProfile = nil

                -- Check if vehicle is in use
                if (vehicle.getIsControlled ~= nil and vehicle:getIsControlled()) or (vehicle.getIsAIActive and vehicle:getIsAIActive()) then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("afm_occupant"),
                        level   = AFMGuiImplementFrame:vehicleOccupant(vehicle)
                    }
                    iconProfile = "afm_icon_occupant"
                    table.insert(rowIndexes, {item = "controlled", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Check if vehicle has ownership
                if vehicle.propertyState ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_ownership"),
                      level = AFMGuiImplementFrame:vehicleOwnership(vehicle)
                    }
                    iconProfile = "afm_icon_ownership"
                    table.insert(rowIndexes, {item = "ownership", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Output the map compass location
                local vehicleCompassLocation = self:getCompassLocation(vehicle)
                if vehicleCompassLocation ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_location"),
                      level = vehicleCompassLocation
                    }
                    iconProfile = "afm_icon_dirt"
                    table.insert(rowIndexes, {item = "compass", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Load Fuel
                local fuelLevel = self:getFuel(vehicle)
                if fuelLevel[1] ~= false then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText(fuelLevel[1]),
                        level   = AFMGuiImplementFrame:rawToPerc(fuelLevel[2], false)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(fuelLevel[2]), 
                        rawValue    = self:formatPercentToBar(1-fuelLevel[2]), 
                        levelGood   = 0.3, 
                        levelWarn   = 0.6
                    }
                    iconProfile = "afm_icon_" .. fuelLevel[1]
                    table.insert(rowIndexes, {item = "fuel", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
                end

                -- Check if vehicle has def
                local defLevel = self:getDEF(vehicle)
                if defLevel ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText("fillType_def"),
                        level   = AFMGuiImplementFrame:rawToPerc(defLevel, false)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(defLevel), 
                        rawValue    = self:formatPercentToBar(1-defLevel), 
                        levelGood   = 0.3, 
                        levelWarn   = 0.6
                    }
                    iconProfile = "afm_icon_fillType_diesel"
                    table.insert(rowIndexes, {item = "def", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
                end

                -- Load Damage
                curIndex = curIndex + 1
                if vehicle.getDamageAmount ~= nil then
                    thisRawAmount = vehicle:getDamageAmount()
                end
                detailText = {
                    title   = g_i18n:getText("infohud_damage"),
                    level   = AFMGuiImplementFrame:rawToPerc(thisRawAmount, false)
                }
                statusBar = {
                    value       = self:formatPercentToBar(thisRawAmount), 
                    rawValue    = self:formatPercentToBar(thisRawAmount), 
                    levelGood   = 0.1, 
                    levelWarn   = 0.2
                }
                iconProfile = "afm_icon_damage"
                table.insert(rowIndexes, {item = "damage", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})

                -- Load Paint
                curIndex = curIndex + 1
                if vehicle.getWearTotalAmount ~= nil then
                    thisRawAmount = vehicle:getWearTotalAmount()
                end
                detailText = {
                    title   = g_i18n:getText("ui_paintCondition"),
                    level   = AFMGuiImplementFrame:rawToPerc(thisRawAmount, true)
                }
                statusBar = {
                    value       = self:formatPercentToBar(1-thisRawAmount), 
                    rawValue    = self:formatPercentToBar(thisRawAmount), 
                    levelGood   = 0.3, 
                    levelWarn   = 0.6
                }
                iconProfile = "afm_icon_paint"
                table.insert(rowIndexes, {item = "paint", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
                
                -- Load Dirt
                curIndex = curIndex + 1
                if vehicle.getDirtAmount ~= nil then
                    thisRawAmount = vehicle:getDirtAmount()
                end
                detailText = {
                    title   = g_i18n:getText("setting_dirt"),
                    level   = AFMGuiImplementFrame:rawToPerc(thisRawAmount, false)
                }
                statusBar = {
                    value       = self:formatPercentToBar(thisRawAmount), 
                    rawValue    = self:formatPercentToBar(thisRawAmount), 
                    levelGood   = 0.3, 
                    levelWarn   = 0.6
                }
                iconProfile = "afm_icon_dirt"
                table.insert(rowIndexes, {item = "dirt", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})

                -- Load Fill data
                if vehicle.getFillUnits ~= nil then
                    -- Load Vehicle Fills
                    local vehicleFills = vehicle:getFillUnits()
                    if vehicleFills ~= nil then
                        for _, fill in pairs(vehicleFills) do
                            -- Get fill percentage
                            local fillPercentage = 0
                            if fill.fillLevel ~= 0 and fill.capacity ~= 0 then
                              fillPercentage = (fill.fillLevel / fill.capacity) * 100
                            end
                            local normalizedValue = fillPercentage / 100
                            local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fill.fillType)
                            local fillType = g_fillTypeManager:getFillTypeByIndex(fill.fillType)
                            local fillLevel = fill.fillLevel

                            local isFuelFill = fillTypeName == "DIESEL" or fillTypeName == "ELECTRICCHARGE" or fillTypeName == "METHANE" or fillTypeName == "DEF"
                            local isNotNeededFill = fillTypeName == "UNKNOWN" or fillTypeName == "AIR"

                            if not isFuelFill and not isNotNeededFill then

                                curIndex = curIndex + 1
                                detailText = {
                                    title   = fillType.title,
                                    level   = string.format("%sl (%d%%)",math.floor(fillLevel),fillPercentage)
                                }
                                statusBar = {
                                    value       = self:formatPercentToBar(normalizedValue), 
                                    rawValue    = self:formatPercentToBar(normalizedValue)
                                }
                                icon = fillType.hudOverlayFilename
                                table.insert(rowIndexes, {item = "fill1", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, icon = icon})

                            end
                        end
                    end 
                end 

                -- Leasing Costs if leased
                if vehicle.propertyState == VehiclePropertyState.LEASED then
                    local leasingCostText = vehicle.price * (EconomyManager.DEFAULT_RUNNING_LEASING_FACTOR + EconomyManager.PER_DAY_LEASING_FACTOR)
                    if leasingCostText ~= nil and leasingCostText > 0 then
                        curIndex = curIndex + 1
                        detailText = {
                          title = g_i18n:getText("afm_leasingCost"),
                          level = g_i18n:formatMoney(leasingCostText,0,true,true)
                        }
                        iconProfile = "afm_icon_cost"
                        table.insert(rowIndexes, {item = "leasingCost", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                    end
                end

                afmDebug("Vehicle Sell Price")
                -- Sell Value
                if vehicle.propertyState == VehiclePropertyState.OWNED then
                    local sellPriceText = self:vehicleSellPrice(vehicle)
                    if sellPriceText ~= nil and sellPriceText > 0 then
                        curIndex = curIndex + 1
                        detailText = {
                          title = g_i18n:getText("afm_sellValue"),
                          level = g_i18n:formatMoney(sellPriceText,0,true,true)
                        }
                        iconProfile = "afm_icon_cost"
                        table.insert(rowIndexes, {item = "sellValue", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                    end
                end

                afmDebug("Vehicle Age")
                -- Load vehicle age
                curIndex = curIndex + 1
                detailText = {
                    title   = g_i18n:getText("afm_age"),
                    level   = Vehicle.getSpecValueAge(nil, vehicle)
                }
                iconProfile = "afm_icon_time"
                table.insert(rowIndexes, {item = "age", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

                afmDebug("Vehicle Operating Time")
                -- Load operating time
                local operatingTimeText
                if vehicle.getOperatingTime == nil then
                  operatingTimeText = "-"
                else
                  operatingTimeText = Vehicle.getSpecValueOperatingTime(nil, vehicle)
                end
                curIndex = curIndex + 1
                detailText = {
                    title   = g_i18n:getText("afm_operatingHours"),
                    level   = operatingTimeText
                }
                iconProfile = "afm_icon_hours"
                table.insert(rowIndexes, {item = "operatingHours", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

                afmDebug("Vehicle Brand")
                -- Load the brand
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

                afmDebug("Vehicle License Plate")
                -- Load the license plate
                local plateText = LicensePlates.getSpecValuePlateText(nil, vehicle)
                if plateText ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_licensePlate"),
                      level = plateText
                    }
                    iconProfile = "afm_icon_plate"
                    table.insert(rowIndexes, {item = "plate", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end 

                afmDebug("Vehicle Mass")
                -- Load the vehicle mass
                local vehicleMass = vehicle:getTotalMass()
                if vehicleMass ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("infohud_mass"),
                      level = g_i18n:formatMass(vehicleMass)
                    }
                    iconProfile = "afm_icon_weight"
                    table.insert(rowIndexes, {item = "mass", rowIndex = curIndex, detailText = detailText, iconProfile  = iconProfile})
                end 
                
                afmDebug("Working Width")
                -- Get working width
                if storeItem.specs ~= nil and storeItem.specs.workingWidth ~= nil then
                    local workingWidth = Vehicle.getSpecValueWorkingWidth(storeItem)
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("ai_settingImplementWidth"),
                      level = workingWidth
                    }
                    iconProfile = "afm_icon_width"
                    table.insert(rowIndexes, {item = "workingWidth", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                afmDebug("Vehicle Power")
                -- Get Power Requirement
                local powerRequired = self:processStoreItemPowerNeeded(vehicle)
                if powerRequired ~= nil and powerRequired ~= 0 then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_powerRequirement"),
                      level = powerRequired
                    }
                    iconProfile = ""
                    table.insert(rowIndexes, {item = "powerRequirement", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                afmDebug("Vehicle Working Speed")
                -- Get working speed
                local maxWorkingSpeed = self:processStoreItemWorkingSpeed(vehicle)
                if maxWorkingSpeed ~= nil and maxWorkingSpeed > 0 then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_maxWorkingSpeed"),
                      level = string.format(g_i18n:getText(ShopConfigScreen.L10N_SYMBOL.WORKING_SPEED), string.format("%1d", g_i18n:getSpeed(maxWorkingSpeed)), g_i18n:getSpeedMeasuringUnit())
                    }
                    iconProfile = "afm_icon_workingSpeed"
                    table.insert(rowIndexes, {item = "maxWorkingSpeed", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                afmDebug("Vehicle Cruise Speed")
                -- Get max cruise speed
                if vehicle.getCruiseControlMaxSpeed ~= nil then
                    local speedSetting = g_gameSettings:getValue(GameSettings.SETTING.USE_MILES)
                    local kmhUnitText = g_i18n:getText("unit_kmh")
                    local mphUnitText = g_i18n:getText("unit_mph")

                    local speedTypeText = kmhUnitText
                    local speedMulitplier
                    if speedSetting then
                      speedTypeText = mphUnitText
                      speedMulitplier = 0.621371
                    else
                      speedMulitplier = 1
                    end

                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_maxCruise"),
                      level = string.format("%d %s",vehicle:getCruiseControlMaxSpeed() * speedMulitplier, speedTypeText)
                    }
                    iconProfile = "afm_icon_cruiseControl"
                    table.insert(rowIndexes, {item = "maxCruise", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Recursive function to get all attached implements
                local function getAllAttachedImplements(vehicle, implementsList)
                    if vehicle.getAttachedImplements ~= nil then
                        local attachedImplements = vehicle:getAttachedImplements()
                        
                        for _, imp in ipairs(attachedImplements) do
                            if imp.object ~= nil then
                                table.insert(implementsList, imp.object)
                                getAllAttachedImplements(imp.object, implementsList) -- Recursive call
                            end
                        end
                    end
                end

                -- Get all attached implements
                local attachedImplements = {}
                getAllAttachedImplements(vehicle, attachedImplements)

                local toolNumber = 0

                -- Process each attached implement
                for _, implement in ipairs(attachedImplements) do
                    local thisName = implement:getFullName()
                    curIndex = curIndex + 1
                    toolNumber = toolNumber + 1
                    detailText = {
                        title = string.format(g_i18n:getText("afm_tool"), toolNumber),
                        level = thisName
                    }
                    if implement.mapHotspotType ~= nil and implement.mapHotspotType == VehicleHotspot.TYPE.TRAILER then
                        iconProfile = "afm_icon_trailer"
                    else
                        iconProfile = "afm_icon_tool"
                    end
                    table.insert(rowIndexes, { item = "tool" .. toolNumber, rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile })
                    
                    -- Check for fill units
                    if implement.getFillUnits ~= nil then
                        local objectFills = implement:getFillUnits()
                        if objectFills ~= nil then
                            for _, fill in pairs(objectFills) do
                                local fillPercentage = 0
                                if fill.fillLevel ~= 0 and fill.capacity ~= 0 then
                                    fillPercentage = (fill.fillLevel / fill.capacity) * 100
                                end
                                local normalizedValue = fillPercentage / 100
                                local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fill.fillType)
                                local fillType = g_fillTypeManager:getFillTypeByIndex(fill.fillType)
                                local fillLevel = fill.fillLevel
                                
                                local isNotNeededFill = fillTypeName == "UNKNOWN" or fillTypeName == "AIR"
                                
                                if not isNotNeededFill then
                                    curIndex = curIndex + 1
                                    detailText = {
                                        title = fillType.title,
                                        level = string.format("%sl (%d%%)", math.floor(fillLevel), fillPercentage)
                                    }
                                    statusBar = {
                                        value = self:formatPercentToBar(normalizedValue),
                                        rawValue = self:formatPercentToBar(normalizedValue)
                                    }
                                    icon = fillType.hudOverlayFilename
                                    table.insert(rowIndexes, { item = "fill1", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, icon = icon })
                                end
                            end
                        end
                    end
                end


                -- Add all of the rows for vehicle details display
                vehicle.rowIndexes = rowIndexes

                -- Add vehicle to table data
                table.insert(self.vehicles, vehicleEntry)


            end
        end
    end

    if self.vehicles ~= nil and #self.vehicles > 0 then
        self.mainBox:setVisible(true)
        self.itemDetailsMap:setVisible(true)
        self.attributesLayout:setVisible(true)
        self.mainBoxEmpty:setVisible(false)

        self:applySorting(self.sortByColumn, self.sortOrder)

        self.vehicleList:reloadData()
        self.vehicleDetail:reloadData()
    else
        -- Farm does not own any vehicles, so let's hid stuff so it does not look broken.
        self.mainBox:setVisible(false)
        self.itemDetailsMap:setVisible(false)
        self.attributesLayout:setVisible(false)
        -- Show Empty Info
        self.mainBoxEmpty:setVisible(true)
    end
    self:updateView()
end

function AFMGuiImplementFrame:getNumberOfItemsInSection(list, section)
    local selectedIndex = self.vehicleList:getSelectedIndexInSection()

    if list == self.vehicleList and self.vehicles ~= nil then
        return #self.vehicles
    elseif self.vehicles ~= nil and #self.vehicles > 0 and self.vehicles[selectedIndex] ~= nil and self.vehicles[selectedIndex].vehicle ~= nil and self.vehicles[selectedIndex].vehicle.rowIndexes ~= nil then
        -- Total number or rows for vehicle details.
        return #self.vehicles[selectedIndex].vehicle.rowIndexes
    else
        return 0
    end
end

function AFMGuiImplementFrame:populateCellForItemInSection(list, section, index, cell)
    afmDebug("AFMGuiImplementFrame:populateCellForItemInSection")
    if list == self.vehicleList then
        local thisVehicle = self.vehicles[index].vehicle
        local name        = thisVehicle:getFullName()
        local thisColor   = { 1, 1, 1, 1 }

        cell:getAttribute("statusRunning"):setVisible(false)
        cell:getAttribute("statusParked"):setVisible(false)
        cell:getAttribute("statusMine"):setVisible(false)

        if g_currentMission.missionDynamicInfo.isMultiplayer then
            local playerFarmId = afmGetPlayerFarmId()
            if thisVehicle.ownerFarmId == playerFarmId then
                cell:getAttribute("statusMine"):setVisible(true)
            end
        end

        if thisVehicle.getIsMotorStarted ~= nil and thisVehicle:getIsMotorStarted() then
            cell:getAttribute("statusRunning"):setVisible(true)
            thisColor = { 0.159, 0.440, 0.287, 1}
        end

        if thisVehicle.getDamageAmount ~= nil and thisVehicle:getDamageAmount() > 0.12 then
            thisColor = { 0.413, 0.070, 0.078, 1}
        end

        if thisVehicle.propertyState == VehiclePropertyState.MISSION then
            thisColor = { 0.223, 0.503, 0.807, 1 }
        end

        local farm = g_farmManager:getFarmById(thisVehicle.ownerFarmId)
        cell:getAttribute("dotBg").color = { 0.02956, 0.02956, 0.02956, 0.5 }
        cell:getAttribute("dot").color = farm:getColor()

        -- cell:getAttribute("title"):setText(hotkey .. name)
        cell:getAttribute("title"):setText(name)
        cell:getAttribute("title").textColor = thisColor
        cell:getAttribute("type"):setText(self:typeString(thisVehicle, true))

        cell:getAttribute("location"):setText(self:getLocation(thisVehicle))
    else
        local selectedIndex      = self.vehicleList.selectedIndex
        local thisVehicle        = self.vehicles[selectedIndex].vehicle

        if thisVehicle ~= nil then
            self.vehicleIcon:setVisible(true)
            self.vehicleDetail:setVisible(true)
            self.afmInfoSubVeh:setVisible(true)

            local rowIndexes = thisVehicle.rowIndexes

            -- Load up the vehicle details display
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
            -- hide UI, no vehicle
            -- self.miniMapBG:setVisible(false)
            self.vehicleIcon:setVisible(false)
            self.vehicleDetail:setVisible(false)
            self.afmInfoSubVeh:setVisible(false)
        end
    end
end


function AFMGuiImplementFrame:setDetailText(cell, nukeBar, title, level)
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

function AFMGuiImplementFrame:setStatusBarValue(statusBarElement, value, rawValue, levelGood, levelWarn)
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

function AFMGuiImplementFrame:powerString(vehicle, noBrace)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)

    if vehicle.configurations == nil or vehicle.configurations.motor == nil then
        return ""
    end

    local boughtMotor = vehicle.configurations.motor
    local motorPower  = storeItem.configurations.motor[boughtMotor].power

    if motorPower == nil then return "" end

    local hp, _ = g_i18n:getPower(motorPower)

    local returnText = string.format(g_i18n:getText("shop_maxPowerValueSingle"), math.floor(hp))

    if noBrace == nil or noBrace == false then
        return " [" .. returnText .. "]"
    end

    return returnText
end

function AFMGuiImplementFrame:typeString(vehicle, noBrace)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)

    local category = g_storeManager:getCategoryByName(storeItem.categoryName)

    local returnText = category.title

    if noBrace == nil or noBrace == false then
        return " [" .. returnText .. "]"
    end

    return returnText
end

function AFMGuiImplementFrame:rawToPerc(value, invert)
    if not invert then
        return math.ceil((value)*100) .. " %"
    end
    return math.ceil((1 - value)*100) .. " %"
end


function AFMGuiImplementFrame:getDEF(vehicle)
    if vehicle.getConsumerFillUnitIndex ~= nil then
        local defFillUnitIndex = vehicle:getConsumerFillUnitIndex(FillType.DEF)

        if defFillUnitIndex ~= nil then
            local fillLevel = vehicle:getFillUnitFillLevel(defFillUnitIndex)
            local capacity  = vehicle:getFillUnitCapacity(defFillUnitIndex)
            return fillLevel / capacity
        end
    end
    return nil
end

function AFMGuiImplementFrame:getDiesel(vehicle)
    if vehicle.getConsumerFillUnitIndex == nil then
        return false
    end

    local fillIndex = vehicle:getConsumerFillUnitIndex(FillType.DIESEL)

    if fillIndex == nil then
        return false
    end

    local fuelLevel  = vehicle:getFillUnitFillLevel(fillIndex)
    local capacity   = vehicle:getFillUnitCapacity(fillIndex)
    local toFill     = capacity - fuelLevel

    return toFill
end

function AFMGuiImplementFrame:getFuel(vehicle)
    local fuelTypeList = {
        {
            FillType.DIESEL,
            "fillType_diesel",
        }, {
            FillType.ELECTRICCHARGE,
            "fillType_electricCharge",
        }, {
            FillType.METHANE,
            "fillType_methane",
        }
    }
    if vehicle.getConsumerFillUnitIndex ~= nil then
        -- This should always pass, unless it's a very odd custom vehicle type.
        for _, fuelType in pairs(fuelTypeList) do
            local fillUnitIndex = vehicle:getConsumerFillUnitIndex(fuelType[1])
            if ( fillUnitIndex ~= nil ) then
                local fuelLevel  = vehicle:getFillUnitFillLevel(fillUnitIndex)
                local capacity   = vehicle:getFillUnitCapacity(fillUnitIndex)
                local percentage = fuelLevel / capacity
                return { fuelType[2], percentage }
            end
        end
    end
    return { false } -- unknown fuel type, should not be possible.
end

function AFMGuiImplementFrame:vehicleCleanCost(vehicle)
    local thisRawAmount = 0
    if vehicle.getDirtAmount ~= nil then
        thisRawAmount = vehicle:getDirtAmount()
    end

    if thisRawAmount == 0 then
        return 0
    elseif thisRawAmount < 0.25 then
        return 150
    elseif thisRawAmount < 0.5 then
        return 250
    elseif thisRawAmount > 0.9 then
        return 500
    else
        return 400
    end
end

function AFMGuiImplementFrame:vehicleRepairPrice(vehicle)
    local wearableSpec = vehicle.spec_wearable
    if wearableSpec ~= nil then
        local thisRawAmount = 0
        if vehicle.getRepairPrice ~= nil then
            thisRawAmount = vehicle:getRepairPrice()
        end

        if thisRawAmount == 0 then
            return 0
        else
            return thisRawAmount * self.costFactor
        end
    else
        return 0
    end
end

function AFMGuiImplementFrame:vehicleRepaintPrice(vehicle)
    local thisRawAmount = 0
    if vehicle.getRepaintPrice ~= nil then
        thisRawAmount = vehicle:getRepaintPrice()
    end

    if thisRawAmount == 0 then
        return 0
    else
        return thisRawAmount * self.costFactor
    end
end

function AFMGuiImplementFrame:vehicleSellPrice(vehicle)
    local thisRawAmount = 0
    if vehicle.getSellPrice ~= nil then
        thisRawAmount = vehicle:getSellPrice()
    end

    if thisRawAmount == 0 then
        return 0
    else
        return thisRawAmount
    end
end

function AFMGuiImplementFrame:vehicleRunning(vehicle)
    if vehicle.getIsMotorStarted ~= nil and vehicle:getIsMotorStarted() then
        return g_i18n:getText("ui_yes")
    end

    return g_i18n:getText("ui_no")
end


function AFMGuiImplementFrame:vehicleParked(vehicle)
    if vehicle.getIsTabbable ~= nil and ( not vehicle:getIsTabbable() ) then
        return g_i18n:getText("ui_yes")
    end

    return g_i18n:getText("ui_no")
end


function AFMGuiImplementFrame:vehicleOccupant(vehicle)
    if vehicle.getIsControlled ~= nil and vehicle:getIsControlled() then
        if vehicle.getControllerName ~= nil then
            return vehicle:getControllerName()
        else
            return g_i18n:getText("afm_you")
        end
    end

    if vehicle.getIsAIActive ~= nil and vehicle:getIsAIActive() then
        if vehicle.ad ~= nil and vehicle.ad.stateModule ~= nil and vehicle.ad.stateModule:isActive() then
            return g_i18n:getText("afm_con_ad")
        elseif vehicle.getCpStatus ~= nil then
            local cpStatus = vehicle:getCpStatus()
            if cpStatus:getIsActive() then
                return g_i18n:getText("afm_con_cp")
            end
        else
            return g_i18n:getText("afm_con_ai")
        end
    end

    return g_i18n:getText("ui_none")
end

function AFMGuiImplementFrame:vehicleOwnership(vehicle)
    if vehicle.propertyState == VehiclePropertyState.OWNED then
        return g_i18n:getText("afm_owned")
    end
    if vehicle.propertyState == VehiclePropertyState.LEASED then
        return g_i18n:getText("afm_leased")
    end
    if vehicle.propertyState == VehiclePropertyState.MISSION then
        return g_i18n:getText("afm_mission")
    end
    return g_i18n:getText("ui_none")
end

function AFMGuiImplementFrame:onListSelectionChanged(list, section, index)
    if list == self.vehicleList then
        if self.vehicles[index] ~= nil and self.vehicles[index].vehicle ~= nil then

            local thisVehicle = self.vehicles[index].vehicle

            if thisVehicle ~= nil then

                local storeItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

                self.vehicleIcon:setImageFilename(storeItem.imageFilename)

                local vehicleInfoExtra = {}

                if g_currentMission.missionDynamicInfo.isMultiplayer then
                    local thisFarmID   = thisVehicle.ownerFarmId
                    local thisFarm     = g_farmManager:getFarmById(thisFarmID)
                    local thisFarmName = thisFarm.name
                    if thisFarmName ~= nil then
                        table.insert(vehicleInfoExtra, thisFarmName)
                    end
                end

                local powerString = self:powerString(thisVehicle, true)

                if powerString ~= "" then
                    table.insert(vehicleInfoExtra, powerString)
                end
                if thisVehicle.propertyState == VehiclePropertyState.MISSION then
                    table.insert(vehicleInfoExtra, g_i18n:getText("fieldJob_contract"))
                end
                if thisVehicle.propertyState == VehiclePropertyState.LEASED then
                    table.insert(vehicleInfoExtra, g_i18n:getText("button_lease"))
                end
                if thisVehicle.getIsMotorStarted ~= nil and thisVehicle:getIsMotorStarted() then
                    table.insert(vehicleInfoExtra, g_i18n:getText("ui_production_status_running"))
                end
                if thisVehicle.getHKParkVehicleState ~= nil and thisVehicle:getHKParkVehicleState() then
                    table.insert(vehicleInfoExtra, g_i18n:getText("afm_parked"))
                end


                self.afmInfoSubVeh:setText(table.concat(vehicleInfoExtra, ", "))

                local centerU, _, centerV = getWorldTranslation(thisVehicle.rootNode)

                self.itemDetailsMap:setCenterToWorldPosition(centerU, centerV)
                self.itemDetailsMap:setMapZoom(7)
                self.itemDetailsMap:setMapAlpha(1)

                local displayItem = g_shopController:makeDisplayItem(storeItem, thisVehicle, thisVehicle.configurations)

                if displayItem ~= nil and self:getIsVisible() then
                  self:assignItemAttributeData(displayItem)
                end

                self.vehicleDetail:reloadData()

            end
        end
    end

    self:updateMenuButtons()
end

function AFMGuiImplementFrame:getLocation(vehicle)
    if vehicle.components == nil and vehicle.components[1].node then return false end

    local wx, _, wz = localToWorld(vehicle.components[1].node, getCenterOfMass(vehicle.components[1].node))

    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(wx, wz)
    if farmlandId ~= nil then

        return string.format("F-%03d", farmlandId)
        
    end

    return "--"
end

function AFMGuiImplementFrame:getCompassLocation(vehicle)
    -- Ensure valid vehicle and node
    if vehicle.components == nil and vehicle.components[1].node then return false end

    -- Get vehicle world position from center of mass
    local wx, _, wz = localToWorld(vehicle.components[1].node, getCenterOfMass(vehicle.components[1].node))

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

function AFMGuiImplementFrame:onButtonParkVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle

    thisVehicle:setHKParkVehicleState(not thisVehicle:getHKParkVehicleState())

    self:rebuildTable()
end


function AFMGuiImplementFrame:onButtonWarpVehicle()
    local dropHeight    = 1.2
    local period        = g_currentMission.environment.currentPeriod
    local dayOfMonth    = g_currentMission.environment.currentDayInPeriod
    local isSouthern    = g_currentMission.environment.daylight.latitude < 0
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle

    if thisVehicle.rootNode == nil then
        return
    end

    local maxSize       = math.max(thisVehicle.size.length, thisVehicle.size.width)
    local offset        = (maxSize / 2) + 1
    local wx, _, wz     = getWorldTranslation(thisVehicle.rootNode)

    local month = period + 2

    if isSouthern then
        month = month + 6
    end

    month = (month - 1) % 12 + 1

    if month == 4 and dayOfMonth == 1 then
        dropHeight = 250
    end

    local playerDropHeight = getTerrainHeightAtWorldPos(g_terrainNode, wx, 0, wz) + dropHeight

    g_localPlayer:leaveVehicle()

    if not g_currentMission.controlPlayer and g_currentMission.controlledVehicle ~= nil then
        g_currentMission:onLeaveVehicle(wx - offset, playerDropHeight, wz - offset, false, false)
    else
        g_localPlayer:teleportTo(wx - offset, playerDropHeight, wz - offset, false, false)
    end

    g_gui:showGui("")
end

function AFMGuiImplementFrame:onButtonSellVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    if thisVehicle ~= nil then
      local storeItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)
      g_shopController:sell(storeItem, thisVehicle)
    end
end

function AFMGuiImplementFrame:onYesNoSellDialog(yes)
    if yes then
        local selectedIndex = self.vehicleList.selectedIndex
        local thisVehicle   = self.vehicles[selectedIndex].vehicle

        g_client:getServerConnection():sendEvent(SellVehicleEvent.new(thisVehicle, EconomyManager.DIRECT_SELL_MULTIPLIER, true))
    end
end

function AFMGuiImplementFrame:onButtonRepairVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local thisCost      = self:vehicleRepairPrice(thisVehicle)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    if thisVehicle ~= nil and self:vehicleRepairPrice(thisVehicle) >= 1 then

        -- Display confirmation dialog for item action
        ActionItemDialog:show(
            self.onYesNoRepairDialog,
            self,
            thisVehicle,
            thisCost,
            thisStoreItem,
            nil,
            g_i18n:getText("afm_repairDialog"),
            GuiSoundPlayer.SOUND_SAMPLES.CONFIG_WRENCH
        )

        return true
    else
        return false
    end
end

function AFMGuiImplementFrame:onYesNoRepairDialog(yes)
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local price         = self:vehicleRepairPrice(thisVehicle)
    local farmId        = thisVehicle:getActiveFarm()

    if yes then
        if g_currentMission:getMoney() < price then
            InfoDialog.show(g_i18n:getText("shop_messageNotEnoughMoneyToBuy"), nil, nil, DialogElement.TYPE_WARNING)
        else
            MoneyPaymentEvent.sendEvent(farmId, price, MoneyType.VEHICLE_REPAIR)
            RepairVehicleEvent.sendEvent(thisVehicle)
        end
    end
end

function AFMGuiImplementFrame:onButtonRepaintVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local thisCost = self:vehicleRepaintPrice(thisVehicle)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    if thisVehicle ~= nil and self:vehicleRepaintPrice(thisVehicle) >= 1 then

        -- Display confirmation dialog for item action
        ActionItemDialog:show(
            self.onYesNoRepaintDialog,
            self,
            thisVehicle,
            thisCost,
            thisStoreItem,
            nil,
            g_i18n:getText("afm_paintDialog"),
            GuiSoundPlayer.SOUND_SAMPLES.CONFIG_SPRAY
        )

        return true
    else
        return false
    end
end

function AFMGuiImplementFrame:onYesNoRepaintDialog(yes)
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local price         = self:vehicleRepaintPrice(thisVehicle)
    local farmId        = thisVehicle:getActiveFarm()

    if yes then
        if g_currentMission:getMoney() < price then
            InfoDialog.show(g_i18n:getText("shop_messageNotEnoughMoneyToBuy"), nil, nil, DialogElement.TYPE_WARNING)
        else
            MoneyPaymentEvent.sendEvent(farmId, price, MoneyType.VEHICLE_REPAIR)
            RepaintVehicleEvent.sendEvent(thisVehicle)
        end
    end
end

function AFMGuiImplementFrame:onButtonCleanVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local thisCost      = self:vehicleCleanCost(thisVehicle)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    if thisVehicle ~= nil and thisCost >= 1 then

        -- Display confirmation dialog for item action
        ActionItemDialog:show(
            self.onYesNoCleanDialog,
            self,
            thisVehicle,
            thisCost,
            thisStoreItem,
            nil,
            g_i18n:getText("afm_cleanDialog"),
            GuiSoundPlayer.SOUND_SAMPLES.CONFIG_SPRAY
        )

        return true
    else
        return false
    end
end

function AFMGuiImplementFrame:onYesNoCleanDialog(yes)
    if yes then
        local selectedIndex = self.vehicleList.selectedIndex
        local thisVehicle   = self.vehicles[selectedIndex].vehicle
        local farmId        = thisVehicle:getActiveFarm()
        local price         = self:vehicleCleanCost(thisVehicle)

        if g_currentMission:getMoney() < price then
            InfoDialog.show(g_i18n:getText("shop_messageNotEnoughMoneyToBuy"), nil, nil, DialogElement.TYPE_WARNING)
        else
            MoneyPaymentEvent.sendEvent(farmId, price, MoneyType.VEHICLE_REPAIR)
            WashVehicleEvent.sendEvent(thisVehicle)
        end
    end
end

function AFMGuiImplementFrame.updateView(self)
    local sortByColumn = self.sortByColumn
    local sortOrder = self.sortOrder

    -- Update sorting icons
    for columnIndex, iconSet in pairs(self.sortIcons) do
        local isCurrentSortColumn = columnIndex == sortByColumn
        local descendingIcon = iconSet[AFMGuiImplementFrame.SORT_ORDER_DESC]
        local showDescendingIcon

        if isCurrentSortColumn then
            showDescendingIcon = sortOrder == AFMGuiImplementFrame.SORT_ORDER_DESC
        else
            showDescendingIcon = false
        end

        descendingIcon:setVisible(showDescendingIcon)

        local ascendingIcon = iconSet[AFMGuiImplementFrame.SORT_ORDER_ASC]
        local showAscendingIcon = isCurrentSortColumn and sortOrder == AFMGuiImplementFrame.SORT_ORDER_ASC

        ascendingIcon:setVisible(showAscendingIcon)
    end

    -- Sort the vehicle list
    table.sort(self.vehicles, function(vehicleA, vehicleB)
        local valueA = vehicleA.columns[sortByColumn].value
        local valueB = vehicleB.columns[sortByColumn].value

        if valueA == valueB then
            -- If primary sort values are equal, sort by name
            valueA = vehicleA.columns[AFMGuiImplementFrame.COLUMN_NAME].value
            valueB = vehicleB.columns[AFMGuiImplementFrame.COLUMN_NAME].value
            
            -- if valueA == valueB then
            --     -- If names are also equal, sort by a secondary value column
            --     valueA = vehicleA.columns[AFMGuiImplementFrame.COLUMN_VALUE].value
            --     valueB = vehicleB.columns[AFMGuiImplementFrame.COLUMN_VALUE].value
            -- end
        end

        if sortOrder == AFMGuiImplementFrame.SORT_ORDER_DESC then
            return valueB < valueA -- Descending order
        else
            return valueA < valueB -- Ascending order
        end
    end)

    -- Refresh the vehicle list and UI elements
    self.vehicleList:reloadData()
    self.vehicleDetail:reloadData()
    self:updateMenuButtons()
end


function AFMGuiImplementFrame.applySorting(self, column, sortOrder)
    if sortOrder == nil then
        if self.sortByColumn == column and self.sortOrder ~= AFMGuiImplementFrame.SORT_ORDER_ASC then
            self.sortOrder = AFMGuiImplementFrame.SORT_ORDER_ASC
        else
            self.sortOrder = AFMGuiImplementFrame.SORT_ORDER_DESC
        end
    else
        self.sortOrder = sortOrder
    end
    self.sortByColumn = column
    self:updateView()
end

function AFMGuiImplementFrame.onClickButtonSortByVehicles(self)
	  self:applySorting(AFMGuiImplementFrame.COLUMN_NAME)
end
function AFMGuiImplementFrame.onClickButtonSortByCategory(self)
	  self:applySorting(AFMGuiImplementFrame.COLUMN_CATEGORY)
end
function AFMGuiImplementFrame.onClickButtonSortByLocation(self)
	  self:applySorting(AFMGuiImplementFrame.COLUMN_LOCATION)
end

function AFMGuiImplementFrame.onCreateButtonSortByVehicles(self, button)
    self.sortIcons[AFMGuiImplementFrame.COLUMN_NAME] = {
        [AFMGuiImplementFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiImplementFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiImplementFrame.onCreateButtonSortByCategory(self, button)
    self.sortIcons[AFMGuiImplementFrame.COLUMN_CATEGORY] = {
        [AFMGuiImplementFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiImplementFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiImplementFrame.onCreateButtonSortByLocation(self, button)
    self.sortIcons[AFMGuiImplementFrame.COLUMN_LOCATION] = {
        [AFMGuiImplementFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiImplementFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiImplementFrame.assignItemAttributeData(self, item)
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
	self:assignItemFillTypesData("shopListAttributeIconFillTypes", item.fillTypeIconFilenames)
	self:assignItemFillTypesData("shopListAttributeIconFillTypes", item.foodFillTypeIconFilenames)
	self:assignItemFillTypesData("shopListAttributeIconSeeds", item.seedTypeIconFilenames)
	self.attributesLayout:invalidateLayout()
end

function AFMGuiImplementFrame.assignItemFillTypesData(self, iconProfile, fillTypeIcons)
    if #fillTypeIcons > 0 then
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
        iconsLayout:invalidateLayout()

        if combinedWidth < totalWidth then
            self.marqueeBoxes[iconsLayout] = 0
            return
        end

        self.marqueeBoxes[iconsLayout] = nil
    end
end


function AFMGuiImplementFrame.updateMarqueeAnimation(self, dt)
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


function AFMGuiImplementFrame.dequeueDetailsCell(self, templateKey)
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

function AFMGuiImplementFrame.queueDetailsCell(self, cell)
    local cellCache = self.detailsCache[cell.name]
    cellCache[#cellCache + 1] = cell -- Add cell to cache

    local clonesInCache = self.clonesInCache
    table.insert(clonesInCache, cell) -- Keep track of clones

    self.attributesLayout:removeElement(cell)
    cell:unlinkElement()
end

function AFMGuiImplementFrame.buildCellDatabase(self)
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

function AFMGuiImplementFrame:processStoreItemWorkingSpeed(vehicle)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
    return (storeItem.specs == nil or storeItem.specs.speedLimit == nil) and 0 or storeItem.specs.speedLimit
end

function AFMGuiImplementFrame:processStoreItemPowerNeeded(vehicle)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
    if storeItem.specs ~= nil and storeItem.specs.neededPower ~= nil and storeItem.specs.neededPower.config ~= nil then

        if storeItem.specs.neededPower == nil then
            return nil
        end

        local minPower = math.huge
        local maxPower = -math.huge

        -- Find the min and max power requirements
        for _, power in pairs(storeItem.specs.neededPower.config) do
            minPower = math.min(minPower, power)
            maxPower = math.max(maxPower, power)
        end

        -- If no valid power values found, fall back to base values
        if minPower == math.huge then
            minPower = storeItem.specs.neededPower.base or 0
            maxPower = storeItem.specs.neededPower.maxPower
        end

        -- If minimum power is 0, no power requirement exists
        if minPower == 0 then
            return nil
        end

        -- If min and max power are the same, display a single value
        if maxPower == nil or minPower == maxPower then
            local powerHP, powerKW = g_i18n:getPower(minPower)

            return string.format(g_i18n:getText("shop_neededPowerValue"), MathUtil.round(powerKW), MathUtil.round(powerHP))
        end

        -- Display power range if min and max differ
        local minPowerHP, _ = g_i18n:getPower(minPower)
        local maxPowerHP, _ = g_i18n:getPower(maxPower)

        return string.format(g_i18n:getText("shop_neededPowerValueMinMax"), MathUtil.round(minPowerHP), MathUtil.round(maxPowerHP))

    end

end

function AFMGuiImplementFrame.onMoneyChange(self)
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
  self:rebuildTable()
end

function AFMGuiImplementFrame:formatPercentToBar(value)
    return value
end

