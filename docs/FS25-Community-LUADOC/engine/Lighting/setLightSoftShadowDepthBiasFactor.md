### setLightSoftShadowDepthBiasFactor

**Description**

> Sets soft shadow depth bias factor of light source. The bias factor is multiplied with the depth bias of the light
> source (e.g. depth bias = 0.0001f, bias factor = 2.0f -> depth bias is 0.0002f). They are separated so you can still
> have the normal bias for PCF shadows (when soft shadows are disabled), which generally
> need a smaller bias.

**Definition**

> setLightSoftShadowDepthBiasFactor(entityId lightId, float softShadowDistance)

**Arguments**

| entityId | lightId            | id of the light source                                      |
|----------|--------------------|-------------------------------------------------------------|
| float    | softShadowDistance | depth bias factor for soft shadows used by the light source |