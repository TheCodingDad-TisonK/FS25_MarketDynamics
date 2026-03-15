## ManureBarrel

**Description**

> Specialization for liquid manure barrel, connects function of barrel to attached manure spreader

**Functions**

- [getAreEffectsVisible](#getareeffectsvisible)
- [getIsWorkAreaActive](#getisworkareaactive)
- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onPostAttachImplement](#onpostattachimplement)
- [onPostDetachImplement](#onpostdetachimplement)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getAreEffectsVisible

**Description**

**Definition**

> getAreEffectsVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ManureBarrel:getAreEffectsVisible(superFunc)
    local spec = self.spec_manureBarrel

    if spec.attachedTool ~ = nil then
        return false
    end

    return superFunc( self )
end

```

### getIsWorkAreaActive

**Description**

**Definition**

> getIsWorkAreaActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |

**Code**

```lua
function ManureBarrel:getIsWorkAreaActive(superFunc, workArea)
    local spec = self.spec_manureBarrel

    if spec.attachedTool ~ = nil then
        return false
    end

    return superFunc( self , workArea)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ManureBarrel.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ManureBarrel" )

    schema:register(XMLValueType.INT, "vehicle.manureBarrel#attacherJointIndex" , "Attacher joint index" )

    schema:setXMLSpecializationType()
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
function ManureBarrel:onLoad(savegame)
    local spec = self.spec_manureBarrel

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.manureBarrel#toolAttachAnimName" , "vehicle.attacherJoints.attacherJoint.objectChange" ) --FS17 to FS19

    spec.attachToolJointIndex = self.xmlFile:getValue( "vehicle.manureBarrel#attacherJointIndex" )
end

```

### onPostAttachImplement

**Description**

**Definition**

> onPostAttachImplement()

**Arguments**

| any | attachable          |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |
| any | loadFromSavegame    |

**Code**

```lua
function ManureBarrel:onPostAttachImplement(attachable, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_manureBarrel
    if jointDescIndex = = spec.attachToolJointIndex then
        spec.attachedTool = attachable
    end
end

```

### onPostDetachImplement

**Description**

**Definition**

> onPostDetachImplement()

**Arguments**

| any | implementIndex |
|-----|----------------|

**Code**

```lua
function ManureBarrel:onPostDetachImplement(implementIndex)
    local spec = self.spec_manureBarrel

    local object
    if self.getObjectFromImplementIndex ~ = nil then
        object = self:getObjectFromImplementIndex(implementIndex)
    end

    if object ~ = nil then
        local attachedImplements = self:getAttachedImplements()
        if attachedImplements[implementIndex].jointDescIndex = = spec.attachToolJointIndex then
            spec.attachedTool = nil
        end
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
function ManureBarrel.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Sprayer , specializations) and SpecializationUtil.hasSpecialization( AttacherJoints , specializations)
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
function ManureBarrel.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ManureBarrel )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttachImplement" , ManureBarrel )
    SpecializationUtil.registerEventListener(vehicleType, "onPostDetachImplement" , ManureBarrel )
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
function ManureBarrel.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreEffectsVisible" , ManureBarrel.getAreEffectsVisible)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , ManureBarrel.getIsWorkAreaActive)
end

```