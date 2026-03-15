## FerryStartEvent

**Description**

> Event for washing stations

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
function FerryStartEvent.emptyNew()
    local self = Event.new( FerryStartEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table ferry)

**Arguments**

| table | ferry | ferry |
|-------|-------|-------|

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function FerryStartEvent.new(ferry)
    local self = FerryStartEvent.emptyNew()
    self.ferry = ferry
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
function FerryStartEvent:readStream(streamId, connection)
    self.ferry = NetworkUtil.readNodeObject(streamId)

    if connection:getIsServer() then
        self.errorCode = streamReadUIntN(streamId, Ferry.ERROR_SEND_NUM_BITS)
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
function FerryStartEvent:run(connection)
    if not connection:getIsServer() then
        self.ferry:start(connection)
    else
            if self.errorCode = = Ferry.ERROR_SUCCESS then
                self.ferry:onStarted()
            else
                    self.ferry:onStartFailed( self.errorCode)
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
function FerryStartEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.ferry)

    if not connection:getIsServer() then
        streamWriteUIntN(streamId, self.errorCode, Ferry.ERROR_SEND_NUM_BITS)
    end
end

```