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

local validationFail
local easyDevControls

local modName = g_currentModName
local modDirectory = g_currentModDirectory
local modSettingsDirectory = g_modSettingsDirectory

local buildId = 1.2
local versionString = "0.0.0.0"
local releaseType = "GIANTS MODHUB"

local consoleCommandsGtX = StartParams.getIsSet("consoleCommandsGtX") -- Extra GtX console commands
local reloadInputActionGtX = StartParams.getValue("reloadInputActionGtX") -- Enables the fast quit game Input Binding (lctrl + lshift + r)
                                                                          -- Optional Parameters separated by a single space: visible clearLog restartProcess

local function isActive()
    return easyDevControls ~= nil and g_modIsLoaded[modName]
end

local function isDebuggerActive()
    return isActive() and easyDevControls.debugger ~= nil
end

local function validateMod()
    local mod = g_modManager:getModByName(modName)

    -- g_isEditor is part of my debugger for mod testing in GE. Added here in case the GE script is released to the public.
    if mod == nil or g_iconGenerator ~= nil or g_isEditor then
        return false
    end

    versionString = mod.version or versionString

    if mod.modName == "FS25_EasyDevControls" or mod.modName == "FS25_EasyDevControls_update" then
        if mod.author ~= nil and #mod.author == 3 then
            return true
        end
    end

    local validationText = "This mod is outdated and not working properly. Please update the mod first!"

    if g_i18n:hasText("ui_modsCannotActivateBlockedModUpdate") then
        validationText = g_i18n:getText("ui_modsCannotActivateBlockedModUpdate")
    end

    validationText = string.format("- %s -\n\n%s", mod.modName, validationText)

    validationFail = {
        startUpdateTime = 2000,

        update = function(self, dt)
            self.startUpdateTime = self.startUpdateTime - dt

            if self.startUpdateTime < 0 then
                if g_dedicatedServer == nil then
                    if not g_gui:getIsGuiVisible() then
                        local yesText = g_i18n:getText("button_modHubDownload")
                        local noText = g_i18n:getText("button_ok")

                        YesNoDialog.show(self.openModHubLink, nil, validationText, mod.title, yesText, noText, DialogElement.TYPE_WARNING)
                    end
                else
                    print("\n" .. validationText .. "\n    - https://farming-simulator.com/mods.php?&title=fs2025&filter=org&org_id=129652&page=0" .. "\n")
                    self.openModHubLink(false)
                end
            end
        end,

        openModHubLink = function(yes)
            if yes then
                openWebFile("mods.php?title=fs2025&filter=org&org_id=129652&page=0", "")
            end

            removeModEventListener(validationFail)
            validationFail = nil
        end
    }

    addModEventListener(validationFail)

    return false
end

local function createFirstLoadDialog()
    if g_dedicatedServer ~= nil or g_currentMission.hud == nil or not g_i18n:hasText("easyDevControls_firstLoadInfo", modName) then
        return
    end

    local infoText = string.format("\n" .. EasyDevControlsUtils.getText("easyDevControls_firstLoadInfo"))

    local controls = {
        g_inputDisplayManager:getControllerSymbolOverlays(InputAction["EDC_SHOW_UI"], nil, EasyDevControlsUtils.getText("input_EDC_SHOW_UI")),
        g_inputDisplayManager:getControllerSymbolOverlays(InputAction["EDC_TOGGLE_HUD"], nil, EasyDevControlsUtils.getText("input_EDC_TOGGLE_HUD")),
        g_inputDisplayManager:getControllerSymbolOverlays(InputAction["EDC_OBJECT_DELETE"], nil, EasyDevControlsUtils.getText("input_EDC_OBJECT_DELETE")),
        g_inputDisplayManager:getControllerSymbolOverlays(InputAction["EDC_PLAYER_RUN_SPEED"], nil, EasyDevControlsUtils.getText("input_EDC_PLAYER_RUN_SPEED")),
        g_inputDisplayManager:getControllerSymbolOverlays(InputAction["EDC_SUPER_STRENGTH"], nil, EasyDevControlsUtils.getText("input_EDC_SUPER_STRENGTH"))
    }

    local firstLoadDialog = {
        startUpdateTime = 2500,
        canDisplayMessage = true,

        update = function(self, dt)
            self.startUpdateTime = self.startUpdateTime - dt

            if self.startUpdateTime < 0 and self.canDisplayMessage and not g_gui:getIsGuiVisible() and not g_currentMission.hud:isInGameMessageVisible() then
                g_currentMission.hud:showInGameMessage("Easy Development Controls", infoText, -1, controls, nil, nil)
                removeModEventListener(self)
                self.canDisplayMessage = false
            end
        end
    }

    addModEventListener(firstLoadDialog)
