## WorkArea

**Description**

> Specialization for work areas providing wrapper environment to allow vehicles to interact with the
> foliage/terrainDetail

**Functions**

- [checkMovingPartDirtyUpdateNode](#checkmovingpartdirtyupdatenode)
- [getAIWorkAreaWidth](#getaiworkareawidth)
- [getImplementAllowAutomaticSteering](#getimplementallowautomaticsteering)
- [getIsAccessibleAtWorldPosition](#getisaccessibleatworldposition)
- [getIsFarmlandNotOwnedWarningShown](#getisfarmlandnotownedwarningshown)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsTypedWorkAreaActive](#getistypedworkareaactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getIsWorkAreaProcessing](#getisworkareaprocessing)
- [getLastTouchedFarmlandFarmId](#getlasttouchedfarmlandfarmid)
- [getTypedNetworkAreas](#gettypednetworkareas)
- [getTypedWorkAreas](#gettypedworkareas)
- [getWorkAreaByIndex](#getworkareabyindex)
- [getWorkAreaWidth](#getworkareawidth)
- [initSpecialization](#initspecialization)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onLoad](#onload)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerWorkAreaXMLPaths](#registerworkareaxmlpaths)
- [updateLastWorkedArea](#updatelastworkedarea)
- [updateWorkAreaWidth](#updateworkareawidth)

### checkMovingPartDirtyUpdateNode

**Description**

**Definition**

> checkMovingPartDirtyUpdateNode()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | node       |
| any | movingPart |

**Code**

```lua
function WorkArea:checkMovingPartDirtyUpdateNode(superFunc, node, movingPart)
    superFunc( self , node, movingPart)

    local spec = self.spec_workArea
    for i = 1 , #spec.workAreas do
        local workArea = spec.workAreas[i]
        if node = = workArea.start or node = = workArea.width or node = = workArea.height then
            Logging.xmlError( self.xmlFile, "Found work area node '%s' in active dirty moving part '%s' with limited update distance.Remove limit or adjust hierarchy for correct function. (maxUpdateDistance = '-')" , getName(node), getName(movingPart.node))
            end

            if workArea.groundReferenceNode ~ = nil then
                if node = = workArea.groundReferenceNode.node then
                    Logging.xmlError( self.xmlFile, "Found ground reference node '%s' in active dirty moving part '%s' with limited update distance.Remove limit or adjust hierarchy for correct function. (maxUpdateDistance = '-')" , getName(node), getName(movingPart.node))
                    end
                end
            end
        end

```

### getAIWorkAreaWidth

**Description**

> Returns the maximum width of any AI work area

**Definition**

> getAIWorkAreaWidth()

**Code**

```lua
function WorkArea:getAIWorkAreaWidth()
    local workingWidth = 0
    for _, workArea in pairs( self.spec_workArea.workAreas) do
        if g_workAreaTypeManager:getWorkAreaTypeIsAIArea(workArea.type ) then
            workingWidth = math.max(workArea.workWidth, workingWidth)
        end
    end

    return workingWidth
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
function WorkArea:getImplementAllowAutomaticSteering(superFunc)
    local spec = self.spec_workArea
    for _, workArea in ipairs(spec.workAreas) do
        if g_workAreaTypeManager:getWorkAreaTypeIsSteeringAssistArea(workArea.type ) then
            return true
        end
    end

    return superFunc( self )
end

```

### getIsAccessibleAtWorldPosition

**Description**

**Definition**

> getIsAccessibleAtWorldPosition(boolean accessible, integer landowner, boolean isBuyable, )

**Arguments**

| boolean | accessible   | true if farmland is accessible for current farmid |
|---------|--------------|---------------------------------------------------|
| integer | landowner    | farmid of current landowner                       |
| boolean | isBuyable    | true if farmland is buyable                       |
| any     | workAreaType |                                                   |

**Code**

```lua
function WorkArea:getIsAccessibleAtWorldPosition(farmId, x, z, workAreaType)
    -- Disallow mission vehicles outside mission fields
    if self.propertyState = = VehiclePropertyState.MISSION then
        return g_missionManager:getIsMissionWorkAllowed(farmId, x, z, workAreaType, self ), farmId, true
    end

    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)
    if farmlandId = = nil then -- no valid farmland, or not buyable
        return false , nil , false
    end

    if farmlandId = = FarmlandManager.NOT_BUYABLE_FARM_ID then
        return false , FarmlandManager.NO_OWNER_FARM_ID, false
    end

    local landOwner = g_farmlandManager:getFarmlandOwner(farmlandId)
    local accessible = (landOwner ~ = 0 and g_currentMission.accessHandler:canFarmAccessOtherId(farmId, landOwner))
    or g_missionManager:getIsMissionWorkAllowed(farmId, x, z, workAreaType, self )

    return accessible, landOwner, true
end

```

### getIsFarmlandNotOwnedWarningShown

**Description**

**Definition**

> getIsFarmlandNotOwnedWarningShown()

**Code**

```lua
function WorkArea:getIsFarmlandNotOwnedWarningShown()
    return self.spec_workArea.showFarmlandNotOwnedWarning
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
function WorkArea:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    if speedRotatingPart.workAreaIndex ~ = nil then
        local spec = self.spec_workArea
        local workArea = spec.workAreas[speedRotatingPart.workAreaIndex]
        if workArea = = nil then
            speedRotatingPart.workAreaIndex = nil
            Logging.xmlWarning( self.xmlFile, "Invalid workAreaIndex '%s'.Indexing starts with 1!" , tostring(speedRotatingPart.workAreaIndex))
            return true
        end

        if not self:getIsWorkAreaProcessing(spec.workAreas[speedRotatingPart.workAreaIndex]) then
            return false
        end
    end

    return superFunc( self , speedRotatingPart)
end

```

### getIsTypedWorkAreaActive

**Description**

> Returns if at least one area from type is active

**Definition**

> getIsTypedWorkAreaActive(integer areaType)

**Arguments**

| integer | areaType | area type |
|---------|----------|-----------|

**Return Values**

| integer | isActive       | isActive              |
|---------|----------------|-----------------------|
| integer | typedWorkAreas | areas from given type |

**Code**

```lua
function WorkArea:getIsTypedWorkAreaActive(areaType)
    local isActive = false
    local typedWorkAreas = self:getTypedWorkAreas(areaType)
    for _, workArea in pairs(typedWorkAreas) do
        if self:getIsWorkAreaActive(workArea) then
            isActive = true
            break
        end
    end

    return isActive, typedWorkAreas
end

```

### getIsWorkAreaActive

**Description**

> Returns true if work area is active

**Definition**

> getIsWorkAreaActive(table workArea)

**Arguments**

| table | workArea | workArea |
|-------|----------|----------|

**Return Values**

| table | isActive | work area is active |
|-------|----------|---------------------|

**Code**

```lua
function WorkArea:getIsWorkAreaActive(workArea)
    if workArea.requiresGroundContact = = true and workArea.groundReferenceNode ~ = nil then
        if not self:getIsGroundReferenceNodeActive(workArea.groundReferenceNode) then
            return false
        end
    end

    if workArea.disableBackwards then
        if self.movingDirection < = 0 then
            return false
        end
    end

    if workArea.onlyActiveWhenLowered then
        if self.getIsLowered ~ = nil then
            if not self:getIsLowered( false ) then
                return false
            end
        end
    end

    return true
end

```

### getIsWorkAreaProcessing

**Description**

> Returns true if work area is processing

**Definition**

> getIsWorkAreaProcessing(table workArea)

**Arguments**

| table | workArea | workArea |
|-------|----------|----------|

**Code**

```lua
function WorkArea:getIsWorkAreaProcessing(workArea)
    return workArea.lastProcessingTime + 200 > = g_currentMission.time
end

```

### getLastTouchedFarmlandFarmId

**Description**

**Definition**

> getLastTouchedFarmlandFarmId()

**Code**

```lua
function WorkArea:getLastTouchedFarmlandFarmId()
    local spec = self.spec_workArea

    if spec.lastAccessedFarmlandOwner ~ = 0 then
        return spec.lastAccessedFarmlandOwner
    end

    return 0
end

```

### getTypedNetworkAreas

**Description**

> Returns positions of active work areas by type

**Definition**

> getTypedNetworkAreas(integer areaType, boolean needsFieldProperty)

**Arguments**

| integer | areaType           | area type            |
|---------|--------------------|----------------------|
| boolean | needsFieldProperty | needs field property |

**Return Values**

| boolean | workAreasSend               | work areas send              |
|---------|-----------------------------|------------------------------|
| boolean | showFarmlandNotOwnedWarning | show field not owned warning |
| boolean | area                        | size of areas                |

**Code**

```lua
function WorkArea:getTypedNetworkAreas(areaType, needsFieldProperty)
    local workAreasSend = { }
    local area = 0
    local typedWorkAreas = self:getTypedWorkAreas(areaType)
    local showFarmlandNotOwnedWarning = false

    for _, workArea in pairs(typedWorkAreas) do
        if self:getIsWorkAreaActive(workArea) then
            local x,_,z = getWorldTranslation(workArea.start)

            local isAccessible = not needsFieldProperty
            if needsFieldProperty then
                local farmId = g_currentMission:getFarmId()
                isAccessible = g_currentMission.accessHandler:canFarmAccessLand(farmId, x, z) or g_missionManager:getIsMissionWorkAllowed(farmId, x, z, areaType, self )
            end

            if isAccessible then
                local x1,_,z1 = getWorldTranslation(workArea.width)
                local x2,_,z2 = getWorldTranslation(workArea.height)
                area = area + math.abs((z1 - z) * (x2 - x) - (x1 - x) * (z2 - z))
                table.insert(workAreasSend, { x,z,x1,z1,x2,z2 } )
            else
                    showFarmlandNotOwnedWarning = true
                end
            end
        end

        return workAreasSend, showFarmlandNotOwnedWarning, area
    end

```

### getTypedWorkAreas

**Description**

> Returns areas by type

**Definition**

> getTypedWorkAreas(integer areaType)

**Arguments**

| integer | areaType | area type |
|---------|----------|-----------|

**Return Values**

| integer | workAreas | work areas |
|---------|-----------|------------|

**Code**

```lua
function WorkArea:getTypedWorkAreas(areaType)
    local spec = self.spec_workArea
    local workAreas = spec.workAreaByType[areaType]
    if workAreas = = nil then
        workAreas = { }
    end

    return workAreas
end

```

### getWorkAreaByIndex

**Description**

**Definition**

> getWorkAreaByIndex()

**Arguments**

| any | workAreaIndex |
|-----|---------------|

**Code**

```lua
function WorkArea:getWorkAreaByIndex(workAreaIndex)
    local spec = self.spec_workArea
    return spec.workAreas[workAreaIndex]
end

```

### getWorkAreaWidth

**Description**

> Returns last calculated work area width

**Definition**

> getWorkAreaWidth(integer workAreaIndex)

**Arguments**

| integer | workAreaIndex | index of work area |
|---------|---------------|--------------------|

**Code**

```lua
function WorkArea:getWorkAreaWidth(workAreaIndex)
    local spec = self.spec_workArea
    return spec.workAreas[workAreaIndex].workWidth
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function WorkArea.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "default" , false , false , false )
    g_workAreaTypeManager:addWorkAreaType( "auxiliary" , false , false , false )

    g_vehicleConfigurationManager:addConfigurationType( "workArea" , g_i18n:getText( "configuration_workArea" ), "workAreas" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "WorkArea" )

    WorkArea.registerWorkAreaXMLPaths(schema, WorkArea.WORK_AREA_XML_KEY)
    WorkArea.registerWorkAreaXMLPaths(schema, WorkArea.WORK_AREA_XML_CONFIG_KEY)

    schema:register(XMLValueType.INT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#workAreaIndex" , "Work area index" )

    schema:setXMLSpecializationType()
end

```

### loadSpeedRotatingPartFromXML

**Description**

> Loads speed rotating parts from xml

**Definition**

> loadSpeedRotatingPartFromXML(table speedRotatingPart, XMLFile xmlFile, string key, )

**Arguments**

| table   | speedRotatingPart | speedRotatingPart |
|---------|-------------------|-------------------|
| XMLFile | xmlFile           | XMLFile instance  |
| string  | key               | key               |
| any     | key               |                   |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function WorkArea:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.workAreaIndex = xmlFile:getValue(key .. "#workAreaIndex" )

    return true
end

```

### loadWorkAreaFromXML

**Description**

> Loads work areas from xml

**Definition**

> loadWorkAreaFromXML(table workArea, XMLFile xmlFile, string key)

**Arguments**

| table   | workArea | workArea         |
|---------|----------|------------------|
| XMLFile | xmlFile  | XMLFile instance |
| string  | key      | key              |

**Return Values**

| string | success | success |
|--------|---------|---------|

**Code**

```lua
function WorkArea:loadWorkAreaFromXML(workArea, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".area#startIndex" , key .. ".area#startNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".area#widthIndex" , key .. ".area#widthNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".area#heightIndex" , key .. ".area#heightNode" ) --FS17 to FS19

    local start = xmlFile:getValue(key .. ".area#startNode" , workArea.start, self.components, self.i3dMappings)
    local width = xmlFile:getValue(key .. ".area#widthNode" , workArea.width, self.components, self.i3dMappings)
    local height = xmlFile:getValue(key .. ".area#heightNode" , workArea.height, self.components, self.i3dMappings)

    if start ~ = nil and width ~ = nil and height ~ = nil then
        if calcDistanceFrom(start, width) < 0.001 then
            Logging.xmlError(xmlFile, "'start' and 'width' have the same position for '%s'!" , key)
                return false
            end
            if calcDistanceFrom(width, height) < 0.001 then
                Logging.xmlError(xmlFile, "'width' and 'height' have the same position for '%s'!" , key)
                    return false
                end

                local areaTypeStr = xmlFile:getValue(key .. "#type" )
                workArea.type = g_workAreaTypeManager:getWorkAreaTypeIndexByName(areaTypeStr) or WorkAreaType.DEFAULT

                if workArea.type = = nil then
                    Logging.xmlWarning(xmlFile, "Invalid workArea type '%s' for workArea '%s'!" , areaTypeStr, key)
                        return false
                    end

                    workArea.requiresGroundContact = xmlFile:getValue(key .. "#requiresGroundContact" , true )

                    if workArea.type ~ = WorkAreaType.AUXILIARY then

                        if workArea.requiresGroundContact then
                            XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#refNodeIndex" , key .. ".groundReferenceNode#index" ) --FS17 to FS19
                            local groundReferenceNodeIndex = xmlFile:getValue(key .. ".groundReferenceNode#index" )
                            if groundReferenceNodeIndex = = nil then
                                Logging.xmlWarning(xmlFile, "Missing groundReference 'groundReferenceNode#index' for workArea '%s'.Add requiresGroundContact = \" false \ " if groundContact is not required!" , key)
                                    return false
                                end
                                local groundReferenceNode = self:getGroundReferenceNodeFromIndex(groundReferenceNodeIndex)
                                if groundReferenceNode ~ = nil then
                                    workArea.groundReferenceNode = groundReferenceNode
                                else
                                        Logging.xmlWarning(xmlFile, "Invalid groundReferenceNode-index for workArea '%s'!" , key)
                                            return false
                                        end
                                    end

                                    workArea.disableBackwards = xmlFile:getValue(key .. "#disableBackwards" , true )
                                    workArea.onlyActiveWhenLowered = xmlFile:getValue(key .. ".onlyActiveWhenLowered#value" , false )

                                    workArea.functionName = xmlFile:getValue(key .. "#functionName" )
                                    if workArea.functionName = = nil then
                                        Logging.xmlWarning(xmlFile, "Missing 'functionName' for workArea '%s'!" , key)
                                            return false
                                        else
                                                if self [workArea.functionName] = = nil then
                                                    Logging.xmlWarning(xmlFile, "Given functionName '%s' not defined.Please add missing function or specialization!" , tostring(workArea.functionName))
                                                        return false
                                                    end
                                                    workArea.processingFunction = self [workArea.functionName]
                                                end

                                                if g_isDevelopmentVersion then
                                                    if not SpecializationUtil.hasSpecialization( Cutter , self.specializations)
                                                        and not SpecializationUtil.hasSpecialization( Pickup , self.specializations)
                                                        and not SpecializationUtil.hasSpecialization( Drivable , self.specializations)
                                                        and xmlFile:getString(key .. ".onlyActiveWhenLowered#value" ) = = nil then
                                                        Logging.xmlDevWarning(xmlFile, "Work area has no 'onlyActiveWhenLowered' attribute set! '%s'" , key)
                                                    end
                                                end

                                                workArea.preprocessFunctionName = xmlFile:getValue(key .. "#preprocessFunctionName" )
                                                if workArea.preprocessFunctionName ~ = nil then
                                                    if self [workArea.preprocessFunctionName] = = nil then
                                                        Logging.xmlWarning(xmlFile, "Given preprocessFunctionName '%s' not defined.Please add missing function or specialization!" , tostring(workArea.preprocessFunctionName))
                                                            return false
                                                        end
                                                        workArea.preprocessingFunction = self [workArea.preprocessFunctionName]
                                                    end

                                                    workArea.postprocessFunctionName = xmlFile:getValue(key .. "#postprocessFunctionName" )
                                                    if workArea.postprocessFunctionName ~ = nil then
                                                        if self [workArea.postprocessFunctionName] = = nil then
                                                            Logging.xmlWarning(xmlFile, "Given postprocessFunctionName '%s' not defined.Please add missing function or specialization!" , tostring(workArea.postprocessFunctionName))
                                                                return false
                                                            end
                                                            workArea.postprocessingFunction = self [workArea.postprocessFunctionName]
                                                        end

                                                        workArea.requiresOwnedFarmland = xmlFile:getValue(key .. "#requiresOwnedFarmland" , true )
                                                    end

                                                    workArea.lastProcessingTime = 0
                                                    workArea.start = start
                                                    workArea.width = width
                                                    workArea.height = height

                                                    workArea.workWidth = - 1

                                                    return true
                                                end

                                                return false
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
function WorkArea:onLoad(savegame)
    local spec = self.spec_workArea

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#startIndex" , "vehicle.workAreas.workArea(0).area#startIndex" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#widthIndex" , "vehicle.workAreas.workArea(0).area#widthIndex" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#heightIndex" , "vehicle.workAreas.workArea(0).area#heightIndex" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#foldMinLimit" , "vehicle.workAreas.workArea(0).folding#minLimit" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#foldMaxLimit" , "vehicle.workAreas.workArea(0).folding#maxLimit" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.workAreas.workArea(0)#refNodeIndex" , "vehicle.workAreas.workArea(0).groundReferenceNode#index" ) --FS17 to FS19

    local configurationId = Utils.getNoNil( self.configurations[ "workArea" ], 1 )
    local configKey = string.format( "vehicle.workAreas.workAreaConfigurations.workAreaConfiguration(%d)" , configurationId - 1 )

    if not self.xmlFile:hasProperty(configKey) then
        configKey = "vehicle.workAreas"
    end

    spec.workAreas = { }
    local i = 0
    while true do
        local key = string.format( "%s.workArea(%d)" , configKey, i)
        if not self.xmlFile:hasProperty(key) then
            break
        end
        local workArea = { }
        if self:loadWorkAreaFromXML(workArea, self.xmlFile, key) then
            table.insert(spec.workAreas, workArea)
            workArea.index = #spec.workAreas

            self:updateWorkAreaWidth(workArea.index)
        end

        i = i + 1
    end

    spec.workAreaByType = { }
    for _, area in pairs(spec.workAreas) do
        if spec.workAreaByType[area.type ] = = nil then
            spec.workAreaByType[area.type ] = { }
        end
        table.insert(spec.workAreaByType[area.type ], area)
    end

    spec.lastAccessedFarmlandOwner = 0
    spec.lastWorkedArea = - 1
    spec.showFarmlandNotOwnedWarning = false
    spec.warningCantUseMissionVehiclesOnOtherLand = g_i18n:getText( "warning_cantUseMissionVehiclesOnOtherLand" )
    spec.warningYouDontHaveAccessToThisLand = g_i18n:getText( "warning_youDontHaveAccessToThisLand" )
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
function WorkArea:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_workArea
    SpecializationUtil.raiseEvent( self , "onStartWorkAreaProcessing" , dt, spec.workAreas)

    spec.showFarmlandNotOwnedWarning = false
    -- do not reset last accessed farmland owner
        -- spec.lastAccessedFarmlandOwner = 0
        local hasProcessed = false

        local farmId = self:getActiveFarm()
        if farmId = = nil then -- Shop
            farmId = AccessHandler.EVERYONE
        end

        local isOwned = false
        local isBuyable = false
        local allowWarning = false
        for i = 1 , #spec.workAreas do
            local workArea = spec.workAreas[i]
            if workArea.type ~ = WorkAreaType.AUXILIARY then
                workArea.lastWorkedHectares = 0

                local isAreaActive = self:getIsWorkAreaActive(workArea)
                if isAreaActive and workArea.requiresOwnedFarmland then
                    local xs,_,zs = getWorldTranslation(workArea.start)
                    local isAccessible, farmlandOwner, buyable = self:getIsAccessibleAtWorldPosition(farmId, xs, zs, workArea.type )
                    isBuyable = isBuyable or buyable
                    if isAccessible then
                        if farmlandOwner ~ = nil then
                            spec.lastAccessedFarmlandOwner = farmlandOwner
                        end
                        isOwned = true
                    else
                            local xw,_,zw = getWorldTranslation(workArea.width)
                            isAccessible, _, buyable = self:getIsAccessibleAtWorldPosition(farmId, xw, zw, workArea.type )
                            isBuyable = isBuyable or buyable
                            if isAccessible then
                                isOwned = true
                            else
                                    local xh,_,zh = getWorldTranslation(workArea.height)
                                    isAccessible, _, buyable = self:getIsAccessibleAtWorldPosition(farmId, xh, zh, workArea.type )
                                    isBuyable = isBuyable or buyable
                                    if isAccessible then
                                        isOwned = true
                                    else
                                            local x = xw + (xh - xs)
                                            local z = zw + (zh - zs)
                                            isAccessible, _, buyable = self:getIsAccessibleAtWorldPosition(farmId, x, z, workArea.type )
                                            isBuyable = isBuyable or buyable
                                            if isAccessible then
                                                isOwned = true
                                            end
                                        end
                                    end
                                end

                                if not isOwned then
                                    isAreaActive = false
                                end

                                allowWarning = isBuyable
                            end

                            if isAreaActive then
                                if workArea.preprocessingFunction ~ = nil then
                                    workArea.preprocessingFunction( self , workArea, dt)
                                end

                                if workArea.processingFunction ~ = nil then
                                    local realArea, _ = workArea.processingFunction( self , workArea, dt)

                                    if realArea > 0 then
                                        workArea.lastWorkedHectares = MathUtil.areaToHa(realArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m

                                        workArea.lastProcessingTime = g_currentMission.time

                                        -- Adding an area of interest for the wildlife spawners / keep(xw,zw) and(xh,zh)
                                            --if g_currentMission.wildlifeManager ~ = nil then
                                                -- local workAreaType = g_workAreaTypeManager:getWorkAreaTypeByIndex(workArea.type)
                                                -- if workAreaType.attractWildlife then
                                                    -- local xw,_,zw = getWorldTranslation(workArea.width)
                                                    -- local xh,_,zh = getWorldTranslation(workArea.height)
                                                    --
                                                    -- local posX = 0.5 * xw + 0.5 * xh
                                                    -- local posZ = 0.5 * zw + 0.5 * zh
                                                    -- g_currentMission.wildlifeManager:createHotspot(posX, nil, posZ, workArea.workWidth / 2, WildlifeHotspot.HOTSPOT_TYPE_ENUM.FIELD_SEEDS)
                                                    -- end
                                                    --end
                                                else
                                                        workArea.lastWorkedHectares = 0
                                                    end
                                                end

                                                if workArea.postprocessingFunction ~ = nil then
                                                    workArea.postprocessingFunction( self , workArea, dt)
                                                end

                                                hasProcessed = true
                                            end
                                        end
                                    end

                                    -- display warning if none of the work areas got valid owned ground
                                        if allowWarning and not isOwned and isActiveForInput then
                                            spec.showFarmlandNotOwnedWarning = true

                                            -- display the warning already via update, so it does not rely on vehicle selection

                                            -- If this vehicle is a mission vehicle, the land-not-owned warning only shows when not working the mission field
                                            -- that could be because the land is unowned by the player but not for, or the vehicle is being used on owned land,
                                                -- which is not allowed to prevent cheating with free vehicles.Therefor, if this is a mission vehicle, we
                                                    -- show a different warning
                                                    if self.propertyState = = VehiclePropertyState.MISSION then
                                                        g_currentMission:showBlinkingWarning(spec.warningCantUseMissionVehiclesOnOtherLand)
                                                    else
                                                            g_currentMission:showBlinkingWarning(spec.warningYouDontHaveAccessToThisLand)
                                                        end
                                                    end

                                                    SpecializationUtil.raiseEvent( self , "onEndWorkAreaProcessing" , dt, hasProcessed)

                                                    if spec.lastWorkedArea > = 0 then
                                                        local statsFarmId = self:getLastTouchedFarmlandFarmId()
                                                        local ha = MathUtil.areaToHa(spec.lastWorkedArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m

                                                        g_farmManager:updateFarmStats(statsFarmId, "workedHectares" , ha)
                                                        g_farmManager:updateFarmStats(statsFarmId, "workedTime" , dt / ( 1000 * 60 ))

                                                        spec.lastWorkedArea = - 1
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
function WorkArea.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( GroundReference , specializations)
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
function WorkArea.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , WorkArea )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , WorkArea )
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
function WorkArea.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onStartWorkAreaProcessing" )
    SpecializationUtil.registerEvent(vehicleType, "onEndWorkAreaProcessing" )
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
function WorkArea.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadWorkAreaFromXML" , WorkArea.loadWorkAreaFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getWorkAreaByIndex" , WorkArea.getWorkAreaByIndex)
    SpecializationUtil.registerFunction(vehicleType, "getIsWorkAreaActive" , WorkArea.getIsWorkAreaActive)
    SpecializationUtil.registerFunction(vehicleType, "updateWorkAreaWidth" , WorkArea.updateWorkAreaWidth)
    SpecializationUtil.registerFunction(vehicleType, "getWorkAreaWidth" , WorkArea.getWorkAreaWidth)
    SpecializationUtil.registerFunction(vehicleType, "getIsWorkAreaProcessing" , WorkArea.getIsWorkAreaProcessing)
    SpecializationUtil.registerFunction(vehicleType, "getTypedNetworkAreas" , WorkArea.getTypedNetworkAreas)
    SpecializationUtil.registerFunction(vehicleType, "getTypedWorkAreas" , WorkArea.getTypedWorkAreas)
    SpecializationUtil.registerFunction(vehicleType, "getIsTypedWorkAreaActive" , WorkArea.getIsTypedWorkAreaActive)
    SpecializationUtil.registerFunction(vehicleType, "getIsFarmlandNotOwnedWarningShown" , WorkArea.getIsFarmlandNotOwnedWarningShown)
    SpecializationUtil.registerFunction(vehicleType, "getLastTouchedFarmlandFarmId" , WorkArea.getLastTouchedFarmlandFarmId)
    SpecializationUtil.registerFunction(vehicleType, "getIsAccessibleAtWorldPosition" , WorkArea.getIsAccessibleAtWorldPosition)
    SpecializationUtil.registerFunction(vehicleType, "updateLastWorkedArea" , WorkArea.updateLastWorkedArea)
    SpecializationUtil.registerFunction(vehicleType, "getMissionByWorkArea" , WorkArea.getMissionByWorkArea)
    SpecializationUtil.registerFunction(vehicleType, "getAIWorkAreaWidth" , WorkArea.getAIWorkAreaWidth)
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
function WorkArea.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , WorkArea.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , WorkArea.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "checkMovingPartDirtyUpdateNode" , WorkArea.checkMovingPartDirtyUpdateNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getImplementAllowAutomaticSteering" , WorkArea.getImplementAllowAutomaticSteering)
end

```

### registerWorkAreaXMLPaths

**Description**

**Definition**

> registerWorkAreaXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function WorkArea.registerWorkAreaXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#type" , "Work area type" , "DEFAULT" )
    schema:register(XMLValueType.BOOL, basePath .. "#requiresGroundContact" , "Requires ground contact to work" , true )
    schema:register(XMLValueType.BOOL, basePath .. "#disableBackwards" , "Area is disabled while driving backwards" , true )
        schema:register(XMLValueType.BOOL, basePath .. "#requiresOwnedFarmland" , "Requires owned farmland" , true )
        schema:register(XMLValueType.STRING, basePath .. "#functionName" , "Work area script function" )
            schema:register(XMLValueType.STRING, basePath .. "#preprocessFunctionName" , "Pre process work area script function" )
                schema:register(XMLValueType.STRING, basePath .. "#postprocessFunctionName" , "Post process work area script function" )

                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#startNode" , "Start node" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#widthNode" , "Width node" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".area#heightNode" , "Height node" )

                    schema:register(XMLValueType.INT, basePath .. ".groundReferenceNode#index" , "Ground reference node index" )
                    schema:register(XMLValueType.BOOL, basePath .. ".onlyActiveWhenLowered#value" , "Work area is only active when lowered" , false )
                end

```

### updateLastWorkedArea

**Description**

**Definition**

> updateLastWorkedArea()

**Arguments**

| any | area |
|-----|------|

**Code**

```lua
function WorkArea:updateLastWorkedArea(area)
    local spec = self.spec_workArea
    spec.lastWorkedArea = math.max(area, spec.lastWorkedArea)
end

```

### updateWorkAreaWidth

**Description**

> Updates work area width based on position of area nodes

**Definition**

> updateWorkAreaWidth(integer workAreaIndex)

**Arguments**

| integer | workAreaIndex | index of work area |
|---------|---------------|--------------------|

**Code**

```lua
function WorkArea:updateWorkAreaWidth(workAreaIndex)
    local spec = self.spec_workArea
    local workArea = spec.workAreas[workAreaIndex]
    if workArea = = nil then
        --#debug Logging.devWarning("No work area for workAreaIndex '%s'", workAreaIndex)
            --#debug printCallstack()
            return
        end

        local x1, _, _ = localToLocal( self.components[ 1 ].node, workArea.start, 0 , 0 , 0 )
        local x2, _, _ = localToLocal( self.components[ 1 ].node, workArea.width, 0 , 0 , 0 )
        local x3, _, _ = localToLocal( self.components[ 1 ].node, workArea.height, 0 , 0 , 0 )

        workArea.workWidth = math.max(x1, x2, x3) - math.min(x1, x2, x3)
    end

```