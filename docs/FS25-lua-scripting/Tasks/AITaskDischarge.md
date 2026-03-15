## AITaskDischarge

**Parent**

> [AITask](?version=script&category=81&class=851)

**Functions**

- [finishedDischarge](#finisheddischarge)
- [new](#new)
- [onError](#onerror)
- [onTargetReached](#ontargetreached)
- [reset](#reset)
- [setDischargeNode](#setdischargenode)
- [setUnloadTrigger](#setunloadtrigger)
- [setVehicle](#setvehicle)
- [start](#start)

### finishedDischarge

**Description**

**Definition**

> finishedDischarge()

**Code**

```lua
function AITaskDischarge:finishedDischarge()
    self.isFinished = true
    --#debug log("finished discharge")
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
function AITaskDischarge.new(isServer, job, customMt)
    local self = AITask.new(isServer, job, customMt or AITaskDischarge _mt)

    self.vehicle = nil
    self.unloadTrigger = nil
    self.dischargeVehicle = nil
    self.dischargeNode = nil
    self.offsetZ = 0
    self.maxSpeed = 5
    self.state = AITaskDischarge.STATE_DRIVING

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
function AITaskDischarge:onError(errorMessage)
end

```

### onTargetReached

**Description**

**Definition**

> onTargetReached()

**Code**

```lua
function AITaskDischarge:onTargetReached()
    self.vehicle:unsetAITarget()

    if self.dischargeVehicle:getAICanStartDischarge( self.dischargeNode) then
        self.state = AITaskDischarge.STATE_DISCHARGE
        self.dischargeVehicle:startAIDischarge( self.dischargeNode, self )
    else
            g_currentMission.aiSystem:stopJob( self.job, AIMessageErrorUnloadingStationFull.new())
        end
    end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AITaskDischarge:reset()
    self.vehicle = nil
    self.unloadTrigger = nil
    self.dischargeVehicle = nil
    self.dischargeNode = nil
    self.offsetZ = 0
    self.state = AITaskDischarge.STATE_DRIVING
    AITaskDischarge:superClass().reset( self )
end

```

### setDischargeNode

**Description**

**Definition**

> setDischargeNode()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | dischargeNode |
| any | offsetZ       |

**Code**

```lua
function AITaskDischarge:setDischargeNode(vehicle, dischargeNode, offsetZ)
    if vehicle ~ = nil then
        self.offsetZ = offsetZ
        vehicle:setCurrentDischargeNodeIndex(dischargeNode.index)
    end

    self.dischargeNode = dischargeNode
    self.dischargeVehicle = vehicle
end

```

### setUnloadTrigger

**Description**

**Definition**

> setUnloadTrigger()

**Arguments**

| any | unloadTrigger |
|-----|---------------|

**Code**

```lua
function AITaskDischarge:setUnloadTrigger(unloadTrigger)
    self.unloadTrigger = unloadTrigger
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
function AITaskDischarge:setVehicle(vehicle)
    self.vehicle = vehicle
end

```

### start

**Description**

**Definition**

> start()

**Code**

```lua
function AITaskDischarge:start()
    if self.isServer then
        local x, z, xDir, zDir = self.unloadTrigger:getAITargetPositionAndDirection()
        x = x + xDir * - self.offsetZ
        z = z + zDir * - self.offsetZ
        local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)

        self.vehicle:setAITarget( self , x, y, z, xDir, 0 , zDir, self.maxSpeed, true )
        self.state = AITaskDischarge.STATE_DRIVING
    end

    AITaskDischarge:superClass().start( self )
end

```