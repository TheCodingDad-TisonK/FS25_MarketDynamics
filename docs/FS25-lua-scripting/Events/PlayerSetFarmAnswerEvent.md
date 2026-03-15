## PlayerSetFarmAnswerEvent

**Description**

> Player farm setting answer event.
> Triggered in response to PlayerSetFarmEvent.

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

> Create an empty instance

**Definition**

> emptyNew()

**Return Values**

| any | instance | Instance of object |
|-----|----------|--------------------|

**Code**

```lua
function PlayerSetFarmAnswerEvent.emptyNew()
    local self = Event.new( PlayerSetFarmAnswerEvent _mt)
    return self
end

```

### new

**Description**

> Create an instance of PlayerSetFarmAnswerEvent.

**Definition**

> new(integer answerState, integer farmId, string? password)

**Arguments**

| integer | answerState |                                      |
|---------|-------------|--------------------------------------|
| integer | farmId      | Farm ID                              |
| string? | password    | Password used for PlayerSetFarmEvent |

**Return Values**

| string? | instance | Instance of PlayerSetFarmAnswerEvent |
|---------|----------|--------------------------------------|

**Code**

```lua
function PlayerSetFarmAnswerEvent.new(answerState, farmId, password)
    local self = PlayerSetFarmAnswerEvent.emptyNew()

    self.answerState = answerState
    self.farmId = farmId
    self.password = password

    return self
end

```

### readStream

**Description**

> Reads network stream

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | network stream identification |
|---------|------------|-------------------------------|
| table   | connection | connection information        |

**Code**

```lua
function PlayerSetFarmAnswerEvent:readStream(streamId, connection)
    self.answerState = streamReadUIntN(streamId, PlayerSetFarmAnswerEvent.SEND_NUM_BITS)
    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

    if streamReadBool(streamId) then
        self.password = streamReadString(streamId)
    end

    self:run(connection)
end

```

### run

**Description**

> Run event

**Definition**

> run(table connection)

**Arguments**

| table | connection | connection information |
|-------|------------|------------------------|

**Code**

```lua
function PlayerSetFarmAnswerEvent:run(connection)
    if not connection:getIsServer() then -- server side, should not happen
        Logging.devWarning( "PlayerSetFarmAnswerEvent is a server to client only event" )
        else -- client side
            if self.answerState = = PlayerSetFarmAnswerEvent.STATE.OK then
                g_messageCenter:publish( PlayerSetFarmAnswerEvent , self.answerState, self.farmId, self.password)
            elseif self.answerState = = PlayerSetFarmAnswerEvent.STATE.PASSWORD_REQUIRED then
                    g_messageCenter:publish( PlayerSetFarmAnswerEvent , self.answerState, self.farmId)
                end
            end
        end

```

### writeStream

**Description**

> Writes network stream

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | network stream identification |
|---------|------------|-------------------------------|
| table   | connection | connection information        |

**Code**

```lua
function PlayerSetFarmAnswerEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.answerState, PlayerSetFarmAnswerEvent.SEND_NUM_BITS)
    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)

    local passwordCorrect = self.answerState = = PlayerSetFarmAnswerEvent.STATE.OK
    local passwordSet = self.password ~ = nil
    if streamWriteBool(streamId, passwordCorrect and passwordSet) then
        streamWriteString(streamId, self.password)
    end
end

```