## Wearable

**Description**

> Specialization allowing vehicles to wear off (with visual and funcional consequences) and be repaired again

**Functions**

- [addAllSubWearableNodes](#addallsubwearablenodes)
- [addDamageAmount](#adddamageamount)
- [addToGlobalWearableNode](#addtoglobalwearablenode)
- [addToLocalWearableNode](#addtolocalwearablenode)
- [addWearableNode](#addwearablenode)
- [addWearAmount](#addwearamount)
- [calculateRepaintPrice](#calculaterepaintprice)
- [calculateRepairPrice](#calculaterepairprice)
- [getDamageAmount](#getdamageamount)
- [getDamageShowOnHud](#getdamageshowonhud)
- [getNodeWearAmount](#getnodewearamount)
- [getRepaintPrice](#getrepaintprice)
- [getRepairPrice](#getrepairprice)
- [getSpecValueCondition](#getspecvaluecondition)
- [getUsageCausesDamage](#getusagecausesdamage)
- [getUsageCausesWear](#getusagecauseswear)
- [getVehicleDamage](#getvehicledamage)
- [getWearMultiplier](#getwearmultiplier)
- [getWearTotalAmount](#getweartotalamount)
- [getWorkWearMultiplier](#getworkwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadSpecValueCondition](#loadspecvaluecondition)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onSaleItemSet](#onsaleitemset)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeAllSubWearableNodes](#removeallsubwearablenodes)
- [removeWearableNode](#removewearablenode)
- [repairVehicle](#repairvehicle)
- [saveToXMLFile](#savetoxmlfile)
- [setDamageAmount](#setdamageamount)
- [setNodeWearAmount](#setnodewearamount)
- [showInfo](#showinfo)
- [updateDamageAmount](#updatedamageamount)
- [updateDebugValues](#updatedebugvalues)
- [updateWearAmount](#updatewearamount)
- [validateWearableNode](#validatewearablenode)

### addAllSubWearableNodes

**Description**

**Definition**

> addAllSubWearableNodes()

**Arguments**

| any | rootNode |
|-----|----------|

**Code**

```lua
function Wearable:addAllSubWearableNodes(rootNode)
    if rootNode ~ = nil then
        I3DUtil.iterateShaderParameterNodesRecursively(rootNode, "scratches_dirt_snow_wetness" , self.addWearableNode, self )
    end
end

```

### addDamageAmount

**Description**

**Definition**

> addDamageAmount()

**Arguments**

| any | amount |
|-----|--------|
| any | force  |

**Code**

```lua
function Wearable:addDamageAmount(amount, force)
    local spec = self.spec_wearable
    self:setDamageAmount(spec.damage + amount, force)
end

```

### addToGlobalWearableNode

**Description**

**Definition**

> addToGlobalWearableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Wearable:addToGlobalWearableNode(node)
    local spec = self.spec_wearable
    if spec.wearableNodes[ 1 ] ~ = nil then
        spec.wearableNodes[ 1 ].nodes[node] = node
    end
end

```

### addToLocalWearableNode

**Description**

**Definition**

> addToLocalWearableNode()

**Arguments**

| any | node        |
|-----|-------------|
| any | updateFunc  |
| any | customIndex |
| any | extraParams |

**Code**

```lua
function Wearable:addToLocalWearableNode(node, updateFunc, customIndex, extraParams)
    local spec = self.spec_wearable

    local nodeData = { }

    --if wearableNode already exists we add node to existing wearableNode
        if customIndex ~ = nil then
            if spec.wearableNodesByIndex[customIndex] ~ = nil then
                spec.wearableNodesByIndex[customIndex].nodes[node] = node
                return
            else
                    spec.wearableNodesByIndex[customIndex] = nodeData
                end
            end

            --if wearableNode doesn't exists we create a new one
                nodeData.nodes = { }
                if node ~ = nil then
                    nodeData.nodes[node] = node
                end

                nodeData.updateFunc = updateFunc
                nodeData.wearAmount = 0
                nodeData.wearAmountSent = 0
                if extraParams ~ = nil then
                    for i, v in pairs(extraParams) do
                        nodeData[i] = v
                    end
                end

                table.insert(spec.wearableNodes, nodeData)
            end

```

### addWearableNode

**Description**

**Definition**

> addWearableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Wearable:addWearableNode(node)
    local isGlobal, updateFunc, customIndex, extraParams = self:validateWearableNode(node)
    if isGlobal then
        self:addToGlobalWearableNode(node)
    elseif updateFunc ~ = nil then
            self:addToLocalWearableNode(node, updateFunc, customIndex, extraParams)
        end
    end

```

### addWearAmount

**Description**

**Definition**

> addWearAmount()

**Arguments**

| any | wearAmount |
|-----|------------|
| any | force      |

**Code**

```lua
function Wearable:addWearAmount(wearAmount, force)
    local spec = self.spec_wearable
    if spec.wearableNodes ~ = nil then
        for _, nodeData in ipairs(spec.wearableNodes) do
            self:setNodeWearAmount(nodeData, self:getNodeWearAmount(nodeData) + wearAmount, force)
        end
    end
end

```

### calculateRepaintPrice

**Description**

> Also used by the sale system

**Definition**

> calculateRepaintPrice()

**Arguments**

| any | price |
|-----|-------|
| any | wear  |

**Code**

```lua
function Wearable.calculateRepaintPrice(price, wear)
    return price * math.sqrt(wear / 100 ) * 2
end

```

### calculateRepairPrice

**Description**

> Also used by the sale system

**Definition**

> calculateRepairPrice()

**Arguments**

| any | price  |
|-----|--------|
| any | damage |

**Code**

```lua
function Wearable.calculateRepairPrice(price, damage)
    -- up to 9% of the price at full damage
    -- repairing more often at low damages is rewarded - repairing always at 10% saves about half of the repair price
    return price * math.pow(damage, 1.5 ) * 0.09
end

```

### getDamageAmount

**Description**

> Get the amount of damage this vehicle has.

**Definition**

> getDamageAmount()

**Return Values**

| any | total |
|-----|-------|

**Code**

```lua
function Wearable:getDamageAmount()
    return self.spec_wearable.damage
end

```

### getDamageShowOnHud

**Description**

> Returns if the damage should be visualized on the hud

**Definition**

> getDamageShowOnHud()

**Return Values**

| any | showOnHud | show damage on hud |
|-----|-----------|--------------------|

**Code**

```lua
function Wearable:getDamageShowOnHud()
    return self.spec_wearable.showOnHud
end

```

### getNodeWearAmount

**Description**

**Definition**

> getNodeWearAmount()

**Arguments**

| any | nodeData |
|-----|----------|

**Code**

```lua
function Wearable:getNodeWearAmount(nodeData)
    return nodeData.wearAmount
end

```

### getRepaintPrice

**Description**

**Definition**

> getRepaintPrice()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Wearable:getRepaintPrice(superFunc)
    return superFunc( self ) + Wearable.calculateRepaintPrice( self:getPrice() , self:getWearTotalAmount())
end

```

### getRepairPrice

**Description**

> Get the price of a repair

**Definition**

> getRepairPrice()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Wearable:getRepairPrice(superFunc)
    return superFunc( self ) + Wearable.calculateRepairPrice( self:getPrice(), self.spec_wearable.damage)
end

```

### getSpecValueCondition

**Description**

**Definition**

> getSpecValueCondition()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function Wearable.getSpecValueCondition(storeItem, realItem)
    if realItem = = nil then
        return nil
    end

    if realItem.getDamageAmount = = nil then
        return nil
    end

    return string.format( "%d%%" , realItem:getDamageAmount() * 100 )
end

```

### getUsageCausesDamage

**Description**

> Damage causes lower performance which impacts mission results.

**Definition**

> getUsageCausesDamage()

**Code**

```lua
function Wearable:getUsageCausesDamage()
    if self.spec_motorized = = nil then
        if getIsSleeping( self.rootNode) then
            return false
        end
    end

    return self.isActive and self.propertyState ~ = VehiclePropertyState.MISSION
end

```

### getUsageCausesWear

**Description**

**Definition**

> getUsageCausesWear()

**Code**

```lua
function Wearable:getUsageCausesWear()
    return true
end

```

### getVehicleDamage

**Description**

> Get damage: affects how well the machine works

**Definition**

> getVehicleDamage()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Wearable:getVehicleDamage(superFunc)
    return math.min(superFunc( self ) + self.spec_wearable.damageByCurve, 1 )
end

```

### getWearMultiplier

**Description**

> Get wear multiplier

**Definition**

> getWearMultiplier()

**Return Values**

| any | multiplier |
|-----|------------|

**Code**

```lua
function Wearable:getWearMultiplier()
    local spec = self.spec_wearable

    local multiplier = 1
    if self:getLastSpeed() < 1 then
        multiplier = 0
    end

    if self.isOnField then
        multiplier = multiplier * spec.fieldMultiplier
    end

    return multiplier
end

```

### getWearTotalAmount

**Description**

> Get the total wear

**Definition**

> getWearTotalAmount()

**Return Values**

| any | total |
|-----|-------|

**Code**

```lua
function Wearable:getWearTotalAmount()
    return self.spec_wearable.totalAmount
end

```

### getWorkWearMultiplier

**Description**

> Get work wear multiplier

**Definition**

> getWorkWearMultiplier()

**Return Values**

| any | multiplier |
|-----|------------|

**Code**

```lua
function Wearable:getWorkWearMultiplier()
    local spec = self.spec_wearable

    return spec.workMultiplier
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Wearable.initSpecialization()
    if Platform.gameplay.hasVehicleDamage then
        g_storeManager:addSpecType( "wearable" , "shopListAttributeIconCondition" , Wearable.loadSpecValueCondition, Wearable.getSpecValueCondition, StoreSpecies.VEHICLE)
    end

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Wearable" )

    schema:register(XMLValueType.FLOAT, "vehicle.wearable#wearDuration" , "Duration until fully worn(minutes)" , 600 )
    schema:register(XMLValueType.FLOAT, "vehicle.wearable#workMultiplier" , "Multiplier while working" , 20 )
        schema:register(XMLValueType.FLOAT, "vehicle.wearable#fieldMultiplier" , "Multiplier while on field" , 2 )
            schema:register(XMLValueType.BOOL, "vehicle.wearable#showOnHud" , "Show the damage on the hud" , true )

            schema:setXMLSpecializationType()

            local schemaSavegame = Vehicle.xmlSchemaSavegame
            schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).wearable.wearNode(?)#amount" , "Wear amount" )
            schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).wearable#damage" , "Damage amount" )
        end

```

### loadSpecValueCondition

**Description**

**Definition**

> loadSpecValueCondition()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Wearable.loadSpecValueCondition(xmlFile, customEnvironment, baseDir)
    -- No data to load as this spec is only for existing items
        return nil
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
function Wearable:onLoad(savegame)
    local spec = self.spec_wearable

    spec.wearableNodes = { }
    spec.wearableNodesByIndex = { }
    self:addToLocalWearableNode( nil , Wearable.updateWearAmount, nil , nil ) -- create global / default wearableNode

    spec.wearDuration = self.xmlFile:getValue( "vehicle.wearable#wearDuration" , 600 ) * 60 * 1000 -- default 600min / 10h
    if spec.wearDuration ~ = 0 then
        spec.wearDuration = 1 / spec.wearDuration * Wearable.WEAR_FACTOR
    end

    spec.totalAmount = 0

    spec.damage = 0
    spec.damageByCurve = 0
    spec.damageSent = 0

    spec.workMultiplier = self.xmlFile:getValue( "vehicle.wearable#workMultiplier" , 20 )
    spec.fieldMultiplier = self.xmlFile:getValue( "vehicle.wearable#fieldMultiplier" , 2 )

    spec.showOnHud = self.xmlFile:getValue( "vehicle.wearable#showOnHud" , true )

    spec.dirtyFlag = self:getNextDirtyFlag()
end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Wearable:onLoadFinished(savegame)
    local spec = self.spec_wearable

    if savegame ~ = nil then
        spec.damage = savegame.xmlFile:getValue(savegame.key .. ".wearable#damage" , 0 )
        spec.damageByCurve = math.max(spec.damage - 0.3 , 0 ) / 0.7
    end

    -- getting als wearable nodes in postLoad to make sure also linked nodes are wearable
    if spec.wearableNodes ~ = nil then
        for _, component in pairs( self.components) do
            self:addAllSubWearableNodes(component.node)
        end

        if savegame ~ = nil then
            for i, nodeData in ipairs(spec.wearableNodes) do
                local nodeKey = string.format( "%s.wearable.wearNode(%d)" , savegame.key, i - 1 )
                local amount = savegame.xmlFile:getValue(nodeKey .. "#amount" , 0 )
                self:setNodeWearAmount(nodeData, amount, true )
            end
        else
                for _, nodeData in ipairs(spec.wearableNodes) do
                    self:setNodeWearAmount(nodeData, 0 , true )
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
function Wearable:onReadStream(streamId, connection)
    local spec = self.spec_wearable

    self:setDamageAmount(streamReadUIntN(streamId, Wearable.SEND_NUM_BITS) / Wearable.SEND_MAX_VALUE, true )

    if spec.wearableNodes ~ = nil then
        for _, nodeData in ipairs(spec.wearableNodes) do
            local wearAmount = streamReadUIntN(streamId, Wearable.SEND_NUM_BITS) / Wearable.SEND_MAX_VALUE
            self:setNodeWearAmount(nodeData, wearAmount, true )
        end
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
function Wearable:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_wearable

    if connection:getIsServer() then
        if streamReadBool(streamId) then
            self:setDamageAmount(streamReadUIntN(streamId, Wearable.SEND_NUM_BITS) / Wearable.SEND_MAX_VALUE, true )

            if spec.wearableNodes ~ = nil then
                for _, nodeData in ipairs(spec.wearableNodes) do
                    local wearAmount = streamReadUIntN(streamId, Wearable.SEND_NUM_BITS) / Wearable.SEND_MAX_VALUE
                    self:setNodeWearAmount(nodeData, wearAmount, true )
                end
            end
        end
    end
end

```

### onSaleItemSet

**Description**

**Definition**

> onSaleItemSet()

**Arguments**

| any | saleItem |
|-----|----------|

**Code**

```lua
function Wearable:onSaleItemSet(saleItem)
    self:addDamageAmount(saleItem.damage or 0 , true )
    self:addWearAmount(saleItem.wear or 0 , true )
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Wearable:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_wearable

    if spec.wearableNodes ~ = nil then
        if self.isServer then
            local changeAmount = self:updateDamageAmount(dt)
            if changeAmount ~ = 0 then
                self:setDamageAmount(spec.damage + changeAmount)
            end

            for _, nodeData in ipairs(spec.wearableNodes) do
                local changedAmount = nodeData.updateFunc( self , nodeData, dt)
                if changedAmount ~ = 0 then
                    self:setNodeWearAmount(nodeData, self:getNodeWearAmount(nodeData) + changedAmount)
                end
            end
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
function Wearable:onWriteStream(streamId, connection)
    local spec = self.spec_wearable

    streamWriteUIntN(streamId, math.floor(spec.damage * Wearable.SEND_MAX_VALUE + 0.5 ), Wearable.SEND_NUM_BITS)

    if spec.wearableNodes ~ = nil then
        for _, nodeData in ipairs(spec.wearableNodes) do
            streamWriteUIntN(streamId, math.floor( self:getNodeWearAmount(nodeData) * Wearable.SEND_MAX_VALUE + 0.5 ), Wearable.SEND_NUM_BITS)
        end
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
function Wearable:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_wearable

    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, math.floor(spec.damage * Wearable.SEND_MAX_VALUE + 0.5 ), Wearable.SEND_NUM_BITS)

            if spec.wearableNodes ~ = nil then
                for _, nodeData in ipairs(spec.wearableNodes) do
                    streamWriteUIntN(streamId, math.floor( self:getNodeWearAmount(nodeData) * Wearable.SEND_MAX_VALUE + 0.5 ), Wearable.SEND_NUM_BITS)
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
function Wearable.prerequisitesPresent(specializations)
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
function Wearable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Wearable )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Wearable )

    if not GS_IS_MOBILE_VERSION then
        SpecializationUtil.registerEventListener(vehicleType, "onSaleItemSet" , Wearable )
        SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Wearable )
        SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Wearable )
        SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Wearable )
        SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Wearable )
        SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Wearable )
    end
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
function Wearable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "addAllSubWearableNodes" , Wearable.addAllSubWearableNodes)
    SpecializationUtil.registerFunction(vehicleType, "addDamageAmount" , Wearable.addDamageAmount)
    SpecializationUtil.registerFunction(vehicleType, "addToGlobalWearableNode" , Wearable.addToGlobalWearableNode)
    SpecializationUtil.registerFunction(vehicleType, "addToLocalWearableNode" , Wearable.addToLocalWearableNode)
    SpecializationUtil.registerFunction(vehicleType, "addWearableNode" , Wearable.addWearableNode)
    SpecializationUtil.registerFunction(vehicleType, "addWearAmount" , Wearable.addWearAmount)
    SpecializationUtil.registerFunction(vehicleType, "getDamageAmount" , Wearable.getDamageAmount)
    SpecializationUtil.registerFunction(vehicleType, "getDamageShowOnHud" , Wearable.getDamageShowOnHud)
    SpecializationUtil.registerFunction(vehicleType, "getNodeWearAmount" , Wearable.getNodeWearAmount)
    SpecializationUtil.registerFunction(vehicleType, "getUsageCausesDamage" , Wearable.getUsageCausesDamage)
    SpecializationUtil.registerFunction(vehicleType, "getUsageCausesWear" , Wearable.getUsageCausesWear)
    SpecializationUtil.registerFunction(vehicleType, "getWearMultiplier" , Wearable.getWearMultiplier)
    SpecializationUtil.registerFunction(vehicleType, "getWearTotalAmount" , Wearable.getWearTotalAmount)
    SpecializationUtil.registerFunction(vehicleType, "getWorkWearMultiplier" , Wearable.getWorkWearMultiplier)
    SpecializationUtil.registerFunction(vehicleType, "removeAllSubWearableNodes" , Wearable.removeAllSubWearableNodes)
    SpecializationUtil.registerFunction(vehicleType, "removeWearableNode" , Wearable.removeWearableNode)
    SpecializationUtil.registerFunction(vehicleType, "repaintVehicle" , Wearable.repaintVehicle)
    SpecializationUtil.registerFunction(vehicleType, "repairVehicle" , Wearable.repairVehicle)
    SpecializationUtil.registerFunction(vehicleType, "setDamageAmount" , Wearable.setDamageAmount)
    SpecializationUtil.registerFunction(vehicleType, "setNodeWearAmount" , Wearable.setNodeWearAmount)
    SpecializationUtil.registerFunction(vehicleType, "updateDamageAmount" , Wearable.updateDamageAmount)
    SpecializationUtil.registerFunction(vehicleType, "updateWearAmount" , Wearable.updateWearAmount)
    SpecializationUtil.registerFunction(vehicleType, "validateWearableNode" , Wearable.validateWearableNode)
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
function Wearable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getVehicleDamage" , Wearable.getVehicleDamage)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRepairPrice" , Wearable.getRepairPrice)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRepaintPrice" , Wearable.getRepaintPrice)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "showInfo" , Wearable.showInfo)
end

```

### removeAllSubWearableNodes

**Description**

**Definition**

> removeAllSubWearableNodes()

**Arguments**

| any | rootNode |
|-----|----------|

**Code**

```lua
function Wearable:removeAllSubWearableNodes(rootNode)
    if rootNode ~ = nil then
        I3DUtil.iterateShaderParameterNodesRecursively(rootNode, "scratches_dirt_snow_wetness" , self.removeWearableNode, self )
    end
end

```

### removeWearableNode

**Description**

> Remove wearable node

**Definition**

> removeWearableNode(node table)

**Arguments**

| node | table | node |
|------|-------|------|

**Code**

```lua
function Wearable:removeWearableNode(node)
    local spec = self.spec_wearable

    if spec.wearableNodes ~ = nil and node ~ = nil then
        for _, nodeData in ipairs(spec.wearableNodes) do
            nodeData.nodes[node] = nil
        end
    end
end

```

### repairVehicle

**Description**

> Repair the vehicle. Owner pays. Causes damage to be reset

**Definition**

> repairVehicle()

**Code**

```lua
function Wearable:repairVehicle()
    if self.isServer then
        g_currentMission:addMoney( - self:getRepairPrice(), self:getOwnerFarmId(), MoneyType.VEHICLE_REPAIR, true , true )

        local total, _ = g_farmManager:updateFarmStats( self:getOwnerFarmId(), "repairVehicleCount" , 1 )
        if total ~ = nil then
            g_achievementManager:tryUnlock( "VehicleRepairFirst" , total)
            g_achievementManager:tryUnlock( "VehicleRepair" , total)
        end
    end

    self:setDamageAmount( 0 )
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
function Wearable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_wearable

    xmlFile:setValue(key .. "#damage" , spec.damage)

    if spec.wearableNodes ~ = nil then
        for i, nodeData in ipairs(spec.wearableNodes) do
            local nodeKey = string.format( "%s.wearNode(%d)" , key, i - 1 )
            xmlFile:setValue(nodeKey .. "#amount" , self:getNodeWearAmount(nodeData))
        end
    end
end

```

### setDamageAmount

**Description**

**Definition**

> setDamageAmount()

**Arguments**

| any | amount |
|-----|--------|
| any | force  |

**Code**

```lua
function Wearable:setDamageAmount(amount, force)
    local spec = self.spec_wearable

    spec.damage = math.min( math.max(amount, 0 ), 1 )
    spec.damageByCurve = math.max(spec.damage - 0.3 , 0 ) / 0.7

    local diff = spec.damageSent - spec.damage
    if math.abs(diff) > Wearable.SEND_THRESHOLD or force then
        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
            spec.damageSent = spec.damage
        end
    end
end

```

### setNodeWearAmount

**Description**

**Definition**

> setNodeWearAmount()

**Arguments**

| any | nodeData   |
|-----|------------|
| any | wearAmount |
| any | force      |

**Code**

```lua
function Wearable:setNodeWearAmount(nodeData, wearAmount, force)
    local spec = self.spec_wearable
    nodeData.wearAmount = math.clamp(wearAmount, 0 , 1 )

    local diff = nodeData.wearAmountSent - nodeData.wearAmount
    if math.abs(diff) > Wearable.SEND_THRESHOLD or force then
        for _, node in pairs(nodeData.nodes) do
            setShaderParameter(node, "scratches_dirt_snow_wetness" , nodeData.wearAmount, nil , nil , nil , false )
        end

        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
            nodeData.wearAmountSent = nodeData.wearAmount
        end

        -- calculate total wearable amount
        spec.totalAmount = 0
        for i = 1 , #spec.wearableNodes do
            spec.totalAmount = spec.totalAmount + spec.wearableNodes[i].wearAmount
        end
        spec.totalAmount = spec.totalAmount / #spec.wearableNodes
    end
end

```

### showInfo

**Description**

**Definition**

> showInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | box       |

**Code**

```lua
function Wearable:showInfo(superFunc, box)
    local damage = self.spec_wearable.damage
    if damage > 0.01 then
        box:addLine(g_i18n:getText( "infohud_damage" ), string.format( "%d %%" , damage * 100 ))
    end

    superFunc( self , box)
end

```

### updateDamageAmount

**Description**

**Definition**

> updateDamageAmount()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Wearable:updateDamageAmount(dt)
    local spec = self.spec_wearable
    if self:getUsageCausesDamage() then
        local factor = 1
        if self.lifetime ~ = nil and self.lifetime ~ = 0 then
            local ageMultiplier = 0.15 * math.min( self.age / self.lifetime, 1 )
            local operatingTime = self.operatingTime / ( 1000 * 60 * 60 )
            local operatingTimeMultiplier = 0.85 * math.min(operatingTime / ( self.lifetime * EconomyManager.LIFETIME_OPERATINGTIME_RATIO), 1 )

            factor = 1 + EconomyManager.MAX_DAILYUPKEEP_MULTIPLIER * (ageMultiplier + operatingTimeMultiplier)
        end

        return dt * spec.wearDuration * 0.35 * factor
    else
            return 0
        end
    end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function Wearable:updateDebugValues(values)
    local spec = self.spec_wearable

    local changedAmount = self:updateDamageAmount( 3600000 )
    table.insert(values, { name = "Damage" , value = string.format( "%.4f a/h(%.2f)" , changedAmount, self:getDamageAmount()) } )

    if spec.wearableNodes ~ = nil then
        if self.isServer then
            for i, nodeData in ipairs(spec.wearableNodes) do
                changedAmount = nodeData.updateFunc( self , nodeData, 3600000 )
                table.insert(values, { name = "WearableNode" .. i, value = string.format( "%.4f a/h(%.6f)" , changedAmount, self:getNodeWearAmount(nodeData)) } )
            end
        end
    end
end

```

### updateWearAmount

**Description**

**Definition**

> updateWearAmount()

**Arguments**

| any | nodeData |
|-----|----------|
| any | dt       |

**Code**

```lua
function Wearable:updateWearAmount(nodeData, dt)
    local spec = self.spec_wearable
    if self:getUsageCausesWear() then
        return dt * spec.wearDuration * self:getWearMultiplier(nodeData) * 0.5
    else
            return 0
        end
    end

```

### validateWearableNode

**Description**

**Definition**

> validateWearableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Wearable:validateWearableNode(node)
    return true , nil -- by default all nodes are global
end

```