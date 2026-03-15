## OverlayManager

**Description**

> reads UVs of overlays from an XML file, stores them, and creates new overlays for other scripts to use

**Functions**

- [addTextureConfigFile](#addtextureconfigfile)
- [createOverlay](#createoverlay)
- [getConfigMetaData](#getconfigmetadata)
- [getSliceInfoById](#getsliceinfobyid)

### addTextureConfigFile

**Description**

> Adds a texture config file to the overlay manager. reads meta information like slices filename and resolution, and
> then reads information for all given slices, and saves them

**Definition**

> addTextureConfigFile(string filename, string prefix, string? customEnv)

**Arguments**

| string  | filename  | name of the texture config file, that contains all other data                     |
|---------|-----------|-----------------------------------------------------------------------------------|
| string  | prefix    | for this texture config file, is used in front of slice id when creating overlays |
| string? | customEnv | custom environment for mod namespace                                              |

**Code**

```lua
function OverlayManager:addTextureConfigFile(filename, prefix, customEnv)
    if customEnv ~ = nil then
        prefix = customEnv .. "." .. prefix
    end

    if filename = = nil then
        Logging.warning( "Filename for texture config file is empty" )
            return
        end

        --if we already have a config file with this prefix loaded, we stop
            if self.textureConfigs[prefix] ~ = nil and not g_gui.currentlyReloading then
                Logging.warning( "Texture config file with prefix '%s' already exists" , prefix)
                return
            end

            local xmlFile = XMLFile.load( "TextureConfig" , filename)
            local directory = Utils.getDirectory(filename)

            --failed to load xml with given filename
            if xmlFile = = nil then
                Logging.warning( "Failed to load XML file from path '%s'" , filename)
                return
            end

            local textureConfig = { }
            textureConfig.xmlFilename = filename

            local imageFilename = xmlFile:getString( "texture.meta.filename" )
            if imageFilename = = nil then
                Logging.xmlWarning(xmlFile, "Missing filename in meta data" )
                return
            end
            textureConfig.imageFilename = directory .. imageFilename

            local imageWidth = xmlFile:getInt( "texture.meta.size#width" )
            if imageWidth = = nil then
                Logging.xmlWarning(xmlFile, "Missing imageWidth in meta data" )
                return
            end

            local imageHeight = xmlFile:getInt( "texture.meta.size#height" )
            if imageHeight = = nil then
                Logging.xmlWarning(xmlFile, "Missing imageHeight in meta data" )
                return
            end

            textureConfig.imageSize = { imageWidth, imageHeight }

            textureConfig.slices = { }

            xmlFile:iterate( "texture.slices.slice" , function (num, key)
                local slice = { }
                local id = xmlFile:getString(key .. "#id" )
                if id = = nil then
                    Logging.xmlWarning(xmlFile, "Missing ID for slice nr. %i" , num)
                        return
                    end
                    slice.sliceId = prefix .. "." .. id

                    local uvsStr = xmlFile:getString(key .. "#uvs" )
                    if uvsStr = = nil then
                        Logging.xmlWarning(xmlFile, "Missing UVs for slice with ID %s" , slice.sliceId)
                            return
                        end

                        local _, _, width, height = unpack( GuiUtils.getNormalizedScreenValues(uvsStr))

                        if width = = nil then
                            slice.width = 0
                            Logging.xmlWarning(xmlFile, "Missing width for slice with ID %s" , slice.sliceId)
                            else
                                    slice.width = GuiUtils.getNormalizedXValue(width)
                                end

                                if height = = nil then
                                    slice.height = 0
                                    Logging.xmlWarning(xmlFile, "Missing height for slice with ID %s" , slice.sliceId)
                                    else
                                            slice.height = GuiUtils.getNormalizedYValue(height)
                                        end

                                        local _, _, widthStr, heightStr = unpack( string.split(uvsStr, " " ))

                                        slice.uvsStr = uvsStr
                                        slice.size = { width, height }
                                        slice.sizeStr = widthStr .. " " .. heightStr
                                        slice.imageSize = textureConfig.imageSize
                                        slice.filename = textureConfig.imageFilename
                                        slice.uvs = GuiUtils.getUVs(uvsStr, textureConfig.imageSize, { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 } )

                                        if textureConfig.slices[id] ~ = nil then
                                            Logging.xmlWarning(xmlFile, "Duplicate slice ID %s" , slice.sliceId)
                                        end

                                        textureConfig.slices[id] = slice
                                    end )

                                    self.textureConfigs[prefix] = textureConfig

                                    xmlFile:delete()
                                end

```

### createOverlay

**Description**

> Returns an overlay with previously loaded data for the given identifier

**Definition**

> createOverlay(string identifier, float? posX, float? posY, float? width, float? height, string? customEnv)

**Arguments**

| string  | identifier | format: "prefix.sliceId" first dot (.) is used as separator, creates overlay with data for slice with name sliceId in texture config file with name prefix |
|---------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| float?  | posX       |                                                                                                                                                            |
| float?  | posY       |                                                                                                                                                            |
| float?  | width      |                                                                                                                                                            |
| float?  | height     |                                                                                                                                                            |
| string? | customEnv  | needed for mod support                                                                                                                                     |

**Return Values**

| string? | overlay | Overlay instance or nil on error |
|---------|---------|----------------------------------|

**Code**

```lua
function OverlayManager:createOverlay(identifier, posX, posY, width, height, customEnv)
    local identifierSplit = string.split(identifier, "." )
    local prefix = identifierSplit[ 1 ]
    local sliceId = identifierSplit[ 2 ]

    if prefix = = nil or sliceId = = nil then
        Logging.warning( "Identifier '%s' does not contain prefix or slice ID" , identifier)
        return nil
    end

    if customEnv ~ = nil then
        prefix = customEnv .. "." .. prefix
    end

    local textureConfig = self.textureConfigs[prefix]

    if textureConfig = = nil then
        Logging.warning( "No texture config with prefix '%s' found" , prefix)
        return nil
    end

    local slice = textureConfig.slices[sliceId]

    if slice = = nil then
        Logging.xmlWarning(textureConfig.xmlFilename, "No slice with ID '%s' found in texture config '%s'" , sliceId, prefix)
        return nil
    end

    posX = posX or 0
    posY = posY or 0

    width = width or slice.width
    height = height or slice.height

    local overlay = Overlay.new(textureConfig.imageFilename, posX, posY, width, height)
    overlay:setUVs(slice.uvs)

    return overlay
end

```

### getConfigMetaData

**Description**

> Returns the texture config meta data for a given config file

**Definition**

> getConfigMetaData(string configPrefix, string? customEnv)

**Arguments**

| string  | configPrefix | prefix that was used to add the texture config file to the overlay manager |
|---------|--------------|----------------------------------------------------------------------------|
| string? | customEnv    | needed for mod support                                                     |

**Return Values**

| string? | metadata | {filename=string, imageSize={width, height}} |
|---------|----------|----------------------------------------------|

**Code**

```lua
function OverlayManager:getConfigMetaData(configPrefix, customEnv)
    if configPrefix = = nil then
        Logging.warning( "Texture config prefix is empty" )
        return nil
    end

    if customEnv ~ = nil then
        configPrefix = customEnv .. "." .. configPrefix
    end

    local textureConfig = self.textureConfigs[configPrefix]

    if textureConfig = = nil then
        Logging.warning( "No texture config with prefix '%s' found" , configPrefix)
        return nil
    end

    local metadata = { filename = textureConfig.imageFilename, imageSize = textureConfig.imageSize }

    return metadata
end

```

### getSliceInfoById

**Description**

> Returns the texture config data for the given identifier

**Definition**

> getSliceInfoById(string identifier, string? customEnv)

**Arguments**

| string  | identifier | format: "prefix.sliceId" first dot (.) is used as separator, creates overlay with data for slice with name sliceId in texture config file with name prefix |
|---------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| string? | customEnv  | needed for mod support                                                                                                                                     |

**Return Values**

| string? | slice | slice table or nil on error |
|---------|-------|-----------------------------|

**Code**

```lua
function OverlayManager:getSliceInfoById(identifier, customEnv)
    if identifier = = nil then
        return nil
    end

    local identifierSplit = string.split(identifier, "." )
    local prefix = identifierSplit[ 1 ]
    local sliceId = identifierSplit[ 2 ]

    if prefix = = nil or sliceId = = nil then
        Logging.warning( "Identifier '%s' does not contain prefix or slice ID" , identifier)
        return nil
    end

    if customEnv ~ = nil then
        prefix = customEnv .. "." .. prefix
    end

    local textureConfig = self.textureConfigs[prefix]

    if textureConfig = = nil then
        Logging.warning( "No texture config with prefix '%s' found" , prefix)
        return nil
    end

    local slice = textureConfig.slices[sliceId]

    if slice = = nil then
        Logging.warning( "No slice with ID '%s' found in texture config '%s'" , sliceId, prefix)
        return nil
    end

    return slice
end

```