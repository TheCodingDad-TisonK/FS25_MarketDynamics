## PlaceableHusbandryAnimals

**Description**

> Specialization for placeables

**Functions**

- [addAnimals](#addanimals)
- [addCluster](#addcluster)
- [canBeSold](#canbesold)
- [consoleCommandAddAnimals](#consolecommandaddanimals)
- [createHusbandry](#createhusbandry)
- [getAnimalCanBeRidden](#getanimalcanberidden)
- [getAnimalDescription](#getanimaldescription)
- [getAnimalInfos](#getanimalinfos)
- [getAnimalSupportsRiding](#getanimalsupportsriding)
- [getAnimalTypeIndex](#getanimaltypeindex)
- [getCluster](#getcluster)
- [getClusterById](#getclusterbyid)
- [getClusters](#getclusters)
- [getClusterSystem](#getclustersystem)
- [getConditionInfos](#getconditioninfos)
- [getIsInAnimalDeliveryArea](#getisinanimaldeliveryarea)
- [getMaxNumOfAnimals](#getmaxnumofanimals)
- [getNeedDayChanged](#getneeddaychanged)
- [getNumOfAnimals](#getnumofanimals)
- [getNumOfClusters](#getnumofclusters)
- [getNumOfFreeAnimalSlots](#getnumoffreeanimalslots)
- [getSpecValueNumberAnimals](#getspecvaluenumberanimals)
- [getSupportsAnimalSubType](#getsupportsanimalsubtype)
- [initSpecialization](#initspecialization)
- [loadDeliveryArea](#loaddeliveryarea)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadSpecValueNumberAnimals](#loadspecvaluenumberanimals)
- [onDayChanged](#ondaychanged)
- [onDelete](#ondelete)
- [onExternalNavigationMeshLoaded](#onexternalnavigationmeshloaded)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onLoadedRideable](#onloadedrideable)
- [onMissionStarted](#onmissionstarted)
- [onPeriodChanged](#onperiodchanged)
- [onReadStream](#onreadstream)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [renameAnimal](#renameanimal)
- [saveToXMLFile](#savetoxmlfile)
- [startRiding](#startriding)
- [updatedClusters](#updatedclusters)
- [updateInfo](#updateinfo)
- [updateOutput](#updateoutput)
- [updateVisualAnimals](#updatevisualanimals)

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
function PlaceableHusbandryAnimals:addAnimals(subTypeIndex, numAnimals, age)
    local mission = g_currentMission
    local animalSystem = mission.animalSystem
    local cluster = animalSystem:createClusterFromSubTypeIndex(subTypeIndex)
    if cluster:getSupportsMerging() then
        cluster.numAnimals = numAnimals
        cluster.age = age
        cluster.subTypeIndex = subTypeIndex
        self:addCluster(cluster)
    else
            for i = 1 , numAnimals do
                cluster = animalSystem:createClusterFromSubTypeIndex(subTypeIndex)
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
function PlaceableHusbandryAnimals:addCluster(cluster)
    if cluster ~ = nil then
        local spec = self.spec_husbandryAnimals
        spec.clusterSystem:addPendingAddCluster(cluster)
        self:raiseActive()
    end
end

```

### canBeSold

**Description**

**Definition**

> canBeSold()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryAnimals:canBeSold(superFunc)
    if self:getNumOfAnimals() > 0 then
        return false , g_i18n:getText( "info_husbandryNotEmpty" )
    end

    return superFunc( self )
end

```

### consoleCommandAddAnimals

**Description**

**Definition**

> consoleCommandAddAnimals()

**Arguments**

| any | _            |
|-----|--------------|
| any | numAnimals   |
| any | subTypeIndex |

**Code**

```lua
function PlaceableHusbandryAnimals.consoleCommandAddAnimals(_, numAnimals, subTypeIndex)
    local usage = 'Usage:gsHusbandryAddAnimals numAnimals [subTypeIndex]\nUse negative number to remove animals'

    local x,y,z = getWorldTranslation(g_cameraManager:getActiveCamera())
    local mask = CollisionFlag.STATIC_OBJECT + CollisionFlag.BUILDING + CollisionFlag.ANIMAL_POSITIONING + CollisionFlag.GROUND_TIP_BLOCKING + CollisionFlag.PLACEMENT_BLOCKING + CollisionFlag.TRIGGER
    raycastAll(x,y + 100 ,z, 0 , - 1 , 0 , 110 , "consoleCommandAddAnimalsRaycastCallback" , PlaceableHusbandryAnimals , mask)

    local husbandryInstance = PlaceableHusbandryAnimals.consoleCommandCurrentHusbandry
    PlaceableHusbandryAnimals.consoleCommandCurrentHusbandry = nil
    if husbandryInstance = = nil then
        return "Error:No husbandry found.Enter a husbandry with the player first"
    end
    local spec = husbandryInstance.spec_husbandryAnimals

    numAnimals = tonumber(numAnimals) or 0
    subTypeIndex = tonumber(subTypeIndex)

    if numAnimals > 0 then
        if husbandryInstance:getNumOfFreeAnimalSlots() = = 0 then
            return "Error:Husbandry is full"
        end

        numAnimals = math.min(numAnimals, husbandryInstance:getNumOfFreeAnimalSlots())
        subTypeIndex = tonumber(subTypeIndex) or 1

        local globalSubTypeIndex = spec.animalType.subTypes[subTypeIndex]
        if globalSubTypeIndex ~ = nil then
            local mission = g_currentMission
            local newCluster = mission.animalSystem:createClusterFromSubTypeIndex(globalSubTypeIndex)
            newCluster.numAnimals = numAnimals
            spec.clusterSystem:addPendingAddCluster(newCluster)
            husbandryInstance:raiseActive()

            return "Added " .. numAnimals .. " animal(s)"
        else
                return "Error:Invalid subtype index\n" .. usage
            end
        elseif numAnimals < 0 then
                local remainingAnimals = numAnimals
                for _, cluster in pairs(husbandryInstance:getClusters()) do
                    if subTypeIndex = = nil or cluster:getSubTypeIndex() = = subTypeIndex then
                        remainingAnimals = cluster:changeNumAnimals(remainingAnimals)
                    end
                    if remainingAnimals > = 0 then
                        break
                    end
                end
                if numAnimals ~ = remainingAnimals then
                    return string.format( "Removed %d animal(s)" , math.abs(numAnimals - remainingAnimals))
                end
                if subTypeIndex ~ = nil then
                    return "Error:Husbandry has no animals of subtype " .. subTypeIndex
                end
                return "Error:Husbandry has no animals"
            end

            return "Error:Invalid number of animals\n" .. usage
        end

```

### createHusbandry

**Description**

**Definition**

> createHusbandry()

**Code**

```lua
function PlaceableHusbandryAnimals:createHusbandry()
    local spec = self.spec_husbandryAnimals
    if spec.navigationMesh = = nil then
        if self.isServer then
            Logging.xmlError( self.xmlFile, "Navigation mesh node not defined for animal husbandry!" )
                printCallstack()
            end
            return
        end

        if not getHasClassId(spec.navigationMesh, ClassIds.NAVIGATION_MESH) then
            Logging.error( "Given mesh node '%s' is not a navigation mesh!" , getName(spec.navigationMesh))
            return
        end

        -- executeConsoleCommand("showNavMesh true", true)

        if getNavMeshSurfaceArea(spec.navigationMesh) = = 0 then
            Logging.error( "Given nav mesh %q has no surface area" , getName(spec.navigationMesh))
            return
        end

        local mission = g_currentMission
        local collisionMaskFilter = CollisionMask.ANIMAL_SINGLEPLAYER
        if mission.missionDynamicInfo.isMultiplayer then
            collisionMaskFilter = CollisionMask.ANIMAL_MULTIPLAYER
        end

        mission.husbandrySystem:removeClusterHusbandry(spec.clusterHusbandry)

        local husbandryId = spec.clusterHusbandry:create(spec.animalType.configFilename, spec.navigationMesh, spec.placementRaycastDistance, collisionMaskFilter)

        if husbandryId = = nil or husbandryId = = 0 then
            Logging.error( "Could not create animal husbandry!" )
            return
        end

        if husbandryId ~ = nil then
            mission.husbandrySystem:addClusterHusbandry(spec.clusterHusbandry) -- duplicates avoided internally
        end

        SpecializationUtil.raiseEvent( self , "onHusbandryAnimalsCreated" , husbandryId)
    end

```

### getAnimalCanBeRidden

**Description**

**Definition**

> getAnimalCanBeRidden()

**Arguments**

| any | clusterId |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryAnimals:getAnimalCanBeRidden(clusterId)
    local mission = g_currentMission
    return mission.husbandrySystem:getCanAddRideable( self:getOwnerFarmId())
end

```

### getAnimalDescription

**Description**

**Definition**

> getAnimalDescription()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | cluster   |

**Code**

```lua
function PlaceableHusbandryAnimals:getAnimalDescription(superFunc, cluster)
    local text = superFunc( self , cluster)

    local mission = g_currentMission
    local visual = mission.animalSystem:getVisualByAge(cluster.subTypeIndex, cluster:getAge())

    return text .. visual.store.description
end

```

### getAnimalInfos

**Description**

**Definition**

> getAnimalInfos()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | cluster   |

**Code**

```lua
function PlaceableHusbandryAnimals:getAnimalInfos(superFunc, cluster)
    local infos = superFunc( self )

    cluster:addInfos(infos)

    return infos
end

```

### getAnimalSupportsRiding

**Description**

**Definition**

> getAnimalSupportsRiding()

**Arguments**

| any | clusterId |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryAnimals:getAnimalSupportsRiding(clusterId)
    local spec = self.spec_husbandryAnimals
    local cluster = spec.clusterSystem:getClusterById(clusterId)
    if cluster ~ = nil then
        local filename = cluster:getRidableFilename()
        if filename ~ = nil then
            return true
        end
    end

    return false
end

```

### getAnimalTypeIndex

**Description**

**Definition**

> getAnimalTypeIndex()

**Code**

```lua
function PlaceableHusbandryAnimals:getAnimalTypeIndex()
    local spec = self.spec_husbandryAnimals
    return spec.animalTypeIndex
end

```

### getCluster

**Description**

**Definition**

> getCluster()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function PlaceableHusbandryAnimals:getCluster(index)
    local spec = self.spec_husbandryAnimals
    return spec.clusterSystem:getCluster(index)
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
function PlaceableHusbandryAnimals:getClusterById(id)
    local spec = self.spec_husbandryAnimals
    return spec.clusterSystem:getClusterById(id)
end

```

### getClusters

**Description**

**Definition**

> getClusters()

**Code**

```lua
function PlaceableHusbandryAnimals:getClusters()
    local spec = self.spec_husbandryAnimals
    return spec.clusterSystem:getClusters()
end

```

### getClusterSystem

**Description**

**Definition**

> getClusterSystem()

**Code**

```lua
function PlaceableHusbandryAnimals:getClusterSystem()
    local spec = self.spec_husbandryAnimals
    return spec.clusterSystem
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
function PlaceableHusbandryAnimals:getConditionInfos(superFunc)
    local infos = superFunc( self )
    local spec = self.spec_husbandryAnimals

    local animalTypeIndex = self:getAnimalTypeIndex()
    if animalTypeIndex ~ = AnimalType.HORSE and animalTypeIndex ~ = AnimalType.PIG then
        local globalProductionFactor = self:getGlobalProductionFactor()
        local productionFactor = self:getProductionFactor()
        local productivity = globalProductionFactor * productionFactor
        spec.info.value = productivity
        spec.info.ratio = productivity
        spec.info.valueText = string.format( "%s %%" , g_i18n:formatNumber(productivity * 100 , 0 ))
        table.insert(infos, spec.info)
    end

    return infos
end

```

### getIsInAnimalDeliveryArea

**Description**

**Definition**

> getIsInAnimalDeliveryArea()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function PlaceableHusbandryAnimals:getIsInAnimalDeliveryArea(x, z)
    local spec = self.spec_husbandryAnimals

    if spec.outdoorContourPolygon ~ = nil then
        local inPolygon = spec.outdoorContourPolygon:getIsPosInside(x, z)
        return inPolygon
    end

    for _, deliveryArea in ipairs(spec.deliveryAreas) do

        local startX, _, startZ = getWorldTranslation(deliveryArea.start)
        local widthX, _, widthZ = getWorldTranslation(deliveryArea.width)
        local heightX, _, heightZ = getWorldTranslation(deliveryArea.height)

        widthX, widthZ = widthX - startX, widthZ - startZ
        heightX, heightZ = heightX - startX, heightZ - startZ

        local inArea = MathUtil.isPointInParallelogram(x, z, startX, startZ, widthX, widthZ, heightX, heightZ)

        if inArea then
            return true
        end
    end

    if #spec.deliveryAreas = = 0 then
        local px, _, pz = getWorldTranslation( self.rootNode)
        if MathUtil.vector2Length(px - x, pz - z) < 30 then
            return true
        end
    end

    return false

end

```

### getMaxNumOfAnimals

**Description**

**Definition**

> getMaxNumOfAnimals()

**Code**

```lua
function PlaceableHusbandryAnimals:getMaxNumOfAnimals()
    local spec = self.spec_husbandryAnimals
    return spec.maxNumAnimals or spec.baseMaxNumAnimals
end

```

### getNeedDayChanged

**Description**

**Definition**

> getNeedDayChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryAnimals:getNeedDayChanged(superFunc)
    return true
end

```

### getNumOfAnimals

**Description**

**Definition**

> getNumOfAnimals()

**Code**

```lua
function PlaceableHusbandryAnimals:getNumOfAnimals()
    local spec = self.spec_husbandryAnimals
    local numAnimals = 0
    local clusters = spec.clusterSystem:getClusters()
    for _, cluster in ipairs(clusters) do
        numAnimals = numAnimals + cluster.numAnimals
    end

    return numAnimals
end

```

### getNumOfClusters

**Description**

**Definition**

> getNumOfClusters()

**Code**

```lua
function PlaceableHusbandryAnimals:getNumOfClusters()
    local spec = self.spec_husbandryAnimals
    local clusters = spec.clusterSystem:getClusters()
    return #clusters
end

```

### getNumOfFreeAnimalSlots

**Description**

**Definition**

> getNumOfFreeAnimalSlots()

**Code**

```lua
function PlaceableHusbandryAnimals:getNumOfFreeAnimalSlots()
    local totalNumAnimals = self:getNumOfAnimals()
    local maxNumAnimals = self:getMaxNumOfAnimals()
    return math.max(maxNumAnimals - totalNumAnimals, 0 )
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

**Code**

```lua
function PlaceableHusbandryAnimals.getSpecValueNumberAnimals(storeItem, realItem)
    local data = storeItem.specs.numberAnimals
    if data = = nil then
        return nil
    end

    local profile = nil

    local mission = g_currentMission
    local animalTypeIndex = mission.animalSystem:getTypeIndexByName(data.animalTypeName)
    if animalTypeIndex = = AnimalType.COW then
        profile = "shopListAttributeIconCow"
    elseif animalTypeIndex = = AnimalType.SHEEP then
            profile = "shopListAttributeIconSheep"
        elseif animalTypeIndex = = AnimalType.HORSE then
                profile = "shopListAttributeIconHorse"
            elseif animalTypeIndex = = AnimalType.PIG then
                    profile = "shopListAttributeIconPig"
                elseif animalTypeIndex = = AnimalType.CHICKEN then
                        profile = "shopListAttributeIconChicken"
                    end

                    return data.maxNumAnimals, profile
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
function PlaceableHusbandryAnimals:getSupportsAnimalSubType(subTypeIndex)
    local spec = self.spec_husbandryAnimals
    local mission = g_currentMission
    local animalSystem = mission.animalSystem
    local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
    return spec.animalTypeIndex = = subType.typeIndex
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableHusbandryAnimals.initSpecialization()
    g_storeManager:addSpecType( "numberAnimals" , "shopListAttributeIconCapacity" , PlaceableHusbandryAnimals.loadSpecValueNumberAnimals, PlaceableHusbandryAnimals.getSpecValueNumberAnimals, StoreSpecies.PLACEABLE)

    if g_isDevelopmentVersion then
        addConsoleCommand( "gsHusbandryAddAnimals" , "Add or remove animals from husbandry where player is currently located" , "consoleCommandAddAnimals" , PlaceableHusbandryAnimals , "numAnimals; [subTypeIndex]" )
        addConsoleCommand( "gsHusbandryDebugToggle" , "Toggle husbandry debug mode" , "consoleCommandToggleDebug" , PlaceableHusbandryAnimals )
    end
end

```

### loadDeliveryArea

**Description**

**Definition**

> loadDeliveryArea()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | area    |

**Code**

```lua
function PlaceableHusbandryAnimals:loadDeliveryArea(xmlFile, key, area)
    local start = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    if start = = nil then
        Logging.xmlWarning(xmlFile, "Delivery area start node not defined for '%s'" , key)
            return false
        end

        local width = xmlFile:getValue(key .. "#widthNode" , nil , self.components, self.i3dMappings)
        if width = = nil then
            Logging.xmlWarning(xmlFile, "Delivery area width node not defined for '%s'" , key)
                return false
            end

            local height = xmlFile:getValue(key .. "#heightNode" , nil , self.components, self.i3dMappings)
            if height = = nil then
                Logging.xmlWarning(xmlFile, "Delivery area height node not defined for '%s'" , key)
                    return false
                end

                area.start = start
                area.width = width
                area.height = height

                return true
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
function PlaceableHusbandryAnimals:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_husbandryAnimals
    spec.clusterSystem:loadFromXMLFile(xmlFile, key .. ".clusters" )
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

**Code**

```lua
function PlaceableHusbandryAnimals.loadSpecValueNumberAnimals(xmlFile, customEnvironment, baseDir)
    local data = nil

    if xmlFile:hasProperty( "placeable.husbandry.animals" ) then
        local maxNumAnimals = xmlFile:getInt( "placeable.husbandry.animals#maxNumAnimals" , 16 )
        local animalTypeName = xmlFile:getString( "placeable.husbandry.animals#type" )
        data = { maxNumAnimals = maxNumAnimals, animalTypeName = animalTypeName }
    end

    return data
end

```

### onDayChanged

**Description**

**Definition**

> onDayChanged()

**Code**

```lua
function PlaceableHusbandryAnimals:onDayChanged()
    if self.isServer then
        local spec = self.spec_husbandryAnimals
        local clusters = spec.clusterSystem:getClusters()
        for _, cluster in ipairs(clusters) do
            cluster:onDayChanged()
        end
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHusbandryAnimals:onDelete()
    local spec = self.spec_husbandryAnimals

    g_messageCenter:unsubscribe(AnimalClusterUpdateEvent, self )
    g_messageCenter:unsubscribe(MessageType.CURRENT_MISSION_START, self )

    self:deleteNavigationMeshPlacementCollision()

    if spec.clusterHusbandry ~ = nil then
        local mission = g_currentMission
        mission.husbandrySystem:removeClusterHusbandry(spec.clusterHusbandry)
        spec.clusterHusbandry:delete()
        spec.clusterHusbandry = nil
    end
    if spec.animalLoadingTrigger ~ = nil then
        spec.animalLoadingTrigger:delete()
        spec.animalLoadingTrigger = nil
    end

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
    end
end

```

### onExternalNavigationMeshLoaded

**Description**

**Definition**

> onExternalNavigationMeshLoaded()

**Arguments**

| any | node         |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableHusbandryAnimals:onExternalNavigationMeshLoaded(node, failedReason, args)
    local spec = self.spec_husbandryAnimals

    local loadingTask = args.loadingTask

    if node = = 0 or node = = nil then
        self:finishLoadingTask(loadingTask)
        Logging.error( "Missing navigation mesh in external navigation mesh file!" )
        return
    end

    if spec.navigationMeshRootNode ~ = nil then
        spec.navigationMesh = I3DUtil.indexToObject(node, spec.navigationMeshNodePath)
        link(spec.navigationMeshRootNode, spec.navigationMesh)
    end
    delete(node)

    self:finishLoadingTask(loadingTask)
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryAnimals:onFinalizePlacement()
    self:createNavigationMesh()

    if self.isLoadedFromSavegame then
        g_messageCenter:subscribeOneshot(MessageType.CURRENT_MISSION_START, PlaceableHusbandryAnimals.onMissionStarted, self )
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
function PlaceableHusbandryAnimals:onLoad(savegame)
    local spec = self.spec_husbandryAnimals
    local xmlFile = self.xmlFile

    spec.infoHealth = { title = g_i18n:getText( "ui_horseHealth" ), text = "" }
    spec.infoNumAnimals = { title = g_i18n:getText( "ui_numAnimals" ), text = "" }
    spec.updateVisuals = false

    local animalTypeName = xmlFile:getValue( "placeable.husbandry.animals#type" )
    if animalTypeName = = nil then
        Logging.xmlError(xmlFile, "Missing animal type!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    local mission = g_currentMission
    spec.animalType = mission.animalSystem:getTypeByName(animalTypeName)
    if spec.animalType = = nil then
        Logging.xmlError(xmlFile, "Animal type '%s' not found!" , animalTypeName)
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    spec.animalTypeIndex = spec.animalType.typeIndex

    spec.navigationMeshRootNode = xmlFile:getValue( "placeable.husbandry.animals.navigation#rootNode" , nil , self.components, self.i3dMappings)
    spec.navigationMesh = xmlFile:getValue( "placeable.husbandry.animals.navigation#node" , nil , self.components, self.i3dMappings)
    local navigationMeshShape = xmlFile:getValue( "placeable.husbandry.animals.navigation#shape" , nil , self.components, self.i3dMappings)
    if navigationMeshShape ~ = nil then
        local navMeshShapeValid = true
        if not getHasClassId(navigationMeshShape, ClassIds.SHAPE) then
            Logging.xmlError(xmlFile, "Given navigation shape %q at %q is not of type 'SHAPE'" , getName(navigationMeshShape), "placeable.husbandry.animals.navigation#shape" )
            navMeshShapeValid = false
        end

        if getHasClassId(navigationMeshShape, ClassIds.NAVIGATION_MESH) then
            Logging.xmlError(xmlFile, "Given navigation shape %q at %q is a navigation mesh instead of a regular shape" , getName(navigationMeshShape), "placeable.husbandry.animals.navigation#shape" )
            navMeshShapeValid = false
        end

        if navMeshShapeValid and not getShapeIsCPUMesh(navigationMeshShape) then
            Logging.xmlError(xmlFile, "Given navigation shape %q at %q is missing the 'CPU Mesh' flag" , getName(navigationMeshShape), "placeable.husbandry.animals.navigation#shape" )
            navMeshShapeValid = false
        end

        if navMeshShapeValid then
            setIsNonRenderable(navigationMeshShape, true )
            spec.navigationMeshShape = navigationMeshShape
        end
    end
    local navigationMeshFilename = xmlFile:getValue( "placeable.husbandry.animals.navigation#filename" , nil )
    if navigationMeshFilename ~ = nil then
        navigationMeshFilename = Utils.getFilename(navigationMeshFilename, self.baseDirectory)
        local loadingTask = self:createLoadingTask(spec)
        spec.navigationMeshNodePath = xmlFile:getValue( "placeable.husbandry.animals.navigation#nodePath" , "0" )

        local arguments = {
        loadingTask = loadingTask
        }
        spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(navigationMeshFilename, true , false , self.onExternalNavigationMeshLoaded, self , arguments)
    end

    -- polygon for the nav mesh area defined by the fence outline, excluding the area defined by the navigationMeshShape
        spec.outdoorContourPolygon = nil

        spec.placementRaycastDistance = xmlFile:getValue( "placeable.husbandry.animals#placementRaycastDistance" , 10.0 )
        spec.sqmPerAnimal = self.xmlFile:getValue( "placeable.husbandry.animals#sqmPerAnimal" , spec.animalType.sqmPerAnimal)
        spec.configMaxNumAnimals = xmlFile:getValue( "placeable.husbandry.animals#maxNumAnimals" , 16 )
        spec.baseMaxNumAnimals = self.xmlFile:getValue( "placeable.husbandry.animals#baseMaxNumAnimals" , spec.configMaxNumAnimals)
        spec.configMaxNumVisualAnimals = self.xmlFile:getValue( "placeable.husbandry.animals#maxNumVisualAnimals" )

        spec.clusterHusbandry = AnimalClusterHusbandry.new( self , animalTypeName, 0 ) --spec.maxNumVisualAnimals)

        spec.clusterSystem = AnimalClusterSystem.new( self.isServer, self )
        g_messageCenter:subscribe(AnimalClusterUpdateEvent, self.updatedClusters, self )

        local animalLoadingTriggerNode = xmlFile:getValue( "placeable.husbandry.animals.loadingTrigger#node" , nil , self.components, self.i3dMappings)
        if animalLoadingTriggerNode ~ = nil then
            spec.animalLoadingTrigger = AnimalLoadingTrigger.new( self.isServer, self.isClient)
            if not spec.animalLoadingTrigger:load(animalLoadingTriggerNode, self ) then
                spec.animalLoadingTrigger:delete()
            end
        end

        spec.deliveryAreas = { }
        self.xmlFile:iterate( "placeable.husbandry.animals.deliveryAreas.deliveryArea" , function (_, key)
            local area = { }
            if self:loadDeliveryArea( self.xmlFile, key, area) then
                table.insert(spec.deliveryAreas, area)
            end
        end )

        spec.info = { title = g_i18n:getText( "statistic_productivity" ), text = "" }

        if not self.isServer or not g_isDevelopmentVersion then
            removeConsoleCommand( "gsHusbandryAddAnimals" )
        end
    end

```

### onLoadedRideable

**Description**

**Definition**

> onLoadedRideable()

**Arguments**

| any | vehicles         |
|-----|------------------|
| any | vehicleLoadState |
| any | arguments        |

**Code**

```lua
function PlaceableHusbandryAnimals:onLoadedRideable(vehicles, vehicleLoadState, arguments)
    local cluster = arguments.cluster

    if vehicleLoadState ~ = VehicleLoadingState.OK or #vehicles = = 0 then
        local spec = self.spec_husbandryAnimals
        cluster:changeNumAnimals( 1 )
        spec.clusterSystem:updateNow()

        return
    end

    local newCluster = cluster:clone()
    newCluster:changeNumAnimals( 1 )
    vehicles[ 1 ]:setCluster(newCluster)
    vehicles[ 1 ]:setPlayerToEnter(arguments.player)
end

```

### onMissionStarted

**Description**

**Definition**

> onMissionStarted()

**Arguments**

| any | isNewSavegame |
|-----|---------------|

**Code**

```lua
function PlaceableHusbandryAnimals:onMissionStarted(isNewSavegame)
    -- process animalsToLoad on onMissionStarted because dedi server is paused on start up and
    -- therefore animals are first loaded if the first player joins.In this state husbandry is already synced with player
        -- and no animals are visible for first player joining the server
            self:updateVisualAnimals()
        end

```

### onPeriodChanged

**Description**

**Definition**

> onPeriodChanged()

**Code**

```lua
function PlaceableHusbandryAnimals:onPeriodChanged()
    if self.isServer then
        local spec = self.spec_husbandryAnimals
        local clusters = spec.clusterSystem:getClusters()

        local totalNumAnimals = self:getNumOfAnimals()
        local maxNumAnimals = self:getMaxNumOfAnimals()
        local freeSlots = math.max(maxNumAnimals - totalNumAnimals, 0 )

        local mission = g_currentMission
        local animalSystem = mission.animalSystem
        for _, cluster in ipairs(clusters) do
            cluster:onPeriodChanged()

            local numNewAnimals = cluster:updateReproduction()
            if numNewAnimals > 0 then
                numNewAnimals = math.min(freeSlots, numNewAnimals)
                if numNewAnimals > 0 then
                    local newCluster = animalSystem:createClusterFromSubTypeIndex(cluster:getSubTypeIndex())
                    newCluster.numAnimals = numNewAnimals
                    freeSlots = freeSlots - numNewAnimals

                    spec.clusterSystem:addPendingAddCluster(newCluster)

                    local subType = animalSystem:getSubTypeByIndex(cluster:getSubTypeIndex())
                    if subType.statsBreedingName ~ = nil then
                        g_farmManager:updateFarmStats( self:getOwnerFarmId(), subType.statsBreedingName, newCluster.numAnimals)
                    end
                end
            end
        end

        self:raiseActive()
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
function PlaceableHusbandryAnimals:onReadStream(streamId, connection)
    local spec = self.spec_husbandryAnimals
    spec.clusterSystem:readStream(streamId, connection)
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PlaceableHusbandryAnimals:onUpdate(dt)
    local spec = self.spec_husbandryAnimals
    if self.isServer then
        spec.clusterSystem:update(dt)
    end

    if spec.clusterHusbandry ~ = nil then
        spec.clusterHusbandry:update(dt)
    end

    if spec.updateVisuals then
        self:updateVisualAnimals()
        spec.updateVisuals = false
    end

    if spec.clusterHusbandry:getNeedsUpdate() then
        self:raiseActive()
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
function PlaceableHusbandryAnimals:onWriteStream(streamId, connection)
    local spec = self.spec_husbandryAnimals
    spec.clusterSystem:writeStream(streamId, connection)
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
function PlaceableHusbandryAnimals.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableHusbandry , specializations)
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
function PlaceableHusbandryAnimals.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onPeriodChanged" , PlaceableHusbandryAnimals )
    SpecializationUtil.registerEventListener(placeableType, "onDayChanged" , PlaceableHusbandryAnimals )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableHusbandryAnimals.registerEvents(placeableType)
    SpecializationUtil.registerEvent(placeableType, "onHusbandryAnimalsCreated" )
    SpecializationUtil.registerEvent(placeableType, "onHusbandryAnimalsUpdate" )
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
function PlaceableHusbandryAnimals.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onExternalNavigationMeshLoaded" , PlaceableHusbandryAnimals.onExternalNavigationMeshLoaded)
    SpecializationUtil.registerFunction(placeableType, "createNavigationMeshFromContour" , PlaceableHusbandryAnimals.createNavigationMeshFromContour)
    SpecializationUtil.registerFunction(placeableType, "createNavigationMesh" , PlaceableHusbandryAnimals.createNavigationMesh)
    SpecializationUtil.registerFunction(placeableType, "setMaxNumAnimals" , PlaceableHusbandryAnimals.setMaxNumAnimals)
    SpecializationUtil.registerFunction(placeableType, "createHusbandry" , PlaceableHusbandryAnimals.createHusbandry)
    SpecializationUtil.registerFunction(placeableType, "updateVisualAnimals" , PlaceableHusbandryAnimals.updateVisualAnimals)
    SpecializationUtil.registerFunction(placeableType, "getNumOfFreeAnimalSlots" , PlaceableHusbandryAnimals.getNumOfFreeAnimalSlots)
    SpecializationUtil.registerFunction(placeableType, "getNumOfAnimals" , PlaceableHusbandryAnimals.getNumOfAnimals)
    SpecializationUtil.registerFunction(placeableType, "getMaxNumOfAnimals" , PlaceableHusbandryAnimals.getMaxNumOfAnimals)
    SpecializationUtil.registerFunction(placeableType, "getNumOfClusters" , PlaceableHusbandryAnimals.getNumOfClusters)
    SpecializationUtil.registerFunction(placeableType, "getSupportsAnimalSubType" , PlaceableHusbandryAnimals.getSupportsAnimalSubType)
    SpecializationUtil.registerFunction(placeableType, "getClusters" , PlaceableHusbandryAnimals.getClusters)
    SpecializationUtil.registerFunction(placeableType, "getCluster" , PlaceableHusbandryAnimals.getCluster)
    SpecializationUtil.registerFunction(placeableType, "getClusterById" , PlaceableHusbandryAnimals.getClusterById)
    SpecializationUtil.registerFunction(placeableType, "getClusterSystem" , PlaceableHusbandryAnimals.getClusterSystem)
    SpecializationUtil.registerFunction(placeableType, "getAnimalTypeIndex" , PlaceableHusbandryAnimals.getAnimalTypeIndex)
    SpecializationUtil.registerFunction(placeableType, "renameAnimal" , PlaceableHusbandryAnimals.renameAnimal)
    SpecializationUtil.registerFunction(placeableType, "addCluster" , PlaceableHusbandryAnimals.addCluster)
    SpecializationUtil.registerFunction(placeableType, "addAnimals" , PlaceableHusbandryAnimals.addAnimals)
    SpecializationUtil.registerFunction(placeableType, "updatedClusters" , PlaceableHusbandryAnimals.updatedClusters)
    SpecializationUtil.registerFunction(placeableType, "consoleCommandAddAnimals" , PlaceableHusbandryAnimals.consoleCommandAddAnimals)
    SpecializationUtil.registerFunction(placeableType, "getAnimalSupportsRiding" , PlaceableHusbandryAnimals.getAnimalSupportsRiding)
    SpecializationUtil.registerFunction(placeableType, "getAnimalCanBeRidden" , PlaceableHusbandryAnimals.getAnimalCanBeRidden)
    SpecializationUtil.registerFunction(placeableType, "startRiding" , PlaceableHusbandryAnimals.startRiding)
    SpecializationUtil.registerFunction(placeableType, "onLoadedRideable" , PlaceableHusbandryAnimals.onLoadedRideable)
    SpecializationUtil.registerFunction(placeableType, "getIsInAnimalDeliveryArea" , PlaceableHusbandryAnimals.getIsInAnimalDeliveryArea)
    SpecializationUtil.registerFunction(placeableType, "loadDeliveryArea" , PlaceableHusbandryAnimals.loadDeliveryArea)
    SpecializationUtil.registerFunction(placeableType, "getOutdoorContourPolygon" , PlaceableHusbandryAnimals.getOutdoorContourPolygon)
    SpecializationUtil.registerFunction(placeableType, "createNavigationMeshPlacementCollision" , PlaceableHusbandryAnimals.createNavigationMeshPlacementCollision)
    SpecializationUtil.registerFunction(placeableType, "deleteNavigationMeshPlacementCollision" , PlaceableHusbandryAnimals.deleteNavigationMeshPlacementCollision)
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
function PlaceableHusbandryAnimals.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getNeedDayChanged" , PlaceableHusbandryAnimals.getNeedDayChanged)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableHusbandryAnimals.updateInfo)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateOutput" , PlaceableHusbandryAnimals.updateOutput)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "canBeSold" , PlaceableHusbandryAnimals.canBeSold)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getConditionInfos" , PlaceableHusbandryAnimals.getConditionInfos)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getAnimalInfos" , PlaceableHusbandryAnimals.getAnimalInfos)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getAnimalDescription" , PlaceableHusbandryAnimals.getAnimalDescription)
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
function PlaceableHusbandryAnimals.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    AnimalClusterSystem.registerSavegameXMLPaths(schema, basePath .. ".clusters" )
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
function PlaceableHusbandryAnimals.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.animals"
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".navigation#rootNode" , "Navigation mesh rootnode" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".navigation#node" , "Navigation mesh node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".navigation#shape" , "Shape to generate navigation mesh from" )
    schema:register(XMLValueType.STRING, basePath .. ".navigation#filename" , "Filename for an external navigation mesh" )
        schema:register(XMLValueType.STRING, basePath .. ".navigation#nodePath" , "Nodepath for an external navigation mesh" )
            schema:register(XMLValueType.STRING, basePath .. "#type" , "Animal type" )
            schema:register(XMLValueType.STRING, basePath .. "#filename" , "Animal configuration file" )
            schema:register(XMLValueType.FLOAT, basePath .. "#placementRaycastDistance" , "Placement raycast distance" , 2 )
            schema:register(XMLValueType.INT, basePath .. "#maxNumAnimals" , "Max number of animals" , 16 )
            schema:register(XMLValueType.INT, basePath .. "#baseMaxNumAnimals" , "Base max number of animals without outoor area" , 16 )
            schema:register(XMLValueType.INT, basePath .. "#sqmPerAnimal" , "Square meter need per animal" )
            schema:register(XMLValueType.INT, basePath .. "#maxNumVisualAnimals" , "Max number of visual animals" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".loadingTrigger#node" , "Animal loading trigger" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".deliveryAreas.deliveryArea(?)#startNode" , "Animal delivery area start node" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".deliveryAreas.deliveryArea(?)#widthNode" , "Animal delivery area width node" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".deliveryAreas.deliveryArea(?)#heightNode" , "Animal delivery area height node" )
            schema:setXMLSpecializationType()
        end

```

### renameAnimal

**Description**

**Definition**

> renameAnimal()

**Arguments**

| any | clusterId   |
|-----|-------------|
| any | name        |
| any | noEventSend |

**Code**

```lua
function PlaceableHusbandryAnimals:renameAnimal(clusterId, name, noEventSend)
    local spec = self.spec_husbandryAnimals
    AnimalNameEvent.sendEvent( self , clusterId, name, noEventSend)

    local cluster = spec.clusterSystem:getClusterById(clusterId)
    if cluster ~ = nil then
        cluster:setName(name)
    end
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
function PlaceableHusbandryAnimals:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_husbandryAnimals
    spec.clusterSystem:saveToXMLFile(xmlFile, key .. ".clusters" , usedModNames)
end

```

### startRiding

**Description**

**Definition**

> startRiding()

**Arguments**

| any | clusterId |
|-----|-----------|
| any | player    |

**Code**

```lua
function PlaceableHusbandryAnimals:startRiding(clusterId, player)
    if not self.isServer then
        g_client:getServerConnection():sendEvent( AnimalRidingEvent.new( self , clusterId, player))
    else
            local spec = self.spec_husbandryAnimals
            local cluster = spec.clusterSystem:getClusterById(clusterId)
            if cluster ~ = nil then
                local x, y, z, rx, ry, rz = spec.clusterHusbandry:getAnimalPosition(clusterId)

                if x ~ = nil then
                    local farmId = self:getOwnerFarmId()
                    local filename = cluster:getRidableFilename()
                    local arguments = {
                    player = player,
                    cluster = cluster
                    }

                    cluster:changeNumAnimals( - 1 )
                    spec.clusterSystem:updateNow()

                    local data = VehicleLoadingData.new()
                    data:setFilename(filename)
                    data:setPosition(x, y, z)
                    data:setRotation(rx, ry, rz)
                    data:setPropertyState(VehiclePropertyState.OWNED)
                    data:setOwnerFarmId(farmId)

                    data:load( self.onLoadedRideable, self , arguments)
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

| any | husbandry |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryAnimals:updatedClusters(husbandry)
    if husbandry = = self then
        local spec = self.spec_husbandryAnimals
        local clusters = spec.clusterSystem:getClusters()

        SpecializationUtil.raiseEvent( self , "onHusbandryAnimalsUpdate" , clusters)

        g_messageCenter:publish(MessageType.HUSBANDRY_ANIMALS_CHANGED, self )

        spec.updateVisuals = true
        self:raiseActive()
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
function PlaceableHusbandryAnimals:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)

    local spec = self.spec_husbandryAnimals
    local health = 0
    local numAnimals = 0
    local clusters = spec.clusterSystem:getClusters()
    local numClusters = #clusters
    if numClusters > 0 then
        for _, cluster in ipairs(clusters) do
            health = health + cluster.health
            numAnimals = numAnimals + cluster.numAnimals
        end

        health = health / numClusters
    end

    spec.infoNumAnimals.text = string.format( "%d / %d" , numAnimals, self:getMaxNumOfAnimals())
    spec.infoHealth.text = string.format( "%d %%" , health)
    table.insert(infoTable, spec.infoNumAnimals)
    table.insert(infoTable, spec.infoHealth)
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
function PlaceableHusbandryAnimals:updateOutput(superFunc, foodFactor, productionFactor, globalProductionFactor)
    if self.isServer then
        local spec = self.spec_husbandryAnimals
        local clusters = spec.clusterSystem:getClusters()
        for _, cluster in ipairs(clusters) do
            cluster:updateHealth(foodFactor)
        end

        self:raiseActive()
    end

    superFunc( self , foodFactor, productionFactor, globalProductionFactor)
end

```

### updateVisualAnimals

**Description**

**Definition**

> updateVisualAnimals()

**Code**

```lua
function PlaceableHusbandryAnimals:updateVisualAnimals()
    local spec = self.spec_husbandryAnimals
    local clusters = spec.clusterSystem:getClusters()
    spec.clusterHusbandry:setClusters(clusters)
    self:raiseActive()
end

```