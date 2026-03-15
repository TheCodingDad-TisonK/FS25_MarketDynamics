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

EasyDevControlsObjectTypes = {}

EasyDevControlsObjectTypes.UNKNOWN = 1
EasyDevControlsObjectTypes.VEHICLE = 2
EasyDevControlsObjectTypes.PLACEABLE = 3
EasyDevControlsObjectTypes.MAP_PLACEABLE = 4
EasyDevControlsObjectTypes.PRODUCTION_POINT = 5
EasyDevControlsObjectTypes.PRODUCTION = 6
EasyDevControlsObjectTypes.TRAIN_SYSTEM = 7
EasyDevControlsObjectTypes.PALLET = 8
EasyDevControlsObjectTypes.BALE = 9
EasyDevControlsObjectTypes.LOG = 10
EasyDevControlsObjectTypes.TREE = 11
EasyDevControlsObjectTypes.STUMP = 12
EasyDevControlsObjectTypes.FIELD = 13

Enum(EasyDevControlsObjectTypes)

local typeTexts = {
    "easyDevControls_typeUnknownType",
    "easyDevControls_typeVehicle",
    "easyDevControls_typePlaceable",
    "easyDevControls_typePrePlacedPlaceable",
    "easyDevControls_typeProductionPoint",
    "easyDevControls_typeProduction",
    "easyDevControls_typeTrainSystem",
    "easyDevControls_typePallet",
    "easyDevControls_typeBale",
    "easyDevControls_typeLog",
    "easyDevControls_typeTree",
    "easyDevControls_typeStump",
    "easyDevControls_typeField"
}

function EasyDevControlsObjectTypes.getText(typeId, count, formatCount)
    local l10n = typeTexts[typeId] or typeTexts[1]

    if count ~= 1 then
        l10n = l10n .. "s" -- Adding 's' to the l10n name will return the plural version
    end

    if formatCount then
        return string.format("%i %s", count, EasyDevControlsUtils.getText(l10n))
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsObjectTypes.getTextByName(typeName, count, formatCount)
    return EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.getByName(typeName), count, formatCount)
end

function EasyDevControlsObjectTypes.getNumTexts()
    return #typeTexts
end
