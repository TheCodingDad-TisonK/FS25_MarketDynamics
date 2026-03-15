## SoundMixer

**Description**

> This class handles the mixing of sounds depending on the game state

**Functions**

- [addVolumeChangedListener](#addvolumechangedlistener)
- [delete](#delete)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onGameStateChanged](#ongamestatechanged)
- [setAudioGroupVolumeFactor](#setaudiogroupvolumefactor)
- [setMasterVolume](#setmastervolume)
- [update](#update)

### addVolumeChangedListener

**Description**

**Definition**

> addVolumeChangedListener()

**Arguments**

| any | audioGroupIndex |
|-----|-----------------|
| any | func            |
| any | target          |

**Code**

```lua
function SoundMixer:addVolumeChangedListener(audioGroupIndex, func, target)
    if self.volumeChangedListeners[audioGroupIndex] = = nil then
        self.volumeChangedListeners[audioGroupIndex] = { }
    end

    -- TODO:this will not prevent duplicates, use target as key instead?
    table.addElement( self.volumeChangedListeners[audioGroupIndex], { func = func, target = target } )
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function SoundMixer:delete()
    g_messageCenter:unsubscribeAll( self )

    removeConsoleCommand( "gsSoundMixerDebug" )
end

```

### loadFromXML

**Description**

> Load sound mixer settings from given xml filepath

**Definition**

> loadFromXML(string xmlFilepath)

**Arguments**

| string | xmlFilepath | filepath of the sound mixer settings xml file |
|--------|-------------|-----------------------------------------------|

**Code**

```lua
function SoundMixer:loadFromXML(xmlFilepath)
    -- ensure all audio groups are initialized in case new ones were added in script
    for _, groupIndex in pairs(AudioGroup.groups) do
        self.volumeFactors[groupIndex] = self.volumeFactors[groupIndex] or 1
        self.volumeChangedListeners[groupIndex] = self.volumeChangedListeners[groupIndex] or { }
    end

    local xmlFile = loadXMLFile( "soundMixerXML" , xmlFilepath) -- TODO:update to new xml wrapper + schema

    if xmlFile ~ = nil and xmlFile ~ = 0 then

        local i = 0
        while true do
            local gameStateKey = string.format( "soundMixer.gameState(%d)" , i)
            if not hasXMLProperty(xmlFile, gameStateKey) then
                break
            end

            local gameStateName = getXMLString(xmlFile, gameStateKey .. "#name" )
            local gameStateIndex = g_gameStateManager:getGameStateIndexByName(gameStateName)
            if gameStateIndex ~ = nil then
                local gameState = { }

                local j = 0
                while true do
                    local audioGroupKey = string.format( "%s.audioGroup(%d)" , gameStateKey, j)
                    if not hasXMLProperty(xmlFile, audioGroupKey) then
                        break
                    end

                    local name = getXMLString(xmlFile, audioGroupKey .. "#name" )
                    local volume = getXMLFloat(xmlFile, audioGroupKey .. "#volume" ) or 1.0
                    local fadeInDuration = (getXMLFloat(xmlFile, audioGroupKey .. "#fadeOutDuration" ) or 0.5 ) * 1000
                    local fadeOutDuration = (getXMLFloat(xmlFile, audioGroupKey .. "#fadeOutDuration" ) or 0.5 ) * 1000
                    local audioGroupIndex = AudioGroup.getAudioGroupIndexByName(name)

                    if audioGroupIndex ~ = nil then
                        gameState[audioGroupIndex] = { volume = volume, fadeInDuration = fadeInDuration, fadeOutDuration = fadeOutDuration }
                    else
                            Logging.xmlWarning(xmlFile, "Audio-Group '%s' in game state '%s' (%s) is not defined!" , name, gameStateName, gameStateKey)
                        end

                        j = j + 1
                    end

                    self.gameStates[gameStateIndex] = gameState
                else
                        Logging.xmlWarning(xmlFile, "Game-State '%s' is not defined for state '%s'!" , gameStateName, gameStateKey)
                        end

                        i = i + 1
                    end

                    delete(xmlFile)
                end

                -- initialize self.volumes for all AudioGroups
                    local currentGameState = g_gameStateManager:getGameState()
                    local gameStateAudioGroups = self.gameStates[currentGameState] or self.gameStates[GameState.LOADING] -- current game state might not be included in mixer config

                    for _, groupIndex in ipairs(AudioGroup.groups) do
                        local data = gameStateAudioGroups and gameStateAudioGroups[groupIndex]
                        local volume = 0 -- (data and data.volume) or 1
                        self.volumes[groupIndex] = volume
                        setAudioGroupVolume(groupIndex, volume)
                    end
                end

```

### new

**Description**

> Creating sound node

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|
| any | group    | audio group        |

**Code**

```lua
function SoundMixer.new(customMt)
    local self = setmetatable( { } , customMt or SoundMixer _mt)

    g_messageCenter:subscribe(MessageType.GAME_STATE_CHANGED, self.onGameStateChanged, self )

    self.masterVolume = 1

    self.gameStates = { } -- GameState -> AudioGroup -> float volume [0 .. 1]
    self.volumes = { } -- AudioGroup -> float volume [0 .. 1]
    self.volumeFactors = { } -- AudioGroup -> float volume [0 .. 1]
    self.volumeChangedListeners = { } -- AudioGroup -> array {func, target}

    for _, groupIndex in pairs(AudioGroup.groups) do
        self.volumeFactors[groupIndex] = 1
        self.volumeChangedListeners[groupIndex] = { }
    end

    addConsoleCommand( "gsSoundMixerDebug" , "Toggle sound mixer debug mode" , "consoleCommandToggleDebug" , self )

    return self
end

```

### onGameStateChanged

**Description**

**Definition**

> onGameStateChanged()

**Arguments**

| any | gameStateId  |
|-----|--------------|
| any | oldGameState |

**Code**

```lua
function SoundMixer:onGameStateChanged(gameStateId, oldGameState)
    local gameState = self.gameStates[gameStateId]
    if gameState ~ = nil then
        self.isDirty = true
        --#debug else
            --#debug Logging.warning("No sound mixing settings for game state %s", gameStateId)
            end
        end

```

### setAudioGroupVolumeFactor

**Description**

**Definition**

> setAudioGroupVolumeFactor()

**Arguments**

| any | audioGroupIndex |
|-----|-----------------|
| any | factor          |

**Code**

```lua
function SoundMixer:setAudioGroupVolumeFactor(audioGroupIndex, factor)
    if audioGroupIndex ~ = nil and self.volumeFactors[audioGroupIndex] ~ = nil then
        self.volumeFactors[audioGroupIndex] = factor
        self.isDirty = true
    end
end

```

### setMasterVolume

**Description**

**Definition**

> setMasterVolume()

**Arguments**

| any | masterVolume |
|-----|--------------|

**Code**

```lua
function SoundMixer:setMasterVolume(masterVolume)
    self.masterVolume = masterVolume
    setMasterVolume(masterVolume)
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function SoundMixer:update(dt)
    if self.isDirty then
        local gameStateIndex = g_gameStateManager:getGameState()
        local gameState = self.gameStates[gameStateIndex]
        if gameState ~ = nil then
            local isDone = true
            for audioGroupIndex, data in pairs(gameState) do
                local currentVolume = self.volumes[audioGroupIndex]
                local target = data.volume * self.volumeFactors[audioGroupIndex]
                if currentVolume ~ = target then
                    isDone = false

                    local dir = 1
                    local func = math.min
                    local fadeDuration = data.fadeInDuration
                    if currentVolume > target then
                        dir = - 1
                        func = math.max
                        fadeDuration = data.fadeOutDuration
                    end

                    local changePerFrame = 1
                    if fadeDuration > 0 then
                        changePerFrame = dt / fadeDuration
                    end

                    currentVolume = func(currentVolume + dir * changePerFrame, target)
                    setAudioGroupVolume(audioGroupIndex, currentVolume)

                    self.volumes[audioGroupIndex] = currentVolume
                    for _, listener in ipairs( self.volumeChangedListeners[audioGroupIndex]) do
                        listener.func(listener.target, audioGroupIndex, currentVolume)
                    end
                end
            end

            if isDone then
                self.isDirty = false
            end
        end
    end
end

```