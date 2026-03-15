## FillVolume

**Description**

> Specialization for visual fill volumes/planes; requires FillUnit specialization

**Functions**

- [getFillVolumeIndicesByFillUnitIndex](#getfillvolumeindicesbyfillunitindex)
- [getFillVolumeLoadInfo](#getfillvolumeloadinfo)
- [getFillVolumeUnloadInfo](#getfillvolumeunloadinfo)
- [getFillVolumeUVScrollSpeed](#getfillvolumeuvscrollspeed)
- [initSpecialization](#initspecialization)
- [loadExtraDependentParts](#loadextradependentparts)
- [loadFillVolume](#loadfillvolume)
- [loadFillVolumeHeightNode](#loadfillvolumeheightnode)
- [loadFillVolumeInfo](#loadfillvolumeinfo)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdate](#onupdate)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerInfoNodeXMLPaths](#registerinfonodexmlpaths)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setFillVolumeForcedFillType](#setfillvolumeforcedfilltype)
- [setFillVolumeForcedFillTypeByFillUnitIndex](#setfillvolumeforcedfilltypebyfillunitindex)
- [setMovingToolDirty](#setmovingtooldirty)
- [updateDebugValues](#updatedebugvalues)
- [updateExtraDependentParts](#updateextradependentparts)

### getFillVolumeIndicesByFillUnitIndex

**Description**

**Definition**

> getFillVolumeIndicesByFillUnitIndex()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillVolume:getFillVolumeIndicesByFillUnitIndex(fillUnitIndex)
    local spec = self.spec_fillVolume
    local indices = { }
    for i, fillVolume in ipairs(spec.volumes) do
        if fillVolume.fillUnitIndex = = fillUnitIndex then
            table.insert(indices, i)
        end
    end

    return indices
end

```

### getFillVolumeLoadInfo

**Description**

**Definition**

> getFillVolumeLoadInfo()

**Arguments**

| any | loadInfoIndex |
|-----|---------------|

**Code**

```lua
function FillVolume:getFillVolumeLoadInfo(loadInfoIndex)
    local spec = self.spec_fillVolume
    return spec.loadInfos[loadInfoIndex]
end

```

### getFillVolumeUnloadInfo

**Description**

**Definition**

> getFillVolumeUnloadInfo()

**Arguments**

| any | unloadInfoIndex |
|-----|-----------------|

**Code**

```lua
function FillVolume:getFillVolumeUnloadInfo(unloadInfoIndex)
    local spec = self.spec_fillVolume
    return spec.unloadInfos[unloadInfoIndex]
end

```

### getFillVolumeUVScrollSpeed

**Description**

**Definition**

> getFillVolumeUVScrollSpeed()

**Code**

```lua
function FillVolume:getFillVolumeUVScrollSpeed()
    return 0 , 0 , 0
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function FillVolume.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "fillVolume" , g_i18n:getText( "configuration_fillVolume" ), "fillVolume" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FillVolume" )

    local basePath = "vehicle.fillVolume.fillVolumeConfigurations.fillVolumeConfiguration(?)"

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".volumes.volume(?)#node" , "Fill volume node" )
    schema:register(XMLValueType.INT, basePath .. ".volumes.volume(?)#fillUnitIndex" , "Fill unit index" )
    schema:register(XMLValueType.FLOAT, basePath .. ".volumes.volume(?)#fillUnitFactor" , "Fill unit factor" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. ".volumes.volume(?)#useFullCapacity" , "Defines if the fill volume represents the full fill unit capacity when multiple fill volumes are given.If set to 'false' (default), the fill level is split across the defined volumes.If set to 'true' all fill up the same." , true )
        schema:register(XMLValueType.BOOL, basePath .. ".volumes.volume(?)#allSidePlanes" , "All side planes" , true )
        schema:register(XMLValueType.BOOL, basePath .. ".volumes.volume(?)#retessellateTop" , "Retessellate top plane for better triangulation quality" , false )

            schema:register(XMLValueType.STRING, basePath .. ".volumes.volume(?)#defaultFillType" , "Default fill type name" )
            schema:register(XMLValueType.STRING, basePath .. ".volumes.volume(?)#forcedVolumeFillType" , "Forced fill type name" )

            schema:register(XMLValueType.FLOAT, basePath .. ".volumes.volume(?)#maxDelta" , "Max.heap size above above input surface [m]" , 1.0 )
            schema:register(XMLValueType.ANGLE, basePath .. ".volumes.volume(?)#maxAllowedHeapAngle" , "Max.allowed heap surface slope angle [deg]" , 35 )
            schema:register(XMLValueType.FLOAT, basePath .. ".volumes.volume(?)#maxSurfaceDistanceError" , "Max.allowed distance from input mesh surface to created fill plane mesh [m]" , 0.05 )
            schema:register(XMLValueType.FLOAT, basePath .. ".volumes.volume(?)#maxSubDivEdgeLength" , "Max.length of sub division edges [m]" , 0.9 )
            schema:register(XMLValueType.FLOAT, basePath .. ".volumes.volume(?)#syncMaxSubDivEdgeLength" , "Max.length of sub division edges used to sync in multiplayer [m]" , 1.35 )

            schema:register(XMLValueType.NODE_INDEX, basePath .. ".volumes.volume(?).deformNode(?)#node" , "Deformer node" )

            FillVolume.registerInfoNodeXMLPaths(schema, "vehicle.fillVolume.loadInfos.loadInfo(?)" )
            FillVolume.registerInfoNodeXMLPaths(schema, "vehicle.fillVolume.unloadInfos.unloadInfo(?)" )

            schema:register(XMLValueType.INT, "vehicle.fillVolume.heightNodes.heightNode(?)#fillVolumeIndex" , "Fill volume index" )
            schema:register(XMLValueType.NODE_INDEX, "vehicle.fillVolume.heightNodes.heightNode(?).refNode(?)#node" , "Reference node" )

            schema:register(XMLValueType.NODE_INDEX, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#node" , "Height node" )
            schema:register(XMLValueType.VECTOR_SCALE, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#baseScale" , "Base scale" , "1 1 1" )
            schema:register(XMLValueType.VECTOR_ 3 , "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#scaleAxis" , "Scale axis" , "0 0 0" )
            schema:register(XMLValueType.VECTOR_SCALE, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#scaleMax" , "Max.scale" , "0 0 0" )
            schema:register(XMLValueType.VECTOR_ 3 , "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#transAxis" , "Translation axis" , "0 0 0" )
            schema:register(XMLValueType.VECTOR_TRANS, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#transMax" , "Max.translation" , "0 0 0" )
            schema:register(XMLValueType.FLOAT, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#minHeight" , "Min.fill volume height used for height node" , 0 )
                schema:register(XMLValueType.FLOAT, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#heightOffset" , "Fill plane height offset" , 0 )
                schema:register(XMLValueType.BOOL, "vehicle.fillVolume.heightNodes.heightNode(?).node(?)#orientateToWorldY" , "Orientate to world Y" , false )

                schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
                    cSchema:register(XMLValueType.INT, cKey .. ".fillVolume#fillVolumeIndex" , "Fill Unit index which includes the deformers" , 1 )
                    cSchema:register(XMLValueType.VECTOR_N, cKey .. ".fillVolume#deformerNodeIndices" , "Indices of deformer nodes to update" )
                end )

                schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
                    cSchema:register(XMLValueType.INT, cKey .. ".fillVolume#fillVolumeIndex" , "Fill Unit index which includes the deformers" , 1 )
                    cSchema:register(XMLValueType.VECTOR_N, cKey .. ".fillVolume#deformerNodeIndices" , "Indices of deformer nodes to update" )
                end )

                schema:setXMLSpecializationType()
            end

```

### loadExtraDependentParts

**Description**

**Definition**

> loadExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | baseName  |
| any | entry     |

**Code**

```lua
function FillVolume:loadExtraDependentParts(superFunc, xmlFile, baseName, entry)
    if not superFunc( self , xmlFile, baseName, entry) then
        return false
    end

    local fillVolumeIndex = xmlFile:getValue(baseName .. ".fillVolume#fillVolumeIndex" , 1 )

    local indices = xmlFile:getValue(baseName .. ".fillVolume#deformerNodeIndices" , nil , true )
    if indices ~ = nil and #indices > 0 then
        entry.fillVolumeIndex = fillVolumeIndex
        entry.deformerNodes = { }

        for i = 1 , #indices do
            table.insert(entry.deformerNodes, indices[i])
        end
    end

    return true
end

```

### loadFillVolume

**Description**

**Definition**

> loadFillVolume()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function FillVolume:loadFillVolume(xmlFile, key, entry)
    local spec = self.spec_fillVolume
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) -- FS17

    entry.baseNode = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if entry.baseNode = = nil then
        printWarning( "Warning:fillVolume '" .. tostring(key) .. "' has an invalid 'node' in '" .. self.configFileName .. "'!" )
        return false
    end

    if not getHasClassId(entry.baseNode, ClassIds.SHAPE) then
        Logging.xmlWarning(xmlFile, "fillVolume '" .. getName(entry.baseNode) .. "' at '" .. tostring(key) .. "' is not a shape!" )
        return false
    end

    local fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" )
    entry.fillUnitIndex = fillUnitIndex
    if fillUnitIndex = = nil then
        printWarning( "Warning:fillVolume '" .. tostring(key) .. "' has no 'fillUnitIndex' given in '" .. self.configFileName .. "'!" )
        return false
    end
    if not self:getFillUnitExists(fillUnitIndex) then
        printWarning( "Warning:fillVolume '" .. tostring(key) .. "' has an invalid 'fillUnitIndex' in '" .. self.configFileName .. "'!" )
        return false
    end

    entry.fillUnitFactor = xmlFile:getValue(key .. "#fillUnitFactor" , 1.0 )
    entry.useFullCapacity = xmlFile:getValue(key .. "#useFullCapacity" , true )

    if spec.fillUnitFillVolumeMapping[fillUnitIndex] = = nil then
        spec.fillUnitFillVolumeMapping[fillUnitIndex] = { fillVolumes = { } , sumFactors = 0 }
    end
    table.insert(spec.fillUnitFillVolumeMapping[fillUnitIndex].fillVolumes, entry)
    spec.fillUnitFillVolumeMapping[fillUnitIndex].sumFactors = spec.fillUnitFillVolumeMapping[fillUnitIndex].sumFactors + entry.fillUnitFactor

    entry.allSidePlanes = xmlFile:getValue(key .. "#allSidePlanes" , true )
    entry.retessellateTop = xmlFile:getValue(key .. "#retessellateTop" , false )

    local defaultFillTypeStr = xmlFile:getValue(key .. "#defaultFillType" )
    if defaultFillTypeStr ~ = nil then
        local defaultFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(defaultFillTypeStr)
        if defaultFillTypeIndex = = nil then
            printWarning( "Warning:Invalid defaultFillType '" .. tostring(defaultFillTypeStr) .. "' for '" .. tostring(key) .. "' in '" .. self.configFileName .. "'" )
                return false
            else
                    entry.defaultFillType = defaultFillTypeIndex
                end
            else
                    entry.defaultFillType = self:getFillUnitFirstSupportedFillType(fillUnitIndex)
                end

                local forcedVolumeFillTypeStr = xmlFile:getValue(key .. "#forcedVolumeFillType" )
                if forcedVolumeFillTypeStr ~ = nil then
                    local forcedVolumeFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(forcedVolumeFillTypeStr)
                    if forcedVolumeFillTypeIndex ~ = nil then
                        entry.forcedVolumeFillType = forcedVolumeFillTypeIndex
                    else
                            printWarning( "Warning:Invalid forcedVolumeFillType '" .. tostring(forcedVolumeFillTypeStr) .. "' for '" .. tostring(key) .. "' in '" .. self.configFileName .. "'" )
                                return false
                            end
                        end

                        entry.maxDelta = xmlFile:getValue(key .. "#maxDelta" , 1.0 )
                        entry.maxSurfaceAngle = xmlFile:getValue(key .. "#maxAllowedHeapAngle" , 35 )

                        entry.maxPhysicalSurfaceAngle = math.rad( 35 )
                        entry.maxSurfaceDistanceError = xmlFile:getValue(key .. "#maxSurfaceDistanceError" , 0.05 )
                        entry.maxSubDivEdgeLength = xmlFile:getValue(key .. "#maxSubDivEdgeLength" , 0.9 )
                        entry.syncMaxSubDivEdgeLength = xmlFile:getValue(key .. "#syncMaxSubDivEdgeLength" , 1.35 )

                        entry.uvPosition = { 0 , 0 , 0 }

                        entry.deformers = { }
                        local j = 0
                        while true do
                            local deformerKey = string.format( "%s.deformNode(%d)" , key, j)
                            if not xmlFile:hasProperty(deformerKey) then
                                break
                            end

                            XMLUtil.checkDeprecatedXMLElements(xmlFile, deformerKey .. "#index" , deformerKey .. "#node" ) -- FS17

                            local node = xmlFile:getValue(deformerKey .. "#node" , nil , self.components, self.i3dMappings)
                            if node ~ = nil then
                                local initPos = { localToLocal(node, entry.baseNode, 0 , 0 , 0 ) }
                                local deformer = { node = node, initPos = initPos, posX = initPos[ 1 ], posZ = initPos[ 3 ], polyline = nil , volume = entry.volume, baseNode = entry.baseNode }
                                table.insert(entry.deformers, deformer)
                                spec.fillVolumeDeformersByNode[node] = deformer
                            end
                            j = j + 1
                        end

                        entry.lastFillType = FillType.UNKNOWN

                        return true
                    end

```

### loadFillVolumeHeightNode

**Description**

**Definition**

> loadFillVolumeHeightNode()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function FillVolume:loadFillVolumeHeightNode(xmlFile, key, entry)
    entry.isDirty = false

    entry.fillVolumeIndex = xmlFile:getValue(key .. "#fillVolumeIndex" , 1 )

    if self.spec_fillVolume.volumes[entry.fillVolumeIndex] = = nil then
        Logging.xmlWarning( self.xmlFile, "Invalid fillVolumeIndex '%d' for heightNode '%s'.Igoring heightNode!" , entry.fillVolumeIndex, key)
            return false
        end

        entry.refNodes = { }
        local i = 0
        while true do
            local nodeKey = key .. string.format( ".refNode(%d)" , i)
            if not xmlFile:hasProperty(nodeKey) then
                break
            end

            XMLUtil.checkDeprecatedXMLElements(xmlFile, nodeKey .. "#index" , nodeKey .. "#node" ) -- FS17 to FS19

            local node = xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
            if node ~ = nil then
                table.insert(entry.refNodes, { refNode = node } )
            else
                    Logging.xmlWarning( self.xmlFile, "Missing node for '%s'" , nodeKey)
                    end

                    i = i + 1
                end

                entry.nodes = { }
                i = 0
                while true do
                    local nodeKey = key .. string.format( ".node(%d)" , i)
                    if not xmlFile:hasProperty(nodeKey) then
                        break
                    end

                    XMLUtil.checkDeprecatedXMLElements(xmlFile, nodeKey .. "#index" , nodeKey .. "#node" ) -- FS17 to FS19

                    local node = xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
                    if node ~ = nil then
                        local nodeEntry = { }
                        nodeEntry.node = node
                        nodeEntry.baseScale = xmlFile:getValue(nodeKey .. "#baseScale" , "1 1 1" , true )
                        nodeEntry.scaleAxis = xmlFile:getValue(nodeKey .. "#scaleAxis" , "0 0 0" , true )
                        nodeEntry.scaleMax = xmlFile:getValue(nodeKey .. "#scaleMax" , "0 0 0" , true )
                        nodeEntry.basePosition = { getTranslation(node) }
                        nodeEntry.transAxis = xmlFile:getValue(nodeKey .. "#transAxis" , "0 0 0" , true )
                        nodeEntry.transMax = xmlFile:getValue(nodeKey .. "#transMax" , "0 0 0" , true )
                        nodeEntry.minHeight = xmlFile:getValue(nodeKey .. "#minHeight" , 0 )
                        nodeEntry.heightOffset = xmlFile:getValue(nodeKey .. "#heightOffset" , 0 )
                        nodeEntry.orientateToWorldY = xmlFile:getValue(nodeKey .. "#orientateToWorldY" , false )
                        table.insert(entry.nodes, nodeEntry)
                    else
                            Logging.xmlWarning( self.xmlFile, "Missing node for '%s'" , nodeKey)
                            end

                            i = i + 1
                        end

                        return true
                    end

```

### loadFillVolumeInfo

**Description**

**Definition**

> loadFillVolumeInfo()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function FillVolume:loadFillVolumeInfo(xmlFile, key, entry)
    entry.nodes = { }
    local i = 0
    while true do
        local infoKey = key .. string.format( ".node(%d)" , i)
        if not xmlFile:hasProperty(infoKey) then
            break
        end

        XMLUtil.checkDeprecatedXMLElements(xmlFile, infoKey .. "#index" , infoKey .. "#node" ) -- FS17 to FS19

        local node = xmlFile:getValue(infoKey .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            local nodeEntry = { }

            nodeEntry.node = node
            nodeEntry.width = xmlFile:getValue(infoKey .. "#width" , 1.0 )
            nodeEntry.length = xmlFile:getValue(infoKey .. "#length" , 1.0 )

            nodeEntry.fillVolumeHeightIndex = xmlFile:getValue(infoKey .. "#fillVolumeHeightIndex" )
            nodeEntry.priority = xmlFile:getValue(infoKey .. "#priority" , 1 )
            nodeEntry.minHeight = xmlFile:getValue(infoKey .. "#minHeight" )
            nodeEntry.maxHeight = xmlFile:getValue(infoKey .. "#maxHeight" )
            nodeEntry.minFillLevelPercentage = xmlFile:getValue(infoKey .. "#minFillLevelPercentage" )
            nodeEntry.maxFillLevelPercentage = xmlFile:getValue(infoKey .. "#maxFillLevelPercentage" )

            nodeEntry.heightForTranslation = xmlFile:getValue(infoKey .. "#heightForTranslation" )
            nodeEntry.translationStart = xmlFile:getValue(infoKey .. "#translationStart" , nil , true )
            nodeEntry.translationEnd = xmlFile:getValue(infoKey .. "#translationEnd" , nil , true )
            nodeEntry.translationAlpha = 0

            table.insert(entry.nodes, nodeEntry)
        else
                Logging.xmlWarning( self.xmlFile, "Missing node for '%s'" , infoKey)
                end

                i = i + 1
            end

            table.sort(entry.nodes, function (a, b) return a.priority > b.priority end )

            return true
        end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function FillVolume:onDelete()
    local spec = self.spec_fillVolume
    if spec.volumes ~ = nil then
        for _, fillVolume in ipairs(spec.volumes) do
            if fillVolume.volume ~ = nil then
                delete(fillVolume.volume)
            end
            fillVolume.volume = nil
        end
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
| any | _                |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function FillVolume:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, _, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_fillVolume

    local mapping = spec.fillUnitFillVolumeMapping[fillUnitIndex]
    if mapping = = nil then
        return
    end

    local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
    local fillType = self:getFillUnitFillType(fillUnitIndex)

    for _, fillVolume in ipairs(mapping.fillVolumes) do
        local baseNode = fillVolume.baseNode
        local volumeNode = fillVolume.volume
        if baseNode = = nil or volumeNode = = nil then
            return
        end

        local oldFillLevel = fillVolume.fillLevel
        fillVolume.fillLevel = math.clamp(fillLevel, 0 , fillVolume.capacity)
        local fillLevelDelta = fillVolume.fillLevel - oldFillLevel

        if fillVolume.forcedFillType ~ = nil then
            fillType = fillVolume.forcedFillType
        end
        if fillLevel = = 0 then
            fillVolume.forcedFillType = nil
        end

        if fillType ~ = fillVolume.lastFillType then
            local maxPhysicalSurfaceAngle
            local fillTypeInfo = g_fillTypeManager:getFillTypeByIndex(fillType)
            if fillTypeInfo ~ = nil then
                maxPhysicalSurfaceAngle = fillTypeInfo.maxPhysicalSurfaceAngle
            end
            if maxPhysicalSurfaceAngle ~ = nil then
                if fillVolume.volume ~ = nil then
                    setFillPlaneMaxPhysicalSurfaceAngle(fillVolume.volume, maxPhysicalSurfaceAngle)
                    fillVolume.maxPhysicalSurfaceAngle = maxPhysicalSurfaceAngle
                end
            end
        end

        setVisibility(fillVolume.volume, fillLevel > 0 )

        if fillType ~ = FillType.UNKNOWN and fillType ~ = fillVolume.lastFillType then
            local textureArrayIndex = g_fillTypeManager:getTextureArrayIndexByFillTypeIndex(fillType)
            if textureArrayIndex ~ = nil then
                setShaderParameter(fillVolume.volume, "fillTypeId" , textureArrayIndex - 1 , 0 , 0 , 0 , false )
            end
        end

        if fillPositionData ~ = nil then
            for i = #spec.availableFillNodes, 1 , - 1 do
                spec.availableFillNodes[i] = nil
            end

            if fillPositionData.nodes ~ = nil then
                local neededPriority = fillPositionData.nodes[ 1 ].priority

                while #spec.availableFillNodes = = 0 and neededPriority > = 1 do
                    for _,node in pairs(fillPositionData.nodes) do
                        if node.priority > = neededPriority then
                            local doInsert = true

                            if node.minHeight ~ = nil or node.maxHeight ~ = nil then
                                local height = - math.huge
                                if node.fillVolumeHeightIndex ~ = nil and spec.heightNodes[node.fillVolumeHeightIndex] ~ = nil then
                                    for _,refNode in pairs(spec.heightNodes[node.fillVolumeHeightIndex].refNodes) do
                                        local x,_,z = localToLocal(refNode.refNode, baseNode, 0 , 0 , 0 )
                                        height = math.max(height, getFillPlaneHeightAtLocalPos(volumeNode, x, z) - fillVolume.heightOffset)
                                    end
                                else
                                        local x,_,z = localToLocal(node.node, baseNode, 0 , 0 , 0 )
                                        height = math.max(height, getFillPlaneHeightAtLocalPos(volumeNode, x, z) - fillVolume.heightOffset)
                                    end

                                    if node.minHeight ~ = nil and height < node.minHeight then
                                        doInsert = false
                                    end
                                    if node.maxHeight ~ = nil and height > node.maxHeight then
                                        doInsert = false
                                    end

                                    if node.heightForTranslation ~ = nil then
                                        if height > node.heightForTranslation then
                                            node.translationAlpha = node.translationAlpha + 0.01
                                            local x,y,z = MathUtil.vector3ArrayLerp(node.translationStart, node.translationEnd, node.translationAlpha)
                                            setTranslation(node.node, x,y,z)
                                        else
                                                node.translationAlpha = node.translationAlpha - 0.01
                                            end
                                            node.translationAlpha = math.clamp(node.translationAlpha, 0 , 1 )
                                        end
                                    end

                                    if node.minFillLevelPercentage ~ = nil or node.maxFillLevelPercentage ~ = nil then
                                        local percentage = fillLevel / self:getFillUnitCapacity(fillUnitIndex)

                                        if node.minFillLevelPercentage ~ = nil and percentage < node.minFillLevelPercentage then
                                            doInsert = false
                                        end
                                        if node.maxFillLevelPercentage ~ = nil and percentage > node.maxFillLevelPercentage then
                                            doInsert = false
                                        end
                                    end

                                    if doInsert then
                                        table.insert(spec.availableFillNodes, node)
                                    end
                                end
                            end
                            if #spec.availableFillNodes > 0 then
                                break
                            end
                            neededPriority = neededPriority - 1
                        end
                    else
                            table.insert(spec.availableFillNodes, fillPositionData)
                        end

                        local numFillNodes = #spec.availableFillNodes
                        local avgX, avgZ = 0 , 0

                        for i = 1 ,numFillNodes do
                            local node = spec.availableFillNodes[i]

                            local x0,y0,z0 = getWorldTranslation(node.node)
                            local d1x,d1y,d1z = localDirectionToWorld(node.node, node.width, 0 , 0 )
                            local d2x,d2y,d2z = localDirectionToWorld(node.node, 0 , 0 ,node.length)

                            if VehicleDebug.state = = VehicleDebug.DEBUG then
                                drawDebugLine( x0,y0,z0, 1 , 0 , 0 , x0 + d1x, y0 + d1y, z0 + d1z, 1 , 0 , 0 )
                                drawDebugLine( x0,y0,z0, 0 , 0 , 1 , x0 + d2x, y0 + d2y, z0 + d2z, 0 , 0 , 1 )
                                drawDebugPoint( x0,y0,z0, 1 , 1 , 1 , 1 )
                                drawDebugPoint( x0 + d1x, y0 + d1y, z0 + d1z, 1 , 0 , 0 , 1 )
                                drawDebugPoint( x0 + d2x, y0 + d2y, z0 + d2z, 0 , 0 , 1 , 1 )
                            end
                            x0 = x0 - (d1x + d2x) / 2
                            y0 = y0 - (d1y + d2y) / 2
                            z0 = z0 - (d1z + d2z) / 2
                            fillPlaneAdd(fillVolume.volume, fillLevelDelta / numFillNodes, x0,y0,z0, d1x,d1y,d1z, d2x,d2y,d2z)

                            local newX, _, newZ = localToLocal(node.node, fillVolume.volume, 0 , 0 , 0 )
                            avgX, avgZ = avgX + newX, avgZ + newZ
                        end

                        local newX = avgX / numFillNodes
                        local newZ = avgZ / numFillNodes
                        if math.abs(newX - spec.lastPositionInfoSent[ 1 ]) > FillVolume.SEND_PRECISION or math.abs(newZ - spec.lastPositionInfoSent[ 2 ]) > FillVolume.SEND_PRECISION then
                            spec.lastPositionInfoSent[ 1 ] = newX
                            spec.lastPositionInfoSent[ 2 ] = newZ

                            self:raiseDirtyFlags(spec.dirtyFlag)
                        end
                    else
                            -- increase size of fill info if there should not be a heap since a small fill info will still produce a heap
                                local loadSize = 0.1
                                if fillVolume.maxPhysicalSurfaceAngle = = 0 or fillVolume.maxSurfaceAngle = = 0 then
                                    loadSize = 10
                                end

                                local x,y,z = localToWorld(fillVolume.volume, - loadSize * 0.5 , 0 , - loadSize * 0.5 )
                                local d1x,d1y,d1z = localDirectionToWorld(fillVolume.volume, loadSize, 0 , 0 )
                                local d2x,d2y,d2z = localDirectionToWorld(fillVolume.volume, 0 , 0 , loadSize)

                                if not self.isServer then
                                    if spec.lastPositionInfo[ 1 ] ~ = 0 and spec.lastPositionInfo[ 2 ] ~ = 0 then
                                        x, y, z = localToWorld(fillVolume.volume, spec.lastPositionInfo[ 1 ], 0 , spec.lastPositionInfo[ 2 ])
                                    end
                                end

                                local steps = math.clamp( math.floor(fillLevelDelta / 400 ), 1 , 25 )
                                for _ = 1 , steps do
                                    fillPlaneAdd(fillVolume.volume, fillLevelDelta / steps, x,y,z, d1x,d1y,d1z, d2x,d2y,d2z)
                                end
                            end

                            local heightNodes = spec.fillVolumeIndexToHeightNode[fillVolume.index]
                            if heightNodes ~ = nil then
                                for _, heightNode in ipairs(heightNodes) do
                                    heightNode.isDirty = true
                                end
                            end

                            for _,deformer in pairs(fillVolume.deformers) do
                                deformer.isDirty = true
                            end

                            fillVolume.lastFillType = fillType
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
function FillVolume:onLoad(savegame)
    local spec = self.spec_fillVolume

    local fillVolumeConfigurationId = Utils.getNoNil( self.configurations[ "fillVolume" ], 1 )
    local configKey = string.format( "vehicle.fillVolume.fillVolumeConfigurations.fillVolumeConfiguration(%d).volumes" , fillVolumeConfigurationId - 1 )

    spec.volumes = { }
    spec.fillVolumeDeformersByNode = { }
    spec.fillUnitFillVolumeMapping = { }

    self.xmlFile:iterate(configKey .. ".volume" , function (_, key)
        local entry = { }
        if self:loadFillVolume( self.xmlFile, key, entry) then
            table.insert(spec.volumes, entry)
            entry.index = #spec.volumes
        end
    end )

    -- create fill units
    for _, mapping in ipairs(spec.fillUnitFillVolumeMapping) do
        for _, fillVolume in ipairs(mapping.fillVolumes) do
            if not fillVolume.useFullCapacity then
                fillVolume.fillUnitFactor = fillVolume.fillUnitFactor / mapping.sumFactors
            end
        end
    end

    for _, fillVolume in ipairs(spec.volumes) do
        local capacity = self:getFillUnitCapacity(fillVolume.fillUnitIndex)
        fillVolume.capacity = capacity * fillVolume.fillUnitFactor
        fillVolume.fillLevel = 0

        fillVolume.volume = createFillPlaneShape(fillVolume.baseNode, "fillPlane" , fillVolume.capacity, fillVolume.maxDelta, fillVolume.maxSurfaceAngle, fillVolume.maxPhysicalSurfaceAngle, fillVolume.maxSurfaceDistanceError, fillVolume.maxSubDivEdgeLength, fillVolume.syncMaxSubDivEdgeLength, fillVolume.allSidePlanes, fillVolume.retessellateTop)
        if fillVolume.volume = = nil or fillVolume.volume = = 0 then
            printWarning( "Warning:fillVolume '" .. tostring(getName(fillVolume.baseNode)) .. "' could not create actual fillVolume in '" .. self.configFileName .. "'! Simplifying the mesh could help" )
            fillVolume.volume = nil
        else

                setVisibility(fillVolume.volume, false )

                for i = #fillVolume.deformers, 1 , - 1 do
                    local deformer = fillVolume.deformers[i]
                    deformer.polyline = findPolyline(fillVolume.volume, deformer.posX, deformer.posZ)
                    if deformer.polyline = = nil and deformer.polyline ~ = - 1 then
                        printWarning( "Warning:Could not find 'polyline' for '" .. tostring(getName(deformer.node)) .. "' in '" .. self.configFileName .. "'" )
                            table.remove(fillVolume.deformers, i)
                        end
                    end

                    link(fillVolume.baseNode, fillVolume.volume)

                    local fillVolumeMaterial = g_materialManager:getBaseMaterialByName( "fillPlane" )
                    if fillVolumeMaterial ~ = nil then
                        setMaterial(fillVolume.volume, fillVolumeMaterial, 0 )
                        g_fillTypeManager:assignFillTypeTextureArraysFromTerrain(fillVolume.volume, g_terrainNode, true , true , true )
                    else
                            Logging.error( "Failed to assign material to fill volume.Base Material 'fillPlane' not found!" )
                        end

                        -- check offset between pivot and bottom plane of fill volume
                        fillPlaneAdd(fillVolume.volume, 1 , 0 , 1 , 0 , 11 , 0 , 0 , 0 , 0 , 11 )
                        fillVolume.heightOffset = getFillPlaneHeightAtLocalPos(fillVolume.volume, 0 , 0 )
                        fillPlaneAdd(fillVolume.volume, - 1 , 0 , 1 , 0 , 11 , 0 , 0 , 0 , 0 , 11 )
                    end
                end

                spec.loadInfos = { }
                self.xmlFile:iterate( "vehicle.fillVolume.loadInfos.loadInfo" , function (_, key)
                    local entry = { }
                    if self:loadFillVolumeInfo( self.xmlFile, key, entry) then
                        table.insert(spec.loadInfos, entry)
                    end
                end )

                spec.unloadInfos = { }
                self.xmlFile:iterate( "vehicle.fillVolume.unloadInfos.unloadInfo" , function (_, key)
                    local entry = { }
                    if self:loadFillVolumeInfo( self.xmlFile, key, entry) then
                        table.insert(spec.unloadInfos, entry)
                    end
                end )

                spec.heightNodes = { }
                spec.fillVolumeIndexToHeightNode = { }
                self.xmlFile:iterate( "vehicle.fillVolume.heightNodes.heightNode" , function (_, key)
                    local entry = { }
                    if self:loadFillVolumeHeightNode( self.xmlFile, key, entry) then
                        table.insert(spec.heightNodes, entry)

                        if spec.fillVolumeIndexToHeightNode[entry.fillVolumeIndex] = = nil then
                            spec.fillVolumeIndexToHeightNode[entry.fillVolumeIndex] = { }
                        end
                        table.insert(spec.fillVolumeIndexToHeightNode[entry.fillVolumeIndex], entry)
                    end
                end )

                spec.lastPositionInfo = { 0 , 0 }
                spec.lastPositionInfoSent = { 0 , 0 }
                spec.availableFillNodes = { }
                spec.dirtyFlag = self:getNextDirtyFlag()

                if not self.isClient or(#spec.volumes = = 0 and #spec.heightNodes = = 0 ) then
                    SpecializationUtil.removeEventListener( self , "onUpdate" , FillVolume )
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
function FillVolume:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_fillVolume

        if streamReadBool(streamId) then
            spec.lastPositionInfo[ 1 ] = FillVolume.readStreamCompressedPosition(streamId)
            spec.lastPositionInfo[ 2 ] = FillVolume.readStreamCompressedPosition(streamId)
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
function FillVolume:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_fillVolume

        -- deform(fill)volume
        for _, fillVolume in pairs(spec.volumes) do
            for _,deformer in ipairs(fillVolume.deformers) do
                if deformer.isDirty and deformer.polyline ~ = nil and deformer.polyline ~ = - 1 then
                    deformer.isDirty = false

                    local posX, posY, posZ = localToLocal(deformer.node, deformer.baseNode, 0 , 0 , 0 )
                    if math.abs(posX - deformer.posX) > 0.0001 or math.abs(posZ - deformer.posZ) > 0.0001 then
                        --#debug local x, y, z = localToWorld(deformer.baseNode, posX, posY, posZ)
                        --#debug drawDebugLine(x, y, z, 0, 1, 0, x, y + 4, z, 0, 1, 0, true)

                        deformer.lastPosX = posX
                        deformer.lastPosZ = posZ
                        local dx = posX - deformer.initPos[ 1 ]
                        local dz = posZ - deformer.initPos[ 3 ]
                        setPolylineTranslation(fillVolume.volume, deformer.polyline, dx,dz)
                    end
                end
            end

            local uvScrollSpeedX, uvScrollSpeedY, uvScrollSpeedZ = self:getFillVolumeUVScrollSpeed(fillVolume.index)
            if uvScrollSpeedX ~ = 0 or uvScrollSpeedY ~ = 0 or uvScrollSpeedZ ~ = 0 then
                fillVolume.uvPosition[ 1 ] = fillVolume.uvPosition[ 1 ] + uvScrollSpeedX * (dt / 1000 )
                fillVolume.uvPosition[ 2 ] = fillVolume.uvPosition[ 2 ] + uvScrollSpeedY * (dt / 1000 )
                fillVolume.uvPosition[ 3 ] = fillVolume.uvPosition[ 3 ] + uvScrollSpeedZ * (dt / 1000 )
                setShaderParameter(fillVolume.volume, "uvOffset" , fillVolume.uvPosition[ 1 ], fillVolume.uvPosition[ 2 ], fillVolume.uvPosition[ 3 ], 0 , false )
            end
        end

        -- update heightNodes
        for _, heightNode in pairs(spec.heightNodes) do
            if heightNode.isDirty then
                heightNode.isDirty = false

                local fillVolume = spec.volumes[heightNode.fillVolumeIndex]

                local baseNode = fillVolume.baseNode
                local volumeNode = fillVolume.volume

                if baseNode ~ = nil and volumeNode ~ = nil then

                    local minHeight = math.huge
                    local maxHeight = - math.huge
                    local maxHeightWorld = - math.huge
                    for _, refNode in pairs(heightNode.refNodes) do
                        local x, _, z = localToLocal(refNode.refNode, baseNode, 0 , 0 , 0 )

                        local height = getFillPlaneHeightAtLocalPos(volumeNode, x, z)
                        if not MathUtil.isNan(height) then -- fill volume deformed by deformerNodes
                            height = height - fillVolume.heightOffset
                            minHeight = math.min(minHeight, height)
                            maxHeight = math.max(maxHeight, height)
                            local _, yw, _ = localToWorld(baseNode, x, height, z)
                            maxHeightWorld = math.max(maxHeightWorld, yw)

                            if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                                local wx1, wy1, wz1 = localToWorld(baseNode, x, fillVolume.heightOffset, z)
                                local wx2, wy2, wz2 = localToWorld(baseNode, x, height, z)
                                drawDebugLine(wx1, wy1, wz1, 0 , 1 , 0 , wx2, wy2, wz2, 0 , 1 , 0 , false )
                                Utils.renderTextAtWorldPosition(wx2, wy2, wz2, string.format( "Height: %.2fm" , height), 0.01 )
                            end
                        end
                    end

                    heightNode.currentMinHeight = minHeight
                    heightNode.currentMaxHeight = maxHeight
                    heightNode.currentMaxHeightWorld = maxHeightWorld

                    for _,node in pairs(heightNode.nodes) do
                        local nodeHeight = math.max(minHeight + node.heightOffset, node.minHeight)

                        local sx = node.scaleAxis[ 1 ] * nodeHeight
                        local sy = node.scaleAxis[ 2 ] * nodeHeight
                        local sz = node.scaleAxis[ 3 ] * nodeHeight
                        if node.scaleMax[ 1 ] > 0 then
                            sx = math.min(node.scaleMax[ 1 ], sx)
                        end
                        if node.scaleMax[ 2 ] > 0 then
                            sy = math.min(node.scaleMax[ 2 ], sy)
                        end
                        if node.scaleMax[ 3 ] > 0 then
                            sz = math.min(node.scaleMax[ 3 ], sz)
                        end
                        local tx = node.transAxis[ 1 ] * nodeHeight
                        local ty = node.transAxis[ 2 ] * nodeHeight
                        local tz = node.transAxis[ 3 ] * nodeHeight
                        if node.transMax[ 1 ] > 0 then
                            tx = math.min(node.transMax[ 1 ], tx)
                        end
                        if node.transMax[ 2 ] > 0 then
                            ty = math.min(node.transMax[ 2 ], ty)
                        end
                        if node.transMax[ 3 ] > 0 then
                            tz = math.min(node.transMax[ 3 ], tz)
                        end

                        setScale(node.node, node.baseScale[ 1 ] + sx, node.baseScale[ 2 ] + sy, node.baseScale[ 3 ] + sz)
                        setTranslation(node.node, node.basePosition[ 1 ] + tx, node.basePosition[ 2 ] + ty, node.basePosition[ 3 ] + tz)

                        if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                            if getEffectiveVisibility(node.node) then
                                renderShapeOutline(node.node, false )

                                if sy ~ = 0 then
                                    setScale(node.node, 1 , 1 , 1 )

                                    local wx1, wy1, wz1 = localToWorld(node.node, 0 , 0 , 0 )
                                    local wx2, wy2, wz2 = localToWorld(node.node, 0 , node.baseScale[ 2 ] + sy, 0 )
                                    drawDebugLine(wx1, wy1, wz1, 0 , 1 , 0 , wx2, wy2, wz2, 0 , 1 , 0 , false )
                                    Utils.renderTextAtWorldPosition(wx2, wy2, wz2, string.format( "%s scaleY: %.2f" , getName(node.node), node.baseScale[ 2 ] + sy), 0.01 )

                                    setScale(node.node, node.baseScale[ 1 ] + sx, node.baseScale[ 2 ] + sy, node.baseScale[ 3 ] + sz)
                                end

                                if ty ~ = 0 then
                                    local wx1, wy1, wz1 = localToWorld(getParent(node.node), node.basePosition[ 1 ] + tx, node.basePosition[ 2 ], node.basePosition[ 3 ] + tz)
                                    local wx2, wy2, wz2 = localToWorld(getParent(node.node), node.basePosition[ 1 ] + tx, node.basePosition[ 2 ] + ty, node.basePosition[ 3 ] + tz)
                                    drawDebugLine(wx1, wy1, wz1, 0 , 1 , 0 , wx2, wy2, wz2, 0 , 1 , 0 , false )
                                    Utils.renderTextAtWorldPosition(wx2, wy2, wz2, string.format( "%s transY: %.2f" , getName(node.node), node.basePosition[ 2 ] + ty), 0.01 )
                                end
                            end
                        end

                        if node.orientateToWorldY then
                            local _, dy, _ = localDirectionToWorld(getParent(node.node), 0 , 1 , 0 )
                            local alpha = math.acos( math.clamp(dy, - 1 , 1 ))
                            setRotation(node.node, alpha, 0 , 0 )
                        end
                    end
                end
            end
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
function FillVolume:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_fillVolume

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            FillVolume.writeStreamCompressedPosition(streamId, spec.lastPositionInfoSent[ 1 ])
            FillVolume.writeStreamCompressedPosition(streamId, spec.lastPositionInfoSent[ 2 ])
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
function FillVolume.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
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
function FillVolume.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FillVolume )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , FillVolume )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , FillVolume )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , FillVolume )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , FillVolume )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , FillVolume )
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
function FillVolume.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadFillVolume" , FillVolume.loadFillVolume)
    SpecializationUtil.registerFunction(vehicleType, "loadFillVolumeInfo" , FillVolume.loadFillVolumeInfo)
    SpecializationUtil.registerFunction(vehicleType, "loadFillVolumeHeightNode" , FillVolume.loadFillVolumeHeightNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillVolumeLoadInfo" , FillVolume.getFillVolumeLoadInfo)
    SpecializationUtil.registerFunction(vehicleType, "getFillVolumeUnloadInfo" , FillVolume.getFillVolumeUnloadInfo)
    SpecializationUtil.registerFunction(vehicleType, "getFillVolumeIndicesByFillUnitIndex" , FillVolume.getFillVolumeIndicesByFillUnitIndex)
    SpecializationUtil.registerFunction(vehicleType, "setFillVolumeForcedFillTypeByFillUnitIndex" , FillVolume.setFillVolumeForcedFillTypeByFillUnitIndex)
    SpecializationUtil.registerFunction(vehicleType, "setFillVolumeForcedFillType" , FillVolume.setFillVolumeForcedFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillVolumeUVScrollSpeed" , FillVolume.getFillVolumeUVScrollSpeed)
end

```

### registerInfoNodeXMLPaths

**Description**

**Definition**

> registerInfoNodeXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function FillVolume.registerInfoNodeXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".node(?)#node" , "Info node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#width" , "Info width" , 1.0 )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#length" , "Info length" , 1.0 )
    schema:register(XMLValueType.INT, basePath .. ".node(?)#fillVolumeHeightIndex" , "Fill volume height index" )
    schema:register(XMLValueType.INT, basePath .. ".node(?)#priority" , "Priority" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#minHeight" , "Min.height" )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#maxHeight" , "Max.height" )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#minFillLevelPercentage" , "Min.fill level percentage" )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#maxFillLevelPercentage" , "Min.fill level percentage" )
    schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#heightForTranslation" , "Min.height for translation" )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".node(?)#translationStart" , "Translation start" )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".node(?)#translationEnd" , "Translation end" )
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
function FillVolume.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setMovingToolDirty" , FillVolume.setMovingToolDirty)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadExtraDependentParts" , FillVolume.loadExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateExtraDependentParts" , FillVolume.updateExtraDependentParts)
end

```

### setFillVolumeForcedFillType

**Description**

**Definition**

> setFillVolumeForcedFillType()

**Arguments**

| any | fillVolumeIndex |
|-----|-----------------|
| any | forcedFillType  |

**Code**

```lua
function FillVolume:setFillVolumeForcedFillType(fillVolumeIndex, forcedFillType)
    local spec = self.spec_fillVolume
    if spec.volumes[fillVolumeIndex] ~ = nil then
        spec.volumes[fillVolumeIndex].forcedFillType = forcedFillType
    end
end

```

### setFillVolumeForcedFillTypeByFillUnitIndex

**Description**

**Definition**

> setFillVolumeForcedFillTypeByFillUnitIndex()

**Arguments**

| any | fillUnitIndex  |
|-----|----------------|
| any | forcedFillType |

**Code**

```lua
function FillVolume:setFillVolumeForcedFillTypeByFillUnitIndex(fillUnitIndex, forcedFillType)
    local spec = self.spec_fillVolume
    for i, fillVolume in ipairs(spec.volumes) do
        if fillVolume.fillUnitIndex = = fillUnitIndex then
            self:setFillVolumeForcedFillType(i, forcedFillType)
        end
    end
end

```

### setMovingToolDirty

**Description**

> Set moving tool dirty

**Definition**

> setMovingToolDirty(function superFunc, integer node, boolean forceUpdate, float dt)

**Arguments**

| function | superFunc   | superFunc                                                 |
|----------|-------------|-----------------------------------------------------------|
| integer  | node        | node id                                                   |
| boolean  | forceUpdate | force immediate update of moving tool and dependent parts |
| float    | dt          | time since last call (only if forceUpdate is set)         |

**Code**

```lua
function FillVolume:setMovingToolDirty(superFunc, node, forceUpdate, dt)
    superFunc( self , node, forceUpdate, dt)

    local spec = self.spec_fillVolume
    if spec.fillVolumeDeformersByNode ~ = nil then
        local deformer = spec.fillVolumeDeformersByNode[node]
        if deformer ~ = nil then
            deformer.isDirty = true
        end
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
function FillVolume:updateDebugValues(values)
    local spec = self.spec_fillVolume

    for fillUnitIndex, mapping in pairs(spec.fillUnitFillVolumeMapping) do
        for index, fillVolume in ipairs(mapping.fillVolumes) do
            table.insert(values, { name = "fillUnitIndex/fillVolume" , value = tostring(fillUnitIndex) .. " / " .. tostring(index) } )
            table.insert(values, { name = "lastFillType" , value = g_fillTypeManager:getFillTypeNameByIndex(fillVolume.lastFillType) } )
            table.insert(values, { name = "volume" , value = tostring(fillVolume.volume) } )
            if fillVolume.volume ~ = nil then
                table.insert(values, { name = "visibility" , value = tostring(getVisibility(fillVolume.volume)) } )

                local textureArrayIndex, _, _, _ = getShaderParameter(fillVolume.volume, "fillTypeId" )
                table.insert(values, { name = "textureArrayIndex" , value = tostring(textureArrayIndex) } )
            end
        end
    end

    table.insert(values, { name = "lastPositionInfo" , value = string.format( "%.2f %.2f" , spec.lastPositionInfo[ 1 ], spec.lastPositionInfo[ 2 ]) } )
    table.insert(values, { name = "lastPositionInfoSent" , value = string.format( "%.2f %.2f" , spec.lastPositionInfoSent[ 1 ], spec.lastPositionInfoSent[ 2 ]) } )
end

```

### updateExtraDependentParts

**Description**

**Definition**

> updateExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | part      |
| any | dt        |

**Code**

```lua
function FillVolume:updateExtraDependentParts(superFunc, part, dt)
    superFunc( self , part, dt)

    if part.deformerNodes ~ = nil then
        if part.fillVolumeIndex ~ = nil then
            part.fillVolume = self.spec_fillVolume.volumes[part.fillVolumeIndex]

            if part.fillVolume = = nil then
                Logging.xmlWarning( self.xmlFile, "Unable to find fillVolume with index '%d' for movingPart/movingTool '%s'" , part.fillVolumeIndex, getName(part.node))
                    part.deformerNodes = nil
                end
                part.fillVolumeIndex = nil
            end

            if part.fillVolume ~ = nil then
                for i, nodeIndex in pairs(part.deformerNodes) do
                    local deformerNode = part.fillVolume.deformers[nodeIndex]
                    if deformerNode = = nil then
                        part.deformerNodes[i] = nil
                    else
                            deformerNode.isDirty = true
                        end
                    end
                end
            end
        end

```