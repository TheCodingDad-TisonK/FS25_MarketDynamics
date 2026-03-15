## VineCutter

**Description**

> Specialization for vine cutters

**Functions**

- [initSpecialization](#initspecialization)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function VineCutter.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "vineCutter" , g_i18n:getText( "shop_configuration" ), "vineCutter" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "VineCutter" )
    schema:register(XMLValueType.STRING, "vehicle.vineCutter#fruitType" , "Fruit type" )
    schema:register(XMLValueType.STRING, "vehicle.vineCutter.vineCutterConfigurations.vineCutterConfiguration(?)#fruitType" , "Fruit type" )
    schema:setXMLSpecializationType()
end

```

### onDraw

**Description**

> Called on draw

**Definition**

> onDraw(boolean isActiveForInput, boolean isSelected, )

**Arguments**

| boolean | isActiveForInput | true if vehicle is active for input |
|---------|------------------|-------------------------------------|
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function VineCutter:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_vineCutter
    if spec.showFarmlandNotOwnedWarning then
        g_currentMission:showBlinkingWarning(spec.warningYouDontHaveAccessToThisLand)
    end
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
function VineCutter:onLoad(savegame)
    local spec = self.spec_vineCutter

    local configurationId = self.configurations[ "vineCutter" ] or 1
    local configKey = string.format( "vehicle.vineCutter.vineCutterConfigurations.vineCutterConfiguration(%d)" , configurationId - 1 )

    local fruitTypeName = self.xmlFile:getValue(configKey .. "#fruitType" )
    if fruitTypeName = = nil then
        fruitTypeName = self.xmlFile:getValue( "vehicle.vineCutter#fruitType" )
    end

    local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
    if fruitType ~ = nil then
        spec.inputFruitTypeIndex = fruitType.index
    else
            spec.inputFruitTypeIndex = FruitType.GRAPE
        end

        spec.outputFillTypeIndex = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.inputFruitTypeIndex)

        spec.showFarmlandNotOwnedWarning = false
        spec.warningYouDontHaveAccessToThisLand = g_i18n:getText( "warning_youDontHaveAccessToThisLand" )
    end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function VineCutter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(VineDetector, specializations)
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VineCutter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , VineCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , VineCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , VineCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , VineCutter )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VineCutter.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getCombine" , VineCutter.getCombine)
    SpecializationUtil.registerFunction(vehicleType, "harvestCallback" , VineCutter.harvestCallback)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VineCutter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , VineCutter.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartVineDetection" , VineCutter.getCanStartVineDetection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsValidVinePlaceable" , VineCutter.getIsValidVinePlaceable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleVinePlaceable" , VineCutter.handleVinePlaceable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "clearCurrentVinePlaceable" , VineCutter.clearCurrentVinePlaceable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIImplementUseVineSegment" , VineCutter.getAIImplementUseVineSegment)
end

```