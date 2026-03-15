## ExtendedMotorized

**Description**

> Specialization to track fuel usage when vehicle is on a field

**Functions**

- [prerequisitesPresent](#prerequisitespresent)
- [updateConsumers](#updateconsumers)

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
function ExtendedMotorized.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Motorized , specializations) and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### updateConsumers

**Description**

**Definition**

> updateConsumers()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | dt        |
| any | accInput  |

**Code**

```lua
function ExtendedMotorized:updateConsumers(superFunc, dt, accInput)
    superFunc( self , dt, accInput)

    local _, isOnField, _ = self:getPFStatisticInfo()
    if isOnField then
        local spec = self.spec_motorized
        for _,consumer in pairs(spec.consumers) do
            if consumer.permanentConsumption and consumer.usage > 0 then
                local fillUnit = self:getFillUnitByIndex(consumer.fillUnitIndex)
                if fillUnit ~ = nil and fillUnit.lastValidFillType = = FillType.DIESEL then
                    self:updatePFStatistic( "usedFuel" , spec.lastFuelUsage / 60 / 60 / 1000 * dt)
                end
            end
        end
    end

end

```