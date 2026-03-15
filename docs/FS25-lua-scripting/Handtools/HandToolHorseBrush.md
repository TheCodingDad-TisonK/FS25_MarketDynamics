## HandToolHorseBrush

**Functions**

- [getHusbandryAndClusterFromNode](#gethusbandryandclusterfromnode)
- [onBrushAction](#onbrushaction)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onHeldStart](#onheldstart)
- [onLoad](#onload)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerXMLPaths](#registerxmlpaths)

### getHusbandryAndClusterFromNode

**Description**

**Definition**

> getHusbandryAndClusterFromNode()

**Arguments**

| any | carryingPlayer |
|-----|----------------|
| any | node           |

**Code**

```lua
function HandToolHorseBrush.getHusbandryAndClusterFromNode(carryingPlayer, node)
    -- If no valid node was given, return nil.
    if node = = nil or not entityExists(node) then
        return nil , nil
    end

    local husbandryId, animalId = getAnimalFromCollisionNode(node)

    if husbandryId ~ = nil and husbandryId ~ = 0 then
        local mission = g_currentMission
        local clusterHusbandry = mission.husbandrySystem:getClusterHusbandryById(husbandryId)
        if clusterHusbandry ~ = nil then
            local husbandry = clusterHusbandry:getPlaceable()
            local cluster = clusterHusbandry:getClusterByAnimalId(animalId)
            if cluster ~ = nil and mission.accessHandler:canFarmAccess(carryingPlayer.farmId, husbandry) then
                if cluster.changeDirt ~ = nil and cluster.getName ~ = nil then
                    return husbandry, cluster
                end
            end
        end
    end

    return nil , nil
end

```

### onBrushAction

**Description**

**Definition**

> onBrushAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolHorseBrush:onBrushAction(_, inputValue)
    local spec = self.spec_horseBrush
    spec.isCleaning = inputValue > 0
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolHorseBrush:onDelete()
    local spec = self.spec_horseBrush

    g_soundManager:deleteSamples(spec.samples)

    if spec.defaultCrosshair ~ = nil then
        spec.defaultCrosshair:delete()
        spec.defaultCrosshair = nil
    end
    if spec.brushCrosshair ~ = nil then
        spec.brushCrosshair:delete()
        spec.brushCrosshair = nil
    end
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function HandToolHorseBrush:onDraw()
    local spec = self.spec_horseBrush

    if spec.treeTypeCrosshair ~ = nil then
        spec.treeTypeCrosshair:render()
    end

    if spec.targetedHusbandry ~ = nil then
        spec.brushCrosshair:render()
    else
            spec.defaultCrosshair:render()
        end
    end

```

### onHeldStart

**Description**

**Definition**

> onHeldStart()

**Code**

```lua
function HandToolHorseBrush:onHeldStart()
    if not self:getCarryingPlayer().isOwner then
        return
    end

    local spec = self.spec_horseBrush

    -- Ensure objects are targeted.
    local targeter = self:getCarryingPlayer().targeter
    targeter:addTargetType( HandToolHorseBrush , CollisionFlag.ANIMAL, 0.5 , spec.animalDetectionDistance)
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
function HandToolHorseBrush:onLoad(xmlFile)
    local spec = self.spec_horseBrush

    spec.animalDetectionDistance = 3

    spec.brushNode = xmlFile:getValue( "handTool.horseBrush#node" , nil , self.components, self.i3dMappings)
    if spec.brushNode ~ = nil then
        spec.originalPos = { getTranslation(spec.brushNode) }
    end

    if self.isClient then
        spec.samples = { }
        spec.samples.cleaning = g_soundManager:loadSampleFromXML(xmlFile, "handTool.horseBrush.sounds" , "cleaning" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.defaultCrosshair = self:createCrosshairOverlay( "gui.crosshairDefault" )
        spec.brushCrosshair = self:createCrosshairOverlay( "gui.horseBrush" )
    end

    spec.targetedHusbandryId = nil
    spec.targetedClusterId = nil
    spec.dirtyFlag = self:getNextDirtyFlag()

    spec.cleaningDeltaPerMs = 10 / 1000
    spec.deltaSum = 0

    spec.isBrushing = false

    spec.brushText = g_i18n:getText( "action_interactAnimalClean" )
end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Code**

```lua
function HandToolHorseBrush:onRegisterActionEvents()
    if not self:getIsActiveForInput( true ) then
        return
    end

    local spec = self.spec_horseBrush

    local _, actionEventId = self:addActionEvent(InputAction.ACTIVATE_HANDTOOL, self , HandToolHorseBrush.onBrushAction, true , true , false , true , nil )
    spec.activateActionEventId = actionEventId
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, "" )
    g_inputBinding:setActionEventActive(actionEventId, false )
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
function HandToolHorseBrush:onUpdate(dt)
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil then
        return
    end

    local spec = self.spec_horseBrush

    spec.targetedHusbandryId = nil
    spec.targetedClusterId = nil
    spec.targetedHusbandry = nil

    -- Get the vehicle being aimed at.
    if carryingPlayer.isOwner then
        local targetNode = carryingPlayer.targeter:getClosestTargetedNodeFromType( HandToolHorseBrush )
        local husbandry, cluster = HandToolHorseBrush.getHusbandryAndClusterFromNode(carryingPlayer, targetNode)
        spec.targetedHusbandry = husbandry

        if husbandry ~ = nil then
            g_inputBinding:setActionEventText(spec.activateActionEventId, string.format(spec.brushText, cluster:getName()))
        end
        g_inputBinding:setActionEventActive(spec.activateActionEventId, husbandry ~ = nil )

        if husbandry ~ = nil then
            if spec.isCleaning then
                spec.targetedHusbandryId = NetworkUtil.getObjectId(husbandry)
                spec.targetedClusterId = cluster.id

                if spec.brushNode ~ = nil then
                    local x, y, z = spec.originalPos[ 1 ], spec.originalPos[ 2 ], spec.originalPos[ 3 ]
                    x = x + math.sin(g_ time * 0.25 * math.pi) * 0.005
                    y = y + math.sin(g_ time * 0.25 * math.pi) * 0.001
                    z = z + math.sin(g_ time * 0.25 * math.pi) * 0.05
                    setTranslation(spec.brushNode, x, y, z)
                end
            end
        end

        if spec.targetedHusbandryId ~ = spec.targetedHusbandryIdSent then
            spec.targetedHusbandryIdSent = spec.targetedHusbandryId
            spec.targetedClusterIdSent = spec.targetedClusterId
            self:raiseDirtyFlags(spec.dirtyFlag)
        end
    end

    if self.isClient then
        if spec.targetedHusbandryId ~ = nil then
            if not g_soundManager:getIsSamplePlaying(spec.samples.cleaning) then
                g_soundManager:playSample(spec.samples.cleaning)
            end
        else
                if g_soundManager:getIsSamplePlaying(spec.samples.cleaning) then
                    g_soundManager:stopSample(spec.samples.cleaning)
                end
            end
        end

        if spec.targetedHusbandryId ~ = nil then
            local husbandry = NetworkUtil.getObject(spec.targetedHusbandryId)
            if husbandry ~ = nil then
                spec.deltaSum = spec.deltaSum + spec.cleaningDeltaPerMs * dt
                if spec.deltaSum > 5 then
                    local delta = math.floor(spec.deltaSum)
                    spec.deltaSum = spec.deltaSum - delta
                    local cluster = husbandry:getClusterById(spec.targetedClusterId)
                    if cluster ~ = nil then
                        g_client:getServerConnection():sendEvent( AnimalCleanEvent.new(husbandry, spec.targetedClusterId, delta))
                    end
                end
            end
        else
                spec.deltaSum = 0
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
function HandToolHorseBrush.prerequisitesPresent(specializations)
    return true
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
function HandToolHorseBrush.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onUpdate" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onDraw" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onHeldStart" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onHeldEnd" , HandToolHorseBrush )
    SpecializationUtil.registerEventListener(handToolType, "onRegisterActionEvents" , HandToolHorseBrush )
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
function HandToolHorseBrush.registerXMLPaths(xmlSchema)
    local basePath = "handTool.horseBrush"

    xmlSchema:setXMLSpecializationType( "HandToolHorseBrush" )
    xmlSchema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Node of the brush" , nil , false )
    SoundManager.registerSampleXMLPaths(xmlSchema, basePath .. ".sounds" , "cleaning" )
    xmlSchema:setXMLSpecializationType()
end

```