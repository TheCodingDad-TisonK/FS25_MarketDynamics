-- Name: RS_settings
-- Author: DonQuacko

RS_invoiceSettings = {}

RS_invoiceSettings.SETTINGS = {}
RS_invoiceSettings.CONTROLS = {}

-- Which settings should appear in the settings menu (order matters)
RS_invoiceSettings.menuItems = {
    'rsVatPercent',
    'rsMaxOpenInvoices',
    'rsInterestPercent',
    'rsInterestIntervalDays'
}


-- Default setting definitions
RS_invoiceSettings.SETTINGS.rsVatPercent = {
    ['default'] = 3,
    ['serverOnly'] = true,
    ['values'] = { 0, 7, 19, 20 },
    ['strings'] = { "0%", "7%", "19%", "20%" }
}

RS_invoiceSettings.SETTINGS.rsMaxOpenInvoices = {
    ['default'] = 2,
    ['serverOnly'] = true,
    ['values'] = { 5, 10, 15, 20 },
    ['strings'] = { "5", "10", "15", "20" }
}



RS_invoiceSettings.SETTINGS.rsInterestPercent = {
    ['default'] = 1,
    ['serverOnly'] = true,
    ['values'] = { 0, 2, 5, 10 },
    ['strings'] = { "0%", "2%", "5%", "10%" }
}

RS_invoiceSettings.SETTINGS.rsInterestIntervalDays = {
    ['default'] = 3,
    ['serverOnly'] = true,
    ['values'] = { 1, 2, 3, 7 },
    ['strings'] = { "1 Tag", "2 Tage", "3 Tage", "7 Tage" }
}

function RS_invoiceSettings.getStateIndex(id, value)
    local current = value
    if current == nil and g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
        current = g_currentMission.rsInvoiceSettings[id]
    end

    local values = RS_invoiceSettings.SETTINGS[id].values

    if type(current) == 'number' then
        local index = RS_invoiceSettings.SETTINGS[id].default
        local initialDiff = math.huge
        for i, v in pairs(values) do
            local currentDiff = math.abs((tonumber(v) or 0) - (tonumber(current) or 0))
            if currentDiff < initialDiff then
                initialDiff = currentDiff
                index = i
            end
        end
        return index
    else
        for i, v in pairs(values) do
            if current == v then
                return i
            end
        end
    end

    return RS_invoiceSettings.SETTINGS[id].default
end


RS_invoiceSettingsControls = {}

function RS_invoiceSettingsControls.onMenuOptionChanged(self, state, menuOption)
    local id = menuOption.id
    local setting = RS_invoiceSettings.SETTINGS
    local value = setting[id].values[state]

    if value ~= nil and g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
        g_currentMission.rsInvoiceSettings[id] = value
    end

    if g_client ~= nil and g_client.getServerConnection ~= nil then
        g_client:getServerConnection():sendEvent(RS_settingsEvent.new(g_currentMission.rsInvoiceSettings))
    end
end


local function updateFocusIds(element)
    if not element then
        return
    end
    element.focusId = FocusManager:serveAutoFocusId()
    for _, child in pairs(element.elements) do
        updateFocusIds(child)
    end
end


