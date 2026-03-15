## HandToolSetHolderEvent

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [sendEvent](#sendevent)
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
function HandToolSetHolderEvent.emptyNew()
    local self = Event.new( HandToolSetHolderEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | handTool |
|-----|----------|
| any | holder   |

**Code**

```lua
function HandToolSetHolderEvent.new(handTool, holder)
    local self = HandToolSetHolderEvent.emptyNew()

    self.handTool = handTool
    self.holder = holder
    self.hasHolder = holder ~ = nil

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
function HandToolSetHolderEvent:readStream(streamId, connection)

    self.handTool = NetworkUtil.readNodeObject(streamId)
    self.hasHolder = streamReadBool(streamId)
    if self.hasHolder then
        self.holder = NetworkUtil.readNodeObject(streamId)
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
function HandToolSetHolderEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection)
    end

    if self.handTool ~ = nil and self.handTool:getIsSynchronized() then
        if ( self.hasHolder and self.holder ~ = nil ) or not self.hasHolder then
            self.handTool:setHolder( self.holder, true )
        end
    end

    g_messageCenter:publish( HandToolSetHolderEvent )
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table handTool, table holder, boolean noEventSend)

**Arguments**

| table   | handTool    | handTool      |
|---------|-------------|---------------|
| table   | holder      | holder        |
| boolean | noEventSend | no event send |

**Code**

```lua
function HandToolSetHolderEvent.sendEvent(handTool, holder, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( HandToolSetHolderEvent.new(handTool, holder))
        else
                g_client:getServerConnection():sendEvent( HandToolSetHolderEvent.new(handTool, holder))
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
function HandToolSetHolderEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.handTool)
    if streamWriteBool(streamId, self.holder ~ = nil ) then
        NetworkUtil.writeNodeObject(streamId, self.holder)
    end
end

```