## PlaceableHusbandryLiquidManure

**Description**

> Specialization for placeables

**Functions**

- [getConditionInfos](#getconditioninfos)
- [onFinalizePlacement](#onfinalizeplacement)
- [onHusbandryAnimalsUpdate](#onhusbandryanimalsupdate)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [updateInfo](#updateinfo)
- [updateOutput](#updateoutput)
- [updateProduction](#updateproduction)

### getConditionInfos

**Description**

**Definition**

> getConditionInfos()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryLiquidManure:getConditionInfos(superFunc)
    local infos = superFunc( self )
    local spec = self.spec_husbandryLiquidManure

    local fillType = g_fillTypeManager:getFillTypeByIndex(spec.fillType)
    if fillType ~ = nil then
        local info = { }
        info.title = fillType.title
        info.value = self:getHusbandryFillLevel(spec.fillType)
        local capacity = self:getHusbandryCapacity(spec.fillType)
        local ratio = 1
        if capacity > 0 then
            ratio = info.value / capacity
        else
                info.disabled = true
                info.title = string.format( "%s(%s)" , info.title, g_i18n:getText( "info_husbandryMissingLiquidManureTank" ))
            end
            info.ratio = math.clamp(ratio, 0 , 1 )
            info.invertedBar = true

            table.insert(infos, info)
        end

        return infos
    end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryLiquidManure:onFinalizePlacement()
    local spec = self.spec_husbandryLiquidManure
    if not self:getHusbandryIsFillTypeSupported(spec.fillType) then
        Logging.warning( "Missing filltype 'liquidManure' in husbandry storage!" )
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
function PlaceableHusbandryLiquidManure:onHusbandryAnimalsUpdate(clusters)
    local spec = self.spec_husbandryLiquidManure

    spec.litersPerHour = 0
    for _, cluster in ipairs(clusters) do
        local subType = g_currentMission.animalSystem:getSubTypeByIndex(cluster.subTypeIndex)
        if subType ~ = nil then
            local liquidManure = subType.output.liquidManure
            if liquidManure ~ = nil then
                local age = cluster:getAge()
                local litersPerAnimal = liquidManure:get(age)
                local litersPerDay = litersPerAnimal * cluster:getNumAnimals()

                spec.litersPerHour = spec.litersPerHour + (litersPerDay / 24 )
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
function PlaceableHusbandryLiquidManure:onLoad(savegame)
    local spec = self.spec_husbandryLiquidManure

    spec.litersPerHour = 0
    spec.fillType = FillType.LIQUIDMANURE
    spec.info = { title = g_i18n:getText( "fillType_liquidManure" ), text = "" }
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
function PlaceableHusbandryLiquidManure.prerequisitesPresent(specializations)
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
function PlaceableHusbandryLiquidManure.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryLiquidManure )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHusbandryLiquidManure )
    SpecializationUtil.registerEventListener(placeableType, "onHusbandryAnimalsUpdate" , PlaceableHusbandryLiquidManure )
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
function PlaceableHusbandryLiquidManure.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateOutput" , PlaceableHusbandryLiquidManure.updateOutput)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateProduction" , PlaceableHusbandryLiquidManure.updateProduction)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableHusbandryLiquidManure.updateInfo)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getConditionInfos" , PlaceableHusbandryLiquidManure.getConditionInfos)
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
function PlaceableHusbandryLiquidManure.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.liquidManure"
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
function PlaceableHusbandryLiquidManure:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)
    local spec = self.spec_husbandryLiquidManure

    local fillLevel = self:getHusbandryFillLevel(spec.fillType)
    spec.info.text = string.format( "%d l" , fillLevel)
    table.insert(infoTable, spec.info)
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
function PlaceableHusbandryLiquidManure:updateOutput(superFunc, foodFactor, productionFactor, globalProductionFactor)
    if self.isServer then
        local spec = self.spec_husbandryLiquidManure

        if spec.litersPerHour > 0 then
            local liters = foodFactor * spec.litersPerHour * g_currentMission.environment.timeAdjustment
            self:addHusbandryFillLevelFromTool( self:getOwnerFarmId(), liters, spec.fillType, nil , nil , nil )
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
function PlaceableHusbandryLiquidManure:updateProduction(superFunc, foodFactor)
    local factor = superFunc( self , foodFactor)

    if self.isServer then
        local spec = self.spec_husbandryLiquidManure
        local freeCapacity = self:getHusbandryFreeCapacity(spec.fillType)
        if freeCapacity < = 0 then
            factor = factor * 0.75
        end
    end

    return factor
end

```