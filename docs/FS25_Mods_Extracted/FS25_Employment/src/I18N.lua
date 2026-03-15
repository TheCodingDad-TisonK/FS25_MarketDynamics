Employment_I18N = {}
local modName = g_currentModName

function Employment_I18N:getText(superFunc, text, modEnv)

    if (text == "employment_ui_employmentIncome" or text == "finance_employmentIncome") and modEnv == nil then
        return superFunc(self, text, modName)
    end

    return superFunc(self, text, modEnv)

end

I18N.getText = Utils.overwrittenFunction(I18N.getText, Employment_I18N.getText)