--
-- AdvancedFarmManager
--

AdvancedFarmManager = {}

AdvancedFarmManager.debug     = false
AdvancedFarmManager.modFolder = g_currentModDirectory
AdvancedFarmManager.limitTab  = false
AdvancedFarmManager.limitTabK = nil

---Source files 
local sourceFiles = {
  -- Debug
  "scripts/globalFuncs.lua",
  -- Gui 
  "gui/AFMGui.lua",
  "gui/AFMGuiVehicleFrame.lua",
  "gui/AFMGuiImplementFrame.lua",
  "gui/AFMGuiPlaceableFrame.lua",
  "gui/AFMGuiFieldFrame.lua",
  -- Functions
  "scripts/HotKeyVehicleSystem.lua",
  -- Events
  "scripts/moneyPaymentEvent.lua",
  "scripts/setHotKeyNickNameEvent.lua",
  "scripts/washVehicleEvent.lua",
  "scripts/repairVehicleEvent.lua",
  "scripts/refuelVehicleEvent.lua",
  "scripts/repaintVehicleEvent.lua",
  "scripts/refuelDEFVehicleEvent.lua",
  "scripts/refuelMethaneVehicleEvent.lua",
  "scripts/actionItemDialog.lua",
}

---Load all of the source files
for _, file in ipairs(sourceFiles) do
  source(Utils.getFilename(file, AdvancedFarmManager.modFolder))
end

addModEventListener(AdvancedFarmManager)


function AdvancedFarmManager.prerequisitesPresent(specializations)
    return true
end


function AdvancedFarmManager:loadMap(name)
    print("~~ AdvancedFarmManager initializing...")
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AdvancedFarmManager:loadMap")
    end

    AdvancedFarmManager.eventName = {}

    self:loadGui()

end

function AdvancedFarmManager:loadGui()
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AdvancedFarmManager:loadMap")
    end

    local vehicleFrame   = AFMGuiVehicleFrame:new(g_i18n)
    local implementFrame = AFMGuiImplementFrame:new(g_i18n)
    local placeableFrame = AFMGuiPlaceableFrame:new(g_i18n)
    local fieldFrame     = AFMGuiFieldFrame:new(g_i18n)

    g_gui:loadProfiles(AdvancedFarmManager.modFolder .. "gui/guiProfiles.xml")
    g_overlayManager:addTextureConfigFile(AdvancedFarmManager.modFolder .. "help/helplineAFMSmall.xml", "AFMHelplineSmall")

    AdvancedFarmManager.gui = AFMGui:new(g_messageCenter, g_i18n, g_inputBinding)

    g_gui:loadGui(AdvancedFarmManager.modFolder .. "gui/AFMGuiVehicleFrame.xml", "AFMGuiVehicleFrame", vehicleFrame, true)
    g_gui:loadGui(AdvancedFarmManager.modFolder .. "gui/AFMGuiImplementFrame.xml", "AFMGuiImplementFrame", implementFrame, true)
    g_gui:loadGui(AdvancedFarmManager.modFolder .. "gui/AFMGuiPlaceableFrame.xml", "AFMGuiPlaceableFrame", placeableFrame, true)
    g_gui:loadGui(AdvancedFarmManager.modFolder .. "gui/AFMGuiFieldFrame.xml", "AFMGuiFieldFrame", fieldFrame, true)
    g_gui:loadGui(AdvancedFarmManager.modFolder .. "gui/AFMGui.xml", "AFMGui", AdvancedFarmManager.gui)
end

function AdvancedFarmManager:reloadGui()
    -- This is only needed when editing and debug
    afmDebug("Reload GUI")

    g_gui.currentlyReloading = true

    AdvancedFarmManager.gui:delete()

    self:loadGui()
end

function AdvancedFarmManager:loadSavegame()
end

function AdvancedFarmManager:registerActionEventsPlayer()
    if not g_currentMission:getIsClient() then return end
    if g_dedicatedServer then return end

    self.eventName = self.eventName or {}

    -- afm_menu
    local result, eventName = g_inputBinding:registerActionEvent(
        'afm_menu', self, self.actionAdvancedFarmManager_openGui, false, true, false, true
    )
    if result and g_inputBinding.events[eventName] ~= nil then
        table.insert(self.eventName, eventName)
        g_inputBinding.events[eventName].displayIsVisible = true
    end

    -- afm_togg
    local t_result, t_eventName = g_inputBinding:registerActionEvent(
        'afm_togg', self, self.actionAdvancedFarmManager_toggleTab, false, true, false, true
    )
    if t_result and g_inputBinding.events[t_eventName] ~= nil then
        table.insert(self.eventName, t_eventName)
        self.limitTabK = t_eventName

        local l10n_entry = self.limitTab and "afm_toggleLimited" or "afm_toggleNotLimited"
        g_inputBinding:setActionEventText(self.limitTabK, g_i18n:getText(l10n_entry))
        g_inputBinding.events[t_eventName].displayIsVisible = true
    end

    -- Hotkeys afm_hot1 to afm_hot9
    for i = 1, 9 do
        local keyName = 'afm_hot' .. tostring(i)
        local l_result, l_eventName = g_inputBinding:registerActionEvent(
            keyName, self, self.actionAdvancedFarmManager_hotKey, false, true, false, true
        )
        if l_result and g_inputBinding.events[l_eventName] ~= nil then
            table.insert(self.eventName, l_eventName)
            g_inputBinding.events[l_eventName].displayIsVisible = false
        end
    end
