## PagingElement

**Description**

> Paging control element.
> Organizes grouped elements into pages to be displayed one at a time. To set it up, one defines several
> same-sized container elements (e.g. bare GuiElement) as children of the PagingElement to hold the pages' contents.
> The pages should be given #name properties which are resolved to a localization text with a prepended "ui\_" prefix.
> On loading, any named child element of this PagingElement will be added as a page.

**Parent**

> [GuiElement](?version=script&category=43&class=482)

**Functions**

- [addElement](#addelement)
- [copyAttributes](#copyattributes)
- [getCurrentPageId](#getcurrentpageid)
- [getIsPageDisabled](#getispagedisabled)
- [getPageById](#getpagebyid)
- [getPageMappingIndex](#getpagemappingindex)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onGuiSetupFinished](#onguisetupfinished)
- [removeElement](#removeelement)
- [setPageDisabled](#setpagedisabled)
- [updatePageMapping](#updatepagemapping)

### addElement

**Description**

**Definition**

> addElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function PagingElement:addElement(element)
    PagingElement:superClass().addElement( self , element)
    if element.name ~ = nil and g_i18n:hasText( "ui_" .. element.name) then
        self:addPage( string.upper(element.name), element, g_i18n:getText( "ui_" .. element.name))
    else
            self:addPage( tostring(element), element, "" )
        end
    end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function PagingElement:copyAttributes(src)
    PagingElement:superClass().copyAttributes( self , src)
    self.onPageChangeCallback = src.onPageChangeCallback
    self.onPageUpdateCallback = src.onPageUpdateCallback

    GuiMixin.cloneMixin( IndexChangeSubjectMixin , src, self )
end

```

### getCurrentPageId

**Description**

> Get the page ID of the currently displayed page.

**Definition**

> getCurrentPageId()

**Code**

```lua
function PagingElement:getCurrentPageId()
    return self.pages[ self.currentPageIndex].id
end

```

### getIsPageDisabled

**Description**

> Determine if a page, identified by page ID, is disabled.

**Definition**

> getIsPageDisabled()

**Arguments**

| any | pageId |
|-----|--------|

**Code**

```lua
function PagingElement:getIsPageDisabled(pageId)
    return self.idPageHash[pageId].disabled
end

```

### getPageById

**Description**

> Get a page by ID.

**Definition**

> getPageById()

**Arguments**

| any | pageId |
|-----|--------|

**Code**

```lua
function PagingElement:getPageById(pageId)
    return self.idPageHash[pageId]
end

```

### getPageMappingIndex

**Description**

> Get the index of a page in the page mappings (only visible pages) by page ID.

**Definition**

> getPageMappingIndex()

**Arguments**

| any | pageId |
|-----|--------|

**Code**

```lua
function PagingElement:getPageMappingIndex(pageId)
    return self.idPageHash[pageId].mappingIndex
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
function PagingElement:loadFromXML(xmlFile, key)
    PagingElement:superClass().loadFromXML( self , xmlFile, key)

    self:addCallback(xmlFile, key .. "#onPageChange" , "onPageChangeCallback" )
    self:addCallback(xmlFile, key .. "#onPageUpdate" , "onPageUpdateCallback" )
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
function PagingElement.new(target, custom_mt)
    if custom_mt = = nil then
        custom_mt = PagingElement _mt
    end

    local self = GuiElement.new(target, custom_mt)
    self:include( IndexChangeSubjectMixin ) -- add index change subject mixin for paging observers

        self.pageIdCount = 1

        self.pages = { } -- list of pages
        self.idPageHash = { } -- hash of page ID to actual page
        self.pageMapping = { } -- map of visible page indices to all page indices

        self.currentPageIndex = 1
        self.currentPageMappingIndex = 1

        return self
    end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function PagingElement:onGuiSetupFinished()
    PagingElement:superClass().onGuiSetupFinished( self )
    self:updatePageMapping()
end

```

### removeElement

**Description**

**Definition**

> removeElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function PagingElement:removeElement(element)
    PagingElement:superClass().removeElement( self , element)
    self:removePageByElement(element) -- also remove any page using that element as its root node
end

```

### setPageDisabled

**Description**

**Definition**

> setPageDisabled()

**Arguments**

| any | page     |
|-----|----------|
| any | disabled |

**Code**

```lua
function PagingElement:setPageDisabled(page, disabled)
    if page ~ = nil then
        page.disabled = disabled
        self:updatePageMapping()
        self:raiseCallback( "onPageUpdateCallback" , page, self )
    end
end

```

### updatePageMapping

**Description**

**Definition**

> updatePageMapping()

**Code**

```lua
function PagingElement:updatePageMapping()
    self.pageMapping = { }
    self.pageTitles = { }
    local currentPage = self.pages[ self.currentPageIndex]

    for i, page in ipairs( self.pages) do
        if not page.disabled then
            table.insert( self.pageMapping, i)
            table.insert( self.pageTitles, page.title)
            page.mappingIndex = # self.pageMapping
        else
                if page = = currentPage then
                    -- force page resetting
                    currentPage = nil
                end
                page.mappingIndex = 1
            end
        end

        if currentPage = = nil then
            if not self.neuterPageUpdates then
                if # self.pageMapping > 0 then
                    self.currentPageMappingIndex = math.clamp( self.currentPageMappingIndex, 1 , # self.pageMapping)
                    self:setPage( self.currentPageMappingIndex)
                end
            end
        else
                self:notifyIndexChange( self.currentPageMappingIndex, # self.pageMapping) -- notify change in number of pages
            end
        end

```