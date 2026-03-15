## BaseMaterial

**Description**

> Specialization for loading materials from a vehicle config xml and applying them to given nodes

**Functions**

- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function BaseMaterial.initSpecialization()
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
function BaseMaterial:onLoad(savegame)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baseMaterial" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baseMaterialConfigurations" , "vehicle.designColorConfigurations" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.designMaterialConfigurations" , "vehicle.designColorConfigurations" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.designMaterial2Configurations" , "vehicle.designColorConfigurations" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.designMaterial3Configurations" , "vehicle.designColorConfigurations" ) --FS22 to FS25
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
function BaseMaterial.prerequisitesPresent(specializations)
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
function BaseMaterial.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , BaseMaterial )
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
function BaseMaterial.registerFunctions(vehicleType)
end

```