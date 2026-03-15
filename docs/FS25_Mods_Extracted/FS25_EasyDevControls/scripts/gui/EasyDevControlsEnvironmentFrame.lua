--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-01

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

EasyDevControlsEnvironmentFrame = {}
EasyDevControlsEnvironmentFrame.NAME = "ENVIRONMENT"

EasyDevControlsEnvironmentFrame.CLEAR_TIRE_TRACKS_RADIUS = EasyDevControlsUtils.getRangeTable(0, 100)
EasyDevControlsEnvironmentFrame.MAX_CLEAR_TIRE_TRACKS_RADIUS = #EasyDevControlsEnvironmentFrame.CLEAR_TIRE_TRACKS_RADIUS

EasyDevControlsEnvironmentFrame.ADD_SALT_RADIUS = EasyDevControlsUtils.getDefaultRangeTable()
EasyDevControlsEnvironmentFrame.MAX_ADD_SALT_RADIUS = #EasyDevControlsEnvironmentFrame.ADD_SALT_RADIUS

local EasyDevControlsEnvironmentFrame_mt = Class(EasyDevControlsEnvironmentFrame, EasyDevControlsBaseFrame)

-- No translation as this is for debugging only and needs to replicate the XML in some way (TO_DO: Add more detail)
local WEATHER_VARIATION_TEXT = [[
variation:
  - weight: %d
  - minHours: %d
  - maxHours: %d
  - minTemperature: %d
  - maxTemperature: %d

clouds:
  - presetId: %s

rain:
  - presetId: %s

wind:
  - angle: %.3f
  - speed: %.3f
  - cirrusSpeedFactor: %.3f
]]

function EasyDevControlsEnvironmentFrame.register()
    local controller = EasyDevControlsEnvironmentFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsEnvironmentFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsEnvironmentFrame", controller, true)

    return controller
end

function EasyDevControlsEnvironmentFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsEnvironmentFrame_mt)

    self.pageName = EasyDevControlsEnvironmentFrame.NAME

    self:setCommandChangedCallback("setTime", EasyDevControlsEnvironmentFrame.onCommandChangedSetTime)

    return self
end

function EasyDevControlsEnvironmentFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsEnvironmentFrame.register()
end

function EasyDevControlsEnvironmentFrame:initialize()
    self.isServer = g_easyDevControls.isServer
    self.isMultiplayer = g_easyDevControls:getIsMultiplayer()

    self.multiWeatherSetAdd:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_set"),
        EasyDevControlsUtils.getText("easyDevControls_add")
    })

    local removeTireTracksRadiusTexts = EasyDevControlsUtils.getFormatedRangeTexts(EasyDevControlsEnvironmentFrame.CLEAR_TIRE_TRACKS_RADIUS, false, true)
    local allText = EasyDevControlsUtils.getText("easyDevControls_all")

    removeTireTracksRadiusTexts[1] = #allText <= 5 and allText or "All" -- Most translations work but it 5 characters is max to to fit in the slider
    self.optionSliderRemoveTireTracksRadius:setTexts(removeTireTracksRadiusTexts)

    self.optionSliderAddSaltRadius:setTexts(EasyDevControlsUtils.getFormatedRangeTexts(EasyDevControlsEnvironmentFrame.CLEAR_SALT_RADIUS, false, true))
end

function EasyDevControlsEnvironmentFrame:onFrameOpening()
    local messageCenter = g_messageCenter

    messageCenter:subscribe(MessageType.HOUR_CHANGED, self.onHourChanged, self)
    messageCenter:subscribe(MessageType.DAY_CHANGED, self.onDayChanged, self)
    messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.onPeriodChanged, self)
    messageCenter:subscribe(MessageType.PERIOD_LENGTH_CHANGED, self.onPeriodLengthChanged, self)

    if self.isServer and not self.isMultiplayer then
        messageCenter:subscribe(MessageType.SEASON_CHANGED, self.onSeasonChanged, self)
    end
end

