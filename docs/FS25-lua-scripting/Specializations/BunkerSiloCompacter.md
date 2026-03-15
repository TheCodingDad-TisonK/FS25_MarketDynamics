## BunkerSiloCompacter

**Description**

> Specialization for increasing bunker silo compaction level and playing samples during the process

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getBunkerSiloCompacterScale](#getbunkersilocompacterscale)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [initSpecialization](#initspecialization)
- [loadBunkerSiloCompactorFromXML](#loadbunkersilocompactorfromxml)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### doCheckSpeedLimit

**Description**

> Returns if speed limit should be checked

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | checkSpeedlimit | check speed limit |
|-----|-----------------|-------------------|

**Code**

```lua
function BunkerSiloCompacter:doCheckSpeedLimit(superFunc)
    local spec = self.spec_bunkerSiloCompacter
    if spec.useSpeedLimit then
        return superFunc( self ) or spec.lastIsCompacting
    end

    return superFunc( self )
end

```

### getBunkerSiloCompacterScale

**Description**

**Definition**

> getBunkerSiloCompacterScale()

**Code**

```lua
function BunkerSiloCompacter:getBunkerSiloCompacterScale()
    return self.spec_bunkerSiloCompacter.scale
end

```

### getDefaultSpeedLimit

**Description**

> Returns default speed limit

**Definition**

> getDefaultSpeedLimit()

**Return Values**

| any | speedLimit | speed limit |
|-----|------------|-------------|

**Code**

```lua
function BunkerSiloCompacter.getDefaultSpeedLimit()
    return 5
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function BunkerSiloCompacter.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "BunkerSiloCompacter" )

    schema:register(XMLValueType.FLOAT, BunkerSiloCompacter.XML_PATH .. "#compactingScale" , "Compacting scale" , 1 )
    schema:register(XMLValueType.BOOL, BunkerSiloCompacter.XML_PATH .. "#useSpeedLimit" , "Defines if speed limit is used while compactor has contact with ground" , false )

        SoundManager.registerSampleXMLPaths(schema, BunkerSiloCompacter.XML_PATH .. ".sounds" , "rolling" )
        SoundManager.registerSampleXMLPaths(schema, BunkerSiloCompacter.XML_PATH .. ".sounds" , "compacting" )

        schema:setXMLSpecializationType()
    end

```

### loadBunkerSiloCompactorFromXML

**Description**

**Definition**

> loadBunkerSiloCompactorFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function BunkerSiloCompacter:loadBunkerSiloCompactorFromXML(xmlFile, key)
    local spec = self.spec_bunkerSiloCompacter
    spec.scale = xmlFile:getValue(key .. "#compactingScale" , 1 )
    spec.useSpeedLimit = xmlFile:getValue(key .. "#useSpeedLimit" , false )
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function BunkerSiloCompacter:onDelete()
    local spec = self.spec_bunkerSiloCompacter
    g_soundManager:deleteSamples(spec.samples)
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
function BunkerSiloCompacter:onLoad(savegame)
    local spec = self.spec_bunkerSiloCompacter

    self:loadBunkerSiloCompactorFromXML( self.xmlFile, BunkerSiloCompacter.XML_PATH)

    if self.isClient then
        spec.samples = { }
        spec.samples.rolling = g_soundManager:loadSampleFromXML( self.xmlFile, BunkerSiloCompacter.XML_PATH .. ".sounds" , "rolling" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.compacting = g_soundManager:loadSampleFromXML( self.xmlFile, BunkerSiloCompacter.XML_PATH .. ".sounds" , "compacting" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.lastIsCompacting = false
        spec.lastHasGroundContact = false
    end

    if self.getWheels = = nil then
        SpecializationUtil.removeEventListener( self , "onUpdate" , BunkerSiloCompacter )
    end
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActive, boolean isActiveForInput, boolean isSelected)

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActive         | true if vehicle is active           |
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |

**Code**

```lua
function BunkerSiloCompacter:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_bunkerSiloCompacter
    local hasGroundContact = false
    local isCompacting = false

    local wheels = self:getWheels()
    for i = 1 , #wheels do
        local wheel = wheels[i]
        if wheel.physics.contact ~ = WheelContactType.NONE then
            hasGroundContact = true
            if wheel.physics.contact = = WheelContactType.GROUND_HEIGHT then
                isCompacting = true
                break
            end
        end
    end

    if spec.lastHasGroundContact ~ = hasGroundContact or spec.lastIsCompacting ~ = isCompacting then
        if hasGroundContact then
            if isCompacting then
                if not g_soundManager:getIsSamplePlaying(spec.samples.compacting) then
                    g_soundManager:playSample(spec.samples.compacting)
                end
            else
                    if g_soundManager:getIsSamplePlaying(spec.samples.compacting) then
                        g_soundManager:stopSample(spec.samples.compacting)
                    end
                end

                if not g_soundManager:getIsSamplePlaying(spec.samples.rolling) then
                    g_soundManager:playSample(spec.samples.rolling)
                end
            else
                    if g_soundManager:getIsSamplePlaying(spec.samples.compacting) then
                        g_soundManager:stopSample(spec.samples.compacting)
                    end
                    if g_soundManager:getIsSamplePlaying(spec.samples.rolling) then
                        g_soundManager:stopSample(spec.samples.rolling)
                    end
                end

                spec.lastHasGroundContact = hasGroundContact
                spec.lastIsCompacting = isCompacting
            end
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
function BunkerSiloCompacter.prerequisitesPresent(specializations)
    return true
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
function BunkerSiloCompacter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , BunkerSiloCompacter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , BunkerSiloCompacter )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , BunkerSiloCompacter )
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
function BunkerSiloCompacter.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadBunkerSiloCompactorFromXML" , BunkerSiloCompacter.loadBunkerSiloCompactorFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getBunkerSiloCompacterScale" , BunkerSiloCompacter.getBunkerSiloCompacterScale)
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
function BunkerSiloCompacter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , BunkerSiloCompacter.doCheckSpeedLimit)
end

```