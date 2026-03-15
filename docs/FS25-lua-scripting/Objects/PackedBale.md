## PackedBale

**Description**

> Class for packed bales

**Parent**

> [Bale](?version=script&category=63&class=581)

**Functions**

- [delete](#delete)
- [getCanInteract](#getcaninteract)
- [getInteractionPosition](#getinteractionposition)
- [loadBaleAttributesFromXML](#loadbaleattributesfromxml)
- [new](#new)
- [unpack](#unpack)

### delete

**Description**

> Deleting bale object

**Definition**

> delete()

**Code**

```lua
function PackedBale:delete()
    g_currentMission.activatableObjectsSystem:removeActivatable( self.packedBaleActivatable)

    PackedBale:superClass().delete( self )
end

```

### getCanInteract

**Description**

**Definition**

> getCanInteract()

**Code**

```lua
function PackedBale:getCanInteract()
    local x1, y1, z1 = self:getInteractionPosition()
    if x1 ~ = nil then
        local x2, y2, z2 = getWorldTranslation( self.nodeId)
        local distance = MathUtil.vector3Length(x1 - x2, y1 - y2, z1 - z2)
        if distance < self.maxUnpackDistance then
            return true
        end
    end

    return false
end

```

### getInteractionPosition

**Description**

**Definition**

> getInteractionPosition()

**Code**

```lua
function PackedBale:getInteractionPosition()

    if g_localPlayer:getIsInVehicle() then
        return
    end

    if not g_currentMission.accessHandler:canPlayerAccess( self ) then
        return
    end

    return g_localPlayer:getPosition()
end

```

### loadBaleAttributesFromXML

**Description**

> Loads bale attributes from xml file

**Definition**

> loadBaleAttributesFromXML(table xmlFile)

**Arguments**

| table | xmlFile | xml file object |
|-------|---------|-----------------|

**Code**

```lua
function PackedBale:loadBaleAttributesFromXML(xmlFile)
    if not PackedBale:superClass().loadBaleAttributesFromXML( self , xmlFile) then
        return false
    end

    self.singleBaleFilename = xmlFile:getValue( "bale.packedBale#singleBale" )
    self.singleBaleFilename = Utils.getFilename( self.singleBaleFilename, self.baseDirectory)
    if self.singleBaleFilename = = nil or not fileExists( self.singleBaleFilename) then
        Logging.xmlError(xmlFile, "Could not find single bale reference for bale(%s)" , self.singleBaleFilename)
            return false
        end

        xmlFile:iterate( "bale.packedBale.singleBale" , function (_, key)
            local node = xmlFile:getValue(key .. "#node" , nil , self.nodeId)
            if node ~ = nil then
                table.insert( self.singleBaleNodes, node)
            end
        end )

        g_currentMission.activatableObjectsSystem:addActivatable( self.packedBaleActivatable)

        return true
    end

```

### new

**Description**

> Creating bale object

**Definition**

> new(boolean isServer, boolean isClient, table? customMt)

**Arguments**

| boolean | isServer | is server |
|---------|----------|-----------|
| boolean | isClient | is client |
| table?  | customMt | customMt  |

**Return Values**

| table? | instance | Instance of object |
|--------|----------|--------------------|

**Code**

```lua
function PackedBale.new(isServer, isClient, customMt)
    local self = Bale.new(isServer, isClient, customMt or PackedBale _mt)
    registerObjectClassName( self , "PackedBale" )

    self.singleBaleNodes = { }
    self.packedBaleActivatable = PackedBaleActivatable.new( self )

    self.maxUnpackDistance = PackedBale.MAX_UNPACK_DISTANCE

    return self
end

```

### unpack

**Description**

> Set wrapping state of bale

**Definition**

> unpack(boolean wrappingState)

**Arguments**

| boolean | wrappingState | new wrapping state |
|---------|---------------|--------------------|

**Code**

```lua
function PackedBale:unpack(noEventSend)
    g_currentMission.activatableObjectsSystem:removeActivatable( self.packedBaleActivatable)

    if self.isServer then
        for i = 1 , # self.singleBaleNodes do
            local singleBaleNode = self.singleBaleNodes[i]

            if self.fillLevel > 1 then
                local baleObject = Bale.new( self.isServer, self.isClient)
                local x, y, z = getWorldTranslation(singleBaleNode)
                local rx, ry, rz = getWorldRotation(singleBaleNode)
                if baleObject:loadFromConfigXML( self.singleBaleFilename, x, y, z, rx, ry, rz) then
                    baleObject:setFillType( self.fillType)
                    baleObject:setFillLevel( math.min( self.fillLevel, baleObject:getCapacity()))
                    baleObject:setOwnerFarmId( self.ownerFarmId, true )
                    baleObject:register()

                    self.fillLevel = self.fillLevel - baleObject:getFillLevel()
                end
            end
        end

        self:delete()
    else
            g_client:getServerConnection():sendEvent( BaleUnpackEvent.new( self ))
        end
    end

```