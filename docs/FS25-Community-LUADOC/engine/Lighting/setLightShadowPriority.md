### setLightShadowPriority

**Description**

> Sets shadow priority (float value) for the given shadow light. Higher value means higher priority (will be picked
> before lower priority lights when too many shadows are on the screen).

**Definition**

> setLightShadowPriority(entityId lightId, float shadowPriority)

**Arguments**

| entityId | lightId        | id of the light source                    |
|----------|----------------|-------------------------------------------|
| float    | shadowPriority | shadow priority value of the light source |