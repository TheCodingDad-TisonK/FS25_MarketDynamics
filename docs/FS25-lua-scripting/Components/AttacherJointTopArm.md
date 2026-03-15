## AttacherJointTopArm

**Description**

> Class for attacher joint top arms

**Functions**

- [delete](#delete)
- [finalize](#finalize)
- [loadFromVehicleXML](#loadfromvehiclexml)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onFinished](#onfinished)
- [onI3DLoaded](#oni3dloaded)
- [registerVehicleXMLPaths](#registervehiclexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setCallback](#setcallback)
- [setIsActive](#setisactive)
- [update](#update)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AttacherJointTopArm:delete()
    if self.node ~ = nil then
        delete( self.node)
        self.node = nil
    end

    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
        self.sharedLoadRequestId = nil
    end
end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function AttacherJointTopArm:finalize()
    if self.translationNode ~ = nil and self.referenceNodeTranslation ~ = nil then
        self.referenceDistance = calcDistanceFrom( self.referenceNodeTranslation, self.translationNode)

        self.translationDefault = { getTranslation( self.translationNode) }
    end

    if self.scaleNode ~ = nil and self.referenceNodeScale ~ = nil then
        local _, _, zOffset = localToLocal( self.referenceNodeScale, self.scaleNode, 0 , 0 , 0 )
        self.scaleReferenceDistance = zOffset
    end
end

```

### loadFromVehicleXML

**Description**

**Definition**

> loadFromVehicleXML()

**Arguments**

| any | vehicle |
|-----|---------|
| any | key     |

**Code**

```lua
function AttacherJointTopArm.loadFromVehicleXML(vehicle, key)
    local topArm

    local baseNode = vehicle.xmlFile:getValue(key .. "#baseNode" , nil , vehicle.components, vehicle.i3dMappings)
    local filename = vehicle.xmlFile:getValue(key .. "#filename" , nil , vehicle.baseDirectory)
    if baseNode ~ = nil and filename ~ = nil then
        XMLUtil.checkDeprecatedXMLElements(vehicle.xmlFile, key .. "#color" , key .. "#materialTemplateName" ) -- FS22 to FS25
        XMLUtil.checkDeprecatedXMLElements(vehicle.xmlFile, key .. "#color2" , key .. "#materialTemplateName2" ) -- FS22 to FS25
        XMLUtil.checkDeprecatedXMLElements(vehicle.xmlFile, key .. "#decalColor" , key .. "#decalMaterialTemplateName" ) -- FS22 to FS25

        if string.contains(filename, ".i3d" ) then
            Logging.xmlWarning(vehicle.xmlFile, "Top arm filename is referring to the i3d file.Please use the xml file instead. (%s)" , filename)
            filename = string.gsub(filename, ".i3d" , ".xml" )
        end

        for oldName, newName in pairs( AttacherJointTopArm.RENAMED_UPPER_LINKS) do
            if filename = = string.format( "data/shared/assets/upperLinks/%s.xml" , oldName) then
                Logging.xmlWarning(vehicle.xmlFile, "Top arm has been renamed from '%s' to '%s' in '%s' (Names now include type, diameter and min.length)" , oldName, newName, key)
                filename = string.format( "data/shared/assets/upperLinks/%s.xml" , newName)
            end
        end

        topArm = AttacherJointTopArm.new(vehicle)
        if not topArm:loadFromXML(baseNode, filename, vehicle.baseDirectory) then
            topArm = nil
        end
    else
            local rotationNode = vehicle.xmlFile:getValue(key .. "#rotationNode" , nil , vehicle.components, vehicle.i3dMappings)
            if rotationNode ~ = nil then
                topArm = AttacherJointTopArm.new(vehicle)
                topArm.node = rotationNode
                topArm.translationNode = vehicle.xmlFile:getValue(key .. "#translationNode" , nil , vehicle.components, vehicle.i3dMappings)
                topArm.referenceNodeTranslation = vehicle.xmlFile:getValue(key .. "#referenceNode" , nil , vehicle.components, vehicle.i3dMappings)

                topArm:finalize()
            end
        end

        if topArm ~ = nil then
            topArm.zScale = vehicle.xmlFile:getValue(key .. "#zScale" , - 1 )
            topArm.toggleVisibility = vehicle.xmlFile:getValue(key .. "#toggleVisibility" , topArm.toggleVisibility)
            topArm.useMountArm = vehicle.xmlFile:getValue(key .. "#useMountArm" , topArm.useMountArm)
            topArm.mountArmRotation = vehicle.xmlFile:getValue(key .. "#mountArmRotation" , nil , true )
            topArm.useBrandDecal = vehicle.xmlFile:getValue(key .. "#useBrandDecal" , topArm.useBrandDecal)

            topArm.material = vehicle.xmlFile:getValue(key .. "#materialTemplateName" , nil , vehicle.customEnvironment)
            topArm.material2 = vehicle.xmlFile:getValue(key .. "#materialTemplateName2" , nil , vehicle.customEnvironment)
            topArm.decalMaterial = vehicle.xmlFile:getValue(key .. "#decalMaterialTemplateName" , nil , vehicle.customEnvironment)
            topArm.useMainColor = vehicle.xmlFile:getValue(key .. "#secondPartUseMainColor" , true )

            ObjectChangeUtil.loadObjectChangeFromXML(vehicle.xmlFile, key, topArm.changeObjects, vehicle.components, vehicle)
            ObjectChangeUtil.setObjectChanges(topArm.changeObjects, false , vehicle, vehicle.setMovingToolDirty, true )
        end

        return topArm
    end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | linkNode      |
|-----|---------------|
| any | xmlFilename   |
| any | baseDirectory |

**Code**

```lua
function AttacherJointTopArm:loadFromXML(linkNode, xmlFilename, baseDirectory)
    self.xmlFile = XMLFile.loadIfExists( "AttacherJointTopArm" , xmlFilename, AttacherJointTopArm.xmlSchema)

    if self.xmlFile = = nil then
        if self.vehicle ~ = nil then
            Logging.xmlWarning( self.vehicle.xmlFile, "Unable to load top arm from xml '%s'" , xmlFilename)
        else
                Logging.warning( "Unable to load top arm from xml '%s'" , xmlFilename)
            end

            self:onFinished( false )
            return false
        end

        local filename = self.xmlFile:getValue( "topArm.filename" , nil , baseDirectory)
        if filename = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing top arm i3d filename!" )

            self:onFinished( false )
            return false
        end

        self.filename = filename
        self.linkNode = linkNode

        if self.vehicle ~ = nil then
            self.sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( self.filename, false , false , self.onI3DLoaded, self , nil )
        else
                self.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync( self.filename, false , false , self.onI3DLoaded, self , nil )
            end

            return true
        end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | customMt |

**Code**

```lua
function AttacherJointTopArm.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or AttacherJointTopArm _mt)

    self.vehicle = vehicle
    self.components = { }
    self.i3dMappings = { }

    self.zScale = - 1
    self.toggleVisibility = false
    self.useMountArm = true
    self.useBrandDecal = true
    self.changeObjects = { }

    return self
end

```

### onFinished

**Description**

**Definition**

> onFinished()

**Arguments**

| any | success |
|-----|---------|

**Code**

```lua
function AttacherJointTopArm:onFinished(success)
    if self.xmlFile ~ = nil then
        self.xmlFile:delete()
        self.xmlFile = nil
    end

    self:finalize()

    if self.callback ~ = nil then
        if self.callbackTarget ~ = nil then
            self.callback( self.callbackTarget, success)
        else
                self.callback(success)
            end
        end
    end

```

### onI3DLoaded

**Description**

**Definition**

> onI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function AttacherJointTopArm:onI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        I3DUtil.loadI3DComponents(i3dNode, self.components)
        I3DUtil.loadI3DMapping( self.xmlFile, "topArm" , self.components, self.i3dMappings)

        self.node = self.xmlFile:getValue( "topArm.rootNode#node" , "0" , self.components, self.i3dMappings)
        if self.node ~ = nil then
            link( self.linkNode, self.node)
            setTranslation( self.node, 0 , 0 , 0 )
            setRotation( self.node, 0 , self.zScale < 0 and math.pi or 0 , 0 )

            self.translationNode = self.xmlFile:getValue( "topArm.translation#node" , nil , self.components, self.i3dMappings)
            self.referenceNodeTranslation = self.xmlFile:getValue( "topArm.translation#referenceNode" , nil , self.components, self.i3dMappings)

            self.scaleNode = self.xmlFile:getValue( "topArm.scale#node" , nil , self.components, self.i3dMappings)
            self.referenceNodeScale = self.xmlFile:getValue( "topArm.scale#referenceNode" , nil , self.components, self.i3dMappings)

            self.brandDecal = self.xmlFile:getValue( "topArm.brandDecal#node" , nil , self.components, self.i3dMappings)
            if not self.useBrandDecal and self.brandDecal ~ = nil then
                setVisibility( self.brandDecal, false )
            end

            self.mountArmNode = self.xmlFile:getValue( "topArm.mountArm#node" , nil , self.components, self.i3dMappings)
            if self.mountArmNode ~ = nil then
                if not self.useMountArm then
                    setVisibility( self.mountArmNode, false )
                    self.mountArmNode = nil
                else
                        self.mountArmRotationDefault = { getRotation( self.mountArmNode) }
                    end
                end

                -- on dark colors we use a white decal and on bright colors a black decal
                if self.decalMaterial = = nil and self.material ~ = nil then
                    local brightness = self.material:getBrightness()
                    if brightness ~ = nil then
                        brightness = (brightness > 0.075 and 1 ) or 0

                        local decalMaterial = VehicleMaterial.new()
                        decalMaterial:setColor( 1 - brightness, 1 - brightness, 1 - brightness)
                    end
                end

                if self.material ~ = nil then
                    self.material:apply( self.node, "upperLink_main_mat" )
                end

                if self.material2 ~ = nil then
                    self.material2:apply( self.node, "upperLink_base_mat" )
                end

                if self.useMainColor then
                    if self.material ~ = nil then
                        self.material:apply( self.node, "upperLink_head_mat" )
                    end
                else
                        if self.material2 ~ = nil then
                            self.material2:apply( self.node, "upperLink_head_mat" )
                        end
                    end

                    if self.decalMaterial ~ = nil then
                        self.decalMaterial:apply( self.node, "upperLink_decal_mat" )
                    end
                end

                delete(i3dNode)
            end

            if self.node ~ = nil then
                self:setIsActive( false )
            end

            self:onFinished( self.node ~ = nil )
        end

```

### registerVehicleXMLPaths

**Description**

**Definition**

> registerVehicleXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function AttacherJointTopArm.registerVehicleXMLPaths(schema, baseKey)
    schema:register(XMLValueType.FILENAME, baseKey .. "#filename" , "Path to top arm i3d file" )
    schema:register(XMLValueType.NODE_INDEX, baseKey .. "#baseNode" , "Link node for upper link" )
        schema:register(XMLValueType.INT, baseKey .. "#zScale" , "Inverts top arm direction" , 1 )
        schema:register(XMLValueType.BOOL, baseKey .. "#toggleVisibility" , "Top arm will be hidden on detach" , false )
        schema:register(XMLValueType.BOOL, baseKey .. "#useMountArm" , "Defines if the mount arm is visible or not" , true )
            schema:register(XMLValueType.VECTOR_ROT, baseKey .. "#mountArmRotation" , "Defines a custom mount arm rotation while no tool is attached" )

                schema:register(XMLValueType.VEHICLE_MATERIAL, baseKey .. "#materialTemplateName" , "Top arm material(applied to 'upperLink_main_mat')" )
                schema:registerAutoCompletionDataSource(baseKey .. "#materialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
                schema:register(XMLValueType.VEHICLE_MATERIAL, baseKey .. "#materialTemplateName2" , "Top arm material 2(applied to 'upperLink_base_mat')" )
                schema:registerAutoCompletionDataSource(baseKey .. "#materialTemplateName2" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
                schema:register(XMLValueType.VEHICLE_MATERIAL, baseKey .. "#decalMaterialTemplateName" , "Top arm decal color(applied to 'upperLink_decal_mat')" )
                schema:registerAutoCompletionDataSource(baseKey .. "#decalMaterialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
                schema:register(XMLValueType.BOOL, baseKey .. "#secondPartUseMainColor" , "Defines if the material 'upperLink_head_mat' uses the 'material' or 'material2' value" , true )
                    schema:register(XMLValueType.BOOL, baseKey .. "#useBrandDecal" , "Defines if the brand decal on the top arm is allowed or not" , true )

                        schema:register(XMLValueType.NODE_INDEX, baseKey .. "#rotationNode" , "Rotation node if top arm not loaded from i3d" )
                            schema:register(XMLValueType.NODE_INDEX, baseKey .. "#translationNode" , "Translation node if top arm not loaded from i3d" )
                                schema:register(XMLValueType.NODE_INDEX, baseKey .. "#referenceNode" , "Reference node if top arm not loaded from i3d" )

                                    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, baseKey)
                                end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function AttacherJointTopArm.registerXMLPaths(schema)
    schema:register(XMLValueType.FILENAME, "topArm.filename" , "Path to top arm i3d file" )
    schema:register(XMLValueType.NODE_INDEX, "topArm.rootNode#node" , "Root node of the top arm" )

    schema:register(XMLValueType.NODE_INDEX, "topArm.translation#node" , "Translating part of the top arm" )
    schema:register(XMLValueType.NODE_INDEX, "topArm.translation#referenceNode" , "Reference node at the end of the top arm" )

    schema:register(XMLValueType.NODE_INDEX, "topArm.scale#node" , "Node that is scaled" )
    schema:register(XMLValueType.NODE_INDEX, "topArm.scale#referenceNode" , "Reference node at the end of the scale part" )

    schema:register(XMLValueType.NODE_INDEX, "topArm.brandDecal#node" , "Branded decal on the top arm" )
    schema:register(XMLValueType.NODE_INDEX, "topArm.mountArm#node" , "Mount arm node that can be adjusted from the vehicle" )

    I3DUtil.registerI3dMappingXMLPaths(schema, "topArm" )
end

```

### setCallback

**Description**

**Definition**

> setCallback()

**Arguments**

| any | callback       |
|-----|----------------|
| any | callbackTarget |

**Code**

```lua
function AttacherJointTopArm:setCallback(callback, callbackTarget)
    self.callback = callback
    self.callbackTarget = callbackTarget
end

```

### setIsActive

**Description**

**Definition**

> setIsActive()

**Arguments**

| any | isActive |
|-----|----------|

**Code**

```lua
function AttacherJointTopArm:setIsActive(isActive)
    if self.mountArmNode ~ = nil and self.mountArmRotation ~ = nil then
        local rotation = isActive and self.mountArmRotationDefault or self.mountArmRotation
        setRotation( self.mountArmNode, rotation[ 1 ], rotation[ 2 ], rotation[ 3 ])
    end

    if self.toggleVisibility then
        setVisibility( self.node, isActive)
    end

    if not isActive then
        setRotation( self.node, 0 , self.zScale < 0 and math.pi or 0 , 0 )

        if self.translationDefault ~ = nil then
            setTranslation( self.translationNode, self.translationDefault[ 1 ], self.translationDefault[ 2 ], self.translationDefault[ 3 ])
        end

        if self.scaleNode ~ = nil then
            setScale( self.scaleNode, 1 , 1 , 1 )
        end
    end

    ObjectChangeUtil.setObjectChanges( self.changeObjects, isActive, self.vehicle, self.vehicle.setMovingToolDirty, true )
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt         |
|-----|------------|
| any | targetNode |

**Code**

```lua
function AttacherJointTopArm:update(dt, targetNode)
    local ax, ay, az = getWorldTranslation( self.node)
    local bx, by, bz = getWorldTranslation(targetNode)

    local dirX, dirY, dirZ = worldDirectionToLocal(getParent( self.node), bx - ax, by - ay, bz - az)

    -- different approach I) rotate actual direction of topArm by 90degree around x-axis
    local alpha = - math.pi * 0.5
    -- check if rotationNode is at back of tractor = > inverted rotation direction, could be dismissed by rotating TG in i3d
        local _, _, lz = worldToLocal( self.vehicle.rootNode, ax, ay, az)
        if lz < 0 then
            alpha = math.pi * 0.5
        end

        local dx, dy, dz = localDirectionToLocal( self.node, getParent( self.node), 0 , 0 , 1 )
        local upX = dx
        local upY = math.cos(alpha) * dy - math.sin(alpha) * dz
        local upZ = math.sin(alpha) * dy + math.cos(alpha) * dz

        setDirection( self.node, dirX, dirY, dirZ, upX, upY, upZ)

        if self.referenceDistance ~ = nil then
            local distance = MathUtil.vector3Length(dirX, dirY, dirZ)
            local translation = (distance - self.referenceDistance)
            setTranslation( self.translationNode, 0 , 0 , translation)

            if self.scaleReferenceDistance ~ = nil then
                setScale( self.scaleNode, 1 , 1 , math.max((translation + self.scaleReferenceDistance) / self.scaleReferenceDistance, 0 ))
            end
        end
    end

```