function RS_invoiceSettings:applySettings(newSettings, isAuthoritative)
    if g_currentMission == nil then
        return
    end

    g_currentMission.rsInvoiceSettings = g_currentMission.rsInvoiceSettings or {}
    local s = g_currentMission.rsInvoiceSettings

    -- Sanitize values: only allow whitelisted values
    for _, id in ipairs(self.menuItems) do
        local def = self.SETTINGS[id]
        local candidate = nil
        if newSettings ~= nil then
            candidate = newSettings[id]
        end

        local ok = false
        for _, v in ipairs(def.values) do
            if candidate == v then
                ok = true
                break
            end
        end

        if ok then
            s[id] = candidate
        elseif s[id] == nil then
            s[id] = def.values[def.default]
        end
    end

    -- Apply runtime effects
    if g_rs_invoiceManager ~= nil then
        local maxOpen = tonumber(s.rsMaxOpenInvoices) or RS_invoiceManager.MAX_TOTAL_SERVICE
        RS_invoiceManager.MAX_TOTAL_SERVICE = maxOpen
        RS_invoiceManager.MAX_OPEN_SERVICE = maxOpen
    end

    -- Update UI states (if already injected)
    for _, id in ipairs(self.menuItems) do
        local ctrl = self.CONTROLS[id]
        if ctrl ~= nil then
            ctrl:setState(self.getStateIndex(id, s[id]))
        end
    end

    -- Persist + broadcast if server-authoritative
    if isAuthoritative and g_currentMission:getIsServer() then
        self:saveToXMLFile(g_currentMission.missionInfo)

        if g_server ~= nil then
            g_server:broadcastEvent(RS_settingsEvent.new(s), false)
        end
    end
end


function RS_invoiceSettings:getVatRate()
    if g_currentMission == nil or g_currentMission.rsInvoiceSettings == nil then
        return 0.19
    end
    local pct = tonumber(g_currentMission.rsInvoiceSettings.rsVatPercent)
    if pct == nil then
        return 0.19
    end
    return pct / 100
end



function RS_invoiceSettings:getInterestRate()
    if g_currentMission == nil or g_currentMission.rsInvoiceSettings == nil then
        return 0
    end
    local pct = tonumber(g_currentMission.rsInvoiceSettings.rsInterestPercent)
    if pct == nil then
        return 0
    end
    return pct / 100
end

function RS_invoiceSettings:getInterestIntervalDays()
    if g_currentMission == nil or g_currentMission.rsInvoiceSettings == nil then
        return 3
    end
    local days = tonumber(g_currentMission.rsInvoiceSettings.rsInterestIntervalDays)
    if days == nil or days <= 0 then
        return 3
    end
    return days
end

function RS_invoiceSettings:loadDefaultsIfMissing()
    if g_currentMission == nil then
        return
    end
    g_currentMission.rsInvoiceSettings = g_currentMission.rsInvoiceSettings or {}
    for _, id in ipairs(self.menuItems) do
        if g_currentMission.rsInvoiceSettings[id] == nil then
            local def = self.SETTINGS[id]
            g_currentMission.rsInvoiceSettings[id] = def.values[def.default]
        end
    end
end


function RS_invoiceSettings:saveToXMLFile(missionInfo)
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end

    local savegameDirectory = g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.savegameDirectory or nil
    if savegameDirectory == nil then
        return
    end

    local filename = savegameDirectory .. "/rs_invoiceSettings.xml"
    local key = "rsInvoiceSettings"
    local xmlFile = XMLFile.create("rsInvoiceSettings", filename, key)
    if xmlFile == nil then
        return
    end

    local s = g_currentMission.rsInvoiceSettings or {}
    xmlFile:setInt(key .. "#rsVatPercent", tonumber(s.rsVatPercent) or 19)
    xmlFile:setInt(key .. "#rsMaxOpenInvoices", tonumber(s.rsMaxOpenInvoices) or 10)
    xmlFile:setInt(key .. "#rsInterestPercent", tonumber(s.rsInterestPercent) or 0)
    xmlFile:setInt(key .. "#rsInterestIntervalDays", tonumber(s.rsInterestIntervalDays) or 3)

    xmlFile:save()
    xmlFile:delete()
end

