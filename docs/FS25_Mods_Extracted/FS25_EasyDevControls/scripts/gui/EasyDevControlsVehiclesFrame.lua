--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-03

Contact:
https://forum.giants-software.com
https://github.com/GtX-Andy/FS25_EasyDevelopmentControls

Important:
Not to be added to any mods / maps or modified from its current release form.
No modifications may be made to this script, including conversion to other game versions without written permission from GtX | Andy
Copying or removing any part of this code for external use without written permission from GtX | Andy is prohibited.

Darf nicht zu Mods / Maps hinzugefügt oder von der aktuellen Release-Form geändert werden.
Ohne schriftliche Genehmigung von GtX | Andy dürfen keine Änderungen an diesem Skript vorgenommen werden, einschließlich der Konvertierung in andere Spielversionen
Das Kopieren oder Entfernen irgendeines Teils dieses Codes zur externen Verwendung ohne schriftliche Genehmigung von GtX | Andy ist verboten.
]]

EasyDevControlsVehiclesFrame = {}
EasyDevControlsVehiclesFrame.NAME = "VEHICLES"

EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS = {}
EasyDevControlsVehiclesFrame.MAX_WIPER_STATES = 10

local EasyDevControlsVehiclesFrame_mt = Class(EasyDevControlsVehiclesFrame, EasyDevControlsBaseFrame)

function EasyDevControlsVehiclesFrame.register()
    local controller = EasyDevControlsVehiclesFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsVehiclesFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsVehiclesFrame", controller, true)

    return controller
end

function EasyDevControlsVehiclesFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsVehiclesFrame_mt)

    self.pageName = EasyDevControlsVehiclesFrame.NAME

    self.updatingDebugState = false
    self.intervalTimeRemaining = 5000

    return self
end

function EasyDevControlsVehiclesFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsVehiclesFrame.register()
end

function EasyDevControlsVehiclesFrame:copyAttributes(src)
    EasyDevControlsVehiclesFrame:superClass().copyAttributes(self, src)
end

function EasyDevControlsVehiclesFrame:initialize()
    local fillEmptySetTexts = {
        EasyDevControlsUtils.getText("easyDevControls_fill"),
        EasyDevControlsUtils.getText("easyDevControls_empty"),
        EasyDevControlsUtils.getText("easyDevControls_set")
    }

    self.vehicleSelectionTitle = g_i18n:getText("ui_statisticViewVehicleSelection")

    self.maximumText = EasyDevControlsUtils.getText("easyDevControls_maximum")
    self.enterAmountText = EasyDevControlsUtils.getText("easyDevControls_placeholderEnterAmount")

    self.unknownText = EasyDevControlsUtils.getText("easyDevControls_unknown")
    self.currentValueText = EasyDevControlsUtils.getText("easyDevControls_currentValue")

    -- Set Fill Level
    self.lastSelectedFillUnit = 1
    self.lastFillTypeVehicle = nil

    self.fillUnitTextsDefault = table.create(1, "1")
    self.lastSelectedFillTypeStateDefault = table.create(1, 1)
    self.fillUnitFillTypesTextsDefault = table.create(1, table.create(1, self.unknownText))
    self.fillUnitSupportedFillTypesDefault = table.create(1, table.create(1, FillType.UNKNOWN))

    self.multiFillChange:setTexts(fillEmptySetTexts)

    -- Set Fuel
    EasyDevControlsVehiclesFrame.createFuelTypeIndexs()
    self.multiFuelChange:setTexts(fillEmptySetTexts)

    -- Set Condition
    self.multiConditionType:setTexts(EasyDevControlsVehicleConditionEvent.getTypeTexts())

    self.multiConditionSetAddRemove:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_set"),
        EasyDevControlsUtils.getText("easyDevControls_add"),
        EasyDevControlsUtils.getText("easyDevControls_remove")
    })

    local conditionSetTexts = {"0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"}
    local conditionAddRemoveTexts = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"}

    self.conditionTypeTexts = {
        conditionSetTexts,
        conditionAddRemoveTexts,
        conditionAddRemoveTexts
    }

    -- Reload Vehicle
    self.multiResetState:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_reload"),
        EasyDevControlsUtils.getText("easyDevControls_reloadReset")
    })

    -- Wipers
    self.wiperStateTextsDefault = {
        EasyDevControlsUtils.getText("easyDevControls_wiperStateRainSensor"),
        g_i18n:getText("ui_off")
    }

    for i = 1, EasyDevControlsVehiclesFrame.MAX_WIPER_STATES do
        table.insert(self.wiperStateTextsDefault, EasyDevControlsUtils.formatText("easyDevControls_state", tostring(i)))
    end

    self.multiGlobalWiperState:setTexts(self.wiperStateTextsDefault)

    -- Vehicle Debug
    local debugStateTexts = nil

    if VehicleDebug.NUM_STATES ~= nil and VehicleDebug.STATE_NAMES ~= nil then
        debugStateTexts = table.create(VehicleDebug.NUM_STATES + 1, EasyDevControlsUtils.capitalise(g_i18n:getText("ui_off"), false))

        for i = 1, VehicleDebug.NUM_STATES do
            debugStateTexts[i + 1] = VehicleDebug.STATE_NAMES[i]
        end
    else
        debugStateTexts = {g_i18n:getText("ui_off"), "Values", "Physics", "Tuning", "Transmission", "Attributes", "Attacher Joints", "AI", "Sounds", "Animations"}
    end

    self.multiVehicleDebug:setTexts(debugStateTexts)
end

