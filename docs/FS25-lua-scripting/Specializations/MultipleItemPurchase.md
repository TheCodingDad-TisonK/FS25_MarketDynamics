## MultipleItemPurchase

**Description**

> Class for a root vehicle that loads bales or vehicles and is removed afterwards

**Functions**

- [addToPhysics](#addtophysics)
- [getFillUnitCapacity](#getfillunitcapacity)
- [getTotalMass](#gettotalmass)
- [initSpecialization](#initspecialization)
- [loadItemAtPosition](#loaditematposition)
- [onDelete](#ondelete)
- [onFinishLoadingVehicle](#onfinishloadingvehicle)
- [onLoad](#onload)
- [onPreLoadFinished](#onpreloadfinished)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeFromPhysics](#removefromphysics)
- [setVisibility](#setvisibility)

### addToPhysics

**Description**

**Definition**

> addToPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function MultipleItemPurchase:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    local spec = self.spec_multipleItemPurchase
    for _, bale in ipairs(spec.loadedBales) do
        bale:addToPhysics()
    end
    for _, vehicle in ipairs(spec.loadedVehicles) do
        vehicle:addToPhysics()
    end

    return true
end

```

### getFillUnitCapacity

**Description**

**Definition**

> getFillUnitCapacity()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function MultipleItemPurchase:getFillUnitCapacity(superFunc, fillUnitIndex)
    if self.propertyState = = VehiclePropertyState.SHOP_CONFIG then
        local fillLevel = 0
        local spec = self.spec_multipleItemPurchase
        for _, bale in ipairs(spec.loadedBales) do
            fillLevel = fillLevel + bale:getFillLevel()
        end

        for _, vehicle in ipairs(spec.loadedVehicles) do
            if vehicle.getFillUnitCapacity ~ = nil then
                fillLevel = fillLevel + vehicle:getFillUnitCapacity( 1 )
            end
        end

        return fillLevel
    end

    return 0
end

```

### getTotalMass

**Description**

**Definition**

> getTotalMass()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | onlyGivenVehicle |

**Code**

```lua
function MultipleItemPurchase:getTotalMass(superFunc, onlyGivenVehicle)
    if self.propertyState = = VehiclePropertyState.SHOP_CONFIG then
        local mass = 0
        local spec = self.spec_multipleItemPurchase
        for _, bale in ipairs(spec.loadedBales) do
            mass = mass + bale:getMass()
        end

        for _, vehicle in ipairs(spec.loadedVehicles) do
            mass = mass + vehicle:getTotalMass()
        end

        return mass
    end

    return 0
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function MultipleItemPurchase.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "multipleItemPurchaseAmount" , g_i18n:getText( "configuration_buyableBaleAmount" ), nil , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "MultipleItemPurchase" )

    schema:register(XMLValueType.STRING, "vehicle.multipleItemPurchase#filename" , "Item filename" )
    schema:register(XMLValueType.BOOL, "vehicle.multipleItemPurchase#isVehicle" , "Is Loading a vehicle(false = Bale)" , false )
    schema:register(XMLValueType.STRING, "vehicle.multipleItemPurchase#fillType" , "Bale fill type" , "STRAW" )
    schema:register(XMLValueType.BOOL, "vehicle.multipleItemPurchase#baleIsWrapped" , "Bale is wrapped" , false )
    schema:register(XMLValueType.STRING, "vehicle.multipleItemPurchase#baleVariationId" , "Bale variation identifier" , "DEFAULT" )

    schema:register(XMLValueType.VECTOR_TRANS, "vehicle.multipleItemPurchase.offsets.offset(?)#offset" , "Offset" )
    schema:register(XMLValueType.FLOAT, "vehicle.multipleItemPurchase.offsets.offset(?)#amount" , "Amount of items to activate offset" )

    schema:register(XMLValueType.VECTOR_TRANS, "vehicle.multipleItemPurchase.itemPositions.itemPosition(?)#position" , "Bale position" )
    schema:register(XMLValueType.VECTOR_ROT, "vehicle.multipleItemPurchase.itemPositions.itemPosition(?)#rotation" , "Bale rotation" )

    schema:setXMLSpecializationType()
end

```

### loadItemAtPosition

**Description**

**Definition**

> loadItemAtPosition()

**Arguments**

| any | position |
|-----|----------|

**Code**

```lua
function MultipleItemPurchase:loadItemAtPosition(position)
    local spec = self.spec_multipleItemPurchase

    if self.isServer or self.propertyState = = VehiclePropertyState.SHOP_CONFIG then
        local x, y, z = localToWorld( self.components[ 1 ].node, unpack(position.position))
        local rx, ry, rz = localRotationToWorld( self.components[ 1 ].node, unpack(position.rotation))

        if not spec.isVehicle then
            local baleObject = Bale.new( self.isServer, self.isClient)
            if baleObject:loadFromConfigXML(spec.itemFilename, x, y, z, rx, ry, rz) then
                baleObject:setFillType(spec.baleFillTypeIndex, true )
                baleObject:setOwnerFarmId( self:getActiveFarm(), true )
                baleObject:setVariationId(spec.baleVariationId)
                if self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG then
                    baleObject:register()
                end

                if spec.baleIsWrapped then
                    baleObject:setWrappingState( 1 )

                    if self.configurations[ "baseColor" ] ~ = nil then
                        local color = ConfigurationUtil.getColorByConfigId( self , "baseColor" , self.configurations[ "baseColor" ])
                        baleObject:setColor( unpack(color))
                    end
                end

                baleObject:removeFromPhysics()

                table.insert(spec.loadedBales, baleObject)
            else
                    Logging.error( "Failed to load multi purchase item '%s'" , spec.itemFilename)
                end
            else
                    local loadingTask = self:createLoadingTask( self )

                    local data = VehicleLoadingData.new()
                    data:setFilename(spec.itemFilename)
                    data:setPosition(x, y, z)
                    data:setRotation(rx, ry, rz)
                    data:setPropertyState( self.propertyState)
                    data:setIsRegistered( self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG)
                    data:setForceServer( self.propertyState = = VehiclePropertyState.SHOP_CONFIG)
                    data:setOwnerFarmId( self:getActiveFarm())

                    local configurations = { }
                    local storeItem = g_storeManager:getItemByXMLFilename(spec.itemFilename)
                    if storeItem ~ = nil and storeItem.configurations ~ = nil then
                        for configName, configItems in pairs(storeItem.configurations) do
                            if self.configurations[configName] ~ = nil then
                                configurations[configName] = self.configurations[configName]
                            end
                        end
                    end

                    data:setConfigurations(configurations)

                    data:load( self.onFinishLoadingVehicle, self , loadingTask)
                end
            end
        end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function MultipleItemPurchase:onDelete()
    if self.propertyState = = VehiclePropertyState.SHOP_CONFIG or g_iconGenerator ~ = nil or g_currentMission.vehicleSystem.debugVehiclesToBeLoaded ~ = nil then
        local spec = self.spec_multipleItemPurchase
        if spec.loadedBales ~ = nil then
            for _, bale in ipairs(spec.loadedBales) do
                bale:delete()
            end
            spec.loadedBales = { }

            for _, vehicle in ipairs(spec.loadedVehicles) do
                vehicle:delete()
            end
            spec.loadedVehicles = { }
        end
    end
end

```

### onFinishLoadingVehicle

**Description**

**Definition**

> onFinishLoadingVehicle()

**Arguments**

| any | vehicles         |
|-----|------------------|
| any | vehicleLoadState |
| any | loadingTask      |

**Code**

```lua
function MultipleItemPurchase:onFinishLoadingVehicle(vehicles, vehicleLoadState, loadingTask)
    if self.isDeleted or self.isDeleting then
        if vehicleLoadState = = VehicleLoadingState.OK then
            for _, vehicle in ipairs(vehicles) do
                vehicle:delete()
            end
        end

        return
    end

    local spec = self.spec_multipleItemPurchase
    if vehicleLoadState = = VehicleLoadingState.OK then
        for _, vehicle in ipairs(vehicles) do
            -- remove from physics and hide -> will be added to physics and shown when the root vehicle is added to physics
            vehicle:removeFromPhysics()
            vehicle:setVisibility( false )

            table.insert(spec.loadedVehicles, vehicle)
        end
    else
            Logging.error( "Failed to load multi purchase item '%s'" , spec.itemFilename)
        end

        if loadingTask ~ = nil then
            self:finishLoadingTask(loadingTask)
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
function MultipleItemPurchase:onLoad(savegame)
    local spec = self.spec_multipleItemPurchase

    spec.loadedBales = { }
    spec.loadedVehicles = { }

    spec.itemFilename = Utils.getFilename( self.xmlFile:getValue( "vehicle.multipleItemPurchase#filename" ), self.baseDirectory)
    spec.isVehicle = self.xmlFile:getValue( "vehicle.multipleItemPurchase#isVehicle" , false )

    local fillTypeName = self.xmlFile:getValue( "vehicle.multipleItemPurchase#fillType" , "STRAW" )
    spec.baleFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
    spec.baleIsWrapped = self.xmlFile:getValue( "vehicle.multipleItemPurchase#baleIsWrapped" , false )
    spec.baleVariationId = self.xmlFile:getValue( "vehicle.multipleItemPurchase#baleVariationId" , "DEFAULT" )

    local positionOffset = { 0 , 0 , 0 }
    local i = 0
    while true do
        local baseKey = string.format( "vehicle.multipleItemPurchase.offsets.offset(%d)" , i)
        if not self.xmlFile:hasProperty(baseKey) then
            break
        end

        local offset = self.xmlFile:getValue(baseKey .. "#offset" , nil , true )
        local amount = self.xmlFile:getValue(baseKey .. "#amount" )

        if amount < = self.configurations[ "multipleItemPurchaseAmount" ] then
            positionOffset = offset
        end

        i = i + 1
    end

    spec.positions = { }
    i = 0
    while true do
        local baseKey = string.format( "vehicle.multipleItemPurchase.itemPositions.itemPosition(%d)" , i)
        if not self.xmlFile:hasProperty(baseKey) then
            break
        end

        local position = self.xmlFile:getValue(baseKey .. "#position" , nil , true )
        local rotation = self.xmlFile:getValue(baseKey .. "#rotation" , nil , true )
        if position ~ = nil and rotation ~ = nil then
            if positionOffset ~ = nil then
                for j = 1 , 3 do
                    position[j] = position[j] + positionOffset[j]
                end
            end

            table.insert(spec.positions, { position = position, rotation = rotation } )
        end

        i = i + 1
    end

    -- remove collision with vehicle and camera blocking, so the loaded bales or objects wont collide with ourself
    for _, component in ipairs( self.components) do
        setCollisionFilterMask(component.node, bit32.bxor(getCollisionFilterMask(component.node), CollisionFlag.VEHICLE + CollisionFlag.DYNAMIC_OBJECT))
    end

    if not self.isServer then
        SpecializationUtil.removeEventListener( self , "onUpdate" , MultipleItemPurchase )
    end
end

```

### onPreLoadFinished

**Description**

> Called after loading

**Definition**

> onPreLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function MultipleItemPurchase:onPreLoadFinished(savegame)
    local spec = self.spec_multipleItemPurchase
    for j, position in ipairs(spec.positions) do
        if j < = self.configurations[ "multipleItemPurchaseAmount" ] then
            self:loadItemAtPosition(position)
        end
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
function MultipleItemPurchase:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG then
        self:delete()
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
function MultipleItemPurchase.prerequisitesPresent(specializations)
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
function MultipleItemPurchase.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , MultipleItemPurchase )
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoadFinished" , MultipleItemPurchase )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , MultipleItemPurchase )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , MultipleItemPurchase )
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
function MultipleItemPurchase.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadItemAtPosition" , MultipleItemPurchase.loadItemAtPosition)
    SpecializationUtil.registerFunction(vehicleType, "onFinishLoadingVehicle" , MultipleItemPurchase.onFinishLoadingVehicle)
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
function MultipleItemPurchase.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTotalMass" , MultipleItemPurchase.getTotalMass)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitCapacity" , MultipleItemPurchase.getFillUnitCapacity)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setVisibility" , MultipleItemPurchase.setVisibility)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , MultipleItemPurchase.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , MultipleItemPurchase.removeFromPhysics)
end

```

### removeFromPhysics

**Description**

**Definition**

> removeFromPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function MultipleItemPurchase:removeFromPhysics(superFunc)
    local spec = self.spec_multipleItemPurchase
    for _, bale in ipairs(spec.loadedBales) do
        bale:removeFromPhysics()
    end
    for _, vehicle in ipairs(spec.loadedVehicles) do
        vehicle:removeFromPhysics()
    end

    return superFunc( self )
end

```

### setVisibility

**Description**

**Definition**

> setVisibility()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | state     |

**Code**

```lua
function MultipleItemPurchase:setVisibility(superFunc, state)
    local spec = self.spec_multipleItemPurchase
    for _, vehicle in ipairs(spec.loadedVehicles) do
        vehicle:setVisibility(state)
    end

    superFunc( self , state)
end

```