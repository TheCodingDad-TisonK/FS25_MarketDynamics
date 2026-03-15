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

EasyDevControlsDynamicListDialog = {}

local EasyDevControlsDynamicListDialog_mt = Class(EasyDevControlsDynamicListDialog, ScreenElement)

function EasyDevControlsDynamicListDialog.register()
    local dynamicListDialog = EasyDevControlsDynamicListDialog.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/dialogs/EasyDevControlsDynamicListDialog.xml")

    g_gui:loadGui(filename, "EasyDevControlsDynamicListDialog", dynamicListDialog)
    EasyDevControlsDynamicListDialog.INSTANCE = dynamicListDialog

    return dynamicListDialog
end

-- TO_DO: Use SmoothList or add double click ability to use for things such as teleportation to a factory or bale.
function EasyDevControlsDynamicListDialog.show(header, list, updateOnOpen, callback, target, args, clearCallbackFunc, clearCallbackTarget, enableNoInfoMessage, customNoInfoMessage)
    local dialog = EasyDevControlsDynamicListDialog.INSTANCE

    if dialog ~= nil then
        dialog:setHeader(header)
        dialog:setList(list, updateOnOpen, enableNoInfoMessage, customNoInfoMessage)
        dialog:setCallback(callback, target, args)
        dialog:setClearCallback(clearCallbackFunc, clearCallbackTarget)

        g_gui:showDialog("EasyDevControlsDynamicListDialog") -- Need to resize before calling 'showDialog' so blur is correct
    end

    return dialog
end

function EasyDevControlsDynamicListDialog.new(target, customMt)
    local self = ScreenElement.new(target, customMt or EasyDevControlsDynamicListDialog_mt)

    self.isCloseAllowed = true
    self.isBackAllowed = false
    self.enableNoInfoMessage = true

    self.updateOnOpen = false
    self.inputDelay = 250

    return self
end

function EasyDevControlsDynamicListDialog.createFromExistingGui(gui, guiName)
    local header = gui.dialogHeaderElement.text
    local list = gui.list
    local updateOnOpen = gui.updateOnOpen
    local callback = gui.callback
    local target = gui.target
    local args = gui.args
    local clearCallbackFunc = gui.clearCallbackFunc
    local clearCallbackTarget = gui.clearCallbackTarget
    local enableNoInfoMessage = gui.enableNoInfoMessage

    local customNoInfoMessage = nil

    if enableNoInfoMessage then
        customNoInfoMessage = gui.noInfoTextElement.text
    end

    if guiName ~= nil then
        g_gui.guis[guiName]:delete()
        g_gui.guis[guiName].target:delete()
    end

    EasyDevControlsDynamicListDialog.INSTANCE = nil
    EasyDevControlsDynamicListDialog.register()
    EasyDevControlsDynamicListDialog.show(header, list, updateOnOpen, callback, target, args, clearCallbackFunc, clearCallbackTarget, enableNoInfoMessage, customNoInfoMessage)
end

function EasyDevControlsDynamicListDialog:onCreate(onCreateArgs)
    self.scrollingLayoutItem:unlinkElement()

    self.defaultHeaderText = self.dialogHeaderElement.text
    self.defaultNoInformationText = self.noInfoTextElement.text

    self.defaultDialogWidth = self.dialogElement.size[1]
    self.defaultDialogHeight = self.dialogElement.size[2]

    self.defaultBoxWidth = self.contentBoxElement.size[1]
    self.defaultBoxHeight = self.contentBoxElement.size[2]

    self.defaultItemWidth = self.scrollingLayoutItem.size[1]
    self.widthOffset = self.defaultBoxWidth - self.defaultItemWidth

    self.textOffset = 20 / g_referenceScreenWidth
end

function EasyDevControlsDynamicListDialog:delete()
    self.scrollingLayoutItem:delete()
    EasyDevControlsDynamicListDialog:superClass().delete(self)
end

function EasyDevControlsDynamicListDialog:onOpen()
    EasyDevControlsDynamicListDialog:superClass().onOpen(self)

    self.inputDelay = self.time + 250
    self.scrollingLayoutElement:registerActionEvents()

    if self.updateOnOpen then
        self:updateListContents()
    end
end

