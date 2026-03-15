## BaleOpenEvent

**Description**

> Event for bale opening

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
function BaleOpenEvent.emptyNew()
    local self = Event.new( BaleOpenEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table bale, float x, float y, float z)

**Arguments**

| table | bale | bale               |
|-------|------|--------------------|
| float | x    | x opening position |
| float | y    | y opening position |
| float | z    | z opening position |

**Return Values**

| float | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function BaleOpenEvent.new(bale)
    local self = BaleOpenEvent.emptyNew()
    self.bale = bale
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
function BaleOpenEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.bale = NetworkUtil.readNodeObject(streamId)
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
function BaleOpenEvent:run(connection)
    if not connection:getIsServer() then
        self.bale:open()
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
function BaleOpenEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.bale)
    end
end

```