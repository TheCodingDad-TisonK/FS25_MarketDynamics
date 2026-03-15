## StumpCutter

**Description**

> Specialization for stump cutter allowing to cut/remove tree trunks/split shapes

**Functions**

- [crushSplitShape](#crushsplitshape)
- [getConsumingLoad](#getconsumingload)
- [getCultivatorLimitToField](#getcultivatorlimittofield)
- [getDirtMultiplier](#getdirtmultiplier)
- [getPlowForceLimitToField](#getplowforcelimittofield)
- [getPlowLimitToField](#getplowlimittofield)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [processStumpCutterArea](#processstumpcutterarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [stumpCutterSplitShapeCallback](#stumpcuttersplitshapecallback)

### crushSplitShape

**Description**

> Crush slit shape

**Definition**

> crushSplitShape(integer shape)

**Arguments**

| integer | shape | shape |
|---------|-------|-------|

**Code**

```lua
function StumpCutter:crushSplitShape(shape)
    if self.isServer then
        local x, _, z = getWorldTranslation(shape)
        delete(shape)

        local range = 10
        g_densityMapHeightManager:setCollisionMapAreaDirty(x - range, z - range, x + range, z + range, true )
        g_currentMission.aiSystem:setAreaDirty(x - range, x + range, z - range, z + range)
    end
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
function StumpCutter:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local spec = self.spec_stumpCutter
    local loadPercentage = 0 -- idle load
    for i = 1 , #spec.cutNodes do
        if spec.cutNodes[i].lastWorkTime + 500 > g_ time then
            loadPercentage = 1
            break
        end
    end

    return value + loadPercentage, count + 1
end

```

### getCultivatorLimitToField

**Description**

> Returns if cultivator is limited to the field

**Definition**

> getCultivatorLimitToField()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | isLimited | is limited to field |
|-----|-----------|---------------------|

**Code**

```lua
function StumpCutter:getCultivatorLimitToField(superFunc)
    return false
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
function StumpCutter:getDirtMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_stumpCutter
    if spec.curSplitShape ~ = nil then
        multiplier = multiplier + self:getWorkDirtMultiplier()
    end

    return multiplier
end

```

### getPlowForceLimitToField

**Description**

> Returns if plow limit to field is forced and not changeable

**Definition**

> getPlowForceLimitToField()

**Return Values**

| any | isForced | is forced |
|-----|----------|-----------|

**Code**

```lua
function StumpCutter:getPlowForceLimitToField()
    return true
end

```

### getPlowLimitToField

**Description**

> Returns if plow is limited to the field

**Definition**

> getPlowLimitToField()

**Return Values**

| any | isLimited | is limited to field |
|-----|-----------|---------------------|

**Code**

```lua
function StumpCutter:getPlowLimitToField()
    return false
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

| any | wearMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function StumpCutter:getWearMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_stumpCutter
    if spec.curSplitShape ~ = nil then
        multiplier = multiplier + self:getWorkWearMultiplier()
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
function StumpCutter.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "stumpCutter" , true , false , false )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "StumpCutter" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.stumpCutter.cutNode(?)#node" , "Cut node" )

    schema:register(XMLValueType.FLOAT, "vehicle.stumpCutter.cutNode(?)#cutSizeY" , "Cut size Y" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.stumpCutter.cutNode(?)#cutSizeZ" , "Cut size X" , 1 )

    schema:register(XMLValueType.TIME, "vehicle.stumpCutter.cutNode(?)#maxCutTime" , "Time until cut" , 4 )
    schema:register(XMLValueType.TIME, "vehicle.stumpCutter.cutNode(?)#maxResetCutTime" , "Time between cuts" , 4 )

    schema:register(XMLValueType.FLOAT, "vehicle.stumpCutter.cutNode(?)#cutFullTreeThreshold" , "If the tree length below the cut node is smaller than this value it gets removed" , 0.4 )
    schema:register(XMLValueType.FLOAT, "vehicle.stumpCutter.cutNode(?)#cutPartThreshold" , "Cut part threshold" , 0.2 )

    schema:register(XMLValueType.INT, "vehicle.stumpCutter.cutNode(?)#workAreaIndex" , "Work area index" )
    schema:register(XMLValueType.TIME, "vehicle.stumpCutter.cutNode(?)#cutDuration" , "Cut duration" , 1 )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.stumpCutter.cutNode(?).effects" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.stumpCutter.sounds" , "start" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.stumpCutter.sounds" , "stop" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.stumpCutter.sounds" , "idle" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.stumpCutter.sounds" , "work" )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.stumpCutter.effects" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.stumpCutter.animationNodes" )

    schema:setXMLSpecializationType()
end

```

### onDeactivate

**Description**

> Called on deactivate

**Definition**

> onDeactivate()

**Code**

```lua
function StumpCutter:onDeactivate()
    if self.isClient then
        local spec = self.spec_stumpCutter
        g_effectManager:stopEffects(spec.effects)
        for i = 1 , #spec.cutNodes do
            g_effectManager:stopEffects(spec.cutNodes[i].effects)
        end
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function StumpCutter:onDelete()
    local spec = self.spec_stumpCutter
    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)
    g_effectManager:deleteEffects(spec.effects)

    if spec.cutNodes ~ = nil then
        for i = 1 , #spec.cutNodes do
            g_effectManager:deleteEffects(spec.cutNodes[i].effects)
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
function StumpCutter:onLoad(savegame)
    local spec = self.spec_stumpCutter

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode" , "vehicle.stumpCutter.animationNodes.animationNode" , "stumbCutter" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutterStartSound" , "vehicle.stumpCutter.sounds.start" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutterIdleSound" , "vehicle.stumpCutter.sounds.idle" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutterWorkSound" , "vehicle.stumpCutter.sounds.work" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutterStopSound" , "vehicle.stumpCutter.sounds.stop" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter.emitterShape(0)" , "vehicle.stumpCutter.effects.effectNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter.particleSystem(0)" , "vehicle.stumpCutter.effects.effectNode" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter#cutNode" , "vehicle.stumpCutter.cutNode#node" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter#cutSizeY" , "vehicle.stumpCutter.cutNode#cutSizeY" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter#cutSizeZ" , "vehicle.stumpCutter.cutNode#cutSizeZ" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter#cutFullTreeThreshold" , "vehicle.stumpCutter.cutNode#cutFullTreeThreshold" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.stumpCutter#cutPartThreshold" , "vehicle.stumpCutter.cutNode#cutPartThreshold" ) --FS19 to FS22

    local baseKey = "vehicle.stumpCutter"

    spec.cutNodes = { }
    spec.currentCutNodeIndex = 1

    local i = 0
    while true do
        local key = string.format( "%s.cutNode(%d)" , baseKey, i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if node = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing 'node' for '%s'!" , key)
                break
            end

            local cutNode = { }
            cutNode.node = node
            cutNode.cutSizeY = self.xmlFile:getValue(key .. "#cutSizeY" , 1 )
            cutNode.cutSizeZ = self.xmlFile:getValue(key .. "#cutSizeZ" , 1 )
            cutNode.maxCutTime = self.xmlFile:getValue(key .. "#maxCutTime" , 4 )
            cutNode.nextCutTime = cutNode.maxCutTime
            cutNode.maxResetCutTime = self.xmlFile:getValue(key .. "#maxResetCutTime" , 1 )
            cutNode.resetCutTime = cutNode.maxResetCutTime
            cutNode.cutFullTreeThreshold = self.xmlFile:getValue(key .. "#cutFullTreeThreshold" , 0.4 )
            cutNode.cutPartThreshold = self.xmlFile:getValue(key .. "#cutPartThreshold" , 0.2 )
            cutNode.workAreaIndex = self.xmlFile:getValue(key .. "#workAreaIndex" )
            cutNode.workTimer = 0
            cutNode.workDuration = self.xmlFile:getValue(key .. "#cutDuration" , 1 )

            cutNode.lastWorkTime = - 1000

            cutNode.workFadeTime = 0
            cutNode.maxWorkFadeTime = 1000

            if self.isClient then
                cutNode.effects = g_effectManager:loadEffect( self.xmlFile, key .. ".effects" , self.components, self , self.i3dMappings)
            end

            table.insert(spec.cutNodes, cutNode)
            i = i + 1
        end

        if self.isClient then
            spec.samples = { }
            spec.samples.start = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "start" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.samples.stop = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "stop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.samples.idle = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "idle" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

            spec.maxWorkFadeTime = 1000
            spec.workFadeTime = 0

            spec.effects = g_effectManager:loadEffect( self.xmlFile, baseKey .. ".effects" , self.components, self , self.i3dMappings)
            spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".animationNodes" , self.components, self , self.i3dMappings)
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
function StumpCutter:onTurnedOff()
    if self.isClient then
        local spec = self.spec_stumpCutter
        spec.workFadeTime = 0
        g_effectManager:stopEffects(spec.effects)
        for i = 1 , #spec.cutNodes do
            g_effectManager:stopEffects(spec.cutNodes[i].effects)
        end

        g_soundManager:stopSamples(spec.samples)
        g_soundManager:playSample(spec.samples.stop)
        g_animationManager:stopAnimations(spec.animationNodes)
    end
end

```

### onTurnedOn

**Description**

> Called on turn on

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function StumpCutter:onTurnedOn()
    if self.isClient then
        local spec = self.spec_stumpCutter
        g_soundManager:stopSamples(spec.samples)
        g_soundManager:playSample(spec.samples.start)
        g_soundManager:playSample(spec.samples.idle, 0 , spec.samples.start)
        g_animationManager:startAnimations(spec.animationNodes)
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
function StumpCutter:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self:getIsTurnedOn() then
        local spec = self.spec_stumpCutter

        local numCutNodes = #spec.cutNodes
        if numCutNodes > 0 then
            local nextCutNodeIndex = spec.currentCutNodeIndex + 1
            if nextCutNodeIndex > numCutNodes then
                nextCutNodeIndex = 1
            end

            spec.currentCutNodeIndex = nextCutNodeIndex
            local cutNode = spec.cutNodes[nextCutNodeIndex]

            cutNode.curLenAbove = 0
            cutNode.curLenBelow = 0

            local x,y,z = getWorldTranslation(cutNode.node)
            local nx,ny,nz = localDirectionToWorld(cutNode.node, 1 , 0 , 0 )
            local yx,yy,yz = localDirectionToWorld(cutNode.node, 0 , 1 , 0 )
            if cutNode.curSplitShape ~ = nil then
                if not entityExists(cutNode.curSplitShape) or testSplitShape(cutNode.curSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, cutNode.cutSizeY, cutNode.cutSizeZ) = = nil then
                    cutNode.curSplitShape = nil
                end
            end
            if cutNode.curSplitShape = = nil then
                local shape, _, _, _, _ = findSplitShape(x,y,z, nx,ny,nz, yx,yy,yz, cutNode.cutSizeY, cutNode.cutSizeZ)
                if shape ~ = 0 then
                    cutNode.curSplitShape = shape
                end
            end

            if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                local x1, y1, z1 = localToWorld(cutNode.node, 0 , 0 , cutNode.cutSizeZ)
                local x2, y2, z2 = localToWorld(cutNode.node, 0 , cutNode.cutSizeY, 0 )

                DebugPlane.renderWithPositions(x, y, z, x1, y1, z1, x2, y2, z2, Color.PRESETS.PINK, false )
            end

            if cutNode.curSplitShape ~ = nil then
                local lenBelow, lenAbove = getSplitShapePlaneExtents(cutNode.curSplitShape, x,y,z, nx,ny,nz)

                if lenAbove > = cutNode.cutPartThreshold then
                    cutNode.lastWorkTime = g_ time
                end

                cutNode.workFadeTime = math.min(cutNode.maxWorkFadeTime, cutNode.workFadeTime + dt * numCutNodes)
                if self.isServer then
                    cutNode.resetCutTime = cutNode.maxResetCutTime
                    if cutNode.nextCutTime > 0 then
                        cutNode.nextCutTime = cutNode.nextCutTime - dt
                        if cutNode.nextCutTime < = 0 then
                            -- cut
                            local _,ly,_ = worldToLocal(cutNode.curSplitShape, x,y,z)
                            if (lenBelow < = cutNode.cutFullTreeThreshold or ly < cutNode.cutPartThreshold + 0.01 ) and lenAbove < 1 then -- only delete tree if lenAbove < 1 to avoid full tree deletion
                                -- Delete full tree:Not much left below the cut or cutting near the ground
                                self:crushSplitShape(cutNode.curSplitShape)
                                cutNode.curSplitShape = nil
                            elseif lenAbove > = cutNode.cutPartThreshold and lenBelow > = cutNode.cutPartThreshold then
                                    -- Normal cut:Splitting 20cm below the top
                                    cutNode.nextCutTime = cutNode.maxCutTime
                                    local curSplitShape = cutNode.curSplitShape
                                    cutNode.curSplitShape = nil
                                    cutNode.curLenAbove = lenAbove
                                    cutNode.curLenBelow = lenBelow

                                    self.shapeBeingCut = curSplitShape
                                    splitShape(curSplitShape, x,y,z, nx,ny,nz, yx,yy,yz, cutNode.cutSizeY, cutNode.cutSizeZ, "stumpCutterSplitShapeCallback" , self )
                                    g_treePlantManager:removingSplitShape(curSplitShape)
                                else
                                        cutNode.curSplitShape = nil
                                        cutNode.nextCutTime = cutNode.maxCutTime
                                    end
                                end
                            end
                        end
                    else
                            cutNode.workFadeTime = math.max( 0 , cutNode.workFadeTime - dt)
                            if self.isServer then
                                if cutNode.resetCutTime > 0 then
                                    cutNode.resetCutTime = cutNode.resetCutTime - dt
                                    if cutNode.resetCutTime < = 0 then
                                        cutNode.nextCutTime = cutNode.maxCutTime
                                    end
                                end
                            end
                        end

                        if self.isClient then
                            if cutNode.lastWorkTime + 500 > g_ time then
                                g_effectManager:setEffectTypeInfo(cutNode.effects, FillType.WOODCHIPS)
                                g_effectManager:startEffects(cutNode.effects)
                            else
                                    g_effectManager:stopEffects(cutNode.effects)
                                end

                                local anyCutNodeWorking = false
                                for i = 1 , #spec.cutNodes do
                                    if spec.cutNodes[i].lastWorkTime + 500 > g_ time then
                                        anyCutNodeWorking = true
                                        break
                                    end
                                end

                                if anyCutNodeWorking then
                                    g_effectManager:setEffectTypeInfo(spec.effects, FillType.WOODCHIPS)
                                    g_effectManager:startEffects(spec.effects)
                                    if not g_soundManager:getIsSamplePlaying(spec.samples.work) then
                                        g_soundManager:playSample(spec.samples.work)
                                    end
                                else
                                        g_effectManager:stopEffects(spec.effects)
                                        if g_soundManager:getIsSamplePlaying(spec.samples.work) then
                                            g_soundManager:stopSample(spec.samples.work)
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
function StumpCutter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
end

```

### processStumpCutterArea

**Description**

**Definition**

> processStumpCutterArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function StumpCutter:processStumpCutterArea(workArea, dt)
    local spec = self.spec_stumpCutter

    if not self.isServer and self.currentUpdateDistance > StumpCutter.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local area, totalArea = 0 , 0
    for _, cutNode in ipairs(spec.cutNodes) do
        if cutNode.workAreaIndex = = workArea.index then
            local xs,_,zs = getWorldTranslation(workArea.start)
            local xw,_,zw = getWorldTranslation(workArea.width)
            local xh,_,zh = getWorldTranslation(workArea.height)

            local _area, _totalArea, nonMowableCut = FSDensityMapUtil.clearDecoArea(xs, zs, xw, zw, xh, zh)
            if _area > 0 and nonMowableCut then
                cutNode.lastWorkTime = g_ time
            end

            area = area + _area
            totalArea = totalArea + _totalArea
        end
    end

    return area, totalArea
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
function StumpCutter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , StumpCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , StumpCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , StumpCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , StumpCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , StumpCutter )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , StumpCutter )
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
function StumpCutter.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "crushSplitShape" , StumpCutter.crushSplitShape)
    SpecializationUtil.registerFunction(vehicleType, "stumpCutterSplitShapeCallback" , StumpCutter.stumpCutterSplitShapeCallback)
    SpecializationUtil.registerFunction(vehicleType, "processStumpCutterArea" , StumpCutter.processStumpCutterArea)
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
function StumpCutter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , StumpCutter.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , StumpCutter.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCultivatorLimitToField" , StumpCutter.getCultivatorLimitToField)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getPlowLimitToField" , StumpCutter.getPlowLimitToField)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getPlowForceLimitToField" , StumpCutter.getPlowForceLimitToField)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , StumpCutter.getConsumingLoad)
end

```

### stumpCutterSplitShapeCallback

**Description**

> Split shape callback

**Definition**

> stumpCutterSplitShapeCallback(integer shape, boolean isBelow, boolean isAbove, float minY, float maxY, float minZ,
> float maxZ)

**Arguments**

| integer | shape   | shape                |
|---------|---------|----------------------|
| boolean | isBelow | is below             |
| boolean | isAbove | is above             |
| float   | minY    | min y split position |
| float   | maxY    | max y split position |
| float   | minZ    | min z split position |
| float   | maxZ    | max z split position |

**Code**

```lua
function StumpCutter:stumpCutterSplitShapeCallback(shape, isBelow, isAbove, minY, maxY, minZ, maxZ)
    local spec = self.spec_stumpCutter
    local cutNode = spec.cutNodes[spec.currentCutNodeIndex]

    if not isBelow then
        if cutNode.curLenAbove < 1 then -- split tree if lenAbove > 1 to avoid fulltree deletion
            self:crushSplitShape(shape)
        else
                g_treePlantManager:addingSplitShape(shape, self.shapeBeingCut)
            end
        else
                local yPos = minY + (maxY - minY) / 2
                local zPos = minZ + (maxZ - minZ) / 2

                local _,y,_ = localToWorld(cutNode.node, - 0.05 , yPos, zPos)
                local height = getTerrainHeightAtWorldPos(g_terrainNode, getWorldTranslation(cutNode.node))
                if y < height then
                    self:crushSplitShape(shape)
                else
                        spec.curSplitShape = shape
                        g_treePlantManager:addingSplitShape(shape, self.shapeBeingCut)
                    end
                end
            end

```