## PlaceableTriggerMarkers

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onMarkerFileLoaded](#onmarkerfileloaded)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableTriggerMarkers:onDelete()
    local spec = self.spec_triggerMarkers
    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
    end

    if spec.triggerMarkers ~ = nil then
        for _, marker in ipairs(spec.triggerMarkers) do
            g_currentMission:removeTriggerMarker(marker.node)
        end
    end

    g_messageCenter:unsubscribe(MessageType.PLAYER_FARM_CHANGED, self )
    g_messageCenter:unsubscribe(MessageType.PLAYER_CREATED, self )
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableTriggerMarkers:onFinalizePlacement()
    local spec = self.spec_triggerMarkers

    if g_terrainNode ~ = nil then
        for _, marker in ipairs(spec.triggerMarkers) do
            if marker.adjustToGround then
                local x, _, z = getWorldTranslation(marker.node)
                local y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z) + marker.groundOffset
                setWorldTranslation(marker.node, x, y, z)
            end
        end
    end

    self:setShowMarkers(g_currentMission.accessHandler:canPlayerAccess( self ))

    -- Get notified when the player visibility state changes
    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.onPlayerFarmChanged, self )
    g_messageCenter:subscribe(MessageType.PLAYER_CREATED, self.onPlayerFarmChanged, self )
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function PlaceableTriggerMarkers:onLoad(savegame)
    local spec = self.spec_triggerMarkers
    local xmlFile = self.xmlFile

    spec.sharedLoadRequestIds = { }

    spec.triggerMarkers = { }

    -- <markerIcons>
    -- <markerIcon filename = "$data/shared/assets/marker/markerIconUnload.i3d" id = "UNLOAD" />

    for _, key in xmlFile:iterator( "placeable.triggerMarkers.triggerMarker" ) do
        local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if node = = nil then
            Logging.xmlWarning(xmlFile, "Missing trigger marker node for '%s'" , key)
                continue
            end

            local adjustToGround = xmlFile:getValue(key .. "#adjustToGround" , false )
            local groundOffset = xmlFile:getValue(key .. "#groundOffset" )

            if groundOffset ~ = nil and not adjustToGround then
                Logging.xmlWarning(xmlFile, "'groundOffset = %.2f' given but 'adjustToGround' is false for '%s'" , groundOffset, key)
                end
                groundOffset = groundOffset or 0.03 -- 3cm as default to prevent clipping of flat markers with terrain

                --#debug if not getEffectiveVisibility(getParent(node)) then
                    --#debug Logging.xmlWarning(xmlFile, "Parent of triggerMarker link node '%s' (%s) is not visible", getName(node), key .. "#node")
                    --#debug end

                    -- check if there are any child nodes, which are not a shape(e.g.transformGroups used as targets) or have a collision
                        --#debug if adjustToGround then
                            --#debug local tgsOrColNodes = {}
                            --#debug I3DUtil.iterateRecursively(node, function (nodeToCheck)
                                --#debug if getRigidBodyType(nodeToCheck) ~ = RigidBodyType.NONE then -- TODO:also warn for non-shapes, e.g.spawnNodes? not getHasClassId(nodeToCheck, ClassIds.SHAPE)
                                    --#debug table.insert(tgsOrColNodes, getName(nodeToCheck))
                                    --#debug end
                                    --#debug end)
                                    --#debug if #tgsOrColNodes > 0 then
                                        --#debug Logging.xmlWarning(xmlFile, "triggerMarker link node '%s' (%s) has child nodes(%s) which are not shapes without a collision.", getName(node), key .. "#node", table.concat(tgsOrColNodes, ", "))
                                        --#debug end
                                        --#debug end

                                        local i3dFilename = self.xmlFile:getValue(key .. "#filename" , nil , self.baseDirectory)

                                        local showAllPlayers = self.xmlFile:getValue(key .. "#showAllPlayers" , false )
                                        local showOnlyIfOwned = self.xmlFile:getValue(key .. "#showOnlyIfOwned" , false )

                                        local marker = {
                                        node = node,
                                        i3dFilename = i3dFilename,
                                        adjustToGround = adjustToGround,
                                        groundOffset = groundOffset,
                                        showAllPlayers = showAllPlayers,
                                        showOnlyIfOwned = showOnlyIfOwned
                                        }

                                        if i3dFilename ~ = nil then

                                            local loadingTask = self:createLoadingTask()

                                            local args = {
                                            marker = marker,
                                            loadingTask = loadingTask
                                            }

                                            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(i3dFilename, false , false , self.onMarkerFileLoaded, self , args)
                                            table.insert(spec.sharedLoadRequestIds, sharedLoadRequestId)
                                        end

                                        table.insert(spec.triggerMarkers, marker)
                                    end
                                end

```

### onMarkerFileLoaded

**Description**

**Definition**

> onMarkerFileLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PlaceableTriggerMarkers:onMarkerFileLoaded(i3dNode, failedReason, args)
    local linkNode = args.marker.node
    local loadingTask = args.loadingTask

    if i3dNode ~ = 0 then
        link(linkNode, i3dNode)

        -- update marker node to be new linked i3d to avoid moving the linkNode(e.g.unloadTriggers) when adjusting to terrain
        args.marker.node = i3dNode
    end

    self:finishLoadingTask(loadingTask)
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function PlaceableTriggerMarkers.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableTriggerMarkers.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableTriggerMarkers )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableTriggerMarkers )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableTriggerMarkers )
    SpecializationUtil.registerEventListener(placeableType, "onOwnerChanged" , PlaceableTriggerMarkers )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableTriggerMarkers.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "onPlayerFarmChanged" , PlaceableTriggerMarkers.onPlayerFarmChanged)
    SpecializationUtil.registerFunction(placeableType, "onMarkerFileLoaded" , PlaceableTriggerMarkers.onMarkerFileLoaded)
    SpecializationUtil.registerFunction(placeableType, "getTriggerMarkerPosition" , PlaceableTriggerMarkers.getTriggerMarkerPosition)
    SpecializationUtil.registerFunction(placeableType, "setShowMarkers" , PlaceableTriggerMarkers.setShowMarkers)
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
function PlaceableTriggerMarkers.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "TriggerMarkers" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".triggerMarkers.triggerMarker(?)#node" , "Trigger marker node" )
    schema:register(XMLValueType.FILENAME, basePath .. ".triggerMarkers.triggerMarker(?)#filename" , "Trigger marker i3d filename" )
    schema:register(XMLValueType.BOOL, basePath .. ".triggerMarkers.triggerMarker(?)#adjustToGround" , "Trigger marker adjusted to ground" )
    schema:register(XMLValueType.FLOAT, basePath .. ".triggerMarkers.triggerMarker(?)#groundOffset" , "Height of the trigger marker above the ground if adjustToGround is enabled" , 0.03 )
        schema:register(XMLValueType.BOOL, basePath .. ".triggerMarkers.triggerMarker(?)#showAllPlayers" , "Show marker for all players even if they do not have access to the placeable" , false )
            schema:register(XMLValueType.BOOL, basePath .. ".triggerMarkers.triggerMarker(?)#showOnlyIfOwned" , "Show marker only if owned" , false )
                schema:setXMLSpecializationType()
            end

```