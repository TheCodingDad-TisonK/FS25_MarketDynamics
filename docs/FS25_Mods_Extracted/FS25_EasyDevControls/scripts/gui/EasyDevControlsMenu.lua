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

EasyDevControlsMenu = {}

EasyDevControlsMenu.VALID_CONTROLS = {
    background = true,
    pagingElement = true,
    pageGeneral = true,
    pagePlayer = true,
    pageObjects = true,
    pageVehicles = true,
    pagePlaceables = true,
    pageFarmlands = true,
    pageEnvironment = true,
    pagePermissions = true,
    pageHelp = true,
    header = true,
    pageSelector = true,
    pagingTabList = true,
    buttonsPanel = true,
    menuButton = true
}

EasyDevControlsMenu.MAX_SERVER_REQUEST_TIME_SEC = 8

local EasyDevControlsMenu_mt = Class(EasyDevControlsMenu, TabbedMenu)

function EasyDevControlsMenu.register()
    EasyDevControlsGeneralFrame.register()
    EasyDevControlsPlayerFrame.register()
    EasyDevControlsObjectsFrame.register()
    EasyDevControlsVehiclesFrame.register()
    EasyDevControlsPlaceablesFrame.register()
    EasyDevControlsFarmlandsFrame.register()
    EasyDevControlsEnvironmentFrame.register()
    EasyDevControlsPermissionsFrame.register()
    EasyDevControlsHelpFrame.register()

    local controller = EasyDevControlsMenu.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsMenu.xml")

    g_gui:loadGui(filename, "EasyDevControlsMenu", controller)

    return controller
end

function EasyDevControlsMenu.new(target, customMt)
    local self = TabbedMenu.new(nil, customMt or EasyDevControlsMenu_mt)

    self.isMultiplayer = false
    self.performBackgroundBlur = true
    self.userRemovedBackgroundBlur = false -- Restores the state when changing between unsupported tabs

    self.time = 0
    self.exitMenuEventId = nil
    self.exitMenuInputDelay = 0

    return self
end

function EasyDevControlsMenu.createFromExistingGui(gui, guiName)
    local guiManager = g_easyDevControlsGuiManager
    local frames = g_gui.frames
    local restorePageIndex

    if not g_easyDevControlsReloadingTranslations then
        g_gui:loadProfiles(EasyDevControlsUtils.getLocalFilename("gui/shared/guiProfiles.xml"))
    end

    EasyDevControlsGeneralFrame.createFromExistingGui(frames.easyDevControlsGeneral.target, "EasyDevControlsGeneralFrame")
    EasyDevControlsPlayerFrame.createFromExistingGui(frames.easyDevControlsPlayer.target, "EasyDevControlsPlayerFrame")
    EasyDevControlsObjectsFrame.createFromExistingGui(frames.easyDevControlsObjects.target, "EasyDevControlsObjectsFrame")
    EasyDevControlsVehiclesFrame.createFromExistingGui(frames.easyDevControlsVehicles.target, "EasyDevControlsVehiclesFrame")
    EasyDevControlsPlaceablesFrame.createFromExistingGui(frames.easyDevControlsPlaceables.target, "EasyDevControlsPlaceablesFrame")
    EasyDevControlsFarmlandsFrame.createFromExistingGui(frames.easyDevControlsFarmlands.target, "EasyDevControlsFarmlandsFrame")
    EasyDevControlsEnvironmentFrame.createFromExistingGui(frames.easyDevControlsEnvironment.target, "EasyDevControlsEnvironmentFrame")
    EasyDevControlsPermissionsFrame.createFromExistingGui(frames.easyDevControlsPermissions.target, "EasyDevControlsPermissionsFrame")
    EasyDevControlsHelpFrame.createFromExistingGui(frames.easyDevControlsHelp.target, "EasyDevControlsHelpFrame")

    if guiManager.classicMenu ~= nil and guiManager.classicMenu.pagingElement ~= nil then
        restorePageIndex = guiManager.classicMenu.pagingElement.currentPageIndex
    end

    local controller = EasyDevControlsMenu.new()

    g_gui.guis.EasyDevControlsMenu:delete()
    g_gui.guis.EasyDevControlsMenu.target:delete()
    g_gui:loadGui(gui.xmlFilename, guiName, controller)

    controller:onMissionFinishedLoading(g_currentMission)

    controller.restorePageIndex = restorePageIndex
    guiManager.classicMenu = controller

    if not g_easyDevControlsReloadingTranslations then
        g_gui:showGui("EasyDevControlsMenu")
    end

    return controller
end

