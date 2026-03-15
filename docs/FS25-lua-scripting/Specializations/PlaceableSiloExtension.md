## PlaceableSiloExtension

**Description**

> Specialization for placeables

**Functions**

- [canBeSold](#canbesold)
- [getCanBePlacedAt](#getcanbeplacedat)
- [getSpecValueVolume](#getspecvaluevolume)
- [initSpecialization](#initspecialization)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadSpecValueVolume](#loadspecvaluevolume)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onSell](#onsell)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)

### canBeSold

**Description**

**Definition**

> canBeSold()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableSiloExtension:canBeSold(superFunc)
    local spec = self.spec_siloExtension

    if spec.storage = = nil then
        return true , nil
    end

    local warning = g_i18n:getText( "info_siloExtensionNotEmpty" ) .. "\n"
    local totalFillLevel = 0

    spec.totalFillTypeSellPrice = 0

    for fillTypeIndex, fillLevel in pairs(spec.storage.fillLevels) do
        totalFillLevel = totalFillLevel + fillLevel
        if fillLevel > 0 then
            local lowestSellPrice = math.huge

            for _, unloadingStation in pairs(g_currentMission.storageSystem:getUnloadingStations()) do
                if unloadingStation.owningPlaceable ~ = nil
                    and unloadingStation.isSellingPoint
                    and unloadingStation.acceptedFillTypes[fillTypeIndex] then
                    local price = unloadingStation:getEffectiveFillTypePrice(fillTypeIndex)

                    if price > 0 then
                        lowestSellPrice = math.min(lowestSellPrice, price)
                    end
                end
            end

            if lowestSellPrice = = math.huge then
                lowestSellPrice = 0.5
            end

            local price = fillLevel * lowestSellPrice * PlaceableSiloExtension.PRICE_SELL_FACTOR
            local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
            warning = string.format( "%s%s(%d %s) - %s: %s\n" , warning, fillType.title, g_i18n:getFluid(fillLevel), g_i18n:getText( "unit_literShort" ), g_i18n:getText( "ui_sellValue" ), g_i18n:formatMoney(price, 0 , true , true ))
            spec.totalFillTypeSellPrice = spec.totalFillTypeSellPrice + price
        end
    end

    if totalFillLevel > 0 then
        return true , warning
    end

    return true , nil
end

```

### getCanBePlacedAt

**Description**

**Definition**

> getCanBePlacedAt()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |
| any | farmId    |

**Code**

```lua
function PlaceableSiloExtension:getCanBePlacedAt(superFunc, x, y, z, farmId)
    local canBePlaced, errorMessage = superFunc( self , x, y, z, farmId)
    if not canBePlaced then
        return false , errorMessage
    end

    local spec = self.spec_siloExtension
    if spec.storage = = nil then
        return false
    end

    spec.lastFoundUnloadingStations = nil
    spec.lastFoundLoadingStations = nil

    local storageSystem = g_currentMission.storageSystem
    -- we also need to check farmId
    spec.lastFoundUnloadingStations = storageSystem:getExtendableUnloadingStationsInRange(spec.storage, farmId, x, y, z)
    spec.lastFoundLoadingStations = storageSystem:getExtendableLoadingStationsInRange(spec.storage, farmId, x, y, z)
    if #spec.lastFoundUnloadingStations = = 0 and #spec.lastFoundLoadingStations = = 0 then
        return false , spec.nearSiloWarning
    end

    return true
end

```

### getSpecValueVolume

**Description**

**Definition**

> getSpecValueVolume()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function PlaceableSiloExtension.getSpecValueVolume(storeItem, realItem)
    if storeItem.specs.siloExtensionVolume = = nil then
        return nil
    end

    return g_i18n:formatVolume(storeItem.specs.siloExtensionVolume)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableSiloExtension.initSpecialization()
    g_storeManager:addSpecType( "siloExtensionVolume" , "shopListAttributeIconCapacity" , PlaceableSiloExtension.loadSpecValueVolume, PlaceableSiloExtension.getSpecValueVolume, StoreSpecies.PLACEABLE)
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableSiloExtension:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_siloExtension

    if spec.storage ~ = nil then
        spec.storage:loadFromXMLFile(xmlFile, key)
    end
end

```

### loadSpecValueVolume

**Description**

**Definition**

> loadSpecValueVolume()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function PlaceableSiloExtension.loadSpecValueVolume(xmlFile, customEnvironment, baseDir)
    return xmlFile:getValue( "placeable.siloExtension.storage#capacity" )
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableSiloExtension:onDelete()
    local spec = self.spec_siloExtension

    if spec.storage ~ = nil then
        local storageSystem = g_currentMission.storageSystem
        if storageSystem:hasStorage(spec.storage) then
            -- just remove storage from all registered unloading and loading stations
            storageSystem:removeStorageFromUnloadingStations(spec.storage, spec.storage.unloadingStations)
            storageSystem:removeStorageFromLoadingStations(spec.storage, spec.storage.loadingStations)

            storageSystem:removeStorage(spec.storage)
        end

        spec.storage:delete()
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableSiloExtension:onFinalizePlacement()
    local spec = self.spec_siloExtension
    if spec.storage ~ = nil then
        local storageSystem = g_currentMission.storageSystem
        local ownerFarmId = self:getOwnerFarmId()
        local lastFoundUnloadingStations = storageSystem:getExtendableUnloadingStationsInRange(spec.storage, ownerFarmId)
        local lastFoundLoadingStations = storageSystem:getExtendableLoadingStationsInRange(spec.storage, ownerFarmId)

        spec.storage:setOwnerFarmId( self:getOwnerFarmId(), true )
        storageSystem:addStorage(spec.storage)
        spec.storage:register( true )

        storageSystem:addStorageToUnloadingStations(spec.storage, lastFoundUnloadingStations)
        storageSystem:addStorageToLoadingStations(spec.storage, lastFoundLoadingStations)
    end
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function PlaceableSiloExtension:onLoad(savegame)
    local spec = self.spec_siloExtension
    local xmlFile = self.xmlFile

    local storageKey = "placeable.siloExtension.storage"
    spec.foreignSilo = xmlFile:getValue(storageKey .. "#foreignSilo" , false ) -- Shows as foreign silo in the menu

    if xmlFile:hasProperty(storageKey) then
        spec.storage = Storage.new( self.isServer, self.isClient)
        spec.storage:load( self.components, xmlFile, storageKey, self.i3dMappings, self.baseDirectory)
        spec.storage.foreignSilo = spec.foreignSilo
    else
            Logging.xmlWarning(xmlFile, "Missing 'storage' for siloExtension!" )
            end

            spec.nearSiloWarning = xmlFile:getValue( "placeable.siloExtension#nearSiloWarning" , "warning_siloExtensionNotNearSilo" , self.customEnvironment)
        end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableSiloExtension:onReadStream(streamId, connection)
    local spec = self.spec_siloExtension

    if spec.storage ~ = nil then
        local storageId = NetworkUtil.readNodeObjectId(streamId)
        spec.storage:readStream(streamId, connection)
        g_client:finishRegisterObject(spec.storage, storageId)
    end
end

```

### onSell

**Description**

**Definition**

> onSell()

**Code**

```lua
function PlaceableSiloExtension:onSell()
    local spec = self.spec_siloExtension

    if self.isServer then
        if spec.totalFillTypeSellPrice > 0 then
            g_currentMission:addMoney(spec.totalFillTypeSellPrice, self:getOwnerFarmId(), MoneyType.HARVEST_INCOME, true , true )
        end
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableSiloExtension:onWriteStream(streamId, connection)
    local spec = self.spec_siloExtension

    if spec.storage ~ = nil then
        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.storage))
        spec.storage:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, spec.storage)
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function PlaceableSiloExtension.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableSiloExtension.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableSiloExtension )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableSiloExtension )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableSiloExtension )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableSiloExtension )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableSiloExtension )
    SpecializationUtil.registerEventListener(placeableType, "onSell" , PlaceableSiloExtension )
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableSiloExtension.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableSiloExtension.setOwnerFarmId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getCanBePlacedAt" , PlaceableSiloExtension.getCanBePlacedAt)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "canBeSold" , PlaceableSiloExtension.canBeSold)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableSiloExtension.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "SiloExtension" )
    Storage.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType()
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableSiloExtension.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "SiloExtension" )
    schema:register(XMLValueType.BOOL, basePath .. ".siloExtension.storage#foreignSilo" , "Shows as foreign silo in the menu" , false )
    schema:register(XMLValueType.L10N_STRING, basePath .. ".siloExtension#nearSiloWarning" , "Warning that is shown if extension is not placed near another silo" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".siloExtension.storage#node" , "Storage node" )
        Storage.registerXMLPaths(schema, basePath .. ".siloExtension.storage" )
        schema:setXMLSpecializationType()
    end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function PlaceableSiloExtension:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_siloExtension
    if spec.storage ~ = nil then
        spec.storage:saveToXMLFile(xmlFile, key, usedModNames)
    end
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | farmId      |
| any | noEventSend |

**Code**

```lua
function PlaceableSiloExtension:setOwnerFarmId(superFunc, farmId, noEventSend)
    local spec = self.spec_siloExtension

    superFunc( self , farmId, noEventSend)

    if self.isServer and spec.storage ~ = nil then
        spec.storage:setOwnerFarmId(farmId, true )
    end
end

```