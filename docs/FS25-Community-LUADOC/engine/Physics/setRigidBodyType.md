### setRigidBodyType

**Description**

> Set rigid body type. If shape does not have CPU-Mesh flag set, setting the type to NONE will clear the baked physics
> data.
> To temporarily disable physics for a node use removeFromPhysics() and addToPhysics() functions instead.

**Definition**

> setRigidBodyType(entityId transformId, integer type)

**Arguments**

| entityId | transformId | transformId                 |
|----------|-------------|-----------------------------|
| integer  | type        | one of enum RIGID_BODY_TYPE |