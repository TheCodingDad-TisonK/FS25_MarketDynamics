## WoodHarvesterOnCutTreeEvent

**Description**

> Event for on cut tree

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
function WoodHarvesterOnCutTreeEvent.emptyNew()
    local self = Event.new( WoodHarvesterOnCutTreeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, float radius)

**Arguments**

| table | object | object |
|-------|--------|--------|
| float | radius | radius |

**Code**

```lua
function WoodHarvesterOnCutTreeEvent.new(object, radius)
    local self = WoodHarvesterOnCutTreeEvent.emptyNew()
    self.object = object
    self.radius = radius
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
function WoodHarvesterOnCutTreeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.radius = streamReadFloat32(streamId)
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
function WoodHarvesterOnCutTreeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self.object, self.radius), nil , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        SpecializationUtil.raiseEvent( self.object, "onCutTree" , self.radius)
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
function WoodHarvesterOnCutTreeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteFloat32(streamId, self.radius)
end

```