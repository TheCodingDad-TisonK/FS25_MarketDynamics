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

EasyDevControlsBaseFrame = {}
EasyDevControlsBaseFrame.NAME = "BASE"

local EasyDevControlsBaseFrame_mt = Class(EasyDevControlsBaseFrame, TabbedMenuFrameElement)

function EasyDevControlsBaseFrame.new(target, custom_mt)
    local self = TabbedMenuFrameElement.new(nil, custom_mt or EasyDevControlsBaseFrame_mt)

    self.pageName = EasyDevControlsBaseFrame.NAME

    self.isOpen = false
    self.isResettingCommands = false
    self.autoSetFocusOnOpen = true

    self.hasInfoText = false
    self.updateTimeInfoText = 0

    self.commandChangedCallbacks = {}

    return self
end

function EasyDevControlsBaseFrame:onFrameOpen()
    EasyDevControlsBaseFrame:superClass().onFrameOpen(self)

    self.isOpening = true
    self.isResettingCommands = false
    self:onUpdateCommands(false)

    self:onFrameOpening()
    self.isOpening = false
    self.isOpen = true

    self:setInfoText(self.onOpenInfoText, self.onOpenInfoErrorCode)
    self.onOpenInfoText = nil
    self.onOpenInfoErrorCode = nil

    if self.autoSetFocusOnOpen and FocusManager:getFocusedElement() == nil then
        self:setSoundSuppressed(true)

        if self.boxLayout ~= nil then
            FocusManager:setFocus(self.boxLayout)
        else
            FocusManager:setFocus(self:findFirstFocusable(true)) -- ??
        end

        self:setSoundSuppressed(false)
    end
end

function EasyDevControlsBaseFrame:onFrameClose()
    EasyDevControlsBaseFrame:superClass().onFrameClose(self)

    g_messageCenter:unsubscribeAll(self) -- Handles any subscribers

    self.isOpen = false

    if self.infoBoxText ~= nil then
        self.hasInfoText = false
        self.infoBoxText:setText("")
    end
end

function EasyDevControlsBaseFrame:onFrameOpening()
end

function EasyDevControlsBaseFrame:onCommandChanged(name, resetToDefault)
    if self.isOpen then
        local callback = self.commandChangedCallbacks[name]

        if callback ~= nil then
            callback(self, name, resetToDefault)

            -- EasyDevControlsLogging.devInfo("Updated command '%s' (resetToDefault = %s) on page %s", name, resetToDefault == true, self.pageName)
        end
    end
end

function EasyDevControlsBaseFrame:onAccessLevelChanged(accessLevel)
    if self.isOpen then
        self.isResettingCommands = false
        self:onUpdateCommands(false)

        EasyDevControlsLogging.devInfo("Access level changed, available properties for frame '%s' updated.", self.pageName)
    end
end

function EasyDevControlsBaseFrame:onUpdateCommands(resetToDefault)
end

function EasyDevControlsBaseFrame:update(dt)
    EasyDevControlsBaseFrame:superClass().update(self, dt)

    if self.hasInfoText and self.infoBoxText ~= nil then
        if getTimeSec() > self.updateTimeInfoText then
            self.infoBoxText:setText("")
            self:setInfoIcon(nil)
            self.hasInfoText = false
        end
    end
end

function EasyDevControlsBaseFrame:setInfoText(text, errorCode)
    if self.isOpen then
        if self.infoBoxText ~= nil and not self.isResettingCommands then
            if text ~= nil then
                if self.infoBoxText.text ~= text then
                    self.infoBoxText:setText(text)
                    self:setInfoIcon(errorCode)
                end

                if text ~= "" then
                    self.updateTimeInfoText = getTimeSec() + 10
                    self.hasInfoText = true
                end
            else
                self.hasInfoText = false
                self.infoBoxText:setText("")
                self:setInfoIcon(nil)
            end
        end
    else
        self.onOpenInfoText = text
        self.onOpenInfoErrorCode = errorCode
    end
end

function EasyDevControlsBaseFrame:setInfoIcon(errorCode)
     local noError = errorCode == nil or errorCode == EasyDevControlsErrorCodes.SUCCESS or errorCode == EasyDevControlsErrorCodes.NONE

     if self.infoBoxIcon ~= nil then
        if noError then
            self.infoBoxIcon:setImageColor(nil, 0.89627, 0.92158, 0.81485, 0.4) -- Default white
        else
            self.infoBoxIcon:setImageColor(nil, 0.53328, 0.06301, 0.00335, 1) -- Warning orange
        end
     end

     if self.infoBoxErrorText ~= nil then
        self.infoBoxText:setText(noError and "" or "(" .. tostring(errorCode) .. ")")
     end
end

function EasyDevControlsBaseFrame:setCommandChangedCallback(name, callback)
    if callback == nil then
        EasyDevControlsLogging.devError("Failed to add command changed callback, no callback given for command %s on page %s", name, self.pageName)

        return false
    end

    self.commandChangedCallbacks[name] = callback

    return true
end

function EasyDevControlsBaseFrame:onClickShowInfo(element)
    local tabbedMenu = self.parent.target

    if tabbedMenu ~= nil and tabbedMenu.pageHelp ~= nil and tabbedMenu.pagingElement ~= nil then
        local pageMappingIndex = tabbedMenu.pagingElement:getPageMappingIndexByElement(tabbedMenu.pageHelp)
        local currentPageIndex = tabbedMenu.pagingElement.currentPageIndex

        if pageMappingIndex ~= nil and tabbedMenu.pageSelector ~= nil then
            tabbedMenu.pageSelector:setState(pageMappingIndex, true)
            tabbedMenu.pageHelp:openPage(currentPageIndex or 1)
        end
    end
end

function EasyDevControlsBaseFrame:onTextInputTextChanged(textInputElement, text)
    if not string.isNilOrWhitespace(text) then
        if textInputElement.allowInvalidText or (tonumber(text) or -1) - 0.001 > 0 then
            textInputElement.lastValidText = text
        else
            textInputElement:setText(textInputElement.lastValidText or "")
        end
    else
        textInputElement.lastValidText = ""
    end
end

function EasyDevControlsBaseFrame:onTextInputEscPressed(textInputElement)
    textInputElement:setText("")
    textInputElement.lastValidText = ""
end

function EasyDevControlsBaseFrame:getHasPermission(name)
    return g_easyDevControlsGuiManager:getHasPermission(name)
end

function EasyDevControlsBaseFrame:getCanShowDialogs()
    return self.isOpen and not self.isResettingCommands
end

function EasyDevControlsBaseFrame:getHasInfoBox()
    return self.infoBoxText ~= nil
end
