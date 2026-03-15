## PlaceableShallowWaterSimulation

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableShallowWaterSimulation:onDelete()
    local spec = self.spec_shallowWaterSimulation

    if spec.waterPlanes ~ = nil then
        for _, waterPlane in ipairs(spec.waterPlanes) do
            g_currentMission.shallowWaterSimulation:removeAreaGeometry(waterPlane)
            g_currentMission.shallowWaterSimulation:removeWaterPlane(waterPlane)
        end
        spec.waterPlanes = nil
    end

    if spec.obstacles ~ = nil then
        for _, obstacle in ipairs(spec.obstacles) do
            g_currentMission.shallowWaterSimulation:removeObstacle(obstacle)
        end
        spec.obstacles = nil
    end
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
function PlaceableShallowWaterSimulation:onLoad(savegame)
    local spec = self.spec_shallowWaterSimulation

    if g_currentMission.shallowWaterSimulation = = nil then
        return
    end

    if self.propertyState = = PlaceablePropertyState.CONSTRUCTION_PREVIEW then
        return -- do not add SWS for preview
        end

        for _, waterPlaneKey in self.xmlFile:iterator( "placeable.shallowWaterSimulation.waterPlane" ) do
            local waterPlane = self.xmlFile:getValue(waterPlaneKey .. "#node" , nil , self.components, self.i3dMappings)

            if waterPlane = = nil then
                continue
            end

            -- set material from material holder if specified
                local materialName = self.xmlFile:getValue(waterPlaneKey .. "#materialName" , nil )
                if materialName ~ = nil then
                    local waterSimMat = g_materialManager:getBaseMaterialByName(materialName)
                    if waterSimMat = = nil then
                        Logging.xmlError( self.xmlFile, "Unable to retrieve material %s for water plane %q at %q" , materialName, getName(waterPlane), waterPlaneKey)
                        else
                                setMaterial(waterPlane, waterSimMat, 0 )
                            end
                        end

                        spec.waterPlanes = spec.waterPlanes or { }

                        if g_currentMission.shallowWaterSimulation:addWaterPlane(waterPlane) then
                            g_currentMission.shallowWaterSimulation:addAreaGeometry(waterPlane)
                            table.insert(spec.waterPlanes, waterPlane)
                        end
                    end

                    for _, key in self.xmlFile:iterator( "placeable.shallowWaterSimulation.obstacle" ) do
                        local node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                        if node = = nil then
                            Logging.xmlWarning( self.xmlFile, "Missing node for obstacle node '%s'" , key)
                                continue
                            end

                            local type = ObstacleType.loadFromXMLFile( self.xmlFile, key .. "#type" ) or ObstacleType.RECTANGLE
                            local size = self.xmlFile:getValue(key .. "#size" , "1 1 1" , true )
                            local offset = self.xmlFile:getValue(key .. "#offset" , nil , true )

                            local xDir, _, zDir = localDirectionToWorld(node, 0 , 0 , 1 )
                            local rotY = MathUtil.getYRotationFromDirection(xDir, zDir)

                            local obstacle = g_currentMission.shallowWaterSimulation:addObstacle(node, size[ 1 ], size[ 2 ], size[ 3 ], nil , nil , offset, rotY, type )
                            if obstacle ~ = nil then
                                spec.obstacles = spec.obstacles or { }
                                table.insert(spec.obstacles, obstacle)
                            end
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
function PlaceableShallowWaterSimulation.prerequisitesPresent(specializations)
    return true
end

```