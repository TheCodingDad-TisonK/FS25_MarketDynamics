## FenceGate

**Parent**

> [FenceSegment](?version=script&category=90&class=869)

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
function FenceGate:readStream(streamId, connection, lastSegment)
    FenceGate:superClass().readStream( self , streamId, connection, lastSegment)

    self.isReversed = streamReadBool(streamId)

    if connection:getIsServer() then
        if self.animatedObjects ~ = nil then
            for _, animatedObject in ipairs( self.animatedObjects) do
                local animatedObjectId = NetworkUtil.readNodeObjectId(streamId)
                animatedObject:readStream(streamId, connection)
                g_client:finishRegisterObject(animatedObject, animatedObjectId)
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

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function FenceGate.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".gate#node" , "" )
    schema:register(XMLValueType.BOOL, basePath .. ".gate#alignY" , "" )
    schema:register(XMLValueType.BOOL, basePath .. ".gate#hasStartPole" , "" )
    schema:register(XMLValueType.BOOL, basePath .. ".gate#hasEndPole" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".gate#length" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".gate#depth" , "" )
    schema:register(XMLValueType.FLOAT, basePath .. ".gate#depthOffset" , "" )
    AnimatedObject.registerXMLPaths(schema, basePath .. ".gate" )
    schema:register(XMLValueType.FLOAT, basePath .. ".gate.animatedObject.aiBlockingRegion#stopDistance" , "" )
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile(XMLFile xmlFile, any key)

**Arguments**

| XMLFile | xmlFile |
|---------|---------|
| any     | key     |

**Code**

```lua
function FenceGate:saveToXMLFile(xmlFile, key)
    if not FenceGate:superClass().saveToXMLFile( self , xmlFile, key) then
        return false
    end

    if self.isReversed then
        xmlFile:setBool(key .. "#reversed" , self.isReversed)
    end

    if self.animatedObjects ~ = nil then
        local index = 0
        for _, animatedObject in ipairs( self.animatedObjects) do
            local animatedObjectKey = string.format( "%s.animatedObject(%d)" , key, index)
            xmlFile:setString(animatedObjectKey .. "#id" , animatedObject.saveId)
            animatedObject:saveToXMLFile(xmlFile, animatedObjectKey) -- TODO:usedModNames
            index = index + 1
        end
    end

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
function FenceGate:writeStream(streamId, connection, lastSegment)
    FenceGate:superClass().writeStream( self , streamId, connection, lastSegment)

    streamWriteBool(streamId, self.isReversed)

    if not connection:getIsServer() then
        if self.animatedObjects ~ = nil then
            for _, animatedObject in ipairs( self.animatedObjects) do
                NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(animatedObject))
                animatedObject:writeStream(streamId, connection)
                g_server:registerObjectInStream(connection, animatedObject)
            end
        end
    end
end

```