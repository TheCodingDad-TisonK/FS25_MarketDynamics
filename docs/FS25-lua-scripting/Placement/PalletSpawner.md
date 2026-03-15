## PalletSpawner

**Description**

> This class spawns pallets

**Functions**

- [delete](#delete)
- [getAllPallets](#getallpallets)
- [getOrSpawnPallet](#getorspawnpallet)
- [getSupportedFillTypes](#getsupportedfilltypes)
- [load](#load)
- [loadPalletFromFilename](#loadpalletfromfilename)
- [new](#new)
- [onFindExistingPallet](#onfindexistingpallet)
- [onFindPallet](#onfindpallet)
- [onFinishLoadingPallet](#onfinishloadingpallet)
- [onSpawnSearchFinished](#onspawnsearchfinished)
- [registerXMLPaths](#registerxmlpaths)
- [spawnPallet](#spawnpallet)
- [update](#update)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function PalletSpawner:delete()
end

```

### getAllPallets

**Description**

> Get all pallets for given fillTypeId within the spawn places

**Definition**

> getAllPallets(integer fillTypeId, function callbackFunc, table callbackTarget)

**Arguments**

| integer  | fillTypeId     | fillTypeId to be supported by the pallet                                    |
|----------|----------------|-----------------------------------------------------------------------------|
| function | callbackFunc   | callback function which will receive indexed list of pallet vehicle objects |
| table    | callbackTarget | target for the callback function                                            |

**Code**

```lua
function PalletSpawner:getAllPallets(fillTypeId, callbackFunc, callbackTarget)
    self.getAllPalletsFoundPallets = { }
    self.getAllPalletsFilltype = fillTypeId

    local spawnPlaces = self.fillTypeToSpawnPlaces[fillTypeId] or self.spawnPlaces
    for i = 1 , #spawnPlaces do
        local place = spawnPlaces[i]
        local x = place.startX + place.width / 2 * place.dirX
        local y = place.startY + place.width / 2 * place.dirY
        local z = place.startZ + place.width / 2 * place.dirZ
        overlapBox(x,y,z, place.rotX, place.rotY, place.rotZ, place.width / 2 , 1 , 1 , "onFindPallet" , self , CollisionFlag.VEHICLE + CollisionFlag.DYNAMIC_OBJECT, true , true , false , true )
    end

    callbackFunc(callbackTarget, table.toList( self.getAllPalletsFoundPallets), fillTypeId)
end

```

### getOrSpawnPallet

**Description**

> Get pallet for given fillTypeId, searches spawnPlaces for existing non-full pallets, spawns a new one otherwise

**Definition**

> getOrSpawnPallet(integer fillTypeId, function callback, table callbackTarget, )

**Arguments**

| integer  | fillTypeId     | fillTypeId to be supported by the pallet            |
|----------|----------------|-----------------------------------------------------|
| function | callback       | callback function which will receive pallet vehicle |
| table    | callbackTarget | target for the callback function                    |
| any      | callbackTarget |                                                     |

**Code**

```lua
function PalletSpawner:getOrSpawnPallet(farmId, fillTypeId, callback, callbackTarget)
    self.foundExistingPallet = nil
    self.getOrSpawnPalletFilltype = fillTypeId

    local spawnPlaces = self.fillTypeToSpawnPlaces[fillTypeId] or self.spawnPlaces

    for i = 1 , #spawnPlaces do
        local place = spawnPlaces[i]
        local x = place.startX + place.width / 2 * place.dirX
        local y = place.startY + place.width / 2 * place.dirY
        local z = place.startZ + place.width / 2 * place.dirZ
        overlapBox(x,y,z, place.rotX, place.rotY, place.rotZ, place.width / 2 , 1 , 1 , "onFindExistingPallet" , self , CollisionFlag.VEHICLE + CollisionFlag.DYNAMIC_OBJECT, true , true , false , true )
    end

    if self.foundExistingPallet ~ = nil then
        callback(callbackTarget, self.foundExistingPallet, PalletSpawner.PALLET_ALREADY_PRESENT, fillTypeId)
    else
            self:spawnPallet(farmId, fillTypeId, callback, callbackTarget)
        end
    end

```

### getSupportedFillTypes

**Description**

**Definition**

> getSupportedFillTypes()

**Code**

```lua
function PalletSpawner:getSupportedFillTypes()
    return self.fillTypeIdToPallet
end

```

### load

**Description**

> Loads data from xml

**Definition**

> load(table components, table xmlFile, string key, string customEnv, table i3dMappings)

**Arguments**

| table  | components  | components         |
|--------|-------------|--------------------|
| table  | xmlFile     | xml file object    |
| string | key         | xml key            |
| string | customEnv   | custom environment |
| table  | i3dMappings | i3dMappings        |

**Return Values**

| table | success | success |
|-------|---------|---------|

**Code**

```lua
function PalletSpawner:load(components, xmlFile, key, customEnv, i3dMappings)
    self.spawnPlaces = { }
    self.fillTypeToSpawnPlaces = { }
    local hasFillTypeSpawnPlaces = false

    for _, spawnPlaceKey in xmlFile:iterator(key .. ".spawnPlaces.spawnPlace" ) do
        local spawnPlace = PlacementUtil.loadPlaceFromXML(xmlFile, spawnPlaceKey, components, i3dMappings)

        local fillTypes
        local fillTypeCategories = xmlFile:getValue(spawnPlaceKey .. "#fillTypeCategories" )
        local fillTypeNames = xmlFile:getValue(spawnPlaceKey .. "#fillTypes" )
        if fillTypeCategories ~ = nil and fillTypeNames = = nil then
            fillTypes = g_fillTypeManager:getFillTypesByCategoryNames(fillTypeCategories, "Warning:Palletspawner '" .. xmlFile:getFilename() .. "' has invalid fillTypeCategory '%s'." )
        elseif fillTypeCategories = = nil and fillTypeNames ~ = nil then
                fillTypes = g_fillTypeManager:getFillTypesByNames(fillTypeNames, "Warning:Palletspawner '" .. xmlFile:getFilename() .. "' has invalid fillType '%s'." )
            end

            if fillTypes ~ = nil then
                hasFillTypeSpawnPlaces = true
                for _, fillType in ipairs(fillTypes) do
                    if self.fillTypeToSpawnPlaces[fillType] = = nil then
                        self.fillTypeToSpawnPlaces[fillType] = { }
                    end
                    table.insert( self.fillTypeToSpawnPlaces[fillType], spawnPlace)
                end
            else
                    table.insert( self.spawnPlaces, spawnPlace)
                end
            end

            if # self.spawnPlaces = = 0 and not hasFillTypeSpawnPlaces then
                Logging.xmlError(xmlFile, "No spawn place(s) defined for pallet spawner %s%s" , key, ".spawnPlaces" )
                    return false
                end

                self.pallets = { }
                self.fillTypeIdToPallet = { }

                -- load default global pallets defined at fillTypes registration
                for fillTypeId, fillType in pairs(g_fillTypeManager.indexToFillType) do
                    if fillType.palletFilename then
                        self:loadPalletFromFilename(fillType.palletFilename, fillTypeId)
                    end
                end

                -- load pallets provided in xml file, will override fillType pallets
                for _, palletKey in xmlFile:iterator(key .. ".pallets.pallet" ) do
                    local palletFilename = Utils.getFilename(xmlFile:getValue(palletKey .. "#filename" ), self.baseDirectory)
                    self:loadPalletFromFilename(palletFilename)
                end

                return true
            end

```

### loadPalletFromFilename

**Description**

**Definition**

> loadPalletFromFilename()

**Arguments**

| any | palletFilename  |
|-----|-----------------|
| any | limitFillTypeId |

**Code**

```lua
function PalletSpawner:loadPalletFromFilename(palletFilename, limitFillTypeId)
    if palletFilename ~ = nil then
        local pallet = { }
        pallet.filename = palletFilename
        pallet.size = StoreItemUtil.getSizeValues(palletFilename, "vehicle" , 0 , { } )

        local palletXmlFile = XMLFile.load( "palletXmlFilename" , palletFilename, Vehicle.xmlSchema)
        if palletXmlFile = = nil then
            return nil
        end

        local fillTypeNamesAndCategories = FillUnit.getFillTypeNamesFromXML(palletXmlFile)
        pallet.capacity = FillUnit.getCapacityFromXml(palletXmlFile)
        palletXmlFile:delete()

        local fillTypes = { }
        fillTypes = g_fillTypeManager:getFillTypesByCategoryNames(fillTypeNamesAndCategories.fillTypeCategoryNames, nil , fillTypes)
        fillTypes = g_fillTypeManager:getFillTypesByNames(fillTypeNamesAndCategories.fillTypeNames, nil , fillTypes)

        local hadMatchingFillType = false
        for _, fillTypeId in ipairs(fillTypes) do
            if limitFillTypeId = = nil or limitFillTypeId = = fillTypeId then
                self.fillTypeIdToPallet[fillTypeId] = pallet
                hadMatchingFillType = true
            end
        end

        if hadMatchingFillType then
            table.insert( self.pallets, pallet)
            return pallet
        end
    end
    return nil
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | baseDirectory |
|-----|---------------|
| any | customMt      |

**Code**

```lua
function PalletSpawner.new(baseDirectory, customMt)
    local self = setmetatable( { } , customMt or PalletSpawner _mt)

    self.baseDirectory = baseDirectory
    self.spawnQueue = { }
    self.currentObjectToSpawn = nil
    self.spawnOffsetY = Platform.gameplay.hasDynamicPallets and 0.2 or 0

    return self
end

```

### onFindExistingPallet

**Description**

**Definition**

> onFindExistingPallet()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PalletSpawner:onFindExistingPallet(node)
    local object = g_currentMission.nodeToObject[node]
    if object ~ = nil and object.isa ~ = nil and object:isa( Vehicle ) and object.isPallet then
        if object:getFillUnitSupportsFillType( 1 , self.getOrSpawnPalletFilltype) and object:getFillUnitFreeCapacity( 1 , self.getOrSpawnPalletFilltype) > 0 then
            self.foundExistingPallet = object
            return false -- stop callback reporting
        end
    end

    return
end

```

### onFindPallet

**Description**

**Definition**

> onFindPallet()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function PalletSpawner:onFindPallet(node)
    local object = g_currentMission.nodeToObject[node]
    if object ~ = nil and object.isa ~ = nil and object:isa( Vehicle ) and object.isPallet then
        local fillUnitIndex = object.spec_pallet.fillUnitIndex
        if object:getFillUnitFillType(fillUnitIndex) = = self.getAllPalletsFilltype then
            self.getAllPalletsFoundPallets[object] = true
        end
    end
end

```

### onFinishLoadingPallet

**Description**

**Definition**

> onFinishLoadingPallet()

**Arguments**

| any | vehicles         |
|-----|------------------|
| any | vehicleLoadState |

**Code**

```lua
function PalletSpawner:onFinishLoadingPallet(vehicles, vehicleLoadState)
    local objectToSpawn = self.currentObjectToSpawn
    local statusCode = vehicleLoadState = = VehicleLoadingState.OK and PalletSpawner.RESULT_SUCCESS or PalletSpawner.RESULT_ERROR_LOADING_PALLET
    objectToSpawn.callback(objectToSpawn.callbackTarget, vehicles[ 1 ], statusCode, objectToSpawn.fillType)
    self.currentObjectToSpawn = nil
    table.remove( self.spawnQueue, 1 )
end

```

### onSpawnSearchFinished

**Description**

**Definition**

> onSpawnSearchFinished()

**Arguments**

| any | location |
|-----|----------|

**Code**

```lua
function PalletSpawner:onSpawnSearchFinished(location)
    local objectToSpawn = self.currentObjectToSpawn
    if location ~ = nil then
        local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, location.x, 0 , location.z)
        -- ensure y is at least terrain height
        -- using only terrain height + offset for pallets might be problematic if spawn area is on top of a mesh with collision
            -- add saftey y offset to avoid pallets clipping into the ground/collision
            location.y = math.max(terrainHeight + self.spawnOffsetY, location.y)

            local data = VehicleLoadingData.new()
            data:setFilename(objectToSpawn.pallet.filename)
            data:setPosition(location.x, location.y, location.z)
            data:setRotation(location.xRot, location.yRot, location.zRot)
            data:setPropertyState(VehiclePropertyState.OWNED)
            data:setOwnerFarmId(objectToSpawn.farmId)
            data:setCustomParameter( "spawnEmpty" , true )

            data:load( self.onFinishLoadingPallet, self )
        else
                -- unable to find space
                objectToSpawn.callback(objectToSpawn.callbackTarget, nil , PalletSpawner.RESULT_NO_SPACE, objectToSpawn.fillType)
                self.currentObjectToSpawn = nil
                table.remove( self.spawnQueue, 1 )
            end
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
function PalletSpawner.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. ".spawnPlaces.spawnPlace(?)#fillTypes" , "Supported filltypes for this spawnPlace" )
        schema:register(XMLValueType.STRING, basePath .. ".spawnPlaces.spawnPlace(?)#fillTypeCategories" , "Supported filltype categories for this spawnPlace" )

            PlacementUtil.registerXMLPaths(schema, basePath)

            schema:register(XMLValueType.STRING, basePath .. ".pallets.pallet(?)#filename" , "Path to pallet xml file" )
        end

```

### spawnPallet

**Description**

> Spawn and get pallet for given fillTypeId

**Definition**

> spawnPallet(integer fillTypeId, function callback, table callbackTarget, )

**Arguments**

| integer  | fillTypeId     | fillTypeId to be supported by the pallet            |
|----------|----------------|-----------------------------------------------------|
| function | callback       | callback function which will receive pallet vehicle |
| table    | callbackTarget | target for the callback function                    |
| any      | callbackTarget |                                                     |

**Code**

```lua
function PalletSpawner:spawnPallet(farmId, fillTypeId, callback, callbackTarget)
    if not g_currentMission.slotSystem:getCanAddLimitedObjects(SlotSystem.LIMITED_OBJECT_PALLET, 1 ) then
        callback(callbackTarget, nil , PalletSpawner.PALLET_LIMITED_REACHED, fillTypeId)
        return
    end

    local pallet = self.fillTypeIdToPallet[fillTypeId]
    if pallet ~ = nil then
        table.insert( self.spawnQueue, { pallet = pallet, fillType = fillTypeId, farmId = farmId, callback = callback, callbackTarget = callbackTarget } )
        g_currentMission:addUpdateable( self )
    else
            Logging.devError( "PalletSpawner:no pallet for fillTypeId '%s'" , fillTypeId)
                callback(callbackTarget, nil , PalletSpawner.NO_PALLET_FOR_FILLTYPE, fillTypeId)
            end
        end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PalletSpawner:update(dt)
    if # self.spawnQueue > 0 then
        -- DebugUtil.renderTable(0.1, 0.88, 0.015, {{name = "palletSpawnerQueue", value = "# = " .. #self.spawnQueue}})

        if self.currentObjectToSpawn = = nil then
            self.currentObjectToSpawn = self.spawnQueue[ 1 ]

            -- DebugUtil.renderTable(0.1, 0.85, 0.015, {{name = "currentPallet", value = self.currentObjectToSpawn.pallet.filename}})

            local spawnPlaces = self.fillTypeToSpawnPlaces[ self.currentObjectToSpawn.fillType] or self.spawnPlaces
            g_currentMission.placementManager:getPlaceAsync(spawnPlaces, self.currentObjectToSpawn.pallet.size, self.onSpawnSearchFinished, self , nil , self.spawnOffsetY, nil , nil )
        end
    else
            g_currentMission:removeUpdateable( self ) -- dont update unless there are pallets to spawn
        end
    end

```