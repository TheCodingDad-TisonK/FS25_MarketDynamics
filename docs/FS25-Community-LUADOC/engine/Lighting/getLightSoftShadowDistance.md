### getLightSoftShadowDistance

**Description**

> Gets soft shadow light distance for directional lights (it's fake, fixed distance from each pixel). Ignored by spot
> lights (though it will still return a value)

**Definition**

> getLightSoftShadowDistance(entityId lightId)

**Arguments**

| entityId | lightId | id of the light source |
|----------|---------|------------------------|

**Return Values**

| float | softShadowDistance | light distance used for the soft shadow |
|-------|--------------------|-----------------------------------------|