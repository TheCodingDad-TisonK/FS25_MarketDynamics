## InGameMenu

**Description**

> In-Game Menu.
> Displays the main in-game menu with several pages, depending on the game state and mode (e.g. tutorial or
> multiplayer). This menu can be extended and modified by adding and removing pages. Default pages for the base game
> are always loaded but can also be removed (effectively just disabled). Custom pages can be entirely new or modified
> sub-classes of the default pages. See methods InGameMenu:addPage() and InGameMenu:removePage() for details.

**Parent**

> [TabbedMenu](?version=script&category=43&class=468)

**Functions**

- [onPageNext](#onpagenext)
- [onPagePrevious](#onpageprevious)

### onPageNext

**Description**

> Handle next page event. we sometimes need to block the page change

**Definition**

> onPageNext()

**Code**

```lua
function InGameMenu:onPageNext()
    if self.blockNextPageNextEvent then
        self.blockNextPageNextEvent = false
    else
            if self.currentPage:requestClose( self.frameClosePageNextCallback) then
                if self.currentPage = = self.pageSettings or self.currentPage = = self.pageHelpLine then
                    self:openSaveScreen()
                end

                TabbedMenu:superClass().onPageNext( self )
            end
        end
    end

```

### onPagePrevious

**Description**

> Handle next page event. we sometimes need to block the page change

**Definition**

> onPagePrevious()

**Code**

```lua
function InGameMenu:onPagePrevious()
    if self.currentPage:requestClose( self.frameClosePagePreviousCallback) then
        if self.currentPage = = self.pageSettings or self.currentPage = = self.pageHelpLine then
            self:openSaveScreen()
        end

        TabbedMenu:superClass().onPagePrevious( self )
    end
end

```