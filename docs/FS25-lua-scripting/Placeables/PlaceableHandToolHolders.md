## PlaceableHandToolHolders

**Description**

> Specialisation for placeables that contain HandToolHolders.

**Functions**

- [registerEvents](#registerevents)
- [setName](#setname)

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function PlaceableHandToolHolders.registerEvents(vehicleType)
end

```

### setName

**Description**

**Definition**

> setName()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | name        |
| any | noEventSend |

**Code**

```lua
function PlaceableHandToolHolders:setName(superFunc, name, noEventSend)
    superFunc( self , name, noEventSend)

    local spec = self.spec_handToolHolders

    if spec.handToolHolders ~ = nil then
        for _, handToolHolder in ipairs(spec.handToolHolders) do
            handToolHolder:setName(name)
        end
    end
end

```