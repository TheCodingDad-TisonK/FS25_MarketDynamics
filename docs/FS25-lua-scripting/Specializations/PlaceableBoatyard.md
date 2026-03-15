## PlaceableBoatyard

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [loadFromXMLFile](#loadfromxmlfile)
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
- [setOwnerFarmId](#setownerfarmid)

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
function PlaceableBoatyard:collectPickObjects(superFunc, node)
    local spec = self.spec_boatyard

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
function PlaceableBoatyard:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_boatyard

    local stateIndex = xmlFile:getValue(key .. ".state#index" ) or 0
    local splineTimeLoaded = xmlFile:getValue(key .. "#splineTime" )

    for i = 0 , stateIndex do
        self:setState(i)
    end
    if splineTimeLoaded ~ = nil then
        self:setSplineTime(splineTimeLoaded)
    end

    local state = spec.stateMachine[spec.stateIndex]
    state:loadFromXMLFile(xmlFile, key)

    spec.storage:loadFromXMLFile(xmlFile, key .. ".storage" )
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
function PlaceableBoatyard:onLoad(savegame)
    local spec = self.spec_boatyard

    local key = "placeable.boatyard"

    spec.spline = self.xmlFile:getValue(key .. "#spline" , nil , self.components, self.i3dMappings)
    spec.splineLength = getSplineLength(spec.spline)
    spec.splineTime = 0
    spec.splineTimeInterpolator = InterpolationTime.new( 1.2 )
    spec.splineInterpolator = InterpolatorValue.new( 0 )
    spec.splineTimeDirtyFlag = self:getNextDirtyFlag()
    spec.splineTimeChanged = false

    spec.boatLinkNode = self.xmlFile:getValue(key .. "#linkNode" , nil , self.components, self.i3dMappings)
    link(getRootNode(), spec.boatLinkNode) -- link to root flat hierarchy -> best performance

    local boatI3DFilename = self.xmlFile:getValue(key .. ".boat#filename" )
    boatI3DFilename = Utils.getFilename(boatI3DFilename, self.baseDirectory)
    spec.boatLaunchReward = self.xmlFile:getValue(key .. ".boat#reward" , 100000 )

    spec.idToMesh = { }
    spec.meshes = { }

    local arguments = {
    loadingTask = self:createLoadingTask(spec),
    }

    spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(boatI3DFilename, true , false , self.onBoatI3DFileLoaded, self , arguments)

    spec.unloadingStation = SellingStation.new( self.isServer, self.isClient)
    spec.unloadingStation:load( self.components, self.xmlFile, key .. ".sellingStation" , self.customEnvironment, self.i3dMappings, self.components[ 1 ].node)
    spec.unloadingStation.owningPlaceable = self

    spec.unloadingStation.getStoreGoods = function (_, farmId, fillTypeIndex)
        return true
    end
    spec.unloadingStation.getSkipSell = function (_, farmId, fillTypeIndex)
        return self:getOwnerFarmId() ~ = AccessHandler.EVERYONE
    end
    spec.unloadingStation.getIsFillAllowedFromFarm = function (_, farmId)
        return true
    end

    spec.unloadingStation:register( true )

    spec.storage = Storage.new( self.isServer, self.isClient)
    spec.storage:load( self.components, self.xmlFile, key .. ".storage" , self.i3dMappings, self.baseDirectory)
    spec.storage:register( true )
    spec.storage:addFillLevelChangedListeners( function () self:raiseActive() end ) -- trigger update loop after storage was changed
    spec.fillTypesAndLevelsAuxiliary = { }
    spec.fillTypeToFillTypeStorageTable = { }
    spec.infoTriggerFillTypesAndLevels = { }
    spec.infoTableEntryStorage = { title = g_i18n:getText( "statistic_storage" ), accentuate = true }

    spec.unloadingStation:addTargetStorage(spec.storage)

    spec.playerTrigger = self.xmlFile:getValue(key .. "#playerTrigger" , nil , self.components, self.i3dMappings)
    if spec.playerTrigger ~ = nil then
        addTrigger(spec.playerTrigger, "playerTriggerCallback" , self )
    end
    spec.activatable = BoatyardActivatable.new( self )

    spec.stateMachine = { }
    spec.stateNameToIndex = { }
    spec.stateTransitions = { }
    spec.stateIndex = - 1
    spec.stateMachineNextIndex = 0
    spec.statesDirtyMask = 0 -- dirty mask for all state dirty flags to easily check if a state needs updating
        local maxNumStates = ( 2 ^ 8 ) - 1

        local stateMachineXmlKey = "placeable.boatyard.stateMachine"
        for _, stateKey in self.xmlFile:iterator(stateMachineXmlKey .. ".states.state" ) do
            if spec.stateMachineNextIndex > maxNumStates then
                Logging.xmlWarning( self.xmlFile, "Maximum number of states reached(%d)" , maxNumStates)
                break
            end

            local stateName = self.xmlFile:getValue(stateKey .. "#name" , "" ):upper()
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

            local stateIndex = spec.stateMachineNextIndex
            spec.stateNameToIndex[stateName] = stateIndex
            local state = class.new( self )
            state:load( self.xmlFile, stateKey)
            spec.stateMachine[stateIndex] = state
            spec.statesDirtyMask = spec.statesDirtyMask + state.dirtyFlag -- accumulate all flags from states to one mask

            spec.stateMachineNextIndex = spec.stateMachineNextIndex + 1
        end

        for _, transitionKey in self.xmlFile:iterator(stateMachineXmlKey .. ".transitions.transition" ) do
            local stateFromName = self.xmlFile:getValue(transitionKey .. "#from" , "" ):upper()
            local stateFromIndex = spec.stateNameToIndex[stateFromName]
            if stateFromIndex = = nil then
                Logging.xmlError( self.xmlFile, "Invalid state.Transition from name '%s' not defined for '%s'" , stateFromName, transitionKey)
                    break
                end

                local stateToName = self.xmlFile:getValue(transitionKey .. "#to" , "" ):upper()
                local stateToIndex = spec.stateNameToIndex[stateToName]
                if stateToIndex = = nil then
                    Logging.xmlError( self.xmlFile, "Invalid state.Transition to name '%s' not defined for '%s'" , stateToName, transitionKey)
                        break
                    end

                    spec.stateTransitions[stateFromIndex] = stateToIndex
                end

                spec.sailingSplines = { }
                spec.boatBobbingFreq = self.xmlFile:getValue(key .. ".sailingSplines#bobbingFreq" , 1 ) / 1000 / math.pi
                spec.boatBobbingAmount = self.xmlFile:getValue(key .. ".sailingSplines#bobbingAmount" , 0.05 )
                spec.boatSwayingFreq = self.xmlFile:getValue(key .. ".sailingSplines#swayingFreq" , 0.8 ) / 1000 / math.pi
                spec.boatSwayingAmount = self.xmlFile:getValue(key .. ".sailingSplines#swayingAmount" , 0.025 )

                for _, sailingSplineKey in self.xmlFile:iterator(key .. ".sailingSplines.spline" ) do
                    local sailingSpline = self.xmlFile:getValue(sailingSplineKey .. "#node" , nil , self.components, self.i3dMappings)
                    local splineLength = getSplineLength(sailingSpline)

                    table.insert(spec.sailingSplines, {
                    node = sailingSpline,
                    length = splineLength,
                    } )
                end

                spec.nextSailingSplineIndex = math.random( 1 , #spec.sailingSplines)

                spec.boatsSailingLinkNode = createTransformGroup( "sailingBoatsLinkNode" )
                link(getRootNode(), spec.boatsSailingLinkNode)

                spec.boatsSailing = { }
                spec.sailingAcc = 0.2
                spec.windSpeed = 1
                g_currentMission.environment.weather.windUpdater:addWindChangedListener( self )
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
function PlaceableBoatyard:onReadStream(streamId, connection)
    local spec = self.spec_boatyard

    -- unloading station
    local unloadingStationId = NetworkUtil.readNodeObjectId(streamId)
    spec.unloadingStation:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.unloadingStation, unloadingStationId)

    -- storage
    local storageId = NetworkUtil.readNodeObjectId(streamId)
    spec.storage:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.storage, storageId)

    local stateIndex = streamReadUInt8(streamId)

    for i = 0 , stateIndex do
        self:setState(i)
    end

    local state = spec.stateMachine[stateIndex]
    state:onReadStream(streamId, connection)

    local splineTime = streamReadFloat32(streamId)
    spec.splineTimeChanged = true
    spec.splineInterpolator:setValue(splineTime)
    spec.splineTimeInterpolator:reset()

    for meshIndex, mesh in ipairs(spec.meshes) do
        local hideByIndexValue = streamReadUIntN(streamId, mesh.numBits)
        local progress = MathUtil.inverseLerp(mesh.indexMax, mesh.indexMin, hideByIndexValue)
        self:setMeshProgress(mesh.id, progress)
    end

    spec.nextSailingSplineIndex = streamReadUInt8(streamId)
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
function PlaceableBoatyard:onWriteStream(streamId, connection)
    local spec = self.spec_boatyard

    -- unloading station
    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.unloadingStation))
    spec.unloadingStation:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.unloadingStation)

    -- storage
    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.storage))
    spec.storage:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.storage)

    streamWriteUInt8(streamId, spec.stateIndex)

    local state = spec.stateMachine[spec.stateIndex]
    state:onWriteStream(streamId, connection)

    streamWriteFloat32(streamId, spec.splineTime)

    for meshIndex, mesh in ipairs(spec.meshes) do
        streamWriteUIntN(streamId, mesh.lastValue, mesh.numBits)
    end

    streamWriteUInt8(streamId, spec.nextSailingSplineIndex)
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
function PlaceableBoatyard.prerequisitesPresent(specializations)
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
function PlaceableBoatyard.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableBoatyard )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableBoatyard )
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
function PlaceableBoatyard.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onBoatI3DFileLoaded" , PlaceableBoatyard.onBoatI3DFileLoaded)
    SpecializationUtil.registerFunction(placeableType, "setMeshProgress" , PlaceableBoatyard.setMeshProgress)
    SpecializationUtil.registerFunction(placeableType, "setState" , PlaceableBoatyard.setState)
    SpecializationUtil.registerFunction(placeableType, "setSplineTime" , PlaceableBoatyard.setSplineTime)
    SpecializationUtil.registerFunction(placeableType, "addSplineDistanceDelta" , PlaceableBoatyard.addSplineDistanceDelta)
    SpecializationUtil.registerFunction(placeableType, "getSplineTime" , PlaceableBoatyard.getSplineTime)
    SpecializationUtil.registerFunction(placeableType, "releaseBoat" , PlaceableBoatyard.releaseBoat)
    SpecializationUtil.registerFunction(placeableType, "createBoat" , PlaceableBoatyard.createBoat)
    SpecializationUtil.registerFunction(placeableType, "setWindValues" , PlaceableBoatyard.setWindValues)
    SpecializationUtil.registerFunction(placeableType, "getFillLevel" , PlaceableBoatyard.getFillLevel)
    SpecializationUtil.registerFunction(placeableType, "removeFillLevel" , PlaceableBoatyard.removeFillLevel)
    SpecializationUtil.registerFunction(placeableType, "playerTriggerCallback" , PlaceableBoatyard.playerTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "buyRequest" , PlaceableBoatyard.buyRequest)
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
function PlaceableBoatyard.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableBoatyard.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableBoatyard.updateInfo)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableBoatyard.setOwnerFarmId)
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
function PlaceableBoatyard.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. ".state#index" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. "#splineTime" , "" )

    BoatyardStateBuilding.registerSavegameXMLPaths(schema, basePath)

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
function PlaceableBoatyard.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Boatyard" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".boatyard#spline" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".boatyard#linkNode" , "" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".boatyard#playerTrigger" , "" )

    schema:register(XMLValueType.STRING, basePath .. ".boatyard.boat#filename" , "" )
    schema:register(XMLValueType.INT, basePath .. ".boatyard.boat#reward" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".boatyard.boat.progressiveVisibilityMesh.mesh(?)#node" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".boatyard.boat.progressiveVisibilityMesh.mesh(?)#id" , "" )
    schema:register(XMLValueType.INT, basePath .. ".boatyard.boat.progressiveVisibilityMesh.mesh(?)#indexMin" , "" )
    schema:register(XMLValueType.INT, basePath .. ".boatyard.boat.progressiveVisibilityMesh.mesh(?)#indexMax" , "" )

    schema:register(XMLValueType.STRING, basePath .. ".boatyard.stateMachine.states.state(?)#name" , "State name" )
    schema:register(XMLValueType.STRING, basePath .. ".boatyard.stateMachine.states.state(?)#class" , "State class" )
    BoatyardState.registerXMLPaths(schema, basePath .. ".boatyard.stateMachine.states.state(?)" )
    BoatyardStateMoving.registerXMLPaths(schema, basePath .. ".boatyard.stateMachine.states.state(?)" )
    BoatyardStateBuilding.registerXMLPaths(schema, basePath .. ".boatyard.stateMachine.states.state(?)" )
    BoatyardStateLaunching.registerXMLPaths(schema, basePath .. ".boatyard.stateMachine.states.state(?)" )

    schema:register(XMLValueType.STRING, basePath .. ".boatyard.stateMachine.transitions.transition(?)#from" , "State name from" )
    schema:register(XMLValueType.STRING, basePath .. ".boatyard.stateMachine.transitions.transition(?)#to" , "State name to" )

    schema:register(XMLValueType.FLOAT, basePath .. ".boatyard.sailingSplines#bobbingFreq" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".boatyard.sailingSplines#bobbingAmount" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".boatyard.sailingSplines#swayingFreq" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".boatyard.sailingSplines#swayingAmount" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".boatyard.sailingSplines.spline(?)#node" , "" )

    SellingStation.registerXMLPaths(schema, basePath .. ".boatyard.sellingStation" )
    Storage.registerXMLPaths(schema , basePath .. ".boatyard.storage" )

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
function PlaceableBoatyard:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_boatyard

    if spec.stateIndex > 0 then
        xmlFile:setValue(key .. ".state#index" , spec.stateIndex)
        xmlFile:setValue(key .. "#splineTime" , spec.splineTime)

        local state = spec.stateMachine[spec.stateIndex]

        state:saveToXMLFile(xmlFile, key, usedModNames)
    end

    spec.storage:saveToXMLFile(xmlFile, key .. ".storage" )
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | farmId    |

**Code**

```lua
function PlaceableBoatyard:setOwnerFarmId(superFunc, farmId)
    superFunc( self , farmId)

    local spec = self.spec_boatyard

    if spec.unloadingStation ~ = nil then
        -- remove from selling station overview if owned, as it does not generate revenue upon deliver anymore
            if farmId = = AccessHandler.EVERYONE then
                g_currentMission.storageSystem:addUnloadingStation(spec.unloadingStation, self )
                g_currentMission.economyManager:addSellingStation(spec.unloadingStation)
            else
                    g_currentMission.economyManager:removeSellingStation(spec.unloadingStation)
                    g_currentMission.storageSystem:removeUnloadingStation(spec.unloadingStation, self )
                end
            end

            if spec.playerTrigger ~ = nil then
                setVisibility(spec.playerTrigger, farmId = = AccessHandler.EVERYONE) -- or farmId = = g_currentMission:getFarmId()
            end
        end

```