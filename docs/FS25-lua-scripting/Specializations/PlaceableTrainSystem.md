## PlaceableTrainSystem

**Description**

> Specialization for placeables

**Functions**

- [addSplinePositionUpdateListener](#addsplinepositionupdatelistener)
- [createVehicles](#createvehicles)
- [finalizeTrain](#finalizetrain)
- [getCanBeRented](#getcanberented)
- [getElectricitySpline](#getelectricityspline)
- [getElectricitySplineLength](#getelectricitysplinelength)
- [getIsRented](#getisrented)
- [getIsTrainInDriveableRange](#getistrainindriveablerange)
- [getLengthSplineTime](#getlengthsplinetime)
- [getNeedDayChanged](#getneeddaychanged)
- [getSpline](#getspline)
- [getSplineLength](#getsplinelength)
- [getSplineTime](#getsplinetime)
- [gsIsTrainFilled](#gsistrainfilled)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDayChanged](#ondaychanged)
- [onDelete](#ondelete)
- [onDeleteObject](#ondeleteobject)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onSellGoodsQuestion](#onsellgoodsquestion)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [railroadVehicleLoaded](#railroadvehicleloaded)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [removeSplinePositionUpdateListener](#removesplinepositionupdatelistener)
- [rentRailroad](#rentrailroad)
- [returnRailroad](#returnrailroad)
- [saveToXMLFile](#savetoxmlfile)
- [sellGoods](#sellgoods)
- [setIsTrainTabbable](#setistraintabbable)
- [setSplineTime](#setsplinetime)
- [toggleRent](#togglerent)
- [updateDriveableState](#updatedriveablestate)
- [updateRailroadVehiclePositions](#updaterailroadvehiclepositions)
- [updateTrainLength](#updatetrainlength)
- [updateTrainPositionByLocomotiveSpeed](#updatetrainpositionbylocomotivespeed)
- [updateTrainPositionByLocomotiveSplinePosition](#updatetrainpositionbylocomotivesplineposition)

### addSplinePositionUpdateListener

**Description**

**Definition**

> addSplinePositionUpdateListener()

**Arguments**

| any | listener |
|-----|----------|

**Code**

```lua
function PlaceableTrainSystem:addSplinePositionUpdateListener(listener)
    if listener ~ = nil then
        local spec = self.spec_trainSystem
        table.addElement(spec.splinePositionUpdateListener, listener)
    end
end

```

### createVehicles

**Description**

**Definition**

> createVehicles()

**Code**

```lua
function PlaceableTrainSystem:createVehicles()
    local spec = self.spec_trainSystem
    if spec.vehicleIdsToLoad ~ = nil and #spec.vehicleIdsToLoad > 0 then
        for k, uniqueId in ipairs(spec.vehicleIdsToLoad) do
            local vehicle = g_currentMission.vehicleSystem:getVehicleByUniqueId(uniqueId)
            if vehicle ~ = nil then
                if vehicle.setTrainSystem = = nil then
                    --#debug Logging.devWarning("Vehicle '%s' (savegameId %d) is not a railroad vehicle", vehicle:getName(), uniqueId)
                    --#debug printCallstack()
                else
                        vehicle:setTrainSystem( self )
                        vehicle.trainVehicleIndex = k
                        table.insert(spec.railroadVehicles, vehicle)
                    end
                end
            end

            self:finalizeTrain( false )
        else
                for k, filename in ipairs(spec.vehiclesToLoad) do
                    filename = Utils.getFilename(filename, spec.baseDirectory)
                    spec.numVehiclesToLoad = spec.numVehiclesToLoad + 1

                    local arguments = {
                    filename = filename,
                    vehicleIndex = k
                    }

                    local data = VehicleLoadingData.new()
                    data:setFilename(filename)
                    data:setPropertyState(VehiclePropertyState.NONE)
                    data:setOwnerFarmId(AccessHandler.EVERYONE)

                    data:load(spec.railroadVehicleLoaded, self , arguments)
                end

            end
            spec.vehiclesToLoad = { }
        end

```

### finalizeTrain

**Description**

**Definition**

> finalizeTrain()

**Arguments**

| any | attachVehicles |
|-----|----------------|

**Code**

```lua
function PlaceableTrainSystem:finalizeTrain(attachVehicles)
    if self:getIsBeingDeleted() then
        return
    end

    local spec = self.spec_trainSystem

    table.sort(spec.railroadVehicles, function (a, b)
        return a.trainVehicleIndex < b.trainVehicleIndex
    end )

    local lastVehicle = nil
    spec.rootLocomotive = nil
    for _,railroadVehicle in ipairs(spec.railroadVehicles) do
        if not railroadVehicle:getIsBeingDeleted() then
            railroadVehicle:addDeleteListener( self )

            if spec.rootLocomotive = = nil and railroadVehicle.startAutomatedTrainTravel ~ = nil then
                spec.rootLocomotive = railroadVehicle
            end

            if attachVehicles and lastVehicle ~ = nil then
                lastVehicle:attachImplement(railroadVehicle, 1 , 1 , true )
            end

            lastVehicle = railroadVehicle
        end
    end

    self:updateTrainLength(spec.startSplineTime)
    self:setIsTrainTabbable(spec.isRented and g_currentMission:getFarmId() = = spec.rentFarmId)
end

```

### getCanBeRented

**Description**

**Definition**

> getCanBeRented()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function PlaceableTrainSystem:getCanBeRented(farmId)
    local spec = self.spec_trainSystem

    if spec.isRented then
        if spec.rentFarmId ~ = farmId then
            return false
        end
    end

    return true
end

```

### getElectricitySpline

**Description**

**Definition**

> getElectricitySpline()

**Code**

```lua
function PlaceableTrainSystem:getElectricitySpline()
    local spec = self.spec_trainSystem
    return spec.electricitySpline
end

```

### getElectricitySplineLength

**Description**

**Definition**

> getElectricitySplineLength()

**Code**

```lua
function PlaceableTrainSystem:getElectricitySplineLength()
    local spec = self.spec_trainSystem
    return spec.electricitySplineLength or 0
end

```

### getIsRented

**Description**

**Definition**

> getIsRented()

**Code**

```lua
function PlaceableTrainSystem:getIsRented()
    local spec = self.spec_trainSystem
    return spec.isRented
end

```

### getIsTrainInDriveableRange

**Description**

**Definition**

> getIsTrainInDriveableRange()

**Code**

```lua
function PlaceableTrainSystem:getIsTrainInDriveableRange()
    return self.spec_trainSystem.lastIsInDriveableRange
end

```

### getLengthSplineTime

**Description**

**Definition**

> getLengthSplineTime()

**Code**

```lua
function PlaceableTrainSystem:getLengthSplineTime()
    local spec = self.spec_trainSystem
    return spec.trainLengthSplineTime
end

```

### getNeedDayChanged

**Description**

**Definition**

> getNeedDayChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableTrainSystem:getNeedDayChanged(superFunc)
    return true
end

```

### getSpline

**Description**

**Definition**

> getSpline()

**Code**

```lua
function PlaceableTrainSystem:getSpline()
    local spec = self.spec_trainSystem
    return spec.spline
end

```

### getSplineLength

**Description**

**Definition**

> getSplineLength()

**Code**

```lua
function PlaceableTrainSystem:getSplineLength()
    local spec = self.spec_trainSystem
    return spec.splineLength
end

```

### getSplineTime

**Description**

**Definition**

> getSplineTime()

**Code**

```lua
function PlaceableTrainSystem:getSplineTime()
    return self.spec_trainSystem.splineTime
end

```

### gsIsTrainFilled

**Description**

**Definition**

> gsIsTrainFilled()

**Code**

```lua
function PlaceableTrainSystem:gsIsTrainFilled()
    local spec = self.spec_trainSystem
    for _,railroadVehicle2 in ipairs(spec.railroadVehicles) do
        if railroadVehicle2.getFillUnits ~ = nil then
            local fillUnits = railroadVehicle2:getFillUnits()
            for fillUnitIndex, fillUnit in ipairs(fillUnits) do
                if fillUnit.fillLevel > 0 then
                    return true
                end
            end
        end
    end

    return false
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
function PlaceableTrainSystem:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_trainSystem

    for _, railroadKey in xmlFile:iterator(key .. ".railroadObjects" ) do
        local index = xmlFile:getValue(railroadKey .. "#index" )
        if index ~ = nil then
            local object = spec.railroadObjects[index]
            if object ~ = nil then
                object:loadFromXMLFile(xmlFile, railroadKey)
            end
        end
    end

    spec.isRented = xmlFile:getValue(key .. "#isRented" , spec.isRented)
    spec.rentFarmId = xmlFile:getValue(key .. "#rentFarmId" , spec.rentFarmId)
    spec.lastRentFarmId = spec.rentFarmId
    spec.currentPrice = xmlFile:getValue(key .. "#currentPrice" , spec.currentPrice)

    spec.startSplineTime = SplineUtil.getValidSplineTime(xmlFile:getValue(key .. "#splineTime" ) or 0 )

    spec.vehicleIdsToLoad = { }
    for _, vehicleKey in xmlFile:iterator(key .. ".railroadVehicle" ) do
        local vehicleUniqueId = xmlFile:getValue(vehicleKey .. "#vehicleUniqueId" )
        if vehicleUniqueId ~ = nil then
            table.insert(spec.vehicleIdsToLoad, vehicleUniqueId)
        end
    end
end

```

### onDayChanged

**Description**

**Definition**

> onDayChanged()

**Code**

```lua
function PlaceableTrainSystem:onDayChanged()
    if self.isServer then
        local spec = self.spec_trainSystem
        if spec.currentPrice > 0 then
            g_currentMission:addMoney( - spec.currentPrice, spec.rentFarmId, MoneyType.LEASING_COSTS, true )
            g_currentMission:showMoneyChange(MoneyType.LEASING_COSTS, nil , false , spec.rentFarmId)
            spec.currentPrice = 0
        end
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableTrainSystem:onDelete()
    local spec = self.spec_trainSystem

    if spec.railroadObjects ~ = nil then
        for _, object in ipairs(spec.railroadObjects) do
            object:delete()
        end
    end

    if spec.railroadVehicles ~ = nil then
        for _, vehicle in ipairs(spec.railroadVehicles) do
            vehicle.trainSystem = nil
        end
    end

    g_currentMission:removeTrainSystem( self )
end

```

### onDeleteObject

**Description**

**Definition**

> onDeleteObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function PlaceableTrainSystem:onDeleteObject(object)
    local spec = self.spec_trainSystem
    if table.removeElement(spec.railroadVehicles, object) then
        self:updateTrainLength(spec.splineTime)
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableTrainSystem:onFinalizePlacement()
    local spec = self.spec_trainSystem

    if spec.railroadCrossings ~ = nil then
        for _, railroadCrossing in ipairs(spec.railroadCrossings) do
            railroadCrossing:findBlockingPositions()
        end
    end

    for _, object in ipairs(spec.railroadObjects) do
        if object.setSplineTimeByPosition ~ = nil then
            object:setSplineTimeByPosition(object.nearestTime, spec.splineLength)
        end
        if object.onSplinePositionTimeUpdate ~ = nil then
            object:onSplinePositionTimeUpdate(spec.splineTime, spec.splineEndTime)
        end
    end

    g_currentMission:addTrainSystem( self )

    if g_currentMission.isMissionStarted then
        self:createVehicles()
    else
            g_messageCenter:subscribeOneshot(MessageType.CURRENT_MISSION_START, PlaceableTrainSystem.createVehicles, self )
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
function PlaceableTrainSystem:onLoad(savegame)
    local spec = self.spec_trainSystem

    spec.lastUpdateLoopIndex = - 1
    spec.splineTime = - 1
    spec.splineTimeSent = spec.splineTime
    spec.splineEndTime = 0
    spec.trainLengthSplineTime = 0
    spec.splinePositionUpdateListener = { }
    spec.startSplineTime = spec.startSplineTime or 0
    spec.railroadVehicles = { }
    spec.trainLength = 0
    spec.x, spec.y, spec.z = 0 , 0 , 0

    spec.splinePositionSpeedReal = 0
    spec.splinePositionSpeed = 0
    spec.firstUpdate = true

    spec.dirtyFlag = self:getNextDirtyFlag()
    spec.stationDirtyFlag = self:getNextDirtyFlag()
    spec.networkTimeInterpolator = InterpolationTime.new( 1.2 )
    spec.networkSplineTimeInterpolator = InterpolatorValue.new( 0 )

    spec.isRented = false
    spec.rentFarmId = FarmManager.SPECTATOR_FARM_ID
    spec.lastRentFarmId = FarmManager.SPECTATOR_FARM_ID
    spec.currentPrice = 0
    spec.rentPricePerHour = self.xmlFile:getValue( "placeable.trainSystem.rent#pricePerHour" , 0 )
    spec.rentPricePerMS = spec.rentPricePerHour / 60 / 60 / 1000

    spec.rootLocomotive = nil

    spec.spline = self.xmlFile:getValue( "placeable.trainSystem.spline#node" , nil , self.components, self.i3dMappings)
    if spec.spline = = nil then
        Logging.xmlError( self.xmlFile, "Missing spline node!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    if not getHasClassId(getGeometry(spec.spline), ClassIds.SPLINE) then
        Logging.xmlError( self.xmlFile, "Given node is not a spline!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    if not getIsSplineClosed(spec.spline) then
        Logging.xmlError( self.xmlFile, "Train spline is not closed.Open splines are not supported!" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    spec.splineLength = getSplineLength(spec.spline)
    spec.splineYOffset = self.xmlFile:getValue( "placeable.trainSystem.spline#splineYOffset" , 0.0 )

    spec.splineDriveRange = { 0 , 1 }

    spec.drivingRangeStart = self.xmlFile:getValue( "placeable.trainSystem.drivingRange#startNode" , nil , self.components, self.i3dMappings)
    spec.drivingRangeEnd = self.xmlFile:getValue( "placeable.trainSystem.drivingRange#endNode" , nil , self.components, self.i3dMappings)
    spec.drivingRangeSellingStationId = self.xmlFile:getValue( "placeable.trainSystem.drivingRange#sellingStationId" )

    spec.textDriveInfo = g_i18n:getText( "ui_infoTrainDrive" )
    spec.textSellQuestion = g_i18n:getText( "ui_questionTrainSellGoods" )

    spec.hasLimitedRange = false
    if spec.drivingRangeStart ~ = nil and spec.drivingRangeEnd ~ = nil then
        local nearestDistanceStart = math.huge
        local nearestDistanceEnd = math.huge

        local x1, y1, z1 = getWorldTranslation(spec.drivingRangeStart)
        local x2, y2, z2 = getWorldTranslation(spec.drivingRangeEnd)

        for i = 0 , 1 , 0.5 / spec.splineLength do
            local sx, sy, sz = getSplinePosition(spec.spline, i)

            local distance1 = MathUtil.vector3Length(sx - x1, sy - y1, sz - z1)
            if distance1 < nearestDistanceStart then
                nearestDistanceStart = distance1
                spec.splineDriveRange[ 1 ] = i
            end

            local distance2 = MathUtil.vector3Length(sx - x2, sy - y2, sz - z2)
            if distance2 < nearestDistanceEnd then
                nearestDistanceEnd = distance2
                spec.splineDriveRange[ 2 ] = i
            end
        end

        if spec.splineDriveRange[ 1 ] > spec.splineDriveRange[ 2 ] then
            local secondValue = spec.splineDriveRange[ 2 ]
            spec.splineDriveRange[ 2 ] = spec.splineDriveRange[ 1 ]
            spec.splineDriveRange[ 1 ] = secondValue
        end

        spec.hasLimitedRange = true
    end

    spec.sellingStationPlaceable = nil
    spec.sellingStationPlaceableId = nil
    spec.sellingStation = nil
    spec.showDialog = 0
    spec.showDialogDelay = 0

    spec.lastIsInDriveableRange = true
    spec.lastSplineTime = 0

    spec.electricitySpline = self.xmlFile:getValue( "placeable.trainSystem.electricitySpline#node" , nil , self.components, self.i3dMappings)
    if spec.electricitySpline ~ = nil then
        if getHasClassId(getGeometry(spec.electricitySpline), ClassIds.SPLINE) then
            if getIsSplineClosed(spec.electricitySpline) then
                local sx, _, sz = getSplinePosition(spec.spline, 0 )
                local esx, _, esz = getSplinePosition(spec.spline, 0 )
                if MathUtil.vector2Length(sx - esx, sz - esz) < 5 then
                    spec.electricitySplineLength = getSplineLength(spec.electricitySpline)
                    spec.electricitySplineYOffset = self.xmlFile:getValue( "placeable.trainSystem.electricitySpline#splineYOffset" , 0.0 )
                else
                        Logging.xmlError( self.xmlFile, "Railroad and electricity spline should almost start at the same x and z positions.Ignoring electricity spline!" )
                        spec.electricitySpline = nil
                    end
                else
                        Logging.xmlError( self.xmlFile, "Railroad electricity spline has to be closed.Ignoring electricity spline!" )
                        spec.electricitySpline = nil
                    end
                else
                        Logging.xmlError( self.xmlFile, "Given electricitySpline node is not a spline.Ignoring electricity spline!" )
                        spec.electricitySpline = nil
                    end
                end

                spec.vehiclesToLoad = { }

                if self.isServer then
                    for _, baseString in self.xmlFile:iterator( "placeable.trainSystem.train.vehicle" ) do
                        local filename = self.xmlFile:getValue(baseString .. "#xmlFilename" )
                        if filename ~ = nil then
                            table.insert(spec.vehiclesToLoad, filename)
                        end
                    end
                end

                spec.railroadObjects = { }
                spec.railroadCrossings = { }
                for _, key in self.xmlFile:iterator( "placeable.trainSystem.railroadCrossings.railroadCrossing" ) do
                    local railroadCrossing = RailroadCrossing.new( self.isServer, self.isClient, self , self.rootNode)
                    if railroadCrossing:loadFromXML( self.xmlFile, key, self.components, self.i3dMappings) then
                        table.insert(spec.railroadCrossings, railroadCrossing)
                        table.insert(spec.railroadObjects, railroadCrossing)
                    else
                            railroadCrossing:delete()
                        end
                    end

                    spec.railroadCallers = { }
                    for _, key in self.xmlFile:iterator( "placeable.trainSystem.railroadCallers.railroadCaller" ) do
                        local railroadCaller = RailroadCaller.new( self.isServer, self.isClient, self , self.rootNode)
                        if railroadCaller:loadFromXML( self.xmlFile, key, self.components, self.i3dMappings) then
                            table.insert(spec.railroadCallers, railroadCaller)
                            table.insert(spec.railroadObjects, railroadCaller)
                        end
                    end

                    for t = 0 , 1 , 0.5 / spec.splineLength do
                        local x1, y1, z1 = getSplinePosition(spec.spline, t)
                        for _, object in ipairs(spec.railroadObjects) do
                            local x2, y2, z2 = getWorldTranslation(object.rootNode)
                            local distance = MathUtil.vector3Length(x1 - x2, y1 - y2, z1 - z2)
                            if object.nearestDistance = = nil then
                                object.nearestDistance = distance
                                object.nearestTime = t
                            else
                                    if object.nearestDistance > distance then
                                        object.nearestDistance = distance
                                        object.nearestTime = t
                                    end
                                end
                            end
                        end

                        spec.railroadVehiclesEndTimes = { }
                        spec.railroadVehicleUpdateIndex = 0

                        spec.lastVehicle = nil
                        spec.numVehiclesToLoad = 0
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
function PlaceableTrainSystem:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_trainSystem
        spec.railroadVehicleIds = { }
        local numVehicles = streamReadInt8(streamId)
        for i = 1 ,numVehicles do
            spec.railroadVehicleIds[i] = NetworkUtil.readNodeObjectId(streamId)
        end

        local splineTime = streamReadFloat32(streamId)
        spec.networkSplineTimeInterpolator:setValue(splineTime)
        spec.networkTimeInterpolator:reset()
        spec.splineTime = splineTime

        for _, railroadObject in ipairs(spec.railroadObjects) do
            if railroadObject.readStream ~ = nil then
                railroadObject:readStream(streamId, connection)
            end
        end

        spec.isRented = streamReadBool(streamId)
        spec.rentFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

        spec.sellingStationPlaceableId = NetworkUtil.readNodeObjectId(streamId)

        self:raiseActive()
    end
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function PlaceableTrainSystem:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_trainSystem
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local splineTime = streamReadFloat32(streamId)
            spec.networkTimeInterpolator:startNewPhaseNetwork()
            spec.networkSplineTimeInterpolator:setTargetValue(splineTime)

            for _, railroadObject in ipairs(spec.railroadObjects) do
                if railroadObject.readUpdateStream ~ = nil then
                    railroadObject:readUpdateStream(streamId, timestamp, connection)
                end
            end
        end

        if streamReadBool(streamId) then
            spec.sellingStationPlaceableId = NetworkUtil.readNodeObjectId(streamId)
        end
    end
end

```

### onSellGoodsQuestion

**Description**

**Definition**

> onSellGoodsQuestion()

**Arguments**

| any | yes |
|-----|-----|

**Code**

```lua
function PlaceableTrainSystem:onSellGoodsQuestion(yes)
    if yes then
        g_client:getServerConnection():sendEvent( PlaceableTrainSystemSellEvent.new( self ))
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PlaceableTrainSystem:onUpdate(dt)
    local spec = self.spec_trainSystem

    if not self.finishedFirstUpdate then
        self:setIsTrainTabbable(spec.isRented and g_currentMission:getFarmId() = = spec.rentFarmId)

        self.finishedFirstUpdate = true
    end

    if self.isClient then
        spec.splinePositionSpeed = spec.splinePositionSpeed * 0.975 + spec.splinePositionSpeedReal * 0.025
    end

    --#profile RemoteProfiler.zoneBeginN("PlaceableTrainSystem-updateObjects")
    for _, railroadObject in ipairs(spec.railroadObjects) do
        if railroadObject.update ~ = nil then
            railroadObject:update(dt)
        end
    end
    --#profile RemoteProfiler.zoneEnd()

    if spec.isRented then
        spec.currentPrice = spec.currentPrice + spec.rentPricePerMS * dt
    end

    if not self.isServer and self.isClient then
        -- load railroadVehicles on client side
        if spec.railroadVehicleIds ~ = nil then
            local allVehiclesSynchronized = true
            for index, id in pairs(spec.railroadVehicleIds) do
                local vehicle = NetworkUtil.getObject(id)
                if vehicle = = nil or not vehicle:getIsSynchronized() then
                    allVehiclesSynchronized = false
                end
            end

            if allVehiclesSynchronized then
                spec.rootLocomotive = nil

                for index, id in pairs(spec.railroadVehicleIds) do
                    local vehicle = NetworkUtil.getObject(id)
                    if vehicle ~ = nil then
                        vehicle:setTrainSystem( self )
                        spec.trainLength = spec.trainLength + vehicle:getFrontToBackDistance()
                        spec.trainLengthSplineTime = spec.trainLength / spec.splineLength
                        table.insert(spec.railroadVehicles, index, vehicle)

                        if spec.rootLocomotive = = nil and vehicle.startAutomatedTrainTravel ~ = nil then
                            spec.rootLocomotive = vehicle
                        end
                    end
                    spec.railroadVehicleIds[index] = nil
                end
                if next(spec.railroadVehicleIds) = = nil then
                    spec.railroadVehicleIds = nil
                    self:setIsTrainTabbable(spec.isRented and g_currentMission:getFarmId() = = spec.rentFarmId)
                end
            end
        end

        -- update train position on client
        spec.networkTimeInterpolator:update(dt)
        local interpolationAlpha = spec.networkTimeInterpolator:getAlpha()
        local splineTime = spec.networkSplineTimeInterpolator:getInterpolatedValue(interpolationAlpha)
        splineTime = SplineUtil.getValidSplineTime(splineTime)
        self:updateTrainPositionByLocomotiveSplinePosition(splineTime)
    end

    if spec.hasLimitedRange then
        if self.isServer and spec.sellingStationPlaceable = = nil then
            if spec.drivingRangeSellingStationId ~ = nil then
                local placeable = g_currentMission.placeableSystem:getPlaceableByUniqueId(spec.drivingRangeSellingStationId)
                if placeable ~ = nil then
                    if placeable.spec_sellingStation ~ = nil then
                        spec.sellingStationPlaceable = placeable
                        spec.sellingStation = placeable.spec_sellingStation.sellingStation

                        self:raiseDirtyFlags(spec.stationDirtyFlag)
                    end
                else
                        Logging.xmlWarning( self.configFileName, "Unable to find selling station placeable with id %q" , spec.drivingRangeSellingStationId)
                    end

                    spec.drivingRangeSellingStationId = nil
                end
            end

            if spec.sellingStationPlaceable = = nil and spec.sellingStationPlaceableId ~ = nil then
                local placeable = NetworkUtil.getObject(spec.sellingStationPlaceableId)
                if placeable ~ = nil then
                    if placeable.spec_sellingStation ~ = nil then
                        spec.sellingStationPlaceable = placeable
                        spec.sellingStation = placeable.spec_sellingStation.sellingStation
                    end
                end
            end

            if spec.showDialogDelay > 0 then
                spec.showDialogDelay = spec.showDialogDelay - dt
                if spec.showDialogDelay < = 0 then
                    local stationName = "UNKNOWN"
                    if spec.sellingStationPlaceable ~ = nil then
                        stationName = spec.sellingStationPlaceable:getName()
                    end

                    local textDriveInfo = string.format(spec.textDriveInfo, stationName)
                    local textSellQuestion = string.format(spec.textSellQuestion, stationName)

                    if spec.showDialog = = 2 then
                        YesNoDialog.show( self.onSellGoodsQuestion, self , textDriveInfo .. "\n\n" .. textSellQuestion)
                    else
                            InfoDialog.show(textDriveInfo)
                        end

                        spec.showDialog = 0
                    end
                end
            end

            self:updateRailroadVehiclePositions(dt)

            self:raiseActive()
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
function PlaceableTrainSystem:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_trainSystem
        local numVehicles = #spec.railroadVehicles
        streamWriteInt8(streamId, numVehicles)
        for i = 1 ,numVehicles do
            NetworkUtil.writeNodeObject(streamId, spec.railroadVehicles[i])
        end

        streamWriteFloat32(streamId, spec.splineTimeSent)

        for _, railroadObject in ipairs(spec.railroadObjects) do
            if railroadObject.writeStream ~ = nil then
                railroadObject:writeStream(streamId, connection)
            end
        end

        streamWriteBool(streamId, spec.isRented)
        streamWriteUIntN(streamId, spec.rentFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)

        NetworkUtil.writeNodeObject(streamId, spec.sellingStationPlaceable)
    end
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function PlaceableTrainSystem:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_trainSystem
    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteFloat32(streamId, spec.splineTimeSent)

            for _, railroadObject in ipairs(spec.railroadObjects) do
                if railroadObject.writeUpdateStream ~ = nil then
                    railroadObject:writeUpdateStream(streamId, connection, dirtyMask)
                end
            end
        end

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.stationDirtyFlag) ~ = 0 ) then
            NetworkUtil.writeNodeObject(streamId, spec.sellingStationPlaceable)
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
function PlaceableTrainSystem.prerequisitesPresent(specializations)
    return true
end

```

### railroadVehicleLoaded

**Description**

**Definition**

> railroadVehicleLoaded()

**Arguments**

| any | vehicles         |
|-----|------------------|
| any | vehicleLoadState |
| any | args             |

**Code**

```lua
function PlaceableTrainSystem:railroadVehicleLoaded(vehicles, vehicleLoadState, args)
    local filename = args.filename
    local vehicleIndex = args.vehicleIndex

    local spec = self.spec_trainSystem
    if vehicleLoadState = = VehicleLoadingState.OK and #vehicles > 0 then
        local vehicle = vehicles[ 1 ]

        if not self:getIsBeingDeleted() then
            vehicle:setTrainSystem( self )
            vehicle.trainVehicleIndex = vehicleIndex
        end

        table.insert(spec.railroadVehicles, vehicle)
    else
            Logging.warning( "(%s) Could not create trainsystem vehicle!" , filename)
        end

        spec.numVehiclesToLoad = spec.numVehiclesToLoad - 1
        if spec.numVehiclesToLoad = = 0 and #spec.vehiclesToLoad = = 0 then
            self:finalizeTrain( true )
        end
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
function PlaceableTrainSystem.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onUpdate" , PlaceableTrainSystem )
    SpecializationUtil.registerEventListener(placeableType, "onDayChanged" , PlaceableTrainSystem )
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
function PlaceableTrainSystem.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateRailroadVehiclePositions" , PlaceableTrainSystem.updateRailroadVehiclePositions)
    SpecializationUtil.registerFunction(placeableType, "createVehicles" , PlaceableTrainSystem.createVehicles)
    SpecializationUtil.registerFunction(placeableType, "railroadVehicleLoaded" , PlaceableTrainSystem.railroadVehicleLoaded)
    SpecializationUtil.registerFunction(placeableType, "finalizeTrain" , PlaceableTrainSystem.finalizeTrain)
    SpecializationUtil.registerFunction(placeableType, "setIsTrainTabbable" , PlaceableTrainSystem.setIsTrainTabbable)
    SpecializationUtil.registerFunction(placeableType, "getIsTrainInDriveableRange" , PlaceableTrainSystem.getIsTrainInDriveableRange)
    SpecializationUtil.registerFunction(placeableType, "getSplineTime" , PlaceableTrainSystem.getSplineTime)
    SpecializationUtil.registerFunction(placeableType, "setSplineTime" , PlaceableTrainSystem.setSplineTime)
    SpecializationUtil.registerFunction(placeableType, "addSplinePositionUpdateListener" , PlaceableTrainSystem.addSplinePositionUpdateListener)
    SpecializationUtil.registerFunction(placeableType, "removeSplinePositionUpdateListener" , PlaceableTrainSystem.removeSplinePositionUpdateListener)
    SpecializationUtil.registerFunction(placeableType, "updateTrainPositionByLocomotiveSpeed" , PlaceableTrainSystem.updateTrainPositionByLocomotiveSpeed)
    SpecializationUtil.registerFunction(placeableType, "updateTrainPositionByLocomotiveSplinePosition" , PlaceableTrainSystem.updateTrainPositionByLocomotiveSplinePosition)
    SpecializationUtil.registerFunction(placeableType, "updateTrainLength" , PlaceableTrainSystem.updateTrainLength)
    SpecializationUtil.registerFunction(placeableType, "toggleRent" , PlaceableTrainSystem.toggleRent)
    SpecializationUtil.registerFunction(placeableType, "getCanBeRented" , PlaceableTrainSystem.getCanBeRented)
    SpecializationUtil.registerFunction(placeableType, "rentRailroad" , PlaceableTrainSystem.rentRailroad)
    SpecializationUtil.registerFunction(placeableType, "returnRailroad" , PlaceableTrainSystem.returnRailroad)
    SpecializationUtil.registerFunction(placeableType, "onDeleteObject" , PlaceableTrainSystem.onDeleteObject)
    SpecializationUtil.registerFunction(placeableType, "getIsRented" , PlaceableTrainSystem.getIsRented)
    SpecializationUtil.registerFunction(placeableType, "getSplineLength" , PlaceableTrainSystem.getSplineLength)
    SpecializationUtil.registerFunction(placeableType, "getElectricitySpline" , PlaceableTrainSystem.getElectricitySpline)
    SpecializationUtil.registerFunction(placeableType, "getElectricitySplineLength" , PlaceableTrainSystem.getElectricitySplineLength)
    SpecializationUtil.registerFunction(placeableType, "getLengthSplineTime" , PlaceableTrainSystem.getLengthSplineTime)
    SpecializationUtil.registerFunction(placeableType, "getSpline" , PlaceableTrainSystem.getSpline)
    SpecializationUtil.registerFunction(placeableType, "updateDriveableState" , PlaceableTrainSystem.updateDriveableState)
    SpecializationUtil.registerFunction(placeableType, "gsIsTrainFilled" , PlaceableTrainSystem.gsIsTrainFilled)
    SpecializationUtil.registerFunction(placeableType, "onSellGoodsQuestion" , PlaceableTrainSystem.onSellGoodsQuestion)
    SpecializationUtil.registerFunction(placeableType, "sellGoods" , PlaceableTrainSystem.sellGoods)
    SpecializationUtil.registerFunction(placeableType, "getTrainPosition" , PlaceableTrainSystem.getTrainPosition)
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
function PlaceableTrainSystem.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getNeedDayChanged" , PlaceableTrainSystem.getNeedDayChanged)
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
function PlaceableTrainSystem.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Train" )
    schema:register(XMLValueType.FLOAT, basePath .. "#splineTime" , "Current spline time" )
    schema:register(XMLValueType.BOOL, basePath .. "#isRented" , "Is train rented" )
    schema:register(XMLValueType.INT, basePath .. "#rentFarmId" , "Train is rented by farm" )
    schema:register(XMLValueType.FLOAT, basePath .. "#currentPrice" , "Current pending rent price" )
    schema:register(XMLValueType.STRING, basePath .. ".railroadVehicle(?)#vehicleUniqueId" , "Vehicle unique id" )
    schema:register(XMLValueType.INT, basePath .. ".railroadObjects(?)#index" , "Object index" )
    schema:setXMLSpecializationType()
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
function PlaceableTrainSystem.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Train" )
    schema:register(XMLValueType.FLOAT, basePath .. ".trainSystem.rent#pricePerHour" , "Rent price per real time hour" , 0 )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".trainSystem.spline#node" , "Spline node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".trainSystem.spline#splineYOffset" , "Spline Y offset" , 0 )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".trainSystem.drivingRange#startNode" , "Start of range node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".trainSystem.drivingRange#endNode" , "End of range node" )
    schema:register(XMLValueType.STRING, basePath .. ".trainSystem.drivingRange#sellingStationId" , "Unique id of selling station" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".trainSystem.electricitySpline#node" , "Electricity spline" )
    schema:register(XMLValueType.FLOAT, basePath .. ".trainSystem.electricitySpline#splineYOffset" , "Electricity spline Y offset" , 0 )

    schema:register(XMLValueType.STRING, basePath .. ".trainSystem.train.vehicle(?)#xmlFilename" , "XMl filename" )

    RailroadCrossing.registerXMLPaths(schema, basePath .. ".trainSystem.railroadCrossings.railroadCrossing(?)" )
    RailroadCaller.registerXMLPaths(schema, basePath .. ".trainSystem.railroadCallers.railroadCaller(?)" )

    schema:setXMLSpecializationType()
end

```

### removeSplinePositionUpdateListener

**Description**

**Definition**

> removeSplinePositionUpdateListener()

**Arguments**

| any | listener |
|-----|----------|

**Code**

```lua
function PlaceableTrainSystem:removeSplinePositionUpdateListener(listener)
    if listener ~ = nil then
        local spec = self.spec_trainSystem
        table.removeElement(spec.splinePositionUpdateListener, listener)
    end
end

```

### rentRailroad

**Description**

**Definition**

> rentRailroad()

**Arguments**

| any | farmId      |
|-----|-------------|
| any | position    |
| any | noEventSend |

**Code**

```lua
function PlaceableTrainSystem:rentRailroad(farmId, position, noEventSend)
    local spec = self.spec_trainSystem
    if spec.rootLocomotive = = nil then
        return
    end

    spec.isRented = true

    spec.rentFarmId = farmId
    spec.lastRentFarmId = farmId
    spec.rootLocomotive:setRequestedSplinePosition(position)

    for _, railroadVehicle in ipairs(spec.railroadVehicles) do
        railroadVehicle:setOwnerFarmId(spec.rentFarmId, true )
    end

    self:setIsTrainTabbable(g_currentMission:getFarmId() = = farmId)

    PlaceableTrainSystemRentEvent.sendEvent( self , true , farmId, position, noEventSend)
end

```

### returnRailroad

**Description**

**Definition**

> returnRailroad()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function PlaceableTrainSystem:returnRailroad(noEventSend)
    local spec = self.spec_trainSystem
    spec.isRented = false

    if self.isServer then
        if spec.currentPrice > 0 then
            g_currentMission:addMoney( - spec.currentPrice, spec.rentFarmId, MoneyType.LEASING_COSTS, true )
            g_currentMission:showMoneyChange(MoneyType.LEASING_COSTS, nil , false , spec.rentFarmId)
            spec.currentPrice = 0
        end

        spec.rootLocomotive:startAutomatedTrainTravel()
    end

    spec.rentFarmId = FarmManager.SPECTATOR_FARM_ID

    for _, railroadVehicle in ipairs(spec.railroadVehicles) do
        railroadVehicle:setOwnerFarmId(spec.rentFarmId, true )
    end

    self:setIsTrainTabbable( false )

    PlaceableTrainSystemRentEvent.sendEvent( self , false , nil , nil , noEventSend)
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
function PlaceableTrainSystem:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_trainSystem

    xmlFile:setValue(key .. "#splineTime" , SplineUtil.getValidSplineTime(spec.splineTime))

    for k, railroadVehicle in ipairs(spec.railroadVehicles) do
        local railroadKey = string.format( "%s.railroadVehicle(%d)" , key, k - 1 )
        xmlFile:setValue(railroadKey .. "#vehicleUniqueId" , railroadVehicle:getUniqueId())
    end

    for k, railroadObject in ipairs(spec.railroadObjects) do
        local railroadKey = string.format( "%s.railroadObjects(%d)" , key, k - 1 )
        if railroadObject.saveToXMLFile ~ = nil then
            xmlFile:setValue(railroadKey .. "#index" , k)
            railroadObject.saveToXMLFile(xmlFile, railroadKey, usedModNames)
        end
    end

    xmlFile:setValue(key .. "#isRented" , spec.isRented)
    xmlFile:setValue(key .. "#rentFarmId" , spec.rentFarmId)
    xmlFile:setValue(key .. "#currentPrice" , spec.currentPrice)
end

```

### sellGoods

**Description**

**Definition**

> sellGoods()

**Code**

```lua
function PlaceableTrainSystem:sellGoods()
    local spec = self.spec_trainSystem
    if spec.sellingStation ~ = nil and spec.rentFarmId ~ = 0 then
        local soldDelta = 0
        for _,railroadVehicle in ipairs(spec.railroadVehicles) do
            if railroadVehicle.getFillUnits ~ = nil then
                local fillUnits = railroadVehicle:getFillUnits()
                for fillUnitIndex, fillUnit in ipairs(fillUnits) do
                    local delta = spec.sellingStation:addFillLevelFromTool(spec.rentFarmId, fillUnit.fillLevel, fillUnit.fillType, nil , ToolType.UNDEFINED)
                    railroadVehicle:addFillUnitFillLevel(railroadVehicle:getOwnerFarmId(), fillUnitIndex, - delta, fillUnit.fillType, ToolType.UNDEFINED, nil )
                    soldDelta = soldDelta + delta
                end
            end
        end

        -- if we've sold something we return the train
            if soldDelta > 0 then
                if spec.isRented then
                    self:returnRailroad()
                end
            end
        end
    end

```

### setIsTrainTabbable

**Description**

**Definition**

> setIsTrainTabbable()

**Arguments**

| any | isTabbable |
|-----|------------|

**Code**

```lua
function PlaceableTrainSystem:setIsTrainTabbable(isTabbable)
    local spec = self.spec_trainSystem

    isTabbable = isTabbable and g_gameSettings:getValue(GameSettings.SETTING.IS_TRAIN_TABBABLE)

    if spec.hasLimitedRange then
        isTabbable = isTabbable and spec.lastIsInDriveableRange
    end

    for _,railroadVehicle in ipairs(spec.railroadVehicles) do
        if railroadVehicle.setIsTabbable ~ = nil then
            railroadVehicle:setIsTabbable(isTabbable)
        end
    end
end

```

### setSplineTime

**Description**

**Definition**

> setSplineTime()

**Arguments**

| any | startTime |
|-----|-----------|
| any | endTime   |

**Code**

```lua
function PlaceableTrainSystem:setSplineTime(startTime, endTime)
    local spec = self.spec_trainSystem

    startTime = SplineUtil.getValidSplineTime(startTime)
endTime = SplineUtil.getValidSplineTime(endTime)

if startTime ~ = spec.splineTime then
    if spec.hasLimitedRange then
        self:updateDriveableState(startTime)
    end

    for _,listener in ipairs(spec.splinePositionUpdateListener) do
        listener:onSplinePositionTimeUpdate(startTime, endTime)
    end

    local delta = startTime - spec.splineTime

    spec.splineTime = startTime
    spec.splineEndTime = endTime

    spec.x, spec.y, spec.z = getSplinePosition(spec.spline, spec.splineTime)

    local interpDt = g_physicsDt
    if g_server = = nil then
        -- on clients, we interpolate the vehicles with g_physicsDtUnclamped, thus we need to use the same for camera interpolation
            interpDt = g_physicsDtUnclamped
        end

        spec.splinePositionSpeedReal = delta * spec.splineLength * ( 1000 / interpDt)
        if self.isServer then
            spec.splinePositionSpeed = spec.splinePositionSpeedReal
        end

        if spec.firstUpdate then
            spec.splinePositionSpeedReal = 0
            spec.splinePositionSpeed = 0
            spec.firstUpdate = false
        end

        for _, railroadVehicle in ipairs(spec.railroadVehicles) do
            railroadVehicle:setSplineSpeed(spec.splinePositionSpeed, spec.splinePositionSpeedReal)
        end

        if self.isServer then
            local threshold = 0.02 / spec.splineLength -- 2 cm threshold
            if math.abs(spec.splineTime - spec.splineTimeSent) > threshold then
                spec.splineTimeSent = spec.splineTime
                self:raiseDirtyFlags(spec.dirtyFlag)
            end
        end
    end
end

```

### toggleRent

**Description**

**Definition**

> toggleRent()

**Arguments**

| any | farmId   |
|-----|----------|
| any | position |

**Code**

```lua
function PlaceableTrainSystem:toggleRent(farmId, position)
    local spec = self.spec_trainSystem

    if spec.isRented then
        if spec.rentFarmId = = farmId then
            self:returnRailroad()
        end
    else
            self:rentRailroad(farmId, position, false )
        end
    end

```

### updateDriveableState

**Description**

**Definition**

> updateDriveableState()

**Arguments**

| any | newSplineTime |
|-----|---------------|

**Code**

```lua
function PlaceableTrainSystem:updateDriveableState(newSplineTime)
    local spec = self.spec_trainSystem

    local isInDriveableRange = (newSplineTime % 1 ) > = spec.splineDriveRange[ 1 ] and(newSplineTime % 1 ) < = spec.splineDriveRange[ 2 ]
    if isInDriveableRange ~ = spec.lastIsInDriveableRange then
        spec.lastIsInDriveableRange = isInDriveableRange
        if not isInDriveableRange then
            for _,railroadVehicle in ipairs(spec.railroadVehicles) do
                if self.isClient then
                    if railroadVehicle.getIsEntered ~ = nil and railroadVehicle:getIsEntered() then
                        g_localPlayer:leaveVehicle()

                        -- show a bit delayed so the player is positionated correctly
                        spec.showDialogDelay = 100
                        spec.showDialog = 1
                        if self:gsIsTrainFilled() then
                            spec.showDialog = 2
                        end
                    end
                end

                if self.isServer then
                    local locomotiveSpec = railroadVehicle.spec_locomotive
                    if locomotiveSpec ~ = nil then
                        if locomotiveSpec.state ~ = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE
                            and locomotiveSpec.state ~ = Locomotive.STATE_REQUESTED_POSITION
                            and locomotiveSpec.state ~ = Locomotive.STATE_REQUESTED_POSITION_BRAKING then
                            railroadVehicle:setLocomotiveState( Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE)

                            -- return rental if train is empty so user will not pay for the drive outside of the map
                                if not self:gsIsTrainFilled() then
                                    if spec.isRented then
                                        self:returnRailroad()
                                    end
                                end

                                if spec.splineTime < newSplineTime then
                                    locomotiveSpec.sellingDirection = 1
                                else
                                        locomotiveSpec.sellingDirection = - 1
                                    end
                                end
                            end
                        end
                    end
                else
                        if self.isServer then
                            for _,railroadVehicle in ipairs(spec.railroadVehicles) do
                                local locomotiveSpec = railroadVehicle.spec_locomotive
                                if locomotiveSpec ~ = nil then
                                    if not railroadVehicle:getIsReadyForAutomatedTrainTravel() then
                                        if locomotiveSpec.state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE then
                                            railroadVehicle:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_INACTIVE)
                                            locomotiveSpec.sellingDirection = 1
                                        end
                                    else
                                            if locomotiveSpec.sellingDirection ~ = nil and locomotiveSpec.sellingDirection < 0 then
                                                locomotiveSpec.sellingDirection = 1

                                                railroadVehicle:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_INACTIVE)
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        self:setIsTrainTabbable(spec.isRented and g_currentMission:getFarmId() = = spec.rentFarmId)
                    end
                end

```

### updateRailroadVehiclePositions

**Description**

**Definition**

> updateRailroadVehiclePositions()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PlaceableTrainSystem:updateRailroadVehiclePositions(dt)
    local spec = self.spec_trainSystem

    -- allow vehicle position update only once a frame
    -- it is triggered by the object that is updated first
    if spec.lastUpdateLoopIndex < g_updateLoopIndex then
        spec.lastUpdateLoopIndex = g_updateLoopIndex

        -- update the spline time by the current locomotive speed first, then update the positions on the spline
        for _, railroadVehicle in pairs(spec.railroadVehicles) do
            if railroadVehicle.getLocomotiveSpeed ~ = nil then
                local locomotiveSpeed = railroadVehicle:getLocomotiveSpeed()

                local interpDt = g_physicsDt
                if g_server = = nil then
                    -- on clients, we interpolate the vehicles with g_physicsDtUnclamped, thus we need to use the same for camera interpolation
                        interpDt = g_physicsDtUnclamped
                    end

                    if locomotiveSpeed ~ = 0 then
                        --#profile RemoteProfiler.zoneBeginN("Locomotive-updatePosition")
                        self:updateTrainPositionByLocomotiveSpeed(interpDt, locomotiveSpeed)
                        --#profile RemoteProfiler.zoneEnd()
                    end
                end
            end

            local maxNumVehicleUpdatesPerFrame = 3
            for _, railroadVehicle in pairs(spec.railroadVehicles) do
                local clipDistance = getClipDistance(railroadVehicle.rootNode)
                if railroadVehicle.currentUpdateDistance < clipDistance then
                    maxNumVehicleUpdatesPerFrame = math.huge
                    break
                end
            end

            local numUpdates = 0
            while true do
                local railroadVehicle = spec.railroadVehicles[spec.railroadVehicleUpdateIndex + 1 ]
                if railroadVehicle = = nil then
                    -- on savegame start / delayed loading of vehicles
                    break
                end

                local vehicleSplineStartTime = spec.splineTime
                if spec.railroadVehicleUpdateIndex > 0 then
                    local railroadVehiclePredecessor = spec.railroadVehicles[spec.railroadVehicleUpdateIndex]
                    vehicleSplineStartTime = spec.railroadVehiclesEndTimes[railroadVehiclePredecessor]
                end

                --#profile RemoteProfiler.zoneBeginN("PlaceableTrainSystem-alignToSplineTime " .. (railroadVehicle.configFileNameClean or(railroadVehicle.getName ~ = nil and railroadVehicle:getName()) or railroadVehicle.__CLASSNAME or ""))
                local vehicleSplineEndTime = railroadVehicle:alignToSplineTime(spec.spline, spec.splineYOffset, vehicleSplineStartTime)
                --#profile RemoteProfiler.zoneEnd()

                spec.railroadVehiclesEndTimes[railroadVehicle] = vehicleSplineEndTime
                spec.railroadVehicleUpdateIndex = (spec.railroadVehicleUpdateIndex + 1 ) % #spec.railroadVehicles

                numUpdates = numUpdates + 1
                if numUpdates = = maxNumVehicleUpdatesPerFrame or numUpdates = = #spec.railroadVehicles then
                    break
                end
            end
        end
    end

```

### updateTrainLength

**Description**

**Definition**

> updateTrainLength()

**Arguments**

| any | splinePosition |
|-----|----------------|

**Code**

```lua
function PlaceableTrainSystem:updateTrainLength(splinePosition)
    local spec = self.spec_trainSystem
    for _,railroadVehicle in ipairs(spec.railroadVehicles) do
        spec.trainLength = spec.trainLength + railroadVehicle:getFrontToBackDistance()
    end
    spec.trainLengthSplineTime = spec.trainLength / spec.splineLength
    self:updateTrainPositionByLocomotiveSplinePosition(splinePosition)
end

```

### updateTrainPositionByLocomotiveSpeed

**Description**

**Definition**

> updateTrainPositionByLocomotiveSpeed()

**Arguments**

| any | dt    |
|-----|-------|
| any | speed |

**Code**

```lua
function PlaceableTrainSystem:updateTrainPositionByLocomotiveSpeed(dt, speed)
    local spec = self.spec_trainSystem
    local distance = speed * (dt / 1000 )
    local increment = distance / spec.splineLength
    local splineTime = self:getSplineTime() + increment

    self:setSplineTime(splineTime, splineTime - spec.trainLengthSplineTime)
end

```

### updateTrainPositionByLocomotiveSplinePosition

**Description**

**Definition**

> updateTrainPositionByLocomotiveSplinePosition()

**Arguments**

| any | splinePosition |
|-----|----------------|

**Code**

```lua
function PlaceableTrainSystem:updateTrainPositionByLocomotiveSplinePosition(splinePosition)
    local spec = self.spec_trainSystem
    local splineTime = splinePosition

    self:setSplineTime(splineTime, splineTime - spec.trainLengthSplineTime)
end

```