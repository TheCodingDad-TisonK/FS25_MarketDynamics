## VehicleSystem

**Description**

> Stores all vehicles of the savegame and handles the loading of them

**Functions**

- [addEnterableVehicle](#addenterablevehicle)
- [addInteractiveVehicle](#addinteractivevehicle)
- [addPendingVehicleLoad](#addpendingvehicleload)
- [addVehicle](#addvehicle)
- [canStartMission](#canstartmission)
- [consoleCommandAddDamageAmount](#consolecommandadddamageamount)
- [consoleCommandAddDirtAmount](#consolecommandadddirtamount)
- [consoleCommandAddPallet](#consolecommandaddpallet)
- [consoleCommandAddWearAmount](#consolecommandaddwearamount)
- [consoleCommandAddWetnessAmount](#consolecommandaddwetnessamount)
- [consoleCommandExportVehicleSets](#consolecommandexportvehiclesets)
- [consoleCommandFillUnitAdd](#consolecommandfillunitadd)
- [consoleCommandLoadAllVehicles](#consolecommandloadallvehicles)
- [consoleCommandLoadAllVehiclesNext](#consolecommandloadallvehiclesnext)
- [consoleCommandReloadVehicle](#consolecommandreloadvehicle)
- [consoleCommandSetFuel](#consolecommandsetfuel)
- [consoleCommandSetMotorTemperature](#consolecommandsetmotortemperature)
- [consoleCommandSetOperatingTime](#consolecommandsetoperatingtime)
- [consoleCommandShowVehicleDistance](#consolecommandshowvehicledistance)
- [consoleCommandVehicleRemoveAll](#consolecommandvehicleremoveall)
- [consoleCommandVehicleToggleRandomFail](#consolecommandvehicletogglerandomfail)
- [delete](#delete)
- [deleteAll](#deleteall)
- [draw](#draw)
- [getNextEnterableVehicle](#getnextenterablevehicle)
- [getVehicleByNodeId](#getvehiclebynodeid)
- [getVehicleByUniqueId](#getvehiclebyuniqueid)
- [load](#load)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadVehicleFinished](#loadvehiclefinished)
- [loadVehicleFromXML](#loadvehiclefromxml)
- [new](#new)
- [onVehicleBuyEvent](#onvehiclebuyevent)
- [registerInputAttacherJoint](#registerinputattacherjoint)
- [removeEnterableVehicle](#removeenterablevehicle)
- [removeInputAttacherJoint](#removeinputattacherjoint)
- [removeInteractiveVehicle](#removeinteractivevehicle)
- [removePendingVehicleLoad](#removependingvehicleload)
- [removeVehicle](#removevehicle)
- [save](#save)
- [saveToXML](#savetoxml)
- [saveVehicleToXML](#savevehicletoxml)
- [setEnteredVehicle](#setenteredvehicle)
- [update](#update)
- [updateInputAttacherJoint](#updateinputattacherjoint)
- [updatePendingSavegameLoadings](#updatependingsavegameloadings)

### addEnterableVehicle

**Description**

**Definition**

> addEnterableVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:addEnterableVehicle(vehicle)
    table.addElement( self.enterables, vehicle)
end

```

### addInteractiveVehicle

**Description**

**Definition**

> addInteractiveVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:addInteractiveVehicle(vehicle)
    self.interactiveVehicles[vehicle] = vehicle
end

```

### addPendingVehicleLoad

**Description**

**Definition**

> addPendingVehicleLoad()

**Arguments**

| any | vehicleLoadingData |
|-----|--------------------|

**Code**

```lua
function VehicleSystem:addPendingVehicleLoad(vehicleLoadingData)
    table.addElement( self.pendingVehicleLoadingData, vehicleLoadingData)
end

```

### addVehicle

**Description**

**Definition**

> addVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:addVehicle(vehicle)
    if vehicle = = nil or vehicle:isa( Vehicle ) = = nil then
        Logging.error( "Given object is not a vehicle" )
        return false
    end

    -- Ensure the vehicle has not already been added.
    if vehicle:getUniqueId() ~ = nil and self.vehicleByUniqueId[vehicle:getUniqueId()] ~ = nil then
        Logging.warning( "Tried to add existing vehicle with unique id of %s! Existing: %s, new: %s" , vehicle:getUniqueId(), tostring( self.vehicleByUniqueId[vehicle:getUniqueId()]), tostring(vehicle))
        return false
    end

    -- If the vehicle has no unique id, give it one.
    if vehicle:getUniqueId() = = nil then
        vehicle:setUniqueId( Utils.getUniqueId(vehicle, self.vehicleByUniqueId, VehicleSystem.UNIQUE_ID_PREFIX))
    end

    table.addElement( self.vehicles, vehicle)
    self.vehicleByUniqueId[vehicle:getUniqueId()] = vehicle

    if vehicle.getIsWet ~ = nil then
        if vehicle:getIsWet() then
            self.wetVehicles[vehicle] = vehicle
        end
    end

    g_messageCenter:publish(MessageType.VEHICLE_ADDED)

    return true
end

```

### canStartMission

**Description**

**Definition**

> canStartMission()

**Code**

```lua
function VehicleSystem:canStartMission()
    for i = 1 , # self.vehicles do
        if not self.vehicles[i]:getIsSynchronized() then
            return false
        end
    end

    if # self.pendingVehicleLoadingData > 0 then
        return false
    end

    return true
end

```

### consoleCommandAddDamageAmount

**Description**

**Definition**

> consoleCommandAddDamageAmount()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function VehicleSystem:consoleCommandAddDamageAmount(amount)
    if self.mission:getIsServer() then
        amount = tonumber(amount) or 0
        local controlledVehicle = g_localPlayer:getCurrentVehicle()
        if controlledVehicle ~ = nil then
            for _, vehicle in pairs(controlledVehicle.rootVehicle.childVehicles) do
                if vehicle.addDamageAmount ~ = nil then
                    vehicle:addDamageAmount(amount)
                end
            end

            return string.format( "Added damage to vehicles(Amount: %.2f)" , amount)
        else
                return "Error:Enter a vehicle first!"
            end
        end

        return "Error:Not available on clients"
    end

```

### consoleCommandAddDirtAmount

**Description**

**Definition**

> consoleCommandAddDirtAmount()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function VehicleSystem:consoleCommandAddDirtAmount(amount)
    if self.mission:getIsServer() then
        amount = tonumber(amount) or 0
        local controlledVehicle = g_localPlayer:getCurrentVehicle()
        if controlledVehicle ~ = nil then
            for _, vehicle in pairs(controlledVehicle.rootVehicle.childVehicles) do
                if vehicle.setDirtAmount ~ = nil then
                    vehicle:setDirtAmount(vehicle:getDirtAmount() + amount)
                end
            end

            return string.format( "Added dirt to vehicles(Amount: %.2f)" , amount)
        else
                return "Error:Enter a vehicle first!"
            end
        end

        return "Error:Not available on clients"
    end

```

### consoleCommandAddPallet

**Description**

**Definition**

> consoleCommandAddPallet()

**Arguments**

| any | palletFillTypeName |
|-----|--------------------|
| any | amount             |
| any | worldX             |
| any | worldZ             |

**Code**

```lua
function VehicleSystem:consoleCommandAddPallet(palletFillTypeName, amount, worldX, worldZ)
    local pallets = { }
    for _, fillType in pairs(g_fillTypeManager:getFillTypes()) do
        if fillType.palletFilename ~ = nil then
            pallets[fillType.name] = fillType.palletFilename
        end
    end

    if palletFillTypeName = = nil then
        Logging.error( "Error:no fillType given" )
        return
    end

    local localPlayer = g_localPlayer
    if string.lower(palletFillTypeName) = = "all" then
        local x, _, z = localPlayer:getPosition()
        local dirX, dirZ = localPlayer:getCurrentFacingDirection()
        for _, fillType in pairs(g_fillTypeManager:getFillTypes()) do
            if fillType.palletFilename ~ = nil then
                x, z = x + dirX * 3 , z + dirZ * 3
                self:consoleCommandAddPallet(fillType.name, amount, x, z)
            end
        end

        return
    end

    palletFillTypeName = string.upper(palletFillTypeName)
    local palletFillType = g_fillTypeManager:getFillTypeIndexByName(palletFillTypeName)

    if palletFillType = = nil then
        Logging.error( "Error:Invalid pallet fillType '%s'" , palletFillTypeName)
        local bestMatch = Utils.getClosestMatchingString(palletFillTypeName, table.toList(pallets))
        if bestMatch ~ = nil then
            print( string.format( "Did you mean %q?" , bestMatch))
        end
        return string.format( "Valid types are %s" , table.concatKeys(pallets, ", " ))
    end

    local xmlFilename = pallets[palletFillTypeName]
    if xmlFilename = = nil then
        Logging.error( "Error:no pallet for given fillType '%s'" , palletFillTypeName)
            return
        end

        local x, y, z = localPlayer:getPosition()
        local dirX, dirZ = localPlayer:getCurrentFacingDirection()

        x,z = x + dirX * 4 , z + dirZ * 4

        x = tonumber(worldX) or x
        z = tonumber(worldZ) or z

        local yOffset = 0
        if Platform.gameplay.hasDynamicPallets then
            yOffset = 0.2
        end

        local collisionMask = CollisionFlag.STATIC_OBJECT + CollisionFlag.TERRAIN + CollisionFlag.TERRAIN_DELTA + CollisionFlag.DYNAMIC_OBJECT + CollisionFlag.VEHICLE
        local objectId, _, hitY, _, _ = RaycastUtil.raycastClosest(x, y + 25 , z, 0 , - 1 , 0 , 40 , collisionMask)
        if objectId ~ = nil then
            y = hitY
        else
                y = getTerrainHeightAtWorldPos(g_terrainNode, x, y, z)
            end

            local function asyncCallbackFunction(_, vehicles, vehicleLoadState, arguments)
                if vehicleLoadState = = VehicleLoadingState.OK then
                    local vehicle = vehicles[ 1 ]

                    local fillUnits = vehicle:getFillUnits()
                    local amountToAdd = tonumber(amount) or math.huge
                    local addedAmount = 0
                    for _, fillUnit in ipairs(fillUnits) do
                        if vehicle:getFillUnitSupportsFillType(fillUnit.fillUnitIndex, palletFillType) then
                            addedAmount = addedAmount + vehicle:addFillUnitFillLevel( 1 , fillUnit.fillUnitIndex, amountToAdd, palletFillType, ToolType.UNDEFINED, nil )
                            amountToAdd = amountToAdd - addedAmount
                            if amountToAdd < = 0 then
                                break
                            end
                        end
                    end

                    print( string.format( "Loaded pallet with %dl of %s" , addedAmount, palletFillTypeName))
                    return
                end

                printError( "Error:Failed to load pallet" )
            end

            local farmId = self.mission:getFarmId()
            farmId = ((farmId ~ = FarmManager.SPECTATOR_FARM_ID) and farmId) or 1

            local data = VehicleLoadingData.new()
            data:setFilename(xmlFilename)
            data:setPosition(x, y + yOffset, z)
            data:setPropertyState(VehiclePropertyState.OWNED)
            data:setOwnerFarmId(farmId)

            data:load(asyncCallbackFunction)

            return
        end

```

### consoleCommandAddWearAmount

**Description**

**Definition**

> consoleCommandAddWearAmount()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function VehicleSystem:consoleCommandAddWearAmount(amount)
    if self.mission:getIsServer() then
        amount = tonumber(amount) or 0
        local controlledVehicle = g_localPlayer:getCurrentVehicle()
        if controlledVehicle ~ = nil then
            for _, vehicle in pairs(controlledVehicle.rootVehicle.childVehicles) do
                if vehicle.addWearAmount ~ = nil then
                    vehicle:addWearAmount(amount)
                end
            end

            return string.format( "Added wear to vehicles(Amount: %.2f)" , amount)
        else
                return "Error:Enter a vehicle first!"
            end
        end

        return "Error:Not available on clients"
    end

```

### consoleCommandAddWetnessAmount

**Description**

**Definition**

> consoleCommandAddWetnessAmount()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function VehicleSystem:consoleCommandAddWetnessAmount(amount)
    if self.mission:getIsServer() then
        amount = tonumber(amount) or 0
        local controlledVehicle = g_localPlayer:getCurrentVehicle()
        if controlledVehicle ~ = nil then
            for _, vehicle in pairs(controlledVehicle.rootVehicle.childVehicles) do
                if vehicle.addWetnessAmount ~ = nil then
                    vehicle:addWetnessAmount(amount)
                end
            end

            return string.format( "Added wetness to vehicles(Amount: %.2f)" , amount)
        else
                return "Error:Enter a vehicle first!"
            end
        end

        return "Error:Not available on clients"
    end

```

### consoleCommandExportVehicleSets

**Description**

**Definition**

> consoleCommandExportVehicleSets()

**Code**

```lua
function VehicleSystem:consoleCommandExportVehicleSets()
    local rootVehicles = { }
    for _, v in ipairs( self.vehicles) do
        local rootVehicle = v:getRootVehicle()
        if rootVehicle ~ = nil then
            rootVehicles[rootVehicle] = rootVehicle
        end
    end

    local function addVehicle(xmlFile, key, vehicle, baseVehicle)
        setXMLString(xmlFile, key .. ".xmlFilename" , vehicle.configFileName)
        setXMLFloat(xmlFile, key .. ".rotY" , 0 )
        setXMLFloat(xmlFile, key .. ".captainFoldingState" , 0 )

        local offsetX, offsetY, offsetZ = localToLocal(vehicle.rootNode, baseVehicle.rootNode, 0 , 0 , 0 )
        setXMLString(xmlFile, key .. ".offset" , string.format( "%.2f %.2f %.2f" , offsetX, offsetY, offsetZ))

        local configIndex = 0
        for configName, configId in pairs(vehicle.configurations) do
            local saveId = ConfigurationUtil.getSaveIdByConfigId(vehicle.configFileName, configName, configId)
            if saveId ~ = nil then
                local configKey = string.format( "%s.configurations.configuration(%d)" , key, configIndex)
                setXMLString(xmlFile, configKey .. "#name" , configName)
                setXMLString(xmlFile, configKey .. "#id" , saveId)
                configIndex = configIndex + 1
            end
        end
    end

    setFileLogPrefixTimestamp( false )

    local vehicleSetIndex = 0
    for _, vehicle in pairs(rootVehicles) do
        local xmlFile = loadXMLFileFromMemory( "vehicleSets" , "<vehicleSets></vehicleSets>" )
        local key = string.format( "vehicleSets.vehicleSet(%d)" , vehicleSetIndex)
        local children = vehicle:getChildVehicles()
        local vehicleIndex = 0
        local childToIndex = { }
        for k = #children, 1 , - 1 do
            local childVehicle = children[k]
            local vehicleKey = string.format( "%s.vehicle(%d)" , key, vehicleIndex)

            addVehicle(xmlFile, vehicleKey, childVehicle, vehicle)
            vehicleIndex = vehicleIndex + 1
            childToIndex[childVehicle] = vehicleIndex
        end

        local attacherIndex = 0
        for k = #children, 1 , - 1 do
            local child = children[k]
            local attacherVehicle = nil
            if child.getAttacherVehicle ~ = nil then
                attacherVehicle = child:getAttacherVehicle()
            end
            if attacherVehicle ~ = nil then
                local attachKey = string.format( "%s.attach(%d)" , key, attacherIndex)

                local rootVehicleIndex = childToIndex[attacherVehicle]
                local attachVehicleIndex = childToIndex[child]
                local implement = attacherVehicle:getImplementByObject(child)
                local inputAttacherJointIndex = child:getActiveInputAttacherJointDescIndex()

                setXMLInt(xmlFile, attachKey .. "#element0" , rootVehicleIndex)
                setXMLInt(xmlFile, attachKey .. "#element1" , attachVehicleIndex)
                setXMLInt(xmlFile, attachKey .. "#attacherJointIndex" , implement.jointDescIndex)
                setXMLInt(xmlFile, attachKey .. "#inputAttacherJointIndex" , inputAttacherJointIndex)

                attacherIndex = attacherIndex + 1
            end
        end

        local xmlString = saveXMLFileToMemory(xmlFile)
        print(xmlString)

        delete(xmlFile)
    end

    setFileLogPrefixTimestamp(g_logFilePrefixTimestamp)
end

```

### consoleCommandFillUnitAdd

**Description**

**Definition**

> consoleCommandFillUnitAdd()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillTypeName  |
| any | amount        |

**Code**

```lua
function VehicleSystem:consoleCommandFillUnitAdd(fillUnitIndex, fillTypeName, amount)
    local usage = "Usage: 'gsFillUnitAdd <fillUnitIndex> <fillTypeName> [amount]'"

    local mission = self.mission
    local player = g_localPlayer
    local controlledVehicle = player:getCurrentVehicle()

    local fillableVehicle
    if controlledVehicle ~ = nil and controlledVehicle.getSelectedObject ~ = nil then
        local selectedObject = controlledVehicle:getSelectedObject()
        if selectedObject ~ = nil and selectedObject.vehicle.addFillUnitFillLevel ~ = nil then
            fillableVehicle = selectedObject.vehicle
        end
    end
    if fillableVehicle = = nil then
        if controlledVehicle ~ = nil and controlledVehicle.addFillUnitFillLevel ~ = nil then
            fillableVehicle = controlledVehicle
        end
    end
    if fillableVehicle = = nil then
        local targetNode = player.targeter:getClosestTargetedNodeFromType( PlayerInputComponent )
        local object = mission:getNodeObject(targetNode)
        if object ~ = nil and object:isa( Vehicle ) and object.addFillUnitFillLevel ~ = nil then
            fillableVehicle = object
        end
    end

    local farmId = mission:getFarmId()

    if fillableVehicle = = nil or fillableVehicle.getFillUnitSupportedToolTypes = = nil then
        return "Error:could not find a fillable vehicle!"
    end

    local function getSupportedFilltypesString()
        local fillUnits = { }

        for fillUnitIdx, fillTypesIndices in pairs(fillableVehicle:debugGetSupportedFillTypesPerFillUnit()) do
            table.insert(fillUnits, string.format( "FillUnit %d - FillTypes: %s" , fillUnitIdx, table.concat(g_fillTypeManager:getFillTypeNamesByIndices(fillTypesIndices), " " )))
        end
        return "Available FillUnits and supported FillTypes:\n" .. table.concat(fillUnits, "\n" )
    end

    if fillUnitIndex = = nil or fillTypeName = = nil then
        return "Error:Missing parameters.\n" .. usage
    end
    if not mission:getIsServer() then
        return "Error: 'gsFillUnitAdd' can only be called on server side!"
    end

    fillUnitIndex = tonumber(fillUnitIndex)
    local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
    amount = tonumber(amount)

    if fillUnitIndex = = nil then
        return "Error:Missing fillUnitIndex!\n" .. usage
    end
    if not fillableVehicle:getFillUnitExists(fillUnitIndex) then
        Logging.error( "FillUnit '%d' in '%s' does not exist!\n%s" , fillUnitIndex, fillableVehicle:getName(), getSupportedFilltypesString())
        return
    end
    if fillTypeIndex = = nil then
        Logging.error( "Unknown fillType '%s'!\n%s" , fillTypeName, getSupportedFilltypesString())
        return
    end

    local capacity = fillableVehicle:getFillUnitCapacity(fillUnitIndex)
    if capacity = = 0 then
        Logging.error( "Selected Vehicle '%s' cannot be filled.Capacity is 0!" , fillableVehicle:getName())
        return
    end

    local fillUnitSupportsFillType = fillableVehicle:getFillUnitSupportsFillType(fillUnitIndex, fillTypeIndex)
    if not fillUnitSupportsFillType then
        Logging.error( "fillUnit '%d' in '%s' does not support fillType '%s'\n%s" , fillUnitIndex, fillableVehicle:getName(), fillTypeName, getSupportedFilltypesString())
        return
    end

    amount = amount or capacity
    if amount = = 0 then
        amount = - capacity
    end
    fillableVehicle:addFillUnitFillLevel(farmId, fillUnitIndex, amount, fillTypeIndex, ToolType.UNDEFINED)

    local fillLevel = fillableVehicle:getFillUnitFillLevel(fillUnitIndex)
    fillTypeIndex = fillableVehicle:getFillUnitFillType(fillUnitIndex)
    fillTypeName = Utils.getNoNil(g_fillTypeManager:getFillTypeNameByIndex(fillTypeIndex), "unknown" )

    return string.format( "new fillLevel: %.1f, fillType: %d(%s)" , fillLevel, fillTypeIndex, fillTypeName)
end

```

### consoleCommandLoadAllVehicles

**Description**

**Definition**

> consoleCommandLoadAllVehicles()

**Arguments**

| any | loadConfigs |
|-----|-------------|
| any | modsOnly    |
| any | palletsOnly |
| any | verbose     |

**Code**

```lua
function VehicleSystem:consoleCommandLoadAllVehicles(loadConfigs, modsOnly, palletsOnly, verbose)
    if not self.mission:getIsServer() and self.mission.missionDynamicInfo.isMultiplayer then
        return "Error:Command not allowed in multiplayer"
    end

    if self.debugVehiclesToBeLoaded ~ = nil then
        return "Error:Loading task is currently running!"
    end

    loadConfigs = string.lower(loadConfigs or "false" ) = = "true"
    modsOnly = string.lower(modsOnly or "false" ) = = "true"
    palletsOnly = string.lower(palletsOnly or "false" ) = = "true"
    verbose = string.lower(verbose or "false" ) = = "true"
    self.debugVehiclesToBeLoaded = { }
    self.debugVehiclesLoaded = { }
    self.debugVehiclesTotal = 0
    self.debugVehiclesToBeLoadedStartTime = g_ time
    I3DManager.VERBOSE_LOADING = verbose

    if not palletsOnly then
        for _, storeItem in pairs(g_storeManager:getItems()) do
            if StoreItemUtil.getIsVehicle(storeItem) and( not modsOnly or(storeItem.isMod or storeItem.dlcTitle ~ = "" )) then
                local defaultConfigs = { }
                if storeItem.defaultConfigurationIds ~ = nil then
                    defaultConfigs = table.clone(storeItem.defaultConfigurationIds)
                end
                if #storeItem.configurationSets > 0 then
                    local defaultSetIndex = 1
                    for i = 1 , #storeItem.configurationSets do
                        if storeItem.configurationSets[i].isDefault then
                            defaultSetIndex = i
                            break
                        end
                    end

                    for name, index in pairs(storeItem.configurationSets[defaultSetIndex].configurations) do
                        defaultConfigs[name] = index
                    end
                end
                table.insert( self.debugVehiclesToBeLoaded, { storeItem = storeItem, configurations = defaultConfigs } )
                self.debugVehiclesTotal = self.debugVehiclesTotal + 1

                if loadConfigs then
                    if storeItem.configurations ~ = nil then
                        for name, configItems in pairs(storeItem.configurations) do
                            if #configItems > 1 then
                                local includedInSet = false
                                for i = 1 , #storeItem.configurationSets do
                                    local configSet = storeItem.configurationSets[i]
                                    if configSet.configurations[name] ~ = nil then
                                        includedInSet = true
                                        break
                                    end
                                end

                                local usedAsDependentConfig = false
                                if not includedInSet then
                                    for _, otherConfigItems in pairs(storeItem.configurations) do
                                        for _, otherConfigItem in ipairs(otherConfigItems) do
                                            if otherConfigItem.dependentConfigurations ~ = nil then
                                                for _, dependentConfig in ipairs(otherConfigItem.dependentConfigurations) do
                                                    if dependentConfig.name = = name then
                                                        usedAsDependentConfig = true
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end

                                if not includedInSet and not usedAsDependentConfig then
                                    for _, configItem in ipairs(configItems) do
                                        if configItem.isSelectable then
                                            if #storeItem.configurationSets > 0 then
                                                -- load the config in all config sets(we need to have at least one configSet set)
                                                for i = 1 , #storeItem.configurationSets do
                                                    local configSet = storeItem.configurationSets[i]
                                                    local configs = table.clone(configSet.configurations)
                                                    configs[name] = configItem.index

                                                    table.insert( self.debugVehiclesToBeLoaded, { storeItem = storeItem, configurations = configs } )
                                                end
                                            else
                                                    -- load just the blank config if we dont have config sets
                                                        local configs = { }
                                                        configs[name] = configItem.index
                                                        table.insert( self.debugVehiclesToBeLoaded, { storeItem = storeItem, configurations = configs } )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            for i = 1 , #storeItem.configurationSets do
                                local configSet = storeItem.configurationSets[i]
                                local configs = { }
                                for name, index in pairs(configSet.configurations) do
                                    configs[name] = index
                                end
                                table.insert( self.debugVehiclesToBeLoaded, { storeItem = storeItem, configurations = configs } )
                            end
                        end
                    end
                end
            else
                    for _, fillType in pairs(g_fillTypeManager:getFillTypes()) do
                        if fillType.palletFilename ~ = nil then
                            local storeItem = g_storeManager:getItemByXMLFilename(fillType.palletFilename)
                            table.insert( self.debugVehiclesToBeLoaded, { storeItem = storeItem, configurations = { } } )
                        end
                    end
                end

                self.debugVehiclesTotalConfigs = # self.debugVehiclesToBeLoaded

                local modStr = (modsOnly and ' mod ') or ''
                if loadConfigs then
                    return print( string.format( "Loading %i %svehicles with all configs .. ." , self.debugVehiclesTotal, modStr))
                else
                        return print( string.format( "Loading %i %svehicles(add first param 'true' to include configs, add second param 'true' to only load mods, add third param 'true' to only load pallets, add fourth param 'verbose' to print i3d loading messages) .. ." , self.debugVehiclesTotal, modStr))
                    end
                end

```

### consoleCommandLoadAllVehiclesNext

**Description**

**Definition**

> consoleCommandLoadAllVehiclesNext()

**Code**

```lua
function VehicleSystem:consoleCommandLoadAllVehiclesNext()
    if self.debugVehiclesLoaded ~ = nil then
        for i = # self.debugVehiclesLoaded, 1 , - 1 do
            local vehicle = self.debugVehiclesLoaded[i]
            vehicle.deleteFrameCounter = vehicle.deleteFrameCounter - 1
            if vehicle.deleteFrameCounter < = 0 then
                vehicle:delete()
                table.remove( self.debugVehiclesLoaded, i)
            end
        end
    end

    if self.debugVehiclesToBeLoaded = = nil then
        return
    end

    if self.debugVehiclesLoadingCount ~ = nil and self.debugVehiclesLoadingCount > 0 then
        return
    end

    if not self.debugVehiclesLoading then
        local vehicleData = table.remove( self.debugVehiclesToBeLoaded, 1 )
        if vehicleData = = nil then
            local totalTime = g_ time - self.debugVehiclesToBeLoadedStartTime
            print( string.format( "Successfully loaded and removed all vehicles in %.1f seconds!" , totalTime / 1000 ))
            self.debugVehiclesToBeLoaded = nil
            self.debugVehiclesLoadingCount = nil

            for _, vehicle in pairs( self.debugVehiclesLoaded) do
                vehicle:delete()
            end
            self.debugVehiclesLoaded = { }

            I3DManager.VERBOSE_LOADING = true
            return
        end

        local configString = "None"
        if next(vehicleData.configurations) ~ = nil then
            configString = ""
            for name, index in pairs(vehicleData.configurations) do
                if configString ~ = "" then
                    configString = configString .. ", "
                end

                configString = configString .. string.format( "%s:%d" , name, index)
            end
        end

        Logging.info( "Loading vehicle %d/%d: %s(Configuration: %s)" , self.debugVehiclesTotalConfigs - # self.debugVehiclesToBeLoaded, self.debugVehiclesTotalConfigs, vehicleData.storeItem.xmlFilename, configString)

        local function asyncCallbackFunction(_, vehicles, vehicleLoadState, arguments)
            self.debugVehiclesLoading = false

            for _, vehicle in pairs(vehicles) do
                vehicle:removeFromPhysics()

                table.insert( self.debugVehiclesLoaded, vehicle)
                vehicle.deleteFrameCounter = 2 -- delete vehicles 2 frames delayed, so they are rendered(so we can see shader issues)
            end
        end

        local data = VehicleLoadingData.new()

        local localPlayer = g_localPlayer
        local x, y, z = localPlayer:getPosition()
        local dirX, dirZ = localPlayer:getCurrentFacingDirection()
        data:setPosition(x + dirX * 10 , y, z + dirZ * 10 )

        data:setStoreItem(vehicleData.storeItem)
        data:setConfigurations(vehicleData.configurations)
        data:setIsRegistered( false )
        data:setIsSaved( false )

        self.debugVehiclesLoading = true
        data:load(asyncCallbackFunction, nil , nil )
    end
end

```

### consoleCommandReloadVehicle

**Description**

**Definition**

> consoleCommandReloadVehicle()

**Arguments**

| any | resetVehicle |
|-----|--------------|
| any | radius       |

**Code**

```lua
function VehicleSystem:consoleCommandReloadVehicle(resetVehicle, radius)
    local usage = "Usage:gsVehicleReload [resetVehicle] [radius]"

    if g_gui.currentGuiName = = "ShopMenu" or g_gui.currentGuiName = = "ShopConfigScreen" then
        return "Error:Reload not supported while in shop!"
        end

        if self.isReloadRunning then
            return "Error:Reloading of vehicles already in progress!"
        end

        if not self.mission:getIsServer() or self.mission.missionDynamicInfo.isMultiplayer then
            return "Error:Reloading only available in SP"
        end

        resetVehicle = Utils.stringToBoolean(resetVehicle)
        radius = tonumber(radius) or 0

        local posX, posY, posZ = g_localPlayer:getPosition()

        -- reload sound and material templates so the new vehicle sounds and materials are based on the newest templates
        g_soundManager:reloadSoundTemplates()

        g_vehicleMaterialManager:loadMaterialTemplates( VehicleMaterialManager.DEFAULT_TEMPLATES_FILENAME)
        g_vehicleMaterialManager:loadMaterialTemplates( VehicleMaterialManager.DEFAULT_BRAND_TEMPLATES_FILENAME)

        local affectedVehicles = { } -- list with vehicle plus all attachments affected by the reload
        local usedVehicles = { }
        local usedModNames = { }

        local function addVehicleToReload(v, list)
            if v.isVehicleSaved then
                v.isReconfigurating = true
                table.insert(list, v)
                usedVehicles[v] = true

                if v ~ = nil and v.getAttachedImplements ~ = nil then
                    local attachedImplements = v:getAttachedImplements()
                    for _, implement in pairs(attachedImplements) do
                        addVehicleToReload(implement.object, list)
                    end
                end
            else
                    v:delete()
                end
            end

            if g_localPlayer:getCurrentVehicle() ~ = nil then
                addVehicleToReload(g_localPlayer:getCurrentVehicle(), affectedVehicles)
            end

            -- within this radius all vehicles are reloaded
            if radius ~ = 0 then
                for _, v in pairs( self.vehicles) do
                    if v ~ = g_localPlayer:getCurrentVehicle() then
                        local vx, vy, vz = getWorldTranslation(v.rootNode)
                        if MathUtil.vector3Length(vx - posX, vy - posY, vz - posZ) < radius then
                            if usedVehicles[v.rootVehicle] = = nil then
                                addVehicleToReload(v.rootVehicle, affectedVehicles)
                            end
                        end
                    end
                end
            end

            if #affectedVehicles = = 0 then
                return "Warning:No vehicle reloaded.Enter a vehicle first or use the command with the radius parameter given, e.g. 'gsVehicleReload false 25'\n" .. usage
            end

            local xmlFile = XMLFile.create( "reloadVehiclesXMLFile" , "" , "vehicles" , Vehicle.xmlSchemaSavegame)
            if xmlFile = = nil then
                return "Error:Unable to create XML for saving vehicles"
                end

                simulatePhysics( false )
                self.isReloadRunning = true

                -- remove the vehicles from the unique id mapping, so we allow registration of the new vehicles
                -- if the registration fails, we readd the vehicles to the mapping
                    for _, vehicle in ipairs(affectedVehicles) do
                        self.vehicleByUniqueId[vehicle:getUniqueId()] = nil
                    end

                    self:saveToXML(affectedVehicles, xmlFile, usedModNames)

                    for _, vehicle in ipairs(affectedVehicles) do
                        vehicle:removeFromPhysics()
                    end

                    local steerableId
                    if g_localPlayer:getCurrentVehicle() ~ = nil then
                        steerableId = g_localPlayer:getCurrentVehicle():getUniqueId()
                    end

                    g_i3DManager:clearEntireSharedI3DFileCache( false )

                    local function asyncCallbackFunction(_, vehicles, vehicleLoadState, arguments)
                        local success = true
                        if vehicleLoadState = = VehicleLoadingState.OK then
                            if #vehicles = = #affectedVehicles then
                                for _, affected_vehicle in pairs(affectedVehicles) do
                                    affected_vehicle:delete()
                                end

                                if steerableId ~ = nil then
                                    for _, vehicle in pairs(vehicles) do
                                        if vehicle:getUniqueId() = = steerableId then
                                            g_localPlayer:requestToEnterVehicle(vehicle)
                                        end
                                    end
                                end
                            else
                                    Logging.error( "Not all vehicles could be reloaded" )
                                    success = false
                                end
                            else
                                    Logging.error( "Failed to load vehicles" )
                                    success = false
                                end

                                if not success then
                                    for _, loadedVehicle in pairs(vehicles) do
                                        loadedVehicle:delete()
                                    end
                                    for _, vehicle in ipairs(affectedVehicles) do
                                        vehicle:addToPhysics()
                                        self.vehicleByUniqueId[vehicle:getUniqueId()] = vehicle
                                    end
                                end

                                xmlFile:delete()

                                self.isReloadRunning = false
                                simulatePhysics( true )

                                if success then
                                    Logging.info( "%d vehicle(s) reloaded" , #affectedVehicles)
                                end
                            end

                            g_asyncTaskManager:addTask( function ()
                                local keepPosition = true
                                self:loadFromXMLFile(xmlFile, asyncCallbackFunction, nil , nil , resetVehicle, keepPosition)
                            end )

                            return
                        end

```

### consoleCommandSetFuel

**Description**

**Definition**

> consoleCommandSetFuel()

**Arguments**

| any | fuelLevel |
|-----|-----------|

**Code**

```lua
function VehicleSystem:consoleCommandSetFuel(fuelLevel)
    if self.mission:getIsServer() then
        if fuelLevel = = nil then
            return "No fuellevel given! Usage:gsVehicleFuelSet <fuelLevel>"
        end
        fuelLevel = Utils.getNoNil( tonumber(fuelLevel), 10000000000 )
        local vehicle = g_localPlayer:getCurrentVehicle()
        if vehicle ~ = nil then
            if vehicle.getConsumerFillUnitIndex ~ = nil then
                local fillUnitIndex = vehicle:getConsumerFillUnitIndex(FillType.DIESEL) or vehicle:getConsumerFillUnitIndex(FillType.ELECTRICCHARGE) or vehicle:getConsumerFillUnitIndex(FillType.METHANE)
                if fillUnitIndex ~ = nil then
                    local fillLevel = vehicle:getFillUnitFillLevel(fillUnitIndex)
                    local delta = fuelLevel - fillLevel
                    vehicle:addFillUnitFillLevel( self.mission:getFarmId(), fillUnitIndex, delta, vehicle:getFillUnitFirstSupportedFillType(fillUnitIndex), ToolType.UNDEFINED, nil )

                    return "Added fuel"
                else
                        return "No Fuel filltype supported!"
                    end
                end

                return "Vehicle has no consumer"
            else
                    return "Enter a vehicle first!"
                end
            end

            return "Not available on clients"
        end

```

### consoleCommandSetMotorTemperature

**Description**

**Definition**

> consoleCommandSetMotorTemperature()

**Arguments**

| any | temperature |
|-----|-------------|

**Code**

```lua
function VehicleSystem:consoleCommandSetMotorTemperature(temperature)
    if self.mission:getIsServer() then
        if temperature = = nil then
            return "No temperature given! Usage:gsVehicleTemperatureSet <temperature>"
        end
        temperature = Utils.getNoNil( tonumber(temperature), 0 )

        local vehicle = g_localPlayer:getCurrentVehicle()
        if vehicle ~ = nil then
            local spec = vehicle.spec_motorized
            if spec ~ = nil then
                spec.motorTemperature.value = math.clamp(temperature, spec.motorTemperature.valueMin, spec.motorTemperature.valueMax)
                return "Set motor temperature to " .. spec.motorTemperature.value
            end

            return "Vehicle has no motor"
        else
                return "Enter a vehicle first!"
            end
        end

        return "Not available on clients"
    end

```

### consoleCommandSetOperatingTime

**Description**

**Definition**

> consoleCommandSetOperatingTime()

**Arguments**

| any | operatingTime |
|-----|---------------|

**Code**

```lua
function VehicleSystem:consoleCommandSetOperatingTime(operatingTime)
    if self.mission:getIsServer() then
        if operatingTime = = nil then
            return "No operatingTime given! Usage:gsVehicleOperatingTimeSet <operatingTime(h)>"
        end

        operatingTime = tonumber(operatingTime) or 0
        operatingTime = operatingTime * 1000 * 60 * 60

        local controlledVehicle = g_localPlayer:getCurrentVehicle()
        if controlledVehicle ~ = nil then
            if controlledVehicle.setOperatingTime ~ = nil then
                controlledVehicle:setOperatingTime(operatingTime)

                return string.format( "Set operating time to %.1f" , operatingTime)
            end

            return "Vehicle has no operating time"
        else
                return "Enter a vehicle first!"
            end
        end

        return "Not available on clients"
    end

```

### consoleCommandShowVehicleDistance

**Description**

**Definition**

> consoleCommandShowVehicleDistance()

**Arguments**

| any | active |
|-----|--------|

**Code**

```lua
function VehicleSystem:consoleCommandShowVehicleDistance(active)
    g_showVehicleDistance = Utils.getNoNil(active, not g_showVehicleDistance)
end

```

### consoleCommandVehicleRemoveAll

**Description**

**Definition**

> consoleCommandVehicleRemoveAll()

**Code**

```lua
function VehicleSystem:consoleCommandVehicleRemoveAll()
    local numDeleted = 0
    for i = # self.vehicles, 1 , - 1 do
        local vehicle = self.vehicles[i]
        if vehicle.trainSystem = = nil and not vehicle.isPallet then
            vehicle:delete()
            numDeleted = numDeleted + 1
        end
    end

    return string.format( "Deleted %i vehicle(s)! Excluded train and pallets" , numDeleted)
end

```

### consoleCommandVehicleToggleRandomFail

**Description**

**Definition**

> consoleCommandVehicleToggleRandomFail()

**Code**

```lua
function VehicleSystem:consoleCommandVehicleToggleRandomFail()
    Vehicle.DEBUG_RANDOM_FAIL_LOADING = not Vehicle.DEBUG_RANDOM_FAIL_LOADING

    return string.format( "Vehicle.DEBUG_RANDOM_FAIL_LOADING: %s" , Vehicle.DEBUG_RANDOM_FAIL_LOADING)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function VehicleSystem:delete()
    for i = # self.pendingVehicleLoadingData, 1 , - 1 do
        self.pendingVehicleLoadingData[i]:cancelLoading()
    end

    for k, vehicle in pairs( self.vehiclesToDelete) do
        vehicle:delete( true )
        self.vehiclesToDelete[k] = nil
    end

    for i = # self.vehicles, 1 , - 1 do
        local vehicle = self.vehicles[i]
        vehicle:delete( true )
    end

    if self.savegameXMLFile ~ = nil then
        self.savegameXMLFile:delete()
        self.savegameXMLFile = nil
    end

    self.mission = nil
    self.vehicles = { }
    self.vehicleByUniqueId = { }
    self.wetVehicles = { }

    self.enterables = { }
    self.interactiveVehicles = { }

    g_messageCenter:unsubscribeAll( self )

    removeConsoleCommand( "gsVehicleShowDistance" )

    removeConsoleCommand( "gsVehicleReload" )

    removeConsoleCommand( "gsPalletAdd" )
    removeConsoleCommand( "gsVehicleFuelSet" )
    removeConsoleCommand( "gsVehicleTemperatureSet" )
    removeConsoleCommand( "gsFillUnitAdd" )
    removeConsoleCommand( "gsVehicleOperatingTimeSet" )
    removeConsoleCommand( "gsVehicleAddDirt" )
    removeConsoleCommand( "gsVehicleAddWear" )
    removeConsoleCommand( "gsVehicleAddWetness" )
    removeConsoleCommand( "gsVehicleAddDamage" )
    removeConsoleCommand( "gsVehicleLoadAll" )

    removeConsoleCommand( "gsVehicleRemoveAll" )
    removeConsoleCommand( "gsExportVehicleSets" )
    removeConsoleCommand( "gsVehiclesPendingLoadings" )
end

```

### deleteAll

**Description**

**Definition**

> deleteAll()

**Code**

```lua
function VehicleSystem:deleteAll()
    local numDeleted = # self.vehicles

    for i = # self.vehicles, 1 , - 1 do
        local vehicle = self.vehicles[i]
        vehicle:delete()
    end

    return numDeleted
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function VehicleSystem:draw()
    for _, vehicle in pairs( self.enterables) do
        vehicle:drawUIInfo()
    end
end

```

### getNextEnterableVehicle

**Description**

**Definition**

> getNextEnterableVehicle()

**Arguments**

| any | currentVehicle |
|-----|----------------|
| any | delta          |

**Code**

```lua
function VehicleSystem:getNextEnterableVehicle(currentVehicle, delta)
    local numVehicles = # self.enterables
    if numVehicles = = 0 then
        return nil
    end

    local index = 1

    if g_localPlayer:getIsInVehicle() and currentVehicle ~ = nil then
        for i, enterable in ipairs( self.enterables) do
            if currentVehicle = = self.enterables[i] then
                index = i + delta
                break
            end
        end
    else
            if delta > 0 then
                -- with tab we go directly in the last entered vehicle
                index = self.lastEnteredVehicleIndex
            else
                    -- with shift + tab we enter the last vehicle in the list -> to quickly get in the last bought one
                    index = numVehicles
                end
            end

            local found = false
            for _ = 1 , numVehicles do
                local enterable = self.enterables[index]
                if enterable ~ = nil and enterable:getIsTabbable() and enterable:getIsEnterable() then
                    found = true
                    break
                else
                        index = index + delta
                        if index > numVehicles then
                            index = 1
                        elseif index < 1 then
                                index = numVehicles
                            end
                        end
                    end

                    if found then
                        return self.enterables[index]
                    end

                    return nil
                end

```

### getVehicleByNodeId

**Description**

> Returns the corresponding vehicle to a given physics node id (supports correct detection of hard attached implements,
> which share the same compound as the parent vehicle)

**Definition**

> getVehicleByNodeId()

**Arguments**

| any | nodeId     |
|-----|------------|
| any | subShapeId |

**Code**

```lua
function VehicleSystem:getVehicleByNodeId(nodeId, subShapeId)
    local vehicle
    if nodeId ~ = subShapeId then
        -- object is a compoundChild.Try to find the compound
        local parentId = subShapeId
        while parentId ~ = 0 do
            if g_currentMission.nodeToObject[parentId] ~ = nil then
                -- found valid compound
                vehicle = g_currentMission.nodeToObject[parentId]
                break
            end

            parentId = getParent(parentId)
        end
    else
            vehicle = g_currentMission.nodeToObject[nodeId]
        end

        if vehicle ~ = nil and vehicle.isa ~ = nil and vehicle:isa( Vehicle ) then
            return vehicle
        end

        return nil
    end

```

### getVehicleByUniqueId

**Description**

**Definition**

> getVehicleByUniqueId()

**Arguments**

| any | uniqueId |
|-----|----------|

**Code**

```lua
function VehicleSystem:getVehicleByUniqueId(uniqueId)
    return self.vehicleByUniqueId[uniqueId]
end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | xmlFilename            |
|-----|------------------------|
| any | asyncCallbackFunction  |
| any | asyncCallbackObject    |
| any | asyncCallbackArguments |
| any | resetVehicles          |

**Code**

```lua
function VehicleSystem:load(xmlFilename, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments, resetVehicles)
    self.savegameXMLFile = XMLFile.load( "vehiclesXML" , xmlFilename, Vehicle.xmlSchemaSavegame)

    if self.savegameXMLFile = = nil then
        Logging.xmlError(xmlFilename, "Loading vehicles xml file failed" )
        g_asyncTaskManager:addSubtask( function ()
            asyncCallbackFunction(asyncCallbackObject, { } , VehicleLoadingState.ERROR, asyncCallbackArguments)
        end )
        return
    end

    self:loadFromXMLFile( self.savegameXMLFile, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile                |
|-----|------------------------|
| any | asyncCallbackFunction  |
| any | asyncCallbackObject    |
| any | asyncCallbackArguments |
| any | resetVehicles          |
| any | keepPosition           |

**Code**

```lua
function VehicleSystem:loadFromXMLFile(xmlFile, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments, resetVehicles, keepPosition)
    if self.loadedVehicles ~ = nil then
        local savegameLoadingData = { }
        savegameLoadingData.xmlFile = xmlFile
        savegameLoadingData.asyncCallbackFunction = asyncCallbackFunction
        savegameLoadingData.asyncCallbackObject = asyncCallbackObject
        savegameLoadingData.asyncCallbackArguments = asyncCallbackArguments
        savegameLoadingData.resetVehicles = resetVehicles
        savegameLoadingData.keepPosition = keepPosition

        table.insert( self.pendingVehicleSavegameLoadings, savegameLoadingData)

        return
    end

    local defaultItemsToSPFarm = xmlFile:getValue( "vehicles#loadAnyFarmInSingleplayer" , false )

    self.loadedVehicles = { }
    self.vehiclesToLoad = 0
    self.vehicleLoadingState = nil

    self.asyncCallbackFunction = asyncCallbackFunction
    self.asyncCallbackObject = asyncCallbackObject
    self.asyncCallbackArguments = asyncCallbackArguments

    xmlFile:iterate( "vehicles.vehicle" , function (index, key)
        g_asyncTaskManager:addSubtask( function ()
            self:loadVehicleFromXML(xmlFile, key, defaultItemsToSPFarm, resetVehicles, keepPosition)
        end )
    end )

    g_asyncTaskManager:addSubtask( function ()
        if self.vehiclesToLoad < = 0 then
            if self.asyncCallbackFunction ~ = nil then
                self.asyncCallbackFunction( self.asyncCallbackObject, self.loadedVehicles, VehicleLoadingState.OK, self.asyncCallbackArguments)

                self.asyncCallbackFunction = nil
                self.asyncCallbackObject = nil
                self.asyncCallbackArguments = nil
            end

            self.loadedVehicles = nil
            self.vehicleLoadingState = nil

            self:updatePendingSavegameLoadings()
        end
    end )
end

```

### loadVehicleFinished

**Description**

**Definition**

> loadVehicleFinished()

**Arguments**

| any | vehicles     |
|-----|--------------|
| any | loadingState |

**Code**

```lua
function VehicleSystem:loadVehicleFinished(vehicles, loadingState)
    if loadingState = = VehicleLoadingState.OK then
        for _, vehicle in ipairs(vehicles) do
            table.insert( self.loadedVehicles, vehicle)
        end
    else
            self.vehicleLoadingState = self.vehicleLoadingState or loadingState
        end

        self.vehiclesToLoad = self.vehiclesToLoad - 1
        if self.vehiclesToLoad < = 0 then
            for _, loadedVehicle in ipairs( self.loadedVehicles) do
                loadedVehicle:addToPhysics()
            end

            if self.asyncCallbackFunction ~ = nil then
                self.asyncCallbackFunction( self.asyncCallbackObject, self.loadedVehicles, self.vehicleLoadingState or VehicleLoadingState.OK, self.asyncCallbackArguments)

                self.asyncCallbackFunction = nil
                self.asyncCallbackObject = nil
                self.asyncCallbackArguments = nil
            end

            self.loadedVehicles = nil
            self.vehicleLoadingState = nil

            self:updatePendingSavegameLoadings()
        end
    end

```

### loadVehicleFromXML

**Description**

**Definition**

> loadVehicleFromXML()

**Arguments**

| any | xmlFile              |
|-----|----------------------|
| any | key                  |
| any | defaultItemsToSPFarm |
| any | resetVehicles        |
| any | keepPosition         |

**Code**

```lua
function VehicleSystem:loadVehicleFromXML(xmlFile, key, defaultItemsToSPFarm, resetVehicles, keepPosition)
    local missionInfo = g_currentMission.missionInfo
    local missionDynamicInfo = g_currentMission.missionDynamicInfo

    local filename = xmlFile:getValue(key .. "#filename" )
    local defaultProperty = xmlFile:getValue(key .. "#defaultFarmProperty" , false )
    local farmId = xmlFile:getValue(key .. "#farmId" )

    local loadForCompetitive = defaultProperty and missionInfo.isCompetitiveMultiplayer and g_farmManager:getFarmById(farmId) ~ = nil
    local loadDefaultProperty = defaultProperty and(missionInfo.loadDefaultFarm and not missionDynamicInfo.isMultiplayer) and(farmId = = FarmManager.SINGLEPLAYER_FARM_ID or defaultItemsToSPFarm)
    local allowedToLoad = missionInfo.isValid or not defaultProperty or loadDefaultProperty or loadForCompetitive

    if not allowedToLoad then
        Logging.xmlInfo(xmlFile, "Vehicle '%s' is not allowed to be loaded" , filename)
        return false
    end

    filename = NetworkUtil.convertFromNetworkFilename(filename)

    local storeItem = g_storeManager:getItemByXMLFilename(filename)

    if storeItem = = nil then
        Logging.xmlWarning(xmlFile, "Unable to retrieve store item for vehicle xml '%s'" , filename)
            return false
        end

        local savegame = { xmlFile = xmlFile, key = key, ignoreFarmId = false , resetVehicles = resetVehicles, keepPosition = keepPosition }

        if loadDefaultProperty and defaultItemsToSPFarm and farmId ~ = FarmManager.SINGLEPLAYER_FARM_ID then
            farmId = FarmManager.SINGLEPLAYER_FARM_ID
            savegame.ignoreFarmId = true
        end

        if not g_currentMission.slotSystem:hasEnoughSlots(storeItem) then
            g_currentMission:addMoney(storeItem.price, farmId, MoneyType.SHOP_VEHICLE_SELL, true )
            Logging.xmlWarning(xmlFile, "Too many slots in use.Selling vehicle '%s' for '%d'" , filename, storeItem.price)
                return false
            end

            self.vehiclesToLoad = self.vehiclesToLoad + 1

            local data = VehicleLoadingData.new()
            data:setStoreItem(storeItem)
            data:setSavegameData(savegame)
            data:setAddToPhysics( false )

            data:load( self.loadVehicleFinished, self )

            return true
        end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | mission  |
|-----|----------|
| any | customMt |

**Code**

```lua
function VehicleSystem.new(mission, customMt)
    local self = setmetatable( { } , customMt or VehicleSystem _mt)

    self.mission = mission
    self.vehicles = { } -- vehicles that are registered
    self.pendingVehicleLoadingData = { } -- vehicle loading data that is currently pending
    self.pendingVehicleSavegameLoadings = { }
    self.vehicleByUniqueId = { }
    self.wetVehicles = { }

    self.enterables = { }
    self.lastEnteredVehicleIndex = 1
    self.inputAttacherJoints = { }
    self.interactiveVehicles = { }
    self.vehiclesToDelete = { }

    self.isReloadRunning = false

    if g_addCheatCommands then
        addConsoleCommand( "gsVehicleShowDistance" , "Shows the distance between vehicle and cam" , "consoleCommandShowVehicleDistance" , self )
    end

    if self.mission:getIsServer() then
        addConsoleCommand( "gsVehicleReload" , "Reloads currently entered vehicle or vehicles within a range when second radius parameter is given" , "consoleCommandReloadVehicle" , self , "[resetVehicle]; [radiusAroundPlayer]" )

        if g_addCheatCommands then
            addConsoleCommand( "gsPalletAdd" , "Adds a pallet" , "consoleCommandAddPallet" , self , "fillTypeName; [fillAmount]; [worldX]; [worldZ]" )
            addConsoleCommand( "gsVehicleFuelSet" , "Sets the vehicle fuel level" , "consoleCommandSetFuel" , self )
            addConsoleCommand( "gsVehicleTemperatureSet" , "Sets the vehicle motor temperature" , "consoleCommandSetMotorTemperature" , self )
            addConsoleCommand( "gsFillUnitAdd" , "Changes a fillUnit with given filllevel and filltype" , "consoleCommandFillUnitAdd" , self , "fillUnitIndex; fillTypeName; [amount]" )
            addConsoleCommand( "gsVehicleOperatingTimeSet" , "Sets the vehicle operating time" , "consoleCommandSetOperatingTime" , self )
            addConsoleCommand( "gsVehicleAddDirt" , "Adds a given amount to current dirt amount" , "consoleCommandAddDirtAmount" , self )
            addConsoleCommand( "gsVehicleAddWear" , "Adds a given amount to current wear amount" , "consoleCommandAddWearAmount" , self )
            addConsoleCommand( "gsVehicleAddWetness" , "Adds a given amount to current wetness amount" , "consoleCommandAddWetnessAmount" , self )
            addConsoleCommand( "gsVehicleAddDamage" , "Adds a given amount to current damage amount" , "consoleCommandAddDamageAmount" , self )
            addConsoleCommand( "gsVehicleLoadAll" , "Load all vehicles" , "consoleCommandLoadAllVehicles" , self , "[loadConfigs]; [modsOnly]; [palletsOnly]; [verbose]" , true )
        end

        if g_addTestCommands then
            addConsoleCommand( "gsVehicleToggleRandomFail" , "Toggles random vehicle load failing" , "consoleCommandVehicleToggleRandomFail" , self )
            addConsoleCommand( "gsVehicleRemoveAll" , "Removes all vehicles from current mission" , "consoleCommandVehicleRemoveAll" , self , nil , true )
            addConsoleCommand( "gsExportVehicleSets" , "Exports vehicle sets" , "consoleCommandExportVehicleSets" , self )
        end
    end

    if g_addTestCommands then
        addConsoleCommand( "gsVehiclesPendingLoadings" , "Prints the pending vehicle loadings" , "consoleCommandPrintPendingLoadings" , self )
    end

    g_messageCenter:subscribe(BuyVehicleEvent, self.onVehicleBuyEvent, self )

    return self
end

```

### onVehicleBuyEvent

**Description**

**Definition**

> onVehicleBuyEvent()

**Arguments**

| any | errorCode    |
|-----|--------------|
| any | leaseVehicle |
| any | price        |

**Code**

```lua
function VehicleSystem:onVehicleBuyEvent(errorCode, leaseVehicle, price)
    local serverFarmId = g_currentMission:getFarmId()
    local numDrivables = 0
    local numVehicles = 0
    for _, item in ipairs( self.vehicles) do
        if item:getOwnerFarmId() = = serverFarmId then
            if item.spec_drivable ~ = nil then
                numDrivables = numDrivables + 1
                numVehicles = numVehicles + 1
            elseif item.spec_attachable ~ = nil and item.spec_bigBag = = nil then
                    numVehicles = numVehicles + 1
                end
            end
        end

        g_achievementManager:tryUnlock( "NumDrivables" , numDrivables)
        g_achievementManager:tryUnlock( "NumVehiclesSmall" , numVehicles)
        g_achievementManager:tryUnlock( "NumVehiclesLarge" , numVehicles)
    end

```

### registerInputAttacherJoint

**Description**

**Definition**

> registerInputAttacherJoint()

**Arguments**

| any | vehicle                 |
|-----|-------------------------|
| any | inputAttacherJointIndex |
| any | inputAttacherJoint      |

**Code**

```lua
function VehicleSystem:registerInputAttacherJoint(vehicle, inputAttacherJointIndex, inputAttacherJoint)
    local inputAttacherJointInfo = { }
    inputAttacherJointInfo.vehicle = vehicle
    inputAttacherJointInfo.jointIndex = inputAttacherJointIndex
    inputAttacherJointInfo.inputAttacherJoint = inputAttacherJoint
    inputAttacherJointInfo.node = inputAttacherJoint.node
    inputAttacherJointInfo.jointType = inputAttacherJoint.jointType
    inputAttacherJointInfo.translation = { getWorldTranslation(inputAttacherJoint.node) }

    table.addElement( self.inputAttacherJoints, inputAttacherJointInfo)

    return inputAttacherJointInfo
end

```

### removeEnterableVehicle

**Description**

**Definition**

> removeEnterableVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:removeEnterableVehicle(vehicle)
    table.removeElement( self.enterables, vehicle)

    -- ensure lastEnteredVehicleIndex is not out of bounds, otherwise tab action will do nothing after selling vehicles
        self.lastEnteredVehicleIndex = math.max( 1 , math.min( self.lastEnteredVehicleIndex, # self.enterables))
    end

```

### removeInputAttacherJoint

**Description**

**Definition**

> removeInputAttacherJoint()

**Arguments**

| any | inputAttacherJointInfo |
|-----|------------------------|

**Code**

```lua
function VehicleSystem:removeInputAttacherJoint(inputAttacherJointInfo)
    table.removeElement( self.inputAttacherJoints, inputAttacherJointInfo)
end

```

### removeInteractiveVehicle

**Description**

**Definition**

> removeInteractiveVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:removeInteractiveVehicle(vehicle)
    self.interactiveVehicles[vehicle] = nil
end

```

### removePendingVehicleLoad

**Description**

**Definition**

> removePendingVehicleLoad()

**Arguments**

| any | vehicleLoadingData |
|-----|--------------------|

**Code**

```lua
function VehicleSystem:removePendingVehicleLoad(vehicleLoadingData)
    table.removeElement( self.pendingVehicleLoadingData, vehicleLoadingData)
end

```

### removeVehicle

**Description**

**Definition**

> removeVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:removeVehicle(vehicle)
    table.removeElement( self.vehicles, vehicle)

    local uniqueId = vehicle:getUniqueId()
    if uniqueId ~ = nil then
        if self.vehicleByUniqueId[uniqueId] = = vehicle then
            self.vehicleByUniqueId[uniqueId] = nil
        end
    end

    self.wetVehicles[vehicle] = nil

    g_messageCenter:publish(MessageType.VEHICLE_REMOVED)
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
function VehicleSystem:save(xmlFilename, usedModNames)
    local xmlFile = XMLFile.create( "vehiclesXML" , xmlFilename, "vehicles" , Vehicle.xmlSchemaSavegame)
    if xmlFile ~ = nil then
        self:saveToXML( self.vehicles, xmlFile, usedModNames)
        xmlFile:delete()
    end
end

```

### saveToXML

**Description**

**Definition**

> saveToXML()

**Arguments**

| any | vehicles     |
|-----|--------------|
| any | xmlFile      |
| any | usedModNames |

**Code**

```lua
function VehicleSystem:saveToXML(vehicles, xmlFile, usedModNames)
    if xmlFile ~ = nil then
        local xmlIndex = 0
        for i, vehicle in ipairs(vehicles) do
            if vehicle:getNeedsSaving() then
                self:saveVehicleToXML(vehicle, xmlFile, xmlIndex, i, usedModNames)

                xmlIndex = xmlIndex + 1
            end
        end

        xmlFile:save( false , true )
    end
end

```

### saveVehicleToXML

**Description**

**Definition**

> saveVehicleToXML()

**Arguments**

| any | vehicle      |
|-----|--------------|
| any | xmlFile      |
| any | index        |
| any | i            |
| any | usedModNames |

**Code**

```lua
function VehicleSystem:saveVehicleToXML(vehicle, xmlFile, index, i, usedModNames)
    local vehicleKey = string.format( "vehicles.vehicle(%d)" , index)

    local modName = vehicle.customEnvironment
    if modName ~ = nil then
        if usedModNames ~ = nil then
            usedModNames[modName] = modName
        end
        xmlFile:setValue(vehicleKey .. "#modName" , modName)
    end

    xmlFile:setValue(vehicleKey .. "#filename" , HTMLUtil.encodeToHTML(NetworkUtil.convertToNetworkFilename(vehicle.configFileName)))

    vehicle:saveToXMLFile(xmlFile, vehicleKey, usedModNames)
end

```

### setEnteredVehicle

**Description**

**Definition**

> setEnteredVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleSystem:setEnteredVehicle(vehicle)
    for i = 1 , # self.enterables do
        if self.enterables[i] = = vehicle then
            self.lastEnteredVehicleIndex = i
            break
        end
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
function VehicleSystem:update(dt)
    if self.debugVehiclesToBeLoaded ~ = nil then
        self:consoleCommandLoadAllVehiclesNext()
    end

    if g_server ~ = nil then
        local weather = g_currentMission.environment.weather
        local indoorMask = g_currentMission.indoorMask

        local rainScale = weather:getRainFallScale()
        if rainScale > 0.1 then
            local timeScale = g_currentMission:getEffectiveTimeScale()
            local timeSinceLastRain = weather:getTimeSinceLastRain()
            local temperature = weather:getCurrentTemperature()
            if timeSinceLastRain < 30 and temperature > 0 then
                for _, vehicle in pairs( self.vehicles) do
                    if not vehicle:getIsInShowroom() and vehicle.updateWetness ~ = nil then
                        local x, _, z = getWorldTranslation(vehicle.rootNode)
                        local isInside = indoorMask:getIsIndoorAtWorldPosition(x, z)
                        if not isInside then
                            vehicle:updateWetness( true , dt * timeScale)

                            if vehicle:getIsWet() then
                                self.wetVehicles[vehicle] = vehicle
                            end
                        else
                                vehicle:updateWetness( false , dt * timeScale)

                                if not vehicle:getIsWet() then
                                    self.wetVehicles[vehicle] = nil
                                end
                            end
                        end
                    end
                end
            elseif next( self.wetVehicles) ~ = nil then
                    local timeScale = g_currentMission:getEffectiveTimeScale()
                    for vehicle, _ in pairs( self.wetVehicles) do
                        vehicle:updateWetness( false , dt * timeScale)

                        if not vehicle:getIsWet() then
                            self.wetVehicles[vehicle] = nil
                        end
                    end
                end
            end
        end

```

### updateInputAttacherJoint

**Description**

**Definition**

> updateInputAttacherJoint()

**Arguments**

| any | inputAttacherJointInfo |
|-----|------------------------|

**Code**

```lua
function VehicleSystem:updateInputAttacherJoint(inputAttacherJointInfo)
    local x, y, z = getWorldTranslation(inputAttacherJointInfo.node)
    inputAttacherJointInfo.translation[ 1 ], inputAttacherJointInfo.translation[ 2 ], inputAttacherJointInfo.translation[ 3 ] = x, y, z
end

```

### updatePendingSavegameLoadings

**Description**

**Definition**

> updatePendingSavegameLoadings()

**Code**

```lua
function VehicleSystem:updatePendingSavegameLoadings()
    if # self.pendingVehicleSavegameLoadings > 0 then
        local savegameLoadingData = self.pendingVehicleSavegameLoadings[ 1 ]
        table.remove( self.pendingVehicleSavegameLoadings, 1 )

        self:loadFromXMLFile(savegameLoadingData.xmlFile, savegameLoadingData.asyncCallbackFunction, savegameLoadingData.asyncCallbackObject, savegameLoadingData.asyncCallbackArguments, savegameLoadingData.resetVehicles, savegameLoadingData.keepPosition)
    end
end

```