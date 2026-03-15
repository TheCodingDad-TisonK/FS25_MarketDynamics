--[[
Copyright (C) GtX (Andy), 2024

Author: GtX | Andy
Date: 15.11.2024
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

EasyDevControlsSettings = {}

local EasyDevControlsSettings_mt = Class(EasyDevControlsSettings)

function EasyDevControlsSettings.new(isServer, isClient)
    local self = setmetatable({}, EasyDevControlsSettings_mt)

    self.isServer = isServer
    self.isClient = isClient

    self.settings = {}
    self.settingsByName = {}
    self.savedSettings = {}

    self.loadingStartGameValues = false

    return self
end

function EasyDevControlsSettings:delete()
end

function EasyDevControlsSettings:onMissionStarted(isNewSavegame)
    local easyDevControls = g_easyDevControls

    if easyDevControls ~= nil and not easyDevControls.gameStarted then
        local function loadStartGameValuesCallback(errorCode)
            self.loadingStartGameValues = true

            for _, setting in ipairs (self.settings) do
                if setting.onMissionStartCallback ~= nil then
                    if setting.callbackTarget ~= nil then
                        if setting.callbackArgs == nil then
                            setting.onMissionStartCallback(setting.callbackTarget, setting.value)
                        else
                            setting.onMissionStartCallback(setting.callbackTarget, setting.value, unpack(setting.callbackArgs))
                        end
                    else
                        if setting.callbackArgs == nil then
                            setting.onMissionStartCallback(setting.value)
                        else
                            setting.onMissionStartCallback(setting.value, unpack(setting.callbackArgs))
                        end
                    end

                    EasyDevControlsLogging.devInfo("Setting - %s: %s", setting.name, setting.value)
                end
            end

            self.loadingStartGameValues = false
        end

        if not easyDevControls:getIsMultiplayer() then
            local function getCanLoadStartGameValues()
                if g_localPlayer == nil then
                    return false
                end

                return g_localPlayer.hands ~= nil
            end

            EasyDevControlsAwaiter.new(getCanLoadStartGameValues, loadStartGameValuesCallback)
        else
            loadStartGameValuesCallback()
        end
    end
end

function EasyDevControlsSettings:loadFromXMLFile(xmlFile, baseKey, missionInfo, isSavegame)
    for _, key in xmlFile:iterator(baseKey .. ".settings.setting") do
        local settingName = xmlFile:getString(key .. "#name", "unknown")
        local setting = self.settingsByName[settingName]

        if setting ~= nil then
            local value = setting.defaultValue

            if setting.typeName == "number" then
                value = xmlFile:getInt(key .. "#intValue", value)
            elseif setting.typeName == "boolean" then
                value = xmlFile:getBool(key .. "#boolValue", value)
            elseif setting.typeName == "string" then
                value = xmlFile:getString(key .. "#stringValue", value)
            end

            setting.value = value
            setting.defaultValue = value

            if not isSavegame then
                if setting.canSave then
                    setting.isSaved = xmlFile:getBool(key .. "#isSaved", true)

                    if setting.isSaved then
                        table.addElement(self.savedSettings, setting)
                    end
                end
            end
        else
            EasyDevControlsLogging.xmlDevError(xmlFile, "Failed to load setting with name '%s' at '%s'", settingName, key)
        end
    end

    if g_easyDevControls:getIsMultiplayer() then
        for _, setting in ipairs (self.settings) do
            if setting.mpValue ~= nil then
                setting.value = setting.mpValue
                setting.defaultValue = setting.mpValue
            end
        end
    end
end

function EasyDevControlsSettings:saveToXMLFile(xmlFile, baseKey)
    xmlFile:setSortedTable(baseKey .. ".settings.setting", self.savedSettings, function(key, setting)
        xmlFile:setString(key .. "#name", setting.name)

        if setting.typeName == "number" then
            xmlFile:setInt(key .. "#intValue", setting.value)
        elseif setting.typeName == "boolean" then
            xmlFile:setBool(key .. "#boolValue", setting.value)
        elseif setting.typeName == "string" then
            xmlFile:setString(key .. "#stringValue", setting.value)
        end
    end)
end

function EasyDevControlsSettings:upgradeXMLFile(xmlFile, baseKey, sourceXMLFilename, targetXMLFilename)
	local userSettings, numUserSettings = {}, 0
	
	for _, key in xmlFile:iterator(baseKey .. ".settings.setting") do
        local settingName = xmlFile:getString(key .. "#name", "unknown")
        local setting = self.settingsByName[settingName]

        if setting ~= nil then
            local value, typeName = nil, setting.typeName

            if typeName == "number" then
                value = xmlFile:getInt(key .. "#intValue", value)
            elseif typeName == "boolean" then
                value = xmlFile:getBool(key .. "#boolValue", value)
            elseif typeName == "string" then
                value = xmlFile:getString(key .. "#stringValue", value)
            end

            if value ~= nil then
				userSettings[settingName] = {
					isSaved = setting.canSave and xmlFile:getBool(key .. "#isSaved", true),
					typeName = typeName,
					value = value
				}
				
				numUserSettings += 1
			end
        end
    end
	
	local adminPassword = xmlFile:getString("easyDevControls.permissions#adminPassword")

	xmlFile:delete()

	copyFile(sourceXMLFilename, targetXMLFilename, true)
	xmlFile = XMLFile.loadIfExists("easyDevControls", targetXMLFilename, EasyDevControls.xmlSchema)
	
	if xmlFile ~= nil then
		if numUserSettings > 0 then
			for _, key in xmlFile:iterator(baseKey .. ".settings.setting") do
				local settingName = xmlFile:getString(key .. "#name", "unknown")
				local setting = userSettings[settingName]
				
				if setting ~= nil then
					if setting.typeName == "number" then
						xmlFile:setInt(key .. "#intValue", setting.value)
					elseif setting.typeName == "boolean" then
						xmlFile:setBool(key .. "#boolValue", setting.value)
					elseif setting.typeName == "string" then
						xmlFile:setString(key .. "#stringValue", setting.value)
					end

					xmlFile:setBool(key .. "#isSaved", setting.isSaved)
				end
			end
		end

		if adminPassword ~= nil then
			xmlFile:setString("easyDevControls.permissions#adminPassword", adminPassword)
		end

		xmlFile:save()

		return xmlFile, true
	end
	
	return nil, false
end

function EasyDevControlsSettings:addSetting(name, value, mpValue, canSave, callback, callbackTarget, callbackArgs)
    if name ~= nil and value ~= nil then
        if self.settingsByName[name] == nil then
            local setting = {
                name = name,
                value = value,
                defaultValue = value,
                mpValue = mpValue,
                typeName = type(value),
                onMissionStartCallback = callback,
                callbackTarget = callbackTarget,
                callbackArgs = callbackArgs
            }

            setting.canSave = Utils.getNoNil(canSave, true)
            setting.isSaved = setting.canSave

            table.insert(self.settings, setting)
            self.settingsByName[name] = setting
        else
            EasyDevControlsLogging.devWarning("(EasyDevControlsSettings) Failed to add setting with name '%s', setting using this name already exists!")
        end
    else
        EasyDevControlsLogging.devCallstackError("(EasyDevControlsSettings) Failed to add setting, missing name or value!")
    end
end

function EasyDevControlsSettings:setValue(name, value)
    local setting = self.settingsByName[name]

    if setting ~= nil then
        value = Utils.getNoNil(value, setting.defaultValue)

        -- if self.loadingStartGameValues then

        -- end

        setting.value = value
    end

    return value
end

function EasyDevControlsSettings:getValue(name, backupValue)
    local setting = self.settingsByName[name]

    if setting ~= nil and setting.value ~= nil then
        return setting.value
    end

    return backupValue
end

function EasyDevControlsSettings:getDefaultValue(name, backupValue)
    local setting = self.settingsByName[name]

    if setting ~= nil and setting.defaultValue ~= nil then
        return setting.defaultValue
    end

    return backupValue
end

function EasyDevControlsSettings:clearOnMissionStartCallback(name)
    local setting = self.settingsByName[name]

    if setting ~= nil then
        setting.onMissionStartCallback = nil
        setting.callbackTarget = nil
        setting.callbackArgs = nil
    end
end

function EasyDevControlsSettings.registerXMLPaths(schema, baseKey)
    schema:register(XMLValueType.STRING, baseKey.. ".settings.setting(?)#name", "Setting name")
    schema:register(XMLValueType.INT, baseKey.. ".settings.setting(?)#intValue", "Setting integer value")
    schema:register(XMLValueType.BOOL, baseKey.. ".settings.setting(?)#boolValue", "Setting boolean value")
    schema:register(XMLValueType.STRING, baseKey.. ".settings.setting(?)#stringValue", "Setting string value")
    schema:register(XMLValueType.BOOL, baseKey.. ".settings.setting(?)#isSaved", "Is setting saved with the game")
end