function EasyDevControlsVehiclesFrame:onUpdateCommands(resetToDefault)
    local easyDevControls = g_easyDevControls

    local isMultiplayer = easyDevControls:getIsMultiplayer()
    local isMasterUser = not isMultiplayer or easyDevControls:getIsMasterUser()

    local vehicle, isEntered = easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

    local wipersForcedState = Wipers.forcedState
    local showVehicleDistance = g_showVehicleDistance
    local vehicleDebugState = VehicleDebug.state
    local tensionBeltDebugRendering = TensionBelts.debugRendering
    local wetnessDebugState = VehicleDebug.wetnessDebugState

    if resetToDefault then
        wipersForcedState = -1
        showVehicleDistance = false
        vehicleDebugState = 1
        tensionBeltDebugRendering = false
        wetnessDebugState = false
    end

    self.updatingDebugState = true

    self.isServer = g_server ~= nil
    self.currentVehicle = vehicle
    self.currentVehicleUniqueId = nil

    if vehicle ~= nil and vehicle.getUniqueId ~= nil then
        self.currentVehicleUniqueId = vehicle:getUniqueId()
    end

    self.currentTargetedVehicle = not isEntered and vehicle or nil
    self.currentMotorizedVehicle = (vehicle ~= nil and vehicle.spec_motorized ~= nil) and vehicle or nil

    -- Next Vehicle
    local vehicleName = "N/A"
    local selectionTitle = self.vehicleSelectionTitle

    if vehicle ~= nil then
        if isEntered then
            if vehicle.getSelectedObject ~= nil then
                local selectedObject = vehicle:getSelectedObject()

                if selectedObject ~= nil and selectedObject.vehicle ~= nil then
                    vehicleName = selectedObject.vehicle:getFullName()

                    if selectedObject.index ~= nil then
                        selectionTitle = string.format("%s (%d)", selectionTitle, selectedObject.index)
                    end
                end
            end
        else
            vehicleName = vehicle:getFullName()
        end
    end

    self.titleVehicleSelection:setText(selectionTitle)
    self.textVehicleSelection:setText(vehicleName)
    self.buttonNextVehicle:setDisabled(not isEntered or EasyDevControlsVehiclesFrame.getNumSelectableObjects(vehicle) <= 1)

    -- Reload Vehicle
    local reloadVehicleDisabled = vehicle == nil or isMultiplayer -- No need for this in MP as all mods are zipped anyway

    self.multiResetState:setDisabled(reloadVehicleDisabled)
    self.buttonConfirmReload:setDisabled(reloadVehicleDisabled)

    -- Analyse Vehicle
    self.buttonConfirmAnalyseVehicle:setDisabled(reloadVehicleDisabled or not isEntered)

    -- Set Fill Level
    local numFillUnitTexts = 0
    local fillUnitTexts = nil

    local lastSelectedFillUnit = self.lastSelectedFillUnit or 1
    local selectedVehicle = easyDevControls:getSelectedVehicle("spec_fillUnit", false, self.currentVehicleUniqueId)
    local setFillUnitDisabled = selectedVehicle == nil or not self:getHasPermission("vehicleFillLevel")

    if not setFillUnitDisabled and selectedVehicle.getFillUnits ~= nil then
        local fillUnits = selectedVehicle:getFillUnits()

        numFillUnitTexts = #fillUnits -- Fix for vehicles that include the 'FillUnit Spec' but do not use it for some reason :-/
        fillUnitTexts = table.create(numFillUnitTexts)

        self.fillUnitFillTypesTexts = table.create(numFillUnitTexts)
        self.fillUnitSupportedFillTypes = table.create(numFillUnitTexts)

        local lastSelectedFillTypeState = table.create(numFillUnitTexts, 1) -- Fill the table with default index 1, will be changed if vehicle matches

        for fillUnitIndex, fillUnit in ipairs(fillUnits) do
            local numSupported = table.size(fillUnit.supportedFillTypes)

            self.fillUnitFillTypesTexts[fillUnitIndex] = table.create(numSupported)
            self.fillUnitSupportedFillTypes[fillUnitIndex] = table.create(numSupported)

            for supportedFillTypeIndex, _ in pairs(fillUnit.supportedFillTypes) do
                table.insert(self.fillUnitFillTypesTexts[fillUnitIndex], EasyDevControlsUtils.getFillTypeTitle(supportedFillTypeIndex, "easyDevControls_unknown"))
                table.insert(self.fillUnitSupportedFillTypes[fillUnitIndex], supportedFillTypeIndex)
            end

            table.insert(fillUnitTexts, EasyDevControlsUtils.formatText("easyDevControls_fillUnitIndex", tostring(fillUnitIndex)))
        end

        if self.lastFillTypeVehicle ~= nil and self.lastFillTypeVehicle == selectedVehicle then
            if self.lastSelectedFillTypeState ~= nil and #self.lastSelectedFillTypeState == numFillUnitTexts then
                for i, state in ipairs (self.lastSelectedFillTypeState) do
                    lastSelectedFillTypeState[i] = state
                end
            else
                lastSelectedFillUnit = 1
            end
        else
            lastSelectedFillUnit = 1
        end

        self.lastSelectedFillTypeState = lastSelectedFillTypeState
        self.lastFillTypeVehicle = selectedVehicle -- [22/05/2022] Thanks @Alien Jim for mentioning this was not remembered when not exiting vehicle :-)
    end

    if numFillUnitTexts <= 0 then
        fillUnitTexts = self.fillUnitTextsDefault

        self.lastSelectedFillTypeState = self.lastSelectedFillTypeStateDefault
        self.fillUnitFillTypesTexts = self.fillUnitFillTypesTextsDefault
        self.fillUnitSupportedFillTypes = self.fillUnitSupportedFillTypesDefault

        lastSelectedFillUnit = 1
        setFillUnitDisabled = true

        self.lastFillTypeVehicle = nil
    end

    self.lastSelectedFillUnit = lastSelectedFillUnit
    self.fillUnitTexts = fillUnitTexts
    self.setFillUnitDisabled = setFillUnitDisabled

    self.multiFillUnit:setTexts(fillUnitTexts)
    self.multiFillUnit:setState(lastSelectedFillUnit)
    self.multiFillUnit:setDisabled(setFillUnitDisabled or #fillUnitTexts <= 1)

    self.multiFillType:setTexts(self.fillUnitFillTypesTexts[lastSelectedFillUnit])
    self.multiFillType:setState(self.lastSelectedFillTypeState[lastSelectedFillUnit])
    self.multiFillType:setDisabled(setFillUnitDisabled or #self.fillUnitFillTypesTexts[lastSelectedFillUnit] <= 1)

    self.multiFillChange:setState(self.multiFillChange:getState(), true) -- Handles 'textInputFillAmount'
    self.multiFillChange:setDisabled(setFillUnitDisabled)

    self.buttonConfirmFillLevel:setDisabled(setFillUnitDisabled)

    -- Toggle Cover
    self.buttonToggleCover:setDisabled(easyDevControls:getSelectedVehicle("spec_cover", false, self.currentVehicleUniqueId) == nil)

    -- Set Condition
    local setConditionDisabled = vehicle == nil or not self:getHasPermission("vehicleCondition")

    self.multiConditionSetAddRemove:setState(self.lastSetAddRemoveState or 1, true)

    self.multiConditionType:setDisabled(setConditionDisabled)
    self.multiConditionSetAddRemove:setDisabled(setConditionDisabled)
    self.optionSliderConditionPercent:setDisabled(setConditionDisabled)
    self.buttonConfirmCondition:setDisabled(setConditionDisabled)

    -- Set Fuel
    self.setFuelDisabled = true

    if self:getHasPermission("vehicleFuel") and vehicle ~= nil and vehicle.getConsumerFillUnitIndex ~= nil then
        EasyDevControlsVehiclesFrame.createFuelTypeIndexs()

        for _, fillTypeIndex in pairs (EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS) do
            if vehicle:getConsumerFillUnitIndex(fillTypeIndex) ~= nil then
                self.setFuelDisabled = false

                break
            end
        end
    end

    self.multiFuelChange:setState(self.multiFuelChange:getState(), true) -- Handles 'textInputFuel'
    self.multiFuelChange:setDisabled(self.setFuelDisabled)
    self.buttonConfirmFuel:setDisabled(self.setFuelDisabled)

    local motorizedVehicleUnavailable = self.currentMotorizedVehicle == nil

    -- Set Power Consumer
    self.buttonSetPowerConsumer:setDisabled(reloadVehicleDisabled or motorizedVehicleUnavailable or not isEntered)

    -- Set Motor Temp
    self.textInputMotorTemp:setText("")
    self.textInputMotorTemp:setPlaceholderText(self.isServer and self.currentValueText:format(g_i18n:formatTemperature(0, 0, false)) or "")
    self.textInputMotorTemp:setDisabled(motorizedVehicleUnavailable or not self:getHasPermission("motorTemp"))

    -- Set Operating Time
    local setOperatingTimeDisabled = vehicle == nil or vehicle.setOperatingTime == nil

    self.textInputOperatingTime:setText("")
    self.textInputOperatingTime:setPlaceholderText(self.currentValueText:format("0.00h"))
    self.textInputOperatingTime:setDisabled(setOperatingTimeDisabled or not self:getHasPermission("operatingTime"))

    -- Remove / Delete All Vehicles
    self.buttonConfirmRemoveAllVehicles:setDisabled(not isMasterUser)

    -- Wipers
    self.multiGlobalWiperState:setState(wipersForcedState + 2, resetToDefault)
    self.wipersForcedState = wipersForcedState

    -- Vehicle Distance
    self.binaryShowVehicleDistance:setIsChecked(showVehicleDistance, self.isOpening, resetToDefault)
    self.showVehicleDistance = showVehicleDistance

    -- Vehicle Debug
    self.multiVehicleDebug:setState(vehicleDebugState + 1)
    self.vehicleDebugState = vehicleDebugState

    -- Tension Belts Debug
    self.binaryTensionBeltsDebug:setIsChecked(tensionBeltDebugRendering, self.isOpening, resetToDefault)
    self.tensionBeltDebugRendering = tensionBeltDebugRendering

    -- Wetness Debug
    self.binaryWetnessDebug:setDisabled(isMultiplayer)
    self.binaryWetnessDebug:setIsChecked(wetnessDebugState, self.isOpening, resetToDefault)
    self.wetnessDebugState = wetnessDebugState

    --
    self.intervalUpdateDisabled = motorizedVehicleUnavailable and setOperatingTimeDisabled
    self.intervalTimeRemaining = 0

    self.updatingDebugState = false
end

function EasyDevControlsVehiclesFrame:onFrameOpening()
    g_messageCenter:subscribe(MessageType.VEHICLE_ADDED, self.onVehicleBuySellEvent, self)
    g_messageCenter:subscribe(MessageType.VEHICLE_REMOVED, self.onVehicleBuySellEvent, self)
end

function EasyDevControlsVehiclesFrame:onFrameClose()
    EasyDevControlsVehiclesFrame:superClass().onFrameClose(self)

    self.currentVehicle = nil
    self.currentVehicleUniqueId = nil
    self.currentTargetedVehicle = nil
    self.currentMotorizedVehicle = nil
end

function EasyDevControlsVehiclesFrame:update(dt)
    EasyDevControlsVehiclesFrame:superClass().update(self, dt)

    if not self.updatingDebugState then
        if Wipers.forcedState ~= self.wipersForcedState then
            self.wipersForcedState = Wipers.forcedState
            self.multiGlobalWiperState:setState(self.wipersForcedState + 2)
        end

        if VehicleDebug.state ~= self.vehicleDebugState then
            self.vehicleDebugState = VehicleDebug.state
            self.multiVehicleDebug:setState(self.vehicleDebugState + 1)
        end

        if TensionBelts.debugRendering ~= self.tensionBeltDebugRendering then
            self.tensionBeltDebugRendering = TensionBelts.debugRendering
            self.binaryTensionBeltsDebug:setIsChecked(TensionBelts.debugRendering, false, false)
        end

        if g_showVehicleDistance ~= self.showVehicleDistance then
            self.showVehicleDistance = g_showVehicleDistance
            self.binaryShowVehicleDistance:setIsChecked(self.showVehicleDistance, false, false)
        end
    end

    if not self.intervalUpdateDisabled then
        self.intervalTimeRemaining -= dt

        if self.intervalTimeRemaining <= 0 then
            self.intervalTimeRemaining = 5000

            if self.isServer and self.currentMotorizedVehicle ~= nil and not self.currentMotorizedVehicle:getIsBeingDeleted() then
                if self.textInputMotorTemp.setPlaceholderText ~= nil then
                    local spec = self.currentMotorizedVehicle.spec_motorized

                    self.textInputMotorTemp:setPlaceholderText(self.currentValueText:format(g_i18n:formatTemperature(spec.motorTemperature.value or 0, 0, false)))
                end
            end

            if self.currentVehicle ~= nil and not self.currentVehicle:getIsBeingDeleted() then
                if self.textInputOperatingTime.setPlaceholderText ~= nil then
                    local minutes = (self.currentVehicle.operatingTime or 0) / 60000
                    local hours = math.floor(minutes / 60)

                    self.textInputOperatingTime:setPlaceholderText(self.currentValueText:format(string.format("%d.%dh", hours, math.floor((minutes - hours * 60) / 6) * 10)))
                end
            end
        end
    end
end

function EasyDevControlsVehiclesFrame:onVehicleBuySellEvent()
    local currentVehicle = self.currentVehicle
    local currentVehicleUniqueId = self.currentVehicleUniqueId

    if currentVehicle ~= nil and currentVehicleUniqueId ~= nil then
        local updateCommands = true -- Assume the vehicle has been reloaded or deleted

        for _, vehicle in ipairs (g_currentMission.vehicleSystem.vehicles) do
            if vehicle:getUniqueId() == currentVehicleUniqueId then
                if vehicle == currentVehicle then
                    updateCommands = false -- No changes so ignore
                end

                break
            end
        end

        if updateCommands then
            self.isResettingCommands = false
            self:onUpdateCommands(false)
        end
    end
end

-- Next Vehicle
function EasyDevControlsVehiclesFrame:onClickNextVehicle(buttonElement)
    local vehicle, isEntered = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

    if isEntered and EasyDevControlsVehiclesFrame.getNumSelectableObjects(vehicle) > 1 then
        local currentSelection = vehicle.currentSelection
        local currentObject = currentSelection.object
        local currentObjectIndex = currentSelection.index
        local currentSubObjectIndex = currentSelection.subIndex

        local numSubSelections = 0
        if currentObject ~= nil then
            numSubSelections = #currentObject.subSelections
        end

        local newSelectedSubObjectIndex = currentSubObjectIndex + 1
        local newSelectedObjectIndex = currentObjectIndex
        local newSelectedObject = currentObject

        if newSelectedSubObjectIndex > numSubSelections then
            newSelectedSubObjectIndex = 1
            newSelectedObjectIndex = currentObjectIndex + 1

            if newSelectedObjectIndex > #vehicle.selectableObjects then
                newSelectedObjectIndex = 1
            end

            newSelectedObject = vehicle.selectableObjects[newSelectedObjectIndex]
        end

        if currentObject ~= newSelectedObject or currentObjectIndex ~= newSelectedObjectIndex or currentSubObjectIndex ~= newSelectedSubObjectIndex then
            if vehicle:setSelectedObject(newSelectedObject, newSelectedSubObjectIndex) then
                self.isResettingCommands = false
                self:onUpdateCommands(false)
            end
        end

        if newSelectedObject.vehicle ~= nil then
            self:setInfoText(string.format("%s: %s", g_i18n:getText("ui_farmlandsCurrentlySelected"), newSelectedObject.vehicle:getFullName()), EasyDevControlsErrorCodes.SUCCESS)
        end

        return
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)
end

-- Reload Vehicle
function EasyDevControlsVehiclesFrame:onClickConfirmReload(buttonElement)
    local vehicle, isEntered = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

    if vehicle ~= nil and vehicle.rootNode ~= nil then
        local resetVehicle = self.multiResetState:getState() == BinaryOptionElement.STATE_RIGHT
        local radius = 0

        if not isEntered and g_localPlayer ~= nil then
            local px, py, pz = g_localPlayer:getPosition()
            local vx, vy, vz = getWorldTranslation(vehicle.rootNode)

            -- Allows resting of the vehicle your looking at.
            radius = MathUtil.vector3Length(vx - px, vy - py, vz - pz) + 0.2
        end

        -- No need for my own function as editing and XML or I3D in MP is not possible.
        local message = g_currentMission.vehicleSystem:consoleCommandReloadVehicle(tostring(resetVehicle), tostring(radius))

        if message == nil or not (message:startsWith("Warning") or message:startsWith("Error")) then
            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_reloadVehicleInfo", vehicle:getFullName()))

            return
        end
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)
end

