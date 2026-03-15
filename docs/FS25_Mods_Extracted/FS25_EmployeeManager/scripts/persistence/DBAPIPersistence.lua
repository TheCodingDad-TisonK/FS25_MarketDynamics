DBAPIPersistence = {}
DBAPIPersistence.__index = DBAPIPersistence
DBAPIPersistence.NAMESPACE = "FS25_EmployeeManager"
DBAPIPersistence.CURRENT_VERSION = 1

function DBAPIPersistence:new()
    local self = setmetatable({}, DBAPIPersistence)
    self.db = nil
    return self
end

function DBAPIPersistence:getName()
    return "DBAPI"
end

function DBAPIPersistence:getAPI()
    if g_globalMods then
        return g_globalMods["FS25_DBAPI"]
    end
    return nil
end

function DBAPIPersistence:getDb()
    if self.db then return self.db end

    local api = self:getAPI()
    if api and api.isReady() and api.hasORM and api.hasORM() then
        local db = api.bind(self.NAMESPACE)
        if db then
            self:initModels(db)
            self:migrate(db)
            self.db = db
            return db
        end
    end
    return nil
end

function DBAPIPersistence:initModels(db)
    -- Define Employee model
    local _, err = db:define("Employee", {
        fields = {
            data = { type = "table", required = true }
        }
    })
    if err then CustomUtils:error("[DBAPIPersistence] Error defining Employee model: %s", tostring(err)) end

    -- Define Parking model
    _, err = db:define("Parking", {
        fields = {
            spots = { type = "table", required = true },
            nextSpotId = { type = "number", default = 1 }
        }
    })
    if err then CustomUtils:error("[DBAPIPersistence] Error defining Parking model: %s", tostring(err)) end

    -- Define Settings model
    _, err = db:define("Settings", {
        fields = {
            version = { type = "number", default = 1 },
            nextEmployeeId = { type = "number", default = 1 },
            lastPoolRefreshDay = { type = "number", default = 0 },
            lastPaymentPeriod = { type = "number", default = 0 }
        }
    })
    if err then CustomUtils:error("[DBAPIPersistence] Error defining Settings model: %s", tostring(err)) end

    -- Define VehicleSnapshot model
    _, err = db:define("VehicleSnapshot", {
        fields = {
            snapshots = { type = "table", required = true }
        }
    })
    if err then CustomUtils:error("[DBAPIPersistence] Error defining VehicleSnapshot model: %s", tostring(err)) end

    -- Define FieldConfig model
    _, err = db:define("FieldConfig", {
        fields = {
            fieldId = { type = "number", required = true },
            cropName = { type = "string", required = true }
        }
    })
    if err then CustomUtils:error("[DBAPIPersistence] Error defining FieldConfig model: %s", tostring(err)) end
end

function DBAPIPersistence:migrate(db)
    local settings, _ = db:find("Settings")
    local version = settings and settings.version or 0

    if version < self.CURRENT_VERSION then
        CustomUtils:info("[DBAPIPersistence] Migrating database from version %d to %d", version, self.CURRENT_VERSION)
        
        -- Add migration logic here when CURRENT_VERSION increases
        -- Example: if version < 1 then ... end

        if settings then
            db:update("Settings", settings.id, { version = self.CURRENT_VERSION })
        else
            db:create("Settings", { version = self.CURRENT_VERSION })
        end
    end
end

function DBAPIPersistence:isAvailable()
    if g_currentMission and g_currentMission.missionDynamicInfo and g_currentMission.missionDynamicInfo.isMultiplayer then
        return false
    end

    local api = self:getAPI()
    if api == nil or not api.isReady() then
        return false
    end

    if not api.hasORM or not api.hasORM() then
        CustomUtils:warning("[DBAPIPersistence] DBAPI version too old (no ORM support)")
        return false
    end

    return true
end

