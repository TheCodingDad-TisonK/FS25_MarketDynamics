## PlaceableRiceFieldEffectStateEvent

**Description**

> Event for a rice field state used in RiceFieldDialog

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
function PlaceableRiceFieldEffectStateEvent.emptyNew()
    return Event.new( PlaceableRiceFieldEffectStateEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new()

**Arguments**

| any | placeableRiceField |
|-----|--------------------|
| any | fieldIndex         |
| any | isFilling          |
| any | isEmptying         |

**Code**

```lua
function PlaceableRiceFieldEffectStateEvent.new(placeableRiceField, fieldIndex, isFilling, isEmptying)
    local self = PlaceableRiceFieldEffectStateEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.fieldIndex = fieldIndex
    self.isFilling = isFilling
    self.isEmptying = isEmptying

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
function PlaceableRiceFieldEffectStateEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)
    self.fieldIndex = streamReadUInt8(streamId)
    self.isFilling = streamReadBool(streamId)
    self.isEmptying = streamReadBool(streamId)

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
function PlaceableRiceFieldEffectStateEvent:run(connection)
    if self.placeableRiceField = = nil or not self.placeableRiceField:getIsSynchronized() then
        return
    end

    self.placeableRiceField:setEffectVisibility( self.fieldIndex, self.isFilling, self.isEmptying)
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
function PlaceableRiceFieldEffectStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)
    streamWriteUInt8(streamId, self.fieldIndex)
    streamWriteBool(streamId, self.isFilling)
    streamWriteBool(streamId, self.isEmptying)
end

```