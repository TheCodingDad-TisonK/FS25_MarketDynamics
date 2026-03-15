### renderOverlay

**Description**

> Render overlay
> Only allowed to be called within "draw"

**Definition**

> renderOverlay(entityId overlayId, float x, float y, float width, float height)

**Arguments**

| entityId | overlayId | overlayId                                |
|----------|-----------|------------------------------------------|
| float    | x         | screenspace x [0 ..1]                    |
| float    | y         | screenspace y [0 ..1]                    |
| float    | width     | normalized width, 1 = full screen width  |
| float    | height    | normalized height 1 = full screen height |