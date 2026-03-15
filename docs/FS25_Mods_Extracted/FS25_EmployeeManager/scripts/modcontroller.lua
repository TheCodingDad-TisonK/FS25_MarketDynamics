ModController = {}

ModController.name = g_currentModName
ModController.path = g_currentModDirectory
ModController.globalKey = "EMPLOYEE_MANAGER_CONTROLLER"

local mod = g_modManager:getModByName(g_currentModName)
if mod ~= nil then
    ModController.version = mod.version
else
    ModController.version = "UNKNOWN"
    CustomUtils:error("[ModController] Could not get mod info for '%s'", g_currentModName)
end

ModController.isInitialized = false

---@param self table
---@param name string
---@param itemSystem table
---@param missionInfo table
---@param missionDynamicInfo table
---@param savegame table
function ModController:loadMap(name, itemSystem, missionInfo, missionDynamicInfo, savegame)
    CustomUtils:info("[%s] Loaded mod version %s", self.name, tostring(self.version))

    self.isInitialized = true

    CustomUtils:info("Initializing Employee Manager Mod...")

    g_employeeManager = EmployeeManager:new(g_currentMission)
    g_parkingManager = ParkingManager:new()
    g_snapshotManager = VehicleSnapshotManager:new()

    g_persistenceManager = PersistenceManager:new()
    g_persistenceManager:addStrategy(DBAPIPersistence:new())
    g_persistenceManager:addStrategy(XMLPersistence:new())
    g_persistenceManager:selectStrategy()

    g_employeeManager:loadEmployeeTemplates(self.path)

    if SimpleStatusHUD then
        self.hud = SimpleStatusHUD.new()
        self.hud:load()
        addConsoleCommand("emToggleHUD", "Toggles the Employee Manager Status HUD", "consoleToggleHUD", self)
        addConsoleCommand("emMenuWorkflow", "Opens the Workflow Editor Menu", "consoleMenuWorkflow", self)
    end

    if g_currentMission and g_helperManager then
        local minHelpers = math.max(g_currentMission.maxNumHirables or 30, 50)
        g_currentMission.maxNumHirables = minHelpers
        CustomUtils:info("[ModController] Set maxNumHirables to %d", minHelpers)
    end

    g_employeeManager:onMissionInitialize(self.path)
    g_employeeManager:subscribeEvents()

    FSBaseMission.saveSavegame = Utils.prependedFunction(FSBaseMission.saveSavegame, function()
        ModController:saveEmployees()
    end)

    self.dataLoaded = false
    self.deferredLoadAttempted = false

    if savegame ~= nil then
        self.dataLoaded = self:loadEmployees(savegame.savegameDirectory)
    end

    if self.dataLoaded then
        if #g_employeeManager.employees == 0 then
            g_employeeManager:generateInitialPool(10)
        end
    else
        CustomUtils:info("[ModController] Load deferred — DBAPI may not be ready yet")
    end

    if rawget(_G, 'g_modGui') ~= nil then
        g_modGui:onMapLoaded()
    end

    local _, eventId = g_inputBinding:registerActionEvent('EM_OPEN_WORKFLOW', self, self.onOpenWorkflow, false, true, false, true)
    if eventId then
        g_inputBinding:setActionEventText(eventId, g_i18n:getText("input_EM_OPEN_WORKFLOW"))
        g_inputBinding:setActionEventTextPriority(eventId, GS_PRIO_NORMAL)
        self.workflowActionEventId = eventId
    end
end

function ModController:saveEmployees()
    if g_persistenceManager == nil or g_employeeManager == nil then return end
    g_persistenceManager:save(g_employeeManager, g_parkingManager, g_snapshotManager)
end

function ModController:loadEmployees(savegameDir)
    if g_persistenceManager == nil or g_employeeManager == nil then
        return false
    end
    return g_persistenceManager:load(g_employeeManager, g_parkingManager, g_snapshotManager)
end

function ModController:deleteMap()
    if self.workflowActionEventId then
        g_inputBinding:removeActionEvent(self.workflowActionEventId)
        self.workflowActionEventId = nil
    end

    if g_employeeManager then
        g_employeeManager:unsubscribeEvents()
        g_employeeManager = nil
    end
    g_parkingManager = nil
    g_snapshotManager = nil
    g_persistenceManager = nil
end

function ModController:update(dt)
    if not self.deferredLoadAttempted and not self.dataLoaded then
        self.deferredLoadAttempted = true
        g_persistenceManager:selectStrategy()
        self.dataLoaded = g_persistenceManager:load(g_employeeManager, g_parkingManager, g_snapshotManager)
        if not self.dataLoaded or #g_employeeManager.employees == 0 then
            CustomUtils:info("[ModController] Deferred load: no data, generating pool")
            g_employeeManager:generateInitialPool(10)
        end
    end

    if g_employeeManager and g_employeeManager.update then
        g_employeeManager:update(dt)
    end

    if g_currentMission and g_helperManager and g_currentMission.maxNumHirables < g_helperManager.numHelpers then
        g_currentMission.maxNumHirables = g_helperManager.numHelpers
    end
end

function ModController:onOpenWorkflow(actionName, inputValue)
    if g_gui.currentGuiName == nil and g_employeeManager ~= nil then
        self:openWorkflowTab()
    end
end

function ModController:consoleMenuWorkflow()
    if g_employeeManager == nil then
        return "Employee Manager not initialized"
    end
    self:openWorkflowTab()
    return "Opening Workflow Editor..."
end

function ModController:openWorkflowTab()
    if g_emGui == nil then
        CustomUtils:warning("[ModController] EMGui not loaded")
        return
    end
    g_gui:showGui("EMGui")
    if g_emGui.pagingElement ~= nil then
        g_emGui.pagingElement:setPage(2)
    end
end

function ModController:draw()
    if self.hud and g_gui.currentGuiName == nil then
        self.hud:draw()
    end
end

function ModController:consoleToggleHUD()
    if self.hud then
        self.hud:toggle()
        return "HUD visibility toggled"
    end
    return "HUD not available"
end

function ModController:keyEvent(unicode, sym, modifier, isDown)
end

addModEventListener(ModController)
