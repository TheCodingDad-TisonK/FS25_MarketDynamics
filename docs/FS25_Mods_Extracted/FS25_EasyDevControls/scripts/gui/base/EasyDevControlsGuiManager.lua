--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-02

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

EasyDevControlsGuiManager = {}

EasyDevControlsGuiManager.OVERLAY_COLOUR = {0.22323, 0.40724, 0.00368, 0.3}
EasyDevControlsGuiManager.USE_SERVER_PASSWORD = "USE_SERVER_PASSWORD"

local EasyDevControlsGuiManager_mt = Class(EasyDevControlsGuiManager)

function EasyDevControlsGuiManager.new(isServer, isClient)
    local self = setmetatable({}, EasyDevControlsGuiManager_mt)

    self.isServer = isServer
    self.isClient = isClient

    self.pagesByName = {}
    self.pages = {}

    self.permissionsByName = {}
    self.permissions = {}

    self.toolTipsByName = {}
    self.toolTips = {}

    self.helpPages = {}

    self.classicMenu = nil
    self.inGameMenuEasyDevControls = nil

    self.isMultiplayer = false
    self.connectedToDedicatedServer = false
    self.isFinishedLoading = false
    self.gameStarted = false

    self.isMasterUser = isServer
    self.accessLevel = EasyDevControlsAccessLevel.NONE
    self.connectionToMasterUser = {}

    -- g_messageCenter:subscribe(MessageType.EDC_GUI_OPEN_SCREEN, self.onOpenEasyDevControlsScreen, self)
    g_messageCenter:subscribe(PlayerPermissionsEvent, self.onUserPermissionsChanged, self)
    g_messageCenter:subscribe(MessageType.MASTERUSER_ADDED, self.onMasterUserAdded, self)
    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.onPlayerFarmChanged, self)

    if self.isServer then
        g_messageCenter:subscribe(MessageType.USER_ADDED, self.onUserAdded, self)
        g_messageCenter:subscribe(MessageType.USER_REMOVED, self.onUserRemoved, self)
    end

    return self
end

function EasyDevControlsGuiManager:load(mission, isReloading)
    if isReloading and g_easyDevControlsDevelopmentMode then
        -- Nothing
    end

    -- Load texture slices (modEnvironment is not called for GUI Bitmap Elements so create a new config type 'easyDevControls' instead of 'gui')
    g_overlayManager:addTextureConfigFile(EasyDevControlsUtils.getLocalFilename("menu/gui.xml"), "easyDevControls")

    -- Load pages data
    self:loadPages(EasyDevControlsUtils.getLocalFilename("gui/shared/guiPages.xml"))

    -- Load profiles
    g_gui:loadProfiles(EasyDevControlsUtils.getLocalFilename("gui/shared/guiProfiles.xml"))

     if not isReloading then
        -- Load Teleport Screen
        g_easyDevControlsTeleportScreen = EasyDevControlsTeleportScreen.register()

        -- Load Dialogs
        g_easyDevControlsDynamicListDialog = EasyDevControlsDynamicListDialog.register()
        g_easyDevControlsDynamicSelectionDialog = EasyDevControlsDynamicSelectionDialog.register()

        -- Load required console commands
        if not mission.missionDynamicInfo.isMultiplayer then
            local mod = g_modManager:getModByName(EasyDevControlsUtils.getCustomEnvironment())

            -- Only when unzipped for easy updating of the translation files.
            if mod ~= nil and mod.fileHash == nil then
                addConsoleCommand("gtxEasyDevControlsReloadTranslations", "Reloads the translation files for the current language.", "consoleCommandReloadTranslations", self, "showChanges [default=true];languageShort [optional (This will load these language texts.)]")
            end

            if g_easyDevControlsDevelopmentMode then
                addConsoleCommand("gtxEasyDevControlsSetAccessLevel", "Forces the given access level.", "consoleCommandSetAccessLevel", self, "accessLevelName [or] index")
            end
        end

        -- Reset focus so that pressing 'Q' and 'A' or 'ESC' before mission start does not cause errors
        FocusManager:setGui("MPLoadingScreen")
    end
end