end



function AdvancedFarmManager:removeActionEventsPlayer()
    AdvancedFarmManager.eventName = {}
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AdvancedFarmManager:removeActionEventsPlayer")
    end
end


function AdvancedFarmManager:actionAdvancedFarmManager_hotKey(actionName, keyStatus, arg3, arg4, arg5)
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AdvancedFarmManager:actionAdvancedFarmManager_hotKey")
    end
    if g_gui.currentGui == nil then
        local keyPressed = tonumber(string.sub(actionName, -1))     

        if g_localPlayer ~= nil then
            local uniqueUserId = afmGetLocalUniqueUserId()
            if uniqueUserId == nil then
                return
            end
            local alreadyDone = false
            local vehicleList = g_currentMission.vehicleSystem and g_currentMission.vehicleSystem.vehicles or {}
            for _, vehicle in ipairs(vehicleList) do
                local hasAccess        = g_currentMission.accessHandler and g_currentMission.accessHandler:canPlayerAccess(vehicle)
                local hasEnter         = vehicle.spec_enterable ~= nil
                local hasSpec          = vehicle.getHotKeyVehicleState ~= nil
                local isConned         = vehicle.getIsControlled ~= nil and vehicle:getIsControlled()

                if not alreadyDone and hasSpec and hasEnter and hasAccess then
                    if vehicle:getHotKeyVehicleState(uniqueUserId) == keyPressed then
                        alreadyDone = true
                        if not isConned then
                            -- available, switch to it
                            g_localPlayer:requestToEnterVehicle(vehicle)
                        end
                    end
                end
            end
        end
    end
end


function AdvancedFarmManager:actionAdvancedFarmManager_openGui(actionName, keyStatus, arg3, arg4, arg5)
    if g_gui.currentGui == nil then
        g_gui:showGui("AFMGui")
    end
end

function AdvancedFarmManager:actionAdvancedFarmManager_toggleTab(actionName, keyStatus, arg3, arg4, arg5)
    afmDebug("Toggle Tab")
    AdvancedFarmManager.limitTab = not AdvancedFarmManager.limitTab
    local l10n_entry = "afm_toggleNotLimited"

    if AdvancedFarmManager.limitTab then
        l10n_entry = "afm_toggleLimited"
    end

    g_inputBinding:setActionEventText(
        AdvancedFarmManager.limitTabK, g_i18n:getText(l10n_entry)
    )
end


function AdvancedFarmManager:mouseEvent(posX, posY, isDown, isUp, button)
end


function AdvancedFarmManager:keyEvent(unicode, sym, modifier, isDown)
    -- if AdvancedFarmManager.debug then
    --     print("~~ AdvancedFarmManager Debug ... AdvancedFarmManager:keyEvent")
    -- end

    if isDown and g_gui.currentGui ~= nil  and g_gui.currentGui.name == "AFMGui" and g_gui.currentGui.target.currentPage.name == "AFMGuiVehicle" then
        if ( sym > 48 and sym < 58 ) or ( sym > 256 and sym < 266) then
            -- Get the current player unique user id
            local uniqueUserId = afmGetLocalUniqueUserId()
            if uniqueUserId == nil then
                return
            end


            local numberKeyPressed  = 0
            if sym > 58 then
                numberKeyPressed  = sym - 256
            else
                numberKeyPressed  = sym - 48
            end
            local vehicleList       = g_gui.currentGui.target.pageAFMVehicles.vehicles
            local currentVehicleIdx = g_gui.currentGui.target.pageAFMVehicles.vehicleList.selectedIndex
            local currentVehicle    = vehicleList[currentVehicleIdx].vehicle

            if currentVehicle.getHotKeyVehicleState ~= nil then
                local currentHotKey = currentVehicle:getHotKeyVehicleState(uniqueUserId)

                if currentHotKey == numberKeyPressed then
                    -- unset current
                    currentVehicle:setHotKeyVehicleState(0, uniqueUserId)
                else
                    for _, vehicleIttr in ipairs(vehicleList) do
                        local v = vehicleIttr.vehicle
                        if v.getHotKeyVehicleState ~= nil and v:getHotKeyVehicleState(uniqueUserId) == numberKeyPressed then
                            v:setHotKeyVehicleState(0, uniqueUserId)
                        end
                    end
                    currentVehicle:setHotKeyVehicleState(numberKeyPressed, uniqueUserId)
                end
            end
            g_gui.currentGui.target.pageAFMVehicles:rebuildTable()
        end
    end