-- Analyse Vehicle
function EasyDevControlsVehiclesFrame:onClickConfirmAnalyseVehicle(buttonElement)
    local vehicle = g_localPlayer:getCurrentVehicle()

    if vehicle == nil then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    local selectedVehicle = vehicle:getSelectedVehicle(nil, nil, self.currentVehicleUniqueId)

    if selectedVehicle ~= nil then
        vehicle = selectedVehicle
    end

    local name = vehicle:getFullName()

    local function analyseVehicle(yes)
        if yes then
            if VehicleDebug.consoleCommandAnalyze(nil) == "Analyzed vehicle" then
                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_vehicleAnalyseInfo", name))
            else
                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_vehicleAnalyseFailedWarning"))
            end
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.CANCELLED)
        end
    end

    local text = EasyDevControlsUtils.formatText("easyDevControls_vehicleAnalyseWarning", name)
    YesNoDialog.show(analyseVehicle, nil, text, "", g_i18n:getText("button_continue"), g_i18n:getText("button_cancel"), DialogElement.TYPE_INFO)
end

-- Fill Unit
function EasyDevControlsVehiclesFrame:onClickFillUnit(state, multiTextOptionElement)
    local fillUnitTexts = self.fillUnitFillTypesTexts[state]

    self.lastSelectedFillUnit = state

    self.multiFillType:setTexts(fillUnitTexts)
    self.multiFillType:setState(self.lastSelectedFillTypeState[state] or 1, true)
    self.multiFillType:setDisabled(self.setFillUnitDisabled or #fillUnitTexts <= 1)

    self.multiFillChange:setState(self.multiFillChange:getState(), true)
end

function EasyDevControlsVehiclesFrame:onClickFillType(state, multiTextOptionElement)
    self.lastSelectedFillTypeState[self.lastSelectedFillUnit] = state
end

function EasyDevControlsVehiclesFrame:onClickFillState(state, multiTextOptionElement)
    local placeholderText = state == 3 and self.enterAmountText or "0 l"

    self.textInputFillAmount:setDisabled(self.setFillUnitDisabled or state < 3)

    if state == 1 then
        local selectedVehicle = g_easyDevControls:getSelectedVehicle("spec_fillUnit", false, self.currentVehicleUniqueId)

        if selectedVehicle ~= nil and selectedVehicle.getFillUnitCapacity ~= nil then
            local capacity = selectedVehicle:getFillUnitCapacity(self.lastSelectedFillUnit)

            if capacity ~= nil and math.abs(capacity) ~= math.huge then
                placeholderText = g_i18n:formatFluid(capacity)
            else
                placeholderText = self.maximumText
            end
        else
            placeholderText = ""
        end
    end

    self.textInputFillAmount:setPlaceholderText(placeholderText)
    self:onTextInputEscPressed(self.textInputFillAmount)
end

function EasyDevControlsVehiclesFrame:onFillAmountEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        self:setFillUnitFillLevel(tonumber(textInputElement.text), textInputElement.text)

        textInputElement:setText("")
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end

    textInputElement.lastValidText = ""
end

function EasyDevControlsVehiclesFrame:onClickConfirmFillLevel(buttonElement)
    local state = self.multiFillChange:getState()

    if state < 3 then
        self:setFillUnitFillLevel(state == 1 and 1e+7 or 0)
    else
        self:onFillAmountEnterPressed(self.textInputFillAmount)
    end
end

function EasyDevControlsVehiclesFrame:setFillUnitFillLevel(amount)
    if amount ~= nil then
        local vehicle = g_easyDevControls:getSelectedVehicle("spec_fillUnit", false, self.currentVehicleUniqueId)

        if vehicle ~= nil then
            local fillUnitIndex = self.lastSelectedFillUnit

            local supportedFillTypes = self.fillUnitSupportedFillTypes[fillUnitIndex]
            local fillTypeState = self.lastSelectedFillTypeState[fillUnitIndex]
            local fillTypeIndex = supportedFillTypes ~= nil and supportedFillTypes[fillTypeState] or nil

            if amount == 0 and vehicle.spec_fillUnit.removeVehicleIfEmpty then
                local function ignoreRemoveIfEmptyCallback(ignoreRemoveIfEmpty)
                    self:setInfoText(g_easyDevControls:setFillUnitFillLevel(vehicle, fillUnitIndex, fillTypeIndex, amount, ignoreRemoveIfEmpty))
                end

                YesNoDialog.show(ignoreRemoveIfEmptyCallback, nil, EasyDevControlsUtils.formatText("easyDevControls_ignoreRemoveIfEmptyMessage", vehicle:getFullName()), "")
            else
                if vehicle:getFillUnitCapacity(fillUnitIndex) == math.huge then
                    amount = math.min(amount, 100)
                end

                self:setInfoText(g_easyDevControls:setFillUnitFillLevel(vehicle, fillUnitIndex, fillTypeIndex, amount, false))
            end
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)
        end
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Set Condition
function EasyDevControlsVehiclesFrame:onClickConditionSetAddRemove(state, multiTextOptionElement)
    self.lastSetAddRemoveState = state

    self.optionSliderConditionPercent:setTexts(self.conditionTypeTexts[state])
    self.optionSliderConditionPercent:setState(1)
