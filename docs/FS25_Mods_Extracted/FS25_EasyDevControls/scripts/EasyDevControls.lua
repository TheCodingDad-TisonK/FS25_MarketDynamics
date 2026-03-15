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

EasyDevControls = {}

local EasyDevControls_mt = Class(EasyDevControls)

-- Using locals so I have a consistent base game value if another mod has copied my ideas :-)
local edc_timeScaleCustomSettings = {0, 0.5, 1, 2, 3, 4, 5, 6, 10, 15, 30, 60, 120, 240, 360, 500, 2000, 5000, 10000, 20000, 40000, 60000}
local edc_timeScaleBaseGameSettings = {0.5, 1, 2, 3, 5, 6, 10, 15, 30, 60, 120, 240, 360}

local calculateDesiredHorizontalVelocityBackup = nil
local function calculateDesiredHorizontalVelocity(stateMachine, directionX, directionZ)
    local mover = stateMachine.player.mover

    if mover.currentSpeed > (PlayerStateWalk.MAXIMUM_WALK_SPEED + 0.5) then
        local speed = mover:calculateSmoothSpeed(stateMachine.player.inputComponent.walkAxis, false, 0, mover.currentSpeed)

        return directionX * speed, directionZ * speed
    end

    return calculateDesiredHorizontalVelocityBackup(stateMachine, directionX, directionZ)
end

function EasyDevControls.new(isServer, isClient, buildId, versionString, releaseType, consoleCommandsGtX)
    local self = setmetatable({}, EasyDevControls_mt)

    self.isServer = isServer
    self.isClient = isClient

    self.buildId = buildId
    self.versionString = versionString
    self.releaseType = releaseType
    self.addExtraConsoleCommands = consoleCommandsGtX

    self.isMasterUser = self.isServer
    self.isMultiplayer = false
    self.gameStarted = false

    self.numUpdateRequests = 0
    self.updateableRemoveTimer = 0

    self.hudVisibilityKeyEnabled = false
    self.deleteObjectsKeyEnabled = false
    self.superStrengthKeyEnabled = false
    self.runSpeedKeyEnabled = false

    self.customTimeScalesEnabled = false
    self.superStrengthEnabled = false
    self.runSpeedEnabled = false
    self.playerNoClipEnabled = false

    self:setTexts()

    g_messageCenter:subscribe(MessageType.EDC_PERMISSIONS_CHANGED, self.onPermissionsChanged, self)
    g_messageCenter:subscribe(MessageType.EDC_ACCESS_LEVEL_CHANGED, self.onAccessLevelChanged, self)

    -- g_messageCenter:subscribe(MessageType.OWN_PLAYER_ENTERED, self.onPlayerEntered, self)
    g_messageCenter:subscribe(MessageType.OWN_PLAYER_LEFT, self.onPlayerLeft, self)
    g_messageCenter:subscribe(MessageType.PLAYER_CREATED, self.onPlayerCreated, self)

    -- if self.isServer then
        -- g_messageCenter:subscribe(MessageType.ON_CLIENT_START_MISSION, self.onClientStartMission, self)
    -- end

    return self
end

function EasyDevControls:load(mission)
    if g_dedicatedServer == nil then
        addConsoleCommand("gtxClearLog", "Clears the game log file. (For mod testing use only!)", "consoleCommandClearLogFile", self)

        if self.isServer then
            addConsoleCommand("gtxSave", "Saves the current game.", "consoleCommandSaveGame", self, "savegameName[optional]")
        end

        -- Advanced versions are already included in my debugger so ignore these.
        if self.debugger == nil then
            addConsoleCommand("gtxQuit", "Clears the game log file and restarts game to the main menu. (For mod testing use only!)", "consoleCommandQuitGame", self, "restartProcess[default=false];arguments[optional]")
        end
            addConsoleCommand("gtxPrint", "Prints the given path information.", "consoleCommandPrintEnvironment", self, "path; ...")

        addConsoleCommand("gtxPrintScenegraph", "Prints the complete map or trees only scenegraph to the log.", "consoleCommandPrintScenegraph", self, "nodeName[default=rootNode (optional: rootNode or trees)];visibleOnly[default=false];clearLog[default=true]")

        if self.addExtraConsoleCommands then
            addConsoleCommand("gtxEasyDevControlsCreateSettingsTemplate", "Creates a default user settings XML template using current settings.", "consoleCommandCreateSettingsTemplate", self, "savePermissions")
        end
    else
        self.addExtraConsoleCommands = false
    end
end

function EasyDevControls:delete(mission)
    -- Make sure the original is restored
    if calculateDesiredHorizontalVelocityBackup ~= nil then
        PlayerStateJump.calculateDesiredHorizontalVelocity = calculateDesiredHorizontalVelocityBackup
        calculateDesiredHorizontalVelocityBackup = nil
    end

    if g_dedicatedServer == nil then
        removeConsoleCommand("gtxClearLog")

        if self.isServer then
            removeConsoleCommand("gtxSave")
        end

        removeConsoleCommand("gtxQuit")
        removeConsoleCommand("gtxPrint")
        removeConsoleCommand("gtxPrintScenegraph")

        if self.addExtraConsoleCommands then
            removeConsoleCommand("gtxEasyDevControlsCreateSettingsTemplate")
        end
    end
end

function EasyDevControls:update(dt)
    if self.isServer and self.loadTreeTrunkDatas ~= nil then
        if not self.addingTreeToCut then
            local x, z = self.lastDirtyTreeAreaX, self.lastDirtyTreeAreaZ

            if x ~= nil and z ~= nil then
                g_densityMapHeightManager:setCollisionMapAreaDirty(x - 4, z - 4, x + 4, z + 4, true)
                g_currentMission.aiSystem:setAreaDirty(x - 4, x + 4, z - 4, z + 4)
            end

            local loadTreeTrunkData = self.loadTreeTrunkDatas[1]

            if loadTreeTrunkData ~= nil then
                self.lastDirtyTreeAreaX = loadTreeTrunkData.x
                self.lastDirtyTreeAreaZ = loadTreeTrunkData.z

                table.insert(g_treePlantManager.loadTreeTrunkDatas, loadTreeTrunkData)
                table.remove(self.loadTreeTrunkDatas, 1)
            end

            if not self.addingTreeToCut and #self.loadTreeTrunkDatas == 0 then
                x, z = self.lastDirtyTreeAreaX, self.lastDirtyTreeAreaZ

                if x ~= nil and z ~= nil then
                    g_densityMapHeightManager:setCollisionMapAreaDirty(x - 4, z - 4, x + 4, z + 4, true)
                    g_currentMission.aiSystem:setAreaDirty(x - 4, x + 4, z - 4, z + 4)
                end

                self.lastDirtyTreeAreaX = nil
                self.lastDirtyTreeAreaZ = nil
                self.loadTreeTrunkDatas = nil

                self.numUpdateRequests = 0
            end
        end
    end

    if self.numUpdateRequests <= 0 then
        self.updateableRemoveTimer += dt

        if self.updateableRemoveTimer >= 4000 then
            self.updateableRemoveTimer = 0
            g_currentMission:removeUpdateable(self)
        end
    else
        self.updateableRemoveTimer = 0
    end
end

function EasyDevControls:onSetMissionInfo(missionInfo, missionDynamicInfo, missionBaseDirectory)
    self.missionInfo = missionInfo
    self.missionDynamicInfo = missionDynamicInfo

    -- for _, mod in ipairs (missionDynamicInfo.mods) do

    -- end

    self.isMultiplayer = missionDynamicInfo.isMultiplayer or g_easyDevControlsSimulateMultiplayer
    self.connectedToDedicatedServer = g_currentMission.connectedToDedicatedServer
end

function EasyDevControls:onMissionStarted(isNewSavegame)
    self.gameStarted = true
end

function EasyDevControls:onSendInitialClientState(connection, user, farm)
    local suppressInfo = true

    if g_easyDevControlsDevelopmentMode then
        suppressInfo = false

        print(string.format("  DevInfo: [Easy Development Controls] Syncing permissions and settings with user %s.", user ~= nil and user:getNickname() or "Unknown"))
    end

    -- Sync all permissions (Excluding those that are SP only for obvious reasons)
    connection:sendEvent(EasyDevControlsPermissionsEvent.new(self.guiManager:getPermissions(true), suppressInfo))

    -- Sync 'Extra Time Scale' state
    connection:sendEvent(EasyDevControlsTimeScaleEvent.new(Utils.getNoNil(self.customTimeScalesEnabled, false), false))

    -- Sync 'Super Strength' state
    if Utils.getNoNil(self.superStrengthEnabled, false) then
        self:setSuperStrengthEnabled(true, nil) -- Should not require awaiter at this point
        connection:sendEvent(EasyDevControlsSuperStrengthEvent.newServerToClient(EasyDevControlsErrorCodes.NONE, true, nil, true))
    end
end

function EasyDevControls:onPlayerHUDUpdateFinished(hudUpdater, dt, x, y, z, yaw, player)
    if self.deleteObjectsKeyEnabled and self.eventIdObjectDelete ~= nil then
        local eventIdObjectDeleteState, actionEventText, targetedObjectType, targetedObject = false, "", nil, nil

        if (hudUpdater.object ~= nil or hudUpdater.splitShape ~= nil) and (player ~= nil and not player:getIsHoldingHandTool() and not player:getAreHandsHoldingObject()) then
            if hudUpdater.isVehicle then
                if hudUpdater.object.trainSystem == nil then
                    eventIdObjectDeleteState = true
                    actionEventText = self.texts.deleteObject:format(hudUpdater.object:getName())

                    targetedObjectType = EasyDevControlsObjectTypes.VEHICLE
                    targetedObject = hudUpdater.object
                end
            elseif hudUpdater.isBale then
                eventIdObjectDeleteState = true
                actionEventText = self.texts.deleteBale

                targetedObjectType = EasyDevControlsObjectTypes.BALE
                targetedObject = hudUpdater.object
            elseif hudUpdater.isPallet then
                eventIdObjectDeleteState = true
                actionEventText = self.texts.deletePallet

                targetedObjectType = EasyDevControlsObjectTypes.PALLET
                targetedObject = hudUpdater.object
            elseif hudUpdater.isSplitShape then
                local splitShape = hudUpdater.splitShape

                if entityExists(splitShape) and getHasClassId(splitShape, ClassIds.MESH_SPLIT_SHAPE) then
                    local splitTypeId = getSplitType(splitShape)

                    if splitTypeId ~= 0 then
                        if getIsSplitShapeSplit(splitShape) then
                            if getRigidBodyType(splitShape) ~= RigidBodyType.STATIC then
                                eventIdObjectDeleteState = true
                                actionEventText = self.texts.deleteLog

                                targetedObjectType = EasyDevControlsObjectTypes.LOG
                            elseif getName(splitShape) == "splitGeom" then
                                eventIdObjectDeleteState = true
                                actionEventText = self.texts.deleteStump

                                targetedObjectType = EasyDevControlsObjectTypes.STUMP
                            end
                        else
                            eventIdObjectDeleteState = true
                            actionEventText = self.texts.deleteTree

                            targetedObjectType = EasyDevControlsObjectTypes.TREE
                        end

                        targetedObject = hudUpdater.splitShape
                    end
                end
            end
        end

        self.targetedObjectType = targetedObjectType
        self.targetedObject = targetedObject

        if self.eventIdObjectDeleteState ~= eventIdObjectDeleteState then
            self.eventIdObjectDeleteState = eventIdObjectDeleteState

            g_inputBinding:setActionEventTextVisibility(self.eventIdObjectDelete, eventIdObjectDeleteState)
            g_inputBinding:setActionEventActive(self.eventIdObjectDelete, eventIdObjectDeleteState)
        end

        if eventIdObjectDeleteState then
            g_inputBinding:setActionEventText(self.eventIdObjectDelete, actionEventText)
        end
    end
end

function EasyDevControls:onSuperStrengthToggled(hands, hasSuperStrength)
    if self.isServer then
        if hasSuperStrength ~= self.superStrengthEnabled then
            self.superStrengthEnabled = hasSuperStrength
            self.settings:setValue("superStrength", hasSuperStrength)

            g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "superStrength", EasyDevControlsPlayerFrame.NAME)
        end
    end
end

function EasyDevControls:onAccessLevelChanged(accessLevel)
    self.isMasterUser = self.guiManager:getIsMasterUser()
    self:onPermissionsChanged()
end

function EasyDevControls:onPermissionsChanged()
    if self.deleteObjectsKeyEnabled and not self:getHasPermission("deleteObjectsKey") then
        self:setDeleteObjectsInputEnabled(false)
    end
end

function EasyDevControls:onClientStartMission(user)
    if self.isServer and user ~= nil and user.id ~= g_currentMission:getServerUserId() then

    end
end

