## PlaceableFoliageAreas

**Description**

> Specialization for placeables

**Functions**

- [loadFoliageArea](#loadfoliagearea)
- [onLoad](#onload)
- [onPostFinalizePlacement](#onpostfinalizeplacement)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### loadFoliageArea

**Description**

**Definition**

> loadFoliageArea()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | area    |

**Code**

```lua
function PlaceableFoliageAreas:loadFoliageArea(xmlFile, key, area)
    local fruitTypeName = xmlFile:getValue(key .. "#fruitType" )
    local decoFoliage = xmlFile:getValue(key .. "#decoFoliage" )

    if fruitTypeName ~ = nil and decoFoliage ~ = nil then
        Logging.xmlInfo(xmlFile, "foliage area has both 'fruitType' and 'decoFoliage' defined for '%s'.Ignoring decoFoliage" , key)
            decoFoliage = nil
        end

        local fruitTypeDesc
        local fruitGrowthState
        if fruitTypeName ~ = nil then
            fruitTypeDesc = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
            if fruitTypeDesc = = nil then
                Logging.xmlWarning(xmlFile, "Foliage area fruit type '%s' not defined for '%s'" , fruitTypeName, key)
                    return false
                end

                local growthStateName = xmlFile:getValue(key .. "#growthStateName" )
                if growthStateName ~ = nil then
                    fruitGrowthState = fruitTypeDesc:getGrowthStateByName(growthStateName)
                    if fruitGrowthState = = nil then
                        Logging.xmlWarning(xmlFile, "Foliage area fruit type growth state name '%s' not defined for '%s'" , growthStateName, key)
                        end
                    end

                    if fruitGrowthState = = nil then
                        fruitGrowthState = xmlFile:getValue(key .. "#state" , fruitTypeDesc.maxHarvestingGrowthState - 1 )
                    end
                end

                if decoFoliage ~ = nil then
                    if not g_currentMission.foliageSystem:getIsDecoLayerDefined(decoFoliage) then
                        Logging.xmlInfo(xmlFile, "Foliage area decoFoliage '%s' not defined on current map for '%s'" , decoFoliage, key)
                            return false
                        end
                    end

                    local start = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
                    if start = = nil then
                        Logging.xmlWarning(xmlFile, "Foliage area start node not defined for '%s'" , key)
                            return false
                        end

                        local width = xmlFile:getValue(key .. "#widthNode" , nil , self.components, self.i3dMappings)
                        if width = = nil then
                            Logging.xmlWarning(xmlFile, "Foliage area width node not defined for '%s'" , key)
                                return false
                            end

                            local height = xmlFile:getValue(key .. "#heightNode" , nil , self.components, self.i3dMappings)
                            if height = = nil then
                                Logging.xmlWarning(xmlFile, "Foliage area height node not defined for '%s'" , key)
                                    return false
                                end

                                area.start = start
                                area.width = width
                                area.height = height
                                area.fruitGrowthState = fruitGrowthState
                                area.fruitTypeDesc = fruitTypeDesc
                                area.decoFoliage = decoFoliage

                                return true
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
function PlaceableFoliageAreas:onLoad(savegame)
    local spec = self.spec_foliageAreas

    spec.areas = { }
    self.xmlFile:iterate( "placeable.foliageAreas.foliageArea" , function (_, key)
        local area = { }
        if self:loadFoliageArea( self.xmlFile, key, area) then
            table.insert(spec.areas, area)
        end
    end )
end

```

### onPostFinalizePlacement

**Description**

**Definition**

> onPostFinalizePlacement()

**Code**

```lua
function PlaceableFoliageAreas:onPostFinalizePlacement()
    if self.isServer then
        local spec = self.spec_foliageAreas

        for _, area in pairs(spec.areas) do
            if area.fruitTypeDesc ~ = nil then
                local fieldArea = DensityMapParallelogram.createFromNodes(area.start, area.width, area.height)
                local fieldUpdateTask = FieldUpdateTask.new()
                fieldUpdateTask:setArea(fieldArea)
                fieldUpdateTask:setFruit(area.fruitTypeDesc.index, area.fruitGrowthState)
                g_fieldManager:addFieldUpdateTask(fieldUpdateTask)
            else
                    local x, _, z = getWorldTranslation(area.start)
                    local xWidth, _, zWidth = getWorldTranslation(area.width)
                    local xHeight, _, zHeight = getWorldTranslation(area.height)
                    g_currentMission.foliageSystem:applyDecoFoliage(area.decoFoliage, x, z, xWidth, zWidth, xHeight, zHeight)
                end
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
function PlaceableFoliageAreas.prerequisitesPresent(specializations)
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
function PlaceableFoliageAreas.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableFoliageAreas )
    SpecializationUtil.registerEventListener(placeableType, "onPostFinalizePlacement" , PlaceableFoliageAreas )
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
function PlaceableFoliageAreas.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadFoliageArea" , PlaceableFoliageAreas.loadFoliageArea)
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
function PlaceableFoliageAreas.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "FoliageAreas" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".foliageAreas.foliageArea(?)#startNode" , "Start node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".foliageAreas.foliageArea(?)#widthNode" , "Width node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".foliageAreas.foliageArea(?)#heightNode" , "Height node" )
    schema:register(XMLValueType.STRING, basePath .. ".foliageAreas.foliageArea(?)#fruitType" , "Fruit type name" )
    schema:register(XMLValueType.STRING, basePath .. ".foliageAreas.foliageArea(?)#growthStateName" , "Fruit type growth state name" )
    schema:register(XMLValueType.STRING, basePath .. ".foliageAreas.foliageArea(?)#decoFoliage" , "Deco foliage name" )
    schema:register(XMLValueType.INT, basePath .. ".foliageAreas.foliageArea(?)#state" , "Fruit type state" )
    schema:setXMLSpecializationType()
end

```