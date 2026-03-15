## MaterialManager

**Description**

> This class handles all materials

**Parent**

> [AbstractManager](?version=script&category=57&class=549)

**Functions**

- [addBaseMaterial](#addbasematerial)
- [addMaterial](#addmaterial)
- [addMaterialToTarget](#addmaterialtotarget)
- [addMaterialType](#addmaterialtype)
- [addModMaterialHolder](#addmodmaterialholder)
- [addParticleMaterial](#addparticlematerial)
- [getBaseMaterialByName](#getbasematerialbyname)
- [getFontMaterial](#getfontmaterial)
- [getMaterial](#getmaterial)
- [getMaterialFromTarget](#getmaterialfromtarget)
- [getMaterialTypeByName](#getmaterialtypebyname)
- [getParticleMaterial](#getparticlematerial)
- [initDataStructures](#initdatastructures)
- [loadFontMaterialsXML](#loadfontmaterialsxml)
- [loadMapData](#loadmapdata)
- [loadModMaterialHolders](#loadmodmaterialholders)
- [materialHolderLoaded](#materialholderloaded)
- [new](#new)
- [unloadMapData](#unloadmapdata)

### addBaseMaterial

**Description**

> Adds a new base material

**Definition**

> addBaseMaterial(string materialName, integer materialId)

**Arguments**

| string  | materialName | materialName         |
|---------|--------------|----------------------|
| integer | materialId   | internal material id |

**Code**

```lua
function MaterialManager:addBaseMaterial(materialName, materialId)
    self.baseMaterialsByName[ string.upper(materialName)] = materialId
    table.insert( self.baseMaterials, materialId)
end

```

### addMaterial

**Description**

> Adds a new material type

**Definition**

> addMaterial(integer fillTypeIndex, string materialType, integer materialIndex, integer materialId)

**Arguments**

| integer | fillTypeIndex | filltype index       |
|---------|---------------|----------------------|
| string  | materialType  | materialType         |
| integer | materialIndex | material index       |
| integer | materialId    | internal material id |

**Code**

```lua
function MaterialManager:addMaterial(fillTypeIndex, materialType, materialIndex, materialId)
    self:addMaterialToTarget( self.materials, fillTypeIndex, materialType, materialIndex, materialId)
end

```

### addMaterialToTarget

**Description**

> Adds a new material type to given target table

**Definition**

> addMaterialToTarget(table target, integer fillTypeIndex, string materialType, integer materialIndex, integer
> materialId)

**Arguments**

| table   | target        | target table         |
|---------|---------------|----------------------|
| integer | fillTypeIndex | filltype index       |
| string  | materialType  | materialType         |
| integer | materialIndex | material index       |
| integer | materialId    | internal material id |

**Code**

```lua
function MaterialManager:addMaterialToTarget(target, fillTypeIndex, materialType, materialIndex, materialId)
    if fillTypeIndex = = nil or materialType = = nil or materialIndex = = nil or materialId = = nil then
        return
    end

    if target[fillTypeIndex] = = nil then
        target[fillTypeIndex] = { }
    end
    local fillTypeMaterials = target[fillTypeIndex]

    if fillTypeMaterials[materialType] = = nil then
        fillTypeMaterials[materialType] = { }
    end
    local materialTypes = fillTypeMaterials[materialType]

    if g_showDevelopmentWarnings and materialTypes[materialIndex] ~ = nil then
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        Logging.devWarning( "Material type '%s' already exists for fillType '%s'.It will be overwritten!" , tostring(materialType), tostring(fillType.name))
        end

        materialTypes[materialIndex] = materialId
    end

```

### addMaterialType

**Description**

> Adds a new material type

**Definition**

> addMaterialType(string name)

**Arguments**

| string | name | name |
|--------|------|------|

**Code**

```lua
function MaterialManager:addMaterialType(name)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a materialType.Ignoring it!" )
            return nil
        end

        name = string.upper(name)

        if self.nameToIndex[name] = = nil then
            table.insert( self.materialTypes, name)
            self.nameToIndex[name] = # self.materialTypes
        end

        return nil
    end

```

### addModMaterialHolder

**Description**

> Returns material for given properties

**Definition**

> addModMaterialHolder()

**Arguments**

| any | filename |
|-----|----------|

**Code**

```lua
function MaterialManager:addModMaterialHolder(filename)
    self.modMaterialHoldersToLoad[filename] = filename
end

```

### addParticleMaterial

**Description**

> Adds a new particle material type

**Definition**

> addParticleMaterial(integer fillTypeIndex, string materialType, integer materialIndex, integer materialId)

**Arguments**

| integer | fillTypeIndex | filltype index       |
|---------|---------------|----------------------|
| string  | materialType  | materialType         |
| integer | materialIndex | material index       |
| integer | materialId    | internal material id |

**Code**

```lua
function MaterialManager:addParticleMaterial(fillTypeIndex, materialType, materialIndex, materialId)
    self:addMaterialToTarget( self.particleMaterials, fillTypeIndex, materialType, materialIndex, materialId)
end

```

### getBaseMaterialByName

**Description**

> Returns base material by given name

**Definition**

> getBaseMaterialByName(string materialName)

**Arguments**

| string | materialName | materialName |
|--------|--------------|--------------|

**Return Values**

| string | materialId | internal material id |
|--------|------------|----------------------|

**Code**

```lua
function MaterialManager:getBaseMaterialByName(materialName)
    if materialName ~ = nil then
        return self.baseMaterialsByName[ string.upper(materialName)]
    end

    return nil
end

```

### getFontMaterial

**Description**

**Definition**

> getFontMaterial()

**Arguments**

| any | materialName      |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function MaterialManager:getFontMaterial(materialName, customEnvironment)
    if customEnvironment ~ = nil and customEnvironment ~ = "" then
        local customMaterialName = customEnvironment .. "." .. materialName
        if self.fontMaterialsByName[customMaterialName] ~ = nil then
            return self.fontMaterialsByName[customMaterialName]
        end
    end

    return self.fontMaterialsByName[materialName]
end

```

### getMaterial

**Description**

> Returns material for given properties

**Definition**

> getMaterial(integer fillType, string materialTypeName, integer materialIndex)

**Arguments**

| integer | fillType         | fill type             |
|---------|------------------|-----------------------|
| string  | materialTypeName | name of material type |
| integer | materialIndex    | index of material     |

**Return Values**

| integer | materialId | id of material |
|---------|------------|----------------|

**Code**

```lua
function MaterialManager:getMaterial(fillType, materialTypeName, materialIndex)
    return self:getMaterialFromTarget( self.materials, fillType, materialTypeName, materialIndex)
end

```

### getMaterialFromTarget

**Description**

> Returns material for given properties

**Definition**

> getMaterialFromTarget(integer fillType, string materialTypeName, integer materialIndex, )

**Arguments**

| integer | fillType         | fill type             |
|---------|------------------|-----------------------|
| string  | materialTypeName | name of material type |
| integer | materialIndex    | index of material     |
| any     | materialIndex    |                       |

**Return Values**

| any | materialId | id of material |
|-----|------------|----------------|

**Code**

```lua
function MaterialManager:getMaterialFromTarget(target, fillType, materialTypeName, materialIndex)
    if fillType = = nil or materialTypeName = = nil or materialIndex = = nil then
        return nil
    end

    local materialType = self:getMaterialTypeByName(materialTypeName)
    if materialType = = nil then
        return nil
    end

    local fillTypeMaterials = target[fillType]
    if fillTypeMaterials = = nil then
        --#debug Logging.warning("missing fillType materials for fillType %s(materialTypeName %s, materialIndex %s)", g_fillTypeManager:getFillTypeNameByIndex(fillType), materialTypeName, materialIndex)
            return nil
        end

        local materials = fillTypeMaterials[materialType]
        if materials = = nil then
            --#debug Logging.warning("missing fillType materials for materialType %s", materialType)
                return nil
            end

            return materials[materialIndex]
        end

```

### getMaterialTypeByName

**Description**

> Returns a materialType by name

**Definition**

> getMaterialTypeByName(string name)

**Arguments**

| string | name | name of material type |
|--------|------|-----------------------|

**Return Values**

| string | materialType | the real material name, nil if not defined |
|--------|--------------|--------------------------------------------|

**Code**

```lua
function MaterialManager:getMaterialTypeByName(name)
    if name ~ = nil then
        name = string.upper(name)

        -- atm we just return the uppercase name because a material type is only defined as a base string
        if self.nameToIndex[name] ~ = nil then
            return name
        end
    end

    return nil
end

```

### getParticleMaterial

**Description**

> Returns material for given properties

**Definition**

> getParticleMaterial(integer fillType, string materialTypeName, integer materialIndex)

**Arguments**

| integer | fillType         | fill type             |
|---------|------------------|-----------------------|
| string  | materialTypeName | name of material type |
| integer | materialIndex    | index of material     |

**Return Values**

| integer | materialId | id of material |
|---------|------------|----------------|

**Code**

```lua
function MaterialManager:getParticleMaterial(fillType, materialTypeName, materialIndex)
    return self:getMaterialFromTarget( self.particleMaterials, fillType, materialTypeName, materialIndex)
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function MaterialManager:initDataStructures()
    self.nameToIndex = { }
    self.materialTypes = { }
    self.materials = { }
    self.particleMaterials = { }
    self.modMaterialHoldersToLoad = { }
    self.fontMaterials = { }
    self.fontMaterialsByName = { }

    self.baseMaterials = { }
    self.baseMaterialsByName = { }

    self.loadedMaterialHolderNodes = { }
end

```

### loadFontMaterialsXML

**Description**

**Definition**

> loadFontMaterialsXML()

**Arguments**

| any | xmlFilename       |
|-----|-------------------|
| any | customEnvironment |
| any | baseDirectory     |

**Code**

```lua
function MaterialManager:loadFontMaterialsXML(xmlFilename, customEnvironment, baseDirectory)
    self.xmlFile = XMLFile.load( "TempFonts" , xmlFilename, MaterialManager.fontMaterialXMLSchema)
    if self.xmlFile ~ = nil then
        self.xmlFile.references = 0

        self.xmlFile:iterate( "fonts.font" , function (index, key)
            self.xmlFile.references = self.xmlFile.references + 1

            local fontMaterial = FontMaterial.new()
            fontMaterial:loadFromXML( self.xmlFile, key, customEnvironment, baseDirectory, function (success)
                if self.xmlFile ~ = nil then
                    self.xmlFile.references = self.xmlFile.references - 1
                    if self.xmlFile.references = = 0 then
                        self.xmlFile:delete()
                        self.xmlFile = nil

                        if self.finishedLoadingCallback ~ = nil then
                            self.finishedLoadingCallback( self.callbackTarget)
                            self.finishedLoadingCallback = nil
                            self.callbackTarget = nil
                        end
                    end
                end

                if success then
                    table.insert( self.fontMaterials, fontMaterial)
                    self.fontMaterialsByName[fontMaterial.name] = fontMaterial
                end
            end )
        end )
    end

    if self.xmlFile = = nil or self.xmlFile.references = = 0 then
        if self.xmlFile ~ = nil then
            self.xmlFile:delete()
            self.xmlFile = nil
        end
        if self.finishedLoadingCallback ~ = nil then
            self.finishedLoadingCallback( self.callbackTarget)
            self.finishedLoadingCallback = nil
            self.callbackTarget = nil
        end
    end
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile                 |
|-----|-------------------------|
| any | missionInfo             |
| any | baseDirectory           |
| any | finishedLoadingCallback |
| any | callbackTarget          |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function MaterialManager:loadMapData(xmlFile, missionInfo, baseDirectory, finishedLoadingCallback, callbackTarget)
    MaterialManager:superClass().loadMapData( self )

    self:addMaterialType( "fillplane" )
    self:addMaterialType( "icon" )
    self:addMaterialType( "unloading" )
    self:addMaterialType( "smoke" )
    self:addMaterialType( "straw" )
    self:addMaterialType( "chopper" )
    self:addMaterialType( "soil" )
    self:addMaterialType( "sprayer" )
    self:addMaterialType( "spreader" )
    self:addMaterialType( "pipe" )
    self:addMaterialType( "mower" )
    self:addMaterialType( "belt" )
    self:addMaterialType( "belt_cropDirt" )
    self:addMaterialType( "belt_cropClean" )
    self:addMaterialType( "leveler" )
    self:addMaterialType( "washer" )
    self:addMaterialType( "pickup" )

    MaterialType = self.nameToIndex

    -- called after last font material was loaded
    self.finishedLoadingCallback = finishedLoadingCallback
    self.callbackTarget = callbackTarget

    self:loadFontMaterialsXML( MaterialManager.DEFAULT_FONT_MATERIAL_XML, nil , self.baseDirectory)

    return true
end

```

### loadModMaterialHolders

**Description**

**Definition**

> loadModMaterialHolders()

**Code**

```lua
function MaterialManager:loadModMaterialHolders()
    for filename, _ in pairs( self.modMaterialHoldersToLoad) do
        g_i3DManager:loadI3DFileAsync(filename, true , true , MaterialManager.materialHolderLoaded, self , nil )
    end
end

```

### materialHolderLoaded

**Description**

**Definition**

> materialHolderLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function MaterialManager:materialHolderLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        for i = getNumOfChildren(i3dNode) - 1 , 0 , - 1 do
            local child = getChildAt(i3dNode, i)
            unlink(child)
            table.insert( self.loadedMaterialHolderNodes, child)
        end

        delete(i3dNode)
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
function MaterialManager.new(customMt)
    local self = AbstractManager.new(customMt or MaterialManager _mt)

    MaterialManager.fontMaterialXMLSchema = XMLSchema.new( "fontMaterials" )
    FontMaterial.registerXMLPaths( MaterialManager.fontMaterialXMLSchema)

    return self
end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function MaterialManager:unloadMapData()
    for _, node in ipairs( self.loadedMaterialHolderNodes) do
        delete(node)
    end

    if self.xmlFile ~ = nil then
        self.xmlFile:delete()
        self.xmlFile = nil
    end

    for _, font in ipairs( self.fontMaterials) do
        delete(font.materialNode)
        if font.materialNodeNoNormal ~ = nil then
            delete(font.materialNodeNoNormal)
        end
        if font.characterShape ~ = nil then
            delete(font.characterShape)
        end
        if font.sharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(font.sharedLoadRequestId)
        end
    end

    MaterialManager:superClass().unloadMapData( self )
end

```