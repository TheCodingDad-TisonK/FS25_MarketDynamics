## BreadcrumbsElement

**Description**

> Breadcrumbs for deeper layouts (shop, modhub)

**Parent**

> [BoxLayoutElement](?version=script&category=43&class=429)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [new](#new)
- [onGuiSetupFinished](#onguisetupfinished)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function BreadcrumbsElement:copyAttributes(src)
    BreadcrumbsElement:superClass().copyAttributes( self , src)

    self.textTemplate = src.textTemplate
    self.arrowTemplate = src.arrowTemplate
    self.ownsTemplates = false
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function BreadcrumbsElement:delete()
    if self.ownsTemplates then
        if self.textTemplate ~ = nil then
            self.textTemplate:delete()
        end

        if self.arrowTemplate ~ = nil then
            self.arrowTemplate:delete()
        end
    end

    BreadcrumbsElement:superClass().delete( self )
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
function BreadcrumbsElement.new(target, custom_mt)
    local self = BoxLayoutElement.new(target, custom_mt or BreadcrumbsElement _mt)

    self.crumbs = { }

    return self
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function BreadcrumbsElement:onGuiSetupFinished()
    BreadcrumbsElement:superClass().onGuiSetupFinished( self )

    if self.textTemplate = = nil or self.arrowTemplate = = nil then
        self.ownsTemplates = true

        self.textTemplate = self:getFirstDescendant( function (element) return element:isa( TextBackdropElement ) end )
        if self.textTemplate ~ = nil then
            self.textTemplate:unlinkElement()
        end

        self.arrowTemplate = self:getFirstDescendant( function (element) return element:isa( BitmapElement ) end )
        if self.arrowTemplate ~ = nil then
            self.arrowTemplate:unlinkElement()
        end
    end
end

```