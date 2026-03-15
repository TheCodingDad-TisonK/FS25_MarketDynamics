## DebugDensityMap

**Parent**

> [DebugElement](?version=script&category=21&class=199)

**Functions**

- [draw](#draw)

### draw

**Description**

> draw

**Definition**

> draw()

**Code**

```lua
function DebugDensityMap:draw()
    local resolution = self.resolution
    local colors = self.pixelValueToColor
    local radius = self.radius

    local steps = math.ceil(radius / resolution - resolution * 0.5 )

    local visualOffsetX = resolution * 0.5
    local visualOffsetZ = resolution * 0.5

    local x = self.centerX
    local z = self.centerZ

    if x = = nil then
        local _
        x, _, z = getWorldTranslation(g_cameraManager:getActiveCamera())
    end

    x = math.floor(x / self.resolution) * self.resolution
    z = math.floor(z / self.resolution) * self.resolution

    local densityOffsetX = resolution * 0.1
    local densityOffsetZ = resolution * 0.1

    for xStep = 1 , steps do
        for zStep = 1 , steps do
            local startWorldX = x + (xStep - steps * 0.5 ) * resolution
            local startWorldZ = z + (zStep - steps * 0.5 ) * resolution
            local widthWorldX = x + (xStep + 1 - steps * 0.5 ) * resolution
            local widthWorldZ = z + (zStep - steps * 0.5 ) * resolution
            local heightWorldX = x + (xStep - steps * 0.5 ) * resolution
            local heightWorldZ = z + (zStep + 1 - steps * 0.5 ) * resolution

            local dStartWorldX = startWorldX + densityOffsetX
            local dStartWorldZ = startWorldZ + densityOffsetZ
            local dWidthWorldX = widthWorldX - densityOffsetX
            local dWidthWorldZ = widthWorldZ + densityOffsetZ
            local dHeightWorldX = heightWorldX + densityOffsetX
            local dHeightWorldZ = heightWorldZ - densityOffsetZ

            self.modifier:setParallelogramWorldCoords(dStartWorldX, dStartWorldZ, dWidthWorldX, dWidthWorldZ, dHeightWorldX, dHeightWorldZ, DensityCoordType.POINT_POINT_POINT)

            for i = 0 , ( 2 ^ self.numChannels) - 1 do
                self.filter:setValueCompareParams(DensityValueCompareType.EQUAL, i)
                local _, numPixels, _ = self.modifier:executeGet( self.filter)

                if numPixels > 0 then
                    local vStartWorldX = startWorldX + resolution * 0.1 - visualOffsetX
                    local vStartWorldZ = startWorldZ + resolution * 0.1 - visualOffsetZ
                    local vWidthWorldX = widthWorldX - resolution * 0.1 - visualOffsetX
                    local vWidthWorldZ = widthWorldZ + resolution * 0.1 - visualOffsetZ
                    local vHeightWorldX = heightWorldX + resolution * 0.1 - visualOffsetX
                    local vHeightWorldZ = heightWorldZ - resolution * 0.1 - visualOffsetZ

                    local color = colors[i]
                    if color ~ = nil then
                        self:drawDebugAreaRectangleFilled(vStartWorldX, vStartWorldZ, vWidthWorldX, vWidthWorldZ, vHeightWorldX, vHeightWorldZ, color)
                    end

                    local centerX = (vStartWorldX + vWidthWorldX) * 0.5
                    local centerZ = (vStartWorldZ + vHeightWorldZ) * 0.5
                    local centerY = getTerrainHeightAtWorldPos(g_terrainNode, centerX, 0 , centerZ) + self.yOffset

                    Utils.renderTextAtWorldPosition(centerX, centerY, centerZ, tostring(i), 0.012 , 0 , self.textColor)

                    break
                end
            end
        end
    end

    if self.displayLegend then
        local legendEntryOffset = 0
        local fontSize = 0.015
        local colorBoxHeight = getTextHeight(fontSize, "1" ) * 0.9
        setTextAlignment(RenderText.ALIGN_LEFT)
        renderText( 0.01 , 0.7 , fontSize, "DebugDensityMap colors" )
        legendEntryOffset = legendEntryOffset + 1.1 * fontSize
        -- TODO:add proper sorting
        for pixelValue, color in pairs(colors) do
            -- TODO:add support for value to text/desc display
                drawFilledRect( 0.013 , 0.7 - legendEntryOffset , colorBoxHeight, colorBoxHeight, color[ 1 ], color[ 2 ], color[ 3 ], math.max(color[ 4 ], 0.5 ))
                renderText( 0.013 + colorBoxHeight * 1.2 , 0.7 - legendEntryOffset, fontSize, string.format( "%d" , pixelValue))
                legendEntryOffset = legendEntryOffset + fontSize
            end
        end
    end

```