## ListenerList

**Description**

> Holds and manages a collection of functions and target objects

**Functions**

- [invoke](#invoke)
- [new](#new)
- [registerListener](#registerlistener)

### invoke

**Description**

> Calls the listeners with the given arguments.

**Definition**

> invoke(any ..., )

**Arguments**

| any | ... | The collection of arguments to pass to the functions. |
|-----|-----|-------------------------------------------------------|
| any | ... |                                                       |

**Code**

```lua
function ListenerList:invoke(targetObject, .. .)

    -- Invoke each listener.
    if self.ignoreFirstArgument then
        for _, listener in ipairs( self.listeners) do
            listener:invoke( .. .)
        end
    else
            for _, listener in ipairs( self.listeners) do
                listener:invoke(targetObject, .. .)
            end
        end
    end

```

### new

**Description**

> Creates a new listener list.

**Definition**

> new(boolean? ignoreFirstArgument)

**Arguments**

| boolean? | ignoreFirstArgument | If this is true, the first argument is not passed along when invoking. Used to ignore the table instance when the listener list is a member of a table. |
|----------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|

**Return Values**

| boolean? | instance | The created instance. |
|----------|----------|-----------------------|

**Code**

```lua
function ListenerList.new(ignoreFirstArgument)

    -- Create the instance.
    local self = setmetatable( { } , ListenerList _mt)

    -- The collection of listening functions.
    self.listeners = { }

    -- If this is true, the first argument is not passed to the invoked functions.This is useful to ignore the table instance when the listener list is a member of a table.
    self.ignoreFirstArgument = ignoreFirstArgument = = true

    -- Return the created instance.
    return self
end

```

### registerListener

**Description**

> Adds the given listener function and target object to the listeners list.

**Definition**

> registerListener((function|TargetedFunction) listenerFunction, table? targetObject)

**Arguments**

| (function | TargetedFunction) | listenerFunction            | The function or TargetedFunction to add to the list. |
|-----------|-------------------|-----------------------------|------------------------------------------------------|
| table?    | targetObject      | The optional target object. |                                                      |

**Code**

```lua
function ListenerList:registerListener(listenerFunction, targetObject)

    -- Resolve the listener function.
        local listener = TargetedFunction.resolveListener(listenerFunction, targetObject)

        -- Add the listener function to the list.
            table.insert( self.listeners, listener)
        end

```