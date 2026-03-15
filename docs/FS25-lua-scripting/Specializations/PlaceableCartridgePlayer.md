## PlaceableCartridgePlayer

**Description**

> Specialization for placeables

**Functions**

- [activatePlayer](#activateplayer)
- [cartridgePlayerTriggerCallback](#cartridgeplayertriggercallback)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### activatePlayer

**Description**

**Definition**

> activatePlayer()

**Code**

```lua
function PlaceableCartridgePlayer:activatePlayer()
    local spec = self.spec_cartridgePlayer
    if spec.currentItem ~ = 0 then
        -- Reparent cartrige content to the place
        link(getChildAt(spec.itemsNode, spec.currentItem - 1 ), getChildAt(spec.connectorNode, 0 ))

        -- Hide monitor
        setVisibility(spec.monitorLightNode, false )
        setVisibility(getChildAt(spec.monitorNode, spec.currentItem - 1 ), false )
    end

    -- Find the next cartridge by searching for visible items only.
        -- Store first visible item as well in case we need to wrap around
        local firstVisibleIndex = 0
        local nextVisibleIndex = 0
        for i = 1 , getNumOfChildren(spec.itemsNode) do
            local isVisible = getVisibility(getChildAt(spec.itemsNode, i - 1 ))

            if isVisible then
                if firstVisibleIndex = = 0 then
                    firstVisibleIndex = i
                end

                if nextVisibleIndex = = 0 and i > spec.currentItem then
                    nextVisibleIndex = i
                end
            end
        end

        local currentVisible = spec.currentItem

        if nextVisibleIndex ~ = 0 then
            spec.currentItem = nextVisibleIndex
        elseif firstVisibleIndex ~ = 0 then
                spec.currentItem = firstVisibleIndex
            elseif spec.currentItem = = 0 then
                    -- No change, so no items exist
                    g_currentMission.hud:showInGameMessage(g_i18n:getText( "ui_gameComputer" ), g_i18n:getText( "ui_gameComputerNoCartridges" ), - 1 )
                else
                        spec.currentItem = 0
                    end

                    if spec.currentItem ~ = 0 then
                        -- Reparent cartridge content to connector
                        link(spec.connectorNode, getChildAt(getChildAt(spec.itemsNode, spec.currentItem - 1 ), 0 ))

                        -- Show monitor
                        setVisibility(spec.monitorLightNode, true )
                        setVisibility(getChildAt(spec.monitorNode, spec.currentItem - 1 ), true )
                    end

                    if currentVisible ~ = spec.currentItem and self.isClient then
                        g_soundManager:playSample(spec.samples.play, 1 )
                    end
                end

```

### cartridgePlayerTriggerCallback

**Description**

> Callback when entering/leaving the trigger area

**Definition**

> cartridgePlayerTriggerCallback()

**Arguments**

| any | triggerId |
|-----|-----------|
| any | otherId   |
| any | onEnter   |
| any | onLeave   |
| any | onStay    |

**Code**

```lua
function PlaceableCartridgePlayer:cartridgePlayerTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
            local spec = self.spec_cartridgePlayer
            if onEnter then
                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
            else
                    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                end
            end
        end
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableCartridgePlayer:onDelete()
    local spec = self.spec_cartridgePlayer

    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
    end

    if self.isClient then
        g_soundManager:deleteSamples(spec.samples)
    end
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableCartridgePlayer:onLoad(savegame)
    local spec = self.spec_cartridgePlayer

    local baseKey = "placeable.cartridgePlayer"
    spec.itemsNode = self.xmlFile:getValue(baseKey .. "#itemsNode" , nil , self.components, self.i3dMappings)
    spec.monitorNode = self.xmlFile:getValue(baseKey .. "#monitorNode" , nil , self.components, self.i3dMappings)
    spec.monitorLightNode = self.xmlFile:getValue(baseKey .. "#monitorLightNode" , nil , self.components, self.i3dMappings)
    spec.connectorNode = self.xmlFile:getValue(baseKey .. "#connectorNode" , nil , self.components, self.i3dMappings)
    spec.triggerNode = self.xmlFile:getValue(baseKey .. "#triggerNode" , nil , self.components, self.i3dMappings)

    if spec.triggerNode ~ = nil then
        if not CollisionFlag.getHasMaskFlagSet(spec.triggerNode, CollisionFlag.PLAYER) then
            Logging.error( "Missing collision mask bit '%d'.Please add this bit to computer trigger node '%s'" , CollisionFlag.getBit(CollisionFlag.PLAYER), I3DUtil.getNodePath(spec.triggerNode))
            return nil
        else
                addTrigger(spec.triggerNode, "cartridgePlayerTriggerCallback" , self )
            end

            spec.activatable = PlaceableCartridgePlayerActivatable.new( self )
        end

        spec.currentItem = 0

        if self.isClient then
            spec.samples = { }
            spec.samples.play = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "play" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, nil )
        end

        return self
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
function PlaceableCartridgePlayer.prerequisitesPresent(specializations)
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
function PlaceableCartridgePlayer.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableCartridgePlayer )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableCartridgePlayer )
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
function PlaceableCartridgePlayer.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "cartridgePlayerTriggerCallback" , PlaceableCartridgePlayer.cartridgePlayerTriggerCallback)
    SpecializationUtil.registerFunction(placeableType, "activatePlayer" , PlaceableCartridgePlayer.activatePlayer)
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
function PlaceableCartridgePlayer.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "CartridgePlayer" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".cartridgePlayer#itemsNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".cartridgePlayer#monitorNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".cartridgePlayer#monitorLightNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".cartridgePlayer#connectorNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".cartridgePlayer#triggerNode" , "" )

    SoundManager.registerSampleXMLPaths(schema, basePath .. ".cartridgePlayer.sounds" , "play" )

    schema:setXMLSpecializationType()
end

```