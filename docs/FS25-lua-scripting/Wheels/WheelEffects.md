## WheelEffects

**Description**

> Handles wheel visual effects (tire tracks, particles, shallow water)

**Functions**

- [addWaterEffectsToPhysicsData](#addwatereffectstophysicsdata)
- [delete](#delete)
- [finalize](#finalize)
- [getDriveGroundParticleSystemsScale](#getdrivegroundparticlesystemsscale)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onUpdateEnd](#onupdateend)
- [onWheelParticleSystemI3DLoaded](#onwheelparticlesystemi3dloaded)
- [onWheelWaterEffectI3DLoaded](#onwheelwatereffecti3dloaded)
- [registerXMLPaths](#registerxmlpaths)
- [removeWaterEffects](#removewatereffects)
- [update](#update)
- [updateTick](#updatetick)

### addWaterEffectsToPhysicsData

**Description**

**Definition**

> addWaterEffectsToPhysicsData()

**Code**

```lua
function WheelEffects:addWaterEffectsToPhysicsData()
    self.hasWaterParticles = true

    local args = { }
    args.wheelNode = self.wheel.driveNode
    args.width = self.wheel.physics.width
    args.radius = self.wheel.physics.radius
    local sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( WheelEffects.WATER_EFFECTS, false , false , self.onWheelWaterEffectI3DLoaded, self , args)
    table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function WheelEffects:delete()
    for _, particleSystem in pairs( self.driveGroundParticleSystems) do
        ParticleUtil.deleteParticleSystem(particleSystem)
    end

    for _, sharedLoadRequestId in ipairs( self.sharedLoadRequestIds) do
        g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
    end
    self.sharedLoadRequestIds = { }

    self:removeWaterEffects()
end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function WheelEffects:finalize()
    for _, visualWheel in ipairs( self.wheel.visualWheels) do
        if self.hasParticles then
            for name, state in pairs( WheelEffects.PARTICLE_SYSTEM_STATES) do
                local sourceParticleSystem = g_particleSystemManager:getParticleSystem(name)
                if sourceParticleSystem ~ = nil then
                    local args = { }
                    args.name = name
                    args.state = state
                    args.wheelNode = visualWheel.node
                    args.width = visualWheel.width
                    args.radius = visualWheel.radius
                    args.sourceParticleSystem = sourceParticleSystem
                    args.sizeScale = 2 * visualWheel.width * visualWheel.radius

                    local sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( WheelEffects.PARTICLE_SYSTEM_PATH, false , false , self.onWheelParticleSystemI3DLoaded, self , args)
                    table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                end
            end
        end

        if self.hasWaterParticles ~ = false then
            local args = { }
            args.wheelNode = visualWheel.node
            args.width = visualWheel.width
            args.radius = visualWheel.radius

            local sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( WheelEffects.WATER_EFFECTS, false , false , self.onWheelWaterEffectI3DLoaded, self , args)
            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
        end

        if self.hasTireTracks and Platform.gameplay.wheelTireTracks then
            self.tireTrackNodeIndex = self.vehicle:addTireTrackNode( self.wheel, self.wheel.driveNodeDirectionNode, visualWheel.node, self.tireTrackAtlasIndex, visualWheel.width, visualWheel.radius, visualWheel:getIsTireInverted())
            self.wheel.syncContactState = true
        end

        if self.isShallowWaterObstacle then
            visualWheel:addShallowWaterObstacle()
        end
    end

    -- if we don't have any visual wheel, we attach the effects to the physical wheel(crawlers etc.)
        if # self.wheel.visualWheels = = 0 then
            if self.hasParticles then
                for name, state in pairs( WheelEffects.PARTICLE_SYSTEM_STATES) do
                    local sourceParticleSystem = g_particleSystemManager:getParticleSystem(name)
                    if sourceParticleSystem ~ = nil then
                        local args = { }
                        args.name = name
                        args.state = state
                        args.wheelNode = self.wheel.driveNode
                        args.width = self.wheel.physics.width
                        args.radius = self.wheel.physics.radius
                        args.sourceParticleSystem = sourceParticleSystem
                        args.sizeScale = 2 * self.wheel.physics.width * self.wheel.physics.radius

                        local sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( WheelEffects.PARTICLE_SYSTEM_PATH, false , false , self.onWheelParticleSystemI3DLoaded, self , args)
                        table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                    end
                end
            end

            if self.hasWaterParticles = = true then
                self:addWaterEffectsToPhysicsData()
            end

            if self.hasTireTracks and Platform.gameplay.wheelTireTracks then
                self.tireTrackNodeIndex = self.vehicle:addTireTrackNode( self.wheel, self.wheel.driveNodeDirectionNode, self.wheel.driveNode, self.tireTrackAtlasIndex, self.wheel.physics.width, self.wheel.physics.radius, false )
                self.wheel.syncContactState = true
            end
        end
    end

```

### getDriveGroundParticleSystemsScale

**Description**

**Definition**

> getDriveGroundParticleSystemsScale()

**Arguments**

| any | particleSystem |
|-----|----------------|
| any | speed          |

**Code**

```lua
function WheelEffects:getDriveGroundParticleSystemsScale(particleSystem, speed)
    local wheel = self.wheel

    if not wheel.physics.hasSnowContact then
        if self.onlyActiveOnGroundContact and wheel.physics.contact ~ = WheelContactType.GROUND then
            return 0
        end

        if not WheelEffects.GROUND_PARTICLES[wheel.physics.lastTerrainAttribute] then
            return 0
        end

        if wheel.physics.densityType = = FieldGroundType.GRASS then
            return 0
        end
    end

    local minSpeed = self.minSpeed
    local direction = self.direction
    if speed > minSpeed and(direction = = 0 or(direction > 0 ) = = ( self.vehicle.movingDirection > 0 )) then
        local maxSpeed = self.maxSpeed
        local alpha = math.min((speed - minSpeed) / (maxSpeed - minSpeed), 1 )
        local scale = MathUtil.lerp( self.minScale, self.maxScale, alpha)
        return scale
    end

    return 0
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlObject |
|-----|-----------|

**Code**

```lua
function WheelEffects:loadFromXML(xmlObject)
    self.hasTireTracks = xmlObject:getValue( "#hasTireTracks" , false )
    self.hasParticles = xmlObject:getValue( "#hasParticles" , false )
    self.hasWaterParticles = xmlObject:getValue( "#hasWaterParticles" )
    self.waterParticleDirection = xmlObject:getValue( "#waterParticleDirection" , 0 )
    self.isShallowWaterObstacle = xmlObject:getValue( "#isShallowWaterObstacle" , true )

    self.tireTrackAtlasIndex = xmlObject:getValue( ".tire#tireTrackAtlasIndex" , 0 )

    self.offset = xmlObject:getValue( ".wheelParticleSystem#psOffset" , "0 0 0" , true )
    self.minSpeed = xmlObject:getValue( ".wheelParticleSystem#minSpeed" , 3 ) / 3600
    self.maxSpeed = xmlObject:getValue( ".wheelParticleSystem#maxSpeed" , 20 ) / 3600
    self.minScale = xmlObject:getValue( ".wheelParticleSystem#minScale" , 0.1 )
    self.maxScale = xmlObject:getValue( ".wheelParticleSystem#maxScale" , 1 )
    self.direction = xmlObject:getValue( ".wheelParticleSystem#direction" , 0 )
    self.onlyActiveOnGroundContact = xmlObject:getValue( ".wheelParticleSystem#onlyActiveOnGroundContact" , true )

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | wheel |
|-----|-------|

**Code**

```lua
function WheelEffects.new(wheel)
    local self = setmetatable( { } , { __index = WheelEffects } )

    self.wheel = wheel
    self.vehicle = wheel.vehicle

    self.sharedLoadRequestIds = { }
    self.driveGroundParticleSystems = { }

    self.waterEffects = { }
    self.waterEffectsLoaded = false
    self.waterEffectsActive = false
    self.waterEffectScale = 0
    self.waterEffectReferenceRadius = nil
    self.speedSmooth = 0
    self.wheelSpeedSmooth = 0

    return self
end

```

### onUpdateEnd

**Description**

**Definition**

> onUpdateEnd()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function WheelEffects:onUpdateEnd(dt)
    for _, particleSystem in ipairs( self.driveGroundParticleSystems) do
        ParticleUtil.setEmittingState(particleSystem, false )
    end
end

```

### onWheelParticleSystemI3DLoaded

**Description**

> Called when wheel particle i3d was loaded

**Definition**

> onWheelParticleSystemI3DLoaded(integer i3dNode, table args, )

**Arguments**

| integer | i3dNode | i3dNode of wheel chock |
|---------|---------|------------------------|
| table   | args    | arguments              |
| any     | args    |                        |

**Code**

```lua
function WheelEffects:onWheelParticleSystemI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local emitterShape = getChildAt(i3dNode, 0 )
        link( self.wheel.repr, emitterShape)
        delete(i3dNode)

        local particleSystem = ParticleUtil.copyParticleSystem( nil , nil , args.sourceParticleSystem, emitterShape)
        particleSystem.state = args.state
        particleSystem.i3dFilename = args.i3dFilename
        particleSystem.particleSpeed = ParticleUtil.getParticleSystemSpeed(particleSystem)
        particleSystem.particleRandomSpeed = ParticleUtil.getParticleSystemSpeedRandom(particleSystem)
        particleSystem.sizeScale = args.sizeScale
        particleSystem.alpha = 0

        particleSystem.isTintable = Utils.getNoNil(getUserAttribute(particleSystem.shape, "tintable" ), true )

        local wx, wy, wz = worldToLocal( self.wheel.repr, getWorldTranslation(args.wheelNode))
        setTranslation(particleSystem.emitterShape, wx + self.offset[ 1 ], wy + self.offset[ 2 ], wz + self.offset[ 3 ])
        setRotation(particleSystem.emitterShape, localRotationToLocal(args.wheelNode, getParent(particleSystem.emitterShape), 0 , 0 , 0 ))
        setScale(particleSystem.emitterShape, args.width, args.radius * 2 , args.radius * 2 )

        table.insert( self.driveGroundParticleSystems, particleSystem)
    end
end

```

### onWheelWaterEffectI3DLoaded

**Description**

**Definition**

> onWheelWaterEffectI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | wheelData    |

**Code**

```lua
function WheelEffects:onWheelWaterEffectI3DLoaded(i3dNode, failedReason, wheelData)
    if i3dNode ~ = 0 and self.hasWaterParticles ~ = false then
        local waterFront = getChildAt(i3dNode, 0 )
        local waterFrontFoam = getChildAt(i3dNode, 1 )
        local waterBack = getChildAt(i3dNode, 2 )
        local waterBackFoam = getChildAt(i3dNode, 3 )

        local waterEffectNode = createTransformGroup( "waterEffectNode" )
        link( self.wheel.node, waterEffectNode)
        setWorldTranslation(waterEffectNode, getWorldTranslation(wheelData.wheelNode))
        setWorldRotation(waterEffectNode, getWorldRotation(wheelData.wheelNode))

        local waterEffect = { }
        waterEffect.wheelData = wheelData
        waterEffect.waterEffectNode = waterEffectNode

        waterEffect.waterFront = waterFront
        waterEffect.waterFrontFoam = waterFrontFoam
        waterEffect.waterBack = waterBack
        waterEffect.waterBackFoam = waterBackFoam

        link(waterEffectNode, waterFront)
        link(waterEffectNode, waterFrontFoam)
        link(waterEffectNode, waterBack)
        link(waterEffectNode, waterBackFoam)

        setTranslation(waterFront, 0 , 0 , wheelData.radius * 0.65 )
        setTranslation(waterFrontFoam, 0 , 0 , wheelData.radius * 0.65 )
        setTranslation(waterBack, 0 , 0 , - wheelData.radius * 0.35 )
        setTranslation(waterBackFoam, 0 , 0 , - wheelData.radius * 0.35 )

        local baseDensity = math.min(wheelData.radius * wheelData.width, 1 )
        setShaderParameter(waterFront, "fadeProgress" , nil , nil , baseDensity, 0 , false )
        setShaderParameter(waterFrontFoam, "fadeProgress" , nil , nil , baseDensity, 0 , false )
        setShaderParameter(waterBack, "fadeProgress" , nil , nil , baseDensity, 0 , false )
        setShaderParameter(waterBackFoam, "fadeProgress" , nil , nil , baseDensity, 0 , false )

        setVisibility(waterEffectNode, false )
        self.waterEffectsActive = false

        table.insert( self.waterEffects, waterEffect)
        self.waterEffectsLoaded = true

        delete(i3dNode)
    end
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function WheelEffects.registerXMLPaths(schema, key)
    schema:register(XMLValueType.BOOL, key .. "#hasTireTracks" , "Has tire tracks" , false )
    schema:register(XMLValueType.BOOL, key .. "#hasParticles" , "Has particles" , false )
    schema:register(XMLValueType.BOOL, key .. "#hasWaterParticles" , "Has water particles" , "true if visual wheel is defined" )
        schema:register(XMLValueType.INT, key .. "#waterParticleDirection" , "The direction in which the water particles should only be active(0:both, 1:only the front, -1:only the back)" , 0 )
        schema:register(XMLValueType.BOOL, key .. "#isShallowWaterObstacle" , "The visual wheels will interact with the shallow water simulation" , true )

        schema:register(XMLValueType.FLOAT, key .. ".tire#tireTrackAtlasIndex" , "Tire track atlas index" , 0 )

        schema:register(XMLValueType.VECTOR_TRANS, key .. ".wheelParticleSystem#psOffset" , "Translation offset" , "0 0 0" )
        schema:register(XMLValueType.FLOAT, key .. ".wheelParticleSystem#minSpeed" , "Min.speed for activation" , 3 )
            schema:register(XMLValueType.FLOAT, key .. ".wheelParticleSystem#maxSpeed" , "Max.speed for activation" , 20 )
                schema:register(XMLValueType.FLOAT, key .. ".wheelParticleSystem#minScale" , "Min.scale" , 0.1 )
                schema:register(XMLValueType.FLOAT, key .. ".wheelParticleSystem#maxScale" , "Max.scale" , 1 )
                schema:register(XMLValueType.INT, key .. ".wheelParticleSystem#direction" , "Moving direction for activation" , 0 )
                    schema:register(XMLValueType.BOOL, key .. ".wheelParticleSystem#onlyActiveOnGroundContact" , "Only active while wheel has ground contact" , true )
                    end

```

### removeWaterEffects

**Description**

**Definition**

> removeWaterEffects()

**Code**

```lua
function WheelEffects:removeWaterEffects()
    for _, waterEffect in ipairs( self.waterEffects) do
        delete(waterEffect.waterEffectNode)
    end

    self.waterEffects = { }
    self.waterEffectsLoaded = false
    self.hasWaterParticles = false
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt                 |
|-----|--------------------|
| any | groundWetness      |
| any | currentUpdateIndex |

**Code**

```lua
function WheelEffects:update(dt, groundWetness, currentUpdateIndex)
    if not self.waterEffectsLoaded then
        return
    end

    local physics = self.wheel.physics

    if VehicleDebug.wheelEffectDebugState then
        physics.hasWaterContact = true
        physics.netInfo.lastSpeedSmoothed = 20 / 3600
        self.waterEffectScale = 1
        self.vehicle.lastSpeedSmoothed = 20 / 3600
    end

    if physics.hasWaterContact then
        self.waterEffectScale = math.min( self.waterEffectScale + dt * WheelEffects.WATER_EFFECT_FADE_IN_TIME, 1 )
    else
            self.waterEffectScale = math.max( self.waterEffectScale - dt * WheelEffects.WATER_EFFECT_FADE_OUT_TIME, 0 )
        end

        local isActive = self.waterEffectScale > 0 and physics.lastContactX ~ = nil
        if isActive then
            local contactX, contactY, contactZ = physics.lastContactX, physics.lastContactY, physics.lastContactZ

            -- exclude the shop
            if contactY > 0 then
                local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, contactX, 0 , contactZ)
                contactY = math.max(contactY, terrainHeight)
            end

            local direction = 1
            if physics.netInfo.lastSpeedSmoothed < - 0.000277 then
                direction = - 1
            end

            local speed = self.vehicle.lastSpeedSmoothed * 3600
            local wheelSpeed = math.abs(physics.netInfo.lastSpeedSmoothed) * 3600

            local slipScale = 1 + physics.netInfo.slip

            local densityFront = math.max( math.min((speed - 1 ) / 11 , 1 ), 0 ) * self.waterEffectScale
            local densityFrontFoam = math.max( math.min((speed - 11 ) / 21 * math.min(slipScale, 2 ), 1 ), 0 ) * self.waterEffectScale
            local densityBack = math.max( math.min((wheelSpeed - 1 ) / 11 , 1 ), 0 ) * self.waterEffectScale
            local densityBackFoam = math.max( math.min((wheelSpeed - 11 ) / 21 * math.min(slipScale, 2 ), 1 ), 0 ) * self.waterEffectScale

            if self.waterParticleDirection ~ = 0 then
                if ( self.waterParticleDirection > 0 ) = = (direction > 0 ) then
                    densityBack = 0
                    densityBackFoam = 0
                else
                        densityFront = 0
                        densityFrontFoam = 0
                    end
                end

                for _, waterEffect in ipairs( self.waterEffects) do
                    if not self.waterEffectsActive then
                        setVisibility(waterEffect.waterEffectNode, true )
                    end

                    local offsetX, _, offsetZ = localToLocal(waterEffect.wheelData.wheelNode, self.wheel.node, 0 , 0 , 0 )
                    local _, offsetY, _ = worldToLocal( self.wheel.node, contactX, contactY, contactZ)
                    setTranslation(waterEffect.waterEffectNode, offsetX, offsetY, offsetZ)

                    local nx, _, nz = getWorldTranslation(waterEffect.waterEffectNode)

                    local tx, tz
                    if physics.useReprDirection or physics.useDriveNodeDirection or physics.rotSpeed ~ = 0 then
                        local offsetX, offsetY, offsetZ = localToLocal(waterEffect.waterEffectNode, self.wheel.driveNodeDirectionNode, 0 , 0 , 0 )
                        tx, _, tz = localToWorld( self.wheel.driveNodeDirectionNode, offsetX, offsetY, offsetZ - direction * 0.25 )
                    else
                            local offsetX, offsetY, offsetZ = localToLocal(waterEffect.waterEffectNode, self.wheel.node, 0 , 0 , 0 )
                            tx, _, tz = localToWorld( self.wheel.node, offsetX, offsetY, offsetZ - direction * 0.25 )
                        end

                        if waterEffect.worldTargetPosition = = nil then
                            waterEffect.worldTargetPosition = { tx, tz }
                        end

                        waterEffect.worldTargetPosition[ 1 ] = waterEffect.worldTargetPosition[ 1 ] * 0.8 + tx * 0.2
                        waterEffect.worldTargetPosition[ 2 ] = waterEffect.worldTargetPosition[ 2 ] * 0.8 + tz * 0.2

                        local dx, dz = nx - waterEffect.worldTargetPosition[ 1 ], nz - waterEffect.worldTargetPosition[ 2 ]

                        local length = MathUtil.vector3Length(dx, 0 , dz)
                        if length > 0 then
                            dx, dz = dx / length, dz / length

                            local dy
                            dx, dy, dz = worldDirectionToLocal(getParent(waterEffect.waterEffectNode), dx, 0 , dz)
                            local upX, upY, upZ = worldDirectionToLocal(getParent(waterEffect.waterEffectNode), 0 , 1 , 0 )
                            setDirection(waterEffect.waterEffectNode, dx, dy, dz, upX, upY, upZ)
                        end

                        if VehicleDebug.wheelEffectDebugState then
                            local _, ny, _ = getWorldTranslation(waterEffect.waterEffectNode)
                            drawDebugLine(nx, ny + 2 , nz, 1 , 0 , 0 , waterEffect.worldTargetPosition[ 1 ], ny + 2 , waterEffect.worldTargetPosition[ 2 ], 1 , 0 , 0 , true )
                        end

                        local radius = self.waterEffectReferenceRadius or waterEffect.wheelData.radius
                        local scaleFront = radius * math.max( math.min(speed / 25 , 1 ), 0.25 )
                        local scaleBack = radius * math.max( math.min((wheelSpeed * math.min(slipScale, 3 )) / 25 , 1 ), 0.25 )

                        local scaleX = waterEffect.wheelData.width * 1.2

                        setScale(waterEffect.waterFront, scaleX, scaleFront, scaleFront)
                        setScale(waterEffect.waterFrontFoam, scaleX, scaleFront, scaleFront)
                        setScale(waterEffect.waterBack, scaleX, scaleBack, scaleBack)
                        setScale(waterEffect.waterBackFoam, scaleX, scaleBack, scaleBack)

                        setShaderParameter(waterEffect.waterFront, "density" , densityFront, nil , nil , nil , false )
                        setShaderParameter(waterEffect.waterFrontFoam, "density" , densityFrontFoam, nil , nil , nil , false )
                        setShaderParameter(waterEffect.waterBack, "density" , densityBack, nil , nil , nil , false )
                        setShaderParameter(waterEffect.waterBackFoam, "density" , densityBackFoam, nil , nil , nil , false )
                    end
                else
                        if self.waterEffectsActive then
                            for _, waterEffect in ipairs( self.waterEffects) do
                                setVisibility(waterEffect.waterEffectNode, false )
                            end
                        end
                    end

                    self.waterEffectsActive = isActive
                end

```

### updateTick

**Description**

**Definition**

> updateTick()

**Arguments**

| any | dt                    |
|-----|-----------------------|
| any | groundWetness         |
| any | currentUpdateDistance |

**Code**

```lua
function WheelEffects:updateTick(dt, groundWetness, currentUpdateDistance)
    if currentUpdateDistance > WheelEffects.MAX_UPDATE_DISTANCE then
        return
    end

    local physics = self.wheel.physics
    local groundColor = physics.groundColor

    -- update particle systems
    local enableSoilPS, hasSnowContact = physics.hasSoilContact, physics.hasSnowContact

    local state = 0
    if hasSnowContact then
        state = WheelEffects.PARTICLE_SYSTEM_STATES.WHEEL_SNOW
    elseif enableSoilPS then
            if groundWetness > 0.2 then
                state = WheelEffects.PARTICLE_SYSTEM_STATES.WHEEL_WET
            else
                    state = WheelEffects.PARTICLE_SYSTEM_STATES.WHEEL_DRY
                end
            elseif groundWetness < = 0.2 then
                    state = WheelEffects.PARTICLE_SYSTEM_STATES.WHEEL_DUST
                end

                local wheelSpeed = physics.netInfo.lastSpeedSmoothed
                local wheelSlip = 1 + physics.netInfo.slip

                for _, particleSystem in ipairs( self.driveGroundParticleSystems) do
                    if particleSystem.state = = state then
                        local scale = 0
                        if particleSystem.state ~ = WheelEffects.PARTICLE_SYSTEM_STATES.WHEEL_DUST then
                            scale = self:getDriveGroundParticleSystemsScale(particleSystem, wheelSpeed) * wheelSlip
                        else
                                scale = self:getDriveGroundParticleSystemsScale(particleSystem, self.vehicle.lastSpeedSmoothed)
                            end

                            if particleSystem.isTintable then
                                -- interpolate between different ground colors to avoid unrealisitic particle color changes
                                if particleSystem.lastColor = = nil then
                                    particleSystem.lastColor = { groundColor[ 1 ], groundColor[ 2 ], groundColor[ 3 ] }
                                    particleSystem.targetColor = { groundColor[ 1 ], groundColor[ 2 ], groundColor[ 3 ] }
                                    particleSystem.currentColor = { groundColor[ 1 ], groundColor[ 2 ], groundColor[ 3 ] }
                                    particleSystem.alpha = 1
                                end

                                if particleSystem.alpha ~ = 1 then
                                    particleSystem.alpha = math.min(particleSystem.alpha + dt * 0.001 , 1 )
                                    local r,g,b = MathUtil.vector3ArrayLerp(particleSystem.lastColor, particleSystem.targetColor, particleSystem.alpha)
                                    particleSystem.currentColor[ 1 ] = r
                                    particleSystem.currentColor[ 2 ] = g
                                    particleSystem.currentColor[ 3 ] = b
                                    if particleSystem.alpha = = 1 then
                                        particleSystem.lastColor[ 1 ] = particleSystem.currentColor[ 1 ]
                                        particleSystem.lastColor[ 2 ] = particleSystem.currentColor[ 2 ]
                                        particleSystem.lastColor[ 3 ] = particleSystem.currentColor[ 3 ]
                                    end
                                end

                                if particleSystem.alpha = = 1 and groundColor[ 1 ] ~ = particleSystem.targetColor[ 1 ] and groundColor[ 2 ] ~ = particleSystem.targetColor[ 2 ] and groundColor[ 3 ] ~ = particleSystem.targetColor[ 3 ] then
                                    particleSystem.alpha = 0
                                    particleSystem.targetColor[ 1 ] = groundColor[ 1 ]
                                    particleSystem.targetColor[ 2 ] = groundColor[ 2 ]
                                    particleSystem.targetColor[ 3 ] = groundColor[ 3 ]
                                end
                            end

                            if scale > 0 then
                                ParticleUtil.setEmittingState(particleSystem, true )
                                if particleSystem.isTintable then
                                    I3DUtil.setShaderParameterRec(particleSystem.shape, "colorAlpha" , particleSystem.currentColor[ 1 ], particleSystem.currentColor[ 2 ], particleSystem.currentColor[ 3 ], 1 )
                                end
                            else
                                    ParticleUtil.setEmittingState(particleSystem, false )
                                end

                                -- emit count
                                local maxSpeed = ( 50 / 3.6 )
                                local circum = physics.radiusOriginal
                                local maxWheelRpm = maxSpeed / circum
                                local wheelRotFactor = (physics.netInfo.xDriveSpeed or 0 ) / maxWheelRpm
                                local emitScale = scale * wheelRotFactor * particleSystem.sizeScale
                                ParticleUtil.setEmitCountScale(particleSystem, math.clamp(emitScale, self.minScale, self.maxScale))

                                -- speed
                                ParticleUtil.setParticleSystemSpeed(particleSystem, particleSystem.particleSpeed)
                                ParticleUtil.setParticleSystemSpeedRandom(particleSystem, particleSystem.particleRandomSpeed)
                            else
                                    ParticleUtil.setEmittingState(particleSystem, false )
                                end
                            end
                        end

```