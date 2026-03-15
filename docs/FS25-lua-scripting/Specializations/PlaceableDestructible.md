## PlaceableDestructible

**Description**

> Specialization for placeables

**Functions**

- [loadFromXMLFile](#loadfromxmlfile)
- [onDestructibleTriggerCallback](#ondestructibletriggercallback)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableDestructible:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_destructible

    local farmId = xmlFile:getValue(key .. ".repairingFarm#id" )
    if farmId ~ = nil then
        local farm = g_farmManager:getFarmById(farmId)
        if farm ~ = nil then
            spec.repairingFarmId = farmId
        else
                Logging.warning(xmlFile, "Repairing farm(Id '%s') does not exist anymore.Ignoring it in '%s'" , farmId, key)
            end
        end
    end

```

### onDestructibleTriggerCallback

**Description**

**Definition**

> onDestructibleTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |

**Code**

```lua
function PlaceableDestructible:onDestructibleTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherActorId = = g_localPlayer.rootNode then
            local spec = self.spec_destructible
            if onEnter then
                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            else
                    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                end
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
function PlaceableDestructible:onFinalizePlacement()
    local spec = self.spec_destructible
    if spec.triggerNode ~ = nil then
        addTrigger(spec.triggerNode, "onDestructibleTriggerCallback" , self )
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
function PlaceableDestructible:onLoad(savegame)
    local spec = self.spec_destructible

    spec.destructTransitions = { }
    for _, transitionKey in self.xmlFile:iterator( "placeable.destructible.destruct.transition" ) do
        local stateFromName = self.xmlFile:getValue(transitionKey .. "#from" , "" )
        local stateFromIndex = self:getConstructibleStateIndexByName(stateFromName)
        if stateFromIndex = = nil then
            Logging.xmlError( self.xmlFile, "Invalid state.Transition from name '%s' not defined for '%s'" , stateFromName, transitionKey)
                break
            end

            local stateToName = self.xmlFile:getValue(transitionKey .. "#to" , "" )
            local stateToIndex = self:getConstructibleStateIndexByName(stateToName)
            if stateToIndex = = nil then
                Logging.xmlError( self.xmlFile, "Invalid state.Transition to name '%s' not defined for '%s'" , stateToName, transitionKey)
                    break
                end

                spec.destructTransitions[stateFromIndex] = stateToIndex
            end

            spec.repairTransitions = { }
            for _, transitionKey in self.xmlFile:iterator( "placeable.destructible.repair.transition" ) do
                local stateFromName = self.xmlFile:getValue(transitionKey .. "#from" , "" )
                local stateFromIndex = self:getConstructibleStateIndexByName(stateFromName)
                if stateFromIndex = = nil then
                    Logging.xmlError( self.xmlFile, "Invalid state.Transition from name '%s' not defined for '%s'" , stateFromName, transitionKey)
                        break
                    end

                    local stateToName = self.xmlFile:getValue(transitionKey .. "#to" , "" )
                    local stateToIndex = self:getConstructibleStateIndexByName(stateToName)
                    if stateToIndex = = nil then
                        Logging.xmlError( self.xmlFile, "Invalid state.Transition to name '%s' not defined for '%s'" , stateToName, transitionKey)
                            break
                        end

                        spec.repairTransitions[stateFromIndex] = stateToIndex
                    end

                    spec.repairBonus = self.xmlFile:getValue( "placeable.destructible.repair#bonus" , nil )

                    spec.triggerNode = self.xmlFile:getValue( "placeable.destructible.trigger#node" , nil , self.components, self.i3dMappings)
                    if spec.triggerNode ~ = nil then
                        if not CollisionFlag.getHasMaskFlagSet(spec.triggerNode, CollisionFlag.PLAYER) then
                            Logging.xmlWarning( self.xmlFile, "Trigger collision mask is missing bit 'TRIGGER_PLAYER' (%d)" , CollisionFlag.getBit(CollisionFlag.PLAYER))
                        end
                    end

                    if self.isClient then
                        spec.samples = { }
                        spec.samples.destructed = g_soundManager:loadSampleFromXML( self.xmlFile, "placeable.destructible.sounds" , "destructed" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                    end

                    spec.activatable = DestructibleActivatable.new( self )
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
function PlaceableDestructible.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableConstructible , specializations)
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
function PlaceableDestructible.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableDestructible )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableDestructible )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableDestructible )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableDestructible.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "destruct" , PlaceableDestructible.destruct)
    SpecializationUtil.registerFunction(placeableType, "destructed" , PlaceableDestructible.destructed)
    SpecializationUtil.registerFunction(placeableType, "startRepairDestructible" , PlaceableDestructible.startRepairDestructible)
    SpecializationUtil.registerFunction(placeableType, "getCanRepairDestructible" , PlaceableDestructible.getCanRepairDestructible)
    SpecializationUtil.registerFunction(placeableType, "onDestructibleTriggerCallback" , PlaceableDestructible.onDestructibleTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "getCanBeDestructedByTwister" , PlaceableDestructible.getCanBeDestructedByTwister)
    SpecializationUtil.registerFunction(placeableType, "startedRepairDestructible" , PlaceableDestructible.startedRepairDestructible)
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
function PlaceableDestructible.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "finalizeConstruction" , PlaceableDestructible.finalizeConstruction)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableDestructible.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. ".repairingFarm#id" , "" )
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
function PlaceableDestructible.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Destructible" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".destructible.trigger#node" , "Trigger" , nil , false )
    schema:register(XMLValueType.STRING, basePath .. ".destructible.destruct.transition(?)#from" , "State name from" , nil , false )
    schema:register(XMLValueType.STRING, basePath .. ".destructible.destruct.transition(?)#to" , "State name to" , nil , false )
    schema:register(XMLValueType.FLOAT, basePath .. ".destructible.repair#bonus" , "Bonus for repairing an unowned building" , nil , false )
        schema:register(XMLValueType.STRING, basePath .. ".destructible.repair.transition(?)#from" , "State name from" , nil , false )
        schema:register(XMLValueType.STRING, basePath .. ".destructible.repair.transition(?)#to" , "State name to" , nil , false )
        SoundManager.registerSampleXMLPaths(schema, basePath .. ".destructible.sounds" , "destructed" )
        schema:setXMLSpecializationType()
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
function PlaceableDestructible:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_destructible

    if spec.repairingFarmId ~ = nil then
        xmlFile:setValue(key .. ".repairingFarm#id" , spec.repairingFarmId)
    end
end

```