function EasyDevControlsDynamicListDialog:onClose()
    self.scrollingLayoutElement:removeActionEvents()

    if not g_gui.currentlyReloading then
        self.list = nil
        self.updateOnOpen = false

        self.enableNoInfoMessage = true
        self.noInfoTextElement:setText(self.defaultNoInformationText)

        self:setHeader(self.defaultHeaderText)
        -- self:updateListContents()
    end

    self.clearButton:setDisabled(true)
    self.clearButton:setVisible(false)
    self.buttonBoxSeparator:setVisible(false)

    EasyDevControlsDynamicListDialog:superClass().onClose(self)
end

function EasyDevControlsDynamicListDialog:close()
    g_gui:closeDialogByName("EasyDevControlsDynamicListDialog")
end

function EasyDevControlsDynamicListDialog:updateListContents()
    local width = self.defaultItemWidth * 0.4
    local maxTextWidth = self.defaultItemWidth - self.widthOffset

    local numItems = self.list ~= nil and #self.list or 0
    local hasItems = numItems > 0

    for i = #self.scrollingLayoutElement.elements, 1, -1 do
        self.scrollingLayoutElement.elements[i]:delete()
    end

    if hasItems then
        local layoutElements = table.create(numItems)
        local layoutHeights = table.create(numItems)

        for _, listItem in ipairs(self.list) do
            local layoutItem = self.scrollingLayoutItem:clone(self.scrollingLayoutElement)
            local titleElement = layoutItem:getDescendantByName("title")
            local textElement = layoutItem:getDescendantByName("text")

            local height = 0

            if not string.isNilOrWhitespace(listItem.title) then
                local text = EasyDevControlsUtils.convertText(listItem.title)
                local textWidth = self:getWidthFromText(titleElement, text, maxTextWidth)

                width = math.max(width, textWidth)

                if textWidth < maxTextWidth then
                    titleElement.textLayoutMode = TextElement.LAYOUT_MODE.TRUNCATE
                else
                    titleElement.textLayoutMode = TextElement.LAYOUT_MODE.SCROLLING
                    titleElement.textScrollOnFocusOnly = false
                    titleElement.textMaxNumLines = 1
                end

                if listItem.titleColour ~= nil then
                    local r, g, b, a = unpack(listItem.titleColour)

                    titleElement:setTextColor(r or 1, g or 1, b or 1, a or 1)
                end

                titleElement.textMaxWidth = width * 0.99
                titleElement:setSize(width * 0.99, nil)

                titleElement:setText(text)
                titleElement:setVisible(true)

                height += titleElement.size[2] + self.textOffset
            else
                titleElement:setText("")
                titleElement:setVisible(false)
            end

            if not string.isNilOrWhitespace(listItem.text) then
                local text = EasyDevControlsUtils.convertText(listItem.text)

                width = math.max(width, self:getWidthFromText(textElement, text, maxTextWidth))

                if listItem.textColour ~= nil then
                    local r, g, b, a = unpack(listItem.textColour)

                    textElement:setTextColor(r or 1, g or 1, b or 1, a or 0.5)
                end

                textElement.textMaxWidth = width * 0.99
                textElement:setSize(width * 0.99, nil)

                textElement:setText(text)
                textElement:setVisible(true)

                height += textElement:getTextHeight() + self.textOffset
            else
                textElement:setText("")
                textElement:setVisible(false)
            end

            if listItem.overlayColour ~= nil then
                local r, g, b, a = unpack(listItem.overlayColour)

                if r ~= nil and g ~= nil and b ~= nil then
                    layoutItem:setImageColor(GuiOverlay.STATE_NORMAL, r, g, b, a or 0)
                end
            end

            table.insert(layoutElements, layoutItem)
            table.insert(layoutHeights, height)
        end

        for i, element in ipairs (layoutElements) do
            element:setSize(width, layoutHeights[i])
            element:invalidateLayout()
        end

        layoutElements = nil
        layoutHeights = nil
    end

    if self.enableNoInfoMessage then
        self.noInfoElement:setVisible(not hasItems)
    end

    self.contentBoxElement:setVisible(hasItems)

    self:setDialogSize(width, true)
end

