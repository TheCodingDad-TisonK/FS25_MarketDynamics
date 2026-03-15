## AITaskStartEvent

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
function AITaskStartEvent.emptyNew()
    local self = Event.new( AITaskStartEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | job  |
|-----|------|
| any | task |

**Code**

```lua
function AITaskStartEvent.new(job, task)
    local self = AITaskStartEvent.emptyNew()

    self.job = job
    self.task = task

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
function AITaskStartEvent:readStream(streamId, connection)
    local jobId = streamReadInt32(streamId)
    local taskId = streamReadUInt8(streamId)

    self.job = g_currentMission.aiSystem:getJobById(jobId)
    if self.job ~ = nil then
        self.task = self.job:getTaskByIndex(taskId)
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
function AITaskStartEvent:run(connection)
    if self.job = = nil then
        Logging.devWarning( "AITaskStartEvent:Job not defined" )
        return
    end

    self.job:startTask( self.task)
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
function AITaskStartEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.job.jobId)
    streamWriteUInt8(streamId, self.task.taskIndex)
end

```