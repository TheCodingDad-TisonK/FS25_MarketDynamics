## WaterTrailer

**Description**

> Specialization for water trailer allowing it to also be filled at any water plane in the world

**Functions**

- [getDrawFirstFillText](#getdrawfirstfilltext)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPreDetach](#onpredetach)
- [onReadStream](#onreadstream)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setIsWaterTrailerFilling](#setiswatertrailerfilling)

### getDrawFirstFillText

**Description**

**Definition**

> getDrawFirstFillText()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function WaterTrailer:getDrawFirstFillText(superFunc)
    local spec = self.spec_waterTrailer
    if self.isClient then
        if self:getIsActiveForInput() and self:getIsSelected() then
            if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 and self:getFillUnitCapacity(spec.fillUnitIndex) ~ = 0 then
                return true
            end
        end
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function WaterTrailer.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "WaterTrailer" )

    schema:register(XMLValueType.INT, "vehicle.waterTrailer#fillUnitIndex" , "Fill unit index" )
    schema:register(XMLValueType.FLOAT, "vehicle.waterTrailer#fillLitersPerSecond" , "Fill liters per second" , 500 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.waterTrailer#fillNode" , "Fill node" , "Root component" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.waterTrailer.sounds" , "refill" )

    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function WaterTrailer:onDelete()
    local spec = self.spec_waterTrailer
    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)

    g_soundManager:deleteSamples(spec.samples)
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
function WaterTrailer:onLoad(savegame)
    local spec = self.spec_waterTrailer

    local fillUnitIndex = self.xmlFile:getValue( "vehicle.waterTrailer#fillUnitIndex" )
    if fillUnitIndex ~ = nil then
        spec.fillUnitIndex = fillUnitIndex
        spec.fillLitersPerSecond = self.xmlFile:getValue( "vehicle.waterTrailer#fillLitersPerSecond" , 500 )
        spec.waterFillNode = self.xmlFile:getValue( "vehicle.waterTrailer#fillNode" , self.components[ 1 ].node, self.components, self.i3dMappings)
    end

    spec.isFilling = false
    spec.activatable = WaterTrailerActivatable.new( self )

    if self.isClient then
        spec.samples = { }
        spec.samples.refill = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.waterTrailer.sounds" , "refill" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    self.needWaterInfo = true
end

```

### onPreDetach

**Description**

> Called if vehicle gets detached

**Definition**

> onPreDetach(table attacherVehicle, table implement)

**Arguments**

| table | attacherVehicle | attacher vehicle |
|-------|-----------------|------------------|
| table | implement       | implement        |

**Code**

```lua
function WaterTrailer:onPreDetach(attacherVehicle, implement)
    local spec = self.spec_waterTrailer
    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function WaterTrailer:onReadStream(streamId, connection)
    local isFilling = streamReadBool(streamId)
    self:setIsWaterTrailerFilling(isFilling, true )
end

```

### onUpdateTick

**Description**

> Called on update tick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function WaterTrailer:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_waterTrailer

    local _, y, _ = getWorldTranslation(spec.waterFillNode)
    local isNearWater = (y < = self.waterY + 0.2 )

    if isNearWater then
        g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
    else
            g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
        end

        if self.isServer then
            if spec.isFilling then
                -- stop filling if not near the water anymore
                    if not isNearWater then
                        self:setIsWaterTrailerFilling( false )
                    end
                end

                if spec.isFilling then
                    if self:getFillUnitAllowsFillType(spec.fillUnitIndex, FillType.WATER) then
                        local delta = self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, spec.fillLitersPerSecond * dt * 0.001 , FillType.WATER, ToolType.TRIGGER, nil )
                        if delta < = 0 then
                            self:setIsWaterTrailerFilling( false )
                        end
                    end
                end
            end
        end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function WaterTrailer:onWriteStream(streamId, connection)
    local spec = self.spec_waterTrailer
    streamWriteBool(streamId, spec.isFilling)
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
function WaterTrailer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
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
function WaterTrailer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , WaterTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , WaterTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , WaterTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , WaterTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , WaterTrailer )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , WaterTrailer )
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
function WaterTrailer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "setIsWaterTrailerFilling" , WaterTrailer.setIsWaterTrailerFilling)
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
function WaterTrailer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDrawFirstFillText" , WaterTrailer.getDrawFirstFillText)
end

```

### setIsWaterTrailerFilling

**Description**

> Set is water trailer filling state

**Definition**

> setIsWaterTrailerFilling(boolean isFilling, boolean noEventSend)

**Arguments**

| boolean | isFilling   | new is filling state |
|---------|-------------|----------------------|
| boolean | noEventSend | no event send        |

**Code**

```lua
function WaterTrailer:setIsWaterTrailerFilling(isFilling, noEventSend)
    local spec = self.spec_waterTrailer
    if isFilling ~ = spec.isFilling then
        WaterTrailerSetIsFillingEvent.sendEvent( self , isFilling, noEventSend)

        spec.isFilling = isFilling

        if self.isClient then
            if isFilling then
                g_soundManager:playSample(spec.samples.refill)
            else
                    g_soundManager:stopSample(spec.samples.refill)
                end
            end
        end
    end

```