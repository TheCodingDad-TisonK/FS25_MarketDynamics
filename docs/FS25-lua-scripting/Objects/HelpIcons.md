## HelpIcons

**Description**

> Class for help icons

**Functions**

- [delete](#delete)
- [deleteHelpIcon](#deletehelpicon)
- [new](#new)
- [onCreate](#oncreate)
- [showHelpIcons](#showhelpicons)
- [triggerCallback](#triggercallback)

### delete

**Description**

> Deleting help icons

**Definition**

> delete()

**Code**

```lua
function HelpIcons:delete()
    for _, helpIcon in pairs( self.helpIcons) do
        removeTrigger(helpIcon.helpIconTriggerId)
    end
end

```

### deleteHelpIcon

**Description**

> Delete help icon

**Definition**

> deleteHelpIcon(integer i)

**Arguments**

| integer | i | id of help icon |
|---------|---|-----------------|

**Code**

```lua
function HelpIcons:deleteHelpIcon(i)
    if self.helpIcons[i] ~ = nil then
        setVisibility( self.helpIcons[i].helpIconId, false )
        setCollisionFilterMask( self.helpIcons[i].helpIconTriggerId, 0 )
    end
end

```

### new

**Description**

> Creating help icons

**Definition**

> new(integer name)

**Arguments**

| integer | name | node id |
|---------|------|---------|

**Return Values**

| integer | instance | Instance of object |
|---------|----------|--------------------|

**Code**

```lua
function HelpIcons.new(name)
    local self = setmetatable( { } , HelpIcons _mt)

    self.me = name
    local num = getNumOfChildren( self.me)

    self.helpIcons = { }
    for i = 0 , num - 1 do
        local helpIconTriggerId = getChildAt( self.me, i)
        local helpIconId = getChildAt(helpIconTriggerId, 0 )
        local helpIconCustomNumber = Utils.getNoNil(getUserAttribute(helpIconTriggerId, "customNumber" ), 0 )
        addTrigger(helpIconTriggerId, "triggerCallback" , self )
        local helpIcon = { helpIconTriggerId = helpIconTriggerId, helpIconId = helpIconId, helpIconCustomNumber = helpIconCustomNumber }
        table.insert( self.helpIcons, helpIcon)
    end
    self.visible = true

    return self
end

```

### onCreate

**Description**

> Creating help icons

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | node id |
|---------|----|---------|

**Code**

```lua
function HelpIcons:onCreate(id)
    local helpIcons = HelpIcons.new(id)
    g_currentMission:addNonUpdateable(helpIcons)
    g_currentMission.helpIconsBase = helpIcons
end

```

### showHelpIcons

**Description**

> Show help icons

**Definition**

> showHelpIcons(boolean visible, boolean clearIconStates)

**Arguments**

| boolean | visible         | visible           |
|---------|-----------------|-------------------|
| boolean | clearIconStates | clear icon states |

**Code**

```lua
function HelpIcons:showHelpIcons(visible, clearIconStates)
    self.visible = visible

    local oldStates = g_currentMission.missionInfo.foundHelpIcons

    for i, helpIcon in ipairs( self.helpIcons) do
        local isVisible = visible
        if clearIconStates = = nil or not clearIconStates then
            isVisible = isVisible and string.sub(oldStates, i, i) = = "0"
        end

        setVisibility(helpIcon.helpIconId, isVisible)
        if isVisible then
            setCollisionFilterMask(helpIcon.helpIconTriggerId, 3145728 )
        else
                setCollisionFilterMask(helpIcon.helpIconTriggerId, 0 )
            end
        end

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
function HelpIcons:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)

    if not onEnter then
        return
    end

    -- Get the local player.If they do not exist, do nothing.
        local localPlayer = g_localPlayer
        if localPlayer = = nil then
            return
        end

        -- If the player is not in a vehicle but the other entity id isn't their root node, do nothing.
            if not localPlayer:getIsInVehicle() and otherId ~ = localPlayer.rootNode then
                return
            end

            -- Get the player's vehicle.If they are not in a vehicle, or if the vehicle does not match the collided object, do nothing.
                local playerVehicle = localPlayer:getCurrentVehicle()
                if playerVehicle = = nil or playerVehicle ~ = g_currentMission.nodeToObject[otherId] then
                    return
                end

                local missionInfo = g_currentMission.missionInfo
                for i, helpIcon in ipairs( self.helpIcons) do -- order is important for savegame

                    if helpIcon.helpIconTriggerId ~ = triggerId or not getVisibility(helpIcon.helpIconId) then
                        continue
                    end

                    setVisibility(helpIcon.helpIconId, false )
                    setCollisionFilterMask(helpIcon.helpIconTriggerId, 0 )

                    -- update help icon string
                    missionInfo.foundHelpIcons = ""
                    for _, helpIcon in ipairs( self.helpIcons) do
                        if getVisibility(helpIcon.helpIconId) then
                            missionInfo.foundHelpIcons = missionInfo.foundHelpIcons .. "0"
                        else
                                missionInfo.foundHelpIcons = missionInfo.foundHelpIcons .. "1"
                            end
                        end

                        local messageNumber = helpIcon.helpIconCustomNumber
                        if messageNumber = = 0 then
                            messageNumber = i
                        end
                        g_currentMission.inGameMessage:showMessage(g_i18n:getText( "helpIcon_title" .. messageNumber), g_i18n:getText( "helpIcon_text" .. messageNumber), 0 )
                    end
                end

```