## WheelVisualPartTire

**Description**

> Visual tire that handles the tire deformation

**Parent**

> [WheelVisualPart](?version=script&category=93&class=912)

**Functions**

- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setNode](#setnode)
- [update](#update)

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlObject |
|-----|-----------|
| any | key       |

**Code**

```lua
function WheelVisualPartTire:loadFromXML(xmlObject, key)
    if not WheelVisualPartTire:superClass().loadFromXML( self , xmlObject, key) then
        return false
    end

    self.maxDeformation = xmlObject:getValue(key .. "#maxDeformation" , 0 )
    self.initialDeformation = xmlObject:getValue(key .. "#initialDeformation" , math.min( 0.04 , self.maxDeformation * 0.6 ))

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | name        |
|-----|-------------|
| any | visualWheel |
| any | linkNode    |
| any | customMt    |

**Code**

```lua
function WheelVisualPartTire.new(name, visualWheel, linkNode, customMt)
    local self = WheelVisualPart.new(name, visualWheel, linkNode, WheelVisualPartTire _mt)

    self.deformation = 0
    self.derformationPrevDirty = false

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
| any | name   |

**Code**

```lua
function WheelVisualPartTire.registerXMLPaths(schema, key, name)
    WheelVisualPart.registerXMLPaths(schema, key, name)

    schema:register(XMLValueType.FLOAT, key .. "#maxDeformation" , "Max.deformation" , 0 )
    schema:register(XMLValueType.FLOAT, key .. "#initialDeformation" , "Tire deformation at initial compression value" , "min.0.04 and max.60% of the deformation" )

    schema:register(XMLValueType.BOOL, key .. "#hasMudMesh" , "Tire has a mud mesh included" , false )
end

```

### setNode

**Description**

**Definition**

> setNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function WheelVisualPartTire:setNode(node)
    WheelVisualPartTire:superClass().setNode( self , node)

    self.tireNodes = { }
    if getHasClassId( self.node, ClassIds.SHAPE) and(getHasShaderParameter( self.node, "morphPos" ) or getHasShaderParameter( self.node, "morphPosition" )) then
        table.insert( self.tireNodes, self.node)
    end

    I3DUtil.iterateRecursively(node, function (subNode)
        if getHasClassId(subNode, ClassIds.SHAPE) and(getHasShaderParameter(subNode, "morphPos" ) or getHasShaderParameter(subNode, "morphPosition" )) then
            table.insert( self.tireNodes, subNode)
        end
    end )

    for _, tireNode in ipairs( self.tireNodes) do
        if getHasShaderParameter(tireNode, "morphPos" ) then
            local x, y, z, _ = getShaderParameter(tireNode, "morphPos" )
            setShaderParameter(tireNode, "morphPos" , nil , nil , nil , 0 , false )
            setShaderParameter(tireNode, "prevMorphPos" , x, y, z, 0 , false )
        elseif getHasShaderParameter(tireNode, "morphPosition" ) then -- support for old fs22 tires with old vehicle shader
                local sx, sy, sz, _ = getShaderParameter(tireNode, "morphPosition" )
                setShaderParameter(tireNode, "morphPos" , sx, sy, sz, 0 , false )
                setShaderParameter(tireNode, "prevMorphPos" , sx, sy, sz, 0 , false )
            end
        end
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
function WheelVisualPartTire:update(x, y, z, xDrive, suspensionLength, steeringAngle, changed)
    if self.node ~ = nil then
        if Platform.gameplay.wheelVisualPressure then
            local deformation = math.clamp( self.initialDeformation - suspensionLength, 0 , self.maxDeformation)
            local prevDeformation, curDeformation

            if math.abs(deformation - self.deformation) > Platform.gameplay.wheelVisualPressureUpdateThreshold then
                prevDeformation = self.deformation
                curDeformation = deformation

                self.deformation = deformation
                self.derformationPrevDirty = true

                changed = true
            end

            -- one frame delayed we update prev deformation to match cur deformation(TAA)
            if curDeformation = = nil and self.derformationPrevDirty then
                prevDeformation = self.deformation
                curDeformation = self.deformation

                self.derformationPrevDirty = false
            end

            if curDeformation ~ = nil then
                for _, tireNode in ipairs( self.tireNodes) do
                    setShaderParameter(tireNode, "morphPos" , nil , nil , nil , curDeformation, false )
                    setShaderParameter(tireNode, "prevMorphPos" , nil , nil , nil , prevDeformation, false )
                end
            end

            suspensionLength = suspensionLength + deformation
        end
    end

    return changed, suspensionLength
end

```