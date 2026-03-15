### getLightSoftShadowSize

**Description**

> Gets soft shadow size. This is essentially the size of the virtual/imagined light source that is casting the soft
> shadow (for directional lights, instead of an infinitely far away sun, it's a fake square light source). The size of
> the
> shadow on the floor is then a function of this size, the light source distance from the ground,
> and the distance of shadow blocker to the ground. For dir lights, the light source distance is fixed at a fake
> distance, and can be set with another scripting command (setLightSoftShadowDistance).

**Definition**

> getLightSoftShadowSize(entityId lightId)

**Arguments**

| entityId | lightId | id of the light source |
|----------|---------|------------------------|

**Return Values**

| float | softShadowSize | soft shadow light size |
|-------|----------------|------------------------|