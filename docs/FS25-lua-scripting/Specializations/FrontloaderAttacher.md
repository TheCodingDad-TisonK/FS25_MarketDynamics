## FrontloaderAttacher

**Description**

> Specialization providing a frontloader attacher dependent on configuration

**Functions**

- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onPreAttachImplement](#onpreattachimplement)
- [onPreDetachImplement](#onpredetachimplement)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function FrontloaderAttacher.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "frontloader" , g_i18n:getText( "configuration_frontloaderAttacher" ), nil , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FrontloaderAttacher" )

    local basePath = "vehicle.frontloaderConfigurations.frontloaderConfiguration(?)"
    schema:register(XMLValueType.BOOL, basePath .. ".attacherJoint#frontAxisLimitJoint" , "Front axis joint will be limited while attached" , true )
        schema:register(XMLValueType.INT, basePath .. ".attacherJoint#frontAxisJoint" , "Front axis joint index" , 1 )

        schema:setXMLSpecializationType()
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
function FrontloaderAttacher:onLoad(savegame)
    if self.configurations[ "frontloader" ] ~ = nil then
        local spec = self.spec_frontloaderAttacher

        local key = string.format( "vehicle.frontloaderConfigurations.frontloaderConfiguration(%d)" , self.configurations[ "frontloader" ] - 1 )
        if self.xmlFile:hasProperty(key .. ".attacherJoint" ) then
            local frontAxisLimitJoint = self.xmlFile:getValue(key .. ".attacherJoint#frontAxisLimitJoint" , true )
            if frontAxisLimitJoint then
                local frontAxisJoint = self.xmlFile:getValue(key .. ".attacherJoint#frontAxisJoint" , 1 )
                if self.componentJoints[frontAxisJoint] ~ = nil then
                    spec.frontAxisJoint = frontAxisJoint
                else
                        Logging.xmlWarning( self.xmlFile, "Invalid front-axis joint '%s' for frontloader attacher." , frontAxisJoint)
                        end
                    end
                end
            end

            if not self.isServer or self.spec_frontloaderAttacher.frontAxisJoint = = nil then
                SpecializationUtil.removeEventListener( self , "onPreDetachImplement" , FrontloaderAttacher )
                SpecializationUtil.removeEventListener( self , "onPreAttachImplement" , FrontloaderAttacher )
            end
        end

```

### onPreAttachImplement

**Description**

**Definition**

> onPreAttachImplement()

**Arguments**

| any | attachable          |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |
| any | loadFromSavegame    |

**Code**

```lua
function FrontloaderAttacher:onPreAttachImplement(attachable, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_frontloaderAttacher

    if spec.frontAxisJoint ~ = nil then
        local attacherJoint = nil
        local attacherJoints = self:getAttacherJoints()
        if attacherJoints ~ = nil then
            attacherJoint = attacherJoints[jointDescIndex]
        end
        if attacherJoint ~ = nil then
            if attacherJoint.jointType = = AttacherJoints.JOINTTYPE_ATTACHABLEFRONTLOADER then
                -- copy rotlimit
                spec.rotLimit = { unpack( self.componentJoints[spec.frontAxisJoint].rotLimit) }
                for i = 1 , 3 do
                    self:setComponentJointRotLimit( self.componentJoints[spec.frontAxisJoint], i, 0 , 0 )
                end
            end
        end
    end
end

```

### onPreDetachImplement

**Description**

**Definition**

> onPreDetachImplement()

**Arguments**

| any | implement |
|-----|-----------|

**Code**

```lua
function FrontloaderAttacher:onPreDetachImplement(implement)
    local spec = self.spec_frontloaderAttacher

    if spec.frontAxisJoint ~ = nil then
        local attacherJoint = nil
        local attacherJointIndex = implement.jointDescIndex
        local attacherJoints = self:getAttacherJoints()
        if attacherJoints ~ = nil then
            attacherJoint = attacherJoints[attacherJointIndex]
        end
        if attacherJoint ~ = nil then
            if attacherJoint.jointType = = AttacherJoints.JOINTTYPE_ATTACHABLEFRONTLOADER then
                for i = 1 , 3 do
                    self:setComponentJointRotLimit( self.componentJoints[spec.frontAxisJoint], i, - spec.rotLimit[i], spec.rotLimit[i])
                end
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
function FrontloaderAttacher.prerequisitesPresent(specializations)
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
function FrontloaderAttacher.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FrontloaderAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetachImplement" , FrontloaderAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttachImplement" , FrontloaderAttacher )
end

```