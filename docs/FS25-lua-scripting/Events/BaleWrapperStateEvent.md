## BaleWrapperStateEvent

**Description**

> Event for bale wrapper state

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
function BaleWrapperStateEvent.emptyNew()
    local self = Event.new( BaleWrapperStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer stateId, integer? nearestBaleServerId)

**Arguments**

| table    | object              | object                                                                     |
|----------|---------------------|----------------------------------------------------------------------------|
| integer  | stateId             | state id                                                                   |
| integer? | nearestBaleServerId | server id of nearest bale, required for state BaleWrapper.CHANGE_GRAB_BALE |

**Return Values**

| integer? | self |
|----------|------|

**Code**

```lua
function BaleWrapperStateEvent.new(object, stateId, nearestBaleServerId)
    local self = BaleWrapperStateEvent.emptyNew()
    self.object = object
    self.stateId = stateId
    assert(nearestBaleServerId ~ = nil or self.stateId ~ = BaleWrapper.CHANGE_GRAB_BALE)
    self.nearestBaleServerId = nearestBaleServerId
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
function BaleWrapperStateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.stateId = streamReadInt8(streamId)
    if self.stateId = = BaleWrapper.CHANGE_GRAB_BALE then
        self.nearestBaleServerId = NetworkUtil.readNodeObjectId(streamId)
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
function BaleWrapperStateEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:doStateChange( self.stateId, self.nearestBaleServerId)
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
function BaleWrapperStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteInt8(streamId, self.stateId)
    if self.stateId = = BaleWrapper.CHANGE_GRAB_BALE then
        NetworkUtil.writeNodeObjectId(streamId, self.nearestBaleServerId)
    end
end

```