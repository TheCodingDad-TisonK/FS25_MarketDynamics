## WoodHarvester

**Description**

> Specialization for wood harvesters including grabbing, felling, delimbing and cutting of certrain types of trees

**Functions**

- [actionEventCutTree](#actioneventcuttree)
- [actionEventDropTree](#actioneventdroptree)
- [actionEventSetCutlength](#actioneventsetcutlength)
- [actionEventTiltHeader](#actioneventtiltheader)
- [cutTree](#cuttree)
- [dropWoodHarvesterTree](#dropwoodharvestertree)
- [findSplitShapesInRange](#findsplitshapesinrange)
- [getAutoAlignHasValidTree](#getautoalignhasvalidtree)
- [getCanBeSelected](#getcanbeselected)
- [getCanSplitShapeBeAccessed](#getcansplitshapebeaccessed)
- [getConsumingLoad](#getconsumingload)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getIsAutoTreeAlignmentAllowed](#getisautotreealignmentallowed)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsWoodHarvesterTiltStateAllowed](#getiswoodharvestertiltstateallowed)
- [getSpecValueMaxTreeSize](#getspecvaluemaxtreesize)
- [getSupportsAutoTreeAlignment](#getsupportsautotreealignment)
- [initSpecialization](#initspecialization)
- [loadSpecValueMaxTreeSize](#loadspecvaluemaxtreesize)
- [loadWoodHarvesterHeaderTiltFromXML](#loadwoodharvesterheadertiltfromxml)
- [onCutTree](#oncuttree)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onDelimbTree](#ondelimbtree)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onStateChange](#onstatechange)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onVehicleSettingChanged](#onvehiclesettingchanged)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setLastTreeDiameter](#setlasttreediameter)
- [setWoodHarvesterCutLengthIndex](#setwoodharvestercutlengthindex)
- [setWoodHarvesterTiltState](#setwoodharvestertiltstate)
- [woodHarvesterSplitShapeCallback](#woodharvestersplitshapecallback)

### actionEventCutTree

**Description**

**Definition**

> actionEventCutTree()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function WoodHarvester.actionEventCutTree( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_woodHarvester
    if self:getIsTurnedOn() then
        if g_ time - spec.lastCutEventTime > spec.cutEventCoolDownTime then
            if spec.hasAttachedSplitShape then
                if not spec.isAttachedSplitShapeMoving and self:getAnimationTime(spec.cutAnimation.name) = = 1 then
                    if spec.automaticCuttingIsDirty then
                        self:cutTree( 0 )
                        spec.lastCutEventTime = g_ time
                    else
                            self:cutTree(spec.currentCutLength)
                            spec.lastCutEventTime = g_ time
                        end
                    end
                elseif spec.curSplitShape ~ = nil and spec.cutTimer = = - 1 then
                        self:cutTree( 0 )
                        spec.lastCutEventTime = g_ time
                    end
                end
            else
                    g_currentMission:showBlinkingWarning(spec.texts.warningFirstTurnOnTheTool, 2000 )
                end
            end

```

### actionEventDropTree

**Description**

**Definition**

> actionEventDropTree()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function WoodHarvester.actionEventDropTree( self , actionName, inputValue, callbackState, isAnalog)
    self:dropWoodHarvesterTree()
end

```

### actionEventSetCutlength

**Description**

**Definition**

> actionEventSetCutlength()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function WoodHarvester.actionEventSetCutlength( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_woodHarvester

    if not spec.isAttachedSplitShapeMoving then
        local cutLengthIndex = spec.currentCutLengthIndex + callbackState
        if cutLengthIndex > #spec.cutLengths then
            cutLengthIndex = 1
        elseif cutLengthIndex < 1 then
                cutLengthIndex = #spec.cutLengths
            end

            self:setWoodHarvesterCutLengthIndex(cutLengthIndex)
        end
    end

```

### actionEventTiltHeader

**Description**

**Definition**

> actionEventTiltHeader()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function WoodHarvester.actionEventTiltHeader( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_woodHarvester

    if self:getIsWoodHarvesterTiltStateAllowed(spec.headerJointTilt) and not spec.hasAttachedSplitShape then
        self:setWoodHarvesterTiltState()
    end
end

```

### cutTree

**Description**

**Definition**

> cutTree()

**Arguments**

| any | length      |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function WoodHarvester:cutTree(length, noEventSend)
    local spec = self.spec_woodHarvester
    WoodHarvesterCutTreeEvent.sendEvent( self , length, noEventSend)
    if self.isServer then
        if length = = 0 then
            if spec.attachedSplitShape ~ = nil or spec.curSplitShape ~ = nil then
                -- while we pick up trees from the ground we skip the cutting
                    if spec.attachedSplitShape = = nil and spec.curSplitShape ~ = nil and getRigidBodyType(spec.curSplitShape) ~ = RigidBodyType.STATIC then
                        spec.cutTimer = 0
                        if spec.cutAnimation.name ~ = nil then
                            self:setAnimationTime(spec.cutAnimation.name, 0 , true )
                            self:playAnimation(spec.cutAnimation.name, 999999 , self:getAnimationTime(spec.cutAnimation.name))
                        end
                    else
                            spec.cutTimer = 100
                            if spec.cutAnimation.name ~ = nil then
                                self:setAnimationTime(spec.cutAnimation.name, 0 , true )
                                self:playAnimation(spec.cutAnimation.name, spec.cutAnimation.speedScale, self:getAnimationTime(spec.cutAnimation.name))
                            end
                        end
                    end
                elseif length > 0 and spec.attachedSplitShape ~ = nil then
                        spec.attachedSplitShapeTargetY = spec.attachedSplitShapeLastCutY + length * spec.cutAttachDirection

                        self:onDelimbTree( true )
                        if g_server ~ = nil then
                            g_server:broadcastEvent( WoodHarvesterOnDelimbTreeEvent.new( self , true ), nil , nil , self )
                        end
                    end
                end

                spec.automaticCuttingIsDirty = false
            end

```

### dropWoodHarvesterTree

**Description**

**Definition**

> dropWoodHarvesterTree()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function WoodHarvester:dropWoodHarvesterTree(noEventSend)
    if self.isServer then
        local spec = self.spec_woodHarvester

        if spec.attachedSplitShapeJointIndex ~ = nil then
            removeJoint(spec.attachedSplitShapeJointIndex)
            spec.attachedSplitShapeJointIndex = nil
        end
        spec.attachedSplitShape = nil

        self:onDelimbTree( false )
        g_server:broadcastEvent( WoodHarvesterOnDelimbTreeEvent.new( self , false ), nil , nil , self )

        SpecializationUtil.raiseEvent( self , "onCutTree" , 0 , false , false )
        g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , 0 ), nil , nil , self )
    end

    WoodHarvesterDropTreeEvent.sendEvent( self , noEventSend)
end

```

### findSplitShapesInRange

**Description**

> Searches for split shapes in range

**Definition**

> findSplitShapesInRange(float yOffset, boolean skipCutAnimation)

**Arguments**

| float   | yOffset          | y offset for search |
|---------|------------------|---------------------|
| boolean | skipCutAnimation | skip cut animation  |

**Code**

```lua
function WoodHarvester:findSplitShapesInRange(yOffset, skipCutAnimation)
    local spec = self.spec_woodHarvester
    if spec.attachedSplitShape = = nil and spec.cutNode ~ = nil then
        local x,y,z = localToWorld(spec.cutNode, yOffset or 0 , 0 , 0 )
        local nx,ny,nz = localDirectionToWorld(spec.cutNode, 1 , 0 , 0 )
        local yx,yy,yz = localDirectionToWorld(spec.cutNode, 0 , 1 , 0 )

        if spec.curSplitShape = = nil and(spec.cutReleasedComponentJoint = = nil or spec.cutReleasedComponentJointRotLimitX = = 0 ) then
            local shape, minY, maxY, minZ, maxZ = findSplitShape(x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ)

            if shape ~ = 0 then
                if not g_splitShapeManager:getSplitShapeAllowsHarvester(shape) then
                    spec.warnInvalidTree = true
                else
                        if self:getCanSplitShapeBeAccessed(x, z, shape) then
                            local treeDx,treeDy,treeDz = localDirectionToWorld(shape, 0 , 1 , 0 ) -- wood harvester trees always grow in the y direction
                            local cosTreeAngle = MathUtil.dotProduct(nx,ny,nz, treeDx,treeDy,treeDz)

                            local angleLimit = 0.2617 -- 15° angle for standing trees
                                if getRigidBodyType(shape) ~ = RigidBodyType.STATIC then
                                    angleLimit = 0.6981 -- 40° angle for logs laying on the ground
                                    end

                                    -- Only allow cutting if the cut header is approximately parallel to the tree
                                        -- allow in both directions, so we can also pickup split shapes in any rotation
                                        local angle = 1.57079 - math.abs( math.acos(cosTreeAngle) - 1.57079 )
                                        if angle < = angleLimit then
                                            local radius = math.max(maxY - minY, maxZ - minZ) * 0.5 * cosTreeAngle

                                            --#debug local x1, y1, z1 = localToWorld(spec.cutNode, yOffset or 0, minY, minZ)
                                            --#debug local x2, y2, z2 = localToWorld(spec.cutNode, yOffset or 0, minY, maxZ)
                                            --#debug local x3, y3, z3 = localToWorld(spec.cutNode, yOffset or 0, maxY, minZ)
                                            --#debug Utils.renderTextAtWorldPosition((x1+x3) / 2, (y1+y3) / 2, (z1+z3) / 2, string.format("diam: %.1f/%.1f", radius*2, spec.cutMaxRadius*2), getCorrectTextSize(0.012), 0)
                                            --#debug DebugPlane.renderWithPositions(x1, y1, z1, x2, y2, z2, x3, y3, z3, Color.PRESETS.GREEN)

                                            if radius > spec.cutMaxRadius then
                                                spec.warnInvalidTreeRadius = true

                                                -- check one meter higher if the tree would fit and then display different warning
                                                    x, y, z = localToWorld(spec.cutNode, yOffset or 0 + 1 , 0 , 0 )
                                                    shape, minY, maxY, minZ, maxZ = findSplitShape(x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ)
                                                    if shape ~ = 0 then
                                                        radius = math.max(maxY - minY, maxZ - minZ) * 0.5 * math.cos(angle)

                                                        --#debug x1, y1, z1 = localToWorld(spec.cutNode, yOffset or 0 + 1, minY, minZ)
                                                        --#debug x2, y2, z2 = localToWorld(spec.cutNode, yOffset or 0 + 1, minY, maxZ)
                                                        --#debug x3, y3, z3 = localToWorld(spec.cutNode, yOffset or 0 + 1, maxY, minZ)
                                                        --#debug Utils.renderTextAtWorldPosition((x1+x3) / 2, (y1+y3) / 2, (z1+z3) / 2, string.format("diam: %.1f/%.1f", radius*2, spec.cutMaxRadius*2), getCorrectTextSize(0.012), 0)
                                                        --#debug DebugPlane.renderWithPositions(x1, y1, z1, x2, y2, z2, x3, y3, z3, Color.PRESETS.GREEN)

                                                        if radius < = spec.cutMaxRadius then
                                                            spec.warnInvalidTreeRadius = false
                                                            spec.warnInvalidTreePosition = true
                                                        end
                                                    end
                                                else
                                                        self:setLastTreeDiameter( math.max(maxY - minY, maxZ - minZ))
                                                        spec.curSplitShape = shape

                                                        if skipCutAnimation then
                                                            self:setAnimationTime(spec.cutAnimation.name, 1 , true )
                                                            spec.cutTimer = 0
                                                        end
                                                    end
                                                end
                                            else
                                                    spec.warnTreeNotOwned = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end

```

### getAutoAlignHasValidTree

**Description**

**Definition**

> getAutoAlignHasValidTree()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | radius    |

**Code**

```lua
function WoodHarvester:getAutoAlignHasValidTree(superFunc, radius)
    local spec = self.spec_woodHarvester
    return spec.curSplitShape ~ = nil , radius < = spec.cutMaxRadius
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
function WoodHarvester:getCanBeSelected(superFunc)
    return true
end

```

### getCanSplitShapeBeAccessed

**Description**

**Definition**

> getCanSplitShapeBeAccessed()

**Arguments**

| any | x     |
|-----|-------|
| any | z     |
| any | shape |

**Code**

```lua
function WoodHarvester:getCanSplitShapeBeAccessed(x, z, shape)
    return g_splitShapeManager:getIsShapeCutAllowed(x, z, shape, self:getActiveFarm(), self:getOwnerConnection())
end

```

### getConsumingLoad

**Description**

**Definition**

> getConsumingLoad()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function WoodHarvester:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local loadPercentage = 0

    local spec = self.spec_woodHarvester
    if spec.isAttachedSplitShapeMoving or self:getIsAnimationPlaying(spec.cutAnimation.name) then
        loadPercentage = 1
    end

    return value + loadPercentage, count + 1
end

```

### getDoConsumePtoPower

**Description**

> Returns if should consume pto power

**Definition**

> getDoConsumePtoPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | consume | consumePtoPower |
|-----|---------|-----------------|

**Code**

```lua
function WoodHarvester:getDoConsumePtoPower(superFunc)
    return superFunc( self ) or self:getIsTurnedOn()
end

```

### getIsAutoTreeAlignmentAllowed

**Description**

**Definition**

> getIsAutoTreeAlignmentAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function WoodHarvester:getIsAutoTreeAlignmentAllowed(superFunc)
    local spec = self.spec_woodHarvester
    if spec.hasAttachedSplitShape then
        return false
    end

    return superFunc( self )
end

```

### getIsFoldAllowed

**Description**

**Definition**

> getIsFoldAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | direction  |
| any | onAiTurnOn |

**Code**

```lua
function WoodHarvester:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_woodHarvester
    if spec.hasAttachedSplitShape then
        return false , spec.texts.warningFoldingTreeMounted
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsWoodHarvesterTiltStateAllowed

**Description**

**Definition**

> getIsWoodHarvesterTiltStateAllowed()

**Arguments**

| any | headerTilt |
|-----|------------|

**Code**

```lua
function WoodHarvester:getIsWoodHarvesterTiltStateAllowed(headerTilt)
    return true
end

```

### getSpecValueMaxTreeSize

**Description**

**Definition**

> getSpecValueMaxTreeSize()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function WoodHarvester.getSpecValueMaxTreeSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.woodHarvesterMaxTreeSize ~ = nil then
        local value = storeItem.specs.woodHarvesterMaxTreeSize * 2 * 100
        local str = string.format( "%d%s" , MathUtil.round(value), g_i18n:getText( "unit_cmShort" ))
        if returnValues and returnRange then
            return value, value, str
        elseif returnValues then
                return value, str
            else
                    return str
                end
            end

            return nil
        end

```

### getSupportsAutoTreeAlignment

**Description**

**Definition**

> getSupportsAutoTreeAlignment()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function WoodHarvester:getSupportsAutoTreeAlignment(superFunc)
    return true
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function WoodHarvester.initSpecialization()
    g_storeManager:addSpecType( "woodHarvesterMaxTreeSize" , "shopListAttributeIconMaxTreeSize" , WoodHarvester.loadSpecValueMaxTreeSize, WoodHarvester.getSpecValueMaxTreeSize, StoreSpecies.VEHICLE)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "WoodHarvester" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.woodHarvester.cutNode#node" , "Cut node" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutNode#maxRadius" , "Max.radius" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutNode#sizeY" , "Size Y" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutNode#sizeZ" , "Size Z" , 1 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.woodHarvester.cutNode#attachNode" , "Attach node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.woodHarvester.cutNode#attachReferenceNode" , "Attach reference node" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutNode#attachMoveSpeed" , "Attach move speed" , 3 )
    schema:register(XMLValueType.INT, "vehicle.woodHarvester.cutNode#releasedComponentJointIndex" , "Released component joint" )
    schema:register(XMLValueType.ANGLE, "vehicle.woodHarvester.cutNode#releasedComponentJointRotLimitXSpeed" , "Released component joint rot limit X speed" , 100 )
    schema:register(XMLValueType.INT, "vehicle.woodHarvester.cutNode#releasedComponentJoint2Index" , "Released component joint 2" )

    schema:register(XMLValueType.STRING, WoodHarvester.HEADER_JOINT_TILT_XML_KEY .. "#animationName" , "Header tilt animation" )
    schema:register(XMLValueType.FLOAT, WoodHarvester.HEADER_JOINT_TILT_XML_KEY .. "#speedFactor" , "Speed of header tilt animation" , 1 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.woodHarvester.delimbNode#node" , "Delimb node" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.delimbNode#sizeX" , "Delimb size X" , 0.1 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.delimbNode#sizeY" , "Delimb size Y" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.delimbNode#sizeZ" , "Delimb size Z" , 1 )
    schema:register(XMLValueType.BOOL, "vehicle.woodHarvester.delimbNode#delimbOnCut" , "Delimb on cut" , false )

    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutLengths#min" , "Min.cut length" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutLengths#max" , "Max.cut length" , 5 )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutLengths#step" , "Cut length steps" , 0.5 )
    schema:register(XMLValueType.VECTOR_N, "vehicle.woodHarvester.cutLengths#values" , "Multiple lengths that are available separated by blank space" )
    schema:register(XMLValueType.INT, "vehicle.woodHarvester.cutLengths#startIndex" , "Default selected cut length index" , 1 )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.woodHarvester.cutEffects" )
    EffectManager.registerEffectXMLPaths(schema, "vehicle.woodHarvester.delimbEffects" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.woodHarvester.forwardingNodes" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.woodHarvester.sounds" , "cut" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.woodHarvester.sounds" , "delimb" )

    schema:register(XMLValueType.STRING, "vehicle.woodHarvester.cutAnimation#name" , "Cut animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutAnimation#speedScale" , "Cut animation speed scale" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.cutAnimation#cutTime" , "Cut animation cut time" )

    schema:register(XMLValueType.STRING, "vehicle.woodHarvester.grabAnimation#name" , "Grab animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.grabAnimation#speedScale" , "Grab animation speed scale" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.woodHarvester.treeSizeMeasure#node" , "Tree size measure node" )
    schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.treeSizeMeasure#rotMaxRadius" , "Max.tree size as reference for grab animation" , 1 )
        schema:register(XMLValueType.FLOAT, "vehicle.woodHarvester.treeSizeMeasure#rotMaxAnimTime" , "Grab animation time which reflects the rotMaxRadius(0-1)" , 1 )

        Dashboard.registerDashboardXMLPaths(schema, "vehicle.woodHarvester.dashboards" , { "cutLength" , "curCutLength" , "diameter" } )

        schema:setXMLSpecializationType()

        local schemaSavegame = Vehicle.xmlSchemaSavegame
        schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).woodHarvester#currentCutLengthIndex" , "Current cut length selection index" , 1 )
        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).woodHarvester#isTurnedOn" , "Harvester is turned on" , false )
        schemaSavegame:register(XMLValueType.VECTOR_ 4 , "vehicles.vehicle(?).woodHarvester#lastTreeSize" , "Last dimensions of tree to cutNode" )
        schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).woodHarvester#lastCutAttachDirection" , "Last tree attach direction" )
        schemaSavegame:register(XMLValueType.VECTOR_ 3 , "vehicles.vehicle(?).woodHarvester#lastTreeJointPos" , "Last tree joint position in local space of splitShape" )
        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).woodHarvester#hasAttachedSplitShape" , "Has split shape attached" , false )
    end

```

### loadSpecValueMaxTreeSize

**Description**

**Definition**

> loadSpecValueMaxTreeSize()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function WoodHarvester.loadSpecValueMaxTreeSize(xmlFile, customEnvironment, baseDir)
    return xmlFile:getValue( "vehicle.woodHarvester.cutNode#maxRadius" )
end

```

### loadWoodHarvesterHeaderTiltFromXML

**Description**

**Definition**

> loadWoodHarvesterHeaderTiltFromXML()

**Arguments**

| any | headerTilt |
|-----|------------|
| any | xmlFile    |
| any | key        |

**Code**

```lua
function WoodHarvester:loadWoodHarvesterHeaderTiltFromXML(headerTilt, xmlFile, key)
    headerTilt.animationName = xmlFile:getValue(key .. "#animationName" )
    if headerTilt.animationName = = nil then
        return false
    end

    headerTilt.speedFactor = xmlFile:getValue(key .. "#speedFactor" , 1 )
    headerTilt.state = false
    headerTilt.lastState = nil

    return true
end

```

### onCutTree

**Description**

**Definition**

> onCutTree()

**Arguments**

| any | radius             |
|-----|--------------------|
| any | isNewTree          |
| any | loadedFromSavegame |

**Code**

```lua
function WoodHarvester:onCutTree(radius, isNewTree, loadedFromSavegame)
    local spec = self.spec_woodHarvester
    if radius > 0 then
        if self.isClient then
            if spec.grabAnimation.name ~ = nil then
                local targetAnimTime = math.min(radius / spec.treeSizeMeasure.rotMaxRadius, 1 ) * spec.treeSizeMeasure.rotMaxAnimTime

                if spec.grabAnimation.speedScale < 0 then
                    targetAnimTime = 1.0 - targetAnimTime
                end
                self:setAnimationStopTime(spec.grabAnimation.name, targetAnimTime)

                if targetAnimTime > self:getAnimationTime(spec.grabAnimation.name) then
                    self:playAnimation(spec.grabAnimation.name, spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), true )
                else
                        self:playAnimation(spec.grabAnimation.name, - spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), true )
                    end
                end

                self:setLastTreeDiameter( 2 * radius)
            end

            spec.hasAttachedSplitShape = true
        else
                if spec.grabAnimation.name ~ = nil then
                    if spec.grabAnimation.speedScale > 0 then
                        self:setAnimationStopTime(spec.grabAnimation.name, 1 )
                    else
                            self:setAnimationStopTime(spec.grabAnimation.name, 0 )
                        end
                        self:playAnimation(spec.grabAnimation.name, spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), true )
                    end
                    spec.hasAttachedSplitShape = false
                    spec.cutTimer = - 1

                    if self.isServer then
                        if spec.headerJointTilt ~ = nil and spec.headerJointTilt.lastState ~ = nil then
                            self:setWoodHarvesterTiltState(spec.headerJointTilt.lastState)
                            spec.headerJointTilt.lastState = nil
                        end
                    end
                end

                if loadedFromSavegame then
                    if spec.grabAnimation.name ~ = nil then
                        AnimatedVehicle.updateAnimationByName( self , spec.grabAnimation.name, 99999999 , true )
                    end
                end
            end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function WoodHarvester:onDeactivate()
    local spec = self.spec_woodHarvester
    spec.curSplitShape = nil
    self:setLastTreeDiameter( 0 )
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function WoodHarvester:onDelete()
    local spec = self.spec_woodHarvester
    if spec.attachedSplitShapeJointIndex ~ = nil then
        removeJoint(spec.attachedSplitShapeJointIndex)
        spec.attachedSplitShapeJointIndex = nil
    end
    if spec.cutAttachHelperNode ~ = nil then
        delete(spec.cutAttachHelperNode)
    end

    g_effectManager:deleteEffects(spec.cutEffects)
    g_effectManager:deleteEffects(spec.delimbEffects)
    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.forwardingNodes)
end

```

### onDelimbTree

**Description**

**Definition**

> onDelimbTree()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function WoodHarvester:onDelimbTree(state)
    local spec = self.spec_woodHarvester
    if state then
        spec.isAttachedSplitShapeMoving = true
    else
            spec.isAttachedSplitShapeMoving = false

            if self.isServer then
                if spec.automaticCuttingEnabled then
                    self:cutTree( 0 )
                else
                        spec.automaticCuttingIsDirty = true
                    end
                else
                        spec.automaticCuttingIsDirty = not spec.automaticCuttingEnabled
                    end
                end
            end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function WoodHarvester:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_woodHarvester
    if isActiveForInputIgnoreSelection and isSelected and self:getIsTurnedOn() then
        if spec.cutNode ~ = nil then
            if spec.warnInvalidTreeRadius then
                g_currentMission:showBlinkingWarning(spec.texts.warningTreeTooThick, 100 )
            elseif spec.warnInvalidTreePosition then
                    g_currentMission:showBlinkingWarning(spec.texts.warningTreeTooThickAtPosition, 100 )
                elseif spec.warnInvalidTree then
                        g_currentMission:showBlinkingWarning(spec.texts.warningTreeTypeNotSupported, 100 )
                    elseif spec.warnTreeNotOwned then
                            g_currentMission:showBlinkingWarning(spec.texts.warningYouDontHaveAccessToThisLand, 100 )
                        end
                    end
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
function WoodHarvester:onLoad(savegame)
    local spec = self.spec_woodHarvester

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.delimbSound" , "vehicle.woodHarvester.sounds.delimb" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.cutSound" , "vehicle.woodHarvester.sounds.cut" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.treeSizeMeasure#index" , "vehicle.woodHarvester.treeSizeMeasure#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.forwardingWheels.wheel(0)" , "vehicle.woodHarvester.forwardingNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.cutParticleSystems" , "vehicle.woodHarvester.cutEffects" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.woodHarvester.delimbParticleSystems" , "vehicle.woodHarvester.delimbEffects" ) --FS17 to FS19

    spec.curSplitShape = nil
    spec.attachedSplitShape = nil
    spec.hasAttachedSplitShape = false
    spec.isAttachedSplitShapeMoving = false
    spec.attachedSplitShapeLastDelimbTime = 0
    spec.attachedSplitShapeX = 0
    spec.attachedSplitShapeY = 0
    spec.attachedSplitShapeZ = 0
    spec.attachedSplitShapeTargetY = 0
    spec.attachedSplitShapeLastCutY = 0
    spec.attachedSplitShapeStartY = 0
    spec.attachedSplitShapeOnlyMove = false
    spec.attachedSplitShapeOnlyMoveDelay = 0
    spec.attachedSplitShapeMoveEffectActive = false
    spec.attachedSplitShapeDelimbEffectActive = false
    spec.cutTimer = - 1

    spec.lastCutEventTime = 0
    spec.cutEventCoolDownTime = 1000 -- alllow cut event only every second so on the client side there is enough time to reseive the correct state from the server

    spec.automaticCuttingEnabled = true
    spec.automaticCuttingIsDirty = false

    spec.lastTreeSize = nil
    spec.lastTreeJointPos = nil
    spec.loadedSplitShapeFromSavegame = false

    spec.cutNode = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#node" , nil , self.components, self.i3dMappings)
    spec.cutMaxRadius = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#maxRadius" , 1 )
    spec.cutSizeY = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#sizeY" , 1 )
    spec.cutSizeZ = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#sizeZ" , 1 )
    spec.cutAttachNode = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#attachNode" , nil , self.components, self.i3dMappings)
    spec.cutAttachReferenceNode = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#attachReferenceNode" , nil , self.components, self.i3dMappings)
    spec.cutAttachMoveSpeed = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#attachMoveSpeed" , 3 ) * 0.001
    local cutReleasedComponentJointIndex = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#releasedComponentJointIndex" )
    if cutReleasedComponentJointIndex ~ = nil then
        spec.cutReleasedComponentJoint = self.componentJoints[cutReleasedComponentJointIndex]
        spec.cutReleasedComponentJointRotLimitX = 0
        spec.cutReleasedComponentJointRotLimitXSpeed = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#releasedComponentJointRotLimitXSpeed" , 100 ) * 0.001
    end
    local cutReleasedComponentJoint2Index = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#releasedComponentJoint2Index" )
    if cutReleasedComponentJoint2Index ~ = nil then
        spec.cutReleasedComponentJoint2 = self.componentJoints[cutReleasedComponentJoint2Index]
        spec.cutReleasedComponentJoint2RotLimitX = 0
        spec.cutReleasedComponentJoint2RotLimitXSpeed = self.xmlFile:getValue( "vehicle.woodHarvester.cutNode#releasedComponentJointRotLimitXSpeed" , 100 ) * 0.001
    end

    spec.headerJointTilt = { }
    if not self:loadWoodHarvesterHeaderTiltFromXML(spec.headerJointTilt, self.xmlFile, "vehicle.woodHarvester.headerJointTilt" ) then
        spec.headerJointTilt = nil
    end

    if spec.cutAttachReferenceNode ~ = nil and spec.cutAttachNode ~ = nil then
        spec.cutAttachHelperNode = createTransformGroup( "helper" )
        link(spec.cutAttachReferenceNode, spec.cutAttachHelperNode)
        setTranslation(spec.cutAttachHelperNode, 0 , 0 , 0 )
        setRotation(spec.cutAttachHelperNode, 0 , 0 , 0 )
    end

    spec.cutAttachDirection = 1
    spec.lastCutAttachDirection = 1

    spec.delimbNode = self.xmlFile:getValue( "vehicle.woodHarvester.delimbNode#node" , nil , self.components, self.i3dMappings)
    spec.delimbSizeX = self.xmlFile:getValue( "vehicle.woodHarvester.delimbNode#sizeX" , 0.1 )
    spec.delimbSizeY = self.xmlFile:getValue( "vehicle.woodHarvester.delimbNode#sizeY" , 1 )
    spec.delimbSizeZ = self.xmlFile:getValue( "vehicle.woodHarvester.delimbNode#sizeZ" , 1 )
    spec.delimbOnCut = self.xmlFile:getValue( "vehicle.woodHarvester.delimbNode#delimbOnCut" , false )

    spec.cutLengthMin = self.xmlFile:getValue( "vehicle.woodHarvester.cutLengths#min" , 1 )
    spec.cutLengthMax = self.xmlFile:getValue( "vehicle.woodHarvester.cutLengths#max" , 5 )
    spec.cutLengthStep = self.xmlFile:getValue( "vehicle.woodHarvester.cutLengths#step" , 0.5 )

    spec.cutLengths = self.xmlFile:getValue( "vehicle.woodHarvester.cutLengths#values" , nil , true )
    if spec.cutLengths = = nil or #spec.cutLengths = = 0 then
        spec.cutLengths = { }
        for i = spec.cutLengthMin, spec.cutLengthMax, spec.cutLengthStep do
            table.insert(spec.cutLengths, i)
        end
    else
            for i = 1 , #spec.cutLengths do
                if spec.cutLengths[i] = = 0 then
                    spec.cutLengths[i] = math.huge
                end
            end
        end

        spec.currentCutLengthIndex = math.clamp( self.xmlFile:getValue( "vehicle.woodHarvester.cutLengths#startIndex" , 1 ), 1 , #spec.cutLengths)
        spec.currentCutLength = spec.cutLengths[spec.currentCutLengthIndex] or 1

        if self.isClient then
            spec.cutEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.woodHarvester.cutEffects" , self.components, self , self.i3dMappings)
            spec.delimbEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.woodHarvester.delimbEffects" , self.components, self , self.i3dMappings)
            spec.forwardingNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.woodHarvester.forwardingNodes" , self.components, self , self.i3dMappings)

            spec.samples = { }
            spec.samples.cut = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.woodHarvester.sounds" , "cut" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.samples.delimb = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.woodHarvester.sounds" , "delimb" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.isCutSamplePlaying = false
            spec.isDelimbSamplePlaying = false
        end

        spec.cutAnimation = { }
        spec.cutAnimation.name = self.xmlFile:getValue( "vehicle.woodHarvester.cutAnimation#name" )
        spec.cutAnimation.speedScale = self.xmlFile:getValue( "vehicle.woodHarvester.cutAnimation#speedScale" , 1 )
        spec.cutAnimation.cutTime = self.xmlFile:getValue( "vehicle.woodHarvester.cutAnimation#cutTime" , 1 )

        spec.grabAnimation = { }
        spec.grabAnimation.name = self.xmlFile:getValue( "vehicle.woodHarvester.grabAnimation#name" )
        spec.grabAnimation.speedScale = self.xmlFile:getValue( "vehicle.woodHarvester.grabAnimation#speedScale" , 1 )

        spec.treeSizeMeasure = { }
        spec.treeSizeMeasure.node = self.xmlFile:getValue( "vehicle.woodHarvester.treeSizeMeasure#node" , nil , self.components, self.i3dMappings)
        spec.treeSizeMeasure.rotMaxRadius = self.xmlFile:getValue( "vehicle.woodHarvester.treeSizeMeasure#rotMaxRadius" , 1 )
        spec.treeSizeMeasure.rotMaxAnimTime = self.xmlFile:getValue( "vehicle.woodHarvester.treeSizeMeasure#rotMaxAnimTime" , 1 )

        spec.warnInvalidTree = false
        spec.warnInvalidTreeRadius = false
        spec.warnInvalidTreePosition = false
        spec.warnTreeNotOwned = false

        spec.lastDiameter = 0

        spec.texts = { }
        spec.texts.actionChangeCutLength = g_i18n:getText( "action_woodHarvesterChangeCutLength" )
        spec.texts.woodHarvesterTiltHeader = g_i18n:getText( "action_woodHarvesterTiltHeader" )
        spec.texts.uiMax = g_i18n:getText( "ui_max" )
        spec.texts.unitMeterShort = g_i18n:getText( "unit_mShort" )
        spec.texts.actionCut = g_i18n:getText( "action_woodHarvesterCut" )
        spec.texts.warningFoldingTreeMounted = g_i18n:getText( "warning_foldingTreeMounted" )
        spec.texts.warningTreeTooThick = g_i18n:getText( "warning_treeTooThick" )
        spec.texts.warningTreeTooThickAtPosition = g_i18n:getText( "warning_treeTooThickAtPosition" )
        spec.texts.warningTreeTypeNotSupported = g_i18n:getText( "warning_treeTypeNotSupported" )
        spec.texts.warningYouDontHaveAccessToThisLand = g_i18n:getText( "warning_youAreNotAllowedToCutThisTree" )
        spec.texts.warningFirstTurnOnTheTool = string.format(g_i18n:getText( "warning_firstTurnOnTheTool" ), self.typeDesc)

        self:registerVehicleSetting(GameSettings.SETTING.WOOD_HARVESTER_AUTO_CUT, true )
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
function WoodHarvester:onLoadFinished(savegame)
    local spec = self.spec_woodHarvester
    if savegame ~ = nil and not savegame.resetVehicles then
        local cutLengthIndex = savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#currentCutLengthIndex" , spec.currentCutLengthIndex)
        self:setWoodHarvesterCutLengthIndex(cutLengthIndex, true )

        if savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#isTurnedOn" , false ) then
            self:setIsTurnedOn( true )
        end

        if spec.grabAnimation.name ~ = nil then
            AnimatedVehicle.updateAnimationByName( self , spec.grabAnimation.name, 99999999 , true )
        end

        local lastTreeSize = savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#lastTreeSize" , nil , true )
        if lastTreeSize ~ = nil then
            spec.lastTreeSize = lastTreeSize
        end

        local lastTreeJointPos = savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#lastTreeJointPos" , nil , true )
        if lastTreeJointPos ~ = nil then
            spec.lastTreeJointPos = lastTreeJointPos
        end

        spec.lastCutAttachDirection = savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#lastCutAttachDirection" , spec.lastCutAttachDirection)

        if savegame.xmlFile:getValue(savegame.key .. ".woodHarvester#hasAttachedSplitShape" , false ) then
            if self:getIsTurnedOn() then
                self:findSplitShapesInRange( 0.5 , true )

                if spec.curSplitShape ~ = nil and spec.curSplitShape ~ = 0 then
                    spec.loadedSplitShapeFromSavegame = true
                end
            end
        end
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function WoodHarvester:onPostLoad(savegame)
    local spec = self.spec_woodHarvester
    if spec.grabAnimation.name ~ = nil then
        local speedScale = - spec.grabAnimation.speedScale
        local stopTime = 0
        if spec.grabAnimation.speedScale < 0 then
            stopTime = 1
        end
        self:playAnimation(spec.grabAnimation.name, speedScale, nil , true )
        self:setAnimationStopTime(spec.grabAnimation.name, stopTime)
        AnimatedVehicle.updateAnimationByName( self , spec.grabAnimation.name, 99999999 , true )
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
function WoodHarvester:onReadStream(streamId, connection)
    local spec = self.spec_woodHarvester
    spec.hasAttachedSplitShape = streamReadBool(streamId)
    if spec.hasAttachedSplitShape then
        local animTime = streamReadUIntN(streamId, 7 ) / 127
        self:setAnimationTime(spec.grabAnimation.name, animTime, true )

        self:setAnimationTime(spec.cutAnimation.name, 1 , true )
    end

    spec.isAttachedSplitShapeMoving = streamReadBool(streamId)

    local cutLengthIndex = streamReadUIntN(streamId, WoodHarvester.NUM_BITS_CUT_LENGTH)
    self:setWoodHarvesterCutLengthIndex(cutLengthIndex, true )
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
function WoodHarvester:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_woodHarvester
        spec.attachedSplitShapeMoveEffectActive = streamReadBool(streamId)
        if spec.attachedSplitShapeMoveEffectActive then
            spec.attachedSplitShapeDelimbEffectActive = streamReadBool(streamId)
        else
                spec.attachedSplitShapeDelimbEffectActive = false
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
function WoodHarvester:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_woodHarvester
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA2, self , WoodHarvester.actionEventCutTree, false , true , true , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(actionEventId, spec.texts.actionCut)

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , WoodHarvester.actionEventSetCutlength, false , true , false , true , 1 )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_CUT_LENGTH_BACK, self , WoodHarvester.actionEventSetCutlength, false , true , false , true , - 1 )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.WOOD_HARVESTER_DROP, self , WoodHarvester.actionEventDropTree, false , true , false , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, true )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)

            if spec.headerJointTilt ~ = nil then
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_WOOD_HARVESTER_TILT, self , WoodHarvester.actionEventTiltHeader, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                g_inputBinding:setActionEventText(actionEventId, spec.texts.woodHarvesterTiltHeader)
            end
        end
    end
end

```

### onRegisterDashboardValueTypes

**Description**

> Called on post load to register dashboard value types

**Definition**

> onRegisterDashboardValueTypes()

**Code**

```lua
function WoodHarvester:onRegisterDashboardValueTypes()
    local spec = self.spec_woodHarvester

    local cutLength = DashboardValueType.new( "woodHarvester" , "cutLength" )
    cutLength:setValue(spec, function ()
        if spec.currentCutLength = = math.huge then
            return 9999999
        else
                return spec.currentCutLength * 100
            end
        end )
        self:registerDashboardValueType(cutLength)

        local curCutLength = DashboardValueType.new( "woodHarvester" , "curCutLength" )
        curCutLength:setValue(spec, function ()
            return math.abs(spec.attachedSplitShapeStartY - spec.attachedSplitShapeY) * 100
        end )
        self:registerDashboardValueType(curCutLength)

        local diameter = DashboardValueType.new( "woodHarvester" , "diameter" )
        diameter:setValue(spec, function ()
            return spec.lastDiameter * 1000
        end )
        self:registerDashboardValueType(diameter)
    end

```

### onStateChange

**Description**

**Definition**

> onStateChange()

**Arguments**

| any | state |
|-----|-------|
| any | data  |

**Code**

```lua
function WoodHarvester:onStateChange(state, data)
    if self.isServer then
        if state = = VehicleStateChange.MOTOR_TURN_ON then
            if self.spec_woodHarvester.attachedSplitShape ~ = nil then
                if self:getCanBeTurnedOn() then
                    self:setIsTurnedOn( true )
                end
            end
        end
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function WoodHarvester:onTurnedOff()
    local spec = self.spec_woodHarvester

    -- first open the cutter completely
    if spec.grabAnimation.name ~ = nil and spec.attachedSplitShape = = nil then
        self.playDelayedGrabAnimationTime = g_currentMission.time + 500
        if spec.grabAnimation.speedScale > 0 then
            self:setAnimationStopTime(spec.grabAnimation.name, 1 )
        else
                self:setAnimationStopTime(spec.grabAnimation.name, 0 )
            end
            self:playAnimation(spec.grabAnimation.name, spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), true )
        end

        if self.isClient then
            g_effectManager:stopEffects(spec.delimbEffects)
            g_effectManager:stopEffects(spec.cutEffects)
            g_soundManager:stopSamples(spec.samples)
            spec.isCutSamplePlaying = false
            spec.isDelimbSamplePlaying = false
        end
    end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function WoodHarvester:onTurnedOn()
    local spec = self.spec_woodHarvester
    self.playDelayedGrabAnimationTime = nil
    if spec.grabAnimation.name ~ = nil and spec.attachedSplitShape = = nil then
        if spec.grabAnimation.speedScale > 0 then
            self:setAnimationStopTime(spec.grabAnimation.name, 1 )
        else
                self:setAnimationStopTime(spec.grabAnimation.name, 0 )
            end
            self:playAnimation(spec.grabAnimation.name, spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), true )
        end

        self:setLastTreeDiameter( 0 )
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
function WoodHarvester:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_woodHarvester

    -- Verify that the split shapes still exist(possible that someone has cut them)
    if self.isServer then
        local lostShape = false
        if spec.attachedSplitShape ~ = nil then
            if not entityExists(spec.attachedSplitShape) then
                spec.attachedSplitShape = nil
                spec.attachedSplitShapeJointIndex = nil
                spec.isAttachedSplitShapeMoving = false
                spec.attachedSplitShapeMoveEffectActive = false
                spec.attachedSplitShapeDelimbEffectActive = false
                spec.cutTimer = - 1
                lostShape = true
            end
        elseif spec.curSplitShape ~ = nil then
                if not entityExists(spec.curSplitShape) then
                    spec.curSplitShape = nil
                    lostShape = true
                end
            end
            if lostShape then
                SpecializationUtil.raiseEvent( self , "onCutTree" , 0 , false , false )
                if g_server ~ = nil then
                    g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , 0 ), nil , nil , self )
                end
            end
        end

        if self.isServer and(spec.attachedSplitShape ~ = nil or spec.curSplitShape ~ = nil ) then
            if spec.cutTimer > 0 then
                if spec.cutAnimation.name ~ = nil then
                    if self:getAnimationTime(spec.cutAnimation.name) > spec.cutAnimation.cutTime then
                        spec.cutTimer = 0
                    end
                else
                        spec.cutTimer = math.max(spec.cutTimer - dt, 0 )
                    end
                end
                local readyToCut = spec.cutTimer = = 0

                -- cut
                if readyToCut then
                    spec.cutTimer = - 1

                    local x,y,z = getWorldTranslation(spec.cutNode)
                    local nx,ny,nz = localDirectionToWorld(spec.cutNode, 1 , 0 , 0 )
                    local yx,yy,yz = localDirectionToWorld(spec.cutNode, 0 , 1 , 0 )
                    local newTreeCut = false

                    local currentSplitShape
                    if spec.attachedSplitShapeJointIndex ~ = nil then
                        removeJoint(spec.attachedSplitShapeJointIndex)
                        spec.attachedSplitShapeJointIndex = nil
                        currentSplitShape = spec.attachedSplitShape
                        spec.attachedSplitShape = nil
                    else
                            currentSplitShape = spec.curSplitShape
                            spec.curSplitShape = nil
                            newTreeCut = true
                        end

                        -- remember split type name for later(achievement)
                            local splitTypeName = ""
                            local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(currentSplitShape))
                            if splitType ~ = nil then
                                splitTypeName = splitType.name
                            end

                            if spec.delimbOnCut then
                                local xD,yD,zD = getWorldTranslation(spec.delimbNode)
                                local nxD,nyD,nzD = localDirectionToWorld(spec.delimbNode, 1 , 0 , 0 )
                                local yxD,yyD,yzD = localDirectionToWorld(spec.delimbNode, 0 , 1 , 0 )
                                local vx,vy,vz = x - xD,y - yD,z - zD
                                local sizeX = MathUtil.vector3Length(vx,vy,vz)
                                removeSplitShapeAttachments(currentSplitShape, xD + vx * 0.5 ,yD + vy * 0.5 ,zD + vz * 0.5 , nxD,nyD,nzD, yxD,yyD,yzD, sizeX * 0.7 + spec.delimbSizeX, spec.delimbSizeY, spec.delimbSizeZ)
                            end

                            spec.attachedSplitShape = nil
                            spec.curSplitShape = nil
                            spec.prevSplitShape = currentSplitShape

                            -- if the tree is loaded from the savegame or we pick up a tree that is already cut, we just attach it
                                local doTreeCut = not spec.loadedSplitShapeFromSavegame
                                if getRigidBodyType(currentSplitShape) ~ = RigidBodyType.STATIC and newTreeCut then
                                    doTreeCut = false
                                end

                                if doTreeCut then
                                    g_currentMission:removeKnownSplitShape(currentSplitShape)
                                    self.shapeBeingCut = currentSplitShape
                                    self.shapeBeingCutIsTree = getRigidBodyType(currentSplitShape) = = RigidBodyType.STATIC
                                    self.shapeBeingCutIsNew = newTreeCut
                                    splitShape(currentSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ, "woodHarvesterSplitShapeCallback" , self )
                                    g_treePlantManager:removingSplitShape(currentSplitShape)
                                else
                                        local minY, maxY, minZ, maxZ
                                        local delimbOffset = 0
                                        if spec.lastTreeSize = = nil or not spec.loadedSplitShapeFromSavegame then
                                            minY, maxY, minZ, maxZ = testSplitShape(currentSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ)
                                            if minY ~ = nil then
                                                local lengthBelow, _ = getSplitShapePlaneExtents(currentSplitShape, x,y,z, nx,ny,nz)
                                                if lengthBelow ~ = nil and lengthBelow > 0.01 then
                                                    -- we move the bottom of the tree to the cutting blade, so it will have the exact set length while cutting
                                                        delimbOffset = - lengthBelow
                                                    end
                                                end
                                            else
                                                    minY, maxY, minZ, maxZ = spec.lastTreeSize[ 1 ], spec.lastTreeSize[ 2 ], spec.lastTreeSize[ 3 ], spec.lastTreeSize[ 4 ]
                                                end

                                                if minY ~ = nil then
                                                    self:woodHarvesterSplitShapeCallback(currentSplitShape, false , true , minY, maxY, minZ, maxZ)
                                                    g_messageCenter:publish(MessageType.TREE_SHAPE_MOUNTED, currentSplitShape, self )

                                                    if delimbOffset ~ = 0 then
                                                        spec.attachedSplitShapeTargetY = spec.attachedSplitShapeLastCutY + delimbOffset * spec.cutAttachDirection
                                                        spec.attachedSplitShapeOnlyMove = true
                                                        spec.attachedSplitShapeOnlyMoveDelay = 750 -- short delay to the tree has time to get into the grab
                                                        self:onDelimbTree( true )
                                                    end
                                                end
                                            end

                                            if spec.attachedSplitShape = = nil then
                                                SpecializationUtil.raiseEvent( self , "onCutTree" , 0 , false , false )
                                                if g_server ~ = nil then
                                                    g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , 0 ), nil , nil , self )
                                                end
                                            else
                                                    if spec.delimbOnCut then
                                                        local xD,yD,zD = getWorldTranslation(spec.delimbNode)
                                                        local nxD,nyD,nzD = localDirectionToWorld(spec.delimbNode, 1 , 0 , 0 )
                                                        local yxD,yyD,yzD = localDirectionToWorld(spec.delimbNode, 0 , 1 , 0 )
                                                        local vx,vy,vz = x - xD,y - yD,z - zD
                                                        local sizeX = MathUtil.vector3Length(vx,vy,vz)
                                                        removeSplitShapeAttachments(spec.attachedSplitShape, xD + vx * 3 ,yD + vy * 3 ,zD + vz * 3 , nxD,nyD,nzD, yxD,yyD,yzD, sizeX * 3 + spec.delimbSizeX, spec.delimbSizeY, spec.delimbSizeZ)
                                                    end
                                                end

                                                if doTreeCut and newTreeCut then
                                                    -- increase tree cut counter for achievements
                                                        local total, _ = g_farmManager:updateFarmStats( self:getActiveFarm(), "cutTreeCount" , 1 )

                                                        if total ~ = nil then
                                                            g_achievementManager:tryUnlock( "CutTreeFirst" , total)
                                                            g_achievementManager:tryUnlock( "CutTree" , total)
                                                        end

                                                        -- update the types of trees cut so far(achievement)
                                                        if splitTypeName ~ = "" then
                                                            local farm = g_farmManager:getFarmById( self:getActiveFarm())
                                                            if farm ~ = nil then
                                                                farm.stats:updateTreeTypesCut(splitTypeName)
                                                            end
                                                        end
                                                    end
                                                end

                                                spec.attachedSplitShapeMoveEffectActive = false
                                                spec.attachedSplitShapeDelimbEffectActive = false

                                                -- delimb
                                                if spec.attachedSplitShape ~ = nil and spec.isAttachedSplitShapeMoving then
                                                    if spec.delimbNode ~ = nil then
                                                        local x,y,z = getWorldTranslation(spec.delimbNode)
                                                        local nx,ny,nz = localDirectionToWorld(spec.delimbNode, 1 , 0 , 0 )
                                                        local yx,yy,yz = localDirectionToWorld(spec.delimbNode, 0 , 1 , 0 )

                                                        local didDelimb = removeSplitShapeAttachments(spec.attachedSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, spec.delimbSizeX, spec.delimbSizeY, spec.delimbSizeZ)
                                                        if didDelimb then
                                                            spec.attachedSplitShapeLastDelimbTime = g_ time
                                                        end

                                                        if g_ time - spec.attachedSplitShapeLastDelimbTime < 500 then
                                                            spec.attachedSplitShapeDelimbEffectActive = true
                                                        end
                                                    end

                                                    local updateSplitShapeJoint, updateJointSavePosition = false , false
                                                    if not spec.attachedSplitShapeOnlyMove then
                                                        if spec.cutNode ~ = nil and spec.attachedSplitShapeJointIndex ~ = nil then
                                                            local x,y,z = getWorldTranslation(spec.cutAttachReferenceNode)
                                                            local nx,ny,nz = localDirectionToWorld(spec.cutAttachReferenceNode, 0 , 1 , 0 )
                                                            local _, lengthRem = getSplitShapePlaneExtents(spec.attachedSplitShape, x,y,z, nx,ny,nz)

                                                            if lengthRem = = nil or lengthRem < = 0.1 then

                                                                -- end of tree
                                                                removeJoint(spec.attachedSplitShapeJointIndex)
                                                                spec.attachedSplitShapeJointIndex = nil
                                                                spec.attachedSplitShape = nil

                                                                self:onDelimbTree( false )
                                                                if g_server ~ = nil then
                                                                    g_server:broadcastEvent( WoodHarvesterOnDelimbTreeEvent.new( self , false ), nil , nil , self )
                                                                end

                                                                SpecializationUtil.raiseEvent( self , "onCutTree" , 0 , false , false )
                                                                if g_server ~ = nil then
                                                                    g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , 0 ), nil , nil , self )
                                                                end
                                                            else
                                                                    local dir = spec.attachedSplitShapeTargetY > spec.attachedSplitShapeY and 1 or - 1
                                                                    local limit = spec.attachedSplitShapeTargetY > spec.attachedSplitShapeY and math.min or math.max
                                                                    spec.attachedSplitShapeY = limit(spec.attachedSplitShapeY + spec.cutAttachMoveSpeed * dt * dir, spec.attachedSplitShapeTargetY)
                                                                    if spec.attachedSplitShapeY = = spec.attachedSplitShapeTargetY then
                                                                        self:onDelimbTree( false )
                                                                        if g_server ~ = nil then
                                                                            g_server:broadcastEvent( WoodHarvesterOnDelimbTreeEvent.new( self , false ), nil , nil , self )
                                                                        end
                                                                    end

                                                                    updateSplitShapeJoint = true
                                                                end
                                                            end
                                                        else
                                                                if spec.attachedSplitShapeOnlyMoveDelay < = 0 then
                                                                    local dir = spec.attachedSplitShapeTargetY > spec.attachedSplitShapeY and 1 or - 1
                                                                    local limit = spec.attachedSplitShapeTargetY > spec.attachedSplitShapeY and math.min or math.max
                                                                    spec.attachedSplitShapeY = limit(spec.attachedSplitShapeY + spec.cutAttachMoveSpeed * dt * dir, spec.attachedSplitShapeTargetY)
                                                                    if spec.attachedSplitShapeY = = spec.attachedSplitShapeTargetY then
                                                                        spec.isAttachedSplitShapeMoving = false
                                                                        spec.attachedSplitShapeOnlyMove = false
                                                                        spec.attachedSplitShapeLastCutY = spec.attachedSplitShapeY
                                                                    end
                                                                    updateSplitShapeJoint = true
                                                                    updateJointSavePosition = true
                                                                else
                                                                        spec.attachedSplitShapeOnlyMoveDelay = spec.attachedSplitShapeOnlyMoveDelay - dt
                                                                    end
                                                                end

                                                                if updateSplitShapeJoint then
                                                                    if spec.attachedSplitShapeJointIndex ~ = nil then
                                                                        local x,y,z = localToWorld(spec.cutNode, 0.3 , 0 , 0 )
                                                                        local nx,ny,nz = localDirectionToWorld(spec.cutNode, 1 , 0 , 0 )
                                                                        local yx,yy,yz = localDirectionToWorld(spec.cutNode, 0 , 1 , 0 )
                                                                        local shape, minY, maxY, minZ, maxZ = findSplitShape(x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ)
                                                                        if shape = = spec.attachedSplitShape then
                                                                            local treeCenterX,treeCenterY,treeCenterZ = localToWorld(spec.cutNode, 0 , (minY + maxY) * 0.5 , (minZ + maxZ) * 0.5 )
                                                                            local _
                                                                            spec.attachedSplitShapeX, _, spec.attachedSplitShapeZ = worldToLocal(spec.attachedSplitShape, treeCenterX,treeCenterY,treeCenterZ)
                                                                            self:setLastTreeDiameter((maxY - minY + maxZ - minZ) * 0.5 )
                                                                        end
                                                                        x,y,z = localToWorld(spec.attachedSplitShape, spec.attachedSplitShapeX, spec.attachedSplitShapeY, spec.attachedSplitShapeZ)
                                                                        setJointPosition(spec.attachedSplitShapeJointIndex, 1 , x,y,z)

                                                                        if updateJointSavePosition then
                                                                            spec.lastTreeJointPos[ 1 ] = spec.attachedSplitShapeX
                                                                            spec.lastTreeJointPos[ 2 ] = spec.attachedSplitShapeY
                                                                            spec.lastTreeJointPos[ 3 ] = spec.attachedSplitShapeZ
                                                                        end
                                                                    end
                                                                end

                                                                spec.attachedSplitShapeMoveEffectActive = updateSplitShapeJoint
                                                            end
                                                        end

                                                        -- effect and sound for cut and delimb
                                                            if self.isClient then
                                                                -- cut
                                                                if spec.cutAnimation.name ~ = nil then
                                                                    if self:getIsAnimationPlaying(spec.cutAnimation.name) and self:getAnimationTime(spec.cutAnimation.name) < spec.cutAnimation.cutTime then
                                                                        if not spec.isCutSamplePlaying then
                                                                            g_soundManager:playSample(spec.samples.cut)
                                                                            spec.isCutSamplePlaying = true
                                                                        end
                                                                        g_effectManager:setEffectTypeInfo(spec.cutEffects, FillType.WOODCHIPS)
                                                                        g_effectManager:startEffects(spec.cutEffects)
                                                                    else
                                                                            if spec.isCutSamplePlaying then
                                                                                g_soundManager:stopSample(spec.samples.cut)
                                                                                spec.isCutSamplePlaying = false
                                                                            end
                                                                            g_effectManager:stopEffects(spec.cutEffects)
                                                                        end
                                                                    end

                                                                    -- delimb
                                                                    if spec.attachedSplitShapeMoveEffectActive then
                                                                        if not spec.isDelimbSamplePlaying then
                                                                            g_soundManager:playSample(spec.samples.delimb)
                                                                            spec.isDelimbSamplePlaying = true
                                                                        end
                                                                        g_effectManager:setEffectTypeInfo(spec.delimbEffects, FillType.WOODCHIPS)
                                                                        g_effectManager:startEffects(spec.delimbEffects)
                                                                        g_effectManager:setDensity(spec.delimbEffects, spec.attachedSplitShapeDelimbEffectActive and 1 or 0.1 )
                                                                        g_animationManager:startAnimations(spec.forwardingNodes)
                                                                    else
                                                                            if spec.isDelimbSamplePlaying then
                                                                                g_soundManager:stopSample(spec.samples.delimb)
                                                                                spec.isDelimbSamplePlaying = false
                                                                            end
                                                                            g_effectManager:stopEffects(spec.delimbEffects)
                                                                            g_animationManager:stopAnimations(spec.forwardingNodes)
                                                                        end
                                                                    end

                                                                    --#debug DebugUtil.drawCutNodeArea(spec.cutNode, spec.cutSizeY, spec.cutSizeZ, 1, 0, 0)
                                                                    --#debug DebugUtil.drawCutNodeArea(spec.delimbNode, spec.delimbSizeY, spec.delimbSizeZ, 0, 0, 1)
                                                                    --#debug local x1, y1, z1 = getWorldTranslation(spec.cutAttachReferenceNode)
                                                                    --#debug local x2, y2, z2 = localToWorld(spec.cutAttachReferenceNode, 0, 2.5, 0)
                                                                    --#debug drawDebugLine(x1, y1, z1, 1, 0, 0, x2, y2, z2, 0, 0, 1, true)
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
function WoodHarvester:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_woodHarvester

    spec.warnInvalidTree = false
    spec.warnInvalidTreeRadius = false
    spec.warnInvalidTreePosition = false
    spec.warnTreeNotOwned = false

    if self:getIsTurnedOn() then
        if spec.attachedSplitShape = = nil and spec.cutNode ~ = nil then
            local x,y,z = getWorldTranslation(spec.cutNode)
            local nx,ny,nz = localDirectionToWorld(spec.cutNode, 1 , 0 , 0 )
            local yx,yy,yz = localDirectionToWorld(spec.cutNode, 0 , 1 , 0 )

            self:findSplitShapesInRange()

            if spec.curSplitShape ~ = nil then
                if entityExists(spec.curSplitShape) then
                    local minY,maxY, minZ,maxZ = testSplitShape(spec.curSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, spec.cutSizeY, spec.cutSizeZ)
                    if minY = = nil then
                        spec.curSplitShape = nil
                    else
                            -- check if cut would be below y = 0(tree CoSy)
                                local cutTooLow = false
                                local _
                                _,y,_ = localToLocal(spec.cutNode, spec.curSplitShape, 0 ,minY,minZ)
                                cutTooLow = cutTooLow or y < 0.01
                                _,y,_ = localToLocal(spec.cutNode, spec.curSplitShape, 0 ,minY,maxZ)
                                cutTooLow = cutTooLow or y < 0.01
                                _,y,_ = localToLocal(spec.cutNode, spec.curSplitShape, 0 ,maxY,minZ)
                                cutTooLow = cutTooLow or y < 0.01
                                _,y,_ = localToLocal(spec.cutNode, spec.curSplitShape, 0 ,maxY,maxZ)
                                cutTooLow = cutTooLow or y < 0.01
                                if cutTooLow then
                                    spec.curSplitShape = nil
                                end
                            end
                        else
                                spec.curSplitShape = nil
                            end
                        end

                        if spec.curSplitShape = = nil and spec.cutTimer > - 1 then
                            SpecializationUtil.raiseEvent( self , "onCutTree" , 0 , false , false )
                            if g_server ~ = nil then
                                g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , 0 ), nil , nil , self )
                            end
                        end

                    end
                end

                if self.isServer then
                    if spec.attachedSplitShape = = nil then
                        if spec.cutReleasedComponentJoint ~ = nil and spec.cutReleasedComponentJointRotLimitX ~ = 0 then
                            spec.cutReleasedComponentJointRotLimitX = math.max( 0 , spec.cutReleasedComponentJointRotLimitX - spec.cutReleasedComponentJointRotLimitXSpeed * dt)
                            setJointRotationLimit(spec.cutReleasedComponentJoint.jointIndex, 0 , true , 0 , spec.cutReleasedComponentJointRotLimitX)
                        end
                        if spec.cutReleasedComponentJoint2 ~ = nil and spec.cutReleasedComponentJoint2RotLimitX ~ = 0 then
                            spec.cutReleasedComponentJoint2RotLimitX = math.max(spec.cutReleasedComponentJoint2RotLimitX - spec.cutReleasedComponentJoint2RotLimitXSpeed * dt, 0 )
                            setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0 , true , - spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
                        end
                    end
                end

                if self.isServer then
                    if self.playDelayedGrabAnimationTime ~ = nil then
                        if self.playDelayedGrabAnimationTime < g_currentMission.time then
                            self.playDelayedGrabAnimationTime = nil
                            if self:getAnimationTime(spec.grabAnimation.name) > 0 then
                                if spec.grabAnimation.name ~ = nil and spec.attachedSplitShape = = nil then
                                    if spec.grabAnimation.speedScale > 0 then
                                        self:setAnimationStopTime(spec.grabAnimation.name, 0 )
                                    else
                                            self:setAnimationStopTime(spec.grabAnimation.name, 1 )
                                        end
                                        self:playAnimation(spec.grabAnimation.name, - spec.grabAnimation.speedScale, self:getAnimationTime(spec.grabAnimation.name), false )
                                    end
                                end
                            end
                        end
                    end

                    if self.isClient then
                        local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA2]
                        if actionEvent ~ = nil then
                            local showAction = false
                            if spec.hasAttachedSplitShape then
                                if not spec.isAttachedSplitShapeMoving and self:getAnimationTime(spec.cutAnimation.name) = = 1 then
                                    showAction = true
                                end
                            elseif spec.curSplitShape ~ = nil then
                                    showAction = true
                                end

                                g_inputBinding:setActionEventActive(actionEvent.actionEventId, showAction)

                                local dropActionEvent = spec.actionEvents[InputAction.WOOD_HARVESTER_DROP]
                                if dropActionEvent ~ = nil then
                                    g_inputBinding:setActionEventActive(dropActionEvent.actionEventId, showAction)
                                end
                            end

                            actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
                            if actionEvent ~ = nil then
                                g_inputBinding:setActionEventActive(actionEvent.actionEventId, not spec.isAttachedSplitShapeMoving)
                                if not spec.isAttachedSplitShapeMoving then
                                    local lengthStr = string.format( "%.1f%s" , spec.currentCutLength, spec.texts.unitMeterShort)
                                    if spec.currentCutLength = = math.huge then
                                        lengthStr = spec.texts.uiMax
                                    end

                                    g_inputBinding:setActionEventText(actionEvent.actionEventId, string.format(spec.texts.actionChangeCutLength, lengthStr))
                                end
                            end
                        end
                    end

```

### onVehicleSettingChanged

**Description**

> Called when vehicle settings change

**Definition**

> onVehicleSettingChanged()

**Arguments**

| any | gameSettingId |
|-----|---------------|
| any | state         |

**Code**

```lua
function WoodHarvester:onVehicleSettingChanged(gameSettingId, state)
    if gameSettingId = = GameSettings.SETTING.WOOD_HARVESTER_AUTO_CUT then
        self.spec_woodHarvester.automaticCuttingEnabled = state
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
function WoodHarvester:onWriteStream(streamId, connection)
    local spec = self.spec_woodHarvester
    if streamWriteBool(streamId, spec.hasAttachedSplitShape) then
        local animTime = self:getAnimationTime(spec.grabAnimation.name)
        streamWriteUIntN(streamId, animTime * 127 , 7 )
    end

    streamWriteBool(streamId, spec.isAttachedSplitShapeMoving)

    streamWriteUIntN(streamId, spec.currentCutLengthIndex, WoodHarvester.NUM_BITS_CUT_LENGTH)
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
function WoodHarvester:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_woodHarvester
        if streamWriteBool(streamId, spec.attachedSplitShapeMoveEffectActive) then
            streamWriteBool(streamId, spec.attachedSplitShapeDelimbEffectActive)
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
function WoodHarvester.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
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
function WoodHarvester.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onCutTree" , WoodHarvester )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleSettingChanged" , WoodHarvester )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function WoodHarvester.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onCutTree" )
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
function WoodHarvester.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "woodHarvesterSplitShapeCallback" , WoodHarvester.woodHarvesterSplitShapeCallback)
    SpecializationUtil.registerFunction(vehicleType, "setLastTreeDiameter" , WoodHarvester.setLastTreeDiameter)
    SpecializationUtil.registerFunction(vehicleType, "findSplitShapesInRange" , WoodHarvester.findSplitShapesInRange)
    SpecializationUtil.registerFunction(vehicleType, "cutTree" , WoodHarvester.cutTree)
    SpecializationUtil.registerFunction(vehicleType, "onDelimbTree" , WoodHarvester.onDelimbTree)
    SpecializationUtil.registerFunction(vehicleType, "getCanSplitShapeBeAccessed" , WoodHarvester.getCanSplitShapeBeAccessed)
    SpecializationUtil.registerFunction(vehicleType, "loadWoodHarvesterHeaderTiltFromXML" , WoodHarvester.loadWoodHarvesterHeaderTiltFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsWoodHarvesterTiltStateAllowed" , WoodHarvester.getIsWoodHarvesterTiltStateAllowed)
    SpecializationUtil.registerFunction(vehicleType, "setWoodHarvesterTiltState" , WoodHarvester.setWoodHarvesterTiltState)
    SpecializationUtil.registerFunction(vehicleType, "setWoodHarvesterCutLengthIndex" , WoodHarvester.setWoodHarvesterCutLengthIndex)
    SpecializationUtil.registerFunction(vehicleType, "dropWoodHarvesterTree" , WoodHarvester.dropWoodHarvesterTree)
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
function WoodHarvester.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , WoodHarvester.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , WoodHarvester.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , WoodHarvester.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , WoodHarvester.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSupportsAutoTreeAlignment" , WoodHarvester.getSupportsAutoTreeAlignment)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAutoTreeAlignmentAllowed" , WoodHarvester.getIsAutoTreeAlignmentAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAutoAlignHasValidTree" , WoodHarvester.getAutoAlignHasValidTree)
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
function WoodHarvester:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_woodHarvester

    xmlFile:setValue(key .. "#currentCutLengthIndex" , spec.currentCutLengthIndex)

    xmlFile:setValue(key .. "#isTurnedOn" , self:getIsTurnedOn() or spec.hasAttachedSplitShape)
    xmlFile:setValue(key .. "#hasAttachedSplitShape" , spec.hasAttachedSplitShape)
    xmlFile:setValue(key .. "#lastCutAttachDirection" , spec.lastCutAttachDirection)

    if spec.hasAttachedSplitShape then
        if spec.lastTreeSize ~ = nil then
            xmlFile:setValue(key .. "#lastTreeSize" , unpack(spec.lastTreeSize))
        end
        if spec.lastTreeJointPos ~ = nil then
            xmlFile:setValue(key .. "#lastTreeJointPos" , unpack(spec.lastTreeJointPos))
        end
    end
end

```

### setLastTreeDiameter

**Description**

**Definition**

> setLastTreeDiameter()

**Arguments**

| any | diameter |
|-----|----------|

**Code**

```lua
function WoodHarvester:setLastTreeDiameter(diameter)
    local spec = self.spec_woodHarvester
    spec.lastDiameter = diameter
end

```

### setWoodHarvesterCutLengthIndex

**Description**

**Definition**

> setWoodHarvesterCutLengthIndex()

**Arguments**

| any | index       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function WoodHarvester:setWoodHarvesterCutLengthIndex(index, noEventSend)
    local spec = self.spec_woodHarvester
    if index ~ = spec.currentCutLengthIndex then
        spec.currentCutLengthIndex = index
        spec.currentCutLength = spec.cutLengths[spec.currentCutLengthIndex] or 1
    end

    WoodHarvesterCutLengthEvent.sendEvent( self , index, noEventSend)
end

```

### setWoodHarvesterTiltState

**Description**

**Definition**

> setWoodHarvesterTiltState()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function WoodHarvester:setWoodHarvesterTiltState(state, noEventSend)
    local spec = self.spec_woodHarvester
    if state = = nil then
        state = not spec.headerJointTilt.state
    end

    if state ~ = spec.headerJointTilt.state then
        spec.headerJointTilt.state = state

        self:playAnimation(spec.headerJointTilt.animationName, state and 1 or - 1 , self:getAnimationTime(spec.headerJointTilt.animationName), true )
    end

    WoodHarvesterHeaderTiltEvent.sendEvent( self , state, noEventSend)
end

```

### woodHarvesterSplitShapeCallback

**Description**

**Definition**

> woodHarvesterSplitShapeCallback()

**Arguments**

| any | shape   |
|-----|---------|
| any | isBelow |
| any | isAbove |
| any | minY    |
| any | maxY    |
| any | minZ    |
| any | maxZ    |

**Code**

```lua
function WoodHarvester:woodHarvesterSplitShapeCallback(shape, isBelow, isAbove, minY, maxY, minZ, maxZ)
    local spec = self.spec_woodHarvester

    g_currentMission:addKnownSplitShape(shape)
    g_treePlantManager:addingSplitShape(shape, self.shapeBeingCut, self.shapeBeingCutIsTree)

    if spec.attachedSplitShape = = nil and isAbove and not isBelow and spec.cutAttachNode ~ = nil and spec.cutAttachReferenceNode ~ = nil then
        spec.attachedSplitShape = shape
        spec.lastTreeSize = { minY, maxY, minZ, maxZ }

        -- Current tree center(mid of cut area)
        local treeCenterX, treeCenterY, treeCenterZ = localToWorld(spec.cutNode, 0 , (minY + maxY) * 0.5 , (minZ + maxZ) * 0.5 )

        local cutAttachDirection
        local loadedSplitShapeFromSavegame = spec.loadedSplitShapeFromSavegame
        if loadedSplitShapeFromSavegame then
            if spec.lastTreeJointPos ~ = nil then
                treeCenterX, treeCenterY, treeCenterZ = localToWorld(shape, unpack(spec.lastTreeJointPos))
                cutAttachDirection = spec.lastCutAttachDirection
            end

            spec.loadedSplitShapeFromSavegame = false
        end
        spec.lastTreeJointPos = { worldToLocal(shape, treeCenterX, treeCenterY, treeCenterZ) }

        -- Target tree center(half tree size in front of the reference node)
        local x,y,z = localToWorld(spec.cutAttachReferenceNode, 0 , 0 , (maxZ - minZ) * 0.5 )

        local dx,dy,dz = localDirectionToWorld(shape, 0 , 0 , 1 )

        local _, treeYDirection, _ = localDirectionToLocal(shape, spec.cutAttachReferenceNode, 0 , 1 , 0 )
        spec.cutAttachDirection = cutAttachDirection or(treeYDirection > 0 and 1 or - 1 )
        spec.lastCutAttachDirection = spec.cutAttachDirection

        local upx,upy,upz = localDirectionToWorld(spec.cutAttachReferenceNode, 0 , spec.cutAttachDirection, 0 )
        local sideX,sideY,sizeZ = MathUtil.crossProduct(upx,upy,upz, dx,dy,dz)
        dx,dy,dz = MathUtil.crossProduct(sideX,sideY,sizeZ, upx,upy,upz) -- Note:we want the up axis to be exact, thus orthogonalize the direction here
        I3DUtil.setWorldDirection(spec.cutAttachHelperNode, dx,dy,dz, upx,upy,upz, 2 )

        local constr = JointConstructor.new()
        constr:setActors(spec.cutAttachNode, shape)
        -- Note:we assume that the direction of the tree is equal to the y axis
        constr:setJointTransforms(spec.cutAttachHelperNode, shape)
        constr:setJointWorldPositions(x,y,z, treeCenterX,treeCenterY,treeCenterZ)

        constr:setRotationLimit( 0 , 0 , 0 )
        constr:setRotationLimit( 1 , 0 , 0 )
        constr:setRotationLimit( 2 , 0 , 0 )

        constr:setEnableCollision( false )

        spec.attachedSplitShapeJointIndex = constr:finalize()

        if spec.cutReleasedComponentJoint ~ = nil then
            spec.cutReleasedComponentJointRotLimitX = math.pi * 0.9
            if spec.cutReleasedComponentJoint.jointIndex ~ = 0 then
                setJointRotationLimit(spec.cutReleasedComponentJoint.jointIndex, 0 , true , 0 , spec.cutReleasedComponentJointRotLimitX)
            end
        end
        if spec.cutReleasedComponentJoint2 ~ = nil then
            spec.cutReleasedComponentJoint2RotLimitX = math.pi * 0.9
            if spec.cutReleasedComponentJoint2.jointIndex ~ = 0 then
                setJointRotationLimit(spec.cutReleasedComponentJoint2.jointIndex, 0 , true , - spec.cutReleasedComponentJoint2RotLimitX, spec.cutReleasedComponentJoint2RotLimitX)
            end
        end

        if spec.headerJointTilt ~ = nil and spec.headerJointTilt.state and spec.headerJointTilt.lastState = = nil then
            spec.headerJointTilt.lastState = spec.headerJointTilt.state
            self:setWoodHarvesterTiltState( false )
        end

        spec.attachedSplitShapeX, spec.attachedSplitShapeY, spec.attachedSplitShapeZ = worldToLocal(shape, treeCenterX,treeCenterY,treeCenterZ)
        spec.attachedSplitShapeLastCutY = spec.attachedSplitShapeY
        spec.attachedSplitShapeStartY = spec.attachedSplitShapeY
        spec.attachedSplitShapeTargetY = spec.attachedSplitShapeY

        local radius = ((maxY - minY) + (maxZ - minZ)) / 4
        SpecializationUtil.raiseEvent( self , "onCutTree" , radius, self.shapeBeingCutIsNew, loadedSplitShapeFromSavegame)
        if g_server ~ = nil then
            g_server:broadcastEvent( WoodHarvesterOnCutTreeEvent.new( self , radius), nil , nil , self )
        end
    end
end

```