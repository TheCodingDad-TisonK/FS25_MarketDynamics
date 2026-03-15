## ConsumableManager

**Description**

> This class handles all available consumables

**Parent**

> [AbstractManager](?version=script&category=58&class=558)

**Functions**

- [addModConsumable](#addmodconsumable)
- [consumableI3DFileLoaded](#consumablei3dfileloaded)
- [getConsumableConsumingMeshByIndex](#getconsumableconsumingmeshbyindex)
- [getConsumableMeshByIndex](#getconsumablemeshbyindex)
- [getConsumableVariationCapacityAndUnitByIndex](#getconsumablevariationcapacityandunitbyindex)
- [getConsumableVariationIndexByName](#getconsumablevariationindexbyname)
- [getConsumableVariationMetaDataByIndex](#getconsumablevariationmetadatabyindex)
- [getConsumableVariationNameByIndex](#getconsumablevariationnamebyindex)
- [getConsumableVariationPriceByIndex](#getconsumablevariationpricebyindex)
- [getConsumableVariationsByType](#getconsumablevariationsbytype)
- [getConsumableVariationShaderParameterByIndex](#getconsumablevariationshaderparameterbyindex)
- [getTypeTitle](#gettypetitle)
- [loadConsumableVariationsFromXML](#loadconsumablevariationsfromxml)
- [loadMapData](#loadmapdata)
- [new](#new)
- [registerConsumablesXMLPaths](#registerconsumablesxmlpaths)
- [registerConsumableXMLPaths](#registerconsumablexmlpaths)
- [unloadMapData](#unloadmapdata)

### addModConsumable

**Description**

> Add mod consumable xml to load

**Definition**

> addModConsumable(string xmlFilename, string customEnvironment, string baseDirectory)

**Arguments**

| string | xmlFilename       | path to consumable xml file |
|--------|-------------------|-----------------------------|
| string | customEnvironment | custom environment          |
| string | baseDirectory     | base rirectory              |

**Code**

```lua
function ConsumableManager:addModConsumable(xmlFilename, customEnvironment, baseDirectory)
    table.insert( self.modConsumablesToLoad, { xmlFilename = xmlFilename,
    customEnvironment = customEnvironment,
    baseDirectory = baseDirectory } )
end

```

### consumableI3DFileLoaded

**Description**

> Called when consumable i3d file was loaded

**Definition**

> consumableI3DFileLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | arguments    |

**Code**

```lua
function ConsumableManager:consumableI3DFileLoaded(i3dNode, failedReason, arguments)
    local consumableVariation, nodePath, name = arguments[ 1 ], arguments[ 2 ], arguments[ 3 ]

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local node = I3DUtil.indexToObject(i3dNode, nodePath, nil , nil )
        if node ~ = nil then
            setTranslation(node, 0 , 0 , 0 )
            setRotation(node, 0 , 0 , 0 )
            unlink(node)
            consumableVariation[name] = node
        else
                printWarning( string.format( "Warning:Unable to find consumable object '%s' for '%s'" , nodePath, consumableVariation.name))
                end

                delete(i3dNode)
            end
        end

```

### getConsumableConsumingMeshByIndex

**Description**

> Returns a cloned version of the consumable mesh by the given name

**Definition**

> getConsumableConsumingMeshByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableConsumingMeshByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return nil
    end

    if consumableVariation.node ~ = nil then
        local clonedNode = clone(consumableVariation.consumingNode or consumableVariation.node, false , false , false )

        for _, shaderParameter in ipairs(consumableVariation.shaderParameters) do
            if shaderParameter.materialSlotName ~ = nil then
                I3DUtil.setMaterialSlotShaderParameterRec(clonedNode, shaderParameter.materialSlotName, shaderParameter.name, shaderParameter.value[ 1 ], shaderParameter.value[ 2 ], shaderParameter.value[ 3 ], shaderParameter.value[ 4 ])
            else
                    I3DUtil.setShaderParameterRec(clonedNode, shaderParameter.name, shaderParameter.value[ 1 ], shaderParameter.value[ 2 ], shaderParameter.value[ 3 ], shaderParameter.value[ 4 ])
                end
            end

            return clonedNode
        end

        return nil
    end

```

### getConsumableMeshByIndex

**Description**

> Returns a cloned version of the consumable mesh by the given name

**Definition**

> getConsumableMeshByIndex()

**Arguments**

| any | index              |
|-----|--------------------|
| any | addTensionBeltMesh |

**Code**

```lua
function ConsumableManager:getConsumableMeshByIndex(index, addTensionBeltMesh)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return nil
    end

    if consumableVariation.node ~ = nil then
        local mesh = clone(consumableVariation.node, false , false , false )

        if addTensionBeltMesh and consumableVariation.tensionBeltNode ~ = nil then
            local tensionBeltMesh = clone(consumableVariation.tensionBeltNode, false , false , false )
            link(mesh, tensionBeltMesh)

            return mesh, tensionBeltMesh
        end

        return mesh, nil
    end

    return nil , nil
end

```

### getConsumableVariationCapacityAndUnitByIndex

**Description**

> Returns the capacity per unit and unit text to display

**Definition**

> getConsumableVariationCapacityAndUnitByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableVariationCapacityAndUnitByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation ~ = nil then
        return consumableVariation.capacity, consumableVariation.unitText
    end

    return nil , nil
end

```

### getConsumableVariationIndexByName

**Description**

> Returns the index of the variation for the given name

**Definition**

> getConsumableVariationIndexByName()

**Arguments**

| any | name              |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function ConsumableManager:getConsumableVariationIndexByName(name, customEnvironment)
    local consumableVariation
    if customEnvironment ~ = nil then
        consumableVariation = self.variationsByName[customEnvironment .. "." .. name]
    end

    if consumableVariation = = nil then
        consumableVariation = self.variationsByName[name]
    end

    if consumableVariation = = nil then
        return 0
    end

    return consumableVariation.index
end

```

### getConsumableVariationMetaDataByIndex

**Description**

> Returns the meta data of the variation for the given index

**Definition**

> getConsumableVariationMetaDataByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableVariationMetaDataByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return nil
    end

    return consumableVariation.metaData
end

```

### getConsumableVariationNameByIndex

**Description**

> Returns the name of the variation for the given index

**Definition**

> getConsumableVariationNameByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableVariationNameByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return "UNKNOWN"
    end

    return consumableVariation.name
end

```

### getConsumableVariationPriceByIndex

**Description**

> Returns the price per unit for the given variation index

**Definition**

> getConsumableVariationPriceByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableVariationPriceByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return nil
    end

    return consumableVariation.price
end

```

### getConsumableVariationsByType

**Description**

> Returns the titles of all available variations for the given type

**Definition**

> getConsumableVariationsByType()

**Arguments**

| any | typeName |
|-----|----------|

**Code**

```lua
function ConsumableManager:getConsumableVariationsByType(typeName)
    local variations = { }
    local indexToVariationIndex = { }
    for variationIndex, consumableVariation in ipairs( self.variations) do
        if consumableVariation.type = = typeName then
            table.insert(variations, consumableVariation.title)
            indexToVariationIndex[#variations] = variationIndex
        end
    end

    return variations, indexToVariationIndex
end

```

### getConsumableVariationShaderParameterByIndex

**Description**

> Returns the shader parameter of the variation for the given index

**Definition**

> getConsumableVariationShaderParameterByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ConsumableManager:getConsumableVariationShaderParameterByIndex(index)
    local consumableVariation = self.variations[index]
    if consumableVariation = = nil then
        return nil
    end

    return consumableVariation.shaderParameters
end

```

### getTypeTitle

**Description**

> Returns the UI title to display of the given type

**Definition**

> getTypeTitle()

**Arguments**

| any | typeName |
|-----|----------|

**Code**

```lua
function ConsumableManager:getTypeTitle(typeName)
    local type = self.typesByName[typeName]
    if type = = nil then
        return nil
    end

    return type.title or typeName
end

```

### loadConsumableVariationsFromXML

**Description**

> Loads consumable variations from xml file

**Definition**

> loadConsumableVariationsFromXML(string xmlFilename, string customEnvironment, string baseDirectory)

**Arguments**

| string | xmlFilename       | path to consumable xml file |
|--------|-------------------|-----------------------------|
| string | customEnvironment | custom environment          |
| string | baseDirectory     | base rirectory              |

**Code**

```lua
function ConsumableManager:loadConsumableVariationsFromXML(xmlFilename, customEnvironment, baseDirectory)
    Logging.devInfo( "Loading Consumable from '%s'" , xmlFilename)

    local xmlFile = XMLFile.load( "Consumable" , xmlFilename, ConsumableManager.xmlSchemaConsumable)
    if xmlFile ~ = nil then
        for _, key in xmlFile:iterator( "consumable.consumableVariation" ) do
            if # self.variations > = ConsumableManager.MAX_NUM_VARIATIONS then
                Logging.xmlWarning(xmlFile, "Max.num consumables variations reached, skip loading of '%s'" , key)
                continue
            end

            local consumableVariation = { }
            consumableVariation.type = xmlFile:getValue(key .. "#type" )
            if consumableVariation.type = = nil then
                Logging.xmlWarning(xmlFile, "Missing type in '%s'" , key)
                continue
            end

            consumableVariation.name = xmlFile:getValue(key .. "#name" )
            if consumableVariation.name = = nil then
                Logging.xmlWarning(xmlFile, "Missing name in '%s'" , key)
                continue
            else
                    if customEnvironment ~ = nil then
                        consumableVariation.name = customEnvironment .. "." .. consumableVariation.name
                    end
                end

                consumableVariation.price = xmlFile:getValue(key .. "#price" , 0 )

                consumableVariation.title = xmlFile:getValue(key .. "#title" , nil , customEnvironment)
                if consumableVariation.title = = nil then
                    Logging.xmlWarning(xmlFile, "Missing title in '%s'" , key)
                    continue
                end

                consumableVariation.unitText = xmlFile:getValue(key .. "#unitText" , nil , customEnvironment, false )
                consumableVariation.capacity = xmlFile:getValue(key .. "#capacity" , 1 )

                consumableVariation.filename = xmlFile:getValue(key .. ".object#filename" )
                if consumableVariation.filename ~ = nil then
                    consumableVariation.filename = Utils.getFilename(consumableVariation.filename, baseDirectory)
                    if consumableVariation.filename ~ = nil then
                        local nodePath = xmlFile:getValue(key .. ".object#node" )
                        if nodePath ~ = nil then
                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(consumableVariation.filename, false , false , self.consumableI3DFileLoaded, self , { consumableVariation, nodePath, "node" } )
                            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                        end
                    end
                end

                consumableVariation.consumingFilename = xmlFile:getValue(key .. ".consumingObject#filename" )
                if consumableVariation.consumingFilename ~ = nil then
                    consumableVariation.consumingFilename = Utils.getFilename(consumableVariation.consumingFilename, baseDirectory)
                    if consumableVariation.consumingFilename ~ = nil then
                        local consumingNodePath = xmlFile:getValue(key .. ".consumingObject#node" )
                        if consumingNodePath ~ = nil then
                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(consumableVariation.consumingFilename, false , false , self.consumableI3DFileLoaded, self , { consumableVariation, consumingNodePath, "consumingNode" } )
                            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                        end
                    end
                end

                consumableVariation.tensionBeltFilename = xmlFile:getValue(key .. ".tensionBeltObject#filename" )
                if consumableVariation.tensionBeltFilename ~ = nil then
                    consumableVariation.tensionBeltFilename = Utils.getFilename(consumableVariation.tensionBeltFilename, baseDirectory)
                    if consumableVariation.tensionBeltFilename ~ = nil then
                        local tensionBeltNodePath = xmlFile:getValue(key .. ".tensionBeltObject#node" )
                        if tensionBeltNodePath ~ = nil then
                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(consumableVariation.tensionBeltFilename, false , false , self.consumableI3DFileLoaded, self , { consumableVariation, tensionBeltNodePath, "tensionBeltNode" } )
                            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                        end
                    end
                end

                consumableVariation.metaData = { }
                for _, valueKey in xmlFile:iterator(key .. ".metaData.value" ) do
                    local name = xmlFile:getValue(valueKey .. "#name" )
                    if name ~ = nil then
                        local valueStr = xmlFile:getValue(valueKey .. "#value" )
                        if valueStr ~ = nil then
                            local value
                            if valueStr:contains( " " ) then
                                value = string.getVector(valueStr)
                            else
                                    value = tonumber(valueStr) or valueStr
                                end

                                if value ~ = nil then
                                    consumableVariation.metaData[name] = value
                                else
                                        Logging.xmlWarning(xmlFile, "Invalid value in '%s'" , valueKey)
                                    end
                                end
                            else
                                    Logging.xmlWarning(xmlFile, "Missing name in '%s'" , valueKey)
                                end
                            end

                            consumableVariation.shaderParameters = { }
                            for _, paramKey in xmlFile:iterator(key .. ".shaderParameter" ) do
                                local name = xmlFile:getValue(paramKey .. "#name" )
                                if name ~ = nil then
                                    local shaderParameter = { }
                                    shaderParameter.name = name
                                    shaderParameter.materialSlotName = xmlFile:getValue(paramKey .. "#materialSlotName" )
                                    shaderParameter.value = xmlFile:getValue(paramKey .. "#value" , nil , true )

                                    if shaderParameter.value ~ = nil then
                                        table.insert(consumableVariation.shaderParameters, shaderParameter)
                                    else
                                            Logging.xmlWarning(xmlFile, "Invalid value in '%s'" , paramKey)
                                        end
                                    else
                                            Logging.xmlWarning(xmlFile, "Missing name in '%s'" , paramKey)
                                        end
                                    end

                                    if self.variationsByName[consumableVariation.name] = = nil then
                                        table.insert( self.variations, consumableVariation)
                                        consumableVariation.index = # self.variations
                                        self.variationsByName[consumableVariation.name] = consumableVariation
                                    else
                                            Logging.xmlWarning(xmlFile, "Consumable with name '%s' already registered" , consumableVariation.name)
                                        end
                                    end

                                    xmlFile:delete()
                                end
                            end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | missionInfo   |
| any | baseDirectory |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function ConsumableManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    ConsumableManager:superClass().loadMapData( self )
    self.baseDirectory = baseDirectory

    local consumablesXMLFile = XMLFile.load( "consumables" , ConsumableManager.DEFAULT_FILENAME, ConsumableManager.xmlSchemaConsumables)
    if consumablesXMLFile ~ = nil then
        for _, key in consumablesXMLFile:iterator( "consumables.types.type" ) do
            local type = { }
            type.name = consumablesXMLFile:getValue(key .. "#name" )
            type.title = consumablesXMLFile:getValue(key .. "#title" )
            if type.name ~ = nil and type.title ~ = nil then
                type.name = string.upper( type.name)

                table.insert( self.types, type )
                self.typesByName[ type.name] = type
            else
                    Logging.xmlWarning(consumablesXMLFile, "Failed to load consumable type from xml. (%s)" , key)
                end
            end

            for _, key in consumablesXMLFile:iterator( "consumables.consumable" ) do
                local filename = consumablesXMLFile:getValue(key .. "#filename" )
                if filename ~ = nil then
                    filename = Utils.getFilename(filename, baseDirectory)
                    self:loadConsumableVariationsFromXML(filename, nil , baseDirectory)
                end
            end

            consumablesXMLFile:delete()
        end

        for i = # self.modConsumablesToLoad, 1 , - 1 do
            local modConsumablesToLoad = self.modConsumablesToLoad[i]
            self:loadConsumableVariationsFromXML(modConsumablesToLoad.xmlFilename, modConsumablesToLoad.customEnvironment, modConsumablesToLoad.baseDirectory)
            self.modConsumablesToLoad[i] = nil
        end
    end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function ConsumableManager.new(customMt)
    local self = AbstractManager.new(customMt or ConsumableManager _mt)

    self.types = { }
    self.typesByName = { }

    self.variations = { }
    self.variationsByName = { }

    self.sharedLoadRequestIds = { }
    self.modConsumablesToLoad = { }

    ConsumableManager.xmlSchemaConsumable = XMLSchema.new( "consumable" )
    ConsumableManager.registerConsumableXMLPaths( ConsumableManager.xmlSchemaConsumable)

    ConsumableManager.xmlSchemaConsumables = XMLSchema.new( "consumables" )
    ConsumableManager.registerConsumablesXMLPaths( ConsumableManager.xmlSchemaConsumables)

    return self
end

```

### registerConsumablesXMLPaths

**Description**

**Definition**

> registerConsumablesXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function ConsumableManager.registerConsumablesXMLPaths(schema)
    schema:register(XMLValueType.STRING, "consumables.types.type(?)#name" , "Name of the consumable type" )
    schema:register(XMLValueType.L10N_STRING, "consumables.types.type(?)#title" , "Name of the type to be shown in the UI" )

    schema:register(XMLValueType.STRING, "consumables.consumable(?)#filename" , "Path to consumable xml file" )
end

```

### registerConsumableXMLPaths

**Description**

**Definition**

> registerConsumableXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function ConsumableManager.registerConsumableXMLPaths(schema)
    schema:register(XMLValueType.STRING, "consumable.consumableVariation(?)#type" , "Name of the consumable type" )
    schema:register(XMLValueType.FLOAT, "consumable.consumableVariation(?)#price" , "Price per unit" , 0 )
    schema:register(XMLValueType.STRING, "consumable.consumableVariation(?)#name" , "Name of the consumable itself(to be refered on vehicles)" )
    schema:register(XMLValueType.L10N_STRING, "consumable.consumableVariation(?)#title" , "Name of the consumable itself(to be shown in the UI)" )

    schema:register(XMLValueType.FLOAT, "consumable.consumableVariation(?)#capacity" , "Capacity of one unit from this type(to be shown in the UI)" , 1 )
    schema:register(XMLValueType.L10N_STRING, "consumable.consumableVariation(?)#unitText" , "Unit text for the UI" )

        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).object#filename" , "Path to i3d file which contains the object" )
        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).object#node" , "Path to the object node inside of the i3d file" )

        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).consumingObject#filename" , "Path to i3d file which contains the object(in consuming state)" )
        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).consumingObject#node" , "Path to the object node inside of the i3d file(in consuming state)" )

        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).tensionBeltObject#filename" , "Path to i3d file which contains the object(tension belt mesh)" )
        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).tensionBeltObject#node" , "Path to the object node inside of the i3d file(tension belt mesh)" )

        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).metaData.value(?)#name" , "Name of the value" )
        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).metaData.value(?)#value" , "Value" )

        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).shaderParameter(?)#name" , "Name of the shader parameter to so on the objects" )
        schema:register(XMLValueType.STRING, "consumable.consumableVariation(?).shaderParameter(?)#materialSlotName" , "Material slot name which should receive the shader parameter(if not set, it will be applied to all materials)" )
            schema:register(XMLValueType.VECTOR_ 4 , "consumable.consumableVariation(?).shaderParameter(?)#value" , "Value" )
        end

```

### unloadMapData

**Description**

> Load data on map load

**Definition**

> unloadMapData()

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function ConsumableManager:unloadMapData()
    for _, consumableVariation in ipairs( self.variations) do
        if consumableVariation.node ~ = nil then
            delete(consumableVariation.node)
        end

        if consumableVariation.consumingNode ~ = nil then
            delete(consumableVariation.consumingNode)
        end

        if consumableVariation.tensionBeltNode ~ = nil then
            delete(consumableVariation.tensionBeltNode)
        end
    end
    self.variations = { }

    for i = 1 , # self.sharedLoadRequestIds do
        local sharedLoadRequestId = self.sharedLoadRequestIds[i]
        g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
    end
    self.sharedLoadRequestIds = { }

    ConsumableManager:superClass().unloadMapData( self )
end

```