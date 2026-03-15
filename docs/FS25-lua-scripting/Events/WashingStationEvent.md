## WashingStationEvent

**Description**

> Event for washing stations

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
function WashingStationEvent.emptyNew()
    local self = Event.new( WashingStationEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table washingStation)

**Arguments**

| table | washingStation | washingStation |
|-------|----------------|----------------|

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function WashingStationEvent.new(washingStation)
    local self = WashingStationEvent.emptyNew()
    self.washingStation = washingStation
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
function WashingStationEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.washingStation = NetworkUtil.readNodeObject(streamId)
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
function WashingStationEvent:run(connection)
    if not connection:getIsServer() then
        local userId = g_currentMission.userManager:getUserIdByConnection(connection)
        if userId ~ = nil then
            local farm = g_farmManager:getFarmByUserId(userId)
            if farm ~ = nil then
                self.washingStation:startWashing(farm.farmId)
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
function WashingStationEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.washingStation)
    end
end

```