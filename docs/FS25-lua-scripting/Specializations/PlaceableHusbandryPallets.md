## PlaceableHusbandryPallets

**Description**

> Specialization for placeables

**Functions**

- [getAllPalletsCallback](#getallpalletscallback)
- [getConditionInfos](#getconditioninfos)
- [getPalletCallback](#getpalletcallback)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onHusbandryAnimalsUpdate](#onhusbandryanimalsupdate)
- [onLoad](#onload)
- [onPalletTriggerCallback](#onpallettriggercallback)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [showPalletBlockedWarning](#showpalletblockedwarning)
- [showSpawnerBlockedWarning](#showspawnerblockedwarning)
- [updateInfo](#updateinfo)
- [updateOutput](#updateoutput)
- [updatePalletInfo](#updatepalletinfo)
- [updatePallets](#updatepallets)

### getAllPalletsCallback

**Description**

**Definition**

> getAllPalletsCallback()

**Arguments**

| any | pallets       |
|-----|---------------|
| any | fillTypeIndex |

**Code**

```lua
function PlaceableHusbandryPallets:getAllPalletsCallback(pallets, fillTypeIndex)
    local spec = self.spec_husbandryPallets
    spec.numPalletInfoUpdateRunning = math.max(spec.numPalletInfoUpdateRunning - 1 , 0 )

    for _, pallet in pairs(pallets) do
        local fillUnitIndex = pallet.spec_pallet.fillUnitIndex
        local palletCapacity = pallet:getFillUnitCapacity(fillUnitIndex)
        spec.capacitiesPending[fillTypeIndex] = spec.capacitiesPending[fillTypeIndex] + palletCapacity
        spec.fillLevelsPending[fillTypeIndex] = spec.fillLevelsPending[fillTypeIndex] + pallet:getFillUnitFillLevel(fillUnitIndex)
        spec.maxCapacitiesPending[fillTypeIndex] = math.max(spec.maxCapacitiesPending[fillTypeIndex], palletCapacity)
    end

    if spec.numPalletInfoUpdateRunning < = 0 then
        for fillTypeIndex, _ in pairs(spec.fillLevels) do
            spec.fillLevels[fillTypeIndex] = spec.fillLevelsPending[fillTypeIndex]

            local capacity = spec.capacitiesPending[fillTypeIndex]
            if #pallets < spec.maxNumPallets[fillTypeIndex] then
                capacity = spec.maxCapacitiesPending[fillTypeIndex] * spec.maxNumPallets[fillTypeIndex]
            end
            spec.capacities[fillTypeIndex] = capacity

            if math.abs(spec.fillLevels[fillTypeIndex] - spec.fillLevelsSent[fillTypeIndex]) > 1 or math.abs(spec.capacities[fillTypeIndex] - spec.capacitiesSent[fillTypeIndex]) > 1 then
                spec.fillLevelsSent[fillTypeIndex] = spec.fillLevels[fillTypeIndex]
                spec.capacitiesSent[fillTypeIndex] = spec.capacities[fillTypeIndex]
                self:raiseDirtyFlags(spec.dirtyFlag)
            end
        end
    end
end

```

### getConditionInfos

**Description**

**Definition**

> getConditionInfos()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryPallets:getConditionInfos(superFunc)
    local infos = superFunc( self )

    local spec = self.spec_husbandryPallets

    for _, fillTypeIndex in ipairs(spec.activeFillTypes) do
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        if fillType ~ = nil then
            local info = { }
            local fillLevel = spec.fillLevels[fillTypeIndex]
            local capacity = spec.capacities[fillTypeIndex]
            info.title = fillType.title
            info.value = fillLevel

            local ratio = 0
            if capacity > 0 then
                ratio = fillLevel / capacity
            end
            info.ratio = math.clamp(ratio, 0 , 1 )
            info.invertedBar = true
            info.customUnitText = spec.fillTypeUnit

            table.insert(infos, info)
        end
    end

    return infos
end

```

### getPalletCallback

**Description**

**Definition**

> getPalletCallback()

**Arguments**

| any | pallet        |
|-----|---------------|
| any | result        |
| any | fillTypeIndex |

**Code**

```lua
function PlaceableHusbandryPallets:getPalletCallback(pallet, result, fillTypeIndex)
    local spec = self.spec_husbandryPallets
    spec.numSpawnsPending = math.max(spec.numSpawnsPending - 1 , 0 )
    spec.currentPallets[fillTypeIndex] = pallet

    if pallet ~ = nil then
        if spec.palletLimitReached then
            spec.palletLimitReached = false
            self:raiseDirtyFlags(spec.dirtyFlag)
        end

        if result = = PalletSpawner.RESULT_SUCCESS then
            pallet:emptyAllFillUnits( true )
        end

        spec.pallets[pallet] = true
        local fillUnitIndex = pallet.spec_pallet.fillUnitIndex
        local pendingLiters = spec.pendingLiters[fillTypeIndex]
        local delta = pallet:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, pendingLiters, fillTypeIndex, ToolType.UNDEFINED)
        if delta > 0 then
            spec.pendingLiters[fillTypeIndex] = math.max(spec.pendingLiters[fillTypeIndex] - delta, 0 )

            if spec.pendingLiters[fillTypeIndex] > 5 then
                self:updatePallets()
            end
        end
    elseif result = = PalletSpawner.RESULT_NO_SPACE then
            self:showSpawnerBlockedWarning(fillTypeIndex)
        elseif result = = PalletSpawner.PALLET_LIMITED_REACHED then
                if not spec.palletLimitReached then
                    spec.palletLimitReached = true
                    self:raiseDirtyFlags(spec.dirtyFlag)
                end
            end

            self:updatePalletInfo()
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
function PlaceableHusbandryPallets:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_husbandryPallets

    for _, pendingKey in xmlFile:iterator(key .. ".pendingLiters" ) do
        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(xmlFile:getValue(pendingKey .. "#fillType" ))
        if fillTypeIndex ~ = nil then
            spec.pendingLiters[fillTypeIndex] = xmlFile:getValue(pendingKey .. "#liters" ) or 0
        end
    end

    self:updatePalletInfo()
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHusbandryPallets:onDelete()
    local spec = self.spec_husbandryPallets

    if spec.palletSpawner ~ = nil then
        for _, info in ipairs(spec.palletSpawner) do
            info.palletSpawner:delete()

            if info.palletTriggers ~ = nil then
                for _, trigger in ipairs(info.palletTriggers) do
                    if trigger.added then
                        removeTrigger(trigger.node)
                    end
                end
            end
        end
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryPallets:onFinalizePlacement()
    local spec = self.spec_husbandryPallets

    if spec.palletSpawner ~ = nil then
        for _, info in ipairs(spec.palletSpawner) do
            if info.palletTriggers ~ = nil then
                for _, trigger in ipairs(info.palletTriggers) do
                    addTrigger(trigger.node, "onPalletTriggerCallback" , self )
                    trigger.added = true
                end
            end
        end
    end
end

```

### onHusbandryAnimalsUpdate

**Description**

**Definition**

> onHusbandryAnimalsUpdate()

**Arguments**

| any | clusters |
|-----|----------|

**Code**

```lua
function PlaceableHusbandryPallets:onHusbandryAnimalsUpdate(clusters)
    local spec = self.spec_husbandryPallets

    for fillTypeIndex, _ in pairs(spec.litersPerHour) do
        spec.litersPerHour[fillTypeIndex] = 0
    end

    spec.activeFillTypes = { }

    for _, cluster in ipairs(clusters) do
        local subType = g_currentMission.animalSystem:getSubTypeByIndex(cluster.subTypeIndex)
        if subType ~ = nil then
            local pallets = subType.output.pallets
            if pallets ~ = nil then
                local age = cluster:getAge()
                local litersPerAnimals = pallets.curve:get(age)
                local litersPerDay = litersPerAnimals * cluster:getNumAnimals()

                spec.litersPerHour[pallets.fillType] = spec.litersPerHour[pallets.fillType] + (litersPerDay / 24 )

                table.addElement(spec.activeFillTypes, pallets.fillType)
            end
        end
    end
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableHusbandryPallets:onLoad(savegame)
    local spec = self.spec_husbandryPallets

    spec.fillTypeIndexToPalletSpawner = { }
    spec.palletSpawner = { }
    spec.fillTypes = { }
    spec.litersPerHour = { }
    spec.currentPallets = { }
    spec.maxNumPallets = { }
    spec.numPalletInfoUpdateRunning = 0
    spec.numSpawnsPending = 0
    spec.pendingLiters = { }
    spec.capacities = { }
    spec.capacitiesPending = { }
    spec.capacitiesSent = { }
    spec.maxCapacitiesPending = { }
    spec.fillLevels = { }
    spec.fillLevelsPending = { }
    spec.fillLevelsSent = { }
    spec.pallets = { }
    spec.activeFillTypes = { }

    for _, key in self.xmlFile:iterator( "placeable.husbandry.pallets.palletSpawner" ) do
        local fillTypes = g_fillTypeManager:loadCombinedFillTypesFromConfig( self.xmlFile, key)
        if #fillTypes > 0 then
            local maxNumPallets = self.xmlFile:getValue(key .. "#maxNumPallets" , 1 )

            local palletSpawner = PalletSpawner.new( self.baseDirectory)
            palletSpawner:load( self.components, self.xmlFile, key, self.customEnvironment, self.i3dMappings)

            for _, fillTypeIndex in ipairs(fillTypes) do
                if spec.fillTypeIndexToPalletSpawner[fillTypeIndex] = = nil then
                    spec.fillTypeIndexToPalletSpawner[fillTypeIndex] = palletSpawner
                    table.insert(spec.fillTypes, fillTypeIndex)
                    spec.litersPerHour[fillTypeIndex] = 0
                    spec.maxNumPallets[fillTypeIndex] = maxNumPallets
                    spec.capacities[fillTypeIndex] = 0
                    spec.capacitiesPending[fillTypeIndex] = 0
                    spec.capacitiesSent[fillTypeIndex] = 0
                    spec.maxCapacitiesPending[fillTypeIndex] = 0
                    spec.fillLevels[fillTypeIndex] = 0
                    spec.fillLevelsPending[fillTypeIndex] = 0
                    spec.fillLevelsSent[fillTypeIndex] = 0
                    spec.pendingLiters[fillTypeIndex] = 0
                else
                        Logging.xmlWarning( self.xmlFile, "There is already a palletSpawner defined for fillType '%s'" , g_fillTypeManager:getFillTypeNameByIndex(fillTypeIndex))
                        end
                    end

                    local palletTriggers
                    if self.isServer then
                        palletTriggers = { }
                        for _, triggerKey in self.xmlFile:iterator(key .. ".palletTrigger" ) do
                            local node = self.xmlFile:getValue(triggerKey .. "#node" , nil , self.components, self.i3dMappings)
                            if node ~ = nil then
                                if not CollisionFlag.getHasMaskFlagSet(node, CollisionFlag.VEHICLE) then -- check if proper bit for pallets is set
                                    Logging.xmlWarning( self.xmlFile, "Pallet trigger %q at %q does not have 'VEHICLE' bit set in its mask, ignoring" , I3DUtil.getNodePath(node, self.rootNode), triggerKey)
                                    continue
                                end
                                table.insert(palletTriggers, { node = node, added = false } )
                            end
                        end
                    end

                    local info = {
                    palletSpawner = palletSpawner,
                    maxNumPallets = maxNumPallets,
                    palletTriggers = palletTriggers
                    }
                    table.insert(spec.palletSpawner, info)
                end
            end

            spec.palletLimitReached = false
            spec.infoHudTooManyPallets = { title = g_i18n:getText( "infohud_tooManyPallets" ), accentuate = true }
            spec.dirtyFlag = self:getNextDirtyFlag()

            local animalTypeIndex = self:getAnimalTypeIndex()
            local animalType = g_currentMission.animalSystem:getTypeByIndex(animalTypeIndex)
            if animalType ~ = nil then
                for _, subTypeIndex in ipairs(animalType.subTypes) do
                    local subType = g_currentMission.animalSystem:getSubTypeByIndex(subTypeIndex)
                    if subType.output ~ = nil then
                        local pallets = subType.output.pallets
                        if pallets ~ = nil then
                            if spec.litersPerHour[pallets.fillType] = = nil then
                                Logging.xmlWarning( self.xmlFile, "Husbandry does not support pallet filltype '%s'" , g_fillTypeManager:getFillTypeNameByIndex(pallets.fillType))
                            end
                        end
                    end
                end
            end
        end

```

### onPalletTriggerCallback

**Description**

**Definition**

> onPalletTriggerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function PlaceableHusbandryPallets:onPalletTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onLeave then
        local spec = self.spec_husbandryPallets
        local object = g_currentMission:getNodeObject(otherId)
        if object ~ = nil then
            for fillTypeIndex, pallet in pairs(spec.currentPallets) do
                if object = = pallet then
                    spec.currentPallets[fillTypeIndex] = nil
                end
            end

            spec.pallets[object] = nil
            self:updatePalletInfo()
        end
    end
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
function PlaceableHusbandryPallets:onReadStream(streamId, connection)
    local spec = self.spec_husbandryPallets
    for _, fillTypeIndex in ipairs(spec.fillTypes) do
        spec.fillLevelsSent[fillTypeIndex] = streamReadFloat32(streamId)
        spec.capacitiesSent[fillTypeIndex] = streamReadFloat32(streamId)
    end

    spec.palletLimitReached = streamReadBool(streamId)
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function PlaceableHusbandryPallets:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spec = self.spec_husbandryPallets
            for _, fillTypeIndex in ipairs(spec.fillTypes) do
                spec.fillLevelsSent[fillTypeIndex] = streamReadFloat32(streamId)
                spec.capacitiesSent[fillTypeIndex] = streamReadFloat32(streamId)
            end

            spec.palletLimitReached = streamReadBool(streamId)
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
function PlaceableHusbandryPallets:onWriteStream(streamId, connection)
    local spec = self.spec_husbandryPallets

    for _, fillTypeIndex in ipairs(spec.fillTypes) do
        streamWriteFloat32(streamId, spec.fillLevelsSent[fillTypeIndex])
        streamWriteFloat32(streamId, spec.capacitiesSent[fillTypeIndex])
    end

    streamWriteBool(streamId, spec.palletLimitReached)
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function PlaceableHusbandryPallets:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_husbandryPallets
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            for _, fillTypeIndex in ipairs(spec.fillTypes) do
                streamWriteFloat32(streamId, spec.fillLevelsSent[fillTypeIndex])
                streamWriteFloat32(streamId, spec.capacitiesSent[fillTypeIndex])
            end

            streamWriteBool(streamId, spec.palletLimitReached)
        end
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
function PlaceableHusbandryPallets.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableHusbandryAnimals , specializations)
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
function PlaceableHusbandryPallets.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableHusbandryPallets )
    SpecializationUtil.registerEventListener(placeableType, "onHusbandryAnimalsUpdate" , PlaceableHusbandryPallets )
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
function PlaceableHusbandryPallets.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onPalletTriggerCallback" , PlaceableHusbandryPallets.onPalletTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "getAllPalletsCallback" , PlaceableHusbandryPallets.getAllPalletsCallback)
    SpecializationUtil.registerFunction(placeableType, "updatePallets" , PlaceableHusbandryPallets.updatePallets)
    SpecializationUtil.registerFunction(placeableType, "getPalletCallback" , PlaceableHusbandryPallets.getPalletCallback)
    SpecializationUtil.registerFunction(placeableType, "showSpawnerBlockedWarning" , PlaceableHusbandryPallets.showSpawnerBlockedWarning)
    SpecializationUtil.registerFunction(placeableType, "showPalletBlockedWarning" , PlaceableHusbandryPallets.showPalletBlockedWarning)
    SpecializationUtil.registerFunction(placeableType, "updatePalletInfo" , PlaceableHusbandryPallets.updatePalletInfo)
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
function PlaceableHusbandryPallets.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getConditionInfos" , PlaceableHusbandryPallets.getConditionInfos)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateOutput" , PlaceableHusbandryPallets.updateOutput)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableHusbandryPallets.updateInfo)
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
function PlaceableHusbandryPallets.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    schema:register(XMLValueType.STRING, basePath .. ".pendingLiters(?)#fillType" , "Name of the filltype" )
    schema:register(XMLValueType.FLOAT, basePath .. ".pendingLiters(?)#liters" , "Pending liters" )
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
function PlaceableHusbandryPallets.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.pallets.palletSpawner(?)"
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".palletTrigger(?)#node" , "A pallet trigger" )
    FillTypeManager.registerConfigXMLFilltypes(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#unitText" , "Pallet fill type unit" )
    schema:register(XMLValueType.INT, basePath .. "#maxNumPallets" , "Maximum number of pallets" )
    PalletSpawner.registerXMLPaths(schema, basePath)
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
function PlaceableHusbandryPallets:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_husbandryPallets
    local index = 0
    for fillTypeIndex, pendingLiters in pairs(spec.pendingLiters) do
        if pendingLiters > 0 then
            local pendingKey = string.format( "%s.pendingLiters(%d)" , key, index)
            xmlFile:setValue(pendingKey .. "#fillType" , g_fillTypeManager:getFillTypeNameByIndex(fillTypeIndex))
            xmlFile:setValue(pendingKey .. "#liters" , pendingLiters)
            index = index + 1
        end
    end
end

```

### showPalletBlockedWarning

**Description**

**Definition**

> showPalletBlockedWarning()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function PlaceableHusbandryPallets:showPalletBlockedWarning(fillTypeIndex)
    if self.isClient and g_currentMission:getFarmId() = = self:getOwnerFarmId() then
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        if fillType ~ = nil then
            local text = string.format(g_i18n:getText( "ingameNotification_palletSpawnerBlocked" ), fillType.title, self:getName())
            g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, text)
        end
    end
end

```

### showSpawnerBlockedWarning

**Description**

**Definition**

> showSpawnerBlockedWarning()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function PlaceableHusbandryPallets:showSpawnerBlockedWarning(fillTypeIndex)
    local spec = self.spec_husbandryPallets
    if not spec.showedWarning then
        if self.isServer then
            g_currentMission:broadcastEventToFarm( AnimalHusbandryNoMorePalletSpaceEvent.new( self , fillTypeIndex), self:getOwnerFarmId(), false )
        end

        self:showPalletBlockedWarning(fillTypeIndex)

        spec.showedWarning = true
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
function PlaceableHusbandryPallets:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)
    local spec = self.spec_husbandryPallets

    if spec.palletLimitReached then
        table.insert(infoTable, spec.infoHudTooManyPallets)
    end
end

```

### updateOutput

**Description**

**Definition**

> updateOutput()

**Arguments**

| any | superFunc              |
|-----|------------------------|
| any | foodFactor             |
| any | productionFactor       |
| any | globalProductionFactor |

**Code**

```lua
function PlaceableHusbandryPallets:updateOutput(superFunc, foodFactor, productionFactor, globalProductionFactor)
    superFunc( self , foodFactor, productionFactor, globalProductionFactor)

    local spec = self.spec_husbandryPallets
    spec.showedWarning = false

    if self.isServer then
        for _, fillTypeIndex in ipairs(spec.fillTypes) do
            local litersPerHour = spec.litersPerHour[fillTypeIndex]
            if litersPerHour > 0 then
                local delta = productionFactor * globalProductionFactor * litersPerHour * g_currentMission.environment.timeAdjustment
                spec.pendingLiters[fillTypeIndex] = spec.pendingLiters[fillTypeIndex] + delta
                self:updatePallets()
            end
        end
    end
end

```

### updatePalletInfo

**Description**

**Definition**

> updatePalletInfo()

**Code**

```lua
function PlaceableHusbandryPallets:updatePalletInfo()
    if self.isServer then
        local spec = self.spec_husbandryPallets
        if spec.numPalletInfoUpdateRunning = = 0 then
            for fillTypeIndex in pairs(spec.capacitiesPending) do
                spec.fillLevelsPending[fillTypeIndex] = 0
                spec.capacitiesPending[fillTypeIndex] = 0
                spec.maxCapacitiesPending[fillTypeIndex] = 0
            end

            for fillTypeIndex, palletSpawner in pairs(spec.fillTypeIndexToPalletSpawner) do
                spec.numPalletInfoUpdateRunning = spec.numPalletInfoUpdateRunning + 1
                palletSpawner:getAllPallets(fillTypeIndex, self.getAllPalletsCallback, self )
            end
        end
    end
end

```

### updatePallets

**Description**

**Definition**

> updatePallets()

**Code**

```lua
function PlaceableHusbandryPallets:updatePallets()
    if self.isServer then
        local spec = self.spec_husbandryPallets
        if spec.numSpawnsPending = = 0 then
            for fillTypeIndex, pendingLiters in pairs(spec.pendingLiters) do
                if pendingLiters > 5 then
                    local palletSpawner = spec.fillTypeIndexToPalletSpawner[fillTypeIndex]
                    spec.numSpawnsPending = spec.numSpawnsPending + 1
                    palletSpawner:getOrSpawnPallet( self:getOwnerFarmId(), fillTypeIndex, self.getPalletCallback, self )
                end
            end
        end
    end
end

```