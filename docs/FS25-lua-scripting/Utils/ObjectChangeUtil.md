## ObjectChangeUtil

**Functions**

- [addAdditionalObjectChangeXMLPaths](#addadditionalobjectchangexmlpaths)
- [loadObjectChangeFromXML](#loadobjectchangefromxml)
- [loadValuesFromXML](#loadvaluesfromxml)
- [registerObjectChangeSingleXMLPaths](#registerobjectchangesinglexmlpaths)
- [registerObjectChangesXMLPaths](#registerobjectchangesxmlpaths)
- [registerObjectChangeXMLPaths](#registerobjectchangexmlpaths)
- [setObjectChange](#setobjectchange)
- [setObjectChanges](#setobjectchanges)
- [updateObjectChanges](#updateobjectchanges)

### addAdditionalObjectChangeXMLPaths

**Description**

**Definition**

> addAdditionalObjectChangeXMLPaths(XMLSchema schema, function func)

**Arguments**

| XMLSchema | schema |
|-----------|--------|
| function  | func   |

**Code**

```lua
function ObjectChangeUtil.addAdditionalObjectChangeXMLPaths(schema, func)
    schema:addDelayedRegistrationFunc( "ObjectChange" , func)
end

```

### loadObjectChangeFromXML

**Description**

> Load object change from xml

**Definition**

> loadObjectChangeFromXML(XMLFile xmlFile, string key, table? objects, integer rootNode, table? parent)

**Arguments**

| XMLFile | xmlFile  | instance of XMLFile                                                                                                    |
|---------|----------|------------------------------------------------------------------------------------------------------------------------|
| string  | key      | key                                                                                                                    |
| table?  | objects  | table to insert loaded objects to, if omitted new table will be created and returned if object changes could be loaded |
| integer | rootNode | id of root node                                                                                                        |
| table?  | parent   | parent                                                                                                                 |

**Return Values**

| table? | objects | list with loaded object changes, 'objects' argument if provided, new table or nil otherwise |
|--------|---------|---------------------------------------------------------------------------------------------|

**Code**

```lua
function ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, objects, rootNode, parent)
    for _, nodeKey in xmlFile:iterator(key .. ".objectChange" ) do
        local i3dMappings
        if parent ~ = nil then
            i3dMappings = parent.i3dMappings
        end
        local node = xmlFile:getValue(nodeKey .. "#node" , nil , rootNode, i3dMappings)
        if node ~ = nil then
            local object = { }
            object.node = node
            ObjectChangeUtil.loadValuesFromXML(xmlFile, nodeKey, node, object, parent, rootNode, i3dMappings)
            objects = objects or { }
            table.insert(objects, object)
        end
    end

    return objects
end

```

### loadValuesFromXML

**Description**

> Load object values from xml

**Definition**

> loadValuesFromXML(XMLFile xmlFile, string key, integer node, table object, table? parent, entityId? rootNode, table?
> i3dMappings)

**Arguments**

| XMLFile   | xmlFile     | instance of XMLFile         |
|-----------|-------------|-----------------------------|
| string    | key         | key                         |
| integer   | node        | node id to load from        |
| table     | object      | table to insert loaded data |
| table?    | parent      | parent                      |
| entityId? | rootNode    |                             |
| table?    | i3dMappings |                             |

**Code**

```lua
function ObjectChangeUtil.loadValuesFromXML(xmlFile, key, node, object, parent, rootNode, i3dMappings)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, "" , key .. "#collisionActive" , key .. "#compoundChildActive or #rigidBodyTypeActive" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, "" , key .. "#collisionInactive" , key .. "#compoundChildInactive or #rigidBodyTypeInactive" ) --FS17 to FS19

    object.parent = parent

    object.interpolation = xmlFile:getValue(key .. "#interpolation" , false )
    object.interpolationTime = xmlFile:getValue(key .. "#interpolationTime" , 1 )

    object.values = { }

    local entry = ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "parentNode" , nil ,
    function (parentNode)
        local x, y, z = getWorldTranslation(node)
        local rx, ry, rz = getWorldRotation(node)

        link(parentNode, node)

        setWorldTranslation(node, x, y, z)
        setWorldRotation(node, rx, ry, rz)
    end , false , nil , rootNode, i3dMappings)

    if entry ~ = nil then
        if entry.active = = nil then
            entry.active = { getParent(object.node) }
        end
        if entry.inactive = = nil then
            entry.inactive = { getParent(object.node) }
        end
    end

    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "delete" ,
    nil ,
    function (doDelete)
        if doDelete then
            local parent = getParent(node)
            local name = getName(node)
            local deletedName = string.format( "%s_deletedByObjectChange" , name)
            local index = getChildIndex(node)
            local emptyTG = createTransformGroup(deletedName)
            link(parent, emptyTG, index)
            delete(node)
        end
    end ,
    false )

    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "translation" ,
    function ()
        return getTranslation(node)
    end ,
    function (x, y, z)
        setTranslation(node, x, y, z)
    end ,
    true , nil , true )

    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "rotation" ,
    function ()
        return getRotation(node)
    end ,
    function (x, y, z)
        setRotation(node, x, y, z)
    end ,
    true , nil , true )

    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "scale" ,
    function ()
        return getScale(node)
    end ,
    function (x, y, z)
        setScale(node, x, y, z)
    end ,
    true , nil , true )

    local shaderParameter = xmlFile:getValue(key .. "#shaderParameter" )
    if shaderParameter ~ = nil then
        local recursive = xmlFile:getValue(key .. "#shaderParameterSetRecursive" , false )
        if not recursive then
            if getHasClassId(node, ClassIds.SHAPE) then
                if getHasShaderParameter(node, shaderParameter) then
                    local sharedShaderParameter = xmlFile:getValue(key .. "#sharedShaderParameter" , false )

                    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "shaderParameter" ,
                    function ()
                        return getShaderParameter(node, shaderParameter)
                    end ,
                    function (x, y, z, w)
                        setShaderParameter(node, shaderParameter, x, y, z, w, sharedShaderParameter)
                    end ,
                    true , nil , true )
                else
                        Logging.xmlWarning(xmlFile, "Missing shader parameter '%s' on object '%s' in '%s'" , shaderParameter, getName(node), key)
                    end
                else
                        Logging.xmlWarning(xmlFile, "Given node %q at %q is not a shape and cannot have a shaderParameter applied to it" , getName(node), key)
                    end
                else
                        -- recursive
                        if I3DUtil.getHasShaderParameterRec(node, shaderParameter) then
                            ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "shaderParameter" ,
                            function ()
                                return I3DUtil.getShaderParameterRec(node, shaderParameter)
                            end ,
                            function (x, y, z, w)
                                setShaderParameterRecursive(node, shaderParameter, x, y, z, w, false )
                            end ,
                            true , nil , true )
                        else
                                Logging.xmlWarning(xmlFile, "Missing shader parameter '%s' on object '%s' or any of its children(recursive) in '%s'" , shaderParameter, getName(node), key)
                            end
                        end
                    end

                    local centerOfMassMaskActive = xmlFile:getString(key .. "#centerOfMassActive" )
                    local centerOfMassMaskInactive = xmlFile:getString(key .. "#centerOfMassInactive" )
                    if centerOfMassMaskActive ~ = nil or centerOfMassMaskInactive ~ = nil then
                        centerOfMassMaskActive = (centerOfMassMaskActive or "" ):split( " " )
                        centerOfMassMaskInactive = (centerOfMassMaskInactive or "" ):split( " " )

                        object.centerOfMassMask = { 1 , 1 , 1 }
                        object.centerOfMassMaskActive = false
                        for i = 1 , 3 do
                            if centerOfMassMaskActive ~ = nil and centerOfMassMaskActive[i] = = "-" then
                                object.centerOfMassMask[i] = 0
                                object.centerOfMassMaskActive = true
                            end

                            if centerOfMassMaskInactive ~ = nil and centerOfMassMaskInactive[i] = = "-" then
                                object.centerOfMassMask[i] = 0
                                object.centerOfMassMaskActive = true
                            end
                        end
                    end

                    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "centerOfMass" ,
                    function ()
                        return getCenterOfMass(node)
                    end ,
                    function (x, y, z)
                        if object.centerOfMassMaskActive ~ = nil then
                            local cx, cy, cz = getCenterOfMass(node)
                            if object.centerOfMassMask[ 1 ] = = 0 then x = cx end
                            if object.centerOfMassMask[ 2 ] = = 0 then y = cy end
                            if object.centerOfMassMask[ 3 ] = = 0 then z = cz end
                        end

                        setCenterOfMass(node, x, y, z)
                    end ,
                    true , nil , true )

                    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "mass" ,
                    function ()
                        return getMass(node)
                    end ,
                    function (value)
                        setMass(node, value / 1000 )

                        if parent ~ = nil and parent.components ~ = nil then
                            for _, component in ipairs(parent.components) do
                                if component.node = = object.node then
                                    component.defaultMass = value / 1000
                                    parent:setMassDirty()
                                end
                            end
                        end
                    end , true )

                    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "visibility" , nil ,
                    function (state)
                        setVisibility(node, state)
                    end , false )

                    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "compoundChild" , nil ,
                    function (state)
                        setIsCompoundChild(node, state)
                    end , false )

                    local rigidBodyTypeActiveStr = xmlFile:getValue(key .. "#rigidBodyTypeActive" )
                    if rigidBodyTypeActiveStr ~ = nil then
                        object.rigidBodyTypeActive = RigidBodyType[ string.upper(rigidBodyTypeActiveStr)]

                        local t = object.rigidBodyTypeActive
                        if t ~ = RigidBodyType.STATIC and t ~ = RigidBodyType.DYNAMIC and t ~ = RigidBodyType.KINEMATIC and t ~ = RigidBodyType.NONE then
                            Logging.xmlWarning(xmlFile, "Invalid rigidBodyTypeActive '%s' for object change node '%s'.Use 'Static', 'Dynamic', 'Kinematic' or 'None'!" , rigidBodyTypeActiveStr, key)
                                object.rigidBodyTypeActive = nil
                            end
                        end

                        local rigidBodyTypeInactiveStr = xmlFile:getValue(key .. "#rigidBodyTypeInactive" )
                        if rigidBodyTypeInactiveStr ~ = nil then
                            object.rigidBodyTypeInactive = RigidBodyType[ string.upper(rigidBodyTypeInactiveStr)]

                            local t = object.rigidBodyTypeInactive
                            if t ~ = RigidBodyType.STATIC and t ~ = RigidBodyType.DYNAMIC and t ~ = RigidBodyType.KINEMATIC and t ~ = RigidBodyType.NONE then
                                Logging.xmlWarning(xmlFile, "Invalid rigidBodyTypeInactive '%s' for object change node '%s'.Use 'Static', 'Dynamic', 'Kinematic' or 'None'!" , rigidBodyTypeInactiveStr, key)
                                    object.rigidBodyTypeInactive = nil
                                end
                            end

                            if parent ~ = nil and parent.loadObjectChangeValuesFromXML ~ = nil then
                                parent:loadObjectChangeValuesFromXML(xmlFile, key, node, object)
                            end
                        end

```

### registerObjectChangeSingleXMLPaths

**Description**

**Definition**

> registerObjectChangeSingleXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function ObjectChangeUtil.registerObjectChangeSingleXMLPaths(schema, basePath)
    schema:addDelayedRegistrationPath(basePath .. ".objectChange(?)" , "ObjectChange" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".objectChange(?)#node" , "Object change node" )
    schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#interpolation" , "Value will be interpolated" , false )
    schema:register(XMLValueType.TIME, basePath .. ".objectChange(?)#interpolationTime" , "Time for interpolation" , 1 )

        local positivStr = "%s if object change is active"
            local negativeStr = "%s if object change is in active"

                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#deleteActive" , string.format(positivStr, "delete" ))
                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#deleteInactive" , string.format(positivStr, "delete" ))

                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#visibilityActive" , string.format(positivStr, "visibility" ))
                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#visibilityInactive" , string.format(negativeStr, "visibility" ))

                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".objectChange(?)#translationActive" , string.format(positivStr, "translation" ))
                schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".objectChange(?)#translationInactive" , string.format(negativeStr, "translation" ))

                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".objectChange(?)#rotationActive" , string.format(positivStr, "rotation" ))
                schema:register(XMLValueType.VECTOR_ROT, basePath .. ".objectChange(?)#rotationInactive" , string.format(negativeStr, "rotation" ))

                schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".objectChange(?)#scaleActive" , string.format(positivStr, "scale" ))
                schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".objectChange(?)#scaleInactive" , string.format(negativeStr, "scale" ))

                schema:register(XMLValueType.STRING, basePath .. ".objectChange(?)#shaderParameter" , "Shader parameter name" )
                schema:register(XMLValueType.VECTOR_ 4 , basePath .. ".objectChange(?)#shaderParameterActive" , string.format(positivStr, "shaderParameter" ))
                schema:register(XMLValueType.VECTOR_ 4 , basePath .. ".objectChange(?)#shaderParameterInactive" , string.format(negativeStr, "shaderParameter" ))
                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#sharedShaderParameter" , "Shader parameter is applied on all objects with the same material" , false )
                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#shaderParameterSetRecursive" , "Shader parameter is applied to all child nodes recursively" , false )

                schema:register(XMLValueType.FLOAT, basePath .. ".objectChange(?)#massActive" , string.format(positivStr, "mass" ))
                schema:register(XMLValueType.FLOAT, basePath .. ".objectChange(?)#massInactive" , string.format(negativeStr, "mass" ))

                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".objectChange(?)#centerOfMassActive" , string.format(positivStr, "center of mass" ))
                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".objectChange(?)#centerOfMassInactive" , string.format(negativeStr, "center of mass" ))

                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#compoundChildActive" , string.format(positivStr, "compound child state" ))
                schema:register(XMLValueType.BOOL, basePath .. ".objectChange(?)#compoundChildInactive" , string.format(negativeStr, "compound child state" ))

                schema:register(XMLValueType.STRING, basePath .. ".objectChange(?)#rigidBodyTypeActive" , string.format(positivStr, "rigid body type" ))
                schema:register(XMLValueType.STRING, basePath .. ".objectChange(?)#rigidBodyTypeInactive" , string.format(negativeStr, "rigid body type" ))

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".objectChange(?)#parentNodeActive" , string.format(positivStr, "parent node" ))
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".objectChange(?)#parentNodeInactive" , string.format(negativeStr, "parent node" ))
            end

