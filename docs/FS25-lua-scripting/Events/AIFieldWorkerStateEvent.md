## AIFieldWorkerStateEvent

**Description**

> Event for ai start

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
function AIFieldWorkerStateEvent.emptyNew()
    local self = Event.new( AIFieldWorkerStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isActive)

**Arguments**

| table   | vehicle  | vehicle   |
|---------|----------|-----------|
| boolean | isActive | is active |

**Code**

```lua
function AIFieldWorkerStateEvent.new(vehicle, isActive)
    local self = AIFieldWorkerStateEvent.emptyNew()

    self.vehicle = vehicle
    self.isActive = isActive

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
function AIFieldWorkerStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.isActive = streamReadBool(streamId)

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
function AIFieldWorkerStateEvent:run(connection)
    if self.vehicle ~ = nil then
        if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
            if self.isActive then
                self.vehicle:startFieldWorker()
            else
                    self.vehicle:stopFieldWorker()
                end
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
function AIFieldWorkerStateEvent:writeStream(streamId, connection)
    assert( not connection:getIsServer(), "AIFieldWorkerStateEvent is a server to client event only" )
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.isActive)
end

```