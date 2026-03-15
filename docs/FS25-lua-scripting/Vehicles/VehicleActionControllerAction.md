## VehicleActionControllerAction

**Description**

> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Functions**

- [actionEvent](#actionevent)
- [addAIEventListener](#addaieventlistener)
- [doAction](#doaction)
- [getControlledActionIcons](#getcontrolledactionicons)
- [getDebugText](#getdebugtext)
- [getDoResetOnDeactivation](#getdoresetondeactivation)
- [getIsFinished](#getisfinished)
- [getIsSaved](#getissaved)
- [getLastDirection](#getlastdirection)
- [getSourceVehicle](#getsourcevehicle)
- [isAvailable](#isavailable)
- [new](#new)
- [onAIEvent](#onaievent)
- [registerActionEvents](#registeractionevents)
- [remove](#remove)
- [setActionIcons](#setactionicons)
- [setCallback](#setcallback)
- [setDeactivateFunction](#setdeactivatefunction)
- [setFinishedFunctions](#setfinishedfunctions)
- [setIsAccessibleFunction](#setisaccessiblefunction)
- [setIsAvailableFunction](#setisavailablefunction)
- [setIsSaved](#setissaved)
- [setResetOnDeactivation](#setresetondeactivation)
- [update](#update)
- [updateForAI](#updateforai)
- [updateParent](#updateparent)

### actionEvent

**Description**

**Definition**

> actionEvent()

**Arguments**

| any | actionName  |
|-----|-------------|
| any | inputValue  |
| any | actionIndex |
| any | isAnalog    |

**Code**

```lua
function VehicleActionControllerAction:actionEvent(actionName, inputValue, actionIndex, isAnalog)
    self:doAction()
end

```

### addAIEventListener

**Description**

**Definition**

> addAIEventListener()

**Arguments**

| any | sourceVehicle      |
|-----|--------------------|
| any | eventName          |
| any | direction          |
| any | forceUntilFinished |

**Code**

```lua
function VehicleActionControllerAction:addAIEventListener(sourceVehicle, eventName, direction, forceUntilFinished)
    self.sourceVehicle = sourceVehicle

    local listener = { }
    listener.eventName = eventName
    listener.direction = direction
    listener.forceUntilFinished = forceUntilFinished

    table.insert( self.aiEventListener, listener)
end

```

### doAction

**Description**

**Definition**

> doAction()

**Arguments**

| any | direction |
|-----|-----------|
| any | isAIEvent |

**Code**

```lua
function VehicleActionControllerAction:doAction(direction, isAIEvent)
    if direction = = nil then
        direction = - self.lastDirection
    end
    self.lastDirection = direction

    local success = self.inputCallback( self.callbackTarget, direction, isAIEvent)
    if success then
        self.lastValidDirection = self.lastDirection
    end

    return success
end

```

### getControlledActionIcons

**Description**

**Definition**

> getControlledActionIcons()

**Code**

```lua
function VehicleActionControllerAction:getControlledActionIcons()
    return self.iconPos, self.iconNeg, self.iconChangeColor
end

```

### getDebugText

**Description**

**Definition**

> getDebugText()

**Code**

```lua
function VehicleActionControllerAction:getDebugText()
    local finishedResult = "?"
    if self.finishedFunc ~ = nil then
        finishedResult = self.finishedFunc( self.finishedFunctionTarget)
        if type(finishedResult) = = "number" then
            finishedResult = string.format( "%.1f" , finishedResult)
        end
    end

    local vehicleName = "Unknown Vehicle"
    if self.callbackTarget ~ = nil then
        vehicleName = self.callbackTarget:getName()
    end

    return string.format( "Prio '%d' - Vehicle '%s' - Action '%s' (%s/%s)" , self.priority, vehicleName, self.name, finishedResult, self.lastDirection = = 1 and self.finishedResult or self.finishedResultRev)
end

```

### getDoResetOnDeactivation

**Description**

**Definition**

> getDoResetOnDeactivation()

**Code**

```lua
function VehicleActionControllerAction:getDoResetOnDeactivation()
    return self.resetOnDeactivation
end

```

### getIsFinished

**Description**

**Definition**

> getIsFinished()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function VehicleActionControllerAction:getIsFinished(direction)
    if self.finishedFunc ~ = nil then
        if direction > 0 then
            return self.finishedFunc( self.finishedFunctionTarget) = = self.finishedResult
        else
                return self.finishedFunc( self.finishedFunctionTarget) = = self.finishedResultRev
            end
        end

        return true
    end

```

### getIsSaved

**Description**

**Definition**

> getIsSaved()

**Code**

```lua
function VehicleActionControllerAction:getIsSaved()
    return self.isSaved
end

```

### getLastDirection

**Description**

**Definition**

> getLastDirection()

**Code**

```lua
function VehicleActionControllerAction:getLastDirection()
    return self.lastDirection
end

```

### getSourceVehicle

**Description**

**Definition**

> getSourceVehicle()

**Code**

```lua
function VehicleActionControllerAction:getSourceVehicle()
    return self.sourceVehicle
end

```

### isAvailable

**Description**

**Definition**

> isAvailable()

**Code**

```lua
function VehicleActionControllerAction:isAvailable()
    if self.availableFunc ~ = nil then
        return self.availableFunc()
    end

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | parent      |
|-----|-------------|
| any | name        |
| any | inputAction |
| any | priority    |
| any | customMt    |

**Code**

```lua
function VehicleActionControllerAction.new(parent, name, inputAction, priority, customMt)
    local self = setmetatable( { } , customMt or VehicleActionControllerAction _mt)

    self.parent = parent
    self.name = name
    self.inputAction = inputAction
    self.priority = priority
    self.lastDirection = - 1
    self.lastValidDirection = 0
    self.isSaved = false
    self.resetOnDeactivation = true
    self.identifier = ""

    self.aiEventListener = { }

    return self
end

```

### onAIEvent

**Description**

**Definition**

> onAIEvent()

**Arguments**

| any | eventName |
|-----|-----------|

**Code**

```lua
function VehicleActionControllerAction:onAIEvent(eventName)
    for _, listener in ipairs( self.aiEventListener) do
        if listener.eventName = = eventName then
            if not self:doAction(listener.direction, true ) and listener.forceUntilFinished then
                self.forceDirectionUntilFinished = listener.direction
            else
                    if self.forceDirectionUntilFinished ~ = nil then
                        if listener.direction ~ = self.forceDirectionUntilFinished then
                            self.forceDirectionUntilFinished = nil
                        end
                    end

                    self.parent:stopActionSequence()
                end
            end
        end
    end

```

### registerActionEvents

**Description**

**Definition**

> registerActionEvents()

**Arguments**

| any | target                          |
|-----|---------------------------------|
| any | vehicle                         |
| any | actionEvents                    |
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function VehicleActionControllerAction:registerActionEvents(target, vehicle, actionEvents, isActiveForInput, isActiveForInputIgnoreSelection)
    --local _, actionEventId = vehicle:addActionEvent(actionEvents, self.inputAction, target, VehicleActionControllerAction.onActionEvent, false, true, false, true)
    --g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
end

```

### remove

**Description**

**Definition**

> remove()

**Code**

```lua
function VehicleActionControllerAction:remove()
    self.parent:removeAction( self )
end

```

### setActionIcons

**Description**

**Definition**

> setActionIcons()

**Arguments**

| any | iconPos     |
|-----|-------------|
| any | iconNeg     |
| any | changeColor |

**Code**

```lua
function VehicleActionControllerAction:setActionIcons(iconPos, iconNeg, changeColor)
    self.iconPos = iconPos
    self.iconNeg = iconNeg
    self.iconChangeColor = changeColor
end

```

### setCallback

**Description**

**Definition**

> setCallback()

**Arguments**

| any | callbackTarget   |
|-----|------------------|
| any | inputCallback    |
| any | inputCallbackRev |

**Code**

```lua
function VehicleActionControllerAction:setCallback(callbackTarget, inputCallback, inputCallbackRev)
    self.callbackTarget = callbackTarget
    self.inputCallback = inputCallback
    self.inputCallbackRev = inputCallbackRev

    self.identifier = callbackTarget.configFileName or ""
end

```

### setDeactivateFunction

**Description**

**Definition**

> setDeactivateFunction()

**Arguments**

| any | deactivateFunctionTarget |
|-----|--------------------------|
| any | deactivateFunc           |
| any | inverseDeactivateFunc    |

**Code**

```lua
function VehicleActionControllerAction:setDeactivateFunction(deactivateFunctionTarget, deactivateFunc, inverseDeactivateFunc)
    self.deactivateFunctionTarget = deactivateFunctionTarget
    self.deactivateFunc = deactivateFunc
    self.inverseDeactivateFunc = Utils.getNoNil(inverseDeactivateFunc, false )
end

```

### setFinishedFunctions

**Description**

**Definition**

> setFinishedFunctions()

**Arguments**

| any | finishedFunctionTarget |
|-----|------------------------|
| any | finishedFunc           |
| any | finishedResult         |
| any | finishedResultRev      |
| any | finishedFuncRev        |

**Code**

```lua
function VehicleActionControllerAction:setFinishedFunctions(finishedFunctionTarget, finishedFunc, finishedResult, finishedResultRev, finishedFuncRev)
    self.finishedFunctionTarget = finishedFunctionTarget
    self.finishedFunc = finishedFunc
    self.finishedFuncRev = finishedFuncRev
    self.finishedResult = finishedResult
    self.finishedResultRev = finishedResultRev
end

```

### setIsAccessibleFunction

**Description**

**Definition**

> setIsAccessibleFunction()

**Arguments**

| any | accessibleFunc |
|-----|----------------|

**Code**

```lua
function VehicleActionControllerAction:setIsAccessibleFunction(accessibleFunc)
    self.accessibleFunc = accessibleFunc
end

```

### setIsAvailableFunction

**Description**

**Definition**

> setIsAvailableFunction()

**Arguments**

| any | availableFunc |
|-----|---------------|

**Code**

```lua
function VehicleActionControllerAction:setIsAvailableFunction(availableFunc)
    self.availableFunc = availableFunc
end

```

### setIsSaved

**Description**

**Definition**

> setIsSaved()

**Arguments**

| any | isSaved |
|-----|---------|

**Code**

```lua
function VehicleActionControllerAction:setIsSaved(isSaved)
    self.isSaved = isSaved
end

```

### setResetOnDeactivation

**Description**

**Definition**

> setResetOnDeactivation()

**Arguments**

| any | resetOnDeactivation |
|-----|---------------------|

**Code**

```lua
function VehicleActionControllerAction:setResetOnDeactivation(resetOnDeactivation)
    self.resetOnDeactivation = resetOnDeactivation
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
function VehicleActionControllerAction:update(dt)
    if self.deactivateFunc ~ = nil then
        if self.lastDirection = = 1 then
            if self.deactivateFunc( self.deactivateFunctionTarget) = = not self.inverseDeactivateFunc then
                if self.parent.currentSequenceIndex = = nil and self.forceDirectionUntilFinished = = nil then
                    self.parent:startActionSequence()
                end
            end
        end
    end
end

```

### updateForAI

**Description**

**Definition**

> updateForAI()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function VehicleActionControllerAction:updateForAI(dt)
    if self.forceDirectionUntilFinished ~ = nil then
        if self:doAction( self.forceDirectionUntilFinished) then
            self.forceDirectionUntilFinished = nil
            self.parent:stopActionSequence()
        end
    end
end

```

### updateParent

**Description**

**Definition**

> updateParent()

**Arguments**

| any | parent |
|-----|--------|

**Code**

```lua
function VehicleActionControllerAction:updateParent(parent)
    if parent ~ = self.parent then
        self.parent:removeAction( self )
        parent:addAction( self )
    end

    self.parent = parent
end

```