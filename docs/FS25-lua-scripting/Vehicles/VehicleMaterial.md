## VehicleMaterial

**Description**

> Stores data of vehicle materials (color, smoothness, clear coat, detail textures)

**Functions**

- [apply](#apply)
- [applyToMaterial](#applytomaterial)
- [applyToVehicle](#applytovehicle)
- [clone](#clone)
- [getBrightness](#getbrightness)
- [getIsApplied](#getisapplied)
- [loadFromXML](#loadfromxml)
- [loadShortFromXML](#loadshortfromxml)
- [new](#new)
- [registerShortXMLPaths](#registershortxmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setColor](#setcolor)
- [setTemplateName](#settemplatename)

### apply

**Description**

**Definition**

> apply()

**Arguments**

| any | node                   |
|-----|------------------------|
| any | targetMaterialSlotName |
| any | colorOnly              |

**Code**

```lua
function VehicleMaterial:apply(node, targetMaterialSlotName, colorOnly)
    local success = false
    targetMaterialSlotName = targetMaterialSlotName or self.targetMaterialSlotName

    if getHasClassId(node, ClassIds.SHAPE) then
        for i = 1 , getNumOfMaterials(node) do
            local materialSlotName = getMaterialSlotName(node, i - 1 )
            if materialSlotName = = targetMaterialSlotName or targetMaterialSlotName = = nil then
                self:applyToMaterial(node, i - 1 , colorOnly)

                success = true
            end
        end
    end

    for i = 1 , getNumOfChildren(node) do
        success = self:apply(getChildAt(node, i - 1 ), targetMaterialSlotName, colorOnly) or success
    end

    return success
end

```

### applyToMaterial

**Description**

**Definition**

> applyToMaterial()

**Arguments**

| any | node          |
|-----|---------------|
| any | materialIndex |
| any | colorOnly     |

**Code**

```lua
function VehicleMaterial:applyToMaterial(node, materialIndex, colorOnly)
    if self.colorScale ~ = nil then
        setShaderParameter(node, "colorScale" , self.colorScale[ 1 ], self.colorScale[ 2 ], self.colorScale[ 3 ], nil , false , materialIndex)
    end

    if colorOnly then
        return
    end

    if self.smoothnessScale ~ = nil then
        setShaderParameter(node, "smoothnessScale" , self.smoothnessScale, nil , nil , nil , false , materialIndex)
    end

    if self.metalnessScale ~ = nil then
        setShaderParameter(node, "metalnessScale" , self.metalnessScale, nil , nil , nil , false , materialIndex)
    end

    if self.clearCoatSmoothness ~ = nil then
        setShaderParameter(node, "clearCoatSmoothness" , self.clearCoatSmoothness, nil , nil , nil , false , materialIndex)
    end

    if self.clearCoatIntensity ~ = nil then
        setShaderParameter(node, "clearCoatIntensity" , self.clearCoatIntensity, nil , nil , nil , false , materialIndex)
    end

    if self.porosity ~ = nil then
        setShaderParameter(node, "porosity" , self.porosity, nil , nil , nil , false , materialIndex)
    end

    local materialId = getMaterial(node, materialIndex)
    local newMaterialId = materialId

    if self.detailDiffuse ~ = nil then
        newMaterialId = setMaterialCustomMapFromFile(newMaterialId, "detailDiffuse" , self.detailDiffuse, false , true , false )
    end

    if self.detailNormal ~ = nil then
        newMaterialId = setMaterialCustomMapFromFile(newMaterialId, "detailNormal" , self.detailNormal, false , false , false )
    end

    if self.detailSpecular ~ = nil then
        newMaterialId = setMaterialCustomMapFromFile(newMaterialId, "detailSpecular" , self.detailSpecular, false , false , false )
    end

    if self.diffuseMap ~ = nil then
        newMaterialId = setMaterialDiffuseMapFromFile(newMaterialId, self.diffuseMap, false , true , false )
    end

    if self.normalMap ~ = nil then
        newMaterialId = setMaterialNormalMapFromFile(newMaterialId, self.normalMap, false , false , false )
    end

    if self.specularMap ~ = nil then
        newMaterialId = setMaterialGlossMapFromFile(newMaterialId, self.specularMap, false , false , false )
    end

    if newMaterialId ~ = materialId then
        setMaterial(node, newMaterialId, materialIndex)
    end
end

```

### applyToVehicle

**Description**

**Definition**

> applyToVehicle()

**Arguments**

| any | vehicle                |
|-----|------------------------|
| any | targetMaterialSlotName |

**Code**

```lua
function VehicleMaterial:applyToVehicle(vehicle, targetMaterialSlotName)
    local success = false
    for i, component in ipairs(vehicle.components) do
        success = self:apply(component.node, targetMaterialSlotName) or success
    end

    return success
end

```

### clone

**Description**

**Definition**

> clone()

**Code**

```lua
function VehicleMaterial:clone()
    local material = VehicleMaterial.new( self.baseDirectory)

    material.targetMaterialSlotName = self.targetMaterialSlotName

    material.templateName = self.templateName
    material.materialTemplate = self.materialTemplate

    material.colorScale = self.colorScale

    material.smoothnessScale = self.smoothnessScale
    material.metalnessScale = self.metalnessScale
    material.clearCoatSmoothness = self.clearCoatSmoothness
    material.clearCoatIntensity = self.clearCoatIntensity
    material.porosity = self.porosity

    material.detailDiffuse = self.detailDiffuse
    material.detailNormal = self.detailNormal
    material.detailSpecular = self.detailSpecular

    material.diffuseMap = self.diffuseMap
    material.normalMap = self.normalMap
    material.specularMap = self.specularMap

    return material
end

```

### getBrightness

**Description**

**Definition**

> getBrightness()

**Code**

```lua
function VehicleMaterial:getBrightness()
    if self.colorScale = = nil then
        return nil
    end

    return MathUtil.getBrightnessFromColor( self.colorScale[ 1 ], self.colorScale[ 2 ], self.colorScale[ 3 ])
end

```

### getIsApplied

**Description**

**Definition**

> getIsApplied()

**Arguments**

| any | node       |
|-----|------------|
| any | materialId |
| any | checkColor |

**Code**

```lua
function VehicleMaterial:getIsApplied(node, materialId, checkColor)
    if checkColor ~ = false then
        local r, g, b, _ = getMaterialCustomParameter(materialId, "colorScale" )

        if self.colorScale ~ = nil then
            if r ~ = self.colorScale[ 1 ] or g ~ = self.colorScale[ 2 ] or b ~ = self.colorScale[ 3 ] then
                return false
            end
        else
                if r ~ = 1 or g ~ = 1 or b ~ = 1 then
                    return false
                end
            end
        end

        local smoothness = getMaterialCustomParameter(materialId, "smoothnessScale" )
        if self.smoothnessScale ~ = nil and smoothness ~ = self.smoothnessScale then
            return false
        elseif self.smoothnessScale = = nil and smoothness ~ = 1 then
                return false
            end

            local metalness = getMaterialCustomParameter(materialId, "metalnessScale" )
            if self.metalnessScale ~ = nil and metalness ~ = self.metalnessScale then
                return false
            elseif self.metalnessScale = = nil and metalness ~ = 1 then
                    return false
                end

                local clearCoatSmoothness = getMaterialCustomParameter(materialId, "clearCoatSmoothness" )
                if self.clearCoatSmoothness ~ = nil and clearCoatSmoothness ~ = self.clearCoatSmoothness then
                    return false
                elseif self.clearCoatSmoothness = = nil and clearCoatSmoothness ~ = 0 then
                        return false
                    end

                    local clearCoatIntensity = getMaterialCustomParameter(materialId, "clearCoatIntensity" )
                    if self.clearCoatIntensity ~ = nil and clearCoatIntensity ~ = self.clearCoatIntensity then
                        return false
                    elseif self.clearCoatIntensity = = nil and clearCoatIntensity ~ = 0 then
                            return false
                        end

                        local porosity = getMaterialCustomParameter(materialId, "porosity" )
                        if self.porosity ~ = nil and porosity ~ = self.porosity then
                            return false
                        elseif self.porosity = = nil and porosity ~ = 0 then
                                return false
                            end

                            local detailDiffuse = getMaterialCustomMapFilename(materialId, "detailDiffuse" )
                            if self.detailDiffuse ~ = nil and detailDiffuse ~ = self.detailDiffuse then
                                return false
                            end

                            local detailNormal = getMaterialCustomMapFilename(materialId, "detailNormal" )
                            if self.detailNormal ~ = nil and detailNormal ~ = self.detailNormal then
                                return false
                            end

                            local detailSpecular = getMaterialCustomMapFilename(materialId, "detailSpecular" )
                            if self.detailSpecular ~ = nil and detailSpecular ~ = self.detailSpecular then
                                return false
                            end

                            local diffuseMap = getMaterialDiffuseMapFilename(materialId)
                            if self.diffuseMap ~ = nil and diffuseMap ~ = self.diffuseMap then
                                return false
                            end

                            local normalMap = getMaterialNormalMapFilename(materialId)
                            if self.normalMap ~ = nil and normalMap ~ = self.normalMap then
                                return false
                            end

                            local specularMap = getMaterialGlossMapFilename(materialId)
                            if self.specularMap ~ = nil and specularMap ~ = self.specularMap then
                                return false
                            end

                            return true
                        end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | customEnvironment |

**Code**

```lua
function VehicleMaterial:loadFromXML(xmlFile, key, customEnvironment)
    self.targetMaterialSlotName = xmlFile:getValue(key .. "#materialSlotName" )

    local templateName = self.templateName or xmlFile:getValue(key .. "#materialTemplateName" )
    if templateName ~ = nil and templateName ~ = self.templateName then
        local materialTemplateUseColorOnly = xmlFile:getValue(key .. "#materialTemplateUseColorOnly" , false )
        if not self:setTemplateName(templateName, materialTemplateUseColorOnly, customEnvironment) then
            Logging.xmlWarning(xmlFile.xmlFile or xmlFile, "Unable to find material template '%s' in '%s'" , templateName, key)
            return false
        end
    end

    local colorStr = xmlFile:getValue(key .. ".colorScale#value" )
    if colorStr ~ = nil then
        local colorTemplate = g_vehicleMaterialManager:getMaterialTemplateByName(colorStr, customEnvironment)
        if colorTemplate ~ = nil then
            self.colorScale = colorTemplate.colorScale or colorTemplate.parentTemplate.colorScale
        else
                self.colorScale = string.getVector(colorStr, 3 ) or self.colorScale
            end
        end

        self.smoothnessScale = xmlFile:getValue(key .. ".smoothness#value" , self.smoothnessScale)
        self.metalnessScale = xmlFile:getValue(key .. ".metalness#value" , self.metalnessScale)
        self.clearCoatSmoothness = xmlFile:getValue(key .. ".clearCoat#smoothness" , self.clearCoatSmoothness)
        self.clearCoatIntensity = xmlFile:getValue(key .. ".clearCoat#intensity" , self.clearCoatIntensity)

        local detailDiffuse = xmlFile:getValue(key .. ".detail#diffuse" , nil , self.baseDirectory)
        self.detailDiffuse = detailDiffuse or self.detailDiffuse

        local detailNormal = xmlFile:getValue(key .. ".detail#normal" , nil , self.baseDirectory)
        self.detailNormal = detailNormal or self.detailNormal

        local detailSpecular = xmlFile:getValue(key .. ".detail#specular" , nil , self.baseDirectory)
        self.detailSpecular = detailSpecular or self.detailSpecular

        local diffuseMap = xmlFile:getValue(key .. ".textures#diffuse" , nil , self.baseDirectory)
        self.diffuseMap = diffuseMap or self.diffuseMap

        local normalMap = xmlFile:getValue(key .. ".textures#normal" , nil , self.baseDirectory)
        self.normalMap = normalMap or self.normalMap

        local specularMap = xmlFile:getValue(key .. ".textures#specular" , nil , self.baseDirectory)
        self.specularMap = specularMap or self.specularMap

        return self.colorScale ~ = nil
        or self.smoothnessScale ~ = nil
        or self.metalnessScale ~ = nil
        or self.clearCoatSmoothness ~ = nil
        or self.clearCoatIntensity ~ = nil
        or self.porosity ~ = nil
        or self.detailDiffuse ~ = nil
        or self.detailNormal ~ = nil
        or self.detailSpecular ~ = nil
        or self.diffuseMap ~ = nil
        or self.normalMap ~ = nil
        or self.specularMap ~ = nil
    end

```

### loadShortFromXML

**Description**

**Definition**

> loadShortFromXML()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | customEnvironment |

**Code**

```lua
function VehicleMaterial:loadShortFromXML(xmlFile, key, customEnvironment)
    self.targetMaterialSlotName = xmlFile:getValue(key .. "#materialSlotName" )

    local templateName = self.templateName or xmlFile:getValue(key .. "#materialTemplateName" )
    if templateName ~ = nil then
        local materialTemplateUseColorOnly = xmlFile:getValue(key .. "#materialTemplateUseColorOnly" , false )
        if not self:setTemplateName(templateName, materialTemplateUseColorOnly, customEnvironment) then
            Logging.xmlWarning(xmlFile.xmlFile or xmlFile, "Unable to find material template '%s' in '%s'" , templateName, key)
            return false
        end

        local templateNameColor = xmlFile:getValue(key .. "#materialTemplateNameColor" )
        if templateNameColor ~ = nil then
            local materialTemplate = g_vehicleMaterialManager:getMaterialTemplateByName(templateNameColor, customEnvironment)
            if materialTemplate ~ = nil then
                self.colorScale = materialTemplate.colorScale or materialTemplate.parentTemplate.colorScale
            end
        end
    else
            return false
        end

        return true
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | baseDirectory |
|-----|---------------|
| any | customMt      |

**Code**

```lua
function VehicleMaterial.new(baseDirectory, customMt)
    local self = setmetatable( { } , customMt or VehicleMaterial _mt)

    self.baseDirectory = baseDirectory
    self.colorOnly = false

    return self
end

```

### registerShortXMLPaths

**Description**

**Definition**

> registerShortXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function VehicleMaterial.registerShortXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#materialSlotName" , "Material slot name in the i3d file" )
    schema:register(XMLValueType.STRING, basePath .. "#materialTemplateName" , "Name of template to apply(all attributes will be used from template)" )
    schema:registerAutoCompletionDataSource(basePath .. "#materialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
    schema:register(XMLValueType.BOOL, basePath .. "#materialTemplateUseColorOnly" , "If 'true', only the color is used from the material template.The rest from the i3d file." , false )
    schema:register(XMLValueType.STRING, basePath .. "#materialTemplateNameColor" , "Name of the material template that is used ONLY for the color" )
        schema:registerAutoCompletionDataSource(basePath .. "#materialTemplateNameColor" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
    end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function VehicleMaterial.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#materialSlotName" , "Material slot name in the i3d file" )
    schema:register(XMLValueType.STRING, basePath .. "#materialTemplateName" , "Name of template to apply(all attributes will be used from template)" )
    schema:registerAutoCompletionDataSource(basePath .. "#materialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
    schema:register(XMLValueType.BOOL, basePath .. "#materialTemplateUseColorOnly" , "If 'true', only the color is used from the material template.The rest from the i3d file." , false )

    schema:register(XMLValueType.STRING, basePath .. ".colorScale#value" , "Material color if it should not be used from configuration(can also be a different material template, from which then ONLY the color is taken)" )

        schema:register(XMLValueType.FLOAT, basePath .. ".smoothness#value" , "Smoothness value" )
        schema:register(XMLValueType.FLOAT, basePath .. ".metalness#value" , "Metalness value" )
        schema:register(XMLValueType.FLOAT, basePath .. ".clearCoat#smoothness" , "Smoothness of clear coat" )
        schema:register(XMLValueType.FLOAT, basePath .. ".clearCoat#intensity" , "Intensity of clear coat" )

        schema:register(XMLValueType.FILENAME, basePath .. ".detail#diffuse" , "Path to detail diffuse texture" )
        schema:register(XMLValueType.FILENAME, basePath .. ".detail#normal" , "Path to detail normal texture" )
        schema:register(XMLValueType.FILENAME, basePath .. ".detail#specular" , "Path to detail specular texture" )

        schema:register(XMLValueType.FILENAME, basePath .. ".textures#diffuse" , "Path to diffuse texture" )
        schema:register(XMLValueType.FILENAME, basePath .. ".textures#normal" , "Path to normal texture" )
        schema:register(XMLValueType.FILENAME, basePath .. ".textures#specular" , "Path to specular texture" )
    end

```

### setColor

**Description**

**Definition**

> setColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |

**Code**

```lua
function VehicleMaterial:setColor(r, g, b)
    if r = = nil then
        return
    end

    if type(r) = = "table" then
        self.colorScale = { r[ 1 ], r[ 2 ], r[ 3 ] }
    else
            self.colorScale = { r, g, b }
        end
    end

```

### setTemplateName

**Description**

**Definition**

> setTemplateName()

**Arguments**

| any | templateName      |
|-----|-------------------|
| any | colorOnly         |
| any | customEnvironment |

**Code**

```lua
function VehicleMaterial:setTemplateName(templateName, colorOnly, customEnvironment)
    self.templateName = templateName

    self.materialTemplate = g_vehicleMaterialManager:getMaterialTemplateByName(templateName, customEnvironment)
    if self.materialTemplate ~ = nil then
        self.colorScale = self.materialTemplate.colorScale or self.materialTemplate.parentTemplate.colorScale
        if self.colorScale = = nil then
            self.colorScale = { 1 , 1 , 1 }
        end

        if colorOnly then
            return true
        end

        self.smoothnessScale = self.materialTemplate.smoothnessScale or self.materialTemplate.parentTemplate.smoothnessScale or 1
        self.metalnessScale = self.materialTemplate.metalnessScale or self.materialTemplate.parentTemplate.metalnessScale or 1
        self.clearCoatSmoothness = self.materialTemplate.clearCoatSmoothness or self.materialTemplate.parentTemplate.clearCoatSmoothness or 0
        self.clearCoatIntensity = self.materialTemplate.clearCoatIntensity or self.materialTemplate.parentTemplate.clearCoatIntensity or 0
        self.porosity = self.materialTemplate.porosity or self.materialTemplate.parentTemplate.porosity or 0

        self.detailDiffuse = self.materialTemplate.detailDiffuse or self.materialTemplate.parentTemplate.detailDiffuse or "data/shared/detailLibrary/nonMetallic/default_diffuse.png"
        self.detailNormal = self.materialTemplate.detailNormal or self.materialTemplate.parentTemplate.detailNormal or "data/shared/detailLibrary/nonMetallic/default_normal.png"
        self.detailSpecular = self.materialTemplate.detailSpecular or self.materialTemplate.parentTemplate.detailSpecular or "data/shared/detailLibrary/nonMetallic/default_specular.png"
    else
            return false
        end

        return true
    end

```