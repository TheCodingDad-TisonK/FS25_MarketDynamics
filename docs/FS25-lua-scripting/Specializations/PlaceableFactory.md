## PlaceableFactory

**Description**

> Specialization for placeables

**Functions**

- [loadFromXMLFile](#loadfromxmlfile)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)

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
function PlaceableFactory:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_factory

    for _, inputKey in xmlFile:iterator(key .. ".input" ) do

        local fillType = g_fillTypeManager:getFillTypeByName(xmlFile:getValue(inputKey .. "#fillType" ))
        local remainingAmount = xmlFile:getValue(inputKey .. "#remainingAmount" )

        for _, input in ipairs(spec.inputs) do
            if input.fillType = = fillType then
                self:updateRemainingAmount( input , remainingAmount)
            end
        end
    end

    spec.storage:loadFromXMLFile(xmlFile, key .. ".storage" )
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
function PlaceableFactory:onLoad(savegame)
    local spec = self.spec_factory

    local key = "placeable.factory"

    spec.itemLinkNode = self.xmlFile:getValue(key .. ".item#linkNode" , nil , self.components, self.i3dMappings)

    local itemI3DFilename = Utils.getFilename( self.xmlFile:getValue(key .. ".item#filename" ), self.baseDirectory)
    spec.itemReward = self.xmlFile:getValue(key .. ".item#reward" , 100000 )

    spec.idToMesh = { }
    spec.meshes = { }

    local arguments = {
    loadingTask = self:createLoadingTask(spec),
    }

    spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(itemI3DFilename, true , false , self.onMeshI3DFileLoaded, self , arguments)

    local sellingStation = self.spec_sellingStation.sellingStation
    sellingStation.owningPlaceable = self

    sellingStation.getStoreGoods = function (_, farmId, fillTypeIndex)
        return true
    end
    sellingStation.getSkipSell = function (_, farmId, fillTypeIndex)
        -- owned by a farm
        local ownerFarmId = self:getOwnerFarmId()
        if ownerFarmId ~ = AccessHandler.EVERYONE then
            return true
        end

        return false
    end

    spec.storage = Storage.new( self.isServer, self.isClient)
    spec.storage:load( self.components, self.xmlFile, key .. ".storage" , self.i3dMappings, self.baseDirectory)
    spec.storage:register( true )
    spec.storage:addFillLevelChangedListeners( function ()
        self:raiseActive() -- trigger update loop after storage was changed
    end )
    spec.storageFillLevelChangedCallback = function () self:updateInfoData() end
    spec.fillTypesAndLevelsAuxiliary = { }
    spec.fillTypeToFillTypeStorageTable = { }
    spec.infoTriggerFillTypesAndLevels = { }
    spec.infoTableEntryStorage = { title = g_i18n:getText( "statistic_storage" ), accentuate = true }

    sellingStation:addTargetStorage(spec.storage)

    spec.playerTrigger = self.xmlFile:getValue(key .. "#playerTrigger" , nil , self.components, self.i3dMappings)
    if spec.playerTrigger ~ = nil then
        addTrigger(spec.playerTrigger, "playerTriggerCallback" , self )
        setVisibility(spec.playerTrigger, self:getOwnerFarmId() = = AccessHandler.EVERYONE) -- set invisible by default, will be made visible again if buyable
        end
        spec.activatable = FactoryActivatable.new( self )

        spec.totalAmount = 0
        spec.inputs = { }
        spec.hasInputMaterials = true -- used to define raiseActive() / update()
        spec.progress = 0
        spec.progressLastSynced = 0
        spec.progressNumBits = 7
        spec.progressDirtyFlag = self:getNextDirtyFlag()

        --this part is required for the factory to be shown in the ingame menu productions frame
            self.inputFillTypeIdsArray = { }
            self.outputFillTypeIdsArray = { }

            local outputTypeStr = self.xmlFile:getValue(key .. ".production.output#fillType" )
            local outputType = g_fillTypeManager:getFillTypeByName(outputTypeStr)

            self.productions = { }
            local production = {
            inputs = { } ,
            outputs = { } ,

            cyclesPerMonth = 1 ,
            costsPerActiveMonth = 0 ,
            }

            if outputType ~ = nil then
                production.primaryProductFillType = outputType.index
                production.name = outputType.title

                table.insert( self.outputFillTypeIdsArray, outputType.index)

                table.insert(production.outputs, {
                type = outputType.index,
                amount = 1 ,
                isFactory = true ,
                } )
            end

            for _, inputKey in self.xmlFile:iterator(key .. ".production.input" ) do
                local fillTypeStr = self.xmlFile:getValue(inputKey .. "#fillType" )
                local fillType = g_fillTypeManager:getFillTypeByName(fillTypeStr)
                if fillType = = nil then
                    Logging.xmlWarning( self.xmlFile, "Unknown fillType '%s' in '%s'" , fillTypeStr, inputKey)
                    break
                end

                if not spec.storage:getIsFillTypeSupported(fillType.index) then
                    Logging.xmlWarning( self.xmlFile, "Filltype '%s' in '%s' not supported by storage" , fillType.name, inputKey)
                    break
                end

                local amount = self.xmlFile:getValue(inputKey .. "#amount" )
                local usagePerHour = self.xmlFile:getValue(inputKey .. "#usagePerHour" )
                local usagePerSecond = usagePerHour / 60 / 60
                spec.totalAmount = spec.totalAmount + amount

                table.insert(spec.inputs, {
                fillType = fillType,
                amount = amount,
                remainingAmount = amount,
                usagePerSecond = usagePerSecond,
                infoTableEntry = { title = fillType.title, text = g_i18n:formatVolume(amount) }
                }
                )

                table.insert(production.inputs, {
                type = fillType.index,
                amount = amount
                } )

                production.cyclesPerMonth = math.max(production.cyclesPerMonth, amount * g_currentMission.environment.timeAdjustment / (usagePerHour * 24 ))
                table.insert( self.inputFillTypeIdsArray, fillType.index)
            end

            table.insert( self.productions, production)

            spec.samples = { }
            spec.samples.active = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "active" , self.baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
            spec.isSoundPlaying = false
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
function PlaceableFactory:onReadStream(streamId, connection)
    local spec = self.spec_factory

    -- storage
    local storageId = NetworkUtil.readNodeObjectId(streamId)
    spec.storage:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.storage, storageId)

    spec.hasInputMaterials = streamReadBool(streamId)

    spec.progress = NetworkUtil.readCompressedPercentages(streamId, spec.progressNumBits)

    for meshIndex, mesh in ipairs(spec.meshes) do
        local hideByIndexValue = streamReadUIntN(streamId, mesh.numBits)
        local progress = MathUtil.inverseLerp(mesh.indexMax, mesh.indexMin, hideByIndexValue)
        self:setMeshProgress(mesh.id, progress)
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
function PlaceableFactory:onWriteStream(streamId, connection)
    local spec = self.spec_factory

    -- storage
    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.storage))
    spec.storage:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.storage)

    streamWriteBool(streamId, spec.hasInputMaterials)

    NetworkUtil.writeCompressedPercentages(streamId, spec.progress, spec.progressNumBits)

    for meshIndex, mesh in ipairs(spec.meshes) do
        streamWriteUIntN(streamId, mesh.lastValue, mesh.numBits)
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
function PlaceableFactory.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableSellingStation , specializations)
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
function PlaceableFactory.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onInfoTriggerEnter" , PlaceableFactory )
    SpecializationUtil.registerEventListener(placeableType, "onInfoTriggerLeave" , PlaceableFactory )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableFactory.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onMeshI3DFileLoaded" , PlaceableFactory.onMeshI3DFileLoaded)
    SpecializationUtil.registerFunction(placeableType, "updateRemainingAmount" , PlaceableFactory.updateRemainingAmount)
    SpecializationUtil.registerFunction(placeableType, "setMeshProgress" , PlaceableFactory.setMeshProgress)
    SpecializationUtil.registerFunction(placeableType, "createFactoryItem" , PlaceableFactory.createFactoryItem)
    SpecializationUtil.registerFunction(placeableType, "sellFactoryItem" , PlaceableFactory.sellFactoryItem)
    SpecializationUtil.registerFunction(placeableType, "getCapacity" , PlaceableFactory.getCapacity)
    SpecializationUtil.registerFunction(placeableType, "getFillLevel" , PlaceableFactory.getFillLevel)
    SpecializationUtil.registerFunction(placeableType, "removeFillLevel" , PlaceableFactory.removeFillLevel)
    SpecializationUtil.registerFunction(placeableType, "playerTriggerCallback" , PlaceableFactory.playerTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "buyRequest" , PlaceableFactory.buyRequest)
    SpecializationUtil.registerFunction(placeableType, "updateInfoData" , PlaceableFactory.updateInfoData)
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
function PlaceableFactory.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableFactory.updateInfo)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableFactory.setOwnerFarmId)
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
function PlaceableFactory.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. ".input(?)#fillType" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".input(?)#remainingAmount" , "" )

    Storage.registerSavegameXMLPaths(schema, basePath .. ".storage" )
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
function PlaceableFactory.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "PlaceableFactory" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".factory#playerTrigger" , "" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".factory.item#linkNode" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".factory.item#filename" , "" )
    schema:register(XMLValueType.INT, basePath .. ".factory.item#reward" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".factory.item.progressiveVisibilityMesh.mesh(?)#node" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".factory.item.progressiveVisibilityMesh.mesh(?)#id" , "" )
    schema:register(XMLValueType.INT, basePath .. ".factory.item.progressiveVisibilityMesh.mesh(?)#indexMin" , "" )
    schema:register(XMLValueType.INT, basePath .. ".factory.item.progressiveVisibilityMesh.mesh(?)#indexMax" , "" )

    schema:register(XMLValueType.STRING, basePath .. ".factory.production.input(?)#fillType" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".factory.production.input(?)#amount" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".factory.production.input(?)#usagePerHour" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".factory.production.output#fillType" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".factory.production#meshId" , "" )

    SellingStation.registerXMLPaths(schema, basePath .. ".factory.sellingStation" )

    Storage.registerXMLPaths(schema, basePath .. ".factory.storage" )

    SoundManager.registerSampleXMLPaths(schema, basePath .. ".factory.sounds" , "active" )

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
function PlaceableFactory:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_factory

    xmlFile:setSortedTable(key .. ".input" , spec.inputs, function (inputKey, input )
        xmlFile:setValue(inputKey .. "#fillType" , input.fillType.name)
        xmlFile:setValue(inputKey .. "#remainingAmount" , input.remainingAmount)
    end )

    spec.storage:saveToXMLFile(xmlFile, key .. ".storage" )
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | farmId    |

**Code**

```lua
function PlaceableFactory:setOwnerFarmId(superFunc, farmId)
    local oldFarmId = self:getOwnerFarmId()

    superFunc( self , farmId)

    local spec = self.spec_factory

    if spec.playerTrigger ~ = nil then
        setVisibility(spec.playerTrigger, farmId = = AccessHandler.EVERYONE) -- or farmId = = g_currentMission:getFarmId()
    end

    if self.propertyState ~ = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
        g_currentMission.productionChainManager:removeFactory( self , oldFarmId)

        local sellingStation = self.spec_sellingStation.sellingStation
        if sellingStation ~ = nil then
            -- remove from selling station overview if owned, as it does not generate revenue upon deliver anymore
                if farmId = = AccessHandler.EVERYONE then
                    g_currentMission.storageSystem:addUnloadingStation(sellingStation, self )
                    g_currentMission.economyManager:addSellingStation(sellingStation)
                else
                        g_currentMission.economyManager:removeSellingStation(sellingStation)
                        g_currentMission.storageSystem:removeUnloadingStation(sellingStation, self )
                    end
                end

                g_currentMission.productionChainManager:addFactory( self )
            end
        end

```