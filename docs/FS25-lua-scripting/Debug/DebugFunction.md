## DebugFunction

**Functions**

- [draw](#draw)
- [getShouldBeDrawn](#getshouldbedrawn)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugFunction:draw()
    if self.drawFunc ~ = nil then
        self.drawFunc( self )
    end
end

```

### getShouldBeDrawn

**Description**

> dedicated function used by DebugManger to determine if draw() should be called or not

**Definition**

> getShouldBeDrawn()

**Return Values**

| any | shouldBeDrawn |
|-----|---------------|

**Code**

```lua
function DebugFunction:getShouldBeDrawn()
    return true
end

```