end

function AdvancedFarmManager:buildHotKeyList()
    local vehicleList       = g_currentMission.enterables
    local hotKeyList        = {}
    local hotKeyKeyList     = {}

    local uniqueUserId = afmGetLocalUniqueUserId()
    if uniqueUserId == nil then
        return hotKeyList, hotKeyKeyList
    end

    for _, thisVehicle in ipairs(vehicleList) do
        if thisVehicle.getHotKeyVehicleState ~= nil and thisVehicle:getIsTabbable() and thisVehicle:getIsEnterable() then
            local thisHotKey = thisVehicle:getHotKeyVehicleState(uniqueUserId)
            if thisHotKey > 0 then
                hotKeyList[thisHotKey] = thisVehicle
                table.insert(hotKeyKeyList, thisHotKey)
            end
        end
    end

    table.sort(hotKeyKeyList)

    return hotKeyList, hotKeyKeyList
end

function AdvancedFarmManager:getClosestHK(haystack, needle)
    local goBack   = 0
    local goFwd    = 10
    local firstIdx = 0
    local lastIdx  = 10

    for _, idx in ipairs(haystack) do
        if firstIdx == 0 then
            firstIdx = idx
        end
        if idx > goBack and idx < needle then
            goBack = idx
        end
        if idx < goFwd and idx > needle then
            goFwd = idx
        end
        lastIdx = idx
    end

    if goBack == 0 then
        goBack = lastIdx
    end
    if goFwd == 10 then
        goFwd = firstIdx
    end

    return goFwd, goBack
end

