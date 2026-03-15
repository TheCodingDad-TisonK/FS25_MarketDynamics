## PlaceableWorkshop

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
function PlaceableWorkshop:onDelete()
    local spec = self.spec_workshop

    if spec.sellingPoint ~ = nil then
        spec.sellingPoint:delete()
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
function PlaceableWorkshop:onLoad(savegame)
    local spec = self.spec_workshop

    spec.sellingPoint = VehicleSellingPoint.new()
    spec.sellingPoint:load( self.components, self.xmlFile, "placeable.workshop.sellingPoint" , self.i3dMappings)
    spec.sellingPoint:setOwnerFarmId( self:getOwnerFarmId())
    spec.sellingPoint.owningPlaceable = self
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
function PlaceableWorkshop.prerequisitesPresent(specializations)
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
function PlaceableWorkshop.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWorkshop )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWorkshop )
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
function PlaceableWorkshop.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableWorkshop.setOwnerFarmId)
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
function PlaceableWorkshop.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Workshop" )
    VehicleSellingPoint.registerXMLPaths(schema, basePath .. ".workshop.sellingPoint" )
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
| any | ownerFarmId |
| any | noEventSend |

**Code**

```lua
function PlaceableWorkshop:setOwnerFarmId(superFunc, ownerFarmId, noEventSend)
    local spec = self.spec_workshop

    superFunc( self , ownerFarmId, noEventSend)

    if spec.sellingPoint ~ = nil then
        spec.sellingPoint:setOwnerFarmId(ownerFarmId)
    end
end

```