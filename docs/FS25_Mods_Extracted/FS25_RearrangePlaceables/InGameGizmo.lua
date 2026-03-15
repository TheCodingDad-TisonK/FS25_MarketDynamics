InGameGizmo = {}
InGameGizmo.ModDirectory = g_currentModDirectory
InGameGizmo.ModName = g_currentModName

source(g_currentModDirectory.."RearrangePlaceableEvent.lua");


function InGameGizmo:ConstructionBrushUpdate()
    if self.cursor ~= nil then InGameGizmo.cursor = self.cursor; end

    if InGameGizmo.cursor.mousePosX == nil then return end;
    if InGameGizmo.cursor.mousePosY == nil then return end;
    if InGameGizmo.ConstructionScreen.camera.camera == nil then return end;
    if InGameGizmo.cursor.rayCollisionMask == nil then return end;

    local HitID, HitX, HitY, HitZ = InGameGizmo:GetRay(CollisionFlag.ANIMAL_POSITIONING)

    if InGameGizmo.LastHit == nil and InGameGizmo.AxisModifier and InGameGizmo.CurrentPlaceable and InGameGizmo.GizmoNode then
        if HitID ~= nil then
            InGameGizmo.LastHit = {
                x = HitX,
                y = HitY,
                z = HitZ
            }
        end
        return;
    end
    
    if InGameGizmo.AxisModifier and InGameGizmo.LastHit and InGameGizmo.CurrentPlaceable and InGameGizmo.GizmoNode then
        if HitX == nil then return; end;
        if HitY == nil then return; end;
        if HitZ == nil then return; end;

        if HitID == nil then return; end;

        local HitName = getName(HitID)

        if InGameGizmo.PlaneXzNode == nil then return end;

        InGameGizmo.EmptyModifer = 1;

        local MoveDistance = { 
            x =  (HitX - InGameGizmo.LastHit.x) * InGameGizmo.AxisModifier.x,
            y =  (HitY - InGameGizmo.LastHit.y) * InGameGizmo.AxisModifier.y,
            z =  (HitZ - InGameGizmo.LastHit.z) * InGameGizmo.AxisModifier.z
        }

        InGameGizmo.LastHit = {
            x = HitX,
            y = HitY,
            z = HitZ
        }

        if InGameGizmo.Rotate then 
            local x, y, z = getWorldRotation(InGameGizmo.CurrentPlaceable.rootNode)

            x = x + (MoveDistance.x*InGameGizmo.EmptyModifer/6)*InGameGizmo.EmptyModifer;
            y = y + (MoveDistance.y*InGameGizmo.EmptyModifer/6)*InGameGizmo.EmptyModifer;
            z = z + (MoveDistance.z*InGameGizmo.EmptyModifer/6)*InGameGizmo.EmptyModifer;

            removeFromPhysics(InGameGizmo.CurrentPlaceable.rootNode)
            setWorldRotation(InGameGizmo.CurrentPlaceable.rootNode, x, y, z)
            addToPhysics(InGameGizmo.CurrentPlaceable.rootNode)
        else
            local x, y, z = getWorldTranslation(InGameGizmo.CurrentPlaceable.rootNode)

            x = x + MoveDistance.x*InGameGizmo.EmptyModifer;
            y = y + MoveDistance.y*InGameGizmo.EmptyModifer;
            z = z + MoveDistance.z*InGameGizmo.EmptyModifer;

            
            removeFromPhysics(InGameGizmo.CurrentPlaceable.rootNode)
            setTranslation(InGameGizmo.CurrentPlaceable.rootNode, x, y, z);
            addToPhysics(InGameGizmo.CurrentPlaceable.rootNode)
        end

        local x, y, z = getWorldTranslation(InGameGizmo.CurrentPlaceable.rootNode)

        removeFromPhysics(InGameGizmo.GizmoNode)
        setTranslation(InGameGizmo.GizmoNode, x, y, z);
        addToPhysics(InGameGizmo.GizmoNode)
    end
end

function InGameGizmo:GetRay(CollisionFlagMask)
    local X, Y, Z, Dx, Dy, Dz = RaycastUtil.getCameraPickingRay(InGameGizmo.cursor.mousePosX, InGameGizmo.cursor.mousePosY, InGameGizmo.ConstructionScreen.camera.camera)
    return RaycastUtil.raycastClosest(X, Y, Z, Dx, Dy, Dz, GuiTopDownCursor.RAYCAST_DISTANCE, CollisionFlagMask)
