--
-- AdvancedFarmManager - Vehicle Page
--

AFMGuiVehicleFrame = {}

local AFMGuiVehicleFrame_mt = Class(AFMGuiVehicleFrame, TabbedMenuFrameElement)

AFMGuiVehicleFrame.COLUMN_NAME = 1
AFMGuiVehicleFrame.COLUMN_CATEGORY = 2
AFMGuiVehicleFrame.COLUMN_LOCATION = 3
AFMGuiVehicleFrame.SORT_ORDER_DESC = 1
AFMGuiVehicleFrame.SORT_ORDER_ASC = 2

function AFMGuiVehicleFrame:new(l10n)
    local self = TabbedMenuFrameElement.new(nil,AFMGuiVehicleFrame_mt)

    self.messageCenter      = g_messageCenter
    self.l10n               = l10n
    self.vehicles           = {}
    self.sortByColumn       = AFMGuiVehicleFrame.COLUMN_NAME
	  self.sortOrder          = AFMGuiVehicleFrame.SORT_ORDER_ASC
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


function AFMGuiVehicleFrame:copyAttributes(src)
    AFMGuiVehicleFrame:superClass().copyAttributes(self, src)

    self.ui   = src.ui
    self.l10n = src.l10n
end


function AFMGuiVehicleFrame:initialize()
    afmDebug("AFMGuiVehicleFrame:initialize")
    self.backButtonInfo = {inputAction = InputAction.MENU_BACK}

    self.activateButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = self.l10n:getText("button_enterVehicle"),
        callback    = function ()
            self:onButtonEnterVehicle()
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
    self.parkButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.TOGGLE_STORE,
        text        = self.l10n:getText("afm_park"),
        callback    = function ()
            self:onButtonParkVehicle()
        end
    }
    self.renameButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.ACTIVATE_OBJECT,
        text        = self.l10n:getText("button_rename"),
        callback    = function ()
            self:onButtonRenameVehicle()
        end
    }
    self.refuelButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.TOGGLE_PIPE,
        text        = self.l10n:getText("action_refuel"),
        callback    = function ()
            self:onButtonRefuelVehicle()
        end
    }
    self:buildCellDatabase()
end


function AFMGuiVehicleFrame:onGuiSetupFinished()
    AFMGuiVehicleFrame:superClass().onGuiSetupFinished(self)
    self.vehicleList:setDataSource(self)
    self.vehicleDetail:setDataSource(self)
end


function AFMGuiVehicleFrame:delete()
    AFMGuiVehicleFrame:superClass().delete(self)
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

function AFMGuiVehicleFrame:update(dt)
	AFMGuiVehicleFrame:superClass().update(self, dt)
	self:updateMarqueeAnimation(dt)
end

function AFMGuiVehicleFrame:updateMenuButtons()
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
        local isParked      = thisVehicle:getHKParkVehicleState()
        local cleanPrice    = self:vehicleCleanCost(thisVehicle)
        local isLeased      = thisVehicle.propertyState == VehiclePropertyState.LEASED
        local isBorrowed    = thisVehicle.propertyState == VehiclePropertyState.MISSION
        local needsDiesel   = self:getDiesel(thisVehicle)
        local dieselCost    = self:getDieselCost(needsDiesel)
        local needsDEF      = self:getDEF(thisVehicle)
        local defCost       = self:getDEFCost(needsDEF)
        local needsMethane  = self:getMethane(thisVehicle)
        local methaneCost   = self:getMethaneCost(needsMethane)
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

            local totalFuelCost = 0
            if dieselCost > 0 then 
              totalFuelCost = totalFuelCost + dieselCost
            end
            if defCost > 0 then
              totalFuelCost = totalFuelCost + defCost
            end
            if methaneCost > 0 then
              totalFuelCost = totalFuelCost + methaneCost
            end
            if (totalFuelCost > 1) then
                self.refuelButtonInfo.text = string.format(
                        "%s (%s)",
                        g_i18n:getText("afm_refuel"),
                        g_i18n:formatMoney(totalFuelCost, 0, true, true)
                    )
                table.insert(self.menuButtonInfo, self.refuelButtonInfo)
            end

            -- Hide in mp
            if ownerFarmId == playerFarmId and not self.isMPGame then
              table.insert(self.menuButtonInfo, self.renameButtonInfo)
            end

        end

        if isParked then
            self.parkButtonInfo.text = g_i18n:getText("afm_unpark")
        else
            self.parkButtonInfo.text = g_i18n:getText("afm_park")
        end

        table.insert(self.menuButtonInfo, self.parkButtonInfo)
    end

    self:setMenuButtonInfoDirty()