function AdvancedFarmManager:findNextHotKey(currentHotKey, directionFwd)
    local hotKeyList, hotKeyKeyList = self:buildHotKeyList()

    if hotKeyKeyList == nil or next(hotKeyList) == nil then
        return false
    end

    if currentHotKey == 0 then
        if directionFwd then
            if hotKeyKeyList[1] == nil then
                return false
            end
            return hotKeyList[hotKeyKeyList[1]]
        end
        if hotKeyKeyList[#hotKeyKeyList] == nil then
            return false
        end
        return hotKeyList[hotKeyKeyList[#hotKeyKeyList]]
    end

    local goFwd, goBack = self:getClosestHK(hotKeyKeyList, currentHotKey)

    if directionFwd then
        return hotKeyList[goFwd]
    else
        return hotKeyList[goBack]
    end

    return false
end

function AdvancedFarmManager:getNextEnterableVehicle(superFunc, currentVehicle, direction)
    -- afmDebug("Get Next Enterable Vehicle : Tab")

    -- Build filtered enterables list
    self.enterables = {}

    local uniqueUserId = afmGetLocalUniqueUserId()

    for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do
        if AdvancedFarmManager.limitTab then
            local hasHotKey = false

            if vehicle.getHotKeyVehicleState ~= nil then
                local hotKey = vehicle:getHotKeyVehicleState(uniqueUserId)
                -- afmDebug("Hotkey Check: " .. tostring(hotKey))
                hasHotKey = hotKey ~= nil and hotKey ~= 0
            end

            if hasHotKey and vehicle.getIsEnterable ~= nil and vehicle:getIsEnterable() then
                table.insert(self.enterables, vehicle)
            end
        else
            if vehicle.getIsEnterable ~= nil and vehicle:getIsEnterable() then
                table.insert(self.enterables, vehicle)
            end
        end
    end

    local totalVehicles = #self.enterables
    -- afmDebug(string.format("Total vehicles in rotation: %d", totalVehicles))

    if totalVehicles == 0 then
        return nil
    end

    local startIndex = 1

    if self.lastEnteredVehicleIndex ~= nil then
        startIndex = self.lastEnteredVehicleIndex
    elseif g_localPlayer:getIsInVehicle() and currentVehicle ~= nil then
        for i, vehicle in ipairs(self.enterables) do
            if vehicle == currentVehicle then
                startIndex = i
                break
            end
        end
    end

    local index = startIndex

    for _ = 1, totalVehicles do
        index = index + direction

        -- Wrap
        if index > totalVehicles then index = 1 end
        if index < 1 then index = totalVehicles end

        local vehicle = self.enterables[index]
        if AdvancedFarmManager.limitTab then
            if vehicle ~= nil and vehicle:getIsEnterable() then
                -- afmDebug(string.format("Switching to vehicle index: %d", index))
                self.lastEnteredVehicleIndex = index
                return vehicle
            end
        else
            if vehicle ~= nil and vehicle:getIsTabbable() and vehicle:getIsEnterable() then
                -- afmDebug(string.format("Switching to vehicle index: %d", index))
                self.lastEnteredVehicleIndex = index
                return vehicle
            end
        end
    end

    -- Fallback to vanilla if nothing found
    return superFunc(self, currentVehicle, direction)
end



function AdvancedFarmManager:update(dt)
  AdvancedFarmManager:registerActionEventsPlayer()
end


function AdvancedFarmManager:draw()
end


local function validateVehicleTypes(typeManager)
    if typeManager.typeName == "vehicle" then
        g_HotKeyVehicleSystem:installSpecialization(g_vehicleTypeManager, g_specializationManager)
    end
end


function AdvancedFarmManager:loadMapDataHelpLineManager(superFunc, ...)
    local ret = superFunc(self, ...)
    if ret then
        self:loadFromXML(Utils.getFilename("help/HelpMenu.xml", AdvancedFarmManager.modFolder))
        return true
    end
    return false
end

function AdvancedFarmManager.resolveFilename(self,superFunc)
  local t_overlayFilename = superFunc(self)

	if t_overlayFilename == "g_AFMExtraIcons" then
		t_overlayFilename = g_AFMExtraIcons
	end
  if t_overlayFilename == "g_AFMIconVehicle" then
    t_overlayFilename = g_AFMIconVehicle
  end
  if t_overlayFilename == "g_AFMIconAttach" then
    t_overlayFilename = g_AFMIconAttach
  end
  if t_overlayFilename == "g_AFMIconPlaceable" then
    t_overlayFilename = g_AFMIconPlaceable
  end
  if t_overlayFilename == "g_AFMIconField" then
    t_overlayFilename = g_AFMIconField
  end

	return t_overlayFilename
end

local function init()
    afmDebug("Init Stuffs")
    -- Load Custom Icons
    g_AFMExtraIcons             = Utils.getFilename("icons/afm_icon_extra.png", AdvancedFarmManager.modFolder)
    g_AFMIconVehicle            = Utils.getFilename("icons/afm_icon_vehicle.png", AdvancedFarmManager.modFolder)
    g_AFMIconAttach             = Utils.getFilename("icons/afm_icon_attach.png", AdvancedFarmManager.modFolder)
    g_AFMIconPlaceable          = Utils.getFilename("icons/afm_icon_placeable.png", AdvancedFarmManager.modFolder)
    g_AFMIconField              = Utils.getFilename("icons/afm_icon_field.png", AdvancedFarmManager.modFolder)
    -- Update and tie to base game functions
    GuiOverlay.resolveFilename  = Utils.overwrittenFunction(GuiOverlay.resolveFilename, AdvancedFarmManager.resolveFilename)
    g_HotKeyVehicleSystem       = HotKeyVehicleSystem:new(g_currentModName, AdvancedFarmManager.modFolder, g_inputBinding, AdvancedFarmManager.debug)
    TypeManager.validateTypes   = Utils.prependedFunction(TypeManager.validateTypes, validateVehicleTypes)
    HelpLineManager.loadMapData = Utils.overwrittenFunction(HelpLineManager.loadMapData, AdvancedFarmManager.loadMapDataHelpLineManager)
    VehicleSystem.getNextEnterableVehicle   = Utils.overwrittenFunction(VehicleSystem.getNextEnterableVehicle, AdvancedFarmManager.getNextEnterableVehicle)
    Placeable.delete            = Utils.appendedFunction(Placeable.delete, placeableRebuildTable)
    Vehicle.delete              = Utils.appendedFunction(Vehicle.delete, vehicleRebuildTable)
    AnimalSellEvent.run         = Utils.appendedFunction(AnimalSellEvent.run, placeableRebuildTable)

    ActionItemDialog.register()
end

function placeableRebuildTable()
    if g_currentMission:getIsClient() and g_gui ~= nil and g_gui.currentGui ~= nil and g_gui.currentGui.target ~= nil and g_gui.currentGui.target.pageAFMPlaceables ~= nil then
        afmDebug("Placeable Delete")
        g_gui.currentGui.target.pageAFMPlaceables:rebuildTable()
    end
end

function vehicleRebuildTable()
    if g_currentMission:getIsClient() and g_gui ~= nil and g_gui.currentGui ~= nil and g_gui.currentGui.target ~= nil then
        afmDebug("Vehicle Delete")
        if g_gui.currentGui.target.pageAFMVehicles ~= nil then
            g_gui.currentGui.target.pageAFMVehicles:rebuildTable()
        end
        if g_gui.currentGui.target.pageAFMImplements ~= nil then
            g_gui.currentGui.target.pageAFMImplements:rebuildTable()
        end
    end
end




init()