function RS_invoiceSettings:loadFromXMLFile()
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end

    local savegameDirectory = g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.savegameDirectory or nil
    if savegameDirectory == nil then
        return
    end

    local filename = savegameDirectory .. "/rs_invoiceSettings.xml"
    local key = "rsInvoiceSettings"
    local xmlFile = XMLFile.loadIfExists("rsInvoiceSettings", filename, key)
    if xmlFile == nil then
        return
    end

    local s = {}
    s.rsVatPercent = xmlFile:getInt(key .. "#rsVatPercent")
    s.rsMaxOpenInvoices = xmlFile:getInt(key .. "#rsMaxOpenInvoices")
    s.rsInterestPercent = xmlFile:getInt(key .. "#rsInterestPercent")
    s.rsInterestIntervalDays = xmlFile:getInt(key .. "#rsInterestIntervalDays")
    xmlFile:delete()

    self:applySettings(s, true)
end

function RS_invoiceSettings:injectMenu()
    local inGameMenu = g_gui.screenControllers[InGameMenu]
    if inGameMenu == nil then
        return
    end
    local settingsPage = inGameMenu.pageSettings
    if settingsPage == nil then
        return
    end

    RS_invoiceSettingsControls.name = settingsPage.name

    local function addBinaryMenuOption(id)
        local callback = "onMenuOptionChanged"
        local i18n_title = "rs_setting_" .. id
        local i18n_tooltip = "rs_toolTip_" .. id
        local options = self.SETTINGS[id].strings

        local originalBox = settingsPage.checkWoodHarvesterAutoCutBox
        local menuOptionBox = originalBox:clone(settingsPage.gameSettingsLayout)
        menuOptionBox.id = id .. "box"

        local menuBinaryOption = menuOptionBox.elements[1]
        menuBinaryOption.id = id
        menuBinaryOption.target = RS_invoiceSettingsControls
        menuBinaryOption:setCallback("onClickCallback", callback)
        menuBinaryOption:setDisabled(false)

        local toolTip = menuBinaryOption.elements[1]
        toolTip:setText(g_i18n:getText(i18n_tooltip))

        local setting = menuOptionBox.elements[2]
        setting:setText(g_i18n:getText(i18n_title))

        menuBinaryOption:setTexts({ table.unpack(options) })
        menuBinaryOption:setState(self.getStateIndex(id))

        self.CONTROLS[id] = menuBinaryOption

        updateFocusIds(menuOptionBox)
        table.insert(settingsPage.controlsList, menuOptionBox)
        return menuOptionBox
    end

    local function addMultiMenuOption(id)
        local callback = "onMenuOptionChanged"
        local i18n_title = "rs_setting_" .. id
        local i18n_tooltip = "rs_toolTip_" .. id
        local options = self.SETTINGS[id].strings

        local originalBox = settingsPage.multiVolumeVoiceBox
        local menuOptionBox = originalBox:clone(settingsPage.gameSettingsLayout)
        menuOptionBox.id = id .. "box"

        local menuMultiOption = menuOptionBox.elements[1]
        menuMultiOption.id = id
        menuMultiOption.target = RS_invoiceSettingsControls
        menuMultiOption:setCallback("onClickCallback", callback)
        menuMultiOption:setDisabled(false)

        local toolTip = menuMultiOption.elements[1]
        toolTip:setText(g_i18n:getText(i18n_tooltip))

        local setting = menuOptionBox.elements[2]
        setting:setText(g_i18n:getText(i18n_title))

        menuMultiOption:setTexts({ table.unpack(options) })
        menuMultiOption:setState(self.getStateIndex(id))

        self.CONTROLS[id] = menuMultiOption

        updateFocusIds(menuOptionBox)
        table.insert(settingsPage.controlsList, menuOptionBox)
        return menuOptionBox
    end

    -- Section header
    local sectionTitle = nil
    for _, elem in ipairs(settingsPage.gameSettingsLayout.elements) do
        if elem.name == "sectionHeader" then
            sectionTitle = elem:clone(settingsPage.gameSettingsLayout)
            break
        end
    end

    if sectionTitle then
        sectionTitle:setText(g_i18n:getText("rs_help_title_invoice_settings"))
    else
        sectionTitle = TextElement.new()
        sectionTitle:applyProfile("fs25_settingsSectionHeader", true)
        sectionTitle:setText(g_i18n:getText("rs_help_title_invoice_settings"))
        sectionTitle.name = "sectionHeader"
        settingsPage.gameSettingsLayout:addElement(sectionTitle)
    end

    sectionTitle.focusId = FocusManager:serveAutoFocusId()
    table.insert(settingsPage.controlsList, sectionTitle)
    self.CONTROLS[sectionTitle.name] = sectionTitle

    for _, id in ipairs(self.menuItems) do
        if #self.SETTINGS[id].values == 2 then
            addBinaryMenuOption(id)
        else
            addMultiMenuOption(id)
        end
    end

    settingsPage.gameSettingsLayout:invalidateLayout()

    -- Enable/disable options for clients when frame opens
    self._didInjectMenu = true

    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, function()
        local isAdmin = g_currentMission:getIsServer() or g_currentMission.isMasterUser
        for _, id in ipairs(self.menuItems) do
            local menuOption = self.CONTROLS[id]
            if menuOption ~= nil then
                menuOption:setState(self.getStateIndex(id))
                if self.SETTINGS[id].serverOnly and g_server == nil then
                    menuOption:setDisabled(not isAdmin)
                else
                    menuOption:setDisabled(false)
                end
            end
        end
    end)
