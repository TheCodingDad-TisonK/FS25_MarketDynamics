## SpecializationManager

**Description**

> This class handles all specializations

**Parent**

> [AbstractManager](?version=script&category=77&class=619)

**Functions**

- [addSpecialization](#addspecialization)
- [getSpecializationByName](#getspecializationbyname)
- [getSpecializationObjectByName](#getspecializationobjectbyname)
- [getSpecializations](#getspecializations)
- [initDataStructures](#initdatastructures)
- [initSpecializations](#initspecializations)
- [loadMapData](#loadmapdata)
- [new](#new)
- [postInitSpecializations](#postinitspecializations)

### addSpecialization

**Description**

> Adds a new vehicleType

**Definition**

> addSpecialization(string name, string className, string filename, string customEnvironment)

**Arguments**

| string | name              | specialization name  |
|--------|-------------------|----------------------|
| string | className         | classname            |
| string | filename          | filename             |
| string | customEnvironment | a custom environment |

**Return Values**

| string | success | true if added else false |
|--------|---------|--------------------------|

**Code**

```lua
function SpecializationManager:addSpecialization(name, className, filename, customEnvironment)

    if self.specializations[name] ~ = nil then
        Logging.error( "Specialization '%s' already exists.Ignoring it!" , tostring(name))
        return false
    elseif className = = nil then
            Logging.error( "No className specified for specialization '%s'" , tostring(name))
                return false
            elseif filename = = nil then
                    Logging.error( "No filename specified for specialization '%s'" , tostring(name))
                        return false
                    else

                            local specialization = { }
                            specialization.name = name
                            specialization.className = className
                            specialization.filename = filename

                            source(filename, customEnvironment)

                            local specializationObject = ClassUtil.getClassObject(className)
                            if specializationObject ~ = nil then
                                specializationObject.className = className
                            else
                                    Logging.warning( "Specialization %q could not resolve its class! Filepath: %q" , name, className)
                                end

                                self.specializations[name] = specialization
                                table.insert( self.sortedSpecializations, specialization)
                            end

                            return true
                        end

```

### getSpecializationByName

**Description**

**Definition**

> getSpecializationByName(string name)

**Arguments**

| string | name |
|--------|------|

**Return Values**

| string | specialization |
|--------|----------------|

**Code**

```lua
function SpecializationManager:getSpecializationByName(name)
    if name ~ = nil then
        return self.specializations[name]
    end

    return nil
end

```

### getSpecializationObjectByName

**Description**

**Definition**

> getSpecializationObjectByName(string name)

**Arguments**

| string | name |
|--------|------|

**Return Values**

| string | class | table |
|--------|-------|-------|

**Code**

```lua
function SpecializationManager:getSpecializationObjectByName(name)
    local entry = self.specializations[name]

    if entry = = nil then
        return nil
    end

    return ClassUtil.getClassObject(entry.className)
end

```

### getSpecializations

**Description**

**Definition**

> getSpecializations()

**Return Values**

| string | specializations | table indexed by specialization name |
|--------|-----------------|--------------------------------------|

**Code**

```lua
function SpecializationManager:getSpecializations()
    return self.specializations
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function SpecializationManager:initDataStructures()
    self.specializations = { }
    self.sortedSpecializations = { }
end

```

### initSpecializations

**Description**

**Definition**

> initSpecializations()

**Code**

```lua
function SpecializationManager:initSpecializations()
    for i = 1 , # self.sortedSpecializations do
        local specialization = self:getSpecializationObjectByName( self.sortedSpecializations[i].name)
        if specialization ~ = nil and specialization.initSpecialization ~ = nil then
            g_asyncTaskManager:addSubtask( function ()
                specialization.initSpecialization()
            end , string.format( "SpecializationManager-initSpecializations - '%s'" , self.sortedSpecializations[i].name))
        end
    end
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function SpecializationManager:loadMapData()
    SpecializationManager:superClass().loadMapData( self )

    -- Load the file, ensuring it exists.
    local xmlFile = XMLFile.loadIfExists( "SpecializationsXML" , self.xmlFilename, SpecializationManager.xmlSchema)
    if xmlFile = = nil then
        Logging.error( "Specializations XML for %q could not be loaded from %q!" , self.typeName, self.xmlFilename)
            return false
        end

        for nodeIndex, nodeKey in xmlFile:iterator( "specializations.specialization" ) do

            -- Load the data, ensuring it exists.
            local typeName = xmlFile:getValue(nodeKey .. "#name" )
            if string.isNilOrWhitespace(typeName) then
                Logging.xmlWarning(xmlFile, "Specialization node %q has missing name!" , nodeKey)
                continue
            end

            local className = xmlFile:getValue(nodeKey .. "#className" )
            if string.isNilOrWhitespace(className) then
                Logging.xmlWarning(xmlFile, "Specialization node %q has missing class name!" , nodeKey)
                continue
            end

            local filename = xmlFile:getValue(nodeKey .. "#filename" )
            if string.isNilOrWhitespace(filename) then
                Logging.xmlWarning(xmlFile, "Specialization node %q has missing filename!" , nodeKey)
                continue
            end

            -- Queue the addition of the specialization.
            g_asyncTaskManager:addSubtask( function ()
                self:addSpecialization(typeName, className, filename, "" )
            end , string.format( "SpecializationManager - Add Specialization '%s'" , className))
        end

        xmlFile:delete()

        g_asyncTaskManager:addSubtask( function ()
            Logging.info( "Loaded %q specializations" , self.typeName)
        end )

        return true
    end

```

### new

**Description**

> Creating manager

**Definition**

> new(string typeName, string xmlFilename, table? customMt)

**Arguments**

| string | typeName    |
|--------|-------------|
| string | xmlFilename |
| table? | customMt    |

**Return Values**

| table? | self | instance of object |
|--------|------|--------------------|

**Code**

```lua
function SpecializationManager.new(typeName, xmlFilename, customMt)
    local self = AbstractManager.new(customMt or SpecializationManager _mt)

    self.typeName = typeName
    self.xmlFilename = xmlFilename

    return self
end

```

### postInitSpecializations

**Description**

**Definition**

> postInitSpecializations()

**Code**

```lua
function SpecializationManager:postInitSpecializations()
    for i = 1 , # self.sortedSpecializations do
        local specialization = self:getSpecializationObjectByName( self.sortedSpecializations[i].name)
        if specialization ~ = nil and specialization.postInitSpecialization ~ = nil then
            g_asyncTaskManager:addSubtask( function ()
                specialization.postInitSpecialization()
            end , string.format( "SpecializationManager-postInitSpecializations - '%s'" , self.sortedSpecializations[i].name))
        end
    end
end

```