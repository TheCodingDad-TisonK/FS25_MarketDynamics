## AIVehicle

**Description**

> Specialization for AI basics which are used on all vehicles

**Functions**

- [collectAIAgentAttachments](#collectaiagentattachments)
- [drawAIAgentAttachments](#drawaiagentattachments)
- [getIsAIPreparingToDrive](#getisaipreparingtodrive)
- [getIsAIReadyToDrive](#getisaireadytodrive)
- [initSpecialization](#initspecialization)
- [loadAIAgentAttachmentsFromXML](#loadaiagentattachmentsfromxml)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [prerequisitesPresent](#prerequisitespresent)
- [raiseAIEvent](#raiseaievent)
- [registerAgentAttachmentPaths](#registeragentattachmentpaths)
- [registerAIAgentAttachment](#registeraiagentattachment)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [safeRaiseAIEvent](#saferaiseaievent)
- [validateAIAgentAttachments](#validateaiagentattachments)

### collectAIAgentAttachments

**Description**

**Definition**

> collectAIAgentAttachments()

**Arguments**

| any | aiDrivableVehicle |
|-----|-------------------|

**Code**

```lua
function AIVehicle:collectAIAgentAttachments(aiDrivableVehicle)
    local spec = self.spec_aiVehicle

    if #spec.agentAttachments > 0 then
        local inputAttacherJointDesc = self:getActiveInputAttacherJoint()
        if inputAttacherJointDesc ~ = nil then
            local jointDesc = self:getAttacherVehicle():getAttacherJointDescFromObject( self )

            local usedExplicitAttachment = false
            for i = 1 , #spec.agentAttachments do
                local agentAttachment = spec.agentAttachments[i]
                if agentAttachment.jointNode = = inputAttacherJointDesc.node then
                    agentAttachment.attacherVehicleJointNode = jointDesc.jointTransform
                    self:registerAIAgentAttachment(aiDrivableVehicle, agentAttachment)
                    usedExplicitAttachment = true
                end
            end

            if not usedExplicitAttachment then
                for i = 1 , #spec.agentAttachments do
                    local agentAttachment = spec.agentAttachments[i]
                    if agentAttachment.isDirectAttachment then
                        agentAttachment.attacherVehicleJointNode = jointDesc.jointTransform
                        agentAttachment.jointNodeDynamic = inputAttacherJointDesc.node
                        self:registerAIAgentAttachment(aiDrivableVehicle, agentAttachment)
                        break
                    end
                end
            end

            for i = 1 , #spec.agentAttachments do
                local agentAttachment = spec.agentAttachments[i]
                if not agentAttachment.isDirectAttachment then
                    self:registerAIAgentAttachment(aiDrivableVehicle, agentAttachment)
                end
            end
        end
    end
end

```

### drawAIAgentAttachments

**Description**

**Definition**

> drawAIAgentAttachments()

**Arguments**

| any | agentAttachments |
|-----|------------------|

**Code**

```lua
function AIVehicle:drawAIAgentAttachments(agentAttachments)
    local spec = self.spec_aiVehicle
    agentAttachments = agentAttachments or spec.agentAttachments
    for i = 1 , #agentAttachments do
        local agentAttachment = agentAttachments[i]
        if agentAttachment.rotCenterNode ~ = nil then
            spec.debugSizeBox:setColorRGBA( 0 , 1 , 0.25 )
            spec.debugSizeBox:createWithNode(agentAttachment.rotCenterNode, agentAttachment.width, agentAttachment.height, agentAttachment.length, 0 , agentAttachment.height * 0.5 + agentAttachment.heightOffset, agentAttachment.lengthOffset)
            spec.debugSizeBox:draw()
        else
                spec.debugSizeBox:setColorRGBA( 0 , 0.15 , 1 )
                spec.debugSizeBox:createWithNode(agentAttachment.rootNode, agentAttachment.width, agentAttachment.height, agentAttachment.length, 0 , agentAttachment.height * 0.5 + agentAttachment.heightOffset, agentAttachment.lengthOffset)
                spec.debugSizeBox:draw()
            end

            self:drawAIAgentAttachments(agentAttachment.agentAttachments)
        end
    end

```

### getIsAIPreparingToDrive

**Description**

**Definition**

> getIsAIPreparingToDrive()

**Code**

```lua
function AIVehicle:getIsAIPreparingToDrive()
    return false
end

```

### getIsAIReadyToDrive

**Description**

**Definition**

> getIsAIReadyToDrive()

**Code**

```lua
function AIVehicle:getIsAIReadyToDrive()
    return true
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AIVehicle.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AIVehicle" )

    AIVehicle.registerAgentAttachmentPaths(schema, "vehicle.ai" , true )

    schema:setXMLSpecializationType()
end

```

### loadAIAgentAttachmentsFromXML

**Description**

**Definition**

> loadAIAgentAttachmentsFromXML()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | baseKey            |
| any | agentAttachments   |
| any | loadSubAttachments |
| any | requiresJointNode  |

**Code**

```lua
function AIVehicle:loadAIAgentAttachmentsFromXML(xmlFile, baseKey, agentAttachments, loadSubAttachments, requiresJointNode)
    xmlFile:iterate(baseKey, function (index, key)
        local agentAttachment = { }
        agentAttachment.jointNode = xmlFile:getValue(key .. "#jointNode" , nil , self.components, self.i3dMappings)
        agentAttachment.jointNodeDynamic = nil

        agentAttachment.rotCenterNode = xmlFile:getValue(key .. "#rotCenterNode" , nil , self.components, self.i3dMappings)
        agentAttachment.rotCenterWheelIndices = xmlFile:getValue(key .. "#rotCenterWheelIndices" , nil , true )
        agentAttachment.rotCenterPosition = xmlFile:getValue(key .. "#rotCenterPosition" , nil , true )

        agentAttachment.useSize = xmlFile:getValue(key .. "#useSize" , false )

        if agentAttachment.useSize then
            agentAttachment.width = self.size.width
            agentAttachment.height = self.size.height
            agentAttachment.heightOffset = self.size.heightOffset
            agentAttachment.length = self.size.length
            agentAttachment.lengthOffset = self.size.lengthOffset
        else
                agentAttachment.width = 3
                agentAttachment.height = 3
                agentAttachment.heightOffset = 0
                agentAttachment.length = 3
                agentAttachment.lengthOffset = 0
            end

            agentAttachment.width = xmlFile:getValue(key .. "#width" , agentAttachment.width)
            agentAttachment.height = xmlFile:getValue(key .. "#height" , agentAttachment.height)
            agentAttachment.heightOffset = xmlFile:getValue(key .. "#heightOffset" , agentAttachment.heightOffset)
            agentAttachment.length = xmlFile:getValue(key .. "#length" , agentAttachment.length)
            agentAttachment.lengthOffset = xmlFile:getValue(key .. "#lengthOffset" , agentAttachment.lengthOffset)

            agentAttachment.hasCollision = xmlFile:getValue(key .. "#hasCollision" , true )

            agentAttachment.isDirectAttachment = false -- direct attachments are directly bound to the input attacher joint - non direct is e.g.another component with open Y rot limit

            agentAttachment.agentAttachments = { }
            if loadSubAttachments ~ = false then
                self:loadAIAgentAttachmentsFromXML(xmlFile, key .. ".agentAttachment" , agentAttachment.agentAttachments, false , true )
            end

            if requiresJointNode = = true then
                if agentAttachment.jointNode = = nil then
                    Logging.xmlWarning(xmlFile, "No joint node defined for ai agent sub attachable '%s'!" , key)
                        return
                    end
                end

                table.insert(agentAttachments, agentAttachment)
            end )

            if loadSubAttachments = = nil and #agentAttachments = = 0 then
                Logging.xmlWarning(xmlFile, "Missing ai agent attachment definition for attachable vehicle" )
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
function AIVehicle:onLoad(savegame)
    local spec = self.spec_aiVehicle

    local baseName = "vehicle.ai"

    spec.agentAttachments = { }
    if self.getInputAttacherJoints ~ = nil then
        self:loadAIAgentAttachmentsFromXML( self.xmlFile, baseName .. ".agentAttachment" , spec.agentAttachments)
    end

    spec.debugSizeBox = DebugBox.new()
    spec.debugSizeBox:setColorRGBA( 0 , 1 , 1 )
    spec.debugSizeBox:setText( "aiAgentAttachment" )
end

```

### onPostLoad

**Description**

> Called on after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function AIVehicle:onPostLoad(savegame)
    local spec = self.spec_aiVehicle
    if #spec.agentAttachments > 0 then
        local inputAttacherJoints = self:getInputAttacherJoints()
        self:validateAIAgentAttachments(spec.agentAttachments, inputAttacherJoints)
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
function AIVehicle.prerequisitesPresent(specializations)
    return true
end

```

### raiseAIEvent

**Description**

**Definition**

> raiseAIEvent()

**Arguments**

| any | eventName     |
|-----|---------------|
| any | implementName |
| any | ...           |

**Code**

```lua
function AIVehicle:raiseAIEvent(eventName, implementName, .. .)
    local actionController = self.rootVehicle.actionController
    for _, vehicle in ipairs( self.rootVehicle.childVehicles) do
        if vehicle ~ = self then
            self:safeRaiseAIEvent(vehicle, implementName, .. .)

            if actionController ~ = nil then
                actionController:onAIEvent(vehicle, implementName)
            end
        end
    end

    self:safeRaiseAIEvent( self , implementName, .. .)
    if actionController ~ = nil then
        actionController:onAIEvent( self , implementName)
    end

    self:safeRaiseAIEvent( self , eventName, .. .)
    if actionController ~ = nil then
        actionController:onAIEvent( self , eventName)
    end
end

```

### registerAgentAttachmentPaths

**Description**

**Definition**

> registerAgentAttachmentPaths()

**Arguments**

| any | schema                |
|-----|-----------------------|
| any | basePath              |
| any | includeSubAttachments |

**Code**

```lua
function AIVehicle.registerAgentAttachmentPaths(schema, basePath, includeSubAttachments)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".agentAttachment(?)#jointNode" , "Custom joint node(if not defined the current attacher joint is used)" )

        schema:register(XMLValueType.VECTOR_N, basePath .. ".agentAttachment(?)#rotCenterWheelIndices" , "The center of these wheel indices define the steering center" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".agentAttachment(?)#rotCenterNode" , "Custom node to define the steering center" )
        schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".agentAttachment(?)#rotCenterPosition" , "Offset from root component that defines the steering center" )

        schema:register(XMLValueType.FLOAT, basePath .. ".agentAttachment(?)#width" , "Agent attachable width" , 3 )
        schema:register(XMLValueType.FLOAT, basePath .. ".agentAttachment(?)#height" , "Agent attachable height" , 3 )
        schema:register(XMLValueType.FLOAT, basePath .. ".agentAttachment(?)#heightOffset" , "Agent attachable height offset(only for visual debug)" , 0 )
            schema:register(XMLValueType.FLOAT, basePath .. ".agentAttachment(?)#length" , "Agent attachable length" , 3 )
            schema:register(XMLValueType.FLOAT, basePath .. ".agentAttachment(?)#lengthOffset" , "Agent attachable length offset from rot center" , 0 )

            schema:register(XMLValueType.BOOL, basePath .. ".agentAttachment(?)#hasCollision" , "Agent attachable is doing collision checks" , true )

            schema:register(XMLValueType.BOOL, basePath .. ".agentAttachment(?)#useSize" , "Use the vehicle size definition for the agentAttachment size as well(for static tools)" , false )

                if includeSubAttachments then
                    AIVehicle.registerAgentAttachmentPaths(schema, basePath .. ".agentAttachment(?)" , false )
                end
            end

```

### registerAIAgentAttachment

**Description**

**Definition**

> registerAIAgentAttachment()

**Arguments**

| any | aiDrivableVehicle |
|-----|-------------------|
| any | agentAttachment   |

**Code**

```lua
function AIVehicle:registerAIAgentAttachment(aiDrivableVehicle, agentAttachment)
    aiDrivableVehicle:addAIAgentAttachment(agentAttachment)

    for i = 1 , #agentAttachment.agentAttachments do
        local subAgentAttachment = agentAttachment.agentAttachments[i]
        aiDrivableVehicle:addAIAgentAttachment(subAgentAttachment)
    end
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
function AIVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AIVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AIVehicle )
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
function AIVehicle.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onAIFieldCourseSettingsInitialized" )
    SpecializationUtil.registerEvent(vehicleType, "onPostAIFieldCourseSettingsInitialized" )
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
function AIVehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "collectAIAgentAttachments" , AIVehicle.collectAIAgentAttachments)
    SpecializationUtil.registerFunction(vehicleType, "registerAIAgentAttachment" , AIVehicle.registerAIAgentAttachment)
    SpecializationUtil.registerFunction(vehicleType, "loadAIAgentAttachmentsFromXML" , AIVehicle.loadAIAgentAttachmentsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "validateAIAgentAttachments" , AIVehicle.validateAIAgentAttachments)
    SpecializationUtil.registerFunction(vehicleType, "drawAIAgentAttachments" , AIVehicle.drawAIAgentAttachments)

    SpecializationUtil.registerFunction(vehicleType, "raiseAIEvent" , AIVehicle.raiseAIEvent)
    SpecializationUtil.registerFunction(vehicleType, "safeRaiseAIEvent" , AIVehicle.safeRaiseAIEvent)
    SpecializationUtil.registerFunction(vehicleType, "getIsAIReadyToDrive" , AIVehicle.getIsAIReadyToDrive)
    SpecializationUtil.registerFunction(vehicleType, "getIsAIPreparingToDrive" , AIVehicle.getIsAIPreparingToDrive)
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
function AIVehicle.registerOverwrittenFunctions(vehicleType)
end

```

### safeRaiseAIEvent

**Description**

**Definition**

> safeRaiseAIEvent()

**Arguments**

| any | vehicle   |
|-----|-----------|
| any | eventName |
| any | ...       |

**Code**

```lua
function AIVehicle:safeRaiseAIEvent(vehicle, eventName, .. .)
    if vehicle.eventListeners[eventName] ~ = nil then
        SpecializationUtil.raiseEvent(vehicle, eventName, .. .)
    end
end

```

### validateAIAgentAttachments

**Description**

**Definition**

> validateAIAgentAttachments()

**Arguments**

| any | agentAttachments    |
|-----|---------------------|
| any | inputAttacherJoints |

**Code**

```lua
function AIVehicle:validateAIAgentAttachments(agentAttachments, inputAttacherJoints)
    for i = 1 , #agentAttachments do
        local agentAttachment = agentAttachments[i]

        for j = 1 , #inputAttacherJoints do
            if agentAttachment.jointNode = = nil or agentAttachment.jointNode = = inputAttacherJoints[j].node then
                agentAttachment.isDirectAttachment = true
            end
        end

        if agentAttachment.rotCenterNode = = nil then
            if agentAttachment.rotCenterPosition ~ = nil and #agentAttachment.rotCenterPosition = = 2 then
                local rotCenterNode = createTransformGroup( "aiAgentAttachmentRotCenter" .. i)
                link( self.components[ 1 ].node, rotCenterNode)
                setTranslation(rotCenterNode, agentAttachment.rotCenterPosition[ 1 ], 0 , agentAttachment.rotCenterPosition[ 2 ])
                agentAttachment.rotCenterNode = rotCenterNode
            elseif agentAttachment.rotCenterWheelIndices ~ = nil and #agentAttachment.rotCenterWheelIndices > 0 then
                    if self.getWheels ~ = nil then
                        local wheels = self:getWheels()
                        local x, y, z = 0 , 0 , 0
                        local dirX, dirY, dirZ = 0 , 0 , 0
                        local numWheels = 0
                        local component = nil
                        for j = 1 , #agentAttachment.rotCenterWheelIndices do
                            local wheelIndex = agentAttachment.rotCenterWheelIndices[j]
                            local wheel = wheels[wheelIndex]
                            if wheel ~ = nil then
                                component = component or wheel.node
                                local wx, wy, wz = localToLocal(wheel.repr, component, 0 , - wheel.physics.radius, 0 )
                                local dx, dy, dz = localDirectionToLocal(wheel.driveNode, component, 0 , 0 , 1 )
                                x, y, z = x + wx, y + wy, z + wz
                                dirX, dirY, dirZ = dirX + dx, dirY + dy, dirZ + dz
                                numWheels = numWheels + 1
                            else
                                    Logging.xmlWarning( self.xmlFile, "Unknown wheel index '%d' ground in ai agent attachment entry 'vehicle.ai.agentAttachment(%d)'!" , wheelIndex, i - 1 )
                                end
                            end

                            if numWheels > 0 then
                                x, y, z = x / numWheels, y / numWheels, z / numWheels
                                dirX, dirY, dirZ = dirX / numWheels, dirY / numWheels, dirZ / numWheels
                            end
                            dirX, dirY, dirZ = MathUtil.vector3Normalize(dirX, dirY, dirZ)

                            if agentAttachment.useSize then
                                agentAttachment.lengthOffset = self.size.lengthOffset - z
                            end

                            local rotCenterNode = createTransformGroup( "aiAgentAttachmentRotCenter" .. i)
                            link(component, rotCenterNode)
                            setTranslation(rotCenterNode, x, y, z)
                            agentAttachment.rotCenterNode = rotCenterNode

                            if numWheels > 0 and MathUtil.vector3Length(dirX, dirY, dirZ) > 0 then
                                setDirection(rotCenterNode, dirX, dirY, dirZ, 0 , 1 , 0 )
                            end
                        end
                    end
                end

                if agentAttachment.rotCenterNode = = nil then
                    agentAttachment.rootNode = self.rootNode
                end

                if agentAttachment.rotCenterNode ~ = nil then
                    if agentAttachment.jointNode = = nil then
                        agentAttachment.jointNodeToHitchOffset = { }
                        for j = 1 , #inputAttacherJoints do
                            local _, _, z = localToLocal(inputAttacherJoints[j].node, agentAttachment.rotCenterNode, 0 , 0 , 0 )
                            agentAttachment.jointNodeToHitchOffset[inputAttacherJoints[j].node] = z
                        end
                    else
                            local _
                            _, _, agentAttachment.trailerHitchOffset = localToLocal(agentAttachment.jointNode, agentAttachment.rotCenterNode, 0 , 0 , 0 )
                        end
                    end

                    self:validateAIAgentAttachments(agentAttachment.agentAttachments, inputAttacherJoints)
                end
            end

```