function EasyDevControls:onPlayerCreated(player)
    if player == g_localPlayer then
        if player.toggleFlightModeCommand ~= nil then
            player.toggleFlightModeCommand.onEnabled:registerListener(function()
                if not self.updatingFlightMode then
                    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "flightMode", EasyDevControlsPlayerFrame.NAME)
                end
            end)

            player.toggleFlightModeCommand.onDisabled:registerListener(function()
                if not self.updatingFlightMode then
                    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "flightMode", EasyDevControlsPlayerFrame.NAME)
                end
            end)
        end

        if player.toggleSuperSpeedCommand ~= nil then
            player.toggleSuperSpeedCommand.onEnabled:registerListener(function()
                self:setRunSpeedState(false)

                g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "runSpeedState", EasyDevControlsPlayerFrame.NAME)
            end)
        end

        if not self:getIsMultiplayer() and player.toggleNoClipCommand ~= nil then
            player.toggleNoClipCommand.onEnabled:registerListener(function(disableTerrainCollision)
                self.playerNoClipEnabled = true

                if not self.updatingPlayerNoClip then
                    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "playerNoClip", EasyDevControlsPlayerFrame.NAME)
                end
            end)

            player.toggleNoClipCommand.onDisabled:registerListener(function()
                self.playerNoClipEnabled = false

                if not self.updatingPlayerNoClip then
                    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "playerNoClip", EasyDevControlsPlayerFrame.NAME)
                end
            end)
        end
    -- elseif self.isServer then
        -- if Utils.getNoNil(self.superStrengthEnabled, false) then
            -- self:setSuperStrengthEnabled(true, nil)
        -- end
    end
end

function EasyDevControls:onPlayerEntered()
end

function EasyDevControls:onPlayerLeft()
    if self.deleteObjectsKeyEnabled then
        if self.eventIdObjectDelete ~= nil then
            g_inputBinding:setActionEventTextVisibility(self.eventIdObjectDelete, false)
            g_inputBinding:setActionEventActive(self.eventIdObjectDelete, false)
        end

        self.eventIdObjectDeleteState = nil
        self.targetedObjectType = nil
        self.targetedObject = nil
    end
end

-- Cheat Money (Add | Remove | Set)
function EasyDevControls:cheatMoney(amount, typeId, farmId)
    if amount == nil or typeId == nil then
        return EasyDevControlsUtils.formatText("easyDevControls_invalidMoneyWarning", "nil"), EasyDevControlsErrorCodes.FAILED
    end

    if not EasyDevControlsUtils.getIsValidFarmId(farmId) then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM
    end

    if self.isServer then
        local farm = g_farmManager:getFarmById(farmId)

        if farm == nil then
            return EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM
        end

        local l10n = "easyDevControls_addMoneyInfo"
        local value = amount

        if typeId == EasyDevControlsMoneyEvent.TYPES.REMOVEMONEY then
            amount = -amount
            l10n = "easyDevControls_removeMoneyInfo"
        elseif typeId == EasyDevControlsMoneyEvent.TYPES.SETMONEY then
            amount -= farm:getBalance()
            l10n = "easyDevControls_setMoneyInfo"
        end

        farm:changeBalance(amount, MoneyType.OTHER)
        g_currentMission:addMoneyChange(amount, farmId, MoneyType.OTHER, true)

        return EasyDevControlsUtils.formatText(l10n, g_i18n:formatMoney(value, 0, true, true)), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsMoneyEvent, amount, typeId)
    end
end

-- Extra Time Scales
function EasyDevControls:setCustomTimeScaleState(enabled, noStateChanged)
    enabled = Utils.getNoNil(enabled, false)

    self.customTimeScalesEnabled = enabled
    self.settings:setValue("extraTimeScales", enabled)

    if enabled then
        Platform.gameplay.timeScaleSettings = edc_timeScaleCustomSettings
    else
        Platform.gameplay.timeScaleSettings = edc_timeScaleBaseGameSettings
    end

    if self.isServer then
        g_server:broadcastEvent(EasyDevControlsTimeScaleEvent.new(enabled, false), false)

        local currentMission = g_currentMission

        if currentMission ~= nil and currentMission.missionInfo ~= nil then
            local timeScaleIndex = Utils.getTimeScaleIndex(currentMission.missionInfo.timeScale or 1)
            local timeScale = Utils.getTimeScaleFromIndex(timeScaleIndex or (enabled and 3 or 2))

            if timeScale ~= nil then
                currentMission:setTimeScale(timeScale)
            end
        end
    end

    if self.gameStarted then
        self:onSetCustomTimeScaleState(noStateChanged)
    end
end

function EasyDevControls:onSetCustomTimeScaleState(noStateChanged)
    if g_dedicatedServer ~= nil then
        return
    end

    if g_inGameMenu ~= nil then
        local pageSettings = g_inGameMenu.pageSettings

        if pageSettings ~= nil and pageSettings.assignTimeScaleTexts ~= nil then
            pageSettings:assignTimeScaleTexts()
        end
    end

    if noStateChanged == nil or noStateChanged == false then
        g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "extraTimeScales", EasyDevControlsGeneralFrame.NAME)
    end
end

function EasyDevControls.getCustomTimeScaleParams()
    local baseGameTimeScales = {}
    local customTimeScales = {}

    for i, timeScale in ipairs (edc_timeScaleBaseGameSettings) do
        baseGameTimeScales[timeScale] = i
    end

    for _, timeScale in ipairs (edc_timeScaleCustomSettings) do
        if baseGameTimeScales[timeScale] == nil then
            table.insert(customTimeScales, timeScale)
        end
    end

    table.sort(customTimeScales)

    local str = ""
    local numCustomTimeScales = #customTimeScales

    for i = 1, numCustomTimeScales do
        str = str .. tostring(customTimeScales[i]) .. "x"

        if i < numCustomTimeScales then
            str = str .. ", "
        end
    end

    return str
end

-- Hud Key
function EasyDevControls:setToggleHudInputEnabled(enabled)
    enabled = Utils.getNoNil(enabled, false)

    self.hudVisibilityKeyEnabled = enabled
    self.settings:setValue("hudVisibilityKey", enabled)

    EasyDevControlsUtils.setEventActiveInAllContexts(InputAction.EDC_TOGGLE_HUD, enabled, true)

    return enabled
end

-- Delete Objects Key
function EasyDevControls:setDeleteObjectsInputEnabled(enabled)
    enabled = Utils.getNoNil(enabled, false) and self:getHasPermission("deleteObjectsKey")

    self.deleteObjectsKeyEnabled = enabled
    self.settings:setValue("deleteObjectsKey", enabled)

    self.eventIdObjectDeleteState = nil
    self.targetedObjectType = nil
    self.targetedObject = nil

    if self.eventIdObjectDelete ~= nil and g_localPlayer ~= nil and g_localPlayer.isControlled then
        g_inputBinding:setActionEventTextVisibility(self.eventIdObjectDelete, false)
        g_inputBinding:setActionEventActive(self.eventIdObjectDelete, false)
    end

    return enabled
end

-- Show Bale Locations
function EasyDevControls:showBaleLocations(enabled)
    local showLocations, typeText = g_easyDevControlsHotspotsManager:setActive(EasyDevControlsObjectTypes.BALE, enabled)

    self.settings:setValue("showBaleLocations", showLocations)

    return EasyDevControlsUtils.formatText(showLocations and "easyDevControls_hotspotsEnabledInfo" or "easyDevControls_hotspotsDisabledInfo", typeText)
end

-- Show Pallet Locations
function EasyDevControls:showPalletLocations(enabled)
    local showLocations, typeText = g_easyDevControlsHotspotsManager:setActive(EasyDevControlsObjectTypes.PALLET, enabled)

    self.settings:setValue("showPalletLocations", showLocations)

    return EasyDevControlsUtils.formatText(showLocations and "easyDevControls_hotspotsEnabledInfo" or "easyDevControls_hotspotsDisabledInfo", typeText)
end

-- Teleport Player or Vehicle
function EasyDevControls:teleport(object, positionX, positionZ, rotationY, useWorldCoords)
    if object == nil or positionX == nil then
        EasyDevControlsLogging.devInfo("Teleport failed no object or (field/farmland id or x/z coordinates) given!")

        return nil, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local currentMission = g_currentMission

        local fieldId = positionX
        local isField = positionZ == nil

        local mapPosX = math.floor(positionX + 0.5)
        local mapPosZ = not isField and math.floor(positionZ + 0.5) or 0

        -- If there is no positionZ then check if it is a farmland
        if isField then
            local farmland = g_farmlandManager:getFarmlandById(positionX)

            if farmland ~= nil then
                positionX, positionZ = farmland:getTeleportPosition()
            else
                EasyDevControlsLogging.devInfo("Teleport failed, no z coordinate given and '%s' is not a valid field/farmland id!", positionX)

                return nil, EasyDevControlsErrorCodes.FAILED
            end
        else
            useWorldCoords = Utils.getNoNil(useWorldCoords, false)

            if not useWorldCoords then
                local terrainSize = currentMission.terrainSize
                local halfTerrainSize = terrainSize * 0.5

                positionX = math.clamp(positionX, 0, terrainSize, halfTerrainSize) - halfTerrainSize
                positionZ = math.clamp(positionZ, 0, terrainSize, halfTerrainSize) - halfTerrainSize
            end
        end

        if object:isa(Player) then
            local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, positionX, 0, positionZ) -- 1.2

            object:teleportTo(positionX, terrainHeight + 0.1, positionZ)

            if rotationY ~= nil and object == g_localPlayer then
                object:setMovementYaw(rotationY)
            end

            if isField then
                local message = EasyDevControlsUtils.formatText("easyDevControls_teleportPlayerFieldInfo", tostring(fieldId))

                return message, EasyDevControlsErrorCodes.SUCCESS, false, 0, rotationY
            end

            local mapPosZStr = tostring(mapPosZ)

            if useWorldCoords then
                mapPosZStr = mapPosZStr .. " (3D / World)" -- TO_DO: Translate??
            end

            local message = EasyDevControlsUtils.formatText("easyDevControls_teleportPlayerInfo", tostring(mapPosX), mapPosZStr)

            return message, EasyDevControlsErrorCodes.SUCCESS, false, 0, rotationY
        end

        if object:isa(Vehicle) then
            -- Vehicles are detached and removed from physics by 'EasyDevControlsUtils.getVehiclesPositionData'when 'isTeleporting == true'.
            currentMission.isTeleporting = true

            local rootVehicle = object:findRootVehicle() or object
            local vehicles, attachedVehicles = EasyDevControlsUtils.getVehiclesPositionData(rootVehicle, object, currentMission.isTeleporting)
            local numVehicles = #vehicles

            -- Move all vehicles
            for _, vehicleData in ipairs (vehicles) do
                local vehicle = vehicleData.vehicle
                local x, y, z = positionX, 0.5, positionZ
                local _, ry, _ = getWorldRotation(vehicle.rootNode)

                if vehicleData.isImplement and vehicleData.offset ~= nil then
                    x, y, z = localToWorld(rootVehicle.rootNode, unpack(vehicleData.offset))
                end

                vehicle:setRelativePosition(x, 0.5, z, rotationY or ry, true)
                vehicle:addToPhysics()
            end

            -- Attach implements to the root vehicle
            for _, attachedVehicle in ipairs (attachedVehicles) do
                attachedVehicle.vehicle:attachImplement(attachedVehicle.object, attachedVehicle.inputAttacherJointDescIndex, attachedVehicle.jointDescIndex, true, nil, nil, false)
            end

            currentMission.isTeleporting = false

            if isField then
                local message = EasyDevControlsUtils.formatText("easyDevControls_teleportVehiclesFieldInfo", tostring(numVehicles), tostring(fieldId))

                return message, EasyDevControlsErrorCodes.SUCCESS, false, numVehicles, nil
            end

            mapPosZStr = tostring(mapPosZ)

            if useWorldCoords then
                mapPosZStr = mapPosZStr .. " (3D / World)" -- TO_DO: Translate??
            end

            local message = EasyDevControlsUtils.formatText("easyDevControls_teleportVehiclesInfo", tostring(numVehicles), tostring(mapPosX), mapPosZStr)

            return message, EasyDevControlsErrorCodes.SUCCESS, true, numVehicles, nil
        end

        return nil, EasyDevControlsErrorCodes.UNKNOWN_FAIL
    else
        return self:clientSendEvent(EasyDevControlsTeleportEvent, object, positionX, positionZ, rotationY, Utils.getNoNil(useWorldCoords, false))
    end
end

-- Super Strength
function EasyDevControls:setSuperStrengthState(active)
    active = Utils.getNoNil(active, false)

    if self.isServer then
        local userId = g_localPlayer.userId

        g_server:broadcastEvent(EasyDevControlsSuperStrengthEvent.newServerToClient(EasyDevControlsErrorCodes.NONE, active, userId, false))

        return self:setSuperStrengthEnabled(active, userId)
    else
        return self:clientSendEvent(EasyDevControlsSuperStrengthEvent, active, nil, false)
    end
end

