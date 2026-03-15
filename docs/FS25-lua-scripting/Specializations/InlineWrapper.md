## InlineWrapper

**Description**

> Class for inline wrappers

**Functions**

- [getAllowBalePushing](#getallowbalepushing)
- [getBrakeForce](#getbrakeforce)
- [getCanInteract](#getcaninteract)
- [getCanPushOff](#getcanpushoff)
- [getCurrentInlineBale](#getcurrentinlinebale)
- [getIsActive](#getisactive)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsInlineBalingAllowed](#getisinlinebalingallowed)
- [getShowConsumableEmptyWarning](#getshowconsumableemptywarning)
- [getSpecValueBaleSize](#getspecvaluebalesize)
- [getSpecValueBaleSizeRound](#getspecvaluebalesizeround)
- [getSpecValueBaleSizeSquare](#getspecvaluebalesizesquare)
- [getWrapperBaleType](#getwrapperbaletype)
- [initSpecialization](#initspecialization)
- [inlineBaleTriggerCallback](#inlinebaletriggercallback)
- [inlineWrapTriggerCallback](#inlinewraptriggercallback)
- [loadSpecValueBaleSize](#loadspecvaluebalesize)
- [loadSpecValueBaleSizeRound](#loadspecvaluebalesizeround)
- [loadSpecValueBaleSizeSquare](#loadspecvaluebalesizesquare)
- [onConsumableVariationChanged](#onconsumablevariationchanged)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onEnterVehicle](#onentervehicle)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [pushOffInlineBale](#pushoffinlinebale)
- [pushOffInlineBaleEvent](#pushoffinlinebaleevent)
- [readInlineBales](#readinlinebales)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setCurrentInlineBale](#setcurrentinlinebale)
- [updateInlineSteeringWheels](#updateinlinesteeringwheels)
- [updateRoundBaleWrappingNode](#updateroundbalewrappingnode)
- [updateSquareBaleWrappingNode](#updatesquarebalewrappingnode)
- [updateWrapperRailings](#updatewrapperrailings)
- [updateWrappingNodes](#updatewrappingnodes)
- [writeInlineBales](#writeinlinebales)

### getAllowBalePushing

**Description**

**Definition**

> getAllowBalePushing()

**Arguments**

| any | bale |
|-----|------|

**Code**

```lua
function InlineWrapper:getAllowBalePushing(bale)
    if bale.dynamicMountJointIndex ~ = nil then
        return false
    end

    return true
end

```

### getBrakeForce

**Description**

**Definition**

> getBrakeForce()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function InlineWrapper:getBrakeForce(superFunc)
    local spec = self.spec_inlineWrapper
    if spec.releaseBrake then
        spec.releaseBrakeSet = spec.releaseBrake
        return 0
    end

    return superFunc( self )
end

```

### getCanInteract

**Description**

**Definition**

> getCanInteract()

**Code**

```lua
function InlineWrapper:getCanInteract()

    local localPlayer = g_localPlayer
    if localPlayer:getIsInVehicle() then
        return false
    end

    if not g_currentMission.accessHandler:canPlayerAccess( self ) then
        return false
    end

    local x1, y1, z1 = localPlayer:getPosition()
    local x2, y2, z2 = getWorldTranslation( self.components[ 1 ].node)

    local distance = MathUtil.vector3Length(x1 - x2, y1 - y2, z1 - z2)

    return distance < InlineWrapper.INTERACTION_RADIUS
end

```

### getCanPushOff

**Description**

**Definition**

> getCanPushOff()

**Code**

```lua
function InlineWrapper:getCanPushOff()
    local spec = self.spec_inlineWrapper

    local currentInlineBale = self:getCurrentInlineBale()
    if currentInlineBale = = nil then
        return false
    end

    if currentInlineBale:getPendingBale() ~ = nil then
        return false
    end

    if self:getIsAnimationPlaying(spec.animations.pusher) then
        return false
    end

    if self:getIsAnimationPlaying(spec.animations.pushOff) then
        return false
    end

    return true
end

```

### getCurrentInlineBale

**Description**

**Definition**

> getCurrentInlineBale()

**Code**

```lua
function InlineWrapper:getCurrentInlineBale()
    return NetworkUtil.getObject( self.spec_inlineWrapper.currentInlineBale)
end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function InlineWrapper:getIsActive(superFunc)
    local spec = self.spec_inlineWrapper
    if spec.releaseBrake or spec.releaseBrake ~ = spec.releaseBrakeSet then
        return true
    end

    return superFunc( self )
end

```

### getIsFoldAllowed

**Description**

**Definition**

> getIsFoldAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | direction  |
| any | onAiTurnOn |

**Code**

```lua
function InlineWrapper:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_inlineWrapper
    if next(spec.enteredInlineBales) ~ = nil then
        return false
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsInlineBalingAllowed

**Description**

**Definition**

> getIsInlineBalingAllowed()

**Code**

```lua
function InlineWrapper:getIsInlineBalingAllowed()
    local spec = self.spec_inlineWrapper

    local foldTime = self:getFoldAnimTime()
    if foldTime < spec.minFoldTime or foldTime > spec.maxFoldTime then
        return false
    end

    if self:getIsAnimationPlaying(spec.animations.pusher) then
        return false
    end

    if self:getIsAnimationPlaying(spec.animations.pushOff) or self:getAnimationTime(spec.animations.pushOff) > 0 then
        return false
    end

    return self:getConsumableIsAvailable( InlineWrapper.CONSUMABLE_TYPE_NAME)
end

```

### getShowConsumableEmptyWarning

**Description**

**Definition**

> getShowConsumableEmptyWarning()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | typeName  |

**Code**

```lua
function InlineWrapper:getShowConsumableEmptyWarning(superFunc, typeName)
    if typeName = = InlineWrapper.CONSUMABLE_TYPE_NAME then
        if superFunc( self , typeName) then
            local spec = self.spec_inlineWrapper
            if next(spec.pendingSingleBales) ~ = nil then
                local foldTime = self:getFoldAnimTime()
                if foldTime > = spec.minFoldTime or foldTime < = spec.maxFoldTime then
                    return true
                end
            end

            return false
        end
    end

    return superFunc( self , typeName)
end

```

### getSpecValueBaleSize

**Description**

**Definition**

> getSpecValueBaleSize()

**Arguments**

| any | storeItem        |
|-----|------------------|
| any | realItem         |
| any | configurations   |
| any | saleItem         |
| any | returnValues     |
| any | returnRange      |
| any | roundBaleWrapper |

**Code**

```lua
function InlineWrapper.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, roundBaleWrapper)
    local baleSizeAttributes = roundBaleWrapper and storeItem.specs.inlineWrapperBaleSizeRound or storeItem.specs.inlineWrapperBaleSizeSquare
    if baleSizeAttributes ~ = nil then
        local minValue = roundBaleWrapper and baleSizeAttributes.minDiameter or baleSizeAttributes.minLength
        local maxValue = roundBaleWrapper and baleSizeAttributes.maxDiameter or baleSizeAttributes.maxLength

        if returnValues = = nil or not returnValues then
            local unit = g_i18n:getText( "unit_cmShort" )
            local size
            if maxValue ~ = minValue then
                size = string.format( "%d%s-%d%s" , minValue * 100 , unit, maxValue * 100 , unit)
            else
                    size = string.format( "%d%s" , minValue * 100 , unit)
                end

                return size
            else
                    if returnRange = = true and maxValue ~ = minValue then
                        return minValue * 100 , maxValue * 100 , g_i18n:getText( "unit_cmShort" )
                    else
                            return minValue * 100 , g_i18n:getText( "unit_cmShort" )
                        end
                    end
                else
                        if returnValues and returnRange then
                            return 0 , 0 , ""
                        elseif returnValues then
                                return 0 , ""
                            else
                                    return ""
                                end
                            end
                        end

```

### getSpecValueBaleSizeRound

**Description**

**Definition**

> getSpecValueBaleSizeRound()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function InlineWrapper.getSpecValueBaleSizeRound(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.inlineWrapperBaleSizeRound ~ = nil then
        return InlineWrapper.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, true )
    end

    return nil
end

```

### getSpecValueBaleSizeSquare

**Description**

**Definition**

> getSpecValueBaleSizeSquare()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function InlineWrapper.getSpecValueBaleSizeSquare(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.inlineWrapperBaleSizeSquare ~ = nil then
        return InlineWrapper.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, false )
    end

    return nil
end

```

### getWrapperBaleType

**Description**

**Definition**

> getWrapperBaleType()

**Arguments**

| any | bale |
|-----|------|

**Code**

```lua
function InlineWrapper:getWrapperBaleType(bale)
    local spec = self.spec_inlineWrapper

    for _, baleType in pairs(spec.baleTypes) do
        if bale:getSupportsWrapping() then
            if bale.isRoundbale then
                if baleType.isRoundBale then
                    if bale.diameter = = baleType.diameter
                        and bale.width = = baleType.width then
                        return baleType
                    end
                end
            else
                    if not baleType.isRoundBale then
                        if bale.width = = baleType.width
                            and bale.height = = baleType.height
                            and bale.length = = baleType.length then
                            return baleType
                        end
                    end
                end
            end
        end

        return nil
    end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function InlineWrapper.initSpecialization()
    g_storeManager:addSpecType( "inlineWrapperBaleSizeRound" , "shopListAttributeIconBaleWrapperBaleSizeRound" , InlineWrapper.loadSpecValueBaleSizeRound, InlineWrapper.getSpecValueBaleSizeRound, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "inlineWrapperBaleSizeSquare" , "shopListAttributeIconBaleWrapperBaleSizeSquare" , InlineWrapper.loadSpecValueBaleSizeSquare, InlineWrapper.getSpecValueBaleSizeSquare, StoreSpecies.VEHICLE)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "InlineWrapper" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.baleTrigger#node" , "Bale pickup trigger" )
    schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTrigger#minFoldTime" , "Min.folding time for bale pickup" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTrigger#maxFoldTime" , "Max.folding time for bale pickup" , 1 )
            schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.wrapTrigger#node" , "Wrap trigger" )

            schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.baleTypes.baleType(?)#startNode" , "Start placement node for bale" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?)#wrapUsage" , "Usage of wrap rolls per minute" , 0.1 )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?).railing#width" , "Railing width to set" )
                schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.baleTypes.baleType(?).inlineBale#filename" , "Path to inline bale xml file" )

                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?).size#diameter" , "Bale diameter" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?).size#width" , "Bale width" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?).size#height" , "Bale height" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.baleTypes.baleType(?).size#length" , "Bale length" )

                schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.railings#animation" , "Railing animation" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.railings#animStartX" , "Railing width at start of animation" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.railings#animEndX" , "Railing width at end of animation" )
                schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.railings#defaultX" , "Default railing width" , 1 )

                schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.wrapping#startNode" , "Reference node for wrapping state of bale" )

                    schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.steeringNodes.steeringNode(?)#node" , "Steering node that is aligned to the start wrapping direction" )

                    schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.wrappingNodes.wrappingNode(?)#node" , "Wrapping node" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.inlineWrapper.wrappingNodes.wrappingNode(?)#target" , "Target node that is aligned to the bale" )
                    schema:register(XMLValueType.VECTOR_TRANS, "vehicle.inlineWrapper.wrappingNodes.wrappingNode(?)#startTrans" , "Start translation" )

                    schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.animations#pusher" , "Pusher animation" , "pusherAnimation" )
                    schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.animations#wrapping" , "Wrapping animation" , "wrappingAnimation" )
                    schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.animations#pushOff" , "Push bale off animation" , "pushOffAnimation" )

                    schema:register(XMLValueType.STRING, "vehicle.inlineWrapper.pushing#brakeForce" , "Brake force while pushing" , 0 )
                        schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.pushing#openBrakeTime" , "Pusher animation time to open brake" , 0.1 )
                        schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper.pushing#closeBrakeTime" , "Pusher animation time to close brake" , 0.5 )
                        schema:register(XMLValueType.INT, "vehicle.inlineWrapper.pushing#minBaleAmount" , "Min.bales wrapped to open brake" , 4 )

                        schema:register(XMLValueType.FLOAT, "vehicle.inlineWrapper#baleMovedThreshold" , "Bale moved threshold for starting wrapping animation" , 0.05 )
                            schema:register(XMLValueType.INT, "vehicle.inlineWrapper#numObjectBits" , "Num bits for sending bales" , 4 )

                                SoundManager.registerSampleXMLPaths(schema, "vehicle.inlineWrapper.sounds" , "wrap" )
                                SoundManager.registerSampleXMLPaths(schema, "vehicle.inlineWrapper.sounds" , "start" )
                                SoundManager.registerSampleXMLPaths(schema, "vehicle.inlineWrapper.sounds" , "stop" )

                                schema:setXMLSpecializationType()
                            end

```

### inlineBaleTriggerCallback

**Description**

**Definition**

> inlineBaleTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function InlineWrapper:inlineBaleTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    if self.isServer then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil and object:isa( Bale ) then
            local objectId = NetworkUtil.getObjectId(object)
            local spec = self.spec_inlineWrapper
            if onEnter then
                if not object:isa( InlineBaleSingle ) then
                    if self:getWrapperBaleType(object) ~ = nil then
                        spec.pendingSingleBales[objectId] = objectId
                    else
                            spec.pendingIncompatibleBales[objectId] = objectId
                        end
                    else
                            spec.enteredInlineBales[objectId] = objectId

                            -- set wrapper and wrapping node again if the bale reenteres
                                local connectedInlineBale = object:getConnectedInlineBale()
                                if connectedInlineBale ~ = nil then
                                    connectedInlineBale:setCurrentWrapperInfo( self , spec.wrappingStartNode)
                                else
                                        -- add information to inline bale if the bale was added to the inline bale(while loading)
                                            object.inlineWrapperToAdd = { wrapper = self , wrappingNode = spec.wrappingStartNode }
                                        end
                                    end
                                elseif onLeave then
                                        spec.pendingSingleBales[objectId] = nil
                                        spec.pendingIncompatibleBales[objectId] = nil
                                        spec.enteredInlineBales[objectId] = nil

                                        if object:isa( InlineBaleSingle ) then
                                            local connectedInlineBale = object:getConnectedInlineBale()
                                            if connectedInlineBale ~ = nil then
                                                local bales = connectedInlineBale:getBales()
                                                local removeFromWrapper = true
                                                for _, bale in ipairs(bales) do
                                                    local baleId = NetworkUtil.getObjectId(bale)
                                                    if spec.pendingSingleBales[baleId] ~ = nil or
                                                        spec.enteredInlineBales[baleId] ~ = nil then
                                                        removeFromWrapper = false
                                                        break
                                                    end
                                                end

                                                if removeFromWrapper then
                                                    connectedInlineBale:setCurrentWrapperInfo( nil , nil )
                                                    self:setCurrentInlineBale( nil )
                                                end
                                            end
                                        end
                                    end

                                    self:raiseDirtyFlags(spec.inlineBalesDirtyFlag)
                                end
                            end
                        end

```

### inlineWrapTriggerCallback

**Description**

**Definition**

> inlineWrapTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function InlineWrapper:inlineWrapTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    if self.isServer then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil and object:isa( Bale ) then
            local spec = self.spec_inlineWrapper
            local objectId = NetworkUtil.getObjectId(object)
            if onEnter then
                spec.enteredBalesToWrap[objectId] = objectId
            elseif onLeave then
                    spec.enteredBalesToWrap[objectId] = nil
                end

                self:raiseActive()
                self:raiseDirtyFlags(spec.inlineBalesDirtyFlag)
            end
        end
    end

```

### loadSpecValueBaleSize

**Description**

**Definition**

> loadSpecValueBaleSize()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |
| any | roundBaleWrapper  |

**Code**

```lua
function InlineWrapper.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir, roundBaleWrapper)
    local rootName = xmlFile:getRootName()

    local baleSizeAttributes = { }
    baleSizeAttributes.minDiameter, baleSizeAttributes.maxDiameter = math.huge, - math.huge
    baleSizeAttributes.minLength, baleSizeAttributes.maxLength = math.huge, - math.huge
    xmlFile:iterate(rootName .. ".inlineWrapper.baleTypes.baleType" , function (_, key)
        local diameter = MathUtil.round(xmlFile:getValue(key .. ".size#diameter" , 0 ), 2 )
        if roundBaleWrapper and diameter ~ = 0 then
            baleSizeAttributes.minDiameter = math.min(baleSizeAttributes.minDiameter, diameter)
            baleSizeAttributes.maxDiameter = math.max(baleSizeAttributes.maxDiameter, diameter)
        end

        local length = MathUtil.round(xmlFile:getValue(key .. ".size#length" , 0 ), 2 )
        if not roundBaleWrapper and length ~ = 0 then
            baleSizeAttributes.minLength = math.min(baleSizeAttributes.minLength, length)
            baleSizeAttributes.maxLength = math.max(baleSizeAttributes.maxLength, length)
        end
    end )

    if baleSizeAttributes.minDiameter ~ = math.huge or baleSizeAttributes.minLength ~ = math.huge then
        return baleSizeAttributes
    end

    return nil
end

```

### loadSpecValueBaleSizeRound

**Description**

**Definition**

> loadSpecValueBaleSizeRound()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function InlineWrapper.loadSpecValueBaleSizeRound(xmlFile, customEnvironment, baseDir)
    return InlineWrapper.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir, true )
end

```

### loadSpecValueBaleSizeSquare

**Description**

**Definition**

> loadSpecValueBaleSizeSquare()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function InlineWrapper.loadSpecValueBaleSizeSquare(xmlFile, customEnvironment, baseDir)
    return InlineWrapper.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir, false )
end

```

### onConsumableVariationChanged

**Description**

> Called while the consumable variation changed on the consum slots

**Definition**

> onConsumableVariationChanged()

**Arguments**

| any | variationIndex |
|-----|----------------|
| any | metaData       |

**Code**

```lua
function InlineWrapper:onConsumableVariationChanged(variationIndex, metaData)
    if metaData.color ~ = nil then
        local spec = self.spec_inlineWrapper
        spec.wrapColor[ 1 ] = metaData.color[ 1 ]
        spec.wrapColor[ 2 ] = metaData.color[ 2 ]
        spec.wrapColor[ 3 ] = metaData.color[ 3 ]
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function InlineWrapper:onDelete()
    local spec = self.spec_inlineWrapper
    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
    end
    if spec.wrapTriggerNode ~ = nil then
        removeTrigger(spec.wrapTriggerNode)
    end

    g_soundManager:deleteSamples(spec.samples)

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)

    local inlineBale = self:getCurrentInlineBale()
    if inlineBale ~ = nil then
        inlineBale:wakeUp( 50 )
        inlineBale:setWrappingState( 1 )
        inlineBale:setCurrentWrapperInfo( nil , nil )
        self:setCurrentInlineBale( nil )
    end
end

```

### onDraw

**Description**

> Called on draw

**Definition**

> onDraw()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function InlineWrapper:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_inlineWrapper
        if next(spec.pendingSingleBales) ~ = nil then
            local foldTime = self:getFoldAnimTime()
            if foldTime < spec.minFoldTime or foldTime > spec.maxFoldTime then
                g_currentMission:showBlinkingWarning( self.spec_foldable.unfoldWarning, 500 )
            end
        end

        if spec.showIncompatibleBalesWarning then
            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_baleNotSupported" ), 500 )
        end
    end
end

```

### onEnterVehicle

**Description**

**Definition**

> onEnterVehicle()

**Code**

```lua
function InlineWrapper:onEnterVehicle()
    local spec = self.spec_inlineWrapper
    for _, steeringNode in ipairs(spec.steeringNodes) do
        setRotation(steeringNode.node, unpack(steeringNode.startRot))

        if self.setMovingToolDirty ~ = nil then
            self:setMovingToolDirty(steeringNode.node)
        end
    end
end

```

### onLeaveVehicle

**Description**

**Definition**

> onLeaveVehicle()

**Code**

```lua
function InlineWrapper:onLeaveVehicle()
    self.rotatedTime = 0
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
function InlineWrapper:onLoad(savegame)
    local spec = self.spec_inlineWrapper

    local baseKey = "vehicle.inlineWrapper"

    spec.triggerNode = self.xmlFile:getValue(baseKey .. ".baleTrigger#node" , nil , self.components, self.i3dMappings)
    if spec.triggerNode ~ = nil then
        addTrigger(spec.triggerNode, "inlineBaleTriggerCallback" , self )
    end

    spec.wrapTriggerNode = self.xmlFile:getValue(baseKey .. ".wrapTrigger#node" , nil , self.components, self.i3dMappings)
    if spec.wrapTriggerNode ~ = nil then
        addTrigger(spec.wrapTriggerNode, "inlineWrapTriggerCallback" , self )
    end

    spec.minFoldTime = self.xmlFile:getValue(baseKey .. ".baleTrigger#minFoldTime" , 0 )
    spec.maxFoldTime = self.xmlFile:getValue(baseKey .. ".baleTrigger#maxFoldTime" , 1 )

    spec.wrapColor = { 1 , 1 , 1 }

    spec.baleTypes = { }
    self.xmlFile:iterate(baseKey .. ".baleTypes.baleType" , function (index, key)
        local entry = { }
        entry.startNode = self.xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
        if entry.startNode ~ = nil then
            entry.railingWidth = self.xmlFile:getValue(key .. ".railing#width" )
            entry.wrapUsage = self.xmlFile:getValue(key .. "#wrapUsage" , 0.1 ) / 60 / 1000

            entry.inlineBaleFilename = Utils.getFilename( self.xmlFile:getValue(key .. ".inlineBale#filename" ), self.baseDirectory)
            if entry.inlineBaleFilename ~ = nil then
                entry.diameter = MathUtil.round( self.xmlFile:getValue(key .. ".size#diameter" , 0 ), 2 )
                entry.width = MathUtil.round( self.xmlFile:getValue(key .. ".size#width" , 0 ), 2 )
                entry.isRoundBale = entry.diameter ~ = 0
                if not entry.isRoundBale then
                    entry.height = MathUtil.round( self.xmlFile:getValue(key .. ".size#height" , 0 ), 2 )
                    entry.length = MathUtil.round( self.xmlFile:getValue(key .. ".size#length" , 0 ), 2 )
                end

                entry.index = #spec.baleTypes + 1

                table.insert(spec.baleTypes, entry)
            else
                    Logging.xmlError( self.xmlFile, "Failed to load bale type.Missing inline bale filename! '%s'" , key)
                end
            else
                    Logging.xmlError( self.xmlFile, "Failed to load bale type.Missing start node! '%s'" , key)
                end
            end )

            spec.railingsAnimation = self.xmlFile:getValue(baseKey .. ".railings#animation" )
            spec.railingsAnimationStartX = self.xmlFile:getValue(baseKey .. ".railings#animStartX" )
            spec.railingsAnimationEndX = self.xmlFile:getValue(baseKey .. ".railings#animEndX" )
            spec.railingStartX = self.xmlFile:getValue(baseKey .. ".railings#defaultX" , 1 )
            spec.currentPosition = spec.railingStartX + 0.01
            spec.targetPosition = spec.railingStartX + 0.01

            spec.wrappingStartNode = self.xmlFile:getValue(baseKey .. ".wrapping#startNode" , nil , self.components, self.i3dMappings)

            spec.steeringNodes = { }
            self.xmlFile:iterate(baseKey .. ".steeringNodes.steeringNode" , function (_, key)
                local entry = { }
                entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)

                if entry.node ~ = nil then
                    entry.startRot = { getRotation(entry.node) }
                    table.insert(spec.steeringNodes, entry)
                end
            end )

            spec.wrappingNodes = { }
            self.xmlFile:iterate(baseKey .. ".wrappingNodes.wrappingNode" , function (_, key)
                local entry = { }
                entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                entry.target = self.xmlFile:getValue(key .. "#target" , nil , self.components, self.i3dMappings)

                if entry.node ~ = nil and entry.target ~ = nil then
                    entry.startTrans = self.xmlFile:getValue(key .. "#startTrans" , nil , true ) or { getTranslation(entry.target) }
                    setTranslation(entry.target, entry.startTrans[ 1 ], entry.startTrans[ 2 ], entry.startTrans[ 3 ])

                    table.insert(spec.wrappingNodes, entry)
                end
            end )

            spec.animations = { }
            spec.animations.pusher = self.xmlFile:getValue(baseKey .. ".animations#pusher" , "pusherAnimation" )
            spec.animations.wrapping = self.xmlFile:getValue(baseKey .. ".animations#wrapping" , "wrappingAnimation" )
            spec.animations.pushOff = self.xmlFile:getValue(baseKey .. ".animations#pushOff" , "pushOffAnimation" )

            spec.pushingBrakeForce = self.xmlFile:getValue(baseKey .. ".pushing#brakeForce" , 0 )
            spec.pushingOpenBrakeTime = self.xmlFile:getValue(baseKey .. ".pushing#openBrakeTime" , 0.1 )
            spec.pushingCloseBrakeTime = self.xmlFile:getValue(baseKey .. ".pushing#closeBrakeTime" , 0.5 )
            spec.pushingMinBaleAmount = self.xmlFile:getValue(baseKey .. ".pushing#minBaleAmount" , 4 )

            spec.baleMovedThreshold = self.xmlFile:getValue(baseKey .. "#baleMovedThreshold" , 0.05 )

            spec.pusherAnimationDirty = false
            spec.showIncompatibleBalesWarning = false

            spec.pendingSingleBales = { }
            spec.pendingIncompatibleBales = { }
            spec.enteredInlineBales = { }
            spec.enteredBalesToWrap = { }

            spec.numObjectBits = self.xmlFile:getValue( "vehicle.inlineWrapper#numObjectBits" , 4 )
            spec.inlineBalesDirtyFlag = self:getNextDirtyFlag()
            spec.warningDirtyFlag = self:getNextDirtyFlag()

            spec.currentLineDirection = nil
            spec.lineDirection = nil
            spec.activatable = InlineWrapperActivatable.new( self )

            if self.isClient then
                spec.samples = { }
                spec.samples.wrap = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "wrap" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                spec.samples.start = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "start" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                spec.samples.stop = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "stop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
            end
        end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function InlineWrapper:onPostLoad(savegame)
    local spec = self.spec_inlineWrapper
    if spec.railingsAnimation ~ = nil then
        self:setAnimationTime(spec.railingsAnimation, 1 , true )
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
function InlineWrapper:onReadStream(streamId, connection)
    self:readInlineBales( "pendingSingleBales" , streamId, connection)
    self:readInlineBales( "enteredInlineBales" , streamId, connection)
    self:readInlineBales( "enteredBalesToWrap" , streamId, connection)

    if streamReadBool(streamId) then
        local inlineBale = NetworkUtil.readNodeObjectId(streamId)
        self:setCurrentInlineBale(inlineBale, true )
    else
            self:setCurrentInlineBale( nil , true )
        end

        local spec = self.spec_inlineWrapper
        spec.showIncompatibleBalesWarning = streamReadBool(streamId)

        g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
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
function InlineWrapper:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_inlineWrapper

        if streamReadBool(streamId) then
            self:readInlineBales( "pendingSingleBales" , streamId, connection)
            self:readInlineBales( "enteredInlineBales" , streamId, connection)
            self:readInlineBales( "enteredBalesToWrap" , streamId, connection)

            if streamReadBool(streamId) then
                local inlineBale = NetworkUtil.readNodeObjectId(streamId)
                self:setCurrentInlineBale(inlineBale, true )
            else
                    self:setCurrentInlineBale( nil , true )
                end

                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            end

            spec.showIncompatibleBalesWarning = streamReadBool(streamId)
        end
    end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function InlineWrapper:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_inlineWrapper
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInput then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.ACTIVATE_OBJECT, self , InlineWrapper.pushOffInlineBaleEvent, false , false , true , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventActive(actionEventId, self:getCanPushOff())
            g_inputBinding:setActionEventTextVisibility(actionEventId, true )
            g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_baleloaderUnload" ))
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
function InlineWrapper:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_inlineWrapper
    if self:getIsAnimationPlaying(spec.animations.wrapping) then
        self:updateWrappingNodes()
    end
end

```

### onUpdateTick

**Description**

> Called on update tick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function InlineWrapper:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_inlineWrapper
    if self.isServer then
        local pendingBaleId = next(spec.pendingSingleBales)
        local pendingBale = NetworkUtil.getObject(pendingBaleId)
        if pendingBale ~ = nil and self:getIsInlineBalingAllowed() then
            local baleType = self:getWrapperBaleType(pendingBale)
            local lastBaleId = next(spec.enteredInlineBales)
            local lastBale = NetworkUtil.getObject(lastBaleId)
            local inlineBale
            local success = false
            if lastBale = = nil then
                -- first bale
                inlineBale = InlineBale.new( self.isServer, self.isClient)

                if inlineBale:loadFromConfigXML(baleType.inlineBaleFilename) then
                    inlineBale:setOwnerFarmId( self:getActiveFarm(), true )

                    inlineBale:setCurrentWrapperInfo( self , spec.wrappingStartNode)

                    inlineBale:register()

                    success = inlineBale:addBale(pendingBale, baleType)
                else
                        inlineBale:delete()
                    end
                else
                        -- add another bale
                        if lastBale:isa( InlineBaleSingle ) then
                            inlineBale = lastBale:getConnectedInlineBale()
                            if inlineBale ~ = nil then

                                success = inlineBale:addBale(pendingBale, baleType)

                                if success then
                                    local currentInlineBale = self:getCurrentInlineBale()
                                    currentInlineBale:setCurrentWrapperInfo( self , spec.wrappingStartNode)
                                end
                            end
                        end
                    end

                    if success then
                        spec.pendingSingleBales[pendingBaleId] = nil
                        spec.enteredInlineBales[pendingBaleId] = pendingBaleId

                        spec.pusherAnimationDirty = true
                        self:setCurrentInlineBale(inlineBale)

                        g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)

                        local total, _ = g_farmManager:updateFarmStats( self:getOwnerFarmId(), "wrappedBales" , 1 )
                        if total ~ = nil then
                            g_achievementManager:tryUnlock( "WrappedBales" , total)
                        end

                        self:raiseDirtyFlags(spec.inlineBalesDirtyFlag)
                    end
                end

                local showIncompatibleBalesWarning = next(spec.pendingIncompatibleBales) ~ = nil
                if showIncompatibleBalesWarning ~ = spec.showIncompatibleBalesWarning then
                    spec.showIncompatibleBalesWarning = showIncompatibleBalesWarning
                    self:raiseDirtyFlags(spec.warningDirtyFlag)
                end
            end

            -- set currentInlineBale not matter if a new bale ist getting mounted(necessary for clients and singleplayer if the savegame if reloaded)
                local inlineBaleId = next(spec.enteredInlineBales)
                local bale = NetworkUtil.getObject(inlineBaleId)
                if bale ~ = nil then
                    if self:getCurrentInlineBale() = = nil then
                        if bale:isa( InlineBaleSingle ) then
                            local inlineBale = bale:getConnectedInlineBale()
                            if inlineBale ~ = nil then
                                self:setCurrentInlineBale(inlineBale)

                                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)

                                self:updateWrappingNodes()

                                local currentInlineBale = self:getCurrentInlineBale()
                                currentInlineBale:setCurrentWrapperInfo( self , spec.wrappingStartNode)
                            end
                        end
                    end
                else
                        self:setCurrentInlineBale( nil )
                    end

                    local needsSteering = ( next(spec.enteredInlineBales) ~ = nil or spec.pushOffStarted) and self:getAttacherVehicle() = = nil
                    local steeringActive = needsSteering and not self:getIsControlled()

                    if spec.lineDirection = = nil and needsSteering then
                        local x, _, z = localDirectionToWorld( self.components[ 1 ].node, 0 , 0 , - 1 )
                        spec.lineDirection = { x, z }
                    elseif spec.lineDirection ~ = nil and not needsSteering then
                            spec.lineDirection = nil
                        end

                        if not steeringActive then
                            if spec.currentLineDirection ~ = nil then
                                spec.currentLineDirection = nil
                                self:updateInlineSteeringWheels()
                            end
                        else
                                spec.currentLineDirection = spec.lineDirection
                            end

                            if spec.currentLineDirection ~ = nil then
                                self:updateInlineSteeringWheels(spec.currentLineDirection[ 1 ], spec.currentLineDirection[ 2 ])
                            end

                            if self.isServer then
                                spec.releaseBrake = false
                                local currentInlineBale = self:getCurrentInlineBale()

                                if spec.pusherAnimationDirty then
                                    local allowedToPush = true

                                    for _, baleId in pairs(spec.pendingSingleBales) do
                                        if not self:getAllowBalePushing(NetworkUtil.getObject(baleId)) then
                                            allowedToPush = false
                                            break
                                        end
                                    end

                                    if allowedToPush then
                                        for _, baleId in pairs(spec.enteredInlineBales) do
                                            if not self:getAllowBalePushing(NetworkUtil.getObject(baleId)) then
                                                allowedToPush = false
                                                break
                                            end
                                        end
                                    end

                                    if allowedToPush then
                                        if currentInlineBale ~ = nil then
                                            local pendingBale = currentInlineBale:getPendingBale()
                                            local pendingBaleId = NetworkUtil.getObjectId(pendingBale)
                                            local baleType = self:getWrapperBaleType(pendingBale)

                                            local replaced, newBaleId = currentInlineBale:replacePendingBale(baleType.startNode, spec.wrapColor)
                                            if replaced then
                                                spec.enteredInlineBales[pendingBaleId] = nil
                                                spec.enteredInlineBales[newBaleId] = newBaleId
                                            end

                                            self:playAnimation(spec.animations.pusher, 1 , 0 )
                                            spec.pusherAnimationDirty = false
                                            currentInlineBale:connectPendingBale()
                                            self:raiseDirtyFlags(spec.inlineBalesDirtyFlag)
                                        end
                                    end

                                    self:raiseActive()
                                end

                                if self:getAttacherVehicle() = = nil then
                                    local allowBrakeOpening = true
                                    if currentInlineBale ~ = nil then
                                        if currentInlineBale:getNumberOfBales() < spec.pushingMinBaleAmount then
                                            allowBrakeOpening = false
                                        end
                                    end

                                    local animTime = self:getAnimationTime(spec.animations.pusher)
                                    local isPushing = self:getIsAnimationPlaying(spec.animations.pusher) and animTime > spec.pushingOpenBrakeTime and animTime < spec.pushingCloseBrakeTime
                                    local currentSpeed = self:getAnimationSpeed(spec.animations.pushOff)
                                    local isPushingOff = self:getIsAnimationPlaying(spec.animations.pushOff) and currentSpeed > 0

                                    local releaseBrake = isPushing or isPushingOff

                                    if allowBrakeOpening then
                                        spec.releaseBrake = releaseBrake
                                    end
                                end
                            end

                            local playWrapAnimation, wrapBaleType = false , nil
                            for _, wrapBaleId in pairs(spec.enteredBalesToWrap) do
                                local wrapBale = NetworkUtil.getObject(wrapBaleId)
                                if wrapBale ~ = nil then
                                    if entityExists(wrapBale.nodeId) then
                                        local x, y, z = localToLocal(wrapBale.nodeId, self.components[ 1 ].node, 0 , 0 , 0 )
                                        if wrapBale.lastWrapTranslation ~ = nil and wrapBale.lastWrapMoveTime ~ = nil then
                                            if math.abs(wrapBale.lastWrapTranslation[ 1 ] - x) + math.abs(wrapBale.lastWrapTranslation[ 2 ] - y) + math.abs(wrapBale.lastWrapTranslation[ 3 ] - z) > spec.baleMovedThreshold then
                                                wrapBale.lastWrapMoveTime = g_currentMission.time
                                                wrapBale.lastWrapTranslation = { x, y, z }
                                            end
                                        else
                                                wrapBale.lastWrapMoveTime = - math.huge
                                                wrapBale.lastWrapTranslation = { x, y, z }
                                            end

                                            if wrapBale.lastWrapMoveTime + 1500 > g_currentMission.time then
                                                playWrapAnimation = true
                                                wrapBaleType = self:getWrapperBaleType(wrapBale)
                                                break
                                            end

                                            self:raiseActive()
                                        end
                                    end
                                end

                                if playWrapAnimation then
                                    if self.isServer and wrapBaleType ~ = nil then
                                        self:updateConsumable( InlineWrapper.CONSUMABLE_TYPE_NAME, - wrapBaleType.wrapUsage * dt, true )
                                    end

                                    if not self:getIsAnimationPlaying(spec.animations.wrapping) then
                                        self:playAnimation(spec.animations.wrapping, 1 , self:getAnimationTime(spec.animations.wrapping), true )
                                    end

                                    if self.isClient then
                                        if not g_soundManager:getIsSamplePlaying(spec.samples.start) and not g_soundManager:getIsSamplePlaying(spec.samples.wrap ) then
                                            g_soundManager:playSample(spec.samples.start)
                                            g_soundManager:playSample(spec.samples.wrap , 0 , spec.samples.start)
                                        end
                                    end
                                else
                                        self:stopAnimation(spec.animations.wrapping, true )

                                        if self.isClient then
                                            if g_soundManager:getIsSamplePlaying(spec.samples.start) or g_soundManager:getIsSamplePlaying(spec.samples.wrap ) then
                                                g_soundManager:stopSample(spec.samples.start)
                                                g_soundManager:stopSample(spec.samples.wrap )
                                                g_soundManager:playSample(spec.samples.stop)
                                            end
                                        end
                                    end

                                    local baleId = next(spec.pendingSingleBales) or next(spec.enteredInlineBales)
                                    bale = NetworkUtil.getObject(baleId)
                                    if bale ~ = nil then
                                        if self:getIsInlineBalingAllowed() then
                                            local baleType = self:getWrapperBaleType(bale)

                                            local currentInlineBale = self:getCurrentInlineBale()
                                            if currentInlineBale ~ = nil then
                                                if not currentInlineBale:getIsBaleAllowed(bale, baleType) then
                                                    baleType = nil
                                                end
                                            end

                                            if baleType ~ = nil then
                                                spec.targetPosition = baleType.railingWidth

                                                self:updateWrapperRailings(spec.targetPosition, dt)
                                            end
                                        end
                                    else
                                            self:updateWrapperRailings(spec.railingStartX, dt)
                                        end

                                        -- reset push off arm
                                        if self.isServer then
                                            if spec.pushOffStarted ~ = nil and spec.pushOffStarted then
                                                if not self:getIsAnimationPlaying(spec.animations.pushOff) then
                                                    self:playAnimation(spec.animations.pushOff, - 1 , 1 )
                                                    spec.pushOffStarted = nil
                                                end
                                            end
                                        end

                                        if self.isClient then
                                            local actionEvent = spec.actionEvents[InputAction.ACTIVATE_OBJECT]
                                            if actionEvent ~ = nil then
                                                g_inputBinding:setActionEventActive(actionEvent.actionEventId, self:getCanPushOff())
                                            end
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
function InlineWrapper:onWriteStream(streamId, connection)
    self:writeInlineBales( "pendingSingleBales" , streamId, connection)
    self:writeInlineBales( "enteredInlineBales" , streamId, connection)
    self:writeInlineBales( "enteredBalesToWrap" , streamId, connection)

    local currentInlineBale = self:getCurrentInlineBale()
    if streamWriteBool(streamId, currentInlineBale ~ = nil ) then
        NetworkUtil.writeNodeObject(streamId, currentInlineBale)
    end

    streamWriteBool(streamId, self.spec_inlineWrapper.showIncompatibleBalesWarning)
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
function InlineWrapper:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_inlineWrapper

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.inlineBalesDirtyFlag) ~ = 0 ) then
            self:writeInlineBales( "pendingSingleBales" , streamId, connection)
            self:writeInlineBales( "enteredInlineBales" , streamId, connection)
            self:writeInlineBales( "enteredBalesToWrap" , streamId, connection)

            local currentInlineBale = self:getCurrentInlineBale()
            if streamWriteBool(streamId, currentInlineBale ~ = nil ) then
                NetworkUtil.writeNodeObject(streamId, currentInlineBale)
            end
        end

        streamWriteBool(streamId, spec.showIncompatibleBalesWarning)
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
function InlineWrapper.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Foldable , specializations) and SpecializationUtil.hasSpecialization(Consumable, specializations)
end

```

### pushOffInlineBale

**Description**

**Definition**

> pushOffInlineBale()

**Code**

```lua
function InlineWrapper:pushOffInlineBale()
    local spec = self.spec_inlineWrapper
    if not self:getIsAnimationPlaying(spec.animations.pushOff) then
        self:playAnimation(spec.animations.pushOff, 1 )
        spec.pushOffStarted = true
    end
end

```

### pushOffInlineBaleEvent

**Description**

**Definition**

> pushOffInlineBaleEvent()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function InlineWrapper.pushOffInlineBaleEvent( self , actionName, inputValue, callbackState, isAnalog)
    if inputValue = = 1 then
        if g_server ~ = nil then
            self:pushOffInlineBale()
        else
                g_client:getServerConnection():sendEvent( InlineWrapperPushOffEvent.new( self ))
            end
        end
    end

```

### readInlineBales

**Description**

**Definition**

> readInlineBales()

**Arguments**

| any | name       |
|-----|------------|
| any | streamId   |
| any | connection |

**Code**

```lua
function InlineWrapper:readInlineBales(name, streamId, connection)
    local spec = self.spec_inlineWrapper
    local sum = streamReadUIntN(streamId, spec.numObjectBits)

    spec[name] = { }
    for _ = 1 , sum do
        local object = NetworkUtil.readNodeObjectId(streamId)
        spec[name][object] = object
    end
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
function InlineWrapper.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , InlineWrapper )
    SpecializationUtil.registerEventListener(vehicleType, "onConsumableVariationChanged" , InlineWrapper )
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
function InlineWrapper.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "readInlineBales" , InlineWrapper.readInlineBales)
    SpecializationUtil.registerFunction(vehicleType, "writeInlineBales" , InlineWrapper.writeInlineBales)
    SpecializationUtil.registerFunction(vehicleType, "getIsInlineBalingAllowed" , InlineWrapper.getIsInlineBalingAllowed)
    SpecializationUtil.registerFunction(vehicleType, "inlineBaleTriggerCallback" , InlineWrapper.inlineBaleTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "inlineWrapTriggerCallback" , InlineWrapper.inlineWrapTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "updateWrappingNodes" , InlineWrapper.updateWrappingNodes)
    SpecializationUtil.registerFunction(vehicleType, "updateRoundBaleWrappingNode" , InlineWrapper.updateRoundBaleWrappingNode)
    SpecializationUtil.registerFunction(vehicleType, "updateSquareBaleWrappingNode" , InlineWrapper.updateSquareBaleWrappingNode)
    SpecializationUtil.registerFunction(vehicleType, "getWrapperBaleType" , InlineWrapper.getWrapperBaleType)
    SpecializationUtil.registerFunction(vehicleType, "getAllowBalePushing" , InlineWrapper.getAllowBalePushing)
    SpecializationUtil.registerFunction(vehicleType, "updateWrapperRailings" , InlineWrapper.updateWrapperRailings)
    SpecializationUtil.registerFunction(vehicleType, "updateInlineSteeringWheels" , InlineWrapper.updateInlineSteeringWheels)
    SpecializationUtil.registerFunction(vehicleType, "getCanInteract" , InlineWrapper.getCanInteract)
    SpecializationUtil.registerFunction(vehicleType, "getCanPushOff" , InlineWrapper.getCanPushOff)
    SpecializationUtil.registerFunction(vehicleType, "setCurrentInlineBale" , InlineWrapper.setCurrentInlineBale)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentInlineBale" , InlineWrapper.getCurrentInlineBale)
    SpecializationUtil.registerFunction(vehicleType, "pushOffInlineBale" , InlineWrapper.pushOffInlineBale)
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
function InlineWrapper.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , InlineWrapper.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsActive" , InlineWrapper.getIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getBrakeForce" , InlineWrapper.getBrakeForce)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShowConsumableEmptyWarning" , InlineWrapper.getShowConsumableEmptyWarning)
end

```

### setCurrentInlineBale

**Description**

**Definition**

> setCurrentInlineBale()

**Arguments**

| any | inlineBale |
|-----|------------|
| any | isClient   |

**Code**

```lua
function InlineWrapper:setCurrentInlineBale(inlineBale, isClient)
    local spec = self.spec_inlineWrapper
    if self.isServer then
        local newInlineBale = NetworkUtil.getObjectId(inlineBale)
        if newInlineBale ~ = spec.currentInlineBale then
            spec.currentInlineBale = newInlineBale
            self:raiseDirtyFlags(spec.inlineBalesDirtyFlag)
        end
    end

    if isClient then
        spec.currentInlineBale = inlineBale
    end
end

```

### updateInlineSteeringWheels

**Description**

**Definition**

> updateInlineSteeringWheels()

**Arguments**

| any | dirX |
|-----|------|
| any | dirZ |

**Code**

```lua
function InlineWrapper:updateInlineSteeringWheels(dirX, dirZ)
    local spec = self.spec_inlineWrapper

    for _, steeringNode in ipairs(spec.steeringNodes) do
        if dirX = = nil or dirZ = = nil then
            setRotation(steeringNode.node, unpack(steeringNode.startRot))
        else
                local px, py, pz = getWorldTranslation(steeringNode.node)
                local targetX, _, targetZ = worldToLocal(getParent(steeringNode.node), px + (dirX) * 10 , py, pz + (dirZ) * 10 )
                targetX, _, targetZ = MathUtil.vector3Normalize(targetX, 0 , targetZ)

                local upX, upY, upZ = localDirectionToWorld(getParent(steeringNode.node), 0 , 1 , 0 )
                setDirection(steeringNode.node, targetX, 0 , targetZ, upX, upY, upZ)
            end

            if self.setMovingToolDirty ~ = nil then
                self:setMovingToolDirty(steeringNode.node)
            end
        end
    end

```

### updateRoundBaleWrappingNode

**Description**

**Definition**

> updateRoundBaleWrappingNode()

**Arguments**

| any | bale         |
|-----|--------------|
| any | wrappingNode |
| any | x            |
| any | y            |
| any | z            |

**Code**

```lua
function InlineWrapper:updateRoundBaleWrappingNode(bale, wrappingNode, x, y, z)
    local baleNode = bale.nodeId
    local baleRadius = bale.diameter / 2
    local steps = 32
    local intersectOffset = 0.01
    local foilOffset = - 0.03

    local w1x, w1y, w1z = worldToLocal(baleNode, x, y, z)

    local distanceToCenter = MathUtil.vector3Length(w1x, w1y, 0 )
    local maxDirY = - math.huge
    local targetX, targetY, targetZ
    for i = 1 , steps do
        local a = (i / steps) * 2 * math.pi

        local c = math.cos(a) * (baleRadius + intersectOffset)
        local s = math.sin(a) * (baleRadius + intersectOffset)

        local distance = MathUtil.vector2Length(c - w1x, s - w1y)
        if distance < distanceToCenter then
            local intersect, _, _, _, _ = MathUtil.getCircleLineIntersection( 0 , 0 , baleRadius, w1x, w1y, c, s)

            if not intersect then
                local px, py, pz = localToWorld(baleNode, c, s, 0 )
                local _, wrapDirY, _ = worldToLocal(wrappingNode, px, py, pz)
                if wrapDirY > maxDirY then
                    maxDirY = wrapDirY

                    targetX, targetY, targetZ = localToWorld(baleNode, math.cos(a) * (baleRadius + foilOffset), math.sin(a) * (baleRadius + foilOffset), w1z)
                end
            end
        end
    end

    return targetX, targetY, targetZ
end

```

### updateSquareBaleWrappingNode

**Description**

**Definition**

> updateSquareBaleWrappingNode()

**Arguments**

| any | bale         |
|-----|--------------|
| any | wrappingNode |
| any | x            |
| any | y            |
| any | z            |

**Code**

```lua
function InlineWrapper:updateSquareBaleWrappingNode(bale, wrappingNode, x, y, z)
    local baleNode = bale.nodeId

    local minAngle = math.huge
    local targetX, targetY, targetZ
    local height = bale.height / 2
    local length = bale.length / 2
    local intersectOffset = 0.01
    local foilOffset = - 0.05

    local w1x, w1y, w1z = worldToLocal(baleNode, x, y, z)

    if bale.wrappingEdges = = nil then
        bale.wrappingEdges = { }
        bale.wrappingEdges[ 1 ] = { 0 , height, - length }
        bale.wrappingEdges[ 2 ] = { 0 , - height, - length }
        bale.wrappingEdges[ 3 ] = { 0 , - height, length }
        bale.wrappingEdges[ 4 ] = { 0 , height, length }
    end

    for _, edge in ipairs(bale.wrappingEdges) do
        local edgeY = edge[ 2 ] + math.sign(edge[ 2 ]) * intersectOffset
        local edgeZ = edge[ 3 ] + math.sign(edge[ 3 ]) * intersectOffset

        local intersect = false
        for i = 1 , 4 do
            local i2 = i < = 3 and i + 1 or 1
            intersect = intersect or MathUtil.getLineBoundingVolumeIntersect(edgeY, edgeZ, w1y, w1z, bale.wrappingEdges[i][ 2 ], bale.wrappingEdges[i][ 3 ], bale.wrappingEdges[i2][ 2 ], bale.wrappingEdges[i2][ 3 ])
        end

        if not intersect then
            local px, py, pz = localToWorld(baleNode, w1x, edgeY, edgeZ)
            local _, wrapDirY, wrapDirZ = worldToLocal(wrappingNode, px, py, pz)
            local angle = MathUtil.getYRotationFromDirection(wrapDirY, wrapDirZ)

            if angle < 0 then
                angle = math.pi + ( math.pi + angle)
            end

            if angle < minAngle then
                minAngle = angle

                targetX, targetY, targetZ = localToWorld(baleNode, w1x, edge[ 2 ] + math.sign(edge[ 2 ]) * foilOffset, edge[ 3 ] + math.sign(edge[ 3 ]) * foilOffset)
            end
        end
    end

    return targetX, targetY, targetZ
end

```

### updateWrapperRailings

**Description**

**Definition**

> updateWrapperRailings()

**Arguments**

| any | targetPosition |
|-----|----------------|
| any | dt             |

**Code**

```lua
function InlineWrapper:updateWrapperRailings(targetPosition, dt)
    local spec = self.spec_inlineWrapper
    if targetPosition ~ = spec.currentPosition then
        local dir = math.sign(targetPosition - spec.currentPosition)
        spec.currentPosition = spec.currentPosition + 0.0001 * dt * dir
        if dir > 0 then
            spec.currentPosition = math.min(spec.currentPosition, targetPosition)
        else
                spec.currentPosition = math.max(spec.currentPosition, targetPosition)
            end

            local animTime = (spec.currentPosition - spec.railingsAnimationStartX) / (spec.railingsAnimationEndX - spec.railingsAnimationStartX)
            self:setAnimationTime(spec.railingsAnimation, animTime, true )
        end
    end

```

### updateWrappingNodes

**Description**

**Definition**

> updateWrappingNodes()

**Code**

```lua
function InlineWrapper:updateWrappingNodes()
    local spec = self.spec_inlineWrapper

    local inlineBale = self:getCurrentInlineBale()
    if inlineBale ~ = nil then
        local bales = spec.enteredBalesToWrap

        for _, wrappingNode in ipairs(spec.wrappingNodes) do
            local x, y, z = getWorldTranslation(wrappingNode.node)
            local minDistance = math.huge
            local minBale
            for _, baleId in pairs(bales) do
                local bale = NetworkUtil.getObject(baleId)
                if bale ~ = nil then
                    if bale ~ = inlineBale:getPendingBale() then
                        local bx, _, bz = worldToLocal(bale.nodeId, x, y, z)
                        local x1, y1, z1
                        local x2, y2, z2
                        if bale.isRoundbale then
                            if bz > = - bale.width / 2 then
                                x1, y1, z1 = localToWorld(bale.nodeId, 0 , 0 , bale.width / 2 )
                                x2, y2, z2 = localToWorld(bale.nodeId, 0 , 0 , - bale.width / 2 )
                            end
                        else
                                if bx > = - bale.width / 2 then
                                    x1, y1, z1 = localToWorld(bale.nodeId, bale.width / 2 , 0 , 0 )
                                    x2, y2, z2 = localToWorld(bale.nodeId, - bale.width / 2 , 0 , 0 )
                                end
                            end

                            if x1 ~ = nil then
                                local distance = math.min( MathUtil.vector3Length(x - x1, y - y1, z - z1), MathUtil.vector3Length(x - x2, y - y2, z - z2))
                                if distance < minDistance then
                                    minDistance = distance
                                    minBale = bale
                                end
                            end
                        end
                    end
                end

                if minBale ~ = nil then
                    local targetX, targetY, targetZ
                    if minBale.isRoundbale then
                        targetX, targetY, targetZ = self:updateRoundBaleWrappingNode(minBale, wrappingNode.node, x, y, z)
                    else
                            targetX, targetY, targetZ = self:updateSquareBaleWrappingNode(minBale, wrappingNode.node, x, y, z)
                        end

                        if targetX ~ = nil then
                            targetX, targetY, targetZ = worldToLocal(getParent(wrappingNode.target), targetX, targetY, targetZ)
                            setTranslation(wrappingNode.target, targetX, targetY, targetZ)
                        else
                                setTranslation(wrappingNode.target, wrappingNode.startTrans[ 1 ], wrappingNode.startTrans[ 2 ], wrappingNode.startTrans[ 3 ])
                            end
                        else
                                setTranslation(wrappingNode.target, wrappingNode.startTrans[ 1 ], wrappingNode.startTrans[ 2 ], wrappingNode.startTrans[ 3 ])
                            end
                        end

                        spec.resetWrappingNodes = true
                    else
                            if spec.resetWrappingNodes then
                                for _, wrappingNode in ipairs(spec.wrappingNodes) do
                                    setTranslation(wrappingNode.target, wrappingNode.startTrans[ 1 ], wrappingNode.startTrans[ 2 ], wrappingNode.startTrans[ 3 ])
                                end

                                spec.resetWrappingNodes = nil
                            end
                        end
                    end

```

### writeInlineBales

**Description**

**Definition**

> writeInlineBales()

**Arguments**

| any | name       |
|-----|------------|
| any | streamId   |
| any | connection |

**Code**

```lua
function InlineWrapper:writeInlineBales(name, streamId, connection)
    local spec = self.spec_inlineWrapper
    local num = table.size(spec[name])
    streamWriteUIntN(streamId, num, spec.numObjectBits)

    local objectIndex = 0
    for object,_ in pairs(spec[name]) do
        objectIndex = objectIndex + 1
        if objectIndex < = num then
            NetworkUtil.writeNodeObjectId(streamId, object)
        else
                Logging.xmlWarning( self.xmlFile, "Not enough bits to send all inline objects.Please increase '%s'" , "vehicle.inlineWrapper#numObjectBits" )
            end
        end
    end

```