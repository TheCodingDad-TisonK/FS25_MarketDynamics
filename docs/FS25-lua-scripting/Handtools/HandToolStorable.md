## HandToolStorable

**Description**

> The hand tool specialisation for any hand tool that can be stored in a HandToolHolder.

**Functions**

- [getHolsterNodeByType](#getholsternodebytype)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### getHolsterNodeByType

**Description**

**Definition**

> getHolsterNodeByType()

**Arguments**

| any | typeName |
|-----|----------|

**Code**

```lua
function HandToolStorable:getHolsterNodeByType(typeName)
    local spec = self.spec_storable
    if spec.holderHolsterNodes = = nil then
        return nil
    end

    return spec.holderHolsterNodes[typeName]
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | xmlFile |
|-----|---------|

**Code**

```lua
function HandToolStorable:onLoad(xmlFile)
    local spec = self.spec_storable

    -- A collection of nodes keyed by holder type.If a holder's type is not a key in this table, then the tool cannot be stored in it.
    spec.holderHolsterNodes = { }

    for _, key in xmlFile:iterator( "handTool.storable.holderType" ) do
        local holderType = xmlFile:getValue(key .. "#type" , nil )
        if holderType = = nil then
            Logging.xmlError(xmlFile, "HandToolStorable has a holder type with a missing type!" )
            continue
        end

        local holderNode = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if holderNode ~ = nil then
            spec.holderHolsterNodes[holderType] = holderNode
        end
    end
end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function HandToolStorable.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolStorable.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolStorable )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolStorable.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "getHolsterNodeByType" , HandToolStorable.getHolsterNodeByType)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | xmlSchema |
|-----|-----------|

**Code**

```lua
function HandToolStorable.registerXMLPaths(xmlSchema)
    local basePath = "handTool.storable.holderType(?)"

    xmlSchema:setXMLSpecializationType( "HandToolStorable" )
    xmlSchema:register(XMLValueType.STRING, basePath .. "#type" , "The type of holder that can be used" , nil , true )
    xmlSchema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "The node used to orient the tool in the holder" )
    xmlSchema:setXMLSpecializationType()
end

```