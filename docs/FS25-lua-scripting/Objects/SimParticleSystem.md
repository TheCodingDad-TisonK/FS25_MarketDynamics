## SimParticleSystem

**Description**

> This pre-simulates a particle system so it doesn't start at zero when the game begins

**Functions**

- [new](#new)
- [onCreate](#oncreate)

### new

**Description**

> Creating SimParticleSystem

**Definition**

> new(integer name)

**Arguments**

| integer | name | node id |
|---------|------|---------|

**Return Values**

| integer | instance | Instance of object |
|---------|----------|--------------------|

**Code**

```lua
function SimParticleSystem.new(name)
    local self = setmetatable( { } , SimParticleSystem _mt)
    self.id = name

    local particleSystem = nil

    if getHasClassId( self.id, ClassIds.SHAPE) then
        local geometry = getGeometry( self.id)
        if geometry ~ = 0 then
            if getHasClassId(geometry, ClassIds.PRECIPITATION) then
                particleSystem = geometry
            end
        end
    end

    if particleSystem ~ = nil then
        local lifespan = getParticleSystemLifespan(particleSystem)
        addParticleSystemSimulationTime(particleSystem, lifespan)
    end

    return self
end

```

### onCreate

**Description**

> Creating SimParticleSystem

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function SimParticleSystem:onCreate(id)
    g_currentMission:addNonUpdateable( SimParticleSystem.new(id))
end

```