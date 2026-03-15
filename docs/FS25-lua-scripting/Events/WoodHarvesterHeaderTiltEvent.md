## WoodHarvesterHeaderTiltEvent

**Description**

> Event for tilting the harvester header

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
function WoodHarvesterHeaderTiltEvent.emptyNew()
    local self = Event.new( WoodHarvesterHeaderTiltEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, float length)

**Arguments**

| table | object | object |
|-------|--------|--------|
| float | length | length |

**Code**

```lua
function WoodHarvesterHeaderTiltEvent.new(object, state)
    local self = WoodHarvesterHeaderTiltEvent.emptyNew()
    self.object = object
    self.state = state
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
function WoodHarvesterHeaderTiltEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)
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
function WoodHarvesterHeaderTiltEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setWoodHarvesterTiltState( self.state, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, float state, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| float   | state       | state         |
| boolean | noEventSend | no event send |

**Code**

```lua
function WoodHarvesterHeaderTiltEvent.sendEvent(object, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( WoodHarvesterHeaderTiltEvent.new(object, state), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( WoodHarvesterHeaderTiltEvent.new(object, state))
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
function WoodHarvesterHeaderTiltEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
end

```