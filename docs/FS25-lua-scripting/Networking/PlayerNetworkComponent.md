## PlayerNetworkComponent

**Description**

> A base, abstract class that defines a set of functions for a networking component for the player.

**Functions**

- [debugDraw](#debugdraw)
- [new](#new)
- [readUpdateStream](#readupdatestream)
- [update](#update)
- [updateTick](#updatetick)
- [writeUpdateStream](#writeupdatestream)

### debugDraw

**Description**

> Displays the debug information.

**Definition**

> debugDraw(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Return Values**

| float | y | The y position on the screen after the entire debug info was drawn. |
|-------|---|---------------------------------------------------------------------|

**Code**

```lua
function PlayerNetworkComponent:debugDraw(x, y, textSize)
    return y
end

```

### new

**Description**

> Creates an instance of the abstract PlayerNetworkComponent class. Only use this when deriving another class from it.

**Definition**

> new(Player player, table custom\_mt)

**Arguments**

| Player | player    | The player who owns this component.               |
|--------|-----------|---------------------------------------------------|
| table  | custom_mt | The required metatable used to derive this class. |

**Return Values**

| table | instance | The created instance. |
|-------|----------|-----------------------|

**Code**

```lua
function PlayerNetworkComponent.new(player, custom_mt)

    -- Create the instance with the given metatable.
    local self = setmetatable( { } , custom_mt)

    -- The player who owns this component.
    self.player = player

    -- Return the created instance.
    return self
end

```

### readUpdateStream

**Description**

> Reads the data from the incoming network stream and handles the state.

**Definition**

> readUpdateStream(integer streamId, Connection connection, integer timestamp)

**Arguments**

| integer    | streamId   | The id of the stream from which to read.                 |
|------------|------------|----------------------------------------------------------|
| Connection | connection | The connection between the server and the target client. |
| integer    | timestamp  | The current timestamp for synchronisation purposes.      |

**Code**

```lua
function PlayerNetworkComponent:readUpdateStream(streamId, connection, timestamp)

end

```

### update

**Description**

> Updates the player based on the network state every frame.

**Definition**

> update(float dt)

**Arguments**

| float | dt | delta time in ms |
|-------|----|------------------|

**Code**

```lua
function PlayerNetworkComponent:update(dt)
end

```

### updateTick

**Description**

> Runs every tick and handles preparing the state.

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerNetworkComponent:updateTick(dt)
end

```

### writeUpdateStream

**Description**

> Writes the state into the outgoing network stream.

**Definition**

> writeUpdateStream(integer streamId, Connection connection, integer dirtyMask)

**Arguments**

| integer    | streamId   | The id of the stream into which to write.                |
|------------|------------|----------------------------------------------------------|
| Connection | connection | The connection between the server and the target client. |
| integer    | dirtyMask  | The current dirty mask.                                  |

**Code**

```lua
function PlayerNetworkComponent:writeUpdateStream(streamId, connection, dirtyMask)

end

```