function EasyDevControlsMenu:exposeControlsAsFields(viewName)
    -- It is great not needing to manually register controls in FS25 but it makes no sense to expose fields that belong to a frameRef in my view
    local allChildren = self:getDescendants()

    for _, element in pairs(allChildren) do
        if element.id and element.id ~= "" then
            local index, varName = GuiElement.extractIndexAndNameFromID(element.id)

            if EasyDevControlsMenu.VALID_CONTROLS[varName] == true then
                if index then
                    if not self[varName] then
                        self[varName] = {}
                    end

                    self[varName][index] = element
                else
                    self[varName] = element
                end

                self.controlIDs[varName] = true
            end
        end
    end
end

function EasyDevControlsMenu:copyAttributes(src)
    EasyDevControlsMenu:superClass().copyAttributes(self, src)

    self.isMultiplayer = src.isMultiplayer
    self.connectedToDedicatedServer = src.connectedToDedicatedServer

    self.performBackgroundBlur = src.performBackgroundBlur
    self.userRemovedBackgroundBlur = src.userRemovedBackgroundBlur

    self.pendingServerRequest = src.pendingServerRequest
end

function EasyDevControlsMenu:onGuiSetupFinished()
    EasyDevControlsMenu:superClass().onGuiSetupFinished(self)

    self:initializePages()
    self:setupPages()
end

function EasyDevControlsMenu:onMissionFinishedLoading(currentMission)
    self.isMultiplayer = currentMission.missionDynamicInfo.isMultiplayer or g_easyDevControlsSimulateMultiplayer
    self.connectedToDedicatedServer = currentMission.connectedToDedicatedServer

    for _, pageData in ipairs (g_easyDevControlsGuiManager:getPages()) do
        local page = self[pageData.id]

        if page ~= nil and page.onMissionFinishedLoading ~= nil then
            page:onMissionFinishedLoading(currentMission)
        end
    end
end

function EasyDevControlsMenu:initializePages()
    self.clickBackCallback = self:makeSelfCallback(self.onButtonBack)

    for _, pageData in ipairs (g_easyDevControlsGuiManager:getPages()) do
        local page = self[pageData.id]

        if page ~= nil and page.initialize ~= nil then
            page:initialize()
        end
    end
end

function EasyDevControlsMenu:setupPages()
    self.clickBackCallback = self:makeSelfCallback(self.onButtonBack)

    for _, pageData in ipairs (g_easyDevControlsGuiManager:getPages()) do
        local page = self[pageData.id]

        if page ~= nil then
            self:registerPage(page, index, self:makeIsVisiblePredicate(pageData.multiplayerOnly))
            self:addPageTab(page, nil, nil, pageData.sliceId)
        end
    end

    self:rebuildTabList()
end

function EasyDevControlsMenu:setupMenuButtonInfo()
    EasyDevControlsMenu:superClass().setupMenuButtonInfo(self)

    local clickBackCallback = self.clickBackCallback
    local pagePreviousCallback = self:makeSelfCallback(self.onPagePrevious)
    local pageNextCallback = self:makeSelfCallback(self.onPageNext)
    local clickResetCallback = self:makeSelfCallback(self.onButtonReset)
    local clickBackgroundCallback = self:makeSelfCallback(self.onButtonBackground)
    local removeBlurButtonText = EasyDevControlsUtils.getText("easyDevControls_removeBlurButton")

    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK,
        text = g_i18n:getText("button_back"),
        callback = clickBackCallback
    }

    self.nextPageButtonInfo = {
        inputAction = InputAction.MENU_PAGE_NEXT,
        text = g_i18n:getText("ui_ingameMenuNext"),
        callback = self.onPageNext
    }

    self.prevPageButtonInfo = {
        inputAction = InputAction.MENU_PAGE_PREV,
        text = g_i18n:getText("ui_ingameMenuPrev"),
        callback = self.onPagePrevious
    }

    self.resetButtonInfo = {
        showWhenPaused = true,
        inputAction = InputAction.MENU_EXTRA_1,
        text = g_i18n:getText("button_defaults"),
        callback = self.onButtonReset
    }

    self.backgroundButtonInfo = {
        showWhenPaused = true,
        inputAction = InputAction.MENU_EXTRA_2,
        addText = EasyDevControlsUtils.getText("easyDevControls_addBlurButton"),
        removeText = removeBlurButtonText,
        text = removeBlurButtonText,
        callback = self.onButtonBackground
    }

    self.defaultMenuButtonInfo = {
        self.backButtonInfo,
        self.nextPageButtonInfo,
        self.prevPageButtonInfo,
        self.resetButtonInfo,
        self.backgroundButtonInfo
    }

    self.defaultMenuButtonInfoByActions[InputAction.MENU_BACK] = self.defaultMenuButtonInfo[1]
    self.defaultMenuButtonInfoByActions[InputAction.MENU_PAGE_PREV] = self.defaultMenuButtonInfo[2]
    self.defaultMenuButtonInfoByActions[InputAction.MENU_PAGE_NEXT] = self.defaultMenuButtonInfo[3]
    self.defaultMenuButtonInfoByActions[InputAction.MENU_EXTRA_1] = self.defaultMenuButtonInfo[4]
    self.defaultMenuButtonInfoByActions[InputAction.MENU_EXTRA_2] = self.defaultMenuButtonInfo[5]

    self.defaultButtonActionCallbacks = {
        [InputAction.MENU_BACK] = clickBackCallback,
        [InputAction.MENU_PAGE_PREV] = pagePreviousCallback,
        [InputAction.MENU_PAGE_NEXT] = pageNextCallback,
        [InputAction.MENU_EXTRA_1] = clickResetCallback,
        [InputAction.MENU_EXTRA_2] = clickBackgroundCallback
    }
