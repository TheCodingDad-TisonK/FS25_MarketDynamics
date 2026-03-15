## AIJobStartRequestEvent

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [newServerToClient](#newservertoclient)
- [readStream](#readstream)
- [run](#run)
- [writeStream](#writestream)

### emptyNew

**Description**

**Definition**

> emptyNew()

**Code**

```lua
function AIJobStartRequestEvent.emptyNew()
    local self = Event.new( AIJobStartRequestEvent _mt)
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
function AIJobStartRequestEvent.new(job, startFarmId)
    local self = AIJobStartRequestEvent.emptyNew()

    self.job = job
    self.startFarmId = startFarmId

    return self
end

```

### newServerToClient

**Description**

**Definition**

> newServerToClient()

**Arguments**

| any | state        |
|-----|--------------|
| any | jobTypeIndex |

**Code**

```lua
function AIJobStartRequestEvent.newServerToClient(state, jobTypeIndex)
    local self = AIJobStartRequestEvent.emptyNew()

    self.state = state
    self.jobTypeIndex = jobTypeIndex

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
function AIJobStartRequestEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.startFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
        local jobTypeIndex = streamReadUInt16(streamId)
        self.job = g_currentMission.aiJobTypeManager:createJob(jobTypeIndex)
        self.job:readStream(streamId, connection)
    else
            self.state = streamReadUInt8(streamId)
            self.jobTypeIndex = streamReadUInt16(streamId)
        end

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
function AIJobStartRequestEvent:run(connection)
    if not connection:getIsServer() then
        local jobTypeIndex = g_currentMission.aiJobTypeManager:getJobTypeIndex( self.job)

        local startable, state = self.job:getIsStartable(connection)

        if not startable then
            connection:sendEvent( AIJobStartRequestEvent.newServerToClient(state, jobTypeIndex))
            return
        end

        connection:sendEvent( AIJobStartRequestEvent.newServerToClient( 0 , jobTypeIndex))
        g_currentMission.aiSystem:startJob( self.job, self.startFarmId)
    else
            g_messageCenter:publish( AIJobStartRequestEvent , self.state, self.jobTypeIndex)
        end
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
function AIJobStartRequestEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteUIntN(streamId, self.startFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)
        local jobTypeIndex = g_currentMission.aiJobTypeManager:getJobTypeIndex( self.job)
        streamWriteUInt16(streamId, jobTypeIndex)
        self.job:writeStream(streamId, connection)
    else
            streamWriteUInt8(streamId, self.state)
            streamWriteUInt16(streamId, self.jobTypeIndex)
        end
    end

```