end

function EasyDevControlsVehiclesFrame:onClickConfirmCondition(buttonElement)
    local vehicle, isEntered = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

    local typeIndex = self.multiConditionType:getState()
    local applyType = self.multiConditionSetAddRemove:getState()
    local amount = (self.optionSliderConditionPercent:getState() - (applyType == 1 and 1 or 0)) * 0.1

    self:setInfoText(g_easyDevControls:setVehicleCondition(vehicle, isEntered, typeIndex, applyType == 1, applyType < 3 and amount or -amount))
end

-- Set Fuel
function EasyDevControlsVehiclesFrame:onClickFuelChangeType(state, multiTextOptionElement)
    local placeholderText = state == 3 and self.enterAmountText or "0 l"

    self.textInputFuel:setDisabled(self.setFuelDisabled or state < 3)

    if state == 1 then
        local vehicle, _ = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

        if vehicle ~= nil and vehicle.spec_motorized ~= nil and vehicle.getConsumerFillUnitIndex ~= nil then
            local _, capacity = SpeedMeterDisplay.getVehicleFuelLevelAndCapacity(vehicle)

            if capacity ~= nil and math.abs(capacity) ~= math.huge then
                placeholderText = g_i18n:formatFluid(capacity)
            else
                placeholderText = self.maximumText
            end
        else
            placeholderText = ""
        end
    end

    self.textInputFuel:setPlaceholderText(placeholderText)
    self:onTextInputEscPressed(self.textInputFuel)