end


function RS_invoiceSettings:loadMap()
    -- Prepare settings table
    self:loadDefaultsIfMissing()

    -- Load persisted settings on server
    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        self:loadFromXMLFile()
    end

    -- Apply runtime effects
    if g_rs_invoiceManager ~= nil and g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
        local maxOpen = tonumber(g_currentMission.rsInvoiceSettings.rsMaxOpenInvoices) or RS_invoiceManager.MAX_TOTAL_SERVICE
        RS_invoiceManager.MAX_TOTAL_SERVICE = maxOpen
        RS_invoiceManager.MAX_OPEN_SERVICE = maxOpen
    end

    -- Inject menu section (deferred): GUI may not be ready during loadMap
    if self._didHookSettingsFrame ~= true then
        self._didHookSettingsFrame = true
        InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, function()
            if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings._didInjectMenu ~= true then
                g_rs_invoiceSettings:injectMenu()
                g_rs_invoiceSettings._didInjectMenu = true
            end
        end)
    end
end


-- Allow keyboard/controller navigation for custom controls
FocusManager.setGui = Utils.appendedFunction(FocusManager.setGui, function(_, gui)
    if gui == "ingameMenuSettings" and g_rs_invoiceSettings ~= nil then
        for _, control in pairs(g_rs_invoiceSettings.CONTROLS) do
            if control ~= nil and (not control.focusId or not FocusManager.currentFocusData.idToElementMapping[control.focusId]) then
                FocusManager:loadElementFromCustomValues(control, nil, nil, false, false)
            end
        end
        local settingsPage = g_gui.screenControllers[InGameMenu].pageSettings
        settingsPage.gameSettingsLayout:invalidateLayout()
    end
end)


-- Send settings to clients when they join
FSBaseMission.sendInitialClientState = Utils.appendedFunction(FSBaseMission.sendInitialClientState,
    function(self, connection, user, farm)
        if g_currentMission ~= nil and g_currentMission:getIsServer() and g_rs_invoiceSettings ~= nil then
            if connection ~= nil and connection.sendEvent ~= nil then
                connection:sendEvent(RS_settingsEvent.new(g_currentMission.rsInvoiceSettings))
            elseif g_server ~= nil and g_server.broadcastEvent ~= nil then
                -- fallback
                g_server:broadcastEvent(RS_settingsEvent.new(g_currentMission.rsInvoiceSettings), false, connection, connection)
            end
        end
    end)


g_rs_invoiceSettings = RS_invoiceSettings
addModEventListener(g_rs_invoiceSettings)
