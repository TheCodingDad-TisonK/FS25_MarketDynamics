--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-03

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

EasyDevControlsUtils = {}

local modName = g_currentModName or ""
local modDirectory = g_currentModDirectory or ""

local modSettingsDirectory = (g_modSettingsDirectory or "") .. "FS25_EasyDevControls/"
local currentModSettingsDirectory = g_currentModSettingsDirectory or ""

local isUpdate = modName:endsWith("_update")

local wrappedFunctions = nil
local wrappedGameFunctions = nil

EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH = {
    PINE = 20,
    BIRCH = 5,
    MAPLE = 2,
    OAK = 3,
    AMERICANELM = 5,
    SHAGBARKHICKORY = 4,
    DEADWOOD = 21,
    LODGEPOLEPINE = 34,
    PINUSSYLVESTRIS = 36, -- 38
    PINUSTABULIFORMIS = 24,
    GOLDENRAIN = 2,
    BETULAERMANII = 2,
    ASPEN = 16,
    BEECH = 17,
    BOXELDER = 2,
    CHINESEELM = 2,
    JAPANESEZELKOVA = 3,
    TILIAAMURENSIS = 3,
    RAVAGED = 9,
    SPRUCE = 24, -- Silver Run Forest
    STONEPINE = 20, -- Silver Run Forest
    GIANTSEQUOIA = 14, -- Silver Run Forest
    PONDEROSAPINE = 30 -- Silver Run Forest
}

if g_modIsLoaded["pdlc_highlandsFishingPack"] then
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.ACORN = nil
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.BIRCH = 3
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.BEECH = 15
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.HORSECHESTNUT = 2
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.PINE = 20
    EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH.SPRUCE = 25
end

EasyDevControlsUtils.FIELD_GROUND_TYPE_TEXTS = {
    NONE = "ui_none",
    STUBBLE_TILLAGE = "ui_growthMapStubbleTillage",
    CULTIVATED = "ui_growthMapCultivated",
    SEEDBED = "ui_growthMapSeedbed",
    PLOWED = "ui_growthMapPlowed",
    ROLLED_SEEDBED = "easyDevControls_rolledSeedbed",
    RIDGE = "easyDevControls_ridge",
    SOWN = "ui_growthMapSown",
    DIRECT_SOWN = "easyDevControls_directSown",
    PLANTED = "easyDevControls_planted",
    RIDGE_SOWN = "easyDevControls_ridgeSown",
    ROLLER_LINES = "easyDevControls_rollerLines",
    HARVEST_READY = "ui_growthMapReadyToHarvest",
    HARVEST_READY_OTHER = "easyDevControls_harvestReadyOther",
    GRASS = "groundType_grass",
    GRASS_CUT = "easyDevControls_grassCut"
}

EasyDevControlsUtils.FIELD_SPRAY_TYPE_TEXTS = {
    NONE = "ui_none",
    FERTILIZER = "easyDevControls_fertilizerStateTitle",
    LIME = "fillType_lime",
    MANURE = "fillType_manure",
    LIQUID_MANURE = "fillType_liquidManure",
    STRAW = "fillType_straw",
    MAIZE = "fillType_maize",
    MASK = "easyDevControls_mask"
}

EasyDevControlsUtils.DEFAULT_RANGES = table.create(100)

for i = 1, 100 do
    table.insert(EasyDevControlsUtils.DEFAULT_RANGES, i)
end

EasyDevControlsUtils.WEATHER_TYPE_NAME_TEXTS = {
    SUN = "easyDevControls_weatherTypeSunny",
    PARTIALLY_CLOUDY = "easyDevControls_weatherTypePartiallyCloudy",
    CLOUDY = "easyDevControls_weatherTypeCloudy",
    RAIN = "easyDevControls_weatherTypeRaining",
    SNOW = "easyDevControls_weatherTypeSnowing",
    HAIL = "easyDevControls_weatherTypeHail",
    TWISTER = "easyDevControls_weatherTypeTwister",
    THUNDER = "easyDevControls_weatherTypeThunder"
}

EasyDevControlsUtils.SEASON_TEXTS = {
    [Season.SPRING] = "easyDevControls_seasonSpring",
    [Season.SUMMER] = "easyDevControls_seasonSummer",
    [Season.AUTUMN] = "easyDevControls_seasonAutumn",
    [Season.WINTER] = "easyDevControls_seasonWinter"
}

function EasyDevControlsUtils.getCustomEnvironment()
    return modName
end

function EasyDevControlsUtils.getBaseDirectory()
    return modDirectory
end

function EasyDevControlsUtils.getSettingsDirectory(getCurrent)
    if getCurrent then
        return currentModSettingsDirectory
    end

    return modSettingsDirectory
end

function EasyDevControlsUtils.getLocalFilename(filename)
    if string.isNilOrWhitespace(filename) then
        return ""
    end

    return modDirectory .. filename
end

function EasyDevControlsUtils.getFilename(filename)
    if not string.isNilOrWhitespace(filename) then
        if filename:sub(1, 17) == "$easyDevControls$" then
            return modDirectory .. filename:sub(18), false
        end

        return Utils.getFilename(filename, modDirectory)
    end

    return "", true
end

function EasyDevControlsUtils.getIsUpdate()
    return isUpdate
end

function EasyDevControlsUtils.getText(name)
    return g_i18n:getText(name, modName)
end

function EasyDevControlsUtils.convertText(text)
    if text == nil then
        EasyDevControlsLogging.warning("No text given to convert!")
        printCallstack()

        return ""
    end

    if string.startsWith(text, "$l10n_") then
        return g_i18n:getText(text:sub(7), modName)
    end

    return text
end

function EasyDevControlsUtils.formatText(name, ...)
    return string.format(g_i18n:getText(name, modName), ...)
end

function EasyDevControlsUtils.namedFormatText(name, ...)
    return string.namedFormat(g_i18n:getText(name, modName), ...)
end

function EasyDevControlsUtils.formatConvertedText(text, ...)
    return string.format(EasyDevControlsUtils.convertText(text), ...)
end

function EasyDevControlsUtils.namedFormatConvertedText(text, ...)
    return string.namedFormat(EasyDevControlsUtils.convertText(text), ...)
end

function EasyDevControlsUtils.formatLength(value, useCentimetres)
    if useCentimetres == true then
        return string.format("%i %s", value * 100, g_i18n:getText("unit_cmShort"))
    end

    return string.format("%i %s", value, g_i18n:getText("unit_mShort"))
