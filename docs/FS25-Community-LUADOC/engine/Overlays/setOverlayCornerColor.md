### setOverlayCornerColor

**Description**

> Set overlay color and alpha for specified corner
> Values are linearly interpolated between the corners allowing for gradients

**Definition**

> setOverlayCornerColor(entityId overlayId, integer cornerIndex, float red, float green, float blue, float alpha)

**Arguments**

| entityId | overlayId   | overlayId                                                                                        |
|----------|-------------|--------------------------------------------------------------------------------------------------|
| integer  | cornerIndex | corner index (same order as uvs: 0 = bottom left, 1 = top left, 2 = bottom right, 3 = top right) |
| float    | red         | red                                                                                              |
| float    | green       | green                                                                                            |
| float    | blue        | blue                                                                                             |
| float    | alpha       | alpha                                                                                            |