function EasyDevControls:setSuperStrengthEnabled(superStrengthEnabled, userId)
    if g_currentMission == nil or g_currentMission.playerSystem == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    local infoText = "easyDevControls_superStrengthOffInfo"
    local currentMaximumMass = HandToolHands.MAXIMUM_PICKUP_MASS or 0.2
    local pickupDistance = HandToolHands.PICKUP_DISTANCE or 2

    if superStrengthEnabled then
        infoText = "easyDevControls_superStrengthOnInfo"
        currentMaximumMass = 1000
        pickupDistance = 10
    end

    self.settings:setValue("superStrength", superStrengthEnabled)
    self.superStrengthEnabled = superStrengthEnabled

    local dedicatedServerUserId = nil

    if g_dedicatedServer ~= nil then
        dedicatedServerUserId = g_currentMission:getServerUserId()
    end

    for _, player in pairs(g_currentMission.playerSystem.players) do
        if dedicatedServerUserId == nil or dedicatedServerUserId ~= player.userId then
            if not EasyDevControls.setPlayerSuperStrengthState(player, superStrengthEnabled, currentMaximumMass, pickupDistance) then
                EasyDevControlsAwaiter.new(function()
                    return player.hands ~= nil
                end,
                function(errorCode)
                    if errorCode == EasyDevControlsErrorCodes.SUCCESS then
                        if EasyDevControls.setPlayerSuperStrengthState(player, superStrengthEnabled, currentMaximumMass, pickupDistance) then
                            EasyDevControlsLogging.devInfo("Hands loaded, super strength values updated for player %s.", player:getNickname())
                        end
                    else
                        EasyDevControlsLogging.devError("Failed to set super strength for player %s. Reason: Awaiter ran too long.", player:getNickname())
                    end
                end)

                EasyDevControlsLogging.devInfo("Awaiting hands for player %s to update super strength values.", player:getNickname())
            end
        end
    end

    if self.isMultiplayer and userId ~= nil and userId ~= g_localPlayer.userId then
        if self.gameStarted then
            g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "superStrength", EasyDevControlsPlayerFrame.NAME)
        end

        local user = g_currentMission.userManager:getUserByUserId(userId)
        local nickname = user ~= nil and user:getNickname() or ""

        if nickname ~= "" then
            local message = EasyDevControlsUtils.formatText(superStrengthEnabled and "easyDevControls_superStrengthOnMessage" or "easyDevControls_superStrengthOffMessage", nickname)

            if g_dedicatedServer == nil then
                g_currentMission:addIngameNotification(superStrengthEnabled and FSBaseMission.INGAME_NOTIFICATION_OK or FSBaseMission.INGAME_NOTIFICATION_INFO, message)
            else
                return message, EasyDevControlsErrorCodes.SUCCESS
            end
        end
    elseif g_dedicatedServer == nil and not self.settings.loadingStartGameValues then
        local message = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_superStrengthTitle"), EasyDevControlsUtils.getText(superStrengthEnabled and "easyDevControls_enabled" or "easyDevControls_disabled"))
        g_currentMission.hud:addSideNotification(superStrengthEnabled and FSBaseMission.INGAME_NOTIFICATION_OK or FSBaseMission.INGAME_NOTIFICATION_INFO, message, 1500)
    end

    return EasyDevControlsUtils.getText(infoText), EasyDevControlsErrorCodes.SUCCESS
end

function EasyDevControls.setPlayerSuperStrengthState(player, hasSuperStrength, currentMaximumMass, pickupDistance)
    if player ~= nil and player.hands ~= nil then
        local spec = player.hands.spec_hands

        spec.hasSuperStrength = hasSuperStrength
        spec.currentMaximumMass = currentMaximumMass
        spec.pickupDistance = pickupDistance

        if player.isOwner and player.targeter ~= nil then
            player.targeter:removeTargetType(HandToolHands)
            player.targeter:addTargetType(HandToolHands, HandToolHands.TARGET_MASK, 0.5, pickupDistance)
        end

        return true
    end

    return false
end

-- Super Strength Key
function EasyDevControls:setSuperStrengthInputEnabled(enabled)
    enabled = Utils.getNoNil(enabled, false)

    self.superStrengthKeyEnabled = enabled
    self.settings:setValue("superStrengthKey", enabled)

    EasyDevControlsUtils.setEventActiveInAllContexts(InputAction.EDC_SUPER_STRENGTH, enabled, true)

    return enabled
end

