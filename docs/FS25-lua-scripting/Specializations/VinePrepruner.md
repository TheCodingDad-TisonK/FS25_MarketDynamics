## VinePrepruner

**Description**

> Specialization for vine prepruners

**Functions**

- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [readPrePrunerFromStream](#readpreprunerfromstream)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [writePrePrunerToStream](#writepreprunertostream)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function VinePrepruner.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "VinePrepruner" )
    schema:register(XMLValueType.STRING, "vehicle.vinePrepruner#fruitType" , "Fruit type" )

    local nodeKey = VinePrepruner.PRUNER_NODE_XML_KEY
    schema:register(XMLValueType.NODE_INDEX, nodeKey .. "#node" , "Pruner node that adjusts translation depending on raycast distance" )
    schema:register(XMLValueType.FLOAT, nodeKey .. "#offset" , "Offset from raycast node to center of pruning unit" , 0.5 )
    schema:register(XMLValueType.INT, nodeKey .. "#axis" , "Move axis" , 1 )
    schema:register(XMLValueType.INT, nodeKey .. "#direction" , "Translation direction" , 1 )
    schema:register(XMLValueType.FLOAT, nodeKey .. "#transMin" , "Min.translation" , 0 )
    schema:register(XMLValueType.FLOAT, nodeKey .. "#transMax" , "Max.translation" , 1 )
    schema:register(XMLValueType.FLOAT, nodeKey .. "#transSpeed" , "Translation speed(m/sec)" , 0.5 )
    schema:register(XMLValueType.INT, nodeKey .. "#numBits" , "Number of bits to sync state in multiplayer" , 8 )

    schema:register(XMLValueType.STRING, "vehicle.vinePrepruner.poleAnimation#name" , "Name of pole animation(will be triggered as soon as pole has been detected)" )
    schema:register(XMLValueType.FLOAT, "vehicle.vinePrepruner.poleAnimation#speedScale" , "Animation speed scale" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.vinePrepruner.poleAnimation#poleThreshold" , "Defines when the pole is detected as percentage of segment length" , 0.1 )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.vinePrepruner.effect" )

    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function VinePrepruner:onDelete()
    local spec = self.spec_vinePrepruner
    g_effectManager:deleteEffects(spec.effects)
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
function VinePrepruner:onLoad(savegame)
    local spec = self.spec_vinePrepruner

    local fruitTypeName = self.xmlFile:getValue( "vehicle.vinePrepruner#fruitType" )
    local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
    if fruitType ~ = nil then
        spec.fruitTypeIndex = fruitType.index
    else
            spec.fruitTypeIndex = FruitType.GRAPE
        end

        spec.prunerNodes = { }
        self.xmlFile:iterate( "vehicle.vinePrepruner.prunerNode" , function (index, key)
            local entry = { }
            if self:loadPreprunerNodeFromXML( self.xmlFile, key, entry) then
                table.insert(spec.prunerNodes, entry)
            end
        end )

        spec.poleAnimation = { }
        spec.poleAnimation.name = self.xmlFile:getValue( "vehicle.vinePrepruner.poleAnimation#name" )
        spec.poleAnimation.speedScale = self.xmlFile:getValue( "vehicle.vinePrepruner.poleAnimation#speedScale" , 1 )
        spec.poleAnimation.poleThreshold = 1 - self.xmlFile:getValue( "vehicle.vinePrepruner.poleAnimation#poleThreshold" , 0.1 )

        spec.lastWorkTime = - 10000
        spec.effectState = false

        if self.isClient then
            spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.vinePrepruner.effect" , self.components, self , self.i3dMappings)
        end

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
function VinePrepruner:onReadStream(streamId, connection)
    VinePrepruner.readPrePrunerFromStream( self , streamId, true )
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
function VinePrepruner:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            VinePrepruner.readPrePrunerFromStream( self , streamId)
        end
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function VinePrepruner:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_vinePrepruner
    for i = 1 , #spec.prunerNodes do
        local prunerNode = spec.prunerNodes[i]
        if self:getIsPreprunerNodeActive(prunerNode) then
            local curTrans = prunerNode.curTrans[prunerNode.axis]
            if prunerNode.transTarget ~ = curTrans then
                local moveDirection = math.sign(prunerNode.transTarget - curTrans)
                local func = moveDirection > = 0 and math.min or math.max
                prunerNode.curTrans[prunerNode.axis] = func(curTrans + prunerNode.transSpeed * dt * moveDirection, prunerNode.transTarget)
                setTranslation(prunerNode.node, prunerNode.curTrans[ 1 ], prunerNode.curTrans[ 2 ], prunerNode.curTrans[ 3 ])
            end
        end
    end

    if self.isServer then
        local effectState = spec.lastWorkTime + 1000 > g_ time
        if effectState ~ = spec.effectState then
            spec.effectState = effectState

            if self.isClient then
                if effectState then
                    g_effectManager:setEffectTypeInfo(spec.effects, nil , spec.fruitTypeIndex, nil )
                    g_effectManager:startEffects(spec.effects)
                else
                        g_effectManager:stopEffects(spec.effects)
                    end
                end

                self:raiseDirtyFlags(spec.dirtyFlag)
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
function VinePrepruner:onWriteStream(streamId, connection)
    VinePrepruner.writePrePrunerToStream( self , streamId)
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
function VinePrepruner:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_vinePrepruner
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            VinePrepruner.writePrePrunerToStream( self , streamId)
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
function VinePrepruner.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(VineDetector, specializations)
end

```

### readPrePrunerFromStream

**Description**

**Definition**

> readPrePrunerFromStream()

**Arguments**

| any | self       |
|-----|------------|
| any | streamId   |
| any | forceState |

**Code**

```lua
function VinePrepruner.readPrePrunerFromStream( self , streamId, forceState)
    local spec = self.spec_vinePrepruner
    for i = 1 , #spec.prunerNodes do
        local prunerNode = spec.prunerNodes[i]

        local maxValue = ( 2 ^ prunerNode.numBits) - 1
        local rawValue = streamReadUIntN(streamId, prunerNode.numBits)
        prunerNode.transTarget = rawValue / maxValue * (prunerNode.transMax - prunerNode.transMin) + prunerNode.transMin
        if forceState then
            prunerNode.curTrans[prunerNode.axis] = prunerNode.transTarget
            setTranslation(prunerNode.node, prunerNode.curTrans[ 1 ], prunerNode.curTrans[ 2 ], prunerNode.curTrans[ 3 ])
        end
    end

    local effectState = streamReadBool(streamId)
    if effectState ~ = spec.effectState then
        spec.effectState = effectState

        if effectState then
            g_effectManager:setEffectTypeInfo(spec.effects, nil , spec.fruitTypeIndex, nil )
            g_effectManager:startEffects(spec.effects)
        else
                g_effectManager:stopEffects(spec.effects)
            end
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
function VinePrepruner.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , VinePrepruner )
    SpecializationUtil.registerEventListener(vehicleType, "onAnimationPartChanged" , VinePrepruner )
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
function VinePrepruner.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadPreprunerNodeFromXML" , VinePrepruner.loadPreprunerNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsPreprunerNodeActive" , VinePrepruner.getIsPreprunerNodeActive)
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
function VinePrepruner.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , VinePrepruner.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartVineDetection" , VinePrepruner.getCanStartVineDetection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsValidVinePlaceable" , VinePrepruner.getIsValidVinePlaceable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "handleVinePlaceable" , VinePrepruner.handleVinePlaceable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIImplementUseVineSegment" , VinePrepruner.getAIImplementUseVineSegment)
end

```

### writePrePrunerToStream

**Description**

**Definition**

> writePrePrunerToStream()

**Arguments**

| any | self     |
|-----|----------|
| any | streamId |

**Code**

```lua
function VinePrepruner.writePrePrunerToStream( self , streamId)
    local spec = self.spec_vinePrepruner
    for i = 1 , #spec.prunerNodes do
        local prunerNode = spec.prunerNodes[i]

        local maxValue = ( 2 ^ prunerNode.numBits) - 1
        local state = (prunerNode.transTarget - prunerNode.transMin) / (prunerNode.transMax - prunerNode.transMin)
        streamWriteUIntN(streamId, state * maxValue, prunerNode.numBits)
    end

    streamWriteBool(streamId, spec.effectState)
end

```