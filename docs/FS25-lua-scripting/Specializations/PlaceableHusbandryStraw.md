## PlaceableHusbandryStraw

**Description**

> Specialization for placeables

**Functions**

- [getConditionInfos](#getconditioninfos)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onHusbandryAnimalsUpdate](#onhusbandryanimalsupdate)
- [onHusbandryFillLevelChanged](#onhusbandryfilllevelchanged)
- [onLoad](#onload)
- [onPostFinalizePlacement](#onpostfinalizeplacement)
- [onReadStream](#onreadstream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [updateInfo](#updateinfo)
- [updateOutput](#updateoutput)
- [updateProduction](#updateproduction)
- [updateStrawPlane](#updatestrawplane)

### getConditionInfos

**Description**

**Definition**

> getConditionInfos()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryStraw:getConditionInfos(superFunc)
    local infos = superFunc( self )
    local spec = self.spec_husbandryStraw

    local fillType = g_fillTypeManager:getFillTypeByIndex(spec.inputFillType)
    if fillType ~ = nil then
        local info = { }
        info.title = fillType.title
        info.value = self:getHusbandryFillLevel(spec.inputFillType)
        local capacity = self:getHusbandryCapacity(spec.inputFillType)
        local ratio = 0
        if capacity > 0 then
            ratio = info.value / capacity
        end
        info.ratio = math.clamp(ratio, 0 , 1 )
        info.invertedBar = false

        table.insert(infos, info)
    end

    local outputFillType = g_fillTypeManager:getFillTypeByIndex(spec.outputFillType)
    if outputFillType ~ = nil then
        local info = { }
        info.title = outputFillType.title
        info.value = self:getHusbandryFillLevel(spec.outputFillType)
        local capacity = self:getHusbandryCapacity(spec.outputFillType)
        local ratio = 1
        if capacity > 0 then
            ratio = info.value / capacity
        else
                info.disabled = true
                info.title = string.format( "%s(%s)" , info.title, g_i18n:getText( "info_husbandryMissingManureHeap" ))
            end
            info.ratio = math.clamp(ratio, 0 , 1 )
            info.invertedBar = true

            table.insert(infos, info)
        end

        return infos
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHusbandryStraw:onDelete()
    local spec = self.spec_husbandryStraw
    if spec.strawPlane ~ = nil then
        spec.strawPlane:delete()
        spec.strawPlane = nil
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryStraw:onFinalizePlacement()
    local spec = self.spec_husbandryStraw
    if not self:getHusbandryIsFillTypeSupported(spec.inputFillType) then
        Logging.warning( "Missing filltype 'straw' in husbandry storage!" )
    end
    if self.isManureActive and not self:getHusbandryIsFillTypeSupported(spec.outputFillType) then
        Logging.warning( "Missing filltype 'manure' in husbandry storage!" )
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
function PlaceableHusbandryStraw:onHusbandryAnimalsUpdate(clusters)
    local spec = self.spec_husbandryStraw
    spec.inputLitersPerHour = 0
    spec.outputLitersPerHour = 0
    for _, cluster in ipairs(clusters) do
        local subType = g_currentMission.animalSystem:getSubTypeByIndex(cluster.subTypeIndex)
        if subType ~ = nil then
            local straw = subType.input.straw
            if straw ~ = nil then
                local age = cluster:getAge()
                local litersPerAnimal = straw:get(age)
                local litersPerDay = litersPerAnimal * cluster:getNumAnimals()

                spec.inputLitersPerHour = spec.inputLitersPerHour + (litersPerDay / 24 )
            end

            local manure = subType.output.manure
            if manure ~ = nil then
                local age = cluster:getAge()
                local litersPerAnimal = manure:get(age)
                local litersPerDay = litersPerAnimal * cluster:getNumAnimals()

                spec.outputLitersPerHour = spec.outputLitersPerHour + (litersPerDay / 24 )
            end
        end
    end
end

```

### onHusbandryFillLevelChanged

**Description**

**Definition**

> onHusbandryFillLevelChanged()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|
| any | delta         |

**Code**

```lua
function PlaceableHusbandryStraw:onHusbandryFillLevelChanged(fillTypeIndex, delta)
    local spec = self.spec_husbandryStraw
    if fillTypeIndex = = spec.inputFillType then
        self:updateStrawPlane()
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
function PlaceableHusbandryStraw:onLoad(savegame)
    local spec = self.spec_husbandryStraw

    spec.manureFactor = self.xmlFile:getValue( "placeable.husbandry.straw.manure#factor" , 1 )
    spec.isManureActive = self.xmlFile:getValue( "placeable.husbandry.straw.manure#active" , true )

    spec.strawPlane = FillPlane.new()
    if spec.strawPlane:load( self.components, self.xmlFile, "placeable.husbandry.straw.strawPlane" , self.i3dMappings) then
        spec.strawPlane:setState( 0 )
    else
            spec.strawPlane:delete()
            spec.strawPlane = nil
        end
        spec.inputFillType = FillType.STRAW
        spec.outputFillType = FillType.MANURE
        spec.inputLitersPerHour = 0
        spec.outputLitersPerHour = 0
        spec.info = { title = g_i18n:getText( "fillType_straw" ), text = "" }
        spec.outputInfo = { title = g_i18n:getText( "fillType_manure" ), text = "" }
    end

```

### onPostFinalizePlacement

**Description**

**Definition**

> onPostFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryStraw:onPostFinalizePlacement()
    self:updateStrawPlane()
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
function PlaceableHusbandryStraw:onReadStream(streamId, connection)
    self:updateStrawPlane()
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
function PlaceableHusbandryStraw.prerequisitesPresent(specializations)
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
function PlaceableHusbandryStraw.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onPostFinalizePlacement" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onHusbandryAnimalsUpdate" , PlaceableHusbandryStraw )
    SpecializationUtil.registerEventListener(placeableType, "onHusbandryFillLevelChanged" , PlaceableHusbandryStraw )
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
function PlaceableHusbandryStraw.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateStrawPlane" , PlaceableHusbandryStraw.updateStrawPlane)
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
function PlaceableHusbandryStraw.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateOutput" , PlaceableHusbandryStraw.updateOutput)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateProduction" , PlaceableHusbandryStraw.updateProduction)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getConditionInfos" , PlaceableHusbandryStraw.getConditionInfos)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableHusbandryStraw.updateInfo)
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
function PlaceableHusbandryStraw.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.straw"
    FillPlane.registerXMLPaths(schema, basePath .. ".strawPlane" )
    schema:register(XMLValueType.FLOAT, basePath .. ".manure#factor" , "Factor to transform straw to manure" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. ".manure#active" , "Enable manure production" , true )
    schema:setXMLSpecializationType()
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
function PlaceableHusbandryStraw:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)
    local spec = self.spec_husbandryStraw

    local fillLevel = self:getHusbandryFillLevel(spec.inputFillType)
    spec.info.text = string.format( "%d l" , fillLevel)
    table.insert(infoTable, spec.info)

    local outputFillLevel = self:getHusbandryFillLevel(spec.outputFillType)
    spec.outputInfo.text = string.format( "%d l" , outputFillLevel)
    table.insert(infoTable, spec.outputInfo)
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
function PlaceableHusbandryStraw:updateOutput(superFunc, foodFactor, productionFactor, globalProductionFactor)
    if self.isServer then
        local spec = self.spec_husbandryStraw

        if spec.inputLitersPerHour > 0 then
            local amount = spec.inputLitersPerHour * g_currentMission.environment.timeAdjustment
            local delta = amount - self:removeHusbandryFillLevel( self:getOwnerFarmId(), amount, spec.inputFillType)
            if spec.outputLitersPerHour > 0 and delta > 0 then
                local liters = foodFactor * spec.outputLitersPerHour * (delta / amount) * g_currentMission.environment.timeAdjustment -- outputLitersPerHour increases with number of animals
                if liters > 0 then
                    self:addHusbandryFillLevelFromTool( self:getOwnerFarmId(), liters, spec.outputFillType, nil , nil , nil )
                end
            end

            self:updateStrawPlane()
        end
    end

    superFunc( self , foodFactor, productionFactor, globalProductionFactor)
end

```

### updateProduction

**Description**

**Definition**

> updateProduction()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | foodFactor |

**Code**

```lua
function PlaceableHusbandryStraw:updateProduction(superFunc, foodFactor)
    local factor = superFunc( self , foodFactor)

    if self.isServer then
        local spec = self.spec_husbandryStraw
        local fillLevel = self:getHusbandryFillLevel(spec.inputFillType)
        if fillLevel > 0 then
            local freeCapacity = self:getHusbandryFreeCapacity(spec.outputFillType)
            if freeCapacity < = 0 then
                factor = factor * 0.75
            end
        else
                factor = factor * 0.9
            end
        end

        return factor
    end

```

### updateStrawPlane

**Description**

**Definition**

> updateStrawPlane()

**Code**

```lua
function PlaceableHusbandryStraw:updateStrawPlane()
    local spec = self.spec_husbandryStraw
    if spec.strawPlane ~ = nil then
        local capacity = self:getHusbandryCapacity(spec.inputFillType, nil )
        local fillLevel = self:getHusbandryFillLevel(spec.inputFillType, nil )
        local factor = 0
        if capacity > 0 then
            factor = fillLevel / capacity
        end

        spec.strawPlane:setState(factor)
    end
end

```