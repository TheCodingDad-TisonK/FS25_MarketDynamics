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

EasyDevControlsTeleportScreen = {}
EasyDevControlsTeleportScreen.INPUT_CONTEXT_NAME = "EDC_TELEPORT_SCREEN"

local EasyDevControlsTeleportScreen_mt = Class(EasyDevControlsTeleportScreen, ScreenElement)

function EasyDevControlsTeleportScreen.register()
    local controller = EasyDevControlsTeleportScreen.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/dialogs/EasyDevControlsTeleportScreen.xml")

    g_gui:loadGui(filename, "EasyDevControlsTeleportScreen", controller)

    return controller
end

function EasyDevControlsTeleportScreen.new()
    local self = ScreenElement.new(nil, EasyDevControlsTeleportScreen_mt)

    self.isCloseAllowed = true
    self.isBackAllowed = true

    self.inputDelay = 250
    self.sendingCallback = false

    self.isPickingLocation = true
    self.isPickingRotation = false

    self.lastInputHelpMode = 0
    self.ingameMapBase = nil

    self.lastMousePosX = 0
    self.lastMousePosY = 0

    self.rotationOrigin = {0, 0}
    self.teleportHotspot = AITargetHotspot.new()

    self.mapHotspotFilter = {
        [MapHotspot.CATEGORY_FIELD] = true,
        [MapHotspot.CATEGORY_MISSION] = true,
        [MapHotspot.CATEGORY_STEERABLE] = true,
        [MapHotspot.CATEGORY_COMBINE] = true,
        [MapHotspot.CATEGORY_TRAILER] = true,
        [MapHotspot.CATEGORY_TOOL] = true,
        [MapHotspot.CATEGORY_OTHER] = true,
        [MapHotspot.CATEGORY_AI] = true,
        [MapHotspot.CATEGORY_PLAYER] = true
    }

    return self
end

function EasyDevControlsTeleportScreen:onGuiSetupFinished()
    EasyDevControlsTeleportScreen:superClass().onGuiSetupFinished(self)

    self.zoomText = g_i18n:getText("ui_ingameMenuMapZoom")
    self.moveCursorText = g_i18n:getText("ui_ingameMenuMapMoveCursor")
    self.panMapText = g_i18n:getText("ui_ingameMenuMapPan")

    self.setLocationText = g_i18n:getText("ui_ai_pickTargetLocation")
    self.setRotationText = g_i18n:getText("ui_ai_pickTargetRotation")

    self.buttonBackText = g_i18n:getText("button_back")
    self.buttonCancelText = g_i18n:getText("button_cancel")
end

function EasyDevControlsTeleportScreen:delete()
    -- g_messageCenter:unsubscribeAll(self)

    if self.teleportHotspot ~= nil then
        self.teleportHotspot:delete()
        self.teleportHotspot = nil
    end

    EasyDevControlsTeleportScreen:superClass().delete(self)
end

function EasyDevControlsTeleportScreen:onOpen()
    EasyDevControlsTeleportScreen:superClass().onOpen(self)

    self.inputDelay = self.time + 250

    self.isPickingLocation = true
    self.isPickingRotation = false
    self.sendingCallback = false

    self:setInGameMapData(g_currentMission) -- Backup
    self:toggleMapInput(true)

    if self.teleportHotspot == nil then
        self.teleportHotspot = AITargetHotspot.new()
    end

    local ingameMap = self.ingameMap

    ingameMap:onOpen()
    ingameMap:registerActionEvents()
    ingameMap:setHotspotSelectionActive(false) -- Not required
    ingameMap:setIsCursorAvailable(false) -- Not required
    ingameMap:unlockMapMovement()

    local player = g_localPlayer

    if player ~= nil then
        local x, _, z = player:getPosition()
        ingameMap:setCenterToWorldPosition(x, z)
    end

    -- Copy current Filter States and set the required filters so map is not covered in hotspots
    if self.ingameMapBase ~= nil then
        self.mapHotspotFilterStates = {}

        local showHotspot = false
        local currentTargetCategory = nil
        local currentMapTargetHotspot = g_currentMission.currentMapTargetHotspot

        if currentMapTargetHotspot and currentMapTargetHotspot.getCategory ~= nil then
            currentTargetCategory = currentMapTargetHotspot:getCategory()
        end

        for category, state in pairs(self.ingameMapBase.filter) do
            showHotspot = self.mapHotspotFilter[category] == true

            -- If the hotspot is tagged then show category regardless of default setting
            if currentTargetCategory == category then
                showHotspot = true
            end

            self.mapHotspotFilterStates[category] = state
            self.ingameMapBase:setHotspotFilter(category, showHotspot)
        end
    end

    self:updateInputGlyphs()

    self.actionMessage:setText(self.setLocationText)
    self.buttonBack:setText(self.buttonBackText)

    g_currentMission:addMapHotspot(self.teleportHotspot)
    self:updateMapHotspotPosition()
