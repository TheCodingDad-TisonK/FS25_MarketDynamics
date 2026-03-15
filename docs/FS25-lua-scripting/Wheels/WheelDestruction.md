## WheelDestruction

**Description**

> Handles crop destruction and density height deformation of the wheels

**Functions**

- [destroyFruitArea](#destroyfruitarea)
- [destroySnowArea](#destroysnowarea)
- [drawAreas](#drawareas)
- [finalize](#finalize)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setIsCareWheel](#setiscarewheel)
- [smoothHeightAtPosition](#smoothheightatposition)
- [update](#update)

### destroyFruitArea

**Description**

**Definition**

> destroyFruitArea()

**Arguments**

| any | x0 |
|-----|----|
| any | z0 |
| any | x1 |
| any | z1 |
| any | x2 |
| any | z2 |

**Code**

```lua
function WheelDestruction:destroyFruitArea(x0,z0, x1,z1, x2,z2)
    FSDensityMapUtil.updateWheelDestructionArea(x0,z0, x1,z1, x2,z2)
end

```

### destroySnowArea

**Description**

**Definition**

> destroySnowArea()

**Arguments**

| any | x0 |
|-----|----|
| any | z0 |
| any | x1 |
| any | z1 |
| any | x2 |
| any | z2 |

**Code**

```lua
function WheelDestruction:destroySnowArea(x0,z0, x1,z1, x2,z2)
    local snowSystem = g_currentMission.snowSystem

    local worldSnowHeight = snowSystem.height
    local curHeight = snowSystem:getSnowHeightAtArea(x0,z0, x1,z1, x2,z2)

    -- Reduce only when it is fresh snow
    local reduceSnow = MathUtil.equalEpsilon(worldSnowHeight, curHeight, 0.005 )
    -- Detect unmelted heaps
    local isOnSnowHeap = worldSnowHeight < 0.005 and curHeight > 1

    -- Melt only if height is substantial
        if curHeight > SnowSystem.MIN_LAYER_HEIGHT and(reduceSnow or isOnSnowHeap) then
            local sink = 0.7 * worldSnowHeight
            if isOnSnowHeap then
                sink = 0.1 * curHeight
            end

            local sinkLayers = math.floor( math.min(sink, curHeight) / SnowSystem.MIN_LAYER_HEIGHT)
            if sinkLayers > 0 then
                snowSystem:removeSnow(x0,z0, x1,z1, x2,z2, sinkLayers)
            end
        end
    end

```

### drawAreas

**Description**

**Definition**

> drawAreas()

**Code**

```lua
function WheelDestruction:drawAreas()
    if not self.isCareWheel then
        for _, visualWheel in ipairs( self.wheel.visualWheels) do
            local repr = self.wheel.repr
            local width = 0.5 * visualWheel.width
            local length = math.min( 0.5 , 0.5 * visualWheel.width)
            local xShift, yShift, zShift = localToLocal(visualWheel.node, repr, 0 , 0 , 0 )

            local x0, y0, z0 = localToWorld(repr, xShift + width, yShift, zShift - length)
            local x1, _, z1 = localToWorld(repr, xShift - width, yShift, zShift - length)
            local x2, _, z2 = localToWorld(repr, xShift + width, yShift, zShift + length)

            local x, z, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(x0, z0, x1, z1, x2, z2)
            DebugUtil.drawDebugParallelogram(x, z, widthX, widthZ, heightX, heightZ, y0, 1 , 1 , 0 , 0.05 , true )
        end

        if # self.wheel.visualWheels = = 0 then
            local repr = self.wheel.repr
            local width = 0.5 * self.wheel.physics.width
            local length = math.min( 0.5 , 0.5 * self.wheel.physics.width)
            local xShift, yShift, zShift = localToLocal( self.wheel.driveNode, repr, 0 , 0 , 0 )

            local x0, y0, z0 = localToWorld(repr, xShift + width, yShift, zShift - length)
            local x1, _, z1 = localToWorld(repr, xShift - width, yShift, zShift - length)
            local x2, _, z2 = localToWorld(repr, xShift + width, yShift, zShift + length)

            local x, z, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(x0, z0, x1, z1, x2, z2)
            DebugUtil.drawDebugParallelogram(x, z, widthX, widthZ, heightX, heightZ, y0, 1 , 1 , 0 , 0.05 , true )
        end
    end
end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function WheelDestruction:finalize()
    for _, visualWheel in ipairs( self.wheel.visualWheels) do
        local destructionNode = { }
        destructionNode.node = visualWheel.node
        destructionNode.width = visualWheel.width
        destructionNode.radius = visualWheel.radius
        table.insert( self.destructionNodes, destructionNode)
    end

    -- if we don't have any visual wheel, we destruct at the physical wheel(crawlers etc.)
        if # self.wheel.visualWheels = = 0 then
            local destructionNode = { }
            destructionNode.node = self.wheel.driveNode
            destructionNode.width = self.wheel.physics.width
            destructionNode.radius = self.wheel.physics.radius
            table.insert( self.destructionNodes, destructionNode)
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

**Code**

```lua
function WheelDestruction:loadFromXML(xmlObject)
    xmlObject:checkDeprecatedXMLElements( ".tire#isCareWheel" , "#isCareWheel" )

    self.isCareWheel = xmlObject:getValue( "#isCareWheel" , false )
    self.smoothGroundRadius = xmlObject:getValue( ".physics#smoothGroundRadius" , math.max( 0.6 , self.wheel.physics.width * 0.75 ))

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
function WheelDestruction.new(wheel)
    local self = setmetatable( { } , { __index = WheelDestruction } )

    self.wheel = wheel
    self.vehicle = wheel.vehicle

    self.destructionNodes = { }
    self.wheelSmoothAccumulation = 0

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
function WheelDestruction.registerXMLPaths(schema, key)
    schema:register(XMLValueType.BOOL, key .. "#isCareWheel" , "Is care wheel" , false )
    schema:register(XMLValueType.FLOAT, key .. ".physics#smoothGroundRadius" , "Smooth ground radius" , "width * 0.75" )
end

```

### setIsCareWheel

**Description**

**Definition**

> setIsCareWheel()

**Arguments**

| any | isCareWheel |
|-----|-------------|

**Code**

```lua
function WheelDestruction:setIsCareWheel(isCareWheel)
    self.isCareWheel = isCareWheel
end

```

### smoothHeightAtPosition

**Description**

**Definition**

> smoothHeightAtPosition()

**Arguments**

| any | x      |
|-----|--------|
| any | y      |
| any | z      |
| any | radius |
| any | amount |

**Code**

```lua
function WheelDestruction:smoothHeightAtPosition(x, y, z, radius, amount)
    local smoothYOffset = - 0.1
    local heightType = DensityMapHeightUtil.getHeightTypeDescAtWorldPos(x, y, z, radius)
    if heightType ~ = nil and heightType.allowsSmoothing then
        local terrainHeightUpdater = g_densityMapHeightManager:getTerrainDetailHeightUpdater()
        if terrainHeightUpdater ~ = nil then
            local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, x, y, z)
            local physicsDeltaHeight = y - terrainHeight
            local deltaHeight = (physicsDeltaHeight + heightType.collisionBaseOffset) / heightType.collisionScale
            deltaHeight = math.min( math.max(deltaHeight, physicsDeltaHeight + heightType.minCollisionOffset), physicsDeltaHeight + heightType.maxCollisionOffset)
            deltaHeight = math.max(deltaHeight + smoothYOffset, 0 )
            local internalHeight = terrainHeight + deltaHeight
            smoothDensityMapHeightAtWorldPos(terrainHeightUpdater, x, internalHeight, z, amount, heightType.index, 0.0 , radius, radius + 1.2 , 0 )
            if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                DebugUtil.drawDebugCircle(x, internalHeight, z, radius, 10 )
            end
        end
    end
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt                      |
|-----|-------------------------|
| any | allowFoliageDestruction |

**Code**

```lua
function WheelDestruction:update(dt, allowFoliageDestruction)
    if g_server ~ = nil or self.vehicle.currentUpdateDistance < WheelDestruction.MAX_UPDATE_DISTANCE then
        if allowFoliageDestruction and self.vehicle.lastSpeedReal > 0.0002 then
            local hasContact = self.wheel.physics.contact ~ = WheelContactType.NONE
            local doFruitDestruction = hasContact and not self.isCareWheel
            local doSnowDestruction = hasContact and self.wheel.physics.hasSnowContact
            if doFruitDestruction or doSnowDestruction then
                for _, destructionNode in ipairs( self.destructionNodes) do
                    local repr = self.wheel.repr
                    local width = 0.5 * destructionNode.width
                    local length = math.min( 0.5 , 0.5 * destructionNode.width)
                    local xShift, yShift, zShift = localToLocal(destructionNode.node, repr, 0 , 0 , 0 )

                    if doFruitDestruction then
                        local x0, _, z0 = localToWorld(repr, xShift + width, yShift, zShift - length)
                        local x1, _, z1 = localToWorld(repr, xShift - width, yShift, zShift - length)
                        local x2, _, z2 = localToWorld(repr, xShift + width, yShift, zShift + length)
                        if g_farmlandManager:getIsOwnedByFarmAtWorldPosition( self.vehicle:getActiveFarm(), x0, z0) then
                            self:destroyFruitArea(x0, z0, x1, z1, x2, z2)
                        end
                    end

                    if doSnowDestruction then
                        local snowOffset = destructionNode.radius * 0.75 * self.vehicle.movingDirection
                        local x3, _, z3 = localToWorld(repr, xShift + width, yShift, zShift - length + snowOffset)
                        local x4, _, z4 = localToWorld(repr, xShift - width, yShift, zShift - length + snowOffset)
                        local x5, _, z5 = localToWorld(repr, xShift + width, yShift, zShift + length + snowOffset)

                        self:destroySnowArea(x3, z3, x4, z4, x5, z5)
                    end
                end
            end
        end

        if Platform.gameplay.wheelDensityHeightSmooth then
            -- smoothing of tipAny
            local wheelSmoothAmount = 0
            if self.vehicle.lastSpeedReal > 0.0002 then -- start smoothing if driving faster than 0.7km/h
                wheelSmoothAmount = self.wheelSmoothAccumulation + math.max( self.vehicle.lastMovedDistance * 1.2 , 0.0003 * dt) -- smooth 1.2m per meter driving or at least 0.3m/s
                local rounded = DensityMapHeightUtil.getRoundedHeightValue(wheelSmoothAmount)
                self.wheelSmoothAccumulation = wheelSmoothAmount - rounded
            else
                    self.wheelSmoothAccumulation = 0
                end

                if wheelSmoothAmount > 0 then
                    for _, destructionNode in ipairs( self.destructionNodes) do
                        local xOffset, _, _ = localToLocal(destructionNode.node, self.wheel.repr, 0 , 0 , 0 )

                        local x, y, z = localToLocal( self.wheel.node, self.wheel.repr, self.wheel.physics.netInfo.x, self.wheel.physics.netInfo.y, self.wheel.physics.netInfo.z)
                        x, y, z = localToWorld( self.wheel.repr, x + xOffset, y - self.wheel.physics.radius, z)

                        self:smoothHeightAtPosition(x, y, z, self.smoothGroundRadius, wheelSmoothAmount)
                    end
                end
            end
        end
    end

```