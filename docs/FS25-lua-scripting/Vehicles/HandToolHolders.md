## HandToolHolders

**Description**

> Specialisation for vehicles that contain HandToolHolders.

**Functions**

- [onDelete](#ondelete)
- [onHandToolHolderFinished](#onhandtoolholderfinished)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolHolders:onDelete()
    local spec = self.spec_handToolHolders

    if spec.handToolHolders ~ = nil then
        for _, handToolHolder in ipairs(spec.handToolHolders) do
            handToolHolder:delete()
        end
        table.clear(spec.handToolHolders)
    end
end

```

### onHandToolHolderFinished

**Description**

**Definition**

> onHandToolHolderFinished()

**Arguments**

| any | handToolHolder |
|-----|----------------|
| any | args           |

**Code**

```lua
function HandToolHolders:onHandToolHolderFinished(handToolHolder, args)
    if handToolHolder ~ = nil then
        local spec = self.spec_handToolHolders
        handToolHolder:setOwnerFarmId( self:getOwnerFarmId())
        handToolHolder:setStoreCallback( function (handTool)
            SpecializationUtil.raiseEvent( self , "onHandToolStoredInHolder" , handTool, handToolHolder)
        end )
        handToolHolder:setPickupCallback( function (handTool)
            SpecializationUtil.raiseEvent( self , "onHandToolTakenFromHolder" , handTool, handToolHolder)
        end )

        table.insert(spec.handToolHolders, handToolHolder)
        local handToolIndex = #spec.handToolHolders

        local savegame = args.savegame
        if savegame ~ = nil and not savegame.resetVehicles then
            for _, key in savegame.xmlFile:iterator(savegame.key .. ".handToolHolders.handToolHolder" ) do
                local index = savegame.xmlFile:getValue(key .. "#index" )
                if index = = handToolIndex then
                    handToolHolder:loadFromXMLFile(savegame.xmlFile, key)
                    break
                end
            end
        end
    end

    self:finishLoadingTask(args.loadingTask)
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function HandToolHolders:onLoad(savegame)
    local spec = self.spec_handToolHolders

    local configurationId = self.configurations[ "handToolHolder" ] or 1
    local configKey = string.format( "vehicle.handToolHolders.handToolHolderConfigurations.handToolHolderConfiguration(%d)" , configurationId - 1 )
    if not self.xmlFile:hasProperty(configKey) then
        configKey = "vehicle.handToolHolders"
    end

    spec.handToolHolders = { }

    local name = self:getName()
    local brand = g_brandManager:getBrandByIndex( self:getBrand())
    if brand ~ = nil then
        name = brand.title .. " " .. name
    end
    local holderName = string.format(g_i18n:getText( "ui_handToolHolderVehicle" ), name)

    -- Iterate over all defined hand tool holders in the given file.
    for nodeIndex, key in self.xmlFile:iterator(configKey .. ".handToolHolder" ) do
        -- Create and add the holder.
        local handToolHolder = HandToolHolder.new( self , self.isServer, self.isClient)
        handToolHolder:setHolderName(holderName)

        local loadingTask = self:createLoadingTask( self )
        local args = {
        loadingTask = loadingTask,
        xmlFile = self.xmlFile,
        key = key,
        savegame = savegame,
        }

        handToolHolder:load( self.xmlFile, key, self.onHandToolHolderFinished, self , args, self.components, self.i3dMappings, self.baseDirectory, self.customEnvironment)
    end
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
function HandToolHolders:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_handToolHolders
        if spec.handToolHolders ~ = nil then
            for _, handToolHolder in ipairs(spec.handToolHolders) do
                local handToolHolderId = NetworkUtil.readNodeObjectId(streamId)
                handToolHolder:readStream(streamId, connection)
                g_client:finishRegisterObject(handToolHolder, handToolHolderId)
            end
        end
    end
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
function HandToolHolders:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_handToolHolders
        if spec.handToolHolders ~ = nil then
            for _, handToolHolder in ipairs(spec.handToolHolders) do
                NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(handToolHolder))
                handToolHolder:writeStream(streamId, connection)
                g_server:registerObjectInStream(connection, handToolHolder)
            end
        end
    end
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function HandToolHolders.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , HandToolHolders )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , HandToolHolders )
    SpecializationUtil.registerEventListener(vehicleType, "saveToXMLFile" , HandToolHolders )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , HandToolHolders )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , HandToolHolders )
    SpecializationUtil.registerEventListener(vehicleType, "onRegistered" , HandToolHolders )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function HandToolHolders.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onHandToolStoredInHolder" )
    SpecializationUtil.registerEvent(vehicleType, "onHandToolTakenFromHolder" )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function HandToolHolders.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onHandToolHolderFinished" , HandToolHolders.onHandToolHolderFinished)
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
function HandToolHolders.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setOwnerFarmId" , HandToolHolders.setOwnerFarmId)
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
function HandToolHolders:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_handToolHolders

    if spec.handToolHolders ~ = nil then
        for k, handToolHolder in ipairs(spec.handToolHolders) do
            local holderKey = string.format( "%s.handToolHolder(%d)" , key, k - 1 )
            xmlFile:setValue(holderKey .. "#index" , k)
            handToolHolder:saveToXMLFile(xmlFile, holderKey)
        end
    end
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | ownerFarmId |
| any | noEventSend |

**Code**

```lua
function HandToolHolders:setOwnerFarmId(superFunc, ownerFarmId, noEventSend)
    superFunc( self , ownerFarmId, noEventSend)

    local spec = self.spec_handToolHolders

    if spec.handToolHolders ~ = nil then
        for _, handToolHolder in ipairs(spec.handToolHolders) do
            handToolHolder:setOwnerFarmId(ownerFarmId, true )
        end
    end
end

```