## Rideable

**Description**

> Specialization class for Rideables

**XML Configuration Parameters**

| vehicle.rideable#speedBackwards | max speed in gait type backwards (m/s) |
|---------------------------------|----------------------------------------|
| vehicle.rideable#speedWalk      | max speed in gait type walk (m/s)      |
| vehicle.rideable#speedTrot      | max speed in gait type trot (m/s)      |
| vehicle.rideable#speedGallop    | max speed in gait type gallop (m/s)    |
| vehicle.rideable#turnAngle      | max turn speed (deg/s)                 |

**Functions**

- [actionEventAccelerate](#actioneventaccelerate)
- [actionEventBrake](#actioneventbrake)
- [actionEventJump](#actioneventjump)
- [actionEventSteer](#actioneventsteer)
- [calculateLegsDistance](#calculatelegsdistance)
- [dayChanged](#daychanged)
- [deleteVehicleCharacter](#deletevehiclecharacter)
- [endFade](#endfade)
- [getCanBeReset](#getcanbereset)
- [getCanBeSold](#getcanbesold)
- [getCluster](#getcluster)
- [getCurrentGait](#getcurrentgait)
- [getFullName](#getfullname)
- [getHoofSurfaceSound](#gethoofsurfacesound)
- [getImageFilename](#getimagefilename)
- [getInteractionHelp](#getinteractionhelp)
- [getIsRideableJumpAllowed](#getisrideablejumpallowed)
- [getMapHotspotRotation](#getmaphotspotrotation)
- [getName](#getname)
- [getPosition](#getposition)
- [getRotation](#getrotation)
- [getShowInVehiclesOverview](#getshowinvehiclesoverview)
- [groundRaycastCallback](#groundraycastcallback)
- [initSpecialization](#initspecialization)
- [jump](#jump)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onEnterVehicle](#onentervehicle)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onReadPositionUpdateStream](#onreadpositionupdatestream)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onSetBroken](#onsetbroken)
- [onUpdate](#onupdate)
- [onUpdateInterpolation](#onupdateinterpolation)
- [onVehicleCharacterChanged](#onvehiclecharacterchanged)
- [onWritePositionUpdateStream](#onwritepositionupdatestream)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [periodChanged](#periodchanged)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [resetInputs](#resetinputs)
- [saveToXMLFile](#savetoxmlfile)
- [setCluster](#setcluster)
- [setCurrentGait](#setcurrentgait)
- [setEquipmentVisibility](#setequipmentvisibility)
- [setPlayerToEnter](#setplayertoenter)
- [setRideableSteer](#setrideablesteer)
- [setWorldPosition](#setworldposition)
- [setWorldPositionQuat](#setworldpositionquat)
- [setWorldPositionQuaternion](#setworldpositionquaternion)
- [showInfo](#showinfo)
- [testCCTMove](#testcctmove)
- [unlinkReins](#unlinkreins)
- [updateAnimation](#updateanimation)
- [updateDebugValues](#updatedebugvalues)
- [updateDirt](#updatedirt)
- [updateFootsteps](#updatefootsteps)
- [updateInputText](#updateinputtext)
- [updateKinematic](#updatekinematic)
- [updateRiding](#updateriding)
- [updateSound](#updatesound)
- [updateVehicleSpeed](#updatevehiclespeed)

### actionEventAccelerate

**Description**

> Callback on accelerate event

**Definition**

> actionEventAccelerate(table self, string actionName, float inputValue, string callbackState, boolean isAnalog)

**Arguments**

| table   | self          | instance                |
|---------|---------------|-------------------------|
| string  | actionName    | action name             |
| float   | inputValue    | input value             |
| string  | callbackState |                         |
| boolean | isAnalog      | true if input is analog |

**Code**

```lua
function Rideable.actionEventAccelerate( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_rideable
    local enterable = self.spec_enterable

    if enterable.isEntered and enterable.isControlled and spec.haltTimer < = 0 and spec.isOnGround then
        self:setCurrentGait( math.min( self:getCurrentGait() + 1 , Rideable.GAITTYPES.MAX))
    end
end

```

### actionEventBrake

**Description**

> Callback on brake event

**Definition**

> actionEventBrake(table self, string actionName, float inputValue, string callbackState, boolean isAnalog)

**Arguments**

| table   | self          | instance                |
|---------|---------------|-------------------------|
| string  | actionName    | action name             |
| float   | inputValue    | input value             |
| string  | callbackState |                         |
| boolean | isAnalog      | true if input is analog |

**Code**

```lua
function Rideable.actionEventBrake( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_rideable
    if self:getIsEntered() and spec.haltTimer < = 0 and spec.isOnGround then
        self:setCurrentGait( math.max( self:getCurrentGait() - 1 , 1 ))
    end
end

```

### actionEventJump

**Description**

> Callback on jump event

**Definition**

> actionEventJump(table self, string actionName, float inputValue, string callbackState, boolean isAnalog)

**Arguments**

| table   | self          | instance                |
|---------|---------------|-------------------------|
| string  | actionName    | action name             |
| float   | inputValue    | input value             |
| string  | callbackState |                         |
| boolean | isAnalog      | true if input is analog |

**Code**

```lua
function Rideable.actionEventJump( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsRideableJumpAllowed() then
        self:jump()
    end
end

```

### actionEventSteer

**Description**

> Callback on steer event

**Definition**

> actionEventSteer(table self, string actionName, float inputValue, string callbackState, boolean isAnalog)

**Arguments**

| table   | self          | instance                |
|---------|---------------|-------------------------|
| string  | actionName    | action name             |
| float   | inputValue    | input value             |
| string  | callbackState |                         |
| boolean | isAnalog      | true if input is analog |

**Code**

```lua
function Rideable.actionEventSteer( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_rideable
    if self:getIsEntered() and spec.haltTimer < = 0 then
        self:setRideableSteer(inputValue)
    end
end

```

### calculateLegsDistance

**Description**

> Gets legs distance from rootNode

**Definition**

> calculateLegsDistance(integer left, integer right)

**Arguments**

| integer | left  | leg node |
|---------|-------|----------|
| integer | right | leg node |

**Return Values**

| integer | distance | from root node |
|---------|----------|----------------|

**Code**

```lua
function Rideable:calculateLegsDistance(leftLegNode, rightLegNode)
    local distance = 0.0
    if leftLegNode ~ = nil and rightLegNode ~ = nil then
        local _, _, dzL = localToLocal(leftLegNode, self.rootNode, 0.0 , 0.0 , 0.0 )
        local _, _, dzR = localToLocal(rightLegNode, self.rootNode, 0.0 , 0.0 , 0.0 )
        distance = (dzL + dzR) * 0.5
    end
    return distance
end

```

### dayChanged

**Description**

**Definition**

> dayChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:dayChanged(superFunc)
    superFunc( self )

    local spec = self.spec_rideable
    if spec.cluster ~ = nil then
        spec.cluster:onDayChanged()
    end
end

```

### deleteVehicleCharacter

**Description**

**Definition**

> deleteVehicleCharacter()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:deleteVehicleCharacter(superFunc)
    self:setEquipmentVisibility( false )
    self:unlinkReins()

    superFunc( self )
end

```

### endFade

**Description**

**Definition**

> endFade()

**Code**

```lua
function Rideable:endFade()
end

```

### getCanBeReset

**Description**

**Definition**

> getCanBeReset()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getCanBeReset(superFunc)
    return false
end

```

### getCanBeSold

**Description**

**Definition**

> getCanBeSold()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getCanBeSold(superFunc)
    return false
end

```

### getCluster

**Description**

**Definition**

> getCluster()

**Code**

```lua
function Rideable:getCluster()
    return self.spec_rideable.cluster
end

```

### getCurrentGait

**Description**

**Definition**

> getCurrentGait()

**Code**

```lua
function Rideable:getCurrentGait()
    return self.spec_rideable.inputValues.currentGait
end

```

### getFullName

**Description**

**Definition**

> getFullName()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getFullName(superFunc)
    return self:getName()
end

```

### getHoofSurfaceSound

**Description**

**Definition**

> getHoofSurfaceSound()

**Arguments**

| any | x          |
|-----|------------|
| any | y          |
| any | z          |
| any | hitTerrain |

**Code**

```lua
function Rideable:getHoofSurfaceSound(x, y, z, hitTerrain)
    local spec = self.spec_rideable

    if hitTerrain then
        local mission = g_currentMission
        local snowHeight = mission.snowSystem:getSnowHeightAtArea(x, z, x + 0.1 , z + 0.1 , x + 0.1 , z)
        if snowHeight > 0 then
            return spec.surfaceNameToSound[ "snow" ]
        else
                local isOnField, _ = FSDensityMapUtil.getFieldDataAtWorldPosition(x, y, z)
                if isOnField then
                    return spec.surfaceNameToSound[ "field" ]
                elseif self.isInShallowWater then
                        return spec.surfaceNameToSound[ "shallowWater" ]
                    elseif self.isInMediumWater then
                            return spec.surfaceNameToSound[ "mediumWater" ]
                        end
                    end

                    local _, _, _, _ , materialId = getTerrainAttributesAtWorldPos(g_terrainNode, x, y, z, true , true , true , true , false )
                    return spec.surfaceIdToSound[materialId]
                else
                        return spec.surfaceNameToSound[ "asphalt" ]
                    end
                end

```

### getImageFilename

**Description**

**Definition**

> getImageFilename()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getImageFilename(superFunc)
    local imageFilename = superFunc( self )

    local cluster = self:getCluster()
    if cluster ~ = nil then
        local mission = g_currentMission
        local visual = mission.animalSystem:getVisualByAge(cluster.subTypeIndex, cluster:getAge())
        imageFilename = visual.store.imageFilename
    end

    return imageFilename
end

```

### getInteractionHelp

**Description**

> Returns interaction help text

**Definition**

> getInteractionHelp()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | text | text |
|-----|------|------|

**Code**

```lua
function Rideable:getInteractionHelp(superFunc)
    if self.interactionFlag = = Vehicle.INTERACTION_FLAG_ENTERABLE then
        local spec = self.spec_rideable
        local enterText = string.format(g_i18n:getText( "action_rideAnimal" ), spec.cluster:getName())
        return enterText
    else
            return superFunc( self )
        end
    end

```

### getIsRideableJumpAllowed

**Description**

**Definition**

> getIsRideableJumpAllowed()

**Arguments**

| any | allowWhileJump |
|-----|----------------|

**Code**

```lua
function Rideable:getIsRideableJumpAllowed(allowWhileJump)
    local spec = self.spec_rideable

    if not spec.isOnGround and not allowWhileJump then
        return false
    end

    if spec.inputValues.currentGait < Rideable.GAITTYPES.CANTER then
        return false
    end

    if self.isBroken then
        return false
    end

    return true
end

```

### getMapHotspotRotation

**Description**

**Definition**

> getMapHotspotRotation()

**Arguments**

| any | superFunc       |
|-----|-----------------|
| any | isPlayerHotspot |

**Code**

```lua
function Rideable:getMapHotspotRotation(superFunc, isPlayerHotspot)
    if not isPlayerHotspot then
        return 0
    end

    return superFunc( self , isPlayerHotspot)
end

```

### getName

**Description**

**Definition**

> getName()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getName(superFunc)
    local spec = self.spec_rideable
    return spec.cluster:getName()
end

```

### getPosition

**Description**

**Definition**

> getPosition()

**Code**

```lua
function Rideable:getPosition()
    return getWorldTranslation( self.rootNode)
end

```

### getRotation

**Description**

**Definition**

> getRotation()

**Code**

```lua
function Rideable:getRotation()
    return getWorldRotation( self.rootNode)
end

```

### getShowInVehiclesOverview

**Description**

**Definition**

> getShowInVehiclesOverview()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:getShowInVehiclesOverview(superFunc)
    return false
end

```

### groundRaycastCallback

**Description**

> Callback used when raycast hists an object. Updates player information so it can be used to pickup the object.

**Definition**

> groundRaycastCallback(integer hitObjectId, float x, float y, float z, float distance)

**Arguments**

| integer | hitObjectId | scenegraph object id                      |
|---------|-------------|-------------------------------------------|
| float   | x           | world x hit position                      |
| float   | y           | world y hit position                      |
| float   | z           | world z hit position                      |
| float   | distance    | distance at which the cast hit the object |

**Return Values**

| float | returns | true object that was hit is valid |
|-------|---------|-----------------------------------|

**Code**

```lua
function Rideable:groundRaycastCallback(hitObjectId, x, y, z, distance)
    local spec = self.spec_rideable
    if hitObjectId = = self.spec_cctdrivable.cctNode then
        return true
    end

    if getCollisionFilterMask(hitObjectId) = = CollisionFlag.DEFAULT then
        return true -- ignore if collision only has default bit = > is not supposed to collide with anything
        end

        -- DebugUtil.drawSimpleDebugCube(x, y, z, 0.05, 1, 0, 0)
        spec.groundRaycastResult.y = y
        spec.groundRaycastResult.object = hitObjectId
        spec.groundRaycastResult.distance = distance

        return false
    end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Rideable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Rideable" )

    schema:register(XMLValueType.FLOAT, "vehicle.rideable#speedBackwards" , "Backward speed" , - 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#speedWalk" , "Walk speed" , 2.5 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#speedCanter" , "Canter speed" , 3.5 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#speedTrot" , "Trot speed" , 5.0 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#speedGallop" , "Gallop speed" , 10.0 )

    schema:register(XMLValueType.FLOAT, "vehicle.rideable#minTurnRadiusBackwards" , "Min turning radius backward" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#minTurnRadiusWalk" , "Min turning radius walk" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#minTurnRadiusCanter" , "Min turning radius canter" , 2.5 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#minTurnRadiusTrot" , "Min turning radius trot" , 5 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#minTurnRadiusGallop" , "Min turning radius gallop" , 10 )

    schema:register(XMLValueType.ANGLE, "vehicle.rideable#turnSpeed" , "Turn speed(deg/s)" , 45 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable#jumpHeight" , "Jump height" , 2 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable#proxy" , "Proxy node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontLeft#node" , "Hoof node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemSlow#node" , "Slow step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemSlow#particleType" , "Slow step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemSlow" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemFast#node" , "Fast step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemFast#particleType" , "Fast step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofFrontLeft.particleSystemFast" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontRight#node" , "Hoof node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemSlow#node" , "Slow step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemSlow#particleType" , "Slow step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemSlow" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemFast#node" , "Fast step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemFast#particleType" , "Fast step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofFrontRight.particleSystemFast" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackLeft#node" , "Hoof node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemSlow#node" , "Slow step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemSlow#particleType" , "Slow step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemSlow" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemFast#node" , "Fast step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemFast#particleType" , "Fast step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofBackLeft.particleSystemFast" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackRight#node" , "Hoof node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemSlow#node" , "Slow step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemSlow#particleType" , "Slow step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemSlow" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemFast#node" , "Fast step particle emitterShape" )
    schema:register(XMLValueType.STRING, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemFast#particleType" , "Fast step particle type" )
    ParticleUtil.registerParticleCopyXMLPaths(schema, "vehicle.rideable.modelInfo.hoofBackRight.particleSystemFast" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#animationNode" , "Animation node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#meshNode" , "Mesh node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#equipmentNode" , "Equipment node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#reinsNode" , "Reins node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#reinLeftNode" , "Rein left node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.rideable.modelInfo#reinRightNode" , "Rein right node" )

    schema:register(XMLValueType.FLOAT, "vehicle.rideable.sounds#breathIntervalNoEffort" , "Breath interval no effort" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable.sounds#breathIntervalEffort" , "Breath interval effort" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable.sounds#minBreathIntervalIdle" , "Min.breath interval idle" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.rideable.sounds#maxBreathIntervalIdle" , "Max.breath interval idle" , 1 )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.rideable.sounds" , "halt" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.rideable.sounds" , "breathingNoEffort" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.rideable.sounds" , "breathingEffort" )

    -- values loaded only by engine, registration just for documentation/validation purposes
        ConditionalAnimation.registerXMLPaths(schema, "vehicle.conditionalAnimation" )
        ConditionalAnimation.registerXMLPaths(schema, "vehicle.riderConditionalAnimation" )

        schema:setXMLSpecializationType()

        local savegameSchema = Vehicle.xmlSchemaSavegame
        savegameSchema:register(XMLValueType.STRING, "vehicles.vehicle(?).rideable#animalType" , "Animal type name" )
    end

```

### jump

**Description**

**Definition**

> jump()

**Code**

```lua
function Rideable:jump()
    local spec = self.spec_rideable

    if not self.isServer then
        g_client:getServerConnection():sendEvent( JumpEvent.new( self ))
    else
            local total, _ = g_farmManager:updateFarmStats( self:getOwnerFarmId(), "horseJumpCount" , 1 )
            if total ~ = nil then
                g_achievementManager:tryUnlock( "HorseJumpsFirst" , total)
                g_achievementManager:tryUnlock( "HorseJumps" , total)
            end
        end

        local jumpHeight = spec.jumpHeight
        if spec.inputValues.currentGait = = Rideable.GAITTYPES.CANTER then
            jumpHeight = jumpHeight * 0.5
        end

        local velY = math.sqrt( 2 * math.abs(spec.gravity) * jumpHeight)
        spec.currentSpeedY = velY
    end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Rideable:onDelete()
    local spec = self.spec_rideable

    local mission = g_currentMission
    mission.husbandrySystem:removeRideable( self )

    g_soundManager:deleteSamples(spec.surfaceSounds)
    g_soundManager:deleteSample(spec.horseStopSound)
    g_soundManager:deleteSample(spec.horseBreathSoundsNoEffort)
    g_soundManager:deleteSample(spec.horseBreathSoundsEffort)

    if spec.hooves ~ = nil then
        for _, d in pairs(spec.hooves) do
            if d.psSlow ~ = nil then
                ParticleUtil.deleteParticleSystem(d.psSlow)
                delete(d.psSlow.emitterShape)
            end
            if d.psFast ~ = nil then
                ParticleUtil.deleteParticleSystem(d.psFast)
                delete(d.psFast.emitterShape)
            end
        end
    end

    if spec.animationPlayer ~ = nil then
        delete(spec.animationPlayer)
        spec.animationPlayer = nil
    end
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Rideable:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_rideable
    if isActiveForInputIgnoreSelection and spec.cluster ~ = nil then
        local mission = g_currentMission
        mission:addExtraPrintText( string.format( "%s: %d %%" , g_i18n:getText( "infohud_riding" ), spec.cluster:getRidingFactor() * 100 ))
    end
end

```

### onEnterVehicle

**Description**

> Called on enter vehicle

**Definition**

> onEnterVehicle(boolean isControlling)

**Arguments**

| boolean | isControlling |
|---------|---------------|

**Code**

```lua
function Rideable:onEnterVehicle(isControlling)
    local spec = self.spec_rideable

    if self.isClient then
        spec.playerToEnter = nil
        spec.checkPlayerToEnter = false

        spec.currentSpeed = 0.0
        spec.currentTurnSpeed = 0.0
        self:setCurrentGait( Rideable.GAITTYPES.STILL)
        spec.isOnGround = false

        -- rider animation
        -- local character = self:getVehicleCharacter()
    end

    if self.isServer then
        spec.lastOwner = self:getOwnerConnection()

        -- setCollisionFilterMask(self.components[1].node, 0)

        spec.doHusbandryCheck = 0
    end
end

```

### onLeaveVehicle

**Description**

> Called on leaving vehicle

**Definition**

> onLeaveVehicle()

**Code**

```lua
function Rideable:onLeaveVehicle()
    local spec = self.spec_rideable
    if self.isClient then
        spec.inputValues.currentGait = Rideable.GAITTYPES.STILL
        self:resetInputs()
        local mission = g_currentMission
        if mission.hud.fadeScreenElement:getAlpha() > 0.0 then
            mission:fadeScreen( - 1 , spec.fadeDuration, self.endFade, self )
        end
    end

    if self.isServer then
        -- setCollisionFilterMask(self.components[1].node, spec.collisionMask)
        spec.doHusbandryCheck = 5000
    end

    spec.leaveTimer = 15000
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
function Rideable:onLoad(savegame)
    local spec = self.spec_rideable

    -- Overwrite the Vehicle high precision setting.Otherwise the precision might lead to large jitter in speed in multiplayer
    self.highPrecisionPositionSynchronization = true

    spec.leaveTimer = 15000
    spec.currentDirtScale = 0
    spec.abandonTimerDuration = g_gameSettings:getValue(GameSettings.SETTING.HORSE_ABANDON_TIMER_DURATION)
    spec.abandonTimer = spec.abandonTimerDuration
    spec.fadeDuration = 400
    spec.isRideableRemoved = false
    spec.justSpawned = true
    spec.meshNode = nil
    -- Animation
    spec.animationNode = nil
    spec.charsetId = nil
    spec.animationPlayer = nil
    spec.animationParameters = { }
    spec.animationParameters.forwardVelocity = { id = 1 , value = 0.0 , type = 1 }
    spec.animationParameters.verticalVelocity = { id = 2 , value = 0.0 , type = 1 }
    spec.animationParameters.yawVelocity = { id = 3 , value = 0.0 , type = 1 }
    spec.animationParameters.absForwardVelocity = { id = 4 , value = 0.0 , type = 1 }
    spec.animationParameters.onGround = { id = 5 , value = false , type = 0 }
    spec.animationParameters.inWater = { id = 6 , value = false , type = 0 }
    spec.animationParameters.closeToGround = { id = 7 , value = false , type = 0 }
    spec.animationParameters.leftRightWeight = { id = 8 , value = 0.0 , type = 1 }
    spec.animationParameters.absYawVelocity = { id = 9 , value = 0.0 , type = 1 }
    spec.animationParameters.halted = { id = 10 , value = false , type = 0 }
    spec.animationParameters.smoothedForwardVelocity = { id = 11 , value = 0.0 , type = 1 }
    spec.animationParameters.absSmoothedForwardVelocity = { id = 12 , value = 0.0 , type = 1 }

    -- InputAction
    spec.acceletateEventId = ""
    spec.brakeEventId = ""
    spec.steerEventId = ""
    spec.jumpEventId = ""

    -- movements
    spec.currentTurnAngle = 0
    spec.currentTurnSpeed = 0.0
    spec.currentSpeed = 0.0
    spec.currentSpeedY = 0.0
    spec.cctMoveQueue = { }
    spec.currentCCTPosX = 0.0
    spec.currentCCTPosY = 0.0
    spec.currentCCTPosZ = 0.0
    spec.lastCCTPosX = 0.0
    spec.lastCCTPosY = 0.0
    spec.lastCCTPosZ = 0.0
    spec.topSpeeds = { }
    spec.topSpeeds[ Rideable.GAITTYPES.BACKWARDS] = self.xmlFile:getValue( "vehicle.rideable#speedBackwards" , - 1.0 )
    spec.topSpeeds[ Rideable.GAITTYPES.STILL] = 0.0
    spec.topSpeeds[ Rideable.GAITTYPES.WALK] = self.xmlFile:getValue( "vehicle.rideable#speedWalk" , 2.5 )
    spec.topSpeeds[ Rideable.GAITTYPES.CANTER] = self.xmlFile:getValue( "vehicle.rideable#speedCanter" , 3.5 )
    spec.topSpeeds[ Rideable.GAITTYPES.TROT] = self.xmlFile:getValue( "vehicle.rideable#speedTrot" , 5.0 )
    spec.topSpeeds[ Rideable.GAITTYPES.GALLOP] = self.xmlFile:getValue( "vehicle.rideable#speedGallop" , 10.0 )
    spec.minTurnRadius = { }
    spec.minTurnRadius[ Rideable.GAITTYPES.BACKWARDS] = self.xmlFile:getValue( "vehicle.rideable#minTurnRadiusBackwards" , 1.0 )
    spec.minTurnRadius[ Rideable.GAITTYPES.STILL] = 1.0
    spec.minTurnRadius[ Rideable.GAITTYPES.WALK] = self.xmlFile:getValue( "vehicle.rideable#minTurnRadiusWalk" , 1.0 )
    spec.minTurnRadius[ Rideable.GAITTYPES.CANTER] = self.xmlFile:getValue( "vehicle.rideable#minTurnRadiusCanter" , 2.5 )
    spec.minTurnRadius[ Rideable.GAITTYPES.TROT] = self.xmlFile:getValue( "vehicle.rideable#minTurnRadiusTrot" , 5.0 )
    spec.minTurnRadius[ Rideable.GAITTYPES.GALLOP] = self.xmlFile:getValue( "vehicle.rideable#minTurnRadiusGallop" , 10.0 )
    spec.groundRaycastResult = { }
    spec.groundRaycastResult.y = 0.0
    spec.groundRaycastResult.object = nil
    spec.groundRaycastResult.distance = 0.0
    spec.haltTimer = 0.0
    spec.smoothedLeftRightWeight = 0.0
    spec.interpolationDt = 16
    spec.ridingTimer = 0
    spec.doHusbandryCheck = 0

    spec.proxy = self.xmlFile:getValue( "vehicle.rideable#proxy" , nil , self.components, self.i3dMappings)
    if spec.proxy ~ = nil then
        setRigidBodyType(spec.proxy, RigidBodyType.NONE)
    end
    spec.collisionMask = getCollisionFilterMask( self.components[ 1 ].node)

    -- interpolation
    -- spec.interpolationTime = InterpolationTime.new(1.0)
    -- spec.interpolatorPosition = InterpolatorPosition.new(0.0, 0.0, 0.0)
    -- spec.interpolatorQuaternion = InterpolatorQuaternion.new(0.0, 0.0, 0.0, 1.0) -- only used on server side for rotation of camera
        -- spec.interpolatorOnGround = InterpolatorValue.new(0.0)

        -- steer
        spec.maxAcceleration = 5 -- m/s^2
        spec.maxDeceleration = 10 -- m/s^2
        spec.gravity = - 9.81

        -- ground orientation
        spec.frontCheckDistance = 0.0
        spec.backCheckDistance = 0.0
        spec.isOnGround = true
        spec.isCloseToGround = true

        assert(spec.topSpeeds[ Rideable.GAITTYPES.MIN] < spec.topSpeeds[ Rideable.GAITTYPES.MAX])
        spec.maxTurnSpeed = self.xmlFile:getValue( "vehicle.rideable#turnSpeed" , 45.0 ) -- xml:deg/s, script:rad/s
        spec.jumpHeight = self.xmlFile:getValue( "vehicle.rideable#jumpHeight" , 2.0 )

        local function loadHoof(target, index, key)
            local hoof = { }
            hoof.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            hoof.onGround = false

            local nodeSlow = self.xmlFile:getValue(key .. ".particleSystemSlow#node" , nil , self.components, self.i3dMappings)
            local particleType = self.xmlFile:getValue(key .. ".particleSystemSlow#particleType" )
            if particleType = = nil then
                Logging.xmlWarning( self.xmlFile, "Missing horse step slow particleType in '%s'" , key .. ".particleSystemSlow" )
                return
            end
            local particleSystem = g_particleSystemManager:getParticleSystem(particleType)
            if particleSystem ~ = nil then
                hoof.psSlow = ParticleUtil.copyParticleSystem( self.xmlFile, key .. ".particleSystemSlow" , particleSystem, nodeSlow)
                link(getRootNode(), hoof.psSlow.emitterShape)
            end

            local nodeFast = self.xmlFile:getValue(key .. ".particleSystemFast#node" , nil , self.components, self.i3dMappings)
            local particleTypeFast = self.xmlFile:getValue(key .. ".particleSystemFast#particleType" )
            if particleTypeFast = = nil then
                Logging.xmlWarning( self.xmlFile, "Missing horse step fast particleType in '%s'" , key .. ".particleSystemFast" )
                return
            end
            local particleSystemFast = g_particleSystemManager:getParticleSystem(particleTypeFast)
            if particleSystemFast ~ = nil then
                hoof.psFast = ParticleUtil.copyParticleSystem( self.xmlFile, key .. ".particleSystemFast" , particleSystemFast, nodeFast)
                link(getRootNode(), hoof.psFast.emitterShape)
            end

            target[index] = hoof
        end

        -- Hooves
        spec.hooves = { }
        loadHoof(spec.hooves, Rideable.HOOVES.FRONT_LEFT, "vehicle.rideable.modelInfo.hoofFrontLeft" )
        loadHoof(spec.hooves, Rideable.HOOVES.FRONT_RIGHT, "vehicle.rideable.modelInfo.hoofFrontRight" )
        loadHoof(spec.hooves, Rideable.HOOVES.BACK_LEFT, "vehicle.rideable.modelInfo.hoofBackLeft" )
        loadHoof(spec.hooves, Rideable.HOOVES.BACK_RIGHT, "vehicle.rideable.modelInfo.hoofBackRight" )

        spec.frontCheckDistance = self:calculateLegsDistance(spec.hooves[ Rideable.HOOVES.FRONT_LEFT].node, spec.hooves[ Rideable.HOOVES.FRONT_RIGHT].node)
        spec.backCheckDistance = self:calculateLegsDistance(spec.hooves[ Rideable.HOOVES.BACK_LEFT].node, spec.hooves[ Rideable.HOOVES.BACK_RIGHT].node)

        spec.animationNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#animationNode" , nil , self.components, self.i3dMappings)
        spec.meshNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#meshNode" , nil , self.components, self.i3dMappings)
        spec.equipmentNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#equipmentNode" , nil , self.components, self.i3dMappings)
        spec.reinsNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#reinsNode" , nil , self.components, self.i3dMappings)
        spec.leftReinNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#reinLeftNode" , nil , self.components, self.i3dMappings)
        spec.rightReinNode = self.xmlFile:getValue( "vehicle.rideable.modelInfo#reinRightNode" , nil , self.components, self.i3dMappings)
        spec.leftReinParentNode = getParent(spec.leftReinNode)
        spec.rightReinParentNode = getParent(spec.rightReinNode)

        -- animation
        if spec.animationNode ~ = nil then
            spec.charsetId = getAnimCharacterSet(spec.animationNode)
            local animationPlayer = createConditionalAnimation()
            if animationPlayer ~ = 0 then
                spec.animationPlayer = animationPlayer
                for key, parameter in pairs(spec.animationParameters) do
                    conditionalAnimationRegisterParameter(spec.animationPlayer, parameter.id, parameter.type , key)
                end
                initConditionalAnimation(spec.animationPlayer, spec.charsetId, self.configFileName, "vehicle.conditionalAnimation" )
                setConditionalAnimationSpecificParameterIds(spec.animationPlayer, spec.animationParameters.absForwardVelocity.id, spec.animationParameters.absYawVelocity.id)
            end
        end

        -- Sounds
        spec.surfaceSounds = { }
        spec.surfaceIdToSound = { }
        spec.surfaceNameToSound = { }
        spec.currentSurfaceSound = nil
        local mission = g_currentMission
        for _, surfaceSound in pairs(mission.surfaceSounds) do
            if surfaceSound.type = = "hoofstep" and surfaceSound.sample ~ = nil then
                local sample = g_soundManager:cloneSample(surfaceSound.sample, self.components[ 1 ].node, self )
                sample.sampleName = surfaceSound.name

                table.insert(spec.surfaceSounds, sample)
                spec.surfaceIdToSound[surfaceSound.materialId] = sample
                spec.surfaceNameToSound[surfaceSound.name] = sample
            end
        end
        spec.horseStopSound = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.rideable.sounds" , "halt" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.horseBreathSoundsNoEffort = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.rideable.sounds" , "breathingNoEffort" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.horseBreathSoundsEffort = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.rideable.sounds" , "breathingEffort" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.horseBreathIntervalNoEffort = self.xmlFile:getValue( "vehicle.rideable.sounds#breathIntervalNoEffort" , 1.0 ) * 1000.0
        spec.horseBreathIntervalEffort = self.xmlFile:getValue( "vehicle.rideable.sounds#breathIntervalEffort" , 1.0 ) * 1000.0
        spec.horseBreathMinIntervalIdle = self.xmlFile:getValue( "vehicle.rideable.sounds#minBreathIntervalIdle" , 1.0 ) * 1000.0
        spec.horseBreathMaxIntervalIdle = self.xmlFile:getValue( "vehicle.rideable.sounds#maxBreathIntervalIdle" , 1.0 ) * 1000.0
        spec.currentBreathTimer = 0.0

        -- attributes set by action events
        spec.inputValues = { }
        spec.inputValues.axisSteer = 0.0
        spec.inputValues.axisSteerSend = 0.0
        spec.inputValues.currentGait = Rideable.GAITTYPES.STILL
        self:resetInputs()

        spec.interpolatorIsOnGround = InterpolatorValue.new( 0.0 )
        if self.isServer then
            spec.interpolatorTurnAngle = InterpolatorAngle.new( 0.0 )
            self.networkTimeInterpolator.maxInterpolationAlpha = 1.2
        end

        -- Network
        spec.dirtyFlag = self:getNextDirtyFlag()

        if savegame ~ = nil then
            local xmlFile = savegame.xmlFile
            local key = savegame.key .. ".rideable"

            local subTypeName = xmlFile:getString(key .. "#subType" , "HORSE_GRAY" )
            local subType = mission.animalSystem:getSubTypeByName(subTypeName)
            if subType ~ = nil then
                local cluster = mission.animalSystem:createClusterFromSubTypeIndex(subType.subTypeIndex)
                cluster:loadFromXMLFile(xmlFile, key .. ".animal" )
                self:setCluster(cluster)
            else
                    Logging.xmlError( self.xmlFile, "Animal sub type '%s' not found for '%s'!" , subTypeName, key)
                        self:setLoadingState(VehicleLoadingState.ERROR)
                        return
                    end
                end

                mission.husbandrySystem:addRideable( self )

                self.needWaterInfo = true
            end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Code**

```lua
function Rideable:onLoadFinished()
    self:raiseActive()
end

```

### onReadPositionUpdateStream

**Description**

**Definition**

> onReadPositionUpdateStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function Rideable:onReadPositionUpdateStream(streamId, connection)
    local spec = self.spec_rideable
    local isOnGround = streamReadBool(streamId)
    if isOnGround then
        spec.interpolatorIsOnGround:setValue( 1.0 )
    else
            spec.interpolatorIsOnGround:setValue( 0.0 )
        end
    end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function Rideable:onReadStream(streamId, connection)
    local spec = self.spec_rideable
    if connection:getIsServer() then
        local isOnGround = streamReadBool(streamId)
        if isOnGround then
            spec.interpolatorIsOnGround:setValue( 1.0 )
        else
                spec.interpolatorIsOnGround:setValue( 0.0 )
            end
        end
        if streamReadBool(streamId) then
            local subTypeIndex = streamReadUIntN(streamId, AnimalCluster.NUM_BITS_SUB_TYPE)
            local mission = g_currentMission
            local cluster = mission.animalSystem:createClusterFromSubTypeIndex(subTypeIndex)
            cluster:readStream(streamId, connection)
            self:setCluster(cluster)
        end
        if streamReadBool(streamId) then
            local player = NetworkUtil.readNodeObject(streamId)
            self:setPlayerToEnter(player)
        end
    end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Rideable:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_rideable

    if not connection:getIsServer() then
        spec.inputValues.axisSteer = streamReadFloat32(streamId)
        spec.inputValues.currentGait = streamReadUInt8(streamId)
    else
            spec.haltTimer = streamReadFloat32(streamId)
            if spec.haltTimer > 0 then
                spec.inputValues.currentGait = Rideable.GAITTYPES.STILL
                spec.inputValues.axisSteerSend = 0
            end

            if streamReadBool(streamId) then
                spec.cluster:readUpdateStream(streamId, connection)
                self:updateDirt()
            end
        end
    end

```

### onRegisterActionEvents

**Description**

> Registers action events

**Definition**

> onRegisterActionEvents()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function Rideable:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_rideable
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local _, actionEventId
            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_ACCELERATE_VEHICLE, self , Rideable.actionEventAccelerate, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            spec.acceletateEventId = actionEventId

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_BRAKE_VEHICLE, self , Rideable.actionEventBrake, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            spec.brakeEventId = actionEventId

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_MOVE_SIDE_VEHICLE, self , Rideable.actionEventSteer, false , false , true , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            spec.steerEventId = actionEventId

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.JUMP, self , Rideable.actionEventJump, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            spec.jumpEventId = actionEventId
        end
    end
end

```

### onSetBroken

**Description**

**Definition**

> onSetBroken()

**Code**

```lua
function Rideable:onSetBroken()
    self:unlinkReins()

    if self.isServer then
        local husbandry = g_currentMission.husbandrySystem:getFirstAvailableHusbandry( self )
        local spec = self.spec_rideable

        local isInStable
        if husbandry ~ = nil then
            local cluster = self:getCluster()
            husbandry:addCluster(cluster)
            self:delete()

            isInStable = true
        else
                isInStable = false
            end

            if spec.lastOwner ~ = nil then
                spec.lastOwner:sendEvent( RideableStableNotificationEvent.new(isInStable, spec.cluster:getName()), nil , true )
            end
        end
    end

```

### onUpdate

**Description**

> Called on on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | delta time                                  |
|---------|------------------|---------------------------------------------|
| boolean | isActiveForInput | true if specializations is active for input |
| boolean | isSelected       | true if specializations is selected         |
| any     | isSelected       |                                             |

**Code**

```lua
function Rideable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_rideable

    if self:getIsSynchronized() and spec.playerToEnter ~ = nil and spec.checkPlayerToEnter then
        if spec.playerToEnter = = g_localPlayer then
            -- force entering as we are sure that the rideable is fully synced on client
            g_localPlayer:requestToEnterVehicle( self , true )
            spec.checkPlayerToEnter = false
        end
    end

    local isEntered = self:getIsEntered()
    if isEntered then
        if isActiveForInputIgnoreSelection then
            self:updateInputText()
        end
        if not self.isServer then
            spec.inputValues.axisSteerSend = spec.inputValues.axisSteer
            self:raiseDirtyFlags(spec.dirtyFlag)
            self:resetInputs()
        end
    end

    self:updateAnimation(dt)
    if self.isClient then
        self:updateSound(dt)
    end

    if self.isServer then
        self:updateRiding(dt)
    end

    if spec.haltTimer > 0 then
        self:setCurrentGait( Rideable.GAITTYPES.STILL)
        spec.haltTimer = spec.haltTimer - dt
    end

    -- steering based on mobile device orientation
    if self:getIsActiveForInput( true ) then
        local inputHelpMode = g_inputBinding:getInputHelpMode()
        if inputHelpMode ~ = GS_INPUT_HELP_MODE_GAMEPAD or GS_PLATFORM_SWITCH then
            if g_gameSettings:getValue(GameSettings.SETTING.GYROSCOPE_STEERING) then
                local dx, dy, dz = getGravityDirection()
                local steeringValue = MathUtil.getSteeringAngleFromDeviceGravity(dx, dy, dz)

                self:setRideableSteer(steeringValue)
            end
        end
    end

    if self.isServer and spec.doHusbandryCheck > 0 then
        spec.doHusbandryCheck = spec.doHusbandryCheck - dt
        -- check if rideable is near husbandry
            local mission = g_currentMission
            local isInRange, husbandry = mission.husbandrySystem:getHusbandryInRideableRange( self )

            if isInRange then
                local isInStable
                if husbandry ~ = nil then
                    local cluster = self:getCluster()
                    husbandry:addCluster(cluster)
                    self:delete()

                    isInStable = true
                else
                        isInStable = false
                    end

                    if spec.lastOwner ~ = nil then
                        spec.lastOwner:sendEvent( RideableStableNotificationEvent.new(isInStable, spec.cluster:getName()), nil , true )
                    end
                end
                spec.lastOwner = nil
            end
        end

```

### onUpdateInterpolation

**Description**

**Definition**

> onUpdateInterpolation()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Rideable:onUpdateInterpolation(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_rideable

    if self.isServer then
        if not self:getIsControlled() then
            self:setCurrentGait( Rideable.GAITTYPES.STILL)
        end
        -- for key, moveInfo in pairs(spec.cctMoveQueue) do
            -- print(string.format("-- [Rideable:onUpdateInterpolation][A][%d]\t%d\t%d\t%d\t%s\t%.6f", g_updateLoopIndex, getPhysicsUpdateIndex(), key, moveInfo.physicsIndex, tostring(getIsPhysicsUpdateIndexSimulated(moveInfo.physicsIndex)), moveInfo.dt))
            -- end

            local interpolationDt = dt
            local oldestMoveInfo = spec.cctMoveQueue[ 1 ]
            if oldestMoveInfo ~ = nil and getIsPhysicsUpdateIndexSimulated(oldestMoveInfo.physicsIndex) then
                interpolationDt = oldestMoveInfo.dt
            end
            spec.interpolationDt = interpolationDt

            self:testCCTMove(interpolationDt)
            self:updateKinematic(dt)

            if self:getIsEntered() then
                self:resetInputs()
            end

            local component = self.components[ 1 ]
            local x,y,z = self:getCCTWorldTranslation()
            component.networkInterpolators.position:setTargetPosition(x,y,z)
            spec.interpolatorTurnAngle:setTargetAngle(spec.currentTurnAngle)
            spec.interpolatorIsOnGround:setTargetValue( self:getIsCCTOnGround() and 1.0 or 0.0 )

            -- use 75 or if dt > 75 then dt + 20
                local phaseDuration = interpolationDt + 30

                self.networkTimeInterpolator:startNewPhase(phaseDuration)
                self.networkTimeInterpolator:update(interpolationDt)

                -- local deltax, deltay, deltaz = component.networkInterpolators.position.targetPositionX - component.networkInterpolators.position.lastPositionX, component.networkInterpolators.position.targetPositionY - component.networkInterpolators.position.lastPositionY, component.networkInterpolators.position.targetPositionZ - component.networkInterpolators.position.lastPositionZ
                -- local deltamag = math.sqrt(deltax*deltax+deltay*deltay+deltaz*deltaz)
                -- print(string.format("-- [Rideable:onUpdateInterpolation][B][%d]\t%.6f\t%.6f\t%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f", g_updateLoopIndex, dt, interpolationDt, getPhysicsUpdateIndex(), self.networkTimeInterpolator.interpolationAlpha, self.networkTimeInterpolator.interpolationDuration, component.networkInterpolators.position.targetPositionX, component.networkInterpolators.position.targetPositionY, component.networkInterpolators.position.targetPositionZ, component.networkInterpolators.position.lastPositionX, component.networkInterpolators.position.lastPositionY, component.networkInterpolators.position.lastPositionZ, deltax, deltay, deltaz, deltamag))

                x, y, z = component.networkInterpolators.position:getInterpolatedValues( self.networkTimeInterpolator.interpolationAlpha)
                setTranslation( self.rootNode, x, y, z)

                local turnAngle = spec.interpolatorTurnAngle:getInterpolatedValue( self.networkTimeInterpolator.interpolationAlpha)
                local _, dirY, _ = localDirectionToWorld( self.rootNode, 0.0 , 0.0 , 1.0 )
                local dirX, dirZ = math.sin(turnAngle), math.cos(turnAngle)

                -- rescale direction to length, keeping the original y(but keep it to some reasonable value)
                local scale = math.sqrt( 1 - math.min(dirY * dirY, 0.9 ))
                dirX = dirX * scale
                dirZ = dirZ * scale
                setDirection( self.rootNode, dirX, dirY, dirZ, 0 , 1 , 0 )
            end

            if not self:getIsEntered() then
                if spec.leaveTimer > 0 then
                    spec.leaveTimer = spec.leaveTimer - dt
                    self:raiseActive()
                end
            end

            local isOnGroundFloat = spec.interpolatorIsOnGround:getInterpolatedValue( self.networkTimeInterpolator:getAlpha())
            spec.isOnGround = isOnGroundFloat > 0.9
            spec.isCloseToGround = false

            if spec.isOnGround and( math.abs(spec.currentSpeed) > 0.001 or math.abs(spec.currentTurnSpeed) > 0.001 ) then
                -- orientation from ground
                local posX, posY, posZ = getWorldTranslation( self.rootNode)
                local dirX, dirY, dirZ = localDirectionToWorld( self.rootNode, 0.0 , 0.0 , 1.0 )
                local fx, fy, fz = posX + dirX * spec.frontCheckDistance, posY + dirY * spec.frontCheckDistance, posZ + dirZ * spec.frontCheckDistance
                spec.groundRaycastResult.y = fy + Rideable.GROUND_RAYCAST_OFFSET - Rideable.GROUND_RAYCAST_MAXDISTANCE
                raycastAll(fx, fy + Rideable.GROUND_RAYCAST_OFFSET, fz, 0.0 , - 1.0 , 0.0 , Rideable.GROUND_RAYCAST_MAXDISTANCE, "groundRaycastCallback" , self , Rideable.GROUND_RAYCAST_COLLISIONMASK)
                fy = spec.groundRaycastResult.y
                local bx, by, bz = posX + dirX * spec.backCheckDistance, posY + dirY * spec.backCheckDistance, posZ + dirZ * spec.backCheckDistance
                spec.groundRaycastResult.y = by + Rideable.GROUND_RAYCAST_OFFSET - Rideable.GROUND_RAYCAST_MAXDISTANCE
                raycastAll(bx, by + Rideable.GROUND_RAYCAST_OFFSET, bz, 0.0 , - 1.0 , 0.0 , Rideable.GROUND_RAYCAST_MAXDISTANCE, "groundRaycastCallback" , self , Rideable.GROUND_RAYCAST_COLLISIONMASK)
                by = spec.groundRaycastResult.y
                local dx, dy, dz = fx - bx, fy - by, fz - bz
                setDirection( self.rootNode, dx, dy, dz, 0 , 1 , 0 )
            else
                    local posX, posY, posZ = getWorldTranslation( self.rootNode)
                    spec.groundRaycastResult.distance = Rideable.GROUND_RAYCAST_MAXDISTANCE
                    raycastAll(posX, posY, posZ, 0.0 , - 1.0 , 0.0 , Rideable.GROUND_RAYCAST_MAXDISTANCE, "groundRaycastCallback" , self , Rideable.GROUND_RAYCAST_COLLISIONMASK)
                    spec.isCloseToGround = spec.groundRaycastResult.distance < 1.25
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
function Rideable:onVehicleCharacterChanged(character)
    if character ~ = nil then
        if self.isClient then
            local spec = self.spec_rideable
            link(character.playerModel.thirdPersonLeftHandNode, spec.leftReinNode)
            link(character.playerModel.thirdPersonRightHandNode, spec.rightReinNode)
            setVisibility(spec.reinsNode, true )

            if character ~ = nil and character.animationCharsetId ~ = nil and character.animationPlayer ~ = nil then
                for key, parameter in pairs(spec.animationParameters) do
                    conditionalAnimationRegisterParameter(character.animationPlayer, parameter.id, parameter.type , key)
                end
                initConditionalAnimation(character.animationPlayer, character.animationCharsetId, self.configFileName, "vehicle.riderConditionalAnimation" )
                setConditionalAnimationSpecificParameterIds(character.animationPlayer, spec.animationParameters.absForwardVelocity.id, spec.animationParameters.absYawVelocity.id)

                self:setEquipmentVisibility( true )
                conditionalAnimationZeroiseTrackTimes(character.animationPlayer)
                conditionalAnimationZeroiseTrackTimes(spec.animationPlayer)
            end

            if self:getIsControlled() then
                local mission = g_currentMission
                if mission.hud.fadeScreenElement:getAlpha() > 0.0 then
                    mission:fadeScreen( - 1 , spec.fadeDuration, self.endFade, self )
                end
            end
        end
    end
end

```

### onWritePositionUpdateStream

**Description**

**Definition**

> onWritePositionUpdateStream(integer streamId, Connection connection, )

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |
| any        | dirtyMask  |            |

**Code**

```lua
function Rideable:onWritePositionUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_rideable
    streamWriteBool(streamId, spec.isOnGround)
end

```

### onWriteStream

**Description**

> Called on client side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function Rideable:onWriteStream(streamId, connection)
    local spec = self.spec_rideable
    if not connection:getIsServer() then
        streamWriteBool(streamId, spec.isOnGround)
    end
    if streamWriteBool(streamId, spec.cluster ~ = nil ) then
        streamWriteUIntN(streamId, spec.cluster:getSubTypeIndex(), AnimalCluster.NUM_BITS_SUB_TYPE)
        spec.cluster:writeStream(streamId, connection)
    end
    if streamWriteBool(streamId, spec.playerToEnter ~ = nil ) then
        NetworkUtil.writeNodeObject(streamId, spec.playerToEnter)
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Rideable:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_rideable
    if connection:getIsServer() then
        streamWriteFloat32(streamId, spec.inputValues.axisSteerSend)
        streamWriteUInt8(streamId, spec.inputValues.currentGait)
    else
            streamWriteFloat32(streamId, spec.haltTimer)

            if streamWriteBool(streamId, spec.cluster ~ = nil ) then
                spec.cluster:writeUpdateStream(streamId, connection)
            end
        end
    end

```

### periodChanged

**Description**

**Definition**

> periodChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Rideable:periodChanged(superFunc)
    superFunc( self )

    local spec = self.spec_rideable
    if spec.cluster ~ = nil then
        spec.cluster:onPeriodChanged()
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
function Rideable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( CCTDrivable , specializations)
end

```

### registerEventListeners

**Description**

> Registers event listeners

**Definition**

> registerEventListeners(table vehicleType)

**Arguments**

| table | vehicleType | type of vehicle |
|-------|-------------|-----------------|

**Code**

```lua
function Rideable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadPositionUpdateStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onWritePositionUpdateStream" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateInterpolation" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onSetBroken" , Rideable )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleCharacterChanged" , Rideable )
end

```

### registerFunctions

**Description**

> Registers functions

**Definition**

> registerFunctions(table vehicleType)

**Arguments**

| table | vehicleType | type of vehicle |
|-------|-------------|-----------------|

**Code**

```lua
function Rideable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getIsRideableJumpAllowed" , Rideable.getIsRideableJumpAllowed)
    SpecializationUtil.registerFunction(vehicleType, "jump" , Rideable.jump)
    SpecializationUtil.registerFunction(vehicleType, "setCurrentGait" , Rideable.setCurrentGait)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentGait" , Rideable.getCurrentGait)
    SpecializationUtil.registerFunction(vehicleType, "setRideableSteer" , Rideable.setRideableSteer)
    SpecializationUtil.registerFunction(vehicleType, "resetInputs" , Rideable.resetInputs)
    SpecializationUtil.registerFunction(vehicleType, "updateKinematic" , Rideable.updateKinematic)
    SpecializationUtil.registerFunction(vehicleType, "testCCTMove" , Rideable.testCCTMove)
    SpecializationUtil.registerFunction(vehicleType, "updateAnimation" , Rideable.updateAnimation)
    SpecializationUtil.registerFunction(vehicleType, "updateSound" , Rideable.updateSound)
    SpecializationUtil.registerFunction(vehicleType, "updateRiding" , Rideable.updateRiding)
    SpecializationUtil.registerFunction(vehicleType, "updateDirt" , Rideable.updateDirt)
    SpecializationUtil.registerFunction(vehicleType, "calculateLegsDistance" , Rideable.calculateLegsDistance)
    SpecializationUtil.registerFunction(vehicleType, "setWorldPositionQuat" , Rideable.setWorldPositionQuat)
    SpecializationUtil.registerFunction(vehicleType, "updateFootsteps" , Rideable.updateFootsteps)
    SpecializationUtil.registerFunction(vehicleType, "getPosition" , Rideable.getPosition)
    SpecializationUtil.registerFunction(vehicleType, "getRotation" , Rideable.getRotation)
    SpecializationUtil.registerFunction(vehicleType, "setEquipmentVisibility" , Rideable.setEquipmentVisibility)
    SpecializationUtil.registerFunction(vehicleType, "getHoofSurfaceSound" , Rideable.getHoofSurfaceSound)
    SpecializationUtil.registerFunction(vehicleType, "groundRaycastCallback" , Rideable.groundRaycastCallback)
    SpecializationUtil.registerFunction(vehicleType, "unlinkReins" , Rideable.unlinkReins)
    SpecializationUtil.registerFunction(vehicleType, "updateInputText" , Rideable.updateInputText)
    SpecializationUtil.registerFunction(vehicleType, "setPlayerToEnter" , Rideable.setPlayerToEnter)
    SpecializationUtil.registerFunction(vehicleType, "endFade" , Rideable.endFade)
    SpecializationUtil.registerFunction(vehicleType, "setCluster" , Rideable.setCluster)
    SpecializationUtil.registerFunction(vehicleType, "getCluster" , Rideable.getCluster)
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
function Rideable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPosition" , Rideable.setWorldPosition)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPositionQuaternion" , Rideable.setWorldPositionQuaternion)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateVehicleSpeed" , Rideable.updateVehicleSpeed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getName" , Rideable.getName)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFullName" , Rideable.getFullName)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeReset" , Rideable.getCanBeReset)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMapHotspotRotation" , Rideable.getMapHotspotRotation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShowInVehiclesOverview" , Rideable.getShowInVehiclesOverview)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "periodChanged" , Rideable.periodChanged)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "dayChanged" , Rideable.dayChanged)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getImageFilename" , Rideable.getImageFilename)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "showInfo" , Rideable.showInfo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "deleteVehicleCharacter" , Rideable.deleteVehicleCharacter)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSold" , Rideable.getCanBeSold)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getInteractionHelp" , Rideable.getInteractionHelp)
end

```

### resetInputs

**Description**

> Resets all inputs

**Definition**

> resetInputs()

**Code**

```lua
function Rideable:resetInputs()
    local spec = self.spec_rideable
    spec.inputValues.axisSteer = 0
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function Rideable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_rideable

    if spec.cluster ~ = nil then
        local mission = g_currentMission
        local animalSystem = mission.animalSystem
        local subTypeIndex = spec.cluster:getSubTypeIndex()
        local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
        xmlFile:setString(key .. "#subType" , subType.name)
        spec.cluster:saveToXMLFile(xmlFile, key .. ".animal" , usedModNames)
    end
end

```

### setCluster

**Description**

**Definition**

> setCluster()

**Arguments**

| any | cluster |
|-----|---------|

**Code**

```lua
function Rideable:setCluster(cluster)
    local spec = self.spec_rideable
    spec.cluster = cluster

    if cluster ~ = nil then
        -- set texture
        local mission = g_currentMission
        local animalSystem = mission.animalSystem
        local subTypeIndex = cluster:getSubTypeIndex()
        local visual = animalSystem:getVisualByAge(subTypeIndex, cluster:getAge())
        local variation = visual.visualAnimal.variations[ 1 ]
        local tileU = variation.tileUIndex / variation.numTilesU
        local tileV = variation.tileVIndex / variation.numTilesV

        I3DUtil.setShaderParameterRec(spec.meshNode, "atlasInvSizeAndOffsetUV" , nil , nil , tileU, tileV)

        self:updateDirt()
    end
end

```

### setCurrentGait

**Description**

**Definition**

> setCurrentGait()

**Arguments**

| any | gait |
|-----|------|

**Code**

```lua
function Rideable:setCurrentGait(gait)
    local spec = self.spec_rideable
    spec.inputValues.currentGait = gait
end

```

### setEquipmentVisibility

**Description**

> Called on leaving the vehicle

**Definition**

> setEquipmentVisibility()

**Arguments**

| any | val |
|-----|-----|

**Code**

```lua
function Rideable:setEquipmentVisibility(val)
    if self.isClient then
        local spec = self.spec_rideable

        if spec.equipmentNode ~ = nil then
            setVisibility(spec.equipmentNode, val)
            setVisibility(spec.reinsNode, val)
        end
    end
end

```

### setPlayerToEnter

**Description**

**Definition**

> setPlayerToEnter()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function Rideable:setPlayerToEnter(player)
    local spec = self.spec_rideable
    spec.playerToEnter = player
    spec.checkPlayerToEnter = true
    self:raiseActive()
end

```

### setRideableSteer

**Description**

**Definition**

> setRideableSteer()

**Arguments**

| any | axisSteer |
|-----|-----------|

**Code**

```lua
function Rideable:setRideableSteer(axisSteer)
    local spec = self.spec_rideable
    if axisSteer ~ = 0 then
        spec.inputValues.axisSteer = - axisSteer
    end
end

```

### setWorldPosition

**Description**

**Definition**

> setWorldPosition()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | x            |
| any | y            |
| any | z            |
| any | xRot         |
| any | yRot         |
| any | zRot         |
| any | i            |
| any | changeInterp |

**Code**

```lua
function Rideable:setWorldPosition(superFunc, x,y,z, xRot,yRot,zRot, i, changeInterp)
    superFunc( self , x,y,z, xRot,yRot,zRot, i, changeInterp)
    if self.isServer and i = = 1 then
        local spec = self.spec_rideable
        local dx, _, dz = localDirectionToWorld( self.rootNode, 0 , 0 , 1 )
        spec.currentTurnAngle = MathUtil.getYRotationFromDirection(dx, dz)
        if changeInterp then
            spec.interpolatorTurnAngle:setAngle(spec.currentTurnAngle)
        end
    end
end

```

### setWorldPositionQuat

**Description**

> Set world position and quaternion rotation of component

**Definition**

> setWorldPositionQuat(float x, float y, float z, float qx, float qy, float qz, float qw, integer i, boolean
> changeInterp)

**Arguments**

| float   | x            | x position           |
|---------|--------------|----------------------|
| float   | y            | y position           |
| float   | z            | z position           |
| float   | qx           | x rotation           |
| float   | qy           | y rotation           |
| float   | qz           | z rotation           |
| float   | qw           | w rotation           |
| integer | i            | index if component   |
| boolean | changeInterp | change interpolation |

**Code**

```lua
function Rideable:setWorldPositionQuat(x,y,z, qx,qy,qz,qw, changeInterp)
    setWorldTranslation( self.rootNode, x,y,z)
    setWorldQuaternion( self.rootNode, qx,qy,qz,qw)
    if changeInterp then
        local spec = self.spec_rideable
        spec.networkInterpolators.position:setPosition(x,y,z)
        spec.networkInterpolators.quaternion:setQuaternion(qx, qy, qz, qw)
    end
end

```

### setWorldPositionQuaternion

**Description**

**Definition**

> setWorldPositionQuaternion()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | x            |
| any | y            |
| any | z            |
| any | qx           |
| any | qy           |
| any | qz           |
| any | qw           |
| any | i            |
| any | changeInterp |

**Code**

```lua
function Rideable:setWorldPositionQuaternion(superFunc, x, y, z, qx, qy, qz, qw, i, changeInterp)
    superFunc( self , x, y, z, qx, qy, qz, qw, i, changeInterp)
    if self.isServer and i = = 1 then
        local spec = self.spec_rideable
        local dx, _, dz = localDirectionToWorld( self.rootNode, 0 , 0 , 1 )
        spec.currentTurnAngle = MathUtil.getYRotationFromDirection(dx, dz)
        if changeInterp then
            spec.interpolatorTurnAngle:setAngle(spec.currentTurnAngle)
        end
    end
end

```

### showInfo

**Description**

**Definition**

> showInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | box       |

**Code**

```lua
function Rideable:showInfo(superFunc, box)
    local spec = self.spec_rideable

    if spec.cluster ~ = nil then
        spec.cluster:showInfo(box)
    end

    superFunc( self , box)
end

```

### testCCTMove

**Description**

> Check if a requested CCT move was successful. We need a range for the error because of possible huge fps fluctuation.

**Definition**

> testCCTMove()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Rideable:testCCTMove(dt)
    local spec = self.spec_rideable
    spec.lastCCTPosX, spec.lastCCTPosY, spec.lastCCTPosZ = spec.currentCCTPosX, spec.currentCCTPosY, spec.currentCCTPosZ
    spec.currentCCTPosX, spec.currentCCTPosY, spec.currentCCTPosZ = getWorldTranslation( self.spec_cctdrivable.cctNode)

    local expectedMovementX, expectedMovementZ = 0 , 0

    while spec.cctMoveQueue[ 1 ] ~ = nil and getIsPhysicsUpdateIndexSimulated(spec.cctMoveQueue[ 1 ].physicsIndex) do
        expectedMovementX = expectedMovementX + spec.cctMoveQueue[ 1 ].moveX
        expectedMovementZ = expectedMovementZ + spec.cctMoveQueue[ 1 ].moveZ
        table.remove(spec.cctMoveQueue, 1 )
    end

    local expectedMovement = math.sqrt(expectedMovementX * expectedMovementX + expectedMovementZ * expectedMovementZ)
    if expectedMovement > 0.001 * dt then -- only check if we are supposed to move faster than 3.6km/h
        local movementX = spec.currentCCTPosX - spec.lastCCTPosX
        local movementZ = spec.currentCCTPosZ - spec.lastCCTPosZ
        local movement = math.sqrt(movementX * movementX + movementZ * movementZ)
        if movement < = expectedMovement * 0.7 and spec.haltTimer < = 0.0 then
            -- print(string.format("-- [Rideable:testCCTMove][%d] movement(%.3f), expectedMovement(%.3f) haltTimer(%.3f)", g_updateLoopIndex, movement, expectedMovement, spec.haltTimer))
            self:setCurrentGait( Rideable.GAITTYPES.STILL)
            spec.haltTimer = 900
            if spec.horseStopSound ~ = nil then
                g_soundManager:playSample(spec.horseStopSound)
            end
        end
    end
end

```

### unlinkReins

**Description**

**Definition**

> unlinkReins()

**Code**

```lua
function Rideable:unlinkReins()
    if self.isClient then
        local spec = self.spec_rideable

        link(spec.leftReinParentNode, spec.leftReinNode)
        link(spec.rightReinParentNode, spec.rightReinNode)
        setVisibility(spec.reinsNode, false )
    end
end

```

### updateAnimation

**Description**

> Updates the parameters that will drive the animation

**Definition**

> updateAnimation(float dt)

**Arguments**

| float | dt | delta time in ms |
|-------|----|------------------|

**Code**

```lua
function Rideable:updateAnimation(dt)
    local spec = self.spec_rideable
    local params = spec.animationParameters
    local speed = self.lastSignedSpeedReal * 1000.0
    local smoothedSpeed = self.lastSignedSpeed * 1000.0
    speed = math.clamp(speed, spec.topSpeeds[ Rideable.GAITTYPES.BACKWARDS], spec.topSpeeds[ Rideable.GAITTYPES.MAX])
    smoothedSpeed = math.clamp(smoothedSpeed, spec.topSpeeds[ Rideable.GAITTYPES.BACKWARDS], spec.topSpeeds[ Rideable.GAITTYPES.MAX])

    local turnSpeed
    if self.isServer then
        turnSpeed = (spec.interpolatorTurnAngle.targetValue - spec.interpolatorTurnAngle.lastValue) / ( self.networkTimeInterpolator.interpolationDuration * 0.001 )
    else
            local interpQuat = self.components[ 1 ].networkInterpolators.quaternion
            local lastDirX, _, lastDirZ = mathQuaternionRotateVector(interpQuat.lastQuaternionX, interpQuat.lastQuaternionY, interpQuat.lastQuaternionZ, interpQuat.lastQuaternionW, 0 , 0 , 1 )
            local targetDirX, _, targetDirZ = mathQuaternionRotateVector(interpQuat.targetQuaternionX, interpQuat.targetQuaternionY, interpQuat.targetQuaternionZ, interpQuat.targetQuaternionW, 0 , 0 , 1 )
            local lastTurnAngle = MathUtil.getYRotationFromDirection(lastDirX, lastDirZ)
            local targetTurnAngle = MathUtil.getYRotationFromDirection(targetDirX, targetDirZ)
            local turnAngleDiff = targetTurnAngle - lastTurnAngle
            -- normalize to -180,180deg
            if turnAngleDiff > math.pi then
                turnAngleDiff = turnAngleDiff - 2 * math.pi
            elseif turnAngleDiff < - math.pi then
                    turnAngleDiff = turnAngleDiff + 2 * math.pi
                end
                turnSpeed = turnAngleDiff / ( self.networkTimeInterpolator.interpolationDuration * 0.001 )
            end

            local interpPos = self.components[ 1 ].networkInterpolators.position
            local speedY = (interpPos.targetPositionY - interpPos.lastPositionY) / ( self.networkTimeInterpolator.interpolationDuration * 0.001 )

            local leftRightWeight
            if math.abs(speed) > 0.01 then
                local closestGait = Rideable.GAITTYPES.STILL
                local closestDiff = math.huge
                for i = 1 , Rideable.GAITTYPES.MAX do
                    local diff = math.abs(speed - spec.topSpeeds[i])
                    if diff < closestDiff then
                        closestGait = i
                        closestDiff = diff
                    end
                end
                local minTurnRadius = spec.minTurnRadius[closestGait]
                leftRightWeight = minTurnRadius * turnSpeed / speed
            else
                    leftRightWeight = turnSpeed / spec.maxTurnSpeed
                end
                if leftRightWeight < spec.smoothedLeftRightWeight then
                    spec.smoothedLeftRightWeight = math.max(leftRightWeight, spec.smoothedLeftRightWeight - 1 / 500 * dt, - 1 )
                else
                        spec.smoothedLeftRightWeight = math.min(leftRightWeight, spec.smoothedLeftRightWeight + 1 / 500 * dt, 1 )
                    end

                    -- print(string.format("-- [Rideable:updateAnimation][%d][%s]\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f", g_updateLoopIndex, tostring(self), dt, leftRightWeight, spec.smoothedLeftRightWeight, math.clamp(leftRightWeight, -1.0, 1.0), turnSpeed / spec.maxTurnSpeed, math.clamp(turnSpeed / spec.maxTurnSpeed, -1.0, 1.0), turnSpeed, speed, self.movingDirection, self.lastSpeedAcceleration * 1000 * 1000))

                    params.forwardVelocity.value = speed
                    params.absForwardVelocity.value = math.abs(speed)
                    params.verticalVelocity.value = speedY
                    params.yawVelocity.value = turnSpeed
                    params.absYawVelocity.value = math.abs(turnSpeed)
                    params.leftRightWeight.value = spec.smoothedLeftRightWeight
                    params.onGround.value = spec.isOnGround -- or spec.justSpawned
                    params.closeToGround.value = spec.isCloseToGround
                    params.inWater.value = self.isInWater
                    params.halted.value = spec.haltTimer > 0
                    params.smoothedForwardVelocity.value = smoothedSpeed
                    params.absSmoothedForwardVelocity.value = math.abs(smoothedSpeed)

                    -- horse animation
                    if spec.animationPlayer ~ = nil then
                        for _, parameter in pairs(params) do
                            if parameter.type = = 0 then
                                setConditionalAnimationBoolValue(spec.animationPlayer, parameter.id, parameter.value)
                            elseif parameter.type = = 1 then
                                    setConditionalAnimationFloatValue(spec.animationPlayer, parameter.id, parameter.value)
                                end
                            end
                            updateConditionalAnimation(spec.animationPlayer, dt)
                            -- local x,y,z = getWorldTranslation(self.rootNode)
                            -- conditionalAnimationDebugDraw(spec.animationPlayer, x,y,z)
                        end
                        local isEntered = self.getIsEntered ~ = nil and self:getIsEntered()
                        local isControlled = self.getIsControlled ~ = nil and self:getIsControlled()

                        if isEntered or isControlled then
                            -- rider animation
                            local character = self:getVehicleCharacter()
                            if character ~ = nil and character.animationCharsetId ~ = nil and character.animationPlayer ~ = nil then
                                for _, parameter in pairs(params) do
                                    if parameter.type = = 0 then
                                        setConditionalAnimationBoolValue(character.animationPlayer, parameter.id, parameter.value)
                                    elseif parameter.type = = 1 then
                                            setConditionalAnimationFloatValue(character.animationPlayer, parameter.id, parameter.value)
                                        end
                                    end
                                    updateConditionalAnimation(character.animationPlayer, dt)
                                    -- local x,y,z = getWorldTranslation(self.rootNode)
                                    -- conditionalAnimationDebugDraw(character.animationPlayer, x,y,z)
                                end
                            end
                            self:updateFootsteps(dt, math.abs(speed))
                        end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function Rideable:updateDebugValues(values)
    local spec = self.spec_rideable

    for k, hoofInfo in pairs(spec.hooves) do
        table.insert(values, { name = "hoof sample " .. k, value = hoofInfo.sampleDebug } )
    end
end

```

### updateDirt

**Description**

**Definition**

> updateDirt()

**Code**

```lua
function Rideable:updateDirt()
    local spec = self.spec_rideable
    local cluster = spec.cluster
    local dirtFactor = 0
    if Platform.gameplay.needHorseCleaning and cluster ~ = nil and cluster.getDirtFactor ~ = nil then
        dirtFactor = cluster:getDirtFactor()
    end
    I3DUtil.setShaderParameterRec(spec.meshNode, "dirt" , dirtFactor, nil , nil , nil )
end

```

### updateFootsteps

**Description**

**Definition**

> updateFootsteps()

**Arguments**

| any | dt    |
|-----|-------|
| any | speed |

**Code**

```lua
function Rideable:updateFootsteps(dt, speed)
    local spec = self.spec_rideable
    local epsilon = 0.001

    if speed > epsilon then
        local dirX, _, dirZ = localDirectionToWorld( self.rootNode, 0 , 0 , 1 )
        local rotY = MathUtil.getYRotationFromDirection(dirX, dirZ)
        for k, hoofInfo in pairs(spec.hooves) do
            local posX, posY, posZ = getWorldTranslation(hoofInfo.node)
            spec.groundRaycastResult.object = 0
            spec.groundRaycastResult.y = posY - 1
            raycastClosest(posX, posY + Rideable.GROUND_RAYCAST_OFFSET, posZ, 0.0 , - 1.0 , 0.0 , Rideable.GROUND_RAYCAST_MAXDISTANCE, "groundRaycastCallback" , self , Rideable.GROUND_RAYCAST_COLLISIONMASK)

            local hitTerrain = spec.groundRaycastResult.object = = g_terrainNode
            local terrainY = spec.groundRaycastResult.y
            local onGround = ((posY - terrainY) < 0.05 )

            -- DebugGizmo.renderAtNode(hoofInfo.node, string.format("[%s] (%.6f/%.6f|%s)", getName(hoofInfo.node), posY, terrainY, tostring(((posY - terrainY) < 0.05))))
            if onGround and not hoofInfo.onGround then
                local r, g, b, _, _ = getTerrainAttributesAtWorldPos(g_terrainNode, posX, posY, posZ, true , true , true , true , false )
                hoofInfo.onGround = true
                -- particles
                if spec.inputValues.currentGait < Rideable.GAITTYPES.CANTER then
                    if hoofInfo.psSlow ~ = nil and hoofInfo.psSlow.emitterShape ~ = nil then
                        ParticleUtil.resetNumOfEmittedParticles(hoofInfo.psSlow)
                        ParticleUtil.setEmittingState(hoofInfo.psSlow, true )
                        setShaderParameter(hoofInfo.psSlow.shape, "psColor" , r, g, b, 1 , false )

                        -- emittershapes are linked to world rootnode
                        setWorldTranslation(hoofInfo.psSlow.emitterShape, posX, terrainY, posZ)
                        setWorldRotation(hoofInfo.psSlow.emitterShape, 0 , rotY, 0 )
                    end
                else
                        if hoofInfo.psFast ~ = nil and hoofInfo.psFast.emitterShape ~ = nil then
                            ParticleUtil.resetNumOfEmittedParticles(hoofInfo.psFast)
                            ParticleUtil.setEmittingState(hoofInfo.psFast, true )
                            setShaderParameter(hoofInfo.psFast.shape, "psColor" , r, g, b, 1 , false )

                            -- emittershapes are linked to world rootnode
                            setWorldTranslation(hoofInfo.psFast.emitterShape, posX, terrainY, posZ)
                            setWorldRotation(hoofInfo.psSlow.emitterShape, 0 , rotY, 0 )
                        end
                    end

                    local sample = self:getHoofSurfaceSound(posX, posY, posZ, hitTerrain)
                    if sample ~ = nil then
                        hoofInfo.sampleDebug = string.format( "%s - %s" , sample.sampleName, sample.filename)
                        g_soundManager:playSample(sample)
                    end

                elseif not onGround and hoofInfo.onGround then
                        hoofInfo.onGround = false
                        if hoofInfo.psSlow ~ = nil and hoofInfo.psSlow.emitterShape ~ = nil then
                            ParticleUtil.setEmittingState(hoofInfo.psSlow, false )
                        end
                        if hoofInfo.psFast ~ = nil and hoofInfo.psFast.emitterShape ~ = nil then
                            ParticleUtil.setEmittingState(hoofInfo.psFast, false )
                        end
                    end
                end
            end
        end

```

### updateInputText

**Description**

**Definition**

> updateInputText()

**Code**

```lua
function Rideable:updateInputText()
    local spec = self.spec_rideable

    if spec.inputValues.currentGait = = Rideable.GAITTYPES.BACKWARDS then
        g_inputBinding:setActionEventText(spec.acceletateEventId, g_i18n:getText( "action_stop" ))
        g_inputBinding:setActionEventActive(spec.acceletateEventId, true )
        g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, true )

        g_inputBinding:setActionEventActive(spec.brakeEventId, false )
        g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, false )

        g_inputBinding:setActionEventActive(spec.jumpEventId, false )
        g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, false )
    elseif spec.inputValues.currentGait = = Rideable.GAITTYPES.STILL then
            g_inputBinding:setActionEventText(spec.acceletateEventId, g_i18n:getText( "action_walk" ))
            g_inputBinding:setActionEventActive(spec.acceletateEventId, true )
            g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, true )

            g_inputBinding:setActionEventText(spec.brakeEventId, g_i18n:getText( "action_walkBackwards" ))
            g_inputBinding:setActionEventActive(spec.brakeEventId, true )
            g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, true )

            g_inputBinding:setActionEventActive(spec.jumpEventId, false )
            g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, false )
        elseif spec.inputValues.currentGait = = Rideable.GAITTYPES.WALK then
                g_inputBinding:setActionEventText(spec.acceletateEventId, g_i18n:getText( "action_trot" ))
                g_inputBinding:setActionEventActive(spec.acceletateEventId, true )
                g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, true )

                g_inputBinding:setActionEventText(spec.brakeEventId, g_i18n:getText( "action_stop" ))
                g_inputBinding:setActionEventActive(spec.brakeEventId, true )
                g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, true )

                g_inputBinding:setActionEventActive(spec.jumpEventId, false )
                g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, false )
            elseif spec.inputValues.currentGait = = Rideable.GAITTYPES.TROT then
                    g_inputBinding:setActionEventText(spec.acceletateEventId, g_i18n:getText( "action_canter" ))
                    g_inputBinding:setActionEventActive(spec.acceletateEventId, true )
                    g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, true )

                    g_inputBinding:setActionEventText(spec.brakeEventId, g_i18n:getText( "action_walk" ))
                    g_inputBinding:setActionEventActive(spec.brakeEventId, true )
                    g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, true )

                    g_inputBinding:setActionEventActive(spec.jumpEventId, false )
                    g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, false )
                elseif spec.inputValues.currentGait = = Rideable.GAITTYPES.CANTER then
                        g_inputBinding:setActionEventText(spec.acceletateEventId, g_i18n:getText( "action_gallop" ))
                        g_inputBinding:setActionEventActive(spec.acceletateEventId, true )
                        g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, true )

                        g_inputBinding:setActionEventText(spec.brakeEventId, g_i18n:getText( "action_trot" ))
                        g_inputBinding:setActionEventActive(spec.brakeEventId, true )
                        g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, true )

                        g_inputBinding:setActionEventText(spec.jumpEventId, g_i18n:getText( "input_JUMP" ))
                        g_inputBinding:setActionEventActive(spec.jumpEventId, true )
                        g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, true )
                    elseif spec.inputValues.currentGait = = Rideable.GAITTYPES.GALLOP then
                            g_inputBinding:setActionEventActive(spec.acceletateEventId, false )
                            g_inputBinding:setActionEventTextVisibility(spec.acceletateEventId, false )

                            g_inputBinding:setActionEventText(spec.brakeEventId, g_i18n:getText( "action_canter" ))
                            g_inputBinding:setActionEventActive(spec.brakeEventId, true )
                            g_inputBinding:setActionEventTextVisibility(spec.brakeEventId, true )

                            g_inputBinding:setActionEventText(spec.jumpEventId, g_i18n:getText( "input_JUMP" ))
                            g_inputBinding:setActionEventActive(spec.jumpEventId, true )
                            g_inputBinding:setActionEventTextVisibility(spec.jumpEventId, true )
                        end
                    end

```

### updateKinematic

**Description**

> Update animal kinematic; if we reach max speed? we fix velocity else we add force to accelerate. If we need to break,
> we add a break force. At the end we add gravity force and change direction when needed.

**Definition**

> updateKinematic(float dt)

**Arguments**

| float | dt | delta time in ms |
|-------|----|------------------|

**Code**

```lua
function Rideable:updateKinematic(dt)
    local spec = self.spec_rideable
    local dtInSec = dt * 0.001

    -- Update movement in current direction
    local desiredSpeed = spec.topSpeeds[spec.inputValues.currentGait]
    local maxSpeedChange = spec.maxAcceleration
    if desiredSpeed = = 0.0 then
        maxSpeedChange = spec.maxDeceleration
    end
    maxSpeedChange = maxSpeedChange * dtInSec
    if not spec.isOnGround then
        -- reduce acceleration when in the air
        maxSpeedChange = maxSpeedChange * 0.2
    end

    local speedChange = (desiredSpeed - spec.currentSpeed)
    speedChange = math.clamp(speedChange, - maxSpeedChange, maxSpeedChange)

    --local movement = (spec.currentSpeed + 0.5 * speedChange) * dtInSec
    if spec.haltTimer < = 0.0 then
        spec.currentSpeed = spec.currentSpeed + speedChange
    else
            spec.currentSpeed = 0.0
        end

        local movement = spec.currentSpeed * dtInSec

        -- Update gravity / vertical movement
        if spec.isOnGround and spec.currentSpeedY < 0 then
            spec.currentSpeedY = 0
        end

        local gravitySpeedChange = spec.gravity * dtInSec
        spec.currentSpeedY = spec.currentSpeedY + gravitySpeedChange
        local movementY = spec.currentSpeedY * dtInSec

        -- Update rotation
        local slowestSpeed = spec.topSpeeds[ Rideable.GAITTYPES.WALK]
        local fastestSpeed = spec.topSpeeds[ Rideable.GAITTYPES.MAX]

        local maxTurnSpeedChange = ( math.clamp((fastestSpeed - spec.currentSpeed) / (fastestSpeed - slowestSpeed), 0 , 1 ) * 0.4 + 0.8 ) -- Use smaller changes when walking slowly(between 0.8 and 1.2 rad/s^2)
        maxTurnSpeedChange = maxTurnSpeedChange * dtInSec
        if not spec.isOnGround then
            -- reduce turn acceleration when in the air
            maxTurnSpeedChange = maxTurnSpeedChange * 0.25
        end

        if self.isServer then
            if not self:getIsEntered() and not self:getIsControlled() and spec.inputValues.axisSteer ~ = 0.0 then
                spec.inputValues.axisSteer = 0.0
            end
        end

        local desiredTurnSpeed = spec.maxTurnSpeed * spec.inputValues.axisSteer
        local turnSpeedChange = (desiredTurnSpeed - spec.currentTurnSpeed)
        turnSpeedChange = math.clamp(turnSpeedChange, - maxTurnSpeedChange, maxTurnSpeedChange)
        spec.currentTurnSpeed = spec.currentTurnSpeed + turnSpeedChange
        spec.currentTurnAngle = spec.currentTurnAngle + spec.currentTurnSpeed * dtInSec * (movement > = 0 and 1 or - 1 )

        local movementX, movementZ = math.sin(spec.currentTurnAngle) * movement, math.cos(spec.currentTurnAngle) * movement
        -- print(string.format("-- [Rideable:updateKinematic][%d]\t%.6f\t%.6f\t%.6f\t%d", g_updateLoopIndex, dt, spec.currentSpeed, movement, getPhysicsUpdateIndex()))
        self:moveCCT(movementX, movementY, movementZ, true )

        table.insert(spec.cctMoveQueue, { physicsIndex = getPhysicsUpdateIndex(), moveX = movementX, moveY = movementY, moveZ = movementZ, dt = dt } )
    end

```

### updateRiding

**Description**

**Definition**

> updateRiding()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Rideable:updateRiding(dt)
    local spec = self.spec_rideable

    if spec.cluster ~ = nil and spec.currentSpeed ~ = 0.0 then
        local ridingTime = spec.cluster:getDailyRidingTime()
        local changeDelta = ridingTime / 100
        local speedFactor = 1

        local gaitType = spec.inputValues.currentGait
        if gaitType = = Rideable.GAITTYPES.CANTER then
            speedFactor = 2
        elseif gaitType = = Rideable.GAITTYPES.GALLOP then
                speedFactor = 3
            end

            spec.ridingTimer = spec.ridingTimer + (dt * speedFactor)

            if spec.ridingTimer > changeDelta then
                spec.ridingTimer = 0
                spec.cluster:changeRiding( 1 )
                spec.cluster:changeDirt( 1 )
            end

            if self.lastMovedDistance > 0.001 then
                local distance = self.lastMovedDistance * 0.001
                g_farmManager:updateFarmStats( self:getOwnerFarmId(), "horseDistance" , distance)
            end

            self:updateDirt()
        end
    end

```

### updateSound

**Description**

**Definition**

> updateSound()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Rideable:updateSound(dt)
    local spec = self.spec_rideable

    if spec.horseBreathSoundsEffort ~ = nil and spec.horseBreathSoundsNoEffort ~ = nil and spec.isOnGround then
        spec.currentBreathTimer = spec.currentBreathTimer - dt
        spec.currentBreathTimer = math.max(spec.currentBreathTimer, 0.0 )

        if spec.currentBreathTimer = = 0.0 then
            if spec.inputValues.currentGait = = Rideable.GAITTYPES.GALLOP then
                g_soundManager:playSample(spec.horseBreathSoundsEffort)
                spec.currentBreathTimer = spec.horseBreathIntervalEffort
            else
                    g_soundManager:playSample(spec.horseBreathSoundsNoEffort)
                    if spec.inputValues.currentGait = = Rideable.GAITTYPES.STILL then
                        spec.currentBreathTimer = spec.horseBreathMinIntervalIdle + ( math.random() * (spec.horseBreathMaxIntervalIdle - spec.horseBreathMinIntervalIdle))
                    else
                            spec.currentBreathTimer = spec.horseBreathIntervalNoEffort
                        end
                    end
                end
            end
        end

```

### updateVehicleSpeed

**Description**

**Definition**

> updateVehicleSpeed()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | dt        |

**Code**

```lua
function Rideable:updateVehicleSpeed(superFunc, dt)
    if self.isServer then
        local spec = self.spec_rideable
        superFunc( self , spec.interpolationDt)
    else
            superFunc( self , dt)
        end
    end

```