## AITaskConveyor

**Parent**

> [AITask](?version=script&category=81&class=850)

**Functions**

- [new](#new)
- [reset](#reset)
- [setVehicle](#setvehicle)
- [start](#start)
- [stop](#stop)

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
function AITaskConveyor.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskConveyor _mt)

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
function AITaskConveyor:reset()
    self.vehicle = nil
    AITaskConveyor:superClass().reset( self )
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
function AITaskConveyor:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskConveyor:start()
    if self.vehicle ~ = nil then
        self.vehicle:startFieldWorker()
    else
            Logging.devError( "Could not start AITaskConveyor.No vehicle set" )
        end

        AITaskConveyor:superClass().start( self )
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
function AITaskConveyor:stop(wasJobStopped)
    AITaskConveyor:superClass().stop( self , wasJobStopped)

    if self.vehicle ~ = nil then
        self.vehicle:stopFieldWorker()
    else
            Logging.devError( "Could not stop AITaskConveyor.No vehicle set" )
        end
    end

```