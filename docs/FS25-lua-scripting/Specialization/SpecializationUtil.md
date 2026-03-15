## SpecializationUtil

**Description**

> Specialization util class

**Functions**

- [copyTypeFunctionsInto](#copytypefunctionsinto)
- [createLoadingTask](#createloadingtask)
- [finishLoadingTask](#finishloadingtask)
- [getIsValidLoadingStep](#getisvalidloadingstep)
- [hasSpecialization](#hasspecialization)
- [initSpecializationsIntoTypeClass](#initspecializationsintotypeclass)
- [raiseAsyncEvent](#raiseasyncevent)
- [raiseEvent](#raiseevent)
- [registerEvent](#registerevent)
- [registerEventListener](#registereventlistener)
- [registerFunction](#registerfunction)
- [registerOverwrittenFunction](#registeroverwrittenfunction)
- [removeEventListener](#removeeventlistener)
- [setLoadingStep](#setloadingstep)

### copyTypeFunctionsInto

**Description**

> Copies the functions from the given type into the given target object.

**Definition**

> copyTypeFunctionsInto(table typeDef, table target)

**Arguments**

| table | typeDef | The type to copy from.         |
|-------|---------|--------------------------------|
| table | target  | The target table to copy into. |

**Code**

```lua
function SpecializationUtil.copyTypeFunctionsInto(typeDef, target)
    for funcName, func in pairs(typeDef.functions) do
        target[funcName] = func
    end
end

```

### createLoadingTask

**Description**

> Creates a loading task on the given typeClass's loadingTasks table with the given target and returns it.

**Definition**

> createLoadingTask(table typeClass, any target)

**Arguments**

| table | typeClass | The class instance of the specialisation type.      |
|-------|-----------|-----------------------------------------------------|
| any   | target    | The id or reference used to track the loading task. |

**Return Values**

| any | task | The created loading task. |
|-----|------|---------------------------|

**Code**

```lua
function SpecializationUtil.createLoadingTask(typeClass, target)

    --#debug Assert.isType(typeClass.loadingTasks, "table", "Type class is missing loadingTasks table!")

    -- Create, add, and return the task.
    local task = {
    target = target,
    --#debug callstack = debug.traceback()
    }

    table.insert(typeClass.loadingTasks, task)

    return task
end

```

### finishLoadingTask

**Description**

> Marks the given task as done, and calls the onFinishedLoading function of the given typeClass, if its
> readyForFinishLoading value evaluates to true.

**Definition**

> finishLoadingTask(table typeClass, table task)

**Arguments**

| table | typeClass | The class instance of the specialisation type.                                              |
|-------|-----------|---------------------------------------------------------------------------------------------|
| table | task      | The task to mark as complete. Should be obtained from SpecializationUtil.createLoadingTask. |

**Code**

```lua
function SpecializationUtil.finishLoadingTask(typeClass, task)

    --#debug Assert.isType(typeClass.onFinishedLoading, "function", "Type class is missing onFinishedLoading function!")
        --#debug Assert.isType(typeClass.loadingTasks, "table", "Type class is missing loadingTasks table! This can be caused by a lack of calls to createLoadingTask, in such a way that the loading completes instantly")
        --#debug Assert.greaterThan(#typeClass.loadingTasks, 0, "Nothing was loading, yet a task was finished!")

        -- Remove the task from the list.If it does not get removed, log a warning but still continue like normal.
        if not table.removeElement(typeClass.loadingTasks, task) then
            Logging.warning( "Loading task was marked as finished, but was never added in the first place.Ensure that every finishLoadingTask call uses a task given from the createLoadingTask function." )
            end

            -- If the type class is ready for the finish loading call, and all tasks have been completed, call the onFinishedLoading function.
                if typeClass.readyForFinishLoading and #typeClass.loadingTasks = = 0 then
                    typeClass:onFinishedLoading()
                end
            end

```

### getIsValidLoadingStep

**Description**

> Checks if the given loading step is a valid enum value of SpecializationLoadStep.

**Definition**

> getIsValidLoadingStep(SpecializationLoadStep loadingStep)

**Arguments**

| SpecializationLoadStep | loadingStep | The loading step to check. |
|------------------------|-------------|----------------------------|

**Return Values**

| SpecializationLoadStep | isValid | True if the given loadingStep is a valid enum value; otherwise false. |
|------------------------|---------|-----------------------------------------------------------------------|

**Code**

```lua
function SpecializationUtil.getIsValidLoadingStep(loadingStep)

    -- Check the given value against each value in the enum.If it matches any; return true.
    for _, value in pairs(SpecializationLoadStep) do
        if value = = loadingStep then
            return true
        end
    end

    -- Otherwise; since no match was found, return false.
    return false
end

```

### hasSpecialization

**Description**

> Checks if a specialzation is in a list of specializations

**Definition**

> hasSpecialization(table spec, table specializations)

**Arguments**

| table | spec            | a specialization class  |
|-------|-----------------|-------------------------|
| table | specializations | list of specializations |

**Return Values**

| table | true | if spec is in specialization list |
|-------|------|-----------------------------------|

**Code**

```lua
function SpecializationUtil.hasSpecialization(spec, specializations)
    for _,v in pairs(specializations) do
        if v = = spec then
            return true
        end
    end

    return false
end

```

### initSpecializationsIntoTypeClass

**Description**

**Definition**

> initSpecializationsIntoTypeClass(any typeManager, any typeDef, table target)

**Arguments**

| any   | typeManager |
|-------|-------------|
| any   | typeDef     |
| table | target      |

**Return Values**

| table | typeDef |
|-------|---------|

**Code**

```lua
function SpecializationUtil.initSpecializationsIntoTypeClass(typeManager, typeDef, target)
    target.type = typeDef
    target.typeName = typeDef.name
    target.specializations = typeDef.specializations
    target.specializationNames = typeDef.specializationNames
    target.specializationsByName = typeDef.specializationsByName
    target.eventListeners = table.clone(typeDef.eventListeners, 2 )

    return typeDef
end

```

### raiseAsyncEvent

**Description**

> Raises a specialization event async

**Definition**

> raiseAsyncEvent(table object, string eventName, any ...)

**Arguments**

| table  | object    | an object that supports specializations |
|--------|-----------|-----------------------------------------|
| string | eventName | the event name                          |
| any    | ...       | the parameters                          |

**Code**

```lua
function SpecializationUtil.raiseAsyncEvent(object, eventName, .. .)
    if object.eventListeners[eventName] = = nil then
        local typeName = object.type and object.type.name or "<unknown>"
        printError( string.format( "Error:Event %q is not registered for type %q!" , eventName, typeName))
            printCallstack()
            return
        end

        local args = { .. . }
        for _, spec in ipairs(object.eventListeners[eventName]) do
            object:addAsyncTask( function ()
                --#profile local doProfiling, profileName = Vehicle.PROFILE_EVENTS[eventName], spec.className .. ":" .. eventName
                --#profile if doProfiling then RemoteProfiler.zoneBeginN(profileName) end
                spec[eventName](object, unpack(args))
                --#profile if doProfiling then RemoteProfiler.zoneEnd() end
            end , spec.className, false )
        end
    end

```

### raiseEvent

**Description**

> Raises a specialization event

**Definition**

> raiseEvent(table object, string eventName, any ...)

**Arguments**

| table  | object    | an object that supports specializations |
|--------|-----------|-----------------------------------------|
| string | eventName | the event name                          |
| any    | ...       | the parameters                          |

**Code**

```lua
function SpecializationUtil.raiseEvent(object, eventName, .. .)
    if object.eventListeners[eventName] = = nil then
        local typeName = object.type and object.type.name or "<unknown>"
        printError( string.format( "Error:Event %q is not registered for type %q!" , eventName, typeName))
            printCallstack()
            return
        end

        for _, spec in ipairs(object.eventListeners[eventName]) do
            --#profile local doProfiling, profileName = Vehicle.PROFILE_EVENTS[eventName], spec.className .. ":" .. eventName
            --#profile if doProfiling then RemoteProfiler.zoneBeginN(profileName) end
            spec[eventName](object, .. .)
            --#profile if doProfiling then RemoteProfiler.zoneEnd() end
        end
    end

```

### registerEvent

**Description**

> Registers an event to a given object type

**Definition**

> registerEvent(table objectType, string eventName)

**Arguments**

| table  | objectType | the object type |
|--------|------------|-----------------|
| string | eventName  | the event name  |

**Code**

```lua
function SpecializationUtil.registerEvent(objectType, eventName)
    if string.isNilOrWhitespace(eventName) then
        Logging.error( "Given name for event is 'nil' or empty!" )
            printCallstack()
            return
        end

        if objectType.functions[eventName] ~ = nil then
            Logging.error( "Event '%s' already registered as function in type '%s'!" , eventName, objectType.name)
                printCallstack()
                return
            end

            if objectType.events[eventName] ~ = nil then
                Logging.error( "Event '%s' already registered as event in type '%s'!" , eventName, objectType.name)
                printCallstack()
                return
            end

            objectType.events[eventName] = eventName
            objectType.eventListeners[eventName] = { }
        end

```

### registerEventListener

**Description**

> Registers an event listener to an object type

**Definition**

> registerEventListener(table objectType, string eventName, table specClass)

**Arguments**

| table  | objectType | the object type          |
|--------|------------|--------------------------|
| string | eventName  | the event name           |
| table  | specClass  | the specialization class |

**Code**

```lua
function SpecializationUtil.registerEventListener(objectType, eventName, specClass)
    if string.isNilOrWhitespace(eventName) then
        Logging.error( "Given event name is is 'nil' or empty!" )
        printCallstack()
        return
    end

    local className = specClass.className

    if objectType.eventListeners = = nil then
        Logging.error( "Invalid type for specialization '%s'!" , className)
            printCallstack()
            return
        end

        if specClass[eventName] = = nil then
            Logging.error( "Event listener function '%s' not defined in specialization '%s'!" , eventName, className)
                printCallstack()
                return
            end

            if objectType.eventListeners[eventName] = = nil then
                return
            end

            local found = false
            for _, registeredSpec in pairs(objectType.eventListeners[eventName]) do
                if registeredSpec = = specClass then
                    found = true
                    break
                end
            end

            if found then
                Logging.error( "Event listener for '%s' already registered in specialization '%s'!" , eventName, className)
                    printCallstack()
                    return
                end

                table.insert(objectType.eventListeners[eventName], specClass)
            end

```

### registerFunction

**Description**

> Registers a function to a given object type

**Definition**

> registerFunction(table objectType, string funcName, function func)

**Arguments**

| table    | objectType | the object type      |
|----------|------------|----------------------|
| string   | funcName   | the function name    |
| function | func       | the function pointer |

**Code**

```lua
function SpecializationUtil.registerFunction(objectType, funcName, func)
    if string.isNilOrWhitespace(funcName) then
        Logging.error( "Given function name is is 'nil' or empty!" )
            printCallstack()
            return
        end

        if func = = nil then
            Logging.error( "Given reference for Function '%s' is 'nil'!" , funcName)
                printCallstack()
                return
            end

            if objectType.functions[funcName] ~ = nil then
                Logging.error( "Function '%s' already registered as function in type '%s'!" , funcName, objectType.name)
                    printCallstack()
                    return
                end

                if objectType.events[funcName] ~ = nil then
                    Logging.error( "Function '%s' already registered as event in type '%s'!" , funcName, objectType.name)
                    printCallstack()
                    return
                end

                objectType.functions[funcName] = func
            end

```

### registerOverwrittenFunction

**Description**

> Overwrites a function of an object type

**Definition**

> registerOverwrittenFunction(table objectType, string funcName, function func)

**Arguments**

| table    | objectType | the object type      |
|----------|------------|----------------------|
| string   | funcName   | the function name    |
| function | func       | the function pointer |

**Code**

```lua
function SpecializationUtil.registerOverwrittenFunction(objectType, funcName, func)
    if string.isNilOrWhitespace(funcName) then
        Logging.error( "Given function name is is 'nil' or empty!" )
            printCallstack()
            return
        end

        if func = = nil then
            Logging.error( "Given reference for OverwrittenFunction '%s' is 'nil'!" , funcName)
                printCallstack()
                return
            end

            -- if function does not exist, we don't need to overwrite anything
                if objectType.functions[funcName] ~ = nil then
                    objectType.functions[funcName] = Utils.overwrittenFunction(objectType.functions[funcName], func)
                end
            end

```

### removeEventListener

**Description**

> Removes an event listener from an object

**Definition**

> removeEventListener(table object, string eventName, table specClass)

**Arguments**

| table  | object    | a object that supports specializations |
|--------|-----------|----------------------------------------|
| string | eventName | the event name                         |
| table  | specClass | a specialization class                 |

**Code**

```lua
function SpecializationUtil.removeEventListener(object, eventName, specClass)
    local listeners = object.eventListeners[eventName]
    if listeners ~ = nil then
        for i = #listeners, 1 , - 1 do
            if listeners[i] = = specClass then
                table.remove(listeners, i)
            end
        end
    end
end

```

### setLoadingStep

**Description**

> Sets the loadingStep value of the given specialisation type class, logging an error if the given step is invalid.

**Definition**

> setLoadingStep(table typeClass, SpecializationLoadStep loadingStep)

**Arguments**

| table                  | typeClass   | The class instance of the specialisation type. |
|------------------------|-------------|------------------------------------------------|
| SpecializationLoadStep | loadingStep | The loading step to set.                       |

**Code**

```lua
function SpecializationUtil.setLoadingStep(typeClass, loadingStep)

    -- If the given step type is not a valid SpecializationLoadStep value, log the error and return.
    if not SpecializationUtil.getIsValidLoadingStep(loadingStep) then
        printCallstack()
        Logging.error( "Invalid loading step '%s'!" , loadingStep)
        return
    end

    -- Set the loading step.
    typeClass.loadingStep = loadingStep
end

```