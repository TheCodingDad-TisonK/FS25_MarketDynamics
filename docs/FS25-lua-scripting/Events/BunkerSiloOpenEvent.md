## BunkerSiloOpenEvent

**Description**

> Event for bunker silo open

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
function BunkerSiloOpenEvent.emptyNew()
    local self = Event.new( BunkerSiloOpenEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table bunkerSilo, float x, float y, float z)

**Arguments**

| table | bunkerSilo | bunkerSilo         |
|-------|------------|--------------------|
| float | x          | x opening position |
| float | y          | y opening position |
| float | z          | z opening position |

**Return Values**

| float | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function BunkerSiloOpenEvent.new(bunkerSilo, x,y,z)
    local self = BunkerSiloOpenEvent.emptyNew()
    self.bunkerSilo = bunkerSilo
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
function BunkerSiloOpenEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.bunkerSilo = NetworkUtil.readNodeObject(streamId)
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
function BunkerSiloOpenEvent:run(connection)
    if not connection:getIsServer() then
        self.bunkerSilo:openSilo( self.x, self.y, self.z)
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
function BunkerSiloOpenEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.bunkerSilo)
        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.y)
        streamWriteFloat32(streamId, self.z)
    end
end

```