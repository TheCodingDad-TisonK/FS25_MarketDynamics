## Suspensions

**Description**

> Specialization for non-wheel suspensions e.g. cabin, seat or player character suspension

**Functions**

- [getIsSuspensionNodeActive](#getissuspensionnodeactive)
- [getSuspensionModfier](#getsuspensionmodfier)
- [getSuspensionNodeFromIndex](#getsuspensionnodefromindex)
- [initSpecialization](#initspecialization)
- [loadSuspensionNodeFromXML](#loadsuspensionnodefromxml)
- [onEnterVehicle](#onentervehicle)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [onVehicleCharacterChanged](#onvehiclecharacterchanged)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [setSuspensionNodeCharacter](#setsuspensionnodecharacter)
- [subCollisionErrorFunction](#subcollisionerrorfunction)

### getIsSuspensionNodeActive

**Description**

**Definition**

> getIsSuspensionNodeActive()

**Arguments**

| any | suspensionNode |
|-----|----------------|

**Code**

```lua
function Suspensions:getIsSuspensionNodeActive(suspensionNode)
    return suspensionNode.node ~ = nil and suspensionNode.component ~ = nil
end

```

### getSuspensionModfier

**Description**

**Definition**

> getSuspensionModfier()

**Code**

```lua
function Suspensions:getSuspensionModfier()
    local spec = self.spec_suspensions
    local index = 1
    -- try to get the seat suspension, normally on index 2(if no cabin suspension on index 1)
        if #spec.suspensionNodes > = 2 and not spec.suspensionNodes[ 2 ].useCharacterTorso and not spec.suspensionNodes[ 2 ].isRotational then
            index = 2
        end

        local suspensionNode = spec.suspensionNodes[index]
        if suspensionNode ~ = nil then
            if not suspensionNode.isRotational then
                return suspensionNode.curTranslation[ 2 ]
            end
        end

        return 0
    end

```

### getSuspensionNodeFromIndex

**Description**

**Definition**

> getSuspensionNodeFromIndex()

**Arguments**

| any | suspensionIndex |
|-----|-----------------|

**Code**

```lua
function Suspensions:getSuspensionNodeFromIndex(suspensionIndex)
    local spec = self.spec_suspensions
    if spec.suspensionAvailable then
        return self.spec_suspensions.suspensionNodes[suspensionIndex]
    end

    return nil
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Suspensions.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Suspensions" )

    local key = Suspensions.SUSPENSION_NODE_XML_KEY

    schema:register(XMLValueType.NODE_INDEX, key .. "#node" , "Suspension node" )
    schema:register(XMLValueType.BOOL, key .. "#useCharacterTorso" , "Use character torso instead of node" )
    schema:register(XMLValueType.FLOAT, key .. "#weight" , "Weight in kg" , 500 )
    schema:register(XMLValueType.VECTOR_ROT, key .. "#minRotation" , "Min.rotation" )
    schema:register(XMLValueType.VECTOR_ROT, key .. "#maxRotation" , "Max.rotation" )
    schema:register(XMLValueType.VECTOR_TRANS, key .. "#startTranslationOffset" , "Custom translation offset" )
    schema:register(XMLValueType.VECTOR_TRANS, key .. "#minTranslation" , "Min.translation" )
    schema:register(XMLValueType.VECTOR_TRANS, key .. "#maxTranslation" , "Max.translation" )
    schema:register(XMLValueType.FLOAT, key .. "#maxVelocityDifference" , "Max.velocity difference" , 0.1 )
    schema:register(XMLValueType.VECTOR_ 2 , key .. "#suspensionParametersX" , "Suspension parameters X" , "0 0" )
    schema:register(XMLValueType.VECTOR_ 2 , key .. "#suspensionParametersY" , "Suspension parameters Y" , "0 0" )
    schema:register(XMLValueType.VECTOR_ 2 , key .. "#suspensionParametersZ" , "Suspension parameters Z" , "0 0" )
    schema:register(XMLValueType.BOOL, key .. "#inverseMovement" , "Invert movement" , false )
    schema:register(XMLValueType.BOOL, key .. "#serverOnly" , "Suspension is only calculated on server side" , false )

    schema:register(XMLValueType.FLOAT, "vehicle.suspensions#maxUpdateDistance" , "Max.distance to vehicle root to update suspension nodes" , Suspensions.DEFAULT_MAX_UPDATE_DISTANCE)

    schema:setXMLSpecializationType()
end

```

### loadSuspensionNodeFromXML

**Description**

**Definition**

> loadSuspensionNodeFromXML()

**Arguments**

| any | xmlFile        |
|-----|----------------|
| any | key            |
| any | suspensionNode |

**Code**

```lua
function Suspensions:loadSuspensionNodeFromXML(xmlFile, key, suspensionNode)
    suspensionNode.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if suspensionNode.node ~ = nil then
        local component = self:getParentComponent(suspensionNode.node)
        if component ~ = nil then
            suspensionNode.component = component
            suspensionNode.refNodeOffset = { localToLocal(suspensionNode.node, component, 0 , 0 , 0 ) }
        end
    end
    suspensionNode.refNodeOffset = suspensionNode.refNodeOffset or { 0 , 0 , 0 }

    suspensionNode.useCharacterTorso = xmlFile:getValue(key .. "#useCharacterTorso" , false )
    if (suspensionNode.node ~ = nil and suspensionNode.component ~ = nil ) or suspensionNode.useCharacterTorso then
        suspensionNode.weight = xmlFile:getValue(key .. "#weight" , 500 )

        suspensionNode.minRotation = xmlFile:getValue(key .. "#minRotation" , nil , true )
        suspensionNode.maxRotation = xmlFile:getValue(key .. "#maxRotation" , nil , true )
        suspensionNode.isRotational = suspensionNode.minRotation ~ = nil and suspensionNode.maxRotation ~ = nil

        if not suspensionNode.isRotational and not suspensionNode.useCharacterTorso then
            suspensionNode.baseTranslation = { getTranslation(suspensionNode.node) }
            suspensionNode.startTranslationOffset = xmlFile:getValue(key .. "#startTranslationOffset" , "0 0 0" , true )
            for j = 1 , 3 do
                suspensionNode.baseTranslation[j] = suspensionNode.baseTranslation[j] + suspensionNode.startTranslationOffset[j]
            end

            setTranslation(suspensionNode.node, suspensionNode.baseTranslation[ 1 ], suspensionNode.baseTranslation[ 2 ], suspensionNode.baseTranslation[ 3 ])

            suspensionNode.minTranslation = xmlFile:getValue(key .. "#minTranslation" , nil , true )
            suspensionNode.maxTranslation = xmlFile:getValue(key .. "#maxTranslation" , nil , true )

            if suspensionNode.minTranslation = = nil or suspensionNode.maxTranslation = = nil then
                Logging.xmlWarning(xmlFile, "suspension '%s' has neither rotational nor translational limits, ignoring" , key)
                return false
            end
        end

        suspensionNode.maxVelocityDifference = xmlFile:getValue(key .. "#maxVelocityDifference" , 0.1 )

        local suspensionParametersX = xmlFile:getValue(key .. "#suspensionParametersX" , "0 0" , true )
        local suspensionParametersY = xmlFile:getValue(key .. "#suspensionParametersY" , "0 0" , true )
        local suspensionParametersZ = xmlFile:getValue(key .. "#suspensionParametersZ" , "0 0" , true )
        suspensionNode.suspensionParameters = { }
        suspensionNode.suspensionParameters[ 1 ] = { }
        suspensionNode.suspensionParameters[ 2 ] = { }
        suspensionNode.suspensionParameters[ 3 ] = { }
        for j = 1 , 2 do
            suspensionNode.suspensionParameters[ 1 ][j] = suspensionParametersX[j] * 1000
            suspensionNode.suspensionParameters[ 2 ][j] = suspensionParametersY[j] * 1000
            suspensionNode.suspensionParameters[ 3 ][j] = suspensionParametersZ[j] * 1000
        end

        suspensionNode.inverseMovement = xmlFile:getValue(key .. "#inverseMovement" , false )
        suspensionNode.serverOnly = xmlFile:getValue(key .. "#serverOnly" , false )

        suspensionNode.lastRefNodePosition = nil
        suspensionNode.lastRefNodeVelocity = nil

        suspensionNode.curRotation = { 0 , 0 , 0 }
        suspensionNode.curRotationSpeed = { 0 , 0 , 0 }

        suspensionNode.curTranslation = { 0 , 0 , 0 }
        suspensionNode.curTranslationSpeed = { 0 , 0 , 0 }

        suspensionNode.curAcc = { 0 , 0 , 0 }

        return true
    end

    return false
end

```

### onEnterVehicle

**Description**

**Definition**

> onEnterVehicle()

**Arguments**

| any | isControlling |
|-----|---------------|

**Code**

```lua
function Suspensions:onEnterVehicle(isControlling)
    if self.getVehicleCharacter ~ = nil then
        local vehicleCharacter = self:getVehicleCharacter()
        if vehicleCharacter ~ = nil then
            local spec = self.spec_suspensions
            for _, suspensionNode in ipairs(spec.suspensionNodes) do
                self:setSuspensionNodeCharacter(suspensionNode, vehicleCharacter)
            end
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
function Suspensions:onLoad(savegame)
    if self.isClient then
        local spec = self.spec_suspensions

        spec.suspensionNodes = { }

        for _, key in self.xmlFile:iterator( "vehicle.suspensions.suspension" ) do
            local suspensionNode = { }
            if self:loadSuspensionNodeFromXML( self.xmlFile, key, suspensionNode) then
                if not suspensionNode.serverOnly or self.isServer then
                    --#debug if suspensionNode.node ~ = nil then
                        --#debug I3DUtil.checkForChildCollisions(suspensionNode.node, Suspensions.subCollisionErrorFunction, self.xmlFile, getName(suspensionNode.node))
                        --#debug end

                        table.insert(spec.suspensionNodes, suspensionNode)
                    end
                end
            end

            spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.suspensions#maxUpdateDistance" , Suspensions.DEFAULT_MAX_UPDATE_DISTANCE)

            if #spec.suspensionNodes > 0 then
                spec.suspensionAvailable = true
            end

            if not Platform.gameplay.allowSuspensionNodes then
                if self.xmlFile:hasProperty( "vehicle.suspensions" ) then
                    Logging.xmlWarning( self.xmlFile, "Suspension nodes are not allowed on this platform" )
                    spec.suspensionAvailable = false
                    spec.suspensionNodes = { }
                end
            end
        end

        if not self.spec_suspensions.suspensionAvailable then
            SpecializationUtil.removeEventListener( self , "onUpdate" , Suspensions )
            SpecializationUtil.removeEventListener( self , "onEnterVehicle" , Suspensions )
            SpecializationUtil.removeEventListener( self , "onVehicleCharacterChanged" , Suspensions )
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
function Suspensions:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_suspensions
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        local timeDelta
        if self.isServer then
            timeDelta = 0.001 * g_physicsDt
        else
                timeDelta = 0.001 * dt
            end

            for _, suspension in ipairs(spec.suspensionNodes) do
                if suspension.node ~ = nil and entityExists(suspension.node) then
                    -- calc velocity diff
                    suspension.curAcc[ 1 ], suspension.curAcc[ 2 ], suspension.curAcc[ 3 ] = 0 , 0 , 0

                    if self:getIsSuspensionNodeActive(suspension) then
                        local wx, wy, wz = localToWorld(suspension.component, unpack(suspension.refNodeOffset))

                        if suspension.lastRefNodePosition = = nil then
                            suspension.lastRefNodePosition = { wx, wy, wz }
                            suspension.lastRefNodeVelocity = { 0 , 0 , 0 }
                        end

                        local direction = (suspension.inverseMovement and - 1 ) or 1

                        local newVelX, newVelY, newVelZ = (wx - suspension.lastRefNodePosition[ 1 ]) / timeDelta * direction,
                        (wy - suspension.lastRefNodePosition[ 2 ]) / timeDelta * direction,
                        (wz - suspension.lastRefNodePosition[ 3 ]) / timeDelta * direction

                        local oldVelX, oldVelY, oldVelZ = unpack(suspension.lastRefNodeVelocity)

                        local velDiffX, velDiffY, velDiffZ = worldDirectionToLocal(getParent(suspension.node), newVelX - oldVelX, newVelY - oldVelY, newVelZ - oldVelZ)

                        velDiffX = math.clamp(velDiffX, - suspension.maxVelocityDifference, suspension.maxVelocityDifference)
                        velDiffY = math.clamp(velDiffY, - suspension.maxVelocityDifference, suspension.maxVelocityDifference)
                        velDiffZ = math.clamp(velDiffZ, - suspension.maxVelocityDifference, suspension.maxVelocityDifference)

                        if suspension.isRotational then
                            if suspension.useCharacterTorso then
                                suspension.curAcc[ 1 ], suspension.curAcc[ 2 ], suspension.curAcc[ 3 ] = MathUtil.crossProduct(velDiffX / timeDelta, velDiffY / timeDelta, velDiffZ / timeDelta, 1 , 0 , 0 )
                            else
                                    suspension.curAcc[ 1 ], suspension.curAcc[ 2 ], suspension.curAcc[ 3 ] = MathUtil.crossProduct(velDiffX / timeDelta, velDiffY / timeDelta, velDiffZ / timeDelta, 0 , 1 , 0 )
                                end
                            else
                                    suspension.curAcc[ 1 ], suspension.curAcc[ 2 ], suspension.curAcc[ 3 ] = - velDiffX / timeDelta, - velDiffY / timeDelta, - velDiffZ / timeDelta
                                end

                                -- prepare for next tick
                                    suspension.lastRefNodePosition[ 1 ] = wx
                                    suspension.lastRefNodePosition[ 2 ] = wy
                                    suspension.lastRefNodePosition[ 3 ] = wz

                                    suspension.lastRefNodeVelocity[ 1 ] = newVelX
                                    suspension.lastRefNodeVelocity[ 2 ] = newVelY
                                    suspension.lastRefNodeVelocity[ 3 ] = newVelZ
                                end

                                -- update spring/damper system, F = F_ext - k*x - c*(dx/dt)
                                -- using implicit euler for spring and damper, explicit euler for external force
                                    for i = 1 , 3 do
                                        local suspensionParameter = suspension.suspensionParameters[i]
                                        if suspensionParameter[ 1 ] > 0 and suspensionParameter[ 2 ] > 0 then
                                            local f = suspension.weight * suspension.curAcc[i]

                                            local k = suspensionParameter[ 1 ]
                                            local c = suspensionParameter[ 2 ]

                                            if suspension.isRotational then
                                                local x = suspension.curRotation[i]
                                                local vx = suspension.curRotationSpeed[i]

                                                local force = f - (k * x) - (c * vx)

                                                -- 'Implicit Methods for Differential Equations' (Baraff), formula(4-6)
                                                    local m = suspension.weight
                                                    local h = timeDelta
                                                    local numerator = h * (force + h * ( - k) * vx) / m
                                                    local denumerator = 1 - (( - c) + h * ( - k)) * h / m
                                                    local curRotationSpeed = vx + numerator / denumerator

                                                    local newRotation = x + (curRotationSpeed * timeDelta)
                                                    newRotation = math.clamp(newRotation, suspension.minRotation[i], suspension.maxRotation[i])

                                                    suspension.curRotationSpeed[i] = (newRotation - x) / timeDelta
                                                    suspension.curRotation[i] = newRotation
                                                else
                                                        local x = suspension.curTranslation[i]
                                                        local vx = suspension.curTranslationSpeed[i]

                                                        local force = f - (k * x) - (c * vx)

                                                        -- 'Implicit Methods for Differential Equations' (Baraff), formula(4-6)
                                                            local m = suspension.weight
                                                            local h = timeDelta
                                                            local numerator = h * (force + h * ( - k) * vx) / m
                                                            local denumerator = 1 - (( - c) + h * ( - k)) * h / m
                                                            local curTranslationSpeed = vx + numerator / denumerator

                                                            local newTranslation = x + (curTranslationSpeed * timeDelta)
                                                            newTranslation = math.clamp(newTranslation, suspension.minTranslation[i], suspension.maxTranslation[i])

                                                            suspension.curTranslationSpeed[i] = (newTranslation - x) / timeDelta
                                                            suspension.curTranslation[i] = newTranslation
                                                        end
                                                    end
                                                end

                                                if suspension.isRotational then
                                                    setRotation(suspension.node, suspension.curRotation[ 1 ], suspension.curRotation[ 2 ], suspension.curRotation[ 3 ])
                                                elseif suspension.minTranslation ~ = nil then
                                                        setTranslation(suspension.node, suspension.baseTranslation[ 1 ] + suspension.curTranslation[ 1 ], suspension.baseTranslation[ 2 ] + suspension.curTranslation[ 2 ], suspension.baseTranslation[ 3 ] + suspension.curTranslation[ 3 ])
                                                    end

                                                    if self.setMovingToolDirty ~ = nil then
                                                        self:setMovingToolDirty(suspension.node)
                                                    end
                                                elseif suspension.node ~ = nil then
                                                        Logging.xmlError( self.xmlFile, "Failed to update suspension node %d.Node does not exist anymore!" , suspension.node)
                                                        suspension.node = nil
                                                    end
                                                end
                                            end
                                        end

```

### onVehicleCharacterChanged

**Description**

**Definition**

> onVehicleCharacterChanged()

**Arguments**

| any | character |
|-----|-----------|

**Code**

```lua
function Suspensions:onVehicleCharacterChanged(character)
    local spec = self.spec_suspensions
    for _, suspensionNode in ipairs(spec.suspensionNodes) do
        if suspensionNode.useCharacterTorso then
            if character ~ = nil then
                self:setSuspensionNodeCharacter(suspensionNode, character)
            else
                    suspensionNode.node = nil
                end
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
function Suspensions.prerequisitesPresent(specializations)
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
function Suspensions.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Suspensions )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Suspensions )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , Suspensions )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleCharacterChanged" , Suspensions )
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
function Suspensions.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadSuspensionNodeFromXML" , Suspensions.loadSuspensionNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getSuspensionNodeFromIndex" , Suspensions.getSuspensionNodeFromIndex)
    SpecializationUtil.registerFunction(vehicleType, "getIsSuspensionNodeActive" , Suspensions.getIsSuspensionNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "setSuspensionNodeCharacter" , Suspensions.setSuspensionNodeCharacter)
end

```

### setSuspensionNodeCharacter

**Description**

**Definition**

> setSuspensionNodeCharacter()

**Arguments**

| any | suspensionNode |
|-----|----------------|
| any | character      |

**Code**

```lua
function Suspensions:setSuspensionNodeCharacter(suspensionNode, character)
    if suspensionNode.useCharacterTorso and character.playerModel ~ = nil then
        suspensionNode.node = character.playerModel.thirdPersonSuspensionNode

        if suspensionNode.node ~ = nil then
            local component = self:getParentComponent(suspensionNode.node)
            if component ~ = nil then
                suspensionNode.refNodeOffset = { localToLocal(character.characterNode, component, 0 , 0 , 0 ) }
                suspensionNode.component = component
            end
        end
    end
end

```

### subCollisionErrorFunction

**Description**

**Definition**

> subCollisionErrorFunction()

**Arguments**

| any | collisionNode |
|-----|---------------|
| any | xmlFile       |
| any | nodeName      |

**Code**

```lua
function Suspensions.subCollisionErrorFunction(collisionNode, xmlFile, nodeName)
    if getHasClassId(collisionNode, ClassIds.SHAPE) then
        Logging.xmlError(xmlFile, "Found collision '%s' as child of suspension node '%s'.This can cause the vehicle to never sleep!" , getName(collisionNode), nodeName)
    end
end

```