end

function EasyDevControlsUtils.formatSquared(value, useCentimetres)
    if useCentimetres == true then
        return string.format("%i %s²", value * 100, g_i18n:getText("unit_cmShort"))
    end

    return string.format("%i %s²", value, g_i18n:getText("unit_mShort"))
end

function EasyDevControlsUtils.getFormatedRangeTexts(rangeTable, useCentimetres, useSquared)
    rangeTable = rangeTable or EasyDevControlsUtils.DEFAULT_RANGES

    local rangeTexts = table.create(#rangeTable)
    local short = "unit_mShort"

    if useCentimetres then
        short = "unit_cmShort"
    end

    short = g_i18n:getText(short)

    if useSquared then
        for _, range in ipairs (rangeTable) do
            table.insert(rangeTexts, string.format("%i %s²", range, short))
        end
    else
        for _, range in ipairs (rangeTable) do
            table.insert(rangeTexts, string.format("%i %s", range, short))
        end
    end

    return rangeTexts
end

function EasyDevControlsUtils.getRangeTable(startValue, endValue)
    if startValue < 0 then
        endValue = math.max(1, endValue + startValue)
    end

    local rangeTable = {}

    for i = startValue, endValue do
        table.insert(rangeTable, i)
    end

    return rangeTable
end

function EasyDevControlsUtils.getDefaultRangeTable()
    return EasyDevControlsUtils.DEFAULT_RANGES
end

function EasyDevControlsUtils.getDefaultRangeValue(index, getValueIndex)
    if getValueIndex == true then
        return Utils.getValueIndex(index, EasyDevControlsUtils.DEFAULT_RANGES)
    end

    return EasyDevControlsUtils.DEFAULT_RANGES[index]
end

function EasyDevControlsUtils.getIsCheckedState(state)
    return (state or 0) >= BinaryOptionElement.STATE_RIGHT
end

function EasyDevControlsUtils.getStateText(state, useYesNoTexts)
    if useYesNoTexts then
        return g_i18n:getText(state and "ui_yes" or "ui_no")
    end

    return g_i18n:getText(state and "ui_on" or "ui_off")
end

function EasyDevControlsUtils.getWeatherTypeText(typeName)
    local l10n = EasyDevControlsUtils.WEATHER_TYPE_NAME_TEXTS[typeName]

    if l10n == nil then
        return EasyDevControlsUtils.capitalise(typeName, false)
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsUtils.getSeasonText(season)
    local l10n = EasyDevControlsUtils.SEASON_TEXTS[season]

    if l10n == nil then
        return EasyDevControlsUtils.getText("easyDevControls_unknown")
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsUtils.getNoNilClamp(value, minValue, maxValue, setTo)
    -- return math.min(math.max((value or setTo), minValue), maxValue)
    return math.clamp(value or setTo, minValue, maxValue)
end

function EasyDevControlsUtils.getHasValidLocationValues(x, y, z)
    return not (x == nil or y == nil or z == nil)
end

function EasyDevControlsUtils.getValidAngle(angle)
    angle = angle % (2 * math.pi)

    if angle < 0 then
        angle = angle + 2 * math.pi
    end

    return angle
end

function EasyDevControlsUtils.getIsValidFarmId(farmId)
    return farmId ~= nil and farmId > FarmManager.SPECTATOR_FARM_ID and farmId <= FarmManager.MAX_FARM_ID
end

function EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex, backup)
    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex) -- Fix for some mods that change names but does not correctly update 'getFillTypeTitleByIndex'
    -- local fillTypeTitle = g_fillTypeManager:getFillTypeTitleByIndex(fillTypeIndex)

    if fillType == nil then
        if backup ~= nil then
            return EasyDevControlsUtils.convertText(backup)
        end

        return EasyDevControlsUtils.getText("easyDevControls_all"):lower()
    end

    -- Simple fix for base game issue where unlike Sugar Beet there are no correct translations for the following. These are new for FS25 @Giants??
    if fillTypeIndex == FillType.WHEAT_CUT or fillTypeIndex == FillType.WHEAT_CUT or fillTypeIndex == FillType.WHEAT_CUT or fillTypeIndex == FillType.WHEAT_CUT then
        if g_languageShort == "en" and fillType.title:sub(-3) ~= "Cut" then
            return string.format("%s %s", fillType.title, g_i18n:getText("action_woodHarvesterCut"))
        end

        return string.format("%s (%s)", fillType.title, g_i18n:getText("action_woodHarvesterCut"))
    end

    return fillType.title
end

function EasyDevControlsUtils.getFieldSprayTypeTitle(typeName, backup)
    local l10n = EasyDevControlsUtils.FIELD_SPRAY_TYPE_TEXTS[typeName]

    if l10n == nil then
        if backup ~= nil then
            return EasyDevControlsUtils.removeUnderscores(backup, true, true)
        end

        return EasyDevControlsUtils.getText("easyDevControls_unknown")
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsUtils.getFieldGroundTypeTitle(typeName, backup)
    local l10n = EasyDevControlsUtils.FIELD_GROUND_TYPE_TEXTS[typeName]

    if l10n == nil then
        if backup ~= nil then
            return EasyDevControlsUtils.removeUnderscores(backup, true, true)
        end

        return EasyDevControlsUtils.getText("easyDevControls_unknown")
    end

    return EasyDevControlsUtils.getText(l10n)
end

function EasyDevControlsUtils.getPlayerWorldLocation(distance)
    local player = g_localPlayer

    if player ~= nil then
        local x, y, z = player:getPosition()
        local dirX, dirZ = player:getCurrentFacingDirection()

        distance = distance or 1 --4

        return x + dirX * distance, y, z + dirZ * distance, dirX, dirZ, player, player:getCurrentVehicle()
    end

    return nil
end

function EasyDevControlsUtils.getObjectSpawnLocation(setY, useTerrainHeight)
    if g_localPlayer == nil then
        return nil
    end

    local x, y, z = g_localPlayer:getPosition()
    local dirX, dirZ = g_localPlayer:getCurrentFacingDirection()

    x += dirX * 4
    z += dirZ * 4

    if useTerrainHeight then
        y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z)
    end

    return x, y + (setY or 5), z, dirX, 0, dirZ, MathUtil.getYRotationFromDirection(dirX, dirZ)
end

