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

EasyDevControlsDynamicSelectionDialog = {}

EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION = 0
EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION = 1
EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT = 2
EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON = 3
EasyDevControlsDynamicSelectionDialog.TYPE_SPACER = 4

EasyDevControlsDynamicSelectionDialog.ANCHOR_MIDDLE = 0
EasyDevControlsDynamicSelectionDialog.ANCHOR_RIGHT = 1
EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM = 2

local EasyDevControlsDynamicSelectionDialog_mt = Class(EasyDevControlsDynamicSelectionDialog, ScreenElement)

function EasyDevControlsDynamicSelectionDialog.register()
    local dynamicSelectionDialog = EasyDevControlsDynamicSelectionDialog.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/dialogs/EasyDevControlsDynamicSelectionDialog.xml")

    g_gui:loadGui(filename, "EasyDevControlsDynamicSelectionDialog", dynamicSelectionDialog)
    EasyDevControlsDynamicSelectionDialog.INSTANCE = dynamicSelectionDialog

    return dynamicSelectionDialog
end

function EasyDevControlsDynamicSelectionDialog.show(headerText, properties, callback, callbackTarget, numRows, flowDirection, anchorPosition, hideBackground, onCloseTarget, onCloseArguments, confirmButtonDisabled, confirmButtonAction, confirmText, applyButtonDisabled, applyButtonAction, applyText, backText)
    local dialog = EasyDevControlsDynamicSelectionDialog.INSTANCE

    if dialog ~= nil then
        dialog:setHeader(headerText, hideBackground)
        dialog:setCallback(callback, callbackTarget)
        dialog:setNotifyOnClose(onCloseTarget, onCloseArguments)
        dialog:setButtonsDisabled(applyButtonDisabled, applyButtonAction, confirmButtonDisabled, confirmButtonAction)
        dialog:setButtonTexts(applyText, confirmText, backText)
        dialog:setAvailableProperties(properties, numRows, flowDirection, anchorPosition)

        g_gui:showDialog("EasyDevControlsDynamicSelectionDialog")
    end

    return dialog
end

function EasyDevControlsDynamicSelectionDialog.new(target, customMt)
    local self = ScreenElement.new(target, customMt or EasyDevControlsDynamicSelectionDialog_mt)

    self.isCloseAllowed = true
    self.isBackAllowed = false

    self.inputDelay = 250
    self.confirmAction = InputAction.MENU_ACCEPT

    self.properties = nil
    self.numProperties = 0
    self.numHorizontal = 0
    self.numVertical = 0
    self.numVerticalClosePerRow = 0
    self.flowDirection = BoxLayoutElement.FLOW_HORIZONTAL
    self.hasValidProperties = false
    self.hideBackground = false

    self.callbackValues = {}
    self.dynamicControlIDs = {}

    self.elementsByName = {}
    self.propertiesByName = {}

    return self
end

function EasyDevControlsDynamicSelectionDialog.createFromExistingGui(gui, guiName)
    local headerText = gui.headerText
    local properties = gui.properties

    local callback = gui.callbackFunc
    local callbackTarget = gui.callbackTarget

    local numRows = gui.numRows
    local flowDirection = gui.flowDirection
    local anchorPosition = gui.anchorPosition
    local hideBackground = Utils.getNoNil(gui.hideBackground, not gui.dialogBgElement:getIsVisible())

    local onCloseTarget = gui.notifyOnCloseTarget
    local onCloseArguments = gui.onCloseArguments

    local confirmDisabled = gui.confirmButton:getIsDisabled()
    local confirmAction = gui.confirmAction

    local applyDisabled = gui.applyButton:getIsDisabled()
    local applyAction = gui.applyAction

    local applyText = gui.confirmButton:getText()
    local confirmText = gui.confirmButton:getText()
    local backText = gui.backButton:getText()

    if guiName ~= nil then
        g_gui.guis[guiName]:delete()
        g_gui.guis[guiName].target:delete()
    end

    EasyDevControlsDynamicSelectionDialog.INSTANCE = nil
    EasyDevControlsDynamicSelectionDialog.register()
    EasyDevControlsDynamicSelectionDialog.show(headerText, properties, callback, callbackTarget, numRows, flowDirection, anchorPosition, hideBackground, onCloseTarget, onCloseArguments, confirmDisabled, confirmAction, confirmText, applyDisabled, applyAction, applyText, backText)
end

