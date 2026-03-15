## TensionBeltsRefreshEvent

**Description**

> Event for tension belts state

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
function TensionBeltsRefreshEvent.emptyNew()
    local self = Event.new( TensionBeltsRefreshEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isActive, integer beltId)

**Arguments**

| table   | object   | object         |
|---------|----------|----------------|
| boolean | isActive | belt is active |
| integer | beltId   | id of belt     |

**Code**

```lua
function TensionBeltsRefreshEvent.new(object)
    local self = TensionBeltsRefreshEvent.emptyNew()
    self.object = object
    return self
end

```

### readStream

**Description**

> Called on client side

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function TensionBeltsRefreshEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
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
function TensionBeltsRefreshEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:refreshTensionBelts()
    end
end

```

### writeStream

**Description**

> Called on server side

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function TensionBeltsRefreshEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```