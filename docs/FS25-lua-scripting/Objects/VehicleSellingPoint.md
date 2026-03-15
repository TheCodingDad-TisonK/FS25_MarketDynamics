## VehicleSellingPoint

**Description**

> Class for vehicle selling point

**Functions**

- [delete](#delete)
- [determineCurrentVehicles](#determinecurrentvehicles)
- [getOwnerFarmId](#getownerfarmid)
- [load](#load)
- [new](#new)
- [openMenu](#openmenu)
- [playerFarmChanged](#playerfarmchanged)
- [registerXMLPaths](#registerxmlpaths)
- [sellAreaTriggerCallback](#sellareatriggercallback)
- [setOwnerFarmId](#setownerfarmid)
- [triggerCallback](#triggercallback)
- [updateIconVisibility](#updateiconvisibility)

### delete

**Description**

> Deleting vehicle selling point

**Definition**

> delete()

**Code**

```lua
function VehicleSellingPoint:delete()
    g_messageCenter:unsubscribeAll( self )

    if self.playerTrigger ~ = nil then
        removeTrigger( self.playerTrigger)
        self.playerTrigger = nil
    end
    if self.sellTriggerNode ~ = nil then
        removeTrigger( self.sellTriggerNode)
        self.sellTriggerNode = nil
    end

    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)

    self.sellIcon = nil
end

```

### determineCurrentVehicles

**Description**

> Determine current vehicle

**Definition**

> determineCurrentVehicles()

**Code**

```lua
function VehicleSellingPoint:determineCurrentVehicles()
    local vehicles = { }

    local playerFarmId = g_currentMission:getFarmId()
    if playerFarmId ~ = FarmManager.SPECTATOR_FARM_ID then

        -- Find first vehicle, then get its rood and all children
        for shapeId, inRange in pairs( self.vehicleShapesInRange) do
            if inRange ~ = nil and entityExists(shapeId) then
                local vehicle = g_currentMission.nodeToObject[shapeId]
                if vehicle ~ = nil and vehicle:isa( Vehicle ) then
                    local subVehicles = vehicle.rootVehicle:getChildVehicles()
                    for _, subVehicle in ipairs(subVehicles) do
                        if subVehicle:getShowInVehiclesOverview() then
                            -- only show owned items
                            if subVehicle:getOwnerFarmId() = = playerFarmId then
                                -- uniqueness check builtin
                                table.addElement(vehicles, subVehicle)
                            end
                        end
                    end
                end
            else
                    self.vehicleShapesInRange[shapeId] = nil
                end
            end

            -- Consistent order independent on which piece of the vehicle entered the trigger first
            table.sort(vehicles, function (a, b)
                return a.rootNode < b.rootNode
            end )
        end

        return vehicles
    end

```

### getOwnerFarmId

**Description**

**Definition**

> getOwnerFarmId()

**Code**

```lua
function VehicleSellingPoint:getOwnerFarmId()
    return self.ownerFarmId
end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | components  |
|-----|-------------|
| any | xmlFile     |
| any | key         |
| any | i3dMappings |

**Code**

```lua
function VehicleSellingPoint:load(components, xmlFile, key, i3dMappings)
    self.playerTrigger = xmlFile:getValue(key .. "#playerTriggerNode" , nil , components, i3dMappings)
    self.sellIcon = xmlFile:getValue(key .. "#iconNode" , nil , components, i3dMappings)
    self.sellTriggerNode = xmlFile:getValue(key .. "#sellTriggerNode" , nil , components, i3dMappings)
    self.ownWorkshop = xmlFile:getValue(key .. "#ownWorkshop" , false )
    self.mobileWorkshop = xmlFile:getValue(key .. "#mobileWorkshop" , false )

    if not CollisionFlag.getHasMaskFlagSet( self.playerTrigger, CollisionFlag.PLAYER) then
        Logging.xmlWarning(xmlFile, "Missing collision mask bit '%d'.Please add this bit to vehicle selling player trigger node '%s'" , CollisionFlag.getBit(CollisionFlag.PLAYER), I3DUtil.getNodePath( self.playerTrigger))
    end
    addTrigger( self.playerTrigger, "triggerCallback" , self )

    if not CollisionFlag.getHasMaskFlagSet( self.sellTriggerNode, CollisionFlag.VEHICLE) then
        Logging.xmlWarning(xmlFile, "Missing collision mask bit '%d'.Please add this bit to vehicle sell area trigger node '%s'" , CollisionFlag.getBit(CollisionFlag.VEHICLE), I3DUtil.getNodePath( self.sellTriggerNode))
    end
    addTrigger( self.sellTriggerNode, "sellAreaTriggerCallback" , self )

    self.activatable = VehicleSellingPointActivatable.new( self , self.ownWorkshop)

    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.playerFarmChanged, self )
    g_messageCenter:subscribe(MessageType.PLAYER_CREATED, self.playerFarmChanged, self )

    self:updateIconVisibility()
end

```

### new

**Description**

> Creating vehicle selling point

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
function VehicleSellingPoint.new()
    local self = setmetatable( { } , VehicleSellingPoint _mt)

    self.vehicleShapesInRange = { }

    self.activateText = ""

    self.isEnabled = true

    return self
end

```

### openMenu

**Description**

> On activate object

**Definition**

> openMenu()

**Code**

```lua
function VehicleSellingPoint:openMenu()
    local vehicles = self:determineCurrentVehicles()

    g_workshopScreen:setSellingPoint( self , not self.ownWorkshop, self.ownWorkshop, self.mobileWorkshop)
    g_workshopScreen:setVehicles(vehicles)
    g_gui:showGui( "WorkshopScreen" )
end

```

### playerFarmChanged

**Description**

**Definition**

> playerFarmChanged()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function VehicleSellingPoint:playerFarmChanged(player)
    if player = = g_localPlayer then
        self:updateIconVisibility()
    end
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
function VehicleSellingPoint.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#playerTriggerNode" , "Player trigger node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#iconNode" , "Icon node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#sellTriggerNode" , "Sell trigger node" )
    schema:register(XMLValueType.BOOL, basePath .. "#ownWorkshop" , "Owned by player" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#mobileWorkshop" , "Workshop is on vehicle" , false )
end

```

### sellAreaTriggerCallback

**Description**

> Sell area trigger callback

**Definition**

> sellAreaTriggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay, )

**Arguments**

| integer | triggerId    | id of trigger |
|---------|--------------|---------------|
| integer | otherId      | id of actor   |
| boolean | onEnter      | on enter      |
| boolean | onLeave      | on leave      |
| boolean | onStay       | on stay       |
| any     | otherShapeId |               |

**Code**

```lua
function VehicleSellingPoint:sellAreaTriggerCallback(triggerId, otherId, onEnter, onLeave, onStay, otherShapeId)
    if otherShapeId ~ = nil and(onEnter or onLeave) then
        if onEnter then
            self.vehicleShapesInRange[otherShapeId] = true
        elseif onLeave then
                self.vehicleShapesInRange[otherShapeId] = nil
            end

            g_workshopScreen:updateVehicles( self , self:determineCurrentVehicles())
        end
    end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | ownerFarmId |
|-----|-------------|

**Code**

```lua
function VehicleSellingPoint:setOwnerFarmId(ownerFarmId)
    self.ownerFarmId = ownerFarmId
    self:updateIconVisibility()
end

```

### triggerCallback

**Description**

> Trigger callback

**Definition**

> triggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger |
|---------|-----------|---------------|
| integer | otherId   | id of actor   |
| boolean | onEnter   | on enter      |
| boolean | onLeave   | on leave      |
| boolean | onStay    | on stay       |

**Code**

```lua
function VehicleSellingPoint:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo) then
        if onEnter or onLeave then
            if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
                if onEnter then
                    g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
                else
                        g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                        self:determineCurrentVehicles()
                    end
                end
            end
        end
    end

```

### updateIconVisibility

**Description**

> Turn the icon on or off depending on the current game and the players farm

**Definition**

> updateIconVisibility()

**Code**

```lua
function VehicleSellingPoint:updateIconVisibility()
    if self.sellIcon ~ = nil then
        local isAvailable = self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo)
        local farmId = g_currentMission:getFarmId()
        local visibleForFarm = farmId ~ = FarmManager.SPECTATOR_FARM_ID and( self:getOwnerFarmId() = = AccessHandler.EVERYONE or farmId = = self:getOwnerFarmId())

        setVisibility( self.sellIcon, isAvailable and visibleForFarm)
    end
end

```