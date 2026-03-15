## BalerCreateBaleEvent

**Description**

> Event for baler bale creation

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
function BalerCreateBaleEvent.emptyNew()
    local self = Event.new( BalerCreateBaleEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer baleFillType, float baleTime, )

**Arguments**

| table   | object       | object         |
|---------|--------------|----------------|
| integer | baleFillType | bale fill type |
| float   | baleTime     | bale time      |
| any     | baleServerId |                |

**Code**

```lua
function BalerCreateBaleEvent.new(object, baleFillType, baleTime, baleServerId)
    local self = BalerCreateBaleEvent.emptyNew()
    self.object = object
    self.baleFillType = baleFillType
    self.baleTime = baleTime
    self.baleServerId = baleServerId
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
function BalerCreateBaleEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.baleTime = streamReadFloat32(streamId)
    self.baleFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
    if streamReadBool(streamId) then
        self.baleServerId = NetworkUtil.readNodeObjectId(streamId)
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
function BalerCreateBaleEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:createBale( self.baleFillType, nil , self.baleServerId)
        self.object:setBaleTime(# self.object.spec_baler.bales, self.baleTime)
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
function BalerCreateBaleEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteFloat32(streamId, self.baleTime)
    streamWriteUIntN(streamId, self.baleFillType, FillTypeManager.SEND_NUM_BITS)
    if streamWriteBool(streamId, self.baleServerId ~ = nil ) then
        NetworkUtil.writeNodeObjectId(streamId, self.baleServerId)
    end
end

```