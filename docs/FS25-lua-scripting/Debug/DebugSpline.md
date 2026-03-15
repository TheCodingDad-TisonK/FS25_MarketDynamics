## DebugSpline

**Parent**

> [DebugElement](?version=script&category=21&class=212)

**Functions**

- [draw](#draw)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugSpline:draw()
    DebugSpline.renderForNode( self.splineNodeId, self.color, self.text or self.defaultText, self.clipDistance, self.displayEPs, self.closestCamSplineTime, self.closestCamPosX, self.closestCamPosY, self.closestCamPosZ, self.textClipDistance)
end

```