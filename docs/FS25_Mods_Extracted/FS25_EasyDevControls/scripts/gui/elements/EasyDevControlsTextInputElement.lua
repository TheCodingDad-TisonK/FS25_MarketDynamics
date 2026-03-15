--[[
Copyright (C) GtX (Andy), 2024

Author: GtX | Andy
Date: 18.11.2024
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

EasyDevControlsTextInputElement = {}
EasyDevControlsTextInputElement.MOD_NAME = g_currentModName

local EasyDevControlsTextInputElement_mt = Class(EasyDevControlsTextInputElement, TextInputElement)

Gui.registerGuiElement("EasyDevControlsTextInput", EasyDevControlsTextInputElement)

function EasyDevControlsTextInputElement.new(target, custom_mt)
    local self = TextInputElement.new(target, custom_mt or EasyDevControlsTextInputElement_mt)

    self.placeholderDefaultProfile = nil
    self.placeholderDefaultText = nil
    self.placeholderClassName = "TextElement"

    self.placeholderName = "placeholder"
    self.placeholderElement = nil

    self.placeholderVisibleOnDisable = false
    self.placeholderVisible = true -- Visibility override

    self.lastValidText = ""

    return self
end

function EasyDevControlsTextInputElement:loadFromXML(xmlFile, key)
    EasyDevControlsTextInputElement:superClass().loadFromXML(self, xmlFile, key)

    self.placeholderDefaultText = Utils.getNoNil(getXMLString(xmlFile, key.."#placeholderDefaultText"), self.placeholderDefaultText)
    self.placeholderName = Utils.getNoNil(getXMLString(xmlFile, key.."#placeholderName"), self.placeholderName)

    self.placeholderVisibleOnDisable = Utils.getNoNil(getXMLBool(xmlFile, key.."#placeholderVisibleOnDisable"), self.placeholderVisibleOnDisable)
    self.placeholderVisible = Utils.getNoNil(getXMLBool(xmlFile, key.."#placeholderVisible"), self.placeholderVisible)
end

function EasyDevControlsTextInputElement:loadProfile(profile, applyProfile)
    EasyDevControlsTextInputElement:superClass().loadProfile(self, profile, applyProfile)

    self.placeholderDefaultProfile = profile:getValue("placeholderDefaultProfile", self.placeholderDefaultProfile)
    self.placeholderDefaultText = profile:getValue("placeholderDefaultText", self.placeholderDefaultText)
    self.placeholderClassName = profile:getValue("placeholderClassName", self.placeholderClassName)

    self.placeholderName = profile:getValue("placeholderName", self.placeholderName)

    self.placeholderVisibleOnDisable = profile:getBool("placeholderVisibleOnDisable", self.placeholderVisibleOnDisable)
    self.placeholderVisible = profile:getBool("placeholderVisible", self.placeholderVisible)
end

function EasyDevControlsTextInputElement:copyAttributes(src)
    EasyDevControlsTextInputElement:superClass().copyAttributes(self, src)

    self.placeholderDefaultProfile = src.placeholderDefaultProfile
    self.placeholderDefaultText = src.placeholderDefaultText
    self.placeholderClassName = src.placeholderClassName

    self.placeholderName = src.placeholderName

    self.placeholderVisibleOnDisable = src.placeholderVisibleOnDisable
    self.placeholderVisible = src.placeholderVisible
end

function EasyDevControlsTextInputElement:clone(parent, includeId, suppressOnCreate)
    local clonedElement = EasyDevControlsTextInputElement:superClass().clone(self, parent, includeId, suppressOnCreate)

    clonedElement:setPlaceholderElement()

    return clonedElement
end

function EasyDevControlsTextInputElement:onGuiSetupFinished()
    EasyDevControlsTextInputElement:superClass().onGuiSetupFinished(self)

    self:setPlaceholderElement()
end

function EasyDevControlsTextInputElement:setPlaceholderElement()
    local element = self:getDescendantByName(self.placeholderName)

    if element == nil then
        local defaultProfile = self.placeholderDefaultProfile
        local className = self.placeholderClassName

        if defaultProfile ~= nil and className ~= nil then
            local class = _G[className]

            if class ~= nil then
                element = class.new(self)
                element.name = self.placeholderName
                self:addElement(element)
                element:applyProfile(defaultProfile)
            end
        end
    end

    self.placeholderElement = element

    self:setPlaceholderText()
    self:updatePlaceholderVisibility()
end

function EasyDevControlsTextInputElement:setCaptureInput(isCapturing)
    EasyDevControlsTextInputElement:superClass().setCaptureInput(self, isCapturing)

    self:updatePlaceholderVisibility()
end

function EasyDevControlsTextInputElement:updateVisibleTextElements()
    EasyDevControlsTextInputElement:superClass().updateVisibleTextElements(self)

    self:updatePlaceholderVisibility()
end

function EasyDevControlsTextInputElement:setDisabled(disabled, blockDelegate)
    EasyDevControlsTextInputElement:superClass().setDisabled(self, disabled, blockDelegate)

    self:updatePlaceholderVisibility()
end

function EasyDevControlsTextInputElement:setPlaceholderVisible(visible)
    self.placeholderVisible = Utils.getNoNil(visible, true)

    self:updatePlaceholderVisibility()
end

function EasyDevControlsTextInputElement:setPlaceholderText(text, ...)
    if self.placeholderElement ~= nil and self.placeholderElement.setText ~= nil then
        if text == nil and self.placeholderDefaultText ~= nil then
            text = g_i18n:convertText(self.placeholderDefaultText, EasyDevControlsTextInputElement.MOD_NAME)
        end

        self.placeholderElement:setText(text or self.placeholderElement:getText(), ...)
    end
end

function EasyDevControlsTextInputElement:updatePlaceholderVisibility()
    if self.placeholderElement ~= nil then
        if self.isCapturingInput then
            self.placeholderElement:setVisible(false)
        else
            local visible = self.placeholderVisible

            if visible and self.disabled then
                visible = self.placeholderVisibleOnDisable
            end

            self.placeholderElement:setVisible(visible and string.isNilOrWhitespace(self.text))
        end
    end
end

function EasyDevControlsTextInputElement:getPlaceholder()
    return self.placeholderElement
end
