## SupportVehicle

**Description**

> Specialization for spawning a support vehicle while detaching and removing it again on attach

**Functions**

- [addSupportVehicle](#addsupportvehicle)
- [enableSupportVehicle](#enablesupportvehicle)
- [getAllowMultipleAttachments](#getallowmultipleattachments)
- [getIsReadyToFinishDetachProcess](#getisreadytofinishdetachprocess)
- [getShowAttachableMapHotspot](#getshowattachablemaphotspot)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPostDetach](#onpostdetach)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeSupportVehicle](#removesupportvehicle)
- [resolveMultipleAttachments](#resolvemultipleattachments)
- [startDetachProcess](#startdetachprocess)
- [supportVehicleLoaded](#supportvehicleloaded)

### addSupportVehicle

**Description**

**Definition**

> addSupportVehicle()

**Arguments**

| any | isDetach |
|-----|----------|

**Code**

```lua
function SupportVehicle:addSupportVehicle(isDetach)
    local spec = self.spec_supportVehicle
    if spec.storeItem ~ = nil and spec.supportVehicle = = nil and not spec.isLoadingSupportVehicle and spec.loadedSupportVehicle = = nil then
        local inputAttacherJoint = self:getInputAttacherJointByJointDescIndex(spec.inputAttacherJointIndex)
        if inputAttacherJoint ~ = nil then
            local x, y, z = getWorldTranslation(inputAttacherJoint.node)
            if isDetach = = true then
                local dirX, _, dirZ = localDirectionToWorld(inputAttacherJoint.node, 1 , 0 , 0 )
                x, y, z = x + dirX * spec.spawnOffset, y, z + dirZ * spec.spawnOffset
            end

            y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z) + spec.terrainOffset

            local xRot, yRot, zRot = localRotationToWorld(inputAttacherJoint.node, - math.pi, 0 , - math.pi)

            spec.isLoadingSupportVehicle = true

            local data = VehicleLoadingData.new()
            data:setStoreItem(spec.storeItem)
            data:setPosition(x, y, z)
            data:setRotation(xRot, yRot, zRot)
            data:setPropertyState(VehiclePropertyState.NONE)
            data:setOwnerFarmId( self:getActiveFarm())
            data:setConfigurations(spec.configurations)

            data:load( SupportVehicle.supportVehicleLoaded, self , { isDetach = isDetach } )
        end
    end
end

```

### enableSupportVehicle

**Description**

**Definition**

> enableSupportVehicle()

**Code**

```lua
function SupportVehicle:enableSupportVehicle()
    local spec = self.spec_supportVehicle
    if spec.loadedSupportVehicle ~ = nil then
        local vehicle = spec.loadedSupportVehicle
        spec.loadedSupportVehicle = nil

        vehicle:setIsSupportVehicle()

        self:setReducedComponentMass( true )

        local inputAttacherJoint = self:getInputAttacherJointByJointDescIndex(spec.inputAttacherJointIndex)
        if inputAttacherJoint ~ = nil then
            local offset = inputAttacherJoint.jointOrigOffsetComponent
            local rotOffset = inputAttacherJoint.jointOrigRotOffsetComponent

            if vehicle.getAttacherJointByJointDescIndex ~ = nil then
                local attacherJoint = vehicle:getAttacherJointByJointDescIndex(spec.attacherJointIndex)
                if attacherJoint ~ = nil then
                    -- move the support vehicle by the inverted offset from the attacher joint to the root node
                    -- like this ourself is still placed with the same X offset to the attacherJoint were it was mounted before
                    local x, y, z = getWorldTranslation(vehicle.rootNode)
                    local rx, ry, rz = getWorldRotation(vehicle.rootNode)

                    local ox, oy, oz = localDirectionToWorld(vehicle.rootNode, attacherJoint.jointOrigOffsetComponent[ 1 ], 0 , attacherJoint.jointOrigOffsetComponent[ 3 ])
                    x, y, z = x - ox, y - oy, z - oz
                    y = math.max(getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z) + spec.terrainOffset, y)

                    vehicle:removeFromPhysics()
                    vehicle:setAbsolutePosition(x, y, z, rx, ry, rz)
                    vehicle:addToPhysics()

                    -- now move ourself to the exact attaching position in the support vehicle
                    x, y, z = localToWorld(attacherJoint.jointTransform, unpack(offset))
                    rx, ry, rz = localRotationToWorld(attacherJoint.jointTransform, unpack(rotOffset))

                    self:removeFromPhysics()
                    self:setAbsolutePosition(x, y, z, rx, ry, rz)
                    self:addToPhysics()

                    vehicle:attachImplement( self , spec.inputAttacherJointIndex, spec.attacherJointIndex, true , nil , nil , true )

                    self.rootVehicle:updateSelectableObjects()
                    self.rootVehicle:setSelectedVehicle( self )

                    --#debug if vehicle.spec_dynamicMountAttacher ~ = nil and vehicle.spec_dynamicMountAttacher.dynamicMountAttacherTrigger ~ = nil then
                        --#debug Logging.warning("DynamicMountAttacher is not allowed for support vehicle '%s'", vehicle.configFileName)
                            --#debug end

                            spec.supportVehicle = vehicle
                            return
                        end
                    end
                end

                vehicle:delete()
            end
        end

```

### getAllowMultipleAttachments

**Description**

> Function to allow showing the attachment dialog even if the attachable is already attached

**Definition**

> getAllowMultipleAttachments()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SupportVehicle:getAllowMultipleAttachments(superFunc)
    return self.spec_supportVehicle.filename ~ = nil
end

```

### getIsReadyToFinishDetachProcess

**Description**

**Definition**

> getIsReadyToFinishDetachProcess()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SupportVehicle:getIsReadyToFinishDetachProcess(superFunc)
    local spec = self.spec_supportVehicle
    return superFunc( self ) and( not spec.isLoadingSupportVehicle or spec.loadedSupportVehicle ~ = nil )
end

```

### getShowAttachableMapHotspot

**Description**

**Definition**

> getShowAttachableMapHotspot()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SupportVehicle:getShowAttachableMapHotspot(superFunc)
    if self.spec_supportVehicle.supportVehicle ~ = nil then
        return self.spec_supportVehicle.supportVehicle:getAttacherVehicle() = = nil
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
function SupportVehicle.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SupportVehicle" )

    schema:register(XMLValueType.STRING, "vehicle.supportVehicle#filename" , "Path to support vehicle xml" )
    schema:register(XMLValueType.INT, "vehicle.supportVehicle#attacherJointIndex" , "Attacher joint index on support vehicle" , 1 )
    schema:register(XMLValueType.INT, "vehicle.supportVehicle#inputAttacherJointIndex" , "Input attacher joint index on own vehicle" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.supportVehicle#terrainOffset" , "Spawn Offset from terrain for the support vehicle" , 0.2 )
        schema:register(XMLValueType.FLOAT, "vehicle.supportVehicle#spawnOffset" , "Tool will be moved this distance away in X direction of the attacher joint" , 0.75 )

        schema:register(XMLValueType.STRING, "vehicle.supportVehicle.configuration(?)#name" , "Configuration name" )
        schema:register(XMLValueType.INT, "vehicle.supportVehicle.configuration(?)#id" , "Configuration id" )

        schema:setXMLSpecializationType()
    end

```

### onDelete

**Description**

> Called on delete

**Definition**

> onDelete()

**Code**

```lua
function SupportVehicle:onDelete()
    if not self.isReconfigurating then
        self:removeSupportVehicle()
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
function SupportVehicle:onLoad(savegame)
    local spec = self.spec_supportVehicle

    local baseKey = "vehicle.supportVehicle"

    spec.attacherJointIndex = self.xmlFile:getValue(baseKey .. "#attacherJointIndex" , 1 )
    spec.inputAttacherJointIndex = self.xmlFile:getValue(baseKey .. "#inputAttacherJointIndex" , 1 )

    spec.terrainOffset = self.xmlFile:getValue(baseKey .. "#terrainOffset" , 0.2 )
    spec.spawnOffset = self.xmlFile:getValue(baseKey .. "#spawnOffset" , 0.75 )

    spec.heightChecks = { }

    local filename = self.xmlFile:getValue(baseKey .. "#filename" )
    if filename ~ = nil then
        spec.filename = Utils.getFilename(filename, self.customEnvironment)

        local storeItem = g_storeManager:getItemByXMLFilename(spec.filename)
        if storeItem ~ = nil then
            spec.storeItem = storeItem

            local size = StoreItemUtil.getSizeValues(storeItem.xmlFilename, "vehicle" , storeItem.rotation)
            table.insert(spec.heightChecks, { size.width / 2 + size.widthOffset, size.length / 2 + size.lengthOffset } )
            table.insert(spec.heightChecks, { - size.width / 2 + size.widthOffset, size.length / 2 + size.lengthOffset } )
            table.insert(spec.heightChecks, { size.width / 2 + size.widthOffset, - size.length / 2 + size.lengthOffset } )
            table.insert(spec.heightChecks, { - size.width / 2 + size.widthOffset, - size.length / 2 + size.lengthOffset } )
        else
                Logging.xmlWarning( self.xmlFile, "Unable to find support vehicle '%s'." , filename)
                spec.filename = nil
            end
        end

        spec.configurations = { }
        local i = 0
        while true do
            local configurationKey = string.format( "%s.configuration(%d)" , baseKey, i)
            if not self.xmlFile:hasProperty(configurationKey) then
                break
            end

            local name = self.xmlFile:getValue(configurationKey .. "#name" )
            local id = self.xmlFile:getValue(configurationKey .. "#id" )
            if name ~ = nil and id ~ = nil then
                spec.configurations[name] = id
            end

            i = i + 1
        end

        spec.firstRun = true
        spec.loadedSupportVehicle = nil
        spec.isLoadingSupportVehicle = false

        if not self.isServer or spec.storeItem = = nil then
            SpecializationUtil.removeEventListener( self , "onDelete" , SupportVehicle )
            SpecializationUtil.removeEventListener( self , "onUpdate" , SupportVehicle )
            SpecializationUtil.removeEventListener( self , "onPostDetach" , SupportVehicle )
        end
    end

```

### onPostDetach

**Description**

> Called if vehicle gets detached

**Definition**

> onPostDetach(table attacherVehicle, table implement)

**Arguments**

| table | attacherVehicle | attacher vehicle |
|-------|-----------------|------------------|
| table | implement       | implement        |

**Code**

```lua
function SupportVehicle:onPostDetach(attacherVehicle, implement)
    self:enableSupportVehicle()
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
function SupportVehicle:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_supportVehicle
    if spec.firstRun and not g_currentMission.vehicleSystem.isReloadRunning then
        if self:getAttacherVehicle() = = nil then
            self:addSupportVehicle( false )
        else
                if spec.supportVehicle = = nil then
                    local attacherVehicle = self:getAttacherVehicle()
                    if attacherVehicle.configFileName = = spec.filename then
                        spec.supportVehicle = attacherVehicle
                        spec.supportVehicle:setIsSupportVehicle()

                        self:setReducedComponentMass( true )
                    end
                end
            end

            spec.firstRun = false
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
function SupportVehicle.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AttacherJoints , specializations) and SpecializationUtil.hasSpecialization( Mountable , specializations)
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
function SupportVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SupportVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , SupportVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , SupportVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onPostDetach" , SupportVehicle )
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
function SupportVehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "addSupportVehicle" , SupportVehicle.addSupportVehicle)
    SpecializationUtil.registerFunction(vehicleType, "enableSupportVehicle" , SupportVehicle.enableSupportVehicle)
    SpecializationUtil.registerFunction(vehicleType, "removeSupportVehicle" , SupportVehicle.removeSupportVehicle)
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
function SupportVehicle.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowMultipleAttachments" , SupportVehicle.getAllowMultipleAttachments)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "resolveMultipleAttachments" , SupportVehicle.resolveMultipleAttachments)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShowAttachableMapHotspot" , SupportVehicle.getShowAttachableMapHotspot)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsReadyToFinishDetachProcess" , SupportVehicle.getIsReadyToFinishDetachProcess)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "startDetachProcess" , SupportVehicle.startDetachProcess)
end

```

### removeSupportVehicle

**Description**

**Definition**

> removeSupportVehicle()

**Code**

```lua
function SupportVehicle:removeSupportVehicle()
    local spec = self.spec_supportVehicle
    if spec.supportVehicle ~ = nil and not spec.supportVehicle.isDeleted then
        spec.supportVehicle:delete()
    end
    spec.supportVehicle = nil

    if self.isServer and self.components ~ = nil then
        self:setReducedComponentMass( false )
    end
end

```

### resolveMultipleAttachments

**Description**

> Function that is called before attaching a attachable to second vehicle

**Definition**

> resolveMultipleAttachments()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SupportVehicle:resolveMultipleAttachments(superFunc)
    if self.isServer then
        self:removeSupportVehicle()
    end

    superFunc( self )
end

```

### startDetachProcess

**Description**

**Definition**

> startDetachProcess()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function SupportVehicle:startDetachProcess(superFunc, noEventSend)
    if not self.isDeleting then
        self:addSupportVehicle( true )
    end

    return superFunc( self , noEventSend)
end

```

### supportVehicleLoaded

**Description**

> Called after the additional attachment was loaded

**Definition**

> supportVehicleLoaded()

**Arguments**

| any | vehicles               |
|-----|------------------------|
| any | vehicleLoadState       |
| any | asyncCallbackArguments |

**Code**

```lua
function SupportVehicle:supportVehicleLoaded(vehicles, vehicleLoadState, asyncCallbackArguments)
    local spec = self.spec_supportVehicle

    if vehicleLoadState = = VehicleLoadingState.OK and #vehicles > 0 then
        if not self.isDeleted then
            spec.loadedSupportVehicle = vehicles[ 1 ]

            if asyncCallbackArguments.isDetach ~ = true then
                self:enableSupportVehicle()
            end
        else
                -- if the parent vehicle was deleted while loading the support vehicle we remove also the support vehicle
                    for _, vehicle in ipairs(vehicles) do
                        vehicle:delete()
                    end
                end
            end

            spec.isLoadingSupportVehicle = false
        end

```