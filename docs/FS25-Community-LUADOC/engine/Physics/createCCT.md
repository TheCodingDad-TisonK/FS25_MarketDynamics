### createCCT

**Description**

> Create character controller (y axis capsule based). Total resulting capsule height is 2 \* radius + height

**Definition**

> createCCT(entityId transformId, float radius, float height, float stepOffset, float slopeLimit, float skinWidth,
> integer collisionGroup, integer collisionMask, float mass)

**Arguments**

| entityId | transformId    | transformId                                 |
|----------|----------------|---------------------------------------------|
| float    | radius         | radius of the cylinder and capsule ends     |
| float    | height         | height of the cylinder part of the capsule. |
| float    | stepOffset     | stepOffset                                  |
| float    | slopeLimit     | slopeLimit (in degrees)                     |
| float    | skinWidth      | skinWidth                                   |
| integer  | collisionGroup | collisionGroup                              |
| integer  | collisionMask  | collisionMask                               |
| float    | mass           | mass                                        |

**Return Values**

| integer | characterIndex | characterIndex |
|---------|----------------|----------------|