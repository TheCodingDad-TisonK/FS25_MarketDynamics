## VehicleEnterRequestEvent

**Description**

> Event for enter request

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
function VehicleEnterRequestEvent.emptyNew()
    local self = Event.new( VehicleEnterRequestEvent _mt, NetworkNode.CHANNEL_MAIN)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, table playerStyle, integer farmId, boolean? force)

**Arguments**

| table    | object      | object |
|----------|-------------|--------|
| table    | playerStyle | info   |
| integer  | farmId      |        |
| boolean? | force       |        |

**Return Values**

| boolean? | self |
|----------|------|

**Code**

```lua
function VehicleEnterRequestEvent.new(object, playerStyle, farmId, force)
    local self = VehicleEnterRequestEvent.emptyNew()
    self.object = object
    self.objectId = NetworkUtil.getObjectId( self.object)
    self.farmId = farmId
    self.playerStyle = playerStyle
    self.force = Utils.getNoNil(force, false )
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
function VehicleEnterRequestEvent:readStream(streamId, connection)
    --#debug Player.debugLog(nil, Player.DEBUG_DISPLAY_FLAG.NETWORK, "VehicleEnterRequestEvent:readStream")
    self.objectId = NetworkUtil.readNodeObjectId(streamId)
    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

    if self.playerStyle = = nil then
        self.playerStyle = PlayerStyle.new()
    end
    self.playerStyle:readStream(streamId, connection)
    self.force = streamReadBool(streamId)

    self.object = NetworkUtil.getObject( self.objectId)
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
function VehicleEnterRequestEvent:run(connection)

    if self.object = = nil or not self.object:getIsSynchronized() then
        return
    end

    -- check if vehicle is available on client
        if not self.force and not g_server:hasGhostObject(connection, self.object) then
            Logging.warning( "Vehicle %q is not fully synchronized to on client" , self.object.configFileName)
            return
        end

        local enterableSpec = self.object.spec_enterable
        if enterableSpec = = nil or enterableSpec.isControlled then
            return
        end

        local userId = g_currentMission.userManager:getUserIdByConnection(connection)
        self.object:setOwnerConnection(connection)
        self.object.controllerFarmId = self.farmId
        self.object.controllerUserId = userId

        --#debug Player.debugLog(g_currentMission.playerSystem:getPlayerByUserId(userId), Player.DEBUG_DISPLAY_FLAG.NETWORK, "VehicleEnterRequestEvent:run")

        -- Broadcast the event to all clients except the client who made the request.
        g_server:broadcastEvent( VehicleEnterResponseEvent.new( self.objectId, false , self.playerStyle, self.farmId, userId), true , connection)

        -- Specifically send the event to the client who made the request to set them as the event owner.
        connection:sendEvent( VehicleEnterResponseEvent.new( self.objectId, true , self.playerStyle, self.farmId, userId))
    end

```

### writeStream

**Description**

> Called by the player entering the vehicle, to be sent to the server.

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function VehicleEnterRequestEvent:writeStream(streamId, connection)
    --#debug Player.debugLog(nil, Player.DEBUG_DISPLAY_FLAG.NETWORK, "VehicleEnterRequestEvent:writeStream")
    NetworkUtil.writeNodeObjectId(streamId, self.objectId)
    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.playerStyle:writeStream(streamId, connection)
    streamWriteBool(streamId, self.force)
end

```