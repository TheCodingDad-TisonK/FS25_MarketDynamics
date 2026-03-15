## PlaceableVehicle

**Description**

> Specialization for vehicles that can be bought via the placeable menu

**Functions**

- [collectPickObjects](#collectpickobjects)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onFinishLoadingVehicle](#onfinishloadingvehicle)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [register](#register)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableVehicle:collectPickObjects(superFunc, node)
    local spec = self.spec_vehicle

    if spec.vehicles ~ = nil then
        for _, vehicleData in ipairs(spec.vehicles) do
            if node = = vehicleData.linkNode then
                return
            end
        end
    end

    superFunc( self , node)
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableVehicle:onDelete()
    local spec = self.spec_vehicle

    if spec.loadedVehicles ~ = nil then
        for _, vehicle in ipairs(spec.loadedVehicles) do
            vehicle:delete( true )
        end
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableVehicle:onFinalizePlacement()
    if self.isServer and g_iconGenerator = = nil then
        local spec = self.spec_vehicle
        if spec.loadedVehicles ~ = nil then
            for _, vehicle in ipairs(spec.loadedVehicles) do
                for _, component in ipairs(vehicle.components) do
                    local x, y, z = getWorldTranslation(component.node)
                    local rx, ry, rz = getWorldRotation(component.node)
                    link(getRootNode(), component.node)
                    setWorldTranslation(component.node, x, y, z)
                    setWorldRotation(component.node, rx, ry, rz)
                end

                vehicle:addToPhysics()
                vehicle:register()
            end

            spec.loadedVehicles = nil
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
| any | vehicleData      |

**Code**

```lua
function PlaceableVehicle:onFinishLoadingVehicle(vehicles, vehicleLoadState, vehicleData)
    if self:getIsBeingDeleted() then
        if vehicleLoadState = = VehicleLoadingState.OK then
            for _, vehicle in ipairs(vehicles) do
                vehicle:delete()
            end
        end
    else
            local spec = self.spec_vehicle
            if vehicleLoadState = = VehicleLoadingState.OK then
                for _, vehicle in ipairs(vehicles) do
                    vehicle:removeFromPhysics()
                    vehicle:setOwnerFarmId( self.ownerFarmId)

                    for _, component in ipairs(vehicle.components) do
                        local x, y, z = getWorldTranslation(component.node)
                        local rx, ry, rz = getWorldRotation(component.node)
                        link(vehicleData.linkNode, component.node)
                        setWorldTranslation(component.node, x, y, z)
                        setWorldRotation(component.node, rx, ry, rz)
                    end

                    table.insert(spec.loadedVehicles, vehicle)
                end
            else
                    Logging.error( "Failed to load placeable vehicle '%s'" , vehicleData.filename)
                end
            end

            if vehicleData.loadingTask ~ = nil then
                self:finishLoadingTask(vehicleData.loadingTask)
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
function PlaceableVehicle:onLoad(savegame)
    local spec = self.spec_vehicle

    -- only load on server and placing client
    if self.isServer or self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
        spec.vehicles = { }
        spec.loadedVehicles = { }

        for _, vehicleKey in self.xmlFile:iterator( "placeable.placeableVehicle.vehicle" ) do
            local vehicleData = { }
            vehicleData.filename = self.xmlFile:getValue(vehicleKey .. "#xmlFilename" , nil , self.baseDirectory)
            vehicleData.linkNode = self.xmlFile:getValue(vehicleKey .. "#linkNode" , nil , self.components, self.i3dMappings)
            if vehicleData.filename ~ = nil and vehicleData.linkNode ~ = nil then
                table.insert(spec.vehicles, vehicleData)

                local x, y, z = getWorldTranslation(vehicleData.linkNode)
                local rx, ry, rz = getWorldRotation(vehicleData.linkNode)

                vehicleData.loadingTask = self:createLoadingTask( self )

                local data = VehicleLoadingData.new()
                data:setFilename(vehicleData.filename)
                data:setPosition(x, y, z)
                data:setRotation(rx, ry, rz)
                if self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
                    data:setPropertyState(VehiclePropertyState.SHOP_CONFIG)
                else
                        data:setPropertyState(VehiclePropertyState.OWNED)
                    end
                    data:setIsRegistered( false )

                    data:load( self.onFinishLoadingVehicle, self , vehicleData)
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
function PlaceableVehicle.prerequisitesPresent(specializations)
    return true
end

```

### register

**Description**

**Definition**

> register()

**Arguments**

| any | alreadySent |
|-----|-------------|

**Code**

```lua
function PlaceableVehicle:register(alreadySent)
    -- this placeable does only spawn vehicles
    -- do not register this placeable to avoid synching to other clients

        if self.propertyState ~ = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
            self:delete()
        end
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
function PlaceableVehicle.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableVehicle )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableVehicle )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableVehicle )
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
function PlaceableVehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onFinishLoadingVehicle" , PlaceableVehicle.onFinishLoadingVehicle)
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
function PlaceableVehicle.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableVehicle.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "register" , PlaceableVehicle.register)
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
function PlaceableVehicle.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "PlaceableVehicle" )

    schema:register(XMLValueType.FILENAME, "placeable.placeableVehicle.vehicle(?)#xmlFilename" , "Path to vehicle xml file" )
    schema:register(XMLValueType.NODE_INDEX, "placeable.placeableVehicle.vehicle(?)#linkNode" , "Link node" )

    schema:setXMLSpecializationType()
end

```