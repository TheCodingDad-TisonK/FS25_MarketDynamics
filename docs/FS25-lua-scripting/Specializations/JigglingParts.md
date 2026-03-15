## JigglingParts

**Description**

> Specialization for letting parts (e.g. sowing coulters) shake during work using a shader

**Functions**

- [initSpecialization](#initspecialization)
- [isJigglingPartActive](#isjigglingpartactive)
- [loadJigglingPartsFromXML](#loadjigglingpartsfromxml)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [updateJigglingPart](#updatejigglingpart)

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function JigglingParts.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "JigglingParts" )

    local basePath = JigglingParts.JIGGLING_PART_XML_KEY
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Jiggling node" )

    schema:register(XMLValueType.FLOAT, basePath .. "#speedScale" , "Speed scale" , 1 )
    schema:register(XMLValueType.STRING, basePath .. "#shaderParameter" , "Shader parameter" , "amplFreq" )
    schema:register(XMLValueType.STRING, basePath .. "#shaderParameterPrev" , "Shader parameter previous frame" , "prevAmplFreq" )
    schema:register(XMLValueType.INT, basePath .. "#shaderParameterComponentSpeed" , "Shader component speed index" , 4 )
    schema:register(XMLValueType.INT, basePath .. "#shaderParameterComponentAmplitude" , "Shader component amplitude index" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#amplitudeScale" , "Amplitude scale" , 4 )
    schema:register(XMLValueType.INT, basePath .. "#refNodeIndex" , "Ground reference node index" )

    schema:setXMLSpecializationType()
end

```

### isJigglingPartActive

**Description**

**Definition**

> isJigglingPartActive()

**Arguments**

| any | jigglingPart |
|-----|--------------|

**Code**

```lua
function JigglingParts:isJigglingPartActive(jigglingPart)
    if jigglingPart.refNodeIndex ~ = nil and jigglingPart.refNode = = nil then
        if self.getGroundReferenceNodeFromIndex ~ = nil then
            local refNode = self:getGroundReferenceNodeFromIndex(jigglingPart.refNodeIndex)
            if refNode ~ = nil then
                jigglingPart.refNode = refNode
            end
        end

        if jigglingPart.refNode = = nil then
            Logging.xmlWarning( self.xmlFile, "Unable to find ground reference node '%d' for jiggling part '%s'" , jigglingPart.refNodeIndex, getName(jigglingPart.node))
            end

            jigglingPart.refNodeIndex = nil
        end

        if jigglingPart.refNode ~ = nil then
            if not self:getIsGroundReferenceNodeActive(jigglingPart.refNode) then
                return false
            end
        end

        return true
    end

```

### loadJigglingPartsFromXML

**Description**

**Definition**

> loadJigglingPartsFromXML()

**Arguments**

| any | jigglingPart |
|-----|--------------|
| any | xmlFile      |
| any | key          |

**Code**

```lua
function JigglingParts:loadJigglingPartsFromXML(jigglingPart, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    jigglingPart.currentTime = 0
    jigglingPart.currentAmplitudeScale = 0

    jigglingPart.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if jigglingPart.node = = nil then
        Logging.xmlWarning( self.xmlFile, "Failed to load node for jiggling part '%s'" , key)
            return false
        end

        jigglingPart.speedScale = xmlFile:getValue(key .. "#speedScale" , 1 )
        jigglingPart.shaderParameter = xmlFile:getValue(key .. "#shaderParameter" , "amplFreq" )
        jigglingPart.shaderParameterPrev = xmlFile:getValue(key .. "#shaderParameterPrev" , "prevAmplFreq" )
        jigglingPart.shaderParameterComponentSpeed = xmlFile:getValue(key .. "#shaderParameterComponentSpeed" , 4 )
        jigglingPart.shaderParameterComponentAmplitude = xmlFile:getValue(key .. "#shaderParameterComponentAmplitude" , 1 )
        jigglingPart.amplitudeScale = xmlFile:getValue(key .. "#amplitudeScale" , 4.0 )

        jigglingPart.refNodeIndex = xmlFile:getValue(key .. "#refNodeIndex" )

        jigglingPart.values = { 0 , 0 , 0 , 0 }

        return true
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
function JigglingParts:onLoad(savegame)
    local spec = self.spec_jigglingParts

    spec.parts = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.jigglingParts.jigglingPart(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local jigglingPart = { }
        if self:loadJigglingPartsFromXML(jigglingPart, self.xmlFile, key) then
            table.insert(spec.parts, jigglingPart)
        end

        i = i + 1
    end

    if #spec.parts = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , JigglingParts )
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function JigglingParts:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_jigglingParts
    for _, jigglingPart in ipairs(spec.parts) do
        if self:isJigglingPartActive(jigglingPart) then
            self:updateJigglingPart(jigglingPart, dt, true )
        elseif jigglingPart.currentAmplitudeScale > 0 then
                self:updateJigglingPart(jigglingPart, dt, false )
            end
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
function JigglingParts.prerequisitesPresent(specializations)
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
function JigglingParts.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , JigglingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , JigglingParts )
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
function JigglingParts.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadJigglingPartsFromXML" , JigglingParts.loadJigglingPartsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "isJigglingPartActive" , JigglingParts.isJigglingPartActive)
    SpecializationUtil.registerFunction(vehicleType, "updateJigglingPart" , JigglingParts.updateJigglingPart)
end

```

### updateJigglingPart

**Description**

**Definition**

> updateJigglingPart()

**Arguments**

| any | jigglingPart  |
|-----|---------------|
| any | dt            |
| any | groundContact |

**Code**

```lua
function JigglingParts:updateJigglingPart(jigglingPart, dt, groundContact)
    local oldX, oldY, oldZ, oldW = jigglingPart.values[ 1 ], jigglingPart.values[ 2 ], jigglingPart.values[ 3 ], jigglingPart.values[ 4 ]
    local x, y, z, w = getShaderParameter(jigglingPart.node, jigglingPart.shaderParameter)
    jigglingPart.values[ 1 ], jigglingPart.values[ 2 ], jigglingPart.values[ 3 ], jigglingPart.values[ 4 ] = x, y, z, w

    -- update speed
    local t = dt / 1000 * jigglingPart.speedScale * self:getLastSpeed() / 20
    jigglingPart.currentTime = jigglingPart.currentTime + t
    jigglingPart.values[jigglingPart.shaderParameterComponentSpeed] = jigglingPart.currentTime

    --update amplitude
    if groundContact and jigglingPart.currentAmplitudeScale < 1 then
        jigglingPart.currentAmplitudeScale = math.min(jigglingPart.currentAmplitudeScale + dt / 100 , 1 )
    elseif not groundContact and jigglingPart.currentAmplitudeScale > 0 then
            jigglingPart.currentAmplitudeScale = math.max(jigglingPart.currentAmplitudeScale - dt / 100 , 0 )
        end
        jigglingPart.values[jigglingPart.shaderParameterComponentAmplitude] = jigglingPart.currentAmplitudeScale * jigglingPart.amplitudeScale

        setShaderParameter(jigglingPart.node, jigglingPart.shaderParameter, jigglingPart.values[ 1 ], jigglingPart.values[ 2 ], jigglingPart.values[ 3 ], jigglingPart.values[ 4 ], false )
        setShaderParameter(jigglingPart.node, jigglingPart.shaderParameterPrev, oldX, oldY, oldZ, oldW, false )
    end

```