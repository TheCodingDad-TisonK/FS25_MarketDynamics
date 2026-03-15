## HandsPickUpFailedEvent

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
function HandsPickUpFailedEvent.emptyNew()
    local self = Event.new( HandsPickUpFailedEvent _mt)

    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | hands |
|-----|-------|

**Code**

```lua
function HandsPickUpFailedEvent.new(hands)
    local self = HandsPickUpFailedEvent.emptyNew()

    self.hands = hands

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
function HandsPickUpFailedEvent:readStream(streamId, connection)

    self.hands = NetworkUtil.readNodeObject(streamId)

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
function HandsPickUpFailedEvent:run(connection)
    assert(connection:getIsServer(), "HandsPickUpFailedEvent is a server to client only event" )

    if self.hands ~ = nil and self.hands:getIsSynchronized() then
        self.hands:pickupFailed()
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
function HandsPickUpFailedEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.hands)
end

```