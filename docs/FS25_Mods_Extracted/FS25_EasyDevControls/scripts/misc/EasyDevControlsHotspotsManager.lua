--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-02

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

EasyDevControlsHotspotsManager = {}

EasyDevControlsHotspotsManager.DEFAULT_COLOURS = {
    BALE = {1, 0.1, 0.01},
    PALLET = {0.1, 1, 0.01}
}

EasyDevControlsHotspotsManager.COLOUR_BLIND_COLOURS = {
    BALE = {0.2541, 0.0065, 0.5089},
    PALLET = {0.0227, 0.5346, 0.8519}
}

EasyDevControlsHotspotsManager.VALID_TYPE_IDS = {
    true,
    true
}

EasyDevControlsHotspotsManager.MIN_HEIGHT = -200  -- Under map, delete it
EasyDevControlsHotspotsManager.UPDATE_INTERVAL = 500

EasyDevControlsHotspotsManager.VALID_TYPE_NAMES = {
    ["pallet"] = true,
    ["treeSaplingPallet"] = true,
    ["bigBag"] = true
}

local EasyDevControlsHotspotsManager_mt = Class(EasyDevControlsHotspotsManager)

function EasyDevControlsHotspotsManager.new()
    local self = setmetatable({}, EasyDevControlsHotspotsManager_mt)

    self.baleToHotspot = {}
    self.palletToHotspot = {}

    self.updateBales = false
    self.updatePallets = false

    self.updateInterval = 0
    self.useColorBlindMode = false

    if g_dedicatedServer == nil then
        g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.onPlayerFarmChanged, self)

        local gameSettingUseColorBlindMode = GameSettings.SETTING.USE_COLORBLIND_MODE

        if gameSettingUseColorBlindMode ~= nil then
            self.useColorBlindMode = g_gameSettings:getValue(gameSettingUseColorBlindMode)
            g_messageCenter:subscribe(MessageType.SETTING_CHANGED[gameSettingUseColorBlindMode], self.onColourBlindModeChanged, self)
        end
    end

    return self
end

function EasyDevControlsHotspotsManager:delete()
    g_messageCenter:unsubscribeAll(self)

    self.baleToHotspot = {}
    self.palletToHotspot = {}

    self.updateBales = false
    self.updatePallets = false
end

function EasyDevControlsHotspotsManager:setCurrentMission(mission)
    self.mission = mission
    self.vehicleSystem = mission.vehicleSystem
    self.itemSystem = mission.itemSystem
    self.accessHandler = mission.accessHandler
end

function EasyDevControlsHotspotsManager:onPlayerFarmChanged(player)
    if player == g_localPlayer then
        self.farmId = player.farmId or FarmManager.SPECTATOR_FARM_ID

        if self.updateBales or self.updatePallets then
            self:destroyHotspots(EasyDevControlsObjectTypes.BALE, true)
            self:destroyHotspots(EasyDevControlsObjectTypes.PALLET, true)

            if self.farmId ~= FarmManager.SPECTATOR_FARM_ID then
                if self.updateBales then
                    self:setActive(EasyDevControlsObjectTypes.BALE, true)
                end

                if self.updatePallets then
                    self:setActive(EasyDevControlsObjectTypes.PALLET, true)
                end
            else
                g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "showObjectLocations", EasyDevControlsGeneralFrame.NAME)
            end
        end
    end
end

function EasyDevControlsHotspotsManager:onColourBlindModeChanged(useColorBlindMode)
    if useColorBlindMode ~= self.useColorBlindMode then
        self.useColorBlindMode = useColorBlindMode

        local r, g, b = self:getColour(true)

        for _, hotspot in pairs (self.baleToHotspot) do
            hotspot:setColor(r, g, b)
        end

        r, g, b = self:getColour(false)

        for _, hotspot in pairs (self.palletToHotspot) do
            hotspot:setColor(r, g, b)
        end
    end
end

function EasyDevControlsHotspotsManager:setActive(typeId, active)
    if g_dedicatedServer ~= nil then
        return false, "None"
    end

    local active = Utils.getNoNil(active, false)
    local typeText = ""

    if self.mission == nil or self.vehicleSystem == nil or self.itemSystem == nil or self.accessHandler == nil then
        self:setCurrentMission(g_currentMission)
    end

    if self.farmId == nil then
        self:onPlayerFarmChanged(g_localPlayer)
    end

    if typeId == EasyDevControlsObjectTypes.BALE then
        self.updateBales = active
        typeText = EasyDevControlsUtils.getText("easyDevControls_typeBale")
    elseif typeId == EasyDevControlsObjectTypes.PALLET then
        self.updatePallets = active
        typeText = EasyDevControlsUtils.getText("easyDevControls_typePallet")
    end

    if not active then
        self:destroyHotspots(typeId)
    end

    if not self.updateBales and not self.updatePallets then
        self.mission:removeUpdateable(self)
    else
        self.mission:addUpdateable(self)
    end

    self.updateInterval = 0

    return active, typeText
end

function EasyDevControlsHotspotsManager:createBaleHotspot(bale)
    local hotspot = EasyDevControlsObjectHotspot.new(bale.nodeId, true)

    bale:addDeleteListener(self, "onDeleteBale")
    self.mission:addMapHotspot(hotspot)

    self.baleToHotspot[bale] = hotspot
end

function EasyDevControlsHotspotsManager:createPalletHotspot(pallet)
    local hotspot = EasyDevControlsObjectHotspot.new(pallet.rootNode, false)

    pallet:addDeleteListener(self, "onDeletePallet")
    self.mission:addMapHotspot(hotspot)

    self.palletToHotspot[pallet] = hotspot
