-- EconomyHUD.lua v1.0 (FS25) — Author: NoticeGG

EconomyHUD = {}
EconomyHUD_mt = Class(EconomyHUD)

EconomyHUD.SHOW_RADIUS = 12
EconomyHUD.HIDE_RADIUS = 18

function EconomyHUD:new(economyMod)
    local o = setmetatable({}, EconomyHUD_mt)
    o.mod           = economyMod
    o.nearSellPoint = nil
    o.bgOverlayObj  = nil
    o.isVisible     = false

    pcall(function()
        if g_overlayManager and g_overlayManager.createOverlay then
            o.bgOverlayObj = g_overlayManager:createOverlay("gui.shortcutBox1_middle", 0, 0, 0, 0)
        end
    end)
    return o
end

function EconomyHUD:delete()
    if self.bgOverlayObj and self.bgOverlayObj.delete then
        pcall(function() self.bgOverlayObj:delete() end)
    end
end

function EconomyHUD:getFillTypeTitle(fillTypeIndex)
    local ft = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
    if ft then return ft.title or ft.name or tostring(fillTypeIndex) end
    return tostring(fillTypeIndex)
end

function EconomyHUD:utf8sub(str, maxChars)
    if not str then return "" end
    local charCount = 0
    local bytePos = 1
    while bytePos <= #str and charCount < maxChars do
        local byte = str:byte(bytePos)
        if byte < 128 then bytePos = bytePos + 1
        elseif byte < 224 then bytePos = bytePos + 2
        elseif byte < 240 then bytePos = bytePos + 3
        else bytePos = bytePos + 4 end
        charCount = charCount + 1
    end
    return str:sub(1, bytePos - 1)
end

function EconomyHUD:getStationPosition(sp)
    -- PREFER unload trigger positions — these are the actual sell points
    -- The owningPlaceable rootNode can be far from the actual unload area
    if sp.unloadTriggers then
        for _, trigger in pairs(sp.unloadTriggers) do
            local tNode = trigger.exactFillRootNode or trigger.triggerNode
            if tNode and tNode ~= 0 then
                local ok, x, y, z = pcall(getWorldTranslation, tNode)
                if ok and x then return x, y, z end
            end
        end
    end
    -- Fallback: station's own root
    if sp.rootNode and sp.rootNode ~= 0 then
        local ok, x, y, z = pcall(getWorldTranslation, sp.rootNode)
        if ok and x then return x, y, z end
    end
    if sp.nodeId and sp.nodeId ~= 0 then
        local ok, x, y, z = pcall(getWorldTranslation, sp.nodeId)
        if ok and x then return x, y, z end
    end
    -- Last resort: owning placeable
    if sp.owningPlaceable then
        local p = sp.owningPlaceable
        local node = p.rootNode
        if not node and p.components and p.components[1] then node = p.components[1].node end
        if node and node ~= 0 then
            local ok, x, y, z = pcall(getWorldTranslation, node)
            if ok and x then return x, y, z end
        end
    end
    return nil, nil, nil
end

function EconomyHUD:getPlayerPosition()
    local px, py, pz

    -- Method 1: Controlled vehicle (when driving)
    pcall(function()
        local vehicle = g_currentMission.controlledVehicle
        if vehicle then
            local node = vehicle.rootNode
            if not node or node == 0 then
                if vehicle.components and vehicle.components[1] then
                    node = vehicle.components[1].node
                end
            end
            if node and node ~= 0 then
                px, py, pz = getWorldTranslation(node)
            end
        end
    end)
    if px then return px, py, pz end

    -- Method 2: Player on foot
    pcall(function()
        if g_localPlayer then
            if g_localPlayer.rootNode and g_localPlayer.rootNode ~= 0 then
                px, py, pz = getWorldTranslation(g_localPlayer.rootNode)
            elseif g_localPlayer.baseInformation and g_localPlayer.baseInformation.lastPositionX then
                local bi = g_localPlayer.baseInformation
                px, py, pz = bi.lastPositionX, bi.lastPositionY, bi.lastPositionZ
            end
        end
    end)
    if px then return px, py, pz end

    -- Method 3: mission.player
    pcall(function()
        local player = g_currentMission.player
        if player and player.rootNode and player.rootNode ~= 0 then
            px, py, pz = getWorldTranslation(player.rootNode)
        end
    end)
    return px, py, pz