end

local function saveToXMLFile(missionInfo)
    if isActive() and missionInfo.isValid then
        local xmlFilename = missionInfo.savegameDirectory .. "/easyDevControls.xml"
        local xmlFile = XMLFile.create("easyDevControlsXML", xmlFilename, "easyDevControls", EasyDevControls.xmlSchema)

        if xmlFile ~= nil then
            -- Bug report information
            xmlFile:setFloat("easyDevControls#buildId", buildId)
            xmlFile:setString("easyDevControls#version", versionString)
            xmlFile:setString("easyDevControls#type", releaseType)

            if easyDevControls.saveToXMLFile ~= nil then
                easyDevControls:saveToXMLFile(xmlFile, "easyDevControls", missionInfo)
            end

            if g_easyDevControlsSettings ~= nil then
                g_easyDevControlsSettings:saveToXMLFile(xmlFile, "easyDevControls", missionInfo)
            end

            if g_easyDevControlsGuiManager ~= nil then
                g_easyDevControlsGuiManager:saveToXMLFile(xmlFile, "easyDevControls", missionInfo)
            end

            xmlFile:save()
            xmlFile:delete()
        end
    end
end

local function loadFromXMLFile(missionInfo)
    if isActive() then
        local xmlFilename = nil
        local firstTimeLoad = true
        local modSettingsDir = EasyDevControlsUtils.getSettingsDirectory(false)

        if not string.isNilOrWhitespace(modSettingsDir) then
            xmlFilename = modSettingsDir .. "defaultUserSettings.xml"
            firstTimeLoad = not fileExists(xmlFilename)

            if firstTimeLoad then
                createFolder(modSettingsDir)
                copyFile(modDirectory .. "shared/defaultUserSettings.xml", xmlFilename, false)

                createFirstLoadDialog()
            end
        end

        if not string.isNilOrWhitespace(xmlFilename) then
            local xmlFile = XMLFile.loadIfExists("easyDevControls", xmlFilename, EasyDevControls.xmlSchema)
            local valid = xmlFile ~= nil

            if valid then
                local userSettingsRevision = 3

                if not firstTimeLoad then
                    if xmlFile:getInt("easyDevControls#revision", 0) ~= userSettingsRevision then
                        -- Update from existing user settings unless something failed then just overwrite.
                        if g_easyDevControlsSettings ~= nil then
                            EasyDevControlsLogging.info("Loading version %s for the first time or user settings revision changed, 'defaultUserSettings.xml' has been updated to avoid errors.", versionString)

                            xmlFile, valid = g_easyDevControlsSettings:upgradeXMLFile(xmlFile, "easyDevControls", modDirectory .. "shared/defaultUserSettings.xml", xmlFilename)
                        else
                            EasyDevControlsLogging.info("Loading version %s for the first time or user settings revision changed, 'defaultUserSettings.xml' has been reset to avoid errors.", versionString)

                            xmlFile:delete()

                            copyFile(modDirectory .. "shared/defaultUserSettings.xml", xmlFilename, true)
                            xmlFile = XMLFile.loadIfExists("easyDevControls", xmlFilename, EasyDevControls.xmlSchema)

                            valid = xmlFile ~= nil
                        end
                    end
                end

                if valid then
                    if g_easyDevControlsSettings ~= nil then
                        g_easyDevControlsSettings:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, false)
                    end

                    if easyDevControls.loadFromXMLFile ~= nil then
                        easyDevControls:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, false)
                    end

                    if g_easyDevControlsGuiManager ~= nil then
                        g_easyDevControlsGuiManager:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, false)
                    end

                    xmlFile:delete()

                    EasyDevControlsLogging.info("Default user settings loaded successfully. (Revision: %d)", userSettingsRevision)
                else
                    EasyDevControlsLogging.warning("Failed to load default user settings, file may be missing!")
                end
            end
        end

        if easyDevControls.isServer and not string.isNilOrWhitespace(missionInfo.savegameDirectory) then
            xmlFilename = missionInfo.savegameDirectory .. "/easyDevControls.xml"

            local xmlFile = XMLFile.loadIfExists("easyDevControls", xmlFilename, EasyDevControls.xmlSchema)

            if xmlFile ~= nil then
                if g_easyDevControlsSettings ~= nil then
                    g_easyDevControlsSettings:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, true)
                end

                if easyDevControls.loadFromXMLFile ~= nil then
                    easyDevControls:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, true)
                end

                if g_easyDevControlsGuiManager ~= nil then
                    g_easyDevControlsGuiManager:loadFromXMLFile(xmlFile, "easyDevControls", missionInfo, true)
                end

                firstTimeLoad = false

                xmlFile:delete()
            end
        end

        return firstTimeLoad
    end

    return false
