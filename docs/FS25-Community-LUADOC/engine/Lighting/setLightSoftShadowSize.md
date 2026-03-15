### setLightSoftShadowSize

**Description**

> Sets soft shadow size. This is essentially the size of the virtual/imagined light source that is casting the soft
> shadow (for directional lights, instead of an infinitely far away sun, it's a fake square light source). The size of
> the
> shadow on the floor is then a function of this size, the light source distance from the ground,
> and the distance of shadow blocker to the ground.

**Definition**

> setLightSoftShadowSize(entityId lightId, float softShadowSize)

**Arguments**

| entityId | lightId        | id of the light source |
|----------|----------------|------------------------|
| float    | softShadowSize | soft shadow light size |