## PlaceableSystem

**Functions**

- [addBunkerSilo](#addbunkersilo)
- [addFarmhouse](#addfarmhouse)
- [addPendingPlaceableLoad](#addpendingplaceableload)
- [addPlaceable](#addplaceable)
- [addWeatherStation](#addweatherstation)
- [canStartMission](#canstartmission)
- [consoleCommandDeleteAllPlaceables](#consolecommanddeleteallplaceables)
- [consoleCommandLoadAllPlaceables](#consolecommandloadallplaceables)
- [consoleCommandReloadAllPlaceables](#consolecommandreloadallplaceables)
- [delete](#delete)
- [deleteAll](#deleteall)
- [getBunkerSilos](#getbunkersilos)
- [getExistingPlaceableByXMLFilename](#getexistingplaceablebyxmlfilename)
- [getFarmhouse](#getfarmhouse)
- [getHasWeatherStation](#gethasweatherstation)
- [loadPlaceableFinished](#loadplaceablefinished)
- [loadPlaceableFromXML](#loadplaceablefromxml)
- [new](#new)
- [removeBunkerSilo](#removebunkersilo)
- [removeFarmhouse](#removefarmhouse)
- [removePendingPlaceableLoad](#removependingplaceableload)
- [removePlaceable](#removeplaceable)
- [removeWeatherStation](#removeweatherstation)
- [save](#save)
- [saveToXML](#savetoxml)

### addBunkerSilo

**Description**

**Definition**

> addBunkerSilo()

**Arguments**

| any | bunkerSilo |
|-----|------------|

**Code**

```lua
function PlaceableSystem:addBunkerSilo(bunkerSilo)
    table.addElement( self.bunkerSilos, bunkerSilo)
end

```

### addFarmhouse

**Description**

**Definition**

> addFarmhouse()

**Arguments**

| any | farmhouse |
|-----|-----------|

**Code**

```lua
function PlaceableSystem:addFarmhouse(farmhouse)
    table.addElement( self.farmhouses, farmhouse)
end

```

### addPendingPlaceableLoad

**Description**

**Definition**

> addPendingPlaceableLoad()

**Arguments**

| any | placeableLoadingData |
|-----|----------------------|

**Code**

```lua
function PlaceableSystem:addPendingPlaceableLoad(placeableLoadingData)
    table.addElement( self.pendingPlaceableLoadingData, placeableLoadingData)
end

```

### addPlaceable

**Description**

**Definition**

> addPlaceable()

**Arguments**

| any | placeable |
|-----|-----------|

**Code**

```lua
function PlaceableSystem:addPlaceable(placeable)
    if placeable = = nil or placeable:isa( Placeable ) = = nil then
        Logging.error( "Given object is not a placeable" )
        return
    end

    local uniqueId = placeable:getUniqueId()

    -- Ensure the hand tool has not already been added.
    if uniqueId ~ = nil and self.placableByUniqueId[uniqueId] ~ = nil then
        Logging.warning( "Tried to add existing placeable with unique id of %s! Existing: %s, new: %s" , uniqueId, tostring( self.placableByUniqueId[uniqueId]), tostring(placeable))
        return
    end

    -- If the placeable has no unique id, give it one.
    if uniqueId = = nil then
        uniqueId = Utils.getUniqueId(placeable, self.placableByUniqueId, PlaceableSystem.UNIQUE_ID_PREFIX)
        placeable:setUniqueId(uniqueId)
    end

    table.addElement( self.placeables, placeable)
    self.placableByUniqueId[uniqueId] = placeable
end

```

### addWeatherStation

**Description**

**Definition**

> addWeatherStation()

**Arguments**

| any | weatherStation |
|-----|----------------|

**Code**

```lua
function PlaceableSystem:addWeatherStation(weatherStation)
    table.addElement( self.weatherStations, weatherStation)
end

```

### canStartMission

**Description**

**Definition**

> canStartMission()

**Code**

```lua
function PlaceableSystem:canStartMission()
    for i = 1 , # self.placeables do
        if not self.placeables[i]:getIsSynchronized() then
            return false
        end
    end

    if # self.pendingPlaceableLoadingData > 0 then
        return false
    end

    return true
end

```

### consoleCommandDeleteAllPlaceables

**Description**

**Definition**

> consoleCommandDeleteAllPlaceables()

**Arguments**

| any | includePreplaced |
|-----|------------------|

**Code**

```lua
function PlaceableSystem:consoleCommandDeleteAllPlaceables(includePreplaced)
    local usage = "Usage:gsPlaceablesDeleteAll [includePreplaced]"
    local numDeleted = 0

    for i = # self.placeables, 1 , - 1 do
        local placeable = self.placeables[i]
        if not placeable:getIsPreplaced() or includePreplaced then
            placeable:delete()
            numDeleted = numDeleted + 1
        end
    end

    if includePreplaced then
        return string.format( "Deleted all %i placeables! Included preplaced ones!" , numDeleted)
    end

    return string.format( "Deleted %i placeables! Excluded preplaced ones.\n%s" , numDeleted, usage)
end

```

### consoleCommandLoadAllPlaceables

**Description**

**Definition**

> consoleCommandLoadAllPlaceables()

**Code**

```lua
function PlaceableSystem:consoleCommandLoadAllPlaceables()
    if self.isLoadAllRunning then
        return "Cannot start loading all placeables.Another loading is currently running"
    end
    if not g_currentMission:getIsServer() or g_currentMission.missionDynamicInfo.isMultiplayer then
        return "Placeable loading only allowed in SP"
    end

    local placeablesToLoad = { }
    for _, storeItem in ipairs(g_storeManager:getItems()) do
        if storeItem.brush ~ = nil and storeItem.brush.type ~ = "" then
            -- handle fences
            if storeItem.brush.type = = "fence" then
                local singletonFilename = storeItem.brush.parameters[ 1 ]
                if singletonFilename ~ = nil then
                    table.insert(placeablesToLoad, singletonFilename)
                else
                        Logging.error( "No fence singleton filename found for '%s'" , storeItem.xmlFilename)
                        end
                    else
                            table.insert(placeablesToLoad, storeItem)
                        end
                    end
                end

                if #placeablesToLoad = = 0 then
                    return "No placeables found"
                end

                g_i3DManager:clearEntireSharedI3DFileCache( false )

                self.isLoadAllRunning = true
                Logging.info( "Start loading all placeables .. ." )

                local x, z = 0 , 0
                local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)

                local loadNextPlaceable

                local function callback(_, loadedPlaceable, placeableLoadingState, args)
                    if placeableLoadingState ~ = PlaceableLoadingState.OK then
                        Logging.error( "Could not load placeable '%s', PlaceableLoadingState: %s" , args.filename, EnumUtil.getName(PlaceableLoadingState, placeableLoadingState))
                    else
                            Logging.info( "Loaded placeable '%s'" , loadedPlaceable.configFileName)
                            loadedPlaceable:finalizePlacement()
                        end

                        if loadedPlaceable ~ = nil then
                            loadedPlaceable:delete()
                        end
                        table.remove(placeablesToLoad, 1 )

                        if #placeablesToLoad = = 0 then
                            self.isLoadAllRunning = false
                            print( "Finished loading placeables" )
                        else
                                local nextItem = placeablesToLoad[ 1 ]
                                loadNextPlaceable(nextItem)
                            end
                        end

                        loadNextPlaceable = function (storeItem)
                            local data = PlaceableLoadingData.new()
                            data:setStoreItem(storeItem)
                            data:setSavegameData( nil )
                            data:setPosition(x, y, z)
                            data:setRotation( 0 , 0 , 0 )
                            data:load(callback, nil , { filename = storeItem.xmlFilename } )
                        end

                        loadNextPlaceable(placeablesToLoad[ 1 ])

                        return
                    end

```

### consoleCommandReloadAllPlaceables

**Description**

**Definition**

> consoleCommandReloadAllPlaceables()

**Code**

```lua
function PlaceableSystem:consoleCommandReloadAllPlaceables()
    if self.isReloadRunning then
        return "Cannot start reloading.Another reloading is currently running"
    end

    if not g_currentMission:getIsServer() or g_currentMission.missionDynamicInfo.isMultiplayer then
        return "Placeable reloading only allowed in SP"
    end

    local xmlFile
    local numPlaceables = 0
    if self.reloadPlaceableSavegame = = nil then
        g_i3DManager:clearEntireSharedI3DFileCache( false )
        Logging.info( "Start reloading placeables(non preplaced placables) .. ." )

        xmlFile = XMLFile.create( "placeableXMLFile" , "" , "placeables" , Placeable.xmlSchemaSavegame)

        local usedModNames = { }
        self:saveToXML(xmlFile, usedModNames, false )

        for i = # self.placeables, 1 , - 1 do
            local placeable = self.placeables[i]
            if not placeable.isPreplaced then
                placeable.isReloading = true -- flag to skip actions in onDelete() such as resetting of indoor areas(old placeable is deleted after new one was loaded)
                placeable:delete()
                numPlaceables = numPlaceables + 1
            end
        end
    else
            Logging.info( "Restart reloading placeables with remaining placeables .. ." )
            xmlFile = self.reloadPlaceableSavegame

            numPlaceables = xmlFile:getNumOfElements( "placeables.placeable" )
        end

        function callback(_, loadedPlaceables, placeableLoadingState, args)
            for _, placeable in ipairs(loadedPlaceables) do
                local uniqueId = placeable:getUniqueId()

                for _, key in xmlFile:iterator( "placeables.placeable" ) do
                    local id = xmlFile:getValue(key .. "#uniqueId" )
                    if id = = uniqueId then
                        xmlFile:removeProperty(key)

                        Logging.info( "Reloaded placeable '%s'." , placeable.configFileName)
                        break
                    end
                end
            end

            local numElements = xmlFile:getNumOfElements( "placeables.placeable" )
            if numElements = = 0 then
                Logging.info( "Finished reloading." )
                xmlFile:delete()
                self.reloadPlaceableSavegame = nil
            else
                    self.reloadPlaceableSavegame = xmlFile
                    Logging.info( "Finished reloading. %d placeables could not be reloaded.Please fix the config/i3d and run the command again!" , numElements)
                end

                self.isReloadRunning = false
            end

            self.isReloadRunning = numPlaceables > 0

            if numPlaceables > 0 then
                g_asyncTaskManager:addTask( function ()
                    self:loadFromXMLFile(xmlFile, callback, nil , nil )
                end )
            else
                    return "No placeables found to reload"
                end

                return
            end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function PlaceableSystem:delete()
    for i = # self.pendingPlaceableLoadingData, 1 , - 1 do
        self.pendingPlaceableLoadingData[i]:cancelLoading()
    end

    for k, placeable in pairs( self.placeablesToDelete) do
        placeable:delete( true )
        self.placeablesToDelete[k] = nil
    end

    for i = # self.placeables, 1 , - 1 do
        local placeable = self.placeables[i]
        placeable:delete( true )
    end

    if self.savegameXMLFile ~ = nil then
        self.savegameXMLFile:delete()
        self.savegameXMLFile = nil
    end

    self.mission = nil
    self.boundary = nil
    self.placeables = { }
    self.savegameIdToPlaceable = { }
    self.farmhouses = { }
    self.bunkerSilos = { }
    self.preplacedPlaceableData = { }
    self.uniqueIdToReplacedPlaceableData = { }

    removeConsoleCommand( "gsPlaceablesDeleteAll" )
    removeConsoleCommand( "gsPlaceablesReloadAll" )
    removeConsoleCommand( "gsPlaceablesLoadAll" )
    removeConsoleCommand( "gsPlaceablesPendingLoadings" )
    removeConsoleCommand( "gsPlaceableSystemDrawBoundary" )
end

```

### deleteAll

**Description**

**Definition**

> deleteAll()

**Code**

```lua
function PlaceableSystem:deleteAll()

    local numDeleted = # self.placeables

    for i = # self.placeables, 1 , - 1 do
        local placeable = self.placeables[i]
        placeable:delete()
    end

    return numDeleted
end

```

### getBunkerSilos

**Description**

**Definition**

> getBunkerSilos()

**Code**

```lua
function PlaceableSystem:getBunkerSilos()
    return self.bunkerSilos
end

```

### getExistingPlaceableByXMLFilename

**Description**

> Returns first instance of the placeable with given config xml, optionally filtered for farmId
> Mainly useful for singleton placeables like fences, ricefields, etc.

**Definition**

> getExistingPlaceableByXMLFilename(string xmlFilename, integer? ownerFarmId, boolean? excludeBoughtWithFarmland)

**Arguments**

| string   | xmlFilename               |                                        |
|----------|---------------------------|----------------------------------------|
| integer? | ownerFarmId               | optionally filter for this ownerFarmId |
| boolean? | excludeBoughtWithFarmland |                                        |

**Return Values**

| boolean? | placeable | placeable instance or nil |
|----------|-----------|---------------------------|

**Code**

```lua
function PlaceableSystem:getExistingPlaceableByXMLFilename(xmlFilename, ownerFarmId, excludeBoughtWithFarmland)
    for _, placeable in ipairs( self.placeables) do
        if placeable.configFileName = = xmlFilename and not placeable.markedForDeletion then
            if ownerFarmId ~ = nil and placeable.ownerFarmId ~ = ownerFarmId then
                continue
            end

            if excludeBoughtWithFarmland and placeable.boughtWithFarmlandSavegameOverwrite then
                continue
            end

            return placeable
        end
    end

    return nil
end

```

### getFarmhouse

**Description**

**Definition**

> getFarmhouse()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function PlaceableSystem:getFarmhouse(farmId)
    for _, farmhouse in ipairs( self.farmhouses) do
        if farmId = = nil or farmhouse:getOwnerFarmId() = = farmId then
            return farmhouse
        end
    end

    return nil
end

```

### getHasWeatherStation

**Description**

**Definition**

> getHasWeatherStation()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function PlaceableSystem:getHasWeatherStation(farmId)
    for _, weatherStation in ipairs( self.weatherStations) do
        if farmId = = nil or weatherStation:getOwnerFarmId() = = farmId then
            return true
        end
    end

    return false
end

```

### loadPlaceableFinished

**Description**

**Definition**

> loadPlaceableFinished()

**Arguments**

| any | placeable    |
|-----|--------------|
| any | loadingState |
| any | arguments    |

**Code**

```lua
function PlaceableSystem:loadPlaceableFinished(placeable, loadingState, arguments)
    if loadingState = = PlaceableLoadingState.OK then
        table.insert( self.loadedPlaceables, placeable)
    else
            self.placeableLoadingState = self.placeableLoadingState or loadingState
        end

        self.placeablesToLoad = self.placeablesToLoad - 1

        if self.asyncCallbackFunction ~ = nil then
            if self.placeablesToLoad < = 0 then
                g_asyncTaskManager:addTask( function ()
                    self.asyncCallbackFunction( self.asyncCallbackObject, self.loadedPlaceables, self.placeableLoadingState or PlaceableLoadingState.OK, self.asyncCallbackArguments)

                    self.asyncCallbackFunction = nil
                    self.asyncCallbackObject = nil
                    self.asyncCallbackArguments = nil

                    self.loadedPlaceables = nil
                    self.placeableLoadingState = nil
                end )
            end
        end
    end

```

### loadPlaceableFromXML

**Description**

**Definition**

> loadPlaceableFromXML()

**Arguments**

| any | xmlFile              |
|-----|----------------------|
| any | key                  |
| any | defaultItemsToSPFarm |
| any | preplacedData        |
| any | callback             |
| any | callbackTarget       |
| any | callbackArguments    |

**Code**

```lua
function PlaceableSystem:loadPlaceableFromXML(xmlFile, key, defaultItemsToSPFarm, preplacedData, callback, callbackTarget, callbackArguments)
    local missionInfo = g_currentMission.missionInfo
    local missionDynamicInfo = g_currentMission.missionDynamicInfo

    local defaultProperty = xmlFile:getValue(key .. "#defaultFarmProperty" , false )
    local farmId = xmlFile:getValue(key .. "#farmId" )

    local loadForCompetitive = defaultProperty and missionInfo.isCompetitiveMultiplayer and g_farmManager:getFarmById(farmId) ~ = nil
    local loadDefaultProperty = defaultProperty and(missionInfo.loadDefaultFarm and not missionDynamicInfo.isMultiplayer) and(farmId = = FarmManager.SINGLEPLAYER_FARM_ID or defaultItemsToSPFarm)
    local allowedToLoad = missionInfo.isValid or not defaultProperty or loadDefaultProperty or loadForCompetitive

    local filename
    if preplacedData ~ = nil then
        filename = preplacedData.xmlFilename
    else
            filename = xmlFile:getValue(key .. "#filename" )
        end

        if filename = = nil then
            if xmlFile:getValue(key .. "#isPreplaced" ) then
                Logging.xmlInfo(xmlFile, "Preplaced placeable node is not defined anmore in the map. '%s'" , key)
            else
                    Logging.xmlInfo(xmlFile, "Missing filename for placeable '%s'" , key)
                    end

                    return false
                end

                if allowedToLoad then
                    if string.startsWith(filename, "$data" ) then
                        filename = Utils.getFilename(filename)
                    end

                    filename = NetworkUtil.convertFromNetworkFilename(filename)

                    local storeItem = g_storeManager:getItemByXMLFilename(filename)
                    if storeItem ~ = nil then
                        local savegame = { xmlFile = xmlFile, key = key, ignoreFarmId = false }

                        if loadDefaultProperty and defaultItemsToSPFarm and farmId ~ = FarmManager.SINGLEPLAYER_FARM_ID then
                            farmId = FarmManager.SINGLEPLAYER_FARM_ID
                            savegame.ignoreFarmId = true
                        end

                        self.placeablesToLoad = self.placeablesToLoad + 1

                        local data = PlaceableLoadingData.new()
                        data:setStoreItem(storeItem)
                        data:setSavegameData(savegame)
                        if preplacedData ~ = nil then
                            data:setPreplacedIndex(preplacedData.index)
                        end

                        g_asyncTaskManager:addSubtask( function ()
                            data:load(callback, callbackTarget, callbackArguments)
                        end )

                        return true
                    else
                            Logging.xmlWarning(xmlFile, "Placeable '%s' not defined in store items" , filename)
                        end
                    else
                            -- Logging.xmlInfo(xmlFile, "Placeable '%s' is not allowed to be loaded", filename)
                        end

                        return false
                    end

```

### new

**Description**

**Definition**

> new(table mission, table? customMt)

**Arguments**

| table  | mission  |
|--------|----------|
| table? | customMt |

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function PlaceableSystem.new(mission, customMt)
    local self = setmetatable( { } , customMt or PlaceableSystem _mt)

    self.mission = mission
    self.placeables = { }
    self.placableByUniqueId = { }
    self.pendingPlaceableLoadingData = { } -- placeable loading data that is currently pending

    self.preplacedPlaceableData = { }
    self.uniqueIdToReplacedPlaceableData = { }
    self.placeablesToDelete = { }

    self.weatherStations = { }
    self.farmhouses = { }
    self.bunkerSilos = { }

    self.boundary = nil

    self.version = 1

    self.isReloadRunning = false

    if self.mission:getIsServer() then
        if g_addTestCommands then
            addConsoleCommand( "gsPlaceablesDeleteAll" , "Deletes all placeables" , "consoleCommandDeleteAllPlaceables" , self , nil , true )
            addConsoleCommand( "gsPlaceablesReloadAll" , "Reloads all placeables" , "consoleCommandReloadAllPlaceables" , self )
            addConsoleCommand( "gsPlaceablesLoadAll" , "Loads all placeables" , "consoleCommandLoadAllPlaceables" , self , nil , true )
        end
    end

    if g_addTestCommands then
        addConsoleCommand( "gsPlaceablesPendingLoadings" , "Prints the pending placeable loadings" , "consoleCommandPrintPendingLoadings" , self )
        addConsoleCommand( "gsPlaceableSystemDrawBoundary" , "Draws the placeable map boundaries" , "consoleCommandDrawMapBoundaries" , self )
    end

    return self
end

```

### removeBunkerSilo

**Description**

**Definition**

> removeBunkerSilo()

**Arguments**

| any | bunkerSilo |
|-----|------------|

**Code**

```lua
function PlaceableSystem:removeBunkerSilo(bunkerSilo)
    table.removeElement( self.bunkerSilos, bunkerSilo)
end

```

### removeFarmhouse

**Description**

**Definition**

> removeFarmhouse()

**Arguments**

| any | farmhouse |
|-----|-----------|

**Code**

```lua
function PlaceableSystem:removeFarmhouse(farmhouse)
    table.removeElement( self.farmhouses, farmhouse)
end

```

### removePendingPlaceableLoad

**Description**

**Definition**

> removePendingPlaceableLoad()

**Arguments**

| any | placeableLoadingData |
|-----|----------------------|

**Code**

```lua
function PlaceableSystem:removePendingPlaceableLoad(placeableLoadingData)
    table.removeElement( self.pendingPlaceableLoadingData, placeableLoadingData)
end

```

### removePlaceable

**Description**

**Definition**

> removePlaceable()

**Arguments**

| any | placeable |
|-----|-----------|

**Code**

```lua
function PlaceableSystem:removePlaceable(placeable)
    table.removeElement( self.placeables, placeable)

    local uniqueId = placeable:getUniqueId()
    if uniqueId ~ = nil then
        self.placableByUniqueId[uniqueId] = nil
    end
end

```

### removeWeatherStation

**Description**

**Definition**

> removeWeatherStation()

**Arguments**

| any | weatherStation |
|-----|----------------|

**Code**

```lua
function PlaceableSystem:removeWeatherStation(weatherStation)
    table.removeElement( self.weatherStations, weatherStation)
end

```

### save

**Description**

**Definition**

> save()

**Arguments**

| any | xmlFilename  |
|-----|--------------|
| any | usedModNames |

**Code**

```lua
function PlaceableSystem:save(xmlFilename, usedModNames)
    local xmlFile = XMLFile.create( "placeablesXML" , xmlFilename, "placeables" , Placeable.xmlSchemaSavegame)
    if xmlFile ~ = nil then
        self:saveToXML(xmlFile, usedModNames)
        xmlFile:save()
        xmlFile:delete()
    end
end

```

### saveToXML

**Description**

**Definition**

> saveToXML()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | usedModNames  |
| any | savePreplaced |

**Code**

```lua
function PlaceableSystem:saveToXML(xmlFile, usedModNames, savePreplaced)
    if xmlFile ~ = nil then
        xmlFile:setValue( "placeables#version" , self.version)

        savePreplaced = Utils.getNoNil(savePreplaced, true )
        local xmlIndex = 0

        if savePreplaced then
            -- save preplaced data first
            for _, data in ipairs( self.preplacedPlaceableData) do
                local placeableKey = string.format( "placeables.placeable(%d)" , xmlIndex)

                xmlFile:setValue(placeableKey .. "#isPreplaced" , true )
                xmlFile:setValue(placeableKey .. "#uniqueId" , data.uniqueId)
                if data.isDeleted then
                    xmlFile:setValue(placeableKey .. "#isDeleted" , true )
                end

                if data.placeable ~ = nil then
                    data.placeable:saveToXMLFile(xmlFile, placeableKey, usedModNames)
                end

                xmlIndex = xmlIndex + 1
            end
        end

        for i, placeable in ipairs( self.placeables) do
            if placeable:getNeedsSaving() and not placeable.isPreplaced then
                self:savePlaceableToXML(placeable, xmlFile, xmlIndex, i, usedModNames)

                xmlIndex = xmlIndex + 1
            end
        end
    end
end

```