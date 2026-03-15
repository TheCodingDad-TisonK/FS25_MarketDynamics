## PlayerStyle

**Description**

> This class handles player avatar customization

**Functions**

- [copyConfigurationFrom](#copyconfigurationfrom)
- [copyFrom](#copyfrom)
- [copySelectionFrom](#copyselectionfrom)
- [debugDraw](#debugdraw)
- [loadConfigurationXML](#loadconfigurationxml)
- [new](#new)
- [readStream](#readstream)
- [writeStream](#writestream)

### copyConfigurationFrom

**Description**

> Copies the configuration from the given style into this style. The selection will be untouched.

**Definition**

> copyConfigurationFrom(PlayerStyle other)

**Arguments**

| PlayerStyle | other | The style to copy from. |
|-------------|-------|-------------------------|

**Code**

```lua
function PlayerStyle:copyConfigurationFrom(other)

    --#debug Assert.isClass(other, PlayerStyle, "Cannot copy from non-style object!")

    -- If the other style is this, do nothing.
        if other = = self then
            return
        end

        -- If the other style has not yet loaded its configuration, log an error and do nothing more.
            if not other.isConfigurationLoaded then
                Logging.error( "Cannot copy configuration from style that has not yet loaded its own configuration!" )
                printCallstack()
                return
            end

            -- Copy the filenames.
            self.xmlFilename = other.xmlFilename
            self.filename = other.filename

            -- Copy the basic attributes.
            self.hatHairstyleIndex = other.hatHairstyleIndex
            self.faceNeutralDiffuseColor = other.faceNeutralDiffuseColor

            -- Copy the style collections.
            self.attachPoints = other.attachPoints
            self.bodyParts = other.bodyParts
            self.bodyPartIndexByName = other.bodyPartIndexByName
            self.presets = other.presets
            self.presetsByName = other.presetsByName

            -- Copy the configurations.
            for configName, config in pairs(other.configs) do
                self.configs[configName]:copyConfigurationFrom(config)
            end

            -- Set the configuration as being loaded and update the disabled options.
            self.isConfigurationLoaded = true
            self:updateDisabledOptions()
        end

```

### copyFrom

**Description**

> Copies the selection and configuration from the given style. If the given style has no loaded configuration, this
> style will be marked as dirty.

**Definition**

> copyFrom(PlayerStyle other)

**Arguments**

| PlayerStyle | other | The style to copy from. |
|-------------|-------|-------------------------|

**Code**

```lua
function PlayerStyle:copyFrom(other)

    if other = = self then
        return
    end

    self.xmlFilename = other.xmlFilename
    self.filename = other.filename

    self.attachPoints = other.attachPoints

    for configName, config in pairs(other.configs) do
        self.configs[configName]:copyConfigurationFrom(config)
        self.configs[configName]:copySelectionFrom(config)
    end

    -- Unify the hair colors.
    self.configs.hairStyle:setSelectedColorIndex( self.configs.hairStyle:getSelectedColorIndex())

    -- No need to copy the lists deep:they are static.Also loaded from XML configuration
    if other.isConfigurationLoaded then
        self.faceNeutralDiffuseColor = other.faceNeutralDiffuseColor

        self.bodyParts = other.bodyParts
        self.bodyPartIndexByName = other.bodyPartIndexByName

        self.hatHairstyleIndex = other.hatHairstyleIndex

        self.presets = other.presets
        self.presetsByName = other.presetsByName

        self.isConfigurationLoaded = true

        self:updateDisabledOptions()
    else
            self.isConfigurationLoaded = false
        end
    end

```

### copySelectionFrom

**Description**

> Copies the selection from the given style into this style. The actual configuration will be untouched.
> If the configuration for this style has not been loaded or the given style is for a different configuration, this
> style's configuration will be marked dirty.

**Definition**

> copySelectionFrom(PlayerStyle other)

**Arguments**

| PlayerStyle | other | The style to copy from. |
|-------------|-------|-------------------------|

**Code**

```lua
function PlayerStyle:copySelectionFrom(other)

    -- If the other style is this, do nothing.
        if other = = self then
            return
        end

        -- The configuration does not need to be loaded if it was already loaded and the two styles are based on the same config.
            self.isConfigurationLoaded = self.xmlFilename = = other.xmlFilename and self.isConfigurationLoaded
            self.xmlFilename = other.xmlFilename

            -- Copy the selection for each config.
                for configName, config in pairs(other.configs) do
                    self.configs[configName]:copySelectionFrom(config)
                end

                -- Unify the hair colors.
                self.configs.hairStyle:setSelectedColorIndex( self.configs.hairStyle:getSelectedColorIndex())
            end

```

### debugDraw

**Description**

> Displays the debug information.

**Definition**

> debugDraw(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Return Values**

| float | y | The y position on the screen after the entire debug info was drawn. |
|-------|---|---------------------------------------------------------------------|

**Code**

```lua
function PlayerStyle:debugDraw(x, y, textSize)

    -- Render the header.
    y = DebugUtil.renderTextLine(x, y, textSize * 1.25 , "Style" , nil , true )
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Is loaded: %s" , self.isConfigurationLoaded))
    if self.isConfigurationLoaded then
        y = DebugUtil.renderTextLine(x, y, textSize, self.xmlFilename)
    end

    local startX = x
    y = DebugUtil.renderTextLine(x, y, textSize, "Config name, item id, color id:" )
    for configName, config in pairs( self.configs) do
        DebugUtil.renderTextLine(x, y, textSize, string.format( "%s: %d %d" , string.sub(configName, 1 , 4 ), config.selectedItemIndex, config.selectedColorIndex))
        x = x + ( 80 * g_pixelSizeX)
        if (x - startX) / g_pixelSizeX > 250 then
            x = startX
            y = y - textSize
        end
    end
    x = startX

    -- Return the final y value.
    return y
end

```

### loadConfigurationXML

**Description**

> Load player style options and configuration info from a player XML

**Definition**

> loadConfigurationXML()

**Arguments**

| any | xmlFilename |
|-----|-------------|

**Code**

```lua
function PlayerStyle:loadConfigurationXML(xmlFilename)

    xmlFilename = Utils.getFilename(xmlFilename)

    -- If the file has already been loaded, copy from it instead of loading the xml.
    if PlayerSystem.PLAYER_STYLES_BY_FILENAME[xmlFilename] ~ = nil then
        self:copyConfigurationFrom( PlayerSystem.PLAYER_STYLES_BY_FILENAME[xmlFilename].style)
        return
    end

    -- Try to load the xml file, defaulting if it fails.
        local xmlFile = XMLFile.loadIfExists( "player" , xmlFilename, PlayerSystem.xmlSchema)
        if xmlFile = = nil then

            -- Log an error and fall back.
            Logging.error( "Player config does not exist at %s.Loading default instead" , xmlFilename)
            xmlFilename = next( PlayerSystem.PLAYER_STYLES_BY_FILENAME)
            xmlFile = XMLFile.loadIfExists( "player" , xmlFilename, PlayerSystem.xmlSchema)

            -- Nothing can be done if no player exists.
                if xmlFile = = nil then
                    Logging.fatal( "Default player config does not exist at %s" , xmlFilename)
                end
            end

            self.xmlFilename = xmlFilename
            local rootKey = "player.playerStyle"

            self.filename = xmlFile:getValue( "player.filename" , nil )

            self.hairColors = PlayerStyle.loadColors(xmlFile, rootKey .. ".colors.hair" )
            self.defaultClothingColors = PlayerStyle.loadColors(xmlFile, rootKey .. ".colors.clothing" )

            -- Attach points
            table.clear( self.attachPoints)
            for _, key in xmlFile:iterator(rootKey .. ".attachPoints.attachPoint" ) do

                -- Get the name of the i3d node from the node.This is used with the i3dMappings to get the desired node.
                local nodeName = xmlFile:getValue(key .. "#node" )

                -- Get the name of the attachment point.If none is given, default to the node name.
                local name = xmlFile:getValue(key .. "#name" , nodeName)

                -- Add the attachment point.
                self.attachPoints[name] = nodeName
            end

            -- Used for moving from 1 config to another
                local restoreFaceSelection = nil

                -- Faces
                if self.configs.face.selectedItemIndex ~ = 0 and self.configs.face:getSelectedItem() ~ = nil then
                    restoreFaceSelection = self.configs.face:getSelectedItem().name
                end

                -- Load the configs.
                for configName, baseKeyName in pairs( PlayerStyleConfig.CONFIG_BASE_KEY_NAMES_BY_NAME) do

                    -- Keep track of the previous selection.
                    local config = self.configs[configName]
                    local selectedItem = config:getSelectedItem()
                    local restoreSelectionName = selectedItem ~ = nil and selectedItem.name or nil
                    local restoreSelectionIndex = config.selectedItemIndex

                    -- Reset and reload the config.
                    config:reset()
                    config:loadFromXMLNode(xmlFile, rootKey, self.defaultClothingColors, self.hairColors, self.attachPoints)

                    -- Try to restore the previous selection.Start with the name, making sure it exists and relates to an item.
                    if restoreSelectionName ~ = nil and config.itemsByName[restoreSelectionName] ~ = nil then
                        config:setSelectedItemName(restoreSelectionName)
                        -- If there is no valid name; fall back to the index.
                    elseif restoreSelectionIndex > 0 and restoreSelectionIndex < = #config.items then
                            config:setSelectedItemIndex(restoreSelectionIndex)
                        end
                    end

                    -- Set the hat hair style index to the last item with the forHat member.
                    for i = # self.configs.hairStyle.items, 1 , - 1 do
                        if self.configs.hairStyle.items[i].forHat then
                            self.hatHairstyleIndex = i
                            break
                        end
                    end

                    table.clear( self.facesByName)
                    for i, faceConfig in pairs( self.configs.face.items) do
                        self.facesByName[faceConfig.name] = faceConfig
                    end

                    if restoreFaceSelection ~ = nil then
                        self.configs.face:setSelectedItemName(restoreFaceSelection)
                    end

                    -- Nude body parts
                    table.clear( self.bodyParts)
                    table.clear( self.bodyPartIndexByName)
                    for _, key in xmlFile:iterator(rootKey .. ".bodyParts.bodyPart" ) do

                        -- Get the name of the i3d node from the node.This is used with the i3dMappings to get the desired node.
                        local nodeName = xmlFile:getValue(key .. "#node" )

                        -- Get the name of the body part.If none is given, default to the node name.
                        local name = xmlFile:getValue(key .. "#name" , nodeName)

                        -- Do not add the body part if it has already been defined.
                            if self.bodyPartIndexByName[name] ~ = nil then
                                Logging.devError( "Wardrobe body part name '%s' already used, skipping!" , name)
                                continue
                            end

                            -- Add the body part.
                            table.insert( self.bodyParts, { nodeName = nodeName, name = name } )
                            self.bodyPartIndexByName[name] = # self.bodyParts
                        end

                        -- Load all presets.
                        table.clear( self.presets)
                        table.clear( self.presetsByName)
                        for i, presetKey in xmlFile:iterator(rootKey .. ".presets.preset" ) do
                            local preset = PlayerStylePreset.new( self.xmlFilename)
                            preset:loadFromXMLNode(xmlFile, presetKey)

                            local isValid = true
                            for configName, configData in pairs(preset.configs) do
                                local itemName = configData.selectionName

                                local config = self.configs[configName]

                                if itemName ~ = "keepCurrent" and config.itemsByName[itemName] = = nil then
                                    isValid = false
                                    Logging.xmlWarning(xmlFile, "Style preset with name '%s' uses item '%s' for '%s' which does not exist!" , preset.name, itemName, configName)
                                    end
                                end

                                if isValid then
                                    if self.presetsByName[preset.name] ~ = nil then
                                        Logging.xmlError(xmlFile, "Style preset with name '%s' has already been defined!" , preset.name)
                                    else
                                            table.insert( self.presets, preset)
                                            self.presetsByName[preset.name] = preset
                                        end
                                    end
                                end

                                -- Set the style as having loaded, and close the file.
                                self.isConfigurationLoaded = true
                                xmlFile:delete()
                            end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function PlayerStyle.new(customMt)
    local self = setmetatable( { } , customMt or PlayerStyle _mt)

    self.disabledOptionsForSelection = { }

    -- The clothing presets(outfits).
    self.presets = { }
    self.presetsByName = { }

    -- The attachment point paths keyed by name.
    self.attachPoints = { }

    -- The body part names and paths of the player model.
    self.bodyParts = { }
    self.bodyPartIndexByName = { }

    -- The face configs keyed by name.
    self.facesByName = { }

    -- Is true if the configuration file(the Player0X.xml) has been loaded; otherwise false.
        self.isConfigurationLoaded = false

        -- Initialise the basic configs.
        self.configs = { }
        self.orderedConfigs = { }
        self:addConfig( PlayerStyleConfig.new( self , "hairStyle" , { PlayerStyleConfig.NOT_FOR_HAT_GETTER_FILTER } , false , true , true ))
        self:addConfig( PlayerStyleConfig.new( self , "glasses" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.SELECTED_GETTER_FILTER } , true ))
        self:addConfig( PlayerStyleConfig.new( self , "headgear" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.NOT_HIDDEN_GETTER_FILTER } ))
        self:addConfig( PlayerStyleConfig.new( self , "facegear" ))
        self:addConfig( PlayerStyleConfig.new( self , "face" ))
        self:addConfig( PlayerStyleConfig.new( self , "beard" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.BEARD_FACE_GETTER_FILTER } , false , false , true ))
        self:addConfig( PlayerStyleConfig.new( self , "top" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.NO_ONEPIECE_GETTER_FILTER } ))
        self:addConfig( PlayerStyleConfig.new( self , "gloves" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.NOT_HIDDEN_GETTER_FILTER } ))
        self:addConfig( PlayerStyleConfig.new( self , "bottom" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.NO_ONEPIECE_GETTER_FILTER } ))
        self:addConfig( PlayerStyleConfig.new( self , "footwear" , { PlayerStyleConfig.ENABLED_GETTER_FILTER } ))
        self:addConfig( PlayerStyleConfig.new( self , "onepiece" , { PlayerStyleConfig.ENABLED_GETTER_FILTER, PlayerStyleConfig.SELECTED_GETTER_FILTER } , true ))

        -- Unify the hair colors.
        self.configs.hairStyle:setSelectedColorIndex( self.configs.hairStyle:getSelectedColorIndex())

        -- Start with a face and hair.
        self.configs.face.selectedItemIndex = 1
        self.configs.hairStyle.selectedItemIndex = 2

        return self
    end

```

### readStream

**Description**

> Reads from network stream

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | id of the stream to read |
|---------|------------|--------------------------|
| table   | connection | connection information   |

**Code**

```lua
function PlayerStyle:readStream(streamId, connection)

    self.xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))

    -- If the configuration needs to be loaded; do so.This is required as selections are saved by name, and the config allows the names to be mapped to indices.
        self:loadConfigurationIfRequired()

        for _, config in ipairs( self.orderedConfigs) do
            config:readStream(streamId, connection)
        end

        self:updateDisabledOptions()

        -- Unify the hair colors.
        self.configs.hairStyle:setSelectedColorIndex( self.configs.hairStyle:getSelectedColorIndex())
    end

```

### writeStream

**Description**

> Writes in network stream

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | id of the stream to read |
|---------|------------|--------------------------|
| table   | connection | connection information   |

**Code**

```lua
function PlayerStyle:writeStream(streamId, connection)
    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.xmlFilename))

    for _, config in ipairs( self.orderedConfigs) do
        config:writeStream(streamId, connection)
    end
end

```