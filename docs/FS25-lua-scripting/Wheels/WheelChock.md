## WheelChock

**Description**

> Handles loading and placement of wheel chocks below wheels

**Functions**

- [delete](#delete)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onI3DLoaded](#oni3dloaded)
- [registerXMLPaths](#registerxmlpaths)
- [update](#update)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function WheelChock:delete()
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
function WheelChock:loadFromXML(xmlObject, key)
    local vehicle = self.wheel.vehicle

    self.filename = xmlObject:getValue(key .. "#filename" , "$data/shared/assets/wheelChocks/wheelChock01.i3d" )
    self.filename = Utils.getFilename( self.filename, self.wheel.baseDirectory)
    if self.filename = = nil then
        xmlObject:xmlWarning(key .. "#filename" , "Invalid filename given for wheel chock" )
            return false
        end

        self.parkingNode = xmlObject:getValue(key .. "#parkingNode" , nil , vehicle.components, vehicle.i3dMappings)
        self.scale = xmlObject:getValue(key .. "#scale" , "1 1 1" , true )
        self.isInverted = xmlObject:getValue(key .. "#isInverted" , false )
        self.isParked = xmlObject:getValue(key .. "#isParked" , false )

        self.offset = xmlObject:getValue(key .. "#offset" , "0 0 0" , true )

        local material = VehicleMaterial.new( self.wheel.baseDirectory)
        if material:loadFromXML(xmlObject, key, self.wheel.vehicle.customEnvironment) then
            self.material = material
        end

        vehicle:onLoadWheelChockFromXML( self , xmlObject, key)

        self.sharedLoadRequestId = vehicle:loadSubSharedI3DFile( self.filename, false , false , self.onI3DLoaded, self )

        return true
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | wheel    |
|-----|----------|
| any | customMt |

**Code**

```lua
function WheelChock.new(wheel, customMt)
    local self = setmetatable( { } , customMt or WheelChock _mt)

    self.wheel = wheel

    self.isInParkingPosition = false
    self.wheelRadiusOffset = 0

    return self
end

```

### onI3DLoaded

**Description**

> Called when wheel chock i3d was loaded

**Definition**

> onI3DLoaded(integer i3dNode, table args, )

**Arguments**

| integer | i3dNode | i3dNode of wheel chock |
|---------|---------|------------------------|
| table   | args    | arguments              |
| any     | args    |                        |

**Code**

```lua
function WheelChock:onI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local _
        self.node = getChildAt(i3dNode, 0 )
        local posRefNode = I3DUtil.indexToObject( self.node, getUserAttribute( self.node, "posRefNode" ))
        if posRefNode ~ = nil then
            _, self.height, self.zOffset = localToLocal(posRefNode, self.node, 0 , 0 , 0 )
            self.height = self.height * self.scale[ 2 ]
            self.zOffset = self.zOffset * self.scale[ 3 ]

            setScale( self.node, self.scale[ 1 ], self.scale[ 2 ], self.scale[ 3 ])

            self.parkedNode = I3DUtil.indexToObject( self.node, getUserAttribute( self.node, "parkedNode" ))
            self.linkedNode = I3DUtil.indexToObject( self.node, getUserAttribute( self.node, "linkedNode" ))

            if self.material ~ = nil then
                self.material:apply( self.node, "wheelChock_main_mat" )
            end

            self:update()
        else
                Logging.warning( "Missing 'posRefNode'-userattribute for wheel-chock '%s'!" , self.filename)
                end

                delete(i3dNode)
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
function WheelChock.registerXMLPaths(schema, key)
    schema:addDelayedRegistrationPath(key, "WheelChock" )

    schema:register(XMLValueType.STRING, key .. "#filename" , "Path to wheel chock i3d" , "$data/shared/assets/wheelChocks/wheelChock01.i3d" )
    schema:register(XMLValueType.VECTOR_SCALE, key .. "#scale" , "Scale" , "1 1 1" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#parkingNode" , "Parking node" )
    schema:register(XMLValueType.BOOL, key .. "#isInverted" , "Is inverted(In front or back of the wheel)" , false )
    schema:register(XMLValueType.BOOL, key .. "#isParked" , "Default is parked" , false )
    schema:register(XMLValueType.VECTOR_TRANS, key .. "#offset" , "Translation offset" , "0 0 0" )

    VehicleMaterial.registerXMLPaths(schema, key)
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | isInParkingPosition |
|-----|---------------------|

**Code**

```lua
function WheelChock:update(isInParkingPosition)
    if self.node = = nil then
        return
    end

    if isInParkingPosition = = nil then
        isInParkingPosition = self.isInParkingPosition
    end

    if not self.wheel.vehicle:getIsWheelChockAllowed( self ) then
        isInParkingPosition = true
    end

    self.isInParkingPosition = isInParkingPosition

    if isInParkingPosition then
        if self.parkingNode ~ = nil then
            setTranslation( self.node, 0 , 0 , 0 )
            setRotation( self.node, 0 , 0 , 0 )
            link( self.parkingNode, self.node)
            setVisibility( self.node, true )
        else
                setVisibility( self.node, false )
            end
        else
                setVisibility( self.node, true )
                setScale( self.node, 1 , 1 , 1 )
                local wheel = self.wheel

                local radiusChockHeightOffset = math.max(wheel.physics.radius - self.wheelRadiusOffset - self.height, 0.01 )
                local angle = math.acos(radiusChockHeightOffset / wheel.physics.radius)
                local zWheelIntersection = wheel.physics.radius * math.sin(angle)
                local zChockOffset = - zWheelIntersection - self.zOffset

                link(wheel.node, self.node)

                local _, yRot, _ = localRotationToLocal(getParent(wheel.repr), wheel.node, getRotation(wheel.repr))
                if self.isInverted then
                    yRot = yRot + math.pi
                end
                setRotation( self.node, 0 , yRot, 0 )

                local dirX, dirY, dirZ = localDirectionToLocal( self.node, wheel.node, 0 , 0 , 1 )
                local normX, normY, normZ = localDirectionToLocal( self.node, wheel.node, 1 , 0 , 0 )

                local posX, posY, posZ = localToLocal(wheel.driveNode, wheel.node, 0 , 0 , 0 )
                posX = posX + normX * self.offset[ 1 ] + dirX * (zChockOffset + self.offset[ 3 ])
                posY = posY + normY * self.offset[ 1 ] + dirY * (zChockOffset + self.offset[ 3 ]) - wheel.physics.radius + self.wheelRadiusOffset + self.offset[ 2 ]
                posZ = posZ + normZ * self.offset[ 1 ] + dirZ * (zChockOffset + self.offset[ 3 ])

                setTranslation( self.node, posX, posY, posZ)
                setScale( self.node, self.scale[ 1 ], self.scale[ 2 ], self.scale[ 3 ])
            end

            if self.parkedNode ~ = nil then
                setVisibility( self.parkedNode, isInParkingPosition)
            end

            if self.linkedNode ~ = nil then
                setVisibility( self.linkedNode, not isInParkingPosition)
            end

            return true
        end

```