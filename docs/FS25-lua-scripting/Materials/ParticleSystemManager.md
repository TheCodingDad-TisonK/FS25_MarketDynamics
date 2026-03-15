## ParticleSystemManager

**Description**

> This class handles all particles

**Parent**

> [AbstractManager](?version=script&category=57&class=552)

**Functions**

- [addParticleSystem](#addparticlesystem)
- [addParticleType](#addparticletype)
- [getParticleSystem](#getparticlesystem)
- [getParticleSystemTypeByName](#getparticlesystemtypebyname)
- [initDataStructures](#initdatastructures)
- [loadMapData](#loadmapdata)
- [new](#new)
- [unloadMapData](#unloadmapdata)

### addParticleSystem

**Description**

> Adds a new material type

**Definition**

> addParticleSystem(string particleType, integer materialIndex, integer materialId)

**Arguments**

| string  | particleType  | particleType         |
|---------|---------------|----------------------|
| integer | materialIndex | material index       |
| integer | materialId    | internal material id |

**Code**

```lua
function ParticleSystemManager:addParticleSystem(particleType, particleSystem)
    if self.particleSystems[particleType] ~ = nil then
        ParticleUtil.deleteParticleSystem( self.particleSystems[particleType])
    end

    self.particleSystems[particleType] = particleSystem
end

```

### addParticleType

**Description**

> Adds a new particle type

**Definition**

> addParticleType(string name)

**Arguments**

| string | name | name |
|--------|------|------|

**Code**

```lua
function ParticleSystemManager:addParticleType(name)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a particleType.Ignoring it!" )
            return nil
        end

        name = string.upper(name)

        if self.nameToIndex[name] = = nil then
            table.insert( self.particleTypes, name)
            self.nameToIndex[name] = # self.particleTypes
        end

        return nil
    end

```

### getParticleSystem

**Description**

> Returns particle system for given properties

**Definition**

> getParticleSystem(integer fillType, string particleTypeName)

**Arguments**

| integer | fillType         | fill type             |
|---------|------------------|-----------------------|
| string  | particleTypeName | name of particle type |

**Return Values**

| string | particleSystem |
|--------|----------------|

**Code**

```lua
function ParticleSystemManager:getParticleSystem(particleTypeName)
    local particleType = self:getParticleSystemTypeByName(particleTypeName)
    if particleType = = nil then
        return nil
    end

    return self.particleSystems[particleType]
end

```

### getParticleSystemTypeByName

**Description**

> Returns a particleType by name

**Definition**

> getParticleSystemTypeByName(string name)

**Arguments**

| string | name | name of particle type |
|--------|------|-----------------------|

**Return Values**

| string | particleType | the real particle name, nil if not defined |
|--------|--------------|--------------------------------------------|

**Code**

```lua
function ParticleSystemManager:getParticleSystemTypeByName(name)
    if name ~ = nil then
        name = string.upper(name)

        -- atm we just return the uppercase name because a particle type is only defined as a base string
        if self.nameToIndex[name] ~ = nil then
            return name
        end
    end

    return nil
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function ParticleSystemManager:initDataStructures()
    self.nameToIndex = { }
    self.particleTypes = { }
    self.particleSystems = { }
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function ParticleSystemManager:loadMapData()
    ParticleSystemManager:superClass().loadMapData( self )

    self:addParticleType( "unloading" )
    self:addParticleType( "smoke" )
    self:addParticleType( "smoke_damping" )
    self:addParticleType( "smoke_chimney" )
    self:addParticleType( "smoke_train_main" )
    self:addParticleType( "smoke_train_side" )
    self:addParticleType( "chopper" )
    self:addParticleType( "straw" )
    self:addParticleType( "cutter_chopper" )
    self:addParticleType( "soil" )
    self:addParticleType( "soil_smoke" )
    self:addParticleType( "soil_chunks" )
    self:addParticleType( "soil_big_chunks" )
    self:addParticleType( "soil_harvesting" )
    self:addParticleType( "spreader" )
    self:addParticleType( "spreader_smoke" )
    self:addParticleType( "windrower" )
    self:addParticleType( "tedder" )
    self:addParticleType( "weeder" )
    self:addParticleType( "crusher_wood" )
    self:addParticleType( "crusher_dust" )
    self:addParticleType( "prepare_fruit" )
    self:addParticleType( "cleaning_soil" )
    self:addParticleType( "cleaning_dust" )
    self:addParticleType( "washer_water" )
    self:addParticleType( "chainsaw_wood" )
    self:addParticleType( "chainsaw_dust" )
    self:addParticleType( "pickup" )
    self:addParticleType( "pickup_falling" )
    self:addParticleType( "sowing" )
    self:addParticleType( "loading" )
    self:addParticleType( "wheel_dust" )
    self:addParticleType( "wheel_dry" )
    self:addParticleType( "wheel_wet" )
    self:addParticleType( "wheel_snow" )
    self:addParticleType( "bees" )
    self:addParticleType( "horse_step_slow" )
    self:addParticleType( "horse_step_fast" )
    self:addParticleType( "spraycan_paint" )
    self:addParticleType( "HYDRAULIC_HAMMER" )
    self:addParticleType( "HYDRAULIC_HAMMER_DEBRIS" )
    self:addParticleType( "STONE" )

    ParticleType = self.nameToIndex

    return true
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
function ParticleSystemManager.new(customMt)
    local self = AbstractManager.new(customMt or ParticleSystemManager _mt)

    return self
end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function ParticleSystemManager:unloadMapData()
    for _, fillTypeParticleSystem in pairs( self.particleSystems) do
        ParticleUtil.deleteParticleSystem(fillTypeParticleSystem)
    end

    ParticleSystemManager:superClass().unloadMapData( self )
end

```