## PlaceableDoghouse

**Description**

> Specialization for placeables

**Functions**

- [canBuy](#canbuy)
- [dogInteractionTriggerCallback](#doginteractiontriggercallback)
- [getCanBePlacedAt](#getcanbeplacedat)
- [getDog](#getdog)
- [getNeedHourChanged](#getneedhourchanged)
- [getSpawnNode](#getspawnnode)
- [initSpecialization](#initspecialization)
- [isDoghouseRegistered](#isdoghouseregistered)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onHourChanged](#onhourchanged)
- [onLoad](#onload)
- [onPreviewDogLoaded](#onpreviewdogloaded)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerDoghouseToMission](#registerdoghousetomission)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setFoodBowlState](#setfoodbowlstate)
- [setOwnerFarmId](#setownerfarmid)
- [unregisterDoghouseToMission](#unregisterdoghousetomission)

### canBuy

**Description**

**Definition**

> canBuy()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableDoghouse:canBuy(superFunc)
    local canBuy, warning = superFunc( self )
    if not canBuy then
        return false , warning
    end

    if self:isDoghouseRegistered() then
        return false , g_i18n:getText( "warning_onlyOneOfThisItemAllowedPerFarm" )
    end

    return true , nil
end

```

### dogInteractionTriggerCallback

**Description**

**Definition**

> dogInteractionTriggerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function PlaceableDoghouse:dogInteractionTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    local spec = self.spec_doghouse
    if spec.dog ~ = nil then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode and g_localPlayer.farmId = = self:getOwnerFarmId() then
            if onEnter then
                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            elseif onLeave then
                    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                end
            end
        end
    end

```

### getCanBePlacedAt

**Description**

**Definition**

> getCanBePlacedAt()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |
| any | farmId    |

**Code**

```lua
function PlaceableDoghouse:getCanBePlacedAt(superFunc, x, y, z, farmId)
    if self:isDoghouseRegistered() then
        return false , g_i18n:getText( "warning_onlyOneOfThisItemAllowedPerFarm" )
    end

    return superFunc( self , x, y, z, farmId)
end

```

### getDog

**Description**

**Definition**

> getDog()

**Code**

```lua
function PlaceableDoghouse:getDog()
    return self.spec_doghouse.dog
end

```

### getNeedHourChanged

**Description**

**Definition**

> getNeedHourChanged()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableDoghouse:getNeedHourChanged(superFunc)
    return true
end

```

### getSpawnNode

**Description**

**Definition**

> getSpawnNode()

**Code**

```lua
function PlaceableDoghouse:getSpawnNode()
    return self.spec_doghouse.spawnNode
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableDoghouse.initSpecialization()
    g_placeableConfigurationManager:addConfigurationType( "dogHouse" , g_i18n:getText( "configuration_doghouse" ), "dogHouse" , PlaceableConfigurationItem )
end

```

### isDoghouseRegistered

**Description**

> Returns true if a doghouse is registered

**Definition**

> isDoghouseRegistered()

**Return Values**

| any | canBuy |
|-----|--------|

**Code**

```lua
function PlaceableDoghouse:isDoghouseRegistered()
    local dogHouse = g_currentMission:getDoghouse( self:getOwnerFarmId())
    return dogHouse ~ = nil
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
function PlaceableDoghouse:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_doghouse
    if spec.dog ~ = nil then
        spec.dog:loadFromXMLFile(xmlFile, key)
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableDoghouse:onDelete()
    local spec = self.spec_doghouse

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)

    self:unregisterDoghouseToMission()

    if self.isServer then
        if spec.dogBall ~ = nil and not spec.dogBall.isDeleted then -- Note:the dogBall might have been deleted by the server/client delete loop already
            spec.dogBall:delete()
            spec.dogBall = nil
        end
        if spec.dog ~ = nil and not spec.dog.isDeleted then -- Note:the dogBall might have been deleted by the server/client delete loop already
            spec.dog:delete()
            spec.dog = nil
        end
    end

    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
    end

    if spec.foodFillSample ~ = nil then
        g_soundManager:deleteSample(spec.foodFillSample)
        spec.foodFillSample = nil
    end

    if spec.dogPreviewSharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.dogPreviewSharedLoadRequestId)
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableDoghouse:onFinalizePlacement()
    local spec = self.spec_doghouse

    if self.isServer and spec.dog ~ = nil then
        spec.dog:finalizePlacement()
    end

    self:registerDoghouseToMission()
end

```

### onHourChanged

**Description**

**Definition**

> onHourChanged()

**Code**

```lua
function PlaceableDoghouse:onHourChanged()
    self:setFoodBowlState( false , true )
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
function PlaceableDoghouse:onLoad(savegame)
    local spec = self.spec_doghouse
    local xmlFile = self.xmlFile
    local isValid = true

    local dogHouseConfigurationId = Utils.getNoNil( self.configurations[ "dogHouse" ], 1 )
    local configKey = string.format( "placeable.dogHouse.dogHouseConfigurations.dogHouseConfiguration(%d)" , dogHouseConfigurationId - 1 )

    if not xmlFile:hasProperty(configKey) then
        configKey = "placeable.dogHouse"
    end

    spec.spawnNode = xmlFile:getValue(configKey .. ".dog#node" , nil , self.components, self.i3dMappings)
    if spec.spawnNode = = nil then
        Logging.xmlError(xmlFile, "Could not load dog spawn node!" )
        isValid = false
    end

    local isConstructionPreview = self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW

    local tileUIndex = xmlFile:getInt(configKey .. ".dog#tileUIndex" , 0 )
    local tileVIndex = xmlFile:getInt(configKey .. ".dog#tileVIndex" , 0 )

    if self.isServer and isValid and not isConstructionPreview then
        local posX, posY, posZ = getWorldTranslation(spec.spawnNode)
        local xmlFilename = Utils.getFilename(xmlFile:getValue(configKey .. ".dog#xmlFilename" ), self.baseDirectory)
        local dog = Dog.new( self.isServer, self.isClient)
        dog:setOwnerFarmId( self:getOwnerFarmId(), true )
        if dog:load( self , xmlFilename, posX, posY, posZ) then
            dog:setTextureTileIndices(tileUIndex, tileVIndex)
            dog:register()
            spec.dog = dog
        else
                isValid = false
                Logging.xmlWarning(xmlFile, "Could not load dog!" )
            end
        end

        if not isValid then
            SpecializationUtil.removeEventListener( self , "onDelete" , PlaceableDoghouse )
            SpecializationUtil.removeEventListener( self , "onFinalizePlacement" , PlaceableDoghouse )
            SpecializationUtil.removeEventListener( self , "onWriteStream" , PlaceableDoghouse )
            SpecializationUtil.removeEventListener( self , "onReadStream" , PlaceableDoghouse )
            SpecializationUtil.removeEventListener( self , "onHourChanged" , PlaceableDoghouse )
            return
        end

        spec.namePlateNode = xmlFile:getValue(configKey .. ".nameplate#node" , nil , self.components, self.i3dMappings)

        spec.ballSpawnNode = xmlFile:getValue(configKey .. ".ball#node" , nil , self.components, self.i3dMappings)
        if self.isServer and not isConstructionPreview then
            local dogBallFilename = Utils.getFilename(xmlFile:getValue(configKey .. ".ball#filename" ), self.baseDirectory)
            local x, y, z = getWorldTranslation(spec.ballSpawnNode)
            local rx, ry, rz = getWorldRotation(spec.ballSpawnNode)
            spec.dogBall = DogBall.new( self.isServer, self.isClient)
            spec.dogBall:setOwnerFarmId( self:getOwnerFarmId(), true )
            spec.dogBall:load(dogBallFilename, x, y, z, rx, ry, rz, self )
            spec.dogBall:register()
        end

        if isConstructionPreview then
            spec.dogPreviewLinkNode = xmlFile:getValue(configKey .. ".dog#previewNode" , nil , self.components, self.i3dMappings)

            local xmlFilename = Utils.getFilename(xmlFile:getValue(configKey .. ".dog#xmlFilename" ), self.baseDirectory)
            local dogXML = XMLFile.load( "dog" , xmlFilename)

            local dogI3DFilename = Utils.getFilename(dogXML:getString( "dog.asset#filename" ), self.baseDirectory)
            local numTilesU = dogXML:getInt( "dog.asset.texture#numTilesU" , 1 )
            local numTilesV = dogXML:getInt( "dog.asset.texture#numTilesV" , 1 )

            dogXML:delete()

            local loadingTask = self:createLoadingTask(spec)
            local arguments = {
            loadingTask = loadingTask,
            tileUIndex = tileUIndex,
            tileVIndex = tileVIndex,
            numTilesU = numTilesU,
            numTilesV = numTilesV
            }
            spec.dogPreviewSharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(dogI3DFilename, true , false , self.onPreviewDogLoaded, self , arguments)
        end

        -- player interaction trigger
        spec.triggerNode = xmlFile:getValue(configKey .. ".playerInteractionTrigger#node" , nil , self.components, self.i3dMappings)
        if spec.triggerNode ~ = nil then
            addTrigger(spec.triggerNode, "dogInteractionTriggerCallback" , self )
        end

        spec.foodNode = xmlFile:getValue(configKey .. ".bowl#foodNode" , nil , self.components, self.i3dMappings)
        if spec.foodNode = = nil then
            Logging.xmlWarning(xmlFile, "Missing bowl food node in 'placeable.dogHouse.bowl#foodNode'!" )
        else
                setVisibility(spec.foodNode, false )

                if g_client ~ = nil then
                    spec.foodFillSample = g_soundManager:loadSampleFromXML(xmlFile, configKey .. ".bowl" , "fillSound" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings)
                end
            end

            spec.activatable = DoghouseActivatable.new( self )
        end

```

### onPreviewDogLoaded

**Description**

**Definition**

> onPreviewDogLoaded()

**Arguments**

| any | node         |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableDoghouse:onPreviewDogLoaded(node, failedReason, args)
    local spec = self.spec_doghouse
    local loadingTask = args.loadingTask

    if node = = 0 or node = = nil then
        self:finishLoadingTask(loadingTask)
        return
    end

    link(spec.dogPreviewLinkNode or self.rootNode, node)

    local tileU = args.tileUIndex / args.numTilesU
    local tileV = args.tileVIndex / args.numTilesV
    setShaderParameterRecursive(node, "atlasInvSizeAndOffsetUV" , 1 / args.numTilesU, 1 / args.numTilesV, tileU, tileV, false )

    self:finishLoadingTask(loadingTask)
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
function PlaceableDoghouse:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_doghouse
        spec.dog = NetworkUtil.readNodeObject(streamId)
        if spec.dog ~ = nil then
            spec.dog.spawner = self
        end
        if spec.foodNode ~ = nil then
            setVisibility(spec.foodNode, streamReadBool(streamId))
        end
    end
end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function PlaceableDoghouse:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_doghouse
        NetworkUtil.writeNodeObject(streamId, spec.dog)
        if spec.foodNode ~ = nil then
            streamWriteBool(streamId, getVisibility(spec.foodNode))
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
function PlaceableDoghouse.prerequisitesPresent(specializations)
    return true
end

```

### registerDoghouseToMission

**Description**

> Registers the doghouse to the mission game.

**Definition**

> registerDoghouseToMission()

**Return Values**

| table | true | if registration went well |
|-------|------|---------------------------|

**Code**

```lua
function PlaceableDoghouse:registerDoghouseToMission()
    if not self:isDoghouseRegistered() then
        g_currentMission.doghouses[ self ] = self
        return true
    end

    return false
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
function PlaceableDoghouse.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableDoghouse )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableDoghouse )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableDoghouse )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableDoghouse )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableDoghouse )
    SpecializationUtil.registerEventListener(placeableType, "onHourChanged" , PlaceableDoghouse )
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
function PlaceableDoghouse.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "dogInteractionTriggerCallback" , PlaceableDoghouse.dogInteractionTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "isDoghouseRegistered" , PlaceableDoghouse.isDoghouseRegistered)
    SpecializationUtil.registerFunction(placeableType, "registerDoghouseToMission" , PlaceableDoghouse.registerDoghouseToMission)
    SpecializationUtil.registerFunction(placeableType, "unregisterDoghouseToMission" , PlaceableDoghouse.unregisterDoghouseToMission)
    SpecializationUtil.registerFunction(placeableType, "setFoodBowlState" , PlaceableDoghouse.setFoodBowlState)
    SpecializationUtil.registerFunction(placeableType, "getDog" , PlaceableDoghouse.getDog)
    SpecializationUtil.registerFunction(placeableType, "getSpawnNode" , PlaceableDoghouse.getSpawnNode)
    SpecializationUtil.registerFunction(placeableType, "onPreviewDogLoaded" , PlaceableDoghouse.onPreviewDogLoaded)
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
function PlaceableDoghouse.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableDoghouse.setOwnerFarmId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "canBuy" , PlaceableDoghouse.canBuy)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getCanBePlacedAt" , PlaceableDoghouse.getCanBePlacedAt)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getNeedHourChanged" , PlaceableDoghouse.getNeedHourChanged)
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
function PlaceableDoghouse.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Doghouse" )
    Dog.registerSavegameXMLPaths(schema, basePath)
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
function PlaceableDoghouse.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Doghouse" )
    local function addDogSchema(key)
        schema:register(XMLValueType.NODE_INDEX, key .. ".dog#node" , "Dog link node" )
        schema:register(XMLValueType.NODE_INDEX, key .. ".dog#previewNode" , "Dog preview link node" )
        schema:register(XMLValueType.INT, key .. ".dog#tileUIndex" , "Dog tile index U" )
        schema:register(XMLValueType.INT, key .. ".dog#tileVIndex" , "Dog tile index V" )
        schema:register(XMLValueType.STRING, key .. ".dog#xmlFilename" , "Dog xml filename" )
        schema:register(XMLValueType.NODE_INDEX, key .. ".nameplate#node" , "Name plate node" )
        schema:register(XMLValueType.NODE_INDEX, key .. ".ball#node" , "Ball node" )
        schema:register(XMLValueType.STRING, key .. ".ball#filename" , "Ball 3d file" )
        schema:register(XMLValueType.NODE_INDEX, key .. ".playerInteractionTrigger#node" , "Interaction trigger node" )
        schema:register(XMLValueType.NODE_INDEX, key .. ".bowl#foodNode" , "Food node in bowl" )
        SoundManager.registerSampleXMLPaths(schema, key .. ".bowl" , "fillSound" )
    end

    addDogSchema(basePath .. ".dogHouse" )
    addDogSchema(basePath .. ".dogHouse.dogHouseConfigurations.dogHouseConfiguration(?)" )
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
function PlaceableDoghouse:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_doghouse
    if spec.dog ~ = nil then
        spec.dog:saveToXMLFile(xmlFile, key, usedModNames)
    end
end

```

### setFoodBowlState

**Description**

**Definition**

> setFoodBowlState()

**Arguments**

| any | isFilled    |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function PlaceableDoghouse:setFoodBowlState(isFilled, noEventSend)
    local spec = self.spec_doghouse
    if spec.foodNode ~ = nil then
        PlaceableDoghouseFoodBowlStateEvent.sendEvent( self , isFilled, noEventSend)

        setVisibility(spec.foodNode, isFilled)

        if isFilled and spec.dog ~ = nil then
            spec.dog:onFoodBowlFilled(spec.foodNode)

            if spec.foodFillSample ~ = nil then
                g_soundManager:playSample(spec.foodFillSample)
            end
        end
    end
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | farmId      |
| any | noEventSend |

**Code**

```lua
function PlaceableDoghouse:setOwnerFarmId(superFunc, farmId, noEventSend)
    superFunc( self , farmId, noEventSend)

    if self.isServer then
        local spec = self.spec_doghouse
        -- Note:we need to send events for the dog and the dogBall if we need to send one for the doghouse
            if spec.dog ~ = nil then
                spec.dog:setOwnerFarmId(farmId, noEventSend)
            end
            if spec.dogBall ~ = nil then
                spec.dogBall:setOwnerFarmId(farmId, noEventSend)
            end
        end
    end

```

### unregisterDoghouseToMission

**Description**

> Registers the doghouse to the mission game.

**Definition**

> unregisterDoghouseToMission()

**Return Values**

| any | true | if registration went well |
|-----|------|---------------------------|

**Code**

```lua
function PlaceableDoghouse:unregisterDoghouseToMission()
    g_currentMission.doghouses[ self ] = nil

    return true
end

```