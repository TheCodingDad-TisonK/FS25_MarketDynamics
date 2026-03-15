## DogBall

**Parent**

> [PhysicsObject](?version=script&category=63&class=577)

**Functions**

- [createNode](#createnode)
- [delete](#delete)
- [load](#load)
- [new](#new)
- [readStream](#readstream)
- [reset](#reset)
- [writeStream](#writestream)

### createNode

**Description**

> Load node from i3d file

**Definition**

> createNode(string i3dFilename)

**Arguments**

| string | i3dFilename | i3d file name |
|--------|-------------|---------------|

**Code**

```lua
function DogBall:createNode(i3dFilename)
    self.i3dFilename = i3dFilename
    self.customEnvironment, self.baseDirectory = Utils.getModNameAndBaseDirectory(i3dFilename)
    local dogBallRoot, sharedLoadRequestId = g_i3DManager:loadSharedI3DFile(i3dFilename, false , false )
    self.sharedLoadRequestId = sharedLoadRequestId

    local dogBallId = getChildAt(dogBallRoot, 0 )
    link(getRootNode(), dogBallId)
    delete(dogBallRoot)

    self:setNodeId(dogBallId)
end

```

### delete

**Description**

> Deleting DogBall object

**Definition**

> delete()

**Code**

```lua
function DogBall:delete()
    self.isDeleted = true -- mark as deleted so we can track it in Doghouse
    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
    end
    unregisterObjectClassName( self )

    DogBall:superClass().delete( self )
end

```

### load

**Description**

> Load DogBall

**Definition**

> load(string i3dFilename, float x, float y, float z, float rx, float ry, float rz)

**Arguments**

| string | i3dFilename | i3d file name     |
|--------|-------------|-------------------|
| float  | x           | x world position  |
| float  | y           | z world position  |
| float  | z           | z world position  |
| float  | rx          | rx world rotation |
| float  | ry          | ry world rotation |
| float  | rz          | rz world rotation |

**Code**

```lua
function DogBall:load(i3dFilename, x,y,z, rx,ry,rz)
    self:createNode(i3dFilename)
    setTranslation( self.nodeId, x, y, z)
    setRotation( self.nodeId, rx, ry, rz)

    if self.isServer then
        self.spawnPos = { x,y,z }
        self.throwPos = { x,y,z }
        self.startRot = { rx,ry,rz }
    end
    return true
end

```

### new

**Description**

> Creating DogBall object

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
function DogBall.new(isServer, isClient, customMt)
    local self = PhysicsObject.new(isServer, isClient, customMt or DogBall _mt)

    self.forcedClipDistance = 150
    registerObjectClassName( self , "DogBall" )
    self.sharedLoadRequestId = nil

    return self
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
function DogBall:readStream(streamId, connection)
    if connection:getIsServer() then
        local i3dFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))

        local isNew = self.i3dFilename = = nil
        if isNew then
            self:load(i3dFilename, 0 , 0 , 0 , 0 , 0 , 0 )
            -- The pose will be set by PhysicsObject, and we don't care about spawnPos/startRot on clients
        end
    end

    DogBall:superClass().readStream( self , streamId, connection)
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function DogBall:reset()
    if self.isServer then
        removeFromPhysics( self.nodeId)
        setTranslation( self.nodeId, unpack( self.spawnPos))
        setRotation( self.nodeId, unpack( self.startRot))
        addToPhysics( self.nodeId)
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
function DogBall:writeStream(streamId, connection)
    if not connection:getIsServer() then
        streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.i3dFilename))
    end

    DogBall:superClass().writeStream( self , streamId, connection)
end

```