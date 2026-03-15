## FarmlandManager

**Description**

> This class handles all basic functionality for land ownership

**Parent**

> [AbstractManager](?version=script&category=25&class=218)

**Functions**

- [consoleCommandBuyAllFarmlands](#consolecommandbuyallfarmlands)
- [consoleCommandBuyFarmland](#consolecommandbuyfarmland)
- [consoleCommandSellAllFarmlands](#consolecommandsellallfarmlands)
- [consoleCommandSellFarmland](#consolecommandsellfarmland)
- [consoleCommandShowFarmlands](#consolecommandshowfarmlands)
- [convertWorldToLocalPosition](#convertworldtolocalposition)
- [delete](#delete)
- [farmDestroyed](#farmdestroyed)
- [getCanAccessLandAtWorldPosition](#getcanaccesslandatworldposition)
- [getFarmlandAtWorldPosition](#getfarmlandatworldposition)
- [getFarmlandById](#getfarmlandbyid)
- [getFarmlandIdAtWorldPosition](#getfarmlandidatworldposition)
- [getFarmlandOwner](#getfarmlandowner)
- [getFarmlands](#getfarmlands)
- [getIsOwnedByFarmAlongLine](#getisownedbyfarmalongline)
- [getIsOwnedByFarmAtWorldPosition](#getisownedbyfarmatworldposition)
- [getIsValidFarmlandId](#getisvalidfarmlandid)
- [getLocalMap](#getlocalmap)
- [getNumOwnedFarmlandIdsByFarmId](#getnumownedfarmlandidsbyfarmid)
- [getOwnedFarmlandIdsByFarmId](#getownedfarmlandidsbyfarmid)
- [getOwnerIdAtWorldPosition](#getowneridatworldposition)
- [getPricePerHa](#getpriceperha)
- [initDataStructures](#initdatastructures)
- [loadFarmlandData](#loadfarmlanddata)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadMapData](#loadmapdata)
- [new](#new)
- [saveToXMLFile](#savetoxmlfile)
- [setLandOwnership](#setlandownership)
- [unloadMapData](#unloadmapdata)

### consoleCommandBuyAllFarmlands

**Description**

**Definition**

> consoleCommandBuyAllFarmlands()

**Code**

```lua
function FarmlandManager:consoleCommandBuyAllFarmlands()
    if (g_currentMission:getIsServer() or g_currentMission.isMasterUser) and g_currentMission:getIsClient() then
        local farmId = g_localPlayer.farmId

        for k, _ in pairs(g_farmlandManager:getFarmlands()) do
            g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(k, farmId, 0 ))
        end
        return "Bought all farmlands"
    else
            return "Command not allowed"
        end
    end

```

### consoleCommandBuyFarmland

**Description**

**Definition**

> consoleCommandBuyFarmland()

**Arguments**

| any | farmlandIdStr |
|-----|---------------|

**Code**

```lua
function FarmlandManager:consoleCommandBuyFarmland(farmlandIdStr)
    if (g_currentMission:getIsServer() or g_currentMission.isMasterUser) and g_currentMission:getIsClient() then
        local farmlandId
        if farmlandIdStr ~ = nil then
            -- farmland given as argument
            farmlandId = tonumber(farmlandIdStr)
            if farmlandId = = nil or self:getFarmlandById(farmlandId) = = nil then
                printError( string.format( "Error:Invalid farmland id %q." , farmlandIdStr))
                return "Use gsFarmlandBuy <farmlandId>"
            end
        else
                -- use current player pos farmland
                local x, _, z = g_localPlayer:getPosition()
                farmlandId = self:getFarmlandIdAtWorldPosition(x,z)

                if farmlandId = = nil then
                    printError( "Error:Unable to retrieve farmland id at player position, provide farmland as argument instead" )
                    return
                end
            end

            local farmId = g_localPlayer.farmId

            if self:getFarmlandOwner(farmlandId) = = farmId then
                printError( string.format( "Error:Farmland %d already owned by farm %d" , farmlandId, farmId))
                return
            end

            -- send buy request
            g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(farmlandId, farmId, 0 ))

            return "Bought farmland " .. farmlandId
        else
                return "Command not allowed"
            end
        end

```

### consoleCommandSellAllFarmlands

**Description**

**Definition**

> consoleCommandSellAllFarmlands()

**Code**

```lua
function FarmlandManager:consoleCommandSellAllFarmlands()
    if (g_currentMission:getIsServer() or g_currentMission.isMasterUser) and g_currentMission:getIsClient() then
        for k, _ in pairs(g_farmlandManager:getFarmlands()) do
            g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(k, FarmlandManager.NO_OWNER_FARM_ID, 0 ))
        end
        return "Sold all farmlands"
    else
            return "Command not allowed"
        end
    end

```

### consoleCommandSellFarmland

**Description**

**Definition**

> consoleCommandSellFarmland()

**Arguments**

| any | farmlandIdStr |
|-----|---------------|

**Code**

```lua
function FarmlandManager:consoleCommandSellFarmland(farmlandIdStr)
    if (g_currentMission:getIsServer() or g_currentMission.isMasterUser) and g_currentMission:getIsClient() then
        local farmlandId
        if farmlandIdStr ~ = nil then
            -- farmland given as argument
            farmlandId = tonumber(farmlandIdStr)
            if farmlandId = = nil or self:getFarmlandById(farmlandId) = = nil then
                printError( string.format( "Error:Invalid farmland id %q" , farmlandIdStr))
                return "Use gsFarmlandSell <farmlandId>"
            end
        else
                -- use current player pos farmland
                local x, _, z = g_localPlayer:getPosition()
                farmlandId = self:getFarmlandIdAtWorldPosition(x,z)

                if farmlandId = = nil then
                    printError( "Error:Unable to retrieve farmland id at player position, provide farmland as argument instead" )
                    return
                end
            end

            if self:getFarmlandOwner(farmlandId) = = FarmlandManager.NO_OWNER_FARM_ID then
                printError( string.format( "Error:Farmland %d not owned by anyone" , farmlandId))
                return
            end

            -- send sell request
            g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(farmlandId, FarmlandManager.NO_OWNER_FARM_ID, 0 ))

            return "Sold farmland " .. farmlandId
        else
                return "Command not allowed"
            end
        end

```

### consoleCommandShowFarmlands

**Description**

**Definition**

> consoleCommandShowFarmlands()

**Code**

```lua
function FarmlandManager:consoleCommandShowFarmlands()
    if not g_debugManager:hasDrawable( self ) then
        g_debugManager:addDrawable( self )
        return "showFarmlands = true\nUse F5 to enter debug mode for enabling overlay"
        else
                g_debugManager:removeDrawable( self )
                self.debugFarmlandColors = nil
                return "showFarmlands = false"
            end
        end

```

### convertWorldToLocalPosition

**Description**

> Converts world to local position

**Definition**

> convertWorldToLocalPosition(float worldPosX, float worldPosZ)

**Arguments**

| float | worldPosX | world position x |
|-------|-----------|------------------|
| float | worldPosZ | world position z |

**Return Values**

| float | localPosX | local position x |
|-------|-----------|------------------|
| float | localPosZ | local position z |

**Code**

```lua
function FarmlandManager:convertWorldToLocalPosition(worldPosX, worldPosZ)
    local terrainSize = g_currentMission.terrainSize
    return math.floor( self.localMapWidth * (worldPosX + terrainSize * 0.5 ) / terrainSize),
    math.floor( self.localMapHeight * (worldPosZ + terrainSize * 0.5 ) / terrainSize)
end

```

### delete

**Description**

> Deletes farm land manager

**Definition**

> delete()

**Code**

```lua
function FarmlandManager:delete()
end

```

### farmDestroyed

**Description**

**Definition**

> farmDestroyed()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function FarmlandManager:farmDestroyed(farmId)
    for _, farmland in pairs( self:getFarmlands()) do
        if self:getFarmlandOwner(farmland.id) = = farmId then
            self:setLandOwnership(farmland.id, FarmlandManager.NO_OWNER_FARM_ID)
        end
    end
end

```

### getCanAccessLandAtWorldPosition

**Description**

> Checks if farm can access the given world position

**Definition**

> getCanAccessLandAtWorldPosition(integer farmId, float worldPosX, float worldPosZ)

**Arguments**

| integer | farmId    | farm id          |
|---------|-----------|------------------|
| float   | worldPosX | world position x |
| float   | worldPosZ | world position z |

**Return Values**

| float | canAccess | true if farm can access the land |
|-------|-----------|----------------------------------|

**Code**

```lua
function FarmlandManager:getCanAccessLandAtWorldPosition(farmId, worldPosX, worldPosZ)
    if farmId = = FarmlandManager.NO_OWNER_FARM_ID or farmId = = nil then
        return false
    end

    local farmlandId = self:getFarmlandIdAtWorldPosition(worldPosX, worldPosZ)
    local ownerFarmId = self.farmlandMapping[farmlandId]
    if ownerFarmId = = farmId then
        return true
    end

    return g_currentMission.accessHandler:canFarmAccessOtherId(farmId, ownerFarmId)
end

```

### getFarmlandAtWorldPosition

**Description**

**Definition**

> getFarmlandAtWorldPosition()

**Arguments**

| any | worldPosX |
|-----|-----------|
| any | worldPosZ |

**Code**

```lua
function FarmlandManager:getFarmlandAtWorldPosition(worldPosX, worldPosZ)
    local farmlandId = self:getFarmlandIdAtWorldPosition(worldPosX, worldPosZ)
    return self.farmlands[farmlandId]
end

```

### getFarmlandById

**Description**

> Gets farmland by id

**Definition**

> getFarmlandById(integer farmlandId)

**Arguments**

| integer | farmlandId | farmland id |
|---------|------------|-------------|

**Return Values**

| integer | farmland | farmland object |
|---------|----------|-----------------|

**Code**

```lua
function FarmlandManager:getFarmlandById(farmlandId)
    return self.farmlands[farmlandId]
end

```

### getFarmlandIdAtWorldPosition

**Description**

> Gets farmland id at given world position

**Definition**

> getFarmlandIdAtWorldPosition(float worldPosX, float worldPosZ)

**Arguments**

| float | worldPosX | world position x |
|-------|-----------|------------------|
| float | worldPosZ | world position z |

**Return Values**

| float | farmlandId | farmland id. if 0, world position is no valid/buyable farmland |
|-------|------------|----------------------------------------------------------------|

**Code**

```lua
function FarmlandManager:getFarmlandIdAtWorldPosition(worldPosX, worldPosZ)
    if self.localMap = = nil then
        return FarmlandManager.NO_OWNER_FARM_ID
    end

    local localPosX, localPosZ = self:convertWorldToLocalPosition(worldPosX, worldPosZ)
    return getBitVectorMapPoint( self.localMap, localPosX, localPosZ, 0 , self.numberOfBits)
end

```

### getFarmlandOwner

**Description**

> Gets farmland owner

**Definition**

> getFarmlandOwner(integer farmlandId)

**Arguments**

| integer | farmlandId | farmland id |
|---------|------------|-------------|

**Return Values**

| integer | farmId | id of farm. Returns 0 if land is not owned by anyone |
|---------|--------|------------------------------------------------------|

**Code**

```lua
function FarmlandManager:getFarmlandOwner(farmlandId)
    --#debug Assert.isInteger(farmlandId) -- ensure farmland id and not farmland itself it given
    if farmlandId = = nil or self.farmlandMapping[farmlandId] = = nil then
        return FarmlandManager.NO_OWNER_FARM_ID
    end

    return self.farmlandMapping[farmlandId]
end

```

### getFarmlands

**Description**

> Gets all farmlands

**Definition**

> getFarmlands()

**Return Values**

| integer | farmlands | all available farmlands |
|---------|-----------|-------------------------|

**Code**

```lua
function FarmlandManager:getFarmlands()
    return self.farmlands
end

```

### getIsOwnedByFarmAlongLine

**Description**

> Checks if farm owns all farmlands along a line

**Definition**

> getIsOwnedByFarmAlongLine(integer farmId, float worldPosX1, float worldPosZ1, float worldPosX2, float worldPosZ2)

**Arguments**

| integer | farmId     | farm id                     |
|---------|------------|-----------------------------|
| float   | worldPosX1 | line start world position x |
| float   | worldPosZ1 | line start world position z |
| float   | worldPosX2 | line end world position x   |
| float   | worldPosZ2 | line end world position z   |

**Return Values**

| float | isOwned | true if farm owns all farmlands long the line |
|-------|---------|-----------------------------------------------|

**Code**

```lua
function FarmlandManager:getIsOwnedByFarmAlongLine(farmId, worldPosX1, worldPosZ1, worldPosX2, worldPosZ2)
    if farmId = = FarmlandManager.NO_OWNER_FARM_ID or farmId = = nil then
        return false
    end

    if self.localMap = = nil then
        return false
    end

    local length = MathUtil.vector2Length(worldPosX1 - worldPosX2, worldPosZ1 - worldPosZ2)

    if length = = 0 then
        return self:getIsOwnedByFarmAtWorldPosition(farmId, worldPosX1, worldPosZ1)
    end

    local bitmapToWorld = g_currentMission.terrainSize / self.localMapWidth
    local step = (bitmapToWorld / length) * 2 -- reduce number of probes as single pixels are unlikely anyways

    -- local debugPoint = DebugPoint.new()

    -- TODO:Optimization:do not step linearly but rather like a binary search to minimize number of probes
        for alpha = 0 , 1 , step do
            local x, z = MathUtil.vector2Lerp(worldPosX1, worldPosZ1, worldPosX2, worldPosZ2, alpha)
            local localPosX, localPosZ = self:convertWorldToLocalPosition(x, z)
            local farmlandId = getBitVectorMapPoint( self.localMap, localPosX, localPosZ, 0 , self.numberOfBits)
            if self.farmlandMapping[farmlandId] ~ = farmId then
                -- debugPoint:createWithWorldPos(x, 0, z, true):setColor(Color.PRESETS.RED):draw()
                return false
            end
            -- debugPoint:createWithWorldPos(x, 0, z, true):setColor(Color.PRESETS.GREEN):draw()
        end

        return true
    end

```

### getIsOwnedByFarmAtWorldPosition

**Description**

> Checks if farm owns given world position

**Definition**

> getIsOwnedByFarmAtWorldPosition(integer farmId, float worldPosX, float worldPosZ)

**Arguments**

| integer | farmId    | farm id          |
|---------|-----------|------------------|
| float   | worldPosX | world position x |
| float   | worldPosZ | world position z |

**Return Values**

| float | isOwned | true if farm owns world position point, else false |
|-------|---------|----------------------------------------------------|

**Code**

```lua
function FarmlandManager:getIsOwnedByFarmAtWorldPosition(farmId, worldPosX, worldPosZ)
    if farmId = = FarmlandManager.NO_OWNER_FARM_ID or farmId = = nil then
        return false
    end
    local farmlandId = self:getFarmlandIdAtWorldPosition(worldPosX, worldPosZ)
    return self.farmlandMapping[farmlandId] = = farmId
end

```

### getIsValidFarmlandId

**Description**

> Checks if given farmland-id is valid

**Definition**

> getIsValidFarmlandId(integer farmlandId)

**Arguments**

| integer | farmlandId | farmland id |
|---------|------------|-------------|

**Return Values**

| integer | isValid | true if id is valid, else false |
|---------|---------|---------------------------------|

**Code**

```lua
function FarmlandManager:getIsValidFarmlandId(farmlandId)
    if farmlandId = = nil or farmlandId = = 0 or farmlandId < 0 then
        return false
    end
    if self:getFarmlandById(farmlandId) = = nil then
        return false
    end
    return true
end

```

### getLocalMap

**Description**

> Gets farmland bit vector handle

**Definition**

> getLocalMap()

**Return Values**

| integer | mapHandle | id of bitvector |
|---------|-----------|-----------------|

**Code**

```lua
function FarmlandManager:getLocalMap()
    return self.localMap
end

```

### getNumOwnedFarmlandIdsByFarmId

**Description**

> Gets number of owned farmland ids for given farm

**Definition**

> getNumOwnedFarmlandIdsByFarmId(integer id)

**Arguments**

| integer | id | farm id |
|---------|----|---------|

**Return Values**

| integer | numFarmlands | integer number of farmlands |
|---------|--------------|-----------------------------|

**Code**

```lua
function FarmlandManager:getNumOwnedFarmlandIdsByFarmId(id)
    local num = 0
    for farmlandId, farmId in pairs( self.farmlandMapping) do
        if farmId = = id then
            num = num + 1
        end
    end
    return num
end

```

### getOwnedFarmlandIdsByFarmId

**Description**

> Gets list of owned farmland ids for given farm

**Definition**

> getOwnedFarmlandIdsByFarmId(integer id)

**Arguments**

| integer | id | farm id |
|---------|----|---------|

**Return Values**

| integer | farmlandIds | table list of farmland ids owned by given farm id |
|---------|-------------|---------------------------------------------------|

**Code**

```lua
function FarmlandManager:getOwnedFarmlandIdsByFarmId(id)
    local farmlandIds = { }
    for farmlandId, farmId in pairs( self.farmlandMapping) do
        if farmId = = id then
            table.insert(farmlandIds, farmlandId)
        end
    end
    return farmlandIds
end

```

### getOwnerIdAtWorldPosition

**Description**

**Definition**

> getOwnerIdAtWorldPosition()

**Arguments**

| any | worldPosX |
|-----|-----------|
| any | worldPosZ |

**Code**

```lua
function FarmlandManager:getOwnerIdAtWorldPosition(worldPosX, worldPosZ)
    local farmlandId = self:getFarmlandIdAtWorldPosition(worldPosX, worldPosZ)
    return self:getFarmlandOwner(farmlandId)
end

```

### getPricePerHa

**Description**

**Definition**

> getPricePerHa()

**Code**

```lua
function FarmlandManager:getPricePerHa()
    return self.pricePerHa
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function FarmlandManager:initDataStructures()
    self.farmlands = { }
    self.sortedFarmlands = { }
    self.sortedFarmlandIds = { }
    -- mapping table farmland id to farm id
    self.farmlandMapping = { }
    self.localMap = nil
    self.localMapWidth = 0
    self.localMapHeight = 0
    self.numberOfBits = 8
end

```

### loadFarmlandData

**Description**

> Load data on map load

**Definition**

> loadFarmlandData()

**Arguments**

| any | xmlFileHandle |
|-----|---------------|

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function FarmlandManager:loadFarmlandData(xmlFileHandle)
    local xmlFile = XMLFile.wrap(xmlFileHandle, FarmlandManager.xmlSchema)

    self.isLoadedFromTerrain = true

    local infoLayer
    local infoLayerName = xmlFile:getValue( "map.farmlands#infoLayer" )
    if infoLayerName ~ = nil then
        infoLayer = getInfoLayerFromTerrain(g_terrainNode, infoLayerName)
        if infoLayer = = nil or infoLayer = = 0 then
            Logging.xmlWarning(xmlFile, "No info layer '%s' defined on terrain!" , infoLayerName)
        end
    end

    local bitVectorMapFilename
    if infoLayer = = nil then
        bitVectorMapFilename = xmlFile:getValue( "map.farmlands#densityMapFilename" )
        if bitVectorMapFilename = = nil then
            Logging.xmlWarning(xmlFile, "Loading farmland file '%s' failed! Missing densityMapFilename" , bitVectorMapFilename)
            return false
        end

        bitVectorMapFilename = Utils.getFilename(bitVectorMapFilename, g_currentMission.baseDirectory)
        local numberOfBits = xmlFile:getValue( "map.farmlands#numChannels" ) or 8

        infoLayer = createBitVectorMap( "FarmlandMap" )
        local success = loadBitVectorMapFromFile(infoLayer, bitVectorMapFilename, numberOfBits)
        if not success then
            Logging.xmlWarning(xmlFile, "Loading farmland file '%s' failed!" , bitVectorMapFilename)
            xmlFile:delete()
            return false
        end

        self.isLoadedFromTerrain = false
    end

    self.pricePerHa = xmlFile:getValue( "map.farmlands#pricePerHa" ) or 60000

    FarmlandManager.NOT_BUYABLE_FARM_ID = 2 ^ self.numberOfBits - 1

    -- load a bitvector
    self.localMap = infoLayer
    self.numberOfBits = getBitVectorMapNumChannels( self.localMap)
    self.localMapWidth, self.localMapHeight = getBitVectorMapSize( self.localMap)

    local farmlandSizeMapping = { }
    local farmlandCenterData = { }
    local numOfFarmlands = 0
    local maxFarmlandId = 0
    local missingFarmlandDefinitions = false

    for x = 0 , self.localMapWidth - 1 do
        for y = 0 , self.localMapHeight - 1 do
            local value = getBitVectorMapPoint( self.localMap, x, y, 0 , self.numberOfBits)

            if value > 0 then
                if self.farmlandMapping[value] = = nil then
                    farmlandSizeMapping[value] = 0
                    farmlandCenterData[value] = { sumPosX = 0 , sumPosZ = 0 }
                    self.farmlandMapping[value] = FarmlandManager.NO_OWNER_FARM_ID
                    numOfFarmlands = numOfFarmlands + 1
                    maxFarmlandId = math.max(value, maxFarmlandId)
                end

                farmlandSizeMapping[value] = farmlandSizeMapping[value] + 1
                farmlandCenterData[value].sumPosX = farmlandCenterData[value].sumPosX + (x - 0.5 )
                farmlandCenterData[value].sumPosZ = farmlandCenterData[value].sumPosZ + (y - 0.5 )
            else
                    missingFarmlandDefinitions = true
                end
            end
        end

        if missingFarmlandDefinitions then
            Logging.xmlWarning(xmlFile, "Farmland-Id was not set for all pixels in farmland-infoLayer!" )
            end

            local isNewSavegame = not g_currentMission.missionInfo.isValid

            for _, key in xmlFile:iterator( "map.farmlands.farmland" ) do
                local farmland = Farmland.new()
                if farmland:load(xmlFile, key) and self.farmlands[farmland.id] = = nil and self.farmlandMapping[farmland.id] ~ = nil then
                    self.farmlands[farmland.id] = farmland
                    table.insert( self.sortedFarmlands, farmland)
                    table.insert( self.sortedFarmlandIds, farmland.id)

                    -- If default should be owned .. .
                    local shouldAddDefaults = isNewSavegame and g_currentMission.missionInfo.hasInitiallyOwnedFarmlands and not g_currentMission.missionDynamicInfo.isMultiplayer
                    -- .. .then set only default farmlands to owned
                    if shouldAddDefaults and g_currentMission:getIsServer() and farmland.defaultFarmProperty then
                        self:setLandOwnership(farmland.id, FarmManager.SINGLEPLAYER_FARM_ID, true )
                    end
                else
                        if self.farmlandMapping[farmland.id] = = nil then
                            Logging.xmlError(xmlFile, "Farmland-Id '%s' not defined in farmland info layer.Skipping farmland definition!" , farmland.id)
                        end
                        if self.farmlands[farmland.id] ~ = nil then
                            Logging.xmlError(xmlFile, "Farmland-id '%s' already exists! Ignore it!" , farmland.id)
                        end
                        farmland:delete()
                    end
                end

                for index, _ in pairs( self.farmlandMapping) do
                    if index ~ = FarmlandManager.NOT_BUYABLE_FARM_ID and self.farmlands[index] = = nil then
                        Logging.xmlError(xmlFile, "Farmland-Id '%d' not defined in farmland xml file!" , index)
                    end
                end

                local transformFactor = g_currentMission.terrainSize / self.localMapWidth
                local pixelToSqm = transformFactor * transformFactor

                for id, farmland in pairs( self.farmlands) do
                    local ha = MathUtil.areaToHa(farmlandSizeMapping[id], pixelToSqm)
                    farmland:setArea(ha)
                    farmland:addMapHotspot()

                    if farmland.xWorldPos = = nil then
                        local posX = ((farmlandCenterData[id].sumPosX / farmlandSizeMapping[id]) - self.localMapWidth * 0.5 ) * transformFactor
                        local posZ = ((farmlandCenterData[id].sumPosZ / farmlandSizeMapping[id]) - self.localMapHeight * 0.5 ) * transformFactor
                        farmland:setIndicatorPosition(posX, posZ)
                    end
                end

                g_messageCenter:subscribe(MessageType.FARM_DELETED, self.farmDestroyed, self )
                g_messageCenter:subscribe(MessageType.FARM_SETTINGS_CHANGED, self.onFarmSettingsChanged, self )

                if g_addCheatCommands then
                    if g_currentMission:getIsServer() then
                        -- master user only cheats(will be added in setMasterUserLocal too)
                        addConsoleCommand( "gsFarmlandBuy" , "Buys farmland with given id" , "consoleCommandBuyFarmland" , self )
                        addConsoleCommand( "gsFarmlandBuyAll" , "Buys all farmlands" , "consoleCommandBuyAllFarmlands" , self )
                        addConsoleCommand( "gsFarmlandSell" , "Sells farmland with given id" , "consoleCommandSellFarmland" , self )
                        addConsoleCommand( "gsFarmlandSellAll" , "Sells all farmlands" , "consoleCommandSellAllFarmlands" , self )
                    end

                    addConsoleCommand( "gsFarmlandShow" , "Show farmlands" , "consoleCommandShowFarmlands" , self )
                end

                xmlFile:delete()

                return true
            end

```

### loadFromXMLFile

**Description**

> Load farmland ownership data from xml savegame file

**Definition**

> loadFromXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | xml filename |
|--------|-------------|--------------|

**Code**

```lua
function FarmlandManager:loadFromXMLFile(xmlFilename)
    if xmlFilename = = nil then
        return false
    end

    local xmlFile = loadXMLFile( "farmlandXML" , xmlFilename)
    if xmlFile = = 0 then
        return false
    end

    local farmlandCounter = 0
    while true do
        local key = string.format( "farmlands.farmland(%d)" , farmlandCounter)
        local farmlandId = getXMLInt(xmlFile, key .. "#id" )
        if farmlandId = = nil then
            break
        end
        local farmId = getXMLInt(xmlFile, key .. "#farmId" )
        if farmId > FarmlandManager.NO_OWNER_FARM_ID then
            self:setLandOwnership(farmlandId, farmId, true )
        end

        farmlandCounter = farmlandCounter + 1
    end

    delete(xmlFile)

    g_farmManager:mergeFarmlandsForSingleplayer()

    return true
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile |
|-----|---------|

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function FarmlandManager:loadMapData(xmlFile)
    FarmlandManager:superClass().loadMapData( self )
    return XMLUtil.loadDataFromMapXML(xmlFile, "farmlands" , g_currentMission.baseDirectory, self , self.loadFarmlandData)
end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function FarmlandManager.new(customMt)
    local self = AbstractManager.new(customMt or FarmlandManager _mt)
    return self
end

```

### saveToXMLFile

**Description**

> Write farmland ownership data to savegame file

**Definition**

> saveToXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | file path |
|--------|-------------|-----------|

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function FarmlandManager:saveToXMLFile(xmlFilename)
    -- save farmland to xml
    local xmlFile = createXMLFile( "farmlandsXML" , xmlFilename, "farmlands" )
    if xmlFile = = 0 then
        Logging.error( "Failed to create farmlands xml file" )
        return false
    end

    local index = 0
    for farmlandId, farmId in pairs( self.farmlandMapping) do
        local farmlandKey = string.format( "farmlands.farmland(%d)" , index)
        setXMLInt(xmlFile, farmlandKey .. "#id" , farmlandId)
        setXMLInt(xmlFile, farmlandKey .. "#farmId" , Utils.getNoNil(farmId, FarmlandManager.NO_OWNER_FARM_ID))
        index = index + 1
    end

    saveXMLFile(xmlFile)
    delete(xmlFile)

    return true
end

```

### setLandOwnership

**Description**

> Sets farm land ownership

**Definition**

> setLandOwnership(integer farmlandId, integer farmId, )

**Arguments**

| integer | farmlandId       | farm land id                               |
|---------|------------------|--------------------------------------------|
| integer | farmId           | farm id. set farmid to 0 to sell farm land |
| any     | loadFromSavegame |                                            |

**Code**

```lua
function FarmlandManager:setLandOwnership(farmlandId, farmId, loadFromSavegame)
    if not self:getIsValidFarmlandId(farmlandId) then
        return false
    end
    if farmId = = nil or farmId < FarmlandManager.NO_OWNER_FARM_ID or farmId = = FarmlandManager.NOT_BUYABLE_FARM_ID then
        return false
    end

    local farmland = self:getFarmlandById(farmlandId)
    if farmland = = nil then
        Logging.warning( "Farmland id %d not defined in map!" , farmlandId)
        return false
    end

    if loadFromSavegame = = nil then
        loadFromSavegame = false
    end

    self.farmlandMapping[farmlandId] = farmId
    farmland:setOwnerFarmId(farmId)

    g_messageCenter:publish(MessageType.FARMLAND_OWNER_CHANGED, farmlandId, farmId, loadFromSavegame)

    return true
end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function FarmlandManager:unloadMapData()
    removeConsoleCommand( "gsFarmlandBuy" )
    removeConsoleCommand( "gsFarmlandBuyAll" )
    removeConsoleCommand( "gsFarmlandSell" )
    removeConsoleCommand( "gsFarmlandSellAll" )
    removeConsoleCommand( "gsFarmlandShow" )

    g_messageCenter:unsubscribeAll( self )

    if self.localMap ~ = nil then
        if not self.isLoadedFromTerrain then
            delete( self.localMap)
        end
        self.localMap = nil
    end
    if ( self.farmlands ~ = nil ) then
        for _, farmland in pairs( self.farmlands) do
            farmland:delete()
        end
    end

    FarmlandManager:superClass().unloadMapData( self )
end

```