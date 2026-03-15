## WoodHarvesterCutLengthEvent

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
function WoodHarvesterCutLengthEvent.emptyNew()
    local self = Event.new( WoodHarvesterCutLengthEvent _mt)
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
function WoodHarvesterCutLengthEvent.new(object, index)
    local self = WoodHarvesterCutLengthEvent.emptyNew()
    self.object = object
    self.index = index
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
function WoodHarvesterCutLengthEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.index = streamReadUIntN(streamId, WoodHarvester.NUM_BITS_CUT_LENGTH)
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
function WoodHarvesterCutLengthEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setWoodHarvesterCutLengthIndex( self.index, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, float index, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| float   | index       | index         |
| boolean | noEventSend | no event send |

**Code**

```lua
function WoodHarvesterCutLengthEvent.sendEvent(object, index, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( WoodHarvesterCutLengthEvent.new(object, index), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( WoodHarvesterCutLengthEvent.new(object, index))
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
function WoodHarvesterCutLengthEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.index, WoodHarvester.NUM_BITS_CUT_LENGTH)
end

```