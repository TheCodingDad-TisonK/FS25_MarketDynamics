RTI18NExtension = {}
local modName = g_currentModName

RTI18NExtension.redTapeTexts = {
    ["finance_rsInvoiceIncome"] = true,
    ["finance_rsInvoiceExpense"] = true,
	["rs_ui_moneyType_invoice_income"] = true,
    ["rs_ui_moneyType_invoice_expense"] = true,
    -- Settings menu texts (we call getText() without modEnv during GUI injection)
    ["rs_help_title_invoice_settings"] = true,
    ["rs_setting_rsVatPercent"] = true,
    ["rs_toolTip_rsVatPercent"] = true,
    ["rs_setting_rsMaxOpenInvoices"] = true,
    ["rs_toolTip_rsMaxOpenInvoices"] = true,
    ["rs_setting_rsInterestPercent"] = true,
    ["rs_toolTip_rsInterestPercent"] = true,
    ["rs_setting_rsInterestIntervalDays"] = true,
    ["rs_toolTip_rsInterestIntervalDays"] = true,
	["rs_ui_errorAmount"] = true,

    -- UI error
    
}

function RTI18NExtension:getText(superFunc, text, modEnv)
    if modEnv == nil and RTI18NExtension.redTapeTexts[text] then
        return superFunc(self, text, modName)
    end

    return superFunc(self, text, modEnv)
end

I18N.getText = Utils.overwrittenFunction(I18N.getText, RTI18NExtension.getText)