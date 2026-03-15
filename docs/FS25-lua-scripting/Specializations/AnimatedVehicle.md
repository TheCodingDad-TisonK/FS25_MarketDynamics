## AnimatedVehicle

**Description**

> Specialization adding support for (keyframe)animations to vehicles

**Functions**

- [animPartSorter](#animpartsorter)
- [animPartSorterReverse](#animpartsorterreverse)
- [findCurrentPartIndex](#findcurrentpartindex)
- [getAnimationByName](#getanimationbyname)
- [getAnimationDuration](#getanimationduration)
- [getAnimationExists](#getanimationexists)
- [getAnimationSpeed](#getanimationspeed)
- [getAnimationTime](#getanimationtime)
- [getDurationToEndOfPart](#getdurationtoendofpart)
- [getIsAnimationPlaying](#getisanimationplaying)
- [getIsMovingPartActive](#getismovingpartactive)
- [getIsMovingToolActive](#getismovingtoolactive)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getMovedLimitedValue](#getmovedlimitedvalue)
- [getNextPartIsPlaying](#getnextpartisplaying)
- [getNumOfActiveAnimations](#getnumofactiveanimations)
- [getRealAnimationTime](#getrealanimationtime)
- [initializeAnimationPart](#initializeanimationpart)
- [initializeAnimationPartAttribute](#initializeanimationpartattribute)
- [initializeAnimationParts](#initializeanimationparts)
- [initSpecialization](#initspecialization)
- [loadAnimation](#loadanimation)
- [loadAnimationPart](#loadanimationpart)
- [loadMovingPartFromXML](#loadmovingpartfromxml)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [loadStaticAnimationPart](#loadstaticanimationpart)
- [loadStaticAnimationPartValues](#loadstaticanimationpartvalues)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPreLoad](#onpreload)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onUpdate](#onupdate)
- [playAnimation](#playanimation)
- [postInitializeAnimationPart](#postinitializeanimationpart)
- [prerequisitesPresent](#prerequisitespresent)
- [registerAnimationValueType](#registeranimationvaluetype)
- [registerAnimationXMLPaths](#registeranimationxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [resetAnimationPartValues](#resetanimationpartvalues)
- [resetAnimationValues](#resetanimationvalues)
- [setAnimationSpeed](#setanimationspeed)
- [setAnimationStopTime](#setanimationstoptime)
- [setAnimationTime](#setanimationtime)
- [setMovedLimitedValues3](#setmovedlimitedvalues)
- [setMovedLimitedValues4](#setmovedlimitedvalues)
- [setMovedLimitedValuesN](#setmovedlimitedvaluesn)
- [setRealAnimationTime](#setrealanimationtime)
- [stopAnimation](#stopanimation)
- [updateAnimation](#updateanimation)
- [updateAnimationByName](#updateanimationbyname)
- [updateAnimationCurrentTime](#updateanimationcurrenttime)
- [updateAnimationPart](#updateanimationpart)
- [updateAnimations](#updateanimations)

### animPartSorter

**Description**

> Returns true if anim parts are in the right order

**Definition**

> animPartSorter(table a, table b)

**Arguments**

| table | a | part a to check |
|-------|---|-----------------|
| table | b | part b to check |

**Return Values**

| table | rightOrder | returns true if parts are in right order |
|-------|------------|------------------------------------------|

**Code**

```lua
function AnimatedVehicle.animPartSorter(a, b)
    if a.startTime < b.startTime then
        return true
    elseif a.startTime = = b.startTime then
            return a.duration < b.duration
        end
        return false
    end

```

### animPartSorterReverse

**Description**

> Returns true if anim parts are in the reverse right order

**Definition**

> animPartSorterReverse(table a, table b)

**Arguments**

| table | a | part a to check |
|-------|---|-----------------|
| table | b | part b to check |

**Return Values**

| table | rightOrder | returns true if parts are in reverse right order |
|-------|------------|--------------------------------------------------|

**Code**

```lua
function AnimatedVehicle.animPartSorterReverse(a, b)
    local endTimeA = a.startTime + a.duration
    local endTimeB = b.startTime + b.duration
    if endTimeA > endTimeB then
        return true
    elseif endTimeA = = endTimeB then
            return a.startTime > b.startTime
        end
        return false
    end

```

### findCurrentPartIndex

**Description**

> Find current playing part

**Definition**

> findCurrentPartIndex(table animation)

**Arguments**

| table | animation | animation |
|-------|-----------|-----------|

**Return Values**

| table | index | of current playing part |
|-------|-------|-------------------------|

**Code**

```lua
function AnimatedVehicle.findCurrentPartIndex(animation)
    if animation.currentSpeed > 0 then
        -- find the first part that is being played at the current time
        animation.currentPartIndex = #animation.parts + 1
        for i, part in ipairs(animation.parts) do
            if part.startTime + part.duration > = animation.currentTime then
                animation.currentPartIndex = i
                break
            end
        end
    else
            -- find the last part that is being played at the current time(the first in partsReverse)
            animation.currentPartIndex = #animation.partsReverse + 1
            for i, part in ipairs(animation.partsReverse) do
                if part.startTime < = animation.currentTime then
                    animation.currentPartIndex = i
                    break
                end
            end
        end
    end

```

### getAnimationByName

**Description**

> Returns the animation by given name

**Definition**

> getAnimationByName(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | animation | animation data |
|--------|-----------|----------------|

**Code**

```lua
function AnimatedVehicle:getAnimationByName(name)
    return self.spec_animatedVehicle.animations[name]
end

```

### getAnimationDuration

**Description**

> Returns duration of animation

**Definition**

> getAnimationDuration(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | duration | duration in ms |
|--------|----------|----------------|

**Code**

```lua
function AnimatedVehicle:getAnimationDuration(name)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        return animation.duration
    end
    return 1
end

```

### getAnimationExists

**Description**

> Returns true if animation exits

**Definition**

> getAnimationExists(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | exists | animation axists |
|--------|--------|------------------|

**Code**

```lua
function AnimatedVehicle:getAnimationExists(name)
    local spec = self.spec_animatedVehicle

    return spec.animations[name] ~ = nil
end

```

### getAnimationSpeed

**Description**

> Returns speed of animation

**Definition**

> getAnimationSpeed(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | speed | speed |
|--------|-------|-------|

**Code**

```lua
function AnimatedVehicle:getAnimationSpeed(name)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        return animation.currentSpeed
    end

    return 0
end

```

### getAnimationTime

**Description**

> Returns animation time

**Definition**

> getAnimationTime(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | animTime | animation time [0..1] |
|--------|----------|-----------------------|

**Code**

```lua
function AnimatedVehicle:getAnimationTime(name)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil and animation.duration > 0 then
        return animation.currentTime / animation.duration
    end

    return 0
end

```

### getDurationToEndOfPart

**Description**

> Returns duration to the end of current part

**Definition**

> getDurationToEndOfPart(table part, table anim)

**Arguments**

| table | part | part      |
|-------|------|-----------|
| table | anim | animation |

**Return Values**

| table | duration | duration to end of current part |
|-------|----------|---------------------------------|

**Code**

```lua
function AnimatedVehicle.getDurationToEndOfPart(part, anim)
    if anim.currentSpeed > 0 then
        return part.startTime + part.duration - anim.currentTime
    else
            return anim.currentTime - part.startTime
        end
    end

```

### getIsAnimationPlaying

**Description**

> Returns true if animation is playing

**Definition**

> getIsAnimationPlaying(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | isPlaying | animation is playing |
|--------|-----------|----------------------|

**Code**

```lua
function AnimatedVehicle:getIsAnimationPlaying(name)
    local spec = self.spec_animatedVehicle
    local animation = spec.animations[name]
    return table.hasElement(spec.activeAnimations, animation)
end

```

### getIsMovingPartActive

**Description**

**Definition**

> getIsMovingPartActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | movingPart |

**Code**

```lua
function AnimatedVehicle:getIsMovingPartActive(superFunc, movingPart)
    if movingPart.requiredAnimation ~ = nil then
        local animationTime = self:getAnimationTime(movingPart.requiredAnimation)
        if animationTime < movingPart.requiredAnimationMin or animationTime > movingPart.requiredAnimationMax then
            return false
        end
    end

    return superFunc( self , movingPart)
end

```

### getIsMovingToolActive

**Description**

**Definition**

> getIsMovingToolActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | movingTool |

**Code**

```lua
function AnimatedVehicle:getIsMovingToolActive(superFunc, movingTool)
    if movingTool.requiredAnimation ~ = nil then
        local animationTime = self:getAnimationTime(movingTool.requiredAnimation)
        if animationTime < movingTool.requiredAnimationMin or animationTime > movingTool.requiredAnimationMax then
            return false
        end
    end

    return superFunc( self , movingTool)
end

```

### getIsSpeedRotatingPartActive

**Description**

**Definition**

> getIsSpeedRotatingPartActive()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |

**Code**

```lua
function AnimatedVehicle:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    if speedRotatingPart.animName ~ = nil then
        local animTime = self:getAnimationTime(speedRotatingPart.animName)
        if speedRotatingPart.animOuterRange then
            if animTime > speedRotatingPart.animMinLimit or animTime < speedRotatingPart.animMaxLimit then
                return false
            end
        else
                if animTime > speedRotatingPart.animMaxLimit or animTime < speedRotatingPart.animMinLimit then
                    return false
                end
            end
        end

        return superFunc( self , speedRotatingPart)
    end

```

### getIsWorkAreaActive

**Description**

**Definition**

> getIsWorkAreaActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |

**Code**

```lua
function AnimatedVehicle:getIsWorkAreaActive(superFunc, workArea)
    if workArea.animName ~ = nil then
        local animTime = self:getAnimationTime(workArea.animName)
        if animTime > workArea.animMaxLimit or animTime < workArea.animMinLimit then
            return false
        end
    end

    return superFunc( self , workArea)
end

```

### getMovedLimitedValue

**Description**

> Returns moved limited value

**Definition**

> getMovedLimitedValue(float currentValue, float destValue, float speed, float dt)

**Arguments**

| float | currentValue | current value              |
|-------|--------------|----------------------------|
| float | destValue    | dest value                 |
| float | speed        | speed                      |
| float | dt           | time since last call in ms |

**Return Values**

| float | ret | limited value |
|-------|-----|---------------|

**Code**

```lua
function AnimatedVehicle.getMovedLimitedValue(currentValue, destValue, speed, dt)
    if destValue = = currentValue then
        return currentValue
    end

    -- we are moving towards -inf, we need to check for the maximum
        local limitF = destValue < currentValue and math.max or math.min
        return limitF(currentValue + speed * dt, destValue)
    end

```

### getNextPartIsPlaying

**Description**

> Get next part is playing

**Definition**

> getNextPartIsPlaying(table nextPart, table prevPart, table anim, boolean default)

**Arguments**

| table   | nextPart | next part     |
|---------|----------|---------------|
| table   | prevPart | previous part |
| table   | anim     | animation     |
| boolean | default  | default value |

**Return Values**

| boolean | isPlaying | next part is playing |
|---------|-----------|----------------------|

**Code**

```lua
function AnimatedVehicle.getNextPartIsPlaying(nextPart, prevPart, anim, default)
    if anim.currentSpeed > 0 then
        if nextPart ~ = nil then
            return nextPart.startTime > anim.currentTime
        end
    else
            if prevPart ~ = nil then
                return prevPart.startTime + prevPart.duration < anim.currentTime
            end
        end
        return default
    end

```

### getNumOfActiveAnimations

**Description**

**Definition**

> getNumOfActiveAnimations()

**Code**

```lua
function AnimatedVehicle:getNumOfActiveAnimations()
    return self.spec_animatedVehicle.numActiveAnimations
end

```

### getRealAnimationTime

**Description**

> Returns real animation time

**Definition**

> getRealAnimationTime(string name)

**Arguments**

| string | name | name of animation |
|--------|------|-------------------|

**Return Values**

| string | animTime | real animation time in ms |
|--------|----------|---------------------------|

**Code**

```lua
function AnimatedVehicle:getRealAnimationTime(name)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        return animation.currentTime
    end
    return 0
end

```

### initializeAnimationPart

**Description**

> Initialize part of animation

**Definition**

> initializeAnimationPart(table part, , , )

**Arguments**

| table | part     | part |
|-------|----------|------|
| any   | part     |      |
| any   | i        |      |
| any   | numParts |      |

**Code**

```lua
function AnimatedVehicle:initializeAnimationPart(animation, part, i, numParts)
    for index = 1 , #part.animationValues do
        part.animationValues[index]:init(i, numParts)
    end
end

```

### initializeAnimationPartAttribute

**Description**

**Definition**

> initializeAnimationPartAttribute()

**Arguments**

| any | self                   |
|-----|------------------------|
| any | animation              |
| any | part                   |
| any | i                      |
| any | numParts               |
| any | nextName               |
| any | prevName               |
| any | startName              |
| any | endName                |
| any | warningName            |
| any | startName2             |
| any | endName2               |
| any | additionalCompareParam |

**Code**

```lua
function AnimatedVehicle.initializeAnimationPartAttribute( self , animation, part, i, numParts, nextName, prevName, startName, endName, warningName, startName2, endName2, additionalCompareParam)
    -- find next part, check for overlapping, enter dependencies and set default start value if not already set
        if part[endName] ~ = nil then
            for j = i + 1 , numParts do
                local part2 = animation.parts[j]

                local additionalCompare = true
                if additionalCompareParam ~ = nil then
                    if part[additionalCompareParam] ~ = part2[additionalCompareParam] then
                        additionalCompare = false
                    end
                end

                -- check if the animations use the same range, if not they cannot collide
                    local sameRequiredRange = true
                    if part.requiredAnimation ~ = nil then
                        if part.requiredAnimation = = part2.requiredAnimation then
                            for n, v in ipairs(part.requiredAnimationRange) do
                                if part2.requiredAnimationRange[n] ~ = v then
                                    sameRequiredRange = false
                                end
                            end
                        end
                    end

                    local sameConfiguration = true
                    if part.requiredConfigurationName ~ = nil then
                        if part.requiredConfigurationName = = part2.requiredConfigurationName then
                            if part.requiredConfigurationIndex ~ = part2.requiredConfigurationIndex then
                                sameConfiguration = false
                            end
                        end
                    end

                    if part.direction = = part2.direction and part.node = = part2.node and part2[endName] ~ = nil and additionalCompare and sameRequiredRange and sameConfiguration then
                        if part.direction = = part2.direction and part.startTime + part.duration > part2.startTime + 0.001 then
                            Logging.xmlWarning( self.xmlFile, "Overlapping %s parts for node '%s' in animation '%s'" , warningName, getName(part.node), animation.name)
                            end
                            part[nextName] = part2
                            part2[prevName] = part
                            if part2[startName] = = nil then
                                part2[startName] = { unpack(part[endName]) }
                            end
                            if startName2 ~ = nil and endName2 ~ = nil then
                                if part2[startName2] = = nil then
                                    part2[startName2] = { unpack(part[endName2]) }
                                end
                            end

                            break
                        end
                    end
                end
            end

```

### initializeAnimationParts

**Description**

> Initialize parts of animation

**Definition**

> initializeAnimationParts(table animation)

**Arguments**

| table | animation | animation |
|-------|-----------|-----------|

**Code**

```lua
function AnimatedVehicle:initializeAnimationParts(animation)
    local numParts = #animation.parts

    for i, part in ipairs(animation.parts) do
        self:initializeAnimationPart(animation, part, i, numParts)
    end

    for i, part in ipairs(animation.parts) do
        self:postInitializeAnimationPart(animation, part, i, numParts)
    end
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AnimatedVehicle.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "animation" , g_i18n:getText( "shop_configuration" ), "animations" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AnimatedVehicle" )

    AnimatedVehicle.registerAnimationXMLPaths(schema, "vehicle.animations.animation(?)" )
    AnimatedVehicle.registerAnimationXMLPaths(schema, "vehicle.animations.animationConfigurations.animationConfiguration(?).animation(?)" )

    schema:register(XMLValueType.STRING, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#animName" , "Animation name" )
    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#animOuterRange" , "Anim limit outer range" , false )
    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#animMinLimit" , "Min.anim limit" , 0 )
    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#animMaxLimit" , "Max.anim limit" , 1 )

    schema:register(XMLValueType.STRING, WorkArea.WORK_AREA_XML_KEY .. "#animName" , "Animation name" )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. "#animMinLimit" , "Min.anim limit" , 0 )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. "#animMaxLimit" , "Max.anim limit" , 1 )

    schema:register(XMLValueType.STRING, WorkArea.WORK_AREA_XML_CONFIG_KEY .. "#animName" , "Animation name" )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. "#animMinLimit" , "Min.anim limit" , 0 )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. "#animMaxLimit" , "Max.anim limit" , 1 )

    schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
        cSchema:register(XMLValueType.STRING, cKey .. "#requiredAnimation" , "Name of the animation that needs to be in a certain range" )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#requiredAnimationMinTime" , "Min.time of the animation that is allowed for the movingTool update [0-1]" , 0 )
            cSchema:register(XMLValueType.FLOAT, cKey .. "#requiredAnimationMaxTime" , "Max.time of the animation that is allowed for the movingTool update [0-1]" , 1 )
            end )

            schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
                cSchema:register(XMLValueType.STRING, cKey .. "#requiredAnimation" , "Name of the animation that needs to be in a certain range" )
                cSchema:register(XMLValueType.FLOAT, cKey .. "#requiredAnimationMinTime" , "Min.time of the animation that is allowed for the movingPart update [0-1]" , 0 )
                    cSchema:register(XMLValueType.FLOAT, cKey .. "#requiredAnimationMaxTime" , "Max.time of the animation that is allowed for the movingPart update [0-1]" , 1 )
                    end )

                    schema:setXMLSpecializationType()
                end

```

### loadAnimation

**Description**

**Definition**

> loadAnimation()

**Arguments**

| any | xmlFile    |
|-----|------------|
| any | key        |
| any | animation  |
| any | components |

**Code**

```lua
function AnimatedVehicle:loadAnimation(xmlFile, key, animation, components)

    local name = xmlFile:getValue(key .. "#name" )
    if name ~ = nil then
        animation.name = name
        animation.parts = { }
        animation.currentTime = 0
        animation.previousTime = 0
        animation.currentSpeed = 1
        animation.looping = xmlFile:getValue(key .. "#looping" , false )
        animation.resetOnStart = xmlFile:getValue(key .. "#resetOnStart" , true )
        animation.soundVolumeFactor = xmlFile:getValue(key .. "#soundVolumeFactor" , 1 )
        animation.isKeyframe = xmlFile:getValue(key .. "#isKeyframe" , false )

        if animation.isKeyframe then
            animation.curvesByNode = { }
        end

        local partI = 0
        while true do
            local partKey = key .. string.format( ".part(%d)" , partI)
            if not xmlFile:hasProperty(partKey) then
                break
            end

            local animationPart = { }
            if not animation.isKeyframe then
                if self:loadAnimationPart(xmlFile, partKey, animationPart, animation, components) then
                    table.insert(animation.parts, animationPart)
                end
            else
                    self:loadStaticAnimationPart(xmlFile, partKey, animationPart, animation, components)
                end

                partI = partI + 1
            end

            -- sort parts by start/end time
            animation.partsReverse = { }
            for _, part in ipairs(animation.parts) do
                table.insert(animation.partsReverse, part)
            end
            table.sort(animation.parts, AnimatedVehicle.animPartSorter)
            table.sort(animation.partsReverse, AnimatedVehicle.animPartSorterReverse)

            self:initializeAnimationParts(animation)

            animation.currentPartIndex = 1
            animation.duration = 0
            for _, part in ipairs(animation.parts) do
                animation.duration = math.max(animation.duration, part.startTime + part.duration)
            end
            if animation.isKeyframe then
                for node, curve in pairs(animation.curvesByNode) do
                    animation.duration = math.max(animation.duration, curve.maxTime)
                end
            end

            animation.startTime = xmlFile:getValue(key .. "#startAnimTime" , 0 )
            animation.currentTime = animation.startTime * animation.duration

            if self.isClient then
                animation.samples = { }

                local i = 0
                while true do
                    local soundKey = string.format( "sound(%d)" , i)
                    local baseKey = key .. "." .. soundKey
                    if not xmlFile:hasProperty(baseKey) then
                        break
                    end

                    local sample = g_soundManager:loadSampleFromXML(xmlFile, key, soundKey, self.baseDirectory, components or self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                    if sample ~ = nil then
                        sample.startTime = xmlFile:getValue(baseKey .. "#startTime" , 0 )
                        sample.endTime = xmlFile:getValue(baseKey .. "#endTime" )
                        sample.direction = xmlFile:getValue(baseKey .. "#direction" , 0 )

                        sample.startPitchScale = xmlFile:getValue(baseKey .. "#startPitchScale" )
                        sample.endPitchScale = xmlFile:getValue(baseKey .. "#endPitchScale" )

                        if (sample.startPitchScale ~ = nil and sample.endPitchScale = = nil ) or(sample.startPitchScale = = nil and sample.endPitchScale ~ = nil ) then
                            sample.startPitchScale = nil
                            sample.endPitchScale = nil
                            Logging.xmlWarning(xmlFile, "Animation sound requires both, startPitchScale and endPitchScale, not only one. (%s)" , baseKey)
                        end

                        -- if no end time and no loop count is defined we play the sound only once
                        if sample.endTime = = nil and sample.loops = = 0 then
                            sample.loops = 1
                        end

                        g_soundManager:setSampleVolumeScale(sample, g_soundManager:getSampleVolumeScale(sample) * animation.soundVolumeFactor)

                        table.insert(animation.samples, sample)
                    end

                    i = i + 1
                end

                xmlFile:iterate(key .. ".stopTimePosSound" , function (index, _)
                    local sample = g_soundManager:loadSampleFromXML(xmlFile, key, string.format( "stopTimePosSound(%d)" , index - 1 ), self.baseDirectory, components or self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                    if sample ~ = nil then
                        animation.eventSamples = animation.eventSamples or { }
                        animation.eventSamples.stopTimePos = animation.eventSamples.stopTimePos or { }
                        table.insert(animation.eventSamples.stopTimePos, sample)
                    end
                end )

                xmlFile:iterate(key .. ".stopTimeNegSound" , function (index, _)
                    local sample = g_soundManager:loadSampleFromXML(xmlFile, key, string.format( "stopTimeNegSound(%d)" , index - 1 ), self.baseDirectory, components or self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                    if sample ~ = nil then
                        animation.eventSamples = animation.eventSamples or { }
                        animation.eventSamples.stopTimeNeg = animation.eventSamples.stopTimeNeg or { }
                        table.insert(animation.eventSamples.stopTimeNeg, sample)
                    end
                end )
            end

            return true
        end

        return false
    end

```

### loadAnimationPart

**Description**

**Definition**

> loadAnimationPart()

**Arguments**

| any | xmlFile    |
|-----|------------|
| any | partKey    |
| any | part       |
| any | animation  |
| any | components |

**Code**

```lua
function AnimatedVehicle:loadAnimationPart(xmlFile, partKey, part, animation, components)
    local startTime = xmlFile:getValue(partKey .. "#startTime" )
    local duration = xmlFile:getValue(partKey .. "#duration" )
    local endTime = xmlFile:getValue(partKey .. "#endTime" )
    local direction = math.sign(xmlFile:getValue(partKey .. "#direction" , 0 ))

    part.components = components or self.components
    part.i3dMappings = self.i3dMappings

    part.animationValues = { }

    local spec = self.spec_animatedVehicle
    for _, animationValueType in pairs(spec.animationValueTypes) do
        local animationValueObject = animationValueType.classObject.new( self , animation, part, animationValueType.startName, animationValueType.endName, animationValueType.name, animationValueType.initialUpdate, animationValueType.get, animationValueType.set, animationValueType.load)
        if animationValueObject:load(xmlFile, partKey) then
            table.insert(part.animationValues, animationValueObject)
        end
    end

    local requiredAnimation = xmlFile:getValue(partKey .. "#requiredAnimation" )
    local requiredAnimationRange = xmlFile:getValue(partKey .. "#requiredAnimationRange" , nil , true )

    local requiredConfigurationName = xmlFile:getValue(partKey .. "#requiredConfigurationName" )
    local requiredConfigurationIndex = xmlFile:getValue(partKey .. "#requiredConfigurationIndex" )

    for i = 1 , #part.animationValues do
        part.animationValues[i].requiredAnimation = requiredAnimation
        part.animationValues[i]:addCompareParameters( "requiredAnimation" )

        if requiredAnimationRange ~ = nil then
            part.animationValues[i].requiredAnimationRange = string.format( "%.2f %.2f" , requiredAnimationRange[ 1 ], requiredAnimationRange[ 2 ])
            part.animationValues[i]:addCompareParameters( "requiredAnimationRange" )
        end

        part.animationValues[i].requiredConfigurationName = requiredConfigurationName
        part.animationValues[i]:addCompareParameters( "requiredConfigurationName" )
        part.animationValues[i].requiredConfigurationIndex = requiredConfigurationIndex
        part.animationValues[i]:addCompareParameters( "requiredConfigurationIndex" )
    end

    if #part.animationValues = = 0 then
        return false
    end

    if startTime ~ = nil and(duration ~ = nil or endTime ~ = nil ) then
        if endTime ~ = nil then
            duration = endTime - startTime
        end
        part.startTime = startTime * 1000
        part.duration = duration * 1000
        part.direction = direction
        part.requiredAnimation = requiredAnimation
        part.requiredAnimationRange = requiredAnimationRange

        part.requiredConfigurationName = requiredConfigurationName
        part.requiredConfigurationIndex = requiredConfigurationIndex

        return true
    end

    return false
end

```

### loadMovingPartFromXML

**Description**

**Definition**

> loadMovingPartFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function AnimatedVehicle:loadMovingPartFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.requiredAnimation = xmlFile:getValue(key .. "#requiredAnimation" )
    if entry.requiredAnimation ~ = nil then
        entry.requiredAnimationMin = xmlFile:getValue(key .. "#requiredAnimationMinTime" , 0 )
        entry.requiredAnimationMax = xmlFile:getValue(key .. "#requiredAnimationMaxTime" , 1 )
    end

    return true
end

```

### loadMovingToolFromXML

**Description**

**Definition**

> loadMovingToolFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function AnimatedVehicle:loadMovingToolFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.requiredAnimation = xmlFile:getValue(key .. "#requiredAnimation" )
    if entry.requiredAnimation ~ = nil then
        entry.requiredAnimationMin = xmlFile:getValue(key .. "#requiredAnimationMinTime" , 0 )
        entry.requiredAnimationMax = xmlFile:getValue(key .. "#requiredAnimationMaxTime" , 1 )
    end

    return true
end

```

### loadSpeedRotatingPartFromXML

**Description**

**Definition**

> loadSpeedRotatingPartFromXML()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |
| any | xmlFile           |
| any | key               |

**Code**

```lua
function AnimatedVehicle:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.animName = xmlFile:getValue(key .. "#animName" )
    speedRotatingPart.animOuterRange = xmlFile:getValue(key .. "#animOuterRange" , false )
    speedRotatingPart.animMinLimit = xmlFile:getValue(key .. "#animMinLimit" , 0 )
    speedRotatingPart.animMaxLimit = xmlFile:getValue(key .. "#animMaxLimit" , 1 )

    return true
end

```

### loadStaticAnimationPart

**Description**

**Definition**

> loadStaticAnimationPart()

**Arguments**

| any | xmlFile    |
|-----|------------|
| any | partKey    |
| any | part       |
| any | animation  |
| any | components |

**Code**

```lua
function AnimatedVehicle:loadStaticAnimationPart(xmlFile, partKey, part, animation, components)
    local node = xmlFile:getValue(partKey .. "#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        local time = xmlFile:getValue(partKey .. "#time" )
        local startTime = xmlFile:getValue(partKey .. "#startTime" )
        local endTime = xmlFile:getValue(partKey .. "#endTime" )

        if animation.curvesByNode[node] = = nil then
            animation.curvesByNode[node] = AnimCurve.new(linearInterpolatorTransRotScale)
        end

        local curve = animation.curvesByNode[node]

        if time ~ = nil then
            self:loadStaticAnimationPartValues(xmlFile, partKey, curve, node, "translation" , "rotation" , "scale" , time * 1000 , animation)
        elseif startTime ~ = nil or endTime ~ = nil then
                if startTime ~ = nil then
                    startTime = startTime * 1000
                    if curve.maxTime = = 0 or curve.maxTime ~ = startTime then
                        self:loadStaticAnimationPartValues(xmlFile, partKey, curve, node, "startTrans" , "startRot" , "startScale" , startTime, animation)
                    end
                end
                if endTime ~ = nil then
                endTime = endTime * 1000
                if curve.maxTime = = 0 or curve.maxTime ~ = endTime then
                    self:loadStaticAnimationPartValues(xmlFile, partKey, curve, node, "endTrans" , "endRot" , "endScale" , endTime, animation)
                end
            end
        end

        --#debug local spec = self.spec_animatedVehicle
        --#debug for _, animationValueType in pairs(spec.animationValueTypes) do
            --#debug if animationValueType.name ~ = "translation" and animationValueType.name ~ = "rotation" and animationValueType.name ~ = "scale" then
                --#debug if animationValueType.startName ~ = "" and xmlFile:getString(partKey .. "#" .. animationValueType.startName) ~ = nil then
                    --#debug Logging.xmlWarning(xmlFile, "Keyframe animations only support translation, rotation and scale values! '%s'", partKey .. "#" .. animationValueType.startName)
                    --#debug end
                    --#debug
                    --#debug if animationValueType.endName ~ = "" and xmlFile:getString(partKey .. "#" .. animationValueType.endName) ~ = nil then
                        --#debug Logging.xmlWarning(xmlFile, "Keyframe animations only support translation, rotation and scale values! '%s'", partKey .. "#" .. animationValueType.endName)
                        --#debug end
                        --#debug end
                        --#debug end
                        --#debug
                        --#debug if xmlFile:getValue(partKey .. "#direction", nil) ~ = nil then
                            --#debug Logging.xmlWarning(xmlFile, "Keyframe animations do not support the direction attribute! '%s'", partKey)
                                --#debug end
                                --#debug
                                --#debug if xmlFile:getValue(partKey .. "#duration", nil) ~ = nil then
                                    --#debug Logging.xmlWarning(xmlFile, "Keyframe animations do not support the duration attribute! '%s'", partKey)
                                        --#debug end

                                        return true
                                    end

                                    return false
                                end

```

### loadStaticAnimationPartValues

**Description**

**Definition**

> loadStaticAnimationPartValues()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | partKey   |
| any | curve     |
| any | node      |
| any | transName |
| any | rotName   |
| any | scaleName |
| any | time      |
| any | animation |

**Code**

```lua
function AnimatedVehicle:loadStaticAnimationPartValues(xmlFile, partKey, curve, node, transName, rotName, scaleName, time , animation)
    local hasTranslation, hasRotation, hasScale = false , false , false

    local x, y, z = xmlFile:getValue(partKey .. "#" .. transName)
    if x = = nil then
        x, y, z = getTranslation(node)
    else
            hasTranslation = true
        end

        local rx, ry, rz = xmlFile:getValue(partKey .. "#" .. rotName)
        if rx = = nil then
            rx, ry, rz = getRotation(node)
        else
                hasRotation = true
            end

            local sx, sy, sz = xmlFile:getValue(partKey .. "#" .. scaleName)
            if sx = = nil then
                sx, sy, sz = getScale(node)
            else
                    hasScale = true
                end

                if hasTranslation or hasRotation or hasScale then
                    if curve.hasTranslation = = nil or curve.hasRotation = = nil or curve.hasScale = = nil then
                        curve.hasTranslation = hasTranslation
                        curve.hasRotation = hasRotation
                        curve.hasScale = hasScale
                    else
                            if curve.hasTranslation ~ = hasTranslation
                                or curve.hasRotation ~ = hasRotation
                                or curve.hasScale ~ = hasScale then
                                Logging.xmlWarning(xmlFile, "All animation parts for node '%s' require the same attributes(translation/rotation/scale) in animation '%s'! '%s'" , getName(node), animation.name, partKey)
                                end
                            end
                        end

                        curve:addKeyframe( { x = x, y = y, z = z, rx = rx, ry = ry, rz = rz, sx = sx, sy = sy, sz = sz, time = time } )
                    end

```

### loadWorkAreaFromXML

**Description**

**Definition**

> loadWorkAreaFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function AnimatedVehicle:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    workArea.animName = xmlFile:getValue(key .. "#animName" )
    workArea.animMinLimit = xmlFile:getValue(key .. "#animMinLimit" , 0 )
    workArea.animMaxLimit = xmlFile:getValue(key .. "#animMaxLimit" , 1 )

    return superFunc( self , workArea, xmlFile, key)
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function AnimatedVehicle:onDelete()
    local spec = self.spec_animatedVehicle
    if self.isClient and spec.animations ~ = nil then
        for _, animation in pairs(spec.animations) do
            g_soundManager:deleteSamples(animation.samples)
            if animation.eventSamples ~ = nil then
                g_soundManager:deleteSamples(animation.eventSamples.stopTimePos)
                g_soundManager:deleteSamples(animation.eventSamples.stopTimeNeg)
            end
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
function AnimatedVehicle:onLoad(savegame)
    local spec = self.spec_animatedVehicle

    spec.animations = { }

    for _, key in self.xmlFile:iterator( "vehicle.animations.animation" ) do
        local animation = { }
        if self:loadAnimation( self.xmlFile, key, animation) then
            spec.animations[animation.name] = animation
        end
    end

    local configurationId = self.configurations[ "animation" ] or 1
    local configKey = string.format( "vehicle.animations.animationConfigurations.animationConfiguration(%d)" , configurationId - 1 )

    if self.xmlFile:hasProperty(configKey) then
        for _, key in self.xmlFile:iterator(configKey .. ".animation" ) do
            local animation = { }
            if self:loadAnimation( self.xmlFile, key, animation) then
                spec.animations[animation.name] = animation
            end
        end
    end

    spec.activeAnimations = { }
    spec.numActiveAnimations = 0
    spec.fixedTimeSamplesDirtyDelay = 0
end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function AnimatedVehicle:onPostLoad(savegame)
    local spec = self.spec_animatedVehicle
    for name, animation in pairs(spec.animations) do
        if animation.resetOnStart then
            self:setAnimationTime(name, 1 , true , false )
            self:setAnimationStopTime(name, animation.startTime)
            self:playAnimation(name, - 1 , 1 , true , false )
            AnimatedVehicle.updateAnimationByName( self , name, 9999999 , true )
        end
    end

    if next(spec.animations) = = nil then
        SpecializationUtil.removeEventListener( self , "onUpdate" , AnimatedVehicle )
    end
end

```

### onPreLoad

**Description**

> Called on pre loading

**Definition**

> onPreLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function AnimatedVehicle:onPreLoad(savegame)
    local spec = self.spec_animatedVehicle
    spec.animationValueTypes = { }

    SpecializationUtil.raiseEvent( self , "onRegisterAnimationValueTypes" )
end

```

### onRegisterAnimationValueTypes

**Description**

> Called on pre load to register animation value types

**Definition**

> onRegisterAnimationValueTypes()

**Code**

```lua
function AnimatedVehicle:onRegisterAnimationValueTypes()
    local loadNodeFunction = function (value, xmlFile, xmlKey)
        value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)

        if value.node ~ = nil then
            value:setWarningInformation( "node: " .. getName(value.node))
            value:addCompareParameters( "node" )

            return true
        end

        return false
    end

    self:registerAnimationValueType( "rotation" , "startRot" , "endRot" , false , AnimationValueFloat , loadNodeFunction,
    function (value)
        return getRotation(value.node)
    end ,

    function (value, .. .)
        setRotation(value.node, .. .)

        SpecializationUtil.raiseEvent( self , "onAnimationPartChanged" , value.node)
    end )

    self:registerAnimationValueType( "translation" , "startTrans" , "endTrans" , false , AnimationValueFloat , loadNodeFunction,
    function (value)
        return getTranslation(value.node)
    end ,

    function (value, .. .)
        setTranslation(value.node, .. .)

        SpecializationUtil.raiseEvent( self , "onAnimationPartChanged" , value.node)
    end )

    self:registerAnimationValueType( "scale" , "startScale" , "endScale" , false , AnimationValueFloat , loadNodeFunction,
    function (value)
        return getScale(value.node)
    end ,

    function (value, .. .)
        setScale(value.node, .. .)

        SpecializationUtil.raiseEvent( self , "onAnimationPartChanged" , value.node)
    end )

    local updateShaderParameterMask = function (xmlFile, xmlKey, mask)
        local customMask = false
        local rawValues = xmlFile:getValue(xmlKey)
        if rawValues ~ = nil then
            for i = 1 , #rawValues do
                if rawValues[i] = = "-" then
                    mask[i] = 0
                    customMask = true
                end
            end
        end

        return customMask
    end

    self:registerAnimationValueType( "shaderParameter" , "shaderStartValues" , "shaderEndValues" , false , AnimationValueFloat ,
    function (value, xmlFile, xmlKey)
        value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)
        value.shaderParameter = xmlFile:getValue(xmlKey .. "#shaderParameter" )
        value.shaderParameterPrev = xmlFile:getValue(xmlKey .. "#shaderParameterPrev" )

        if value.node ~ = nil and value.shaderParameter ~ = nil then
            if getHasClassId(value.node, ClassIds.SHAPE) and getHasShaderParameter(value.node, value.shaderParameter) then
                value:setWarningInformation( "node: " .. getName(value.node) .. "with shaderParam: " .. value.shaderParameter)
                value:addCompareParameters( "node" , "shaderParameter" )

                value.shaderParameterMask = { 1 , 1 , 1 , 1 }
                value.customShaderParameterMask = updateShaderParameterMask(xmlFile, xmlKey .. "#shaderStartValues" , value.shaderParameterMask)
                value.customShaderParameterMask = updateShaderParameterMask(xmlFile, xmlKey .. "#shaderEndValues" , value.shaderParameterMask) or value.customShaderParameterMask

                if value.shaderParameterPrev ~ = nil then
                    if not getHasShaderParameter(value.node, value.shaderParameterPrev) then
                        Logging.xmlWarning(xmlFile, "Node '%s' has no shaderParameterPrev '%s' for animation part '%s'!" , getName(value.node), value.shaderParameterPrev, xmlKey)
                            return false
                        end
                    else
                            local prevName = "prev" .. string.upper( string.sub(value.shaderParameter, 1 , 1 )) .. string.sub(value.shaderParameter, 2 ) -- uppercase first letter of parameter name
                            if getHasShaderParameter(value.node, prevName) then
                                value.shaderParameterPrev = prevName
                            end
                        end

                        return true
                    else
                            Logging.xmlWarning(xmlFile, "Node '%s' has no shaderParameter '%s' for animation part '%s'!" , getName(value.node), value.shaderParameter, xmlKey)
                            end
                        end

                        return false
                    end ,

                    function (value)
                        return getShaderParameter(value.node, value.shaderParameter)
                    end ,

                    function (value, x, y, z, w)
                        if value.customShaderParameterMask then
                            if value.shaderParameterMask[ 1 ] = = 0 then x = nil end
                            if value.shaderParameterMask[ 2 ] = = 0 then y = nil end
                            if value.shaderParameterMask[ 3 ] = = 0 then z = nil end
                            if value.shaderParameterMask[ 4 ] = = 0 then w = nil end
                        end

                        if value.shaderParameterPrev ~ = nil then
                            g_animationManager:setPrevShaderParameter(value.node, value.shaderParameter, x, y, z, w, false , value.shaderParameterPrev)
                        else
                                setShaderParameter(value.node, value.shaderParameter, x, y, z, w, false )
                            end
                        end )

                        self:registerAnimationValueType( "visibility" , "visibility" , "" , false , AnimationValueBool , loadNodeFunction,
                        function (value)
                            return getVisibility(value.node)
                        end ,

                        function (value, .. .)
                            setVisibility(value.node, .. .)
                        end )

                        self:registerAnimationValueType( "visibilityInter" , "startVisibility" , "endVisibility" , false , AnimationValueFloat ,
                        function (value, xmlFile, xmlKey)
                            value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)
                            if value.node ~ = nil and value.startValue ~ = nil and value.endValue ~ = nil then
                                value:setWarningInformation( "node: " .. getName(value.node))
                                value:addCompareParameters( "node" )

                                return true
                            end

                            return false
                        end ,
                        function (value)
                            if value.lastVisibilityValue ~ = nil then
                                return value.lastVisibilityValue
                            end

                            return getVisibility(value.node) and 1 or 0
                        end ,

                        function (value, visibility)
                            value.lastVisibilityValue = visibility
                            setVisibility(value.node, visibility > = 0.5 )
                        end )

                        self:registerAnimationValueType( "animationClip" , "clipStartTime" , "clipEndTime" , true , AnimationValueFloat ,
                        function (value, xmlFile, xmlKey)
                            value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)
                            value.animationClip = xmlFile:getValue(xmlKey .. "#animationClip" )

                            if value.node ~ = nil and value.animationClip ~ = nil then
                                value.animationCharSet = getAnimCharacterSet(value.node)
                                if value.animationCharSet ~ = 0 then
                                    value.animationClipIndex = getAnimClipIndex(value.animationCharSet, value.animationClip)

                                    value:setWarningInformation( "node: " .. getName(value.node) .. "with animationClip: " .. value.animationClip)
                                    value:addCompareParameters( "node" , "animationClip" )

                                    return true
                                else
                                        Logging.xmlWarning(xmlFile, "Unable to find animation clip '%s' on node '%s' in '%s'" , value.animationClip, getName(value.node), xmlKey)
                                    end
                                end

                                return false
                            end ,

                            function (value)
                                local oldClipIndex = getAnimTrackAssignedClip(value.animationCharSet, 0 )
                                clearAnimTrackClip(value.animationCharSet, 0 )
                                assignAnimTrackClip(value.animationCharSet, 0 , value.animationClipIndex)

                                if oldClipIndex = = value.animationClipIndex then
                                    return getAnimTrackTime(value.animationCharSet, 0 )
                                end

                                local startTime = value.startValue or value.endValue
                                if value.animation.currentSpeed < 0 then
                                    startTime = value.endValue or value.startValue
                                end

                                return startTime[ 1 ]
                            end ,

                            function (value, time )
                                local oldClipIndex = getAnimTrackAssignedClip(value.animationCharSet, 0 )
                                if oldClipIndex ~ = value.animationClipIndex then
                                    clearAnimTrackClip(value.animationCharSet, 0 )
                                    assignAnimTrackClip(value.animationCharSet, 0 , value.animationClipIndex)
                                end

                                enableAnimTrack(value.animationCharSet, 0 )
                                setAnimTrackTime(value.animationCharSet, 0 , time , true )
                                disableAnimTrack(value.animationCharSet, 0 )
                            end )

                            self:registerAnimationValueType( "dependentAnimation" , "dependentAnimationStartTime" , "dependentAnimationEndTime" , true , AnimationValueFloat ,
                            function (value, xmlFile, xmlKey)
                                value.dependentAnimation = xmlFile:getValue(xmlKey .. "#dependentAnimation" )

                                if value.dependentAnimation ~ = nil then
                                    value:setWarningInformation( "dependentAnimation: " .. value.dependentAnimation)
                                    value:addCompareParameters( "dependentAnimation" )

                                    return true
                                end

                                return false
                            end ,

                            function (value)
                                return value.vehicle:getAnimationTime(value.dependentAnimation)
                            end ,

                            function (value, time )
                                value.vehicle:setAnimationTime(value.dependentAnimation, time , true )
                            end )

                            if self.isServer then
                                self:registerAnimationValueType( "rotLimit" , "" , "" , false , AnimationValueFloat ,
                                function (value, xmlFile, xmlKey)
                                    value.startRotLimit = xmlFile:getValue(xmlKey .. "#startRotLimit" , nil , true )
                                    value.startRotMinLimit = xmlFile:getValue(xmlKey .. "#startRotMinLimit" , nil , true )
                                    value.startRotMaxLimit = xmlFile:getValue(xmlKey .. "#startRotMaxLimit" , nil , true )

                                    if value.startRotLimit ~ = nil then
                                        if value.startRotMinLimit ~ = nil then
                                            Logging.xmlWarning(xmlFile, "Invalid rotLimit definition. 'startRotMinLimit' defined but overwritten by defined 'startRotLimit'! (%s)" , xmlKey)
                                        end
                                        if value.startRotMaxLimit ~ = nil then
                                            Logging.xmlWarning(xmlFile, "Invalid rotLimit definition. 'startRotMaxLimit' defined but overwritten by defined 'startRotLimit'! (%s)" , xmlKey)
                                        end

                                        value.startRotMinLimit = { - value.startRotLimit[ 1 ], - value.startRotLimit[ 2 ], - value.startRotLimit[ 3 ] }
                                        value.startRotMaxLimit = { value.startRotLimit[ 1 ], value.startRotLimit[ 2 ], value.startRotLimit[ 3 ] }
                                    end

                                    value.endRotLimit = xmlFile:getValue(xmlKey .. "#endRotLimit" , nil , true )
                                    value.endRotMinLimit = xmlFile:getValue(xmlKey .. "#endRotMinLimit" , nil , true )
                                    value.endRotMaxLimit = xmlFile:getValue(xmlKey .. "#endRotMaxLimit" , nil , true )

                                    if value.endRotLimit ~ = nil then
                                        if value.endRotMinLimit ~ = nil then
                                            Logging.xmlWarning(xmlFile, "Invalid rotLimit definition. 'endRotMinLimit' defined but overwritten by defined 'endRotLimit'! (%s)" , xmlKey)
                                        end
                                        if value.endRotMaxLimit ~ = nil then
                                            Logging.xmlWarning(xmlFile, "Invalid rotLimit definition. 'endRotMaxLimit' defined but overwritten by defined 'endRotLimit'! (%s)" , xmlKey)
                                        end

                                        value.endRotMinLimit = { - value.endRotLimit[ 1 ], - value.endRotLimit[ 2 ], - value.endRotLimit[ 3 ] }
                                        value.endRotMaxLimit = { value.endRotLimit[ 1 ], value.endRotLimit[ 2 ], value.endRotLimit[ 3 ] }
                                    end

                                    local componentJointIndex = xmlFile:getValue(xmlKey .. "#componentJointIndex" )
                                    if componentJointIndex ~ = nil then
                                        if componentJointIndex > = 1 then
                                            value.componentJoint = value.vehicle.componentJoints[componentJointIndex]
                                        end

                                        if value.componentJoint = = nil then
                                            Logging.xmlWarning(xmlFile, "Invalid componentJointIndex for animation part '%s'.Indexing starts with 1!" , xmlKey)
                                                return false
                                            end
                                        end

                                        if (value.endRotMinLimit ~ = nil and value.endRotMaxLimit = = nil ) or(value.endRotMinLimit = = nil and value.endRotMaxLimit ~ = nil ) then
                                            Logging.xmlWarning(xmlFile, "Incomplete end trans limit for animation part '%s'." , xmlKey)
                                            return false
                                        end

                                        if value.componentJoint ~ = nil and value.endRotMinLimit ~ = nil and value.endRotMaxLimit ~ = nil then
                                            if value.startRotMinLimit ~ = nil and value.startRotMaxLimit ~ = nil then
                                                value.startValue = { value.startRotMinLimit[ 1 ], value.startRotMinLimit[ 2 ], value.startRotMinLimit[ 3 ], value.startRotMaxLimit[ 1 ], value.startRotMaxLimit[ 2 ], value.startRotMaxLimit[ 3 ] }
                                            end
                                            if value.endRotMinLimit ~ = nil and value.endRotMaxLimit ~ = nil then
                                                value.endValue = { value.endRotMinLimit[ 1 ], value.endRotMinLimit[ 2 ], value.endRotMinLimit[ 3 ], value.endRotMaxLimit[ 1 ], value.endRotMaxLimit[ 2 ], value.endRotMaxLimit[ 3 ] }
                                            end

                                            if value.endValue = = nil then
                                                Logging.xmlWarning(xmlFile, "Missing end rot limit for animation part '%s'." , xmlKey)
                                                return false
                                            end

                                            value.endName = "rotLimit" -- only for comparing parts
                                                value:setWarningInformation( "componentJointIndex: " .. componentJointIndex)
                                                value:addCompareParameters( "componentJoint" )

                                                return true
                                            end

                                            return false
                                        end ,

                                        function (value)
                                            return value.componentJoint.rotMinLimit[ 1 ], value.componentJoint.rotMinLimit[ 2 ], value.componentJoint.rotMinLimit[ 3 ], value.componentJoint.rotLimit[ 1 ], value.componentJoint.rotLimit[ 2 ], value.componentJoint.rotLimit[ 3 ]
                                        end ,

                                        function (value, minX, minY, minZ, maxX, maxY, maxZ)
                                            value.vehicle:setComponentJointRotLimit(value.componentJoint, 1 , minX, maxX)
                                            value.vehicle:setComponentJointRotLimit(value.componentJoint, 2 , minY, maxY)
                                            value.vehicle:setComponentJointRotLimit(value.componentJoint, 3 , minZ, maxZ)
                                        end )

                                        self:registerAnimationValueType( "transLimit" , "" , "" , false , AnimationValueFloat ,
                                        function (value, xmlFile, xmlKey)
                                            value.startTransLimit = xmlFile:getValue(xmlKey .. "#startTransLimit" , nil , true )
                                            value.startTransMinLimit = xmlFile:getValue(xmlKey .. "#startTransMinLimit" , nil , true )
                                            value.startTransMaxLimit = xmlFile:getValue(xmlKey .. "#startTransMaxLimit" , nil , true )

                                            if value.startTransLimit ~ = nil then
                                                if value.startTransMinLimit ~ = nil then
                                                    Logging.xmlWarning(xmlFile, "Invalid transLimit definition. 'startTransMinLimit' defined but overwritten by defined 'startTransLimit'! (%s)" , xmlKey)
                                                end
                                                if value.startTransMaxLimit ~ = nil then
                                                    Logging.xmlWarning(xmlFile, "Invalid transLimit definition. 'startTransMaxLimit' defined but overwritten by defined 'startTransLimit'! (%s)" , xmlKey)
                                                end

                                                value.startTransMinLimit = { - value.startTransLimit[ 1 ], - value.startTransLimit[ 2 ], - value.startTransLimit[ 3 ] }
                                                value.startTransMaxLimit = { value.startTransLimit[ 1 ], value.startTransLimit[ 2 ], value.startTransLimit[ 3 ] }
                                            end

                                            value.endTransLimit = xmlFile:getValue(xmlKey .. "#endTransLimit" , nil , true )
                                            value.endTransMinLimit = xmlFile:getValue(xmlKey .. "#endTransMinLimit" , nil , true )
                                            value.endTransMaxLimit = xmlFile:getValue(xmlKey .. "#endTransMaxLimit" , nil , true )

                                            if value.endTransLimit ~ = nil then
                                                if value.endTransMinLimit ~ = nil then
                                                    Logging.xmlWarning(xmlFile, "Invalid transLimit definition. 'endTransMinLimit' defined but overwritten by defined 'endTransLimit'! (%s)" , xmlKey)
                                                end
                                                if value.endTransMaxLimit ~ = nil then
                                                    Logging.xmlWarning(xmlFile, "Invalid transLimit definition. 'endTransMaxLimit' defined but overwritten by defined 'endTransLimit'! (%s)" , xmlKey)
                                                end

                                                value.endTransMinLimit = { - value.endTransLimit[ 1 ], - value.endTransLimit[ 2 ], - value.endTransLimit[ 3 ] }
                                                value.endTransMaxLimit = { value.endTransLimit[ 1 ], value.endTransLimit[ 2 ], value.endTransLimit[ 3 ] }
                                            end

                                            local componentJointIndex = xmlFile:getValue(xmlKey .. "#componentJointIndex" )
                                            if componentJointIndex ~ = nil then
                                                if componentJointIndex > = 1 then
                                                    value.componentJoint = value.vehicle.componentJoints[componentJointIndex]
                                                end

                                                if value.componentJoint = = nil then
                                                    Logging.xmlWarning(xmlFile, "Invalid componentJointIndex for animation part '%s'.Indexing starts with 1!" , xmlKey)
                                                        return false
                                                    end
                                                end

                                                if (value.endTransMinLimit ~ = nil and value.endTransMaxLimit = = nil ) or(value.endTransMinLimit = = nil and value.endTransMaxLimit ~ = nil ) then
                                                    Logging.xmlWarning(xmlFile, "Incomplete end trans limit for animation part '%s'." , xmlKey)
                                                    return false
                                                end

                                                if value.componentJoint ~ = nil and value.endTransMinLimit ~ = nil and value.endTransMaxLimit ~ = nil then
                                                    if value.startTransMinLimit ~ = nil and value.startTransMaxLimit ~ = nil then
                                                        value.startValue = { value.startTransMinLimit[ 1 ], value.startTransMinLimit[ 2 ], value.startTransMinLimit[ 3 ], value.startTransMaxLimit[ 1 ], value.startTransMaxLimit[ 2 ], value.startTransMaxLimit[ 3 ] }
                                                    end
                                                    if value.endTransMinLimit ~ = nil and value.endTransMaxLimit ~ = nil then
                                                        value.endValue = { value.endTransMinLimit[ 1 ], value.endTransMinLimit[ 2 ], value.endTransMinLimit[ 3 ], value.endTransMaxLimit[ 1 ], value.endTransMaxLimit[ 2 ], value.endTransMaxLimit[ 3 ] }
                                                    end

                                                    if value.endValue = = nil then
                                                        Logging.xmlWarning(xmlFile, "Missing end trans limit for animation part '%s'." , xmlKey)
                                                        return false
                                                    end

                                                    value.endName = "transLimit" -- only for comparing parts
                                                        value:setWarningInformation( "componentJointIndex: " .. componentJointIndex)
                                                        value:addCompareParameters( "componentJoint" )

                                                        return true
                                                    end

                                                    return false
                                                end ,

                                                function (value)
                                                    return value.componentJoint.transMinLimit[ 1 ], value.componentJoint.transMinLimit[ 2 ], value.componentJoint.transMinLimit[ 3 ], value.componentJoint.transLimit[ 1 ], value.componentJoint.transLimit[ 2 ], value.componentJoint.transLimit[ 3 ]
                                                end ,

                                                function (value, minX, minY, minZ, maxX, maxY, maxZ)
                                                    value.vehicle:setComponentJointTransLimit(value.componentJoint, 1 , minX, maxX)
                                                    value.vehicle:setComponentJointTransLimit(value.componentJoint, 2 , minY, maxY)
                                                    value.vehicle:setComponentJointTransLimit(value.componentJoint, 3 , minZ, maxZ)
                                                end )

                                                self:registerAnimationValueType( "rotationLimitSpring" , "" , "" , false , AnimationValueFloat ,
                                                function (value, xmlFile, xmlKey)
                                                    value.startRotLimitSpring = xmlFile:getValue(xmlKey .. "#startRotLimitSpring" , nil , true )
                                                    value.startRotLimitDamping = xmlFile:getValue(xmlKey .. "#startRotLimitDamping" , nil , true )

                                                    value.endRotLimitSpring = xmlFile:getValue(xmlKey .. "#endRotLimitSpring" , nil , true )
                                                    value.endRotLimitDamping = xmlFile:getValue(xmlKey .. "#endRotLimitDamping" , nil , true )

                                                    local componentJointIndex = xmlFile:getValue(xmlKey .. "#componentJointIndex" )
                                                    if componentJointIndex ~ = nil then
                                                        if componentJointIndex > = 1 then
                                                            value.componentJoint = value.vehicle.componentJoints[componentJointIndex]
                                                        end

                                                        if value.componentJoint = = nil then
                                                            Logging.xmlWarning(xmlFile, "Invalid componentJointIndex for animation part '%s'.Indexing starts with 1!" , xmlKey)
                                                                return false
                                                            end
                                                        end

                                                        if value.componentJoint ~ = nil and(value.endRotLimitSpring ~ = nil or value.startRotLimitDamping ~ = nil ) then
                                                            if value.startRotLimitSpring ~ = nil and value.startRotLimitDamping ~ = nil then
                                                                value.startValue = { value.startRotLimitSpring[ 1 ], value.startRotLimitSpring[ 2 ], value.startRotLimitSpring[ 3 ], value.startRotLimitDamping[ 1 ], value.startRotLimitDamping[ 2 ], value.startRotLimitDamping[ 3 ] }
                                                            end
                                                            if value.endRotLimitSpring ~ = nil and value.endRotLimitDamping ~ = nil then
                                                                value.endValue = { value.endRotLimitSpring[ 1 ], value.endRotLimitSpring[ 2 ], value.endRotLimitSpring[ 3 ], value.endRotLimitDamping[ 1 ], value.endRotLimitDamping[ 2 ], value.endRotLimitDamping[ 3 ] }
                                                            end

                                                            if value.endValue = = nil then
                                                                Logging.xmlWarning(xmlFile, "Missing 'endRotLimitSpring' or 'endRotLimitDamping' for animation part '%s'." , xmlKey)
                                                                    return false
                                                                end

                                                                value.endName = "rotationLimitSpring" -- only for comparing parts
                                                                    value:setWarningInformation( "componentJointIndex: " .. componentJointIndex)
                                                                    value:addCompareParameters( "componentJoint" )

                                                                    return true
                                                                end

                                                                return false
                                                            end ,

                                                            function (value)
                                                                return value.componentJoint.rotLimitSpring[ 1 ], value.componentJoint.rotLimitSpring[ 2 ], value.componentJoint.rotLimitSpring[ 3 ], value.componentJoint.rotLimitDamping[ 1 ], value.componentJoint.rotLimitDamping[ 2 ], value.componentJoint.rotLimitDamping[ 3 ]
                                                            end ,

                                                            function (value, spring1, spring2, spring3, damping1, damping2, damping3)
                                                                value.componentJoint.rotLimitSpring[ 1 ], value.componentJoint.rotLimitSpring[ 2 ], value.componentJoint.rotLimitSpring[ 3 ] = spring1, spring2, spring3
                                                                value.componentJoint.rotLimitDamping[ 1 ], value.componentJoint.rotLimitDamping[ 2 ], value.componentJoint.rotLimitDamping[ 3 ] = damping1, damping2, damping3
                                                                if value.componentJoint.jointIndex ~ = nil then
                                                                    for i = 1 , 3 do
                                                                        setJointRotationLimitSpring(value.componentJoint.jointIndex, i - 1 , value.componentJoint.rotLimitSpring[i], value.componentJoint.rotLimitDamping[i])
                                                                    end
                                                                end
                                                            end )

                                                            self:registerAnimationValueType( "componentMass" , "startMass" , "endMass" , false , AnimationValueFloat ,
                                                            function (value, xmlFile, xmlKey)
                                                                local componentIndex = xmlFile:getValue(xmlKey .. "#componentIndex" )
                                                                if componentIndex ~ = nil then
                                                                    if componentIndex > = 1 then
                                                                        value.component = value.vehicle.components[componentIndex]
                                                                    end

                                                                    if value.component = = nil then
                                                                        Logging.xmlWarning(xmlFile, "Invalid component for animation part '%s'.Indexing starts with 1!" , xmlKey)
                                                                            return false
                                                                        end
                                                                    end

                                                                    if value.component ~ = nil then
                                                                        value:setWarningInformation( "componentIndex: " .. componentIndex)
                                                                        value:addCompareParameters( "component" )

                                                                        return true
                                                                    end

                                                                    return false
                                                                end ,

                                                                function (value)
                                                                    return getMass(value.component.node) * 1000
                                                                end ,

                                                                function (value, mass)
                                                                    setMass(value.component.node, mass * 0.001 )
                                                                end )

                                                                self:registerAnimationValueType( "centerOfMass" , "startCenterOfMass" , "endCenterOfMass" , false , AnimationValueFloat ,
                                                                function (value, xmlFile, xmlKey)
                                                                    local componentIndex = xmlFile:getValue(xmlKey .. "#componentIndex" )
                                                                    if componentIndex ~ = nil then
                                                                        if componentIndex > = 1 then
                                                                            value.component = value.vehicle.components[componentIndex]
                                                                        end

                                                                        if value.component = = nil then
                                                                            Logging.xmlWarning(xmlFile, "Invalid component for animation part '%s'.Indexing starts with 1!" , xmlKey)
                                                                                return false
                                                                            end
                                                                        end

                                                                        if value.component ~ = nil then
                                                                            value:setWarningInformation( "componentIndex: " .. componentIndex)
                                                                            value:addCompareParameters( "component" )

                                                                            return true
                                                                        end

                                                                        return false
                                                                    end ,

                                                                    function (value)
                                                                        return getCenterOfMass(value.component.node)
                                                                    end ,

                                                                    function (value, x, y, z)
                                                                        setCenterOfMass(value.component.node, x, y, z)
                                                                    end )

                                                                    self:registerAnimationValueType( "frictionVelocity" , "startFrictionVelocity" , "endFrictionVelocity" , false , AnimationValueFloat , loadNodeFunction,
                                                                    function (value)
                                                                        return value.lastFrictionVelocity or 0
                                                                    end ,

                                                                    function (value, velocity)
                                                                        setFrictionVelocity(value.node, velocity)
                                                                        value.lastFrictionVelocity = velocity

                                                                        if value.origTransX = = nil then
                                                                            value.origTransX, value.origTransY, value.origTransZ = getTranslation(value.node)
                                                                        end
                                                                        setTranslation(value.node, value.origTransX + math.random() * 0.001 , value.origTransY, value.origTransZ)
                                                                    end )
                                                                end

                                                                self:registerAnimationValueType( "spline" , "startSplinePos" , "endSplinePos" , false , AnimationValueFloat ,
                                                                function (value, xmlFile, xmlKey)
                                                                    value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)
                                                                    value.spline = xmlFile:getValue(xmlKey .. "#spline" , nil , value.part.components, value.part.i3dMappings)

                                                                    if value.node ~ = nil and value.spline ~ = nil then
                                                                        value:setWarningInformation( "node:" .. getName(value.node) .. " with spline: " .. getName(value.spline))
                                                                        value:addCompareParameters( "node" , "spline" )

                                                                        return true
                                                                    end

                                                                    return false
                                                                end ,

                                                                function (value)
                                                                    if value.lastSplineTime ~ = nil then
                                                                        return value.lastSplineTime
                                                                    end

                                                                    local startTime = value.startValue or value.endValue
                                                                    if value.animation.currentSpeed < 0 then
                                                                        startTime = value.endValue or value.startValue
                                                                    end

                                                                    return startTime[ 1 ]
                                                                end ,

                                                                function (value, splineTime)
                                                                    local x, y, z = getSplinePosition(value.spline, splineTime % 1 )
                                                                    x, y, z = worldToLocal(getParent(value.node), x, y, z)
                                                                    setTranslation(value.node, x, y, z)

                                                                    value.lastSplineTime = splineTime

                                                                    for _, part2 in ipairs(value.animation.parts) do
                                                                        for index = 1 , #part2.animationValues do
                                                                            local value2 = part2.animationValues[index]
                                                                            if value2.node = = value.node then
                                                                                if value2.name = = value.name then
                                                                                    value2.lastSplineTime = splineTime
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end )

                                                                self:registerAnimationValueType( "rollingGate" , "startGatePos" , "endGatePos" , false , AnimationValueFloat ,
                                                                function (value, xmlFile, xmlKey)
                                                                    if xmlFile:hasProperty(xmlKey .. ".rollingGateAnimation" ) then
                                                                        local rollingGate = RollingGateAnimation.new()
                                                                        if rollingGate:load(xmlFile, xmlKey .. ".rollingGateAnimation" , value.part.components, value.part.i3dMappings) then
                                                                            value:setWarningInformation( "rollingGateAnimation:" .. getName(rollingGate.splineNode))

                                                                            value.rollingGate = rollingGate

                                                                            return true
                                                                        end
                                                                    end

                                                                    return false
                                                                end ,

                                                                function (value)
                                                                    return value.rollingGate.state
                                                                end ,

                                                                function (value, state)
                                                                    value.rollingGate:setState(state)
                                                                end )
                                                            end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function AnimatedVehicle:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    AnimatedVehicle.updateAnimations( self , dt)

    local spec = self.spec_animatedVehicle
    if spec.fixedTimeSamplesDirtyDelay > 0 then
        spec.fixedTimeSamplesDirtyDelay = spec.fixedTimeSamplesDirtyDelay - 1
        if spec.fixedTimeSamplesDirtyDelay < = 0 then
            for _, animation in pairs(spec.animations) do
                if not table.hasElement(spec.activeAnimations, animation) then
                    if self.isClient then
                        for i = 1 , #animation.samples do
                            local sample = animation.samples[i]
                            if g_soundManager:getIsSamplePlaying(sample) then
                                if sample.loops = = 0 then
                                    g_soundManager:stopSample(sample)
                                end
                            end
                        end
                    end
                end
            end

            spec.fixedTimeSamplesDirtyDelay = 0
        end
    end

    if spec.numActiveAnimations > 0 then
        self:raiseActive()
    end
end

```

### playAnimation

**Description**

> Play animation

**Definition**

> playAnimation(string name, float speed, float animTime, boolean noEventSend, )

**Arguments**

| string  | name        | name of animation |
|---------|-------------|-------------------|
| float   | speed       | speed             |
| float   | animTime    | start time        |
| boolean | noEventSend | no event send     |
| any     | allowSounds |                   |

**Code**

```lua
function AnimatedVehicle:playAnimation(name, speed, animTime, noEventSend, allowSounds)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        SpecializationUtil.raiseEvent( self , "onPlayAnimation" , name)

        if speed = = nil then
            speed = animation.currentSpeed
        end

        -- skip animation if speed is not set or 0 to allow skipping animations per xml speed attribute set to 0
            if speed = = nil or speed = = 0 then
                return
            end

            if animTime = = nil then
                if self:getIsAnimationPlaying(name) then
                    animTime = self:getAnimationTime(name)
                elseif speed > 0 then
                        animTime = 0
                    else
                            animTime = 1
                        end
                    end
                    if noEventSend = = nil or noEventSend = = false then
                        if g_server ~ = nil then
                            g_server:broadcastEvent( AnimatedVehicleStartEvent.new( self , name, speed, animTime), nil , nil , self )
                        else
                                g_client:getServerConnection():sendEvent( AnimatedVehicleStartEvent.new( self , name, speed, animTime))
                            end
                        end

                        if not table.hasElement(spec.activeAnimations, animation) then
                            table.addElement(spec.activeAnimations, animation)
                            spec.numActiveAnimations = spec.numActiveAnimations + 1
                            SpecializationUtil.raiseEvent( self , "onStartAnimation" , name, speed)
                        end
                        animation.currentSpeed = speed
                        animation.currentTime = animTime * animation.duration
                        self:resetAnimationValues(animation)

                        self:raiseActive()
                    end
                end

```

### postInitializeAnimationPart

**Description**

> Post Initialize part of animation (normally used to set default start value if not set by the end value of the
> previous part)

**Definition**

> postInitializeAnimationPart(table part, , , )

**Arguments**

| table | part     | part |
|-------|----------|------|
| any   | part     |      |
| any   | i        |      |
| any   | numParts |      |

**Code**

```lua
function AnimatedVehicle:postInitializeAnimationPart(animation, part, i, numParts)
    for index = 1 , #part.animationValues do
        part.animationValues[index]:postInit()
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
function AnimatedVehicle.prerequisitesPresent(specializations)
    return true
end

```

### registerAnimationValueType

**Description**

**Definition**

> registerAnimationValueType()

**Arguments**

| any | name          |
|-----|---------------|
| any | startName     |
| any | endName       |
| any | initialUpdate |
| any | classObject   |
| any | load          |
| any | get           |
| any | set           |

**Code**

```lua
function AnimatedVehicle:registerAnimationValueType(name, startName, endName, initialUpdate, classObject, load, get, set)
    local spec = self.spec_animatedVehicle

    if spec.animationValueTypes[name] = = nil then
        local animationValueType = { }

        animationValueType.classObject = classObject
        animationValueType.name = name
        animationValueType.startName = startName
        animationValueType.endName = endName
        animationValueType.initialUpdate = initialUpdate
        animationValueType.load = load
        animationValueType.get = get
        animationValueType.set = set

        spec.animationValueTypes[name] = animationValueType
    end
end

```

### registerAnimationXMLPaths

**Description**

**Definition**

> registerAnimationXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AnimatedVehicle.registerAnimationXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#name" , "Name of animation" )
    schema:register(XMLValueType.BOOL, basePath .. "#looping" , "Animation is looping" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#resetOnStart" , "Animation is reset while loading the vehicle" , true )
        schema:register(XMLValueType.FLOAT, basePath .. "#startAnimTime" , "Animation is set to this time if resetOnStart is set" , 0 )
            schema:register(XMLValueType.FLOAT, basePath .. "#soundVolumeFactor" , "Sound volume factor that is applied for all sounds in this animation" , 1 )
                schema:register(XMLValueType.BOOL, basePath .. "#isKeyframe" , "Is static keyframe animation instead of dynamically interpolating animation(Keyframe animations only support trans/rot/scale!)" , false )

                schema:addDelayedRegistrationPath(basePath .. ".part(?)" , "AnimatedVehicle:part" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".part(?)#node" , "Part node" )
                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#startTime" , "Start time" )
                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#duration" , "Duration" )
                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#endTime" , "End time" )
                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#time" , "Keyframe time(only for keyframe animations)" )
                    schema:register(XMLValueType.INT, basePath .. ".part(?)#direction" , "Part direction" , 0 )
                    schema:register(XMLValueType.STRING, basePath .. ".part(?)#tangentType" , "Type of tangent to be used(linear, spline, step)" , "linear" )

                    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#startRot" , "Start rotation" )
                    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#endRot" , "End rotation" )
                    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#startTrans" , "Start translation" )
                    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#endTrans" , "End translation" )
                    schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".part(?)#startScale" , "Start scale" )
                    schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".part(?)#endScale" , "End scale" )
                    schema:register(XMLValueType.BOOL, basePath .. ".part(?)#visibility" , "Visibility" )
                    schema:register(XMLValueType.BOOL, basePath .. ".part(?)#startVisibility" , "Visibility at start time(switched in the middle)" )
                    schema:register(XMLValueType.BOOL, basePath .. ".part(?)#endVisibility" , "Visibility at end time(switched in the middle)" )
                    schema:register(XMLValueType.INT, basePath .. ".part(?)#componentJointIndex" , "Component joint index" )

                    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#rotation" , "Rotation(only for keyframe animations)" )
                        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#translation" , "Translation(only for keyframe animations)" )
                            schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".part(?)#scale" , "Scale(only for keyframe animations)" )

                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#requiredAnimation" , "Required animation needs to be in a specific range to play part" )
                                schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".part(?)#requiredAnimationRange" , "Animation range of required animation" )

                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#requiredConfigurationName" , "This configuration needs to bet set to #requiredConfigurationIndex" )
                                schema:register(XMLValueType.INT, basePath .. ".part(?)#requiredConfigurationIndex" , "Required configuration needs to be in this state to activate the animation part" )

                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#startRotLimit" , "Start rotation limit" )
                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#startRotMinLimit" , "Start rotation min limit" )
                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#startRotMaxLimit" , "Start rotation max limit" )

                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#endRotLimit" , "End rotation limit" )
                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#endRotMinLimit" , "End rotation min limit" )
                                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".part(?)#endRotMaxLimit" , "End rotation max limit" )

                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#startTransLimit" , "Start translation limit" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#startTransMinLimit" , "Start translation min limit" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#startTransMaxLimit" , "Start translation max limit" )

                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#endTransLimit" , "End translation limit" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#endTransMinLimit" , "End translation min limit" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#endTransMaxLimit" , "End translation max limit" )

                                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".part(?)#startRotLimitSpring" , "Start rot limit spring" )
                                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".part(?)#startRotLimitDamping" , "Start rot limit damping" )

                                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".part(?)#endRotLimitSpring" , "End rot limit spring" )
                                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".part(?)#endRotLimitDamping" , "End rot limit damping" )

                                schema:register(XMLValueType.INT, basePath .. ".part(?)#componentIndex" , "Component index" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#startMass" , "Start mass of component" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#startCenterOfMass" , "Start center of mass" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#endMass" , "End mass of component" )
                                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".part(?)#endCenterOfMass" , "End center of mass" )

                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#startFrictionVelocity" , "Start friction velocity applied to node" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#endFrictionVelocity" , "End friction velocity applied to node" )

                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#shaderParameter" , "Shader parameter" )
                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#shaderParameterPrev" , "Shader parameter(prev)" )
                                schema:register(XMLValueType.STRING_LIST, basePath .. ".part(?)#shaderStartValues" , "Start shader values" )
                                schema:register(XMLValueType.STRING_LIST, basePath .. ".part(?)#shaderEndValues" , "End shader values" )

                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#animationClip" , "Animation clip name" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#clipStartTime" , "Animation clip start time" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#clipEndTime" , "Animation clip end time" )

                                schema:register(XMLValueType.STRING, basePath .. ".part(?)#dependentAnimation" , "Dependent animation name" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#dependentAnimationStartTime" , "Dependent animation start time" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#dependentAnimationEndTime" , "Dependent animation end time" )

                                schema:register(XMLValueType.NODE_INDEX, basePath .. ".part(?)#spline" , "Spline node" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#startSplinePos" , "Start spline position" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#endSplinePos" , "End spline position" )

                                RollingGateAnimation.registerXMLPaths(schema, basePath .. ".part(?).rollingGateAnimation" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#startGatePos" , "Start rolling gate position" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".part(?)#endGatePos" , "End rolling gate position" )

                                SoundManager.registerSampleXMLPaths(schema, basePath, "sound(?)" )
                                schema:register(XMLValueType.TIME, basePath .. ".sound(?)#startTime" , "Start play time" , 0 )
                                schema:register(XMLValueType.TIME, basePath .. ".sound(?)#endTime" , "End play time for loops or used on opposite direction" )
                                    schema:register(XMLValueType.INT, basePath .. ".sound(?)#direction" , "Direction to play the sound(0 = any direction)" , 0 )
                                    schema:register(XMLValueType.FLOAT, basePath .. ".sound(?)#startPitchScale" , "Pitch scale at the start time" )
                                    schema:register(XMLValueType.FLOAT, basePath .. ".sound(?)#endPitchScale" , "Pitch scale at the end time" )

                                    SoundManager.registerSampleXMLPaths(schema, basePath, "stopTimePosSound(?)" )
                                    SoundManager.registerSampleXMLPaths(schema, basePath, "stopTimeNegSound(?)" )
                                end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AnimatedVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , AnimatedVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AnimatedVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AnimatedVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , AnimatedVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AnimatedVehicle )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , AnimatedVehicle )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AnimatedVehicle.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onRegisterAnimationValueTypes" )
    SpecializationUtil.registerEvent(vehicleType, "onPlayAnimation" )
    SpecializationUtil.registerEvent(vehicleType, "onStartAnimation" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdateAnimation" )
    SpecializationUtil.registerEvent(vehicleType, "onFinishAnimation" )
    SpecializationUtil.registerEvent(vehicleType, "onStopAnimation" )
    SpecializationUtil.registerEvent(vehicleType, "onAnimationPartChanged" )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AnimatedVehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "registerAnimationValueType" , AnimatedVehicle.registerAnimationValueType)
    SpecializationUtil.registerFunction(vehicleType, "loadAnimation" , AnimatedVehicle.loadAnimation)
    SpecializationUtil.registerFunction(vehicleType, "loadAnimationPart" , AnimatedVehicle.loadAnimationPart)
    SpecializationUtil.registerFunction(vehicleType, "loadStaticAnimationPart" , AnimatedVehicle.loadStaticAnimationPart)
    SpecializationUtil.registerFunction(vehicleType, "loadStaticAnimationPartValues" , AnimatedVehicle.loadStaticAnimationPartValues)
    SpecializationUtil.registerFunction(vehicleType, "initializeAnimationParts" , AnimatedVehicle.initializeAnimationParts)
    SpecializationUtil.registerFunction(vehicleType, "initializeAnimationPart" , AnimatedVehicle.initializeAnimationPart)
    SpecializationUtil.registerFunction(vehicleType, "postInitializeAnimationPart" , AnimatedVehicle.postInitializeAnimationPart)
    SpecializationUtil.registerFunction(vehicleType, "playAnimation" , AnimatedVehicle.playAnimation)
    SpecializationUtil.registerFunction(vehicleType, "stopAnimation" , AnimatedVehicle.stopAnimation)
    SpecializationUtil.registerFunction(vehicleType, "getAnimationExists" , AnimatedVehicle.getAnimationExists)
    SpecializationUtil.registerFunction(vehicleType, "getAnimationByName" , AnimatedVehicle.getAnimationByName)
    SpecializationUtil.registerFunction(vehicleType, "getIsAnimationPlaying" , AnimatedVehicle.getIsAnimationPlaying)
    SpecializationUtil.registerFunction(vehicleType, "getRealAnimationTime" , AnimatedVehicle.getRealAnimationTime)
    SpecializationUtil.registerFunction(vehicleType, "setRealAnimationTime" , AnimatedVehicle.setRealAnimationTime)
    SpecializationUtil.registerFunction(vehicleType, "getAnimationTime" , AnimatedVehicle.getAnimationTime)
    SpecializationUtil.registerFunction(vehicleType, "setAnimationTime" , AnimatedVehicle.setAnimationTime)
    SpecializationUtil.registerFunction(vehicleType, "getAnimationDuration" , AnimatedVehicle.getAnimationDuration)
    SpecializationUtil.registerFunction(vehicleType, "setAnimationSpeed" , AnimatedVehicle.setAnimationSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getAnimationSpeed" , AnimatedVehicle.getAnimationSpeed)
    SpecializationUtil.registerFunction(vehicleType, "setAnimationStopTime" , AnimatedVehicle.setAnimationStopTime)
    SpecializationUtil.registerFunction(vehicleType, "resetAnimationValues" , AnimatedVehicle.resetAnimationValues)
    SpecializationUtil.registerFunction(vehicleType, "resetAnimationPartValues" , AnimatedVehicle.resetAnimationPartValues)
    SpecializationUtil.registerFunction(vehicleType, "updateAnimationPart" , AnimatedVehicle.updateAnimationPart)
    SpecializationUtil.registerFunction(vehicleType, "getNumOfActiveAnimations" , AnimatedVehicle.getNumOfActiveAnimations)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AnimatedVehicle.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , AnimatedVehicle.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , AnimatedVehicle.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , AnimatedVehicle.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , AnimatedVehicle.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingToolFromXML" , AnimatedVehicle.loadMovingToolFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingToolActive" , AnimatedVehicle.getIsMovingToolActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingPartFromXML" , AnimatedVehicle.loadMovingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingPartActive" , AnimatedVehicle.getIsMovingPartActive)
end

```

### resetAnimationPartValues

**Description**

> Resets animation part

**Definition**

> resetAnimationPartValues(table part)

**Arguments**

| table | part | part to reset |
|-------|------|---------------|

**Code**

```lua
function AnimatedVehicle:resetAnimationPartValues(part)
    for index = 1 , #part.animationValues do
        part.animationValues[index]:reset()
    end
end

```

### resetAnimationValues

**Description**

> Resets animation values

**Definition**

> resetAnimationValues(table animation)

**Arguments**

| table | animation | animation |
|-------|-----------|-----------|

**Code**

```lua
function AnimatedVehicle:resetAnimationValues(animation)
    AnimatedVehicle.findCurrentPartIndex(animation)
    for _, part in ipairs(animation.parts) do
        self:resetAnimationPartValues(part)
    end
end

```

### setAnimationSpeed

**Description**

> Sets speed of animation

**Definition**

> setAnimationSpeed(string name, float speed)

**Arguments**

| string | name  | name of animation |
|--------|-------|-------------------|
| float  | speed | speed             |

**Code**

```lua
function AnimatedVehicle:setAnimationSpeed(name, speed)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        local speedReversed = false
        if (animation.currentSpeed > 0 ) ~ = (speed > 0 ) then
            speedReversed = true
        end
        animation.currentSpeed = speed
        if self:getIsAnimationPlaying(name) and speedReversed then
            self:resetAnimationValues(animation)
        end
    end
end

```

### setAnimationStopTime

**Description**

> Sets animation stop time

**Definition**

> setAnimationStopTime(string name, float stopTime)

**Arguments**

| string | name     | name of animation |
|--------|----------|-------------------|
| float  | stopTime | stop time [0..1]  |

**Code**

```lua
function AnimatedVehicle:setAnimationStopTime(name, stopTime)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        animation.stopTime = stopTime * animation.duration
    end
end

```

### setAnimationTime

**Description**

> Set animation time

**Definition**

> setAnimationTime(string name, float animTime, boolean update, )

**Arguments**

| string  | name       | name of animation     |
|---------|------------|-----------------------|
| float   | animTime   | animation time [0..1] |
| boolean | update     | update animation      |
| any     | playSounds |                       |

**Code**

```lua
function AnimatedVehicle:setAnimationTime(name, animTime, update, playSounds)
    local spec = self.spec_animatedVehicle

    if spec.animations = = nil then
        printCallstack()
    end

    local animation = spec.animations[name]
    if animation ~ = nil then
        self:setRealAnimationTime(name, animTime * animation.duration, update, playSounds)
    end
end

```

### setMovedLimitedValues3

**Description**

> Sets moved limited values (3)

**Definition**

> setMovedLimitedValues3(table currentValues, table destValues, table speeds, float dt)

**Arguments**

| table | currentValues | current values             |
|-------|---------------|----------------------------|
| table | destValues    | dest values                |
| table | speeds        | speeds                     |
| float | dt            | time since last call in ms |

**Code**

```lua
function AnimatedVehicle.setMovedLimitedValues3(currentValues, destValues, speeds, dt)
    return AnimatedVehicle.setMovedLimitedValuesN( 3 , currentValues, destValues, speeds, dt)
end

```

### setMovedLimitedValues4

**Description**

> Sets moved limited values (4)

**Definition**

> setMovedLimitedValues4(table currentValues, table destValues, table speeds, float dt)

**Arguments**

| table | currentValues | current values             |
|-------|---------------|----------------------------|
| table | destValues    | dest values                |
| table | speeds        | speeds                     |
| float | dt            | time since last call in ms |

**Code**

```lua
function AnimatedVehicle.setMovedLimitedValues4(currentValues, destValues, speeds, dt)
    return AnimatedVehicle.setMovedLimitedValuesN( 4 , currentValues, destValues, speeds, dt)
end

```

### setMovedLimitedValuesN

**Description**

> Sets moved limited values on N values

**Definition**

> setMovedLimitedValuesN(integer n, table currentValues, table destValues, table speeds, float dt)

**Arguments**

| integer | n             | number of values           |
|---------|---------------|----------------------------|
| table   | currentValues | current values             |
| table   | destValues    | dest values                |
| table   | speeds        | speeds                     |
| float   | dt            | time since last call in ms |

**Code**

```lua
function AnimatedVehicle.setMovedLimitedValuesN(n, currentValues, destValues, speeds, dt)
    local hasChanged = false
    for i = 1 , n do
        local newValue = AnimatedVehicle.getMovedLimitedValue(currentValues[i], destValues[i], speeds[i], dt)
        if currentValues[i] ~ = newValue then
            hasChanged = true
            currentValues[i] = newValue
        end
    end
    return hasChanged
end

```

### setRealAnimationTime

**Description**

> Set animation real time

**Definition**

> setRealAnimationTime(string name, float animTime, boolean update, )

**Arguments**

| string  | name       | name of animation         |
|---------|------------|---------------------------|
| float   | animTime   | real animation time in ms |
| boolean | update     | update animation          |
| any     | playSounds |                           |

**Code**

```lua
function AnimatedVehicle:setRealAnimationTime(name, animTime, update, playSounds)
    local spec = self.spec_animatedVehicle

    local animation = spec.animations[name]
    if animation ~ = nil then
        if update = = nil or update then
            local currentSpeed = animation.currentSpeed
            animation.currentSpeed = 1
            if animation.currentTime > animTime then
                animation.currentSpeed = - 1
            end

            self:resetAnimationValues(animation)

            local dtToUse, _ = AnimatedVehicle.updateAnimationCurrentTime( self , animation, 99999999 , animTime)
            AnimatedVehicle.updateAnimation( self , animation, dtToUse, true , true , playSounds)
            animation.currentSpeed = currentSpeed
        else
                animation.currentTime = animTime
            end
        end
    end

```

### stopAnimation

**Description**

> Stop animation

**Definition**

> stopAnimation(string name, boolean noEventSend)

**Arguments**

| string  | name        | name of animation |
|---------|-------------|-------------------|
| boolean | noEventSend | no event send     |

**Code**

```lua
function AnimatedVehicle:stopAnimation(name, noEventSend)
    local spec = self.spec_animatedVehicle

    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( AnimatedVehicleStopEvent.new( self , name), nil , nil , self )
        else
                g_client:getServerConnection():sendEvent( AnimatedVehicleStopEvent.new( self , name))
            end
        end
        local animation = spec.animations[name]
        if animation ~ = nil then
            SpecializationUtil.raiseEvent( self , "onStopAnimation" , name)
            animation.stopTime = nil

            if self.isClient then
                for i = 1 , #animation.samples do
                    local sample = animation.samples[i]
                    if sample.loops = = 0 then
                        g_soundManager:stopSample(sample)
                    end
                end
            end
        end

        if table.hasElement(spec.activeAnimations, animation) then
            table.removeElement(spec.activeAnimations, animation)
            spec.numActiveAnimations = spec.numActiveAnimations - 1
            SpecializationUtil.raiseEvent( self , "onFinishAnimation" , name)
        end
    end

```

### updateAnimation

**Description**

> Update animation

**Definition**

> updateAnimation(table anim, float dtToUse, boolean stopAnimation, boolean fixedTimeUpdate, playSounds playSounds, )

**Arguments**

| table      | anim            | animation                                                                                                               |
|------------|-----------------|-------------------------------------------------------------------------------------------------------------------------|
| float      | dtToUse         | dt to use                                                                                                               |
| boolean    | stopAnimation   | stop animation                                                                                                          |
| boolean    | fixedTimeUpdate | is a fixed time update (e.g. from setAnimationTime) -> no sound, no looping, fixed setting between start and end values |
| playSounds | playSounds      | if true it still plays sounds while doing fixed time updates                                                            |
| any        | playSounds      |                                                                                                                         |

**Code**

```lua
function AnimatedVehicle.updateAnimation( self , anim, dtToUse, stopAnim, fixedTimeUpdate, playSounds)
    local spec = self.spec_animatedVehicle
    local isStopTimeStop = stopAnim

    local numParts = #anim.parts
    local parts = anim.parts
    if anim.currentSpeed < 0 then
        parts = anim.partsReverse
    end

    if dtToUse > 0 then
        local hasChanged = false
        local nothingToChangeYet = false

        if not anim.isKeyframe then
            for partI = anim.currentPartIndex, numParts do
                local part = parts[partI]

                local isInRange = true
                if part.requiredAnimation ~ = nil then
                    local time = self:getAnimationTime(part.requiredAnimation)
                    if time < part.requiredAnimationRange[ 1 ] or time > part.requiredAnimationRange[ 2 ] then
                        isInRange = false
                    end
                end

                local sameConfiguration = true
                if part.requiredConfigurationName ~ = nil then
                    if self.configurations[part.requiredConfigurationName] ~ = nil then
                        if self.configurations[part.requiredConfigurationName] ~ = part.requiredConfigurationIndex then
                            sameConfiguration = false
                        end
                    end
                end

                if (part.direction = = 0 or((part.direction > 0 ) = = (anim.currentSpeed > = 0 ))) and isInRange and sameConfiguration then
                    local durationToEnd = AnimatedVehicle.getDurationToEndOfPart(part, anim)

                    -- is this part not playing yet?
                    if durationToEnd > part.duration then
                        nothingToChangeYet = true
                        break
                    end

                    local realDt = dtToUse

                    if anim.currentSpeed > 0 then
                        local startT = anim.currentTime - dtToUse
                        if startT < part.startTime then
                            realDt = dtToUse - part.startTime + startT
                        end
                    else
                            local startT = anim.currentTime + dtToUse
                            local endTime = part.startTime + part.duration
                            if startT > endTime then
                                realDt = dtToUse - (startT - endTime)
                            end
                        end

                        durationToEnd = durationToEnd + realDt

                        if self:updateAnimationPart(anim, part, durationToEnd, dtToUse, realDt, fixedTimeUpdate) then
                            hasChanged = true
                        end
                    end

                    if partI = = anim.currentPartIndex then
                        -- is this part finished?
                        if (anim.currentSpeed > 0 and part.startTime + part.duration < anim.currentTime) or
                            (anim.currentSpeed < = 0 and part.startTime > anim.currentTime)
                            then
                            self:resetAnimationPartValues(part)
                            anim.currentPartIndex = anim.currentPartIndex + 1
                        end
                    end
                end
                if not nothingToChangeYet and not hasChanged and anim.currentPartIndex > = numParts then
                    -- end the animation
                    anim.previousTime = anim.currentTime
                    if anim.currentSpeed > 0 then
                        anim.currentTime = anim.duration
                    else
                            anim.currentTime = 0
                        end
                        stopAnim = true
                    end
                else
                        for node, curve in pairs(anim.curvesByNode) do
                            local x, y, z, rx, ry, rz, sx, sy, sz = curve:get(anim.currentTime)
                            if curve.hasTranslation then
                                setTranslation(node, x, y, z)
                            end
                            if curve.hasRotation then
                                setRotation(node, rx, ry, rz)
                            end
                            if curve.hasScale then
                                setScale(node, sx, sy, sz)
                            end

                            SpecializationUtil.raiseEvent( self , "onAnimationPartChanged" , node)
                        end

                        stopAnim = anim.currentTime < = 0 or anim.currentTime > = anim.duration
                    end

                    if table.hasElement(spec.activeAnimations, anim) or playSounds = = true then
                        if fixedTimeUpdate ~ = true or playSounds = = true then
                            for i = 1 , #anim.samples do
                                local sample = anim.samples[i]
                                if g_soundManager:getIsSamplePlaying(sample) then
                                    if sample.endTime ~ = nil then
                                        if sample.startPitchScale ~ = nil then
                                            local alpha = MathUtil.inverseLerp(sample.startTime, sample.endTime, anim.currentTime)
                                            sample.pitchScale = (sample.endPitchScale - sample.startPitchScale) * alpha + sample.startPitchScale
                                        end

                                        if anim.currentSpeed > 0 then
                                            if anim.currentTime > sample.endTime then
                                                g_soundManager:stopSample(sample)
                                            end
                                        else
                                                if anim.currentTime < sample.startTime then
                                                    g_soundManager:stopSample(sample)
                                                end
                                            end

                                            -- if the direction does not match with the new animation direction, we stop the sound
                                                if not(sample.direction = = 0 or((sample.direction > = 0 ) = = (anim.currentSpeed > = 0 ))) then
                                                    g_soundManager:stopSample(sample)
                                                end
                                            end
                                        else
                                                if sample.direction = = 0 or((sample.direction > = 0 ) = = (anim.currentSpeed > = 0 )) then
                                                    if sample.loops ~ = 0 then
                                                        if sample.endTime ~ = nil then
                                                            sample.readyToStart = anim.previousTime < sample.startTime or anim.previousTime > sample.endTime
                                                        else
                                                                if anim.currentSpeed < 0 then
                                                                    sample.readyToStart = anim.previousTime > sample.startTime

                                                                else
                                                                        sample.readyToStart = anim.previousTime < sample.startTime
                                                                    end
                                                                end
                                                            else
                                                                    sample.readyToStart = true
                                                                end

                                                                local inRange = anim.currentTime > = sample.startTime
                                                                if sample.endTime ~ = nil then
                                                                    inRange = anim.currentTime > = sample.startTime and anim.currentTime < = sample.endTime
                                                                else
                                                                        if anim.currentSpeed < 0 then
                                                                            inRange = anim.currentTime < = sample.startTime
                                                                        end
                                                                    end

                                                                    if sample.readyToStart and inRange then
                                                                        g_soundManager:playSample(sample)
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end

                                                    SpecializationUtil.raiseEvent( self , "onUpdateAnimation" , anim.name)

                                                    if not table.hasElement(spec.activeAnimations, anim) then
                                                        spec.fixedTimeSamplesDirtyDelay = 2
                                                    end
                                                end
                                            end
                                            if stopAnim or(numParts > 0 and(anim.currentPartIndex > numParts or anim.currentPartIndex < 1 )) then
                                                anim.previousTime = anim.currentTime
                                                if not stopAnim then
                                                    if anim.currentSpeed > 0 then
                                                        anim.currentTime = anim.duration
                                                    else
                                                            anim.currentTime = 0
                                                        end
                                                    end
                                                    anim.currentTime = math.min( math.max(anim.currentTime, 0 ), anim.duration)
                                                    local allowLooping = anim.stopTime ~ = anim.currentTime
                                                    anim.stopTime = nil
                                                    if table.hasElement(spec.activeAnimations, anim) then
                                                        if self.isClient then
                                                            for i = 1 , #anim.samples do
                                                                local sample = anim.samples[i]
                                                                if sample.loops = = 0 then
                                                                    g_soundManager:stopSample(sample)
                                                                end
                                                            end

                                                            if isStopTimeStop and anim.eventSamples ~ = nil then
                                                                if anim.currentSpeed > 0 then
                                                                    if anim.eventSamples.stopTimePos ~ = nil then
                                                                        for i = 1 , #anim.eventSamples.stopTimePos do
                                                                            g_soundManager:playSample(anim.eventSamples.stopTimePos[i])
                                                                        end
                                                                    end
                                                                else
                                                                        if anim.eventSamples.stopTimeNeg ~ = nil then
                                                                            for i = 1 , #anim.eventSamples.stopTimeNeg do
                                                                                g_soundManager:playSample(anim.eventSamples.stopTimeNeg[i])
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            table.removeElement(spec.activeAnimations, anim)
                                                            spec.numActiveAnimations = spec.numActiveAnimations - 1
                                                            SpecializationUtil.raiseEvent( self , "onFinishAnimation" , anim.name)
                                                        end

                                                        if allowLooping and fixedTimeUpdate ~ = true then
                                                            if anim.looping then
                                                                -- restart animation
                                                                self:setAnimationTime(anim.name, math.abs((anim.currentTime / math.max(anim.duration, 0.0001 )) - 1 ), true )
                                                                self:playAnimation(anim.name, anim.currentSpeed, nil , true )
                                                            end
                                                        end
                                                    end
                                                end

```

### updateAnimationByName

**Description**

> Update animation by name

**Definition**

> updateAnimationByName(string animName, float dt, , )

**Arguments**

| string | animName        | name of animation to update |
|--------|-----------------|-----------------------------|
| float  | dt              | time since last call in ms  |
| any    | dt              |                             |
| any    | fixedTimeUpdate |                             |

**Code**

```lua
function AnimatedVehicle.updateAnimationByName( self , animName, dt, fixedTimeUpdate)
    local spec = self.spec_animatedVehicle

    local anim = spec.animations[animName]
    if anim ~ = nil then
        local dtToUse, stopAnim = AnimatedVehicle.updateAnimationCurrentTime( self , anim, dt, anim.stopTime)
        AnimatedVehicle.updateAnimation( self , anim, dtToUse, stopAnim, fixedTimeUpdate)
    end
end

```

### updateAnimationCurrentTime

**Description**

> Update current animation time

**Definition**

> updateAnimationCurrentTime(table anim, float dt, float stopTime, )

**Arguments**

| table | anim     | animation                  |
|-------|----------|----------------------------|
| float | dt       | time since last call in ms |
| float | stopTime | stop time                  |
| any   | stopTime |                            |

**Return Values**

| any | dtToUse       | dt to use      |
|-----|---------------|----------------|
| any | stopAnimation | stop animation |

**Code**

```lua
function AnimatedVehicle.updateAnimationCurrentTime( self , anim, dt, stopTime)
    anim.previousTime = anim.currentTime
    anim.currentTime = anim.currentTime + dt * anim.currentSpeed

    local absSpeed = math.abs(anim.currentSpeed)
    local dtToUse = dt * absSpeed
    local stopAnim = false
    if stopTime ~ = nil then
        if anim.currentSpeed > 0 then
            if stopTime < = anim.currentTime then
                dtToUse = dtToUse - (anim.currentTime - stopTime)
                anim.currentTime = stopTime
                stopAnim = true
            end
        else
                if stopTime > = anim.currentTime then
                    dtToUse = dtToUse - (stopTime - anim.currentTime)
                    anim.currentTime = stopTime
                    stopAnim = true
                end
            end
        end
        return dtToUse, stopAnim
    end

```

### updateAnimationPart

**Description**

> Update animation part

**Definition**

> updateAnimationPart(table anim, table part, float durationToEnd, float dtToUse, float realDt, )

**Arguments**

| table | anim            | animation       |
|-------|-----------------|-----------------|
| table | part            | part            |
| float | durationToEnd   | duration to end |
| float | dtToUse         | dt to use       |
| float | realDt          | real dt         |
| any   | fixedTimeUpdate |                 |

**Code**

```lua
function AnimatedVehicle:updateAnimationPart(animation, part, durationToEnd, dtToUse, realDt, fixedTimeUpdate)
    local hasPartChanged = false

    for index = 1 , #part.animationValues do
        local valueChanged = part.animationValues[index]:update(durationToEnd, dtToUse, realDt, fixedTimeUpdate)
        hasPartChanged = hasPartChanged or valueChanged
    end

    return hasPartChanged
end

```

### updateAnimations

**Description**

> Update animations

**Definition**

> updateAnimations(float dt, , )

**Arguments**

| float | dt              | time since last call in ms |
|-------|-----------------|----------------------------|
| any   | dt              |                            |
| any   | fixedTimeUpdate |                            |

**Code**

```lua
function AnimatedVehicle.updateAnimations( self , dt, fixedTimeUpdate)
    local spec = self.spec_animatedVehicle

    for i = #spec.activeAnimations, 1 , - 1 do
        local animation = spec.activeAnimations[i]

        local dtToUse, stopAnim = AnimatedVehicle.updateAnimationCurrentTime( self , animation, dt, animation.stopTime)
        AnimatedVehicle.updateAnimation( self , animation, dtToUse, stopAnim, fixedTimeUpdate)
    end
end

```