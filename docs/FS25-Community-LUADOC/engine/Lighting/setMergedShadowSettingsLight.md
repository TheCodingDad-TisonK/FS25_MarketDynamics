### setMergedShadowSettingsLight

**Description**

> Sets the shadow settings light for a group of light sources with merged shadows. This will replace the automatic
> computation and explicitly use all the shadow settings from the given shadow settings light when rendering the merged
> shadow.

**Definition**

> setMergedShadowSettingsLight(entityId lightId, entityId shadowSettingsLightId)

**Arguments**

| entityId | lightId               | id of one of the light sources in a given merged shadow group   |
|----------|-----------------------|-----------------------------------------------------------------|
| entityId | shadowSettingsLightId | id the light source that should be used as a source of settings |