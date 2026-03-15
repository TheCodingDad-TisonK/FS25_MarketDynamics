## TrailerToggleTipSideEvent

**Description**

> Event for toggle trailer tipping

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
function TrailerToggleTipSideEvent.emptyNew()
    local self = Event.new( TrailerToggleTipSideEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isStart, table tipTrigger, integer tipSideIndex)

**Arguments**

| table   | object       | object            |
|---------|--------------|-------------------|
| boolean | isStart      | is start          |
| table   | tipTrigger   | tip trigger       |
| integer | tipSideIndex | index of tip side |

**Code**

```lua
function TrailerToggleTipSideEvent.new(object, tipSideIndex)
    local self = TrailerToggleTipSideEvent.emptyNew()
    self.object = object
    self.tipSideIndex = tipSideIndex
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
function TrailerToggleTipSideEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.tipSideIndex = streamReadUIntN(streamId, Trailer.TIP_SIDE_NUM_BITS)

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
function TrailerToggleTipSideEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPreferedTipSide( self.tipSideIndex, true )
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
function TrailerToggleTipSideEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.tipSideIndex, Trailer.TIP_SIDE_NUM_BITS)
end

```