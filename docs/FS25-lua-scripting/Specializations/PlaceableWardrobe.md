## PlaceableWardrobe

**Description**

> Specialization for placeables

**Functions**

- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [wardrobeTriggerCallback](#wardrobetriggercallback)

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableWardrobe:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_wardrobe
    local isFreeForAll = xmlFile:getValue(key .. "#isFreeForAll" )
    if isFreeForAll ~ = nil then
        spec.isFreeForAll = isFreeForAll
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableWardrobe:onDelete()
    local spec = self.spec_wardrobe

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)

    if spec.wardrobeTrigger ~ = nil then
        removeTrigger(spec.wardrobeTrigger)
    end
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
function PlaceableWardrobe:onLoad(savegame)
    local spec = self.spec_wardrobe

    spec.activatable = WardrobeActivatable.new( self )

    local wardrobeTriggerKey = "placeable.wardrobe#triggerNode"
    spec.wardrobeTrigger = self.xmlFile:getValue(wardrobeTriggerKey, nil , self.components, self.i3dMappings)
    if spec.wardrobeTrigger ~ = nil then
        if not CollisionFlag.getHasMaskFlagSet(spec.wardrobeTrigger, CollisionFlag.PLAYER) then
            Logging.warning( "%s wardrobe trigger '%s' does not have 'TRIGGER_PLAYER' bit(%s) set" , self.configFileName, wardrobeTriggerKey, CollisionFlag.getBit(CollisionFlag.PLAYER))
        end
        addTrigger(spec.wardrobeTrigger, "wardrobeTriggerCallback" , self )
    end

    spec.isFreeForAll = self.xmlFile:getValue( "placeable.wardrobe#isFreeForAll" , false )
end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function PlaceableWardrobe:onReadStream(streamId, connection)
    local spec = self.spec_wardrobe
    spec.isFreeForAll = streamReadBool(streamId)
end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function PlaceableWardrobe:onWriteStream(streamId, connection)
    local spec = self.spec_wardrobe
    streamWriteBool(streamId, spec.isFreeForAll)
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
function PlaceableWardrobe.prerequisitesPresent(specializations)
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
function PlaceableWardrobe.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWardrobe )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWardrobe )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableWardrobe )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableWardrobe )
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
function PlaceableWardrobe.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "wardrobeTriggerCallback" , PlaceableWardrobe.wardrobeTriggerCallback)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableWardrobe.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Wardrobe" )
    schema:register(XMLValueType.BOOL, basePath .. "#isFreeForAll" , "Allow any farm not just the owner to access the wardrobe" )
    schema:setXMLSpecializationType()
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
function PlaceableWardrobe.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Wardrobe" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wardrobe#triggerNode" , "Wardrobe trigger node for player" )
        schema:register(XMLValueType.BOOL, basePath .. ".wardrobe#isFreeForAll" , "Allow any farm not just the owner to access the wardrobe" , "false if owned by a specific farm, true otherwise" )
            schema:setXMLSpecializationType()
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
function PlaceableWardrobe:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#isFreeForAll" , self.spec_wardrobe.isFreeForAll)
end

```

### wardrobeTriggerCallback

**Description**

**Definition**

> wardrobeTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function PlaceableWardrobe:wardrobeTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherActorId = = g_localPlayer.rootNode then
            local spec = self.spec_wardrobe
            if spec.isFreeForAll or self:getOwnerFarmId() = = g_localPlayer.farmId then
                if onEnter then
                    g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
                else
                        g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                    end
                end
            end
        end
    end

```