end

function EasyDevControlsVehiclesFrame:onFuelEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        self:setVehicleFuel(tonumber(textInputElement.text))

        textInputElement:setText("")
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end

    textInputElement.lastValidText = ""
end

function EasyDevControlsVehiclesFrame:onClickConfirmFuel(buttonElement)
    local state = self.multiFuelChange:getState()

    if state < 3 then
        self:setVehicleFuel(state == 1 and 1e+7 or 0)
    else
        self:onFuelEnterPressed(self.textInputFuel)
    end
end

function EasyDevControlsVehiclesFrame:setVehicleFuel(amount)
    if amount ~= nil then
        local vehicle, _ = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

        if vehicle ~= nil and vehicle.spec_motorized ~= nil and vehicle.getConsumerFillUnitIndex ~= nil then
            local _, capacity = SpeedMeterDisplay.getVehicleFuelLevelAndCapacity(vehicle)

            if capacity ~= nil and math.abs(capacity) ~= math.huge then
                self:setInfoText(g_easyDevControls:setVehicleFuel(vehicle, amount))
            end
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)
        end
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsVehiclesFrame.createFuelTypeIndexs()
    if EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS == nil or #EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS < 3 then
        EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS = {
            FillType.DIESEL,
            FillType.ELECTRICCHARGE,
            FillType.METHANE
        }
    end
