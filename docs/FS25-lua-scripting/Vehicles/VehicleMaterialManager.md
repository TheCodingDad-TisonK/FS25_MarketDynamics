## VehicleMaterialManager

**Description**

> This class handles the material templates that are used with the vehicle shader

**Parent**

> [AbstractManager](?version=script&category=91&class=893)

**Functions**

- [addModMaterialTemplatesToLoad](#addmodmaterialtemplatestoload)
- [getMaterialTemplateByName](#getmaterialtemplatebyname)
- [getMaterialTemplateColorAndTitleByName](#getmaterialtemplatecolorandtitlebyname)
- [getMaterialTemplateColorByName](#getmaterialtemplatecolorbyname)
- [getMaterialTemplateFinish](#getmaterialtemplatefinish)
- [getMaterialTemplateIndexByName](#getmaterialtemplateindexbyname)
- [getMaterialTemplateNameByIndex](#getmaterialtemplatenamebyindex)
- [initDataStructures](#initdatastructures)
- [loadMapData](#loadmapdata)
- [loadMaterialTemplates](#loadmaterialtemplates)
- [loadMaterialTemplatesFromXML](#loadmaterialtemplatesfromxml)
- [registerXMLPaths](#registerxmlpaths)

### addModMaterialTemplatesToLoad

**Description**

**Definition**

> addModMaterialTemplatesToLoad()

**Arguments**

| any | xmlFilename       |
|-----|-------------------|
| any | key               |
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function VehicleMaterialManager:addModMaterialTemplatesToLoad(xmlFilename, key, baseDirectory, customEnvironment)
    table.insert( self.modMaterialTemplatesToLoad, { xmlFilename = xmlFilename, key = key, baseDirectory = baseDirectory, customEnvironment = customEnvironment } )
end

```

### getMaterialTemplateByName

**Description**

**Definition**

> getMaterialTemplateByName()

**Arguments**

| any | name              |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateByName(name, customEnvironment)
    if name ~ = nil then
        if customEnvironment ~ = nil then
            local template = self.materialTemplatesByName[ string.upper(customEnvironment .. "." .. name)]
            if template ~ = nil then
                return template
            end
        end

        return self.materialTemplatesByName[ string.upper(name)]
    end

    return nil
end

```

### getMaterialTemplateColorAndTitleByName

**Description**

**Definition**

> getMaterialTemplateColorAndTitleByName()

**Arguments**

| any | name              |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateColorAndTitleByName(name, customEnvironment)
    if name ~ = nil then
        name = string.upper(name)
        local materialTemplate = self:getMaterialTemplateByName(name, customEnvironment)
        if materialTemplate ~ = nil then
            local title
            if materialTemplate.brand ~ = nil then
                title = materialTemplate.brand.title
            end

            if materialTemplate.titleL10N ~ = nil then
                if title ~ = nil then
                    title = title .. " "
                else
                        title = ""
                    end

                    title = title .. g_i18n:convertText(materialTemplate.titleL10N, materialTemplate.customEnvironment)
                end

                if materialTemplate.colorScale = = nil then
                    return { 1 , 1 , 1 } , title
                end

                return table.clone(materialTemplate.colorScale), title
            end
        end

        return nil , nil
    end

```

### getMaterialTemplateColorByName

**Description**

**Definition**

> getMaterialTemplateColorByName()

**Arguments**

| any | name              |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateColorByName(name, customEnvironment)
    if name ~ = nil then
        name = string.upper(name)
        local materialTemplate = self:getMaterialTemplateByName(name, customEnvironment)
        if materialTemplate ~ = nil and materialTemplate.colorScale ~ = nil then
            return { materialTemplate.colorScale[ 1 ], materialTemplate.colorScale[ 2 ], materialTemplate.colorScale[ 3 ], 0 }
        end
    end

    return nil
end

```

### getMaterialTemplateFinish

**Description**

**Definition**

> getMaterialTemplateFinish()

**Arguments**

| any | materialTemplateName |
|-----|----------------------|

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateFinish(materialTemplateName)
    local isMetallic, isMat = false , false
    if materialTemplateName = = nil then
        return isMetallic, isMat
    end

    local materialTemplateNameLower = string.lower(materialTemplateName)

    if materialTemplateNameLower:contains( "silver" )
        or materialTemplateNameLower:contains( "copper" )
        or materialTemplateNameLower:contains( "gold" )
        or materialTemplateNameLower:contains( "bronze" )
        or materialTemplateNameLower:contains( "chrome" )
        or materialTemplateNameLower:contains( "metallic" ) then
        isMetallic = true
    end

    if materialTemplateNameLower:contains( "matpaint" ) then
        isMat = true
    end

    return isMetallic, isMat
end

```

### getMaterialTemplateIndexByName

**Description**

**Definition**

> getMaterialTemplateIndexByName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateIndexByName(name)
    if name ~ = nil then
        name = string.upper(name)
        for i, materialTemplate in ipairs( self.materialTemplates) do
            if materialTemplate.name = = name then
                return i
            end
        end
    end

    return 1
end

```

### getMaterialTemplateNameByIndex

**Description**

**Definition**

> getMaterialTemplateNameByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function VehicleMaterialManager:getMaterialTemplateNameByIndex(index)
    local template = self.materialTemplates[index] or self.materialTemplates[ 1 ]
    return template.name
end

```

### initDataStructures

**Description**

**Definition**

> initDataStructures()

**Code**

```lua
function VehicleMaterialManager:initDataStructures()
    self.materialTemplates = { }
    self.materialTemplatesByName = { }
    self.modMaterialTemplatesToLoad = { }
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData(integer mapXMLFile, table missionInfo, string baseDirectory)

**Arguments**

| integer | mapXMLFile    |
|---------|---------------|
| table   | missionInfo   |
| string  | baseDirectory |

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function VehicleMaterialManager:loadMapData(mapXMLFile, missionInfo, baseDirectory)
    self:loadMaterialTemplates( VehicleMaterialManager.DEFAULT_TEMPLATES_FILENAME)
    self:loadMaterialTemplates( VehicleMaterialManager.DEFAULT_BRAND_TEMPLATES_FILENAME)

    for i = # self.modMaterialTemplatesToLoad, 1 , - 1 do
        local modMaterialTemplate = self.modMaterialTemplatesToLoad[i]

        local xmlFile = XMLFile.load( "ModFile" , modMaterialTemplate.xmlFilename, g_modDescSchema)
        if xmlFile ~ = nil then
            self:loadMaterialTemplatesFromXML(xmlFile, modMaterialTemplate.key, modMaterialTemplate.baseDirectory, modMaterialTemplate.customEnvironment, "calibratedPaint" )

            xmlFile:delete()
        end

        table.remove( self.modMaterialTemplatesToLoad, i)
    end
end

```

### loadMaterialTemplates

**Description**

**Definition**

> loadMaterialTemplates()

**Arguments**

| any | xmlFilename       |
|-----|-------------------|
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function VehicleMaterialManager:loadMaterialTemplates(xmlFilename, baseDirectory, customEnvironment)
    local xmlFile = XMLFile.load( "templates" , xmlFilename, VehicleMaterialManager.xmlSchema)
    if xmlFile ~ = nil then
        self:loadMaterialTemplatesFromXML(xmlFile, "templates" , baseDirectory, customEnvironment)
        xmlFile:delete()
    end
end

```

### loadMaterialTemplatesFromXML

**Description**

**Definition**

> loadMaterialTemplatesFromXML()

**Arguments**

| any | xmlFile               |
|-----|-----------------------|
| any | key                   |
| any | baseDirectory         |
| any | customEnvironment     |
| any | parentTemplateDefault |

**Code**

```lua
function VehicleMaterialManager:loadMaterialTemplatesFromXML(xmlFile, key, baseDirectory, customEnvironment, parentTemplateDefault)
    parentTemplateDefault = xmlFile:getValue(key .. "#parentTemplateDefault" , parentTemplateDefault)

    xmlFile:iterate(key .. ".template" , function (index, templateKey)
        local name = xmlFile:getValue(templateKey .. "#name" )
        if name ~ = nil then
            if customEnvironment ~ = nil then
                name = string.upper(customEnvironment .. "." .. name)
            else
                    name = string.upper(name)
                end

                local parentName = xmlFile:getValue(templateKey .. "#parentTemplate" , parentTemplateDefault)
                local parentTemplate
                if parentName ~ = nil then
                    parentTemplate = self.materialTemplatesByName[ string.upper(parentName)]
                    if parentTemplate = = nil then
                        Logging.xmlWarning(xmlFile, "Unable to find parent template '%s' for '%s'" , parentName, templateKey)
                            return
                        end
                    end

                    local materialTemplate = self.materialTemplatesByName[name]
                    if materialTemplate = = nil then
                        materialTemplate = { }
                    end

                    materialTemplate.name = name
                    materialTemplate.parentTemplate = parentTemplate or materialTemplate

                    materialTemplate.customEnvironment = customEnvironment

                    local brandName = xmlFile:getValue(templateKey .. "#brand" )
                    if brandName ~ = nil then
                        materialTemplate.brand = g_brandManager:getBrandByName(brandName)
                        if materialTemplate.brand = = nil then
                            Logging.xmlWarning(xmlFile, "Unknown brand '%s' defined in material template '%s'" , brandName, templateKey)
                        end
                    end

                    materialTemplate.titleL10N = xmlFile:getValue(templateKey .. "#title" )

                    materialTemplate.colorScale = xmlFile:getValue(templateKey .. "#colorScale" , nil , true )

                    materialTemplate.smoothnessScale = xmlFile:getValue(templateKey .. "#smoothnessScale" )
                    materialTemplate.metalnessScale = xmlFile:getValue(templateKey .. "#metalnessScale" )
                    materialTemplate.clearCoatSmoothness = xmlFile:getValue(templateKey .. "#clearCoatSmoothness" )
                    materialTemplate.clearCoatIntensity = xmlFile:getValue(templateKey .. "#clearCoatIntensity" )
                    materialTemplate.porosity = xmlFile:getValue(templateKey .. "#porosity" )

                    materialTemplate.detailDiffuse = xmlFile:getValue(templateKey .. "#detailDiffuse" )
                    if materialTemplate.detailDiffuse ~ = nil then
                        materialTemplate.detailDiffuse = Utils.getFilename(materialTemplate.detailDiffuse, baseDirectory)
                        if not textureFileExists(materialTemplate.detailDiffuse) then
                            Logging.xmlWarning(xmlFile, "Unable to find detail texture '%s' in '%s'" , materialTemplate.detailDiffuse, templateKey)
                            materialTemplate.detailDiffuse = nil
                        end
                    end
                    if materialTemplate.detailDiffuse = = nil and materialTemplate.parentTemplate.detailDiffuse = = nil then
                        Logging.xmlWarning(xmlFile, "Missing detail diffuse texture for '%s'" , templateKey)
                            return
                        end

                        materialTemplate.detailNormal = xmlFile:getValue(templateKey .. "#detailNormal" )
                        if materialTemplate.detailNormal ~ = nil then
                            materialTemplate.detailNormal = Utils.getFilename(materialTemplate.detailNormal, baseDirectory)
                            if not textureFileExists(materialTemplate.detailNormal) then
                                Logging.xmlWarning(xmlFile, "Unable to find detail texture '%s' in '%s'" , materialTemplate.detailNormal, templateKey)
                                materialTemplate.detailNormal = nil
                            end
                        end
                        if materialTemplate.detailNormal = = nil and materialTemplate.parentTemplate.detailNormal = = nil then
                            Logging.xmlWarning(xmlFile, "Missing detail normal texture for '%s'" , templateKey)
                                return
                            end

                            materialTemplate.detailSpecular = xmlFile:getValue(templateKey .. "#detailSpecular" )
                            if materialTemplate.detailSpecular ~ = nil then
                                materialTemplate.detailSpecular = Utils.getFilename(materialTemplate.detailSpecular, baseDirectory)
                                if not textureFileExists(materialTemplate.detailSpecular) then
                                    Logging.xmlWarning(xmlFile, "Unable to find detail texture '%s' in '%s'" , materialTemplate.detailSpecular, templateKey)
                                    materialTemplate.detailSpecular = nil
                                end
                            end
                            if materialTemplate.detailSpecular = = nil and materialTemplate.parentTemplate.detailSpecular = = nil then
                                Logging.xmlWarning(xmlFile, "Missing detail specular texture for '%s'" , templateKey)
                                    return
                                end

                                table.insert( self.materialTemplates, materialTemplate)
                                self.materialTemplatesByName[name] = materialTemplate
                            else
                                    Logging.xmlWarning(xmlFile, "Missing name attribute for '%s'" , templateKey)
                                    end
                                end )
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
function VehicleMaterialManager.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#id" , "File Identifier" )
    schema:register(XMLValueType.STRING, basePath .. "#name" , "File Name" )

    schema:register(XMLValueType.STRING, basePath .. "#parentTemplateDefault" , "Name of default parent template" )
    schema:register(XMLValueType.STRING, basePath .. "#parentTemplateFilename" , "Path to parent template file" )

    schema:register(XMLValueType.STRING, basePath .. ".template(?)#name" , "Name of template" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#title" , "Name of the color to display in the shop" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#description" , "Descrpition text of the template" )
    schema:register(XMLValueType.INT, basePath .. ".template(?)#usage" , "Usage of the color" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#parentTemplate" , "Name of parent template" , "templates#parentTemplateDefault" )

    schema:register(XMLValueType.STRING, basePath .. ".template(?)#brand" , "Brand identifier" )

    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".template(?)#colorScale" , "Color values(sRGB)" )

    schema:register(XMLValueType.FLOAT, basePath .. ".template(?)#smoothnessScale" )
    schema:register(XMLValueType.FLOAT, basePath .. ".template(?)#metalnessScale" )
    schema:register(XMLValueType.FLOAT, basePath .. ".template(?)#clearCoatSmoothness" )
    schema:register(XMLValueType.FLOAT, basePath .. ".template(?)#clearCoatIntensity" )
    schema:register(XMLValueType.FLOAT, basePath .. ".template(?)#porosity" )

    schema:register(XMLValueType.STRING, basePath .. ".template(?)#category" , "Category name(Used by DCC Tool)" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#iconFilename" , "Icon filename(Used by DCC Tool)" )

    schema:register(XMLValueType.STRING, basePath .. ".template(?)#detailDiffuse" , "Detail diffuse texture" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#detailNormal" , "Detail normal texture" )
    schema:register(XMLValueType.STRING, basePath .. ".template(?)#detailSpecular" , "Detail specular texture" )

    schema:register(XMLValueType.STRING, basePath .. ".template(?).colorScan#filename" , "Path to scan reference" )
    schema:register(XMLValueType.BOOL, basePath .. ".template(?).colorScan#channelR" , "Calibrate red channel" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".template(?).colorScan#channelG" , "Calibrate green channel" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".template(?).colorScan#channelB" , "Calibrate blue channel" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".template(?).colorScan#channelSmoothness" , "Calibrate smoothness" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".template(?).colorScan#channelMetalness" , "Calibrate metalness" , true )
end

```