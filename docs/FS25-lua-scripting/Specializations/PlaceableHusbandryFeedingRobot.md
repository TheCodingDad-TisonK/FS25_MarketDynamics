## PlaceableHusbandryFeedingRobot

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFeedingRobotLoaded](#onfeedingrobotloaded)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
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
- [updateFeeding](#updatefeeding)
- [updateInfo](#updateinfo)

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
function PlaceableHusbandryFeedingRobot:collectPickObjects(superFunc, node)
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        if spec.feedingRobot:getIsNodeUsed(node) then
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
function PlaceableHusbandryFeedingRobot:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:loadFromXMLFile(xmlFile, key)
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHusbandryFeedingRobot:onDelete()
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:delete()
        spec.feedingRobot = nil
    end
end

```

### onFeedingRobotLoaded

**Description**

**Definition**

> onFeedingRobotLoaded()

**Arguments**

| any | robot |
|-----|-------|
| any | args  |

**Code**

```lua
function PlaceableHusbandryFeedingRobot:onFeedingRobotLoaded(robot, args)
    self:finishLoadingTask(args.loadingTask)
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableHusbandryFeedingRobot:onFinalizePlacement()
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:finalizePlacement()
    end
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
function PlaceableHusbandryFeedingRobot:onLoad(savegame)
    local spec = self.spec_husbandryFeedingRobot

    if not self.xmlFile:hasProperty( "placeable.husbandry.feedingRobot" ) then
        return
    end

    local filename = self.xmlFile:getValue( "placeable.husbandry.feedingRobot#filename" )
    if filename = = nil then
        Logging.xmlError( self.xmlFile, "Feedingrobot filename missing" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    filename = Utils.getFilename(filename, self.baseDirectory)

    local className = self.xmlFile:getValue( "placeable.husbandry.feedingRobot#class" , "" )
    local class = ClassUtil.getClassObject(className)
    if class = = nil then
        Logging.xmlError( self.xmlFile, "Feedingrobot class '%s' not defined" , className)
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    local linkNode = self.xmlFile:getValue( "placeable.husbandry.feedingRobot#linkNode" , nil , self.components, self.i3dMappings)
    if linkNode = = nil then
        Logging.xmlError( self.xmlFile, "Feedingrobot linkNode not defined" )
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    local loadingTask = self:createLoadingTask( self )
    spec.feedingRobot = class.new( self.isServer, self.isClient, self , self.baseDirectory)
    spec.feedingRobot:load(linkNode, filename, self.onFeedingRobotLoaded, self , { loadingTask = loadingTask } )
    spec.feedingRobot:register( true )

    for _, splineKey in self.xmlFile:iterator( "placeable.husbandry.feedingRobot.splines.spline" ) do
        local fakeLength = self.xmlFile:getFloat(splineKey .. "#fakeLength" , nil )
        local stopAtEnd = self.xmlFile:getBool(splineKey .. "#stopAtEnd" , false )
        if fakeLength ~ = nil then
            fakeLength = fakeLength
            spec.feedingRobot:addSplineWaitingPoint(fakeLength)
        else
                local spline = self.xmlFile:getValue(splineKey .. "#node" , nil , self.components, self.i3dMappings)
                if spline = = nil then
                    Logging.xmlWarning( self.xmlFile, "Feedingrobot spline not defined for '%s'" , splineKey)
                        break
                    end
                    if not getHasClassId(getGeometry(spline), ClassIds.SPLINE) then
                        Logging.xmlWarning( self.xmlFile, "Given node is not a spline for '%s'" , splineKey)
                            break
                        end
                        local direction = self.xmlFile:getValue(splineKey .. "#direction" , 1 )
                        local isFeeding = self.xmlFile:getValue(splineKey .. "#isFeeding" , false )

                        spec.feedingRobot:addSpline(spline, direction, isFeeding, stopAtEnd)
                    end
                end

                spec.feedingRobot:finishSplines()

                spec.dependedAnimatedObjects = { }
                self.xmlFile:iterate( "placeable.husbandry.feedingRobot.animatedObjects.animatedObject" , function (index, animationObjectKey)
                    local animatedObjectIndex = self.xmlFile:getInt(animationObjectKey .. "#index" )
                    local direction = self.xmlFile:getInt(animationObjectKey .. "#direction" , 1 )

                    table.insert(spec.dependedAnimatedObjects, { animatedObjectIndex = animatedObjectIndex, direction = direction } )
                end )
            end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableHusbandryFeedingRobot:onPostLoad(savegame)
    local spec = self.spec_husbandryFeedingRobot
    if spec.dependedAnimatedObjects ~ = nil and self.spec_animatedObjects ~ = nil then
        local animatedObjects = self.spec_animatedObjects.animatedObjects

        for _, data in ipairs(spec.dependedAnimatedObjects) do
            local animatedObject = animatedObjects[data.animatedObjectIndex]
            if animatedObject ~ = nil then
                animatedObject.getCanBeTriggered = Utils.overwrittenFunction(animatedObject.getCanBeTriggered, function (_, superFunc)
                    if not superFunc(animatedObject) then
                        return false
                    end

                    return not spec.feedingRobot:getIsDriving()
                end )

                spec.feedingRobot:addStateChangedListener( function (state)
                    if spec.feedingRobot:getIsDriving() then
                        if animatedObject.animation.direction ~ = data.direction then
                            animatedObject:setDirection(data.direction)
                        end
                    end
                end )
            end
        end
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
function PlaceableHusbandryFeedingRobot:onReadStream(streamId, connection)
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        local feedingRobotId = NetworkUtil.readNodeObjectId(streamId)
        spec.feedingRobot:readStream(streamId, connection)
        g_client:finishRegisterObject(spec.feedingRobot, feedingRobotId)
    end
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
function PlaceableHusbandryFeedingRobot:onWriteStream(streamId, connection)
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.feedingRobot))
        spec.feedingRobot:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, spec.feedingRobot)
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
function PlaceableHusbandryFeedingRobot.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PlaceableHusbandryFood , specializations)
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
function PlaceableHusbandryFeedingRobot.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHusbandryFeedingRobot )
    SpecializationUtil.registerEventListener(placeableType, "onPostLoad" , PlaceableHusbandryFeedingRobot )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHusbandryFeedingRobot )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHusbandryFeedingRobot )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableHusbandryFeedingRobot )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableHusbandryFeedingRobot )
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
function PlaceableHusbandryFeedingRobot.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onFeedingRobotLoaded" , PlaceableHusbandryFeedingRobot.onFeedingRobotLoaded)
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
function PlaceableHusbandryFeedingRobot.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableHusbandryFeedingRobot.setOwnerFarmId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateFeeding" , PlaceableHusbandryFeedingRobot.updateFeeding)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableHusbandryFeedingRobot.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableHusbandryFeedingRobot.updateInfo)
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
function PlaceableHusbandryFeedingRobot.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    FeedingRobot.registerSavegameXMLPaths(schema, basePath)
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
function PlaceableHusbandryFeedingRobot.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Husbandry" )
    basePath = basePath .. ".husbandry.feedingRobot"
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#linkNode" , "Feedingrobot link node" )
    schema:register(XMLValueType.STRING, basePath .. "#class" , "Feedingrobot class name" )
    schema:register(XMLValueType.STRING, basePath .. "#filename" , "Feedingrobot config file" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".splines.spline(?)#node" , "Feedingrobot spline" )
    schema:register(XMLValueType.INT, basePath .. ".splines.spline(?)#direction" , "Feedingrobot spline direction" )
    schema:register(XMLValueType.BOOL, basePath .. ".splines.spline(?)#isFeeding" , "Feedingrobot spline feeding part" )
    schema:register(XMLValueType.FLOAT, basePath .. ".splines.spline(?)#fakeLength" , "Fake length of spline for simulating a waiting point" )
        schema:register(XMLValueType.BOOL, basePath .. ".splines.spline(?)#stopAtEnd" , "If robot should stop at the end of the spline and switch to next state" )
        schema:register(XMLValueType.INT, basePath .. ".animatedObjects.animatedObject(?)#index" , "Dependent animated object index" )
        schema:register(XMLValueType.INT, basePath .. ".animatedObjects.animatedObject(?)#direction" , "Dependent animated object direction" )
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
function PlaceableHusbandryFeedingRobot:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:saveToXMLFile(xmlFile, key, usedModNames)
    end
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
function PlaceableHusbandryFeedingRobot:setOwnerFarmId(superFunc, farmId)
    superFunc( self , farmId)

    local spec = self.spec_husbandryFeedingRobot
    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:setOwnerFarmId(farmId, true )
    end
end

```

### updateFeeding

**Description**

**Definition**

> updateFeeding()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableHusbandryFeedingRobot:updateFeeding(superFunc)
    local spec = self.spec_husbandryFeedingRobot
    if self.isServer then
        if spec.feedingRobot ~ = nil then
            local litersPerHour = self:getFoodLitersPerHour() * g_currentMission.environment.timeAdjustment
            spec.feedingRobot:createFoodMixture(litersPerHour * 1.5 )
        end
    end

    return superFunc( self )
end

```

### updateInfo

**Description**

**Definition**

> updateInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | infoTable |

**Code**

```lua
function PlaceableHusbandryFeedingRobot:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)

    local spec = self.spec_husbandryFeedingRobot

    if spec.feedingRobot ~ = nil then
        spec.feedingRobot:updateInfo(infoTable)
    end
end

```