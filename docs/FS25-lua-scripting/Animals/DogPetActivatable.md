## DogPetActivatable

**Functions**

- [getDistance](#getdistance)
- [getIsActivatable](#getisactivatable)
- [new](#new)
- [run](#run)

### getDistance

**Description**

**Definition**

> getDistance()

**Arguments**

| any | posX |
|-----|------|
| any | posY |
| any | posZ |

**Code**

```lua
function DogPetActivatable:getDistance(posX, posY, posZ)
    local distance = self.dog:getDistanceTo(posX, posY, posZ)
    return distance
end

```

### getIsActivatable

**Description**

**Definition**

> getIsActivatable()

**Code**

```lua
function DogPetActivatable:getIsActivatable()
    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | dog |
|-----|-----|

**Code**

```lua
function DogPetActivatable.new(dog)
    local self = setmetatable( { } , DogPetActivatable _mt)

    self.dog = dog

    self.activateText = g_i18n:getText( "action_petAnimal" )

    return self
end

```

### run

**Description**

**Definition**

> run()

**Code**

```lua
function DogPetActivatable:run()
    self.dog:pet()
end

```