-- Player Jump Height
function EasyDevControls:setPlayerJumpMultiplier(index)
    index = self.settings:setValue("jumpHeightIndex", math.clamp(index or 1, 1, #EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS))
    PlayerStateJump.JUMP_UPFORCE = EasyDevControlsPlayerFrame.getJumpUpForce(index)

    return index
end

-- Player Jump Delay
function EasyDevControls:setPlayerJumpDelay(index)
    index = self.settings:setValue("jumpDelayIndex", math.clamp(index or 1, 1, #EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS))
    PlayerStateJump.MINIMUM_GROUND_TIME_THRESHOLD = EasyDevControlsPlayerFrame.getMinimumGroundTimeThreshold(index)

    return index
end

-- Running Speed
function EasyDevControls:setRunSpeedMultiplier(index, noUpdate)
    index = self.settings:setValue("runSpeedIndex", math.clamp(index or 1, 1, #EasyDevControlsPlayerFrame.RUN_SPEED_MULTIPLIERS))

    if not noUpdate then
        self:updateRunSpeed()
    end

    return index
end

function EasyDevControls:setRunSpeedState(enabled, noUpdate)
    enabled = self.settings:setValue("runSpeedState", Utils.getNoNil(enabled, false))

    self.runSpeedEnabled = enabled

    if not noUpdate then
        self:updateRunSpeed()
    end

    return enabled
end

function EasyDevControls:updateRunSpeed()
    -- Restore the original function
    if calculateDesiredHorizontalVelocityBackup ~= nil then
        PlayerStateJump.calculateDesiredHorizontalVelocity = calculateDesiredHorizontalVelocityBackup
        calculateDesiredHorizontalVelocityBackup = nil
    end

    if self.settings:getValue("runSpeedState", false) then
        local multiplier = EasyDevControlsPlayerFrame.getRunSpeedMultiplier(self.settings:getValue("runSpeedIndex", 1))

        if self.gameStarted then
            local toggleSuperSpeedCommand = g_localPlayer.toggleSuperSpeedCommand

            if toggleSuperSpeedCommand ~= nil and toggleSuperSpeedCommand.value then
                toggleSuperSpeedCommand:disableValue()
            end
        end

        -- Add temp function to only apply the jump move speed when running
        calculateDesiredHorizontalVelocityBackup = PlayerStateJump.calculateDesiredHorizontalVelocity
        PlayerStateJump.calculateDesiredHorizontalVelocity = calculateDesiredHorizontalVelocity

        -- PlayerStateJump.MAXIMUM_MOVE_SPEED = 7 * multiplier
        PlayerStateJump.MAXIMUM_MOVE_SPEED = 3
        PlayerStateWalk.MAXIMUM_RUN_SPEED = 7 * multiplier
        PlayerStateSwim.MAXIMUM_SPRINT_SPEED = 5 * multiplier
        PlayerMover.ACCELERATION = 16 * multiplier
        PlayerMover.DECELERATION = 10 * multiplier

        return true
    end

    PlayerStateJump.MAXIMUM_MOVE_SPEED = 3
    PlayerStateWalk.MAXIMUM_RUN_SPEED = 7
    PlayerStateSwim.MAXIMUM_SPRINT_SPEED = 5
    PlayerMover.ACCELERATION = 16
    PlayerMover.DECELERATION = 10

    return false
end

function EasyDevControls:setRunSpeedInputEnabled(active)
    enabled = Utils.getNoNil(active, false)

    self.runSpeedKeyEnabled = enabled
    self.settings:setValue("runSpeedKey", enabled)

    EasyDevControlsUtils.setEventActiveInAllContexts(InputAction.EDC_PLAYER_RUN_SPEED, enabled, true)

    return enabled
end

-- Add Bale
function EasyDevControls:spawnBale(baleIndex, fillTypeIndex, wrappingState, farmId, x, y, z, ry, fillLevel, wrapDiffuse, wrappingColor)
    if baleIndex == nil or x == nil or y == nil or z == nil or ry == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if g_baleManager.bales[baleIndex] == nil or g_fillTypeManager:getFillTypeByIndex(fillTypeIndex) == nil then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFillTypeWarning"), EasyDevControlsErrorCodes.FAILED
    end

    wrappingState = EasyDevControlsUtils.getNoNilClamp(wrappingState, 0, 1, 1)

    if not EasyDevControlsUtils.getIsValidFarmId(farmId) then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM
    end

    if self.isServer then
        local xmlFilename = g_baleManager.bales[baleIndex].xmlFilename
        local bale = Bale.new(self.isServer, self.isClient)

        if bale:loadFromConfigXML(xmlFilename, x, y, z, 0, ry, 0) then
            local setFillLevel = fillLevel ~= nil

            bale:setFillType(fillTypeIndex, not setFillLevel)

            if setFillLevel then
                bale:setFillLevel(fillLevel)
            end

            bale:setWrappingState(wrappingState)

            if wrappingState > 0 then
                if wrapDiffuse ~= nil then
                    bale:setWrapTextures(wrapDiffuse)
                end

                if wrappingColor ~= nil and #wrappingColor >= 3 then
                    bale:setColor(wrappingColor[1], wrappingColor[2], wrappingColor[3], 1)
                elseif fillTypeIndex == FillType.SILAGE then
                    bale:setColor(1, 0.1413, 0, 1) -- FI_ORANGE
                elseif fillTypeIndex == FillType.GRASS_WINDROW then
                    bale:setColor(0, 0.2051, 0.0685, 1) -- FI_GREEN
                else
                    bale:setColor(0.6662, 0.3839, 0.5481, 1) -- PINK
                end
            end

            bale:setOwnerFarmId(farmId, true)
            bale:register()

            return EasyDevControlsUtils.formatText("easyDevControls_spawnObjectsInfo", EasyDevControlsUtils.getText("easyDevControls_typeBale")), EasyDevControlsErrorCodes.SUCCESS
        end

        if bale.delete ~= nil then
            bale:delete()
        end

        return EasyDevControlsUtils.formatText("easyDevControls_failedToSpawnObjectWarning", EasyDevControlsUtils.getText("easyDevControls_typeBale")), EasyDevControlsErrorCodes.FAILED
    else
        local params = {
            baleIndex = baleIndex,
            fillTypeIndex = fillTypeIndex,
            wrappingState = wrappingState,
            wrappingColor = wrappingColor,
            x = x,
            y = y,
            z = z,
            ry = ry
        }

        return self:clientSendEvent(EasyDevControlsSpawnObjectEvent, EasyDevControlsObjectTypes.BALE, params)
    end
end

-- Add Pallet
function EasyDevControls:spawnPallet(fillTypeIndex, xmlFilename, farmId, x, y, z, ry, amountToAdd, guiFrame, connection)
    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

    if fillType == nil then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFillTypeWarning"), EasyDevControlsErrorCodes.FAILED
    end

    if x == nil or y == nil or z == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    xmlFilename = xmlFilename or fillType.palletFilename

    if xmlFilename == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if not EasyDevControlsUtils.getIsValidFarmId(farmId) then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM
    end

    if self.isServer then
        if amountToAdd == nil then
            amountToAdd = math.huge
        elseif amountToAdd < 0 then
            amountToAdd = 0
        end

        local function asyncCallbackFunction(_, vehicles, vehicleLoadState, arguments)
            if vehicleLoadState == VehicleLoadingState.OK then
                local vehicle = vehicles[1]
                local addedAmount = 0

                vehicle:emptyAllFillUnits(true)

                if amountToAdd > 0 then
                    for _, fillUnit in ipairs(vehicle:getFillUnits()) do
                        if vehicle:getFillUnitSupportsFillType(fillUnit.fillUnitIndex, fillTypeIndex) then
                            addedAmount += vehicle:addFillUnitFillLevel(1, fillUnit.fillUnitIndex, amountToAdd, fillTypeIndex, ToolType.UNDEFINED, nil)
                            amountToAdd -= addedAmount

                            if amountToAdd <= 0 then
                                break
                            end
                        end
                    end
                end

                if guiFrame ~= nil and guiFrame.isOpen then
                    if guiFrame.setInfoText ~= nil then
                        guiFrame:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_spawnObjectsInfo", EasyDevControlsUtils.getText("easyDevControls_typePallet")), EasyDevControlsErrorCodes.SUCCESS)
                    end
                elseif connection ~= nil then
                    EasyDevControlsLogging.dedicatedServerInfo(EasyDevControlsUtils.formatText("easyDevControls_spawnObjectsInfo", EasyDevControlsUtils.getText("easyDevControls_typePallet")))
                    connection:sendEvent(EasyDevControlsSpawnObjectEvent.newServerToClient(EasyDevControlsErrorCodes.SUCCESS, EasyDevControlsObjectTypes.PALLET))
                end

                return
            end

            if guiFrame ~= nil and guiFrame.isOpen then
                if guiFrame.setInfoText ~= nil then
                    guiFrame:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_failedToSpawnObjectWarning", EasyDevControlsUtils.getText("easyDevControls_typePallet")), EasyDevControlsErrorCodes.FAILED)
                end
            elseif connection ~= nil then
                EasyDevControlsLogging.dedicatedServerInfo(EasyDevControlsUtils.formatText("easyDevControls_failedToSpawnObjectWarning", EasyDevControlsUtils.getText("easyDevControls_typePallet")))
                connection:sendEvent(EasyDevControlsSpawnObjectEvent.newServerToClient(EasyDevControlsErrorCodes.FAILED, EasyDevControlsObjectTypes.PALLET))
            end

            return
        end

        local collisionMask = CollisionFlag.STATIC_OBJECT + CollisionFlag.TERRAIN + CollisionFlag.TERRAIN_DELTA + CollisionFlag.DYNAMIC_OBJECT + CollisionFlag.VEHICLE
        local objectId, _, hitY, _, _ = RaycastUtil.raycastClosest(x, y + 25, z, 0, -1, 0, 40, collisionMask)

        local data = VehicleLoadingData.new()
        -- local configurations = EasyDevControlsUtils.getPalletConfigurations(xmlFilename)

        -- if configurations ~= nil then
            -- data:setConfigurations(configurations)
        -- end

        data:setFilename(xmlFilename)
        data:setPosition(x, (objectId ~= nil and hitY or getTerrainHeightAtWorldPos(g_terrainNode, x, y, z)) + 0.2, z)
        data:setRotation(0, ry or 0, 0)
        data:setPropertyState(VehiclePropertyState.OWNED)
        data:setOwnerFarmId(farmId)
        data:load(asyncCallbackFunction)
    else
        local params = {
            xmlFilename = xmlFilename,
            fillTypeIndex = fillTypeIndex,
            x = x,
            y = y,
            z = z,
            ry = ry or 0,
            amountToAdd = amountToAdd
        }

        return self:clientSendEvent(EasyDevControlsSpawnObjectEvent, EasyDevControlsObjectTypes.PALLET, params)
    end
end

-- Add Log
function EasyDevControls:spawnLog(treeType, length, growthStateI, x, y, z, dirX, dirY, dirZ)
    if treeType == nil or x == nil or y == nil or z == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    local treePlantManager = g_treePlantManager

    if treePlantManager == nil or treePlantManager.loadTreeTrunkDatas == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    local treeTypeDesc = treePlantManager:getTreeTypeDescFromIndex(treeType)

    if treeTypeDesc == nil or (#treeTypeDesc.stages <= 1 and not (treeTypeDesc.name == "DEADWOOD" or treeTypeDesc.name == "RAVAGED")) then
        return EasyDevControlsUtils.getText("easyDevControls_invalidTreeTypeWarning"), EasyDevControlsErrorCodes.FAILED
    end

    local numStages = #treeTypeDesc.stages

    length = EasyDevControlsUtils.getNoNilClamp(length, 1, EasyDevControlsUtils.getMaxLogLength(treeTypeDesc.name) or 1, 1)
    growthStateI = EasyDevControlsUtils.getNoNilClamp(growthStateI, 0, numStages, numStages)

    local variationIndex = #treeTypeDesc.stages[growthStateI]

    if self.isServer then
        local typeText = string.format("%s (%s) %s", EasyDevControlsUtils.formatLength(length), treeTypeDesc.title, EasyDevControlsUtils.getText("easyDevControls_typeLog"))

        local useOnlyStump = false
        local treeId, splitShapeFileId = treePlantManager:loadTreeNode(treeTypeDesc, x, y, z, 0, 0, 0, growthStateI, variationIndex)

        if treeId == 0 then
            return EasyDevControlsUtils.formatText("easyDevControls_failedToSpawnObjectWarning", typeText), EasyDevControlsErrorCodes.FAILED
        end

        if not getFileIdHasSplitShapes(splitShapeFileId) then
            delete(treeId)

            return EasyDevControlsUtils.formatText("easyDevControls_failedToSpawnObjectWarning", typeText), EasyDevControlsErrorCodes.FAILED
        end

        table.insert(treePlantManager.treesData.splitTrees, {
            x = x,
            y = y,
            z = z,
            rx = 0,
            ry = 0,
            rz = 0,
            node = treeId,
            growthStateI = growthStateI,
            treeType = treeTypeDesc.index,
            splitShapeFileId = splitShapeFileId,
            variationIndex = variationIndex,
            hasSplitShapes = true
        })

        g_server:broadcastEvent(TreePlantEvent.new(treeType, x, y, z, 0, 0, 0, growthStateI, variationIndex, splitShapeFileId, false))

        self.addingTreeToCut = true

        if self.loadTreeTrunkDatas == nil then
            self.loadTreeTrunkDatas = {}
        end

        table.insert(self.loadTreeTrunkDatas, {
            x = x,
            y = y,
            z = z,
            dirX = dirX,
            dirY = dirY,
            dirZ = dirZ,
            offset = 0.5,
            delimb = true,
            framesLeft = 2,
            length = length,
            useOnlyStump = useOnlyStump,
            shape = treeId + 2,
            cutTreeTrunkCallback = TreePlantManager.cutTreeTrunkCallback
        })

        self.numUpdateRequests += 1
        g_currentMission:addUpdateable(self)

        self.addingTreeToCut = false

        return EasyDevControlsUtils.formatText("easyDevControls_spawnObjectsInfo", typeText), EasyDevControlsErrorCodes.SUCCESS
    else
        local params = {
            treeType = treeType,
            length = length,
            growthStateI = growthStateI,
            variationIndex = variationIndex,
            rx = dirX,
            ry = dirY,
            rz = dirZ,
            x = x,
            y = y,
            z = z
        }

        return self:clientSendEvent(EasyDevControlsSpawnObjectEvent, EasyDevControlsObjectTypes.LOG, params)
    end
end

-- Plant Tree
function EasyDevControls:plantTree(treeType, growthStateI, variationIndex, isGrowing, x, y, z, ry)
    if treeType == nil or x == nil or y == nil or z == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        ry = ry or (math.random() * 2 * math.pi)

        if g_treePlantManager:plantTree(treeType, x, y, z, 0, ry, 0, growthStateI, variationIndex, isGrowing) then
            return EasyDevControlsUtils.getText("easyDevControls_plantTreeInfo"), EasyDevControlsErrorCodes.SUCCESS
        end
    else
        return EasyDevControlsUtils.getText("easyDevControls_singlePlayerOnly"), EasyDevControlsErrorCodes.FAILED -- TO_DO: (Future) Add MP support
    end
end

-- Tip Anywhere
function EasyDevControls:tipHeightType(amount, fillTypeIndex, x, y, z, dirX, dirZ, length, vehicle, player, connection)
    if amount == nil or fillTypeIndex == nil or x == nil or y == nil or z == nil or player == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    dirX = dirX or 1
    dirZ = dirZ or 0

    length = length or 2

    if EasyDevControlsUtils.getCanTipToGround(amount, fillTypeIndex, x, y, z, dirX, dirZ, length, vehicle, player.farmId, connection) then
        if self.isServer then
            local tipped, lineOffset = DensityMapHeightUtil.tipToGroundAroundLine(vehicle, amount, fillTypeIndex, x, y, z, x + length * dirX, y, z + length * dirZ, 10, 40, nil, nil, nil, nil)

            if tipped > 0 then
                player.mover:teleportTo(x, DensityMapHeightUtil.getHeightAtWorldPos(x, y, z), z) -- Try and stop player getting stuck in the heap

                return EasyDevControlsUtils.formatText("easyDevControls_tipToGroundInfo", g_i18n:formatFluid(tipped), EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex), EasyDevControlsUtils.formatLength(length)), EasyDevControlsErrorCodes.SUCCESS
            end

            return self.texts.requestFailed, EasyDevControlsErrorCodes.UNKNOWN_FAIL
        end

        return self:clientSendEvent(EasyDevControlsTipHeightTypeEvent, amount, fillTypeIndex, x, y, z, dirX, dirZ, length, vehicle)
    end

    return g_i18n:getText("warning_youDontHaveAccessToThisLand"), EasyDevControlsErrorCodes.INVALID_FARM
end

-- Clear Tip Area
function EasyDevControls:clearHeightType(typeId, fillTypeIndex, x, z, radius, farmId, connection)
    if not EasyDevControlsClearHeightTypeEvent.getIsValidTypeId(typeId) then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.UNKNOWN_FAIL
    end

    if fillTypeIndex == FillType.UNKNOWN then
        fillTypeIndex = nil
    end

    if typeId == EasyDevControlsClearHeightTypeEvent.TYPE_AREA then
        if x == nil or z == nil then
            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end

        radius = EasyDevControlsUtils.getNoNilClamp(radius, 1, EasyDevControlsObjectsFrame.MAX_CLEAR_RADIUS, 1)

        if not self:getIsMasterUser(connection) then
            if not EasyDevControlsUtils.getIsFarmlandAccessible(x, z, farmId, radius) then
                return string.format("%s (%i m²)", g_i18n:getText("warning_youDontOwnThisLand"), radius), EasyDevControlsErrorCodes.INVALID_FARM
            end
        end

        if self.isServer then
            local startX, startZ, widthX, widthZ, heightX, heightZ = EasyDevControlsUtils.getArea(x, z, radius)

            if EasyDevControlsUtils.clearArea(startX, startZ, widthX, widthZ, heightX, heightZ, fillTypeIndex) then
                return EasyDevControlsUtils.formatText("easyDevControls_clearTipAreaRadiusInfo", EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex), string.format("%i m²", radius)), EasyDevControlsErrorCodes.SUCCESS
            end

            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end
    end

    if typeId == EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND then
        if x == nil then
            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end

        if farmId ~= nil and not self:getIsMasterUser(connection) then
            local farmlandOwner = g_farmlandManager:getFarmlandOwner(x)

            if farmlandOwner == FarmlandManager.NO_OWNER_FARM_ID or not g_currentMission.accessHandler:canFarmAccessOtherId(farmId, farmlandOwner) then
                return g_i18n:getText("warning_youDontOwnThisLand"), EasyDevControlsErrorCodes.INVALID_FARM
            end
        end

        if self.isServer then
            if EasyDevControlsUtils.clearFarmland(x, fillTypeIndex) then
                local farmlandName = string.format(g_i18n:getText("contract_farmland"), tostring(x)) -- TO_DO: Add EDC translations for farmland / farmlands

                return EasyDevControlsUtils.formatText("easyDevControls_clearTipAreaFieldInfo", farmlandName, EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex)), EasyDevControlsErrorCodes.SUCCESS
            end

            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end
    end

    if typeId == EasyDevControlsClearHeightTypeEvent.TYPE_MAP then
        if self.isServer then
            local sizeHalf = g_currentMission.terrainSize * 0.5

            if EasyDevControlsUtils.clearArea(-sizeHalf, sizeHalf, sizeHalf, sizeHalf, -sizeHalf, -sizeHalf, fillTypeIndex) then
                return EasyDevControlsUtils.formatText("easyDevControls_clearTipAreaMapInfo", EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex)), EasyDevControlsErrorCodes.SUCCESS
            end

            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end
    end

    return self:clientSendEvent(EasyDevControlsClearHeightTypeEvent, typeId, fillTypeIndex, x, z, radius)
end

-- Remove All Objects
function EasyDevControls:removeAllObjects(typeId)
    if not EasyDevControlsRemoveAllObjectsEvent.getIsValidTypeId(typeId) then
        EasyDevControlsLogging.devInfo("[EasyDevControls.removeAllObjects] Failed to remove objects, a valid type was not specified!")

        return self.texts.requestFailed, EasyDevControlsErrorCodes.UNKNOWN_FAIL
    end

    if self.isServer then
        local numRemoved = 0

        if typeId == EasyDevControlsObjectTypes.VEHICLE then
            local vehicles = g_currentMission.vehicleSystem.vehicles
            local vehicle = nil

            for i = #vehicles, 1, -1 do
                vehicle = vehicles[i]

                if vehicle.trainSystem == nil and not vehicle.isPallet then
                    vehicle:delete(true) -- delete without delay
                    numRemoved += 1
                end
            end
        elseif typeId == EasyDevControlsObjectTypes.PALLET then
            local vehicles = g_currentMission.vehicleSystem.vehicles
            local vehicle = nil

            for i = #vehicles, 1, -1 do
                vehicle = vehicles[i]

                if vehicle.isPallet then
                    vehicle:delete(true) -- delete without delay
                    numRemoved += 1
                end
            end
        elseif typeId == EasyDevControlsObjectTypes.BALE then
            local baleObjects = EasyDevControlsUtils.getBaleObjectsFromObjectStorages()
            local itemsToSave = g_currentMission.itemSystem.itemsToSave
            local balesToRemove = {}

            for _, item in pairs(itemsToSave) do
                local object = item.item

                if baleObjects[object] == nil and object.isa ~= nil and object:isa(Bale) then
                    table.addElement(balesToRemove, object)
                end
            end

            for i = #balesToRemove, 1, -1 do
                balesToRemove[i]:delete()
                numRemoved += 1
            end
        elseif typeId == EasyDevControlsObjectTypes.LOG or typeId == EasyDevControlsObjectTypes.STUMP then
            local removeStumps = typeId == EasyDevControlsObjectTypes.STUMP
            local _, numSplit = getNumOfSplitShapes()

            if numSplit > 0 then
                local densityManager = g_densityMapHeightManager
                local aiSystem = g_currentMission.aiSystem
                local splitSplitShapes = {}

                EasyDevControlsUtils.collectSplitSplitShapes(getRootNode(), not removeStumps, removeStumps, splitSplitShapes)

                for _, splitShape in pairs (splitSplitShapes) do
                    local x, _, z = getWorldTranslation(splitShape)

                    delete(splitShape)

                    if removeStumps then
                        densityManager:setCollisionMapAreaDirty(x - 10, z - 10, x + 10, z + 10, true)
                        aiSystem:setAreaDirty(x - 10, x + 10, z - 10, z + 10)
                    end

                    numRemoved += 1
                end

                if numRemoved > 0 then
                    g_treePlantManager:cleanupDeletedTrees()
                end
            end
        elseif typeId == EasyDevControlsObjectTypes.PLACEABLE or typeId == EasyDevControlsObjectTypes.MAP_PLACEABLE then
            local removePreplaced = typeId == EasyDevControlsObjectTypes.MAP_PLACEABLE
            local placeableSystem = g_currentMission.placeableSystem

            local placeable = nil
            local preplaced = false

            for i = #placeableSystem.placeables, 1, -1 do
                placeable = placeableSystem.placeables[i]
                preplaced = placeable:getIsPreplaced()

                if (not preplaced and not removePreplaced) or (preplaced and removePreplaced) then
                    placeable:delete()
                    numRemoved += 1
                end
            end
        end

        if numRemoved == 0 then
            -- TO_DO: Add message stating none of this object type found?
        end

        return EasyDevControlsUtils.formatText("easyDevControls_removeAllObjectsInfo", tostring(numRemoved), EasyDevControlsObjectTypes.getText(typeId, numRemoved, false)), EasyDevControlsErrorCodes.SUCCESS, numRemoved
    else
        return self:clientSendEvent(EasyDevControlsRemoveAllObjectsEvent, typeId)
    end
end

-- Set Fill Level
function EasyDevControls:setFillUnitFillLevel(vehicle, fillUnitIndex, fillTypeIndex, amount, ignoreRemoveIfEmpty)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle, "spec_fillUnit") then
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end

    if fillUnitIndex == nil or fillTypeIndex == nil or amount == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.UNKNOWN_FAIL
    end

    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

    if fillType ~= nil then
        local spec = vehicle.spec_fillUnit
        local fillUnit = spec.fillUnits[fillUnitIndex]

        if fillUnit ~= nil and fillUnit.supportedFillTypes[fillTypeIndex] and fillUnit.capacity ~= 0 then
            ignoreRemoveIfEmpty = Utils.getNoNil(ignoreRemoveIfEmpty, false)

            if self.isServer then
                local farmId = vehicle:getOwnerFarmId() or 1
                local balerSpec = vehicle.spec_baler
                local oldRemoveVehicleIfEmpty = spec.removeVehicleIfEmpty

                -- Causes to many issues so not possible (Will try and find a fix for FS25 if I have time after release.)
                if balerSpec ~= nil and balerSpec.hasUnloadingAnimation then
                    return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
                end

                if fillUnit.fillLevel > 0 then
                    spec.removeVehicleIfEmpty = false
                    vehicle:addFillUnitFillLevel(farmId, fillUnitIndex, -math.huge, fillUnit.fillType, ToolType.UNDEFINED)
                    spec.removeVehicleIfEmpty = oldRemoveVehicleIfEmpty
                end

                if ignoreRemoveIfEmpty then
                    spec.removeVehicleIfEmpty = false
                end

                amount = amount > 0 and amount or -math.huge

                if amount > 0 and vehicle.finishedFirstUpdate then
                    if fillUnit.updateMass and not fillUnit.ignoreFillLimit and g_currentMission.missionInfo.trailerFillLimit then
                        vehicle:updateMass()
                    end
                end

                local deltaLevel = vehicle:addFillUnitFillLevel(farmId, fillUnitIndex, math.min(amount, fillUnit.capacity), fillTypeIndex, ToolType.UNDEFINED)
                spec.removeVehicleIfEmpty = oldRemoveVehicleIfEmpty

                -- Move the bale down the chute so it does not spew them when unloading, not recommended really. This updates fast so Ready, aim.... FIRE!!!
                if balerSpec ~= nil and not balerSpec.hasUnloadingAnimation then
                    vehicle:moveBales(vehicle:getTimeFromLevel(deltaLevel))
                end

                if fillUnit.fillLevel > 0 then
                    local fillLevelString = string.format("%s %s", g_i18n:formatNumber(g_i18n:getVolume(fillUnit.fillLevel), 0), g_i18n:getVolumeUnit(true))

                    return EasyDevControlsUtils.formatText("easyDevControls_setFillUnitFillLevelInfo", tostring(fillUnitIndex), vehicle:getFullName(), fillType.title, fillLevelString), EasyDevControlsErrorCodes.SUCCESS
                end

                return EasyDevControlsUtils.formatText("easyDevControls_setFillUnitEmptyInfo", tostring(fillUnitIndex), vehicle:getFullName()), EasyDevControlsErrorCodes.SUCCESS
            else
                return self:clientSendEvent(EasyDevControlsSetFillUnitFillLevel, vehicle, fillUnitIndex, fillTypeIndex, amount, ignoreRemoveIfEmpty)
            end
        else
            return self.texts.requestFailed, EasyDevControlsErrorCodes.UNKNOWN_FAIL
        end
    else
        return EasyDevControlsUtils.getText("easyDevControls_invalidFillTypeWarning")
    end
end

-- Vehicle Condition
function EasyDevControls:setVehicleCondition(vehicle, isEntered, typeId, setToAmount, amount)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle) then
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end

    setToAmount = Utils.getNoNil(setToAmount, false)
    amount = amount or 0

    if setToAmount then
        amount = math.abs(amount)
    end

    if self.isServer then
        local addDirt, addWetness, addWear, addDamage = false, false, false, false

        if typeId == EasyDevControlsVehicleConditionEvent.TYPE_DIRT then
            addDirt = true
        elseif typeId == EasyDevControlsVehicleConditionEvent.TYPE_WET then
            addWetness = true
        elseif typeId == EasyDevControlsVehicleConditionEvent.TYPE_WEAR then
            addWear = true
        elseif typeId == EasyDevControlsVehicleConditionEvent.TYPE_DAMAGE then
            addDamage = true
        else
            addDirt, addWetness, addWear, addDamage = true, true, true, true
        end

        self:setVehicleConditionValues(vehicle, setToAmount, amount, addDirt, addWetness, addWear, addDamage, isEntered)

        if isEntered then
            return EasyDevControlsUtils.formatText("easyDevControls_vehicleAndImplementsConditionInfo", vehicle:getFullName()), EasyDevControlsErrorCodes.SUCCESS
        end

        return EasyDevControlsUtils.formatText("easyDevControls_vehicleConditionInfo", vehicle:getFullName()), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsVehicleConditionEvent, vehicle, isEntered, typeId, setToAmount, amount)
    end
