## ManureSensor

**Description**

> Specialization for manure sensors

**Functions**

- [getCurrentNitrogenLevelOffset](#getcurrentnitrogenleveloffset)
- [getCurrentNitrogenUsageLevelOffset](#getcurrentnitrogenusageleveloffset)
- [getIsUsingExactNitrogenAmount](#getisusingexactnitrogenamount)
- [getManureSensorNitrogenOffset](#getmanuresensornitrogenoffset)
- [initSpecialization](#initspecialization)
- [linkManureSensor](#linkmanuresensor)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)

### getCurrentNitrogenLevelOffset

**Description**

**Definition**

> getCurrentNitrogenLevelOffset()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | lastChangeLevels |

**Code**

```lua
function ManureSensor:getCurrentNitrogenLevelOffset(superFunc, lastChangeLevels)
    local spec = self [ ManureSensor.SPEC_TABLE_NAME]

    if not spec.sensorRequired then
        return superFunc( self )
    end

    if not spec.sensorAvailable then
        return self:getManureSensorNitrogenOffset(lastChangeLevels)
    end

    return 0
end

```

### getCurrentNitrogenUsageLevelOffset

**Description**

**Definition**

> getCurrentNitrogenUsageLevelOffset()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | lastChangeLevels |

**Code**

```lua
function ManureSensor:getCurrentNitrogenUsageLevelOffset(superFunc, lastChangeLevels)
    local spec = self [ ManureSensor.SPEC_TABLE_NAME]

    if not spec.sensorRequired then
        return superFunc( self )
    end

    if spec.sensorAvailable then
        return self:getManureSensorNitrogenOffset(lastChangeLevels)
    end

    return 0
end

```

### getIsUsingExactNitrogenAmount

**Description**

**Definition**

> getIsUsingExactNitrogenAmount()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ManureSensor:getIsUsingExactNitrogenAmount(superFunc)
    local spec = self [ ManureSensor.SPEC_TABLE_NAME]

    if not spec.sensorRequired then
        return superFunc( self )
    end

    return spec.sensorAvailable
end

```

### getManureSensorNitrogenOffset

**Description**

**Definition**

> getManureSensorNitrogenOffset()

**Arguments**

| any | lastChangeLevels |
|-----|------------------|

**Code**

```lua
function ManureSensor:getManureSensorNitrogenOffset(lastChangeLevels)
    local spec = self [ ManureSensor.SPEC_TABLE_NAME]
    local curve = (g_ time % ManureSensor.CHANGE_TIME) / ManureSensor.CHANGE_TIME + spec.currentCurveOffset
    local offset = math.sin(curve * math.pi * 2 ) * 0.75 + math.sin(curve * math.pi * 10 ) * 0.15 + math.sin(curve * math.pi * 20 ) * 0.15
    local stepOffset = offset * (lastChangeLevels * ManureSensor.MAX_NITROGEN_OFFSET_PCT)
    local direction = math.sign(stepOffset)
    stepOffset = MathUtil.round( math.abs(stepOffset))
    return stepOffset * direction
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ManureSensor.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "manureSensor" , g_i18n:getText( "configuration_manureSensor" ), "manureSensor" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ManureSensor" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.manureSensor.manureSensorConfigurations.manureSensorConfiguration(?).linkNode#node" , "Sensor Link Node" )
    schema:register(XMLValueType.STRING, "vehicle.manureSensor.manureSensorConfigurations.manureSensorConfiguration(?).linkNode#type" , "Sensor Type(DEFAULT, LARGE, SMALL or STANDALONE)" )

    schema:setXMLSpecializationType()
end

```

### linkManureSensor

**Description**

**Definition**

> linkManureSensor()

**Arguments**

| any | linkData |
|-----|----------|

**Code**

```lua
function ManureSensor:linkManureSensor(linkData)
    for i = 1 , #linkData.linkNodes do
        local linkNodeData = linkData.linkNodes[i]

        local linkNode = linkNodeData.linkNode
        if linkNode = = nil and linkNodeData.nodeName ~ = nil then
            if self.i3dMappings[linkNodeData.nodeName] ~ = nil then
                linkNode = self.i3dMappings[linkNodeData.nodeName].nodeId
            end
        end

        if linkNode ~ = nil then
            local sensorData = g_precisionFarming:getClonedManureSensorNode(linkNodeData.typeName)
            if sensorData ~ = nil then
                link(linkNode, sensorData.node)

                if linkNodeData.translation ~ = nil then
                    setTranslation(sensorData.node, linkNodeData.translation[ 1 ], linkNodeData.translation[ 2 ], linkNodeData.translation[ 3 ])
                end
                if linkNodeData.rotation ~ = nil then
                    setRotation(sensorData.node, linkNodeData.rotation[ 1 ], linkNodeData.rotation[ 2 ], linkNodeData.rotation[ 3 ])
                end
                if linkNodeData.scale ~ = nil then
                    setScale(sensorData.node, linkNodeData.scale[ 1 ], linkNodeData.scale[ 2 ], linkNodeData.scale[ 3 ])
                end
            end
        end
    end

    self [ ManureSensor.SPEC_TABLE_NAME].sensorAvailable = true
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function ManureSensor:onLoad(savegame)
    local spec = self [ ManureSensor.SPEC_TABLE_NAME]

    spec.currentCurveOffset = math.random()

    spec.sensorRequired = false
    local fillUnits = self:getFillUnits()
    for i = 1 , #fillUnits do
        spec.sensorRequired = spec.sensorRequired or self:getFillUnitAllowsFillType(i, FillType.LIQUIDMANURE) or self:getFillUnitAllowsFillType(i, FillType.DIGESTATE)
    end

    spec.sensorAvailable = false

    local configIndex = self.configurations[ "manureSensor" ]
    if configIndex ~ = nil then
        local configKey = string.format( "vehicle.manureSensor.manureSensorConfigurations.manureSensorConfiguration(%d)" , configIndex - 1 )

        local linkNode = self.xmlFile:getValue(configKey .. ".linkNode#node" , nil , self.components, self.i3dMappings)
        if linkNode ~ = nil then
            local typeName = self.xmlFile:getValue(configKey .. ".linkNode#type" , "DEFAULT" )
            local linkData = { }
            linkData.linkNodes = { }
            linkData.linkNodes[ 1 ] = { linkNode = linkNode,
            typeName = typeName
            }
            self:linkManureSensor(linkData)
        end

        if configIndex > 1 then
            if g_precisionFarming ~ = nil then
                local linkData = g_precisionFarming:getManureSensorLinkageData( self.configFileName)
                if linkData ~ = nil then
                    self:linkManureSensor(linkData)
                end
            end
        end
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function ManureSensor.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Sprayer , specializations) and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```