## BoatyardActivatable

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
function BoatyardActivatable:getIsActivatable()
    local ownerFarmId = self.boatyard:getOwnerFarmId()
    return ownerFarmId = = AccessHandler.EVERYONE -- or ownerFarmId = = g_currentMission:getFarmId()
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | boatyard |
|-----|----------|

**Code**

```lua
function BoatyardActivatable.new(boatyard)
    local self = setmetatable( { } , BoatyardActivatable _mt)

    self.boatyard = boatyard
    self.activateText = string.format(g_i18n:getText( "action_buyOBJECT" ), self.boatyard:getName())

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function BoatyardActivatable:run()
    local ownerFarmId = self.boatyard:getOwnerFarmId()
    if ownerFarmId = = AccessHandler.EVERYONE then
        self.boatyard:buyRequest()
    end
end

```