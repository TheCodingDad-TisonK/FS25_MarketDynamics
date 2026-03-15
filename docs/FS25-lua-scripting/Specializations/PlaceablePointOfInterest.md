## PlaceablePointOfInterest

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setOwnerFarmId](#setownerfarmid)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceablePointOfInterest:onDelete()
    local spec = self.spec_pointOfInterest

    if spec.points ~ = nil then
        for _, poi in ipairs(spec.points) do
            poi:delete()
        end
    end
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
function PlaceablePointOfInterest:onLoad(savegame)
    local spec = self.spec_pointOfInterest

    spec.points = { }
    self.xmlFile:iterate( "placeable.pointOfInterest.point" , function (_, key)
        local className = self.xmlFile:getValue(key .. "#class" , "PointOfInterest" )
        local class = ClassUtil.getClassObject(className)
        if class = = nil then
            Logging.xmlError( self.xmlFile, "PointOfInterest class '%s' not defined for '%s'" , className, key)
                return
            end

            local poi = class.new( self , self.customEnvironment)
            if poi:load( self.components, self.xmlFile, key, self.customEnvironment, self.i3dMappings, self.rootNode) then
                table.insert(spec.points, poi)
            else
                    poi:delete()
                end
            end )
        end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function PlaceablePointOfInterest.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceablePointOfInterest.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceablePointOfInterest )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceablePointOfInterest )
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceablePointOfInterest.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceablePointOfInterest.setOwnerFarmId)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceablePointOfInterest.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "PointOfInterest" )
    schema:register(XMLValueType.STRING, basePath .. ".pointOfInterest.point(?)#class" )
    PointOfInterest.registerXMLPaths(schema, basePath .. ".pointOfInterest.point(?)" )
    schema:setXMLSpecializationType()
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | farmId      |
| any | noEventSend |

**Code**

```lua
function PlaceablePointOfInterest:setOwnerFarmId(superFunc, farmId, noEventSend)
    local spec = self.spec_pointOfInterest

    superFunc( self , farmId, noEventSend)

    for _, point in ipairs(spec.points) do
        point:setOwnerFarmId(farmId)
    end
end

```