end

function EasyDevControlsVehiclesFrame.addCustomFuelTypeIndex(fillTypeIndex)
    if fillTypeIndex == nil then
        return false, 0
    end

    return table.addElement(EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS, fillTypeIndex)
end

-- Toggle Cover
function EasyDevControlsVehiclesFrame:onClickToggleCover(buttonElement)
    local selectedVehicle = g_easyDevControls:getSelectedVehicle("spec_cover", false, self.currentVehicleUniqueId)

    if selectedVehicle ~= nil then
        local spec = selectedVehicle.spec_cover
        local newState = spec.state + 1
        local stateText = ""

        if newState > #spec.covers then
            newState = 0
        end

        if selectedVehicle:getIsNextCoverStateAllowed(newState) then
            selectedVehicle:setCoverState(newState)

            spec.isStateSetAutomatically = false

            stateText = EasyDevControlsUtils.getText(newState == 0 and "easyDevControls_closed" or "easyDevControls_open"):lower()
            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_toggleCoverInfo", selectedVehicle:getFullName(), stateText, tostring(newState)))
        else
            if selectedVehicle.getIsNextCoverStateAllowedWarning ~= nil then
                stateText = selectedVehicle:getIsNextCoverStateAllowedWarning(newState)
            end

            if string.isNilOrWhitespace(stateText) then
                stateText = EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage")
            end

            self:setInfoText(stateText, EasyDevControlsErrorCodes.FAILED)
        end

        return
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED)
end

