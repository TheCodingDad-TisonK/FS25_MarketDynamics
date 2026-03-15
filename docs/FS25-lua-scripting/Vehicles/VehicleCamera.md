## VehicleCamera

**Description**

> Camera for vehicles

**Functions**

- [actionEventLookLeftRight](#actioneventlookleftright)
- [actionEventLookUpDown](#actioneventlookupdown)
- [consoleCommandCameraYDebug](#consolecommandcameraydebug)
- [consoleCommandLODDebug](#consolecommandloddebug)
- [delete](#delete)
- [getCollisionDistance](#getcollisiondistance)
- [getTiltDirectionOffset](#gettiltdirectionoffset)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onActivate](#onactivate)
- [onActiveCameraSuspensionSettingChanged](#onactivecamerasuspensionsettingchanged)
- [onCameraCollisionDetectionSettingChanged](#oncameracollisiondetectionsettingchanged)
- [onDeactivate](#ondeactivate)
- [onFovySettingChanged](#onfovysettingchanged)
- [onPostLoad](#onpostload)
- [raycastCallback](#raycastcallback)
- [registerCameraSavegameXMLPaths](#registercamerasavegamexmlpaths)
- [registerCameraXMLPaths](#registercameraxmlpaths)
- [resetCamera](#resetcamera)
- [saveToXMLFile](#savetoxmlfile)
- [setCameraYDebugState](#setcameraydebugstate)
- [setLODDebugState](#setloddebugstate)
- [setSeparateCameraPose](#setseparatecamerapose)
- [touchEventLookLeftRight](#toucheventlookleftright)
- [touchEventLookUpDown](#toucheventlookupdown)
- [touchEventZoomInOut](#toucheventzoominout)
- [update](#update)
- [updateRotateNodeRotation](#updaterotatenoderotation)
- [zoomSmoothly](#zoomsmoothly)

### actionEventLookLeftRight

**Description**

**Definition**

> actionEventLookLeftRight()

**Arguments**

| any | actionName    |
|-----|---------------|
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |
| any | isMouse       |

**Code**

```lua
function VehicleCamera:actionEventLookLeftRight(actionName, inputValue, callbackState, isAnalog, isMouse)
    if isMouse then
        inputValue = inputValue * 0.001 * 16.666
    else
            inputValue = inputValue * 0.001 * g_currentDt
        end
        self.lastInputValues.leftRight = self.lastInputValues.leftRight + inputValue

        --#debug if self.cameraYDebugMode then
            --#debug local mouseButtonLast, _ = g_inputBinding:getMouseButtonState()
            --#debug if mouseButtonLast = = Input.MOUSE_BUTTON_MIDDLE then
                --#debug local x, y, z = getTranslation(self.rotateNode)
                --#debug setTranslation(self.rotateNode, x, y, z + inputValue)
                --#debug end
                --#debug end
            end

```

### actionEventLookUpDown

**Description**

**Definition**

> actionEventLookUpDown()

**Arguments**

| any | actionName    |
|-----|---------------|
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |
| any | isMouse       |

**Code**

```lua
function VehicleCamera:actionEventLookUpDown(actionName, inputValue, callbackState, isAnalog, isMouse)
    if isMouse then
        inputValue = inputValue * 0.001 * 16.666
    else
            inputValue = inputValue * 0.001 * g_currentDt
        end
        self.lastInputValues.upDown = self.lastInputValues.upDown + inputValue

        --#debug if self.cameraYDebugMode then
            --#debug local mouseButtonLast, _ = g_inputBinding:getMouseButtonState()
            --#debug if mouseButtonLast = = Input.MOUSE_BUTTON_MIDDLE then
                --#debug local x, y, z = getTranslation(self.rotateNode)
                --#debug setTranslation(self.rotateNode, x, y + inputValue, z)
                --#debug end
                --#debug end
            end

```

### consoleCommandCameraYDebug

**Description**

**Definition**

> consoleCommandCameraYDebug()

**Arguments**

| any | height |
|-----|--------|

**Code**

```lua
function VehicleCamera.consoleCommandCameraYDebug(height)
    if g_activeVehicleCamera ~ = nil then
        g_activeVehicleCamera:setCameraYDebugState( not g_activeVehicleCamera.cameraYDebugMode, height)
        return string.format( "(%s) Vehicle Camera Y Debug: %s" , g_activeVehicleCamera.vehicle:getName(), g_activeVehicleCamera.cameraYDebugMode)
    end

    return "Enter a vehicle first!"
end

```

### consoleCommandLODDebug

**Description**

**Definition**

> consoleCommandLODDebug()

**Code**

```lua
function VehicleCamera.consoleCommandLODDebug()
    if g_activeVehicleCamera ~ = nil then
        g_activeVehicleCamera:setLODDebugState( not g_activeVehicleCamera.lodDebugMode)
        return string.format( "(%s) Vehicle Camera LOD Debug: %s" , g_activeVehicleCamera.vehicle:getName(), g_activeVehicleCamera.lodDebugMode)
    end

    return "Enter a vehicle first!"
end

```

### delete

**Description**

> Deleting vehicle camera

**Definition**

> delete()

**Code**

```lua
function VehicleCamera:delete()
    g_cameraManager:removeCamera( self.cameraNode)

    self:onDeactivate()

    if self.cameraNode ~ = nil and self.positionSmoothingParameter > 0 then
        delete( self.cameraNode)
        self.cameraNode = nil
    end

    if self.cameraWorldParent ~ = nil then
        delete( self.cameraWorldParent)
        self.cameraWorldParent = nil
    end

    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.ACTIVE_SUSPENSION_CAMERA], self )
    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.FOV_Y], self )
    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.CAMERA_CHECK_COLLISION], self )
end

```

### getCollisionDistance

**Description**

> Get distance to collision

**Definition**

> getCollisionDistance()

**Return Values**

| any | hasCollision      | has collision         |
|-----|-------------------|-----------------------|
| any | collisionDistance | distance to collision |
| any | normalX           | normal x              |
| any | normalY           | normal y              |
| any | normalZ           | normal z              |
| any | normalDotDir      | normal dot direction  |

**Code**

```lua
function VehicleCamera:getCollisionDistance()
    if not self.isCollisionEnabled then
        return false , nil , nil , nil , nil , nil
    end

    --#profile RemoteProfiler.zoneBeginN("VehicleCamera:getCollisionDistance")

    local raycastMask = VehicleCamera.raycastMask

    local targetCamX, targetCamY, targetCamZ = localToWorld( self.rotateNode, self.transDirX * self.zoomTarget, self.transDirY * self.zoomTarget, self.transDirZ * self.zoomTarget)

    local hasCollision = false
    local collisionDistance = - 1
    local normalX,normalY,normalZ
    local normalDotDir
    for _, raycastNode in ipairs( self.raycastNodes) do

        hasCollision = false

        local nodeX, nodeY, nodeZ = getWorldTranslation(raycastNode)
        local dirX, dirY, dirZ = targetCamX - nodeX, targetCamY - nodeY, targetCamZ - nodeZ
        local dirLength = MathUtil.vector3Length(dirX, dirY, dirZ)
        dirX = dirX / dirLength
        dirY = dirY / dirLength
        dirZ = dirZ / dirLength

        local startX = nodeX
        local startY = nodeY
        local startZ = nodeZ
        local currentDistance = 0
        local minDistance = self.transMin

        while true do
            if (dirLength - currentDistance) < = 0 then
                break
            end
            self.raycastDistance = 0
            raycastClosest(startX, startY, startZ, dirX, dirY, dirZ, dirLength - currentDistance, "raycastCallback" , self , raycastMask)

            if self.raycastDistance ~ = 0 then
                currentDistance = currentDistance + self.raycastDistance + 0.001
                local ndotd = MathUtil.dotProduct( self.normalX, self.normalY, self.normalZ, dirX, dirY, dirZ)

                local object = g_currentMission:getNodeObject( self.raycastTransformId)
                local ignoreObject = object = = self.vehicle

                if object ~ = nil and not ignoreObject then
                    if object.rootVehicle = = self.vehicle.rootVehicle then
                        ignoreObject = true
                    end

                    if not ignoreObject then
                        local vehicles = self.vehicle:getChildVehicles()
                        for i = 1 , #vehicles do
                            local vehicle = vehicles[i]

                            if object ~ = vehicle then
                                local mountObject = object.dynamicMountObject or object.tensionMountObject or object.mountObject
                                if mountObject ~ = nil and(mountObject = = vehicle or mountObject.rootVehicle = = vehicle) then
                                    ignoreObject = true
                                    break
                                end
                            end
                        end
                    end
                end

                -- ignore cut trees that are loaded to a vehicle
                if not ignoreObject and getHasClassId( self.raycastTransformId, ClassIds.MESH_SPLIT_SHAPE) then
                    ignoreObject = true
                end

                if not ignoreObject and getHasTrigger( self.raycastTransformId) then
                    ignoreObject = true
                end

                if ignoreObject then
                    if ndotd > 0 then
                        minDistance = math.max(minDistance, currentDistance)
                    end
                else
                        hasCollision = true
                        -- we take the distance from the rotate node
                        if raycastNode = = self.rotateNode then
                            normalX,normalY,normalZ = self.normalX, self.normalY, self.normalZ

                            -- for static buildings we allow less than min.distance
                                -- for all other objects we limit by min.camera translation(e.g.if you load a dynamic object onto a pickup truck)
                                    if getRigidBodyType( self.raycastTransformId) = = RigidBodyType.STATIC then
                                        collisionDistance = currentDistance
                                    else
                                            collisionDistance = math.max( self.transMin, currentDistance)
                                        end

                                        normalDotDir = ndotd
                                    end
                                    break
                                end
                                startX = nodeX + dirX * currentDistance
                                startY = nodeY + dirY * currentDistance
                                startZ = nodeZ + dirZ * currentDistance
                            else
                                    break
                                end
                            end
                            if not hasCollision then
                                break
                            end
                        end

                        --#profile RemoteProfiler.zoneEnd()

                        return hasCollision, collisionDistance, normalX,normalY,normalZ, normalDotDir
                    end

```

### getTiltDirectionOffset

**Description**

> Set separate camera pose

**Definition**

> getTiltDirectionOffset()

**Code**

```lua
function VehicleCamera:getTiltDirectionOffset()
    if not self.isInside and g_gameSettings:getValue(GameSettings.SETTING.CAMERA_TILTING) and getHasTouchpad() then
        local dx, dy, dz = getGravityDirection()
        local tiltOffset = MathUtil.getHorizontalRotationFromDeviceGravity(dx, dy, dz)
        return tiltOffset
    end

    return 0
end

```

### loadFromXML

**Description**

> Load vehicle camera from xml file

**Definition**

> loadFromXML(XMLFile xmlFile, string key, , )

**Arguments**

| XMLFile | xmlFile     | XMLFile instance |
|---------|-------------|------------------|
| string  | key         | key              |
| any     | savegame    |                  |
| any     | cameraIndex |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function VehicleCamera:loadFromXML(xmlFile, key, savegame, cameraIndex)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, self.vehicle.configFileName, key .. "#index" , "#node" ) -- FS17 to FS19

    self.cameraNode = xmlFile:getValue(key .. "#node" , nil , self.vehicle.components, self.vehicle.i3dMappings)
    if self.cameraNode = = nil or not getHasClassId( self.cameraNode, ClassIds.CAMERA) then
        Logging.xmlWarning(xmlFile, "Invalid camera node for camera '%s'.Must be a camera type!" , key)
            return false
        end

        self.shadowFocusBoxNode = xmlFile:getValue(key .. "#shadowFocusBox" , nil , self.vehicle.components, self.vehicle.i3dMappings)
        if self.shadowFocusBoxNode ~ = nil and( not getHasClassId( self.shadowFocusBoxNode, ClassIds.SHAPE) or not getShapeIsCPUMesh( self.shadowFocusBoxNode)) then
            Logging.xmlWarning(xmlFile, "Invalid camera shadow focus box '%s'.Must be a shape and cpu mesh" , getName( self.shadowFocusBoxNode))
            self.shadowFocusBoxNode = nil
        end

        if Platform.gameplay.hasShadowFocusBox then
            if self.isInside and self.shadowFocusBoxNode = = nil then
                Logging.xmlDevWarning(xmlFile, "Missing shadow focus box for indoor camera '%s'" , key)
                end
            else
                    if self.shadowFocusBoxNode ~ = nil then
                        Logging.xmlDevWarning(xmlFile, "Shadow focus box for camera '%s' not allowed on this platform" , key)
                            self.shadowFocusBoxNode = nil
                        end
                    end

                    self.isInside = xmlFile:getValue(key .. "#isInside" , false )
                    self.allowHeadTracking = xmlFile:getValue(key .. "#allowHeadTracking" , self.isInside)
                    self.useOutdoorSounds = xmlFile:getValue(key .. "#useOutdoorSounds" , not self.isInside)

                    local lowResColHandlerHighPrio = self.isInside -- update precipitation occlusion cells directly next to the camera each frame to avoid visible particles inside the cabin
                    local dofInfo
                    if not self.isInside then
                        dofInfo = g_depthOfFieldManager:createInfo( 0.5 , 1 , 0.3 , 400 , 1400 , false ) --DOF ON
                        -- dofInfo = g_depthOfFieldManager:createInfo(nil, nil, nil, nil, nil, nil) --DOF OFF
                    end
                    g_cameraManager:addCamera( self.cameraNode, self.shadowFocusBoxNode, false , lowResColHandlerHighPrio, dofInfo)

                    -- collect vehicle collision nodes to toggle PRECIPITATION_BLOCKING col bit when indoor camera is active
                    if self.isInside then
                        self.collisionNodes = { }

                        I3DUtil.iterateRecursively( self.vehicle.rootNode, function (node)
                            if getHasClassId(node, ClassIds.SHAPE) and(getRigidBodyType(node) ~ = RigidBodyType.NONE or getIsCompoundChild(node)) and bit32.btest(getCollisionFilterGroup(node), CollisionFlag.VEHICLE) then
                                table.insert( self.collisionNodes, node)
                            end
                        end , true )
                    end

                    self.defaultFovY = getFovY( self.cameraNode)
                    self.fovY = calculateFovY( self.defaultFovY)
                    setFovY( self.cameraNode, self.fovY)

                    self.isRotatable = xmlFile:getValue(key .. "#rotatable" , false )
                    self.limit = xmlFile:getValue(key .. "#limit" , false )
                    if self.limit then
                        self.rotMinX = xmlFile:getValue(key .. "#rotMinX" )
                        self.rotMaxX = xmlFile:getValue(key .. "#rotMaxX" )

                        self.transMin = xmlFile:getValue(key .. "#transMin" )
                        self.transMax = xmlFile:getValue(key .. "#transMax" )

                        if self.transMax ~ = nil then
                            self.transMax = math.max( self.transMin, self.transMax * Platform.gameplay.maxCameraZoomFactor)
                        end

                        if self.rotMinX = = nil or self.rotMaxX = = nil or self.transMin = = nil or self.transMax = = nil then
                            Logging.xmlWarning(xmlFile, "Missing 'rotMinX', 'rotMaxX', 'transMin' or 'transMax' for camera '%s'" , key)
                                return false
                            end
                        end

                        if self.isRotatable then
                            self.rotateNode = xmlFile:getValue(key .. "#rotateNode" , nil , self.vehicle.components, self.vehicle.i3dMappings)
                            self.hasExtraRotationNode = self.rotateNode ~ = nil
                        end

                        local rotation = xmlFile:getValue(key .. "#rotation" , nil , true )
                        if rotation ~ = nil then
                            local rotationNode = self.cameraNode
                            if self.rotateNode ~ = nil then
                                rotationNode = self.rotateNode
                            end
                            setRotation(rotationNode, unpack(rotation))
                        end
                        local translation = xmlFile:getValue(key .. "#translation" , nil , true )
                        if translation ~ = nil then
                            setTranslation( self.cameraNode, unpack(translation))
                        end

                        self.allowTranslation = ( self.rotateNode ~ = nil and self.rotateNode ~ = self.cameraNode)

                        self.useMirror = xmlFile:getValue(key .. "#useMirror" , false )
                        self.useWorldXZRotation = xmlFile:getValue(key .. "#useWorldXZRotation" ) -- overrides the ingame setting
                        self.resetCameraOnVehicleSwitch = xmlFile:getValue(key .. "#resetCameraOnVehicleSwitch" ) -- overrides the ingame setting
                        self.suspensionNodeIndex = xmlFile:getValue(key .. "#suspensionNodeIndex" )

                        if ( not Platform.gameplay.useWorldCameraInside and self.isInside) or
                            ( not Platform.gameplay.useWorldCameraOutside and not self.isInside) then
                            self.useWorldXZRotation = false
                        end

                        self.positionSmoothingParameter = 0
                        self.lookAtSmoothingParameter = 0
                        local useDefaultPositionSmoothing = xmlFile:getValue(key .. "#useDefaultPositionSmoothing" , true )
                        if useDefaultPositionSmoothing then
                            if self.isInside then
                                self.positionSmoothingParameter = 0.128 -- 0.095
                                self.lookAtSmoothingParameter = 0.176 -- 0.12
                            else
                                    self.positionSmoothingParameter = 0.016
                                    self.lookAtSmoothingParameter = 0.022
                                end
                            end
                            self.positionSmoothingParameter = xmlFile:getValue(key .. "#positionSmoothingParameter" , self.positionSmoothingParameter)
                            self.lookAtSmoothingParameter = xmlFile:getValue(key .. "#lookAtSmoothingParameter" , self.lookAtSmoothingParameter)

                            local useHeadTracking = g_gameSettings:getValue(GameSettings.SETTING.IS_HEAD_TRACKING_ENABLED) and isHeadTrackingAvailable() and self.allowHeadTracking
                            if useHeadTracking then
                                self.positionSmoothingParameter = 0
                                self.lookAtSmoothingParameter = 0
                            end

                            self.cameraPositionNode = self.cameraNode
                            if self.positionSmoothingParameter > 0 then
                                -- create a node which indicates the target position of the camera
                                self.cameraPositionNode = createTransformGroup( "cameraPositionNode" )
                                local camIndex = getChildIndex( self.cameraNode)
                                link(getParent( self.cameraNode), self.cameraPositionNode, camIndex)
                                local x,y,z = getTranslation( self.cameraNode)
                                local rx,ry,rz = getRotation( self.cameraNode)
                                setTranslation( self.cameraPositionNode, x, y, z)
                                setRotation( self.cameraPositionNode, rx, ry, rz)

                                -- parent node of the camera in world space that is already aligned with the Y rotation to the target position
                                -- this avoids gimbal lock issues when at 0 or 180 degree(#)
                                self.cameraWorldParent = createTransformGroup( "cameraWorldParent" )
                                link( self.cameraWorldParent, self.cameraNode)
                            end
                            self.rotYSteeringRotSpeed = xmlFile:getValue(key .. "#rotYSteeringRotSpeed" , 0 )

                            if self.rotateNode = = nil or self.rotateNode = = self.cameraNode then
                                self.rotateNode = self.cameraPositionNode
                            end

                            if useHeadTracking then
                                local dx,_,dz = localDirectionToLocal( self.cameraPositionNode, getParent( self.cameraPositionNode), 0 , 0 , 1 )
                                local tx,ty,tz = localToLocal( self.cameraPositionNode, getParent( self.cameraPositionNode), 0 , 0 , 0 )
                                self.headTrackingNode = createTransformGroup( "headTrackingNode" )
                                link(getParent( self.cameraPositionNode), self.headTrackingNode)
                                setTranslation( self.headTrackingNode, tx, ty, tz)
                                if math.abs(dx) + math.abs(dz) > 0.0001 then
                                    setDirection( self.headTrackingNode, dx, 0 , dz, 0 , 1 , 0 )
                                else
                                        setRotation( self.headTrackingNode, 0 , 0 , 0 )
                                    end
                                end

                                self.origRotX, self.origRotY, self.origRotZ = getRotation( self.rotateNode)
                                self.rotX = self.origRotX
                                self.rotY = self.origRotY
                                self.rotZ = self.origRotZ

                                self.origTransX, self.origTransY, self.origTransZ = getTranslation( self.cameraPositionNode)
                                self.transX = self.origTransX
                                self.transY = self.origTransY
                                self.transZ = self.origTransZ

                                local transLength = MathUtil.vector3Length( self.origTransX, self.origTransY, self.origTransZ) + 0.00001 -- prevent devision by zero
                                self.zoom = transLength
                                self.zoomTarget = transLength
                                self.zoomDefault = transLength
                                self.zoomLimitedTarget = - 1

                                local trans1OverLength = 1.0 / transLength
                                self.transDirX = trans1OverLength * self.origTransX
                                self.transDirY = trans1OverLength * self.origTransY
                                self.transDirZ = trans1OverLength * self.origTransZ
                                if self.allowTranslation then
                                    if transLength < = 0.01 then
                                        Logging.xmlWarning(xmlFile, "Invalid camera translation for camera '%s'.Distance needs to be bigger than 0.01" , key)
                                        end
                                    end

                                    table.insert( self.raycastNodes, self.rotateNode)

                                    for _, raycastKey in xmlFile:iterator(key .. ".raycastNode" ) do
                                        XMLUtil.checkDeprecatedXMLElements(xmlFile, self.vehicle.configFileName, raycastKey .. "#index" , raycastKey .. "#node" ) --FS17 to FS19

                                        local node = xmlFile:getValue(raycastKey .. "#node" , nil , self.vehicle.components, self.vehicle.i3dMappings)
                                        if node ~ = nil then
                                            table.insert( self.raycastNodes, node)
                                        end
                                    end

                                    local sx, sy, sz = getScale( self.cameraNode)
                                    if sx ~ = 1 or sy ~ = 1 or sz ~ = 1 then
                                        Logging.xmlWarning(xmlFile, "Vehicle camera with scale found for camera '%s'.Resetting to scale 1" , key)
                                            setScale( self.cameraNode, 1 , 1 , 1 )
                                        end

                                        self.changeObjects = { }
                                        ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, self.changeObjects, self.vehicle.components, self.vehicle)
                                        ObjectChangeUtil.setObjectChanges( self.changeObjects, false , self.vehicle, self.vehicle.setMovingToolDirty)

                                        if not g_gameSettings:getValue(GameSettings.SETTING.RESET_CAMERA) or g_currentMission.vehicleSystem.isReloadRunning then
                                            if savegame ~ = nil and not savegame.resetVehicles then
                                                local cameraKey = string.format(savegame.key .. ".enterable.camera(%d)" , cameraIndex)
                                                if savegame.xmlFile:hasProperty(cameraKey) then
                                                    local rotX, rotY, rotZ = savegame.xmlFile:getValue(cameraKey .. "#rotation" , { self.rotX, self.rotY, self.rotZ } )
                                                    if not( MathUtil.isNan(rotX) or MathUtil.isNan(rotY) or MathUtil.isNan(rotZ)) then
                                                        self.rotX, self.rotY, self.rotZ = rotX, rotY, rotZ

                                                        if self.allowTranslation then
                                                            self.transX, self.transY, self.transZ = savegame.xmlFile:getValue(cameraKey .. "#translation" , { self.transX, self.transY, self.transZ } )

                                                            self.zoom = savegame.xmlFile:getValue(cameraKey .. "#zoom" , self.zoom)
                                                            self.zoomTarget = self.zoom
                                                        end

                                                        setTranslation( self.cameraPositionNode, self.transX, self.transY, self.transZ)
                                                        setRotation( self.rotateNode, self.rotX, self.rotY, self.rotZ)

                                                        if g_currentMission.vehicleSystem.isReloadRunning then
                                                            local fovY = savegame.xmlFile:getValue(cameraKey .. "#fovY" )
                                                            if fovY ~ = nil then
                                                                setFovY( self.cameraNode, fovY)
                                                            end
                                                        end

                                                        self.lodDebugModeLoaded = savegame.xmlFile:getValue(cameraKey .. "#lodDebugActive" , false )
                                                        if self.lodDebugModeLoaded then
                                                            self.loadDebugZoom = savegame.xmlFile:getValue(cameraKey .. "#lodDebugZoom" , self.zoom)
                                                        end

                                                        --#debug self.cameraYDebugModeLoaded = savegame.xmlFile:getValue(cameraKey .. "#cameraYDebugActive", false)
                                                        --#debug if self.cameraYDebugModeLoaded then
                                                            --#debug self.cameraYDebugHeight = savegame.xmlFile:getValue(cameraKey .. "#cameraYDebugHeight")
                                                            --#debug end
                                                        end
                                                    end
                                                end
                                            end

                                            return true
                                        end

```

### new

**Description**

> Creating vehicle camera

**Definition**

> new(Vehicle vehicle, table? customMt)

**Arguments**

| Vehicle | vehicle  | The vehicle that this camera belongs to. |
|---------|----------|------------------------------------------|
| table?  | customMt | Custom metatable.                        |

**Return Values**

| table? | self | The created instance. |
|--------|------|-----------------------|

**Code**

```lua
function VehicleCamera.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or VehicleCamera _mt)

    self.vehicle = vehicle
    self.isActivated = false

    self.limitRotXDelta = 0

    self.cameraNode = nil

    self.raycastDistance = 0
    self.normalX = 0
    self.normalY = 0
    self.normalZ = 0

    self.raycastNodes = { }
    self.disableCollisionTime = - 1

    self.lookAtPosition = { 0 , 0 , 0 }
    self.lookAtLastTargetPosition = { 0 , 0 , 0 }
    self.position = { 0 , 0 , 0 }
    self.lastTargetPosition = { 0 , 0 , 0 }
    self.upVector = { 0 , 0 , 0 }
    self.lastUpVector = { 0 , 0 , 0 }

    self.lastInputValues = { }
    self.lastInputValues.upDown = 0
    self.lastInputValues.leftRight = 0

    self.isCollisionEnabled = true
    if g_modIsLoaded[ "FS22_disableVehicleCameraCollision" ] or g_isDevelopmentVersion then
        self.isCollisionEnabled = g_gameSettings:getValue(GameSettings.SETTING.CAMERA_CHECK_COLLISION)
        g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.CAMERA_CHECK_COLLISION], self.onCameraCollisionDetectionSettingChanged, self )
    end

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.ACTIVE_SUSPENSION_CAMERA], self.onActiveCameraSuspensionSettingChanged, self )
    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.FOV_Y], self.onFovySettingChanged, self )

    return self
end

```

### onActivate

**Description**

> Called on activate

**Definition**

> onActivate()

**Code**

```lua
function VehicleCamera:onActivate()
    if self.cameraNode = = nil then
        return
    end

    if g_addCheatCommands then
        addConsoleCommand( "gsCameraAutoRotate" , "Auto rotate vehicle outdoor camera" , "consoleCommandSetAutoRotate" , self , "speed" )
        addConsoleCommand( "gsCameraOffset" , "Offset vehicle outdoor camera target" , "consoleCommandSetOffset" , self , "x; y; z" )
        addConsoleCommand( "gsCameraRotationSaveLoad" , "Save and load current camera rotation + zoom" , "consoleCommandRotationSaveLoad" , self )
    end

    self:onActiveCameraSuspensionSettingChanged(g_gameSettings:getValue(GameSettings.SETTING.ACTIVE_SUSPENSION_CAMERA))

    self.isActivated = true
    if not g_currentMission.vehicleSystem.isReloadRunning then
        if ( self.resetCameraOnVehicleSwitch = = nil and g_gameSettings:getValue(GameSettings.SETTING.RESET_CAMERA)) or self.resetCameraOnVehicleSwitch then
            self:resetCamera()
        end
    end

    if g_cameraManager:getActiveCamera() ~ = self.cameraNode then
        g_cameraManager:setActiveCamera( self.cameraNode)
    end

    local rx,ry,rz = getWorldRotation( self.rotateNode)
    if MathUtil.isNan(rx) or MathUtil.isNan(ry) or MathUtil.isNan(rz) then
        self:resetCamera()
    end

    if self.positionSmoothingParameter > 0 then
        local xlook,ylook,zlook = getWorldTranslation( self.rotateNode)

        -- inject offset from console command
        xlook = xlook + ( self.offsetX or 0 )
        ylook = ylook + ( self.offsetY or 0 )
        zlook = zlook + ( self.offsetZ or 0 )

        self.lookAtPosition[ 1 ] = xlook
        self.lookAtPosition[ 2 ] = ylook
        self.lookAtPosition[ 3 ] = zlook
        self.lookAtLastTargetPosition[ 1 ] = xlook
        self.lookAtLastTargetPosition[ 2 ] = ylook
        self.lookAtLastTargetPosition[ 3 ] = zlook
        local x,y,z = getWorldTranslation( self.cameraPositionNode)
        self.position[ 1 ] = x
        self.position[ 2 ] = y
        self.position[ 3 ] = z
        self.lastTargetPosition[ 1 ] = x
        self.lastTargetPosition[ 2 ] = y
        self.lastTargetPosition[ 3 ] = z
        local upx, upy, upz = localDirectionToWorld( self.rotateNode, self:getTiltDirectionOffset(), 1 , 0 )
        self.upVector[ 1 ] = upx
        self.upVector[ 2 ] = upy
        self.upVector[ 3 ] = upz
        self.lastUpVector[ 1 ] = upx
        self.lastUpVector[ 2 ] = upy
        self.lastUpVector[ 3 ] = upz

        setWorldRotation( self.cameraNode, rx,ry,rz)
        setWorldTranslation( self.cameraNode, x,y,z)
    end

    self.lastInputValues = { }
    self.lastInputValues.upDown = 0
    self.lastInputValues.leftRight = 0

    -- activate action event callbacks
    g_inputBinding:beginActionEventsModification( Vehicle.INPUT_CONTEXT_NAME)
    local _, actionEventId1 = g_inputBinding:registerActionEvent(InputAction.AXIS_LOOK_UPDOWN_VEHICLE, self , VehicleCamera.actionEventLookUpDown, false , false , true , true , nil )
    local _, actionEventId2 = g_inputBinding:registerActionEvent(InputAction.AXIS_LOOK_LEFTRIGHT_VEHICLE, self , VehicleCamera.actionEventLookLeftRight, false , false , true , true , nil )
    g_inputBinding:setActionEventTextVisibility(actionEventId1, false )
    g_inputBinding:setActionEventTextVisibility(actionEventId2, false )
    g_inputBinding:endActionEventsModification()

    ObjectChangeUtil.setObjectChanges( self.changeObjects, true , self.vehicle, self.vehicle.setMovingToolDirty)

    -- add PRECIPITATION_BLOCKING bit to cols
    self:updatePrecipitationCollisions( true )

    if g_touchHandler ~ = nil then
        self.touchListenerPinch = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_PINCH, VehicleCamera.touchEventZoomInOut, self )
        self.touchListenerY = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_AXIS_Y, VehicleCamera.touchEventLookUpDown, self )
        self.touchListenerX = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_AXIS_X, VehicleCamera.touchEventLookLeftRight, self )
    end

    g_activeVehicleCamera = self
    if self.lodDebugModeLoaded then
        self:setLODDebugState( self.lodDebugModeLoaded, self.loadDebugZoom)
        self.lodDebugModeLoaded = nil
    end
    --#debug if self.cameraYDebugModeLoaded then
        --#debug self:setCameraYDebugState(self.cameraYDebugModeLoaded, self.cameraYDebugHeight)
        --#debug self.cameraYDebugModeLoaded = nil
        --#debug end
    end

```

### onActiveCameraSuspensionSettingChanged

**Description**

> Called when camera suspension setting has changed

**Definition**

> onActiveCameraSuspensionSettingChanged(boolean newState)

**Arguments**

| boolean | newState | new setting state |
|---------|----------|-------------------|

**Code**

```lua
function VehicleCamera:onActiveCameraSuspensionSettingChanged(newState)
    if self.suspensionNode ~ = nil then
        if self.lastActiveCameraSuspensionSetting ~ = newState then
            if newState then
                link( self.cameraSuspensionParentNode, self.cameraPositionNode)
            else
                    link( self.cameraBaseParentNode, self.cameraPositionNode)
                end

                self.lastActiveCameraSuspensionSetting = newState
            end
        end
    end

```

### onCameraCollisionDetectionSettingChanged

**Description**

> Called when camera collision detection setting has changed

**Definition**

> onCameraCollisionDetectionSettingChanged(boolean newState)

**Arguments**

| boolean | newState | new setting state |
|---------|----------|-------------------|

**Code**

```lua
function VehicleCamera:onCameraCollisionDetectionSettingChanged(newState)
    self.isCollisionEnabled = newState
end

```

### onDeactivate

**Description**

> Called on deactivate

**Definition**

> onDeactivate()

**Code**

```lua
function VehicleCamera:onDeactivate()
    self.isActivated = false

    removeConsoleCommand( "gsCameraAutoRotate" )
    removeConsoleCommand( "gsCameraOffset" )
    removeConsoleCommand( "gsCameraRotationSaveLoad" )

    -- remove action event callbacks
    g_inputBinding:beginActionEventsModification( Vehicle.INPUT_CONTEXT_NAME)
    g_inputBinding:removeActionEventsByTarget( self )
    g_inputBinding:endActionEventsModification()

    ObjectChangeUtil.setObjectChanges( self.changeObjects, false , self.vehicle, self.vehicle.setMovingToolDirty)

    -- remove PRECIPITATION_BLOCKING bit from cols
    self:updatePrecipitationCollisions( false )

    if g_touchHandler ~ = nil then
        g_touchHandler:removeGestureListener( self.touchListenerPinch)
        g_touchHandler:removeGestureListener( self.touchListenerY)
        g_touchHandler:removeGestureListener( self.touchListenerX)
    end

    if self.lodDebugMode then
        self:setLODDebugState( false )
    end
    --#debug if self.cameraYDebugMode then
        --#debug self:setCameraYDebugState(false)
        --#debug end
        if g_activeVehicleCamera = = self then
            g_activeVehicleCamera = nil
        end
    end

```

### onFovySettingChanged

**Description**

> Called when camera fovy setting has changed

**Definition**

> onFovySettingChanged()

**Code**

```lua
function VehicleCamera:onFovySettingChanged()
    if self.cameraNode ~ = nil then
        self.fovY = calculateFovY( self.defaultFovY)
        setFovY( self.cameraNode, self.fovY)
    end
end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame data |
|-------|----------|---------------|

**Code**

```lua
function VehicleCamera:onPostLoad(savegame)
    self.suspensionNode = nil
    if self.suspensionNodeIndex ~ = nil and self.vehicle.getSuspensionNodeFromIndex ~ = nil then
        self.suspensionNode = self.vehicle:getSuspensionNodeFromIndex( self.suspensionNodeIndex)
        if self.suspensionNode = = nil then
            Logging.warning( "Vehicle Camera '%s' with invalid suspensionIndex '%s' found." , getName( self.cameraNode), self.suspensionNodeIndex)
        end
    end
    if self.suspensionNode ~ = nil then
        if self.suspensionNode.node ~ = nil then
            -- at the suspension node Y offset to the camera position, so we move both together
            -- like this we can set up the camera correctly in maya / editor and the ingame position still matches
            if self.suspensionNode.startTranslationOffset ~ = nil then
                local yOffset = self.suspensionNode.startTranslationOffset[ 2 ]
                if yOffset ~ = 0 then
                    self.origTransY = self.origTransY + yOffset
                    setTranslation( self.cameraPositionNode, self.origTransX, self.origTransY, self.origTransZ)
                end
            end

            self.cameraSuspensionParentNode = createTransformGroup( "cameraSuspensionParentNode" )
            link( self.suspensionNode.node, self.cameraSuspensionParentNode)
            setWorldTranslation( self.cameraSuspensionParentNode, getWorldTranslation(getParent( self.cameraPositionNode)))
            setWorldQuaternion( self.cameraSuspensionParentNode, getWorldQuaternion(getParent( self.cameraPositionNode)))

            self.cameraBaseParentNode = getParent( self.cameraPositionNode)

            self.lastActiveCameraSuspensionSetting = false
        else
                Logging.warning( "Vehicle Camera '%s' with invalid suspensionIndex '%s' found.CharacterTorso suspensions are not allowed." , getName( self.cameraNode), self.suspensionNodeIndex)
                self.suspensionNode = nil
            end
        end
    end

```

### raycastCallback

**Description**

> Raycast callback

**Definition**

> raycastCallback(integer transformId, float x, float y, float z, float distance, float nx, float ny, float nz)

**Arguments**

| integer | transformId | id raycasted object          |
|---------|-------------|------------------------------|
| float   | x           | x raycast position           |
| float   | y           | y raycast position           |
| float   | z           | z raycast position           |
| float   | distance    | distance to raycast position |
| float   | nx          | normal x                     |
| float   | ny          | normal y                     |
| float   | nz          | normal z                     |

**Code**

```lua
function VehicleCamera:raycastCallback(transformId, x, y, z, distance, nx, ny, nz)
    self.raycastDistance = distance
    self.normalX = nx
    self.normalY = ny
    self.normalZ = nz
    self.raycastTransformId = transformId
end

```

### registerCameraSavegameXMLPaths

**Description**

**Definition**

> registerCameraSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function VehicleCamera.registerCameraSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.VECTOR_ROT, basePath .. "#rotation" , "Camera rotation" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#translation" , "Camera translation" )
    schema:register(XMLValueType.FLOAT, basePath .. "#zoom" , "Camera zoom" )
    schema:register(XMLValueType.ANGLE, basePath .. "#fovY" , "Custom Field of View Y" )
    schema:register(XMLValueType.BOOL, basePath .. "#lodDebugActive" , "LOD Debug Mode Active" )
    schema:register(XMLValueType.FLOAT, basePath .. "#lodDebugZoom" , "LOD Debug Mode Zoom Ref" )
    schema:register(XMLValueType.BOOL, basePath .. "#cameraYDebugActive" , "Camera Y Debug Mode Active" )
    schema:register(XMLValueType.FLOAT, basePath .. "#cameraYDebugHeight" , "Camera Y Debug Mode orthographic height" )
end

```

### registerCameraXMLPaths

**Description**

**Definition**

> registerCameraXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function VehicleCamera.registerCameraXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Camera node" )
    schema:register(XMLValueType.BOOL, basePath .. "#rotatable" , "Camera is rotatable" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#limit" , "Has limits" , false )
    schema:register(XMLValueType.FLOAT, basePath .. "#rotMinX" , "Min.X rotation" )
    schema:register(XMLValueType.FLOAT, basePath .. "#rotMaxX" , "Max.X rotation" )
    schema:register(XMLValueType.FLOAT, basePath .. "#transMin" , "Min.Z translation" )
    schema:register(XMLValueType.FLOAT, basePath .. "#transMax" , "Max.Z translation" )

    schema:register(XMLValueType.BOOL, basePath .. "#isInside" , "Is camera inside.Used for camera smoothing and fallback/default value for 'useOutdoorSounds'" , false )
        schema:register(XMLValueType.BOOL, basePath .. "#allowHeadTracking" , "Allow head tracking" , "isInside value" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. "#shadowFocusBox" , "Shadow focus box" )

        schema:register(XMLValueType.BOOL, basePath .. "#useOutdoorSounds" , "Use outdoor sounds" , "false for 'isInside' cameras, otherwise true" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. "#rotateNode" , "Rotate node" )
            schema:register(XMLValueType.VECTOR_ROT, basePath .. "#rotation" , "Camera rotation" )
            schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#translation" , "Camera translation" )

            schema:register(XMLValueType.BOOL, basePath .. "#useMirror" , "Use mirrors" , false )
            schema:register(XMLValueType.BOOL, basePath .. "#useWorldXZRotation" , "Use world XZ rotation" )
            schema:register(XMLValueType.BOOL, basePath .. "#resetCameraOnVehicleSwitch" , "Reset camera on vehicle switch" )
            schema:register(XMLValueType.INT, basePath .. "#suspensionNodeIndex" , "Index of seat suspension node" )
            schema:register(XMLValueType.BOOL, basePath .. "#useDefaultPositionSmoothing" , "Use default position smoothing parameters" , true )

            schema:register(XMLValueType.FLOAT, basePath .. "#positionSmoothingParameter" , "Position smoothing parameter" , "0.128 for indoor / 0.016 for outside" )
                schema:register(XMLValueType.FLOAT, basePath .. "#lookAtSmoothingParameter" , "Look at smoothing parameter" , "0.176 for indoor / 0.022 for outside" )

                    schema:register(XMLValueType.ANGLE, basePath .. "#rotYSteeringRotSpeed" , "Rot Y steering rotation speed" , 0 )

                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".raycastNode(?)#node" , "Raycast node" )

                    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
                end

```

### resetCamera

**Description**

> Reset camera to original pose

**Definition**

> resetCamera()

**Code**

```lua
function VehicleCamera:resetCamera()
    self.rotX = self.origRotX
    self.rotY = self.origRotY
    self.rotZ = self.origRotZ

    self.transX = self.origTransX
    self.transY = self.origTransY
    self.transZ = self.origTransZ

    local transLength = MathUtil.vector3Length( self.origTransX, self.origTransY, self.origTransZ)
    self.zoom = transLength
    self.zoomTarget = transLength
    self.zoomLimitedTarget = - 1

    self:updateRotateNodeRotation()
    setTranslation( self.cameraPositionNode, self.transX, self.transY, self.transZ)

    if self.positionSmoothingParameter > 0 then
        local xlook,ylook,zlook = getWorldTranslation( self.rotateNode)
        self.lookAtPosition[ 1 ] = xlook + ( self.offsetX or 0 )
        self.lookAtPosition[ 2 ] = ylook + ( self.offsetY or 0 )
        self.lookAtPosition[ 3 ] = zlook + ( self.offsetZ or 0 )
        local x,y,z = getWorldTranslation( self.cameraPositionNode)
        self.position[ 1 ] = x
        self.position[ 2 ] = y
        self.position[ 3 ] = z

        self:setSeparateCameraPose()
    end
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function VehicleCamera:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#rotation" , self.rotX, self.rotY, self.rotZ)
    xmlFile:setValue(key .. "#translation" , self.transX, self.transY, self.transZ)
    xmlFile:setValue(key .. "#zoom" , self.zoom)
    xmlFile:setValue(key .. "#fovY" , getFovY( self.cameraNode))

    if self.lodDebugMode then
        xmlFile:setValue(key .. "#lodDebugActive" , true )
        xmlFile:setValue(key .. "#lodDebugZoom" , self.loadDebugZoom)
    end
    --#debug if self.cameraYDebugMode then
        --#debug xmlFile:setValue(key .. "#cameraYDebugActive", true)
        --#debug xmlFile:setValue(key .. "#cameraYDebugHeight", getOrthographicHeight(self.cameraNode))
        --#debug end
    end

```

### setCameraYDebugState

**Description**

**Definition**

> setCameraYDebugState()

**Arguments**

| any | state  |
|-----|--------|
| any | height |

**Code**

```lua
function VehicleCamera:setCameraYDebugState(state, height)
    if state ~ = self.cameraYDebugMode then
        self.cameraYDebugMode = state
        if self.cameraYDebugMode then
            self.cameraYDebugHeight = tonumber(height) or 5
            self.cameraYDebugZoom = self.zoom

            self.rotX, self.rotY, self.rotZ = 0 , math.pi * 0.5 , 0
            setRotation( self.rotateNode, self.rotX, self.rotY, self.rotZ)
            setIsOrthographic( self.cameraNode, true )
            setOrthographicHeight( self.cameraNode, tonumber(height) or 5 )
            self.isRotatable = false

            g_currentMission.hud:setIsVisible( false )
        else
                self.isRotatable = true
                setIsOrthographic( self.cameraNode, false )

                if self = = g_activeVehicleCamera then
                    g_currentMission.hud:setIsVisible( true )
                end
            end
        end
    end

```

### setLODDebugState

**Description**

**Definition**

> setLODDebugState()

**Arguments**

| any | state |
|-----|-------|
| any | zoom  |

**Code**

```lua
function VehicleCamera:setLODDebugState(state, zoom)
    if state ~ = self.lodDebugMode then
        self.lodDebugMode = state
        if self.lodDebugMode then
            self.transMaxOrig = self.transMax
            self.transMax = 350
            self.loadDebugZoom = zoom or self.zoom

            setViewDistanceCoeff( 1 )
            setLODDistanceCoeff( 1 )
            setTerrainLODDistanceCoeff( 1 )
        else
                self.transMax = self.transMaxOrig
                self.zoomTarget = self.zoomDefault
                self.zoom = self.zoomDefault
                setFovY( self.cameraNode, self.fovY)

                setViewDistanceCoeff(g_settingsModel.percentValues[g_settingsModel:getValue( SettingsModel.SETTING.OBJECT_DRAW_DISTANCE)])
                setLODDistanceCoeff(g_settingsModel.percentValues[g_settingsModel:getValue( SettingsModel.SETTING.LOD_DISTANCE)])
                setTerrainLODDistanceCoeff(g_settingsModel.percentValues[g_settingsModel:getValue( SettingsModel.SETTING.TERRAIN_LOD_DISTANCE)])
            end
        end
    end

```

### setSeparateCameraPose

**Description**

> Set separate camera pose

**Definition**

> setSeparateCameraPose()

**Code**

```lua
function VehicleCamera:setSeparateCameraPose()
    if self.rotateNode ~ = self.cameraPositionNode then
        local dx = self.position[ 1 ] - self.lookAtPosition[ 1 ]
        local dy = self.position[ 2 ] - self.lookAtPosition[ 2 ]
        local dz = self.position[ 3 ] - self.lookAtPosition[ 3 ]

        local wdx, wdz = MathUtil.vector2Normalize(dx, dz)
        setDirection( self.cameraWorldParent, wdx, 0 , wdz, 0 , 1 , 0 )

        local upx, upy, upz = unpack( self.upVector)
        if upx = = 0 and upy = = 0 and upz = = 0 then
            upy = 1
        end

        if math.abs(dx) < 0.001 and math.abs(dz) < 0.001 then
            upx = 0.1
        end

        dx,dy,dz = MathUtil.vector3Normalize(dx,dy,dz)
        upx,upy,upz = MathUtil.vector3Normalize(upx,upy,upz)

        setWorldDirection( self.cameraNode, dx, dy, dz, upx, upy, upz)
    else
            local dx, dy, dz = localDirectionToWorld( self.rotateNode, 0 , 0 , 1 )
            local upx, upy, upz = localDirectionToWorld( self.rotateNode, self:getTiltDirectionOffset(), 1 , 0 )
            setWorldDirection( self.cameraNode, dx, dy, dz, upx, upy, upz)
        end
        setWorldTranslation( self.cameraNode, self.position[ 1 ], self.position[ 2 ], self.position[ 3 ])

        if self.lodDebugMode then
            local _, _ , curZoom = localToLocal( self.cameraNode, self.rotateNode, 0 , 0 , 0 )
            local l = math.atan( self.fovY) * self.loadDebugZoom
            local mouseButtonLast, mouseButtonStateLast = g_inputBinding:getMouseButtonState()
            if mouseButtonStateLast and mouseButtonLast = = Input.MOUSE_BUTTON_MIDDLE then
                setFovY( self.cameraNode, self.fovY)
            else
                    setFovY( self.cameraNode, math.tan(l / math.max(curZoom, l)))
                end
                setTextAlignment(RenderText.ALIGN_CENTER)
                renderText( 0.5 , 0.1 , 0.04 , string.format( "Distance: %d" , self.zoom))
                setTextAlignment(RenderText.ALIGN_LEFT)
            end
        end

```

### touchEventLookLeftRight

**Description**

**Definition**

> touchEventLookLeftRight()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function VehicleCamera:touchEventLookLeftRight(value)
    if self.isActivated then
        local factor = (g_screenAspectRatio) * 75
        VehicleCamera.actionEventLookLeftRight( self , nil , value * factor, nil , nil , false )
    end
end

```

### touchEventLookUpDown

**Description**

**Definition**

> touchEventLookUpDown()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function VehicleCamera:touchEventLookUpDown(value)
    if self.isActivated then
        local factor = (g_screenHeight * g_pixelSizeX) * - 75
        VehicleCamera.actionEventLookUpDown( self , nil , value * factor, nil , nil , false )
    end
end

```

### touchEventZoomInOut

**Description**

**Definition**

> touchEventZoomInOut()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function VehicleCamera:touchEventZoomInOut(value)
    if self.isActivated then
        self:zoomSmoothly(value * 15 )
    end
end

```

### update

**Description**

> Update

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function VehicleCamera:update(dt)
    --#profile RemoteProfiler.zoneBeginN("VehicleCamera:update")

    local target = self.zoomTarget
    if self.zoomLimitedTarget > = 0 then
        target = math.min( self.zoomLimitedTarget, self.zoomTarget)
    end
    self.zoom = target + ( math.pow( 0.99579 , dt) * ( self.zoom - target) )

    --#debug if Input.isKeyPressed(Input.KEY_lalt) then
        --#debug if self.origLimit = = nil then
            --#debug self.origLimit = self.limit
            --#debug end
            --#debug self.limit = false
            --#debug elseif self.lastInputValues.upDown ~ = 0 then
                --#debug if self.origLimit ~ = nil then
                    --#debug self.limit = self.origLimit
                    --#debug end
                    --#debug end

                    if self.lastInputValues.upDown ~ = 0 then
                        local value = self.lastInputValues.upDown * g_gameSettings:getValue(GameSettings.SETTING.CAMERA_SENSITIVITY)
                        self.lastInputValues.upDown = 0
                        value = g_gameSettings:getValue(GameSettings.SETTING.INVERT_Y_LOOK) and - value or value

                        if self.isRotatable then
                            if self.isActivated and not g_gui:getIsGuiVisible() then
                                if self.limitRotXDelta > 0.001 then
                                    self.rotX = math.min( self.rotX - value, self.rotX)
                                elseif self.limitRotXDelta < - 0.001 then
                                        self.rotX = math.max( self.rotX - value, self.rotX)
                                    else
                                            self.rotX = self.rotX - value
                                        end

                                        if self.limit then
                                            self.rotX = math.min( self.rotMaxX, math.max( self.rotMinX, self.rotX))
                                        end
                                    end
                                end
                            end

                            if self.lastInputValues.leftRight ~ = 0 or self.autoRotateOverride then
                                local value = self.autoRotateOverride or( self.lastInputValues.leftRight * g_gameSettings:getValue(GameSettings.SETTING.CAMERA_SENSITIVITY))
                                self.lastInputValues.leftRight = 0

                                if self.isRotatable then
                                    if self.isActivated and not g_gui:getIsGuiVisible() then
                                        self.rotY = self.rotY - value
                                    end
                                end
                            end

                            --
                            if g_gameSettings:getValue(GameSettings.SETTING.IS_HEAD_TRACKING_ENABLED) and isHeadTrackingAvailable() and self.allowHeadTracking and self.headTrackingNode ~ = nil then
                                local tx,ty,tz = getHeadTrackingTranslation()
                                local pitch,yaw,roll = getHeadTrackingRotation()
                                if pitch ~ = nil then
                                    local camParent = getParent( self.cameraNode)
                                    local ctx,cty,ctz
                                    local crx,cry,crz
                                    if camParent ~ = 0 then
                                        ctx, cty, ctz = localToLocal( self.headTrackingNode, camParent, tx, ty, tz)
                                        crx, cry, crz = localRotationToLocal( self.headTrackingNode, camParent, pitch,yaw,roll)
                                    else
                                            ctx, cty, ctz = localToWorld( self.headTrackingNode, tx, ty, tz)
                                            crx, cry, crz = localRotationToWorld( self.headTrackingNode, pitch,yaw,roll)
                                        end

                                        setRotation( self.cameraNode, crx, cry, crz)
                                        setTranslation( self.cameraNode, ctx, cty, ctz)
                                    end
                                else
                                        self:updateRotateNodeRotation()

                                        if self.limit then
                                            -- adjust rotation to avoid clipping with terrain
                                            if self.isRotatable and(( self.useWorldXZRotation = = nil and g_gameSettings:getValue(GameSettings.SETTING.USE_WORLD_CAMERA)) or self.useWorldXZRotation) then
                                                local numIterations = 4
                                                for _ = 1 , numIterations do
                                                    local transX, transY, transZ = self.transDirX * self.zoom, self.transDirY * self.zoom, self.transDirZ * self.zoom
                                                    local x,y,z = localToWorld(getParent( self.cameraPositionNode), transX, transY, transZ)

                                                    local terrainHeight = DensityMapHeightUtil.getHeightAtWorldPos(x, 0 ,z)

                                                    local minHeight = terrainHeight + 0.9
                                                    if y < minHeight then
                                                        local h = math.sin( self.rotX) * self.zoom
                                                        local h2 = h - (minHeight - y)
                                                        self.rotX = math.asin( math.clamp(h2 / self.zoom, - 1 , 1 ))
                                                        self:updateRotateNodeRotation()
                                                    else
                                                            break
                                                        end
                                                    end
                                                end

                                                -- adjust zoom to avoid collision with objects
                                                if self.allowTranslation then

                                                    self.limitRotXDelta = 0
                                                    local hasCollision, collisionDistance, nx,ny,nz, normalDotDir = self:getCollisionDistance()
                                                    if hasCollision then
                                                        local distOffset = 0.1
                                                        if normalDotDir ~ = nil then
                                                            local absNormalDotDir = math.abs(normalDotDir)
                                                            distOffset = MathUtil.lerp( 1.2 , 0.1 , absNormalDotDir * absNormalDotDir * ( 3 - 2 * absNormalDotDir))
                                                        end
                                                        collisionDistance = math.max(collisionDistance - distOffset, 0.01 )
                                                        self.disableCollisionTime = g_currentMission.time + 400
                                                        self.zoomLimitedTarget = collisionDistance
                                                        if collisionDistance < self.zoom then
                                                            self.zoom = collisionDistance
                                                        end
                                                        if self.isRotatable and nx ~ = nil and collisionDistance < self.transMin then
                                                            local _,lny,_ = worldDirectionToLocal( self.rotateNode, nx,ny,nz)
                                                            if lny > 0.5 then
                                                                self.limitRotXDelta = 1
                                                            elseif lny < - 0.5 then
                                                                    self.limitRotXDelta = - 1
                                                                end
                                                            end
                                                        else
                                                                if self.disableCollisionTime < = g_currentMission.time then
                                                                    self.zoomLimitedTarget = - 1
                                                                end
                                                            end
                                                        end

                                                    end
                                                    self.transX, self.transY, self.transZ = self.transDirX * self.zoom, self.transDirY * self.zoom, self.transDirZ * self.zoom
                                                    setTranslation( self.cameraPositionNode, self.transX, self.transY, self.transZ)

                                                    if self.positionSmoothingParameter > 0 then

                                                        local interpDt = g_physicsDt

                                                        if self.vehicle.spec_rideable ~ = nil then
                                                            interpDt = self.vehicle.spec_rideable.interpolationDt
                                                        end

                                                        if g_server = = nil then
                                                            -- on clients, we interpolate the vehicles with dt, thus we need to use the same for camera interpolation
                                                                interpDt = dt
                                                            end
                                                            if interpDt > 0 then
                                                                local xlook,ylook,zlook = getWorldTranslation( self.rotateNode)
                                                                local lookAtPos = self.lookAtPosition
                                                                local lookAtLastPos = self.lookAtLastTargetPosition
                                                                lookAtPos[ 1 ],lookAtPos[ 2 ],lookAtPos[ 3 ] = self:getSmoothed( self.lookAtSmoothingParameter, lookAtPos[ 1 ],lookAtPos[ 2 ],lookAtPos[ 3 ], xlook,ylook,zlook, lookAtLastPos[ 1 ],lookAtLastPos[ 2 ],lookAtLastPos[ 3 ], interpDt)
                                                                lookAtLastPos[ 1 ],lookAtLastPos[ 2 ],lookAtLastPos[ 3 ] = xlook,ylook,zlook

                                                                local x,y,z = getWorldTranslation( self.cameraPositionNode)
                                                                local pos = self.position
                                                                local lastPos = self.lastTargetPosition
                                                                pos[ 1 ],pos[ 2 ],pos[ 3 ] = self:getSmoothed( self.positionSmoothingParameter, pos[ 1 ],pos[ 2 ],pos[ 3 ], x,y,z, lastPos[ 1 ],lastPos[ 2 ],lastPos[ 3 ], interpDt)
                                                                lastPos[ 1 ],lastPos[ 2 ],lastPos[ 3 ] = x,y,z

                                                                local upx, upy, upz = localDirectionToWorld( self.rotateNode, self:getTiltDirectionOffset(), 1 , 0 )
                                                                local up = self.upVector
                                                                local lastUp = self.lastUpVector
                                                                up[ 1 ],up[ 2 ],up[ 3 ] = self:getSmoothed( self.positionSmoothingParameter, up[ 1 ],up[ 2 ],up[ 3 ], upx, upy, upz, lastUp[ 1 ],lastUp[ 2 ],lastUp[ 3 ], interpDt)
                                                                lastUp[ 1 ],lastUp[ 2 ],lastUp[ 3 ] = upx, upy, upz

                                                                self:setSeparateCameraPose()
                                                            end
                                                        end
                                                    end

                                                    if MathUtil.isNan( self.rotX) or MathUtil.isNan( self.rotY) or MathUtil.isNan( self.rotZ) then
                                                        self:resetCamera()
                                                    end

                                                    --#debug if self.cameraYDebugMode then
                                                        --#debug setTextAlignment(RenderText.ALIGN_CENTER)
                                                        --#debug setTextBold(true)
                                                        --#debug
                                                        --#debug local x, y, z = getTranslation(self.rotateNode)
                                                        --#debug local text = string.format("Camera Position: %.2f %.2f %.2f", x, y, z)
                                                        --#debug
                                                        --#debug setTextColor(0, 0, 0, 1)
                                                        --#debug renderText(0.5, 0.01, 0.025, text)
                                                        --#debug
                                                        --#debug setTextColor(1, 1, 1, 1)
                                                        --#debug renderText(0.499, 0.012, 0.025, text)
                                                        --#debug
                                                        --#debug setTextAlignment(RenderText.ALIGN_LEFT)
                                                        --#debug setTextBold(false)
                                                        --#debug end

                                                        --#profile RemoteProfiler.zoneEnd()
                                                    end

```

### updateRotateNodeRotation

**Description**

> Update rotation node rotation

**Definition**

> updateRotateNodeRotation()

**Code**

```lua
function VehicleCamera:updateRotateNodeRotation()

    local rotY = self.rotY
    if self.rotYSteeringRotSpeed ~ = nil and self.rotYSteeringRotSpeed ~ = 0 and self.vehicle.spec_articulatedAxis ~ = nil and self.vehicle.spec_articulatedAxis.interpolatedRotatedTime ~ = nil then
        rotY = rotY + self.vehicle.spec_articulatedAxis.interpolatedRotatedTime * self.rotYSteeringRotSpeed
    end

    if ( self.useWorldXZRotation = = nil and g_gameSettings:getValue(GameSettings.SETTING.USE_WORLD_CAMERA)) or self.useWorldXZRotation then

        local vehicleDirectionX, _, vehicleDirectionZ = localDirectionToWorld(getParent( self.rotateNode), 0 , 0 , 1 )
        vehicleDirectionX, vehicleDirectionZ = MathUtil.vector2Normalize(vehicleDirectionX, vehicleDirectionZ)

        local newDx = math.cos( self.rotX) * ( math.cos(rotY) * vehicleDirectionX + math.sin(rotY) * vehicleDirectionZ)
        local newDy = - math.sin( self.rotX)
        local newDz = math.cos( self.rotX) * ( - math.sin(rotY) * vehicleDirectionX + math.cos(rotY) * vehicleDirectionZ)

        newDx,newDy,newDz = worldDirectionToLocal(getParent( self.rotateNode), newDx,newDy,newDz)
        local upx,upy,upz = worldDirectionToLocal(getParent( self.rotateNode), 0 , 1 , 0 )

        -- worst case check
        if math.abs( MathUtil.dotProduct(newDx,newDy,newDz, upx,upy,upz)) > ( 0.99 * MathUtil.vector3Length(newDx,newDy,newDz) * MathUtil.vector3Length(upx,upy,upz) ) then
            setRotation( self.rotateNode, self.rotX, rotY, self.rotZ)
        else
                setDirection( self.rotateNode, newDx,newDy,newDz, upx,upy,upz)
            end
        else
                setRotation( self.rotateNode, self.rotX, rotY, self.rotZ)
            end
        end

```

### zoomSmoothly

**Description**

> Zoom camera smoothly

**Definition**

> zoomSmoothly(float offset)

**Arguments**

| float | offset | offset |
|-------|--------|--------|

**Code**

```lua
function VehicleCamera:zoomSmoothly(offset)
    local transMin, transMax = self.transMin, self.transMax
    --#debug if Input.isKeyPressed(Input.KEY_lalt) then
        --#debug offset = offset * 0.1
        --#debug transMin, transMax = 0, 100
        --#debug end

        if self.lodDebugMode then
            offset = offset * 10
        end

        local zoomTarget = self.zoomTarget
        if transMin ~ = nil and transMax ~ = nil and transMin ~ = transMax then
            zoomTarget = math.min(transMax, math.max(transMin, self.zoomTarget + offset))
        end
        self.zoomTarget = zoomTarget

        --#debug if self.cameraYDebugMode then
            --#debug setOrthographicHeight(self.cameraNode, getOrthographicHeight(self.cameraNode) + offset * 0.1)
            --#debug end
        end

```