function EasyDevControlsUtils.getArea(x, z, radius, getWidthAndHeight)
    local halfRadius = (radius or 1) / 2

    if x == nil or z == nil then
        local _ = nil

        if g_localPlayer ~= nil then
            x, _, z = player:getPosition()
        else
            x, _, z = getWorldTranslation(getCamera(0))
        end
    end

    if getWidthAndHeight then
        return MathUtil.getXZWidthAndHeight(x - halfRadius, z - halfRadius, x + halfRadius, z - halfRadius, x - halfRadius, z + halfRadius)
    end

    return x - halfRadius, z - halfRadius, x + halfRadius, z - halfRadius, x - halfRadius, z + halfRadius
end

function EasyDevControlsUtils.getProjectedArea(sizeX, sizeZ, distance, getWidthAndHeight)
    local posX, _, posZ, dirX, dirZ = EasyDevControlsUtils.getPlayerWorldLocation()

    if posX == nil or posZ == nil then
        posX, _, posZ = getWorldTranslation(getCamera(0))
    end

    sizeX = sizeX or 5
    sizeZ = sizeZ or 5
    distance = distance or 2

    local sideX, _, sideZ = MathUtil.crossProduct(dirX, 0, dirZ, 0, 1, 0)
    local startWorldX = posX - sideX * sizeX * 0.5 + dirX * distance
    local startWorldZ = posZ - sideZ * sizeX * 0.5 + dirZ * distance
    local widthWorldX = posX + sideX * sizeX * 0.5 + dirX * distance
    local widthWorldZ = posZ + sideZ * sizeX * 0.5 + dirZ * distance
    local heightWorldX = posX - sideX * sizeX * 0.5 + dirX * (distance + sizeZ)
    local heightWorldZ = posZ - sideZ * sizeX * 0.5 + dirZ * (distance + sizeZ)

    local positionX = (startWorldX + widthWorldX + heightWorldX) / 3
    local positionZ = (startWorldZ + widthWorldZ + heightWorldZ) / 3

    if getWidthAndHeight then
        startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ = MathUtil.getXZWidthAndHeight(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    end

    return startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, positionX, positionZ
end

function EasyDevControlsUtils.getObjectLocationString(node, owningPlaceable)
    if g_currentMission ~= nil or g_currentMission.hud ~= nil then
        local ingameMap = g_currentMission.hud:getIngameMap()

        if ingameMap ~= nil and node ~= nil then
            local x, y, z = getWorldTranslation(node)

            if owningPlaceable ~= nil then
                local hotspot = owningPlaceable:getHotspot(1)

                -- Make sure there is a teleport node world position available or just use given node.
                if hotspot ~= nil and hotspot.teleportWorldX ~= nil and hotspot.teleportWorldY ~= nil and hotspot.teleportWorldZ ~= nil then
                    x = hotspot.teleportWorldX
                    y = hotspot.teleportWorldY
                    z = hotspot.teleportWorldZ
                end
            end

            local normalizedPosX = EasyDevControlsUtils.getNoNilClamp((x + ingameMap.worldCenterOffsetX) / ingameMap.worldSizeX, 0, 1, x)
            local normalizedPosZ = EasyDevControlsUtils.getNoNilClamp((z + ingameMap.worldCenterOffsetZ) / ingameMap.worldSizeZ, 0, 1, z)

            return string.format("%d, %d", normalizedPosX * ingameMap.worldSizeX, normalizedPosZ * ingameMap.worldSizeZ)
        end
    end

    return "N/A"
end

function EasyDevControlsUtils.getIsFarmlandAccessible(x, z, farmId, radius)
    if x == nil or z == nil or not EasyDevControlsUtils.getIsValidFarmId(farmId) then
        return false
    end

    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)

    if farmlandId ~= nil and farmlandId ~= FarmlandManager.NOT_BUYABLE_FARM_ID then
        local farmlandOwner = g_farmlandManager:getFarmlandOwner(farmlandId)

        if farmlandOwner ~= FarmlandManager.NO_OWNER_FARM_ID and g_currentMission.accessHandler:canFarmAccessOtherId(farmId, farmlandOwner) then
            if radius == nil then
                return true
            end

            local startX, startZ, widthX, widthZ, heightX, heightZ = EasyDevControlsUtils.getArea(x, z, radius)

            if EasyDevControlsUtils.getIsFarmlandAccessible(startX, startZ, farmId) then
                if EasyDevControlsUtils.getIsFarmlandAccessible(widthX, widthZ, farmId) then
                    return EasyDevControlsUtils.getIsFarmlandAccessible(heightX, heightZ, farmId)
                end
            end
        end
    end

    return false
end

function EasyDevControlsUtils.getCanTipToGround(amount, fillTypeIndex, x, y, z, dirX, dirZ, length, vehicle, farmId, connection)
    length = length or 1

    if g_easyDevControls == nil or not g_easyDevControls:getIsMasterUser(connection) then
        if not EasyDevControlsUtils.getIsFarmlandAccessible(x, z, farmId, nil) then
            return false
        end

        for i = length, 1, -1 do
            if not EasyDevControlsUtils.getIsFarmlandAccessible(x + i * dirX, z + i * dirZ, farmId) then
                return false
            end
        end
    end

    return DensityMapHeightUtil.getCanTipToGroundAroundLine(vehicle, amount or 100, fillTypeIndex or FillType.CHAFF, x, y, z, x + length * dirX, y, z + length * dirZ, 10, 40, 0, false, nil, nil)
end

function EasyDevControlsUtils.getMonthFromPeriod(currentPeriod)
    local environment = g_currentMission.environment
    local month = 1

    if environment ~= nil then
        currentPeriod = currentPeriod or environment.currentPeriod

        month = currentPeriod + 2

        if environment.daylight.latitude < 0 then
            month = month + 6
        end

        month = (month - 1) % 12 + 1
    end

    return month
end

function EasyDevControlsUtils.getPeriodFromMonth(month)
    local environment = g_currentMission.environment
    local period = SeasonPeriod.EARLY_SPRING

    if environment ~= nil and month ~= nil then
        period = month - 2

        if environment.daylight.latitude < 0 then
            period = period - 6
        end

        period = (period - 1) % 12 + 1
    end

    return period
end

function EasyDevControlsUtils.getPathFromString(env, pathString)
    -- TO_DO: Currently part of my new debugger as I am not sure how many used this and idea was just copied anyway..
    --        Will still add an option later as the original ideas are all mine :-)
end

