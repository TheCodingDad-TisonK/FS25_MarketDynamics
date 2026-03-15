## AIDrivable

**Description**

> Specialization for extending vehicles to by used by AI helpers

**Functions**

- [addAIAgentAttachment](#addaiagentattachment)
- [consoleCommandMove](#consolecommandmove)
- [consoleCommandSetTurnRadius](#consolecommandsetturnradius)
- [createAgent](#createagent)
- [deleteAgent](#deleteagent)
- [drawDebugAIAgent](#drawdebugaiagent)
- [getAIAgentMaxBrakeAcceleration](#getaiagentmaxbrakeacceleration)
- [getAIAgentSize](#getaiagentsize)
- [getAIAllowsBackwards](#getaiallowsbackwards)
- [getAIRootNode](#getairootnode)
- [getAIRootNodeBoundingBox](#getairootnodeboundingbox)
- [getAIRootNodeMaxZOffset](#getairootnodemaxzoffset)
- [getAIRootNodeMinZOffset](#getairootnodeminzoffset)
- [getAITurningRadius](#getaiturningradius)
- [getCanStartAIVehicle](#getcanstartaivehicle)
- [getIsAIJobSupported](#getisaijobsupported)
- [getIsAIPreparingToDrive](#getisaipreparingtodrive)
- [getIsAIReadyToDrive](#getisaireadytodrive)
- [initSpecialization](#initspecialization)
- [loadAgentInfoFromXML](#loadagentinfofromxml)
- [onCruiseControlSpeedChanged](#oncruisecontrolspeedchanged)
- [onEnterVehicle](#onentervehicle)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onUpdate](#onupdate)
- [postInitSpecialization](#postinitspecialization)
- [prepareForAIDriving](#prepareforaidriving)
- [prerequisitesPresent](#prerequisitespresent)
- [reachedAITarget](#reachedaitarget)
- [registerAgentXMLPaths](#registeragentxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setAIRootNodeDirty](#setairootnodedirty)
- [setAITarget](#setaitarget)
- [startNewAIAgentAttachmentChain](#startnewaiagentattachmentchain)
- [unsetAITarget](#unsetaitarget)
- [updateAIAgentAttachmentOffsetData](#updateaiagentattachmentoffsetdata)
- [updateAIAgentAttachments](#updateaiagentattachments)
- [updateAIAgentPoseData](#updateaiagentposedata)

### addAIAgentAttachment

**Description**

**Definition**

> addAIAgentAttachment()

**Arguments**

| any | attachmentData |
|-----|----------------|
| any | level          |

**Code**

```lua
function AIDrivable:addAIAgentAttachment(attachmentData, level)
    local spec = self.spec_aiDrivable

    spec.attachmentsMaxWidth = math.max(spec.attachmentsMaxWidth, attachmentData.width)
    spec.attachmentsMaxHeight = math.max(spec.attachmentsMaxHeight, attachmentData.height)

    attachmentData.level = level

    if spec.attachmentChains[spec.attachmentChainIndex] = = nil then
        spec.attachmentChains[spec.attachmentChainIndex] = { }
    end

    table.insert(spec.attachments, attachmentData)
    table.insert(spec.attachmentChains[spec.attachmentChainIndex], attachmentData)
end

```

### consoleCommandMove

**Description**

**Definition**

> consoleCommandMove()

**Arguments**

| any | distance |
|-----|----------|

**Code**

```lua
function AIDrivable:consoleCommandMove(distance)
    local vehicles = { }
    local attachedVehicles = self:getChildVehicles()
    for _, vehicle in ipairs(attachedVehicles) do
        vehicle:removeFromPhysics()
        table.insert(vehicles, vehicle)
    end

    local aiRootNode = self:getAIRootNode()
    local dirX, dirY, dirZ = localDirectionToWorld(aiRootNode, 1 , 0 , 0 )
    local moveX, moveY, moveZ = dirX * distance, dirY * distance, dirZ * distance
    local currentTurnRadius = self:getTurningRadiusByRotTime( self.rotatedTime)

    local gizmo = DebugGizmo.new()
    local x, y, z = localToWorld(aiRootNode, currentTurnRadius, 0.05 , 0 )
    gizmo:createWithWorldPosAndDir(x, y, z, 0 , 0 , 1 , 0 , 1 , 0 , "" , false , nil )
    g_debugManager:addElement(gizmo)

    currentTurnRadius = - currentTurnRadius + distance
    self.rotatedTime = self:getSteeringRotTimeByCurvature( 1 / currentTurnRadius)

    if self.rotatedTime < 0 then
        self.spec_wheels.axisSide = self.rotatedTime / - self.maxRotTime / self:getSteeringDirection()
    else
            self.spec_wheels.axisSide = self.rotatedTime / self.minRotTime / self:getSteeringDirection()
        end

        for _, vehicle in ipairs(vehicles) do
            for _, component in ipairs(vehicle.components) do
                x, y, z = getWorldTranslation(component.node)
                setWorldTranslation(component.node, x + moveX, y + moveY, z + moveZ)
            end
        end

        for _, vehicle in ipairs(vehicles) do
            vehicle:addToPhysics()
        end
    end

```

### consoleCommandSetTurnRadius

**Description**

**Definition**

> consoleCommandSetTurnRadius()

**Arguments**

| any | turnRadius |
|-----|------------|

**Code**

```lua
function AIDrivable:consoleCommandSetTurnRadius(turnRadius)
    turnRadius = tonumber(turnRadius) or 10

    local rotatedTime = self:getSteeringRotTimeByCurvature( 1 / turnRadius)

    local axisSide
    if rotatedTime > 0 then
        axisSide = rotatedTime / - self.maxRotTime
    else
            axisSide = rotatedTime / self.minRotTime
        end

        axisSide = self:getSteeringDirection() * axisSide

        self.spec_drivable.axisSide = axisSide
    end

```

### createAgent

**Description**

**Definition**

> createAgent()

**Arguments**

| any | helperIndex |
|-----|-------------|

**Code**

```lua
function AIDrivable:createAgent(helperIndex)
    if self.isServer then
        local spec = self.spec_aiDrivable

        spec.cruiseControlLimit = math.huge

        -- first update the ai attachments which may have influence on the agent size
        self:updateAIAgentAttachments()
        local trailerData = spec.attachmentsTrailerOffsetData

        local navigationMapId = g_currentMission.aiSystem:getNavigationMap()
        local agent = spec.agentInfo
        local width, length, lengthOffset, frontOffset, height = self:getAIAgentSize()
        local maxBrakeAcceleration = self:getAIAgentMaxBrakeAcceleration()
        local maxCentripetalAcceleration = agent.maxCentripetalAcceleration
        local minTurningRadius = self:getAITurningRadius(agent.maxTurningRadius or self.maxTurningRadius)
        local minLandingTurningRadius = minTurningRadius -- turning radius limit used when approaching the goal
        local allowBackwards = self:getAIAllowsBackwards()

        spec.agentId = createVehicleNavigationAgent(navigationMapId, minTurningRadius, minLandingTurningRadius, allowBackwards, width, height, length, lengthOffset, frontOffset, maxBrakeAcceleration, maxCentripetalAcceleration, trailerData)

        setName(spec.agentId, string.format( "%s - %s" , getName(spec.agentId), self.configFileNameClean))

        g_currentMission.aiSystem:addAgent(spec.agentId, self )

        self:setAIVehicleObstacleStateDirty()

        if g_currentMission.aiSystem.debugEnabled then
            if spec.debugVehicle ~ = nil then
                spec.debugVehicle:delete()
            end
            spec.debugVehicle = AIDebugVehicle.new( self , { math.random(), math.random(), math.random() } )

            if spec.debugDump ~ = nil then
                spec.debugDump:delete()
            end

            spec.debugDump = AIDebugDump.new( self , spec.agentId)
            spec.debugDump:startRecording(minTurningRadius, allowBackwards, width, length, lengthOffset, frontOffset, maxBrakeAcceleration, maxCentripetalAcceleration)
        end
        if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
            enableVehicleNavigationAgentDebugRendering(spec.agentId, true )
        end
    end
end

```

### deleteAgent

**Description**

**Definition**

> deleteAgent()

**Code**

```lua
function AIDrivable:deleteAgent()
    local spec = self.spec_aiDrivable

    spec.isRunning = false
    self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF, true )

    if spec.debugDump ~ = nil then
        spec.debugDump:delete()
        spec.debugDump = nil
    end

    if spec.agentId ~ = nil then

        if g_currentMission ~ = nil and g_currentMission.aiSystem ~ = nil then
            g_currentMission.aiSystem:removeAgent(spec.agentId)
        end

        delete(spec.agentId)
        spec.agentId = nil
    end

    self:setAIVehicleObstacleStateDirty()
end

```

### drawDebugAIAgent

**Description**

**Definition**

> drawDebugAIAgent()

**Code**

```lua
function AIDrivable:drawDebugAIAgent()
    local spec = self.spec_aiDrivable
    if not spec.agentInfo.isValid then
        return
    end

    local aiRootNode = self:getAIRootNode()
    local groundOffset = 0.15

    local yOffset = 0
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem ~ = nil then
        if storeItem.shopTranslationOffset ~ = nil then
            yOffset = storeItem.shopTranslationOffset[ 2 ]
        end
    end

    local width, length, lengthOffset, frontOffset, height = self:getAIAgentSize()
    spec.debugSizeBox:createWithNode(aiRootNode, width, height, length, 0 , height * 0.5 - yOffset, lengthOffset)
    spec.debugSizeBox:draw()

    local fx, fy, fz = localToWorld(aiRootNode, 0 , 0 , frontOffset)
    local dirX, dirY, dirZ = localDirectionToWorld(aiRootNode, 0 , 0 , 1 )
    local upX, upY, upZ = localDirectionToWorld(aiRootNode, 0 , 1 , 0 )
    if fy > 0 then
        fy = getTerrainHeightAtWorldPos(g_terrainNode, fx, 0 , fz) + groundOffset
    end
    spec.debugFrontMarker:createWithWorldPosAndDir(fx, fy, fz, dirX, dirY, dirZ, upX, upY, upZ, "FrontMarker" , false , nil , 3 )
    spec.debugFrontMarker:draw()

    local x, y, z = getWorldTranslation(aiRootNode)
    if spec.isRunning then
        local text
        if spec.useManualDriving then
            text = string.format( "Distance: %.2f" , spec.distanceToTarget)
        else
                text = AIDrivable.STATES[spec.lastState]
            end

            Utils.renderTextAtWorldPosition(x, y + 4 , z, text , 0.015 , 0 , 1 , 1 , 1 , 1 )
        end

        if spec.debugVehicle ~ = nil then
            spec.debugVehicle:setForcedY(y + 0.1 )
            spec.debugVehicle:draw()
        end

        local sx, _, sz = localToWorld(aiRootNode, 0 , 0.5 , 0 )
        local sy = getTerrainHeightAtWorldPos(g_terrainNode, sx, 0 , sz) + groundOffset

        local lx, _, lz = localToWorld(aiRootNode, 10 , 0.5 , 0 )
        local rx, _, rz = localToWorld(aiRootNode, - 10 , 0.5 , 0 )

        drawDebugLine(sx, sy, sz, 1 , 0 , 0 , lx, sy, lz, 1 , 0 , 0 )
        drawDebugLine(sx, sy, sz, 0 , 1 , 0 , rx, sy, rz, 0 , 1 , 0 )

        local dirX1, dirZ1 = MathUtil.vector2Normalize(lx - sx, lz - sz)
        local maxTurningRadius = self.maxTurningRadius
        local currentTurnRadius = self:getTurningRadiusByRotTime( self.rotatedTime)
        local minRadius = self:getAITurningRadius( self.maxTurningRadius)

        local revTime = self:getSteeringRotTimeByCurvature( 1 / (currentTurnRadius * ( self.rotatedTime > = 0 and 1 or - 1 )))

        local debugString = string.format( "ReferenceRadius: %.3fm\nMinRadius: %.3fm\nCalc Radius: %.3f\nRotatedTime: %.3f\nRevTime: %.3f" , currentTurnRadius, maxTurningRadius, minRadius, self.rotatedTime, revTime)
        Utils.renderTextAtWorldPosition(sx, sy + 5 , sz, debugString, getCorrectTextSize( 0.012 ), 0 )

        local wheelSpec = self.spec_wheels
        for _, wheel in ipairs(wheelSpec.wheels) do
            if wheel.physics.rotSpeed ~ = 0 or( self.spec_articulatedAxis ~ = nil and self.spec_articulatedAxis.componentJoint ~ = nil ) then
                local wsx, wsy, wsz = localToWorld(wheel.repr, 0 , 0 , 0 )
                local wdx, wdy, wdz = localDirectionToWorld(wheel.driveNode, 1 , 0 , 0 )
                local wlx, _, wlz = wsx + wdx * 10 , wsy + wdy * 10 , wsz + wdz * 10
                local wrx, _, wrz = wsx + wdx * - 10 , wsy + wdy * - 10 , wsz + wdz * - 10
                drawDebugLine(wsx, sy, wsz, 1 , 0 , 0 , wlx, sy, wlz, 1 , 0 , 0 )
                drawDebugLine(wsx, sy, wsz, 0 , 1 , 0 , wrx, sy, wrz, 0 , 1 , 0 )
            end
        end

        if wheelSpec.steeringCenterNode ~ = nil then
            DebugGizmo.renderAtNode(wheelSpec.steeringCenterNode, "SCN" )
        end

        local sign = math.sign( self.rotatedTime)
        local cx, cz = sx + sign * dirX1 * currentTurnRadius, sz + sign * dirZ1 * currentTurnRadius
        DebugGizmo.renderAtPosition(cx, sy, cz, dirX1, 0 , dirZ1, 0 , 1 , 0 , "X" )

        sign = math.sign( self.rotatedTime)
        cx, cz = sx + sign * dirX1 * minRadius, sz + sign * dirZ1 * minRadius
        DebugGizmo.renderAtPosition(cx, sy, cz, dirX1, 0 , dirZ1, 0 , 1 , 0 , "M" )
    end

```

### getAIAgentMaxBrakeAcceleration

**Description**

**Definition**

> getAIAgentMaxBrakeAcceleration()

**Code**

```lua
function AIDrivable:getAIAgentMaxBrakeAcceleration()
    local spec = self.spec_aiDrivable
    local agent = spec.agentInfo
    return agent.maxBrakeAcceleration
end

```

### getAIAgentSize

**Description**

**Definition**

> getAIAgentSize()

**Code**

```lua
function AIDrivable:getAIAgentSize()
    local spec = self.spec_aiDrivable

    local agent = spec.agentInfo
    if not agent.isValid then
        return nil , nil , nil , nil , nil
    end

    local width = math.max(agent.width, spec.attachmentsMaxWidth)
    local height = math.max(agent.height, spec.attachmentsMaxHeight)
    local length = agent.length
    local lengthOffset = agent.lengthOffset

    length = length + spec.attachmentsMaxLengthOffsetPos - spec.attachmentsMaxLengthOffsetNeg
    lengthOffset = lengthOffset + spec.attachmentsMaxLengthOffsetPos * 0.5 + spec.attachmentsMaxLengthOffsetNeg * 0.5

    return width, length, lengthOffset, agent.frontOffset, height
end

```

### getAIAllowsBackwards

**Description**

**Definition**

> getAIAllowsBackwards()

**Code**

```lua
function AIDrivable:getAIAllowsBackwards()
    return false
end

```

### getAIRootNode

**Description**

**Definition**

> getAIRootNode()

**Code**

```lua
function AIDrivable:getAIRootNode()
    return self.components[ 1 ].node
end

```

### getAIRootNodeBoundingBox

**Description**

**Definition**

> getAIRootNodeBoundingBox()

**Code**

```lua
function AIDrivable:getAIRootNodeBoundingBox()
    local spec = self.spec_aiDrivable
    local boundingBox = spec.aiRootNodeBoundingBox
    local aiRootNode = self:getAIRootNode()

    local sizeX, sizeY, sizeZ = boundingBox[ 2 ] - boundingBox[ 1 ], boundingBox[ 4 ] - boundingBox[ 3 ], boundingBox[ 6 ] - boundingBox[ 5 ]
    local centerX, centerY, centerZ = boundingBox[ 1 ] + sizeX * 0.5 , boundingBox[ 3 ] + sizeY * 0.5 , boundingBox[ 5 ] + sizeZ * 0.5

    local vx, vy, vz = localToWorld(aiRootNode, centerX, centerY, centerZ)
    local qx, qy, qz, qw = getWorldQuaternion(aiRootNode)

    return vx, vy, vz, qx, qy, qz, qw, sizeX * 0.5 , sizeY * 0.5 , sizeZ * 0.5
end

```

### getAIRootNodeMaxZOffset

**Description**

**Definition**

> getAIRootNodeMaxZOffset()

**Code**

```lua
function AIDrivable:getAIRootNodeMaxZOffset()
    local spec = self.spec_aiDrivable
    return spec.aiRootNodeBoundingBox[ 6 ]
end

```

### getAIRootNodeMinZOffset

**Description**

**Definition**

> getAIRootNodeMinZOffset()

**Code**

```lua
function AIDrivable:getAIRootNodeMinZOffset()
    local spec = self.spec_aiDrivable
    return spec.aiRootNodeBoundingBox[ 5 ]
end

```

### getAITurningRadius

**Description**

**Definition**

> getAITurningRadius()

**Arguments**

| any | minRadius |
|-----|-----------|

**Code**

```lua
function AIDrivable:getAITurningRadius(minRadius)
    return minRadius
end

```

### getCanStartAIVehicle

**Description**

**Definition**

> getCanStartAIVehicle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIDrivable:getCanStartAIVehicle(superFunc)
    local spec = self.spec_aiDrivable
    if not spec.agentInfo.isValid then
        return false
    end

    return superFunc( self )
end

```

### getIsAIJobSupported

**Description**

**Definition**

> getIsAIJobSupported()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | jobName   |

**Code**

```lua
function AIDrivable:getIsAIJobSupported(superFunc, jobName)
    local spec = self.spec_aiDrivable
    if not spec.agentInfo.isValid then
        return false
    end

    return superFunc( self , jobName)
end

```

### getIsAIPreparingToDrive

**Description**

**Definition**

> getIsAIPreparingToDrive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIDrivable:getIsAIPreparingToDrive(superFunc)
    for _, vehicle in ipairs( self.rootVehicle.childVehicles) do
        if vehicle ~ = self then
            if vehicle.getIsAIPreparingToDrive ~ = nil then
                if vehicle:getIsAIPreparingToDrive() then
                    return true
                end
            end
        end
    end

    return superFunc( self )
end

```

### getIsAIReadyToDrive

**Description**

**Definition**

> getIsAIReadyToDrive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIDrivable:getIsAIReadyToDrive(superFunc)
    for _, vehicle in ipairs( self.rootVehicle.childVehicles) do
        if vehicle ~ = self then
            if vehicle.getIsAIReadyToDrive ~ = nil then
                if not vehicle:getIsAIReadyToDrive() then
                    return false , vehicle
                end
            end
        end
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AIDrivable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AI" )
    AIDrivable.registerAgentXMLPaths(schema, "vehicle.ai.agent" )
    schema:setXMLSpecializationType()
end

```

### loadAgentInfoFromXML

**Description**

**Definition**

> loadAgentInfoFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | agent   |

**Code**

```lua
function AIDrivable:loadAgentInfoFromXML(xmlFile, agent)
    local baseSizeKey = "vehicle.ai.agent"
    agent.width = xmlFile:getValue(baseSizeKey .. "#width" )
    agent.length = xmlFile:getValue(baseSizeKey .. "#length" )
    agent.height = xmlFile:getValue(baseSizeKey .. "#height" )
    agent.lengthOffset = xmlFile:getValue(baseSizeKey .. "#lengthOffset" , 0 )
    agent.frontOffset = xmlFile:getValue(baseSizeKey .. "#frontOffset" , 3 )
    agent.frontWheelIndices = xmlFile:getValue(baseSizeKey .. "#frontWheelIndices" , nil , true )
    agent.frontWheelNodes = xmlFile:getValue(baseSizeKey .. "#frontWheelNodes" , nil , self.components, self.i3dMappings, true )
    agent.maxBrakeAcceleration = xmlFile:getValue(baseSizeKey .. "#maxBrakeAcceleration" , 5 )
    agent.maxCentripetalAcceleration = xmlFile:getValue(baseSizeKey .. "#maxCentripetalAcceleration" , 1 )
    agent.maxTurningRadius = xmlFile:getValue(baseSizeKey .. "#maxTurningRadius" )

    agent.isDefined = xmlFile:hasProperty(baseSizeKey)

    -- check configurations for changed agent values
        for name, id in pairs( self.configurations) do
            local configDesc = g_vehicleConfigurationManager:getConfigurationDescByName(name)
            local key = string.format( "%s(%d).aiAgent" , configDesc.configurationKey, id - 1 )

            if xmlFile:hasProperty(key) then
                agent.width = xmlFile:getValue(key .. "#width" , agent.width)
                agent.length = xmlFile:getValue(key .. "#length" , agent.length)
                agent.height = xmlFile:getValue(key .. "#height" , agent.height)
                agent.lengthOffset = xmlFile:getValue(key .. "#lengthOffset" , agent.lengthOffset)
                agent.frontOffset = xmlFile:getValue(key .. "#frontOffset" , agent.frontOffset)

                agent.frontWheelIndices = xmlFile:getValue(key .. "#frontWheelIndices" , agent.frontWheelIndices, true )
                agent.frontWheelNodes = xmlFile:getValue(key .. "#frontWheelNodes" , agent.frontWheelNodes, self.components, self.i3dMappings, true )

                agent.maxBrakeAcceleration = math.min(xmlFile:getValue(key .. "#maxBrakeAcceleration" , agent.maxBrakeAcceleration))
                agent.maxCentripetalAcceleration = math.min(xmlFile:getValue(key .. "#maxCentripetalAcceleration" , agent.maxCentripetalAcceleration))
                agent.maxTurningRadius = xmlFile:getValue(key .. "#maxTurningRadius" , agent.maxTurningRadius)

                agent.isDefined = true
            end
        end
    end

```

### onCruiseControlSpeedChanged

**Description**

**Definition**

> onCruiseControlSpeedChanged()

**Arguments**

| any | speed        |
|-----|--------------|
| any | speedReverse |

**Code**

```lua
function AIDrivable:onCruiseControlSpeedChanged(speed, speedReverse)
    local spec = self.spec_aiDrivable
    spec.cruiseControlLimit = speed
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
function AIDrivable:onEnterVehicle(isControlling)
    if isControlling and self.isServer then
        addConsoleCommand( "gsAISetTurnRadius" , "Set Turn radius" , "consoleCommandSetTurnRadius" , self )
        addConsoleCommand( "gsAIMoveVehicle" , "Moves vehicles" , "consoleCommandMove" , self )
        addConsoleCommand( "gsAIClearPath" , "Clears debug path" , "consoleCommandClearPath" , self )
    end
end

```

### onLeaveVehicle

**Description**

**Definition**

> onLeaveVehicle()

**Arguments**

| any | wasEntered |
|-----|------------|

**Code**

```lua
function AIDrivable:onLeaveVehicle(wasEntered)
    if wasEntered then
        removeConsoleCommand( "gsAISetTurnRadius" )
        removeConsoleCommand( "gsAIMoveVehicle" )
        removeConsoleCommand( "gsAIClearPath" )
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
function AIDrivable:onLoad(savegame)
    local spec = self.spec_aiDrivable

    spec.agentInfo = { }
    spec.agentInfo.isValid = false
    self:loadAgentInfoFromXML( self.xmlFile, spec.agentInfo)

    spec.maxSpeed = math.huge
    spec.isRunning = false
    spec.useManualDriving = false
    spec.lastState = nil
    spec.lastIsBlocked = false
    spec.lastMaxSpeed = 0
    spec.cruiseControlLimit = math.huge
    spec.stuckTime = 0
    spec.agentId = nil
    spec.targetX, spec.targetY, spec.targetZ = nil , nil , nil
    spec.targetDirX, spec.targetDirY, spec.targetDirZ = nil , nil , nil

    spec.lastNoSpaceAtStart, spec.lastNoSpaceAtTarget = false , false

    spec.aiRootNodeBoundingBox = { 0 , 1 , 0 , 1 , 0 , 1 }

    spec.attachments = { }
    spec.attachmentChains = { }
    spec.attachmentChainIndex = 1
    spec.attachmentsTrailerOffsetData = { }
    spec.attachmentsMaxWidth = 0
    spec.attachmentsMaxHeight = 0
    spec.attachmentsMaxLengthOffsetPos = 0
    spec.attachmentsMaxLengthOffsetNeg = 0

    spec.poseData = { }

    spec.debugVehicle = nil
    spec.debugSizeBox = DebugBox.new()
    spec.debugSizeBox:setColorRGBA( 0 , 1 , 1 )
    spec.debugSizeBox:setText( "agentSize" )
    spec.debugSizeBox:setTextSize( 0.012 )

    spec.debugFrontMarker = DebugGizmo.new()
    spec.debugDump = nil
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Code**

```lua
function AIDrivable:onPostLoad()
    local spec = self.spec_aiDrivable

    local aiRootNode = self:getAIRootNode()

    spec.attacherJointOffsets = { }
    if self.getAttacherJoints ~ = nil then
        for _, attacherJoint in ipairs( self:getAttacherJoints()) do
            local node = attacherJoint.jointTransform
            local xDir, yDir, zDir = localDirectionToLocal(node, aiRootNode, 0 , 0 , 1 )
            local xUp, yUp, zUp = localDirectionToLocal(node, aiRootNode, 0 , 1 , 0 )
            local x, y, z = localToLocal(node, aiRootNode, 0 , 0 , 0 )

            table.insert(spec.attacherJointOffsets, { x = x, y = y, z = z, xDir = xDir, yDir = yDir, zDir = zDir, xUp = xUp, yUp = yUp, zUp = zUp } )
        end
    end

    -- only auto generate if we have at least a empty entry inside the xml
        if spec.agentInfo.isDefined then
            if spec.agentInfo.width = = nil or spec.agentInfo.length = = nil or spec.agentInfo.height = = nil then
                spec.agentInfo.width = spec.agentInfo.width or self.size.width
                spec.agentInfo.height = spec.agentInfo.height or self.size.height

                if spec.agentInfo.length = = nil then
                    spec.agentInfo.length = self.size.length
                    local _, _, zOffset = localToLocal(aiRootNode, self.rootNode, 0 , 0 , 0 )
                    spec.agentInfo.lengthOffset = - zOffset + self.size.lengthOffset
                end
            end

            if spec.agentInfo.frontWheelIndices ~ = nil or spec.agentInfo.frontWheelNodes ~ = nil then
                local z, numPositions = 0 , 0
                if spec.agentInfo.frontWheelNodes ~ = nil and #spec.agentInfo.frontWheelNodes > 0 then
                    for i, wheelNode in ipairs(spec.agentInfo.frontWheelNodes) do
                        local wheel = self:getWheelByWheelNode(wheelNode)
                        if wheel ~ = nil then
                            local _, _, rz = localToLocal(wheel.repr, aiRootNode, 0 , 0 , 0 )
                            z = z + rz
                            numPositions = numPositions + 1
                        else
                                Logging.xmlWarning( self.xmlFile, "Node wheel for node '%s' found for ai agent definition." , getName(wheelNode))
                                end
                            end
                        elseif spec.agentInfo.frontWheelIndices ~ = nil and #spec.agentInfo.frontWheelIndices > 0 then
                                for i, wheelIndex in ipairs(spec.agentInfo.frontWheelIndices) do
                                    local wheel = self:getWheelFromWheelIndex(wheelIndex)
                                    if wheel ~ = nil then
                                        local _, _, rz = localToLocal(wheel.repr, aiRootNode, 0 , 0 , 0 )
                                        z = z + rz
                                        numPositions = numPositions + 1
                                    else
                                            Logging.xmlWarning( self.xmlFile, "Unknown wheel index '%d' found for ai agent definition." , wheelIndex)
                                            end
                                        end
                                    end

                                    if numPositions > 0 then
                                        spec.agentInfo.frontOffset = z / numPositions
                                    end
                                end
                            end

                            spec.agentInfo.isValid = spec.agentInfo.width ~ = nil or spec.agentInfo.length ~ = nil or spec.agentInfo.height ~ = nil

                            spec.debugSizeBox:setText( string.format( "agentSize\nw:%.2f l:%.2f h:%.2f" , spec.agentInfo.width or 0 , spec.agentInfo.length or 0 , spec.agentInfo.height or 0 ))

                            self:setAIRootNodeDirty()
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
function AIDrivable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_aiDrivable

    if self.isServer then
        if spec.isRunning then

            -- if vehicle was blocked in the last frame we want to keep the block state as long as last speed < 4kmh
                -- to avoid issues with set block or unblock each frame
                local isStillBlocked = spec.lastIsBlocked and self:getLastSpeed() < 5
                -- check if vehicle is currently blocked
                    local isCurrentlyBlocked = math.abs(spec.lastMaxSpeed) > 0 and self:getLastSpeed() < 1

                    if isCurrentlyBlocked or isStillBlocked then
                        spec.stuckTime = spec.stuckTime + dt
                    else
                            spec.stuckTime = 0
                        end

                        local isBlocked = spec.stuckTime > 5000

                        local aiRootNode = self:getAIRootNode()
                        local x, y, z = getWorldTranslation(aiRootNode)
                        spec.distanceToTarget = MathUtil.vector2Length(x - spec.targetX, z - spec.targetZ)
                        local lastSpeed = self.lastSpeedReal * self.movingDirection * 1000

                        local maxSpeed = math.min(spec.maxSpeed, spec.cruiseControlLimit)

                        if spec.useManualDriving then
                            local tx, _, tz = worldToLocal(aiRootNode, spec.targetX, spec.targetY, spec.targetZ)

                            AIVehicleUtil.driveToPoint( self , dt, 1 , true , true , tx, tz, maxSpeed, false )

                            spec.lastMaxSpeed = maxSpeed

                            if spec.distanceToTarget < 0.5 then
                                self:reachedAITarget()
                            end
                        else
                                local dirX, dirY, dirZ = localDirectionToWorld(aiRootNode, 0 , 0 , 1 )

                                self:updateAIAgentPoseData()

                                local curvature, maxSpeedCurvature, status = getVehicleNavigationAgentNextCurvature(spec.agentId, spec.poseData, math.abs(lastSpeed))

                                if spec.debugDump ~ = nil then
                                    spec.debugDump:addData(dt, x, y, z, dirX, dirY, dirZ, lastSpeed, curvature, maxSpeed, status )
                                end

                                -- update driving
                                if status = = AgentState.DRIVING then
                                    maxSpeed = math.min(maxSpeedCurvature * 3.6 , maxSpeed)
                                    AIVehicleUtil.driveAlongCurvature( self , dt, curvature, maxSpeed, 1 )
                                    if maxSpeed = = 0 then
                                        isBlocked = false
                                    end
                                elseif status = = AgentState.PLANNING then
                                        self:stopAIDriving()
                                        isBlocked = false
                                        self:brake( 1 )
                                    elseif status = = AgentState.BLOCKED then
                                            self:stopAIDriving()
                                            isBlocked = true
                                        elseif status = = AgentState.TARGET_REACHED then
                                                isBlocked = false
                                                self:reachedAITarget()
                                            elseif status = = AgentState.NOT_REACHABLE then
                                                    isBlocked = false
                                                    self:stopCurrentAIJob( AIMessageErrorNotReachable.new())
                                                end

                                                spec.lastState = status
                                                spec.lastMaxSpeed = maxSpeed
                                            end

                                            if spec.debugVehicle ~ = nil then
                                                spec.debugVehicle:update(dt)
                                            end

                                            -- reset the stuck time if the blocking is for a valid reason(e.g.traffic blockers and planning state)
                                                if not isBlocked and spec.stuckTime > 5000 then
                                                    spec.stuckTime = 0
                                                end

                                                if isBlocked and not spec.lastIsBlocked then
                                                    g_server:broadcastEvent( AIVehicleIsBlockedEvent.new( self , true ), true , nil , self )
                                                elseif not isBlocked and spec.lastIsBlocked then
                                                        g_server:broadcastEvent( AIVehicleIsBlockedEvent.new( self , false ), true , nil , self )
                                                    end

                                                    spec.lastIsBlocked = isBlocked

                                                    SpecializationUtil.raiseEvent( self , "onAIDriveableActive" )
                                                end
                                            end
                                        end

```

### postInitSpecialization

**Description**

**Definition**

> postInitSpecialization()

**Code**

```lua
function AIDrivable.postInitSpecialization()
    local schema = Vehicle.xmlSchema

    for name, configDesc in pairs(g_vehicleConfigurationManager:getConfigurations()) do
        local configurationKey = configDesc.configurationKey .. "(?)"
        schema:setXMLSharedRegistration( "configAIAgent" , configurationKey)
        AIDrivable.registerAgentXMLPaths(schema, configurationKey .. ".aiAgent" )
        schema:resetXMLSharedRegistration( "configAIAgent" , configurationKey)
    end
end

```

### prepareForAIDriving

**Description**

**Definition**

> prepareForAIDriving()

**Code**

```lua
function AIDrivable:prepareForAIDriving()
    self:raiseAIEvent( "onAIDrivablePrepare" , "onAIImplementPrepareForTransport" )
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
function AIDrivable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AIVehicle , specializations) and
    SpecializationUtil.hasSpecialization( AIJobVehicle , specializations) and
    SpecializationUtil.hasSpecialization( Drivable , specializations)
end

```

### reachedAITarget

**Description**

**Definition**

> reachedAITarget()

**Code**

```lua
function AIDrivable:reachedAITarget()
    local spec = self.spec_aiDrivable
    if self.isServer then
        local lastTask = spec.task
        if lastTask ~ = nil then
            lastTask:onTargetReached()
        end
    end
end

```

### registerAgentXMLPaths

**Description**

**Definition**

> registerAgentXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AIDrivable.registerAgentXMLPaths(schema, basePath)
    schema:register(XMLValueType.FLOAT, basePath .. "#width" , "AI vehicle width" )
    schema:register(XMLValueType.FLOAT, basePath .. "#length" , "AI vehicle length" )
    schema:register(XMLValueType.FLOAT, basePath .. "#lengthOffset" , "AI vehicle length offset" )
    schema:register(XMLValueType.FLOAT, basePath .. "#height" , "AI vehicle height" )
    schema:register(XMLValueType.FLOAT, basePath .. "#frontOffset" , "AI vehicle front offset" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#frontWheelIndices" , "List of wheels(indices) that are used for steering" )
        schema:register(XMLValueType.NODE_INDICES, basePath .. "#frontWheelNodes" , "List of wheels(nodes) that are used for steering" )
            schema:register(XMLValueType.FLOAT, basePath .. "#maxBrakeAcceleration" , "AI vehicle max brake acceleration" )
            schema:register(XMLValueType.FLOAT, basePath .. "#maxCentripetalAcceleration" , "AI vehicle max centripetal acceleration" )
            schema:register(XMLValueType.FLOAT, basePath .. "#maxTurningRadius" , "Max.turning radius(overwrites value detected from ackermann steering)" )
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
function AIDrivable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AIDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AIDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AIDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , AIDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , AIDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onCruiseControlSpeedChanged" , AIDrivable )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIDrivable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onAIDrivablePrepare" )
    SpecializationUtil.registerEvent(vehicleType, "onAIDriveableStart" )
    SpecializationUtil.registerEvent(vehicleType, "onAIDriveableActive" )
    SpecializationUtil.registerEvent(vehicleType, "onAIDriveableEnd" )
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
function AIDrivable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "consoleCommandSetTurnRadius" , AIDrivable.consoleCommandSetTurnRadius)
    SpecializationUtil.registerFunction(vehicleType, "consoleCommandMove" , AIDrivable.consoleCommandMove)
    SpecializationUtil.registerFunction(vehicleType, "consoleCommandClearPath" , AIDrivable.consoleCommandClearPath)
    SpecializationUtil.registerFunction(vehicleType, "createAgent" , AIDrivable.createAgent)
    SpecializationUtil.registerFunction(vehicleType, "deleteAgent" , AIDrivable.deleteAgent)
    SpecializationUtil.registerFunction(vehicleType, "setAITarget" , AIDrivable.setAITarget)
    SpecializationUtil.registerFunction(vehicleType, "unsetAITarget" , AIDrivable.unsetAITarget)
    SpecializationUtil.registerFunction(vehicleType, "stopAIDriving" , AIDrivable.stopAIDriving)
    SpecializationUtil.registerFunction(vehicleType, "reachedAITarget" , AIDrivable.reachedAITarget)
    SpecializationUtil.registerFunction(vehicleType, "getAIRootNode" , AIDrivable.getAIRootNode)
    SpecializationUtil.registerFunction(vehicleType, "setAIRootNodeDirty" , AIDrivable.setAIRootNodeDirty)
    SpecializationUtil.registerFunction(vehicleType, "getAIRootNodeMinZOffset" , AIDrivable.getAIRootNodeMinZOffset)
    SpecializationUtil.registerFunction(vehicleType, "getAIRootNodeMaxZOffset" , AIDrivable.getAIRootNodeMaxZOffset)
    SpecializationUtil.registerFunction(vehicleType, "getAIRootNodeBoundingBox" , AIDrivable.getAIRootNodeBoundingBox)
    SpecializationUtil.registerFunction(vehicleType, "getAIAllowsBackwards" , AIDrivable.getAIAllowsBackwards)
    SpecializationUtil.registerFunction(vehicleType, "drawDebugAIAgent" , AIDrivable.drawDebugAIAgent)
    SpecializationUtil.registerFunction(vehicleType, "debugGetAgentHasSpaceAt" , AIDrivable.debugGetAgentHasSpaceAt)
    SpecializationUtil.registerFunction(vehicleType, "loadAgentInfoFromXML" , AIDrivable.loadAgentInfoFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getAIAgentSize" , AIDrivable.getAIAgentSize)
    SpecializationUtil.registerFunction(vehicleType, "getAIAgentMaxBrakeAcceleration" , AIDrivable.getAIAgentMaxBrakeAcceleration)
    SpecializationUtil.registerFunction(vehicleType, "updateAIAgentAttachments" , AIDrivable.updateAIAgentAttachments)
    SpecializationUtil.registerFunction(vehicleType, "addAIAgentAttachment" , AIDrivable.addAIAgentAttachment)
    SpecializationUtil.registerFunction(vehicleType, "startNewAIAgentAttachmentChain" , AIDrivable.startNewAIAgentAttachmentChain)
    SpecializationUtil.registerFunction(vehicleType, "updateAIAgentAttachmentOffsetData" , AIDrivable.updateAIAgentAttachmentOffsetData)
    SpecializationUtil.registerFunction(vehicleType, "updateAIAgentPoseData" , AIDrivable.updateAIAgentPoseData)
    SpecializationUtil.registerFunction(vehicleType, "prepareForAIDriving" , AIDrivable.prepareForAIDriving)
    SpecializationUtil.registerFunction(vehicleType, "getAITurningRadius" , AIDrivable.getAITurningRadius)
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
function AIDrivable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartAIVehicle" , AIDrivable.getCanStartAIVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIJobSupported" , AIDrivable.getIsAIJobSupported)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanHaveAIVehicleObstacle" , AIDrivable.getCanHaveAIVehicleObstacle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIReadyToDrive" , AIDrivable.getIsAIReadyToDrive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIPreparingToDrive" , AIDrivable.getIsAIPreparingToDrive)
end

```

### setAIRootNodeDirty

**Description**

**Definition**

> setAIRootNodeDirty()

**Code**

```lua
function AIDrivable:setAIRootNodeDirty()
    local spec = self.spec_aiDrivable

    local aiRootNode = self:getAIRootNode()

    local xOffsetPosX, xOffsetPosY, xOffsetPosZ = localToWorld( self.rootNode, self.size.widthOffset + self.size.width * 0.5 , 0 , 0 )
    local xOffsetNegX, xOffsetNegY, xOffsetNegZ = localToWorld( self.rootNode, self.size.widthOffset - self.size.width * 0.5 , 0 , 0 )
    local yOffsetPosX, yOffsetPosY, yOffsetPosZ = localToWorld( self.rootNode, 0 , self.size.heightOffset + self.size.height, 0 )
    local yOffsetNegX, yOffsetNegY, yOffsetNegZ = localToWorld( self.rootNode, 0 , self.size.heightOffset, 0 )
    local zOffsetPosX, zOffsetPosY, zOffsetPosZ = localToWorld( self.rootNode, 0 , 0 , self.size.lengthOffset + self.size.length * 0.5 )
    local zOffsetNegX, zOffsetNegY, zOffsetNegZ = localToWorld( self.rootNode, 0 , 0 , self.size.lengthOffset - self.size.length * 0.5 )

    local xOffset1, yOffset1, zOffset1 = worldToLocal(aiRootNode, xOffsetPosX, xOffsetPosY, xOffsetPosZ)
    local xOffset2, yOffset2, zOffset2 = worldToLocal(aiRootNode, xOffsetNegX, xOffsetNegY, xOffsetNegZ)
    local xOffset3, yOffset3, zOffset3 = worldToLocal(aiRootNode, yOffsetPosX, yOffsetPosY, yOffsetPosZ)
    local xOffset4, yOffset4, zOffset4 = worldToLocal(aiRootNode, yOffsetNegX, yOffsetNegY, yOffsetNegZ)
    local xOffset5, yOffset5, zOffset5 = worldToLocal(aiRootNode, zOffsetPosX, zOffsetPosY, zOffsetPosZ)
    local xOffset6, yOffset6, zOffset6 = worldToLocal(aiRootNode, zOffsetNegX, zOffsetNegY, zOffsetNegZ)

    local minXOffset = math.min(xOffset1, xOffset2, xOffset3, xOffset4, xOffset5, xOffset6)
    local maxXOffset = math.max(xOffset1, xOffset2, xOffset3, xOffset4, xOffset5, xOffset6)
    local minYOffset = math.min(yOffset1, yOffset2, yOffset3, yOffset4, yOffset5, yOffset6)
    local maxYOffset = math.max(yOffset1, yOffset2, yOffset3, yOffset4, yOffset5, yOffset6)
    local minZOffset = math.min(zOffset1, zOffset2, zOffset3, zOffset4, zOffset5, zOffset6)
    local maxZOffset = math.max(zOffset1, zOffset2, zOffset3, zOffset4, zOffset5, zOffset6)

    spec.aiRootNodeBoundingBox[ 1 ] = minXOffset
    spec.aiRootNodeBoundingBox[ 2 ] = maxXOffset
    spec.aiRootNodeBoundingBox[ 3 ] = minYOffset
    spec.aiRootNodeBoundingBox[ 4 ] = maxYOffset
    spec.aiRootNodeBoundingBox[ 5 ] = minZOffset
    spec.aiRootNodeBoundingBox[ 6 ] = maxZOffset
end

```

### setAITarget

**Description**

**Definition**

> setAITarget()

**Arguments**

| any | task             |
|-----|------------------|
| any | x                |
| any | y                |
| any | z                |
| any | dirX             |
| any | dirY             |
| any | dirZ             |
| any | maxSpeed         |
| any | useManualDriving |

**Code**

```lua
function AIDrivable:setAITarget(task, x, y, z, dirX, dirY, dirZ, maxSpeed, useManualDriving)
    local spec = self.spec_aiDrivable

    local aiRootNode = self:getAIRootNode()
    local cx, cy, cz = getWorldTranslation(aiRootNode)
    local cDirX, cDirY, cDirZ = localDirectionToWorld(aiRootNode, 0 , 0 , 1 )

    spec.useManualDriving = Utils.getNoNil(useManualDriving, false )

    spec.isRunning = true
    spec.task = task
    spec.maxSpeed = maxSpeed or math.huge
    spec.targetX, spec.targetY, spec.targetZ = x, y, z
    spec.targetDirX, spec.targetDirY, spec.targetDirZ = dirX or 0 , dirY, dirZ or 0
    spec.distanceToTarget = MathUtil.vector2Length(cx - x, cz - z)

    spec.lastNoSpaceAtStart, spec.lastNoSpaceAtTarget = false , false

    if not spec.useManualDriving and self.isServer then
        --#debug -- remove existing elements
        --#debug g_debugManager:removeGroup("AIAgentHasSpace")
        --#debug
        --#debug if not self:debugGetAgentHasSpaceAt(x, y, z, dirX, dirY, dirZ, "target") then
            --#debug Logging.devWarning("%s No space for AI agent at target location %.2f %.2f %.2f", self.configFileName, x,y,z)
                --#debug spec.lastNoSpaceAtTarget = true
                --#debug end

                --#debug local wx,wy,wz = getWorldTranslation(self.components[1].node)
                --#debug local dx, dy, dz = localDirectionToWorld(self.components[1].node, 0, 0, 1)
                --#debug if not self:debugGetAgentHasSpaceAt(wx,wy,wz, dx, dy, dz, "start") then
                    --#debug Logging.devWarning("%s No space for AI agent at start location %.2f %.2f %.2f", self.configFileName, wx,wy,wz)
                        --#debug spec.lastNoSpaceAtStart = true
                        --#debug end

                        setVehicleNavigationAgentTarget(spec.agentId, x, y, z, dirX, dirY, dirZ)
                    end

                    if spec.debugVehicle ~ = nil then
                        spec.debugVehicle:setTarget(x, y, z, dirX, dirY, dirZ)
                    end

                    if spec.debugDump ~ = nil then
                        if not useManualDriving then
                            spec.debugDump:stopPlanningRecording()
                            spec.debugDump:startPlanningRecording()
                        else
                                spec.debugDump:stopPlanningRecording()
                            end

                            spec.debugDump:setTarget(x, y, z, dirX, dirY, dirZ, cx, cy, cz, cDirX, cDirY, cDirZ, spec.maxSpeed)
                        end

                        SpecializationUtil.raiseEvent( self , "onAIDriveableStart" )
                    end

```

### startNewAIAgentAttachmentChain

**Description**

**Definition**

> startNewAIAgentAttachmentChain()

**Code**

```lua
function AIDrivable:startNewAIAgentAttachmentChain()
    local spec = self.spec_aiDrivable
    if spec.attachmentChains[spec.attachmentChainIndex] ~ = nil then
        spec.attachmentChainIndex = spec.attachmentChainIndex + 1
    end
end

```

### unsetAITarget

**Description**

**Definition**

> unsetAITarget()

**Code**

```lua
function AIDrivable:unsetAITarget()
    local spec = self.spec_aiDrivable
    spec.isRunning = false
    spec.task = nil
    spec.useManualDriving = false

    self:stopAIDriving()

    SpecializationUtil.raiseEvent( self , "onAIDriveableEnd" )
end

```

### updateAIAgentAttachmentOffsetData

**Description**

**Definition**

> updateAIAgentAttachmentOffsetData()

**Code**

```lua
function AIDrivable:updateAIAgentAttachmentOffsetData()
    local spec = self.spec_aiDrivable

    if not spec.agentInfo.isValid then
        return
    end

    local _, agentLength, _, _ = self:getAIAgentSize()
    local numTrailers = 0
    for ci = 1 , #spec.attachmentChains do
        local chainAttachments = spec.attachmentChains[ci]
        local isDynamicChain = true
        local isStaticChain = true

        local parentSteeringCenterNode = self:getAIRootNode()
        for i = 1 , #chainAttachments do
            local agentAttachment = chainAttachments[i]
            if agentAttachment.rotCenterNode ~ = nil and isDynamicChain then
                if numTrailers < AIDrivable.TRAILER_LIMIT then
                    local jointNode = agentAttachment.jointNode or agentAttachment.jointNodeDynamic
                    local attacherVehicleJointNode = agentAttachment.attacherVehicleJointNode or jointNode
                    if attacherVehicleJointNode ~ = nil and jointNode ~ = nil then
                        local _, _, tractorHitchOffset = localToLocal(attacherVehicleJointNode, parentSteeringCenterNode, 0 , 0 , 0 )

                        local trailerHitchOffset
                        if agentAttachment.jointNodeToHitchOffset ~ = nil then
                            trailerHitchOffset = agentAttachment.jointNodeToHitchOffset[jointNode]
                        else
                                trailerHitchOffset = agentAttachment.trailerHitchOffset
                            end

                            if trailerHitchOffset ~ = nil then
                                local centerOffset = agentAttachment.lengthOffset + (agentLength * 0.5 ) - (agentAttachment.length * 0.5 )
                                local hasCollision = agentAttachment.hasCollision and 1 or 0

                                table.insert(spec.attachmentsTrailerOffsetData, tractorHitchOffset)
                                table.insert(spec.attachmentsTrailerOffsetData, trailerHitchOffset)
                                table.insert(spec.attachmentsTrailerOffsetData, centerOffset)
                                table.insert(spec.attachmentsTrailerOffsetData, hasCollision)

                                parentSteeringCenterNode = agentAttachment.rotCenterNode
                                numTrailers = numTrailers + 1
                            end
                        end
                        isStaticChain = false
                    end
                elseif isStaticChain then
                        if numTrailers > 0 then
                            isDynamicChain = false
                        end

                        if agentAttachment.rotCenterNode = = nil then
                            local aiRootNode = self:getAIRootNode()
                            local _, _, z1 = localToLocal(agentAttachment.rootNode, aiRootNode, 0 , 0 , agentAttachment.length * 0.5 )
                            local _, _, z2 = localToLocal(agentAttachment.rootNode, aiRootNode, 0 , 0 , - agentAttachment.length * 0.5 )

                            local minZ = - spec.agentInfo.length * 0.5 + spec.agentInfo.lengthOffset
                            local maxZ = spec.agentInfo.length * 0.5 + spec.agentInfo.lengthOffset
                            local zDiffNeg = math.min( 0 , z1 - minZ, z2 - minZ)
                            local zDiffPos = math.max( 0 , z1 - maxZ, z2 - maxZ)

                            spec.attachmentsMaxLengthOffsetPos = math.max(spec.attachmentsMaxLengthOffsetPos, zDiffPos)
                            spec.attachmentsMaxLengthOffsetNeg = math.min(spec.attachmentsMaxLengthOffsetNeg, zDiffNeg)
                        end
                    end
                end
            end
        end

```

### updateAIAgentAttachments

**Description**

**Definition**

> updateAIAgentAttachments()

**Code**

```lua
function AIDrivable:updateAIAgentAttachments()
    local spec = self.spec_aiDrivable

    spec.attachments = { }
    spec.attachmentChains = { }
    spec.attachmentChainIndex = 1
    spec.attachmentsTrailerOffsetData = { }
    spec.attachmentsMaxWidth = 0
    spec.attachmentsMaxHeight = 0

    spec.attachmentsMaxLengthOffsetPos = 0
    spec.attachmentsMaxLengthOffsetNeg = 0

    self:collectAIAgentAttachments( self )
    self:updateAIAgentAttachmentOffsetData()
    self:updateAIAgentPoseData()
end

```

### updateAIAgentPoseData

**Description**

**Definition**

> updateAIAgentPoseData()

**Code**

```lua
function AIDrivable:updateAIAgentPoseData()
    local spec = self.spec_aiDrivable

    local aiRootNode = self:getAIRootNode()

    spec.poseData[ 1 ], spec.poseData[ 2 ], spec.poseData[ 3 ] = getWorldTranslation(aiRootNode)
    spec.poseData[ 4 ], spec.poseData[ 5 ], spec.poseData[ 6 ] = localDirectionToWorld(aiRootNode, 0 , 0 , 1 )

    local numTrailers = 0
    local currentIndex = 6

    for ci = 1 , #spec.attachmentChains do
        local chainAttachments = spec.attachmentChains[ci]
        local isDynamicChain = true

        for i = 1 , #chainAttachments do
            local agentAttachment = chainAttachments[i]
            if agentAttachment.rotCenterNode ~ = nil and isDynamicChain then
                if numTrailers < AIDrivable.TRAILER_LIMIT then
                    spec.poseData[currentIndex + 1 ], spec.poseData[currentIndex + 2 ], spec.poseData[currentIndex + 3 ] = getWorldTranslation(agentAttachment.rotCenterNode)
                    spec.poseData[currentIndex + 4 ], spec.poseData[currentIndex + 5 ], spec.poseData[currentIndex + 6 ] = localDirectionToWorld(agentAttachment.rotCenterNode, 0 , 0 , 1 )

                    numTrailers = numTrailers + 1
                    currentIndex = currentIndex + 6
                end
            else
                    if numTrailers > 0 then
                        isDynamicChain = false
                    end
                end
            end
        end

        while #spec.poseData > currentIndex do
            table.remove(spec.poseData, #spec.poseData)
        end
    end

```