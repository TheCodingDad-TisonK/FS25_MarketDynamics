### setLightSoftShadowDistance

**Description**

> Sets soft shadow light distance for directional lights (it's fake, fixed distance from each pixel). Ignored by spot
> lights.

**Definition**

> setLightSoftShadowDistance(entityId lightId, float softShadowDistance)

**Arguments**

| entityId | lightId            | id of the light source                                           |
|----------|--------------------|------------------------------------------------------------------|
| float    | softShadowDistance | Distance (in meters) of the fake area light source to the ground |