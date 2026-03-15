## TerrainLayerElement

**Description**

> Display a terrain layer image

**Parent**

> [GuiElement](?version=script&category=43&class=501)

**Functions**

- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getFocusTarget](#getfocustarget)
- [new](#new)
- [setTerrainLayer](#setterrainlayer)

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Code**

```lua
function TerrainLayerElement:canReceiveFocus()
    if not self.visible or # self.elements < 1 then
        return false
    end
    -- element can only receive focus if all sub elements are ready to receive focus
        for _, v in ipairs( self.elements) do
            if ( not v:canReceiveFocus()) then
                return false
            end
        end
        return true
    end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function TerrainLayerElement:copyAttributes(src)
    TerrainLayerElement:superClass().copyAttributes( self , src)

    self:setTerrainLayer(src.terrainRootNode, src.layer)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function TerrainLayerElement:delete()
    self:destroyOverlay( self.terrainRootNode)

    TerrainLayerElement:superClass().delete( self )
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function TerrainLayerElement:draw(clipX1, clipY1, clipX2, clipY2)
    if self.terrainLayerTextureOverlay = = nil then
        return
    end

    local posX, posY, sizeX, sizeY = self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ]
    local u1, v1, u2, v2, u3, v3, u4, v4 = 0 , 0 , 0 , 1 , 1 , 0 , 1 , 1

    -- Needs clipping
    if clipX1 ~ = nil then
        local oldX1, oldY1, oldX2, oldY2 = posX, posY, sizeX + posX, sizeY + posY

        local posX2 = posX + sizeX
        local posY2 = posY + sizeY

        posX = math.max(posX, clipX1)
        posY = math.max(posY, clipY1)

        sizeX = math.max( math.min(posX2, clipX2) - posX, 0 )
        sizeY = math.max( math.min(posY2, clipY2) - posY, 0 )

        local p1 = (posX - oldX1) / (oldX2 - oldX1) -- start x
        local p2 = (posY - oldY1) / (oldY2 - oldY1) -- start y
        local p3 = ((posX + sizeX) - oldX1) / (oldX2 - oldX1) -- end x
        local p4 = ((posY + sizeY) - oldY1) / (oldY2 - oldY1) -- end y

        -- start x, start y
        u1 = p1
        v1 = p2

        -- start x, end y
        u2 = p1
        v2 = p4

        -- end x, start y
        u3 = p3
        v3 = p2

        -- end x, end y
        u4 = p3
        v4 = p4
    end

    if u1 ~ = u3 and v1 ~ = v2 then
        setOverlayUVs( self.terrainLayerTextureOverlay, u1, v1, u2, v2, u3, v3, u4, v4)
        renderOverlay( self.terrainLayerTextureOverlay, posX, posY, sizeX, sizeY)
    end

    TerrainLayerElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
end

```

### getFocusTarget

**Description**

**Definition**

> getFocusTarget()

**Code**

```lua
function TerrainLayerElement:getFocusTarget()
    if # self.elements > 0 then
        local _, firstElement = next( self.elements)
        if firstElement then
            return firstElement
        end
    end
    return self
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function TerrainLayerElement.new(target, custom_mt)
    local self = TerrainLayerElement:superClass().new(target, custom_mt or TerrainLayerElement _mt)

    self.terrainLayerTextureOverlay = nil

    return self
end

```

### setTerrainLayer

**Description**

> Set the terrain layer to render

**Definition**

> setTerrainLayer()

**Arguments**

| any | terrainRootNode |
|-----|-----------------|
| any | layer           |

**Code**

```lua
function TerrainLayerElement:setTerrainLayer(terrainRootNode, layer)
    if layer ~ = nil then
        if self.terrainLayerTextureOverlay = = nil then
            self:createOverlay(terrainRootNode)
        end

        local displayLayer = getTerrainLayerSubLayer(terrainRootNode, layer, 0 )
        setOverlayLayer( self.terrainLayerTextureOverlay, displayLayer)

        self.layer = layer
    end
end

```