function EasyDevControlsEnvironmentFrame:onUpdateCommands(resetToDefault)
    local currentMission = g_currentMission
    local environment = currentMission.environment
    local mpDisabled = self.isMultiplayer or not self.isServer

    -- Time Set
    self:onCommandChangedSetTime("setTime", resetToDefault)

    -- Reload Environment Data
    self.buttonEnvironmentReloadData:setDisabled(mpDisabled)

    -- Reload Weather Data
    self.buttonWeatherReloadData:setDisabled(mpDisabled)

    -- Weather Set / Add
    self:updateWeatherData(environment)

    -- Remove Tire Tracks
    local removeTireTracksDisabled = currentMission == nil or currentMission.tireTrackSystem == nil

    self.optionSliderRemoveTireTracksRadius:setState(1)
    self.optionSliderRemoveTireTracksRadius:setDisabled(removeTireTracksDisabled)
    self.buttonRemoveTireTracks:setDisabled(removeTireTracksDisabled)

    local updateSnowDisabled = not self:getHasPermission("updateSnow")

    -- Add Snow
    self.buttonAddSnow:setDisabled(updateSnowDisabled)

    -- Remove Snow
    self.buttonRemoveSnow:setDisabled(updateSnowDisabled)

    -- Set Snow
    self.textInputSetSnow.lastValidText = ""
    self.textInputSetSnow:setText("")
    self.textInputSetSnow:setDisabled(updateSnowDisabled)

    -- Add Salt
    local saltDisabled = not self:getHasPermission("addSalt")

    self.optionSliderAddSaltRadius:setState(1)
    self.optionSliderAddSaltRadius:setDisabled(saltDisabled)
    self.buttonConfirmAddSalt:setDisabled(saltDisabled)

    -- Weather Debug, Seasonal Shader Debug
    local weatherDebugEnabled = Weather.DEBUG_ENABLED
    local debugSeasonalShaderParameter = environment.debugSeasonalShaderParameter

    if resetToDefault then
        weatherDebugEnabled = false
        debugSeasonalShaderParameter = false
    end

    self.binaryWeatherDebug:setIsChecked(weatherDebugEnabled, self.isOpening, resetToDefault)
    self.binarySeasonalShaderDebug:setIsChecked(debugSeasonalShaderParameter, self.isOpening, resetToDefault)

    -- Environment Mask System Debug
    if environment.environmentMaskSystem ~= nil then
        local isDebugViewActive = environment.environmentMaskSystem.isDebugViewActive

        if resetToDefault then
            isDebugViewActive = false
        end

        self.binaryEnvironmentMaskDebug:setIsChecked(isDebugViewActive, self.isOpening, resetToDefault)
        self.binaryEnvironmentMaskDebug:setDisabled(false)
    else
        self.binaryEnvironmentMaskDebug:setIsChecked(false, self.isOpening)
        self.binaryEnvironmentMaskDebug:setDisabled(true)
    end

    -- Random Wind Waving
    if EasyDevControlsEnvironmentFrame.getWeatherIsLoaded() then
        local weather = g_currentMission.environment.weather
        local randomWindWaving = true

        if not resetToDefault and (weather and weather.windUpdater ~= nil) then
            randomWindWaving = weather.windUpdater.randomWindWaving
        end

        self.binaryRandomWindWaving:setIsChecked(randomWindWaving, self.isOpening, resetToDefault)
    end

    self.binaryRandomWindWaving:setDisabled(mpDisabled)

    -- Tire Track Debug
    local tyreTrackDebugEnabled = TireTrackSystem.addTrackPointFuncBackup ~= nil

    if resetToDefault then
        tyreTrackDebugEnabled = false
    end

    self.binaryTireTrackDebug:setIsChecked(tyreTrackDebugEnabled, self.isOpening, resetToDefault)
    self.binaryTireTrackDebug:setDisabled(removeTireTracksDisabled)
end

-- Set Time (Month | Day | Hour)
function EasyDevControlsEnvironmentFrame:onCommandChangedSetTime(name, resetToDefault)
    local environment = g_currentMission.environment
    local setTimeDisabled = not self:getHasPermission(name)

    self.setTimeDisabled = setTimeDisabled

    self.multiSetMonth:setState(EasyDevControlsEnvironmentFrame.getMonthFromPeriod(environment.currentPeriod))
    self:onPeriodLengthChanged(environment.daysPerPeriod)
    self.optionSliderSetHour:setState(environment.currentHour + 2)

    self.multiSetMonth:setDisabled(setTimeDisabled)
    self.optionSliderSetHour:setDisabled(setTimeDisabled)
    self.buttonConfirmTime:setDisabled(setTimeDisabled)
