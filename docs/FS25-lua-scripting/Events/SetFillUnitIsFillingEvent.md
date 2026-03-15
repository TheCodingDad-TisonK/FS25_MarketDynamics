## SetFillUnitIsFillingEvent

**Description**

> Event for toggle filling

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
function SetFillUnitIsFillingEvent.emptyNew()
    local self = Event.new( SetFillUnitIsFillingEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isFilling)

**Arguments**

| table   | vehicle   | vehicle          |
|---------|-----------|------------------|
| boolean | isFilling | is filling state |

**Code**

```lua
function SetFillUnitIsFillingEvent.new(vehicle, isFilling)
    local self = SetFillUnitIsFillingEvent.emptyNew()
    self.vehicle = vehicle
    self.isFilling = isFilling
    return self
end

```

### readStream

**Description**

> Called on client side

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function SetFillUnitIsFillingEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.isFilling = streamReadBool(streamId)
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
function SetFillUnitIsFillingEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setFillUnitIsFilling( self.isFilling, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SetFillUnitIsFillingEvent.new( self.vehicle, self.isFilling), nil , connection, self.vehicle)
    end
end

```

### writeStream

**Description**

> Called on server side

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function SetFillUnitIsFillingEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.isFilling)
end

```