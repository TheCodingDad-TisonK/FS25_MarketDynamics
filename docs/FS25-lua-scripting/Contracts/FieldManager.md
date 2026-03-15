## FieldManager

**Description**

> This class handles all functionality for AI fields and the NPCs handling them.

**Parent**

> [AbstractManager](?version=script&category=18&class=187)

**Functions**

- [delete](#delete)
- [initDataStructures](#initdatastructures)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadMapData](#loadmapdata)
- [new](#new)
- [saveToXMLFile](#savetoxmlfile)
- [unloadMapData](#unloadmapdata)

### delete

**Description**

> Deletes field manager

**Definition**

> delete()

**Code**

```lua
function FieldManager:delete()
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function FieldManager:initDataStructures()
    self.fields = { }
    self.farmlandIdFieldMapping = { }
    self.currentFieldPartitionIndex = nil
    self.nextCheckTime = 0
    self.nextUpdateTime = 0
    self.nextFieldCheckIndex = 0
    self.updateTasks = { }
    self.fieldNumUpdateTasks = { }
    self.pendingFieldUpdatesMapping = { }
    self.pendingFieldUpdates = { }

    self.fieldStateUpdateIndex = 0
    self.fieldsDoStateUpdate = { }

    self.debugField = nil
end

```

### loadFromXMLFile

**Description**

> Load field savegame data

**Definition**

> loadFromXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | savegame xml file name |
|--------|-------------|------------------------|

**Code**

```lua
function FieldManager:loadFromXMLFile(xmlFilename)
    local xmlFile = XMLFile.load( "fields" , xmlFilename, FieldManager.xmlSchemaSavegame)
    if xmlFile = = nil then
        return
    end

    for _, key in xmlFile:iterator( "fields.field" ) do
        local fieldId = xmlFile:getInt(key .. "#id" )
        if fieldId ~ = nil then
            local field = self:getFieldById(fieldId)
            if field ~ = nil then
                field:loadFromXMLFile(xmlFile, key)
            end
        end
    end

    self.pendingFieldUpdates = { }
    self.pendingFieldUpdatesMapping = { }
    for _, key in xmlFile:iterator( "fields.pendingUpdate" ) do
        local fieldId = xmlFile:getInt(key .. "#fieldId" )
        if fieldId ~ = nil then
            local field = self:getFieldById(fieldId)
            if field ~ = nil then
                table.insert( self.pendingFieldUpdates, field)
                self.pendingFieldUpdatesMapping[field] = true
            end
        end
    end

    for _, key in xmlFile:iterator( "fields.task" ) do
        local className = xmlFile:getString(key .. "#className" , "FieldUpdateTask" )
        local class = ClassUtil.getClassObject(className)
        if class ~ = nil then
            local updateTask = class.new()
            if updateTask:loadFromXMLFile(xmlFile, key) then
                self:addFieldUpdateTask(updateTask)
            end
        end
    end

    xmlFile:delete()
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData(XMLFile xmlFile, , )

**Arguments**

| XMLFile | xmlFile       | map xml file instance |
|---------|---------------|-----------------------|
| any     | missionInfo   |                       |
| any     | baseDirectory |                       |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function FieldManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    FieldManager:superClass().loadMapData( self )

    local mission = g_currentMission
    self.mission = mission
    mission:addUpdateable( self )

    local fieldGroundSystem = mission.fieldGroundSystem
    self.groundTypeSown = FieldGroundType.getValueByType(FieldGroundType.SOWN)
    self.sprayTypeFertilizer = FieldSprayType.getValueByType(FieldSprayType.FERTILIZER)
    self.sprayTypeLime = FieldSprayType.getValueByType(FieldSprayType.LIME)
    self.sprayLevelMaxValue = fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
    self.plowLevelMaxValue = Platform.gameplay.usePlowCounter and fieldGroundSystem:getMaxValue(FieldDensityMap.PLOW_LEVEL) or 0
    self.limeLevelMaxValue = Platform.gameplay.useLimeCounter and fieldGroundSystem:getMaxValue(FieldDensityMap.LIME_LEVEL) or 0

    -- create list of valid/available fruit types
    self.availableFruitTypeIndices = { }
    for _, fruitType in ipairs(g_fruitTypeManager:getFruitTypes()) do
        if fruitType.useForFieldMissions and fruitType.allowsSeeding then
            table.insert( self.availableFruitTypeIndices, fruitType.index)
        end
    end
    self.fruitTypesCount = # self.availableFruitTypeIndices

    self.fieldIndexToCheck = 1

    local farmlandInfoLayer = g_farmlandManager:getLocalMap()
    local modifier = DensityMapModifier.new(farmlandInfoLayer, 0 , g_farmlandManager.numberOfBits, g_terrainNode)
    local filter = DensityMapFilter.new(modifier)

    -- Connect farmlands to fields first.We need the farmlands to skip overriding owned fields(in order to have working starter fields)
    for i, field in ipairs( self.fields) do
        g_asyncTaskManager:addSubtask( function ()
            local isValid = true
            local posX, posZ = field:getCenterOfFieldWorldPosition()
            local farmland = g_farmlandManager:getFarmlandAtWorldPosition(posX, posZ)
            if farmland ~ = nil then
                if self.farmlandIdFieldMapping[farmland.id] ~ = nil then
                    Logging.error( "FieldManager - There already exists field '%d' on farmland '%s'" , i, farmland.id)
                    isValid = false
                end

                filter:setValueCompareParams(DensityValueCompareType.NOTEQUAL, farmland.id)
                modifier:clearPolygonPoints()

                for _, point in ipairs(field:getPolygonPoints()) do
                    local x, _, z = getWorldTranslation(point)
                    modifier:addPolygonPointWorldCoords(x, z)
                end

                local _, numPixels, _ = modifier:executeGet(filter)

                if numPixels > 0 then
                    local numFarmlands = #g_farmlandManager:getFarmlands()
                    for j = 0 , numFarmlands do
                        if j ~ = farmland.id then
                            filter:setValueCompareParams(DensityValueCompareType.EQUAL, j)
                            local _, numPixelsI, _ = modifier:executeGet(filter)
                            if numPixelsI > 0 then
                                Logging.error( "FieldManager - Field '%d' with center on farmland '%d' touches farmland '%d' with '%d' pixels" , i, farmland.id, j, numPixelsI)
                                isValid = false
                            end
                        end
                    end
                end
            else
                    Logging.error( "FieldManager - Failed to find farmland in center of field '%s' at %d %d" , i, posX, posZ)
                    isValid = false
                end

                if isValid then
                    field:setFarmland(farmland)
                    farmland:setField(field)
                    self.farmlandIdFieldMapping[farmland.id] = field
                end
            end , string.format( "FieldManager:loadMapData - Field '%d'" , i))
        end

        -- New save game
        if not mission.missionInfo.isValid and g_server ~ = nil and not Profiler.IS_INITIALIZED then
            local preplantedFields = { }

            local filename = getXMLString(xmlFile, "map.fields#filename" )
            if filename ~ = nil then
                local xmlFilename = Utils.getFilename(filename, baseDirectory)
                local fieldsXMLFile = XMLFile.load( "fieldsXML" , xmlFilename, FieldManager.xmlSchema)
                if fieldsXMLFile ~ = nil then
                    for _, fieldKey in fieldsXMLFile:iterator( "map.fields.field" ) do
                        g_asyncTaskManager:addSubtask( function ()
                            local fieldId = fieldsXMLFile:getValue(fieldKey .. "#fieldId" )
                            local field = self:getFieldById(fieldId)
                            if field ~ = nil then
                                local className = fieldsXMLFile:getString(fieldKey .. "#className" , "FieldUpdateTask" )
                                local class = ClassUtil.getClassObject(className)
                                if class ~ = nil then
                                    local updateTask = class.new()
                                    if updateTask:loadFromXMLFile(fieldsXMLFile, fieldKey) then
                                        self:addFieldUpdateTask(updateTask)
                                        preplantedFields[field] = true
                                    end
                                end
                            end
                        end )
                    end

                    g_asyncTaskManager:addSubtask( function ()
                        fieldsXMLFile:delete()
                    end )
                end
            end

            for _, field in pairs( self.fields) do
                g_asyncTaskManager:addSubtask( function ()
                    if not field:getHasOwner() and field.isMissionAllowed and preplantedFields[field] = = nil then
                        -- Plan a random fruit for the NPC
                            local fruitIndex = table.getRandomElement( self.availableFruitTypeIndices)
                            if field.grassMissionOnly then
                                fruitIndex = FruitType.GRASS
                            end

                            local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitIndex)
                            if fruitTypeDesc = = nil then
                                return
                            end

                            local growthState = fruitTypeDesc:getRandomInitialState(g_currentMission.missionInfo.growthMode)
                            local weedState = 0
                            local stoneLevel = 0
                            local groundType = FieldGroundType.SOWN
                            local groundAngle = field:getAngle()
                            local sprayType = FieldSprayType.NONE
                            local sprayLevel = math.random( 0 , self.sprayLevelMaxValue)
                            local plowLevel = math.random( 0 , self.plowLevelMaxValue)
                            local limeLevel = math.random( 0 , self.limeLevelMaxValue)

                            if growthState ~ = nil then
                                if fruitTypeDesc.plantsWeed then
                                    -- Add some randomness:older plants have higher chance of older weeds
                                    if growthState > 4 then
                                        weedState = math.random( 3 , 9 )
                                    else
                                            weedState = math.random( 1 , 7 )
                                        end
                                    end

                                    groundType = fruitTypeDesc:getGrowthStateGroundType(growthState) or groundType
                                else
                                        fruitIndex = nil

                                        groundType = math.random() < 0.5 and FieldGroundType.CULTIVATED or FieldGroundType.PLOWED
                                        if groundType = = FieldGroundType.PLOWED then
                                            plowLevel = self.plowLevelMaxValue
                                        end

                                        if sprayLevel > 0 then
                                            sprayType = math.random() < 0.7 and FieldSprayType.LIQUID_MANURE or FieldSprayType.MANURE
                                        end
                                        if limeLevel > 0 and math.random() < 0.1 then
                                            sprayType = FieldSprayType.LIME
                                        end
                                    end

                                    if not mission.missionInfo.plowingRequiredEnabled then
                                        plowLevel = self.plowLevelMaxValue
                                    end

                                    local task = FieldUpdateTask.new()
                                    task:setField(field)
                                    task:setFruit(fruitIndex, growthState)
                                    task:setWeedState(weedState)
                                    task:setStoneLevel(stoneLevel)
                                    task:setGroundType(groundType)
                                    task:setGroundAngle(groundAngle)
                                    task:setSprayType(sprayType)
                                    task:setSprayLevel(sprayLevel)
                                    task:setLimeLevel(limeLevel)
                                    task:setPlowLevel(plowLevel)
                                    task:clearHeight()

                                    self:addFieldUpdateTask(task)
                                end
                            end )
                        end
                    end

                    g_asyncTaskManager:addSubtask( function ()
                        if mission:getIsServer() then
                            if g_addCheatCommands then
                                addConsoleCommand( "gsFieldSetState" , "Opens UI to set state for specific field(s)" , "consoleCommandSetFieldState" , self , "[fieldId]; [fruitName]; [growthState]" )
                                    addConsoleCommand( "gsFieldSetGround" , "Opens UI to set state for specific field(s)" , "consoleCommandSetFieldGround" , self , "[fieldId]; [groundTypeName]; [angle]; [groundLayer]; [fertilizerState]; [plowingState]; [weedState]; [limeState]; [stubbleState]; [buyField]; [removeFoliage]" )
                                    end
                                end

                                if g_addCheatCommands then
                                    addConsoleCommand( "gsFieldToggleStatus" , "Shows field status" , "consoleCommandToggleDebugFieldStatus" , self )
                                    addConsoleCommand( "gsFieldToggleNPCLogging" , "Toggle field npc action logging" , "consoleCommandToggleDebugFieldNPCLogging" , self )
                                end
                            end )

                            -- On clients, force all fields to have some value so map at least shows them
                            g_asyncTaskManager:addSubtask( function ()
                                if not mission:getIsServer() then
                                    for _, field in pairs( self.fields) do
                                        local task = FieldUpdateTask.new()
                                        task:setField(field)
                                        task:setGroundType(FieldGroundType.CULTIVATED)
                                        task:setGroundAngle(field:getAngle())
                                        self:addFieldUpdateTask(task)
                                    end
                                end

                                -- run pending update tasks
                                while true do
                                    local task = table.remove( self.updateTasks, 1 )
                                    if task = = nil then
                                        break
                                    end

                                    g_asyncTaskManager:addSubtask( function ()
                                        task:start()
                                        while not task:getIsFinished() do
                                            task:update( 1 )
                                        end
                                        self:onFinishFieldUpdateTask(task)
                                    end )
                                end
                            end )

                            g_messageCenter:subscribe(MessageType.FINISHED_GROWTH_PERIOD, self.onFinishedGrowthPeriod, self )
                            g_messageCenter:subscribe(MessageType.MISSION_GENERATION_START, self.onMissionGenerationStart, self )
                            g_messageCenter:subscribe(MessageType.MISSION_GENERATION_END, self.onMissionGenerationEnd, self )

                            local cellsize = 0.5 --g_currentMission.terrainSize / self.defaultMissionMapWidth
                            self.debugBitVectorMap = DebugBitVectorMap.newSimple( 5 , cellsize, false , 0.1 )
                            local fieldState = FieldState.new()
                            local textColor = Color.new( 1 , 1 , 1 , 0.7 )
                            self.debugBitVectorMap:createWithCustomFunc( function (instance, startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
                                local centerX = (startWorldX + widthWorldX) * 0.5 --(startWorldX + widthWorldX + heightWorldX) / 3
                                local centerZ = (startWorldZ + heightWorldZ) * 0.5 --(startWorldZ + widthWorldZ + heightWorldZ) / 3

                                fieldState:update(centerX, centerZ)

                                if fieldState.groundType = = 0 then
                                    return 0
                                end

                                local y = getTerrainHeightAtWorldPos(g_terrainNode, centerX, 0 , centerZ)
                                fieldState:drawDebugAtWorldPosition(centerX, y, centerZ, 0.008 , textColor)

                                return 1
                            end )
                            self.debugBitVectorMap.getShouldBeDrawn = function ()
                                return FieldManager.DEBUG_SHOW_FIELDSTATUS
                            end
                            g_debugManager:addElement( self.debugBitVectorMap)
                        end

```

### new

**Description**

> Creating manager

**Definition**

> new(table customMt)

**Arguments**

| table | customMt | custom metatable |
|-------|----------|------------------|

**Return Values**

| table | instance | of the field manager |
|-------|----------|----------------------|

**Code**

```lua
function FieldManager.new(customMt)
    local self = AbstractManager.new(customMt or FieldManager _mt)

    return self
end

```

### saveToXMLFile

**Description**

> Write field data

**Definition**

> saveToXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | file path |
|--------|-------------|-----------|

**Code**

```lua
function FieldManager:saveToXMLFile(xmlFilename)
    local xmlFile = XMLFile.create( "fields" , xmlFilename, "fields" , FieldManager.xmlSchemaSavegame)

    for k, field in ipairs( self.fields) do
        local key = string.format( "fields.field(%d)" , k - 1 )
        local id = field:getId()
        if id ~ = nil then
            xmlFile:setInt(key .. "#id" , field:getId())
            field:saveToXMLFile(xmlFile, key)
        end
    end

    if self.pendingFieldUpdates ~ = nil then
        for k, field in ipairs( self.pendingFieldUpdates) do
            local id = field:getId()
            if id ~ = nil then
                local key = string.format( "fields.pendingUpdate(%d)" , k - 1 )
                xmlFile:setInt(key .. "#fieldId" , id)
            end
        end
    end

    for k, updateTask in ipairs( self.updateTasks) do
        local needsSaving = updateTask.needsSaving
        if needsSaving or needsSaving = = nil then
            local key = string.format( "fields.task(%d)" , k - 1 )
            xmlFile:setString(key .. "#className" , ClassUtil.getClassNameByObject(updateTask))
            updateTask:saveToXMLFile(xmlFile, key)
        end
    end

    xmlFile:save()
    xmlFile:delete()
end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function FieldManager:unloadMapData()
    if self.mission ~ = nil then
        self.mission:removeUpdateable( self )
    end

    for _, field in pairs( self.fields) do
        field:delete()
    end
    self.fields = { }
    self.fieldsToCheck = nil
    self.fieldsToUpdate = nil

    self.fieldGroundSystem = nil
    self.mission = nil

    g_messageCenter:unsubscribeAll( self )

    removeConsoleCommand( "gsFieldSetState" )
    removeConsoleCommand( "gsFieldSetGround" )
    removeConsoleCommand( "gsFieldToggleStatus" )
    removeConsoleCommand( "gsFieldToggleNPCLogging" )

    FieldManager:superClass().unloadMapData( self )
end

```