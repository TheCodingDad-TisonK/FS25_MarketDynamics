## AnimatedMapObject

**Description**

> Class for animated map objects

**Parent**

> [AnimatedObject](?version=script&category=63&class=573)

**Functions**

- [load](#load)
- [new](#new)
- [onCreate](#oncreate)

### load

**Description**

> Load animated object attributes from object

**Definition**

> load(integer nodeId)

**Arguments**

| integer | nodeId | id of object to load from |
|---------|--------|---------------------------|

**Return Values**

| integer | success | success |
|---------|---------|---------|

**Code**

```lua
function AnimatedMapObject:load(nodeId)
    local xmlFilename = getUserAttribute(nodeId, "xmlFilename" )
    if xmlFilename = = nil then
        Logging.error( "Missing 'xmlFilename' user attribute for AnimatedMapObject node '%s'!" , getName(nodeId))
            return false
        end

        local baseDir = g_currentMission.loadingMapBaseDirectory
        if baseDir = = "" then
            baseDir = Utils.getNoNil( self.baseDirectory, baseDir)
        end
        xmlFilename = Utils.getFilename(xmlFilename, baseDir)

        local saveId = getUserAttribute(nodeId, "saveId" ) or getUserAttribute(nodeId, "index" ) -- TODO:remove support for old "index"
            if saveId = = nil then
                Logging.error( "Missing 'saveId' user attribute for AnimatedMapObject node '%s'!" , getName(nodeId))
                    return false
                end

                local xmlFile = XMLFile.load( "AnimatedObject" , xmlFilename, AnimatedMapObject.xmlSchema)
                if xmlFile = = nil then
                    return false
                end

                -- Find the saveId in the XML
                local key
                xmlFile:iterate( "animatedObjects.animatedObject" , function (_, objectKey)
                    local configSaveId = xmlFile:getString(objectKey .. "#saveId" ) or xmlFile:getString(objectKey .. "#index" ) -- TODO:remove support for old "index"
                        if configSaveId = = saveId then
                            key = objectKey
                            return true
                        end
                        return
                    end )

                    if key = = nil then
                        Logging.error( "saveId '%s' not found in AnimatedObject xml '%s'!" , saveId, xmlFilename)
                        return false
                    end

                    local result = AnimatedMapObject:superClass().load( self , nodeId, xmlFile, key, xmlFilename)

                    xmlFile:delete()

                    return result
                end

```

### new

**Description**

> Creating new instance of animated object class

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | is server        |
|---------|----------|------------------|
| boolean | isClient | is client        |
| table?  | customMt | custom metatable |

**Return Values**

| table? | self | new instance of object |
|--------|------|------------------------|

**Code**

```lua
function AnimatedMapObject.new(isServer, isClient, customMt)
    return AnimatedObject.new(isServer, isClient, customMt or AnimatedMapObject _mt)
end

```

### onCreate

**Description**

> Creating animated object

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function AnimatedMapObject:onCreate(id)
    local object = AnimatedMapObject.new(g_server ~ = nil , g_client ~ = nil )
    if object:load(id) then
        g_currentMission.onCreateObjectSystem:add(object, true )
        object:register( true )
    else
            object:delete()
        end
    end

```