end

function EasyDevControls:setVehicleConditionValues(vehicle, setToAmount, amount, addDirt, addWetness, addWear, addDamage, updateChildVehicles)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle) then
        return
    end

    local washableSpec = vehicle.spec_washable
    local wearableSpec = vehicle.spec_wearable

    if washableSpec ~= nil then
        for i = 1, #washableSpec.washableNodes do
            local nodeData = washableSpec.washableNodes[i]

            if setToAmount then
                if addDirt then
                    vehicle:setNodeDirtAmount(nodeData, amount, true)
                end

                if addWetness then
                    vehicle:setNodeWetness(nodeData, amount, true)
                end
            else
                if addDirt then
                    vehicle:setNodeDirtAmount(nodeData, nodeData.dirtAmount + amount, true)
                end

                if addWetness then
                    vehicle:setNodeWetness(nodeData, nodeData.wetness + amount, true)
                end
            end
        end
    end

    if wearableSpec ~= nil then
        if addWear then
            if wearableSpec.wearableNodes ~= nil then
                for _, nodeData in ipairs(wearableSpec.wearableNodes) do
                    if setToAmount then
                        vehicle:setNodeWearAmount(nodeData, amount, true)
                    else
                        vehicle:setNodeWearAmount(nodeData, vehicle:getNodeWearAmount(nodeData) + amount, true)
                    end
                end
            end
        end

        if addDamage then
            if setToAmount then
                vehicle:setDamageAmount(amount, true)
            else
                vehicle:setDamageAmount(wearableSpec.damage + amount, true)
            end
        end
    end

    if updateChildVehicles and (vehicle.rootVehicle ~= nil and vehicle.rootVehicle.childVehicles ~= nil) then
        for _, childVehicle in pairs(vehicle.rootVehicle.childVehicles) do
            self:setVehicleConditionValues(childVehicle, setToAmount, amount, addDirt, addWetness, addWear, addDamage, false)
        end
    end
end

-- Vehicle Fuel
function EasyDevControls:setVehicleFuel(vehicle, amount)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle, "getConsumerFillUnitIndex") then
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end

    amount = amount or 1e+7

    if self.isServer then
        EasyDevControlsVehiclesFrame.createFuelTypeIndexs()

        for _, fillTypeIndex in pairs (EasyDevControlsVehiclesFrame.FUEL_TYPE_INDEXS) do
            local fillUnitIndex = vehicle:getConsumerFillUnitIndex(fillTypeIndex)

            if fillUnitIndex ~= nil then
                local newFillLevel = amount - vehicle:getFillUnitFillLevel(fillUnitIndex)
                local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

                vehicle:addFillUnitFillLevel(vehicle:getOwnerFarmId(), fillUnitIndex, newFillLevel, vehicle:getFillUnitFirstSupportedFillType(fillUnitIndex), ToolType.UNDEFINED, nil)
                newFillLevel = vehicle:getFillUnitFillLevel(fillUnitIndex) or 0

                return EasyDevControlsUtils.formatText("easyDevControls_vehicleFuelInfo", fillType.title, vehicle:getFullName(), newFillLevel, g_i18n:getVolumeUnit(true)), EasyDevControlsErrorCodes.SUCCESS
            end
        end

        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.UNKNOWN_FAIL
    else
        return self:clientSendEvent(EasyDevControlsVehicleOperatingValueEvent, vehicle, EasyDevControlsVehicleOperatingValueEvent.FUEL, amount)
    end
end

-- Vehicle Motor Temp
function EasyDevControls:setVehicleMotorTemperature(vehicle, temperature)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle, "spec_motorized") then
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local spec = vehicle.spec_motorized

        spec.motorTemperature.value = EasyDevControlsUtils.getNoNilClamp(temperature, spec.motorTemperature.valueMin, spec.motorTemperature.valueMax, 0)

        return EasyDevControlsUtils.formatText("easyDevControls_vehicleMotorTempInfo", vehicle:getFullName(), spec.motorTemperature.value), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsVehicleOperatingValueEvent, vehicle, EasyDevControlsVehicleOperatingValueEvent.MOTOR_TEMP, temperature)
    end
end

-- Vehicle Operating Time
function EasyDevControls:setVehicleOperatingTime(vehicle, operatingTime)
    if not EasyDevControlsUtils.getIsValidVehicle(vehicle, "setOperatingTime") then
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end

    operatingTime = math.abs(operatingTime or 0)

    if self.isServer then
        vehicle:setOperatingTime(operatingTime * 1000 * 60 * 60)

        return EasyDevControlsUtils.formatText("easyDevControls_vehicleOperatingTimeInfo", vehicle:getFullName(), Enterable.getFormattedOperatingTime(vehicle)), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsVehicleOperatingValueEvent, vehicle, EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME, operatingTime)
    end
end

-- Power Consumer
function EasyDevControls:setPowerConsumer(powerConsumerVehicle, neededMinPtoPower, neededMaxPtoPower, forceFactor, maxForce, forceDir, ptoRpm, syncVehicles)
    if powerConsumerVehicle ~= nil and powerConsumerVehicle.spec_powerConsumer ~= nil then
        local spec = powerConsumerVehicle.spec_powerConsumer

        if spec.edcOriginalValues == nil then
            spec.edcOriginalValues = {
                neededMinPtoPower = spec.neededMinPtoPower,
                neededMaxPtoPower = spec.neededMaxPtoPower,
                forceFactor = spec.forceFactor,
                maxForce = spec.maxForce,
                forceDir = spec.forceDir,
                ptoRpm = spec.ptoRpm
            }
        end

        spec.neededMinPtoPower = Utils.getNoNil(neededMinPtoPower, spec.neededMinPtoPower)
        spec.neededMaxPtoPower = Utils.getNoNil(neededMaxPtoPower, spec.neededMaxPtoPower)
        spec.forceFactor = Utils.getNoNil(forceFactor, spec.forceFactor)
        spec.maxForce = Utils.getNoNil(maxForce, spec.maxForce)
        spec.forceDir = Utils.getNoNil(forceDir, spec.forceDir)
        spec.ptoRpm = Utils.getNoNil(ptoRpm, spec.ptoRpm)

        if spec.neededMaxPtoPower < spec.neededMinPtoPower then
            spec.neededMaxPtoPower = spec.neededMinPtoPower
        end

        if spec.forceDir < -1 or spec.forceDir == 0  or spec.forceDir > 1 then
            spec.forceDir = 1
        end

        -- Update all vehicles with matching configFileName
        syncVehicles = Utils.getNoNil(syncVehicles, false)

        if syncVehicles then
            for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do
                if vehicle.configFileName == powerConsumerVehicle.configFileName then
                    local powerConsumerSpec = vehicle.spec_powerConsumer

                    if powerConsumerSpec.edcOriginalValues == nil then
                        powerConsumerSpec.edcOriginalValues = {
                            neededMinPtoPower = spec.neededMinPtoPower,
                            neededMaxPtoPower = spec.neededMaxPtoPower,
                            forceFactor = spec.forceFactor,
                            maxForce = spec.maxForce,
                            forceDir = spec.forceDir,
                            ptoRpm = spec.ptoRpm
                        }
                    end

                    powerConsumerSpec.neededMinPtoPower = spec.neededMinPtoPower
                    powerConsumerSpec.neededMaxPtoPower = spec.neededMaxPtoPower
                    powerConsumerSpec.forceFactor = spec.forceFactor
                    powerConsumerSpec.maxForce = spec.maxForce
                    powerConsumerSpec.forceDir = spec.forceDir
                    powerConsumerSpec.ptoRpm = spec.ptoRpm
                end
            end
        end

        return EasyDevControlsUtils.formatText("easyDevControls_setPowerConsumerInfo", powerConsumerVehicle:getFullName(), tostring(syncVehicles)), EasyDevControlsErrorCodes.SUCCESS
    else
        return EasyDevControlsUtils.getText("easyDevControls_noValidVehicleWarning"), EasyDevControlsErrorCodes.FAILED
    end
