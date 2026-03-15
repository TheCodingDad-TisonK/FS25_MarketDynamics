## AIDischargeable

**Description**

> Specialization for ai discharging

**Functions**

- [getDischargeNodeAutomaticDischarge](#getdischargenodeautomaticdischarge)
- [onDischargeStateChanged](#ondischargestatechanged)

### getDischargeNodeAutomaticDischarge

**Description**

**Definition**

> getDischargeNodeAutomaticDischarge()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function AIDischargeable:getDischargeNodeAutomaticDischarge(superFunc, dischargeNode)
    -- disable automatic discharging since we control it on our own when we reach the unloading point
    if Platform.gameplay.automaticDischarge and self:getIsAIActive() then
        return false
    end

    return superFunc( self , dischargeNode)
end

```

### onDischargeStateChanged

**Description**

**Definition**

> onDischargeStateChanged()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function AIDischargeable:onDischargeStateChanged(state)
    local spec = self.spec_aiDischargeable
    if spec.currentDischargeNode ~ = nil and spec.isAIDischargeRunning and state = = Dischargeable.DISCHARGE_STATE_OFF then
        self:stoppedAIDischarge()
    end
end

```