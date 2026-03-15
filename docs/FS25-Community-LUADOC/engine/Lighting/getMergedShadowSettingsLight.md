### getMergedShadowSettingsLight

**Description**

> Gets ID of the shadow settings light used in a given group of light sources with merged shadows. Will return id 0 if
> the light source doesn't have any settings light, or if its not part of a merged shadow group.

**Definition**

> getMergedShadowSettingsLight(entityId lightId)

**Arguments**

| entityId | lightId | id of one of the light sources in a given merged shadow group |
|----------|---------|---------------------------------------------------------------|

**Return Values**

| entityId | settingsLightId | id of the shadow settings light (or 0 if there isn't one assigned to the merged shadow group) |
|----------|-----------------|-----------------------------------------------------------------------------------------------|