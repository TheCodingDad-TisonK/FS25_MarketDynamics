## HandTool

**Description**

> The hand tool class, representing a hand tool instance.

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [attachTool](#attachtool)
- [attachToolToCamera](#attachtooltocamera)
- [attachToolToHand](#attachtooltohand)
- [calculateSellPrice](#calculatesellprice)
- [clearActionEvents](#clearactionevents)
- [createLoadingTask](#createloadingtask)
- [delete](#delete)
- [detachTool](#detachtool)
- [finishLoadingTask](#finishloadingtask)
- [getCarryingPlayer](#getcarryingplayer)
- [getIsCarried](#getiscarried)
- [getIsHeld](#getisheld)
- [getIsSynchronized](#getissynchronized)
- [getNeedsSaving](#getneedssaving)
- [getPrice](#getprice)
- [getSellPrice](#getsellprice)
- [getUniqueId](#getuniqueid)
- [i3dFileLoaded](#i3dfileloaded)
- [init](#init)
- [loadFinished](#loadfinished)
- [new](#new)
- [onFinishedLoading](#onfinishedloading)
- [periodChanged](#periodchanged)
- [postInit](#postinit)
- [postReadStream](#postreadstream)
- [postWriteStream](#postwritestream)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [register](#register)
- [registerEvents](#registerevents)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setCarryingPlayer](#setcarryingplayer)
- [setFilename](#setfilename)
- [setLoadCallback](#setloadcallback)
- [setLoadingState](#setloadingstate)
- [setLoadingStep](#setloadingstep)
- [setType](#settype)
- [setUniqueId](#setuniqueid)
- [startHolding](#startholding)
- [stopHolding](#stopholding)
- [update](#update)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### attachTool

**Description**

> Attaches the tool to its carrying player, based on the player's camera perspective.

**Definition**

> attachTool()

**Code**

```lua
function HandTool:attachTool()

    -- Do nothing if the tool is not being held.A player is needed to attach to.
        if not self:getIsHeld() then
            return
        end

        -- Handle attaching the tool to the player or to their camera, based on the perspective.
        -- Note that only the client player can hold a tool in first person, the tool is always in the hand when viewed from another player's perspective.
        if self.carryingPlayer:getForceHandToolFirstPerson() and self.carryingPlayer.camera.isFirstPerson then
            self:attachToolToCamera()
        else
                self:attachToolToHand()
            end

            if self.rootNode ~ = nil then
                setVisibility( self.rootNode, true )
            end
        end

```

### attachToolToCamera

**Description**

> Attaches the tool directly to the player's camera, using the first person node as an offset.

**Definition**

> attachToolToCamera()

**Code**

```lua
function HandTool:attachToolToCamera()

    -- If the tool is not held or has no root node, do nothing.
        if not self:getIsHeld() or self.rootNode = = nil then
            return
        end

        -- If there is no first person node, attach the root node directly to the camera with no offset, log a warning, and do nothing more.
            if self.firstPersonNode = = nil then
                Logging.warning( "Handtool %s is missing first person node, using no offset!" , self.typeName)
                link( self:getCarryingPlayer().camera.pitchNode, self.rootNode)
                setTranslation( self.rootNode, 0 , 0 , 0 )
                setRotation( self.rootNode, 0 , 0 , 0 )
                return
            end

            -- Link the root node to the camera's pitch node, so that the first person node is centred on it.
            HandToolUtil.linkAndTransformRelativeToParent( self.rootNode, self.firstPersonNode, self:getCarryingPlayer().camera.pitchNode)
        end

```

### attachToolToHand

**Description**

> Attaches the tool to the player's hand, using the hand node as an offset.

**Definition**

> attachToolToHand()

**Code**

```lua
function HandTool:attachToolToHand()

    -- If the tool is not held, or the graphics of the player are invalid, do nothing.
        if not self:getIsHeld() or self.carryingPlayer.graphicsComponent = = nil or self.carryingPlayer.graphicsComponent.model = = nil then
            Logging.error( "Invalid player configuration or tool is not held, cannot equip hand tool" )
            return false
        end

        -- If there is no root node, do nothing.
            if self.rootNode = = nil then
                return false
            end

            -- Get the player's model.
            local playerModel = self.carryingPlayer.graphicsComponent.model

            -- If there is no hand node, log a warning, zero the offset, and return.
            if self.handNode = = nil then
                Logging.warning( "Handtool %s is missing hand node, using no offset!" , self.typeName)
                link(playerModel.thirdPersonRightHandNode, self.rootNode)
                setTranslation( self.rootNode, 0 , 0 , 0 )
                setRotation( self.rootNode, 0 , 0 , 0 )
                return false
            end

            local handNode = playerModel.thirdPersonRightHandNode
            if self.useLeftHand then
                handNode = playerModel.thirdPersonLeftHandNode
            end

            -- Link the tool to the hand and transform it so that the tool's hand node matches the transform of the player's hand node.
            HandToolUtil.linkAndTransformRelativeToParent( self.rootNode, self.handNode, handNode)

            return true
        end

```

### calculateSellPrice

**Description**

> Calculate price of vehicle given a bunch of parameters

**Definition**

> calculateSellPrice()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | age       |
| any | price     |

**Code**

```lua
function HandTool.calculateSellPrice(storeItem, age, price)
    local ageInYears = age / Environment.PERIODS_IN_YEAR
    local ageFactor = math.min( - 0.1 * math.log(ageInYears) + 0.75 , 0.8 )

    return math.max(price * ageFactor, price * 0.03 )
end

```

### clearActionEvents

**Description**

> Unbinds and removes all action events related to this tool.

**Definition**

> clearActionEvents(boolean? clearCarriedActionEvents)

**Arguments**

| boolean? | clearCarriedActionEvents | If this is true, the carried action events will be cleared instead. |
|----------|--------------------------|---------------------------------------------------------------------|

**Code**

```lua
function HandTool:clearActionEvents(clearCarriedActionEvents)
    g_inputBinding:beginActionEventsModification( PlayerInputComponent.INPUT_CONTEXT_NAME)
    for inputAction, actionEvent in pairs( self.actionEvents) do
        g_inputBinding:removeActionEvent(actionEvent.actionEventId)
        self.actionEvents[inputAction] = nil
    end
    g_inputBinding:endActionEventsModification()
end

```

### createLoadingTask

**Description**

> Creates a loading task in the loadingTasks table with the given target and returns it.

**Definition**

> createLoadingTask(any target)

**Arguments**

| any | target | The id or reference used to track the loading task. |
|-----|--------|-----------------------------------------------------|

**Return Values**

| any | task | The created loading task. |
|-----|------|---------------------------|

**Code**

```lua
function HandTool:createLoadingTask(target)
    return SpecializationUtil.createLoadingTask( self , target)
end

```

### delete

**Description**

> Cleans up any resources the hand tool uses.

**Definition**

> delete()

**Code**

```lua
function HandTool:delete()
    if self.isDeleted then
        return
    end

    g_currentMission:removeOwnedItem( self )

    g_messageCenter:unsubscribeAll( self )

    local mission = g_currentMission
    local handToolSystem = mission.handToolSystem

    if self.holder ~ = nil then
        self:setHolder( nil , true )
    end

    -- If an i3d file was loaded, release the id.
    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
        self.sharedLoadRequestId = nil
    end

    SpecializationUtil.raiseEvent( self , "onDelete" )

    if self.rootNode ~ = nil and entityExists( self.rootNode) then
        delete( self.rootNode)
        self.rootNode = nil
    end

    handToolSystem:removeHandTool( self )

    if self.externalSoundsFile ~ = nil then
        self.externalSoundsFile:delete()
        self.externalSoundsFile = nil
    end

    HandTool:superClass().delete( self )

    self.isDeleted = true
end

```

### detachTool

**Description**

> Detaches the tool from its carrying player, leaving it unlinked.

**Definition**

> detachTool()

**Code**

```lua
function HandTool:detachTool()
    -- If there is no root node to detach, do nothing.
        if self.rootNode = = nil then
            return
        end

        setVisibility( self.rootNode, false )

        -- Unlink the root node completely.
        unlink( self.rootNode)
    end

```

### finishLoadingTask

**Description**

> Marks the given task as done, and calls onFinishedLoading, if readyForFinishLoading is true.

**Definition**

> finishLoadingTask(table task)

**Arguments**

| table | task | The task to mark as complete. Should be obtained from createLoadingTask. |
|-------|------|--------------------------------------------------------------------------|

**Code**

```lua
function HandTool:finishLoadingTask(task)
    SpecializationUtil.finishLoadingTask( self , task)
end

```

### getCarryingPlayer

**Description**

> Gets the player who is currently carrying this hand tool.

**Definition**

> getCarryingPlayer()

**Return Values**

| table | player | The player who has this hand tool in their inventory. |
|-------|--------|-------------------------------------------------------|

**Code**

```lua
function HandTool:getCarryingPlayer()
    return self.carryingPlayer
end

```

### getIsCarried

**Description**

> Gets the value representing if this tool is currently carried by a player.

**Definition**

> getIsCarried()

**Return Values**

| table | isCarried | True if this tool is in a player's inventory; otherwise false. Note that getIsHeld can also be true; this value is just for if the player has the tool on them. |
|-------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function HandTool:getIsCarried()
    return self.carryingPlayer ~ = nil
end

```

### getIsHeld

**Description**

> Gets the value representing if this tool is currently equipped (held) by a player.

**Definition**

> getIsHeld()

**Return Values**

| table | isHeld | True if this tool is carried and currently used by the player; otherwise false. |
|-------|--------|---------------------------------------------------------------------------------|

**Code**

```lua
function HandTool:getIsHeld()

    -- If the tool is not carried at all, it cannot be held, so return false.
    if not self:getIsCarried() then
        return false
    end

    return self.isHeld
end

```

### getIsSynchronized

**Description**

> Gets the value representing the load state of this tool, where true means the tool has fully loaded and synchronised.

**Definition**

> getIsSynchronized()

**Return Values**

| table | hasLoaded | True if the tool has fully loaded and synchronised; otherwise false. |
|-------|-----------|----------------------------------------------------------------------|

**Code**

```lua
function HandTool:getIsSynchronized()
    return self.loadingStep = = SpecializationLoadStep.SYNCHRONIZED
end

```

### getNeedsSaving

**Description**

**Definition**

> getNeedsSaving()

**Code**

```lua
function HandTool:getNeedsSaving()
    return self.canBeSaved
end

```

### getPrice

**Description**

> Returns price

**Definition**

> getPrice(float price)

**Arguments**

| float | price | price |
|-------|-------|-------|

**Code**

```lua
function HandTool:getPrice()
    return self.price
end

```

### getSellPrice

**Description**

> Get sell price

**Definition**

> getSellPrice()

**Return Values**

| float | sellPrice | sell price |
|-------|-----------|------------|

**Code**

```lua
function HandTool:getSellPrice()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    return HandTool.calculateSellPrice(storeItem, self.age, self:getPrice())
end

```

### getUniqueId

**Description**

> Gets this tool's unique id.

**Definition**

> getUniqueId()

**Return Values**

| float | uniqueId | This tool's unique id. |
|-------|----------|------------------------|

**Code**

```lua
function HandTool:getUniqueId()
    return self.uniqueId
end

```

### i3dFileLoaded

**Description**

**Definition**

> i3dFileLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | arguments    |
| any | i3dLoadingId |

**Code**

```lua
function HandTool:i3dFileLoaded(i3dNode, failedReason, arguments, i3dLoadingId)
    if i3dNode = = 0 then
        self:setLoadingState(HandToolLoadingState.ERROR)
        Logging.xmlError( self.xmlFile, "Handtool i3d loading failed!" )
        self:loadCallback()
        return
    end

    self.i3dNode = i3dNode
    setVisibility(i3dNode, false )

    self:loadFinished()
end

```

### init

**Description**

> Initialises the hand tool class.

**Definition**

> init()

**Code**

```lua
function HandTool.init()

    -- Call the init function for all specialisations that have the function.
        for name, spec in pairs(g_handToolSpecializationManager:getSpecializations()) do
            local classObj = ClassUtil.getClassObject(spec.className)
            if classObj = = nil or rawget(classObj, "init" ) = = nil then
                continue
            end

            classObj.init()
        end
    end

```

### loadFinished

**Description**

**Definition**

> loadFinished()

**Code**

```lua
function HandTool:loadFinished()
    self:setLoadingState(HandToolLoadingState.OK)
    self:setLoadingStep(SpecializationLoadStep.LOAD)

    self.age = 0
    self:setOwnerFarmId( self.handToolLoadingData.ownerFarmId, true )
    self.mass = self.xmlFile:getValue( "handTool.base#mass" , 0 )

    local savegame = self.savegame
    if savegame ~ = nil then
        local uniqueId = savegame.xmlFile:getValue(savegame.key .. "#uniqueId" , nil )
        if uniqueId ~ = nil then
            self:setUniqueId(uniqueId)
        end

        -- Load this early:it used by the handtool load functions already
        local farmId = savegame.xmlFile:getValue(savegame.key .. "#farmId" , AccessHandler.EVERYONE)
        if g_farmManager.mergedFarms ~ = nil and g_farmManager.mergedFarms[farmId] ~ = nil then
            farmId = g_farmManager.mergedFarms[farmId]
        end

        self:setOwnerFarmId(farmId, true )
    end

    self.price = self.handToolLoadingData.price
    if self.price = = 0 or self.price = = nil then
        local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
        self.price = StoreItemUtil.getDefaultPrice(storeItem, self.configurations)
    end

    self.typeDesc = self.xmlFile:getValue( "handTool.base.typeDesc" , "TypeDescription" , self.customEnvironment, true )
    self.activateText = self.xmlFile:getValue( "handTool.base.actions#activate" , "Activate" , self.customEnvironment, true )

    if self.i3dNode ~ = nil then
        self.rootNode = getChildAt( self.i3dNode, 0 )

        self.components = { }
        I3DUtil.loadI3DComponents( self.i3dNode, self.components)

        self.i3dMappings = { }
        I3DUtil.loadI3DMapping( self.xmlFile, "handTool" , self.rootLevelNodes, self.i3dMappings)

        for _, component in ipairs( self.components) do
            link(getRootNode(), component.node)
            setVisibility(component.node, false )
        end

        delete( self.i3dNode)
        self.i3dNode = nil

        self.graphicalNode = self.xmlFile:getValue( "handTool.base.graphics#node" , nil , self.components, self.i3dMappings)

        if self.graphicalNode = = nil then
            Logging.xmlError( self.xmlFile, "Handtool is missing graphical node! Graphics will not work as intended!" )
            self:setLoadingState(HandToolLoadingState.ERROR)
            self:loadCallback()
            return
        end

        self.graphicalNodeParent = getParent( self.graphicalNode)
        self.handNode = self.xmlFile:getValue( "handTool.base.handNode#node" , nil , self.components, self.i3dMappings)
        self.useLeftHand = self.xmlFile:getValue( "handTool.base.handNode#useLeftHand" , self.useLeftHand)
        self.firstPersonNode = self.xmlFile:getValue( "handTool.base.firstPersonNode#node" , nil , self.components, self.i3dMappings)
    end

    self.shouldLockFirstPerson = self.xmlFile:getValue( "handTool.base.graphics#lockFirstPerson" , nil )
    self.runMultiplier = self.xmlFile:getValue( "handTool.base#runMultiplier" , 1.0 )
    self.walkMultiplier = self.xmlFile:getValue( "handTool.base#walkMultiplier" , 1.0 )
    self.jumpMultiplier = math.clamp( self.xmlFile:getValue( "handTool.base#jumpMultiplier" , 1.0 ), 0 , 1.2 )
    self.canCrouch = self.xmlFile:getValue( "handTool.base#canCrouch" , true )
    self.mustBeHeld = self.xmlFile:getValue( "handTool.base#mustBeHeld" , false )
    self.canBeSaved = self.xmlFile:getValue( "handTool.base#canBeSaved" , true )
    if not self.handToolLoadingData.isSaved then
        self.canBeSaved = false
    end

    self.canBeDropped = self.xmlFile:getValue( "handTool.base#canBeDropped" , true )
    if not self.handToolLoadingData.canBeDropped then
        self.canBeDropped = false
    end

    -- Load the sound properties.
    local soundsXMLFilename = self.xmlFile:getValue( "handTool.base.sounds#filename" , nil )
    soundsXMLFilename = Utils.getFilename(soundsXMLFilename, self.baseDirectory)
    self.externalSoundsFile = XMLFile.loadIfExists( "TempExternalSounds" , soundsXMLFilename, HandTool.xmlSchemaSounds)

    SpecializationUtil.raiseEvent( self , "onLoad" , self.xmlFile, self.baseDirectory)
    if self.loadingState ~ = HandToolLoadingState.OK then
        Logging.xmlError( self.xmlFile, "HandTool loading failed!" )
        self:loadCallback()
        return
    end

    self:setLoadingStep(SpecializationLoadStep.POST_LOAD)

    SpecializationUtil.raiseEvent( self , "onPostLoad" , self.savegame)

    if self.loadingState ~ = HandToolLoadingState.OK then
        Logging.xmlError( self.xmlFile, "HandTool post-loading failed!" )
        self:loadCallback()
        return
    end

    if savegame ~ = nil then
        self.age = savegame.xmlFile:getValue(savegame.key .. "#age" , 0 )
        self.price = savegame.xmlFile:getValue(savegame.key .. "#price" , self.price)
    end

    local mission = g_currentMission
    if mission ~ = nil and mission.environment ~ = nil then
        g_messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.periodChanged, self )
    end

    if # self.loadingTasks = = 0 then
        self:onFinishedLoading()
    else
            self.readyForFinishLoading = true
            self:setLoadingStep(SpecializationLoadStep.AWAIT_SUB_I3D)
        end
    end

```

### new

**Description**

> Creates a new hand tool instance.

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | True if this instance is being created on the server. |
|---------|----------|-------------------------------------------------------|
| boolean | isClient | True if this instance is being created on the client. |
| table?  | customMt |                                                       |

**Return Values**

| table? | self | The created instance. |
|--------|------|-----------------------|

**Code**

```lua
function HandTool.new(isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or HandTool _mt)

    self.finishedLoading = false
    self.isDeleted = false
    self.updateLoopIndex = - 1
    self.sharedLoadRequestId = nil
    self.loadingState = HandToolLoadingState.OK
    self.loadingStep = SpecializationLoadStep.CREATED

    self.loadingTasks = { }
    self.readyForFinishLoading = false

    self.uniqueId = nil

    self.rootNode = nil
    self.graphicalNode = nil
    self.handNode = nil
    self.useLeftHand = false
    self.firstPersonNode = nil

    self.mass = 0

    self.actionEvents = { }

    self.carryingPlayer = nil
    self.isHeld = false

    self.holder = nil

    return self
end

```

### onFinishedLoading

**Description**

> Called after all specializations have finished loading, and handles finalising the load state and cleaning up any
> loading variables.

**Definition**

> onFinishedLoading()

**Code**

```lua
function HandTool:onFinishedLoading()
    self:setLoadingStep(SpecializationLoadStep.FINISHED)
    SpecializationUtil.raiseEvent( self , "onLoadFinished" , self.savegame)

    -- if we are the server or in single player we don't need to be synchronized
        if self.isServer then
            self:setLoadingStep(SpecializationLoadStep.SYNCHRONIZED)
        end

        self.finishedLoading = true

        local mission = g_currentMission
        local handToolSystem = mission.handToolSystem
        if not handToolSystem:addHandTool( self ) then
            Logging.xmlError( self.xmlFile, "Failed to register handTool!" )
            self:setLoadingState(HandToolLoadingState.ERROR)
            self:loadCallback()
            return
        end

        if self.handToolLoadingData.isRegistered then
            self:register()
        end

        local holder = self.handToolLoadingData.holder
        if holder ~ = nil then
            if holder:getCanPickupHandTool( self ) then
                self.pendingHolder = holder
            end
        else
                local savegame = self.savegame
                if savegame ~ = nil then
                    self.pendingHolderUniqueId = savegame.xmlFile:getValue(savegame.key .. ".holder#uniqueId" , nil )
                end
            end

            g_currentMission:addOwnedItem( self )

            self.savegame = nil
            self.handToolLoadingData = nil

            self.xmlFile:delete()
            self.xmlFile = nil

            -- Clean up the sounds file.
            if self.externalSoundsFile ~ = nil then
                self.externalSoundsFile:delete()
                self.externalSoundsFile = nil
            end

            self:loadCallback()
        end

```

### periodChanged

**Description**

> Called if period changed

**Definition**

> periodChanged()

**Code**

```lua
function HandTool:periodChanged()
    self.age = self.age + 1
end

```

### postInit

**Description**

> Post-initialises the hand tool class.

**Definition**

> postInit()

**Code**

```lua
function HandTool.postInit()
end

```

### postReadStream

**Description**

> Called on client side on join when the handTool was fully loaded

**Definition**

> postReadStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function HandTool:postReadStream(streamId, connection)
    if streamReadBool(streamId) then
        self.pendingHolderObjectId = NetworkUtil.readNodeObjectId(streamId)
        self.isHoldingPending = streamReadBool(streamId)
        self:raiseActive()
    end

    SpecializationUtil.raiseEvent( self , "onReadStream" , streamId, connection)

    self:setLoadingStep(SpecializationLoadStep.SYNCHRONIZED)
end

```

### postWriteStream

**Description**

> Called on server side when handTool is fully loaded on client side

**Definition**

> postWriteStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function HandTool:postWriteStream(streamId, connection)
    local holder = self:getHolder()
    if streamWriteBool(streamId, holder ~ = nil ) then
        NetworkUtil.writeNodeObject(streamId, holder)
        streamWriteBool(streamId, self:getIsHeld())
    end

    SpecializationUtil.raiseEvent( self , "onWriteStream" , streamId, connection)
end

```

### readStream

**Description**

> Reads the initial tool state from the server.

**Definition**

> readStream(integer streamId, Connection connection, integer objectId)

**Arguments**

| integer    | streamId   | The id of the stream from which to read. |
|------------|------------|------------------------------------------|
| Connection | connection | The connection to the server.            |
| integer    | objectId   | The id of the tool object.               |

**Code**

```lua
function HandTool:readStream(streamId, connection, objectId)
    HandTool:superClass().readStream( self , streamId, connection, objectId)

    local filename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
    local canBeDropped = streamReadBool(streamId)

    if self.loadingStep ~ = SpecializationLoadStep.CREATED then
        Logging.error( "Try to intialize loading of a handtool that is already loading!" )
        return
    end

    local data = HandToolLoadingData.new()
    data:setFilename(filename)
    data:setOwnerFarmId( self.ownerFarmId)
    data:setCanBeDropped(canBeDropped)

    local asyncCallbackFunction = function (_, handTool, loadingState)
        if loadingState = = HandToolLoadingState.OK then
            g_client:onObjectFinishedAsyncLoading(handTool)
        else
                Logging.error( "Failed to load handtool on client" )
                printCallstack()
            end
        end

        data:loadHandToolOnClient( self , asyncCallbackFunction, nil )
    end

```

### readUpdateStream

**Description**

> Called on client side on update

**Definition**

> readUpdateStream(integer streamId, table connection, )

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| any     | connection |            |

**Code**

```lua
function HandTool:readUpdateStream(streamId, timestamp, connection)
    SpecializationUtil.raiseEvent( self , "onReadUpdateStream" , streamId, timestamp, connection)
end

```

### register

**Description**

**Definition**

> register()

**Arguments**

| any | alreadySent |
|-----|-------------|

**Code**

```lua
function HandTool:register(alreadySent)
    HandTool:superClass().register( self , alreadySent)

    SpecializationUtil.raiseEvent( self , "onRegistered" , alreadySent)
end

```

### registerEvents

**Description**

> Registers all specialization events to the given hand tool type.

**Definition**

> registerEvents(table handToolType)

**Arguments**

| table | handToolType | The specialisation type to which the functions are registered. |
|-------|--------------|----------------------------------------------------------------|

**Code**

```lua
function HandTool.registerEvents(handToolType)
    SpecializationUtil.registerEvent(handToolType, "onPreLoad" )
    SpecializationUtil.registerEvent(handToolType, "onLoad" )
    SpecializationUtil.registerEvent(handToolType, "onPostLoad" )
    SpecializationUtil.registerEvent(handToolType, "onLoadFinished" )
    SpecializationUtil.registerEvent(handToolType, "onDelete" )
    SpecializationUtil.registerEvent(handToolType, "onSave" )
    SpecializationUtil.registerEvent(handToolType, "onRegistered" )
    SpecializationUtil.registerEvent(handToolType, "onWriteStream" )
    SpecializationUtil.registerEvent(handToolType, "onReadStream" )
    SpecializationUtil.registerEvent(handToolType, "onWriteUpdateStream" )
    SpecializationUtil.registerEvent(handToolType, "onReadUpdateStream" )
    SpecializationUtil.registerEvent(handToolType, "onPreUpdate" )
    SpecializationUtil.registerEvent(handToolType, "onUpdate" )
    SpecializationUtil.registerEvent(handToolType, "onPostUpdate" )
    SpecializationUtil.registerEvent(handToolType, "onUpdateTick" )
    SpecializationUtil.registerEvent(handToolType, "onDraw" )

    SpecializationUtil.registerEvent(handToolType, "onRegisterActionEvents" )
    SpecializationUtil.registerEvent(handToolType, "onHandToolHolderChanged" )
    SpecializationUtil.registerEvent(handToolType, "onHeldStart" )
    SpecializationUtil.registerEvent(handToolType, "onHeldEnd" )

    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerStyleChanged" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerShown" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerHidden" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerEnteredVehicle" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerExitedVehicle" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerChanged" )
    SpecializationUtil.registerEvent(handToolType, "onCarryingPlayerPerspectiveSwitched" )

    SpecializationUtil.registerEvent(handToolType, "onDebugDraw" )
end

```

### registerSavegameXMLPaths

**Description**

> Registers all node paths used for the savegame xml file.

**Definition**

> registerSavegameXMLPaths(XMLSchema savegameXMLSchema)

**Arguments**

| XMLSchema | savegameXMLSchema | The schema used for the savegame hand tools. |
|-----------|-------------------|----------------------------------------------|

**Code**

```lua
function HandTool.registerSavegameXMLPaths(savegameXMLSchema)
    local handToolBaseKey = "handTools.handTool(?)"

    savegameXMLSchema:register(XMLValueType.STRING, handToolBaseKey .. "#filename" , "The filename of the tool xml file" , nil , true )
    savegameXMLSchema:register(XMLValueType.STRING, handToolBaseKey .. "#modName" , "Name of mod" )
    savegameXMLSchema:register(XMLValueType.STRING, handToolBaseKey .. "#uniqueId" , "The unique id of the hand tool within the savegame" , nil , true )
    savegameXMLSchema:register(XMLValueType.INT, handToolBaseKey .. "#farmId" , "The id of the farm owning the tool" , nil , true )
    savegameXMLSchema:register(XMLValueType.FLOAT, handToolBaseKey .. "#age" , "The age of the hand tool" , nil , true )
    savegameXMLSchema:register(XMLValueType.FLOAT, handToolBaseKey .. "#price" , "The price of the hand tool" , nil , true )
    savegameXMLSchema:register(XMLValueType.STRING, handToolBaseKey .. ".holder#uniqueId" , "Last holder" , nil , true )

    -- Register all loaded specialisations.
    for _, specialisation in pairs(g_handToolSpecializationManager:getSpecializations()) do
        local specialisationClass = ClassUtil.getClassObject(specialisation.className)
        if specialisationClass.registerSavegameXMLPaths then
            specialisationClass.registerSavegameXMLPaths(savegameXMLSchema, handToolBaseKey)
        end
    end
end

```

### registerXMLPaths

**Description**

> Registers xml paths within the hand tool schema.

**Definition**

> registerXMLPaths()

**Code**

```lua
function HandTool.registerXMLPaths()

    -- Create the schema.
    local xmlSchema = XMLSchema.new( "handTool" )
    HandTool.xmlSchema = xmlSchema

    g_storeManager:addSpeciesXMLSchema(StoreSpecies.HANDTOOL, HandTool.xmlSchema)
    g_handToolTypeManager:setXMLSchema( HandTool.xmlSchema)

    HandTool.xmlSchemaSounds = XMLSchema.new( "handTool_sounds" )
    HandTool.xmlSchemaSounds:setRootNodeName( "sounds" )
    HandTool.xmlSchema:addSubSchema( HandTool.xmlSchemaSounds, "sounds" )

    -- Register store paths.
    StoreManager.registerStoreDataXMLPaths(xmlSchema, "handTool" )
    I3DUtil.registerI3dMappingXMLPaths(xmlSchema, "handTool" )

    xmlSchema:register(XMLValueType.STRING, "handTool.annotation" , "Annotation" , nil , true )

    -- Register base node.
    xmlSchema:register(XMLValueType.BOOL, "handTool.base#canCrouch" , "If the player can crouch while holding this tool" , true , false )
        xmlSchema:register(XMLValueType.BOOL, "handTool.base#mustBeHeld" , "True if this tool must be held, and cannot be put away; false otherwise" , false , false )
            xmlSchema:register(XMLValueType.BOOL, "handTool.base#canBeSaved" , "True if this tool can be saved; false otherwise" , "Defaults to true, so that the tool will be saved" , false )
                xmlSchema:register(XMLValueType.BOOL, "handTool.base#canBeDropped" , "True if this tool can be dropped to inventory" , "Defaults to true, so that the tool will be dropped" , false )
                    xmlSchema:register(XMLValueType.FLOAT, "handTool.base#runMultiplier" , "The amount of run speed the player gains while running with this tool" , true , false )
                        xmlSchema:register(XMLValueType.FLOAT, "handTool.base#walkMultiplier" , "The amount of walk speed the player gains while walking with this tool" , true , false )
                            xmlSchema:register(XMLValueType.FLOAT, "handTool.base#jumpMultiplier" , "The amount of jump strength the player gains while walking with this tool" , true , false )
                                xmlSchema:register(XMLValueType.L10N_STRING, "handTool.base.actions#activate" , "The text displayed for activating the tool" , nil , false )
                                    xmlSchema:register(XMLValueType.STRING, "handTool.base.filename" , "Hand tool i3d file" , nil , false )
                                    xmlSchema:register(XMLValueType.L10N_STRING, "handTool.base.typeDesc" , "Hand tool name localization string" , nil , false )
                                    xmlSchema:register(XMLValueType.STRING, "handTool.base.sounds#filename" , "The filename of the xml file defining the sounds of the tool" , nil , false )
                                    xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.base.graphics#node" , "The node containing all the graphical nodes of the tool" , nil , false )
                                    xmlSchema:register(XMLValueType.BOOL, "handTool.base.graphics#lockFirstPerson" , "True if first person mode should be forced, false for third person.A lack of this attribute does not lock the perspective at all" , nil , false )
                                        xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.base.handNode#node" , "The node used to position the hand tool when held in third person" , nil , false )
                                        xmlSchema:register(XMLValueType.BOOL, "handTool.base.handNode#useLeftHand" , "If the handtool should be attached to player left hand" , nil , false )
                                        xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.base.firstPersonNode#node" , "The node used to position the hand tool when held in first person" , nil , false )
                                        xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.base.carried#targetNode" , "The node of the player character that the tool is attached to when not held" , nil , false )
                                        xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.base.carried#node" , "The node used to position the hand tool when not held" , nil , false )
                                        xmlSchema:register(XMLValueType.FLOAT, "handTool.base#mass" , "Mass in kilograms" , nil , false )

                                        -- Register root node attributes.
                                        xmlSchema:register(XMLValueType.STRING, "handTool#type" , "The specialisation type of the hand tool" , nil , true )
                                        xmlSchema:registerAutoCompletionDataSource( "handTool#type" , "$dataS/handToolTypes.xml" , "handToolTypes.type#name" )

                                        -- Register all loaded specialisations.
                                        for _, specialisation in pairs(g_handToolSpecializationManager:getSpecializations()) do
                                            local specialisationClass = ClassUtil.getClassObject(specialisation.className)
                                            if specialisationClass.registerXMLPaths then
                                                specialisationClass.registerXMLPaths(xmlSchema)
                                                xmlSchema:setXMLSpecializationType()
                                            end
                                        end
                                    end

```

### saveToXMLFile

**Description**

> Saves this hand tool to the given savegame xml file under the given key.

**Definition**

> saveToXMLFile(XMLFile xmlFile, string key, table usedModNames)

**Arguments**

| XMLFile | xmlFile      | The savegame xml file to save to (Handtools.xml).               |
|---------|--------------|-----------------------------------------------------------------|
| string  | key          | The base key under which to create the hand tool node.          |
| table   | usedModNames | The collection of currently used mod names in the current game. |

**Code**

```lua
function HandTool:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#uniqueId" , self.uniqueId)
    xmlFile:setValue(key .. "#farmId" , self:getOwnerFarmId() or - 1 )
    xmlFile:setValue(key .. "#age" , self.age)

    if self.holder ~ = nil then
        xmlFile:setValue(key .. ".holder#uniqueId" , self.holder:getUniqueId())
    end

    for id, spec in pairs( self.specializations) do
        local name = self.specializationNames[id]

        if spec.saveToXMLFile ~ = nil then
            spec.saveToXMLFile( self , xmlFile, key .. "." .. name, usedModNames)
        end
    end
end

```

### setCarryingPlayer

**Description**

> Sets the player who is currently carrying this hand tool.

**Definition**

> setCarryingPlayer(Player player)

**Arguments**

| Player | player | the player |
|--------|--------|------------|

**Code**

```lua
function HandTool:setCarryingPlayer(player)
    --#debug Logging.devInfo("HandTool:setCarryingPlayer '%s' for hand tool %q(%s)", player and player.uniqueUserId or "nil", self.configFileName, self.uniqueId)
        local lastCarryingPlayer = self.carryingPlayer
        self.carryingPlayer = player

        SpecializationUtil.raiseEvent( self , "onCarryingPlayerChanged" , player, lastCarryingPlayer)

        self:clearActionEvents()
        if player ~ = nil and player.isOwner then
            self:registerActionEvents()
        end
    end

```

### setFilename

**Description**

**Definition**

> setFilename()

**Arguments**

| any | filename |
|-----|----------|

**Code**

```lua
function HandTool:setFilename(filename)
    self.configFileName = filename
    self.configFileNameClean = Utils.getFilenameInfo(filename, true )

    self.customEnvironment, self.baseDirectory = Utils.getModNameAndBaseDirectory(filename)
end

```

### setLoadCallback

**Description**

**Definition**

> setLoadCallback()

**Arguments**

| any | loadCallbackFunction          |
|-----|-------------------------------|
| any | loadCallbackFunctionTarget    |
| any | loadCallbackFunctionArguments |

**Code**

```lua
function HandTool:setLoadCallback(loadCallbackFunction, loadCallbackFunctionTarget, loadCallbackFunctionArguments)
    self.loadCallbackFunction = loadCallbackFunction
    self.loadCallbackFunctionTarget = loadCallbackFunctionTarget
    self.loadCallbackFunctionArguments = loadCallbackFunctionArguments
end

```

### setLoadingState

**Description**

**Definition**

> setLoadingState()

**Arguments**

| any | loadingState |
|-----|--------------|

**Code**

```lua
function HandTool:setLoadingState(loadingState)
    if HandToolLoadingState.getName(loadingState) ~ = nil then
        self.loadingState = loadingState
    else
            printCallstack()
            Logging.error( "Invalid loading state '%s'!" , loadingState)
        end
    end

```

### setLoadingStep

**Description**

> Sets the loadingStep value of this handtool, logging an error if the given step is invalid.

**Definition**

> setLoadingStep(SpecializationLoadStep loadingStep)

**Arguments**

| SpecializationLoadStep | loadingStep | The loading step to set. |
|------------------------|-------------|--------------------------|

**Code**

```lua
function HandTool:setLoadingStep(loadingStep)
    SpecializationUtil.setLoadingStep( self , loadingStep)
end

```

### setType

**Description**

**Definition**

> setType()

**Arguments**

| any | typeDef |
|-----|---------|

**Code**

```lua
function HandTool:setType(typeDef)
    SpecializationUtil.initSpecializationsIntoTypeClass(g_handToolTypeManager, typeDef, self )
end

```

### setUniqueId

**Description**

> Sets this tool's unique id. Note that a hand tool's id should not be changed once it has been first set.

**Definition**

> setUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id to use. |
|--------|----------|-----------------------|

**Code**

```lua
function HandTool:setUniqueId(uniqueId)
    --#debug Assert.isType(uniqueId, "string", "Hand tool unique id must be a string!")
    --#debug Assert.isNil(self.uniqueId, "Should not change a hand tool's unique id!")
    self.uniqueId = uniqueId
end

```

### startHolding

**Description**

> Fired when the player starts holding this hand tool in their hands.

**Definition**

> startHolding()

**Code**

```lua
function HandTool:startHolding()
    --#debug Logging.devInfo("HandTool:startHolding for hand tool %q(%s)", self.configFileName, self.uniqueId)

        self:raiseActive()

        -- Begin getting the tool out.
        self.isHoldStarting = true

        local player = self.carryingPlayer

        -- Handle locking the player's perspective if needed.
            if player ~ = nil and player:getForceHandToolFirstPerson() and self.shouldLockFirstPerson ~ = nil then
                self.wasInFirstPerson = player.camera.isFirstPerson
                if self.shouldLockFirstPerson then
                    player.camera:lockFirstPersonMode()
                else
                        player.camera:lockThirdPersonMode()
                    end
                end

                self.isHeld = true

                -- Attach the tool to the player.
                self:attachTool()

                -- Raise the held start event.
                SpecializationUtil.raiseEvent( self , "onHeldStart" , player)

                self:clearActionEvents()
                if player ~ = nil and player.isOwner then
                    self:registerActionEvents()
                end

                -- Finish getting the tool out.
                self.isHoldStarting = false
            end

```

### stopHolding

**Description**

> Fired when the player stops holding this hand tool in their hands.

**Definition**

> stopHolding(Player player)

**Arguments**

| Player | player | The player who was holding this tool. |
|--------|--------|---------------------------------------|

**Code**

```lua
function HandTool:stopHolding()
    --#debug Logging.devInfo("HandTool:stopHolding for hand tool %q(%s)", self.configFileName, self.uniqueId)

        -- Begin putting the tool away.
        self.isHoldEnding = true

        local carryingPlayer = self:getCarryingPlayer()

        -- Handle unlocking and resetting the perspective, if needed.
            if carryingPlayer ~ = nil and carryingPlayer:getForceHandToolFirstPerson() and self.shouldLockFirstPerson ~ = nil then
                carryingPlayer.camera:unlockSwitching()
                carryingPlayer.camera:switchToPerspective( self.wasInFirstPerson)
            end

            self.isHeld = false

            -- Detach the tool from the player.
            self:detachTool()

            -- Raise the held end event.
            SpecializationUtil.raiseEvent( self , "onHeldEnd" )

            -- Unbind any bound controls.
            self:clearActionEvents()
            if carryingPlayer ~ = nil and carryingPlayer.isOwner then
                self:registerActionEvents()
            end

            -- Stop putting the tool away.
            self.isHoldEnding = false
        end

```

### update

**Description**

> Updates this hand tool as it is being held in the player's hands.

**Definition**

> update(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function HandTool:update(dt)
    if self.pendingHolder ~ = nil then
        self:setHolder( self.pendingHolder)
        self.pendingHolder = nil
    end

    if self.pendingHolderObjectId ~ = nil then
        local holder = NetworkUtil.getObject( self.pendingHolderObjectId)
        if holder ~ = nil then
            if holder:getCanPickupHandTool( self ) then
                self:setHolder(holder, true )

                if self.isHoldingPending and self.carryingPlayer ~ = nil then
                    self.carryingPlayer:setCurrentHandTool( self , true )
                end
            end
            self.pendingHolderObjectId = nil
            self.isHoldingPending = nil
        end
        self:raiseActive()
    end

    if self.pendingHolderUniqueId ~ = nil then
        local mission = g_currentMission
        local holder = mission:getObjectByUniqueId( self.pendingHolderUniqueId)
        if holder ~ = nil then
            self:setHolder(holder)
            self.pendingHolderUniqueId = nil
        end
        self:raiseActive()
    end

    SpecializationUtil.raiseEvent( self , "onPreUpdate" , dt)

    SpecializationUtil.raiseEvent( self , "onUpdate" , dt)

    SpecializationUtil.raiseEvent( self , "onPostUpdate" , dt)

    if self:getIsHeld() then
        local carryingPlayer = self:getCarryingPlayer()
        if carryingPlayer ~ = nil and carryingPlayer:getIsControlled() then
            self:raiseActive()
        end
    end
end

```

### writeStream

**Description**

> Writes the state of this tool to the network stream.

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | The id of the stream to which to write.                                |
|------------|------------|------------------------------------------------------------------------|
| Connection | connection | The connection to the specific client who will receive this tool data. |

**Code**

```lua
function HandTool:writeStream(streamId, connection)
    HandTool:superClass().writeStream( self , streamId, connection)

    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.configFileName))
    streamWriteBool(streamId, self.canBeDropped)
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
function HandTool:writeUpdateStream(streamId, connection, dirtyMask)
    SpecializationUtil.raiseEvent( self , "onWriteUpdateStream" , streamId, connection, dirtyMask)
end

```