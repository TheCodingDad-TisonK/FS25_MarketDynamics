## DebugElement

**Description**

> base class for all Debug\* classes

**Functions**

- [addToManager](#addtomanager)
- [draw](#draw)
- [getShouldBeDrawn](#getshouldbedrawn)
- [new](#new)
- [setClipDistance](#setclipdistance)
- [setColorRGBA](#setcolorrgba)
- [setIsVisible](#setisvisible)
- [setVisbileWhenGUIOpen](#setvisbilewhenguiopen)

### addToManager

**Description**

**Definition**

> addToManager(string? groupId, float? lifetime, integer? maxCount)

**Arguments**

| string?  | groupId  | arbitrary string to group debug elements into, used for visiblity toggle and removal of multiple elements (optional) |
|----------|----------|----------------------------------------------------------------------------------------------------------------------|
| float?   | lifetime | lifetime of the debug object in ms before being automatically removed (optional)                                     |
| integer? | maxCount | maximum number of debug elements for the group, oldest element will be removed if limit is reached (optional)        |

**Return Values**

| integer? | self |
|----------|------|

**Code**

```lua
function DebugElement:addToManager(groupId, lifetime, maxCount)
    g_debugManager:addElement( self , groupId, lifetime, maxCount)

    return self
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugElement:draw()
end

```

### getShouldBeDrawn

**Description**

> dedicated function used by DebugManger to determine if draw() should be called or not

**Definition**

> getShouldBeDrawn()

**Return Values**

| integer? | shouldBeDrawn |
|----------|---------------|

**Code**

```lua
function DebugElement:getShouldBeDrawn()
    if not self.isVisible then
        return
    end

    if self.hideWhenGuiIsOpen and g_gui ~ = nil and g_gui:getIsGuiVisible() and g_gui.currentGuiName ~ = "ConstructionScreen" then
        return false
    end

    if self.clipDistance ~ = nil then
        local x, y, z = getWorldTranslation(g_cameraManager:getActiveCamera())
        if MathUtil.vector3Length(x - self.x, y - self.y, z - self.z) > self.clipDistance then
            return false
        end
    end

    return true
end

```

### new

**Description**

> Create new instance of a DebugElement

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self | instance |
|--------|------|----------|

**Code**

```lua
function DebugElement.new(customMt)
    local self = setmetatable( { } , customMt or DebugElement _mt)

    self.x, self.y, self.z = 0 , 0 , 0
    self.color = Color.new( 1 , 1 , 1 , 1 )
    self.text = nil
    self.textSize = nil
    self.textColor = nil
    self.textClipDistance = nil
    self.isVisible = true
    self.clipDistance = nil
    self.hideWhenGuiIsOpen = true

    return self
end

```

### setClipDistance

**Description**

> setClipDistance

**Definition**

> setClipDistance(float? clipDistance)

**Arguments**

| float? | clipDistance |
|--------|--------------|

**Return Values**

| float? | self |
|--------|------|

**Code**

```lua
function DebugElement:setClipDistance(clipDistance)

    --#debug Assert.isNilOrType(clipDistance, "number")

    self.clipDistance = clipDistance

    return self
end

```

### setColorRGBA

**Description**

> Set color using r,g,b,(a)

**Definition**

> setColorRGBA(float r, float g, float b, float? a)

**Arguments**

| float  | r | 0 to 1 |
|--------|---|--------|
| float  | g | 0 to 1 |
| float  | b | 0 to 1 |
| float? | a | 0 to 1 |

**Return Values**

| float? | self |
|--------|------|

**Code**

```lua
function DebugElement:setColorRGBA(r, g, b, a)

    --#debug Assert.isNilOrType(r, "number")
    --#debug Assert.isNilOrType(g, "number")
    --#debug Assert.isNilOrType(b, "number")
    --#debug Assert.isNilOrType(a, "number")

    self.color = Color.new(r,g,b,a)
    return self
end

```

### setIsVisible

**Description**

> setIsVisible

**Definition**

> setIsVisible(boolean isVisible)

**Arguments**

| boolean | isVisible |
|---------|-----------|

**Return Values**

| boolean | self |
|---------|------|

**Code**

```lua
function DebugElement:setIsVisible(isVisible)

    --#debug Assert.isType(isVisible, "boolean")

    self.isVisible = isVisible

    return self
end

```

### setVisbileWhenGUIOpen

**Description**

> setVisbileWhenGUIOpen

**Definition**

> setVisbileWhenGUIOpen(boolean isVisible)

**Arguments**

| boolean | isVisible |
|---------|-----------|

**Return Values**

| boolean | self |
|---------|------|

**Code**

```lua
function DebugElement:setVisbileWhenGUIOpen(isVisible)

    --#debug Assert.isType(isVisible, "boolean")

    self.hideWhenGuiIsOpen = not isVisible

    return self
end

```