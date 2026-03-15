## HandToolLoadingData

**Description**

> Stores all data that is required to load a HandTool

**Functions**

- [load](#load)
- [new](#new)
- [setFilename](#setfilename)
- [setIsRegistered](#setisregistered)
- [setOwnerFarmId](#setownerfarmid)
- [setSavegameData](#setsavegamedata)
- [setStoreItem](#setstoreitem)

### load

**Description**

> Load handtool and calls the optional callback

**Definition**

> load(function? callback, table? callbackTarget, table? callbackArguments)

**Arguments**

| function? | callback          | callback to be called when handtool has been loaded |
|-----------|-------------------|-----------------------------------------------------|
| table?    | callbackTarget    | callback target                                     |
| table?    | callbackArguments | callback arguments                                  |

**Code**

```lua
function HandToolLoadingData:load(callback, callbackTarget, callbackArguments)
    self.callback, self.callbackTarget, self.callbackArguments = callback, callbackTarget, callbackArguments

    local handToolData = self.handToolData
    handToolData.handToolType, handToolData.handToolClass = g_handToolTypeManager:getObjectTypeFromXML(handToolData.xmlFilename)

    self.loadingState = HandToolLoadingState.OK

    if handToolData.handToolType = = nil or handToolData.handToolClass = = nil then
        self.loadingState = HandToolLoadingState.ERROR
        if self.callback ~ = nil then
            self.callback( self.callbackTarget, nil , self.loadingState, self.callbackArguments)
            self.callback = nil
            self.callbackTarget = nil
            self.callbackArguments = nil
        end
        return
    end

    self:loadHandTool(handToolData)
end

```

### new

**Description**

> Creates a new instance of HandToolLoadingData

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | handToolLoadingData | HandToolLoadingData instance |
|-----|---------------------|------------------------------|

**Code**

```lua
function HandToolLoadingData.new(customMt)
    local self = setmetatable( { } , customMt or HandToolLoadingData _mt)

    self.isValid = false
    self.storeItem = nil
    self.handToolData = nil
    self.ownerFarmId = AccessHandler.EVERYONE
    self.savegameData = nil
    self.isSaved = true
    self.canBeDropped = true

    self.isRegistered = true
    self.forceServer = false
    self.loadingHandTool = nil
    self.loadingState = nil

    return self
end

```

### setFilename

**Description**

> Sets the store data by given xml filename

**Definition**

> setFilename(string filename)

**Arguments**

| string | filename | filename |
|--------|----------|----------|

**Code**

```lua
function HandToolLoadingData:setFilename(filename)
    if fileExists(filename) then
        self.handToolData = { xmlFilename = filename }
    else
            Logging.error( "Unable to find handtool config for '%s'" , filename)
                printCallstack()
            end
        end

```

### setIsRegistered

**Description**

> Sets if the handtool is registered after loading

**Definition**

> setIsRegistered(boolean isRegistered)

**Arguments**

| boolean | isRegistered | isRegistered |
|---------|--------------|--------------|

**Code**

```lua
function HandToolLoadingData:setIsRegistered(isRegistered)
    self.isRegistered = isRegistered
end

```

### setOwnerFarmId

**Description**

> Sets the owner of the handtool

**Definition**

> setOwnerFarmId(integer ownerFarmId)

**Arguments**

| integer | ownerFarmId | ownerFarmId |
|---------|-------------|-------------|

**Code**

```lua
function HandToolLoadingData:setOwnerFarmId(ownerFarmId)
    self.ownerFarmId = ownerFarmId
end

```

### setSavegameData

**Description**

> Sets the savegame data for a handtool if it's loaded from a savegame

**Definition**

> setSavegameData(table savegameData)

**Arguments**

| table | savegameData | savegameData (table with the following attributes: xmlFile, key) |
|-------|--------------|------------------------------------------------------------------|

**Code**

```lua
function HandToolLoadingData:setSavegameData(savegameData)
    self.savegameData = savegameData
end

```

### setStoreItem

**Description**

> Sets the store item

**Definition**

> setStoreItem(table storeItem)

**Arguments**

| table | storeItem | storeItem |
|-------|-----------|-----------|

**Code**

```lua
function HandToolLoadingData:setStoreItem(storeItem)
    if storeItem ~ = nil then
        self.storeItem = storeItem
        self.handToolData = { xmlFilename = storeItem.xmlFilename }
    else
            Logging.error( "No store item defined" )
            printCallstack()
        end

        self.isValid = storeItem ~ = nil
    end

```