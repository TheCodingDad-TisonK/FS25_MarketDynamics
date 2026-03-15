## WindBending

**Description**

> Specialization for controlling wind bending nodes

**Functions**

- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function WindBending.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "WindBending" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.windBending.windBendingNodes.windBendingNode(?)#node" , "Shader node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.windBending.windBendingNodes.windBendingNode(?)#decalNode" , "Extra node that gets the exact same shader parameters" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.windBending.windBendingNodes.windBendingNode(?)#speedReferenceNode" , "Reference node to calculate speed of wind" )
    schema:register(XMLValueType.FLOAT, "vehicle.windBending.windBendingNodes.windBendingNode(?)#maxBending" , "Bending in meters" , 0.15 )
    schema:register(XMLValueType.FLOAT, "vehicle.windBending.windBendingNodes.windBendingNode(?)#maxBendingNeg" , "Negative bending in meters(used if the vehicle drives in reverse)" , "same as #maxBending" )
        schema:register(XMLValueType.FLOAT, "vehicle.windBending.windBendingNodes.windBendingNode(?)#maxBendingSpeed" , "Speed at which max bending state is reached in kmph" , 20 )

        schema:setXMLSpecializationType()
    end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function WindBending:onLoad(savegame)
    local spec = self.spec_windBending

    if self.isClient then
        spec.windBending = { }

        self.xmlFile:iterate( "vehicle.windBending.windBendingNodes.windBendingNode" , function (_, key)
            local entry = { }
            entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            if entry.node ~ = nil then
                if getHasClassId(entry.node, ClassIds.SHAPE) and getHasShaderParameter(entry.node, "directionBend" ) then
                    entry.speedReferenceNode = self.xmlFile:getValue(key .. "#speedReferenceNode" , entry.node, self.components, self.i3dMappings)
                    entry.parentComponent = self:getParentComponent(entry.speedReferenceNode)

                    entry.maxBending = self.xmlFile:getValue(key .. "#maxBending" , 0.15 )
                    entry.maxBendingNeg = self.xmlFile:getValue(key .. "#maxBendingNeg" , entry.maxBending)
                    entry.maxBendingSpeed = self.xmlFile:getValue(key .. "#maxBendingSpeed" , 20 )

                    entry.decalNode = self.xmlFile:getValue(key .. "#decalNode" , nil , self.components, self.i3dMappings)

                    entry.lastPosition = nil

                    table.insert(spec.windBending, entry)
                else
                        Logging.xmlError( self.xmlFile, "Unable to load wind bending node from xml.Node has not shader parameter 'directionBend'. '%s'" , key)
                    end
                else
                        Logging.xmlError( self.xmlFile, "Unable to load wind bending node from xml.Node not found. '%s'" , key)
                    end
                end )
            end

            if not self.isClient or #spec.windBending = = 0 then
                SpecializationUtil.removeEventListener( self , "onUpdate" , WindBending )
            end
        end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function WindBending:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_windBending

    local lastSpeed = self:getLastSpeed()
    for i = 1 , #spec.windBending do
        local windBendingNode = spec.windBending[i]

        local x, y, z = localToWorld(windBendingNode.speedReferenceNode, 0 , 0 , 0 )
        if windBendingNode.lastPosition = = nil then
            windBendingNode.lastPosition = { x, y, z }
        end

        local vx = (x - windBendingNode.lastPosition[ 1 ]) * 10
        local vy = (y - windBendingNode.lastPosition[ 2 ]) * 10
        local vz = (z - windBendingNode.lastPosition[ 3 ]) * 10

        if vx ~ = 0 or vy ~ = 0 or vz ~ = 0 then
            vx, vy, vz = worldDirectionToLocal(getParent(windBendingNode.node), vx, vy, vz)
            vx, vy, vz = MathUtil.vector3Normalize(vx, vy, vz)

            local maxBending = self.movingDirection > = 0 and windBendingNode.maxBending or windBendingNode.maxBendingNeg
            local bendingAmount = maxBending * (lastSpeed / windBendingNode.maxBendingSpeed)
            g_animationManager:setPrevShaderParameter(windBendingNode.node, "directionBend" , vx, vy, vz, bendingAmount, false , "prevDirectionBend" )

            if windBendingNode.decalNode ~ = nil then
                g_animationManager:setPrevShaderParameter(windBendingNode.decalNode, "directionBend" , vx, vy, vz, bendingAmount, false , "prevDirectionBend" )
            end
        end

        windBendingNode.lastPosition[ 1 ] = x
        windBendingNode.lastPosition[ 2 ] = y
        windBendingNode.lastPosition[ 3 ] = z
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function WindBending.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function WindBending.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , WindBending )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , WindBending )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function WindBending.registerFunctions(vehicleType)
end

```