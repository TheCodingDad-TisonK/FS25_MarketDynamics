## DebugPolygon

**Parent**

> [DebugElement](?version=script&category=21&class=209)

**Functions**

- [draw](#draw)
- [renderWithPositions](#renderwithpositions)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugPolygon:draw()
    DebugPolygon.renderWithPositions( self.positions, self.color, self.solid, self.drawContour)
end

```

### renderWithPositions

**Description**

**Definition**

> renderWithPositions(array positions, table? color, boolean? solid, )

**Arguments**

| array    | positions   | polygon vertex positions in format: x1,y1,z1, x2,y2,z2, ... |
|----------|-------------|-------------------------------------------------------------|
| table?   | color       | Color instance, default WHITE (optional)                    |
| boolean? | solid       | (optional)                                                  |
| any      | drawContour |                                                             |

**Code**

```lua
function DebugPolygon.renderWithPositions(positions, color, solid, drawContour)
    local r,g,b,a = (color or Color.PRESETS.WHITE):unpack()
    solid = Utils.getNoNil(solid, false )

    drawDebugPolygon(positions, r, g, b, a, solid)

    if drawContour then
        for i = 1 , #positions, 3 do
            if i + 3 < #positions then
                -- edge between intermediate vertices
                drawDebugLine(positions[i], positions[i + 1 ], positions[i + 2 ], r,g,b, positions[i + 3 ], positions[i + 4 ], positions[i + 5 ], r,g,b,solid)
            else
                    -- last edge from last vertex to first vertex
                    drawDebugLine(positions[i], positions[i + 1 ], positions[i + 2 ], r,g,b, positions[ 1 ], positions[ 2 ], positions[ 3 ], r,g,b,solid)
                end
            end
        end
    end

```