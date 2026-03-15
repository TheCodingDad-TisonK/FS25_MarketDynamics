## VehicleEnterResponseEvent

**Description**

> Event for enter response

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [writeStream](#writestream)

### emptyNew

**Description**

> Create instance of Event class

**Definition**

> emptyNew()

**Return Values**

| any | self | instance of class event |
|-----|------|-------------------------|

**Code**

```lua
function VehicleEnterResponseEvent.emptyNew()
    local self = Event.new( VehicleEnterResponseEvent _mt, NetworkNode.CHANNEL_MAIN)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table id, boolean isOwner, table playerStyle, integer farmId, integer userId)

**Arguments**

| table   | id          | id       |
|---------|-------------|----------|
| boolean | isOwner     | is owner |
| table   | playerStyle |          |
| integer | farmId      |          |
| integer | userId      |          |

**Return Values**

| integer | self |
|---------|------|

**Code**

```lua
function VehicleEnterResponseEvent.new(id, isOwner, playerStyle, farmId, userId)
    local self = VehicleEnterResponseEvent.emptyNew()

    self.id = id
    self.isOwner = isOwner
    self.playerStyle = playerStyle
    self.farmId = farmId
    self.userId = userId

    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function VehicleEnterResponseEvent:readStream(streamId, connection)
    --#debug Player.debugLog(nil, Player.DEBUG_DISPLAY_FLAG.NETWORK, "VehicleEnterResponseEvent:readStream")
    self.id = NetworkUtil.readNodeObjectId(streamId)
    self.isOwner = streamReadBool(streamId)

    if self.playerStyle = = nil then
        self.playerStyle = PlayerStyle.new()
    end
    self.playerStyle:readStream(streamId, connection)

    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.userId = User.streamReadUserId(streamId)
    self:run(connection)
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection | connection |
|------------|------------|------------|

**Code**

```lua
function VehicleEnterResponseEvent:run(connection)

    local vehicle = NetworkUtil.getObject( self.id)
    if vehicle = = nil then
        Logging.devWarning( "VehicleEnterResponseEvent:Vehicle '%s' not found.Skip entering" , self.id)
        return
    end

    if not vehicle:getIsSynchronized() then
        Logging.devWarning( "VehicleEnterResponseEvent:Vehicle '%s' not synchronized.Skip entering" , vehicle.configFileName)
        return
    end

    local player = g_currentMission.playerSystem:getPlayerByUserId( self.userId)
    if player = = nil then
        Logging.devWarning( "VehicleEnterResponseEvent:Player '%s' not found.Skip entering" , self.userId)
        return
    end

    player:onEnterVehicle(vehicle)
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function VehicleEnterResponseEvent:writeStream(streamId, connection)
    --#debug Player.debugLog(nil, Player.DEBUG_DISPLAY_FLAG.NETWORK, "VehicleEnterResponseEvent:writeStream")
    NetworkUtil.writeNodeObjectId(streamId, self.id)
    streamWriteBool(streamId, self.isOwner)

    self.playerStyle:writeStream(streamId, connection)

    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    User.streamWriteUserId(streamId, self.userId)
end

```