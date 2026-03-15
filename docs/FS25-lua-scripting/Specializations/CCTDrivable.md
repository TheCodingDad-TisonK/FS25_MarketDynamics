## CCTDrivable

**Description**

> Specialization class for CCTDrivables

**XML Configuration Parameters**

| vehicle.cctDrivable#cctRadius | radius of the CCT |
|-------------------------------|-------------------|
| vehicle.cctDrivable#cctHeight | height of the CCT |

**Functions**

- [getCCTCollisionMask](#getcctcollisionmask)
- [getCCTWorldTranslation](#getcctworldtranslation)
- [getIsCCTOnGround](#getiscctonground)
- [initSpecialization](#initspecialization)
- [moveCCT](#movecct)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setWorldPosition](#setworldposition)
- [setWorldPositionQuaternion](#setworldpositionquaternion)

### getCCTCollisionMask

**Description**

**Definition**

> getCCTCollisionMask()

**Return Values**

| any | returns | the collision mask |
|-----|---------|--------------------|

**Code**

```lua
function CCTDrivable:getCCTCollisionMask()
    local spec = self.spec_cctdrivable
    return spec.kinematicCollisionMask
end

```

### getCCTWorldTranslation

**Description**

**Definition**

> getCCTWorldTranslation()

**Return Values**

| any | x | position of center of CCT |
|-----|---|---------------------------|
| any | y | position of center of CCT |
| any | z | position of center of CCT |

**Code**

```lua
function CCTDrivable:getCCTWorldTranslation()
    local spec = self.spec_cctdrivable
    local cctX, cctY, cctZ = getTranslation(spec.cctNode)
    cctY = cctY + spec.cctCenterOffset
    return cctX, cctY, cctZ
end

```

### getIsCCTOnGround

**Description**

**Definition**

> getIsCCTOnGround()

**Return Values**

| any | returns | the CCT index |
|-----|---------|---------------|

**Code**

```lua
function CCTDrivable:getIsCCTOnGround()
    local spec = self.spec_cctdrivable
    if self.isServer then
        local _, _, isOnGround = getCCTCollisionFlags(spec.controllerIndex)
        return isOnGround
    end
    return false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function CCTDrivable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "CCTDrivable" )

    schema:register(XMLValueType.FLOAT, "vehicle.cctDrivable#cctRadius" , "CCT radius" , 1.0 )
    schema:register(XMLValueType.FLOAT, "vehicle.cctDrivable#cctHeight" , "CCT height" , 1.0 )
    schema:register(XMLValueType.FLOAT, "vehicle.cctDrivable#cctSlopeLimit" , "CCT slope limit" , 25.0 )
    schema:register(XMLValueType.FLOAT, "vehicle.cctDrivable#cctStepOffset" , "CCT step offset" , 0.35 )

    schema:setXMLSpecializationType()
end

```

### moveCCT

**Description**

**Definition**

> moveCCT()

**Arguments**

| any | moveX |
|-----|-------|
| any | moveY |
| any | moveZ |

**Code**

```lua
function CCTDrivable:moveCCT(moveX, moveY, moveZ)
    if self.isServer then
        local spec = self.spec_cctdrivable
        -- move cct
        -- print(string.format("-- [CCTDrivable:moveCCT][%d] physIndex(%d) move(%.6f, %.6f, %.6f) physDt(%.6f) physDtNoInterp(%.6f) physDtUnclamp(%.6f)", g_updateLoopIndex, getPhysicsUpdateIndex(), moveX, moveY, moveZ, g_physicsDt, g_physicsDtNonInterpolated, g_physicsDtUnclamped))
        moveCCT(spec.controllerIndex, moveX, moveY, moveZ, spec.movementCollisionGroup, spec.movementCollisionMask)
        self:raiseActive()
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function CCTDrivable:onDelete()
    local spec = self.spec_cctdrivable

    if spec.controllerIndex ~ = nil then
        removeCCT(spec.controllerIndex)
        delete(spec.cctNode)
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
function CCTDrivable:onLoad(savegame)
    local spec = self.spec_cctdrivable

    spec.cctRadius = self.xmlFile:getValue( "vehicle.cctDrivable#cctRadius" , 1.0 )
    spec.cctHeight = self.xmlFile:getValue( "vehicle.cctDrivable#cctHeight" , 1.0 )
    spec.cctSlopeLimit = self.xmlFile:getValue( "vehicle.cctDrivable#cctSlopeLimit" , 25 )
    spec.cctStepOffset = self.xmlFile:getValue( "vehicle.cctDrivable#cctStepOffset" , 0.3 )
    spec.cctCenterOffset = - spec.cctRadius

    spec.kinematicCollisionGroup = CollisionFlag.ANIMAL + CollisionFlag.CAMERA_BLOCKING
    spec.kinematicCollisionMask = CollisionMask.ALL
    - bit32.bor(
    CollisionFlag.VEHICLE,
    CollisionFlag.ANIMAL,
    CollisionFlag.PLAYER,
    CollisionFlag.WATER,
    CollisionFlag.AI_BLOCKING,
    CollisionFlag.GROUND_TIP_BLOCKING,
    CollisionFlag.PLACEMENT_BLOCKING,
    CollisionFlag.CAMERA_BLOCKING,
    CollisionFlag.PRECIPITATION_BLOCKING,
    CollisionFlag.ANIMAL_NAV_MESH_BLOCKING,
    CollisionFlag.TERRAIN_DISPLACEMENT
    )

    spec.movementCollisionGroup = spec.kinematicCollisionGroup
    spec.movementCollisionMask = CollisionMask.ALL
    - bit32.bor(
    CollisionFlag.TRIGGER,
    CollisionFlag.WATER,
    CollisionFlag.AI_BLOCKING,
    CollisionFlag.GROUND_TIP_BLOCKING,
    CollisionFlag.PLACEMENT_BLOCKING,
    CollisionFlag.CAMERA_BLOCKING,
    CollisionFlag.PRECIPITATION_BLOCKING,
    CollisionFlag.ANIMAL_NAV_MESH_BLOCKING,
    CollisionFlag.TERRAIN_DISPLACEMENT
    )

    if self.isServer then
        -- CCT
        spec.cctNode = createTransformGroup( "cctDrivable" )
        link(getRootNode(), spec.cctNode)
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
function CCTDrivable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Enterable , specializations)
end

```

### registerEventListeners

**Description**

> Registers event listeners

**Definition**

> registerEventListeners(table vehicleType)

**Arguments**

| table | vehicleType | type of vehicle |
|-------|-------------|-----------------|

**Code**

```lua
function CCTDrivable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , CCTDrivable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , CCTDrivable )
end

```

### registerFunctions

**Description**

> Registers functions

**Definition**

> registerFunctions(table vehicleType)

**Arguments**

| table | vehicleType | type of vehicle |
|-------|-------------|-----------------|

**Code**

```lua
function CCTDrivable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getTouchingNode" , CCTDrivable.getTouchingNode)
    SpecializationUtil.registerFunction(vehicleType, "moveCCTExternal" , CCTDrivable.moveCCTExternal)
    SpecializationUtil.registerFunction(vehicleType, "moveCCT" , CCTDrivable.moveCCT)
    SpecializationUtil.registerFunction(vehicleType, "getIsCCTOnGround" , CCTDrivable.getIsCCTOnGround)
    SpecializationUtil.registerFunction(vehicleType, "getCCTCollisionMask" , CCTDrivable.getCCTCollisionMask)
    SpecializationUtil.registerFunction(vehicleType, "getCCTWorldTranslation" , CCTDrivable.getCCTWorldTranslation)
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
function CCTDrivable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , CCTDrivable.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPosition" , CCTDrivable.setWorldPosition)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPositionQuaternion" , CCTDrivable.setWorldPositionQuaternion)
end

```

### setWorldPosition

**Description**

> Set world position and rotation of component

**Definition**

> setWorldPosition(float x, float y, float z, float xRot, float yRot, float zRot, integer i, boolean changeInterp, )

**Arguments**

| float   | x            | x position           |
|---------|--------------|----------------------|
| float   | y            | y position           |
| float   | z            | z position           |
| float   | xRot         | x rotation           |
| float   | yRot         | y rotation           |
| float   | zRot         | z rotation           |
| integer | i            | index if component   |
| boolean | changeInterp | change interpolation |
| any     | changeInterp |                      |

**Code**

```lua
function CCTDrivable:setWorldPosition(superFunc, x,y,z, xRot,yRot,zRot, i, changeInterp)
    superFunc( self , x,y,z, xRot,yRot,zRot, i, changeInterp)
    if self.isServer and i = = 1 then
        local spec = self.spec_cctdrivable
        setTranslation(spec.cctNode, x, y - spec.cctCenterOffset, z)
    end
end

```

### setWorldPositionQuaternion

**Description**

> Set world position and quaternion rotation of component

**Definition**

> setWorldPositionQuaternion(float x, float y, float z, float qx, float qy, float qz, float qw, integer i, boolean
> changeInterp, )

**Arguments**

| float   | x            | x position           |
|---------|--------------|----------------------|
| float   | y            | y position           |
| float   | z            | z position           |
| float   | qx           | x rotation           |
| float   | qy           | y rotation           |
| float   | qz           | z rotation           |
| float   | qw           | w rotation           |
| integer | i            | index if component   |
| boolean | changeInterp | change interpolation |
| any     | changeInterp |                      |

**Code**

```lua
function CCTDrivable:setWorldPositionQuaternion(superFunc, x, y, z, qx, qy, qz, qw, i, changeInterp)
    superFunc( self , x, y, z, qx, qy, qz, qw, i, changeInterp)
    if self.isServer and i = = 1 then
        local spec = self.spec_cctdrivable
        setTranslation(spec.cctNode, x, y - spec.cctCenterOffset, z)
    end
end

```