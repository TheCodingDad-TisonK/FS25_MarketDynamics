## PlaceableIncomePerHour

**Description**

> Specialization for placeables

**Functions**

- [getIncomePerHour](#getincomeperhour)
- [getNeedHourChanged](#getneedhourchanged)
- [getSpecValueIncomePerHour](#getspecvalueincomeperhour)
- [initSpecialization](#initspecialization)
- [loadSpecValueIncomePerHour](#loadspecvalueincomeperhour)
- [onHourChanged](#onhourchanged)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)

### getIncomePerHour

**Description**

**Definition**

> getIncomePerHour()

**Code**

```lua
function PlaceableIncomePerHour:getIncomePerHour()
    local spec = self.spec_incomePerHour
    return spec.incomePerHour
end

```

### getNeedHourChanged

**Description**

**Definition**

> getNeedHourChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableIncomePerHour:getNeedHourChanged(superFunc)
    return true
end

```

### getSpecValueIncomePerHour

**Description**

> Returns value of income per hour

**Definition**

> getSpecValueIncomePerHour(table storeItem, table realItem)

**Arguments**

| table | storeItem | store item |
|-------|-----------|------------|
| table | realItem  | real item  |

**Return Values**

| table | incomePerHour | income per hour |
|-------|---------------|-----------------|

**Code**

```lua
function PlaceableIncomePerHour.getSpecValueIncomePerHour(storeItem, realItem)
    if storeItem.specs.incomePerHour = = nil then
        return nil
    end

    local fixedIncome, variableIncome = unpack(storeItem.specs.incomePerHour)

    fixedIncome = fixedIncome * 24 -- 24 hours in an un-adjusted month

    if variableIncome ~ = 0 then
        variableIncome = variableIncome * 24
        local maxTotalIncome = fixedIncome + variableIncome

        -- display income range
        return string.format( "%s - %s / %s" , g_i18n:formatMoney(fixedIncome, nil , false ), g_i18n:formatMoney(maxTotalIncome), g_i18n:getText( "ui_month" ))
    end

    -- display just fixed income
    return string.format( "%s / %s" , g_i18n:formatMoney(fixedIncome), g_i18n:getText( "ui_month" ))
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableIncomePerHour.initSpecialization()
    g_storeManager:addSpecType( "incomePerHour" , "shopListAttributeIconIncomePerHour" , PlaceableIncomePerHour.loadSpecValueIncomePerHour, PlaceableIncomePerHour.getSpecValueIncomePerHour, StoreSpecies.PLACEABLE)
    g_placeableConfigurationManager:addConfigurationType( "incomePerHour" , g_i18n:getText( "configuration_incomePerHour" ), "incomePerHour" , PlaceableConfigurationItem )
end

```

### loadSpecValueIncomePerHour

**Description**

> Loads capacity spec value

**Definition**

> loadSpecValueIncomePerHour(XMLFile xmlFile, string customEnvironment, )

**Arguments**

| XMLFile | xmlFile           | XMLFile instance   |
|---------|-------------------|--------------------|
| string  | customEnvironment | custom environment |
| any     | baseDir           |                    |

**Return Values**

| any | capacityAndUnit | capacity and unit |
|-----|-----------------|-------------------|

**Code**

```lua
function PlaceableIncomePerHour.loadSpecValueIncomePerHour(xmlFile, customEnvironment, baseDir)
    local incomePerHour = xmlFile:getValue( "placeable.incomePerHour.incomePerHourConfigurations.incomePerHourConfiguration(0)#incomePerHour" , xmlFile:getValue( "placeable.incomePerHour" , 0 ))

    local windTurbineIncomePerHour = xmlFile:getValue( "placeable.windTurbine#incomePerHour" , 0 )

    local solarPanelsDefaultConfigIncomePerHour = xmlFile:getValue( "placeable.solarPanels.solarPanelsConfigurations.solarPanelsConfiguration(0)#incomePerHour" , 0 )

    if incomePerHour = = 0 and windTurbineIncomePerHour = = 0 and solarPanelsDefaultConfigIncomePerHour = = 0 then
        return nil
    end

    return { incomePerHour, windTurbineIncomePerHour + solarPanelsDefaultConfigIncomePerHour } -- store fixed and variable incomes separately
end

```

### onHourChanged

**Description**

> Called if hour changed

**Definition**

> onHourChanged()

**Code**

```lua
function PlaceableIncomePerHour:onHourChanged()
    if self.isServer then
        local ownerFarmId = self:getOwnerFarmId()
        if ownerFarmId ~ = FarmlandManager.NO_OWNER_FARM_ID then
            local environment = g_currentMission.environment
            local incomePerHour = self:getIncomePerHour() * environment.timeAdjustment

            if incomePerHour ~ = 0 then
                g_currentMission:addMoney(incomePerHour, ownerFarmId, MoneyType.PROPERTY_INCOME, true )
            end
        end
    end
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function PlaceableIncomePerHour:onLoad(savegame)
    local spec = self.spec_incomePerHour
    local xmlFile = self.xmlFile

    local configurationId = self.configurations[ "incomePerHour" ] or 1
    local configKey = string.format( "placeable.incomePerHour.incomePerHourConfigurations.incomePerHourConfiguration(%d)#incomePerHour" , configurationId - 1 )

    spec.incomePerHour = xmlFile:getValue(configKey) or xmlFile:getValue( "placeable.incomePerHour" , 0 )
    spec.incomePerHourFactor = 1
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
function PlaceableIncomePerHour.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableIncomePerHour.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableIncomePerHour )
    SpecializationUtil.registerEventListener(placeableType, "onHourChanged" , PlaceableIncomePerHour )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableIncomePerHour.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getIncomePerHour" , PlaceableIncomePerHour.getIncomePerHour)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableIncomePerHour.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getNeedHourChanged" , PlaceableIncomePerHour.getNeedHourChanged)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableIncomePerHour.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "IncomePerHour" )

    schema:register(XMLValueType.FLOAT, basePath .. ".incomePerHour.incomePerHourConfigurations.incomePerHourConfiguration(?)#incomePerHour" , "Income per hour" )
    schema:register(XMLValueType.FLOAT, basePath .. ".incomePerHour" , "Income per hour" )
    schema:setXMLSpecializationType()
end

```