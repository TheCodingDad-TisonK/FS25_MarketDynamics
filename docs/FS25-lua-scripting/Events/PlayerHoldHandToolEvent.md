## PlayerHoldHandToolEvent

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [sendEvent](#sendevent)
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
function PlayerHoldHandToolEvent.emptyNew()
    local self = Event.new( PlayerHoldHandToolEvent _mt, NetworkNode.CHANNEL_MAIN)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | player     |
|-----|------------|
| any | handToolId |
| any | isHolding  |

**Code**

```lua
function PlayerHoldHandToolEvent.new(player, handToolId, isHolding)
    local self = PlayerHoldHandToolEvent.emptyNew()

    self.player = player
    self.handToolId = handToolId

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
function PlayerHoldHandToolEvent:readStream(streamId, connection)

    self.player = NetworkUtil.readNodeObject(streamId)
    if streamReadBool(streamId) then
        self.handToolId = NetworkUtil.readNodeObjectId(streamId)
    end

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
function PlayerHoldHandToolEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection)
    end

    if self.player ~ = nil then
        if self.handToolId ~ = nil then
            local handTool = NetworkUtil.getObject( self.handToolId)
            if handTool ~ = nil and handTool:getIsSynchronized() then
                self.player:setCurrentHandTool(handTool, true )
            end
        else
                self.player:setCurrentHandTool( nil , true )
            end
        end
    end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table player, integer handToolId, boolean noEventSend)

**Arguments**

| table   | player      | player             |
|---------|-------------|--------------------|
| integer | handToolId  | handTool object id |
| boolean | noEventSend | no event send      |

**Code**

```lua
function PlayerHoldHandToolEvent.sendEvent(player, handToolId, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlayerHoldHandToolEvent.new(player, handToolId))
        else
                g_client:getServerConnection():sendEvent( PlayerHoldHandToolEvent.new(player, handToolId))
            end
        end
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
function PlayerHoldHandToolEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.player)
    if streamWriteBool(streamId, self.handToolId ~ = nil ) then
        NetworkUtil.writeNodeObjectId(streamId, self.handToolId)
    end
end

```