function EasyDevControlsUtils.capitalise(text, capitaliseEachWord)
    if text == nil then
        return ""
    end

    text = text:lower()

    if capitaliseEachWord then
        text = text:gsub("(%w[%w]*)", function(word)
            return word:sub(1, 1):upper() .. word:sub(2)
        end)
    else
        text = text:sub(1, 1):upper() .. text:sub(2)
    end

    return text
end

function EasyDevControlsUtils.removeUnderscores(text, capitalise, capitaliseEachWord)
    if text == nil then
        return ""
    end

    text = text:gsub("_", " ")

    if capitalise then
        text = EasyDevControlsUtils.capitalise(text, capitaliseEachWord)
    end

    return text
end

function EasyDevControlsUtils.splitCamelCase(text, capitalise, capitaliseEachWord)
    if text == nil then
        return ""
    end

    -- text = text:gsub("(%l)(%u)", "%1 %2")
    -- TO_DO: Use a single pattern rather than 2 gsubs
    text = text:gsub("(%l)([%d%u])", "%1 %2"):gsub("(%d)(%u)", "%1 %2") -- add a space before each upper case letter and again to add space between digits and upper case

    if capitalise then
        text = EasyDevControlsUtils.capitalise(text, capitaliseEachWord)
    end

    return text
end

function EasyDevControlsUtils.clearTable(tableToClear, createMissing) -- clearNumericTable
    if tableToClear == nil then
        if not createMissing then
            return
        end

        return {}
    end

    for i = #tableToClear, 1, -1 do
        tableToClear[i] = nil
    end
end

function EasyDevControlsUtils.getIsValidVehicle(vehicle, requiredName)
    if vehicle == nil or (vehicle.markedForDeletion or vehicle.isDeleted or vehicle.isDeleting) then
        return false
    end

    return requiredName == nil or vehicle[requiredName] ~= nil
end

function EasyDevControlsUtils.collectPositionData(vehicle, isImplement, vehicles, attachedVehicles, rootVehicle, isTeleporting)
    local x, y, z = getWorldTranslation(vehicle.rootNode)

    if rootVehicle == nil then
        rootVehicle = vehicle

        if vehicles[1] ~= nil and vehicles[1].vehicle ~= nil then
            rootVehicle = vehicles[1].vehicle
        end
    end

    table.insert(vehicles, {
        vehicle = vehicle,
        isImplement = isImplement,
        offset = {worldToLocal(rootVehicle.rootNode, x, y, z)}
    })

    -- Only with 'spec_attacherJoints'
    if vehicle.getAttachedImplements ~= nil then
        local attachedImplements = vehicle:getAttachedImplements()
        local numAttachedImplements = #attachedImplements

        -- If there are implements then record their position
        if numAttachedImplements > 0 then
            for _, implement in pairs(attachedImplements) do
                EasyDevControlsUtils.collectPositionData(implement.object, true, vehicles, attachedVehicles, rootVehicle, isTeleporting)

                table.insert(attachedVehicles, {
                    vehicle = vehicle,
                    object = implement.object,
                    jointDescIndex = implement.jointDescIndex,
                    inputAttacherJointDescIndex = implement.object:getActiveInputAttacherJointDescIndex()
                })
            end

            if isTeleporting then
                for i = numAttachedImplements, 1, -1 do
                    vehicle:detachImplement(1, true)
                end
            end
        end
    end

    if isTeleporting then
        vehicle:removeFromPhysics()
    end
end

function EasyDevControlsUtils.getVehiclesPositionData(vehicle, targetVehicle, isTeleporting)
    local vehicles = {}
    local attachedVehicles = {}

    if vehicle ~= nil then
        EasyDevControlsUtils.collectPositionData(vehicle, false, vehicles, attachedVehicles, vehicle, Utils.getNoNil(isTeleporting, false))
    end

    return vehicles, attachedVehicles
end

function EasyDevControlsUtils.getVinePlaceables()
    local vineSystem = g_currentMission.vineSystem
    local vinePlaceables = {}

    if vineSystem ~= nil and vineSystem.nodes ~= nil then
        for node, placeable in pairs (vineSystem.nodes) do
            if vinePlaceables[placeable] == nil then
                vinePlaceables[placeable] = {}
            end

            table.insert(vinePlaceables[placeable], node)
        end
    end

    return vinePlaceables
end

-- To the person (You know who you are) that created a mod to delete stumps, bales and pallets and cut and pasted my code without asking there has been no changes here. But Keep Out!!!
function EasyDevControlsUtils.collectSplitSplitShapes(node, findLogs, findStumps, splitSplitShapes)
    for i = 0, getNumOfChildren(node) - 1 do
        local node = getChildAt(node, i)

        if (getName(node) == "splitGeom" and getHasClassId(node, ClassIds.MESH_SPLIT_SHAPE)) and (getSplitType(node) ~= 0 and getIsSplitShapeSplit(node)) then
            local rigidBodyType = getRigidBodyType(node)

            if (findLogs and rigidBodyType == RigidBodyType.DYNAMIC) or (findStumps and rigidBodyType == RigidBodyType.STATIC) then
                splitSplitShapes[node] = node
            end
        else
            EasyDevControlsUtils.collectSplitSplitShapes(node, findLogs, findStumps, splitSplitShapes)
        end
    end
end

function EasyDevControlsUtils.getClearAreaDensityMapModifiers(fillTypeIndex)
    if fillTypeIndex == nil or fillTypeIndex == FillType.UNKNOWN then
        local modifiers = DensityMapHeightUtil.modifiersCache.clearArea

        if modifiers == nil then
            modifiers = {
                heightModifier = DensityMapModifier.new(DensityMapHeightUtil.terrainDetailHeightId, DensityMapHeightUtil.heightFirstChannel, DensityMapHeightUtil.heightNumChannels),
                typeModifier = DensityMapModifier.new(DensityMapHeightUtil.terrainDetailHeightId, DensityMapHeightUtil.typeFirstChannel, DensityMapHeightUtil.typeNumChannels)
            }

            DensityMapHeightUtil.modifiersCache.clearArea = modifiers
        end

        return modifiers
    end

    if g_densityMapHeightManager:getIsValid() then
        local heightType = g_densityMapHeightManager:getDensityMapHeightTypeByFillTypeIndex(fillTypeIndex)

        if heightType ~= nil then
            local modifiers = DensityMapHeightUtil.modifiersCache.removeFromGroundByArea

            if modifiers == nil then
                modifiers = {
                    heightModifier = DensityMapModifier.new(DensityMapHeightUtil.terrainDetailHeightId, DensityMapHeightUtil.heightFirstChannel, DensityMapHeightUtil.heightNumChannels),
                    typeModifier = DensityMapModifier.new(DensityMapHeightUtil.terrainDetailHeightId, DensityMapHeightUtil.typeFirstChannel, DensityMapHeightUtil.typeNumChannels),
                    typeFilters = {}
                }

                DensityMapHeightUtil.modifiersCache.removeFromGroundByArea = modifiers
            end

            local typeFilter = modifiers.typeFilters[heightType]

            if typeFilter == nil then
                typeFilter = DensityMapFilter.new(modifiers.typeModifier)

                typeFilter:setValueCompareParams(DensityValueCompareType.EQUAL, heightType.index)

                modifiers.typeFilters[heightType] = typeFilter
            end

            return modifiers, typeFilter
        end
    end

    return nil
