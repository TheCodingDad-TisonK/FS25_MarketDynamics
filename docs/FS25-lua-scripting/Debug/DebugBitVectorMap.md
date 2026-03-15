## DebugBitVectorMap

**Functions**

- [aiAreaCheck](#aiareacheck)
- [createWithAIVehicle](#createwithaivehicle)
- [createWithCustomFunc](#createwithcustomfunc)
- [draw](#draw)
- [new](#new)
- [setAdditionalDrawInfoFunc](#setadditionaldrawinfofunc)

### aiAreaCheck

**Description**

**Definition**

> aiAreaCheck()

**Arguments**

| any | startWorldX  |
|-----|--------------|
| any | startWorldZ  |
| any | widthWorldX  |
| any | widthWorldZ  |
| any | heightWorldX |
| any | heightWorldZ |

**Code**

```lua
function DebugBitVectorMap:aiAreaCheck(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    return AIVehicleUtil.getAIAreaOfVehicle( self.aiVehicle, startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
end

```

### createWithAIVehicle

**Description**

**Definition**

> createWithAIVehicle(table vehicle)

**Arguments**

| table | vehicle |
|-------|---------|

**Return Values**

| table | self |
|-------|------|

**Code**

```lua
function DebugBitVectorMap:createWithAIVehicle(vehicle)
    self.aiVehicle = vehicle

    return self
end

```

### createWithCustomFunc

**Description**

**Definition**

> createWithCustomFunc(function customFunc)

**Arguments**

| function | customFunc |
|----------|------------|

**Return Values**

| function | self |
|----------|------|

**Code**

```lua
function DebugBitVectorMap:createWithCustomFunc(customFunc)
    self.customFunc = customFunc

    return self
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugBitVectorMap:draw()
    if self.aiVehicle ~ = nil then
        if not self.aiVehicle.isDeleted and not self.aiVehicle.isDeleting then
            local cx, _, cz = getWorldTranslation( self.aiVehicle.rootNode)
            self:drawAroundCenter(cx, cz, DebugBitVectorMap.aiAreaCheck)
        end
    elseif self.customFunc ~ = nil then
            local cx, _, cz = getWorldTranslation(g_cameraManager:getActiveCamera())
            self:drawAroundCenter(cx, cz, self.customFunc)
        end
    end

```

### new

**Description**

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function DebugBitVectorMap.new(customMt)
    local self = setmetatable( { } , customMt or DebugBitVectorMap _mt)

    self.radius = 15
    self.cellSize = 0.5
    self.vertexAligned = false

    self.opacity = 0.4 -- opacity if no custom opacity is defined for specfic value color
        self.valueToColor = {
        [ 0 ] = Color.PRESETS.RED:copy(),
        [ 1 ] = Color.PRESETS.GREEN:copy(),
        [ 2 ] = Color.PRESETS.BLUE:copy(),
        -- TODO:add more default, add setter
        }
        self.undefinedValueColor = Color.new( 0.2 , 0.2 , 0.2 )

        self.yOffset = 0.1
        self.solid = false
        self.pixelPaddingFactor = 0.02 -- factor applied to cellSize adding some padding to rendered pixels
        self.displayLegend = true

        return self
    end

```

### setAdditionalDrawInfoFunc

**Description**

**Definition**

> setAdditionalDrawInfoFunc(function drawInfoFunc)

**Arguments**

| function | drawInfoFunc |
|----------|--------------|

**Return Values**

| function | self |
|----------|------|

**Code**

```lua
function DebugBitVectorMap:setAdditionalDrawInfoFunc(drawInfoFunc)
    self.drawInfoFunc = drawInfoFunc

    return self
end

```