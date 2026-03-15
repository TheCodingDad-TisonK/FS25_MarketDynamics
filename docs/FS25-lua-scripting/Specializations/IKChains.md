## IKChains

**Description**

> Specialization loading inverse kinematic (IK) chains

**Functions**

- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function IKChains.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "IKChains" )
    IKUtil.registerIKChainXMLPaths(schema, "vehicle.ikChains.ikChain(?)" )
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
function IKChains:onLoad(savegame)
    local spec = self.spec_ikChains

    spec.chains = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.ikChains.ikChain(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end
        IKUtil.loadIKChain( self.xmlFile, key, self.components, self.components, spec.chains)
        i = i + 1
    end

    if next(spec.chains) = = nil then
        SpecializationUtil.removeEventListener( self , "onUpdate" , IKChains )
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function IKChains:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    IKUtil.updateIKChains( self.spec_ikChains.chains)
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
function IKChains.prerequisitesPresent(specializations)
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
function IKChains.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , IKChains )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , IKChains )
end

```