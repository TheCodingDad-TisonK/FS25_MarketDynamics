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

EasyDevControlsHelpFrame = {}
EasyDevControlsHelpFrame.NAME = "HELP"

local EasyDevControlsHelpFrame_mt = Class(EasyDevControlsHelpFrame, EasyDevControlsBaseFrame)

function EasyDevControlsHelpFrame.register()
    local controller = EasyDevControlsHelpFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsHelpFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsHelpFrame", controller, true)

    return controller
end

function EasyDevControlsHelpFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsHelpFrame_mt)

    self.pageName = EasyDevControlsHelpFrame.NAME

    return self
end

function EasyDevControlsHelpFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsHelpFrame.register()
end

function EasyDevControlsHelpFrame:initialize()
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

    self.menuButtonInfo = {
        self.backButtonInfo,
        self.nextPageButtonInfo,
        self.prevPageButtonInfo
    }

    self.contentItemTemplate:unlinkElement()
    FocusManager:removeElement(self.contentItemTemplate)

    self:resetSlider(self.listDataElement)
    self:resetSlider(self.contentBoxElement)
end

function EasyDevControlsHelpFrame:delete()
    self.contentItemTemplate:delete()

    EasyDevControlsHelpFrame:superClass().delete(self)
end

function EasyDevControlsHelpFrame:onFrameOpening()
    self.listDataElement:reloadData()
    self:setMenuButtonInfoDirty()

    self.contentBoxElement:registerActionEvents()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.listDataElement)
    self:setSoundSuppressed(false)
end

function EasyDevControlsHelpFrame:onFrameClose()
    self.contentBoxElement:removeActionEvents()
    EasyDevControlsHelpFrame:superClass().onFrameClose(self)
end

function EasyDevControlsHelpFrame:resetSlider(element)
    if element.sliderElement ~= nil then
        element.sliderElement:setValue(0, true)
    end
end

function EasyDevControlsHelpFrame:updateContents(page)
    local contentBoxElements = self.contentBoxElement.elements

    for i = #contentBoxElements, 1, -1 do
        contentBoxElements[i]:delete()
    end

    if page ~= nil then
        self.categoryTitleElement:setText(page.title or "Unknown Title")
        self.categoryIconElement:setImageSlice(nil, page.sliceId or "gui.icon_options_help2")

        local ignoredStyle = "INGAME"

        for _, toolTip in ipairs(page.toolTips) do
            if toolTip.style ~= ignoredStyle then
                self:addContentRowItem(toolTip.title, toolTip.text, toolTip.elementId)
            end
        end

        if #contentBoxElements > 0 then
            self:addContentRowItem("", "", nil) -- Empty space to allow the scrolling to finishes higher
            contentBoxElements[1].forceFocusScrollToTop = true
        end
    end

    self.contentBoxElement:invalidateLayout()
end

function EasyDevControlsHelpFrame:addContentRowItem(title, text, elementId)
    local row = self.contentItemTemplate:clone(self.contentBoxElement)

    local titleElement = row:getDescendantByName("title")
    titleElement:setText(title)

    local textElement = row:getDescendantByName("text")
    textElement:setText(text)

    -- Really only required for InGameMenu version
    -- if not string.isNilOrWhitespace(elementId) then
        -- textElement.id = elementId
        -- self[elementId] = textElement
    -- end

    local sizeY = titleElement.size[2] + textElement:getTextHeight()
    row:setSize(nil, sizeY)

    row:invalidateLayout()
end

function EasyDevControlsHelpFrame:onListSelectionChanged(list, section, index)
    if self.contentBoxElement ~= nil then
        self:updateContents(g_easyDevControlsGuiManager:getHelpPageByIndex(index))
        self.contentBoxElement:scrollTo(0, true)
    end
end

function EasyDevControlsHelpFrame:getNumberOfSections()
    return 1
end

function EasyDevControlsHelpFrame:getNumberOfItemsInSection(list, section)
    return #g_easyDevControlsGuiManager:getHelpPages()
end

function EasyDevControlsHelpFrame:populateCellForItemInSection(list, section, index, element)
    local page = g_easyDevControlsGuiManager:getHelpPageByIndex(index)

    if page ~= nil then
        element:getAttribute("title"):setText(page.title or "Unknown Title")

        local iconElement = element:getAttribute("icon")
        local sliceId = page.sliceId

        if sliceId ~= nil then
            iconElement:setImageSlice(nil, sliceId)
            iconElement:setVisible(true)
        else
            iconElement:setVisible(false)
        end
    end
end

function EasyDevControlsHelpFrame:openPage(pageIndex)
    self:setSoundSuppressed(true)
    self.listDataElement:setSelectedItem(1, pageIndex, true, 1)
    self:setSoundSuppressed(false)
end
