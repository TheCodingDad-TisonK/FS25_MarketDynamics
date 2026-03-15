## PlaceableManureHeap

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [getCanBePlacedAt](#getcanbeplacedat)
- [getSpecValueCapacity](#getspecvaluecapacity)
- [initSpecialization](#initspecialization)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadSpecValueCapacity](#loadspecvaluecapacity)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)
- [updateInfo](#updateinfo)

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableManureHeap:collectPickObjects(superFunc, node)
    local spec = self.spec_manureHeap

    if spec.loadingStation ~ = nil then
        for _, loadTrigger in ipairs(spec.loadingStation.loadTriggers) do
            if node = = loadTrigger.triggerNode then
                return
            end
        end
    end

    if spec.manureHeap ~ = nil then
        if node = = spec.manureHeap.activationTriggerNode then
            return
        end
    end

    superFunc( self , node)
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
function PlaceableManureHeap:getCanBePlacedAt(superFunc, x, y, z, farmId)
    local spec = self.spec_manureHeap
    if spec.manureHeap = = nil then
        return false
    end

    if spec.needsBarn then
        local storageSystem = g_currentMission.storageSystem

        -- we also need to check farmId
        local lastFoundUnloadingStations = storageSystem:getExtendableUnloadingStationsInRange(spec.manureHeap, farmId, x, y, z)
        if #lastFoundUnloadingStations = = 0 then
            return false , g_i18n:getText( "warning_manureHeapNotNearBarn" )
        end
    end

    return superFunc( self , x, y, z, farmId)
end

```

### getSpecValueCapacity

**Description**

**Definition**

> getSpecValueCapacity()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function PlaceableManureHeap.getSpecValueCapacity(storeItem, realItem)
    if storeItem.specs.manureHeapCapacity = = nil then
        return nil
    end

    return g_i18n:formatVolume(storeItem.specs.manureHeapCapacity)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableManureHeap.initSpecialization()
    g_storeManager:addSpecType( "manureHeapCapacity" , "shopListAttributeIconCapacity" , PlaceableManureHeap.loadSpecValueCapacity, PlaceableManureHeap.getSpecValueCapacity, StoreSpecies.PLACEABLE)
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
function PlaceableManureHeap:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_manureHeap
    if spec.manureHeap ~ = nil then
        spec.manureHeap:loadFromXMLFile(xmlFile, key)
    end
end

```

### loadSpecValueCapacity

**Description**

**Definition**

> loadSpecValueCapacity()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function PlaceableManureHeap.loadSpecValueCapacity(xmlFile, customEnvironment, baseDir)
    return xmlFile:getValue( "placeable.manureHeap#capacity" )
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableManureHeap:onDelete()
    local spec = self.spec_manureHeap
    local storageSystem = g_currentMission.storageSystem

    if spec.manureHeap ~ = nil then
        if storageSystem:hasStorage(spec.manureHeap) then
            -- just remove storage from all registered unloading and loading stations
            storageSystem:removeStorageFromUnloadingStations(spec.manureHeap, spec.manureHeap.unloadingStations)
            storageSystem:removeStorageFromLoadingStations(spec.manureHeap, spec.manureHeap.loadingStations)

            storageSystem:removeStorage(spec.manureHeap)
        end
        spec.manureHeap:delete()
        spec.manureHeap = nil
    end

    if spec.loadingStation ~ = nil then
        if spec.loadingStation:getIsFillTypeSupported(FillType.MANURE) then
            g_currentMission:removeManureLoadingStation(spec.loadingStation)
        end

        storageSystem:removeLoadingStation(spec.loadingStation, self )
        spec.loadingStation:delete()
        spec.loadingStation = nil
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableManureHeap:onFinalizePlacement()
    local spec = self.spec_manureHeap
    local storageSystem = g_currentMission.storageSystem
    local ownerFarmId = self:getOwnerFarmId()

    if spec.loadingStation ~ = nil and spec.manureHeap ~ = nil then
        spec.loadingStation:register( true )
        storageSystem:addLoadingStation(spec.loadingStation, self )

        spec.manureHeap:finalize()
        spec.manureHeap:register( true )
        spec.manureHeap:setOwnerFarmId(ownerFarmId, true )
        storageSystem:addStorage(spec.manureHeap)
        storageSystem:addStorageToLoadingStation(spec.manureHeap, spec.loadingStation)

        if spec.loadingStation:getIsFillTypeSupported(FillType.MANURE) then
            g_currentMission:addManureLoadingStation(spec.loadingStation)
        end

        local storagesInRange = storageSystem:getStorageExtensionsInRange(spec.loadingStation, ownerFarmId)
        for _, storage in ipairs(storagesInRange) do
            if spec.loadingStation.sourceStorages[storage] = = nil then
                storageSystem:addStorageToLoadingStation(storage, spec.loadingStation)
            end
        end

        local lastFoundUnloadingStations = storageSystem:getExtendableUnloadingStationsInRange(spec.manureHeap, ownerFarmId)
        local lastFoundLoadingStations = storageSystem:getExtendableLoadingStationsInRange(spec.manureHeap, ownerFarmId)
        storageSystem:addStorageToUnloadingStations(spec.manureHeap, lastFoundUnloadingStations)
        storageSystem:addStorageToLoadingStations(spec.manureHeap, lastFoundLoadingStations)
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
function PlaceableManureHeap:onLoad(savegame)
    local spec = self.spec_manureHeap
    local xmlFile = self.xmlFile

    spec.loadingStation = LoadingStation.new( self.isServer, self.isClient)
    if not spec.loadingStation:load(spec.components, xmlFile, "placeable.manureHeap.loadingStation" , self.customEnvironment, self.i3dMappings, self.components[ 1 ].node) then
        spec.loadingStation:delete()
        spec.loadingStation = nil
        return false
    end
    spec.loadingStation.owningPlaceable = self
    spec.loadingStation.hasStoragePerFarm = false

    spec.manureHeap = ManureHeap.new(spec.isServer, self.isClient)
    if not spec.manureHeap:load(spec.components, xmlFile, "placeable.manureHeap" , self.customEnvironment, self.i3dMappings, self.components[ 1 ].node) then
        spec.manureHeap:delete()
        spec.manureHeap = nil
    end

    spec.needsBarn = xmlFile:getValue( "placeable.manureHeap#needsBarn" , false )

    spec.infoFillLevel = { title = g_i18n:getText( "fillType_manure" ), text = "" }

    return true
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
function PlaceableManureHeap:onReadStream(streamId, connection)
    local spec = self.spec_manureHeap

    if spec.loadingStation ~ = nil and spec.manureHeap ~ = nil then
        local loadingStationId = NetworkUtil.readNodeObjectId(streamId)
        spec.loadingStation:readStream(streamId, connection)
        g_client:finishRegisterObject(spec.loadingStation, loadingStationId)

        local manureHeapId = NetworkUtil.readNodeObjectId(streamId)
        spec.manureHeap:readStream(streamId, connection)
        g_client:finishRegisterObject(spec.manureHeap, manureHeapId)
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
function PlaceableManureHeap:onWriteStream(streamId, connection)
    local spec = self.spec_manureHeap

    if spec.loadingStation ~ = nil and spec.manureHeap ~ = nil then
        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.loadingStation))
        spec.loadingStation:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, spec.loadingStation)

        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.manureHeap))
        spec.manureHeap:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, spec.manureHeap)
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
function PlaceableManureHeap.prerequisitesPresent(specializations)
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
function PlaceableManureHeap.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableManureHeap )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableManureHeap )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableManureHeap )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableManureHeap )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableManureHeap )
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
function PlaceableManureHeap.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableManureHeap.setOwnerFarmId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableManureHeap.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getCanBePlacedAt" , PlaceableManureHeap.getCanBePlacedAt)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableManureHeap.updateInfo)
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
function PlaceableManureHeap.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "ManureHeap" )
    ManureHeap.registerSavegameXMLPaths(schema, basePath)
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
function PlaceableManureHeap.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "ManureHeap" )
    ManureHeap.registerXMLPaths(schema, basePath .. ".manureHeap" )
    schema:register(XMLValueType.BOOL, basePath .. ".manureHeap#needsBarn" , "Can only be placed next to a barn" , true )
    LoadingStation.registerXMLPaths(schema, basePath .. ".manureHeap.loadingStation" )
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
function PlaceableManureHeap:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_manureHeap
    if spec.manureHeap ~ = nil then
        spec.manureHeap:saveToXMLFile(xmlFile, key, usedModNames)
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
function PlaceableManureHeap:setOwnerFarmId(superFunc, farmId, noEventSend)
    superFunc( self , farmId, noEventSend)

    local spec = self.spec_manureHeap

    if self.isServer then
        if spec.manureHeap ~ = nil then
            spec.manureHeap:setOwnerFarmId(farmId, true )
        end
    end

    local storageSystem = g_currentMission.storageSystem
    if spec.loadingStation ~ = nil then
        local storagesInRange = storageSystem:getStorageExtensionsInRange(spec.loadingStation, farmId)
        for _, storage in ipairs(storagesInRange) do
            if spec.loadingStation.sourceStorages[storage] = = nil then
                storageSystem:addStorageToLoadingStation(storage, spec.loadingStation)
            end
        end
    end

    if spec.manureHeap ~ = nil then
        local lastFoundUnloadingStations = storageSystem:getExtendableUnloadingStationsInRange(spec.manureHeap, farmId)
        local lastFoundLoadingStations = storageSystem:getExtendableLoadingStationsInRange(spec.manureHeap, farmId)
        storageSystem:addStorageToUnloadingStations(spec.manureHeap, lastFoundUnloadingStations)
        storageSystem:addStorageToLoadingStations(spec.manureHeap, lastFoundLoadingStations)
    end
end

```

### updateInfo

**Description**

**Definition**

> updateInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | infoTable |

**Code**

```lua
function PlaceableManureHeap:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)

    local spec = self.spec_manureHeap
    if spec.manureHeap = = nil then
        return
    end

    local fillLevel = spec.manureHeap:getFillLevel(spec.manureHeap.fillTypeIndex)

    spec.infoFillLevel.text = string.format( "%d l" , fillLevel)
    table.insert(infoTable, spec.infoFillLevel)
end

```