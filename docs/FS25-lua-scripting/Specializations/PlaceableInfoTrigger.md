## PlaceableInfoTrigger

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onFinalizePlacement](#onfinalizeplacement)
- [onInfoTriggerCallback](#oninfotriggercallback)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [updateInfo](#updateinfo)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableInfoTrigger:onDelete()
    local spec = self.spec_infoTrigger

    if spec.infoTriggerNode ~ = nil then
        removeTrigger(spec.infoTriggerNode)
        spec.infoTriggerNode = nil
    end

    spec.showInfo = false
    g_currentMission:removeDrawable( self )

    if spec.hudBox ~ = nil and g_currentMission.hud ~ = nil then
        g_currentMission.hud.infoDisplay:destroyBox(spec.hudBox)
    end
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function PlaceableInfoTrigger:onDraw()
    local spec = self.spec_infoTrigger
    if spec.showInfo then
        if spec.showAllPlayers or self:getOwnerFarmId() = = g_currentMission:getFarmId() then
            -- Gather info
            self:updateInfo(spec.info)

            if #spec.info > 0 then
                local box = spec.hudBox
                if box ~ = nil then
                    box:clear()
                    box:setTitle( self:getName())

                    for i = 1 , #spec.info do
                        local element = spec.info[i]

                        box:addLine(element.title, element.text, element.accentuate)

                        spec.info[i] = nil
                    end

                    box:showNextFrame()
                end
            end
        end
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableInfoTrigger:onFinalizePlacement()
    local spec = self.spec_infoTrigger
    if spec.infoTriggerNode ~ = nil then
        addTrigger(spec.infoTriggerNode, "onInfoTriggerCallback" , self )
    end
end

```

### onInfoTriggerCallback

**Description**

**Definition**

> onInfoTriggerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function PlaceableInfoTrigger:onInfoTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    local spec = self.spec_infoTrigger
    if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
        if onEnter then
            spec.showInfo = true
            g_currentMission:addDrawable( self )
            SpecializationUtil.raiseEvent( self , "onInfoTriggerEnter" , otherId)

        else
                spec.showInfo = false
                g_currentMission:removeDrawable( self )
                SpecializationUtil.raiseEvent( self , "onInfoTriggerLeave" , otherId)
            end
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
function PlaceableInfoTrigger:onLoad(savegame)
    local spec = self.spec_infoTrigger

    spec.info = { }
    spec.showInfo = false
    spec.showAllPlayers = self.xmlFile:getValue( "placeable.infoTrigger#showAllPlayers" , false )
    spec.infoTriggerNode = self.xmlFile:getValue( "placeable.infoTrigger#triggerNode" , nil , self.components, self.i3dMappings)
    if spec.infoTriggerNode ~ = nil then
        if not CollisionFlag.getHasMaskFlagSet(spec.infoTriggerNode, CollisionFlag.PLAYER) then
            Logging.xmlWarning( self.xmlFile, "Info trigger collision mask is missing bit 'TRIGGER_PLAYER' (%d)" , CollisionFlag.getBit(CollisionFlag.PLAYER))
        end
    end

    if Platform.playerInfo.showPlaceableInfo then
        spec.hudBox = g_currentMission.hud.infoDisplay:createBox( InfoDisplayKeyValueBox )
    end
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
function PlaceableInfoTrigger.prerequisitesPresent(specializations)
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
function PlaceableInfoTrigger.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableInfoTrigger )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableInfoTrigger )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableInfoTrigger )
    SpecializationUtil.registerEventListener(placeableType, "onDraw" , PlaceableInfoTrigger )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableInfoTrigger.registerEvents(placeableType)
    SpecializationUtil.registerEvent(placeableType, "onInfoTriggerEnter" )
    SpecializationUtil.registerEvent(placeableType, "onInfoTriggerLeave" )
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
function PlaceableInfoTrigger.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateInfo" , PlaceableInfoTrigger.updateInfo)
    SpecializationUtil.registerFunction(placeableType, "onInfoTriggerCallback" , PlaceableInfoTrigger.onInfoTriggerCallback)
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
function PlaceableInfoTrigger.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "InfoTrigger" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".infoTrigger#triggerNode" , "Info trigger" , nil , false )
    schema:register(XMLValueType.BOOL, basePath .. ".infoTrigger#showAllPlayers" , "Show info to all players" , false , false )
    schema:setXMLSpecializationType()
end

```

### updateInfo

**Description**

**Definition**

> updateInfo()

**Arguments**

| any | info |
|-----|------|

**Code**

```lua
function PlaceableInfoTrigger:updateInfo(info)
end

```