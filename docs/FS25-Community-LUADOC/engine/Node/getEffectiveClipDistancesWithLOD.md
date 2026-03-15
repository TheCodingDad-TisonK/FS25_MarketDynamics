### getEffectiveClipDistancesWithLOD

**Description**

> Get effective clip distance respecting LODs and current view distance coefficients.
> If node is not of type SHAPE, LIGHT\_SOURCE or AUDIO\_SOURCE the effective (including coefficient), combined (
> respecting anchestry) clip distance is returned.

**Definition**

> getEffectiveClipDistancesWithLOD(entityId objectId)

**Arguments**

| entityId | objectId | objectId |
|----------|----------|----------|

**Return Values**

| float | minDist | minDist |
|-------|---------|---------|
| float | maxDist | maxDist |