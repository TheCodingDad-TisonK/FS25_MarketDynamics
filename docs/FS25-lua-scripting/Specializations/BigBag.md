## BigBag

**Description**

> Specialization for big bags to control joint limits and size animation

**Functions**

- [getInfoBoxTitle](#getinfoboxtitle)
- [initSpecialization](#initspecialization)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getInfoBoxTitle

**Description**

**Definition**

> getInfoBoxTitle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function BigBag:getInfoBoxTitle(superFunc)
    return g_i18n:getText( "shopItem_bigBag" )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function BigBag.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "BigBag" )

    schema:register(XMLValueType.INT, "vehicle.bigBag#fillUnitIndex" , "Fill unit index" )

    schema:register(XMLValueType.STRING, "vehicle.bigBag.sizeAnimation#name" , "Name of size animation" )
    schema:register(XMLValueType.FLOAT, "vehicle.bigBag.sizeAnimation#minTime" , "Min.animation that is used while it's empty" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.bigBag.sizeAnimation#maxTime" , "Max.animation that is used while it's full" , 1 )

            schema:register(XMLValueType.FLOAT, "vehicle.bigBag.sizeAnimation#liftShrinkTime" , "Time of animation that is reduced while the big bag is lifted" , 0.2 )

                schema:register(XMLValueType.INT, "vehicle.bigBag.componentJoint#index" , "Component Joint Index" , 1 )
                schema:register(XMLValueType.VECTOR_ROT, "vehicle.bigBag.componentJoint#minRotLimit" , "Rot Limit if trans limit is at min" )
                    schema:register(XMLValueType.VECTOR_ROT, "vehicle.bigBag.componentJoint#maxRotLimit" , "Rot Limit if trans limit is at max" )
                        schema:register(XMLValueType.VECTOR_TRANS, "vehicle.bigBag.componentJoint#minTransLimit" , "Trans Limit if big bag is empty" )
                            schema:register(XMLValueType.VECTOR_TRANS, "vehicle.bigBag.componentJoint#maxTransLimit" , "Trans Limit if big bag is full" )

                                schema:register(XMLValueType.FLOAT, "vehicle.bigBag.componentJoint#angularDamping" , "Angular damping of components" , 0.01 )

                                schema:setXMLSpecializationType()
                            end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillType         |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function BigBag:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_bigBag
    if spec.fillUnitIndex = = fillUnitIndex then
        local fillLevelPct = self:getFillUnitFillLevelPercentage(fillUnitIndex)
        spec.currentSizeTime = fillLevelPct * (spec.sizeAnimationMaxTime - spec.sizeAnimationMinTime) + spec.sizeAnimationMinTime

        spec.currentAnimationTime = spec.currentSizeTime * ( 1 - spec.currentShrinkTime)
        self:setAnimationTime(spec.sizeAnimationName, spec.currentAnimationTime)

        if self.isServer then
            if spec.minTransLimit ~ = nil and spec.maxTransLimit ~ = nil then
                local x, y, z = MathUtil.vector3ArrayLerp(spec.minTransLimit, spec.maxTransLimit, fillLevelPct)

                self:setComponentJointTransLimit(spec.componentJoint, 1 , - x, x)
                self:setComponentJointTransLimit(spec.componentJoint, 2 , - y, y)
                self:setComponentJointTransLimit(spec.componentJoint, 3 , - z, z)
            end
        end
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
function BigBag:onLoad(savegame)
    local spec = self.spec_bigBag

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.bigBag#fillUnitIndex" , 1 )

    spec.sizeAnimationName = self.xmlFile:getValue( "vehicle.bigBag.sizeAnimation#name" )
    spec.sizeAnimationMinTime = self.xmlFile:getValue( "vehicle.bigBag.sizeAnimation#minTime" , 0 )
    spec.sizeAnimationMaxTime = self.xmlFile:getValue( "vehicle.bigBag.sizeAnimation#maxTime" , 1 )

    spec.sizeAnimationLiftShrinkTime = self.xmlFile:getValue( "vehicle.bigBag.sizeAnimation#liftShrinkTime" , 0.2 )

    spec.componentJointIndex = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#index" , 1 )
    local jointDesc = self.componentJoints[spec.componentJointIndex]
    if jointDesc ~ = nil then
        spec.minRotLimit = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#minRotLimit" , nil , true )
        spec.maxRotLimit = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#maxRotLimit" , nil , true )

        spec.minTransLimit = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#minTransLimit" , nil , true )
        spec.maxTransLimit = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#maxTransLimit" , nil , true )

        spec.componentJoint = jointDesc
        spec.jointNode = jointDesc.jointNode
        spec.jointNodeReferenceNode = createTransformGroup( "jointNodeReference" )
        link( self.components[jointDesc.componentIndices[ 2 ]].node, spec.jointNodeReferenceNode)
        setWorldTranslation(spec.jointNodeReferenceNode, getWorldTranslation(spec.jointNode))
        setWorldRotation(spec.jointNodeReferenceNode, getWorldRotation(spec.jointNode))

        spec.component1 = self.components[spec.componentJoint.componentIndices[ 1 ]]
        spec.component2 = self.components[spec.componentJoint.componentIndices[ 2 ]]

        spec.angularDamping = self.xmlFile:getValue( "vehicle.bigBag.componentJoint#angularDamping" , 0.01 )
        setAngularDamping(spec.component1.node, spec.angularDamping)
        setAngularDamping(spec.component2.node, spec.angularDamping)

        spec.lastJointLimitAlpha = - 1
    end

    spec.currentShrinkTime = 0
    spec.currentSizeTime = 1
    spec.currentAnimationTime = 1

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
function BigBag:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_bigBag

    if spec.jointNode ~ = nil then
        local xLimit, _, _ = MathUtil.lerp(spec.minTransLimit[ 1 ], spec.maxTransLimit[ 1 ], self:getFillUnitFillLevelPercentage(spec.fillUnitIndex))
        local xOffset, _, _ = localToLocal(spec.jointNode, spec.jointNodeReferenceNode, 0 , 0 , 0 )
        local alpha = 1 - math.clamp((xOffset / xLimit + 1 ) / 2 , 0 , 1 )
        spec.currentShrinkTime = alpha * spec.sizeAnimationLiftShrinkTime

        if self.isServer then
            if math.abs(spec.lastJointLimitAlpha - alpha) > 0.05 then
                if spec.minRotLimit ~ = nil and spec.maxRotLimit ~ = nil then
                    local rx, ry, rz = MathUtil.vector3ArrayLerp(spec.minRotLimit, spec.maxRotLimit, alpha)

                    self:setComponentJointRotLimit(spec.componentJoint, 1 , - rx, rx)
                    self:setComponentJointRotLimit(spec.componentJoint, 2 , - ry, ry)
                    self:setComponentJointRotLimit(spec.componentJoint, 3 , - rz, rz)
                end

                spec.lastJointLimitAlpha = alpha
            end
        end

        local newAnimationTime = spec.currentSizeTime * ( 1 - spec.currentShrinkTime)
        if math.abs(newAnimationTime - spec.currentAnimationTime) > 0.01 then
            self:setAnimationTime(spec.sizeAnimationName, newAnimationTime)
            spec.currentAnimationTime = newAnimationTime
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
function BigBag.prerequisitesPresent(specializations)
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
function BigBag.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , BigBag )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , BigBag )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , BigBag )
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
function BigBag.registerFunctions(vehicleType)
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
function BigBag.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getInfoBoxTitle" , BigBag.getInfoBoxTitle)
end

```