PersistenceStrategy = {}
PersistenceStrategy.__index = PersistenceStrategy

function PersistenceStrategy:new()
    return setmetatable({}, self)
end

function PersistenceStrategy:getName()
    return "BaseStrategy"
end

function PersistenceStrategy:isAvailable()
    return false
end

function PersistenceStrategy:save(employeeManager, parkingManager, snapshotManager)
    CustomUtils:warning("[PersistenceStrategy] save() not implemented for %s", self:getName())
    return false
end

function PersistenceStrategy:load(employeeManager, parkingManager, snapshotManager)
    CustomUtils:warning("[PersistenceStrategy] load() not implemented for %s", self:getName())
    return false
end
