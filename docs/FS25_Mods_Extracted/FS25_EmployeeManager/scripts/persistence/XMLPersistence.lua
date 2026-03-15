XMLPersistence = {}
XMLPersistence.__index = XMLPersistence

function XMLPersistence:new()
    return setmetatable({}, self)
end

function XMLPersistence:getName()
    return "XML"
end

function XMLPersistence:isAvailable()
    return true
end

function XMLPersistence:getSavegameDirectory()
    if g_currentMission and g_currentMission.missionInfo then
        return g_currentMission.missionInfo.savegameDirectory
    end
    return nil
end

function XMLPersistence:save(employeeManager, parkingManager, snapshotManager)
    local dir = self:getSavegameDirectory()
    if dir == nil then
        CustomUtils:warning("[XMLPersistence] No savegame directory, cannot save")
        return false
    end

    local xmlPath = dir .. "/employeeManager.xml"
    local xmlFile = createXMLFile("employeeManagerXML", xmlPath, "employeeManager")
    if xmlFile == nil or xmlFile == 0 then
        CustomUtils:error("[XMLPersistence] Failed to create save file: %s", xmlPath)
        return false
    end

    employeeManager:saveToXMLFile(xmlFile, "employeeManager")

    -- Save Field Configs
    local fieldKey = "employeeManager.fieldConfigs"
    local fIdx = 0
    for fieldId, config in pairs(employeeManager.fieldConfigs or {}) do
        local base = string.format("%s.fieldConfig(%d)", fieldKey, fIdx)
        setXMLInt(xmlFile, base .. "#fieldId", fieldId)
        setXMLString(xmlFile, base .. "#cropName", config.cropName or "")
        fIdx = fIdx + 1
    end

    -- Save Vehicle Snapshots
    if snapshotManager then
        local snapData = snapshotManager:toTable()
        local sIdx = 0
        for empIdStr, snap in pairs(snapData) do
            local base = string.format("employeeManager.vehicleSnapshots.snapshot(%d)", sIdx)
            setXMLString(xmlFile, base .. "#employeeId", empIdStr)
            setXMLFloat(xmlFile, base .. ".vehicle#id", snap.vehicle.id or 0)
            setXMLString(xmlFile, base .. ".vehicle#name", snap.vehicle.name or "")
            setXMLFloat(xmlFile, base .. ".vehicle#x", snap.vehicle.x)
            setXMLFloat(xmlFile, base .. ".vehicle#y", snap.vehicle.y)
            setXMLFloat(xmlFile, base .. ".vehicle#z", snap.vehicle.z)
            setXMLFloat(xmlFile, base .. ".vehicle#angle", snap.vehicle.angle or 0)

            for tIdx, tool in ipairs(snap.tools or {}) do
                local tBase = string.format("%s.tool(%d)", base, tIdx - 1)
                setXMLFloat(xmlFile, tBase .. "#id", tool.id or 0)
                setXMLString(xmlFile, tBase .. "#name", tool.name or "")
                setXMLFloat(xmlFile, tBase .. "#x", tool.x)
                setXMLFloat(xmlFile, tBase .. "#y", tool.y)
                setXMLFloat(xmlFile, tBase .. "#z", tool.z)
                setXMLFloat(xmlFile, tBase .. "#angle", tool.angle or 0)
            end
            sIdx = sIdx + 1
        end
    end

    saveXMLFile(xmlFile)
    delete(xmlFile)

    local hiredCount = 0
    for _, e in ipairs(employeeManager.employees) do
        if e.isHired then hiredCount = hiredCount + 1 end
    end
    CustomUtils:info("[XMLPersistence] Saved %d employees (%d hired) to %s", #employeeManager.employees, hiredCount, xmlPath)
    return true
end

function XMLPersistence:load(employeeManager, parkingManager, snapshotManager)
    local dir = self:getSavegameDirectory()
    if dir == nil then
        CustomUtils:warning("[XMLPersistence] No savegame directory available for loading")
        return false
    end

    local xmlPath = dir .. "/employeeManager.xml"
    if not fileExists(xmlPath) then
        CustomUtils:info("[XMLPersistence] No save file found at %s", xmlPath)
        return false
    end

    CustomUtils:info("[XMLPersistence] Loading from: %s", xmlPath)
    local xmlFile = loadXMLFile("employeeManagerXML", xmlPath)
    if xmlFile == nil or xmlFile == 0 then
        CustomUtils:error("[XMLPersistence] Failed to load file: %s", xmlPath)
        return false
    end

    employeeManager:loadFromXMLFile(xmlFile, "employeeManager")

    -- Load Field Configs
    employeeManager.fieldConfigs = {}
    local fieldKey = "employeeManager.fieldConfigs"
    local fIdx = 0
    while true do
        local base = string.format("%s.fieldConfig(%d)", fieldKey, fIdx)
        local fId = getXMLInt(xmlFile, base .. "#fieldId")
        if not fId then break end
        local cName = getXMLString(xmlFile, base .. "#cropName")
        employeeManager.fieldConfigs[fId] = { cropName = cName }
        fIdx = fIdx + 1
    end

    -- Load Vehicle Snapshots
    if snapshotManager then
        local snapData = {}
        local sIdx = 0
        while true do
            local base = string.format("employeeManager.vehicleSnapshots.snapshot(%d)", sIdx)
            local empIdStr = getXMLString(xmlFile, base .. "#employeeId")
            if not empIdStr then break end

            local snap = {
                employeeId = tonumber(empIdStr),
                timestamp = 0,
                vehicle = {
                    id = getXMLFloat(xmlFile, base .. ".vehicle#id") or 0,
                    name = getXMLString(xmlFile, base .. ".vehicle#name") or "",
                    x = getXMLFloat(xmlFile, base .. ".vehicle#x") or 0,
                    y = getXMLFloat(xmlFile, base .. ".vehicle#y") or 0,
                    z = getXMLFloat(xmlFile, base .. ".vehicle#z") or 0,
                    angle = getXMLFloat(xmlFile, base .. ".vehicle#angle") or 0
                },
                tools = {}
            }

            local tIdx = 0
            while true do
                local tBase = string.format("%s.tool(%d)", base, tIdx)
                local tId = getXMLFloat(xmlFile, tBase .. "#id")
                if not tId then break end
                table.insert(snap.tools, {
                    id = tId,
                    name = getXMLString(xmlFile, tBase .. "#name") or "",
                    x = getXMLFloat(xmlFile, tBase .. "#x") or 0,
                    y = getXMLFloat(xmlFile, tBase .. "#y") or 0,
                    z = getXMLFloat(xmlFile, tBase .. "#z") or 0,
                    angle = getXMLFloat(xmlFile, tBase .. "#angle") or 0
                })
                tIdx = tIdx + 1
            end

            snapData[empIdStr] = snap
            sIdx = sIdx + 1
        end
        snapshotManager:fromTable(snapData)
    end

    delete(xmlFile)

    local hiredCount = 0
    for _, e in ipairs(employeeManager.employees) do
        if e.isHired then hiredCount = hiredCount + 1 end
    end
    CustomUtils:info("[XMLPersistence] Loaded %d employees (%d hired)", #employeeManager.employees, hiredCount)
    return #employeeManager.employees > 0
end
