## Fence

**Functions**

- [readStream](#readstream)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [writeStream](#writestream)

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
function Fence:readStream(streamId, connection)
    local numSegments = streamReadUInt16(streamId)
    local lastSegment
    for i = 1 , numSegments do
        local segmentTemplateIndex = streamReadUInt8(streamId)
        local segment = self:createNewSegment( self.segmentTemplatesSorted[segmentTemplateIndex])

        segment:readStream(streamId, connection, lastSegment)
        segment:updateMeshes( true , false )
        segment:finalize( true )
        lastSegment = segment
    end
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function Fence.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. ".segment(?)#id" , "Segment id from config xml" )

    FenceSegment.registerSavegameXMLPaths(schema, basePath .. ".segment(?)" )
    FenceGate.registerSavegameXMLPaths(schema, basePath .. ".segment(?)" )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function Fence.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Fence" )
    schema:register(XMLValueType.STRING, basePath .. ".fence.segment(?)#id" , "" , nil , true )
    schema:register(XMLValueType.STRING, basePath .. ".fence.segment(?)#class" , "" , nil , true )
    FenceSegment.registerXMLPaths(schema, basePath .. ".fence.segment(?)" )
    FenceGate.registerXMLPaths(schema, basePath .. ".fence.segment(?)" )
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
function Fence:saveToXMLFile(xmlFile, key, usedModNames)
    local segmentXMLIndex = 0
    for _, segment in ipairs( self.segments) do
        if segment.needsSaving = = nil or segment.needsSaving = = true then
            local segmentKey = string.format( "%s.segment(%d)" , key, segmentXMLIndex)
            if segment:saveToXMLFile(xmlFile, segmentKey) then
                xmlFile:setString(segmentKey .. "#id" , segment:getId())
                segmentXMLIndex = segmentXMLIndex + 1
            end
        end
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
function Fence:writeStream(streamId, connection)
    streamWriteUInt16(streamId, # self.segments)

    local lastSegment
    for _, segment in ipairs( self.segments) do
        local segmentTemplateIndex = self:getSegmentTemplateIndexById(segment:getId())
        streamWriteUInt8(streamId, segmentTemplateIndex)

        segment:writeStream(streamId, connection, lastSegment)
        lastSegment = segment
    end
end

```