```

### registerObjectChangesXMLPaths

**Description**

**Definition**

> registerObjectChangesXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function ObjectChangeUtil.registerObjectChangesXMLPaths(schema, basePath)
    schema:setXMLSharedRegistration( "ObjectChange_multiple" , basePath)
    ObjectChangeUtil.registerObjectChangeSingleXMLPaths(schema, basePath .. ".objectChanges" )
    schema:resetXMLSharedRegistration( "ObjectChange_multiple" , basePath)
end

```

### registerObjectChangeXMLPaths

**Description**

**Definition**

> registerObjectChangeXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
    schema:setXMLSharedRegistration( "ObjectChange_single" , basePath)
    ObjectChangeUtil.registerObjectChangeSingleXMLPaths(schema, basePath)
    schema:resetXMLSharedRegistration( "ObjectChange_single" , basePath)
end

```

### setObjectChange

**Description**

> Set object change

**Definition**

> setObjectChange(table object, boolean isActive, table target, function updateFunc, boolean? skipInterpolation)

**Arguments**

| table    | object            | objects to change     |
|----------|-------------------|-----------------------|
| boolean  | isActive          | is active             |
| table    | target            | target for updateFunc |
| function | updateFunc        | function to update    |
| boolean? | skipInterpolation |                       |

**Code**

```lua
function ObjectChangeUtil.setObjectChange(object, isActive, target, updateFunc, skipInterpolation)
    if isActive then
        for i = 1 , #object.values do
            local value = object.values[i]

            if value.active ~ = nil then
                if object.interpolation and value.interpolatable and not skipInterpolation then
                    local interpolator = ValueInterpolator.new(object.node .. value.name, value.getFunc, value.setFunc, value.active, object.interpolationTime)
                    if interpolator ~ = nil then
                        interpolator:setUpdateFunc(updateFunc, target, object.node)
                        interpolator:setDeleteListenerObject(object.parent)
                    end
                else
                        if skipInterpolation then
                            ValueInterpolator.removeInterpolator(object.node .. value.name)
                        end

                        value.setFunc( unpack(value.active))
                    end
                end
            end

            if object.rigidBodyTypeActive ~ = nil then
                setRigidBodyType(object.node, object.rigidBodyTypeActive)
            end
        else
                for i = 1 , #object.values do
                    local value = object.values[i]

                    if value.inactive ~ = nil then
                        if object.interpolation and value.interpolatable and not skipInterpolation then
                            local interpolator = ValueInterpolator.new(object.node .. value.name, value.getFunc, value.setFunc, value.inactive, object.interpolationTime)
                            if interpolator ~ = nil then
                                interpolator:setUpdateFunc(updateFunc, target, object.node)
                                interpolator:setDeleteListenerObject(object.parent)
                            end
                        else
                                if skipInterpolation then
                                    ValueInterpolator.removeInterpolator(object.node .. value.name)
                                end

                                value.setFunc( unpack(value.inactive))
                            end
                        end
                    end

                    if object.rigidBodyTypeInactive ~ = nil then
                        setRigidBodyType(object.node, object.rigidBodyTypeInactive)
                    end
                end
                if target ~ = nil then
                    if target.setObjectChangeValues ~ = nil then
                        target:setObjectChangeValues(object, isActive)
                    end
                    if updateFunc ~ = nil then
                        updateFunc(target, object.node)
                    end
                end
            end

