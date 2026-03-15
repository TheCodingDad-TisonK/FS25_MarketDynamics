## SunAdmirer

**Description**

> Class for objects which are visible when the sun is out

**Functions**

- [delete](#delete)
- [new](#new)
- [onCreate](#oncreate)
- [onWeatherChanged](#onweatherchanged)

### delete

**Description**

> Remove Object from WeatherChangeListeners

**Definition**

> delete()

**Code**

```lua
function SunAdmirer:delete()
    g_messageCenter:unsubscribeAll( self )
end

```

### new

**Description**

> Creating nightlight object

**Definition**

> new(integer name)

**Arguments**

| integer | name | ID of the node |
|---------|------|----------------|

**Return Values**

| integer | instance | Instance of object |
|---------|----------|--------------------|

**Code**

```lua
function SunAdmirer.new(id)
    local self = setmetatable( { } , SunAdmirer _mt)

    self.id = id
    self.switchCollision = Utils.getNoNil(getUserAttribute(id, "switchCollision" ), false )

    if self.switchCollision then
        self.collisionMask = getCollisionFilterMask(id)
    end

    self:setVisibility( true )

    g_messageCenter:subscribe(MessageType.DAY_NIGHT_CHANGED, self.onWeatherChanged, self )

    return self
end

```

### onCreate

**Description**

> Creating sun admirer object

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | ID of the node |
|---------|----|----------------|

**Code**

```lua
function SunAdmirer:onCreate(id)
    g_currentMission:addNonUpdateable( SunAdmirer.new(id))
end

```

### onWeatherChanged

**Description**

> Change visibility of sun object

**Definition**

> onWeatherChanged()

**Code**

```lua
function SunAdmirer:onWeatherChanged()
    if g_currentMission ~ = nil and g_currentMission.environment ~ = nil then
        self:setVisibility(g_currentMission.environment.isSunOn and not g_currentMission.environment.weather:getIsRaining())
    end
end

```