-- Set Power Consumer
function EasyDevControlsVehiclesFrame:onClickSetPowerConsumer(buttonElement)
    local currentVehicle = g_localPlayer ~= nil and g_localPlayer:getCurrentVehicle() or nil

    if currentVehicle ~= nil then
        local isPowerConsumer, selectedImplement = EasyDevControlsVehiclesFrame.getSelectedImplementIsPowerConsumer(currentVehicle)

        if isPowerConsumer then
            local spec = selectedImplement.spec_powerConsumer
            local properties = EasyDevControlsVehiclesFrame.getPowerConsumerProperties(spec)

            local function setPowerConsumer(yes, callbackValues)
                if not yes then
                    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.CANCELLED)

                    return
                end

                if callbackValues == nil then
                    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)

                    return
                end

                if Utils.getNoNil(callbackValues["resetToDefault"], false) then
                    if spec.edcOriginalValues ~= nil then
                        for name, value in pairs (spec.edcOriginalValues) do
                            if name == "forceDir" then
                                callbackValues[name] = value < 0 and 1 or 2
                            else
                                callbackValues[name] = value
                            end
                        end
                    else
                        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_defaultResetFailedMessage"), EasyDevControlsErrorCodes.FAILED)

                        return
                    end
                end

                local neededMinPtoPower = Utils.getNoNil(callbackValues["neededMinPtoPower"], spec.neededMinPtoPower)
                local neededMaxPtoPower = Utils.getNoNil(callbackValues["neededMaxPtoPower"], spec.neededMaxPtoPower)
                local forceFactor = Utils.getNoNil(callbackValues["forceFactor"], spec.forceFactor)
                local maxForce = Utils.getNoNil(callbackValues["maxForce"], spec.maxForce)

                local forceDir = callbackValues["forceDir"]

                if forceDir ~= nil then
                    forceDir = forceDir == 2 and 1 or -1
                else
                    forceDir = spec.forceDir
                end

                local ptoRpm = Utils.getNoNil(callbackValues["ptoRpm"], spec.ptoRpm)
                local syncVehicles = Utils.getNoNil(callbackValues["syncVehicles"], BinaryOptionElement.STATE_LEFT) == BinaryOptionElement.STATE_RIGHT

                self:setInfoText(g_easyDevControls:setPowerConsumer(selectedImplement, neededMinPtoPower, neededMaxPtoPower, forceFactor, maxForce, forceDir, ptoRpm, syncVehicles))
            end

            local headerText = selectedImplement:getFullName()
            local flowDirection = BoxLayoutElement.FLOW_VERTICAL
            local anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_MIDDLE

            EasyDevControlsDynamicSelectionDialog.show(headerText, properties, setPowerConsumer, nil, 2, flowDirection, anchorPosition)
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_setPowerConsumerWarning"), EasyDevControlsErrorCodes.UNKNOWN_FAIL)
        end
    end
end