function EasyDevControlsGuiManager:loadPages(xmlFilename)
    self.pages = {}
    self.pagesByName = {}

    self.permissions = {}
    self.permissionsByName = {}

    self.toolTips = {}
    self.toolTipsByName = {}

    self.helpPages = {}

    local isMultiplayer = self.isMultiplayer
    local defaultAccessLevel = EasyDevControlsAccessLevel.EDC_ADMIN
    local xmlFile = XMLFile.load("edcPages", xmlFilename)

    if xmlFile ~= nil then
        local function getAccessLevelFromXML(key, default)
            local accessLevelName = xmlFile:getString(key)

            if accessLevelName ~= nil then
                local accessLevel = EasyDevControlsAccessLevel.getByName(accessLevelName)

                if accessLevel ~= nil then
                    return accessLevel
                else
                    EasyDevControlsLogging.devError("Invalid accessLevel name '%s' given at index '%s'", accessLevelName:upper(), key)
                end
            end

            return default
        end

        for _, key in xmlFile:iterator("guiPages.guiPage") do
            local pageId = xmlFile:getString(key .. "#id", "pageUnknown")

            if pageId ~= "pageUnknown" then
                local pageName = xmlFile:getString(key .. "#name", "UNKNOWN"):upper()

                if self.pagesByName[pageName] == nil then
                    local page = {
                        id = pageId,
                        name = pageName,
                        index = #self.pages + 1,
                        title = EasyDevControlsUtils.convertText(xmlFile:getString(key .. "#title", "Unknown")),
                        sliceId = xmlFile:getString(key .. "#slice", "easyDevControls.icon_general"),
                        multiplayerOnly = xmlFile:getBool(key .. "#multiplayerOnly", false),
                        toolTips = {},
                        permissions = {}
                    }

                    -- Used by the Info page in classic mode and by the InGameMenu to create tabs.
                    if xmlFile:hasProperty(key .. ".alternativePageData") then
                        page.alternativePageData = {
                            id = xmlFile:getString(key .. ".alternativePageData#id", page.id),
                            name = xmlFile:getString(key .. ".alternativePageData#name", pageName):upper(),
                            title = EasyDevControlsUtils.convertText(xmlFile:getString(key .. ".alternativePageData#title", page.title)),
                            sliceId = xmlFile:getString(key .. ".alternativePageData#slice", page.sliceId),
                        }
                    end

                    if xmlFile:hasProperty(key .. ".toolTips") then
                        for _, toolTipKey in xmlFile:iterator(key .. ".toolTips.toolTip") do
                            local name = xmlFile:getString(toolTipKey .. "#name")

                            if name ~= nil and self.toolTipsByName[name] == nil then
                                local title = xmlFile:getString(toolTipKey .. "#title", "Unknown")
                                local toolTipText = xmlFile:getString(toolTipKey .. "#text", "...")
                                local style = xmlFile:getString(toolTipKey .. "#style", "SHARED") -- SHARED | INGAME | CLASSIC

                                local params = xmlFile:getString(toolTipKey .. "#params")
                                local paramsFunc = xmlFile:getString(toolTipKey .. "#paramsFunc")

                                if params ~= nil then
                                    local paramsToLower = xmlFile:getBool(toolTipKey .. "#paramsToLower", false)

                                    params = params:split("|")

                                    for i = 1, #params do
                                        if not paramsToLower then
                                            params[i] = EasyDevControlsUtils.convertText(params[i])
                                        else
                                            params[i] = EasyDevControlsUtils.convertText(params[i]):lower()
                                        end
                                    end

                                    local paramsFormatting = xmlFile:getString(toolTipKey .. "#paramsFormatting")

                                    if paramsFormatting ~= nil then
                                        toolTipText = string.gsub(EasyDevControlsUtils.convertText(toolTipText) .. paramsFormatting, "\\([n])", "\n")
                                    end

                                    toolTipText = EasyDevControlsUtils.formatConvertedText(toolTipText, unpack(params))
                                elseif paramsFunc ~= nil then
                                    local class, func, target = nil, nil, nil
                                    local paramsFuncTarget = xmlFile:getString(toolTipKey .. "#paramsFuncTarget")
                                    local funcName, paramsFuncSplit = paramsFunc, paramsFunc:split(".")

                                    if #paramsFuncSplit > 1 then
                                        class = _G[paramsFuncSplit[1]]
                                        funcName = paramsFuncSplit[2]
                                    end

                                    if paramsFuncTarget ~= nil then
                                        target = _G[paramsFuncTarget]
                                    end

                                    if class ~= nil then
                                        func = class[funcName]
                                    elseif target ~= nil then
                                        func = target[funcName]
                                    else
                                        func = _G[funcName]
                                    end

                                    if func ~= nil then
                                        toolTipText = EasyDevControlsUtils.convertText(toolTipText)

                                        local _, formatCount = string.gsub(toolTipText, "%%s", "")

                                        if formatCount == 0 then
                                            toolTipText = toolTipText .. "%s"
                                        end

                                        toolTipText = toolTipText:format(func(funcTarget))
                                    else
                                        toolTipText = EasyDevControlsUtils.convertText(toolTipText)

                                        EasyDevControlsLogging.xmlDevError(xmlFile, "Function with name '%s' could not be found!", paramsFunc)
                                    end
                                else
                                    toolTipText = EasyDevControlsUtils.convertText(toolTipText)
                                end

                                toolTip = {
                                    name = name,
                                    pageName = pageName,
                                    elementId = name .. "ToolTip",
                                    title = EasyDevControlsUtils.convertText(title),
                                    text = toolTipText,
                                    style = style:upper()
                                }

                                table.insert(self.toolTips, toolTip)
                                table.insert(page.toolTips, toolTip)

                                self.toolTipsByName[name] = toolTip
                            else
                                EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to add toolTip (%s), missing name or possible duplicate!", name or "nil")
                            end
                        end
                    end

                    if isMultiplayer and xmlFile:hasProperty(key .. ".permissions") then
                        local toolTipText = EasyDevControlsUtils.getText("easyDevControls_permissionsToolTip")

                        for _, permissionKey in xmlFile:iterator(key .. ".permissions.permission") do
                            local name = xmlFile:getString(permissionKey .. "#name")

                            if name ~= nil and self.permissionsByName[name] == nil then
                                local permission = {
                                    title = EasyDevControlsUtils.convertText(xmlFile:getString(permissionKey .. "#title", "Unknown")),
                                    pageName = pageName,
                                    name = name,
                                }

                                local toolTipParams = xmlFile:getString(permissionKey .. "#toolTipParams")

                                if toolTipParams ~= nil then
                                    toolTipParams = toolTipParams:split("|")

                                    for i = 1, #toolTipParams do
                                        toolTipParams[i] = EasyDevControlsUtils.convertText(toolTipParams[i])
                                    end

                                    permission.toolTipText = string.format(toolTipText, table.concat(toolTipParams, " | "))
                                else
                                    permission.toolTipText = string.format(toolTipText, permission.title)
                                end

                                permission.maximumAccessLevel = getAccessLevelFromXML(permissionKey .. "#maximumAccessLevel", defaultAccessLevel)
                                permission.accessLevel = getAccessLevelFromXML(permissionKey .. "#accessLevel", permission.maximumAccessLevel)

                                permission.disabled = xmlFile:getBool(permissionKey .. "#disabled", false) -- Disabled should never be set by code, will break MP sync. Used for future or incomplete commands.
                                permission.singlePlayerOnly = xmlFile:getBool(permissionKey .. "#singlePlayerOnly", false)

                                table.insert(self.permissions, permission)
                                table.insert(page.permissions, permission)

                                self.permissionsByName[name] = permission
                            else
                                EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to add permission (%s), missing name or possible duplicate!", name or "nil")
                            end
                        end

                        -- EasyDevControlsPermissionsEvent.SEND_NUM_BITS = EasyDevControlsUtils.getNumBits(#self.permissions)
                    end

                    if isMultiplayer or not page.multiplayerOnly then
                        local helpTitle = page.title
                        local helpSliceId = page.sliceId

                        if page.alternativePageData ~= nil then
                            helpTitle = page.alternativePageData.title
                            helpSliceId = page.alternativePageData.sliceId
                        end

                        if pageName == "PERMISSIONS" then
                            -- Dynamically add the toolTips for each permission
                            for _, guiPage in ipairs (self.pages) do
                                local name = string.format("permissionsOverview%sPage", EasyDevControlsUtils.capitalise(guiPage.name, false))
                                local toolTipText = ""
                                local numPermissions = 0

                                for _, permission in ipairs (guiPage.permissions) do
                                    if not permission.disabled and not permission.singlePlayerOnly then
                                        if numPermissions > 0 then
                                            toolTipText = string.format("%s\n-    %s", toolTipText, permission.title)
                                        else
                                            toolTipText = string.format("-    %s", permission.title)
                                        end

                                        numPermissions += 1
                                    end
                                end

                                local toolTip = {
                                    name = name,
                                    pageName = pageName,
                                    elementId = name .. "ToolTip",
                                    title = guiPage.title,
                                    text = toolTipText
                                }

                                table.insert(self.toolTips, toolTip)
                                table.insert(page.toolTips, toolTip)

                                self.toolTipsByName[name] = toolTip
                            end
                        end

                        table.insert(self.helpPages, {
                            title = helpTitle,
                            sliceId = helpSliceId,
                            pageIndex = page.index,
                            toolTips = page.toolTips
                        })
                    end

                    table.insert(self.pages, page)

                    self.pagesByName[pageName] = page
                else
                    EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to add page with name '%s' as it already exists!", pageName)
                end
            else
                EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to add page, invalid 'pageId' given at '%s'.", key)
            end
        end

        xmlFile:delete()
    end
end

function EasyDevControlsGuiManager:delete()
    g_messageCenter:unsubscribeAll(self)

    removeConsoleCommand("gtxEasyDevControlsReloadTranslations")
    removeConsoleCommand("gtxEasyDevControlsSetAccessLevel")
end

function EasyDevControlsGuiManager:loadFromXMLFile(xmlFile, baseKey, missionInfo, isSavegame)
    if self.isServer and self.isMultiplayer then
        local adminPassword = xmlFile:getString(baseKey .. ".permissions#adminPassword")

        if adminPassword == EasyDevControlsGuiManager.USE_SERVER_PASSWORD then
            adminPassword = nil
        end

        self.adminPassword = adminPassword

        for _, key in xmlFile:iterator(baseKey .. ".permissions.permission") do
            local permissionName = xmlFile:getString(key .. "#name", "unknown")
            local permission = self.permissionsByName[permissionName]

            if permission ~= nil then
                local accessLevel = EasyDevControlsAccessLevel.loadFromXMLFile(xmlFile, key .. "#accessLevel")

                permission.accessLevel = EasyDevControlsUtils.getValidAccessLevel(accessLevel, permission.maximumAccessLevel, permission.accessLevel)
            else
                EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to load permission with name '%s' at '%s'", permissionName, key)
            end
        end
    end
end

function EasyDevControlsGuiManager:saveToXMLFile(xmlFile, baseKey)
    if self.isServer and self.isMultiplayer then
        if not string.isNilOrWhitespace(self.adminPassword) then
            xmlFile:setString(baseKey .. ".permissions#adminPassword", self.adminPassword)
        end

        xmlFile:setSortedTable(baseKey .. ".permissions.permission", self.permissions, function(key, permission)
            xmlFile:setString(key .. "#name", permission.name)
            EasyDevControlsAccessLevel.saveToXMLFile(xmlFile, key .. "#accessLevel", permission.accessLevel)
        end)
    end
end

function EasyDevControlsGuiManager:onSetMissionInfo(missionInfo, missionDynamicInfo, missionBaseDirectory)
    self.isMultiplayer = missionDynamicInfo.isMultiplayer or g_easyDevControlsSimulateMultiplayer
    self.connectedToDedicatedServer = g_currentMission.connectedToDedicatedServer
end

function EasyDevControlsGuiManager:onMissionFinishedLoading(mission, isReloading)
    local mapTeleportScreen = g_easyDevControlsTeleportScreen

    if mapTeleportScreen ~= nil then
        mapTeleportScreen:setInGameMap(mission.hud:getIngameMap())
        mapTeleportScreen:setTerrainSize(mission.terrainSize)
    end

    if not self:getUseInGameMenu() then
        self:initializeClassicMode(isReloading)
    else
        self:initializeInGameMenuMode(isReloading)

        if self.inGameMenuEasyDevControls ~= nil then
            self.inGameMenuEasyDevControls:onMissionFinishedLoading(mission, isReloading)
        else
            g_easyDevControlsSettings:setValue("inGameMenuMode", false)
            self:initializeClassicMode(isReloading)

            EasyDevControlsLogging.info("Failed to initialise In-Game menu, falling back to Classic menu.")
        end
    end

    if self.classicMenu ~= nil then
        self.classicMenu:onMissionFinishedLoading(mission, isReloading)
    end

    self.isFinishedLoading = true
end

function EasyDevControlsGuiManager:onMissionStarted(isNewSavegame)
    if self.gameStarted then
        return
    end

    self:updateAccessLevel(true)
    self.gameStarted = true
end

function EasyDevControlsGuiManager:onUserPermissionsChanged(userId)
    if userId == g_currentMission.playerUserId then
        self:updateAccessLevel(true)
    end
end

function EasyDevControlsGuiManager:onMasterUserAdded(user)
    if user:getId() == g_currentMission.playerUserId then
        self:updateAccessLevel(true)
    end
end

function EasyDevControlsGuiManager:onPlayerFarmChanged(player)
    if player == g_localPlayer then
        self:updateAccessLevel(true)
    end
end

function EasyDevControlsGuiManager:onUserAdded(user)
    if self.isServer and user:getId() == g_currentMission.playerUserId then
        self.connectionToMasterUser[user:getConnection()] = user
    end
end

function EasyDevControlsGuiManager:onUserRemoved(user)
    self.connectionToMasterUser[user:getConnection()] = nil
end

function EasyDevControlsGuiManager:onOpenEasyDevControlsScreen(index)
    if g_currentMission:getAllowsGuiDisplay() then
        g_gui:showGui("EasyDevControlsMenu")

        if index ~= nil and self.classicMenu ~= nil then
            self.classicMenu.pageSelector:setState(index, true)
        end
    end
end

function EasyDevControlsGuiManager:initializeInGameMenuMode(forceReload)
    return false -- (Future) Have not had the time to finish this so removed from release version for now.
end

function EasyDevControlsGuiManager:initializeClassicMode(forceReload)
    if self.classicMenu == nil or forceReload then
        self.classicMenu = EasyDevControlsMenu.register()

        if self.isFinishedLoading and self.classicMenu.onMissionFinishedLoading ~= nil then
            self.classicMenu:onMissionFinishedLoading(g_currentMission, true)
        end
    end

    return true
end

function EasyDevControlsGuiManager:setIsMasterUser(isMasterUser)
    if self.isServer then
        isMasterUser = true
    end

    if isMasterUser and not g_currentMission.isMasterUser then
        isMasterUser = false
    end

    if self.isMasterUser ~= isMasterUser then
        self.isMasterUser = isMasterUser

        -- g_messageCenter:publish(MessageType.EDC_MASTERUSER_STATE_CHANGED, isMasterUser)

        self:updateAccessLevel(true)

        return true
    end

    return false
end

function EasyDevControlsGuiManager:setPermissionAccessLevel(name, accessLevel, suppressInfo)
    local permission = self.permissionsByName[name]

    if permission ~= nil then
        accessLevel = EasyDevControlsUtils.getValidAccessLevel(accessLevel, permission.maximumAccessLevel, permission.accessLevel)

        if accessLevel ~= permission.accessLevel then
            permission.accessLevel = accessLevel

            if not suppressInfo then
                EasyDevControlsLogging.info("Permission '%s': %s (%d)", name, EasyDevControlsAccessLevel.getName(accessLevel), accessLevel)
            end

            return true
        end
    end

    return false
end

function EasyDevControlsGuiManager:setUseInGameMenu(useInGameMenu, callback)
    useInGameMenu = false -- g_easyDevControlsSettings:setValue("inGameMenuMode", useInGameMenu)

    if useInGameMenu then
        if self.inGameMenuEasyDevControls == nil then
            self:initializeInGameMenuMode(false)
        end
    else
        if self.classicMenu == nil then
            self:initializeClassicMode(false)
        end
    end

    if callback ~= nil then
        callback(useInGameMenu)
    end
end

function EasyDevControlsGuiManager:updateAccessLevel(forceUpdate)
    local accessLevel = EasyDevControlsAccessLevel.NONE

    if g_dedicatedServer == nil then
        local farm = g_farmManager:getFarmById(g_currentMission:getFarmId())

        if farm ~= nil and not farm.isSpectator then
            if self.isServer or self.isMasterUser then
                accessLevel = EasyDevControlsAccessLevel.EDC_ADMIN
            elseif g_currentMission.isMasterUser then
                accessLevel = EasyDevControlsAccessLevel.ADMIN
            elseif farm:isUserFarmManager(g_currentMission.playerUserId) then
                accessLevel = EasyDevControlsAccessLevel.FARM_MANAGER
            else
                accessLevel = EasyDevControlsAccessLevel.STANDARD
            end
        end
    else
        accessLevel = EasyDevControlsAccessLevel.EDC_ADMIN
    end

    if (accessLevel ~= self.accessLevel) or (forceUpdate == true) then
        self.accessLevel = accessLevel

        g_messageCenter:publish(MessageType.EDC_ACCESS_LEVEL_CHANGED, accessLevel)

        if g_easyDevControlsDevelopmentMode then
            print(string.format("  DevInfo: [Easy Development Controls] Access level changed to %s (%d)", EasyDevControlsAccessLevel.getName(accessLevel), accessLevel))
        end
    end
end

function EasyDevControlsGuiManager:getUsePermissions()
    return self.isMultiplayer and #self.permissions > 0
end

function EasyDevControlsGuiManager:getAccessLevel()
    return self.accessLevel or EasyDevControlsAccessLevel.NONE
end

function EasyDevControlsGuiManager:getHasPermission(name)
    if self.isMultiplayer then
        local permission = self.permissionsByName[name]

        if permission == nil or (permission.disabled or permission.singlePlayerOnly) then
            return false
        end

        return permission.accessLevel >= self:getAccessLevel()
    end

    return true
end

function EasyDevControlsGuiManager:getPages()
    return self.pages
end

function EasyDevControlsGuiManager:getPermissions(excludeSinglePlayerOnly)
    if excludeSinglePlayerOnly then
        local permissions = {}

        for _, permission in ipairs (self.permissions) do
            if not permission.singlePlayerOnly then
                table.insert(permissions, permission)
            end
        end

        return permissions
    end

    return self.permissions
end

function EasyDevControlsGuiManager:getHelpPages()
    return self.helpPages
end

function EasyDevControlsGuiManager:getHelpPageByIndex(pageIndex)
    return self.helpPages[pageIndex]
end

function EasyDevControlsGuiManager:getIsMasterUser(connection)
    if connection ~= nil then
        return self.connectionToMasterUser[connection] ~= nil
    end

    -- return self.isServer or self.isMasterUser
    return self.isMasterUser
end

function EasyDevControlsGuiManager:getPageByName(pageName)
    return self.pagesByName[pageName ~= nil and pageName:upper()]
end

function EasyDevControlsGuiManager:getPageByIndex(pageIndex)
    return self.pages[pageIndex]
end

function EasyDevControlsGuiManager:getPageNameByPermissionName(permissionName)
    local permission = self.permissionsByName[permissionName]

    return permission ~= nil and permission.pageName or ""
end

function EasyDevControlsGuiManager:getPermissionByName(permissionName)
    return self.permissionsByName[permissionName]
end

function EasyDevControlsGuiManager:getUseInGameMenu()
    return false -- g_easyDevControlsSettings:getValue("inGameMenuMode", false)
end

function EasyDevControlsGuiManager.getTranslationParams()
    local contributorsText = ""
    local englishLanguageShort = "en"

    local currentLanguage = g_language
    local currentLanguageShort = g_languageShort

    local function getValidLanguageName(language)
        if currentLanguage == language then
            if getLanguageNativeName ~= nil then
                return getLanguageNativeName(language)
            end
        end

        if currentLanguageShort == englishLanguageShort then
            local languageName = getLanguageName(language)

            if languageName == "Deutsch" then
                return "German"
            elseif languageName == "Polski" then
                return "Polish"
            elseif languageName == "Italiano" then
                return "Italian"
            elseif languageName == "Polski" then
                return "Czech"
            end
        end

        return getLanguageName(language)
    end

    for _, availableLanguage in ipairs (g_availableLanguagesTable) do
        local languageName = getValidLanguageName(availableLanguage)
        local languageCode = getLanguageCode(availableLanguage)

        if languageName ~= nil and languageCode ~= nil then
            local xmlFilename = EasyDevControlsUtils.getLocalFilename("translations/translation_" .. languageCode .. ".xml")
            local xmlFile = XMLFile.loadIfExists("modL10n", xmlFilename)

            if xmlFile ~= nil then
                local contributors = {}

                for _, key in xmlFile:iterator("l10n.contributors.name") do
                    local contributor = xmlFile:getString(key)

                    if contributor ~= nil then
                        table.insert(contributors, contributor)
                    end
                end

                if #contributors > 0 then
                    contributorsText = string.format("%s%s: %s\n", contributorsText, languageName, table.concat(contributors, ", "))
                else
                    contributorsText = string.format("%s%s: %s\n", contributorsText, languageName, "...")
                end

                xmlFile:delete()
            end
        end
    end

    return contributorsText
end

function EasyDevControlsGuiManager.getReleaseParams()
    local easyDevControls = g_easyDevControls

    local text = "Release: %s\nVersion: %s\nBuild: %.1f"
    local newLine = "\n\n"

    if easyDevControls.debugger ~= nil then
        text = text .. newLine .. "God Mode: Yes"
        newLine = "\n"
    end

    if g_easyDevControlsDevelopmentMode then
        text = text .. newLine .. "Development: Yes"

        if g_easyDevControlsDebugLevel ~= nil then
            text = text .. "\nDebug Level: " .. tostring(g_easyDevControlsDebugLevel)
        end

        newLine = "\n"
    end

    if g_easyDevControlsSimulateMultiplayer then
        text = text .. newLine .. "Simulated MP: Yes"
        newLine = "\n"
    end

    return string.format(text, easyDevControls.releaseType, easyDevControls.versionString, easyDevControls.buildId)
end

function EasyDevControlsGuiManager.getUserSettingsLocationParams()
    local modSettingsDir = EasyDevControlsUtils.getSettingsDirectory(false)

    if not string.isNilOrWhitespace(modSettingsDir) then
        return modSettingsDir .. "defaultUserSettings.xml"
    end

    -- I think this is correct however I do not own any MAC devices to check :-)
    if PlatformId ~= nil and PlatformId.MAC == GS_PLATFORM_ID then
        return "~/Library/Application Support/FarmingSimulator2025/modSettings/FS25_EasyDevControls/defaultUserSettings.xml"
    end

    return "C:/Users/%USERNAME%/Documents/My Games/FarmingSimulator2025/modSettings/FS25_EasyDevControls/defaultUserSettings.xml"