end

-- Set Production Point Fill Levels
function EasyDevControls:setProductionPointFillLevels(productionPoint, fillLevel, fillTypeIndex, isOutput, suppressText)
    if productionPoint ~= nil or fillLevel ~= nil then
        local fillTypeIds = isOutput and productionPoint.outputFillTypeIds or productionPoint.inputFillTypeIds

        if fillTypeIds ~= nil then
            if fillTypeIndex ~= nil then
                if fillTypeIds[fillTypeIndex] ~= nil then
                    if self.isServer then
                        local modeL10N = isOutput and "easyDevControls_output" or "easyDevControls_input"
                        local fillTypeTitle = EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex, "Unknown")

                        productionPoint.storage:setFillLevel(fillLevel, fillTypeIndex)

                        return EasyDevControlsUtils.formatText("easyDevControls_productionPointFillLevelInfo", EasyDevControlsUtils.getText(modeL10N):lower(), fillTypeTitle, productionPoint:getName()), EasyDevControlsErrorCodes.SUCCESS
                    else
                        return self:clientSendEvent(EasyDevControlsSetProductionPointFillLevelsEvent, productionPoint, fillLevel, fillTypeIndex, isOutput)
                    end
                else
                    return EasyDevControlsUtils.getText("easyDevControls_invalidFillTypeWarning"), EasyDevControlsErrorCodes.FAILED
                end
            else
                if self.isServer then
                    for supportedFillType in pairs (fillTypeIds) do
                        productionPoint.storage:setFillLevel(fillLevel, supportedFillType)
                    end

                    if suppressText then
                        return true
                    else
                        local modeL10N = isOutput and "easyDevControls_output" or "easyDevControls_input"
                        local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PRODUCTION_POINT, 1)

                        return EasyDevControlsUtils.formatText("easyDevControls_productionPointFillLevelAllInfo", EasyDevControlsUtils.getText(modeL10N):lower(), "1", typeText), EasyDevControlsErrorCodes.SUCCESS
                    end
                else
                    local text, errorCode = self:clientSendEvent(EasyDevControlsSetProductionPointFillLevelsEvent, productionPoint, fillLevel, nil, isOutput)

                    if suppressText then
                        return true
                    end

                    return text, errorCode
                end
            end
        end
    end

    if suppressText then
        return false
    end

    return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
end

-- Tip To Trigger
function EasyDevControls:tipFillTypeToTrigger(object, fillUnitIndex, fillTypeIndex, deltaFillLevel, farmId)
    if deltaFillLevel <= 0 then
        return EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED
    end

    if not EasyDevControlsUtils.getIsValidFarmId(farmId) then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM
    end

    if g_fillTypeManager:getFillTypeByIndex(fillTypeIndex) == nil then
        return EasyDevControlsUtils.getText("easyDevControls_invalidFillTypeWarning"), EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local appliedFillLevel = object:addFillUnitFillLevel(farmId, fillUnitIndex or 1, deltaFillLevel, fillTypeIndex, ToolType.UNDEFINED, nil)

        if appliedFillLevel > 0 then
            -- g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "tipToTrigger", EasyDevControlsPlaceablesFrame.NAME)

            return EasyDevControlsUtils.formatText("easyDevControls_tipToTriggerSuccess", string.format("%s %s", g_i18n:formatNumber(appliedFillLevel), g_i18n:getText("unit_liter"))), EasyDevControlsErrorCodes.SUCCESS, appliedFillLevel
        end

        return EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED
    else
        return self:clientSendEvent(EasyDevControlsTipFillTypeToTrigger, object, fillUnitIndex or 1, fillTypeIndex, deltaFillLevel)
    end
end

-- Reload Placeables
function EasyDevControls:reloadPlaceables(target, resultFunction)
    local placeableSystem = g_currentMission.placeableSystem

    -- No need for this in multiplayer as mods must be zipped
    if (not self.isServer or self:getIsMultiplayer()) or (placeableSystem == nil or placeableSystem.isReloadRunning) then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    local placeablesToReload = {}
    local placeableToIndex = {}

    for i, placeable in ipairs(placeableSystem.placeables) do
        if not placeable.isPreplaced and placeable.spec_trainSystem == nil and placeable.spec_riceField == nil then
            if target == nil then
                table.insert(placeablesToReload, placeable)
                placeableToIndex[placeable] = i
            elseif target == placeable then
                table.insert(placeablesToReload, placeable)
                placeableToIndex[placeable] = i

                break
            end
        end
    end

    if #placeablesToReload > 0 then
        local xmlFile = XMLFile.create("placeableXMLFile", "", "placeables", Placeable.xmlSchemaSavegame)
        local xmlIndex = 0

        xmlFile:setValue("placeables#version", placeableSystem.version)

        for _, placeable in ipairs (placeablesToReload) do
            placeableSystem:savePlaceableToXML(placeable, xmlFile, xmlIndex, placeableToIndex[placeable], usedModNames)
            placeableSystem:removePlaceable(placeable) -- remove the placeable so the uniqueId does not exist as I delete only if the new one loads correctly

            xmlIndex += 1
        end

        function callback(_, loadedPlaceables, placeableLoadingState, args)
            local numReloaded = 0

            for _, placeable in ipairs(loadedPlaceables) do
                local uniqueId = placeable:getUniqueId()

                -- If the placeable loaded without XML or I3D errors, delete the old one
                for i, oldPlaceable in ipairs (placeablesToReload) do
                    if oldPlaceable:getUniqueId() == uniqueId then
                        oldPlaceable.isReloading = true
                        oldPlaceable:delete(true) -- do not queue for delete

                        table.remove(placeablesToReload, i)
                        placeableToIndex[oldPlaceable] = nil

                        numReloaded += 1

                        break
                    end
                end
            end

            -- If some placeables failed to load due to XML or I3D errors, restore the 'uniqueIds' and return list of XML filenames
            if #placeablesToReload > 0 then
                for _, placeable in ipairs (placeablesToReload) do
                    placeableSystem:addPlaceable(placeable) -- restore the placeable
                end
            end

            xmlFile:delete()
            placeableSystem.isReloadRunning = false

            if resultFunction ~= nil then
                resultFunction(numReloaded, placeablesToReload) -- send the 'placeablesToReload' as these failed to reload
            end

            g_messageCenter:publish(MessageType.EDC_PRODUCTIONS_CHANGED, true)
        end

        g_i3DManager:clearEntireSharedI3DFileCache(false)
        placeableSystem.isReloadRunning = true

        g_asyncTaskManager:addTask(function()
            placeableSystem:loadFromXMLFile(xmlFile, callback, nil, nil)
        end)
    else
        return EasyDevControlsUtils.formatText("easyDevControls_reloadPlaceablesInfo", "0", EasyDevControlsUtils.getText("easyDevControls_typePlaceables"))
    end
end

-- Set Field Fruit
function EasyDevControls:setFieldFruit(fieldIndex, fruitTypeIndex, growthState, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId)
    if self.isServer then
        if fieldIndex == 0 then
            local numFieldsUpdated = 0

            for _, field in ipairs (g_fieldManager:getFields()) do
                if EasyDevControlsUtils.setField(field, fruitTypeIndex, growthState, groundType, nil, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId) then
                    numFieldsUpdated += 1
                end
            end

            if numFieldsUpdated > 0 then
                return EasyDevControlsUtils.formatText("easyDevControls_setAllFieldSuccessInfo", tostring(numFieldsUpdated)), EasyDevControlsErrorCodes.SUCCESS, numFieldsUpdated
            end
        elseif EasyDevControlsUtils.setField(g_fieldManager:getFieldById(fieldIndex), fruitTypeIndex, growthState, groundType, nil, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId) then
            return EasyDevControlsUtils.formatText("easyDevControls_setFieldSuccessInfo", tostring(fieldIndex)), EasyDevControlsErrorCodes.SUCCESS, fieldIndex
        end

        return EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED, 0
    else
        return self:clientSendEvent(EasyDevControlsSetFieldEvent, EasyDevControlsSetFieldEvent.FRUIT, fieldIndex, fruitTypeIndex, growthState, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland)
    end
end

-- Set Field Ground
function EasyDevControls:setFieldGround(fieldIndex, groundAngle, removeFoliage, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId)
    if self.isServer then
        local fruitTypeIndex = nil

        if removeFoliage then
            fruitTypeIndex = FruitType.UNKNOWN
        end

        if fieldIndex == 0 then
            local numFieldsUpdated = 0

            for _, field in ipairs (g_fieldManager:getFields()) do
                if EasyDevControlsUtils.setField(field, fruitTypeIndex, 0, groundType, groundAngle, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId) then
                    numFieldsUpdated += 1
                end
            end

            if numFieldsUpdated > 0 then
                return EasyDevControlsUtils.formatText("easyDevControls_setAllFieldSuccessInfo", tostring(numFieldsUpdated)), EasyDevControlsErrorCodes.SUCCESS, numFieldsUpdated
            end
        elseif EasyDevControlsUtils.setField(g_fieldManager:getFieldById(fieldIndex), fruitTypeIndex, 0, groundType, groundAngle, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, farmId) then
            return EasyDevControlsUtils.formatText("easyDevControls_setFieldSuccessInfo", tostring(fieldIndex)), EasyDevControlsErrorCodes.SUCCESS, fieldIndex
        end

        return EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED, 0
    else
        return self:clientSendEvent(EasyDevControlsSetFieldEvent, EasyDevControlsSetFieldEvent.GROUND, fieldIndex, groundAngle, removeFoliage, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland)
    end
end

-- Set Rice Field
function EasyDevControls:setRiceField(placeable, fieldIndex, fruitTypeIndex, growthState, groundAngle, waterLevel)
    if placeable == nil or placeable.spec_riceField == nil then
        return EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED
    end

    local field = placeable:getFieldByIndex(fieldIndex)
    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)

    if field == nil or (fruitTypeIndex ~= FruitType.UNKNOWN and fruitType == nil) then
        return EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local densityMapPolygon = DensityMapPolygon.new()
        densityMapPolygon:updateFromPolygon2D(field.polygonFoliage)

        local fieldUpdateTask = FieldUpdateTask.new()
        fieldUpdateTask:setArea(densityMapPolygon)

        local groundType = FieldGroundType.CULTIVATED

        if fruitTypeIndex ~= FruitType.UNKNOWN then
            growthState = math.clamp(growthState or 1, 1, fruitType.numFoliageStates)
            groundType = fruitType:getGrowthStateGroundType(growthState)
        else
            growthState = 0
        end

        fieldUpdateTask:setFruit(fruitTypeIndex, growthState)

        if groundType ~= nil then
            fieldUpdateTask:setGroundType(groundType)
        end

        if groundAngle ~= nil then
            fieldUpdateTask:setGroundAngle(-groundAngle)
        end

        fieldUpdateTask:enqueue(true)

        if waterLevel ~= nil then
            placeable:setWaterHeight(fieldIndex, placeable.spec_riceField.waterMaxLevel * (waterLevel / 100))
        end

        return EasyDevControlsUtils.formatText("easyDevControls_setFieldSuccessInfo", "(" .. g_i18n:getText("fillType_rice") .. ")"), EasyDevControlsErrorCodes.SUCCESS, fieldIndex
    else
        return self:clientSendEvent(EasyDevControlsSetFieldEvent, EasyDevControlsSetFieldEvent.RICE, placeable, fieldIndex, fruitTypeIndex, growthState or 1, groundAngle or 0, waterLevel or 0)
    end
end