end

function EasyDevControlsUtils.clearArea(startX, startZ, widthX, widthZ, heightX, heightZ, fillTypeIndex)
    local modifiers, typeFilter = EasyDevControlsUtils.getClearAreaDensityMapModifiers(fillTypeIndex)

    if modifiers ~= nil then
        modifiers.heightModifier:setParallelogramWorldCoords(startX, startZ, widthX, widthZ, heightX, heightZ, DensityCoordType.POINT_POINT_POINT)
        modifiers.typeModifier:setParallelogramWorldCoords(startX, startZ, widthX, widthZ, heightX, heightZ, DensityCoordType.POINT_POINT_POINT)

        -- modifiers.heightModifier:executeSetWithStats(0, typeFilter)
        modifiers.heightModifier:executeSet(0, typeFilter)
        modifiers.typeModifier:executeSet(0, typeFilter)

        return true
    end

    return false

    -- if fillTypeIndex == nil or fillTypeIndex == FillType.UNKNOWN then
       -- DensityMapHeightUtil.clearArea(startX, startZ, widthX, widthZ, heightX, heightZ)
    -- else
        -- Not working correctly in FS25, leaving a heap of terrain, could be that the 'heightModifier' is set second and there is no longer anything to change because mine works??
        -- DensityMapHeightUtil.removeFromGroundByArea(startX, startZ, widthX, widthZ, heightX, heightZ, fillTypeIndex)
    -- end
end

-- May be a better solution but need more docs.
function EasyDevControlsUtils.clearFarmland(farmlandId, fillTypeIndex)
    local farmlandManager = g_farmlandManager

    if farmlandManager == nil or farmlandManager:getFarmlandById(farmlandId) == nil then
        return false
    end

    local modifiers, typeFilter = EasyDevControlsUtils.getClearAreaDensityMapModifiers(fillTypeIndex)

    if modifiers == nil then
        return false
    end

    local numAreasCleared = 0

    local terrainSize = g_currentMission.terrainSize
    local terrainSizeHalf = terrainSize / 2

    local bitmapToWorld = terrainSize / farmlandManager.localMapWidth
    local worldToBitmap = farmlandManager.localMapWidth / terrainSize

    local farmlands = farmlandManager.farmlands
    local localMap = farmlandManager.localMap
    local numberOfBits = farmlandManager.numberOfBits

    local farmland, bitmapX, bitmapZ = nil, nil, nil
    local startX, startZ, widthX, widthZ, heightX, heightZ, valid = nil, nil, nil, nil, nil, nil, false

    for stepZ = 0, terrainSize - 1, 2 do
        bitmapZ = math.floor((stepZ - terrainSizeHalf) + terrainSizeHalf) * worldToBitmap

        startX, startZ, widthX, widthZ, heightX, heightZ, valid = nil, nil, nil, nil, nil, nil, false

        for stepX = 0, terrainSize - 1, 2 do
            bitmapX = math.floor((stepX - terrainSizeHalf) + terrainSizeHalf) * worldToBitmap

            farmland = farmlands[getBitVectorMapPoint(localMap, bitmapX, bitmapZ, 0, numberOfBits)]

            if farmland ~= nil and farmland.id == farmlandId then
                if startX == nil then
                    startX = bitmapX * bitmapToWorld - terrainSizeHalf
                    startZ = bitmapZ * bitmapToWorld - terrainSizeHalf
                    widthX = bitmapX * bitmapToWorld - terrainSizeHalf
                    widthZ = bitmapZ * bitmapToWorld - terrainSizeHalf + bitmapToWorld
                    heightX = bitmapX * bitmapToWorld - terrainSizeHalf + bitmapToWorld
                    heightZ = bitmapZ * bitmapToWorld - terrainSizeHalf

                    valid = true
                else
                    heightX = bitmapX * bitmapToWorld - terrainSizeHalf + bitmapToWorld
                end
            end
        end

        if valid then
            modifiers.heightModifier:setParallelogramWorldCoords(startX, startZ, widthX, widthZ, heightX, heightZ, DensityCoordType.POINT_POINT_POINT)
            modifiers.typeModifier:setParallelogramWorldCoords(startX, startZ, widthX, widthZ, heightX, heightZ, DensityCoordType.POINT_POINT_POINT)

            -- modifiers.heightModifier:executeSetWithStats(0, typeFilter)
            modifiers.heightModifier:executeSet(0, typeFilter)
            modifiers.typeModifier:executeSet(0, typeFilter)

            -- local debugPlane = DebugPlane.newSimple(false, false, Color.PRESETS.ORANGE, true):createWithPositions(startX, 0, startZ, widthX, 0, widthZ, heightX, 0, heightZ)
            -- g_debugManager:addElement(debugPlane, "edcFarmlands", 60000)

            numAreasCleared += 1
        end
    end

    return numAreasCleared > 0
end

function EasyDevControlsUtils.clearField(field, fillTypeIndex, farmId, immediate)
    if field ~= nil and field.getDensityMapPolygon ~= nil then
        if farmId ~= nil and field.farmland ~= nil then
            if g_farmlandManager:getFarmlandOwner(field.farmland:getId()) ~= farmId then
                return false
            end
        end

        local typeFilter, _ = nil, nil

        if fillTypeIndex ~= nil then
             _, typeFilter = EasyDevControlsUtils.getClearAreaDensityMapModifiers(fillTypeIndex)

             if typeFilter == nil then
                return false
             end
        end

        local fieldUpdateTask = FieldUpdateTask.new()

        fieldUpdateTask:setField(field)
        fieldUpdateTask:setArea(field:getDensityMapPolygon())

        fieldUpdateTask:addFilter(typeFilter)
        fieldUpdateTask:clearHeight()

        fieldUpdateTask:resetDisplacement() -- ?
        fieldUpdateTask:clearTireTracks()

        fieldUpdateTask:enqueue(Utils.getNoNil(immediate, true))

        return true
    end

    return false
