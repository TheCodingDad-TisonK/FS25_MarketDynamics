## ShopCategoriesFrame

**Description**

> Shop categories frame for the in-game menu shop.
> Displays categories/brands or purchasable items in a tile-layout.

**Parent**

> [TabbedMenuFrameElement](?version=script&category=43&class=493)

**Functions**

- [register](#register)

### register

**Description**

> Creates an instance of this frame, and loads the associated XML file

**Definition**

> register()

**Code**

```lua
function ShopCategoriesFrame.register()
    local shopCategoriesFrame = ShopCategoriesFrame.new()
    g_gui:loadGui( "dataS/gui/ShopCategoriesFrame.xml" , "ShopCategoriesFrame" , shopCategoriesFrame, true )
end

```