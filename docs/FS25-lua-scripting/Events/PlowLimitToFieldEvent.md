## PlowLimitToFieldEvent

**Description**

> Event for limit to field state

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
function PlowLimitToFieldEvent.emptyNew()
    local self = Event.new( PlowLimitToFieldEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean plowLimitToField)

**Arguments**

| table   | object           | object                   |
|---------|------------------|--------------------------|
| boolean | plowLimitToField | plow is limited to field |

**Code**

```lua
function PlowLimitToFieldEvent.new(object, plowLimitToField)
    local self = PlowLimitToFieldEvent.emptyNew()
    self.object = object
    self.plowLimitToField = plowLimitToField
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
function PlowLimitToFieldEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.plowLimitToField = streamReadBool(streamId)
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
function PlowLimitToFieldEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPlowLimitToField( self.plowLimitToField, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( PlowLimitToFieldEvent.new( self.object, self.plowLimitToField), nil , connection, self.object)
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
function PlowLimitToFieldEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.plowLimitToField)
end

```