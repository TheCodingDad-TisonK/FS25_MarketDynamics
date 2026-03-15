## PlaceableWeatherStation

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableWeatherStation:onDelete()
    g_currentMission.placeableSystem:removeWeatherStation( self )

    if self.isClient then
        local spec = self.spec_weatherStation
        g_soundManager:deleteSample(spec.sample)
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableWeatherStation:onFinalizePlacement()
    g_currentMission.placeableSystem:addWeatherStation( self )

    if self.isClient then
        local spec = self.spec_weatherStation
        if spec.sample ~ = nil then
            g_soundManager:playSample(spec.sample)
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
function PlaceableWeatherStation:onLoad(savegame)
    local spec = self.spec_weatherStation

    if self.isClient then
        spec.sample = g_soundManager:loadSampleFromXML( self.xmlFile, "placeable.weatherStation.sounds" , "idle" , self.baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, nil )
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
function PlaceableWeatherStation.prerequisitesPresent(specializations)
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
function PlaceableWeatherStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWeatherStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWeatherStation )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableWeatherStation )
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
function PlaceableWeatherStation.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "WeatherStation" )

    SoundManager.registerSampleXMLPaths(schema, basePath .. ".weatherStation.sounds" , "idle" )

    schema:setXMLSpecializationType()
end

```