-- Vine System Set State
function EasyDevControls:vineSystemSetState(placeableVine, fruitTypeIndex, growthState, farmId)
    if fruitTypeIndex == nil or growthState == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    local fruitType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(fruitTypeIndex)

    if fruitType == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local vineSystem = g_currentMission.vineSystem
        local accessHandler = g_currentMission.accessHandler

        local vinePlaceables = EasyDevControlsUtils.getVinePlaceables()
        local numUpdated = 0

        if placeableVine == nil then
            for placeable, nodes in pairs(vinePlaceables) do
                if placeable:getVineFruitType() == fruitTypeIndex and accessHandler:canFarmAccessOtherId(farmId, placeable:getOwnerFarmId()) then
                    for _, node in ipairs (nodes) do
                        local startX, startZ, widthX, widthZ, heightX, heightZ = placeable:getVineAreaByNode(node)

                        FSDensityMapUtil:setVineAreaValue(fruitTypeIndex, startX, startZ, widthX, widthZ, heightX, heightZ, growthState)
                        vineSystem.dirtyNodes[node] = true
                    end
                end

                if placeable.spec_fence ~= nil and placeable.spec_fence.segments ~= nil then
                    numUpdated += #placeable.spec_fence.segments
                else
                    numUpdated += 1
                end
            end
        else
            local nodes = vinePlaceables[placeableVine]

            if nodes ~= nil and accessHandler:canFarmAccessOtherId(farmId, placeableVine:getOwnerFarmId()) then
                if placeableVine:getVineFruitType() ~= fruitTypeIndex then
                    fruitTypeIndex = placeableVine:getVineFruitType()
                    fruitType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(fruitTypeIndex)
                end

                for _, node in ipairs (nodes) do
                    local startX, startZ, widthX, widthZ, heightX, heightZ = placeableVine:getVineAreaByNode(node)

                    FSDensityMapUtil:setVineAreaValue(fruitTypeIndex, startX, startZ, widthX, widthZ, heightX, heightZ, growthState)
                    vineSystem.dirtyNodes[node] = true

                    numUpdated = 1
                end
            end
        end

        return EasyDevControlsUtils.formatText("easyDevControls_vineSetStateInfo", tostring(numUpdated), fruitType.title, tostring(growthState)), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsVineSystemSetStateEvent, placeableVine, fruitTypeIndex, growthState)
    end
end

-- Add / Remove Weeds
function EasyDevControls:addRemoveWeedsDelta(fieldIndex, delta)
    local weedSystem = g_currentMission.weedSystem

    if not weedSystem:getMapHasWeed() or (fieldIndex == nil or fieldIndex > 2 ^ g_farmlandManager.numberOfBits - 1) then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        weedSystem:consoleCommandAddDelta(fieldIndex, delta)

        return EasyDevControlsAddRemoveDeltaEvent.getInfoText(true, fieldIndex, delta), EasyDevControlsErrorCodes.SUCCESS
    else
        self:clientSendEvent(EasyDevControlsAddRemoveDeltaEvent, true, fieldIndex, delta)
    end
end

-- Add / Remove Stones
function EasyDevControls:addRemoveStonesDelta(fieldIndex, delta)
    local stoneSystem = g_currentMission.stoneSystem

    if not stoneSystem:getMapHasStones() or (fieldIndex == nil or fieldIndex > 2 ^ g_farmlandManager.numberOfBits - 1) then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        stoneSystem:consoleCommandAddDelta(fieldIndex, delta)

        return EasyDevControlsAddRemoveDeltaEvent.getInfoText(false, fieldIndex, delta), EasyDevControlsErrorCodes.SUCCESS
    else
        self:clientSendEvent(EasyDevControlsAddRemoveDeltaEvent, false, fieldIndex, delta)
    end
end

-- Advance Growth / Set Seasonal Growth Period
function EasyDevControls:setGrowthPeriod(seasonal, period)
    period = period or g_currentMission.environment.currentPeriod

    if seasonal and period > 2 ^ EasyDevControlsUpdateSetGrowthPeriodEvent.PERIOD_SEND_NUM_BITS - 1 then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local growthSystem = g_currentMission.growthSystem

        if not seasonal and growthSystem:getGrowthMode() ~= GrowthMode.DAILY then
            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end

        growthSystem:triggerGrowth(period)

        return EasyDevControlsUtils.getText("easyDevControls_updatingAllFieldsMessage"), EasyDevControlsErrorCodes.SUCCESS
    else
        -- Event send Dialogue is not required as that is handled by the Frame even in SP
        g_client:getServerConnection():sendEvent(EasyDevControlsUpdateSetGrowthPeriodEvent.new(seasonal, period))

        return self.texts.serverRequest, EasyDevControlsErrorCodes.SUCCESS
    end
end

-- Set Time (Month, Day, Hour)
function EasyDevControls:setCurrentTime(hourToSet, daysToAdvance)
    if hourToSet == nil or daysToAdvance == nil then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local environment = g_currentMission.environment

        hourToSet = math.floor(hourToSet * 1000 * 60 * 60)

        if daysToAdvance <= 0 and hourToSet <= environment.dayTime then
            return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
        end

        local monotonicDayToSet = environment.currentMonotonicDay + daysToAdvance
        local dayToSet = environment.currentDay + daysToAdvance

        environment:setEnvironmentTime(monotonicDayToSet, dayToSet, hourToSet, environment.daysPerPeriod, false)
        environment.lighting:setDayTime(environment.dayTime, true)
        environment.weather.cheatedTime = true -- FS25 flag that appears to set the weather change duration to 0 so this goes here.

        g_server:broadcastEvent(EnvironmentTimeEvent.new(monotonicDayToSet, dayToSet, hourToSet, environment.daysPerPeriod))

        local periodFormat = g_i18n:formatDayInPeriod(environment.currentDayInPeriod, environment.currentPeriod, false)
        local hourFormat = string.format("%02.f:00", environment.currentHour)

        return EasyDevControlsUtils.formatText("easyDevControls_setTimeInfo", periodFormat, hourFormat), EasyDevControlsErrorCodes.SUCCESS
    else
        return self:clientSendEvent(EasyDevControlsTimeEvent, hourToSet, daysToAdvance)
    end
end

-- Add / Set Snow
function EasyDevControls:updateSnowAndSalt(typeId, value, player)
    if (g_currentMission == nil or g_currentMission.snowSystem == nil) or (EasyDevControlsUpdateSnowAndSaltEvent.requiresValue(typeId) and value == nil) then
        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    end

    if self.isServer then
        local snowSystem = g_currentMission.snowSystem

        if typeId == EasyDevControlsUpdateSnowAndSaltEvent.ADD_SALT then
            if player == nil then
                return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
            end

            local x, y, z = player:getPosition()
            local startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ = EasyDevControlsUtils.getArea(x, z, value, false)

            snowSystem:removeSnow(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, 1) -- Remove only one layer around player at give radius
            -- snowSystem:consoleCommandSalt(value)

            return EasyDevControlsUtils.formatText("easyDevControls_addSaltInfo", value), EasyDevControlsErrorCodes.SUCCESS
        end

        local environment = g_currentMission.environment

        if environment ~= nil and environment.weather ~= nil then
            if typeId == EasyDevControlsUpdateSnowAndSaltEvent.ADD_SNOW then
                environment.weather.snowHeight = SnowSystem.MAX_HEIGHT
                snowSystem:setSnowHeight(SnowSystem.MAX_HEIGHT)

                return EasyDevControlsUtils.getText("easyDevControls_addSnowInfo"), EasyDevControlsErrorCodes.SUCCESS
            elseif typeId == EasyDevControlsUpdateSnowAndSaltEvent.SET_SNOW then
                environment.weather.snowHeight = value
                snowSystem:setSnowHeight(value)

                return EasyDevControlsUtils.formatText("easyDevControls_setSnowInfo", snowSystem.height), EasyDevControlsErrorCodes.SUCCESS
            elseif typeId == EasyDevControlsUpdateSnowAndSaltEvent.REMOVE_SNOW then
                environment.weather.snowHeight = 0
                snowSystem:removeAll()

                return EasyDevControlsUtils.getText("easyDevControls_removeSnowInfo"), EasyDevControlsErrorCodes.SUCCESS
            end
        end

        return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
    else
        return self:clientSendEvent(EasyDevControlsUpdateSnowAndSaltEvent, typeId, value)
    end
end

-- Action Events Register/Unregister
function EasyDevControls:registerPlayerActionEvents(player, inputBinding)
    local _, eventId = inputBinding:registerActionEvent(InputAction.EDC_PLAYER_RUN_SPEED, self, self.onInputPlayerRunSpeed, false, true, false, true)

    inputBinding:setActionEventTextVisibility(eventId, self.settings:getValue("runSpeedKeyVisible", false))
    inputBinding:setActionEventActive(eventId, self.runSpeedKeyEnabled)

    self.eventIdToggleRunSpeed = eventId

    _, eventId = inputBinding:registerActionEvent(InputAction.EDC_OBJECT_DELETE, self, self.onInputObjectDelete, false, true, false, true)

    inputBinding:setActionEventText(eventId, EasyDevControlsUtils.getText("input_EDC_OBJECT_DELETE"))
    inputBinding:setActionEventTextPriority(eventId, GS_PRIO_VERY_HIGH)
    inputBinding:setActionEventTextVisibility(eventId, false)
    inputBinding:setActionEventActive(eventId, false)

    self.eventIdObjectDelete = eventId

    _, eventId = inputBinding:registerActionEvent(InputAction.EDC_SUPER_STRENGTH, self, self.onInputSuperStrength, false, true, false, true)

    inputBinding:setActionEventText(eventId, EasyDevControlsUtils.getText("input_EDC_SUPER_STRENGTH"))
    inputBinding:setActionEventTextVisibility(eventId, self.settings:getValue("superStrengthKeyVisible", false))
    inputBinding:setActionEventActive(eventId, false)

    self.eventIdSuperStrength = eventId
end

function EasyDevControls:unregisterPlayerActionEvents(player, inputBinding)
    inputBinding:removeActionEventsByTarget(self)

    self.eventIdToggleRunSpeed = nil

    self.eventIdObjectDelete = nil
    self.eventIdObjectDeleteState = nil
    self.targetedObjectType = nil
    self.targetedObject = nil

    self.eventIdSuperStrength = nil
end

function EasyDevControls:registerGlobalActionEvents(player, inputBinding)
    local _, eventId = inputBinding:registerActionEvent(InputAction.EDC_SHOW_UI, self, self.onInputOpenMenu, false, true, false, true)
    inputBinding:setActionEventTextVisibility(eventId, self.settings:getValue("openMenuKeyVisible", false))

    _, eventId = inputBinding:registerActionEvent(InputAction.EDC_TOGGLE_HUD, self, self.onInputToggleHud, false, true, false, true)
    inputBinding:setActionEventTextVisibility(eventId, self.settings:getValue("hudVisibilityKeyVisible", false))
    inputBinding:setActionEventActive(eventId, self.hudVisibilityKeyEnabled)

    if self.reloadInputActionEnabled then
        if InputAction.RELOAD_GAME ~= nil then
            _, eventId = inputBinding:registerActionEvent(InputAction.RELOAD_GAME, self, self.onInputReloadGame, false, true, false, true)
            inputBinding:setActionEventTextVisibility(eventId, Utils.getNoNil(self.reloadInputActionVisibility, false))
            inputBinding:setActionEventText(eventId, g_i18n:getText("button_cancelGame"))
        end
    end
end

