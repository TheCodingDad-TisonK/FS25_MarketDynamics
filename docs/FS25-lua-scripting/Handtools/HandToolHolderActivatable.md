## HandToolHolderActivatable

**Functions**

- [getDistance](#getdistance)
- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

### getDistance

**Description**

**Definition**

> getDistance()

**Arguments**

| any | positionX |
|-----|-----------|
| any | positionY |
| any | positionZ |

**Code**

```lua
function HandToolHolderActivatable:getDistance(positionX, positionY, positionZ)
    if self.needTargeting then
        if self:getIsActivatable() then
            return 0
        end
    end

    local x, y, z = getWorldTranslation( self.handToolHolder.holderNode)
    local distance = MathUtil.vector3Length(positionX - x, positionY - y, positionZ - z)

    return distance
end

```

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function HandToolHolderActivatable:getIsActivatable()

    local localPlayer = g_localPlayer

    -- If there's no player or targeter, do nothing.
        if localPlayer = = nil then
            return false
        end

        if self.needTargeting then
            if localPlayer.targeter = = nil then
                return false
            end

            local targetedHandToolHolder = HandToolUtil.getTargetedHandToolHolder(localPlayer.targeter)
            if targetedHandToolHolder ~ = self.handToolHolder then
                return false
            end
        end

        -- Get the hand tool in the holder, and the hand tool held by the player.
        local holderHandTool = self.handToolHolder:getHandTool()
        local playerHandTool = localPlayer:getHeldHandTool()

        -- If the player is not holding a hand tool and the holder has a hand tool, return based on if the player can carry the holder's hand tool.
            if playerHandTool = = nil and holderHandTool ~ = nil then
                local canPickup = localPlayer:getCanPickupHandTool(holderHandTool)
                if canPickup then
                    self.activateText = string.format( self.takeText, holderHandTool.typeDesc)
                end
                return canPickup

                -- Otherwise; if the player is holding a hand tool and the holder is empty, return based on if the holder can carry the player's hand tool.
                elseif playerHandTool ~ = nil and holderHandTool = = nil then
                        local canPickup = self.handToolHolder:getCanPickupHandTool(playerHandTool)
                        if canPickup then
                            self.activateText = string.format( self.storeText, playerHandTool.typeDesc)
                        end
                        return canPickup
                    end

                    -- Since all other checks failed, return false.
                    return false
                end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | handToolHolder |
|-----|----------------|
| any | takeText       |
| any | storeText      |
| any | needTargeting  |

**Code**

```lua
function HandToolHolderActivatable.new(handToolHolder, takeText, storeText, needTargeting)
    local self = setmetatable( { } , HandToolHolderActivatable _mt)

    self.handToolHolder = handToolHolder

    self.needTargeting = needTargeting
    self.takeText = takeText
    self.storeText = storeText
    self.activateText = self.takeText

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function HandToolHolderActivatable:run()
    -- Get the hand tool in the holder, and the hand tool held by the player.
    local holderHandTool = self.handToolHolder:getHandTool()
    local playerHandTool = g_localPlayer:getHeldHandTool()

    if playerHandTool = = nil and holderHandTool ~ = nil then
        -- If the player is not holding a hand tool and the holder has a hand tool, try take the stored hand tool.
        holderHandTool:setHolder(g_localPlayer)
        g_localPlayer:setCurrentHandTool(holderHandTool)

    elseif playerHandTool ~ = nil and holderHandTool = = nil then
            -- Otherwise; if the player is holding a hand tool and the holder is empty, try store the held hand tool.
                playerHandTool:setHolder( self.handToolHolder)
            end
        end

```