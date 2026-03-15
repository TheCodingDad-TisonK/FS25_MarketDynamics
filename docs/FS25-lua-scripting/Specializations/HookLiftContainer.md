## HookLiftContainer

**Description**

> Specialization for hooklift containers to be attached/loaded up on a hooklift trailer

**Functions**

- [addToPhysics](#addtophysics)
- [getBrakeForce](#getbrakeforce)
- [getCanDischargeToGround](#getcandischargetoground)
- [getCanDischargeToObject](#getcandischargetoobject)
- [initSpecialization](#initspecialization)
- [isDetachAllowed](#isdetachallowed)
- [onHookLiftContainerLockChanged](#onhookliftcontainerlockchanged)
- [onLoad](#onload)
- [onStartTipping](#onstarttipping)
- [onStopTipping](#onstoptipping)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeFromPhysics](#removefromphysics)

### addToPhysics

**Description**

**Definition**

> addToPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function HookLiftContainer:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.setHookLiftContainerPhysicsState ~ = nil then
        attacherVehicle:setHookLiftContainerPhysicsState( self , true )
    end

    return true
end

```

### getBrakeForce

**Description**

**Definition**

> getBrakeForce()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function HookLiftContainer:getBrakeForce(superFunc)
    if self:getAttacherVehicle() ~ = nil then
        return 0
    end

    return superFunc( self )
end

```

### getCanDischargeToGround

**Description**

**Definition**

> getCanDischargeToGround()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function HookLiftContainer:getCanDischargeToGround(superFunc, dischargeNode)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.getIsTippingAllowed ~ = nil then
        if not attacherVehicle:getIsTippingAllowed() then
            return false
        end
    end

    return superFunc( self , dischargeNode)
end

```

### getCanDischargeToObject

**Description**

**Definition**

> getCanDischargeToObject()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function HookLiftContainer:getCanDischargeToObject(superFunc, dischargeNode)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.getIsTippingAllowed ~ = nil then
        if not attacherVehicle:getIsTippingAllowed() then
            return false
        end
    end

    return superFunc( self , dischargeNode)
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function HookLiftContainer.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "HookLiftContainer" )

    schema:register(XMLValueType.BOOL, "vehicle.hookLiftContainer#tiltContainerOnDischarge" , "Tilt container on discharge" , true )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.hookLiftContainer.visualRollReference#startNode" , "Reference nodes that represent the bottom of the container" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.hookLiftContainer.visualRollReference#endNode" , "Reference nodes that represent the bottom of the container" )

    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, "vehicle.hookLiftContainer.containerLock" )

    schema:setXMLSpecializationType()
end

```

### isDetachAllowed

**Description**

**Definition**

> isDetachAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function HookLiftContainer:isDetachAllowed(superFunc)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.getCanDetachContainer ~ = nil then
        if not attacherVehicle:getCanDetachContainer() then
            return false , nil
        end
    end

    return superFunc( self )
end

```

### onHookLiftContainerLockChanged

**Description**

**Definition**

> onHookLiftContainerLockChanged()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function HookLiftContainer:onHookLiftContainerLockChanged(state)
    local spec = self.spec_hookLiftContainer

    if self.setConnectionHosesActive ~ = nil then
        local attacherVehicle = self:getAttacherVehicle()
        local implement = attacherVehicle:getImplementByObject( self )
        if implement ~ = nil then
            self:setConnectionHosesActive(state)
        end
    end

    ObjectChangeUtil.setObjectChanges(spec.containerLockChangeObjects, state, self , self.setMovingToolDirty)
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
function HookLiftContainer:onLoad(savegame)
    local spec = self.spec_hookLiftContainer

    spec.tiltContainerOnDischarge = self.xmlFile:getValue( "vehicle.hookLiftContainer#tiltContainerOnDischarge" , true )

    spec.visualReferenceNodeStart = self.xmlFile:getValue( "vehicle.hookLiftContainer.visualRollReference#startNode" , nil , self.components, self.i3dMappings)
    spec.visualReferenceNodeEnd = self.xmlFile:getValue( "vehicle.hookLiftContainer.visualRollReference#endNode" , nil , self.components, self.i3dMappings)

    spec.containerLockChangeObjects = { }
    ObjectChangeUtil.loadObjectChangeFromXML( self.xmlFile, "vehicle.hookLiftContainer.containerLock" , spec.containerLockChangeObjects, self.components, self )
    ObjectChangeUtil.setObjectChanges(spec.containerLockChangeObjects, false , self , self.setMovingToolDirty)

    if self.setConnectionHosesActive ~ = nil then
        self:setConnectionHosesActive( false )
    end
end

```

### onStartTipping

**Description**

**Definition**

> onStartTipping()

**Arguments**

| any | tipSideIndex |
|-----|--------------|

**Code**

```lua
function HookLiftContainer:onStartTipping(tipSideIndex)
    local spec = self.spec_hookLiftContainer
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.startTipping ~ = nil and spec.tiltContainerOnDischarge then
        attacherVehicle:startTipping()
    end
end

```

### onStopTipping

**Description**

**Definition**

> onStopTipping()

**Code**

```lua
function HookLiftContainer:onStopTipping()
    local spec = self.spec_hookLiftContainer
    local attacherVehicle = self:getAttacherVehicle()

    if attacherVehicle ~ = nil and attacherVehicle.stopTipping ~ = nil and spec.tiltContainerOnDischarge then
        attacherVehicle:stopTipping()
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
function HookLiftContainer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AnimatedVehicle , specializations) and SpecializationUtil.hasSpecialization( Attachable , specializations)
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
function HookLiftContainer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , HookLiftContainer )
    SpecializationUtil.registerEventListener(vehicleType, "onStartTipping" , HookLiftContainer )
    SpecializationUtil.registerEventListener(vehicleType, "onStopTipping" , HookLiftContainer )
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
function HookLiftContainer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onHookLiftContainerLockChanged" , HookLiftContainer.onHookLiftContainerLockChanged)
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
function HookLiftContainer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToObject" , HookLiftContainer.getCanDischargeToObject)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToGround" , HookLiftContainer.getCanDischargeToGround)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isDetachAllowed" , HookLiftContainer.isDetachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , HookLiftContainer.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , HookLiftContainer.removeFromPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getBrakeForce" , HookLiftContainer.getBrakeForce)
end

```

### removeFromPhysics

**Description**

> Add to physics

**Definition**

> removeFromPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function HookLiftContainer:removeFromPhysics(superFunc)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.setHookLiftContainerPhysicsState ~ = nil then
        attacherVehicle:setHookLiftContainerPhysicsState( self , false )
    end

    if not superFunc( self ) then
        return false
    end

    return true
end

```