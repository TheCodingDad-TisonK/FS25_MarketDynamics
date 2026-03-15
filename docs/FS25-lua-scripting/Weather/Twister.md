## Twister

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream id  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function Twister:readStream(streamId, connection)
    Twister:superClass().readStream( self , streamId, connection)

    if connection:getIsServer() then
        local mission = g_currentMission
        local paramsXZ = mission.vehicleXZPosCompressionParams
        local paramsY = mission.vehicleYPosCompressionParams
        local x = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        local y = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
        local z = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        setWorldTranslation( self.rootNode, x, y, z)
        local fadeValue = streamReadFloat32(streamId)
        self:setFadeValue(fadeValue, true )

        self.networkTimeInterpolator:reset()
    end
end

```

### readUpdateStream

**Description**

> Called on client side on update

**Definition**

> readUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream id  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Twister:readUpdateStream(streamId, timestamp, connection)
    Twister:superClass().readUpdateStream( self , streamId, timestamp, connection)

    if connection:getIsServer() then
        if streamReadBool(streamId) then
            local mission = g_currentMission
            local paramsXZ = mission.vehicleXZPosCompressionParams
            local paramsY = mission.vehicleYPosCompressionParams
            local x = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
            local y = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
            local z = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
            local fadeValue = streamReadFloat32(streamId)

            self.positionInterpolator:setTargetPosition(x, y, z)
            self.fadeInterpolator:setTargetValue(fadeValue)
            self.networkTimeInterpolator:startNewPhaseNetwork()
        end
    end
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream id  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function Twister:writeStream(streamId, connection)
    Twister:superClass().writeStream( self , streamId, connection)

    if not connection:getIsServer() then
        local mission = g_currentMission
        local x,y,z = getWorldTranslation( self.rootNode)
        local paramsXZ = mission.vehicleXZPosCompressionParams
        local paramsY = mission.vehicleYPosCompressionParams
        NetworkUtil.writeCompressedWorldPosition(streamId, x, paramsXZ)
        NetworkUtil.writeCompressedWorldPosition(streamId, y, paramsY)
        NetworkUtil.writeCompressedWorldPosition(streamId, z, paramsXZ)
        streamWriteFloat32(streamId, self.fadeValue)
    end
end

```

### writeUpdateStream

**Description**

> Called on server side on update

**Definition**

> writeUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream id  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Twister:writeUpdateStream(streamId, connection, dirtyMask)
    Twister:superClass().writeUpdateStream( self , streamId, connection, dirtyMask)

    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, self.dirtyFlag) ~ = 0 ) then
            local mission = g_currentMission
            local paramsXZ = mission.vehicleXZPosCompressionParams
            local paramsY = mission.vehicleYPosCompressionParams
            NetworkUtil.writeCompressedWorldPosition(streamId, self.sendPosX, paramsXZ)
            NetworkUtil.writeCompressedWorldPosition(streamId, self.sendPosY, paramsY)
            NetworkUtil.writeCompressedWorldPosition(streamId, self.sendPosZ, paramsXZ)
            streamWriteFloat32(streamId, self.sendFadeValue)
        end
    end
end

```