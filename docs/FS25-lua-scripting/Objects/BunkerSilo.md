## BunkerSilo

**Description**

> Class for bunker silo

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [clearSiloArea](#clearsiloarea)
- [delete](#delete)
- [getBunkerAreaOffset](#getbunkerareaoffset)
- [getCanCloseSilo](#getcanclosesilo)
- [getCanInteract](#getcaninteract)
- [getCanOpenSilo](#getcanopensilo)
- [getInteractionPosition](#getinteractionposition)
- [getIsCloserToFront](#getisclosertofront)
- [interactionTriggerCallback](#interactiontriggercallback)
- [load](#load)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [onChangedFillLevelCallback](#onchangedfilllevelcallback)
- [onCreate](#oncreate)
- [openSilo](#opensilo)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setState](#setstate)
- [switchFillTypeAtOffset](#switchfilltypeatoffset)
- [update](#update)
- [updateFillLevel](#updatefilllevel)
- [updateTick](#updatetick)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### clearSiloArea

**Description**

> Clear the silo area

**Definition**

> clearSiloArea()

**Code**

```lua
function BunkerSilo:clearSiloArea()
    local xs, _, zs = getWorldTranslation( self.bunkerSiloArea.start)
    local xw, _, zw = getWorldTranslation( self.bunkerSiloArea.width)
    local xh, _, zh = getWorldTranslation( self.bunkerSiloArea.height)
    DensityMapHeightUtil.clearArea(xs,zs, xw,zw, xh,zh)
end

```

### delete

**Description**

> Deleting bunker silo object

**Definition**

> delete()

**Code**

```lua
function BunkerSilo:delete()
    if self.interactionTriggerNode ~ = nil then
        removeTrigger( self.interactionTriggerNode)
    end

    g_densityMapHeightManager:removeFixedFillTypesArea( self.bunkerSiloArea)
    g_densityMapHeightManager:removeConvertingFillTypeAreas( self.bunkerSiloArea)

    g_messageCenter:unsubscribeAll( self )

    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
    BunkerSilo:superClass().delete( self )
end

```

### getBunkerAreaOffset

**Description**

> Get bunker area offset

**Definition**

> getBunkerAreaOffset(boolean updateAtFront, float offset, integer fillType)

**Arguments**

| boolean | updateAtFront | update at front |
|---------|---------------|-----------------|
| float   | offset        | offset          |
| integer | fillType      | fill type       |

**Return Values**

| integer | offset | offset |
|---------|--------|--------|

**Code**

```lua
function BunkerSilo:getBunkerAreaOffset(updateAtFront, offset, fillType)
    local area = self.bunkerSiloArea

    local hx, hz = area.dhx_norm, area.dhz_norm
    local hl = MathUtil.vector3Length(area.dhx, area.dhy, area.dhz)

    while offset < = (hl - 1 ) do
        local pos = offset
        if not updateAtFront then
            pos = hl - offset - 1
        end
        local d1x,d1z = pos * hx, pos * hz
        local d2x,d2z = (pos + 1 ) * hx, (pos + 1 ) * hz

        local a0x, a0z = area.sx + d1x, area.sz + d1z
        local a1x, a1z = area.wx + d1x, area.wz + d1z
        local a2x, a2z = area.sx + d2x, area.sz + d2z

        local fillLevel = DensityMapHeightUtil.getFillLevelAtArea(fillType, a0x,a0z, a1x,a1z, a2x,a2z)
        if fillLevel > 0 then
            return offset
        end
        offset = offset + 1
    end

    return math.max(hl - 1 , 0 )
end

```

### getCanCloseSilo

**Description**

> Get can close silo

**Definition**

> getCanCloseSilo()

**Return Values**

| integer | canClose | can close silo |
|---------|----------|----------------|

**Code**

```lua
function BunkerSilo:getCanCloseSilo()
    return self.state = = BunkerSilo.STATE_FILL and self.fillLevel > 0 and self.compactedPercent > = 100
end

```

### getCanInteract

**Description**

> Get can interact with silo

**Definition**

> getCanInteract(boolean showInformationOnly)

**Arguments**

| boolean | showInformationOnly | show information only |
|---------|---------------------|-----------------------|

**Return Values**

| boolean | canInteract | can interact |
|---------|-------------|--------------|

**Code**

```lua
function BunkerSilo:getCanInteract(showInformationOnly)
    local localPlayer = g_localPlayer
    if localPlayer = = nil then
        return false
    end

    if showInformationOnly then

        -- If the player is not in a vehicle and is in range, return true.
        if not localPlayer:getIsInVehicle() and self.playerInRange then
            return true
        end

        -- If the player is in a vehicle, check to see if it is in range.
            local playerVehicle = localPlayer:getCurrentVehicle()
            if playerVehicle ~ = nil then
                for vehicle in pairs( self.vehiclesInRange) do
                    if vehicle:getIsActiveForInput( true ) and vehicle = = playerVehicle then
                        return true
                    end
                end
            end
        elseif not localPlayer:getIsInVehicle() and self.playerInRange then
                return true
            end

            return false
        end

```

### getCanOpenSilo

**Description**

> Get can open silo

**Definition**

> getCanOpenSilo()

**Return Values**

| boolean | canOpen | can open silo |
|---------|---------|---------------|

**Code**

```lua
function BunkerSilo:getCanOpenSilo()
    if not( self.state = = BunkerSilo.STATE_FERMENTED or self.state = = BunkerSilo.STATE_DRAIN) then
        return false
    end
    local ix,iy,iz = self:getInteractionPosition()
    if ix ~ = nil then
        local closerToFront = self:getIsCloserToFront(ix,iy,iz)
        if closerToFront and not self.isOpenedAtFront then
            return true
        end
        if not closerToFront and not self.isOpenedAtBack then
            return true
        end
    end
    return false
end

```

### getInteractionPosition

**Description**

> Get interact position

**Definition**

> getInteractionPosition()

**Return Values**

| boolean | x | x world position |
|---------|---|------------------|
| boolean | y | y world position |
| boolean | z | z world position |

**Code**

```lua
function BunkerSilo:getInteractionPosition()
    local localPlayer = g_localPlayer
    if localPlayer = = nil then
        return nil
    end

    if not localPlayer:getIsInVehicle() and self.playerInRange then
        return localPlayer:getPosition()
    else
            local playerVehicle = localPlayer:getCurrentVehicle()
            if self.vehiclesInRange[playerVehicle] ~ = nil then
                return getWorldTranslation( self.vehiclesInRange[playerVehicle].components[ 1 ].node)
            end
        end

        return nil
    end

```

### getIsCloserToFront

**Description**

> Get is closer to front

**Definition**

> getIsCloserToFront(float ix, float iy, float iz)

**Arguments**

| float | ix | x position |
|-------|----|------------|
| float | iy | y position |
| float | iz | z position |

**Return Values**

| float | isCloserToFront | is closer to front |
|-------|-----------------|--------------------|

**Code**

```lua
function BunkerSilo:getIsCloserToFront(ix,iy,iz)
    local area = self.bunkerSiloArea

    local x = area.sx + ( 0.5 * area.dwx) + (area.offsetFront * area.dhx_norm)
    local y = area.sy + ( 0.5 * area.dwy) + (area.offsetFront * area.dhy_norm)
    local z = area.sz + ( 0.5 * area.dwz) + (area.offsetFront * area.dhz_norm)
    local distFront = MathUtil.vector3Length(x - ix, y - iy, z - iz)

    x = area.sx + ( 0.5 * area.dwx) + area.dhx - (area.offsetBack * area.dhx_norm)
    y = area.sy + ( 0.5 * area.dwy) + area.dhy - (area.offsetBack * area.dhy_norm)
    z = area.sz + ( 0.5 * area.dwz) + area.dhz - (area.offsetBack * area.dhz_norm)
    local distBack = MathUtil.vector3Length(x - ix, y - iy, z - iz)

    return distFront < distBack
end

```

### interactionTriggerCallback

**Description**

> interactionTriggerCallback

**Definition**

> interactionTriggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay,
> integer otherId)

**Arguments**

| integer | triggerId | id of trigger     |
|---------|-----------|-------------------|
| integer | otherId   | id of actor       |
| boolean | onEnter   | on enter          |
| boolean | onLeave   | on leave          |
| boolean | onStay    | on stay           |
| integer | otherId   | id of other actor |

**Code**

```lua
function BunkerSilo:interactionTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay, otherShapeId)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
            if onEnter then
                self.playerInRange = true
                g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
            else
                    self.playerInRange = false
                    if self.numVehiclesInRange = = 0 then
                        g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                    end
                end
            else
                    local vehicle = g_currentMission:getNodeObject(otherShapeId)
                    if vehicle ~ = nil and vehicle:isa( Vehicle ) then
                        if onEnter then
                            if self.vehiclesInRange[vehicle] = = nil then
                                self.vehiclesInRange[vehicle] = true
                                self.numVehiclesInRange = self.numVehiclesInRange + 1

                                g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)

                                -- add callback if shovel
                                    if vehicle.setBunkerSiloInteractorCallback ~ = nil then
                                        vehicle:setBunkerSiloInteractorCallback( BunkerSilo.onChangedFillLevelCallback, self )
                                    end
                                end
                            else
                                    if self.vehiclesInRange[vehicle] then
                                        self.vehiclesInRange[vehicle] = nil
                                        self.numVehiclesInRange = self.numVehiclesInRange - 1

                                        if self.numVehiclesInRange = = 0 and not self.playerInRange then
                                            g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                                        end

                                        -- remove callback if shovel
                                            if vehicle.setBunkerSiloInteractorCallback ~ = nil then
                                                vehicle:setBunkerSiloInteractorCallback( nil )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

```

### load

**Description**

> Load bunker silo

**Definition**

> load(table components, table xmlFile, string key, table i3dMappings)

**Arguments**

| table  | components  | components      |
|--------|-------------|-----------------|
| table  | xmlFile     | xml file object |
| string | key         | xml key         |
| table  | i3dMappings | i3dMappings     |

**Return Values**

| table | success | success |
|-------|---------|---------|

**Code**

```lua
function BunkerSilo:load(components, xmlFile, key, i3dMappings)
    self.bunkerSiloArea.start = xmlFile:getValue(key .. ".area#startNode" , nil , components, i3dMappings)
    self.bunkerSiloArea.width = xmlFile:getValue(key .. ".area#widthNode" , nil , components, i3dMappings)
    self.bunkerSiloArea.height = xmlFile:getValue(key .. ".area#heightNode" , nil , components, i3dMappings)

    self.bunkerSiloArea.sx, self.bunkerSiloArea.sy, self.bunkerSiloArea.sz = getWorldTranslation( self.bunkerSiloArea.start)
    self.bunkerSiloArea.wx, self.bunkerSiloArea.wy, self.bunkerSiloArea.wz = getWorldTranslation( self.bunkerSiloArea.width)
    self.bunkerSiloArea.hx, self.bunkerSiloArea.hy, self.bunkerSiloArea.hz = getWorldTranslation( self.bunkerSiloArea.height)

    self.bunkerSiloArea.dhx = self.bunkerSiloArea.hx - self.bunkerSiloArea.sx
    self.bunkerSiloArea.dhy = self.bunkerSiloArea.hy - self.bunkerSiloArea.sy
    self.bunkerSiloArea.dhz = self.bunkerSiloArea.hz - self.bunkerSiloArea.sz
    self.bunkerSiloArea.dhx_norm, self.bunkerSiloArea.dhy_norm, self.bunkerSiloArea.dhz_norm = MathUtil.vector3Normalize( self.bunkerSiloArea.dhx, self.bunkerSiloArea.dhy, self.bunkerSiloArea.dhz)

    self.bunkerSiloArea.dwx = self.bunkerSiloArea.wx - self.bunkerSiloArea.sx
    self.bunkerSiloArea.dwy = self.bunkerSiloArea.wy - self.bunkerSiloArea.sy
    self.bunkerSiloArea.dwz = self.bunkerSiloArea.wz - self.bunkerSiloArea.sz
    self.bunkerSiloArea.dwx_norm, self.bunkerSiloArea.dwy_norm, self.bunkerSiloArea.dwz_norm = MathUtil.vector3Normalize( self.bunkerSiloArea.dwx, self.bunkerSiloArea.dwy, self.bunkerSiloArea.dwz)

    self.bunkerSiloArea.inner = { }
    self.bunkerSiloArea.inner.start = xmlFile:getValue(key .. ".innerArea#startNode" , self.bunkerSiloArea.start, components, i3dMappings)
    self.bunkerSiloArea.inner.width = xmlFile:getValue(key .. ".innerArea#widthNode" , self.bunkerSiloArea.width, components, i3dMappings)
    self.bunkerSiloArea.inner.height = xmlFile:getValue(key .. ".innerArea#heightNode" , self.bunkerSiloArea.height, components, i3dMappings)

    self.bunkerSiloArea.inner.sx, self.bunkerSiloArea.inner.sy, self.bunkerSiloArea.inner.sz = getWorldTranslation( self.bunkerSiloArea.inner.start)
    self.bunkerSiloArea.inner.wx, self.bunkerSiloArea.inner.wy, self.bunkerSiloArea.inner.wz = getWorldTranslation( self.bunkerSiloArea.inner.width)
    self.bunkerSiloArea.inner.hx, self.bunkerSiloArea.inner.hy, self.bunkerSiloArea.inner.hz = getWorldTranslation( self.bunkerSiloArea.inner.height)

    self.interactionTriggerNode = xmlFile:getValue(key .. ".interactionTrigger#node" , nil , components, i3dMappings)
    if self.interactionTriggerNode ~ = nil then
        addTrigger( self.interactionTriggerNode, "interactionTriggerCallback" , self )
    end

    self.acceptedFillTypes = { }
    local data = xmlFile:getValue(key .. "#acceptedFillTypes" , "chaff grass_windrow dryGrass_windrow" ):split( " " )
    for i = 1 , #data do
        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(data[i])
        if fillTypeIndex ~ = nil then
            self.acceptedFillTypes[fillTypeIndex] = true
        else
                Logging.warning( "'%s' is an invalid fillType for bunkerSilo '%s'!" , tostring(data[i]), key .. "#acceptedFillTypes" )
                end
            end

            local inputFillTypeName = xmlFile:getValue(key .. "#inputFillType" , "chaff" )
            local inputFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(inputFillTypeName)
            if inputFillTypeIndex ~ = nil then
                self.inputFillType = inputFillTypeIndex
            else
                    Logging.warning( "'%s' is an invalid input fillType for bunkerSilo '%s'!" , tostring(inputFillTypeName), key .. "#inputFillType" )
                    end

                    local outputFillTypeName = xmlFile:getValue(key .. "#outputFillType" , "silage" )
                    local outputFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(outputFillTypeName)
                    if outputFillTypeIndex ~ = nil then
                        self.outputFillType = outputFillTypeIndex
                    else
                            Logging.warning( "'%s' is an invalid output fillType for bunkerSilo '%s'!" , tostring(outputFillTypeName), key .. "#outputFillType" )
                            end

                            g_densityMapHeightManager:setConvertingFillTypeAreas( self.bunkerSiloArea, self.acceptedFillTypes, self.inputFillType)

                            self.distanceToCompactedFillLevel = xmlFile:getValue(key .. "#distanceToCompactedFillLevel" , self.distanceToCompactedFillLevel)
                            self.openingLength = xmlFile:getValue(key .. "#openingLength" , 5 )

                            local leftWallNode = xmlFile:getValue(key .. ".wallLeft#node" , nil , components, i3dMappings)
                            if leftWallNode ~ = nil then
                                self.wallLeft = { }
                                self.wallLeft.node = leftWallNode
                                self.wallLeft.visible = true
                                self.wallLeft.collision = xmlFile:getValue(key .. ".wallLeft#collision" , nil , components, i3dMappings)
                            end

                            local rightWallNode = xmlFile:getValue(key .. ".wallRight#node" , nil , components, i3dMappings)
                            if rightWallNode ~ = nil then
                                self.wallRight = { }
                                self.wallRight.node = rightWallNode
                                self.wallRight.visible = true
                                self.wallRight.collision = xmlFile:getValue(key .. ".wallRight#collision" , nil , components, i3dMappings)
                            end

                            self.fillLevel = 0

                            -- adjust timings to difficulty
                            local difficultyMultiplier = g_currentMission.missionInfo.economicDifficulty
                            self.distanceToCompactedFillLevel = self.distanceToCompactedFillLevel / difficultyMultiplier

                            self:setState( BunkerSilo.STATE_FILL)

                            return true
                        end

```

### loadFromXMLFile

**Description**

> Loading from attributes and nodes

**Definition**

> loadFromXMLFile(XMLFile xmlFile, string key)

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| string  | key     | key              |

**Return Values**

| string | success | success |
|--------|---------|---------|

**Code**

```lua
function BunkerSilo:loadFromXMLFile(xmlFile, key)

    local state = xmlFile:getValue(key .. "#state" )
    if state ~ = nil then
        if state > = 0 and state < BunkerSilo.NUM_STATES then
            self:setState(state)
        end
    end

    local fillLevel = xmlFile:getValue(key .. "#fillLevel" )
    if fillLevel ~ = nil then
        self.fillLevel = fillLevel
    end
    local compactedFillLevel = xmlFile:getValue(key .. "#compactedFillLevel" )
    if compactedFillLevel ~ = nil then
        self.compactedFillLevel = math.clamp(compactedFillLevel, 0 , self.fillLevel)
    end
    self.compactedPercent = MathUtil.getFlooredPercent( math.min( self.compactedFillLevel, self.fillLevel), self.fillLevel)

    local fermentingTime = xmlFile:getValue(key .. "#fermentingTime" )
    if fermentingTime ~ = nil then
        -- Convert to percent
        self.fermentingPercent = fermentingTime / ( BunkerSilo.MILLISECONDS_PER_DAY * g_currentMission.environment.daysPerPeriod)
    end

    self.isOpenedAtFront = xmlFile:getValue(key .. "#openedAtFront" , false )
    self.isOpenedAtBack = xmlFile:getValue(key .. "#openedAtBack" , false )

    if self.isOpenedAtFront then
        self.bunkerSiloArea.offsetFront = self:getBunkerAreaOffset( true , 0 , self.outputFillType)
    else
            self.bunkerSiloArea.offsetFront = self:getBunkerAreaOffset( true , 0 , self.fermentingFillType)
        end
        if self.isOpenedAtBack then
            self.bunkerSiloArea.offsetBack = self:getBunkerAreaOffset( false , 0 , self.outputFillType)
        else
                self.bunkerSiloArea.offsetBack = self:getBunkerAreaOffset( false , 0 , self.fermentingFillType)
            end

            if self.fillLevel > 0 and self.state = = BunkerSilo.STATE_DRAIN then
                local area = self.bunkerSiloArea
                local offWx = area.wx - area.sx
                local offWz = area.wz - area.sz
                local offW = math.sqrt(offWx * offWx + offWz * offWz)

                local offHx = area.hx - area.sx
                local offHz = area.hz - area.sz
                local offH = math.sqrt(offHx * offHx + offHz * offHz)

                if offW > 0.001 and offH > 0.001 then
                    -- offset by 0.9m in each direction(and max 45%)
                    local offWScale = math.min( 0.45 , 0.9 / offW)
                    offWx = offWx * offWScale
                    offWz = offWz * offWScale

                    local offHScale = math.min( 0.45 , 0.9 / offH)
                    offHx = offHx * offHScale
                    offHz = offHz * offHScale

                    local innerFillLevel1 = DensityMapHeightUtil.getFillLevelAtArea( self.fermentingFillType, area.sx + offWx + offHx,area.sz + offWz + offHz, area.wx - offWx + offHx,area.wz - offWz + offHz, area.hx + offWx - offHx,area.hz + offWz - offHz)
                    local innerFillLevel2 = DensityMapHeightUtil.getFillLevelAtArea( self.outputFillType, area.sx + offWx + offHx,area.sz + offWz + offHz, area.wx - offWx + offHx,area.wz - offWz + offHz, area.hx + offWx - offHx,area.hz + offWz - offHz)
                    local innerFillLevel = innerFillLevel1 + innerFillLevel2
                    if innerFillLevel < self.emptyThreshold * 0.5 then
                        DensityMapHeightUtil.removeFromGroundByArea(area.sx,area.sz, area.wx,area.wz, area.hx,area.hz, self.fermentingFillType)
                        DensityMapHeightUtil.removeFromGroundByArea(area.sx,area.sz, area.wx,area.wz, area.hx,area.hz, self.outputFillType)
                        self:setState( BunkerSilo.STATE_FILL, false )
                    end
                end

                DensityMapHeightUtil.changeFillTypeAtArea(area.sx, area.sz, area.wx, area.wz, area.hx, area.hz, self.inputFillType, self.outputFillType)
            elseif self.fillLevel > 0 and( self.state = = BunkerSilo.STATE_CLOSED or self.state = = BunkerSilo.STATE_FERMENTED) then
                    local area = self.bunkerSiloArea
                    DensityMapHeightUtil.changeFillTypeAtArea(area.sx, area.sz, area.wx, area.wz, area.hx, area.hz, self.inputFillType, self.fermentingFillType)
                elseif self.state = = BunkerSilo.STATE_FILL then
                        local area = self.bunkerSiloArea
                        local fermentingFillLevel, fermentingPixels, totalFermentingPixels = DensityMapHeightUtil.getFillLevelAtArea( self.fermentingFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                        -- Set to fermented state if more than 50% of the area is filled with fermenting fill type
                            if fermentingFillLevel > self.emptyThreshold and fermentingPixels > 0.5 * totalFermentingPixels then
                                local _inputFillLevel, inputPixels, totalInputPixels = DensityMapHeightUtil.getFillLevelAtArea( self.inputFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                                -- Only change if less than 10% is filled with input type(chaff) (ie.the silo is not being filled)
                                    if inputPixels < 0.1 * totalInputPixels then
                                        self:setState( BunkerSilo.STATE_FERMENTED, false )
                                    end
                                end
                            end

                            return true
                        end

```

### new

**Description**

> Creating bunker silo object

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | is server |
|---------|----------|-----------|
| boolean | isClient | is client |
| table?  | customMt | customMt  |

**Return Values**

| table? | instance | Instance of object |
|--------|----------|--------------------|

**Code**

```lua
function BunkerSilo.new(isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or BunkerSilo _mt)

    self.interactionTriggerNode = nil

    self.bunkerSiloArea = { }
    self.bunkerSiloArea.offsetFront = 0
    self.bunkerSiloArea.offsetBack = 0

    self.acceptedFillTypes = { }

    self.inputFillType = FillType.CHAFF
    self.outputFillType = FillType.SILAGE
    self.fermentingFillType = FillType.TARP

    self.isOpenedAtFront = false
    self.isOpenedAtBack = false
    self.distanceToCompactedFillLevel = 100

    self.fermentingPercent = 0 -- float from 0 to 1

    self.fillLevel = 0
    self.compactedFillLevel = 0
    self.compactedPercent = 0 -- specially rounded/snapped integer from 0 to 100
    self.emptyThreshold = 100

    self.playerInRange = false
    self.vehiclesInRange = { }
    self.numVehiclesInRange = 0

    self.siloIsFullWarningTimer = 0
    self.siloIsFullWarningDuration = 2000

    self.updateTimer = 0

    self.activatable = BunkerSiloActivatable.new( self )

    self.state = BunkerSilo.STATE_FILL

    self.bunkerSiloDirtyFlag = self:getNextDirtyFlag()

    g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.onHourChanged, self )

    return self
end

```

### onChangedFillLevelCallback

**Description**

> Called if fill level changed

**Definition**

> onChangedFillLevelCallback(table vehicle, integer fillDelta, integer fillType, , , , )

**Arguments**

| table   | vehicle   | vehicle    |
|---------|-----------|------------|
| integer | fillDelta | fill delta |
| integer | fillType  | fill type  |
| any     | fillType  |            |
| any     | x         |            |
| any     | y         |            |
| any     | z         |            |

**Code**

```lua
function BunkerSilo.onChangedFillLevelCallback( self , vehicle, fillDelta, fillType, x, y, z)
    if fillDelta > = 0 then
        return
    end

    local area = self.bunkerSiloArea
    if x = = nil or y = = nil or z = = nil then
        x, y, z = getWorldTranslation(vehicle.components[ 1 ].node)
    end

    local closerToFront = self:getIsCloserToFront(x, y, z)
    local length = self.openingLength

    if closerToFront then
        if self.isOpenedAtFront then
            local p1 = MathUtil.getProjectOnLineParameter(x,z, area.sx,area.sz, area.dhx_norm,area.dhz_norm)
            if p1 > area.offsetFront - length then
                local offset = self:getBunkerAreaOffset( true , area.offsetFront, self.fermentingFillType)
                local targetOffset = math.max(p1, offset) + length

                self:switchFillTypeAtOffset( true , area.offsetFront, targetOffset - area.offsetFront)
                area.offsetFront = targetOffset
            end
        end
    else
            if self.isOpenedAtBack then
                local p1 = MathUtil.getProjectOnLineParameter(x,z, area.hx,area.hz, - area.dhx_norm, - area.dhz_norm)
                if p1 > area.offsetBack - length then
                    local offset = self:getBunkerAreaOffset( false , area.offsetBack, self.fermentingFillType)
                    local targetOffset = math.max(p1, offset) + length

                    self:switchFillTypeAtOffset( false , area.offsetBack, targetOffset - area.offsetBack)
                    area.offsetBack = targetOffset
                end
            end
        end
    end

```

### onCreate

**Description**

> Creating bunker silo object

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function BunkerSilo:onCreate(id)
    Logging.error( "BunkerSilo.onCreate is deprecated!" )
end

```

### openSilo

**Description**

> Open silo

**Definition**

> openSilo(float px, float py, float pz)

**Arguments**

| float | px | x player position |
|-------|----|-------------------|
| float | py | y player position |
| float | pz | z player position |

**Code**

```lua
function BunkerSilo:openSilo(px,py,pz)
    self:setState( BunkerSilo.STATE_DRAIN, true )

    self.bunkerSiloArea.offsetFront = self:getBunkerAreaOffset( true , 0 , self.fermentingFillType)
    self.bunkerSiloArea.offsetBack = self:getBunkerAreaOffset( false , 0 , self.fermentingFillType)

    -- check which side is closer to player
    local openAtFront = self:getIsCloserToFront(px,py,pz)
    if openAtFront and not self.isOpenedAtFront then
        self:switchFillTypeAtOffset( true , self.bunkerSiloArea.offsetFront, self.openingLength)
        self.isOpenedAtFront = true
        self:raiseDirtyFlags( self.bunkerSiloDirtyFlag)
    elseif not self.isOpenedAtBack then
            self:switchFillTypeAtOffset( false , self.bunkerSiloArea.offsetBack, self.openingLength)
            self.isOpenedAtBack = true
            self:raiseDirtyFlags( self.bunkerSiloDirtyFlag)
        end
    end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function BunkerSilo:readStream(streamId, connection)
    BunkerSilo:superClass().readStream( self , streamId, connection)
    if connection:getIsServer() then
        local state = streamReadUIntN(streamId, 3 )
        self:setState(state)
        self.isOpenedAtFront = streamReadBool(streamId)
        self.isOpenedAtBack = streamReadBool(streamId)
        self.fillLevel = streamReadFloat32(streamId)
        self.compactedPercent = streamReadUIntN(streamId, 7 )
        self.fermentingPercent = NetworkUtil.readCompressedPercentages(streamId)
    end
end

```

### readUpdateStream

**Description**

> Called on client side on update

**Definition**

> readUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function BunkerSilo:readUpdateStream(streamId, timestamp, connection)
    BunkerSilo:superClass().readUpdateStream( self , streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local state = streamReadUIntN(streamId, 3 )
            if state ~ = self.state then
                self:setState(state, true )
            end

            self.fillLevel = streamReadFloat32(streamId)
            self.isOpenedAtFront = streamReadBool(streamId)
            self.isOpenedAtBack = streamReadBool(streamId)

            if self.state = = BunkerSilo.STATE_FILL then
                self.compactedPercent = streamReadUIntN(streamId, 7 )
            elseif self.state = = BunkerSilo.STATE_CLOSED or self.state = = BunkerSilo.STATE_FERMENTED then
                    self.fermentingPercent = NetworkUtil.readCompressedPercentages(streamId)
                end
            end
        end
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
function BunkerSilo.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. "#state" , "Current silo state(FILL = 0, CLOSED = 1, FERMENTED = 2, DRAIN = 3)" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#fillLevel" , "Current fill level" )
    schema:register(XMLValueType.FLOAT, basePath .. "#compactedFillLevel" , "Compacted fill level" )
    schema:register(XMLValueType.FLOAT, basePath .. "#fermentingTime" , "Fermenting time" )
    schema:register(XMLValueType.BOOL, basePath .. "#openedAtFront" , "Is opened at front" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#openedAtBack" , "Is opened at back" , false )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function BunkerSilo.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#startNode" , "Area start node(placed in the middle of the walls)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#widthNode" , "Area width node(placed in the middle of the walls)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#heightNode" , "Area height node(placed in the middle of the walls)" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".innerArea#startNode" , "Inner area start node(Used to detect fill level - placed 25cm from inner walls)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".innerArea#widthNode" , "Inner area width node(Used to detect fill level - placed 25cm from inner walls)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".innerArea#heightNode" , "Inner area height node(Used to detect fill level - placed 25cm from inner walls)" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wallLeft#node" , "Left wall node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wallLeft#collision" , "Left wall collision" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wallRight#node" , "Right wall node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wallRight#collision" , "Right wall collision" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".interactionTrigger#node" , "Interaction trigger node" )
    schema:register(XMLValueType.STRING, basePath .. "#acceptedFillTypes" , "Accepted fill types" , "chaff grass_windrow dryGrass_windrow" )
    schema:register(XMLValueType.STRING, basePath .. "#inputFillType" , "Input fill type" , "chaff" )
    schema:register(XMLValueType.STRING, basePath .. "#outputFillType" , "Output fill type" , "silage" )

    schema:register(XMLValueType.FLOAT, basePath .. "#distanceToCompactedFillLevel" , "Distance to drive on bunker silo for full compaction" , 100 )
        schema:register(XMLValueType.FLOAT, basePath .. "#openingLength" , "Opening length" , 5 )
    end

```

### saveToXMLFile

**Description**

> Save to XML file

**Definition**

> saveToXMLFile(XMLFile xmlFile, string key, table usedModNames)

**Arguments**

| XMLFile | xmlFile      | XMLFile instance       |
|---------|--------------|------------------------|
| string  | key          | key                    |
| table   | usedModNames | list of use dmod names |

**Code**

```lua
function BunkerSilo:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#state" , self.state)
    xmlFile:setValue(key .. "#fillLevel" , self.fillLevel)
    xmlFile:setValue(key .. "#compactedFillLevel" , self.compactedFillLevel)
    xmlFile:setValue(key .. "#fermentingTime" , self.fermentingPercent * BunkerSilo.MILLISECONDS_PER_DAY * g_currentMission.environment.daysPerPeriod)
    xmlFile:setValue(key .. "#openedAtFront" , self.isOpenedAtFront)
    xmlFile:setValue(key .. "#openedAtBack" , self.isOpenedAtBack)
end

```

### setState

**Description**

> Set state

**Definition**

> setState(boolean state, boolean showNotification)

**Arguments**

| boolean | state            | new state         |
|---------|------------------|-------------------|
| boolean | showNotification | show notification |

**Code**

```lua
function BunkerSilo:setState(state, showNotification)
    if state ~ = self.state then
        if state = = BunkerSilo.STATE_FILL then
            self.fermentingPercent = 0
            self.compactedFillLevel = 0
            self.compactedPercent = 0
            self.isOpenedAtFront = false
            self.isOpenedAtBack = false
            self.bunkerSiloArea.offsetFront = 0
            self.bunkerSiloArea.offsetBack = 0

            if showNotification then
                self:showBunkerMessage(g_i18n:getText( "ingameNotification_bunkerSiloIsEmpty" ))
            end

            if self.isServer then
                g_densityMapHeightManager:removeFixedFillTypesArea( self.bunkerSiloArea)
                g_densityMapHeightManager:setConvertingFillTypeAreas( self.bunkerSiloArea, self.acceptedFillTypes, self.inputFillType)
            end

        elseif state = = BunkerSilo.STATE_CLOSED then
                -- change fillType
                local area = self.bunkerSiloArea
                local offsetFront = self:getBunkerAreaOffset( true , 0 , self.inputFillType)
                local offsetBack = self:getBunkerAreaOffset( false , 0 , self.inputFillType)

                local x0 = area.sx + (offsetFront * area.dhx_norm)
                local z0 = area.sz + (offsetFront * area.dhz_norm)
                local x1 = x0 + area.dwx
                local z1 = z0 + area.dwz
                local x2 = area.sx + area.dhx - (offsetBack * area.dhx_norm)
                local z2 = area.sz + area.dhz - (offsetBack * area.dhz_norm)

                if self.isServer then
                    local _changed = DensityMapHeightUtil.changeFillTypeAtArea(x0,z0, x1,z1, x2,z2, self.inputFillType, self.fermentingFillType)

                    g_densityMapHeightManager:removeFixedFillTypesArea( self.bunkerSiloArea)
                    g_densityMapHeightManager:removeConvertingFillTypeAreas( self.bunkerSiloArea)
                end

                -- remove tire tracks and remove displacement for smooth heap
                    g_currentMission.tireTrackSystem:eraseParallelogram(x0,z0, x1,z1, x2,z2)
                    FSDensityMapUtil.resetDisplacementArea(x0,z0, x1,z1, x2,z2)

                    if showNotification then
                        self:showBunkerMessage(g_i18n:getText( "ingameNotification_bunkerSiloCovered" ))
                    end

                elseif state = = BunkerSilo.STATE_FERMENTED then

                        if showNotification then
                            self:showBunkerMessage(g_i18n:getText( "ingameNotification_bunkerSiloDoneFermenting" ))
                        end

                    elseif state = = BunkerSilo.STATE_DRAIN then

                            self.bunkerSiloArea.offsetFront = 0
                            self.bunkerSiloArea.offsetBack = 0

                            if showNotification then
                                self:showBunkerMessage(g_i18n:getText( "ingameNotification_bunkerSiloOpened" ))
                            end

                            if self.isServer then
                                g_densityMapHeightManager:removeConvertingFillTypeAreas( self.bunkerSiloArea)
                                local fillTypes = { }
                                fillTypes[ self.outputFillType] = true
                                g_densityMapHeightManager:setFixedFillTypesArea( self.bunkerSiloArea, fillTypes)
                            end

                        end

                        self.state = state
                        if self.isServer then
                            self:raiseDirtyFlags( self.bunkerSiloDirtyFlag)
                        end
                    end
                end

```

### switchFillTypeAtOffset

**Description**

> Switch fill type at offset

**Definition**

> switchFillTypeAtOffset(boolean switchAtFront, float offset, float length)

**Arguments**

| boolean | switchAtFront | switch at front |
|---------|---------------|-----------------|
| float   | offset        | offset          |
| float   | length        | length          |

**Code**

```lua
function BunkerSilo:switchFillTypeAtOffset(switchAtFront, offset, length)

    local fillType = self.fermentingFillType
    local newFillType = self.outputFillType

    local a0x, a0z
    local a1x, a1z
    local a2x, a2z

    local area = self.bunkerSiloArea

    if switchAtFront then
        a0x, a0z = area.sx + (offset * area.dhx_norm), area.sz + (offset * area.dhz_norm)
        a1x, a1z = a0x + area.dwx, a0z + area.dwz
        a2x, a2z = area.sx + ((offset + length) * area.dhx_norm), area.sz + ((offset + length) * area.dhz_norm)
    else
            a0x, a0z = area.hx - (offset * area.dhx_norm), area.hz - (offset * area.dhz_norm)
            a1x, a1z = a0x + area.dwx, a0z + area.dwz
            a2x, a2z = area.hx - ((offset + length) * area.dhx_norm), area.hz - ((offset + length) * area.dhz_norm)
        end

        DensityMapHeightUtil.changeFillTypeAtArea(a0x,a0z, a1x,a1z, a2x,a2z, fillType, newFillType)

    end

```

### update

**Description**

> Update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function BunkerSilo:update(dt)
    if self:getCanInteract( true ) then
        local fillTypeIndex = self.inputFillType
        if self.state = = BunkerSilo.STATE_CLOSED or self.state = = BunkerSilo.STATE_FERMENTED or self.state = = BunkerSilo.STATE_DRAIN then
            fillTypeIndex = self.outputFillType
        end
        local fillTypeName = ""
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        if fillType ~ = nil then
            fillTypeName = fillType.title
        end

        g_currentMission:addExtraPrintText( string.format( "%s %s: %d" , g_i18n:getText( "info_fillLevel" ), fillTypeName, self.fillLevel))

        if self.state = = BunkerSilo.STATE_FILL then
            g_currentMission:addExtraPrintText( string.format( "%s %d%%" , g_i18n:getText( "info_compacting" ), self.compactedPercent))
        elseif self.state = = BunkerSilo.STATE_CLOSED or self.state = = BunkerSilo.STATE_FERMENTED then
                g_currentMission:addExtraPrintText( string.format( "%s %d%%" , g_i18n:getText( "info_fermenting" ), math.ceil( self.fermentingPercent * 100 )))
            end
        end

        if self.isServer then
            if self.state = = BunkerSilo.STATE_FILL then
                for vehicle,state in pairs( self.vehiclesInRange) do
                    if state then
                        if vehicle:getIsActive() then
                            local distance = vehicle.lastMovedDistance
                            if distance > 0 then
                                local mass = vehicle:getTotalMass( false )

                                local compactingFactor = (mass / BunkerSilo.COMPACTING_BASE_MASS)

                                local compactingScale = 1
                                if vehicle.getBunkerSiloCompacterScale ~ = nil then
                                    compactingScale = vehicle:getBunkerSiloCompacterScale() or compactingScale
                                end
                                compactingFactor = compactingFactor * compactingScale

                                local deltaCompact = distance * compactingFactor * self.distanceToCompactedFillLevel

                                if vehicle.getWheels ~ = nil then
                                    local wheels = vehicle:getWheels()
                                    local numWheels = #wheels
                                    if numWheels > 0 then
                                        local wheelsOnSilo = 0
                                        local wheelsInAir = 0
                                        for _, wheel in ipairs(wheels) do
                                            if wheel.physics.contact = = WheelContactType.GROUND_HEIGHT then
                                                wheelsOnSilo = wheelsOnSilo + 1
                                            elseif wheel.physics.contact = = WheelContactType.NONE then
                                                    wheelsInAir = wheelsInAir + 1
                                                end
                                            end
                                            if wheelsOnSilo > 0 then
                                                deltaCompact = deltaCompact * ((wheelsOnSilo + wheelsInAir) / numWheels)
                                            else
                                                    deltaCompact = 0
                                                end
                                            else
                                                    -- vehicles without wheels are not allowed to compact(e.g.levelers)
                                                    deltaCompact = 0
                                                end
                                            end

                                            if deltaCompact > 0 then
                                                local compactedFillLevel = math.min( self.compactedFillLevel + deltaCompact, self.fillLevel)
                                                if compactedFillLevel ~ = self.compactedFillLevel then
                                                    self:updateCompacting(compactedFillLevel)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- for chaff tutorial:always take the highest fill level of all bunker silos
                        if g_currentMission ~ = nil and g_currentMission.bunkerScore ~ = nil then
                            if g_currentMission.bunkerScore < self.fillLevel then
                                g_currentMission.bunkerScore = self.fillLevel
                            end
                        end

                        self:raiseActive()
                    end

```

### updateFillLevel

**Description**

> Update fill level

**Definition**

> updateFillLevel()

**Code**

```lua
function BunkerSilo:updateFillLevel()
    local area = self.bunkerSiloArea.inner
    local fillLevel = self.fillLevel
    local fillType = self.inputFillType

    if fillType ~ = FillType.UNKNOWN then
        if self.state = = BunkerSilo.STATE_FILL then
            fillLevel = DensityMapHeightUtil.getFillLevelAtArea(fillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
        elseif self.state = = BunkerSilo.STATE_CLOSED then
                fillLevel = DensityMapHeightUtil.getFillLevelAtArea( self.fermentingFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
            elseif self.state = = BunkerSilo.STATE_FERMENTED then
                    local fillLevel1 = DensityMapHeightUtil.getFillLevelAtArea( self.fermentingFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                    local fillLevel2 = DensityMapHeightUtil.getFillLevelAtArea( self.outputFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                    fillLevel = fillLevel1 + fillLevel2
                elseif self.state = = BunkerSilo.STATE_DRAIN then
                        local fillLevel1 = DensityMapHeightUtil.getFillLevelAtArea( self.fermentingFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                        local fillLevel2 = DensityMapHeightUtil.getFillLevelAtArea( self.outputFillType, area.sx,area.sz, area.wx,area.wz, area.hx,area.hz)
                        fillLevel = fillLevel1 + fillLevel2
                        if fillLevel < self.emptyThreshold then
                            DensityMapHeightUtil.removeFromGroundByArea(area.sx,area.sz, area.wx,area.wz, area.hx,area.hz, self.fermentingFillType)
                            DensityMapHeightUtil.removeFromGroundByArea(area.sx,area.sz, area.wx,area.wz, area.hx,area.hz, self.outputFillType)
                            self:setState( BunkerSilo.STATE_FILL, true )
                        end
                    end
                end

                self.fillLevel = fillLevel
            end

```

### updateTick

**Description**

> UpdateTick

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function BunkerSilo:updateTick(dt)
    if self.isServer then
        self.updateTimer = self.updateTimer - dt
        if self.updateTimer < = 0 then
            self.updateTimer = 200 + math.random() * 100 -- update every 200 to 300ms

            local oldFillLevel = self.fillLevel
            self:updateFillLevel()
            if oldFillLevel ~ = self.fillLevel then
                self:updateCompacting( self.compactedFillLevel)
            end
        end
    end
    if not self.adjustedOpeningLength then
        self.adjustedOpeningLength = true
        self.openingLength = math.max( self.openingLength, DensityMapHeightUtil.getDefaultMaxRadius( self.outputFillType) + 1 )
    end
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function BunkerSilo:writeStream(streamId, connection)
    BunkerSilo:superClass().writeStream( self , streamId, connection)
    if not connection:getIsServer() then
        streamWriteUIntN(streamId, self.state, 3 )
        streamWriteBool(streamId, self.isOpenedAtFront)
        streamWriteBool(streamId, self.isOpenedAtBack)
        streamWriteFloat32(streamId, self.fillLevel)
        streamWriteUIntN(streamId, self.compactedPercent, 7 )
        NetworkUtil.writeCompressedPercentages(streamId, self.fermentingPercent)
    end
end

```

### writeUpdateStream

**Description**

> Called on server side on update

**Definition**

> writeUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function BunkerSilo:writeUpdateStream(streamId, connection, dirtyMask)
    BunkerSilo:superClass().writeUpdateStream( self , streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, self.bunkerSiloDirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, self.state, 3 )

            streamWriteFloat32(streamId, self.fillLevel)
            streamWriteBool(streamId, self.isOpenedAtFront)
            streamWriteBool(streamId, self.isOpenedAtBack)

            if self.state = = BunkerSilo.STATE_FILL then
                streamWriteUIntN(streamId, self.compactedPercent, 7 )
            elseif self.state = = BunkerSilo.STATE_CLOSED or self.state = = BunkerSilo.STATE_FERMENTED then
                    NetworkUtil.writeCompressedPercentages(streamId, self.fermentingPercent)
                end
            end
        end
    end

```