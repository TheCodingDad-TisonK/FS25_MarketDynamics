## PlacementGrid2D

**Description**

> Creates a 2d grid based on a node, width (X-axis) and length (Z-axis)
> Creates vertical lines for blocked areas with the given spacing
> These lines a have a minX and maxX value to define the extend of the blocked area
> To get a free position we loop over the whole area in z-axis. The spacing defines the stepsize
> We now check in each iteration if there is a blocking line. If so we check upper and lower side if there's enough
> space
> If there is enough space we mark the current point as available for placing. If not we reset the point
> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
> | |
> | ##### |
> | ##### | width
> | ##### |
> |\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_|
> length
> Modes:
> SIDES (Places the objects at the edges)
> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
> |##### ##### ##### |
> |##### ##### ##### |
> | |
> | |
> |##### ##### |
> |##### #####\_\_\_\_\_\_\_\_\_|
> FILL (Places the objects top down)
> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
> |##### ##### ##### |
> |##### ##### ##### |
> | |
> |##### ##### |
> |##### ##### |
> |\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_|

**Functions**

- [blockAreaByBoundingBox](#blockareabyboundingbox)
- [blockAreaLocal](#blockarealocal)
- [delete](#delete)
- [drawDebug](#drawdebug)
- [new](#new)
- [reset](#reset)
- [updateBlockedArea](#updateblockedarea)

### blockAreaByBoundingBox

**Description**

**Definition**

> blockAreaByBoundingBox()

**Arguments**

| any | x       |
|-----|---------|
| any | y       |
| any | z       |
| any | dirX    |
| any | dirY    |
| any | dirZ    |
| any | upX     |
| any | upY     |
| any | upZ     |
| any | extendX |
| any | extendY |
| any | extendZ |

**Code**

```lua
function PlacementGrid2D:blockAreaByBoundingBox(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, extendY, extendZ)
    local x1, _, z1 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, - extendX, - extendY, - extendZ))
    local x2, _, z2 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, - extendY, - extendZ))
    local x3, _, z3 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, - extendY, extendZ))
    local x4, _, z4 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, - extendX, - extendY, extendZ))
    local x5, _, z5 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, - extendX, extendY, - extendZ))
    local x6, _, z6 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, extendY, - extendZ))
    local x7, _, z7 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, extendY, extendZ))
    local x8, _, z8 = worldToLocal( self.node, MathUtil.transform(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, - extendX, extendY, extendZ))

    local minX = math.max( 0 , math.min(x1, x2, x3, x4, x5, x6, x7, x8))
    local maxX = math.min( self.width, math.max(x1, x2, x3, x4, x5, x6, x7, x8))
    local minZ = math.max( 0 , math.min(z1, z2, z3, z4, z5, z6, z7, z8))
    local maxZ = math.min( self.length, math.max(z1, z2, z3, z4, z5, z6, z7, z8))

    self:updateBlockedArea(minX, maxX, minZ, maxZ)
end

```

### blockAreaLocal

**Description**

**Definition**

> blockAreaLocal()

**Arguments**

| any | x      |
|-----|--------|
| any | z      |
| any | width  |
| any | length |

**Code**

```lua
function PlacementGrid2D:blockAreaLocal(x, z, width, length)
    local minX = x
    local maxX = x + width
    local minZ = z
    local maxZ = z + length

    self:updateBlockedArea(minX, maxX, minZ, maxZ)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function PlacementGrid2D:delete()
end

```

### drawDebug

**Description**

**Definition**

> drawDebug()

**Code**

```lua
function PlacementGrid2D:drawDebug()
    local x1, y1, z1 = localToWorld( self.node, 0 , 0 , 0 )
    local x2, y2, z2 = localToWorld( self.node, self.width, 0 , 0 )
    local x3, y3, z3 = localToWorld( self.node, self.width, 0 , self.length)
    local x4, y4, z4 = localToWorld( self.node, 0 , 0 , self.length)

    drawDebugLine(x1, y1, z1, 1 , 1 , 1 , x2, y2, z2, 1 , 1 , 1 )
    drawDebugLine(x2, y2, z2, 1 , 1 , 1 , x3, y3, z3, 1 , 1 , 1 )
    drawDebugLine(x3, y3, z3, 1 , 1 , 1 , x4, y4, z4, 1 , 1 , 1 )
    drawDebugLine(x4, y4, z4, 1 , 1 , 1 , x1, y1, z1, 1 , 1 , 1 )

    for _, blockedArea in pairs( self.blockedAreas) do
        local sx1, sy1, sz1 = localToWorld( self.node, blockedArea.minX, 0 , blockedArea.offsetZ)
        local sx2, sy2, sz2 = localToWorld( self.node, blockedArea.maxX, 0 , blockedArea.offsetZ)
        if blockedArea.maxX > blockedArea.minX then
            local csx1, csy1, csz1 = localToWorld( self.node, blockedArea.minX, 0 , blockedArea.zStart)
            local csx2, csy2, csz2 = localToWorld( self.node, blockedArea.maxX, 0 , blockedArea.zStart)
            drawDebugLine(csx1, csy1, csz1, 1 , 1 , 1 , csx2, csy2, csz2, 1 , 1 , 1 )
            local cex1, cey1, cez1 = localToWorld( self.node, blockedArea.minX, 0 , blockedArea.zEnd)
            local cex2, cey2, cez2 = localToWorld( self.node, blockedArea.maxX, 0 , blockedArea.zEnd)
            drawDebugLine(cex1, cey1, cez1, 1 , 1 , 1 , cex2, cey2, cez2, 1 , 1 , 1 )

            drawDebugLine(sx1, sy1, sz1, 1 , 0 , 0 , sx2, sy2, sz2, 1 , 0 , 0 )
        end
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | node    |
|-----|---------|
| any | width   |
| any | length  |
| any | spacing |
| any | mode    |

**Code**

```lua
function PlacementGrid2D.new(node, width, length, spacing, mode)
    local self = setmetatable( { } , PlacementGrid2D _mt)

    self.node = node
    self.width = width
    self.length = length
    self.spacing = spacing

    self.placementMode = mode or PlacementGrid2D.MODE_SIDES

    self.blockedAreas = { }

    self.lowerPos = { x = 0 , z = 0 , isValid = false }
    self.upperPos = { x = 0 , z = 0 , isValid = false }

    return self
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function PlacementGrid2D:reset()
    self.blockedAreas = { }
end

```

### updateBlockedArea

**Description**

**Definition**

> updateBlockedArea()

**Arguments**

| any | minX |
|-----|------|
| any | maxX |
| any | minZ |
| any | maxZ |

**Code**

```lua
function PlacementGrid2D:updateBlockedArea(minX, maxX, minZ, maxZ)
    local startIndex = math.max( 1 , math.ceil(minZ / self.spacing))
    local endIndex = math.max( 0 , math.ceil(maxZ / self.spacing))

    for i = startIndex, endIndex do
        local blockedArea = self.blockedAreas[i]
        if blockedArea = = nil then
            local zStart = (i - 1 ) * self.spacing
            local zEnd = i * self.spacing
            local offsetZ = (zStart + zEnd) * 0.5

            blockedArea = {
            minX = self.width,
            maxX = 0 ,
            zStart = zStart,
            zEnd = zEnd,
            offsetZ = offsetZ
            }

            self.blockedAreas[i] = blockedArea
        end

        blockedArea.minX = math.min(blockedArea.minX, minX)
        blockedArea.maxX = math.max(blockedArea.maxX, maxX)
    end
end

```