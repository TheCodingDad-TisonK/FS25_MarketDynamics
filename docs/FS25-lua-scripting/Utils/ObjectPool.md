## ObjectPool

**Description**

> Holds a collection of pooled objects and handles creating new ones when the pool is empty.

**Functions**

- [clear](#clear)
- [getLength](#getlength)
- [getOrCreateNext](#getorcreatenext)
- [new](#new)
- [returnToPool](#returntopool)

### clear

**Description**

> Removes all instances from the pool's collections.

**Definition**

> clear()

**Code**

```lua
function ObjectPool:clear()
    table.clear( self.poolSet)
    table.clear( self.pool)
end

```

### getLength

**Description**

> Gets the total count of objects in the pool.

**Definition**

> getLength()

**Return Values**

| any | count | The number of items in the pool. |
|-----|-------|----------------------------------|

**Code**

```lua
function ObjectPool:getLength()
    -- TODO:Replace with __len metafunction in Lua 5.2
    return # self.pool
end

```

### getOrCreateNext

**Description**

> Gets and returns an instance from the pool, or creates one if the pool is empty.

**Definition**

> getOrCreateNext()

**Return Values**

| any | instance | The pooled or created object. |
|-----|----------|-------------------------------|

**Code**

```lua
function ObjectPool:getOrCreateNext()

    -- Get the next object in the pool.
    local instance = table.remove( self.pool)

    -- If there was no object in the pool, create a new one.
    if not instance then

        -- If the constructor is the default empty table, skip the unpacking.
        if self.objectConstructor = = ObjectPool.EMPTY_TABLE_CONSTRUCTOR then
            instance = self.objectConstructor()
            -- Otherwise; unpack the arguments and call the constructor.
        else
                instance = self.objectConstructor( table.unpack( self.objectConstructorArguments, 1 , self.objectConstructorArguments.n))
            end
            -- Otherwise; also remove the object from the set.
        else
                self.poolSet[instance] = nil
            end

            -- Return the created or gotten object.
            return instance
        end

```

### new

**Description**

> Creates a new object pool with the given constructor.

**Definition**

> new(function? objectConstructor, any ...)

**Arguments**

| function? | objectConstructor | The constructor function to call in order to create new objects when the pool is empty. If this is nil, ObjectPool.EMPTY_TABLE_CONSTRUCTOR will be used. |
|-----------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| any       | ...               | The arguments to pass through to the constructor.                                                                                                        |

**Return Values**

| any | instance | The created instance. |
|-----|----------|-----------------------|

**Code**

```lua
function ObjectPool.new(objectConstructor, .. .)

    -- Ensure a constructor was given or is nil.
    --#debug Assert.isNilOrType(objectConstructor, "function", "Object constructor was not a function or nil!")

        -- Create the instance.
        local self = setmetatable( { } , ObjectPool _mt)

        -- The object constructor and arguments.
        self.objectConstructor = objectConstructor or ObjectPool.EMPTY_TABLE_CONSTRUCTOR
        self.objectConstructorArguments = table.pack( .. .)

        -- The pool of objects.
        self.pool = { }

        -- The set of pooled objects to avoid duplicates.
        self.poolSet = { }

        -- Return the created instance.
        return self
    end

```

### returnToPool

**Description**

> Returns the given instance to the pool.

**Definition**

> returnToPool(table instance)

**Arguments**

| table | instance | The instance to return to the pool. |
|-------|----------|-------------------------------------|

**Code**

```lua
function ObjectPool:returnToPool(instance)

    -- Ensure the given instance exists.
    if instance = = nil then
        return false
    end
    --#debug Assert.isType(instance, "table", "Given instance was not a table!")

    -- Ensure the object is not already pooled.
    if self.poolSet[instance] ~ = nil then
        return false
    end

    -- If the object constructor is the default empty table, clear the table.
    if self.objectConstructor = = ObjectPool.EMPTY_TABLE_CONSTRUCTOR then
        table.clear(instance)
        -- Otherwise; if the instance has a reset function, call it.
        elseif instance.reset ~ = nil then
                instance:reset()
            end

            -- Add the object to the collections.
            table.insert( self.pool, instance)
            self.poolSet[instance] = instance

            -- Return true, as the addition was a success.
            return true
        end

```