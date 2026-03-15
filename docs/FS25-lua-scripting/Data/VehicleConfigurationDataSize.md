## VehicleConfigurationDataSize

**Description**

> Adds vehicle size change functionality to all configurations

**Functions**

- [onSizeLoad](#onsizeload)
- [registerXMLPaths](#registerxmlpaths)

### onSizeLoad

**Description**

**Definition**

> onSizeLoad()

**Arguments**

| any | configItem |
|-----|------------|
| any | xmlFile    |
| any | sizeData   |

**Code**

```lua
function VehicleConfigurationDataSize.onSizeLoad(configItem, xmlFile, sizeData)
    if configItem.configKey = = "" then
        return
    end

    local key = configItem.configKey .. ".size"

    -- configuration values will completely overwrite the size values
    sizeData.width = xmlFile:getValue(key .. "#width" , sizeData.width)
    sizeData.length = xmlFile:getValue(key .. "#length" , sizeData.length)
    sizeData.height = xmlFile:getValue(key .. "#height" , sizeData.height)
    sizeData.widthOffset = xmlFile:getValue(key .. "#widthOffset" , sizeData.widthOffset)
    sizeData.lengthOffset = xmlFile:getValue(key .. "#lengthOffset" , sizeData.lengthOffset)
    sizeData.heightOffset = xmlFile:getValue(key .. "#heightOffset" , sizeData.heightOffset)

    local minWidth = xmlFile:getValue(key .. "#minWidth" )
    if minWidth ~ = nil then
        sizeData.minWidth = math.max(minWidth, sizeData.minWidth or 0 )
    end

    local minLength = xmlFile:getValue(key .. "#minLength" )
    if minLength ~ = nil then
        sizeData.minLength = math.max(minLength, sizeData.minLength or 0 )
    end

    local minHeight = xmlFile:getValue(key .. "#minHeight" )
    if minHeight ~ = nil then
        sizeData.minHeight = math.max(minHeight, sizeData.minHeight or 0 )
    end
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema     |
|-----|------------|
| any | rootPath   |
| any | configPath |

**Code**

```lua
function VehicleConfigurationDataSize.registerXMLPaths(schema, rootPath, configPath)
    schema:setXMLSharedRegistration( "VehicleConfigurationDataSize" , configPath)

    local sizeKey = configPath .. ".size"
    schema:register(XMLValueType.FLOAT, sizeKey .. "#width" , "occupied width of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#length" , "occupied length of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#height" , "occupied height of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#minWidth" , "Minimum width of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#minLength" , "Minimum length of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#minHeight" , "Minimum height of the vehicle when loaded in this configuration" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#widthOffset" , "width offset" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#lengthOffset" , "length offset" )
    schema:register(XMLValueType.FLOAT, sizeKey .. "#heightOffset" , "height offset" )

    schema:resetXMLSharedRegistration( "VehicleConfigurationDataSize" , configPath)
end

```