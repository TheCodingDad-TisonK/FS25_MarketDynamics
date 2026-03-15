## ServerSoundManager

**Description**

> Special sound manager class for dedicated server that disables all sounds

**Parent**

> [SoundManager](?version=script&category=76&class=616)

**Functions**

- [new](#new)

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function ServerSoundManager.new(customMt)
    local self = SoundManager.new(customMt or ServerSoundManager _mt)

    return self
end

```