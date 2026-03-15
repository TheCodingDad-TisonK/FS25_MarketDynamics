## MaterialUtil

**Description**

> Util for materials

**Functions**

- [getMaterialBySlotName](#getmaterialbyslotname)
- [onCreateBaseMaterial](#oncreatebasematerial)
- [onCreateMaterial](#oncreatematerial)
- [onCreateParticleMaterial](#oncreateparticlematerial)
- [onCreateParticleSystem](#oncreateparticlesystem)
- [validateMaterialAttributes](#validatematerialattributes)

### getMaterialBySlotName

**Description**

**Definition**

> getMaterialBySlotName()

**Arguments**

| any | node         |
|-----|--------------|
| any | materialName |

**Code**

```lua
function MaterialUtil.getMaterialBySlotName(node, materialName)
    if getHasClassId(node, ClassIds.SHAPE) then
        local numMaterials = getNumOfMaterials(node)
        for i = 1 , numMaterials do
            if getMaterialSlotName(node, i - 1 ) = = materialName then
                return getMaterial(node, i - 1 )
            end
        end
    end

    local numChildren = getNumOfChildren(node)
    for i = 1 , numChildren do
        local child = getChildAt(node, i - 1 )
        local materialId = MaterialUtil.getMaterialBySlotName(child, materialName)
        if materialId ~ = nil then
            return materialId
        end
    end

    return nil
end

```

### onCreateBaseMaterial

**Description**

> Called by material holder to create material

**Definition**

> onCreateBaseMaterial(any unused, integer id)

**Arguments**

| any     | unused | unused |
|---------|--------|--------|
| integer | id     | id     |

**Code**

```lua
function MaterialUtil.onCreateBaseMaterial(_, id)
    local materialNameStr = getUserAttribute(id, "materialName" )
    if materialNameStr = = nil then
        Logging.i3dWarning(id, "Missing 'materialName' user attribute for MaterialUtil.onCreateBaseMaterial" )
            return
        end

        g_materialManager:addBaseMaterial(materialNameStr, getMaterial(id, 0 ))
    end

```

### onCreateMaterial

**Description**

> Called by material holder to create material

**Definition**

> onCreateMaterial(any unused, integer id)

**Arguments**

| any     | unused | unused |
|---------|--------|--------|
| integer | id     | id     |

**Code**

```lua
function MaterialUtil.onCreateMaterial(_, id)
    local isValid, fillTypeIndex, materialType, materialIndex = MaterialUtil.validateMaterialAttributes(id, "MaterialUtil.onCreateMaterial" )
    if isValid then
        g_materialManager:addMaterial(fillTypeIndex, materialType, materialIndex, getMaterial(id, 0 ))
    end
end

```

### onCreateParticleMaterial

**Description**

> Called by material holder to create particle material

**Definition**

> onCreateParticleMaterial(any unused, integer id)

**Arguments**

| any     | unused | unused |
|---------|--------|--------|
| integer | id     | id     |

**Code**

```lua
function MaterialUtil.onCreateParticleMaterial(_, id)
    local isValid, fillTypeIndex, materialType, materialIndex = MaterialUtil.validateMaterialAttributes(id, "MaterialUtil.onCreateParticleMaterial" )
    if isValid then
        g_materialManager:addParticleMaterial(fillTypeIndex, materialType, materialIndex, getMaterial(id, 0 ))
    end
end

```

### onCreateParticleSystem

**Description**

> Called by particle holder to create particle system

**Definition**

> onCreateParticleSystem(any unused, integer id)

**Arguments**

| any     | unused | unused |
|---------|--------|--------|
| integer | id     | id     |

**Code**

```lua
function MaterialUtil.onCreateParticleSystem(_, id)
    local particleTypeName = getUserAttribute(id, "particleType" )
    if particleTypeName = = nil then
        Logging.i3dWarning(id, "Missing 'particleType' user attribute for MaterialUtil.onCreateParticleSystem" )
            return
        end

        local particleType = g_particleSystemManager:getParticleSystemTypeByName(particleTypeName)
        if particleType = = nil then
            Logging.i3dWarning(id, "Unknown particleType '%s' given in 'particleType' user attribute for MaterialUtil.onCreateParticleSystem" , particleTypeName)
                print( string.format( "Available types: %s" , table.concat(g_particleSystemManager.particleTypes, " " )))
                return
            end

            local defaultEmittingState = Utils.getNoNil(getUserAttribute(id, "defaultEmittingState" ), false )
            local worldSpace = Utils.getNoNil(getUserAttribute(id, "worldSpace" ), true )
            local forceFullLifespan = Utils.getNoNil(getUserAttribute(id, "forceFullLifespan" ), false )

            local particleSystem = { }

            ParticleUtil.loadParticleSystemFromNode(id, particleSystem, defaultEmittingState, worldSpace, forceFullLifespan)

            g_particleSystemManager:addParticleSystem(particleType, particleSystem)
        end

```

### validateMaterialAttributes

**Description**

> Called by material holder to create material

**Definition**

> validateMaterialAttributes(entityId node, string sourceFuncName)

**Arguments**

| entityId | node           | id               |
|----------|----------------|------------------|
| string   | sourceFuncName | used for logging |

**Return Values**

| string | success       |
|--------|---------------|
| string | fillTypeIndex |
| string | materialType  |
| string | materialIndex |

**Code**

```lua
function MaterialUtil.validateMaterialAttributes(node, sourceFuncName)
    local fillTypeStr = getUserAttribute(node, "fillType" )
    if fillTypeStr = = nil then
        Logging.i3dWarning(node, "Missing 'fillType' user attribute for %q" , sourceFuncName)
            return false
        end

        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeStr)
        if fillTypeIndex = = nil then
            Logging.i3dWarning(node, "Unknown fillType %q in user attribute 'fillType' for %q" , fillTypeStr, sourceFuncName)
                return false
            end

            local materialTypeName = getUserAttribute(node, "materialType" )
            if materialTypeName = = nil then
                Logging.i3dWarning(node, "Missing 'materialType' user attribute for %q" , sourceFuncName)
                    return false
                end

                local materialType = g_materialManager:getMaterialTypeByName(materialTypeName)
                if materialType = = nil then
                    Logging.i3dWarning(node, "Unknown materialType %q for %q" , materialTypeName, sourceFuncName)
                        return false
                    end

                    local matIdStr = Utils.getNoNil(getUserAttribute(node, "materialIndex" ), 1 )
                    local materialIndex = tonumber(matIdStr)
                    if materialIndex = = nil then
                        Logging.i3dWarning(node, "Invalid materialIndex %q for %q" , matIdStr, sourceFuncName)
                            return false
                        end

                        return true , fillTypeIndex, materialType, materialIndex
                    end

```