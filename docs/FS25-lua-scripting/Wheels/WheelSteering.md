## WheelSteering

**Description**

> Handles the steering related nodes (steering nodes, fender nodes)

**Functions**

- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setSteeringValues](#setsteeringvalues)
- [update](#update)

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlObject |
|-----|-----------|

**Code**

```lua
function WheelSteering:loadFromXML(xmlObject)
    self.steeringNode = xmlObject:getValue( ".steering#node" , nil , self.vehicle.components, self.vehicle.i3dMappings)
    self.steeringRotNode = xmlObject:getValue( ".steering#rotNode" , nil , self.vehicle.components, self.vehicle.i3dMappings)
    self.steeringNodeMinTransX = xmlObject:getValue( ".steering#nodeMinTransX" )
    self.steeringNodeMaxTransX = xmlObject:getValue( ".steering#nodeMaxTransX" )
    self.steeringNodeMinRotY = xmlObject:getValue( ".steering#nodeMinRotY" )
    self.steeringNodeMaxRotY = xmlObject:getValue( ".steering#nodeMaxRotY" )

    self.fenders = { }

    local i = 0
    while true do
        local fenderKey = string.format( ".fender(%d)" , i)
        local xmlFile, _ = xmlObject:getXMLFileAndPropertyKey(fenderKey)
        if xmlFile = = nil then
            break
        end

        local entry = { }
        entry.node = xmlObject:getValue(fenderKey .. "#node" , nil , self.vehicle.components, self.vehicle.i3dMappings)
        if entry.node ~ = nil then
            entry.rotMax = xmlObject:getValue(fenderKey .. "#rotMax" )
            entry.rotMin = xmlObject:getValue(fenderKey .. "#rotMin" )

            table.insert( self.fenders, entry)
        end

        i = i + 1
    end

    self.steeringAxleScale = xmlObject:getValue( ".steeringAxle#scale" , 0 )
    self.steeringAxleRotMax = xmlObject:getValue( ".steeringAxle#rotMax" , 0 )
    self.steeringAxleRotMin = xmlObject:getValue( ".steeringAxle#rotMin" , - 0 )

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | wheel |
|-----|-------|

**Code**

```lua
function WheelSteering.new(wheel)
    local self = setmetatable( { } , { __index = WheelSteering } )

    self.wheel = wheel
    self.vehicle = wheel.vehicle

    self.steeringNodeMaxRot = 1
    self.steeringNodeMinRot = - 1

    return self
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function WheelSteering.registerXMLPaths(schema, key)
    schema:register(XMLValueType.NODE_INDEX, key .. ".steering#node" , "Steering node" )
    schema:register(XMLValueType.NODE_INDEX, key .. ".steering#rotNode" , "Steering rot node" )
    schema:register(XMLValueType.FLOAT, key .. ".steering#nodeMinTransX" , "Min.X translation" )
    schema:register(XMLValueType.FLOAT, key .. ".steering#nodeMaxTransX" , "Max.X translation" )
    schema:register(XMLValueType.ANGLE, key .. ".steering#nodeMinRotY" , "Min.Y rotation" )
    schema:register(XMLValueType.ANGLE, key .. ".steering#nodeMaxRotY" , "Max.Y rotation" )

    schema:register(XMLValueType.NODE_INDEX, key .. ".fender(?)#node" , "Fender node" )
    schema:register(XMLValueType.ANGLE, key .. ".fender(?)#rotMax" , "Max.rotation" )
    schema:register(XMLValueType.ANGLE, key .. ".fender(?)#rotMin" , "Min.rotation" )

    schema:register(XMLValueType.FLOAT, key .. ".steeringAxle#scale" , "Steering axle scale" )
    schema:register(XMLValueType.ANGLE, key .. ".steeringAxle#rotMax" , "Max.rotation" )
    schema:register(XMLValueType.ANGLE, key .. ".steeringAxle#rotMin" , "Min.rotation" )
end

```

### setSteeringValues

**Description**

**Definition**

> setSteeringValues()

**Arguments**

| any | rotMin      |
|-----|-------------|
| any | rotMax      |
| any | rotSpeed    |
| any | rotSpeedNeg |
| any | inverted    |

**Code**

```lua
function WheelSteering:setSteeringValues(rotMin, rotMax, rotSpeed, rotSpeedNeg, inverted)
    if self.steeringAxleScale ~ = 0 then
        if inverted then
            self.steeringAxleScale = - self.steeringAxleScale
        end

        self.steeringAxleRotMax = rotMax
        self.steeringAxleRotMin = rotMin
    end

    for i = 1 , # self.fenders do
        local fender = self.fenders[i]

        fender.rotMax = fender.rotMax or rotMax
        fender.rotMin = fender.rotMin or rotMin
    end

    self.steeringNodeMaxRot = math.max(rotMax, self.steeringAxleRotMax)
    self.steeringNodeMinRot = math.min(rotMin, self.steeringAxleRotMin)
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | x                |
|-----|------------------|
| any | y                |
| any | z                |
| any | xDrive           |
| any | suspensionLength |
| any | steeringAngle    |
| any | changed          |

**Code**

```lua
function WheelSteering:update(x, y, z, xDrive, suspensionLength, steeringAngle, changed)
    if self.steeringNode ~ = nil then
        local refAngle = self.steeringNodeMaxRot
        local refTrans = self.steeringNodeMaxTransX
        local refRot = self.steeringNodeMaxRotY
        if steeringAngle < 0 then
            refAngle = self.steeringNodeMinRot
            refTrans = self.steeringNodeMinTransX
            refRot = self.steeringNodeMinRotY
        end

        local steeringValue = 0
        if refAngle ~ = 0 then
            steeringValue = steeringAngle / refAngle
        end

        if self.steeringNodeMinTransX ~ = nil then
            local _, sny, snz = getTranslation( self.steeringNode)
            local snx = refTrans * steeringValue
            setTranslation( self.steeringNode, snx, sny, snz)
        end

        if self.steeringNodeMinRotY ~ = nil then
            local rotX, _, rotZ = getRotation( self.steeringRotNode or self.steeringNode)
            local rotY = refRot * steeringValue
            setRotation( self.steeringRotNode or self.steeringNode, rotX, rotY, rotZ)
        end
    end

    for i = 1 , # self.fenders do
        local fender = self.fenders[i]

        local angleDif = 0
        if steeringAngle > fender.rotMax then
            angleDif = fender.rotMax - steeringAngle
        elseif steeringAngle < fender.rotMin then
                angleDif = fender.rotMin - steeringAngle
            end

            setRotation(fender.node, 0 , angleDif, 0 )
        end
    end

```