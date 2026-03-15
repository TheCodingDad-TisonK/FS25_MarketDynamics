## PlayerTargeter

**Description**

> Exists for the client's player, and handles raycasting and finding specific objects for them to interact with.

**Functions**

- [addFilterToTargetType](#addfiltertotargettype)
- [addTargetType](#addtargettype)
- [debugDraw](#debugdraw)
- [getClosestTargetedNodeFromType](#getclosesttargetednodefromtype)
- [getHasTargetedKey](#gethastargetedkey)
- [getLastLookRay](#getlastlookray)
- [new](#new)
- [recalculateCombinedTargetMask](#recalculatecombinedtargetmask)
- [removeTargetType](#removetargettype)
- [tryAddTargetWithMask](#tryaddtargetwithmask)
- [update](#update)

### addFilterToTargetType

**Description**

> Adds the given filter function to the given target type.

**Definition**

> addFilterToTargetType(any targetKey, function filterFunction)

**Arguments**

| any      | targetKey      | The key of the objects to target.                                                                                                              |
|----------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| function | filterFunction | A function that is called for each raycast object that matches the mask and helps filter out unwanted items. bool function(hitObject, x, y, z) |

**Code**

```lua
function PlayerTargeter:addFilterToTargetType(targetKey, filterFunction)

    --#debug Assert.isType(filterFunction, "function", "Filter function must be a function!")
        --#debug Assert.isTrue(self:getHasTargetedKey(targetKey), "Cannot add filter function to key that does not exist!")

            -- Get the mask for the given target.
                local targetedMask = self.targetedMasks[targetKey]
                table.insert(targetedMask.filterFunctions, filterFunction)
            end

```

### addTargetType

**Description**

> Adds the given target type to the targeter, so that the raycasts will include objects with these collision masks.

**Definition**

> addTargetType(any targetKey, CollisionFlag targetMask, float? minDistance, float maxDistance)

**Arguments**

| any           | targetKey   | An object used as a key to later retrieve or remove the target type.                      |
|---------------|-------------|-------------------------------------------------------------------------------------------|
| CollisionFlag | targetMask  | The mask of the objects to target.                                                        |
| float?        | minDistance | The optional minimum distance that an object of this type can be targeted. Defaults to 0. |
| float         | maxDistance | The maximum distance that an object of this type can be targeted.                         |

**Code**

```lua
function PlayerTargeter:addTargetType(targetKey, targetMask, minDistance, maxDistance)

    --#debug Assert.isNilOrType(minDistance, "number", "Minimum distance must be a number or nil!")
    --#debug Assert.isType(maxDistance, "number", "Maximum distance must be a number!")

    -- Check that the key is not already being targeted.
    if self:getHasTargetedKey(targetKey) then
        return
    end

    -- Set the highest max distance of the ray based on the given distance and the current max.
    self.highestMaxDistance = math.max( self.highestMaxDistance, maxDistance)

    -- Create the targeted mask table.
    self.targetedMasks[targetKey] = { key = targetKey, mask = targetMask, minDistance = minDistance or 0 , maxDistance = maxDistance, filterFunctions = { } }

    -- Recalculate the combined mask to use for the ray.
        self:recalculateCombinedTargetMask()
    end

```

### debugDraw

**Description**

> Displays the debug information.

**Definition**

> debugDraw(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Return Values**

| float | y | The y position on the screen after the entire debug info was drawn. |
|-------|---|---------------------------------------------------------------------|

**Code**

```lua
function PlayerTargeter:debugDraw(x, y, textSize)

    -- Render the header.
    y = DebugUtil.renderTextLine(x, y, textSize * 1.5 , "Targeter" , nil , true )

    local combinedMaskName = CollisionFlag.getFlagsStringFromMask( self.combinedTargetMask)
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Combined mask: %q" , combinedMaskName), nil , true )
    y = DebugUtil.renderTextLine(x, y, textSize, "Masks:" , nil , true )

    for key, targetedMask in pairs( self.targetedMasks) do
        local maskNode = self:getClosestTargetedNodeFromType(key)
        local nodeName = (maskNode ~ = nil and entityExists(maskNode)) and getName(maskNode) or "none"

        local maskName = CollisionFlag.getFlagsStringFromMask(targetedMask.mask)

        y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Mask %q: %q" , maskName, nodeName))
    end

    return y
end

```

### getClosestTargetedNodeFromType

**Description**

> Gets the last found node from the given target mask, or nil if none was found.

**Definition**

> getClosestTargetedNodeFromType(any targetKey)

**Arguments**

| any | targetKey | The key of the objects to stop targeting. |
|-----|-----------|-------------------------------------------|

**Return Values**

| any | node | The last found node from the given target mask, or nil if none was found. |
|-----|------|---------------------------------------------------------------------------|

**Code**

```lua
function PlayerTargeter:getClosestTargetedNodeFromType(targetKey)
    local closestTarget = self.closestTargetsByKey[targetKey]
    return closestTarget ~ = nil and closestTarget.node or nil
end

```

### getHasTargetedKey

**Description**

> Returns true if the given key is targeted; otherwise false.

**Definition**

> getHasTargetedKey(CollisionFlag targetKey)

**Arguments**

| CollisionFlag | targetKey | The key of the objects to target. |
|---------------|-----------|-----------------------------------|

**Return Values**

| CollisionFlag | hasTargetedMask | True if the mask is targeted; otherwise false. |
|---------------|-----------------|------------------------------------------------|

**Code**

```lua
function PlayerTargeter:getHasTargetedKey(targetKey)
    return self.targetedMasks[targetKey] ~ = nil
end

```

### getLastLookRay

**Description**

> Gets the last look ray components.

**Definition**

> getLastLookRay()

**Return Values**

| CollisionFlag | lastRayX          | The origin's x position. |
|---------------|-------------------|--------------------------|
| CollisionFlag | lastRayY          | The origin's y position. |
| CollisionFlag | lastRayZ          | The origin's z position. |
| CollisionFlag | lastRayDirectionX | The ray's x direction.   |
| CollisionFlag | lastRayDirectionY | The ray's y direction.   |
| CollisionFlag | lastRayDirectionZ | The ray's z direction.   |

**Code**

```lua
function PlayerTargeter:getLastLookRay()
    return self.lastRayX, self.lastRayY, self.lastRayZ, self.lastRayDirectionX, self.lastRayDirectionY, self.lastRayDirectionZ
end

```

### new

**Description**

> Creates a new targeter for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player for whom the targeter is made. |
|--------|--------|-------------------------------------------|

**Return Values**

| Player | self | The created instance. |
|--------|------|-----------------------|

**Code**

```lua
function PlayerTargeter.new(player)

    -- Create the instance.
    local self = setmetatable( { } , PlayerTargeter _mt)

    -- The player that this targeter belongs to.
    self.player = player

    -- The pool of unused target tables.
    self.pooledTargets = ObjectPool.new()

    -- The total combined mask.
    self.combinedTargetMask = 0

    -- The collection of specifically targeted masks.
    self.targetedMasks = { }

    self.closestTargetsByKey = { }
    self.currentTargetsByKey = { }

    -- The highest maximum distance that is targeted.
    self.highestMaxDistance = 0

    -- The components of the last ray that was fired by this targeter.
    self.lastRayX, self.lastRayY, self.lastRayZ = nil , nil , nil
    self.lastRayDirectionX, self.lastRayDirectionY, self.lastRayDirectionZ = nil , nil , nil

    -- Return the created instance.
    return self
end

```

### recalculateCombinedTargetMask

**Description**

> Resets and recalculates the combined target mask using all targeted masks.

**Definition**

> recalculateCombinedTargetMask()

**Code**

```lua
function PlayerTargeter:recalculateCombinedTargetMask()
    self.combinedTargetMask = 0
    for _, targetedMask in pairs( self.targetedMasks) do
        self.combinedTargetMask = bit32.bor( self.combinedTargetMask, targetedMask.mask)
    end
end

```

### removeTargetType

**Description**

> Removes the given target type from this targeter.

**Definition**

> removeTargetType(any targetKey)

**Arguments**

| any | targetKey | The key of the objects to stop targeting. |
|-----|-----------|-------------------------------------------|

**Code**

```lua
function PlayerTargeter:removeTargetType(targetKey)

    -- Remove the target from the collection.
    self.targetedMasks[targetKey] = nil

    -- Recalculate the combined target mask and maximum distance.
    self:recalculateCombinedTargetMask()
    self.highestMaxDistance = 0
    for _, targetedMask in pairs( self.targetedMasks) do
        self.highestMaxDistance = math.max( self.highestMaxDistance, targetedMask.maxDistance)
    end
end

```

### tryAddTargetWithMask

**Description**

> Attempts to add the given information to the given target mask's target.

**Definition**

> tryAddTargetWithMask(entityId hitNode, float x, float y, float z, table targetedMask, float distance)

**Arguments**

| entityId | hitNode      | The node that was hit.                        |
|----------|--------------|-----------------------------------------------|
| float    | x            | The hit x position.                           |
| float    | y            | The hit y position.                           |
| float    | z            | The hit z position.                           |
| table    | targetedMask | The targeted mask table to attempt to add to. |
| float    | distance     | The distance of the ray.                      |

**Code**

```lua
function PlayerTargeter:tryAddTargetWithMask(hitNode, x, y, z, targetedMask, distance)

    -- If the distance is greater than the max distance or the hit node does not have the right mask, do nothing.
        if distance > targetedMask.maxDistance or distance < targetedMask.minDistance or not CollisionFlag.getHasGroupFlagSet(hitNode, targetedMask.mask) then
            return
        end

        -- If the ray already hit something with this mask that's closer, check the distances.If the hit object is further away than the existing one, do nothing.
            local existingClosestTarget = self.currentTargetsByKey[targetedMask.key]
            if existingClosestTarget ~ = nil and existingClosestTarget.distance < distance then
                return
            end

            -- If the any of the filter functions from the targeted mask returns false; do nothing.
                for i, filterFunction in ipairs(targetedMask.filterFunctions) do
                    if not filterFunction(hitNode, x, y, z) then
                        return
                    end
                end

                -- Set the closest target of the mask to the hit node.
                local target = self.pooledTargets:getOrCreateNext()
                target.x, target.y, target.z = x, y, z
                target.node = hitNode
                target.distance = distance
                self.currentTargetsByKey[targetedMask.key] = target
            end

```

### update

**Description**

> Updates the targeter to find targeted objects.

**Definition**

> update(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerTargeter:update(dt)
    -- Get the position and direction from the player's camera, do nothing if it was invalid.
        self.lastRayX, self.lastRayY, self.lastRayZ, self.lastRayDirectionX, self.lastRayDirectionY, self.lastRayDirectionZ = self.player:getLookRay()
        if self.lastRayX = = nil then
            return
        end

        self:resetState()

        -- Cast the ray.
        raycastAllAsync( self.lastRayX, self.lastRayY, self.lastRayZ, self.lastRayDirectionX, self.lastRayDirectionY, self.lastRayDirectionZ, self.highestMaxDistance, "raycastCallback" , self , self.combinedTargetMask)
    end

```