## HandToolSystem

**Description**

> The class responsible for managing hand tools in the world.

**Parent**

> [AbstractManager](?version=script&category=45&class=528)

**Functions**

- [addHandTool](#addhandtool)
- [addHandToolHolder](#addhandtoolholder)
- [addPendingHandToolLoad](#addpendinghandtoolload)
- [canStartMission](#canstartmission)
- [getHandToolByUniqueId](#gethandtoolbyuniqueid)
- [getHandToolHolderByUniqueId](#gethandtoolholderbyuniqueid)
- [loadHandToolFinished](#loadhandtoolfinished)
- [loadHandToolFromXML](#loadhandtoolfromxml)
- [new](#new)
- [removeHandTool](#removehandtool)
- [removeHandToolHolder](#removehandtoolholder)
- [removePendingHandToolLoad](#removependinghandtoolload)
- [save](#save)
- [saveHandToolToXML](#savehandtooltoxml)
- [saveToXML](#savetoxml)

### addHandTool

**Description**

**Definition**

> addHandTool()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolSystem:addHandTool(handTool)
    if handTool = = nil or handTool:isa( HandTool ) = = nil then
        Logging.error( "Given object is not a handtool" )
        return false
    end

    -- Ensure the handTool has not already been added.
    if handTool:getUniqueId() ~ = nil and self.handToolsByUniqueId[handTool:getUniqueId()] ~ = nil then
        Logging.warning( "Tried to add existing handTool with unique id of %s! Existing: %s, new: %s" , handTool:getUniqueId(), tostring( self.handToolsByUniqueId[handTool:getUniqueId()]), tostring(handTool))
        return false
    end

    -- If the handTool has no unique id, give it one.
    if handTool:getUniqueId() = = nil then
        handTool:setUniqueId( Utils.getUniqueId(handTool, self.handToolsByUniqueId, HandToolSystem.UNIQUE_ID_PREFIX))
    end

    table.addElement( self.handTools, handTool)
    self.handToolsByUniqueId[handTool:getUniqueId()] = handTool

    g_messageCenter:publish(MessageType.HANDTOOL_ADDED)

    return true
end

```

### addHandToolHolder

**Description**

**Definition**

> addHandToolHolder()

**Arguments**

| any | handToolHolder |
|-----|----------------|

**Code**

```lua
function HandToolSystem:addHandToolHolder(handToolHolder)
    if handToolHolder = = nil or handToolHolder:isa( HandToolHolder ) = = nil then
        Logging.error( "Given object is not a HandToolHolder" )
        return false
    end

    -- Add the holder to the collections.
    table.addElement( self.handToolHolders, handToolHolder)

    local uniqueId = handToolHolder:getUniqueId()
    -- Ensure the handTool has not already been added.
    if uniqueId ~ = nil and self.handToolHoldersByUniqueId[uniqueId] ~ = nil then
        Logging.warning( "Tried to add existing handToolHolder(%s) but uniqueId is already in use! Existing: %s, new: %s" , uniqueId, tostring( self.handToolHoldersByUniqueId[uniqueId]), tostring(handToolHolder))
        return false
    end

    -- If the handTool has no unique id, give it one.
    if uniqueId = = nil then
        uniqueId = Utils.getUniqueId(handToolHolder, self.handToolHoldersByUniqueId, HandToolSystem.UNIQUE_ID_HOLDER_PREFIX)
        handToolHolder:setUniqueId(uniqueId)
    end

    self.handToolHoldersByUniqueId[uniqueId] = handToolHolder
    Logging.devInfo( "Added handtool holder %q(%s)" , handToolHolder, uniqueId)

    for _, clickBoxNode in ipairs(handToolHolder.clickBoxes) do
        --#debug Assert.hasNoKey(self.handToolHoldersByClickBox, clickBoxNode, "Cannot add clickBox node to two different hand tool holders!")
        self.handToolHoldersByClickBox[clickBoxNode] = handToolHolder
    end

    return true
end

```

### addPendingHandToolLoad

**Description**

**Definition**

> addPendingHandToolLoad()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolSystem:addPendingHandToolLoad(handTool)
    table.addElement( self.pendingHandTools, handTool)
end

```

### canStartMission

**Description**

**Definition**

> canStartMission()

**Code**

```lua
function HandToolSystem:canStartMission()
    for _, handTool in ipairs( self.handTools) do
        if not handTool:getIsSynchronized() then
            return false
        end
    end

    if # self.pendingHandTools > 0 then
        return false
    end

    return true
end

```

### getHandToolByUniqueId

**Description**

**Definition**

> getHandToolByUniqueId()

**Arguments**

| any | uniqueId |
|-----|----------|

**Code**

```lua
function HandToolSystem:getHandToolByUniqueId(uniqueId)
    return self.handToolsByUniqueId[uniqueId]
end

```

### getHandToolHolderByUniqueId

**Description**

**Definition**

> getHandToolHolderByUniqueId()

**Arguments**

| any | uniqueId |
|-----|----------|

**Code**

```lua
function HandToolSystem:getHandToolHolderByUniqueId(uniqueId)
    return self.handToolHoldersByUniqueId[uniqueId]
end

```

### loadHandToolFinished

**Description**

**Definition**

> loadHandToolFinished()

**Arguments**

| any | handTool     |
|-----|--------------|
| any | loadingState |

**Code**

```lua
function HandToolSystem:loadHandToolFinished(handTool, loadingState)
    if loadingState = = HandToolLoadingState.OK then
        table.insert( self.loadedHandTools, handTool)
    else
            self.handToolLoadingState = self.handToolLoadingState or loadingState
        end

        self.handToolsToLoad = self.handToolsToLoad - 1
        if self.handToolsToLoad < = 0 then
            if self.asyncCallbackFunction ~ = nil then
                self.asyncCallbackFunction( self.asyncCallbackObject, self.loadedHandTools, self.handToolLoadingState or HandToolLoadingState.OK, self.asyncCallbackArguments)

                self.asyncCallbackFunction = nil
                self.asyncCallbackObject = nil
                self.asyncCallbackArguments = nil

                self.loadedHandTools = nil
                self.handToolLoadingState = nil
            end
        end
    end

```

### loadHandToolFromXML

**Description**

**Definition**

> loadHandToolFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function HandToolSystem:loadHandToolFromXML(xmlFile, key)
    local filename = xmlFile:getValue(key .. "#filename" )

    local allowedToLoad = true

    if allowedToLoad then
        filename = NetworkUtil.convertFromNetworkFilename(filename)
        local savegame = {
        xmlFile = xmlFile,
        key = key
        }

        local storeItem = g_storeManager:getItemByXMLFilename(filename)

        if storeItem ~ = nil then
            self.handToolsToLoad = self.handToolsToLoad + 1

            local data = HandToolLoadingData.new()
            data:setStoreItem(storeItem)
            data:setSavegameData(savegame)

            data:load( self.loadHandToolFinished, self )

            return true
        end
    else
            Logging.xmlInfo(xmlFile, "HandTool '%s' is not allowed to be loaded" , filename)
        end

        return false
    end

```

### new

**Description**

> Creates a new HandToolSystem with the current global specializations and types.

**Definition**

> new()

**Return Values**

| any | self | The created instance. |
|-----|------|-----------------------|

**Code**

```lua
function HandToolSystem.new()
    local self = setmetatable( { } , HandToolSystem _mt)

    self.version = 1
    self.handTools = { }
    self.handToolsByUniqueId = { }
    self.pendingHandTools = { }
    self.startingPlayerHandTools = { }
    self.handToolsToDelete = { }

    self.handToolHolders = { }
    self.handToolHoldersByUniqueId = { }
    self.handToolHoldersByClickBox = { }

    if g_addTestCommands then
        addConsoleCommand( "gsHandToolsPendingLoadings" , "Prints the pending handtool loadings" , "consoleCommandPrintPendingLoadings" , self )
    end

    return self
end

```

### removeHandTool

**Description**

**Definition**

> removeHandTool()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolSystem:removeHandTool(handTool)
    if handTool = = nil then
        return
    end

    -- Remove the hand tool from the collections.
    table.removeElement( self.handTools, handTool)
    local uniqueId = handTool:getUniqueId()
    if uniqueId ~ = nil then
        if self.handToolsByUniqueId[uniqueId] = = handTool then
            self.handToolsByUniqueId[uniqueId] = nil
        end
    end

    g_messageCenter:publish(MessageType.HANDTOOL_REMOVED)
end

```

### removeHandToolHolder

**Description**

**Definition**

> removeHandToolHolder()

**Arguments**

| any | handToolHolder |
|-----|----------------|

**Code**

```lua
function HandToolSystem:removeHandToolHolder(handToolHolder)
    if handToolHolder = = nil then
        return
    end

    -- Remove the holder from the collections.
    table.removeElement( self.handToolHolders, handToolHolder)

    local uniqueId = handToolHolder:getUniqueId()
    if uniqueId ~ = nil then
        if self.handToolHoldersByUniqueId[uniqueId] = = handToolHolder then
            self.handToolHoldersByUniqueId[uniqueId] = nil
        end
    end

    if handToolHolder.clickBoxes ~ = nil then
        for _, clickBoxNode in ipairs(handToolHolder.clickBoxes) do
            self.handToolHoldersByClickBox[clickBoxNode] = nil
        end
    end
end

```

### removePendingHandToolLoad

**Description**

**Definition**

> removePendingHandToolLoad()

**Arguments**

| any | handTool |
|-----|----------|

**Code**

```lua
function HandToolSystem:removePendingHandToolLoad(handTool)
    table.removeElement( self.pendingHandTools, handTool)
end

```

### save

**Description**

**Definition**

> save()

**Arguments**

| any | xmlFilename  |
|-----|--------------|
| any | usedModNames |

**Code**

```lua
function HandToolSystem:save(xmlFilename, usedModNames)
    local xmlFile = XMLFile.create( "handToolsXML" , xmlFilename, "handTools" , HandToolSystem.savegameXMLSchema)
    if xmlFile ~ = nil then
        self:saveToXML( self.handTools, xmlFile, usedModNames)
        xmlFile:delete()
    end
end

```

### saveHandToolToXML

**Description**

**Definition**

> saveHandToolToXML()

**Arguments**

| any | handTool     |
|-----|--------------|
| any | xmlFile      |
| any | index        |
| any | i            |
| any | usedModNames |

**Code**

```lua
function HandToolSystem:saveHandToolToXML(handTool, xmlFile, index, i, usedModNames)
    local handToolKey = string.format( "handTools.handTool(%d)" , index)

    local modName = handTool.customEnvironment
    if modName ~ = nil then
        if usedModNames ~ = nil then
            usedModNames[modName] = modName
        end
        xmlFile:setValue(handToolKey .. "#modName" , modName)
    end

    xmlFile:setValue(handToolKey .. "#filename" , HTMLUtil.encodeToHTML(NetworkUtil.convertToNetworkFilename(handTool.configFileName)))

    handTool:saveToXMLFile(xmlFile, handToolKey, usedModNames)
end

```

### saveToXML

**Description**

**Definition**

> saveToXML()

**Arguments**

| any | handTools    |
|-----|--------------|
| any | xmlFile      |
| any | usedModNames |

**Code**

```lua
function HandToolSystem:saveToXML(handTools, xmlFile, usedModNames)
    if xmlFile ~ = nil then
        local xmlIndex = 0
        for i, handTool in ipairs(handTools) do
            if handTool:getNeedsSaving() then
                self:saveHandToolToXML(handTool, xmlFile, xmlIndex, i, usedModNames)

                xmlIndex = xmlIndex + 1
            end
        end

        xmlFile:save( false , true )
    end
end

```