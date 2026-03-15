--[[
Copyright (C) GtX (Andy), 2025

Author: GtX | Andy
Date: 10.01.2025
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

EasyDevControlsErrorCodes = {}

EasyDevControlsErrorCodes.NONE = 1
EasyDevControlsErrorCodes.SUCCESS = 2
EasyDevControlsErrorCodes.FAILED = 3
EasyDevControlsErrorCodes.UNKNOWN_FAIL = 4
EasyDevControlsErrorCodes.INVALID_FARM = 5
EasyDevControlsErrorCodes.PERMISSIONS = 6
EasyDevControlsErrorCodes.CANCELLED = 7

Enum(EasyDevControlsErrorCodes)

local errorCodeTexts = {
    "easyDevControls_noInformationMessage",
    "easyDevControls_success",
    "easyDevControls_requestFailedMessage",
    "easyDevControls_unknownFailMessage",
    "easyDevControls_invalidFarmWarning",
    "shop_messageNoPermissionGeneral",
    "easyDevControls_requestCancelledMessage"
}

function EasyDevControlsErrorCodes.getText(errorCode)
    local l10n = errorCodeTexts[errorCode]

    if l10n == nil then
        return ""
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsErrorCodes.getValidErrorCode(errorCode, backup)
    if errorCode == nil then
        return backup or EasyDevControlsErrorCodes.NONE
    end

    if EasyDevControlsErrorCodes.getName(errorCode) == nil then
        if g_easyDevControlsDevelopmentMode then
            local available = {}

            for name, index in pairs(EasyDevControlsErrorCodes.getAll()) do
                table.insert(available, `{index} = {name}`)
            end

            table.sort(available)

            local message = "  DevError: [Easy Development Controls] Invalid error code '%s' for Enum 'EasyDevControlsErrorCodes', only %d codes available.\n    Use: %s"

            printError(string.format(message, errorCode, #available, table.concat(available, ", ")))
            printCallstack()
        end

        return backup or EasyDevControlsErrorCodes.NONE
    end

    return errorCode
end

function EasyDevControlsErrorCodes.getNumTexts()
    return #errorCodeTexts
end