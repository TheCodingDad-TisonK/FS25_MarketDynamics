### getClipDistancesWithLOD

**Description**

> Get clip distance respecting LODs, ignoring view distance coefficients.
> If node is not of type SHAPE, LIGHT\_SOURCE or AUDIO\_SOURCE the combined clip distance (respecting anchestry) is
> returned.

**Definition**

> getClipDistancesWithLOD(entityId objectId)

**Arguments**

| entityId | objectId | objectId |
|----------|----------|----------|

**Return Values**

| float | minDist | minDist |
|-------|---------|---------|
| float | maxDist | maxDist |