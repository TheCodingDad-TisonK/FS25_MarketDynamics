## AnimationValueFloat

**Description**

> Animation value with one or multiple floats for AnimatedVehicle

**Functions**

- [addCompareParameters](#addcompareparameters)
- [init](#init)
- [initValues](#initvalues)
- [load](#load)
- [new](#new)
- [postInit](#postinit)
- [reset](#reset)
- [setWarningInformation](#setwarninginformation)
- [update](#update)

### addCompareParameters

**Description**

**Definition**

> addCompareParameters()

**Arguments**

| any | ... |
|-----|-----|

**Code**

```lua
function AnimationValueFloat:addCompareParameters( .. .)
    for i = 1 , select( "#" , .. .) do
        local value = select(i, .. .)
        table.insert( self.compareParams, value)
    end
end

```

### init

**Description**

**Definition**

> init()

**Arguments**

| any | index    |
|-----|----------|
| any | numParts |

**Code**

```lua
function AnimationValueFloat:init(index, numParts)
    for j = index + 1 , numParts do
        local part2 = self.animation.parts[j]
        if self.part.direction = = part2.direction then
            local animationValue2
            for secondIndex = 1 , #part2.animationValues do
                local secondAnimValue = part2.animationValues[secondIndex]
                if secondAnimValue.endName = = self.endName then
                    local allowed = true
                    for paramIndex = 1 , # self.compareParams do
                        local param = self.compareParams[paramIndex]
                        if secondAnimValue[param] ~ = self [param] then
                            allowed = false
                        end
                    end

                    if allowed then
                        animationValue2 = secondAnimValue
                    end
                end
            end

            if animationValue2 ~ = nil then
                if self.part.startTime + self.part.duration > part2.startTime + 0.001 then
                    Logging.xmlWarning( self.xmlFile, "Overlapping %s parts for '%s' in animation '%s'" , self.name, self.warningInfo, self.animation.name)
                    end

                    self.nextPart = animationValue2.part
                    animationValue2.prevPart = self.part
                    if animationValue2.startValue = = nil then
                        animationValue2.startValue = { unpack( self.endValue) }
                    end

                    break
                end
            end
        end
    end

```

### initValues

**Description**

**Definition**

> initValues()

**Arguments**

| any | targetValue     |
|-----|-----------------|
| any | durationToEnd   |
| any | fixedTimeUpdate |
| any | ...             |

**Code**

```lua
function AnimationValueFloat:initValues(targetValue, durationToEnd, fixedTimeUpdate, .. .)
    self.curValue = self.curValue or self.oldCurValues

    local numValues = select( "#" , .. .)
    for i = 1 , numValues do
        self.curValue[i] = select(i, .. .)
    end

    local invDuration = 1.0 / math.max(durationToEnd, 0.001 )

    self.speed = self.speed or self.oldSpeed
    for i = 1 , # self.curValue do
        self.speed[i] = (targetValue[i] - self.curValue[i]) * invDuration

        self.curStartValue[i] = self.curValue[i]
        self.curRealValue[i] = self.curValue[i]
    end

    if fixedTimeUpdate = = true then
        -- for fixed time updates(e.g.setAnimationTime) we use directly start and end values instead
        -- of interpolating from the current position to the target as we normally do
            -- this helps us to set the spline tangent type values correctly
            if self.animation.currentSpeed < 0 then
                for i = 1 , numValues do
                    self.curStartValue[i] = self.endValue[i]
                end
            else
                    for i = 1 , numValues do
                        self.curStartValue[i] = self.startValue[i]
                    end
                end
            end

            self.curTargetValue = targetValue

            return self.initialUpdate
        end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AnimationValueFloat:load(xmlFile, key)
    if self.startName ~ = "" then
        self.startValue = xmlFile:getValue(key .. "#" .. self.startName, nil , true )

        if type( self.startValue) = = "number" then
            self.startValue = { self.startValue }
        elseif type( self.startValue) = = "boolean" then
                self.startValue = { self.startValue and 1 or 0 }
            elseif type( self.startValue) = = "string" then
                    self.startValue = { tonumber( self.startValue) or 0 }
                elseif type( self.startValue) = = "table" then
                        for i = 1 , # self.startValue do
                            if type( self.startValue[i]) = = "string" then
                                self.startValue[i] = tonumber( self.startValue[i]) or 0
                            end
                        end
                    end
                end

                if self.endName ~ = "" then
                    self.endValue = xmlFile:getValue(key .. "#" .. self.endName, nil , true )

                    if type( self.endValue) = = "number" then
                        self.endValue = { self.endValue }
                    elseif type( self.endValue) = = "boolean" then
                            self.endValue = { self.endValue and 1 or 0 }
                        elseif type( self.endValue) = = "string" then
                                self.endValue = { tonumber( self.endValue) or 0 }
                            elseif type( self.endValue) = = "table" then
                                    for i = 1 , # self.endValue do
                                        if type( self.endValue[i]) = = "string" then
                                            self.endValue[i] = tonumber( self.endValue[i]) or 0
                                        end
                                    end
                                end
                            end

                            if self.endValue ~ = nil or self.endName = = "" then
                                self.warningInfo = key
                                self.xmlFile = xmlFile

                                local success = self:extraLoad(xmlFile, key)

                                if success then
                                    local tangentTypeStr = xmlFile:getValue(key .. "#tangentType" , "linear" )
                                    tangentTypeStr = "TANGENT_TYPE_" .. string.upper(tangentTypeStr)
                                    if AnimationValueFloat [tangentTypeStr] ~ = nil then
                                        self.tangentType = AnimationValueFloat [tangentTypeStr]
                                    else
                                            self.tangentType = AnimationValueFloat.TANGENT_TYPE_LINEAR
                                        end

                                        self.curStartValue = { }
                                        self.curRealValue = { }
                                        for i = 1 , #( self.startValue or self.endValue) do
                                            self.curStartValue[i] = 0
                                            self.curRealValue[i] = 0
                                        end

                                        return true
                                    end
                                end

                                return false
                            end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | animation     |
| any | part          |
| any | startName     |
| any | endName       |
| any | name          |
| any | initialUpdate |
| any | get           |
| any | set           |
| any | extraLoad     |
| any | customMt      |

**Code**

```lua
function AnimationValueFloat.new(vehicle, animation, part, startName, endName, name, initialUpdate, get, set, extraLoad, customMt)
    local self = setmetatable( { } , customMt or AnimationValueFloat _mt)

    self.vehicle = vehicle
    self.animation = animation
    self.part = part

    self.startName = startName
    self.endName = endName
    self.name = name

    self.initialUpdate = initialUpdate

    self.get = get
    self.set = set
    self.extraLoad = extraLoad

    self.warningInfo = self.name
    self.compareParams = { }

    self.oldCurValues = { }
    self.oldSpeed = { }

    self.curValue = nil
    self.speed = nil

    return self
end

```

### postInit

**Description**

**Definition**

> postInit()

**Code**

```lua
function AnimationValueFloat:postInit()
    if self.endValue ~ = nil and self.startValue = = nil then
        self.startValue = { self:get() }
    end
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AnimationValueFloat:reset()
    self.oldCurValues = self.curValue or self.oldCurValues
    self.oldSpeed = self.speed or self.oldSpeed

    self.curValue = nil
    self.speed = nil
end

```

### setWarningInformation

**Description**

**Definition**

> setWarningInformation()

**Arguments**

| any | info |
|-----|------|

**Code**

```lua
function AnimationValueFloat:setWarningInformation(info)
    self.warningInfo = info
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | durationToEnd   |
|-----|-----------------|
| any | dtToUse         |
| any | realDt          |
| any | fixedTimeUpdate |

**Code**

```lua
function AnimationValueFloat:update(durationToEnd, dtToUse, realDt, fixedTimeUpdate)
    if self.startValue ~ = nil and(durationToEnd > 0 or AnimatedVehicle.getNextPartIsPlaying( self.nextPart, self.prevPart, self.animation, true )) then
        local targetValue = self.endValue
        if self.animation.currentSpeed < 0 then
            targetValue = self.startValue
        end

        local forceUpdate = false
        if self.curValue = = nil then
            forceUpdate = self:initValues(targetValue, durationToEnd, fixedTimeUpdate, self:get())
        end

        if AnimatedVehicle.setMovedLimitedValuesN(# self.curValue, self.curValue, targetValue, self.speed, realDt) or forceUpdate then
            if self.tangentType = = AnimationValueFloat.TANGENT_TYPE_LINEAR then
                self:set( unpack( self.curValue))
            elseif self.tangentType = = AnimationValueFloat.TANGENT_TYPE_SPLINE then
                    for i = 1 , # self.curValue do
                        local alpha = 0
                        if fixedTimeUpdate ~ = true then
                            local range = self.curTargetValue[i] - self.curStartValue[i]
                            if range ~ = 0 then
                                alpha = ( self.curValue[i] - self.curStartValue[i]) / range
                            end
                        elseif self.part.duration ~ = 0 then
                                alpha = 1 - math.clamp((durationToEnd - realDt) / self.part.duration, 0 , 1 )
                            end

                            if alpha > = 0 and alpha < = 1 then
                                self.curRealValue[i] = getSplineAlpha(alpha) * ( self.curTargetValue[i] - self.curStartValue[i]) + self.curStartValue[i]
                            else
                                    self.curRealValue[i] = self.curValue[i]
                                end
                            end

                            self:set( unpack( self.curRealValue))
                        elseif self.tangentType = = AnimationValueFloat.TANGENT_TYPE_STEP then
                                for i = 1 , # self.curValue do
                                    local alpha = ( self.curValue[i] - self.curStartValue[i]) / math.max( self.curTargetValue[i] - self.curStartValue[i], 0.00001 )
                                    if alpha > = 1 then
                                        self.curRealValue[i] = self.curValue[i]
                                    else
                                            self.curRealValue[i] = self.curStartValue[i]
                                        end
                                    end

                                    self:set( unpack( self.curRealValue))
                                end

                                return true
                            end
                        end

                        return false
                    end

```