end

function EasyDevControlsUtils.setField(field, fruitTypeIndex, growthState, groundType, groundAngle, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId)
    if field == nil or field.farmland == nil then
        return false
    end

    local missionInfo = g_currentMission.missionInfo
    local farmlandId = field.farmland:getId()

    if buyFarmland and farmId ~= nil and g_farmlandManager:getFarmlandOwner(farmlandId) ~= farmId then
        g_server:broadcastEvent(FarmlandStateEvent.new(farmlandId, farmId, 0), false)
        g_farmlandManager:setLandOwnership(farmlandId, farmId)
    end

    local fieldUpdateTask = FieldUpdateTask.new()

    fieldUpdateTask:setField(field)
    fieldUpdateTask:setArea(field:getDensityMapPolygon())

    groundAngle = groundAngle or 0

    if fruitTypeIndex ~= nil then
        if fruitTypeIndex ~= FruitType.UNKNOWN and groundAngle ~= 0 then
            groundAngle = (groundType == FieldGroundType.RIDGE or groundType == FieldGroundType.RIDGE_SOWN) and 0 or groundAngle
        end

        fieldUpdateTask:setFruit(fruitTypeIndex, growthState or 1)
    end

    fieldUpdateTask:setGroundType(groundType)
    fieldUpdateTask:setGroundAngle(-groundAngle)

    fieldUpdateTask:setWeedState(missionInfo.weedsEnabled and weedState or 0)
    fieldUpdateTask:setStoneLevel(missionInfo.stonesEnabled and stoneLevel or 0)

    fieldUpdateTask:setSprayType(sprayType)
    fieldUpdateTask:setSprayLevel(sprayLevel)
    fieldUpdateTask:setLimeLevel(limeLevel)

    fieldUpdateTask:setPlowLevel(plowLevel)
    fieldUpdateTask:setRollerLevel(rollerLevel)
    fieldUpdateTask:setStubbleShredLevel(stubbleShredLevel)

    if clearHeightTypes then
        fieldUpdateTask:clearHeight()
    end

    fieldUpdateTask:resetDisplacement()
    fieldUpdateTask:clearTireTracks()

    fieldUpdateTask:enqueue(true)

    return true
end

function EasyDevControlsUtils.deleteTree(shape, isPlanted, setAreaDirty)
    if g_server ~= nil and shape ~= nil and entityExists(shape) then
        local x, y, z = getWorldTranslation(shape)

        g_currentMission:removeKnownSplitShape(shape)

        if isPlanted then
            splitShape(shape, x, y + 0.2, z, 0, 1, 0, 0, 0, 0, 4, 4, "deleteCutSplitShapeCallback", EasyDevControlsUtils)
        else
            delete(shape)
        end

        g_treePlantManager:removingSplitShape(shape)
        -- g_treePlantManager:cleanupDeletedTrees()

        if setAreaDirty then
            g_densityMapHeightManager:setCollisionMapAreaDirty(x - 10, z - 10, x + 10, z + 10, true)
            g_currentMission.aiSystem:setAreaDirty(x - 10, x + 10, z - 10, z + 10)
        end
    end
end

function EasyDevControlsUtils.deleteCutSplitShapeCallback(unused, shape, isBelow, isAbove, minY, maxY, minZ, maxZ)
    if shape ~= nil then
        delete(shape)
    end
end

function EasyDevControlsUtils.getMaxLogLength(name)
    if name ~= nil then
        return EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH[name:upper()] or 1
    end

    return 1
end

