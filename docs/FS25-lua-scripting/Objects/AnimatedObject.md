## AnimatedObject

**Description**

> Class for animated objects

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [delete](#delete)
- [hourChanged](#hourchanged)
- [load](#load)
- [loadFrameValues](#loadframevalues)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setAnimTime](#setanimtime)
- [setFrameValues](#setframevalues)
- [triggerCallback](#triggercallback)
- [update](#update)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### delete

**Description**

> Delete animated object

**Definition**

> delete()

**Code**

```lua
function AnimatedObject:delete()

    if self.triggerNode ~ = nil then
        removeTrigger( self.triggerNode)
        for i = 0 , getNumOfChildren( self.triggerNode) - 1 do
            removeTrigger(getChildAt( self.triggerNode, i))
        end
        self.triggerNode = nil
    end

    if self.samplesMoving ~ = nil then
        g_soundManager:deleteSamples( self.samplesMoving)
        self.samplesMoving = nil
    end
    if self.samplePosEnd ~ = nil then
        g_soundManager:deleteSample( self.samplePosEnd)
        self.samplePosEnd = nil
    end
    if self.sampleNegEnd ~ = nil then
        g_soundManager:deleteSample( self.sampleNegEnd)
        self.sampleNegEnd = nil
    end

    if self.animation ~ = nil and self.animation.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.animation.sharedLoadRequestId)
        self.animation.sharedLoadRequestId = nil
    end

    if g_currentMission ~ = nil then
        g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
    end

    if g_messageCenter ~ = nil then
        g_messageCenter:unsubscribeAll( self )
    end

    self.isDeleted = true

    AnimatedObject:superClass().delete( self )
end

```

### hourChanged

**Description**

> Called on hour change

**Definition**

> hourChanged()

**Code**

```lua
function AnimatedObject:hourChanged()
    if not self.isServer then
        return
    end

    if g_currentMission = = nil or g_currentMission.environment = = nil then
        return
    end

    if self.openingHours ~ = nil then
        local currentHour = g_currentMission.environment.currentHour

        if currentHour > = self.openingHours.startTime and currentHour < self.openingHours.endTime then
            if not self.openingHours.isOpen then
                if self.isServer then
                    self.animation.direction = 1
                    self:raiseActive()
                end
                self.openingHours.isOpen = true
            end
            if self.openingHours.disableIfClosed then
                self.isEnabled = true
            end
        else
                if self.openingHours.isOpen then
                    if self.isServer then
                        self.animation.direction = - 1
                        self:raiseActive()
                    end
                    self.openingHours.isOpen = false
                end
                if self.openingHours.disableIfClosed then
                    self.isEnabled = false
                end
            end
        end
    end

```

### load

**Description**

> Load animated object from object with given configuration file

**Definition**

> load(entityId|table rootNode, XMLFile xmlFile, string key, string xmlFilename, table? i3dMappings)

**Arguments**

| entityId | table       | rootNode                      | id of object |
|----------|-------------|-------------------------------|--------------|
| XMLFile  | xmlFile     |                               |              |
| string   | key         |                               |              |
| string   | xmlFilename | Path of the xml configuration |              |
| table?   | i3dMappings |                               |              |

**Return Values**

| table? | success | success |
|--------|---------|---------|

**Code**

```lua
function AnimatedObject:load(rootNode, xmlFile, key, xmlFilename, i3dMappings)
    self.xmlFilename = xmlFilename

    local modName, baseDirectory = Utils.getModNameAndBaseDirectory(xmlFilename)
    self.baseDirectory = baseDirectory
    self.customEnvironment = modName

    self.nodeId = rootNode
    if type(rootNode) = = "table" then
        self.nodeId = rootNode[ 1 ].node
    end

    local success = true
    self.saveId = xmlFile:getString(key .. "#saveId" ) or "AnimatedObject_" .. getName( self.nodeId)

    local animKey = key .. ".animation"

    self.animation = { }
    self.animation.parts = { }
    self.animation.shaderAnims = nil
    self.animation.clipRootNode = nil
    self.animation.clipName = nil
    self.animation.clipTrack = nil
    self.animation.duration = xmlFile:getFloat(animKey .. "#duration" )
    self.animation.time = 0
    self.animation.direction = 0
    self.animation.maxTime = 0

    for _, partKey in xmlFile:iterator(animKey .. ".part" ) do
        local node = xmlFile:getNode(partKey .. "#node" , nil , rootNode, i3dMappings)
        if node ~ = nil then
            local checkStaticCol = function (nodeToCheck)
                if getRigidBodyType(nodeToCheck) = = RigidBodyType.STATIC and getHasClassId(nodeToCheck, ClassIds.SHAPE) then -- check for classId as transformGroups can be static as well
                    Logging.xmlWarning(xmlFile, "Animated node %q at %q is a static rigid body, ignoring" , I3DUtil.getNodePath(nodeToCheck, self.nodeId), partKey)
                    return false
                end
                return
            end
            if I3DUtil.iterateRecursively(node, checkStaticCol, true ) = = false then
                continue -- do not add as animated part if check failed
                end

                local part = { }
                part.node = node
                part.frames = { }

                for _, frameKey in xmlFile:iterator(partKey .. ".keyFrame" ) do
                    local keyframe = { self:loadFrameValues(xmlFile, frameKey, node) }
                    keyframe.time = xmlFile:getFloat(frameKey .. "#time" )
                    self.animation.maxTime = math.max(keyframe.time , self.animation.maxTime)

                    table.insert(part.frames, keyframe)
                end

                if #part.frames > 0 then
                    table.insert( self.animation.parts, part)
                end
            end
        end

        for _, shaderKey in xmlFile:iterator(animKey .. ".shader" ) do
            local node = xmlFile:getNode(shaderKey .. "#node" , nil , rootNode, i3dMappings)
            if node ~ = nil then
                local parameterName = xmlFile:getString(shaderKey .. "#parameterName" )
                if parameterName ~ = nil and getHasShaderParameter(node, parameterName) then
                    local shader = { }

                    shader.node = node
                    shader.parameterName = parameterName
                    shader.frames = { }

                    for _, frameKey in xmlFile:iterator(shaderKey .. ".keyFrame" ) do
                        local keyTime = xmlFile:getFloat(frameKey .. "#time" )

                        local shaderValuesStr = xmlFile:getString(frameKey .. "#values" , nil )
                        if shaderValuesStr ~ = nil then
                            local values = string.split(shaderValuesStr, " " )
                            if #values > 4 then
                                Logging.xmlWarning(xmlFile, "More than 4 values(%q) given for shader parameters at %q" , shaderValuesStr, frameKey .. "#values" )
                                end
                                for i = 1 , 4 do -- x,y,z,w
                                    values[i] = tonumber(values[i])
                                end

                                local keyframe = values
                                keyframe.time = keyTime
                                table.insert(shader.frames, keyframe)
                            end
                        end

                        if #shader.frames > 0 then
                            self.animation.shaderAnims = self.animation.shaderAnims or { }
                            table.insert( self.animation.shaderAnims, shader)
                        end
                    end
                end
            end

            -- convert loaded parts to anim curve
            for _, part in ipairs( self.animation.parts) do
                part.animCurve = AnimCurve.new(linearInterpolatorN)

                for _, frame in ipairs(part.frames) do
                    frame.time = frame.time / self.animation.maxTime -- normalize frame timtes 0 .. 1

                    part.animCurve:addKeyframe(frame)
                end

                part.frames = nil
            end

            if self.animation.shaderAnims ~ = nil then
                for _, shader in ipairs( self.animation.shaderAnims) do
                    shader.animCurve = AnimCurve.new(linearInterpolatorN)

                    for _, frame in ipairs(shader.frames) do
                        frame.time = frame.time / self.animation.maxTime -- normalize frame timtes 0 .. 1

                        shader.animCurve:addKeyframe(frame)
                    end

                    shader.frames = nil
                end
            end

            local clipRootNode = xmlFile:getNode(animKey .. ".clip#rootNode" , nil , rootNode, i3dMappings)
            local clipName = xmlFile:getString(animKey .. ".clip#name" )

            if clipRootNode ~ = nil and clipName ~ = nil then
                local clipFilename = xmlFile:getString(animKey .. ".clip#filename" )

                self.animation.clipRootNode = clipRootNode
                self.animation.clipName = clipName
                self.animation.clipTrack = 0

                if clipFilename ~ = nil then
                    clipFilename = Utils.getFilename(clipFilename, self.baseDirectory)
                    self.animation.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(clipFilename, false , false , self.onSharedAnimationFileLoaded, self , nil )
                    self.animation.clipFilename = clipFilename
                else
                        self:applyAnimation()
                    end
                end

                self.rollingGateAnimations = { }
                for _, rollingGateAnimationKey in xmlFile:iterator(animKey .. ".rollingGateAnimation" ) do
                    local rollingGateAnimation = RollingGateAnimation.new()
                    if rollingGateAnimation:load(xmlFile, rollingGateAnimationKey, rootNode, i3dMappings) then
                        if self.rollingGateAnimations = = nil then
                            self.rollingGateAnimations = { }
                        end

                        table.insert( self.rollingGateAnimations, rollingGateAnimation)
                    end
                end

                if self.animation.duration = = nil then
                    self.animation.duration = self.animation.maxTime
                end
                self.animation.duration = self.animation.duration * 1000

                local initialTime = xmlFile:getFloat(animKey .. "#initialTime" , 0 ) * 1000
                local time = 0
                if self.animation.duration ~ = 0 then
                    time = initialTime / self.animation.duration
                end
                self:setAnimTime( time , true )

                local startTime = xmlFile:getFloat(key .. ".openingHours#startTime" )
                local endTime = xmlFile:getFloat(key .. ".openingHours#endTime" )
                if startTime ~ = nil and endTime ~ = nil then
                    local disableIfClosed = xmlFile:getBool(key .. ".openingHours#disableIfClosed" , false )
                    local closedText = xmlFile:getI18NValue(key .. ".openingHours#closedText" , nil , self.customEnvironment)
                    self.openingHours = { startTime = startTime, endTime = endTime, disableIfClosed = disableIfClosed, closedText = closedText }
                    g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.hourChanged, self )
                end

                self.isEnabled = true

                local triggerId = xmlFile:getNode(key .. ".controls#triggerNode" , nil , rootNode, i3dMappings)
                if triggerId ~ = nil then
                    self.triggerNode = triggerId

                    addTrigger( self.triggerNode, "triggerCallback" , self )
                    for i = 0 , getNumOfChildren( self.triggerNode) - 1 do
                        addTrigger(getChildAt( self.triggerNode, i), "triggerCallback" , self )
                    end

                    if InputAction ~ = nil then
                        local posAction = xmlFile:getString(key .. ".controls#posAction" )
                        if posAction ~ = nil then
                            if InputAction[posAction] then
                                self.controls.posAction = posAction

                                local posText = xmlFile:getString(key .. ".controls#posText" )
                                if posText ~ = nil then
                                    if g_i18n:hasText(posText, self.customEnvironment) then
                                        posText = g_i18n:getText(posText, self.customEnvironment)
                                    end
                                    self.controls.posActionText = posText
                                end

                                local negText = xmlFile:getString(key .. ".controls#negText" )
                                if negText ~ = nil then
                                    if g_i18n:hasText(negText, self.customEnvironment) then
                                        negText = g_i18n:getText(negText, self.customEnvironment)
                                    end
                                    self.controls.negActionText = negText
                                end

                                local negAction = xmlFile:getString(key .. ".controls#negAction" )
                                if negAction ~ = nil then
                                    if InputAction[negAction] then
                                        self.controls.negAction = negAction
                                    else
                                            printWarning( "Warning:Negative direction action '" .. negAction .. "' not defined!" )
                                        end
                                    end
                                else
                                        printWarning( "Warning:Positive direction action '" .. posAction .. "' not defined!" )
                                    end
                                end
                            end
                        end

                        if g_client ~ = nil then
                            local soundsKey = key .. ".sounds"
                            self.samplesMoving = g_soundManager:loadSamplesFromXML(xmlFile, soundsKey, "moving" , self.baseDirectory, rootNode, 1 , AudioGroup.ENVIRONMENT, i3dMappings, nil )
                            self.samplePosEnd = g_soundManager:loadSampleFromXML(xmlFile, soundsKey, "posEnd" , self.baseDirectory, rootNode, 1 , AudioGroup.ENVIRONMENT, i3dMappings, nil )
                            self.sampleNegEnd = g_soundManager:loadSampleFromXML(xmlFile, soundsKey, "negEnd" , self.baseDirectory, rootNode, 1 , AudioGroup.ENVIRONMENT, i3dMappings, nil )
                        end

                        self.animatedObjectDirtyFlag = self:getNextDirtyFlag()

                        return success
                    end

```

### loadFrameValues

**Description**

> Load frame values from xml

**Definition**

> loadFrameValues(XMLFile xmlFile, string key, integer node)

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| string  | key     | key              |
| integer | node    | node id          |

**Return Values**

| integer | x          | x translation |
|---------|------------|---------------|
| integer | y          | y translation |
| integer | z          | z translation |
| integer | rx         | x rotation    |
| integer | ry         | y rotation    |
| integer | rz         | z rotation    |
| integer | sx         | x scale       |
| integer | sy         | y scale       |
| integer | sz         | z scale       |
| integer | visibility | visibility    |

**Code**

```lua
function AnimatedObject:loadFrameValues(xmlFile, key, node)
    local rx, ry, rz = xmlFile:getRotation(key .. "#rotation" )
    if rx = = nil then
        rx, ry, rz = getRotation(node)
    end
    local x, y, z = xmlFile:getTranslation(key .. "#translation" )
    if x = = nil then
        x, y, z = getTranslation(node)
    end
    local sx, sy, sz = xmlFile:getScale(key .. "#scale" )
    if sx = = nil then
        sx, sy, sz = getScale(node)
    end
    local isVisible = xmlFile:getBool(key .. "#visibility" , true )

    local visibility = 1
    if not isVisible then
        -- check if node has visibility condition which would interfere with visibility animation
            --#debug local required, prevent = getVisibilityConditionWeatherMask(node)
            --#debug if required ~ = 0 or prevent ~ = 0 then
                --#debug Logging.i3dWarning(node, "animated object has visibility keyframes while node also has visibility conditions applied")
                    --#debug end

                    visibility = 0
                end

                return x, y, z, rx, ry, rz, sx, sy, sz, visibility
            end

```

### loadFromXMLFile

**Description**

> Loading from attributes and nodes

**Definition**

> loadFromXMLFile(XMLFile xmlFile, string key)

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| string  | key     | key              |

**Return Values**

| string | success | success |
|--------|---------|---------|

**Code**

```lua
function AnimatedObject:loadFromXMLFile(xmlFile, key)
    local animTime = xmlFile:getFloat(key .. "#time" )
    if animTime ~ = nil then
        self.animation.direction = xmlFile:getInt(key .. "#direction" , 0 )
        self:setAnimTime(animTime, true )
    end

    AnimatedObject.hourChanged( self )

    return true
end

```

### new

**Description**

> Creating new instance of animated object class

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | is server        |
|---------|----------|------------------|
| boolean | isClient | is client        |
| table?  | customMt | custom metatable |

**Return Values**

| table? | self | new instance of object |
|--------|------|------------------------|

**Code**

```lua
function AnimatedObject.new(isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or AnimatedObject _mt)
    self.nodeId = 0
    self.isMoving = false

    -- input controls fields:
    self.controls = { }
    self.controls.wasPressed = false
    self.controls.posAction = nil
    self.controls.negAction = nil
    self.controls.posText = nil
    self.controls.negText = nil
    self.controls.posActionEventId = nil
    self.controls.negActionEventId = nil

    self.networkTimeInterpolator = InterpolationTime.new( 1.2 )
    self.networkAnimTimeInterpolator = InterpolatorValue.new( 0 )

    self.activatable = AnimatedObjectActivatable.new( self )

    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function AnimatedObject:readStream(streamId, connection)
    AnimatedObject:superClass().readStream( self , streamId, connection)
    if connection:getIsServer() then
        local animTime = streamReadFloat32(streamId)
        self:setAnimTime(animTime, true )
        local direction = streamReadUIntN(streamId, 2 ) - 1
        self.animation.direction = direction

        self.networkAnimTimeInterpolator:setValue(animTime)

        self.networkTimeInterpolator:reset()
    end
end

```

### readUpdateStream

**Description**

> Called on client side on update

**Definition**

> readUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function AnimatedObject:readUpdateStream(streamId, timestamp, connection)
    AnimatedObject:superClass().readUpdateStream( self , streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            self.networkTimeInterpolator:startNewPhaseNetwork()
            local animTime = streamReadFloat32(streamId)
            self.networkAnimTimeInterpolator:setTargetValue(animTime)
            local direction = streamReadUIntN(streamId, 2 ) - 1
            self.animation.direction = direction
        end
    end
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AnimatedObject.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.FLOAT, basePath .. "#time" , "Animated object time" )
    schema:register(XMLValueType.INT, basePath .. "#direction" , "Animated object direction" , 0 )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AnimatedObject.registerXMLPaths(schema, basePath)
    schema:setXMLSharedRegistration( "AnimatedObject" , basePath)

    basePath = basePath .. ".animatedObject(?)"
    schema:register(XMLValueType.STRING, basePath .. "#saveId" , "Save identifier" , "AnimatedObject_[nodeName]" )
    schema:register(XMLValueType.FLOAT, basePath .. ".animation#duration" , "Animation duration(sec.)" , 3 )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".animation.part(?)#node" , "Part node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".animation.part(?).keyFrame(?)#time" , "Key time" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".animation.part(?).keyFrame(?)#rotation" , "Key rotation" , "values read from i3d node" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".animation.part(?).keyFrame(?)#translation" , "Key translation" , "values read from i3d node" )
    schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".animation.part(?).keyFrame(?)#scale" , "Key scale" , "values read from i3d node" )
    schema:register(XMLValueType.BOOL, basePath .. ".animation.part(?).keyFrame(?)#visibility" , "Key visibility" , true )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".animation.shader(?)#node" , "Shader node" )
    schema:register(XMLValueType.STRING, basePath .. ".animation.shader(?)#parameterName" , "Shader parameter name" )
    schema:register(XMLValueType.FLOAT, basePath .. ".animation.shader(?).keyFrame(?)#time" , "Key time" )
    schema:register(XMLValueType.STRING, basePath .. ".animation.shader(?).keyFrame(?)#values" , "Key shader parameter values.Use '-' to force using existing shader parameter value" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".animation.clip#rootNode" , "I3d animation rootnode" )
    schema:register(XMLValueType.STRING, basePath .. ".animation.clip#name" , "I3d animation clipName" )
    schema:register(XMLValueType.STRING, basePath .. ".animation.clip#filename" , "I3d animation external animation" )

    RollingGateAnimation.registerXMLPaths(schema, basePath .. ".animation.rollingGateAnimation(?)" )

    schema:register(XMLValueType.FLOAT, basePath .. ".animation#initialTime" , "Animation time after loading" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. ".openingHours#startTime" , "Start day time" )
    schema:register(XMLValueType.FLOAT, basePath .. ".openingHours#endTime" , "End day time" )
    schema:register(XMLValueType.BOOL, basePath .. ".openingHours#disableIfClosed" , "Disabled if closed" )
        schema:register(XMLValueType.L10N_STRING, basePath .. ".openingHours#closedText" , "Closed text" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".controls#triggerNode" , "Player trigger node" )

        schema:register(XMLValueType.STRING, basePath .. ".controls#posAction" , "Positive direction action event name" )
        schema:registerAutoCompletionDataSource(basePath .. ".controls#posAction" , "$dataS/inputActions.xml" , "actions.action#name" )
        schema:register(XMLValueType.STRING, basePath .. ".controls#posText" , "Positive direction text" )
        schema:register(XMLValueType.STRING, basePath .. ".controls#negText" , "Negative direction text" )
        schema:register(XMLValueType.STRING, basePath .. ".controls#negAction" , "Negative direction action event name" )
        schema:registerAutoCompletionDataSource(basePath .. ".controls#negAction" , "$dataS/inputActions.xml" , "actions.action#name" )

        if SoundManager ~ = nil then
            SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "moving(?)" )
            SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "posEnd" )
            SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "negEnd" )
        end

        schema:resetXMLSharedRegistration( "AnimatedObject" , basePath)
    end

```

### setAnimTime

**Description**

> Set animation time

**Definition**

> setAnimTime(float t, )

**Arguments**

| float | t         | time |
|-------|-----------|------|
| any   | omitSound |      |

**Code**

```lua
function AnimatedObject:setAnimTime(t, omitSound)
    t = math.clamp(t, 0 , 1 )

    for _, part in pairs( self.animation.parts) do
        local x, y, z, rx, ry, rz, sx, sy, sz, vis = part.animCurve:get(t)

        setTranslation(part.node, x, y, z)
        setRotation(part.node, rx, ry, rz)
        setScale(part.node, sx, sy, sz)
        setVisibility(part.node, vis = = 1 )
    end

    if self.animation.shaderAnims ~ = nil then
        for _, shader in pairs( self.animation.shaderAnims) do
            local x, y, z, w = shader.animCurve:get(t)
            local parameterName = shader.parameterName

            setShaderParameter(shader.node, parameterName, x, y, z, w, false )
        end
    end

    local characterSet = self.animation.clipCharacterSet
    if characterSet ~ = nil then
        enableAnimTrack(characterSet, self.animation.clipTrack)
        setAnimTrackTime(characterSet, self.animation.clipTrack, t * self.animation.clipDuration, true )
        disableAnimTrack(characterSet, self.animation.clipTrack)
    end

    if self.rollingGateAnimations ~ = nil then
        for _, rollingGateAnimation in pairs( self.rollingGateAnimations) do
            rollingGateAnimation:setState(t)
        end
    end

    self.animation.time = t
    self.isMoving = true

    return t
end

```

### setFrameValues

**Description**

> Set frame values

**Definition**

> setFrameValues(integer node, table v)

**Arguments**

| integer | node | node id |
|---------|------|---------|
| table   | v    | values  |

**Code**

```lua
function AnimatedObject:setFrameValues(node, v)
    setTranslation(node, v[ 1 ], v[ 2 ], v[ 3 ])
    setRotation(node, v[ 4 ], v[ 5 ], v[ 6 ])
    setScale(node, v[ 7 ], v[ 8 ], v[ 9 ])
    setVisibility(node, v[ 10 ] = = 1 )
end

```

### triggerCallback

**Description**

> Trigger callback

**Definition**

> triggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger                    |
|---------|-----------|----------------------------------|
| integer | otherId   | id of object that calls callback |
| boolean | onEnter   | called on enter                  |
| boolean | onLeave   | called on leave                  |
| boolean | onStay    | called on stay                   |

**Code**

```lua
function AnimatedObject:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if g_currentMission.missionInfo:isa(FSCareerMissionInfo) then
        if onEnter or onLeave then
            if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
                if onEnter then
                    g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
                else
                        g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                    end

                    self:raiseActive()
                end
            end
        end
    end

```

### update

**Description**

> Called on update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function AnimatedObject:update(dt)
    AnimatedObject:superClass().update( self , dt)

    local finishedAnimation = false

    -- former updateTick()
    if self.isServer then
        if self.animation.direction ~ = 0 then
            local newAnimTime = 0
            if self.animation.duration ~ = 0 then
                newAnimTime = math.clamp( self.animation.time + ( self.animation.direction * dt) / self.animation.duration, 0 , 1 )
            end

            self:setAnimTime(newAnimTime)
            if newAnimTime = = 0 or newAnimTime = = 1 then
                self.animation.direction = 0
                finishedAnimation = true

                -- unblock AI region when gate if fully opened
                    if self.aiBlockingRegion ~ = nil then
                        g_currentMission.aiSystem:setBlockingRegionState( self.aiBlockingRegion.blockingRegionId, newAnimTime = = 0 )
                    end
                end
            end

            if self.animation.time ~ = self.animation.timeSend then
                self.animation.timeSend = self.animation.time
                self:raiseDirtyFlags( self.animatedObjectDirtyFlag)
            end
        else
                self.networkTimeInterpolator:update(dt)
                local interpolationAlpha = self.networkTimeInterpolator:getAlpha()
                local animTime = self.networkAnimTimeInterpolator:getInterpolatedValue(interpolationAlpha)
                local newAnimTime = self:setAnimTime(animTime)

                if self.animation.direction ~ = 0 then
                    if self.animation.direction > 0 then
                        if newAnimTime = = 1 then
                            self.animation.direction = 0
                            finishedAnimation = true
                        end
                    else
                            if newAnimTime = = 0 then
                                self.animation.direction = 0
                                finishedAnimation = true
                            end
                        end
                    end

                    if self.networkTimeInterpolator:isInterpolating() then
                        self:raiseActive()
                    end
                end

                if self.samplesMoving ~ = nil then
                    if self.isMoving and self.animation.direction ~ = 0 then
                        if not self.samplesMovingArePlaying then
                            g_soundManager:playSamples( self.samplesMoving)
                            self.samplesMovingArePlaying = true
                        end
                    else
                            if self.samplesMovingArePlaying then
                                g_soundManager:stopSamples( self.samplesMoving)
                                self.samplesMovingArePlaying = false
                            end
                        end
                    end

                    if finishedAnimation and self.animation.direction = = 0 then
                        if self.samplePosEnd ~ = nil and self.animation.time = = 1 then
                            g_soundManager:playSample( self.samplePosEnd)
                        elseif self.sampleNegEnd ~ = nil and self.animation.time = = 0 then
                                g_soundManager:playSample( self.sampleNegEnd)
                            end
                        end

                        self.isMoving = false

                        if self.animation.direction ~ = 0 then
                            self:raiseActive()
                        end
                    end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function AnimatedObject:writeStream(streamId, connection)
    AnimatedObject:superClass().writeStream( self , streamId, connection)
    if not connection:getIsServer() then
        streamWriteFloat32(streamId, self.animation.time )
        streamWriteUIntN(streamId, self.animation.direction + 1 , 2 )
    end
end

```

### writeUpdateStream

**Description**

> Called on server side on update

**Definition**

> writeUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function AnimatedObject:writeUpdateStream(streamId, connection, dirtyMask)
    AnimatedObject:superClass().writeUpdateStream( self , streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, self.animatedObjectDirtyFlag) ~ = 0 ) then
            streamWriteFloat32(streamId, self.animation.timeSend)
            streamWriteUIntN(streamId, self.animation.direction + 1 , 2 )
        end
    end
end

```