end

function InGameGizmo:MouseDown(Button)

    if Button ~= 1 and Button ~= 3 then
        return;
    end
  
    if InGameGizmo.cursor.mousePosX == nil then return end;
    if InGameGizmo.cursor.mousePosY == nil then return end;
    if InGameGizmo.ConstructionScreen.camera.camera == nil then return end;
    if InGameGizmo.cursor.rayCollisionMask == nil then return end;

    setRigidBodyType(InGameGizmo.PlaneXzNode, RigidBodyType.NONE)
    setRigidBodyType(InGameGizmo.PlaneY1, RigidBodyType.NONE)
    setRigidBodyType(InGameGizmo.PlaneY2, RigidBodyType.NONE)
    setRigidBodyType(InGameGizmo.PlaneY3, RigidBodyType.NONE)
    setRigidBodyType(InGameGizmo.PlaneY4, RigidBodyType.NONE)

    local HitID, HitX, HitY, HitZ = InGameGizmo:GetRay(CollisionFlag.PLACEMENT_BLOCKING)

    if HitID == nil then return; end
    local HitName = getName(HitID)

    if InGameGizmo.PlaneXzNode == nil then return end;

    if HitName == "GizmoX" then
        InGameGizmo.AxisModifier = {x = 1, y = 0, z = 0};

        setRigidBodyType(InGameGizmo.PlaneXzNode, RigidBodyType.STATIC)
    end 

    if HitName == "GizmoY" then
        InGameGizmo.AxisModifier = {x = 0, y = 1, z = 0};


        setRigidBodyType(InGameGizmo.PlaneY1, RigidBodyType.STATIC)
        setRigidBodyType(InGameGizmo.PlaneY2, RigidBodyType.STATIC)
        setRigidBodyType(InGameGizmo.PlaneY3, RigidBodyType.STATIC)
        setRigidBodyType(InGameGizmo.PlaneY4, RigidBodyType.STATIC)

        local CamToPlaneDistance = math.huge;
        local NodeToHide = nil;

        local Idist1 = calcDistanceFrom(InGameGizmo.ConstructionScreen.camera.camera, InGameGizmo.PlaneY1)
        if Idist1 < CamToPlaneDistance then
            CamToPlaneDistance = Idist1
            NodeToHide = InGameGizmo.PlaneY1
        end

        local Idist2 = calcDistanceFrom(InGameGizmo.ConstructionScreen.camera.camera, InGameGizmo.PlaneY2)
        if Idist2 < CamToPlaneDistance then
            CamToPlaneDistance = Idist2
            NodeToHide = InGameGizmo.PlaneY2
        end

        local Idist3 = calcDistanceFrom(InGameGizmo.ConstructionScreen.camera.camera, InGameGizmo.PlaneY3)
        if Idist3 < CamToPlaneDistance then
            CamToPlaneDistance = Idist3
            NodeToHide = InGameGizmo.PlaneY3
        end

        local Idist4 = calcDistanceFrom(InGameGizmo.ConstructionScreen.camera.camera, InGameGizmo.PlaneY4)
        if Idist4 < CamToPlaneDistance then
            CamToPlaneDistance = Idist4
            NodeToHide = InGameGizmo.PlaneY4
        end

        setRigidBodyType(NodeToHide, RigidBodyType.NONE)
    end

    if HitName == "GizmoZ" then
        InGameGizmo.AxisModifier = {x = 0, y = 0, z = 1};
        setRigidBodyType(InGameGizmo.PlaneXzNode, RigidBodyType.STATIC)
    end

    if InGameGizmo.AxisModifier == nil then return; end;   

    InGameGizmo.Rotate = Button == 3;
end

function InGameGizmo:MouseUp() 
    InGameGizmo.AxisModifier = nil;
    InGameGizmo.LastHit = nil;

    InGameGizmo.LastHitPlane = nil;
end

function InGameGizmo:MouseEvent(posX, posY, isDown, isUp, button, eventUsed) 
    
    InGameGizmo.ConstructionScreen = self;

    if InGameGizmo.CurrentPlaceable == nil then return nil end;
    --if button == 4 or button == 0 or button == 2 or button == 5 then return end

    if isDown then
        InGameGizmo:MouseDown(button);
    end

    if isUp then
        InGameGizmo:MouseUp();
    end
