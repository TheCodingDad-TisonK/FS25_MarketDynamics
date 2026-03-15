## AITaskFieldWork

**Parent**

> [AITask](?version=script&category=81&class=853)

**Functions**

- [new](#new)
- [reset](#reset)
- [setVehicle](#setvehicle)
- [start](#start)
- [stop](#stop)
- [update](#update)

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
function AITaskFieldWork.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskFieldWork _mt)

    self.vehicle = nil

    return self
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITaskFieldWork:reset()
    self.vehicle = nil
    AITaskFieldWork:superClass().reset( self )
end

```

### setVehicle

**Description**

**Definition**

> setVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AITaskFieldWork:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskFieldWork:start()
    if self.vehicle ~ = nil then
        self.vehicle:startFieldWorker()
    else
            Logging.devError( "Could not start AITaskFieldWork.No vehicle set" )
        end

        AITaskFieldWork:superClass().start( self )
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
function AITaskFieldWork:stop(wasJobStopped)
    AITaskFieldWork:superClass().stop( self , wasJobStopped)

    if self.vehicle ~ = nil then
        self.vehicle:stopFieldWorker()
    else
            Logging.devError( "Could not stop AITaskFieldWork.No vehicle set" )
        end
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
function AITaskFieldWork:update(dt)
end

```