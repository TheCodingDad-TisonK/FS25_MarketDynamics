## AIVehicleObstacle

**Description**

> Specialization for base AI functionality

**Functions**

- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)

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
function AIVehicleObstacle.prerequisitesPresent(specializations)
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
function AIVehicleObstacle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AIVehicleObstacle )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , AIVehicleObstacle )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AIVehicleObstacle )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , AIVehicleObstacle )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , AIVehicleObstacle )
end

```