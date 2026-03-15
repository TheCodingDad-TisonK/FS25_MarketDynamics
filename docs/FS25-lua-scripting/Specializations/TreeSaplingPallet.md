## TreeSaplingPallet

**Description**

> Specialization for tree pallets only to store the loaded tree type

**Functions**

- [getTreeSaplingPalletType](#gettreesaplingpallettype)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onTreeSaplingLoaded](#ontreesaplingloaded)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setTreeSaplingPalletType](#settreesaplingpallettype)
- [showInfo](#showinfo)
- [updateTreeSaplingPalletNodes](#updatetreesaplingpalletnodes)
- [updateTreeSaplingVisuals](#updatetreesaplingvisuals)

### getTreeSaplingPalletType

**Description**

> Returns current tree type

**Definition**

> getTreeSaplingPalletType()

**Return Values**

| any | name | tree type name |
|-----|------|----------------|

**Code**

```lua
function TreeSaplingPallet:getTreeSaplingPalletType()
    local spec = self.spec_treeSaplingPallet
    return spec.treeTypeName, spec.variationName
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function TreeSaplingPallet.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "treeSaplingType" , g_i18n:getText( "configuration_treeType" ), "treeSaplingPallet" , VehicleConfigurationItemTreeSapling )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "TreeSaplingPallet" )

    schema:register(XMLValueType.INT, "vehicle.treeSaplingPallet#fillUnitIndex" , "Index of the saplings fill unit" , 1 )
    schema:register(XMLValueType.STRING, "vehicle.treeSaplingPallet#treeType" , "Tree Type Name" , "spruce1" )
    schema:register(XMLValueType.STRING, "vehicle.treeSaplingPallet#variationName" , "Stage variation name to use" , "DEFAULT" )
    schema:register(XMLValueType.FILENAME, "vehicle.treeSaplingPallet#filename" , "Custom tree sapling i3d file" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.treeSaplingPallet.saplingNodes.saplingNode(?)#node" , "Sapling link node" )
    schema:register(XMLValueType.BOOL, "vehicle.treeSaplingPallet.saplingNodes.saplingNode(?)#randomize" , "Randomize rotation and scale of saplings" , true )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.treeSaplingPallet.treeSaplingTypeConfigurations.treeSaplingTypeConfiguration(?).saplingNodes.saplingNode(?)#node" , "Sapling link node" )
    schema:register(XMLValueType.BOOL, "vehicle.treeSaplingPallet.treeSaplingTypeConfigurations.treeSaplingTypeConfiguration(?).saplingNodes.saplingNode(?)#randomize" , "Randomize rotation and scale of saplings" , true )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).treeSaplingPallet#treeTypeName" , "Name of currently loaded tree type" )
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).treeSaplingPallet#variationName" , "Name of currently loaded tree stage variation" )
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function TreeSaplingPallet:onDelete()
    local spec = self.spec_treeSaplingPallet

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
        spec.sharedLoadRequestId = nil
    end

    if spec.saplingNodes ~ = nil then
        for _, saplingNode in ipairs(spec.saplingNodes) do
            if saplingNode.saplingShape ~ = nil then
                delete(saplingNode.saplingShape)
                saplingNode.saplingShape = nil
            end
        end
    end
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function TreeSaplingPallet:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    self:updateTreeSaplingPalletNodes()
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
function TreeSaplingPallet:onLoad(savegame)
    local spec = self.spec_treeSaplingPallet

    local treeSaplingTypeConfigurationId = self.configurations[ "treeSaplingType" ] or 1
    local baseKey = string.format( "vehicle.treeSaplingPallet.treeSaplingTypeConfigurations.treeSaplingTypeConfiguration(%d)" , treeSaplingTypeConfigurationId - 1 )
    if not self.xmlFile:hasProperty(baseKey) then
        baseKey = "vehicle.treeSaplingPallet"
    end

    spec.saplingNodes = { }

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.treeSaplingPallet#fillUnitIndex" , 1 )
    spec.treeTypeName = self.xmlFile:getValue( "vehicle.treeSaplingPallet#treeType" , "spruce" )
    spec.variationName = self.xmlFile:getValue( "vehicle.treeSaplingPallet#variationName" )
    spec.treeTypeFilename = self.xmlFile:getValue( "vehicle.treeSaplingPallet#filename" , nil , self.baseDirectory)

    local configItem = ConfigurationUtil.getConfigItemByConfigId( self.configFileName, "treeSaplingType" , treeSaplingTypeConfigurationId)
    if configItem ~ = nil then
        spec.fillUnitIndex = configItem.fillUnitIndex or spec.fillUnitIndex
        spec.treeTypeName = configItem.treeTypeName or spec.treeTypeName
        spec.variationName = configItem.variationName or spec.variationName
        spec.treeTypeFilename = configItem.treeTypeFilename or spec.treeTypeFilename
    end

    if savegame ~ = nil then
        spec.treeTypeName = savegame.xmlFile:getValue(savegame.key .. ".treeSaplingPallet#treeTypeName" , spec.treeTypeName)
        spec.variationName = savegame.xmlFile:getValue(savegame.key .. ".treeSaplingPallet#variationName" , spec.variationName)
    end

    if spec.treeTypeFilename = = nil then
        local treeTypeDesc = g_treePlantManager:getTreeTypeDescFromName(spec.treeTypeName)
        if treeTypeDesc ~ = nil then
            local variations = treeTypeDesc.stages[ 1 ]
            if variations ~ = nil then
                local variation
                for _, _variation in ipairs(variations) do
                    if string.lower(_variation.name or "DEFAULT" ) = = string.lower(spec.variationName or "DEFAULT" ) then
                        variation = _variation
                        break
                    end
                end

                if variation ~ = nil then
                    spec.treeTypeFilename = variation.palletFilename or variation.filename
                end
            end

            spec.infoBoxLineTitle = g_i18n:getText( "configuration_treeType" , self.customEnvironment)
            spec.infoBoxLineValue = treeTypeDesc.title
        end
    end

    if spec.treeTypeFilename ~ = nil then
        local nodeKey = baseKey .. ".saplingNodes.saplingNode"
        if not self.xmlFile:hasProperty(nodeKey) then
            nodeKey = "vehicle.treeSaplingPallet.saplingNodes.saplingNode"
        end

        self.xmlFile:iterate(nodeKey, function (_, key)
            local entry = { }
            entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)

            if entry.node ~ = nil then
                if self.xmlFile:getValue(key .. "#randomize" , true ) then
                    setRotation(entry.node, 0 , math.random( 0 , math.pi * 2 ), 0 )
                    setScale(entry.node, 1 , math.random( 90 , 110 ) / 100 , 1 )
                end

                table.insert(spec.saplingNodes, entry)
            end
        end )
    end

    self:updateTreeSaplingVisuals()
end

```

### onTreeSaplingLoaded

**Description**

> Called after the sapling has been loaded

**Definition**

> onTreeSaplingLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Return Values**

| any | i3dNode | i3d node id |
|-----|---------|-------------|
| any | args    | arguments   |

**Code**

```lua
function TreeSaplingPallet:onTreeSaplingLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local shape = getChildAt(i3dNode, 0 )

        local spec = self.spec_treeSaplingPallet
        for _, saplingNode in ipairs(spec.saplingNodes) do
            if saplingNode.saplingShape ~ = nil then
                delete(saplingNode.saplingShape)
            end

            saplingNode.saplingShape = clone(shape, false , false , false )
            link(saplingNode.node, saplingNode.saplingShape)
        end

        delete(i3dNode)

        self:updateTreeSaplingPalletNodes()
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
function TreeSaplingPallet.prerequisitesPresent(specializations)
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
function TreeSaplingPallet.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , TreeSaplingPallet )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , TreeSaplingPallet )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , TreeSaplingPallet )
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
function TreeSaplingPallet.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onTreeSaplingLoaded" , TreeSaplingPallet.onTreeSaplingLoaded)
    SpecializationUtil.registerFunction(vehicleType, "getTreeSaplingPalletType" , TreeSaplingPallet.getTreeSaplingPalletType)
    SpecializationUtil.registerFunction(vehicleType, "setTreeSaplingPalletType" , TreeSaplingPallet.setTreeSaplingPalletType)
    SpecializationUtil.registerFunction(vehicleType, "updateTreeSaplingVisuals" , TreeSaplingPallet.updateTreeSaplingVisuals)
    SpecializationUtil.registerFunction(vehicleType, "updateTreeSaplingPalletNodes" , TreeSaplingPallet.updateTreeSaplingPalletNodes)
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
function TreeSaplingPallet.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "showInfo" , TreeSaplingPallet.showInfo)
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
function TreeSaplingPallet:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_treeSaplingPallet

    if spec.treeTypeName ~ = nil then
        xmlFile:setValue(key .. "#treeTypeName" , spec.treeTypeName)
    end
    if spec.variationName ~ = nil then
        xmlFile:setValue(key .. "#variationName" , spec.variationName)
    end
end

```

### setTreeSaplingPalletType

**Description**

> Sets the current tree type

**Definition**

> setTreeSaplingPalletType()

**Arguments**

| any | treeTypeName  |
|-----|---------------|
| any | variationName |

**Return Values**

| any | name | tree type name |
|-----|------|----------------|

**Code**

```lua
function TreeSaplingPallet:setTreeSaplingPalletType(treeTypeName, variationName)
    local spec = self.spec_treeSaplingPallet
    if treeTypeName ~ = spec.treeTypeName or spec.variationName ~ = variationName then
        spec.treeTypeName, spec.variationName = treeTypeName, variationName
        self:updateTreeSaplingVisuals()
    end
end

```

### showInfo

**Description**

**Definition**

> showInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | box       |

**Code**

```lua
function TreeSaplingPallet:showInfo(superFunc, box)
    local spec = self.spec_treeSaplingPallet
    if spec.infoBoxLineTitle ~ = nil then
        box:addLine(spec.infoBoxLineTitle, spec.infoBoxLineValue)
    end

    superFunc( self , box)
end

```

### updateTreeSaplingPalletNodes

**Description**

**Definition**

> updateTreeSaplingPalletNodes()

**Code**

```lua
function TreeSaplingPallet:updateTreeSaplingPalletNodes()
    local spec = self.spec_treeSaplingPallet

    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
    local capacity = self:getFillUnitCapacity(spec.fillUnitIndex)
    for i = 1 , #spec.saplingNodes do
        local saplingNode = spec.saplingNodes[i]
        setVisibility(saplingNode.node, i < = MathUtil.round(fillLevel))

        I3DUtil.setShaderParameterRec(saplingNode.node, "hideByIndex" , capacity - fillLevel, 0 , 0 , 0 )
    end
end

```

### updateTreeSaplingVisuals

**Description**

> Sets the current tree type

**Definition**

> updateTreeSaplingVisuals()

**Return Values**

| any | name | tree type name |
|-----|------|----------------|

**Code**

```lua
function TreeSaplingPallet:updateTreeSaplingVisuals()
    local spec = self.spec_treeSaplingPallet

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
        spec.sharedLoadRequestId = nil
    end

    if spec.treeTypeFilename ~ = nil then
        if self.finishedLoading then
            spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(spec.treeTypeFilename, false , false , self.onTreeSaplingLoaded, self )
        else
                spec.sharedLoadRequestId = self:loadSubSharedI3DFile(spec.treeTypeFilename, false , false , self.onTreeSaplingLoaded, self )
            end
        end
    end

```