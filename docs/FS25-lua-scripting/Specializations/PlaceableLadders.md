## PlaceableLadders

**Functions**

- [collectPickObjects](#collectpickobjects)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableLadders:collectPickObjects(superFunc, node)
    local spec = self.spec_ladders

    local foundNode = false
    if spec.ladderTriggers ~ = nil then
        for _, ladderTrigger in ipairs(spec.ladderTriggers) do
            if node = = ladderTrigger.node then
                foundNode = true
                break
            end
        end
    end

    if not foundNode then
        superFunc( self , node)
    end
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
function PlaceableLadders.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableLadders.collectPickObjects)
end

```