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

EasyDevControlsPermissionsFrame = {}
EasyDevControlsPermissionsFrame.NAME = "PERMISSIONS"

EasyDevControlsPermissionsFrame.COLOURS = {
    ONLINE = {0, 1, 0, 1},
    OFFLINE = {1, 0, 0, 1}
}

local EasyDevControlsPermissionsFrame_mt = Class(EasyDevControlsPermissionsFrame, EasyDevControlsBaseFrame)

function EasyDevControlsPermissionsFrame.register()
    local controller = EasyDevControlsPermissionsFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsPermissionsFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsPermissionsFrame", controller, true)

    return controller
end

function EasyDevControlsPermissionsFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsPermissionsFrame_mt)

    self.pageName = EasyDevControlsPermissionsFrame.NAME

    self.requiresSave = false

    self.autoSetFocusOnOpen = false
    self.numActiveElements = 0

    self.currentPermissions = {}
    self.changedPermissions = {}

    self.multiTextOptionElements = {}
    self.multiTextOptionElementByName = {}

    return self
end

function EasyDevControlsPermissionsFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsPermissionsFrame.register()
end

function EasyDevControlsPermissionsFrame:copyAttributes(src)
    EasyDevControlsPermissionsFrame:superClass().copyAttributes(self, src)

    self.requiresSave = src.requiresSave

    self.currentPermissions = src.currentPermissions
    self.changedPermissions = src.changedPermissions

    self.multiTextOptionElements = src.multiTextOptionElements
    self.multiTextOptionElementByName = src.multiTextOptionElementByName
end

function EasyDevControlsPermissionsFrame:initialize()
    self.edcAdminLoginText = EasyDevControlsUtils.getText("easyDevControls_adminLogin")
    self.gameAdminLoginText = g_i18n:getText("button_adminLogin")

    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
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

    self.adminLoginButtonInfo = {
        inputAction = InputAction.MENU_ACTIVATE,
        text = "",
        callback = function ()
            self:onButtonAdminLogin()
        end
    }

    self.adminLogoutButtonInfo = {
        inputAction = InputAction.MENU_EXTRA_1,
        text = EasyDevControlsUtils.getText("easyDevControls_adminLogout"),
        callback = function ()
            self:onButtonAdminLogout()
        end
    }

    self.adminChangePasswordButtonInfo = {
        inputAction = InputAction.MENU_EXTRA_2,
        text = EasyDevControlsUtils.getText("easyDevControls_changePassword"),
        callback = function ()
            self:onButtonAdminChangePassword()
        end
    }

    self.saveButtonInfo = {
        showWhenPaused = true,
        inputAction = InputAction.MENU_ACTIVATE,
        text = g_i18n:getText("button_save"),
        callback = function()
            self:saveChanges()
        end
    }

    self.permissionsCategoryTemplate:unlinkElement()
    FocusManager:removeElement(self.permissionsCategoryTemplate)

    self.permissionsMultiTextOptionTemplate:unlinkElement()
    FocusManager:removeElement(self.permissionsMultiTextOptionTemplate)

    --self:initializeScrollingLayout()
end

