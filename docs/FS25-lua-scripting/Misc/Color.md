## Color

**Description**

> A class holding 4 values representing a color, with functions for converting to and from multiple formats, and an
> indexer supporting numeric indexing and swizzling.

**Functions**

- [blend](#blend)
- [copy](#copy)
- [copyTo](#copyto)
- [fromHex](#fromhex)
- [fromPackedValue](#frompackedvalue)
- [fromPresetName](#frompresetname)
- [fromRGBA](#fromrgba)
- [fromVector](#fromvector)
- [fromVectorRGBA](#fromvectorrgba)
- [new](#new)
- [parseFromString](#parsefromstring)
- [swizzle](#swizzle)
- [toHex](#tohex)
- [toPackedValue](#topackedvalue)
- [toVector3](#tovector)
- [toVector4](#tovector)
- [toVectorRGB](#tovectorrgb)
- [toVectorRGBA](#tovectorrgba)
- [unpack](#unpack)
- [unpack3](#unpack)
- [unpackRGBA](#unpackrgba)
- [writeStreamRGB](#writestreamrgb)

### blend

**Description**

> Blends the two colors together, returning the result.

**Definition**

> blend(Color first, Color second, float alpha)

**Arguments**

| Color | first  | The first color value.                                                                     |
|-------|--------|--------------------------------------------------------------------------------------------|
| Color | second | The second color value.                                                                    |
| float | alpha  | The blend amount, where 0 is equal to the first color, and 1 is equal to the second color. |

**Return Values**

| float | blendedColor | The resulting color. |
|-------|--------------|----------------------|

**Code**

```lua
function Color.blend(first, second, alpha)
    --#debug Assert.isClass(first, Color, "Given first color was not a Color type!")
    --#debug Assert.isClass(second, Color, "Given second color was not a Color type!")
    --#debug Assert.isType(alpha, "number", "Given alpha was not a number!")
    return Color.new( MathUtil.lerp(first.r, second.r, alpha), MathUtil.lerp(first.g, second.g, alpha), MathUtil.lerp(first.b, second.b, alpha), MathUtil.lerp(first.a, second.a, alpha))
end

```

### copy

**Description**

> Returns a copy of this color.

**Definition**

> copy()

**Return Values**

| float | copy | The copied color. |
|-------|------|-------------------|

**Code**

```lua
function Color:copy()
    return Color.new( self.r, self.g, self.b, self.a)
end

```

### copyTo

**Description**

> Copies this color's values into the given color.

**Definition**

> copyTo(Color color)

**Arguments**

| Color | color | The color into which to copy the values. |
|-------|-------|------------------------------------------|

**Code**

```lua
function Color:copyTo(color)
    color.r, color.g, color.b, color.a = self.r, self.g, self.b, self.a
end

```

### fromHex

**Description**

> Creates a color from the given hex code, with or without the preceeding '#' character.

**Definition**

> fromHex(string hexString)

**Arguments**

| string | hexString | The hex string to turn into a color. |
|--------|-----------|--------------------------------------|

**Return Values**

| string | color | The created color. |
|--------|-------|--------------------|

**Code**

```lua
function Color.fromHex(hexString)

    -- If the given value is not a string, do nothing.
        if type(hexString) ~ = "string" then
            return nil
        end

        -- If the given value is a string and begins with '#' as many color codes do, remove it.
            if type(hexString) = = "string" and string.startsWith(hexString, '#') then
                hexString = string.sub(hexString, 2 )
            end

            -- Read the hex string has a hex value.If it failed to parse, return nil.
            local packedValue = tonumber(hexString, 16 )
            if packedValue = = nil then
                return nil
            end

            -- Create the color from a packed value.
            return Color.fromPackedValue(packedValue)
        end

```

### fromPackedValue

**Description**

> Creates a new color from the given 32-bit packed color.

**Definition**

> fromPackedValue(integer packedValue)

**Arguments**

| integer | packedValue | The 32-bit integer value from which to unpack the color. |
|---------|-------------|----------------------------------------------------------|

**Return Values**

| integer | color | The created color. |
|---------|-------|--------------------|

**Code**

```lua
function Color.fromPackedValue(packedValue)

    -- If the given type is a string, turn it into a number.
    if type(packedValue) = = "string" then
        packedValue = tonumber(packedValue)
    end

    -- If the given type is not a number, return nil.
    if type(packedValue) ~ = "number" then
        return nil
    end

    -- Unpack the individual channels from the packed value and normalise them between 0 and 1.
    local r = bit32.band(packedValue, 0x000000ff) / 255
    local g = bit32.rshift(bit32.band(packedValue, 0x0000ff00), 8 ) / 255
    local b = bit32.rshift(bit32.band(packedValue, 0x00ff0000 ), 16 ) / 255
    local a = bit32.rshift(bit32.band(packedValue, 0xff000000 ), 24 ) / 255

    -- Return the unpacked color.
    return Color.new(r, g, b, a)
end

```

### fromPresetName

**Description**

> Gets the preset from the given name, case insensitive. See Color.PRESETS.

**Definition**

> fromPresetName(string presetName)

**Arguments**

| string | presetName | The name of the preset to get. |
|--------|------------|--------------------------------|

**Return Values**

| string | preset | The preset with the given name, or nil if none was found. |
|--------|--------|-----------------------------------------------------------|

**Code**

```lua
function Color.fromPresetName(presetName)

    -- If the given name is not a string, do nothing.
        if type(presetName) ~ = "string" then
            return nil
        end

        -- Return the preset with the given name in capitals.
        return Color.PRESETS[ string.upper(presetName)]
    end

```

### fromRGBA

**Description**

> Creates a new color from the given RGBA values from 0 to 255.

**Definition**

> fromRGBA(integer r, integer g, integer b, integer? a)

**Arguments**

| integer  | r | The red value. Defaults to 0.     |
|----------|---|-----------------------------------|
| integer  | g | The green value. Defaults to 0.   |
| integer  | b | The blue value. Defaults to 0.    |
| integer? | a | The alpha value. Defaults to 255. |

**Return Values**

| integer? | color | The created color. |
|----------|-------|--------------------|

**Code**

```lua
function Color.fromRGBA(r, g, b, a)
    return Color.new((r or 0 ) / 255 , (g or 0 ) / 255 , (b or 0 ) / 255 , (a or 255 ) / 255 )
end

```

### fromVector

**Description**

> Creates a color from the given array-styled vector. Where each numeric index is a channel from 0 to 1.

**Definition**

> fromVector(table vector, integer? minLength, integer? maxLength)

**Arguments**

| table    | vector    | The vector to create the color from.                                                                                                                              |
|----------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| integer? | minLength | The optional minimum length. If the given vector has fewer elements than this length, nil will be returned. If no minimum length is given, no check will be made. |
| integer? | maxLength | The optional maximum length. All elements in the given vector past this count will be ignored and set to a default value.                                         |

**Return Values**

| integer? | color | The created color. |
|----------|-------|--------------------|

**Code**

```lua
function Color.fromVector(vector, minLength, maxLength)

    -- Check the validity of the given vector.If it is invalid, return nil.
    if type(vector) ~ = "table" or(minLength ~ = nil and #vector < minLength) then
        return nil
    end

    -- Default the max length to the count of the vector.
    maxLength = maxLength or #vector

    -- Return the color.
    return Color.new( 1 < = maxLength and vector[ 1 ] or 0 , 2 < = maxLength and vector[ 2 ] or 0 , 3 < = maxLength and vector[ 3 ] or 0 , 4 < = maxLength and vector[ 4 ] or 1 )
end

```

### fromVectorRGBA

**Description**

> Creates a new color from the RGBA values from 0 to 255 in the given vector. See Color.fromRGBA(r, g, b, a)

**Definition**

> fromVectorRGBA(table vector, integer? minLength, integer? maxLength)

**Arguments**

| table    | vector    | The vector color, where each element is a number ranging from 0 to 255.                                                                                           |
|----------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| integer? | minLength | The optional minimum length. If the given vector has fewer elements than this length, nil will be returned. If no minimum length is given, no check will be made. |
| integer? | maxLength | The optional maximum length. All elements in the given vector past this count will be ignored and set to a default value.                                         |

**Return Values**

| integer? | color | The created color. |
|----------|-------|--------------------|

**Code**

```lua
function Color.fromVectorRGBA(vector, minLength, maxLength)

    -- Check the validity of the given vector.If it is invalid, return nil.
    if type(vector) ~ = "table" or(minLength ~ = nil and #vector < minLength) then
        return nil
    end

    -- Default the max length to the count of the vector.
    maxLength = maxLength or #vector

    -- Return the color from RGBA.
    return Color.fromRGBA( 1 < = maxLength and vector[ 1 ] or 0 , 2 < = maxLength and vector[ 2 ] or 0 , 3 < = maxLength and vector[ 3 ] or 0 , 4 < = maxLength and vector[ 4 ] or 255 )
end

```

### new

**Description**

> Creates a new color from the given channels, from 0 to 1.

**Definition**

> new(float r, float g, float b, float? a)

**Arguments**

| float  | r | The red channel.   |
|--------|---|--------------------|
| float  | g | The green channel. |
| float  | b | The blue channel.  |
| float? | a | The alpha channel. |

**Return Values**

| float? | self | The created instance. |
|--------|------|-----------------------|

**Code**

```lua
function Color.new(r, g, b, a)

    --#debug Assert.isNilOrType(r, "number", "Red channel was not number or nil!")
    --#debug Assert.isNilOrType(g, "number", "Green channel was not number or nil!")
    --#debug Assert.isNilOrType(b, "number", "Blue channel was not number or nil!")
    --#debug Assert.isNilOrType(a, "number", "Alpha channel was not number or nil!")

    -- Create the instance.
    local self = setmetatable( { } , Color _mt)

    -- Set the color channels, defaulting to solid black.
    self.r = r or 0
    self.g = g or 0
    self.b = b or 0
    self.a = a or 1

    --#debug Assert.isBetween(self.r, 0, 1, nil, nil, "Red channel was out of range!")
    --#debug Assert.isBetween(self.g, 0, 1, nil, nil, "Green channel was out of range!")
    --#debug Assert.isBetween(self.b, 0, 1, nil, nil, "Blue channel was out of range!")
    --#debug Assert.isBetween(self.a, 0, 1, nil, nil, "Alpha channel was out of range!")

    -- Return the created instance.
    return self
end

```

### parseFromString

**Description**

> Attempts to parse the given string as a color. Attempting; in the following order: hex, preset, brand color (if
> g\_vehicleMaterialManager is not nil), packed value, then vector value, then finally nil.

**Definition**

> parseFromString(string inputString, boolean? ignoreAlpha)

**Arguments**

| string   | inputString | The string input to parse.                                      |
|----------|-------------|-----------------------------------------------------------------|
| boolean? | ignoreAlpha | If this is true, alpha will not be included in the final color. |

**Return Values**

| boolean? | color | The parsed color, or nil if the string could not be parsed. |
|----------|-------|-------------------------------------------------------------|

**Code**

```lua
function Color.parseFromString(inputString, ignoreAlpha)

    -- If the given input is not a string, do nothing.
        if type(inputString) ~ = "string" then
            return nil
        end

        -- If the string starts with a hash '#' character, then parse it as a hex value.
        if string.startsWith(inputString, '#') then
            return Color.fromHex(inputString)
        end
        -- Try to parse the string as a packed value.If it's a valid packed value color, return it.
        local color = Color.fromPackedValue(inputString)
        if color ~ = nil then
            if ignoreAlpha then
                color.a = 1
            end
            return color
        end

        -- Try to parse the string as a vector, then the vector as a color.If it's a valid RGBA vector color, return it.
        local vector = string.split(inputString, " " , tonumber )
        if #vector > = 3 then
            if ignoreAlpha then
                return Color.new(vector[ 1 ], vector[ 2 ], vector[ 3 ])
            else
                    return Color.new(vector[ 1 ], vector[ 2 ], vector[ 3 ], vector[ 4 ])
                end
            end

            -- If there is a brand color manager and it contains a color with the given string as a name, return it.
            if g_vehicleMaterialManager ~ = nil then
                color = Color.fromVector(g_vehicleMaterialManager:getMaterialTemplateColorByName(inputString), nil , 3 )
                if color ~ = nil then
                    if ignoreAlpha then
                        color.a = 1
                    end
                    return color
                end
            end

            -- If there is a preset with the given string as a name, return it.
            color = Color.fromPresetName(inputString)
            if color ~ = nil then
                if ignoreAlpha then
                    color.a = 1
                end
                return color
            end

            -- The input string was not valid, so return nil.
            return nil
        end

```

### swizzle

**Description**

> Returns the swizzled vector from the color using the given key.

**Definition**

> swizzle(string key)

**Arguments**

| string | key | The key to swizzle from. Should be a string between 1 and 4 characters in length. |
|--------|-----|-----------------------------------------------------------------------------------|

**Return Values**

| string | swizzledVector | The swizzled vector from the given key, or nil if the key included an invalid character. |
|--------|----------------|------------------------------------------------------------------------------------------|

**Code**

```lua
function Color:swizzle(key)

    -- Ensure the key is valid and of valid length.
    if type(key) ~ = "string" then
        return nil
    end
    local swizzleLength = string.len(key)
    if swizzleLength > 4 or swizzleLength < = 0 then
        return nil
    end

    -- Go over each character in the given string.
    local swizzleVector = { }
    for i = 1 , swizzleLength do

        -- Get the color with the given character.Return nil if it was nil.
            local swizzleValue = rawget( self , string.sub(key, i, i))
            if swizzleValue = = nil then
                return nil
            end

            -- Add the value to the swizzle vector.
            swizzleVector[i] = swizzleValue
        end

        -- Return the created vector.
        return swizzleVector
    end

```

### toHex

**Description**

> Converts this color into a hex code, with or without the preceeding '#' character based on the given includeHash
> parameter.

**Definition**

> toHex(boolean includeHash)

**Arguments**

| boolean | includeHash | If this evaluates to true, the given hex code will start with a '#' character. Otherwise it will be a plain hex value. |
|---------|-------------|------------------------------------------------------------------------------------------------------------------------|

**Return Values**

| boolean | hexString | The calculated hex string representing the color. |
|---------|-----------|---------------------------------------------------|

**Code**

```lua
function Color:toHex(includeHash)

    local packedValue = self:toPackedValue()
    return string.format( "%s%x" , (includeHash and '#' or "" ), packedValue)
end

```

### toPackedValue

**Description**

> Creates a 32-bit packed integer value from this color.

**Definition**

> toPackedValue()

**Return Values**

| boolean | packedValue | The 32-bit integer packed value. |
|---------|-------------|----------------------------------|

**Code**

```lua
function Color:toPackedValue()

    -- Pack each channel into the value and return it.
    local packedValue = math.ceil( self.r * 255 )
    packedValue = bit32.bor(packedValue, bit32.lshift( math.ceil( self.g * 255 ), 8 ))
    packedValue = bit32.bor(packedValue, bit32.lshift( math.ceil( self.b * 255 ), 16 ))
    packedValue = bit32.bor(packedValue, bit32.lshift( math.ceil( self.a * 255 ), 24 ))
    return packedValue
end

```

### toVector3

**Description**

> Returns this color as a vector3 (rgb).

**Definition**

> toVector3()

**Return Values**

| boolean | vector3 | The color as a vector3 (rgb). |
|---------|---------|-------------------------------|

**Code**

```lua
function Color:toVector3()
    return { self.r, self.g, self.b }
end

```

### toVector4

**Description**

> Returns this color as a vector4 (rgba).

**Definition**

> toVector4()

**Return Values**

| boolean | vector4 | The color as a vector4 (rgba). |
|---------|---------|--------------------------------|

**Code**

```lua
function Color:toVector4()
    return { self.r, self.g, self.b, self.a }
end

```

### toVectorRGB

**Description**

> Creates an RGB color array from the color, where each channel is between 0 and 255.

**Definition**

> toVectorRGB()

**Return Values**

| boolean | vectorRGB | The RGB vector. |
|---------|-----------|-----------------|

**Code**

```lua
function Color:toVectorRGB()
    return { math.ceil( self.r * 255 ), math.ceil( self.g * 255 ), math.ceil( self.b * 255 ) }
end

```

### toVectorRGBA

**Description**

> Creates an RGBA color array from the color, where each channel is between 0 and 255.

**Definition**

> toVectorRGBA()

**Return Values**

| boolean | vectorRGBA | The RGBA vector. |
|---------|------------|------------------|

**Code**

```lua
function Color:toVectorRGBA()
    return { math.ceil( self.r * 255 ), math.ceil( self.g * 255 ), math.ceil( self.b * 255 ), math.ceil( self.a * 255 ) }
end

```

### unpack

**Description**

> Unpacks this color into its seperate rgba channels from 0 to 1.

**Definition**

> unpack()

**Return Values**

| boolean | r | The red value.   |
|---------|---|------------------|
| boolean | g | The green value. |
| boolean | b | The blue value.  |
| boolean | a | The alpha value. |

**Code**

```lua
function Color:unpack()
    return self.r, self.g, self.b, self.a
end

```

### unpack3

**Description**

> Unpacks this color into its separate rgb channels from 0 to 1.

**Definition**

> unpack3()

**Return Values**

| boolean | r | The red value.   |
|---------|---|------------------|
| boolean | g | The green value. |
| boolean | b | The blue value.  |

**Code**

```lua
function Color:unpack3()
    return self.r, self.g, self.b
end

```

### unpackRGBA

**Description**

> Unpacks this color into its seperate rgba channels from 0 to 255.

**Definition**

> unpackRGBA()

**Return Values**

| boolean | r | The red value.   |
|---------|---|------------------|
| boolean | g | The green value. |
| boolean | b | The blue value.  |
| boolean | a | The alpha value. |

**Code**

```lua
function Color:unpackRGBA()
    return math.ceil( self.r * 255 ), math.ceil( self.g * 255 ), math.ceil( self.b * 255 ), math.ceil( self.a * 255 )
end

```

### writeStreamRGB

**Description**

> Writes the given color to the network stream with a 10 bit precision

**Definition**

> writeStreamRGB(integer streamId, float r, float g, float b)

**Arguments**

| integer | streamId | The stream to write to |
|---------|----------|------------------------|
| float   | r        | red value              |
| float   | g        | green value            |
| float   | b        | blue value             |

**Code**

```lua
function Color.writeStreamRGB(streamId, r, g, b)
    streamWriteUIntN(streamId, math.clamp(r, 0 , 1 ) * 1023 , 10 )
    streamWriteUIntN(streamId, math.clamp(g, 0 , 1 ) * 1023 , 10 )
    streamWriteUIntN(streamId, math.clamp(b, 0 , 1 ) * 1023 , 10 )
end

```