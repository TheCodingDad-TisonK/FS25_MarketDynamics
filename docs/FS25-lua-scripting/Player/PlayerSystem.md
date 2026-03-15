## PlayerSystem

**Description**

> The class responsible for managing all players of a mission.

**Functions**

- [addPlayer](#addplayer)
- [debugDrawAllPlayers](#debugdrawallplayers)
- [draw](#draw)
- [getHasPlayerWithUniqueId](#gethasplayerwithuniqueid)
- [getIsPlayerAdded](#getisplayeradded)
- [getPlayerByConnection](#getplayerbyconnection)
- [getPlayerByIndex](#getplayerbyindex)
- [getPlayerByRootNode](#getplayerbyrootnode)
- [getPlayerByUniqueId](#getplayerbyuniqueid)
- [getPlayerByUserId](#getplayerbyuserid)
- [getPlayerCount](#getplayercount)
- [getPlayerDataByUniqueId](#getplayerdatabyuniqueid)
- [saveHugeUnloadedPlayers](#savehugeunloadedplayers)
- [saveToXMLFile](#savetoxmlfile)
- [saveUnloadedPlayers](#saveunloadedplayers)

### addPlayer

**Description**

> Adds the given player to this system.

**Definition**

> addPlayer(Player player)

**Arguments**

| Player | player | The player to add. |
|--------|--------|--------------------|

**Return Values**

| Player | success | False if the player has already been added; otherwise true. |
|--------|---------|-------------------------------------------------------------|

**Code**

```lua
function PlayerSystem:addPlayer(player)

    --#debug Assert.isNotNil(player, "Player is nil!")
    --#debug Assert.isClass(player, Player, "Player is not of class Player!")

    -- If the player has already been added to this system, return false.
    local existingPlayer = self:getPlayerByUserId(player.userId)
    if existingPlayer ~ = nil then

        -- If the existing player does not match the given player, it means there are two players with the same id in the world, so log an error.
        if existingPlayer ~ = player then
            Logging.error( "Player with user id %d exists in the system with table address of %s, but a player with the same user id tried to be added with a table address of %s!" ,
            player.userId, tostring(existingPlayer), tostring(player))
        end
        return false
    end

    --#debug Assert.isNil(table.find(self.players, player), "Player already exists in array!")
    --#debug Assert.hasNoKey(self.playersByUserId, player.userId, "Player already exists by user id!")

    -- Handle logging.
    --#debug player:debugLog(Player.DEBUG_DISPLAY_FLAG.INITIALISATION, "Player added to system")

    -- Add the player to the collections.
    table.insert( self.players, player)
    self.playersByUserId[player.userId] = player
    self.playersByRootNode[player.rootNode] = player
    self.playersByConnection[player.connection] = player

    -- If the player has a unique user id, add them to the collection immediately.
    if not string.isNilOrWhitespace(player.uniqueUserId) then
        self.playersByUniqueId[player.uniqueUserId] = player

        -- Remove the player's data from the unloaded table.
        if g_server ~ = nil and self.unloadedPlayerDataByUniqueId[player.uniqueUserId] ~ = nil then
            self.unloadedPlayerDataByUniqueId[player.uniqueUserId] = nil
            self.unloadedPlayerDataCount = self.unloadedPlayerDataCount - 1
        end
    end

    -- If the player is the local player, set them as such.
    if player.isOwner then
        self:setLocalPlayer(player)
    end

    -- Return true, as the player was succesfully added.
    return true
end

```

### debugDrawAllPlayers

**Description**

> Displays the debug information for all added players.

**Definition**

> debugDrawAllPlayers(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Code**

```lua
function PlayerSystem:debugDrawAllPlayers(x, y, textSize)

    for i, player in ipairs( self.players) do
        player:debugDraw(x, y, textSize)
        x = x + 0.2
    end
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function PlayerSystem:draw()
    for _, player in pairs( self.players) do
        if not player.isDeleted then
            player:drawUIInfo()
        end
    end

    if PlayerSystem.DEBUG_ANIMATIONS then
        local startPosX = 0.07
        local lineOffsetY = 0.4
        local posX = startPosX
        local posY = 0.9
        local textSize = getCorrectTextSize( 0.012 )
        local numPlayer = 1

        for _, player in pairs( self.players) do
            local name = player:getNickname()
            setTextBold( true )
            renderText(posX, posY + 0.02 , textSize, name)
            setTextBold( false )
            player:drawDebug(posX, posY, textSize)
            posX = posX + 0.1
            numPlayer = numPlayer + 1

            if numPlayer > 9 then
                posX = startPosX
                posY = posY - lineOffsetY
                numPlayer = 1
            end
        end
    end

    if PlayerSystem.DEBUG_SOUNDS then
        local startPosX = 0.07
        local lineOffsetY = 0.4
        local posX = startPosX
        local posY = 0.9
        local textSize = getCorrectTextSize( 0.012 )
        local numPlayer = 1

        for _, player in pairs( self.players) do
            local name = player:getNickname()
            setTextBold( true )
            renderText(posX, posY + 0.02 , textSize, name)
            setTextBold( false )
            player.graphicsComponent.sounds:drawDebug(posX, posY, textSize)
            posX = posX + 0.1
            numPlayer = numPlayer + 1

            if numPlayer > 9 then
                posX = startPosX
                posY = posY - lineOffsetY
                numPlayer = 1
            end
        end
    end
end

```

### getHasPlayerWithUniqueId

**Description**

> Finds if a player or unloaded data exists for the given unique id.

**Definition**

> getHasPlayerWithUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id of the player or data to check for. |
|--------|----------|---------------------------------------------------|

**Return Values**

| string | hasPlayer | True if the given unique id has a loaded or unloaded player associated with it. |
|--------|-----------|---------------------------------------------------------------------------------|

**Code**

```lua
function PlayerSystem:getHasPlayerWithUniqueId(uniqueId)
    if g_server ~ = nil then
        return uniqueId ~ = nil and( self.playersByUniqueId[uniqueId] ~ = nil or self.unloadedPlayerDataByUniqueId[uniqueId] ~ = nil )
    else
            return uniqueId ~ = nil and self.playersByUniqueId[uniqueId] ~ = nil
        end
    end

```

### getIsPlayerAdded

**Description**

> Finds if the given player is added to this system as an active player (not as unloaded data).

**Definition**

> getIsPlayerAdded(Player player)

**Arguments**

| Player | player | The player to check. |
|--------|--------|----------------------|

**Return Values**

| Player | isAdded | True if the player is in this system; otherwise false. |
|--------|---------|--------------------------------------------------------|

**Code**

```lua
function PlayerSystem:getIsPlayerAdded(player)
    return player ~ = nil and player.uniqueUserId ~ = nil and self:getPlayerByUniqueId(player.uniqueUserId) ~ = nil
end

```

### getPlayerByConnection

**Description**

> Gets the player from the given connection.

**Definition**

> getPlayerByConnection(Connection connection)

**Arguments**

| Connection | connection | The connection of the player to get. |
|------------|------------|--------------------------------------|

**Return Values**

| Connection | player | The found player. |
|------------|--------|-------------------|

**Code**

```lua
function PlayerSystem:getPlayerByConnection(connection)
    return self.playersByConnection[connection]
end

```

### getPlayerByIndex

**Description**

> Gets the player from the given index.

**Definition**

> getPlayerByIndex(integer index)

**Arguments**

| integer | index | The index of the player to get. |
|---------|-------|---------------------------------|

**Return Values**

| integer | player | The found player. |
|---------|--------|-------------------|

**Code**

```lua
function PlayerSystem:getPlayerByIndex(index)
    return self.players[index]
end

```

### getPlayerByRootNode

**Description**

> Gets the player from the given root node.

**Definition**

> getPlayerByRootNode(entityId rootNode)

**Arguments**

| entityId | rootNode | The root node of the player to get. |
|----------|----------|-------------------------------------|

**Return Values**

| entityId | player | The found player. |
|----------|--------|-------------------|

**Code**

```lua
function PlayerSystem:getPlayerByRootNode(rootNode)
    return self.playersByRootNode[rootNode]
end

```

### getPlayerByUniqueId

**Description**

> Gets the player from the given unique id.

**Definition**

> getPlayerByUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id of the player to get. |
|--------|----------|-------------------------------------|

**Return Values**

| string | player | The found player. |
|--------|--------|-------------------|

**Code**

```lua
function PlayerSystem:getPlayerByUniqueId(uniqueId)
    return self.playersByUniqueId[uniqueId]
end

```

### getPlayerByUserId

**Description**

> Gets the player from the given user id.

**Definition**

> getPlayerByUserId(string userId)

**Arguments**

| string | userId | The user id of the player to get. |
|--------|--------|-----------------------------------|

**Return Values**

| string | player | The found player. |
|--------|--------|-------------------|

**Code**

```lua
function PlayerSystem:getPlayerByUserId(userId)
    return self.playersByUserId[userId]
end

```

### getPlayerCount

**Description**

> Gets the count of players currently playing (excluding players not in the world, who have unloaded data).

**Definition**

> getPlayerCount()

**Return Values**

| string | playerCount | The number of active players. |
|--------|-------------|-------------------------------|

**Code**

```lua
function PlayerSystem:getPlayerCount()
    return # self.players
end

```

### getPlayerDataByUniqueId

**Description**

> Gets the player data from the given unique id.

**Definition**

> getPlayerDataByUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id of the player data to get. |
|--------|----------|------------------------------------------|

**Return Values**

| string | playerData | The found player data. |
|--------|------------|------------------------|

**Code**

```lua
function PlayerSystem:getPlayerDataByUniqueId(uniqueId)
    if g_server ~ = nil then
        return self.unloadedPlayerDataByUniqueId[uniqueId]
    else
            return nil
        end
    end

```

### saveHugeUnloadedPlayers

**Description**

> Saves PlayerSystem.MAX\_NUM\_SAVED\_PLAYERS unloaded players to the given file at the given key. Trims any players
> over the PlayerSystem.MAX\_NUM\_SAVED\_PLAYERS count, sorted by time last played.

**Definition**

> saveHugeUnloadedPlayers(XMLFile xmlFile, string baseKey)

**Arguments**

| XMLFile | xmlFile | The file to save to.          |
|---------|---------|-------------------------------|
| string  | baseKey | The base node key to save to. |

**Code**

```lua
function PlayerSystem:saveHugeUnloadedPlayers(xmlFile, baseKey)

    -- All current players were already saved, so all indices must be relative to this.
    local savedPlayerCount = self:getPlayerCount()

    -- Create a list of the unloaded players and sort them by time last connected.
    local sortedPlayerDataByLastPlayTime = table.create( self.unloadedPlayerDataCount)
    for _, playerData in pairs( self.unloadedPlayerDataByUniqueId) do
        table.insert(sortedPlayerDataByLastPlayTime, playerData)
    end
    table.sort(sortedPlayerDataByLastPlayTime, function (a, b) return a.lastConnectedDateTime > b.lastConnectedDateTime end )

    -- Get the current date and time.
    local currentYear, currentMonth, currentDay, currentHour, currentMinute = string.match(getDate( "%Y/%m/%d %H:%M" ), "(%d+)/(%d+)/(%d+) (%d+):(%d+)" )
    currentYear, currentMonth, currentDay, currentHour, currentMinute = tonumber(currentYear), tonumber(currentMonth), tonumber(currentDay), tonumber(currentHour), tonumber(currentMinute)

    -- Calculate the maximum number of seconds for a player have logged in during for them to be safe from deletion.
        local maxSecondsSinceLastConnection = PlayerSystem.MAX_NUM_DAYS_OFFLINE * 24 * 60 * 60

        -- Save the players.
        for i, playerData in ipairs(sortedPlayerDataByLastPlayTime) do

            -- If the limit of saved players has been hit, check the date last played.
            if i + savedPlayerCount > PlayerSystem.MAX_NUM_SAVED_PLAYERS then

                -- Get the date and time that the player last logged in.
                local year, month, day, hour, minute = string.match(playerData.lastConnectedDateTime, "(%d+)/(%d+)/(%d+) (%d+):(%d+)" )
                year, month, day, hour, minute = tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(minute)

                -- If the player has not been on for a while, stop saving all players from here.
                    -- The table is sorted, so it is certain that any consecutive player will not have logged on recently enough.
                    if year ~ = nil and math.abs(getDateDiffSeconds(year, month, day, hour, minute, 0 , currentYear, currentMonth, currentDay, currentHour, currentMinute, 0 )) > maxSecondsSinceLastConnection then
                        Logging.xmlInfo(xmlFile, "Excluded %d players from player save:Limit reached and affected players did not join the server for more than %d days" , (savedPlayerCount + self.unloadedPlayerDataCount) - (i - 1 ), PlayerSystem.MAX_NUM_DAYS_OFFLINE)
                            break
                        end
                    end

                    -- Save the player data.
                    Player.saveDataToXMLFile(xmlFile, playerData, string.format( "%s.player(%d)" , baseKey, (i + savedPlayerCount) - 1 ))
                end
            end

```

### saveToXMLFile

**Description**

> Saves all players to an xml file with the given filepath.

**Definition**

> saveToXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | The filename of the file to save to. |
|--------|-------------|--------------------------------------|

**Return Values**

| string | success | True if the file was saved; otherwise false. |
|--------|---------|----------------------------------------------|

**Code**

```lua
function PlayerSystem:saveToXMLFile(xmlFilename)

    --#debug Assert.isNotNil(g_server, "Players can only be saved on the server!")

    -- Create the file.
    local rootKey = "players"
    local xmlFile = XMLFile.create( "Players" , xmlFilename, rootKey, PlayerSystem.savegameXMLSchema)
    if xmlFile = = nil then
        return false
    end

    -- Always save the players that are currently playing.
    local savedPlayerCount = 0
    for i, player in ipairs( self.players) do
        player:saveToXMLFile(xmlFile, string.format( "%s.player(%d)" , rootKey, savedPlayerCount))
        savedPlayerCount = savedPlayerCount + 1
    end

    -- Save the unloaded players, based on if there should be some pruned.
        if savedPlayerCount + self.unloadedPlayerDataCount > = PlayerSystem.MAX_NUM_SAVED_PLAYERS then
            self:saveHugeUnloadedPlayers(xmlFile, rootKey)
        else
                self:saveUnloadedPlayers(xmlFile, rootKey)
            end

            -- Finish saving and return true, as the saving was successful.
            xmlFile:save()
            xmlFile:delete()
            return true
        end

```

### saveUnloadedPlayers

**Description**

> Saves all unloaded players to the given file at the given key. Does not trim any players.

**Definition**

> saveUnloadedPlayers(XMLFile xmlFile, string baseKey)

**Arguments**

| XMLFile | xmlFile | The file to save to.          |
|---------|---------|-------------------------------|
| string  | baseKey | The base node key to save to. |

**Code**

```lua
function PlayerSystem:saveUnloadedPlayers(xmlFile, baseKey)

    --#debug Assert.isNotNil(g_server, "Player system should only save from the server!")

    -- All current players were already saved, so all indices must be relative to this.
    local savedPlayerCount = self:getPlayerCount()

    -- Save all unloaded players.
    local currentPlayerDataCount = savedPlayerCount
    for _, playerData in pairs( self.unloadedPlayerDataByUniqueId) do
        Player.saveDataToXMLFile(xmlFile, playerData, string.format( "%s.player(%d)" , baseKey, currentPlayerDataCount))
        currentPlayerDataCount = currentPlayerDataCount + 1
    end
end

```