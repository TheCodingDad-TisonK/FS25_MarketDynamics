### setMergedShadowNearPlaneOffset

**Description**

> Sets the near plane for culling and rendering of the given merged shadow. Useful if the center of the merged shadow
> ends up inside objects and you want it to only start rendering at some distance from the center.

**Definition**

> setMergedShadowNearPlaneOffset(entityId lightId, float nearPlane)

**Arguments**

| entityId | lightId   | id of the light source node     |
|----------|-----------|---------------------------------|
| float    | nearPlane | near plane of the merged shadow |