## GuiElement

**Description**

> GUI Element base class.
> All elements displayed in the game UI must be instances or descendants of this class.
> All XML configuration properties as declared below (and in subclasses) are mirrored in guiProfiles.xml as key-value
> pairs in the form of &ltValue name="property\_name" value="value" /&gt. Profiles are able to inherit from other
> profiles, so take care to check their hierarchy if any of your settings do not seem to have any effect. Directly set
> properties in the XML configuration will always override profile values, however.
> Layer properties, prefixed with "[layer]", interact with an overlay system and provide display images. Usable
> layers, whose names are substituted for the prefix, are primarily "image" and "icon". UI elements define layer names
> on their own and read them from these generated properties. Whenever an element requires a layer, it is described
> in its documentation such as this one. Example for an icon layer focus color property:
> iconFocusedColor="0.9 0.1 0.5 1.0".
> A note regarding callbacks: All callbacks are called on an element's target first. When GUI elements are created from
> configuration, their top-level view (e.g. MainScreen) is the callback target, i.e. MainScreen:callbackName() is
> executed. Unless an element's target has been set to another value explicitly via code, this will always be the case.

**Functions**

- [addCallback](#addcallback)
- [addElement](#addelement)
- [applyProfile](#applyprofile)
- [canReceiveFocus](#canreceivefocus)
- [clone](#clone)
- [copyAttributes](#copyattributes)
- [cutFrameBordersHorizontal](#cutframebordershorizontal)
- [cutFrameBordersVertical](#cutframebordersvertical)
- [delete](#delete)
- [draw](#draw)
- [extractIndexAndNameFromID](#extractindexandnamefromid)
- [fadeIn](#fadein)
- [fadeOut](#fadeout)
- [findDescendantsRec](#finddescendantsrec)
- [fixThinLines](#fixthinlines)
- [getAspectScale](#getaspectscale)
- [getBorders](#getborders)
- [getCenter](#getcenter)
- [getClipArea](#getcliparea)
- [getDescendantById](#getdescendantbyid)
- [getDescendantByName](#getdescendantbyname)
- [getDescendants](#getdescendants)
- [getFirstDescendant](#getfirstdescendant)
- [getFocusTarget](#getfocustarget)
- [getHandleFocus](#gethandlefocus)
- [getIsActive](#getisactive)
- [getIsActiveNonRec](#getisactivenonrec)
- [getIsDisabled](#getisdisabled)
- [getIsFocused](#getisfocused)
- [getIsHighlighted](#getishighlighted)
- [getIsSelected](#getisselected)
- [getIsVisible](#getisvisible)
- [getIsVisibleNonRec](#getisvisiblenonrec)
- [getOriginalBorders](#getoriginalborders)
- [getOverlayState](#getoverlaystate)
- [getParentBorders](#getparentborders)
- [getParentOriginalBorders](#getparentoriginalborders)
- [getSoundSuppressed](#getsoundsuppressed)
- [include](#include)
- [inputEvent](#inputevent)
- [isChildOf](#ischildof)
- [keyEvent](#keyevent)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [mouseEvent](#mouseevent)
- [move](#move)
- [new](#new)
- [onClose](#onclose)
- [onFocusActivate](#onfocusactivate)
- [onFocusEnter](#onfocusenter)
- [onFocusLeave](#onfocusleave)
- [onGuiSetupFinished](#onguisetupfinished)
- [onHighlight](#onhighlight)
- [onHighlightRemove](#onhighlightremove)
- [onOpen](#onopen)
- [raiseCallback](#raisecallback)
- [removeElement](#removeelement)
- [reset](#reset)
- [resolveSizeString](#resolvesizestring)
- [setAbsolutePosition](#setabsoluteposition)
- [setAlpha](#setalpha)
- [setDisabled](#setdisabled)
- [setFocused](#setfocused)
- [setHandleFocus](#sethandlefocus)
- [setId](#setid)
- [setPosition](#setposition)
- [setSelected](#setselected)
- [setSize](#setsize)
- [setSoundSuppressed](#setsoundsuppressed)
- [setVisible](#setvisible)
- [shouldFocusChange](#shouldfocuschange)
- [toggleFrameSide](#toggleframeside)
- [toString](#tostring)
- [touchEvent](#touchevent)
- [unlinkElement](#unlinkelement)
- [update](#update)
- [updateAbsolutePosition](#updateabsoluteposition)
- [updateFramePosition](#updateframeposition)

### addCallback

**Description**

> Add a callback to this element which was defined in its XML definition.
> If this element has a target, the given function name will be called on the target. Otherwise, the function is
> assumed to be global.

**Definition**

> addCallback(xmlFile XML, key XML, funcName Name)

**Arguments**

| xmlFile  | XML  | file handle                                |
|----------|------|--------------------------------------------|
| key      | XML  | node path of this GuiElement's definition. |
| funcName | Name | of the callback function                   |

**Code**

```lua
function GuiElement:addCallback(xmlFile, key, funcName)
    local callbackName = getXMLString(xmlFile, key)
    if callbackName ~ = nil then
        if self.target ~ = nil then
            --#debug if callbackName ~ = "onCreate" and self.target[callbackName] = = nil then
                --#debug Logging.xmlWarning(xmlFile, "Could not find callback function %q for target(id = %q, name = %q) at element %q", callbackName, (self.target.id or "") , (self.target.name or ""), key)
                    --#debug end
                    self [funcName] = self.target[callbackName]
                else
                        self [funcName] = ClassUtil.getFunction(callbackName)
                    end
                end
            end

```

### addElement

**Description**

> Add a child GuiElement to this GuiElement.

**Definition**

> addElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function GuiElement:addElement(element)
    if element.parent ~ = nil then
        element.parent:removeElement(element)
    end

    table.insert( self.elements, element)
    element.parent = self
end

```

### applyProfile

**Description**

> Apply a GUI profile with a given name to this element.

**Definition**

> applyProfile(profileName Name, boolean? blockSizeUpdate, boolean? ignoreSameProfile)

**Arguments**

| profileName | Name              | of the profile to apply to this element                                                                               |
|-------------|-------------------|-----------------------------------------------------------------------------------------------------------------------|
| boolean?    | blockSizeUpdate   | [optional] If true, will not apply position and size settings, default is false                                       |
| boolean?    | ignoreSameProfile | [optional] If true, will only apply the profile if it has a different name from the current profile, default is false |

**Code**

```lua
function GuiElement:applyProfile(profileName, blockSizeUpdate, ignoreSameProfile)
    if profileName and(ignoreSameProfile ~ = true or profileName ~ = self.profile) then
        local pro = g_gui:getProfile(profileName)
        if pro ~ = nil then
            self.profile = profileName
            self:loadProfile(pro, not blockSizeUpdate)
        end
    end
end

```

### canReceiveFocus

**Description**

> Determine if this GuiElement can receive focus.

**Definition**

> canReceiveFocus()

**Code**

```lua
function GuiElement:canReceiveFocus()
    return false -- default is not focusable, subclasses need to make themselves available
end

```

### clone

**Description**

> Create a deep copy clone of this GuiElement.

**Definition**

> clone(table parent, boolean? includeId, boolean? suppressOnCreate, )

**Arguments**

| table    | parent                   | Target parent element of the cloned element                                 |
|----------|--------------------------|-----------------------------------------------------------------------------|
| boolean? | includeId                | [optional, default=false] If true, will also clone ID values                |
| boolean? | suppressOnCreate         | [optional, default=false] If true, will not trigger the "onCreate" callback |
| any      | blockFocusHandlingReload |                                                                             |

**Return Values**

| any | Cloned | instance of this gui element |
|-----|--------|------------------------------|

**Code**

```lua
function GuiElement:clone(parent, includeId, suppressOnCreate, blockFocusHandlingReload)
    local ret = self.new()

    if parent ~ = nil then
        parent:addElement(ret)
    end

    ret:copyAttributes( self )

    for i = 1 , # self.elements do
        local clonedChild = self.elements[i]:clone(ret, includeId, suppressOnCreate, true )
        if includeId then
            clonedChild.id = self.elements[i].id
        end
    end

    if not blockFocusHandlingReload then
        ret:reloadFocusHandling( true )
    end

    if not suppressOnCreate then
        ret:raiseCallback( "onCreateCallback" , ret, ret.onCreateArgs)
    end

    return ret
end

```

### copyAttributes

**Description**

> Copy all attributes from a source GuiElement to this GuiElement.

**Definition**

> copyAttributes(table src)

**Arguments**

| table | src | Source element that the parameters are copied from |
|-------|-----|----------------------------------------------------|

**Code**

```lua
function GuiElement:copyAttributes(src)
    self.name = src.name
    self.typeName = src.typeName
    self.newLayer = src.newLayer
    self.debugEnabled = src.debugEnabled

    self.visible = src.visible
    self.focused = src.focused
    self.disabled = src.disabled
    self.selected = src.selected
    self.highlighted = src.highlighted

    self.size = table.clone(src.size)
    self.absoluteSizeOffset = src.absoluteSizeOffset and table.clone(src.absoluteSizeOffset) or nil
    self.margin = table.clone(src.margin)
    self.onCreateCallback = src.onCreateCallback
    self.onCreateArgs = src.onCreateArgs
    self.onCloseCallback = src.onCloseCallback
    self.onOpenCallback = src.onOpenCallback
    self.onDrawCallback = src.onDrawCallback

    self.target = src.target
    self.profile = src.profile
    self.fadeInTime = src.fadeInTime
    self.fadeOutTime = src.fadeOutTime
    self.alpha = src.alpha
    self.fadeDirection = src.fadeDirection
    self.updateChildrenState = src.updateChildrenState
    self.toolTipElementId = src.toolTipElementId
    self.toolTipText = src.toolTipText
    self.handleFocus = src.handleFocus
    self.clipping = src.clipping
    self.focusOnHighlight = src.focusOnHighlight
    self.focusFallthrough = src.focusFallthrough
    self.disallowFlowCut = src.disallowFlowCut

    self.ignoreLayout = src.ignoreLayout
    self.soundDisabled = src.soundDisabled

    self.hasFrame = src.hasFrame
    if self.hasFrame then
        self.frameThickness = table.clone(src.frameThickness)
        self.frameColors = src.frameColors ~ = nil and table.clone(src.frameColors, math.huge) or nil
        self.frameOverlayVisible = table.clone(src.frameOverlayVisible)
    end

    self.focusId = src.focusId
    self.focusChangeData = table.clone(src.focusChangeData)
    self.isAlwaysFocusedOnOpen = src.isAlwaysFocusedOnOpen

    self.position = table.clone(src.position)
    self.absPosition = table.clone(src.absPosition)
    self.absSize = table.clone(src.absSize)
    self.anchors = table.clone(src.anchors)
    self.anchorDeltas = table.clone(src.anchorDeltas)
    self.pivot = table.clone(src.pivot)

    if src.hotspot ~ = nil then
        self.hotspot = table.clone(src.hotspot)
    end
end

```

### cutFrameBordersHorizontal

**Description**

> Cut horizontal frame borders if a vertical frame side is thicker.

**Definition**

> cutFrameBordersHorizontal()

**Arguments**

| any | verticalPart   |
|-----|----------------|
| any | horizontalPart |
| any | isLeft         |

**Code**

```lua
function GuiElement:cutFrameBordersHorizontal(verticalPart, horizontalPart, isLeft)
    if verticalPart.width > horizontalPart.height then -- equals test for thickness
        if isLeft then
            horizontalPart.x = horizontalPart.x + verticalPart.width
        end

        horizontalPart.width = horizontalPart.width - verticalPart.width
    end
end

```

### cutFrameBordersVertical

**Description**

> Cut vertical frame borders if a horizontal frame side is thicker.

**Definition**

> cutFrameBordersVertical()

**Arguments**

| any | horizontalPart |
|-----|----------------|
| any | verticalPart   |
| any | isBottom       |

**Code**

```lua
function GuiElement:cutFrameBordersVertical(horizontalPart, verticalPart, isBottom)
    if horizontalPart.width > = verticalPart.height then -- test for greater or equals here to avoid overlaps when thickness is the same
        if isBottom then
            verticalPart.y = verticalPart.y + horizontalPart.height
        end

        verticalPart.height = verticalPart.height - horizontalPart.height
    end
end

```

### delete

**Description**

> Delete this GuiElement.
> Also deletes all child elements and removes itself from its parent and focus.

**Definition**

> delete()

**Code**

```lua
function GuiElement:delete()
    for i = # self.elements, 1 , - 1 do
        self.elements[i].parent = nil
        self.elements[i]:delete()
    end
    table.clear( self.elements)

    if self.parent ~ = nil then
        self.parent:removeElement( self )
    end
    -- unset focus data
    FocusManager:removeElement( self )
end

```

### draw

**Description**

> Draw this GuiElement.
> If defined, triggers the "onDrawCallback".

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function GuiElement:draw(clipX1, clipY1, clipX2, clipY2)
    if self.newLayer then
        new2DLayer()
    end

    -- update clip with own element clipping
    clipX1, clipY1, clipX2, clipY2 = self:getClipArea(clipX1, clipY1, clipX2, clipY2)

    self:raiseCallback( "onDrawCallback" , self )

    if self.debugEnabled or g_uiDebugEnabled then
        if self.hotspot ~ = nil then
            local xLeft = self.absPosition[ 1 ] + self.hotspot[ 1 ]
            local yTop = self.absPosition[ 2 ] + self.hotspot[ 2 ] + self.absSize[ 2 ]
            local xRight = self.absPosition[ 1 ] + self.hotspot[ 3 ] + self.absSize[ 1 ]
            local yBottom = self.absPosition[ 2 ] + self.hotspot[ 4 ]

            -- draw bottom line
            drawLine2D(xLeft, yBottom, xRight, yBottom, 2 * g_pixelSizeX, 1 , 0 , 1 , 1 )
            -- draw top line
            drawLine2D(xLeft, yTop, xRight, yTop, 2 * g_pixelSizeX, 1 , 0 , 1 , 1 )
            -- draw left line
            drawLine2D(xLeft, yBottom, xLeft, yTop, 2 * g_pixelSizeX, 1 , 0 , 1 , 1 )
            -- draw right line
            drawLine2D(xRight, yBottom, xRight, yTop, 2 * g_pixelSizeX, 1 , 0 , 1 , 1 )
        else
                drawFilledRect( self.absPosition[ 1 ] - g_pixelSizeX, self.absPosition[ 2 ] - g_pixelSizeY, self.absSize[ 1 ] + 2 * g_pixelSizeX, g_pixelSizeY, 1 , 0 , 0 , 1 )
                drawFilledRect( self.absPosition[ 1 ] - g_pixelSizeX, self.absPosition[ 2 ] + self.absSize[ 2 ], self.absSize[ 1 ] + 2 * g_pixelSizeX, g_pixelSizeY, 1 , 0 , 0 , 1 )
                drawFilledRect( self.absPosition[ 1 ] - g_pixelSizeX, self.absPosition[ 2 ], g_pixelSizeX, self.absSize[ 2 ], 1 , 0 , 0 , 1 )
                drawFilledRect( self.absPosition[ 1 ] + self.absSize[ 1 ], self.absPosition[ 2 ], g_pixelSizeX, self.absSize[ 2 ], 1 , 0 , 0 , 1 )
            end
        end

        for i = 1 , # self.elements do
            local child = self.elements[i]
            if child:getIsVisibleNonRec() then
                -- Clip beforehand so not every element class has to do it
                    child:draw(child:getClipArea(clipX1, clipY1, clipX2, clipY2))
                end
            end

            if self.hasFrame then
                for i = 1 , 4 do
                    if self.frameOverlayVisible[i] then
                        local frame = self.frameBounds[i]
                        local color = ( self.frameColors ~ = nil and self.frameColors[i]) or GuiElement.FRAME_DEFAULT_COLOR

                        drawFilledRect(frame.x, frame.y, frame.width, frame.height, color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ], clipX1, clipY1, clipX2, clipY2)
                    end
                end
            end

            if g_uiFocusDebugEnabled and self.focusId ~ = nil and self:canReceiveFocus() then
                setTextColor( 1 , 0 , 0 , 1 )
                local size = 0.008
                local y = self.absPosition[ 2 ] + self.absSize[ 2 ]
                renderText( self.absPosition[ 1 ], y - 1 * size, size, " FocusId: " .. tostring( self.focusId) .. " " .. tostring(ClassUtil.getClassNameByObject( self )))
                renderText( self.absPosition[ 1 ], y - 2 * size, size, " T: " .. tostring( self.focusChangeData[ FocusManager.TOP]))
                renderText( self.absPosition[ 1 ], y - 3 * size, size, " B: " .. tostring( self.focusChangeData[ FocusManager.BOTTOM]))
                renderText( self.absPosition[ 1 ], y - 4 * size, size, " L: " .. tostring( self.focusChangeData[ FocusManager.LEFT]))
                renderText( self.absPosition[ 1 ], y - 5 * size, size, " R: " .. tostring( self.focusChangeData[ FocusManager.RIGHT]))

                setTextColor( 1 , 1 , 1 , 1 )
            end
        end

```

### extractIndexAndNameFromID

**Description**

> Try to extract a field name and index from an element ID.
> IDs in configurations may be indexed on definition (e.g. fillTypes[2]). This function extracts the list name and
> index if such a case is found. Otherwise, it will return no index and the original element ID.

**Definition**

> extractIndexAndNameFromID(elementId Element)

**Arguments**

| elementId | Element | ID, to be used as a field name on a ScreenElement view. |
|-----------|---------|---------------------------------------------------------|

**Return Values**

| elementId | or | nil, field name |
|-----------|----|-----------------|

**Code**

```lua
function GuiElement.extractIndexAndNameFromID(elementId)
    local len = elementId:len()
    local varName = elementId
    local index = nil
    if len > = 4 and elementId:sub( len , len ) = = "]" then
        local startI = elementId:find( "[" , 1 , true )
        if startI ~ = nil and startI > 1 and startI < len - 1 then
            index = tonumber(elementId:sub(startI + 1 , len - 1 ))
            if index ~ = nil then
                varName = elementId:sub( 1 , startI - 1 )
            end
        end
    end
    return index, varName
end

```

### fadeIn

**Description**

> Fade this element into visibility.

**Definition**

> fadeIn()

**Arguments**

| any | factor |
|-----|--------|

**Code**

```lua
function GuiElement:fadeIn(factor)
    if self.fadeInTime > 0 then
        self.fadeDirection = 1 * Utils.getNoNil(factor, 1 )
        self:setAlpha( math.max( self.alpha, 0.0001 )) -- Ensure that we are considered visible and get an update
    else
            self.fadeDirection = 0
            self:setAlpha( 1 )
        end
    end

```

### fadeOut

**Description**

> Fade this element out of visibility.

**Definition**

> fadeOut()

**Arguments**

| any | factor |
|-----|--------|

**Code**

```lua
function GuiElement:fadeOut(factor)
    if self.fadeOutTime > 0 then
        self.fadeDirection = - 1 * Utils.getNoNil(factor, 1 )
    else
            self.fadeDirection = 0
            self:setAlpha( 0 )
        end
    end

```

### findDescendantsRec

**Description**

> Recursively add descendant elements of a root to an accumulator list. If a predicate function is given, it is
> evaluated per element and only elements which yield a true value for the function are added to the accumulator.

**Definition**

> findDescendantsRec(accumulator List, rootElement? Current, predicateFunction? [optional])

**Arguments**

| accumulator        | List       | which receives descendant elements                                          |
|--------------------|------------|-----------------------------------------------------------------------------|
| rootElement?       | Current    | element root whose direction children are added (after optional evaluation) |
| predicateFunction? | [optional] | If specified, will be evaluated per element (see getDescendants)            |

**Code**

```lua
function GuiElement:findDescendantsRec(accumulator, rootElement, predicateFunction)
    if not rootElement then return end -- safety
    for _, element in ipairs(rootElement.elements) do
        self:findDescendantsRec(accumulator, element, predicateFunction) -- depth first
        if not predicateFunction or predicateFunction(element) then
            table.insert(accumulator, element)
        end
    end
end

```

### fixThinLines

**Description**

**Definition**

> fixThinLines()

**Code**

```lua
function GuiElement:fixThinLines()
    if self.thinLineProtection then
        if self.size[ 1 ] ~ = 0 then
            self.size[ 1 ] = math.max( self.size[ 1 ], g_pixelSizeX)
        end

        if self.size[ 2 ] ~ = 0 then
            self.size[ 2 ] = math.max( self.size[ 2 ], g_pixelSizeY)
        end

        self:updateAbsolutePosition()
    end
end

```

### getAspectScale

**Description**

> Get aspect scaling values for this element's settings and the game's resolution.

**Definition**

> getAspectScale()

**Return Values**

| predicateFunction? | X | aspect scale factor |
|--------------------|---|---------------------|
| predicateFunction? | Y | aspect scale factor |

**Code**

```lua
function GuiElement:getAspectScale()
    return g_aspectScaleX, g_aspectScaleY
end

```

### getBorders

**Description**

> Get this element's border rectangle represented by minimum and maximum points.

**Definition**

> getBorders()

**Return Values**

| predicateFunction? | minX | minX of element border |
|--------------------|------|------------------------|
| predicateFunction? | minY | minY of element border |
| predicateFunction? | maxX | maxX of element border |
| predicateFunction? | maxY | maxY of element border |

**Code**

```lua
function GuiElement:getBorders()
    local minX = self.absPosition[ 1 ]
    local minY = self.absPosition[ 2 ]
    local maxX = self.absPosition[ 1 ] + self.absSize[ 1 ]
    local maxY = self.absPosition[ 2 ] + self.absSize[ 2 ]

    return minX, minY, maxX, maxY
end

```

### getCenter

**Description**

> Get this element's center position.

**Definition**

> getCenter()

**Return Values**

| predicateFunction? | x | absolute x position of element center |
|--------------------|---|---------------------------------------|
| predicateFunction? | y | absolute y position of element center |

**Code**

```lua
function GuiElement:getCenter()
    local x = self.absPosition[ 1 ] + self.absSize[ 1 ] * 0.5
    local y = self.absPosition[ 2 ] + self.absSize[ 2 ] * 0.5
    return x, y
end

```

### getClipArea

**Description**

> Update given clip area with clip settings

**Definition**

> getClipArea()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function GuiElement:getClipArea(clipX1, clipY1, clipX2, clipY2)
    if self.clipping then
        clipX1 = math.max(clipX1 or 0 , self.absPosition[ 1 ])
        clipY1 = math.max(clipY1 or 0 , self.absPosition[ 2 ])
        clipX2 = math.min(clipX2 or 1 , self.absPosition[ 1 ] + self.absSize[ 1 ])
        clipY2 = math.min(clipY2 or 1 , self.absPosition[ 2 ] + self.absSize[ 2 ])
    end

    return clipX1, clipY1, clipX2, clipY2
end

```

### getDescendantById

**Description**

> Get a descendant element of this element by its ID.
> This is a shorthand for getDescendants() with an ID matching predicate function.

**Definition**

> getDescendantById(id Element)

**Arguments**

| id | Element | id |
|----|---------|----|

**Return Values**

| id | or | nil |
|----|----|-----|

**Code**

```lua
function GuiElement:getDescendantById(id)
    local element = nil
    if id then
        local function findId(e)
            return e.id and e.id = = id
        end

        element = self:getFirstDescendant(findId)
    end
    return element
end

```

### getDescendantByName

**Description**

> Get a descendant element of this element by its name.
> This is a shorthand for getDescendants() with an ID matching predicate function.

**Definition**

> getDescendantByName(name Element)

**Arguments**

| name | Element | name |
|------|---------|------|

**Return Values**

| name | or | nil |
|------|----|-----|

**Code**

```lua
function GuiElement:getDescendantByName(name)
    local element = nil
    if name then
        local function findId(e)
            return e.name and e.name = = name
        end

        element = self:getFirstDescendant(findId)
    end
    return element
end

```

### getDescendants

**Description**

> Get all contained elements of this element in the entire hierarchy.
> Descendants are traversed depth-first, meaning that if elements have been properly added, the element order mirrors
> the order in the XML configuration (lines). Use this method sparingly, especially on high-level elements.
> Optionally, a predicate function can be passed which filters descendant elements. The function must return true for
> any desired element and false otherwise.

**Definition**

> getDescendants(predicateFunction? [optional])

**Arguments**

| predicateFunction? | [optional] | A function which determines if a descendant element should be returned. Must
take a GuiElement as an argument and return true if that element should be returned or false otherwise. |
| Type | Parameter |
| |

**Return Values**

| predicateFunction? | of | this element's descendants in depth-first order with contiguous numeric indices. |
|--------------------|----|----------------------------------------------------------------------------------|

**Code**

```lua
function GuiElement:getDescendants(predicateFunction)
    local descendants = { }
    self:findDescendantsRec(descendants, self , predicateFunction)
    return descendants
end

```

### getFirstDescendant

**Description**

> Get the first descendant element of this element which matches a predicate function.
> This is a shorthand for getDescendants() which returns just the first element matching the predicate function or nil
> if no matching element exists.

**Definition**

> getFirstDescendant(predicateFunction A)

**Arguments**

| predicateFunction | A | function which determines if a descendant element should be returned. Must take a
GuiElement as an argument and return true if that element should be returned or false otherwise. |
| Type | Parameter |
| |

**Return Values**

| predicateFunction | matching | descendant element in depth-first order or nil, if no element matched the predicate function |
|-------------------|----------|----------------------------------------------------------------------------------------------|

**Code**

```lua
function GuiElement:getFirstDescendant(predicateFunction)
    local element = nil
    local res = self:getDescendants(predicateFunction)
    if #res > 0 then
        element = res[ 1 ]
    end
    return element
end

```

### getFocusTarget

**Description**

> Get the actual focus target, in case a child or parent element needs to be targeted instead.

**Definition**

> getFocusTarget(incomingDirection (Optional), moveDirection (Optional))

**Arguments**

| incomingDirection | (Optional) | If specified, may return different targets for different incoming directions.             |
|-------------------|------------|-------------------------------------------------------------------------------------------|
| moveDirection     | (Optional) | Actual movement direction per input. This is the opposing direction of incomingDirection. |

**Return Values**

| moveDirection | Actual | element to focus. |
|---------------|--------|-------------------|

**Code**

```lua
function GuiElement:getFocusTarget(incomingDirection, moveDirection)
    return self
end

```

### getHandleFocus

**Description**

> Determine if this element can receive focus.

**Definition**

> getHandleFocus()

**Code**

```lua
function GuiElement:getHandleFocus()
    return self.handleFocus
end

```

### getIsActive

**Description**

> Determine if this element is active (not disabled and visible).

**Definition**

> getIsActive()

**Code**

```lua
function GuiElement:getIsActive()
    return not self.disabled and self:getIsVisible()
end

```

### getIsActiveNonRec

**Description**

> Determine if this element is active (not disabled and visible) without checking the parents

**Definition**

> getIsActiveNonRec()

**Code**

```lua
function GuiElement:getIsActiveNonRec()
    return not self.disabled and self:getIsVisibleNonRec()
end

```

### getIsDisabled

**Description**

> Determine if this element is disabled.

**Definition**

> getIsDisabled()

**Code**

```lua
function GuiElement:getIsDisabled()
    return self.disabled
end

```

### getIsFocused

**Description**

> Determine if this element is currently focused.

**Definition**

> getIsFocused()

**Code**

```lua
function GuiElement:getIsFocused()
    return self.focused
end

```

### getIsHighlighted

**Description**

> Determine if this element is currently highlighted.

**Definition**

> getIsHighlighted()

**Code**

```lua
function GuiElement:getIsHighlighted()
    return self.highlighted
end

```

### getIsSelected

**Description**

> Determine if this element is currently selected.

**Definition**

> getIsSelected()

**Code**

```lua
function GuiElement:getIsSelected()
    return self.selected
end

```

### getIsVisible

**Description**

> Determine if this element is visible.
> This checks the visibility flag of the element. If the parent is invisible, then so is this element.

**Definition**

> getIsVisible()

**Code**

```lua
function GuiElement:getIsVisible()
    if not self.visible then
        return false
    end

    if self.parent ~ = nil then
        return self.parent:getIsVisible()
    end

    return true
end

```

### getIsVisibleNonRec

**Description**

> Determine if this element is visible without checking the parents

**Definition**

> getIsVisibleNonRec()

**Code**

```lua
function GuiElement:getIsVisibleNonRec()
    return self.visible and self.alpha > 0
end

```

### getOriginalBorders

**Description**

> Get this element's original border rectangle represented by minimum and maximum points. Original border means before
> any scaling, using the values defined in the XML

**Definition**

> getOriginalBorders()

**Return Values**

| moveDirection | minX | minX of originalBorders |
|---------------|------|-------------------------|
| moveDirection | minY | minY of originalBorders |
| moveDirection | maxX | maxX of originalBorders |
| moveDirection | maxY | maxY of originalBorders |

**Code**

```lua
function GuiElement:getOriginalBorders()
    local minX = self.position[ 1 ]
    local minY = self.position[ 2 ]
    local maxX = self.position[ 1 ] + self.size[ 1 ]
    local maxY = self.position[ 2 ] + self.size[ 2 ]

    return minX, minY, maxX, maxY
end

```

### getOverlayState

**Description**

> Get this element's overlay state.

**Definition**

> getOverlayState()

**Code**

```lua
function GuiElement:getOverlayState()
    if self:getIsDisabled() then
        return GuiOverlay.STATE_DISABLED
    elseif self:getIsSelected() then
            return GuiOverlay.STATE_SELECTED
        elseif self:getIsFocused() then
                return GuiOverlay.STATE_FOCUSED
            elseif self:getIsHighlighted() then
                    return GuiOverlay.STATE_HIGHLIGHTED
                end

                return GuiOverlay.STATE_NORMAL
            end

```

### getParentBorders

**Description**

> Get the bottom left and top right corners of this element's parent's border rectangle.
> If this element has no parent, the full screen's borders are returned (i.e. 0, 0, 1, 1)

**Definition**

> getParentBorders()

**Return Values**

| moveDirection | minX | minX of parent element or full screen borders |
|---------------|------|-----------------------------------------------|
| moveDirection | minY | minY of parent element or full screen borders |
| moveDirection | maxX | maxX of parent element or full screen borders |
| moveDirection | maxY | maxY of parent element or full screen borders |

**Code**

```lua
function GuiElement:getParentBorders()
    if self.parent ~ = nil then
        return self.parent:getBorders()
    end

    return 0 , 0 , 1 , 1
end

```

### getParentOriginalBorders

**Description**

> Get the bottom left and top right corners of this element's parent's original border rectangle.
> If this element has no parent, the full screen's borders are returned (i.e. 0, 0, 1, 1)

**Definition**

> getParentOriginalBorders()

**Return Values**

| moveDirection | minX | minX of parent element or full screen original borders |
|---------------|------|--------------------------------------------------------|
| moveDirection | minY | minY of parent element or full screen original borders |
| moveDirection | maxX | maxX of parent element or full screen original borders |
| moveDirection | maxY | maxY of parent element or full screen original borders |

**Code**

```lua
function GuiElement:getParentOriginalBorders()
    if self.parent ~ = nil then
        return self.parent:getOriginalBorders()
    end

    return 0 , 0 , 1 , 1
end

```

### getSoundSuppressed

**Description**

> Get the sound suppression flag from this element.
> If the flag is set to true, no sounds should be played when interacting with this element.

**Definition**

> getSoundSuppressed()

**Code**

```lua
function GuiElement:getSoundSuppressed()
    return self.isSoundSuppressed
end

```

### include

**Description**

> Include a mixin in this element.
> See GuiMixin.lua for the details on usage and implementation of mixins.

**Definition**

> include(guiMixinType Class)

**Arguments**

| guiMixinType | Class | table reference of a descendant of GuiMixin |
|--------------|-------|---------------------------------------------|

**Code**

```lua
function GuiElement:include(guiMixinType)
    guiMixinType.new():addTo( self )
end

```

### inputEvent

**Description**

> Handles an input event on a menu input action.
> Input is first passed to the current GUI view, then to the focused element, then to the focus manager for navigation.
> When a GUI element receives input, it should always propagate the input to its parent element first so they may
> override behavior and/or set the event used flag. If properly inherited from GuiElement and descendants, this
> behavior is guaranteed.

**Definition**

> inputEvent(action Name, value Input, eventUsed If)

**Arguments**

| action    | Name  | of input action which was triggered.                                                                  |
|-----------|-------|-------------------------------------------------------------------------------------------------------|
| value     | Input | value in the range of [-1, 1] for full axes and [0, 1] for half axes (includes buttons)               |
| eventUsed | If    | true, the event has been used by an input handler and should only be acted upon in exceptional cases. |

**Return Values**

| eventUsed | if | the input event has been handled, false otherwise. |
|-----------|----|----------------------------------------------------|

**Code**

```lua
function GuiElement:inputEvent(action, value, eventUsed)
    if not eventUsed then
        eventUsed = self.parent and self.parent:inputEvent(action, value, eventUsed)
        if eventUsed = = nil then
            eventUsed = false
        end
    end

    return eventUsed
end

```

### isChildOf

**Description**

> Check if this element is the child of another element.
> This checks the full parent hierarchy.

**Definition**

> isChildOf()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function GuiElement:isChildOf(element)
    if element = = self then
        return false
    end

    local p = self.parent
    while p do
        if p = = self then
            return false
        end

        if p = = element then
            return true
        end

        p = p.parent
    end

    return false
end

```

### keyEvent

**Description**

> Key event hook for raw keyboard input.

**Definition**

> keyEvent()

**Arguments**

| any | unicode   |
|-----|-----------|
| any | sym       |
| any | modifier  |
| any | isDown    |
| any | eventUsed |

**Return Values**

| any | if | the keyboard input has been processed by this element. |
|-----|----|--------------------------------------------------------|

**Code**

```lua
function GuiElement:keyEvent(unicode, sym, modifier, isDown, eventUsed)
    if eventUsed = = nil then
        eventUsed = false
    end

    if self.visible then
        for i = # self.elements, 1 , - 1 do
            local v = self.elements[i]
            if v:keyEvent(unicode, sym, modifier, isDown, eventUsed) then
                eventUsed = true
            end
        end
    end

    return eventUsed
end

```

### loadFromXML

**Description**

> Load element data from an XML definition file.

**Definition**

> loadFromXML(xmlFile Definition, key XML)

**Arguments**

| xmlFile | Definition | XML file handle                        |
|---------|------------|----------------------------------------|
| key     | XML        | node path to this element's definition |

**Code**

```lua
function GuiElement:loadFromXML(xmlFile, key)
    local profile = getXMLString(xmlFile, key .. "#profile" )
    if profile ~ = nil then
        self.profile = profile
        local pro = g_gui:getProfile(profile) -- defaults to base reference if profile name is invalid, also prints warning in that case
            self:loadProfile(pro)
        end

        self:setId(xmlFile, key)

        self.onCreateArgs = getXMLString(xmlFile, key .. "#onCreateArgs" )
        self:addCallback(xmlFile, key .. "#onCreate" , "onCreateCallback" )
        self:addCallback(xmlFile, key .. "#onOpen" , "onOpenCallback" )
        self:addCallback(xmlFile, key .. "#onClose" , "onCloseCallback" )
        self:addCallback(xmlFile, key .. "#onDraw" , "onDrawCallback" )

        self.name = getXMLString(xmlFile, key .. "#name" ) or self.name
        self.pivot = string.getVector(getXMLString(xmlFile, key .. "#pivot" ), 2 ) or self.pivot
        self.position = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#position" ), self.position)
        self.sizeStr = getXMLString(xmlFile, key .. "#size" ) or self.sizeStr
        self.widthStr = getXMLString(xmlFile, key .. "#width" ) or self.widthStr
        self.heightStr = getXMLString(xmlFile, key .. "#height" ) or self.heightStr
        self.absoluteSizeOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#absoluteSizeOffset" ), self.absoluteSizeOffset)
        self.margin = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#margin" ), self.margin)
        self.anchors = string.getVector(getXMLString(xmlFile, key .. "#anchors" ), 4 ) or self.anchors

        self.thinLineProtection = Utils.getNoNil(getXMLBool(xmlFile, key .. "#thinLineProtection" ), self.thinLineProtection)

        self.visible = Utils.getNoNil(getXMLBool(xmlFile, key .. "#visible" ), self.visible)
        self.disabled = Utils.getNoNil(getXMLBool(xmlFile, key .. "#disabled" ), self.disabled)
        self.newLayer = Utils.getNoNil(getXMLBool(xmlFile, key .. "#newLayer" ), self.newLayer)
        self.debugEnabled = Utils.getNoNil(getXMLBool(xmlFile, key .. "#debugEnabled" ), self.debugEnabled)
        self.updateChildrenState = Utils.getNoNil(getXMLBool(xmlFile, key .. "#updateChildrenState" ), self.updateChildrenState)
        self.toolTipText = getXMLString(xmlFile, key .. "#toolTipText" )
        self.toolTipElementId = getXMLString(xmlFile, key .. "#toolTipElementId" )
        self.layoutIgnore = Utils.getNoNil(getXMLBool(xmlFile, key .. "#layoutIgnore" ), self.layoutIgnore)
        self.clipping = Utils.getNoNil(getXMLBool(xmlFile, key .. "#clipping" ), self.clipping)
        self.hotspot = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#hotspot" ), self.hotspot)

        self.handleFocus = Utils.getNoNil(getXMLBool(xmlFile, key .. "#handleFocus" ), self.handleFocus)
        self.soundDisabled = Utils.getNoNil(getXMLBool(xmlFile, key .. "#soundDisabled" ), self.soundDisabled)

        self.focusOnHighlight = Utils.getNoNil(getXMLBool(xmlFile, key .. "#focusOnHighlight" ), self.focusOnHighlight)
        self.focusFallthrough = Utils.getNoNil(getXMLBool(xmlFile, key .. "#focusFallthrough" ), self.focusFallthrough)
        self.disallowFlowCut = Utils.getNoNil(getXMLBool(xmlFile, key .. "#disallowFlowCut" ), self.disallowFlowCut)

        self.hasFrame = Utils.getNoNil(getXMLBool(xmlFile, key .. "#hasFrame" ), self.hasFrame)
        if self.hasFrame then
            self.frameThickness = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#frameThickness" ), self.frameThickness)

            local frameColors = self.frameColors or { }

            local color = getXMLString(xmlFile, key .. "#frameLeftColor" )
            frameColors[ GuiElement.FRAME_LEFT] = GuiUtils.getColorArray(color, frameColors[ GuiElement.FRAME_LEFT])
            color = getXMLString(xmlFile, key .. "#frameTopColor" )
            frameColors[ GuiElement.FRAME_TOP] = GuiUtils.getColorArray(color, frameColors[ GuiElement.FRAME_TOP])
            color = getXMLString(xmlFile, key .. "#frameRightColor" )
            frameColors[ GuiElement.FRAME_RIGHT] = GuiUtils.getColorArray(color, frameColors[ GuiElement.FRAME_RIGHT])
            color = getXMLString(xmlFile, key .. "#frameBottomColor" )
            frameColors[ GuiElement.FRAME_BOTTOM] = GuiUtils.getColorArray(color, frameColors[ GuiElement.FRAME_BOTTOM])

            self.frameColors = table.size(frameColors) > 0 and frameColors or nil

            self.frameOverlayVisible = self.frameOverlayVisible or { true , true , true , true }
        end

        local fadeInTime = getXMLFloat(xmlFile, key .. "#fadeInTime" )
        if fadeInTime ~ = nil then
            self.fadeInTime = fadeInTime * 1000
        end

        local fadeOutTime = getXMLFloat(xmlFile, key .. "#fadeOutTime" )
        if fadeOutTime ~ = nil then
            self.fadeOutTime = fadeOutTime * 1000
        end

        if self.toolTipText ~ = nil then
            if self.toolTipText:sub( 1 , 6 ) = = "$l10n_" then
                self.toolTipText = g_i18n:getText( self.toolTipText:sub( 7 ), self.customEnvironment)
            end
        end

        -- load focus properties
        FocusManager:loadElementFromXML(xmlFile, key, self )

        self:resolveSizeString()
        self:verifyConfiguration()
    end

```

### loadProfile

**Description**

> Load profile data for this element.

**Definition**

> loadProfile(profile Loaded, boolean applyProfile)

**Arguments**

| profile | Loaded       | GUI profile                                                                                                 |
|---------|--------------|-------------------------------------------------------------------------------------------------------------|
| boolean | applyProfile | If true, will re-calculate some dynamic properties. Use this when setting profiles dynamically at run time. |

**Code**

```lua
function GuiElement:loadProfile(profile, applyProfile)
    self.name = profile:getValue( "name" , self.name)
    self.pivot = string.getVector(profile:getValue( "pivot" ), 2 ) or self.pivot
    self.position = GuiUtils.getNormalizedScreenValues(profile:getValue( "position" ), self.position)
    self.sizeStr = profile:getValue( "size" , self.sizeStr)
    self.widthStr = profile:getValue( "width" , self.widthStr)
    self.heightStr = profile:getValue( "height" , self.heightStr)
    self.absoluteSizeOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "absoluteSizeOffset" ), self.absoluteSizeOffset)
    self.margin = GuiUtils.getNormalizedScreenValues(profile:getValue( "margin" ), self.margin)
    self.anchors = string.getVector(profile:getValue( "anchors" ), 4 ) or self.anchors

    self.visible = profile:getBool( "visible" , self.visible)
    self.disabled = profile:getBool( "disabled" , self.disabled)
    self.newLayer = profile:getBool( "newLayer" , self.newLayer)
    self.debugEnabled = profile:getBool( "debugEnabled" , self.debugEnabled)
    self.updateChildrenState = profile:getBool( "updateChildrenState" , self.updateChildrenState)
    self.toolTipText = profile:getValue( "toolTipText" , self.toolTipText)
    self.layoutIgnore = profile:getBool( "layoutIgnore" , self.layoutIgnore)
    self.thinLineProtection = profile:getBool( "thinLineProtection" , self.thinLineProtection)
    self.clipping = profile:getBool( "clipping" , self.clipping)
    self.focusOnHighlight = profile:getBool( "focusOnHighlight" , self.focusOnHighlight)
    self.focusFallthrough = profile:getBool( "focusFallthrough" , self.focusFallthrough)
    self.disallowFlowCut = profile:getBool( "disallowFlowCut" , self.disallowFlowCut)
    self.hotspot = GuiUtils.getNormalizedScreenValues(profile:getValue( "hotspot" ), self.hotspot)

    self.hasFrame = profile:getBool( "hasFrame" , self.hasFrame)
    if self.hasFrame then
        self.frameThickness = GuiUtils.getNormalizedScreenValues(profile:getValue( "frameThickness" ), self.frameThickness)

        local frameColors = self.frameColors or { }

        frameColors[ GuiElement.FRAME_LEFT] = GuiUtils.getColorArray(profile:getValue( "frameLeftColor" ), frameColors[ GuiElement.FRAME_LEFT])
        frameColors[ GuiElement.FRAME_TOP] = GuiUtils.getColorArray(profile:getValue( "frameTopColor" ), frameColors[ GuiElement.FRAME_TOP])
        frameColors[ GuiElement.FRAME_RIGHT] = GuiUtils.getColorArray(profile:getValue( "frameRightColor" ), frameColors[ GuiElement.FRAME_RIGHT])
        frameColors[ GuiElement.FRAME_BOTTOM] = GuiUtils.getColorArray(profile:getValue( "frameBottomColor" ), frameColors[ GuiElement.FRAME_BOTTOM])

        self.frameColors = table.size(frameColors) > 0 and frameColors or nil

        self.frameOverlayVisible = self.frameOverlayVisible or { true , true , true , true }
    end

    self.handleFocus = profile:getBool( "handleFocus" , self.handleFocus)
    self.soundDisabled = profile:getBool( "soundDisabled" , self.soundDisabled)

    local fadeInTime = profile:getValue( "fadeInTime" )
    if fadeInTime ~ = nil then
        fadeInTime = tonumber(fadeInTime)

        if fadeInTime ~ = nil then
            self.fadeInTime = fadeInTime * 1000
        else
                Logging.devWarning( "Invalid fadeInTime format for profile '%s'" , self.profile)
                end
            end

            local fadeOutTime = profile:getValue( "fadeOutTime" )
            if fadeOutTime ~ = nil then
                fadeOutTime = tonumber(fadeOutTime)

                if fadeOutTime ~ = nil then
                    self.fadeOutTime = fadeOutTime * 1000
                else
                        Logging.devWarning( "Invalid fadeOutTime format for profile '%s'" , self.profile)
                        end
                    end

                    if applyProfile then
                        self:resolveSizeString()
                        self:fixThinLines()
                        self:updateAbsolutePosition()
                    end
                end

```

### mouseEvent

**Description**

> Mouse event hook for mouse movement checks.

**Definition**

> mouseEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | button    |
| any | eventUsed |

**Code**

```lua
function GuiElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if eventUsed = = nil then
        eventUsed = false
    end

    if self.visible then
        for i = # self.elements, 1 , - 1 do
            local v = self.elements[i]
            if v ~ = nil and v:mouseEvent(posX, posY, isDown, isUp, button, eventUsed) then
                eventUsed = true
            end
        end
    end

    return eventUsed
end

```

### move

**Description**

> Modify this element's position (i.e. translate position).

**Definition**

> move()

**Arguments**

| any | dx |
|-----|----|
| any | dy |

**Code**

```lua
function GuiElement:move(dx, dy)
    self.position[ 1 ] = self.position[ 1 ] + dx
    self.position[ 2 ] = self.position[ 2 ] + dy
    self:updateAbsolutePosition()
end

```

### new

**Description**

> Create a new GuiElement.

**Definition**

> new(target Target, )

**Arguments**

| target | Target    | ScreenElement instance |
|--------|-----------|------------------------|
| any    | custom_mt |                        |

**Code**

```lua
function GuiElement.new(target, custom_mt)
    local self = setmetatable( { } , custom_mt or GuiElement _mt)
    self:include( GuiMixin ) -- adds hasIncluded() method to check for included mixins

        self.elements = { }
        self.target = target

        self.profile = ""
        self.name = nil
        self.debugEnabled = false
        self.position = { 0 , 0 }
        self.absPosition = { 0 , 0 }
        self.size = { 1 , 1 }
        self.absSize = { 1 , 1 }
        self.sizeStr = "100% 100%"
        self.widthStr = nil
        self.heightStr = nil
        self.margin = { 0 , 0 , 0 , 0 } -- left, top, right, bottom
        self.anchors = { 0 , 1 , 0 , 1 } -- xMin, xMax, yMin, yMax
        self.anchorDeltas = { } -- xMinDelta, xMaxDelta, yMinDelta, yMaxDelta
        self.pivot = { 0 , 0 }
        self.absoluteSizeOffset = nil -- xDir, yDir
        self.thinLineProtection = true
        self.disallowFlowCut = false

        --element states
        self.visible = true
        self.disabled = false
        self.selected = false
        self.focused = false
        self.highlighted = false

        self.alpha = 1
        self.fadeInTime = 0
        self.fadeOutTime = 0
        self.fadeDirection = 0
        self.newLayer = false
        self.toolTipText = nil
        self.toolTipElementId = nil
        self.toolTipElement = nil
        self.layoutIgnore = false

        self.focusOnHighlight = false
        self.focusFallthrough = false

        self.clipping = false
        self.hotspot = nil -- to define clickable area offset

        self.hasFrame = false
        if self.hasFrame then
            self.frameThickness = { 0 , 0 , 0 , 0 } -- left, top, right, bottom
            self.frameColors = {
            [ GuiElement.FRAME_LEFT] = { 1 , 1 , 1 , 1 } ,
            [ GuiElement.FRAME_TOP] = { 1 , 1 , 1 , 1 } ,
            [ GuiElement.FRAME_RIGHT] = { 1 , 1 , 1 , 1 } ,
            [ GuiElement.FRAME_BOTTOM] = { 1 , 1 , 1 , 1 } ,
            }
            self.frameOverlayVisible = { true , true , true , true }
        end

        self.updateChildrenState = true
        self.overlayState = GuiOverlay.STATE_NORMAL
        self.previousOverlayState = nil -- remembers the current overlay state when it needs to be temporarily overridden(e.g.STATE_PRESSED)

        self.isSoundSuppressed = false
        self.soundDisabled = false

        self.handleFocus = true
        self.focusChangeData = { }
        self.focusId = nil

        return self
    end

```

### onClose

**Description**

> Called on the root element of a screen view when it is closed.
> This raises the "onCloseCallback" if defined and propagates to all children.

**Definition**

> onClose()

**Code**

```lua
function GuiElement:onClose()
    self:raiseCallback( "onCloseCallback" , self )
    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onClose()
    end
end

```

### onFocusActivate

**Description**

> Called when this element has focus and the focus activation action is triggered.
> This propagates to all children.

**Definition**

> onFocusActivate()

**Code**

```lua
function GuiElement:onFocusActivate()
    for i = 1 , # self.elements do
        local child = self.elements[i]
        if child.handleFocus then
            child:onFocusActivate()
        end
    end
end

```

### onFocusEnter

**Description**

> Called when this element becomes focused.
> This propagates to all children.

**Definition**

> onFocusEnter()

**Code**

```lua
function GuiElement:onFocusEnter()
    self:setFocused( true , true )

    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onFocusEnter()
    end

    if self.toolTipElement ~ = nil and self.toolTipText ~ = nil then
        self.toolTipElement:setText( self.toolTipText)
    end
end

```

### onFocusLeave

**Description**

> Called when this element loses focus.
> This propagates to all children.

**Definition**

> onFocusLeave()

**Code**

```lua
function GuiElement:onFocusLeave()
    self:setFocused( false , true )

    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onFocusLeave()
    end

    if self.toolTipElement ~ = nil and self.toolTipText ~ = nil then
        self.toolTipElement:setText( "" )
    end
end

```

### onGuiSetupFinished

**Description**

> Called on a screen view's root GuiElement when all elements in a screen view have been created.
> The event is propagated to all children, depth-first.

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function GuiElement:onGuiSetupFinished()
    for _, elem in ipairs( self.elements) do
        elem:onGuiSetupFinished()
    end

    if self.toolTipElementId ~ = nil then
        local toolTipElement = self.target:getDescendantById( self.toolTipElementId)
        if toolTipElement ~ = nil then
            self.toolTipElement = toolTipElement
        else
                Logging.warning( "toolTipElementId '%s' not found for '%s'!" , self.toolTipElementId, self.target.name)
                end
            end
        end

```

### onHighlight

**Description**

> Called when this element is highlighted.
> This propagates to all children.

**Definition**

> onHighlight()

**Code**

```lua
function GuiElement:onHighlight()
    self:setHighlighted( true , true )

    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onHighlight()
    end

    if self.toolTipElement ~ = nil and self.toolTipText ~ = nil then
        self.toolTipElement:setText( self.toolTipText)
    end

    if self.focusOnHighlight then
        FocusManager:setFocus( self )
    end
end

```

### onHighlightRemove

**Description**

> Called when this element loses the highlight.
> This propagates to all children.

**Definition**

> onHighlightRemove()

**Code**

```lua
function GuiElement:onHighlightRemove()
    self:setHighlighted( false , true )

    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onHighlightRemove()
    end

    if self.toolTipElement ~ = nil and self.toolTipText ~ = nil then
        self.toolTipElement:setText( "" )
    end
end

```

### onOpen

**Description**

> Called on the root element of a screen view when it is opened.
> This raises the "onOpenCallback" if defined and propagates to all children.

**Definition**

> onOpen()

**Code**

```lua
function GuiElement:onOpen()
    self:raiseCallback( "onOpenCallback" , self )
    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:onOpen()
    end
end

```

### raiseCallback

**Description**

> Raise a previously added callback by name.

**Definition**

> raiseCallback()

**Arguments**

| any | name |
|-----|------|
| any | ...  |

**Code**

```lua
function GuiElement:raiseCallback(name, .. .)
    if self [name] ~ = nil then
        if self.target ~ = nil then
            return self [name]( self.target, .. .)
        else
                return self [name]( .. .)
            end
        end
        return nil
    end

```

### removeElement

**Description**

> Remove a child GuiElement from this GuiElement.

**Definition**

> removeElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function GuiElement:removeElement(element)
    for i = 1 , # self.elements do
        local child = self.elements[i]
        if child = = element then
            table.remove( self.elements, i)
            element.parent = nil
            break
        end
    end
end

```

### reset

**Description**

> Resets the state of this GuiElement and its children.

**Definition**

> reset()

**Code**

```lua
function GuiElement:reset()
    for i = 1 , # self.elements do
        self.elements[i]:reset()
    end
end

```

### resolveSizeString

**Description**

> Resolves this elements size string. if the string does not contain a "%", the value is further processed by GuiUtils.
> if a "%" is present, we set the elements size and anchors according to its parents size

**Definition**

> resolveSizeString()

**Code**

```lua
function GuiElement:resolveSizeString()
    local resolveFunc = function (str, isXVariable)
        local index = isXVariable and 1 or 2
        if string.find(str, "%%" ) ~ = nil then
            str = string.gsub(str, "%%" , "" )
            str = tonumber(str)

            if str = = nil then
                Logging.warning( "GuiElement:resolveSizeString:String %s could not be converted to a number" , str)
                return false
            end

            local percent = str / 100

            if self.parent = = nil then
                self.size[index] = 1 - ( self.absoluteSizeOffset and self.absoluteSizeOffset[index] or 0 )
            else
                    self.size[index] = percent * self.parent.size[index] - ( self.absoluteSizeOffset and self.absoluteSizeOffset[index] or 0 )
                end
            else
                    self.size[index] = GuiUtils.getNormalizedValue(str, isXVariable) or self.size[index]
                end

                return true
            end

            local sizes = string.split( self.sizeStr, " " )
            for i, str in pairs(sizes) do
                local isXVariable = i % 2 = = 1
                if not resolveFunc(str, isXVariable) then
                    break
                end
            end

            if self.widthStr ~ = nil then
                resolveFunc( self.widthStr, true )
            end

            if self.heightStr ~ = nil then
                resolveFunc( self.heightStr, false )
            end

            self:updateAnchorDeltas()
        end

```

### setAbsolutePosition

**Description**

> Directly set the absolute screen position of this GuiElement.
> Also updates children accordingly.

**Definition**

> setAbsolutePosition()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function GuiElement:setAbsolutePosition(x, y)
    x = x or self.absPosition[ 1 ]
    y = y or self.absPosition[ 2 ]

    local xDif = x - self.absPosition[ 1 ]
    local yDif = y - self.absPosition[ 2 ]
    self.absPosition[ 1 ] = x
    self.absPosition[ 2 ] = y

    for i = 1 , # self.elements do
        local child = self.elements[i]
        child:setAbsolutePosition(child.absPosition[ 1 ] + xDif, child.absPosition[ 2 ] + yDif)
    end

    if self.hasFrame then
        self:updateFramePosition()
    end
end

```

### setAlpha

**Description**

> Directly set this element's alpha (transparency) value

**Definition**

> setAlpha(alpha Transparency)

**Arguments**

| alpha | Transparency | value in the floating point range of [0, 1], where 0 is invisible and 1 is opaque. |
|-------|--------------|------------------------------------------------------------------------------------|

**Code**

```lua
function GuiElement:setAlpha(alpha)
    if alpha ~ = self.alpha then

        self.alpha = math.clamp(alpha, 0 , 1 )
        for _, childElem in pairs( self.elements) do
            childElem:setAlpha( self.alpha)
        end

        if self.alpha = = 1 or self.alpha = = 0 then
            self.fadeDirection = 0
        end
    end
end

```

### setDisabled

**Description**

> Set this element's disabled state.
> Disabled elements can be displayed differently and do not respond to input actions.

**Definition**

> setDisabled(disabled If, )

**Arguments**

| disabled | If            | true, disables the element. False enables it again. |
|----------|---------------|-----------------------------------------------------|
| any      | blockDelegate |                                                     |

**Code**

```lua
function GuiElement:setDisabled(disabled, blockDelegate)
    self.disabled = disabled

    if self.updateChildrenState and not blockDelegate then
        for _, child in pairs( self.elements) do
            child:setDisabled(disabled)
        end
    end
end

```

### setFocused

**Description**

> Set this element's focused state. Calling this function does not actually focus the element in the FocusManager,
> instead this should be called by FocusManager.setFocus()

**Definition**

> setFocused(focused If, )

**Arguments**

| focused | If            | true, sets the element as focused. |
|---------|---------------|------------------------------------|
| any     | blockDelegate |                                    |

**Code**

```lua
function GuiElement:setFocused(focused, blockDelegate)
    self.focused = focused

    if self.updateChildrenState and not blockDelegate then
        for _, child in pairs( self.elements) do
            child:setFocused(focused)
        end
    end
end

```

### setHandleFocus

**Description**

> Set this elements capability to receive focus.

**Definition**

> setHandleFocus()

**Arguments**

| any | handleFocus |
|-----|-------------|

**Code**

```lua
function GuiElement:setHandleFocus(handleFocus)
    self.handleFocus = handleFocus
end

```

### setId

**Description**

> Try setting this element's ID from its XML definition.

**Definition**

> setId()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function GuiElement:setId(xmlFile, key)
    local id = getXMLString(xmlFile, key .. "#id" )
    if id ~ = nil then
        local valid = true

        local _, varName = GuiElement.extractIndexAndNameFromID(id)

        if varName:find( "[^%w_]" ) ~ = nil then
            printError( "Error:Invalid gui element id " .. id)
            valid = false
        end

        if valid then
            self.id = id
        end
    end
end

```

### setPosition

**Description**

> Set this element's position.

**Definition**

> setPosition()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function GuiElement:setPosition(x, y)
    self.position[ 1 ] = x or self.position[ 1 ]
    self.position[ 2 ] = y or self.position[ 2 ]

    self:updateAnchorDeltas()
    self:updateAbsolutePosition()
end

```

### setSelected

**Description**

> Set this element's selected state.

**Definition**

> setSelected(selected If, )

**Arguments**

| selected | If            | true, sets the element as selected. |
|----------|---------------|-------------------------------------|
| any      | blockDelegate |                                     |

**Code**

```lua
function GuiElement:setSelected(selected, blockDelegate)
    self.selected = selected

    if self.updateChildrenState and not blockDelegate then
        for _, child in pairs( self.elements) do
            child:setSelected(selected)
        end
    end
end

```

### setSize

**Description**

> Set this element's size.

**Definition**

> setSize(boolean updateChildAnchorDeltas, , )

**Arguments**

| boolean | updateChildAnchorDeltas | if true, this elements new size will be used as the original size for children to calculate anchor deltas with. defaults to false |
|---------|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| any     | y                       |                                                                                                                                   |
| any     | updateChildAnchorDeltas |                                                                                                                                   |

**Code**

```lua
function GuiElement:setSize(x, y, updateChildAnchorDeltas)
    x = x or self.size[ 1 ]
    y = y or self.size[ 2 ]

    if self.thinLineProtection then
        if x ~ = 0 then
            x = math.max(x, g_pixelSizeX)
        end

        if y ~ = 0 then
            y = math.max(y, g_pixelSizeY)
        end
    end

    self.size[ 1 ] = x
    self.size[ 2 ] = y

    self:updateAnchorDeltas(updateChildAnchorDeltas)
    self:updateAbsolutePosition()
end

```

### setSoundSuppressed

**Description**

> Toggle a flag to suppress UI sounds issued by this element or by the FocusManager when handling this element.
> This setting will propagate to children.

**Definition**

> setSoundSuppressed()

**Arguments**

| any | doSuppress |
|-----|------------|

**Code**

```lua
function GuiElement:setSoundSuppressed(doSuppress)
    self.isSoundSuppressed = doSuppress

    for _, child in pairs( self.elements) do
        child:setSoundSuppressed(doSuppress)
    end
end

```

### setVisible

**Description**

> Set this element's visibility.

**Definition**

> setVisible()

**Arguments**

| any | visible |
|-----|---------|

**Code**

```lua
function GuiElement:setVisible(visible)
    self.visible = visible
end

```

### shouldFocusChange

**Description**

> Determine if this GuiElement should change focus in a given direction.

**Definition**

> shouldFocusChange()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function GuiElement:shouldFocusChange(direction)
    -- focus should only change if all sub elements allow the change
        for _, v in ipairs( self.elements) do
            if ( not v:shouldFocusChange(direction)) then
                return false
            end
        end

        return true
    end

```

### toggleFrameSide

**Description**

> Toggle a frame side's visibility identified by index.
> If this element has no frame this will have no effect.

**Definition**

> toggleFrameSide(integer sideIndex, )

**Arguments**

| integer | sideIndex | Index of the frame side, use one of GuiElement.FRAME_... |
|---------|-----------|----------------------------------------------------------|
| any     | isVisible |                                                          |

**Code**

```lua
function GuiElement:toggleFrameSide(sideIndex, isVisible)
    if self.hasFrame then
        self.frameOverlayVisible[sideIndex] = isVisible
    end
end

```

### toString

**Description**

> Get a nice string representation for this GUI element.

**Definition**

> toString()

**Code**

```lua
function GuiElement:toString()
    return string.format(
    "[ID: %s, FocusID: %s, GuiProfile: %s, Position: %g, %g]" ,
    tostring( self.id),
    tostring( self.focusId),
    tostring( self.profile),
    self.absPosition[ 1 ], self.absPosition[ 2 ]
    )
end

```

### touchEvent

**Description**

> Touch event hook for touch movement checks.

**Definition**

> touchEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | touchId   |
| any | eventUsed |

**Code**

```lua
function GuiElement:touchEvent(posX, posY, isDown, isUp, touchId, eventUsed)
    if eventUsed = = nil then
        eventUsed = false
    end

    if self.visible then
        for i = # self.elements, 1 , - 1 do
            local v = self.elements[i]
            if v:touchEvent(posX, posY, isDown, isUp, touchId, eventUsed) then
                eventUsed = true
            end
        end
    end

    return eventUsed
end

```

### unlinkElement

**Description**

> Safely remove this GuiElement from its parent, if it has a parent.

**Definition**

> unlinkElement()

**Code**

```lua
function GuiElement:unlinkElement()
    if self.parent ~ = nil then
        self.parent:removeElement( self )
    end
end

```

### update

**Description**

> Update this GuiElement.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function GuiElement:update(dt)
    if self.fadeDirection ~ = 0 then
        if self.fadeDirection > 0 then
            self:setAlpha( self.alpha + self.fadeDirection * (dt / self.fadeInTime))
        else
                self:setAlpha( self.alpha + self.fadeDirection * (dt / self.fadeOutTime))
            end
        end

        for _, child in ipairs( self.elements) do
            if child:getIsActiveNonRec() then
                child:update(dt)
            end
        end
    end

```

### updateAbsolutePosition

**Description**

> Update this elements absolute screen position.
> This needs to be called whenever a position, alignment, origin or size value changes.

**Definition**

> updateAbsolutePosition()

**Code**

```lua
function GuiElement:updateAbsolutePosition()
    if # self.anchorDeltas = = 0 then
        self:updateAnchorDeltas()
    end

    local minX, minY, maxX, maxY = self:getParentBorders()

    -- Get absolute anchor position(borders[3] - borders[1] = width
    local anchorPos_X1 = minX + (maxX - minX) * self.anchors[ 1 ]
    local anchorPos_X2 = minX + (maxX - minX) * self.anchors[ 2 ]
    local anchorPos_Y1 = minY + (maxY - minY) * self.anchors[ 3 ]
    local anchorPos_Y2 = minY + (maxY - minY) * self.anchors[ 4 ]

    -- Calculate new element position and size based on distance to anchors
    self.absPosition[ 1 ] = anchorPos_X1 + self.anchorDeltas[ 1 ]
    self.absPosition[ 2 ] = anchorPos_Y1 + self.anchorDeltas[ 2 ]

    self.absSize[ 1 ] = anchorPos_X2 + self.anchorDeltas[ 3 ] - self.absPosition[ 1 ]
    self.absSize[ 2 ] = anchorPos_Y2 + self.anchorDeltas[ 4 ] - self.absPosition[ 2 ]

    for i = 1 , # self.elements do
        self.elements[i]:updateAbsolutePosition()
    end

    if self.hasFrame then
        self:updateFramePosition()
    end
end

```

### updateFramePosition

**Description**

> Update the frame overlay positions if necessary.

**Definition**

> updateFramePosition()

**Code**

```lua
function GuiElement:updateFramePosition()
    local x, y = unpack( self.absPosition)
    local width, height = unpack( self.absSize)

    width = math.max(width, g_pixelSizeX)
    height = math.max(height, g_pixelSizeY)

    if self.frameBounds = = nil then
        self.frameBounds = { { } , { } , { } , { } }
    end

    local frameLeft = GuiElement.FRAME_LEFT
    local frameRight = GuiElement.FRAME_RIGHT
    local frameTop = GuiElement.FRAME_TOP
    local frameBottom = GuiElement.FRAME_BOTTOM

    local left = self.frameBounds[frameLeft]
    left.x = x
    left.y = y
    left.width = self.frameThickness[frameLeft]
    left.height = height

    local top = self.frameBounds[frameTop]
    top.x = x
    top.y = y + height - self.frameThickness[frameTop]
    top.width = width
    top.height = self.frameThickness[frameTop]

    local right = self.frameBounds[frameRight]
    right.x = x + width - self.frameThickness[frameRight]
    right.y = y
    right.width = self.frameThickness[frameRight]
    right.height = height

    local bottom = self.frameBounds[frameBottom]
    bottom.x = x
    bottom.y = y
    bottom.width = width
    bottom.height = self.frameThickness[frameBottom]

    self:cutFrameBordersHorizontal( self.frameBounds[frameLeft], self.frameBounds[frameTop], true )
    self:cutFrameBordersHorizontal( self.frameBounds[frameLeft], self.frameBounds[frameBottom], true )
    self:cutFrameBordersHorizontal( self.frameBounds[frameRight], self.frameBounds[frameTop], false )
    self:cutFrameBordersHorizontal( self.frameBounds[frameRight], self.frameBounds[frameBottom], false )

    self:cutFrameBordersVertical( self.frameBounds[frameBottom], self.frameBounds[frameLeft], true )
    self:cutFrameBordersVertical( self.frameBounds[frameBottom], self.frameBounds[frameRight], true )
    self:cutFrameBordersVertical( self.frameBounds[frameTop], self.frameBounds[frameLeft], false )
    self:cutFrameBordersVertical( self.frameBounds[frameTop], self.frameBounds[frameRight], false )
end

```