end

function EasyDevControlsMenu:onMenuOpened()
    if self.isMultiplayer then
        g_messageCenter:subscribe(MessageType.EDC_SERVER_REQUEST_SENT, self.onServerRequestSent, self)
        g_messageCenter:subscribe(MessageType.EDC_SERVER_REQUEST_COMPLETED, self.onServerRequestCompleted, self)

        g_messageCenter:subscribe(MessageType.EDC_ACCESS_LEVEL_CHANGED, self.onAccessLevelChanged, self)
        g_messageCenter:subscribe(MessageType.EDC_PERMISSIONS_CHANGED, self.onPermissionsChanged, self)
    end

    g_messageCenter:subscribe(MessageType.EDC_COMMAND_STATE_CHANGED, self.onCommandStateChanged, self)

    if g_easyDevControlsSettings:getValue("toggleMenuMode", false) then
        local _, eventId = g_inputBinding:registerActionEvent(InputAction.EDC_SHOW_UI, self, self.onExitMenuActionEvent, false, true, false, true)

        g_inputBinding:setActionEventTextVisibility(eventId, false)

        self.exitMenuEventId = eventId
        self.exitMenuInputDelay = self.time + 250
    end
end

function EasyDevControlsMenu:onClose()
    EasyDevControlsMenu:superClass().onClose(self)

    g_messageCenter:unsubscribeAll(self)

    if self.exitMenuEventId ~= nil then
        g_inputBinding:removeActionEvent(self.exitMenuEventId)
        self.exitMenuEventId = nil
    end

    if self.pendingServerRequest ~= nil then
        self.pendingServerRequest = nil

        MessageDialog.hide()
    end

    self:setBackgroundVisable(true, true)
end

function EasyDevControlsMenu:onPageChange(pageIndex, pageMappingIndex, element, skipTabVisualUpdate)
    if not self.performBackgroundBlur or self.userRemovedBackgroundBlur then
        local page = self.pagingElement:getPageElementByIndex(pageIndex)

        if page == self.pagePermissions or page == self.pageHelp then
            self:setBackgroundVisable(true, false)
        elseif self.userRemovedBackgroundBlur and self.performBackgroundBlur then
            self:setBackgroundVisable(false, false)
        end
    end

    EasyDevControlsMenu:superClass().onPageChange(self, pageIndex, pageMappingIndex, element, skipTabVisualUpdate)
end

function EasyDevControlsMenu:onServerRequestSent(eventClass, message, currentLatency)
    if eventClass == nil then
        return
    end

    local hasReply = not eventClass.NO_REPLY

    currentLatency = currentLatency or 80

    if currentLatency >= 80 then
        local endTimeSec = getTimeSec() + (hasReply and EasyDevControlsMenu.MAX_SERVER_REQUEST_TIME_SEC or (currentLatency * 6) / 1000)

        if message == nil then
            message = EasyDevControlsUtils.getText("easyDevControls_serverRequestMessage")
        end

        MessageDialog.show(message, EasyDevControlsMenu.messageDialogUpdate, self, DialogElement.TYPE_LOADING, false, endTimeSec)
    end

    if hasReply then
        self.pendingServerRequest = eventClass
    end
end

