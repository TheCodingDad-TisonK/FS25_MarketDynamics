## ExtendedWearable

**Description**

> Specialization to track vehicle wear costs

**Functions**

- [onPostUpdateTick](#onpostupdatetick)
- [prerequisitesPresent](#prerequisitespresent)

### onPostUpdateTick

**Description**

**Definition**

> onPostUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function ExtendedWearable:onPostUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedWearable.SPEC_TABLE_NAME]

    local damage = self.spec_wearable.damage
    if spec.lastDamage > 0 then
        local price = self:getPrice()
        local lastRepairPrice = Wearable.calculateRepairPrice(price, spec.lastDamage)
        local repairPrice = Wearable.calculateRepairPrice(price, damage)
        local repairCosts = repairPrice - lastRepairPrice
        if repairCosts > 0 then
            local _, isOnField, _ = self:getPFStatisticInfo()
            if isOnField then
                self:updatePFStatistic( "vehicleCosts" , repairCosts)
            end
        end
    end

    spec.lastDamage = damage
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
function ExtendedWearable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Wearable , specializations) and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```