end

function InGameGizmo:Deactivate()
    if InGameGizmo.ConstructionScreen ~= nil then
        g_inputBinding:setActionEventText(InGameGizmo.ConstructionScreen.backButtonEvent, g_i18n:getText("input_CONSTRUCTION_EXIT"));
    end

    if InGameGizmo.GizmoNode ~= nil then
        removeFromPhysics(InGameGizmo.GizmoNode)   
        setTranslation(InGameGizmo.GizmoNode, 0,-1000,0);
        setVisibility(InGameGizmo.GizmoNode, false);
        addToPhysics(InGameGizmo.GizmoNode)
    end

    InGameGizmo.LastPlaceable = InGameGizmo.CurrentPlaceable;
    InGameGizmo.CurrentPlaceable = nil;
    InGameGizmo.AxisModifier = nil;
    InGameGizmo.LastHit = nil;

    if InGameGizmo.StartPosition == nil then return end;
    if InGameGizmo.StartRotation == nil then return end;
    if InGameGizmo.LastPlaceable == nil then return end;

    InGameGizmo.WaitFrames = 5;
end

function InGameGizmo:ConfirmPlacemnet(Price)

    local x, y, z = getWorldTranslation(InGameGizmo.LastPlaceable.rootNode)
    local a, b, c = getWorldRotation(InGameGizmo.LastPlaceable.rootNode)

    RearrangePlaceableEvent.new(InGameGizmo.LastPlaceable, x, y, z, a, b, c, Price):sendEvent();

    InGameGizmo.LastPlaceable = nil;
    InGameGizmo.StartPosition = nil;
    InGameGizmo.StartRotation = nil;

end

function InGameGizmo:CancelPlacemnet()
    removeFromPhysics(InGameGizmo.LastPlaceable.rootNode)
    setTranslation(InGameGizmo.LastPlaceable.rootNode, InGameGizmo.StartPosition.X, InGameGizmo.StartPosition.Y, InGameGizmo.StartPosition.Z);
    setWorldRotation(InGameGizmo.LastPlaceable.rootNode, InGameGizmo.StartRotation.X, InGameGizmo.StartRotation.Y, InGameGizmo.StartRotation.Z);
    addToPhysics(InGameGizmo.LastPlaceable.rootNode)


    InGameGizmo.LastPlaceable = nil;
    InGameGizmo.StartPosition = nil;
    InGameGizmo.StartRotation = nil;
end

function InGameGizmo:PlaceableSelected(CurrentPlaceable)
    g_inputBinding:setActionEventText(InGameGizmo.ConstructionScreen.backButtonEvent, g_i18n:getText("button_back"));

    InGameGizmo.CurrentPlaceable = CurrentPlaceable;

    if InGameGizmo.GizmoNode == nil then
        InGameGizmo.GizmoNode = loadI3DFile(InGameGizmo.ModDirectory .."Gizmos.i3d");
        
        if InGameGizmo.GizmoNode then        
            link(getRootNode(), InGameGizmo.GizmoNode) 
            
            InGameGizmo.PlaneXzNode = getChildAt(getChildAt(InGameGizmo.GizmoNode, 0), 7)
            
            InGameGizmo.PlaneY1 = getChildAt(getChildAt(InGameGizmo.GizmoNode, 0), 6)
            InGameGizmo.PlaneY2 = getChildAt(getChildAt(InGameGizmo.GizmoNode, 0), 5)
            InGameGizmo.PlaneY3 = getChildAt(getChildAt(InGameGizmo.GizmoNode, 0), 4)
            InGameGizmo.PlaneY4 = getChildAt(getChildAt(InGameGizmo.GizmoNode, 0), 3)
        end
    end



    local x, y, z = getWorldTranslation(CurrentPlaceable.rootNode)
    InGameGizmo.StartPosition = {X = x, Y = y, Z = z}

    removeFromPhysics(InGameGizmo.GizmoNode)
    setTranslation(InGameGizmo.GizmoNode, x, y, z);
    setVisibility(InGameGizmo.GizmoNode, true);
    addToPhysics(InGameGizmo.GizmoNode)

    local a, b, c = getWorldRotation(CurrentPlaceable.rootNode)
    InGameGizmo.StartRotation = {X = a, Y = b, Z = c}
