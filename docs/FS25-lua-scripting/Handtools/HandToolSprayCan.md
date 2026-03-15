## HandToolSprayCan

**Functions**

- [activateSpraying](#activatespraying)
- [changeTreeMarkerType](#changetreemarkertype)
- [getIsSprayingAllowed](#getissprayingallowed)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onHeldStart](#onheldstart)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processDelayedMarker](#processdelayedmarker)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setIsSpraying](#setisspraying)
- [tryToAddTreeMarker](#trytoaddtreemarker)

### activateSpraying

**Description**

**Definition**

> activateSpraying()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolSprayCan:activateSpraying(_, inputValue)
    local spec = self.spec_sprayCan
    spec.activatePressed = inputValue ~ = 0
end

```

### changeTreeMarkerType

**Description**

**Definition**

> changeTreeMarkerType()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolSprayCan:changeTreeMarkerType(_, inputValue)
    local spec = self.spec_sprayCan
    local mission = g_currentMission
    local treeMarkerSystem = mission.treeMarkerSystem
    spec.treeMarkerTypeIndex = spec.treeMarkerTypeIndex + 1
    if spec.treeMarkerTypeIndex > treeMarkerSystem:getNumOfTreeMarkerTypes() then
        spec.treeMarkerTypeIndex = 1
    end

    spec.treeMarkerType = treeMarkerSystem:getTreeMarkerTypeByIndex(spec.treeMarkerTypeIndex)

    if spec.treeTypeCrosshair ~ = nil then
        spec.treeTypeCrosshair:delete()
    end

    spec.treeTypeCrosshair = self:createCrosshairOverlayFromFile(spec.treeMarkerType.iconFilename, HandTool.DEFAULT_CROSSHAIR_SIZE_PIXELS * 2 )
end

```

### getIsSprayingAllowed

**Description**

**Definition**

> getIsSprayingAllowed()

**Arguments**

| any | shape |
|-----|-------|

**Code**

```lua
function HandToolSprayCan:getIsSprayingAllowed(shape)
    if shape = = nil or shape = = 0 then
        return true
    end

    local x, _, z = getWorldTranslation(shape)
    local mission = g_currentMission
    if mission.accessHandler:canFarmAccessLand(g_localPlayer.farmId, x, z) then
        return true
    end

    return false
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolSprayCan:onDelete()
    local spec = self.spec_sprayCan

    self:processDelayedMarker()

    if spec.effects ~ = nil then
        g_effectManager:deleteEffects(spec.effects)
    end

    if spec.sprayingSample ~ = nil then
        g_soundManager:deleteSample(spec.sprayingSample)
    end

    if spec.treeCrosshair ~ = nil then
        spec.treeCrosshair:delete()
        spec.treeCrosshair = nil
    end

    if spec.treeTypeCrosshair ~ = nil then
        spec.treeTypeCrosshair:delete()
        spec.treeTypeCrosshair = nil
    end
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function HandToolSprayCan:onDraw()
    local spec = self.spec_sprayCan

    if spec.treeMarkerType = = nil then
        return
    end

    if spec.remainingNumMarkers = = 0 then
        return
    end

    if spec.treeTypeCrosshair ~ = nil then
        spec.treeTypeCrosshair:render()
    end

    if spec.foundTargetTree ~ = nil then
        spec.treeCrosshair:render()
    end
end

```

### onHeldStart

**Description**

**Definition**

> onHeldStart()

**Code**

```lua
function HandToolSprayCan:onHeldStart()

    if not self:getCarryingPlayer().isOwner then
        return
    end

    local spec = self.spec_sprayCan

    -- Ensure objects are targeted.
    local targeter = self:getCarryingPlayer().targeter
    targeter:addTargetType( HandToolSprayCan , CollisionFlag.TREE, 0.5 , spec.sprayDetectionDistance)
    targeter:addFilterToTargetType( HandToolSprayCan , function (hitNode, x, y, z)
        return getHasClassId(hitNode, ClassIds.MESH_SPLIT_SHAPE)
    end )
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | xmlFile |
|-----|---------|

**Code**

```lua
function HandToolSprayCan:onLoad(xmlFile)
    local spec = self.spec_sprayCan

    spec.maxTotalNumMarkers = 255
    spec.totalNumMarkers = xmlFile:getValue( "handTool.sprayCan#totalNumMarkers" , 50 )
    if spec.totalNumMarkers > spec.maxTotalNumMarkers or spec.totalNumMarkers < 1 then
        spec.totalNumMarkers = spec.maxTotalNumMarkers
        Logging.xmlWarning(xmlFile, "Invalid totalNumMarkers value.Valid range is 1-%d" , spec.maxTotalNumMarkers)
    end
    spec.remainingNumMarkers = spec.totalNumMarkers

    local color = xmlFile:getValue( "handTool.sprayCan#color" , { 1 , 1 , 1 , 1 } , true )
    spec.sprayColor = color
    spec.sprayDetectionDistance = xmlFile:getValue( "handTool.sprayCan#distance" , 1.5 )

    spec.sprayDelay = xmlFile:getValue( "handTool.sprayCan#delay" , 0 ) * 1000
    spec.sprayDuration = 500
    spec.sprayStopTime = 0

    local colorMaterialSlotName = xmlFile:getValue( "handTool.sprayCan#colorMaterialSlotName" )
    if colorMaterialSlotName ~ = nil then
        I3DUtil.setMaterialSlotShaderParameterRec( self.rootNode, colorMaterialSlotName, "colorScale" , color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ])
    end

    local shakeNode = xmlFile:getValue( "handTool.sprayCan#shakeNode" , self.rootNode, self.components, self.i3dMappings)
    spec.canNode = shakeNode
    spec.originalPos = { getTranslation(shakeNode) }

    if self.isClient then
        spec.effects = g_effectManager:loadEffect(xmlFile, "handTool.sprayCan.effects" , self.components, self , self.i3dMappings)
        g_effectManager:setEffectTypeInfo(spec.effects, FillType.WATER)
        for _, effect in ipairs(spec.effects) do
            if effect.setColor ~ = nil then
                effect:setColor(color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ])
            end
        end
    end

    spec.sprayingSample = g_soundManager:loadSampleFromXML(xmlFile, "handTool.sprayCan.sounds" , "spraying" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

    spec.foundTreeShape = nil
    spec.foundTreeHitPosition = { 0 , 0 , 0 }
    spec.treeMarkerTypeIndex = 1

    if g_iconGenerator = = nil then
        local mission = g_currentMission
        local treeMarkerSystem = mission.treeMarkerSystem
        spec.treeMarkerType = treeMarkerSystem:getTreeMarkerTypeByIndex(spec.treeMarkerTypeIndex)

        if spec.treeMarkerType = = nil then
            spec.treeMarkerTypeIndex = 1
            spec.treeMarkerType = treeMarkerSystem:getTreeMarkerTypeByIndex(spec.treeMarkerTypeIndex)
        end
    end

    spec.treeCrosshair = self:createCrosshairOverlayFromFile( "data/shared/treeMarker/markerTree_icon.png" , HandTool.DEFAULT_CROSSHAIR_SIZE_PIXELS * 2 )

    if spec.treeMarkerType ~ = nil then
        spec.treeTypeCrosshair = self:createCrosshairOverlayFromFile(spec.treeMarkerType.iconFilename, HandTool.DEFAULT_CROSSHAIR_SIZE_PIXELS * 2 )
    end

    spec.wasActivatePressed = false
    spec.isSpraying = false
    spec.numShakes = 3
    spec.shakeDuration = 200
    spec.shakeEndTime = 0
    spec.delayedMarker = nil

    spec.dirtyFlag = self:getNextDirtyFlag()

    return true
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
function HandToolSprayCan:onPostLoad(savegame)
    if savegame ~ = nil then
        local key = savegame.key .. ".sprayCan"
        if savegame.xmlFile:hasProperty(key) then
            local spec = self.spec_sprayCan
            spec.remainingNumMarkers = math.clamp(savegame.xmlFile:getValue(key .. "#remainingNumMarkers" , spec.remainingNumMarkers), 1 , spec.maxTotalNumMarkers)
        end
    end
end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId       |
|-----|----------------|
| any | connection     |
| any | carryingPlayer |

**Code**

```lua
function HandToolSprayCan:onReadStream(streamId, connection, carryingPlayer)
    if connection:getIsServer() then
        local spec = self.spec_sprayCan
        spec.remainingNumMarkers = streamReadUInt8(streamId)
    end
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId       |
|-----|----------------|
| any | timestamp      |
| any | connection     |
| any | carryingPlayer |

**Code**

```lua
function HandToolSprayCan:onReadUpdateStream(streamId, timestamp, connection, carryingPlayer)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local spec = self.spec_sprayCan
            spec.remainingNumMarkers = streamReadUInt8(streamId)
        end
    end
end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Code**

```lua
function HandToolSprayCan:onRegisterActionEvents()
    if not self:getIsActiveForInput( true ) then
        return
    end

    local _, actionEventId = self:addActionEvent(InputAction.SPRAYCAN_CHANGE_MARKER, self , self.changeTreeMarkerType, false , true , false , true , nil )
    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_changeTreeMarkerType" ))

    _, actionEventId = self:addActionEvent(InputAction.ACTIVATE_HANDTOOL, self , self.activateSpraying, true , true , true , true , nil )
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_sprayTreeMarker" ))
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolSprayCan:onUpdate(dt)
    local spec = self.spec_sprayCan

    local player = self:getCarryingPlayer()
    local allowInput = player ~ = nil and player.isOwner or false

    if allowInput then
        local targetTree = player.targeter.closestTargetsByKey[ HandToolSprayCan ]
        spec.foundTargetTree = targetTree

        if spec.activatePressed then
            if not spec.wasActivatePressed and not spec.isSpraying then
                local mission = g_currentMission
                if spec.remainingNumMarkers > 0 then
                    local x, y, z, _, _, _ = player:getLookRay()
                    local treeMarkerTypeIndex = spec.treeMarkerTypeIndex
                    local shape = nil
                    local hitX, hitY, hitZ = nil , nil , nil

                    if targetTree ~ = nil then
                        shape = targetTree.node
                        hitX, hitY, hitZ = targetTree.x, targetTree.y, targetTree.z
                    end

                    if self:getIsSprayingAllowed(shape) then
                        g_client:getServerConnection():sendEvent(SprayCanEvent.new( self , treeMarkerTypeIndex, shape, x, y, z, hitX, hitY, hitZ))
                    else
                            mission:showBlinkingWarning(g_i18n:getText( "warning_youAreNotAllowedToMarkThisTree" , self.customEnvironment), 2000 )
                        end
                    else
                            mission:showBlinkingWarning(g_i18n:getText( "warning_sprayCanIsEmpty" , self.customEnvironment), 2000 )
                        end

                        spec.wasActivatePressed = true
                    end
                end
            end

            if spec.delayedMarker ~ = nil and spec.delayedMarker.time < = g_ time then
                self:processDelayedMarker()
            end

            if spec.isSpraying then
                if allowInput then
                    local x, y, z = spec.originalPos[ 1 ], spec.originalPos[ 2 ], spec.originalPos[ 3 ]
                    local timeLeft = math.max( 0 , spec.shakeEndTime - g_ time )
                    local factor = 1 - (timeLeft / spec.shakeDuration)
                    local animValue = MathUtil.lerp( 0 , spec.numShakes, factor)

                    x = x + math.sin(animValue * math.pi) * 0.01
                    y = y + math.sin(animValue * math.pi) * 0.05
                    z = z + math.sin(animValue * math.pi) * 0.01
                    setTranslation(spec.canNode, x, y, z)
                end

                if g_ time > spec.sprayStopTime then
                    self:setIsSpraying( false , false )
                end
            end

            if not spec.activatePressed then
                spec.wasActivatePressed = false
            end

            spec.activatePressed = false
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
| any | dirtyMask  |

**Code**

```lua
function HandToolSprayCan:onWriteStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_sprayCan
        streamWriteUInt8(streamId, spec.remainingNumMarkers)
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
function HandToolSprayCan:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_sprayCan

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteUInt8(streamId, spec.remainingNumMarkers)
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
function HandToolSprayCan.prerequisitesPresent(specializations)
    return true
end

```

### processDelayedMarker

**Description**

**Definition**

> processDelayedMarker()

**Code**

```lua
function HandToolSprayCan:processDelayedMarker()
    local spec = self.spec_sprayCan

    if spec.delayedMarker ~ = nil then
        local splitShapeId = spec.delayedMarker.splitShapeId
        local treeMarkerTypeIndex = spec.delayedMarker.treeMarkerTypeIndex
        local x = spec.delayedMarker.x
        local y = spec.delayedMarker.y
        local z = spec.delayedMarker.z
        local hitX = spec.delayedMarker.hitX
        local hitY = spec.delayedMarker.hitY
        local hitZ = spec.delayedMarker.hitZ

        if entityExists(splitShapeId) then
            local r, g, b, a = spec.sprayColor[ 1 ], spec.sprayColor[ 2 ], spec.sprayColor[ 3 ], spec.sprayColor[ 4 ]
            local mission = g_currentMission
            local treeMarkerSystem = mission.treeMarkerSystem
            treeMarkerSystem:addTreeMarkerCameraBased(splitShapeId, treeMarkerTypeIndex, r, g, b, a, x, y, z, hitX, hitY, hitZ, true )
        end

        spec.delayedMarker = nil
    end
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolSprayCan.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onPostLoad" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onUpdate" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onDraw" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onWriteStream" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onReadStream" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onWriteUpdateStream" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onReadUpdateStream" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onRegisterActionEvents" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onHeldStart" , HandToolSprayCan )
    SpecializationUtil.registerEventListener(handToolType, "onHeldEnd" , HandToolSprayCan )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolSprayCan.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "tryToAddTreeMarker" , HandToolSprayCan.tryToAddTreeMarker)
    SpecializationUtil.registerFunction(handToolType, "processDelayedMarker" , HandToolSprayCan.processDelayedMarker)
    SpecializationUtil.registerFunction(handToolType, "setIsSpraying" , HandToolSprayCan.setIsSpraying)
    SpecializationUtil.registerFunction(handToolType, "changeTreeMarkerType" , HandToolSprayCan.changeTreeMarkerType)
    SpecializationUtil.registerFunction(handToolType, "getIsSprayingAllowed" , HandToolSprayCan.getIsSprayingAllowed)
    SpecializationUtil.registerFunction(handToolType, "activateSpraying" , HandToolSprayCan.activateSpraying)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | savegameXMLSchema |
|-----|-------------------|
| any | baseKey           |

**Code**

```lua
function HandToolSprayCan.registerSavegameXMLPaths(savegameXMLSchema, baseKey)
    savegameXMLSchema:register(XMLValueType.INT, baseKey .. ".sprayCan#remainingNumMarkers" , "Remaining number of markers" )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | xmlSchema |
|-----|-----------|

**Code**

```lua
function HandToolSprayCan.registerXMLPaths(xmlSchema)
    xmlSchema:setXMLSpecializationType( "HandToolSprayCan" )
    xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.sprayCan#shakeNode" , "Shake node" )
    xmlSchema:register(XMLValueType.STRING, "handTool.sprayCan#colorMaterialSlotName" , "Material slot name that should be colored" )
    xmlSchema:register(XMLValueType.VECTOR_ 4 , "handTool.sprayCan#color" , "Color of the paint" )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.sprayCan#distance" , "Spray distance" )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.sprayCan#delay" , "Spray delay in seconds" )
    xmlSchema:register(XMLValueType.INT, "handTool.sprayCan#totalNumMarkers" , "Total number of markers" )
    SoundManager.registerSampleXMLPaths(xmlSchema, "handTool.sprayCan.sounds" , "spraying" )
    EffectManager.registerEffectXMLPaths(xmlSchema, "handTool.sprayCan.effects" )
    xmlSchema:setXMLSpecializationType()
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
function HandToolSprayCan:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_sprayCan

    xmlFile:setValue(key .. "#remainingNumMarkers" , spec.remainingNumMarkers)
end

```

### setIsSpraying

**Description**

**Definition**

> setIsSpraying()

**Arguments**

| any | isSpraying |
|-----|------------|
| any | force      |

**Code**

```lua
function HandToolSprayCan:setIsSpraying(isSpraying, force)
    local spec = self.spec_sprayCan
    if spec.isSpraying ~ = isSpraying then
        if isSpraying then
            if self:getIsHeld() then
                g_effectManager:startEffects(spec.effects)
                g_soundManager:playSample(spec.sprayingSample)
                spec.shakeEndTime = g_ time + spec.shakeDuration
                spec.isSpraying = true
            end
        else
                if force then
                    g_effectManager:resetEffects(spec.effects)
                end

                g_effectManager:stopEffects(spec.effects)
                g_soundManager:stopSample(spec.sprayingSample)
                spec.sprayStopTime = 0
                spec.isSpraying = false
            end
        end
    end

```

### tryToAddTreeMarker

**Description**

**Definition**

> tryToAddTreeMarker()

**Arguments**

| any | treeMarkerTypeIndex |
|-----|---------------------|
| any | splitShapeId        |
| any | x                   |
| any | y                   |
| any | z                   |
| any | hitX                |
| any | hitY                |
| any | hitZ                |

**Code**

```lua
function HandToolSprayCan:tryToAddTreeMarker(treeMarkerTypeIndex, splitShapeId, x, y, z, hitX, hitY, hitZ)
    local spec = self.spec_sprayCan

    self:setIsSpraying( true , false )
    spec.sprayStopTime = g_ time + spec.sprayDuration

    spec.remainingNumMarkers = spec.remainingNumMarkers - 1
    if self.isServer then
        self:raiseDirtyFlags(spec.dirtyFlag)
    end

    if splitShapeId ~ = nil then
        if self:getIsSprayingAllowed(splitShapeId) then
            spec.delayedMarker = {
            time = g_ time + spec.sprayDelay,
            splitShapeId = splitShapeId,
            treeMarkerTypeIndex = treeMarkerTypeIndex,
            hitX = hitX,
            hitY = hitY,
            hitZ = hitZ,
            x = x,
            y = y,
            z = z
            }
        end
    end
end

```