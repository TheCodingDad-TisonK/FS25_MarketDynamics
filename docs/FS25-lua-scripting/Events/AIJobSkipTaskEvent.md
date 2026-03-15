## AIJobSkipTaskEvent

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
function AIJobSkipTaskEvent.emptyNew()
    local self = Event.new( AIJobSkipTaskEvent _mt)
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AIJobSkipTaskEvent.new(job)
    local self = AIJobSkipTaskEvent.emptyNew()

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
function AIJobSkipTaskEvent:readStream(streamId, connection)
    local jobId = streamReadInt32(streamId)
    self.job = g_currentMission.aiSystem:getJobById(jobId)

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
function AIJobSkipTaskEvent:run(connection)
    assert( not connection:getIsServer(), "AIJobSkipTaskEvent is client to server only" )

    g_currentMission.aiSystem:skipCurrentTaskInternal( self.job)

    if Platform.isMobile then
        g_messageCenter:publish(MessageType.AI_TASK_SKIPPED)
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
function AIJobSkipTaskEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.job.jobId)
end

```