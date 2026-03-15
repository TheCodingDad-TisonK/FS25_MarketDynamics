## InlineBaleSingle

**Description**

> Class for inline bales

**Parent**

> [Bale](?version=script&category=63&class=579)

**Functions**

- [getBaleSupportsBaleLoader](#getbalesupportsbaleloader)
- [getCanBeOpened](#getcanbeopened)
- [getConnectedInlineBale](#getconnectedinlinebale)
- [getHasConnector](#gethasconnector)
- [new](#new)
- [removeConnector](#removeconnector)
- [setConnectedInlineBale](#setconnectedinlinebale)
- [setConnector](#setconnector)
- [setConnectorVisibility](#setconnectorvisibility)
- [setWrappingState](#setwrappingstate)

### getBaleSupportsBaleLoader

**Description**

**Definition**

> getBaleSupportsBaleLoader()

**Code**

```lua
function InlineBaleSingle:getBaleSupportsBaleLoader()
    return false
end

```

### getCanBeOpened

**Description**

**Definition**

> getCanBeOpened()

**Code**

```lua
function InlineBaleSingle:getCanBeOpened()
    return false
end

```

### getConnectedInlineBale

**Description**

**Definition**

> getConnectedInlineBale()

**Code**

```lua
function InlineBaleSingle:getConnectedInlineBale()
    return self.connectedInlineBale
end

```

### getHasConnector

**Description**

**Definition**

> getHasConnector()

**Code**

```lua
function InlineBaleSingle:getHasConnector()
    return self.inlineConnector ~ = nil
end

```

### new

**Description**

> Creating bale object

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | is server |
|---------|----------|-----------|
| boolean | isClient | is client |
| table?  | customMt | customMt  |

**Return Values**

| table? | instance | Instance of object |
|--------|----------|--------------------|

**Code**

```lua
function InlineBaleSingle.new(isServer, isClient, customMt)
    local self = Bale.new(isServer, isClient, customMt or InlineBaleSingle _mt)
    registerObjectClassName( self , "InlineBaleSingle" )

    self.connectedInlineBale = nil

    return self
end

```

### removeConnector

**Description**

**Definition**

> removeConnector()

**Code**

```lua
function InlineBaleSingle:removeConnector()
    local connector = self.inlineConnector
    if connector ~ = nil then
        if entityExists(connector.joint1) then
            delete(connector.joint1)
        end
        if entityExists(connector.joint2) then
            delete(connector.joint2)
        end
        if entityExists(connector.mesh) then
            delete(connector.mesh)
        end

        if connector.sharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(connector.sharedLoadRequestId)
        end
        self.inlineConnector = nil
    end
end

```

### setConnectedInlineBale

**Description**

**Definition**

> setConnectedInlineBale()

**Arguments**

| any | inlineBale |
|-----|------------|

**Code**

```lua
function InlineBaleSingle:setConnectedInlineBale(inlineBale)
    self.connectedInlineBale = inlineBale
end

```

### setConnector

**Description**

**Definition**

> setConnector()

**Arguments**

| any | connectedBale |
|-----|---------------|
| any | filename      |
| any | axis          |
| any | offset        |

**Code**

```lua
function InlineBaleSingle:setConnector(connectedBale, filename, axis, offset)
    filename = NetworkUtil.convertFromNetworkFilename(filename)
    local rootNode, sharedLoadRequestId = g_i3DManager:loadSharedI3DFile(filename, false , false )
    if rootNode = = 0 then
        return false
    end

    local startNode = getChildAt(rootNode, 0 )
    local endNode = getChildAt(rootNode, 1 )
    local skinnedMesh = getChildAt(rootNode, 2 )
    link(connectedBale.nodeId, endNode)
    link( self.nodeId, startNode)
    link( self.nodeId, skinnedMesh)

    local translation = { 0 , 0 , 0 }
    translation[axis] = offset
    setTranslation(startNode, unpack(translation))

    translation[axis] = - offset
    setTranslation(endNode, unpack(translation))

    delete(rootNode)

    self.inlineConnector = { filename = filename, sharedLoadRequestId = sharedLoadRequestId, mesh = skinnedMesh, joint1 = startNode, joint2 = endNode, isDirty = true }
    setVisibility(skinnedMesh, self.wrappingState > 0 )

    if getHasShaderParameter(skinnedMesh, "colorScale" ) then
        local r, g, b, _ = unpack(connectedBale.wrappingColor)
        setShaderParameter(skinnedMesh, "colorScale" , r, g, b, 1 , false )
    end

    if getHasShaderParameter(skinnedMesh, "scratches_dirt_snow_wetness" ) then
        setShaderParameter(skinnedMesh, "scratches_dirt_snow_wetness" , 0 , 0 , 0 , 0 , false )
    end

    return true
end

```

### setConnectorVisibility

**Description**

**Definition**

> setConnectorVisibility()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function InlineBaleSingle:setConnectorVisibility(state)
    if self:getHasConnector() then
        setVisibility( self.inlineConnector.mesh, state)
    end
end

```

### setWrappingState

**Description**

> Set wrapping state of bale

**Definition**

> setWrappingState(float wrappingState, )

**Arguments**

| float | wrappingState | new wrapping state |
|-------|---------------|--------------------|
| any   | noEventSend   |                    |

**Code**

```lua
function InlineBaleSingle:setWrappingState(wrappingState, noEventSend)
    self:setConnectorVisibility(wrappingState > 0 )

    InlineBaleSingle:superClass().setWrappingState( self , wrappingState, noEventSend)
end

```