## Motorbike

**Description**

> Specialization for motor bike

**Functions**

- [initSpecialization](#initspecialization)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Motorbike.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Motorbike" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.motorbike.tilt#node" , "Tilt Node" )
    schema:register(XMLValueType.ANGLE, "vehicle.motorbike.tilt#maxTilt" , "Max.tilt in corners" , 0 )
    schema:register(XMLValueType.ANGLE, "vehicle.motorbike.tilt#idleTilt" , "Tilt while not driving" , 0 )
        schema:register(XMLValueType.ANGLE, "vehicle.motorbike.tilt#backwardTilt" , "Tilt while going backward" , 0 )
            schema:register(XMLValueType.ANGLE, "vehicle.motorbike.tilt#tiltSpeed" , "Tilt speed(deg/sec)" , 5 )

            schema:register(XMLValueType.STRING, "vehicle.motorbike.footAnimation#name" , "Name of the foot animation" )
            schema:register(XMLValueType.FLOAT, "vehicle.motorbike.footAnimation#speed" , "Play speed of the animation" , 1 )
            schema:register(XMLValueType.FLOAT, "vehicle.motorbike.footAnimation#speedThreshold" , "Speed threshold to play the animation" , 1 )

            schema:register(XMLValueType.STRING, "vehicle.motorbike.backwardAnimation#name" , "Name of the backward walk animation" )
            schema:register(XMLValueType.FLOAT, "vehicle.motorbike.backwardAnimation#speed" , "Speed of the animation" , 1 )

            schema:register(XMLValueType.FLOAT, "vehicle.motorbike.steering#highSpeedScale" , "Scale value for max.steering angle when above speed threshold" , 0.5 )
                schema:register(XMLValueType.FLOAT, "vehicle.motorbike.steering#highSpeedThreshold" , "Threshold at which the steering is reduced to the defined scale" , 20 )

                schema:setXMLSpecializationType()
            end

```

### onLeaveVehicle

**Description**

**Definition**

> onLeaveVehicle()

**Code**

```lua
function Motorbike:onLeaveVehicle()
    if self.isServer then
        local _, dirY, _ = localDirectionToWorld( self.rootNode, 0 , 1 , 0 )
        if dirY < 0.5 then
            local positionX, positionY, positionZ = getWorldTranslation( self.rootNode)

            local dirX, _, dirZ = localDirectionToWorld( self.rootNode, 0 , 0 , 1 )
            dirX, dirZ = MathUtil.vector2Normalize(dirX, dirZ)
            local yRot = MathUtil.getYRotationFromDirection(dirX, dirZ)

            self:removeFromPhysics()
            self:setAbsolutePosition(positionX, positionY, positionZ, 0 , yRot, 0 )
            self:addToPhysics()
        end
    end
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
function Motorbike:onLoad(savegame)
    local spec = self.spec_motorbike

    spec.tilt = { }
    spec.tilt.node = self.xmlFile:getValue( "vehicle.motorbike.tilt#node" , nil , self.components, self.i3dMappings)
    spec.tilt.maxTilt = self.xmlFile:getValue( "vehicle.motorbike.tilt#maxTilt" , 0 )
    spec.tilt.idleTilt = self.xmlFile:getValue( "vehicle.motorbike.tilt#idleTilt" , 0 )
    spec.tilt.backwardTilt = self.xmlFile:getValue( "vehicle.motorbike.tilt#backwardTilt" , 0 )
    spec.tilt.tiltSpeed = self.xmlFile:getValue( "vehicle.motorbike.tilt#tiltSpeed" , 5 ) * 0.001
    spec.tilt.currentValue = spec.tilt.idleTilt
    setRotation(spec.tilt.node, 0 , 0 , spec.tilt.currentValue)

    spec.footAnimation = { }
    spec.footAnimation.name = self.xmlFile:getValue( "vehicle.motorbike.footAnimation#name" )
    spec.footAnimation.speed = self.xmlFile:getValue( "vehicle.motorbike.footAnimation#speed" , 1 )
    spec.footAnimation.speedThreshold = self.xmlFile:getValue( "vehicle.motorbike.footAnimation#speedThreshold" , 1 )
    spec.footAnimation.state = false

    spec.backwardAnimation = { }
    spec.backwardAnimation.name = self.xmlFile:getValue( "vehicle.motorbike.backwardAnimation#name" )
    spec.backwardAnimation.speed = self.xmlFile:getValue( "vehicle.motorbike.backwardAnimation#speed" , 1 )
    spec.backwardAnimation.state = false
    spec.backwardAnimation.maxBackwardSpeed = self:getMotor():getMaximumBackwardSpeed()

    spec.steering = { }
    spec.steering.highSpeedScale = self.xmlFile:getValue( "vehicle.motorbike.steering#highSpeedScale" , 0.5 )
    spec.steering.highSpeedThreshold = self.xmlFile:getValue( "vehicle.motorbike.steering#highSpeedThreshold" , 20 )
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Motorbike:onPostLoad(savegame)
    local spec = self.spec_motorbike
    spec.steering.minRotTime = self.minRotTime
    spec.steering.maxRotTime = self.maxRotTime
    spec.steering.wheelSteeringDuration = self.wheelSteeringDuration
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function Motorbike:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_motorbike

    local lastSpeed = self:getLastSpeed()

    local targetTilt
    if self.movingDirection < 0 then
        targetTilt = spec.tilt.backwardTilt
    elseif lastSpeed < 0.5 then
            targetTilt = spec.tilt.idleTilt
        else
                targetTilt = - math.min(lastSpeed / 50 , 1 ) * self.rotatedTime * spec.tilt.maxTilt
            end

            local direction = math.sign(targetTilt - spec.tilt.currentValue)
            local limit = direction > 0 and math.min or math.max
            local currentValue = limit(spec.tilt.currentValue + direction * spec.tilt.tiltSpeed * dt, targetTilt)

            if currentValue ~ = spec.tilt.currentValue then
                spec.tilt.currentValue = currentValue
                setRotation(spec.tilt.node, 0 , 0 , spec.tilt.currentValue)
            end

            local footAnimationState = lastSpeed < spec.footAnimation.speedThreshold or self.movingDirection < 0
            if footAnimationState ~ = spec.footAnimation.state then
                spec.footAnimation.state = footAnimationState

                local animationTime = self:getAnimationTime(spec.footAnimation.name)
                if footAnimationState then
                    self:playAnimation(spec.footAnimation.name, - spec.footAnimation.speed, animationTime, true )
                else
                        self:playAnimation(spec.footAnimation.name, spec.footAnimation.speed, animationTime, true )
                    end
                end

                local backwardAnimationState = self.movingDirection < 0 and lastSpeed > 0.5
                if backwardAnimationState ~ = spec.backwardAnimation.state then
                    spec.backwardAnimation.state = backwardAnimationState

                    if backwardAnimationState then
                        self:playAnimation(spec.backwardAnimation.name, spec.backwardAnimation.speed, self:getAnimationTime(spec.backwardAnimation.name), true )
                    else
                            self:stopAnimation(spec.backwardAnimation.name)
                            self:setAnimationTime(spec.backwardAnimation.name, 0 , true )
                        end
                    end

                    if spec.backwardAnimation.state then
                        self:setAnimationSpeed(spec.backwardAnimation.name, spec.backwardAnimation.speed * (lastSpeed / spec.backwardAnimation.maxBackwardSpeed))
                    end

                    local steeringAngleScale = spec.steering.highSpeedScale + ( 1 - math.min(lastSpeed / spec.steering.highSpeedThreshold, 1 )) * ( 1 - spec.steering.highSpeedScale)
                    self.minRotTime = spec.steering.minRotTime * steeringAngleScale
                    self.maxRotTime = spec.steering.maxRotTime * steeringAngleScale
                    self.wheelSteeringDuration = spec.steering.wheelSteeringDuration * steeringAngleScale
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
function Motorbike.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AnimatedVehicle , specializations) and SpecializationUtil.hasSpecialization( Motorized , specializations)
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
function Motorbike.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Motorbike )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Motorbike )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Motorbike )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , Motorbike )
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
function Motorbike.registerFunctions(vehicleType)
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
function Motorbike.registerOverwrittenFunctions(vehicleType)
end

```