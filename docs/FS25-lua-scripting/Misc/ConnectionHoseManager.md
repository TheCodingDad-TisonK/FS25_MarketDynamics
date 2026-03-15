## ConnectionHoseManager

**Description**

> This class handles all connection hoses

**Parent**

> [AbstractManager](?version=script&category=58&class=557)

**Functions**

- [adapterI3DFileLoaded](#adapteri3dfileloaded)
- [addModConnectionHoses](#addmodconnectionhoses)
- [basicHoseI3DFileLoaded](#basichosei3dfileloaded)
- [closeSocket](#closesocket)
- [getClonedAdapterNode](#getclonedadapternode)
- [getClonedBasicHose](#getclonedbasichose)
- [getClonedHoseNode](#getclonedhosenode)
- [getHoseAdapterByName](#gethoseadapterbyname)
- [getHoseMaterialByName](#gethosematerialbyname)
- [getHoseTypeByName](#gethosetypebyname)
- [getSocketByName](#getsocketbyname)
- [getSocketTarget](#getsockettarget)
- [initDataStructures](#initdatastructures)
- [linkSocketToNode](#linksockettonode)
- [loadConnectionHosesFromXML](#loadconnectionhosesfromxml)
- [loadMapData](#loadmapdata)
- [materialI3DFileLoaded](#materiali3dfileloaded)
- [new](#new)
- [openSocket](#opensocket)
- [registerXMLPaths](#registerxmlpaths)
- [socketI3DFileLoaded](#socketi3dfileloaded)
- [unloadMapData](#unloadmapdata)

### adapterI3DFileLoaded

**Description**

> Called when adapter i3d file was loaded

**Definition**

> adapterI3DFileLoaded(string name, , )

**Arguments**

| string | name         | connectionHoseType index name |
|--------|--------------|-------------------------------|
| any    | failedReason |                               |
| any    | args         |                               |

**Code**

```lua
function ConnectionHoseManager:adapterI3DFileLoaded(i3dNode, failedReason, args)
    local hoseType = args.hoseType
    local adapterName = args.adapterName
    local xmlFile = args.xmlFile
    local adapterKey = args.adapterKey

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local node = xmlFile:getValue(adapterKey .. "#node" , nil , i3dNode)
        local hoseReferenceNode = getChildAt(node, 0 )
        unlink(node)

        local detachedNode = xmlFile:getValue(adapterKey .. "#detachedNode" , nil , i3dNode)
        if detachedNode ~ = nil then
            unlink(detachedNode)
        end

        if hoseReferenceNode ~ = 0 then
            local entry = { }
            entry.node = node
            entry.detachedNode = detachedNode
            entry.hoseReferenceNode = hoseReferenceNode
            hoseType.adapters[ string.upper(adapterName)] = entry
        else
                printWarning( string.format( "Warning:Missing hose reference node as child from adapter '%s' in connection type '%s'" , adapterName, hoseType.name))
            end

            delete(i3dNode)
        end

        xmlFile.references = xmlFile.references - 1
        if xmlFile.references = = 0 then
            self.xmlFiles[xmlFile] = nil
            xmlFile:delete()
        end
    end

```

### addModConnectionHoses

**Description**

> Add mod connection hose xml to load

**Definition**

> addModConnectionHoses(string xmlFilename, string customEnvironment, string baseDirectory)

**Arguments**

| string | xmlFilename       | path to connection hose xml file |
|--------|-------------------|----------------------------------|
| string | customEnvironment | custom environment               |
| string | baseDirectory     | base rirectory                   |

**Code**

```lua
function ConnectionHoseManager:addModConnectionHoses(xmlFilename, customEnvironment, baseDirectory)
    table.insert( self.modConnectionHosesToLoad, { xmlFilename = xmlFilename,
    customEnvironment = customEnvironment,
    baseDirectory = baseDirectory } )
end

```

### basicHoseI3DFileLoaded

**Description**

> Called when basic hose i3d file was loaded

**Definition**

> basicHoseI3DFileLoaded(string name, , )

**Arguments**

| string | name         | connectionHoseType index name |
|--------|--------------|-------------------------------|
| any    | failedReason |                               |
| any    | args         |                               |

**Code**

```lua
function ConnectionHoseManager:basicHoseI3DFileLoaded(i3dNode, failedReason, args)
    local xmlFile = args.xmlFile
    local hoseKey = args.hoseKey

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local node = xmlFile:getValue(hoseKey .. "#node" , nil , i3dNode)
        if node ~ = nil then
            unlink(node)
            local entry = { }
            entry.node = node
            entry.startStraightening = xmlFile:getValue(hoseKey .. "#startStraightening" , 2 )
            entry.endStraightening = xmlFile:getValue(hoseKey .. "#endStraightening" , 2 )
            entry.minCenterPointAngle = xmlFile:getValue(hoseKey .. "#minCenterPointAngle" , 90 )

            local length = xmlFile:getValue(hoseKey .. "#length" )
            if length = = nil then
                printWarning( string.format( "Warning:Missing length attribute in '%s'" , hoseKey))
            end

            local realLength = xmlFile:getValue(hoseKey .. "#realLength" )
            if realLength = = nil then
                printWarning( string.format( "Warning:Missing realLength attribute in '%s'" , hoseKey))
            end

            local diameter = xmlFile:getValue(hoseKey .. "#diameter" )
            if diameter = = nil then
                printWarning( string.format( "Warning:Missing diameter attribute in '%s'" , hoseKey))
            end

            if length ~ = nil and realLength ~ = nil and diameter ~ = nil then
                entry.length = length
                entry.realLength = realLength
                entry.diameter = diameter
                table.insert( self.basicHoses, entry)
            end
        end

        delete(i3dNode)
    end

    xmlFile.references = xmlFile.references - 1
    if xmlFile.references = = 0 then
        self.xmlFiles[xmlFile] = nil
        xmlFile:delete()
    end
end

```

### closeSocket

**Description**

**Definition**

> closeSocket()

**Arguments**

| any | socket |
|-----|--------|

**Code**

```lua
function ConnectionHoseManager:closeSocket(socket)
    if socket ~ = nil then
        if #socket.caps > 0 then
            for _, cap in ipairs(socket.caps) do
                if cap.openedRotation ~ = nil then
                    setRotation(cap.node, unpack(cap.closedRotation))
                end
                setVisibility(cap.node, cap.closedVisibility)
            end
        end
    end
end

```

### getClonedAdapterNode

**Description**

**Definition**

> getClonedAdapterNode()

**Arguments**

| any | typeName          |
|-----|-------------------|
| any | adapterName       |
| any | customEnvironment |
| any | detached          |

**Code**

```lua
function ConnectionHoseManager:getClonedAdapterNode(typeName, adapterName, customEnvironment, detached)
    local hoseType = self:getHoseTypeByName(typeName, customEnvironment)
    if hoseType ~ = nil then
        local adapter = self:getHoseAdapterByName(hoseType, adapterName, customEnvironment)
        if adapter ~ = nil then
            if not detached then
                local adapterNodeClone = clone(adapter.node, true )
                setTranslation(adapterNodeClone, 0 , 0 , 0 )
                setRotation(adapterNodeClone, 0 , 0 , 0 )

                local hoseReferenceNodeClone = getChildAt(adapterNodeClone, 0 )

                return adapterNodeClone, hoseReferenceNodeClone
            elseif adapter.detachedNode ~ = nil then
                    local detachedNodeClone = clone(adapter.detachedNode, true )
                    setTranslation(detachedNodeClone, 0 , 0 , 0 )
                    setRotation(detachedNodeClone, 0 , 0 , 0 )

                    return detachedNodeClone
                end
            end
        end

        return nil
    end

```

### getClonedBasicHose

**Description**

**Definition**

> getClonedBasicHose()

**Arguments**

| any | length   |
|-----|----------|
| any | diameter |

**Code**

```lua
function ConnectionHoseManager:getClonedBasicHose(length, diameter)
    -- look for the most exact diameter we can get
        local minDiameterDiff = math.huge
        local closestDiameter = math.huge
        for _, hose in pairs( self.basicHoses) do
            local diff = math.abs(hose.diameter - diameter)
            if minDiameterDiff > diff then
                minDiameterDiff = diff
                closestDiameter = hose.diameter
            end
        end

        -- get all hoses with that diameter
        local foundHoses = { }
        for _, hose in pairs( self.basicHoses) do
            local diff = math.abs(hose.diameter - closestDiameter)
            if diff < = 0.0001 then
                table.insert(foundHoses, hose)
            end
        end

        --look for the hose with the most exact length
            local minLengthDiff = math.huge
            local foundHose
            for _, hose in pairs(foundHoses) do
                local diff = math.abs(hose.length - length)
                if minLengthDiff > diff then
                    minLengthDiff = diff
                    foundHose = hose
                end
            end

            if foundHose ~ = nil then
                return clone(foundHose.node, true ), foundHose.realLength, foundHose.startStraightening, foundHose.endStraightening, foundHose.minCenterPointAngle, closestDiameter
            end

            return nil
        end

```

### getClonedHoseNode

**Description**

**Definition**

> getClonedHoseNode()

**Arguments**

| any | typeName          |
|-----|-------------------|
| any | hoseName          |
| any | length            |
| any | diameter          |
| any | vehicleMaterial   |
| any | customEnvironment |

**Code**

```lua
function ConnectionHoseManager:getClonedHoseNode(typeName, hoseName, length, diameter, vehicleMaterial, customEnvironment)
    local hoseType = self:getHoseTypeByName(typeName, customEnvironment)
    if hoseType ~ = nil then
        local material = self:getHoseMaterialByName(hoseType, hoseName, customEnvironment)
        if material ~ = nil then
            local hoseNodeClone, realLength, startStraightening, endStraightening, minCenterPointAngle, closestDiameter = self:getClonedBasicHose(length, diameter)
            if hoseNodeClone ~ = nil then
                local mat = getMaterial(material.materialNode, 0 )
                setMaterial(hoseNodeClone, mat, 0 )

                if material.materialTemplate ~ = nil then
                    material.materialTemplate:apply(hoseNodeClone)
                end

                if vehicleMaterial ~ = nil then
                    -- clear the diffuse map so we multiply with a pure white diffuse
                    local newMat = setMaterialDiffuseMapFromFile(mat, "data/shared/detailLibrary/metallic/clear_diffuse.dds" , true , true , false )
                    setMaterial(hoseNodeClone, newMat, 0 )

                    vehicleMaterial:apply(hoseNodeClone)
                end

                setShaderParameter(hoseNodeClone, "lengthAndDiameter" , realLength, diameter / closestDiameter, nil , nil , false )

                if material.uvMinMax ~ = nil then
                    local scale = material.uvMinMax[ 2 ] - material.uvMinMax[ 1 ]
                    setShaderParameter(hoseNodeClone, "uvScale" , (length / realLength) * material.uvLengthScale, scale, nil , nil , false )

                    local xOffset, yOffset = material.uvRandomOffset[ 1 ], material.uvRandomOffset[ 2 ]
                    if xOffset ~ = 0 then
                        xOffset = math.random() * xOffset
                    end
                    if yOffset ~ = 0 then
                        yOffset = math.random() * yOffset
                    end
                    setShaderParameter(hoseNodeClone, "offsetUV" , xOffset, material.uvMinMax[ 1 ] + yOffset, nil , nil , false )
                end

                return hoseNodeClone, startStraightening, endStraightening, minCenterPointAngle
            end
        end
    end

    return nil , nil , nil , nil
end

```

### getHoseAdapterByName

**Description**

**Definition**

> getHoseAdapterByName()

**Arguments**

| any | hoseType          |
|-----|-------------------|
| any | adapterName       |
| any | customEnvironment |

**Code**

```lua
function ConnectionHoseManager:getHoseAdapterByName(hoseType, adapterName, customEnvironment)
    if hoseType = = nil or adapterName = = nil then
        return nil
    end

    if customEnvironment ~ = nil then
        local customTypeName = string.upper(customEnvironment .. "." .. adapterName)
        if hoseType.adapters[customTypeName] ~ = nil then
            return hoseType.adapters[customTypeName]
        end
    end

    return hoseType.adapters[ string.upper(adapterName)]
end

```

### getHoseMaterialByName

**Description**

**Definition**

> getHoseMaterialByName()

**Arguments**

| any | hoseType          |
|-----|-------------------|
| any | materialName      |
| any | customEnvironment |

**Code**

```lua
function ConnectionHoseManager:getHoseMaterialByName(hoseType, materialName, customEnvironment)
    if hoseType = = nil or materialName = = nil then
        return nil
    end

    if customEnvironment ~ = nil then
        local customTypeName = string.upper(customEnvironment .. "." .. materialName)
        if hoseType.hoses[customTypeName] ~ = nil then
            return hoseType.hoses[customTypeName]
        end
    end

    return hoseType.hoses[ string.upper(materialName)]
end

```

### getHoseTypeByName

**Description**

**Definition**

> getHoseTypeByName()

**Arguments**

| any | typeName          |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function ConnectionHoseManager:getHoseTypeByName(typeName, customEnvironment)
    if typeName = = nil then
        return nil
    end

    if customEnvironment ~ = nil then
        local customTypeName = string.upper(customEnvironment .. "." .. typeName)
        if self.typeByName[customTypeName] ~ = nil then
            return self.typeByName[customTypeName]
        end
    end

    return self.typeByName[ string.upper(typeName)]
end

```

### getSocketByName

**Description**

**Definition**

> getSocketByName()

**Arguments**

| any | socketName        |
|-----|-------------------|
| any | customEnvironment |

**Code**

```lua
function ConnectionHoseManager:getSocketByName(socketName, customEnvironment)
    if socketName = = nil then
        return nil
    end

    if customEnvironment ~ = nil then
        local customTypeName = string.upper(customEnvironment .. "." .. socketName)
        if self.sockets[customTypeName] ~ = nil then
            return self.sockets[customTypeName]
        end
    end

    return self.sockets[ string.upper(socketName)]
end

```

### getSocketTarget

**Description**

**Definition**

> getSocketTarget()

**Arguments**

| any | socket        |
|-----|---------------|
| any | defaultTarget |

**Code**

```lua
function ConnectionHoseManager:getSocketTarget(socket, defaultTarget)
    if socket ~ = nil then
        if socket.referenceNode ~ = nil then
            return socket.referenceNode
        end
    end

    return defaultTarget
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function ConnectionHoseManager:initDataStructures()
    self.xmlFiles = { }
    self.typeByName = { }
    ConnectionHoseType = self.typeByName
    self.basicHoses = { }
    self.sockets = { }
    self.sharedLoadRequestIds = { }
    self.modConnectionHosesToLoad = { }
end

```

### linkSocketToNode

**Description**

**Definition**

> linkSocketToNode()

**Arguments**

| any | socketName        |
|-----|-------------------|
| any | node              |
| any | customEnvironment |
| any | socketMaterial    |

**Code**

```lua
function ConnectionHoseManager:linkSocketToNode(socketName, node, customEnvironment, socketMaterial)
    local socket = self:getSocketByName(socketName, customEnvironment)
    if socket ~ = nil and node ~ = nil then
        local linkedSocket = { }
        linkedSocket.node = clone(socket.node, true )
        setTranslation(linkedSocket.node, 0 , 0 , 0 )
        setRotation(linkedSocket.node, 0 , 0 , 0 )

        linkedSocket.referenceNode = I3DUtil.indexToObject(linkedSocket.node, socket.referenceNode)

        linkedSocket.caps = { }
        for _, cap in ipairs(socket.caps) do
            local clonedCap = { }
            for i, v in pairs(cap) do
                clonedCap[i] = v
            end

            clonedCap.node = I3DUtil.indexToObject(linkedSocket.node, clonedCap.node)
            table.insert(linkedSocket.caps, clonedCap)
        end

        if socketMaterial ~ = nil then
            socketMaterial:apply(linkedSocket.node, "connector_color_mat" )
        end

        link(node, linkedSocket.node)
        self:closeSocket(linkedSocket)

        return linkedSocket
    end

    return nil
end

```

### loadConnectionHosesFromXML

**Description**

> Loads Connection hoses

**Definition**

> loadConnectionHosesFromXML(string xmlFilename, string customEnvironment, string baseDirectory)

**Arguments**

| string | xmlFilename       | path to connection hose xml file |
|--------|-------------------|----------------------------------|
| string | customEnvironment | custom environment               |
| string | baseDirectory     | base rirectory                   |

**Code**

```lua
function ConnectionHoseManager:loadConnectionHosesFromXML(xmlFilename, customEnvironment, baseDirectory)
    Logging.info( "Loading ConnectionHoses from '%s'" , xmlFilename)

    local xmlFile = XMLFile.load( "TempHoses" , xmlFilename, ConnectionHoseManager.xmlSchema)
    if xmlFile ~ = nil then
        self.xmlFiles[xmlFile] = true
        xmlFile.references = 1
        --load basic hoses
        local i = 0
        while true do
            local hoseKey = string.format( "connectionHoses.basicHoses.basicHose(%d)" , i)
            if not xmlFile:hasProperty(hoseKey) then
                break
            end

            local filename = xmlFile:getValue(hoseKey .. "#filename" )
            if filename ~ = nil then
                xmlFile.references = xmlFile.references + 1
                filename = Utils.getFilename(filename, baseDirectory)

                local arguments = {
                xmlFile = xmlFile,
                hoseKey = hoseKey
                }
                local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.basicHoseI3DFileLoaded, self , arguments)
                table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
            end

            i = i + 1
        end

        --load hose types
        i = 0
        while true do
            local key = string.format( "connectionHoses.connectionHoseTypes.connectionHoseType(%d)" , i)
            if not xmlFile:hasProperty(key) then
                break
            end

            local name = xmlFile:getValue(key .. "#name" )
            if name ~ = nil then
                local hoseType
                if self.typeByName[ string.upper(name)] ~ = nil then
                    hoseType = self.typeByName[ string.upper(name)]
                else
                        if customEnvironment ~ = nil then
                            name = customEnvironment .. "." .. name
                        end

                        hoseType = { }
                        hoseType.name = name
                        hoseType.adapters = { }
                        hoseType.hoses = { }

                        self.typeByName[ string.upper(name)] = hoseType
                    end

                    local j = 0
                    while true do
                        local adapterKey = string.format( "%s.adapter(%d)" , key, j)
                        if not xmlFile:hasProperty(adapterKey) then
                            break
                        end

                        local adapterName = xmlFile:getValue(adapterKey .. "#name" , "DEFAULT" )
                        if customEnvironment ~ = nil then
                            adapterName = customEnvironment .. "." .. adapterName
                        end

                        local filename = xmlFile:getValue(adapterKey .. "#filename" )
                        if filename ~ = nil then
                            xmlFile.references = xmlFile.references + 1
                            filename = Utils.getFilename(filename, baseDirectory)

                            local arguments = {
                            hoseType = hoseType,
                            adapterName = adapterName,
                            xmlFile = xmlFile,
                            adapterKey = adapterKey
                            }
                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.adapterI3DFileLoaded, self , arguments)
                            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                        end
                        j = j + 1
                    end

                    j = 0
                    while true do
                        local hoseKey = string.format( "%s.material(%d)" , key, j)
                        if not xmlFile:hasProperty(hoseKey) then
                            break
                        end

                        local hoseName = xmlFile:getValue(hoseKey .. "#name" , "DEFAULT" )
                        if customEnvironment ~ = nil then
                            hoseName = customEnvironment .. "." .. hoseName
                        end

                        local filename = xmlFile:getValue(hoseKey .. "#filename" )
                        if filename ~ = nil then
                            xmlFile.references = xmlFile.references + 1
                            filename = Utils.getFilename(filename, baseDirectory)

                            local arguments = {
                            hoseType = hoseType,
                            hoseName = hoseName,
                            xmlFile = xmlFile,
                            hoseKey = hoseKey
                            }
                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.materialI3DFileLoaded, self , arguments)
                            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                        end
                        j = j + 1
                    end
                end

                i = i + 1
            end

            --load basic hoses
            i = 0
            while true do
                local socketKey = string.format( "connectionHoses.sockets.socket(%d)" , i)
                if not xmlFile:hasProperty(socketKey) then
                    break
                end

                local name = xmlFile:getValue(socketKey .. "#name" )
                if customEnvironment ~ = nil then
                    name = customEnvironment .. "." .. name
                end

                local filename = xmlFile:getValue(socketKey .. "#filename" )
                if name ~ = nil and filename ~ = nil then
                    xmlFile.references = xmlFile.references + 1
                    filename = Utils.getFilename(filename, baseDirectory)

                    local arguments = {
                    name = name,
                    xmlFile = xmlFile,
                    socketKey = socketKey
                    }
                    local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.socketI3DFileLoaded, self , arguments)
                    table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
                end
                i = i + 1
            end

            xmlFile.references = xmlFile.references - 1
            if xmlFile.references = = 0 then
                self.xmlFiles[xmlFile] = nil
                xmlFile:delete()
            end
        end
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
function ConnectionHoseManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    ConnectionHoseManager:superClass().loadMapData( self )
    self.baseDirectory = baseDirectory
    self:loadConnectionHosesFromXML( ConnectionHoseManager.DEFAULT_HOSES_FILENAME, nil , self.baseDirectory)

    for i = # self.modConnectionHosesToLoad, 1 , - 1 do
        local modConnectionHoseToLoad = self.modConnectionHosesToLoad[i]
        self:loadConnectionHosesFromXML(modConnectionHoseToLoad.xmlFilename, modConnectionHoseToLoad.customEnvironment, modConnectionHoseToLoad.baseDirectory)
        self.modConnectionHosesToLoad[i] = nil
    end
end

```

### materialI3DFileLoaded

**Description**

> Called when material i3d file was loaded

**Definition**

> materialI3DFileLoaded(string name, , )

**Arguments**

| string | name         | connectionHoseType index name |
|--------|--------------|-------------------------------|
| any    | failedReason |                               |
| any    | args         |                               |

**Code**

```lua
function ConnectionHoseManager:materialI3DFileLoaded(i3dNode, failedReason, args)
    local hoseType = args.hoseType
    local hoseName = args.hoseName
    local xmlFile = args.xmlFile
    local hoseKey = args.hoseKey

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local materialNode = xmlFile:getValue(hoseKey .. "#materialNode" , nil , i3dNode)
        unlink(materialNode)
        if materialNode ~ = nil then
            local entry = { }
            entry.materialNode = materialNode
            entry.uvMinMax = xmlFile:getValue(hoseKey .. "#uvMinMax" , nil , true )
            entry.uvLengthScale = xmlFile:getValue(hoseKey .. "#uvLengthScale" , 1 )
            entry.uvRandomOffset = xmlFile:getValue(hoseKey .. "#uvRandomOffset" , "0 0" , true )

            entry.materialTemplate = xmlFile:getValue(hoseKey .. "#materialTemplateName" )

            hoseType.hoses[ string.upper(hoseName)] = entry
        end

        delete(i3dNode)
    end

    xmlFile.references = xmlFile.references - 1
    if xmlFile.references = = 0 then
        self.xmlFiles[xmlFile] = nil
        xmlFile:delete()
    end
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
function ConnectionHoseManager.new(customMt)
    local self = AbstractManager.new(customMt or ConnectionHoseManager _mt)

    self:initDataStructures()

    ConnectionHoseManager.xmlSchema = XMLSchema.new( "connectionHoses" )
    ConnectionHoseManager:registerXMLPaths( ConnectionHoseManager.xmlSchema)

    return self
end

```

### openSocket

**Description**

**Definition**

> openSocket()

**Arguments**

| any | socket |
|-----|--------|

**Code**

```lua
function ConnectionHoseManager:openSocket(socket)
    if socket ~ = nil then
        if #socket.caps > 0 then
            for _, cap in ipairs(socket.caps) do
                if cap.openedRotation ~ = nil then
                    setRotation(cap.node, unpack(cap.openedRotation))
                end
                setVisibility(cap.node, cap.openedVisibility)
            end
        end
    end
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function ConnectionHoseManager:registerXMLPaths(schema)
    schema:register(XMLValueType.STRING, "connectionHoses.basicHoses.basicHose(?)#filename" , "I3d filename" )
    schema:register(XMLValueType.NODE_INDEX, "connectionHoses.basicHoses.basicHose(?)#node" , "Path to hose node" )
    schema:register(XMLValueType.FLOAT, "connectionHoses.basicHoses.basicHose(?)#startStraightening" , "Straightening factor on start side" , 2 )
    schema:register(XMLValueType.FLOAT, "connectionHoses.basicHoses.basicHose(?)#endStraightening" , "Straightening factor on end side" , 2 )
    schema:register(XMLValueType.ANGLE, "connectionHoses.basicHoses.basicHose(?)#minCenterPointAngle" , "Min.bending angle at the center of the hose" , 90 )
    schema:register(XMLValueType.FLOAT, "connectionHoses.basicHoses.basicHose(?)#length" , "Reference length of hose" )
    schema:register(XMLValueType.FLOAT, "connectionHoses.basicHoses.basicHose(?)#realLength" , "Real length of hose in i3d" )
    schema:register(XMLValueType.FLOAT, "connectionHoses.basicHoses.basicHose(?)#diameter" , "Diameter of hose" )

    schema:register(XMLValueType.STRING, "connectionHoses.connectionHoseTypes.connectionHoseType(?)#name" , "Name of type" )
    schema:register(XMLValueType.STRING, "connectionHoses.connectionHoseTypes.connectionHoseType(?).adapter(?)#name" , "Name of adapter" )
    schema:register(XMLValueType.STRING, "connectionHoses.connectionHoseTypes.connectionHoseType(?).adapter(?)#filename" , "Path to i3d file" )
    schema:register(XMLValueType.NODE_INDEX, "connectionHoses.connectionHoseTypes.connectionHoseType(?).adapter(?)#node" , "Adapter node in i3d file" )
    schema:register(XMLValueType.NODE_INDEX, "connectionHoses.connectionHoseTypes.connectionHoseType(?).adapter(?)#detachedNode" , "Detached adapter node in i3d file" )

    schema:register(XMLValueType.STRING, "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#name" , "Name of material" )
    schema:register(XMLValueType.STRING, "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#filename" , "Path to i3d file" )
    schema:register(XMLValueType.NODE_INDEX, "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#materialNode" , "Material node in i3d file" )
    schema:register(XMLValueType.VECTOR_ 2 , "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#uvMinMax" , "Min.and max.range of uv's in Y" )
    schema:register(XMLValueType.FLOAT, "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#uvLengthScale" , "Scale factor of the UV in X axis" , 1 )
    schema:register(XMLValueType.VECTOR_ 2 , "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#uvRandomOffset" , "Random offset range on x and y axis" , "0 0" )
    schema:register(XMLValueType.VEHICLE_MATERIAL, "connectionHoses.connectionHoseTypes.connectionHoseType(?).material(?)#materialTemplateName" , "Material template to be applied by default" )

    schema:register(XMLValueType.STRING, "connectionHoses.sockets.socket(?)#name" , "Socket name" )
    schema:register(XMLValueType.STRING, "connectionHoses.sockets.socket(?)#filename" , "Path to i3d file" )
    schema:register(XMLValueType.NODE_INDEX, "connectionHoses.sockets.socket(?)#node" , "Socket node in i3d" )
    schema:register(XMLValueType.STRING, "connectionHoses.sockets.socket(?)#referenceNode" , "Index of reference node inside socket" )
    schema:register(XMLValueType.STRING, "connectionHoses.sockets.socket(?).cap(?)#node" , "Index of cap node inside socket" )
    schema:register(XMLValueType.VECTOR_ROT, "connectionHoses.sockets.socket(?).cap(?)#openedRotation" , "Opened rotation" )
    schema:register(XMLValueType.VECTOR_ROT, "connectionHoses.sockets.socket(?).cap(?)#closedRotation" , "Closed rotation" )
    schema:register(XMLValueType.BOOL, "connectionHoses.sockets.socket(?).cap(?)#openedVisibility" , "Opened visibility" , true )
    schema:register(XMLValueType.BOOL, "connectionHoses.sockets.socket(?).cap(?)#closedVisibility" , "Closed visibility" , true )
end

```

### socketI3DFileLoaded

**Description**

> Called when socket i3d file was loaded

**Definition**

> socketI3DFileLoaded(string name, , )

**Arguments**

| string | name         | connectionHoseType index name |
|--------|--------------|-------------------------------|
| any    | failedReason |                               |
| any    | args         |                               |

**Code**

```lua
function ConnectionHoseManager:socketI3DFileLoaded(i3dNode, failedReason, args)
    local name = args.name
    local xmlFile = args.xmlFile
    local socketKey = args.socketKey

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local node = xmlFile:getValue(socketKey .. "#node" , nil , i3dNode)

        if node ~ = nil then
            unlink(node)
            local entry = { }
            entry.node = node

            entry.referenceNode = xmlFile:getValue(socketKey .. "#referenceNode" )

            entry.caps = { }

            local j = 0
            while true do
                local capKey = string.format(socketKey .. ".cap(%d)" , j)
                if not xmlFile:hasProperty(capKey) then
                    break
                end

                local cap = { }
                cap.node = xmlFile:getValue(capKey .. "#node" )
                if cap.node ~ = nil then
                    cap.openedRotation = xmlFile:getValue(capKey .. "#openedRotation" , nil , true )
                    cap.closedRotation = xmlFile:getValue(capKey .. "#closedRotation" , nil , true )
                    cap.openedVisibility = xmlFile:getValue(capKey .. "#openedVisibility" , true )
                    cap.closedVisibility = xmlFile:getValue(capKey .. "#closedVisibility" , true )

                    table.insert(entry.caps, cap)
                end

                j = j + 1
            end

            if self.sockets[ string.upper(name)] = = nil then
                self.sockets[ string.upper(name)] = entry
            else
                    Logging.xmlError(xmlFile, "Socket '%s' already exists" , name)
                end
            end

            delete(i3dNode)
        end

        xmlFile.references = xmlFile.references - 1
        if xmlFile.references = = 0 then
            self.xmlFiles[xmlFile] = nil
            xmlFile:delete()
        end
    end

```

### unloadMapData

**Description**

> Load data on map load

**Definition**

> unloadMapData()

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function ConnectionHoseManager:unloadMapData()
    for _, entry in ipairs( self.basicHoses) do
        delete(entry.node)
    end
    for _, hoseType in pairs( self.typeByName) do
        for _, adapter in pairs(hoseType.adapters) do
            delete(adapter.node)
            delete(adapter.detachedNode)
        end
        for _, hose in pairs(hoseType.hoses) do
            delete(hose.materialNode)
        end
    end
    for _, entry in pairs( self.sockets) do
        delete(entry.node)
    end

    for i = 1 , # self.sharedLoadRequestIds do
        local sharedLoadRequestId = self.sharedLoadRequestIds[i]
        g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
    end

    for xmlFile, _ in pairs( self.xmlFiles) do
        self.xmlFiles[xmlFile] = nil
        xmlFile:delete()
    end

    ConnectionHoseManager:superClass().unloadMapData( self )
end

```