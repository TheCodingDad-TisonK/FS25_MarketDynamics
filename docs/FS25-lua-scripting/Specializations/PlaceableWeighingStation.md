## PlaceableWeighingStation

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onLoad](#onload)
- [onWeighingTriggerCallback](#onweighingtriggercallback)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setWeightDisplay](#setweightdisplay)
- [updateWeightDisplay](#updateweightdisplay)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableWeighingStation:onDelete()
    local spec = self.spec_weighingStation

    if spec.trigger ~ = nil then
        removeTrigger(spec.trigger)
        spec.trigger = nil
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
function PlaceableWeighingStation:onLoad(savegame)
    local spec = self.spec_weighingStation

    local key = "placeable.weighingStation"

    spec.trigger = self.xmlFile:getValue(key .. "#triggerNode" , nil , self.components, self.i3dMappings)
    if spec.trigger = = nil then
        Logging.xmlError( self.xmlFile, "Missing vehicle triggerNode for weighing station" )
            return
        end

        addTrigger(spec.trigger, "onWeighingTriggerCallback" , self )
        spec.triggerVehicleNodes = { }
        spec.vehicles = { }

        spec.displays = { }
        self.xmlFile:iterate(key .. ".display" , function (_, displayKey)
            local displayNode = self.xmlFile:getValue(displayKey .. "#node" , nil , self.components, self.i3dMappings)
            if displayNode ~ = nil then
                local fontName = string.upper( self.xmlFile:getValue(displayKey .. "#font" , "DIGIT" ))
                local fontMaterial = g_materialManager:getFontMaterial(fontName, self.customEnvironment)

                if fontMaterial ~ = nil then
                    local display = { }

                    local alignmentStr = self.xmlFile:getValue(displayKey .. "#alignment" , "RIGHT" )
                    local alignment = RenderText[ "ALIGN_" .. string.upper(alignmentStr)] or RenderText.ALIGN_RIGHT

                    local size = self.xmlFile:getValue(displayKey .. "#size" , 0.03 )
                    local scaleX = self.xmlFile:getValue(displayKey .. "#scaleX" , 1 )
                    local scaleY = self.xmlFile:getValue(displayKey .. "#scaleY" , 1 )
                    local mask = self.xmlFile:getValue(displayKey .. "#mask" , "00.0" )
                    local emissiveScale = self.xmlFile:getValue(displayKey .. "#emissiveScale" , 0.2 )
                    local color = self.xmlFile:getValue(displayKey .. "#color" , { 0.9 , 0.9 , 0.9 , 1 } , true )
                    local hiddenColor = self.xmlFile:getValue(displayKey .. "#hiddenColor" , nil , true )

                    display.displayNode = displayNode
                    display.formatStr, display.formatPrecision = Utils.maskToFormat(mask)

                    display.characterLine = CharacterLine.new(displayNode, fontMaterial, mask:len())
                    display.characterLine:setSizeAndScale(size, scaleX, scaleY)
                    display.characterLine:setTextAlignment(alignment)
                    display.characterLine:setColor(color, hiddenColor, emissiveScale)

                    table.insert(spec.displays, display)
                end
            end
        end )

        self:setWeightDisplay( 0 )
    end

```

### onWeighingTriggerCallback

**Description**

> Trigger callback

**Definition**

> onWeighingTriggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger |
|---------|-----------|---------------|
| integer | otherId   | id of actor   |
| boolean | onEnter   | on enter      |
| boolean | onLeave   | on leave      |
| boolean | onStay    | on stay       |

**Code**

```lua
function PlaceableWeighingStation:onWeighingTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        local spec = self.spec_weighingStation
        if onEnter then
            spec.triggerVehicleNodes[otherId] = true
        else
                -- on leave
                spec.triggerVehicleNodes[otherId] = nil
            end

            self:updateWeightDisplay()
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
function PlaceableWeighingStation.prerequisitesPresent(specializations)
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
function PlaceableWeighingStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWeighingStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWeighingStation )
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
function PlaceableWeighingStation.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onWeighingTriggerCallback" , PlaceableWeighingStation.onWeighingTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "updateWeightDisplay" , PlaceableWeighingStation.updateWeightDisplay)
    SpecializationUtil.registerFunction(placeableType, "setWeightDisplay" , PlaceableWeighingStation.setWeightDisplay)
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
function PlaceableWeighingStation.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "WeighingStation" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".weighingStation#triggerNode" , "Vehicle trigger" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".weighingStation.display(?)#node" , "Display start node" )
    schema:register(XMLValueType.STRING, basePath .. ".weighingStation.display(?)#font" , "Display font name" )
    schema:register(XMLValueType.STRING, basePath .. ".weighingStation.display(?)#alignment" , "Display text alignment" )
    schema:register(XMLValueType.FLOAT, basePath .. ".weighingStation.display(?)#size" , "Display text size" )
    schema:register(XMLValueType.FLOAT, basePath .. ".weighingStation.display(?)#scaleX" , "Display text x scale" )
    schema:register(XMLValueType.FLOAT, basePath .. ".weighingStation.display(?)#scaleY" , "Display text y scale" )
    schema:register(XMLValueType.STRING, basePath .. ".weighingStation.display(?)#mask" , "Display text mask" )
    schema:register(XMLValueType.FLOAT, basePath .. ".weighingStation.display(?)#emissiveScale" , "Display emissive scale" )
    schema:register(XMLValueType.COLOR, basePath .. ".weighingStation.display(?)#color" , "Display text color" )
    schema:register(XMLValueType.COLOR, basePath .. ".weighingStation.display(?)#hiddenColor" , "Display text hidden color" )

    schema:setXMLSpecializationType()
end

```

### setWeightDisplay

**Description**

**Definition**

> setWeightDisplay()

**Arguments**

| any | mass |
|-----|------|

**Code**

```lua
function PlaceableWeighingStation:setWeightDisplay(mass)
    local spec = self.spec_weighingStation
    for _, display in ipairs(spec.displays) do
        local int, floatPart = math.modf(mass)

        local value = string.format(display.formatStr, int, math.abs( math.floor(floatPart * ( 10 ^ display.formatPrecision))))
        display.characterLine:setText(value)
    end
end

```

### updateWeightDisplay

**Description**

**Definition**

> updateWeightDisplay()

**Code**

```lua
function PlaceableWeighingStation:updateWeightDisplay()
    local spec = self.spec_weighingStation

    -- resolve nodes to vehicles, add to table to eliminate duplicates
    for node, _ in pairs(spec.triggerVehicleNodes) do
        if entityExists(node) then
            local vehicle = g_currentMission:getNodeObject(node)
            if vehicle ~ = nil and vehicle.getTotalMass ~ = nil then
                spec.vehicles[vehicle] = true
            end
        else
                -- vehicle does not exist anymore
                spec.triggerVehicleNodes[node] = nil
            end
        end

        local mass = 0
        for vehicle in pairs(spec.vehicles) do
            mass = mass + vehicle:getTotalMass( true )
        end
        table.clear(spec.vehicles)

        self:setWeightDisplay(mass * 1000 )
    end

```