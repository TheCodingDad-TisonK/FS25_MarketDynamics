## Dog

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [delete](#delete)
- [fetchItem](#fetchitem)
- [finalizePlacement](#finalizeplacement)
- [followEntity](#followentity)
- [getUpdatePriority](#getupdatepriority)
- [goToSpawn](#gotospawn)
- [hourChanged](#hourchanged)
- [idleStay](#idlestay)
- [idleWander](#idlewander)
- [isAbandoned](#isabandoned)
- [load](#load)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [onFoodBowlFilled](#onfoodbowlfilled)
- [onGhostAdd](#onghostadd)
- [onGhostRemove](#onghostremove)
- [onIndoorStateChanged](#onindoorstatechanged)
- [onPlayerLeave](#onplayerleave)
- [pet](#pet)
- [playerFarmChanged](#playerfarmchanged)
- [playerInteractionTriggerCallback](#playerinteractiontriggercallback)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [resetSteeringParms](#resetsteeringparms)
- [saveToXMLFile](#savetoxmlfile)
- [setName](#setname)
- [setVisibility](#setvisibility)
- [teleportToSpawn](#teleporttospawn)
- [testScope](#testscope)
- [update](#update)
- [updateTick](#updatetick)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### delete

**Description**

> Delete

**Definition**

> delete()

**Code**

```lua
function Dog:delete()
    self.isDeleted = true -- mark as deleted so we can track it in Doghouse
    if self.dogInstance ~ = nil then
        --#debug log("delete dogInstance", self.dogInstance)
        delete( self.dogInstance)
    end

    if self.isServer then
        g_messageCenter:unsubscribeAll( self )
    end

    unregisterObjectClassName( self )
    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
    g_soundManager:removeIndoorStateChangedListener( self )

    Dog:superClass().delete( self )
end

```

### fetchItem

**Description**

> Activate fetch ball behavior

**Definition**

> fetchItem(object object, )

**Arguments**

| object | object | of type DogBall |
|--------|--------|-----------------|
| any    | ball   |                 |

**Code**

```lua
function Dog:fetchItem(player, ball)
    if not self.isServer then
        g_client:getServerConnection():sendEvent( DogFetchItemEvent.new( self , player, ball))
    else
            local x, y, z = getWorldTranslation(ball.nodeId)
            ball.throwPos = { x, y, z }
            setCompanionBehaviorFetch( self.dogInstance, self.animalId, ball.nodeId, player.rootNode)
            self.entityThrower = player.rootNode
        end
    end

```

### finalizePlacement

**Description**

**Definition**

> finalizePlacement()

**Code**

```lua
function Dog:finalizePlacement()
    self:setVisibility( true )

    if self.isServer then
        g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.hourChanged, self )
        g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, Dog.playerFarmChanged, self )
    end
end

```

### followEntity

**Description**

> Activate follow player

**Definition**

> followEntity(integer scenegraph)

**Arguments**

| integer | scenegraph | node of the ball |
|---------|------------|------------------|

**Code**

```lua
function Dog:followEntity(player)
    -- Note:we also set entityFollow on the client side so that we can update the gui(it won't be 100% accurate if an other player interacts, but that should be good enough)
        self.entityFollow = player.rootNode
        self.entityThrower = nil
        if not self.isServer then
            g_client:getServerConnection():sendEvent( DogFollowEvent.new( self , player))
        else
                setCompanionBehaviorFollowEntity( self.dogInstance, self.animalId, self.entityFollow)
                self.isStaying = false
            end
        end

```

### getUpdatePriority

**Description**

> Get update priority

**Definition**

> getUpdatePriority(float skipCount, float x, float y, float z, float coeff, table connection, )

**Arguments**

| float | skipCount    | skip count |
|-------|--------------|------------|
| float | x            | x position |
| float | y            | y position |
| float | z            | z position |
| float | coeff        | coeff      |
| table | connection   | connection |
| any   | isGuiVisible |            |

**Return Values**

| any | priority | priority |
|-----|----------|----------|

**Code**

```lua
function Dog:getUpdatePriority(skipCount, x, y, z, coeff, connection, isGuiVisible)
    local distance, clipDistance = getCompanionClosestDistance( self.dogInstance, x, y, z)
    if clipDistance = = 0 then
        return 0
    end

    local clipDist = math.min(clipDistance * coeff, self.forcedClipDistance)
    local result = ( 1.0 - distance / clipDist) * 0.8 + 0.5 * skipCount * 0.2

    return result
end

```

### goToSpawn

**Description**

> Activate fetch ball behavior

**Definition**

> goToSpawn(integer scenegraph)

**Arguments**

| integer | scenegraph | node of the ball |
|---------|------------|------------------|

**Code**

```lua
function Dog:goToSpawn()
    self.entityFollow = nil
    self.entityThrower = nil

    if not self.isServer then
        g_client:getServerConnection():sendEvent( DogFollowEvent.new( self , nil ))
    else
            setCompanionBehaviorGotoEntity( self.dogInstance, self.animalId, self.spawner:getSpawnNode())
        end
    end

```

### hourChanged

**Description**

> Called by the environment when an hour has changed.

**Definition**

> hourChanged()

**Code**

```lua
function Dog:hourChanged()
    if not self.isServer then
        return
    end

    if self.dogInstance ~ = nil then
        setCompanionDaytime( self.dogInstance, g_currentMission.environment.dayTime)
    end
end

```

### idleStay

**Description**

> Activate dog staying behavior (used when the currently followed player is switching vehicles or leaving the game)

**Definition**

> idleStay()

**Code**

```lua
function Dog:idleStay()
    -- This is only supposed to be called on the server
    self.entityFollow = nil
    self.entityThrower = nil
    setCompanionBehaviorDefault( self.dogInstance, self.animalId)
    self.isStaying = true
end

```

### idleWander

**Description**

**Definition**

> idleWander()

**Code**

```lua
function Dog:idleWander()
    -- This is only supposed to be called on the server
    --setCompanionBehaviorIdleWander(self.dogInstance, self.animalId)
end

```

### isAbandoned

**Description**

**Definition**

> isAbandoned()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Dog:isAbandoned(dt)
    local isEntityInRange = false
    for _, player in pairs(g_currentMission.players) do
        if player.isControlled then
            local entityX, entityY, entityZ = getWorldTranslation(player.rootNode)
            local distance, _ = getCompanionClosestDistance( self.dogInstance, entityX, entityY, entityZ)
            if distance < self.abandonRange then
                isEntityInRange = true
                break
            end
        end
    end

    if not isEntityInRange then
        for _, enterable in pairs(g_currentMission.vehicleSystem.enterables) do
            if enterable.spec_enterable ~ = nil and enterable.spec_enterable.isControlled then
                local entityX, entityY, entityZ = getWorldTranslation(enterable.rootNode)
                local distance, _ = getCompanionClosestDistance( self.dogInstance, entityX, entityY, entityZ)
                if distance < self.abandonRange then
                    isEntityInRange = true
                    break
                end
            end
        end
    end

    if isEntityInRange then
        self.abandonTimer = self.abandonTimerDuration
    else
            self.abandonTimer = self.abandonTimer - dt
            if self.abandonTimer < = 0 then
                return true
            end
        end

        return false
    end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | spawner     |
|-----|-------------|
| any | xmlFilename |
| any | spawnX      |
| any | spawnY      |
| any | spawnZ      |

**Code**

```lua
function Dog:load(spawner, xmlFilename, spawnX, spawnY, spawnZ)
    self.spawner = spawner
    self.animalId = 0
    self.spawnX = spawnX
    self.spawnY = spawnY
    self.spawnZ = spawnZ
    self.xmlFilename = xmlFilename
    self.name = g_currentMission.animalNameSystem:getRandomName()

    local dogInstance = createAnimalCompanionManager(CompanionAnimalType.DOG, self.xmlFilename, "dog" , self.spawnX, self.spawnY, self.spawnZ, g_terrainNode, self.isServer, self.isClient, 1 , AudioGroup.ENVIRONMENT)
    if dogInstance = = 0 then
        return false
    end

    self.dogInstance = dogInstance
    setCompanionWaterDetectionOffset( self.dogInstance, 0.45 )

    setCompanionTrigger( self.dogInstance, self.animalId, "playerInteractionTriggerCallback" , self )

    setCompanionTextureTile( self.dogInstance, self.animalId, 1 , 1 )

    local groundMask = CollisionFlag.TERRAIN + CollisionFlag.STATIC_OBJECT
    local obstacleMask = CollisionFlag.STATIC_OBJECT +
    CollisionFlag.DYNAMIC_OBJECT +
    CollisionFlag.VEHICLE +
    CollisionFlag.BUILDING
    setCompanionCollisionMask( self.dogInstance, groundMask, obstacleMask, CollisionFlag.WATER)

    g_soundManager:addIndoorStateChangedListener( self )
    setCompanionUseOutdoorAudioSetup( self.dogInstance, not g_soundManager:getIsIndoor())

    return true
end

```

### loadFromXMLFile

**Description**

> Loading from attributes and nodes

**Definition**

> loadFromXMLFile(XMLFile xmlFile, string key, boolean resetVehicles)

**Arguments**

| XMLFile | xmlFile       | XMLFile instance |
|---------|---------------|------------------|
| string  | key           | key              |
| boolean | resetVehicles | reset vehicles   |

**Return Values**

| boolean | success | success |
|---------|---------|---------|

**Code**

```lua
function Dog:loadFromXMLFile(xmlFile, key, resetVehicles)
    self:setName(xmlFile:getValue(key .. "#name" , "" ))

    return true
end

```

### new

**Description**

> Creating

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | isClient |
| any | customMt |

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function Dog.new(isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or Dog _mt)

    self.dogInstance = nil
    self.animalId = nil
    self.spawner = nil
    self.xmlFilename = nil
    self.entityFollow = nil
    self.entityThrower = nil
    self.isStaying = false
    self.abandonTimer = 0.0
    self.abandonTimerDuration = 6000
    self.abandonRange = 100
    self.name = ""

    self.tileIndexU = 0
    self.tileIndexV = 0

    self.spawnX = 0
    self.spawnY = 0
    self.spawnZ = 0

    self.forcedClipDistance = 80

    self.activatable = DogPetActivatable.new( self )

    registerObjectClassName( self , "Dog" )

    self.dirtyFlag = self:getNextDirtyFlag()
    return self
end

```

### onFoodBowlFilled

**Description**

**Definition**

> onFoodBowlFilled()

**Arguments**

| any | foodBowlNode |
|-----|--------------|

**Code**

```lua
function Dog:onFoodBowlFilled(foodBowlNode)
    self.entityFollow = nil
    self.entityThrower = nil
    setCompanionBehaviorFeed( self.dogInstance, self.animalId, foodBowlNode)
end

```

### onGhostAdd

**Description**

> On ghost add

**Definition**

> onGhostAdd()

**Code**

```lua
function Dog:onGhostAdd()
    self:setVisibility( true )
end

```

### onGhostRemove

**Description**

> On ghost remove

**Definition**

> onGhostRemove()

**Code**

```lua
function Dog:onGhostRemove()
    self:setVisibility( false )
end

```

### onIndoorStateChanged

**Description**

**Definition**

> onIndoorStateChanged()

**Arguments**

| any | isIndoor |
|-----|----------|

**Code**

```lua
function Dog:onIndoorStateChanged(isIndoor)
    setCompanionUseOutdoorAudioSetup( self.dogInstance, not g_soundManager:getIsIndoor())
end

```

### onPlayerLeave

**Description**

> Tells the dog to stay at the current place when we leave the currently followed player

**Definition**

> onPlayerLeave()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function Dog:onPlayerLeave(player)
    -- return dog to it's house
    if self.isServer then
        if self.entityFollow = = player.rootNode or self.entityThrower = = player.rootNode then
            self:idleStay()
        end
    end
end

```

### pet

**Description**

> Activate dog petting response behavior

**Definition**

> pet()

**Code**

```lua
function Dog:pet()
    if not self.isServer then
        g_client:getServerConnection():sendEvent( DogPetEvent.new( self ))
    else
            setCompanionBehaviorPet( self.dogInstance, self.animalId)

            local total, _ = g_farmManager:updateFarmStats( self:getOwnerFarmId(), "petDogCount" , 1 )
            if total ~ = nil then
                g_achievementManager:tryUnlock( "PetDog" , total)
            end
        end
    end

```

### playerFarmChanged

**Description**

**Definition**

> playerFarmChanged()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function Dog:playerFarmChanged(player)
    if self.isServer then
        if self.entityFollow = = player.rootNode or self.entityThrower = = player.rootNode then
            self:idleStay()
        end
    end
end

```

### playerInteractionTriggerCallback

**Description**

> Callback when dog interaction trigger is activated

**Definition**

> playerInteractionTriggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger |
|---------|-----------|---------------|
| integer | otherId   | id of actor   |
| boolean | onEnter   | on enter      |
| boolean | onLeave   | on leave      |
| boolean | onStay    | on stay       |

**Code**

```lua
function Dog:playerInteractionTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
            if onEnter then
                if g_currentMission.accessHandler:canFarmAccess(g_localPlayer.farmId, self , false ) then
                    g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
                end
            else
                    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                end
            end
        end
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
function Dog:readStream(streamId, connection)
    if connection:getIsServer() then
        local spawner = NetworkUtil.readNodeObject(streamId)
        -- Note:the spawner can be when the doghouse not synced yet.The spawner will be set later on
        local xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))

        local spawnX = streamReadFloat32(streamId)
        local spawnY = streamReadFloat32(streamId)
        local spawnZ = streamReadFloat32(streamId)
        local name = streamReadString(streamId)
        self.tileIndexU = streamReadUIntN(streamId, 3 )
        self.tileIndexV = streamReadUIntN(streamId, 3 )

        local isNew = self.xmlFilename = = nil
        if isNew then
            self:load(spawner, xmlFilename, spawnX, spawnY, spawnZ)
            if spawner ~ = nil then
                spawner.dog = self
            end
        end

        self:setTextureTileIndices( self.tileIndexU, self.tileIndexV)
        self:setName(name)
    end
    Dog:superClass().readStream( self , streamId, connection)
end

```

### readUpdateStream

**Description**

> Read update network stream

**Definition**

> readUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | network stream identification |
|---------|------------|-------------------------------|
| integer | timestamp  |                               |
| table   | connection | connection information        |

**Code**

```lua
function Dog:readUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        readAnimalCompanionManagerFromStream( self.dogInstance, streamId, g_clientInterpDelay, g_packetPhysicsNetworkTime, g_client.tickDuration)
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
function Dog.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#name" , "Name of dog" )
end

```

### resetSteeringParms

**Description**

**Definition**

> resetSteeringParms()

**Code**

```lua
function Dog:resetSteeringParms()
    -- This is only supposed to be called on the server

end

```

### saveToXMLFile

**Description**

> Get save attributes and nodes

**Definition**

> saveToXMLFile(table xmlFile, string key, table usedModNames)

**Arguments**

| table  | xmlFile      |
|--------|--------------|
| string | key          |
| table  | usedModNames |

**Code**

```lua
function Dog:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#name" , HTMLUtil.encodeToHTML( self.name))
end

```

### setName

**Description**

**Definition**

> setName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function Dog:setName(name)
    self.name = name or ""
end

```

### setVisibility

**Description**

**Definition**

> setVisibility()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function Dog:setVisibility(state)
    if self.dogInstance ~ = nil then
        setCompanionsVisibility( self.dogInstance, state)
        setCompanionsPhysicsUpdate( self.dogInstance, state)
    end
end

```

### teleportToSpawn

**Description**

**Definition**

> teleportToSpawn()

**Code**

```lua
function Dog:teleportToSpawn()
    if self.isServer then
        setCompanionPosition( self.dogInstance, self.animalId, self.spawnX, self.spawnY, self.spawnZ)
        self:idleWander()
        self:resetSteeringParms()
        self.isStaying = false
        self.entityFollow = nil
        self.entityThrower = nil

        -- TODO sync notification
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_OK, g_i18n:getText( "ingameNotification_dogInDogHouse" ))
    end
end

```

### testScope

**Description**

> Test scope

**Definition**

> testScope(float x, float y, float z, float coeff, )

**Arguments**

| float | x            | x position |
|-------|--------------|------------|
| float | y            | y position |
| float | z            | z position |
| float | coeff        | coeff      |
| any   | isGuiVisible |            |

**Return Values**

| any | inScope | in scope |
|-----|---------|----------|

**Code**

```lua
function Dog:testScope(x,y,z, coeff, isGuiVisible)
    local distance, clipDistance = getCompanionClosestDistance( self.dogInstance, x, y, z)
    local clipDist = math.min(clipDistance * coeff, self.forcedClipDistance)

    return distance < clipDist
end

```

### update

**Description**

> Update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function Dog:update(dt)
    -- companionDebugDraw(self.dogInstance, self.animalId, true, true, true)

    if self.isServer then
        if self.isStaying and self:isAbandoned(dt) then
            self:teleportToSpawn()
        end

        -- The dog is always active
        -- The only time when it could be disabled is when it is staying.But we don't care to optimize for that case
            self:raiseActive()
        end
        Dog:superClass().update( self , dt)
    end

```

### updateTick

**Description**

> Update network tick

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function Dog:updateTick(dt)
    if self.isServer and self.dogInstance ~ = nil then
        if getAnimalCompanionNeedNetworkUpdate( self.dogInstance) then
            self:raiseDirtyFlags( self.dirtyFlag)
        end
    end
    Dog:superClass().updateTick( self , dt)
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
function Dog:writeStream(streamId, connection)
    if not connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.spawner)
        streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.xmlFilename))
        streamWriteFloat32(streamId, self.spawnX)
        streamWriteFloat32(streamId, self.spawnY)
        streamWriteFloat32(streamId, self.spawnZ)
        streamWriteString(streamId, self.name)
        streamWriteUIntN(streamId, self.tileIndexU, 3 )
        streamWriteUIntN(streamId, self.tileIndexV, 3 )
    end
    Dog:superClass().writeStream( self , streamId, connection)
end

```

### writeUpdateStream

**Description**

> Write update network stream

**Definition**

> writeUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | network stream identification |
|---------|------------|-------------------------------|
| table   | connection | connection information        |
| integer | dirtyMask  |                               |

**Code**

```lua
function Dog:writeUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        writeAnimalCompanionManagerToStream( self.dogInstance, streamId)
    end
end

```