end

function EasyDevControlsGuiManager:addSettings(settings)
    settings:addSetting("toggleMenuMode", false, nil, false)
    -- settings:addSetting("inGameMenuMode", false, nil, true)
end

function EasyDevControlsGuiManager:consoleCommandReloadTranslations(showChanges, languageShort)
    local currentMission = g_currentMission

    if currentMission == nil or not self.isFinishedLoading then
        return "Reloading of translations is not possible before game has been started."
    end

    if currentMission.missionDynamicInfo.isMultiplayer then
        return "Reloading of translations is not possible in multiplayer."
    end

    if self:getUseInGameMenu() then
        return "Reloading of translations is not possible when using In-Game Menu mode."
    end

    local openGui = false
    local oldDevMode = g_easyDevControlsDevelopmentMode
    local message = "%d translation entries reloaded ( Added: %s | Removed: %d | Changed: %d ) successfully."

    local numOldTexts = 0
    local numNewTexts = 0
    local numLoadedTexts = 0
    local numRefreshedTexts = 0

    local xmlFile, xmlFilename = nil, nil
    local l10nFilenamePrefix = EasyDevControlsUtils.getLocalFilename("translations/translation_")

    g_easyDevControlsDevelopmentMode = true
    g_easyDevControlsReloadingTranslations = true

    if l10nFilenamePrefix ~= nil then
        local languageShorts

        if languageShort ~= nil then
            local validLanguageShort = false

            for _, lang in ipairs(g_availableLanguagesTable) do
                if languageShort == getLanguageCode(lang) then
                    languageShorts = {languageShort}

                    validLanguageShort = true

                    break
                end
            end

            if validLanguageShort then
                if not fileExists(l10nFilenamePrefix .. languageShort .. ".xml") then
                    return "Failed to reload translation entries for language " .. languageShort .. ". File " .. l10nFilenamePrefix .. languageShort .. ".xml does not exist!"
                end
            else
                return "Failed to reload translation entries for language " .. languageShort .. ". Language is not supported by the current game release."
            end
        else
            languageShorts = {g_languageShort, "en", "de"}
        end

        for _, langShort in ipairs(languageShorts) do
            xmlFilename = l10nFilenamePrefix .. langShort .. ".xml"

            if fileExists(xmlFilename) then
                xmlFile = XMLFile.load("modL10n", xmlFilename)

                break
            end
        end

        if xmlFile ~= nil then
            local modName = EasyDevControlsUtils.getCustomEnvironment()
            local modi18n = g_i18n.modEnvironments[modName]
            local oldTexts = {}

            if showChanges ~= nil then
                showChanges = showChanges:upper() == "TRUE"
            else
                showChanges = true
            end

            for name, value in pairs (modi18n.texts) do
                modi18n:setText(name, nil)
                oldTexts[name] = value
                numOldTexts += 1
            end

            for _, key in xmlFile:iterator("l10n.texts.text") do
                local name = xmlFile:getString(key .. "#name")
                local text = xmlFile:getString(key .. "#text")

                if name ~= nil and text ~= nil then
                    if modi18n:hasModText(name) then
                        printf("- Duplicate l10n entry '%s' in '%s', ignoring this definition.", name, xmlFilename)
                    else
                        local oldText = oldTexts[name]

                        if oldText == nil then
                            numNewTexts += 1

                            if showChanges then
                                printf("- Added new l10n entry '%s'", name)
                            end
                        else
                            numLoadedTexts += 1

                            if oldText ~= text then
                                numRefreshedTexts += 1

                                if showChanges then
                                    printf("- Update text for l10n entry '%s'", name)
                                end
                            end
                        end

                        modi18n:setText(name, text:gsub("\r\n", "\n"))
                    end
                end
            end

            xmlFile:delete()
        else
            EasyDevControlsLogging.devWarning("No l10n file found with prefix '%s'!", l10nFilenamePrefix)
        end

        if g_easyDevControls.setTexts ~= nil then
            g_easyDevControls:setTexts() -- Refresh stored texts
        end
    end

    if numNewTexts > 0 or numRefreshedTexts > 0 then
        g_gui.currentlyReloading = true
        self:load(currentMission, true)
        g_gui.currentlyReloading = false

        if self.classicMenu ~= nil then
            local guiName = "EasyDevControlsMenu"
            local gui = g_gui.guis[guiName]

            if gui ~= nil and gui.target ~= nil then
                local guiController = gui.target
                local object = guiController:class()

                if object ~= nil and object.createFromExistingGui ~= nil then
                    if g_gui.currentGui == gui then
                        openGui = true

                        gui:setSoundSuppressed(true)
                        g_gui:showGui("")
                    end

                    g_gui.currentlyReloading = true
                    object.createFromExistingGui(guiController, guiName)
                    g_gui.currentlyReloading = false
                end
            end
        else
            self:initializeClassicMode(true)
        end

        self.accessLevel = EasyDevControlsAccessLevel.EDC_ADMIN
        self.isMasterUser = true

        g_messageCenter:publish(MessageType.EDC_ACCESS_LEVEL_CHANGED, self.accessLevel)

        message = "%d translation entries reloaded ( Added: %s | Removed: %d | Changed: %d ) from '%s'\nStandard (Classic) Menu has been reloaded."
    end

    g_easyDevControlsDevelopmentMode = oldDevMode
    g_easyDevControlsReloadingTranslations = nil

    if openGui then
        g_gui:showGui("EasyDevControlsMenu")
    end

    return message:format(numLoadedTexts, numNewTexts, numLoadedTexts - numOldTexts, numRefreshedTexts, xmlFilename)
