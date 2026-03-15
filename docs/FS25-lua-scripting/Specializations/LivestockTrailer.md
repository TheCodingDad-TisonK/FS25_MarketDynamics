## LivestockTrailer

**Description**

> Specialization for livestrock trailers with animals as cargo

**Functions**

- [addAnimals](#addanimals)
- [addCluster](#addcluster)
- [clearAnimals](#clearanimals)
- [dayChanged](#daychanged)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getAnimalUnloadPlaces](#getanimalunloadplaces)
- [getClusterById](#getclusterbyid)
- [getClusters](#getclusters)
- [getClusterSystem](#getclustersystem)
- [getCurrentAnimalType](#getcurrentanimaltype)
- [getLoadingTrigger](#getloadingtrigger)
- [getMaxNumOfAnimals](#getmaxnumofanimals)
- [getNumOfAnimals](#getnumofanimals)
- [getNumOfFreeAnimalSlots](#getnumoffreeanimalslots)
- [getRideablesInTrigger](#getrideablesintrigger)
- [getSellPrice](#getsellprice)
- [getSpecValueNumberAnimals](#getspecvaluenumberanimals)
- [getSpecValueNumberAnimalsCow](#getspecvaluenumberanimalscow)
- [getSpecValueNumberAnimalsHorse](#getspecvaluenumberanimalshorse)
- [getSpecValueNumberAnimalsPig](#getspecvaluenumberanimalspig)
- [getSpecValueNumberAnimalsSheep](#getspecvaluenumberanimalssheep)
- [getSupportsAnimalSubType](#getsupportsanimalsubtype)
- [getSupportsAnimalType](#getsupportsanimaltype)
- [initSpecialization](#initspecialization)
- [loadSpecValueNumberAnimals](#loadspecvaluenumberanimals)
- [loadSpecValueNumberAnimalsCow](#loadspecvaluenumberanimalscow)
- [loadSpecValueNumberAnimalsHorse](#loadspecvaluenumberanimalshorse)
- [loadSpecValueNumberAnimalsPig](#loadspecvaluenumberanimalspig)
- [loadSpecValueNumberAnimalsSheep](#loadspecvaluenumberanimalssheep)
- [onAnimalLoaded](#onanimalloaded)
- [onAnimalLoadTriggerCallback](#onanimalloadtriggercallback)
- [onAnimalRideableDeleted](#onanimalrideabledeleted)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [periodChanged](#periodchanged)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setAnimalScreenController](#setanimalscreencontroller)
- [setLoadingTrigger](#setloadingtrigger)
- [updateAnimals](#updateanimals)
- [updatedClusters](#updatedclusters)

### addAnimals

**Description**

**Definition**

> addAnimals()

**Arguments**

| any | subTypeIndex |
|-----|--------------|
| any | numAnimals   |
| any | age          |

**Code**

```lua
function LivestockTrailer:addAnimals(subTypeIndex, numAnimals, age)
    local cluster = g_currentMission.animalSystem:createClusterFromSubTypeIndex(subTypeIndex)
    if cluster:getSupportsMerging() then
        cluster.numAnimals = numAnimals
        cluster.age = age
        self:addCluster(cluster)
    else
            for i = 1 , numAnimals do
                if i > 1 then
                    cluster = g_currentMission.animalSystem:createClusterFromSubTypeIndex(subTypeIndex)
                end
                cluster.numAnimals = 1
                cluster.age = age
                self:addCluster(cluster)
            end
        end
    end

```

### addCluster

**Description**

**Definition**

> addCluster()

**Arguments**

| any | cluster |
|-----|---------|

**Code**

```lua
function LivestockTrailer:addCluster(cluster)
    local spec = self.spec_livestockTrailer

    spec.clusterSystem:addPendingAddCluster(cluster)
    spec.clusterSystem:updateNow()
end

```

### clearAnimals

**Description**

**Definition**

> clearAnimals()

**Code**

```lua
function LivestockTrailer:clearAnimals()
    local spec = self.spec_livestockTrailer
    if spec.animalTypeIndexToPlaces ~ = nil then
        for _, place in pairs(spec.animalTypeIndexToPlaces) do
            for _, slot in ipairs(place.slots) do
                if slot.sharedLoadRequestId ~ = nil then
                    g_i3DManager:releaseSharedI3DFile(slot.sharedLoadRequestId)
                    slot.sharedLoadRequestId = nil
                end
                if slot.loadedMesh ~ = nil then
                    delete(slot.loadedMesh)
                    slot.loadedMesh = nil
                end
            end
        end
    end
end

```

### dayChanged

**Description**

**Definition**

> dayChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function LivestockTrailer:dayChanged(superFunc)
    superFunc( self )

    local spec = self.spec_livestockTrailer
    local clusters = spec.clusterSystem:getClusters()
    for _, cluster in ipairs(clusters) do
        cluster:onDayChanged()
    end
end

```

### getAdditionalComponentMass

**Description**

**Definition**

> getAdditionalComponentMass()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | component |

**Code**

```lua
function LivestockTrailer:getAdditionalComponentMass(superFunc, component)
    local additionalMass = superFunc( self , component)
    local spec = self.spec_livestockTrailer

    local clusters = spec.clusterSystem:getClusters()
    for _, cluster in ipairs(clusters) do
        local subTypeIndex = cluster:getSubTypeIndex()
        local subType = g_currentMission.animalSystem:getSubTypeByIndex(subTypeIndex)
        local fillTypeIndex = subType.fillTypeIndex
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

        additionalMass = additionalMass + (fillType.massPerLiter * cluster:getNumAnimals())
    end

    return additionalMass
end

```

### getAnimalUnloadPlaces

**Description**

**Definition**

> getAnimalUnloadPlaces()

**Code**

```lua
function LivestockTrailer:getAnimalUnloadPlaces()
    local spec = self.spec_livestockTrailer
    local places = { }

    for _, spawnPlace in ipairs(spec.spawnPlaces) do
        local node = spawnPlace.node
        local x, y, z = getWorldTranslation(node)

        local place = { }
        place.startX, place.startY, place.startZ = x, y, z
        place.rotX, place.rotY, place.rotZ = getWorldRotation(node)
        place.dirX, place.dirY, place.dirZ = localDirectionToWorld(node, 1 , 0 , 0 )
        place.dirPerpX, place.dirPerpY, place.dirPerpZ = localDirectionToWorld(node, 0 , 0 , 1 )
        place.yOffset = 1
        place.maxWidth = math.huge
        place.maxLength = math.huge
        place.maxHeight = math.huge
        place.width = spawnPlace.width

        table.insert(places, place)
    end

    return places
end

```

### getClusterById

**Description**

**Definition**

> getClusterById()

**Arguments**

| any | id |
|-----|----|

**Code**

```lua
function LivestockTrailer:getClusterById(id)
    local spec = self.spec_livestockTrailer
    return spec.clusterSystem:getClusterById(id)
end

```

### getClusters

**Description**

**Definition**

> getClusters()

**Code**

```lua
function LivestockTrailer:getClusters()
    local spec = self.spec_livestockTrailer
    return spec.clusterSystem:getClusters()
end

```

### getClusterSystem

**Description**

**Definition**

> getClusterSystem()

**Code**

```lua
function LivestockTrailer:getClusterSystem()
    local spec = self.spec_livestockTrailer
    return spec.clusterSystem
end

```

### getCurrentAnimalType

**Description**

**Definition**

> getCurrentAnimalType()

**Code**

```lua
function LivestockTrailer:getCurrentAnimalType()
    local spec = self.spec_livestockTrailer
    local clusters = spec.clusterSystem:getClusters()
    if #clusters = = 0 then
        return nil
    end

    local animalSystem = g_currentMission.animalSystem
    local subTypeIndex = clusters[ 1 ]:getSubTypeIndex()
    local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
    local animalType = animalSystem:getTypeByIndex(subType.typeIndex)
    return animalType
end

```

### getLoadingTrigger

**Description**

**Definition**

> getLoadingTrigger()

**Code**

```lua
function LivestockTrailer:getLoadingTrigger()
    return self.spec_livestockTrailer.loadingTrigger
end

```

### getMaxNumOfAnimals

**Description**

**Definition**

> getMaxNumOfAnimals()

**Arguments**

| any | animalType |
|-----|------------|

**Code**

```lua
function LivestockTrailer:getMaxNumOfAnimals(animalType)
    local spec = self.spec_livestockTrailer

    local currentAnimalType = self:getCurrentAnimalType()
    if animalType = = nil and currentAnimalType = = nil then
        return 0
    end

    if currentAnimalType ~ = nil and animalType ~ = currentAnimalType then
        return 0
    end

    animalType = animalType or currentAnimalType

    if not self:getSupportsAnimalType(animalType.typeIndex) then
        return 0
    end

    local place = spec.animalTypeIndexToPlaces[animalType.typeIndex]
    return #place.slots
end

```

### getNumOfAnimals

**Description**

**Definition**

> getNumOfAnimals()

**Code**

```lua
function LivestockTrailer:getNumOfAnimals()
    local spec = self.spec_livestockTrailer

    local clusters = spec.clusterSystem:getClusters()
    if #clusters = = 0 then
        return 0
    end

    local subTypeIndex = clusters[ 1 ]:getSubTypeIndex()
    local subType = g_currentMission.animalSystem:getSubTypeByIndex(subTypeIndex)

    local place = spec.animalTypeIndexToPlaces[subType.typeIndex]
    return place.usedSlots or 0
end

```

### getNumOfFreeAnimalSlots

**Description**

**Definition**

> getNumOfFreeAnimalSlots()

**Arguments**

| any | subTypeIndex |
|-----|--------------|

**Code**

```lua
function LivestockTrailer:getNumOfFreeAnimalSlots(subTypeIndex)
    local animalSystem = g_currentMission.animalSystem
    local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
    local animalType = animalSystem:getTypeByIndex(subType.typeIndex)

    local used = self:getNumOfAnimals()
    local total = self:getMaxNumOfAnimals(animalType)
    return total - used
end

```

### getRideablesInTrigger

**Description**

**Definition**

> getRideablesInTrigger()

**Code**

```lua
function LivestockTrailer:getRideablesInTrigger()
    local spec = self.spec_livestockTrailer
    return spec.rideablesInTrigger
end

```

### getSellPrice

**Description**

**Definition**

> getSellPrice()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function LivestockTrailer:getSellPrice(superFunc)
    local sellPrice = superFunc( self )

    local spec = self.spec_livestockTrailer
    local clusters = spec.clusterSystem:getClusters()
    for _, cluster in ipairs(clusters) do
        local sellPriceCluster = cluster:getSellPrice() * cluster:getNumAnimals()

        sellPrice = sellPrice + (sellPriceCluster * 0.75 )
    end

    return sellPrice
end

```

### getSpecValueNumberAnimals

**Description**

**Definition**

> getSpecValueNumberAnimals()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |
| any | specName  |

**Code**

```lua
function LivestockTrailer.getSpecValueNumberAnimals(storeItem, realItem, specName)
    if storeItem.specs[specName] = = nil then
        return nil
    end
    return string.format( "%d %s" , storeItem.specs[specName], g_i18n:getText( "unit_pieces" ))
end

```

### getSpecValueNumberAnimalsCow

**Description**

**Definition**

> getSpecValueNumberAnimalsCow()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function LivestockTrailer.getSpecValueNumberAnimalsCow(storeItem, realItem)
    return LivestockTrailer.getSpecValueNumberAnimals(storeItem, realItem, "numAnimalsCow" )
end

```

### getSpecValueNumberAnimalsHorse

**Description**

**Definition**

> getSpecValueNumberAnimalsHorse()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function LivestockTrailer.getSpecValueNumberAnimalsHorse(storeItem, realItem)
    return LivestockTrailer.getSpecValueNumberAnimals(storeItem, realItem, "numAnimalsHorse" )
end

```

### getSpecValueNumberAnimalsPig

**Description**

**Definition**

> getSpecValueNumberAnimalsPig()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function LivestockTrailer.getSpecValueNumberAnimalsPig(storeItem, realItem)
    return LivestockTrailer.getSpecValueNumberAnimals(storeItem, realItem, "numAnimalsPig" )
end

```

### getSpecValueNumberAnimalsSheep

**Description**

**Definition**

> getSpecValueNumberAnimalsSheep()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function LivestockTrailer.getSpecValueNumberAnimalsSheep(storeItem, realItem)
    return LivestockTrailer.getSpecValueNumberAnimals(storeItem, realItem, "numAnimalsSheep" )
end

```

### getSupportsAnimalSubType

**Description**

**Definition**

> getSupportsAnimalSubType()

**Arguments**

| any | subTypeIndex |
|-----|--------------|

**Code**

```lua
function LivestockTrailer:getSupportsAnimalSubType(subTypeIndex)
    local animalSystem = g_currentMission.animalSystem
    local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
    local animalType = animalSystem:getTypeByIndex(subType.typeIndex)

    return self:getSupportsAnimalType(animalType.typeIndex)
end

```

### getSupportsAnimalType

**Description**

**Definition**

> getSupportsAnimalType()

**Arguments**

| any | animalTypeIndex |
|-----|-----------------|

**Code**

```lua
function LivestockTrailer:getSupportsAnimalType(animalTypeIndex)
    return self.spec_livestockTrailer.animalTypeIndexToPlaces[animalTypeIndex] ~ = nil
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function LivestockTrailer.initSpecialization()
    g_storeManager:addSpecType( "numAnimalsCow" , "shopListAttributeIconCow" , LivestockTrailer.loadSpecValueNumberAnimalsCow, LivestockTrailer.getSpecValueNumberAnimalsCow, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "numAnimalsPig" , "shopListAttributeIconPig" , LivestockTrailer.loadSpecValueNumberAnimalsPig, LivestockTrailer.getSpecValueNumberAnimalsPig, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "numAnimalsSheep" , "shopListAttributeIconSheep" , LivestockTrailer.loadSpecValueNumberAnimalsSheep, LivestockTrailer.getSpecValueNumberAnimalsSheep, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "numAnimalsHorse" , "shopListAttributeIconHorse" , LivestockTrailer.loadSpecValueNumberAnimalsHorse, LivestockTrailer.getSpecValueNumberAnimalsHorse, StoreSpecies.VEHICLE)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "LivestockTrailer" )

    schema:register(XMLValueType.STRING, "vehicle.livestockTrailer.animal(?)#type" , "Animal type name" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.livestockTrailer.animal(?)#node" , "Animal node" )
    schema:register(XMLValueType.INT, "vehicle.livestockTrailer.animal(?)#numSlots" , "Number of slots" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.livestockTrailer.loadTrigger#node" , "Load trigger node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.livestockTrailer.spawnPlaces.spawnPlace(?)#node" , "Unload spawn places" )
    schema:register(XMLValueType.FLOAT, "vehicle.livestockTrailer.spawnPlaces.spawnPlace(?)#width" , "Unloading width" , 15 )

    schema:setXMLSpecializationType()

    local savegameSchema = Vehicle.xmlSchemaSavegame
    savegameSchema:register(XMLValueType.STRING, "vehicles.vehicle(?).livestockTrailer#animalType" , "Animal type name" )
    AnimalClusterSystem.registerSavegameXMLPaths(savegameSchema, "vehicles.vehicle(?).livestockTrailer" )
end

```

### loadSpecValueNumberAnimals

**Description**

**Definition**

> loadSpecValueNumberAnimals()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |
| any | animalTypeName    |

**Code**

```lua
function LivestockTrailer.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir, animalTypeName)
    local maxNumAnimals = nil
    local i = 0
    local root = xmlFile:getRootName()
    while true do
        local key = string.format( "%s.livestockTrailer.animal(%d)" , root, i)
        if not xmlFile:hasProperty(key) then
            break
        end

        local typeName = xmlFile:getValue(key .. "#type" )
        if typeName ~ = nil and string.lower(typeName) = = string.lower(animalTypeName) then
            maxNumAnimals = xmlFile:getValue(key .. "#numSlots" , 0 )
            break
        end

        i = i + 1
    end

    return maxNumAnimals
end

```

### loadSpecValueNumberAnimalsCow

**Description**

**Definition**

> loadSpecValueNumberAnimalsCow()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function LivestockTrailer.loadSpecValueNumberAnimalsCow(xmlFile, customEnvironment, baseDir)
    return LivestockTrailer.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir, "cow" )
end

```

### loadSpecValueNumberAnimalsHorse

**Description**

**Definition**

> loadSpecValueNumberAnimalsHorse()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function LivestockTrailer.loadSpecValueNumberAnimalsHorse(xmlFile, customEnvironment, baseDir)
    return LivestockTrailer.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir, "horse" )
end

```

### loadSpecValueNumberAnimalsPig

**Description**

**Definition**

> loadSpecValueNumberAnimalsPig()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function LivestockTrailer.loadSpecValueNumberAnimalsPig(xmlFile, customEnvironment, baseDir)
    return LivestockTrailer.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir, "pig" )
end

```

### loadSpecValueNumberAnimalsSheep

**Description**

**Definition**

> loadSpecValueNumberAnimalsSheep()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function LivestockTrailer.loadSpecValueNumberAnimalsSheep(xmlFile, customEnvironment, baseDir)
    return LivestockTrailer.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir, "sheep" )
end

```

### onAnimalLoaded

**Description**

**Definition**

> onAnimalLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function LivestockTrailer:onAnimalLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local slot = args.slot
        local visual = args.visual

        link(slot.linkNode, i3dNode)

        slot.loadedMesh = i3dNode
        slot.meshLoadingInProgress = false

        local variations = visual.visualAnimal.variations[ 1 ]
        local tileU = variations.tileUIndex / variations.numTilesU
        local tileV = variations.tileVIndex / variations.numTilesV
        I3DUtil.setShaderParameterRec(i3dNode, "atlasInvSizeAndOffsetUV" , 1 / variations.numTilesU, 1 / variations.numTilesV, tileU, tileV)
        I3DUtil.setShaderParameterRec(i3dNode, "dirt" , 0 , nil , nil , nil )
    end
end

```

### onAnimalLoadTriggerCallback

**Description**

**Definition**

> onAnimalLoadTriggerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function LivestockTrailer:onAnimalLoadTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        local spec = self.spec_livestockTrailer
        local vehicle = g_currentMission.nodeToObject[otherId]

        if vehicle ~ = nil and vehicle.spec_rideable ~ = nil then
            local cluster = vehicle:getCluster()
            if cluster ~ = nil then
                local subTypeIndex = cluster:getSubTypeIndex()
                if self:getSupportsAnimalSubType(subTypeIndex) then
                    if onEnter then
                        table.addElement(spec.rideablesInTrigger, vehicle)
                        vehicle:addDeleteListener( self , "onAnimalRideableDeleted" )
                    else
                            table.removeElement(spec.rideablesInTrigger, vehicle)
                            vehicle:removeDeleteListener( self , "onAnimalRideableDeleted" )
                        end

                        if spec.animalScreenController ~ = nil then
                            spec.animalScreenController:onAnimalsChanged( self , nil )
                        end
                    end
                end
            end
        end
    end

```

### onAnimalRideableDeleted

**Description**

**Definition**

> onAnimalRideableDeleted()

**Arguments**

| any | rideable |
|-----|----------|

**Code**

```lua
function LivestockTrailer:onAnimalRideableDeleted(rideable)
    local spec = self.spec_livestockTrailer

    table.removeElement(spec.rideablesInTrigger, rideable)

    if spec.animalScreenController ~ = nil then
        spec.animalScreenController:onAnimalsChanged( self , nil )
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function LivestockTrailer:onDelete()
    self:clearAnimals()
    g_messageCenter:unsubscribe(AnimalClusterUpdateEvent, self )

    if g_currentMission ~ = nil then
        g_currentMission.husbandrySystem:removeLivestockTrailer( self )
    end

    local spec = self.spec_livestockTrailer
    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
    end

    if spec.activatable ~ = nil then
        g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
    end

    if spec.rideablesInTrigger ~ = nil then
        for _, vehicle in ipairs(spec.rideablesInTrigger) do
            vehicle:removeDeleteListener( self , "onAnimalRideableDeleted" )
        end
        table.clear(spec.rideablesInTrigger)
    end

    if spec.loadingTrigger ~ = nil then
        spec.loadingTrigger:setLoadingTrailer( nil )
        spec.loadingTrigger = nil
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
function LivestockTrailer:onLoad(savegame)
    local spec = self.spec_livestockTrailer

    spec.animalPlaces = { }
    spec.animalTypeIndexToPlaces = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.livestockTrailer.animal(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local place = { }
        place.numUsed = 0

        local animalTypeStr = self.xmlFile:getValue(key .. "#type" )
        local animalTypeIndex = g_currentMission.animalSystem:getTypeIndexByName(animalTypeStr)
        if animalTypeIndex = = nil then
            Logging.xmlWarning( self.xmlFile, "Animal type '%s' could not be found!" , animalTypeStr)
            break
        end
        place.animalTypeIndex = animalTypeIndex

        place.slots = { }
        local parent = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        local numSlots = math.abs( self.xmlFile:getValue(key .. "#numSlots" , 0 ))
        if numSlots > getNumOfChildren(parent) then
            Logging.xmlWarning( self.xmlFile, "numSlots is greater than available children for '%s'" , key)
                numSlots = getNumOfChildren(parent)
            end
            for j = 0 , numSlots - 1 do
                local slotNode = getChildAt(parent, j)
                table.insert(place.slots, { linkNode = slotNode, loadedMesh = nil , place = place } )
            end

            table.insert(spec.animalPlaces, place)
            spec.animalTypeIndexToPlaces[place.animalTypeIndex] = place

            i = i + 1
        end

        local trigger = self.xmlFile:getValue( "vehicle.livestockTrailer.loadTrigger#node" , nil , self.components, self.i3dMappings)
        if trigger ~ = nil then
            addTrigger(trigger, "onAnimalLoadTriggerCallback" , self )
            spec.triggerNode = trigger
        end
        spec.rideablesInTrigger = { }

        spec.spawnPlaces = { }
        self.xmlFile:iterate( "vehicle.livestockTrailer.spawnPlaces.spawnPlace" , function (_, key)
            local node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            local width = self.xmlFile:getValue(key .. "#width" , 5 )

            if node ~ = nil then
                table.insert(spec.spawnPlaces, { node = node, width = width } )
            end
        end )

        if #spec.spawnPlaces > 0 or spec.triggerNode ~ = nil then
            spec.activatable = LivestockTrailerActivatable.new( self )
            if g_currentMission ~ = nil then
                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            end
        end

        spec.clusterSystem = AnimalClusterSystem.new( self.isServer, self )
        g_messageCenter:subscribe(AnimalClusterUpdateEvent, self.updatedClusters, self )

        spec.loadingTrigger = nil
        spec.animalScreenController = nil

        if g_currentMission ~ = nil then
            g_currentMission.husbandrySystem:addLivestockTrailer( self )
        end
    end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function LivestockTrailer:onLoadFinished(savegame)
    if savegame ~ = nil and not savegame.resetVehicles then
        local spec = self.spec_livestockTrailer
        local xmlFile = savegame.xmlFile
        local key = savegame.key

        spec.clusterSystem:loadFromXMLFile(xmlFile, key .. ".livestockTrailer" )
        spec.clusterSystem:updateNow()
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
function LivestockTrailer:onReadStream(streamId, connection)
    local spec = self.spec_livestockTrailer
    spec.clusterSystem:readStream(streamId, connection)
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
function LivestockTrailer:onWriteStream(streamId, connection)
    local spec = self.spec_livestockTrailer
    spec.clusterSystem:writeStream(streamId, connection)
end

```

### periodChanged

**Description**

**Definition**

> periodChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function LivestockTrailer:periodChanged(superFunc)
    superFunc( self )

    local spec = self.spec_livestockTrailer
    local clusters = spec.clusterSystem:getClusters()
    for _, cluster in ipairs(clusters) do
        cluster:onPeriodChanged()
    end
end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function LivestockTrailer.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function LivestockTrailer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , LivestockTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , LivestockTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , LivestockTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , LivestockTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , LivestockTrailer )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function LivestockTrailer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentAnimalType" , LivestockTrailer.getCurrentAnimalType)
    SpecializationUtil.registerFunction(vehicleType, "getSupportsAnimalType" , LivestockTrailer.getSupportsAnimalType)
    SpecializationUtil.registerFunction(vehicleType, "getSupportsAnimalSubType" , LivestockTrailer.getSupportsAnimalSubType)
    SpecializationUtil.registerFunction(vehicleType, "setLoadingTrigger" , LivestockTrailer.setLoadingTrigger)
    SpecializationUtil.registerFunction(vehicleType, "getLoadingTrigger" , LivestockTrailer.getLoadingTrigger)
    SpecializationUtil.registerFunction(vehicleType, "updateAnimals" , LivestockTrailer.updateAnimals)
    SpecializationUtil.registerFunction(vehicleType, "updatedClusters" , LivestockTrailer.updatedClusters)
    SpecializationUtil.registerFunction(vehicleType, "clearAnimals" , LivestockTrailer.clearAnimals)
    SpecializationUtil.registerFunction(vehicleType, "addAnimals" , LivestockTrailer.addAnimals)
    SpecializationUtil.registerFunction(vehicleType, "addCluster" , LivestockTrailer.addCluster)
    SpecializationUtil.registerFunction(vehicleType, "getClusters" , LivestockTrailer.getClusters)
    SpecializationUtil.registerFunction(vehicleType, "getRideablesInTrigger" , LivestockTrailer.getRideablesInTrigger)
    SpecializationUtil.registerFunction(vehicleType, "getClusterById" , LivestockTrailer.getClusterById)
    SpecializationUtil.registerFunction(vehicleType, "getClusterSystem" , LivestockTrailer.getClusterSystem)
    SpecializationUtil.registerFunction(vehicleType, "getNumOfAnimals" , LivestockTrailer.getNumOfAnimals)
    SpecializationUtil.registerFunction(vehicleType, "getMaxNumOfAnimals" , LivestockTrailer.getMaxNumOfAnimals)
    SpecializationUtil.registerFunction(vehicleType, "getNumOfFreeAnimalSlots" , LivestockTrailer.getNumOfFreeAnimalSlots)
    SpecializationUtil.registerFunction(vehicleType, "onAnimalLoaded" , LivestockTrailer.onAnimalLoaded)
    SpecializationUtil.registerFunction(vehicleType, "onAnimalLoadTriggerCallback" , LivestockTrailer.onAnimalLoadTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "getAnimalUnloadPlaces" , LivestockTrailer.getAnimalUnloadPlaces)
    SpecializationUtil.registerFunction(vehicleType, "setAnimalScreenController" , LivestockTrailer.setAnimalScreenController)
    SpecializationUtil.registerFunction(vehicleType, "onAnimalRideableDeleted" , LivestockTrailer.onAnimalRideableDeleted)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function LivestockTrailer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalComponentMass" , LivestockTrailer.getAdditionalComponentMass)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSellPrice" , LivestockTrailer.getSellPrice)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "dayChanged" , LivestockTrailer.dayChanged)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "periodChanged" , LivestockTrailer.periodChanged)
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
function LivestockTrailer:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_livestockTrailer
    spec.clusterSystem:saveToXMLFile(xmlFile, key, usedModNames)
end

```

### setAnimalScreenController

**Description**

**Definition**

> setAnimalScreenController()

**Arguments**

| any | controller |
|-----|------------|

**Code**

```lua
function LivestockTrailer:setAnimalScreenController(controller)
    self.spec_livestockTrailer.animalScreenController = controller
end

```

### setLoadingTrigger

**Description**

**Definition**

> setLoadingTrigger()

**Arguments**

| any | trigger |
|-----|---------|

**Code**

```lua
function LivestockTrailer:setLoadingTrigger(trigger)
    self.spec_livestockTrailer.loadingTrigger = trigger
end

```

### updateAnimals

**Description**

**Definition**

> updateAnimals()

**Code**

```lua
function LivestockTrailer:updateAnimals()
    local spec = self.spec_livestockTrailer

    self:clearAnimals()

    local slotIndex = 1
    local clusters = spec.clusterSystem:getClusters()
    local animalType = self:getCurrentAnimalType()
    if animalType ~ = nil then
        local place = spec.animalTypeIndexToPlaces[animalType.typeIndex]
        place.usedSlots = 0
        for _, cluster in ipairs(clusters) do
            for i = 1 , cluster:getNumAnimals() do
                local slot = place.slots[slotIndex]
                slot.meshLoadingInProgress = true

                local visual = g_currentMission.animalSystem:getVisualByAge(cluster:getSubTypeIndex(), cluster:getAge())
                local filename = visual.visualAnimal.filenamePosed
                slot.filename = filename
                local arguments = {
                slot = slot,
                visual = visual
                }
                local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.onAnimalLoaded, self , arguments)
                slot.sharedLoadRequestId = sharedLoadRequestId

                slotIndex = slotIndex + 1
                place.usedSlots = place.usedSlots + 1
            end
        end
    end
end

```

### updatedClusters

**Description**

**Definition**

> updatedClusters()

**Arguments**

| any | trailer |
|-----|---------|

**Code**

```lua
function LivestockTrailer:updatedClusters(trailer)
    if trailer = = self then
        self:updateAnimals()
        self:setMassDirty()
    end
end

```