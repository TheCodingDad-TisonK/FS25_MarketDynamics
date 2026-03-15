## AnimationValueBool

**Description**

> Animation value with a boolean as type

**Parent**

> [AnimationValueFloat](?version=script&category=91&class=880)

**Functions**

- [init](#init)
- [load](#load)
- [new](#new)
- [postInit](#postinit)
- [reset](#reset)
- [update](#update)

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
function AnimationValueBool:init(index, numParts)
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
function AnimationValueBool:load(xmlFile, key)
    self.value = xmlFile:getValue(key .. "#" .. self.startName)

    self.warningInfo = key
    self.xmlFile = xmlFile

    return self.value ~ = nil and self:extraLoad(xmlFile, key)
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
function AnimationValueBool.new(vehicle, animation, part, startName, endName, name, initialUpdate, get, set, extraLoad, customMt)
    return AnimationValueFloat.new(vehicle, animation, part, startName, endName, name, initialUpdate, get, set, extraLoad, customMt or AnimationValueBool _mt)
end

```

### postInit

**Description**

**Definition**

> postInit()

**Code**

```lua
function AnimationValueBool:postInit()
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function AnimationValueBool:reset()
    self.curValue = nil
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | durationToEnd |
|-----|---------------|
| any | dtToUse       |
| any | realDt        |

**Code**

```lua
function AnimationValueBool:update(durationToEnd, dtToUse, realDt)
    if self.curValue = = nil then
        self.curValue = self:get()
    end

    if self.value ~ = self.curValue then
        self.curValue = self.value
        self:set( self.value)
        return true
    end

    return false
end

```