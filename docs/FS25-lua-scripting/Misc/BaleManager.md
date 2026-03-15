## BaleManager

**Description**

> This class handles all bales

**Parent**

> [AbstractManager](?version=script&category=58&class=554)

**Functions**

- [baleLoaded](#baleloaded)
- [consoleCommandAddBale](#consolecommandaddbale)
- [consoleCommandAddBaleAll](#consolecommandaddbaleall)
- [consoleCommandListBales](#consolecommandlistbales)
- [getBaleCapacityByBaleIndex](#getbalecapacitybybaleindex)
- [getBaleIndex](#getbaleindex)
- [getBaleInfoByXMLFilename](#getbaleinfobyxmlfilename)
- [getBaleTypeIndexByXMLFilename](#getbaletypeindexbyxmlfilename)
- [getBaleXMLFilename](#getbalexmlfilename)
- [getBaleXMLFilenameByIndex](#getbalexmlfilenamebyindex)
- [getFermentationTime](#getfermentationtime)
- [getIsBaleMatching](#getisbalematching)
- [getIsRoundBale](#getisroundbale)
- [getPossibleCapacitiesForFillType](#getpossiblecapacitiesforfilltype)
- [initDataStructures](#initdatastructures)
- [loadBaleDataFromXML](#loadbaledatafromxml)
- [loadBaleFromXML](#loadbalefromxml)
- [loadBales](#loadbales)
- [loadMapData](#loadmapdata)
- [loadModBaleFromXML](#loadmodbalefromxml)
- [new](#new)
- [registerBaleTextureXMLPaths](#registerbaletexturexmlpaths)
- [registerBaleXMLPaths](#registerbalexmlpaths)
- [registerFermentation](#registerfermentation)
- [registerMapBalesXMLPaths](#registermapbalesxmlpaths)
- [removeFermentation](#removefermentation)
- [unloadBaleData](#unloadbaledata)
- [unloadMapData](#unloadmapdata)
- [update](#update)

### baleLoaded

**Description**

> Bale i3d file loaded

**Definition**

> baleLoaded(entityId i3dNode, integer failedReason, Bale bale)

**Arguments**

| entityId | i3dNode      |
|----------|--------------|
| integer  | failedReason |
| Bale     | bale         |

**Code**

```lua
function BaleManager:baleLoaded(i3dNode, failedReason, bale)
    if i3dNode ~ = 0 then
        bale.sharedRoot = i3dNode

        local collisionPreset = CollisionPreset.BALE

        local baleId = getChildAt(i3dNode, 0 )
        if getCollisionFilterGroup(baleId) ~ = collisionPreset.group then
            Logging.error( "Bale '%s' has wrong collision group mask.Expected: %d, got: %d" , bale.xmlFilename, collisionPreset.group, getCollisionFilterGroup(baleId))
        end

        if getCollisionFilterMask(baleId) ~ = collisionPreset.mask then
            Logging.error( "Bale '%s' has wrong collision mask.Expected: %d, got: %d" , bale.xmlFilename, collisionPreset.mask, getCollisionFilterMask(baleId))
        end

        removeFromPhysics(i3dNode)
    end
end

```

### consoleCommandAddBale

**Description**

**Definition**

> consoleCommandAddBale()

**Arguments**

| any | fillTypeName |
|-----|--------------|
| any | isRoundbale  |
| any | width        |
| any | height       |
| any | length       |
| any | wrapState    |
| any | modName      |

**Code**

```lua
function BaleManager:consoleCommandAddBale(fillTypeName, isRoundbale, width, height, length, wrapState, modName)
    local usage = "gsBaleAdd fillTypeName isRoundBale [width] [height/diameter] [length] [wrapState] [modName]"

    if not g_currentMission:getIsServer() then
        Logging.error( "Command only allowed on server!" )
        return
    end

    fillTypeName = Utils.getNoNil(fillTypeName, "STRAW" )
    isRoundbale = Utils.stringToBoolean(isRoundbale)

    width = width ~ = nil and tonumber(width) or nil
    height = height ~ = nil and tonumber(height) or nil
    length = length ~ = nil and tonumber(length) or nil
    if wrapState ~ = nil and tonumber(wrapState) = = nil then
        Logging.error( "Invalid wrapState '%s', number expected.\nUsage: %s" , wrapState, usage)
        return
    end
    wrapState = tonumber(wrapState or 0 )

    local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
    if fillTypeIndex = = nil then
        Logging.error( "Invalid fillTypeName '%s' (e.g.STRAW).\nUsage: %s" , fillTypeName, usage)
        return
    end

    local baleXMLFilename, _ = self:getBaleXMLFilename(fillTypeIndex, isRoundbale, width, height, length, height, modName)
    if baleXMLFilename = = nil then
        Logging.error( "Could not find bale for given size attributes!\nUsage: %s" , usage)
            self:consoleCommandListBales()
            return
        end

        local x, y, z = g_localPlayer:getPosition()
        local dirX, dirZ = g_localPlayer:getCurrentFacingDirection()

        x, z = x + dirX * 4 , z + dirZ * 4
        y = y + 5
        local ry = MathUtil.getYRotationFromDirection(dirX, dirZ)

        local farmId = g_currentMission:getFarmId()
        farmId = ((farmId ~ = FarmManager.SPECTATOR_FARM_ID) and farmId) or 1 -- don't spawn bales with spectator farm

        local baleObject = Bale.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
        if baleObject:loadFromConfigXML(baleXMLFilename, x, y, z, 0 , ry, 0 ) then
            baleObject:setFillType(fillTypeIndex, true )
            baleObject:setWrappingState(wrapState)
            baleObject:setOwnerFarmId(farmId, true )
            baleObject:register()
        end

        return string.format( "Created bale at(%.2f, %.2f, %.2f).For specific bales use: %s" , x, y, z, usage)
    end

```

### consoleCommandAddBaleAll

**Description**

**Definition**

> consoleCommandAddBaleAll()

**Arguments**

| any | drawSizeBox |
|-----|-------------|

**Code**

```lua
function BaleManager:consoleCommandAddBaleAll(drawSizeBox)
    if g_server = = nil then
        Logging.error( "Command only allowed on server!" )
        return
    end

    drawSizeBox = string.lower(drawSizeBox or "" ) = = "true"

    local wx, wy, wz
    local dirX, dirZ
    if self.debugLoadPosition = = nil then
        wx, wy, wz = g_localPlayer:getPosition()
        dirX, dirZ = g_localPlayer:getCurrentFacingDirection()
        self.debugLoadPosition = { wx, wy, wz, dirX, dirZ }
    else
            wx, wy, wz = self.debugLoadPosition[ 1 ], self.debugLoadPosition[ 2 ], self.debugLoadPosition[ 3 ]
            dirX, dirZ = self.debugLoadPosition[ 4 ], self.debugLoadPosition[ 5 ]
        end

        if self.debugBales ~ = nil then
            for _, bale in ipairs( self.debugBales) do
                bale:delete()
            end
        end

        g_debugManager:removeGroup( "baleManager" )

        self.debugBales = { }

        self:unloadBaleData()
        g_i3DManager:clearEntireSharedI3DFileCache()
        self.bales = { }

        local xmlFilename = Utils.getFilename( "data/maps/maps_bales.xml" )
        local balesXMLFile = XMLFile.load( "TempBales" , xmlFilename, BaleManager.mapBalesXMLSchema)
        if balesXMLFile ~ = nil then
            self:loadBales(balesXMLFile)
            balesXMLFile:delete()
        end

        local function spawnBales()
            local boxColor = Color.new( 0.2 , 0.2 , 0.2 , 1 )

            wx, wz = wx + dirX * 4 , wz + dirZ * 4
            local yRot = MathUtil.getYRotationFromDirection(dirX, dirZ)

            local xOffset, zOffset = 0 , 0
            for baleIndex, bale in ipairs( self.bales) do
                for _, fillTypeData in ipairs(bale.fillTypes) do
                    zOffset = (bale.isRoundbale and bale.width or bale.length) * 0.5
                    for variationIndex, variationData in ipairs(bale.variations) do
                        local x, z = wx + dirX * zOffset - dirZ * xOffset, wz + dirZ * zOffset + dirX * xOffset

                        local baleHeight = (bale.isRoundbale and bale.diameter or bale.height)
                        local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z) + baleHeight * 0.5

                        local baleObject = Bale.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
                        if baleObject:loadFromConfigXML(bale.xmlFilename, x, y, z, 0 , yRot, 0 ) then
                            baleObject:setFillType(fillTypeData.fillTypeIndex, true )
                            baleObject:setVariationIndex(variationIndex)
                            baleObject:setOwnerFarmId(g_currentMission:getFarmId(), true )
                            baleObject:register()
                            baleObject:removeFromPhysics()

                            local debugString = string.format( "%s(%s - %s)" , Utils.getFilenameFromPath(bale.xmlFilename), g_fillTypeManager:getFillTypeNameByIndex(fillTypeData.fillTypeIndex), variationData.id)

                            local rx, ry, rz = localRotationToWorld(baleObject.nodeId, 0 , math.pi, 0 )
                            DebugText3D.new():createWithWorldPos(x, y + baleHeight * 0.5 + 0.25 , z, rx, ry, rz, debugString, 0.07 ):addToManager( "baleManager" , nil , math.huge)

                            if drawSizeBox then
                                local sizeX, sizeY, sizeZ
                                if bale.isRoundbale then
                                    sizeX, sizeY, sizeZ = bale.diameter, bale.diameter, bale.width
                                else
                                        sizeX, sizeY, sizeZ = bale.width, bale.height, bale.length
                                    end
                                    DebugBox.new():createWithWorldPosAndRot(x, y, z, rx, ry, rz, sizeX, sizeY, sizeZ):setColor(boxColor):addToManager( "baleManager" , nil , math.huge)
                                end

                                table.insert( self.debugBales, baleObject)
                            end

                            zOffset = zOffset + (bale.isRoundbale and bale.width or bale.length) + 1
                        end

                        xOffset = xOffset + 2.5
                    end

                    xOffset = xOffset + 5
                end
            end

            local numBalesToLoad = # self.bales
            local function baleLoaded(_, i3dNode, failedReason, bale)
                self:baleLoaded(i3dNode, failedReason, bale)
                numBalesToLoad = numBalesToLoad - 1
                if numBalesToLoad = = 0 then
                    spawnBales()
                end
            end

            for _, bale in ipairs( self.bales) do
                bale.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(bale.i3dFilename, false , true , baleLoaded, self , bale)
            end
        end

```

### consoleCommandListBales

**Description**

**Definition**

> consoleCommandListBales()

**Code**

```lua
function BaleManager:consoleCommandListBales()
    print( "Available bale types:" )
    for _, bale in ipairs( self.bales) do
        local attributes = { bale.xmlFilename }
        table.insert(attributes, string.format( "isRoundbale = %s" , bale.isRoundbale))
        for _, sizeProperty in ipairs( { "width" , "height" , "length" , "diameter" } ) do
            if bale[sizeProperty] ~ = nil and bale[sizeProperty] ~ = 0 then
                table.insert(attributes, string.format( "%s = %s" , sizeProperty, bale[sizeProperty]))
            end
        end
        log( table.concat(attributes, " " ))

        local fillTypeNames = { }
        for _, fillTypeData in ipairs(bale.fillTypes) do
            table.insert(fillTypeNames, g_fillTypeManager:getFillTypeNameByIndex(fillTypeData.fillTypeIndex))
        end
        log( " fillTypes: " , table.concat(fillTypeNames, " " ))
    end
end

```

### getBaleCapacityByBaleIndex

**Description**

> Returns capacity for specific fill type by given bale index

**Definition**

> getBaleCapacityByBaleIndex(integer baleIndex, integer fillTypeIndex)

**Arguments**

| integer | baleIndex     | fill type index |
|---------|---------------|-----------------|
| integer | fillTypeIndex | fill type index |

**Return Values**

| integer | capacity |
|---------|----------|

**Code**

```lua
function BaleManager:getBaleCapacityByBaleIndex(baleIndex, fillTypeIndex)
    if baleIndex ~ = nil then
        local bale = self.bales[baleIndex]
        if bale ~ = nil then
            for j = 1 , #bale.fillTypes do
                if bale.fillTypes[j].fillTypeIndex = = fillTypeIndex then
                    return bale.fillTypes[j].capacity
                end
            end
        end
    end

    return 0
end

```

### getBaleIndex

**Description**

> Get index of bale that matches given specs

**Definition**

> getBaleIndex(integer fillTypeIndex, boolean isRoundbale, float width, float height, float length, float diameter,
> float diameter, string customEnvironment)

**Arguments**

| integer | fillTypeIndex     | fill type index                          |
|---------|-------------------|------------------------------------------|
| boolean | isRoundbale       | is roundbale                             |
| float   | width             | bale width                               |
| float   | height            | bale height                              |
| float   | length            | bale length                              |
| float   | diameter          | bale diameter                            |
| float   | diameter          | bale diameter                            |
| string  | customEnvironment | seach bales from this custom environment |

**Return Values**

| string | index | index |
|--------|-------|-------|

**Code**

```lua
function BaleManager:getBaleIndex(fillTypeIndex, isRoundbale, width, height, length, diameter, customEnvironment)
    -- for mods we search first in it's own custom environment for a matching bale
        if customEnvironment ~ = nil then
            for baleIndex = 1 , # self.bales do
                local bale = self.bales[baleIndex]
                if bale.isAvailable then
                    if customEnvironment = = bale.customEnvironment then
                        if self:getIsBaleMatching(bale, fillTypeIndex, isRoundbale, width, height, length, diameter) then
                            return baleIndex
                        end
                    end
                end
            end
        end

        -- now search all bales without custom environment
        for baleIndex = 1 , # self.bales do
            local bale = self.bales[baleIndex]
            if bale.isAvailable then
                if bale.customEnvironment = = nil then
                    if self:getIsBaleMatching(bale, fillTypeIndex, isRoundbale, width, height, length, diameter) then
                        return baleIndex
                    end
                end
            end
        end

        return nil
    end

```

### getBaleInfoByXMLFilename

**Description**

> Returns information about the given bale xml file

**Definition**

> getBaleInfoByXMLFilename()

**Arguments**

| any | xmlFilename         |
|-----|---------------------|
| any | useVisualInfomation |

**Code**

```lua
function BaleManager:getBaleInfoByXMLFilename(xmlFilename, useVisualInfomation)
    for i = 1 , # self.bales do
        local bale = self.bales[i]
        if bale.xmlFilename = = xmlFilename then
            if useVisualInfomation = = true then
                return bale.isRoundbale, bale.visualWidth, bale.visualHeight, bale.visualLength, bale.visualDiameter, bale.maxStackHeight
            else
                    return bale.isRoundbale, bale.width, bale.height, bale.length, bale.diameter, bale.maxStackHeight
                end
            end
        end

        return false , 0 , 0 , 0 , 0 , 1
    end

```

### getBaleTypeIndexByXMLFilename

**Description**

> Returns the bale index for the given XML filename

**Definition**

> getBaleTypeIndexByXMLFilename()

**Arguments**

| any | xmlFilename |
|-----|-------------|

**Code**

```lua
function BaleManager:getBaleTypeIndexByXMLFilename(xmlFilename)
    for i = 1 , # self.bales do
        if self.bales[i].xmlFilename = = xmlFilename then
            return i
        end
    end

    return nil
end

```

### getBaleXMLFilename

**Description**

> Get xml file bale that matches given specs

**Definition**

> getBaleXMLFilename(integer fillTypeIndex, boolean isRoundbale, float width, float height, float length, float
> diameter, )

**Arguments**

| integer | fillTypeIndex     | fill type index |
|---------|-------------------|-----------------|
| boolean | isRoundbale       | is roundbale    |
| float   | width             | bale width      |
| float   | height            | bale height     |
| float   | length            | bale length     |
| float   | diameter          | bale diameter   |
| any     | customEnvironment |                 |

**Return Values**

| any | index | index |
|-----|-------|-------|

**Code**

```lua
function BaleManager:getBaleXMLFilename(fillTypeIndex, isRoundbale, width, height, length, diameter, customEnvironment)
    local baleIndex = self:getBaleIndex(fillTypeIndex, isRoundbale, width, height, length, diameter, customEnvironment)
    if baleIndex ~ = nil then
        return self.bales[baleIndex].xmlFilename, baleIndex
    end

    return nil
end

```

### getBaleXMLFilenameByIndex

**Description**

> Returns the bale xml filename for the given bale index

**Definition**

> getBaleXMLFilenameByIndex()

**Arguments**

| any | baleIndex |
|-----|-----------|

**Code**

```lua
function BaleManager:getBaleXMLFilenameByIndex(baleIndex)
    if baleIndex ~ = nil and self.bales[baleIndex] ~ = nil then
        return self.bales[baleIndex].xmlFilename
    end

    return nil
end

```

### getFermentationTime

**Description**

> Returns fermentation time for given bale

**Definition**

> getFermentationTime(table bale)

**Arguments**

| table | bale | bale object |
|-------|------|-------------|

**Return Values**

| table | time | current fermentation time in ms |
|-------|------|---------------------------------|

**Code**

```lua
function BaleManager:getFermentationTime(bale)
    for i = 1 , # self.fermentations do
        if self.fermentations[i].bale = = bale then
            return self.fermentations[i].time
        end
    end

    return 0
end

```

### getIsBaleMatching

**Description**

**Definition**

> getIsBaleMatching()

**Arguments**

| any | bale          |
|-----|---------------|
| any | fillTypeIndex |
| any | isRoundbale   |
| any | width         |
| any | height        |
| any | length        |
| any | diameter      |

**Code**

```lua
function BaleManager:getIsBaleMatching(bale, fillTypeIndex, isRoundbale, width, height, length, diameter)
    if bale.isRoundbale = = isRoundbale then
        local fillTypeMatch = false
        for j = 1 , #bale.fillTypes do
            if bale.fillTypes[j].fillTypeIndex = = fillTypeIndex then
                fillTypeMatch = true
                break
            end
        end

        if fillTypeMatch then
            local sizeMatch
            if isRoundbale then
                sizeMatch = (width = = nil or MathUtil.round(width, 2 ) = = bale.width)
                and(diameter = = nil or MathUtil.round(diameter, 2 ) = = bale.diameter)
            else
                    sizeMatch = (width = = nil or MathUtil.round(width, 2 ) = = bale.width)
                    and(height = = nil or MathUtil.round(height, 2 ) = = bale.height)
                    and(length = = nil or MathUtil.round(length, 2 ) = = bale.length)
                end

                if sizeMatch then
                    return true
                end
            end
        end

        return false
    end

```

### getIsRoundBale

**Description**

> Returns if the given bale type index is a roundbale

**Definition**

> getIsRoundBale()

**Arguments**

| any | baleIndex |
|-----|-----------|

**Code**

```lua
function BaleManager:getIsRoundBale(baleIndex)
    if baleIndex ~ = nil and self.bales[baleIndex] ~ = nil then
        return self.bales[baleIndex].isRoundbale
    end

    return nil
end

```

### getPossibleCapacitiesForFillType

**Description**

**Definition**

> getPossibleCapacitiesForFillType()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function BaleManager:getPossibleCapacitiesForFillType(fillTypeIndex)
    local capacities = { }

    for _, bale in ipairs( self.bales) do
        for _, fillTypeData in ipairs(bale.fillTypes) do
            if fillTypeData.fillTypeIndex = = fillTypeIndex then
                table.insert(capacities, fillTypeData.capacity)
            end
        end
    end

    return capacities
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function BaleManager:initDataStructures()
    self.bales = { }
    self.modBalesToLoad = { }
    self.fermentations = { }
end

```

### loadBaleDataFromXML

**Description**

> Loads and adds bale type from xml

**Definition**

> loadBaleDataFromXML(XMLFile xmlFile, float key, )

**Arguments**

| XMLFile | xmlFile       | XMLFile instance |
|---------|---------------|------------------|
| float   | key           | xmlKey           |
| any     | baseDirectory |                  |

**Return Values**

| any | baleType | baleType object |
|-----|----------|-----------------|

**Code**

```lua
function BaleManager:loadBaleDataFromXML(bale, xmlFile, baseDirectory)
    local i3dFilename = xmlFile:getValue( "bale.filename" )
    if i3dFilename ~ = nil then
        bale.i3dFilename = Utils.getFilename(i3dFilename, baseDirectory)
        if not fileExists(bale.i3dFilename) then
            Logging.xmlError(xmlFile, "Bale i3d file could not be found '%s'" , bale.i3dFilename)
            return false
        end

        bale.isRoundbale = xmlFile:getValue( "bale.size#isRoundbale" , true )
        bale.width = MathUtil.round(xmlFile:getValue( "bale.size#width" , 0 ), 2 )
        bale.height = MathUtil.round(xmlFile:getValue( "bale.size#height" , 0 ), 2 )
        bale.length = MathUtil.round(xmlFile:getValue( "bale.size#length" , 0 ), 2 )
        bale.diameter = MathUtil.round(xmlFile:getValue( "bale.size#diameter" , 0 ), 2 )
        bale.maxStackHeight = xmlFile:getValue( "bale.size#maxStackHeight" , bale.isRoundbale and 2 or 3 )
        bale.visualWidth = xmlFile:getValue( "bale.size#visualWidth" , bale.width)
        bale.visualHeight = xmlFile:getValue( "bale.size#visualHeight" , bale.height)
        bale.visualLength = xmlFile:getValue( "bale.size#visualLength" , bale.length)
        bale.visualDiameter = xmlFile:getValue( "bale.size#visualDiameter" , bale.diameter)

        if bale.isRoundbale and(bale.diameter = = 0 or bale.width = = 0 ) then
            Logging.xmlError(xmlFile, "Missing size attributes for round bale.Requires width and diameter." )
                return false
            elseif not bale.isRoundbale and(bale.width = = 0 or bale.height = = 0 or bale.length = = 0 ) then
                    Logging.xmlError(xmlFile, "Missing size attributes for square bale.Requires width, height and length." )
                        return false
                    end

                    bale.fillTypes = { }
                    xmlFile:iterate( "bale.fillTypes.fillType" , function (index, key)
                        local fillTypeName = xmlFile:getValue(key .. "#name" )
                        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                        if fillTypeIndex ~ = nil then
                            local fillTypeData = { }
                            fillTypeData.fillTypeIndex = fillTypeIndex
                            fillTypeData.capacity = xmlFile:getValue(key .. "#capacity" , 0 )
                            table.insert(bale.fillTypes, fillTypeData)
                        else
                                Logging.xmlWarning(xmlFile, "Unknown fill type '%s' for bale in '%s'" , fillTypeName, key)
                                end
                            end )

                            bale.variations = { }
                            xmlFile:iterate( "bale.variations.variation" , function (index, key)
                                local id = xmlFile:getValue(key .. "#id" )
                                if id ~ = nil then
                                    local variationData = { }
                                    variationData.id = id
                                    table.insert(bale.variations, variationData)
                                end
                            end )

                            if #bale.variations = = 0 then
                                table.insert(bale.variations, { id = "DEFAULT" } )
                            end
                        else
                                Logging.xmlError(xmlFile, "No i3D file defined in bale xml." )
                                return false
                            end

                            return true
                        end

```

### loadBaleFromXML

**Description**

**Definition**

> loadBaleFromXML()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | key           |
| any | baseDirectory |

**Code**

```lua
function BaleManager:loadBaleFromXML(xmlFile, key, baseDirectory)
    if type(xmlFile) ~ = "table" then
        xmlFile = XMLFile.wrap(xmlFile)
    end

    local xmlFilename = xmlFile:getString(key .. "#filename" )
    if xmlFilename ~ = nil then
        local bale = { }
        bale.xmlFilename = Utils.getFilename(xmlFilename, baseDirectory)
        bale.isAvailable = xmlFile:getBool(key .. "#isAvailable" , true )
        local baleXmlFile = XMLFile.load( "TempBale" , bale.xmlFilename, BaleManager.baleXMLSchema)
        if baleXmlFile ~ = nil then
            local success = self:loadBaleDataFromXML(bale, baleXmlFile, baseDirectory)
            baleXmlFile:delete()
            if success then
                table.insert( self.bales, bale)
                return true
            end
        end
    end

    Logging.xmlError(xmlFile, "Failed to load bale from xml '%s'" , key)

    return false
end

```

### loadBales

**Description**

**Definition**

> loadBales()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | baseDirectory |

**Code**

```lua
function BaleManager:loadBales(xmlFile, baseDirectory)
    xmlFile:iterate( "map.bales.bale" , function (index, key)
        self:loadBaleFromXML(xmlFile, key, baseDirectory)
    end )

    return true
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | missionInfo   |
| any | baseDirectory |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function BaleManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    BaleManager:superClass().loadMapData( self )

    local filename = getXMLString(xmlFile, "map.bales#filename" )
    if filename = = nil then
        Logging.xmlInfo(xmlFile, "No bales xml defined in map" )
        return false
    end
    local xmlFilename = Utils.getFilename(filename, baseDirectory)
    local balesXMLFile = XMLFile.load( "TempBales" , xmlFilename, BaleManager.mapBalesXMLSchema)
    if balesXMLFile ~ = nil then
        self:loadBales(balesXMLFile, baseDirectory)
        balesXMLFile:delete()
    end

    for i = # self.modBalesToLoad, 1 , - 1 do
        local bale = self.modBalesToLoad[i]
        local baleXmlFile = XMLFile.load( "TempBale" , bale.xmlFilename, BaleManager.baleXMLSchema)
        if baleXmlFile ~ = nil then
            if self:loadBaleDataFromXML(bale, baleXmlFile, bale.baseDirectory) then
                table.insert( self.bales, bale)
            end
            baleXmlFile:delete()
        end
        table.remove( self.modBalesToLoad, i)
    end

    BaleManager.SEND_NUM_BITS = MathUtil.getNumRequiredBits(# self.bales)

    for _, bale in ipairs( self.bales) do
        bale.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(bale.i3dFilename, false , true , self.baleLoaded, self , bale)
    end

    if g_addCheatCommands then
        addConsoleCommand( "gsBaleAdd" , "Adds a bale" , "consoleCommandAddBale" , self , "[fillTypeName]; [isRoundbale]; [width]; [height]; [length]; [wrapState]; [modName]" )
        addConsoleCommand( "gsBaleAddAll" , "Adds a bale" , "consoleCommandAddBaleAll" , self , "[drawSizeBox]" )
        addConsoleCommand( "gsBaleList" , "List available bale types" , "consoleCommandListBales" , self )
    end

    return true
end

```

### loadModBaleFromXML

**Description**

**Definition**

> loadModBaleFromXML()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function BaleManager:loadModBaleFromXML(xmlFile, key, baseDirectory, customEnvironment)
    if type(xmlFile) ~ = "table" then
        xmlFile = XMLFile.wrap(xmlFile)
    end

    local xmlFilename = xmlFile:getString(key .. "#filename" )
    if xmlFilename ~ = nil then
        xmlFilename = Utils.getFilename(xmlFilename, baseDirectory)

        local bale = { }
        bale.xmlFilename = xmlFilename
        bale.baseDirectory = baseDirectory
        bale.customEnvironment = customEnvironment
        bale.isAvailable = xmlFile:getBool(key .. "#isAvailable" , true )

        table.insert( self.modBalesToLoad, bale)
        return true
    end

    Logging.xmlError(xmlFile, "Failed to load bale from xml '%s'" , key)

    return false
end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function BaleManager.new(customMt)
    local self = AbstractManager.new(customMt or BaleManager _mt)

    BaleManager.baleXMLSchema = XMLSchema.new( "bale" )
    BaleManager.registerBaleXMLPaths( BaleManager.baleXMLSchema)

    BaleManager.mapBalesXMLSchema = XMLSchema.new( "mapBales" )
    BaleManager.registerMapBalesXMLPaths( BaleManager.mapBalesXMLSchema)

    return self
end

```

### registerBaleTextureXMLPaths

**Description**

**Definition**

> registerBaleTextureXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function BaleManager.registerBaleTextureXMLPaths(schema, basePath)
    schema:register(XMLValueType.FILENAME, basePath .. ".diffuse#filename" , "Diffuse texture to apply to all mesh nodes" )
    schema:register(XMLValueType.BOOL, basePath .. ".diffuse#useFillTypeArray" , "Use the fill type array texture for diffuse" , false )

        schema:register(XMLValueType.FILENAME, basePath .. ".normal#filename" , "Normal texture to apply to all mesh nodes" )
        schema:register(XMLValueType.BOOL, basePath .. ".normal#useFillTypeArray" , "Use the fill type array texture for normal" , false )

            schema:register(XMLValueType.FILENAME, basePath .. ".alpha#filename" , "Alpha texture to apply to all mesh nodes" )

            schema:register(XMLValueType.FILENAME, basePath .. ".baleNormal#filename" , "Bale normal texture to apply to all mesh nodes" )

            schema:register(XMLValueType.FILENAME, basePath .. ".netWrapDiffuse#filename" , "Net wrap diffuse texture to apply to all mesh nodes" )
            schema:register(XMLValueType.FILENAME, basePath .. ".netWrapNormal#filename" , "Net Wrap normal texture to apply to all mesh nodes" )
        end

```

### registerBaleXMLPaths

**Description**

**Definition**

> registerBaleXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function BaleManager.registerBaleXMLPaths(schema)
    schema:register(XMLValueType.STRING, "bale.filename" , "Path to i3d file" )

    schema:register(XMLValueType.BOOL, "bale.size#isRoundbale" , "Bale is a roundbale" , true )
    schema:register(XMLValueType.FLOAT, "bale.size#width" , "Bale Width" , 0 )
    schema:register(XMLValueType.FLOAT, "bale.size#height" , "Bale Height" , 0 )
    schema:register(XMLValueType.FLOAT, "bale.size#length" , "Bale Length" , 0 )
    schema:register(XMLValueType.FLOAT, "bale.size#diameter" , "Bale Diameter" , 0 )
    schema:register(XMLValueType.INT, "bale.size#maxStackHeight" , "Max.stack height for automatic spawning of bales" , "2 or round bales and 3 for square bales" )
        schema:register(XMLValueType.FLOAT, "bale.size#visualWidth" , "Bale Width(Real size of the visuals if different)" , "Same as #width" )
            schema:register(XMLValueType.FLOAT, "bale.size#visualHeight" , "Bale Height(Real size of the visuals if different)" , "Same as #height" )
                schema:register(XMLValueType.FLOAT, "bale.size#visualLength" , "Bale Length(Real size of the visuals if different)" , "Same as #length" )
                    schema:register(XMLValueType.FLOAT, "bale.size#visualDiameter" , "Bale Diameter(Real size of the visuals if different)" , "Same as #diameter" )

                        schema:register(XMLValueType.NODE_INDEX, "bale.mountableObject#triggerNode" , "Trigger node" )
                        schema:register(XMLValueType.FLOAT, "bale.mountableObject#forceAcceleration" , "Acceleration force" , 4 )
                        schema:register(XMLValueType.FLOAT, "bale.mountableObject#forceLimitScale" , "Force limit scale" , 1 )
                        schema:register(XMLValueType.BOOL, "bale.mountableObject#axisFreeY" , "Joint is free in Y direction" , false )
                        schema:register(XMLValueType.BOOL, "bale.mountableObject#axisFreeX" , "Joint is free in X direction" , false )

                        schema:register(XMLValueType.STRING, "bale.uvId" , "Specify that this bale model has a custom UV.This will result in baleWrapper to replace the bale if the UV is different to the defined one in the baleWrapper.So the baleWrapper will always use a bale with a UV that matches the wrapping texture." , "DEFAULT" )

                            schema:register(XMLValueType.NODE_INDEX, "bale.baleMeshes.baleMesh(?)#node" , "Path to mesh node" )
                            schema:register(XMLValueType.BOOL, "bale.baleMeshes.baleMesh(?)#supportsWrapping" , "Defines if the mesh is hidden while wrapping or not" )
                                schema:register(XMLValueType.STRING, "bale.baleMeshes.baleMesh(?)#fillTypes" , "If defined this mesh is only visible if any of this fillTypes is set" )
                                    schema:register(XMLValueType.BOOL, "bale.baleMeshes.baleMesh(?)#isTensionBeltMesh" , "Defines if this mesh is detected for tension belt calculation" , false )
                                        schema:register(XMLValueType.BOOL, "bale.baleMeshes.baleMesh(?)#isAlphaMesh" , "Defines if the mesh is a alpha mesh(different material will be applied)" , false )

                                            schema:register(XMLValueType.STRING, "bale.fillTypes.fillType(?)#name" , "Name of fill type" )
                                            schema:register(XMLValueType.FLOAT, "bale.fillTypes.fillType(?)#capacity" , "Fill level of bale with this fill type" )
                                            schema:register(XMLValueType.FLOAT, "bale.fillTypes.fillType(?)#mass" , "Mass of bale with this fill type" , 500 )
                                            schema:register(XMLValueType.FLOAT, "bale.fillTypes.fillType(?)#forceAcceleration" , "Force acceleration value of bale with this fill type" , "bale.mountableObject#forceAcceleration" )
                                            schema:register(XMLValueType.BOOL, "bale.fillTypes.fillType(?)#supportsWrapping" , "Wrapping is allowed while this type is used" )
                                                schema:register(XMLValueType.STRING, "bale.fillTypes.fillType(?)#materialName" , "Bale material to use" )
                                                schema:register(XMLValueType.STRING, "bale.fillTypes.fillType(?)#alphaMaterialName" , "Bale material to use on alpha mesh parts" )
                                                BaleManager.registerBaleTextureXMLPaths(schema, "bale.fillTypes.fillType(?)" )

                                                schema:register(XMLValueType.STRING, "bale.variations.variation(?)#id" , "Variation identifier" )
                                                BaleManager.registerBaleTextureXMLPaths(schema, "bale.variations.variation(?)" )

                                                schema:register(XMLValueType.STRING, "bale.fillTypes.fillType(?).fermenting#outputFillType" , "Output fill type after fermenting" )
                                                schema:register(XMLValueType.BOOL, "bale.fillTypes.fillType(?).fermenting#requiresWrapping" , "Wrapping is required to start fermenting" , true )
                                                schema:register(XMLValueType.FLOAT, "bale.fillTypes.fillType(?).fermenting#time" , "Fermenting time in ingame days which represent months" , 1 )

                                                -- packed bales
                                                schema:register(XMLValueType.STRING, "bale.packedBale#singleBale" , "Path to single bale xml filename" )
                                                schema:register(XMLValueType.NODE_INDEX, "bale.packedBale.singleBale(?)#node" , "Single bale spawn node" )
                                            end

```

### registerFermentation

**Description**

> Register bale fermentation

**Definition**

> registerFermentation(table bale, float currentTime, float maxTime)

**Arguments**

| table | bale        | bale object                     |
|-------|-------------|---------------------------------|
| float | currentTime | current fermentation time in ms |
| float | maxTime     | max fermentation time           |

**Code**

```lua
function BaleManager:registerFermentation(bale, currentTime, maxTime)
    if not Platform.gameplay.hasBaleFermentation then
        maxTime = 0
    end

    maxTime = maxTime * g_currentMission.missionInfo.economicDifficulty

    local fermentation = { }
    fermentation.bale = bale
    fermentation.time = currentTime
    fermentation.percentageSend = 0
    fermentation.maxTime = maxTime

    table.insert( self.fermentations, fermentation)
end

```

### registerMapBalesXMLPaths

**Description**

**Definition**

> registerMapBalesXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function BaleManager.registerMapBalesXMLPaths(schema)
    schema:register(XMLValueType.STRING, "map.bales.bale(?)#filename" , "Path to bale xml" )
    schema:register(XMLValueType.STRING, "map.bales.bale(?)#isAvailable" , "Bale is available for all balers to spawn" )
    end

```

### removeFermentation

**Description**

> Removed fermentation of given bale

**Definition**

> removeFermentation(table bale)

**Arguments**

| table | bale | bale object |
|-------|------|-------------|

**Code**

```lua
function BaleManager:removeFermentation(bale)
    for i = # self.fermentations, 1 , - 1 do
        if self.fermentations[i].bale = = bale then
            table.remove( self.fermentations, i)
        end
    end
end

```

### unloadBaleData

**Description**

> Unload bale data

**Definition**

> unloadBaleData()

**Code**

```lua
function BaleManager:unloadBaleData()
    for _, bale in ipairs( self.bales) do
        if bale.sharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(bale.sharedLoadRequestId)
            bale.sharedLoadRequestId = nil
        end
        if bale.sharedRoot ~ = nil then
            delete(bale.sharedRoot)
            bale.sharedRoot = nil
        end
    end
end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function BaleManager:unloadMapData()
    self:unloadBaleData()

    if g_addCheatCommands then
        removeConsoleCommand( "gsBaleAdd" )
        removeConsoleCommand( "gsBaleList" )
    end

    BaleManager:superClass().unloadMapData( self )
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
function BaleManager:update(dt)
    if g_server ~ = nil then
        local numFermentations = # self.fermentations
        if numFermentations > 0 then
            local timeScale = g_currentMission:getEffectiveTimeScale()

            for i = numFermentations, 1 , - 1 do
                local fermentation = self.fermentations[i]

                fermentation.time = fermentation.time + dt * timeScale
                if fermentation.time > = fermentation.maxTime then
                    fermentation.bale:onFermentationUpdate( 1 )
                    fermentation.bale:onFermentationEnd()
                    table.remove( self.fermentations, i)
                else
                        local percentage = fermentation.time / fermentation.maxTime
                        if math.floor(percentage * 100 ) ~ = math.floor(fermentation.percentageSend * 100 ) then
                            fermentation.bale:onFermentationUpdate(percentage)
                            fermentation.percentageSend = percentage
                        end
                    end
                end
            end
        end
    end

```