end

function EasyDevControlsTeleportScreen:onClose()
    self.ingameMap:onClose()
    self:toggleMapInput(false)
    self:resetAllValues(true)

    EasyDevControlsTeleportScreen:superClass().onClose(self)
end

function EasyDevControlsTeleportScreen:toggleMapInput(isActive)
    if self.isInputContextActive ~= isActive then
        self.isInputContextActive = isActive

        self:toggleCustomInputContext(isActive, EasyDevControlsTeleportScreen.INPUT_CONTEXT_NAME)

        if isActive then
            g_inputBinding:removeActionEventsByActionName(InputAction.MENU_EXTRA_2)
        end
    end
end

function EasyDevControlsTeleportScreen:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    self.lastMousePosX = posX
    self.lastMousePoxY = posY

    if self.isPickingLocation then
        local localX, localY = self.ingameMap:getLocalPosition(posX, posY)

        self:setTeleportHotspotPosition(localX, localY)
    elseif self.isPickingRotation then
        if self.teleportHotspot ~= nil then
            local localX, localY = self.ingameMap:getLocalPosition(posX, posY)
            local worldX, worldZ = self.ingameMap:localToWorldPos(localX, localY)
            local angle = EasyDevControlsUtils.getValidAngle(math.atan2(worldX - self.rotationOrigin[1], worldZ - self.rotationOrigin[2]) + math.pi)

            self.teleportHotspot:setWorldRotation(angle)
        end
    end

    return EasyDevControlsTeleportScreen:superClass().mouseEvent(self, posX, posY, isDown, isUp, button, eventUsed)
end

function EasyDevControlsTeleportScreen:update(dt)
    EasyDevControlsTeleportScreen:superClass().update(self, dt)

    local currentInputHelpMode = g_inputBinding:getInputHelpMode()

    if currentInputHelpMode ~= self.lastInputHelpMode then
        self.lastInputHelpMode = currentInputHelpMode

        local showCursor = currentInputHelpMode ~= GS_INPUT_HELP_MODE_GAMEPAD

        g_inputBinding:setShowMouseCursor(showCursor)
        self.buttonSelect:setVisible(not showCursor)

        self:updateInputGlyphs()
    end

    if currentInputHelpMode == GS_INPUT_HELP_MODE_GAMEPAD then
        local localX, localY = self.ingameMap:getLocalPointerTarget()

        if self.isPickingLocation then
            self:setTeleportHotspotPosition(localX, localY)
        elseif self.isPickingRotation then
            if self.teleportHotspot ~= nil then
                local worldX, worldZ = self.ingameMap:localToWorldPos(localX, localY)
                local angle = EasyDevControlsUtils.getValidAngle(math.atan2(worldX - self.rotationOrigin[1], worldZ - self.rotationOrigin[2]) + math.pi)

                self.teleportHotspot:setWorldRotation(angle)
            end
        end
    end
end

function EasyDevControlsTeleportScreen:onClickMap(element, worldX, worldZ)
    if self.inputDelay < self.time then
        if self.isPickingLocation then
            self.isPickingLocation = false

            self.rotationOrigin = {
                worldX,
                worldZ
            }

            self.teleportHotspot:setWorldPosition(worldX, worldZ)

            self.buttonBack:setText(self.buttonCancelText)
            self.actionMessage:setText(self.setRotationText)

            self.isPickingRotation = true

            self.ingameMap:lockMapMovement()
        elseif self.isPickingRotation then
            local ingameMapBase = self.ingameMapBase

            if ingameMapBase ~= nil then
                local x, z = self.teleportHotspot:getWorldPosition()
                local normalizedPosX = EasyDevControlsUtils.getNoNilClamp((x + ingameMapBase.worldCenterOffsetX) / ingameMapBase.worldSizeX, 0, 1, x)
                local normalizedPosZ = EasyDevControlsUtils.getNoNilClamp((z + ingameMapBase.worldCenterOffsetZ) / ingameMapBase.worldSizeZ, 0, 1, z)

                local posX, posZ = normalizedPosX * ingameMapBase.worldSizeX, normalizedPosZ * ingameMapBase.worldSizeZ
                local angle = EasyDevControlsUtils.getValidAngle(math.atan2(worldX - self.rotationOrigin[1], worldZ - self.rotationOrigin[2]))

                self:sendCallback(posX, posZ, angle)
            else
                self:sendCallback(nil, nil, nil)
            end
        end
    end
end

function EasyDevControlsTeleportScreen:onClickBack(forceBack, usedMenuButton)
    local eventUnused = true

    if self.sendingCallback or self.isPickingLocation then
        eventUnused = EasyDevControlsTeleportScreen:superClass().onClickBack(self, forceBack, usedMenuButton)
    end

    self:resetAllValues()

    return eventUnused
end

