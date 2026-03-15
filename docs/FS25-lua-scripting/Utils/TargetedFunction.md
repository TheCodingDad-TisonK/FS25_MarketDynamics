## TargetedFunction

**Description**

> Holds a function and an optional target object to make event functions simpler.

**Functions**

- [delete](#delete)
- [invoke](#invoke)
- [new](#new)
- [resolveListener](#resolvelistener)
- [unpackCombinedArguments](#unpackcombinedarguments)

### delete

**Description**

> Unbinds the function and target.

**Definition**

> delete()

**Code**

```lua
function TargetedFunction:delete()
    self.targetFunction = nil
    self.targetObject = nil
end

```

### invoke

**Description**

> Calls the function with the given arguments.

**Definition**

> invoke(any ...)

**Arguments**

| any | ... | The collection of arguments to pass to the function. |
|-----|-----|------------------------------------------------------|

**Return Values**

| any | value | The return value of the function. |
|-----|-------|-----------------------------------|

**Code**

```lua
function TargetedFunction:invoke( .. .)

    -- Call the function with the optional object.
        if self.targetObject then
            if self.arguments.n = = 0 then
                return self.targetFunction( self.targetObject, .. .)
            else
                    return self.targetFunction( self.targetObject, self:unpackCombinedArguments( .. .))
                end
            else
                    if self.arguments.n = = 0 then
                        return self.targetFunction( .. .)
                    else
                            return self.targetFunction( self:unpackCombinedArguments( .. .))
                        end
                    end
                end

```

### new

**Description**

> Creates a new listener function with the given function and target object.

**Definition**

> new(function targetFunction, table? targetObject, any ...)

**Arguments**

| function | targetFunction | The function that is called.                   |
|----------|----------------|------------------------------------------------|
| table?   | targetObject   | The optional object used to call the function. |
| any      | ...            | optional arguments for the function            |

**Return Values**

| any | instance | The created instance. |
|-----|----------|-----------------------|

**Code**

```lua
function TargetedFunction.new(targetFunction, targetObject, .. .)

    --#debug assert(type(targetFunction) = = "function", "Given listener function was not a function.")
        --#debugif targetObject ~ = nil then
        --#debug assert(type(targetObject) = = "table", "Given target object was not a table.")
        --#debug end

        -- Create the instance.
        local self = setmetatable( { } , TargetedFunction _mt)

        -- Set the values.
        self.targetFunction = targetFunction
        self.targetObject = targetObject

        -- The arguments of the function.
            self.arguments = table.pack( .. .)

            -- Return the created instance.
            return self
        end

```

### resolveListener

**Description**

> Takes a listener function and an optional target object. If the listener function is a TargetedFunction, returns it
> as-is. Otherwise; wraps the function and optional target object in a TargetedFunction and returns it.

**Definition**

> resolveListener(function targetFunction, table? targetObject)

**Arguments**

| function | targetFunction | The function or TargetedFunction to wrap or return.    |
|----------|----------------|--------------------------------------------------------|
| table?   | targetObject   | The optional target object, used to wrap the function. |

**Return Values**

| table? | targetFunction | The wrapped or returned TargetedFunction. |
|--------|----------------|-------------------------------------------|

**Code**

```lua
function TargetedFunction.resolveListener(targetFunction, targetObject)

    -- If the target function is a function, wrap it in a TargetedFunction and return it.
        if type(targetFunction) = = "function" then
            return TargetedFunction.new(targetFunction, targetObject)
            -- Otherwise; assume it's already a TargetedFunction and return it as-is.
        else
                return targetFunction
            end
        end

```

### unpackCombinedArguments

**Description**

> Combines this function's arguments with the given arguments, returning each value separately.

**Definition**

> unpackCombinedArguments(any ...)

**Arguments**

| any | ... | The arguments to pack. |
|-----|-----|------------------------|

**Return Values**

| any | ... | Multiple values, starting with each element in this function's arguments, then each element in the given arguments. |
|-----|-----|---------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function TargetedFunction:unpackCombinedArguments( .. .)
    return table.unpack( table.getListUnion( self.arguments, table.pack( .. .)))
end

```