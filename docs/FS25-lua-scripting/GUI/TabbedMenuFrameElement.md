## TabbedMenuFrameElement

**Description**

> Base class for frame elements for the in-game menu.

**Parent**

> [FrameElement](?version=script&category=43&class=498)

**Functions**

- [clearMenuButtonInfoDirty](#clearmenubuttoninfodirty)
- [getHasCustomMenuButtons](#gethascustommenubuttons)
- [getMainElementPosition](#getmainelementposition)
- [getMainElementSize](#getmainelementsize)
- [getMenuButtonInfo](#getmenubuttoninfo)
- [initialize](#initialize)
- [isMenuButtonInfoDirty](#ismenubuttoninfodirty)
- [new](#new)
- [onFrameClose](#onframeclose)
- [onFrameOpen](#onframeopen)
- [requestClose](#requestclose)
- [setMenuButtonInfo](#setmenubuttoninfo)
- [setMenuButtonInfoDirty](#setmenubuttoninfodirty)
- [setTitle](#settitle)

### clearMenuButtonInfoDirty

**Description**

> Clear menu button dirty flag.

**Definition**

> clearMenuButtonInfoDirty()

**Code**

```lua
function TabbedMenuFrameElement:clearMenuButtonInfoDirty()
    self.menuButtonsDirty = false
end

```

### getHasCustomMenuButtons

**Description**

> Check if this menu frame requires menu button customization.

**Definition**

> getHasCustomMenuButtons()

**Code**

```lua
function TabbedMenuFrameElement:getHasCustomMenuButtons()
    return self.hasCustomMenuButtons
end

```

### getMainElementPosition

**Description**

> Get the frame's main content element's screen position.

**Definition**

> getMainElementPosition()

**Code**

```lua
function TabbedMenuFrameElement:getMainElementPosition()
    return { 0 , 0 }
end

```

### getMainElementSize

**Description**

> Get the frame's main content element's screen size.

**Definition**

> getMainElementSize()

**Code**

```lua
function TabbedMenuFrameElement:getMainElementSize()
    return { 1 , 1 }
end

```

### getMenuButtonInfo

**Description**

> Get custom menu button information.

**Definition**

> getMenuButtonInfo()

**Return Values**

| any | Array | of button info as {i={inputAction=, text=, callback=}} |
|-----|-------|--------------------------------------------------------|

**Code**

```lua
function TabbedMenuFrameElement:getMenuButtonInfo()
    return self.menuButtonInfo
end

```

### initialize

**Description**

> Late initialization of a menu frame.
> Override in sub-classes.

**Definition**

> initialize()

**Arguments**

| any | ... |
|-----|-----|

**Code**

```lua
function TabbedMenuFrameElement:initialize( .. .)
end

```

### isMenuButtonInfoDirty

**Description**

> Get the menu button info dirty state (has changed).

**Definition**

> isMenuButtonInfoDirty()

**Code**

```lua
function TabbedMenuFrameElement:isMenuButtonInfoDirty()
    return self.menuButtonsDirty
end

```

### new

**Description**

> Create a new TabbedMenuFrameElement instance.

**Definition**

> new()

**Arguments**

| any | target   |
|-----|----------|
| any | customMt |

**Code**

```lua
function TabbedMenuFrameElement.new(target, customMt)
    local self = FrameElement.new(target, customMt or TabbedMenuFrameElement _mt)

    self.hasCustomMenuButtons = false
    self.menuButtonInfo = { }
    self.menuButtonsDirty = false
    self.title = nil
    self.tabbingMenuVisibleDirty = false
    self.tabbingMenuVisible = true
    self.currentPage = 1

    self:setNumberOfPages( 1 )

    self.requestCloseCallback = NO_CALLBACK -- close request accepted callback

    return self
end

```

### onFrameClose

**Description**

> Called when this frame is closed by its container.

**Definition**

> onFrameClose()

**Code**

```lua
function TabbedMenuFrameElement:onFrameClose()
    TabbedMenuFrameElement:superClass().onClose( self )
end

```

### onFrameOpen

**Description**

> Called when this frame is opened by its container.

**Definition**

> onFrameOpen()

**Code**

```lua
function TabbedMenuFrameElement:onFrameOpen()
    TabbedMenuFrameElement:superClass().onOpen( self )

    self:updatePagingButtons()
end

```

### requestClose

**Description**

> Request to close the frame.
> Frames can contain logic (e.g. saving pending changes) which should be handled before closing. Use this method in
> sub-classes request closing the frame so it can wrap up first. If a callback is provided and the initial request
> could not close the frame, the callback will be called as soon as the frame can be closed.

**Definition**

> requestClose()

**Arguments**

| any | callback |
|-----|----------|

**Code**

```lua
function TabbedMenuFrameElement:requestClose(callback)
    self.requestCloseCallback = callback or NO_CALLBACK
    return true
end

```

### setMenuButtonInfo

**Description**

> Set custom menu button information.

**Definition**

> setMenuButtonInfo(table? menuButtonInfo)

**Arguments**

| table? | menuButtonInfo | Array of button info as {i={inputAction=, text=, callback=}} or nil to reset. |
|--------|----------------|-------------------------------------------------------------------------------|

**Code**

```lua
function TabbedMenuFrameElement:setMenuButtonInfo(menuButtonInfo)
    self.menuButtonInfo = menuButtonInfo
    self.hasCustomMenuButtons = menuButtonInfo ~ = nil
end

```

### setMenuButtonInfoDirty

**Description**

> Set the menu button info dirty flag which causes the menu to update the buttons from this element's information.

**Definition**

> setMenuButtonInfoDirty()

**Code**

```lua
function TabbedMenuFrameElement:setMenuButtonInfoDirty()
    self.menuButtonsDirty = true
end

```

### setTitle

**Description**

> Set a new title for the frame

**Definition**

> setTitle()

**Arguments**

| any | title |
|-----|-------|

**Code**

```lua
function TabbedMenuFrameElement:setTitle(title)
    self.title = title
    if self.pagingTitle ~ = nil then
        self.pagingTitle:setText(title)
    end
end

```