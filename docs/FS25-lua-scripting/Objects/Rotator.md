## Rotator

**Description**

> s rotate around a specified axis (default z) with a specified speed

**Functions**

- [new](#new)
- [onCreate](#oncreate)
- [update](#update)

### new

**Description**

> Creating rotator

**Definition**

> new(entityId node)

**Arguments**

| entityId | node | node id |
|----------|------|---------|

**Return Values**

| entityId | instance | Instance of object |
|----------|----------|--------------------|

**Code**

```lua
function Rotator.new(node)
    local self = setmetatable( { } , Rotator _mt)

    self.axisTable = { 0 , 0 , 0 }
    self.rotationNode = node
    local rpm = tonumber(getUserAttribute(node, "rpm" ))
    if rpm ~ = nil then
        self.speed = (rpm * 2 * math.pi) / 60 / 1000 -- rpm to rad/ms
    else
            self.speed = Utils.getNoNil( tonumber(getUserAttribute(node, "speed" )), 0.0012 )
        end
        local axis = Utils.getNoNil(getUserAttribute(node, "axis" ), 3 )
        self.axisTable[axis] = 1

        return self
    end

```

### onCreate

**Description**

> Creating rotator

**Definition**

> onCreate(entityId id)

**Arguments**

| entityId | id | node id |
|----------|----|---------|

**Code**

```lua
function Rotator:onCreate(id)
    g_currentMission:addUpdateable( Rotator.new(id))
end

```

### update

**Description**

> Update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function Rotator:update(dt)
    rotate( self.rotationNode, self.axisTable[ 1 ] * self.speed * dt, self.axisTable[ 2 ] * self.speed * dt, self.axisTable[ 3 ] * self.speed * dt)
end

```