function EasyDevControlsDynamicSelectionDialog:onCreate(onCreateArgs)
    local size = self.multiTextOptionTemplate.size
    local margin = self.multiTextOptionTemplate.margin

    self.templateWidth = size[1] + margin[1] + margin[3]
    self.templateHeight = size[2] + margin[2] + margin[4]

    self.multiTextOptionTemplate:unlinkElement()
    FocusManager:removeElement(self.multiTextOptionTemplate)
    self.binaryOptionTemplate:unlinkElement()
    FocusManager:removeElement(self.binaryOptionTemplate)
    self.textInputTemplate:unlinkElement()
    FocusManager:removeElement(self.textInputTemplate)
    self.buttonTemplate:unlinkElement()
    FocusManager:removeElement(self.buttonTemplate)
    self.spacerTemplate:unlinkElement()
    FocusManager:removeElement(self.spacerTemplate)

    self.defaultDialogWidth = self.dialogElement.size[1]
    self.defaultDialogHeight = self.dialogElement.size[2]

    self.defaultHeader = self.dialogHeaderElement.text

    self.defaultApplyText = self.applyButton.text
    self.defaultConfirmText = self.confirmButton.text
    self.defaultBackText = self.backButton.text

    self.onOffTexts = {
        g_i18n:getText("ui_off"),
        g_i18n:getText("ui_on")
    }

    self.yesNoTexts = {
        g_i18n:getText("ui_no"),
        g_i18n:getText("ui_yes")
    }
end

function EasyDevControlsDynamicSelectionDialog:onOpen()
    EasyDevControlsDynamicSelectionDialog:superClass().onOpen(self)

    self.inputDelay = self.time + 250
    self:updateProperties()
end

function EasyDevControlsDynamicSelectionDialog:onClose()
    if not g_gui.currentlyReloading then
        self:setHeader(nil, false)
        self:setButtonTexts(self.defaultApplyText, self.defaultConfirmText, self.defaultBackText)
        self:setApplyButtonAction(InputAction.MENU_ACTIVATE)
        self:setConfirmButtonAction(InputAction.MENU_ACCEPT)
    end

    EasyDevControlsDynamicSelectionDialog:superClass().onClose(self)
end

function EasyDevControlsDynamicSelectionDialog:close()
    g_gui:closeDialogByName("EasyDevControlsDynamicSelectionDialog")

    if self.notifyOnCloseTarget ~= nil then
        self.notifyOnCloseTarget:onDynamicSelectionDialogClosed(self.onCloseArguments)

        self.notifyOnCloseTarget = nil
        self.onCloseArguments = nil
    end
end

function EasyDevControlsDynamicSelectionDialog:delete()
    self.multiTextOptionTemplate:delete()
    self.binaryOptionTemplate:delete()
    self.textInputTemplate:delete()
    self.buttonTemplate:delete()
    self.spacerTemplate:delete()

    EasyDevControlsDynamicSelectionDialog:superClass().delete(self)
end

function EasyDevControlsDynamicSelectionDialog:onClickBack(forceBack, usedMenuButton)
    if (self.isCloseAllowed or forceBack) and not usedMenuButton then
        self:close()

        return false
    else
        return true
    end
end

function EasyDevControlsDynamicSelectionDialog:sendCallback(confirm, callbackValues, elementsByName, propertiesByName, element)
    if self.inputDelay < self.time then
        if element ~= self.applyButton then
            self:close()
        else
            self.confirmButton:setDisabled(true)
            self.applyButton:setDisabled(true)
        end

        if self.callbackFunc ~= nil then
            if self.callbackTarget ~= nil then
                self.callbackFunc(self.callbackTarget, confirm, callbackValues, elementsByName, propertiesByName)
            else
                self.callbackFunc(confirm, callbackValues, elementsByName, propertiesByName)
            end
        end
    end
end

function EasyDevControlsDynamicSelectionDialog:onConfirm(element)
    self:sendCallback(
        element ~= self.backButton,
        self.callbackValues,
        self.elementsByName,
        self.propertiesByName,
        element
    )
end

function EasyDevControlsDynamicSelectionDialog:setCallback(callbackFunc, target)
    self.callbackFunc = callbackFunc
    self.callbackTarget = target
end

function EasyDevControlsDynamicSelectionDialog:setHeader(text, hideBackground)
    self.hideBackground = Utils.getNoNil(hideBackground, false)

    self.dialogHeaderElement:setText(Utils.getNoNil(text, self.defaultHeader))
    self.dialogBgElement:setVisible(not self.hideBackground)
end

