## TestAreas

**Description**

> Specialization for test areas to be used in other specs

**Functions**

- [calculateTestAreaDimensions](#calculatetestareadimensions)
- [generateTestAreasForWorkArea](#generatetestareasforworkarea)
- [getIsTestAreaActive](#getistestareaactive)
- [getTestAreaChargeByWorkAreaIndex](#gettestareachargebyworkareaindex)
- [getTestAreaWidthByWorkAreaIndex](#gettestareawidthbyworkareaindex)
- [initSpecialization](#initspecialization)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onPostLoad](#onpostload)
- [onPreLoad](#onpreload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processTestArea](#processtestarea)
- [readTestAreasStream](#readtestareasstream)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerTestAreaForWorkArea](#registertestareaforworkarea)
- [setTestAreaRequirements](#settestarearequirements)
- [writeTestAreasStream](#writetestareasstream)

### calculateTestAreaDimensions

**Description**

**Definition**

> calculateTestAreaDimensions()

**Arguments**

| any | workArea |
|-----|----------|
| any | testArea |

**Code**

```lua
function TestAreas:calculateTestAreaDimensions(workArea, testArea)
    testArea.areaSideOffset = testArea.areaSideOffset or 0

    local startX, _, _ = worldToLocal(workArea.testAreaRootNode, getWorldTranslation(testArea.start))
    local widthX, _, _ = worldToLocal(workArea.testAreaRootNode, getWorldTranslation(testArea.width))
    testArea.minWidthValue = startX + testArea.areaSideOffset
    testArea.maxWidthValue = widthX - testArea.areaSideOffset

    workArea.testAreaMinX = math.min(workArea.testAreaMinX, testArea.minWidthValue, testArea.maxWidthValue)
    workArea.testAreaMaxX = math.max(workArea.testAreaMaxX, testArea.minWidthValue, testArea.maxWidthValue)
end

```

### generateTestAreasForWorkArea

**Description**

**Definition**

> generateTestAreasForWorkArea()

**Arguments**

| any | workArea |
|-----|----------|

**Code**

```lua
function TestAreas:generateTestAreasForWorkArea(workArea)
    workArea.testAreaParent = createTransformGroup( "testAreaParent" )
    link(getParent(workArea.testAreaStartNode), workArea.testAreaParent)
    setTranslation(workArea.testAreaParent, getTranslation(workArea.testAreaStartNode))

    local dirX, dirY, dirZ = localToLocal(workArea.testAreaStartNode, workArea.testAreaWidthNode, 0 , 0 , 0 )
    dirX, dirY, dirZ = MathUtil.vector3Normalize(dirX, dirY, dirZ)
    dirX, dirY, dirZ = localDirectionToLocal(workArea.testAreaStartNode, getParent(workArea.testAreaStartNode), dirX, dirY, dirZ)

    I3DUtil.setDirection(workArea.testAreaParent, dirX, dirY, dirZ, 0 , 1 , 0 )

    local workAreaWidth = calcDistanceFrom(workArea.testAreaStartNode, workArea.testAreaWidthNode)
    local areaWidth = (workAreaWidth * workArea.testAreaScale) / workArea.testAreaNumAreas
    local totalOffset = - workAreaWidth * ( 1 - workArea.testAreaScale) * 0.5
    local areaSideOffset = areaWidth * ( 1 - workArea.testAreaWidthScale) * 0.5 + workArea.testAreaXOffset
    for index = 1 , workArea.testAreaNumAreas do
        local startNode = createTransformGroup( string.format( "testArea%dStart" , index))
        local widthNode = createTransformGroup( string.format( "testArea%dWidth" , index))
        local heightNode = createTransformGroup( string.format( "testArea%dHeight" , index))

        link(workArea.testAreaParent, startNode)
        link(workArea.testAreaParent, widthNode)
        link(workArea.testAreaParent, heightNode)

        local startAreaX = - ((index - 1 ) * areaWidth) - areaSideOffset + totalOffset
        local endAreaX = - (index * areaWidth) + areaSideOffset + totalOffset

        setTranslation(startNode, - (workArea.testAreaZOffset + workArea.testAreaLength), 0 , startAreaX)
        setTranslation(widthNode, - (workArea.testAreaZOffset + workArea.testAreaLength), 0 , endAreaX)
        setTranslation(heightNode, - workArea.testAreaZOffset, 0 , startAreaX)

        local testArea = { }
        testArea.start = startNode
        testArea.width = widthNode
        testArea.height = heightNode

        testArea.areaSideOffset = areaSideOffset

        self:calculateTestAreaDimensions(workArea, testArea)
        self:registerTestAreaForWorkArea(workArea, testArea)
    end
end

```

### getIsTestAreaActive

**Description**

**Definition**

> getIsTestAreaActive()

**Arguments**

| any | testArea |
|-----|----------|

**Code**

```lua
function TestAreas:getIsTestAreaActive(testArea)
    return true
end

```

### getTestAreaChargeByWorkAreaIndex

**Description**

**Definition**

> getTestAreaChargeByWorkAreaIndex()

**Arguments**

| any | workAreaIndex |
|-----|---------------|

**Code**

```lua
function TestAreas:getTestAreaChargeByWorkAreaIndex(workAreaIndex)
    local spec = self.spec_testAreas
    local testAreas = spec.testAreasByWorkAreaIndex[workAreaIndex]
    if testAreas ~ = nil then
        local charged = 0
        for i = 1 , #testAreas do
            if testAreas[i].hasContact then
                charged = charged + 1
            end
        end

        return charged / #testAreas
    end

    return 1
end

```

### getTestAreaWidthByWorkAreaIndex

**Description**

**Definition**

> getTestAreaWidthByWorkAreaIndex()

**Arguments**

| any | workAreaIndex |
|-----|---------------|

**Code**

```lua
function TestAreas:getTestAreaWidthByWorkAreaIndex(workAreaIndex)
    local spec = self.spec_testAreas
    local workArea = self:getWorkAreaByIndex(workAreaIndex)
    if workArea ~ = nil then
        if spec.testAreasByWorkAreaIndex[workAreaIndex] ~ = nil then
            return workArea.testAreaCurrentWidthMin, workArea.testAreaCurrentWidthMax, workArea.testAreaMinX, workArea.testAreaMaxX, true
        end

        local width = self:getWorkAreaWidth(workAreaIndex) * 0.5
        return - width, width, - width, width, false
    end

    return - math.huge, math.huge, 0 , 0 , false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function TestAreas.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "TestAreas" )

    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#autoGenerate" , "Automatically generate test areas" , false )
    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#rootNode" , "Root node as reference for width" )
        schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#startNode" , "Left node reference for automatic calculation" )
            schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#widthNode" , "Right node reference for automatic calculation" )
                schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#zOffset" , "Offset in Z direction" , 0 )
                schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#xOffset" , "Offset for both sides mirrored(negative value will shrink area, positive will increase area on both sides)" , 0 )
                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#length" , "Length of area itself" , 0.5 )
                    schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#numAreas" , "Number of used areas" , 10 )
                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#areaWidthScale" , "Width percentage of each individual area" , 0.9 )
                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".testAreas#scale" , "Scale of test areas over width of work area" , 1 )

                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas.testArea(?)#startNode" , "Start Node" )
                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas.testArea(?)#widthNode" , "Width Node" )
                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_KEY .. ".testAreas.testArea(?)#heightNode" , "Height Node" )

                    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#autoGenerate" , "Automatically generate test areas" , false )
                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#rootNode" , "Root node as reference for width" )
                        schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#startNode" , "Left node reference for automatic calculation" )
                            schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#widthNode" , "Right node reference for automatic calculation" )
                                schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#zOffset" , "Offset in Z direction" , 0 )
                                schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#xOffset" , "Offset for both sides mirrored(negative value will shrink area, positive will increase area on both sides)" , 0 )
                                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#length" , "Length of area itself" , 0.5 )
                                    schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#numAreas" , "Number of used areas" , 10 )
                                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#areaWidthScale" , "Width percentage of each individual area" , 0.9 )
                                    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas#scale" , "Scale of test areas over width of work area" , 1 )

                                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas.testArea(?)#startNode" , "Start Node" )
                                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas.testArea(?)#widthNode" , "Width Node" )
                                    schema:register(XMLValueType.NODE_INDEX, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".testAreas.testArea(?)#heightNode" , "Height Node" )

                                    schema:setXMLSpecializationType()
                                end

```

### loadWorkAreaFromXML

**Description**

**Definition**

> loadWorkAreaFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function TestAreas:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    if not superFunc( self , workArea, xmlFile, key) then
        return false
    end

    if not Platform.gameplay.allowTestAreas then
        if xmlFile:hasProperty(key .. ".testAreas" ) then
            Logging.xmlWarning(xmlFile, "TestAreas not allowed on this platform in '%s'" , key)
        end
    end

    workArea.automaticTestAreas = xmlFile:getValue(key .. ".testAreas#autoGenerate" , false )

    workArea.testAreaRootNode = xmlFile:getValue(key .. ".testAreas#rootNode" , nil , self.components, self.i3dMappings)

    workArea.testAreaStartNode = xmlFile:getValue(key .. ".testAreas#startNode" , workArea.start, self.components, self.i3dMappings)
    workArea.testAreaWidthNode = xmlFile:getValue(key .. ".testAreas#widthNode" , workArea.width, self.components, self.i3dMappings)

    workArea.testAreaXOffset = xmlFile:getValue(key .. ".testAreas#xOffset" , 0 )
    workArea.testAreaZOffset = xmlFile:getValue(key .. ".testAreas#zOffset" , 0 )
    workArea.testAreaNumAreas = xmlFile:getValue(key .. ".testAreas#numAreas" , 10 )
    workArea.testAreaLength = xmlFile:getValue(key .. ".testAreas#length" , 0.5 )
    workArea.testAreaWidthScale = xmlFile:getValue(key .. ".testAreas#areaWidthScale" , 0.9 )
    workArea.testAreaScale = xmlFile:getValue(key .. ".testAreas#scale" , 1 )

    workArea.testAreaMinX = 0
    workArea.testAreaMaxX = 0

    if workArea.automaticTestAreas then
        if workArea.testAreaRootNode = = nil then
            workArea.testAreaRootNode = createTransformGroup( "testAreaRootNode" )
            link(getParent(workArea.testAreaStartNode), workArea.testAreaRootNode)

            local x1, y1, z1 = getWorldTranslation(workArea.testAreaStartNode)
            local x2, y2, z2 = getWorldTranslation(workArea.testAreaWidthNode)
            setWorldTranslation(workArea.testAreaRootNode, (x1 + x2) * 0.5 , (y1 + y2) * 0.5 , (z1 + z2) * 0.5 )
        end

        self:generateTestAreasForWorkArea(workArea)
    else
            if workArea.testAreaRootNode = = nil then
                workArea.testAreaRootNode = self.components[ 1 ].node
            end

            xmlFile:iterate(key .. ".testAreas.testArea" , function (_, areaKey)
                local testArea = { }
                testArea.start = xmlFile:getValue(areaKey .. "#startNode" , nil , self.components, self.i3dMappings)
                testArea.width = xmlFile:getValue(areaKey .. "#widthNode" , nil , self.components, self.i3dMappings)
                testArea.height = xmlFile:getValue(areaKey .. "#heightNode" , nil , self.components, self.i3dMappings)

                if testArea.start ~ = nil and testArea.width ~ = nil and testArea.height ~ = nil then
                    self:calculateTestAreaDimensions(workArea, testArea)
                    self:registerTestAreaForWorkArea(workArea, testArea)
                end
            end )
        end

        workArea.hasTestAreas = workArea.testAreaRootNode ~ = nil

        workArea.testAreaCurrentWidthMin = - math.huge
        workArea.testAreaCurrentWidthMax = math.huge

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
function TestAreas:onPostLoad(savegame)
    local spec = self.spec_testAreas

    for workArea, testAreas in pairs(spec.testAreasByWorkArea) do
        spec.testAreasByWorkAreaIndex[workArea.index] = testAreas
    end
end

```

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function TestAreas:onPreLoad(savegame)
    local spec = self.spec_testAreas

    spec.testAreas = { }
    spec.testAreasByWorkArea = { }
    spec.testAreasByWorkAreaIndex = { }

    spec.testAreaDirtyFlag = self:getNextDirtyFlag()
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
function TestAreas:onReadStream(streamId, connection)
    self:readTestAreasStream(streamId, connection)
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
function TestAreas:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            self:readTestAreasStream(streamId, connection)
        end
    end
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
function TestAreas:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_testAreas

    for workArea, testAreas in pairs(spec.testAreasByWorkArea) do
        if self:getIsWorkAreaActive(workArea) then
            workArea.testAreaCurrentWidthMin = - math.huge
            workArea.testAreaCurrentWidthMax = math.huge

            local numTestAreas = #testAreas
            local chargedAreas = numTestAreas
            local foundLeft = false
            local foundLeftIndex = - 1
            for i = 1 , numTestAreas do
                local testArea = testAreas[i]
                if self:processTestArea(testArea) then
                    foundLeft = true
                    foundLeftIndex = i

                    workArea.testAreaCurrentWidthMin = testArea.minWidthValue
                    workArea.testAreaCurrentWidthMax = testArea.maxWidthValue

                    break
                else
                        chargedAreas = chargedAreas - 1
                    end
                end

                if foundLeft then
                    local fruitFound = false
                    for i = numTestAreas, foundLeftIndex + 1 , - 1 do
                        local testArea = testAreas[i]
                        if not fruitFound then
                            if self:processTestArea(testArea) then
                                workArea.testAreaCurrentWidthMax = testArea.maxWidthValue
                                fruitFound = true
                            else
                                    chargedAreas = chargedAreas - 1
                                end
                            else
                                    testArea.hasContact = true
                                end
                            end
                        end

                        if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                            local x1, y1, z1 = localToWorld(workArea.testAreaRootNode, math.max(workArea.testAreaCurrentWidthMin, workArea.testAreaMinX), 0 , 0 )
                            local x2, y2, z2 = localToWorld(workArea.testAreaRootNode, math.min(workArea.testAreaCurrentWidthMax, workArea.testAreaMaxX), 0 , 0 )

                            drawDebugLine(x1, y1, z1, 0 , 1 , 0 , x1, y1 + 2 , z1, 0 , 1 , 0 )
                            drawDebugLine(x2, y2, z2, 0 , 1 , 0 , x2, y2 + 1 , z2, 0 , 1 , 0 )
                        end
                    else
                            workArea.testAreaCurrentWidthMin = - math.huge
                            workArea.testAreaCurrentWidthMax = math.huge
                        end
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
function TestAreas:onWriteStream(streamId, connection)
    self:writeTestAreasStream(streamId, connection)
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
function TestAreas:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, self.spec_testAreas.testAreaDirtyFlag) ~ = 0 ) then
            self:writeTestAreasStream(streamId, connection)
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
function TestAreas.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations)
end

```

### processTestArea

**Description**

**Definition**

> processTestArea()

**Arguments**

| any | testArea |
|-----|----------|

**Code**

```lua
function TestAreas:processTestArea(testArea)
    local spec = self.spec_testAreas

    local x, _, z = getWorldTranslation(testArea.start)
    local x1, _, z1 = getWorldTranslation(testArea.width)
    local x2, _, z2 = getWorldTranslation(testArea.height)

    if self.isServer and(spec.fruitTypeIndex ~ = nil or spec.fillTypeIndex ~ = nil ) then
        if self:getIsTestAreaActive(testArea) then
            if spec.fruitTypeIndex ~ = nil then
                local fruitValue, _, _, _ = FSDensityMapUtil.getFruitArea(spec.fruitTypeIndex, x, z, x1, z1, x2, z2, nil , spec.allowsForageGrowthState)
                testArea.hasContact = fruitValue > 0
            else
                    local fillLevel = DensityMapHeightUtil.getFillLevelAtArea(spec.fillTypeIndex, x, z, x1, z1, x2, z2)
                    testArea.hasContact = fillLevel > 0
                end

                if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                    local dx, dz, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(x, z, x1, z1, x2, z2)
                    DebugUtil.drawDebugParallelogram(dx, dz, widthX, widthZ, heightX, heightZ, 0.2 , testArea.hasContact and 0 or 1 , testArea.hasContact and 1 or 0 , 0 , 0.5 )
                    DebugGizmo.renderAtNode(testArea.start, getName(testArea.start), true , 1 , true )
                    DebugGizmo.renderAtNode(testArea.width, getName(testArea.width), true , 1 , true )
                    DebugGizmo.renderAtNode(testArea.height, getName(testArea.height), true , 1 , true )
                end

                if testArea.hasContactSent ~ = testArea.hasContact then
                    self:raiseDirtyFlags(spec.testAreaDirtyFlag)
                    testArea.hasContactSent = testArea.hasContact
                end
            end
        elseif spec.fruitTypeIndex ~ = nil or spec.fillTypeIndex ~ = nil then
                if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                    local dx, dz, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(x, z, x1, z1, x2, z2)
                    DebugUtil.drawDebugParallelogram(dx, dz, widthX, widthZ, heightX, heightZ, 0.2 , testArea.hasContact and 0 or 1 , testArea.hasContact and 1 or 0 , 0 , 0.5 )
                end
            end

            return testArea.hasContact
        end

```

### readTestAreasStream

**Description**

**Definition**

> readTestAreasStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function TestAreas:readTestAreasStream(streamId, connection)
    local spec = self.spec_testAreas

    for i = 1 , #spec.testAreas do
        spec.testAreas[i].hasContact = false
    end

    local startIndex, endIndex = 0 , 0
    local hadFruitContact = false
    for i = 1 , #spec.testAreas do
        local testArea = spec.testAreas[i]
        testArea.hasContact = streamReadBool(streamId)
        if testArea.hasContact then
            hadFruitContact = true
            startIndex = i
            break
        end
    end

    if hadFruitContact then
        for i = #spec.testAreas, 1 , - 1 do
            local testArea = spec.testAreas[i]
            testArea.hasContact = streamReadBool(streamId)
            if testArea.hasContact then
            endIndex = i
            break
        end
    end
end

if startIndex ~ = 0 and endIndex ~ = 0 then
    for i = startIndex, endIndex do
        spec.testAreas[i].hasContact = true
    end
end
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
function TestAreas.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , TestAreas )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , TestAreas )
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
function TestAreas.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "readTestAreasStream" , TestAreas.readTestAreasStream)
    SpecializationUtil.registerFunction(vehicleType, "writeTestAreasStream" , TestAreas.writeTestAreasStream)
    SpecializationUtil.registerFunction(vehicleType, "generateTestAreasForWorkArea" , TestAreas.generateTestAreasForWorkArea)
    SpecializationUtil.registerFunction(vehicleType, "calculateTestAreaDimensions" , TestAreas.calculateTestAreaDimensions)
    SpecializationUtil.registerFunction(vehicleType, "registerTestAreaForWorkArea" , TestAreas.registerTestAreaForWorkArea)
    SpecializationUtil.registerFunction(vehicleType, "setTestAreaRequirements" , TestAreas.setTestAreaRequirements)
    SpecializationUtil.registerFunction(vehicleType, "getIsTestAreaActive" , TestAreas.getIsTestAreaActive)
    SpecializationUtil.registerFunction(vehicleType, "processTestArea" , TestAreas.processTestArea)
    SpecializationUtil.registerFunction(vehicleType, "getTestAreaWidthByWorkAreaIndex" , TestAreas.getTestAreaWidthByWorkAreaIndex)
    SpecializationUtil.registerFunction(vehicleType, "getTestAreaChargeByWorkAreaIndex" , TestAreas.getTestAreaChargeByWorkAreaIndex)
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
function TestAreas.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , TestAreas.loadWorkAreaFromXML)
end

```

### registerTestAreaForWorkArea

**Description**

**Definition**

> registerTestAreaForWorkArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | testArea |

**Code**

```lua
function TestAreas:registerTestAreaForWorkArea(workArea, testArea)
    testArea.hasContact = false
    testArea.hasContactSent = false

    local spec = self.spec_testAreas
    if spec.testAreasByWorkArea[workArea] = = nil then
        spec.testAreasByWorkArea[workArea] = { }
    end

    table.insert(spec.testAreasByWorkArea[workArea], testArea)
    table.insert(spec.testAreas, testArea)
end

```

### setTestAreaRequirements

**Description**

**Definition**

> setTestAreaRequirements()

**Arguments**

| any | fruitTypeIndex          |
|-----|-------------------------|
| any | fillTypeIndex           |
| any | allowsForageGrowthState |

**Code**

```lua
function TestAreas:setTestAreaRequirements(fruitTypeIndex, fillTypeIndex, allowsForageGrowthState)
    local spec = self.spec_testAreas

    if fruitTypeIndex = = FruitType.UNKNOWN then
        fruitTypeIndex = nil
    end

    if fillTypeIndex = = FillType.UNKNOWN then
        fillTypeIndex = nil
    end

    spec.fruitTypeIndex = fruitTypeIndex
    spec.fillTypeIndex = fillTypeIndex
    spec.allowsForageGrowthState = allowsForageGrowthState
end

```

### writeTestAreasStream

**Description**

**Definition**

> writeTestAreasStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function TestAreas:writeTestAreasStream(streamId, connection)
    local spec = self.spec_testAreas

    local hadFruitContact = false
    for i = 1 , #spec.testAreas do
        local testArea = spec.testAreas[i]
        streamWriteBool(streamId, testArea.hasContact)
        if testArea.hasContact then
            hadFruitContact = true
            break
        end
    end

    if hadFruitContact then
        for i = #spec.testAreas, 1 , - 1 do
            local testArea = spec.testAreas[i]
            streamWriteBool(streamId, testArea.hasContact)
            if testArea.hasContact then
                break
            end
        end
    end
end

```