## CropRowAdjustedNodes

**Description**

> Specialization for adjusting nodes to crop rows / terrain raster

**Functions**

- [getIsCropRowAdjustedNodeActive](#getiscroprowadjustednodeactive)
- [initSpecialization](#initspecialization)
- [loadCropRowAdjustedNodeFromXML](#loadcroprowadjustednodefromxml)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [updateCropRowAdjustedNode](#updatecroprowadjustednode)

### getIsCropRowAdjustedNodeActive

**Description**

**Definition**

> getIsCropRowAdjustedNodeActive()

**Arguments**

| any | adjustedNode |
|-----|--------------|

**Code**

```lua
function CropRowAdjustedNodes:getIsCropRowAdjustedNodeActive(adjustedNode)
    local spec_foldable = self.spec_foldable
    if spec_foldable ~ = nil then
        local foldAnimTime = spec_foldable.foldAnimTime
        if foldAnimTime ~ = nil and(foldAnimTime > adjustedNode.foldMaxLimit or foldAnimTime < adjustedNode.foldMinLimit) then
            return false
        end
    end

    if self.getIsLowered = = nil or not self:getIsLowered() then
        return false
    end

    local dx, _, dz = localDirectionToWorld(adjustedNode.referenceFrame, 0 , 0 , 1 )
    local yRot = MathUtil.getYRotationFromDirection( MathUtil.vector2Normalize(dx, dz))
    yRot = yRot % ( math.pi * 0.5 )

    if math.abs(yRot) < CropRowAdjustedNodes.MAX_ACTIVE_ANGLE or math.abs(yRot) > 1.5708 - CropRowAdjustedNodes.MAX_ACTIVE_ANGLE then
        return true
    end

    return false
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function CropRowAdjustedNodes.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "CropRowAdjustedNodes" )

    schema:register(XMLValueType.FLOAT, "vehicle.cropRowAdjustedNodes#maxUpdateDistance" , "If the player is more than this distance away the nodes will no longer be updated" , 100 )

    local adjustedNodePath = "vehicle.cropRowAdjustedNodes.adjustedNode(?)"

    schema:register(XMLValueType.NODE_INDEX, adjustedNodePath .. "#node" , "Row adjusted node" )
    schema:register(XMLValueType.INT, adjustedNodePath .. "#transAxis" , "Translation Axis" , 1 )
    schema:register(XMLValueType.FLOAT, adjustedNodePath .. "#minTrans" , "Min.translation value" , - 0.25 )
    schema:register(XMLValueType.FLOAT, adjustedNodePath .. "#maxTrans" , "Max.translation value" , 0.25 )
    schema:register(XMLValueType.FLOAT, adjustedNodePath .. "#moveSpeed" , "Move speed(m/sec)" , 0.25 )

    schema:register(XMLValueType.BOOL, adjustedNodePath .. "#betweenRows" , "Defines if the node is aligned on the rows or the middle between the rows" , true )
        schema:register(XMLValueType.STRING, adjustedNodePath .. "#fruitTypes" , "List of supported fruit types separated by a whitespace" , "maize potato sunflower" )

        schema:register(XMLValueType.FLOAT, adjustedNodePath .. ".foldable#minLimit" , "Fold min.time" , 0 )
        schema:register(XMLValueType.FLOAT, adjustedNodePath .. ".foldable#maxLimit" , "Fold max.time" , 1 )

        schema:setXMLSpecializationType()
    end

```

### loadCropRowAdjustedNodeFromXML

**Description**

**Definition**

> loadCropRowAdjustedNodeFromXML()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | adjustedNode |

**Code**

```lua
function CropRowAdjustedNodes:loadCropRowAdjustedNodeFromXML(xmlFile, key, adjustedNode)
    adjustedNode.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if adjustedNode.node ~ = nil then
        adjustedNode.referenceFrame = createTransformGroup( "cropRowAdjustedNodeRefFrame" )
        link(getParent(adjustedNode.node), adjustedNode.referenceFrame)
        setTranslation(adjustedNode.referenceFrame, getTranslation(adjustedNode.node))
        setRotation(adjustedNode.referenceFrame, getRotation(adjustedNode.node))

        adjustedNode.startTrans = { getTranslation(adjustedNode.node) }
        adjustedNode.curTrans = { getTranslation(adjustedNode.node) }

        adjustedNode.transAxis = xmlFile:getValue(key .. "#transAxis" , 1 )
        adjustedNode.minTrans = xmlFile:getValue(key .. "#minTrans" , - 0.25 )
        adjustedNode.maxTrans = xmlFile:getValue(key .. "#maxTrans" , 0.25 )

        adjustedNode.moveSpeed = xmlFile:getValue(key .. "#moveSpeed" , 0.25 ) / 1000

        adjustedNode.betweenRows = xmlFile:getValue(key .. "#betweenRows" , true )

        adjustedNode.fruitTypes = { }
        local fruitTypesStr = xmlFile:getValue(key .. "#fruitTypes" , "maize potato sunflower" )
        if fruitTypesStr ~ = nil then
            local fruitTypes = fruitTypesStr:split( " " )
            for _, fruitTypeName in pairs(fruitTypes) do
                local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
                if fruitType ~ = nil then
                    adjustedNode.fruitTypes[fruitType.index] = true
                end
            end
        end

        if next(adjustedNode.fruitTypes) ~ = nil then
            adjustedNode.foldMinLimit = xmlFile:getValue(key .. ".foldable#minLimit" , 0 )
            adjustedNode.foldMaxLimit = xmlFile:getValue(key .. ".foldable#maxLimit" , 1 )

            return true
        else
                Logging.xmlWarning(xmlFile, "Missing fruit types in '%s'" , key)
            end
        else
                Logging.xmlWarning(xmlFile, "Missing node in '%s'" , key)
            end

            return false
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
function CropRowAdjustedNodes:onLoad(savegame)
    local spec = self.spec_cropRowAdjustedNodes

    spec.adjustedNodes = { }
    self.xmlFile:iterate( "vehicle.cropRowAdjustedNodes.adjustedNode" , function (index, key)
        local adjustedNode = { }
        if self:loadCropRowAdjustedNodeFromXML( self.xmlFile, key, adjustedNode) then
            table.insert(spec.adjustedNodes, adjustedNode)
        end
    end )

    if #spec.adjustedNodes = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , CropRowAdjustedNodes )
    else
            spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.cropRowAdjustedNodes#maxUpdateDistance" , 100 )
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
function CropRowAdjustedNodes:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cropRowAdjustedNodes
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        for _, adjustedNode in pairs(spec.adjustedNodes) do
            self:updateCropRowAdjustedNode(adjustedNode, dt)
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
function CropRowAdjustedNodes.prerequisitesPresent(specializations)
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
function CropRowAdjustedNodes.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , CropRowAdjustedNodes )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , CropRowAdjustedNodes )
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
function CropRowAdjustedNodes.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadCropRowAdjustedNodeFromXML" , CropRowAdjustedNodes.loadCropRowAdjustedNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "updateCropRowAdjustedNode" , CropRowAdjustedNodes.updateCropRowAdjustedNode)
    SpecializationUtil.registerFunction(vehicleType, "getIsCropRowAdjustedNodeActive" , CropRowAdjustedNodes.getIsCropRowAdjustedNodeActive)
end

```

### updateCropRowAdjustedNode

**Description**

**Definition**

> updateCropRowAdjustedNode()

**Arguments**

| any | adjustedNode |
|-----|--------------|
| any | dt           |

**Code**

```lua
function CropRowAdjustedNodes:updateCropRowAdjustedNode(adjustedNode, dt)
    local wasActive = adjustedNode.isActive
    adjustedNode.isActive = self:getIsCropRowAdjustedNodeActive(adjustedNode)

    if adjustedNode.isActive then
        local wx, _, wz = getWorldTranslation(adjustedNode.referenceFrame)
        local fruitTypeIndex, _ = FSDensityMapUtil.getFruitTypeIndexAtWorldPos(wx, wz)
        if adjustedNode.fruitTypes[fruitTypeIndex] = = nil then
            adjustedNode.isActive = false
            return
        end

        local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
        local spacing = fruitTypeDesc.plantSpacing
        local snapAngle = math.pi * 0.5 -- currently only 90° angles are supported

        local rasteredX1, rasteredZ1 = rasterize(wx, wz, spacing, g_currentMission.terrainSize, adjustedNode.betweenRows)

        local wx2, _, wz2 = localToWorld(adjustedNode.referenceFrame, 0 , 0 , 10 )
        local rasteredX2, rasteredZ2 = rasterize(wx2, wz2, spacing, g_currentMission.terrainSize, adjustedNode.betweenRows)

        local normlineDirX, normlineDirZ = MathUtil.vector2Normalize(rasteredX2 - rasteredX1, rasteredZ2 - rasteredZ1)

        -- snap to closest foliage angle
        local yRot = MathUtil.getYRotationFromDirection(normlineDirX, normlineDirZ)
        yRot = MathUtil.round(yRot / snapAngle) * snapAngle
        normlineDirX, normlineDirZ = MathUtil.getDirectionFromYRotation(yRot)

        local lineX, lineZ = rasteredX1 - normlineDirX, rasteredZ1 - normlineDirZ
        local signedDistance = MathUtil.getSignedDistanceToLineSegment2D(wx, wz, lineX, lineZ, normlineDirX, normlineDirZ, spacing + 1 )

        --#debug local dx, _, dz = localToWorld(adjustedNode.referenceFrame, 0, 0, -5)
        --#debug local origX, origZ = rasterize(dx, dz, spacing, g_currentMission.terrainSize, false)
        --#debug for rowIndex = -10, 10, 1 do
            --#debug local x, z = origX + normlineDirZ * rowIndex * spacing, origZ - normlineDirX * rowIndex * spacing
            --#debug local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z) + 0.8
            --#debug drawDebugLine(x, y, z, 0, 1, 0, x + normlineDirX * 10, y, z + normlineDirZ * 10, 0, 1, 0, true)
            --#debug end
            --#debug
            --#debug local origBetweenX, origBetweenZ = rasterize(dx, dz, spacing, g_currentMission.terrainSize, true)
            --#debug for rowIndex = -10, 10, 1 do
                --#debug local x, z = origBetweenX + normlineDirZ * rowIndex * spacing, origBetweenZ - normlineDirX * rowIndex * spacing
                --#debug local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z) + 0.4
                --#debug drawDebugLine(x, y, z, 1, 0, 0, x + normlineDirX * 10, y, z + normlineDirZ * 10, 1, 0, 0, true)
                --#debug end

                local transX = math.clamp( - signedDistance, adjustedNode.startTrans[adjustedNode.transAxis] + adjustedNode.minTrans, adjustedNode.startTrans[adjustedNode.transAxis] + adjustedNode.maxTrans)
                adjustedNode.targetTrans = transX

                local difference = adjustedNode.targetTrans - adjustedNode.curTrans[adjustedNode.transAxis]
                if math.abs(difference) > 0.001 then
                    adjustedNode.isDirty = true
                end
            elseif wasActive then
                    adjustedNode.targetTrans = adjustedNode.startTrans[adjustedNode.transAxis]
                    adjustedNode.isDirty = true
                end

                if adjustedNode.isDirty then
                    adjustedNode.curTrans[ 1 ], adjustedNode.curTrans[ 2 ], adjustedNode.curTrans[ 3 ] = getTranslation(adjustedNode.node)
                    local difference = adjustedNode.targetTrans - adjustedNode.curTrans[adjustedNode.transAxis]
                    if math.abs(difference) > 0.001 then
                        local direction = math.sign(difference)
                        local limit = direction > 0 and math.min or math.max
                        adjustedNode.curTrans[adjustedNode.transAxis] = limit(adjustedNode.curTrans[adjustedNode.transAxis] + direction * adjustedNode.moveSpeed * dt, adjustedNode.targetTrans)
                        setTranslation(adjustedNode.node, adjustedNode.curTrans[ 1 ], adjustedNode.curTrans[ 2 ], adjustedNode.curTrans[ 3 ])

                        if self.setMovingToolDirty ~ = nil then
                            self:setMovingToolDirty(adjustedNode.node)
                        end
                    else
                            adjustedNode.isDirty = false
                        end
                    end
                end

```