## PlaceableRiceField

**Description**

> Specialization for placeables

**Functions**

- [buildMesh](#buildmesh)
- [collectPickObjects](#collectpickobjects)
- [getDestructionMethod](#getdestructionmethod)
- [getHasValidFields](#gethasvalidfields)
- [initSpecialization](#initspecialization)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPumpI3DLoaded](#onpumpi3dloaded)
- [onReadStream](#onreadstream)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [performNodeDestruction](#performnodedestruction)
- [performTerrainDeformation](#performterraindeformation)
- [prerequisitesPresent](#prerequisitespresent)
- [previewNodeDestructionNodes](#previewnodedestructionnodes)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)

### buildMesh

**Description**

**Definition**

> buildMesh()

**Arguments**

| any | field |
|-----|-------|

**Code**

```lua
function PlaceableRiceField:buildMesh(field)
    local spec = self.spec_riceField

    local offsetPolygon = field.polygon:getOffsetPolygon( PlaceableRiceField.COL_MESH_SIZE_OFFSET)
    if offsetPolygon = = nil then
        return false
    end

    local waterplaneNode = createPlaneShapeFrom2DContour( "riceFieldVisualWaterPlane" , field.polygon:getVertices(), false )
    if waterplaneNode = = 0 then
        return false
    end

    local waterplaneMirrorsNode = clone(waterplaneNode, false , false , false )
    setName(waterplaneMirrorsNode, "riceFieldVisualWaterPlaneMirror" )

    -- dedicated water col as we cannot move it with the visual water to ensure it is always
    local waterplaneColNode = createPlaneShapeFrom2DContour( "riceFieldWaterCol" , field.polygon:getVertices(), true )
    if waterplaneColNode = = 0 then
        return false
    end

    local placementColPlaneNode = createPlaneShapeFrom2DContour( "riceFieldPlacementCol" , offsetPolygon:getVertices(), true )
    if placementColPlaneNode = = 0 then
        return false
    end

    removeFromPhysics(waterplaneColNode)
    removeFromPhysics(placementColPlaneNode)

    field.node = createTransformGroup( "riceField" )
    link( self.rootNode, field.node)
    field.mesh = waterplaneNode
    field.mirrorMesh = waterplaneMirrorsNode
    field.colMesh = waterplaneColNode
    field.placementColMesh = placementColPlaneNode
    link(field.node, waterplaneNode)
    link(field.node, waterplaneMirrorsNode)
    link(field.node, waterplaneColNode)
    link(field.node, placementColPlaneNode)

    -- placement col
    local x, _, z = getTranslation(placementColPlaneNode)
    setTranslation(placementColPlaneNode, x, field.height - 1 , z) -- col for masks can be below the terrain
        setCollisionFilter(placementColPlaneNode, CollisionFlag.PLACEMENT_BLOCKING, 1 )
        setIsNonRenderable(placementColPlaneNode, true )
        addToPhysics(placementColPlaneNode)

        -- water col
        x, _, z = getTranslation(waterplaneColNode)
        setTranslation(waterplaneColNode, x, field.height + spec.waterMaxLevel, z)
        setCollisionFilter(waterplaneColNode, CollisionFlag.WATER , 1 )
        setIsNonRenderable(waterplaneColNode, true )
        addToPhysics(waterplaneColNode)

        --#debug local rnx, rny, rnz = getWorldTranslation(field.node)
        --#debug Assert.areRoughlyEqual(rnx, 0)
        --#debug Assert.areRoughlyEqual(rny, 0)
        --#debug Assert.areRoughlyEqual(rnz, 0)

        -- water planes
        -- regular water plane
        setShapeReceiveShadowmap(waterplaneNode, true )
        setShapeCastShadowmap(waterplaneNode, false )

        local r,g,b,a = unpack(spec.underwaterFogColor or PlaceableRiceField.UNDERWATER_FOG_COLOR)
        local depthScale, refractionColorScale, getWaterDepthScale, inscatteringScale = unpack(spec.underwaterFogDepth or PlaceableRiceField.UNDERWATER_FOG_DEPTH)

        local waterSimMat = g_materialManager:getBaseMaterialByName( "riceFieldWaterSimulation" )
        if waterSimMat = = nil then
            Logging.error( "Unable to retrieve material 'riceFieldWaterSimulation' for rice field water plane" )
            else
                    setMaterial(waterplaneNode, waterSimMat, 0 )
                    setShaderParameter(waterplaneNode, "underwaterFogColor" , r,g,b,a, false )
                    setShaderParameter(waterplaneNode, "underwaterFogDepth" , depthScale, refractionColorScale, getWaterDepthScale, inscatteringScale, false )
                end

                -- simplified mirror water plane
                setShapeReceiveShadowmap(waterplaneMirrorsNode, true )
                setShapeCastShadowmap(waterplaneMirrorsNode, false )
                local waterMirrorMat = g_materialManager:getBaseMaterialByName( "riceFieldWaterInMirror" )
                if waterMirrorMat = = nil then
                    Logging.error( "Unable to retrieve material 'riceFieldWaterInMirror' for rice field water plane" )
                    else
                            setMaterial(waterplaneMirrorsNode, waterMirrorMat, 0 )
                            setShaderParameter(waterplaneNode, "underwaterFogColor" , r,g,b,a)
                            setShaderParameter(waterplaneNode, "underwaterFogDepth" , depthScale, refractionColorScale, getWaterDepthScale, inscatteringScale, false )
                            setObjectMask(waterplaneMirrorsNode, ObjectMask.SHAPE_VIS_MIRROR_ONLY)
                        end

                        field.polygonFoliage = field.polygon:getOffsetPolygon(spec.foliageOffsetFromRidge)
                        field.areaSqm = field.polygon:getArea()
                        field.capacity = field.areaSqm * 1000 * spec.waterMaxLevel

                        table.insert(spec.fields, field)
                        local fieldIndex = #spec.fields

                        self:setWaterHeight(fieldIndex, field.waterHeight, true )

                        if g_currentMission.shallowWaterSimulation ~ = nil then
                            g_currentMission.shallowWaterSimulation:addWaterPlane(field.mesh)
                            g_currentMission.shallowWaterSimulation:addAreaGeometry(field.mesh)
                        end

                        g_currentMission:addNodeObject(waterplaneColNode, self )
                        g_currentMission:addNodeObject(placementColPlaneNode, self )

                        -- add pump and trigger at center of first edge
                        field.pumpNode = clone(spec.pumpNode, false , false , false )
                        link(field.node, field.pumpNode)

                        field.fillingWater = I3DUtil.indexToObject(field.pumpNode, spec.fillingWaterPath)
                        field.fillingSplash = I3DUtil.indexToObject(field.pumpNode, spec.fillingSplashPath)
                        field.emptyingWater = I3DUtil.indexToObject(field.pumpNode, spec.emptyingWaterPath)
                        field.emptyingSplash = I3DUtil.indexToObject(field.pumpNode, spec.emptyingSplashPath)

                        if spec.samples ~ = nil then
                            if spec.samples.pumpSound ~ = nil then
                                field.pumpSound = g_soundManager:cloneSample(spec.samples.pumpSound, field.pumpNode)
                            end
                            if spec.samples.waterSound ~ = nil then
                                local waterSoundLinkNode = createTransformGroup( "riceFieldWaterSoundNode" )
                                link(field.pumpNode, waterSoundLinkNode)
                                field.waterSoundLinkNode = waterSoundLinkNode
                                field.waterSound = g_soundManager:cloneSample(spec.samples.waterSound, field.waterSoundLinkNode)
                            end
                        end

                        -- position pump
                        local x1, z1, x2, z2 = field.polygon:getEdge( 1 )
                        local cx, cz = (x1 + x2) / 2 , (z1 + z2) / 2
                        setWorldTranslation(field.pumpNode, cx, field.height, cz)

                        -- position emptying splash
                        local wx,wy,wz = getWorldTranslation(field.emptyingSplash)
                        local heightDiff = math.abs(getTerrainHeightAtWorldPos(g_terrainNode, wx, 0 , wz) - wy)
                        if heightDiff < 0.5 then
                            setWorldTranslation(field.emptyingSplash, wx, wy + 0.07 , wz)
                        else
                                -- hide splash if too far from terrain beneath
                                    delete(field.emptyingSplash)
                                    field.emptyingSplash = createTransformGroup( "riceFieldEmptyingSplashDummy" )
                                    link(field.pumpNode, field.emptyingSplash)
                                end

                                local orientation = field.polygon:getCurveOrientation()
                                local ry = - math.pi / 2 + MathUtil.getYRotationFromDirection(x2 - x1, z2 - z1) + (orientation = = - 1 and math.pi or 0 )
                                setRotation(field.pumpNode, 0 , ry, 0 )
                                addToPhysics(field.pumpNode)

                                self:setEffectVisibility(fieldIndex, false , false )

                                field.playerTriggerNode = clone(spec.playerTriggerNode, false , false , false )
                                link(field.node, field.playerTriggerNode)
                                setWorldTranslation(field.playerTriggerNode, cx, field.height, cz)
                                setRotation(field.playerTriggerNode, 0 , ry, 0 )
                                addToPhysics(field.playerTriggerNode)
                                addTrigger(field.playerTriggerNode, "playerTriggerCallback" , self )
                                spec.triggerToFieldIndex[field.playerTriggerNode] = fieldIndex

                                return true
                            end

```

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |
| any | target    |

**Code**

```lua
function PlaceableRiceField:collectPickObjects(superFunc, node, target)
    ---Default picking objects is disabled
end

```

### getDestructionMethod

**Description**

> Deletion is in pieces so not instantly

**Definition**

> getDestructionMethod()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableRiceField:getDestructionMethod(superFunc)
    return Placeable.DESTRUCTION.PER_NODE
end

```

### getHasValidFields

**Description**

**Definition**

> getHasValidFields()

**Code**

```lua
function PlaceableRiceField:getHasValidFields()
    local spec = self.spec_riceField
    for _, field in ipairs(spec.fields) do
        if field.polygon:getNumVertices() > = 3 then -- field.mesh ~ = nil
            return true
        end
    end

    return false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableRiceField.initSpecialization()
    if g_isDevelopmentVersion then
        addConsoleCommand( "gsRiceFieldWaterSetLevel" , "Set rice field water level percentage" , "consoleCommandSetWaterLevel" , PlaceableRiceField )
        addConsoleCommand( "gsRiceFieldWaterSetShaderParameters" , "Set rice field water plane shader parameters" , "consoleCommandsetWaterShaderParameters" , PlaceableRiceField , "r; g; b; a; depthScale; refractionColorScale; getWaterDepthScale; inscatteringScale" )
        addConsoleCommand( "gsRiceFieldSetRice" , "Set field rice state" , "consoleCommandSetRiceState" , PlaceableRiceField , "fruitTypeName; growthState; groundAngle" )
        addConsoleCommand( "gsRiceFieldCreateFromField" , "Create a rice field from a field using the same outline" , "consoleCommandCreateRiceFieldFromField" , PlaceableRiceField , "fieldIndex" )
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
function PlaceableRiceField:loadFromXMLFile(xmlFile, key)
    for fieldIndex, fieldKey in xmlFile:iterator(key .. ".fields.field" ) do

        local height = xmlFile:getValue(fieldKey .. "#worldHeight" )

        local field = self:createNewField(height)
        field.waterHeight = xmlFile:getValue(fieldKey .. "#waterHeight" ) or 0
        local waterHeightTarget = xmlFile:getValue(fieldKey .. "#waterHeightTarget" )

        local numVertexElements = xmlFile:getNumOfElements(fieldKey .. ".v" )
        field.polygon = Polygon2D.new(numVertexElements)

        for _, periodKey in xmlFile:iterator(fieldKey .. ".waterLevels" ) do
            local period = xmlFile:getValue(periodKey .. "#period" )
            field.periodWaterLevelPerSqm[period] = xmlFile:getValue(periodKey .. "#levelPerSqm" )
        end

        xmlFile:iterate(fieldKey .. ".v" , function (vertexIndex, vertexKey)

            local xz = xmlFile:getVector(vertexKey, nil , 2 )

            field.polygon:addPos(xz[ 1 ], xz[ 2 ])
        end )

        self:buildMesh(field)

        -- perform deformation and set initial fruit if new savegame is started with preplaced fields
            if self.isServer and not g_currentMission.missionInfo.isValid then
                Logging.devInfo( "perform initial deformation for rice field %q" , key)
                    local initialFruitName = xmlFile:getValue(fieldKey .. "#initialFruit" )
                    if initialFruitName ~ = nil then
                        local initialFruitType = g_fruitTypeManager:getFruitTypeByName(initialFruitName)
                        if initialFruitType ~ = nil then
                            field.initialFruitTypeIndex = initialFruitType.index
                            field.initialFruitGrowthState = xmlFile:getValue(fieldKey .. "#initialFruitGrowthState" ) or initialFruitType:getMinHarvestingGrowthState()
                            Logging.devInfo( "initial fruit %q at growth state %d" , initialFruitName, field.initialFruitGrowthState or - 1 )
                        end
                    end

                    field.deformationIsFree = true
                    self:performTerrainDeformation(field, callback)
                end

                if waterHeightTarget ~ = nil then
                    self:setWaterHeightTarget(fieldIndex, waterHeightTarget)
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
function PlaceableRiceField:onDelete()
    local spec = self.spec_riceField

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)

    g_messageCenter:unsubscribe(MessageType.FINISHED_GROWTH_PERIOD, self )
    g_messageCenter:unsubscribe( PlaceableRiceFieldFieldAnswerEvent , self )

    g_debugManager:removeGroup( "PlaceableRiceField" .. tostring( self ))

    if spec.fields ~ = nil then
        for _, field in ipairs(spec.fields) do
            self:deleteField(field)
        end

        spec.fields = { }
    end

    if spec.pumpNode ~ = nil then
        delete(spec.pumpNode)
        spec.pumpNode = nil
    end

    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples)
    end

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
        spec.sharedLoadRequestId = nil
    end

    --#debug g_debugManager:removeDrawable(self)
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
function PlaceableRiceField:onLoad(savegame)
    local spec = self.spec_riceField
    local xmlFile = self.xmlFile

    spec.fields = { }
    spec.triggerToFieldIndex = { }
    spec.fieldsToCheckForOverlap = { }
    spec.nodesToCheckForOverlap = { }

    spec.groundTypeInner = xmlFile:getValue( "placeable.riceField.area#groundType" )
    spec.groundInnerOffsetFromRidge = xmlFile:getValue( "placeable.riceField.area#offsetFromRidge" , - 0.5 )
    spec.groundTypeRidge = xmlFile:getValue( "placeable.riceField.ridge#groundType" )
    spec.ridgeHeight = xmlFile:getValue( "placeable.riceField.ridge#height" , 0.35 )
    spec.levelingWidth = xmlFile:getValue( "placeable.riceField.ridge#levelingWidth" , 0.45 )
    spec.ridgePaintWidth = xmlFile:getValue( "placeable.riceField.ridge#paintWidth" , 1 )
    local foliageTypeName = xmlFile:getValue( "placeable.riceField.ridge#foliageType" )
    if foliageTypeName ~ = nil then
        spec.ridgeFoliageType = g_fruitTypeManager:getFruitTypeByName(foliageTypeName)
        if spec.ridgeFoliageType ~ = nil then
            local foliageGrowthState
            local foliageGrowthStateName = xmlFile:getValue( "placeable.riceField.ridge#foliageGrowthStateName" )
            if foliageGrowthStateName ~ = nil then
                foliageGrowthState = spec.ridgeFoliageType:getGrowthStateByName(foliageGrowthStateName)
                if foliageGrowthState = = nil then
                    Logging.xmlWarning(xmlFile, "Foliage growthstate name '%s' does not exist for fruit type '%s'!" , foliageGrowthStateName, foliageTypeName)
                    end
                end

                if foliageGrowthState = = nil then
                    foliageGrowthState = xmlFile:getValue( "placeable.riceField.ridge#foliageGrowthStateName" , 2 )
                end

                spec.ridgeFoliageGrowthState = foliageGrowthState
                spec.ridgeFoliageWidth = xmlFile:getValue( "placeable.riceField.ridge#foliageWidth" , spec.ridgePaintWidth / 2 )
                spec.ridgeFoliageOffset = xmlFile:getValue( "placeable.riceField.ridge#foliageOffsetFromRidge" , 0.5 )
            else
                    Logging.xmlWarning(xmlFile, "Foliage type '%s' does not exist!" , foliageTypeName)
                end
            end

            spec.waterMaxLevel = xmlFile:getValue( "placeable.riceField.water#maxLevel" , spec.ridgeHeight * 0.8 )
            local waterFillDurationGameMinutes = xmlFile:getValue( "placeable.riceField.water#fillDurationGameMinutes" , 60 )
            spec.waterFillDurationMs = waterFillDurationGameMinutes * 60 * 1000
            spec.underwaterFogColor = xmlFile:getValue( "placeable.riceField.water#underwaterFogColor" )
            spec.underwaterFogDepth = xmlFile:getValue( "placeable.riceField.water#underwaterFogDepth" )

            spec.playerTriggerNode = xmlFile:getValue( "placeable.riceField.playerTrigger#node" , nil , self.components, self.i3dMappings)

            local pumpFilename = xmlFile:getValue( "placeable.riceField.pump#filename" )
            if pumpFilename ~ = nil then
                pumpFilename = Utils.getFilename(pumpFilename, self.baseDirectory)
                local args = {
                loadingTask = self:createLoadingTask(spec),
                xmlFile = xmlFile
                }

                spec.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(pumpFilename, false , false , self.onPumpI3DLoaded, self , args)
            end

            if self.isClient then
                spec.samples = { }
                spec.samples.pumpSound = g_soundManager:loadSampleFromXML(xmlFile, "placeable.riceField.pump.sounds" , "pump" , self.baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                spec.samples.waterSound = g_soundManager:loadSampleFromXML(xmlFile, "placeable.riceField.pump.sounds" , "water" , self.baseDirectory, self.components, 0 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
            end

            local fruitTypeNames = xmlFile:getValue( "placeable.riceField.foliage#fruitTypes" , "RICELONGGRAIN RICE" )
            spec.fruitTypes = g_fruitTypeManager:getFruitTypesByNames(fruitTypeNames)
            spec.foliageOffsetFromRidge = xmlFile:getValue( "placeable.riceField.foliage#offsetFromRidge" , - 1 )

            -- spec.moduleNode = I3DUtil.indexToObject(self.components, "1", self.i3dMappings)
            -- spec.moduleCornerNode = I3DUtil.indexToObject(self.components, "2", self.i3dMappings)

            if self.isServer then
                spec.waterPlanesDirtyFlag = self:getNextDirtyFlag()
                spec.fieldIndicesDirty = { }
                spec.fieldsPendingTargetWaterLevel = { }
            end

            spec.activatable = PlaceableRiceFieldActivatable.new( self )

            g_messageCenter:subscribe(MessageType.FINISHED_GROWTH_PERIOD, self.onFinishedGrowthPeriod, self )

            --#debug g_debugManager:addDrawable(self)
        end

```

### onPumpI3DLoaded

**Description**

**Definition**

> onPumpI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableRiceField:onPumpI3DLoaded(i3dNode, failedReason, args)
    local spec = self.spec_riceField

    local loadingTask = args.loadingTask
    local xmlFile = args.xmlFile

    if i3dNode = = 0 then
        self:finishLoadingTask(loadingTask)
        return false
    end

    spec.pumpNode = i3dNode -- template to clone per field

    -- store node paths to resolve after cloning template pumpNode(per field)
    spec.fillingWaterPath = xmlFile:getString( "placeable.riceField.pump.filling#water" )
    spec.fillingSplashPath = xmlFile:getString( "placeable.riceField.pump.filling#splash" )
    spec.fillingSplashYOffset = xmlFile:getValue( "placeable.riceField.pump.filling#yOffset" , 0.07 )
    spec.emptyingWaterPath = xmlFile:getString( "placeable.riceField.pump.emptying#water" )
    spec.emptyingSplashPath = xmlFile:getString( "placeable.riceField.pump.emptying#splash" )

    self:finishLoadingTask(loadingTask)

    return true
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
function PlaceableRiceField:onReadStream(streamId, connection)
    local numFields = streamReadUInt8(streamId)

    for i = 1 , numFields do
        local height = streamReadFloat32(streamId)
        local field = self:createNewField(height)

        local numVertices = streamReadUInt16(streamId)
        field.polygon = Polygon2D.new(numVertices)

        for i = 1 , numVertices do
            field.polygon:addPos(streamReadFloat32(streamId), streamReadFloat32(streamId))
        end

        field.waterHeight = streamReadFloat32(streamId)

        local isFilling = false
        local isEmptying = false
        if streamReadBool(streamId) then
            field.waterHeightTarget = streamReadFloat32(streamId)
            isFilling = field.waterHeightTarget > field.waterHeight
            isEmptying = field.waterHeightTarget < field.waterHeight
        end

        self:buildMesh(field)

        self:setEffectVisibility(i, isFilling, isEmptying)
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function PlaceableRiceField:onUpdateTick(dt)
    local spec = self.spec_riceField

    if g_currentMission.shallowWaterSimulation ~ = nil then
        for _, field in ipairs(spec.fields) do
            if field.isFilling and math.random() > 0.6 then
                -- add some waves to SWS when filling
                local x,_,z = getWorldTranslation(field.fillingSplash)

                g_currentMission.shallowWaterSimulation:paintCircle(x, nil ,z, 0.3 , MathUtil.randomFloat( - 1 , 1 ), MathUtil.randomFloat( - 1 , 1 ))
            end
        end
    end

    if not self.isServer then
        return
    end

    local changeFactor = g_currentMission:getEffectiveTimeScale() * dt / spec.waterFillDurationMs

    for fieldIndex in pairs(spec.fieldsPendingTargetWaterLevel) do
        local field = spec.fields[fieldIndex]
        if field = = nil then
            continue
        end

        local dir = spec.fieldsPendingTargetWaterLevel[fieldIndex]

        -- check if target height is reached
            local heightDiff = field.waterHeight - field.waterHeightTarget
            if heightDiff * dir > = 0 then
                -- remove field from pending list, remove water target attribute
                spec.fieldsPendingTargetWaterLevel[fieldIndex] = nil
                field.waterHeightTarget = nil

                -- stop effects
                self:setEffectVisibility(fieldIndex, false , false )

                -- enqueue one more update to sync reaching of target fillLevel to the clients
                spec.fieldIndicesDirty[fieldIndex] = true
                self:raiseDirtyFlags(spec.waterPlanesDirtyFlag)
                self:raiseActive()

                continue
            end

            local newHeight = field.waterHeight + dir * spec.waterMaxLevel * changeFactor
            if dir = = PlaceableRiceField.FILL_DIRECTION.RISE then
                newHeight = math.min(newHeight, field.waterHeightTarget)
            else
                    newHeight = math.max(newHeight, field.waterHeightTarget)
                end

                self:setWaterHeight(fieldIndex, newHeight) -- will raise active
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
function PlaceableRiceField:onWriteStream(streamId, connection)
    local spec = self.spec_riceField

    local numFields = #spec.fields

    streamWriteUInt8(streamId, numFields)

    for _, field in ipairs(spec.fields) do

        streamWriteFloat32(streamId, field.height)

        streamWriteUInt16(streamId, field.polygon:getNumVertices())

        for _, vertexComponent in ipairs(field.polygon:getVertices()) do
            streamWriteFloat32(streamId, vertexComponent)
        end

        streamWriteFloat32(streamId, field.waterHeight)

        if streamWriteBool(streamId, field.waterHeightTarget ~ = nil ) then
            streamWriteFloat32(streamId, field.waterHeightTarget)
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
function PlaceableRiceField:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_riceField

    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.btest(dirtyMask, spec.waterPlanesDirtyFlag)) then
            for fieldIndex, field in ipairs(spec.fields) do
                if streamWriteBool(streamId, spec.fieldIndicesDirty[fieldIndex] ~ = nil ) then -- only sync filllevel for fields which were set dirty
                    NetworkUtil.writeCompressedRange(streamId, field.waterHeight, 0 , spec.waterMaxLevel, PlaceableRiceField.WATER_LEVEL_NUM_BITS)
                    streamWriteBool(streamId, field.waterHeightTarget = = nil )
                end
            end
        end
    end
end

```

### performNodeDestruction

**Description**

**Definition**

> performNodeDestruction()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableRiceField:performNodeDestruction(superFunc, node)
    local didRemoveField = self:removeFieldByNode(node)
    local destroyPlaceable = not self:getHasValidFields()
    return didRemoveField, destroyPlaceable
end

```

### performTerrainDeformation

**Description**

**Definition**

> performTerrainDeformation()

**Arguments**

| any | field    |
|-----|----------|
| any | callback |

**Code**

```lua
function PlaceableRiceField:performTerrainDeformation(field, callback)
    local spec = self.spec_riceField

    -- prepare terrain deformation
    field.displacedVolume = 0

    -- flatten inside rice field
    field.areaDeformation = TerrainDeformation.new(g_terrainNode)

    -- create list of vertices including y coordinate
    local polygon3dVertices = field.polygon:getVerticesAs3DCoordinates(field.height + 0.02 )

    field.brushCallback = callback or( function () end )

    local terrainBrushId = g_groundTypeManager:getTerrainLayerByType(spec.groundTypeInner)
    field.areaDeformation:setOutsideAreaConstraints( PlaceableRiceField.MAX_HEIGHT_DIFF_TO_TERRAIN * 1.1 , math.rad( 45 ), math.rad( 50 ))
    field.areaDeformation:addPolygonalArea(polygon3dVertices, terrainBrushId, false ) -- placement col is blocked by water plane mesh already

    field.deformQueue = 1
    field.areaDeformationJobId = g_terrainDeformationQueue:queueJob(field.areaDeformation, false , "onTerrainDeformationTaskFinished" , self , field)

    -- deform ridges
    local deformWidthHalf = spec.levelingWidth / 2
    field.ridgeDeformation = TerrainDeformation.new(g_terrainNode)
    field.ridgeDeformation:enableDeformationMode()
    -- spec.ridgeDeformation:enableAreaBasedDeformationMode()
    field.ridgeDeformation:setOutsideAreaConstraints( PlaceableRiceField.MAX_HEIGHT_DIFF_TO_TERRAIN * 1.1 , math.rad( 45 ), math.rad( 50 ))
    for edgeIndex, v1x, v1z, v2x, v2z in field.polygon:iteratorEdges() do
        -- offset edges by half ridge width
        local dx, dz = MathUtil.vector2Normalize(v2x - v1x, v2z - v1z)
        local dxPerp, dzPerp = - dz, dx
        v1x = v1x - (dx * deformWidthHalf) + (dxPerp * deformWidthHalf)
        v1z = v1z - (dz * deformWidthHalf) + (dzPerp * deformWidthHalf)

        v2x = v2x + (dx * deformWidthHalf) + (dxPerp * deformWidthHalf)
        v2z = v2z + (dz * deformWidthHalf) + (dzPerp * deformWidthHalf)

        -- absolute to relative for deformation
            v2x, v2z = v2x - v1x, v2z - v1z
            local hx, hz = MathUtil.vector2SetLength(v2z , - v2x, spec.levelingWidth)

            -- DebugPlane.new():createWithPositionsOffset(v1x, field.height + spec.ridgeHeight, v1z, v2x, 0, v2z, hx, 0, hz):addToManager()
            field.ridgeDeformation:addArea(v1x, field.height + spec.ridgeHeight, v1z, v2x, 0 , v2z, hx, 0 , hz, terrainBrushId, false )
        end
        field.deformQueue = field.deformQueue + 1
        field.ridgeDeformationJobId = g_terrainDeformationQueue:queueJob(field.ridgeDeformation, false , "onTerrainDeformationTaskFinished" , self , field)

        -- paint ridges
        terrainBrushId = g_groundTypeManager:getTerrainLayerByType(spec.groundTypeRidge)

        if terrainBrushId ~ = nil then
            field.ridgeDeformationPaint = TerrainDeformation.new(g_terrainNode)
            field.ridgeDeformationPaint:enablePaintingMode()

            local ridgeWidthHalf = spec.ridgePaintWidth / 2
            for edgeIndex, v1x, v1z, v2x, v2z in field.polygon:iteratorEdges() do
                -- offset edges by half ridge width
                local dx, dz = MathUtil.vector2Normalize(v2x - v1x, v2z - v1z)
                local dxPerp, dzPerp = - dz, dx
                v1x = v1x - (dx * ridgeWidthHalf) + (dxPerp * ridgeWidthHalf)
                v1z = v1z - (dz * ridgeWidthHalf) + (dzPerp * ridgeWidthHalf)

                v2x = v2x + (dx * ridgeWidthHalf) + (dxPerp * ridgeWidthHalf)
                v2z = v2z + (dz * ridgeWidthHalf) + (dzPerp * ridgeWidthHalf)

                -- absolute to relative for deformation
                    v2x, v2z = v2x - v1x, v2z - v1z
                    local hx, hz = MathUtil.vector2SetLength(v2z , - v2x, spec.ridgePaintWidth)

                    field.ridgeDeformationPaint:addArea(v1x, field.height + spec.ridgeHeight, v1z, v2x, 0 , v2z, hx, 0 , hz, terrainBrushId, false )
                end

                field.deformQueue = field.deformQueue + 1
                field.ridgePaintJobId = g_terrainDeformationQueue:queueJob(field.ridgeDeformationPaint, false , "onTerrainDeformationTaskFinished" , self , field)
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
function PlaceableRiceField.prerequisitesPresent(specializations)
    return true
end

```

### previewNodeDestructionNodes

**Description**

**Definition**

> previewNodeDestructionNodes(function superFunc, entityId node)

**Arguments**

| function | superFunc |                                       |
|----------|-----------|---------------------------------------|
| entityId | node      | node to visualize provided by raycast |

**Return Values**

| entityId | nodesToVisualizeByBrush |
|----------|-------------------------|

**Code**

```lua
function PlaceableRiceField:previewNodeDestructionNodes(superFunc, node)
    local field = self:getFieldByNode(node)

    if field ~ = nil then
        renderShapeOutline(field.mesh, false )
        I3DUtil.iterateRecursively(field.pumpNode, function (iteratedNode)
            if getHasClassId(iteratedNode, ClassIds.SHAPE) and not getIsNonRenderable(iteratedNode) and getVisibility(iteratedNode) then
                renderShapeOutline(iteratedNode, false )
            end
        end )
    end

    return nil -- nothing to visualize by the brush
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
function PlaceableRiceField.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onReadUpdateStream" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onWriteUpdateStream" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onDirtyMaskCleared" , PlaceableRiceField )
    SpecializationUtil.registerEventListener(placeableType, "onUpdateTick" , PlaceableRiceField )

    SpecializationUtil.registerEventListener(placeableType, "onPeriodChanged" , PlaceableRiceField )
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
function PlaceableRiceField.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onPumpI3DLoaded" , PlaceableRiceField.onPumpI3DLoaded)
    SpecializationUtil.registerFunction(placeableType, "drawDebug" , PlaceableRiceField.drawDebug)
    SpecializationUtil.registerFunction(placeableType, "getCanCreateNewField" , PlaceableRiceField.getCanCreateNewField)
    SpecializationUtil.registerFunction(placeableType, "createNewField" , PlaceableRiceField.createNewField)
    SpecializationUtil.registerFunction(placeableType, "removeFieldByNode" , PlaceableRiceField.removeFieldByNode)
    SpecializationUtil.registerFunction(placeableType, "removeFieldByIndex" , PlaceableRiceField.removeFieldByIndex)
    SpecializationUtil.registerFunction(placeableType, "deleteField" , PlaceableRiceField.deleteField)
    SpecializationUtil.registerFunction(placeableType, "getFields" , PlaceableRiceField.getFields)
    SpecializationUtil.registerFunction(placeableType, "getFieldByIndex" , PlaceableRiceField.getFieldByIndex)
    SpecializationUtil.registerFunction(placeableType, "getFieldByNode" , PlaceableRiceField.getFieldByNode)
    SpecializationUtil.registerFunction(placeableType, "getCanAddVertex" , PlaceableRiceField.getCanAddVertex)
    SpecializationUtil.registerFunction(placeableType, "getCanFinish" , PlaceableRiceField.getCanFinish)
    SpecializationUtil.registerFunction(placeableType, "onPolyhedronOverlap" , PlaceableRiceField.onPolyhedronOverlap)
    SpecializationUtil.registerFunction(placeableType, "onFinishedGrowthPeriod" , PlaceableRiceField.onFinishedGrowthPeriod)
    SpecializationUtil.registerFunction(placeableType, "getHasValidFields" , PlaceableRiceField.getHasValidFields)
    SpecializationUtil.registerFunction(placeableType, "addVertex" , PlaceableRiceField.addVertex)
    SpecializationUtil.registerFunction(placeableType, "removeLastVertex" , PlaceableRiceField.removeLastVertex)
    SpecializationUtil.registerFunction(placeableType, "tryToFinishField" , PlaceableRiceField.tryToFinishField)
    SpecializationUtil.registerFunction(placeableType, "finalizeNewField" , PlaceableRiceField.finalizeNewField)
    SpecializationUtil.registerFunction(placeableType, "onRiceFieldAnswerEvent" , PlaceableRiceField.onRiceFieldAnswerEvent)
    SpecializationUtil.registerFunction(placeableType, "buildMesh" , PlaceableRiceField.buildMesh)
    SpecializationUtil.registerFunction(placeableType, "performTerrainDeformation" , PlaceableRiceField.performTerrainDeformation)
    SpecializationUtil.registerFunction(placeableType, "onTerrainDeformationFinished" , PlaceableRiceField.onTerrainDeformationFinished)
    SpecializationUtil.registerFunction(placeableType, "onTerrainDeformationFailed" , PlaceableRiceField.onTerrainDeformationFailed)
    SpecializationUtil.registerFunction(placeableType, "onTerrainDeformationTaskFinished" , PlaceableRiceField.onTerrainDeformationTaskFinished)
    SpecializationUtil.registerFunction(placeableType, "getFirstAndLastVertex" , PlaceableRiceField.getFirstAndLastVertex)
    SpecializationUtil.registerFunction(placeableType, "getNumVertices" , PlaceableRiceField.getNumVertices)
    SpecializationUtil.registerFunction(placeableType, "setWaterHeight" , PlaceableRiceField.setWaterHeight)
    SpecializationUtil.registerFunction(placeableType, "setEffectVisibility" , PlaceableRiceField.setEffectVisibility)
    SpecializationUtil.registerFunction(placeableType, "getWaterHeight" , PlaceableRiceField.getWaterHeight)
    SpecializationUtil.registerFunction(placeableType, "setWaterHeightTarget" , PlaceableRiceField.setWaterHeightTarget)
    SpecializationUtil.registerFunction(placeableType, "getWaterHeightTarget" , PlaceableRiceField.getWaterHeightTarget)
    SpecializationUtil.registerFunction(placeableType, "getWaterFillLevel" , PlaceableRiceField.getWaterFillLevel)
    SpecializationUtil.registerFunction(placeableType, "getWaterFillLevelPerSqm" , PlaceableRiceField.getWaterFillLevelPerSqm)
    SpecializationUtil.registerFunction(placeableType, "getFieldFillingState" , PlaceableRiceField.getFieldFillingState)
    SpecializationUtil.registerFunction(placeableType, "getMaxWaterHeight" , PlaceableRiceField.getMaxWaterHeight)
    SpecializationUtil.registerFunction(placeableType, "getArea" , PlaceableRiceField.getArea)
    SpecializationUtil.registerFunction(placeableType, "getSupportedFruitTypes" , PlaceableRiceField.getSupportedFruitTypes)
    SpecializationUtil.registerFunction(placeableType, "playerTriggerCallback" , PlaceableRiceField.playerTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "renderEdges" , PlaceableRiceField.renderEdges)
    SpecializationUtil.registerFunction(placeableType, "getRiceFieldState" , PlaceableRiceField.getRiceFieldState)
    SpecializationUtil.registerFunction(placeableType, "onRiceFieldStatusResult" , PlaceableRiceField.onRiceFieldStatusResult)
    SpecializationUtil.registerFunction(placeableType, "getConfirmDestruction" , PlaceableRiceField.getConfirmDestruction)
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
function PlaceableRiceField.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "addToPhysics" , PlaceableRiceField.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableRiceField.collectPickObjects)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getIsOnFarmland" , PlaceableRiceField.getIsOnFarmland)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getFarmlandId" , PlaceableRiceField.getFarmlandId)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getDestructionMethod" , PlaceableRiceField.getDestructionMethod)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "performNodeDestruction" , PlaceableRiceField.performNodeDestruction)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "previewNodeDestructionNodes" , PlaceableRiceField.previewNodeDestructionNodes)
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
function PlaceableRiceField.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "RiceField" )
    schema:register(XMLValueType.FLOAT, basePath .. ".fields.field(?)#worldHeight" , "world height/y level of the field" )
    schema:register(XMLValueType.FLOAT, basePath .. ".fields.field(?)#waterHeight" , "water height in meters" )
    schema:register(XMLValueType.FLOAT, basePath .. ".fields.field(?)#waterHeightTarget" , "water level target height in m relative to field ground" )
    schema:register(XMLValueType.STRING, basePath .. ".fields.field(?)#initialFruit" , "initial fruit for preplaced rice fields" )
        schema:register(XMLValueType.INT, basePath .. ".fields.field(?)#initialFruitGrowthState" , "initial fruit growth state index for preplaced rice fields" )
            schema:register(XMLValueType.STRING, basePath .. ".fields.field(?).v(?)" , "outline vertex x z position" )
            schema:register(XMLValueType.INT, basePath .. ".fields.field(?).waterLevels(?)#period" , "period index" )
            schema:register(XMLValueType.FLOAT, basePath .. ".fields.field(?).waterLevels(?)#levelPerSqm" , "water level for period" )
                schema:setXMLSpecializationType()
            end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function PlaceableRiceField.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "RiceField" )
    schema:register(XMLValueType.STRING, basePath .. ".riceField.area#groundType" , "" , "dirt" )
    schema:register(XMLValueType.FLOAT, basePath .. ".riceField.area#offsetFromRidge" , "distance in m the ground type inside the rice field if offset from the ridge center" , "-0.5" )

        schema:register(XMLValueType.STRING, basePath .. ".riceField.ridge#groundType" , "" , "grass" )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.ridge#height" , "height of the ridge around the rice field in m" , 0.35 )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.ridge#levelingWidth" , "width of the ridge terrain leveling in m" , 0.45 )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.ridge#paintWidth" , "width of the painted area on the ridge around the rice field in m" , 1 )
        schema:register(XMLValueType.STRING, basePath .. ".riceField.ridge#foliageType" , "foliage to place ontop of ridge" )
        schema:register(XMLValueType.INT, basePath .. ".riceField.ridge#foliageGrowthState" , "foliage growth state" , 2 )
        schema:register(XMLValueType.STRING, basePath .. ".riceField.ridge#foliageGrowthStateName" , "foliage growth state name" )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.ridge#foliageWidth" , "foliage width" , "paintWidth / 2" )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.ridge#foliageOffsetFromRidge" , "foliage offset" , "0.5" )

        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.water#maxLevel" , "maximum height of the water" , "80% or ridge height" )
        schema:register(XMLValueType.FLOAT, basePath .. ".riceField.water#fillDurationGameMinutes" , "duration for fully filling field in game minutes" )
            schema:register(XMLValueType.VECTOR_ 4 , basePath .. ".riceField.water#underwaterFogColor" , "shader paramters for underwaterFogColor" )
                schema:register(XMLValueType.VECTOR_ 4 , basePath .. ".riceField.water#underwaterFogDepth" , "shader paramters for underwaterFogDepth" )

                    schema:register(XMLValueType.FILENAME, basePath .. ".riceField.pump#filename" , "filepath to pump i3d file" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".riceField.pump.filling#water" , "node index path to filling water mesh" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".riceField.pump.filling#splash" , "node index path to filling water splash mesh" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".riceField.pump.filling#yOffset" , "y offset of the splash above the water plane" , 0.07 )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".riceField.pump.emptying#water" , "node index path to emptying water mesh" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".riceField.pump.emptying#splash" , "node index path to emptying water splash mesh" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".riceField.pump.sounds" , "pump" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".riceField.pump.sounds" , "water" )

                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".riceField.playerTrigger#node" , "node of the player trigger" )

                    schema:register(XMLValueType.STRING, basePath .. ".riceField.foliage#fruitTypes" , "" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".riceField.foliage#offsetFromRidge" , "" )
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
function PlaceableRiceField:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_riceField

    xmlFile:setTable(key .. ".fields.field" , spec.fields, function (path, field, _)
        xmlFile:setValue(path .. "#worldHeight" , field.height)
        xmlFile:setValue(path .. "#waterHeight" , field.waterHeight)
        if field.waterHeightTarget ~ = nil then
            xmlFile:setValue(path .. "#waterHeightTarget" , field.waterHeightTarget)
        end

        local periodIndex = 0
        for period, waterLevelPerSqm in pairs(field.periodWaterLevelPerSqm) do
            xmlFile:setValue( string.format( "%s.waterLevels(%d)#period" , path, periodIndex), period)
            xmlFile:setValue( string.format( "%s.waterLevels(%d)#levelPerSqm" , path, periodIndex), waterLevelPerSqm)
            periodIndex = periodIndex + 1
        end

        for vertexIndex, xPos, zPos in field.polygon:iteratorVertices() do
            xmlFile:setValue( string.format( "%s.v(%d)" , path, vertexIndex - 1 ), string.format( "%.3f %.3f" , xPos, zPos))
        end
    end )
end

```