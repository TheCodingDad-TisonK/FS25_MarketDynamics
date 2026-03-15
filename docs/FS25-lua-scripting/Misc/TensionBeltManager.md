## TensionBeltManager

**Description**

> This class handles all tension belts

**Functions**

- [getBeltData](#getbeltdata)
- [getType](#gettype)
- [initDataStructures](#initdatastructures)
- [new](#new)
- [onCreateTensionBelt](#oncreatetensionbelt)
- [unloadMapData](#unloadmapdata)

### getBeltData

**Description**

**Definition**

> getBeltData()

**Arguments**

| any | beltName |
|-----|----------|

**Code**

```lua
function TensionBeltManager:getBeltData(beltName)
    if beltName = = nil then
        return self.defaultBeltData
    end

    local beltType = self:getType(beltName)

    local beltData = self.belts[beltType]
    if beltData = = nil then
        return self.defaultBeltData
    end

    return beltData
end

```

### getType

**Description**

**Definition**

> getType()

**Arguments**

| any | beltName |
|-----|----------|

**Code**

```lua
function TensionBeltManager:getType(beltName)
    return "BELT_TYPE_" .. string.upper(beltName)
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function TensionBeltManager:initDataStructures()
    self.belts = { }
    self.defaultBeltData = nil
end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function TensionBeltManager.new(customMt)
    local self = setmetatable( { } , customMt or TensionBeltManager _mt)

    self:initDataStructures()

    return self
end

```

### onCreateTensionBelt

**Description**

**Definition**

> onCreateTensionBelt()

**Arguments**

| any | _  |
|-----|----|
| any | id |

**Code**

```lua
function TensionBeltManager.onCreateTensionBelt(_, id)
    local self = g_tensionBeltManager

    local name = Utils.getNoNil(getUserAttribute(id, "name" ), "default" )
    local width = Utils.getNoNil(getUserAttribute(id, "width" ), 0.15 )
    local beltType = self:getType(name)

    if self.belts[beltType] ~ = nil then
        printWarning( "Warning:Tension belt type '" .. name .. "' already exists!" )
        return
    end

    local belt = { }
    belt.width = width

    for i = 0 , getNumOfChildren(id) - 1 do
        local node = getChildAt(id, i)

        if getUserAttribute(node, 'isMaterial') then
            belt.material = { materialId = getMaterial(node, 0 ), uvScale = Utils.getNoNil(getUserAttribute(node, 'uvScale'), 0.1 ) }

        elseif getUserAttribute(node, 'isDummyMaterial') then
                belt.dummyMaterial = { materialId = getMaterial(node, 0 ), uvScale = Utils.getNoNil(getUserAttribute(node, 'uvScale'), 0.1 ) }

            elseif getUserAttribute(node, 'isHook') then
                    if belt.hook ~ = nil then
                        local _,_,z = getTranslation(getChildAt(node, 0 ))
                        belt.hook2 = { node = node, sizeRatio = z }
                    else
                            local _,_,z = getTranslation(getChildAt(node, 0 ))
                            belt.hook = { node = node, sizeRatio = z }
                        end

                    elseif getUserAttribute(node, 'isRatchet') then
                            local _,_,z = getTranslation(getChildAt(node, 0 ))
                            belt.ratchet = { node = node, sizeRatio = z }
                        end
                    end

                    if belt.material = = nil then
                        printWarning( "Warning:No material defined for tension belt type '" .. name .. "'!" )
                            return
                        end

                        if belt.dummyMaterial = = nil then
                            printWarning( "Warning:No material defined for tension belt type '" .. name .. "'!" )
                                return
                            end

                            self.belts[beltType] = belt

                            if self.defaultBeltData = = nil then
                                self.defaultBeltData = belt
                            end
                        end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function TensionBeltManager:unloadMapData()
    self:initDataStructures()
end

```