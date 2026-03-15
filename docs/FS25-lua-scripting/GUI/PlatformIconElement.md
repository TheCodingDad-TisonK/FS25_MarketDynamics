## PlatformIconElement

**Description**

> Display a platform icon, depending on current and set platform.

**Parent**

> [BitmapElement](?version=script&category=43&class=484)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [new](#new)
- [setPlatformId](#setplatformid)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function PlatformIconElement:copyAttributes(src)
    PlatformIconElement:superClass().copyAttributes( self , src)

    self.platformId = src.platformId
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function PlatformIconElement:delete()
    PlatformIconElement:superClass().delete( self )
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
function PlatformIconElement.new(target, custom_mt)
    local self = PlatformIconElement:superClass().new(target, custom_mt or PlatformIconElement _mt)

    return self
end

```

### setPlatformId

**Description**

> Set the terrain layer to render

**Definition**

> setPlatformId()

**Arguments**

| any | platformId |
|-----|------------|

**Code**

```lua
function PlatformIconElement:setPlatformId(platformId)
    local useOtherIcon = false

    -- On some platforms we can only show the icon for the same platform
        if GS_PLATFORM_ID = = PlatformId.PS5 and platformId ~ = PlatformId.PS5 then
            useOtherIcon = true
        elseif GS_PLATFORM_ID = = PlatformId.XBOX_SERIES and platformId ~ = PlatformId.XBOX_SERIES then
                useOtherIcon = true
            elseif GS_IS_MSSTORE_VERSION and(platformId ~ = PlatformId.XBOX_SERIES and platformId ~ = PlatformId.WIN) then
                    useOtherIcon = true
                end

                if useOtherIcon then
                    platformId = 0
                end

                if not PlatformIconElement.ALLOW_COLOR_CHANGE[platformId] then
                    self.colorSelectedBackup = self.overlay.colorSelected
                    self.overlay.colorSelected = self.overlay.color
                else
                        if self.colorSelectedBackup ~ = nil then
                            self.overlay.colorSelected = self.colorSelectedBackup
                            self.colorSelectedBackup = nil
                        end
                    end

                    self:setImageSlice( nil , PlatformIconElement.SLICES[platformId])
                end

```