function EasyDevControlsDynamicSelectionDialog:setButtonTexts(applyText, confirmText, backText)
    self.applyButton:setText(Utils.getNoNil(applyText, self.defaultApplyText))
    self.confirmButton:setText(Utils.getNoNil(confirmText, self.defaultConfirmText))
    self.backButton:setText(Utils.getNoNil(backText, self.defaultBackText))
end

function EasyDevControlsDynamicSelectionDialog:setButtonsDisabled(applyDisabled, applyAction, confirmDisabled, confirmAction)
    applyDisabled = Utils.getNoNil(applyDisabled, true)

    self.applyButton:setDisabled(applyDisabled)
    self.applyButton:setVisible(not applyDisabled)
    self.applyButtonBoxSeparator:setVisible(not applyDisabled)

    if not applyDisabled then
        self:setApplyButtonAction(applyAction)
    end

    confirmDisabled = Utils.getNoNil(confirmDisabled, false)

    self.confirmButton:setDisabled(confirmDisabled)
    self.confirmButton:setVisible(not confirmDisabled)
    self.confirmButtonBoxSeparator:setVisible(not applyDisabled)

    if not confirmDisabled then
        self:setConfirmButtonAction(confirmAction)
    end
end

function EasyDevControlsDynamicSelectionDialog:setApplyButtonAction(applyAction)
    if applyAction ~= nil then
        self.applyAction = applyAction
        self.confirmButton:setInputAction(applyAction)
    end
end

function EasyDevControlsDynamicSelectionDialog:setConfirmButtonAction(confirmAction)
    if confirmAction ~= nil then
        self.confirmAction = confirmAction
        self.confirmButton:setInputAction(confirmAction)
    end
end

function EasyDevControlsDynamicSelectionDialog:setNotifyOnClose(target, onCloseArguments)
    if target ~= nil and target.onDynamicSelectionDialogClosed ~= nil then
        self.notifyOnCloseTarget = target
        self.onCloseArguments = onCloseArguments
    end
end

function EasyDevControlsDynamicSelectionDialog:setAvailableProperties(properties, numRows, flowDirection, anchorPosition)
    self.properties = properties

    self.numProperties = 0
    self.numRows = 0
    self.numColumns = 0

    self.flowDirection = BoxLayoutElement.FLOW_HORIZONTAL
    self.anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_MIDDLE

    self.hasValidProperties = false

    if properties ~= nil then
        self:setDialogElementSize(properties, numRows, flowDirection, anchorPosition)
    end
end

