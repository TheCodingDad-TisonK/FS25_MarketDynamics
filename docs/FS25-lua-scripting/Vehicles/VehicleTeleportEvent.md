## VehicleTeleportEvent

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [run](#run)

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
function VehicleTeleportEvent.emptyNew()
    local self = Event.new( VehicleTeleportEvent _mt, NetworkNode.CHANNEL_MAIN)
    return self
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
function VehicleTeleportEvent:run(connection)
    if not connection:getIsServer() then
        if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
            g_currentMission:teleportVehicle( self.vehicle, self.x, self.z, self.rotY)
        end
    end
end

```