## ArticulatedAxis

**Description**

> Specialization for vehicles which steer with an articulated axis (excavators, loaders ...)

**Functions**

- [getSteeringRotTimeByCurvature](#getsteeringrottimebycurvature)
- [getTurningRadiusByRotTime](#getturningradiusbyrottime)
- [initSpecialization](#initspecialization)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getSteeringRotTimeByCurvature

**Description**

**Definition**

> getSteeringRotTimeByCurvature()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | curvature |

**Code**

```lua
function ArticulatedAxis:getSteeringRotTimeByCurvature(superFunc, curvature)
    return self.wheelSteeringDuration * ( math.atan(curvature) / math.atan( 1 / self.maxTurningRadius))
end

```

### getTurningRadiusByRotTime

**Description**

**Definition**

> getTurningRadiusByRotTime()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | rotTime   |

**Code**

```lua
function ArticulatedAxis:getTurningRadiusByRotTime(superFunc, rotTime)
    local spec = self.spec_articulatedAxis
    if spec.componentJoint = = nil or spec.rotSpeed = = 0 then
        return superFunc( self , rotTime)
    end

    local rotSpeed = spec.rotSpeed
    local rotMax = self.maxRotation

    local curvature = - math.tan((rotTime / ( math.sign(rotSpeed) * rotMax / rotSpeed)) * math.atan( 1 / self.maxTurningRadius))

    if curvature = = 0 then
        return math.huge
    end

    return 1 / curvature
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ArticulatedAxis.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ArticulatedAxis" )

    schema:register(XMLValueType.INT, "vehicle.articulatedAxis#componentJointIndex" , "Index of component joint" )
    schema:register(XMLValueType.ANGLE, "vehicle.articulatedAxis#rotSpeed" , "Rotation speed" )
    schema:register(XMLValueType.ANGLE, "vehicle.articulatedAxis#rotMax" , "Max rotation" )
    schema:register(XMLValueType.ANGLE, "vehicle.articulatedAxis#rotMin" , "Min rotation" )
    schema:register(XMLValueType.INT, "vehicle.articulatedAxis#anchorActor" , "Anchor actor index" , 0 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.articulatedAxis#rotNode" , "Rotation node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.articulatedAxis#aiReverserNode" , "AI reverser node" )
    schema:register(XMLValueType.FLOAT, "vehicle.articulatedAxis#maxTurningRadius" , "Fixed turning radius to overwrite automatic calculations" )
    schema:register(XMLValueType.VECTOR_N, "vehicle.articulatedAxis#customWheelIndices1" , "Component 1 wheel indices.Needed if wheels are not linked to component 1 directly.E.g.dolly axis" )
        schema:register(XMLValueType.VECTOR_N, "vehicle.articulatedAxis#customWheelIndices2" , "Component 2 wheel indices.Needed if wheels are not linked to component 2 directly.E.g.dolly axis" )

            schema:register(XMLValueType.NODE_INDEX, "vehicle.articulatedAxis.rotatingPart(?)#node" , "Rotation part node" )
            schema:register(XMLValueType.VECTOR_ROT, "vehicle.articulatedAxis.rotatingPart(?)#posRot" , "Positive rotation" )
            schema:register(XMLValueType.VECTOR_ROT, "vehicle.articulatedAxis.rotatingPart(?)#negRot" , "Negative rotation" )
            schema:register(XMLValueType.FLOAT, "vehicle.articulatedAxis.rotatingPart(?)#posRotFactor" , "Positive rotation factor" , 1 )
            schema:register(XMLValueType.FLOAT, "vehicle.articulatedAxis.rotatingPart(?)#negRotFactor" , "Negative rotation factor" , 1 )
            schema:register(XMLValueType.BOOL, "vehicle.articulatedAxis.rotatingPart(?)#invertSteeringAngle" , "Invert steering angle" , false )

            SoundManager.registerSampleXMLPaths(schema, "vehicle.articulatedAxis.sounds" , "steering" )

            schema:setXMLSpecializationType()
        end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function ArticulatedAxis:onDeactivate()
    if self.isClient then
        local spec = self.spec_articulatedAxis
        g_soundManager:stopSamples(spec.samples)
        spec.isSteeringSoundPlaying = false
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function ArticulatedAxis:onDelete()
    if self.isClient then
        local spec = self.spec_articulatedAxis
        g_soundManager:deleteSamples(spec.samples)
    end
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function ArticulatedAxis:onLoad(savegame)
    local xmlFile = self.xmlFile
    local spec = self.spec_articulatedAxis

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.articulatedAxis.rotatingPart(0)#index" , "vehicle.articulatedAxis.rotatingPart(0)#node" ) -- FS17

    local index = xmlFile:getValue( "vehicle.articulatedAxis#componentJointIndex" )
    if index ~ = nil then
        if index = = 0 then
            Logging.xmlWarning( self.xmlFile, "Invalid component joint index '0' for articulatedAxis.Indices start with 1!" )
            else
                    local componentJoint = self.componentJoints[index]
                    local rotSpeed = xmlFile:getValue( "vehicle.articulatedAxis#rotSpeed" )
                    local rotMax = xmlFile:getValue( "vehicle.articulatedAxis#rotMax" )
                    local rotMin = xmlFile:getValue( "vehicle.articulatedAxis#rotMin" )
                    if componentJoint ~ = nil and rotSpeed ~ = nil and rotMax ~ = nil and rotMin ~ = nil then
                        spec.rotSpeed = rotSpeed
                        spec.rotMax = rotMax
                        spec.rotMin = rotMin

                        spec.componentJoint = componentJoint
                        spec.anchorActor = xmlFile:getValue( "vehicle.articulatedAxis#anchorActor" , 0 )
                        spec.rotationNode = xmlFile:getValue( "vehicle.articulatedAxis#rotNode" , nil , self.components, self.i3dMappings)
                        if spec.rotationNode = = nil then
                            spec.rotationNode = spec.componentJoint.jointNode
                        end

                        spec.curRot = 0

                        spec.rotatingParts = { }
                        for _index, key in xmlFile:iterator( "vehicle.articulatedAxis.rotatingPart" ) do
                            local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                            if node = = nil then
                                Logging.xmlWarning( self.xmlFile, "Failed to load rotation part '%s'" , key)
                                continue
                            end

                            local rotatingPart = { }
                            rotatingPart.node = node
                            rotatingPart.defRot = { getRotation(node) }
                            rotatingPart.posRot = xmlFile:getValue(key .. "#posRot" , nil , true )
                            if rotatingPart.posRot = = nil then
                                Logging.xmlError(xmlFile, "Missing values for '%s'" , key .. "#posRot" )
                                    continue
                                end
                                rotatingPart.negRot = xmlFile:getValue(key .. "#negRot" , nil , true )
                                if rotatingPart.negRot = = nil then
                                    Logging.xmlError(xmlFile, "Missing values for '%s'" , key .. "#negRot" )
                                        continue
                                    end
                                    rotatingPart.negRotFactor = xmlFile:getValue(key .. "#negRotFactor" , 1 )
                                    rotatingPart.posRotFactor = xmlFile:getValue(key .. "#posRotFactor" , 1 )
                                    rotatingPart.invertSteeringAngle = xmlFile:getValue(key .. "#invertSteeringAngle" , false )

                                    table.insert(spec.rotatingParts, rotatingPart)
                                end

                                local customWheelIndices = { { } , { } }
                                local customWheelIndices1Sorted = xmlFile:getValue( "vehicle.articulatedAxis#customWheelIndices1" , nil , true )
                                if customWheelIndices1Sorted ~ = nil then
                                    for _, wheelIndex in ipairs(customWheelIndices1Sorted) do
                                        customWheelIndices[ 1 ][wheelIndex] = true
                                    end
                                end
                                local customWheelIndices2Sorted = xmlFile:getValue( "vehicle.articulatedAxis#customWheelIndices2" , nil , true )
                                if customWheelIndices2Sorted ~ = nil then
                                    for _, wheelIndex in ipairs(customWheelIndices2Sorted) do
                                        customWheelIndices[ 2 ][wheelIndex] = true
                                    end
                                end

                                -- adjust steering values
                                local maxRotTime = rotMax / rotSpeed
                                local minRotTime = rotMin / rotSpeed
                                if minRotTime > maxRotTime then
                                    local temp = minRotTime
                                    minRotTime = maxRotTime
                                    maxRotTime = temp
                                end
                                if maxRotTime > self.maxRotTime then
                                    self.maxRotTime = maxRotTime
                                end
                                if minRotTime < self.minRotTime then
                                    self.minRotTime = minRotTime
                                end

                                self.maxRotation = rotMax
                                self.wheelSteeringDuration = math.sign(rotSpeed) * rotMax / rotSpeed

                                -- adjust variables used by AIVehicleUtil
                                spec.aiReverserNode = xmlFile:getValue( "vehicle.articulatedAxis#aiReverserNode" , nil , self.components, self.i3dMappings)

                                local maxTurningRadius = 0
                                local specWheels = self.spec_wheels
                                for j = 1 , 2 do
                                    local rootNode = self.components[componentJoint.componentIndices[j]].node

                                    local numFoundWheels = 0
                                    for wheelIndex, wheel in ipairs(specWheels.wheels) do
                                        if self:getParentComponent(wheel.repr) = = rootNode or customWheelIndices[j][wheelIndex] ~ = nil then
                                            numFoundWheels = numFoundWheels + 1

                                            local wx,_,wz = localToLocal(wheel.driveNode, rootNode, 0 , 0 , 0 )
                                            local dx1 = 1
                                            if wx < 0 then
                                                dx1 = - 1
                                            end
                                            local dz1 = math.tan( math.max(wheel.physics.rotMin, wheel.physics.rotMax) )
                                            if wz > 0 then
                                                dz1 = - dz1
                                            end

                                            local x2, z2 = 0 , 0
                                            local dx2 = 1
                                            if wx < 0 then
                                                dx2 = - 1
                                            end
                                            local dz2 = math.tan( math.max(rotMin, rotMax) )
                                            if wz < 0 then
                                                dz2 = - dz2
                                            end

                                            -- normalize directions
                                            local l1 = MathUtil.vector2Length(dx1, dz1)
                                            dx1, dz1 = dx1 / l1, dz1 / l1

                                            local l2 = MathUtil.vector2Length(dx2, dz2)
                                            dx2, dz2 = dx2 / l2, dz2 / l2

                                            local intersect, _, f2 = MathUtil.getLineLineIntersection2D(wx,wz, dx1,dz1, x2,z2, dx2,dz2)
                                            if intersect then
                                                local radius = math.abs(f2)
                                                maxTurningRadius = math.max(maxTurningRadius, radius)
                                            end
                                        end
                                    end

                                    if numFoundWheels < 2 then
                                        Logging.warning( "Could not find articulated axis wheels for component %d.Requires at least two wheels.Need to be added via 'customWheelIndices%d' attribute if not directly inside the component." , j, j)
                                        end
                                    end

                                    if maxTurningRadius ~ = 0 then
                                        self.maxTurningRadius = maxTurningRadius
                                    end

                                    self.maxTurningRadius = xmlFile:getValue( "vehicle.articulatedAxis#maxTurningRadius" , self.maxTurningRadius)
                                end
                            end
                        end

                        if self.isClient then
                            spec.samples = { }
                            spec.samples.steering = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.articulatedAxis.sounds" , "steering" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            spec.isSteeringSoundPlaying = false
                        end

                        spec.interpolatedRotatedTime = 0
                    end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Code**

```lua
function ArticulatedAxis:onPostLoad()
    local spec = self.spec_articulatedAxis
    if spec.componentJoint ~ = nil then
        if self.updateArticulatedAxisRotation ~ = nil then
            self:updateArticulatedAxisRotation( 0 , 99999 )
        end
    else
            SpecializationUtil.removeEventListener( self , "onUpdate" , ArticulatedAxis )
        end
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
function ArticulatedAxis:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_articulatedAxis
    -- interpolatedRotatedTime to manipulate camera rot
    if spec.interpolatedRotatedTime < self.rotatedTime then
        spec.interpolatedRotatedTime = math.min( self.rotatedTime, spec.interpolatedRotatedTime + math.abs(spec.rotSpeed) * dt / 500 )
    elseif spec.interpolatedRotatedTime > self.rotatedTime then
            spec.interpolatedRotatedTime = math.max( self.rotatedTime, spec.interpolatedRotatedTime - math.abs(spec.rotSpeed) * dt / 500 )
        end

        local steeringAngle = math.clamp( self.rotatedTime * spec.rotSpeed, spec.rotMin, spec.rotMax)
        if self.updateArticulatedAxisRotation ~ = nil then
            steeringAngle = self:updateArticulatedAxisRotation(steeringAngle, dt)
        end

        if self.isClient then
            local isSteering = math.abs(steeringAngle - spec.curRot) > 0.0001
            if isSteering ~ = spec.isSteeringSoundPlaying then
                if isSteering then
                    g_soundManager:playSample(spec.samples.steering)
                else
                        g_soundManager:stopSample(spec.samples.steering)
                    end

                    spec.isSteeringSoundPlaying = isSteering
                end
            end

            if math.abs(steeringAngle - spec.curRot) > 0.000001 then
                if self.isServer then
                    setRotation(spec.rotationNode, 0 , steeringAngle, 0 )
                    self:setComponentJointFrame(spec.componentJoint, spec.anchorActor)
                end
                spec.curRot = steeringAngle

                if self.isClient then
                    local percent = 0
                    if steeringAngle > 0 then
                        percent = steeringAngle / spec.rotMax
                    elseif steeringAngle < 0 then
                            percent = steeringAngle / spec.rotMin
                        end

                        for _,rotPart in pairs(spec.rotatingParts) do
                            local rx,ry,rz
                            if (steeringAngle > 0 and not rotPart.invertSteeringAngle) or(steeringAngle < 0 and rotPart.invertSteeringAngle) then
                                rx,ry,rz = MathUtil.vector3ArrayLerp(rotPart.defRot, rotPart.posRot, math.min( 1 ,percent * rotPart.posRotFactor))
                            else
                                    rx,ry,rz = MathUtil.vector3ArrayLerp(rotPart.defRot, rotPart.negRot, math.min( 1 ,percent * rotPart.negRotFactor))
                                end
                                setRotation(rotPart.node, rx,ry,rz)
                                if self.setMovingToolDirty ~ = nil then
                                    self:setMovingToolDirty(rotPart.node)
                                end
                            end
                        end
                    end
                end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function ArticulatedAxis.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Drivable , specializations)
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
function ArticulatedAxis.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ArticulatedAxis )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , ArticulatedAxis )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , ArticulatedAxis )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , ArticulatedAxis )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , ArticulatedAxis )
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
function ArticulatedAxis.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSteeringRotTimeByCurvature" , ArticulatedAxis.getSteeringRotTimeByCurvature)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTurningRadiusByRotTime" , ArticulatedAxis.getTurningRadiusByRotTime)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIReverserNode" , ArticulatedAxis.getAIReverserNode)
end

```