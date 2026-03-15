## InlineBaleOpenEvent

**Description**

> Event for inline bale opening

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
function InlineBaleOpenEvent.emptyNew()
    local self = Event.new( InlineBaleOpenEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table inlineBale, float x, float y, float z)

**Arguments**

| table | inlineBale | inlineBale         |
|-------|------------|--------------------|
| float | x          | x opening position |
| float | y          | y opening position |
| float | z          | z opening position |

**Return Values**

| float | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function InlineBaleOpenEvent.new(inlineBale, x,y,z)
    local self = InlineBaleOpenEvent.emptyNew()
    self.inlineBale = inlineBale
    self.x = x
    self.y = y
    self.z = z
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
function InlineBaleOpenEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.inlineBale = NetworkUtil.readNodeObject(streamId)
        self.x = streamReadFloat32(streamId)
        self.y = streamReadFloat32(streamId)
        self.z = streamReadFloat32(streamId)
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
function InlineBaleOpenEvent:run(connection)
    if not connection:getIsServer() then
        self.inlineBale:openBaleAtPosition( self.x, self.y, self.z)
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
function InlineBaleOpenEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.inlineBale)
        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.y)
        streamWriteFloat32(streamId, self.z)
    end
end

```