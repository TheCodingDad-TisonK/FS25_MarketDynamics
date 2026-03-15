## TreePlanter

**Description**

> Specialization for tree planters providing possibility to pick up seedling pallets and create trees

**Functions**

- [actionEventPlant](#actioneventplant)
- [actionEventToggleTreePlanterFieldLimitation](#actioneventtoggletreeplanterfieldlimitation)
- [addFillUnitFillLevel](#addfillunitfilllevel)
- [createTree](#createtree)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getCanBeSelected](#getcanbeselected)
- [getCanPlantOutsideSeason](#getcanplantoutsideseason)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getFillLevelInformation](#getfilllevelinformation)
- [getFillUnitAllowsFillType](#getfillunitallowsfilltype)
- [getFillUnitCapacity](#getfillunitcapacity)
- [getFillUnitFillLevel](#getfillunitfilllevel)
- [getFillUnitFillLevelPercentage](#getfillunitfilllevelpercentage)
- [getFillUnitFillType](#getfillunitfilltype)
- [getFillUnitFreeCapacity](#getfillunitfreecapacity)
- [getFillUnitHasMountedPalletsToUnload](#getfillunithasmountedpalletstounload)
- [getFillUnitMountedPalletsToUnload](#getfillunitmountedpalletstounload)
- [getFillUnitUnloadPalletFilename](#getfillunitunloadpalletfilename)
- [getHasObjectMounted](#gethasobjectmounted)
- [getImplementAllowAutomaticSteering](#getimplementallowautomaticsteering)
- [getIsOnField](#getisonfield)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getSaplingPalletInRange](#getsaplingpalletinrange)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadPallet](#loadpallet)
- [onDelete](#ondelete)
- [onDeleteTreePlanterObject](#ondeletetreeplanterobject)
- [onDraw](#ondraw)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onFillUnitIsFillingStateChanged](#onfillunitisfillingstatechanged)
- [onFillUnitUnloadPallet](#onfillunitunloadpallet)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onTreePlanterSaplingLoaded](#ontreeplantersaplingloaded)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [palletTriggerCallback](#pallettriggercallback)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeMountedObject](#removemountedobject)
- [saveToXMLFile](#savetoxmlfile)
- [setPlantLimitToField](#setplantlimittofield)
- [setTreePlanterTreeTypeIndex](#settreeplantertreetypeindex)
- [updateTreePlanterFillLevel](#updatetreeplanterfilllevel)

### actionEventPlant

**Description**

**Definition**

> actionEventPlant()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function TreePlanter.actionEventPlant( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_treePlanter
    if spec.hasGroundContact then
        if g_treePlantManager:canPlantTree() then
            local x, y, z = getWorldTranslation(spec.node)
            if g_currentMission.accessHandler:canFarmAccessLand( self:getActiveFarm(), x, z) then
                if not PlacementUtil.isInsideRestrictedZone(g_currentMission.restrictedZones, x, y, z, true ) then
                    self:createTree()
                else
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_actionNotAllowedHere" ))
                    end
                else
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_youDontHaveAccessToThisLand" ))
                    end
                else
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_tooManyTrees" ))
                    end
                else
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_treePlanterNoGroundContact" ))
                    end
                end

```

### actionEventToggleTreePlanterFieldLimitation

**Description**

**Definition**

> actionEventToggleTreePlanterFieldLimitation()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function TreePlanter.actionEventToggleTreePlanterFieldLimitation( self , actionName, inputValue, callbackState, isAnalog)
    self:setPlantLimitToField( not self.spec_treePlanter.limitToField)
end

```

### addFillUnitFillLevel

**Description**

**Definition**

> addFillUnitFillLevel()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | farmId           |
| any | fillUnitIndex    |
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |

**Code**

```lua
function TreePlanter:addFillUnitFillLevel(superFunc, farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            local fillUnits = pallet:getFillUnits()
            for palletFillUnitIndex, _ in pairs(fillUnits) do
                if pallet:getFillUnitFillType(fillUnitIndex) = = fillTypeIndex then
                    return pallet:addFillUnitFillLevel( self:getOwnerFarmId(), palletFillUnitIndex, fillLevelDelta, fillTypeIndex, ToolType.UNDEFINED)
                end
            end
        end
    end

    return superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
end

```

### createTree

**Description**

> Create tree on current position

**Definition**

> createTree()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function TreePlanter:createTree(noEventSend)
    local spec = self.spec_treePlanter

    if not g_treePlantManager:canPlantTree() then
        spec.showTooManyTreesWarning = true
        return
    end

    if self.isServer then
        local x, y, z = getWorldTranslation(spec.node)
        local yRot = math.random() * 2 * math.pi

        local treeTypeIndex = spec.currentTreeTypeIndex
        local variationIndex = spec.currentTreeVariationIndex
        if treeTypeIndex = = nil or variationIndex = = nil then
            Logging.error( "Failed to plant tree.Tree type not found. (treeType %s, variation %s)" , treeTypeIndex, variationIndex)
            return
        end

        g_treePlantManager:plantTree(treeTypeIndex, x, y, z, 0 , yRot, 0 , 1 , variationIndex)

        if spec.lastTreePos = = nil then
            spec.lastTreePos = { x, y, z }
        else
                spec.lastTreePos[ 1 ], spec.lastTreePos[ 2 ], spec.lastTreePos[ 3 ] = x, y, z
            end

            local farmId = self:getActiveFarm()

            if g_currentMission.missionInfo.helperBuySeeds and self:getIsAIActive() then
                local pallet = spec.mountedSaplingPallet
                if pallet ~ = nil then
                    local storeItem = g_storeManager:getItemByXMLFilename(pallet.configFileName)
                    local pricePerSapling = 1.5 * (storeItem.price / pallet:getFillUnitCapacity( 1 ))
                    g_farmManager:updateFarmStats(farmId, "expenses" , pricePerSapling)
                    g_currentMission:addMoney( - pricePerSapling, self:getActiveFarm(), MoneyType.PURCHASE_SEEDS)
                end
            else
                    -- use 0.9999 instead of 1 to compansate float precision on mp sync
                    local fillLevelChange = - 0.9999
                    if self:getFillUnitFillLevel(spec.fillUnitIndex) < 1.5 then
                        fillLevelChange = - math.huge
                    end

                    self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, fillLevelChange, self:getFillUnitFillType(spec.fillUnitIndex), ToolType.UNDEFINED)
                end

                -- increase tree plant counter for achievements
                    g_farmManager:updateFarmStats(farmId, "plantedTreeCount" , 1 )
                else
                        local x, y, z = getWorldTranslation(spec.node)
                        if spec.lastTreePos = = nil then
                            spec.lastTreePos = { x, y, z }
                        else
                                spec.lastTreePos[ 1 ], spec.lastTreePos[ 2 ], spec.lastTreePos[ 3 ] = x, y, z
                            end
                        end

                        if self.isClient then
                            if spec.plantAnimation.name ~ = nil then
                                self:setAnimationTime(spec.plantAnimation.name, 0 , true )
                                self:playAnimation(spec.plantAnimation.name, spec.plantAnimation.speedScale, 0 , true )
                            end
                        end

                        TreePlanterCreateTreeEvent.sendEvent( self , noEventSend)
                    end

```

### doCheckSpeedLimit

**Description**

> Returns if speed limit should be checked

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | checkSpeedlimit | check speed limit |
|-----|-----------------|-------------------|

**Code**

```lua
function TreePlanter:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and self:getIsImplementChainLowered())
end

```

### getCanBeSelected

**Description**

**Definition**

> getCanBeSelected()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TreePlanter:getCanBeSelected(superFunc)
    return true
end

```

### getCanPlantOutsideSeason

**Description**

**Definition**

> getCanPlantOutsideSeason()

**Code**

```lua
function TreePlanter:getCanPlantOutsideSeason()
    return false
end

```

### getDefaultSpeedLimit

**Description**

> Returns default speed limit

**Definition**

> getDefaultSpeedLimit()

**Return Values**

| any | speedLimit | speed limit |
|-----|------------|-------------|

**Code**

```lua
function TreePlanter.getDefaultSpeedLimit()
    return 5
end

```

### getDirtMultiplier

**Description**

> Returns current dirt multiplier

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current dirt multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function TreePlanter:getDirtMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_treePlanter
    if spec.hasGroundContact then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
end

```

### getFillLevelInformation

**Description**

**Definition**

> getFillLevelInformation()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | display   |

**Code**

```lua
function TreePlanter:getFillLevelInformation(superFunc, display)
    local spec = self.spec_treePlanter
    local pallet = spec.mountedSaplingPallet

    if pallet ~ = nil then
        local capacity = self:getFillUnitCapacity(spec.fillUnitIndex)
        local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
        local fillType = self:getFillUnitFillType(spec.fillUnitIndex)

        display:addFillLevel(fillType, fillLevel, capacity)
    end

    superFunc( self , display)
end

```

### getFillUnitAllowsFillType

**Description**

**Definition**

> getFillUnitAllowsFillType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | fillType      |

**Code**

```lua
function TreePlanter:getFillUnitAllowsFillType(superFunc, fillUnitIndex, fillType)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            return false
        end
    end

    return superFunc( self , fillUnitIndex, fillType)
end

```

### getFillUnitCapacity

**Description**

**Definition**

> getFillUnitCapacity()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function TreePlanter:getFillUnitCapacity(superFunc, fillUnitIndex)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            local capacity = 0
            local fillUnits = pallet:getFillUnits()
            for palletFillUnitIndex, _ in pairs(fillUnits) do
                capacity = capacity + pallet:getFillUnitCapacity(palletFillUnitIndex)
            end

            return capacity
        end
    end

    return superFunc( self , fillUnitIndex)
end

```

### getFillUnitFillLevel

**Description**

**Definition**

> getFillUnitFillLevel()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function TreePlanter:getFillUnitFillLevel(superFunc, fillUnitIndex)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            local fillLevel = 0
            local fillUnits = pallet:getFillUnits()
            for palletFillUnitIndex, _ in pairs(fillUnits) do
                fillLevel = fillLevel + pallet:getFillUnitFillLevel(palletFillUnitIndex)
            end

            return fillLevel
        end
    end

    return superFunc( self , fillUnitIndex)
end

```

### getFillUnitFillLevelPercentage

**Description**

**Definition**

> getFillUnitFillLevelPercentage()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function TreePlanter:getFillUnitFillLevelPercentage(superFunc, fillUnitIndex)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            local capacity = self:getFillUnitCapacity(fillUnitIndex)
            local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
            if capacity > 0 then
                return fillLevel / capacity
            end
        end
    end

    return superFunc( self , fillUnitIndex)
end

```

### getFillUnitFillType

**Description**

**Definition**

> getFillUnitFillType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function TreePlanter:getFillUnitFillType(superFunc, fillUnitIndex)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            local fillUnits = pallet:getFillUnits()
            for palletFillUnitIndex, _ in pairs(fillUnits) do
                if pallet:getFillUnitFillLevel(palletFillUnitIndex) > 0 then
                    return pallet:getFillUnitFillType(palletFillUnitIndex)
                end
            end
        end
    end

    return superFunc( self , fillUnitIndex)
end

```

### getFillUnitFreeCapacity

**Description**

**Definition**

> getFillUnitFreeCapacity()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | fillTypeIndex |
| any | farmId        |

**Code**

```lua
function TreePlanter:getFillUnitFreeCapacity(superFunc, fillUnitIndex, fillTypeIndex, farmId)
    local spec = self.spec_treePlanter
    if fillUnitIndex = = spec.fillUnitIndex then
        local pallet = spec.mountedSaplingPallet
        if pallet ~ = nil then
            return 0
        end
    end

    return superFunc( self , fillUnitIndex, fillTypeIndex, farmId)
end

```

### getFillUnitHasMountedPalletsToUnload

**Description**

**Definition**

> getFillUnitHasMountedPalletsToUnload()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TreePlanter:getFillUnitHasMountedPalletsToUnload(superFunc)
    return self.spec_treePlanter.mountedSaplingPallet ~ = nil
end

```

### getFillUnitMountedPalletsToUnload

**Description**

**Definition**

> getFillUnitMountedPalletsToUnload()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TreePlanter:getFillUnitMountedPalletsToUnload(superFunc)
    return { self.spec_treePlanter.mountedSaplingPallet }
end

```

### getFillUnitUnloadPalletFilename

**Description**

**Definition**

> getFillUnitUnloadPalletFilename()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |

**Code**

```lua
function TreePlanter:getFillUnitUnloadPalletFilename(superFunc, fillUnitIndex)
    local spec = self.spec_treePlanter
    if spec.mountedSaplingPallet = = nil then
        if spec.currentTreeTypeIndex ~ = nil then
            return g_treePlantManager:getPalletStoreItemFilenameByIndex(spec.currentTreeTypeIndex, 1 , spec.currentTreeVariationIndex)
        end
    end
end

```

### getHasObjectMounted

**Description**

> Returns if the vehicle (or any child) has the given object mounted

**Definition**

> getHasObjectMounted(table object, )

**Arguments**

| table | object | object |
|-------|--------|--------|
| any   | object |        |

**Return Values**

| any | hasObjectMounted | has object mounted |
|-----|------------------|--------------------|

**Code**

```lua
function TreePlanter:getHasObjectMounted(superFunc, object)
    if superFunc( self , object) then
        return true
    end

    local pallet = self.spec_treePlanter.mountedSaplingPallet
    if pallet ~ = nil then
        if pallet = = object then
            return true
        end

        if pallet.getHasObjectMounted ~ = nil then
            if pallet:getHasObjectMounted(object) then
                return true
            end
        end
    end

    return false
end

```

### getImplementAllowAutomaticSteering

**Description**

**Definition**

> getImplementAllowAutomaticSteering()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TreePlanter:getImplementAllowAutomaticSteering(superFunc)
    return true
end

```

### getIsOnField

**Description**

**Definition**

> getIsOnField()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TreePlanter:getIsOnField(superFunc)
    if superFunc( self ) then
        return true
    end

    -- since we don't need to be on a field to work we check only for ground contract
        if self.spec_treePlanter.hasGroundContact then
            return true
        end

        return false
    end

```

### getIsSpeedRotatingPartActive

**Description**

> Returns true if speed rotating part is active

**Definition**

> getIsSpeedRotatingPartActive(table speedRotatingPart, )

**Arguments**

| table | speedRotatingPart | speedRotatingPart |
|-------|-------------------|-------------------|
| any   | speedRotatingPart |                   |

**Return Values**

| any | isActive | speed rotating part is active |
|-----|----------|-------------------------------|

**Code**

```lua
function TreePlanter:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    local spec = self.spec_treePlanter

    if not spec.hasGroundContact then
        return false
    end

    return superFunc( self , speedRotatingPart)
end

```

### getIsWorkAreaActive

**Description**

**Definition**

> getIsWorkAreaActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |

**Code**

```lua
function TreePlanter:getIsWorkAreaActive(superFunc, workArea)
    local spec = self.spec_treePlanter

    local isActive = superFunc( self , workArea)
    if workArea.groundReferenceNode = = spec.groundReferenceNode then
        if not self:getIsTurnedOn() then
            isActive = false
        end
    end

    return isActive
end

```

### getSaplingPalletInRange

**Description**

> Returns nearest sapling pallet in range

**Definition**

> getSaplingPalletInRange(integer refNode, , )

**Arguments**

| integer | refNode          | id of reference node |
|---------|------------------|----------------------|
| any     | refNode          |                      |
| any     | palletsInTrigger |                      |

**Return Values**

| any | object | object of sapling pallet |
|-----|--------|--------------------------|

**Code**

```lua
function TreePlanter.getSaplingPalletInRange( self , refNode, palletsInTrigger)
    local spec = self.spec_treePlanter

    local nearestDistance = spec.nearestPalletDistance
    local nearestSaplingPallet = nil

    for object, state in pairs(palletsInTrigger) do
        if state ~ = nil and state > 0 then
            if object ~ = spec.mountedSaplingPallet then
                local distance = calcDistanceFrom(refNode, object.rootNode)
                if distance < nearestDistance then
                    local validPallet = false

                    local fillUnits = object:getFillUnits()
                    for fillUnitIndex, _ in pairs(fillUnits) do
                        local filltype = object:getFillUnitFillType(fillUnitIndex)
                        if filltype ~ = FillType.UNKNOWN then
                            if self:getFillUnitSupportsFillType(spec.fillUnitIndex, filltype) then
                                if object:getFillUnitFillLevel(fillUnitIndex) > 0 then
                                    validPallet = true
                                    break
                                end
                            end
                        end
                    end

                    if validPallet then
                        nearestSaplingPallet = object
                    end
                end

            end
        end
    end
    return nearestSaplingPallet
end

```

### getWearMultiplier

**Description**

> Returns current wear multiplier

**Definition**

> getWearMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function TreePlanter:getWearMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_treePlanter
    if spec.hasGroundContact then
        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function TreePlanter.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "TreePlanter" )

    schema:register(XMLValueType.STRING, "vehicle.treePlanter#inputAction" , "Name of the input action to plant a tree manually(If set, the trees are planted manual only)" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.treePlanter#node" , "Node index" )
    schema:register(XMLValueType.FLOAT, "vehicle.treePlanter#minDistance" , "Min.distance between trees" , 20 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.treePlanter#palletTrigger" , "Pallet trigger" )
    schema:register(XMLValueType.INT, "vehicle.treePlanter#refNodeIndex" , "Ground reference node index" , 1 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.treePlanter#saplingPalletGrabNode" , "Sapling pallet grab node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.treePlanter#saplingPalletMountNode" , "Sapling pallet mount node" )
    schema:register(XMLValueType.INT, "vehicle.treePlanter#fillUnitIndex" , "Fill unit index" )
    schema:register(XMLValueType.FLOAT, "vehicle.treePlanter#palletMountingRange" , "Min.distance from saplingPalletGrabNode to pallet to mount it" , 6 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.treePlanter.saplingNodes.saplingNode(?)#node" , "Link node for tree sapling(will be hidden based on fill level)" )

        schema:register(XMLValueType.STRING, "vehicle.treePlanter.plantAnimation#name" , "Name of plant animation" )
        schema:register(XMLValueType.FLOAT, "vehicle.treePlanter.plantAnimation#speedScale" , "Speed scale of animation" , 1 )

        schema:register(XMLValueType.STRING, "vehicle.treePlanter.magazineAnimation#name" , "Name of magazine animation(updated based on fill level)" )
        schema:register(XMLValueType.FLOAT, "vehicle.treePlanter.magazineAnimation#speedScale" , "Speed scale of animation" , 1 )
        schema:register(XMLValueType.INT, "vehicle.treePlanter.magazineAnimation#numRows" , "Number of rows on the magazine" , 1 )

        SoundManager.registerSampleXMLPaths(schema, "vehicle.treePlanter.sounds" , "work" )
        AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.treePlanter.animationNodes" )

        schema:setXMLSpecializationType()

        local schemaSavegame = Vehicle.xmlSchemaSavegame
        schemaSavegame:register(XMLValueType.VECTOR_TRANS, "vehicles.vehicle(?).treePlanter#lastTreePos" , "Position of last tree" )
        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).treePlanter#palletHadBeenMounted" , "Pallet is mounted" )
        schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).treePlanter#currentTreeType" , "Name of currently loaded tree type" )
        schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).treePlanter#currentTreeVariation" , "Name of currently loaded tree stage variation" )
    end

```

### loadPallet

**Description**

> Called on loading

**Definition**

> loadPallet(table savegame, )

**Arguments**

| table | savegame    | savegame |
|-------|-------------|----------|
| any   | noEventSend |          |

**Code**

```lua
function TreePlanter:loadPallet(palletObjectId, noEventSend)
    local spec = self.spec_treePlanter

    TreePlanterLoadPalletEvent.sendEvent( self , palletObjectId, noEventSend)

    spec.palletIdToMount = palletObjectId
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function TreePlanter:onDelete()
    local spec = self.spec_treePlanter

    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)

    if spec.activatable ~ = nil then
        g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
    end

    if spec.mountedSaplingPallet ~ = nil then
        spec.mountedSaplingPallet:unmount( true )
        spec.mountedSaplingPallet = nil
    end

    if spec.palletTrigger ~ = nil then
        removeTrigger(spec.palletTrigger)

        g_currentMission:removeNodeObject(spec.palletTrigger)
    end

    if spec.saplingSharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.saplingSharedLoadRequestId)
        spec.saplingSharedLoadRequestId = nil
    end
end

```

### onDeleteTreePlanterObject

**Description**

**Definition**

> onDeleteTreePlanterObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function TreePlanter:onDeleteTreePlanterObject(object)
    local spec = self.spec_treePlanter
    if spec.mountedSaplingPallet = = object then
        spec.mountedSaplingPallet = nil
    end

    spec.palletsInTrigger[object] = nil
end

```

### onDraw

**Description**

> Called on draw

**Definition**

> onDraw(boolean isActiveForInput, boolean isSelected, )

**Arguments**

| boolean | isActiveForInput | true if vehicle is active for input |
|---------|------------------|-------------------------------------|
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function TreePlanter:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_treePlanter

    if isActiveForInputIgnoreSelection then
        if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 then
            g_currentMission:addExtraPrintText(g_i18n:getText( "info_firstFillTheTool" ))
        end

        if spec.currentTreeTypeIndex ~ = nil and self:getFillUnitFillLevel(spec.fillUnitIndex) > 0 then
            if spec.treeTypeExtraPrintText ~ = nil then
                g_currentMission:addExtraPrintText(spec.treeTypeExtraPrintText)
            end
        end
    end

    if spec.showFieldNotOwnedWarning then
        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_youDontHaveAccessToThisLand" ))
    end

    if spec.showRestrictedZoneWarning then
        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_actionNotAllowedHere" ))
    end

    if spec.showTooManyTreesWarning then
        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_tooManyTrees" ))
    end

    if spec.showWrongPlantingTimeWarning then
        g_currentMission:showBlinkingWarning( string.format(g_i18n:getText( "warning_theSelectedFruitTypeCantBePlantedInThisPeriod" ), g_i18n:formatPeriod()), 100 )
    end
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function TreePlanter:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if fillUnitIndex = = self.spec_treePlanter.fillUnitIndex then
        self:updateTreePlanterFillLevel()
    end
end

```

### onFillUnitIsFillingStateChanged

**Description**

**Definition**

> onFillUnitIsFillingStateChanged()

**Arguments**

| any | isFilling |
|-----|-----------|

**Code**

```lua
function TreePlanter:onFillUnitIsFillingStateChanged(isFilling)
    if self.isServer then
        if isFilling then
            local trigger = self.spec_fillUnit.fillTrigger.currentTrigger
            if trigger ~ = nil and trigger.sourceObject ~ = nil then
                if trigger.sourceObject.getTreeSaplingPalletType ~ = nil then
                    local treeTypeName, variationName = trigger.sourceObject:getTreeSaplingPalletType()
                    local treeTypeIndex, variationIndex = g_treePlantManager:getTreeTypeIndexAndVariationFromName(treeTypeName, 1 , variationName)

                    self:setTreePlanterTreeTypeIndex(treeTypeIndex, variationIndex)
                end
            end
        end
    end
end

```

### onFillUnitUnloadPallet

**Description**

**Definition**

> onFillUnitUnloadPallet()

**Arguments**

| any | pallet |
|-----|--------|

**Code**

```lua
function TreePlanter:onFillUnitUnloadPallet(pallet)
    local spec = self.spec_treePlanter
    if pallet.setTreeSaplingPalletType ~ = nil then
        local treeTypeName, variationName = g_treePlantManager:getTreeTypeNameAndVariationByIndex(spec.currentTreeTypeIndex, 1 , spec.currentTreeVariationIndex)
        pallet:setTreeSaplingPalletType(treeTypeName, variationName)
    end

    if spec.mountedSaplingPallet = = pallet then
        spec.mountedSaplingPallet = nil
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
function TreePlanter:onLoad(savegame)
    local spec = self.spec_treePlanter

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.treePlanterSound" , "vehicle.treePlanter.sounds.work" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode(0)" , "vehicle.treePlanter.animationNodes.animationNode" ) --FS17 to FS19

    local baseKey = "vehicle.treePlanter"

    if self.isClient then
        spec.samples = { }
        spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isWorkSamplePlaying = false

        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".animationNodes" , self.components, self , self.i3dMappings)
    end

    spec.inputAction = InputAction[ self.xmlFile:getValue(baseKey .. "#inputAction" )]

    spec.node = self.xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
    spec.minDistance = self.xmlFile:getValue(baseKey .. "#minDistance" , 20 ) -- distance to next tree

    spec.palletTrigger = self.xmlFile:getValue(baseKey .. "#palletTrigger" , nil , self.components, self.i3dMappings)
    if spec.palletTrigger ~ = nil then
        addTrigger(spec.palletTrigger, "palletTriggerCallback" , self )

        g_currentMission:addNodeObject(spec.palletTrigger, self )
    else
            Logging.xmlWarning( self.xmlFile, "TreePlanter requires a palletTrigger!" )
        end
        spec.palletsInTrigger = { }

        local refNodeIndex = self.xmlFile:getValue(baseKey .. "#refNodeIndex" , 1 )
        spec.groundReferenceNode = self:getGroundReferenceNodeFromIndex(refNodeIndex)
        if spec.groundReferenceNode = = nil then
            Logging.xmlWarning( self.xmlFile, "No groundReferenceNode specified or invalid groundReferenceNode index in '%s'" , baseKey .. "#refNodeIndex" )
        end

        spec.currentTreeTypeIndex = nil
        spec.currentTreeVariationIndex = nil

        spec.saplingNodes = { }
        self.xmlFile:iterate(baseKey .. ".saplingNodes.saplingNode" , function (index, key)
            local node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            if node ~ = nil then
                table.insert(spec.saplingNodes, node)
            end
        end )

        spec.plantAnimation = { }
        spec.plantAnimation.name = self.xmlFile:getValue(baseKey .. ".plantAnimation#name" )
        spec.plantAnimation.speedScale = self.xmlFile:getValue(baseKey .. ".plantAnimation#speedScale" , 1 )

        spec.magazineAnimation = { }
        spec.magazineAnimation.name = self.xmlFile:getValue(baseKey .. ".magazineAnimation#name" )
        spec.magazineAnimation.speedScale = self.xmlFile:getValue(baseKey .. ".magazineAnimation#speedScale" , 1 )
        spec.magazineAnimation.numRows = self.xmlFile:getValue(baseKey .. ".magazineAnimation#numRows" , 1 )

        spec.activatable = TreePlanterActivatable.new( self )

        spec.saplingPalletGrabNode = self.xmlFile:getValue(baseKey .. "#saplingPalletGrabNode" , self.rootNode, self.components, self.i3dMappings)
        spec.saplingPalletMountNode = self.xmlFile:getValue(baseKey .. "#saplingPalletMountNode" , self.rootNode, self.components, self.i3dMappings)
        spec.mountedSaplingPallet = nil

        spec.fillUnitIndex = self.xmlFile:getValue( baseKey .. "#fillUnitIndex" , 1 )
        spec.nearestPalletDistance = self.xmlFile:getValue( baseKey .. "#palletMountingRange" , 6.0 )

        spec.currentTree = 1
        spec.lastTreePos = nil

        spec.showFieldNotOwnedWarning = false
        spec.showRestrictedZoneWarning = false
        spec.showTooManyTreesWarning = false
        spec.hasGroundContact = false
        spec.showWrongPlantingTimeWarning = false

        spec.limitToField = true
        spec.forceLimitToField = false

        -- attributes for AI
            if self.addAIGroundTypeRequirements ~ = nil then
                self:addAIGroundTypeRequirements( TreePlanter.AI_REQUIRED_GROUND_TYPES)

                if self.setAIFruitProhibitions ~ = nil then
                    self:setAIFruitProhibitions(FruitType.POPLAR, 1 , 5 )
                end
            end

            spec.dirtyFlag = self:getNextDirtyFlag()

            if savegame ~ = nil and not savegame.resetVehicles then
                spec.lastTreePos = savegame.xmlFile:getValue(savegame.key .. ".treePlanter#lastTreePos" , nil , true )

                spec.palletHadBeenMounted = savegame.xmlFile:getValue(savegame.key .. ".treePlanter#palletHadBeenMounted" )

                local treeTypeName = savegame.xmlFile:getValue(savegame.key .. ".treePlanter#currentTreeType" )
                local variationName = savegame.xmlFile:getValue(savegame.key .. ".treePlanter#currentTreeVariation" )
                if treeTypeName ~ = nil then
                    local treeTypeIndex, variationIndex = g_treePlantManager:getTreeTypeIndexAndVariationFromName(treeTypeName, 1 , variationName)

                    self:setTreePlanterTreeTypeIndex(treeTypeIndex, variationIndex, true )
                end
            end
        end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function TreePlanter:onReadStream(streamId, connection)
    local spec = self.spec_treePlanter
    if streamReadBool(streamId) then
        spec.palletIdToMount = NetworkUtil.readNodeObjectId(streamId)
    end

    if streamReadBool(streamId) then
        local treeTypeIndex = streamReadUInt32(streamId)
        local variationIndex = streamReadUIntN(streamId, TreePlantManager.VARIATION_NUM_BITS)
        self:setTreePlanterTreeTypeIndex(treeTypeIndex, variationIndex, true )
    end

    if streamReadBool(streamId) then
        local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
        local paramsY = g_currentMission.vehicleYPosCompressionParams
        local x = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        local y = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
        local z = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)

        spec.lastTreePos = { x, y, z }
    end
end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function TreePlanter:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_treePlanter
        if streamReadBool(streamId) then
            spec.hasGroundContact = streamReadBool(streamId)
            spec.showFieldNotOwnedWarning = streamReadBool(streamId)
            spec.showRestrictedZoneWarning = streamReadBool(streamId)
        end
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
function TreePlanter:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_treePlanter
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if not spec.forceLimitToField then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , TreePlanter.actionEventToggleTreePlanterFieldLimitation, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            end

            if spec.inputAction ~ = nil then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, spec.inputAction, self , TreePlanter.actionEventPlant, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_plantTree" ))
            end
        end
    end
end

```

### onTreePlanterSaplingLoaded

**Description**

> Called after the sapling has been loaded

**Definition**

> onTreePlanterSaplingLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Return Values**

| any | i3dNode | i3d node id |
|-----|---------|-------------|
| any | args    | arguments   |

**Code**

```lua
function TreePlanter:onTreePlanterSaplingLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        local sourceSapling = getChildAt(i3dNode, 0 )

        local spec = self.spec_treePlanter
        for i = 1 , #spec.saplingNodes do
            local sapling = clone(sourceSapling, false , false , false )
            link(spec.saplingNodes[i], sapling)
        end

        self:updateTreePlanterFillLevel( true )

        delete(i3dNode)
    end
end

```

### onTurnedOff

**Description**

> Called on turn off

**Definition**

> onTurnedOff(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function TreePlanter:onTurnedOff()
    if self.isClient then
        local spec = self.spec_treePlanter
        g_animationManager:stopAnimations(spec.animationNodes)
        g_soundManager:stopSamples(spec.samples)
        spec.isWorkSamplePlaying = false
    end
end

```

### onTurnedOn

**Description**

> Called on turn off

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function TreePlanter:onTurnedOn()
    if self.isClient then
        local spec = self.spec_treePlanter
        g_animationManager:startAnimations(spec.animationNodes)
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
function TreePlanter:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_treePlanter

    if self.finishedFirstUpdate then
        local pallet
        if spec.palletIdToMount ~ = nil then
            pallet = NetworkUtil.getObject(spec.palletIdToMount)
        elseif spec.palletHadBeenMounted then
                spec.palletHadBeenMounted = nil
                pallet = TreePlanter.getSaplingPalletInRange( self , spec.saplingPalletMountNode, spec.palletsInTrigger)
            end

            if pallet ~ = nil and pallet:getIsSynchronized() then
                pallet:mount( self , spec.saplingPalletMountNode, 0 , 0 , 0 , 0 , 0 , 0 )
                spec.mountedSaplingPallet = pallet
                g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                spec.palletIdToMount = nil

                if self.isServer then
                    if pallet.getTreeSaplingPalletType ~ = nil then
                        local treeTypeName, variationName = pallet:getTreeSaplingPalletType()
                        local treeTypeIndex, variationIndex = g_treePlantManager:getTreeTypeIndexAndVariationFromName(treeTypeName, 1 , variationName)

                        self:setTreePlanterTreeTypeIndex(treeTypeIndex, variationIndex)
                    end
                end

                FillUnit.updateUnloadActionDisplay( self )
            end
        end

        if self.isClient then
            local nearestSaplingPallet = nil
            if spec.mountedSaplingPallet = = nil then
                nearestSaplingPallet = TreePlanter.getSaplingPalletInRange( self , spec.saplingPalletGrabNode, spec.palletsInTrigger)
            end

            if spec.nearestSaplingPallet ~ = nearestSaplingPallet then
                spec.nearestSaplingPallet = nearestSaplingPallet

                if nearestSaplingPallet ~ = nil then
                    g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
                else
                        g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                    end
                end
            end

            if spec.mountedSaplingPallet ~ = nil then
                if spec.mountedSaplingPallet.isDeleted then
                    spec.palletsInTrigger[spec.mountedSaplingPallet] = nil
                    spec.mountedSaplingPallet = nil
                else
                        spec.mountedSaplingPallet:raiseActive()
                    end
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
function TreePlanter:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_treePlanter

    spec.showTooManyTreesWarning = false
    local showFieldNotOwnedWarning = false
    local showRestrictedZoneWarning = false

    if self.isServer then
        local hasGroundContact = false
        if spec.groundReferenceNode ~ = nil then
            hasGroundContact = self:getIsGroundReferenceNodeActive(spec.groundReferenceNode)
        end

        if spec.hasGroundContact ~ = hasGroundContact then
            self:raiseDirtyFlags(spec.dirtyFlag)
            spec.hasGroundContact = hasGroundContact
        end
    end

    if self:getIsAIActive() then
        if not g_currentMission.missionInfo.helperBuySeeds then
            if spec.mountedSaplingPallet = = nil then
                local rootVehicle = self.rootVehicle
                rootVehicle:stopCurrentAIJob( AIMessageErrorOutOfFill.new())
            end
        end
    end

    spec.showWrongPlantingTimeWarning = false

    if spec.hasGroundContact then
        if self:getIsTurnedOn() then
            local isPlantingSeason = true
            if not self:getCanPlantOutsideSeason() then
                local fillType = self:getFillUnitFillType(spec.fillUnitIndex)

                local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByFillTypeIndex(fillType)
                isPlantingSeason = fruitTypeDesc = = nil or fruitTypeDesc:getIsPlantableInPeriod(g_currentMission.missionInfo.growthMode, g_currentMission.environment.currentPeriod)
            end
            spec.showWrongPlantingTimeWarning = not isPlantingSeason

            if self.isServer and isPlantingSeason then
                local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
                local fillType = self:getFillUnitFillType(spec.fillUnitIndex)

                if g_currentMission.missionInfo.helperBuySeeds then
                    if self:getIsAIActive() then
                        if spec.mountedSaplingPallet ~ = nil then
                            fillType = spec.mountedSaplingPallet:getFillUnitFillType( 1 )
                        else
                                fillType = FillType.POPLAR
                            end
                        end
                    end

                    if fillLevel = = 0 and( not self:getIsAIActive() or not g_currentMission.missionInfo.helperBuySeeds) then
                        fillType = FillType.UNKNOWN
                    end

                    if fillType = = FillType.TREESAPLINGS then
                        if self:getLastSpeed() > 1 then
                            local x,y,z = getWorldTranslation(spec.node)
                            if g_currentMission.accessHandler:canFarmAccessLand( self:getActiveFarm(), x, z) then
                                if not PlacementUtil.isInsideRestrictedZone(g_currentMission.restrictedZones, x, y, z, true ) then
                                    if spec.lastTreePos ~ = nil then
                                        local distance = MathUtil.vector3Length(x - spec.lastTreePos[ 1 ], y - spec.lastTreePos[ 2 ], z - spec.lastTreePos[ 3 ])
                                        if distance > spec.minDistance then
                                            self:createTree()
                                        end
                                    else
                                            self:createTree()
                                        end
                                    else
                                            showRestrictedZoneWarning = true
                                        end
                                    else
                                            showFieldNotOwnedWarning = true
                                        end
                                    end
                                elseif fillType ~ = FillType.UNKNOWN then
                                        local x,_,z = getWorldTranslation(spec.node)
                                        if g_currentMission.accessHandler:canFarmAccessLand( self:getActiveFarm(), x, z) then
                                            local width = math.sqrt( g_currentMission:getFruitPixelsToSqm() ) * 0.5

                                            local sx,_,sz = localToWorld(spec.node, - width, 0 ,width)
                                            local wx,_,wz = localToWorld(spec.node, width, 0 ,width)
                                            local hx,_,hz = localToWorld(spec.node, - width, 0 , 3 * width)

                                            local fruitType = g_fruitTypeManager:getFruitTypeIndexByFillTypeIndex(fillType)
                                            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitType)

                                            local dx,_,dz = localDirectionToWorld(spec.node, 0 , 0 , 1 )
                                            local angleRad = MathUtil.getYRotationFromDirection(dx, dz)
                                            if fruitDesc ~ = nil and fruitDesc.directionSnapAngle ~ = 0 then
                                                angleRad = math.floor(angleRad / fruitDesc.directionSnapAngle + 0.5 ) * fruitDesc.directionSnapAngle
                                            end
                                            local angle = FSDensityMapUtil.convertToDensityMapAngle(angleRad, g_currentMission.fieldGroundSystem:getGroundAngleMaxValue())

                                            -- cultivate
                                            local limitToField = spec.limitToField or spec.forceLimitToField
                                            local limitFruitDestructionToField = spec.limitToField or spec.forceLimitToField
                                            FSDensityMapUtil.updateCultivatorArea(sx,sz, wx,wz, hx,hz, not limitToField, limitFruitDestructionToField, angle, nil )
                                            FSDensityMapUtil.eraseTireTrack(sx,sz, wx,wz, hx,hz)

                                            -- plant, shift area
                                            sx,_,sz = localToWorld(spec.node, - width, 0 , - 3 * width)
                                            wx,_,wz = localToWorld(spec.node, width, 0 , - 3 * width)
                                            hx,_,hz = localToWorld(spec.node, - width, 0 , - width)

                                            local sowingValue = FieldGroundType.getValueByType(FieldGroundType.SOWN)
                                            local area, _ = FSDensityMapUtil.updateSowingArea(fruitType, sx,sz, wx,wz, hx,hz, sowingValue, false , angle, 2 )

                                            local usage = fruitDesc.seedUsagePerSqm * area

                                            local farmId = self:getActiveFarm()
                                            if self:getIsAIActive() and g_currentMission.missionInfo.helperBuySeeds then
                                                local price = usage * g_currentMission.economyManager:getCostPerLiter(FillType.SEEDS, false ) * 1.5 -- increase price if AI is active to reward the player's manual work
                                                    g_farmManager:updateFarmStats(farmId, "expenses" , price)
                                                    g_currentMission:addMoney( - price, self:getActiveFarm(), MoneyType.PURCHASE_SEEDS)
                                                else
                                                        self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - usage, fillType, ToolType.UNDEFINED)
                                                    end

                                                    local lastHa = MathUtil.areaToHa(area, g_currentMission:getFruitPixelsToSqm())
                                                    g_farmManager:updateFarmStats(farmId, "seedUsage" , usage)
                                                    g_farmManager:updateFarmStats(farmId, "sownHectares" , lastHa)
                                                    g_farmManager:updateFarmStats(farmId, "sownTime" , dt / ( 1000 * 60 ))

                                                    self:updateLastWorkedArea(area)
                                                else
                                                        showFieldNotOwnedWarning = true
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    if self.isServer then
                                        if spec.showFieldNotOwnedWarning ~ = showFieldNotOwnedWarning or spec.showRestrictedZoneWarning ~ = showRestrictedZoneWarning then
                                            spec.showFieldNotOwnedWarning = showFieldNotOwnedWarning
                                            spec.showRestrictedZoneWarning = showRestrictedZoneWarning
                                            self:raiseDirtyFlags(spec.dirtyFlag)
                                        end
                                    end

                                    if self.isClient then
                                        if self:getIsTurnedOn() and spec.hasGroundContact and self:getLastSpeed() > 1 then
                                            if not spec.isWorkSamplePlaying then
                                                g_soundManager:playSample(spec.samples.work)
                                                spec.isWorkSamplePlaying = true
                                            end
                                        else
                                                if spec.isWorkSamplePlaying then
                                                    g_soundManager:stopSample(spec.samples.work)
                                                    spec.isWorkSamplePlaying = false
                                                end
                                            end

                                            local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
                                            if actionEvent ~ = nil then
                                                local showAction = false

                                                if isActiveForInputIgnoreSelection then
                                                    local fillType = self:getFillUnitFillType(spec.fillUnitIndex)
                                                    if fillType ~ = FillType.UNKNOWN and fillType ~ = FillType.TREESAPLINGS then
                                                        if g_currentMission:getHasPlayerPermission( "createFields" , self:getOwnerConnection()) then
                                                            if not spec.forceLimitToField then
                                                                showAction = true
                                                            end
                                                        end
                                                    end

                                                    if showAction then
                                                        if spec.limitToField then
                                                            g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText( "action_allowCreateFields" ))
                                                        else
                                                                g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText( "action_limitToFields" ))
                                                            end
                                                        end
                                                    end

                                                    g_inputBinding:setActionEventActive(actionEvent.actionEventId, showAction)
                                                end

                                                if spec.inputAction ~ = nil then
                                                    local actionEvent = spec.actionEvents[spec.inputAction]
                                                    if actionEvent ~ = nil then
                                                        local isActive = true
                                                        if spec.lastTreePos ~ = nil then
                                                            local x, y, z = getWorldTranslation(spec.node)
                                                            local distance = MathUtil.vector3Length(x - spec.lastTreePos[ 1 ], y - spec.lastTreePos[ 2 ], z - spec.lastTreePos[ 3 ])
                                                            isActive = distance > spec.minDistance
                                                        end

                                                        g_inputBinding:setActionEventActive(actionEvent.actionEventId, isActive and self:getFillUnitFillLevel(spec.fillUnitIndex) > 0 )
                                                    end
                                                end
                                            end
                                        end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function TreePlanter:onWriteStream(streamId, connection)
    local spec = self.spec_treePlanter
    streamWriteBool(streamId, spec.mountedSaplingPallet ~ = nil )
    if spec.mountedSaplingPallet ~ = nil then
        local palletId = NetworkUtil.getObjectId(spec.mountedSaplingPallet)
        NetworkUtil.writeNodeObjectId(streamId, palletId)
    end

    if streamWriteBool(streamId, spec.currentTreeTypeIndex ~ = nil ) then
        streamWriteUInt32(streamId, spec.currentTreeTypeIndex)
        streamWriteUIntN(streamId, spec.currentTreeVariationIndex or 1 , TreePlantManager.VARIATION_NUM_BITS)
    end

    if streamWriteBool(streamId, spec.lastTreePos ~ = nil ) then
        local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
        local paramsY = g_currentMission.vehicleYPosCompressionParams
        NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastTreePos[ 1 ], paramsXZ)
        NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastTreePos[ 2 ], paramsY)
        NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastTreePos[ 3 ], paramsXZ)
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function TreePlanter:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_treePlanter
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteBool(streamId, spec.hasGroundContact)
            streamWriteBool(streamId, spec.showFieldNotOwnedWarning)
            streamWriteBool(streamId, spec.showRestrictedZoneWarning)
        end
    end
end

```

### palletTriggerCallback

**Description**

**Definition**

> palletTriggerCallback()

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
function TreePlanter:palletTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_treePlanter

    if otherId ~ = 0 then
        local object = g_currentMission:getNodeObject(otherId)
        if object ~ = nil and object.isa ~ = nil then
            if object:isa( Vehicle ) then
                if object.isPallet and g_currentMission.accessHandler:canFarmAccess( self:getActiveFarm(), object) then
                    local currentValue = Utils.getNoNil(spec.palletsInTrigger[object], 0 )

                    if onEnter then
                        spec.palletsInTrigger[object] = currentValue + 1

                        if currentValue = = 0 and object.addDeleteListener ~ = nil then
                            object:addDeleteListener( self , "onDeleteTreePlanterObject" )
                        end
                    elseif onLeave then
                            spec.palletsInTrigger[object] = math.max(currentValue - 1 , 0 )
                        end

                        if spec.palletsInTrigger[object] = = 0 then
                            spec.palletsInTrigger[object] = nil
                        end
                    end
                end
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
function TreePlanter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
    and SpecializationUtil.hasSpecialization( FillUnit , specializations)
    and SpecializationUtil.hasSpecialization( GroundReference , specializations)
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
function TreePlanter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitIsFillingStateChanged" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , TreePlanter )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitUnloadPallet" , TreePlanter )
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
function TreePlanter.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "removeMountedObject" , TreePlanter.removeMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "setPlantLimitToField" , TreePlanter.setPlantLimitToField)
    SpecializationUtil.registerFunction(vehicleType, "createTree" , TreePlanter.createTree)
    SpecializationUtil.registerFunction(vehicleType, "loadPallet" , TreePlanter.loadPallet)
    SpecializationUtil.registerFunction(vehicleType, "palletTriggerCallback" , TreePlanter.palletTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onDeleteTreePlanterObject" , TreePlanter.onDeleteTreePlanterObject)
    SpecializationUtil.registerFunction(vehicleType, "getCanPlantOutsideSeason" , TreePlanter.getCanPlantOutsideSeason)
    SpecializationUtil.registerFunction(vehicleType, "setTreePlanterTreeTypeIndex" , TreePlanter.setTreePlanterTreeTypeIndex)
    SpecializationUtil.registerFunction(vehicleType, "onTreePlanterSaplingLoaded" , TreePlanter.onTreePlanterSaplingLoaded)
    SpecializationUtil.registerFunction(vehicleType, "updateTreePlanterFillLevel" , TreePlanter.updateTreePlanterFillLevel)
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
function TreePlanter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , TreePlanter.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , TreePlanter.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , TreePlanter.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , TreePlanter.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , TreePlanter.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , TreePlanter.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsOnField" , TreePlanter.getIsOnField)

    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addFillUnitFillLevel" , TreePlanter.addFillUnitFillLevel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitFillLevel" , TreePlanter.getFillUnitFillLevel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitFillLevelPercentage" , TreePlanter.getFillUnitFillLevelPercentage)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitFillType" , TreePlanter.getFillUnitFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitCapacity" , TreePlanter.getFillUnitCapacity)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitAllowsFillType" , TreePlanter.getFillUnitAllowsFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitFreeCapacity" , TreePlanter.getFillUnitFreeCapacity)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillLevelInformation" , TreePlanter.getFillLevelInformation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getHasObjectMounted" , TreePlanter.getHasObjectMounted)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitHasMountedPalletsToUnload" , TreePlanter.getFillUnitHasMountedPalletsToUnload)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitUnloadPalletFilename" , TreePlanter.getFillUnitUnloadPalletFilename)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitMountedPalletsToUnload" , TreePlanter.getFillUnitMountedPalletsToUnload)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getImplementAllowAutomaticSteering" , TreePlanter.getImplementAllowAutomaticSteering)
end

```

### removeMountedObject

**Description**

> Remove mounted object

**Definition**

> removeMountedObject(integer object, boolean isDeleting)

**Arguments**

| integer | object     | object to remove |
|---------|------------|------------------|
| boolean | isDeleting | called on delete |

**Code**

```lua
function TreePlanter:removeMountedObject(object, isDeleting)
    local spec = self.spec_treePlanter

    if spec.mountedSaplingPallet = = object then
        spec.mountedSaplingPallet:unmount()
        spec.mountedSaplingPallet = nil
    end
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
function TreePlanter:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_treePlanter

    if spec.lastTreePos ~ = nil then
        xmlFile:setValue(key .. "#lastTreePos" , unpack(spec.lastTreePos))
    end
    if spec.mountedSaplingPallet ~ = nil then
        xmlFile:setValue(key .. "#palletHadBeenMounted" , true )
    end

    if spec.currentTreeTypeIndex ~ = nil then
        local treeTypeName, variationName = g_treePlantManager:getTreeTypeNameAndVariationByIndex(spec.currentTreeTypeIndex, 1 , spec.currentTreeVariationIndex)

        if treeTypeName ~ = nil then
            xmlFile:setValue(key .. "#currentTreeType" , treeTypeName)
        end
        if variationName ~ = nil then
            xmlFile:setValue(key .. "#currentTreeVariation" , variationName)
        end
    end
end

```

### setPlantLimitToField

**Description**

> Set plant limit to field state

**Definition**

> setPlantLimitToField(boolean plantLimitToField, boolean noEventSend)

**Arguments**

| boolean | plantLimitToField | plant limit to field state |
|---------|-------------------|----------------------------|
| boolean | noEventSend       | no event send              |

**Code**

```lua
function TreePlanter:setPlantLimitToField(plantLimitToField, noEventSend)
    local spec = self.spec_treePlanter

    if spec.limitToField ~ = plantLimitToField then
        spec.limitToField = plantLimitToField

        PlantLimitToFieldEvent.sendEvent( self , plantLimitToField, noEventSend)
    end
end

```

### setTreePlanterTreeTypeIndex

**Description**

**Definition**

> setTreePlanterTreeTypeIndex()

**Arguments**

| any | treeTypeIndex      |
|-----|--------------------|
| any | treeVariationIndex |
| any | noEventSend        |

**Code**

```lua
function TreePlanter:setTreePlanterTreeTypeIndex(treeTypeIndex, treeVariationIndex, noEventSend)
    local spec = self.spec_treePlanter
    if treeTypeIndex ~ = spec.currentTreeTypeIndex or treeVariationIndex ~ = spec.currentTreeVariationIndex then
        spec.currentTreeTypeIndex = treeTypeIndex
        spec.currentTreeVariationIndex = treeVariationIndex

        local treeTypeDesc = g_treePlantManager:getTreeTypeDescFromIndex(spec.currentTreeTypeIndex)
        if treeTypeDesc ~ = nil then
            spec.treeTypeExtraPrintText = string.format( "%s: %s" , g_i18n:getText( "configuration_treeType" ), treeTypeDesc.title)
        end

        if #spec.saplingNodes > 0 then
            if spec.saplingSharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile(spec.saplingSharedLoadRequestId)
                spec.saplingSharedLoadRequestId = nil
            end

            local treeSaplingFilename
            if treeTypeDesc ~ = nil then
                local variations = treeTypeDesc.stages[ 1 ]
                if variations ~ = nil then
                    local variation = variations[treeVariationIndex]
                    if variation ~ = nil then
                        treeSaplingFilename = variation.planterFilename or variation.filename
                    end
                end
            end

            if treeSaplingFilename ~ = nil then
                spec.saplingSharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(treeSaplingFilename, false , false , self.onTreePlanterSaplingLoaded, self )
            end
        end

        TreePlanterTreeTypeEvent.sendEvent( self , treeTypeIndex, treeVariationIndex, noEventSend)
    end
end

```

### updateTreePlanterFillLevel

**Description**

**Definition**

> updateTreePlanterFillLevel()

**Arguments**

| any | onLoad |
|-----|--------|

**Code**

```lua
function TreePlanter:updateTreePlanterFillLevel(onLoad)
    local spec = self.spec_treePlanter

    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
    local capacity = self:getFillUnitCapacity(spec.fillUnitIndex)

    for i = 1 , #spec.saplingNodes do
        local node = spec.saplingNodes[i]
        setVisibility(node, i < = MathUtil.round(fillLevel))

        I3DUtil.setShaderParameterRec(node, "hideByIndex" , capacity - fillLevel, 0 , 0 , 0 )
    end

    if spec.magazineAnimation.name ~ = nil then
        local targetAnimationTime = math.ceil(((fillLevel - 1 ) / capacity) * spec.magazineAnimation.numRows) / spec.magazineAnimation.numRows
        local animationTime = self:getAnimationTime(spec.magazineAnimation.name)
        if targetAnimationTime ~ = animationTime then
            self:setAnimationStopTime(spec.magazineAnimation.name, targetAnimationTime)
            self:playAnimation(spec.magazineAnimation.name, spec.magazineAnimation.speedScale * math.sign(targetAnimationTime - animationTime), animationTime, true )

            if onLoad then
                AnimatedVehicle.updateAnimationByName( self , spec.magazineAnimation.name, 999999 , true )
            end
        end
    end

    if spec.unloadActionEventId ~ = nil then
        g_inputBinding:setActionEventActive(spec.unloadActionEventId, fillLevel > 0 )
    end
end

```