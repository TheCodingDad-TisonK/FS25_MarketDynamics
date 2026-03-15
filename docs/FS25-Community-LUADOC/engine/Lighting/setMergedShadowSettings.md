### setMergedShadowSettings

**Description**

> Sets various shadow settings of the merged shadow that this light belongs to (sets it for all lights in the group).
> Arguments can be nil if you'd like one of them to remain unchanged.
> By default, these are simply set to the equivalent settings of the very first light that was added to the merged
> shadow group.
> If you are unsure about the exact values of some settings, you can hand in the equivalent setting of one of the lights
> in the group (e.g. depth bias, shadow map resolution, etc.).

**Definition**

> setMergedShadowSettings(entityId lightId, float? depthBias, float? slopeScaleDepthBias, float? slopeScaleDepthClamp,
> integer? shadowMapResolution)

**Arguments**

| entityId | lightId              | id of the light source node                                                                                                 |
|----------|----------------------|-----------------------------------------------------------------------------------------------------------------------------|
| float?   | depthBias            | shadow map depth bias for the merged shadow [optional, default=currentValue]                                                |
| float?   | slopeScaleDepthBias  | slope-scaled shadow map depth bias for the merged shadow [optional, default=currentValue]                                   |
| float?   | slopeScaleDepthClamp | clamp for the slope-scaled shadow map depth bias for the merged shadow [optional, default=currentValue]                     |
| integer? | shadowMapResolution  | resolution of the merged shadow's shadow/depth map, will be used for both width and height [optional, default=currentValue] |