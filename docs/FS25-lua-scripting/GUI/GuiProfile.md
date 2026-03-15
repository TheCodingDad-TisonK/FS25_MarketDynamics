## GuiProfile

**Description**

> GUI element display profile.
> Holds GuiElement property data for re-use similar to a HTML/CSS definition.

**Functions**

- [getBool](#getbool)
- [getNumber](#getnumber)
- [getValue](#getvalue)
- [loadFromXML](#loadfromxml)
- [new](#new)

### getBool

**Description**

> Get a boolean value from this profile (and its ancestors) by name.

**Definition**

> getBool(string name, boolean default)

**Arguments**

| string  | name    | Name of attribute value to retrieve                   |
|---------|---------|-------------------------------------------------------|
| boolean | default | Default value to use if the attribute is not defined. |

**Return Values**

| boolean | bool |
|---------|------|

**Code**

```lua
function GuiProfile:getBool(name, default)
    local value = self:getValue(name)
    local ret = default
    if value ~ = nil and value ~ = "nil" then
        --#debug Assert.assert(string.lower(value) = = "true" or string.lower(value) = = "false", "Invalid boolean", "Value %q for key %q is not a valid boolean string", value, name)
            ret = ( string.lower(value) = = "true" )
        end

        return ret
    end

```

### getNumber

**Description**

> Get a number value from this profile (and its ancestors) by name.

**Definition**

> getNumber(string name, float default)

**Arguments**

| string | name    | Name of attribute value to retrieve                   |
|--------|---------|-------------------------------------------------------|
| float  | default | Default value to use if the attribute is not defined. |

**Return Values**

| float | number | value of attribute if set, given 'default' otherwise |
|-------|--------|------------------------------------------------------|

**Code**

```lua
function GuiProfile:getNumber(name, default)
    local value = self:getValue(name)
    local ret = default
    if value ~ = nil and value ~ = "nil" then
        ret = tonumber(value)
        --#debug Assert.isNotNil(ret)
    end

    return ret
end

```

### getValue

**Description**

> Get a string value from this profile (and its ancestors) by name.

**Definition**

> getValue(string name, string default)

**Arguments**

| string | name    | Name of attribute value to retrieve                   |
|--------|---------|-------------------------------------------------------|
| string | default | Default value to use if the attribute is not defined. |

**Return Values**

| string | value |
|--------|-------|

**Code**

```lua
function GuiProfile:getValue(name, default)
    local ret = default

    -- Try a special case
    if self.values[name .. g_baseUIPostfix] ~ = nil and self.values[name .. g_baseUIPostfix] ~ = "nil" then
        ret = self.values[name .. g_baseUIPostfix]

        -- Try definition in the profile
    elseif self.values[name] ~ = nil and self.values[name] ~ = "nil" then
            ret = self.values[name]

            -- Try the profile itself
        else
                if self.parent ~ = nil then
                    -- Try parent
                    local parentProfile
                    if self.isVariant then
                        parentProfile = self.profiles[ self.parent]
                    else
                            -- Follow the path of special variants so top-level variants update all children
                            parentProfile = g_gui:getProfile( self.parent)
                        end

                        if parentProfile ~ = nil and parentProfile ~ = "nil" then
                            ret = parentProfile:getValue(name, default)
                        else
                                Logging.warning( "Parent-profile '%s' not found for profile '%s'" , self.parent, self.name)
                                end
                            end
                        end

                        return ret
                    end

```

### loadFromXML

**Description**

> Load profile data from XML.

**Definition**

> loadFromXML(entityId xmlFile, string key, table presets, boolean? isTrait, boolean? isVariant)

**Arguments**

| entityId | xmlFile   | XML file handle                                                    |
|----------|-----------|--------------------------------------------------------------------|
| string   | key       | Profile XML element node path                                      |
| table    | presets   | Table of presets for symbol resolution, {preset name=preset value} |
| boolean? | isTrait   | Whether this profile is a trait                                    |
| boolean? | isVariant |                                                                    |

**Return Values**

| boolean? | success | True if profile values could be loaded, false otherwise. |
|----------|---------|----------------------------------------------------------|

**Code**

```lua
function GuiProfile:loadFromXML(xmlFile, key, presets, isTrait, isVariant)
    local name = getXMLString(xmlFile, key .. "#name" )
    if name = = nil then
        Logging.xmlWarning(xmlFile, "Missing name for a profile in XML file %s at path %s" , getXMLFilename(xmlFile), key)
            return false
        end

        self.name = name
        self.isTrait = isTrait or false
        self.parent = getXMLString(xmlFile, key .. "#extends" )
        self.isVariant = isVariant

        if self.parent = = self.name then
            error( "Profile " .. name .. " extends itself" )
        end

        -- If this is not a trait, resolve traits
        if not isTrait then
            local traitsStr = getXMLString(xmlFile, key .. "#with" )
            if traitsStr ~ = nil then
                local traitNames = string.split( string.trim(traitsStr), " " )

                -- Copy all values, overwriting previous ones.
                -- This is resolving of the traits.
                for i, traitName in ipairs(traitNames) do
                    local trait = self.traits[traitName]

                    if trait ~ = nil then
                        for traitValueName, value in pairs(trait.values) do
                            self.values[traitValueName] = value
                        end
                    else
                            Logging.xmlWarning(xmlFile, "Trait-profile '%s' not found for trait '%s' at '%s'" , traitName, self.name, key)
                            end
                        end
                    end
                end

                local numElements = getXMLNumOfChildren(xmlFile, key)
                local oldFormatCount = 0
                for i = 0 , numElements - 1 do
                    local valueName = getXMLElementName(xmlFile, string.format( "%s.*(%i)" , key, i))
                    local valueKey = key .. string.format( ".%s(0)#value" , valueName)

                    --if old format is still used, we throw a warning
                        if valueName = = "Value" then
                            valueName = getXMLString(xmlFile, key .. string.format( ".Value(%i)#name" , oldFormatCount))
                            valueKey = key .. string.format( ".Value(%i)#value" , oldFormatCount)
                            oldFormatCount = oldFormatCount + 1

                            Logging.xmlWarning(xmlFile, "Gui profile '%s' still uses old format, please convert it to the new one" , valueName)
                        end

                        local value = getXMLString(xmlFile, valueKey)
                        if valueName = = nil or value = = nil or valueName = = "Variant" then
                            break
                        end

                        if value:startsWith( "$preset_" ) then
                            local preset = string.gsub(value, "$preset_" , "" )
                            if presets[preset] ~ = nil then
                                value = presets[preset]
                            else
                                    Logging.xmlWarning(xmlFile, "Preset '%s' it profile '%s' at '%s' is not defined" , preset, name, valueKey)
                                end
                            end

                            self.values[valueName] = value
                        end

                        return true
                    end

```

### new

**Description**

> Create a new GuiProfile.

**Definition**

> new(table profiles, table traits)

**Arguments**

| table | profiles | Reference to loaded profiles table for inheritance checking. |
|-------|----------|--------------------------------------------------------------|
| table | traits   | Reference to loaded traits table for inheritance checking.   |

**Return Values**

| table | GuiProfile | instance |
|-------|------------|----------|

**Code**

```lua
function GuiProfile.new(profiles, traits)
    local self = setmetatable( { } , GuiProfile _mt)

    self.values = { }
    self.name = ""
    self.profiles = profiles
    self.traits = traits
    self.parent = nil

    return self
end

```