end

function EasyDevControlsGuiManager:consoleCommandSetAccessLevel(newAccessLevel)
    if g_currentMission.missionDynamicInfo.isMultiplayer or not g_easyDevControlsDevelopmentMode then
        return "Command is for Development SP testing by GtX only!"
    end

    local accessLevel = EasyDevControlsAccessLevel.NONE

    if newAccessLevel == nil then
        newAccessLevel = accessLevel
    end

    if tonumber(newAccessLevel) then
        accessLevel = math.clamp(tonumber(newAccessLevel), EasyDevControlsAccessLevel.EDC_ADMIN, EasyDevControlsAccessLevel.NONE)
    else
        accessLevel = EasyDevControlsAccessLevel.getByName(newAccessLevel) or accessLevel
    end

    self.accessLevel = accessLevel
    self.isMasterUser = accessLevel == EasyDevControlsAccessLevel.EDC_ADMIN

    local user = g_currentMission.userManager:getUserByUserId(g_currentMission.playerUserId)

    if user ~= nil then
        if self.isMasterUser then
            self.connectionToMasterUser[user:getConnection()] = user
        else
            self.connectionToMasterUser[user:getConnection()] = nil
        end
    end

    g_messageCenter:publish(MessageType.EDC_ACCESS_LEVEL_CHANGED, accessLevel)

    return string.format("Access level changed to %s (%s).", EasyDevControlsAccessLevel.getName(accessLevel), accessLevel)
end
