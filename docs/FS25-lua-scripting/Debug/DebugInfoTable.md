## DebugInfoTable

**Parent**

> [DebugElement](?version=script&category=21&class=203)

**Functions**

- [renderAtPosition](#renderatposition)

### renderAtPosition

**Description**

> renderAtPosition

**Definition**

> renderAtPosition(float x, float y, float z, array information, float? rx, float? ry, float? rz, float? size, table?
> color)

**Arguments**

| float  | x           |                                                                                    |
|--------|-------------|------------------------------------------------------------------------------------|
| float  | y           |                                                                                    |
| float  | z           |                                                                                    |
| array  | information | array where entires are of structure {title="", content={{name, value}, ...}, ...} |
| float? | rx          | (optional)                                                                         |
| float? | ry          | (optional)                                                                         |
| float? | rz          | (optional)                                                                         |
| float? | size        | (optional)                                                                         |
| table? | color       | Color instance (optional)                                                          |

**Code**

```lua
function DebugInfoTable.renderAtPosition(x,y,z, information, rx,ry,rz, size, color)
    setTextDepthTestEnabled( false )
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
    if color ~ = nil then
        setTextColor(color:unpack())
    end
    setTextBold( false )

    if rx = = nil then
        rx,ry,rz = 0 , DebugUtil.getYRotatationToCamera(x,y,z), 0
    end

    size = size or 0.5

    local yOffset = 0
    for i = #information, 1 , - 1 do
        local info = information[i]
        local title = info.title
        local content = info.content

        for j = #content, 1 , - 1 do
            local pair = content[j]
            local key = pair.name
            local value = pair.value
            if pair.color ~ = nil then
                setTextColor(pair.color:unpack())
            end
            local lineSize = size * (pair.sizeFactor or 1 )

            setTextAlignment(RenderText.ALIGN_RIGHT)
            renderText3D(x, y + yOffset, z, rx, ry, rz, lineSize, key)
            setTextAlignment(RenderText.ALIGN_LEFT)
            if type(value) = = "number" then
                renderText3D(x, y + yOffset, z, rx,ry,rz, lineSize, " " .. string.format( "%.4f" , value))
            else
                    renderText3D(x, y + yOffset, z, rx,ry,rz, lineSize, " " .. tostring(value))
                end

                if pair.color ~ = nil then
                    setTextColor(color:unpack())
                end

                yOffset = yOffset + lineSize
            end

            setTextAlignment(RenderText.ALIGN_CENTER)
            setTextBold( true )
            renderText3D(x, y + yOffset, z, rx,ry,rz, size, title)
            setTextBold( false )
            setTextAlignment(RenderText.ALIGN_LEFT)
            yOffset = yOffset + 2 * size
        end

        setTextDepthTestEnabled( true )
    end

```