function EasyDevControlsTeleportScreen:onDrawPostIngameMapHotspots()
    if self.teleportHotspot ~= nil and self.actionMessage ~= nil then
        local x, y, _ = self.teleportHotspot:getLastScreenPosition()
        local width, height = self.teleportHotspot:getDimension()

        self.actionMessage:setAbsolutePosition(x + width * 0.5, y + height * 0.5)
    end
end

function EasyDevControlsTeleportScreen:sendCallback(posX, posZ, angle)
    if self.callbackFunction ~= nil then
        if self.callbackTarget ~= nil then
            self.callbackFunction(self.callbackTarget, self.teleportObject, posX, posZ, angle)
        else
            self.callbackFunction(self.teleportObject, posX, posZ, angle)
        end
    end

    self.sendingCallback = true
    self:onClickBack(true, false)
end

function EasyDevControlsTeleportScreen:updateInputGlyphs()
    local moveActions, moveText = nil

    if self.lastInputHelpMode == GS_INPUT_HELP_MODE_GAMEPAD then
        moveText = self.moveCursorText
        moveActions = {
            InputAction.AXIS_MAP_SCROLL_LEFT_RIGHT,
            InputAction.AXIS_MAP_SCROLL_UP_DOWN
        }
    else
        moveText = self.panMapText
        moveActions = {
            InputAction.AXIS_LOOK_LEFTRIGHT_DRAG,
            InputAction.AXIS_LOOK_UPDOWN_DRAG
        }
    end

    self.mapMoveGlyph:setActions(moveActions, nil, nil, true)
    self.mapMoveGlyphText:setText(moveText)

    self.mapZoomGlyph:setActions({InputAction.AXIS_MAP_ZOOM_IN, InputAction.AXIS_MAP_ZOOM_OUT}, nil, nil, false)
    self.mapZoomGlyphText:setText(self.zoomText)
end

function EasyDevControlsTeleportScreen:updateMapHotspotPosition()
    local localX, localY = 0.5, 0.5

    if g_inputBinding:getInputHelpMode() ~= GS_INPUT_HELP_MODE_GAMEPAD then
        local posX, posY = g_lastMousePosX, g_lastMousePosY

        if posX == nil or posY == nil then
            posX, posY = g_inputBinding:getMousePosition()
        end

        localX, localY = self.ingameMap:getLocalPosition(posX, posY)
    else
        localX, localY = self.ingameMap:getLocalPointerTarget()
    end

    self:setTeleportHotspotPosition(localX, localY)
end

function EasyDevControlsTeleportScreen:resetAllValues(forceReset)
    if self.sendingCallback or forceReset then
        g_currentMission:removeMapHotspot(self.teleportHotspot)

        -- Restore the Filter States
        if self.mapHotspotFilterStates ~= nil then
            local ingameMapBase = self.ingameMapBase

            if ingameMapBase ~= nil then
                for category, state in pairs(self.mapHotspotFilterStates) do
                    ingameMapBase:setHotspotFilter(category, state)
                end
            end

            self.mapHotspotFilterStates = nil
        end
    else
        self:updateMapHotspotPosition()
    end

    self.buttonBack:setText(self.buttonBackText)
    self.actionMessage:setText(self.setLocationText)

    self.ingameMap:unlockMapMovement()
    self.ingameMap.mapZoom = self.ingameMap.zoomDefault

    self.isPickingLocation = true
    self.isPickingRotation = false
    self.sendingCallback = false
end

function EasyDevControlsTeleportScreen:setTeleportHotspotPosition(localX, localY)
    if self.teleportHotspot ~= nil then
        local worldX, worldZ = self.ingameMap:localToWorldPos(localX, localY)
        self.teleportHotspot:setWorldPosition(worldX, worldZ)
    end
end

function EasyDevControlsTeleportScreen:setCallback(callbackFunction, callbackTarget, teleportObject)
    self.callbackFunction = callbackFunction
    self.callbackTarget = callbackTarget
    self.teleportObject = teleportObject
end

function EasyDevControlsTeleportScreen:setInGameMap(ingameMap)
    self.ingameMapBase = ingameMap
    self.ingameMap:setIngameMap(ingameMap)
end

function EasyDevControlsTeleportScreen:setTerrainSize(terrainSize)
    self.ingameMap:setTerrainSize(terrainSize)
end

function EasyDevControlsTeleportScreen:setInGameMapData(currentMission)
    if currentMission ~= nil then
        if self.ingameMap.ingameMap == nil or self.ingameMapBase == nil then
            self:setInGameMap(currentMission.hud:getIngameMap())

            EasyDevControlsLogging.devInfo("[EasyDevControlsTeleportScreen] InGameMap data missing, trying to set it now.")
        end

        if (self.ingameMap.terrainSize or 0) <= 0 then
            self:setTerrainSize(currentMission.terrainSize)

            EasyDevControlsLogging.devInfo("[EasyDevControlsTeleportScreen] Invalid terrain size, trying to set it now.")
        end
    end
end
