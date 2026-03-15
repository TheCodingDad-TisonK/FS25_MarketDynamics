## HandToolHolder

**Description**

> An object that can hold a HandTool for storage or transportation purposes.

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [delete](#delete)
- [drawDebug](#drawdebug)
- [getCanPickupHandTool](#getcanpickuphandtool)
- [getCanPickupHandToolFromMenu](#getcanpickuphandtoolfrommenu)
- [getHandTool](#gethandtool)
- [getHolderName](#getholdername)
- [getHolderNodePair](#getholdernodepair)
- [getSpawnedHandTool](#getspawnedhandtool)
- [getSpawnsHandTool](#getspawnshandtool)
- [getUniqueId](#getuniqueid)
- [load](#load)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [onDropHandTool](#ondrophandtool)
- [onDummyHandToolI3DLoaded](#ondummyhandtooli3dloaded)
- [onFinishedLoading](#onfinishedloading)
- [onPickupHandTool](#onpickuphandtool)
- [onPlayerCallback](#onplayercallback)
- [onSpawnedHandToolLoaded](#onspawnedhandtoolloaded)
- [readStream](#readstream)
- [register](#register)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setHolderName](#setholdername)
- [setOwnerFarmId](#setownerfarmid)
- [setPickupCallback](#setpickupcallback)
- [setPlayerInRange](#setplayerinrange)
- [setStoreCallback](#setstorecallback)
- [setUniqueId](#setuniqueid)
- [updateDummyHandTool](#updatedummyhandtool)
- [writeStream](#writestream)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function HandToolHolder:delete()
    local handTool = self.handTool

    self.storeCallback = nil
    self.pickupCallback = nil

    if self.pendingHandToolData ~ = nil then
        self.pendingHandToolData:cancelLoading()
        self.pendingHandToolData = nil
    end

    if handTool ~ = nil and handTool ~ = self.spawnedHandTool then
        handTool:setHolder( nil )
    end

    if self.spawnedHandTool ~ = nil then
        self.spawnedHandTool:setHolder( nil , true )
        self.spawnedHandTool:delete()
    end

    if self.activationTrigger ~ = nil then
        removeTrigger( self.activationTrigger)
        self.activationTrigger = nil
    end

    if self.dummySharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.dummySharedLoadRequestId)
        self.dummySharedLoadRequestId = nil
    end

    self.parent = nil

    g_currentMission.handToolSystem:removeHandToolHolder( self )
    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)

    HandToolHolder:superClass().delete( self )
end

```

### drawDebug

**Description**

**Definition**

> drawDebug()

**Code**

```lua
function HandToolHolder:drawDebug()

    if self.handTool ~ = nil then
        local holderNode, toolNode = self:getHolderNodePair( self:getHandTool())
        DebugGizmo.renderAtNode(holderNode)
        DebugGizmo.renderAtNode(toolNode)
    else
            DebugGizmo.renderAtNode( self.holderNode)
        end
    end

```

### getCanPickupHandTool

**Description**

**Definition**

> getCanPickupHandTool()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolHolder:getCanPickupHandTool(handTool)
    -- If there is already a tool in this holder, return false.
    if self.handTool ~ = nil then
        return false
    end

    -- If the given tool is nil, or is not storable, return false.
    if handTool = = nil or handTool.spec_storable = = nil then
        return false
    end

    -- If this holder uses a spawned tool, check that the given tool is the spawned tool.
    if self:getSpawnsHandTool() then
        return self:getSpawnedHandTool() = = handTool
    else
            -- Otherwise; check that the given tool is the correct type and belongs to the farm.
            local handToolHolderNode = handTool:getHolsterNodeByType( self.holderType)
            local handToolFarmId = handTool:getOwnerFarmId()
            local holderFarmId = self:getOwnerFarmId()
            local sameFarm = handToolFarmId = = holderFarmId

            return handToolHolderNode ~ = nil and sameFarm
        end
    end

```

### getCanPickupHandToolFromMenu

**Description**

**Definition**

> getCanPickupHandToolFromMenu()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolHolder:getCanPickupHandToolFromMenu(handTool)
    return true
end

```

### getHandTool

**Description**

**Definition**

> getHandTool()

**Code**

```lua
function HandToolHolder:getHandTool()
    return self.handTool
end

```

### getHolderName

**Description**

**Definition**

> getHolderName()

**Code**

```lua
function HandToolHolder:getHolderName()
    return self.name
end

```

### getHolderNodePair

**Description**

**Definition**

> getHolderNodePair()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolHolder:getHolderNodePair(handTool)
    if handTool.getHolsterNodeByType = = nil then
        return nil , nil
    end

    -- Get the holder node from the hand tool for this holder.If it is nil, return nil.
        local handToolHolderNode = handTool:getHolsterNodeByType( self.holderType)
        if handToolHolderNode = = nil then
            return nil , nil
        end

        -- Return the two nodes that should be linked.
        return self.holderNode, handToolHolderNode
    end

```

### getSpawnedHandTool

**Description**

**Definition**

> getSpawnedHandTool()

**Code**

```lua
function HandToolHolder:getSpawnedHandTool()
    return self.spawnedHandTool
end

```

### getSpawnsHandTool

**Description**

**Definition**

> getSpawnsHandTool()

**Code**

```lua
function HandToolHolder:getSpawnsHandTool()
    return self.spawnedHandToolFilename ~ = nil
end

```

### getUniqueId

**Description**

> Gets this holder's unique id.

**Definition**

> getUniqueId()

**Return Values**

| any | uniqueId | This tool's unique id. |
|-----|----------|------------------------|

**Code**

```lua
function HandToolHolder:getUniqueId()
    return self.uniqueId
end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | xmlFile        |
|-----|----------------|
| any | key            |
| any | callback       |
| any | callbackTarget |
| any | callbackArgs   |
| any | components     |
| any | i3dMappings    |
| any | baseDirectory  |
| any | customEnv      |

**Code**

```lua
function HandToolHolder:load(xmlFile, key, callback, callbackTarget, callbackArgs, components, i3dMappings, baseDirectory, customEnv)
    self.holderType = xmlFile:getValue(key .. ".holder#type" , nil )
    self.holderNode = xmlFile:getValue(key .. ".holder#node" , nil , components, i3dMappings)

    local dummyFilename = xmlFile:getValue(key .. ".holder#dummyFilename" )
    if dummyFilename ~ = nil then
        dummyFilename = Utils.getFilename(dummyFilename, baseDirectory)

        self.dummySharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(dummyFilename, true , true , self.onDummyHandToolI3DLoaded, self , nil )
    end

    self.clickBoxes = { }
    for nodeIndex, clickBoxNodeKey in xmlFile:iterator(key .. ".clickBoxes.clickBox" ) do
        local clickBox = xmlFile:getValue(clickBoxNodeKey .. "#node" , nil , components, i3dMappings)
        if clickBox ~ = nil then
            table.insert( self.clickBoxes, clickBox)
        end
    end

    self.activationTrigger = xmlFile:getValue(key .. ".trigger#node" , nil , components, i3dMappings)
    if self.activationTrigger then
        addTrigger( self.activationTrigger, "onPlayerCallback" , self )
    end

    self.callback = callback
    self.callbackTarget = callbackTarget
    self.callbackArgs = callbackArgs

    -- Get the name of the tool.If none was given, do nothing.
        local spawnedHandToolFilename = xmlFile:getValue(key .. ".spawnedHandToolFilename" )
        if spawnedHandToolFilename ~ = nil then
            spawnedHandToolFilename = Utils.getFilename(spawnedHandToolFilename, baseDirectory)

            self.spawnedHandToolFilename = spawnedHandToolFilename

            local data = HandToolLoadingData.new()
            data:setFilename(spawnedHandToolFilename)
            data:setOwnerFarmId( self:getOwnerFarmId())
            data:setIsRegistered( false )
            data:load( self.onSpawnedHandToolLoaded, self )
            self.pendingHandToolData = data

            self.isHandToolPending = true
        end

        -- Set the take/store activatable texts.
        local takeText = xmlFile:getValue(key .. ".actions#takeText" , "action_takeHandTool" , customEnv, true )
        local storeText = xmlFile:getValue(key .. ".actions#storeText" , "action_returnHandTool" , customEnv, true )
        self.activatable = HandToolHolderActivatable.new( self , takeText, storeText, self.activationTrigger = = nil )

        if not self.isHandToolPending then
            self:onFinishedLoading()
        end
    end

```

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
function HandToolHolder:loadFromXMLFile(xmlFile, key)
    local uniqueId = xmlFile:getValue(key .. "#uniqueId" , nil )
    if uniqueId ~ = nil then
        self:setUniqueId(uniqueId)
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | parent   |
|-----|----------|
| any | isServer |
| any | isClient |
| any | customMt |

**Code**

```lua
function HandToolHolder.new(parent, isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or HandToolHolder _mt)

    self.parent = parent
    self.name = ""
    self.handTool = nil
    self.isPlayerInRange = false

    return self
end

```

### onDropHandTool

**Description**

**Definition**

> onDropHandTool()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolHolder:onDropHandTool(handTool)
    if handTool = = nil or handTool ~ = self.handTool then
        return
    end

    -- Unlink the hand tool node from the holder.
    unlink(handTool.rootNode)

    self.handTool = nil

    if self.pickupCallback ~ = nil then
        self.pickupCallback(handTool)
    end

    self:updateDummyHandTool()

    return handTool
end

```

### onDummyHandToolI3DLoaded

**Description**

**Definition**

> onDummyHandToolI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function HandToolHolder:onDummyHandToolI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        self.dummyHandTool = getChildAt(i3dNode, 0 )
        link( self.holderNode, self.dummyHandTool)
        delete(i3dNode)
        self:updateDummyHandTool()
    end
end

```

### onFinishedLoading

**Description**

**Definition**

> onFinishedLoading()

**Code**

```lua
function HandToolHolder:onFinishedLoading()
    self.callback( self.callbackTarget, self , self.callbackArgs)

    g_currentMission.handToolSystem:addHandToolHolder( self )

    if self.activationTrigger = = nil then
        g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
    end
end

```

### onPickupHandTool

**Description**

**Definition**

> onPickupHandTool()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolHolder:onPickupHandTool(handTool)
    if handTool = = nil then
        return false
    end

    -- If this holder cannot hold the hand tool, return false.
    if not self:getCanPickupHandTool(handTool) then
        return false
    end

    -- Get the nodes to link, if they are nil then return false.
        local holderNode, handToolHolderNode = self:getHolderNodePair(handTool)
        if holderNode = = nil or handToolHolderNode = = nil then
            return false
        end

        self.handTool = handTool

        if self.storeCallback ~ = nil then
            self.storeCallback(handTool)
        end

        -- Link the tool to the holder and transform it so that the tool's holder node matches the transform of the holder's holder node.
        HandToolUtil.linkAndTransformRelativeToParent(handTool.rootNode, handToolHolderNode, holderNode)

        -- If the graphical node is not the root node of the tool, reset it.
        if handTool.graphicalNode ~ = handTool.rootNode then
            setTranslation(handTool.graphicalNode, 0 , 0 , 0 )
            setRotation(handTool.graphicalNode, 0 , 0 , 0 )
        end

        self:updateDummyHandTool()

        return true
    end

```

### onPlayerCallback

**Description**

**Definition**

> onPlayerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function HandToolHolder:onPlayerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
            if onEnter then
                g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
                self:setPlayerInRange( true )
            else
                    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                    self:setPlayerInRange( false )
                end
            end
        end
    end

```

### onSpawnedHandToolLoaded

**Description**

**Definition**

> onSpawnedHandToolLoaded()

**Arguments**

| any | handTool     |
|-----|--------------|
| any | loadingState |

**Code**

```lua
function HandToolHolder:onSpawnedHandToolLoaded(handTool, loadingState)
    self.pendingHandToolData = nil

    -- Ensure the tool was loaded.
    if handTool = = nil then
        Logging.error( "Could not load spawned hand tool for HandToolHolder!" )
            self.callback( self.callbackTarget, nil , self.callbackArgs)
            return
        end

        self.spawnedHandTool = handTool
        handTool:setAttachedHolder( self )
        handTool:setHolder( self , true )

        if self.isRegistered then
            handTool:register( true )
        end

        -- If there is no spawned hand tool filename set, set it to the filename of the given hand tool.
        if string.isNilOrWhitespace( self.spawnedHandToolFilename) then
            self.spawnedHandToolFilename = handTool.xmlFilename
        end

        self:onFinishedLoading()
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
function HandToolHolder:readStream(streamId, connection, objectId)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spawnedHandTool = self.spawnedHandTool
            local spawnedHandToolId = NetworkUtil.readNodeObjectId(streamId)
            spawnedHandTool:postReadStream(streamId, connection)
            g_client:finishRegisterObject(spawnedHandTool, spawnedHandToolId)
        end
    end
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
function HandToolHolder:register(alreadySent)
    HandToolHolder:superClass().register( self , alreadySent)

    if self.spawnedHandTool ~ = nil then
        if not self.spawnedHandTool.isRegistered then
            self.spawnedHandTool:register( true )
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
function HandToolHolder.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#uniqueId" , nil , false )
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
function HandToolHolder.registerXMLPaths(schema, basePath)
    schema:setXMLSharedRegistration( "HandToolHolder" , basePath)

    schema:register(XMLValueType.STRING, basePath .. ".handToolHolder(?).holder#type" , "The type of hand tool that this holder accepts" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".handToolHolder(?).holder#node" , "The name of the node specifying the orientation of the held tool" )
    schema:register(XMLValueType.STRING, basePath .. ".handToolHolder(?).holder#dummyFilename" , "The filename of a dummy object that will be visible while player is in range" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".handToolHolder(?).clickBoxes.clickBox(?)#node" , "The name of the clickbox node" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".handToolHolder(?).trigger#node" , "Player activation trigger" )
        schema:register(XMLValueType.STRING, basePath .. ".handToolHolder(?).spawnedHandToolFilename" , "The filepath of the hand tool that is spawned.If this is not nil, then only the spawned tool can be put into and taken out of this holder" )
        schema:register(XMLValueType.L10N_STRING, basePath .. ".handToolHolder(?).actions#takeText" , "The name of the localization string displayed when the player can take the tool" )
        schema:register(XMLValueType.L10N_STRING, basePath .. ".handToolHolder(?).actions#storeText" , "The name of the localization string displayed when the player can store a tool" )

        schema:resetXMLSharedRegistration( "HandToolHolder" , basePath)
    end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function HandToolHolder:saveToXMLFile(xmlFile, key)
    xmlFile:setValue(key .. "#uniqueId" , self.uniqueId)
end

```

### setHolderName

**Description**

**Definition**

> setHolderName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function HandToolHolder:setHolderName(name)
    self.name = name
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | farmId      |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function HandToolHolder:setOwnerFarmId(farmId, noEventSend)
    HandToolHolder:superClass().setOwnerFarmId( self , farmId, noEventSend)

    if self.spawnedHandTool ~ = nil then
        self.spawnedHandTool:setOwnerFarmId(farmId, true )
    end
end

```

### setPickupCallback

**Description**

**Definition**

> setPickupCallback()

**Arguments**

| any | pickupCallback |
|-----|----------------|

**Code**

```lua
function HandToolHolder:setPickupCallback(pickupCallback)
    self.pickupCallback = pickupCallback
end

```

### setPlayerInRange

**Description**

**Definition**

> setPlayerInRange()

**Arguments**

| any | isInRange |
|-----|-----------|

**Code**

```lua
function HandToolHolder:setPlayerInRange(isInRange)
    self.isPlayerInRange = isInRange
    self:updateDummyHandTool()
end

```

### setStoreCallback

**Description**

**Definition**

> setStoreCallback()

**Arguments**

| any | storeCallback |
|-----|---------------|

**Code**

```lua
function HandToolHolder:setStoreCallback(storeCallback)
    self.storeCallback = storeCallback
end

```

### setUniqueId

**Description**

> Sets this holder's unique id. Note that a holder's id should not be changed once it has been first set.

**Definition**

> setUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id to use. |
|--------|----------|-----------------------|

**Code**

```lua
function HandToolHolder:setUniqueId(uniqueId)
    --#debug Assert.isType(uniqueId, "string", "Hand tool holder unique id must be a string!")
    --#debug Assert.isNil(self.uniqueId, "Should not change a hand tool holder's unique id!")
    self.uniqueId = uniqueId
end

```

### updateDummyHandTool

**Description**

**Definition**

> updateDummyHandTool()

**Code**

```lua
function HandToolHolder:updateDummyHandTool()
    if self.dummyHandTool ~ = nil then
        local isVisible = self.isPlayerInRange and self.handTool = = nil
        setVisibility( self.dummyHandTool, isVisible)
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
function HandToolHolder:writeStream(streamId, connection)
    if not connection:getIsServer() then
        local spawnedHandTool = self.spawnedHandTool
        if streamWriteBool(streamId, spawnedHandTool ~ = nil ) then
            NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spawnedHandTool))
            spawnedHandTool:postWriteStream(streamId, connection)
            g_server:registerObjectInStream(connection, spawnedHandTool)
        end
    end
end

```