end

function InGameGizmo:ClickButton() 
    InGameGizmo:PlaceableSelected(self.placeable);
    self:onClickBack()
end

function InGameGizmo:InsertMoveButton() 
    InGameGizmo:Deactivate()

    if self.MoveButton ~=nil then return; end;

    local function createBtn(prefab, text, callback)
		local btn = prefab:clone(prefab.parent)
		btn:setText(text)
		btn:setVisible(false)
		btn:setCallback("onClickCallback", callback)
        btn:setInputAction(InputAction.MENU_EXTRA_1)
		btn.parent:invalidateLayout()
		return btn
	end

    self.MoveButton = createBtn(self.renameButton, g_i18n:getText("button_move"), "onClickMove");
    self.MoveButton:setVisible(true)
end

function InGameGizmo:ButtonMenuBack(OldFunc, ...) 
    if InGameGizmo.CurrentPlaceable ~= nil then InGameGizmo:Deactivate(); return; end
    return OldFunc(self,...);
end

function InGameGizmo:update()	
    if InGameGizmo.WaitFrames == nil then return; end;

    if InGameGizmo.WaitFrames > 0 then 
        InGameGizmo.WaitFrames = InGameGizmo.WaitFrames - 1;
    end

    InGameGizmo.WaitFrames = nil;

    if InGameGizmo.LastPlaceable == nil then return; end;
    if InGameGizmo.StartPosition == nil then return; end;
    if InGameGizmo.StartRotation == nil then return; end;

    

    local x, y, z = getWorldTranslation(InGameGizmo.LastPlaceable.rootNode)
    local distanceX = math.abs(x - InGameGizmo.StartPosition.X);
    local distanceY = math.abs(y - InGameGizmo.StartPosition.Y);
    local distanceZ = math.abs(z - InGameGizmo.StartPosition.Z);
    local totalDistance = math.sqrt(distanceX^2 + distanceY^2 + distanceZ^2);

    local x, y, z = getWorldRotation(InGameGizmo.LastPlaceable.rootNode)

    if totalDistance < 0.05 and x == InGameGizmo.StartRotation.X and y == InGameGizmo.StartRotation.Y and z == InGameGizmo.StartRotation.Z then
        InGameGizmo.LastPlaceable = nil;
        InGameGizmo.StartPosition = nil;
        InGameGizmo.StartRotation = nil;

        return;
    end;

    local price = (totalDistance/50) * 1000;

    local args = {
        text = g_i18n:getText("ui_totalPrice").." "..g_i18n:formatMoney(price, 0, true, true),
        title = g_i18n:getText("ui_saveChanges"),
        callback = function(yes)
            if yes then
                InGameGizmo:ConfirmPlacemnet(price);
            else
                InGameGizmo:CancelPlacemnet();
            end        
        end
    }

    local dialog = g_gui:showDialog("YesNoDialog")
    dialog.target:setText(args.text)
    dialog.target:setTitle(args.title)
    dialog.target:setDialogType(Utils.getNoNil(args.dialogType, DialogElement.TYPE_QUESTION))
    dialog.target:setCallback(args.callback, args.target, args.args)
    dialog.target:setButtonTexts(args.yesText, args.noText)
    dialog.target:setButtonSounds(args.yesSound, args.noSound)
end;

PlaceableInfoDialog.onClickMove = Utils.prependedFunction(PlaceableInfoDialog.onClickMove, InGameGizmo.ClickButton);
PlaceableInfoDialog.setPlaceable = Utils.prependedFunction(PlaceableInfoDialog.setPlaceable, InGameGizmo.InsertMoveButton);

ConstructionScreen.mouseEvent = Utils.prependedFunction(ConstructionScreen.mouseEvent, InGameGizmo.MouseEvent);
ConstructionScreen.onButtonMenuBack = Utils.overwrittenFunction(ConstructionScreen.onButtonMenuBack, InGameGizmo.ButtonMenuBack);

ConstructionScreen.setBrush = Utils.appendedFunction(ConstructionScreen.setBrush, InGameGizmo.Deactivate);

ConstructionBrushSelect.update = Utils.prependedFunction(ConstructionBrushSelect.update, InGameGizmo.ConstructionBrushUpdate);

addModEventListener(InGameGizmo);
