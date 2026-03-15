## NightlightFlicker

**Description**

> s are flickering lights that are only active at night or during bad weather

**Functions**

- [new](#new)
- [onCreate](#oncreate)
- [onWeatherChanged](#onweatherchanged)
- [update](#update)

### new

**Description**

> Creating nightlightflicker

**Definition**

> new(integer name)

**Arguments**

| integer | name | node id |
|---------|------|---------|

**Return Values**

| integer | instance | Instance of object |
|---------|----------|--------------------|

**Code**

```lua
function NightlightFlicker.new(id)
    local self = setmetatable( { } , NightlightFlicker _mt)

    self.id = id
    self.isVisible = false
    self.isFlickerActive = false
    self.nextFlicker = 0
    self.flickerDuration = 100
    setVisibility( self.id, self.isVisible)

    g_messageCenter:subscribe(MessageType.DAY_NIGHT_CHANGED, self.oNWeatherChanged, self )

    return self
end

```

### onCreate

**Description**

> Creating nightlightflicker

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function NightlightFlicker:onCreate(id)
    g_currentMission:addUpdateable( NightlightFlicker.new(id))
end

```

### onWeatherChanged

**Description**

> Change visibility of night object

**Definition**

> onWeatherChanged()

**Code**

```lua
function NightlightFlicker:onWeatherChanged()
    if g_currentMission ~ = nil and g_currentMission.environment ~ = nil then
        self.isVisible = not(g_currentMission.environment.isSunOn and not g_currentMission.environment.weather:getIsRaining())
        setVisibility( self.id, self.isVisible)
    end
end

```

### update

**Description**

> Update flickering

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function NightlightFlicker:update(dt)
    if self.isVisible then

        self.nextFlicker = self.nextFlicker - dt
        if self.nextFlicker < = 0 then
            self.isFlickerActive = true
            setVisibility( self.id, false )
            self.nextFlicker = math.floor( math.random() * 1500 + self.flickerDuration + 10 ) -- set next flicker at least 10ms after this one
        end

        if self.isFlickerActive then
            self.flickerDuration = self.flickerDuration - dt
            if self.flickerDuration < = 0 then
                self.isFlickerActive = false
                self.flickerDuration = math.floor( math.random() * 200 )
                setVisibility( self.id, true )
            end
        end

    end
end

```