function EasyDevControlsPermissionsFrame:initializeScrollingLayout()
    self.initialisingScrollingLayout = true

    self.multiTextOptionElements = {}
    self.multiTextOptionElementByName = {}

    local multiTextOptionElements = self.multiTextOptionElements
    local multiTextOptionElementByName = self.multiTextOptionElementByName
    local scrollingLayoutElement = self.permissionsScrollingLayout

    for i = #scrollingLayoutElement.elements, 1, -1 do
        scrollingLayoutElement.elements[i]:delete()
    end

    local categoryContainer = self.permissionsCategoryTemplate
    local multiTextOptionContainer = self.permissionsMultiTextOptionTemplate

    local disabledText = EasyDevControlsUtils.getText("easyDevControls_unsupported") -- easyDevControls_disabled
    local singlePlayerOnlyText = EasyDevControlsUtils.getText("easyDevControls_singlePlayerOnly")

    local permissionTexts = {
        string.format("EDC %s", g_i18n:getText("ui_admin")),
        g_i18n:getText("ui_admin"),
        g_i18n:getText("ui_farmManager"),
        g_i18n:getText("configuration_valueDefault"),
        g_i18n:getText("ui_none")
    }

    local alternatingColours = {
        [false] = {
            0.02956,
            0.02956,
            0.02956,
            0.6
        },
        [true] = {
            0.02956,
            0.02956,
            0.02956,
            0.2
        }
    }

    local guiManager = g_easyDevControlsGuiManager
    local isMultiplayer = guiManager.isMultiplayer
    local isAlternating = false
    local toolTipTitleText = ""
    local numDisabledElements = 0

    for _, page in ipairs (guiManager:getPages()) do
        if page.permissions ~= nil and #page.permissions > 0 then
            local categoryContainerElement = categoryContainer:clone(scrollingLayoutElement)
            local categoryIconElement = categoryContainerElement:getDescendantByName("icon")
            local categoryTitleElement = categoryContainerElement:getDescendantByName("title")

            if page.sliceId ~= nil then
                categoryIconElement:setImageSlice(nil, page.sliceId)
                categoryIconElement:setVisible(true)
            else
                categoryIconElement:setVisible(false)
            end

            categoryTitleElement:setText(page.title or "TO_DO")
            categoryContainerElement:reloadFocusHandling(true)
            isAlternating = false

            for _, permission in ipairs (page.permissions) do
                local multiTextOptionContainerElement = multiTextOptionContainer:clone(scrollingLayoutElement)
                local titleElement = multiTextOptionContainerElement:getDescendantByName("title")
                local multiTextOptionElement = multiTextOptionContainerElement:getDescendantByName("multiTextOption")
                local toolTipElement = multiTextOptionElement:getDescendantByName("toolTip")

                local multiTextOptionDisabled = permission.disabled or (isMultiplayer and permission.singlePlayerOnly)
                local maximumAccessLevel = not multiTextOptionDisabled and permission.maximumAccessLevel or 1
                local multiTextOptionTexts = table.create(maximumAccessLevel)

                titleElement:setText(permission.title)

                if not multiTextOptionDisabled then
                    for i = 1, maximumAccessLevel do
                        table.insert(multiTextOptionTexts, permissionTexts[i])
                    end
                else
                    table.insert(multiTextOptionTexts, (permission.disabled and disabledText or singlePlayerOnlyText))

                    numDisabledElements += 1
                end

                multiTextOptionElement:setTexts(multiTextOptionTexts)
                multiTextOptionElement:setState(permission.accessLevel)

                multiTextOptionElement:setDisabled(multiTextOptionDisabled)

                multiTextOptionElement.id = nil
                multiTextOptionElement.name = permission.name

                table.insert(multiTextOptionElements, multiTextOptionElement)
                multiTextOptionElementByName[permission.name] = multiTextOptionElement

                toolTipElement:setText(permission.toolTipText or "")

                multiTextOptionContainerElement:setImageColor(nil, unpack(alternatingColours[isAlternating]))
                multiTextOptionContainerElement:reloadFocusHandling(true)

                isAlternating = not isAlternating
            end
        end
    end

    local firstElement = multiTextOptionElements[1]

    if firstElement ~= nil then
        firstElement.forceFocusScrollToTop = true
    end

    scrollingLayoutElement.wrapAround = true
    scrollingLayoutElement:scrollTo(0, true)
    scrollingLayoutElement:invalidateLayout()

    local elementsToLink = multiTextOptionElements

    if numDisabledElements > 0 then
        elementsToLink = table.create(#multiTextOptionElements - numDisabledElements)

        for _, multiTextOptionElement in ipairs (multiTextOptionElements) do
            if not multiTextOptionElement.disabled then
                table.insert(elementsToLink, multiTextOptionElement)
            end
        end
    end

    for i = 1, #elementsToLink do
        local multiTextOptionElement = elementsToLink[i]
        local topMultiTextOptionElement = elementsToLink[i - 1]
        local bottomMultiTextOptionElement = elementsToLink[i + 1]

        if topMultiTextOptionElement ~= nil then
            FocusManager:linkElements(multiTextOptionElement, FocusManager.TOP, topMultiTextOptionElement)
        else
            FocusManager:linkElements(multiTextOptionElement, FocusManager.TOP, elementsToLink[#elementsToLink])
        end

        if bottomMultiTextOptionElement ~= nil then
            FocusManager:linkElements(multiTextOptionElement, FocusManager.BOTTOM, bottomMultiTextOptionElement)
        else
            FocusManager:linkElements(multiTextOptionElement, FocusManager.BOTTOM, elementsToLink[1])
        end
    end

    self.initialisingScrollingLayout = false
end

function EasyDevControlsPermissionsFrame:delete()
    if self.permissionsCategoryTemplate ~= nil then
        self.permissionsCategoryTemplate:delete()
    end

    if self.permissionsMultiTextOptionTemplate ~= nil then
        self.permissionsMultiTextOptionTemplate:delete()
    end

    EasyDevControlsPermissionsFrame:superClass().delete(self)
end

function EasyDevControlsPermissionsFrame:updateMenuButtons()
    self.menuButtonInfo = {
        self.backButtonInfo,
        self.nextPageButtonInfo,
        self.prevPageButtonInfo
    }

    if g_currentMission.connectedToDedicatedServer then
        if g_easyDevControlsGuiManager.isMasterUser then
            table.insert(self.menuButtonInfo, self.adminChangePasswordButtonInfo)
            table.insert(self.menuButtonInfo, self.adminLogoutButtonInfo)
        else
            self.adminLoginButtonInfo.text = g_currentMission.isMasterUser and self.edcAdminLoginText or self.gameAdminLoginText
            table.insert(self.menuButtonInfo, self.adminLoginButtonInfo)
        end
    end

    if self.requiresSave then
        table.insert(self.menuButtonInfo, self.saveButtonInfo)
    end

    self:setMenuButtonInfoDirty()
end

function EasyDevControlsPermissionsFrame:onUpdateCommands(resetToDefault)
    self:updateProperties()
    self:updateMenuButtons()

    self.permissionsSlider.handleFocus = self.numActiveElements == 0

    if self.permissionsSlider.handleFocus then
        FocusManager:setFocus(self.permissionsSlider)
    else
        local focusedElement = FocusManager:getFocusedElement()

        if focusedElement == nil or focusedElement == self.permissionsSlider then
            self:setSoundSuppressed(true)
            FocusManager:setFocus(self:findFirstFocusable(true))
            self:setSoundSuppressed(false)
        end
    end
end

function EasyDevControlsPermissionsFrame:onAccessLevelChanged(accessLevel)
    if self.isOpen then
        self:onUpdateCommands(false)
    end
end

function EasyDevControlsPermissionsFrame:requestClose(callback)
    if self.requiresSave then
        EasyDevControlsPermissionsFrame:superClass().requestClose(self, callback)

        YesNoDialog.show(self.onYesNoSavePermissions, self, g_i18n:getText("ui_saveChanges"))

        return false
    end

    return true
end

function EasyDevControlsPermissionsFrame:onClickPermission(accessLevel, multiTextOptionElement)
    local permissionName = multiTextOptionElement.name

    if permissionName ~= nil then
        if self.currentPermissions[permissionName] ~= accessLevel then
            self.changedPermissions[permissionName] = accessLevel
        else
            self.changedPermissions[permissionName] = nil
        end

        self.requiresSave = next(self.changedPermissions) ~= nil
        self:updateMenuButtons()
    end
end

function EasyDevControlsPermissionsFrame:updateProperties()
    local guiManager = g_easyDevControlsGuiManager

    local isMultiplayer = guiManager.isMultiplayer
    local permissions = guiManager:getPermissions()

    local multiTextOptionElement, permissionName, accessLevel = nil, "", 0
    local disableElements = guiManager.isMasterUser ~= true
    local disabled = true

    self.numActiveElements = 0
    self.requiresSave = false
    self.currentPermissions = {}
    self.changedPermissions = {}

    if #permissions ~= #self.multiTextOptionElements then
        self:initializeScrollingLayout()

        EasyDevControlsLogging.devInfo("Permissions have changed, scrolling layout has been re-initialised.")
    end

    for _, permission in ipairs (permissions) do
        disabled = disableElements or permission.disabled or (isMultiplayer and permission.singlePlayerOnly)

        permissionName, accessLevel = permission.name, permission.accessLevel
        multiTextOptionElement = self.multiTextOptionElementByName[permissionName]

        multiTextOptionElement:setState(accessLevel)
        multiTextOptionElement:setDisabled(disabled)

        self.currentPermissions[permissionName] = accessLevel

        if not disabled then
            self.numActiveElements += 1
        end
    end
end

function EasyDevControlsPermissionsFrame:saveChanges()
    local guiManager = g_easyDevControlsGuiManager
    local permissionsToSync = {}
    local numPermissionsChanged = 0

    for permissionName, accessLevel in pairs (self.changedPermissions) do
        if guiManager:setPermissionAccessLevel(permissionName, accessLevel) then
            self.currentPermissions[permissionName] = accessLevel

            table.insert(permissionsToSync, {
                name = permissionName,
                accessLevel = accessLevel
            })

            numPermissionsChanged += 1
        end
    end

    self.requiresSave = false
    self.changedPermissions = {}

    self:updateMenuButtons()

    if numPermissionsChanged > 0 then
        EasyDevControlsPermissionsEvent.sendEvent(permissionsToSync, false)

        local text = g_i18n:getText("ui_savingFinished")

        self:setInfoText(string.format("%s (%s: %d)", text, g_i18n:getText("ui_permissions"), numPermissionsChanged))

        InfoDialog.show(text, self.requestCloseCallback)
    else
        local text = EasyDevControlsUtils.getText("easyDevControls_savingFailed")

        self:setInfoText(text, EasyDevControlsErrorCodes.FAILED)

        InfoDialog.show(text, self.requestCloseCallback)
    end

    self.requestCloseCallback = NO_CALLBACK
end

function EasyDevControlsPermissionsFrame:onYesNoSavePermissions(yes)
    if yes then
        self:saveChanges()
    else
        self:updateProperties()
        self:updateMenuButtons()

        self.requestCloseCallback() -- Complete then page close
        self.requestCloseCallback = NO_CALLBACK --  Clear callback
    end
end

function EasyDevControlsPermissionsFrame:onButtonAdminLogin()
    if g_currentMission.isMasterUser then
        PasswordDialog.show(self.onAdminPasswordEntered, self, nil, "", EasyDevControlsUtils.getText("easyDevControls_adminLogin"))
    else
        PasswordDialog.show(self.onAdminPasswordEntered, self, nil, "", g_i18n:getText("button_adminLogin"))
    end
end

function EasyDevControlsPermissionsFrame:onButtonAdminChangePassword()
    PasswordDialog.show(self.onAdminPasswordChanged, self, nil, "", EasyDevControlsUtils.getText("easyDevControls_changePassword"))
end

function EasyDevControlsPermissionsFrame:onButtonAdminLogout()
    if g_easyDevControlsGuiManager:setIsMasterUser(false) then
        g_client:getServerConnection():sendEvent(EasyDevControlsAdminEvent.new(true, "", false))
        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_loggedOut", getDate("%Y/%m/%d %H:%M")))
    else
        g_easyDevControlsGuiManager:updateAccessLevel(true)
    end
end

function EasyDevControlsPermissionsFrame:onAdminPasswordEntered(password, yes)
    if yes then
        if g_currentMission.isMasterUser then
            g_messageCenter:subscribe(EasyDevControlsAdminEvent, self.onAdminPasswordServerReply, self)
            g_client:getServerConnection():sendEvent(EasyDevControlsAdminEvent.new(false, password, false))
        else
            g_messageCenter:subscribe(GetAdminAnswerEvent, self.onAdminAccessGranted, self)
            g_client:getServerConnection():sendEvent(GetAdminEvent.new(password))
        end
    end
end

function EasyDevControlsPermissionsFrame:onAdminPasswordChanged(password, yes)
    if yes then
        if string.isNilOrWhitespace(password) then
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_passwordInvalid"), EasyDevControlsErrorCodes.FAILED)

            return
        end

        g_messageCenter:subscribe(EasyDevControlsAdminEvent, self.onAdminPasswordServerReply, self)
        g_client:getServerConnection():sendEvent(EasyDevControlsAdminEvent.new(false, password, true))
    end
end

function EasyDevControlsPermissionsFrame:onAdminPasswordServerReply(accessState)
    g_messageCenter:unsubscribe(EasyDevControlsAdminEvent, self)

    if accessState == EasyDevControlsAdminEvent.ACCESS_GRANTED then
        g_easyDevControlsGuiManager:setIsMasterUser(true)
        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_loggedIn", getDate("%Y/%m/%d %H:%M")))
    elseif accessState == EasyDevControlsAdminEvent.ACCESS_DENIED then
        InfoDialog.show(g_i18n:getText("ui_wrongPassword"))
    elseif accessState == EasyDevControlsAdminEvent.CHANGED_PASSWORD then
        g_easyDevControlsGuiManager:updateAccessLevel(true)
        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_passwordChanged", getDate("%Y/%m/%d %H:%M")))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_unknownFailMessage"), EasyDevControlsErrorCodes.UNKNOWN_FAIL)
    end
end

function EasyDevControlsPermissionsFrame:onAdminAccessGranted()
    g_messageCenter:unsubscribe(GetAdminAnswerEvent, self)
    g_easyDevControlsGuiManager:updateAccessLevel(true)
end
