## InGameMenuAnimalsFrame

**Description**

> In-game menu animals statistics frame.
> Displays information for all owned animal pens and horses.

**Parent**

> [TabbedMenuFrameElement](?version=script&category=43&class=469)

**Functions**

- [delete](#delete)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function InGameMenuAnimalsFrame:delete()
    for k, clone in pairs( self.subCategoryDotBox.elements) do
        clone:delete()
        self.subCategoryDotBox.elements[k] = nil
    end

    self.subCategoryDotTemplate:delete()

    InGameMenuAnimalsFrame:superClass().delete( self )
end

```