## DynamicallyLoadedParts

**Description**

> Specialization for loading and linking external i3d files/assets (e.g. wheelChocks) to a vehicle

**Functions**

- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onDynamicallyPartI3DLoaded](#ondynamicallyparti3dloaded)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function DynamicallyLoadedParts.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "DynamicallyLoadedParts" )

    local basePath = "vehicle.dynamicallyLoadedParts.dynamicallyLoadedPart(?)"
    schema:register(XMLValueType.STRING, basePath .. "#filename" , "Filename to i3d file" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Node in external i3d file" , "0|0" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#linkNode" , "Link node" , "0>" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#position" , "Position" , "0 0 0" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#rotationNode" , "Rotation node" , "node" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. "#rotation" , "Rotation node rotation" )
    schema:register(XMLValueType.STRING, basePath .. "#shaderParameterName" , "Shader parameter name" )
    schema:register(XMLValueType.VECTOR_ 4 , basePath .. "#shaderParameter" , "Shader parameter to apply" )

    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function DynamicallyLoadedParts:onDelete()
    local spec = self.spec_dynamicallyLoadedParts

    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
    end
end

```

### onDynamicallyPartI3DLoaded

**Description**

**Definition**

> onDynamicallyPartI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function DynamicallyLoadedParts:onDynamicallyPartI3DLoaded(i3dNode, failedReason, args)
    local spec = self.spec_dynamicallyLoadedParts

    local xmlFile = args.xmlFile
    local partKey = args.partKey
    local dynamicallyLoadedPart = args.dynamicallyLoadedPart

    if i3dNode = = 0 then
        Logging.xmlWarning(xmlFile, "Failed to load dynamicallyLoadedPart '%s'.Unable to load i3d" , partKey)
        return false
    end

    local node = xmlFile:getValue(partKey .. "#node" , "0|0" , i3dNode)
    if node = = nil then
        Logging.xmlWarning(xmlFile, "Failed to load dynamicallyLoadedPart '%s'.Unable to find node in loaded i3d" , partKey)
        delete(i3dNode)
        return false
    end

    local linkNode = xmlFile:getValue(partKey .. "#linkNode" , "0>" , self.components, self.i3dMappings)
    if linkNode = = nil then
        Logging.xmlWarning(xmlFile, "Failed to load dynamicallyLoadedPart '%s'.Unable to find linkNode" , partKey)
        delete(i3dNode)
        return false
    else
            local isReference, filename, runtimeLoaded = getReferenceInfo(linkNode)
            if isReference and runtimeLoaded then
                local xmlName = Utils.getFilenameInfo(dynamicallyLoadedPart.filename, true )
                local i3dName = Utils.getFilenameInfo(filename, true )

                if xmlName ~ = i3dName then
                    Logging.xmlWarning(xmlFile, "DynamicallyLoadedPart '%s' loading different file from XML compared to i3D. (XML: %s vs i3D: %s)" , getName(linkNode), xmlName, i3dName)
                end

                Logging.xmlWarning(xmlFile, "DynamicallyLoadedPart link node '%s' is a runtime loaded reference.Please load it either via XML or the i3D reference, but not both!" , getName(linkNode))
                delete(i3dNode)
                return
            end
        end

        local x, y, z = xmlFile:getValue(partKey .. "#position" )
        if x ~ = nil and y ~ = nil and z ~ = nil then
            setTranslation(node, x, y, z)
        else
                setTranslation(node, 0 , 0 , 0 )
            end

            setRotation(node, 0 , 0 , 0 )

            local rotationNode = xmlFile:getValue(partKey .. "#rotationNode" , node, i3dNode)
            local rotX, rotY, rotZ = xmlFile:getValue(partKey .. "#rotation" )
            if rotX ~ = nil and rotY ~ = nil and rotZ ~ = nil then
                setRotation(rotationNode, rotX, rotY, rotZ)
            end

            local shaderParameterName = xmlFile:getValue(partKey .. "#shaderParameterName" )
            local sx, sy, sz, sw = xmlFile:getValue(partKey .. "#shaderParameter" )
            if shaderParameterName ~ = nil and sx ~ = nil and sy ~ = nil and sz ~ = nil and sw ~ = nil then
                setShaderParameter(node, shaderParameterName, sx, sy, sz, sw, false )
            end

            link(linkNode, node)
            delete(i3dNode)

            table.insert(spec.parts, dynamicallyLoadedPart)

            return true
        end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function DynamicallyLoadedParts:onLoad(savegame)
    local spec = self.spec_dynamicallyLoadedParts

    spec.sharedLoadRequestIds = { }
    spec.parts = { }

    self.xmlFile:iterate( "vehicle.dynamicallyLoadedParts.dynamicallyLoadedPart" , function (_, partKey)
        local filename = self.xmlFile:getValue(partKey .. "#filename" )
        if filename ~ = nil then
            local dynamicallyLoadedPart = { }
            dynamicallyLoadedPart.filename = Utils.getFilename(filename, self.baseDirectory)
            local arguments = {
            xmlFile = self.xmlFile,
            partKey = partKey,
            dynamicallyLoadedPart = dynamicallyLoadedPart
            }
            local sharedLoadRequestId = self:loadSubSharedI3DFile(dynamicallyLoadedPart.filename, false , false , self.onDynamicallyPartI3DLoaded, self , arguments)
            table.insert(spec.sharedLoadRequestIds, sharedLoadRequestId)
        else
                Logging.xmlWarning( self.xmlFile, "Missing filename for dynamically loaded part '%s'" , partKey)
                end
            end )
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
function DynamicallyLoadedParts.prerequisitesPresent(specializations)
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
function DynamicallyLoadedParts.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , DynamicallyLoadedParts )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , DynamicallyLoadedParts )
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
function DynamicallyLoadedParts.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onDynamicallyPartI3DLoaded" , DynamicallyLoadedParts.onDynamicallyPartI3DLoaded)
end

```