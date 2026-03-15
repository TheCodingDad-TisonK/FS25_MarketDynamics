## Utils

**Functions**

- [getUniqueId](#getuniqueid)

### getUniqueId

**Description**

> Gets a unique id for the given value, ensuring there are no collisions with the given mapping table. Appends the given
> prefix to the start and truncates the md5 hash to the given length.

**Definition**

> getUniqueId(any value, table? mappingTable, string? prefix, integer? md5Length)

**Arguments**

| any      | value        | The value from which to make the unique id. Note that calling this function with the same value twice will give different ids.                                                         |
|----------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| table?   | mappingTable | The optional table to check against for collisions. For each id that is generated, the table is checked. If the value with that key is anything other than nil; a new id is generated. |
| string?  | prefix       | The optional prefix to append to the front of the id.                                                                                                                                  |
| integer? | md5Length    | The optional length of the desired md5 hash, between 1 and 32. This length does not include the prefix. If this is nil, the full 32 characters will be used.                           |

**Return Values**

| integer? | uniqueId | The generated unique id. |
|----------|----------|--------------------------|

**Code**

```lua
function Utils.getUniqueId(value, mappingTable, prefix, md5Length)

    -- Default the md5 length to nil if it is not valid.
        if type(md5Length) ~ = "number" or md5Length < = 0 or md5Length > = 32 then
            md5Length = nil
        end

        --#debug Assert.isNotNil(value, "Mapping value cannot be nil!")
        --#debug Assert.isNilOrType(mappingTable, "table", "Mapping table must be a table or nil!")
        --#debug Assert.isNilOrType(prefix, "string", "Prefix must be a string or nil!")

        -- Default the prefix to an empty string.
        prefix = prefix or ""

        -- Keep generating unique ids until one is found that does not collide.
        local uniqueId
        local i = 0
        repeat
        local md5 = getMD5( tostring(value) .. tostring(getTime()) .. tostring(i))
        if md5Length ~ = nil then
            uniqueId = prefix .. string.sub(md5, 1 , md5Length)
        else
                uniqueId = prefix .. md5
            end
            i = i + 1
            until mappingTable = = nil or mappingTable[uniqueId] = = nil

            -- Return the unique id.
            return uniqueId
        end

```