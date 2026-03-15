## ProductionChainManager

**Description**

> This class handles the interaction between Production- and/or SellingPoints

**Parent**

> [AbstractManager](?version=script&category=58&class=560)

**Functions**

- [addFactory](#addfactory)
- [addFactoryToFarm](#addfactorytofarm)
- [addProductionPoint](#addproductionpoint)
- [addProductionPointToFarm](#addproductionpointtofarm)
- [getFactoriesForFarmId](#getfactoriesforfarmid)
- [getHasFreeSlots](#gethasfreeslots)
- [getNumOfProductionPoints](#getnumofproductionpoints)
- [getProductionPointsForFarmId](#getproductionpointsforfarmid)
- [getUnownedFactories](#getunownedfactories)
- [getUnownedProductionPoints](#getunownedproductionpoints)
- [hourChanged](#hourchanged)
- [initDataStructures](#initdatastructures)
- [new](#new)
- [removeFactory](#removefactory)
- [removeFactoryFromFarm](#removefactoryfromfarm)
- [removeProductionPoint](#removeproductionpoint)
- [removeProductionPointFromFarm](#removeproductionpointfromfarm)
- [unloadMapData](#unloadmapdata)
- [updateBalance](#updatebalance)

### addFactory

**Description**

**Definition**

> addFactory()

**Arguments**

| any | factory |
|-----|---------|

**Code**

```lua
function ProductionChainManager:addFactory(factory)
    if self.reverseFactory[factory] then
        Logging.warning( "Factory '%s' already registered." , factory:tableId())
        return false
    end

    self.reverseFactory[factory] = true
    table.insert( self.factories, factory)

    local farmId = factory:getOwnerFarmId()
    if farmId ~ = AccessHandler.EVERYONE then
        if not self.farmIds[farmId] then
            self.farmIds[farmId] = { }
        end
        self:addFactoryToFarm(factory, self.farmIds[farmId])
    end
    return true
end

```

### addFactoryToFarm

**Description**

**Definition**

> addFactoryToFarm()

**Arguments**

| any | factory   |
|-----|-----------|
| any | farmTable |

**Code**

```lua
function ProductionChainManager:addFactoryToFarm(factory, farmTable)
    if not farmTable.factories then
        farmTable.factories = { }
    end
    table.insert(farmTable.factories, factory)
end

```

### addProductionPoint

**Description**

**Definition**

> addProductionPoint()

**Arguments**

| any | productionPoint |
|-----|-----------------|

**Code**

```lua
function ProductionChainManager:addProductionPoint(productionPoint)
    if self.reverseProductionPoint[productionPoint] then
        Logging.warning( "Production point '%s' already registered." , productionPoint:tableId())
        return false
    end
    if # self.productionPoints > = ProductionChainManager.NUM_MAX_PRODUCTION_POINTS then
        printf( "Maximum number of %i Production Points reached." , ProductionChainManager.NUM_MAX_PRODUCTION_POINTS)
        return false
    end

    if # self.productionPoints = = 0 and self.isServer then
        g_currentMission:addUpdateable( self )
    end

    self.reverseProductionPoint[productionPoint] = true
    table.insert( self.productionPoints, productionPoint)

    --#debug if self.debugEnabled then
        --#debug g_currentMission:addDrawable(productionPoint)
        --#debug end

        local farmId = productionPoint:getOwnerFarmId()
        if farmId ~ = AccessHandler.EVERYONE then
            if not self.farmIds[farmId] then
                self.farmIds[farmId] = { }
            end
            self:addProductionPointToFarm(productionPoint, self.farmIds[farmId])
        end
        return true
    end

```

### addProductionPointToFarm

**Description**

**Definition**

> addProductionPointToFarm()

**Arguments**

| any | productionPoint |
|-----|-----------------|
| any | farmTable       |

**Code**

```lua
function ProductionChainManager:addProductionPointToFarm(productionPoint, farmTable)
    if not farmTable.productionPoints then
        farmTable.productionPoints = { }
    end
    table.insert(farmTable.productionPoints, productionPoint)

    if not farmTable.inputTypeToProductionPoints then
        farmTable.inputTypeToProductionPoints = { }
    end

    for inputType in pairs(productionPoint.inputFillTypeIds) do
        if not farmTable.inputTypeToProductionPoints[inputType] then
            farmTable.inputTypeToProductionPoints[inputType] = { }
        end
        table.insert(farmTable.inputTypeToProductionPoints[inputType], productionPoint)
    end
end

```

### getFactoriesForFarmId

**Description**

**Definition**

> getFactoriesForFarmId()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function ProductionChainManager:getFactoriesForFarmId(farmId)
    return self.farmIds[farmId] and self.farmIds[farmId].factories or { }
end

```

### getHasFreeSlots

**Description**

**Definition**

> getHasFreeSlots()

**Code**

```lua
function ProductionChainManager:getHasFreeSlots()
    return # self.productionPoints < ProductionChainManager.NUM_MAX_PRODUCTION_POINTS
end

```

### getNumOfProductionPoints

**Description**

**Definition**

> getNumOfProductionPoints()

**Code**

```lua
function ProductionChainManager:getNumOfProductionPoints()
    return # self.productionPoints
end

```

### getProductionPointsForFarmId

**Description**

**Definition**

> getProductionPointsForFarmId()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function ProductionChainManager:getProductionPointsForFarmId(farmId)
    return self.farmIds[farmId] and self.farmIds[farmId].productionPoints or { }
end

```

### getUnownedFactories

**Description**

**Definition**

> getUnownedFactories()

**Code**

```lua
function ProductionChainManager:getUnownedFactories()
    local unownedFactories = { }
    for _, factory in pairs( self.factories) do
        if factory:getOwnerFarmId() = = AccessHandler.EVERYONE then
            table.insert(unownedFactories, factory)
        end
    end

    return unownedFactories
end

```

### getUnownedProductionPoints

**Description**

**Definition**

> getUnownedProductionPoints()

**Code**

```lua
function ProductionChainManager:getUnownedProductionPoints()
    local unownedPoints = { }
    for _, point in pairs( self.productionPoints) do
        if point:getOwnerFarmId() = = AccessHandler.EVERYONE then
            table.insert(unownedPoints, point)
        end
    end

    return unownedPoints
end

```

### hourChanged

**Description**

**Definition**

> hourChanged()

**Code**

```lua
function ProductionChainManager:hourChanged()
    self.hourChangedDirty = true
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function ProductionChainManager:initDataStructures()
    self.productionPoints = { }
    self.reverseProductionPoint = { }

    self.factories = { }
    self.reverseFactory = { }

    self.farmIds = { }

    self.currentUpdateIndex = 1
    self.hourChangedDirty = false
    self.hourChangeUpdating = false
end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | customMt |

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function ProductionChainManager.new(isServer, customMt)
    local self = AbstractManager.new(customMt or ProductionChainManager _mt)

    self.isServer = isServer

    --#debug self.debugEnabled = false

    --#debug addConsoleCommand("gsProductionPointToggleDebug", "Toggle production point debugging", "consoleCommandToggleProdPointDebug", self)
    addConsoleCommand( "gsProductionPointsList" , "List all production points on map" , "commandListProductionPoints" , self )
    addConsoleCommand( "gsProductionPointsPrintAutoDeliverMapping" , "Prints which fillTypes are required by which production points" , "commandPrintAutoDeliverMapping" , self )
    addConsoleCommand( "gsProductionPointSetOwner" , "" , "commandSetOwner" , self )
    addConsoleCommand( "gsProductionPointSetProductionState" , "" , "commandSetProductionState" , self )
    addConsoleCommand( "gsProductionPointSetOutputMode" , "" , "commandSetOutputMode" , self )
    addConsoleCommand( "gsProductionPointSetFillLevel" , "" , "commandSetFillLevel" , self )

    if self.isServer then
        g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.hourChanged, self )
    end

    return self
end

```

### removeFactory

**Description**

**Definition**

> removeFactory()

**Arguments**

| any | factory |
|-----|---------|
| any | farmId  |

**Code**

```lua
function ProductionChainManager:removeFactory(factory, farmId)
    self.reverseFactory[factory] = nil

    if table.removeElement( self.factories, factory) then
        if farmId ~ = AccessHandler.EVERYONE and self.farmIds[farmId] ~ = nil then
            self.farmIds[farmId] = self:removeFactoryFromFarm(factory, self.farmIds[farmId])
        end
    end
end

```

### removeFactoryFromFarm

**Description**

**Definition**

> removeFactoryFromFarm()

**Arguments**

| any | factory   |
|-----|-----------|
| any | farmTable |

**Code**

```lua
function ProductionChainManager:removeFactoryFromFarm(factory, farmTable)
    if farmTable.factories = = nil then
        return farmTable
    end

    table.removeElement(farmTable.factories, factory)

    if #farmTable.factories = = 0 and farmTable.productionPoints = = nil then
        farmTable = nil
    end

    return farmTable
end

```

### removeProductionPoint

**Description**

**Definition**

> removeProductionPoint()

**Arguments**

| any | productionPoint |
|-----|-----------------|

**Code**

```lua
function ProductionChainManager:removeProductionPoint(productionPoint)
    self.reverseProductionPoint[productionPoint] = nil

    if table.removeElement( self.productionPoints, productionPoint) then
        local farmId = productionPoint:getOwnerFarmId()
        if farmId ~ = AccessHandler.EVERYONE then
            self.farmIds[farmId] = self:removeProductionPointFromFarm(productionPoint, self.farmIds[farmId])
        end

        --#debug if self.debugEnabled then
            --#debug g_currentMission:removeDrawable(productionPoint)
            --#debug end
        end

        if # self.productionPoints = = 0 and self.isServer then
            g_currentMission:removeUpdateable( self )
        end
    end

```

### removeProductionPointFromFarm

**Description**

**Definition**

> removeProductionPointFromFarm()

**Arguments**

| any | productionPoint |
|-----|-----------------|
| any | farmTable       |

**Code**

```lua
function ProductionChainManager:removeProductionPointFromFarm(productionPoint, farmTable)
    if farmTable.productionPoints = = nil then
        return farmTable
    end

    table.removeElement(farmTable.productionPoints, productionPoint)

    local inputTypeToProductionPoints = farmTable.inputTypeToProductionPoints
    for inputType in pairs(productionPoint.inputFillTypeIds) do
        if inputTypeToProductionPoints[inputType] then
            if not table.removeElement(inputTypeToProductionPoints[inputType], productionPoint) then
                printError( "Error:ProductionChainManager:removeProductionPoint():Unable to remove production point from input type mapping" )
            end
            if #inputTypeToProductionPoints[inputType] = = 0 then
                inputTypeToProductionPoints[inputType] = nil
            end
        end
    end
    if #farmTable.productionPoints = = 0 and farmTable.factories = = nil then
        farmTable = nil
    end

    return farmTable
end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function ProductionChainManager:unloadMapData()
    --#debug removeConsoleCommand("gsProductionPointToggleDebug")
    removeConsoleCommand( "gsProductionPointsList" )
    removeConsoleCommand( "gsProductionPointsPrintAutoDeliverMapping" )
    removeConsoleCommand( "gsProductionPointSetOwner" )
    removeConsoleCommand( "gsProductionPointSetProductionState" )
    removeConsoleCommand( "gsProductionPointSetOutputMode" )
    removeConsoleCommand( "gsProductionPointSetFillLevel" )

    if self.isServer then
        g_messageCenter:unsubscribe(MessageType.HOUR_CHANGED, self )
    end

    ProductionChainManager:superClass().unloadMapData( self )
end

```

### updateBalance

**Description**

**Definition**

> updateBalance()

**Code**

```lua
function ProductionChainManager:updateBalance()

end

```