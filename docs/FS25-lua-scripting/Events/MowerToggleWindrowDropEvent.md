## MowerToggleWindrowDropEvent

**Description**

> Event for mower toggle drop

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
function MowerToggleWindrowDropEvent.emptyNew()
    local self = Event.new( MowerToggleWindrowDropEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean useMowerWindrowDropAreas)

**Arguments**

| table   | object                   | object                       |
|---------|--------------------------|------------------------------|
| boolean | useMowerWindrowDropAreas | use mower windrow drop areas |

**Code**

```lua
function MowerToggleWindrowDropEvent.new(object, useMowerWindrowDropAreas)
    local self = MowerToggleWindrowDropEvent.emptyNew()
    self.object = object
    self.useMowerWindrowDropAreas = useMowerWindrowDropAreas
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
function MowerToggleWindrowDropEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.useMowerWindrowDropAreas = streamReadBool(streamId)
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
function MowerToggleWindrowDropEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setUseMowerWindrowDropAreas( self.useMowerWindrowDropAreas, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean useMowerWindrowDropAreas, boolean noEventSend)

**Arguments**

| table   | vehicle                  | vehicle                      |
|---------|--------------------------|------------------------------|
| boolean | useMowerWindrowDropAreas | use mower windrow drop areas |
| boolean | noEventSend              | no event send                |

**Code**

```lua
function MowerToggleWindrowDropEvent.sendEvent(vehicle, useMowerWindrowDropAreas, noEventSend)
    if useMowerWindrowDropAreas ~ = vehicle.useMowerWindrowDropAreas then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( MowerToggleWindrowDropEvent.new(vehicle, useMowerWindrowDropAreas), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( MowerToggleWindrowDropEvent.new(vehicle, useMowerWindrowDropAreas))
                end
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
function MowerToggleWindrowDropEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.useMowerWindrowDropAreas)
end

```