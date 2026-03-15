## Dashboard

**Description**

> Specialization for dashboards/instrument panels with various types (number, animation, rotation, visibility, ...)

**Functions**

- [addDelayedRegistrationFunc](#adddelayedregistrationfunc)
- [defaultDashboardStateFunc](#defaultdashboardstatefunc)
- [getDashboardColor](#getdashboardcolor)
- [getDashboardGroupByName](#getdashboardgroupbyname)
- [getDashboardValue](#getdashboardvalue)
- [getIsDashboardGroupActive](#getisdashboardgroupactive)
- [initSpecialization](#initspecialization)
- [loadDashboardCompoundFromExternalXML](#loaddashboardcompoundfromexternalxml)
- [loadDashboardCompoundFromXML](#loaddashboardcompoundfromxml)
- [loadDashboardFromXML](#loaddashboardfromxml)
- [loadDashboardGroupFromXML](#loaddashboardgroupfromxml)
- [loadDashboardsFromXML](#loaddashboardsfromxml)
- [onDashboardCompoundLoaded](#ondashboardcompoundloaded)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPreInitComponentPlacement](#onpreinitcomponentplacement)
- [onUpdate](#onupdate)
- [onUpdateEnd](#onupdateend)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerDashboardValueType](#registerdashboardvaluetype)
- [registerDashboardXMLPaths](#registerdashboardxmlpaths)
- [registerDisplayType](#registerdisplaytype)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [setDashboardsDirty](#setdashboardsdirty)
- [updateDashboards](#updatedashboards)
- [updateDashboardValueType](#updatedashboardvaluetype)
- [warningAttributes](#warningattributes)

### addDelayedRegistrationFunc

**Description**

**Definition**

> addDelayedRegistrationFunc()

**Arguments**

| any | schema |
|-----|--------|
| any | func   |

**Code**

```lua
function Dashboard.addDelayedRegistrationFunc(schema, func)
    schema:addDelayedRegistrationFunc( "Dashboard" , func)

    if Dashboard.compoundsXMLSchema = = nil then
        Dashboard.compoundsXMLSchema = XMLSchema.new( "dashboardCompounds" )
    end

    Dashboard.compoundsXMLSchema:addDelayedRegistrationFunc( "Dashboard" , func)
end

```

### defaultDashboardStateFunc

**Description**

**Definition**

> defaultDashboardStateFunc()

**Arguments**

| any | dashboard |
|-----|-----------|
| any | newValue  |
| any | minValue  |
| any | maxValue  |
| any | isActive  |

**Code**

```lua
function Dashboard:defaultDashboardStateFunc(dashboard, newValue, minValue, maxValue, isActive)
    local typeData = Dashboard.TYPE_DATA[dashboard.displayTypeIndex]
    typeData.updateFunc( self , dashboard, newValue, minValue, maxValue, isActive)
end

```

### getDashboardColor

**Description**

**Definition**

> getDashboardColor()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | colorStr          |
| any | customEnvironment |

**Code**

```lua
function Dashboard.getDashboardColor(xmlFile, colorStr, customEnvironment)
    if colorStr = = nil then
        return nil
    end

    if Dashboard.COLORS[ string.upper(colorStr)] ~ = nil then
        return Dashboard.COLORS[ string.upper(colorStr)]
    end

    local brandColor = g_vehicleMaterialManager:getMaterialTemplateColorByName(colorStr, customEnvironment)
    if brandColor ~ = nil then
        return brandColor
    end

    local vector = string.getVector(colorStr)
    if vector ~ = nil and #vector > = 3 then
        if #vector = = 3 then
            vector[ 4 ] = 1
        end

        return vector
    end

    Logging.xmlWarning(xmlFile, "Unable to resolve color '%s'" , colorStr)

    return nil
end

```

### getDashboardGroupByName

**Description**

**Definition**

> getDashboardGroupByName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function Dashboard:getDashboardGroupByName(name)
    return self.spec_dashboard.groups[name]
end

```

### getDashboardValue

**Description**

**Definition**

> getDashboardValue()

**Arguments**

| any | valueObject |
|-----|-------------|
| any | valueFunc   |
| any | dashboard   |

**Code**

```lua
function Dashboard:getDashboardValue(valueObject, valueFunc, dashboard)
    if type(valueFunc) = = "number" or type(valueFunc) = = "boolean" then
        return valueFunc
    elseif type(valueFunc) = = "function" then
            return valueFunc(valueObject, dashboard)
        end

        local object = valueObject[valueFunc]
        if type(object) = = "function" then
            return valueObject[valueFunc](valueObject, dashboard)
        elseif type(object) = = "number" or type(object) = = "boolean" then
                return object
            end

            return nil
        end

```

### getIsDashboardGroupActive

**Description**

**Definition**

> getIsDashboardGroupActive()

**Arguments**

| any | group |
|-----|-------|

**Code**

```lua
function Dashboard:getIsDashboardGroupActive(group)
    return true
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Dashboard.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Dashboard" )

    Dashboard.registerDashboardXMLPaths(schema, "vehicle.dashboard.default" )
    schema:register(XMLValueType.STRING, Dashboard.GROUP_XML_KEY .. "#name" , "Dashboard group name" )

    schema:register(XMLValueType.FLOAT, "vehicle.dashboard#maxUpdateDistance" , "Max.distance to vehicle root to update connection hoses" , Dashboard.DEFAULT_MAX_UPDATE_DISTANCE)
    schema:register(XMLValueType.FLOAT, "vehicle.dashboard#maxUpdateDistanceCritical" , "Max.distance to vehicle root to update critical connection hoses(All with type 'ROT')" , Dashboard.DEFAULT_MAX_UPDATE_DISTANCE_CRITICAL)
    schema:register(XMLValueType.TIME, "vehicle.dashboard#tickIntervall" , "If defined the low priority dashboard will get updated at this interval(otherwise every second frame)" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.dashboard.compounds.compound(?)#linkNode" , "Link node for dashboard compound" )
        schema:register(XMLValueType.STRING, "vehicle.dashboard.compounds.compound(?)#filename" , "Path to compound xml file" )
        schema:register(XMLValueType.STRING, "vehicle.dashboard.compounds.compound(?)#name" , "Name of dashboard compound to load" )
        schema:register(XMLValueType.STRING_LIST, "vehicle.dashboard.compounds.compound(?)#configIds" , "Configuration identifiers(the given configuations will be enabled, separated by whitespace)" )
        schema:register(XMLValueType.STRING, "vehicle.dashboard.compounds.compound(?).configurationDependency(?)#configName" , "Name of the vehicle config" )
        schema:register(XMLValueType.INT, "vehicle.dashboard.compounds.compound(?).configurationDependency(?)#configIndex" , "Index of the vehicle config" )
        schema:register(XMLValueType.BOOL, "vehicle.dashboard.compounds.compound(?).configurationDependency(?)#useCompound" , "Use dashboard compound only when the defined configuration is set" , false )
        schema:register(XMLValueType.STRING_LIST, "vehicle.dashboard.compounds.compound(?).configurationDependency(?)#additionalConfigIds" , "Dashboard config ids to be used when this vehicle config is active" )
        schema:register(XMLValueType.STRING_LIST, "vehicle.dashboard.compounds.compound(?).configurationDependency(?)#disabledConfigIds" , "Dashboard config ids to be used when this vehicle config is active" )

        schema:setXMLSpecializationType()

        if Dashboard.compoundsXMLSchema = = nil then
            Dashboard.compoundsXMLSchema = XMLSchema.new( "dashboardCompounds" )
        end

        Dashboard.compoundsXMLSchema:register(XMLValueType.NODE_INDEX, "dashboardCompounds.dashboardCompound(?)#node" , "Root node in i3d file to load" )
        Dashboard.compoundsXMLSchema:register(XMLValueType.STRING, "dashboardCompounds.dashboardCompound(?)#filename" , "Path to i3d file" )
        Dashboard.compoundsXMLSchema:register(XMLValueType.STRING, "dashboardCompounds.dashboardCompound(?)#name" , "Name of dashboard compound" )
        I3DUtil.registerI3dMappingXMLPaths( Dashboard.compoundsXMLSchema, "dashboardCompounds" )
        Dashboard.registerDashboardXMLPaths( Dashboard.compoundsXMLSchema, "dashboardCompounds.dashboardCompound(?)" )

        Dashboard.compoundsXMLSchema:register(XMLValueType.STRING, "dashboardCompounds.dashboardCompound(?).configuration(?)#id" , "Identifier of the configuration" )
        Dashboard.registerDashboardXMLPaths( Dashboard.compoundsXMLSchema, "dashboardCompounds.dashboardCompound(?).configuration(?)" )
        ObjectChangeUtil.registerObjectChangeXMLPaths( Dashboard.compoundsXMLSchema, "dashboardCompounds.dashboardCompound(?).configuration(?)" )
    end

```

### loadDashboardCompoundFromExternalXML

**Description**

**Definition**

> loadDashboardCompoundFromExternalXML()

**Arguments**

| any | dashboardXMLFile |
|-----|------------------|
| any | compound         |
| any | compoundKey      |
| any | components       |

**Code**

```lua
function Dashboard:loadDashboardCompoundFromExternalXML(dashboardXMLFile, compound, compoundKey, components)
    local node = dashboardXMLFile:getValue(compoundKey .. "#node" , nil , components, compound.i3dMappings)
    if node ~ = nil then
        link(compound.linkNode, node)
        setTranslation(node, 0 , 0 , 0 )
        setRotation(node, 0 , 0 , 0 )

        self:loadDashboardsFromXML(dashboardXMLFile, compoundKey, nil , components, compound.i3dMappings, node)

        for _, configKey in dashboardXMLFile:iterator(compoundKey .. ".configuration" ) do
            local isActive = false
            local id = dashboardXMLFile:getValue(configKey .. "#id" )
            if id ~ = nil and compound.configIds ~ = nil then
                for _, _id in ipairs(compound.configIds) do
                    if string.lower(id) = = string.lower(_id) then
                        isActive = true
                    end
                end
            end

            local objects = { }
            ObjectChangeUtil.loadObjectChangeFromXML(dashboardXMLFile, configKey, objects, components, compound)
            ObjectChangeUtil.setObjectChanges(objects, isActive, compound)

            if isActive then
                self:loadDashboardsFromXML(dashboardXMLFile, configKey, nil , components, compound.i3dMappings, node)
            end
        end
    else
            Logging.xmlWarning(dashboardXMLFile, "Unable to find node for compound at '%s'" , compoundKey)
                return false
            end

            return true
        end

```

### loadDashboardCompoundFromXML

**Description**

**Definition**

> loadDashboardCompoundFromXML()

**Arguments**

| any | xmlFile  |
|-----|----------|
| any | key      |
| any | compound |

**Code**

```lua
function Dashboard:loadDashboardCompoundFromXML(xmlFile, key, compound)
    compound.linkNode = xmlFile:getValue(key .. "#linkNode" , nil , self.components, self.i3dMappings)
    if compound.linkNode = = nil then
        return false
    end

    compound.filename = xmlFile:getValue(key .. "#filename" )
    if compound.filename ~ = nil then
        compound.filename = Utils.getFilename(compound.filename, self.baseDirectory)
    else
            return false
        end

        if compound.filename ~ = nil then
            compound.name = xmlFile:getValue(key .. "#name" )

            compound.configIds = xmlFile:getValue(key .. "#configIds" , nil , true )

            local isAllowed = true
            for _, configDependencyKey in xmlFile:iterator(key .. ".configurationDependency" ) do
                local configName = xmlFile:getValue(configDependencyKey .. "#configName" )
                local configIndex = xmlFile:getValue(configDependencyKey .. "#configIndex" )
                if configName ~ = nil and configIndex ~ = nil then
                    if self.configurations[configName] = = configIndex then
                        local configIds = xmlFile:getValue(configDependencyKey .. "#additionalConfigIds" , nil , true )
                        if configIds ~ = nil then
                            for _, _configId in ipairs(configIds) do
                                table.insert(compound.configIds, _configId)
                            end
                        end

                        configIds = xmlFile:getValue(configDependencyKey .. "#disabledConfigIds" , nil , true )
                        if configIds ~ = nil then
                            for _, _configId in ipairs(configIds) do
                                for i = #compound.configIds, 1 , - 1 do
                                    if compound.configIds[i] = = _configId then
                                        table.remove(compound.configIds, i)
                                    end
                                end
                            end
                        end
                    else
                            local useCompound = xmlFile:getValue(configDependencyKey .. "#useCompound" , false )
                            if useCompound then
                                isAllowed = false
                            end
                        end
                    end
                end

                if compound.name ~ = nil then
                    if isAllowed then
                        local dashboardXMLFile = XMLFile.load( "dashboardCompoundsXML" , compound.filename, Dashboard.compoundsXMLSchema)
                        if dashboardXMLFile ~ = nil then
                            local compoundKey
                            dashboardXMLFile:iterate( "dashboardCompounds.dashboardCompound" , function (index, _compoundKey)
                                if dashboardXMLFile:getValue(_compoundKey .. "#name" ) = = compound.name then
                                    compoundKey = _compoundKey
                                    return
                                end
                            end )

                            if compoundKey ~ = nil then
                                local i3dFilename = dashboardXMLFile:getValue(compoundKey .. "#filename" )
                                if i3dFilename ~ = nil then
                                    i3dFilename = Utils.getFilename(i3dFilename, self.baseDirectory)
                                end

                                if i3dFilename = = nil then
                                    Logging.xmlWarning(dashboardXMLFile, "Missing filename for compound '%s'" , compound.name)
                                        return false
                                    end

                                    local arguments = {
                                    dashboardXMLFile = dashboardXMLFile,
                                    compound = compound,
                                    compoundKey = compoundKey,
                                    }
                                    local sharedLoadRequestId = self:loadSubSharedI3DFile(i3dFilename, false , false , self.onDashboardCompoundLoaded, self , arguments)
                                    table.insert( self.spec_dashboard.sharedLoadRequestIds, sharedLoadRequestId)
                                    return true
                                else
                                        Logging.xmlWarning(dashboardXMLFile, "Unable to find compound by name '%s'" , compound.name)
                                        dashboardXMLFile:delete()
                                        return false
                                    end
                                end
                            end
                        else
                                Logging.xmlWarning(xmlFile, "Missing name in '%s'" , key)
                                return false
                            end
                        end

                        return false
                    end

```

### loadDashboardFromXML

**Description**

**Definition**

> loadDashboardFromXML()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | key         |
| any | dashboard   |
| any | valueType   |
| any | components  |
| any | i3dMappings |
| any | parentNode  |

**Code**

```lua
function Dashboard:loadDashboardFromXML(xmlFile, key, dashboard, valueType, components, i3dMappings, parentNode)
    dashboard.valueType = valueType

    if valueType ~ = nil then
        if valueType.isa = = nil or not valueType:isa( DashboardValueType ) then
            Logging.error( "Deprecated call of Dashboard:loadDashboardFromXML.Needs to be called with DashboardValueType object or nil." )
            printCallstack()
            return false
        end

        local valueTypeName = xmlFile:getValue(key .. "#valueType" )
        if valueTypeName ~ = dashboard.valueType.name and valueTypeName ~ = dashboard.valueType.fullName then
            return false
        end
    end

    local displayType = xmlFile:getValue(key .. "#displayType" )
    if displayType ~ = nil then
        local displayTypeIndex = Dashboard.TYPES[ string.upper(displayType)]

        if displayTypeIndex ~ = nil then
            dashboard.displayTypeIndex = displayTypeIndex
        else
                Logging.xmlWarning(xmlFile, "Unknown displayType '%s' for dashboard '%s'" , displayType, key)
                    return false
                end
            else
                    Logging.xmlWarning(xmlFile, "Missing displayType for dashboard '%s'" , key)
                        return false
                    end

                    dashboard.doInterpolation = xmlFile:getValue(key .. "#doInterpolation" , false )
                    dashboard.isCritical = xmlFile:getValue(key .. "#isCritical" )
                    dashboard.useStateChange = xmlFile:getValue(key .. "#useStateChange" , false )
                    if dashboard.useStateChange then
                        dashboard.stateChangeValue = xmlFile:getValue(key .. "#stateChangeValue" )
                        dashboard.stateChangeTime = xmlFile:getValue(key .. "#stateChangeTime" , 0.2 )
                        dashboard.stateChangeLastValue = nil
                        dashboard.stateChangeEndTime = - math.huge
                    end
                    dashboard.idleValue = xmlFile:getValue(key .. "#idleValue" , (valueType ~ = nil and valueType.idleValue or 0 ) or 0 )
                    dashboard.lastInterpolationValue = dashboard.idleValue
                    dashboard.offsetValue = xmlFile:getValue(key .. "#offsetValue" )
                    dashboard.scaleFactor = xmlFile:getValue(key .. "#scaleFactor" )

                    dashboard.minActiveValue = xmlFile:getValue(key .. "#minActiveValue" )
                    dashboard.maxActiveValue = xmlFile:getValue(key .. "#maxActiveValue" )

                    if xmlFile:hasProperty(key .. ".valueMapping" ) then
                        dashboard.valueMapping = AnimCurve.new(linearInterpolator1)
                        for _, valueMappingKey in xmlFile:iterator(key .. ".valueMapping" ) do
                            local sourceValue = xmlFile:getValue(valueMappingKey .. "#sourceValue" )
                            local dashboardValue = xmlFile:getValue(valueMappingKey .. "#dashboardValue" )
                            if sourceValue ~ = nil and dashboardValue ~ = nil then
                                dashboard.valueMapping:addKeyframe( { dashboardValue, time = sourceValue } )
                            end
                        end

                        if dashboard.valueMapping.numKeyframes = = 0 then
                            dashboard.valueMapping = nil
                        end
                    end

                    dashboard.groups = { }
                    local groupsStr = xmlFile:getValue(key .. "#groups" )
                    if groupsStr ~ = nil then
                        local groups = string.split(groupsStr, " " )
                        for _, name in ipairs(groups) do
                            local group = self:getDashboardGroupByName(name)
                            if group ~ = nil then
                                table.insert(dashboard.groups, group)
                            else
                                    Logging.xmlWarning(xmlFile, "Unable to find dashboard group '%s' for dashboard '%s'" , name, key)
                                    end
                                end
                            end

                            if valueType ~ = nil and valueType.stateFunction ~ = nil then
                                dashboard.stateFunc = valueType.stateFunction
                            else
                                    dashboard.stateFunc = Dashboard.defaultDashboardStateFunc
                                end

                                local interpolationSpeed
                                if valueType ~ = nil then
                                    interpolationSpeed = valueType:getInterpolationSpeed(dashboard)
                                end
                                dashboard.interpolationSpeed = xmlFile:getValue(key .. "#interpolationSpeed" , interpolationSpeed or 0.005 )

                                local typeData = Dashboard.TYPE_DATA[dashboard.displayTypeIndex]
                                if typeData ~ = nil then
                                    if not typeData.loadFunc( self , xmlFile, key, dashboard, components, i3dMappings, parentNode) then
                                        return false
                                    end
                                else
                                        return false
                                    end

                                    if valueType ~ = nil and valueType.loadFunction ~ = nil then
                                        if not valueType.loadFunction( self , xmlFile, key, dashboard, components, i3dMappings, parentNode) then
                                            return false
                                        end
                                    end

                                    dashboard.lastValue = nil

                                    return true
                                end

```

### loadDashboardGroupFromXML

**Description**

**Definition**

> loadDashboardGroupFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | group   |

**Code**

```lua
function Dashboard:loadDashboardGroupFromXML(xmlFile, key, group)
    group.name = xmlFile:getValue(key .. "#name" )
    if group.name = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing name for dashboard group '%s'" , key)
            return false
        end

        if self:getDashboardGroupByName(group.name) ~ = nil then
            Logging.xmlWarning( self.xmlFile, "Duplicated dashboard group name '%s' for group '%s'" , group.name, key)
                return false
            end

            group.isActive = false

            return true
        end

```

### loadDashboardsFromXML

**Description**

**Definition**

> loadDashboardsFromXML()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | key                |
| any | dashboardValueType |
| any | components         |
| any | i3dMappings        |
| any | parentNode         |

**Code**

```lua
function Dashboard:loadDashboardsFromXML(xmlFile, key, dashboardValueType, components, i3dMappings, parentNode)
    if self.isClient then
        local spec = self.spec_dashboard

        xmlFile:iterate(key .. ".dashboard" , function (index, dashboardKey)
            local valueTypeName = xmlFile:getValue(dashboardKey .. "#valueType" )

            local dashboardValueTypeToUse = dashboardValueType
            local numMatches = 0
            if dashboardValueTypeToUse = = nil and valueTypeName ~ = nil then
                for _, _dashboardValueType in ipairs(spec.dashboardValueTypes) do
                    if valueTypeName = = _dashboardValueType.name or valueTypeName = = _dashboardValueType.fullName then
                        dashboardValueTypeToUse = _dashboardValueType
                        numMatches = numMatches + 1
                    end
                end
            end

            if numMatches > 1 and dashboardValueTypeToUse.xmlKey = = nil then
                Logging.xmlWarning(xmlFile, "Dashboard valueType name '%s' is used in multiple specializations.Please specify with specialization prefix. (e.g. 'motorized.rpm')" , valueTypeName)
            end

            if valueTypeName ~ = nil and dashboardValueTypeToUse = = nil then
                Logging.xmlWarning(xmlFile, "Unknown dashboard valueType '%s' for dashboard '%s'" , valueTypeName, dashboardKey)
                    return
                end

                local dashboard = { }
                if self:loadDashboardFromXML(xmlFile, dashboardKey, dashboard, dashboardValueTypeToUse, components or self.components, i3dMappings or self.i3dMappings, parentNode) then
                    local typeData = Dashboard.TYPE_DATA[dashboard.displayTypeIndex]
                    local isCritical = typeData.isCritical
                    if dashboard.isCritical ~ = nil then
                        isCritical = dashboard.isCritical
                    end

                    if isCritical and((dashboardValueTypeToUse ~ = nil and dashboardValueTypeToUse.pollUpdate) or dashboard.doInterpolation) then
                        table.insert(spec.criticalDashboards, dashboard)
                    else
                            if (dashboardValueTypeToUse ~ = nil and not dashboardValueTypeToUse.pollUpdate) and not dashboard.doInterpolation then
                                local fullName = dashboardValueTypeToUse.fullName
                                if spec.dashboardsByValueType[fullName] = = nil then
                                    spec.dashboardsByValueType[fullName] = { }
                                    spec.dashboardsByValueTypeDirty[fullName] = false
                                end
                                table.insert(spec.dashboardsByValueType[fullName], dashboard)
                            else
                                    if dashboardValueTypeToUse = = nil then
                                        table.insert(spec.groupDashboards, dashboard)
                                    else
                                            table.insert(spec.tickDashboards, dashboard)
                                        end
                                    end
                                end

                                spec.numDashboards = spec.numDashboards + 1
                            end
                        end )
                    end

                    return true
                end

```

### onDashboardCompoundLoaded

**Description**

**Definition**

> onDashboardCompoundLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function Dashboard:onDashboardCompoundLoaded(i3dNode, failedReason, args)
    local dashboardXMLFile = args.dashboardXMLFile
    local compound = args.compound
    local compoundKey = args.compoundKey

    if i3dNode ~ = 0 then
        local components = { }
        for i = 1 , getNumOfChildren(i3dNode) do
            table.insert(components, { node = getChildAt(i3dNode, i - 1 ) } )
        end

        compound.i3dMappings = { }
        I3DUtil.loadI3DMapping(dashboardXMLFile, "dashboardCompounds" , components, compound.i3dMappings, nil )

        self:loadDashboardCompoundFromExternalXML(dashboardXMLFile, compound, compoundKey, components)

        delete(i3dNode)
    end

    dashboardXMLFile:delete()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Dashboard:onDelete()
    local spec = self.spec_dashboard

    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
    end
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
function Dashboard:onLoad(savegame)
    local spec = self.spec_dashboard

    spec.dashboards = { } -- backward compatibility

    spec.groupDashboards = { } -- dashboards that are only toggle with the group and never change the values
    spec.dashboardsByValueType = { } -- dashboards by type that are updated based on events from otehr specializations
    spec.dashboardsByValueTypeDirty = { } -- dirty state of each value type, so the dashboards are updated when we get into the update range again

    spec.tickDashboards = { } -- low prio dashboards that are updated in tick
    spec.criticalDashboards = { } -- high prio dashboards that are updated each frame(e.g.pedal rotations)

    spec.numDashboards = 0

    spec.groups = { }
    spec.sortedGroups = { }
    spec.groupUpdateIndex = 1
    spec.hasGroups = false
    spec.dashboardTypesLoaded = false

    spec.dashboardValueTypes = { }
    spec.sharedLoadRequestIds = { }

    local i = 0
    while true do
        local baseKey = string.format( "%s.groups.group(%d)" , "vehicle.dashboard" , i)
        if not self.xmlFile:hasProperty(baseKey) then
            break
        end

        local group = { }
        if self:loadDashboardGroupFromXML( self.xmlFile, baseKey, group) then
            spec.groups[group.name] = group
            table.insert(spec.sortedGroups, group)
            spec.hasGroups = true
        end

        i = i + 1
    end

    spec.isDirty = false
    spec.isDirtyTick = false

    spec.tickIntervall = self.xmlFile:getValue( "vehicle.dashboard#tickIntervall" )
    spec.timeSinceLastTick = 0

    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.dashboard#maxUpdateDistance" , Dashboard.DEFAULT_MAX_UPDATE_DISTANCE)
    spec.maxUpdateDistanceCritical = self.xmlFile:getValue( "vehicle.dashboard#maxUpdateDistanceCritical" , Dashboard.DEFAULT_MAX_UPDATE_DISTANCE_CRITICAL)
    spec.lastUpdateDistance = math.huge
end

```

### onPreInitComponentPlacement

**Description**

**Definition**

> onPreInitComponentPlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Dashboard:onPreInitComponentPlacement(savegame)
    -- load dashboards in onPreInitComponentPlacement, so we get all the value types that are registered in onPostLoad

    local spec = self.spec_dashboard

    if self.isClient then
        SpecializationUtil.raiseEvent( self , "onRegisterDashboardValueTypes" )

        spec.dashboardTypesLoaded = true
        self:loadDashboardsFromXML( self.xmlFile, "vehicle.dashboard.default" )

        for _, dashboardValueType in ipairs(spec.dashboardValueTypes) do
            dashboardValueType:loadFromXML( self.xmlFile, self )
        end

        spec.dashboardCompounds = { }
        self.xmlFile:iterate( "vehicle.dashboard.compounds.compound" , function (index, compoundKey)
            local dashboardCompound = { }
            if self:loadDashboardCompoundFromXML( self.xmlFile, compoundKey, dashboardCompound) then
                table.insert(spec.dashboardCompounds, dashboardCompound)
            end
        end )
    end

    if not self.isClient or spec.numDashboards = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , Dashboard )
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , Dashboard )
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Dashboard:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_dashboard

        if spec.hasGroups then
            local group = spec.sortedGroups[spec.groupUpdateIndex]
            if self:getIsDashboardGroupActive(group) ~ = group.isActive then
                group.isActive = not group.isActive

                -- force update of all dashboards
                self:updateDashboards(spec.groupDashboards, dt, true )
                self:updateDashboards(spec.tickDashboards, dt, true )
                self:updateDashboards(spec.criticalDashboards, dt, true )
                for _, dashboards in pairs(spec.dashboardsByValueType) do
                    self:updateDashboards(dashboards, dt, true )
                end
            end

            spec.groupUpdateIndex = spec.groupUpdateIndex + 1
            if spec.groupUpdateIndex > #spec.sortedGroups then
                spec.groupUpdateIndex = 1
            end
        end

        if self.currentUpdateDistance < spec.maxUpdateDistanceCritical or spec.isDirty then
            self:updateDashboards(spec.criticalDashboards, dt)

            spec.isDirty = false
        end

        if spec.isDirtyTick then
            self:raiseActive()
        end
    end
end

```

### onUpdateEnd

**Description**

**Definition**

> onUpdateEnd()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Dashboard:onUpdateEnd(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_dashboard
        self:updateDashboards(spec.tickDashboards, dt, true )
        self:updateDashboards(spec.criticalDashboards, dt, true )
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Dashboard:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_dashboard
        if self.currentUpdateDistance < spec.maxUpdateDistance or spec.isDirtyTick then
            local updateAllowed = true
            if spec.tickIntervall ~ = nil then
                spec.timeSinceLastTick = spec.timeSinceLastTick + dt
                if spec.timeSinceLastTick < spec.tickIntervall then
                    updateAllowed = false
                else
                        spec.timeSinceLastTick = 0
                    end
                end

                if updateAllowed then
                    self:updateDashboards(spec.tickDashboards, dt)
                    spec.isDirtyTick = false
                end
            end

            if self.currentUpdateDistance < spec.maxUpdateDistance then
                for valueType, dashboards in pairs(spec.dashboardsByValueType) do
                    if spec.dashboardsByValueTypeDirty[valueType] then
                        self:updateDashboards(dashboards, dt, true )
                        spec.dashboardsByValueTypeDirty[valueType] = false
                    end
                end
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
function Dashboard.prerequisitesPresent(specializations)
    return true
end

```

### registerDashboardValueType

**Description**

**Definition**

> registerDashboardValueType()

**Arguments**

| any | dashboardValueType |
|-----|--------------------|

**Code**

```lua
function Dashboard:registerDashboardValueType(dashboardValueType)
    local spec = self.spec_dashboard
    table.insert(spec.dashboardValueTypes, dashboardValueType)

    if spec.dashboardTypesLoaded then
        dashboardValueType:loadFromXML( self.xmlFile, self )
    end
end

```

### registerDashboardXMLPaths

**Description**

**Definition**

> registerDashboardXMLPaths(XMLSchema schema, string basePath, array availableValueTypes)

**Arguments**

| XMLSchema | schema              | XMLSchema instance         |
|-----------|---------------------|----------------------------|
| string    | basePath            |                            |
| array     | availableValueTypes | list of allowed valueTypes |

**Code**

```lua
function Dashboard.registerDashboardXMLPaths(schema, basePath, availableValueTypes)
    schema:register(XMLValueType.STRING, basePath .. ".dashboard(?)#valueType" , "Value type name" , nil , nil , availableValueTypes)
    schema:register(XMLValueType.STRING, basePath .. ".dashboard(?)#displayType" , "Display type name" , nil , nil , table.toList( Dashboard.TYPES))
    schema:register(XMLValueType.BOOL, basePath .. ".dashboard(?)#doInterpolation" , "Do interpolation" , false )
    schema:register(XMLValueType.BOOL, basePath .. ".dashboard(?)#isCritical" , "Defines if dashboard update is critical and should be done every frame" , "automatically based on type" )
        schema:register(XMLValueType.BOOL, basePath .. ".dashboard(?)#useStateChange" , "Dashboard is active for a defined amount of time when the source value changes" , false )
            schema:register(XMLValueType.TIME, basePath .. ".dashboard(?)#stateChangeTime" , "Defines how long the dashboard is active when the state changes(seconds)" , 0.2 )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#stateChangeValue" , "Defines the dashboard value which triggers the state change.If not defined, any state change will trigger it" )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#interpolationSpeed" , "Interpolation speed" , 0.005 )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#idleValue" , "Idle value" , 0 )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#offsetValue" , "Offset the value by the given amount" , 0 )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#scaleFactor" , "Scale the value by the given factor" , 1 )

            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#minActiveValue" , "Min.value to activate this dashboard" )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#maxActiveValue" , "Max.value to activate this dashboard" )

            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?).valueMapping(?)#sourceValue" , "Source value" )
            schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?).valueMapping(?)#dashboardValue" , "Value to be used for dashboard at this source value" )

                schema:register(XMLValueType.STRING, basePath .. ".dashboard(?)#groups" , "List of groups" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".dashboard(?)#node" , "Node" )

                schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#warningThresholdMin" , "(WARNING) Threshold min." )
                schema:register(XMLValueType.FLOAT, basePath .. ".dashboard(?)#warningThresholdMax" , "(WARNING) Threshold max." )

                for _, typeData in pairs( Dashboard.TYPE_DATA) do
                    typeData.schemaFunc(schema, basePath)
                end

                schema:addDelayedRegistrationPath(basePath .. ".dashboard(?)" , "Dashboard" )
            end

```

### registerDisplayType

**Description**

**Definition**

> registerDisplayType()

**Arguments**

| any | typeIndex  |
|-----|------------|
| any | isCritical |
| any | schemaFunc |
| any | loadFunc   |
| any | updateFunc |

**Code**

```lua
function Dashboard.registerDisplayType(typeIndex, isCritical, schemaFunc, loadFunc, updateFunc)
    local typeData = { }
    typeData.isCritical = isCritical
    typeData.schemaFunc = schemaFunc
    typeData.loadFunc = loadFunc
    typeData.updateFunc = updateFunc

    Dashboard.TYPE_DATA[typeIndex] = typeData
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
function Dashboard.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Dashboard )
    SpecializationUtil.registerEventListener(vehicleType, "onPreInitComponentPlacement" , Dashboard )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Dashboard )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Dashboard )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Dashboard )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateEnd" , Dashboard )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function Dashboard.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onRegisterDashboardValueTypes" )
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
function Dashboard.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "registerDashboardValueType" , Dashboard.registerDashboardValueType)
    SpecializationUtil.registerFunction(vehicleType, "updateDashboards" , Dashboard.updateDashboards)
    SpecializationUtil.registerFunction(vehicleType, "updateDashboardValueType" , Dashboard.updateDashboardValueType)
    SpecializationUtil.registerFunction(vehicleType, "loadDashboardGroupFromXML" , Dashboard.loadDashboardGroupFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsDashboardGroupActive" , Dashboard.getIsDashboardGroupActive)
    SpecializationUtil.registerFunction(vehicleType, "getDashboardGroupByName" , Dashboard.getDashboardGroupByName)
    SpecializationUtil.registerFunction(vehicleType, "loadDashboardCompoundFromXML" , Dashboard.loadDashboardCompoundFromXML)
    SpecializationUtil.registerFunction(vehicleType, "onDashboardCompoundLoaded" , Dashboard.onDashboardCompoundLoaded)
    SpecializationUtil.registerFunction(vehicleType, "loadDashboardCompoundFromExternalXML" , Dashboard.loadDashboardCompoundFromExternalXML)
    SpecializationUtil.registerFunction(vehicleType, "loadDashboardsFromXML" , Dashboard.loadDashboardsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadDashboardFromXML" , Dashboard.loadDashboardFromXML)
    SpecializationUtil.registerFunction(vehicleType, "setDashboardsDirty" , Dashboard.setDashboardsDirty)
    SpecializationUtil.registerFunction(vehicleType, "getDashboardValue" , Dashboard.getDashboardValue)
end

```

### setDashboardsDirty

**Description**

**Definition**

> setDashboardsDirty()

**Code**

```lua
function Dashboard:setDashboardsDirty()
    self.spec_dashboard.isDirty = true
    self.spec_dashboard.isDirtyTick = true

    self:raiseActive()
end

```

### updateDashboards

**Description**

**Definition**

> updateDashboards()

**Arguments**

| any | dashboards |
|-----|------------|
| any | dt         |
| any | force      |

**Code**

```lua
function Dashboard:updateDashboards(dashboards, dt, force)
    for i = 1 , #dashboards do
        local dashboard = dashboards[i]
        local isActive = true
        for j = 1 , #dashboard.groups do
            if not dashboard.groups[j].isActive then
                isActive = false
                break
            end
        end

        if dashboard.valueType ~ = nil then
            local value, min , max , center, isNumber = dashboard.valueType:getValue(dashboard)

            if dashboard.useStateChange then
                if value ~ = dashboard.stateChangeLastValue then
                    dashboard.stateChangeLastValue = value

                    if not isNumber then
                        value = value and 1 or 0
                    end

                    if dashboard.stateChangeValue = = nil or value = = dashboard.stateChangeValue then
                        dashboard.stateChangeEndTime = g_ time + dashboard.stateChangeTime
                    end
                end

                if dashboard.stateChangeEndTime > g_ time then
                    value = 1
                else
                        value = 0
                    end
                    isNumber = true
                end

                if dashboard.minActiveValue ~ = nil then
                    if value < dashboard.minActiveValue then
                        isActive = false
                    end
                end

                if dashboard.maxActiveValue ~ = nil then
                    if value > dashboard.maxActiveValue then
                        isActive = false
                    end
                end

                if isNumber then
                    if dashboard.scaleFactor ~ = nil then
                        value = value * dashboard.scaleFactor
                    end

                    if dashboard.offsetValue ~ = nil then
                        value = value + dashboard.offsetValue
                    end

                    if dashboard.valueMapping ~ = nil then
                        value = dashboard.valueMapping:get(value)
                    end
                end

                if not isActive then
                    if isNumber then
                        value = dashboard.idleValue
                    else
                            value = dashboard.idleValue > 0.5
                        end
                    end

                    if dashboard.doInterpolation then
                        -- convert boolean values to number, so we can interpolate it
                        if not isNumber then
                            value = value and 1 or 0
                        end

                        if value ~ = dashboard.lastInterpolationValue then
                            local dir = math.sign(value - dashboard.lastInterpolationValue)
                            local limitFunc = math.min
                            if dir < 0 then
                                limitFunc = math.max
                            end

                            value = limitFunc(dashboard.lastInterpolationValue + dashboard.interpolationSpeed * dir * dt, value)
                            dashboard.lastInterpolationValue = value
                        end
                    end

                    if value ~ = dashboard.lastValue or force then
                        dashboard.lastValue = value

                        if isNumber then
                            -- for idle values while not active we ignore the limits

                                if min ~ = nil then
                                    if dashboard.doInterpolation then
                                        min = math.min( min , dashboard.idleValue)
                                    end

                                    value = math.max( min , value)
                                end

                                if max ~ = nil and isActive then
                                    if dashboard.doInterpolation then
                                        max = math.max( max , dashboard.idleValue)
                                    end

                                    value = math.min( max , value)
                                end

                                if center ~ = nil then
                                    local maxValue = math.max( math.abs( min ), math.abs( max ))
                                    if value < center then
                                        value = - value / min * maxValue
                                    elseif value > center then
                                            value = value / max * maxValue
                                        end

                                        max = maxValue
                                        min = - maxValue
                                    end
                                end

                                dashboard.stateFunc( self , dashboard, value, min , max , isActive)
                            end
                        elseif force then
                                dashboard.stateFunc( self , dashboard, true , nil , nil , isActive)
                            end
                        end
                    end

```

### updateDashboardValueType

**Description**

**Definition**

> updateDashboardValueType()

**Arguments**

| any | valueTypeName |
|-----|---------------|

**Code**

```lua
function Dashboard:updateDashboardValueType(valueTypeName)
    self.spec_dashboard.dashboardsByValueTypeDirty[valueTypeName] = true
end

```

### warningAttributes

**Description**

**Definition**

> warningAttributes()

**Arguments**

| any | self      |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | dashboard |
| any | isActive  |

**Code**

```lua
function Dashboard.warningAttributes( self , xmlFile, key, dashboard, isActive)
    dashboard.warningThresholdMin = xmlFile:getValue(key .. "#warningThresholdMin" , - math.huge)
    dashboard.warningThresholdMax = xmlFile:getValue(key .. "#warningThresholdMax" , math.huge)

    return true
end

```