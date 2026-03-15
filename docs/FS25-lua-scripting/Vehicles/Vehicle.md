## Vehicle

**Description**

> This class handles all basic functionality of a vehicle
> - loading of i3d
> - syncing of components
> - handling of specializations

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [actionEventToggleSelection](#actioneventtoggleselection)
- [actionEventToggleSelectionReverse](#actioneventtoggleselectionreverse)
- [activate](#activate)
- [addChildVehicles](#addchildvehicles)
- [addSubselection](#addsubselection)
- [addToPhysics](#addtophysics)
- [addVehicleToAIImplementList](#addvehicletoaiimplementlist)
- [calculateDailyUpkeep](#calculatedailyupkeep)
- [calculateSellPrice](#calculatesellprice)
- [clearDirtyMask](#cleardirtymask)
- [clearSubselections](#clearsubselections)
- [createComponentJoint](#createcomponentjoint)
- [createLoadingTask](#createloadingtask)
- [createMapHotspot](#createmaphotspot)
- [dayChanged](#daychanged)
- [deactivate](#deactivate)
- [delete](#delete)
- [deleteMapHotspot](#deletemaphotspot)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [doCollisionMaskCheck](#docollisionmaskcheck)
- [draw](#draw)
- [drawUIInfo](#drawuiinfo)
- [findRootVehicle](#findrootvehicle)
- [finishLoadingTask](#finishloadingtask)
- [getActionControllerDirection](#getactioncontrollerdirection)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getAdditionalSchemaText](#getadditionalschematext)
- [getAreControlledActionsAccessible](#getarecontrolledactionsaccessible)
- [getAreControlledActionsAllowed](#getarecontrolledactionsallowed)
- [getAreControlledActionsAvailable](#getarecontrolledactionsavailable)
- [getAvailableComponentMass](#getavailablecomponentmass)
- [getBlockSelection](#getblockselection)
- [getBrand](#getbrand)
- [getCanBeAddedToSales](#getcanbeaddedtosales)
- [getCanBeMounted](#getcanbemounted)
- [getCanBePickedUp](#getcanbepickedup)
- [getCanBeReset](#getcanbereset)
- [getCanBeSelected](#getcanbeselected)
- [getCanBeSold](#getcanbesold)
- [getCanToggleSelectable](#getcantoggleselectable)
- [getChildVehicleHash](#getchildvehiclehash)
- [getChildVehicles](#getchildvehicles)
- [getComponentMass](#getcomponentmass)
- [getControlledActionIcons](#getcontrolledactionicons)
- [getDailyUpkeep](#getdailyupkeep)
- [getDeactivateOnLeave](#getdeactivateonleave)
- [getDefaultMass](#getdefaultmass)
- [getDistanceToNode](#getdistancetonode)
- [getFillLevelInformation](#getfilllevelinformation)
- [getFullName](#getfullname)
- [getHasObjectMounted](#gethasobjectmounted)
- [getImageFilename](#getimagefilename)
- [getInteractionHelp](#getinteractionhelp)
- [getIsActive](#getisactive)
- [getIsActiveForInput](#getisactiveforinput)
- [getIsActiveForSound](#getisactiveforsound)
- [getIsAIActive](#getisaiactive)
- [getIsAutomaticShiftingAllowed](#getisautomaticshiftingallowed)
- [getIsInShowroom](#getisinshowroom)
- [getIsInUse](#getisinuse)
- [getIsLowered](#getislowered)
- [getIsMapHotspotVisible](#getismaphotspotvisible)
- [getIsNodeActive](#getisnodeactive)
- [getIsOnField](#getisonfield)
- [getIsOperating](#getisoperating)
- [getIsPowered](#getispowered)
- [getIsReadyForAutomatedTrainTravel](#getisreadyforautomatedtraintravel)
- [getIsSelected](#getisselected)
- [getIsSynchronized](#getissynchronized)
- [getIsVehicleNode](#getisvehiclenode)
- [getLastSpeed](#getlastspeed)
- [getLimitedVehicleYPosition](#getlimitedvehicleyposition)
- [getMapHotspot](#getmaphotspot)
- [getMaxComponentMassReached](#getmaxcomponentmassreached)
- [getName](#getname)
- [getNeedsSaving](#getneedssaving)
- [getOperatingTime](#getoperatingtime)
- [getOverallCenterOfMass](#getoverallcenterofmass)
- [getParentComponent](#getparentcomponent)
- [getPrice](#getprice)
- [getPropertyState](#getpropertystate)
- [getRawSpeedLimit](#getrawspeedlimit)
- [getReloadXML](#getreloadxml)
- [getRepaintPrice](#getrepaintprice)
- [getRepairPrice](#getrepairprice)
- [getRequiresPower](#getrequirespower)
- [getResetPlaces](#getresetplaces)
- [getRootVehicle](#getrootvehicle)
- [getSelectedObject](#getselectedobject)
- [getSelectedVehicle](#getselectedvehicle)
- [getSellPrice](#getsellprice)
- [getShowInVehiclesOverview](#getshowinvehiclesoverview)
- [getSpecConfigValuesWeight](#getspecconfigvaluesweight)
- [getSpecValueAdditionalWeight](#getspecvalueadditionalweight)
- [getSpecValueCombinations](#getspecvaluecombinations)
- [getSpecValueDailyUpkeep](#getspecvaluedailyupkeep)
- [getSpecValueOperatingTime](#getspecvalueoperatingtime)
- [getSpecValueSlots](#getspecvalueslots)
- [getSpecValueSpeedLimit](#getspecvaluespeedlimit)
- [getSpecValueWeight](#getspecvalueweight)
- [getSpecValueWorkingWidth](#getspecvalueworkingwidth)
- [getSpecValueWorkingWidthConfig](#getspecvalueworkingwidthconfig)
- [getSpeedLimit](#getspeedlimit)
- [getTotalMass](#gettotalmass)
- [getUniqueId](#getuniqueid)
- [getUppercaseName](#getuppercasename)
- [getUseTurnedOnSchema](#getuseturnedonschema)
- [getVehicleDamage](#getvehicledamage)
- [getVehicleWorldDirection](#getvehicleworlddirection)
- [getVehicleWorldXRot](#getvehicleworldxrot)
- [getWorkLoad](#getworkload)
- [hasInputConflictWithSelection](#hasinputconflictwithselection)
- [i3dFileLoaded](#i3dfileloaded)
- [init](#init)
- [interact](#interact)
- [load](#load)
- [loadCallback](#loadcallback)
- [loadComponentFromXML](#loadcomponentfromxml)
- [loadComponentJointFromXML](#loadcomponentjointfromxml)
- [loadFinished](#loadfinished)
- [loadObjectChangeValuesFromXML](#loadobjectchangevaluesfromxml)
- [loadSchemaOverlay](#loadschemaoverlay)
- [loadSpecValueAdditionalWeight](#loadspecvalueadditionalweight)
- [loadSpecValueCombinations](#loadspecvaluecombinations)
- [loadSpecValueSpeedLimit](#loadspecvaluespeedlimit)
- [loadSpecValueWeight](#loadspecvalueweight)
- [loadSpecValueWorkingWidth](#loadspecvalueworkingwidth)
- [loadSpecValueWorkingWidthConfig](#loadspecvalueworkingwidthconfig)
- [loadSubSharedI3DFile](#loadsubsharedi3dfile)
- [new](#new)
- [onFinishedLoading](#onfinishedloading)
- [onVehicleWakeUpCallback](#onvehiclewakeupcallback)
- [onWaterRaycastCallback](#onwaterraycastcallback)
- [periodChanged](#periodchanged)
- [playControlledActions](#playcontrolledactions)
- [postInit](#postinit)
- [postReadStream](#postreadstream)
- [postWriteStream](#postwritestream)
- [raiseStateChange](#raisestatechange)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [register](#register)
- [registerActionEvents](#registeractionevents)
- [registerComponentXMLPaths](#registercomponentxmlpaths)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerInteractionFlag](#registerinteractionflag)
- [registers](#registers)
- [registerSelectableObjects](#registerselectableobjects)
- [removeActionEvent](#removeactionevent)
- [removeActionEvents](#removeactionevents)
- [removeFromPhysics](#removefromphysics)
- [requestActionEventUpdate](#requestactioneventupdate)
- [reset](#reset)
- [resetPositionToTerrainHeight](#resetpositiontoterrainheight)
- [saveStatsToXMLFile](#savestatstoxmlfile)
- [saveToXMLFile](#savetoxmlfile)
- [selectVehicle](#selectvehicle)
- [setAbsolutePosition](#setabsoluteposition)
- [setBroken](#setbroken)
- [setComponentJointFrame](#setcomponentjointframe)
- [setComponentJointRotLimit](#setcomponentjointrotlimit)
- [setComponentJointTransLimit](#setcomponentjointtranslimit)
- [setConfigurations](#setconfigurations)
- [setDefaultComponentPosition](#setdefaultcomponentposition)
- [setFilename](#setfilename)
- [setLoadCallback](#setloadcallback)
- [setLoadingState](#setloadingstate)
- [setLoadingStep](#setloadingstep)
- [setMassDirty](#setmassdirty)
- [setObjectChangeValues](#setobjectchangevalues)
- [setOperatingTime](#setoperatingtime)
- [setOwnerFarmId](#setownerfarmid)
- [setRelativePosition](#setrelativeposition)
- [setSelectedObject](#setselectedobject)
- [setSelectedVehicle](#setselectedvehicle)
- [setType](#settype)
- [setUniqueId](#setuniqueid)
- [setVisibility](#setvisibility)
- [setWorldPosition](#setworldposition)
- [setWorldPositionQuaternion](#setworldpositionquaternion)
- [showInfo](#showinfo)
- [unselectVehicle](#unselectvehicle)
- [update](#update)
- [updateActionEvents](#updateactionevents)
- [updateEnd](#updateend)
- [updateMapHotspot](#updatemaphotspot)
- [updateMass](#updatemass)
- [updateSelectableObjects](#updateselectableobjects)
- [updateTick](#updatetick)
- [updateVehicleChain](#updatevehiclechain)
- [updateVehicleSpeed](#updatevehiclespeed)
- [updateWaterInfo](#updatewaterinfo)
- [wakeUp](#wakeup)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### actionEventToggleSelection

**Description**

**Definition**

> actionEventToggleSelection()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Vehicle.actionEventToggleSelection( self , actionName, inputValue, callbackState, isAnalog)
    local currentSelection = self.currentSelection
    local currentObject = currentSelection.object
    local currentObjectIndex = currentSelection.index
    local currentSubObjectIndex = currentSelection.subIndex

    local numSubSelections = 0
    if currentObject ~ = nil then
        numSubSelections = #currentObject.subSelections
    end

    local newSelectedSubObjectIndex = currentSubObjectIndex + 1
    local newSelectedObjectIndex = currentObjectIndex
    local newSelectedObject = currentObject

    if newSelectedSubObjectIndex > numSubSelections then
        newSelectedSubObjectIndex = 1
        newSelectedObjectIndex = currentObjectIndex + 1

        if newSelectedObjectIndex > # self.selectableObjects then
            newSelectedObjectIndex = 1
        end
        newSelectedObject = self.selectableObjects[newSelectedObjectIndex]
    end

    if currentObject ~ = newSelectedObject or currentObjectIndex ~ = newSelectedObjectIndex or currentSubObjectIndex ~ = newSelectedSubObjectIndex then
        -- event
        self:setSelectedObject(newSelectedObject, newSelectedSubObjectIndex)
    end
end

```

### actionEventToggleSelectionReverse

**Description**

**Definition**

> actionEventToggleSelectionReverse()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Vehicle.actionEventToggleSelectionReverse( self , actionName, inputValue, callbackState, isAnalog)
    local currentSelection = self.currentSelection
    local currentObject = currentSelection.object
    local currentObjectIndex = currentSelection.index
    local currentSubObjectIndex = currentSelection.subIndex

    local newSelectedSubObjectIndex = currentSubObjectIndex - 1
    local newSelectedObjectIndex = currentObjectIndex
    local newSelectedObject = currentObject

    if newSelectedSubObjectIndex < 1 then
        newSelectedSubObjectIndex = 1
        newSelectedObjectIndex = currentObjectIndex - 1

        if newSelectedObjectIndex < 1 then
            newSelectedObjectIndex = # self.selectableObjects
        end

        newSelectedObject = self.selectableObjects[newSelectedObjectIndex]
        if newSelectedObject ~ = nil then
            newSelectedSubObjectIndex = #newSelectedObject.subSelections
        end
    end

    if currentObject ~ = newSelectedObject or currentObjectIndex ~ = newSelectedObjectIndex or currentSubObjectIndex ~ = newSelectedSubObjectIndex then
        -- event
        self:setSelectedObject(newSelectedObject, newSelectedSubObjectIndex)
    end
end

```

### activate

**Description**

> Called on activate

**Definition**

> activate()

**Code**

```lua
function Vehicle:activate()
    if self.actionController ~ = nil then
        self.actionController:activate()
    end

    SpecializationUtil.raiseEvent( self , "onActivate" )
end

```

### addChildVehicles

**Description**

**Definition**

> addChildVehicles()

**Arguments**

| any | vehicles    |
|-----|-------------|
| any | rootVehicle |

**Code**

```lua
function Vehicle:addChildVehicles(vehicles, rootVehicle)
    table.insert(vehicles, self )
    rootVehicle.childVehicleHash = rootVehicle.childVehicleHash .. ":" .. tostring( self.id)
end

```

### addSubselection

**Description**

**Definition**

> addSubselection()

**Arguments**

| any | subSelection |
|-----|--------------|

**Code**

```lua
function Vehicle:addSubselection(subSelection)
    table.insert( self.selectionObject.subSelections, subSelection)
    return # self.selectionObject.subSelections
end

```

### addToPhysics

**Description**

> Add vehicle to physics

**Definition**

> addToPhysics()

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Vehicle:addToPhysics()

    if not self.isAddedToPhysics then
        local lastMotorizedNode = nil
        for _, component in pairs( self.components) do
            addToPhysics(component.node)
            if component.motorized then
                if lastMotorizedNode ~ = nil then
                    if self.isServer then
                        addVehicleLink(lastMotorizedNode, component.node)
                    end
                end
                lastMotorizedNode = component.node
            end
        end

        self.isAddedToPhysics = true

        if self.isServer then
            for _, jointDesc in pairs( self.componentJoints) do
                self:createComponentJoint( self.components[jointDesc.componentIndices[ 1 ]], self.components[jointDesc.componentIndices[ 2 ]], jointDesc)
            end

            -- if rootnode is sleeping all other components are sleeping as well
                addWakeUpReport( self.rootNode, "onVehicleWakeUpCallback" , self )
            end

            for _, collisionPair in pairs( self.collisionPairs) do
                setPairCollision(collisionPair.component1.node, collisionPair.component2.node, collisionPair.enabled)
            end

            self:setMassDirty()

            return true
        end

        return false
    end

```

### addVehicleToAIImplementList

**Description**

**Definition**

> addVehicleToAIImplementList()

**Arguments**

| any | list |
|-----|------|

**Code**

```lua
function Vehicle:addVehicleToAIImplementList(list)
end

```

### calculateDailyUpkeep

**Description**

**Definition**

> calculateDailyUpkeep()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | age            |
| any | operatingTime  |
| any | configurations |

**Code**

```lua
function Vehicle.calculateDailyUpkeep(storeItem, age, operatingTime, configurations)
    local multiplier = 1
    if storeItem.lifetime ~ = nil and storeItem.lifetime ~ = 0 then
        local ageMultiplier = 0.3 * math.min(age / storeItem.lifetime, 1 )
        operatingTime = operatingTime / ( 1000 * 60 * 60 )
        local operatingTimeMultiplier = 0.7 * math.min(operatingTime / (storeItem.lifetime * EconomyManager.LIFETIME_OPERATINGTIME_RATIO), 1 )
        multiplier = 1 + EconomyManager.MAX_DAILYUPKEEP_MULTIPLIER * (ageMultiplier + operatingTimeMultiplier)
    end

    return StoreItemUtil.getDailyUpkeep(storeItem, configurations) * multiplier
end

```

### calculateSellPrice

**Description**

> Calculate price of vehicle given a bunch of parameters

**Definition**

> calculateSellPrice()

**Arguments**

| any | storeItem     |
|-----|---------------|
| any | age           |
| any | operatingTime |
| any | price         |
| any | repairPrice   |
| any | repaintPrice  |

**Code**

```lua
function Vehicle.calculateSellPrice(storeItem, age, operatingTime, price, repairPrice, repaintPrice)
    local operatingTimeHours = operatingTime / ( 60 * 60 * 1000 )
    local maxVehicleAge = storeItem.lifetime
    local ageInYears = age / Environment.PERIODS_IN_YEAR

    StoreItemUtil.loadSpecsFromXML(storeItem)

    -- Motorized vehicles depreciate differently
    local motorizedFactor = 1.0
    if storeItem.specs.power = = nil then
        motorizedFactor = 1.3
    end

    local operatingTimeFactor = 1 - operatingTimeHours ^ motorizedFactor / maxVehicleAge
    local ageFactor = math.min( - 0.1 * math.log(ageInYears) + 0.75 , 0.85 )

    return math.max(price * operatingTimeFactor * ageFactor - repairPrice - repaintPrice, price * 0.03 )
end

```

### clearDirtyMask

**Description**

**Definition**

> clearDirtyMask()

**Code**

```lua
function Vehicle:clearDirtyMask()
    self.dirtyMask = 0
    SpecializationUtil.raiseEvent( self , "onDirtyMaskCleared" )
end

```

### clearSubselections

**Description**

**Definition**

> clearSubselections()

**Code**

```lua
function Vehicle:clearSubselections()
    self.selectionObject.subSelections = { }
end

```

### createComponentJoint

**Description**

> Create component joint between two components

**Definition**

> createComponentJoint(table component1, table component2, table jointDesc)

**Arguments**

| table | component1 | component 1 |
|-------|------------|-------------|
| table | component2 | component 2 |
| table | jointDesc  | joint desc  |

**Return Values**

| table | success | success |
|-------|---------|---------|

**Code**

```lua
function Vehicle:createComponentJoint(component1, component2, jointDesc)
    if component1 = = nil or component2 = = nil or jointDesc = = nil then
        Logging.xmlWarning( self.xmlFile, "Could not create component joint.No component1, component2 or jointDesc given!" )
        return false
    end

    local constr = JointConstructor.new()
    constr:setActors(component1.node, component2.node)

    local localPoses1 = jointDesc.jointLocalPoses[ 1 ]
    local localPoses2 = jointDesc.jointLocalPoses[ 2 ]
    constr:setJointLocalPositions(localPoses1.trans[ 1 ], localPoses1.trans[ 2 ], localPoses1.trans[ 3 ], localPoses2.trans[ 1 ], localPoses2.trans[ 2 ], localPoses2.trans[ 3 ])
    constr:setJointLocalRotations(localPoses1.rot[ 1 ], localPoses1.rot[ 2 ], localPoses1.rot[ 3 ], localPoses2.rot[ 1 ], localPoses2.rot[ 2 ], localPoses2.rot[ 3 ])
    --constr:setJointTransforms(jointDesc.jointNode, jointDesc.jointNodeActor1)

    constr:setRotationLimitSpring(jointDesc.rotLimitSpring[ 1 ], jointDesc.rotLimitDamping[ 1 ], jointDesc.rotLimitSpring[ 2 ], jointDesc.rotLimitDamping[ 2 ], jointDesc.rotLimitSpring[ 3 ], jointDesc.rotLimitDamping[ 3 ])
    constr:setTranslationLimitSpring(jointDesc.transLimitSpring[ 1 ], jointDesc.transLimitDamping[ 1 ], jointDesc.transLimitSpring[ 2 ], jointDesc.transLimitDamping[ 2 ], jointDesc.transLimitSpring[ 3 ], jointDesc.transLimitDamping[ 3 ])
    constr:setZRotationXOffset(jointDesc.zRotationXOffset)
    for i = 1 , 3 do
        if jointDesc.rotLimit[i] > = jointDesc.rotMinLimit[i] then
            constr:setRotationLimit(i - 1 , jointDesc.rotMinLimit[i], jointDesc.rotLimit[i])
        end

        if jointDesc.transLimit[i] > = jointDesc.transMinLimit[i] then
            constr:setTranslationLimit(i - 1 , true , jointDesc.transMinLimit[i], jointDesc.transLimit[i])
        else
                constr:setTranslationLimit(i - 1 , false , 0 , 0 )
            end
        end

        constr:setRotationLimitForceLimit(jointDesc.rotLimitForceLimit[ 1 ], jointDesc.rotLimitForceLimit[ 2 ], jointDesc.rotLimitForceLimit[ 3 ])
        constr:setTranslationLimitForceLimit(jointDesc.transLimitForceLimit[ 1 ], jointDesc.transLimitForceLimit[ 2 ], jointDesc.transLimitForceLimit[ 3 ])

        if jointDesc.isBreakable then
            constr:setBreakable(jointDesc.breakForce, jointDesc.breakTorque)
        end
        constr:setEnableCollision(jointDesc.enableCollision)

        for i = 1 , 3 do
            if jointDesc.maxRotDriveForce[i] > 0.0001 and(jointDesc.rotDriveVelocity[i] ~ = nil or jointDesc.rotDriveRotation[i] ~ = nil ) then
                local pos = Utils.getNoNil(jointDesc.rotDriveRotation[i], 0 )
                local vel = Utils.getNoNil(jointDesc.rotDriveVelocity[i], 0 )
                constr:setAngularDrive(i - 1 , jointDesc.rotDriveRotation[i] ~ = nil , jointDesc.rotDriveVelocity[i] ~ = nil , jointDesc.rotDriveSpring[i], jointDesc.rotDriveDamping[i], jointDesc.maxRotDriveForce[i], pos, vel)
            end
            if jointDesc.maxTransDriveForce[i] > 0.0001 and(jointDesc.transDriveVelocity[i] ~ = nil or jointDesc.transDrivePosition[i] ~ = nil ) then
                local pos = Utils.getNoNil(jointDesc.transDrivePosition[i], 0 )
                local vel = Utils.getNoNil(jointDesc.transDriveVelocity[i], 0 )
                constr:setLinearDrive(i - 1 , jointDesc.transDrivePosition[i] ~ = nil , jointDesc.transDriveVelocity[i] ~ = nil , jointDesc.transDriveSpring[i], jointDesc.transDriveDamping[i], jointDesc.maxTransDriveForce[i], pos, vel)
            end
        end

        jointDesc.jointIndex = constr:finalize()

        return true
    end

```

### createLoadingTask

**Description**

> Creates a loading task in the loadingTasks table with the given target and returns it.

**Definition**

> createLoadingTask(any target)

**Arguments**

| any | target | The id or reference used to track the loading task. |
|-----|--------|-----------------------------------------------------|

**Return Values**

| any | task | The created loading task. |
|-----|------|---------------------------|

**Code**

```lua
function Vehicle:createLoadingTask(target)
    return SpecializationUtil.createLoadingTask( self , target)
end

```

### createMapHotspot

**Description**

**Definition**

> createMapHotspot()

**Code**

```lua
function Vehicle:createMapHotspot()
    local mapHotspot = VehicleHotspot.new()
    mapHotspot:setVehicle( self )
    mapHotspot:setVehicleType( self.mapHotspotType)
    mapHotspot:setOwnerFarmId( self:getOwnerFarmId())
    self.mapHotspot = mapHotspot

    g_currentMission:addMapHotspot(mapHotspot)
end

```

### dayChanged

**Description**

**Definition**

> dayChanged()

**Code**

```lua
function Vehicle:dayChanged()
end

```

### deactivate

**Description**

> Called on deactivate

**Definition**

> deactivate()

**Code**

```lua
function Vehicle:deactivate()
    if self.actionController ~ = nil then
        self.actionController:deactivate()
    end

    SpecializationUtil.raiseEvent( self , "onDeactivate" )
end

```

### delete

**Description**

**Definition**

> delete()

**Arguments**

| any | immediate |
|-----|-----------|

**Code**

```lua
function Vehicle:delete(immediate)
    if not self.markedForDeletion then
        self:deleteMapHotspot()
        if self.tourId ~ = nil then
            g_guidedTourManager:removeVehicle( self.tourId)
        end
        g_messageCenter:unsubscribeAll( self )

        local rootVehicle = self.rootVehicle
        if rootVehicle ~ = nil and rootVehicle:getIsAIActive() then
            rootVehicle:stopCurrentAIJob( AIMessageErrorVehicleDeleted.new())
        end

        if self.propertyState = = VehiclePropertyState.OWNED then
            g_currentMission:removeOwnedItem( self )
        elseif self.propertyState = = VehiclePropertyState.LEASED then
                g_currentMission:removeLeasedItem( self )
            end
        end

        self.markedForDeletion = true
        -- activate delayed delete
        if not g_currentMission.isExitingGame then
            if not immediate then
                g_currentMission.vehicleSystem:markVehicleForDeletion( self )
                return
            end
        end

        if self.isDeleted then
            Logging.devError( "Trying to delete an already deleted vehicle" )
            printCallstack()
            return
        end

        VehicleDebug.delete( self )

        self.isDeleting = true

        g_inputBinding:beginActionEventsModification( Vehicle.INPUT_CONTEXT_NAME)
        self:removeActionEvents()
        g_inputBinding:endActionEventsModification()

        SpecializationUtil.raiseEvent( self , "onPreDelete" )
        SpecializationUtil.raiseEvent( self , "onDelete" )

        if self.isServer and self.componentJoints ~ = nil then
            for _,v in pairs( self.componentJoints) do
                if v.jointIndex ~ = 0 then
                    removeJoint(v.jointIndex)
                end
            end

            removeWakeUpReport( self.rootNode)
        end

        if self.components ~ = nil then
            -- unlink all components first in case we linked one component into another(during loading they are linked into the component joints)
            for _, component in pairs( self.components) do
                unlink(component.node)
            end

            for _, component in pairs( self.components) do
                delete(component.node)

                g_currentMission:removeNodeObject(component.node)
            end
        end

        if self.i3dNode ~ = nil then
            delete( self.i3dNode)
            self.i3dNode = nil
        end

        if self.sharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
            self.sharedLoadRequestId = nil
        end

        self.xmlFile:delete()

        if self.externalSoundsFile ~ = nil then
            self.externalSoundsFile:delete()
        end

        self.rootNode = nil
        self.isDeleting = false
        self.isDeleted = true

        g_currentMission.vehicleSystem:removeVehicle( self )

        Vehicle:superClass().delete( self )
    end

```

### deleteMapHotspot

**Description**

**Definition**

> deleteMapHotspot()

**Code**

```lua
function Vehicle:deleteMapHotspot()
    if self.mapHotspot ~ = nil then
        g_currentMission:removeMapHotspot( self.mapHotspot)
        self.mapHotspot:delete()
        self.mapHotspot = nil
    end
end

```

### doCheckSpeedLimit

**Description**

**Definition**

> doCheckSpeedLimit()

**Code**

```lua
function Vehicle:doCheckSpeedLimit()
    return false
end

```

### doCollisionMaskCheck

**Description**

**Definition**

> doCollisionMaskCheck()

**Arguments**

| any | targetCollisionMask |
|-----|---------------------|
| any | path                |
| any | node                |
| any | str                 |

**Code**

```lua
function Vehicle:doCollisionMaskCheck(targetCollisionMask, path, node, str)
    local ignoreCheck = false
    if path ~ = nil then
        ignoreCheck = self.xmlFile:getValue(path, false )
    end

    if not ignoreCheck then
        local hasMask = false
        if node = = nil then
            for _, component in ipairs( self.components) do
                hasMask = hasMask or bit32.band(getCollisionFilterMask(component.node), targetCollisionMask) = = targetCollisionMask
            end
        else
                hasMask = hasMask or bit32.band(getCollisionFilterMask(node), targetCollisionMask) = = targetCollisionMask
            end

            if not hasMask then
                printCallstack()
                Logging.xmlWarning( self.xmlFile, "%s has wrong collision mask! Following bit(s) need to be set '%s' or use '%s'" , str or self.typeName, MathUtil.numberToSetBitsStr(targetCollisionMask), path)
                return false
            end
        end

        return true
    end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | subDraw |
|-----|---------|

**Code**

```lua
function Vehicle:draw(subDraw)
    if self:getIsSynchronized() then
        local rootVehicle = self.rootVehicle
        local selectedVehicle = self:getSelectedVehicle()
        if not subDraw then
            -- draw is only called on the 'entered' vehicle
            -- so if the 'entered' vehicle is not the root vehicle or not the selected vehicle we call draw on them
                if self ~ = rootVehicle and selectedVehicle ~ = rootVehicle then
                    rootVehicle:draw( true )
                end

                if selectedVehicle ~ = nil and self ~ = selectedVehicle and selectedVehicle ~ = rootVehicle then
                    selectedVehicle:draw( true )
                end
            end

            if selectedVehicle = = self or rootVehicle = = self then
                local isActiveForInput = self:getIsActiveForInput()
                local isActiveForInputIgnoreSelection = self:getIsActiveForInput( true )
                SpecializationUtil.raiseEvent( self , "onDraw" , isActiveForInput, isActiveForInputIgnoreSelection, true )
            end

            -- DebugText.renderAtNode(self.rootNode, "farm: " .. tostring(self:getOwnerFarmId()) .. ", controller: " .. tostring(self:getActiveFarm()))

            -- if self = = self.rootVehicle and self:getIsActiveForInput() then
                -- renderText(0.5, 0.95, 0.012, tostring(self:getSelectedVehicle()))
                -- for k, object in ipairs(self.selectableObjects) do
                    -- renderText(0.5, 0.9-k*0.015, 0.012, tostring(object.vehicle) .. " " .. tostring(object.vehicle.configFileName) .. ": " .. #object.subSelections .. " " .. tostring(object.vehicle:getIsSelected()))
                    -- end
                    -- end

                    VehicleDebug.drawDebug( self )

                    if self.showTailwaterDepthWarning then
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_dontDriveIntoWater" ), 2000 )
                    end
                end
            end

```

### drawUIInfo

**Description**

> Draw UI info

**Definition**

> drawUIInfo()

**Code**

```lua
function Vehicle:drawUIInfo()
    if self:getIsSynchronized() then
        SpecializationUtil.raiseEvent( self , "onDrawUIInfo" )

        if g_showVehicleDistance then
            local dist = calcDistanceFrom( self.rootNode, g_cameraManager:getActiveCamera())
            if dist < = 350 then
                local x, y, z = getWorldTranslation( self.rootNode)
                Utils.renderTextAtWorldPosition(x, y + 1 , z, string.format( "%.0f" , dist), getCorrectTextSize( 0.02 ), 0 )
            end
        end
    end
end

```

### findRootVehicle

**Description**

**Definition**

> findRootVehicle()

**Code**

```lua
function Vehicle:findRootVehicle()
    return self
end

```

### finishLoadingTask

**Description**

> Marks the given task as done, and calls onFinishedLoading, if readyForFinishLoading is true.

**Definition**

> finishLoadingTask(table task)

**Arguments**

| table | task | The task to mark as complete. Should be obtained from createLoadingTask. |
|-------|------|--------------------------------------------------------------------------|

**Code**

```lua
function Vehicle:finishLoadingTask(task)
    SpecializationUtil.finishLoadingTask( self , task)
end

```

### getActionControllerDirection

**Description**

**Definition**

> getActionControllerDirection()

**Code**

```lua
function Vehicle:getActionControllerDirection()
    if self.actionController ~ = nil then
        return self.actionController:getActionControllerDirection()
    end

    return 1
end

```

### getAdditionalComponentMass

**Description**

**Definition**

> getAdditionalComponentMass()

**Arguments**

| any | component |
|-----|-----------|

**Code**

```lua
function Vehicle:getAdditionalComponentMass(component)
    return 0
end

```

### getAdditionalSchemaText

**Description**

**Definition**

> getAdditionalSchemaText()

**Code**

```lua
function Vehicle:getAdditionalSchemaText()
    return nil
end

```

### getAreControlledActionsAccessible

**Description**

**Definition**

> getAreControlledActionsAccessible()

**Code**

```lua
function Vehicle:getAreControlledActionsAccessible()
    if self:getIsAIActive() then
        return false
    end

    if self.actionController ~ = nil then
        return self.actionController:getAreControlledActionsAccessible()
    end

    return false
end

```

### getAreControlledActionsAllowed

**Description**

> Returns if controlled actions are allowed

**Definition**

> getAreControlledActionsAllowed()

**Return Values**

| any | allow   | allow controlled actions |
|-----|---------|--------------------------|
| any | warning | not allowed warning      |

**Code**

```lua
function Vehicle:getAreControlledActionsAllowed()
    return not self:getIsAIActive(), ""
end

```

### getAreControlledActionsAvailable

**Description**

**Definition**

> getAreControlledActionsAvailable()

**Code**

```lua
function Vehicle:getAreControlledActionsAvailable()
    if self:getIsAIActive() then
        return false
    end

    if self.actionController ~ = nil then
        return self.actionController:getAreControlledActionsAvailable()
    end

    return false
end

```

### getAvailableComponentMass

**Description**

**Definition**

> getAvailableComponentMass()

**Code**

```lua
function Vehicle:getAvailableComponentMass()
    return math.max(( self.maxComponentMass - self.precalculatedMass) - self.serverMass, 0 )
end

```

### getBlockSelection

**Description**

**Definition**

> getBlockSelection()

**Code**

```lua
function Vehicle:getBlockSelection()
    return not self.allowSelection
end

```

### getBrand

**Description**

**Definition**

> getBrand()

**Code**

```lua
function Vehicle:getBrand()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem = = nil then
        return Brand.LIZARD
    end

    if storeItem.configurations ~ = nil then
        for configName, _ in pairs(storeItem.configurations) do
            local configId = self.configurations[configName]
            local config = storeItem.configurations[configName][configId]
            if config.vehicleBrand ~ = nil then
                return config.vehicleBrand
            end
        end
    end

    return storeItem.brandIndex
end

```

### getCanBeAddedToSales

**Description**

**Definition**

> getCanBeAddedToSales()

**Code**

```lua
function Vehicle:getCanBeAddedToSales()
    return true
end

```

### getCanBeMounted

**Description**

**Definition**

> getCanBeMounted()

**Code**

```lua
function Vehicle:getCanBeMounted()
    return entityExists( self.components[ 1 ].node)
end

```

### getCanBePickedUp

**Description**

**Definition**

> getCanBePickedUp(Player byPlayer)

**Arguments**

| Player | byPlayer |
|--------|----------|

**Return Values**

| Player | canBePickUp |
|--------|-------------|

**Code**

```lua
function Vehicle:getCanBePickedUp(byPlayer)
    return self.supportsPickUp and g_currentMission.accessHandler:canPlayerAccess( self , byPlayer)
end

```

### getCanBeReset

**Description**

**Definition**

> getCanBeReset()

**Code**

```lua
function Vehicle:getCanBeReset()
    return self.canBeReset and not g_guidedTourManager:getIsTourRunning()
end

```

### getCanBeSelected

**Description**

**Definition**

> getCanBeSelected()

**Code**

```lua
function Vehicle:getCanBeSelected()
    return VehicleDebug.state ~ = 0 -- allow selection while any debug modes is active to debug any vehicle
    end

```

### getCanBeSold

**Description**

**Definition**

> getCanBeSold()

**Code**

```lua
function Vehicle:getCanBeSold()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem ~ = nil then
        return storeItem.canBeSold
    end

    return true
end

```

### getCanToggleSelectable

**Description**

**Definition**

> getCanToggleSelectable()

**Code**

```lua
function Vehicle:getCanToggleSelectable()
    return false
end

```

### getChildVehicleHash

**Description**

**Definition**

> getChildVehicleHash()

**Code**

```lua
function Vehicle:getChildVehicleHash()
    return self.childVehicleHash
end

```

### getChildVehicles

**Description**

**Definition**

> getChildVehicles()

**Code**

```lua
function Vehicle:getChildVehicles()
    return self.childVehicles
end

```

### getComponentMass

**Description**

> Returns the mass of a component

**Definition**

> getComponentMass(table component)

**Arguments**

| table | component | component |
|-------|-----------|-----------|

**Return Values**

| table | mass | mass |
|-------|------|------|

**Code**

```lua
function Vehicle:getComponentMass(component)
    if component ~ = nil then
        return component.mass
    end

    return 0
end

```

### getControlledActionIcons

**Description**

**Definition**

> getControlledActionIcons()

**Code**

```lua
function Vehicle:getControlledActionIcons()
    if self.actionController ~ = nil then
        local iconPos, iconNeg, changeColor = self.actionController:getControlledActionIcons()
        if iconPos ~ = nil then
            return iconPos, iconNeg, changeColor
        end
    end

    return "TURN_ON" , "TURN_ON" , true
end

```

### getDailyUpkeep

**Description**

> Get daily up keep

**Definition**

> getDailyUpkeep()

**Return Values**

| table | dailyUpkeep | daily up keep |
|-------|-------------|---------------|

**Code**

```lua
function Vehicle:getDailyUpkeep()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    return Vehicle.calculateDailyUpkeep(storeItem, self.age, self.operatingTime, self.configurations)
end

```

### getDeactivateOnLeave

**Description**

**Definition**

> getDeactivateOnLeave()

**Code**

```lua
function Vehicle:getDeactivateOnLeave()
    return true
end

```

### getDefaultMass

**Description**

**Definition**

> getDefaultMass()

**Code**

```lua
function Vehicle:getDefaultMass()
    local mass = 0

    for _, component in ipairs( self.components) do
        mass = mass + (component.defaultMass or 0 )
    end

    return mass
end

```

### getDistanceToNode

**Description**

**Definition**

> getDistanceToNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Vehicle:getDistanceToNode(node)
    self.interactionFlag = Vehicle.INTERACTION_FLAG_NONE
    return math.huge
end

```

### getFillLevelInformation

**Description**

> Get fill level information

**Definition**

> getFillLevelInformation(table display)

**Arguments**

| table | display | fill level information |
|-------|---------|------------------------|

**Code**

```lua
function Vehicle:getFillLevelInformation(display)
end

```

### getFullName

**Description**

**Definition**

> getFullName()

**Code**

```lua
function Vehicle:getFullName()
    local name = self:getName()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem ~ = nil then
        local brand = g_brandManager:getBrandByIndex( self:getBrand())
        if brand ~ = nil and brand.name ~ = "NONE" then
            name = brand.title .. " " .. name
        end
    end

    return name
end

```

### getHasObjectMounted

**Description**

> Returns if the vehicle (or any child) has the given object mounted

**Definition**

> getHasObjectMounted(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Return Values**

| table | hasObjectMounted | has object mounted |
|-------|------------------|--------------------|

**Code**

```lua
function Vehicle:getHasObjectMounted(object)
    return false
end

```

### getImageFilename

**Description**

**Definition**

> getImageFilename()

**Code**

```lua
function Vehicle:getImageFilename()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem = = nil then
        return ShopController.EMPTY_FILENAME
    end

    if storeItem.configurations ~ = nil then
        for configName, _ in pairs(storeItem.configurations) do
            local configId = self.configurations[configName]
            local config = storeItem.configurations[configName][configId]
            if config = = nil then
                Logging.xmlWarning( self.xmlFile, "Vehicle has an invalid configuration value %s for %s" , configId, configName)
                elseif config.vehicleIcon ~ = nil and config.vehicleIcon ~ = "" then
                        return config.vehicleIcon
                    end
                end
            end

            return storeItem.imageFilename
        end

```

### getInteractionHelp

**Description**

**Definition**

> getInteractionHelp()

**Code**

```lua
function Vehicle:getInteractionHelp()
    return ""
end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Code**

```lua
function Vehicle:getIsActive()
    if self.isBroken then
        return false
    end

    if self.forceIsActive then
        return true
    end

    return false
end

```

### getIsActiveForInput

**Description**

**Definition**

> getIsActiveForInput()

**Arguments**

| any | ignoreSelection |
|-----|-----------------|
| any | activeForAI     |

**Code**

```lua
function Vehicle:getIsActiveForInput(ignoreSelection, activeForAI)
    if not self.allowsInput then
        return false
    end

    if not g_currentMission.isRunning then
        return false
    end

    if (activeForAI = = nil or not activeForAI) and self:getIsAIActive() then
        return false
    end

    if not ignoreSelection then
        local rootVehicle = self.rootVehicle
        if rootVehicle ~ = nil then
            local selectedObject = rootVehicle:getSelectedVehicle()
            if self ~ = selectedObject then
                return false
            end
        else
                return false
            end
        end

        local rootAttacherVehicle = self.rootVehicle
        if rootAttacherVehicle ~ = self then
            if not rootAttacherVehicle:getIsActiveForInput( true , activeForAI) then
                return false
            end
        else
                -- if it is the root vehicle and it is not enterable we check for a attacherVehicle
                    if self.getIsEntered = = nil and self.getAttacherVehicle ~ = nil and self:getAttacherVehicle() = = nil then
                        return false
                    end
                end

                return true
            end

```

### getIsActiveForSound

**Description**

**Definition**

> getIsActiveForSound()

**Code**

```lua
function Vehicle:getIsActiveForSound()
    printWarning( "Warning:Vehicle:getIsActiveForSound() is deprecated" )
    return false
end

```

### getIsAIActive

**Description**

**Definition**

> getIsAIActive()

**Code**

```lua
function Vehicle:getIsAIActive()
    if self.getAttacherVehicle ~ = nil then
        local attacherVehicle = self:getAttacherVehicle()
        if attacherVehicle ~ = nil then
            return attacherVehicle:getIsAIActive()
        end
    end

    return false
end

```

### getIsAutomaticShiftingAllowed

**Description**

**Definition**

> getIsAutomaticShiftingAllowed()

**Code**

```lua
function Vehicle:getIsAutomaticShiftingAllowed()
    return true
end

```

### getIsInShowroom

**Description**

> Returns if the vehicle is currently inside a showroom

**Definition**

> getIsInShowroom()

**Code**

```lua
function Vehicle:getIsInShowroom()
    return self.propertyState = = VehiclePropertyState.SHOP_CONFIG
end

```

### getIsInUse

**Description**

**Definition**

> getIsInUse()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function Vehicle:getIsInUse(connection)
    return false
end

```

### getIsLowered

**Description**

**Definition**

> getIsLowered()

**Arguments**

| any | defaultIsLowered |
|-----|------------------|

**Code**

```lua
function Vehicle:getIsLowered(defaultIsLowered)
    return false
end

```

### getIsMapHotspotVisible

**Description**

**Definition**

> getIsMapHotspotVisible()

**Code**

```lua
function Vehicle:getIsMapHotspotVisible()
    return true
end

```

### getIsNodeActive

**Description**

> Returns if a vehicle node is currently used in any of the active components (not disabled by component configurations)

**Definition**

> getIsNodeActive(integer node)

**Arguments**

| integer | node | node id |
|---------|------|---------|

**Code**

```lua
function Vehicle:getIsNodeActive(node)
    while node ~ = 0 do
        for _, rootLevelNode in ipairs( self.rootLevelNodes) do
            if node = = rootLevelNode.node then
                if rootLevelNode.isInactive then
                    return false -- inside a inactive component
                else
                        return true -- inside a active component
                    end
                end
            end

            node = getParent(node)
        end

        return false
    end

```

### getIsOnField

**Description**

> Returns true if vehicle is on a field

**Definition**

> getIsOnField()

**Return Values**

| integer | isOnField | is on field |
|---------|-----------|-------------|

**Code**

```lua
function Vehicle:getIsOnField()
    for _,component in pairs( self.components) do
        local wx, wy, wz = localToWorld(component.node, getCenterOfMass(component.node))

        local h = getTerrainHeightAtWorldPos(g_terrainNode, wx, wy, wz)
        if h - 1 > wy then -- 1m threshold since ground tools are working slightly under the ground
            break
        end

        local isOnField, _ = FSDensityMapUtil.getFieldDataAtWorldPosition(wx, wy, wz)
        if isOnField then
            return true
        end
    end

    return false
end

```

### getIsOperating

**Description**

> Returns true if is operating

**Definition**

> getIsOperating()

**Return Values**

| integer | isOperating | is operating |
|---------|-------------|--------------|

**Code**

```lua
function Vehicle:getIsOperating()
    return false
end

```

### getIsPowered

**Description**

**Definition**

> getIsPowered()

**Code**

```lua
function Vehicle:getIsPowered()
    return true
end

```

### getIsReadyForAutomatedTrainTravel

**Description**

**Definition**

> getIsReadyForAutomatedTrainTravel()

**Code**

```lua
function Vehicle:getIsReadyForAutomatedTrainTravel()
    return true
end

```

### getIsSelected

**Description**

**Definition**

> getIsSelected()

**Code**

```lua
function Vehicle:getIsSelected()
    if self.selectionObject = = nil then
        return false
    end

    return self.selectionObject.isSelected
end

```

### getIsSynchronized

**Description**

**Definition**

> getIsSynchronized()

**Code**

```lua
function Vehicle:getIsSynchronized()
    return self.loadingStep = = SpecializationLoadStep.SYNCHRONIZED
end

```

### getIsVehicleNode

**Description**

> Returns true if node is from vehicle

**Definition**

> getIsVehicleNode(integer nodeId)

**Arguments**

| integer | nodeId | node id |
|---------|--------|---------|

**Return Values**

| integer | isFromVehicle | is from vehicle |
|---------|---------------|-----------------|

**Code**

```lua
function Vehicle:getIsVehicleNode(nodeId)
    return self.vehicleNodes[nodeId] ~ = nil
end

```

### getLastSpeed

**Description**

> Returns last speed in kph

**Definition**

> getLastSpeed(boolean useAttacherVehicleSpeed)

**Arguments**

| boolean | useAttacherVehicleSpeed | use speed of attacher vehicle |
|---------|-------------------------|-------------------------------|

**Return Values**

| boolean | lastSpeed | last speed |
|---------|-----------|------------|

**Code**

```lua
function Vehicle:getLastSpeed(useAttacherVehicleSpeed)
    if useAttacherVehicleSpeed then
        if self.attacherVehicle ~ = nil then
            return self.attacherVehicle:getLastSpeed( true )
        end
    end

    return self.lastSpeed * 3600
end

```

### getLimitedVehicleYPosition

**Description**

**Definition**

> getLimitedVehicleYPosition()

**Arguments**

| any | position |
|-----|----------|

**Code**

```lua
function Vehicle:getLimitedVehicleYPosition(position)
    if position.posY = = nil then
        -- vehicle position based on yOffset
        local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, position.posX, 300 , position.posZ)
        return terrainHeight + Utils.getNoNil(position.yOffset, 0 )
    end

    return position.posY
end

```

### getMapHotspot

**Description**

**Definition**

> getMapHotspot()

**Code**

```lua
function Vehicle:getMapHotspot()
    return self.mapHotspot
end

```

### getMaxComponentMassReached

**Description**

**Definition**

> getMaxComponentMassReached()

**Code**

```lua
function Vehicle:getMaxComponentMassReached()
    return( self.serverMass + 0.001 ) > = ( self.maxComponentMass - self.precalculatedMass)
end

```

### getName

**Description**

**Definition**

> getName()

**Code**

```lua
function Vehicle:getName()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem = = nil then
        return "Unknown"
    end

    if storeItem.configurations ~ = nil then
        for configName, _ in pairs(storeItem.configurations) do
            local configId = self.configurations[configName]
            local config = storeItem.configurations[configName][configId]
            if config.vehicleName ~ = nil and config.vehicleName ~ = "" then
                return config.vehicleName
            end
        end
    end

    return storeItem.name
end

```

### getNeedsSaving

**Description**

**Definition**

> getNeedsSaving()

**Code**

```lua
function Vehicle:getNeedsSaving()
    return self.isVehicleSaved
end

```

### getOperatingTime

**Description**

**Definition**

> getOperatingTime()

**Code**

```lua
function Vehicle:getOperatingTime()
    return self.operatingTime
end

```

### getOverallCenterOfMass

**Description**

> Returns overall center of mass of vehicle

**Definition**

> getOverallCenterOfMass()

**Return Values**

| any | x | x |
|-----|---|---|
| any | y | y |
| any | z | z |

**Code**

```lua
function Vehicle:getOverallCenterOfMass()
    local cx, cy, cz = 0 , 0 , 0
    local totalMass = self:getTotalMass( true )
    local numComponents = # self.components
    for i = 1 , numComponents do
        local component = self.components[i]
        local ccx, ccy, ccz = localToWorld(component.node, getCenterOfMass(component.node))
        local percentage = self:getComponentMass(component) / totalMass

        cx, cy, cz = cx + ccx * percentage, cy + ccy * percentage, cz + ccz * percentage
    end

    return cx, cy, cz
end

```

### getParentComponent

**Description**

> Get parent component of node

**Definition**

> getParentComponent(integer node)

**Arguments**

| integer | node | id of node |
|---------|------|------------|

**Return Values**

| integer | parentComponent | id of parent component node |
|---------|-----------------|-----------------------------|

**Code**

```lua
function Vehicle:getParentComponent(node)
    while node ~ = 0 do
        if self:getIsVehicleNode(node) then
            return node
        end
        node = getParent(node)
    end
    return 0
end

```

### getPrice

**Description**

> Returns price

**Definition**

> getPrice(float price)

**Arguments**

| float | price | price |
|-------|-------|-------|

**Code**

```lua
function Vehicle:getPrice()
    return self.price
end

```

### getPropertyState

**Description**

**Definition**

> getPropertyState()

**Code**

```lua
function Vehicle:getPropertyState()
    return self.propertyState
end

```

### getRawSpeedLimit

**Description**

> Get raw speed limit of vehicle

**Definition**

> getRawSpeedLimit()

**Return Values**

| float | speedLimit | speed limit |
|-------|------------|-------------|

**Code**

```lua
function Vehicle:getRawSpeedLimit()
    return self.speedLimit
end

```

### getReloadXML

**Description**

> Get reload xml

**Definition**

> getReloadXML()

**Return Values**

| float | xml | xml |
|-------|-----|-----|

**Code**

```lua
function Vehicle:getReloadXML()
    local vehicleXMLFile = XMLFile.create( "vehicleXMLFile" , "" , "vehicles" , Vehicle.xmlSchemaSavegame)
    if vehicleXMLFile ~ = nil then
        local key = string.format( "vehicles.vehicle(%d)" , 0 )

        vehicleXMLFile:setValue(key .. "#filename" , HTMLUtil.encodeToHTML(NetworkUtil.convertToNetworkFilename( self.configFileName)))
        self:saveToXMLFile(vehicleXMLFile, key, { } )

        return vehicleXMLFile
    end

    return nil
end

```

### getRepaintPrice

**Description**

**Definition**

> getRepaintPrice()

**Code**

```lua
function Vehicle:getRepaintPrice()
    return 0
end

```

### getRepairPrice

**Description**

**Definition**

> getRepairPrice()

**Code**

```lua
function Vehicle:getRepairPrice()
    return 0
end

```

### getRequiresPower

**Description**

> Returns if the vehicle is currently requiring power for a certain activity (e.g. for unloading via the pipe) - this
> can be used to automatically try to enable the power (e.g. motor turn on)

**Definition**

> getRequiresPower()

**Code**

```lua
function Vehicle:getRequiresPower()
    return false
end

```

### getResetPlaces

**Description**

**Definition**

> getResetPlaces()

**Code**

```lua
function Vehicle:getResetPlaces()
    return g_currentMission:getResetPlaces(), g_currentMission.usedLoadPlaces
end

```

### getRootVehicle

**Description**

**Definition**

> getRootVehicle()

**Code**

```lua
function Vehicle:getRootVehicle()
    return self.rootVehicle
end

```

### getSelectedObject

**Description**

**Definition**

> getSelectedObject()

**Code**

```lua
function Vehicle:getSelectedObject()
    local rootVehicle = self.rootVehicle
    if rootVehicle = = self then
        return self.currentSelection.object
    end

    return rootVehicle:getSelectedObject()
end

```

### getSelectedVehicle

**Description**

**Definition**

> getSelectedVehicle()

**Code**

```lua
function Vehicle:getSelectedVehicle()
    local selectedObject = self:getSelectedObject()
    if selectedObject ~ = nil then
        return selectedObject.vehicle
    end
    return nil
end

```

### getSellPrice

**Description**

> Get sell price

**Definition**

> getSellPrice()

**Return Values**

| float | sellPrice | sell price |
|-------|-----------|------------|

**Code**

```lua
function Vehicle:getSellPrice()
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    return Vehicle.calculateSellPrice(storeItem, self.age, self.operatingTime, self:getPrice(), self:getRepairPrice(), self:getRepaintPrice())
end

```

### getShowInVehiclesOverview

**Description**

**Definition**

> getShowInVehiclesOverview()

**Code**

```lua
function Vehicle:getShowInVehiclesOverview()
    return self.showInVehicleOverview and( self.propertyState = = VehiclePropertyState.OWNED or self.propertyState = = VehiclePropertyState.LEASED)
end

```

### getSpecConfigValuesWeight

**Description**

**Definition**

> getSpecConfigValuesWeight()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Vehicle.getSpecConfigValuesWeight(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.weight ~ = nil then
        if storeItem.specs.weight.storeDataConfigs ~ = nil then
            return storeItem.specs.weight.storeDataConfigs
        end
    end

    return nil
end

```

### getSpecValueAdditionalWeight

**Description**

**Definition**

> getSpecValueAdditionalWeight()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Vehicle.getSpecValueAdditionalWeight(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if not g_currentMission.missionInfo.trailerFillLimit then
        return nil
    end

    if storeItem.specs.additionalWeight ~ = nil then
        local baseWeight = Vehicle.getSpecValueWeight(storeItem, realItem, configurations, saleItem, true )
        if baseWeight ~ = nil then
            local additionalWeight = storeItem.specs.additionalWeight - baseWeight

            if returnValues then
                return additionalWeight
            else
                    return g_i18n:formatMass(additionalWeight)
                end
            end
        end

        return nil
    end

```

### getSpecValueCombinations

**Description**

**Definition**

> getSpecValueCombinations()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function Vehicle.getSpecValueCombinations(storeItem, realItem)
    return storeItem.specs.combinations
end

```

### getSpecValueDailyUpkeep

**Description**

**Definition**

> getSpecValueDailyUpkeep()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |
| any | _         |
| any | saleItem  |

**Code**

```lua
function Vehicle.getSpecValueDailyUpkeep(storeItem, realItem, _, saleItem)
    local dailyUpkeep = storeItem.dailyUpkeep
    if realItem ~ = nil and realItem.getDailyUpkeep ~ = nil then
        dailyUpkeep = realItem:getDailyUpkeep()
    elseif saleItem ~ = nil then
            dailyUpkeep = 0 --Vehicle.calculateDailyUpkeep(storeItem, saleItem.age, saleItem.operatingTime, {})
        end

        -- Hide when no upkeep
        if dailyUpkeep = = 0 then
            return nil
        end

        return string.format(g_i18n:getText( "shop_maintenanceValue" ), g_i18n:formatMoney(dailyUpkeep, 2 ))
    end

```

### getSpecValueOperatingTime

**Description**

**Definition**

> getSpecValueOperatingTime()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |
| any | _         |
| any | saleItem  |

**Code**

```lua
function Vehicle.getSpecValueOperatingTime(storeItem, realItem, _, saleItem)
    local operatingTime

    if realItem ~ = nil and realItem.operatingTime ~ = nil then
        operatingTime = realItem.operatingTime
    elseif saleItem ~ = nil then
            operatingTime = saleItem.operatingTime
        else
                return nil
            end

            local minutes = operatingTime / ( 1000 * 60 )
            local hours = math.floor(minutes / 60 )
            minutes = math.floor((minutes - hours * 60 ) / 6 )

            return string.format(g_i18n:getText( "shop_operatingTime" ), hours, minutes)
        end

```

### getSpecValueSlots

**Description**

**Definition**

> getSpecValueSlots()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Vehicle.getSpecValueSlots(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local numOwned = g_currentMission:getNumOfItems(storeItem)
    local valueText = ""
    if realItem ~ = nil then
        local sellSlotUsage = g_currentMission.slotSystem:getStoreItemSlotUsage(storeItem, numOwned = = 1 )
        if sellSlotUsage ~ = 0 then
            valueText = "-" .. sellSlotUsage
        end
    else
            local buySlotUsage = g_currentMission.slotSystem:getStoreItemSlotUsage(storeItem, numOwned = = 0 )
            if storeItem.bundleInfo ~ = nil then
                buySlotUsage = 0
                for i = 1 , #storeItem.bundleInfo.bundleItems do
                    local bundleInfo = storeItem.bundleInfo.bundleItems[i]
                    local numBundleItemOwned = g_currentMission:getNumOfItems(bundleInfo.item)
                    local usage = g_currentMission.slotSystem:getStoreItemSlotUsage(bundleInfo.item, numBundleItemOwned = = 0 )
                    buySlotUsage = buySlotUsage + usage
                end
            end

            if buySlotUsage ~ = 0 then
                valueText = "+" .. buySlotUsage
            end
        end

        if valueText ~ = "" then
            return valueText
        else
                return nil
            end
        end

```

### getSpecValueSpeedLimit

**Description**

**Definition**

> getSpecValueSpeedLimit()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function Vehicle.getSpecValueSpeedLimit(storeItem, realItem)
    if storeItem.specs.speedLimit ~ = nil then
        return string.format(g_i18n:getText( "shop_maxSpeed" ), string.format( "%1d" , g_i18n:getSpeed(storeItem.specs.speedLimit)), g_i18n:getSpeedMeasuringUnit())
    end
    return nil
end

```

### getSpecValueWeight

**Description**

**Definition**

> getSpecValueWeight()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Vehicle.getSpecValueWeight(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.weight ~ = nil then
        local vehicleMass, vehicleMassMax
        if realItem ~ = nil then
            realItem:updateMass()
            vehicleMass = realItem:getTotalMass( true )
        else
                if storeItem.specs.weight.storeDataMin ~ = nil then
                    vehicleMass = (storeItem.specs.weight.storeDataMin or 0 ) / 1000
                    vehicleMassMax = (storeItem.specs.weight.storeDataMax or 0 ) / 1000
                elseif storeItem.specs.weight.componentMass ~ = nil then
                        if configurations ~ = nil and configurations[ "component" ] ~ = nil then
                            vehicleMass = storeItem.specs.weight.configurations[configurations[ "component" ]]
                        end

                        if vehicleMass = = nil then
                            vehicleMass = storeItem.specs.weight.componentMass
                        end

                        vehicleMass = vehicleMass + (storeItem.specs.weight.wheelMassDefaultConfig or 0 )
                        vehicleMass = vehicleMass + FillUnit.getSpecValueStartFillUnitMassByMassData(storeItem.specs.weight.fillUnitMassData)
                    end
                end

                if vehicleMass ~ = nil and vehicleMass ~ = 0 then
                    if returnValues then
                        if returnRange then
                            return vehicleMass, vehicleMassMax
                        else
                                return vehicleMass
                            end
                        else
                                if vehicleMassMax ~ = nil and vehicleMassMax ~ = 0 then
                                    return g_i18n:formatMass(vehicleMass, vehicleMassMax)
                                else
                                        return g_i18n:formatMass(vehicleMass)
                                    end
                                end
                            end
                        end

                        return nil
                    end

```

### getSpecValueWorkingWidth

**Description**

**Definition**

> getSpecValueWorkingWidth()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function Vehicle.getSpecValueWorkingWidth(storeItem, realItem)
    if storeItem.specs.workingWidth ~ = nil then
        local workingWidth = storeItem.specs.workingWidth
        if workingWidth.minWidth ~ = workingWidth.width then
            return string.format(g_i18n:getText( "shop_workingWidthValue" ), string.format( "%s-%s" , g_i18n:formatNumber(workingWidth.minWidth, 1 , true ), g_i18n:formatNumber(workingWidth.width, 1 , true )))
        end

        return string.format(g_i18n:getText( "shop_workingWidthValue" ), g_i18n:formatNumber(workingWidth.width, 1 , true ))
    end

    return nil
end

```

### getSpecValueWorkingWidthConfig

**Description**

**Definition**

> getSpecValueWorkingWidthConfig()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Vehicle.getSpecValueWorkingWidthConfig(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.workingWidthConfig ~ = nil then
        local minWorkingWidth = 0
        local workingWidth = 0
        if configurations ~ = nil and(realItem ~ = nil or saleItem ~ = nil ) then
            for configName, config in pairs(configurations) do
                if storeItem.specs.workingWidthConfig[configName] ~ = nil then
                    local configData = storeItem.specs.workingWidthConfig[configName][config]
                    if configData ~ = nil then
                        workingWidth = configData.width
                    end
                end
            end
        else
                local minWidth = math.huge
                local maxWidth = 0
                for configName, configs in pairs(storeItem.specs.workingWidthConfig) do
                    for _, configData in pairs(configs) do
                        if configData.isSelectable then
                            minWidth = math.min(minWidth, configData.width)
                            maxWidth = math.max(maxWidth, configData.width)
                        end
                    end
                end

                minWorkingWidth = minWidth
                workingWidth = maxWidth
            end

            if not returnValues then
                if minWorkingWidth ~ = 0 and minWorkingWidth ~ = math.huge and minWorkingWidth ~ = workingWidth then
                    return string.format(g_i18n:getText( "shop_workingWidthValue" ), string.format( "%s-%s" , g_i18n:formatNumber(minWorkingWidth, 1 , true ), g_i18n:formatNumber(workingWidth, 1 , true )))
                else
                        return string.format(g_i18n:getText( "shop_workingWidthValue" ), g_i18n:formatNumber(workingWidth, 1 , true ))
                    end
                else
                        return workingWidth
                    end
                end

                return nil
            end

```

### getSpeedLimit

**Description**

> Get speed limit

**Definition**

> getSpeedLimit(boolean onlyIfWorking)

**Arguments**

| boolean | onlyIfWorking | only if working |
|---------|---------------|-----------------|

**Return Values**

| boolean | limit             | limit                |
|---------|-------------------|----------------------|
| boolean | doCheckSpeedLimit | do check speed limit |

**Code**

```lua
function Vehicle:getSpeedLimit(onlyIfWorking)
    local limit = math.huge
    local doCheckSpeedLimit = self:doCheckSpeedLimit()
    if onlyIfWorking = = nil or(onlyIfWorking and doCheckSpeedLimit) then
        limit = self:getRawSpeedLimit()

        local damage = self:getVehicleDamage()
        if damage > 0 then
            limit = limit * ( 1 - damage * Vehicle.DAMAGED_SPEEDLIMIT_REDUCTION)
        end
    end

    local attachedImplements
    if self.getAttachedImplements ~ = nil then
        attachedImplements = self:getAttachedImplements()
    end
    if attachedImplements ~ = nil then
        for _, implement in pairs(attachedImplements) do
            if implement.object ~ = nil then
                local speed, implementDoCheckSpeedLimit = implement.object:getSpeedLimit(onlyIfWorking)
                if onlyIfWorking = = nil or(onlyIfWorking and implementDoCheckSpeedLimit) then
                    limit = math.min(limit, speed)
                end
                doCheckSpeedLimit = doCheckSpeedLimit or implementDoCheckSpeedLimit
            end
        end
    end
    return limit, doCheckSpeedLimit
end

```

### getTotalMass

**Description**

> Returns total mass of vehicle (optional including attached vehicles)

**Definition**

> getTotalMass(boolean onlyGivenVehicle)

**Arguments**

| boolean | onlyGivenVehicle | use only the given vehicle, if false or nil it includes all attachables |
|---------|------------------|-------------------------------------------------------------------------|

**Return Values**

| boolean | totalMass | total mass |
|---------|-----------|------------|

**Code**

```lua
function Vehicle:getTotalMass(onlyGivenVehicle)
    local mass = 0

    for _, component in ipairs( self.components) do
        mass = mass + self:getComponentMass(component)
    end

    return mass
end

```

### getUniqueId

**Description**

> Gets this vehicle's unique id.

**Definition**

> getUniqueId()

**Return Values**

| boolean | uniqueId | This vehicle's unique id. |
|---------|----------|---------------------------|

**Code**

```lua
function Vehicle:getUniqueId()
    return self.uniqueId
end

```

### getUppercaseName

**Description**

> Gets the full name of the vehicle in uppercase.

**Definition**

> getUppercaseName()

**Return Values**

| boolean | uppercaseFullName | The uppercase full name of the vehicle. |
|---------|-------------------|-----------------------------------------|

**Code**

```lua
function Vehicle:getUppercaseName()
    local name = self:getFullName()
    name = utf8ToUpper(name)
    return name
end

```

### getUseTurnedOnSchema

**Description**

**Definition**

> getUseTurnedOnSchema()

**Code**

```lua
function Vehicle:getUseTurnedOnSchema()
    return false
end

```

### getVehicleDamage

**Description**

**Definition**

> getVehicleDamage()

**Code**

```lua
function Vehicle:getVehicleDamage()
    return 0
end

```

### getVehicleWorldDirection

**Description**

> Returns the world space direction of the vehicle

**Definition**

> getVehicleWorldDirection()

**Return Values**

| boolean | x | x |
|---------|---|---|
| boolean | y | y |
| boolean | z | z |

**Code**

```lua
function Vehicle:getVehicleWorldDirection()
    return localDirectionToWorld( self.components[ 1 ].node, 0 , 0 , 1 )
end

```

### getVehicleWorldXRot

**Description**

> Returns the world space x rotation in rad

**Definition**

> getVehicleWorldXRot()

**Return Values**

| boolean | rotation | rotation |
|---------|----------|----------|

**Code**

```lua
function Vehicle:getVehicleWorldXRot()
    local _, y, _ = localDirectionToWorld( self.components[ 1 ].node, 0 , 0 , 1 )
    local slopeAngle = math.pi * 0.5 - math.atan( 1 / y)
    if slopeAngle > math.pi * 0.5 then
        slopeAngle = slopeAngle - math.pi
    end

    return slopeAngle
end

```

### getWorkLoad

**Description**

**Definition**

> getWorkLoad()

**Code**

```lua
function Vehicle:getWorkLoad()
    return 0 , 0
end

```

### hasInputConflictWithSelection

**Description**

**Definition**

> hasInputConflictWithSelection()

**Arguments**

| any | inputs |
|-----|--------|

**Code**

```lua
function Vehicle:hasInputConflictWithSelection(inputs)
    printCallstack()
    Logging.xmlWarning( self.xmlFile, "Vehicle:hasInputConflictWithSelection() is deprecated!" )
    return false
end

```

### i3dFileLoaded

**Description**

**Definition**

> i3dFileLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | arguments    |
| any | i3dLoadingId |

**Code**

```lua
function Vehicle:i3dFileLoaded(i3dNode, failedReason, arguments, i3dLoadingId)
    if i3dNode = = 0 then
        self:setLoadingState(VehicleLoadingState.ERROR)
        Logging.xmlError( self.xmlFile, "Vehicle i3d loading failed!" )
        self:loadCallback()
        return
    end

    self.i3dNode = i3dNode
    setVisibility(i3dNode, false )

    g_asyncTaskManager:addTask( function ()
        self:loadFinished()
    end )
end

```

### init

**Description**

**Definition**

> init()

**Code**

```lua
function Vehicle.init()
    g_vehicleConfigurationManager:addConfigurationType( "baseColor" , g_i18n:getText( "configuration_baseColor" ), nil , VehicleConfigurationItemColor )
    g_vehicleConfigurationManager:addConfigurationType( "vehicleType" , g_i18n:getText( "configuration_design" ), nil , VehicleConfigurationItemVehicleType )
    g_vehicleConfigurationManager:addConfigurationType( "component" , g_i18n:getText( "configuration_design" ), "base" , VehicleConfigurationItem )

    g_vehicleConfigurationManager:addConfigurationType( "design" , g_i18n:getText( "configuration_design" ), nil , VehicleConfigurationItem )
    g_vehicleConfigurationManager:addConfigurationType( "designColor" , g_i18n:getText( "configuration_designColor" ), nil , VehicleConfigurationItemColor )
    for i = 2 , 16 do
        g_vehicleConfigurationManager:addConfigurationType( string.format( "design%d" , i), g_i18n:getText( "configuration_design" ), nil , VehicleConfigurationItem )
        g_vehicleConfigurationManager:addConfigurationType( string.format( "designColor%d" , i), g_i18n:getText( "configuration_designColor" ), nil , VehicleConfigurationItemColor )
    end

    g_storeManager:addSpecType( "age" , "shopListAttributeIconLifeTime" , nil , Vehicle.getSpecValueAge, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "operatingTime" , "shopListAttributeIconOperatingHours" , nil , Vehicle.getSpecValueOperatingTime, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "dailyUpkeep" , "shopListAttributeIconMaintenanceCosts" , nil , Vehicle.getSpecValueDailyUpkeep, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "workingWidth" , "shopListAttributeIconWorkingWidth" , Vehicle.loadSpecValueWorkingWidth, Vehicle.getSpecValueWorkingWidth, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "workingWidthConfig" , "shopListAttributeIconWorkingWidth" , Vehicle.loadSpecValueWorkingWidthConfig, Vehicle.getSpecValueWorkingWidthConfig, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "speedLimit" , "shopListAttributeIconWorkSpeed" , Vehicle.loadSpecValueSpeedLimit, Vehicle.getSpecValueSpeedLimit, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "weight" , "shopListAttributeIconWeight" , Vehicle.loadSpecValueWeight, Vehicle.getSpecValueWeight, StoreSpecies.VEHICLE, nil , Vehicle.getSpecConfigValuesWeight)
    g_storeManager:addSpecType( "additionalWeight" , "shopListAttributeIconAdditionalWeight" , Vehicle.loadSpecValueAdditionalWeight, Vehicle.getSpecValueAdditionalWeight, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "combinations" , nil , Vehicle.loadSpecValueCombinations, Vehicle.getSpecValueCombinations, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "slots" , "shopListAttributeIconSlots" , nil , Vehicle.getSpecValueSlots, StoreSpecies.VEHICLE)

    Vehicle.xmlSchema = XMLSchema.new( "vehicle" )
    g_storeManager:addSpeciesXMLSchema(StoreSpecies.VEHICLE, Vehicle.xmlSchema)
    g_vehicleTypeManager:setXMLSchema( Vehicle.xmlSchema)

    Vehicle.xmlSchemaSounds = XMLSchema.new( "vehicle_sounds" )
    Vehicle.xmlSchemaSounds:setRootNodeName( "sounds" )
    Vehicle.xmlSchema:addSubSchema( Vehicle.xmlSchemaSounds, "sounds" )

    Vehicle.xmlSchemaSavegame = XMLSchema.new( "savegame_vehicles" )

    Vehicle.registers()
end

```

### interact

**Description**

**Definition**

> interact()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function Vehicle:interact(player)
end

```

### load

**Description**

**Definition**

> load()

**Arguments**

| any | vehicleLoadingData |
|-----|--------------------|

**Code**

```lua
function Vehicle:load(vehicleLoadingData)
    self.vehicleLoadingData = vehicleLoadingData

    self:setLoadingStep(SpecializationLoadStep.PRE_LOAD)

    self.isVehicleSaved = vehicleLoadingData.isSaved

    if self.type = = nil then
        Logging.xmlWarning( self.xmlFile, "Unable to find vehicleType" )
        self:setLoadingState(VehicleLoadingState.ERROR)
        return self.loadingState
    end

    self.actionEvents = { }
    self.xmlFile = XMLFile.load( "vehicleXML" , self.configFileName, Vehicle.xmlSchema)
    self.savegame = vehicleLoadingData.savegameData
    self.isAddedToPhysics = false

    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem ~ = nil then
        self.brand = g_brandManager:getBrandByIndex(storeItem.brandIndex)
        self.lifetime = storeItem.lifetime
    end

    self.externalSoundsFilename = self.xmlFile:getValue( "vehicle.base.sounds#filename" )
    if self.externalSoundsFilename ~ = nil then
        self.externalSoundsFilename = Utils.getFilename( self.externalSoundsFilename, self.baseDirectory)
        self.externalSoundsFile = XMLFile.load( "TempExternalSounds" , self.externalSoundsFilename, Vehicle.xmlSchemaSounds)
    end

    self.soundVolumeFactor = self.xmlFile:getValue( "vehicle.base.sounds#volumeFactor" )

    -- pass function pointers from specializations to 'self'
        SpecializationUtil.copyTypeFunctionsInto( self.type , self )

        -- check if one of the configurations is not set - e.g.if new configurations are available but not in savegame
            local item = g_storeManager:getItemByXMLFilename( self.configFileName)
            if item ~ = nil and item.configurations ~ = nil then
                -- check if the loaded configurations do match the configuration sets
                    -- if not we apply the set which has the most common configurations
                        -- e.g.if a new configuration was added to the configuration set we make sure we don't break old savegames
                            if item.configurationSets ~ = nil and #item.configurationSets > 0 then
                                if not ConfigurationUtil.getConfigurationsMatchConfigSets( self.configurations, item.configurationSets) then
                                    local closestSet, closestSetMatches = ConfigurationUtil.getClosestConfigurationSet( self.configurations, item.configurationSets)
                                    if closestSet ~ = nil then
                                        for configName, index in pairs(closestSet.configurations) do
                                            self.configurations[configName] = index
                                        end

                                        Logging.xmlInfo( self.xmlFile, "Savegame configurations do not match the configuration sets! Apply closest configuration set '%s' with %d matching configurations." , closestSet.name, closestSetMatches)
                                        end
                                    end
                                end

                                for configName, _ in pairs(item.configurations) do
                                    local defaultConfigId = StoreItemUtil.getDefaultConfigId(item, configName)
                                    if self.configurations[configName] = = nil then
                                        ConfigurationUtil.setConfiguration( self , configName, defaultConfigId)
                                    end
                                    -- base configuration is always included
                                    ConfigurationUtil.addBoughtConfiguration(g_vehicleConfigurationManager, self , configName, defaultConfigId)
                                end
                                -- check if currently used configurations are still available
                                    for configName, value in pairs( self.configurations) do
                                        if item.configurations[configName] = = nil then
                                            Logging.xmlWarning( self.xmlFile, "Configurations are not present anymore.Ignoring this configuration(%s)!" , configName)
                                            self.configurations[configName] = nil
                                            self.boughtConfigurations[configName] = nil
                                        else
                                                local defaultConfigId = StoreItemUtil.getDefaultConfigId(item, configName)
                                                if #item.configurations[configName] < value then
                                                    Logging.xmlWarning( self.xmlFile, "Configuration with index '%d' is not present anymore.Using default configuration instead! (%s)" , value, configName)

                                                    if self.boughtConfigurations[configName] ~ = nil then
                                                        self.boughtConfigurations[configName][value] = nil
                                                        if next( self.boughtConfigurations[configName]) = = nil then
                                                            self.boughtConfigurations[configName] = nil
                                                        end
                                                    end
                                                    ConfigurationUtil.setConfiguration( self , configName, defaultConfigId)
                                                else
                                                        ConfigurationUtil.addBoughtConfiguration(g_vehicleConfigurationManager, self , configName, value)
                                                    end
                                                end
                                            end
                                        end

                                        SpecializationUtil.createSpecializationEnvironments( self , function (specName, specEntryName)
                                            Logging.xmlError( self.xmlFile, "The vehicle specialization '%s' could not be added because variable '%s' already exists!" , specName, specEntryName)
                                            self:setLoadingState(VehicleLoadingState.ERROR)
                                        end )

                                        SpecializationUtil.raiseEvent( self , "onPreLoad" , self.savegame)
                                        if self.loadingState ~ = VehicleLoadingState.OK then
                                            Logging.xmlError( self.xmlFile, "Vehicle pre-loading failed!" )
                                            self.xmlFile:delete()
                                            return false
                                        end

                                        ConfigurationUtil.raiseConfigurationItemEvent( self , "onPreLoad" )

                                        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.filename" , "vehicle.base.filename" ) --FS17 to FS19

                                        self.i3dFilename = Utils.getFilename( self.xmlFile:getValue( "vehicle.base.filename" ), self.baseDirectory)
                                        if self.i3dFilename ~ = nil then
                                            local isPathValid, invalidDesc = Utils.getPathIsValid( self.i3dFilename)
                                            if not isPathValid then
                                                Logging.xmlWarning( self.xmlFile, "Filename contains %s, which are not allowed! (%s)" , invalidDesc, "vehicle.base.filename" )
                                            end
                                        end

                                        self:setLoadingStep(SpecializationLoadStep.AWAIT_I3D)

                                        self.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync( self.i3dFilename, true , false , self.i3dFileLoaded, self )

                                        return nil
                                    end

```

### loadCallback

**Description**

**Definition**

> loadCallback()

**Code**

```lua
function Vehicle:loadCallback()
    if self.loadCallbackFunction ~ = nil then
        self.loadCallbackFunction( self.loadCallbackFunctionTarget, self , self.loadingState, self.loadCallbackFunctionArguments)
        self.loadCallbackFunction = nil
        self.loadCallbackFunctionTarget = nil
        self.loadCallbackFunctionArguments = nil
    end
end

```

### loadComponentFromXML

**Description**

> Load component from xml

**Definition**

> loadComponentFromXML(table component, XMLFile xmlFile, string key, table rootPosition, integer i)

**Arguments**

| table   | component    | component               |
|---------|--------------|-------------------------|
| XMLFile | xmlFile      | XMLFile instance        |
| string  | key          | key                     |
| table   | rootPosition | root position (x, y, z) |
| integer | i            | component index         |

**Return Values**

| integer | success | success |
|---------|---------|---------|

**Code**

```lua
function Vehicle:loadComponentFromXML(component, xmlFile, key, rootPosition, i)
    if not self.isServer then
        if getRigidBodyType(component.node) = = RigidBodyType.DYNAMIC then
            setRigidBodyType(component.node, RigidBodyType.KINEMATIC)
        end
    end

    if i = = 1 then
        rootPosition[ 1 ], rootPosition[ 2 ], rootPosition[ 3 ] = getTranslation(component.node)
        if rootPosition[ 2 ] ~ = 0 then
            Logging.xmlWarning( self.xmlFile, "Y-Translation of component 1(node 0>) has to be 0.Current value is: %.5f" , rootPosition[ 2 ])
        end
    end

    if getRigidBodyType(component.node) = = RigidBodyType.STATIC then
        component.isStatic = true
    elseif getRigidBodyType(component.node) = = RigidBodyType.KINEMATIC then
            component.isKinematic = true
        elseif getRigidBodyType(component.node) = = RigidBodyType.DYNAMIC then
                component.isDynamic = true
            end

            if not CollisionFlag.getHasGroupFlagSet(component.node, CollisionFlag.VEHICLE) then
                Logging.xmlWarning( self.xmlFile, "Missing collision group mask %s.Please add this bit to component node '%s'" , CollisionFlag.getBitAndName(CollisionFlag.VEHICLE), getName(component.node))
            end

            if not CollisionFlag.getHasMaskFlagSet(component.node, CollisionFlag.VEHICLE) then
                Logging.xmlWarning( self.xmlFile, "Missing collision filter mask %s.Please add this bit to component node '%s'" , CollisionFlag.getBitAndName(CollisionFlag.VEHICLE), getName(component.node))
            end

            -- the position of the first component is the zero
            translate(component.node, - rootPosition[ 1 ], - rootPosition[ 2 ], - rootPosition[ 3 ])
            local x,y,z = getTranslation(component.node)
            local rx,ry,rz = getRotation(component.node)
            component.originalTranslation = { x,y,z }
            component.originalRotation = { rx,ry,rz }

            component.sentTranslation = { x,y,z }
            component.sentRotation = { rx,ry,rz }

            component.defaultMass = nil
            component.mass = nil

            local mass = xmlFile:getValue(key .. "#mass" )
            if mass ~ = nil then
                if mass < 10 then
                    Logging.xmlDevWarning( self.xmlFile, "Mass is lower than 10kg for '%s'.Mass unit is kilograms.Is this correct?" , key)
                    end
                    if component.isDynamic then
                        setMass(component.node, mass / 1000 )
                    end

                    component.defaultMass = mass / 1000
                    component.mass = component.defaultMass
                    component.lastMass = component.mass
                else
                        Logging.xmlWarning( self.xmlFile, "Missing 'mass' for '%s'.Using default mass 500kg instead!" , key)
                            component.defaultMass = 0.5
                            component.mass = 0.5
                            component.lastMass = component.mass
                        end

                        local comX, comY, comZ = xmlFile:getValue(key .. "#centerOfMass" )
                        if comX ~ = nil then
                            setCenterOfMass(component.node, comX, comY, comZ)
                        end
                        local inertiaScaleX, inertiaScaleY, inertiaScaleZ = xmlFile:getValue(key .. "#inertiaScale" )
                        if inertiaScaleX ~ = nil then
                            setInertiaScale(component.node, inertiaScaleX, inertiaScaleY, inertiaScaleZ)
                        end
                        local count = xmlFile:getValue(key .. "#solverIterationCount" ) -- TODO:clamp
                        if count ~ = nil then
                            setSolverIterationCount(component.node, count)
                            component.solverIterationCount = count
                        end
                        component.motorized = xmlFile:getValue(key .. "#motorized" ) -- Note:motorized is nil if not set in the xml, and can be set by the wheels
                            self.vehicleNodes[component.node] = { component = component }
                            local clipDistance = getClipDistance(component.node)
                            if clipDistance > = 1000000 and getVisibility(component.node) then
                                local defaultClipdistance = 300
                                Logging.xmlWarning( self.xmlFile, "No clipdistance is set to component node '%s' (%s>).Set default clipdistance '%d'" , getName(component.node), i - 1 , defaultClipdistance)
                                setClipDistance(component.node, defaultClipdistance)
                            end

                            component.collideWithAttachables = xmlFile:getValue(key .. "#collideWithAttachables" , false )

                            if getRigidBodyType(component.node) ~ = RigidBodyType.NONE then
                                if getLinearDamping(component.node) > 0.01 then
                                    Logging.xmlDevWarning( self.xmlFile, "Non-zero linear damping(%.4f) for component node '%s' (%s>).Is this correct?" , getLinearDamping(component.node), getName(component.node), i - 1 )
                                    elseif getAngularDamping(component.node) > 0.05 then
                                            Logging.xmlDevWarning( self.xmlFile, "Large angular damping(%.4f) for component node '%s' (%s>).Is this correct?" , getAngularDamping(component.node), getName(component.node), i - 1 )
                                            elseif getAngularDamping(component.node) < 0.0001 then
                                                    Logging.xmlDevWarning( self.xmlFile, "Zero damping for component node '%s' (%s>).Is this correct?" , getName(component.node), i - 1 )
                                                    end
                                                end

                                                local name = getName(component.node)
                                                if not name:contains( "_component" ) then
                                                    Logging.xmlDevWarning( self.xmlFile, "Name of component '%d' ('%s') does not correspond with the component naming convention! (vehicleName_componentName_component%d)" , i, name, i)
                                                end

                                                g_currentMission:addNodeObject(component.node, self )

                                                return true
                                            end

```

### loadComponentJointFromXML

**Description**

> Load component joints from xml

**Definition**

> loadComponentJointFromXML(table jointDesc, XMLFile xmlFile, string key, integer componentJointI, integer jointNode,
> integer index1, integer index2)

**Arguments**

| table   | jointDesc       | joint desc            |
|---------|-----------------|-----------------------|
| XMLFile | xmlFile         | XMLFile instance      |
| string  | key             | key                   |
| integer | componentJointI | component joint index |
| integer | jointNode       | id of joint node      |
| integer | index1          | index of component 1  |
| integer | index2          | index of component 2  |

**Return Values**

| integer | success | success |
|---------|---------|---------|

**Code**

```lua
function Vehicle:loadComponentJointFromXML(jointDesc, xmlFile, key, componentJointI, jointNode, index1, index2)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#indexActor1" , key .. "#nodeActor1" ) --FS17 to FS19

    jointDesc.componentIndices = { index1, index2 }
    jointDesc.jointNode = jointNode
    jointDesc.jointNodeActor1 = xmlFile:getValue(key .. "#nodeActor1" , jointNode, self.components, self.i3dMappings)
    if self.isServer then
        if self.components[index1] = = nil or self.components[index2] = = nil then
            Logging.xmlWarning( self.xmlFile, "Invalid component indices(component1: %d, component2: %d) for component joint %d.Indices start with 1!" , index1, index2, componentJointI)
                return false
            end

            local x, y, z = xmlFile:getValue( key .. "#rotLimit" )
            local rotLimits = { math.rad( Utils.getNoNil(x, 0 )), math.rad( Utils.getNoNil(y, 0 )), math.rad( Utils.getNoNil(z, 0 )) }
            x, y, z = xmlFile:getValue( key .. "#transLimit" )
            local transLimits = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
            jointDesc.rotLimit = rotLimits
            jointDesc.transLimit = transLimits

            x, y, z = xmlFile:getValue( key .. "#rotMinLimit" )
            local rotMinLimits = { Utils.getNoNilRad(x, nil ), Utils.getNoNilRad(y, nil ), Utils.getNoNilRad(z, nil ) }

            x, y, z = xmlFile:getValue( key .. "#transMinLimit" )
            local transMinLimits = { x,y,z }

            for i = 1 , 3 do
                if rotMinLimits[i] = = nil then
                    if rotLimits[i] > = 0 then
                        rotMinLimits[i] = - rotLimits[i]
                    else
                            rotMinLimits[i] = rotLimits[i] + 1
                        end
                    end
                    if transMinLimits[i] = = nil then
                        if transLimits[i] > = 0 then
                            transMinLimits[i] = - transLimits[i]
                        else
                                transMinLimits[i] = transLimits[i] + 1
                            end
                        end
                    end

                    jointDesc.jointLocalPoses = { }
                    local trans = { localToLocal(jointDesc.jointNode, self.components[index1].node, 0 , 0 , 0 ) }
                    local rot = { localRotationToLocal(jointDesc.jointNode, self.components[index1].node, 0 , 0 , 0 ) }
                    jointDesc.jointLocalPoses[ 1 ] = { trans = trans, rot = rot }

                    trans = { localToLocal(jointDesc.jointNodeActor1, self.components[index2].node, 0 , 0 , 0 ) }
                    rot = { localRotationToLocal(jointDesc.jointNodeActor1, self.components[index2].node, 0 , 0 , 0 ) }
                    jointDesc.jointLocalPoses[ 2 ] = { trans = trans, rot = rot }

                    jointDesc.rotMinLimit = rotMinLimits
                    jointDesc.transMinLimit = transMinLimits

                    x, y, z = xmlFile:getValue( key .. "#rotLimitSpring" )
                    local rotLimitSpring = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#rotLimitDamping" )
                    local rotLimitDamping = { Utils.getNoNil(x, 1 ), Utils.getNoNil(y, 1 ), Utils.getNoNil(z, 1 ) }
                    jointDesc.rotLimitSpring = rotLimitSpring
                    jointDesc.rotLimitDamping = rotLimitDamping

                    x, y, z = xmlFile:getValue( key .. "#rotLimitForceLimit" )
                    local rotLimitForceLimit = { Utils.getNoNil(x, - 1 ), Utils.getNoNil(y, - 1 ), Utils.getNoNil(z, - 1 ) }
                    x, y, z = xmlFile:getValue( key .. "#transLimitForceLimit" )
                    local transLimitForceLimit = { Utils.getNoNil(x, - 1 ), Utils.getNoNil(y, - 1 ), Utils.getNoNil(z, - 1 ) }
                    jointDesc.rotLimitForceLimit = rotLimitForceLimit
                    jointDesc.transLimitForceLimit = transLimitForceLimit

                    x, y, z = xmlFile:getValue( key .. "#transLimitSpring" )
                    local transLimitSpring = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#transLimitDamping" )
                    local transLimitDamping = { Utils.getNoNil(x, 1 ), Utils.getNoNil(y, 1 ), Utils.getNoNil(z, 1 ) }
                    jointDesc.transLimitSpring = transLimitSpring
                    jointDesc.transLimitDamping = transLimitDamping

                    jointDesc.zRotationXOffset = 0
                    local zRotationNode = xmlFile:getValue(key .. "#zRotationNode" , nil , self.components, self.i3dMappings)
                    if zRotationNode ~ = nil then
                        local yOffset, zOffset
                        jointDesc.zRotationXOffset, yOffset, zOffset = localToLocal(zRotationNode, jointNode, 0 , 0 , 0 )

                        if math.abs(yOffset) > 0.01 or math.abs(zOffset) > 0.01 then
                            Logging.xmlWarning( self.xmlFile, "ComponentJoint zRotationNode '%s' is not correctly aligned with joint node '%s'.Offset is:y %.3f, z %.3f.Make sure the zRotationNode has only a translation offset on the X axis." , getName(zRotationNode), getName(jointNode), yOffset, zOffset)
                        end
                    end

                    jointDesc.isBreakable = xmlFile:getValue(key .. "#breakable" , false )
                    if jointDesc.isBreakable then
                        jointDesc.breakForce = xmlFile:getValue(key .. "#breakForce" , 10 )
                        jointDesc.breakTorque = xmlFile:getValue(key .. "#breakTorque" , 10 )
                    end
                    jointDesc.enableCollision = xmlFile:getValue(key .. "#enableCollision" , false )

                    -- Rotational drive
                    x, y, z = xmlFile:getValue( key .. "#maxRotDriveForce" )
                    local maxRotDriveForce = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#rotDriveVelocity" )
                    local rotDriveVelocity = { Utils.getNoNilRad(x, nil ), Utils.getNoNilRad(y, nil ), Utils.getNoNilRad(z, nil ) } -- convert from deg/s to rad/s
                    x, y, z = xmlFile:getValue( key .. "#rotDriveRotation" )
                    local rotDriveRotation = { Utils.getNoNilRad(x, nil ), Utils.getNoNilRad(y, nil ), Utils.getNoNilRad(z, nil ) } -- convert from deg to rad
                    x, y, z = xmlFile:getValue( key .. "#rotDriveSpring" )
                    local rotDriveSpring = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#rotDriveDamping" )
                    local rotDriveDamping = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }

                    jointDesc.rotDriveVelocity = rotDriveVelocity
                    jointDesc.rotDriveRotation = rotDriveRotation
                    jointDesc.rotDriveSpring = rotDriveSpring
                    jointDesc.rotDriveDamping = rotDriveDamping
                    jointDesc.maxRotDriveForce = maxRotDriveForce

                    -- Translational drive
                    x, y, z = xmlFile:getValue( key .. "#maxTransDriveForce" )
                    local maxTransDriveForce = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#transDriveVelocity" )
                    local transDriveVelocity = { x,y,z }
                    x, y, z = xmlFile:getValue( key .. "#transDrivePosition" )
                    local transDrivePosition = { x,y,z }
                    x, y, z = xmlFile:getValue( key .. "#transDriveSpring" )
                    local transDriveSpring = { Utils.getNoNil(x, 0 ), Utils.getNoNil(y, 0 ), Utils.getNoNil(z, 0 ) }
                    x, y, z = xmlFile:getValue( key .. "#transDriveDamping" )
                    local transDriveDamping = { Utils.getNoNil(x, 1 ), Utils.getNoNil(y, 1 ), Utils.getNoNil(z, 1 ) }

                    jointDesc.transDriveVelocity = transDriveVelocity
                    jointDesc.transDrivePosition = transDrivePosition
                    jointDesc.transDriveSpring = transDriveSpring
                    jointDesc.transDriveDamping = transDriveDamping
                    jointDesc.maxTransDriveForce = maxTransDriveForce

                    jointDesc.initComponentPosition = xmlFile:getValue(key .. "#initComponentPosition" , true )

                    jointDesc.jointIndex = 0
                end

                return true
            end

```

### loadFinished

**Description**

**Definition**

> loadFinished()

**Code**

```lua
function Vehicle:loadFinished()
    local realNumComponents
    local componentsKey
    local numComponents

    self:addAsyncTask( function ()
        self:setLoadingState(VehicleLoadingState.OK)
        self:setLoadingStep(SpecializationLoadStep.LOAD)

        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.forcedMapHotspotType" , "vehicle.base.mapHotspot#type" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.forcedMapHotspotType" , "vehicle.base.mapHotspot#type" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.speedLimit#value" , "vehicle.base.speedLimit#value" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.steeringAxleNode#index" , "vehicle.base.steeringAxle#node" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.size#width" , "vehicle.base.size#width" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.size#length" , "vehicle.base.size#length" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.size#widthOffset" , "vehicle.base.size#widthOffset" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.size#lengthOffset" , "vehicle.base.size#lengthOffset" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.typeDesc" , "vehicle.base.typeDesc" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.components" , "vehicle.base.components" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.components.component" , "vehicle.base.components.component" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.components.component1" , "vehicle.base.components.component" ) --FS17 to FS19
        XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.mapHotspot#hasDirection" ) --FS22 to FS25
    end , "Vehicle - Deprecated Check" )

    self:addAsyncTask( function ()
        local savegame = self.savegame

        if savegame ~ = nil then
            self.tourId = nil
            local tourId = savegame.xmlFile:getValue(savegame.key .. "#tourId" )
            if tourId ~ = nil then
                self.tourId = tourId
                g_guidedTourManager:addVehicle( self , self.tourId)
            end
        end

        self.age = 0
        self.propertyState = self.vehicleLoadingData.propertyState
        self:setOwnerFarmId( self.vehicleLoadingData.ownerFarmId, true )

        if savegame ~ = nil then
            local uniqueId = savegame.xmlFile:getValue(savegame.key .. "#uniqueId" , nil )
            if uniqueId ~ = nil then
                self:setUniqueId(uniqueId)
            end

            if not savegame.ignoreFarmId then
                -- Load this early:it used by the vehicle load functions already
                local farmId = savegame.xmlFile:getValue(savegame.key .. "#farmId" , AccessHandler.EVERYONE)
                if g_farmManager.mergedFarms ~ = nil and g_farmManager.mergedFarms[farmId] ~ = nil then
                    farmId = g_farmManager.mergedFarms[farmId]
                end

                self:setOwnerFarmId(farmId, true )
            end
        end

        self.price = self.vehicleLoadingData.price
        if self.price = = 0 or self.price = = nil then
            local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
            self.price = StoreItemUtil.getDefaultPrice(storeItem, self.configurations)
        end

        self.typeDesc = self.xmlFile:getValue( "vehicle.base.typeDesc" , "TypeDescription" , self.customEnvironment, true )
        for name, configDesc in pairs(g_vehicleConfigurationManager:getConfigurations()) do
            local configurationKey = string.format( "%s(%d)" , configDesc.configurationKey, ( self.configurations[name] or 1 ) - 1 )
            local typeDesc = self.xmlFile:getValue(configurationKey .. "#typeDesc" , nil , self.customEnvironment, false )
            if typeDesc ~ = nil then
                self.typeDesc = typeDesc
            end
        end

        self.synchronizePosition = self.xmlFile:getValue( "vehicle.base.synchronizePosition" , true )
        self.highPrecisionPositionSynchronization = false
        self.supportsPickUp = self.xmlFile:getValue( "vehicle.base.supportsPickUp" , false )
        self.canBeReset = self.xmlFile:getValue( "vehicle.base.canBeReset" , true )
        self.showInVehicleOverview = self.xmlFile:getValue( "vehicle.base.showInVehicleMenu" , true )

        self.rootNode = getChildAt( self.i3dNode, 0 )
        self.serverMass = 0
        self.precalculatedMass = 0 -- mass of vehicle that is not included in serverMass(e.g.wheels)
        self.isMassDirty = false

        self.terrainHeightResetCounter = 0

        self.currentUpdateDistance = 0
        self.lastDistanceToCamera = 0
        self.lodDistanceCoeff = getLODDistanceCoeff()
        self.viewDistanceCoeff = getViewDistanceCoeff()

        self.components = { }
        self.vehicleNodes = { }

        realNumComponents = getNumOfChildren( self.i3dNode)
        local rootPosition = { 0 , 0 , 0 }

        local componentConfigurationId = self.configurations[ "component" ] or 1
        componentsKey = string.format( "vehicle.base.componentConfigurations.componentConfiguration(%d)" , componentConfigurationId - 1 )
        if not self.xmlFile:hasProperty(componentsKey) then
            componentsKey = "vehicle.base.components"
        end

        numComponents = self.xmlFile:getValue(componentsKey .. "#numComponents" , realNumComponents)
        self.maxComponentMass = self.xmlFile:getValue(componentsKey .. "#maxMass" , math.huge) / 1000

        self.rootLevelNodes = { }
        for i = 1 , realNumComponents do
            local rootLevelNode = { }
            rootLevelNode.node = getChildAt( self.i3dNode, i - 1 )
            rootLevelNode.isInactive = true

            if not getVisibility(rootLevelNode.node) then
                Logging.xmlDevWarning( self.xmlFile, "Found hidden component '%s' in i3d file.Components are not allowed to be hidden!" , getName(rootLevelNode.node))
            end

            setVisibility(rootLevelNode.node, false )

            table.insert( self.rootLevelNodes, rootLevelNode)
        end

        for componentIndex, componentKey in self.xmlFile:iterator(componentsKey .. ".component" ) do
            if componentIndex > numComponents then
                Logging.xmlWarning( self.xmlFile, "Invalid components count.I3D file has '%d' components, but tried to load component no. '%d'!" , numComponents, componentIndex + 1 )
                break
            end

            local i3dIndex = self.xmlFile:getValue(componentKey .. "#index" , componentIndex) - 1

            local component = { }
            component.node = getChildAt( self.i3dNode, i3dIndex)

            if self:loadComponentFromXML(component, self.xmlFile, componentKey, rootPosition, componentIndex) then
                local x,y,z = getWorldTranslation(component.node)
                local qx,qy,qz,qw = getWorldQuaternion(component.node)
                component.networkInterpolators = { }
                component.networkInterpolators.position = InterpolatorPosition.new(x, y, z)
                component.networkInterpolators.quaternion = InterpolatorQuaternion.new(qx, qy, qz, qw)
                table.insert( self.components, component)
            end
        end

        for _, component in ipairs( self.components) do
            link(getRootNode(), component.node)
        end
    end , "Vehicle - Components Loading" )

    self:addAsyncTask( function ()
        -- root level nodes represent all nodes on root level
        -- components and inactive components which have not been loaded
        -- this is used to initialize the i3D mapping still correctly for the unused component nodes, so we don't have to adjust the whole xml file
            for _, rootLevelNode in ipairs( self.rootLevelNodes) do
                for _, component in ipairs( self.components) do
                    if component.node = = rootLevelNode.node then
                        rootLevelNode.isInactive = false
                    end
                end

                if rootLevelNode.isInactive then
                    -- inactive components are stored hidden in the root component
                    local x, y, z = getWorldTranslation(rootLevelNode.node)
                    local rx, ry, rz = getWorldRotation(rootLevelNode.node)
                    link( self.components[ 1 ].node, rootLevelNode.node)
                    setWorldTranslation(rootLevelNode.node, x, y, z)
                    setWorldRotation(rootLevelNode.node, rx, ry, rz)
                    setRigidBodyType(rootLevelNode.node, RigidBodyType.NONE)

                    I3DUtil.iterateRecursively(rootLevelNode.node, function (node)
                        if getIsCompoundChild(node) then
                            setIsCompoundChild(node, false )
                        end
                    end )
                end
            end

            delete( self.i3dNode)
            self.i3dNode = nil

            self.numComponents = # self.components
            if numComponents ~ = self.numComponents then
                Logging.xmlWarning( self.xmlFile, "I3D file offers '%d' objects, but '%d' components have been loaded!" , numComponents, self.numComponents)
            end

            if Vehicle.DEBUG_RANDOM_FAIL_LOADING and math.random() > 0.75 then
                self.numComponents = 0
            end

            if self.numComponents = = 0 then
                Logging.xmlWarning( self.xmlFile, "No components defined for vehicle!" )
                    self:setLoadingState(VehicleLoadingState.ERROR)
                    self:loadCallback()
                end
            end , "Vehicle - I3D Delete" )

            self:addAsyncTask( function ()
                self.defaultMass = 0
                for j = 1 , # self.components do
                    self.defaultMass = self.defaultMass + self.components[j].defaultMass
                end

                -- load i3d mappings
                self.i3dMappings = { }
                I3DUtil.loadI3DMapping( self.xmlFile, "vehicle" , self.rootLevelNodes, self.i3dMappings, realNumComponents)
            end , "Vehicle - I3D mapping" )

            self:addAsyncTask( function ()
                -- need to be defined in vehicle because all vehicles can define a steering axle ref node
                self.steeringAxleNode = self.xmlFile:getValue( "vehicle.base.steeringAxle#node" , nil , self.components, self.i3dMappings)
                if self.steeringAxleNode = = nil then
                    self.steeringAxleNode = self.components[ 1 ].node
                end

                self:loadSchemaOverlay( self.xmlFile)
            end , "Vehicle - Schema Overlays" )

            self:addAsyncTask( function ()
                -- load component joints
                self.componentJoints = { }

                for componentJointIndex, componentJointKey in self.xmlFile:iterator(componentsKey .. ".joint" ) do
                    local index1 = self.xmlFile:getValue(componentJointKey .. "#component1" )
                    local index2 = self.xmlFile:getValue(componentJointKey .. "#component2" )

                    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, componentJointKey .. "#index" , componentJointKey .. "#node" ) --FS17 to FS19

                    if index1 = = nil or index2 = = nil then
                        Logging.xmlWarning( self.xmlFile, "Missing component index in component joint '%s'" , componentJointKey)
                        break
                    end

                    local jointNode = self.xmlFile:getValue(componentJointKey .. "#node" , nil , self.components, self.i3dMappings)
                    if jointNode ~ = nil and jointNode ~ = 0 then
                        local jointDesc = { }
                        if self:loadComponentJointFromXML(jointDesc, self.xmlFile, componentJointKey, componentJointIndex - 1 , jointNode, index1, index2) then
                            table.insert( self.componentJoints, jointDesc)
                            jointDesc.index = # self.componentJoints
                        end
                    end
                end
            end , "Vehicle - Component Joints" )

            self:addAsyncTask( function ()
                self.collisionPairs = { }
                for collisionPairIndex, collisionPairKey in self.xmlFile:iterator(componentsKey .. ".collisionPair" ) do
                    local enabled = self.xmlFile:getValue(collisionPairKey .. "#enabled" )
                    local index1 = self.xmlFile:getValue(collisionPairKey .. "#component1" )
                    local index2 = self.xmlFile:getValue(collisionPairKey .. "#component2" )
                    if index1 ~ = nil and index2 ~ = nil and enabled ~ = nil then
                        local component1 = self.components[index1]
                        local component2 = self.components[index2]
                        if component1 ~ = nil and component2 ~ = nil then
                            if not enabled then
                                table.insert( self.collisionPairs, { component1 = component1, component2 = component2, enabled = enabled } )
                            end
                        else
                                Logging.xmlWarning( self.xmlFile, "Failed to load collision pair '%s'.Unknown component indices.Indices start with 1." , collisionPairKey)
                            end
                        end
                    end
                end , "Vehicle - Collision Pairs" )

                self:addAsyncTask( function ()
                    self.supportsRadio = self.xmlFile:getValue( "vehicle.base.supportsRadio" , true )
                    self.allowsInput = self.xmlFile:getValue( "vehicle.base.input#allowed" , true )
                    self.size = StoreItemUtil.getSizeValuesFromXML( self.configFileName, self.xmlFile, "vehicle" , 0 , self.configurations)
                end , "Vehicle - Size" )

                self:addAsyncTask( function ()
                    self.yRotationOffset = self.xmlFile:getValue( "vehicle.base.size#yRotation" , 0.0 )
                    self.showTailwaterDepthWarning = false
                    self.thresholdTailwaterDepthWarning = self.xmlFile:getValue( "vehicle.base.tailwaterDepth#warning" , self.size.height * 0.25 )
                    self.thresholdTailwaterDepth = self.xmlFile:getValue( "vehicle.base.tailwaterDepth#threshold" , self.size.height * 0.75 )
                    self.networkTimeInterpolator = InterpolationTime.new( 1.2 )
                    self.movingDirection = 0
                    self.rotatedTime = 0
                    self.isBroken = false
                    self.forceIsActive = false
                    self.finishedFirstUpdate = false
                    self.lastPosition = nil
                    self.lastSpeed = 0
                    self.lastSpeedReal = 0
                    self.lastSpeedSmoothed = 0
                    self.lastSignedSpeed = 0
                    self.lastSignedSpeedReal = 0
                    self.lastMovedDistance = 0
                    self.lastSpeedAcceleration = 0
                    self.lastMoveTime = - 10000
                    self.operatingTime = 0
                    self.allowSelection = self.xmlFile:getValue( "vehicle.base.selection#allowed" , true )

                    self.isInWater = false
                    self.isInShallowWater = false
                    self.isInMediumWater = false
                    self.waterY = - 200
                    self.tailwaterDepth = - 200
                    self.waterCheckPosition = { 0 , 0 , 0 }

                    self.currentSelection = { object = nil , index = 0 , subIndex = 1 }
                    self.selectionObject = { index = 0 , isSelected = false , vehicle = self , subSelections = { } }

                    self.childVehicles = { self } -- table including all attached children and the vehicle itself
                    self.childVehicleHash = "" -- string with each child vehicles table address(can be used to compare and detect if the vehicles have been changed)
                        self.rootVehicle = self

                        self.registeredActionEvents = { }
                        self.actionEventUpdateRequested = false
                        self.vehicleDirtyFlag = self:getNextDirtyFlag()

                        if g_currentMission ~ = nil and g_currentMission.environment ~ = nil then
                            g_messageCenter:subscribe(MessageType.DAY_CHANGED, self.dayChanged, self )
                            g_messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.periodChanged, self )
                        end

                        self.mapHotspotAvailable = self.xmlFile:getValue( "vehicle.base.mapHotspot#available" , true )
                        if self.mapHotspotAvailable then
                            local hotspotType = self.xmlFile:getValue( "vehicle.base.mapHotspot#type" , "OTHER" )
                            self.mapHotspotType = VehicleHotspot.getTypeByName(hotspotType) or VehicleHotspot.TYPE.OTHER
                        end

                        self.directionReferenceNode = self.xmlFile:getValue(componentsKey .. "#directionReferenceNode" , nil , self.components, self.i3dMappings)

                        local speedLimit = math.huge
                        for _, spec in ipairs( self.specializations) do
                            if spec.getDefaultSpeedLimit ~ = nil then
                                local limit = spec.getDefaultSpeedLimit( self )
                                speedLimit = math.min(limit, speedLimit)
                            end
                        end

                        self.checkSpeedLimit = speedLimit = = math.huge
                        self.speedLimit = self.xmlFile:getValue( "vehicle.base.speedLimit#value" , speedLimit)
                    end , "Vehicle - Various Data" )

                    self:addAsyncTask( function ()
                        local objectChanges = { }
                        ObjectChangeUtil.loadObjectChangeFromXML( self.xmlFile, "vehicle.base.objectChanges" , objectChanges, self.components, self )
                        ObjectChangeUtil.setObjectChanges(objectChanges, true )
                    end , "Vehicle - Object Change Loading" )

                    self:addAsyncTask( function ()
                        ConfigurationUtil.raiseConfigurationItemEvent( self , "onLoad" )
                    end , "Vehicle - Configurations OnLoad" )

                    self:addAsyncTask( function ()
                        SpecializationUtil.raiseAsyncEvent( self , "onLoad" , self.savegame)
                    end )

                    self:addAsyncTask( function ()
                        if self.loadingState ~ = VehicleLoadingState.OK then
                            Logging.xmlError( self.xmlFile, "Vehicle loading failed!" )
                            self:loadCallback()
                        end
                    end , nil , true )

                    self:addAsyncTask( function ()
                        if Platform.gameplay.automaticVehicleControl then
                            if self.actionController ~ = nil then
                                self.actionController:load( self.savegame)
                            end
                        end

                        SpecializationUtil.raiseEvent( self , "onRootVehicleChanged" , self )

                        -- move all components that are joint to other components to the joint node, so all specializations can move them in there postLoad
                        if self.isServer then
                            for _, jointDesc in pairs( self.componentJoints) do
                                if jointDesc.initComponentPosition then
                                    local component2 = self.components[jointDesc.componentIndices[ 2 ]].node
                                    local jointNode = jointDesc.jointNode

                                    if self:getParentComponent(jointNode) = = component2 then
                                        jointNode = jointDesc.jointNodeActor1
                                    end

                                    if self:getParentComponent(jointNode) ~ = component2 then
                                        setTranslation(component2, localToLocal(component2, jointNode, 0 , 0 , 0 ))
                                        setRotation(component2, localRotationToLocal(component2, jointNode, 0 , 0 , 0 ))
                                        link(jointNode, component2)
                                    end
                                end
                            end
                        end
                    end )

                    self:addAsyncTask( function ()
                        ConfigurationUtil.raiseConfigurationItemEvent( self , "onPrePostLoad" )

                        self:setLoadingStep(SpecializationLoadStep.POST_LOAD)
                    end )

                    self:addAsyncTask( function ()
                        SpecializationUtil.raiseAsyncEvent( self , "onPostLoad" , self.savegame)
                    end )

                    self:addAsyncTask( function ()
                        ConfigurationUtil.raiseConfigurationItemEvent( self , "onPostLoad" )
                    end )

                    self:addAsyncTask( function ()
                        if self.loadingState ~ = VehicleLoadingState.OK then
                            Logging.xmlError( self.xmlFile, "Vehicle post-loading failed!" )
                            self:loadCallback()
                        end
                    end , nil , true )

                    self:addAsyncTask( function ()
                        SpecializationUtil.raiseAsyncEvent( self , "onPreInitComponentPlacement" , self.savegame)
                    end )

                    self:addAsyncTask( function ()
                        if self.loadingState ~ = VehicleLoadingState.OK then
                            Logging.xmlError( self.xmlFile, "Vehicle pre init component placement failed!" )
                            self:loadCallback()
                        end
                    end , nil , true )

                    self:addAsyncTask( function ()
                        -- move all components that are joint to other components back to the world, so the changes from the specs post load is applied to the world trans/rot
                        if self.isServer then
                            for _, jointDesc in pairs( self.componentJoints) do
                                if jointDesc.initComponentPosition then
                                    local component2 = self.components[jointDesc.componentIndices[ 2 ]]
                                    local jointNode = jointDesc.jointNode

                                    if self:getParentComponent(jointNode) = = component2.node then
                                        jointNode = jointDesc.jointNodeActor1
                                    end

                                    if self:getParentComponent(jointNode) ~ = component2.node then
                                        if getParent(component2.node) = = jointNode then
                                            local ox, oy, oz = 0 , 0 , 0
                                            if jointDesc.jointNodeActor1 ~ = jointDesc.jointNode then
                                                local x1, y1, z1 = localToLocal(jointDesc.jointNode, component2.node, 0 , 0 , 0 )
                                                local x2, y2, z2 = localToLocal(jointDesc.jointNodeActor1, component2.node, 0 , 0 , 0 )
                                                ox, oy, oz = x1 - x2, y1 - y2, z1 - z2
                                            end

                                            local x, y, z = localToWorld(component2.node, ox, oy, oz)
                                            local rx, ry, rz = localRotationToWorld(component2.node, 0 , 0 , 0 )

                                            link(getRootNode(), component2.node)
                                            setWorldTranslation(component2.node, x, y, z)
                                            setWorldRotation(component2.node, rx, ry, rz)

                                            component2.originalTranslation = { x, y, z }
                                            component2.originalRotation = { rx, ry, rz }

                                            component2.sentTranslation = { x, y, z }
                                            component2.sentRotation = { rx, ry, rz }
                                        end
                                    end
                                end
                            end

                            for _, jointDesc in pairs( self.componentJoints) do
                                self:setComponentJointFrame(jointDesc, 0 )
                                self:setComponentJointFrame(jointDesc, 1 )
                            end
                        end

                        local savegame = self.savegame
                        if savegame ~ = nil then
                            self.age = savegame.xmlFile:getValue(savegame.key .. "#age" , 0 )
                            self.price = savegame.xmlFile:getValue(savegame.key .. "#price" , self.price)

                            self.propertyState = VehiclePropertyState.loadFromXMLFile(savegame.xmlFile, savegame.key .. "#propertyState" ) or self.propertyState

                            local operatingTime = savegame.xmlFile:getValue(savegame.key .. "#operatingTime" , self.operatingTime) * 1000
                            self:setOperatingTime(operatingTime, true )

                            local isBroken = savegame.xmlFile:getValue(savegame.key .. "#isBroken" , self.isBroken)
                            if not savegame.resetVehicles and isBroken then
                                self:setBroken()
                            end
                        end

                        if not self.vehicleLoadingData:applyPositionData( self ) then
                            self:setLoadingState(VehicleLoadingState.NO_SPACE)
                            self:loadCallback()
                            return
                        end
                    end , "Vehicle - Components Linking" )

                    self:addAsyncTask( function ()
                        self:updateSelectableObjects()
                        self:setSelectedVehicle( self , nil , true )

                        if self.rootVehicle = = self then
                            local savegame = self.savegame
                            if savegame ~ = nil then
                                self.loadedSelectedObjectIndex = savegame.xmlFile:getValue(savegame.key .. "#selectedObjectIndex" )
                                self.loadedSubSelectedObjectIndex = savegame.xmlFile:getValue(savegame.key .. "#subSelectedObjectIndex" )
                            end
                        end

                        SpecializationUtil.raiseEvent( self , "onPreLoadFinished" , self.savegame)

                        -- hide vehicle and remove from physics as long as the sub tasks are not finished
                        self:setVisibility( false )

                        if # self.loadingTasks = = 0 then
                            self:onFinishedLoading()
                        else
                                self.readyForFinishLoading = true
                                self:setLoadingStep(SpecializationLoadStep.AWAIT_SUB_I3D)
                            end
                        end , "Vehicle - Finalize Loading" )
                    end

```

### loadObjectChangeValuesFromXML

**Description**

> Load object change from xml

**Definition**

> loadObjectChangeValuesFromXML(integer xmlFile, string key, integer node, table object)

**Arguments**

| integer | xmlFile | id of xml object |
|---------|---------|------------------|
| string  | key     | key              |
| integer | node    | node id          |
| table   | object  | object           |

**Code**

```lua
function Vehicle:loadObjectChangeValuesFromXML(xmlFile, key, node, object)
end

```

### loadSchemaOverlay

**Description**

> Load schema overlay data from xml file
> The HUD draws the schema from this information and handles all required visual components.

**Definition**

> loadSchemaOverlay(XMLFile xmlFile)

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|

**Code**

```lua
function Vehicle:loadSchemaOverlay(xmlFile)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#file" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#width" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#height" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#invisibleBorderRight" , "vehicle.base.schemaOverlay#invisibleBorderRight" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#invisibleBorderLeft" , "vehicle.base.schemaOverlay#invisibleBorderLeft" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#attacherJointPosition" , "vehicle.base.schemaOverlay#attacherJointPosition" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#basePosition" , "vehicle.base.schemaOverlay#basePosition" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#fileSelected" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#fileTurnedOn" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.schemaOverlay#fileSelectedTurnedOn" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.schemaOverlay.default#name" , "vehicle.base.schemaOverlay#name" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.schemaOverlay.turnedOn#name" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.schemaOverlay.selected#name" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.base.schemaOverlay.turnedOnSelected#name" ) --FS19 to FS22

    if xmlFile:hasProperty( "vehicle.base.schemaOverlay" ) then
        XMLUtil.checkDeprecatedXMLElements(xmlFile, "vehicle.schemaOverlay.attacherJoint" , "vehicle.attacherJoints.attacherJoint.schema" ) -- FS17

        local x, y = xmlFile:getValue( "vehicle.base.schemaOverlay#attacherJointPosition" )
        local baseX, baseY = xmlFile:getValue( "vehicle.base.schemaOverlay#basePosition" )

        if baseX = = nil then
            baseX = x
        end

        if baseY = = nil then
            baseY = y
        end

        local schemaName = xmlFile:getValue( "vehicle.base.schemaOverlay#name" , "" )

        local modPrefix = self.customEnvironment or ""
        schemaName = Vehicle.prefixSchemaOverlayName(schemaName, modPrefix)

        self.schemaOverlay = VehicleSchemaOverlayData.new(
        baseX, baseY,
        schemaName,
        xmlFile:getValue( "vehicle.base.schemaOverlay#invisibleBorderRight" ),
        xmlFile:getValue( "vehicle.base.schemaOverlay#invisibleBorderLeft" ))
    end
end

```

### loadSpecValueAdditionalWeight

**Description**

**Definition**

> loadSpecValueAdditionalWeight()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Vehicle.loadSpecValueAdditionalWeight(xmlFile, customEnvironment, baseDir)
    local maxWeight = xmlFile:getValue( "vehicle.base.components#maxMass" )
    if maxWeight ~ = nil then
        return maxWeight / 1000
    end

    return nil
end

```

### loadSpecValueCombinations

**Description**

**Definition**

> loadSpecValueCombinations()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDirectory     |

**Code**

```lua
function Vehicle.loadSpecValueCombinations(xmlFile, customEnvironment, baseDirectory)
    local combinations = { }

    xmlFile:iterate( "vehicle.storeData.specs.combination" , function (index, key)
        local combinationData = { }
        local xmlFilename = xmlFile:getValue(key .. "#xmlFilename" )
        if xmlFilename ~ = nil then
            combinationData.xmlFilename = Utils.getFilename(xmlFilename)
            combinationData.customXMLFilename = Utils.getFilename(xmlFilename, baseDirectory)

            local storeItem = g_storeManager:getItemByXMLFilename(combinationData.customXMLFilename)
            if storeItem = = nil then
                storeItem = g_storeManager:getItemByXMLFilename(combinationData.xmlFilename)
            end
            if storeItem = = nil then
                Logging.xmlWarning(xmlFile, "Could not find combination vehicle '%s'" , combinationData.xmlFilename)
            end
        end

        local filterCategoryStr = xmlFile:getValue(key .. "#filterCategory" )
        if filterCategoryStr ~ = nil then
            combinationData.filterCategories = filterCategoryStr:split( " " )
        end

        combinationData.filterSpec = xmlFile:getValue(key .. "#filterSpec" )
        combinationData.filterSpecMin = xmlFile:getValue(key .. "#filterSpecMin" , 0 )
        combinationData.filterSpecMax = xmlFile:getValue(key .. "#filterSpecMax" , 1 )

        if combinationData.xmlFilename ~ = nil or combinationData.filterCategories ~ = nil or combinationData.filterSpec then
            table.insert(combinations, combinationData)
        end
    end )

    return combinations
end

```

### loadSpecValueSpeedLimit

**Description**

**Definition**

> loadSpecValueSpeedLimit()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Vehicle.loadSpecValueSpeedLimit(xmlFile, customEnvironment, baseDir)
    return xmlFile:getValue( "vehicle.base.speedLimit#value" )
end

```

### loadSpecValueWeight

**Description**

**Definition**

> loadSpecValueWeight()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Vehicle.loadSpecValueWeight(xmlFile, customEnvironment, baseDir)
    local massData = { }
    massData.componentMass = 0
    for _, key in xmlFile:iterator( "vehicle.base.components.component" ) do
        local mass = xmlFile:getValue(key .. "#mass" , 0 ) / 1000

        massData.componentMass = massData.componentMass + mass
    end

    local hasConfigMass = false
    massData.configurations = { }
    for configIndex, configKey in xmlFile:iterator( "vehicle.base.componentConfigurations.componentConfiguration" ) do
        local configMass = 0
        for _, componentKey in xmlFile:iterator(configKey .. ".component" ) do
            local mass = xmlFile:getValue(componentKey .. "#mass" , 0 ) / 1000

            configMass = configMass + mass
            hasConfigMass = true
        end
        massData.configurations[configIndex] = configMass
    end

    massData.fillUnitMassData = FillUnit.loadSpecValueFillUnitMassData(xmlFile, customEnvironment, baseDir)
    massData.wheelMassDefaultConfig = Wheels.loadSpecValueWheelWeight(xmlFile, customEnvironment, baseDir)

    local configMin, configMax
    massData.storeDataConfigs = { }
    for _, key in xmlFile:iterator( "vehicle.storeData.specs.weight.config" ) do
        local config = { }
        config.name = xmlFile:getValue(key .. "#name" )
        if config.name ~ = nil then
            config.index = xmlFile:getValue(key .. "#index" , 1 )
            config.value = xmlFile:getValue(key .. "#value" , 0 ) / 1000

            configMin = math.min(configMin or math.huge, config.value * 1000 )
            configMax = math.max(configMax or - math.huge, config.value * 1000 )

            table.insert(massData.storeDataConfigs, config)
        end
    end

    if #massData.storeDataConfigs = = 0 then
        massData.storeDataConfigs = nil
    end

    if not xmlFile:getValue( "vehicle.storeData.specs.weight#ignore" , false ) then
        massData.storeDataMin = xmlFile:getValue( "vehicle.storeData.specs.weight#minValue" , configMin)
        massData.storeDataMax = xmlFile:getValue( "vehicle.storeData.specs.weight#maxValue" , configMax)

        if massData.componentMass > 0 or hasConfigMass or massData.storeDataMin ~ = nil then
            return massData
        end
    end

    return nil
end

```

### loadSpecValueWorkingWidth

**Description**

**Definition**

> loadSpecValueWorkingWidth()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Vehicle.loadSpecValueWorkingWidth(xmlFile, customEnvironment, baseDir)
    local width = xmlFile:getValue( "vehicle.storeData.specs.workingWidth" )
    if width = = nil then
        return nil
    end

    local minWidth = xmlFile:getValue( "vehicle.storeData.specs.workingWidth#minWidth" , width)
    return { width = width, minWidth = minWidth }
end

```

### loadSpecValueWorkingWidthConfig

**Description**

**Definition**

> loadSpecValueWorkingWidthConfig()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Vehicle.loadSpecValueWorkingWidthConfig(xmlFile, customEnvironment, baseDir)
    local workingWidths = nil

    for name, configDesc in pairs(g_vehicleConfigurationManager:getConfigurations()) do
        for configurationIndex, configurationKey in xmlFile:iterator(configDesc.configurationKey) do
            local workingWidth = xmlFile:getValue(configurationKey .. "#workingWidth" )
            if workingWidth ~ = nil then
                workingWidths = workingWidths or { }
                workingWidths[name] = workingWidths[name] or { }
                workingWidths[name][configurationIndex] = { width = workingWidth, isSelectable = xmlFile:getValue(configurationKey .. "#isSelectable" , true ) }
            end
        end
    end

    return workingWidths
end

```

### loadSubSharedI3DFile

**Description**

**Definition**

> loadSubSharedI3DFile()

**Arguments**

| any | filename               |
|-----|------------------------|
| any | callOnCreate           |
| any | addToPhysics           |
| any | asyncCallbackFunction  |
| any | asyncCallbackObject    |
| any | asyncCallbackArguments |

**Code**

```lua
function Vehicle:loadSubSharedI3DFile(filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)

    local loadingTask = self:createLoadingTask( self )

    -- If a callback function was given, and the loading has not yet finished, handle the callback.
        if asyncCallbackFunction ~ = nil then

            -- Wrap the callback function.
                local targetAsyncCallbackFunction = asyncCallbackFunction
                asyncCallbackFunction = function (target, i3dNode, failedReason, args)
                    -- If the type class has been marked for deletion while the loading was taken place, undo the loading.
                        if self.isDeleted or self.isDeleting then
                            if i3dNode ~ = 0 then
                                delete(i3dNode)
                            end

                            targetAsyncCallbackFunction(target, 0 , failedReason, args)
                            self:finishLoadingTask(loadingTask)

                            return
                        end

                        targetAsyncCallbackFunction(target, i3dNode, failedReason, args)
                        self:finishLoadingTask(loadingTask)
                    end

                    -- Debug check for if the callback function is missing, or loading has already finished.
                        --#debug else
                            --#debug if asyncCallbackFunction = = nil then
                                --#debug Logging.error("loadSubSharedI3DFile:no asyncCallbackFunction defined")
                                --#debug elseif self.syncVehicleLoadingFinished then
                                    --#debug Logging.error("loadSubSharedI3DFile:syncVehicleLoadingFinished")
                                    --#debug end
                                    --#debug printCallstack()
                                end

                                -- Start loading the file and return the id.
                                local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)

                                return sharedLoadRequestId
                            end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | isClient |
| any | customMt |

**Code**

```lua
function Vehicle.new(isServer, isClient, customMt)

    local self = Object.new(isServer, isClient, customMt or Vehicle _mt)

    self.finishedLoading = false
    self.isDeleted = false
    self.updateLoopIndex = - 1
    self.sharedLoadRequestId = nil
    self.loadingState = VehicleLoadingState.OK
    self.loadingStep = SpecializationLoadStep.CREATED

    self.loadingTasks = { }
    self.readyForFinishLoading = false

    -- The unique id of vehicle used to reference it from elsewhere.
    self.uniqueId = nil

    self.actionController = VehicleActionController.new( self )

    return self
end

```

### onFinishedLoading

**Description**

**Definition**

> onFinishedLoading()

**Code**

```lua
function Vehicle:onFinishedLoading()
    if self.isServer then
        -- Only servers add to physics and make visible now.Clients will do this later in postReadStream
            self:setVisibility( true )
            self:addToPhysics()
        end

        self:setLoadingStep(SpecializationLoadStep.FINISHED)
        SpecializationUtil.raiseEvent( self , "onLoadFinished" , self.savegame)

        ConfigurationUtil.raiseConfigurationItemEvent( self , "onLoadFinished" )

        -- if we are the server or in single player we don't need to be synchronized
            if self.isServer then
                self:setLoadingStep(SpecializationLoadStep.SYNCHRONIZED)
            end

            if g_currentMission ~ = nil and self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG and self.mapHotspotAvailable then
                self:createMapHotspot()
            end

            self.finishedLoading = true

            if not g_currentMission.vehicleSystem:addVehicle( self ) then
                Logging.xmlError( self.xmlFile, "Failed to register vehicle!" )
                self:setLoadingState(VehicleLoadingState.ERROR)
                self:loadCallback()
                return
            end

            if self.propertyState = = VehiclePropertyState.OWNED then
                g_currentMission:addOwnedItem( self )
            elseif self.propertyState = = VehiclePropertyState.LEASED then
                    g_currentMission:addLeasedItem( self )
                end

                if self.vehicleLoadingData.isRegistered then
                    self:register()
                end

                SpecializationUtil.raiseEvent( self , "onLoadEnd" , self.savegame)

                self:loadCallback()
                self.savegame = nil

                self.vehicleLoadingData = nil
            end

```

### onVehicleWakeUpCallback

**Description**

**Definition**

> onVehicleWakeUpCallback()

**Arguments**

| any | id |
|-----|----|

**Code**

```lua
function Vehicle:onVehicleWakeUpCallback(id)
    self:raiseActive()
end

```

### onWaterRaycastCallback

**Description**

**Definition**

> onWaterRaycastCallback()

**Arguments**

| any | nodeId        |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |
| any | distance      |
| any | nx            |
| any | ny            |
| any | nz            |
| any | subShapeIndex |
| any | shapeId       |
| any | isLast        |

**Code**

```lua
function Vehicle:onWaterRaycastCallback(nodeId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast)
    self.waterCheckIsPending = false

    local checkY = self.waterCheckPosition[ 2 ] - self.size.height * 0.5
    local waterY = y
    if nodeId = = 0 then
        waterY = - 2500
    end
    self.waterY = waterY
    self.isInWater = waterY > checkY
    self.isInShallowWater = false
    self.isInMediumWater = false
    if self.isInWater then
        local checkX, checkZ = self.waterCheckPosition[ 1 ], self.waterCheckPosition[ 3 ]
        local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, checkX, 0 , checkZ)
        local waterDepth = math.max( 0 , waterY - terrainHeight)
        self.isInShallowWater = waterDepth < = 0.5
        self.isInMediumWater = not self.isInShallowWater
    end
    self.tailwaterDepth = math.max( 0 , waterY - checkY)

    return false
end

```

### periodChanged

**Description**

> Called if period changed

**Definition**

> periodChanged()

**Code**

```lua
function Vehicle:periodChanged()
    self.age = self.age + 1
end

```

### playControlledActions

**Description**

**Definition**

> playControlledActions()

**Code**

```lua
function Vehicle:playControlledActions()
    if self.actionController ~ = nil then
        self.actionController:playControlledActions()
    end
end

```

### postInit

**Description**

**Definition**

> postInit()

**Code**

```lua
function Vehicle.postInit()
    local schema = Vehicle.xmlSchema
    local schemaSavegame = Vehicle.xmlSchemaSavegame

    local configurations = g_vehicleConfigurationManager:getConfigurations()
    for _, configuration in pairs(configurations) do
        g_asyncTaskManager:addSubtask( function ()
            if configuration.itemClass.registerXMLPaths ~ = nil then
                configuration.itemClass.registerXMLPaths(schema, configuration.configurationsKey, configuration.configurationKey .. "(?)" )
            end

            schema:register(XMLValueType.FLOAT, configuration.configurationKey .. "(?)#workingWidth" , "Work width to display in shop while config is active" )
                schema:register(XMLValueType.L10N_STRING, configuration.configurationKey .. "(?)#typeDesc" , "Type description text to display in shop while config is active" )

                    if configuration.itemClass.registerSavegameXMLPaths ~ = nil then
                        configuration.itemClass.registerSavegameXMLPaths(schemaSavegame, "vehicles.vehicle(?).configuration(?)" )

                        -- for backward compatibility
                            configuration.itemClass.registerSavegameXMLPaths(schemaSavegame, "vehicles.vehicle(?).boughtConfiguration(?)" )
                        end
                    end )
                end
            end

```

### postReadStream

**Description**

> Called on client side on join when the vehicle was fully loaded

**Definition**

> postReadStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function Vehicle:postReadStream(streamId, connection)
    -- remove from physics to set static components correctly(normally they should not be added yet)
    self:removeFromPhysics()

    local paramsXZ = self.highPrecisionPositionSynchronization and( self.vehicleXZPosHighPrecisionCompressionParams or g_currentMission.vehicleXZPosHighPrecisionCompressionParams) or( self.vehicleXZPosCompressionParams or g_currentMission.vehicleXZPosCompressionParams)
    local paramsY = self.highPrecisionPositionSynchronization and( self.vehicleYPosHighPrecisionCompressionParams or g_currentMission.vehicleYPosHighPrecisionCompressionParams) or( self.vehicleYPosCompressionParams or g_currentMission.vehicleYPosCompressionParams)
    for i = 1 , # self.components do
        local component = self.components[i]
        local x = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        local y = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
        local z = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
        local x_rot = NetworkUtil.readCompressedAngle(streamId)
        local y_rot = NetworkUtil.readCompressedAngle(streamId)
        local z_rot = NetworkUtil.readCompressedAngle(streamId)

        local qx,qy,qz,qw = mathEulerToQuaternion(x_rot,y_rot,z_rot)
        self:setWorldPositionQuaternion(x,y,z, qx,qy,qz,qw, i, true )

        component.networkInterpolators.position:setPosition(x,y,z)
        component.networkInterpolators.quaternion:setQuaternion(qx,qy,qz,qw)
    end
    self.networkTimeInterpolator:reset()

    -- add to physics and make visible
    self:setVisibility( true )
    self:addToPhysics()

    self.serverMass = streamReadFloat32(streamId)
    self.age = streamReadUInt16(streamId)
    self:setOperatingTime(streamReadFloat32(streamId), true )
    self.price = streamReadInt32(streamId)
    self.isBroken = streamReadBool(streamId)

    if Vehicle.DEBUG_NETWORK_READ_WRITE then
        print( "-------------------------------------------------------------" )
        print( self.configFileName)
        for _, spec in ipairs( self.eventListeners[ "onReadStream" ]) do
            local className = ClassUtil.getClassName(spec)
            local startBits = streamGetReadOffset(streamId)
            spec[ "onReadStream" ]( self , streamId, connection)
            print( " " .. tostring(className) .. " read " .. streamGetReadOffset(streamId) - startBits .. " bits" )
        end
    else
            SpecializationUtil.raiseEvent( self , "onReadStream" , streamId, connection)
        end

        self:setLoadingStep(SpecializationLoadStep.SYNCHRONIZED)
    end

```

### postWriteStream

**Description**

> Called on server side when vehicle is fully loaded on client side

**Definition**

> postWriteStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function Vehicle:postWriteStream(streamId, connection)
    local paramsXZ = self.highPrecisionPositionSynchronization and( self.vehicleXZPosHighPrecisionCompressionParams or g_currentMission.vehicleXZPosHighPrecisionCompressionParams) or( self.vehicleXZPosCompressionParams or g_currentMission.vehicleXZPosCompressionParams)
    local paramsY = self.highPrecisionPositionSynchronization and( self.vehicleYPosHighPrecisionCompressionParams or g_currentMission.vehicleYPosHighPrecisionCompressionParams) or( self.vehicleYPosCompressionParams or g_currentMission.vehicleYPosCompressionParams)
    for i = 1 , # self.components do
        local component = self.components[i]
        local x,y,z = getWorldTranslation(component.node)
        local x_rot,y_rot,z_rot = getWorldRotation(component.node)
        NetworkUtil.writeCompressedWorldPosition(streamId, x, paramsXZ)
        NetworkUtil.writeCompressedWorldPosition(streamId, y, paramsY)
        NetworkUtil.writeCompressedWorldPosition(streamId, z, paramsXZ)
        NetworkUtil.writeCompressedAngle(streamId, x_rot)
        NetworkUtil.writeCompressedAngle(streamId, y_rot)
        NetworkUtil.writeCompressedAngle(streamId, z_rot)
    end

    streamWriteFloat32(streamId, self.serverMass)
    streamWriteUInt16(streamId, self.age)
    streamWriteFloat32(streamId, self.operatingTime)
    streamWriteInt32(streamId, self.price)
    streamWriteBool(streamId, self.isBroken)

    if Vehicle.DEBUG_NETWORK_READ_WRITE then
        print( "-------------------------------------------------------------" )
        print( self.configFileName)
        for _, spec in ipairs( self.eventListeners[ "onWriteStream" ]) do
            local className = ClassUtil.getClassName(spec)
            local startBits = streamGetWriteOffset(streamId)
            spec[ "onWriteStream" ]( self , streamId, connection)
            print( " " .. tostring(className) .. " Wrote " .. streamGetWriteOffset(streamId) - startBits .. " bits" )
        end
    else
            SpecializationUtil.raiseEvent( self , "onWriteStream" , streamId, connection)
        end
    end

```

### raiseStateChange

**Description**

**Definition**

> raiseStateChange()

**Arguments**

| any | state |
|-----|-------|
| any | ...   |

**Code**

```lua
function Vehicle:raiseStateChange(state, .. .)
    --#debug Assert.isNotNil(state)
    SpecializationUtil.raiseEvent( self , "onStateChange" , state, .. .)
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, table connection, )

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| any     | objectId   |            |

**Code**

```lua
function Vehicle:readStream(streamId, connection, objectId)
    Vehicle:superClass().readStream( self , streamId, connection, objectId)

    local filename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))

    local configurations, boughtConfigurations, configurationData = ConfigurationUtil.readConfigurationsFromStream(g_vehicleConfigurationManager, streamId, connection, filename)

    self.propertyState = VehiclePropertyState.readStream(streamId)

    if self.loadingStep ~ = SpecializationLoadStep.CREATED then
        Logging.error( "Try to intialize loading of a vehicle that is already loading!" )
        return
    end

    local data = VehicleLoadingData.new()
    data:setFilename(filename)
    data:setPropertyState( self.propertyState)
    data:setOwnerFarmId( self.ownerFarmId)
    data:setConfigurations(configurations)
    data:setBoughtConfigurations(boughtConfigurations)
    data:setConfigurationData(configurationData)

    local asyncCallbackFunction = function (_, vehicle, loadingState)
        if loadingState = = VehicleLoadingState.OK then
            g_client:onObjectFinishedAsyncLoading(vehicle)
        else
                Logging.error( "Failed to load vehicle on client" )
                printCallstack()
            end
        end

        data:loadVehicleOnClient( self , asyncCallbackFunction, nil )
    end

```

### readUpdateStream

**Description**

> Called on client side on update

**Definition**

> readUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Vehicle:readUpdateStream(streamId, timestamp, connection)
    if connection.isServer then
        local hasUpdate = streamReadBool(streamId)
        if hasUpdate then
            self.networkTimeInterpolator:startNewPhaseNetwork()

            local paramsXZ = self.highPrecisionPositionSynchronization and( self.vehicleXZPosHighPrecisionCompressionParams or g_currentMission.vehicleXZPosHighPrecisionCompressionParams) or( self.vehicleXZPosCompressionParams or g_currentMission.vehicleXZPosCompressionParams)
            local paramsY = self.highPrecisionPositionSynchronization and( self.vehicleYPosHighPrecisionCompressionParams or g_currentMission.vehicleYPosHighPrecisionCompressionParams) or( self.vehicleYPosCompressionParams or g_currentMission.vehicleYPosCompressionParams)
            for i = 1 , # self.components do
                local component = self.components[i]
                if not component.isStatic then
                    local x = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
                    local y = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
                    local z = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
                    local x_rot = NetworkUtil.readCompressedAngle(streamId)
                    local y_rot = NetworkUtil.readCompressedAngle(streamId)
                    local z_rot = NetworkUtil.readCompressedAngle(streamId)
                    local qx,qy,qz,qw = mathEulerToQuaternion(x_rot,y_rot,z_rot)

                    component.networkInterpolators.position:setTargetPosition(x,y,z)
                    component.networkInterpolators.quaternion:setTargetQuaternion(qx,qy,qz,qw)
                end
            end
            SpecializationUtil.raiseEvent( self , "onReadPositionUpdateStream" , streamId, connection)
        end
    end

    if Vehicle.DEBUG_NETWORK_READ_WRITE_UPDATE then
        print( "-------------------------------------------------------------" )
        print( self.configFileName)
        for _, spec in ipairs( self.eventListeners[ "onReadUpdateStream" ]) do
            local className = ClassUtil.getClassName(spec)
            local startBits = streamGetReadOffset(streamId)
            spec[ "onReadUpdateStream" ]( self , streamId, timestamp, connection)
            print( " " .. tostring(className) .. " read " .. streamGetReadOffset(streamId) - startBits .. " bits" )
        end
    else
            SpecializationUtil.raiseEvent( self , "onReadUpdateStream" , streamId, timestamp, connection)
        end
    end

```

### register

**Description**

**Definition**

> register()

**Arguments**

| any | alreadySent |
|-----|-------------|

**Code**

```lua
function Vehicle:register(alreadySent)
    Vehicle:superClass().register( self , alreadySent)

    SpecializationUtil.raiseEvent( self , "onRegistered" , alreadySent)
end

```

### registerActionEvents

**Description**

**Definition**

> registerActionEvents()

**Arguments**

| any | excludedVehicle |
|-----|-----------------|

**Code**

```lua
function Vehicle:registerActionEvents(excludedVehicle)
    if not g_gui:getIsGuiVisible() and not g_currentMission.isPlayerFrozen and excludedVehicle ~ = self then
        self.actionEventUpdateRequested = false

        local isActiveForInput = self:getIsActiveForInput()
        local isActiveForInputIgnoreSelection = self:getIsActiveForInput( true )

        if isActiveForInput then
            -- reset the action binding enabled state for bindings previously disabled during conflict resolution:
                g_inputBinding:resetActiveActionBindings()
            end

            -- safety:set the input registration context without changing the actual input context in case we're currently
            -- not in the vehicle context(e.g.due to network events)
            g_inputBinding:beginActionEventsModification( Vehicle.INPUT_CONTEXT_NAME)

            SpecializationUtil.raiseEvent( self , "onPreRegisterActionEvents" , isActiveForInput, isActiveForInputIgnoreSelection)

            SpecializationUtil.raiseEvent( self , "onRegisterActionEvents" , isActiveForInput, isActiveForInputIgnoreSelection)

            self:clearActionEventsTable( self.actionEvents)
            if self:getCanToggleSelectable() then
                local numSelectableObjects = 0

                for _, object in ipairs( self.selectableObjects) do
                    numSelectableObjects = numSelectableObjects + 1 + #object.subSelections
                end

                if numSelectableObjects > 1 then
                    local _, actionEventId = self:addActionEvent( self.actionEvents, InputAction.SWITCH_IMPLEMENT, self , Vehicle.actionEventToggleSelection, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)

                    _, actionEventId = self:addActionEvent( self.actionEvents, InputAction.SWITCH_IMPLEMENT_BACK, self , Vehicle.actionEventToggleSelectionReverse, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                end
            end

            VehicleDebug.registerActionEvents( self )

            if Platform.gameplay.automaticVehicleControl then
                if self.actionController ~ = nil then
                    if self:getIsActiveForInput( true ) then
                        if self = = self.rootVehicle then
                            self.actionController:registerActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
                        end
                    end
                end
            end

            g_inputBinding:endActionEventsModification()
        end
    end

```

### registerComponentXMLPaths

**Description**

**Definition**

> registerComponentXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Vehicle.registerComponentXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. "#numComponents" , "Number of components loaded from i3d" , "number of components the i3d contains" )
    schema:register(XMLValueType.FLOAT, basePath .. "#maxMass" , "Max.overall mass the vehicle can have" , "unlimited" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#directionReferenceNode" , "Direction node to calculate the current driving direction and speed" )
    schema:register(XMLValueType.INT, basePath .. ".component(?)#index" , "Index of the component node in the i3d hierarchy" )
    schema:register(XMLValueType.FLOAT, basePath .. ".component(?)#mass" , "Mass of component [kg]" , "Mass of component in i3d" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".component(?)#centerOfMass" , "Center of mass in local space(x y z)" , "Center of mass in i3d" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".component(?)#inertiaScale" , "Scales the inertia, defining how the mass is distributed around the object(x y z, x = inertia around the local x axis).Inertia quadratically depends on the object radius.E.g.using an inertiaScale of 4 is equal to having a 2 times larger object along the given axis" , "1 1 1" )
    schema:register(XMLValueType.INT, basePath .. ".component(?)#solverIterationCount" , "Solver iterations count" )
    schema:register(XMLValueType.BOOL, basePath .. ".component(?)#motorized" , "Is motorized component" , "set by motorized specialization" )
    schema:register(XMLValueType.BOOL, basePath .. ".component(?)#collideWithAttachables" , "Collides with attachables" , false )

    schema:register(XMLValueType.INT, basePath .. ".joint(?)#component1" , "First component of the joint" )
    schema:register(XMLValueType.INT, basePath .. ".joint(?)#component2" , "Second component of the joint" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".joint(?)#node" , "Joint node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".joint(?)#nodeActor1" , "Actor node of second component" , "Joint node" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotLimit" , "Rotation limit" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transLimit" , "Translation limit" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotMinLimit" , "Min rotation limit" , "inversed rotation limit" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transMinLimit" , "Min translation limit" , "inversed translation limit" )

    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotLimitSpring" , "Rotation spring limit" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotLimitDamping" , "Rotation damping limit" , "1 1 1" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotLimitForceLimit" , "Rotation limit force limit(-1 = infinite)" , "-1 -1 -1" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transLimitForceLimit" , "Translation limit force limit(-1 = infinite)" , "-1 -1 -1" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transLimitSpring" , "Translation spring limit" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transLimitDamping" , "Translation damping limit" , "1 1 1" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".joint(?)#zRotationNode" , "Position of joints z rotation" )
    schema:register(XMLValueType.BOOL, basePath .. ".joint(?)#breakable" , "Joint is breakable" , false )
    schema:register(XMLValueType.FLOAT, basePath .. ".joint(?)#breakForce" , "Joint force until it breaks" , 10 )
    schema:register(XMLValueType.FLOAT, basePath .. ".joint(?)#breakTorque" , "Joint torque until it breaks" , 10 )
    schema:register(XMLValueType.BOOL, basePath .. ".joint(?)#enableCollision" , "Enable collision between both components" , false )

    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#maxRotDriveForce" , "Max rotational drive force" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotDriveVelocity" , "Rotational drive velocity" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotDriveRotation" , "Rotational drive rotation" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotDriveSpring" , "Rotational drive spring" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#rotDriveDamping" , "Rotational drive damping" , "0 0 0" )

    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transDriveVelocity" , "Translational drive velocity" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transDrivePosition" , "Translational drive position" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transDriveSpring" , "Translational drive spring" , "0 0 0" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#transDriveDamping" , "Translational drive damping" , "1 1 1" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".joint(?)#maxTransDriveForce" , "Max translational drive force" , "0 0 0" )

    schema:register(XMLValueType.BOOL, basePath .. ".joint(?)#initComponentPosition" , "Defines if the component is translated and rotated during loading based on joint movement" , true )

        schema:register(XMLValueType.BOOL, basePath .. ".collisionPair(?)#enabled" , "Collision between components enabled" )
        schema:register(XMLValueType.INT, basePath .. ".collisionPair(?)#component1" , "Index of first component" )
        schema:register(XMLValueType.INT, basePath .. ".collisionPair(?)#component2" , "Index of second component" )
    end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function Vehicle.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onPreLoad" )
    SpecializationUtil.registerEvent(vehicleType, "onLoad" )
    SpecializationUtil.registerEvent(vehicleType, "onPostLoad" )
    SpecializationUtil.registerEvent(vehicleType, "onPreInitComponentPlacement" )
    SpecializationUtil.registerEvent(vehicleType, "onPreLoadFinished" )
    SpecializationUtil.registerEvent(vehicleType, "onLoadFinished" )
    SpecializationUtil.registerEvent(vehicleType, "onLoadEnd" )
    SpecializationUtil.registerEvent(vehicleType, "onRegistered" )
    SpecializationUtil.registerEvent(vehicleType, "onDirtyMaskCleared" )
    SpecializationUtil.registerEvent(vehicleType, "onPreDelete" )
    SpecializationUtil.registerEvent(vehicleType, "onDelete" )
    SpecializationUtil.registerEvent(vehicleType, "onSave" )
    SpecializationUtil.registerEvent(vehicleType, "onReadStream" )
    SpecializationUtil.registerEvent(vehicleType, "onWriteStream" )
    SpecializationUtil.registerEvent(vehicleType, "onReadUpdateStream" )
    SpecializationUtil.registerEvent(vehicleType, "onWriteUpdateStream" )
    SpecializationUtil.registerEvent(vehicleType, "onReadPositionUpdateStream" )
    SpecializationUtil.registerEvent(vehicleType, "onWritePositionUpdateStream" )
    SpecializationUtil.registerEvent(vehicleType, "onHandToolTaken" )
    SpecializationUtil.registerEvent(vehicleType, "onHandToolPlaced" )
    SpecializationUtil.registerEvent(vehicleType, "onPreUpdate" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdate" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdateInterpolation" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdateDebug" )
    SpecializationUtil.registerEvent(vehicleType, "onPostUpdate" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdateTick" )
    SpecializationUtil.registerEvent(vehicleType, "onPostUpdateTick" )
    SpecializationUtil.registerEvent(vehicleType, "onUpdateEnd" )
    SpecializationUtil.registerEvent(vehicleType, "onDraw" )
    SpecializationUtil.registerEvent(vehicleType, "onDrawUIInfo" )
    SpecializationUtil.registerEvent(vehicleType, "onActivate" )
    SpecializationUtil.registerEvent(vehicleType, "onDeactivate" )
    SpecializationUtil.registerEvent(vehicleType, "onStateChange" )
    SpecializationUtil.registerEvent(vehicleType, "onPreRegisterActionEvents" )
    SpecializationUtil.registerEvent(vehicleType, "onRegisterActionEvents" )
    SpecializationUtil.registerEvent(vehicleType, "onRootVehicleChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onSelect" )
    SpecializationUtil.registerEvent(vehicleType, "onUnselect" )
    SpecializationUtil.registerEvent(vehicleType, "onSetBroken" )
    SpecializationUtil.registerEvent(vehicleType, "onSaleItemSet" )
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
function Vehicle.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "register" , Vehicle.register)
    SpecializationUtil.registerFunction(vehicleType, "setOwnerFarmId" , Vehicle.setOwnerFarmId)
    SpecializationUtil.registerFunction(vehicleType, "loadSubSharedI3DFile" , Vehicle.loadSubSharedI3DFile)
    SpecializationUtil.registerFunction(vehicleType, "drawUIInfo" , Vehicle.drawUIInfo)
    SpecializationUtil.registerFunction(vehicleType, "raiseActive" , Vehicle.raiseActive)
    SpecializationUtil.registerFunction(vehicleType, "setLoadingState" , Vehicle.setLoadingState)
    SpecializationUtil.registerFunction(vehicleType, "setLoadingStep" , Vehicle.setLoadingStep)
    SpecializationUtil.registerFunction(vehicleType, "addToPhysics" , Vehicle.addToPhysics)
    SpecializationUtil.registerFunction(vehicleType, "removeFromPhysics" , Vehicle.removeFromPhysics)
    SpecializationUtil.registerFunction(vehicleType, "setVisibility" , Vehicle.setVisibility)
    SpecializationUtil.registerFunction(vehicleType, "setRelativePosition" , Vehicle.setRelativePosition)
    SpecializationUtil.registerFunction(vehicleType, "setAbsolutePosition" , Vehicle.setAbsolutePosition)
    SpecializationUtil.registerFunction(vehicleType, "getLimitedVehicleYPosition" , Vehicle.getLimitedVehicleYPosition)
    SpecializationUtil.registerFunction(vehicleType, "setWorldPosition" , Vehicle.setWorldPosition)
    SpecializationUtil.registerFunction(vehicleType, "setWorldPositionQuaternion" , Vehicle.setWorldPositionQuaternion)
    SpecializationUtil.registerFunction(vehicleType, "setDefaultComponentPosition" , Vehicle.setDefaultComponentPosition)
    SpecializationUtil.registerFunction(vehicleType, "getIsNodeActive" , Vehicle.getIsNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "updateVehicleSpeed" , Vehicle.updateVehicleSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getUpdatePriority" , Vehicle.getUpdatePriority)
    SpecializationUtil.registerFunction(vehicleType, "getPrice" , Vehicle.getPrice)
    SpecializationUtil.registerFunction(vehicleType, "getSellPrice" , Vehicle.getSellPrice)
    SpecializationUtil.registerFunction(vehicleType, "getDailyUpkeep" , Vehicle.getDailyUpkeep)
    SpecializationUtil.registerFunction(vehicleType, "getIsOnField" , Vehicle.getIsOnField)
    SpecializationUtil.registerFunction(vehicleType, "getParentComponent" , Vehicle.getParentComponent)
    SpecializationUtil.registerFunction(vehicleType, "getLastSpeed" , Vehicle.getLastSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getDeactivateOnLeave" , Vehicle.getDeactivateOnLeave)
    SpecializationUtil.registerFunction(vehicleType, "getOwnerConnection" , Vehicle.getOwnerConnection)
    SpecializationUtil.registerFunction(vehicleType, "getIsVehicleNode" , Vehicle.getIsVehicleNode)
    SpecializationUtil.registerFunction(vehicleType, "getIsOperating" , Vehicle.getIsOperating)
    SpecializationUtil.registerFunction(vehicleType, "getIsActive" , Vehicle.getIsActive)
    SpecializationUtil.registerFunction(vehicleType, "getIsActiveForInput" , Vehicle.getIsActiveForInput)
    SpecializationUtil.registerFunction(vehicleType, "getIsActiveForSound" , Vehicle.getIsActiveForSound)
    SpecializationUtil.registerFunction(vehicleType, "getIsLowered" , Vehicle.getIsLowered)
    SpecializationUtil.registerFunction(vehicleType, "updateWaterInfo" , Vehicle.updateWaterInfo)
    SpecializationUtil.registerFunction(vehicleType, "onWaterRaycastCallback" , Vehicle.onWaterRaycastCallback)
    SpecializationUtil.registerFunction(vehicleType, "setBroken" , Vehicle.setBroken)
    SpecializationUtil.registerFunction(vehicleType, "getVehicleDamage" , Vehicle.getVehicleDamage)
    SpecializationUtil.registerFunction(vehicleType, "getRepairPrice" , Vehicle.getRepairPrice)
    SpecializationUtil.registerFunction(vehicleType, "getRepaintPrice" , Vehicle.getRepaintPrice)
    SpecializationUtil.registerFunction(vehicleType, "setMassDirty" , Vehicle.setMassDirty)
    SpecializationUtil.registerFunction(vehicleType, "updateMass" , Vehicle.updateMass)
    SpecializationUtil.registerFunction(vehicleType, "getMaxComponentMassReached" , Vehicle.getMaxComponentMassReached)
    SpecializationUtil.registerFunction(vehicleType, "getAdditionalComponentMass" , Vehicle.getAdditionalComponentMass)
    SpecializationUtil.registerFunction(vehicleType, "getTotalMass" , Vehicle.getTotalMass)
    SpecializationUtil.registerFunction(vehicleType, "getComponentMass" , Vehicle.getComponentMass)
    SpecializationUtil.registerFunction(vehicleType, "getDefaultMass" , Vehicle.getDefaultMass)
    SpecializationUtil.registerFunction(vehicleType, "getOverallCenterOfMass" , Vehicle.getOverallCenterOfMass)
    SpecializationUtil.registerFunction(vehicleType, "getVehicleWorldXRot" , Vehicle.getVehicleWorldXRot)
    SpecializationUtil.registerFunction(vehicleType, "getVehicleWorldDirection" , Vehicle.getVehicleWorldDirection)
    SpecializationUtil.registerFunction(vehicleType, "getFillLevelInformation" , Vehicle.getFillLevelInformation)
    SpecializationUtil.registerFunction(vehicleType, "getHasObjectMounted" , Vehicle.getHasObjectMounted)
    SpecializationUtil.registerFunction(vehicleType, "activate" , Vehicle.activate)
    SpecializationUtil.registerFunction(vehicleType, "deactivate" , Vehicle.deactivate)
    SpecializationUtil.registerFunction(vehicleType, "setComponentJointFrame" , Vehicle.setComponentJointFrame)
    SpecializationUtil.registerFunction(vehicleType, "setComponentJointRotLimit" , Vehicle.setComponentJointRotLimit)
    SpecializationUtil.registerFunction(vehicleType, "setComponentJointTransLimit" , Vehicle.setComponentJointTransLimit)
    SpecializationUtil.registerFunction(vehicleType, "loadComponentFromXML" , Vehicle.loadComponentFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadComponentJointFromXML" , Vehicle.loadComponentJointFromXML)
    SpecializationUtil.registerFunction(vehicleType, "createComponentJoint" , Vehicle.createComponentJoint)
    SpecializationUtil.registerFunction(vehicleType, "loadSchemaOverlay" , Vehicle.loadSchemaOverlay)
    SpecializationUtil.registerFunction(vehicleType, "getAdditionalSchemaText" , Vehicle.getAdditionalSchemaText)
    SpecializationUtil.registerFunction(vehicleType, "getUseTurnedOnSchema" , Vehicle.getUseTurnedOnSchema)
    SpecializationUtil.registerFunction(vehicleType, "dayChanged" , Vehicle.dayChanged)
    SpecializationUtil.registerFunction(vehicleType, "periodChanged" , Vehicle.periodChanged)
    SpecializationUtil.registerFunction(vehicleType, "raiseStateChange" , Vehicle.raiseStateChange)
    SpecializationUtil.registerFunction(vehicleType, "doCheckSpeedLimit" , Vehicle.doCheckSpeedLimit)
    SpecializationUtil.registerFunction(vehicleType, "interact" , Vehicle.interact)
    SpecializationUtil.registerFunction(vehicleType, "getInteractionHelp" , Vehicle.getInteractionHelp)
    SpecializationUtil.registerFunction(vehicleType, "getIsInteractive" , Vehicle.getIsInteractive)
    SpecializationUtil.registerFunction(vehicleType, "getDistanceToNode" , Vehicle.getDistanceToNode)
    SpecializationUtil.registerFunction(vehicleType, "getIsAIActive" , Vehicle.getIsAIActive)
    SpecializationUtil.registerFunction(vehicleType, "getIsPowered" , Vehicle.getIsPowered)
    SpecializationUtil.registerFunction(vehicleType, "getRequiresPower" , Vehicle.getRequiresPower)
    SpecializationUtil.registerFunction(vehicleType, "getIsInShowroom" , Vehicle.getIsInShowroom)
    SpecializationUtil.registerFunction(vehicleType, "addVehicleToAIImplementList" , Vehicle.addVehicleToAIImplementList)
    SpecializationUtil.registerFunction(vehicleType, "setOperatingTime" , Vehicle.setOperatingTime)

    SpecializationUtil.registerFunction(vehicleType, "requestActionEventUpdate" , Vehicle.requestActionEventUpdate)
    SpecializationUtil.registerFunction(vehicleType, "removeActionEvents" , Vehicle.removeActionEvents)
    SpecializationUtil.registerFunction(vehicleType, "updateActionEvents" , Vehicle.updateActionEvents)
    SpecializationUtil.registerFunction(vehicleType, "registerActionEvents" , Vehicle.registerActionEvents)
    SpecializationUtil.registerFunction(vehicleType, "addActionEvent" , Vehicle.addActionEvent)

    SpecializationUtil.registerFunction(vehicleType, "updateSelectableObjects" , Vehicle.updateSelectableObjects)
    SpecializationUtil.registerFunction(vehicleType, "registerSelectableObjects" , Vehicle.registerSelectableObjects)
    SpecializationUtil.registerFunction(vehicleType, "addSubselection" , Vehicle.addSubselection)
    SpecializationUtil.registerFunction(vehicleType, "getRootVehicle" , Vehicle.getRootVehicle)
    SpecializationUtil.registerFunction(vehicleType, "findRootVehicle" , Vehicle.findRootVehicle)
    SpecializationUtil.registerFunction(vehicleType, "getChildVehicles" , Vehicle.getChildVehicles)
    SpecializationUtil.registerFunction(vehicleType, "addChildVehicles" , Vehicle.addChildVehicles)
    SpecializationUtil.registerFunction(vehicleType, "updateVehicleChain" , Vehicle.updateVehicleChain)
    SpecializationUtil.registerFunction(vehicleType, "getCanBeSelected" , Vehicle.getCanBeSelected)
    SpecializationUtil.registerFunction(vehicleType, "getBlockSelection" , Vehicle.getBlockSelection)
    SpecializationUtil.registerFunction(vehicleType, "getCanToggleSelectable" , Vehicle.getCanToggleSelectable)
    SpecializationUtil.registerFunction(vehicleType, "unselectVehicle" , Vehicle.unselectVehicle)
    SpecializationUtil.registerFunction(vehicleType, "selectVehicle" , Vehicle.selectVehicle)
    SpecializationUtil.registerFunction(vehicleType, "getIsSelected" , Vehicle.getIsSelected)
    SpecializationUtil.registerFunction(vehicleType, "getSelectedObject" , Vehicle.getSelectedObject)
    SpecializationUtil.registerFunction(vehicleType, "getSelectedVehicle" , Vehicle.getSelectedVehicle)
    SpecializationUtil.registerFunction(vehicleType, "setSelectedVehicle" , Vehicle.setSelectedVehicle)
    SpecializationUtil.registerFunction(vehicleType, "setSelectedObject" , Vehicle.setSelectedObject)
    SpecializationUtil.registerFunction(vehicleType, "getIsReadyForAutomatedTrainTravel" , Vehicle.getIsReadyForAutomatedTrainTravel)
    SpecializationUtil.registerFunction(vehicleType, "getIsAutomaticShiftingAllowed" , Vehicle.getIsAutomaticShiftingAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getSpeedLimit" , Vehicle.getSpeedLimit)
    SpecializationUtil.registerFunction(vehicleType, "getRawSpeedLimit" , Vehicle.getRawSpeedLimit)
    SpecializationUtil.registerFunction(vehicleType, "getActiveFarm" , Vehicle.getActiveFarm)
    SpecializationUtil.registerFunction(vehicleType, "onVehicleWakeUpCallback" , Vehicle.onVehicleWakeUpCallback)
    SpecializationUtil.registerFunction(vehicleType, "getCanBeMounted" , Vehicle.getCanBeMounted)
    SpecializationUtil.registerFunction(vehicleType, "getName" , Vehicle.getName)
    SpecializationUtil.registerFunction(vehicleType, "getFullName" , Vehicle.getFullName)
    SpecializationUtil.registerFunction(vehicleType, "getBrand" , Vehicle.getBrand)
    SpecializationUtil.registerFunction(vehicleType, "getImageFilename" , Vehicle.getImageFilename)
    SpecializationUtil.registerFunction(vehicleType, "getCanBePickedUp" , Vehicle.getCanBePickedUp)
    SpecializationUtil.registerFunction(vehicleType, "getCanBeReset" , Vehicle.getCanBeReset)
    SpecializationUtil.registerFunction(vehicleType, "getResetPlaces" , Vehicle.getResetPlaces)
    SpecializationUtil.registerFunction(vehicleType, "getCanBeSold" , Vehicle.getCanBeSold)
    SpecializationUtil.registerFunction(vehicleType, "getCanBeAddedToSales" , Vehicle.getCanBeAddedToSales)
    SpecializationUtil.registerFunction(vehicleType, "getReloadXML" , Vehicle.getReloadXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsInUse" , Vehicle.getIsInUse)
    SpecializationUtil.registerFunction(vehicleType, "getPropertyState" , Vehicle.getPropertyState)
    SpecializationUtil.registerFunction(vehicleType, "getAreControlledActionsAllowed" , Vehicle.getAreControlledActionsAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getAreControlledActionsAvailable" , Vehicle.getAreControlledActionsAvailable)
    SpecializationUtil.registerFunction(vehicleType, "getAreControlledActionsAccessible" , Vehicle.getAreControlledActionsAccessible)
    SpecializationUtil.registerFunction(vehicleType, "getControlledActionIcons" , Vehicle.getControlledActionIcons)
    SpecializationUtil.registerFunction(vehicleType, "playControlledActions" , Vehicle.playControlledActions)
    SpecializationUtil.registerFunction(vehicleType, "getActionControllerDirection" , Vehicle.getActionControllerDirection)
    SpecializationUtil.registerFunction(vehicleType, "createMapHotspot" , Vehicle.createMapHotspot)
    SpecializationUtil.registerFunction(vehicleType, "getMapHotspot" , Vehicle.getMapHotspot)
    SpecializationUtil.registerFunction(vehicleType, "updateMapHotspot" , Vehicle.updateMapHotspot)
    SpecializationUtil.registerFunction(vehicleType, "getIsMapHotspotVisible" , Vehicle.getIsMapHotspotVisible)
    SpecializationUtil.registerFunction(vehicleType, "getMapHotspotRotation" , Vehicle.getMapHotspotRotation)
    SpecializationUtil.registerFunction(vehicleType, "getMapHotspotPosition" , Vehicle.getMapHotspotPosition)
    SpecializationUtil.registerFunction(vehicleType, "getShowInVehiclesOverview" , Vehicle.getShowInVehiclesOverview)
    SpecializationUtil.registerFunction(vehicleType, "showInfo" , Vehicle.showInfo)
    SpecializationUtil.registerFunction(vehicleType, "loadObjectChangeValuesFromXML" , Vehicle.loadObjectChangeValuesFromXML)
    SpecializationUtil.registerFunction(vehicleType, "setObjectChangeValues" , Vehicle.setObjectChangeValues)
    SpecializationUtil.registerFunction(vehicleType, "getIsSynchronized" , Vehicle.getIsSynchronized)
end

```

### registerInteractionFlag

**Description**

> Register interaction flag

**Definition**

> registerInteractionFlag(string name)

**Arguments**

| string | name | name of flag |
|--------|------|--------------|

**Code**

```lua
function Vehicle.registerInteractionFlag(name)
    local key = "INTERACTION_FLAG_" .. string.upper(name)
    if Vehicle [key] = = nil then
        Vehicle.NUM_INTERACTION_FLAGS = Vehicle.NUM_INTERACTION_FLAGS + 1
        Vehicle [key] = Vehicle.NUM_INTERACTION_FLAGS
    end

    return Vehicle [key]
end

```

### registers

**Description**

**Definition**

> registers()

**Code**

```lua
function Vehicle.registers()
    local schema = Vehicle.xmlSchema
    local schemaSavegame = Vehicle.xmlSchemaSavegame

    schema:register(XMLValueType.STRING, "vehicle#type" , "Vehicle type" )
    schema:registerAutoCompletionDataSource( "vehicle#type" , "$dataS/vehicleTypes.xml" , "vehicleTypes.type#name" )
    schema:register(XMLValueType.STRING, "vehicle.annotation" , "Annotation" , nil , true )

    StoreManager.registerStoreDataXMLPaths(schema, "vehicle" )

    schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.workingWidth" , "Working width to display in shop" )
    schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.workingWidth#minWidth" , "Min.working width to display in shop" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.combination(?)#xmlFilename" , "Combination to display in shop" )
    schema:registerAutoCompletionDataSource( "vehicle.storeData.specs.combination(?)#xmlFilename" , "dataS/storeItems.xml" , "storeItems.storeItem#xmlFilename" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.combination(?)#filterCategory" , "Filter in this category" )
    schema:registerAutoCompletionDataSource( "vehicle.storeData.specs.combination(?)#filterCategory" , "$dataS/storeCategories.xml" , "categories.category#name" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.combination(?)#filterSpec" , "Filter for this spec type" )
        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.combination(?)#filterSpecMin" , "Filter spec type in this range(min.)" )
        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.combination(?)#filterSpecMax" , "Filter spec type in this range(max.)" )

        schema:register(XMLValueType.BOOL, "vehicle.storeData.specs.weight#ignore" , "Hide vehicle weight in shop" , false )
        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.weight#minValue" , "Min.weight to display in shop" )
        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.weight#maxValue" , "Max.weight to display in shop" )
        schema:register(XMLValueType.STRING, "vehicle.storeData.specs.weight.config(?)#name" , "Name of configuration" )
        schema:register(XMLValueType.INT, "vehicle.storeData.specs.weight.config(?)#index" , "Index of selected configuration" )
        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.weight.config(?)#value" , "Weight value which can be reached with this configuration" )

        schema:register(XMLValueType.STRING, "vehicle.base.filename" , "Path to i3d filename" , nil )
        schema:register(XMLValueType.L10N_STRING, "vehicle.base.typeDesc" , "Type description" , nil )
        schema:register(XMLValueType.BOOL, "vehicle.base.synchronizePosition" , "Vehicle position synchronized" , true )
        schema:register(XMLValueType.BOOL, "vehicle.base.supportsPickUp" , "Vehicle can be picked up by hand" , false )
        schema:register(XMLValueType.BOOL, "vehicle.base.canBeReset" , "Vehicle can be reset to shop" , true )
        schema:register(XMLValueType.BOOL, "vehicle.base.showInVehicleMenu" , "Vehicle shows in vehicle menu" , true )
        schema:register(XMLValueType.BOOL, "vehicle.base.supportsRadio" , "Vehicle supported radio" , true )
        schema:register(XMLValueType.BOOL, "vehicle.base.input#allowed" , "Vehicle allows key input" , true )
        schema:register(XMLValueType.BOOL, "vehicle.base.selection#allowed" , "Vehicle selection is allowed" , true )
        schema:register(XMLValueType.FLOAT, "vehicle.base.tailwaterDepth#warning" , "Tailwater depth warning is shown from this water depth" , "25% of vehicle height" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.tailwaterDepth#threshold" , "Vehicle is broken after this water depth" , "75% of vehicle height" )
        schema:register(XMLValueType.STRING, "vehicle.base.mapHotspot#type" , "Map hotspot type" , nil , nil , table.toList(VehicleHotspot.TYPE))
        schema:register(XMLValueType.BOOL, "vehicle.base.mapHotspot#available" , "Map hotspot is available" , true )
        schema:register(XMLValueType.FLOAT, "vehicle.base.speedLimit#value" , "Speed limit" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#width" , "Occupied width of the vehicle when loaded" , nil , true )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#length" , "Occupied length of the vehicle when loaded" , nil , true )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#height" , "Occupied height of the vehicle when loaded" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#widthOffset" , "Width offset" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#lengthOffset" , "Width offset" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.size#heightOffset" , "Height offset" )
        schema:register(XMLValueType.ANGLE, "vehicle.base.size#yRotation" , "Y Rotation offset in i3d(Needs to be set to the vehicle's rotation in the i3d file and is e.g.used to check ai working direction)" , 0 )
        schema:register(XMLValueType.NODE_INDEX, "vehicle.base.steeringAxle#node" , "Steering axle node used to calculate the steering angle of attachments" )
        schema:register(XMLValueType.STRING, "vehicle.base.sounds#filename" , "Path to external sound files" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.sounds#volumeFactor" , "This factor will be applied to all sounds of this vehicle" )

        I3DUtil.registerI3dMappingXMLPaths(schema, "vehicle" )

        Vehicle.registerComponentXMLPaths(schema, "vehicle.base.components" )
        Vehicle.registerComponentXMLPaths(schema, "vehicle.base.componentConfigurations.componentConfiguration(?)" )

        ObjectChangeUtil.registerObjectChangesXMLPaths(schema, "vehicle.base" )

        schema:register(XMLValueType.VECTOR_ 2 , "vehicle.base.schemaOverlay#attacherJointPosition" , "Position of attacher joint" )
        schema:register(XMLValueType.VECTOR_ 2 , "vehicle.base.schemaOverlay#basePosition" , "Position of vehicle" )
        schema:register(XMLValueType.STRING, "vehicle.base.schemaOverlay#name" , "Name of schema overlay" )
        schema:registerAutoCompletionDataSource( "vehicle.base.schemaOverlay#name" , "$dataS/vehicleSchemaOverlays.xml" , "vehicleSchemaOverlays.overlay#name" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.schemaOverlay#invisibleBorderRight" , "Size of invisible border on the right" )
        schema:register(XMLValueType.FLOAT, "vehicle.base.schemaOverlay#invisibleBorderLeft" , "Size of invisible border on the left" )

        schema:register(XMLValueType.STRING, "vehicle.vehicleTypeConfigurations.vehicleTypeConfiguration(?)#vehicleType" , "Vehicle type for configuration" )

            schema:register(XMLValueType.BOOL, "vehicle.designConfigurations#preLoad" , "Defines if the design configurations are applied before the execution of load or after.Can help if the configurations manipulate the wheel positions for example." , false )

                StoreItemUtil.registerConfigurationSetXMLPaths(schema, "vehicle" )

                schemaSavegame:register(XMLValueType.BOOL, "vehicles#loadAnyFarmInSingleplayer" , "Load any farm in singleplayer" , false )
                schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?)#filename" , "XML filename" )
                schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?)#modName" , "Vehicle mod name" )
                schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?)#isBroken" , "If the vehicle is broken" , false )
                schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?)#defaultFarmProperty" , "Property of default farm" , false )
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)#id" , "Vehicle id" )
                schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?)#tourId" , "Tour id" )
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)#farmId" , "Farm id" )
                schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?)#uniqueId" , "Vehicle's unique id" )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?)#age" , "Age in number of months" )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?)#price" , "Price" )
                VehiclePropertyState.registerXMLPath(schemaSavegame, "vehicles.vehicle(?)#propertyState" , "Property state" , nil , false )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?)#operatingTime" , "Operating time" )
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)#selectedObjectIndex" , "Selected object index" )
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)#subSelectedObjectIndex" , "Sub selected object index" )

                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).component(?)#index" , "Component index" )
                schemaSavegame:register(XMLValueType.VECTOR_TRANS, "vehicles.vehicle(?).component(?)#position" , "Component position" )
                schemaSavegame:register(XMLValueType.VECTOR_ROT, "vehicles.vehicle(?).component(?)#rotation" , "Component rotation" )

                VehicleActionController.registerXMLPaths(schemaSavegame, "vehicles.vehicle(?).actionController" )

                schemaSavegame:register(XMLValueType.INT, "vehicles.attachments(?)#rootVehicleId" , "Id of root vehicle" )
            end

```

### registerSelectableObjects

**Description**

**Definition**

> registerSelectableObjects()

**Arguments**

| any | selectableObjects |
|-----|-------------------|

**Code**

```lua
function Vehicle:registerSelectableObjects(selectableObjects)
    if self:getCanBeSelected() and not self:getBlockSelection() then
        table.insert(selectableObjects, self.selectionObject)
        self.selectionObject.index = #selectableObjects
    end
end

```

### removeActionEvent

**Description**

**Definition**

> removeActionEvent()

**Arguments**

| any | actionEventsTable |
|-----|-------------------|
| any | inputAction       |

**Code**

```lua
function Vehicle:removeActionEvent(actionEventsTable, inputAction)
    if actionEventsTable[inputAction] ~ = nil then
        g_inputBinding:removeActionEvent(actionEventsTable[inputAction].actionEventId)
        actionEventsTable[inputAction] = nil
    end
end

```

### removeActionEvents

**Description**

**Definition**

> removeActionEvents()

**Code**

```lua
function Vehicle:removeActionEvents()
    g_inputBinding:removeActionEventsByTarget( self )
end

```

### removeFromPhysics

**Description**

> Remove vehicle from physics

**Definition**

> removeFromPhysics()

**Code**

```lua
function Vehicle:removeFromPhysics()
    for _, component in pairs( self.components) do
        removeFromPhysics(component.node)
    end
    -- invalidate wheel shapes and component joints(removing the components removes the wheels and joints too)
    if self.isServer then
        for _, jointDesc in pairs( self.componentJoints) do
            jointDesc.jointIndex = 0
        end
        removeWakeUpReport( self.rootNode)
    end
    self.isAddedToPhysics = false

    return true
end

```

### requestActionEventUpdate

**Description**

**Definition**

> requestActionEventUpdate()

**Code**

```lua
function Vehicle:requestActionEventUpdate()
    -- pass request to rootVehicle
    local vehicle = self.rootVehicle
    if vehicle = = self then
        self.actionEventUpdateRequested = true
    else
            vehicle:requestActionEventUpdate()
        end

        -- remove all actionEvents
        vehicle:removeActionEvents()
    end

```

### reset

**Description**

**Definition**

> reset()

**Arguments**

| any | forceDelete |
|-----|-------------|
| any | callback    |
| any | resetPlayer |

**Code**

```lua
function Vehicle:reset(forceDelete, callback, resetPlayer)
    if self.isResetInProgress then
        return
    end

    -- vehicle is removed in any case - even if we cannot spawn a new vehicle
        if forceDelete then
            self:delete()
        end

        -- optional reset of the player in case we reset because we are below the terrain etc.
        if resetPlayer then
            if g_localPlayer ~ = nil then
                local vehicle = g_localPlayer:getCurrentVehicle()
                if vehicle = = self then
                    g_localPlayer:leaveVehicle( nil , true )
                    g_localPlayer.mover:teleportToSpawnPoint()
                end
            end
        end

        local uniqueId = self:getUniqueId()

        local vehicleSystem = g_currentMission.vehicleSystem
        self.isResetInProgress = true

        local xmlFile = self:getReloadXML()

        local function asyncCallbackFunction(_, vehicles, arguments)
            self.isResetInProgress = false

            if #vehicles > 0 then
                g_messageCenter:publish(MessageType.VEHICLE_RESET, self , vehicles[ 1 ])

                -- remove the old vehicle if the reset was successful
                    if not forceDelete then
                        self:delete()
                    end
                else
                        if not forceDelete then
                            -- reset has been failed, so we still keep the old vehicle
                            vehicleSystem.vehicleByUniqueId[uniqueId] = self
                        end
                    end

                    if callback ~ = nil then
                        callback(#vehicles > 0 )
                    end

                    xmlFile:delete()
                end

                g_asyncTaskManager:addTask( function ()
                    vehicleSystem.vehicleByUniqueId[uniqueId] = nil
                    vehicleSystem:loadFromXMLFile(xmlFile, asyncCallbackFunction, nil , { } , true )
                end )
            end

```

### resetPositionToTerrainHeight

**Description**

> Resets the vehicle translation to be above the terrain

**Definition**

> resetPositionToTerrainHeight()

**Code**

```lua
function Vehicle:resetPositionToTerrainHeight()
    local maxOffset = 0
    for i, component in pairs( self.components) do
        local wx, wy, wz = getWorldTranslation(component.node)
        local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, wx, wy, wz)

        maxOffset = math.max(maxOffset, terrainHeight - wy)
    end

    self:removeFromPhysics()

    for i, component in pairs( self.components) do
        local wx, wy, wz = getWorldTranslation(component.node)
        setWorldTranslation(component.node, wx, wy + maxOffset + 10 , wz)
    end

    self:addToPhysics()

    for _, childVehicle in ipairs( self.childVehicles) do
        if childVehicle ~ = self then
            childVehicle:resetPositionToTerrainHeight()
        end
    end
end

```

### saveStatsToXMLFile

**Description**

> Get xml states attributes

**Definition**

> saveStatsToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Return Values**

| any | attributes | attributes |
|-----|------------|------------|

**Code**

```lua
function Vehicle:saveStatsToXMLFile(xmlFile, key)
    local isTabbable = self.getIsTabbable = = nil or self:getIsTabbable()
    if self.isDeleted or not self.isVehicleSaved or not isTabbable then
        return false
    end
    local name = "Unknown"
    local categoryName = "unknown"
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    if storeItem ~ = nil then
        if storeItem.name ~ = nil then
            name = tostring(storeItem.name)
        end

        categoryName = storeItem.categoryName
    end

    setXMLString(xmlFile, key .. "#name" , HTMLUtil.encodeToHTML(name))
    setXMLString(xmlFile, key .. "#category" , HTMLUtil.encodeToHTML(categoryName))
    setXMLString(xmlFile, key .. "#type" , HTMLUtil.encodeToHTML( tostring( self.typeName)))

    if self.components[ 1 ] ~ = nil and self.components[ 1 ].node ~ = 0 then
        local x,y,z = getWorldTranslation( self.components[ 1 ].node)
        setXMLFloat(xmlFile, key .. "#x" , x)
        setXMLFloat(xmlFile, key .. "#y" , y)
        setXMLFloat(xmlFile, key .. "#z" , z)
    end

    for id, spec in pairs( self.specializations) do
        if spec.saveStatsToXMLFile ~ = nil then
            spec.saveStatsToXMLFile( self , xmlFile, key)
        end
    end

    return true
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
function Vehicle:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setValue(key .. "#uniqueId" , self.uniqueId)

    xmlFile:setValue(key .. "#age" , self.age)
    xmlFile:setValue(key .. "#price" , self.price)
    xmlFile:setValue(key .. "#farmId" , self:getOwnerFarmId())

    VehiclePropertyState.saveToXMLFile(xmlFile, key .. "#propertyState" , self.propertyState)
    xmlFile:setValue(key .. "#operatingTime" , self.operatingTime / 1000 )

    if self.tourId ~ = nil then
        xmlFile:setValue(key .. "#tourId" , self.tourId)
    end

    if self.rootVehicle = = self then
        xmlFile:setValue(key .. "#selectedObjectIndex" , self.currentSelection.index)
        if self.currentSelection.subIndex ~ = nil then
            xmlFile:setValue(key .. "#subSelectedObjectIndex" , self.currentSelection.subIndex)
        end
    end

    if self.isBroken then
        xmlFile:setValue(key .. "#isBroken" , self.isBroken)
    end

    for k, component in ipairs( self.components) do
        local compKey = string.format( "%s.component(%d)" , key, k - 1 )
        local node = component.node
        local x,y,z = getWorldTranslation(node)
        local xRot,yRot,zRot = getWorldRotation(node)

        xmlFile:setValue(compKey .. "#index" , k)
        xmlFile:setValue(compKey .. "#position" , x, y, z)
        xmlFile:setValue(compKey .. "#rotation" , xRot, yRot, zRot)
    end

    ConfigurationUtil.saveConfigurationsToXMLFile( self.configFileName, xmlFile, key .. ".configuration" , self.configurations, self.boughtConfigurations, self.configurationData)

    for id, spec in pairs( self.specializations) do
        local name = self.specializationNames[id]

        if spec.saveToXMLFile ~ = nil then
            spec.saveToXMLFile( self , xmlFile, key .. "." .. name, usedModNames)
        end
    end

    if Platform.gameplay.automaticVehicleControl then
        if self.actionController ~ = nil then
            self.actionController:saveToXMLFile(xmlFile, key .. ".actionController" , usedModNames)
        end
    end
end

```

### selectVehicle

**Description**

**Definition**

> selectVehicle()

**Arguments**

| any | subSelectionIndex       |
|-----|-------------------------|
| any | ignoreActionEventUpdate |

**Code**

```lua
function Vehicle:selectVehicle(subSelectionIndex, ignoreActionEventUpdate)
    self.selectionObject.isSelected = true
    SpecializationUtil.raiseEvent( self , "onSelect" , subSelectionIndex)

    if ignoreActionEventUpdate = = nil or not ignoreActionEventUpdate then
        self:requestActionEventUpdate()
    end
end

```

### setAbsolutePosition

**Description**

**Definition**

> setAbsolutePosition()

**Arguments**

| any | positionX          |
|-----|--------------------|
| any | positionY          |
| any | positionZ          |
| any | xRot               |
| any | yRot               |
| any | zRot               |
| any | componentPositions |

**Code**

```lua
function Vehicle:setAbsolutePosition(positionX, positionY, positionZ, xRot, yRot, zRot, componentPositions)
    local tempRootNode = createTransformGroup( "tempRootNode" )
    setTranslation(tempRootNode, positionX, positionY, positionZ)
    setRotation(tempRootNode, xRot, yRot, zRot)

    -- now move the objects to the scene root node
    for i, component in pairs( self.components) do
        local x,y,z = localToWorld(tempRootNode, unpack(component.originalTranslation))
        local rx,ry,rz = localRotationToWorld(tempRootNode, unpack(component.originalRotation))

        if componentPositions ~ = nil and #componentPositions = = # self.components then
            x,y,z = unpack(componentPositions[i][ 1 ])
            rx,ry,rz = unpack(componentPositions[i][ 2 ])
        end

        self:setWorldPosition(x, y, z, rx, ry, rz, i, true )
    end
    delete(tempRootNode)

    self.networkTimeInterpolator:reset()
end

```

### setBroken

**Description**

**Definition**

> setBroken()

**Code**

```lua
function Vehicle:setBroken()
    if self.isServer and not self.isBroken then
        g_server:broadcastEvent( VehicleBrokenEvent.new( self ), nil , nil , self )
    end

    self.isBroken = true
    SpecializationUtil.raiseEvent( self , "onSetBroken" )

    if self.tourId ~ = nil then
        if g_guidedTourManager:getIsTourRunning() then
            g_guidedTourManager:abortTour()
        end
    end
end

```

### setComponentJointFrame

**Description**

> Set component joint frame

**Definition**

> setComponentJointFrame(table jointDesc, integer anchorActor)

**Arguments**

| table   | jointDesc   | joint desc index |
|---------|-------------|------------------|
| integer | anchorActor | anchor actor     |

**Code**

```lua
function Vehicle:setComponentJointFrame(jointDesc, anchorActor)
    if anchorActor = = 0 then
        local localPoses = jointDesc.jointLocalPoses[ 1 ]
        localPoses.trans[ 1 ], localPoses.trans[ 2 ], localPoses.trans[ 3 ] = localToLocal(jointDesc.jointNode, self.components[jointDesc.componentIndices[ 1 ]].node, 0 , 0 , 0 )
        localPoses.rot[ 1 ], localPoses.rot[ 2 ], localPoses.rot[ 3 ] = localRotationToLocal(jointDesc.jointNode, self.components[jointDesc.componentIndices[ 1 ]].node, 0 , 0 , 0 )
    else
            local localPoses = jointDesc.jointLocalPoses[ 2 ]
            localPoses.trans[ 1 ], localPoses.trans[ 2 ], localPoses.trans[ 3 ] = localToLocal(jointDesc.jointNodeActor1, self.components[jointDesc.componentIndices[ 2 ]].node, 0 , 0 , 0 )
            localPoses.rot[ 1 ], localPoses.rot[ 2 ], localPoses.rot[ 3 ] = localRotationToLocal(jointDesc.jointNodeActor1, self.components[jointDesc.componentIndices[ 2 ]].node, 0 , 0 , 0 )
        end

        local jointNode = jointDesc.jointNode
        if anchorActor = = 1 then
            jointNode = jointDesc.jointNodeActor1
        end

        if jointDesc.jointIndex ~ = 0 then
            setJointFrame(jointDesc.jointIndex, anchorActor, jointNode)
        end
    end

```

### setComponentJointRotLimit

**Description**

> Set component joint rot limit

**Definition**

> setComponentJointRotLimit(table componentJoint, integer axis, float minLimit, float maxLimit)

**Arguments**

| table   | componentJoint | component joint |
|---------|----------------|-----------------|
| integer | axis           | axis            |
| float   | minLimit       | min limit       |
| float   | maxLimit       | max limit       |

**Code**

```lua
function Vehicle:setComponentJointRotLimit(componentJoint, axis, minLimit, maxLimit)
    if self.isServer then
        componentJoint.rotLimit[axis] = maxLimit
        componentJoint.rotMinLimit[axis] = minLimit

        if componentJoint.jointIndex ~ = 0 then
            if minLimit < = maxLimit then
                setJointRotationLimit(componentJoint.jointIndex, axis - 1 , true , minLimit, maxLimit)
            else
                    setJointRotationLimit(componentJoint.jointIndex, axis - 1 , false , 0 , 0 )
                end
            end
        end
    end

```

### setComponentJointTransLimit

**Description**

> Set component joint trans limit

**Definition**

> setComponentJointTransLimit(table componentJoint, integer axis, float minLimit, float maxLimit)

**Arguments**

| table   | componentJoint | component joint |
|---------|----------------|-----------------|
| integer | axis           | axis            |
| float   | minLimit       | min limit       |
| float   | maxLimit       | max limit       |

**Code**

```lua
function Vehicle:setComponentJointTransLimit(componentJoint, axis, minLimit, maxLimit)
    if self.isServer then
        componentJoint.transLimit[axis] = maxLimit
        componentJoint.transMinLimit[axis] = minLimit

        if componentJoint.jointIndex ~ = 0 then
            if minLimit < = maxLimit then
                setJointTranslationLimit(componentJoint.jointIndex, axis - 1 , true , minLimit, maxLimit)
            else
                    setJointTranslationLimit(componentJoint.jointIndex, axis - 1 , false , 0 , 0 )
                end
            end
        end
    end

```

### setConfigurations

**Description**

**Definition**

> setConfigurations()

**Arguments**

| any | configurations       |
|-----|----------------------|
| any | boughtConfigurations |
| any | configurationData    |

**Code**

```lua
function Vehicle:setConfigurations(configurations, boughtConfigurations, configurationData)
    self.configurations, self.boughtConfigurations = configurations, boughtConfigurations

    self.configurationData = configurationData or self.configurationData
    if self.configurationData = = nil then
        self.configurationData = { }
    end

    self.sortedConfigurationNames = { }
    for configName, _ in pairs( self.configurations) do
        table.insert( self.sortedConfigurationNames, configName)
    end

    table.sort( self.sortedConfigurationNames, function (a, b)
        return a < b
    end )
end

```

### setDefaultComponentPosition

**Description**

> Sets the world position of the given component index to the default offset to the vehicle root node

**Definition**

> setDefaultComponentPosition(integer componentIndex)

**Arguments**

| integer | componentIndex | index if component |
|---------|----------------|--------------------|

**Code**

```lua
function Vehicle:setDefaultComponentPosition(componentIndex)
    -- makes no sense for the root component as we use the offset to the root component - so we skip it
        if componentIndex = = 1 then
            return
        end

        local component = self.components[componentIndex]
        if component ~ = nil then
            local x, y, z = localToWorld( self.rootNode, unpack(component.originalTranslation))
            local rx, ry, rz = localRotationToWorld( self.rootNode, unpack(component.originalRotation))

            self:setWorldPosition(x, y, z, rx, ry, rz, componentIndex, true )
        end
    end

```

### setFilename

**Description**

**Definition**

> setFilename()

**Arguments**

| any | filename |
|-----|----------|

**Code**

```lua
function Vehicle:setFilename(filename)
    self.configFileName = filename
    self.configFileNameClean = Utils.getFilenameInfo(filename, true )

    self.customEnvironment, self.baseDirectory = Utils.getModNameAndBaseDirectory(filename)
end

```

### setLoadCallback

**Description**

**Definition**

> setLoadCallback()

**Arguments**

| any | loadCallbackFunction          |
|-----|-------------------------------|
| any | loadCallbackFunctionTarget    |
| any | loadCallbackFunctionArguments |

**Code**

```lua
function Vehicle:setLoadCallback(loadCallbackFunction, loadCallbackFunctionTarget, loadCallbackFunctionArguments)
    self.loadCallbackFunction = loadCallbackFunction
    self.loadCallbackFunctionTarget = loadCallbackFunctionTarget
    self.loadCallbackFunctionArguments = loadCallbackFunctionArguments
end

```

### setLoadingState

**Description**

**Definition**

> setLoadingState()

**Arguments**

| any | loadingState |
|-----|--------------|

**Code**

```lua
function Vehicle:setLoadingState(loadingState)
    if VehicleLoadingState.getName(loadingState) ~ = nil then
        self.loadingState = loadingState
    else
            printCallstack()
            Logging.error( "Invalid loading state '%s'!" , loadingState)
        end
    end

```

### setLoadingStep

**Description**

> Sets the loadingStep value of this vehicle, logging an error if the given step is invalid.

**Definition**

> setLoadingStep(SpecializationLoadStep loadingStep)

**Arguments**

| SpecializationLoadStep | loadingStep | The loading step to set. |
|------------------------|-------------|--------------------------|

**Code**

```lua
function Vehicle:setLoadingStep(loadingStep)
    SpecializationUtil.setLoadingStep( self , loadingStep)
end

```

### setMassDirty

**Description**

**Definition**

> setMassDirty()

**Code**

```lua
function Vehicle:setMassDirty()
    self.isMassDirty = true
end

```

### setObjectChangeValues

**Description**

> Sets object change values

**Definition**

> setObjectChangeValues(table object, boolean isActive)

**Arguments**

| table   | object   | object    |
|---------|----------|-----------|
| boolean | isActive | is active |

**Code**

```lua
function Vehicle:setObjectChangeValues(object, isActive)
end

```

### setOperatingTime

**Description**

**Definition**

> setOperatingTime()

**Arguments**

| any | operatingTime |
|-----|---------------|
| any | isLoading     |

**Code**

```lua
function Vehicle:setOperatingTime(operatingTime, isLoading)
    if not isLoading and self.propertyState = = VehiclePropertyState.LEASED and g_currentMission ~ = nil and g_currentMission.economyManager ~ = nil and math.floor(operatingTime / ( 1000 * 60 * 60 )) > math.floor( self.operatingTime / ( 1000 * 60 * 60 )) then
        g_currentMission.economyManager:vehicleOperatingHourChanged( self )
    end
    self.operatingTime = math.max(operatingTime or 0 , 0 )
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | farmId      |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Vehicle:setOwnerFarmId(farmId, noEventSend)
    Vehicle:superClass().setOwnerFarmId( self , farmId, noEventSend)

    if self.mapHotspot ~ = nil then
        self.mapHotspot:setOwnerFarmId(farmId)
    end
end

```

### setRelativePosition

**Description**

> Set relative position of vehicle

**Definition**

> setRelativePosition(float positionX, float offsetY, float positionZ, float yRot)

**Arguments**

| float | positionX | x position |
|-------|-----------|------------|
| float | offsetY   | y offset   |
| float | positionZ | z position |
| float | yRot      | y rotation |

**Code**

```lua
function Vehicle:setRelativePosition(positionX, offsetY, positionZ, yRot)
    -- position the vehicle
    local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, positionX, 300 , positionZ)

    self:setAbsolutePosition(positionX, terrainHeight + offsetY, positionZ, 0 , yRot, 0 )
end

```

### setSelectedObject

**Description**

**Definition**

> setSelectedObject()

**Arguments**

| any | object                  |
|-----|-------------------------|
| any | subSelectionIndex       |
| any | ignoreActionEventUpdate |

**Code**

```lua
function Vehicle:setSelectedObject(object, subSelectionIndex, ignoreActionEventUpdate)
    local currentSelection = self.currentSelection

    if object = = nil then
        object = self:getSelectedObject()
    end

    local found = false
    for _, o in ipairs( self.selectableObjects) do
        if o = = object then
            found = true
        end
    end

    if found then
        -- if object was found unselect all other vehicles
            for _, o in ipairs( self.selectableObjects) do
                if o ~ = object and o.vehicle:getIsSelected() then
                    o.vehicle:unselectVehicle()
                end
            end

            if object ~ = currentSelection.object or subSelectionIndex ~ = currentSelection.subIndex then
                currentSelection.object = object
                currentSelection.index = object.index
                if subSelectionIndex ~ = nil then
                    currentSelection.subIndex = subSelectionIndex
                end
                if currentSelection.subIndex > #object.subSelections then
                    currentSelection.subIndex = 1
                end

                currentSelection.object.vehicle:selectVehicle(currentSelection.subIndex, ignoreActionEventUpdate)

                return true
            end
        else
                object = self:getSelectedObject()

                found = false
                for _, o in ipairs( self.selectableObjects) do
                    if o = = object then
                        found = true
                    end
                end

                -- if the object to select could not be found and the object that was selected is not available anymore we clear the selection
                    if not found then
                        currentSelection.object = nil
                        currentSelection.index = 1
                        currentSelection.subIndex = 1
                    end
                end

                return false
            end

```

### setSelectedVehicle

**Description**

**Definition**

> setSelectedVehicle()

**Arguments**

| any | vehicle                 |
|-----|-------------------------|
| any | subSelectionIndex       |
| any | ignoreActionEventUpdate |

**Code**

```lua
function Vehicle:setSelectedVehicle(vehicle, subSelectionIndex, ignoreActionEventUpdate)
    local object = nil

    -- if vehicle could not be selected we select the next possible vehicle
        if vehicle = = nil or not vehicle:getCanBeSelected() or self:getBlockSelection() then
            vehicle = nil
            for _, o in ipairs( self.selectableObjects) do
                if o.vehicle:getCanBeSelected() and not o.vehicle:getBlockSelection() then
                    vehicle = o.vehicle
                    break
                end
            end
        end

        if vehicle ~ = nil then
            object = vehicle.selectionObject
        end

        return self:setSelectedObject(object, subSelectionIndex, ignoreActionEventUpdate)
    end

```

### setType

**Description**

**Definition**

> setType()

**Arguments**

| any | typeDef |
|-----|---------|

**Code**

```lua
function Vehicle:setType(typeDef)
    assertWithCallstack( self.configFileName ~ = nil , "Setting vehicle type without setting a filename previously.Call 'setFilename' first!" )

    if self.configurations ~ = nil then
        local configItem = ConfigurationUtil.getConfigItemByConfigId( self.configFileName, "vehicleType" , self.configurations[ "vehicleType" ])
        if configItem ~ = nil then
            if configItem.vehicleType ~ = nil then
                local configType = g_vehicleTypeManager:getTypeByName(configItem.vehicleType, self.customEnvironment)
                if configType ~ = nil then
                    typeDef = configType
                else
                        Logging.warning( "Unknown vehicle type '%s' in configuration for '%s'" , configItem.vehicleType, self.configFileName)
                        end
                    end
                end
            end

            SpecializationUtil.initSpecializationsIntoTypeClass(g_vehicleTypeManager, typeDef, self )
        end

```

### setUniqueId

**Description**

> Sets this vehicle's unique id. Note that a vehicle's id should not be changed once it has been first set.

**Definition**

> setUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id to use. |
|--------|----------|-----------------------|

**Code**

```lua
function Vehicle:setUniqueId(uniqueId)
    --#debug Assert.isType(uniqueId, "string", "Vehicle unique id must be a string!")
    --#debug Assert.isNil(self.uniqueId, "Should not change a vehicle's unique id!")
    self.uniqueId = uniqueId
end

```

### setVisibility

**Description**

> Sets visibility of a vehicle

**Definition**

> setVisibility(boolean state)

**Arguments**

| boolean | state | visibility state |
|---------|-------|------------------|

**Code**

```lua
function Vehicle:setVisibility(state)
    for _, component in pairs( self.components) do
        setVisibility(component.node, state)
    end
end

```

### setWorldPosition

**Description**

> Set world position and rotation of component

**Definition**

> setWorldPosition(float x, float y, float z, float xRot, float yRot, float zRot, integer componentIndex, boolean
> changeInterp)

**Arguments**

| float   | x              | x position           |
|---------|----------------|----------------------|
| float   | y              | y position           |
| float   | z              | z position           |
| float   | xRot           | x rotation           |
| float   | yRot           | y rotation           |
| float   | zRot           | z rotation           |
| integer | componentIndex | index if component   |
| boolean | changeInterp   | change interpolation |

**Code**

```lua
function Vehicle:setWorldPosition(x, y, z, xRot, yRot, zRot, componentIndex, changeInterp)
    local component = self.components[componentIndex]
    if component ~ = nil then
        setWorldTranslation(component.node, x, y, z)
        setWorldRotation(component.node, xRot, yRot, zRot)
        if changeInterp then
            local qx, qy, qz, qw = mathEulerToQuaternion(xRot, yRot, zRot)
            component.networkInterpolators.quaternion:setQuaternion(qx, qy, qz, qw)
            component.networkInterpolators.position:setPosition(x, y, z)
        end
    end
end

```

### setWorldPositionQuaternion

**Description**

> Set world position and quaternion rotation of component

**Definition**

> setWorldPositionQuaternion(float x, float y, float z, float qx, float qy, float qz, float qw, integer componentIndex,
> boolean changeInterp)

**Arguments**

| float   | x              | x position           |
|---------|----------------|----------------------|
| float   | y              | y position           |
| float   | z              | z position           |
| float   | qx             | x rotation           |
| float   | qy             | y rotation           |
| float   | qz             | z rotation           |
| float   | qw             | w rotation           |
| integer | componentIndex | index if component   |
| boolean | changeInterp   | change interpolation |

**Code**

```lua
function Vehicle:setWorldPositionQuaternion(x, y, z, qx, qy, qz, qw, componentIndex, changeInterp)
    local component = self.components[componentIndex]
    if component ~ = nil then
        --#profile RemoteProfiler.zoneBeginN("translation")
        setWorldTranslation(component.node, x, y, z)
        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("quaternion")
        setWorldQuaternion(component.node, qx, qy, qz, qw)
        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("interpolator")
        if changeInterp then
            component.networkInterpolators.quaternion:setQuaternion(qx, qy, qz, qw)
            component.networkInterpolators.position:setPosition(x, y, z)
        end
        --#profile RemoteProfiler.zoneEnd()
    end
end

```

### showInfo

**Description**

**Definition**

> showInfo()

**Arguments**

| any | box |
|-----|-----|

**Code**

```lua
function Vehicle:showInfo(box)
    if self.isBroken then
        box:addLine(g_i18n:getText( "infohud_vehicleBrokenNeedToReset" ), nil , true )
    end
end

```

### unselectVehicle

**Description**

**Definition**

> unselectVehicle()

**Code**

```lua
function Vehicle:unselectVehicle()
    self.selectionObject.isSelected = false
    SpecializationUtil.raiseEvent( self , "onUnselect" )

    self:requestActionEventUpdate()
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
function Vehicle:update(dt)
    --#profile RemoteProfiler.zoneBeginN("Vehicle:update-positionValidation")
    if self.isServer then
        local mapBoundingSize = g_currentMission.terrainSize -- allow the doubled range of the terrain, so the train is not resetted

        local wx, wy, wz = getTranslation( self.rootNode)
        if MathUtil.isNan(wx) then
            if not self.isDeleting or self.isDeleted then
                Logging.error( "Invalid vehicle translation detected, resetting to shop(%s)" , self.configFileName)
                self:setRelativePosition( 0 , 0 , 0 , 0 )

                self:reset( true , nil , true )
            end

            return
        elseif wx < - mapBoundingSize or wx > mapBoundingSize or wz < - mapBoundingSize or wz > mapBoundingSize then
                if not self.isDeleting or self.isDeleted then
                    Logging.error( "Vehicle outside of the world detected, resetting to shop(%s)" , self.configFileName)

                    self:reset( true , nil , true )
                end

                return
            elseif wy < - mapBoundingSize then
                    if not self.isDeleting or self.isDeleted then
                        local resetThreshold = mapBoundingSize * 0.5 - 25
                        if wx < - resetThreshold or wx > resetThreshold or wz < - resetThreshold or wz > resetThreshold then
                            Logging.error( "Vehicle below the world detected, resetting to shop(%s)" , self.configFileName)

                            -- if we are too close to the map border or outside the map, we reset to the shop
                                self:reset( true , nil , true )
                            else
                                    if self.terrainHeightResetCounter > 5 then
                                        self.terrainHeightResetCounter = 0

                                        Logging.error( "Vehicle below the world detected multiple times, resetting to shop(%s)" , self.configFileName)

                                        -- if we are too often below the terrain, we reset to the shop
                                            self:reset( true , nil , true )
                                            return
                                        end

                                        Logging.error( "Vehicle below the world detected, resetting to terrain level again(%s)" , self.configFileName)
                                        self.rootVehicle:resetPositionToTerrainHeight()
                                        self.terrainHeightResetCounter = self.terrainHeightResetCounter + 1
                                    end
                                end

                                return
                            end
                        end
                        --#profile RemoteProfiler.zoneEnd()

                        -- states
                        --#profile RemoteProfiler.zoneBeginN("Vehicle:update-initVariables")
                        self.isActive = self:getIsActive()
                        local isActiveForInput = self:getIsActiveForInput()
                        local isActiveForInputIgnoreSelection = self:getIsActiveForInput( true )
                        local isSelected = self:getIsSelected()
                        local lastDistanceToCamera = 999999

                        local rootNode = self.rootNode
                        if rootNode ~ = nil then
                            local cameraNode = g_cameraManager:getActiveCamera()
                            lastDistanceToCamera = calcDistanceFrom(rootNode, cameraNode)
                        end

                        self.lastDistanceToCamera = lastDistanceToCamera
                        self.currentUpdateDistance = lastDistanceToCamera / self.viewDistanceCoeff
                        self.isActiveForInputIgnoreSelectionIgnoreAI = self:getIsActiveForInput( true , true )
                        self.isActiveForLocalSound = self.isActiveForInputIgnoreSelectionIgnoreAI
                        self.updateLoopIndex = g_updateLoopIndex

                        --#profile RemoteProfiler.zoneEnd()

                        SpecializationUtil.raiseEvent( self , "onPreUpdate" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

                        -- interpolation of position
                        if not self.isServer and self.synchronizePosition then
                            self.networkTimeInterpolator:update(dt)
                            local interpolationAlpha = self.networkTimeInterpolator:getAlpha()
                            for i, component in pairs( self.components) do
                                if not component.isStatic then
                                    local posX, posY, posZ = component.networkInterpolators.position:getInterpolatedValues(interpolationAlpha)
                                    local quatX, quatY, quatZ, quatW = component.networkInterpolators.quaternion:getInterpolatedValues(interpolationAlpha)
                                    --#profile RemoteProfiler.zoneBeginN("Vehicle:update-interpolation-setWorldPositionQuaternion")
                                    self:setWorldPositionQuaternion(posX, posY, posZ, quatX, quatY, quatZ, quatW, i, false )
                                    --#profile RemoteProfiler.zoneEnd()
                                end
                            end

                            if self.networkTimeInterpolator:isInterpolating() then
                                self:raiseActive()
                            end
                        end

                        SpecializationUtil.raiseEvent( self , "onUpdateInterpolation" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

                        --#profile RemoteProfiler.zoneBeginN("Vehicle:update-vehicleSpeed")
                        self:updateVehicleSpeed(dt)
                        --#profile RemoteProfiler.zoneEnd()

                        --#profile RemoteProfiler.zoneBeginN("Vehicle:update-updateActionEvents")
                        if self.actionEventUpdateRequested then
                            self:updateActionEvents()
                        end
                        --#profile RemoteProfiler.zoneEnd()

                        --#profile RemoteProfiler.zoneBeginN("Vehicle:update-automaticVehicleControl")
                        if Platform.gameplay.automaticVehicleControl then
                            if self.actionController ~ = nil then
                                self.actionController:update(dt)
                                self.actionController:updateForAI(dt)
                            end
                        else
                                if self.actionController ~ = nil then
                                    self.actionController:updateForAI(dt)
                                end
                            end
                            --#profile RemoteProfiler.zoneEnd()

                            SpecializationUtil.raiseEvent( self , "onUpdate" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
                            if Vehicle.debuggingActive then
                                SpecializationUtil.raiseEvent( self , "onUpdateDebug" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
                            end
                            SpecializationUtil.raiseEvent( self , "onPostUpdate" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

                            if self.finishedFirstUpdate and self.isMassDirty then
                                self.isMassDirty = false
                                self:updateMass()
                            end

                            self.finishedFirstUpdate = true

                            if self.isServer then
                                if not getIsSleeping( self.rootNode) then
                                    self:raiseActive()
                                end
                            end

                            VehicleDebug.updateDebug( self , dt)

                            self:updateMapHotspot()
                        end

```

### updateActionEvents

**Description**

**Definition**

> updateActionEvents()

**Code**

```lua
function Vehicle:updateActionEvents()
    local rootVehicle = self.rootVehicle
    rootVehicle:registerActionEvents()
end

```

### updateEnd

**Description**

**Definition**

> updateEnd()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Vehicle:updateEnd(dt)
    local isActiveForInput = self:getIsActiveForInput()
    local isActiveForInputIgnoreSelection = self:getIsActiveForInput( true )
    local isSelected = self:getIsSelected()

    -- on the last update we update with distance 0, so we make sure the vehicle is in the correct state before falling asleep
    self.currentUpdateDistance = 0

    SpecializationUtil.raiseEvent( self , "onUpdateEnd" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
end

```

### updateMapHotspot

**Description**

**Definition**

> updateMapHotspot()

**Code**

```lua
function Vehicle:updateMapHotspot()
    if self.mapHotspot ~ = nil then
        self.mapHotspot:setVisible( self:getIsMapHotspotVisible())
    end
end

```

### updateMass

**Description**

**Definition**

> updateMass()

**Code**

```lua
function Vehicle:updateMass()
    self.serverMass = 0

    for k, component in ipairs( self.components) do
        if component.defaultMass = = nil then
            if component.isDynamic then
                component.defaultMass = getMass(component.node)
            else
                    component.defaultMass = 1
                end
                component.mass = component.defaultMass
            end

            local mass = self:getAdditionalComponentMass(component)
            if mass = = math.huge then
                Logging.devError( "%s:Additional component '%d' mass is inf!" , self.configFileName, k)
            end

            component.mass = component.defaultMass + mass
            if component.mass = = math.huge then
                Logging.devError( "%s:Setting component '%d' mass to inf!" , self.configFileName, k)
            end

            self.serverMass = self.serverMass + component.mass
        end

        local realTotalMass = 0
        for _, component in ipairs( self.components) do
            realTotalMass = realTotalMass + self:getComponentMass(component)
        end

        self.precalculatedMass = realTotalMass - self.serverMass

        for k, component in ipairs( self.components) do
            local maxFactor = self.serverMass / ( self.maxComponentMass - self.precalculatedMass)

            if maxFactor > 1 then
                component.mass = component.mass / maxFactor
                if component.mass = = math.huge then
                    Logging.devError( "%s:Scaling component '%d' mass to inf! MaxFactor %s | serverMass %s | maxComponentMass %s | precalculatedMass %s" , self.configFileName, k, maxFactor, self.serverMass, self.maxComponentMass, self.precalculatedMass)
                end
            end

            -- only update physically mass if difference to last mass is greater 20kg
                if self.isServer and component.isDynamic and math.abs(component.lastMass - component.mass) > 0.02 then
                    setMass(component.node, component.mass)
                    component.lastMass = component.mass
                end
            end

            self.serverMass = math.min( self.serverMass, self.maxComponentMass - self.precalculatedMass)
        end

```

### updateSelectableObjects

**Description**

**Definition**

> updateSelectableObjects()

**Code**

```lua
function Vehicle:updateSelectableObjects()
    self.selectableObjects = { }
    if self = = self.rootVehicle then
        self:registerSelectableObjects( self.selectableObjects)
    end
end

```

### updateTick

**Description**

> updateTick

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function Vehicle:updateTick(dt)
    if self.isServer then
        local wx, _, _ = getWorldTranslation( self.rootNode)
        if MathUtil.isNan(wx) then
            return
        end
    end

    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-getIsActiveForInput")
    local isActiveForInput = self:getIsActiveForInput()
    --#profile RemoteProfiler.zoneEnd()
    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-getIsActiveForInput(true)")
    local isActiveForInputIgnoreSelection = self:getIsActiveForInput( true )
    --#profile RemoteProfiler.zoneEnd()
    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-getIsSelected")
    local isSelected = self:getIsSelected()
    --#profile RemoteProfiler.zoneEnd()

    if self.isActive and self.needWaterInfo then
        --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-updateWaterInfo")
        self:updateWaterInfo()
        --#profile RemoteProfiler.zoneEnd()
    end

    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-getIsOnField")
    self.isOnField = self:getIsOnField()
    --#profile RemoteProfiler.zoneEnd()

    if self.isServer then
        if self.synchronizePosition then
            --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-synchronizePosition")
            local hasOwner = self:getOwnerConnection() ~ = nil
            for i = 1 , # self.components do
                local component = self.components[i]
                if not component.isStatic then
                    local x,y,z = getWorldTranslation(component.node)
                    local x_rot,y_rot,z_rot = getWorldRotation(component.node)
                    local sentTranslation = component.sentTranslation
                    local sentRotation = component.sentRotation
                    if hasOwner or
                        math.abs(x - sentTranslation[ 1 ]) > 0.005 or
                        math.abs(y - sentTranslation[ 2 ]) > 0.005 or
                        math.abs(z - sentTranslation[ 3 ]) > 0.005 or
                        math.abs(x_rot - sentRotation[ 1 ]) > 0.1 or
                        math.abs(y_rot - sentRotation[ 2 ]) > 0.1 or
                        math.abs(z_rot - sentRotation[ 3 ]) > 0.1
                        then
                        self:raiseDirtyFlags( self.vehicleDirtyFlag)
                        sentTranslation[ 1 ] = x
                        sentTranslation[ 2 ] = y
                        sentTranslation[ 3 ] = z
                        sentRotation[ 1 ] = x_rot
                        sentRotation[ 2 ] = y_rot
                        sentRotation[ 3 ] = z_rot

                        self.lastMoveTime = g_currentMission.time
                    end
                end
            end
            --#profile RemoteProfiler.zoneEnd()
        end
    end

    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-tailwaterWarning")
    -- is the vehicle sunken in the water?
    self.showTailwaterDepthWarning = false
    if not self.isBroken and not g_gui:getIsGuiVisible() then
        if self.tailwaterDepth > self.thresholdTailwaterDepthWarning then
            self.showTailwaterDepthWarning = true
            if self.tailwaterDepth > self.thresholdTailwaterDepth then
                self:setBroken()
            end
        end
    end

    local rootAttacherVehicle = self.rootVehicle
    if rootAttacherVehicle ~ = nil and rootAttacherVehicle ~ = self then
        rootAttacherVehicle.showTailwaterDepthWarning = rootAttacherVehicle.showTailwaterDepthWarning or self.showTailwaterDepthWarning
    end
    --#profile RemoteProfiler.zoneEnd()

    --#profile RemoteProfiler.zoneBeginN("Vehicle:updateTick-operating")
    if self:getIsOperating() then
        self:setOperatingTime( self.operatingTime + dt)
    end
    --#profile RemoteProfiler.zoneEnd()

    SpecializationUtil.raiseEvent( self , "onUpdateTick" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    SpecializationUtil.raiseEvent( self , "onPostUpdateTick" , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
end

```

### updateVehicleChain

**Description**

**Definition**

> updateVehicleChain()

**Arguments**

| any | secondCall |
|-----|------------|

**Code**

```lua
function Vehicle:updateVehicleChain(secondCall)
    local rootVehicle = self:findRootVehicle()
    if rootVehicle ~ = self.rootVehicle then
        self.rootVehicle = rootVehicle
        SpecializationUtil.raiseEvent( self , "onRootVehicleChanged" , rootVehicle)
    end

    if rootVehicle ~ = self and not secondCall then
        rootVehicle:updateVehicleChain()
        return
    end

    for i = # self.childVehicles, 1 , - 1 do
        self.childVehicles[i] = nil
    end

    self.childVehicleHash = ""

    self:addChildVehicles( self.childVehicles, self )

    if rootVehicle = = self then
        for i = 1 , # self.childVehicles do
            if self.childVehicles[i] ~ = rootVehicle then
                self.childVehicles[i]:updateVehicleChain( true )
            end
        end
    end
end

```

### updateVehicleSpeed

**Description**

**Definition**

> updateVehicleSpeed()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Vehicle:updateVehicleSpeed(dt)
    -- On servers, the physics state is only change
    if self.finishedFirstUpdate and not self.components[ 1 ].isStatic then
        local speedReal = 0
        local movedDistance = 0
        local movingDirection = 0
        local signedSpeedReal = 0

        if not self.isServer or self.components[ 1 ].isKinematic then
            if not self.isServer and self.synchronizePosition then
                -- Client code can use the interpolation information that is driving the position change
                local interpPos = self.components[ 1 ].networkInterpolators.position
                local dx, dy, dz = 0 , 0 , 0
                if self.networkTimeInterpolator:isInterpolating() then
                    dx, dy, dz = worldDirectionToLocal( self.directionReferenceNode or self.components[ 1 ].node, interpPos.targetPositionX - interpPos.lastPositionX, interpPos.targetPositionY - interpPos.lastPositionY, interpPos.targetPositionZ - interpPos.lastPositionZ)
                end

                if dz > 0.001 then
                    movingDirection = 1
                elseif dz < - 0.001 then
                        movingDirection = - 1
                    end
                    speedReal = MathUtil.vector3Length(dx, dy, dz) / self.networkTimeInterpolator.interpolationDuration
                    signedSpeedReal = speedReal * (dz > = 0 and 1 or - 1 )
                    movedDistance = speedReal * dt
                else
                        -- Client or kinematic code can't use physics velocity, so calculate based on the position change
                        local x,y,z = getWorldTranslation( self.components[ 1 ].node)
                        if self.lastPosition = = nil then
                            self.lastPosition = { x,y,z }
                        end
                        local dx, dy, dz = worldDirectionToLocal( self.directionReferenceNode or self.components[ 1 ].node, x - self.lastPosition[ 1 ], y - self.lastPosition[ 2 ], z - self.lastPosition[ 3 ])
                        self.lastPosition[ 1 ], self.lastPosition[ 2 ], self.lastPosition[ 3 ] = x, y, z
                        if dz > 0.001 then
                            movingDirection = 1
                        elseif dz < - 0.001 then
                                movingDirection = - 1
                            end
                            movedDistance = MathUtil.vector3Length(dx, dy, dz)
                            speedReal = movedDistance / dt
                            signedSpeedReal = speedReal * (dz > = 0 and 1 or - 1 )
                        end
                    elseif self.components[ 1 ].isDynamic then
                            -- Dynamic objects on server use velocity provided by the physics engine
                            local vx, vy, vz = getLocalLinearVelocity( self.components[ 1 ].node)
                            if self.directionReferenceNode ~ = nil then
                                vx, vy, vz = localDirectionToLocal( self.components[ 1 ].node, self.directionReferenceNode, vx, vy, vz)
                            end
                            speedReal = MathUtil.vector3Length(vx, vy, vz) * 0.001
                            movedDistance = speedReal * g_physicsDt
                            signedSpeedReal = speedReal * (vz > = 0 and 1 or - 1 )
                            if vz > 0.001 then
                                movingDirection = 1
                            elseif vz < - 0.001 then
                                    movingDirection = - 1
                                end
                            end

                            if self.isServer then
                                -- On the server, the velocity only changes when a physics simulation step is performed(thus only update the acceleration when something was simulated)
                                if g_physicsDtNonInterpolated > 0 then
                                    self.lastSpeedAcceleration = (speedReal * movingDirection - self.lastSpeedReal * self.movingDirection) / g_physicsDtNonInterpolated
                                end
                            else
                                    -- On the client, the position is driven by the interpolation(updated with dt)
                                    self.lastSpeedAcceleration = (speedReal * movingDirection - self.lastSpeedReal * self.movingDirection) / dt
                                end

                                -- Update smooth values(use less smoothing on the server)
                                if self.isServer then
                                    self.lastSpeed = self.lastSpeed * 0.5 + speedReal * 0.5
                                    self.lastSignedSpeed = self.lastSignedSpeed * 0.5 + signedSpeedReal * 0.5
                                else
                                        self.lastSpeed = self.lastSpeed * 0.9 + speedReal * 0.1
                                        self.lastSignedSpeed = self.lastSignedSpeed * 0.9 + signedSpeedReal * 0.1
                                    end
                                    self.lastSpeedSmoothed = self.lastSpeedSmoothed * 0.9 + speedReal * 0.1
                                    self.lastSpeedReal = speedReal
                                    self.lastSignedSpeedReal = signedSpeedReal
                                    self.movingDirection = movingDirection
                                    self.lastMovedDistance = movedDistance
                                end
                            end

```

### updateWaterInfo

**Description**

**Definition**

> updateWaterInfo()

**Code**

```lua
function Vehicle:updateWaterInfo()
    if self.waterCheckIsPending then
        return
    end

    -- water info is always one frame delayed for current position(async)
        -- start the raycast in the center of the vehicle, so we detect the depth also correctly if the vehicle is upside down or on the side
            local x, y, z = localToWorld( self.rootNode, 0 , self.size.height * 0.5 , 0 )
            self.waterCheckPosition[ 1 ] = x
            self.waterCheckPosition[ 2 ] = y
            self.waterCheckPosition[ 3 ] = z
            self.waterCheckIsPending = true

            local raycastDistance = 50
            raycastClosestAsync(x, y + raycastDistance * 0.5 , z, 0 , - 1 , 0 , raycastDistance, "onWaterRaycastCallback" , self , CollisionFlag.WATER)
        end

```

### wakeUp

**Description**

> Shortly wake up the vehicle physics

**Definition**

> wakeUp()

**Code**

```lua
function Vehicle:wakeUp()
    I3DUtil.wakeUpObject( self.components[ 1 ].node)
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function Vehicle:writeStream(streamId, connection)
    Vehicle:superClass().writeStream( self , streamId, connection)

    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.configFileName))

    ConfigurationUtil.writeConfigurationsToStream(g_vehicleConfigurationManager, streamId, connection, self.configFileName, self.configurations, self.boughtConfigurations, self.configurationData)

    VehiclePropertyState.writeStream(streamId, self.propertyState)
end

```

### writeUpdateStream

**Description**

> Called on server side on update

**Definition**

> writeUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Vehicle:writeUpdateStream(streamId, connection, dirtyMask)
    if not connection.isServer then
        if streamWriteBool(streamId, bit32.band(dirtyMask, self.vehicleDirtyFlag) ~ = 0 ) then

            local paramsXZ = self.highPrecisionPositionSynchronization and( self.vehicleXZPosHighPrecisionCompressionParams or g_currentMission.vehicleXZPosHighPrecisionCompressionParams) or( self.vehicleXZPosCompressionParams or g_currentMission.vehicleXZPosCompressionParams)
            local paramsY = self.highPrecisionPositionSynchronization and( self.vehicleYPosHighPrecisionCompressionParams or g_currentMission.vehicleYPosHighPrecisionCompressionParams) or( self.vehicleYPosCompressionParams or g_currentMission.vehicleYPosCompressionParams)
            for i = 1 , # self.components do
                local component = self.components[i]
                if not component.isStatic then
                    local x,y,z = getWorldTranslation(component.node)
                    local x_rot,y_rot,z_rot = getWorldRotation(component.node)
                    NetworkUtil.writeCompressedWorldPosition(streamId, x, paramsXZ)
                    NetworkUtil.writeCompressedWorldPosition(streamId, y, paramsY)
                    NetworkUtil.writeCompressedWorldPosition(streamId, z, paramsXZ)
                    NetworkUtil.writeCompressedAngle(streamId, x_rot)
                    NetworkUtil.writeCompressedAngle(streamId, y_rot)
                    NetworkUtil.writeCompressedAngle(streamId, z_rot)
                end
            end
            SpecializationUtil.raiseEvent( self , "onWritePositionUpdateStream" , streamId, connection, dirtyMask)
        end
    end

    if Vehicle.DEBUG_NETWORK_READ_WRITE_UPDATE then
        print( "-------------------------------------------------------------" )
        print( self.configFileName)
        for _, spec in ipairs( self.eventListeners[ "onWriteUpdateStream" ]) do
            local className = ClassUtil.getClassName(spec)
            local startBits = streamGetWriteOffset(streamId)
            spec[ "onWriteUpdateStream" ]( self , streamId, connection, dirtyMask)
            print( " " .. tostring(className) .. " Wrote " .. streamGetWriteOffset(streamId) - startBits .. " bits" )
        end
    else
            SpecializationUtil.raiseEvent( self , "onWriteUpdateStream" , streamId, connection, dirtyMask)
        end
    end

```