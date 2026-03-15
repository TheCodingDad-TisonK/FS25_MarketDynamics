## AITaskWaitForFilling

**Parent**

> [AITask](?version=script&category=81&class=855)

**Functions**

- [addAllowedFillType](#addallowedfilltype)
- [addFillUnits](#addfillunits)
- [new](#new)
- [reset](#reset)
- [setVehicle](#setvehicle)
- [start](#start)
- [stop](#stop)
- [update](#update)

### addAllowedFillType

**Description**

**Definition**

> addAllowedFillType()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function AITaskWaitForFilling:addAllowedFillType(fillType)
    self.fillTypes[fillType] = true
end

```

### addFillUnits

**Description**

**Definition**

> addFillUnits()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function AITaskWaitForFilling:addFillUnits(vehicle, fillUnitIndex)
    table.insert( self.fillUnitInfo, { vehicle = vehicle, fillUnitIndex = fillUnitIndex } )
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
function AITaskWaitForFilling.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskWaitForFilling _mt)

    self.fillTypes = { }
    self.vehicle = nil
    self.fillUnitInfo = { }
    self.waitTime = 0
    self.waitDuration = 3 * 1000
    self.isFullyLoaded = false

    return self
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITaskWaitForFilling:reset()
    self.vehicle = nil
    self.fillTypes = { }
    self.fillUnitInfo = { }
    self.waitTime = 0
    self.isFullyLoaded = false
    AITaskWaitForFilling:superClass().reset( self )
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
function AITaskWaitForFilling:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskWaitForFilling:start()
    AITaskWaitForFilling:superClass().start( self )

    if self.isServer then
        self.isFullyLoaded = false
        for _, fillUnitInfo in ipairs( self.fillUnitInfo) do
            fillUnitInfo.vehicle:aiPrepareLoading(fillUnitInfo.fillUnitIndex, self )
        end
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
function AITaskWaitForFilling:stop(wasJobStopped)
    AITaskWaitForFilling:superClass().stop( self , wasJobStopped)

    if self.isServer then
        for _, fillUnitInfo in ipairs( self.fillUnitInfo) do
            fillUnitInfo.vehicle:aiFinishLoading(fillUnitInfo.fillUnitIndex, self )
        end
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
function AITaskWaitForFilling:update(dt)
    if self.isServer then
        if not self.isFullyLoaded then
            local valid = false
            local isFullyLoaded = true
            for _, fillUnitInfo in ipairs( self.fillUnitInfo) do
                local vehicle = fillUnitInfo.vehicle
                local fillUnitIndex = fillUnitInfo.fillUnitIndex
                local fillType = vehicle:getFillUnitFillType(fillUnitIndex)
                local fillLevel = vehicle:getFillUnitFillLevel(fillUnitIndex)
                local freeCapacity = vehicle:getFillUnitFreeCapacity(fillUnitIndex)

                if freeCapacity > 0 then
                    isFullyLoaded = false
                end

                if (fillLevel > 0 and self.fillTypes[fillType]) or fillLevel = = 0 then
                    valid = true
                end
            end

            if not valid then
                g_currentMission.aiSystem:stopJob( self.job, AIMessageErrorNoValidFillTypeLoaded.new())
                return
            end

            if isFullyLoaded then
                self.isFullyLoaded = true
                self.waitTime = g_ time + self.waitDuration
            end
        else
                if g_ time > self.waitTime then
                    self.isFinished = true
                end
            end
        end
    end

```