## SemiTrailerFront

**Description**

> Specialization for detachable front part of separable semi trailers

**Functions**

- [isDetachAllowed](#isdetachallowed)
- [onLoad](#onload)
- [onPostAttach](#onpostattach)
- [onPostAttachImplement](#onpostattachimplement)
- [onPreDetach](#onpredetach)
- [onPreDetachImplement](#onpredetachimplement)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### isDetachAllowed

**Description**

> Returns true if detach is allowed

**Definition**

> isDetachAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | detachAllowed | detach is allowed |
|-----|---------------|-------------------|

**Code**

```lua
function SemiTrailerFront:isDetachAllowed(superFunc)
    local canBeDatached, warning = superFunc( self )
    if not canBeDatached then
        return false , warning
    end

    local spec = self.spec_semiTrailerFront
    return spec.attachedSemiTrailerBack ~ = nil , nil
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
function SemiTrailerFront:onLoad(savegame)
    local spec = self.spec_semiTrailerFront
    spec.inputAttacherCurFade = 1
    spec.inputAttacherFadeDir = 1
    spec.inputAttacherFadeDuration = 1000

    spec.joint = self.spec_attachable.inputAttacherJoints[ 1 ]
    spec.joint.lowerRotLimitScaleBackup = { spec.joint.lowerRotLimitScale[ 1 ], spec.joint.lowerRotLimitScale[ 2 ], spec.joint.lowerRotLimitScale[ 3 ] }

    spec.attachedSemiTrailerBack = nil
    spec.inputAttacherImplement = nil
    spec.doSemiTrailerLockCheck = true
end

```

### onPostAttach

**Description**

> Called after vehicle was attached

**Definition**

> onPostAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                           |
|---------|---------------------|--------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint              |
| integer | jointDescIndex      | index of attacher joint it was attached to |

**Code**

```lua
function SemiTrailerFront:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_semiTrailerFront
    spec.inputAttacherImplement = attacherVehicle:getImplementByObject( self )
end

```

### onPostAttachImplement

**Description**

> Called on attaching a implement

**Definition**

> onPostAttachImplement(table implement, , , )

**Arguments**

| table | implement           | implement to attach |
|-------|---------------------|---------------------|
| any   | inputJointDescIndex |                     |
| any   | jointDescIndex      |                     |
| any   | loadFromSavegame    |                     |

**Code**

```lua
function SemiTrailerFront:onPostAttachImplement(attachable, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_semiTrailerFront
    spec.attachedSemiTrailerBack = attachable
    spec.inputAttacherFadeDir = 1000
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
function SemiTrailerFront:onPreDetach(attacherVehicle, implement)
    local spec = self.spec_semiTrailerFront
    spec.inputAttacherImplement = nil
end

```

### onPreDetachImplement

**Description**

> Called on detaching a implement

**Definition**

> onPreDetachImplement(integer implementIndex)

**Arguments**

| integer | implementIndex | index of implement to detach |
|---------|----------------|------------------------------|

**Code**

```lua
function SemiTrailerFront:onPreDetachImplement(implement)
    local spec = self.spec_semiTrailerFront
    spec.attachedSemiTrailerBack = nil
    spec.inputAttacherFadeDir = - 1
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function SemiTrailerFront:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_semiTrailerFront

    if spec.doSemiTrailerLockCheck then
        spec.doSemiTrailerLockCheck = false
        if spec.attachedSemiTrailerBack = = nil then
            spec.inputAttacherFadeDir = - 1
        end
    end

    if self.isServer and spec.inputAttacherImplement ~ = nil and((spec.inputAttacherCurFade > 0 and spec.inputAttacherFadeDir < 0 ) or(spec.inputAttacherCurFade < 1 and spec.inputAttacherFadeDir > 0 )) then
        spec.inputAttacherCurFade = math.clamp(spec.inputAttacherCurFade + (spec.inputAttacherFadeDir * dt) / spec.inputAttacherFadeDuration, 0 , 1 )

        local lowerRotLimitScale = spec.joint.lowerRotLimitScale
        local lowerRotLimitScaleBackup = spec.joint.lowerRotLimitScaleBackup
        lowerRotLimitScale[ 1 ] = lowerRotLimitScaleBackup[ 1 ] * spec.inputAttacherCurFade
        lowerRotLimitScale[ 2 ] = lowerRotLimitScaleBackup[ 2 ] * spec.inputAttacherCurFade
        lowerRotLimitScale[ 3 ] = lowerRotLimitScaleBackup[ 3 ] * spec.inputAttacherCurFade

        local attacherVehicle = self:getAttacherVehicle()
        if attacherVehicle ~ = nil then
            local attacherJoints = attacherVehicle:getAttacherJoints()
            local jointDesc = attacherJoints[spec.inputAttacherImplement.jointDescIndex]
            local lowerRotLimit = spec.inputAttacherImplement.lowerRotLimit
            if lowerRotLimit ~ = nil then
                local x = lowerRotLimit[ 1 ] * lowerRotLimitScale[ 1 ]
                local y = lowerRotLimit[ 2 ] * lowerRotLimitScale[ 2 ]
                local z = lowerRotLimit[ 3 ] * lowerRotLimitScale[ 3 ]

                setJointRotationLimit(jointDesc.jointIndex, 0 , true , - x, x)
                setJointRotationLimit(jointDesc.jointIndex, 1 , true , - y, y)
                setJointRotationLimit(jointDesc.jointIndex, 2 , true , - z, z)
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
function SemiTrailerFront.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AttacherJoints , specializations)
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
function SemiTrailerFront.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SemiTrailerFront )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , SemiTrailerFront )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttachImplement" , SemiTrailerFront )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetachImplement" , SemiTrailerFront )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , SemiTrailerFront )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , SemiTrailerFront )
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
function SemiTrailerFront.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isDetachAllowed" , SemiTrailerFront.isDetachAllowed)
end

```