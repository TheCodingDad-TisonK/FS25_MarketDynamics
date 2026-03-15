## MultiOptionElement

**Description**

> Multiple choice text element.

**Parent**

> [MultiTextOptionElement](?version=script&category=27&class=221)

**Functions**

- [copyAttributes](#copyattributes)
- [getState](#getstate)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setState](#setstate)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function MultiOptionElement:copyAttributes(src)
    MultiOptionElement:superClass().copyAttributes( self , src)
end

```

### getState

**Description**

**Definition**

> getState()

**Code**

```lua
function MultiOptionElement:getState()
    return self.state
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function MultiOptionElement:loadFromXML(xmlFile, key)
    MultiOptionElement:superClass().loadFromXML( self , xmlFile, key)
end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function MultiOptionElement:loadProfile(profile, applyProfile)
    MultiOptionElement:superClass().loadProfile( self , profile, applyProfile)
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function MultiOptionElement.new(target, custom_mt)
    local self = MultiTextOptionElement.new(target, custom_mt or MultiOptionElement _mt)

    self.options = { }

    return self
end

```

### setState

**Description**

**Definition**

> setState()

**Arguments**

| any | state      |
|-----|------------|
| any | forceEvent |

**Code**

```lua
function MultiOptionElement:setState(state, forceEvent)
    MultiOptionElement:superClass().setState( self , state, forceEvent)
end

```