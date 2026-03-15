## PlaceableWindTurbine

**Description**

> Specialization for placeables

**Functions**

- [getIncomePerHour](#getincomeperhour)
- [getWindTurbineLoad](#getwindturbineload)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setWindValues](#setwindvalues)
- [updateHeadRotation](#updateheadrotation)
- [updateRotorRotSpeed](#updaterotorrotspeed)

### getIncomePerHour

**Description**

**Definition**

> getIncomePerHour()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableWindTurbine:getIncomePerHour(superFunc)
    local spec = self.spec_windTurbine

    local incomePerHour = superFunc( self )

    incomePerHour = incomePerHour + spec.incomePerHour * spec.rotSpeedFactor

    return incomePerHour
end

```

### getWindTurbineLoad

**Description**

**Definition**

> getWindTurbineLoad()

**Code**

```lua
function PlaceableWindTurbine:getWindTurbineLoad()
    local spec = self.spec_windTurbine
    return spec.rotSpeedFactor
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableWindTurbine:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_windTurbine
    if spec.headNode ~ = nil then
        spec.headRotation = xmlFile:getValue(key .. "#headRotation" , 0 )
        self:updateHeadRotation()
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableWindTurbine:onDelete()
    g_currentMission.environment.weather.windUpdater:removeWindChangedListener( self )

    local spec = self.spec_windTurbine
    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableWindTurbine:onFinalizePlacement()
    local spec = self.spec_windTurbine

    if spec.isFinalized then
        self:startWindTurbine()
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
function PlaceableWindTurbine:onLoad(savegame)
    local spec = self.spec_windTurbine

    local headNode = self.xmlFile:getValue( "placeable.windTurbine#headNode" , nil , self.components, self.i3dMappings)
    if headNode ~ = nil then
        spec.headNode = headNode
        spec.headAdjustToWind = self.xmlFile:getValue( "placeable.windTurbine#headAdjustToWind" , false )
        spec.headRotation = 0
    end

    spec.rotorOptimalWindSpeed = math.clamp( self.xmlFile:getValue( "placeable.windTurbine#optimalWindSpeed" , 15 ), 1 , 200 )
    spec.rotSpeedFactor = 1
    spec.incomePerHour = self.xmlFile:getValue( "placeable.windTurbine#incomePerHour" , 0 )
    spec.isFinalized = self.xmlFile:getBool( "placeable.windTurbine#isFinalized" , true )

    if self.isClient then
        spec.samples = { }
        spec.samples.idle = g_soundManager:loadSampleFromXML( self.xmlFile, "placeable.windTurbine.sounds" , "idle" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "placeable.windTurbine.animationNodes" , self.components, self , self.i3dMappings)
        for _, anim in ipairs(spec.animationNodes) do
            anim.speedFunc = function ()
                return spec.rotSpeedFactor
            end
        end
    end
end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableWindTurbine:onReadStream(streamId, connection)
    local spec = self.spec_windTurbine
    if spec.headNode ~ = nil then
        spec.headRotation = NetworkUtil.readCompressedAngle(streamId)
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableWindTurbine:onWriteStream(streamId, connection)
    local spec = self.spec_windTurbine
    if spec.headNode ~ = nil then
        NetworkUtil.writeCompressedAngle(streamId, spec.headRotation)
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
function PlaceableWindTurbine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableIncomePerHour , specializations)
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
function PlaceableWindTurbine.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWindTurbine )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWindTurbine )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableWindTurbine )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableWindTurbine )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableWindTurbine )
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
function PlaceableWindTurbine.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateHeadRotation" , PlaceableWindTurbine.updateHeadRotation)
    SpecializationUtil.registerFunction(placeableType, "updateRotorRotSpeed" , PlaceableWindTurbine.updateRotorRotSpeed)
    SpecializationUtil.registerFunction(placeableType, "setWindValues" , PlaceableWindTurbine.setWindValues)
    SpecializationUtil.registerFunction(placeableType, "getWindTurbineLoad" , PlaceableWindTurbine.getWindTurbineLoad)
    SpecializationUtil.registerFunction(placeableType, "startWindTurbine" , PlaceableWindTurbine.startWindTurbine)
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
function PlaceableWindTurbine.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getIncomePerHour" , PlaceableWindTurbine.getIncomePerHour)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "finalizeConstruction" , PlaceableWindTurbine.finalizeConstruction)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableWindTurbine.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "WindTurbine" )
    schema:register(XMLValueType.ANGLE, basePath .. "#headRotation" , "Current head rotation" )
    schema:setXMLSpecializationType()
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
function PlaceableWindTurbine.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "WindTurbine" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".windTurbine#headNode" , "Head node" )
    schema:register(XMLValueType.BOOL, basePath .. ".windTurbine#headAdjustToWind" , "Adjust head node to current wind direction" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".windTurbine#rotationNode" , "Rotor rotation node, rotated on z-axis" )
    schema:register(XMLValueType.FLOAT, basePath .. ".windTurbine#optimalWindSpeed" , "Wind speed in m/s at which rotor reaches max rpm" )
    schema:register(XMLValueType.FLOAT, basePath .. ".windTurbine#incomePerHour" , "Income per hour" )
    schema:register(XMLValueType.BOOL, basePath .. ".windTurbine#isFinalized" , "If the wind turbine is finalized and ready on start.E.g.constructible" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".windTurbine.sounds" , "idle" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".windTurbine.animationNodes" )
    schema:setXMLSpecializationType()
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function PlaceableWindTurbine:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_windTurbine
    if spec.headNode ~ = nil then
        xmlFile:setValue(key .. "#headRotation" , spec.headRotation)
    end
end

```

### setWindValues

**Description**

**Definition**

> setWindValues()

**Arguments**

| any | windDirX               |
|-----|------------------------|
| any | windDirZ               |
| any | windVelocity           |
| any | cirrusCloudSpeedFactor |

**Code**

```lua
function PlaceableWindTurbine:setWindValues(windDirX, windDirZ, windVelocity, cirrusCloudSpeedFactor)
    local spec = self.spec_windTurbine
    if spec.headAdjustToWind and spec.headNode ~ = nil then
        spec.headRotation = MathUtil.getYRotationFromDirection( - windDirX, - windDirZ)
        self:updateHeadRotation()
    end

    self:updateRotorRotSpeed(windVelocity)
end

```

### updateHeadRotation

**Description**

**Definition**

> updateHeadRotation()

**Code**

```lua
function PlaceableWindTurbine:updateHeadRotation()
    local spec = self.spec_windTurbine
    if spec.headNode ~ = nil then
        setWorldRotation(spec.headNode, 0 , spec.headRotation, 0 )
    end
end

```

### updateRotorRotSpeed

**Description**

**Definition**

> updateRotorRotSpeed()

**Arguments**

| any | windVelocity |
|-----|--------------|

**Code**

```lua
function PlaceableWindTurbine:updateRotorRotSpeed(windVelocity)
    local spec = self.spec_windTurbine
    spec.rotSpeedFactor = math.clamp(windVelocity / spec.rotorOptimalWindSpeed, 0 , 1 )

    if self.isClient then
        if spec.rotSpeedFactor > 0 then
            if not g_soundManager:getIsSamplePlaying(spec.samples.idle) then
                g_soundManager:playSample(spec.samples.idle, 0 )
            end
        else
                if g_soundManager:getIsSamplePlaying(spec.samples.idle) then
                    g_soundManager:stopSample(spec.samples.idle)
                end
            end
        end
    end

```