function EasyDevControlsMenu:onServerRequestCompleted(eventClass, errorCode, infoText, infoTextOnError)
    if self.pendingServerRequest == eventClass then
        self.pendingServerRequest = nil

        MessageDialog.hide()

        if self.currentPage ~= nil then
            if self.currentPage.intervalTimeRemaining ~= nil then
                self.currentPage.intervalTimeRemaining = 500 -- No harm allowing an update in case the command displays info
            end

            if self.currentPage.setInfoText ~= nil then
                if errorCode == EasyDevControlsErrorCodes.SUCCESS or (infoTextOnError and not string.isNilOrWhitespace(infoText)) then
                    self.currentPage:setInfoText(infoText, errorCode)
                else
                    self.currentPage:setInfoText(EasyDevControlsErrorCodes.getText(errorCode), errorCode)
                end
            end
        end
    end
end

function EasyDevControlsMenu:onAccessLevelChanged(accessLevel)
    for i, pageFrameElement in ipairs (self.pageFrames) do
        if pageFrameElement.onAccessLevelChanged ~= nil then
            pageFrameElement:onAccessLevelChanged(accessLevel)
        end
    end
end

function EasyDevControlsMenu:onPermissionsChanged()
    if self.currentPage ~= nil and self.currentPage.onUpdateCommands ~= nil then
        self.isResettingCommands = false
        self.currentPage:onUpdateCommands(true)
    end
end

function EasyDevControlsMenu:onCommandStateChanged(name, pageName)
    if self.currentPage ~= nil and self.currentPage.onCommandChanged ~= nil then
        if string.isNilOrWhitespace(pageName) or pageName == self.currentPage.pageName then
            self.currentPage:onCommandChanged(name, false)
        end
    end
end

function EasyDevControlsMenu:onButtonBack()
    local currentPage = self.currentPage

    if currentPage ~= nil and currentPage == self.pagePermissions and not currentPage:requestClose(self.clickBackCallback) then
        return
    end

    EasyDevControlsMenu:superClass().onButtonBack(self)
end

function EasyDevControlsMenu:onButtonReset()
    if self.currentPage ~= nil then
        local function onResetPageCallback(yes)
            if yes then
                if self.currentPage.onUpdateCommands ~= nil then
                    self.currentPage.isResettingCommands = true
                    self.currentPage:onUpdateCommands(true)
                    self.currentPage.isResettingCommands = false

                    if self.currentPage.setInfoText ~= nil then
                        self.currentPage:setInfoText(EasyDevControlsUtils.getText("easyDevControls_resetPageSuccess"))
                    end
                else
                    EasyDevControlsLogging.devInfo("Missing function 'onUpdateCommands' for '%s' frame!", self.currentPage.pageName)
                end
            end
        end

        YesNoDialog.show(onResetPageCallback, nil, EasyDevControlsUtils.getText("easyDevControls_resetPageWarning"), g_i18n:getText("button_reset"))
    end
end

function EasyDevControlsMenu:onButtonBackground()
    self:setBackgroundVisable(nil, false)
    self.userRemovedBackgroundBlur = not self.performBackgroundBlur
end

function EasyDevControlsMenu:onExitMenuActionEvent(action, value, eventUsed)
    if self.exitMenuInputDelay >= self.time then
        return
    end

    if g_easyDevControlsSettings:getValue("toggleMenuMode", false) then
        self:playSample(GuiSoundPlayer.SOUND_SAMPLES.BACK)
        self:exitMenu()
    end
end

function EasyDevControlsMenu:setBackgroundVisable(isVisible, isClosing)
    if not isClosing then
        if isVisible == nil then
            isVisible = not self.performBackgroundBlur
        end

        if self.performBackgroundBlur then
            if not isVisible then
                g_depthOfFieldManager:popArea()
            end
        else
            if isVisible then
                g_depthOfFieldManager:pushArea(0, 0, 1, 1)
            end
        end
    else
        isVisible = true
    end

    if self.performBackgroundBlur ~= isVisible then
        self.performBackgroundBlur = isVisible

        self.background:setVisible(isVisible)
        self.backgroundButtonInfo.text = isVisible and self.backgroundButtonInfo.removeText or self.backgroundButtonInfo.addText

        if self.currentPage ~= nil then
            self:updateButtonsPanel(self.currentPage)
        end
    end
end

function EasyDevControlsMenu:makeIsVisiblePredicate(multiplayerOnly)
    if multiplayerOnly then
        return function()
            return self.isMultiplayer
        end
    end

    return function()
        return true
    end
end

function EasyDevControlsMenu.messageDialogUpdate(_, dt, endTimeSec)
    if endTimeSec ~= nil and endTimeSec <= getTimeSec() then
        MessageDialog.hide() -- Close if it takes to long, possible network error...
        self.pendingServerRequest = nil
    end
end