end

function EasyDevControlsEnvironmentFrame:onClickConfirmTime(buttonElement)
    local maxTimeScale = self.isMultiplayer and 1 or 120 -- FS22: Need to limit so that the season can catch up especially in MP

    if g_currentMission.missionInfo.timeScale <= maxTimeScale then
        local environment = g_currentMission.environment
        local daysPerPeriod = environment.daysPerPeriod
        local currentDayInPeriod = environment.currentDayInPeriod
        local currentMonth = EasyDevControlsEnvironmentFrame.getMonthFromPeriod()

        local showWarning = false
        local daysToAdvance  = 0

        local monthToSet = self.multiSetMonth:getState()
        local dayToSet = self.multiSetDay:getState()
        local hourToSet = self.optionSliderSetHour:getState() - 1

        if monthToSet == currentMonth then
            if dayToSet > currentDayInPeriod then
                daysToAdvance = dayToSet - currentDayInPeriod
            elseif dayToSet < currentDayInPeriod then
                daysToAdvance = (12 * daysPerPeriod) + (dayToSet - currentDayInPeriod)
                showWarning = true
            elseif dayToSet == currentDayInPeriod and hourToSet <= environment.currentHour then
                daysToAdvance = 12 * daysPerPeriod
                showWarning = true
            end
        else
            daysToAdvance = (((12 - currentMonth) + monthToSet) % 12) * daysPerPeriod

            if dayToSet > currentDayInPeriod then
                daysToAdvance = daysToAdvance + (dayToSet - 1)
            elseif dayToSet < currentDayInPeriod then
                daysToAdvance = daysToAdvance + (dayToSet - currentDayInPeriod)
            end

            showWarning = daysToAdvance >= daysPerPeriod
        end

        local function setCurrentTime(yes)
            if yes then
                self:setInfoText(g_easyDevControls:setCurrentTime(hourToSet, daysToAdvance))

                if not self.isMultiplayer then
                    self.optionSliderSetHour:setState(EasyDevControlsEnvironmentFrame.getNextHour(environment.currentHour) + 1, true)
                    self:onSeasonChanged(environment.currentSeason) -- Update the available weather types
                end
            end
        end

        if not showWarning then
            setCurrentTime(true)
        else
            local numMonths = math.floor(daysToAdvance / daysPerPeriod)
            local numDays = ((daysToAdvance / daysPerPeriod) - numMonths) * daysPerPeriod

            YesNoDialog.show(setCurrentTime, nil, EasyDevControlsUtils.formatText("easyDevControls_setTimeWarning", g_i18n:formatNumMonth(numMonths), g_i18n:formatNumDay(numDays)))
        end
    else
        local timeScaleText = "120x"

        if maxTimeScale == 1 then
            timeScaleText = g_i18n:getText("ui_realTime")
        end

        -- InfoDialog.show(EasyDevControlsUtils.formatText("easyDevControls_timeScaleWarning", timeScaleText), self.requestCloseCallback, nil, DialogElement.TYPE_INFO)
        InfoDialog.show(EasyDevControlsUtils.formatText("easyDevControls_timeScaleWarning", timeScaleText), nil, nil, DialogElement.TYPE_INFO)
    end
end

-- Reload Weather / Environment Data
function EasyDevControlsEnvironmentFrame:onClickConfirmReloadData(buttonElement)
    if EasyDevControlsEnvironmentFrame.getWeatherIsLoaded() then
        local currentMission = g_currentMission
        local environment = currentMission.environment

        if buttonElement.name == "environmentReload" then
            currentMission.ambientSoundSystem:consoleCommandReload() -- Reload the sounds also as this may have also changed.

            if environment.weather and environment.weather.rainUpdater ~= nil then
                environment.weather.rainUpdater:reset() -- Avoid log warnings and also allows for modifications
            end

            environment:consoleCommandReloadEnvironment()

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_reloadedEnvironmentDataInfo", environment.xmlFilename))
        elseif buttonElement.name == "weatherReload" then
            currentMission.ambientSoundSystem:consoleCommandReload() -- Reload the sounds also as this may have also changed.
            environment.weather:consoleCommandWeatherReloadData()

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_reloadedWeatherDataInfo", environment.xmlFilename))
        end

        buttonElement:setDisabled(true)
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"))
    end
