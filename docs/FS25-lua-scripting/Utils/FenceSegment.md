## FenceSegment

**Functions**

- [readStream](#readstream)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [writeStream](#writestream)

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, table connection, )

**Arguments**

| integer | streamId    | stream ID  |
|---------|-------------|------------|
| table   | connection  | connection |
| any     | lastSegment |            |

**Code**

```lua
function FenceSegment:readStream(streamId, connection, lastSegment)
    local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
    local paramsY = g_currentMission.vehicleYPosCompressionParams

    if connection:getIsServer() then
        self.id = streamReadUInt16(streamId)
    end

    if streamReadBool(streamId) then
        self.startPosX = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        self.startPosY = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
        self.startPosZ = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
    else
            self.startPosX = lastSegment.endPosX
            self.startPosY = lastSegment.endPosY
            self.startPosZ = lastSegment.endPosZ
        end

        self.endPosX = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        self.endPosY = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
        self.endPosZ = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)

        if self.metadata.poles and # self.metadata.poles > 0 then
            self.hasStartPole = streamReadBool(streamId)
            self.hasEndPole = streamReadBool(streamId)
        end

        self:registerTerrainHeightChangeCallbacks()
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
function FenceSegment.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    schema:register(XMLValueType.ANGLE, basePath .. "#maxVerticalAngle" , "" )
    schema:register(XMLValueType.ANGLE, basePath .. "#maxSlopeAngle" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. "#price" , "price per segment" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".poles.pole(?)#node" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".poles.pole(?)#radius" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".poles.pole(?)#height" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".panels#maxScale" , "" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. ".panels#useRandomization" , "If true and multiple panels are defined for the same length they will be used randomly, otherwise only the first panel is used" , false )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".panels.panel(?)#node" , "" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".panels.panel(?)#collisionNode" , "" )
        schema:register(XMLValueType.FLOAT, basePath .. ".panels.panel(?)#length" , "" )
        schema:register(XMLValueType.FLOAT, basePath .. ".panels.panel(?)#width" , "" )
        schema:register(XMLValueType.FLOAT, basePath .. ".panels.panel(?)#height" , "" )
        schema:register(XMLValueType.BOOL, basePath .. ".panels.panel(?)#alignY" , "" )
    end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function FenceSegment:saveToXMLFile(xmlFile, key)
    if self.startPosX = = nil or self.endPosX = = nil then
        Logging.devInfo( "FenceSegment:saveToXMLFile incomplete fence %s %s %s - %s %s %s" , self.startPosX, self.startPosY, self.startPosZ, self.endPosX, self.endPosY, self.endPosZ)
        return false
    end

    xmlFile:setTranslation(key .. "#start" , self.startPosX, self.startPosY, self.startPosZ)
    xmlFile:setTranslation(key .. "#end" , self.endPosX, self.endPosY, self.endPosZ)

    return true
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, table connection, )

**Arguments**

| integer | streamId    | stream ID  |
|---------|-------------|------------|
| table   | connection  | connection |
| any     | lastSegment |            |

**Code**

```lua
function FenceSegment:writeStream(streamId, connection, lastSegment)
    local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
    local paramsY = g_currentMission.vehicleYPosCompressionParams

    if not connection:getIsServer() then
        streamWriteUInt16(streamId, self.id)
    end

    local sendStartPos = true
    if lastSegment ~ = nil then
        if lastSegment.endPosX = = self.startPosX and lastSegment.endPosY = = self.startPosY and lastSegment.endPosZ = = self.startPosZ then
            sendStartPos = false
        end
    end

    if streamWriteBool(streamId, sendStartPos) then
        NetworkUtil.writeCompressedWorldPosition(streamId, self.startPosX, paramsXZ)
        NetworkUtil.writeCompressedWorldPosition(streamId, self.startPosY, paramsY)
        NetworkUtil.writeCompressedWorldPosition(streamId, self.startPosZ, paramsXZ)
    end

    NetworkUtil.writeCompressedWorldPosition(streamId, self.endPosX, paramsXZ)
    NetworkUtil.writeCompressedWorldPosition(streamId, self.endPosY, paramsY)
    NetworkUtil.writeCompressedWorldPosition(streamId, self.endPosZ, paramsXZ)

    if self.metadata.poles and # self.metadata.poles > 0 then
        streamWriteBool(streamId, Utils.getNoNil( self.hasStartPole, false ))
        streamWriteBool(streamId, Utils.getNoNil( self.hasEndPole, false ))
    end
end

```