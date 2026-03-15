## HandToolFlashlight

**Description**

> The hand tool specialisation for hand tools that shine a light from a node.

**Functions**

- [onDelete](#ondelete)
- [onHeldEnd](#onheldend)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setFlashlightIsActive](#setflashlightisactive)
- [updateTransform](#updatetransform)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolFlashlight:onDelete()
    local spec = self.spec_flashlight
    if spec.lightNode ~ = nil then
        -- The light node comes with the i3d file, but is relinked to the root node, so must be manually deleted.
        delete(spec.lightNode)
        spec.lightNode = nil
    end

    g_soundManager:deleteSamples(spec.samples)

    if spec.lightNodeParent ~ = nil then
        delete(spec.lightNodeParent)
        spec.lightNodeParent = nil
    end
end

```

### onHeldEnd

**Description**

**Definition**

> onHeldEnd()

**Code**

```lua
function HandToolFlashlight:onHeldEnd()
    self:setFlashlightIsActive( false , true )
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | xmlFile |
|-----|---------|

**Code**

```lua
function HandToolFlashlight:onLoad(xmlFile)
    local spec = self.spec_flashlight

    spec.isActive = false

    self.isFlashlight = true

    -- The light node.
    spec.lightNode = xmlFile:getValue( "handTool.flashlight.light#node" , nil , self.components, self.i3dMappings)
    spec.lightMeshNode = xmlFile:getValue( "handTool.flashlight.light#mesh" , nil , self.components, self.i3dMappings)
    spec.lightNodeParent = getParent(spec.lightNode)
    spec.lightNodeOffsetX, spec.lightNodeOffsetY, spec.lightNodeOffsetZ = getTranslation(spec.lightNode)
    spec.lightNodeForwardX, spec.lightNodeForwardY, spec.lightNodeForwardZ = localDirectionToLocal(spec.lightNode, spec.lightNodeParent, 0 , 0 , 1 )

    -- Link the light node to the root node, so that it does not get hidden with the main hand tool.
    link(getRootNode(), spec.lightNode)

    -- The parameters.
    spec.distance = xmlFile:getValue( "handTool.flashlight.light#distance" , 100 )
    spec.coneAngle = xmlFile:getValue( "handTool.flashlight.light#coneAngle" , 60 )
    spec.color = Color.fromVector(xmlFile:getValue( "handTool.flashlight.light#color" , { 1 , 1 , 1 , 1 } , true ))
    spec.dropOff = xmlFile:getValue( "handTool.flashlight.light#dropOff" , 5 )

    if spec.lightNode = = nil then
        Logging.xmlError(xmlFile, "Flashlight's light node could not be resolved!" )
        return
    end

    -- Set the light parameters.
    setLightRange(spec.lightNode, spec.distance)
    setLightColor(spec.lightNode, spec.color.r, spec.color.g, spec.color.b)
    setLightDropOff(spec.lightNode, spec.dropOff)
    setLightConeAngle(spec.lightNode, spec.coneAngle)

    local iesProfileFilename = xmlFile:getValue( "handTool.flashlight.light#iesProfile" )
    if iesProfileFilename ~ = nil then
        iesProfileFilename = Utils.getFilename(iesProfileFilename, self.baseDirectory)
        setLightIESProfile(spec.lightNode, iesProfileFilename)
    end

    if self.isClient then
        spec.samples = { }
        spec.samples.toggle = g_soundManager:loadSampleFromXML(xmlFile, "handTool.flashlight.sounds" , "toggle" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    -- Start with the light off.
    self:setFlashlightIsActive( false , true )
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolFlashlight:onUpdate(dt)
    self:updateTransform( self:getIsHeld())
    self:raiseActive()
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
function HandToolFlashlight.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolFlashlight.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolFlashlight )
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolFlashlight )
    SpecializationUtil.registerEventListener(handToolType, "onUpdate" , HandToolFlashlight )
    SpecializationUtil.registerEventListener(handToolType, "onHeldEnd" , HandToolFlashlight )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolFlashlight.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "setFlashlightIsActive" , HandToolFlashlight.setFlashlightIsActive)
    SpecializationUtil.registerFunction(handToolType, "updateTransform" , HandToolFlashlight.updateTransform)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | xmlSchema |
|-----|-----------|

**Code**

```lua
function HandToolFlashlight.registerXMLPaths(xmlSchema)
    xmlSchema:setXMLSpecializationType( "HandToolFlashlight" )
    xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.flashlight.light#node" , "The light node on the flashlight" )
    xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.flashlight.light#mesh" , "The self illum mesh of the flashlight" )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.flashlight.light#distance" , "The distance of the light" )
    xmlSchema:register(XMLValueType.ANGLE, "handTool.flashlight.light#coneAngle" , "The cone angle of the light" )
    xmlSchema:register(XMLValueType.COLOR, "handTool.flashlight.light#color" , "The color of the light" )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.flashlight.light#dropOff" , "The drop off of the light" )
    xmlSchema:register(XMLValueType.STRING, "handTool.flashlight.light#iesProfile" , "The IES Profile" )
    SoundManager.registerSampleXMLPaths(xmlSchema, "handTool.flashlight.sounds" , "toggle" )
    xmlSchema:setXMLSpecializationType()
end

```

### setFlashlightIsActive

**Description**

**Definition**

> setFlashlightIsActive()

**Arguments**

| any | isActive    |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function HandToolFlashlight:setFlashlightIsActive(isActive, noEventSend)
    local spec = self.spec_flashlight

    local changed = spec.isActive ~ = isActive
    spec.isActive = isActive

    if spec.lightNode ~ = nil then
        setVisibility(spec.lightNode, isActive)
    end
    if spec.lightMeshNode ~ = nil then
        setVisibility(spec.lightMeshNode, isActive)
    end

    if changed and spec.samples ~ = nil then
        if not g_soundManager:getIsSamplePlaying(spec.samples.toggle) then
            g_soundManager:playSample(spec.samples.toggle)
        end
    end

    FlashlightToggleLightEvent.sendEvent( self , spec.isActive, noEventSend)
end

```

### updateTransform

**Description**

**Definition**

> updateTransform()

**Arguments**

| any | isHeld |
|-----|--------|

**Code**

```lua
function HandToolFlashlight:updateTransform(isHeld)

    local spec = self.spec_flashlight

    -- If the flashlight is held, position the light so that it comes out of the tool model.
    if isHeld then

        -- Ensure the parent of the light node still exists.
        if spec.lightNodeParent = = nil or not entityExists(spec.lightNodeParent) then
            spec.lightNodeParent = nil
            return
        end

        local worldPositionX, worldPositionY, worldPositionZ = localToWorld(spec.lightNodeParent, spec.lightNodeOffsetX, spec.lightNodeOffsetY, spec.lightNodeOffsetZ)
        local worldForwardX, worldForwardY, worldForwardZ = localDirectionToLocal(spec.lightNodeParent, getRootNode(), spec.lightNodeForwardX, spec.lightNodeForwardY, spec.lightNodeForwardZ)

        setWorldTranslation(spec.lightNode, worldPositionX, worldPositionY, worldPositionZ)
        setDirection(spec.lightNode, worldForwardX, worldForwardY, worldForwardZ, 0 , 1 , 0 )
        return
    end

    -- Get the carrying player.If there is none, do nothing more.
        local player = self:getCarryingPlayer()
        if player = = nil then
            return
        end

        -- If the player has a camera and is in first person, position the light so that it follows the camera.
        if player.camera ~ = nil and player.camera.isFirstPerson then
            local cameraPositionX, cameraPositionY, cameraPositionZ = player.camera:getCameraPosition()
            local cameraPitch, cameraYaw = player.camera:getRotation()

            setWorldTranslation(spec.lightNode, cameraPositionX, cameraPositionY, cameraPositionZ)
            setWorldRotation(spec.lightNode, - cameraPitch, MathUtil.getValidLimit(cameraYaw + math.pi), 0 )
            return
        end

        local graphics = player.graphicsComponent
        if graphics = = nil then
            return
        end

        local model = graphics.model
        -- If the player has no loaded model; do nothing.
            if model = = nil or model.thirdPersonHeadNode = = nil or not entityExists(model.thirdPersonHeadNode) then
                return
            end

            -- Position the light to point in the player's graphical direction, without pitch.
            local yaw = graphics:getModelYaw()
            local headPositionX, headPositionY, headPositionZ = localToWorld(model.thirdPersonHeadNode, 0 , - 0.2 , 0 )

            setWorldTranslation(spec.lightNode, headPositionX, headPositionY, headPositionZ)
            setWorldRotation(spec.lightNode, 0 , MathUtil.getValidLimit(yaw + math.pi), 0 )
        end

```