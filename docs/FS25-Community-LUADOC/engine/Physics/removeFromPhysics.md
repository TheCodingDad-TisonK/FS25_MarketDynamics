### removeFromPhysics

**Description**

> Remove node and recursively all child nodes from physics
> Not instant as physics run in a separate thread with an independent framerate.
> Use getIsAddedToPhysics() to check a nodes current state.

**Definition**

> removeFromPhysics(entityId transformId)

**Arguments**

| entityId | transformId | transformId |
|----------|-------------|-------------|