--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
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

EasyDevControlsDebugManager = {}

local EasyDevControlsDebugManager_mt = Class(EasyDevControlsDebugManager)
local emptyTable = {}

function EasyDevControlsDebugManager.new()
    local self = setmetatable({}, EasyDevControlsDebugManager_mt)

    self.productionChainDebugEnabled = false
    self.productionChainDebugFunctionId = nil

    self.testAreasDebugEnabled = false
    self.testAreasDebugFunctionId = nil

    return self
end

function EasyDevControlsDebugManager:delete()
    self:setProductionPointsDebugEnabled(false)
    self:setTestAreasDebugEnabled(false)
end

function EasyDevControlsDebugManager:getDebugIsEnabledByName(name)
    if name == "productionPointsDebug" then
        return self.productionChainDebugEnabled
    elseif name == "testAreasDebug" then
        return self.testAreasDebugEnabled
    end

    return false
end

-----------------------------
-- Production Points Debug --
-----------------------------

function EasyDevControlsDebugManager:setProductionPointsDebugEnabled(enabled)
    if g_currentMission ~= nil then
        enabled = Utils.getNoNil(enabled, false)

        if self.productionChainDebugFunctionId ~= nil then
            g_debugManager:removeElementById(self.productionChainDebugFunctionId)
            self.productionChainDebugFunctionId = nil
        end

        if enabled then
            local debugFunction = DebugFunction.new(nil, EasyDevControlsDebugManager.onDrawProductionPointsDebug, nil, EasyDevControlsDebugManager.onDeleteProductionPointsDebug)

            debugFunction.texts = {}
            debugFunction.manager = self

            self.productionChainDebugFunctionId = g_debugManager:addElement(debugFunction)
        end

        self.productionChainDebugEnabled = enabled
    end

    return self.productionChainDebugEnabled
end

function EasyDevControlsDebugManager:getProductionPointsDebugIsEnabled()
    return self.productionChainDebugEnabled
end

function EasyDevControlsDebugManager.onDrawProductionPointsDebug(debugFunc)
    if g_currentMission == nil or g_currentMission.productionChainManager == nil then
        return
    end

    if debugFunc.texts == nil then
        debugFunc.texts = {}
    end

    for _, pp in pairs(g_currentMission.productionChainManager.productionPoints or emptyTable) do
        local rootNode = g_localPlayer:getCurrentRootNode()

        local px, py, pz = getWorldTranslation(rootNode)
        local ppx, ppy, ppz = getWorldTranslation(pp.node)

        local distance = MathUtil.vector3Length(px - ppx, py - ppy, pz - ppz)

        if distance < 40 then
            local text = {}

            table.insert(text, string.format("PP %s (%s) | ownerFarmId: %s | isOwned: %s", pp:getName(), pp:tableId(), pp.ownerFarmId, pp.isOwned))

            for i = 1, #pp.productions do
                local production = pp.productions[i]

                table.insert(text, string.format("  prodId '%s': cyclesPerMinute: %.2f | enabled: %s", production.id, production.cyclesPerMinute, table.hasElement(pp.activeProductions, production)))

                for n = 1, #production.inputs do
                    local input = production.inputs[n]

                    table.insert(text, string.format("    input: %s: %.2f", g_fillTypeManager:getFillTypeNameByIndex(input.type), input.amount))
                end

                for n = 1, #production.outputs do
                    local output = production.outputs[n]

                    table.insert(text, string.format("    output: %s: %.2f | directSell: %s | autoDeliver: %s", g_fillTypeManager:getFillTypeNameByIndex(output.type), output.amount, tostring(pp.outputFillTypeIdsDirectSell[output.type] == true), tostring(pp.outputFillTypeIdsAutoDeliver[output.type] == true)))
                end
            end

            -- No client data available
            if pp.isServer then
                table.insert(text, string.format("productionCostsToClaim : %.1f", pp.productionCostsToClaim))
                table.insert(text, string.format("waitingForPalletToSpawn: %s", pp.waitingForPalletToSpawn))

                if g_time < pp.palletSpawnCooldown then
                    table.insert(text, string.format("palletSpawnCooldown: %.1f sec", (pp.palletSpawnCooldown - g_time) / 1000))
                end
            end

            local debugText = debugFunc.texts[pp]

            if debugText == nil then
                local node = pp.node

                if pp.interactionTriggerNode ~= nil then
                    node = pp.interactionTriggerNode
                elseif pp.storage ~= nil then
                    node = pp.storage.rootNode
                end

                local x, y, z = getWorldTranslation(node)

                debugText = DebugText3D.new()
                debugText:createWithWorldPos(x, y, z, 0, 0, 0, "", 0.05)
                debugText.node = node

                debugFunc.texts[pp] = debugText
            end

            if pp.storage ~= nil then
                local storage = pp.storage

                table.insert(text, " ")

                for fillType, accepted in pairs(storage.fillTypes) do
                    if accepted then
                        table.insert(text, string.format("%s : %.3f / %.3f", g_fillTypeManager:getFillTypeNameByIndex(fillType), storage.fillLevels[fillType] or 0, storage.capacities[fillType] or storage.capacity or -1))
                    end
                end
            end

            local x, y, z = localToWorld(debugText.node or pp.node, 0, 1, 0)
            local cx, cy, cz = getWorldTranslation(g_cameraManager:getActiveCamera())
            local dirX, _, dirZ = MathUtil.vector3Normalize(cx - x, cy - y, cz - z)

            debugText.ry = MathUtil.getYRotationFromDirection(dirX, dirZ)
            debugText.y = py + 1.2

            debugText:setText(table.concat(text, "\n"))
            debugText:draw()
        end
    end
