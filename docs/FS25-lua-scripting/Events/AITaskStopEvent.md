## AITaskStopEvent

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
function AITaskStopEvent.emptyNew()
    local self = Event.new( AITaskStopEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | job           |
|-----|---------------|
| any | task          |
| any | wasJobStopped |

**Code**

```lua
function AITaskStopEvent.new(job, task, wasJobStopped)
    local self = AITaskStopEvent.emptyNew()

    self.job = job
    self.wasJobStopped = wasJobStopped
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
function AITaskStopEvent:readStream(streamId, connection)
    local jobId = streamReadInt32(streamId)
    local taskId = streamReadUInt8(streamId)
    local wasJobStopped = streamReadBool(streamId)

    self.job = g_currentMission.aiSystem:getJobById(jobId)
    if self.job ~ = nil then
        self.task = self.job:getTaskByIndex(taskId)
    end

    self.wasJobStopped = wasJobStopped

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
function AITaskStopEvent:run(connection)
    if self.job = = nil then
        Logging.devWarning( "AITaskStopEvent:Job not defined" )
        return
    end

    self.job:stopTask( self.task, self.wasJobStopped)
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
function AITaskStopEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.job.jobId)
    streamWriteUInt8(streamId, self.task.taskIndex)
    streamWriteBool(streamId, self.wasJobStopped)
end

```