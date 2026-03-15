## RollercoasterActivatable

**Functions**

- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function RollercoasterActivatable:getIsActivatable()
    return self.rollercoaster:getCanEnter()
end

```

### new

**Description**

**Definition**

> new(table rollercoaster)

**Arguments**

| table | rollercoaster | rollercoaster instance |
|-------|---------------|------------------------|

**Code**

```lua
function RollercoasterActivatable.new(rollercoaster)
    local self = setmetatable( { } , RollercoasterActivatable _mt)

    self.rollercoaster = rollercoaster
    self.activateText = g_i18n:getText( "action_rideRollercoaster" )

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function RollercoasterActivatable:run()
    if self.rollercoaster:getCanEnter() then
        local seatIndex = self.rollercoaster:getFreeSeatIndex()

        if seatIndex ~ = nil then
            g_client:getServerConnection():sendEvent( RollercoasterPassengerEnterRequestEvent.new( self.rollercoaster, g_localPlayer))
        end
    end
end

```