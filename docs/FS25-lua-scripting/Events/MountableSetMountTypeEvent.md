## MountableSetMountTypeEvent

**Description**

> Event to sync the current mount type of a vehicle

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
function MountableSetMountTypeEvent.emptyNew()
    local self = Event.new( MountableSetMountTypeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean mountType, )

**Arguments**

| table   | object      | object                       |
|---------|-------------|------------------------------|
| boolean | mountType   | use mower windrow drop areas |
| any     | mountObject |                              |

**Code**

```lua
function MountableSetMountTypeEvent.new(object, mountType, mountObject)
    local self = MountableSetMountTypeEvent.emptyNew()
    self.object = object
    self.mountType = mountType
    self.mountObject = mountObject
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
function MountableSetMountTypeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.mountType = streamReadUIntN(streamId, MountableObject.MOUNT_TYPE_SEND_NUM_BITS)

    if streamReadBool(streamId) then
        self.mountObject = NetworkUtil.readNodeObject(streamId)
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
function MountableSetMountTypeEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        -- only broadcast if we(still) have a valid object on the server and it's not deleted already
            if not connection:getIsServer() then
                g_server:broadcastEvent( self , false , connection, self.object)
            end

            self.object:setDynamicMountType( self.mountType, self.mountObject, true )
        end
    end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean mountType, boolean noEventSend, )

**Arguments**

| table   | vehicle     | vehicle                      |
|---------|-------------|------------------------------|
| boolean | mountType   | use mower windrow drop areas |
| boolean | noEventSend | no event send                |
| any     | noEventSend |                              |

**Code**

```lua
function MountableSetMountTypeEvent.sendEvent(vehicle, mountType, mountObject, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( MountableSetMountTypeEvent.new(vehicle, mountType, mountObject), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( MountableSetMountTypeEvent.new(vehicle, mountType, mountObject))
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
function MountableSetMountTypeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.mountType, MountableObject.MOUNT_TYPE_SEND_NUM_BITS)

    if streamWriteBool(streamId, self.mountObject ~ = nil ) then
        NetworkUtil.writeNodeObject(streamId, self.mountObject)
    end
end

```