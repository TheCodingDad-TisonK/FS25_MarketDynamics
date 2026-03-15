## PlayerCCT

**Description**

> A capsule controller for a player. Simply managing the CCT.

**Functions**

- [calculateIfBottomTouchesGround](#calculateifbottomtouchesground)
- [debugDraw](#debugdraw)
- [delete](#delete)
- [getPosition](#getposition)
- [move](#move)
- [new](#new)
- [rebuild](#rebuild)
- [setPosition](#setposition)

### calculateIfBottomTouchesGround

**Description**

> Calculates if the bottom of the capsule is touching the ground.

**Definition**

> calculateIfBottomTouchesGround()

**Return Values**

| any | isGrounded | Is true if the bottom of the capsule is touching the ground; otherwise false. |
|-----|------------|-------------------------------------------------------------------------------|

**Code**

```lua
function PlayerCCT:calculateIfBottomTouchesGround()

    -- Get the collision flags for the top, middle, and bottom of the CCT.The bottom is the only part that matters.
        local _, _, isGrounded = getCCTCollisionFlags( self.capsuleId)

        -- Return the bottom flag.
        return isGrounded
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
function PlayerCCT:debugDraw(x, y, textSize)

    -- Render the header.
    y = DebugUtil.renderTextLine(x, y, textSize * 1.5 , "CCT" , nil , true )

    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Height: %.2f" , self.height))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Physics height: %.2f" , getCCTHeight( self.capsuleId)))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Desired height: %.2f" , self.desiredHeight))

    return y
end

```

### delete

**Description**

> Removes the CCT, if one exists.

**Definition**

> delete()

**Code**

```lua
function PlayerCCT:delete()

    -- Remove the CCT and set the index to nil.
    if self.capsuleId ~ = nil then
        removeCCT( self.capsuleId)
        self.capsuleId = nil
    end
end

```

### getPosition

**Description**

> Returns the position of the player's feet.

**Definition**

> getPosition()

**Return Values**

| float | x | The x position. |
|-------|---|-----------------|
| float | y | The y position. |
| float | z | The z position. |

**Code**

```lua
function PlayerCCT:getPosition()
    local x, y, z = getWorldTranslation( self.rootNode)
    return x, y + self:getBottomOffsetY(), z
end

```

### move

**Description**

> Moves the CCT using the given movement.

**Definition**

> move(float movementX, float movementY, float movementZ)

**Arguments**

| float | movementX | The x movement in metres. |
|-------|-----------|---------------------------|
| float | movementY | The y movement in metres. |
| float | movementZ | The z movement in metres. |

**Code**

```lua
function PlayerCCT:move(movementX, movementY, movementZ)
    --#profile RemoteProfiler.zoneBeginN("PlayerCCT-move")
    moveCCT( self.capsuleId, movementX, movementY, movementZ, self.movementCollisionGroup, self.movementCollisionMask)
    --#profile RemoteProfiler.zoneEnd()
end

```

### new

**Description**

> Creates a new player CCT instance

**Definition**

> new()

**Return Values**

| float | playerCCT | The created instance. |
|-------|-----------|-----------------------|

**Code**

```lua
function PlayerCCT.new()
    local self = setmetatable( { } , PlayerCCT _mt)

    -- The id of the CCT itself.
    self.capsuleId = nil

    -- The height of the capsule.
    self.height = PlayerCCT.DEFAULT_HEIGHT

    -- The height that the capsule wishes to have, before the physics system knows if it is valid.
        self.desiredHeight = self.height

        -- The physics index on which the height was changed.
        self.heightChangePhysicsIndex = nil

        -- The radius of the capsule.
        self.radius = 0.35

        -- The steepest slope the capsule can climb.
        self.slopeLimit = 60

        -- The highest y difference the capsule can step up.
        self.stepOffset = 0.4

        -- The mass of the capsule.
        self.mass = 0

        self.collisionGroup = PlayerCCT.DEFAULT_COLLISION_GROUP

        self.collisionMask = PlayerCCT.DEFAULT_COLLISION_MASK

        self.movementCollisionGroup = PlayerCCT.DEFAULT_MOVEMENT_COLLISION_GROUP

        self.movementCollisionMask = PlayerCCT.DEFAULT_MOVEMENT_COLLISION_MASK

        -- Return the created instance.
        return self
    end

```

### rebuild

**Description**

> Deletes and recreates the player's CCT.

**Definition**

> rebuild()

**Code**

```lua
function PlayerCCT:rebuild()

    -- Delete the old CCT.
    if self.capsuleId ~ = nil then
        removeCCT( self.capsuleId)
        self.capsuleId = nil
    end

    -- Create the CCT again.
    self.capsuleId = createCCT( self.rootNode, self.radius, self.desiredHeight, self.stepOffset, self.slopeLimit, self:getSkinWidth(), self.collisionGroup, self.collisionMask, self.mass)

    -- Update the height members.
    self.height = self.desiredHeight
    self.heightChangePhysicsIndex = nil
end

```

### setPosition

**Description**

> Positions the player's foot position using the given position.

**Definition**

> setPosition(float x, float y, float z, boolean? setNodeTranslation)

**Arguments**

| float    | x                  | The x position.                                                                                      |
|----------|--------------------|------------------------------------------------------------------------------------------------------|
| float    | y                  | The y position.                                                                                      |
| float    | z                  | The z position.                                                                                      |
| boolean? | setNodeTranslation | If this is true, the player's root node will also be moved to the given position. Defaults to false. |

**Code**

```lua
function PlayerCCT:setPosition(x, y, z, setNodeTranslation)

    if setNodeTranslation then
        setWorldTranslation( self.rootNode, x, y - self:getBottomOffsetY(), z)
    end

    setCCTPosition( self.capsuleId, x, y - self:getBottomOffsetY(), z)
end

```