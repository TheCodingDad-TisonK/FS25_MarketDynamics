## PlaceableAnimalLoadingTrigger

**Description**

> Specialization for placeable animal loading triggers

**Functions**

- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableAnimalLoadingTrigger:onDelete()
    local spec = self.spec_animalLoadingTrigger
    if spec.animalLoadingTrigger ~ = nil then
        spec.animalLoadingTrigger:delete()
        spec.animalLoadingTrigger = nil
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
function PlaceableAnimalLoadingTrigger:onLoad(savegame)
    local spec = self.spec_animalLoadingTrigger

    spec.animalLoadingTrigger = AnimalLoadingTrigger.new( self.isServer, self.isClient)
    if not spec.animalLoadingTrigger:loadFromXML( self.xmlFile, "placeable.animalLoadingTrigger" , self.components, self.i3dMappings) then
        spec.animalLoadingTrigger:delete()
        spec.animalLoadingTrigger = nil
    end
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
function PlaceableAnimalLoadingTrigger.prerequisitesPresent(specializations)
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
function PlaceableAnimalLoadingTrigger.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableAnimalLoadingTrigger )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableAnimalLoadingTrigger )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableAnimalLoadingTrigger.registerFunctions(placeableType)
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
function PlaceableAnimalLoadingTrigger.registerOverwrittenFunctions(placeableType)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableAnimalLoadingTrigger.registerSavegameXMLPaths(schema, basePath)
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
function PlaceableAnimalLoadingTrigger.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "AnimalLoadingTrigger" )
    AnimalLoadingTrigger.registerXMLPaths(schema, basePath .. ".animalLoadingTrigger" )
    schema:setXMLSpecializationType()
end

```