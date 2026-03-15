## Leveler

**Description**

> Specialization for levelers for distributing silage/chaff in bunker silos

**Functions**

- [getIsAttacherJointControlDampingAllowed](#getisattacherjointcontroldampingallowed)
- [getIsLevelerPickupNodeActive](#getislevelerpickupnodeactive)
- [initSpecialization](#initspecialization)
- [loadLevelerNodeFromXML](#loadlevelernodefromxml)
- [onDelete](#ondelete)
- [onLevelerRaycastCallback](#onlevelerraycastcallback)
- [onLoad](#onload)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdate](#onupdate)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getIsAttacherJointControlDampingAllowed

**Description**

> Returns if damping is allowed

**Definition**

> getIsAttacherJointControlDampingAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | allowed | allowed |
|-----|---------|---------|

**Code**

```lua
function Leveler:getIsAttacherJointControlDampingAllowed(superFunc)
    if not superFunc( self ) then
        return false
    end

    for _, levelerNode in pairs( self.spec_leveler.nodes) do
        local x, y, z = getWorldTranslation(levelerNode.node)
        local _, height = DensityMapHeightUtil.getHeightAtWorldPos(x, y, z)
        if height = = 0 then
            return false
        end
    end

    return true
end

```

### getIsLevelerPickupNodeActive

**Description**

> Returns true if leveler pickup node is active

**Definition**

> getIsLevelerPickupNodeActive(table levelerNode)

**Arguments**

| table | levelerNode | pickup node data |
|-------|-------------|------------------|

**Return Values**

| table | isActive | pickup node is active |
|-------|----------|-----------------------|

**Code**

```lua
function Leveler:getIsLevelerPickupNodeActive(levelerNode)
    return self.getAttacherVehicle = = nil or self:getAttacherVehicle() ~ = nil
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Leveler.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Leveler" )

    local basePath = Leveler.LEVELER_NODE_XML_KEY

    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Leveler node" )

    schema:register(XMLValueType.FLOAT, basePath .. "#width" , "Width" )
    schema:register(XMLValueType.FLOAT, basePath .. "#zOffset" , "Z axis offset" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#yOffset" , "Y axis offset" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#minDropWidth" , "Min.drop width" , "half of width" )
    schema:register(XMLValueType.FLOAT, basePath .. "#maxDropWidth" , "Max.drop width" , "width value" )
    schema:register(XMLValueType.FLOAT, basePath .. "#minDropDirOffset" , "Min.drop direction offset" , 0.7 )
    schema:register(XMLValueType.FLOAT, basePath .. "#maxDropDirOffset" , "Max.drop direction offset" , 0.7 )
    schema:register(XMLValueType.INT, basePath .. "#numHeightLimitChecks" , "Number of height limit checks" , 6 )
    schema:register(XMLValueType.BOOL, basePath .. "#alignToWorldY" , "Defines if the leveler node is aligned to worlds Y axis" , true )

        schema:register(XMLValueType.BOOL, basePath .. ".smoothing#allowed" , "Leveler smoothes while driving backward" , true )
            schema:register(XMLValueType.FLOAT, basePath .. ".smoothing#radius" , "Smooth ground radius" , 0.5 )
            schema:register(XMLValueType.FLOAT, basePath .. ".smoothing#overlap" , "Radius overlap" , 1.7 )
            schema:register(XMLValueType.INT, basePath .. ".smoothing#direction" , "Smooth direction(if set to '0' it smooths in both directions)" , - 1 )

                schema:register(XMLValueType.INT, basePath .. "#fillUnitIndex" , "Fill unit index" , "Value of vehicle.leveler#fillUnitIndex" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".occlusionAreas.occlusionArea(?)#startNode" , "Start node" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".occlusionAreas.occlusionArea(?)#widthNode" , "Width node" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".occlusionAreas.occlusionArea(?)#heightNode" , "Height node" )

                schema:register(XMLValueType.INT, "vehicle.leveler.pickUpDirection" , "Pick up direction" , 1 )
                schema:register(XMLValueType.INT, "vehicle.leveler#fillUnitIndex" , "Fill unit index" )
                schema:register(XMLValueType.FLOAT, "vehicle.leveler#maxFillLevelPerMS" , "Max.fill level change rate as reference for effect and force" , 20 )

                    schema:register(XMLValueType.NODE_INDEX, "vehicle.leveler.force#node" , "Force node" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.leveler.force#directionNode" , "Force direction node" )
                    schema:register(XMLValueType.FLOAT, "vehicle.leveler.force#maxForce" , "Max.force in kN" , 0 )
                    schema:register(XMLValueType.INT, "vehicle.leveler.force#direction" , "Driving direction for applying force" , 1 )

                        schema:register(XMLValueType.BOOL, "vehicle.leveler#ignoreFarmlandState" , "If set to true the farmland underneath the leveler does not need to be bought to actually work" , false )

                        EffectManager.registerEffectXMLPaths(schema, "vehicle.leveler.effects" )

                        schema:setXMLSpecializationType()
                    end

```

### loadLevelerNodeFromXML

**Description**

> Loads leveler node from xml

**Definition**

> loadLevelerNodeFromXML(table levelerNode, XMLFile xmlFile, string key)

**Arguments**

| table   | levelerNode | leveler node data |
|---------|-------------|-------------------|
| XMLFile | xmlFile     | XMLFile instance  |
| string  | key         | key               |

**Return Values**

| string | success | success |
|--------|---------|---------|

**Code**

```lua
function Leveler:loadLevelerNodeFromXML(levelerNode, xmlFile, key)
    levelerNode.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if levelerNode.node ~ = nil then
        local referenceFrame = createTransformGroup( "referenceFrame" )
        link(getParent(levelerNode.node), referenceFrame)
        setTranslation(referenceFrame, getTranslation(levelerNode.node))
        setRotation(referenceFrame, getRotation(levelerNode.node))
        levelerNode.referenceFrame = referenceFrame

        levelerNode.zOffset = xmlFile:getValue(key .. "#zOffset" , 0 )
        levelerNode.yOffset = xmlFile:getValue(key .. "#yOffset" , 0 )
        levelerNode.width = xmlFile:getValue(key .. "#width" )
        levelerNode.halfWidth = levelerNode.width * 0.5

        levelerNode.minDropWidth = xmlFile:getValue(key .. "#minDropWidth" , levelerNode.width * 0.5 )
        levelerNode.halfMinDropWidth = levelerNode.minDropWidth * 0.5
        levelerNode.maxDropWidth = xmlFile:getValue(key .. "#maxDropWidth" , levelerNode.width)
        levelerNode.halfMaxDropWidth = levelerNode.maxDropWidth * 0.5

        levelerNode.minDropDirOffset = xmlFile:getValue(key .. "#minDropDirOffset" , 0.7 )
        levelerNode.maxDropDirOffset = xmlFile:getValue(key .. "#maxDropDirOffset" , 0.7 )
        levelerNode.numHeightLimitChecks = xmlFile:getValue(key .. "#numHeightLimitChecks" , 6 )
        levelerNode.alignToWorldY = xmlFile:getValue(key .. "#alignToWorldY" , true )

        levelerNode.occlusionAreas = { }

        local i = 0
        while true do
            local baseKey = string.format( "%s.occlusionAreas.occlusionArea(%d)" , key, i)
            if not xmlFile:hasProperty(baseKey) then
                break
            end

            local entry = { }
            entry.startNode = xmlFile:getValue(baseKey .. "#startNode" , nil , self.components, self.i3dMappings)
            entry.widthNode = xmlFile:getValue(baseKey .. "#widthNode" , nil , self.components, self.i3dMappings)
            entry.heightNode = xmlFile:getValue(baseKey .. "#heightNode" , nil , self.components, self.i3dMappings)

            if entry.startNode ~ = nil and entry.widthNode ~ = nil and entry.heightNode ~ = nil then
                table.insert(levelerNode.occlusionAreas, entry)
            else
                    Logging.xmlWarning(xmlFile, "Failed to load occlustion area '%s'.One or more nodes missing." , baseKey)
                end

                i = i + 1
            end

            levelerNode.allowsSmoothing = xmlFile:getValue(key .. ".smoothing#allowed" , true )
            levelerNode.smoothGroundRadius = xmlFile:getValue(key .. ".smoothing#radius" , 0.5 )
            levelerNode.smoothOverlap = xmlFile:getValue(key .. ".smoothing#overlap" , 1.7 )
            levelerNode.smoothDirection = xmlFile:getValue(key .. ".smoothing#direction" , - 1 )

            levelerNode.lineOffsetPickUp = nil
            levelerNode.lineOffsetDrop = nil

            levelerNode.lastPickUp = 0
            levelerNode.lastDrop = 0

            levelerNode.fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" , self.spec_leveler.fillUnitIndex)
            if not self:getFillUnitExists(levelerNode.fillUnitIndex) then
                Logging.xmlWarning( self.xmlFile, "Unknown fillUnitIndex '%s' for leveler" , tostring(levelerNode.fillUnitIndex))
                    return false
                end

                return true
            end

            return false
        end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Leveler:onDelete()
    local spec = self.spec_leveler

    g_effectManager:deleteEffects(spec.effects)
end

```

### onLevelerRaycastCallback

**Description**

> Callback used when raycast hits an object.

**Definition**

> onLevelerRaycastCallback(integer hitObjectId, float x, float y, float z, float distance, float nx, float ny, float nz,
> integer subShapeIndex, integer shapeId, boolean isLast, )

**Arguments**

| integer | hitObjectId   | scenegraph object id                      |
|---------|---------------|-------------------------------------------|
| float   | x             | world x hit position                      |
| float   | y             | world y hit position                      |
| float   | z             | world z hit position                      |
| float   | distance      | distance at which the cast hit the object |
| float   | nx            | normal x direction                        |
| float   | ny            | normal y direction                        |
| float   | nz            | normal z direction                        |
| integer | subShapeIndex | sub shape index                           |
| integer | shapeId       | id of shape                               |
| boolean | isLast        | is last hit                               |
| any     | isLast        |                                           |

**Return Values**

| any | return | false to stop raycast |
|-----|--------|-----------------------|

**Code**

```lua
function Leveler.onLevelerRaycastCallback(levelerNode, hitObjectId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast)
    local self = levelerNode.vehicle
    if self.isDeleted or self.isDeleting then
        return
    end

    local spec = self.spec_leveler

    if hitObjectId ~ = 0 then
        if hitObjectId ~ = g_terrainNode then
            levelerNode.raycastHitObject = true
            --#debug drawDebugLine(x, y, z, 1, 0, 0, x, y + 1, z, 1, 0, 0, true)
        end
    end

    if isLast then
        if not levelerNode.raycastHitObject then
            local fillLevel = self:getFillUnitFillLevel(levelerNode.fillUnitIndex)
            if fillLevel > 0 then
                local fillType = levelerNode.raycastLastFillType
                local outerRadius = levelerNode.raycastLastRadius

                local f = spec.lastFillLevelMovedPct
                local width = MathUtil.lerp(levelerNode.halfMinDropWidth, levelerNode.halfMaxDropWidth, f)
                local dropOffset = MathUtil.lerp(levelerNode.minDropDirOffset, levelerNode.maxDropDirOffset, f)

                local terrainHeightUpdater = g_densityMapHeightManager:getTerrainDetailHeightUpdater()
                if terrainHeightUpdater ~ = nil then
                    for i = 1 , #levelerNode.occlusionAreas do
                        local occlusionArea = levelerNode.occlusionAreas[i]

                        local ox1, oy1, oz1 = getWorldTranslation(occlusionArea.startNode)
                        local ox2, _, oz2 = getWorldTranslation(occlusionArea.widthNode)
                        local ox3, _, oz3 = getWorldTranslation(occlusionArea.heightNode)

                        local ox, oz, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(ox1, oz1, ox2, oz2, ox3, oz3)

                        addDensityMapHeightOcclusionArea(terrainHeightUpdater, ox, oy1, oz, widthX, oy1, widthZ, heightX, oy1, heightZ, true )

                        --#debug DebugUtil.drawDebugParallelogram(x, z, widthX, widthZ, heightX, heightZ, 0, 0.5, 0, 0, 0.1)
                    end
                end

                local sx,sy,sz = localToWorld(levelerNode.node, - width, levelerNode.yOffset, levelerNode.zOffset + dropOffset)
                local ex,ey,ez = localToWorld(levelerNode.node, width, levelerNode.yOffset, levelerNode.zOffset + dropOffset)
                levelerNode.lastDrop2, levelerNode.lineOffsetDrop2 = DensityMapHeightUtil.tipToGroundAroundLine( self , fillLevel, fillType, sx,sy,sz, ex,ey,ez, 0 , outerRadius, levelerNode.lineOffsetDrop2, false , nil )

                --#debug DebugUtil.drawDebugLine(sx,sy,sz, ex,ey,ez, 0, 1, 1, outerRadius)

                if levelerNode.lastDrop2 > 0 then
                    local leftOver = fillLevel - levelerNode.lastDrop2
                    if leftOver < = g_densityMapHeightManager:getMinValidLiterValue(fillType) then
                        levelerNode.lastDrop2 = fillLevel
                        spec.litersToPickup = spec.litersToPickup + leftOver
                    end
                    self:addFillUnitFillLevel( self:getOwnerFarmId(), levelerNode.fillUnitIndex, - levelerNode.lastDrop2, fillType, ToolType.UNDEFINED, nil )
                end
            end
        end
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
function Leveler:onLoad(savegame)
    local spec = self.spec_leveler

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.leveler.levelerNode#index" , "vehicle.leveler.levelerNode#node" ) -- FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.levelerEffects" , "vehicle.leveler.effects" ) -- FS17

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.leveler.levelerNode(0)#minDropHeight" ) -- FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.leveler.levelerNode(0)#maxDropHeight" ) -- FS22

    spec.pickUpDirection = self.xmlFile:getValue( "vehicle.leveler.pickUpDirection" , 1.0 )
    spec.maxFillLevelPerMS = self.xmlFile:getValue( "vehicle.leveler#maxFillLevelPerMS" , 35 )
    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.leveler#fillUnitIndex" )

    spec.nodes = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.leveler.levelerNode(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local levelerNode = { }
        if self:loadLevelerNodeFromXML(levelerNode, self.xmlFile, key) then
            levelerNode.vehicle = self
            levelerNode.onLevelerRaycastCallback = self.onLevelerRaycastCallback
            table.insert(spec.nodes, levelerNode)
        end
        i = i + 1
    end

    spec.litersToPickup = 0
    spec.smoothAccumulation = 0

    spec.lastFillLevelMoved = 0
    spec.lastFillLevelMovedPct = 0
    spec.lastFillLevelMovedTarget = 0
    spec.lastFillLevelMovedBuffer = 0
    spec.lastFillLevelMovedBufferTime = 300
    spec.lastFillLevelMovedBufferTimer = 0

    spec.forceNode = self.xmlFile:getValue( "vehicle.leveler.force#node" , nil , self.components, self.i3dMappings)
    spec.forceDirNode = self.xmlFile:getValue( "vehicle.leveler.force#directionNode" , spec.forceNode, self.components, self.i3dMappings)

    spec.maxForce = self.xmlFile:getValue( "vehicle.leveler.force#maxForce" , 0 ) -- kN
    spec.lastForce = 0
    spec.forceDir = self.xmlFile:getValue( "vehicle.leveler.force#direction" , 1 )

    spec.ignoreFarmlandState = self.xmlFile:getValue( "vehicle.leveler#ignoreFarmlandState" , false )

    if self.isClient then
        spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.leveler.effects" , self.components, self , self.i3dMappings)
    end

    if #spec.nodes = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , Leveler )
    end

    spec.dirtyFlag = self:getNextDirtyFlag()
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
function Leveler:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spec = self.spec_leveler
            spec.lastFillLevelMovedPct = streamReadUIntN(streamId, Leveler.LEVEL_NUM_BITS) / Leveler.LEVEL_MAX_VALUE
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
function Leveler:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_leveler

    if self.isClient then
        local fillType = FillType.UNKNOWN
        for _, levelerNode in pairs(spec.nodes) do
            fillType = self:getFillUnitLastValidFillType(levelerNode.fillUnitIndex)
            if fillType ~ = FillType.UNKNOWN then
                break
            end
        end

        if fillType ~ = FillType.UNKNOWN and spec.lastFillLevelMovedPct > 0 then
            g_effectManager:setEffectTypeInfo(spec.effects, fillType)
            g_effectManager:startEffects(spec.effects)

            for _, effect in pairs(spec.effects) do
                if effect:isa(LevelerEffect) or effect:isa(SnowPlowMotionPathEffect) then
                    effect:setFillLevel(spec.lastFillLevelMovedPct)
                    effect:setLastVehicleSpeed( self.movingDirection * self:getLastSpeed())
                end
            end
        else
                g_effectManager:stopEffects(spec.effects)
            end
        end

        if self.isServer then
            for _, levelerNode in pairs(spec.nodes) do
                local x0,y0,z0 = localToWorld(levelerNode.node, - levelerNode.halfWidth, levelerNode.yOffset, levelerNode.maxDropDirOffset)
                local x1,y1,z1 = localToWorld(levelerNode.node, levelerNode.halfWidth, levelerNode.yOffset, levelerNode.maxDropDirOffset)
                if not spec.ignoreFarmlandState then
                    local ownerFarmId = self:getOwnerFarmId()
                    if not g_farmlandManager:getCanAccessLandAtWorldPosition(ownerFarmId, x0, z0) or
                        not g_farmlandManager:getCanAccessLandAtWorldPosition(ownerFarmId, x1, z1) then
                        break
                    end
                end

                local pickedUpFillLevel = 0
                local fillType = self:getFillUnitFillType(levelerNode.fillUnitIndex)
                local fillLevel = self:getFillUnitFillLevel(levelerNode.fillUnitIndex)

                if fillType = = FillType.UNKNOWN or fillLevel < g_densityMapHeightManager:getMinValidLiterValue(fillType) + 0.001 then
                    local newFillType = DensityMapHeightUtil.getFillTypeAtLine(x0,y0,z0, x1,y1,z1, 0.5 * levelerNode.maxDropDirOffset)
                    if newFillType ~ = FillType.UNKNOWN and newFillType ~ = fillType then
                        if self:getFillUnitSupportsFillType(levelerNode.fillUnitIndex, newFillType) then
                            self:addFillUnitFillLevel( self:getOwnerFarmId(), levelerNode.fillUnitIndex, - math.huge)
                            fillType = newFillType
                        end
                    end
                end
                local heightType = g_densityMapHeightManager:getDensityMapHeightTypeByFillTypeIndex(fillType)

                if fillType ~ = FillType.UNKNOWN and heightType ~ = nil then
                    local innerRadius = 0.5
                    local outerRadius = 2
                    local capacity = self:getFillUnitCapacity(levelerNode.fillUnitIndex)

                    -- limit the leveler node Y direction to the world Y(So the node + offset can be higher as the node but cannot dig into the ground when facing downwards)
                    local dirY = 0
                    if levelerNode.alignToWorldY then
                        local dirX, dirZ
                        dirX, dirY, dirZ = localDirectionToWorld(levelerNode.referenceFrame, 0 , 0 , 1 )
                        I3DUtil.setWorldDirection(levelerNode.node, dirX, math.max(dirY, 0 ), dirZ, 0 , 1 , 0 )
                    end
                    --#debug DebugGizmo.renderAtNode(levelerNode.node, "levelerNode")

                    -- pick up at node
                    if self:getIsLevelerPickupNodeActive(levelerNode) then
                        if spec.pickUpDirection = = self.movingDirection and self.lastSpeed > 0.0001 then
                            local sx,sy,sz = localToWorld(levelerNode.node, - levelerNode.halfWidth, levelerNode.yOffset, levelerNode.zOffset)
                            local ex,ey,ez = localToWorld(levelerNode.node, levelerNode.halfWidth, levelerNode.yOffset, levelerNode.zOffset)

                            --#debug DebugUtil.drawDebugLine(sx, sy, sz, ex, ey, ez, 0, 1, 0)

                            if dirY > = 0 then
                                local _, sy2, _ = localToWorld(levelerNode.node, - levelerNode.halfWidth, levelerNode.yOffset, levelerNode.zOffset + innerRadius)
                                local _, ey2, _ = localToWorld(levelerNode.node, levelerNode.halfWidth, levelerNode.yOffset, levelerNode.zOffset + innerRadius)

                                sy = math.max(sy, sy2)
                                ey = math.max(ey, ey2)
                            end

                            fillLevel = self:getFillUnitFillLevel(levelerNode.fillUnitIndex)
                            local delta = - (capacity - fillLevel)
                            local numHeightLimitChecks = levelerNode.numHeightLimitChecks
                            if numHeightLimitChecks > 0 then
                                local movementY = 0
                                for i = 0 ,numHeightLimitChecks do
                                    local t = i / numHeightLimitChecks
                                    local xi = sx + (ex - sx) * t
                                    local yi = sy + (ey - sy) * t
                                    local zi = sz + (ez - sz) * t
                                    local hi = DensityMapHeightUtil.getHeightAtWorldPos(xi,yi,zi)
                                    movementY = math.max(movementY, hi - 0.05 - yi) -- limit to 5cm below surface
                                end
                                if movementY > 0 then
                                    sy = sy + movementY
                                    ey = ey + movementY
                                end
                            end

                            levelerNode.lastPickUp, levelerNode.lineOffsetPickUp = DensityMapHeightUtil.tipToGroundAroundLine( self , delta, fillType, sx,sy,sz, ex,ey,ez, innerRadius, outerRadius, levelerNode.lineOffsetPickUp, true , nil )

                            --#debug DebugUtil.drawDebugLine(sx, sy, sz, ex, ey, ez, 1, 0, 0, innerRadius)

                            if levelerNode.lastPickUp < 0 then
                                if self.notifiyBunkerSilo ~ = nil then
                                    self:notifiyBunkerSilo(levelerNode.lastPickUp, fillType, (sx + ex) * 0.5 , (sy + ey) * 0.5 , (sz + ez) * 0.5 )
                                end

                                levelerNode.lastPickUp = levelerNode.lastPickUp + spec.litersToPickup
                                spec.litersToPickup = 0

                                self:addFillUnitFillLevel( self:getOwnerFarmId(), levelerNode.fillUnitIndex, - levelerNode.lastPickUp, fillType, ToolType.UNDEFINED, nil )
                                pickedUpFillLevel = levelerNode.lastPickUp
                            end
                        end
                    end

                    local lastPickUpPerMS = - pickedUpFillLevel

                    spec.lastFillLevelMovedBuffer = spec.lastFillLevelMovedBuffer + lastPickUpPerMS
                    spec.lastFillLevelMovedBufferTimer = spec.lastFillLevelMovedBufferTimer + dt
                    if spec.lastFillLevelMovedBufferTimer > spec.lastFillLevelMovedBufferTime then
                        spec.lastFillLevelMovedTarget = spec.lastFillLevelMovedBuffer / spec.lastFillLevelMovedBufferTimer

                        spec.lastFillLevelMovedBufferTimer = 0
                        spec.lastFillLevelMovedBuffer = 0
                    end

                    if self.movingDirection < 0 and self.lastSpeed * 3600 > 0.5 then
                        spec.lastFillLevelMovedBuffer = 0
                    end

                    -- drop at node
                    fillLevel = self:getFillUnitFillLevel(levelerNode.fillUnitIndex)
                    if fillLevel > 0 then
                        local f = (fillLevel / capacity)
                        local width = MathUtil.lerp(levelerNode.halfMinDropWidth, levelerNode.halfMaxDropWidth, f)

                        local sx,sy,sz = localToWorld(levelerNode.node, - width, levelerNode.yOffset, levelerNode.zOffset)
                        local ex,ey,ez = localToWorld(levelerNode.node, width, levelerNode.yOffset, levelerNode.zOffset)

                        local yOffset = - 0.15

                        levelerNode.lastDrop1, levelerNode.lineOffsetDrop1 = DensityMapHeightUtil.tipToGroundAroundLine( self , fillLevel, fillType, sx,sy + yOffset,sz, ex,ey + yOffset,ez, innerRadius, outerRadius, levelerNode.lineOffsetDrop1, true , nil )

                        --#debug DebugUtil.drawDebugLine(sx,sy+yOffset,sz, ex,ey+yOffset,ez, 1, 1, 1, innerRadius)

                        if levelerNode.lastDrop1 > 0 then
                            local leftOver = fillLevel - levelerNode.lastDrop1
                            if leftOver < = g_densityMapHeightManager:getMinValidLiterValue(fillType) then
                                levelerNode.lastDrop1 = fillLevel
                                spec.litersToPickup = spec.litersToPickup + leftOver
                            end
                            self:addFillUnitFillLevel( self:getOwnerFarmId(), levelerNode.fillUnitIndex, - levelerNode.lastDrop1, fillType, ToolType.UNDEFINED, nil )
                        end
                    end

                    -- drop further at front
                    fillLevel = self:getFillUnitFillLevel(levelerNode.fillUnitIndex)

                    if fillLevel > 0 then
                        local dropOffset = MathUtil.lerp(levelerNode.minDropDirOffset, levelerNode.maxDropDirOffset, spec.lastFillLevelMovedPct)

                        local wx, wy, wz = localToWorld(levelerNode.node, 0 , levelerNode.yOffset, 0 )
                        local tx, ty, tz = localToWorld(levelerNode.node, 0 , levelerNode.yOffset, levelerNode.zOffset + dropOffset)

                        levelerNode.raycastLastFillType = fillType
                        levelerNode.raycastLastRadius = outerRadius
                        levelerNode.raycastHitObject = false
                        local rDirX, rDirY, rDirZ = tx - wx, ty - wy, tz - wz
                        local distance = MathUtil.vector3Length(rDirX, rDirY, rDirZ)
                        rDirX, rDirY, rDirZ = MathUtil.vector3Normalize(rDirX, rDirY, rDirZ)
                        raycastAllAsync(wx, wy, wz, rDirX, rDirY, rDirZ, distance, "onLevelerRaycastCallback" , levelerNode, Leveler.COLLISION_MASK)

                        --#debug drawDebugLine(wx, wy, wz, 1, 0, 0, wx+rDirX*distance, wy+rDirY*distance, wz+rDirZ*distance, 0, 1, 0, true)
                    end
                else
                        spec.lastFillLevelMovedBuffer = 0
                        spec.lastFillLevelMovedTarget = 0
                    end

                    -- call fill level changed callack to inform bunker silo about change
                    if pickedUpFillLevel < 0 and fillType ~ = FillType.UNKNOWN then
                        self:notifiyBunkerSilo(pickedUpFillLevel, fillType)
                    end

                    if levelerNode.allowsSmoothing and(levelerNode.smoothDirection = = 0 or self.movingDirection = = levelerNode.smoothDirection) then
                        local smoothAmount = 0
                        if self.lastSpeedReal > 0.0002 then -- start smoothing if driving faster than 0.7km/h
                            smoothAmount = spec.smoothAccumulation + math.max( self.lastMovedDistance * 0.5 , 0.0003 * dt) -- smooth 1.2m per meter driving or at least 0.3m/s
                            local rounded = DensityMapHeightUtil.getRoundedHeightValue(smoothAmount)
                            spec.smoothAccumulation = smoothAmount - rounded
                        else
                                spec.smoothAccumulation = 0
                            end

                            if smoothAmount > 0 then
                                DensityMapHeightUtil.smoothAroundLine(levelerNode.node, levelerNode.width, levelerNode.smoothGroundRadius, levelerNode.smoothOverlap, smoothAmount, true )
                            end
                        end
                    end

                    local smoothFactor = 0.05
                    if spec.lastFillLevelMovedTarget = = 0 then
                        smoothFactor = 0.2
                    end

                    spec.lastFillLevelMoved = spec.lastFillLevelMoved * ( 1 - smoothFactor) + spec.lastFillLevelMovedTarget * smoothFactor
                    if spec.lastFillLevelMoved < 0.005 then
                        spec.lastFillLevelMoved = 0
                    end

                    local oldPercentage = spec.lastFillLevelMovedPct
                    spec.lastFillLevelMovedPct = math.max( math.min(spec.lastFillLevelMoved / spec.maxFillLevelPerMS, 1 ), 0 )

                    if spec.lastFillLevelMovedPct ~ = oldPercentage then
                        self:raiseDirtyFlags(spec.dirtyFlag)
                    end

                    if spec.forceNode ~ = nil then
                        if self.movingDirection = = spec.forceDir and spec.lastFillLevelMoved > 0 then
                            spec.lastForce = - spec.maxForce * spec.lastFillLevelMovedPct
                            local dx, dy, dz = localDirectionToWorld(spec.forceDirNode, 0 , 0 , spec.lastForce)
                            local px, py, pz = getCenterOfMass(spec.forceNode)

                            addForce(spec.forceNode, dx, dy, dz, px, py, pz, true )
                        end
                    end
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
function Leveler:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_leveler
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, spec.lastFillLevelMovedPct * Leveler.LEVEL_MAX_VALUE, Leveler.LEVEL_NUM_BITS)
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
function Leveler.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and SpecializationUtil.hasSpecialization( BunkerSiloInteractor , specializations)
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
function Leveler.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Leveler )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Leveler )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Leveler )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Leveler )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Leveler )
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
function Leveler.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getIsLevelerPickupNodeActive" , Leveler.getIsLevelerPickupNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "loadLevelerNodeFromXML" , Leveler.loadLevelerNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "onLevelerRaycastCallback" , Leveler.onLevelerRaycastCallback)
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
function Leveler.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAttacherJointControlDampingAllowed" , Leveler.getIsAttacherJointControlDampingAllowed)
end

```