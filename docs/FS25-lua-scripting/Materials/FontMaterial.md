## FontMaterial

**Description**

> Class for font materials that are used with the alphabetShader

**Functions**

- [assignFontMaterialToNode](#assignfontmaterialtonode)
- [getCharacterByCharacterIndex](#getcharacterbycharacterindex)
- [getCharacterIndexByCharacter](#getcharacterindexbycharacter)
- [getClonedShape](#getclonedshape)
- [getFontMaxWidthRatio](#getfontmaxwidthratio)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onI3DFileLoaded](#oni3dfileloaded)
- [registerXMLPaths](#registerxmlpaths)
- [setFontCharacter](#setfontcharacter)
- [setFontCharacterColor](#setfontcharactercolor)

### assignFontMaterialToNode

**Description**

**Definition**

> assignFontMaterialToNode()

**Arguments**

| any | node      |
|-----|-----------|
| any | hasNormal |

**Code**

```lua
function FontMaterial:assignFontMaterialToNode(node, hasNormal)
    if node ~ = nil then
        local materialId = self.materialId
        if hasNormal = = false then
            materialId = self.materialIdNoNormal or materialId
        end

        setMaterial(node, materialId, 0 )
        setShaderParameter(node, "spacing" , self.spacingX, self.spacingY, 0 , 0 , false )
    end
end

```

### getCharacterByCharacterIndex

**Description**

**Definition**

> getCharacterByCharacterIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function FontMaterial:getCharacterByCharacterIndex(index)
    local char = self.characters[index]
    if char ~ = nil then
        return char.value
    end

    return nil
end

```

### getCharacterIndexByCharacter

**Description**

**Definition**

> getCharacterIndexByCharacter()

**Arguments**

| any | char |
|-----|------|

**Code**

```lua
function FontMaterial:getCharacterIndexByCharacter( char )
    for i = 1 , # self.characters do
        if string.lower( self.characters[i].value) = = string.lower( char ) then
            return i
        end
    end

    return 0
end

```

### getClonedShape

**Description**

**Definition**

> getClonedShape()

**Arguments**

| any | linkNode  |
|-----|-----------|
| any | hasNormal |

**Code**

```lua
function FontMaterial:getClonedShape(linkNode, hasNormal)
    local char = clone( self.characterShape, false , false , false )
    link(linkNode, char )
    self:assignFontMaterialToNode( char , hasNormal)

    return char
end

```

### getFontMaxWidthRatio

**Description**

**Definition**

> getFontMaxWidthRatio()

**Arguments**

| any | alphabetical |
|-----|--------------|
| any | numerical    |
| any | special      |

**Code**

```lua
function FontMaterial:getFontMaxWidthRatio(alphabetical, numerical, special)
    local maxRatio = 0
    for i = 1 , # self.characters do
        local character = self.characters[i]

        if character.type = = MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL and alphabetical ~ = false
            or character.type = = MaterialManager.FONT_CHARACTER_TYPE.NUMERICAL and numerical ~ = false
            or character.type = = MaterialManager.FONT_CHARACTER_TYPE.SPECIAL and special ~ = false then
            local spacingX, spacingY = character.spacingX or self.spacingX, character.spacingY or self.spacingY
            local ratio = ( 1 - (spacingX * 2 )) / ( 1 - (spacingY * 2 ))
            maxRatio = math.max(ratio, maxRatio)
        end
    end

    return maxRatio
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | customEnvironment |
| any | baseDirectory     |
| any | callback          |

**Code**

```lua
function FontMaterial:loadFromXML(xmlFile, key, customEnvironment, baseDirectory, callback)
    local name = xmlFile:getValue(key .. "#name" )
    local filename = xmlFile:getValue(key .. "#filename" )
    local node = xmlFile:getValue(key .. "#node" )
    local noNormalNode = xmlFile:getValue(key .. "#noNormalNode" )
    local characterShapePath = xmlFile:getValue(key .. "#characterShape" )
    if name ~ = nil and filename ~ = nil and node ~ = nil then
        if customEnvironment ~ = nil and customEnvironment ~ = "" then
            name = customEnvironment .. "." .. name
        end

        self.name = name
        self.node = node
        self.noNormalNode = noNormalNode
        self.characterShapePath = characterShapePath

        filename = Utils.getFilename(filename, baseDirectory)

        local arguments = {
        xmlFile = xmlFile,
        key = key,
        }

        self.callback = callback

        self.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.onI3DFileLoaded, self , arguments)
    else
            if callback ~ = nil then
                callback( false )
            end
        end
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function FontMaterial.new(customMt)
    local self = setmetatable( { } , customMt or FontMaterial _mt)

    return self
end

```

### onI3DFileLoaded

**Description**

**Definition**

> onI3DFileLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | arguments    |
| any | loadingId    |

**Code**

```lua
function FontMaterial:onI3DFileLoaded(i3dNode, failedReason, arguments, loadingId)
    local xmlFile = arguments.xmlFile
    local key = arguments.key

    if i3dNode ~ = 0 then
        local materialNode = I3DUtil.indexToObject(i3dNode, self.node)
        if materialNode ~ = nil then
            self.materialId = getMaterial(materialNode, 0 )
            self.materialNode = materialNode

            if self.noNormalNode ~ = nil then
                self.materialNodeNoNormal = I3DUtil.indexToObject(i3dNode, self.noNormalNode)
                self.materialIdNoNormal = getMaterial( self.materialNodeNoNormal, 0 )
            end

            if self.characterShapePath ~ = nil then
                self.characterShape = I3DUtil.indexToObject(i3dNode, self.characterShapePath)
            end

            unlink( self.materialNodeNoNormal)
            unlink( self.characterShape)
            unlink(materialNode)

            self.spacingX = xmlFile:getValue(key .. ".spacing#x" , 0 )
            self.spacingY = xmlFile:getValue(key .. ".spacing#y" , 0 )

            self.charToCharSpace = xmlFile:getValue(key .. ".spacing#charToChar" , 0.05 )

            self.characters = { }
            self.characterToCharacterData = { }

            self.charactersByType = { }
            self.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.NUMERICAL] = { }
            self.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL] = { }
            self.charactersByType[ MaterialManager.FONT_CHARACTER_TYPE.SPECIAL] = { }

            xmlFile:iterate(key .. ".character" , function (index, charKey)
                local character = { }
                character.uvIndex = xmlFile:getValue(charKey .. "#uvIndex" , 0 )
                character.value = xmlFile:getValue(charKey .. "#value" )
                local typeStr = xmlFile:getValue(charKey .. "#type" , "alphabetical" )
                character.type = MaterialManager.FONT_CHARACTER_TYPE[ string.upper(typeStr)] or MaterialManager.FONT_CHARACTER_TYPE.ALPHABETICAL

                character.spacingX = math.max(xmlFile:getValue(charKey .. "#spacingX" , self.spacingX), 0.0001 )
                character.spacingY = math.max(xmlFile:getValue(charKey .. "#spacingY" , self.spacingY), 0.0001 )
                character.offsetX = xmlFile:getValue(charKey .. "#offsetX" , 0 )
                character.offsetY = xmlFile:getValue(charKey .. "#offsetY" , 0 )
                character.realSpacingX = math.max(xmlFile:getValue(charKey .. "#realSpacingX" , character.spacingX), 0.0001 )

                if character.value ~ = nil then
                    self.characterToCharacterData[character.value] = character

                    local lower , upper = string.lower(character.value), string.upper(character.value)
                    if self.characterToCharacterData[ lower ] = = nil then
                        self.characterToCharacterData[ lower ] = character
                    end
                    if self.characterToCharacterData[ upper ] = = nil then
                        self.characterToCharacterData[ upper ] = character
                    end

                    table.insert( self.characters, character)
                    table.insert( self.charactersByType[character.type ], character)
                end
            end )
        end

        delete(i3dNode)
    end

    if self.callback ~ = nil then
        self.callback( self.materialNode ~ = nil )
    end
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function FontMaterial.registerXMLPaths(schema)
    schema:register(XMLValueType.STRING, "fonts.font(?)#name" , "Name if font" )
        schema:register(XMLValueType.STRING, "fonts.font(?)#filename" , "Path to i3d file" )
        schema:register(XMLValueType.STRING, "fonts.font(?)#node" , "Path to material node" )
        schema:register(XMLValueType.STRING, "fonts.font(?)#characterShape" , "Path to character mesh" )
        schema:register(XMLValueType.STRING, "fonts.font(?)#noNormalNode" , "Path to material node without normal map" )

        schema:register(XMLValueType.FLOAT, "fonts.font(?).spacing#x" , "X Spacing" , 0 )
        schema:register(XMLValueType.FLOAT, "fonts.font(?).spacing#y" , "Y Spacing" , 0 )
        schema:register(XMLValueType.FLOAT, "fonts.font(?).spacing#charToChar" , "Spacing from character to character in percentage" , 0.1 )

        schema:register(XMLValueType.INT, "fonts.font(?).character(?)#uvIndex" , "Index on uv map" , 0 )
        schema:register(XMLValueType.STRING, "fonts.font(?).character(?)#value" , "Character value" )
        schema:register(XMLValueType.STRING, "fonts.font(?).character(?)#type" , "Character type" , "alphabetical" )
        schema:register(XMLValueType.FLOAT, "fonts.font(?).character(?)#spacingX" , "Custom spacing X" )
        schema:register(XMLValueType.FLOAT, "fonts.font(?).character(?)#spacingY" , "Custom spacing Y" )
        schema:register(XMLValueType.FLOAT, "fonts.font(?).character(?)#offsetX" , "Custom X offset for created char lines(percentage)" , 0 )
            schema:register(XMLValueType.FLOAT, "fonts.font(?).character(?)#offsetY" , "Custom Y offset for created char lines(percentage)" , 0 )
                schema:register(XMLValueType.FLOAT, "fonts.font(?).character(?)#realSpacingX" , "Real spacing from border to visual beginning" )
            end

```

### setFontCharacter

**Description**

**Definition**

> setFontCharacter()

**Arguments**

| any | node            |
|-----|-----------------|
| any | targetCharacter |
| any | color           |
| any | hiddenColor     |

**Code**

```lua
function FontMaterial:setFontCharacter(node, targetCharacter, color, hiddenColor)
    if node ~ = nil then
        if hiddenColor ~ = nil then
            if targetCharacter = = " " then
                targetCharacter = "0"
                self:setFontCharacterColor(node, hiddenColor[ 1 ], hiddenColor[ 2 ], hiddenColor[ 3 ])
            else
                    self:setFontCharacterColor(node, color[ 1 ], color[ 2 ], color[ 3 ])
                end
            end

            -- try first if we have a character with matching case
                local foundCharacter = self.characterToCharacterData[targetCharacter]

                -- if not we use any character independent of the case
                    if foundCharacter = = nil then
                        foundCharacter = self.characterToCharacterData[ string.lower(targetCharacter)]
                    end

                    if foundCharacter ~ = nil then
                        setVisibility(node, true )
                        setShaderParameter(node, "index" , foundCharacter.uvIndex, 0 , 0 , 0 , false )
                        setShaderParameter(node, "spacing" , foundCharacter.spacingX or self.spacingX, foundCharacter.spacingY or self.spacingY, 0 , 0 , false )
                    else
                            setVisibility(node, false )
                        end

                        return foundCharacter
                    end

                    return nil
                end

```

### setFontCharacterColor

**Description**

**Definition**

> setFontCharacterColor()

**Arguments**

| any | node     |
|-----|----------|
| any | r        |
| any | g        |
| any | b        |
| any | a        |
| any | emissive |

**Code**

```lua
function FontMaterial:setFontCharacterColor(node, r, g, b, a, emissive)
    if node ~ = nil then
        setShaderParameter(node, "colorScale" , r, g, b, a, false )

        if emissive ~ = nil then
            setShaderParameter(node, "lightControl" , emissive, nil , nil , nil , false )
        end
    end
end

```