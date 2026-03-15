## DebugBox

**Parent**

> [DebugElement](?version=script&category=21&class=196)

**Functions**

- [setDrawFaces](#setdrawfaces)
- [setSize](#setsize)

### setDrawFaces

**Description**

> setDrawFaces

**Definition**

> setDrawFaces(boolean drawFaces)

**Arguments**

| boolean | drawFaces |
|---------|-----------|

**Return Values**

| boolean | self |
|---------|------|

**Code**

```lua
function DebugBox:setDrawFaces(drawFaces)

    --#debug Assert.isType(drawFaces, "boolean")

    self.drawFaces = drawFaces

    return self
end

```

### setSize

**Description**

> setSize

**Definition**

> setSize(float sizeX, float sizeY, float sizeZ)

**Arguments**

| float | sizeX |
|-------|-------|
| float | sizeY |
| float | sizeZ |

**Return Values**

| float | self |
|-------|------|

**Code**

```lua
function DebugBox:setSize(sizeX, sizeY, sizeZ)

    --#debug Assert.isNilOrType(sizeX, "number")
    --#debug Assert.isNilOrType(sizeY, "number")
    --#debug Assert.isNilOrType(sizeZ, "number")

    self.sizeX = sizeX or self.sizeX
    self.sizeY = sizeY or self.sizeY
    self.sizeZ = sizeZ or self.sizeZ

    DebugBox.calculateCornerPositions( self.cornerPositions, self.x, self.y, self.z, self.upX, self.upY, self.upZ, self.dirX, self.dirY, self.dirZ, self.sizeX, self.sizeY, self.sizeZ)

    return self
end

```