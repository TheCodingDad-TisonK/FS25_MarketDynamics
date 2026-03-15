## ChainsawCutEvent

**Description**

> HandToolSetHolderEvent

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [writeStream](#writestream)

### emptyNew

**Description**

> Create instance of Event class

**Definition**

> emptyNew()

**Return Values**

| any | self | instance of class event |
|-----|------|-------------------------|

**Code**

```lua
function ChainsawCutEvent.emptyNew()
    local self = Event.new( ChainsawCutEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(integer splitShapeId, float x, float y, float z, float nx, float ny, float nz, float yx, float yy, float yz, float
> cutSizeY, float cutSizeZ, integer farmId)

**Arguments**

| integer | splitShapeId | id of split shape |
|---------|--------------|-------------------|
| float   | x            | x                 |
| float   | y            | y                 |
| float   | z            | z                 |
| float   | nx           | nx                |
| float   | ny           | ny                |
| float   | nz           | nz                |
| float   | yx           | yx                |
| float   | yy           | yy                |
| float   | yz           | yz                |
| float   | cutSizeY     | y cut size        |
| float   | cutSizeZ     | z cut size        |
| integer | farmId       |                   |

**Return Values**

| integer | self |
|---------|------|

**Code**

```lua
function ChainsawCutEvent.new(splitShapeId, x,y,z, nx,ny,nz, yx,yy,yz, cutSizeY, cutSizeZ, farmId)
    local self = ChainsawCutEvent.emptyNew()

    self.splitShapeId = splitShapeId
    self.x = x
    self.y = y
    self.z = z
    self.nx = nx
    self.ny = ny
    self.nz = nz
    self.yx = yx
    self.yy = yy
    self.yz = yz
    self.cutSizeY = cutSizeY
    self.cutSizeZ = cutSizeZ
    self.farmId = farmId

    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function ChainsawCutEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        local splitShapeId = readSplitShapeIdFromStream(streamId)
        local x = streamReadFloat32(streamId)
        local y = streamReadFloat32(streamId)
        local z = streamReadFloat32(streamId)
        local nx = streamReadFloat32(streamId)
        local ny = streamReadFloat32(streamId)
        local nz = streamReadFloat32(streamId)
        local yx = streamReadFloat32(streamId)
        local yy = streamReadFloat32(streamId)
        local yz = streamReadFloat32(streamId)
        local cutSizeY = streamReadFloat32(streamId)
        local cutSizeZ = streamReadFloat32(streamId)
        local farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

        if splitShapeId ~ = 0 then
            ChainsawUtil.cutSplitShape(splitShapeId, x,y,z, nx,ny,nz, yx,yy,yz, cutSizeY, cutSizeZ, farmId)
        end
    end
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection | connection |
|------------|------------|------------|

**Code**

```lua
function ChainsawCutEvent:run(connection)
    print( "Error:ChainsawCutEvent is not allowed to be executed on a local client" )
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function ChainsawCutEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        writeSplitShapeIdToStream(streamId, self.splitShapeId)
        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.y)
        streamWriteFloat32(streamId, self.z)
        streamWriteFloat32(streamId, self.nx)
        streamWriteFloat32(streamId, self.ny)
        streamWriteFloat32(streamId, self.nz)
        streamWriteFloat32(streamId, self.yx)
        streamWriteFloat32(streamId, self.yy)
        streamWriteFloat32(streamId, self.yz)
        streamWriteFloat32(streamId, self.cutSizeY)
        streamWriteFloat32(streamId, self.cutSizeZ)
        streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    end
end

```