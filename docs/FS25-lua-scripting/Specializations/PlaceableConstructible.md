## PlaceableConstructible

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadSpecValueFillTypes](#loadspecvaluefilltypes)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableConstructible:collectPickObjects(superFunc, node)
    local spec = self.spec_constructible

    for i = 1 , #spec.unloadingStation.unloadTriggers do
        local unloadTrigger = spec.unloadingStation.unloadTriggers[i]
        if node = = unloadTrigger.exactFillRootNode then
            return
        end
    end

    superFunc( self , node)
end

```

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
function PlaceableConstructible:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_constructible

    local stateName = xmlFile:getValue(key .. ".state#name" )
    spec.stateIndexPending = spec.stateNameToIndex[stateName] or 1

    -- this needs to be delayed to avoid Placeable:finalize overwriting already disabled physics on nodes
    spec.postFinalize = function ()
        local state = spec.stateMachine[spec.stateIndexPending]
        state:loadFromXMLFile(xmlFile, key)
    end

    spec.storage:loadFromXMLFile(xmlFile, key .. ".storage" )
end

```

### loadSpecValueFillTypes

**Description**

**Definition**

> loadSpecValueFillTypes(XMLFile xmlFile, string? customEnvironment, string? baseDir, table? resultTable)

**Arguments**

| XMLFile | xmlFile           |
|---------|-------------------|
| string? | customEnvironment |
| string? | baseDir           |
| table?  | resultTable       |

**Return Values**

| table? | fillTypeNames |
|--------|---------------|

**Code**

```lua
function PlaceableConstructible.loadSpecValueFillTypes(xmlFile, customEnvironment, baseDir, resultTable)
    if not xmlFile:hasProperty( "placeable.constructible" ) then
        return resultTable
    end

    local fillTypeNames = resultTable or { }

    for _, stateKey in xmlFile:iterator( "placeable.constructible.stateMachine.states.state" ) do
        for _, inputKey in xmlFile:iterator(stateKey .. ".input" ) do
            local fillTypeName = xmlFile:getString(inputKey .. "#fillType" )
            fillTypeNames[fillTypeName] = true
        end
    end

    return fillTypeNames
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableConstructible:onDelete()
    local spec = self.spec_constructible

    removeConsoleCommand( "gsConstructibleFinishState" )

    g_messageCenter:unsubscribeAll( self )

    if spec.unloadingStation ~ = nil then
        g_currentMission.storageSystem:removeUnloadingStation(spec.unloadingStation, self )
        g_currentMission.economyManager:removeSellingStation(spec.unloadingStation)
        spec.unloadingStation:delete()
        spec.unloadingStation = nil
    end

    if spec.storage ~ = nil then
        spec.storage:delete()
        spec.storage = nil
    end

    if spec.stateMachine ~ = nil then
        for _, state in ipairs(spec.stateMachine) do
            state:delete()
        end
        spec.stateMachine = nil
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableConstructible:onFinalizePlacement(savegame)
    local spec = self.spec_constructible

    local farmId = self:getOwnerFarmId()
    if spec.unloadingStation ~ = nil then
        spec.unloadingStation:setOwnerFarmId(farmId, true )
    end
    if spec.storage ~ = nil then
        spec.storage:setOwnerFarmId(farmId, true )
    end

    if self.isServer then
        -- do this after finalize placement as addToPhysics for whole placeable is called there
            if spec.stateIndexPending ~ = nil then
                for i = 1 , spec.stateIndexPending do
                    self:setConstructibleState(i)
                end

                if spec.postFinalize ~ = nil then
                    spec.postFinalize()
                end

                spec.stateIndexPending = nil
                spec.postFinalize = nil
            else
                    self:setConstructibleState(spec.startStateIndex)
                end

                self:raiseActive()
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
function PlaceableConstructible:onLoad(savegame)
    local spec = self.spec_constructible

    spec.unloadingStation = SellingStation.new( self.isServer, self.isClient)
    spec.unloadingStation:load( self.components, self.xmlFile, "placeable.constructible.sellingStation" , self.customEnvironment, self.i3dMappings, self.components[ 1 ].node)
    spec.unloadingStation.owningPlaceable = self
    spec.unloadingStation.getStoreGoods = function (_, farmId, fillTypeIndex)
        return true
    end
    spec.unloadingStation.getSkipSell = function (_, farmId, fillTypeIndex)
        -- owned by a farm
        local ownerFarmId = self:getOwnerFarmId()
        if ownerFarmId ~ = AccessHandler.EVERYONE then
            return true
        end

        return false
    end
    spec.unloadingStation:register( true )

    spec.storage = Storage.new( self.isServer, self.isClient)
    spec.storage:load( self.components, self.xmlFile, "placeable.constructible.storage" , self.i3dMappings, self.baseDirectory)
    spec.storage:register( true )
    spec.storage:addFillLevelChangedListeners( function () self:raiseActive() end ) -- trigger update loop after storage was changed
    spec.fillTypesAndLevelsAuxiliary = { }
    spec.fillTypeToFillTypeStorageTable = { }
    spec.infoTriggerFillTypesAndLevels = { }

    spec.infoTableEntryStorage = {
    title = g_i18n:getText( "statistic_storage" ),
    accentuate = true
    }

    spec.unloadingStation:addTargetStorage(spec.storage)

    g_currentMission.storageSystem:addUnloadingStation(spec.unloadingStation, self )
    g_currentMission.economyManager:addSellingStation(spec.unloadingStation)

    -- load statemachine after animation so it can be passed for initialization
        spec.stateMachine = { }
        spec.stateNameToIndex = { }
        spec.stateTransitions = { }
        spec.stateIndex = - 1
        spec.startStateIndex = 1
        spec.previewStateIndex = 1

        spec.statesDirtyMask = 0 -- dirty mask for all state dirty flags to easily check if a state needs updating
            local maxNumStates = ( 2 ^ 8 ) - 1
            local dirtyFlags = { }
            local maxNumDirtyFlags = 10
            local stateMachineNextIndex = 1
            for _, stateKey in self.xmlFile:iterator( "placeable.constructible.stateMachine.states.state" ) do
                if stateMachineNextIndex > maxNumStates then
                    Logging.xmlWarning( self.xmlFile, "Maximum number of states reached(%d)" , maxNumStates)
                    break
                end

                local stateName = string.upper( self.xmlFile:getValue(stateKey .. "#name" , "" ))
                if spec.stateNameToIndex[stateName] ~ = nil then
                    Logging.xmlError( self.xmlFile, "State '%s' already defined" , stateName, stateKey)
                    break
                end

                local stateClassName = self.xmlFile:getValue(stateKey .. "#class" , "" )
                local class = ClassUtil.getClassObject(stateClassName)
                if class = = nil then
                    Logging.xmlError( self.xmlFile, "State class '%s' at '%s' not defined" , stateClassName, stateKey)
                    break
                end

                if not class:isa(ConstructibleState) then
                    Logging.xmlError( self.xmlFile, "State class '%s' is not a ConstructibleState at '%s'" , stateClassName, stateKey)
                    break
                end

                if #dirtyFlags < maxNumDirtyFlags then
                    table.insert(dirtyFlags, self:getNextDirtyFlag())
                end

                local stateIndex = stateMachineNextIndex
                spec.stateNameToIndex[stateName] = stateIndex

                -- wrap around dirty flags to avoid using too many flags
                local dirtyFlagIndex = ((stateMachineNextIndex - 1 ) % maxNumDirtyFlags) + 1
                local dirtyFlag = dirtyFlags[dirtyFlagIndex]

                local state = class.new( self , dirtyFlag)
                state:load( self.xmlFile, stateKey)
                spec.stateMachine[stateIndex] = state
                spec.statesDirtyMask = bit32.bor(spec.statesDirtyMask, dirtyFlag) -- accumulate all flags from states to one mask

                if self.xmlFile:getValue(stateKey .. "#isStartState" ) then
                    spec.startStateIndex = stateIndex
                end

                if self.xmlFile:getValue(stateKey .. "#isPreviewState" ) then
                    spec.previewStateIndex = stateIndex
                end

                stateMachineNextIndex = stateMachineNextIndex + 1
            end

            for _, transitionKey in self.xmlFile:iterator( "placeable.constructible.stateMachine.transitions.transition" ) do
                local stateFromName = string.upper( self.xmlFile:getValue(transitionKey .. "#from" , "" ))
                local stateFromIndex = spec.stateNameToIndex[stateFromName]
                if stateFromIndex = = nil then
                    Logging.xmlError( self.xmlFile, "Invalid state.Transition from name '%s' not defined for '%s'" , stateFromName, transitionKey)
                        break
                    end

                    local stateToName = string.upper( self.xmlFile:getValue(transitionKey .. "#to" , "" ))
                    local stateToIndex = spec.stateNameToIndex[stateToName]
                    if stateToIndex = = nil then
                        Logging.xmlError( self.xmlFile, "Invalid state.Transition to name '%s' not defined for '%s'" , stateToName, transitionKey)
                            break
                        end

                        spec.stateTransitions[stateFromIndex] = stateToIndex
                    end

                    -- ensure setup state is applied in preview, e.g.that things are hidden
                    if self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
                        self:setConstructiblePreviewState()
                    end
                end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableConstructible:onReadStream(streamId, connection)
    local spec = self.spec_constructible

    -- unloading station
    local unloadingStationId = NetworkUtil.readNodeObjectId(streamId)
    spec.unloadingStation:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.unloadingStation, unloadingStationId)

    -- storage
    local storageId = NetworkUtil.readNodeObjectId(streamId)
    spec.storage:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.storage, storageId)

    -- state
    local stateIndex = streamReadUInt8(streamId)
    for i = 1 , stateIndex do
        self:setConstructibleState(i)
    end

    local state = spec.stateMachine[stateIndex]
    state:onReadStream(streamId, connection)
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function PlaceableConstructible:onWriteStream(streamId, connection)
    local spec = self.spec_constructible

    -- unloading station
    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.unloadingStation))
    spec.unloadingStation:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.unloadingStation)

    -- storage
    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.storage))
    spec.storage:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.storage)

    -- state
    streamWriteUInt8(streamId, spec.stateIndex)
    local state = spec.stateMachine[spec.stateIndex]
    state:onWriteStream(streamId, connection)
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
function PlaceableConstructible.prerequisitesPresent(specializations)
    return true
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
function PlaceableConstructible.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onInfoTriggerEnter" , PlaceableConstructible )
    SpecializationUtil.registerEventListener(placeableType, "onInfoTriggerLeave" , PlaceableConstructible )
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
function PlaceableConstructible.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "setConstructibleState" , PlaceableConstructible.setConstructibleState)
    SpecializationUtil.registerFunction(placeableType, "finalizeConstruction" , PlaceableConstructible.finalizeConstruction)
    SpecializationUtil.registerFunction(placeableType, "getConstructibleFillLevel" , PlaceableConstructible.getConstructibleFillLevel)
    SpecializationUtil.registerFunction(placeableType, "getConstructibleSupportsFillType" , PlaceableConstructible.getConstructibleSupportsFillType)
    SpecializationUtil.registerFunction(placeableType, "removeConstructibleFillLevel" , PlaceableConstructible.removeConstructibleFillLevel)
    SpecializationUtil.registerFunction(placeableType, "getConstructibleStateIndexByName" , PlaceableConstructible.getConstructibleStateIndexByName)
    SpecializationUtil.registerFunction(placeableType, "setConstructiblePreviewState" , PlaceableConstructible.setConstructiblePreviewState)
    SpecializationUtil.registerFunction(placeableType, "getConstructibleStateIndex" , PlaceableConstructible.getConstructibleStateIndex)
    SpecializationUtil.registerFunction(placeableType, "resetConstructibleToState" , PlaceableConstructible.resetConstructibleToState)
    SpecializationUtil.registerFunction(placeableType, "consoleCommandFinishConstructionState" , PlaceableConstructible.consoleCommandFinishConstructionState)
    SpecializationUtil.registerFunction(placeableType, "getNumFinishedConstructibleStates" , PlaceableConstructible.getNumFinishedConstructibleStates)
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
function PlaceableConstructible.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableConstructible.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableConstructible.updateInfo)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableConstructible.setOwnerFarmId)
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
function PlaceableConstructible.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. ".state#index" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".state#name" , "" )
    ConstructibleStateBuilding.registerSavegameXMLPaths(schema, basePath)
    Storage.registerSavegameXMLPaths(schema, basePath .. ".storage" )
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
function PlaceableConstructible.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Constructible" )

    schema:register(XMLValueType.STRING, basePath .. ".constructible.stateMachine.states.state(?)#name" , "State name" )
    schema:register(XMLValueType.STRING, basePath .. ".constructible.stateMachine.states.state(?)#class" , "State class" )
    schema:register(XMLValueType.BOOL, basePath .. ".constructible.stateMachine.states.state(?)#isStartState" , "Marks a state as starting state" )
    schema:register(XMLValueType.BOOL, basePath .. ".constructible.stateMachine.states.state(?)#isPreviewState" , "State is shown while placing the placeable or used in the icon generator" )
        ConstructibleState.registerXMLPaths(schema, basePath .. ".constructible.stateMachine.states.state(?)" )
        ConstructibleStateBuilding.registerXMLPaths(schema, basePath .. ".constructible.stateMachine.states.state(?)" )
        ConstructibleStateFinalize.registerXMLPaths(schema, basePath .. ".constructible.stateMachine.states.state(?)" )

        schema:register(XMLValueType.STRING, basePath .. ".constructible.stateMachine.transitions.transition(?)#from" , "State name from" )
        schema:register(XMLValueType.STRING, basePath .. ".constructible.stateMachine.transitions.transition(?)#to" , "State name to" )

        SellingStation.registerXMLPaths(schema, basePath .. ".constructible.sellingStation" )
        Storage.registerXMLPaths(schema, basePath .. ".constructible.storage" )

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
function PlaceableConstructible:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_constructible

    if spec.stateIndex ~ = nil and spec.stateIndex > 0 then
        local state = spec.stateMachine[spec.stateIndex]
        xmlFile:setValue(key .. ".state#name" , state.name)

        state:saveToXMLFile(xmlFile, key, usedModNames)
    end

    spec.storage:saveToXMLFile(xmlFile, key .. ".storage" )
end

```