## AIJobVehicleStateEvent

**Description**

> Event for ai start

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

> Create instance of Event class

**Definition**

> emptyNew()

**Return Values**

| any | self | instance of class event |
|-----|------|-------------------------|

**Code**

```lua
function AIJobVehicleStateEvent.emptyNew()
    local self = Event.new( AIJobVehicleStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isActive, , )

**Arguments**

| table   | vehicle       | vehicle   |
|---------|---------------|-----------|
| boolean | isActive      | is active |
| any     | helperIndex   |           |
| any     | startedFarmId |           |

**Code**

```lua
function AIJobVehicleStateEvent.new(vehicle, job, helperIndex, startedFarmId)
    local self = AIJobVehicleStateEvent.emptyNew()

    self.vehicle = vehicle
    self.job = job
    self.helperIndex = helperIndex
    self.startedFarmId = startedFarmId

    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function AIJobVehicleStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

    if streamReadBool(streamId) then
        local jobId = streamReadInt32(streamId)
        self.job = g_currentMission.aiSystem:getJobById(jobId)
        self.startedFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
        self.helperIndex = streamReadUInt8(streamId)
    end

    self:run(connection)
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection | connection |
|------------|------------|------------|

**Code**

```lua
function AIJobVehicleStateEvent:run(connection)
    if self.vehicle ~ = nil then
        if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
            if self.job ~ = nil then
                self.vehicle:aiJobStarted( self.job, self.helperIndex, self.startedFarmId)
            else
                    self.vehicle:aiJobFinished()
                end
            end
        end
    end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function AIJobVehicleStateEvent:writeStream(streamId, connection)
    assert( not connection:getIsServer(), "AIJobVehicleStateEvent is a server to client event only" )
    NetworkUtil.writeNodeObject(streamId, self.vehicle)

    if streamWriteBool(streamId, self.job ~ = nil ) then
        streamWriteInt32(streamId, self.job.jobId)
        streamWriteUIntN(streamId, self.startedFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)
        streamWriteUInt8(streamId, self.helperIndex)
    end
end

```