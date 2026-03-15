## VehicleConfigurationDataOverwrites

**Description**

> Adds the possibility to overwrite other xml attributes

**Functions**

- [onPreLoad](#onpreload)
- [registerXMLPaths](#registerxmlpaths)

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | vehicle    |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function VehicleConfigurationDataOverwrites.onPreLoad(vehicle, configItem, configId)
    local xmlFile = vehicle.xmlFile
    local configKey = configItem.configKey
    if configKey = = "" then
        return
    end

    xmlFile:iterate(configKey .. ".xmlOverwrites.remove" , function (_, key)
        local attributePath = xmlFile:getString(key .. "#path" )

        xmlFile:removeProperty(attributePath)
    end )

    xmlFile:iterate(configKey .. ".xmlOverwrites.set" , function (_, key)
        local attributePath = xmlFile:getString(key .. "#path" )
        local attributeValue = xmlFile:getString(key .. "#value" )

        xmlFile:setString(attributePath, attributeValue)
    end )

    xmlFile:iterate(configKey .. ".xmlOverwrites.clearList" , function (_, key)
        local attributePath = xmlFile:getString(key .. "#path" )
        local keepIndex = xmlFile:getInt(key .. "#keepIndex" )

        local numItems = 0
        while true do
            if xmlFile:hasProperty( string.format(attributePath .. "(%d)" , numItems)) then
                numItems = numItems + 1
            else
                    break
                end
            end

            for i = numItems, 1 , - 1 do
                if i ~ = keepIndex then
                    xmlFile:removeProperty( string.format(attributePath .. "(%d)" , i - 1 ))
                end
            end
        end )
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
function VehicleConfigurationDataOverwrites.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.STRING, configPath .. ".xmlOverwrites.remove(?)#path" , "Path to remove from parent xml" )
    schema:register(XMLValueType.STRING, configPath .. ".xmlOverwrites.set(?)#path" , "Path change in parent xml" )
    schema:register(XMLValueType.STRING, configPath .. ".xmlOverwrites.set(?)#value" , "Target value to set in parent file" )
    schema:register(XMLValueType.STRING, configPath .. ".xmlOverwrites.clearList(?)#path" , "List to clear but keep one item" )
    schema:register(XMLValueType.INT, configPath .. ".xmlOverwrites.clearList(?)#keepIndex" , "Index of list to keep" )
end

```