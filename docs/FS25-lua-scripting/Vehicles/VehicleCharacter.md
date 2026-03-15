## VehicleCharacter

**Description**

> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Functions**

- [characterLoaded](#characterloaded)
- [delete](#delete)
- [getAllowCharacterUpdate](#getallowcharacterupdate)
- [getIKChainTargets](#getikchaintargets)
- [getParentComponent](#getparentcomponent)
- [getPlayerStyle](#getplayerstyle)
- [load](#load)
- [loadCharacter](#loadcharacter)
- [new](#new)
- [registerCharacterXMLPaths](#registercharacterxmlpaths)
- [setAllowCharacterUpdate](#setallowcharacterupdate)
- [setCharacterVisibility](#setcharactervisibility)
- [setDirty](#setdirty)
- [setIKChainPoseByTarget](#setikchainposebytarget)
- [setIKChainTargets](#setikchaintargets)
- [setSpineDirty](#setspinedirty)
- [unloadCharacter](#unloadcharacter)
- [update](#update)
- [updateIKChains](#updateikchains)
- [updateVisibility](#updatevisibility)

### characterLoaded

**Description**

**Definition**

> characterLoaded()

**Arguments**

| any | loadingState |
|-----|--------------|
| any | arguments    |

**Code**

```lua
function VehicleCharacter:characterLoaded(loadingState, arguments)
    if loadingState = = HumanModelLoadingState.OK then
        -- Model was unloaded before finishing loading
        if self.playerModel.rootNode = = nil then
            return
        end

        self.isStyleLoaded = false

        -- Link to the vehicle
        local linkNode = Utils.getNoNil( self.characterNode, self.vehicle.rootNode)
        link(linkNode, self.playerModel.rootNode)

        -- Update IK
        for ikChainId, target in pairs( self.ikChainTargets) do
            IKUtil.setTarget( self.playerModel:getIKChains(), ikChainId, target)
        end

        if self.playerModel.thirdPersonHipsNode ~ = nil then
            local x, y, z = VehicleCharacter.SPINE_ROTATION[ 1 ], VehicleCharacter.SPINE_ROTATION[ 2 ], VehicleCharacter.SPINE_ROTATION[ 3 ]
            if self.characterSpineRotationOffset ~ = nil then
                x, y, z = self.characterSpineRotationOffset[ 1 ] + x, self.characterSpineRotationOffset[ 2 ] + y, self.characterSpineRotationOffset[ 3 ] + z
            end

            setRotation( self.playerModel.thirdPersonHipsNode, x, y, z)
        end

        self.characterDistanceRefNode = self.characterDistanceRefNodeCustom or self.playerModel.thirdPersonHeadNode

        if self.playerModel.skeleton ~ = nil and getNumOfChildren( self.playerModel.skeleton) > 0 then
            if self.useAnimation then
                local skeleton = self.playerModel.skeleton
                local animNode = g_animCache:getNode(AnimationCache.CHARACTER)
                cloneAnimCharacterSet(getChildAt(animNode, 0 ), skeleton)
                self.animationCharsetId = getAnimCharacterSet(getChildAt(skeleton, 0 ))
                local animationPlayer = createConditionalAnimation()
                if animationPlayer ~ = 0 then
                    self.animationPlayer = animationPlayer
                end

                -- for i = 0, getAnimNumOfClips(self.animationCharsetId)-1 do
                    -- print(getAnimClipName(self.animationCharsetId, i))
                    -- end

                    if self.animationCharsetId = = 0 then
                        self.animationCharsetId = nil
                        Logging.devError( "-- [VehicleCharacter:loadCharacter] Could not load animation CharSet from: [%s/%s]" , getName(getParent(skeleton)), getName(skeleton))
                        printScenegraph(getParent(skeleton))
                    end
                elseif self.useIdleAnimation then
                        local skeleton = self.playerModel.skeleton
                        local animNode = g_animCache:getNode(AnimationCache.VEHICLE_CHARACTER)
                        cloneAnimCharacterSet(getChildAt(animNode, 0 ), skeleton)
                        self.animationCharsetId = getAnimCharacterSet(skeleton)
                        if self.animationCharsetId ~ = 0 then
                            self.idleClipIndex = getAnimClipIndex( self.animationCharsetId, "idle1Source" )
                            clearAnimTrackClip( self.animationCharsetId, 0 )
                            assignAnimTrackClip( self.animationCharsetId, 0 , self.idleClipIndex)
                            setAnimTrackLoopState( self.animationCharsetId, 0 , true )

                            self.idleAnimationState = false
                        else
                                self.useIdleAnimation = false
                                self.animationCharsetId = nil
                                Logging.devError( "-- [VehicleCharacter:loadCharacter] Could not load animation CharSet from: [%s/%s]" , getName(getParent(skeleton)), getName(skeleton))
                            end
                        end
                    end

                    local playerStyle = arguments.playerStyle
                    self.playerModel:loadFromStyleAsync(playerStyle, function (target, loadingState, args)
                        if loadingState = = HumanModelLoadingState.OK then
                            self.isStyleLoaded = true
                            self:setDirty( true )
                            self:setCharacterVisibility( self.isVisible)
                        end
                    end , nil , nil )
                else
                        self.playerModel:delete()
                        self.playerModel = nil

                        Logging.error( "Failed to load vehicleCharacter" )
                    end

                    local asyncCallbackObject = arguments.asyncCallbackObject
                    local asyncCallbackFunction = arguments.asyncCallbackFunction
                    local asyncCallbackArguments = arguments.asyncCallbackArguments

                    if asyncCallbackFunction ~ = nil then
                        asyncCallbackFunction(asyncCallbackObject, loadingState, asyncCallbackArguments)
                    end
                end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function VehicleCharacter:delete()
    self:unloadCharacter()
end

```

### getAllowCharacterUpdate

**Description**

**Definition**

> getAllowCharacterUpdate()

**Code**

```lua
function VehicleCharacter:getAllowCharacterUpdate()
    return self.allowUpdate
end

```

### getIKChainTargets

**Description**

**Definition**

> getIKChainTargets()

**Code**

```lua
function VehicleCharacter:getIKChainTargets()
    return self.ikChainTargets
end

```

### getParentComponent

**Description**

**Definition**

> getParentComponent()

**Code**

```lua
function VehicleCharacter:getParentComponent()
    return self.parentComponent
end

```

### getPlayerStyle

**Description**

**Definition**

> getPlayerStyle()

**Code**

```lua
function VehicleCharacter:getPlayerStyle()
    if self.playerModel ~ = nil then
        return self.playerModel.style
    end

    return nil
end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | xmlNode |

**Code**

```lua
function VehicleCharacter:load(xmlFile, xmlNode)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlNode .. "#index" , xmlNode .. "#node" ) --FS17 to FS19

    self.characterNode = xmlFile:getValue(xmlNode .. "#node" , nil , self.vehicle.components, self.vehicle.i3dMappings)
    if self.characterNode ~ = nil then
        self.parentComponent = self.vehicle:getParentComponent( self.characterNode)
        self.characterCameraMinDistance = xmlFile:getValue(xmlNode .. "#cameraMinDistance" , 1.5 )
        self.characterDistanceRefNodeCustom = xmlFile:getValue(xmlNode .. "#distanceRefNode" , nil , self.vehicle.components, self.vehicle.i3dMappings)
        self.characterDistanceRefNode = self.characterDistanceRefNodeCustom or self.characterNode
        setVisibility( self.characterNode, false )
        self.useAnimation = xmlFile:getValue(xmlNode .. "#useAnimation" , false )
        self.useIdleAnimation = xmlFile:getValue(xmlNode .. "#useIdleAnimation" , not self.useAnimation and Platform.gameplay.hasVehicleCharacterIdleAnimations)

        if not self.useAnimation then
            self.ikChainTargets = { }
            IKUtil.loadIKChainTargets(xmlFile, xmlNode, self.vehicle.components, self.ikChainTargets, self.vehicle.i3dMappings)
        end
        self.characterSpineRotationOffset = xmlFile:getValue(xmlNode .. "#spineRotationOffset" , nil , true )
        self.characterSpineSpeedDepended = xmlFile:getValue(xmlNode .. "#speedDependedSpine" , false )
        self.characterSpineNodeMinRot = xmlFile:getValue(xmlNode .. "#spineNodeMinRot" , 10 )
        self.characterSpineNodeMaxRot = xmlFile:getValue(xmlNode .. "#spineNodeMaxRot" , - 10 )
        self.characterSpineNodeMinAcc = xmlFile:getValue(xmlNode .. "#spineNodeMinAcc" , - 1 ) / ( 1000 * 1000 )
        self.characterSpineNodeMaxAcc = xmlFile:getValue(xmlNode .. "#spineNodeMaxAcc" , 1 ) / ( 1000 * 1000 )
        self.characterSpineNodeAccDeadZone = xmlFile:getValue(xmlNode .. "#spineNodeAccDeadZone" , 0.2 ) / ( 1000 * 1000 )
        self.characterSpineLastRotation = 0
        self:setCharacterVisibility( self.isVisible)

        self.maxUpdateDistance = xmlFile:getValue(xmlNode .. "#maxUpdateDistance" , VehicleCharacter.DEFAULT_MAX_UPDATE_DISTANCE)
        setClipDistance( self.characterNode, xmlFile:getValue(xmlNode .. "#clipDistance" , VehicleCharacter.DEFAULT_CLIP_DISTANCE))

        return true
    end
    return false
end

```

### loadCharacter

**Description**

**Definition**

> loadCharacter()

**Arguments**

| any | playerStyle            |
|-----|------------------------|
| any | asyncCallbackObject    |
| any | asyncCallbackFunction  |
| any | asyncCallbackArguments |

**Code**

```lua
function VehicleCharacter:loadCharacter(playerStyle, asyncCallbackObject, asyncCallbackFunction, asyncCallbackArguments)
    if playerStyle = = nil then
        asyncCallbackFunction(asyncCallbackObject, false , asyncCallbackArguments)
        return
    end

    if self.playerModel ~ = nil then
        self.playerModel:delete()
    end

    self.playerModel = HumanModel.new()

    local arguments = {
    asyncCallbackObject = asyncCallbackObject,
    asyncCallbackFunction = asyncCallbackFunction,
    asyncCallbackArguments = asyncCallbackArguments,
    playerStyle = playerStyle
    }
    self.playerModel:load(playerStyle.xmlFilename, false , false , self.useAnimation, self.characterLoaded, self , arguments)
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | customMt |

**Code**

```lua
function VehicleCharacter.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or VehicleCharacter _mt)

    self.vehicle = vehicle
    self.characterNode = nil
    self.allowUpdate = true
    self.ikChainTargets = { }
    self.animationCharsetId = nil
    self.animationPlayer = nil
    self.useAnimation = false
    self.isVisible = false

    return self
end

```

### registerCharacterXMLPaths

**Description**

**Definition**

> registerCharacterXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |
| any | name     |

**Code**

```lua
function VehicleCharacter.registerCharacterXMLPaths(schema, basePath, name)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Character root node" )
    schema:register(XMLValueType.FLOAT, basePath .. "#cameraMinDistance" , "Min.distance until character is hidden" , 1.5 )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#distanceRefNode" , "Distance reference node" , "Character root node" )
    schema:register(XMLValueType.BOOL, basePath .. "#useAnimation" , "Use animation instead of ik chains" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#useIdleAnimation" , "Apply character idle animation additionally to ik chain control" , "set if #useAnimation not set" )

        schema:register(XMLValueType.VECTOR_ROT, basePath .. "#spineRotationOffset" , "Spine rotation offset" )
        schema:register(XMLValueType.BOOL, basePath .. "#speedDependedSpine" , "Speed dependent spine" , false )
        schema:register(XMLValueType.ANGLE, basePath .. "#spineNodeMinRot" , "Spine node min.rotation" , 10 )
        schema:register(XMLValueType.ANGLE, basePath .. "#spineNodeMaxRot" , "Spine node max.rotation" , - 10 )
        schema:register(XMLValueType.FLOAT, basePath .. "#spineNodeMinAcc" , "Spine node min.acceleration" , - 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#spineNodeMaxAcc" , "Spine node max.acceleration" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#spineNodeAccDeadZone" , "Spine node acceleration dead zone" , 0.2 )

        schema:register(XMLValueType.FLOAT, basePath .. "#maxUpdateDistance" , "Max.distance to vehicle root to update ik chains of character" , VehicleCharacter.DEFAULT_MAX_UPDATE_DISTANCE)
        schema:register(XMLValueType.FLOAT, basePath .. "#clipDistance" , "Clip distance of character" , VehicleCharacter.DEFAULT_CLIP_DISTANCE)

        IKUtil.registerIKChainTargetsXMLPaths(schema, basePath)
    end

```

### setAllowCharacterUpdate

**Description**

**Definition**

> setAllowCharacterUpdate()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function VehicleCharacter:setAllowCharacterUpdate(state)
    self.allowUpdate = state
end

```

### setCharacterVisibility

**Description**

**Definition**

> setCharacterVisibility()

**Arguments**

| any | isVisible |
|-----|-----------|

**Code**

```lua
function VehicleCharacter:setCharacterVisibility(isVisible)
    if self.characterNode ~ = nil then
        setVisibility( self.characterNode, isVisible)
    end
    if self.playerModel ~ = nil and self.playerModel.isLoaded then
        self.playerModel:setVisibility(isVisible)
    end

    self.isVisible = isVisible
end

```

### setDirty

**Description**

**Definition**

> setDirty()

**Arguments**

| any | setAllDirty |
|-----|-------------|

**Code**

```lua
function VehicleCharacter:setDirty(setAllDirty)
    if self.playerModel ~ = nil then
        for chainId, target in pairs( self.ikChainTargets) do
            if target.setDirty or setAllDirty then
                IKUtil.setIKChainDirty( self.playerModel:getIKChains(), chainId)
            end
        end
    end
end

```

### setIKChainPoseByTarget

**Description**

**Definition**

> setIKChainPoseByTarget()

**Arguments**

| any | target |
|-----|--------|
| any | poseId |

**Code**

```lua
function VehicleCharacter:setIKChainPoseByTarget(target, poseId)
    if self.playerModel ~ = nil then
        local ikChains = self.playerModel:getIKChains()

        local chain = IKUtil.getIKChainByTarget(ikChains, target)
        if chain ~ = nil then
            IKUtil.setIKChainPose(ikChains, chain.id, poseId)
        end
    end
end

```

### setIKChainTargets

**Description**

**Definition**

> setIKChainTargets()

**Arguments**

| any | targets |
|-----|---------|
| any | force   |

**Code**

```lua
function VehicleCharacter:setIKChainTargets(targets, force)
    if self.ikChainTargets ~ = targets or force then
        self.ikChainTargets = targets

        if self.playerModel ~ = nil then
            for ikChainId, target in pairs( self.ikChainTargets) do
                IKUtil.setTarget( self.playerModel:getIKChains(), ikChainId, target)
            end
            self:setDirty( true )
        end
    end
end

```

### setSpineDirty

**Description**

**Definition**

> setSpineDirty()

**Arguments**

| any | acc |
|-----|-----|

**Code**

```lua
function VehicleCharacter:setSpineDirty(acc)
    if math.abs(acc) < self.characterSpineNodeAccDeadZone then
        acc = 0
    end
    local alpha = math.clamp((acc - self.characterSpineNodeMinAcc) / ( self.characterSpineNodeMaxAcc - self.characterSpineNodeMinAcc), 0 , 1 )
    local rotation = MathUtil.lerp( self.characterSpineNodeMinRot, self.characterSpineNodeMaxRot, alpha)
    if rotation ~ = self.characterSpineLastRotation then
        self.characterSpineLastRotation = self.characterSpineLastRotation * 0.95 + rotation * 0.05
        setRotation( self.player.spineNode, self.characterSpineLastRotation, 0 , 0 )
        self:setDirty()
    end
end

```

### unloadCharacter

**Description**

**Definition**

> unloadCharacter()

**Code**

```lua
function VehicleCharacter:unloadCharacter()
    if self.playerModel ~ = nil then
        self.characterDistanceRefNode = self.characterDistanceRefNodeCustom or self.characterNode

        self.playerModel:delete()
        self.playerModel = nil

        if self.animationPlayer ~ = nil then
            delete( self.animationPlayer)
            self.animationPlayer = nil
        end

    end
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function VehicleCharacter:update(dt)
    --#profile RemoteProfiler.zoneBeginN("VehicleCharacter:update")
    if self.playerModel ~ = nil and self.playerModel.isLoaded then

        if Platform.gameplay.allowVehicleCharacterIKDirtyUpdate then
            if self.vehicle.currentUpdateDistance < self.maxUpdateDistance and self.isVisible then
                if self:getAllowCharacterUpdate() then
                    self:setDirty( false )
                end

                self:updateIKChains()
            end
        end

        if self.useIdleAnimation then
            if self.vehicle.currentUpdateDistance < self.maxUpdateDistance then
                if not self.idleAnimationState then
                    self.idleAnimationState = true
                    enableAnimTrack( self.animationCharsetId, 0 )
                end
            else
                    if self.idleAnimationState then
                        self.idleAnimationState = false
                        disableAnimTrack( self.animationCharsetId, 0 )
                    end
                end
            end
        end
        --#profile RemoteProfiler.zoneEnd()
    end

```

### updateIKChains

**Description**

**Definition**

> updateIKChains()

**Code**

```lua
function VehicleCharacter:updateIKChains()
    IKUtil.updateIKChains( self.playerModel:getIKChains(), true )
end

```

### updateVisibility

**Description**

**Definition**

> updateVisibility()

**Code**

```lua
function VehicleCharacter:updateVisibility()
    --#profile RemoteProfiler.zoneBeginN("VehicleCharacter:updateVisibility")
    if self.isStyleLoaded and entityExists( self.characterDistanceRefNode) and entityExists(g_cameraManager:getActiveCamera()) then
        local dist = calcDistanceFrom( self.characterDistanceRefNode, g_cameraManager:getActiveCamera())
        local visible = dist > = self.characterCameraMinDistance
        self:setCharacterVisibility(visible)
    end
    --#profile RemoteProfiler.zoneEnd()
end

```