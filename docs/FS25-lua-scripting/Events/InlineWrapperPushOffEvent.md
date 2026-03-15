## InlineWrapperPushOffEvent

**Description**

> Event for pushing off the bales from inline wrapper

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
function InlineWrapperPushOffEvent.emptyNew()
    local self = Event.new( InlineWrapperPushOffEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table inlineWrapper)

**Arguments**

| table | inlineWrapper | inlineWrapper |
|-------|---------------|---------------|

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function InlineWrapperPushOffEvent.new(inlineWrapper)
    local self = InlineWrapperPushOffEvent.emptyNew()
    self.inlineWrapper = inlineWrapper
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
function InlineWrapperPushOffEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.inlineWrapper = NetworkUtil.readNodeObject(streamId)
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
function InlineWrapperPushOffEvent:run(connection)
    if not connection:getIsServer() then
        if self.inlineWrapper ~ = nil and self.inlineWrapper:getIsSynchronized() then
            self.inlineWrapper:pushOffInlineBale()
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
function InlineWrapperPushOffEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.inlineWrapper)
    end
end

```