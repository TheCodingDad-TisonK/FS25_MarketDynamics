## AITaskDriveTo

**Parent**

> [AITask](?version=script&category=81&class=852)

**Functions**

- [new](#new)
- [onError](#onerror)
- [onTargetReached](#ontargetreached)
- [reset](#reset)
- [setTargetDirection](#settargetdirection)
- [setTargetOffset](#settargetoffset)
- [setTargetPosition](#settargetposition)
- [setVehicle](#setvehicle)
- [start](#start)
- [startDriving](#startdriving)
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
function AITaskDriveTo.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskDriveTo _mt)

    self.x = nil
    self.z = nil
    self.dirX = nil
    self.dirZ = nil
    self.vehicle = nil
    self.state = AITaskDriveTo.STATE_DRIVE_TO_OFFSET_POS
    self.maxSpeed = 10
    self.offset = 0

    self.prepareTimeout = 0

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
function AITaskDriveTo:onError(errorMessage)
end

```

### onTargetReached

**Description**

**Definition**

> onTargetReached()

**Code**

```lua
function AITaskDriveTo:onTargetReached()
    if self.state = = AITaskDriveTo.STATE_DRIVE_TO_OFFSET_POS then
        local y = getTerrainHeightAtWorldPos(g_terrainNode, self.x, 0 , self.z)
        self.vehicle:setAITarget( self , self.x, y, self.z, self.dirX, 0 , self.dirZ, self.maxSpeed, true )
        self.state = AITaskDriveTo.STATE_DRIVE_TO_FINAL_POS
    else
            self.isFinished = true
        end
    end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITaskDriveTo:reset()
    self.vehicle = nil
    self.x, self.z = nil , nil
    self.dirX, self.dirZ = nil , nil
    self.state = AITaskDriveTo.STATE_DRIVE_TO_OFFSET_POS
    self.maxSpeed = 10
    self.offset = 0
    AITaskDriveTo:superClass().reset( self )
end

```

### setTargetDirection

**Description**

**Definition**

> setTargetDirection()

**Arguments**

| any | dirX |
|-----|------|
| any | dirZ |

**Code**

```lua
function AITaskDriveTo:setTargetDirection(dirX, dirZ)
    self.dirX = dirX
    self.dirZ = dirZ

    if self.isActive then
        -- update target
    end
end

```

### setTargetOffset

**Description**

**Definition**

> setTargetOffset()

**Arguments**

| any | offset |
|-----|--------|

**Code**

```lua
function AITaskDriveTo:setTargetOffset(offset)
    self.offset = offset
end

```

### setTargetPosition

**Description**

**Definition**

> setTargetPosition()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function AITaskDriveTo:setTargetPosition(x, z)
    self.x = x
    self.z = z

    if self.isActive then
        -- update target
        -- self.vehicle:
    end
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
function AITaskDriveTo:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskDriveTo:start()
    if self.isServer then
        self.state = AITaskDriveTo.STATE_PREPARE_DRIVING
        self.vehicle:prepareForAIDriving()

        self.isActive = true

        --#debug log("AITaskDriveTo:start()")
    end

    AITaskDriveTo:superClass().start( self )
end

```

### startDriving

**Description**

**Definition**

> startDriving()

**Code**

```lua
function AITaskDriveTo:startDriving()
    local y = getTerrainHeightAtWorldPos(g_terrainNode, self.x, 0 , self.z)
    local dirY = 0

    self.state = AITaskDriveTo.STATE_DRIVE_TO_FINAL_POS
    local x = self.x
    local z = self.z

    if self.offset ~ = 0 then
        self.state = AITaskDriveTo.STATE_DRIVE_TO_OFFSET_POS
        x = self.x + self.dirX * - self.offset
        z = self.z + self.dirZ * - self.offset
    end

    --#debug log("AITaskDriveTo:startDriving()", x, y, z, self.dirX, self.dirZ, "Drive to Offset", (self.state = = AITaskDriveTo.STATE_DRIVE_TO_OFFSET_POS))
    self.vehicle:setAITarget( self , x, y, z, self.dirX, dirY, self.dirZ)
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
function AITaskDriveTo:stop(wasJobStopped)
    AITaskDriveTo:superClass().stop( self , wasJobStopped)

    if self.isServer then
        self.vehicle:unsetAITarget()

        self.isActive = false
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
function AITaskDriveTo:update(dt)
    if self.isServer then
        if self.state = = AITaskDriveTo.STATE_PREPARE_DRIVING then
            local isReadyToDrive, blockingVehicle = self.vehicle:getIsAIReadyToDrive()
            if isReadyToDrive then
                self:startDriving()
            else
                    if not self.vehicle:getIsAIPreparingToDrive() then
                        self.prepareTimeout = self.prepareTimeout + dt
                        if self.prepareTimeout > AITaskDriveTo.PREPARE_TIMEOUT then
                            self.vehicle:stopCurrentAIJob( AIMessageErrorCouldNotPrepare.new(blockingVehicle or self.vehicle))
                        end
                    end
                end
            end
        end
    end

```