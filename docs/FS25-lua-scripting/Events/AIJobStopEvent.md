## AIJobStopEvent

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
function AIJobStopEvent.emptyNew()
    local self = Event.new( AIJobStopEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | job       |
|-----|-----------|
| any | aiMessage |

**Code**

```lua
function AIJobStopEvent.new(job, aiMessage)
    local self = AIJobStopEvent.emptyNew()

    self.aiMessage = aiMessage
    self.job = job

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
function AIJobStopEvent:readStream(streamId, connection)

    local jobId = streamReadInt32(streamId)
    self.job = g_currentMission.aiSystem:getJobById(jobId)

    if streamReadBool(streamId) then
        local messageIndex = streamReadInt32(streamId)
        self.aiMessage = g_currentMission.aiMessageManager:createMessage(messageIndex)
        self.aiMessage:readStream(streamId, connection)
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
function AIJobStopEvent:run(connection)
    if self.job ~ = nil then
        if connection:getIsServer() then
            g_currentMission.aiSystem:stopJobInternal( self.job, self.aiMessage)
        else
                g_currentMission.aiSystem:stopJob( self.job, self.aiMessage)
            end
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
function AIJobStopEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.job.jobId)
    if streamWriteBool(streamId, self.aiMessage ~ = nil ) then
        local messageIndex = g_currentMission.aiMessageManager:getMessageIndex( self.aiMessage)
        streamWriteInt32(streamId, messageIndex)
        self.aiMessage:writeStream(streamId, connection)
    end
end

```