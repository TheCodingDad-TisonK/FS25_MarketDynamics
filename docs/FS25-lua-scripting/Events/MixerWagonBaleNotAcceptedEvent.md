## MixerWagonBaleNotAcceptedEvent

**Description**

> Event for honking

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
function MixerWagonBaleNotAcceptedEvent.emptyNew()
    local self = Event.new( MixerWagonBaleNotAcceptedEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle)

**Arguments**

| table | vehicle | vehicle |
|-------|---------|---------|

**Code**

```lua
function MixerWagonBaleNotAcceptedEvent.new()
    local self = MixerWagonBaleNotAcceptedEvent.emptyNew()
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
function MixerWagonBaleNotAcceptedEvent:readStream(streamId, connection)
    self:run(connection)
end

```

### run

**Description**

**Definition**

> run()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function MixerWagonBaleNotAcceptedEvent:run(connection)
    g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, g_i18n:getText( "warning_baleNotSupported" ))
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
function MixerWagonBaleNotAcceptedEvent:writeStream(streamId, connection)
end

```