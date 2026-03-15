## WheelVisual

**Description**

> Represents a visual wheel

**Functions**

- [addShallowWaterObstacle](#addshallowwaterobstacle)
- [delete](#delete)
- [getAdditionalMass](#getadditionalmass)
- [getIsTireInverted](#getistireinverted)
- [getShallowWaterParameters](#getshallowwaterparameters)
- [getTireNode](#gettirenode)
- [getWidthAndOffset](#getwidthandoffset)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [postLoad](#postload)
- [registerXMLPaths](#registerxmlpaths)
- [removeShallowWaterObstacle](#removeshallowwaterobstacle)
- [setConnectedWheel](#setconnectedwheel)
- [update](#update)

### addShallowWaterObstacle

**Description**

**Definition**

> addShallowWaterObstacle()

**Code**

```lua
function WheelVisual:addShallowWaterObstacle()
    if g_currentMission.shallowWaterSimulation = = nil then
        return
    end

    if self.vehicle.propertyState = = VehiclePropertyState.SHOP_CONFIG then
        return -- avoid interference with water planes while in shop under the map
        end

        if self.wheel ~ = nil then
            self.shallowWaterRotationNode = self.wheel.driveNodeDirectionNode
        else
                self.shallowWaterRotationNode = createTransformGroup( "shallowWaterRotationNode" )
                link(getParent( self.linkNode), self.shallowWaterRotationNode)
                setWorldTranslation( self.shallowWaterRotationNode, getWorldTranslation( self.node))
                setWorldRotation( self.shallowWaterRotationNode, getWorldRotation( self.node))
            end

            self.shallowWaterObstacle = g_currentMission.shallowWaterSimulation:addObstacle( self.node, self.width, self.radius * 2 , self.radius * 1.75 , self.getShallowWaterParameters, self )
        end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function WheelVisual:delete()
    for _, visualPart in ipairs( self.visualParts) do
        visualPart:delete()
    end

    self:removeShallowWaterObstacle()

    delete( self.node)
end

```

### getAdditionalMass

**Description**

**Definition**

> getAdditionalMass()

**Code**

```lua
function WheelVisual:getAdditionalMass()
    local additionalMass = 0
    for _, visualPart in ipairs( self.visualParts) do
        additionalMass = additionalMass + visualPart:getMass()
    end

    return additionalMass
end

```

### getIsTireInverted

**Description**

**Definition**

> getIsTireInverted()

**Code**

```lua
function WheelVisual:getIsTireInverted()
    for _, visualPart in ipairs( self.visualParts) do
        if visualPart:isa( WheelVisualPartTire ) then
            return self.isInverted
        end
    end

    return false
end

```

### getShallowWaterParameters

**Description**

**Definition**

> getShallowWaterParameters()

**Code**

```lua
function WheelVisual:getShallowWaterParameters()
    local velocity = self.vehicle.lastSignedSpeed * 1000

    local ox, oz = 0 , 0
    -- add random factor if wheel is slipping
        if self.wheel.physics ~ = nil then
            local slip = self.wheel.physics.netInfo.slip
            if slip > 0.1 then
                ox, oz = math.random() * 2 - 1 * slip, math.random() * 2 - 1 * slip
            end
        end

        -- if wheel is not slipping add random factor if it is moving
            if ox = = 0 and math.abs(velocity) > 0.27 then
                ox, oz = math.random() * 2 - 1 , math.random() * 2 - 1
            end

            local dx, _, dz = localDirectionToWorld( self.shallowWaterRotationNode, 0 , 0 , 1 )
            local yRot = MathUtil.getYRotationFromDirection(dx, dz)
            dx, dz = dx * velocity, dz * velocity
            return dx + ox, dz + oz, yRot
        end

```

### getTireNode

**Description**

**Definition**

> getTireNode()

**Code**

```lua
function WheelVisual:getTireNode()
    for _, visualPart in ipairs( self.visualParts) do
        if visualPart:isa( WheelVisualPartTire ) then
            return visualPart.node
        end
    end

    return nil
end

```

### getWidthAndOffset

**Description**

**Definition**

> getWidthAndOffset()

**Code**

```lua
function WheelVisual:getWidthAndOffset()
    local offsetX, _, _ = getTranslation( self.node)
    for _, visualPart in ipairs( self.visualParts) do
        if visualPart:isa( WheelVisualPartTire ) then
            return self.width, offsetX + ( self.isLeft and visualPart.offset or - visualPart.offset)
        end
    end

    return self.width, offsetX
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlObject |
|-----|-----------|

**Code**

```lua
function WheelVisual:loadFromXML(xmlObject)
    if xmlObject.externalXMLFile ~ = nil then
        self.externalXMLFilename = xmlObject.externalXMLFile.filename
    end
    self.externalConfigId = xmlObject.externalConfigId

    self.width = xmlObject:getValue( ".physics#width" , self.width)
    self.radius = xmlObject:getValue( ".physics#radius" , self.radius)

    local widthAndDiam = xmlObject:getValue( ".outerRim(0)#widthAndDiam" , nil , true )
    if widthAndDiam ~ = nil then
        self.rimDiameter = widthAndDiam[ 2 ]
    end

    local rimMaterialTemplateName = xmlObject:getValue( "#rimMaterialTemplateName" )
    if rimMaterialTemplateName ~ = nil then
        local rimMaterial = VehicleMaterial.new()
        if rimMaterial:setTemplateName(rimMaterialTemplateName, nil , self.vehicle.customEnvironment) then
            self.rimMaterial = rimMaterial
        end
    end

    for xmlName, data in pairs( WheelVisual.PARTS) do
        local i = 0
        while true do
            local key = string.format( ".%s(%d)" , xmlName, i)
            local xmlFile, _ = xmlObject:getXMLFileAndPropertyKey(key)
            if xmlFile = = nil then
                break
            end

            local visualPart = data.class.new(xmlName, self , self.node)
            if visualPart:loadFromXML(xmlObject, key) then
                if xmlName ~ = "innerRim" and xmlName ~ = "additional" then
                    visualPart.offset = visualPart.offset + self.rimOffset
                end

                table.insert( self.visualParts, visualPart)
            end

            i = i + 1
        end
    end

    return # self.visualParts > 0
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | wheel         |
| any | linkNode      |
| any | isLeft        |
| any | rimOffset     |
| any | baseDirectory |
| any | customMt      |

**Code**

```lua
function WheelVisual.new(vehicle, wheel, linkNode, isLeft, rimOffset, baseDirectory, customMt)
    local self = setmetatable( { } , customMt or WheelVisual _mt)

    self.vehicle = vehicle
    self.wheel = wheel
    self.isLeft = isLeft
    self.rimOffset = rimOffset
    self.baseDirectory = baseDirectory

    self.width = 0.5
    self.radius = 0.5
    self.mass = 0

    self.linkNode = linkNode
    self.node = createTransformGroup( "visualWheel" )
    link(linkNode, self.node)

    self.visualParts = { }

    return self
end

```

### postLoad

**Description**

**Definition**

> postLoad()

**Code**

```lua
function WheelVisual:postLoad()
    for _, visualPart in ipairs( self.visualParts) do
        if self.rimMaterial ~ = nil then
            if visualPart.name = = "innerRim" or visualPart.name = = "outerRim" then
                self.rimMaterial:apply(visualPart.node, visualPart:getDefaultMaterialSlotName())
            end
        end

        visualPart:postLoad()
    end
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
function WheelVisual.registerXMLPaths(schema, key)
    schema:register(XMLValueType.FLOAT, key .. ".physics#radius" , "Wheel radius" , 0.5 )
    schema:register(XMLValueType.FLOAT, key .. ".physics#width" , "Wheel width" , 0.6 )

    schema:register(XMLValueType.STRING, key .. "#rimMaterialTemplateName" , "Material template to apply to the inner and outer rim" )

    for xmlName, data in pairs( WheelVisual.PARTS) do
        data.class.registerXMLPaths(schema, key .. "." .. xmlName .. "(?)" , data.name)
    end
end

```

### removeShallowWaterObstacle

**Description**

**Definition**

> removeShallowWaterObstacle()

**Code**

```lua
function WheelVisual:removeShallowWaterObstacle()
    if self.shallowWaterObstacle ~ = nil then
        g_currentMission.shallowWaterSimulation:removeObstacle( self.shallowWaterObstacle)
        self.shallowWaterObstacle = nil
    end
end

```

### setConnectedWheel

**Description**

**Definition**

> setConnectedWheel()

**Arguments**

| any | connectedVisualWheel |
|-----|----------------------|
| any | offset               |

**Code**

```lua
function WheelVisual:setConnectedWheel(connectedVisualWheel, offset)
    self.connectedVisualWheel = connectedVisualWheel
    self.connectedVisualWheelOffset = offset

    local otherX, _, _ = getTranslation(connectedVisualWheel.node)

    local invertOffset = offset < 0

    offset = offset + self.width * 0.5 + connectedVisualWheel.width * 0.5

    if not self.isLeft then
        offset = - offset
    end

    if invertOffset then
        offset = - offset
    end

    self.connectedVisualWheelOffsetDirection = math.sign(offset)

    setTranslation( self.node, otherX + offset, 0 , 0 )
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
function WheelVisual:update(x, y, z, xDrive, suspensionLength, steeringAngle, changed)
    for _, visualPart in ipairs( self.visualParts) do
        if visualPart.update ~ = nil then
            changed, suspensionLength = visualPart:update(x, y, z, xDrive, suspensionLength, steeringAngle, changed)
        end
    end

    return changed, suspensionLength
end

```