end

local function loadSharedColours()
    local easyDevControlsColours = {}

    local xmlFilename = modDirectory .. "shared/colours.xml"

    if fileExists(xmlFilename) then
        local xmlFile = loadXMLFile("coloursXML", xmlFilename)

        if xmlFile ~= nil and xmlFile ~= 0 then
            local validMaterialNames = {
                calibratedGlossPaint = true,
                calibratedMetallicPaint = true,
                calibratedMatPaint = true
            }

            local i = 0

            while true do
                local key = string.format("colours.colour(%d)", i)

                if not hasXMLProperty(xmlFile, key) then
                    break
                end

                local title = getXMLString(xmlFile, key .. "#title")
                local value = getXMLString(xmlFile, key .. "#value")

                if title ~= nil and value ~= nil then
                    local colour = string.getVector(value, 3)

                    if colour ~= nil then
                        local name = EasyDevControlsUtils.convertText(title)
                        local price = Utils.getNoNil(getXMLInt(xmlFile, key .. "#price"), 0)

                        local materialName = getXMLString(xmlFile, key .. "#materialName")

                        if materialName ~= nil and validMaterialNames[materialName] == nil then
                            materialName = nil

                            EasyDevControlsLogging.xmlDevError(xmlFile, "Given material name '%s' for colour '%s' is not valid. Use: calibratedGlossPaint or calibratedMetallicPaint or calibratedMatPaint", materialName, key)
                        end

                        local params = getXMLString(xmlFile, key .. "#params")

                        if params ~= nil then
                            params = params:split("|")

                            for i = 1, #params do
                                params[i] = EasyDevControlsUtils.convertText(params[i])
                            end

                            name = string.format(name, unpack(params))
                        end

                        table.insert(easyDevControlsColours, {
                            name = name,
                            color = colour,
                            price = price,
                            materialName = materialName
                        })
                    else
                        EasyDevControlsLogging.xmlDevError(xmlFile, "Colour '%s' has invalid format. Should be 4 vector '- - - -', ignoring!", title)
                    end
                else
                    EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to load colour '%s', check title and value.", key)
                end

                i += 1
            end

            delete(xmlFile)
        end
    end

    if #easyDevControlsColours == 0 then
        table.insert(easyDevControlsColours, {
            name = string.format("Farming Innovations %s", g_i18n:getText("ui_colorGreen")),
            color = {0.0000, 0.2051, 0.0685},
            price = 0,
            materialName = "calibratedGlossPaint"
        })

        table.insert(easyDevControlsColours, {
            name = string.format("Farming Innovations %s", g_i18n:getText("ui_colorOrange")),
            color = {1.0000, 0.1413, 0.0000},
            price = 0,
            materialName = "calibratedGlossPaint"
        })

        if VehicleConfigurationItemColor ~= nil and VehicleConfigurationItemColor.DEFAULT_COLORS ~= nil then
            for i, brandMaterialName in ipairs(VehicleConfigurationItemColor.DEFAULT_COLORS) do
                local color, title = g_vehicleMaterialManager:getMaterialTemplateColorAndTitleByName(brandMaterialName, modName)

                if color ~= nil then
                    table.insert(easyDevControlsColours, {
                        name = title or "",
                        color = color,
                        price = 0,
                        materialName = "calibratedGlossPaint"
                    })
                end
            end
        end

        EasyDevControlsLogging.xmlDevError(xmlFilename, "Failed to load colours from XML, using %d backup colours instead.", #easyDevControlsColours)
    end

    return easyDevControlsColours
end

local function load(mission)
    if isActive() then
        g_easyDevControlsColours = loadSharedColours()

        easyDevControls:load(mission)

        if g_easyDevControlsHotspotsManager ~= nil then
            g_easyDevControlsHotspotsManager:setCurrentMission(mission)
        end

        if g_easyDevControlsGuiManager ~= nil then
            g_easyDevControlsGuiManager:load(mission)
        end

        if easyDevControls.debugger and easyDevControls.debugger.load ~= nil then
            easyDevControls.debugger:load(mission)
        end

        local firstTimeLoad = loadFromXMLFile(mission.missionInfo)
        -- EasyDevControlsLogging.devHitTarget("load", firstTimeLoad and "firstTimeLoad" or "noUserSettings")
    end
end

local function unload(mission)
    if isActive() then
        easyDevControls.isDeleting = true

        -- EasyDevControlsLogging.devHitTarget("unload", "started")

        if g_globalMods ~= nil then
            g_globalMods.easyDevControls = nil
        end

        if easyDevControls.debugger ~= nil then
            easyDevControls.debugger:delete(mission)
            easyDevControls.debugger = nil
        end

        if g_easyDevControlsHotspotsManager ~= nil then
            g_easyDevControlsHotspotsManager:delete()
        end

        if g_easyDevControlsGuiManager ~= nil then
            g_easyDevControlsGuiManager:delete()
            g_easyDevControlsGuiManager = nil
        end

        if g_easyDevControlsSettings ~= nil then
            g_easyDevControlsSettings:delete()
            g_easyDevControlsSettings = nil
        end

        if g_easyDevControlsDebugManager ~= nil then
            g_easyDevControlsDebugManager:delete()
            g_easyDevControlsDebugManager = nil
        end

        easyDevControls:delete()
        easyDevControls.guiManager = nil
        easyDevControls.settings = nil

        g_easyDevControls = nil
        easyDevControls = nil

        -- EasyDevControlsLogging.devHitTarget("unload", "finished")
    end
end

local function inGameMenuSetMissionInfo(inGameMenu, missionInfo, missionDynamicInfo, missionBaseDirectory)
    if isActive() then
        if missionDynamicInfo.isMultiplayer then
            g_easyDevControlsSimulateMultiplayer = nil
        end

        easyDevControls:onSetMissionInfo(missionInfo, missionDynamicInfo, missionBaseDirectory)

        if easyDevControls.guiManager ~= nil then
            easyDevControls.guiManager:onSetMissionInfo(missionInfo, missionDynamicInfo, missionBaseDirectory)
        end

        -- EasyDevControlsLogging.devHitTarget("inGameMenuSetMissionInfo")
    end
end

local function sendInitialClientState(_, connection, user, farm)
    if isActive() then
        easyDevControls:onSendInitialClientState(connection, user, farm)
    end
end

local function onFinishedLoading(mission)
    if isActive() then
        -- EasyDevControlsLogging.devHitTarget("onFinishedLoading")

        if easyDevControls.onMissionFinishedLoading ~= nil then
            easyDevControls:onMissionFinishedLoading(mission)
        end

        if easyDevControls.guiManager ~= nil then
            easyDevControls.guiManager:onMissionFinishedLoading(mission)
        end
    end
end

local function onStartMission(mission)
    if isActive() then
        local isNewSavegame = not mission.missionInfo.isValid

        g_asyncTaskManager:addTask(function ()
            if g_easyDevControlsSettings ~= nil then
                g_easyDevControlsSettings:onMissionStarted(isNewSavegame)
            end
        end)

        g_asyncTaskManager:addTask(function ()
            if g_easyDevControlsGuiManager ~= nil then
                g_easyDevControlsGuiManager:onMissionStarted(isNewSavegame)
            end
        end)

        g_asyncTaskManager:addTask(function ()
            easyDevControls:onMissionStarted(isNewSavegame)
            -- EasyDevControlsLogging.devHitTarget("onStartMission")
        end)
    end
end

local function registerGlobalPlayerActionEvents(playerInputComponent, contextName)
    if isActive() and playerInputComponent.player ~= nil and playerInputComponent.player.isOwner then
        -- The context here changes as this is called when on foot or in a vehicle
        local currentContextName = g_inputBinding:getContextName()
        local newContectName = contextName or currentContextName

        if currentContextName ~= newContectName then
            g_inputBinding:beginActionEventsModification(newContectName)
        end

        easyDevControls:registerGlobalActionEvents(playerInputComponent.player, g_inputBinding)

        if currentContextName ~= newContectName then
            g_inputBinding:beginActionEventsModification(currentContextName)
        end
    end
end

local function registerActionEvents(playerInputComponent)
    if isActive() and playerInputComponent.player ~= nil and playerInputComponent.player.isOwner then
        -- These are player only inputs so set that context
        g_inputBinding:beginActionEventsModification(PlayerInputComponent.INPUT_CONTEXT_NAME)
        easyDevControls:registerPlayerActionEvents(playerInputComponent.player, g_inputBinding)
        g_inputBinding:endActionEventsModification(g_easyDevControlsDevelopmentMode)
    end
end

local function unregisterActionEvents(playerInputComponent)
    if isActive() and playerInputComponent.player ~= nil and playerInputComponent.player.isOwner then
        -- These are player only inputs so set that context
        g_inputBinding:beginActionEventsModification(PlayerInputComponent.INPUT_CONTEXT_NAME)
        easyDevControls:unregisterPlayerActionEvents(playerInputComponent.player, g_inputBinding)
        g_inputBinding:endActionEventsModification(g_easyDevControlsDevelopmentMode)
    end
end

local function playerHUDUpdateFinished(hudUpdater, dt, x, y, z, yaw)
    if isActive() then
        easyDevControls:onPlayerHUDUpdateFinished(hudUpdater, dt, x, y, z, yaw, g_localPlayer)
    end
end

local function consoleCommandToggleSuperStrength(hands)
    if isActive() and hands.spec_hands ~= nil then
        easyDevControls:onSuperStrengthToggled(hands, hands.spec_hands.hasSuperStrength)
    end
end

local function updateRingSelector(handToolChainsaw, superFunc, targetedTree, ...)
    if not g_woodCuttingMarkerEnabled then
        targetedTree = nil -- Missing in base game at time of release.
    end

    superFunc(handToolChainsaw, targetedTree, ...)
end

local function cloudSettingsCopyAttributes(cloudSettings, src)
    cloudSettings.id = src.id -- Not cloned like RainUpdater
end

local function init()
    if g_globalMods == nil then
        g_globalMods = {}
    end

    if g_globalMods.easyDevControls ~= nil then
        Logging.error("Validation of '%s' failed, script set has already been loaded by '%s'.", modName, g_globalMods.easyDevControls.modName or "Unknown")

        return false
    end

    if validateMod() then
        -- MISC
        source(modDirectory .. "scripts/misc/EasyDevControlsAwaiter.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsLogging.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsUtils.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsSettings.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsDebugManager.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsHotspotsManager.lua")

        -- MESSAGE TYPES & ENUMS
        source(modDirectory .. "scripts/misc/EasyDevControlsAccessLevel.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsErrorCodes.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsObjectTypes.lua")
        source(modDirectory .. "scripts/misc/EasyDevControlsMessageTypes.lua")

        -- EVENTS
        source(modDirectory .. "scripts/events/EasyDevControlsAdminEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsPermissionsEvent.lua")

        -- TO_DO: Consolidate some of the Events into a single event using 'EVENT_TYPE_ID'
        source(modDirectory .. "scripts/events/EasyDevControlsMoneyEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsTimeScaleEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsTeleportEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsDeleteObjectEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsSuperStrengthEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsSpawnObjectEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsTipHeightTypeEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsClearHeightTypeEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsRemoveAllObjectsEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsSetFillUnitFillLevel.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsVehicleConditionEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsVehicleOperatingValueEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsObjectFarmChangeEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsSetProductionPointFillLevelsEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsTipFillTypeToTrigger.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsSetFieldEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsVineSystemSetStateEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsAddRemoveDeltaEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsUpdateSetGrowthPeriodEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsTimeEvent.lua")
        source(modDirectory .. "scripts/events/EasyDevControlsUpdateSnowAndSaltEvent.lua")

        -- Custom Elements
        source(modDirectory .. "scripts/gui/elements/EasyDevControlsTextInputElement.lua")

        -- Dialogs
        source(modDirectory .. "scripts/gui/dialogs/EasyDevControlsTeleportScreen.lua")
        source(modDirectory .. "scripts/gui/dialogs/EasyDevControlsDynamicListDialog.lua")
        source(modDirectory .. "scripts/gui/dialogs/EasyDevControlsDynamicSelectionDialog.lua")

        -- GUI (Standard)
        source(modDirectory .. "scripts/gui/EasyDevControlsMenu.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsBaseFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsGeneralFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsPlayerFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsObjectsFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsVehiclesFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsPlaceablesFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsFarmlandsFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsEnvironmentFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsPermissionsFrame.lua")
        source(modDirectory .. "scripts/gui/EasyDevControlsHelpFrame.lua")

        -- GUI Manager
        source(modDirectory .. "scripts/gui/base/EasyDevControlsGuiManager.lua")

        -- MANAGER
        source(modDirectory .. "scripts/EasyDevControls.lua")

        -- Initialise Settings
        g_easyDevControlsSettings = EasyDevControlsSettings.new(g_server ~= nil, g_client ~= nil)

        -- Initialise Manager
        easyDevControls = EasyDevControls.new(g_server ~= nil, g_client ~= nil, buildId, versionString, releaseType, consoleCommandsGtX)

        if easyDevControls ~= nil then
            --
            if reloadInputActionGtX ~= nil then
                easyDevControls.reloadInputActionEnabled = true
                easyDevControls.reloadInputActionVisibility = false
                easyDevControls.reloadInputActionClearLog = false
                easyDevControls.reloadInputActionRestartProcess = false

                if reloadInputActionGtX ~= "" then
                    local options = string.split(string.upper(reloadInputActionGtX), " ")

                    for _, option in ipairs (options) do
                        if option == "VISIBLE" then
                            easyDevControls.reloadInputActionVisibility = true
                        elseif option == "CLEARLOG" then
                            easyDevControls.reloadInputActionClearLog = true
                        elseif option == "RESTARTPROCESS" then
                            easyDevControls.reloadInputActionRestartProcess = true
                        end
                    end
                else
                    EasyDevControlsLogging.devInfo("No Parameters")
                end
            end

            --
            easyDevControls.settings = g_easyDevControlsSettings

            -- Set development mode if build is 0 or debugLevelGtX parameter is set, also handled by my debugger as required.
            if g_easyDevControlsDebugManager ~= nil then
                g_easyDevControlsDebugManager:setDevelopmentDebugLevel(StartParams.getValue("debugLevelGtX") or ((g_gtxDevelopmentMode or buildId == 0) and 4 or 0))
            end

            -- Initialise Hotspots Manager
            g_easyDevControlsHotspotsManager = EasyDevControlsHotspotsManager.new()

            -- Initialise the GUI Manager
            g_easyDevControlsGuiManager = EasyDevControlsGuiManager.new(g_server ~= nil, g_client ~= nil)

            -- Setup pointers
            easyDevControls.guiManager = g_easyDevControlsGuiManager
            easyDevControls.settings = g_easyDevControlsSettings

            -- Add Settings
            easyDevControls:addSettings(easyDevControls.settings)

            g_globalMods.easyDevControls = easyDevControls
            g_easyDevControls = easyDevControls

            -- Initialise my debugger when available
            if StartParams.getIsSet("debuggerGtX") and not isDebuggerActive() then
                local path = getUserProfileAppPath() .. "gtxSettings/GtXDebugger.lua"

                if fileExists(path) then
                    source(path)

                    if isDebuggerActive() then
                        Logging.info("[Easy Development Controls] Debugger has been initialised!")
                    end
                end
            end

            FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, saveToXMLFile)

            Mission00.load = Utils.prependedFunction(Mission00.load, load)
            FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, unload)
            InGameMenu.setMissionInfo = Utils.prependedFunction(InGameMenu.setMissionInfo, inGameMenuSetMissionInfo)

            FSBaseMission.sendInitialClientState = Utils.appendedFunction(FSBaseMission.sendInitialClientState, sendInitialClientState)
            FSBaseMission.onFinishedLoading = Utils.prependedFunction(FSBaseMission.onFinishedLoading, onFinishedLoading)
            Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, onStartMission)

            PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerGlobalPlayerActionEvents, registerGlobalPlayerActionEvents)
            PlayerInputComponent.registerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerActionEvents, registerActionEvents)
            PlayerInputComponent.unregisterActionEvents = Utils.appendedFunction(PlayerInputComponent.unregisterActionEvents, unregisterActionEvents)

            PlayerHUDUpdater.update = Utils.appendedFunction(PlayerHUDUpdater.update, playerHUDUpdateFinished)

            HandToolHands.consoleCommandToggleSuperStrength = Utils.appendedFunction(HandToolHands.consoleCommandToggleSuperStrength, consoleCommandToggleSuperStrength)
            HandToolChainsaw.updateRingSelector = Utils.overwrittenFunction(HandToolChainsaw.updateRingSelector, updateRingSelector)
            CloudSettings.copyAttributes = Utils.appendedFunction(CloudSettings.copyAttributes, cloudSettingsCopyAttributes)
        else
            g_easyDevControlsSettings:delete()
            g_easyDevControlsSettings = nil
        end
    else
        Logging.error("[%s] Failed to initialise / validate mod, make sure you are using the latest release available on the Giants Official Mod Hub with no file or zip name changes!", modName)
    end
end

init()
