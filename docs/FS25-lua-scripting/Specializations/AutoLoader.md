## AutoLoader

**Description**

> Specialization for automatically load objects onto a vehicle

**Functions**

- [actionControllerEvent](#actioncontrollerevent)
- [addToPhysics](#addtophysics)
- [autoLoaderOverlapCallback](#autoloaderoverlapcallback)
- [autoLoaderPickupTriggerCallback](#autoloaderpickuptriggercallback)
- [getDynamicMountTimeToMount](#getdynamicmounttimetomount)
- [getIsAutoLoadingAllowed](#getisautoloadingallowed)
- [getIsValidAutoLoaderObject](#getisvalidautoloaderobject)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onDeletePendingObject](#ondeletependingobject)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeFromPhysics](#removefromphysics)
- [saveToXMLFile](#savetoxmlfile)

### actionControllerEvent

**Description**

**Definition**

> actionControllerEvent()

**Arguments**

| any | self      |
|-----|-----------|
| any | direction |

**Code**

```lua
function AutoLoader.actionControllerEvent( self , direction)
    local spec = self.spec_autoLoader
    if direction < 0 then
        spec.isAutoLoadingActive = false
    else
            spec.isAutoLoadingActive = true
        end

        return true
    end

```

### addToPhysics

**Description**

**Definition**

> addToPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AutoLoader:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self.isServer then
        local spec = self.spec_autoLoader
        for object, _ in pairs(spec.mountedObjects) do
            if object.addToPhysics ~ = nil then
                object:addToPhysics()
            end
        end
    end

    return true
end

```

### autoLoaderOverlapCallback

**Description**

**Definition**

> autoLoaderOverlapCallback()

**Arguments**

| any | transformId |
|-----|-------------|

**Code**

```lua
function AutoLoader:autoLoaderOverlapCallback(transformId)
    if transformId ~ = 0 and getHasClassId(transformId, ClassIds.SHAPE) and not getHasTrigger(transformId) then
        local object = g_currentMission:getNodeObject(transformId)
        local spec = self.spec_autoLoader
        if object ~ = self and spec.mountedObjects[object] = = nil and spec.currentPendingObject ~ = object then

            spec.isAreaBlocked = true
            return false
        end
    end

    return true
end

```

### autoLoaderPickupTriggerCallback

**Description**

**Definition**

> autoLoaderPickupTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function AutoLoader:autoLoaderPickupTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_autoLoader
    if onEnter then
        local object = g_currentMission:getNodeObject(otherActorId)
        -- this happens if a compound child of a deleted compound is entering
            if otherActorId ~ = 0 and self:getIsAutoLoadingAllowed() and(object = = nil or spec.mountedObjects[object] = = nil ) then
                local shouldBeSkipped = spec.skippedObjects[object] ~ = nil and spec.alwaysActiveTriggers[triggerId] = = true
                if self:getIsValidAutoLoaderObject(object) and spec.pendingObjects[object] ~ = triggerId and not shouldBeSkipped then
                    spec.pendingObjects[object] = triggerId
                    object:addDeleteListener( self , AutoLoader.onDeletePendingObject)

                    spec.needGridUpdate = true
                    self:raiseActive()
                end
            end
        elseif onLeave then
                local object = g_currentMission:getNodeObject(otherActorId)
                if object ~ = nil and spec.pendingObjects[object] ~ = nil then
                    spec.pendingObjects[object] = nil
                    object:removeDeleteListener( self , AutoLoader.onDeletePendingObject)
                end
            end
        end

```

### getDynamicMountTimeToMount

**Description**

**Definition**

> getDynamicMountTimeToMount()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AutoLoader:getDynamicMountTimeToMount(superFunc)
    return self:getIsAutoLoadingAllowed() and - 1 or math.huge
end

```

### getIsAutoLoadingAllowed

**Description**

**Definition**

> getIsAutoLoadingAllowed()

**Code**

```lua
function AutoLoader:getIsAutoLoadingAllowed()
    -- check if the vehicle has not fallen to side
        local _, y1, _ = getWorldTranslation( self.components[ 1 ].node)
        local _, y2, _ = localToWorld( self.components[ 1 ].node, 0 , 1 , 0 )
        if y2 - y1 < 0.5 then
            return false
        end

        return true
    end

```

### getIsValidAutoLoaderObject

**Description**

**Definition**

> getIsValidAutoLoaderObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function AutoLoader:getIsValidAutoLoaderObject(object)
    if object = = nil then
        return false
    end

    if object = = self then
        return false
    end

    local spec = self.spec_autoLoader
    if spec.mountedObjects[object] ~ = nil then
        return false
    end

    if not object:isa( Vehicle ) and not object:isa( Bale ) then
        return false
    end

    if object.getAutoLoadIsSupported = = nil or not object:getAutoLoadIsSupported() then
        return false
    end

    if not g_currentMission.accessHandler:canFarmAccess( self:getActiveFarm(), object) then
        return false
    end

    return true
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AutoLoader.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AutoLoader" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.autoLoader.areas.area(?)#node" , "Area root node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.autoLoader.areas.area(?).trigger(?)#node" , "Trigger node" )
    schema:register(XMLValueType.BOOL, "vehicle.autoLoader.areas.area(?).trigger(?)#alwaysActive" , "Sets a trigger always active" )
    schema:register(XMLValueType.FLOAT, "vehicle.autoLoader.areas.area(?)#length" , "Area length" )
    schema:register(XMLValueType.FLOAT, "vehicle.autoLoader.areas.area(?)#width" , "Area width" )
    schema:register(XMLValueType.FLOAT, "vehicle.autoLoader.areas.area(?)#height" , "Area height(only used for collision checks)" )
        schema:register(XMLValueType.FLOAT, "vehicle.autoLoader.areas.area(?)#spacing" , "Area spacing" )

        schema:setXMLSpecializationType()

        local schemaSavegame = Vehicle.xmlSchemaSavegame
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#mountPosX" , "Mount position x" )
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#mountPosZ" , "Mount position z" )
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#mountSizeX" , "Mount size x" )
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#mountSizeZ" , "Mount size z" )
        schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#mountAreaIndex" , "Mount area index" )
        schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).autoLoader.mountedObject(?)#vehicleUniqueId" , "Vehicle unique id" )
        Bale.registerSavegameXMLPaths(schemaSavegame, "vehicles.vehicle(?).autoLoader.mountedObject(?).bale" )
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function AutoLoader:onDelete()
    local spec = self.spec_autoLoader

    if self.isServer then
        for pendingObject, _ in pairs(spec.pendingObjects) do
            pendingObject:removeDeleteListener( self , AutoLoader.onDeletePendingObject)
        end

        for object, _ in pairs(spec.mountedObjects) do
            object:unmountKinematic()
        end

        if spec.areas ~ = nil then
            for _, area in ipairs(spec.areas) do
                area.grid:delete()
            end
        end

        if spec.triggerToAreas ~ = nil then
            for triggerNode, _ in pairs(spec.triggerToAreas) do
                removeTrigger(triggerNode)
            end
        end
    end

    spec.skippedObjects = nil
    spec.pendingObjects = nil
    spec.mountedObjects = nil
end

```

### onDeletePendingObject

**Description**

**Definition**

> onDeletePendingObject()

**Arguments**

| any | self   |
|-----|--------|
| any | object |

**Code**

```lua
function AutoLoader.onDeletePendingObject( self , object)
    local spec = self.spec_autoLoader
    spec.pendingObjects[object] = nil
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function AutoLoader:onDraw()
    local spec = self.spec_autoLoader
    if spec.areas ~ = nil then
        for _, area in ipairs(spec.areas) do
            area.grid:drawDebug()
        end
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
function AutoLoader:onLoad(savegame)
    local spec = self.spec_autoLoader
    if self.isServer then

        spec.collsionMask = CollisionFlag.VEHICLE + CollisionFlag.DYNAMIC_OBJECT

        spec.pendingObjects = { }
        spec.mountedObjects = { }
        spec.triggerToAreas = { }
        spec.alwaysActiveTriggers = { }
        spec.skippedObjects = { }

        self.xmlFile:iterate( "vehicle.autoLoader.areas.area" , function (_, areaKey)
            local node = self.xmlFile:getValue(areaKey .. "#node" , nil , self.components, self.i3dMappings)
            local length = self.xmlFile:getValue(areaKey .. "#length" , 6.0 )
            local width = self.xmlFile:getValue(areaKey .. "#width" , 2.5 )
            local height = self.xmlFile:getValue(areaKey .. "#height" , 4 )
            local spacing = self.xmlFile:getValue(areaKey .. "#spacing" , 0.1 )

            if node ~ = nil then
                if spec.areas = = nil then
                    spec.areas = { }
                end

                local area = { }
                area.node = node
                area.index = #spec.areas + 1
                area.width = width
                area.length = length
                area.height = height
                area.spacing = spacing
                area.grid = PlacementGrid2D.new(node, width, length, spacing, PlacementGrid2D.MODE_SIDES)

                self.xmlFile:iterate(areaKey .. ".trigger" , function (_, triggerKey)
                    local triggerNode = self.xmlFile:getValue(triggerKey .. "#node" , nil , self.components, self.i3dMappings)
                    if spec.triggerToAreas[triggerNode] = = nil then
                        addTrigger(triggerNode, "autoLoaderPickupTriggerCallback" , self )
                        spec.triggerToAreas[triggerNode] = { }
                    end

                    local alwaysActive = self.xmlFile:getValue(triggerKey .. "#alwaysActive" )
                    if alwaysActive then
                        spec.alwaysActiveTriggers[triggerNode] = true
                    end

                    table.insert(spec.triggerToAreas[triggerNode], area)
                end )

                table.insert(spec.areas, area)
            end
        end )
    end

    spec.isAutoLoadingActive = false
    spec.warningNoSpace = g_i18n:getText( "autoLoader_warningNoSpace" )
    spec.warningTooLarge = g_i18n:getText( "autoLoader_warningTooLarge" )
end

```

### onRootVehicleChanged

**Description**

> Called if root vehicle changes

**Definition**

> onRootVehicleChanged(table rootVehicle)

**Arguments**

| table | rootVehicle | root vehicle |
|-------|-------------|--------------|

**Code**

```lua
function AutoLoader:onRootVehicleChanged(rootVehicle)
    local spec = self.spec_autoLoader
    local actionController = rootVehicle.actionController
    if actionController ~ = nil then
        if spec.controlledAction ~ = nil then
            spec.controlledAction:updateParent(actionController)
            return
        end

        spec.controlledAction = actionController:registerAction( "autoLoaderLoad" , nil , 4 )
        spec.controlledAction:setCallback( self , AutoLoader.actionControllerEvent)
        spec.controlledAction:setIsAvailableFunction( function ()
            return next( self.spec_autoLoader.pendingObjects) ~ = nil
        end )
        spec.controlledAction:setActionIcons( "AUTO_LOAD" , "AUTO_LOAD" , false )
    else
            if spec.controlledAction ~ = nil then
                spec.controlledAction:remove()
                spec.controlledAction = nil
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
function AutoLoader:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_autoLoader
    if self.isServer and spec.areas ~ = nil then
        for object, t in pairs(spec.skippedObjects) do
            t = t - dt
            spec.skippedObjects[object] = t > 0 and t or nil
        end

        if spec.pendingVehicles ~ = nil then
            for _, data in ipairs(spec.pendingVehicles) do
                local vehicleUniqueId = data.vehicleUniqueId
                local vehicle = g_currentMission.vehicleSystem:getVehicleByUniqueId(vehicleUniqueId)
                if vehicle ~ = nil then
                    local area = data.area
                    local posX = data.posX
                    local posZ = data.posZ
                    local sizeX = data.sizeX
                    local sizeZ = data.sizeZ

                    local success = vehicle:autoLoad( self , area.node, posX, posZ, sizeX, sizeZ)
                    if success then
                        spec.mountedObjects[vehicle] = { posX, posZ, sizeX, sizeZ, area.index }
                        spec.pendingObjects[vehicle] = nil
                        vehicle:removeDeleteListener( self , AutoLoader.onDeletePendingObject)
                        area.grid:blockAreaLocal(posX, posZ, sizeX, sizeZ)
                    end
                end
            end
            spec.pendingVehicles = nil
        end

        if spec.needGridUpdate then
            spec.needGridUpdate = false

            for _, area in ipairs(spec.areas) do
                area.grid:reset()
                for object, _ in pairs(spec.mountedObjects) do
                    local x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, extendY, extendZ = object:getAutoLoadBoundingBox()
                    area.grid:blockAreaByBoundingBox(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, extendX, extendY, extendZ)
                end
            end
        end

        local showTooLargeWarning = false
        local showNoSpaceWarning = false

        for pendingObject, triggerId in pairs(spec.pendingObjects) do
            if not pendingObject.isDeleted then
                if spec.isAutoLoadingActive or spec.alwaysActiveTriggers[triggerId] = = true then
                    if pendingObject:getAutoLoadIsAllowed() then
                        local sizeX, sizeY, sizeZ = pendingObject:getAutoLoadSize()
                        local areas = spec.triggerToAreas[triggerId]
                        for _, area in ipairs(areas) do
                            if sizeX < = area.width and sizeY < = area.height and sizeZ < = area.length then
                                local foundSpace = false
                                for try = 1 , 3 do
                                    local posX, posZ = area.grid:getFreePosition(sizeX, sizeZ)

                                    if posX ~ = nil then
                                        local x, y, z = localToWorld(area.node, posX + sizeX * 0.5 , sizeY * 0.5 , posZ + sizeZ * 0.5 )
                                        local rx, ry, rz = getWorldRotation(area.node)
                                        spec.isAreaBlocked = false
                                        spec.currentPendingObject = pendingObject
                                        overlapBox(x, y, z, rx, ry, rz, sizeX * 0.5 , sizeY * 0.5 , sizeZ * 0.5 , "autoLoaderOverlapCallback" , self , spec.collsionMask, true , true , false , true )
                                        spec.currentPendingObject = nil
                                        if not spec.isAreaBlocked then
                                            local success = pendingObject:autoLoad( self , area.node, posX, posZ, sizeX, sizeZ)
                                            if success then
                                                spec.mountedObjects[pendingObject] = { posX, posZ, sizeX, sizeZ, area.index }
                                                spec.pendingObjects[pendingObject] = nil
                                                pendingObject:removeDeleteListener( self , AutoLoader.onDeletePendingObject)
                                                area.grid:blockAreaLocal(posX, posZ, sizeX, sizeZ)
                                                foundSpace = true

                                                -- reset warnings as we were able to load one item
                                                showNoSpaceWarning = false
                                                showTooLargeWarning = false

                                                -- we found an area and mounted the object so we can break here
                                                break
                                            end
                                        else
                                                area.grid:blockAreaLocal(posX, posZ, sizeX, sizeZ)
                                            end
                                        else
                                                showNoSpaceWarning = true
                                            end
                                        end

                                        if foundSpace then
                                            break
                                        end
                                    else
                                            showTooLargeWarning = true
                                        end
                                    end
                                end
                            end

                            if showNoSpaceWarning and spec.warningNoSpace ~ = nil then
                                g_currentMission:showBlinkingWarning(spec.warningNoSpace, 2000 )
                            elseif showTooLargeWarning and spec.warningTooLarge ~ = nil then
                                    g_currentMission:showBlinkingWarning(spec.warningTooLarge, 2000 )
                                end
                            else
                                    spec.pendingObjects[pendingObject] = true
                                end
                            end

                            if Platform.gameplay.automaticVehicleControl then
                                if spec.isAutoLoadingActive then
                                    self.rootVehicle:playControlledActions()
                                end
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
function AutoLoader.prerequisitesPresent(specializations)
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
function AutoLoader.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AutoLoader )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AutoLoader )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , AutoLoader )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AutoLoader )
    SpecializationUtil.registerEventListener(vehicleType, "onRootVehicleChanged" , AutoLoader )
    --#debug SpecializationUtil.registerEventListener(vehicleType, "onDraw", AutoLoader)
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
function AutoLoader.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "autoLoaderPickupTriggerCallback" , AutoLoader.autoLoaderPickupTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "autoLoaderOverlapCallback" , AutoLoader.autoLoaderOverlapCallback)
    SpecializationUtil.registerFunction(vehicleType, "getIsValidAutoLoaderObject" , AutoLoader.getIsValidAutoLoaderObject)
    SpecializationUtil.registerFunction(vehicleType, "getIsAutoLoadingAllowed" , AutoLoader.getIsAutoLoadingAllowed)
    SpecializationUtil.registerFunction(vehicleType, "onUnmountObject" , AutoLoader.onUnmountObject)
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
function AutoLoader.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDynamicMountTimeToMount" , AutoLoader.getDynamicMountTimeToMount)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , AutoLoader.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , AutoLoader.removeFromPhysics)
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
function AutoLoader:removeFromPhysics(superFunc)
    local ret = superFunc( self )

    if self.isServer then
        local spec = self.spec_autoLoader
        for object, _ in pairs(spec.mountedObjects) do
            if object.removeFromPhysics ~ = nil then
                object:removeFromPhysics()
            end
        end
    end

    return ret
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
function AutoLoader:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_autoLoader

    local i = 0
    for object, mountData in pairs(spec.mountedObjects) do
        local mountKey = string.format( "%s.mountedObject(%d)" , key, i)

        xmlFile:setValue(mountKey .. "#mountPosX" , mountData[ 1 ])
        xmlFile:setValue(mountKey .. "#mountPosZ" , mountData[ 2 ])
        xmlFile:setValue(mountKey .. "#mountSizeX" , mountData[ 3 ])
        xmlFile:setValue(mountKey .. "#mountSizeZ" , mountData[ 4 ])
        xmlFile:setValue(mountKey .. "#mountAreaIndex" , mountData[ 5 ])

        if object:isa( Vehicle ) then
            xmlFile:setValue(mountKey .. "#vehicleUniqueId" , object:getUniqueId())
        elseif object:isa( Bale ) then
                object:saveToXMLFile(xmlFile, mountKey .. ".bale" )
            end

            i = i + 1
        end
    end

```