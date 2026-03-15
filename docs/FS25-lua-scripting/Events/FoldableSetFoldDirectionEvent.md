## FoldableSetFoldDirectionEvent

**Description**

> Event for set folding direction

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
function FoldableSetFoldDirectionEvent.emptyNew()
    local self = Event.new( FoldableSetFoldDirectionEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer direction, boolean moveToMiddle)

**Arguments**

| table   | object       | object         |
|---------|--------------|----------------|
| integer | direction    | direction      |
| boolean | moveToMiddle | move to middle |

**Code**

```lua
function FoldableSetFoldDirectionEvent.new(object, direction, moveToMiddle)
    local self = FoldableSetFoldDirectionEvent.emptyNew()
    self.object = object
    self.direction = math.sign(direction)
    self.moveToMiddle = moveToMiddle
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
function FoldableSetFoldDirectionEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.direction = streamReadUIntN(streamId, 2 ) - 1
    self.moveToMiddle = streamReadBool(streamId)
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
function FoldableSetFoldDirectionEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setFoldState( self.direction, self.moveToMiddle, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( FoldableSetFoldDirectionEvent.new( self.object, self.direction, self.moveToMiddle), nil , connection, self.object)
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
function FoldableSetFoldDirectionEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.direction + 1 , 2 )
    streamWriteBool(streamId, self.moveToMiddle)
end

```