function EasyDevControlsDynamicSelectionDialog:updateProperties()
    for i = #self.propertiesLayoutElement.elements, 1, -1 do
        self.propertiesLayoutElement.elements[i]:delete()
    end

    for varName, _ in pairs (self.dynamicControlIDs) do
        self[varName] = nil
    end

    self.callbackValues = {}
    self.dynamicControlIDs = {}

    self.elementsByName = {}
    self.propertiesByName = {}

    if self.hasValidProperties then
        for i = 1, self.numProperties do
            local property = self.properties[i]
            local typeId = property.typeId

            local itemElement = nil
            local validElement = false

            if typeId == EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION or typeId == EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION then
                local lastIndex = property.lastIndex or 1
                local isBinaryOption = typeId == EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION

                itemElement, validElement = self:cloneTemplate(isBinaryOption and "binaryOptionTemplate" or "multiTextOptionTemplate", false, property.name, i)

                itemElement.onClickCallback = function(_, state, element, isLeft)
                    element.lastIndex = state
                    property.lastIndex = state

                    if property.onClickCallback ~= nil then
                        property.onClickCallback(self, state, element, isLeft, property)
                    else
                        self.callbackValues[element.name] = state
                    end
                end

                if property.texts ~= nil then
                    itemElement:setTexts(property.texts)
                elseif property.useCheckedTexts or isBinaryOption then
                    itemElement:setTexts(property.useYesNoTexts and self.yesNoTexts or self.onOffTexts)
                end

                itemElement.lastIndex = lastIndex

                self.callbackValues[itemElement.name] = lastIndex
            elseif typeId == EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT then
                itemElement, validElement = self:cloneTemplate("textInputTemplate", false, property.name, i)

                itemElement.enterWhenClickOutside = Utils.getNoNil(property.enterWhenClickOutside, true)
                itemElement.maxCharacters = property.maxCharacters

                if itemElement.placeholderText ~= nil then
                    itemElement:setPlaceholderText(itemElement.placeholderText)
                end

                itemElement.placeholderVisibleOnDisable = Utils.getNoNil(property.placeholderVisibleOnDisable, itemElement.placeholderVisibleOnDisable)
                itemElement:setPlaceholderVisible(property.placeholderVisible)

                itemElement.lastValidText = tostring(property.defaultValue or "")

                itemElement.onEnterPressedCallback = function(_, element, clickedOutside)
                    if property.onEnterPressedCallback ~= nil then
                        property.onEnterPressedCallback(self, element, clickedOutside, element.lastValidText, property)
                    else
                        if element.text ~= "" then
                            local value = tonumber(element.text)

                            if value ~= nil then
                                self.callbackValues[element.name] = value
                            else
                                element:setText("")
                                element.lastValidText = ""
                            end
                        end
                    end

                    element.lastValidText = ""
                end

                itemElement.onEscPressedCallback = function(_, element)
                    if property.onEscPressedCallback ~= nil then
                        local lastValidText = element.lastValidText
                        property.onEscPressedCallback(self, element, property, lastValidText)
                    end

                    if not property.ignoreEsc then
                        element:setText("")
                        element.lastValidText = ""
                    end
                end

                itemElement.onTextChangedCallback = function(_, element, text)
                    if property.onTextChangedCallback ~= nil then
                        property.onTextChangedCallback(self, element, text, property)
                    else
                        if text ~= nil and text ~= "" then
                            local value = tonumber(text)

                            if value ~= nil then
                                element.lastValidText = text

                                self.callbackValues[element.name] = value
                            else
                                element:setText(element.lastValidText)
                            end
                        else
                            element.lastValidText = ""
                        end
                    end
                end

                itemElement:setText(itemElement.lastValidText)

                self.callbackValues[itemElement.name] = property.defaultValue or 0
            elseif typeId == EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON then
                itemElement, validElement = self:cloneTemplate("buttonTemplate", false, property.name, i)

                itemElement.onClickCallback = function(d, element)
                    if property.onClickCallback ~= nil then
                        property.onClickCallback(self, element, property)
                    else
                        self.callbackValues[element.name] = true
                        self:onConfirm(self.confirmButton)
                    end
                end

                self.callbackValues[itemElement.name] = Utils.getNoNil(property.defaultValue, false)
            elseif typeId == EasyDevControlsDynamicSelectionDialog.TYPE_SPACER then
                itemElement, validElement = self:cloneTemplate("spacerTemplate", false, property.name, i)
            end

            if itemElement ~= nil and validElement then
                local titleElement = itemElement:getDescendantByName("title")

                if property.profile ~= nil then
                    itemElement:applyProfile(property.profile)
                end

                itemElement:setDisabled(Utils.getNoNil(property.disabled, false))
                itemElement:setVisible(true)

                if titleElement ~= nil then
                    if property.title ~= nil then
                        titleElement:setText(property.title)
                    else
                        titleElement:setVisible(false)
                        titleElement:setDisabled(true)
                    end
                end

                itemElement.propertyId = i
                itemElement.dynamicId = property.dynamicId

                self:exposeDynamicIdAsField(itemElement)

                self.elementsByName[itemElement.name] = itemElement
                self.propertiesByName[itemElement.name] = property
            end
        end
    end

    local elements = self.propertiesLayoutElement.elements
    local firstElement = elements[1]
    local lastElement = elements[#elements]

    if firstElement ~= nil then
        for i, element in ipairs (elements) do
            if element.name ~= nil and self.propertiesByName[element.name] ~= nil then
                if element.setIsChecked ~= nil then
                    element:setIsChecked(element.lastIndex == BinaryOptionElement.STATE_RIGHT, true, self.propertiesByName[element.name].forceState) -- No animation
                elseif element.setState ~= nil then
                    element:setState(element.lastIndex, self.propertiesByName[element.name].forceState)
                end
            end

            if element == firstElement then
                FocusManager:linkElements(element, FocusManager.TOP, lastElement)
                FocusManager:linkElements(element, FocusManager.BOTTOM, elements[i + 1])
            elseif element == lastElement then
                FocusManager:linkElements(element, FocusManager.TOP, elements[i - 1])
                FocusManager:linkElements(element, FocusManager.BOTTOM, firstElement)
            else
                FocusManager:linkElements(element, FocusManager.TOP, elements[i - 1])
                FocusManager:linkElements(element, FocusManager.BOTTOM, elements[i + 1])
            end
        end
    end

    self.propertiesLayoutElement:invalidateLayout()
    FocusManager:setFocus(firstElement)
end

function EasyDevControlsDynamicSelectionDialog:setDialogElementSize(properties, numRows, flowDirection, anchorPosition)
    local maxRows = 5
    local maxColumns = 8
    local maxProperties = maxRows * maxColumns
    local numColumns = 1

    if self.flowDirection ~= flowDirection then
        if flowDirection == BoxLayoutElement.FLOW_VERTICAL then
            flowDirection = BoxLayoutElement.FLOW_VERTICAL
            self.propertiesLayoutElement:applyProfile("edc_dynamicSelectionDialogLayoutVertical", true)
        else
            flowDirection = BoxLayoutElement.FLOW_HORIZONTAL
            self.propertiesLayoutElement:applyProfile("edc_dynamicSelectionDialogLayout", true)
        end
    end

    if self.anchorPosition ~= anchorPosition then
        if anchorPosition == EasyDevControlsDynamicSelectionDialog.ANCHOR_RIGHT then
            anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_RIGHT
            self.dialogElement:applyProfile("edc_dynamicSelectionDialogBgRight", true)
        elseif anchorPosition == EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM then
            anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM
            self.dialogElement:applyProfile("edc_dynamicSelectionDialogBgBottom", true)
        else
            anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_MIDDLE
            self.dialogElement:applyProfile("edc_dynamicSelectionDialogBg", true)
        end
    end

    local numProperties = math.min(#properties, maxProperties)

    if numProperties > 1 then
        numRows = math.clamp(numRows or 1, 1, maxRows)
        numColumns = math.ceil(numProperties / numRows)
    end

    local heightOffset = 0
    local widthOffset = self.templateWidth * (numRows - 1)
    local closeTemplateHeight = self.templateHeight - (42 / g_referenceScreenHeight) -- GuiUtils.getNormalizedYValue("42px")

    local rowOffsets = {}
    local rowIndex = 1

    for i, property in ipairs (properties) do
        if property.profile == nil or not property.profile:endsWith("Close") then
            rowOffsets[rowIndex] = (rowOffsets[rowIndex] or -self.templateHeight) + self.templateHeight
        else
            rowOffsets[rowIndex] = (rowOffsets[rowIndex] or -self.templateHeight) + closeTemplateHeight
        end

        if flowDirection == BoxLayoutElement.FLOW_HORIZONTAL then
            rowIndex += 1

            if rowIndex > numRows then
                rowIndex = 1
            end
        elseif i % numColumns == 0 then
            rowIndex += 1
        end
    end

    for i, offset in ipairs (rowOffsets) do
        if offset > heightOffset then
            heightOffset = offset
        end
    end

    self.numProperties = numProperties
    self.numRows = numRows
    self.numColumns = numColumns
    self.flowDirection = flowDirection
    self.anchorPosition = anchorPosition
    self.hasValidProperties = numProperties > 0

    self.dialogElement:setSize(self.defaultDialogWidth + widthOffset, self.defaultDialogHeight + heightOffset)

    return numProperties
end

function EasyDevControlsDynamicSelectionDialog:exposeDynamicIdAsField(element)
    if element.dynamicId ~= nil and element.dynamicId ~= "" then
        local index, varName = GuiElement.extractIndexAndNameFromID(element.dynamicId)

        if varName:find("[^%w_]") ~= nil then
            EasyDevControlsLogging.devInfo("Invalid dynamic id '%s' for GUI property '%s', alphanumeric only with no white spaces or punctuation!", element.dynamicId, element.propertyId)

            return
        end

        if self.dynamicControlIDs[varName] ~= nil then
            EasyDevControlsLogging.devInfo("Duplicate dynamic id '%s' for GUI property '%s'!", varName, element.propertyId)

            return
        end

        if index then
            if self[varName] == nil then
                self[varName] = {}
            end

            self[varName][index] = element
        else
            self[varName] = element
        end

        self.dynamicControlIDs[varName] = true
    end
end

function EasyDevControlsDynamicSelectionDialog:cloneTemplate(templateControlName, includeId, propertyName, index)
    local control = self[templateControlName]

    if control ~= nil then
        local element = control:clone(self.propertiesLayoutElement, includeId)

        if (propertyName == nil or propertyName == "") or propertyName:find("[^%w_]") ~= nil then
            element.name = string.format("property%d", index)
        else
            element.name = propertyName
        end

        element:reloadFocusHandling(true)

        return element, true
    end

    return {}, false
end

function EasyDevControlsDynamicSelectionDialog:getBlurArea()
    if self.hideBackground or self.dialogElement == nil then
        return
    end

    return self.dialogElement.absPosition[1], self.dialogElement.absPosition[2], self.dialogElement.absSize[1], self.dialogElement.absSize[2]
end