function EasyDevControlsVehiclesFrame.getPowerConsumerProperties(spec)
    local powerConsumerProperties = {
        {
            name = "neededMinPtoPower",
            title = EasyDevControlsUtils.getText("easyDevControls_neededMinPtoPowerTitle"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
            ignoreEsc = true
        },
        {
            name = "neededMaxPtoPower",
            title = EasyDevControlsUtils.getText("easyDevControls_neededMaxPtoPowerTitle"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
            ignoreEsc = true
        },
        {
            name = "forceFactor",
            title = EasyDevControlsUtils.getText("easyDevControls_forceFactorTitle"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
            ignoreEsc = true
        },
        {
            name = "maxForce",
            title = EasyDevControlsUtils.getText("easyDevControls_maxForceTitle"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
            ignoreEsc = true
        },
        {
            name = "forceDir",
            title = EasyDevControlsUtils.getText("easyDevControls_forceDir"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
            texts = {"-1", "1"},
        },
        {
            name = "ptoRpm",
            title = EasyDevControlsUtils.getText("easyDevControls_ptoRpm"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
            ignoreEsc = true
        },
        {
            name = "syncVehicles",
            title = EasyDevControlsUtils.getText("easyDevControls_syncVehicles"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
            defaultValue = BinaryOptionElement.STATE_RIGHT,
            useYesNoTexts = true
        },
        {
            name = "resetToDefault",
            title = EasyDevControlsUtils.getText("easyDevControls_resetToDefault"),
            typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON,
            defaultValue = false
        }
    }

    for i, property in ipairs (powerConsumerProperties) do
        if spec ~= nil then
            local value = spec[property.name]

            if value ~= nil then
                if property.name == "forceDir" then
                    property.defaultValue = value < 0 and 1 or 2
                else
                    property.defaultValue = value
                end
            end
        end
    end

    return powerConsumerProperties
end

function EasyDevControlsVehiclesFrame.getSelectedImplementIsPowerConsumer(vehicle)
    if EasyDevControlsUtils.getIsValidVehicle(vehicle, "getSelectedImplement") then
        local selectedImplement = vehicle:getSelectedImplement()

        if selectedImplement ~= nil and selectedImplement.object.spec_powerConsumer ~= nil then
            return true, selectedImplement.object
        end
    end

    return false
end

-- Set Motor Temp
function EasyDevControlsVehiclesFrame:onMotorTempEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        local temperature = tonumber(textInputElement.text)

        if temperature ~= nil then
            local vehicle, _ = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

            self.intervalTimeRemaining = 500

            self:setInfoText(g_easyDevControls:setVehicleMotorTemperature(vehicle, temperature))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
        end

        textInputElement:setText("")
    end

    textInputElement.lastValidText = ""
end

-- Set Operating Time
function EasyDevControlsVehiclesFrame:onOperatingTimeEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        local operatingTime = tonumber(textInputElement.text)

        if operatingTime ~= nil then
            local vehicle, _ = g_easyDevControls:getVehicle(false, false, self.currentVehicleUniqueId)

            self.intervalTimeRemaining = 500

            self:setInfoText(g_easyDevControls:setVehicleOperatingTime(vehicle, operatingTime))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
        end

        textInputElement:setText("")
    end

    textInputElement.lastValidText = ""
end

function EasyDevControlsVehiclesFrame:onOperatingTimeTextChanged(textInputElement, text)
    if not string.isNilOrWhitespace(text) then
        local value = tonumber(text)

        if value ~= nil and value >= 0 then
            textInputElement.lastValidText = text
        else
            textInputElement:setText(textInputElement.lastValidText or "")
        end
    else
        textInputElement.lastValidText = ""
    end
end

-- Remove All Vehicles
function EasyDevControlsVehiclesFrame:onClickConfirmRemoveAllVehicles(buttonElement)
    local function removeAllVehicles(yes)
        if yes then
            self.buttonConfirmRemoveAllVehicles:setDisabled(true)
            self:setInfoText(g_easyDevControls:removeAllObjects(EasyDevControlsObjectTypes.VEHICLE))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.CANCELLED)
        end
    end

    local text = EasyDevControlsUtils.formatText("easyDevControls_removeAllObjectsWarning", EasyDevControlsUtils.getText("easyDevControls_typeVehicles"))
    YesNoDialog.show(removeAllVehicles, nil, text, "", g_i18n:getText("button_continue"), g_i18n:getText("button_cancel"))
end

-- Wipers
function EasyDevControlsVehiclesFrame:onClickGlobalWiperState(state, multiTextOptionElement)
    local wipersForcedState = state - 2

    if self.wipersForcedState == wipersForcedState then
        return
    end

    self.updatingDebugState = true

    self.wipersForcedState = wipersForcedState
    Wipers.forcedState = EasyDevControlsUtils.getNoNilClamp(wipersForcedState, -1, 999, -1)

    local extraText = ""

    if state == 1 then
        extraText = "(" .. EasyDevControlsUtils.getText("easyDevControls_default") .. ")"
    end

    self:setInfoText(string.format("%s: %s%s", EasyDevControlsUtils.getText("easyDevControls_globalWiperStateTitle"), multiTextOptionElement.texts[state], extraText))

    self.updatingDebugState = false
end

-- Show Vehicle Distance
function EasyDevControlsVehiclesFrame:onClickShowVehicleDistance(state, binaryOptionElement)
    self.updatingDebugState = true

    self.showVehicleDistance = state == BinaryOptionElement.STATE_RIGHT
    g_currentMission.vehicleSystem:consoleCommandShowVehicleDistance(self.showVehicleDistance)

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_vehicleDistanceInfo", binaryOptionElement.texts[state]))

    self.updatingDebugState = false
end

-- Vehicle Debug
function EasyDevControlsVehiclesFrame:onClickVehicleDebug(state, multiTextOptionElement)
    local vehicleDebugState = state - 1

    if self.vehicleDebugState == vehicleDebugState then
        return
    end

    self.updatingDebugState = true

    self.vehicleDebugState = vehicleDebugState
    VehicleDebug.setState(vehicleDebugState)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_debugStateInfo", multiTextOptionElement.texts[state]))

    self.updatingDebugState = false
end

-- Tension Belts Debug
function EasyDevControlsVehiclesFrame:onClickTensionBeltsDebug(state, binaryOptionElement)
    self.updatingDebugState = true

    self.tensionBeltDebugRendering = state == BinaryOptionElement.STATE_RIGHT
    TensionBelts.debugRendering = self.tensionBeltDebugRendering
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_tensionBeltsDebugInfo", binaryOptionElement.texts[state]))

    self.updatingDebugState = false
end

-- Wetness Debug
function EasyDevControlsVehiclesFrame:onClickWetnessDebug(state, binaryOptionElement)
    self.updatingDebugState = true

    self.wetnessDebugState = state == BinaryOptionElement.STATE_RIGHT

    if self.wetnessDebugState ~= VehicleDebug.wetnessDebugState then
        -- If the player is on foot and has a vehicle targeted then use the radius to that vehicle so it is reloaded
        if g_localPlayer == nil or g_localPlayer:getCurrentVehicle() == nil then
            local consoleCommandReloadVehicle = VehicleSystem.consoleCommandReloadVehicle

            VehicleSystem.consoleCommandReloadVehicle = function(vehicleSystem, resetVehicle, radius)
                local targetedVehicle = nil

                if self.currentVehicleUniqueId ~= nil and vehicleSystem.vehicleByUniqueId ~= nil then
                    targetedVehicle = vehicleSystem.vehicleByUniqueId[self.currentVehicleUniqueId]
                end

                if targetedVehicle ~= nil then
                    local px, py, pz = g_localPlayer:getPosition()
                    local vx, vy, vz = getWorldTranslation(targetedVehicle.rootNode)

                    radius = tostring(MathUtil.vector3Length(vx - px, vy - py, vz - pz) + 0.2)

                    return consoleCommandReloadVehicle(vehicleSystem, resetVehicle, radius)
                end
            end

            VehicleDebug.consoleCommandWetnessDebug()

            if VehicleDebug.wetnessDebugState then
                executeConsoleCommand("gsVehicleReload")
            end

            -- Restore the original command
            VehicleSystem.consoleCommandReloadVehicle = consoleCommandReloadVehicle
        else
            VehicleDebug.consoleCommandWetnessDebug()
        end

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_wetnessDebugInfo", binaryOptionElement.texts[state]))
    end

    self.updatingDebugState = false
end

-- Shared

function EasyDevControlsVehiclesFrame.getNumSelectableObjects(vehicle)
    local numSelectableObjects = 0

    if vehicle ~= nil and vehicle.selectableObjects ~= nil and vehicle.getCanToggleSelectable ~= nil and vehicle:getCanToggleSelectable() then
        for _, object in ipairs(vehicle.selectableObjects) do
            numSelectableObjects = numSelectableObjects + 1 + #object.subSelections
        end
    end

    return numSelectableObjects
end
