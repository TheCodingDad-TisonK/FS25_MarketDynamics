## LicensePlate

**Description**

> This class manages a single license plate

**Functions**

- [changeCharacter](#changecharacter)
- [clone](#clone)
- [delete](#delete)
- [getColor](#getcolor)
- [getFontSize](#getfontsize)
- [getFormattedString](#getformattedstring)
- [getRandomCharacters](#getrandomcharacters)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setColor](#setcolor)
- [setColorIndex](#setcolorindex)
- [setVariation](#setvariation)
- [updateData](#updatedata)
- [validateLicensePlateCharacters](#validatelicenseplatecharacters)

### changeCharacter

**Description**

> Change license plate character in given direction

**Definition**

> changeCharacter(integer variationIndex, table currentCharacters, integer valueIndex, integer direction)

**Arguments**

| integer | variationIndex    | variation index   |
|---------|-------------------|-------------------|
| table   | currentCharacters | current character |
| integer | valueIndex        | value index       |
| integer | direction         | direction         |

**Return Values**

| integer | currentCharacters |
|---------|-------------------|

**Code**

```lua
function LicensePlate:changeCharacter(variationIndex, currentCharacters, valueIndex, direction)
    local variation = self.variations[variationIndex]
    if variation ~ = nil then
        local value = variation.values[valueIndex]
        local currentCharacter = currentCharacters[value.realIndex]

        local sourceCharactersSources = { }
        if value.alphabetical then
            table.insert(sourceCharactersSources, self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL])
        end
        if value.numerical then
            table.insert(sourceCharactersSources, self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.NUMERICAL])
        end
        if value.special then
            table.insert(sourceCharactersSources, self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.SPECIAL])
        end

        local newSource
        local newIndex = 1
        for j = 1 , #sourceCharactersSources do
            local source = sourceCharactersSources[j]

            for i = 1 , #source do
                local sourceCharacter = source[i]
                if sourceCharacter.value = = currentCharacter then
                    newIndex = i + direction
                    if newIndex > #source then
                        local nextSource = sourceCharactersSources[j + 1 ]
                        if nextSource ~ = nil then
                            newIndex = 1
                            newSource = nextSource
                        else
                                newIndex = #source
                                newSource = source
                            end
                        elseif newIndex < 1 then
                                local prevSource = sourceCharactersSources[j - 1 ]
                                if prevSource ~ = nil then
                                    newIndex = #prevSource
                                    newSource = prevSource
                                else
                                        newIndex = 1
                                        newSource = source
                                    end
                                else
                                        newSource = source
                                    end
                                end
                            end
                        end

                        if newSource ~ = nil then
                            if newSource[newIndex] ~ = nil then
                                currentCharacters[value.realIndex] = newSource[newIndex].value
                            end
                        end
                    end

                    return currentCharacters
                end

```

### clone

**Description**

**Definition**

> clone(boolean includeFrame)

**Arguments**

| boolean | includeFrame |
|---------|--------------|

**Return Values**

| boolean | licensePlateClone |
|---------|-------------------|

**Code**

```lua
function LicensePlate:clone(includeFrame)
    local licensePlateClone = LicensePlate.new()

    licensePlateClone.node = clone( self.node, false , false , false )

    licensePlateClone.type = self.type
    licensePlateClone.filename = self.filename
    licensePlateClone.width = self.width
    licensePlateClone.height = self.height
    licensePlateClone.fontSize = self.fontSize
    licensePlateClone.fontUseNormalMap = self.fontUseNormalMap
    licensePlateClone.fontScaleX = self.fontScaleX
    licensePlateClone.fontScaleY = self.fontScaleY

    licensePlateClone.rawWidth = self.width
    licensePlateClone.rawHeight = self.height

    licensePlateClone.widthOffsetLeft = 0
    licensePlateClone.widthOffsetRight = 0
    licensePlateClone.heightOffsetTop = 0
    licensePlateClone.heightOffsetBot = 0

    licensePlateClone.font = self.font
    licensePlateClone.fontMaxWidthRatio = self.fontMaxWidthRatio

    licensePlateClone.variations = table.clone( self.variations, 10 )
    for i = 1 , #licensePlateClone.variations do
        local variation = licensePlateClone.variations[i]
        for j = 1 , #variation.values do
            local value = variation.values[j]
            value.node = I3DUtil.indexToObject(licensePlateClone.node, value.nodePath)
        end
    end

    licensePlateClone.frame = table.clone( self.frame, 10 )
    if licensePlateClone.frame ~ = nil then
        includeFrame = includeFrame = = true
        local frameNode = I3DUtil.indexToObject(licensePlateClone.node, licensePlateClone.frame.node)
        if frameNode ~ = nil then
            setVisibility(frameNode, includeFrame)

            if includeFrame then
                licensePlateClone.width = licensePlateClone.width + 2 * licensePlateClone.frame.widthOffset
                licensePlateClone.height = licensePlateClone.height + licensePlateClone.frame.heightOffsetTop + licensePlateClone.frame.heightOffsetBot

                licensePlateClone.widthOffsetLeft = licensePlateClone.frame.widthOffset
                licensePlateClone.widthOffsetRight = licensePlateClone.frame.widthOffset
                licensePlateClone.heightOffsetTop = licensePlateClone.frame.heightOffsetTop
                licensePlateClone.heightOffsetBot = licensePlateClone.frame.heightOffsetBot
            end
        end
    end

    licensePlateClone:setVariation( self.variationIndex, self.position)

    return licensePlateClone
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function LicensePlate:delete()
    delete( self.node)
end

```

### getColor

**Description**

> Get color of license plate

**Definition**

> getColor(integer colorIndex)

**Arguments**

| integer | colorIndex |
|---------|------------|

**Return Values**

| integer | color |
|---------|-------|

**Code**

```lua
function LicensePlate:getColor(colorIndex)
    local colors, _ = self.manager:getAvailableColors()
    local colorData = colors[colorIndex]
    if colorData ~ = nil then
        return colorData.color
    end

    return nil
end

```

### getFontSize

**Description**

**Definition**

> getFontSize()

**Return Values**

| integer | maxWidth |
|---------|----------|
| integer | fontSize |

**Code**

```lua
function LicensePlate:getFontSize()
    return self.fontSize * self.fontMaxWidthRatio, self.fontSize
end

```

### getFormattedString

**Description**

**Definition**

> getFormattedString()

**Return Values**

| integer | formattedString |
|---------|-----------------|

**Code**

```lua
function LicensePlate:getFormattedString()
    if self.characters = = "" then
        return nil
    end

    local str = ""
    local variation = self.variations[ self.variationIndex]
    if variation ~ = nil then
        for i = 1 , #variation.values do
            local value = variation.values[i]
            if not value.isStatic then
                local char = self.characters:sub(i, i) or ""
                if char ~ = "_" then
                    if value.nextSection then
                        str = str .. " " .. char
                    else
                            str = str .. char
                        end
                    end
                end
            end
        end

        return str
    end

```

### getRandomCharacters

**Description**

> Returns a random character table for given variation

**Definition**

> getRandomCharacters(integer variationIndex)

**Arguments**

| integer | variationIndex | variation index |
|---------|----------------|-----------------|

**Return Values**

| integer | characters | table with characters |
|---------|------------|-----------------------|

**Code**

```lua
function LicensePlate:getRandomCharacters(variationIndex)
    local characters = { }

    local firstNumericCharacter = true
    local variation = self.variations[variationIndex]
    if variation ~ = nil then
        for i = 1 , #variation.values do
            local value = variation.values[i]

            if not value.isStatic then
                if value.character = = nil then
                    local random = math.random()

                    local sourceCharacters = self.font.characters
                    if value.alphabetical then
                        sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL]
                    elseif value.numerical then
                            sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.NUMERICAL]
                        elseif value.special then
                                sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.SPECIAL]
                            end

                            if sourceCharacters ~ = nil and #sourceCharacters > 0 then
                                local index = math.max( math.floor( random * #sourceCharacters), 1 )

                                -- special case for numbers -> never start with leading zero
                                    if value.numerical and firstNumericCharacter then
                                        if index = = 1 and #sourceCharacters > 1 then
                                            index = 2
                                        end
                                        firstNumericCharacter = false
                                    end

                                    table.insert(characters, sourceCharacters[index].value)
                                else
                                        table.insert(characters, "0" )
                                    end
                                else
                                        table.insert(characters, value.character)
                                    end
                                end
                            end
                        end

                        return characters
                    end

```

### loadFromXML

**Description**

> Load data on map load

**Definition**

> loadFromXML(entityId node, string filename, any customEnvironment, XMLFile xmlFile, string key)

**Arguments**

| entityId | node              |
|----------|-------------------|
| string   | filename          |
| any      | customEnvironment |
| XMLFile  | xmlFile           |
| string   | key               |

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function LicensePlate:loadFromXML(node, filename, customEnvironment, xmlFile, key)
    local typeStr = xmlFile:getValue(key .. "#type" , "ELONGATED" )
    if typeStr ~ = nil then
        self.type = LicensePlateManager.PLATE_TYPE[typeStr]
        if self.type ~ = nil then
            self.node = node
            self.filename = filename
            self.width = xmlFile:getValue(key .. "#width" , 1 )
            self.height = xmlFile:getValue(key .. "#height" , 0.3 )
            self.fontSize = xmlFile:getValue(key .. ".font#size" , 0.1 )
            self.fontUseNormalMap = xmlFile:getValue(key .. ".font#useNormalMap" , true )
            self.fontScaleX = xmlFile:getValue(key .. ".font#scaleX" , 1 )
            self.fontScaleY = xmlFile:getValue(key .. ".font#scaleY" , 1 )

            self.widthOffsetLeft = 0
            self.widthOffsetRight = 0
            self.heightOffsetTop = 0
            self.heightOffsetBot = 0

            self.font = g_licensePlateManager:getFont()

            if self.font = = nil then
                Logging.error( "LicensePlate:Unable to get font from LicensePlateManager, possibly not initialized/loaded yet" )
                printCallstack()
                return false
            end
            self.fontMaxWidthRatio = self.font:getFontMaxWidthRatio()

            self.variations = { }
            xmlFile:iterate(key .. ".variations.variation" , function (_, variationKey)
                local variation = { }
                variation.values = { }

                local realIndex = 0
                xmlFile:iterate(variationKey .. ".value" , function (index, valueKey)
                    local value = { }
                    value.index = index
                    value.realIndex = realIndex + 1
                    value.nodePath = xmlFile:getValue(valueKey .. "#node" )
                    value.node = I3DUtil.indexToObject( self.node, value.nodePath)
                    value.nextSection = xmlFile:getValue(valueKey .. "#nextSection" , false )
                    if value.nodePath ~ = nil and value.node ~ = nil then
                        local x, y, z = getTranslation(value.node)
                        value.posX = xmlFile:getValue(valueKey .. "#posX" , x)
                        value.posY = xmlFile:getValue(valueKey .. "#posY" , y)
                        value.posZ = xmlFile:getValue(valueKey .. "#posZ" , z)

                        value.character = xmlFile:getValue(valueKey .. "#character" )
                        value.numerical = xmlFile:getValue(valueKey .. "#numerical" , false )
                        value.alphabetical = xmlFile:getValue(valueKey .. "#alphabetical" , false )
                        value.special = xmlFile:getValue(valueKey .. "#special" , false )
                        value.isStatic = xmlFile:getValue(valueKey .. "#isStatic" , not value.numerical and not value.alphabetical and not value.special and value.character = = nil )
                        value.locked = xmlFile:getValue(valueKey .. "#locked" , value.character ~ = nil )

                        value.maxWidthRatio = self.font:getFontMaxWidthRatio(value.alphabetical, value.numerical, value.special)

                        local positionStr = xmlFile:getValue(valueKey .. "#position" , "ANY" )
                        local position = LicensePlateManager.PLATE_POSITION[ string.upper(positionStr)]
                        if position = = nil then
                            Logging.xmlError(xmlFile, "Unknown position '%s' in '%s'" , positionStr, valueKey)
                        end
                        value.position = position or LicensePlateManager.PLATE_POSITION.ANY

                        if not value.isStatic then
                            realIndex = realIndex + 1
                        end

                        I3DUtil.setShapeCastShadowmapRec(value.node, false )

                        table.insert(variation.values, value)
                    end
                end )

                variation.materials = { }
                xmlFile:iterate(variationKey .. ".material" , function (_, materialKey)
                    local material = VehicleMaterial.new()
                    if material:loadFromXML(xmlFile, materialKey, customEnvironment) then
                        local positionStr = xmlFile:getValue(materialKey .. "#position" , "ANY" )
                        local position = LicensePlateManager.PLATE_POSITION[ string.upper(positionStr)]
                        if position = = nil then
                            Logging.xmlError(xmlFile, "Unknown position '%s' in '%s'" , positionStr, materialKey)
                        end
                        material.licensePlatePosition = position or LicensePlateManager.PLATE_POSITION.ANY

                        table.insert(variation.materials, material)
                    end
                end )

                if #variation.values > 0 then
                    table.insert( self.variations, variation)
                end
            end )

            self.frame = { }
            self.frame.node = xmlFile:getValue(key .. ".frame#node" )
            self.frame.widthOffset = xmlFile:getValue(key .. ".frame#widthOffset" , 0 )
            self.frame.heightOffsetTop = xmlFile:getValue(key .. ".frame#heightOffsetTop" , 0 )
            self.frame.heightOffsetBot = xmlFile:getValue(key .. ".frame#heightOffsetBot" , 0 )

            if self.frame.node = = nil or I3DUtil.indexToObject( self.node, self.frame.node) = = nil then
                self.frame = nil
            end
        else
                return false
            end
        end

        return true
    end

```

### new

**Description**

> Creating manager

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function LicensePlate.new(customMt)
    local self = setmetatable( { } , customMt or LicensePlate _mt)

    self.variationIndex = 1
    self.position = LicensePlateManager.PLATE_POSITION.ANY
    self.characters = ""
    self.manager = g_licensePlateManager

    return self
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string baseName)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | baseName |

**Code**

```lua
function LicensePlate.registerXMLPaths(schema, baseName)
    schema:register(XMLValueType.STRING, baseName .. "#filename" , "License plate i3d filename" )
    schema:register(XMLValueType.NODE_INDEX, baseName .. "#node" , "License plate node" )
    schema:register(XMLValueType.STRING, baseName .. "#type" , "License plate type 'SQUARISH' or 'ELONGATED'" , "ELONGATED" )

    schema:register(XMLValueType.FLOAT, baseName .. "#width" , "Width of license plate" , 1 )
    schema:register(XMLValueType.FLOAT, baseName .. "#height" , "Height of license plate" , 0.2 )

    schema:register(XMLValueType.FLOAT, baseName .. ".font#size" , "Size of font" , 0.1 )
    schema:register(XMLValueType.BOOL, baseName .. ".font#useNormalMap" , "Use normal map for the characters" , true )
        schema:register(XMLValueType.FLOAT, baseName .. ".font#scaleX" , "Additional scaling of font X" , 1 )
        schema:register(XMLValueType.FLOAT, baseName .. ".font#scaleY" , "Additional scaling of font Y" , 1 )

        schema:register(XMLValueType.STRING, baseName .. ".variations.variation(?).value(?)#node" , "Value mesh index" )
        schema:register(XMLValueType.FLOAT, baseName .. ".variations.variation(?).value(?)#posX" , "X translation of value node" )
        schema:register(XMLValueType.FLOAT, baseName .. ".variations.variation(?).value(?)#posY" , "Y translation of value node" )
        schema:register(XMLValueType.FLOAT, baseName .. ".variations.variation(?).value(?)#posZ" , "Z translation of value node" )
        schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#nextSection" , "Is start character for next section" , false )
            schema:register(XMLValueType.STRING, baseName .. ".variations.variation(?).value(?)#character" , "Pre defined character of node" )
            schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#numerical" , "Node supports numeric characters" , false )
            schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#alphabetical" , "Node supports alphabetical characters" , false )
            schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#special" , "Node supports special characters" , false )
            schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#isStatic" , "Node is only static without applying of characters" , "is static if 'numerical' and 'alphabetical' are both on false and no fixed character is given" )
                schema:register(XMLValueType.BOOL, baseName .. ".variations.variation(?).value(?)#locked" , "Character value can not be changed" , "locked when character is defined" )
                schema:register(XMLValueType.STRING, baseName .. ".variations.variation(?).value(?)#position" , "Value will be hidden of position differs from placement position" , "ANY" )

                VehicleMaterial.registerXMLPaths(schema, baseName .. ".variations.variation(?).material(?)" )
                schema:register(XMLValueType.STRING, baseName .. ".variations.variation(?).material(?)#position" , "Value will be hidden of position differs from placement position" , "ANY" )

                schema:register(XMLValueType.STRING, baseName .. ".frame#node" , "Frame node that can be toggled" )
                schema:register(XMLValueType.FLOAT, baseName .. ".frame#widthOffset" , "Width of frame on each side" , 0 )
                schema:register(XMLValueType.FLOAT, baseName .. ".frame#heightOffsetTop" , "Height of frame on top" , 0 )
                schema:register(XMLValueType.FLOAT, baseName .. ".frame#heightOffsetBot" , "Height of frame at bottom" , 0 )
            end

```

### setColor

**Description**

> Set color of license plate

**Definition**

> setColor(float r, float g, float b)

**Arguments**

| float | r | red value   |
|-------|---|-------------|
| float | g | green value |
| float | b | blue value  |

**Code**

```lua
function LicensePlate:setColor(r, g, b)
    local material = VehicleMaterial.new()
    material:setColor(r, g, b)
    material:apply( self.node, g_licensePlateManager.materialNamePlate)

    for j = 1 , # self.variations do
        for i = 1 , # self.variations[j].values do
            local value = self.variations[j].values[i]
            if not value.isStatic then
                if value.node ~ = nil then
                    I3DUtil.setShaderParameterRec(value.node, g_licensePlateManager.shaderParameterCharacters, r, g, b)
                end
            end
        end
    end
end

```

### setColorIndex

**Description**

> Set color of license plate by color index

**Definition**

> setColorIndex(integer colorIndex)

**Arguments**

| integer | colorIndex | index of color |
|---------|------------|----------------|

**Code**

```lua
function LicensePlate:setColorIndex(colorIndex)
    local colors, _ = self.manager:getAvailableColors()
    local colorData = colors[colorIndex]
    if colorData ~ = nil then
        self:setColor(colorData.color[ 1 ], colorData.color[ 2 ], colorData.color[ 3 ])
    end
end

```

### setVariation

**Description**

**Definition**

> setVariation(integer variationIndex, )

**Arguments**

| integer | variationIndex |
|---------|----------------|
| any     | position       |

**Code**

```lua
function LicensePlate:setVariation(variationIndex, position)
    local variation = self.variations[variationIndex]
    if variation ~ = nil then
        local oldVariation = self.variations[ self.variationIndex]
        for i = 1 , #oldVariation.values do
            local value = oldVariation.values[i]
            if not value.isStatic then
                for j = 1 , getNumOfChildren(value.node) do
                    delete(getChildAt(value.node, j - 1 ))
                end
            end
        end

        self.variationIndex = variationIndex

        for i = 1 , #variation.values do
            local value = variation.values[i]

            if not value.isStatic then
                value.characterLine = CharacterLine.new(value.node, self.font, 1 )
                value.characterLine:setSizeAndScale( self.fontSize, self.fontScaleX, self.fontScaleY)
                value.characterLine:setTextAlignment(RenderText.ALIGN_CENTER)
                value.characterLine:setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
                value.characterLine:setUseNormalMap( self.fontUseNormalMap)
            end
        end

        for i = 1 , #variation.materials do
            local material = variation.materials[i]

            if position = = nil or material.licensePlatePosition = = LicensePlateManager.PLATE_POSITION.ANY or material.licensePlatePosition = = position then
                material:apply( self.node)
            end
        end
    end
end

```

### updateData

**Description**

**Definition**

> updateData(integer variationIndex, integer position, string characters, boolean validate)

**Arguments**

| integer | variationIndex |                                           |
|---------|----------------|-------------------------------------------|
| integer | position       | one of LicensePlateManager.PLATE_POSITION |
| string  | characters     |                                           |
| boolean | validate       |                                           |

**Code**

```lua
function LicensePlate:updateData(variationIndex, position, characters, validate)
    if variationIndex ~ = self.variationIndex or position ~ = self.position then
        self:setVariation(variationIndex, position)
    end

    self.position = position or self.position

    if validate = = true then
        characters = self:validateLicensePlateCharacters(characters)
    end

    self.characters = characters

    local variation = self.variations[ self.variationIndex]
    if variation ~ = nil then
        local stringPos = 1
        for i = 1 , #variation.values do
            local value = variation.values[i]
            if value.node ~ = nil then
                setTranslation(value.node, value.posX, value.posY, value.posZ)

                local samePosition = (value.position = = LicensePlateManager.PLATE_POSITION.ANY or value.position = = position) and value.position ~ = LicensePlateManager.PLATE_POSITION.NONE

                local targetChar = value.character
                if not value.locked then
                    targetChar = characters:sub(stringPos, stringPos) or targetChar -- TODO:not utf8 compatible
                end

                if not value.isStatic and targetChar ~ = "" and targetChar ~ = "_" and samePosition then
                    value.characterLine:setText(targetChar)
                    setVisibility(value.node, true )
                elseif value.isStatic and samePosition then
                        setVisibility(value.node, true )
                    else
                            setVisibility(value.node, false )
                        end

                        if not value.isStatic then
                            stringPos = stringPos + 1
                        end
                    end
                end
            end
        end

```

### validateLicensePlateCharacters

**Description**

> Check if license plate characters are allowed

**Definition**

> validateLicensePlateCharacters(table characters)

**Arguments**

| table | characters | characters |
|-------|------------|------------|

**Return Values**

| table | characters | characters |
|-------|------------|------------|

**Code**

```lua
function LicensePlate:validateLicensePlateCharacters(characters)
    local str = characters
    local isTbl = type(characters) = = "table"
    local length
    if isTbl then
        str = table.concat(characters, "" )
        length = #characters
    else
            length = characters:len() -- TODO:not utf8 compatible
        end

        local variation = self.variations[ self.variationIndex]

        str = filterText(str, false , false )
        for i = 1 , length do
            local replacement = str:sub(i, i) -- TODO:not utf8 compatible
            local old
            if isTbl then
                old = characters[i]
            else
                    old = characters:sub(i, i) -- TODO:not utf8 compatible
                end

                if replacement ~ = old then
                    local value = variation.values[i]
                    if value ~ = nil then
                        local sourceCharacters = self.font.characters
                        if value.alphabetical then
                            sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL]
                        elseif value.numerical then
                                sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.NUMERICAL]
                            elseif value.special then
                                    sourceCharacters = self.font.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.SPECIAL]
                                end

                                if isTbl then
                                    characters[i] = sourceCharacters[ 1 ].value
                                else
                                        characters = str:sub( 1 , i - 1 ) .. sourceCharacters[ 1 ].value .. str:sub(i + 1 ) -- TODO:not utf8 compatible
                                    end
                                end
                            end
                        end

                        return characters
                    end

```