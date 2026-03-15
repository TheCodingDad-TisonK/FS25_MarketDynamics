## PlaceableBeehivePalletSpawner

**Description**

> Specialization for placeables

**Functions**

- [addFillLevel](#addfilllevel)
- [canBuy](#canbuy)
- [getPalletCallback](#getpalletcallback)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [updateInfo](#updateinfo)
- [updatePallets](#updatepallets)

### addFillLevel

**Description**

**Definition**

> addFillLevel()

**Arguments**

| any | fillLevel |
|-----|-----------|

**Code**

```lua
function PlaceableBeehivePalletSpawner:addFillLevel(fillLevel)
    if self.isServer then
        local spec = self.spec_beehivePalletSpawner

        if fillLevel ~ = nil then
            spec.pendingLiters = spec.pendingLiters + fillLevel
        end
    end
end

```

### canBuy

**Description**

**Definition**

> canBuy()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableBeehivePalletSpawner:canBuy(superFunc)
    local canBuy, warning = superFunc( self )
    if not canBuy then
        return false , warning
    end

    if g_currentMission.beehiveSystem:getFarmBeehivePalletSpawner(g_localPlayer.farmId) ~ = nil then
        return false , g_i18n:getText( "warning_onlyOneOfThisItemAllowedPerFarm" )
    end

    return true , nil
end

```

### getPalletCallback

**Description**

**Definition**

> getPalletCallback()

**Arguments**

| any | pallet        |
|-----|---------------|
| any | result        |
| any | fillTypeIndex |

**Code**

```lua
function PlaceableBeehivePalletSpawner:getPalletCallback(pallet, result, fillTypeIndex)
    local spec = self.spec_beehivePalletSpawner
    spec.spawnPending = false

    if pallet ~ = nil then
        if result = = PalletSpawner.RESULT_SUCCESS then
            if spec.palletLimitReached then
                spec.palletLimitReached = false
                self:raiseDirtyFlags(spec.dirtyFlag)
            end
            pallet:emptyAllFillUnits( true )
        end

        local delta = pallet:addFillUnitFillLevel( self:getOwnerFarmId(), 1 , spec.pendingLiters, fillTypeIndex, ToolType.UNDEFINED)

        spec.pendingLiters = math.max(spec.pendingLiters - delta, 0 )

    elseif result = = PalletSpawner.RESULT_NO_SPACE then
            -- TODO:add cooldown or "pallet removed" callback to prevent overlap boxes in every frame
        elseif result = = PalletSpawner.PALLET_LIMITED_REACHED then
                if not spec.palletLimitReached then
                    spec.palletLimitReached = true
                    self:raiseDirtyFlags(spec.dirtyFlag)
                end
            end
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
function PlaceableBeehivePalletSpawner:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_beehivePalletSpawner

    spec.pendingLiters = xmlFile:getValue(key .. ".beehivePalletSpawner#pendingLiters" ) or spec.pendingLiters
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableBeehivePalletSpawner:onDelete()
    local spec = self.spec_beehivePalletSpawner
    if spec.palletSpawner ~ = nil then
        spec.palletSpawner:delete()
    end
    g_currentMission.beehiveSystem:removeBeehivePalletSpawner( self )
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableBeehivePalletSpawner:onFinalizePlacement()
    g_currentMission.beehiveSystem:addBeehivePalletSpawner( self )
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
function PlaceableBeehivePalletSpawner:onLoad(savegame)
    local spec = self.spec_beehivePalletSpawner
    local xmlFile = self.xmlFile

    local palletSpawnerKey = "placeable.beehivePalletSpawner"
    spec.palletSpawner = PalletSpawner.new( self.baseDirectory)
    if not spec.palletSpawner:load( self.components, xmlFile, palletSpawnerKey, self.customEnvironment, self.i3dMappings) then
        Logging.xmlError(xmlFile, "Unable to load pallet spawner %s" , palletSpawnerKey)
        self:setLoadingState(PlaceableLoadingState.ERROR)
        return
    end

    spec.pendingLiters = 0
    spec.spawnPending = false
    spec.palletLimitReached = false
    spec.infoHudTooManyPallets = { title = g_i18n:getText( "infohud_tooManyPallets" ) }
    spec.fillType = g_fillTypeManager:getFillTypeIndexByName( "HONEY" )

    spec.dirtyFlag = self:getNextDirtyFlag()
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
function PlaceableBeehivePalletSpawner:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_beehivePalletSpawner
        spec.palletLimitReached = streamReadBool(streamId)
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
function PlaceableBeehivePalletSpawner:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_beehivePalletSpawner
        spec.palletLimitReached = streamReadBool(streamId)
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
function PlaceableBeehivePalletSpawner:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_beehivePalletSpawner
        streamWriteBool(streamId, spec.palletLimitReached)
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
function PlaceableBeehivePalletSpawner:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_beehivePalletSpawner
        streamWriteBool(streamId, spec.palletLimitReached)
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
function PlaceableBeehivePalletSpawner.prerequisitesPresent(specializations)
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
function PlaceableBeehivePalletSpawner.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableBeehivePalletSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableBeehivePalletSpawner )
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
function PlaceableBeehivePalletSpawner.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "addFillLevel" , PlaceableBeehivePalletSpawner.addFillLevel)
    SpecializationUtil.registerFunction(placeableType, "updatePallets" , PlaceableBeehivePalletSpawner.updatePallets)
    SpecializationUtil.registerFunction(placeableType, "getPalletCallback" , PlaceableBeehivePalletSpawner.getPalletCallback)
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
function PlaceableBeehivePalletSpawner.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "canBuy" , PlaceableBeehivePalletSpawner.canBuy)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "updateInfo" , PlaceableBeehivePalletSpawner.updateInfo)
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
function PlaceableBeehivePalletSpawner.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.FLOAT, basePath .. ".beehivePalletSpawner#pendingLiters" , "Pending liters to be spawned" )
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
function PlaceableBeehivePalletSpawner.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "BeehivePalletSpawner" )
    PalletSpawner.registerXMLPaths(schema, basePath .. ".beehivePalletSpawner" )
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
function PlaceableBeehivePalletSpawner:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_beehivePalletSpawner

    if spec.pendingLiters > 0 then
        xmlFile:setValue(key .. ".beehivePalletSpawner#pendingLiters" , spec.pendingLiters)
    end
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
function PlaceableBeehivePalletSpawner:updateInfo(superFunc, infoTable)
    superFunc( self , infoTable)
    local spec = self.spec_beehivePalletSpawner
    if spec.palletLimitReached then
        table.insert(infoTable, spec.infoHudTooManyPallets)
    end
end

```

### updatePallets

**Description**

**Definition**

> updatePallets()

**Code**

```lua
function PlaceableBeehivePalletSpawner:updatePallets()
    if self.isServer then
        local spec = self.spec_beehivePalletSpawner

        if not spec.spawnPending and spec.pendingLiters > 10 then
            spec.spawnPending = true
            spec.palletSpawner:getOrSpawnPallet( self:getOwnerFarmId(), spec.fillType, self.getPalletCallback, self )
        end
    end
end

```