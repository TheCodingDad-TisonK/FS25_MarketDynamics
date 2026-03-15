## LiftableAxleEvent

**Description**

> Event for liftable axle state

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
function LiftableAxleEvent.emptyNew()
    local self = Event.new( LiftableAxleEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, , )

**Arguments**

| table | object      | object |
|-------|-------------|--------|
| any   | state       |        |
| any   | fixedHeight |        |

**Code**

```lua
function LiftableAxleEvent.new(object, state, fixedHeight)
    local self = LiftableAxleEvent.emptyNew()

    self.object = object
    self.state = state
    self.fixedHeight = fixedHeight

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
function LiftableAxleEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)

    if streamReadBool(streamId) then
        self.fixedHeight = streamReadFloat32(streamId)
    else
            self.fixedHeight = nil
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
function LiftableAxleEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setLiftableAxleState( self.state, self.fixedHeight, nil , true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean isActive, boolean noEventSend, )

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | isActive    | is active     |
| boolean | noEventSend | no event send |
| any     | noEventSend |               |

**Code**

```lua
function LiftableAxleEvent.sendEvent(object, state, fixedHeight, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( LiftableAxleEvent.new(object, state, fixedHeight), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( LiftableAxleEvent.new(object, state, fixedHeight))
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
function LiftableAxleEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)

    if streamWriteBool(streamId, self.fixedHeight ~ = nil ) then
        streamWriteFloat32(streamId, self.fixedHeight)
    end
end

```