end

function EasyDevControlsDebugManager.onDeleteProductionPointsDebug(debugFunc)
    local manager = debugFunc.manager or g_easyDevControlsDebugManager

    if manager ~= nil then
        if manager.productionChainDebugFunctionId ~= nil and g_debugManager ~= nil then
            g_debugManager:removeElementById(manager.productionChainDebugFunctionId)
        end

        manager.productionChainDebugEnabled = false
        manager.productionChainDebugFunctionId = nil
    end

    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "productionPointsDebug", EasyDevControlsPlaceablesFrame.NAME)
end

-------------------------------
-- Placeable Test Area Debug --
-------------------------------

function EasyDevControlsDebugManager:setTestAreasDebugEnabled(enabled)
    if g_currentMission ~= nil and g_currentMission.placeableSystem ~= nil then
        enabled = Utils.getNoNil(enabled, false)

        if self.testAreasDebugFunctionId ~= nil then
            g_debugManager:removeElementById(self.testAreasDebugFunctionId)
            self.testAreasDebugFunctionId = nil
        end

        if enabled then
            local debugFunction = DebugFunction.new(nil, EasyDevControlsDebugManager.onDrawTestAreasDebug, nil, EasyDevControlsDebugManager.onDeleteTestAreasDebug)

            debugFunction.placeableToDebugTestAreas = {}
            debugFunction.manager = self

            self.testAreasDebugFunctionId = g_debugManager:addElement(debugFunction)
        end

        self.testAreasDebugEnabled = enabled
    end

    return self.testAreasDebugEnabled
end

function EasyDevControlsDebugManager:getTestAreasDebugIsEnabled()
    return self.testAreasDebugEnabled
end

function EasyDevControlsDebugManager.onDrawTestAreasDebug(debugFunc)
    if g_currentMission.placeableSystem == nil then
        return
    end

    if debugFunc.placeableToDebugTestAreas == nil then
        debugFunc.placeableToDebugTestAreas = {}
    end

    for _, placeable in ipairs(g_currentMission.placeableSystem.placeables) do
        local spec = placeable.spec_placement

        if spec ~= nil then
            local debugTestAreas = debugFunc.placeableToDebugTestAreas[placeable]

            if debugTestAreas == nil then
                debugTestAreas = {}
                debugFunc.placeableToDebugTestAreas[placeable] = debugTestAreas
            end

            for _, testArea in ipairs(spec.testAreas) do
                local debugTestArea = debugTestAreas[testArea]

                if debugTestArea == nil then
                    debugTestArea = {
                        areaBox = DebugBox.new():createWithStartEnd(testArea.startNode, testArea.endNode):setSize(testArea.size.x, testArea.size.y, testArea.size.z):setColor(Color.PRESETS.GREEN),
                        startNode = DebugGizmo.new():createWithNode(testArea.startNode, getName(testArea.startNode), false, nil),
                        endNode = DebugGizmo.new():createWithNode(testArea.endNode, getName(testArea.endNode), false, nil),
                        areaPlane = DebugPlane.newSimple(true, false, Color.PRESETS.GREEN, true):createWithStartEnd(testArea.startNode, testArea.endNode)
                    }

                    debugTestAreas[testArea] = debugTestArea
                end

                debugTestArea.areaBox:draw()
                debugTestArea.startNode:draw()
                debugTestArea.endNode:draw()
                debugTestArea.areaPlane:draw()
            end
        end
    end
end

function EasyDevControlsDebugManager.onDeleteTestAreasDebug(debugFunc)
    local manager = debugFunc.manager or g_easyDevControlsDebugManager

    if manager ~= nil then
        if manager.testAreasDebugFunctionId ~= nil and g_debugManager ~= nil then
            g_debugManager:removeElementById(manager.testAreasDebugFunctionId)
        end

        manager.testAreasDebugEnabled = false
        manager.testAreasDebugFunctionId = nil
    end

    g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "testAreasDebug", EasyDevControlsPlaceablesFrame.NAME)
end

-----------------
-- Development --
-----------------

function EasyDevControlsDebugManager.init()
    if g_easyDevControlsDebugManager ~= nil then
        g_easyDevControlsDebugManager:delete()
        g_easyDevControlsDebugManager = nil
    end

    g_easyDevControlsDebugLevel = 0
    g_easyDevControlsDevelopmentMode = false
    g_easyDevControlsSimulateMultiplayer = false

    g_easyDevControlsDebugManager = EasyDevControlsDebugManager.new()
end

function EasyDevControlsDebugManager:setDevelopmentDebugLevel(debugLevel)
    debugLevel = math.clamp(debugLevel or 0, 0, 4)

    if debugLevel ~= g_easyDevControlsDebugLevel then
        g_easyDevControlsDebugLevel = debugLevel
        g_easyDevControlsDevelopmentMode = debugLevel > 0

        -- Auto validate and wrap functions when at highest level
        if debugLevel == 4 and EasyDevControlsUtils ~= nil then
            if EasyDevControlsUtils.validate ~= nil then
                EasyDevControlsUtils.validate()
            end

            if EasyDevControlsUtils.wrapFunctions ~= nil then
                EasyDevControlsUtils.wrapFunctions(false, true)
            end
        end

        if MessageType.EDC_DEBUG_LEVEL_CHANGED ~= nil then
            g_messageCenter:publish(MessageType.EDC_DEBUG_LEVEL_CHANGED)
        end
    end
end

EasyDevControlsDebugManager.init()
