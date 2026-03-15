## AutoLoaderBales

**Description**

> Specialization to automatically load bales into a tool
> Use for straw blowers and mixer wagons on Platforms with automatic loading enabled

**Functions**

- [autoLoaderBalesTriggerCallback](#autoloaderbalestriggercallback)
- [doAutoLoadBale](#doautoloadbale)
- [getAutoLoadBaleTypeFromBale](#getautoloadbaletypefrombale)
- [getIsBaleAutoLoadable](#getisbaleautoloadable)
- [initSpecialization](#initspecialization)
- [onBaleDeleted](#onbaledeleted)
- [onDelete](#ondelete)
- [onDeleteAutoLoaderBalesObject](#ondeleteautoloaderbalesobject)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)

### autoLoaderBalesTriggerCallback

**Description**

> Trigger callback

**Definition**

> autoLoaderBalesTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean
> onStay, integer otherShapeId)

**Arguments**

| integer | triggerId    | id of trigger     |
|---------|--------------|-------------------|
| integer | otherActorId | id of other actor |
| boolean | onEnter      | on enter          |
| boolean | onLeave      | on leave          |
| boolean | onStay       | on stay           |
| integer | otherShapeId | id of other shape |

**Code**

```lua
function AutoLoaderBales:autoLoaderBalesTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    if otherActorId = = 0 then
        return
    end

    local object = g_currentMission:getNodeObject(otherActorId)
    if object = = nil then
        return
    end

    if not object:isa( Bale ) or not g_currentMission.accessHandler:canFarmAccess( self:getActiveFarm(), object) or not object:getAllowPickup() then
        return
    end

    local spec = self.spec_autoLoaderBales
    if onEnter then
        spec.balesInTrigger[object] = (spec.balesInTrigger[object] or 0 ) + 1
        if spec.balesInTrigger[object] = = 1 then
            object:addDeleteListener( self , AutoLoaderBales.onBaleDeleted)
        end
    else
            spec.balesInTrigger[object] = (spec.balesInTrigger[object] or 0 ) - 1
            if spec.balesInTrigger[object] < = 0 then
                spec.balesInTrigger[object] = nil
                object:removeDeleteListener( self , AutoLoaderBales.onBaleDeleted)
            end
        end
    end

```

### doAutoLoadBale

**Description**

**Definition**

> doAutoLoadBale()

**Arguments**

| any | baleType |
|-----|----------|
| any | bale     |

**Code**

```lua
function AutoLoaderBales:doAutoLoadBale(baleType, bale)
    local spec = self.spec_autoLoaderBales

    if baleType.mountBale then
        local x, y, z
        if bale.isRoundbale then
            x, y, z = baleType.offsetDirection[ 1 ] * spec.numMountedBales * bale.diameter, baleType.offsetDirection[ 2 ] * spec.numMountedBales * bale.diameter, baleType.offsetDirection[ 3 ] * spec.numMountedBales * bale.width
        else
                x, y, z = baleType.offsetDirection[ 1 ] * spec.numMountedBales * bale.width, baleType.offsetDirection[ 2 ] * spec.numMountedBales * bale.height, baleType.offsetDirection[ 3 ] * spec.numMountedBales * bale.length
            end

            bale:mountKinematic( self , baleType.spawnNode, x, y, z, 0 , 0 , 0 )
            bale:setNeedsSaving( false )
            spec.mountedBales[bale] = true
            bale:addDeleteListener( self , AutoLoaderBales.onDeleteAutoLoaderBalesObject)

            spec.loadedBaleType = baleType
            spec.numMountedBales = spec.numMountedBales + 1
        else
                removeFromPhysics(bale.nodeId)

                setTranslation(bale.nodeId, getWorldTranslation(baleType.spawnNode))
                setWorldRotation(bale.nodeId, getWorldRotation(baleType.spawnNode))

                addToPhysics(bale.nodeId)

                local vx, vy, vz = getLinearVelocity( self:getParentComponent(baleType.spawnNode))
                setLinearVelocity(bale.nodeId, vx, vy, vz)
            end
        end

```

### getAutoLoadBaleTypeFromBale

**Description**

**Definition**

> getAutoLoadBaleTypeFromBale()

**Arguments**

| any | bale |
|-----|------|

**Code**

```lua
function AutoLoaderBales:getAutoLoadBaleTypeFromBale(bale)
    local spec = self.spec_autoLoaderBales
    local baleFillType = bale:getFillType()

    for i = 1 , #spec.baleTypes do
        local baleType = spec.baleTypes[i]
        if spec.loadedBaleType = = nil or baleType = = spec.loadedBaleType then
            local fillTypeAllowed = #baleType.fillTypes = = 0
            for j = 1 , #baleType.fillTypes do
                if baleType.fillTypes[j] = = baleFillType then
                    fillTypeAllowed = true
                    break
                end
            end

            if fillTypeAllowed then
                if bale:getBaleMatchesSize(baleType.diameter, baleType.width, baleType.height, baleType.length) then
                    return baleType
                end
            end
        end
    end

    return nil
end

```

### getIsBaleAutoLoadable

**Description**

**Definition**

> getIsBaleAutoLoadable()

**Arguments**

| any | bale |
|-----|------|

**Code**

```lua
function AutoLoaderBales:getIsBaleAutoLoadable(bale)
    if bale.mountObject ~ = nil then
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
function AutoLoaderBales.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AutoLoaderBales" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.autoLoaderBales.trigger#node" , "Bale pickup trigger node" )

    schema:register(XMLValueType.STRING, "vehicle.autoLoaderBales.baleTypes.baleType(?)#fillTypes" , "List of supported fill types(if empty, all fill types are allowed)" )

        schema:register(XMLValueType.FLOAT, "vehicle.autoLoaderBales.baleTypes.baleType(?)#diameter" , "Bale diameter" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.autoLoaderBales.baleTypes.baleType(?)#width" , "Bale width" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.autoLoaderBales.baleTypes.baleType(?)#height" , "Bale height" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.autoLoaderBales.baleTypes.baleType(?)#length" , "Bale length" , 0 )

        schema:register(XMLValueType.NODE_INDEX, "vehicle.autoLoaderBales.baleTypes.baleType(?).spawnPlace#node" , "Node to spawn the bale" )
        schema:register(XMLValueType.INT, "vehicle.autoLoaderBales.baleTypes.baleType(?).spawnPlace#numBales" , "Number of bales that can be loaded" , 1 )
        schema:register(XMLValueType.VECTOR_ 3 , "vehicle.autoLoaderBales.baleTypes.baleType(?).spawnPlace#offsetDirection" , "Defines the axis in which the additional bales are moved" , "0 1 0" )
        schema:register(XMLValueType.BOOL, "vehicle.autoLoaderBales.baleTypes.baleType(?).spawnPlace#mountBale" , "Defines if the bale is mounted or just moved to the position of the spawn node" , true )

            schema:setXMLSpecializationType()

            local schemaSavegame = Vehicle.xmlSchemaSavegame
            Bale.registerSavegameXMLPaths(schemaSavegame, "vehicles.vehicle(?).autoLoaderBales.bale(?)" )
        end

```

### onBaleDeleted

**Description**

**Definition**

> onBaleDeleted()

**Arguments**

| any | self   |
|-----|--------|
| any | object |

**Code**

```lua
function AutoLoaderBales.onBaleDeleted( self , object)
    local spec = self.spec_autoLoaderBales
    spec.balesInTrigger[object] = nil
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function AutoLoaderBales:onDelete()
    local spec = self.spec_autoLoaderBales
    if spec.triggerId ~ = nil then
        removeTrigger(spec.triggerId)
    end

    if spec.balesInTrigger ~ = nil then
        for bale, _ in pairs(spec.balesInTrigger) do
            if bale.removeDeleteListener ~ = nil then
                bale:removeDeleteListener( self , AutoLoaderBales.onBaleDeleted)
            end
        end
        table.clear(spec.balesInTrigger)
    end

    if spec.mountedBales ~ = nil then
        for bale, _ in pairs(spec.mountedBales) do
            if bale.removeDeleteListener ~ = nil then
                bale:removeDeleteListener( self , AutoLoaderBales.onDeleteAutoLoaderBalesObject)
            end
            bale:unmountKinematic()
            bale:setNeedsSaving( true )
        end
        table.clear(spec.mountedBales)
    end
end

```

### onDeleteAutoLoaderBalesObject

**Description**

**Definition**

> onDeleteAutoLoaderBalesObject()

**Arguments**

| any | self   |
|-----|--------|
| any | object |

**Code**

```lua
function AutoLoaderBales.onDeleteAutoLoaderBalesObject( self , object)
    local spec = self.spec_autoLoaderBales
    if spec.mountedBales[object] ~ = nil then
        spec.mountedBales[object] = nil
        spec.numMountedBales = spec.numMountedBales - 1
    end

    spec.balesInTrigger[object] = nil

    if next(spec.mountedBales) = = nil then
        spec.loadedBaleType = nil
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
function AutoLoaderBales:onLoad(savegame)
    local spec = self.spec_autoLoaderBales

    spec.balesInTrigger = { }
    spec.balePickupDelay = 0

    spec.mountedBales = { }
    spec.numMountedBales = 0
    spec.loadedBaleType = nil

    if self.isServer then
        spec.triggerId = self.xmlFile:getValue( "vehicle.autoLoaderBales.trigger#node" , nil , self.components, self.i3dMappings)
        if spec.triggerId ~ = nil then
            addTrigger(spec.triggerId, "autoLoaderBalesTriggerCallback" , self )
        end

        spec.baleTypes = { }
        self.xmlFile:iterate( "vehicle.autoLoaderBales.baleTypes.baleType" , function (index, baleTypeKey)
            local baleType = { }
            baleType.spawnNode = self.xmlFile:getValue(baleTypeKey .. ".spawnPlace#node" , nil , self.components, self.i3dMappings)
            if baleType.spawnNode ~ = nil then
                baleType.numBales = self.xmlFile:getValue(baleTypeKey .. ".spawnPlace#numBales" , 1 )
                baleType.offsetDirection = self.xmlFile:getValue(baleTypeKey .. ".spawnPlace#offsetDirection" , "0 1 0" , true )
                baleType.mountBale = self.xmlFile:getValue(baleTypeKey .. ".spawnPlace#mountBale" , true )

                baleType.diameter = MathUtil.round( self.xmlFile:getValue(baleTypeKey .. "#diameter" , 0 ), 2 )
                baleType.width = MathUtil.round( self.xmlFile:getValue(baleTypeKey .. "#width" , 0 ), 2 )
                baleType.height = MathUtil.round( self.xmlFile:getValue(baleTypeKey .. "#height" , 0 ), 2 )
                baleType.length = MathUtil.round( self.xmlFile:getValue(baleTypeKey .. "#length" , 0 ), 2 )

                local fillTypeNames = self.xmlFile:getValue(baleTypeKey .. "#fillTypes" )
                baleType.fillTypes = g_fillTypeManager:getFillTypesByNames(fillTypeNames, "Warning: '" .. self.xmlFile:getFilename() .. "' has invalid fillType '%s'." )

                if (baleType.diameter ~ = 0 and baleType.width ~ = 0 )
                    or(baleType.width ~ = 0 and baleType.height ~ = 0 and baleType.length ~ = 0 ) then
                    table.insert(spec.baleTypes, baleType)
                else
                        Logging.xmlWarning( self.xmlFile, "Incomplete bale size defintion in '%s'" , baleTypeKey)
                    end
                else
                        Logging.xmlWarning( self.xmlFile, "Missing spawn place node in '%s'" , baleTypeKey)
                    end
                end )
            end
        end

```

### onLoadFinished

**Description**

> Called after loading

**Definition**

> onLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function AutoLoaderBales:onLoadFinished(savegame)
    if savegame ~ = nil then
        if not savegame.resetVehicles then
            savegame.xmlFile:iterate(savegame.key .. ".autoLoaderBales.bale" , function (index, baleKey)
                local attributes = { }
                Bale.loadBaleAttributesFromXMLFile(attributes, savegame.xmlFile, baleKey, savegame.resetVehicles)

                local bale = Bale.new( self.isServer, self.isClient)
                if bale:loadFromConfigXML(attributes.xmlFilename, 0 , 0 , 0 , 0 , 0 , 0 , attributes.uniqueId) then
                    bale:applyBaleAttributes(attributes)
                    local baleType = self:getAutoLoadBaleTypeFromBale(bale)
                    if baleType ~ = nil then
                        self:doAutoLoadBale(baleType, bale)
                    else
                            bale:delete()
                        end
                    end
                end )
            end

        end
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
function AutoLoaderBales:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_autoLoaderBales

    spec.balePickupDelay = math.max(spec.balePickupDelay - 1 , 0 )
    if spec.balePickupDelay = = 0 then
        local baleMaxHeight = 0
        local baleToLoad, baleTypeToLoad
        for object, num in pairs(spec.balesInTrigger) do
            if num > 0 then
                if self:getIsBaleAutoLoadable(object) then
                    local baleType = self:getAutoLoadBaleTypeFromBale(object)
                    if baleType ~ = nil then
                        if spec.numMountedBales < baleType.numBales then
                            local _, y, _ = getWorldTranslation(object.nodeId)
                            if y > baleMaxHeight then
                                baleMaxHeight = y
                                baleToLoad, baleTypeToLoad = object, baleType
                            end
                        end
                    end
                end
            end
        end

        if baleToLoad ~ = nil then
            self:doAutoLoadBale(baleTypeToLoad, baleToLoad)
            spec.balesInTrigger[baleToLoad] = nil
            spec.balePickupDelay = 10
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
function AutoLoaderBales.prerequisitesPresent(specializations)
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
function AutoLoaderBales.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AutoLoaderBales )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , AutoLoaderBales )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , AutoLoaderBales )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AutoLoaderBales )
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
function AutoLoaderBales.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "autoLoaderBalesTriggerCallback" , AutoLoaderBales.autoLoaderBalesTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "getAutoLoadBaleTypeFromBale" , AutoLoaderBales.getAutoLoadBaleTypeFromBale)
    SpecializationUtil.registerFunction(vehicleType, "doAutoLoadBale" , AutoLoaderBales.doAutoLoadBale)
    SpecializationUtil.registerFunction(vehicleType, "getIsBaleAutoLoadable" , AutoLoaderBales.getIsBaleAutoLoadable)
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
function AutoLoaderBales.registerOverwrittenFunctions(vehicleType)
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
function AutoLoaderBales:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_autoLoaderBales

    local index = 0
    for bale, _ in pairs(spec.mountedBales) do
        local baleKey = string.format( "%s.bale(%d)" , key, index)
        bale:saveToXMLFile(xmlFile, baleKey)
        index = index + 1
    end
end

```