end

-- Weather Set / Add
function EasyDevControlsEnvironmentFrame:updateWeatherData(environment)
    local setAddWeatherDisabled = not self.isServer or self.isMultiplayer
    local variationText = EasyDevControlsUtils.getText("easyDevControls_variation")

    local typeState =  1
    local variationState = 1
    local setAddState = 1

    if environment == nil then
        environment = g_currentMission.environment
    end

    if not setAddWeatherDisabled and self.currentSeason == environment.currentSeason then
        typeState = self.multiWeatherType:getState()
        variationState = self.multiWeatherVariation:getState()
        setAddState = self.multiWeatherSetAdd:getState()
    end

    self.currentSeason = environment.currentSeason
    self.setAddWeatherDisabled = setAddWeatherDisabled

    local numSeasonWeatherTypes = table.size(environment.weather.typeToWeatherObject[self.currentSeason])

    self.weatherTypes = table.create(numSeasonWeatherTypes)
    self.weatherTypeTexts = table.create(numSeasonWeatherTypes)

    self.weatherTypeVariations = table.create(numSeasonWeatherTypes)
    self.weatherVariationTexts = table.create(numSeasonWeatherTypes)

    -- Only load the available weather types for the current season
    for weatherTypeIndex, weatherTypeObject in pairs(environment.weather.typeToWeatherObject[self.currentSeason]) do
        local weatherTypeName = WeatherType.getName(weatherTypeIndex)

        local variations = {
            0
        }

        local variationTexts = {
            EasyDevControlsUtils.getText("easyDevControls_random")
        }

        for _, variation in pairs (weatherTypeObject.variations) do
            table.insert(variations, variation.index)
            table.insert(variationTexts, string.format("%s %i", variationText, variation.index))
        end

        table.insert(self.weatherTypes, weatherTypeName)
        table.insert(self.weatherTypeTexts, EasyDevControlsUtils.getWeatherTypeText(weatherTypeName))

        table.insert(self.weatherTypeVariations, variations)
        table.insert(self.weatherVariationTexts, variationTexts)

        if setAddWeatherDisabled then
            typeState = 1
            variationState = 1

            break
        end
    end

    if typeState > #self.weatherTypes then
        typeState = 1
    end

    if variationState > #self.weatherVariationTexts[typeState] then
        variationState = 1
    end

    self.multiWeatherSetAdd:setState(setAddState)
    self.textWeatherSetAdd:setText(EasyDevControlsUtils.formatText("easyDevControls_setAddWeatherTitle", self.multiWeatherSetAdd.texts[setAddState]))

    self.multiWeatherType:setTexts(self.weatherTypeTexts)
    self.multiWeatherType:setState(typeState)
    self.multiWeatherVariation:setTexts(self.weatherVariationTexts[typeState])
    self.multiWeatherVariation:setState(variationState)

    self.multiWeatherSetAdd:setDisabled(setAddWeatherDisabled)
    self.multiWeatherType:setDisabled(setAddWeatherDisabled)
    self.multiWeatherVariation:setDisabled(setAddWeatherDisabled or EasyDevControlsUtils.getIsCheckedState(setAddState))
    self.buttonVariationInfo:setDisabled(setAddWeatherDisabled)
    self.buttonConfirmWeather:setDisabled(setAddWeatherDisabled)
end

function EasyDevControlsEnvironmentFrame:onClickWeatherSetAdd(state, multiTextOptionElement)
    local isDisabled = self.setAddWeatherDisabled or EasyDevControlsUtils.getIsCheckedState(state)

    self.textWeatherSetAdd:setText(EasyDevControlsUtils.formatText("easyDevControls_setAddWeatherTitle", multiTextOptionElement.texts[state]))
    self.multiWeatherVariation:setDisabled(isDisabled)

    if isDisabled then
        self.multiWeatherVariation:setState(1)
    end
end

function EasyDevControlsEnvironmentFrame:onClickWeatherType(state, multiTextOptionElement)
    self.multiWeatherVariation:setTexts(self.weatherVariationTexts[state])
    self.multiWeatherVariation:setState(1)
