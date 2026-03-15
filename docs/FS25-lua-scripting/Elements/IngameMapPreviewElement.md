## IngameMapPreviewElement

**Parent**

> [GuiElement](?version=script&category=27&class=219)

**Functions**

- [onClose](#onclose)

### onClose

**Description**

**Definition**

> onClose()

**Code**

```lua
function IngameMapPreviewElement:onClose()
    IngameMapPreviewElement:superClass().onClose( self )
    self.ingameMap:setCustomLayout( nil )
    self.ingameMap.clipHotspots = false
    self.ingameMap:setMapClipArea( nil , nil , nil , nil )
end

```