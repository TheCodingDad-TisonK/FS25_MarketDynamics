## AIJobStartEvent

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

**Definition**

> emptyNew()

**Code**

```lua
function AIJobStartEvent.emptyNew()
    local self = Event.new( AIJobStartEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | job         |
|-----|-------------|
| any | startFarmId |

**Code**

```lua
function AIJobStartEvent.new(job, startFarmId)
    local self = AIJobStartEvent.emptyNew()

    self.job = job
    self.startFarmId = startFarmId

    return self
end

```

### readStream

**Description**

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIJobStartEvent:readStream(streamId, connection)
    assert(connection:getIsServer(), "AIJobStartEvent is a server to client only event" )

    self.startFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    local jobTypeIndex = streamReadInt32(streamId)

    self.job = g_currentMission.aiJobTypeManager:createJob(jobTypeIndex)
    self.job:readStream(streamId, connection)

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
function AIJobStartEvent:run(connection)
    g_currentMission.aiSystem:startJobInternal( self.job, self.startFarmId)
end

```

### writeStream

**Description**

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIJobStartEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.startFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    local jobTypeIndex = g_currentMission.aiJobTypeManager:getJobTypeIndex( self.job)
    streamWriteInt32(streamId, jobTypeIndex)
    self.job:writeStream(streamId, connection)
end

```