function DBAPIPersistence:save(employeeManager, parkingManager, snapshotManager)
    local db = self:getDb()
    if not db then
        CustomUtils:error("[DBAPIPersistence] DBAPI ORM not available for save")
        return false
    end

    -- 1. Save Settings (singleton)
    local settings = {
        nextEmployeeId = employeeManager.nextEmployeeId or 1,
        lastPoolRefreshDay = employeeManager.lastPoolRefreshDay or 0,
        lastPaymentPeriod = employeeManager.lastPaymentPeriod or 0
    }
    local sRec, _ = db:find("Settings")
    if sRec then
        db:update("Settings", sRec.id, settings)
    else
        db:create("Settings", settings)
    end

    -- 2. Save Parking (singleton)
    if parkingManager then
        local pData = {
            spots = parkingManager.spots or {},
            nextSpotId = parkingManager.nextSpotId or 1
        }
        local pRec, _ = db:find("Parking")
        if pRec then
            db:update("Parking", pRec.id, pData)
        else
            db:create("Parking", pData)
        end
    end

    -- 3. Save Employees
    -- Clear existing records to avoid duplicates and bloat
    local existing, _ = db:findAll("Employee")
    if existing then
        for _, rec in ipairs(existing) do
            db:delete("Employee", rec.id)
        end
    end

    local count = 0
    for _, e in ipairs(employeeManager.employees) do
        local _, err = db:create("Employee", { data = e:toTable() })
        if not err then
            count = count + 1
        else
            CustomUtils:error("[DBAPIPersistence] Failed to save employee %d: %s", e.id, tostring(err))
        end
    end

    -- 4. Save Field Configs
    local existingFC, _ = db:findAll("FieldConfig")
    if existingFC then
        for _, rec in ipairs(existingFC) do
            db:delete("FieldConfig", rec.id)
        end
    end

    local fcCount = 0
    for fieldId, config in pairs(employeeManager.fieldConfigs or {}) do
        local _, err = db:create("FieldConfig", { fieldId = fieldId, cropName = config.cropName or "" })
        if not err then
            fcCount = fcCount + 1
        end
    end

    -- 5. Save Vehicle Snapshots
    if snapshotManager then
        local snapData = snapshotManager:toTable()
        local snapRec, _ = db:find("VehicleSnapshot")
        if snapRec then
            db:update("VehicleSnapshot", snapRec.id, { snapshots = snapData })
        else
            db:create("VehicleSnapshot", { snapshots = snapData })
        end
    end

    CustomUtils:info("[DBAPIPersistence] Saved %d employees and %d field configs via DBAPI ORM", count, fcCount)
    return true
end

function DBAPIPersistence:load(employeeManager, parkingManager, snapshotManager)
    local db = self:getDb()
    if not db then
        CustomUtils:error("[DBAPIPersistence] DBAPI ORM not available for load")
        return false
    end

    -- 1. Load Settings
    local sRec, _ = db:find("Settings")
    if sRec then
        employeeManager.nextEmployeeId = sRec.nextEmployeeId or 1
        employeeManager.lastPoolRefreshDay = sRec.lastPoolRefreshDay or 0
        employeeManager.lastPaymentPeriod = sRec.lastPaymentPeriod or 0
    end

    -- 2. Load Parking
    if parkingManager then
        local pRec, _ = db:find("Parking")
        if pRec then
            parkingManager.spots = pRec.spots or {}
            parkingManager.nextSpotId = pRec.nextSpotId or 1
            CustomUtils:debug("[DBAPIPersistence] Loaded %d parking spots", #parkingManager.spots)
        end
    end

    -- 3. Load Employees
    local emps, _ = db:findAll("Employee")
    if emps and #emps > 0 then
        employeeManager.employees = {}
        local maxId = 0
        local hiredCount = 0
        for _, rec in ipairs(emps) do
            if rec.data then
                local emp = Employee.fromTable(rec.data)
                if emp then
                    -- Re-assign vehicle if needed
                    if emp.assignedVehicleId and emp.assignedVehicleId ~= 0 then
                        local vehicle = employeeManager:getVehicleById(emp.assignedVehicleId)
                        if vehicle then
                            emp:assignVehicle(vehicle)
                        end
                    end
                    table.insert(employeeManager.employees, emp)
                    if emp.id > maxId then maxId = emp.id end
                    if emp.isHired then hiredCount = hiredCount + 1 end
                end
            end
        end

        -- Sync nextEmployeeId if needed
        if employeeManager.nextEmployeeId <= maxId then
            employeeManager.nextEmployeeId = maxId + 1
        end

        CustomUtils:info("[DBAPIPersistence] Loaded %d employees (%d hired) via DBAPI ORM", #employeeManager.employees, hiredCount)
    else
        CustomUtils:info("[DBAPIPersistence] No employee data found in DBAPI ORM")
    end

    -- 4. Load Field Configs
    local fcs, _ = db:findAll("FieldConfig")
    employeeManager.fieldConfigs = {}
    if fcs then
        for _, rec in ipairs(fcs) do
            employeeManager.fieldConfigs[rec.fieldId] = { cropName = rec.cropName }
        end
        CustomUtils:debug("[DBAPIPersistence] Loaded %d field configs", #fcs)
    end

    -- 5. Load Vehicle Snapshots
    if snapshotManager then
        local snapRec, _ = db:find("VehicleSnapshot")
        if snapRec and snapRec.snapshots then
            snapshotManager:fromTable(snapRec.snapshots)
        end
    end

    -- Fill pool if empty or low
    local numToGenerate = 10 - #employeeManager.employees
    if numToGenerate > 0 then
        CustomUtils:info("[DBAPIPersistence] Filling pool: generating %d candidates", numToGenerate)
        employeeManager:generateInitialPool(numToGenerate)
    end

    return #employeeManager.employees > 0
end