```

### setObjectChanges

**Description**

> Set object changes

**Definition**

> setObjectChanges(table objects, boolean isActive, table? target, function? updateFunc, boolean? skipInterpolation)

**Arguments**

| table     | objects           | objects to change     |
|-----------|-------------------|-----------------------|
| boolean   | isActive          | is active             |
| table?    | target            | target for updateFunc |
| function? | updateFunc        | function to update    |
| boolean?  | skipInterpolation |                       |

**Code**

```lua
function ObjectChangeUtil.setObjectChanges(objects, isActive, target, updateFunc, skipInterpolation)
    if objects ~ = nil then
        for _, object in pairs(objects) do
            ObjectChangeUtil.setObjectChange(object, isActive, target, updateFunc, skipInterpolation)
        end
    end
end

```

### updateObjectChanges

**Description**

> Update object changes

**Definition**

> updateObjectChanges(XMLFile xmlFile, string key, integer configIndex, integer rootNode, table parent)

**Arguments**

| XMLFile | xmlFile     | instance of XMLFile  |
|---------|-------------|----------------------|
| string  | key         | key                  |
| integer | configIndex | index of used config |
| integer | rootNode    | id of root node      |
| table   | parent      | parent               |

**Code**

```lua
function ObjectChangeUtil.updateObjectChanges(xmlFile, key, configIndex, rootNode, parent)
    local i = 0
    local activeI = (configIndex - 1 )
    while true do
        local objectChangeKey = string.format(key .. "(%d)" , i)
        if not xmlFile:hasProperty(objectChangeKey) then
            break
        end
        if i ~ = activeI then
            local objects = ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, objectChangeKey, nil , rootNode, parent)
            ObjectChangeUtil.setObjectChanges(objects, false , parent)
        end
        i = i + 1
    end

    -- Set the active config last so that it can overwrite settings of inactive configurations
    if i > activeI then
        local objectChangeKey = string.format(key .. "(%d)" , activeI)
        local objects = ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, objectChangeKey, nil , rootNode, parent)
        ObjectChangeUtil.setObjectChanges(objects, true , parent)
    end
end

```