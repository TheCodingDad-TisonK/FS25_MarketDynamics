## IndexStateElement

**Description**

> Index state display element.
> Displays a visual element per screen page to let the player see an indication of their current list, page or multi-
> option selection index. The element points at a UI element which supports indexed access, such as ListElement,
> PageElement or MultiTextOption. For other cases, UI views directly manipulate the states (e.g. cycling hints in the
> loading screen).

**Parent**

> [BoxLayoutElement](?version=script&category=43&class=459)

**Functions**

- [copyAttributes](#copyattributes)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [locateIndexableElement](#locateindexableelement)
- [locateStateElementTemplate](#locatestateelementtemplate)
- [new](#new)
- [onGuiSetupFinished](#onguisetupfinished)
- [onIndexChange](#onindexchange)
- [setPageCount](#setpagecount)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function IndexStateElement:copyAttributes(src)
    IndexStateElement:superClass().copyAttributes( self , src)

    self.stateElementTemplate = src.stateElementTemplate:clone()
    self.indexableElement = src.indexableElement
    self.indexableElementId = src.indexableElementId
    self.reverseElements = src.reverseElements
    self.indexMinimizeWidth = src.indexMinimizeWidth

    self:locateIndexableElement()
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function IndexStateElement:loadFromXML(xmlFile, key)
    IndexStateElement:superClass().loadFromXML( self , xmlFile, key)

    self.stateElementTemplateId = getXMLString(xmlFile, key .. "#stateElementTemplateId" )
    self.indexableElementId = getXMLString(xmlFile, key .. "#indexableElementId" )
    self.reverseElements = Utils.getNoNil(getXMLBool(xmlFile, key .. "#reverseElements" ), self.reverseElements)
    self.indexMinimizeWidth = Utils.getNoNil(getXMLBool(xmlFile, key .. "#indexMinimizeWidth" ), self.indexMinimizeWidth)
end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function IndexStateElement:loadProfile(profile, applyProfile)
    IndexStateElement:superClass().loadProfile( self , profile, applyProfile)

    self.reverseElements = profile:getBool( "reverseElements" , self.reverseElements)
    self.indexMinimizeWidth = profile:getBool( "indexMinimizeWidth" , self.indexMinimizeWidth)
end

```

### locateIndexableElement

**Description**

> Find and store the indexable element which is configured in #indexableElementId.
> The function first locates the current view root (if possible) and then searches downwards. The search is broader
> than locateStateElementTemplate() to allow more flexibility in UI design and configuration.

**Definition**

> locateIndexableElement()

**Code**

```lua
function IndexStateElement:locateIndexableElement()
    if self.indexableElementId then -- locate indexable element if reference is set
        local root = self.parent
        local levels = 20
        while root.parent and levels > 0 do
            root = root.parent
            levels = levels - 1
        end

        self.indexableElement = root:getDescendantById( self.indexableElementId)

        if self.indexableElement then
            if self.indexableElement:hasIncluded( IndexChangeSubjectMixin ) then
                self.indexableElement:addIndexChangeObserver( self , self.onIndexChange)
            else
                    printWarning( "Warning:Element " .. tostring( self.indexableElement) .. " does not support index change observers and is not valid to be targeted by IndexStateElement " .. tostring( self ) .. ".Check configuration." )
                end
            else
                    printWarning( "Warning:IndexStateElement " .. tostring( self ) .. " could not find valid indexable element with ID [" .. tostring( self.indexableElementId) .. "].Check configuration." )
                end
            end -- otherwise assume custom control over this element
        end

```

### locateStateElementTemplate

**Description**

> Find and store the state element template which is configured in #stateElementTemplateId.
> The function searches from this elements parent downwards, so any descendant of this element or its siblings may
> contain the state element template.

**Definition**

> locateStateElementTemplate()

**Code**

```lua
function IndexStateElement:locateStateElementTemplate()
    -- get template element from configured ID
    self.stateElementTemplate = self.parent:getDescendantById( self.stateElementTemplateId)
    if self.stateElementTemplate then
        self.stateElementTemplate:setVisible( false )
        self.stateElementTemplate:setHandleFocus( false ) -- no focus, no highlight
        self.stateElementTemplate:unlinkElement() -- take out of hierarchy to avoid further updates
    else
            printWarning( "Warning:IndexStateElement " .. tostring( self ) .. " could not find state element template with ID [" .. tostring( self.stateElementTemplateId) .. "].Check configuration." )
        end
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function IndexStateElement.new(target, custom_mt)
    if custom_mt = = nil then
        custom_mt = IndexStateElement _mt
    end

    local self = BoxLayoutElement.new(target, custom_mt)

    self.pageElements = { }
    self.currentPageIndex = 1
    self.indexableElementId = nil
    self.indexableElement = nil
    self.stateElementTemplateId = nil
    self.stateElementTemplate = nil
    self.reverseElements = false
    self.indexMinimizeWidth = false

    return self
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function IndexStateElement:onGuiSetupFinished()
    IndexStateElement:superClass().onGuiSetupFinished( self )

    if not self.stateElementTemplate then
        self:locateStateElementTemplate()
    end

    if not self.indexableElement and self.indexableElementId ~ = nil then
        self:locateIndexableElement()
    end
end

```

### onIndexChange

**Description**

> Event handler for index changes.

**Definition**

> onIndexChange(integer index, integer count)

**Arguments**

| integer | index | New index        |
|---------|-------|------------------|
| integer | count | (New) item count |

**Code**

```lua
function IndexStateElement:onIndexChange(index, count)
    if count ~ = # self.pageElements then
        self:setPageCount(count, index)
    end

    self:setPageIndex(index)
end

```

### setPageCount

**Description**

> Set the page count.
> Clears current page elements and rebuilds as many as needed from the configured template.

**Definition**

> setPageCount(integer count, integer? initialIndex)

**Arguments**

| integer  | count        | Number of page indicators to display          |
|----------|--------------|-----------------------------------------------|
| integer? | initialIndex | [optional] Page index to set after rebuilding |

**Code**

```lua
function IndexStateElement:setPageCount(count, initialIndex)
    -- locate the state element template if page count has been set before GUI finalization
        if not self.stateElementTemplate then
            self:locateStateElementTemplate()
        end

        if count ~ = # self.pageElements then
            -- clear pages
            for _, element in pairs( self.pageElements) do
                self:removeElement(element)
                element:delete()
            end
            self.pageElements = { }

            -- replicate template
            for _ = 1 , count do
                local stateElement = self.stateElementTemplate:clone( self )
                stateElement:setVisible( true )
                table.insert( self.pageElements, stateElement)
            end

            -- rebuild layout
            self:invalidateLayout()
            if initialIndex then
                self:setPageIndex(initialIndex)
            end

            self:updateSize()
        end
    end

```