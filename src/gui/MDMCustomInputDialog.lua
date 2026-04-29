-- MDMCustomInputDialog.lua
-- Custom dialog for entering manual amounts or delivery days.
--
-- params = {
--   mode = "amount" | "days",
--   currentValue = number,
--   isRealDays = boolean (only used if mode == "days"),
--   onConfirmed = function(value, isRealDays)
-- }

MDMCustomInputDialog = {}
local MDMCustomInputDialog_mt = Class(MDMCustomInputDialog, MessageDialog)

function MDMCustomInputDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or MDMCustomInputDialog_mt)
    self.mode = "amount"
    self.currentValue = 0
    self.isRealDays = false
    self._onConfirmed = nil

    self.dlgTitle = nil
    self.dlgInputLabel = nil
    self.textInput = nil
    self.daysToggleContainer = nil
    self.txtGameDays = nil
    self.txtRealDays = nil
    self.dlgHint = nil
    self.btnConfirm = nil
    
    self.isOpen = false

    return self
end

function MDMCustomInputDialog:setData(params)
    self.mode = params.mode or "amount"
    self.currentValue = params.currentValue or 0
    self.isRealDays = params.isRealDays or false
    self._onConfirmed = params.onConfirmed
end

function MDMCustomInputDialog:onCreate()
    local ok, err = pcall(function() MDMCustomInputDialog:superClass().onCreate(self) end)
    if not ok then MDMLog.warn("MDMCustomInputDialog:onCreate error: " .. tostring(err)) end
end

function MDMCustomInputDialog:onGuiSetupFinished()
    MDMCustomInputDialog:superClass().onGuiSetupFinished(self)

    self.dlgTitle = self:getDescendantById("dlgTitle")
    self.dlgInputLabel = self:getDescendantById("dlgInputLabel")
    self.textInput = self:getDescendantById("textInput")
    self.daysToggleContainer = self:getDescendantById("daysToggleContainer")
    self.txtGameDays = self:getDescendantById("txtGameDays")
    self.txtRealDays = self:getDescendantById("txtRealDays")
    self.dlgHint = self:getDescendantById("dlgHint")
    self.btnConfirm = self:getDescendantById("btnConfirm")
end

function MDMCustomInputDialog:onOpen()
    MDMCustomInputDialog:superClass().onOpen(self)
    self.isOpen = true
    self._isPending = false

    if self.textInput then
        local displayVal = self.currentValue
        if displayVal <= 0 then displayVal = "" end
        self.textInput:setText(tostring(displayVal))
        FocusManager:setFocus(self.textInput)
    end

    if self.mode == "amount" then
        if self.dlgTitle then self.dlgTitle:setText(g_i18n:getText("mdm_custom_amount")) end
        if self.dlgInputLabel then self.dlgInputLabel:setText(g_i18n:getText("mdm_enter_amount")) end
        if self.daysToggleContainer then self.daysToggleContainer:setVisible(false) end
        if self.dlgHint then self.dlgHint:setText(g_i18n:getText("mdm_custom_amount_hint") or "Enter the quantity in liters.") end
    else
        if self.dlgTitle then self.dlgTitle:setText(g_i18n:getText("mdm_custom_days")) end
        if self.dlgInputLabel then self.dlgInputLabel:setText(g_i18n:getText("mdm_enter_days")) end
        if self.daysToggleContainer then self.daysToggleContainer:setVisible(true) end
        if self.dlgHint then self.dlgHint:setText(g_i18n:getText("mdm_custom_days_hint") or "Select delivery window length. Real Days will convert to game time based on current time scale.") end
        self:_updateToggleUI()
    end

    self:_validateInput()
end

function MDMCustomInputDialog:onClose()
    self.isOpen = false
    self._isPending = false
    MDMCustomInputDialog:superClass().onClose(self)
end

function MDMCustomInputDialog:onTextChanged(element, text)
    self:_validateInput()
end

function MDMCustomInputDialog:_validateInput()
    if not self.textInput then return end
    local text = self.textInput:getText()
    local val = tonumber(text)
    
    local isValid = false
    if val ~= nil and val > 0 then
        if self.mode == "amount" and val <= 100000000 then -- Reasonable max limits
            isValid = true
        elseif self.mode == "days" and val <= 3650 then
            isValid = true
        end
    end
    
    if self.btnConfirm then
        self.btnConfirm:setDisabled(not isValid)
    end
end

function MDMCustomInputDialog:_updateToggleUI()
    local SEL   = {0.0,  0.83, 0.49, 1.0}
    local UNSEL = {0.75, 0.75, 0.75, 1.0}
    
    if self.txtGameDays then
        local c = self.isRealDays and UNSEL or SEL
        self.txtGameDays:setTextColor(c[1], c[2], c[3], c[4])
    end
    if self.txtRealDays then
        local c = self.isRealDays and SEL or UNSEL
        self.txtRealDays:setTextColor(c[1], c[2], c[3], c[4])
    end
end

function MDMCustomInputDialog:onToggleGameDays()
    self.isRealDays = false
    self:_updateToggleUI()
end

function MDMCustomInputDialog:onToggleRealDays()
    self.isRealDays = true
    self:_updateToggleUI()
end

function MDMCustomInputDialog:onConfirmClick()
    if self.btnConfirm and self.btnConfirm.disabled then return end
    
    local text = self.textInput:getText()
    local val = tonumber(text)
    if not val or val <= 0 then return end
    
    local cb = self._onConfirmed
    local isReal = self.isRealDays
    
    self:close()
    
    if cb then
        cb(val, isReal)
    end
end

function MDMCustomInputDialog:onCancelClick()
    self:close()
end