-- Action Event Callbacks (Player)
function EasyDevControls:onInputPlayerRunSpeed(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    self:setRunSpeedState(not self.runSpeedEnabled)

    local message = self.runSpeedEnabled and self.texts.runSpeedEnabled or self.texts.runSpeedDisabled
    local notificationType = self.runSpeedEnabled and FSBaseMission.INGAME_NOTIFICATION_OK or FSBaseMission.INGAME_NOTIFICATION_INFO

    g_currentMission.hud:addSideNotification(notificationType, message, 1500)
end

function EasyDevControls:onInputObjectDelete(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    if self.targetedObjectType == nil or self.targetedObject == nil then
        return
    end

    if self:getHasPermission("deleteObjectsKey") then
        if self.targetedObjectType == EasyDevControlsObjectTypes.VEHICLE or self.targetedObjectType == EasyDevControlsObjectTypes.PALLET then
            if self.isServer then
                self.targetedObject:delete(true) -- immediate vehicle delete
            else
                g_client:getServerConnection():sendEvent(EasyDevControlsDeleteObjectEvent.new(self.targetedObjectType, self.targetedObject))
            end
        elseif self.targetedObjectType == EasyDevControlsObjectTypes.BALE then
            if self.isServer then
                self.targetedObject:delete()
            else
                g_client:getServerConnection():sendEvent(EasyDevControlsDeleteObjectEvent.new(EasyDevControlsObjectTypes.BALE, self.targetedObject))
            end
        else
            local isLog = self.targetedObjectType == EasyDevControlsObjectTypes.LOG
            local isTree = self.targetedObjectType == EasyDevControlsObjectTypes.TREE
            local isStump = self.targetedObjectType == EasyDevControlsObjectTypes.STUMP

            if isLog or isTree or isStump then
                if getHasClassId(self.targetedObject, ClassIds.MESH_SPLIT_SHAPE) and getSplitType(self.targetedObject) ~= 0 then
                    if self.isServer then
                        EasyDevControlsUtils.deleteTree(self.targetedObject, isTree, not isLog)
                    else
                        g_client:getServerConnection():sendEvent(EasyDevControlsDeleteObjectEvent.new(self.targetedObjectType, self.targetedObject))
                    end
                end
            end
        end
    end

    self.targetedObjectType = nil
    self.targetedObject = nil
end

function EasyDevControls:onInputSuperStrength(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    if self:getHasPermission("superStrength") then
        self:setSuperStrengthState(not self.superStrengthEnabled)
    else
        g_currentMission:showBlinkingWarning(self.texts.noPermissionSuperStrength, 2000)
    end
end

-- Action Event Callbacks (Global)
function EasyDevControls:onInputOpenMenu(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    self.guiManager:onOpenEasyDevControlsScreen()
    -- g_messageCenter:publish(MessageType.EDC_GUI_OPEN_SCREEN, nil)
end

function EasyDevControls:onInputToggleHud(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    if g_currentMission ~= nil and g_currentMission.hud ~= nil then
        g_currentMission.hud:consoleCommandToggleVisibility()
    end
end

function EasyDevControls:onInputReloadGame(actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    if self.reloadInputActionEnabled then
        EasyDevControlsUtils.doRestart(Utils.getNoNil(self.reloadInputActionClearLog, false), Utils.getNoNil(self.reloadInputActionRestartProcess, false), "")
    end
end

-- Misc
function EasyDevControls:setTexts()
    self.texts = {
        noPermissionSuperStrength = string.format("%s (%s)", g_i18n:getText("shop_messageNoPermissionGeneral"), EasyDevControlsUtils.getText("easyDevControls_superStrengthTitle")),
        runSpeedEnabled = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_runSpeedTitle"), EasyDevControlsUtils.getText("easyDevControls_enabled")),
        runSpeedDisabled = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_runSpeedTitle"), EasyDevControlsUtils.getText("easyDevControls_disabled")),
        requestFailed = EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"),
        serverRequest = EasyDevControlsUtils.getText("easyDevControls_serverRequestMessage"),
        deleteObject = EasyDevControlsUtils.getText("easyDevControls_deleteObject"),
        deleteBale = EasyDevControlsUtils.formatText("easyDevControls_deleteObject", EasyDevControlsUtils.getText("easyDevControls_typeBale")),
        deletePallet = EasyDevControlsUtils.formatText("easyDevControls_deleteObject", EasyDevControlsUtils.getText("easyDevControls_typePallet")),
        deleteLog = EasyDevControlsUtils.formatText("easyDevControls_deleteObject", EasyDevControlsUtils.getText("easyDevControls_typeLog")),
        deleteStump = EasyDevControlsUtils.formatText("easyDevControls_deleteObject", EasyDevControlsUtils.getText("easyDevControls_infohud_stump")),
        deleteTree = EasyDevControlsUtils.formatText("easyDevControls_deleteObject", EasyDevControlsUtils.getText("easyDevControls_infohud_tree"))
    }
end

function EasyDevControls:clientSendEvent(eventClass, ...)
    if self.isClient and eventClass ~= nil then
        g_messageCenter:publish(MessageType.EDC_SERVER_REQUEST_SENT, eventClass, self.texts.serverRequest, g_client.currentLatency)
        g_client:getServerConnection():sendEvent(eventClass.new(...))

        if eventClass.NO_REPLY then
            return self.texts.serverRequest, EasyDevControlsErrorCodes.SUCCESS
        end

        return "", EasyDevControlsErrorCodes.SUCCESS
    end

    return self.texts.requestFailed, EasyDevControlsErrorCodes.FAILED
end

function EasyDevControls:getVehicle(ignoreFarm, getRootVehicle, uniqueId)
    local player = g_localPlayer

    if uniqueId ~= nil then
        local vehicle = g_currentMission.vehicleSystem:getVehicleByUniqueId(uniqueId)

        if player ~= nil then
            return vehicle, vehicle == player:getCurrentVehicle()
        end

        return vehicle, false
    end

    if player ~= nil then
        local vehicle = player:getCurrentVehicle()

        if vehicle ~= nil then
            return vehicle, true
        end

        if player.isControlled and player.hudUpdater ~= nil then
            local hudUpdater = player.hudUpdater
            local object = hudUpdater.object

            if hudUpdater.object ~= nil and (hudUpdater.isVehicle or hudUpdater.isPallet) then
                ignoreFarm = ignoreFarm or (self.isServer or self.isMasterUser)

                if ignoreFarm or (hudUpdater.object:getOwnerFarmId() == player.farmId) then
                    if getRootVehicle then
                        return hudUpdater.object:findRootVehicle() or hudUpdater.object, false
                    end

                    return hudUpdater.object, false
                end
            end
        end
    end

    return nil, false
end

function EasyDevControls:getSelectedVehicle(requiredName, ignoreFarm, uniqueId)
    local vehicle, isEntered = self:getVehicle(ignoreFarm, false, uniqueId)

    if vehicle ~= nil then
        if isEntered then
            if vehicle.getSelectedObject == nil then
                return nil
            end

            local selectedObject = vehicle:getSelectedObject()

            if selectedObject ~= nil and EasyDevControlsUtils.getIsValidVehicle(selectedObject.vehicle, requiredName) then
                return selectedObject.vehicle
            end
        end

        if EasyDevControlsUtils.getIsValidVehicle(vehicle, requiredName) then
            return vehicle
        end
    end

    return nil
end

function EasyDevControls:getIsMultiplayer()
    return self.isMultiplayer or g_easyDevControlsSimulateMultiplayer
end

function EasyDevControls:getIsMasterUser(connection)
    return self.guiManager:getIsMasterUser(connection)
end

function EasyDevControls:getHasPermission(name)
    return self.guiManager:getHasPermission(name)
end

-- Settings (name, value, mpValue, canSave, callback, callbackTarget)
-- Note: Some setting are not permitted to be saved, too many potential problems.
function EasyDevControls:addSettings(settings)
    local canSave = g_dedicatedServer == nil

    -- Gui Manager Settings
    self.guiManager:addSettings(settings)

    -- Show or hide input bindings
    -- Note: Future In-Game Menu setting but for now could be edited in 'C:\Users\%USERNAME%\Documents\My Games\FarmingSimulator2025\modSettings\FS25_EasyDevControls\defaultUserSettings.xml')
    settings:addSetting("openMenuKeyVisible", false, nil, canSave)
    settings:addSetting("hudVisibilityKeyVisible", false, nil, canSave)
    settings:addSetting("runSpeedKeyVisible", false, nil, canSave)
    settings:addSetting("superStrengthKeyVisible", false, nil, canSave)

    settings:addSetting("extraTimeScales", false, nil, true, EasyDevControls.setCustomTimeScaleState, self)
    settings:addSetting("hudVisibilityKey", true, nil, canSave, EasyDevControls.setToggleHudInputEnabled, self)
    settings:addSetting("deleteObjectsKey", false, false, false, EasyDevControls.setDeleteObjectsInputEnabled, self)
    settings:addSetting("showBaleLocations", false, false, canSave, EasyDevControls.showBaleLocations, self)
    settings:addSetting("showPalletLocations", false, false, canSave, EasyDevControls.showPalletLocations, self)

    settings:addSetting("superStrength", false, false, canSave, EasyDevControls.setSuperStrengthEnabled, self)
    settings:addSetting("superStrengthKey", false, nil, canSave, EasyDevControls.setSuperStrengthInputEnabled, self)
    settings:addSetting("jumpDelayIndex", EasyDevControlsPlayerFrame.JUMP_DELAY_DEFAULT_INDEX, nil, canSave, EasyDevControls.setPlayerJumpDelay, self)
    settings:addSetting("jumpHeightIndex", EasyDevControlsPlayerFrame.JUMP_HEIGHT_DEFAULT_INDEX, nil, canSave, EasyDevControls.setPlayerJumpMultiplier, self)
    settings:addSetting("runSpeedIndex", EasyDevControlsPlayerFrame.RUN_SPEED_DEFAULT_INDEX, nil, canSave, EasyDevControls.setRunSpeedMultiplier, self)
    settings:addSetting("runSpeedState", false, nil, canSave, EasyDevControls.setRunSpeedState, self)
    settings:addSetting("runSpeedKey", false, nil, canSave, EasyDevControls.setRunSpeedInputEnabled, self)
    settings:addSetting("playerNoClip", false, nil, false)
    settings:addSetting("woodCuttingMarker", true, nil, false) -- Not saved because it could cause confusion to some players
    settings:addSetting("aimOverlay", true, nil, false) -- Not saved because it could cause confusion to some players
end

-- Console Commands
function EasyDevControls:consoleCommandClearLogFile()
    if EasyDevControlsUtils.clearGameLogFile() then
        return "Game log file was cleared."
    end

    return "Failed to clear game log file."
end

function EasyDevControls:consoleCommandSaveGame(...)
    if g_currentMission == nil or not self.gameStarted then
        return "Game has not been started yet."
    end

    local savegameName = table.concat({...}, " ") -- Combine all parameters to allow for spaces

    if not string.isNilOrWhitespace(savegameName) then
        g_currentMission:setSavegameName(savegameName, true)
    end

    g_currentMission:saveSavegame(true)
end

function EasyDevControls:consoleCommandQuitGame(restartProcess, arguments)
    EasyDevControlsUtils.doRestart(true, Utils.stringToBoolean(restartProcess), arguments)
end

function EasyDevControls:consoleCommandPrintScenegraph(nodeName, visibleOnly, clearLog)
    local node = getRootNode()

    nodeName = nodeName or "rootNode"
    nodeNameUpper = nodeName:upper()

    if nodeNameUpper ~= "ROOTNODE" then
        if nodeNameUpper == "TREES" then
            if g_treePlantManager.treesData ~= nil then
                node = g_treePlantManager.treesData.rootNode
            end
        else
            node = getChild(node, nodeName)
        end
    end

    if node == nil or node == 0 then
        return "Failed to find valid scenegraph node"
    end

    if clearLog ~= "false" then
        EasyDevControlsUtils.clearGameLogFile()
    end

    setFileLogPrefixTimestamp(false)

    printScenegraph(node, Utils.stringToBoolean(visibleOnly))

    setFileLogPrefixTimestamp(g_logFilePrefixTimestamp)

    return
end

function EasyDevControls:consoleCommandPrintEnvironment(path, ...)
    -- TO_DO: Add commands like the advanced versions now included in my INTERNAL debugger.
    -- EasyDevControlsUtils.getPathFromString(env, pathString)

    return "Debug console commands are currently not available but are marked to return. If this is a feature you liked please let me know on GitHub and I will adjust the priority."
end

function EasyDevControls:consoleCommandCreateSettingsTemplate(savePermissions)
    if not self.gameStarted then
        return "Game has not been started yet."
    end

    local templatesDir = EasyDevControlsUtils.createFolder("templates/")
    local xmlFilename = templatesDir .. "defaultUserSettings.xml"
    local xmlFile = XMLFile.create("easyDevControlsDefaultSettingsXML", xmlFilename, "easyDevControls", EasyDevControls.xmlSchema)

    if xmlFile ~= nil then
        xmlFile:setInt("easyDevControls#revision", 1)

        xmlFile:setSortedTable("easyDevControls.settings.setting", g_easyDevControlsSettings.settings, function(key, setting)
            xmlFile:setString(key .. "#name", setting.name)

            if setting.typeName == "number" then
                xmlFile:setInt(key .. "#intValue", setting.value)
            elseif setting.typeName == "boolean" then
                xmlFile:setBool(key .. "#boolValue", setting.value)
            elseif setting.typeName == "string" then
                xmlFile:setString(key .. "#stringValue", setting.value)
            end

            if setting.canSave then
                xmlFile:setBool(key .. "#isSaved", setting.isSaved)
            end
        end)

        if Utils.stringToBoolean(savePermissions) then
            xmlFile:setString("easyDevControls.permissions#adminPassword", "USE_SERVER_PASSWORD")

            xmlFile:setSortedTable("easyDevControls.permissions.permission", g_easyDevControlsGuiManager.permissions, function(key, permission)
                xmlFile:setString(key .. "#name", permission.name)
                EasyDevControlsAccessLevel.saveToXMLFile(xmlFile, key .. "#accessLevel", permission.accessLevel)
            end)
        end

        xmlFile:save()
        xmlFile:delete()

        return "XML file created at '" .. xmlFilename .. "'"
    end

    if not EasyDevControlsUtils.getIsUpdate() then
        local files = Files.getFilesRecursive(templatesDir)

        if files ~= nil and #files == 0 then
            deleteFolder(templatesDir)
        end
    end

    return "Failed to create XML"
end

-- function EasyDevControls.registerXMLPaths(schema, baseKey)

-- end

-- XML Data
-- g_xmlManager:addCreateSchemaFunction(function()
    -- EasyDevControls.xmlSchema = XMLSchema.new("easyDevControls")
-- end)

-- g_xmlManager:addInitSchemaFunction(function()
    -- local schema = EasyDevControls.xmlSchema

    -- -- Bug Reporting
    -- schema:register(XMLValueType.FLOAT, "easyDevControls#buildId", "Build ID")
    -- schema:register(XMLValueType.STRING, "easyDevControls#version", "Version string")
    -- schema:register(XMLValueType.STRING, "easyDevControls#type", "Release type")

    -- EasyDevControls.registerXMLPaths(schema, "easyDevControls")
    -- EasyDevControlsGuiManager.registerXMLPaths(schema, "easyDevControls")
    -- EasyDevControlsSettingsModel.registerXMLPaths(schema, "easyDevControls")
-- end)
