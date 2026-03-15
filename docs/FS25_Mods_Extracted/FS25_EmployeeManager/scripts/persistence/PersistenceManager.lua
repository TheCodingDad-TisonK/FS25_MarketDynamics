PersistenceManager = {}
PersistenceManager.__index = PersistenceManager

function PersistenceManager:new()
    local self = setmetatable({}, PersistenceManager)
    self.strategies = {}
    self.activeStrategy = nil
    return self
end

function PersistenceManager:addStrategy(strategy)
    table.insert(self.strategies, strategy)
    CustomUtils:debug("[PersistenceManager] Registered strategy: %s", strategy:getName())
end

function PersistenceManager:selectStrategy()
    for _, strategy in ipairs(self.strategies) do
        local available = strategy:isAvailable()
        CustomUtils:info("[PersistenceManager] Strategy %s available: %s", strategy:getName(), tostring(available))
        if available then
            self.activeStrategy = strategy
            CustomUtils:info("[PersistenceManager] >>> Selected strategy: %s", strategy:getName())
            return strategy
        end
    end

    CustomUtils:warning("[PersistenceManager] No available strategy found!")
    self.activeStrategy = nil
    return nil
end

function PersistenceManager:save(employeeManager, parkingManager, snapshotManager)
    if employeeManager == nil then
        CustomUtils:warning("[PersistenceManager] save() called with nil employeeManager")
        return false
    end

    if self.activeStrategy == nil then
        CustomUtils:warning("[PersistenceManager] No active strategy, re-selecting...")
        self:selectStrategy()
    end

    if self.activeStrategy == nil then
        CustomUtils:error("[PersistenceManager] Cannot save: no strategy available")
        return false
    end

    local strategy = self.activeStrategy
    CustomUtils:info("[PersistenceManager] Saving with %s...", strategy:getName())

    local ok, result = pcall(function()
        return strategy:save(employeeManager, parkingManager, snapshotManager)
    end)

    if ok and result then
        CustomUtils:info("[PersistenceManager] Save succeeded with %s", strategy:getName())
        return true
    end

    if not ok then
        CustomUtils:error("[PersistenceManager] Save CRASHED with %s: %s", strategy:getName(), tostring(result))
    else
        CustomUtils:warning("[PersistenceManager] Save returned false with %s", strategy:getName())
    end

    return false
end

function PersistenceManager:load(employeeManager, parkingManager, snapshotManager)
    if employeeManager == nil then
        CustomUtils:warning("[PersistenceManager] load() called with nil employeeManager")
        return false
    end

    if self.activeStrategy == nil then
        CustomUtils:warning("[PersistenceManager] No active strategy, re-selecting...")
        self:selectStrategy()
    end

    if self.activeStrategy == nil then
        CustomUtils:error("[PersistenceManager] Cannot load: no strategy available")
        return false
    end

    local strategy = self.activeStrategy
    CustomUtils:info("[PersistenceManager] Loading with %s...", strategy:getName())

    local ok, result = pcall(function()
        return strategy:load(employeeManager, parkingManager, snapshotManager)
    end)

    if ok and result then
        CustomUtils:info("[PersistenceManager] Load succeeded with %s", strategy:getName())
        return true
    end

    if not ok then
        CustomUtils:error("[PersistenceManager] Load CRASHED with %s: %s", strategy:getName(), tostring(result))
    else
        CustomUtils:info("[PersistenceManager] No data found with %s", strategy:getName())
    end

    return false
end
