## AIParameterGroup

**Functions**

- [addParameter](#addparameter)
- [getParameters](#getparameters)
- [getTitle](#gettitle)
- [new](#new)

### addParameter

**Description**

**Definition**

> addParameter()

**Arguments**

| any | parameter |
|-----|-----------|

**Code**

```lua
function AIParameterGroup:addParameter(parameter)
    table.insert( self.parameters, parameter)
end

```

### getParameters

**Description**

**Definition**

> getParameters()

**Code**

```lua
function AIParameterGroup:getParameters()
    return self.parameters
end

```

### getTitle

**Description**

**Definition**

> getTitle()

**Code**

```lua
function AIParameterGroup:getTitle()
    return self.title
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | title    |
|-----|----------|
| any | customMt |

**Code**

```lua
function AIParameterGroup.new(title, customMt)
    local self = setmetatable( { } , customMt or AIParameterGroup _mt)

    self.parameters = { }
    self.title = title

    return self
end

```