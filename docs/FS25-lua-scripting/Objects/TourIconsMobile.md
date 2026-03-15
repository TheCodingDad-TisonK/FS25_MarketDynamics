## TourIconsMobile

**Description**

> Tour icons are part of the (optional) guided tour at the career game's start

**Functions**

- [activateNextIcon](#activatenexticon)
- [delete](#delete)
- [makeIconVisible](#makeiconvisible)
- [new](#new)
- [onCreate](#oncreate)
- [reactToDialog](#reacttodialog)
- [showTourDialog](#showtourdialog)
- [update](#update)

### activateNextIcon

**Description**

> Activate next icon

**Definition**

> activateNextIcon()

**Code**

```lua
function TourIconsMobile:activateNextIcon()
    -- make all previous icons invisible(also handles cases where player managed to skip icons)
    for i = 1 , self.currentTourIconNumber do
        local tourIcon = self.tourIcons[i]
        if getVisibility(tourIcon.tourIconId) then
            setVisibility(tourIcon.tourIconId, false )
            setCollisionFilterMask(tourIcon.tourIconTriggerId, 0 )
        end
    end

    if self.tourIcons[ self.currentTourIconNumber + 1 ] ~ = nil then
        self:makeIconVisible( self.tourIcons[ self.currentTourIconNumber + 1 ].tourIconId)
    else
            -- end of tour!
            if self.mapHotspot ~ = nil then
                g_currentMission:removeMapHotspot( self.mapHotspot)
                self.mapHotspot:delete()
                self.mapHotspot = nil
            end
            -- re-display non-tour help icons
            if g_gameSettings:getValue(GameSettings.SETTING.SHOW_HELP_ICONS) then
                if g_currentMission.helpIconsBase ~ = nil then
                    g_currentMission.helpIconsBase:showHelpIcons( true , true )
                end
            end

            self.visible = false
            g_messageCenter:publish(MessageType.GUIDED_TOUR_FINISHED)

            -- clean up scene objects:
            self:delete()
        end

        local title = g_i18n:getText( "ui_tour" )
        local text = ""

        if self.currentTourIconNumber = = 1 then
            text = g_i18n:getText( "tour_mobile_part01_activate" )

        elseif self.currentTourIconNumber = = 2 then
                text = g_i18n:getText( "tour_mobile_part01_drive" )

            elseif self.currentTourIconNumber = = 3 then
                    text = g_i18n:getText( "tour_mobile_part01_helper" )

                elseif self.currentTourIconNumber = = 4 then
                        text = g_i18n:getText( "tour_mobile_part01_finished" )

                    elseif self.currentTourIconNumber = = 5 then -- # cultivating
                            text = g_i18n:getText( "tour_mobile_part02_activate" )

                        elseif self.currentTourIconNumber = = 6 then
                                text = g_i18n:getText( "tour_mobile_part02_drive" )

                            elseif self.currentTourIconNumber = = 7 then
                                    text = g_i18n:getText( "tour_mobile_part02_finished" )

                                elseif self.currentTourIconNumber = = 8 then -- # sowing
                                        text = g_i18n:getText( "tour_mobile_part03_attach" )

                                    elseif self.currentTourIconNumber = = 9 then
                                            text = g_i18n:getText( "tour_mobile_part03_activateDrive" )

                                        elseif self.currentTourIconNumber = = 10 then
                                                text = g_i18n:getText( "tour_mobile_part03_finished" )

                                            elseif self.currentTourIconNumber = = 11 then -- # trailer / tipping and selling
                                                    text = g_i18n:getText( "tour_mobile_part04_driveToYard" )

                                                elseif self.currentTourIconNumber = = 12 then
                                                        text = g_i18n:getText( "tour_mobile_part04_detach" )

                                                    elseif self.currentTourIconNumber = = 13 then
                                                            text = g_i18n:getText( "tour_mobile_part04_attachTrailer" )

                                                        elseif self.currentTourIconNumber = = 14 then
                                                                text = g_i18n:getText( "tour_mobile_part04_driveToHarvester" )

                                                            elseif self.currentTourIconNumber = = 15 then
                                                                    text = g_i18n:getText( "tour_mobile_part04_driveToSellpoint" )

                                                                elseif self.currentTourIconNumber = = 16 then
                                                                        text = g_i18n:getText( "tour_mobile_part04_Unload" )

                                                                    elseif self.currentTourIconNumber = = 17 then
                                                                            text = g_i18n:getText( "tour_mobile_end" )

                                                                        end

                                                                        if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle().setCruiseControlState ~ = nil then
                                                                            g_localPlayer:getCurrentVehicle():setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF)
                                                                        end

                                                                        if g_gui:getIsGuiVisible() then
                                                                            self.queuedMessage = { title = title, text = text }
                                                                        else
                                                                                g_currentMission.hud.ingameMap:toggleSize( IngameMapMobile.STATE_HIDDEN, true )
                                                                                InfoDialog.show(text)
                                                                            end

                                                                            self.currentTourIconNumber = self.currentTourIconNumber + 1

                                                                            self.permanentMessageDelay = 250
                                                                        end

```

### delete

**Description**

> Deleting tour icons

**Definition**

> delete()

**Code**

```lua
function TourIconsMobile:delete()
    g_currentMission:removeUpdateable( self )

    for _, tourIcon in pairs( self.tourIcons) do
        removeTrigger(tourIcon.tourIconTriggerId)
    end

    if self.me ~ = 0 then
        delete( self.me)
        self.me = 0
    end
end

```

### makeIconVisible

**Description**

> Make tour icon visable

**Definition**

> makeIconVisible(integer tourIconId)

**Arguments**

| integer | tourIconId | id of tour icon |
|---------|------------|-----------------|

**Code**

```lua
function TourIconsMobile:makeIconVisible(tourIconId)
    -- make next icon visible
    setVisibility(tourIconId, true )
    local x, y, z = getWorldTranslation(tourIconId)

    if self.mapHotspot = = nil then
        self.mapHotspot = TourHotspot.new()
        g_currentMission:addMapHotspot( self.mapHotspot)
    end

    self.mapHotspot:setWorldPosition(x, z)

    -- Find 'hidden' icon used internally only
    local h = getTerrainHeightAtWorldPos(g_terrainNode, x,y,z)
    if y > h then
        g_currentMission:setMapTargetHotspot( self.mapHotspot)
        g_currentMission.disableMapTargetHotspotHiding = true
    else
            g_currentMission:setMapTargetHotspot( nil )
            g_currentMission.disableMapTargetHotspotHiding = false
        end
    end

```

### new

**Description**

> Creating tour icons

**Definition**

> new(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Return Values**

| integer | instance | Instance of object |
|---------|----------|--------------------|

**Code**

```lua
function TourIconsMobile.new(id)
    local self = setmetatable( { } , TourIconsMobile _mt)

    self.me = id
    local num = getNumOfChildren( self.me)

    self.tourIcons = { }
    for i = 0 , num - 1 do
        local tourIconTriggerId = getChildAt( self.me, i)
        local tourIconId = getChildAt(tourIconTriggerId, 0 )
        addTrigger(tourIconTriggerId, "triggerCallback" , self )
        setVisibility(tourIconId, false )
        local tourIcon = { tourIconTriggerId = tourIconTriggerId, tourIconId = tourIconId }
        table.insert( self.tourIcons, tourIcon)
    end

    self.visible = false
    self.mapHotspot = nil
    self.currentTourIconNumber = 1
    self.alpha = 0.25
    self.alphaDirection = 1
    self.startTourDialog = false
    self.startTourDialogDelay = 0
    self.permanentMessageDelay = 0
    self.isPaused = false
    self.pauseTime = 0
    self.soldStuffAtGrainElevator = false

    local plowLevelMaxValue = g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.PLOW_LEVEL)
    local limeLevelMaxValue = g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.LIME_LEVEL)
    self.plowLevelMaxValue = plowLevelMaxValue
    self.limeLevelMaxValue = limeLevelMaxValue

    _, self.permanentTextSize = getNormalizedScreenValues( 0 , 28 )

    return self
end

```

### onCreate

**Description**

> Creating tour icons

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function TourIconsMobile:onCreate(id)
    local tourIcons = TourIconsMobile.new(id)
    g_currentMission:addUpdateable(tourIcons)
    g_currentMission.tourIconsBase = tourIcons
end

```

### reactToDialog

**Description**

> React to tour dialog

**Definition**

> reactToDialog(boolean yes)

**Arguments**

| boolean | yes | answer to dialog |
|---------|-----|------------------|

**Code**

```lua
function TourIconsMobile:reactToDialog(yes)
    if yes then
        self.visible = true
        self:activateNextIcon()
        -- hide all non-tour question marks
        if g_currentMission.helpIconsBase ~ = nil then
            g_currentMission.helpIconsBase:showHelpIcons( false , true )
        end

        -- g_messageCenter:publish(MessageType.GUIDED_TOUR_STARTED)
    else
            self.visible = false
            InfoDialog.show(g_i18n:getText( "tour_mobile_abort" ))

            self:delete()
        end
    end

```

### showTourDialog

**Description**

> Show tour yes/no dialog

**Definition**

> showTourDialog()

**Code**

```lua
function TourIconsMobile:showTourDialog()
    YesNoDialog.show( self.reactToDialog, self , g_i18n:getText( "tour_text_start" ), "" )
end

```

### update

**Description**

> Update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function TourIconsMobile:update(dt)
    if not g_currentMission.missionInfo.isValid and g_server ~ = nil and self.initDone = = nil and g_currentMission:getIsTourSupported() then
        self.initDone = true

        g_currentMission:fadeScreen( - 1 , 3000 , function ()
            self.canStart = true
        end , self )

        -- prepare fields
        Logging.devWarning( "TourIconsMobile:update not yet implemented with new polygon system" )
        -- local field = g_fieldManager:getFieldById(2)
        -- local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(FruitType.WHEAT)
        -- for i = 1,#field.maxField1StatusPartitions do
            -- g_fieldManager:setFieldPartitionStatus(field, field.maxField1StatusPartitions, i, fruitDesc.index, FieldManager.FIELDSTATE_GROWING, fruitDesc.maxHarvestingGrowthState, 3, true, self.plowLevelMaxValue, 0, self.limeLevelMaxValue)
            -- end

            -- local field = g_fieldManager:getFieldById(1)
            -- local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(FruitType.CANOLA)
            -- for i = 1,#field.maxField1StatusPartitions do
                -- g_fieldManager:setFieldPartitionStatus(field, field.maxField1StatusPartitions, i, fruitDesc.index, FieldManager.FIELDSTATE_HARVESTED, 0, 0, false, self.plowLevelMaxValue, 0, self.limeLevelMaxValue)
                -- end

                -- local field = g_fieldManager:getFieldById(3)
                -- for i = 1,#field.maxField1StatusPartitions do
                    -- g_fieldManager:setFieldPartitionStatus(field, field.maxField1StatusPartitions, i, nil, FieldManager.FIELDSTATE_CULTIVATED, 0, 0, false, self.plowLevelMaxValue, 0, self.limeLevelMaxValue)
                    -- end
                end

                if self.startTourDialog and self.canStart then
                    self.startTourDialogDelay = self.startTourDialogDelay - dt
                    if self.startTourDialogDelay < 0 then
                        self.startTourDialog = false
                        self:showTourDialog()
                    end
                end

                -- Delay messages always when UI is visible
                if g_gui:getIsGuiVisible() then
                    return
                elseif self.queuedMessage ~ = nil then
                        -- Show queued message and try again next frame
                        g_currentMission.hud.ingameMap:toggleSize( IngameMapMobile.STATE_HIDDEN, true )
                        InfoDialog.show( self.queuedMessage)
                        self.queuedMessage = nil
                        return
                    end

                    if self.isPaused then
                        if self.pauseTime > 0 then
                            self.pauseTime = self.pauseTime - dt
                        else
                                self.pauseTime = 0
                                self.isPaused = false
                                self:activateNextIcon()
                            end
                        end

                        if self.visible and not self.isPaused then
                            --# harvesting

                            -- wait for player to activate the cutter
                                if self.currentTourIconNumber = = 2 then
                                    if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourCombine" ] then
                                        if g_currentMission.tourVehicles[ "tourCombine" ]:getActionControllerDirection() < 0 then
                                            self.pauseTime = 2000
                                            self.isPaused = true
                                        end
                                    end

                                    -- wait for player to activate the helper
                                    elseif self.currentTourIconNumber = = 4 then
                                            if g_currentMission.tourVehicles[ "tourCombine" ]:getIsTurnedOn() and g_currentMission.tourVehicles[ "tourCombine" ]:getIsAIActive() then
                                                self.pauseTime = 1000
                                                self.isPaused = true
                                            end

                                            --# cultivating

                                            -- wait for player to enter tractor1 and attach cultivator
                                            elseif self.currentTourIconNumber = = 5 then
                                                    if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                        self.pauseTime = 1000
                                                        self.isPaused = true
                                                    end

                                                elseif self.currentTourIconNumber = = 6 then
                                                        if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                            if g_currentMission.tourVehicles[ "tourTractor1" ]:getActionControllerDirection() < 0 then
                                                                self.pauseTime = 1000
                                                                self.isPaused = true
                                                            end
                                                        end

                                                        --# sowing

                                                        -- wait for player to enter tractor2 and attach sowingMachine
                                                        elseif self.currentTourIconNumber = = 8 then
                                                                if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor2" ] then
                                                                    self.pauseTime = 1000
                                                                    self.isPaused = true
                                                                end

                                                            elseif self.currentTourIconNumber = = 9 then
                                                                    if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor2" ] then
                                                                        if g_currentMission.tourVehicles[ "tourSowingMachine" ].rootVehicle = = g_currentMission.tourVehicles[ "tourTractor2" ] then
                                                                            self.pauseTime = 1000
                                                                            self.isPaused = true
                                                                        end
                                                                    end

                                                                    --# overloading / tipping

                                                                    -- wait for player to enter tractor2
                                                                    elseif self.currentTourIconNumber = = 11 then
                                                                            if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                                                self.pauseTime = 1000
                                                                                self.isPaused = true
                                                                            end

                                                                        elseif self.currentTourIconNumber = = 13 then
                                                                                if g_currentMission.tourVehicles[ "tourCultivator" ].rootVehicle = = g_currentMission.tourVehicles[ "tourCultivator" ] then
                                                                                    self.pauseTime = 1000
                                                                                    self.isPaused = true
                                                                                end

                                                                            elseif self.currentTourIconNumber = = 14 then
                                                                                    if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                                                        if g_currentMission.tourVehicles[ "tourTrailer" ].rootVehicle = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                                                            self.pauseTime = 1000
                                                                                            self.isPaused = true
                                                                                        end
                                                                                    end

                                                                                elseif self.currentTourIconNumber = = 15 then
                                                                                        if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                                                            if g_currentMission.tourVehicles[ "tourTrailer" ]:getFillUnitFillLevel( 1 ) > 800 then
                                                                                                self.pauseTime = 1000
                                                                                                self.isPaused = true
                                                                                            end
                                                                                        end

                                                                                    elseif self.currentTourIconNumber = = 17 then
                                                                                            if g_localPlayer:getCurrentVehicle() ~ = nil and g_localPlayer:getCurrentVehicle() = = g_currentMission.tourVehicles[ "tourTractor1" ] then
                                                                                                if g_currentMission.tourVehicles[ "tourTrailer" ]:getFillUnitFillLevel( 1 ) < = 2 then
                                                                                                    self.pauseTime = 1000
                                                                                                    self.isPaused = true
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end

```