end


function AFMGuiVehicleFrame:onFrameOpen()
    self.itemDetailsMap:setIngameMap(g_currentMission.hud:getIngameMap())
    AFMGuiVehicleFrame:superClass().onFrameOpen(self)

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiVehicleFrame:onFrameOpen")
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
    self.messageCenter:subscribe(SetHotKeyNickNameEvent, self.onRefreshEvent, self) -- Update when hot key nick name is set
    self.messageCenter:subscribe(MotorSetTurnedOnEvent, self.onRefreshEvent, self) -- Update table when another user starts a vehicle
    self.messageCenter:subscribe(MessageType.MONEY_CHANGED, self.onMoneyChange, self) -- Update anytime there is a money change
end


function AFMGuiVehicleFrame:onRefreshEvent()
    self:rebuildTable()
end


function AFMGuiVehicleFrame:onFrameClose()
    AFMGuiVehicleFrame:superClass().onFrameClose(self)

    self.vehicles = {}
    self.itemDetailsMap:onClose()
    self.messageCenter:unsubscribeAll(self)
end

function AFMGuiVehicleFrame:rebuildTable()
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiVehicleFrame:rebuildTable")
    end

    self.vehicles = {}

    afmDebug(string.format("Rebuild Table - Vehicles: %d", #g_currentMission.vehicleSystem.vehicles)) 

    if g_localPlayer ~= nil and g_currentMission.vehicleSystem.vehicles ~= nil and #g_currentMission.vehicleSystem.vehicles > 0 then
        for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do

            local hasStoreItem     = vehicle.configFileName ~= nil
            local isSelling        = (vehicle.isDeleted ~= nil and vehicle.isDeleted) or (vehicle.isDeleting ~= nil and vehicle.isDeleting)
            local hasAccess        = g_currentMission.accessHandler:canPlayerAccess(vehicle)
            local showVehicle      = vehicle:getShowInVehiclesOverview()
            local hasConned        = vehicle.getIsControlled ~= nil
            local isProperty       = vehicle.propertyState == VehiclePropertyState.OWNED or vehicle.propertyState == VehiclePropertyState.LEASED or vehicle.propertyState == VehiclePropertyState.MISSION
            local isPallet         = vehicle.typeName == "pallet"  or vehicle.typeName == "treeSaplingPallet" or vehicle.typeName == "bigBag"
            local isTrain          = vehicle.typeName == "locomotive"
            local isBelt           = vehicle.typeName == "conveyorBelt" or vehicle.typeName == "pickupConveyorBelt"
            local isRidable        = SpecializationUtil.hasSpecialization(Rideable, vehicle.specializations)
            local isSteerImplement = vehicle.spec_attachable ~= nil

            local skippable        = isTrain or isBelt or isRidable or isSteerImplement or isPallet

            if hasStoreItem and not isSelling and not skippable and hasConned and hasAccess and showVehicle and vehicle.getSellPrice ~= nil and vehicle.price ~= nil and isProperty then

                -- Setup Vehicle Sorting Stuff
                local vehicleEntry = {
                  ["vehicle"] = vehicle,
                  ["columns"] = {}
                }
                local vehicleName = vehicle:getFullName()
                vehicleEntry.columns[AFMGuiVehicleFrame.COLUMN_NAME] = {
                  ["text"] = vehicleName,
                  ["value"] = vehicleName
                }

                local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
                local getVehicleCategory = g_storeManager:getCategoryByName(storeItem.categoryName)
                local vehicleCategory = getVehicleCategory.title
                vehicleEntry.columns[AFMGuiVehicleFrame.COLUMN_CATEGORY] = {
                  ["text"] = vehicleCategory,
                  ["value"] = vehicleCategory
                }

                local vehicleLocation = self:getLocation(vehicle)
                vehicleEntry.columns[AFMGuiVehicleFrame.COLUMN_LOCATION] = {
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
                        level   = self:vehicleOccupant(vehicle)
                    }
                    iconProfile = "afm_icon_occupant"
                    table.insert(rowIndexes, {item = "controlled", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

                -- Check if vehicle has ownership
                if vehicle.propertyState ~= nil then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_ownership"),
                      level = self:vehicleOwnership(vehicle)
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
                        level   = self:rawToPerc(fuelLevel[2], false)
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
                local defLevel = self:getFuelDEF(vehicle)

                if defLevel[1] ~= false then
                    curIndex = curIndex + 1
                    detailText = {
                        title   = g_i18n:getText(defLevel[1]),
                        level   = self:rawToPerc(defLevel[2], false)
                    }
                    statusBar = {
                        value       = self:formatPercentToBar(defLevel[2]), 
                        rawValue    = self:formatPercentToBar(1-defLevel[2]), 
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
                    level   = self:rawToPerc(thisRawAmount, false)
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
                    level   = self:rawToPerc(thisRawAmount, true)
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
                    level   = self:rawToPerc(thisRawAmount, false)
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

                -- Load vehicle age
                curIndex = curIndex + 1
                detailText = {
                    title   = g_i18n:getText("afm_age"),
                    level   = Vehicle.getSpecValueAge(nil, vehicle)
                }
                iconProfile = "afm_icon_time"
                table.insert(rowIndexes, {item = "age", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

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

                -- Load the vehicle power
                if storeItem.configurations ~= nil or storeItem.configurations.motor ~= nil then
                    local boughtMotor = storeItem.configurations.motor
                    if storeItem.configurations ~= nil and storeItem.configurations.motor[boughtMotor] ~= nil and storeItem.configurations.motor[boughtMotor].power ~= nil then
                        local motorPower  = storeItem.configurations.motor[boughtMotor].power
                        if motorPower ~= nil then
                            curIndex = curIndex + 1
                            detailText = {
                              title = g_i18n:getText("afm_power"),
                              level = self:powerString(vehicle, true)
                            }
                            iconProfile = "afm_icon_power"
                            table.insert(rowIndexes, {item = "power", rowIndex = curIndex, detailText = detailText, iconProfile  = iconProfile})
                        end
                    end
                end

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

                -- Get Power Requirement
                local powerRequired = self:processStoreItemPowerNeeded(vehicle)
                if powerRequired ~= nil and powerRequired > 0 then
                    curIndex = curIndex + 1
                    detailText = {
                      title = g_i18n:getText("afm_powerRequirement"),
                      level = powerRequired
                    }
                    iconProfile = ""
                    table.insert(rowIndexes, {item = "powerRequirement", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                end

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
        -- Farm does not own any vehicles, so let's hide stuff so it does not look broken.
        self.mainBox:setVisible(false)
        self.itemDetailsMap:setVisible(false)
        self.attributesLayout:setVisible(false)
        -- Show Empty Info
        self.mainBoxEmpty:setVisible(true)
    end
    self:updateView()
end

function AFMGuiVehicleFrame:getNumberOfItemsInSection(list, section)
    local selectedIndex = self.vehicleList:getSelectedIndexInSection()

    if selectedIndex ~= nil then
        if list == self.vehicleList and self.vehicles ~= nil then
            return #self.vehicles
        elseif self.vehicles ~= nil and #self.vehicles > 0 and self.vehicles[selectedIndex] ~= nil and self.vehicles[selectedIndex].vehicle ~= nil and self.vehicles[selectedIndex].vehicle.rowIndexes ~= nil then
            -- Total number or rows for vehicle details.
            return #self.vehicles[selectedIndex].vehicle.rowIndexes
        end
    end
    return 0
end

function AFMGuiVehicleFrame:populateCellForItemInSection(list, section, index, cell)
    afmDebug("AFMGuiVehicleFrame:populateCellForItemInSection")
    if list == self.vehicleList then
        local thisVehicle = self.vehicles[index].vehicle
        local name        = thisVehicle:getFullName()
        local thisColor   = { 1, 1, 1, 1 }
        local thisHotKey  = 0
        local isParked    = false
        local hotkey      = "";

        local uniqueUserId = afmGetLocalUniqueUserId()

        if thisVehicle.getHotKeyVehicleState ~= nil then
            thisHotKey = thisVehicle:getHotKeyVehicleState(uniqueUserId)
            isParked   = thisVehicle:getHKParkVehicleState()
        end

        cell:getAttribute("statusRunning"):setVisible(false)
        cell:getAttribute("statusParked"):setVisible(false)
        cell:getAttribute("statusMine"):setVisible(false)
        cell:getAttribute("activeDriver"):setVisible(false)
        cell:getAttribute("activeAI"):setVisible(false)

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

        if isParked then
            cell:getAttribute("statusParked"):setVisible(true)
            thisColor = { 0.2195, 0.2233, 0.2310, 1}
        end

        if thisVehicle.getIsControlled ~= nil and thisVehicle:getIsControlled() then
            cell:getAttribute("activeDriver"):setVisible(true)
        elseif thisVehicle.getIsAIActive and thisVehicle:getIsAIActive() then
            cell:getAttribute("activeAI"):setVisible(true)
        end


        if thisVehicle.getDamageAmount ~= nil and thisVehicle:getDamageAmount() > 0.12 then
            thisColor = { 0.413, 0.070, 0.078, 1}
        end

        if thisVehicle.propertyState == VehiclePropertyState.MISSION then
            thisColor = { 0.223, 0.503, 0.807, 1 }
        end

        if thisHotKey ~= nil and thisHotKey > 0 then
            -- cell:getAttribute("hotkey"):setText(tostring(thisHotKey))
            hotkey = "["..thisHotKey.."] "
        else
            -- cell:getAttribute("hotkey"):setText("")
        end

        local farm = g_farmManager:getFarmById(thisVehicle.ownerFarmId)
        cell:getAttribute("dotBg").color = { 0.02956, 0.02956, 0.02956, 0.5 }
        cell:getAttribute("dot").color = farm:getColor()

        cell:getAttribute("title"):setText(hotkey .. name)
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
            self.vehicleIcon:setVisible(false)
            self.vehicleDetail:setVisible(false)
            self.afmInfoSubVeh:setVisible(false)
        end
    end
end


function AFMGuiVehicleFrame:setDetailText(cell, nukeBar, title, level)
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

function AFMGuiVehicleFrame:setStatusBarValue(statusBarElement, value, rawValue, levelGood, levelWarn)
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

function AFMGuiVehicleFrame:powerString(vehicle, noBrace)
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

function AFMGuiVehicleFrame:typeString(vehicle, noBrace)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)

    if vehicle.configurations == nil or vehicle.configurations.motor == nil then
        return ""
    end

    local category = g_storeManager:getCategoryByName(storeItem.categoryName)

    local returnText = category.title

    if noBrace == nil or noBrace == false then
        return " [" .. returnText .. "]"
    end

    return returnText
end

function AFMGuiVehicleFrame:rawToPerc(value, invert)
    if not invert then
        return math.ceil((value)*100) .. " %"
    end
    return math.ceil((1 - value)*100) .. " %"
end

function AFMGuiVehicleFrame:getMethane(vehicle)
    if vehicle.getConsumerFillUnitIndex == nil then
        return false
    end

    local fillIndex = vehicle:getConsumerFillUnitIndex(FillType.METHANE)

    if fillIndex == nil then
        return false
    end

    local fuelLevel  = vehicle:getFillUnitFillLevel(fillIndex)
    local capacity   = vehicle:getFillUnitCapacity(fillIndex)
    local toFill     = capacity - fuelLevel

    return toFill
end

function AFMGuiVehicleFrame:getMethaneCost(amount)
    if amount ~= nil and amount ~= false and amount > 0 then
      return g_currentMission.economyManager:getPricePerLiter(FillType.METHANE) * amount * self.costFactor
    else
      return 0
    end    
end

function AFMGuiVehicleFrame:getDEF(vehicle)
    if vehicle.getConsumerFillUnitIndex == nil then
        return false
    end

    local fillIndex = vehicle:getConsumerFillUnitIndex(FillType.DEF)

    if fillIndex == nil then
        return false
    end

    local fuelLevel  = vehicle:getFillUnitFillLevel(fillIndex)
    local capacity   = vehicle:getFillUnitCapacity(fillIndex)
    local toFill     = capacity - fuelLevel

    return toFill
end

function AFMGuiVehicleFrame:getDEFCost(amount)
    if amount ~= nil and amount ~= false and amount > 0 then
      return g_currentMission.economyManager:getPricePerLiter(FillType.DEF) * amount * self.costFactor
    else
      return 0
    end    
end

function AFMGuiVehicleFrame:getDiesel(vehicle)
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

function AFMGuiVehicleFrame:getDieselCost(amount)
    if amount ~= nil and amount ~= false and amount > 0 then
      return g_currentMission.economyManager:getPricePerLiter(FillType.DIESEL) * amount * self.costFactor
    else
      return 0
    end    
end

function AFMGuiVehicleFrame:getFuel(vehicle)
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
    return { false, 0 } -- unknown fuel type, should not be possible.
end

function AFMGuiVehicleFrame:getFuelDEF(vehicle)
    local fuelTypeList = {
        {
            FillType.DEF,
            "fillType_def",
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
    return { false, 0 } -- unknown fuel type, should not be possible.
end

function AFMGuiVehicleFrame:vehicleCleanCost(vehicle)
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

function AFMGuiVehicleFrame:vehicleRepairPrice(vehicle)
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

function AFMGuiVehicleFrame:vehicleRepaintPrice(vehicle)
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

function AFMGuiVehicleFrame:vehicleSellPrice(vehicle)
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

function AFMGuiVehicleFrame:vehicleRunning(vehicle)
    if vehicle.getIsMotorStarted ~= nil and vehicle:getIsMotorStarted() then
        return g_i18n:getText("ui_yes")
    end

    return g_i18n:getText("ui_no")
end


function AFMGuiVehicleFrame:vehicleParked(vehicle)
    if vehicle.getIsTabbable ~= nil and ( not vehicle:getIsTabbable() ) then
        return g_i18n:getText("ui_yes")
    end

    return g_i18n:getText("ui_no")
end


function AFMGuiVehicleFrame:vehicleOccupant(vehicle)
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

function AFMGuiVehicleFrame:vehicleOwnership(vehicle)
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

function AFMGuiVehicleFrame:onListSelectionChanged(list, section, index)
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

function AFMGuiVehicleFrame:getLocation(vehicle)
    if vehicle.components == nil and vehicle.components[1].node then return false end

    local wx, _, wz = localToWorld(vehicle.components[1].node, getCenterOfMass(vehicle.components[1].node))

    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(wx, wz)
    if farmlandId ~= nil then

        return string.format("F-%03d", farmlandId)
        
    end

    return "--"
end

function AFMGuiVehicleFrame:getCompassLocation(vehicle)
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


function AFMGuiVehicleFrame:onButtonRefuelVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local needsDiesel   = self:getDiesel(thisVehicle)
    local dieselCost    = self:getDieselCost(needsDiesel)
    local needsDEF      = self:getDEF(thisVehicle)
    local defCost       = self:getDEFCost(needsDEF)
    local needsMethane  = self:getMethane(thisVehicle)
    local methaneCost   = self:getMethaneCost(needsMethane)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    local totalFuelCost = 0
    if dieselCost > 0 then 
      totalFuelCost = totalFuelCost + dieselCost
    end
    if defCost > 0 then
      totalFuelCost = totalFuelCost + defCost
    end
    if methaneCost > 0 then
      totalFuelCost = totalFuelCost + methaneCost
    end

    -- Display confirmation dialog for item action
    ActionItemDialog:show(
        self.onYesNoRefuelDialog,
        self,
        thisVehicle,
        totalFuelCost,
        thisStoreItem,
        nil,
        g_i18n:getText("afm_refuelDialog"),
        GuiSoundPlayer.SOUND_SAMPLES.TRANSACTION
    )

end

function AFMGuiVehicleFrame:onYesNoRefuelDialog(yes)
    afmDebug("Refuel Vehicle")
    if yes then
        local selectedIndex        = self.vehicleList.selectedIndex
        local thisVehicle          = self.vehicles[selectedIndex].vehicle
        local fillUnitIndexDiesel  = thisVehicle:getConsumerFillUnitIndex(FillType.DIESEL)
        local fillUnitIndexDEF     = thisVehicle:getConsumerFillUnitIndex(FillType.DEF)
        local fillUnitIndexMethane = thisVehicle:getConsumerFillUnitIndex(FillType.METHANE)
        local farmId               = thisVehicle:getActiveFarm()
        local needsDiesel   = self:getDiesel(thisVehicle)
        local dieselCost    = self:getDieselCost(needsDiesel)
        local needsDEF      = self:getDEF(thisVehicle)
        local defCost       = self:getDEFCost(needsDEF)
        local needsMethane  = self:getMethane(thisVehicle)
        local methaneCost   = self:getMethaneCost(needsMethane)

        afmDebug("Refuel Needed Check")

        if needsDiesel == false and needsDEF == false and needsMethane == false then
            return
        end

        local totalFuelCost = 0
        if dieselCost > 0 then 
          totalFuelCost = totalFuelCost + dieselCost
        end
        if defCost > 0 then
          totalFuelCost = totalFuelCost + defCost
        end
        if methaneCost > 0 then
          totalFuelCost = totalFuelCost + methaneCost
        end

        afmDebug(totalFuelCost)

        if needsDiesel then
            local delta = thisVehicle:addFillUnitFillLevel(farmId, fillUnitIndexDiesel, needsDiesel, FillType.DIESEL, ToolType.TRIGGER, nil)
            if delta > 0 then
                RefuelVehicleEvent.sendEvent(farmId, thisVehicle)
            end
        end

        if needsDEF then
            local delta2 = thisVehicle:addFillUnitFillLevel(farmId, fillUnitIndexDEF, needsDEF, FillType.DEF, ToolType.TRIGGER, nil)
            if delta2 > 0 then
                RefuelDEFVehicleEvent.sendEvent(farmId, thisVehicle)
            end
        end

        if needsMethane then
            local delta3 = thisVehicle:addFillUnitFillLevel(farmId, fillUnitIndexMethane, needsMethane, FillType.METHANE, ToolType.TRIGGER, nil)
            if delta3 > 0 then
                RefuelMethaneVehicleEvent.sendEvent(farmId, thisVehicle)
            end
        end

        if totalFuelCost > 0 then
          MoneyPaymentEvent.sendEvent(farmId, totalFuelCost, MoneyType.PURCHASE_FUEL)
        end
    end
end

function AFMGuiVehicleFrame:onButtonParkVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle

    thisVehicle:setHKParkVehicleState(not thisVehicle:getHKParkVehicleState())

    self:rebuildTable()
end


function AFMGuiVehicleFrame:onButtonEnterVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local isConned      = thisVehicle.getIsControlled ~= nil and thisVehicle:getIsControlled()

    if not isConned then
        -- available, switch to it
        g_gui:showGui("")
        g_localPlayer:requestToEnterVehicle(thisVehicle)
    elseif thisVehicle.spec_enterable.controllerUserId ==  g_localPlayerUserId then
        -- already in it, just close GUI
        g_gui:showGui("")
    else
        -- occupied, refuse request
        InfoDialog.show(g_i18n:getText("afm_occupied"), nil, nil, DialogElement.TYPE_WARNING)
    end
end

function AFMGuiVehicleFrame:onButtonSellVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    if thisVehicle ~= nil then
      local storeItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)
      g_shopController:sell(storeItem, thisVehicle)

      self:rebuildTable()
    end
end

function AFMGuiVehicleFrame:onButtonRepairVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local thisCost      = self:vehicleRepairPrice(thisVehicle)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    if thisVehicle ~= nil and thisCost >= 1 then

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

function AFMGuiVehicleFrame:onYesNoRepairDialog(yes)
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


function AFMGuiVehicleFrame:onButtonRepaintVehicle()
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local thisCost = self:vehicleRepaintPrice(thisVehicle)
    local thisStoreItem = g_storeManager:getItemByXMLFilename(thisVehicle.configFileName)

    if thisVehicle ~= nil and thisCost >= 1 then

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

function AFMGuiVehicleFrame:onYesNoRepaintDialog(yes)
    local selectedIndex = self.vehicleList.selectedIndex
    local thisVehicle   = self.vehicles[selectedIndex].vehicle
    local price         = self:vehicleRepaintPrice(thisVehicle)
    local farmId        = thisVehicle:getActiveFarm()

    afmDebug("Repaint Cost")
    afmDebug(price)

    if yes then
        if g_currentMission:getMoney() < price then
            InfoDialog.show(g_i18n:getText("shop_messageNotEnoughMoneyToBuy"), nil, nil, DialogElement.TYPE_WARNING)
        else
            MoneyPaymentEvent.sendEvent(farmId, price, MoneyType.VEHICLE_REPAIR)
            RepaintVehicleEvent.sendEvent(thisVehicle)
        end
    end
end

function AFMGuiVehicleFrame:onButtonCleanVehicle()
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

function AFMGuiVehicleFrame:onYesNoCleanDialog(yes)
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

function AFMGuiVehicleFrame:onButtonRenameVehicle()
    local selectedIndex  = self.vehicleList.selectedIndex
    local thisVehicle    = self.vehicles[selectedIndex].vehicle
    local defaultNewName = ""

    if thisVehicle.spec_hotKeyVehicle.nickname ~= nil then
        defaultNewName = thisVehicle.spec_hotKeyVehicle.nickname
    end
    
    -- TextInputDialog.show(onTextEntered, target, defaultText, dialogPrompt, imePrompt, maxCharacters, confirmText, callbackArgs, inputText, applyTextFilter)
    TextInputDialog.show(
        function (_, text, yes)
            if yes then
                local vehicleNickName = string.trim(text)

                local sIndex               = self.vehicleList.selectedIndex
                local thisChangeVehicle    = self.vehicles[sIndex].vehicle
                --thisChangeVehicle:setHotKeyNickName(vehicleNickName)
                if self.isMPGame then
                    thisChangeVehicle:setHotKeyNickName(vehicleNickName)
                    SetHotKeyNickNameEvent.sendEvent(thisChangeVehicle, vehicleNickName)
                    self:rebuildTable()
                else
                    thisChangeVehicle:setHotKeyNickName(vehicleNickName)
                    self:rebuildTable()
                end
            end
        end,
        self,
        defaultNewName,
        g_i18n:getText("ui_enterName"),
        g_i18n:getText("ui_enterName"),
        40,
        g_i18n:getText("button_change"),
        nil,
        g_i18n:getText("button_changeName"),
        true
    )
end


function AFMGuiVehicleFrame.updateView(self)

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiVehicleFrame:updateView")
    end

    local sortByColumn = self.sortByColumn
    local sortOrder = self.sortOrder

    -- Update sorting icons
    for columnIndex, iconSet in pairs(self.sortIcons) do
        local isCurrentSortColumn = columnIndex == sortByColumn
        local descendingIcon = iconSet[AFMGuiVehicleFrame.SORT_ORDER_DESC]
        local showDescendingIcon

        if isCurrentSortColumn then
            showDescendingIcon = sortOrder == AFMGuiVehicleFrame.SORT_ORDER_DESC
        else
            showDescendingIcon = false
        end

        descendingIcon:setVisible(showDescendingIcon)

        local ascendingIcon = iconSet[AFMGuiVehicleFrame.SORT_ORDER_ASC]
        local showAscendingIcon = isCurrentSortColumn and sortOrder == AFMGuiVehicleFrame.SORT_ORDER_ASC

        ascendingIcon:setVisible(showAscendingIcon)
    end

    -- Sort the vehicle list
    table.sort(self.vehicles, function(vehicleA, vehicleB)
        local valueA = vehicleA.columns[sortByColumn].value
        local valueB = vehicleB.columns[sortByColumn].value

        if valueA == valueB then
            -- If primary sort values are equal, sort by name
            valueA = vehicleA.columns[AFMGuiVehicleFrame.COLUMN_NAME].value
            valueB = vehicleB.columns[AFMGuiVehicleFrame.COLUMN_NAME].value
            
            -- if valueA == valueB then
            --     -- If names are also equal, sort by a secondary value column
            --     valueA = vehicleA.columns[AFMGuiVehicleFrame.COLUMN_VALUE].value
            --     valueB = vehicleB.columns[AFMGuiVehicleFrame.COLUMN_VALUE].value
            -- end
        end

        if sortOrder == AFMGuiVehicleFrame.SORT_ORDER_DESC then
            return valueB < valueA -- Descending order
        else
            return valueA < valueB -- Ascending order
        end
    end)

    -- Refresh the vehicle list and UI elements
    self.vehicleList:reloadData()
    self.vehicleDetail:setVisible(self.vehicleList:getItemCount() > 0)
    self:updateMenuButtons()
end


function AFMGuiVehicleFrame.applySorting(self, column, sortOrder)
    if sortOrder == nil then
        if self.sortByColumn == column and self.sortOrder ~= AFMGuiVehicleFrame.SORT_ORDER_ASC then
            self.sortOrder = AFMGuiVehicleFrame.SORT_ORDER_ASC
        else
            self.sortOrder = AFMGuiVehicleFrame.SORT_ORDER_DESC
        end
    else
        self.sortOrder = sortOrder
    end
    self.sortByColumn = column
    self:updateView()
end

function AFMGuiVehicleFrame.onClickButtonSortByVehicles(self)
	  self:applySorting(AFMGuiVehicleFrame.COLUMN_NAME)
end
function AFMGuiVehicleFrame.onClickButtonSortByCategory(self)
	  self:applySorting(AFMGuiVehicleFrame.COLUMN_CATEGORY)
end
function AFMGuiVehicleFrame.onClickButtonSortByLocation(self)
	  self:applySorting(AFMGuiVehicleFrame.COLUMN_LOCATION)
end

function AFMGuiVehicleFrame.onCreateButtonSortByVehicles(self, button)
    self.sortIcons[AFMGuiVehicleFrame.COLUMN_NAME] = {
        [AFMGuiVehicleFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiVehicleFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiVehicleFrame.onCreateButtonSortByCategory(self, button)
    self.sortIcons[AFMGuiVehicleFrame.COLUMN_CATEGORY] = {
        [AFMGuiVehicleFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiVehicleFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiVehicleFrame.onCreateButtonSortByLocation(self, button)
    self.sortIcons[AFMGuiVehicleFrame.COLUMN_LOCATION] = {
        [AFMGuiVehicleFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiVehicleFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiVehicleFrame.assignItemAttributeData(self, item)
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

function AFMGuiVehicleFrame.assignItemFillTypesData(self, iconProfile, fillTypeIcons)
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


function AFMGuiVehicleFrame.updateMarqueeAnimation(self, dt)
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


function AFMGuiVehicleFrame.dequeueDetailsCell(self, templateKey)
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

function AFMGuiVehicleFrame.queueDetailsCell(self, cell)
    local cellCache = self.detailsCache[cell.name]
    cellCache[#cellCache + 1] = cell -- Add cell to cache

    local clonesInCache = self.clonesInCache
    table.insert(clonesInCache, cell) -- Keep track of clones

    self.attributesLayout:removeElement(cell)
    cell:unlinkElement()
end

function AFMGuiVehicleFrame.buildCellDatabase(self)
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

function AFMGuiVehicleFrame:processStoreItemWorkingSpeed(vehicle)
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
    return (storeItem.specs == nil or storeItem.specs.speedLimit == nil) and 0 or storeItem.specs.speedLimit
end

function AFMGuiVehicleFrame:processStoreItemPowerNeeded(vehicle)
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

function AFMGuiVehicleFrame.onMoneyChange(self)
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

function AFMGuiVehicleFrame:formatPercentToBar(value)
    return value
end