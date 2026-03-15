## BunkerSiloInteractor

**Description**

> Specialization for connecting bunker silo callbacks with vehicles

**Functions**

- [notifiyBunkerSilo](#notifiybunkersilo)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [setBunkerSiloInteractorCallback](#setbunkersilointeractorcallback)

### notifiyBunkerSilo

**Description**

**Definition**

> notifiyBunkerSilo()

**Arguments**

| any | changedFillLevel |
|-----|------------------|
| any | fillType         |
| any | x                |
| any | y                |
| any | z                |

**Code**

```lua
function BunkerSiloInteractor:notifiyBunkerSilo(changedFillLevel, fillType, x, y, z)
    local spec = self.spec_bunkerSiloInteractor
    if spec.callback ~ = nil then
        spec.callback(spec.callbackTarget, self , changedFillLevel, fillType, x, y, z)
    end
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function BunkerSiloInteractor:onLoad(savegame)
    local spec = self.spec_bunkerSiloInteractor

    spec.callback = nil
    spec.callbackTarget = nil
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
function BunkerSiloInteractor.prerequisitesPresent(specializations)
    return true
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
function BunkerSiloInteractor.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , BunkerSiloInteractor )
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
function BunkerSiloInteractor.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "setBunkerSiloInteractorCallback" , BunkerSiloInteractor.setBunkerSiloInteractorCallback)
    SpecializationUtil.registerFunction(vehicleType, "notifiyBunkerSilo" , BunkerSiloInteractor.notifiyBunkerSilo)
end

```

### setBunkerSiloInteractorCallback

**Description**

> Set fill level changed callback (e.g. by bunker silo)

**Definition**

> setBunkerSiloInteractorCallback(function callback, table callbackTarget)

**Arguments**

| function | callback       | callback        |
|----------|----------------|-----------------|
| table    | callbackTarget | callback target |

**Code**

```lua
function BunkerSiloInteractor:setBunkerSiloInteractorCallback(callback, callbackTarget)
    local spec = self.spec_bunkerSiloInteractor
    spec.callback = callback
    spec.callbackTarget = callbackTarget
end

```