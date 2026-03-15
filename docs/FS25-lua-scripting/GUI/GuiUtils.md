## GuiUtils

**Description**

> GUI utility functions

**Functions**

- [checkOverlayOverlap](#checkoverlayoverlap)
- [getColorArray](#getcolorarray)
- [getColorGradientArray](#getcolorgradientarray)
- [getNormalizedValues](#getnormalizedvalues)
- [getUVs](#getuvs)

### checkOverlayOverlap

**Description**

> Check if a point lies within or a hotspot overlaps an overlay.

**Definition**

> checkOverlayOverlap(posX Point, posY Point, overlayX Overlay, overlayY Overlay, overlaySizeX Overlay, overlaySizeY
> Overlay, hotspot If)

**Arguments**

| posX         | Point   | or hotspot x position                                                                                                                                                                 |
|--------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| posY         | Point   | or hotspot y position                                                                                                                                                                 |
| overlayX     | Overlay | x position                                                                                                                                                                            |
| overlayY     | Overlay | y position                                                                                                                                                                            |
| overlaySizeX | Overlay | width                                                                                                                                                                                 |
| overlaySizeY | Overlay | height                                                                                                                                                                                |
| hotspot      | If      | provided as an array having 4 numbers for the bounding points of a rectangle {minX, minY, maxX, maxY}, will be checked if it overlaps the overlay area given by the other parameters. |

**Code**

```lua
function GuiUtils.checkOverlayOverlap(posX, posY, overlayX, overlayY, overlaySizeX, overlaySizeY, hotspot)
    if hotspot ~ = nil and #hotspot = = 4 then
        return overlaySizeX > 0 and overlaySizeY > 0
        and posX > = overlayX + hotspot[ 1 ]
        and posX < = overlayX + overlaySizeX + hotspot[ 3 ]
        and posY > = overlayY + hotspot[ 4 ]
        and posY < = overlayY + overlaySizeY + hotspot[ 2 ]
    else
            return overlaySizeX > 0 and overlaySizeY > 0
            and posX > = overlayX
            and posX < = overlayX + overlaySizeX
            and posY > = overlayY
            and posY < = overlayY + overlaySizeY
        end
    end

```

### getColorArray

**Description**

> Transform an attribute string representing a 4D color array into an actual array.

**Definition**

> getColorArray(str Attribute, defaultValue Default)

**Arguments**

| str          | Attribute | string containing exactly 4 numbers                                                |
|--------------|-----------|------------------------------------------------------------------------------------|
| defaultValue | Default   | value to return if the "str" parameter value is nil or invalid for transformation. |

**Return Values**

| defaultValue | list | of the 4 converted values as numbers: {red, green, blue, alpha} |
|--------------|------|-----------------------------------------------------------------|

**Code**

```lua
function GuiUtils.getColorArray(colorStr, defaultValue)
    return string.getVector(colorStr, 4 ) or defaultValue
end

```

### getColorGradientArray

**Description**

> Transform an attribute string representing a 4D color array into an actual array.

**Definition**

> getColorGradientArray(str Attribute, defaultValue Default)

**Arguments**

| str          | Attribute | string containing exactly 4 numbers                                                |
|--------------|-----------|------------------------------------------------------------------------------------|
| defaultValue | Default   | value to return if the "str" parameter value is nil or invalid for transformation. |

**Return Values**

| defaultValue | list | of the 4 converted values as numbers: {red, green, blue, alpha}, or 16 numbers: 4x rgba. |
|--------------|------|------------------------------------------------------------------------------------------|

**Code**

```lua
function GuiUtils.getColorGradientArray(colorStr, defaultValue)
    local data = string.getVector(colorStr)
    if data ~ = nil and(#data = = 4 or #data = = 16 ) then
        return data
    end
    return defaultValue
end

```

### getNormalizedValues

**Description**

> Transform an attribute string representing a list of numbers into an array and normalize the values.

**Definition**

> getNormalizedValues(str Attribute, refSize Reference, defaultValue Default)

**Arguments**

| str          | Attribute | string containing numbers, either raw or with a pixel unit designation on each number (e.g. "12 24" or "12px 24px") |
|--------------|-----------|---------------------------------------------------------------------------------------------------------------------|
| refSize      | Reference | size for normalization, e.g. a reference screen resolution used to scale pixel values, {sizeX, sizeY}               |
| defaultValue | Default   | value to return if the "str" parameter value is nil                                                                 |

**Return Values**

| defaultValue | list | of normalized values |
|--------------|------|----------------------|

**Code**

```lua
function GuiUtils.getNormalizedValues(data, refSize, defaultValue)
    if data ~ = nil then
        local parts = data
        local isString = type(data) = = "string"
        if isString then
            parts = data:split( " " )
        end
        local values = { }
        for k, part in pairs(parts) do
            local value = part

            if isString then
                local isPixelValue, isDisplayPixelValue = false , false
                if string.find(value, "px" ) ~ = nil then
                    isPixelValue = true
                    value = string.gsub(value, "px" , "" )
                elseif string.find(value, "dp" ) ~ = nil then
                        isDisplayPixelValue = true
                        value = string.gsub(value, "dp" , "" )
                    end

                    value = tonumber(value)

                    if isDisplayPixelValue then
                        local s = (k + 1 ) % 2
                        if s = = 0 then -- horizontal
                            value = value * g_pixelSizeX
                            else -- vertical
                                value = value * g_pixelSizeY
                            end
                        elseif isPixelValue then
                                -- refSize stores only 2 values(width, height).As str can contains more than 2 values we have to do a
                                    -- loop match with this modulo operation(1->1, 2->2, 3->1, 4->2, 5->1, 6->1 .. .)
                                    value = value / refSize[((k + 1 ) % 2 ) + 1 ]
                                end
                            else
                                    value = value / refSize[((k + 1 ) % 2 ) + 1 ]
                                end

                                table.insert(values, value)
                            end

                            if defaultValue ~ = nil and #defaultValue > #parts then
                                -- Repeat missing values, so that 0 -> 0 0 or 0 0 0 0, and 0 1 -> 0 1 0 1.
                                -- This is also what CSS effectively does
                                local wrap = #parts
                                for i = #parts + 1 , #defaultValue do
                                    table.insert(values, values[(i - 1 ) % wrap + 1 ])
                                end
                            end

                            return values
                        end

                        return defaultValue
                    end

```

### getUVs

**Description**

> Transform an attribute string representing a UV array into an actual array and normalize the values.

**Definition**

> getUVs(str Attribute, ref Texture, defaultValue Default, )

**Arguments**

| str          | Attribute | string containing exactly 4 numbers, order and format: "x[px] y[px] sizeX[px] sizeY[px]" |
|--------------|-----------|------------------------------------------------------------------------------------------|
| ref          | Texture   | reference size used to normalize pixel UV coordinates into unit sized UV coordinates     |
| defaultValue | Default   | value to return if the "str" parameter value is nil or invalid for transformation.       |
| any          | rotation  |                                                                                          |

**Return Values**

| any | list | of the UV coordinates as {u1, v1, u2, v2, u3, v3, u4, v4} |
|-----|------|-----------------------------------------------------------|

**Code**

```lua
function GuiUtils.getUVs(str, ref, defaultValue, rotation)
    if str ~ = nil then

        --#debug if type(str) = = "string" then
            --#debug local valid, errorMessage = GuiUtils.validateUvs(str)
            --#debug if not valid then
                --#debug Logging.error("%s; string: %s", errorMessage, str)
                --#debug printCallstack()
                --#debug return defaultValue
                --#debug end
                --#debug end

                local uvs = GuiUtils.getNormalizedValues(str, ref or { 1024 , 1024 } )
                if uvs[ 1 ] ~ = nil then
                    local result = { uvs[ 1 ], 1 - uvs[ 2 ] - uvs[ 4 ], uvs[ 1 ], 1 - uvs[ 2 ], uvs[ 1 ] + uvs[ 3 ], 1 - uvs[ 2 ] - uvs[ 4 ], uvs[ 1 ] + uvs[ 3 ], 1 - uvs[ 2 ] }

                    if rotation ~ = nil then
                        GuiUtils.rotateUVs(result, rotation)
                    end

                    return result
                else
                        Logging.devError( "GuiUtils.getUVs() Unable to get uvs for '%s'" , str)
                        end
                    end

                    return defaultValue
                end

```