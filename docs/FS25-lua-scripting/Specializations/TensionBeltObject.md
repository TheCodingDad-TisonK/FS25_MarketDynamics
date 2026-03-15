## TensionBeltObject

**Description**

> Specialization for vehicles which can be mounted by tension belts

**Functions**

- [getMeshNodes](#getmeshnodes)
- [getSupportsTensionBelts](#getsupportstensionbelts)
- [getTensionBeltNodeId](#gettensionbeltnodeid)
- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)

### getMeshNodes

**Description**

**Definition**

> getMeshNodes()

**Code**

```lua
function TensionBeltObject:getMeshNodes()
    return self.spec_tensionBeltObject.meshNodes
end

```

### getSupportsTensionBelts

**Description**

**Definition**

> getSupportsTensionBelts()

**Code**

```lua
function TensionBeltObject:getSupportsTensionBelts()
    return self.spec_tensionBeltObject.supportsTensionBelts
end

```

### getTensionBeltNodeId

**Description**

**Definition**

> getTensionBeltNodeId()

**Code**

```lua
function TensionBeltObject:getTensionBeltNodeId()
    return self.components[ 1 ].node
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function TensionBeltObject.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "TensionBeltObject" )

    schema:register(XMLValueType.BOOL, "vehicle.tensionBeltObject#supportsTensionBelts" , "Supports tension belts" , true )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.tensionBeltObject.meshNodes.meshNode(?)#node" , "Mesh node for tension belt calculation" )

        schema:setXMLSpecializationType()
    end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function TensionBeltObject:onLoad(savegame)
    local spec = self.spec_tensionBeltObject

    spec.supportsTensionBelts = self.xmlFile:getValue( "vehicle.tensionBeltObject#supportsTensionBelts" , true )

    spec.meshNodes = { }
    for _, meshNodeKey in self.xmlFile:iterator( "vehicle.tensionBeltObject.meshNodes.meshNode" ) do
        local node = self.xmlFile:getValue(meshNodeKey .. "#node" , nil , self.components, self.i3dMappings)
        if node = = nil then
            continue
        end

        if not getHasClassId(node, ClassIds.SHAPE) then
            Logging.xmlWarning( self.xmlFile, "Node %q at %q is not a shape" , I3DUtil.getNodePath(node), meshNodeKey)
            continue
        end

        if not getShapeIsCPUMesh(node) then
            Logging.xmlWarning( self.xmlFile, "Mesh node %q at %q does not have the 'CPU-Mesh' flag(Shape settings) enabled which required for tension belts" , I3DUtil.getNodePath(node), meshNodeKey)
                continue
            end

            table.insert(spec.meshNodes, node)
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
function TensionBeltObject.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function TensionBeltObject.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , TensionBeltObject )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function TensionBeltObject.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getSupportsTensionBelts" , TensionBeltObject.getSupportsTensionBelts)
    SpecializationUtil.registerFunction(vehicleType, "getMeshNodes" , TensionBeltObject.getMeshNodes)
    SpecializationUtil.registerFunction(vehicleType, "getTensionBeltNodeId" , TensionBeltObject.getTensionBeltNodeId)
end

```