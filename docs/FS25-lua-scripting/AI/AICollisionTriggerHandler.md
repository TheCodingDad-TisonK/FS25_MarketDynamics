## AICollisionTriggerHandler

**Description**

> Drive strategy to stop vehicle on collision
> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Functions**

- [generateTriggerPath](#generatetriggerpath)
- [init](#init)
- [new](#new)
- [onVehicleCollisionDistanceCallback](#onvehiclecollisiondistancecallback)
- [setCollisionDistanceCallback](#setcollisiondistancecallback)
- [setIsBlockedCallback](#setisblockedcallback)
- [setStaticCollisionCallback](#setstaticcollisioncallback)
- [update](#update)
- [updateBlockedCallback](#updateblockedcallback)
- [updateStaticCollisionCallback](#updatestaticcollisioncallback)

### generateTriggerPath

**Description**

**Definition**

> generateTriggerPath()

**Arguments**

| any | vehicle         |
|-----|-----------------|
| any | trigger         |
| any | movingDirection |

**Code**

```lua
function AICollisionTriggerHandler:generateTriggerPath(vehicle, trigger, movingDirection)
    local node = movingDirection > = 0 and trigger.node or(trigger.backNode or trigger.node)
    trigger.curTriggerDirection = (movingDirection < 0 and trigger.backNode ~ = trigger.node) and trigger.backNodeDirection or 1

    for i = 0 , AICollisionTriggerHandler.TRIGGER_SUBDIVISIONS * 3 , 3 do
        local x, y, z = localToWorld(node, 0 , 0 , i / AICollisionTriggerHandler.TRIGGER_SUBDIVISIONS / 3 * trigger.length * trigger.curTriggerDirection)
        trigger.positions[i + 1 ] = x
        trigger.positions[i + 2 ] = getTerrainHeightAtWorldPos(g_terrainNode, x, y, z) + trigger.height * 0.5
        trigger.positions[i + 3 ] = z
    end

    trigger.isValid = true
end

```

### init

**Description**

**Definition**

> init()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | strategy |

**Code**

```lua
function AICollisionTriggerHandler:init(vehicle, strategy)
    self.vehicle = vehicle
    self.strategy = strategy

    if vehicle.isServer then
        self.collisionTriggerByVehicle = { }

        self.rootVehicle = vehicle.rootVehicle

        local vehicles = self.rootVehicle.childVehicles
        for i = 1 , #vehicles do
            local subVehicle = vehicles[i]
            if subVehicle.getAICollisionTriggers ~ = nil then
                subVehicle:getAICollisionTriggers( self.collisionTriggerByVehicle)
            end

            if subVehicle.getAIImplementCollisionTriggers ~ = nil then
                subVehicle:getAIImplementCollisionTriggers( self.collisionTriggerByVehicle)
            end
        end

        local index = 1
        for v, trigger in pairs( self.collisionTriggerByVehicle) do
            trigger.vehicle = v
            trigger.updateIndex = index
            trigger.hasCollision = false
            trigger.hasStaticCollision = false
            trigger.isValid = true
            trigger.hitCounter = 0
            trigger.hitStaticCounter = 0
            trigger.curTriggerLength = 5
            trigger.curTriggerDirection = 1

            trigger.dynamicHitPoint = { 0 , 0 , 0 }
            trigger.dynamicHitPointValid = false
            trigger.dynamicHitPointDistance = math.huge
            trigger.dynamicHitPointInitialDistance = 0

            trigger.staticHitPoint = { 0 , 0 , 0 }
            trigger.staticHitPointValid = false
            trigger.staticHitPointDistance = math.huge
            trigger.staticHitPointInitialDistance = 0

            trigger.positions = { }
            for i = 1 , ( AICollisionTriggerHandler.TRIGGER_SUBDIVISIONS + 1 ) * 3 do
                table.insert(trigger.positions, 0 )
            end

            index = index + AICollisionTriggerHandler.UPDATE_INTERVAL
        end
        self.maxUpdateIndex = index
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function AICollisionTriggerHandler.new(customMt)
    local self = setmetatable( { } , customMt or AICollisionTriggerHandler _mt)

    self.numCollidingVehicles = { }
    self.vehicleIgnoreList = { }

    self.collisionTriggerByVehicle = { }
    self.maxUpdateIndex = 1

    self.hasStaticCollision = false
    self.isBlocked = false

    self.dynamicHitPointDistance = math.huge
    self.staticHitPointDistance = math.huge

    return self
end

```

### onVehicleCollisionDistanceCallback

**Description**

**Definition**

> onVehicleCollisionDistanceCallback()

**Arguments**

| any | distance      |
|-----|---------------|
| any | objectId      |
| any | subShapeIndex |
| any | isLast        |
| any | trigger       |

**Code**

```lua
function AICollisionTriggerHandler:onVehicleCollisionDistanceCallback(distance, objectId, subShapeIndex, isLast, trigger)
    -- check for mission and strategy existence in case we receive the async callback after one of them has been removed(e.g.leaving game)
        if g_currentMission ~ = nil and self.collisionTriggerByVehicle ~ = nil then
            -- ignore callbacks that arrive after the vehicle has been deleted
            for vehicle, _ in pairs( self.collisionTriggerByVehicle) do
                if vehicle.isDeleted or vehicle.isDeleting then
                    return false
                end
            end

            if objectId ~ = 0 then

                local player = g_currentMission.playerSystem:getPlayerByRootNode(objectId)
                if player ~ = nil then
                    trigger.hitCounter = trigger.hitCounter + 1
                else
                        local vehicle = g_currentMission.nodeToObject[objectId]
                        if vehicle = = nil or self.collisionTriggerByVehicle[vehicle] = = nil then
                            -- exclude all objects that have 'road' in their name -> for wrongly set up mod map roads
                                if not getHasTrigger(objectId) then --and not getName(objectId):contains("road") then
                                    if vehicle = = nil or vehicle.getRootVehicle = = nil or vehicle:getRootVehicle() ~ = self.rootVehicle then
                                        if getRigidBodyType(objectId) ~ = RigidBodyType.DYNAMIC then
                                            trigger.hitStaticCounter = trigger.hitStaticCounter + 1
                                        else
                                                -- we fully ignore other than vehicle dynamic objects(bales, traffic signs, etc.)
                                                if bit32.band(getCollisionFilterGroup(objectId), CollisionFlag.VEHICLE) ~ = 0 then
                                                    trigger.hitCounter = trigger.hitCounter + 1
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        -- we store the first hit position and then calculate the distance to this position afterwards
                        -- this works fine while driving straight to the collision, but is not accorate in curves
                            -- but it is much cheaper than checking for the real distance to the collision the engine

                                if objectId = = 0 or isLast then
                                    local hasCollision = trigger.hitCounter > 0
                                    if hasCollision ~ = trigger.hasCollision then
                                        trigger.hasCollision = hasCollision

                                        if hasCollision then
                                            trigger.dynamicHitPointValid = true
                                            trigger.dynamicHitPoint[ 1 ], trigger.dynamicHitPoint[ 2 ], trigger.dynamicHitPoint[ 3 ] = getWorldTranslation(trigger.node)
                                            trigger.dynamicHitPointInitialDistance = trigger.vehicle.lastSpeedReal * g_physicsDt * AICollisionTriggerHandler.UPDATE_INTERVAL
                                        else
                                                trigger.dynamicHitPointValid = false
                                                trigger.dynamicHitPointDistance = math.huge
                                            end

                                            self:updateBlockedCallback()
                                        end

                                        local hasStaticCollision = trigger.hitStaticCounter > 0
                                        if hasStaticCollision ~ = trigger.hasStaticCollision then
                                            trigger.hasStaticCollision = hasStaticCollision

                                            if hasStaticCollision then
                                                trigger.staticHitPointValid = true
                                                trigger.staticHitPoint[ 1 ], trigger.staticHitPoint[ 2 ], trigger.staticHitPoint[ 3 ] = getWorldTranslation(trigger.node)
                                                trigger.staticHitPointInitialDistance = trigger.vehicle.lastSpeedReal * g_physicsDt * AICollisionTriggerHandler.UPDATE_INTERVAL
                                            else
                                                    trigger.staticHitPointValid = false
                                                    trigger.staticHitPointDistance = math.huge
                                                end

                                                self:updateStaticCollisionCallback()
                                            end

                                            return false
                                        else
                                                return true
                                            end
                                        end

                                        return
                                    end

```

### setCollisionDistanceCallback

**Description**

**Definition**

> setCollisionDistanceCallback()

**Arguments**

| any | callback |
|-----|----------|

**Code**

```lua
function AICollisionTriggerHandler:setCollisionDistanceCallback(callback)
    self.collisionDistanceCallback = callback
end

```

### setIsBlockedCallback

**Description**

**Definition**

> setIsBlockedCallback()

**Arguments**

| any | callback |
|-----|----------|

**Code**

```lua
function AICollisionTriggerHandler:setIsBlockedCallback(callback)
    self.isBlockedCallback = callback
end

```

### setStaticCollisionCallback

**Description**

**Definition**

> setStaticCollisionCallback()

**Arguments**

| any | callback |
|-----|----------|

**Code**

```lua
function AICollisionTriggerHandler:setStaticCollisionCallback(callback)
    self.staticCollisionCallback = callback
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt              |
|-----|-----------------|
| any | movingDirection |

**Code**

```lua
function AICollisionTriggerHandler:update(dt, movingDirection)
    local dynamicHitPointDistance, staticHitPointDistance = math.huge, math.huge
    local currentIndex = g_updateLoopIndex % self.maxUpdateIndex
    for v, trigger in pairs( self.collisionTriggerByVehicle) do
        if trigger.dynamicHitPointValid then
            local x, y, z = getWorldTranslation(trigger.node)
            trigger.dynamicHitPointDistance = math.max(trigger.length - MathUtil.vector3Length(trigger.dynamicHitPoint[ 1 ] - x, trigger.dynamicHitPoint[ 2 ] - y, trigger.dynamicHitPoint[ 3 ] - z) - trigger.dynamicHitPointInitialDistance, 0 )
        end

        if trigger.staticHitPointValid then
            local x, y, z = getWorldTranslation(trigger.node)
            trigger.staticHitPointDistance = math.max(trigger.length - MathUtil.vector3Length(trigger.staticHitPoint[ 1 ] - x, trigger.staticHitPoint[ 2 ] - y, trigger.staticHitPoint[ 3 ] - z) - trigger.staticHitPointInitialDistance, 0 )
        end

        dynamicHitPointDistance = math.min(trigger.dynamicHitPointDistance, dynamicHitPointDistance)
        staticHitPointDistance = math.min(trigger.staticHitPointDistance, staticHitPointDistance)

        if trigger.updateIndex = = currentIndex then
            self:generateTriggerPath(v, trigger, movingDirection)

            if trigger.isValid then
                trigger.hitCounter = 0
                trigger.hitStaticCounter = 0
                local dx, dy, dz = localDirectionToWorld(trigger.node, 0 , 0 , trigger.curTriggerDirection)
                getVehicleCollisionDistance(trigger.positions, dx, dy, dz, trigger.width, trigger.height, "onVehicleCollisionDistanceCallback" , self , trigger, AICollisionTriggerHandler.COLLISION_MASK, true , true , true , true )
            end
        end
    end

    self.dynamicHitPointDistance = dynamicHitPointDistance
    self.staticHitPointDistance = staticHitPointDistance

    if self.collisionDistanceCallback ~ = nil then
        self.collisionDistanceCallback( math.min( self.dynamicHitPointDistance, self.staticHitPointDistance))
    end

    if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
        for v, trigger in pairs( self.collisionTriggerByVehicle) do
            self:generateTriggerPath(v, trigger, movingDirection)

            if trigger.isValid then
                for i = 1 , #trigger.positions - 3 , 3 do
                    drawDebugLine(trigger.positions[i + 0 ], trigger.positions[i + 1 ] + 2 , trigger.positions[i + 2 ], 1 , 0 , 0 , trigger.positions[i + 3 ], trigger.positions[i + 4 ] + 2 , trigger.positions[i + 5 ], 0 , 1 , 0 , true )
                end

                local dx, dy, dz = localDirectionToWorld(trigger.node, 0 , 0 , 1 )
                debugDrawVehicleCollision(trigger.positions, dx, dy, dz, trigger.width, trigger.height)
            end
        end
    end
end

```

### updateBlockedCallback

**Description**

**Definition**

> updateBlockedCallback()

**Code**

```lua
function AICollisionTriggerHandler:updateBlockedCallback()
    local isBlocked = false
    for v, trigger in pairs( self.collisionTriggerByVehicle) do
        if trigger.hasCollision then
            isBlocked = true
            break
        end
    end

    if isBlocked ~ = self.isBlocked then
        self.isBlocked = isBlocked

        if self.isBlockedCallback ~ = nil then
            self.isBlockedCallback(isBlocked)
        end
    end
end

```

### updateStaticCollisionCallback

**Description**

**Definition**

> updateStaticCollisionCallback()

**Code**

```lua
function AICollisionTriggerHandler:updateStaticCollisionCallback()
    local hasStaticCollision = false
    for v, trigger in pairs( self.collisionTriggerByVehicle) do
        if trigger.hasStaticCollision then
            hasStaticCollision = true
            break
        end
    end

    if hasStaticCollision ~ = self.hasStaticCollision then
        self.hasStaticCollision = hasStaticCollision

        if self.staticCollisionCallback ~ = nil then
            self.staticCollisionCallback(hasStaticCollision)
        end
    end
end

```