function EasyDevControlsUtils.getBaleWrapColours(colourIndex)
    return g_easyDevControlsColours, math.min(colourIndex or 5, #g_easyDevControlsColours)
end

function EasyDevControlsUtils.getBaleObjectsFromObjectStorages()
    local baleObjects, numBaleObjects = {}, 0

    if g_currentMission ~= nil and g_currentMission.placeableSystem ~= nil then
        for _, placeable in ipairs(g_currentMission.placeableSystem.placeables) do
            if placeable.spec_objectStorage ~= nil and placeable.spec_objectStorage.supportsBales then
                for _, abstractObject in ipairs(placeable.spec_objectStorage.storedObjects) do
                    if abstractObject.baleObject ~= nil then
                        baleObjects[abstractObject.baleObject] = placeable
                        numBaleObjects += 1
                    end
                end
            end
        end
    end

    return baleObjects, numBaleObjects
end

function EasyDevControlsUtils.getPalletConfigurations(xmlFilename)
    if xmlFilename == "data/objects/pallets/treeSaplingPallet02/treeSaplingPallet02.xml" then
        if EasyDevControlsUtils.treeSaplingPalletConfigurations == nil and g_treePlantManager ~= nil then
            local xmlFile = XMLFile.loadIfExists("edc_pallet", xmlFilename, Vehicle.xmlSchema)

            if xmlFile ~= nil then
                if xmlFile:getValue("vehicle.treeSaplingPallet.treeSaplingTypeConfigurations.treeSaplingTypeConfiguration(0)#useMapTreeTypes", false) then
                    local treeSaplingType = 0

                    for _, treeType in ipairs(g_treePlantManager.treeTypes) do
                        if #treeType.stages > 1 and treeType.supportsPlanting then
                            treeSaplingType += 1

                            if treeType.name == "PINUSSYLVESTRIS" then
                                EasyDevControlsUtils.treeSaplingPalletConfigurations = {
                                    treeSaplingType = treeSaplingType
                                }

                                break
                            end
                        end
                    end
                end

                xmlFile:delete()
            end
        end

        return EasyDevControlsUtils.treeSaplingPalletConfigurations
    end

    return nil
end

function EasyDevControlsUtils.clearFile(file, protectedCall)
    if not string.isNilOrWhitespace(file) and fileExists(file) then
        if protectedCall then
            local success, response = pcall(function()
                io.open(file, "w"):close()
            end)

            return success, response
        end

        io.open(file, "w"):close()
    end
end

function EasyDevControlsUtils.clearGameLogFile()
    local logFileBackup = currentModSettingsDirectory .. "backupLog.txt"
    local logFile = getUserProfileAppPath() .. "log.txt"

    if not folderExists(currentModSettingsDirectory) then
        createFolder(currentModSettingsDirectory)
    end

    local success, response = pcall(function()
        io.open(logFileBackup, "w"):close()
        setFileLogName(logFileBackup)

        io.open(logFile, "w"):close()
        setFileLogName(logFile)

        if fileExists(logFileBackup) then
            deleteFile(logFileBackup)
        end
    end)

    return success, response
end

function EasyDevControlsUtils.doRestart(clearLogFile, restartProcess, args)
    if clearLogFile then
        if I3DManager.clearEntireSharedI3DFileCache ~= nil then
            local oldClearEntireSharedI3DFileCache = I3DManager.clearEntireSharedI3DFileCache

            function I3DManager.clearEntireSharedI3DFileCache(self, ...)
                oldClearEntireSharedI3DFileCache(self, ...)

                EasyDevControlsUtils.clearGameLogFile()
                EasyDevControlsLogging.info("Clearing log file and exiting to main menu...")

                I3DManager.clearEntireSharedI3DFileCache = oldClearEntireSharedI3DFileCache
            end
        else
            EasyDevControlsUtils.clearGameLogFile()
        end
    end

    if (restartProcess or g_currentMission == nil) or OnInGameMenuMenu == nil then
        RestartManager:setStartScreen(RestartManager.START_SCREEN_MAIN)
        doRestart(true, args or "")
    else
        OnInGameMenuMenu()
    end
end

function EasyDevControlsUtils.copyFile(copyFrom, copyTo, overwrite)
    if string.isNilOrWhitespace(copyFrom) or string.isNilOrWhitespace(copyTo) or not fileExists(copyFrom) then
        return ""
    end

    local path = EasyDevControlsUtils.getSettingsDirectory(false)
    local filename = path .. copyTo

    if not overwrite and fileExists(filename) then
        return filename
    end

    createFolder(path)

    local splitPath = copyTo:split("/")
    local numPaths = #splitPath

    for i = 1, numPaths - 1 do
        path = path .. splitPath[i] .. "/"
        createFolder(path)
    end

    copyFile(copyFrom, filename, overwrite)

    return filename
end

function EasyDevControlsUtils.createFolder(subDirectory)
    if subDirectory ~= nil then
        if subDirectory:sub(-1) ~= "/" then
            subDirectory = subDirectory .. "/"
        end

        createFolder(modSettingsDirectory .. subDirectory)

        return modSettingsDirectory .. subDirectory
    end

    createFolder(modSettingsDirectory)

    return modSettingsDirectory
end

function EasyDevControlsUtils.setEventActiveInContext(contextName, actionName, isActive, forceRefresh)
    if actionName == nil or isActive == nil then
        if actionName ~= nil then
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event state in context %s but no 'actionName' provided!", contextName or "UNKNOWN")
        else
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event state in context %s but no 'isActive' provided!", contextName or "UNKNOWN")
        end

        return
    end

    local inputBinding = g_inputBinding
    local hasChange = false

    local context = inputBinding.contexts[contextName]

    if context ~= nil and context.actionEvents ~= nil then
        local action = inputBinding.nameActions[actionName]
        local actionEvents = context.actionEvents[action]

        if actionEvents ~= nil then
            for _, event in ipairs(actionEvents) do
                hasChange = event.isActive ~= isActive
                event.isActive = isActive
            end
        end
    end

    if forceRefresh or hasChange then
        inputBinding:refreshEventCollections()
    end
end

function EasyDevControlsUtils.setEventActiveInAllContexts(actionName, isActive, forceRefresh, contexts)
    if actionName == nil or isActive == nil then
        if actionName ~= nil then
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event state but no 'actionName' provided!")
        else
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event state but no 'isActive' provided!")
        end

        return
    end

    local inputBinding = g_inputBinding
    local hasChange = false

    for contextName, _ in pairs (contexts or inputBinding.contexts) do
        local context = inputBinding.contexts[contextName]

        if context ~= nil and context.actionEvents ~= nil then
            local action = inputBinding.nameActions[actionName]
            local actionEvents = context.actionEvents[action]

            if actionEvents ~= nil then
                for _, event in ipairs(actionEvents) do
                    hasChange = event.isActive ~= isActive
                    event.isActive = isActive
                end
            end
        end
    end

    if forceRefresh or hasChange then
        inputBinding:refreshEventCollections()
    end
end

function EasyDevControlsUtils.setEventTextVisibilityInAllContexts(actionName, displayIsVisible, forceRefresh, contexts)
    if actionName == nil or displayIsVisible == nil then
        if actionName ~= nil then
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event visibility but no 'actionName' provided!")
        else
            EasyDevControlsLogging.devWarning("[EasyDevControlsUtils] Trying to set action event visibility but not 'displayIsVisible' provided!")
        end

        return
    end

    local inputBinding = g_inputBinding
    local hasChange = false

    for contextName, _ in pairs (contexts or inputBinding.contexts) do
        local context = inputBinding.contexts[contextName]

        if context ~= nil and context.actionEvents ~= nil then
            local action = inputBinding.nameActions[actionName]
            local actionEvents = context.actionEvents[action]

            if actionEvents ~= nil then
                for _, event in ipairs(actionEvents) do
                    hasChange = event.displayIsVisible ~= displayIsVisible
                    event.displayIsVisible = displayIsVisible
                end
            end
        end
    end

    if forceRefresh or hasChange then
        inputBinding:refreshEventCollections()
    end
end

--[[function EasyDevControlsUtils.getIsTextNumeric(text, allowNegative)
    if allowNegative then
        return string.match(text, "^[+-]?[0-9]+$")
    end

    return string.match(text, "^[0-9]+$")
end]]

function EasyDevControlsUtils.getValidAccessLevel(accessLevel, maximumAccessLevel, backup)
    if accessLevel == nil then
        return backup
    end

    return math.clamp(accessLevel, 1, math.clamp(maximumAccessLevel or accessLevel, 1, 5))
end

function EasyDevControlsUtils.getNumBits(value)
    local numBits = 1

    if value ~= nil and value > 1 then
        for _ = 1, 31 do
            if value <= 2 ^ numBits - 1 then
                break
            end

            numBits += 1
        end
    end

    return numBits
end

-- Debugging
function EasyDevControlsUtils.getToDoTexts()
    return {
        -- ['easyDevControls_refreshSaleSystemTitle'] = "Refresh Vehicle Sales", -- General
        -- ['easyDevControls_refreshSaleSystemInfo'] = "%s vehicles are now available on sale.", -- General
        -- ['easyDevControls_refreshSaleSystemHelp'] = "Clears existing vehicle sales and generates new ones.", -- General
    }
end

function EasyDevControlsUtils.validate()
    if g_easyDevControlsDevelopmentMode then
        local validateText = ""

        -- Check EasyDevControlsErrorCodes mapping matches
        local numIds = #EasyDevControlsErrorCodes.getAllOrdered()
        local numTexts = EasyDevControlsErrorCodes.getNumTexts()

        if numIds ~= numTexts then
            validateText = string.format("%s/n    Enum 'EasyDevControlsErrorCodes' contains %d entries and there is %d l10n mapping entries!", validateText, numIds, numTexts)
        end

        -- Check EasyDevControlsObjectTypes mapping matches
        numIds = #EasyDevControlsObjectTypes.getAllOrdered()
        numTexts = EasyDevControlsObjectTypes.getNumTexts()

        if numIds ~= numTexts then
            validateText = string.format("%s/n    Enum 'EasyDevControlsObjectTypes' contains %d entries and there is %d l10n mapping entries!", validateText, numIds, numTexts)
        end

        if validateText == "" then
            print(string.format("  DevInfo: [Easy Development Controls] Validation successful."))
        else
            printError(string.format("  DevError: [Easy Development Controls] The following validation errors were found:/n%s", validateText))
        end
    end
end

function EasyDevControlsUtils.wrapFunctions(showWarnings, wrapGameFunctions)
    if not g_easyDevControlsDevelopmentMode then
        return
    end

    EasyDevControlsUtils.unwrapFunctions()

    wrappedFunctions = {}

    local textsToTranlate = EasyDevControlsUtils.getToDoTexts()

    if wrapGameFunctions then
        EasyDevControlsUtils.unwrapGameFunctions()
        EasyDevControlsUtils.wrapGameFunctions(showWarnings)
    else
        wrappedFunctions.getText = EasyDevControlsUtils.getText

        function EasyDevControlsUtils.getText(name)
            if textsToTranlate[name] ~= nil then
                if not g_i18n:hasText(name, modName) then
                    if showWarnings then
                        EasyDevControlsLogging.devWarning("Text with name %s has no valid translation!", name)
                    end

                    return textsToTranlate[name]
                else
                    EasyDevControlsLogging.devWarning("Text with name '%s' is marked as TO_DO but a translation exists.", name)
                end
            end

            return wrappedFunctions.getText(name)
        end
    end

    wrappedFunctions.convertText = EasyDevControlsUtils.convertText

    function EasyDevControlsUtils.convertText(text)
        if text == nil then
            EasyDevControlsLogging.warning("No text given to convert!")
            printCallstack()

            return ""
        end

        if string.startsWith(text, "$l10n_") then
            text = text:sub(7)

            if textsToTranlate[text] ~= nil then
                if not g_i18n:hasText(text, modName) then
                    if showWarnings then
                        EasyDevControlsLogging.devWarning("Text with name %s has no valid translation!", text)
                    end

                    return textsToTranlate[text]
                else
                    EasyDevControlsLogging.devWarning("Text with name '%s' is marked as TO_DO but a translation exists.", text)
                end
            end

            return g_i18n:getText(text, modName)
        end

        return text
    end

    wrappedFunctions.formatText = EasyDevControlsUtils.formatText

    function EasyDevControlsUtils.formatText(name, ...)
        if textsToTranlate[name] ~= nil then
            if not g_i18n:hasText(name, modName) then
                if showWarnings then
                    EasyDevControlsLogging.devWarning("Text with name %s has no valid translation!", name)
                end

                return string.format(textsToTranlate[name], ...)
            else
                EasyDevControlsLogging.devWarning("Text with name '%s' is marked as TO_DO but a translation exists.", name)
            end
        end

        return wrappedFunctions.formatText(name, ...)
    end

    wrappedFunctions.namedFormatText = EasyDevControlsUtils.namedFormatText

    function EasyDevControlsUtils.namedFormatText(name, ...)
        if textsToTranlate[name] ~= nil then
            if not g_i18n:hasText(name, modName) then
                if showWarnings then
                    EasyDevControlsLogging.devWarning("Text with name %s has no valid translation!", name)
                end

                return string.namedFormat(textsToTranlate[name], ...)
            else
                EasyDevControlsLogging.devWarning("Text with name '%s' is marked as TO_DO but a translation exists.", name)
            end
        end

        return wrappedFunctions.namedFormatText(name, ...)
    end
end

function EasyDevControlsUtils.unwrapFunctions()
    if not g_easyDevControlsDevelopmentMode then
        return
    end

    if wrappedFunctions ~= nil then
        for name, func in pairs (wrappedFunctions) do
            EasyDevControlsUtils[name] = func
        end
    end

    wrappedFunctions = nil
end

function EasyDevControlsUtils.wrapGameFunctions(showWarnings)
    if not g_easyDevControlsDevelopmentMode then
        return
    end

    EasyDevControlsUtils.unwrapGameFunctions(name)

    wrappedGameFunctions = {}

    local textsToTranlate = EasyDevControlsUtils.getToDoTexts()

    -- Useful for GUI
    local wrappedFunc = I18N.getText
    wrappedGameFunctions["I18N.getText"] = wrappedFunc

    function I18N.getText(self, name, customEnv)
        if customEnv == modName then
            if textsToTranlate[name] ~= nil then
                if not self:hasText(name, modName) then
                    if showWarnings then
                        EasyDevControlsLogging.devWarning("Text with name %s has no valid translation!", name)
                    end

                    return textsToTranlate[name]
                else
                    EasyDevControlsLogging.devWarning("Text with name '%s' is marked as TO_DO but a translation exists.", name)
                end
            end
        end

        return wrappedFunc(self, name, customEnv)
    end
end

function EasyDevControlsUtils.unwrapGameFunctions()
    if not g_easyDevControlsDevelopmentMode then
        return
    end

    if wrappedGameFunctions ~= nil then
        for name, func in pairs (wrappedGameFunctions) do
            local splitName = name:split(".")
            _G[splitName[1]][splitName[2]] = func
        end
    end

    wrappedGameFunctions = nil
end

function EasyDevControlsUtils.devInfo(message, ...)
    if g_easyDevControlsDevelopmentMode then
        EasyDevControlsLogging.devCallstackError("'EasyDevControlsUtils.devInfo' is depreciated, use 'EasyDevControlsLogging.devInfo' instead!")
    end
end
