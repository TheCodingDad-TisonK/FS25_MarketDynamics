## WildlifeInstanceSimple

**Parent**

> [WildlifeInstance](?version=script&category=&class=)

**Functions**

- [getCanDespawnNow](#getcandespawnnow)

### getCanDespawnNow

**Description**

> Finds if this instance wants to currently despawn. This will be false if the instance is in the process of despawning.

**Definition**

> getCanDespawnNow()

**Return Values**

| any | canDespawn | True if this species has a despawn time range defined, the instance has been alive for long enough, and the instance is not already fleeing; otherwise false. |
|-----|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function WildlifeInstanceSimple:getCanDespawnNow()
    return not self.stateMachine.states.flee.fleeingToDespawn and self.despawnTime ~ = nil and self:getSecondsSinceSpawn() > = self.despawnTime
end

```