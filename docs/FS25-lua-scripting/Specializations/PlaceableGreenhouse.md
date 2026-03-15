## PlaceableGreenhouse

**Description**

> Specialization for placeables

**Functions**

- [addPlantPlace](#addplantplace)
- [getRandomGrowthInterval](#getrandomgrowthinterval)
- [getRandomWateringInterval](#getrandomwateringinterval)
- [initSpecialization](#initspecialization)
- [loadPlantFromXml](#loadplantfromxml)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onOutputFillTypesChanged](#onoutputfilltypeschanged)
- [onProductionStatusChanged](#onproductionstatuschanged)
- [onUpdate](#onupdate)
- [plantI3DLoadedCallback](#planti3dloadedcallback)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setPlantAtPlace](#setplantatplace)
- [updatePlantDistribution](#updateplantdistribution)
- [updatePlantsStage](#updateplantsstage)

### addPlantPlace

**Description**

**Definition**

> addPlantPlace()

**Arguments**

| any | node          |
|-----|---------------|
| any | useRandomYRot |

**Code**

```lua
function PlaceableGreenhouse:addPlantPlace(node, useRandomYRot)
    local spec = self.spec_greenhouse

    useRandomYRot = Utils.getNoNil(useRandomYRot, true )
    if useRandomYRot then
        setRotation(node, 0 , math.random() * math.pi * 2 , 0 )
    end
    table.insert(spec.plantPlaces, { node = node, fillType = nil , stage = nil } )
end

```

### getRandomGrowthInterval

**Description**

**Definition**

> getRandomGrowthInterval()

**Code**

```lua
function PlaceableGreenhouse.getRandomGrowthInterval()
    return math.random( PlaceableGreenhouse.GROWTH_INTERVAL_MIN, PlaceableGreenhouse.GROWTH_INTERVAL_MAX)
end

```

### getRandomWateringInterval

**Description**

**Definition**

> getRandomWateringInterval()

**Code**

```lua
function PlaceableGreenhouse.getRandomWateringInterval()
    return math.random( PlaceableGreenhouse.WATERING_INTERVAL_MIN, PlaceableGreenhouse.WATERING_INTERVAL_MAX)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableGreenhouse.initSpecialization()
    local plantXmlSchema = XMLSchema.new( "greenhousePlant" )
    plantXmlSchema:register(XMLValueType.STRING, "greenhousePlant.i3dFilename" , "i3d file of plant" )
    plantXmlSchema:register(XMLValueType.NODE_INDEX, "greenhousePlant.stages.growing(?)#node" , "Growing mesh" )
    plantXmlSchema:register(XMLValueType.NODE_INDEX, "greenhousePlant.stages.withered#node" , "Withered mesh" )

    I3DUtil.registerI3dMappingXMLPaths(plantXmlSchema, "greenhousePlant" )

    PlaceableGreenhouse.plantXmlSchema = plantXmlSchema
end

```

### loadPlantFromXml

**Description**

**Definition**

> loadPlantFromXml()

**Arguments**

| any | xmlFilename |
|-----|-------------|

**Code**

```lua
function PlaceableGreenhouse:loadPlantFromXml(xmlFilename)
    local plant = {
    i3dFilename = "" ,
    i3dNode = nil ,
    stages = { -- stagse are stored as child indices of meshes -> allows working on cloned nodes without managing node ids
    growing = { } , -- growing stages from small to big
    first = nil ,
    last = nil ,
    withered = nil ,
    }
    }

    local plantXmlFile = XMLFile.load( "plantXml" , xmlFilename, PlaceableGreenhouse.plantXmlSchema)
    if plantXmlFile ~ = nil then
        local spec = self.spec_greenhouse
        spec.plantXMLFiles[plantXmlFile] = true

        local i3dFilename = plantXmlFile:getValue( "greenhousePlant.i3dFilename" )
        if i3dFilename ~ = nil then
            plant.i3dFilename = Utils.getFilename(i3dFilename, self.baseDirectory)

            local loadingTask = self:createLoadingTask()

            local arguments = {
            plant = plant,
            plantXmlFile = plantXmlFile,
            loadingTask = loadingTask
            }
            plant.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(plant.i3dFilename, false , false , self.plantI3DLoadedCallback, self , arguments)
        end
    end

    return plant
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableGreenhouse:onDelete()
    local spec = self.spec_greenhouse

    if spec.plantXMLFiles ~ = nil then
        for plantXMLFile, _ in pairs(spec.plantXMLFiles) do
            plantXMLFile:delete()
            spec.plantXMLFiles[plantXMLFile] = nil
        end
    end

    if spec.growthTimer ~ = nil then
        spec.growthTimer:delete()
    end
    if spec.wateringTimer ~ = nil then
        spec.wateringTimer:delete()
    end

    if spec.filltypeIdToPlant ~ = nil then
        for _, plant in pairs(spec.filltypeIdToPlant) do
            if plant.sharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile(plant.sharedLoadRequestId)
            end

            if plant.i3dNode ~ = nil then
                delete(plant.i3dNode)
                plant.i3dNode = nil
            end
        end
    end

    g_effectManager:deleteEffects(spec.effects)
    g_soundManager:deleteSamples(spec.samples)
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableGreenhouse:onFinalizePlacement()
    self.plantDistributionDirty = true
    self.spec_greenhouse.wateringTimer:start()
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
function PlaceableGreenhouse:onLoad(savegame)
    local spec = self.spec_greenhouse
    local xmlFile = self.xmlFile
    local key = "placeable.greenhouse"

    spec.filltypeIdToPlant = { }
    spec.plantPlaces = { }

    spec.activeFilltypes = { }
    spec.hasWater = true
    spec.plantXMLFiles = { }

    for _, plantKey in xmlFile:iterator(key .. ".plants.plant" ) do
        local fillTypeName = xmlFile:getValue(plantKey .. "#fillType" )
        local fillType = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
        if fillType ~ = nil then
            local plantXmlFilename = xmlFile:getValue(plantKey .. "#xmlFilename" )
            if plantXmlFilename ~ = nil then
                plantXmlFilename = Utils.getFilename(plantXmlFilename, self.baseDirectory)
                local plant = self:loadPlantFromXml(plantXmlFilename)
                if plant ~ = nil then
                    spec.filltypeIdToPlant[fillType] = plant
                end
            end
        else
                Logging.xmlWarning(xmlFile, "Unknown fillType '%s' for plant '%s'" , fillTypeName, plantKey)
                end
            end

            for _, plantSpaceKey in xmlFile:iterator(key .. ".plantSpaces.space" ) do
                local plantPlaceNode = self.xmlFile:getValue(plantSpaceKey .. "#node" , nil , self.components, self.i3dMappings)
                local useRandomYRot = self.xmlFile:getValue(plantSpaceKey .. "#useRandomYRot" , true )
                if plantPlaceNode ~ = nil then
                    self:addPlantPlace(plantPlaceNode, useRandomYRot)
                end
            end

            for _, plantParentKey in xmlFile:iterator(key .. ".plantSpaces.spacesParent" ) do
                local parentNode = self.xmlFile:getValue(plantParentKey .. "#node" , nil , self.components, self.i3dMappings)
                local useRandomYRot = self.xmlFile:getValue(plantParentKey .. "#useRandomYRot" , true )
                local numChildren = getNumOfChildren(parentNode)
                if numChildren > 0 then
                    for i = 0 , numChildren - 1 do
                        self:addPlantPlace(getChildAt(parentNode, i), useRandomYRot)
                    end
                else
                        Logging.xmlWarning(xmlFile, "No i3d child nodes for '%s'" , plantParentKey)
                        end
                    end

                    if self.isClient then
                        spec.samples = { }
                        spec.samples.watering = g_soundManager:loadSampleFromXML(xmlFile, key .. ".sounds" , "watering" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, nil )

                        spec.effects = g_effectManager:loadEffect(xmlFile, key .. ".effectNodes" , self.components, self , self.i3dMappings)
                    end

                    spec.growthTimer = Timer.new( PlaceableGreenhouse.getRandomGrowthInterval())
                    spec.growthTimer:setFinishCallback( function (timerInstance)
                        timerInstance:setDuration( PlaceableGreenhouse.getRandomGrowthInterval())
                        self:updatePlantsStage() -- restarts timer if reasonable
                        end )
                        spec.growthTimer:setScaleFunction( function ()
                            return g_currentMission:getEffectiveTimeScale()
                        end )

                        spec.wateringTimer = Timer.new( PlaceableGreenhouse.getRandomWateringInterval())
                        spec.wateringTimer:setFinishCallback( function (timerInstance)
                            if spec.hasWater then
                                g_effectManager:startEffects(spec.effects)
                                g_soundManager:playSample(spec.samples.watering)

                                Timer.createOneshot( PlaceableGreenhouse.WATERING_DURATION, function ()
                                    g_effectManager:stopEffects(spec.effects)
                                    g_soundManager:stopSample(spec.samples.watering)
                                end , function () return g_currentMission:getEffectiveTimeScale() end )
                                timerInstance:start() -- restart for next watering
                                end
                            end )
                            spec.wateringTimer:setScaleFunction( function ()
                                return g_currentMission:getEffectiveTimeScale()
                            end )
                        end

```

### onOutputFillTypesChanged

**Description**

**Definition**

> onOutputFillTypesChanged()

**Arguments**

| any | outputs |
|-----|---------|
| any | state   |

**Code**

```lua
function PlaceableGreenhouse:onOutputFillTypesChanged(outputs, state)
    local spec = self.spec_greenhouse

    for _, output in pairs(outputs) do
        local fillType = output.type
        if state then
            if spec.filltypeIdToPlant[fillType] ~ = nil then
                spec.activeFilltypes[fillType] = true
            end
        else
                spec.activeFilltypes[fillType] = nil
            end
        end

        -- only directly updated visuals if during gameplay -> plants are updated expliclitly once after load onFinalizePlacement
            if self:getIsSynchronized() then
                self.plantDistributionDirty = true
            end

            self:raiseActive()
        end

```

### onProductionStatusChanged

**Description**

**Definition**

> onProductionStatusChanged()

**Arguments**

| any | production |
|-----|------------|
| any | status     |

**Code**

```lua
function PlaceableGreenhouse:onProductionStatusChanged(production, status )
    local spec = self.spec_greenhouse

    local hasWater = not( status = = ProductionPoint.PROD_STATUS.MISSING_INPUTS)

    if spec.hasWater ~ = hasWater then
        spec.hasWater = hasWater
        self:updatePlantsStage()
    end

    if hasWater and next(spec.activeFilltypes) ~ = nil then
        spec.wateringTimer:startIfNotRunning()
    else
            spec.wateringTimer:stop()
        end
    end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Code**

```lua
function PlaceableGreenhouse:onUpdate()
    if self.plantDistributionDirty then
        self:updatePlantDistribution()
    end
end

```

### plantI3DLoadedCallback

**Description**

**Definition**

> plantI3DLoadedCallback()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableGreenhouse:plantI3DLoadedCallback(i3dNode, failedReason, args)
    local spec = self.spec_greenhouse
    local plant = args.plant
    local plantXmlFile = args.plantXmlFile
    local loadingTask = args.loadingTask

    if i3dNode ~ = 0 then
        local components = I3DUtil.loadI3DComponents(i3dNode)
        local i3dMappings = I3DUtil.loadI3DMapping(plantXmlFile, "greenhousePlant" , components)

        plant.i3dNode = i3dNode

        plantXmlFile:iterate( "greenhousePlant.stages.growing" , function (index, key)
            local growingNode = plantXmlFile:getValue(key .. "#node" , nil , components, i3dMappings)
            if growingNode ~ = nil then
                local childIndex = getChildIndex(growingNode)
                table.insert(plant.stages.growing, childIndex)
            end
        end )

        plant.stages.first = plant.stages.growing[ 1 ]
        plant.stages.last = plant.stages.growing[#plant.stages.growing]

        local witheredNode = plantXmlFile:getValue( "greenhousePlant.stages.withered#node" , nil , components, i3dMappings)
        if witheredNode ~ = nil then
            plant.stages.withered = getChildIndex(witheredNode)
        end
    end

    plantXmlFile:delete()
    spec.plantXMLFiles[plantXmlFile] = nil

    self:finishLoadingTask(loadingTask)
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
function PlaceableGreenhouse.prerequisitesPresent(specializations)
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
function PlaceableGreenhouse.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableGreenhouse )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableGreenhouse )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableGreenhouse )
    SpecializationUtil.registerEventListener(placeableType, "onOutputFillTypesChanged" , PlaceableGreenhouse )
    SpecializationUtil.registerEventListener(placeableType, "onProductionStatusChanged" , PlaceableGreenhouse )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableGreenhouse )
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
function PlaceableGreenhouse.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadPlantFromXml" , PlaceableGreenhouse.loadPlantFromXml)
    SpecializationUtil.registerFunction(placeableType, "plantI3DLoadedCallback" , PlaceableGreenhouse.plantI3DLoadedCallback)
    SpecializationUtil.registerFunction(placeableType, "addPlantPlace" , PlaceableGreenhouse.addPlantPlace)
    SpecializationUtil.registerFunction(placeableType, "updatePlantDistribution" , PlaceableGreenhouse.updatePlantDistribution)
    SpecializationUtil.registerFunction(placeableType, "setPlantAtPlace" , PlaceableGreenhouse.setPlantAtPlace)
    SpecializationUtil.registerFunction(placeableType, "updatePlantsStage" , PlaceableGreenhouse.updatePlantsStage)
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
function PlaceableGreenhouse.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Greenhouse" )
    schema:register(XMLValueType.STRING, basePath .. ".greenhouse.plants.plant(?)#fillType" , "FillType of plant" )
    schema:register(XMLValueType.STRING, basePath .. ".greenhouse.plants.plant(?)#xmlFilename" , "xml file of greenhouse plant" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".greenhouse.plantSpaces.space(?)#node" , "node where plant is placed" )
    schema:register(XMLValueType.BOOL, basePath .. ".greenhouse.plantSpaces.space(?)#useRandomYRot" , "node is randomly rotated on the y axis" , true )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".greenhouse.plantSpaces.spacesParent(?)#node" , "parent node of nodes where plants are placed" )
    schema:register(XMLValueType.BOOL, basePath .. ".greenhouse.plantSpaces.spacesParent(?)#useRandomYRot" , "node is randomly rotated on the y axis" , true )

    SoundManager.registerSampleXMLPaths(schema, basePath .. ".greenhouse.sounds" , "watering" )
    EffectManager.registerEffectXMLPaths(schema, basePath .. ".greenhouse.effectNodes" )
    schema:setXMLSpecializationType()
end

```

### setPlantAtPlace

**Description**

**Definition**

> setPlantAtPlace()

**Arguments**

| any | fillType   |
|-----|------------|
| any | plantPlace |

**Code**

```lua
function PlaceableGreenhouse:setPlantAtPlace(fillType, plantPlace)
    local spec = self.spec_greenhouse

    -- only update if required fillType differs from current one
        if plantPlace.fillType ~ = fillType then
            if plantPlace.fillType ~ = nil then
                -- remove existing stages from other plant
                for i = getNumOfChildren(plantPlace.node) - 1 , 0 , - 1 do
                    local plantStage = getChildAt(plantPlace.node, i)
                    delete(plantStage)
                end
                plantPlace.fillType = nil
            end

            local plant = spec.filltypeIdToPlant[fillType]
            if plant ~ = nil then
                local plantClone = clone(getChildAt(plant.i3dNode, 0 ), false , false , false )

                for n = getNumOfChildren(plantClone) - 1 , 0 , - 1 do
                    local plantStage = getChildAt(plantClone, n)
                    link(plantPlace.node, plantStage, 0 )
                end
                plantPlace.fillType = fillType
                plantPlace.stage = nil

                delete(plantClone)
            end
        end
    end

```

### updatePlantDistribution

**Description**

> populates the plant nodes with cloned plants set in activeFilltypes

**Definition**

> updatePlantDistribution()

**Code**

```lua
function PlaceableGreenhouse:updatePlantDistribution()
    local spec = self.spec_greenhouse

    local numActiveFilltypes = table.size(spec.activeFilltypes)
    local numPlaces = #spec.plantPlaces

    local fillTypesList = table.toList(spec.activeFilltypes)

    for i = 1 , numPlaces do
        -- rotate active fillTypes through places
        local fillType = fillTypesList[(i % numActiveFilltypes) + 1 ]
        local plantPlace = spec.plantPlaces[i]

        self:setPlantAtPlace(fillType, plantPlace)
    end

    self.plantDistributionDirty = false
    self:updatePlantsStage()
end

```

### updatePlantsStage

**Description**

> cycles throufh plants growth stages or sets plants to withered if no water is available

**Definition**

> updatePlantsStage()

**Code**

```lua
function PlaceableGreenhouse:updatePlantsStage()
    local spec = self.spec_greenhouse

    if table.size(spec.activeFilltypes) = = 0 then
        return
    end

    if not spec.hasWater then
        spec.growthTimer:stop()
    else
            spec.growthTimer:start()
        end

        for i = 1 , #spec.plantPlaces do
            local plantPlace = spec.plantPlaces[i]

            local plant = spec.filltypeIdToPlant[plantPlace.fillType]

            local newStage
            if not spec.hasWater then
                newStage = plant.stages.withered
            else
                    newStage = (plantPlace.stage and(plantPlace.stage + 1 )) or plant.stages.first
                    if newStage > plant.stages.last then
                        newStage = plant.stages.first
                    end
                end

                if plantPlace.stage ~ = newStage then
                    for n = 0 , getNumOfChildren(plantPlace.node) - 1 do
                        local plantStage = getChildAt(plantPlace.node, n)
                        setVisibility(plantStage, n = = newStage)
                    end
                    plantPlace.stage = newStage
                end
            end
        end

```