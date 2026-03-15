## PlaceableRollercoaster

**Description**

> Specialization for placeables

**Functions**

- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onSharedAnimationFileLoaded](#onsharedanimationfileloaded)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableRollercoaster:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_rollercoaster

    for _, counterKey in xmlFile:iterator(key .. ".player" ) do
        local uniqueUserId = xmlFile:getValue(counterKey .. "#uniqueUserId" )
        local rideCount = xmlFile:getValue(counterKey .. "#rideCount" )

        if uniqueUserId ~ = nil and rideCount ~ = nil then
            spec.playerRideCounter[uniqueUserId] = rideCount
        end
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableRollercoaster:onDelete()
    local spec = self.spec_rollercoaster

    g_messageCenter:unsubscribeAll( self )

    g_currentMission:removeMapHotspot(spec.rollercoasterHotspot)

    spec.rollercoasterHotspot:delete()

    if spec.animation ~ = nil and spec.animation.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.animation.sharedLoadRequestId)
        spec.animation.sharedLoadRequestId = nil
    end

    for _, seat in ipairs(spec.seats) do
        if seat.vehicleCharacter ~ = nil then
            seat.vehicleCharacter:delete()
        end
        if seat.camera ~ = nil then
            seat.camera:delete()
        end
    end

    if spec.soundsMoving ~ = nil then
        for _, sound in ipairs(spec.soundsMoving) do
            if sound.movingSound ~ = nil then
                g_currentMission.ambientSoundSystem:removeMovingSound(sound.movingSound)
                sound.movingSound = nil
            end
        end
    end

    if spec.sounds ~ = nil then
        g_soundManager:deleteSamples(spec.sounds)
    end

    if spec.playerTrigger ~ = nil then
        removeTrigger(spec.playerTrigger)
        spec.playerTrigger = nil
    end

    if PlaceableRollercoaster.INSTANCE = = self then
        PlaceableRollercoaster.INSTANCE = nil
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableRollercoaster:onFinalizePlacement(savegame)
    local spec = self.spec_rollercoaster

    spec.rollercoasterHotspot:setPlaceable( self )
    spec.rollercoasterHotspot:setOwnerFarmId( nil )

    local x,y,z, _
    x,_,z = getWorldTranslation(spec.hotSpotLinkNode)
    spec.rollercoasterHotspot:setWorldPosition(x, z)

    x,y,z = getWorldTranslation(spec.hotSpotTeleportNode)
    spec.rollercoasterHotspot:setTeleportWorldPosition(x, y, z)

    g_currentMission:addMapHotspot(spec.rollercoasterHotspot)

    if PlaceableRollercoaster.INSTANCE = = nil then
        PlaceableRollercoaster.INSTANCE = self
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
function PlaceableRollercoaster:onLoad(savegame)
    local spec = self.spec_rollercoaster

    local key = "placeable.rollercoaster"

    local clipRootNode = self.xmlFile:getValue(key .. ".animation.clip#rootNode" , nil , self.components, self.i3dMappings)
    local clipName = self.xmlFile:getValue(key .. ".animation.clip#name" )

    local _, baseDirectory = Utils.getModNameAndBaseDirectory( self.xmlFile:getFilename())

    if clipRootNode ~ = nil and clipName ~ = nil then
        local clipFilename = self.xmlFile:getValue(key .. ".animation.clip#filename" )

        spec.animation = { }
        spec.animation.clipRootNode = clipRootNode
        spec.animation.clipName = clipName
        spec.animation.clipTrack = 0
        spec.animation.speedScale = self.xmlFile:getValue(key .. ".animation#speedScale" , 1 )

        if clipFilename ~ = nil then
            clipFilename = Utils.getFilename(clipFilename, baseDirectory)

            local loadingTask = self:createLoadingTask()
            local arguments = {
            loadingTask = loadingTask
            }
            spec.animation.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(clipFilename, false , false , self.onSharedAnimationFileLoaded, self , arguments)
            spec.animation.clipFilename = clipFilename
        end

        setVisibility(clipRootNode, false )

        spec.animationTimeInterpolator = InterpolationTime.new( 1.3 )
        spec.animationInterpolator = InterpolatorValue.new( 0 )
    end

    spec.playerTrigger = self.xmlFile:getValue(key .. ".playerTrigger#node" , nil , self.components, self.i3dMappings)
    addTrigger(spec.playerTrigger, "playerTriggerCallback" , self )
    self:setPlayerTriggerState( false )
    spec.activatable = RollercoasterActivatable.new( self )

    spec.carts = { }
    spec.seats = { }

    for cartIndex, cartKey in self.xmlFile:iterator(key .. ".carts.cart" ) do
        local cart = { }
        cart.node = self.xmlFile:getValue(cartKey .. "#node" , nil , self.components, self.i3dMappings)
        cart.slope = 0
        cart.angleChange = 0
        cart.dirX, cart.dirY, cart.dirZ = localDirectionToWorld(cart.node, 0 , 0 , 1 )

        for _, seatKey in self.xmlFile:iterator(cartKey .. ".seat" ) do
            local seatEntry = { }
            seatEntry.cart = cart
            seatEntry.node = self.xmlFile:getValue(seatKey .. "#node" , nil , self.components, self.i3dMappings)
            if seatEntry.node ~ = nil then
                -- TODO:only have one camera per game and switch location dynamically?
                local camera = VehicleCamera.new( self )
                if camera:loadFromXML( self.xmlFile, seatKey .. ".camera" , nil , 1 ) then
                    seatEntry.camera = camera
                end

                seatEntry.vehicleCharacter = VehicleCharacter.new( self )
                if seatEntry.vehicleCharacter ~ = nil and not seatEntry.vehicleCharacter:load( self.xmlFile, seatKey .. ".characterNode" ) then
                    seatEntry.vehicleCharacter = nil
                end
            end

            seatEntry.characterSpineLastRotationX, seatEntry.characterSpineLastRotationZ = 0 , 0
            seatEntry.randomFactor = math.random()
            seatEntry.smoothingFactor = 1 - ( math.random( 10 , 40 ) / 100 )
            seatEntry.smoothingFactorInv = 1 - seatEntry.smoothingFactor

            table.insert(spec.seats, seatEntry)
        end

        table.insert(spec.carts, cart)
    end

    spec.centerCart = spec.carts[ MathUtil.round(#spec.carts / 2 )] -- center cart used for sound etc

        spec.localSeatIndex = nil
        spec.numRiders = 0
        spec.ridersChangedListeners = { }

        spec.exitPoints = { }
        for _, pointKey in self.xmlFile:iterator(key .. ".exitPoints.exitPoint" ) do
            local exitPoint = self.xmlFile:getValue(pointKey .. "#node" , nil , self.components, self.i3dMappings)
            if exitPoint ~ = nil then
                table.insert(spec.exitPoints, exitPoint)
            end
        end

        if #spec.exitPoints < #spec.seats then
            Logging.xmlWarning( self.xmlFile, "Only %d exitPoints defined for %d seats" , #spec.exitPoints, #spec.seats)
            end

            spec.rollercoasterHotspot = RollercoasterHotspot.new()
            spec.hotSpotLinkNode = self.xmlFile:getValue(key .. ".hotspot#linkNode" , nil , self.components, self.i3dMappings)
            spec.hotSpotTeleportNode = self.xmlFile:getValue(key .. ".hotspot#teleportNode" , nil , self.components, self.i3dMappings)

            if self.isClient then
                -- spline based sound for lifts
                    spec.soundsMoving = { }
                    for index, soundKey in self.xmlFile:iterator(key .. ".movingSounds.sound" ) do
                        local movingSoundNode = self.xmlFile:getValue(soundKey .. "#node" , nil , self.components, self.i3dMappings)
                        local soundFilename = Utils.getFilename( self.xmlFile:getValue(soundKey .. "#filename" ), baseDirectory)
                        local innerRadius = self.xmlFile:getValue(soundKey .. "#innerRadius" )
                        local radius = self.xmlFile:getValue(soundKey .. "#radius" )
                        local volume = self.xmlFile:getValue(soundKey .. "#volume" , 1 )

                        local audioSource = createAudioSource( "rollercoaster_" .. tostring(index), soundFilename, radius, innerRadius, volume, 0 )
                        local sample = getAudioSourceSample(audioSource)
                        setSampleGroup(sample, AudioGroup.ENVIRONMENT)

                        link(getChildAt(movingSoundNode, 1 ), audioSource) -- link to TG which is moved along spline

                        -- only create sample here, sound is activated on build completion
                        table.insert(spec.soundsMoving, { node = movingSoundNode, movingSound = nil } )
                    end

                    -- regular sounds with modifiers
                    spec.sounds = { }
                    spec.sounds.driving1 = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "driving1" , baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                    spec.sounds.driving2 = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "driving2" , baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                    spec.sounds.driving3 = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "driving3" , baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                    spec.sounds.driving4 = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "driving4" , baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                    spec.sounds.driving5 = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "driving5" , baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )

                    -- initilize for sound modifiers
                        spec.speed = 0
                        spec.posX, spec.posY, spec.posZ = getWorldTranslation(spec.centerCart.node)

                        self.currentUpdateDistance = math.huge -- needed for VehicleCharacter:update()
                        end

                        g_messageCenter:subscribe(MessageType.USER_REMOVED, self.onUserRemoved, self )
                    end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableRollercoaster:onReadStream(streamId, connection)
    local spec = self.spec_rollercoaster

    -- used seats
    for seatIndex, seat in ipairs(spec.seats) do
        if streamReadBool(streamId) then
            local player = NetworkUtil.readNodeObject(streamId)
            self:enterRide(seatIndex, player)
        end
    end
end

```

### onSharedAnimationFileLoaded

**Description**

**Definition**

> onSharedAnimationFileLoaded()

**Arguments**

| any | node         |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableRollercoaster:onSharedAnimationFileLoaded(node, failedReason, args)
    local spec = self.spec_rollercoaster

    if node ~ = 0 and node ~ = nil then
        if not self.isDeleted then
            local animNode = getChildAt(getChildAt(node, 0 ), 0 )
            if cloneAnimCharacterSet(animNode, spec.animation.clipRootNode) then

                local characterSet = getAnimCharacterSet(spec.animation.clipRootNode)
                local clipIndex = getAnimClipIndex(characterSet, spec.animation.clipName)
                if clipIndex ~ = - 1 then
                    assignAnimTrackClip(characterSet, spec.animation.clipTrack, clipIndex)
                    setAnimTrackLoopState(characterSet, spec.animation.clipTrack, false )

                    spec.animation.clipDuration = getAnimClipDuration(characterSet, clipIndex)
                    spec.animation.clipIndex = clipIndex
                    spec.animation.clipCharacterSet = characterSet

                    setAnimTrackSpeedScale(characterSet, clipIndex, spec.animation.speedScale)
                else
                        Logging.error( "Animation clip with name '%s' does not exist in '%s'" , spec.animation.clipName, spec.animation.clipFilename or self.xmlFilename)
                    end
                end
            end

            delete(node)
        end

        spec.playerRideCounter = { }

        for _, state in pairs( self.spec_constructible.stateMachine) do
            if state.init ~ = nil then
                state:init()
            end
        end

        self:finishLoadingTask(args.loadingTask)
    end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableRollercoaster:onWriteStream(streamId, connection)
    local spec = self.spec_rollercoaster

    -- used seats
    for seatIndex, seat in ipairs(spec.seats) do
        if streamWriteBool(streamId, seat.player ~ = nil ) then
            NetworkUtil.writeNodeObject(streamId, seat.player)
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
function PlaceableRollercoaster.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableConstructible , specializations)
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableRollercoaster.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableRollercoaster )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableRollercoaster )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableRollercoaster )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableRollercoaster )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableRollercoaster )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableRollercoaster )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableRollercoaster.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onSharedAnimationFileLoaded" , PlaceableRollercoaster.onSharedAnimationFileLoaded)
    SpecializationUtil.registerFunction(placeableType, "getCanEnter" , PlaceableRollercoaster.getCanEnter)
    SpecializationUtil.registerFunction(placeableType, "getFreeSeatIndex" , PlaceableRollercoaster.getFreeSeatIndex)
    SpecializationUtil.registerFunction(placeableType, "getCanStart" , PlaceableRollercoaster.getCanStart)
    SpecializationUtil.registerFunction(placeableType, "startRide" , PlaceableRollercoaster.startRide)
    SpecializationUtil.registerFunction(placeableType, "endRide" , PlaceableRollercoaster.endRide)
    SpecializationUtil.registerFunction(placeableType, "getAnimation" , PlaceableRollercoaster.getAnimation)
    SpecializationUtil.registerFunction(placeableType, "setAnimationTime" , PlaceableRollercoaster.setAnimationTime)
    SpecializationUtil.registerFunction(placeableType, "updateFxModifierValues" , PlaceableRollercoaster.updateFxModifierValues)
    SpecializationUtil.registerFunction(placeableType, "tryEnterRide" , PlaceableRollercoaster.tryEnterRide)
    SpecializationUtil.registerFunction(placeableType, "enterRide" , PlaceableRollercoaster.enterRide)
    SpecializationUtil.registerFunction(placeableType, "exitRide" , PlaceableRollercoaster.exitRide)
    SpecializationUtil.registerFunction(placeableType, "onUserRemoved" , PlaceableRollercoaster.onUserRemoved)
    SpecializationUtil.registerFunction(placeableType, "registerRidersChangedListener" , PlaceableRollercoaster.registerRidersChangedListener)
    SpecializationUtil.registerFunction(placeableType, "unregisterRidersChangedListener" , PlaceableRollercoaster.unregisterRidersChangedListener)
    SpecializationUtil.registerFunction(placeableType, "getParentComponent" , PlaceableRollercoaster.getParentComponent)
    SpecializationUtil.registerFunction(placeableType, "passengerCharacterLoaded" , PlaceableRollercoaster.passengerCharacterLoaded)
    SpecializationUtil.registerFunction(placeableType, "playerTriggerCallback" , PlaceableRollercoaster.playerTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "setPlayerTriggerState" , PlaceableRollercoaster.setPlayerTriggerState)
    SpecializationUtil.registerFunction(placeableType, "getNumRides" , PlaceableRollercoaster.getNumRides)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableRollercoaster.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getHotspot" , PlaceableRollercoaster.getHotspot)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "finalizeConstruction" , PlaceableRollercoaster.finalizeConstruction)
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
function PlaceableRollercoaster.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. ".state#index" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. "#splineTime" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".player(?)#uniqueUserId" , "" )
    schema:register(XMLValueType.INT, basePath .. ".player(?)#rideCount" , 0 )
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
function PlaceableRollercoaster.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Rollercoaster" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.animation.clip#rootNode" , "Animation root node" )
    schema:register(XMLValueType.STRING, basePath .. ".rollercoaster.animation.clip#name" , "Animation clip name" )
    schema:register(XMLValueType.STRING, basePath .. ".rollercoaster.animation.clip#filename" , "Animation filename" )
    schema:register(XMLValueType.FLOAT, basePath .. ".rollercoaster.animation#speedScale" , "Animation speed scale" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.movingSounds.sound(?)#node" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".rollercoaster.movingSounds.sound(?)#filename" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".rollercoaster.movingSounds.sound(?)#innerRadius" , "Audio source inner radius" )
    schema:register(XMLValueType.FLOAT, basePath .. ".rollercoaster.movingSounds.sound(?)#radius" , "Audio source radius" )
    schema:register(XMLValueType.FLOAT, basePath .. ".rollercoaster.movingSounds.sound(?)#volume" , "Audio source volume" )

    SoundManager.registerSampleXMLPaths(schema, basePath .. ".rollercoaster.sounds" , "driving1" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".rollercoaster.sounds" , "driving2" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".rollercoaster.sounds" , "driving3" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".rollercoaster.sounds" , "driving4" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".rollercoaster.sounds" , "driving5" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.playerTrigger#node" , "Player trigger for entering the ride" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.exitPoints.exitPoint(?)#node" , "Node where players exit the rollercoaster" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.hotspot#linkNode" , "Node where hotspot is linked to" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.hotspot#teleportNode" , "Node where player is teleported to.Teleporting is only available if this is set" )

            schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.carts.cart(?)#node" , "Cart node" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".rollercoaster.carts.cart(?).seat(?)#node" , "Seat reference node to calculate entering distance to" )

            VehicleCamera.registerCameraXMLPaths(schema, basePath .. ".rollercoaster.carts.cart(?).seat(?).camera" )
            VehicleCharacter.registerCharacterXMLPaths(schema, basePath .. ".rollercoaster.carts.cart(?).seat(?).characterNode" )

            schema:setXMLSpecializationType()
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
function PlaceableRollercoaster:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_rollercoaster

    local i = 0
    for uniqueUserId, rideCount in pairs(spec.playerRideCounter) do
        local counterKey = string.format( "%s.player(%d)" , key, i)
        xmlFile:setValue(counterKey .. "#uniqueUserId" , uniqueUserId)
        xmlFile:setValue(counterKey .. "#rideCount" , rideCount)
        i = i + 1
    end
end

```