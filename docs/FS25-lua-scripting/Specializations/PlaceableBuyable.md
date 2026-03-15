## PlaceableBuyable

**Description**

> Specialization for placeables

**Functions**

- [buyRequest](#buyrequest)
- [onBuyingTriggerCallback](#onbuyingtriggercallback)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setOwnerFarmId](#setownerfarmid)

### buyRequest

**Description**

**Definition**

> buyRequest()

**Arguments**

| any | requestCallback |
|-----|-----------------|
| any | target          |

**Code**

```lua
function PlaceableBuyable:buyRequest(requestCallback, target)
    if g_guidedTourManager:getIsTourRunning() then
        InfoDialog.show(g_i18n:getText( "guidedTour_feature_deactivated" ))
        return
    end

    local playerFarmId = g_currentMission:getFarmId()

    local price = self:getPrice()
    if self.buysFarmland then
        local farmlandId = self:getFarmlandId()
        local farmland = g_farmlandManager:getFarmlandById(farmlandId)
        if farmland ~ = nil and g_farmlandManager:getFarmlandOwner(farmlandId) ~ = playerFarmId then
            price = price + farmland.price * self.buysFarmlandPriceScale
        end
    end

    local placeable = self
    local buyingEventCallback = function (statusCode)
        if statusCode ~ = nil then
            local dialogArgs = BuyExistingPlaceableEvent.DIALOG_MESSAGES[statusCode]
            if dialogArgs ~ = nil then
                InfoDialog.show(g_i18n:getText(dialogArgs.text), nil , nil , dialogArgs.dialogType)
            end
        end
        g_messageCenter:unsubscribe(BuyExistingPlaceableEvent, placeable)

        placeable:onBuy()
    end

    local dialogCallback = function (yes)
        if yes then
            g_messageCenter:subscribe(BuyExistingPlaceableEvent, buyingEventCallback)

            g_client:getServerConnection():sendEvent(BuyExistingPlaceableEvent.new( self , playerFarmId))
        end

        if requestCallback ~ = nil then
            if target ~ = nil then
                target:requestCallback(yes)
            else
                    requestCallback(yes)
                end
            end
        end

        YesNoDialog.show(dialogCallback, nil , string.format(g_i18n:getText( "dialog_buyBuildingFor" ), self:getName(), g_i18n:formatMoney(price, 0 , true )))
    end

```

### onBuyingTriggerCallback

**Description**

**Definition**

> onBuyingTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherId      |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function PlaceableBuyable:onBuyingTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay, otherShapeId)
    if onEnter or onLeave then
        if g_localPlayer and g_localPlayer.rootNode = = otherId then
            local spec = self.spec_buyable
            if onEnter and spec.isTriggerActive then
                -- automatically perform action without manual activation on mobile
                if Platform.gameplay.autoActivateTrigger and spec.activatable:getIsActivatable() then
                    spec.activatable:run()
                    return
                end

                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            end
            if onLeave then
                g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
            end
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
function PlaceableBuyable:onDelete()
    local spec = self.spec_buyable

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
    spec.activatable = nil

    if spec.markerNode ~ = nil then
        g_currentMission:removeTriggerMarker(spec.markerNode)
    end

    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
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
function PlaceableBuyable:onLoad(savegame)
    local spec = self.spec_buyable

    spec.activatable = BuyBuildingActivatable.new( self )

    spec.triggerNode = self.xmlFile:getValue( "placeable.buyable.trigger#node" , nil , self.components, self.i3dMappings)
    if spec.triggerNode ~ = nil then
        addTrigger(spec.triggerNode, "onBuyingTriggerCallback" , self )
    end

    spec.markerNode = self.xmlFile:getValue( "placeable.buyable.marker#node" , nil , self.components, self.i3dMappings)
    spec.isTriggerActive = true
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
function PlaceableBuyable.prerequisitesPresent(specializations)
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
function PlaceableBuyable.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableBuyable )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableBuyable )
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
function PlaceableBuyable.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onBuyingTriggerCallback" , PlaceableBuyable.onBuyingTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "setIsBuyingTriggerActive" , PlaceableBuyable.setIsBuyingTriggerActive)
    SpecializationUtil.registerFunction(placeableType, "buyRequest" , PlaceableBuyable.buyRequest)
    SpecializationUtil.registerFunction(placeableType, "getHasBuyingTrigger" , PlaceableBuyable.getHasBuyingTrigger)
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
function PlaceableBuyable.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableBuyable.setOwnerFarmId)
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
function PlaceableBuyable.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Buyable" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".buyable.trigger#node" , "Buying trigger" , nil , false )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".buyable.marker#node" , "Marker node" , nil , false )
    schema:setXMLSpecializationType()
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
function PlaceableBuyable:setOwnerFarmId(superFunc, farmId, noEventSend)
    superFunc( self , farmId, noEventSend)

    self:setIsBuyingTriggerActive(farmId = = AccessHandler.EVERYONE)
end

```