end

function EasyDevControlsHotspotsManager:destroyHotspots(typeId, farmChange)
    self.mission:removeUpdateable(self)

    if typeId == EasyDevControlsObjectTypes.BALE then
        for bale, hotspot in pairs (self.baleToHotspot) do
            bale:removeDeleteListener(self, "onDeleteBale")

            self.mission:removeMapHotspot(hotspot)
            hotspot:delete()
        end

        self.baleToHotspot = {}
        self.updateBales = false
    elseif typeId == EasyDevControlsObjectTypes.PALLET then
        for pallet, hotspot in pairs (self.palletToHotspot) do
            pallet:removeDeleteListener(self, "onDeletePallet")

            self.mission:removeMapHotspot(hotspot)
            hotspot:delete()
        end

        self.palletToHotspot = {}
        self.updatePallets = false
    end

    if (farmChange == nil or farmChange == false) and (self.updateBales or self.updatePallets) then
        self.mission:addUpdateable(self)
    end
end

function EasyDevControlsHotspotsManager:onDeleteBale(bale)
    local hotspot = self.baleToHotspot[bale]

    if hotspot ~= nil then
        self.baleToHotspot[bale] = nil

        self.mission:removeMapHotspot(hotspot)
        hotspot:delete()
    end
end

function EasyDevControlsHotspotsManager:onDeletePallet(pallet)
    local hotspot = self.palletToHotspot[pallet]

    if hotspot ~= nil then
        self.palletToHotspot[pallet] = nil

        self.mission:removeMapHotspot(hotspot)
        hotspot:delete()
    end
end

function EasyDevControlsHotspotsManager:update(dt)
    if self.farmId == FarmManager.SPECTATOR_FARM_ID then
        return
    end

    self.updateInterval -= dt

    if self.updateInterval <= 0 then
        local numObjects = 0

        if self.updateBales then
            for object, _ in pairs (self.itemSystem.itemsToSave) do
                -- Could be part of an Object Storage (Fermenting) so ignore.
                -- if object.getNeedsSaving == nil or object:getNeedsSaving() then
                if object.nodeId ~= nil and getVisibility(object.nodeId) then
                    if self.baleToHotspot[object] ~= nil then
                        local x, y, z = getWorldTranslation(object.nodeId)

                        if y > EasyDevControlsHotspotsManager.MIN_HEIGHT then
                            self.baleToHotspot[object]:setWorldPosition(x, z)
                            numObjects += 1
                        else
                            object:delete()
                        end
                    elseif object.isa ~= nil and object:isa(Bale) and self.accessHandler:canFarmAccessOtherId(self.farmId, object:getOwnerFarmId()) then
                        self:createBaleHotspot(object)
                    end
                elseif self.baleToHotspot[object] ~= nil then
                    self:onDeleteBale(object)
                end
            end
        end

        if self.updatePallets then
            for _, vehicle in ipairs (self.vehicleSystem.vehicles) do
                if self.palletToHotspot[vehicle] ~= nil then
                    local x, y, z = getWorldTranslation(vehicle.rootNode)

                    if y > EasyDevControlsHotspotsManager.MIN_HEIGHT then
                        self.palletToHotspot[vehicle]:setWorldPosition(x, z)
                        numObjects += 1
                    else
                        vehicle:delete()
                    end
                elseif vehicle.isa ~= nil and vehicle:isa(Vehicle) and (vehicle.isPallet or EasyDevControlsHotspotsManager.VALID_TYPE_NAMES[vehicle.typeName]) then
                    if self.accessHandler:canFarmAccessOtherId(self.farmId, vehicle:getOwnerFarmId()) then
                        self:createPalletHotspot(vehicle)
                    end
                end
            end
        end

        self.updateInterval = numObjects < 500 and 0 or EasyDevControlsHotspotsManager.UPDATE_INTERVAL
    end
end

function EasyDevControlsHotspotsManager:getColour(isBale)
    local COLOURS = EasyDevControlsHotspotsManager.DEFAULT_COLOURS

    if self.useColorBlindMode then
        COLOURS = EasyDevControlsHotspotsManager.COLOUR_BLIND_COLOURS
    end

    if isBale then
        return COLOURS.BALE[1], COLOURS.BALE[2], COLOURS.BALE[3]
    end

    return COLOURS.PALLET[1], COLOURS.PALLET[2], COLOURS.PALLET[3]
end


EasyDevControlsObjectHotspot = {}
local EasyDevControlsObjectHotspot_mt = Class(EasyDevControlsObjectHotspot, MapHotspot)

function EasyDevControlsObjectHotspot.new(rootNode, isBale)
    local self = MapHotspot.new(EasyDevControlsObjectHotspot_mt)

    local x, y, z = 0, 0, 0
    local r, g, b = 1, 0, 1

    self.width, self.height = getNormalizedScreenValues(40, 40)
    self.icon = g_overlayManager:createOverlay("mapHotspots.other", 0, 0, self.width, self.height)

    if g_easyDevControlsHotspotsManager ~= nil then
        r, g, b = g_easyDevControlsHotspotsManager:getColour(isBale)
    end

    self:setColor(r or 1, g or 1, b or 1)

    if rootNode ~= nil then
        x, y, z = getWorldTranslation(rootNode)
    end

    self:setWorldPosition(x, z)
    self:setVisible(true)

    return self
end

function EasyDevControlsObjectHotspot:getCategory()
    return MapHotspot.CATEGORY_OTHER
end
