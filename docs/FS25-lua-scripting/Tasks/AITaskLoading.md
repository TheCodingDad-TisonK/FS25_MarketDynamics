## AITaskLoading

**Parent**

> [AITask](?version=script&category=81&class=854)

**Functions**

- [finishedLoading](#finishedloading)
- [new](#new)
- [onError](#onerror)
- [onTargetReached](#ontargetreached)
- [reset](#reset)
- [setFillType](#setfilltype)
- [setFillUnit](#setfillunit)
- [setLoadTrigger](#setloadtrigger)
- [setVehicle](#setvehicle)
- [start](#start)

### finishedLoading

**Description**

**Definition**

> finishedLoading()

**Code**

```lua
function AITaskLoading:finishedLoading()
    if self.loadVehicle ~ = nil then
        self.loadVehicle:aiFinishLoading( self.fillUnitIndex, self )
    end

    --#debug log("finished loading")
    self.isFinished = true
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
function AITaskLoading.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskLoading _mt)

    self.vehicle = nil
    self.loadTrigger = nil
    self.fillType = nil
    self.loadVehicle = nil
    self.fillUnitIndex = nil
    self.offsetZ = 0
    self.maxSpeed = 5

    return self
end

```

### onError

**Description**

**Definition**

> onError()

**Arguments**

| any | errorMessage |
|-----|--------------|

**Code**

```lua
function AITaskLoading:onError(errorMessage)
end

```

### onTargetReached

**Description**

**Definition**

> onTargetReached()

**Code**

```lua
function AITaskLoading:onTargetReached()
    --#debug log("start filling")

    self.vehicle:unsetAITarget()

    self.state = AITaskLoading.STATE_LOADING
    self.loadVehicle:aiPrepareLoading( self.fillUnitIndex, self )
    self.loadVehicle:aiStartLoadingFromTrigger( self.loadTrigger, self.fillUnitIndex, self.fillType, self )
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITaskLoading:reset()
    self.vehicle = nil
    self.loadTrigger = nil
    self.loadVehicle = nil
    self.fillType = nil
    AITaskLoading:superClass().reset( self )
end

```

### setFillType

**Description**

**Definition**

> setFillType()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function AITaskLoading:setFillType(fillType)
    self.fillType = fillType
end

```

### setFillUnit

**Description**

**Definition**

> setFillUnit()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | fillUnitIndex |
| any | offsetZ       |

**Code**

```lua
function AITaskLoading:setFillUnit(vehicle, fillUnitIndex, offsetZ)
    self.offsetZ = offsetZ
    self.loadVehicle = vehicle
    self.fillUnitIndex = fillUnitIndex
end

```

### setLoadTrigger

**Description**

**Definition**

> setLoadTrigger()

**Arguments**

| any | loadTrigger |
|-----|-------------|

**Code**

```lua
function AITaskLoading:setLoadTrigger(loadTrigger)
    self.loadTrigger = loadTrigger
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
function AITaskLoading:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskLoading:start()
    if self.isServer then
        local x, z, xDir, zDir = self.loadTrigger:getAITargetPositionAndDirection()
        x = x + xDir * - self.offsetZ
        z = z + zDir * - self.offsetZ
        local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)

        self.vehicle:setAITarget( self , x, y, z, xDir, 0 , zDir, self.maxSpeed, true )

        self.state = AITaskLoading.STATE_DRIVING
    end

    AITaskLoading:superClass().start( self )
end

```