end

function EconomyHUD:update(dt)
    local px, py, pz = self:getPlayerPosition()
    if not px then
        self.isVisible = false
        self.nearSellPoint = nil
        return
    end

    local radius = self.nearSellPoint and EconomyHUD.HIDE_RADIUS or EconomyHUD.SHOW_RADIUS
    local radiusSq = radius * radius

    local nearest = nil
    local nearestDist2 = radiusSq

    for _, sp in pairs(self.mod:getAllSellPoints()) do
        local sx, sy, sz = self:getStationPosition(sp)
        if sx then
            local d2 = (px-sx)*(px-sx) + (pz-sz)*(pz-sz)
            if d2 < nearestDist2 then
                nearestDist2 = d2
                nearest = sp
            end
        end
    end

    self.nearSellPoint = nearest
    self.isVisible = nearest ~= nil
end

function EconomyHUD:draw()
    local guiVisible = false
    pcall(function() guiVisible = g_gui:getIsGuiVisible() end)
    if guiVisible then return end

    pcall(function() self:drawEventBar() end)

    if self.isVisible and self.nearSellPoint then
        pcall(function() self:drawStationPanel() end)
    end
end

function EconomyHUD:drawStationPanel()
    local sp = self.nearSellPoint

    local summary = {}
    if sp.acceptedFillTypes then
        for fillTypeIndex, accepted in pairs(sp.acceptedFillTypes) do
            if accepted then
                local state = self.mod:ensureState(sp, fillTypeIndex)
                if state then
                    local evMult = self.mod:getActiveEventMultiplier(sp, fillTypeIndex)
                    local raw = math.max(0.85, math.min(1.15, state.index + state.lureBonus))
                    table.insert(summary, {
                        title = self:getFillTypeTitle(fillTypeIndex),
                        index = raw * evMult,
                    })
                end
            end
        end
    end
    table.sort(summary, function(a, b) return a.title < b.title end)
    if #summary == 0 then return end

    local ROW_H = 0.014
    local FONT = 0.0085
    local FONT_HEAD = 0.009
    local PAD = 0.004
    local panelW = 0.17
    local PX = 1.0 - panelW - 0.005
    local maxRows = math.min(#summary, 30)
    local panelH = (maxRows + 1) * ROW_H + PAD * 2 + 0.002

    -- Position below event bar
    local eventBarBottom = 0.0
    local events = self.mod:getActiveEventsList()
    if #events > 0 then
        local evLines = 1
        for _, ev in ipairs(events) do
            evLines = evLines + 1
            local desc = ev.desc or ""
            evLines = evLines + math.ceil(#desc / 47)
            if ev.fillTypesDisplay and ev.fillTypesDisplay ~= "" then evLines = evLines + 1 end
        end
        local evH = evLines * 0.012 + 0.008
        eventBarBottom = 0.88 - evH - 0.025
    else
        eventBarBottom = 0.88
    end
    local PY = eventBarBottom - panelH

    self:drawRect(PX, PY, panelW, panelH, 0.02, 0.02, 0.05, 0.82)

    local curY = PY + panelH - PAD - ROW_H * 0.3

    local stationName = ""
    pcall(function()
        if sp.owningPlaceable and sp.owningPlaceable.getName then
            stationName = sp.owningPlaceable:getName() or ""
        end
    end)
    if stationName == "" then stationName = "Точка продажи" end

    self:drawText(PX + PAD, curY, self:utf8sub(stationName, 30), FONT_HEAD, 0.95, 0.82, 0.22, 1)
    curY = curY - ROW_H
    self:drawRect(PX + PAD, curY + ROW_H * 0.5, panelW - PAD * 2, 0.0006, 0.40, 0.40, 0.40, 0.5)
    curY = curY - ROW_H * 0.15

    local shown = 0
    for _, d in ipairs(summary) do
        if shown >= maxRows then break end
        shown = shown + 1
        local nowPct = (d.index - 1.0) * 100
        local r, g, b
        if nowPct > 5 then r, g, b = 0.25, 0.92, 0.35
        elseif nowPct < -5 then r, g, b = 0.95, 0.32, 0.25
        else r, g, b = 0.80, 0.80, 0.80 end
        self:drawText(PX + PAD, curY, self:utf8sub(d.title, 18), FONT, r, g, b, 1)
        self:drawText(PX + panelW - PAD - 0.025, curY, string.format("%+.0f%%", nowPct), FONT, r, g, b, 1)
        curY = curY - ROW_H
    end
end

function EconomyHUD:drawEventBar()
    local events = self.mod:getActiveEventsList()
    if #events == 0 then return end

    local LINE_H = 0.012
    local FONT_HEAD = 0.009
    local FONT_TITLE = 0.0085
    local FONT_DESC = 0.0075
    local PAD = 0.004
    local panelW = 0.17

    local allLines = {}
    for _, ev in ipairs(events) do
        local sign = ev.multiplier >= 1.0 and "+" or ""
        local pct = (ev.multiplier - 1.0) * 100
        table.insert(allLines, {type="title", text=string.format("%s  %s%.0f%%", ev.title, sign, pct), neg=ev.isNegative})
        local desc = ev.desc or ""
        local pos = 1
        while pos <= #desc do
            local chunk = desc:sub(pos, pos + 47)
            if pos + 47 < #desc then
                local bp = chunk:reverse():find(" ")
                if bp and bp < 20 then chunk = chunk:sub(1, #chunk - bp) end
            end
            table.insert(allLines, {type="desc", text=chunk})
            pos = pos + #chunk
            if desc:sub(pos, pos) == " " then pos = pos + 1 end
        end
        if ev.fillTypesDisplay and ev.fillTypesDisplay ~= "" then
            table.insert(allLines, {type="fills", text=ev.fillTypesDisplay})
        end
    end

    local totalLines = 1 + #allLines
    local panelH = totalLines * LINE_H + PAD * 2

    local PX = 1.0 - panelW - 0.005
    local PY = 0.88 - panelH

    self:drawRect(PX, PY, panelW, panelH, 0.02, 0.02, 0.05, 0.82)

    local curY = PY + panelH - PAD - LINE_H * 0.3

    self:drawText(PX + PAD, curY, "СОБЫТИЕ РЫНКА", FONT_HEAD, 0.95, 0.82, 0.22, 1)
    curY = curY - LINE_H

    for _, line in ipairs(allLines) do
        if line.type == "title" then
            local r, g, b
            if line.neg then r, g, b = 1.0, 0.50, 0.25
            else r, g, b = 0.35, 0.85, 1.0 end
            self:drawText(PX + PAD, curY, line.text, FONT_TITLE, r, g, b, 1)
        elseif line.type == "fills" then
            self:drawText(PX + PAD, curY, line.text, FONT_DESC, 0.85, 0.75, 0.45, 1)
        else
            self:drawText(PX + PAD, curY, line.text, FONT_DESC, 0.62, 0.62, 0.62, 0.9)
        end
        curY = curY - LINE_H
    end
end

function EconomyHUD:drawRect(x, y, w, h, r, g, b, a)
    if self.bgOverlayObj then
        self.bgOverlayObj:setPosition(x, y)
        self.bgOverlayObj:setDimension(w, h)
        self.bgOverlayObj:setColor(r, g, b, a or 0.8)
        self.bgOverlayObj:draw()
    end
end

function EconomyHUD:drawText(x, y, str, size, r, g, b, a)
    setTextBold(false)
    setTextColor(r or 1, g or 1, b or 1, a or 1)
    setTextAlignment(RenderText.ALIGN_LEFT)
    renderText(x, y, size, tostring(str))
    setTextColor(1, 1, 1, 1)
end

return EconomyHUD
