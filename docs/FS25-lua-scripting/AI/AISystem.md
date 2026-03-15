## AISystem

**Functions**

- [addAgent](#addagent)
- [addBlockingRegion](#addblockingregion)
- [addJob](#addjob)
- [addJobVehicle](#addjobvehicle)
- [addObstacle](#addobstacle)
- [addRoadSpline](#addroadspline)
- [consoleCommandAICheckSplineInterference](#consolecommandaichecksplineinterference)
- [consoleCommandAICostmapExport](#consolecommandaicostmapexport)
- [consoleCommandAIEnableDebug](#consolecommandaienabledebug)
- [consoleCommandAISetAreaDirty](#consolecommandaisetareadirty)
- [consoleCommandAISetLastTarget](#consolecommandaisetlasttarget)
- [consoleCommandAISetTarget](#consolecommandaisettarget)
- [consoleCommandAIShowCosts](#consolecommandaishowcosts)
- [consoleCommandAIShowObstacles](#consolecommandaishowobstacles)
- [consoleCommandAIStart](#consolecommandaistart)
- [consoleCommandAIToggleAINodeDebug](#consolecommandaitoggleainodedebug)
- [consoleCommandAIToggleSplineVisibility](#consolecommandaitogglesplinevisibility)
- [consoleCommandShowPlanningDebug](#consolecommandshowplanningdebug)
- [delete](#delete)
- [drawDebug](#drawdebug)
- [getActiveJobs](#getactivejobs)
- [getAgentStateName](#getagentstatename)
- [getAILimitedReached](#getailimitedreached)
- [getJobById](#getjobbyid)
- [getNavigationMap](#getnavigationmap)
- [getNavigationMapFilename](#getnavigationmapfilename)
- [getNumActiveJobs](#getnumactivejobs)
- [getVehicleByAgent](#getvehiclebyagent)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadMapData](#loadmapdata)
- [new](#new)
- [onClientJoined](#onclientjoined)
- [onCreateAIRoadSpline](#oncreateairoadspline)
- [onMissionStarted](#onmissionstarted)
- [onTerrainLoad](#onterrainload)
- [registerXMLPaths](#registerxmlpaths)
- [removeAgent](#removeagent)
- [removeBlockingRegion](#removeblockingregion)
- [removeJob](#removejob)
- [removeJobVehicle](#removejobvehicle)
- [removeObstacle](#removeobstacle)
- [removeRoadSpline](#removeroadspline)
- [save](#save)
- [setAreaDirty](#setareadirty)
- [setBlockingRegionState](#setblockingregionstate)
- [setObstacleIsPassable](#setobstacleispassable)
- [skipCurrentTask](#skipcurrenttask)
- [skipCurrentTaskInternal](#skipcurrenttaskinternal)
- [startJob](#startjob)
- [startJobInternal](#startjobinternal)
- [stopJob](#stopjob)
- [stopJobById](#stopjobbyid)
- [stopJobInternal](#stopjobinternal)
- [update](#update)

### addAgent

**Description**

**Definition**

> addAgent()

**Arguments**

| any | agentId |
|-----|---------|
| any | vehicle |

**Code**

```lua
function AISystem:addAgent(agentId, vehicle)
    self.activeAgents[agentId] = vehicle
end

```

### addBlockingRegion

**Description**

> Adds a static, fixed size, toggleable blocking area to the AI system, default state: blocking
> If blocking is enabled and an agent crosses the region it will wait meters in front of the region and the invoke the
> callback function continously
> Debug rendering is enabled via enableVehicleNavigationMapDebugRendering (included in console command
> gsAIObstaclesShow)

**Definition**

> addBlockingRegion(float x, float y, float z, float rx, float ry, float rz, float sizeX, float sizeY, float sizeZ,
> float stopDistance, string callbackFuncName, table? callbackTarget)

**Arguments**

| float  | x                |                                                                                                                                                          |
|--------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| float  | y                |                                                                                                                                                          |
| float  | z                |                                                                                                                                                          |
| float  | rx               |                                                                                                                                                          |
| float  | ry               |                                                                                                                                                          |
| float  | rz               |                                                                                                                                                          |
| float  | sizeX            |                                                                                                                                                          |
| float  | sizeY            |                                                                                                                                                          |
| float  | sizeZ            |                                                                                                                                                          |
| float  | stopDistance     |                                                                                                                                                          |
| string | callbackFuncName | callback(entityId navMapId, entityId agentId, integer blockingRegionId), periodically called when agent is overlapping or waiting at the blocking region |
| table? | callbackTarget   |                                                                                                                                                          |

**Return Values**

| table? | blockingRegionId |
|--------|------------------|

**Code**

```lua
function AISystem:addBlockingRegion(x,y,z, rx,ry,rz, sizeX,sizeY,sizeZ, stopDistance, callbackFuncName, callbackTarget)
    if not self.isServer then
        return nil
    end

    if self.navigationMap = = nil then
        Logging.warning( "AISystem:addBlockingRegion():vehicle navigation not initialized yet/anymore" )
        printCallstack()
        -- TODO:enqueue
        return nil
    end

    local blockingRegionId = addVehicleNavigationWorldBlockingRegion( self.navigationMap, x,y,z, rx,ry,rz, sizeX,sizeY,sizeZ, stopDistance, callbackFuncName, callbackTarget)
    log( "AISystem:addVehicleNavigationWorldBlockingRegion pos:" , x,y,z, "rot:" , rx,ry,rz, "size:" , sizeX,sizeY,sizeZ, "stopDistance:" , stopDistance, " = > id:" , blockingRegionId)

    return blockingRegionId
end

```

### addJob

**Description**

**Definition**

> addJob()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AISystem:addJob(job)
    table.insert( self.activeJobs, job)
end

```

### addJobVehicle

**Description**

**Definition**

> addJobVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AISystem:addJobVehicle(vehicle)
    table.addElement( self.activeJobVehicles, vehicle)
end

```

### addObstacle

**Description**

**Definition**

> addObstacle(entityId node, float? centerOffsetX, float? centerOffsetY, float? centerOffsetZ, float? sizeX, float?
> sizeY, float? sizeZ, float? brakeAcceleration, boolean? isPassable)

**Arguments**

| entityId | node              |                                                                                                         |
|----------|-------------------|---------------------------------------------------------------------------------------------------------|
| float?   | centerOffsetX     |                                                                                                         |
| float?   | centerOffsetY     |                                                                                                         |
| float?   | centerOffsetZ     |                                                                                                         |
| float?   | sizeX             |                                                                                                         |
| float?   | sizeY             |                                                                                                         |
| float?   | sizeZ             |                                                                                                         |
| float?   | brakeAcceleration |                                                                                                         |
| boolean? | isPassable        | If not passable, other vehicles are not allowed to overtake when approaching from behind. default: true |

**Code**

```lua
function AISystem:addObstacle(node, centerOffsetX, centerOffsetY, centerOffsetZ, sizeX, sizeY, sizeZ, brakeAcceleration, isPassable)
    if self.isServer and self.navigationMap ~ = nil and node ~ = nil then
        centerOffsetX = centerOffsetX or 0
        centerOffsetY = centerOffsetY or 0
        centerOffsetZ = centerOffsetZ or 0
        sizeX = sizeX or 0
        sizeY = sizeY or 0
        sizeZ = sizeZ or 0
        brakeAcceleration = brakeAcceleration or 0
        isPassable = Utils.getNoNil(isPassable, true )

        addVehicleNavigationPhysicsObstacle( self.navigationMap, node, centerOffsetX, centerOffsetY, centerOffsetZ, sizeX, sizeY, sizeZ, brakeAcceleration)

        if not isPassable then
            setVehicleNavigationPhysicsObstacleIsPassable( self.navigationMap, node, false )
        end
    end
end

```

### addRoadSpline

**Description**

**Definition**

> addRoadSpline(entityId spline, float? maxWidth, float? maxTurningRadius, float? maxHeight)

**Arguments**

| entityId | spline           |
|----------|------------------|
| float?   | maxWidth         |
| float?   | maxTurningRadius |
| float?   | maxHeight        |

**Code**

```lua
function AISystem:addRoadSpline(spline, maxWidth, maxTurningRadius, maxHeight)
    if self.isServer and spline ~ = nil then
        if self.navigationMap ~ = nil then
            I3DUtil.iterateRecursively(spline, function (subSpline)
                if I3DUtil.getIsSpline(subSpline) then
                    local isAllowed = true
                    if getUserAttribute(subSpline, "isAISpline" ) = = false then
                        isAllowed = false
                    end

                    if isAllowed then
                        local defaultMaxWidth = maxWidth or self.defaultVehicleMaxWidth
                        local defaultMaxHeight = maxHeight or self.defaultVehicleMaxHeightSpline
                        local defaultMaxTurningRadius = maxTurningRadius or self.defaultVehicleMaxTurningRadius
                        addRoadsToVehicleNavigationMap( self.navigationMap, subSpline, defaultMaxWidth, defaultMaxHeight, defaultMaxTurningRadius)

                        setVisibility(subSpline, self.splinesVisible)

                        table.addElement( self.roadSplines, subSpline)
                    end
                end
            end , true )
        else
                local delayedSplineData = { }
                delayedSplineData.spline = spline
                delayedSplineData.maxWidth = maxWidth
                delayedSplineData.maxTurningRadius = maxTurningRadius
                delayedSplineData.maxHeight = maxHeight

                table.addElement( self.delayedRoadSplines, delayedSplineData)
            end
        end
    end

```

### consoleCommandAICheckSplineInterference

**Description**

> walk across all AI splines and check if they interfere with any objects

**Definition**

> consoleCommandAICheckSplineInterference()

**Arguments**

| any | stepLength          |
|-----|---------------------|
| any | heightOffset        |
| any | defaultSplineWidth  |
| any | defaultSplineHeight |

**Code**

```lua
function AISystem:consoleCommandAICheckSplineInterference(stepLength, heightOffset, defaultSplineWidth, defaultSplineHeight)
    if not self.isServer then
        return "gsAISplinesCheckInterference is a server-only command"
    end

    local usage = "gsAISplineCheckInterference [stepLength] [heightOffset] [defaultSplineWidth] [defaultSplineHeight]\nUse 'gsDebugManagerClearElements' to remove boxes."

    g_debugManager:removeGroup( "AIInterference" )

    local debugLastPos = { }
    local debugNumInterferences = 0

    stepLength = tonumber(stepLength) or 5
    heightOffset = tonumber(heightOffset) or 0.2
    defaultSplineWidth = tonumber(defaultSplineWidth) or self.defaultVehicleMaxWidth
    defaultSplineHeight = tonumber(defaultSplineHeight) or self.defaultVehicleMaxHeightSpline
    local collisionMask = CollisionMask.ALL - CollisionFlag.TERRAIN - CollisionFlag.TERRAIN_DELTA - CollisionFlag.TERRAIN_DISPLACEMENT - CollisionFlag.TRIGGER - CollisionFlag.FILLABLE
    local overlapFactor = 0.9 -- slightly overlap to reduce change of unchecked areas in curves

    Logging.info( "Checking interference:stepLength = %.2f heightOffset = %.2f defaultSplineWidth = %.2f defaultSplineHeight = %.2f" , stepLength, heightOffset, defaultSplineWidth, defaultSplineHeight)

    local numSplines = 0
    local testPosition = createTransformGroup( "testPosition" )
    local splineMaxWidth -- save spline max width as they might be inherited
    local splineMaxHeight -- save spline max width as they might be inherited

    local splinesWithIntersections = { }

    local callbackTarget = { }
    callbackTarget.onOverlapCallback = function (target, nodeId)
        if nodeId = = 0 then
            return
        end

        -- ignore anything which does not collide, e.g.tip collisions
        if getCollisionFilterMask(nodeId) = = 1 then
            return
        end

        if CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.VEHICLE) or CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.TRAFFIC_VEHICLE) then
            return
        end
        if CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.ROAD) then
            return
        end

        -- CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.AI_BLOCKING)
        local last = debugLastPos

        local customWidth = getUserAttribute(nodeId, 'maxWidth')
        local customWidthText = customWidth and string.format( " (maxWidth UserAttribute: %.2f)" , customWidth) or ""

        local nodeName = string.format( "%s|%s" , getName(getParent(nodeId)), getName(nodeId))
        Logging.warning( "found interference for spline '%s'%s with object '%s' at %d %d %d" , getName(last.spline), customWidthText, nodeName, last.wx, last.wy, last.wz)

            local overlapDebugBox = DebugBox.new():createFromOverlapBoxParameters(last.wx, last.wy, last.wz, last.rx, last.ry, last.rz, last.sx, last.sy, last.sz)
            overlapDebugBox:setText(nodeName)
            overlapDebugBox:addToManager( "AIInterference" )

            splinesWithIntersections[last.spline] = true

            debugNumInterferences = debugNumInterferences + 1
        end

        local function checkInterference(spline)
            numSplines = numSplines + 1
            local splineWidth = getUserAttribute(spline, "maxWidth" ) or splineMaxWidth or defaultSplineWidth
            local splineHeight = getUserAttribute(spline, "maxHeight" ) or splineMaxHeight or defaultSplineHeight
            local splineLength = getSplineLength(spline)
            local stepSize = stepLength * overlapFactor / splineLength
            for offset = 0 , 1 + stepSize, stepSize do
                local clampedSplineTime = math.clamp(offset, 0 , 1 )
                local wx, wy, wz = getSplinePosition(spline, clampedSplineTime)
                local dx, dy, dz = getSplineDirection(spline, clampedSplineTime)
                setWorldTranslation(testPosition, wx, wy, wz)
                setDirection(testPosition, dx, dy, dz, 0 , 1 , 0 )

                local rx, ry, rz = getWorldRotation(testPosition)
                local sx, sy, sz = splineWidth / 2 , (splineHeight / 2 ) - heightOffset / 2 , stepLength / 2
                wy = wy + sy + heightOffset -- offset height by extent and 20 cm to avoid clipping with bridges

                debugLastPos = {
                rx = rx, ry = ry, rz = rz,
                sx = sx, sy = sy, sz = sz,
                wx = wx, wy = wy, wz = wz,
                spline = spline,
                }

                overlapBox(wx, wy, wz, rx, ry, rz, sx, sy, sz, "onOverlapCallback" , callbackTarget, collisionMask, false , true , true , true )
            end
        end

        local function filterSplines(node, depth)
            if I3DUtil.getIsSpline(node) then
                checkInterference(node)
            else
                    -- save spline index for transform groups as it's inherited to child splines
                        splineMaxWidth = getUserAttribute(node, "maxWidth" )
                        splineMaxHeight = getUserAttribute(node, "maxHeight" )
                    end
                end

                for _, aiSpline in ipairs( self.roadSplines) do
                    I3DUtil.iterateRecursively(aiSpline, filterSplines, true )
                end

                for spline in pairs(splinesWithIntersections) do
                    DebugSpline.new():createWithNode(spline):addToManager( "AIInterference" )
                end

                delete(testPosition)

                return string.format( "Checked %d splines, found %d interferences\n%s" , numSplines, debugNumInterferences, usage)
            end

```

### consoleCommandAICostmapExport

**Description**

**Definition**

> consoleCommandAICostmapExport()

**Arguments**

| any | imageFormatStr |
|-----|----------------|

**Code**

```lua
function AISystem:consoleCommandAICostmapExport(imageFormatStr)
    if not self.isServer then
        return "gsAICostsExport is a server-only command"
    end

    if g_currentMission.missionInfo.savegameDirectory = = nil then
        return "Error:Savegame directory does not exist yet, please save the game first"
    end

    local imageFormat = BitmapUtil.FORMAT.PIXELMAP
    if imageFormatStr ~ = nil then
        imageFormat = BitmapUtil.FORMAT[ string.upper(imageFormatStr)]
        if imageFormat = = nil then
            Logging.error( "Unknown image format '%s'.Available formats: %s" , imageFormatStr, table.concatKeys( BitmapUtil.FORMAT, ", " ))
            return "Error:Costmap export failed"
        end
    end

    local terrainSizeHalf = self.mission.terrainSize * 0.5
    local cellSizeHalf = self.cellSizeMeters / 2
    local imageSize = self.mission.terrainSize

    local isGreymap = imageFormat = = BitmapUtil.FORMAT.GREYMAP
    local colorBlocking = self.debug.colors.blocking
    local colorSpline = self.debug.colors.spline

    local splines = self:getRoadSplines()

    -- create mapping table from rounded world [x][z] coordinates for existing splines
        -- checking for near spline for a given world position for each pixel is too expensive/slow
            local posToHasSpline = { }
            for spline in pairs(splines) do
                local splineLength = getSplineLength(spline)
                for splineTime = 0 , 1 , 1 / splineLength do -- step spline in 1m increments
                    local wx, _, wz = getSplinePosition(spline, splineTime)
                    local xInt, zInt = MathUtil.round(wx), MathUtil.round(wz)
                    posToHasSpline[xInt] = posToHasSpline[xInt] or { }
                    posToHasSpline[xInt][zInt] = true
                end
            end

            local terrainNode = g_terrainNode
            local function getPixelsIterator()
                local stepZ = - terrainSizeHalf + cellSizeHalf
                local stepX = - terrainSizeHalf + cellSizeHalf

                local pixel = { 0 , 0 , 0 }

                return function ()
                    if stepZ > (terrainSizeHalf - cellSizeHalf) then
                        return nil
                    end

                    local worldPosY = getTerrainHeightAtWorldPos(terrainNode, stepX, 0 , stepZ)
                    local cost, isBlocking = getVehicleNavigationMapCostAtWorldPos( self.navigationMap, stepX, worldPosY, stepZ)

                    -- check lookup table if position has a spline
                        local xInt, zInt = MathUtil.round(stepX), MathUtil.round(stepZ)
                        local posHasSpline = posToHasSpline[xInt] and posToHasSpline[xInt][zInt]

                        if isGreymap then
                            if posHasSpline then
                                pixel[ 1 ] = 1
                            else
                                    pixel[ 1 ] = cost
                                end
                                pixel[ 1 ] = (pixel[ 1 ] / AISystem.COSTMAP_MAX_VALUE) * 255
                            else
                                    if posHasSpline then
                                        pixel[ 1 ], pixel[ 2 ], pixel[ 3 ] = colorSpline[ 1 ], colorSpline[ 2 ], colorSpline[ 3 ]
                                    else
                                            if isBlocking then
                                                pixel[ 1 ], pixel[ 2 ], pixel[ 3 ] = colorBlocking[ 1 ], colorBlocking[ 2 ], colorBlocking[ 3 ]
                                            else
                                                    pixel[ 1 ], pixel[ 2 ], pixel[ 3 ] = Utils.getGreenRedBlendedColor(cost / AISystem.COSTMAP_MAX_VALUE)
                                                end
                                            end
                                            pixel[ 1 ], pixel[ 2 ], pixel[ 3 ] = pixel[ 1 ] * 255 , pixel[ 2 ] * 255 , pixel[ 3 ] * 255
                                        end

                                        if stepX < (terrainSizeHalf - self.cellSizeMeters) then
                                            stepX = stepX + self.cellSizeMeters
                                        else
                                                stepX = - terrainSizeHalf + cellSizeHalf
                                                stepZ = stepZ + self.cellSizeMeters
                                            end

                                            return pixel
                                        end
                                    end

                                    if not BitmapUtil.writeBitmapToFileFromIterator(getPixelsIterator, imageSize, imageSize, g_currentMission.missionInfo.savegameDirectory .. "/navigationMap" , imageFormat) then
                                        return "Error:Costmap export failed"
                                    end

                                    return "Finished costmap export"
                                end

```

### consoleCommandAIEnableDebug

**Description**

**Definition**

> consoleCommandAIEnableDebug()

**Code**

```lua
function AISystem:consoleCommandAIEnableDebug()
    self.debugEnabled = not self.debugEnabled
    return "debugEnabled = " .. tostring( self.debugEnabled)
end

```

### consoleCommandAISetAreaDirty

**Description**

**Definition**

> consoleCommandAISetAreaDirty()

**Arguments**

| any | width |
|-----|-------|

**Code**

```lua
function AISystem:consoleCommandAISetAreaDirty(width)
    if not self.isServer then
        return "gsAICostsUpdate is a server-only command"
    end

    local x,_,z = getWorldTranslation(g_cameraManager:getActiveCamera())
    width = math.clamp( tonumber(width) or 30 , 2 , g_terrainSize or 2048 )
    local halfWidth = width / 2
    self:setAreaDirty(x - halfWidth, x + halfWidth, z - halfWidth, z + halfWidth)
    return string.format( "Updated costmap in a %dx%d area around the camera" , width, width)
end

```

### consoleCommandAISetLastTarget

**Description**

**Definition**

> consoleCommandAISetLastTarget()

**Code**

```lua
function AISystem:consoleCommandAISetLastTarget()
    if not self.isServer then
        return "gsAISetLastTarget is a server-only command"
    end

    if self.debug.target ~ = nil then
        local x = self.debug.target.x
        local y = self.debug.target.y
        local z = self.debug.target.z
        local dirX = self.debug.target.dirX
        local dirZ = self.debug.target.dirZ

        local marker = self.debug.marker
        if marker ~ = nil then
            marker:create(x,y,z, dirX,dirZ)
        end
        return "Set target to last target"
    else
            return "No last target found"
        end
    end

```

### consoleCommandAISetTarget

**Description**

**Definition**

> consoleCommandAISetTarget()

**Arguments**

| any | offsetX |
|-----|---------|
| any | offsetZ |

**Code**

```lua
function AISystem:consoleCommandAISetTarget(offsetX, offsetZ)
    if not self.isServer then
        return "gsAISetTarget is a server-only command"
    end

    local x, y, z = 0 , 0 , 0
    local dirX, dirY, dirZ, _ = 1 , 0 , 0 , nil
    local localPlayer = g_localPlayer
    if not localPlayer:getIsInVehicle() then
        if localPlayer ~ = nil and localPlayer:getIsControlled() and localPlayer.rootNode ~ = nil and localPlayer.rootNode ~ = 0 then
            local yaw
            x, z, yaw = localPlayer:getMapPositionAndLookYaw()
            y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)
            dirX, dirZ = MathUtil.getDirectionFromYRotation(yaw)
        end
    elseif localPlayer:getCurrentVehicle() ~ = nil then
            x, y, z = getWorldTranslation(localPlayer:getCurrentVehicle().rootNode)
            dirX, _, dirZ = localDirectionToWorld(localPlayer:getCurrentVehicle().rootNode, 0 , 0 , 1 )
        else
                x, y, z = getWorldTranslation(g_cameraManager:getActiveCamera())
                dirX, _, dirZ = localDirectionToWorld(g_cameraManager:getActiveCamera(), 0 , 0 , - 1 )
            end

            local normX, _, normZ = MathUtil.crossProduct( 0 , 1 , 0 , dirX, dirY, dirZ)

            offsetX = tonumber(offsetX) or 0
            offsetZ = tonumber(offsetZ) or 0

            x = x + dirX * offsetZ + normX * offsetX
            z = z + dirZ * offsetZ + normZ * offsetX

            self.debug.target = {
            x = x,
            y = y,
            z = z,
            dirX = dirX,
            dirY = dirY,
            dirZ = dirZ,
            }

            if self.debug.marker ~ = nil then
                g_debugManager:removeElement( self.debug.marker)
                self.debug.marker = nil
            end
            self.debug.marker = DebugFlag.new():create(x,y,z, dirX, dirZ):setText( "AI Target" )
            g_debugManager:addElement( self.debug.marker, "AI" )

            return "Set AI Target"
        end

```

### consoleCommandAIShowCosts

**Description**

**Definition**

> consoleCommandAIShowCosts()

**Code**

```lua
function AISystem:consoleCommandAIShowCosts()
    if not self.isServer then
        return "gsAICostsShow is a server-only command"
    end

    self.debug.isCostRenderingActive = not self.debug.isCostRenderingActive

    if self.debug.isCostRenderingActive then
        g_debugManager:addDrawable( self )
        return "showCosts = true"
    else
            g_debugManager:removeDrawable( self )
            return "showCosts = false"
        end
    end

```

### consoleCommandAIShowObstacles

**Description**

**Definition**

> consoleCommandAIShowObstacles()

**Code**

```lua
function AISystem:consoleCommandAIShowObstacles()
    if not self.isServer then
        return "gsAIObstaclesShow is a server-only command"
    end

    self.mapDebugRenderingEnabled = not self.mapDebugRenderingEnabled
    enableVehicleNavigationMapDebugRendering( self.navigationMap, self.mapDebugRenderingEnabled)

    return "AIShowObstacles = " .. tostring( self.mapDebugRenderingEnabled)
end

```

### consoleCommandAIStart

**Description**

**Definition**

> consoleCommandAIStart()

**Code**

```lua
function AISystem:consoleCommandAIStart()
    if not self.isServer then
        return "Only available on server"
    end

    if g_localPlayer:getCurrentVehicle() = = nil then
        return "Please enter a vehicle first"
    end

    local target = self.debug.target
    if target = = nil then
        return "Please set a target first"
    end

    local job = g_currentMission.aiJobTypeManager:createJob(AIJobType.GOTO)
    local angle = MathUtil.getYRotationFromDirection(target.dirX, target.dirZ)

    job.vehicleParameter:setVehicle(g_localPlayer:getCurrentVehicle())
    job.positionAngleParameter:setPosition(target.x, target.z)
    job.positionAngleParameter:setAngle(angle)
    job:setValues()

    local success, errorMessage = job:validate(g_localPlayer.farmId)
    if success then
        self:startJob(job, g_localPlayer.farmId)
        return "Started ai .. ."
    else
            return "Error: " .. tostring(errorMessage)
        end
    end

```

### consoleCommandAIToggleAINodeDebug

**Description**

**Definition**

> consoleCommandAIToggleAINodeDebug()

**Code**

```lua
function AISystem:consoleCommandAIToggleAINodeDebug()
    self.stationsAINodesVisible = not self.stationsAINodesVisible

    if self.stationsAINodesVisible then
        self.stationsAINodesDebugElements = { }

        for _, unloadingStation in pairs(g_currentMission.storageSystem:getUnloadingStations()) do
            if unloadingStation:isa( UnloadingStation ) then
                local x, _, _, _, unloadTrigger = unloadingStation:getAITargetPositionAndDirection(FillType.UNKNOWN)
                if x ~ = nil then
                    local text = "UnloadingStation: " .. unloadingStation:getName()
                    local gizmo = DebugGizmo.new():createWithNode(unloadTrigger.aiNode, text, nil , nil , nil , false )
                    g_debugManager:addElement(gizmo)
                    table.insert( self.stationsAINodesDebugElements, gizmo)
                end
            end
        end

        for _, loadingStation in pairs(g_currentMission.storageSystem:getLoadingStations()) do
            local x, _, _, _, loadTrigger = loadingStation:getAITargetPositionAndDirection(FillType.UNKNOWN)
            if x ~ = nil then
                local text = "LoadingStation: " .. loadingStation:getName()
                local gizmo = DebugGizmo.new():createWithNode(loadTrigger.aiNode, text, nil , nil , nil , false )
                g_debugManager:addElement(gizmo)
                table.insert( self.stationsAINodesDebugElements, gizmo)
            end
        end
    else
            for _, gizmo in pairs( self.stationsAINodesDebugElements) do
                g_debugManager:removeElement(gizmo)
                gizmo:delete()
            end
            self.stationsAINodesDebugElements = nil
        end

        if self.stationsAINodesVisible then
            Logging.warning( "Nodes in reloaded placeables are not updated automatically.Toggle this command again to update the station nodes if placeables were reloaded." )
            end
            return "AISystem.stationsAINodesVisible = " .. tostring( self.stationsAINodesVisible)
        end

```

### consoleCommandAIToggleSplineVisibility

**Description**

**Definition**

> consoleCommandAIToggleSplineVisibility()

**Code**

```lua
function AISystem:consoleCommandAIToggleSplineVisibility()
    if not self.isServer then
        return "gsAISplinesShow is a server-only command"
    end

    self.splinesVisible = not self.splinesVisible

    if self.splinesVisible then
        local debugMat = g_debugManager:getDebugMat()

        -- set visible and create debug elements
        for spline in pairs( self:getRoadSplines()) do
            local r, g, b = DebugUtil.getDebugColor(spline):unpack()
            setMaterial(spline, debugMat, 0 )
            setShaderParameter(spline, "color" , r, g, b, 0 , false )
            setShaderParameter(spline, "alpha" , 1 , 0 , 0 , 0 , false )

            local debugSpline = DebugSpline.new():createWithNode(spline):setColorRGBA(r,g,b):setClipDistance( 250 )
            g_debugManager:addElement(debugSpline, "AISystemSplines" )
        end
    else
            -- remove existing debug elements
            g_debugManager:removeGroup( "AISystemSplines" )

            -- hide splines implicitly unhidden by DebugSpline
            for spline in pairs( self:getRoadSplines()) do
                setVisibility(spline, false )
            end
        end

        if g_currentMission.trafficSystem ~ = nil and g_currentMission.trafficSystem.rootNodeId ~ = nil then
            setVisibility(g_currentMission.trafficSystem.rootNodeId, self.splinesVisible)
        end

        return "AISystem.splinesVisible = " .. tostring( self.splinesVisible)
    end

```

### consoleCommandShowPlanningDebug

**Description**

**Definition**

> consoleCommandShowPlanningDebug()

**Code**

```lua
function AISystem:consoleCommandShowPlanningDebug()
    self.planningDebugEnabled = not self.planningDebugEnabled
    Logging.info( "AI Planning debug " .. ( self.planningDebugEnabled and "on" or "off" ))
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AISystem:delete()
    --#debug log("AISystem:delete()")
    if self.isServer then
        for i = # self.jobsToRemove, 1 , - 1 do
            local job = self.jobsToRemove[i]
            local jobId = job.jobId

            table.removeElement( self.activeJobs, job)
            table.remove( self.jobsToRemove, i)

            g_messageCenter:publish(MessageType.AI_JOB_REMOVED, jobId)
        end

        for i = # self.activeJobs, 1 , - 1 do
            local job = self.activeJobs[i]
            self:stopJob(job, AIMessageErrorUnknown.new())
        end
    end

    if self.navigationMap ~ = nil then
        delete( self.navigationMap)
        self.navigationMap = nil
    end

    if self.debug ~ = nil and self.debug.marker ~ = nil then
        g_debugManager:removeElement( self.debug.marker)
        self.debug.marker = nil
    end

    if self.lastPlanningBitVectorMap ~ = nil then
        delete( self.lastPlanningBitVectorMap)
        self.lastPlanningBitVectorMap = nil
    end

    self.activeAgents = { }

    g_messageCenter:unsubscribeAll( self )

    removeConsoleCommand( "gsAISetTarget" )
    removeConsoleCommand( "gsAISetLastTarget" )
    removeConsoleCommand( "gsAIStart" )
    removeConsoleCommand( "gsAIEnableDebug" )
    removeConsoleCommand( "gsAISplinesShow" )
    removeConsoleCommand( "gsAISplinesCheckInterference" )
    removeConsoleCommand( "gsAIStationsShow" )
    removeConsoleCommand( "gsAIObstaclesShow" )
    removeConsoleCommand( "gsAICostsShow" )
    removeConsoleCommand( "gsAICostsUpdate" )
    removeConsoleCommand( "gsAICostsExport" )
    removeConsoleCommand( "gsAIAgentSetState" )
end

```

### drawDebug

**Description**

**Definition**

> drawDebug()

**Code**

```lua
function AISystem:drawDebug()
    if not self.debug.isCostRenderingActive or(g_gui:getIsGuiVisible() and g_gui.currentGuiName ~ = "ConstructionScreen" ) then
        return
    end

    local x,_,z = getWorldTranslation(g_cameraManager:getActiveCamera())
    if g_localPlayer:getCurrentVehicle() ~ = nil then
        local object = g_localPlayer:getCurrentVehicle()
        if g_localPlayer:getCurrentVehicle().selectedImplement ~ = nil then
            object = g_localPlayer:getCurrentVehicle().selectedImplement.object
        end
        x,_,z = getWorldTranslation(object.components[ 1 ].node)
    end

    local cellSizeHalf = self.cellSizeMeters * 0.5
    x = ( math.floor(x / self.cellSizeMeters) * self.cellSizeMeters) + cellSizeHalf
    z = ( math.floor(z / self.cellSizeMeters) * self.cellSizeMeters) + cellSizeHalf

    local range = 15 * self.cellSizeMeters
    local terrainSizeHalf = self.mission.terrainSize * 0.5
    local minX = math.max(x - range, - terrainSizeHalf + cellSizeHalf)
    local minZ = math.max(z - range, - terrainSizeHalf + cellSizeHalf)
    local maxX = math.min(x + range, terrainSizeHalf - cellSizeHalf)
    local maxZ = math.min(z + range, terrainSizeHalf - cellSizeHalf)

    local worldPosX, worldPosY, worldPosZ
    local terrainNode = g_terrainNode
    local cost, isBlocking
    local color
    local textSize = getCorrectTextSize( 0.015 )
    local r, g, b

    for stepZ = minZ, maxZ, self.cellSizeMeters do
        for stepX = minX, maxX, self.cellSizeMeters do

            worldPosX = stepX
            worldPosY = getTerrainHeightAtWorldPos(terrainNode, stepX, 0 , stepZ)
            worldPosZ = stepZ

            cost, isBlocking = getVehicleNavigationMapCostAtWorldPos( self.navigationMap, worldPosX, worldPosY, worldPosZ)
            color = self.debug.colors.default
            if isBlocking then
                color = self.debug.colors.blocking
            else
                    r, g, b = Utils.getGreenRedBlendedColor(cost / AISystem.COSTMAP_MAX_VALUE)

                    color[ 1 ] = r
                    color[ 2 ] = g
                    color[ 3 ] = b
                end

                Utils.renderTextAtWorldPosition(worldPosX, worldPosY, worldPosZ, string.format( "%.1f" , cost), textSize, 0 , color)
            end
        end
    end

```

### getActiveJobs

**Description**

**Definition**

> getActiveJobs()

**Code**

```lua
function AISystem:getActiveJobs()
    return self.activeJobs
end

```

### getAgentStateName

**Description**

**Definition**

> getAgentStateName()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function AISystem.getAgentStateName(index)
    for k, v in pairs(AgentState) do
        if v = = index then
            return k
        end
    end

    return "UNKNOWN"
end

```

### getAILimitedReached

**Description**

**Definition**

> getAILimitedReached()

**Code**

```lua
function AISystem:getAILimitedReached()
    return # self.activeJobVehicles > = g_currentMission.maxNumHirables
end

```

### getJobById

**Description**

**Definition**

> getJobById()

**Arguments**

| any | jobId |
|-----|-------|

**Code**

```lua
function AISystem:getJobById(jobId)
    for _, job in ipairs( self.activeJobs) do
        if job.jobId = = jobId then
            return job
        end
    end

    return nil
end

```

### getNavigationMap

**Description**

**Definition**

> getNavigationMap()

**Return Values**

| any | navigationCostmap |
|-----|-------------------|

**Code**

```lua
function AISystem:getNavigationMap()
    return self.navigationMap
end

```

### getNavigationMapFilename

**Description**

**Definition**

> getNavigationMapFilename()

**Code**

```lua
function AISystem:getNavigationMapFilename()
    return self.filename
end

```

### getNumActiveJobs

**Description**

**Definition**

> getNumActiveJobs()

**Code**

```lua
function AISystem:getNumActiveJobs()
    return # self.activeJobs
end

```

### getVehicleByAgent

**Description**

**Definition**

> getVehicleByAgent()

**Arguments**

| any | agentId |
|-----|---------|

**Code**

```lua
function AISystem:getVehicleByAgent(agentId)
    return self.activeAgents[agentId]
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFilename |
|-----|-------------|

**Code**

```lua
function AISystem:loadFromXMLFile(xmlFilename)
    local xmlFile = XMLFile.load( "aiSystemXML" , xmlFilename)
    if xmlFile = = nil then
        return
    end

    local x = xmlFile:getFloat( "aiSystem.debug.target#posX" )
    local y = xmlFile:getFloat( "aiSystem.debug.target#posY" )
    local z = xmlFile:getFloat( "aiSystem.debug.target#posZ" )
    local dirX = xmlFile:getFloat( "aiSystem.debug.target#dirX" )
    local dirY = xmlFile:getFloat( "aiSystem.debug.target#dirY" )
    local dirZ = xmlFile:getFloat( "aiSystem.debug.target#dirZ" )

    if x ~ = nil and y ~ = nil and z ~ = nil and dirX ~ = nil and dirY ~ = nil and dirZ ~ = nil then
        self.debug.target = { }
        self.debug.target.x = x
        self.debug.target.y = y
        self.debug.target.z = z
        self.debug.target.dirX = dirX
        self.debug.target.dirY = dirY
        self.debug.target.dirZ = dirZ
    end

    xmlFile:delete()
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData(entityId xmlFile, table? missionInfo, string? baseDirectory)

**Arguments**

| entityId | xmlFile       | xml file handle |
|----------|---------------|-----------------|
| table?   | missionInfo   |                 |
| string?  | baseDirectory |                 |

**Code**

```lua
function AISystem:loadMapData(xmlFile, missionInfo, baseDirectory)
    if g_addCheatCommands then
        if self.isServer then
            addConsoleCommand( "gsAISetTarget" , "Sets AI Target" , "consoleCommandAISetTarget" , self )
            addConsoleCommand( "gsAISetLastTarget" , "Sets AI Target to last position" , "consoleCommandAISetLastTarget" , self )
            addConsoleCommand( "gsAIStart" , "Starts driving to target" , "consoleCommandAIStart" , self )

            if g_isDevelopmentVersion then
                addConsoleCommand( "gsAIAgentSetState" , "Sets the AI Agent State" , "consoleCommandAIAgentSetState" , self )
            end
        end
        addConsoleCommand( "gsAIEnableDebug" , "Enables AI debugging" , "consoleCommandAIEnableDebug" , self )
        addConsoleCommand( "gsAISplinesShow" , "Toggle AI system spline visibility" , "consoleCommandAIToggleSplineVisibility" , self )
        addConsoleCommand( "gsAISplinesCheckInterference" , "Check if AI splines interfere with any objects" , "consoleCommandAICheckSplineInterference" , self , "[stepLength]; [heightOffset]; [defaultSplineWidth]; [defaultSplineHeight]" )
            addConsoleCommand( "gsAIStationsShow" , "Toggle AI system stations ai nodes visibility" , "consoleCommandAIToggleAINodeDebug" , self )
            addConsoleCommand( "gsAIObstaclesShow" , "Shows the obstacles around the camera" , "consoleCommandAIShowObstacles" , self )
            addConsoleCommand( "gsAIPlanningDebug" , "Shows the last planning bit vector map" , "consoleCommandShowPlanningDebug" , self )
            addConsoleCommand( "gsAICostsShow" , "Shows the costs per cell" , "consoleCommandAIShowCosts" , self )
            addConsoleCommand( "gsAICostsUpdate" , "Update costmap given width around the camera" , "consoleCommandAISetAreaDirty" , self , "[width = 30]" )
            addConsoleCommand( "gsAICostsExport" , "Export costmap to image file" , "consoleCommandAICostmapExport" , self )
        end

        self.cellSizeMeters = 1
        self.maxSlopeAngle = math.rad( 15 )
        self.infoLayerName = "navigationCollision"
        self.infoLayerChannel = 0
        self.aiDrivableCollisionMask = CollisionFlag.AI_DRIVABLE
        self.obstacleCollisionMask = CollisionFlag.AI_BLOCKING
        self.vehicleMaxHeight = 4 -- for costmap generation
            self.defaultVehicleMaxWidth = 6
            self.defaultVehicleMaxTurningRadius = 20 -- TODO
            self.defaultVehicleMaxHeightSpline = 10
            self.isLeftHandTraffic = false

            -- load map specific xml with custom settings
            local relFilename = getXMLString(xmlFile, "map.aiSystem#filename" )
            if relFilename ~ = nil then
                local filepath = Utils.getFilename(relFilename, baseDirectory)
                if filepath ~ = nil then
                    local xmlFileAISystem = XMLFile.load( "mapAISystem" , filepath, AISystem.xmlSchema)
                    if xmlFileAISystem ~ = nil then

                        self.maxSlopeAngle = xmlFileAISystem:getValue( "aiSystem.maxSlopeAngle" ) or self.maxSlopeAngle
                        self.infoLayerName = xmlFileAISystem:getValue( "aiSystem.blockedAreaInfoLayer#name" ) or self.infoLayerName
                        self.infoLayerChannel = xmlFileAISystem:getValue( "aiSystem.blockedAreaInfoLayer#channel" ) or self.infoLayerChannel
                        self.vehicleMaxHeight = xmlFileAISystem:getValue( "aiSystem.vehicleMaxHeight" ) or self.vehicleMaxHeight
                        self.defaultVehicleMaxHeightSpline = xmlFileAISystem:getValue( "aiSystem.vehicleMaxHeightSpline" ) or self.defaultVehicleMaxHeightSpline
                        self.isLeftHandTraffic = Utils.getNoNil(xmlFileAISystem:getValue( "aiSystem.isLeftHandTraffic" ), self.isLeftHandTraffic)

                        xmlFileAISystem:delete()
                    end
                end
            end

            self.debugEnabled = g_isDevelopmentVersion
            self.debug = { }
            self.debug.target = nil
            self.debug.isCostRenderingActive = false
            self.debug.colors = { }
            self.debug.colors.default = { 0 , 1 , 0 , 1 }
            self.debug.colors.blocking = { 1 , 0 , 0 , 1 }
            self.debug.colors.spline = { 0 , 0 , 1 , 1 }

            self.activeJobs = { }
            self.jobsToRemove = { }

            self.splinesVisible = false
            self.roadSplines = { }
        end

```

### new

**Description**

**Definition**

> new(boolean isServer, table mission, table? customMt)

**Arguments**

| boolean | isServer |                  |
|---------|----------|------------------|
| table   | mission  | mission instance |
| table?  | customMt |                  |

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function AISystem.new(isServer, mission, customMt)
    local self = setmetatable( { } , customMt or AISystem _mt)

    self.isServer = isServer
    self.mission = mission
    self.filename = "vehicleNavigationCostmap.dat"
    self.navigationMap = nil

    self.planningDebugEnabled = false
    self.lastPlanningBitVectorMap = nil

    self.activeAgents = { }

    self.jobsToRemove = { }
    self.activeJobs = { }
    self.activeJobVehicles = { }
    self.delayedRoadSplines = { }

    AISystem.xmlSchema = XMLSchema.new( "aiSystem" )
    self:registerXMLPaths( AISystem.xmlSchema)

    return self
end

```

### onClientJoined

**Description**

**Definition**

> onClientJoined()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function AISystem:onClientJoined(connection)
    for _, job in ipairs( self.activeJobs) do
        connection:sendEvent( AIJobStartEvent.new(job, job.startedFarmId))
    end
end

```

### onCreateAIRoadSpline

**Description**

> OnCreate callback for adding splines part of a map the to vehicle navigation system.
> Searches given node and all children recursively for spline nodes.
> For adding splines from placeables use 'PlaceableAI' specialization

**Definition**

> onCreateAIRoadSpline(entityId node, )

**Arguments**

| entityId | node |
|----------|------|
| any      | node |

**Code**

```lua
function AISystem.onCreateAIRoadSpline(_, node)
    if node ~ = nil and node ~ = 0 then
        local maxWidth = tonumber(getUserAttribute(node, "maxWidth" ))
        local maxTurningRadius = tonumber(getUserAttribute(node, "maxTurningRadius" ))
        local maxHeight = tonumber(getUserAttribute(node, "maxHeight" ))
        g_currentMission.aiSystem:addRoadSpline(node, maxWidth, maxTurningRadius, maxHeight)
    end
end

```

### onMissionStarted

**Description**

**Definition**

> onMissionStarted()

**Arguments**

| any | isNewSavegame |
|-----|---------------|

**Code**

```lua
function AISystem:onMissionStarted(isNewSavegame)
    local worldSizeHalf = 0.5 * self.mission.terrainSize
    Logging.info( "No vehicle navigation cost map found.Start scanning map .. ." )
    updateVehicleNavigationMap( self.navigationMap, - worldSizeHalf, worldSizeHalf, - worldSizeHalf, worldSizeHalf)
end

```

### onTerrainLoad

**Description**

**Definition**

> onTerrainLoad()

**Arguments**

| any | terrainNode |
|-----|-------------|

**Code**

```lua
function AISystem:onTerrainLoad(terrainNode)
    if self.isServer then
        self.navigationMap = createVehicleNavigationMap( self.cellSizeMeters, terrainNode, self.maxSlopeAngle, self.infoLayerName, self.infoLayerChannel, self.aiDrivableCollisionMask, self.obstacleCollisionMask, self.vehicleMaxHeight, self.isLeftHandTraffic)

        if self.mission.trafficSystem ~ = nil then
            local roadSplineRootNodeId = self.mission.trafficSystem.rootNodeId
            self:addRoadSpline(roadSplineRootNodeId)
        end

        for i = # self.delayedRoadSplines, 1 , - 1 do
            local delayedSplineData = table.remove( self.delayedRoadSplines, 1 )
            self:addRoadSpline(delayedSplineData.spline, delayedSplineData.maxWidth, delayedSplineData.maxTurningRadius, delayedSplineData.maxHeight)
        end

        local missionInfo = self.mission.missionInfo
        local loadFromSave = false
        if missionInfo.isValid and missionInfo:getIsNavigationCollisionValid( self.mission) then
            local path = missionInfo.savegameDirectory .. "/" .. self.filename
            local success = loadVehicleNavigationCostMapFromFile( self.navigationMap, path)
            if success then
                Logging.info( "Loaded navigation cost map from savegame" )
                loadFromSave = true
            end
        end

        if not loadFromSave then
            g_messageCenter:subscribeOneshot(MessageType.CURRENT_MISSION_START, AISystem.onMissionStarted, self )
        end

        g_messageCenter:publishDelayedAfterFrames(MessageType.AI_SYSTEM_LOADED, 2 ) -- delay 2 frames as added splines need this to be processed in the engine
    end

    return true
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function AISystem:registerXMLPaths(schema)
    schema:register(XMLValueType.ANGLE, "aiSystem.maxSlopeAngle" , "Maximum terrain angle in degrees which is classified as drivable" , 15 )
    schema:register(XMLValueType.STRING, "aiSystem.blockedAreaInfoLayer#name" , "Map info layer name defining areas which are blocked for AI driving" , "navigationCollision" )
        schema:register(XMLValueType.INT, "aiSystem.blockedAreaInfoLayer#channel" , "Map info layer channel defining areas which are blocked for AI driving" , 0 )
            schema:register(XMLValueType.FLOAT, "aiSystem.vehicleMaxHeight" , "Maximum expected vehicle height used for generating the costmap, e.g.relevant for overhanging collisions" , 4 )
                schema:register(XMLValueType.FLOAT, "aiSystem.vehicleMaxHeightSpline" , "Default maximum vehicle height allowed for driving on splines, can be adjusted per spline via userAttribute 'maxHeight'" , 10 )
                    schema:register(XMLValueType.BOOL, "aiSystem.isLeftHandTraffic" , "Map has left-hand traffic.This setting will only affect collision avoidance, traffic and ai splines need to be set up as left hand in map itself" , false )
                end

```

### removeAgent

**Description**

**Definition**

> removeAgent()

**Arguments**

| any | agentId |
|-----|---------|

**Code**

```lua
function AISystem:removeAgent(agentId)
    self.activeAgents[agentId] = nil
end

```

### removeBlockingRegion

**Description**

**Definition**

> removeBlockingRegion(integer blockingRegionId)

**Arguments**

| integer | blockingRegionId |
|---------|------------------|

**Code**

```lua
function AISystem:removeBlockingRegion(blockingRegionId)
    if not self.isServer then
        return
    end

    if self.navigationMap = = nil or blockingRegionId = = nil then
        return
    end

    log( "AISystem:removeVehicleNavigationWorldBlockingRegion" , blockingRegionId)
    removeVehicleNavigationWorldBlockingRegion( self.navigationMap, blockingRegionId)
end

```

### removeJob

**Description**

**Definition**

> removeJob()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AISystem:removeJob(job)
    table.insert( self.jobsToRemove, job)
end

```

### removeJobVehicle

**Description**

**Definition**

> removeJobVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AISystem:removeJobVehicle(vehicle)
    table.removeElement( self.activeJobVehicles, vehicle)
end

```

### removeObstacle

**Description**

**Definition**

> removeObstacle(entityId node)

**Arguments**

| entityId | node |
|----------|------|

**Code**

```lua
function AISystem:removeObstacle(node)
    if self.isServer and self.navigationMap ~ = nil and node ~ = nil then
        removeVehicleNavigationPhysicsObstacle( self.navigationMap, node)
    end
end

```

### removeRoadSpline

**Description**

**Definition**

> removeRoadSpline(entityId spline)

**Arguments**

| entityId | spline |
|----------|--------|

**Code**

```lua
function AISystem:removeRoadSpline(spline)
    if self.isServer and spline ~ = nil then
        if self.navigationMap ~ = nil then
            removeRoadsFromVehicleNavigationMap( self.navigationMap, spline)
            setVisibility(spline, false )
            table.removeElement( self.roadSplines, spline)
        else
                for _, delayedSplineData in ipairs( self.delayedRoadSplines) do
                    if delayedSplineData.spline = = spline then
                        table.removeElement( self.delayedRoadSplines, delayedSplineData)
                        break
                    end
                end
            end
        end
    end

```

### save

**Description**

**Definition**

> save()

**Arguments**

| any | xmlFilename  |
|-----|--------------|
| any | usedModNames |

**Code**

```lua
function AISystem:save(xmlFilename, usedModNames)
    local xmlFile = XMLFile.create( "aiSystemXML" , xmlFilename, "aiSystem" )
    if xmlFile ~ = nil then
        local hasData = false
        if self.debug.target ~ = nil then
            local target = self.debug.target
            xmlFile:setFloat( "aiSystem.debug.target#posX" , target.x)
            xmlFile:setFloat( "aiSystem.debug.target#posY" , target.y)
            xmlFile:setFloat( "aiSystem.debug.target#posZ" , target.z)
            xmlFile:setFloat( "aiSystem.debug.target#dirX" , target.dirX)
            xmlFile:setFloat( "aiSystem.debug.target#dirY" , target.dirY)
            xmlFile:setFloat( "aiSystem.debug.target#dirZ" , target.dirZ)

            hasData = true
        end

        if hasData then
            xmlFile:save()
        end

        xmlFile:delete()
    end
end

```

### setAreaDirty

**Description**

> Set vehicle navigation costmap dirty for given AABB to enqueue reevaluation of costs, e.g. after removing or adding
> static phyiscs ojects

**Definition**

> setAreaDirty(float minX, float maxX, float minZ, float maxZ)

**Arguments**

| float | minX | world AABB min x |
|-------|------|------------------|
| float | maxX | world AABB max x |
| float | minZ | world AABB min z |
| float | maxZ | world AABB max z |

**Code**

```lua
function AISystem:setAreaDirty(minX, maxX, minZ, maxZ)
    if self.navigationMap ~ = nil then
        --#debug if self.debug.isCostRenderingActive then
            --#debug DebugPlane.newSimple(false, false, nil, true):createWithPositions(minX,0,minZ, maxX,0,minZ, minX,0,maxZ):addToManager("AISystemCostmap", 10000, 50)
            --#debug end
            updateVehicleNavigationMap( self.navigationMap, minX, maxX, minZ, maxZ)
        end
    end

```

### setBlockingRegionState

**Description**

**Definition**

> setBlockingRegionState(integer blockingRegionId, boolean isBlocking)

**Arguments**

| integer | blockingRegionId |                                                                      |
|---------|------------------|----------------------------------------------------------------------|
| boolean | isBlocking       | if true agents will be blocked by the region and wait in front of it |

**Code**

```lua
function AISystem:setBlockingRegionState(blockingRegionId, isBlocking)
    if not self.isServer then
        return
    end

    if self.navigationMap = = nil then
        -- TODO:enqueue
        Logging.warning( "AISystem:setBlockingRegionState():vehicle navigation not initialized yet/anymore" )
        printCallstack()
        return
    end

    setVehicleNavigationWorldBlockingRegionState( self.navigationMap, blockingRegionId, isBlocking)
end

```

### setObstacleIsPassable

**Description**

**Definition**

> setObstacleIsPassable(entityId node, boolean isPassable)

**Arguments**

| entityId | node       |
|----------|------------|
| boolean  | isPassable |

**Code**

```lua
function AISystem:setObstacleIsPassable(node, isPassable)
    if self.isServer and self.navigationMap ~ = nil and node ~ = nil then
        setVehicleNavigationPhysicsObstacleIsPassable( self.navigationMap, node, isPassable)
    end
end

```

### skipCurrentTask

**Description**

**Definition**

> skipCurrentTask()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AISystem:skipCurrentTask(job)
    -- if self.isServer then
        -- self:skipCurrentTaskInternal(job)
        -- else
            g_client:getServerConnection():sendEvent( AIJobSkipTaskEvent.new(job))
            -- end
        end

```

### skipCurrentTaskInternal

**Description**

**Definition**

> skipCurrentTaskInternal()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AISystem:skipCurrentTaskInternal(job)
    job:skipCurrentTask()
end

```

### startJob

**Description**

**Definition**

> startJob()

**Arguments**

| any | job         |
|-----|-------------|
| any | startFarmId |

**Code**

```lua
function AISystem:startJob(job, startFarmId)
    assert( self.isServer)
    if self.isServer then
        job:setId( AISystem.NEXT_JOB_ID)
        AISystem.NEXT_JOB_ID = AISystem.NEXT_JOB_ID + 1

        g_server:broadcastEvent( AIJobStartEvent.new(job, startFarmId))

        self:startJobInternal(job, startFarmId)
    end
end

```

### startJobInternal

**Description**

**Definition**

> startJobInternal()

**Arguments**

| any | job         |
|-----|-------------|
| any | startFarmId |

**Code**

```lua
function AISystem:startJobInternal(job, startFarmId)
    job:start(startFarmId)
    self:addJob(job)

    g_messageCenter:publish(MessageType.AI_JOB_STARTED, job, startFarmId)
end

```

### stopJob

**Description**

**Definition**

> stopJob()

**Arguments**

| any | job       |
|-----|-----------|
| any | aiMessage |

**Code**

```lua
function AISystem:stopJob(job, aiMessage)
    if self.isServer then
        self:stopJobInternal(job, aiMessage)
        g_server:broadcastEvent( AIJobStopEvent.new(job, aiMessage))
    else
            -- just send a request to the server.
            -- server will broadcast the real job to all clients
            g_client:getServerConnection():sendEvent( AIJobStopEvent.new(job, aiMessage))
        end
    end

```

### stopJobById

**Description**

**Definition**

> stopJobById()

**Arguments**

| any | jobId       |
|-----|-------------|
| any | aiMessage   |
| any | noEventSend |

**Code**

```lua
function AISystem:stopJobById(jobId, aiMessage, noEventSend)
    local job = self:getJobById(jobId)
    if job ~ = nil then
        self:stopJob(job, aiMessage, noEventSend)
        return true
    end

    return false
end

```

### stopJobInternal

**Description**

**Definition**

> stopJobInternal()

**Arguments**

| any | job       |
|-----|-----------|
| any | aiMessage |

**Code**

```lua
function AISystem:stopJobInternal(job, aiMessage)
    job:stop(aiMessage)
    self:removeJob(job)

    g_messageCenter:publish(MessageType.AI_JOB_STOPPED, job, aiMessage)
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AISystem:update(dt)
    for i = # self.jobsToRemove, 1 , - 1 do
        local job = self.jobsToRemove[i]
        local jobId = job.jobId

        table.removeElement( self.activeJobs, job)
        table.remove( self.jobsToRemove, i)

        g_messageCenter:publish(MessageType.AI_JOB_REMOVED, jobId)
    end

    for _, job in ipairs( self.activeJobs) do
        job:update(dt)

        if self.isServer and g_currentMission.isRunning then
            job:updateCost(dt)
        end
    end
end

```