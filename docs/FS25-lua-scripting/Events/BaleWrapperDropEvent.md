## BaleWrapperDropEvent

**Description**

> Event for bale wrapper drop

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
function BaleWrapperDropEvent.emptyNew()
    local self = Event.new( BaleWrapperDropEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer dropAnimationIndex)

**Arguments**

| table   | object             | object   |
|---------|--------------------|----------|
| integer | dropAnimationIndex | state id |

**Return Values**

| integer | self |
|---------|------|

**Code**

```lua
function BaleWrapperDropEvent.new(object, dropAnimationIndex)
    local self = BaleWrapperDropEvent.emptyNew()
    self.object = object
    self.dropAnimationIndex = dropAnimationIndex

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
function BaleWrapperDropEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.dropAnimationIndex = streamReadUIntN(streamId, 4 )

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
function BaleWrapperDropEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , nil , self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setBaleWrapperDropAnimation( self.dropAnimationIndex)
        self.object:doStateChange( BaleWrapper.CHANGE_WRAPPER_START_DROP_BALE, nil )
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
function BaleWrapperDropEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.dropAnimationIndex, 4 )
end

```