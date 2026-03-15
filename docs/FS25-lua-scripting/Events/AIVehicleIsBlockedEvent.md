## AIVehicleIsBlockedEvent

**Description**

> Event for ai block

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
function AIVehicleIsBlockedEvent.emptyNew()
    local self = Event.new( AIVehicleIsBlockedEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isBlocked)

**Arguments**

| table   | object    | object     |
|---------|-----------|------------|
| boolean | isBlocked | is blocked |

**Code**

```lua
function AIVehicleIsBlockedEvent.new(object, isBlocked)
    local self = AIVehicleIsBlockedEvent.emptyNew()
    self.object = object
    self.isBlocked = isBlocked
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
function AIVehicleIsBlockedEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.isBlocked = streamReadBool(streamId)
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
function AIVehicleIsBlockedEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        if self.isBlocked then
            self.object:aiBlock()
        else
                self.object:aiContinue()
            end
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
function AIVehicleIsBlockedEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.isBlocked)
end

```