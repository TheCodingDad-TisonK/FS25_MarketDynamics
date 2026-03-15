## WoodHarvesterOnDelimbTreeEvent

**Description**

> Event for delimb tree state

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
function WoodHarvesterOnDelimbTreeEvent.emptyNew()
    return Event.new( WoodHarvesterOnDelimbTreeEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | state  | state  |

**Code**

```lua
function WoodHarvesterOnDelimbTreeEvent.new(object, state)
    local self = WoodHarvesterOnDelimbTreeEvent.emptyNew()
    self.object = object
    self.state = state
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
function WoodHarvesterOnDelimbTreeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)
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
function WoodHarvesterOnDelimbTreeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( WoodHarvesterOnDelimbTreeEvent.new( self.object, self.state), nil , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:onDelimbTree( self.state)
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
function WoodHarvesterOnDelimbTreeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
end

```