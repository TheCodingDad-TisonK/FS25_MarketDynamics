## SoundManager

**Description**

> This class handles all sounds

**Parent**

> [AbstractManager](?version=script&category=76&class=617)

**Functions**

- [addIndoorStateChangedListener](#addindoorstatechangedlistener)
- [cloneSample](#clonesample)
- [cloneSample2D](#clonesample2d)
- [consoleCommandToggleDebug](#consolecommandtoggledebug)
- [createAudio2d](#createaudio2d)
- [createAudioSource](#createaudiosource)
- [delete](#delete)
- [deleteSample](#deletesample)
- [deleteSamples](#deletesamples)
- [draw](#draw)
- [getCurrentFadeFactor](#getcurrentfadefactor)
- [getCurrentRandomizationValue](#getcurrentrandomizationvalue)
- [getCurrentSampleLowpassGain](#getcurrentsamplelowpassgain)
- [getCurrentSamplePitch](#getcurrentsamplepitch)
- [getCurrentSampleVolume](#getcurrentsamplevolume)
- [getIsIndoor](#getisindoor)
- [getIsSamplePlaying](#getissampleplaying)
- [getModifierFactor](#getmodifierfactor)
- [getRandomSample](#getrandomsample)
- [getSampleLoopSynthesisStartDuration](#getsampleloopsynthesisstartduration)
- [getSampleModifierValue](#getsamplemodifiervalue)
- [getSampleVolumeScale](#getsamplevolumescale)
- [initDataStructures](#initdatastructures)
- [loadModifiersFromXML](#loadmodifiersfromxml)
- [loadRandomizationsFromXML](#loadrandomizationsfromxml)
- [loadSample2DFromXML](#loadsample2dfromxml)
- [loadSampleAttributesFromTemplate](#loadsampleattributesfromtemplate)
- [loadSampleAttributesFromXML](#loadsampleattributesfromxml)
- [loadSampleFromXML](#loadsamplefromxml)
- [loadSamplesFromXML](#loadsamplesfromxml)
- [loadSoundTemplates](#loadsoundtemplates)
- [new](#new)
- [onCreateAudio2d](#oncreateaudio2d)
- [onCreateAudioSource](#oncreateaudiosource)
- [playSample](#playsample)
- [playSamples](#playsamples)
- [registerModifierType](#registermodifiertype)
- [registerModifierXMLPaths](#registermodifierxmlpaths)
- [registerSampleXMLPaths](#registersamplexmlpaths)
- [reloadSoundTemplates](#reloadsoundtemplates)
- [removeIndoorStateChangedListener](#removeindoorstatechangedlistener)
- [setCurrentSampleAttributes](#setcurrentsampleattributes)
- [setIsIndoor](#setisindoor)
- [setSampleLoopSynthesisParameters](#setsampleloopsynthesisparameters)
- [setSampleLowpassGainOffset](#setsamplelowpassgainoffset)
- [setSamplePitch](#setsamplepitch)
- [setSamplePitchOffset](#setsamplepitchoffset)
- [setSamplesLoopSynthesisParameters](#setsamplesloopsynthesisparameters)
- [setSampleVolume](#setsamplevolume)
- [setSampleVolumeOffset](#setsamplevolumeoffset)
- [setSampleVolumeScale](#setsamplevolumescale)
- [stopSample](#stopsample)
- [stopSamples](#stopsamples)
- [update](#update)
- [updateSampleAttributes](#updatesampleattributes)
- [updateSampleFade](#updatesamplefade)
- [updateSampleModifiers](#updatesamplemodifiers)
- [updateSampleRandomizations](#updatesamplerandomizations)
- [validateSampleDefinition](#validatesampledefinition)

### addIndoorStateChangedListener

**Description**

**Definition**

> addIndoorStateChangedListener()

**Arguments**

| any | target |
|-----|--------|

**Code**

```lua
function SoundManager:addIndoorStateChangedListener(target)
    table.addElement( self.indoorStateChangedListeners, target)
end

```

### cloneSample

**Description**

> Returns a clone of the sample at the given link node

**Definition**

> cloneSample(table sample, integer linkNode, )

**Arguments**

| table   | sample               | sample object       |
|---------|----------------------|---------------------|
| integer | linkNode             | id of new link node |
| any     | modifierTargetObject |                     |

**Return Values**

| any | sample | sample object |
|-----|--------|---------------|

**Code**

```lua
function SoundManager:cloneSample(sample, linkNode, modifierTargetObject)
    local newSample = table.clone(sample)
    newSample.modifiers = table.clone(sample.modifiers)

    if not sample.is2D then
        newSample.soundNode = createAudioSource(newSample.sampleName, newSample.filename, newSample.outerRadius, newSample.innerRadius, newSample.current.volume, newSample.loops)
        newSample.soundSample = getAudioSourceSample(newSample.soundNode)
        setAudioSourceAutoPlay(newSample.soundNode, false )
        link(linkNode, newSample.soundNode)
        newSample.linkNode = linkNode

        if newSample.linkNodeOffset = = nil then
            setTranslation(newSample.soundNode, 0 , 0 , 0 )
        else
                setTranslation(newSample.soundNode, newSample.linkNodeOffset[ 1 ], newSample.linkNodeOffset[ 2 ], newSample.linkNodeOffset[ 3 ])
            end
        end

        setSampleGroup(newSample.soundSample, sample.audioGroup)
        newSample.audioGroup = sample.audioGroup

        if sample.supportsReverb then
            addSampleEffect(newSample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
        else
                removeSampleEffect(sample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
            end

            if modifierTargetObject ~ = nil then
                newSample.modifierTargetObject = modifierTargetObject
            end

            if sample.sourceRandomizations ~ = nil then
                newSample.sourceRandomizations = { }
                for _, randomSample in ipairs(sample.sourceRandomizations) do
                    local newRandomSample = self:getRandomSample(sample, randomSample.filename)

                    table.insert(newSample.sourceRandomizations, newRandomSample)
                end
            end

            self.samples[newSample] = newSample
            table.insert( self.orderedSamples, newSample)

            return newSample
        end

```

### cloneSample2D

**Description**

> Returns a clone of the sample at the given link node

**Definition**

> cloneSample2D(table sample, integer linkNode, )

**Arguments**

| table   | sample               | sample object       |
|---------|----------------------|---------------------|
| integer | linkNode             | id of new link node |
| any     | modifierTargetObject |                     |

**Return Values**

| any | sample | sample object |
|-----|--------|---------------|

**Code**

```lua
function SoundManager:cloneSample2D(sample, linkNode, modifierTargetObject)
    local newSample = table.clone(sample)
    newSample.modifiers = table.clone(sample.modifiers)

    newSample.audioGroup = sample.audioGroup
    newSample.linkNode = nil
    newSample.soundNode = nil
    newSample.is2D = true

    newSample.soundSample = createSample(newSample.sampleName)
    newSample.orgSoundSample = newSample.soundSample

    loadSample(newSample.soundSample, newSample.filename, false )
    newSample.duration = getSampleDuration(newSample.soundSample)
    setSampleGroup(newSample.soundSample, sample.audioGroup)
    newSample.audioGroup = sample.audioGroup

    if modifierTargetObject ~ = nil then
        newSample.modifierTargetObject = modifierTargetObject
    end

    if sample.sourceRandomizations ~ = nil then
        newSample.sourceRandomizations = { }
        for _, randomSample in ipairs(sample.sourceRandomizations) do
            local newRandomSample = { }
            newRandomSample.filename = randomSample.filename
            newRandomSample.isEmpty = randomSample.isEmpty
            newRandomSample.is2D = true
            if not randomSample.isEmpty then
                newRandomSample.soundSample = createSample(newSample.sampleName)
                loadSample(newRandomSample.soundSample, newRandomSample.filename, false )
            end

            table.insert(newSample.sourceRandomizations, newRandomSample)
        end
    end

    self.samples[newSample] = newSample
    table.insert( self.orderedSamples, newSample)

    return newSample
end

```

### consoleCommandToggleDebug

**Description**

**Definition**

> consoleCommandToggleDebug()

**Code**

```lua
function SoundManager:consoleCommandToggleDebug()
    SoundManager.GLOBAL_DEBUG_ENABLED = not SoundManager.GLOBAL_DEBUG_ENABLED
    if SoundManager.GLOBAL_DEBUG_ENABLED then
        -- add all 3d samples to debugSamples table
        for _, sample in pairs( self.orderedSamples) do
            if sample.linkNode ~ = nil then
                self.debugSamples[sample] = true
            end
        end
    else
            table.clear( self.debugSamples)
            -- remove all debugSamples except the ones flagged in xml
            for _, sample in pairs( self.debugSamplesFlagged) do
                self.debugSamples[sample] = true
            end
        end
        return string.format( "SoundManager.GLOBAL_DEBUG_ENABLED = %s" , SoundManager.GLOBAL_DEBUG_ENABLED)
    end

```

### createAudio2d

**Description**

**Definition**

> createAudio2d()

**Arguments**

| any | sample   |
|-----|----------|
| any | filename |

**Code**

```lua
function SoundManager:createAudio2d(sample, filename)
    if sample.soundSample ~ = nil then
        delete(sample.soundSample)
    end

    if string.isNilOrWhitespace(filename) then
        return
    end

    sample.soundSample = createSample(sample.sampleName)
    sample.orgSoundSample = sample.soundSample
    loadSample(sample.soundSample, filename, false )

    self:onCreateAudio2d(sample)
end

```

### createAudioSource

**Description**

**Definition**

> createAudioSource()

**Arguments**

| any | sample   |
|-----|----------|
| any | filename |

**Code**

```lua
function SoundManager:createAudioSource(sample, filename)
    if sample.soundNode ~ = nil then
        delete(sample.soundNode)
    end

    if string.isNilOrWhitespace(filename) then
        return
    end

    sample.filename = filename
    local audioSourceName = string.format( "%s - %s" , sample.sampleName, filename)
    sample.soundNode = createAudioSource(audioSourceName, filename, sample.outerRadius, sample.innerRadius, sample.current.volume, sample.loops)
    sample.soundSample = getAudioSourceSample(sample.soundNode)

    self:onCreateAudioSource(sample)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function SoundManager:delete()
    if self.soundTemplateXMLFile ~ = nil then
        delete( self.soundTemplateXMLFile)
        self.soundTemplateXMLFile = nil
    end
end

```

### deleteSample

**Description**

> Deletes the sample

**Definition**

> deleteSample(table sample)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|

**Code**

```lua
function SoundManager:deleteSample(sample)
    if sample ~ = nil and sample.filename ~ = nil then
        if self:getIsSamplePlaying(sample) then
            self:stopSample(sample)
        end

        self.samples[sample] = nil
        table.removeElement( self.activeSamples, sample)
        table.removeElement( self.orderedSamples, sample)
        self.debugSamples[sample] = nil
        table.removeElement( self.debugSamplesFlagged, sample)

        if sample.soundNode ~ = nil then
            delete(sample.soundNode)
        end
        if sample.is2D and sample.orgSoundSample ~ = nil then
            delete(sample.orgSoundSample)
        end

        if sample.sourceRandomizations ~ = nil then
            for _, randomSample in ipairs(sample.sourceRandomizations) do
                if not randomSample.isEmpty then
                    if randomSample.soundNode ~ = nil and randomSample.soundNode ~ = sample.soundNode then
                        delete(randomSample.soundNode)
                    end
                    if randomSample.is2D then
                        delete(randomSample.soundSample)
                    end
                end
            end

            sample.sourceRandomizations = nil
        end

        sample.soundSample = nil
        sample.soundNode = nil
    end
end

```

### deleteSamples

**Description**

> Deletes table of samples

**Definition**

> deleteSamples(table samples, , )

**Arguments**

| table | samples     | table with sample objects |
|-------|-------------|---------------------------|
| any   | delay       |                           |
| any   | afterSample |                           |

**Code**

```lua
function SoundManager:deleteSamples(samples, delay, afterSample)
    if samples ~ = nil then
        for _, sample in pairs(samples) do
            self:deleteSample(sample, delay, afterSample)
        end
    end
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function SoundManager:draw()
    -- draw sample debug
    for linkNode, linkNodeSamples in pairs( self.debugSamplesLinkNodes) do
        -- draw link node
        local x,y,z = getWorldTranslation(linkNode)
        local debugNode = createTransformGroup( "sampleDebugNode" )
        setTranslation(debugNode, x,y,z)

        local isVisible = getEffectiveVisibility(linkNode)
        local linkNodeText = string.format( "LinkNode '%s' (visible = %s)" , getName(linkNode), isVisible)
        local linkNodeColor = not isVisible and Color.PRESETS.RED or nil
        DebugPoint.renderAtNode(linkNode, nil , linkNodeColor, false , linkNodeText, 0.012 , 250 , 150 )

        -- draw invidiual samples
        for i = 1 , #linkNodeSamples do
            local sample = linkNodeSamples[i]
            local name = sample.sampleName or i
            local rotOffset = i / 100 -- slightly offset rotation per sample so circles with same radius distinguishable

            local text = string.format( "AudioSample '%s' IR = %d OR = %d isPlaying = %s tmpl = %s" , name, sample.innerRadius, sample.outerRadius, self:getIsSamplePlaying(sample), sample.templateName)
            local color = DebugUtil.tableToColor(sample)
            setRotation(debugNode, 0 , rotOffset, 0 )
            Utils.renderTextAtWorldPosition(x,y,z, text, getCorrectTextSize( 0.016 ), i * getCorrectTextSize( 0.016 ), color)
            DebugSphere.renderAtNode(debugNode, nil , sample.outerRadius, color, 20 )
        end
        delete(debugNode)
    end
end

```

### getCurrentFadeFactor

**Description**

**Definition**

> getCurrentFadeFactor()

**Arguments**

| any | sample |
|-----|--------|

**Code**

```lua
function SoundManager:getCurrentFadeFactor(sample)
    local fadeFactor = 1

    if sample.fadeIn ~ = 0 then
        fadeFactor = sample.fade / sample.fadeIn
    end

    return fadeFactor
end

```

### getCurrentRandomizationValue

**Description**

**Definition**

> getCurrentRandomizationValue()

**Arguments**

| any | sample    |
|-----|-----------|
| any | attribute |

**Code**

```lua
function SoundManager:getCurrentRandomizationValue(sample, attribute)
    if sample.randomizations ~ = nil then
        if sample.randomizations[attribute] ~ = nil then
            return sample.randomizations[attribute]
        end
    end

    return 0
end

```

### getCurrentSampleLowpassGain

**Description**

**Definition**

> getCurrentSampleLowpassGain()

**Arguments**

| any | sample |
|-----|--------|

**Code**

```lua
function SoundManager:getCurrentSampleLowpassGain(sample)
    return(sample.current.lowpassGain + self:getCurrentRandomizationValue(sample, "lowpassGain" )) * sample.lowpassGainScale + sample.offsets.lowpassGain
end

```

### getCurrentSamplePitch

**Description**

**Definition**

> getCurrentSamplePitch()

**Arguments**

| any | sample |
|-----|--------|

**Code**

```lua
function SoundManager:getCurrentSamplePitch(sample)
    return(sample.current.pitch + self:getCurrentRandomizationValue(sample, "pitch" )) * sample.pitchScale + sample.offsets.pitch
end

```

### getCurrentSampleVolume

**Description**

**Definition**

> getCurrentSampleVolume()

**Arguments**

| any | sample |
|-----|--------|

**Code**

```lua
function SoundManager:getCurrentSampleVolume(sample)
    return math.max((sample.current.volume + self:getCurrentRandomizationValue(sample, "volume" )) * self:getCurrentFadeFactor(sample) * sample.volumeScale + sample.offsets.volume, 0 )
end

```

### getIsIndoor

**Description**

> Checks if indoor mode is active

**Definition**

> getIsIndoor()

**Return Values**

| any | isIndoor | true if indoor mode is active else false |
|-----|----------|------------------------------------------|

**Code**

```lua
function SoundManager:getIsIndoor()
    return self.isIndoor
end

```

### getIsSamplePlaying

**Description**

> Checks if a sample is playing

**Definition**

> getIsSamplePlaying(table sample)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|

**Return Values**

| table | isPlaying | true if sample is playing else false |
|-------|-----------|--------------------------------------|

**Code**

```lua
function SoundManager:getIsSamplePlaying(sample)
    if sample ~ = nil and sample.soundSample ~ = nil then
        --#debug Assert.isTrue(entityExists(sample.soundSample), "Audio sample entity for %q does not exist anymore", sample.filename)
            return isSamplePlaying(sample.soundSample)
        end

        return false
    end

```

### getModifierFactor

**Description**

> Gets modifier factor

**Definition**

> getModifierFactor(table sample, string modifierName)

**Arguments**

| table  | sample       | sample object     |
|--------|--------------|-------------------|
| string | modifierName | the modifier name |

**Return Values**

| string | factor | the modifier factor |
|--------|--------|---------------------|

**Code**

```lua
function SoundManager:getModifierFactor(sample, modifierName)
    if sample.modifiers ~ = nil then
        local modifier = sample.modifiers[modifierName]
        if modifier ~ = nil and modifier.currentValue ~ = nil then
            return modifier.currentValue
        end
    end

    return 1.0
end

```

### getRandomSample

**Description**

**Definition**

> getRandomSample()

**Arguments**

| any | sample   |
|-----|----------|
| any | filename |

**Code**

```lua
function SoundManager:getRandomSample(sample, filename)
    local randomSample = { }
    randomSample.filename = filename
    if filename ~ = "-" then
        if not sample.is2D then
            local audioSourceName = string.format( "%s - %s" , sample.sampleName, filename)
            local audioSource = createAudioSource(audioSourceName, filename, sample.outerRadius, sample.innerRadius, 1 , sample.loops)
            if audioSource ~ = 0 then
                randomSample.soundNode = audioSource
                local sampleId = getAudioSourceSample(randomSample.soundNode)
                if sample.supportsReverb then
                    addSampleEffect(sampleId, SoundManager.DEFAULT_REVERB_EFFECT)
                else
                        removeSampleEffect(sampleId, SoundManager.DEFAULT_REVERB_EFFECT)
                    end
                    setAudioSourcePriority(audioSource, sample.priority)
                end
            else
                    local sample2D = createSample(sample.sampleName)
                    if sample2D ~ = 0 and loadSample(sample2D, filename, false ) then
                        randomSample.soundSample = sample2D
                        randomSample.is2D = true
                    end
                end
            else
                    randomSample.isEmpty = true
                end

                return randomSample
            end

```

### getSampleLoopSynthesisStartDuration

**Description**

> Returns sample loop synthesis start duration

**Definition**

> getSampleLoopSynthesisStartDuration(table sample)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|

**Return Values**

| table | duration | duration |
|-------|----------|----------|

**Code**

```lua
function SoundManager:getSampleLoopSynthesisStartDuration(sample)
    if sample ~ = nil and sample.soundSample ~ = nil then
        if sample.isGlsFile then
            return getSampleLoopSynthesisStartDuration(sample.soundSample)
        end
    end

    return 0
end

```

### getSampleModifierValue

**Description**

> Gets sample modifiers

**Definition**

> getSampleModifierValue(table sample, table inputs, string debugString)

**Arguments**

| table  | sample      | sample object     |
|--------|-------------|-------------------|
| table  | inputs      | a table of values |
| string | debugString | a string          |

**Code**

```lua
function SoundManager:getSampleModifierValue(sample, attribute, typeIndex)
    local modifier = sample.modifiers[attribute]
    if modifier ~ = nil then
        local curve = modifier[typeIndex]
        if curve ~ = nil then
            local typeData = self.modifierTypeIndexToDesc[typeIndex]
            local t = typeData.func(sample.modifierTargetObject)
            if typeData.maxFunc ~ = nil and typeData.minFunc ~ = nil then
                local min = typeData.minFunc(sample.modifierTargetObject)
                t = math.clamp((t - min ) / (typeData.maxFunc(sample.modifierTargetObject) - min ), 0 , 1 )
            end

            return curve:get(t), t, true
        end
    end

    return 0 , 0 , false
end

```

### getSampleVolumeScale

**Description**

> returns the sample volume scale

**Definition**

> getSampleVolumeScale(table sample)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|

**Return Values**

| table | volumeScale | volume scale |
|-------|-------------|--------------|

**Code**

```lua
function SoundManager:getSampleVolumeScale(sample)
    if sample ~ = nil then
        return sample.volumeScale
    end

    return 1
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function SoundManager:initDataStructures()
    self.samples = { }
    self.orderedSamples = { }
    self.activeSamples = { }
    self.activeSamplesSet = { }
    self.debugSamplesFlagged = { } -- array, containing all samples which are flagged for debugging in xml
        self.debugSamples = { } -- sample indexed table, contains all samples which will be drawn
        self.debugSamplesLinkNodes = { } -- link-node indexed table, contaning array of samples
        self.currentSampleIndex = 1
        self.oldRandomizationIndex = 1
        self.isIndoor = false

        self.soundTemplates = { }
        self.soundTemplateXMLFile = nil
        self:loadSoundTemplates( SoundManager.DEFAULT_SOUND_TEMPLATES)

        self.modifierTypeNameToIndex = { }
        self.modifierTypeIndexToDesc = { }
        SoundModifierType = self.modifierTypeNameToIndex

        setReverbEffect( 0 , Reverb.GS_OPEN_FIELD, Reverb.GS_OPEN_FIELD, 1.0 )

        self.indoorStateChangedListeners = { }
    end

```

### loadModifiersFromXML

**Description**

> Loads a sample modifiers from xml

**Definition**

> loadModifiersFromXML(table sample, integer xmlFile, string key)

**Arguments**

| table   | sample  | sample object   |
|---------|---------|-----------------|
| integer | xmlFile | xml-file handle |
| string  | key     | xml element key |

**Code**

```lua
function SoundManager:loadModifiersFromXML(sample, xmlFile, key)
    sample.modifiers = sample.modifiers or { }
    for _, attribute in pairs( SoundManager.SAMPLE_MODIFIER_ATTRIBUTES) do
        local modifier = sample.modifiers[attribute] or { }
        modifier.hasModification = Utils.getNoNil(modifier.hasModification, false )

        local i = 0
        while true do
            local modKey = string.format( "%s.%s.modifier(%d)" , key, attribute, i)
            if not hasXMLProperty(xmlFile, modKey) then
                break
            end

            local type = getXMLString(xmlFile, modKey .. "#type" )
            local typeIndex = SoundModifierType[ type ]
            if typeIndex ~ = nil then
                if modifier[typeIndex] = = nil then
                    modifier[typeIndex] = AnimCurve.new(linearInterpolator1)
                end

                local value = getXMLFloat(xmlFile, modKey .. "#value" )
                local modifiedValue = getXMLFloat(xmlFile, modKey .. "#modifiedValue" )
                modifier[typeIndex]:addKeyframe( { modifiedValue, time = value } , xmlFile, modKey)

                modifier.hasModification = true
                --TODO:remove debug comment and enable warning for everyone for next release
                    --#debug else
                        --#debug Logging.xmlWarning(xmlFile, "Unknown modifier type '%s' in '%s'\nAvailable types: %s", type, key, table.concatKeys(SoundModifierType, ", "))
                    end
                    i = i + 1
                end

                modifier.currentValue = nil
                sample.modifiers[attribute] = modifier
            end
        end

```

### loadRandomizationsFromXML

**Description**

> Loads a sample modifiers from xml

**Definition**

> loadRandomizationsFromXML(table sample, integer xmlFile, string key, )

**Arguments**

| table   | sample  | sample object   |
|---------|---------|-----------------|
| integer | xmlFile | xml-file handle |
| string  | key     | xml element key |
| any     | baseDir |                 |

**Code**

```lua
function SoundManager:loadRandomizationsFromXML(sample, xmlFile, key, baseDir)
    local i = 0
    while true do
        local baseKey = string.format( "%s.randomization(%d)" , key, i)
        if not hasXMLProperty(xmlFile, baseKey) then
            break
        end

        local randomization = { }

        randomization.minVolume = getXMLFloat(xmlFile, baseKey .. "#minVolume" )
        randomization.maxVolume = getXMLFloat(xmlFile, baseKey .. "#maxVolume" )

        randomization.minPitch = getXMLFloat(xmlFile, baseKey .. "#minPitch" )
        randomization.maxPitch = getXMLFloat(xmlFile, baseKey .. "#maxPitch" )

        randomization.minLowpassGain = getXMLFloat(xmlFile, baseKey .. "#minLowpassGain" )
        randomization.maxLowpassGain = getXMLFloat(xmlFile, baseKey .. "#maxLowpassGain" )

        randomization.isInside = Utils.getNoNil(getXMLBool(xmlFile, baseKey .. "#isInside" ), true )
        randomization.isOutside = Utils.getNoNil(getXMLBool(xmlFile, baseKey .. "#isOutside" ), true )

        if randomization.isInside then
            if randomization.minVolume ~ = nil then
                if sample.indoorAttributes.volume + randomization.minVolume < = 0 then
                    Logging.xmlWarning(xmlFile, "Invalid sample '%s' randomization found in %s.randomization#minVolume can result in negative volume(indoor)" , sample.templateName or sample.sampleName, baseKey)
                end
            end

            sample.randomizationsIn = sample.randomizationsIn or { }
            table.insert(sample.randomizationsIn, randomization)
        end

        if randomization.isOutside then
            if randomization.minVolume ~ = nil then
                if sample.outdoorAttributes.volume + randomization.minVolume < = 0 then
                    Logging.xmlWarning(xmlFile, "Invalid sample '%s' randomization found in %s.randomization#minVolume can result in negative volume(outdoor)" , sample.templateName or sample.sampleName, baseKey)
                end
            end

            sample.randomizationsOut = sample.randomizationsOut or { }
            table.insert(sample.randomizationsOut, randomization)
        end

        i = i + 1
    end

    i = 0
    while true do
        local baseKey = string.format( "%s.sourceRandomization(%d)" , key, i)
        if not hasXMLProperty(xmlFile, baseKey) then
            break
        end

        local filename = getXMLString(xmlFile, baseKey .. "#file" )
        if filename ~ = nil then
            if filename ~ = "-" then
                filename = Utils.getFilename(filename, baseDir)
            end

            local randomSample = self:getRandomSample(sample, filename)

            sample.sourceRandomizations = sample.sourceRandomizations or { }
            table.insert(sample.sourceRandomizations, randomSample)
        end

        i = i + 1
    end

    if sample.sourceRandomizations ~ = nil and #sample.sourceRandomizations > 0 and not sample.addedBaseFileToRandomizations then
        local filename = Utils.getFilename(sample.filename, baseDir)

        local randomSample = self:getRandomSample(sample, filename)
        table.insert(sample.sourceRandomizations, randomSample)

        sample.addedBaseFileToRandomizations = true
    end
end

```

### loadSample2DFromXML

**Description**

> Loads a 2D sample from XML.
> This creates a sample using no spatial information to be used for global, client-only contexts (e.g. UI).

**Definition**

> loadSample2DFromXML(integer xmlFile, string baseKey, string sampleName, string baseDir, integer loops, string
> audioGroup, boolean? requiresFile)

**Arguments**

| integer  | xmlFile      | Sample definition XML file handle                                         |
|----------|--------------|---------------------------------------------------------------------------|
| string   | baseKey      | Parent element key of sample                                              |
| string   | sampleName   | Sample element name                                                       |
| string   | baseDir      | Sample file path base directory                                           |
| integer  | loops        | Loop count of sample, defaults to 1. A value of 0 will loop indefinitely. |
| string   | audioGroup   | Sample audio group                                                        |
| boolean? | requiresFile |                                                                           |

**Code**

```lua
function SoundManager:loadSample2DFromXML(xmlFile, baseKey, sampleName, baseDir, loops, audioGroup, requiresFile)
    if type(xmlFile) = = "table" then
        xmlFile = xmlFile.handle
    end

    local sample = nil

    local isValid, usedExternal, definitionXmlFile, sampleKey = self:validateSampleDefinition(xmlFile, baseKey, sampleName, baseDir, audioGroup, true )

    if isValid then
        sample = { }
        sample.is2D = true
        sample.sampleName = sampleName

        local template = getXMLString(definitionXmlFile, sampleKey .. "#template" )
        if template ~ = nil then
            sample = self:loadSampleAttributesFromTemplate(sample, template, baseDir, loops, definitionXmlFile, sampleKey)
            if sample = = nil then
                return nil
            end
        end

        if not self:loadSampleAttributesFromXML(sample, definitionXmlFile, sampleKey, baseDir, loops, requiresFile) then
            return nil
        end

        sample.filename = Utils.getFilename(sample.filename, baseDir)
        sample.linkNode = nil
        sample.current = sample.outdoorAttributes
        sample.audioGroup = audioGroup
        sample.supportsReverb = Utils.getNoNil(getXMLBool(xmlFile, sampleKey .. "#supportsReverb" ), true )

        self:createAudio2d(sample, sample.filename)

        sample.offsets = { volume = 0 , pitch = 0 , lowpassGain = 0 }

        self.samples[sample] = sample
        table.insert( self.orderedSamples, sample)
    end

    if usedExternal then
        delete(definitionXmlFile)
    end

    return sample
end

```

### loadSampleAttributesFromTemplate

**Description**

**Definition**

> loadSampleAttributesFromTemplate()

**Arguments**

| any | sample       |
|-----|--------------|
| any | templateName |
| any | baseDir      |
| any | defaultLoops |
| any | xmlFile      |
| any | sampleKey    |

**Code**

```lua
function SoundManager:loadSampleAttributesFromTemplate(sample, templateName, baseDir, defaultLoops, xmlFile, sampleKey)
    local xmlKey = self.soundTemplates[templateName]
    if xmlKey ~ = nil then
        if self.soundTemplateXMLFile ~ = nil then
            local templateSample = { }
            templateSample.is2D = sample.is2D
            templateSample.sampleName = sample.sampleName
            templateSample.templateName = templateName
            if not self:loadSampleAttributesFromXML(templateSample, self.soundTemplateXMLFile, xmlKey, baseDir, defaultLoops, false ) then
                return nil
            end
            return templateSample
        end
    else
            local xmlFileObject = g_xmlManager:getFileByHandle(xmlFile)
            if xmlFileObject ~ = nil then
                Logging.xmlError(xmlFileObject, "Sound template '%s' was not found in %s" , templateName, sampleKey)
                return nil
            else
                    Logging.error( "Sound template '%s' was not found in %s" , templateName, sampleKey)
                    return nil
                end
            end

            return sample
        end

```

### loadSampleAttributesFromXML

**Description**

> Loads a sample attributes from xml

**Definition**

> loadSampleAttributesFromXML(table sample, integer xmlFile, string key, , , )

**Arguments**

| table   | sample       | sample object   |
|---------|--------------|-----------------|
| integer | xmlFile      | xml-file handle |
| string  | key          | xml element key |
| any     | baseDir      |                 |
| any     | defaultLoops |                 |
| any     | requiresFile |                 |

**Code**

```lua
function SoundManager:loadSampleAttributesFromXML(sample, xmlFile, key, baseDir, defaultLoops, requiresFile)
    local parent = getXMLString(xmlFile, key .. "#parent" )

    if parent ~ = nil then
        local templateKey = self.soundTemplates[parent]
        if templateKey ~ = nil then
            self:loadSampleAttributesFromXML(sample, self.soundTemplateXMLFile, templateKey, baseDir, defaultLoops, false )
        end
    end

    sample.filename = getXMLString(xmlFile, key .. "#file" ) or sample.filename or ""
    if sample.filename = = nil and(requiresFile = = nil or requiresFile) then
        printWarning( "Warning:Filename not defined in '" .. tostring(key) .. "'.Ignoring it!" )
        return false
    end

    sample.linkNodeOffset = string.getVector(getXMLString(xmlFile, key .. "#linkNodeOffset" ), 3 )

    sample.innerRadius = getXMLFloat(xmlFile, key .. "#innerRadius" ) or sample.innerRadius or 5.0
    sample.outerRadius = getXMLFloat(xmlFile, key .. "#outerRadius" ) or sample.outerRadius or 80.0

    sample.volumeScale = getXMLFloat(xmlFile, key .. "#volumeScale" ) or sample.volumeScale or 1.0
    sample.pitchScale = getXMLFloat(xmlFile, key .. "#pitchScale" ) or sample.pitchScale or 1.0
    sample.lowpassGainScale = getXMLFloat(xmlFile, key .. "#lowpassGainScale" ) or sample.lowpassGainScale or 1.0

    sample.loopSynthesisRPMRatio = getXMLFloat(xmlFile, key .. "#loopSynthesisRPMRatio" ) or sample.loopSynthesisRPMRatio or 1.0

    sample.indoorAttributes = sample.indoorAttributes or { }
    sample.indoorAttributes.volume = getXMLFloat(xmlFile, key .. ".volume#indoor" ) or sample.indoorAttributes.volume or 0.8
    sample.indoorAttributes.pitch = getXMLFloat(xmlFile, key .. ".pitch#indoor" ) or sample.indoorAttributes.pitch or 1.0
    sample.indoorAttributes.lowpassGain = getXMLFloat(xmlFile, key .. ".lowpassGain#indoor" ) or sample.indoorAttributes.lowpassGain or 0.8
    sample.indoorAttributes.lowpassCutoffFrequency = getXMLFloat(xmlFile, key .. ".lowpassCutoffFrequency#indoor" ) or sample.indoorAttributes.lowpassCutoffFrequency or 0.0 -- by default this is defined by the group(default 5000hz, resonance 2)
    sample.indoorAttributes.lowpassResonance = getXMLFloat(xmlFile, key .. ".lowpassResonance#indoor" ) or sample.indoorAttributes.lowpassResonance or 0.0

    sample.outdoorAttributes = sample.outdoorAttributes or { }
    sample.outdoorAttributes.volume = getXMLFloat(xmlFile, key .. ".volume#outdoor" ) or sample.outdoorAttributes.volume or 1.0
    sample.outdoorAttributes.pitch = getXMLFloat(xmlFile, key .. ".pitch#outdoor" ) or sample.outdoorAttributes.pitch or 1.0
    sample.outdoorAttributes.lowpassGain = getXMLFloat(xmlFile, key .. ".lowpassGain#outdoor" ) or sample.outdoorAttributes.lowpassGain or 1.0
    sample.outdoorAttributes.lowpassCutoffFrequency = getXMLFloat(xmlFile, key .. ".lowpassCutoffFrequency#outdoor" ) or sample.outdoorAttributes.lowpassCutoffFrequency or 0.0
    sample.outdoorAttributes.lowpassResonance = getXMLFloat(xmlFile, key .. ".lowpassResonance#outdoor" ) or sample.outdoorAttributes.lowpassResonance or 0.0

    sample.loops = getXMLInt(xmlFile, key .. "#loops" ) or sample.loops or defaultLoops or 1

    sample.supportsReverb = Utils.getNoNil( Utils.getNoNil(getXMLBool(xmlFile, key .. "#supportsReverb" ), sample.supportsReverb), true )

    sample.isLocalSound = Utils.getNoNil( Utils.getNoNil(getXMLBool(xmlFile, key .. "#isLocalSound" ), sample.isLocalSound), false )

    local priority
    local priorityStr = getXMLString(xmlFile, key .. "#priority" )
    if priorityStr ~ = nil then
        priority = AudioSourcePriority[ string.upper(priorityStr)]
    end
    sample.priority = priority or sample.priority or AudioSourcePriority.MEDIUM

    sample.debug = Utils.getNoNil(getXMLBool(xmlFile, key .. "#debug" ), sample.debug )
    if sample.debug or SoundManager.GLOBAL_DEBUG_ENABLED then
        if sample.debug then
            -- save flagged samples in separate table to keep them when disabling global mode
            table.insert( self.debugSamplesFlagged, sample)
        end
        self.debugSamples[sample] = true
        sample.debug = nil
    end

    local fadeIn = getXMLFloat(xmlFile, key .. "#fadeIn" )
    if fadeIn ~ = nil then
        fadeIn = fadeIn * 1000
    end
    sample.fadeIn = fadeIn or sample.fadeIn or 0

    local fadeOut = getXMLFloat(xmlFile, key .. "#fadeOut" )
    if fadeOut ~ = nil then
        fadeOut = fadeOut * 1000
    end
    sample.fadeOut = fadeOut or sample.fadeOut or 0

    sample.fade = 0

    sample.isIndoor = false

    self:loadModifiersFromXML(sample, xmlFile, key)
    self:loadRandomizationsFromXML(sample, xmlFile, key, baseDir)

    return true
end

```

### loadSampleFromXML

**Description**

> Loads a sample from xml

**Definition**

> loadSampleFromXML(integer xmlFile, string baseKey, string sampleName, string baseDir, (table|integer) components,
> integer loops, integer audioGroup, table? i3dMappings, table? modifierTargetObject, boolean? requiresFile)

**Arguments**

| integer  | xmlFile              | xml-file handle        |            |
|----------|----------------------|------------------------|------------|
| string   | baseKey              | xml element key        |            |
| string   | sampleName           | sample name            |            |
| string   | baseDir              | base directory         |            |
| (table   | integer)             | components             | components |
| integer  | loops                | number of loops        |            |
| integer  | audioGroup           | audio group index      |            |
| table?   | i3dMappings          | i3d mapping table      |            |
| table?   | modifierTargetObject | modifier target object |            |
| boolean? | requiresFile         |                        |            |

**Return Values**

| boolean? | sample |
|----------|--------|

**Code**

```lua
function SoundManager:loadSampleFromXML(xmlFile, baseKey, sampleName, baseDir, components, loops, audioGroup, i3dMappings, modifierTargetObject, requiresFile)
    local sample = nil

    if type(xmlFile) = = "table" then
        xmlFile = xmlFile.handle
    end

    local externalSoundsFile, volumeFactor
    if modifierTargetObject ~ = nil then
        externalSoundsFile = modifierTargetObject.externalSoundsFile
        volumeFactor = modifierTargetObject.soundVolumeFactor
    end

    local isValid, _, definitionXmlFile, sampleKey, linkNode = self:validateSampleDefinition(xmlFile, baseKey, sampleName, baseDir, audioGroup, false , components, i3dMappings, externalSoundsFile)

    if isValid then
        sample = { }
        sample.is2D = false
        sample.sampleName = sampleName

        local template = getXMLString(definitionXmlFile, sampleKey .. "#template" )
        if template ~ = nil then
            sample = self:loadSampleAttributesFromTemplate(sample, template, baseDir, loops, definitionXmlFile, sampleKey)
            if sample = = nil then
                return nil
            end
        end

        if not self:loadSampleAttributesFromXML(sample, definitionXmlFile, sampleKey, baseDir, loops, requiresFile) then
            return nil
        end

        sample.filename = Utils.getFilename(sample.filename, baseDir)
        sample.isGlsFile = sample.filename:find( ".gls" ) ~ = nil
        sample.linkNode = linkNode
        sample.modifierTargetObject = modifierTargetObject
        sample.current = sample.outdoorAttributes
        sample.audioGroup = audioGroup

        if volumeFactor ~ = nil then
            sample.volumeScale = sample.volumeScale * volumeFactor
        end

        self:createAudioSource(sample, sample.filename)

        sample.offsets = { volume = 0 , pitch = 0 , lowpassGain = 0 }

        self.samples[sample] = sample
        table.insert( self.orderedSamples, sample)
    end

    return sample
end

```

### loadSamplesFromXML

**Description**

> Loads multiple samples for same xml key into a table and returns it

**Definition**

> loadSamplesFromXML(integer xmlFile, string key, string sampleName, string baseDir, table components, integer loops,
> integer audioGroup, table i3dMappings, table? modifierTargetObject, table? samples)

**Arguments**

| integer | xmlFile              | xml-file handle                 |
|---------|----------------------|---------------------------------|
| string  | key                  | xml element key                 |
| string  | sampleName           | sample name                     |
| string  | baseDir              | base directory                  |
| table   | components           | components                      |
| integer | loops                | number of loops                 |
| integer | audioGroup           | audio group index               |
| table   | i3dMappings          | i3d mapping table               |
| table?  | modifierTargetObject | modifier target object          |
| table?  | samples              | table to add the loaded samples |

**Return Values**

| table? | samples | table with samples |
|--------|---------|--------------------|

**Code**

```lua
function SoundManager:loadSamplesFromXML(xmlFile, baseKey, sampleName, baseDir, components, loops, audioGroup, i3dMappings, modifierTargetObject, samples)
    samples = samples or { }
    local i = 0
    while true do
        local sample = g_soundManager:loadSampleFromXML(xmlFile, baseKey, string.format( "%s(%d)" , sampleName, i), baseDir, components, loops, audioGroup, i3dMappings, modifierTargetObject)
        if sample = = nil then
            break
        end

        table.insert(samples, sample)
        i = i + 1
    end

    return samples
end

```

### loadSoundTemplates

**Description**

> Loads sound templates from xml file

**Definition**

> loadSoundTemplates()

**Arguments**

| any | xmlFilename |
|-----|-------------|

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function SoundManager:loadSoundTemplates(xmlFilename)
    local xmlFile = loadXMLFile( "soundTemplates" , xmlFilename)
    if xmlFile ~ = 0 then
        local i = 0
        while true do
            local key = string.format( "soundTemplates.template(%d)" , i)
            if not hasXMLProperty(xmlFile, key) then
                break
            end

            local name = getXMLString(xmlFile, key .. "#name" )
            if name ~ = nil then
                if self.soundTemplates[name] = = nil then
                    self.soundTemplates[name] = key
                else
                        Logging.xmlWarning(xmlFile, "Sound template '%s' already exists!" , name)
                    end
                end

                i = i + 1
            end

            self.soundTemplateXMLFile = xmlFile
            return true
        end

        return false
    end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function SoundManager.new(customMt)
    local self = AbstractManager.new(customMt or SoundManager _mt)

    addConsoleCommand( "gsSoundManagerDebug" , "Toggle SoundManager global debug mode" , "consoleCommandToggleDebug" , self )

    return self
end

```

### onCreateAudio2d

**Description**

**Definition**

> onCreateAudio2d()

**Arguments**

| any | sample       |
|-----|--------------|
| any | ignoreReverb |

**Code**

```lua
function SoundManager:onCreateAudio2d(sample, ignoreReverb)
    sample.duration = getSampleDuration(sample.soundSample)

    setSampleGroup(sample.soundSample, sample.audioGroup)
    setSampleVolume(sample.soundSample, sample.current.volume)
    setSamplePitch(sample.soundSample, sample.current.pitch)
    setSampleFrequencyFilter(sample.soundSample, 1.0 , sample.current.lowpassGain, 0.0 , sample.current.lowpassCutoffFrequency, 0.0 , sample.current.lowpassResonance)

    if not ignoreReverb then
        if sample.supportsReverb then
            addSampleEffect(sample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
        else
                removeSampleEffect(sample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
            end
        end
    end

```

### onCreateAudioSource

**Description**

**Definition**

> onCreateAudioSource()

**Arguments**

| any | sample       |
|-----|--------------|
| any | ignoreReverb |

**Code**

```lua
function SoundManager:onCreateAudioSource(sample, ignoreReverb)
    sample.soundSample = getAudioSourceSample(sample.soundNode)
    sample.duration = getSampleDuration(sample.soundSample)
    sample.outerRange = getAudioSourceRange(sample.soundNode)
    sample.innerRange = getAudioSourceInnerRange(sample.soundNode)
    sample.isDirty = true

    setSampleGroup(sample.soundSample, sample.audioGroup)
    setSampleVolume(sample.soundSample, sample.current.volume)
    setSamplePitch(sample.soundSample, sample.current.pitch)
    setSampleFrequencyFilter(sample.soundSample, 1.0 , sample.current.lowpassGain, 0.0 , sample.current.lowpassCutoffFrequency, 0.0 , sample.current.lowpassResonance)

    if not ignoreReverb then
        if sample.supportsReverb then
            addSampleEffect(sample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
        else
                removeSampleEffect(sample.soundSample, SoundManager.DEFAULT_REVERB_EFFECT)
            end
        end

        setAudioSourceAutoPlay(sample.soundNode, false )
        setAudioSourcePriority(sample.soundNode, sample.priority)

        link(sample.linkNode, sample.soundNode)

        if sample.linkNodeOffset = = nil then
            setTranslation(sample.soundNode, 0 , 0 , 0 )
        else
                setTranslation(sample.soundNode, sample.linkNodeOffset[ 1 ], sample.linkNodeOffset[ 2 ], sample.linkNodeOffset[ 3 ])
            end
        end

```

### playSample

**Description**

> Plays the sample

**Definition**

> playSample(table sample, float? delay, table? afterSample)

**Arguments**

| table  | sample      | sample object                                                  |
|--------|-------------|----------------------------------------------------------------|
| float? | delay       | delay in milliseconds                                          |
| table? | afterSample | if defined the sample will start after this sample is finished |

**Code**

```lua
function SoundManager:playSample(sample, delay, afterSample)
    if sample ~ = nil then
        if not sample.isLocalSound or sample.modifierTargetObject = = nil or(sample.isLocalSound and sample.modifierTargetObject.isActiveForLocalSound) then
            self:updateSampleRandomizations(sample)
            self:updateSampleModifiers(sample)
            self:updateSampleAttributes(sample, true )

            if not sample.isEmptySample and sample.soundSample ~ = nil then
                delay = delay or 0

                local afterSampleId = 0
                if afterSample ~ = nil then
                    afterSampleId = afterSample.soundSample
                end
                playSample(sample.soundSample, sample.loops, self:getModifierFactor(sample, "volume" ) * self:getCurrentSampleVolume(sample), 0 , delay, afterSampleId)

                table.addElement( self.activeSamples, sample)

                --#debug if SoundManager.GLOBAL_DEBUG_ENABLED then
                    --#debug if sample.linkNode ~ = nil and not getEffectiveVisibility(sample.linkNode) then
                        --#debug if sample.modifierTargetObject = = nil or sample.modifierTargetObject.propertyState = = nil or sample.modifierTargetObject.propertyState ~ = VehiclePropertyState.SHOP_CONFIG then
                            --#debug Logging.devWarning("Sound link node '%s' is not visible or not linked to the root node.The sound '%s' will not play", I3DUtil.getNodePath(sample.linkNode), sample.sampleName)
                            --#debug end
                            --#debug end
                            --#debug end
                        end
                    end
                end
            end

```

### playSamples

**Description**

> Plays table of samples

**Definition**

> playSamples(table samples, integer? delay, table? afterSample)

**Arguments**

| table    | samples     | table with sample objects                                 |
|----------|-------------|-----------------------------------------------------------|
| integer? | delay       | delay in ms                                               |
| table?   | afterSample | sample will be played as soon as afterSample has stoppped |

**Code**

```lua
function SoundManager:playSamples(samples, delay, afterSample)
    for _, sample in pairs(samples) do
        self:playSample(sample, delay, afterSample)
    end
end

```

### registerModifierType

**Description**

> Loads sound templates from xml file

**Definition**

> registerModifierType()

**Arguments**

| any | typeName |
|-----|----------|
| any | func     |
| any | minFunc  |
| any | maxFunc  |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function SoundManager:registerModifierType(typeName, func, minFunc, maxFunc)
    typeName = string.upper(typeName)

    if SoundModifierType[typeName] = = nil then
        if type(func) ~ = "function" then
            Logging.error( "SoundManager.registerModifierType:parameter 'func' is of type '%s'.Possibly the registerModifierType is called before the definition of the function?" , type(func))
                printCallstack()
                return
            end

            local desc = { }
            desc.name = typeName
            desc.index = # self.modifierTypeIndexToDesc + 1
            desc.func = func
            desc.minFunc = minFunc
            desc.maxFunc = maxFunc

            SoundModifierType[typeName] = desc.index
            table.insert( self.modifierTypeIndexToDesc, desc)
        end

        return SoundModifierType[typeName]
    end

```

### registerModifierXMLPaths

**Description**

**Definition**

> registerModifierXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | path   |

**Code**

```lua
function SoundManager.registerModifierXMLPaths(schema, path)
    schema:register(XMLValueType.STRING, path .. ".modifier(?)#type" , "Modifier type" , nil , false , SoundModifierType and table.toList(SoundModifierType))
    schema:register(XMLValueType.FLOAT, path .. ".modifier(?)#value" , "Source value of modifier type" )
    schema:register(XMLValueType.FLOAT, path .. ".modifier(?)#modifiedValue" , "Change that is applied on sample value" )
end

```

### registerSampleXMLPaths

**Description**

**Definition**

> registerSampleXMLPaths(table schema, string basePath, string xmlElementName)

**Arguments**

| table  | schema         |
|--------|----------------|
| string | basePath       |
| string | xmlElementName |

**Code**

```lua
function SoundManager.registerSampleXMLPaths(schema, basePath, xmlElementName)
    schema:setSubSchemaIdentifier( "sounds" )

    if xmlElementName = = nil then
        Logging.error( "Failed to register sound sample xml paths! No sound xml element name given." )
        printCallstack()
        return
    end

    if string.contains(xmlElementName, " " ) then
        Logging.error( "Failed to register sound sample xml paths! XML element name cannot have spaces: '%s'" , xmlElementName)
        printCallstack()
        return
    end

    schema:setXMLSharedRegistration( "SoundManager_sound" , basePath)

    local soundPath = basePath .. "." .. xmlElementName
    schema:register(XMLValueType.NODE_INDEX, soundPath .. "#linkNode" , "Link node for 3d sound" )
        schema:register(XMLValueType.VECTOR_TRANS, soundPath .. "#linkNodeOffset" , "Sound source will be offset by this value to the link node" )
        schema:register(XMLValueType.STRING, soundPath .. "#template" , "Sound template name" )
        schema:registerAutoCompletionDataSource(soundPath .. "#template" , "$data/sounds/soundTemplates.xml" , "soundTemplates.template#name" )

        SoundManager.registerGenericSampleXMLPaths(schema, soundPath)

        schema:resetXMLSharedRegistration( "SoundManager_sound" , basePath)
        schema:setSubSchemaIdentifier()
    end

```

### reloadSoundTemplates

**Description**

> Reloads sound templates xml file

**Definition**

> reloadSoundTemplates()

**Code**

```lua
function SoundManager:reloadSoundTemplates()
    for k, _ in pairs( self.soundTemplates) do
        self.soundTemplates[k] = nil
    end

    if entityExists( self.soundTemplateXMLFile) then
        delete( self.soundTemplateXMLFile)
        self.soundTemplateXMLFile = nil
    end

    self:loadSoundTemplates( SoundManager.DEFAULT_SOUND_TEMPLATES)
end

```

### removeIndoorStateChangedListener

**Description**

**Definition**

> removeIndoorStateChangedListener()

**Arguments**

| any | target |
|-----|--------|

**Code**

```lua
function SoundManager:removeIndoorStateChangedListener(target)
    table.removeElement( self.indoorStateChangedListeners, target)
end

```

### setCurrentSampleAttributes

**Description**

**Definition**

> setCurrentSampleAttributes()

**Arguments**

| any | sample   |
|-----|----------|
| any | isIndoor |

**Code**

```lua
function SoundManager:setCurrentSampleAttributes(sample, isIndoor)
    if isIndoor then
        sample.current = sample.indoorAttributes
        sample.randomizations = sample.randomizationsIn
    else
            sample.current = sample.outdoorAttributes
            sample.randomizations = sample.randomizationsOut
        end
    end

```

### setIsIndoor

**Description**

> Sets the indoor state

**Definition**

> setIsIndoor(boolean true)

**Arguments**

| boolean | true | if sound should be played as indoor, else false |
|---------|------|-------------------------------------------------|

**Code**

```lua
function SoundManager:setIsIndoor(isIndoor)
    if self.isIndoor ~ = isIndoor then
        self.isIndoor = isIndoor

        -- update sample attribute directly so it's not one or more frames delayed
        for i = 1 , # self.activeSamples do
            local sample = self.activeSamples[i]
            if self:getIsSamplePlaying(sample) then
                self:updateSampleAttributes(sample)
            end
        end

        for _, target in ipairs( self.indoorStateChangedListeners) do
            target:onIndoorStateChanged(isIndoor)
        end
    end
end

```

### setSampleLoopSynthesisParameters

**Description**

> Sets sample loop synthesis parameters

**Definition**

> setSampleLoopSynthesisParameters(table sample, float rpm, float loadFactor)

**Arguments**

| table | sample     | sample object |
|-------|------------|---------------|
| float | rpm        | rpm           |
| float | loadFactor | loadFactor    |

**Code**

```lua
function SoundManager:setSampleLoopSynthesisParameters(sample, rpm, loadFactor)
    if sample ~ = nil and sample.soundSample ~ = nil then
        if rpm ~ = nil then
            if sample.loopSynthesisRPMRatio ~ = 1 then
                rpm = math.clamp(rpm / sample.loopSynthesisRPMRatio, 0 , 1 )
            end

            setSampleLoopSynthesisRPM(sample.soundSample, rpm, true )
        end

        if loadFactor ~ = nil then
            setSampleLoopSynthesisLoadFactor(sample.soundSample, loadFactor)
        end
    end
end

```

### setSampleLowpassGainOffset

**Description**

> Sets a lowpass gain offset for given sample

**Definition**

> setSampleLowpassGainOffset(table samples, float offset)

**Arguments**

| table | samples | table with sample objects |
|-------|---------|---------------------------|
| float | offset  | offset                    |

**Code**

```lua
function SoundManager:setSampleLowpassGainOffset(sample, offset)
    if sample ~ = nil then
        sample.offsets.lowpassGain = offset
    end
end

```

### setSamplePitch

**Description**

> Sets the sample pitch

**Definition**

> setSamplePitch(table sample, float pitch)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|
| float | pitch  | pitch         |

**Code**

```lua
function SoundManager:setSamplePitch(sample, pitch)
    if sample ~ = nil and sample.soundSample ~ = nil then
        setSamplePitch(sample.soundSample, pitch)
    end
end

```

### setSamplePitchOffset

**Description**

> Sets a pitch offset for given sample

**Definition**

> setSamplePitchOffset(table samples, float offset)

**Arguments**

| table | samples | table with sample objects |
|-------|---------|---------------------------|
| float | offset  | offset                    |

**Code**

```lua
function SoundManager:setSamplePitchOffset(sample, offset)
    if sample ~ = nil then
        sample.offsets.pitch = offset
    end
end

```

### setSamplesLoopSynthesisParameters

**Description**

> Sets samples loop synthesis parameters

**Definition**

> setSamplesLoopSynthesisParameters(table samples, float rpm, float loadFactor)

**Arguments**

| table | samples    | sample object |
|-------|------------|---------------|
| float | rpm        | rpm           |
| float | loadFactor | loadFactor    |

**Code**

```lua
function SoundManager:setSamplesLoopSynthesisParameters(samples, rpm, loadFactor)
    for _, sample in pairs(samples) do
        self:setSampleLoopSynthesisParameters(sample, rpm, loadFactor)
    end
end

```

### setSampleVolume

**Description**

> Sets the sample volume

**Definition**

> setSampleVolume(table sample, float volume)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|
| float | volume | volume        |

**Code**

```lua
function SoundManager:setSampleVolume(sample, volume)
    if sample ~ = nil and sample.soundSample ~ = nil then
        setSampleVolume(sample.soundSample, volume)
    end
end

```

### setSampleVolumeOffset

**Description**

> Sets a volume offset for given sample

**Definition**

> setSampleVolumeOffset(table samples, float offset)

**Arguments**

| table | samples | table with sample objects |
|-------|---------|---------------------------|
| float | offset  | offset                    |

**Code**

```lua
function SoundManager:setSampleVolumeOffset(sample, offset)
    if sample ~ = nil then
        sample.offsets.volume = offset
    end
end

```

### setSampleVolumeScale

**Description**

> Sets the sample volume scale

**Definition**

> setSampleVolumeScale(table sample, float volumeScale)

**Arguments**

| table | sample      | sample object |
|-------|-------------|---------------|
| float | volumeScale | volume scale  |

**Code**

```lua
function SoundManager:setSampleVolumeScale(sample, volumeScale)
    if sample ~ = nil then
        sample.volumeScale = volumeScale
    end
end

```

### stopSample

**Description**

> Stops the sample

**Definition**

> stopSample(table sample, float? delay, float? fadeOut)

**Arguments**

| table  | sample  | sample object                                                                                     |
|--------|---------|---------------------------------------------------------------------------------------------------|
| float? | delay   | set delay in ms for stopping the sound, set automatically for loop synthesis samples, 0 otherwise |
| float? | fadeOut | set the fade out duration in ms, if not given default defined in the sample is used               |

**Code**

```lua
function SoundManager:stopSample(sample, delay, fadeOut)
    if sample ~ = nil and sample.soundSample ~ = nil then
        stopSample(sample.soundSample, delay or getSampleLoopSynthesisStopDuration(sample.soundSample), fadeOut or sample.fadeOut)
    end
end

```

### stopSamples

**Description**

> Stops table of samples

**Definition**

> stopSamples(table samples)

**Arguments**

| table | samples | table with sample objects |
|-------|---------|---------------------------|

**Code**

```lua
function SoundManager:stopSamples(samples)
    for _, sample in pairs(samples) do
        self:stopSample(sample)
    end
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
function SoundManager:update(dt)
    for i = 0 , SoundManager.MAX_SAMPLES_PER_FRAME do
        local index = self.currentSampleIndex

        if index > # self.activeSamples then
            self.currentSampleIndex = 1
            break
        end

        local sample = self.activeSamples[index]
        if self:getIsSamplePlaying(sample) then
            self:updateSampleFade(sample, dt)
            self:updateSampleModifiers(sample)
            self:updateSampleAttributes(sample)
        else
                table.removeElement( self.activeSamples, sample)
                sample.fade = 0
            end

            self.currentSampleIndex = self.currentSampleIndex + 1
        end

        -- collect samples to debug
        table.clear( self.debugSamplesLinkNodes)
        for sample in pairs( self.debugSamples) do
            if sample.linkNode ~ = nil and entityExists(sample.linkNode) then
                local distanceToCam = calcDistanceFrom(g_cameraManager:getActiveCamera(), sample.linkNode)
                -- sample is flagged for debugging or global debug is enabled + player is within 15m or 150% of the outer radius of the source
                    if distanceToCam < 15 or(distanceToCam < sample.outerRadius * 1.5 ) then
                        -- group samples by linkNodes
                        if self.debugSamplesLinkNodes[sample.linkNode] = = nil then
                            self.debugSamplesLinkNodes[sample.linkNode] = { }
                        end
                        table.insert( self.debugSamplesLinkNodes[sample.linkNode], sample)
                    end
                end
            end
        end

```

### updateSampleAttributes

**Description**

> Updates sample attributes

**Definition**

> updateSampleAttributes(table sample, boolean force)

**Arguments**

| table   | sample | sample object                                    |
|---------|--------|--------------------------------------------------|
| boolean | force  | true if indoor / outdoor change should be forced |

**Code**

```lua
function SoundManager:updateSampleAttributes(sample, force)
    if sample ~ = nil then
        if sample.isIndoor ~ = self.isIndoor or force then
            self:setCurrentSampleAttributes(sample, self.isIndoor)
            sample.isIndoor = self.isIndoor
        end

        if sample.soundSample ~ = nil then
            local volumeFactor = self:getModifierFactor(sample, "volume" )
            local pitchFactor = self:getModifierFactor(sample, "pitch" )
            local lowpassGainFactor = self:getModifierFactor(sample, "lowpassGain" )

            setSampleVolume(sample.soundSample, volumeFactor * self:getCurrentSampleVolume(sample))
            setSamplePitch(sample.soundSample, pitchFactor * self:getCurrentSamplePitch(sample))
            setSampleFrequencyFilter(sample.soundSample, 1.0 , lowpassGainFactor * self:getCurrentSampleLowpassGain(sample), 0.0 , sample.current.lowpassCutoffFrequency, 0.0 , sample.current.lowpassResonance)

            if sample.modifiers[ "loopSynthesisRpm" ].hasModification then
                local loopSynthesisRpmFactor = self:getModifierFactor(sample, "loopSynthesisRpm" )
                setSampleLoopSynthesisRPM(sample.soundSample, math.clamp(loopSynthesisRpmFactor, 0 , 1 ), true )
            end

            if sample.modifiers[ "loopSynthesisLoad" ].hasModification then
                local loopSynthesisLoadFactor = self:getModifierFactor(sample, "loopSynthesisLoad" )
                setSampleLoopSynthesisLoadFactor(sample.soundSample, math.clamp(loopSynthesisLoadFactor, 0 , 1 ))
            end
        end
    end
end

```

### updateSampleFade

**Description**

> Updates sample fade

**Definition**

> updateSampleFade(table sample, float dt)

**Arguments**

| table | sample | sample object              |
|-------|--------|----------------------------|
| float | dt     | time since last call in ms |

**Code**

```lua
function SoundManager:updateSampleFade(sample, dt)
    if sample ~ = nil then
        if sample.fadeIn ~ = 0 then
            sample.fade = math.min(sample.fade + dt, sample.fadeIn)
        end
    end
end

```

### updateSampleModifiers

**Description**

> Updates sample modifiers

**Definition**

> updateSampleModifiers(table sample)

**Arguments**

| table | sample | sample object |
|-------|--------|---------------|

**Code**

```lua
function SoundManager:updateSampleModifiers(sample)
    if sample = = nil or sample.modifiers = = nil then
        return
    end

    for attributeIndex, attribute in pairs( SoundManager.SAMPLE_MODIFIER_ATTRIBUTES) do
        local modifier = sample.modifiers[attribute]

        if modifier ~ = nil then
            local value = 1.0
            for name, typeIndex in pairs(SoundModifierType) do
                local changeValue, _, available = self:getSampleModifierValue(sample, attribute, typeIndex)
                if available then
                    value = value * changeValue
                end
            end

            modifier.currentValue = value
        end
    end
end

```

### updateSampleRandomizations

**Description**

> Updates sample modifiers

**Definition**

> updateSampleRandomizations(table sample, table inputs)

**Arguments**

| table | sample | sample object     |
|-------|--------|-------------------|
| table | inputs | a table of values |

**Code**

```lua
function SoundManager:updateSampleRandomizations(sample)
    if sample = = nil then
        return
    end

    for _, name in ipairs( SoundManager.SAMPLE_RANDOMIZATIONS) do
        if (name = = "randomizationsIn" ) = = sample.isIndoor then
            local numRandomizations = sample[name] and #sample[name] or 0
            if numRandomizations > 0 then
                local randomizationIndexToUse = math.max( math.floor( math.random(numRandomizations)), 1 )
                local randomizationToUse = sample[name][randomizationIndexToUse]

                if randomizationToUse.minVolume ~ = nil and randomizationToUse.maxVolume then
                    sample[name].volume = math.random() * (randomizationToUse.maxVolume - randomizationToUse.minVolume) + randomizationToUse.minVolume
                end

                if randomizationToUse.minPitch ~ = nil and randomizationToUse.maxPitch then
                    sample[name].pitch = math.random() * (randomizationToUse.maxPitch - randomizationToUse.minPitch) + randomizationToUse.minPitch
                end

                if randomizationToUse.minLowpassGain ~ = nil and randomizationToUse.maxLowpassGain then
                    sample[name].lowpassGain = math.random() * (randomizationToUse.maxLowpassGain - randomizationToUse.minLowpassGain) + randomizationToUse.minLowpassGain
                end
            end
        end
    end

    local numRandomizations = sample.sourceRandomizations and #sample.sourceRandomizations or 0
    if numRandomizations > 0 then
        local randomizationIndexToUse = 1
        for i = 1 , 3 do
            randomizationIndexToUse = math.max( math.floor( math.random(numRandomizations)), 1 )
            if self.oldRandomizationIndex ~ = randomizationIndexToUse then
                break
            end
        end
        self.oldRandomizationIndex = randomizationIndexToUse
        local randomSample = sample.sourceRandomizations[randomizationIndexToUse]

        if not sample.is2D then
            if sample.soundSample ~ = nil then
                stopSample(sample.soundSample, 0.0 , sample.fadeOut)
            end

            if not randomSample.isEmpty then
                sample.soundNode = randomSample.soundNode
                self:onCreateAudioSource(sample, true )
                sample.isEmptySample = false
            else
                    sample.isEmptySample = true
                end
            else
                    if sample.soundSample ~ = nil then
                        stopSample(sample.soundSample, 0.0 , sample.fadeOut)
                    end

                    if not randomSample.isEmpty then
                        sample.soundSample = randomSample.soundSample
                        self:onCreateAudio2d(sample, true )
                        sample.isEmptySample = false
                    else
                            sample.isEmptySample = true
                        end
                    end
                end
            end

```

### validateSampleDefinition

**Description**

> Validate a sample definition and parameters.

**Definition**

> validateSampleDefinition(integer xmlFile, string baseKey, string sampleName, string baseDir, string audioGroup,
> boolean is2D, table components, table i3dMappings, )

**Arguments**

| integer | xmlFile            | Sample definition XML file handle                                          |
|---------|--------------------|----------------------------------------------------------------------------|
| string  | baseKey            | Parent element key of sample                                               |
| string  | sampleName         | Sample element name                                                        |
| string  | baseDir            | Sample file path base directory                                            |
| string  | audioGroup         | Sample audio group                                                         |
| boolean | is2D               | If true, the sample is interpreted as a non-spatial sound sample           |
| table   | components         | Path components targeting a node to which a spatial audio source is linked |
| table   | i3dMappings        | Mappings of I3D indices to path components for node link resolution        |
| any     | externalSoundsFile |                                                                            |

**Return Values**

| any | True  | if the definition and parameters are valid                                                                                               |
|-----|-------|------------------------------------------------------------------------------------------------------------------------------------------|
| any | True  | if an external XML file is loaded in place of the given parameter, caller must delete the handle afterwards!                             |
| any | XML   | file handle, either the one passed in as an argument or an alternate external sound file definition which must be released by the caller |
| any | Sound | definition parent element key which may have changed according to an alternate external sound file definition                            |
| any | Link  | node target for spatial sound samples                                                                                                    |

**Code**

```lua
function SoundManager:validateSampleDefinition(xmlFile, baseKey, sampleName, baseDir, audioGroup, is2D, components, i3dMappings, externalSoundsFile)
    local isValid = false
    local usedExternal = false
    local actualXMLFile = xmlFile
    local sampleKey = ""
    local linkNode = nil

    if sampleName ~ = nil then
        if not AudioGroup.getIsValidAudioGroup(audioGroup) then
            printWarning( "Warning:Invalid audioGroup index '" .. tostring(audioGroup) .. "'." )
        end

        sampleKey = baseKey .. "." .. sampleName

        if externalSoundsFile ~ = nil then
            if not hasXMLProperty(actualXMLFile, sampleKey) then
                sampleKey = Vehicle.xmlSchemaSounds:replaceRootName(sampleKey)
                actualXMLFile = externalSoundsFile.handle
                usedExternal = true
            end
        end

        local xmlFileObject = g_xmlManager:getFileByHandle(xmlFile)
        if xmlFileObject ~ = nil then
            XMLUtil.checkDeprecatedXMLElements(xmlFileObject, baseKey .. "#externalSoundFile" , "vehicle.base.sounds#filename" ) --FS19 to FS22
        end

        if actualXMLFile ~ = nil then
            if hasXMLProperty(actualXMLFile, sampleKey) then
                isValid = true

                if not is2D then -- check if linkNode exists
                    linkNode = I3DUtil.indexToObject(components, getXMLString(actualXMLFile, sampleKey .. "#linkNode" ), i3dMappings)
                    if linkNode = = nil then
                        if type(components) = = "number" then
                            linkNode = components
                        elseif type(components) = = "table" then
                                linkNode = components[ 1 ].node
                            else
                                    printWarning( "Warning:Could not find linkNode(" .. tostring(getXMLString(actualXMLFile, sampleKey .. "#linkNode" )) .. ") for sample '" .. tostring(sampleName) .. "'.Ignoring it!" )
                                        isValid = false
                                    end
                                end
                            end
                        end
                    else
                            Logging.warning( "Unable to load sample '%s' from internal or given external sound file '%s'!" , sampleName, externalSoundsFile)
                        end
                    end

                    return isValid, usedExternal, actualXMLFile, sampleKey, linkNode
                end

```