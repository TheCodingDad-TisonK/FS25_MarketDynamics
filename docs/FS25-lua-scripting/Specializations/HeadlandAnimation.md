## HeadlandAnimation

**Description**

> Specialization for playing animations when vehicle is on headland

**Functions**

- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function HeadlandAnimation.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "HeadlandAnimation" )

    schema:register(XMLValueType.TIME, "vehicle.headlandAnimation#activationDelay" , "Headland is activated after this time above activationAngle" , 0.5 )
    schema:register(XMLValueType.TIME, "vehicle.headlandAnimation#deactivationDelay" , "Headland is deactivated after this time below deactivationAngle" , 4 )
    schema:register(XMLValueType.FLOAT, "vehicle.headlandAnimation#activationAngle" , "Headland is activated above this steering percentage [0-1]" , 0.2 )
    schema:register(XMLValueType.FLOAT, "vehicle.headlandAnimation#deactivationAngle" , "Headland is deactivated below this steering percentage [0-1]" , 0.13 )
    schema:register(XMLValueType.STRING, "vehicle.headlandAnimation#requiredGroundTypes" , "Headland is only activated one of these ground types is below vehicle" )

    schema:register(XMLValueType.STRING, "vehicle.headlandAnimation.animation(?)#name" , "Animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.headlandAnimation.animation(?)#speed" , "Animation speed" )

    schema:setXMLSpecializationType()
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
function HeadlandAnimation:onLoad(savegame)
    local spec = self.spec_headlandAnimation

    spec.isAvailable = self.xmlFile:hasProperty( "vehicle.headlandAnimation" )
    if spec.isAvailable then
        spec.headlandActivationDelay = self.xmlFile:getValue( "vehicle.headlandAnimation#activationDelay" , 0.5 )
        spec.headlandDeactivationDelay = self.xmlFile:getValue( "vehicle.headlandAnimation#deactivationDelay" , 4 )
        spec.headlandActivationAngle = self.xmlFile:getValue( "vehicle.headlandAnimation#activationAngle" , 0.2 )
        spec.headlandDeactivationAngle = self.xmlFile:getValue( "vehicle.headlandAnimation#deactivationAngle" , 0.13 )

        local requiredGroundTypesStr = self.xmlFile:getValue( "vehicle.headlandAnimation#requiredGroundTypes" )
        requiredGroundTypesStr = requiredGroundTypesStr:split( " " )
        spec.requiredGroundTypes = { }
        for i = 1 , #requiredGroundTypesStr do
            local name = requiredGroundTypesStr[i]
            if name ~ = nil and name ~ = "" then
                local groundType = FieldGroundType[name]
                if groundType ~ = nil then
                    spec.requiredGroundTypes[groundType] = true
                else
                        Logging.xmlWarning( self.xmlFile, "Unknown ground type '%s' defined for headland animation" , name)
                        end
                    end
                end

                spec.headlandDeactivationTime = 0
                spec.headlandState = false
                spec.lastHeadlandState = false

                spec.animations = { }

                local i = 0
                while true do
                    local baseKey = string.format( "vehicle.headlandAnimation.animation(%d)" , i)
                    if not self.xmlFile:hasProperty(baseKey) then
                        break
                    end

                    local animation = { }
                    animation.name = self.xmlFile:getValue(baseKey .. "#name" )
                    animation.speed = self.xmlFile:getValue(baseKey .. "#speed" )
                    if animation.name ~ = nil then
                        table.insert(spec.animations, animation)
                    end

                    i = i + 1
                end
            else
                    SpecializationUtil.removeEventListener( self , "onUpdate" , HeadlandAnimation )
                end
            end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActive, boolean isActiveForInput, boolean isSelected)

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActive         | true if vehicle is active           |
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |

**Code**

```lua
function HeadlandAnimation:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_headlandAnimation

    local validGround = true
    if spec.headlandRequiredDensityBits ~ = 0 then
        local x, y, z = getWorldTranslation( self.components[ 1 ].node)
        local _, _, groundType = FSDensityMapUtil.getFieldDataAtWorldPosition(x, y, z)

        if spec.requiredGroundTypes[groundType] ~ = true then
            validGround = false
        end
    end

    if validGround and math.abs( self.rotatedTime) > spec.headlandActivationAngle then
        spec.headlandDeactivationTime = spec.headlandDeactivationTime + dt
        if spec.headlandDeactivationTime > spec.headlandActivationDelay then
            spec.headlandState = true
            spec.headlandDeactivationTime = spec.headlandDeactivationDelay
        end
    elseif math.abs( self.rotatedTime) < spec.headlandDeactivationAngle then
            spec.headlandDeactivationTime = math.max(spec.headlandDeactivationTime - dt, 0 )
        end

        if spec.headlandDeactivationTime = = 0 then
            spec.headlandState = false
        end

        if spec.headlandState ~ = spec.lastHeadlandState then
            local direction = spec.headlandState and 1 or - 1

            for i = 1 , #spec.animations do
                local animation = spec.animations[i]
                self:playAnimation(animation.name, animation.speed * direction, self:getAnimationTime(animation.name))
            end

            spec.lastHeadlandState = spec.headlandState
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
function HeadlandAnimation.prerequisitesPresent(specializations)
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
function HeadlandAnimation.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , HeadlandAnimation )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , HeadlandAnimation )
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
function HeadlandAnimation.registerFunctions(vehicleType)
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
function HeadlandAnimation.registerOverwrittenFunctions(vehicleType)
end

```