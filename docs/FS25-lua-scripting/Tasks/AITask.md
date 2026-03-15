## AITask

**Functions**

- [delete](#delete)
- [getIsFinished](#getisfinished)
- [new](#new)
- [reset](#reset)
- [skip](#skip)
- [start](#start)
- [stop](#stop)
- [update](#update)
- [validate](#validate)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AITask:delete()
end

```

### getIsFinished

**Description**

**Definition**

> getIsFinished()

**Code**

```lua
function AITask:getIsFinished()
    return self.isFinished
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | job      |
| any | customMt |

**Code**

```lua
function AITask.new(isServer, job, customMt)
    local self = setmetatable( { } , customMt or AITask _mt)

    self.isServer = isServer
    self.job = job
    self.isFinished = false
    self.isRunning = false
    self.markAsFinished = false

    return self
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITask:reset()
    self.isFinished = false
end

```

### skip

**Description**

**Definition**

> skip()

**Code**

```lua
function AITask:skip()
    --#debug Logging.devInfo("%s:skip() - IsRunning %s", ClassUtil.getClassNameByObject(self), tostring(self.isRunning))
    if self.isRunning then
        self.isFinished = true
    else
            self.markAsFinished = true
        end
    end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITask:start()
    --#debug Logging.devInfo("%s:start()", ClassUtil.getClassNameByObject(self))
    self.isFinished = false
    self.isRunning = true

    if self.markAsFinished then
        --#debug Logging.devInfo("%s:start() mark as finished", ClassUtil.getClassNameByObject(self))
        self.isFinished = true
        self.markAsFinished = false
    end
end

```

### stop

**Description**

**Definition**

> stop()

**Arguments**

| any | wasJobStopped |
|-----|---------------|

**Code**

```lua
function AITask:stop(wasJobStopped)
    --#debug Logging.devInfo("%s:stop()", ClassUtil.getClassNameByObject(self))
    self.isRunning = false
    self.markAsFinished = false
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AITask:update(dt)
end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | ignoreUnsetParameters |
|-----|-----------------------|

**Code**

```lua
function AITask:validate(ignoreUnsetParameters)
    return true , nil
end

```