end

function EasyDevControlsEnvironmentFrame:onClickVariationInfo(buttonElement)
    if EasyDevControlsEnvironmentFrame.getWeatherIsLoaded() then
        local weather = g_currentMission.environment.weather
        local weatherTypeName = self.weatherTypes[self.multiWeatherType:getState()]
        local weatherType = WeatherType.getByName(weatherTypeName)

        if weatherType ~= nil then
            local weatherTypeObject = weather.typeToWeatherObject[self.currentSeason][weatherType]

            if weatherTypeObject ~= nil then
                local variationText = EasyDevControlsUtils.getText("easyDevControls_variation")
                local list = table.create(#weatherTypeObject.variations)

                for _, variation in ipairs (weatherTypeObject.variations) do
                    local cloudsPresetId = variation.clouds ~= nil and variation.clouds.id or "N/A"
                    local rainPresetId = variation.rainPresetId or "N/A"

                    table.insert(list, {
                        overlayColour = EasyDevControlsGuiManager.OVERLAY_COLOUR,
                        title = string.format("%s %i", variationText, variation.index),
                        text = string.format(
                            WEATHER_VARIATION_TEXT,
                            variation.weight,
                            variation.minHours,
                            variation.maxHours,
                            variation.minTemperature,
                            variation.maxTemperature,
                            cloudsPresetId,
                            rainPresetId,
                            variation.wind.windAngle,
                            MathUtil.mpsToKmh(variation.wind.windVelocity),
                            variation.wind.cirrusSpeedFactor
                        )
                    })
                end

                EasyDevControlsDynamicListDialog.show(string.format("%s '%s' %s", EasyDevControlsUtils.getSeasonText(self.currentSeason or 0), weatherTypeName, EasyDevControlsUtils.getText("easyDevControls_variations")), list)

                return
            end
        end
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
end

function EasyDevControlsEnvironmentFrame:onClickConfirmWeather(buttonElement)
    local weatherType = self.multiWeatherType:getState()
    local weatherTypeName = self.weatherTypes[weatherType]

    if weatherType ~= nil and EasyDevControlsEnvironmentFrame.getWeatherIsLoaded() then
        local weather = g_currentMission.environment.weather

        if EasyDevControlsUtils.getIsCheckedState(self.multiWeatherSetAdd:getState()) then
            local resultText = weather:consoleCommandWeatherAdd(weatherTypeName)

            if resultText:sub(1, 3) == "Add" then
                self:setInfoText(resultText, EasyDevControlsErrorCodes.SUCCESS)

                return
            end
        else
            -- Console command was breaking the Forecast so added my own set weather
            local variationState = self.multiWeatherVariation:getState()
            local variationIndex

            if variationState > 1 then
                variationIndex = self.weatherTypeVariations[weatherType][variationState]
            end

            local currentInstance = weather.forecastItems[1]
            local currentObject

            if currentInstance ~= nil then
                currentObject = weather:getWeatherObjectByIndex(currentInstance.season, currentInstance.objectIndex)
            end

            weatherType = WeatherType.getByName(weatherTypeName)

            if weatherType ~= nil then
                local environment = g_currentMission.environment
                local currentSeason = environment.currentSeason
                local weatherObject = weather.typeToWeatherObject[currentSeason][weatherType]

                if weatherObject ~= nil then
                    local variation = weatherObject:getVariationByIndex(variationIndex)

                    if variation == nil then
                        variation = weatherObject:getVariationByIndex(weatherObject:getRandomVariationIndex())
                    end

                    local duration = math.random(variation.minHours, variation.maxHours) * 60 * 60 * 1000
                    local startDay, startDayTime = environment:getDayAndDayTime(environment.dayTime, environment.currentMonotonicDay)

                    weather.forecastItems = {
                        WeatherInstance.createInstance(weatherObject.index, variation.index, startDay, startDayTime, duration, currentSeason)
                    }

                    weather:fillWeatherForecast() -- create the rest of the forecast

                    if currentObject ~= nil then
                        currentObject:deactivate(1) -- deactivate original
                        currentObject:update(99999999) -- push update to finalise
                    end

                    weather:init() -- reset environment factors for new forecast

                    self:setInfoText(string.format("Weather set to '%s'", weatherTypeName:upper())) -- No translation so it matches the 'ADD' console command.

                    return
                end
            end
        end
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
end

-- Remove Tire Tracks
function EasyDevControlsEnvironmentFrame:onClickRemoveTireTracks(buttonElement)
    if g_currentMission.tireTrackSystem ~= nil then
        local radiusState = self.optionSliderRemoveTireTracksRadius:getState()

        if radiusState == 1 then
            local halfTerrainSize  = g_currentMission.terrainSize / 2 + 1

            g_currentMission.tireTrackSystem:eraseParallelogram(-halfTerrainSize, -halfTerrainSize, halfTerrainSize, -halfTerrainSize, -halfTerrainSize, halfTerrainSize)
            executeConsoleCommand("vtRedrawAll")

            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_removeAllTireTracksInfo"))
        else
            local radius = EasyDevControlsEnvironmentFrame.CLEAR_TIRE_TRACKS_RADIUS[radiusState]
            local x, _, z = EasyDevControlsUtils.getPlayerWorldLocation()

            -- g_currentMission.tireTrackSystem:eraseParallelogram(x - radius, z - radius, x + radius, z - radius, x - radius, z + radius)
            g_currentMission.tireTrackSystem:eraseParallelogram(EasyDevControlsUtils.getArea(x, z, radius))
            executeConsoleCommand("vtRedrawAll")

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_removeTireTracksInfo", self.optionSliderRemoveTireTracksRadius.texts[radiusState]))
        end
    else
        self:setInfoText(string.format("%s (tireTrackSystem == nil)", EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage")))
    end
end

-- Add / Remove Snow
function EasyDevControlsEnvironmentFrame:onClickAddRemoveSnow(buttonElement)
    self:setInfoText(g_easyDevControls:updateSnowAndSalt(EasyDevControlsUpdateSnowAndSaltEvent[buttonElement.name]))
end

-- Set Snow
function EasyDevControlsEnvironmentFrame:onSetSnowEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        self:setInfoText(g_easyDevControls:updateSnowAndSalt(EasyDevControlsUpdateSnowAndSaltEvent.SET_SNOW, tonumber(textInputElement.text)))

        textInputElement:setText("")
    end

    textInputElement.lastValidText = ""
end

function EasyDevControlsEnvironmentFrame:onSetSnowTextChanged(textInputElement, text)
    if text ~= "" then
        local value = tonumber(text)

        if #text == 1 and text == "-" then
            textInputElement.lastValidText = text
        elseif value ~= nil then
            if value > SnowSystem.MAX_HEIGHT then
                textInputElement.lastValidText = tostring(SnowSystem.MAX_HEIGHT)
                textInputElement:setText(textInputElement.lastValidText)
            elseif value < -4 then
                textInputElement.lastValidText = "-4"
                textInputElement:setText(textInputElement.lastValidText)
            end

            textInputElement.lastValidText = text
        else
            textInputElement:setText(textInputElement.lastValidText)
        end
    else
        textInputElement.lastValidText = ""
    end
end

-- Add Salt
function EasyDevControlsEnvironmentFrame:onClickConfirmAddSalt(buttonElement)
    local state = self.optionSliderAddSaltRadius:getState()
    local radius =  EasyDevControlsEnvironmentFrame.ADD_SALT_RADIUS[state] or 5

    self:setInfoText(g_easyDevControls:updateSnowAndSalt(EasyDevControlsUpdateSnowAndSaltEvent.ADD_SALT, radius, g_localPlayer))
end

-- Weather Debug
function EasyDevControlsEnvironmentFrame:onClickWeatherDebug(state, multiTextOptionElement)
    if Weather.DEBUG_ENABLED ~= EasyDevControlsUtils.getIsCheckedState(state) then
        g_currentMission.environment.weather:consoleCommandWeatherToggleDebug()
    end

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_weatherDebugInfo", multiTextOptionElement.texts[state]:lower()))
end

-- Seasonal Shader Debug
function EasyDevControlsEnvironmentFrame:onClickSeasonalShaderDebug(state, binaryOptionElement)
    local environment = g_currentMission.environment

    if environment ~= nil then
        environment.debugSeasonalShaderParameter = EasyDevControlsUtils.getIsCheckedState(state)

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_seasonalShaderDebugInfo", binaryOptionElement.texts[state]:lower()))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Environment Mask System Debug
function EasyDevControlsEnvironmentFrame:onClickEnvironmentMaskDebug(state, binaryOptionElement)
    local environment = g_currentMission.environment

    if environment.environmentMaskSystem ~= nil then
        if environment.environmentMaskSystem.isDebugViewActive ~= EasyDevControlsUtils.getIsCheckedState(state) then
            environment.environmentMaskSystem:consoleCommandToggleDebugView()
        end

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_environmentMaskDebugInfo", binaryOptionElement.texts[state]:lower()))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Random Wind Waving
function EasyDevControlsEnvironmentFrame:onClickRandomWindWaving(state, binaryOptionElement)
    if EasyDevControlsEnvironmentFrame.getWeatherIsLoaded() then
        local weather = g_currentMission.environment.weather

        if weather and weather.windUpdater then
            weather.windUpdater.randomWindWaving = EasyDevControlsUtils.getIsCheckedState(state)
        end

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_randomWindWavingInfo", binaryOptionElement.texts[state]:lower()))
    else
        binaryOptionElement:setChecked(false, true)
        binaryOptionElement:setDisabled(true)

        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Tire Track Debug
function EasyDevControlsEnvironmentFrame:onClickTireTrackDebug(state, binaryOptionElement)
    local enabled = TireTrackSystem.addTrackPointFuncBackup ~= nil

    if enabled ~= EasyDevControlsUtils.getIsCheckedState(state) then
        TireTrackSystem:consoleCommandTireTrackDebug()
    end

    self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_tireTrackDebugTitle"), binaryOptionElement.texts[state]))
end

-- Listeners
function EasyDevControlsEnvironmentFrame:onHourChanged(currentHour)
    self.optionSliderSetHour:setState(EasyDevControlsEnvironmentFrame.getNextHour(currentHour) + 1, true)
end

function EasyDevControlsEnvironmentFrame:onDayChanged(currentDay)
    local environment = g_currentMission.environment

    if environment.daysPerPeriod > 1 then
        self.multiSetDay:setState(environment.currentDayInPeriod, true)
    end
end

function EasyDevControlsEnvironmentFrame:onPeriodChanged(currentPeriod)
    self.multiSetMonth:setState(EasyDevControlsEnvironmentFrame.getMonthFromPeriod(currentPeriod))
end

function EasyDevControlsEnvironmentFrame:onPeriodLengthChanged(daysPerPeriod)
    local dayText = g_i18n:getText("ui_day")
    local daysPerPeriodTexts = table.create(daysPerPeriod)

    for i = 1, daysPerPeriod do
        table.insert(daysPerPeriodTexts, string.format("%s %d", dayText, i))
    end

    self.multiSetDay:setTexts(daysPerPeriodTexts)
    self.multiSetDay:setState(g_currentMission.environment.currentDayInPeriod, true)
    self.multiSetDay:setDisabled(self.setTimeDisabled or daysPerPeriod == 1)
end

function EasyDevControlsEnvironmentFrame:onSeasonChanged(currentSeason)
    if self.currentSeason ~= currentSeason then
        self.buttonVariationInfo:setDisabled(true)
        self.buttonConfirmWeather:setDisabled(true)

        self:updateWeatherData(g_currentMission.environment)
    end
end

-- Shared
function EasyDevControlsEnvironmentFrame.getNextHour(currentHour)
    if currentHour == nil then
        currentHour = g_currentMission.environment.currentHour
    end

    return (currentHour + 1) % 24
end

function EasyDevControlsEnvironmentFrame.getMonthFromPeriod(currentPeriod)
    local environment = g_currentMission.environment

    if currentPeriod == nil then
        currentPeriod = environment.currentPeriod
    end

    local month = currentPeriod + 2

    if environment.daylight.latitude < 0 then
        month = month + 6
    end

    return (month - 1) % 12 + 1
end

function EasyDevControlsEnvironmentFrame.getWeatherIsLoaded()
    local currentMission = g_currentMission

    return not (currentMission == nil or currentMission.environment == nil or currentMission.environment.weather == nil)
end
