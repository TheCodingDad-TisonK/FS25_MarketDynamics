## VehicleConfigurationDataSprayerNodes

**Description**

> Adds the sprayer nozzle and sensor nodes for all configurations

**Functions**

- [onPrePostLoad](#onprepostload)
- [registerXMLPaths](#registerxmlpaths)

### onPrePostLoad

**Description**

**Definition**

> onPrePostLoad()

**Arguments**

| any | vehicle    |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function VehicleConfigurationDataSprayerNodes.onPrePostLoad(vehicle, configItem, configId)
    if configItem.configKey = = "" then
        return
    end

    local spec = vehicle[ ExtendedSprayerEffects.SPEC_TABLE_NAME]
    if spec ~ = nil then
        for _, key in vehicle.xmlFile:iterator(configItem.configKey .. ".sprayerNozzles.nozzle" ) do
            local linkNode = vehicle.xmlFile:getValue(key .. "#node" , nil , vehicle.components, vehicle.i3dMappings)
            if linkNode ~ = nil then
                local effectNode = g_precisionFarming:getClonedSprayerEffectNode()
                if effectNode ~ = nil then
                    local effectNodeData = { }
                    effectNodeData.translation = vehicle.xmlFile:getValue(key .. "#translation" , { 0 , 0 , 0 } , true )
                    effectNodeData.rotation = vehicle.xmlFile:getValue(key .. "#rotation" , { 0 , 0 , 0 } , true )

                    local effectData = { }
                    if vehicle:addExtendedSprayerNozzleEffect(effectData, effectNode, linkNode, effectNodeData) then
                        table.insert(spec.sprayerEffects, effectData)
                    end
                end
            end
        end
    end

    if vehicle[ WeedSpotSpray.SPEC_TABLE_NAME] ~ = nil then
        if vehicle[ WeedSpotSpray.SPEC_TABLE_NAME].isEnabled then
            local linkData = { }
            linkData.sensorNodes = { }
            for _, sensorNodeKey in vehicle.xmlFile:iterator(configItem.configKey .. ".weedSpotSpraySensors.sensorNode" ) do
                local sensorNode = { }
                sensorNode.id = vehicle.xmlFile:getValue(sensorNodeKey .. "#id" )
                sensorNode.nodeName = vehicle.xmlFile:getValue(sensorNodeKey .. "#node" )
                sensorNode.translation = vehicle.xmlFile:getValue(sensorNodeKey .. "#translation" , "0 0 0" , true )
                sensorNode.rotation = vehicle.xmlFile:getValue(sensorNodeKey .. "#rotation" , "0 0 0" , true )
                sensorNode.bracketSize = vehicle.xmlFile:getValue(sensorNodeKey .. "#bracketSize" , 1 )

                table.insert(linkData.sensorNodes, sensorNode)
            end

            if #linkData.sensorNodes > 0 then
                vehicle:addWeedSpotSpraySensorNodes(linkData)
            end
        end
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
function VehicleConfigurationDataSprayerNodes.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.NODE_INDEX, configPath .. ".sprayerNozzles.nozzle(?)#node" , "Nozzle Node" )
    schema:register(XMLValueType.VECTOR_TRANS, configPath .. ".sprayerNozzles.nozzle(?)#translation" , "Translation offset from the defined node" )
    schema:register(XMLValueType.VECTOR_ROT, configPath .. ".sprayerNozzles.nozzle(?)#rotation" , "Rotation offset from the defined node" )

    schema:register(XMLValueType.STRING, configPath .. ".weedSpotSpraySensors.sensorNode(?)#id" , "Sensor identifier of the type to use" )
    schema:register(XMLValueType.STRING, configPath .. ".weedSpotSpraySensors.sensorNode(?)#node" , "Name of node in i3d mapping" )
    schema:register(XMLValueType.VECTOR_TRANS, configPath .. ".weedSpotSpraySensors.sensorNode(?)#translation" , "Translation offset from node" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ROT, configPath .. ".weedSpotSpraySensors.sensorNode(?)#rotation" , "Rotation offset from node" , "0 0 0" )
    schema:register(XMLValueType.FLOAT, configPath .. ".weedSpotSpraySensors.sensorNode(?)#bracketSize" , "Size of the bracket" , 1 )
end

```