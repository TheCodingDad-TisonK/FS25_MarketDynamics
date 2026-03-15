## WheelVisualPartConnector

**Description**

> Visual tire that handles the tire deformation

**Parent**

> [WheelVisualPart](?version=script&category=93&class=911)

**Functions**

- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setNode](#setnode)

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
function WheelVisualPartConnector:loadFromXML(xmlObject, key)
    if not WheelVisualPartConnector:superClass().loadFromXML( self , xmlObject, key) then
        return false
    end

    self.useWidthAndDiam = xmlObject:getValue(key .. "#useWidthAndDiam" , false )
    self.usePosAndScale = xmlObject:getValue(key .. "#usePosAndScale" , false )

    self.diameter = xmlObject:getValue(key .. "#diameter" )
    self.additionalOffset = xmlObject:getValue(key .. "#offset" , 0 )
    self.hookOffset = xmlObject:getValue(key .. "#hookOffset" )
    self.width = xmlObject:getValue(key .. "#width" )

    self.startPos = xmlObject:getValue(key .. "#startPos" )
    self.endPos = xmlObject:getValue(key .. "#endPos" )
    self.startPosOffset = xmlObject:getValue(key .. "#startPosOffset" )
    self.endPosOffset = xmlObject:getValue(key .. "#endPosOffset" )

    self.uniformScale = xmlObject:getValue(key .. "#uniformScale" )

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
function WheelVisualPartConnector.new(name, visualWheel, linkNode, customMt)
    local self = WheelVisualPart.new(name, visualWheel, linkNode, WheelVisualPartConnector _mt)

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
function WheelVisualPartConnector.registerXMLPaths(schema, key, name)
    WheelVisualPart.registerXMLPaths(schema, key, name)

    schema:register(XMLValueType.BOOL, key .. "#useWidthAndDiam" , "Use width and diameter from connector definition" , false )
    schema:register(XMLValueType.BOOL, key .. "#usePosAndScale" , "Use position and scale from connector definition" , false )

    schema:register(XMLValueType.FLOAT, key .. "#diameter" , "Diameter for shader(inch)" )
        schema:register(XMLValueType.FLOAT, key .. "#offset" , "Additional connector X offset(m)" , 0 )
        schema:register(XMLValueType.FLOAT, key .. "#hookOffset" , "Offset to the hook from the end of the connector outer rim(inch)" , "width of additional wheel" )
        schema:register(XMLValueType.FLOAT, key .. "#width" , "Width for shader(inch)" )
            schema:register(XMLValueType.FLOAT, key .. "#startPos" , "Start pos for shader(inch)" )
                schema:register(XMLValueType.FLOAT, key .. "#endPos" , "End pos for shader(inch)" )
                    schema:register(XMLValueType.FLOAT, key .. "#startPosOffset" , "Start pos offset for shader(inch) (will be added on top if it's automatically calculated)" )
                        schema:register(XMLValueType.FLOAT, key .. "#endPosOffset" , "End pos offset for shader(inch) (will be added on top if it's automatically calculated)" )
                            schema:register(XMLValueType.FLOAT, key .. "#uniformScale" , "Uniform scale for shader" )
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
function WheelVisualPartConnector:setNode(node)
    WheelVisualPartConnector:superClass().setNode( self , node)

    local connectedWheel = self.visualWheel.connectedVisualWheel
    if connectedWheel ~ = nil then
        setTranslation(node, localToLocal(connectedWheel.node, getParent(node), 0 , 0 , 0 ))

        local offsetDirection = self.visualWheel.connectedVisualWheelOffsetDirection
        local wheelWidthInch = MathUtil.mToInch( self.visualWheel.width)
        local connectedWheelOffsetInch = MathUtil.mToInch( self.visualWheel.connectedVisualWheelOffset)
        local connectedWheelWidthInch = MathUtil.mToInch(connectedWheel.width)

        if not self.useWidthAndDiam then
            self:setShaderParameterRec(node, "connectorPos" , 0 , wheelWidthInch + ( self.startPosOffset or 0 ), connectedWheelOffsetInch + ( self.endPosOffset or 0 ), self.hookOffset or wheelWidthInch)
            self:setShaderParameterRec(node, "widthAndDiam" , nil , self.diameter or self.visualWheel.rimDiameter or 0 , nil , nil )
        else
                local connectorOffset = offsetDirection * ((( 0.5 * connectedWheelWidthInch + 0.5 * connectedWheelOffsetInch) * 0.0254 ) + self.additionalOffset) -- in meters
                local connectorDiameter = self.diameter or self.visualWheel.rimDiameter or 0

                local x, y, z = getTranslation(node)
                setTranslation(node, x + connectorOffset, y, z)
                self:setShaderParameterRec(node, "widthAndDiam" , self.width, connectorDiameter, nil , nil )
            end

            if self.usePosAndScale then
                self:setShaderParameterRec(node, "connectorPosAndScale" , self.startPos, self.endPos, self.uniformScale, nil )
            end
        end
    end

```