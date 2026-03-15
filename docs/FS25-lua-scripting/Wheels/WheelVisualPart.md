## WheelVisualPart

**Description**

> Visual part of the wheel (tire, inner rim, outer rim, additionals)

**Functions**

- [delete](#delete)
- [getDefaultMaterialSlotName](#getdefaultmaterialslotname)
- [getHasShaderParameterRec](#gethasshaderparameterrec)
- [getMass](#getmass)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onPartI3DLoaded](#onparti3dloaded)
- [postLoad](#postload)
- [registerXMLPaths](#registerxmlpaths)
- [setNode](#setnode)
- [setShaderParameterRec](#setshaderparameterrec)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function WheelVisualPart:delete()
    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
    end
end

```

### getDefaultMaterialSlotName

**Description**

**Definition**

> getDefaultMaterialSlotName()

**Code**

```lua
function WheelVisualPart:getDefaultMaterialSlotName()
    if self.name = = "innerRim" then
        return "rim_inner_mat"
    elseif self.name = = "outerRim" then
            return "rim_outer_mat"
        elseif self.name = = "additional" then
                return "rim_additional_mat"
            elseif self.name = = "connector" then
                    return "rim_bolt_mat"
                end
            end

```

### getHasShaderParameterRec

**Description**

**Definition**

> getHasShaderParameterRec()

**Arguments**

| any | node                |
|-----|---------------------|
| any | shaderParameterName |

**Code**

```lua
function WheelVisualPart:getHasShaderParameterRec(node, shaderParameterName)
    if getHasClassId(node, ClassIds.SHAPE) then
        if getHasShaderParameter(node, "widthAndDiam" ) then
            return true
        end
    end

    local numChildren = getNumOfChildren(node)
    for i = 1 , numChildren do
        if self:getHasShaderParameterRec(getChildAt(node, i - 1 ), shaderParameterName) then
            return true
        end
    end

    return false
end

```

### getMass

**Description**

**Definition**

> getMass()

**Code**

```lua
function WheelVisualPart:getMass()
    return self.mass or 0
end

```

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
function WheelVisualPart:loadFromXML(xmlObject, key)
    self.filename = xmlObject:getValue(key .. "#filename" )
    if self.filename ~ = nil then
        self.filename = Utils.getFilename( self.filename, self.visualWheel.baseDirectory)
        if self.filename:contains( ".xml" ) then
            local visualPartXMLFile = XMLFile.load( "visualPartXML" , self.filename)
            if visualPartXMLFile ~ = nil then
                local rootName = visualPartXMLFile:getRootName()

                self.filename = visualPartXMLFile:getString(rootName .. ".file#name" )
                if self.filename ~ = nil then
                    self.filename = Utils.getFilename( self.filename, self.visualWheel.baseDirectory)
                    if self.filename = = nil then
                        Logging.xmlError(visualPartXMLFile, "Unable to load visual wheel part from xml file.Unknown i3d file." )
                        return false
                    end
                else
                        Logging.xmlError(visualPartXMLFile, "Unable to load visual wheel part from xml file.Missing file definition." )
                        return false
                    end

                    if self.visualWheel.isLeft then
                        self.indexPath = visualPartXMLFile:getString(rootName .. ".file#leftNode" )
                    else
                            self.indexPath = visualPartXMLFile:getString(rootName .. ".file#rightNode" )
                        end

                        if self.indexPath = = nil then
                            Logging.xmlError(visualPartXMLFile, "Unable to load visual wheel part from xml file.Missing node definition." )
                            return false
                        end

                        visualPartXMLFile:delete()
                    else
                            xmlObject:xmlWarning(key .. "#filename" , "Unable to load visual wheel part from xml file '%s'!" , self.filename)
                            return false
                        end
                    end

                    if self.visualWheel.isLeft then
                        self.indexPath = xmlObject:getValueAlternative(key .. "#nodeLeft" , key .. "#node" , self.indexPath)
                    else
                            self.indexPath = xmlObject:getValueAlternative(key .. "#nodeRight" , key .. "#node" , self.indexPath)
                        end

                        self.widthAndDiam = xmlObject:getValue(key .. "#widthAndDiam" , nil , true )
                        self.offset = xmlObject:getValue(key .. "#offset" , 0 )
                        self.scale = xmlObject:getValue(key .. "#scale" , nil , true )
                        self.holeScale = xmlObject:getValue(key .. "#holeScale" )

                        self.mass = xmlObject:getValue(key .. "#mass" )
                        self.isInverted = xmlObject:getValue(key .. "#isInverted" , false )

                        self.materials = { }
                        local i = 0
                        while true do
                            local materialKey = string.format( "%s.material(%d)" , key, i)
                            local materialXMLFile, _ = xmlObject:getXMLFileAndPropertyKey(materialKey)
                            if materialXMLFile = = nil then
                                break
                            end

                            local material = VehicleMaterial.new( self.visualWheel.baseDirectory)
                            if material:loadFromXML(xmlObject, materialKey, self.visualWheel.vehicle.customEnvironment) then
                                table.insert( self.materials, material)
                            end

                            i = i + 1
                        end

                        local material = VehicleMaterial.new( self.visualWheel.baseDirectory)
                        if material:loadShortFromXML(xmlObject, key, self.visualWheel.vehicle.customEnvironment) then
                            material.targetMaterialSlotName = material.targetMaterialSlotName or self:getDefaultMaterialSlotName()
                            table.insert( self.materials, material)
                        end

                        self.sharedLoadRequestId = self.visualWheel.vehicle:loadSubSharedI3DFile( self.filename, false , false , self.onPartI3DLoaded, self )

                        return true
                    end

                    return false
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
function WheelVisualPart.new(name, visualWheel, linkNode, customMt)
    local self = setmetatable( { } , customMt or WheelVisualPart _mt)

    self.name = name
    self.visualWheel = visualWheel
    self.linkNode = linkNode

    return self
end

```

### onPartI3DLoaded

**Description**

**Definition**

> onPartI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function WheelVisualPart:onPartI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local node = I3DUtil.indexToObject(i3dNode, self.indexPath)
        if node ~ = nil then
            self:setNode(node)
        end

        delete(i3dNode)
    end
end

```

### postLoad

**Description**

**Definition**

> postLoad()

**Code**

```lua
function WheelVisualPart:postLoad()
    for _, material in ipairs( self.materials) do
        material:apply( self.node)
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
| any | name   |

**Code**

```lua
function WheelVisualPart.registerXMLPaths(schema, key, name)
    schema:register(XMLValueType.STRING, key .. "#filename" , name .. " - Path to i3d file" )
    schema:register(XMLValueType.STRING, key .. "#node" , name .. " - Index in i3d file" , "0|0" )
    schema:register(XMLValueType.STRING, key .. "#nodeLeft" , name .. " - Left index in i3d file" , "0|0" )
    schema:register(XMLValueType.STRING, key .. "#nodeRight" , name .. " - Right index in i3d file" , "0|0" )
    schema:register(XMLValueType.VECTOR_ 2 , key .. "#widthAndDiam" , name .. " - Width and diameter" )
    schema:register(XMLValueType.VECTOR_SCALE, key .. "#scale" , name .. " - Scale" )
    schema:register(XMLValueType.FLOAT, key .. "#holeScale" , name .. " - Scale factor for hole in the rim(blue vertex color)" )
        schema:register(XMLValueType.FLOAT, key .. "#offset" , name .. " - Offset" , false )
        schema:register(XMLValueType.FLOAT, key .. "#mass" , name .. " - Mass" )
        schema:register(XMLValueType.BOOL, key .. "#isInverted" , name .. " - Node is inverted" , false )

        VehicleMaterial.registerXMLPaths(schema, key .. ".material(?)" )
        VehicleMaterial.registerShortXMLPaths(schema, key)
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
function WheelVisualPart:setNode(node)
    self.node = node

    link( self.linkNode, self.node)

    local direction = self.visualWheel.isLeft and 1 or - 1
    setTranslation( self.node, self.offset * direction, 0 , 0 )

    if self.scale ~ = nil then
        setScale( self.node, self.scale[ 1 ], self.scale[ 2 ], self.scale[ 3 ])
    end

    if self.widthAndDiam ~ = nil then
        if self:getHasShaderParameterRec( self.node, "widthAndDiam" ) then
            self:setShaderParameterRec( self.node, "widthAndDiam" , self.widthAndDiam[ 1 ], self.widthAndDiam[ 2 ], nil , nil )
        else
                -- convert width and diam to scale(mesh is normalized to 1 meter)
                local scaleX = MathUtil.inchToM( self.widthAndDiam[ 1 ])
                local scaleZY = MathUtil.inchToM( self.widthAndDiam[ 2 ])
                setScale( self.node, scaleX, scaleZY, scaleZY)
            end
        end

        if self.holeScale ~ = nil then
            if self:getHasShaderParameterRec( self.node, "widthAndDiam" ) then
                self:setShaderParameterRec( self.node, "widthAndDiam" , nil , nil , self.holeScale, 0 )
            end
        end

        if self.isInverted then
            setRotation( self.node, 0 , 0 , math.pi)
        end
    end

```

### setShaderParameterRec

**Description**

**Definition**

> setShaderParameterRec()

**Arguments**

| any | node                |
|-----|---------------------|
| any | shaderParameterName |
| any | x                   |
| any | y                   |
| any | z                   |
| any | w                   |

**Code**

```lua
function WheelVisualPart:setShaderParameterRec(node, shaderParameterName, x, y, z, w)
    if getHasClassId(node, ClassIds.SHAPE) then
        setShaderParameter(node, shaderParameterName, x, y, z, w, false , - 1 )
    end

    local numChildren = getNumOfChildren(node)
    for i = 1 , numChildren do
        self:setShaderParameterRec(getChildAt(node, i - 1 ), shaderParameterName, x, y, z, w)
    end
end

```