function EasyDevControlsDynamicListDialog:onClickBack(forceBack, usedMenuButton)
    if (self.isCloseAllowed or forceBack) and not usedMenuButton then
        if self.inputDelay < self.time then
            self:close()

            if self.callbackFunc ~= nil then
                if self.target ~= nil then
                    self.callbackFunc(self.target, self.list, self.args)
                else
                    self.callbackFunc(self.list, self.args)
                end
            end

            return false
        end
    else
        return true
    end
end

function EasyDevControlsDynamicListDialog:onClickClear()
    if self.clearCallbackFunc ~= nil then
        local header = self.dialogHeaderElement:getText()
        local list = self.list
        local updateOnOpen = self.updateOnOpen
        local callback = self.callback
        local target = self.target
        local args = self.args
        local clearCallbackFunc = self.clearCallbackFunc
        local clearCallbackTarget = self.clearCallbackTarget
        local enableNoInfoMessage = self.enableNoInfoMessage

        local customNoInfoMessage = nil

        if enableNoInfoMessage then
            customNoInfoMessage = self.noInfoTextElement:getText()
        end

        self:close()

        local newList = nil

        if clearCallbackTarget ~= nil then
            newList, updateOnOpen = clearCallbackFunc(clearCallbackTarget, list)
        else
            newList, updateOnOpen = clearCallbackFunc(list)
        end

        EasyDevControlsDynamicListDialog.show(header, newList or list, updateOnOpen, callback, target, clearCallbackFunc, clearCallbackTarget, enableNoInfoMessage, customNoInfoMessage)
    end
end

function EasyDevControlsDynamicListDialog:setList(list, updateOnOpen, enableNoInfoMessage, customNoInfoMessage)
    self.list = list

    self.updateOnOpen = Utils.getNoNil(updateOnOpen, false)
    self.enableNoInfoMessage = Utils.getNoNil(enableNoInfoMessage, true)

    if self.enableNoInfoMessage and customNoInfoMessage ~= nil then
        self.noInfoTextElement:setText(customNoInfoMessage)
    end

    if not self.updateOnOpen then
        self:updateListContents()
    end
end

function EasyDevControlsDynamicListDialog:setCallback(callbackFunc, target, args)
    self.callbackFunc = callbackFunc
    self.target = target
    self.args = args
end

function EasyDevControlsDynamicListDialog:setClearCallback(callbackFunc, target)
    self.clearCallbackFunc = callbackFunc
    self.clearCallbackTarget = target

    local enabled = callbackFunc ~= nil

    self.clearButton:setDisabled(not enabled)
    self.clearButton:setVisible(enabled)
    self.buttonBoxSeparator:setVisible(enabled)
end

function EasyDevControlsDynamicListDialog:setHeader(text)
    self.dialogHeaderElement:setText(Utils.getNoNil(text, self.defaultHeaderText))
end

function EasyDevControlsDynamicListDialog:getWidthFromText(textElement, text, maxWidth)
    setTextBold(textElement.textBold) -- Largest possible size

    local width = math.min(getTextWidth(textElement.textSize, text) + self.textOffset, maxWidth)
    -- local width = math.min(getTextWidth(textElement.textSize, text) + self.textOffset, self.defaultItemWidth - self.widthOffset)

    setTextBold(false)

    -- if textElement.textLayoutMode ~= TextElement.LAYOUT_MODE.OVERFLOW then
        -- return math.min(width, textElement.absSize[1])
    -- end

    return width
end

function EasyDevControlsDynamicListDialog:setDialogSize(width, invalidateLayout)
    if width == nil then
        width = self.defaultItemWidth * 0.4
    end

    width = math.min(width, self.defaultItemWidth - self.widthOffset)

    self.dialogElement:setSize(width + self.widthOffset)
    self.noInfoElement:setSize(width)
    self.contentBoxElement:setSize(width)
    self.scrollingLayoutElement:setSize(width)

    if invalidateLayout then
        self.scrollingLayoutElement:invalidateLayout(true)
    end
end

function EasyDevControlsDynamicListDialog:getBlurArea()
    if self.dialogElement ~= nil then
        return self.dialogElement.absPosition[1], self.dialogElement.absPosition[2], self.dialogElement.absSize[1], self.dialogElement.absSize[2]
    end
end
