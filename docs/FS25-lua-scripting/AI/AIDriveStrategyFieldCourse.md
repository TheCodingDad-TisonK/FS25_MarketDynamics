## AIDriveStrategyFieldCourse

**Description**

> Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Parent**

> [AIDriveStrategy](?version=script&category=4&class=150)

**Functions**

- [delete](#delete)
- [fillReconstructionData](#fillreconstructiondata)
- [getDriveData](#getdrivedata)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onFieldCourseLoadedCallback](#onfieldcourseloadedcallback)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [saveToXML](#savetoxml)
- [setAIVehicle](#setaivehicle)
- [update](#update)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AIDriveStrategyFieldCourse:delete()
    AIDriveStrategyFieldCourse:superClass().delete( self )

    for _, implement in ipairs( self.vehicle:getAttachedAIImplements()) do
        implement.object:aiImplementEndLine()

        local rootVehicle = implement.object.rootVehicle
        rootVehicle:raiseStateChange(VehicleStateChange.AI_END_LINE)
    end
end

```

### fillReconstructionData

**Description**

**Definition**

> fillReconstructionData()

**Arguments**

| any | data |
|-----|------|

**Code**

```lua
function AIDriveStrategyFieldCourse:fillReconstructionData(data)
    if self.aiFieldCourse ~ = nil then
        data.aiFieldCourseReconstructionData = AIFieldCourseReconstructionData.new()
        data.aiFieldCourseReconstructionData:setDataByAIFieldCourse( self.aiFieldCourse)
    end
end

```

### getDriveData

**Description**

**Definition**

> getDriveData()

**Arguments**

| any | dt |
|-----|----|
| any | vX |
| any | vY |
| any | vZ |

**Code**

```lua
function AIDriveStrategyFieldCourse:getDriveData(dt, vX, vY, vZ)
    if self.fieldDetectionInProgress = = nil then
        if self.fieldNotOwned then
            self.vehicle:stopCurrentAIJob( AIMessageErrorFieldNotOwned.new())
            self:debugPrint( "Stopping AIVehicle - Field not owned" )
        else
                self.vehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
                self:debugPrint( "Stopping AIVehicle - Failed to start field detection" )
            end

            return
        end

        local isTurning, _ = false , nil
        if self.aiFieldCourse ~ = nil then
            isTurning, _, _, _, _, _ = self.aiFieldCourse:getActiveSegmentData()
        end

        local tX, tZ, moveForwards, maxSpeed, distanceToStop = 0 , 0 , true , 0 , 0

        local canContinueWork, stopAI, stopReason = self.vehicle:getCanAIFieldWorkerContinueWork(isTurning)
        if not canContinueWork then
            self.lastContinueWorkState = false
            self.lastContinueWorkBlockedTime = g_ time

            if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                self.vehicle:addAIDebugText( "- Wait for turn on(getCanAIFieldWorkerContinueWork)" )
                end

                maxSpeed = 0

                if stopAI then
                    self.vehicle:stopCurrentAIJob(stopReason or AIMessageErrorUnknown.new())
                    self:debugPrint( "Stopping AIVehicle - cannot continue work" )
                end

                return tX, tZ, moveForwards, maxSpeed, distanceToStop
            else
                    self.lastContinueWorkState = true
                end

                if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                    if self.aiFieldCourse ~ = nil then
                        self.aiFieldCourse:addDebugTexts( self.vehicle)
                    end

                    self.vehicle:addAIDebugText( string.format( " Has Static Collision: %s" , self.hasStaticCollision))
                    self.vehicle:addAIDebugText( string.format( " Collision Distance:dynamic: %.1f static: %.1f" , self.collisionHandler.dynamicHitPointDistance, self.collisionHandler.staticHitPointDistance))
                    self.vehicle:addAIDebugText( string.format( " Is Blocked: %s" , self.isBlocked))
                    self.vehicle:addAIDebugText( string.format( " Distance To Collision: %s" , self.collisionDistance))

                    if self.aiFieldCourse ~ = nil then
                        local aiImplements = self.vehicle:getAttachedAIImplements()
                        for i, implement in ipairs(aiImplements) do
                            local leftMarker, rightMarker, backMarker, _ = implement.object:getAIMarkers()
                            local lx, _, lz = getWorldTranslation(leftMarker)
                            local rx, _, rz = getWorldTranslation(rightMarker)
                            local leftOffset = self.aiFieldCourse:getPositionOffsetToActiveSegment(lx, lz)
                            local rightOffset = self.aiFieldCourse:getPositionOffsetToActiveSegment(rx, rz)

                            local _, _, maxZOffset = localToLocal(leftMarker, self.vehicleAISteeringNode, 0 , 0 , 0 )
                            local _, _, minZOffset = localToLocal(backMarker, self.vehicleAISteeringNode, 0 , 0 , 0 )

                            self.vehicle:addAIDebugText( string.format( "%s" , implement.object:getName()))
                            self.vehicle:addAIDebugText( string.format( " Side Drift: %.2fm | Width: %.2fm" , (leftOffset + rightOffset) * 0.5 * - 1 , calcDistanceFrom(leftMarker, rightMarker)))
                            self.vehicle:addAIDebugText( string.format( " zOffset: %.2fm / %.2fm" , minZOffset, maxZOffset))
                        end

                        self.vehicle:addAIDebugText( string.format( " Segment Side Offset: %.2f" , self.aiFieldCourse:getActiveSegmentSideOffset()))
                    end
                end

                if self.isBlocked then
                    return tX, tZ, moveForwards, maxSpeed, distanceToStop
                end

                if self.aiFieldCourse ~ = nil then
                    local steeringOffset = 4
                    vX, vY, vZ = getWorldTranslation( self.lastMovingDirection > 0 and self.vehicleAISteeringNode or self.vehicleAISteeringNodeReverse)

                    tX, tZ, moveForwards, maxSpeed, distanceToStop = self.aiFieldCourse:getDriveData(dt, vX, vY, vZ, self.vehicle:getLastSpeed(), steeringOffset, self.reverserDirectionNodeRefNode)

                    if tX ~ = nil and(tX ~ = 0 or tZ ~ = 0 ) then
                        if not moveForwards and self.reverserDirectionNode ~ = nil then
                            local rx, _, rz = getWorldTranslation( self.reverserDirectionNode)
                            local revDistance = MathUtil.vector2Length(tX - rx, tZ - rz)

                            local dirX1, _, dirZ1 = localDirectionToWorld( self.vehicleAISteeringNodeReverse, 0 , 0 , 1 )
                            local length1 = MathUtil.vector2Length(dirX1, dirZ1)

                            local dirX2, _, dirZ2 = localDirectionToWorld( self.reverserDirectionNode, 0 , 0 , 1 )
                            local length2 = MathUtil.vector2Length(dirX2, dirZ2)

                            if length1 > 0 and length2 > 0 then
                                dirX1, dirZ1 = dirX1 / length1, dirZ1 / length1
                                dirX2, dirZ2 = dirX2 / length2, dirZ2 / length2

                                local z = MathUtil.getProjectOnLineParameter(tX, tZ, rx, rz, dirX2, dirZ2)
                                local x = math.sqrt(revDistance * revDistance - z * z)

                                local sDirX, sDirZ = MathUtil.vector2Normalize(rx - tX, rz - tZ)
                                x = x * math.sign( MathUtil.dotProduct( - dirZ2, 0 , dirX2, sDirX, 0 , sDirZ))

                                local angle = MathUtil.getSignedAngleBetweenVectors2D(dirX1, dirZ1, dirX2, dirZ2)

                                local ltX = math.cos(angle) * x - math.sin(angle) * z
                                local ltZ = math.sin(angle) * x + math.cos(angle) * z

                                if not MathUtil.isNan(ltX) and not MathUtil.isNan(ltZ) then
                                    tX, _, tZ = localToWorld( self.vehicleAISteeringNodeReverse, - ltX, 0 , ltZ)
                                end
                            end
                        end

                        if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                            local _, _, segmentPosition, segmentLength, subSegmentPosition, subSegmentLength = self.aiFieldCourse:getActiveSegmentData()
                            if segmentPosition ~ = nil then
                                self.vehicle:addAIDebugText( string.format( "Segment Position: %.1f%% of %.1fm" , segmentPosition * 100 , segmentLength))
                                if subSegmentLength ~ = segmentLength then
                                    self.vehicle:addAIDebugText( string.format( "Sub Segment Position: %.1f%% of %.1fm" , subSegmentPosition * 100 , subSegmentLength))
                                end
                            end
                        end

                        self.lastVehiclePosition[ 1 ] = vX
                        self.lastVehiclePosition[ 2 ] = vY
                        self.lastVehiclePosition[ 3 ] = vZ
                        self.lastTargetPosition[ 1 ] = tX
                        self.lastTargetPosition[ 2 ] = vY
                        self.lastTargetPosition[ 3 ] = tZ
                        self.lastMovingDirection = moveForwards and 1 or - 1
                    end
                end

                if self.collisionDistance ~ = math.huge and moveForwards then
                    maxSpeed = math.min(maxSpeed, math.max( self.collisionDistance * 2 , 1 ))
                end

                return tX, tZ, moveForwards, maxSpeed, distanceToStop
            end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | data    |
|-----|---------|
| any | xmlFile |
| any | key     |

**Code**

```lua
function AIDriveStrategyFieldCourse.loadFromXML(data, xmlFile, key)
    data.aiFieldCourseReconstructionData = AIFieldCourseReconstructionData.new()
    if not data.aiFieldCourseReconstructionData:loadFromXML(xmlFile, key .. ".strategyFieldCourse" ) then
        data.aiFieldCourseReconstructionData = nil
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | reconstructionData |
|-----|--------------------|
| any | customMt           |

**Code**

```lua
function AIDriveStrategyFieldCourse.new(reconstructionData, customMt)
    local self = AIDriveStrategy.new(reconstructionData, customMt or AIDriveStrategyFieldCourse _mt)

    self.collisionHandler = AICollisionTriggerHandler.new()

    self.isBlocked = false
    self.hasStaticCollision = false
    self.hasStaticCollisionTimer = 0
    self.collisionDistance = math.huge

    self.lastContinueWorkState = false
    self.lastContinueWorkBlockedTime = - math.huge

    self.reconstructionData = reconstructionData

    return self
end

```

### onFieldCourseLoadedCallback

**Description**

**Definition**

> onFieldCourseLoadedCallback()

**Arguments**

| any | fieldCourse |
|-----|-------------|

**Code**

```lua
function AIDriveStrategyFieldCourse:onFieldCourseLoadedCallback(fieldCourse)
    if self.vehicle.isDeleted or self.vehicle.isDeleting then
        return
    end

    if fieldCourse ~ = nil then
        -- callback is allowed with pre adjusted AIFieldCourse as well(from savegame)
        local aiFieldCourse = nil
        if ClassUtil.getClassObjectByObject(fieldCourse) = = FieldCourse then
            aiFieldCourse = AIFieldCourse.new(fieldCourse)
        else
                aiFieldCourse = fieldCourse
                fieldCourse = aiFieldCourse.fieldCourse
            end

            if fieldCourse.isVineyardCourse then
                self.vehicle:stopCurrentAIJob( AIMessageErrorVineyardNotSupported.new())
                self:debugPrint( "Stopping AIVehicle - Vineyard course not supported" )
                return
            end

            local _

            local aiRootNode = self.vehicle:getAIDirectionNode()
            self.startX, _, self.startZ = localToWorld(aiRootNode, 0 , 0 , 0 )
            local dx, _, dz = localDirectionToWorld(aiRootNode, 0 , 0 , 1 )
            self.startYRot = MathUtil.getYRotationFromDirection(dx, dz)

            local attachedAIImplements = self.vehicle:getAttachedAIImplements()

            aiFieldCourse:setStartPosition( self.startX, self.startZ, self.startYRot)

            self:debugPrint( " Start Position: %.3f %.3f(%.3f°)" , self.startX, self.startZ, math.deg( self.startYRot))

            self.aiFieldCourse = aiFieldCourse

            aiFieldCourse:setInitialSegmentCallback( function ()
                self.initialSegmentFinished = true

                if not self.fieldCourseSettings.workInitialSegment then
                    self.vehicle:raiseAIEvent( "onAIFieldWorkerPrepareForWork" , "onAIImplementPrepareForWork" )
                end
            end )

            aiFieldCourse:setSegmentAreaValidityFunction( function (startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
                for i, implement in ipairs(attachedAIImplements) do
                    local area, totalArea = AIVehicleUtil.getAIAreaOfVehicle(implement.object, startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
                    if totalArea > 0 and area / totalArea > 0 then
                        return true
                    end
                end

                return false
            end )

            if self.fieldCourseSettings.workInitialSegment then
                self.vehicle:raiseAIEvent( "onAIFieldWorkerPrepareForWork" , "onAIImplementPrepareForWork" )
            end

            aiFieldCourse:finalize( function ()
                if #aiFieldCourse.fieldCourse.segments = = 0 then
                    self.vehicle:stopCurrentAIJob( AIMessageErrorFieldNotReady.new())
                    return
                end

                self.fieldDetectionInProgress = false
            end )
        else
                self.vehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
                self:debugPrint( "Stopping AIVehicle - Field boundary not detected" )
            end
        end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AIDriveStrategyFieldCourse.registerSavegameXMLPaths(schema, basePath)
    AIFieldCourseReconstructionData.registerXMLPaths(schema, basePath .. ".strategyFieldCourse" )
end

```

### saveToXML

**Description**

**Definition**

> saveToXML()

**Arguments**

| any | data    |
|-----|---------|
| any | xmlFile |
| any | key     |

**Code**

```lua
function AIDriveStrategyFieldCourse.saveToXML(data, xmlFile, key)
    if data.aiFieldCourseReconstructionData ~ = nil then
        data.aiFieldCourseReconstructionData:saveToXML(xmlFile, key .. ".strategyFieldCourse" )
    end
end

```

### setAIVehicle

**Description**

**Definition**

> setAIVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIDriveStrategyFieldCourse:setAIVehicle(vehicle)
    AIDriveStrategyFieldCourse:superClass().setAIVehicle( self , vehicle)

    self.collisionHandler:init(vehicle, self )

    self.vehicleAISteeringNode = self.vehicle:getAISteeringNode()
    self.vehicleAISteeringNodeReverse = self.vehicle:getAIReverserNode()

    self.reverserDirectionNode = AIVehicleUtil.getAIToolReverserDirectionNode( self.vehicle)
    self.reverserDirectionNodeRefNode = self.reverserDirectionNode -- ref node is only used a reference for the on-segment-position

        if self.reverserDirectionNodeRefNode = = nil then
            if self.vehicle.getAIToolReverserDirectionNode ~ = nil then
                self.reverserDirectionNodeRefNode = self.vehicle:getAIToolReverserDirectionNode()
            end

            if self.reverserDirectionNodeRefNode = = nil then
                if self.vehicleAISteeringNodeReverse ~ = self.vehicleAISteeringNode then
                    self.reverserDirectionNodeRefNode = self.vehicleAISteeringNodeReverse
                end
            end
        end

        self.vehicle.aiDriveDirection = { 0 , 1 }
        self.vehicle.aiDriveTarget = { 0 , 0 }

        self.lastVehiclePosition = { 0 , 0 , 0 }
        self.lastTargetPosition = { 0 , 0 , 1 }
        self.lastMovingDirection = 1

        self.lastSegmentIsTurn = false
        self.nextSegmentTurnSide = nil
        self.lastSegmentTurnSide = nil

        self.vehicle:initializeLoadedAIModeUserSettings()
        self.fieldCourseSettings = self.vehicle:getAIModeFieldCourseSettings()

        if self.fieldCourseSettings ~ = nil then
            self.implementData = self.fieldCourseSettings:resetDynamicSettings( self.vehicle)
        else
                self.fieldCourseSettings, self.implementData = FieldCourseSettings.generate( self.vehicle)
            end

            self.fieldCourseSettings:print( self.debugPrint, self )

            local doFieldDetection = true
            if self.reconstructionData ~ = nil then
                if self.reconstructionData.aiFieldCourseReconstructionData ~ = nil then
                    doFieldDetection = false

                    Logging.devInfo( "Using field course data from savegame" )

                    local vx, _, vz = localToWorld( self.vehicle:getAIDirectionNode(), 0 , 0 , 0 )

                    self.fieldDetectionInProgress = true
                    if not self.reconstructionData.aiFieldCourseReconstructionData:apply( self , self.onFieldCourseLoadedCallback, vx, vz) then
                        self.fieldDetectionInProgress = nil
                        doFieldDetection = true
                    end
                end
            end

            if doFieldDetection then
                local notOwned = false
                if AIDriveStrategyFieldCourse.fieldDetectionPosition = = nil then
                    self.fieldDetectionX, self.fieldDetectionZ, notOwned = FieldCourse.findClosestField( nil , nil , nil , nil , self.vehicle:getAIJobFarmId(), self.vehicle, 2 , self.fieldCourseSettings)
                else
                        self.fieldDetectionX, self.fieldDetectionZ = AIDriveStrategyFieldCourse.fieldDetectionPosition[ 1 ], AIDriveStrategyFieldCourse.fieldDetectionPosition[ 2 ]
                    end

                    if self.fieldDetectionX ~ = nil and notOwned = = false then
                        self.fieldDetectionInProgress = true

                        g_fieldCourseManager:generateFieldCourseAtWorldPos( self.fieldDetectionX, self.fieldDetectionZ, self.fieldCourseSettings, self.onFieldCourseLoadedCallback, self )
                    elseif notOwned then
                            self.fieldNotOwned = true
                        end
                    end

                    self.collisionHandler:setStaticCollisionCallback( function (hasStaticCollision)
                        self.hasStaticCollision = hasStaticCollision
                    end )
                    self.collisionHandler:setIsBlockedCallback( function (isBlocked)
                        self.isBlocked = isBlocked

                        if g_server ~ = nil then
                            g_server:broadcastEvent( AIVehicleIsBlockedEvent.new( self.vehicle, isBlocked), true , nil , self.vehicle)
                        end
                    end )
                    self.collisionHandler:setCollisionDistanceCallback( function (distance)
                        self.collisionDistance = distance
                    end )
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
function AIDriveStrategyFieldCourse:update(dt)
    self.collisionHandler:update(dt, self.lastMovingDirection)

    if self.aiFieldCourse ~ = nil then
        self.aiFieldCourse:update(dt)

        if VehicleDebug.state = = VehicleDebug.DEBUG_AI and self.vehicle.isActiveForInputIgnoreSelectionIgnoreAI then
            self.aiFieldCourse:draw()
            self.fieldCourseSettings:draw()
        end

        local aiImplements = self.vehicle:getAttachedAIImplements()

        local segmentIsTurn, segmentIsInitial, segmentPosition, _, _, _ = self.aiFieldCourse:getActiveSegmentData()
        if segmentIsTurn ~ = nil then
            local isInitial, sideOffset = self.aiFieldCourse:getNextSegmentData()
            if not isInitial and sideOffset ~ = nil then
                local nextSegmentTurnSide = sideOffset > 0
                if nextSegmentTurnSide ~ = self.nextSegmentTurnSide then
                    self.vehicle:aiFieldWorkerSideOffsetChanged(nextSegmentTurnSide, segmentIsInitial)
                    self.nextSegmentTurnSide = nextSegmentTurnSide
                end
            end

            if not segmentIsInitial or self.fieldCourseSettings.workInitialSegment then
                if segmentIsTurn ~ = self.lastSegmentIsTurn then
                    if segmentIsTurn then
                        self.lastSegmentTurnSide = self.nextSegmentTurnSide
                        self.vehicle:aiFieldWorkerStartTurn( self.lastSegmentTurnSide, nil )
                    else
                            self.vehicle:aiFieldWorkerEndTurn( self.lastSegmentTurnSide, nil )
                        end

                        self.lastSegmentIsTurn = segmentIsTurn
                    elseif segmentIsTurn then
                            self.vehicle:aiFieldWorkerTurnProgress(segmentPosition, self.lastSegmentTurnSide, self.lastMovingDirection)
                        end

                        for i, implement in ipairs(aiImplements) do
                            local data = self.implementData[i]

                            if not self.fieldCourseSettings.toolAlwaysActive then
                                local doAreaCheck = false
                                if segmentIsTurn or self.lastMovingDirection < 0 then
                                    data.isLowered = false

                                    -- for tools that can never reverse we check also on headlands if we have valid
                                        -- ground below and lower the tool to work as much as we can
                                        -- or if we have only a front tool mounted we work our path to the first segment
                                            if ( not self.fieldCourseSettings.canTurnBackward and not self.fieldCourseSettings.allowStraightReversing)
                                                or( self.fieldCourseSettings.workInitialSegment and segmentIsInitial and self.lastMovingDirection > 0 ) then
                                                doAreaCheck = true
                                            end
                                        else
                                                -- on the line we always do checks for valid ground and lower only if it was found
                                                    -- have some delay between beeing blocked due to lowering/lifting and the next area checks
                                                    -- to avoid changing of the area state during lowering/lifting
                                                    doAreaCheck = g_ time - self.lastContinueWorkBlockedTime > 1000
                                                end

                                                if doAreaCheck then
                                                    local leftMarker, rightMarker, backMarker, markersInverted = implement.object:getAIMarkers()
                                                    local _, _, areaLength = localToLocal(leftMarker, backMarker, 0 , 0 , 0 )

                                                    -- we apply a savety offset here cause on same implements the markers are moved on x axis while lifting the tool
                                                        -- with this offset we don't check the next row
                                                        local safetyOffset = 0.2

                                                        local size = 3 + areaLength

                                                        local getAreaDimensions = function (leftNode, rightNode, xOffset, zOffset, areaSize, invertXOffset)
                                                            local xOffsetLeft, xOffsetRight = xOffset, xOffset
                                                            if invertXOffset = = nil or invertXOffset then
                                                                xOffsetLeft = - xOffsetLeft
                                                            end

                                                            if markersInverted then
                                                                xOffsetLeft = - xOffsetLeft
                                                                xOffsetRight = - xOffsetRight
                                                            end

                                                            local sX, _, sZ = localToWorld(leftNode, xOffsetLeft, 0 , zOffset)
                                                            local hX, _, hZ = localToWorld(leftNode, xOffsetLeft, 0 , zOffset + areaSize)
                                                            local wX, _, wZ = localToWorld(rightNode, xOffsetRight, 0 , zOffset)

                                                            return sX, sZ, wX, wZ, hX, hZ
                                                        end

                                                        local sX, sZ, wX, wZ, hX, hZ = getAreaDimensions(leftMarker, rightMarker, safetyOffset, - areaLength, size)

                                                        local area, totalArea = AIVehicleUtil.getAIAreaOfVehicle(implement.object, sX, sZ, wX, wZ, hX, hZ)
                                                        if totalArea > 0 and area / totalArea > 0 then
                                                            data.isLowered = true
                                                        else
                                                                data.isLowered = false
                                                            end

                                                            if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                                local x, z, widthX, widthZ, heightX, heightZ = MathUtil.getXZWidthAndHeight(sX, sZ, wX, wZ, hX, hZ)
                                                                DebugUtil.drawDebugParallelogram(x, z, widthX, widthZ, heightX, heightZ, 0.2 , data.isLowered and 0 or 1 , data.isLowered and 1 or 0 , 0 , 1 )
                                                            end
                                                        end
                                                    else
                                                            data.isLowered = not segmentIsTurn and self.lastMovingDirection > = 0
                                                        end

                                                        -- a implement always lowers it's parent(s) as well
                                                        local currentData = data
                                                        while currentData.parentAIImplement ~ = nil do
                                                            if currentData.isLowered and not currentData.parentAIImplement.isLowered then
                                                                currentData.parentAIImplement.isLowered = true
                                                            end

                                                            currentData = currentData.parentAIImplement
                                                        end
                                                    end
                                                end
                                            end

                                            self.vehicle:setAIFieldWorkerIsTurning(segmentIsTurn)

                                            local isCornerCutOutActive = self.aiFieldCourse:getIsCornerCutOutActive()
                                            self.vehicle:setAIFieldWorkerIsCornerCutOutActive(isCornerCutOutActive)

                                            for i, implement in ipairs(aiImplements) do
                                                local data = self.implementData[i]

                                                if data.isLowered then
                                                    if data.wasLowered ~ = true then
                                                        implement.object:aiImplementStartLine()

                                                        local rootVehicle = implement.object:getRootVehicle()
                                                        rootVehicle:raiseStateChange(VehicleStateChange.AI_START_LINE)
                                                    end
                                                else
                                                        if data.wasLowered ~ = false then
                                                            implement.object:aiImplementEndLine()

                                                            local rootVehicle = implement.object:getRootVehicle()
                                                            rootVehicle:raiseStateChange(VehicleStateChange.AI_END_LINE)
                                                        end
                                                    end

                                                    data.wasLowered = data.isLowered
                                                end

                                                local vX, vY, vZ = self.lastVehiclePosition[ 1 ], self.lastVehiclePosition[ 2 ], self.lastVehiclePosition[ 3 ]
                                                local tX, tY, tZ = self.lastTargetPosition[ 1 ], self.lastTargetPosition[ 2 ], self.lastTargetPosition[ 3 ]
                                                local dx, dz = MathUtil.vector2Normalize(tX - vX, tZ - vZ)
                                                local r, g, b = 0 , 1 , 0
                                                if self.lastMovingDirection < 0 then
                                                    r, g, b = 1 , 0 , 0
                                                end
                                                drawDebugTriangle(vX + dz * 0.25 , vY + 4 , vZ - dx * 0.25 , vX - dz * 0.25 , vY + 4 , vZ + dx * 0.25 , tX, tY + 4 , tZ, r, g, b, 0.2 , true )

                                                if self.hasStaticCollision and self.lastContinueWorkState then
                                                    if self.vehicle:getLastSpeed() < 1 then
                                                        self.hasStaticCollisionTimer = self.hasStaticCollisionTimer + dt
                                                        if self.hasStaticCollisionTimer > 5000 then
                                                            self.hasStaticCollisionTimer = 0

                                                            self.aiFieldCourse:skipCurrentSubSegment( 25 )
                                                            self:debugPrint( "AIVehicle blocked - skip current sub segment" )
                                                        end
                                                    else
                                                            self.hasStaticCollisionTimer = 0
                                                        end
                                                    else
                                                            self.hasStaticCollisionTimer = 0
                                                        end
                                                    end
                                                end

```