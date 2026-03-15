## Basketball

**Description**

> Class for basketballs

**Parent**

> [PhysicsObject](?version=script&category=63&class=575)

**Functions**

- [createNode](#createnode)
- [delete](#delete)
- [load](#load)
- [new](#new)
- [onCreate](#oncreate)
- [readStream](#readstream)
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
function Basketball:createNode(i3dFilename)
    self.i3dFilename = i3dFilename
    self.customEnvironment, self.baseDirectory = Utils.getModNameAndBaseDirectory(i3dFilename)
    local basketballRoot, sharedLoadRequestId = g_i3DManager:loadSharedI3DFile(i3dFilename, false , false )
    self.sharedLoadRequestId = sharedLoadRequestId

    local basketballId = getChildAt(basketballRoot, 0 )
    link(getRootNode(), basketballId)
    delete(basketballRoot)

    self:setNodeId(basketballId)
end

```

### delete

**Description**

> Deleting basketball object

**Definition**

> delete()

**Code**

```lua
function Basketball:delete()
    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
        self.sharedLoadRequestId = nil
    end
    unregisterObjectClassName( self )
    Basketball:superClass().delete( self )
end

```

### load

**Description**

> Load Basketball

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
function Basketball:load(i3dFilename, x,y,z, rx,ry,rz)
    self.i3dFilename = i3dFilename
    self.customEnvironment, self.baseDirectory = Utils.getModNameAndBaseDirectory(i3dFilename)
    self:createNode(i3dFilename)
    setTranslation( self.nodeId, x, y, z)
    setRotation( self.nodeId, rx, ry, rz)

    return true
end

```

### new

**Description**

> Creating basketball object

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
function Basketball.new(isServer, isClient, customMt)
    local self = PhysicsObject.new(isServer, isClient, customMt or Basketball _mt)

    self.forcedClipDistance = 150
    self.sharedLoadRequestId = nil
    registerObjectClassName( self , "Basketball" )

    return self
end

```

### onCreate

**Description**

> Creating basketball

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function Basketball:onCreate(id)
    local basketball = Basketball.new(g_server ~ = nil , g_client ~ = nil )
    local x, y, z = getWorldTranslation(id)
    local rx, ry, rz = getWorldRotation(id)
    local filename = Utils.getNoNil(getUserAttribute(id, "filename" ), "$data/objects/basketball/basketball.i3d" )
    filename = Utils.getFilename(filename, g_currentMission.loadingMapBaseDirectory)

    if basketball:load(filename, x, y, z, rx, ry, rz) then
        g_currentMission.onCreateObjectSystem:add(basketball)
        basketball:register( true )
    else
            basketball:delete()
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
function Basketball:readStream(streamId, connection)
    if connection:getIsServer() then
        local i3dFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
        if self.nodeId = = 0 then
            self:createNode(i3dFilename)
        end
        Basketball:superClass().readStream( self , streamId, connection)
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
function Basketball:writeStream(streamId, connection)
    if not connection:getIsServer() then
        streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.i3dFilename))
        Basketball:superClass().writeStream( self , streamId, connection)
    end
end

```