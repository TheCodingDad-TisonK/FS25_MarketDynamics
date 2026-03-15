## Pallet

**Description**

> Specialization for handling the content on the big bags

**Functions**

- [autoLoad](#autoload)
- [collectPalletTensionBeltNodes](#collectpallettensionbeltnodes)
- [getAutoLoadSize](#getautoloadsize)
- [getCanBeReset](#getcanbereset)
- [getFillUnitEmptyOnReset](#getfillunitemptyonreset)
- [getInfoBoxTitle](#getinfoboxtitle)
- [getIsMapHotspotVisible](#getismaphotspotvisible)
- [getMeshNodes](#getmeshnodes)
- [getShowInVehiclesOverview](#getshowinvehiclesoverview)
- [initSpecialization](#initspecialization)
- [loadComponentFromXML](#loadcomponentfromxml)
- [onDelete](#ondelete)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPreLoad](#onpreload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setPalletTensionBeltNodesDirty](#setpallettensionbeltnodesdirty)

### autoLoad

**Description**

**Definition**

> autoLoad()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | autoLoader |
| any | node       |
| any | posX       |
| any | posZ       |
| any | sizeX      |
| any | sizeZ      |

**Code**

```lua
function Pallet:autoLoad(superFunc, autoLoader, node, posX, posZ, sizeX, sizeZ)
    local mountPosX = posX + sizeX * 0.5
    local mountPosY = 0
    local mountPosZ = posZ + sizeZ * 0.5
    local mountRotX = 0
    local mountRotY = math.pi * 0.5
    local mountRotZ = 0

    self:mountKinematic(autoLoader, node, mountPosX, mountPosY, mountPosZ, mountRotX, mountRotY, mountRotZ)

    return true
end

```

### collectPalletTensionBeltNodes

**Description**

**Definition**

> collectPalletTensionBeltNodes()

**Arguments**

| any | nodes |
|-----|-------|

**Code**

```lua
function Pallet:collectPalletTensionBeltNodes(nodes)
    local spec = self.spec_pallet
    if #spec.tensionBeltNodes > 0 then
        for _, node in ipairs(spec.tensionBeltNodes) do
            table.insert(nodes, node)
        end
    end

    for i = 1 , #spec.contents do
        local content = spec.contents[i]
        for j = 1 , #content.objects do
            local object = content.objects[j]
            if object.isActive and object.useAsTensionBeltMesh then
                table.insert(nodes, object.tensionBeltNode or object.node)
            end
        end
    end

    -- add additional mesh nodes that are defined via xml
    if self.spec_tensionBeltObject ~ = nil then
        for _, meshNode in ipairs( self.spec_tensionBeltObject.meshNodes) do
            table.insert(nodes, meshNode)
        end
    end
end

```

### getAutoLoadSize

**Description**

**Definition**

> getAutoLoadSize()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getAutoLoadSize(superFunc)
    local size = self.size
    -- pallets are rotated by 90°.so we need to switch length and width
    local sizeX = size.length
    local sizeY = size.height
    local sizeZ = size.width

    return sizeX, sizeY, sizeZ
end

```

### getCanBeReset

**Description**

**Definition**

> getCanBeReset()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getCanBeReset(superFunc)
    return false
end

```

### getFillUnitEmptyOnReset

**Description**

**Definition**

> getFillUnitEmptyOnReset()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getFillUnitEmptyOnReset(superFunc)
    return false
end

```

### getInfoBoxTitle

**Description**

**Definition**

> getInfoBoxTitle()

**Code**

```lua
function Pallet:getInfoBoxTitle()
    return g_i18n:getText( "infohud_pallet" )
end

```

### getIsMapHotspotVisible

**Description**

**Definition**

> getIsMapHotspotVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getIsMapHotspotVisible(superFunc)
    return false
end

```

### getMeshNodes

**Description**

**Definition**

> getMeshNodes()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getMeshNodes(superFunc)
    local spec = self.spec_pallet
    if spec.tensionBeltMeshesDirty then
        spec.tensionBeltMeshes = { }
        self:collectPalletTensionBeltNodes(spec.tensionBeltMeshes)
        spec.tensionBeltMeshesDirty = false
    end

    if #spec.tensionBeltMeshes > 0 then
        return spec.tensionBeltMeshes
    end

    return superFunc( self )
end

```

### getShowInVehiclesOverview

**Description**

**Definition**

> getShowInVehiclesOverview()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Pallet:getShowInVehiclesOverview(superFunc)
    return false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Pallet.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Pallet" )

    schema:register(XMLValueType.INT, "vehicle.pallet#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet#node" , "Root visual pallet node" )
    schema:register(XMLValueType.NODE_INDICES, "vehicle.pallet#linkNode" , "Link node for externally loaded visual pallet(can be multiple link nodes separated by space)" )
        schema:register(XMLValueType.FILENAME, "vehicle.pallet#filename" , "Path to visual pallet i3d file to load" , "$data/objects/pallets/shared/euroPallet/euroPallet.i3d" )
        schema:register(XMLValueType.FILENAME, "vehicle.pallet.texture(?)#diffuse" , "Path to the diffuse texture to use(if multiple are defined it will switch between them randomly)" )

            schema:register(XMLValueType.INT, "vehicle.pallet.content(?)#fillUnitIndex" , "Fill unit index for this content" , "pallet#fillUnitIndex" )
                schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet.content(?).object(?)#node" , "Object node" )
                schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet.content(?).object(?)#tensionBeltNode" , "Object used for tension belt calculations" )
                    schema:register(XMLValueType.BOOL, "vehicle.pallet.content(?).object(?)#useAsTensionBeltMesh" , "Flag for toggling object node being used as tension belt node" , true )

                        schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet.straps.strap(?)#startNode" , "Start node of the strap" )
                        schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet.straps.strap(?)#endNode" , "End node of the strap" )
                        schema:register(XMLValueType.STRING, "vehicle.pallet.straps.strap(?)#tensionBeltType" , "Type of the tension belt to use" , "basic" )
                        schema:register(XMLValueType.NODE_INDEX, "vehicle.pallet.straps.strap(?).intersectionNode(?)#node" , "Intersection node" )

                        SoundManager.registerSampleXMLPaths(schema, "vehicle.pallet.sounds" , "unload" )

                        schema:setXMLSpecializationType()

                        local schemaSavegame = Vehicle.xmlSchemaSavegame
                        local key = "vehicles.vehicle(?).pallet"
                        schemaSavegame:register(XMLValueType.FLOAT, key .. "#age" , "Random age of the pallet [0-1]" )
                    end

```

### loadComponentFromXML

**Description**

**Definition**

> loadComponentFromXML()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | component    |
| any | xmlFile      |
| any | key          |
| any | rootPosition |
| any | i            |

**Code**

```lua
function Pallet:loadComponentFromXML(superFunc, component, xmlFile, key, rootPosition, i)
    if not Platform.gameplay.hasDynamicPallets then
        if getRigidBodyType(component.node) = = RigidBodyType.DYNAMIC then
            setRigidBodyType(component.node, RigidBodyType.KINEMATIC)
        end
    end

    return superFunc( self , component, xmlFile, key, rootPosition, i)
end

```

### onDelete

**Description**

> Called on delete

**Definition**

> onDelete()

**Code**

```lua
function Pallet:onDelete()
    local spec = self.spec_pallet
    if self.isClient then
        g_soundManager:deleteSamples(spec.samples)
    end

    if spec.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile(spec.sharedLoadRequestId)
        spec.sharedLoadRequestId = nil
    end

    g_currentMission.slotSystem:removeLimitedObject(SlotSystem.LIMITED_OBJECT_PALLET, self )
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillType         |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function Pallet:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_pallet
    for i = 1 , #spec.contents do
        local content = spec.contents[i]

        if content.fillUnitIndex = = fillUnitIndex then
            local fillLevelPct = self:getFillUnitFillLevelPercentage(fillUnitIndex)

            local visibleIndex = math.floor(content.numObjects * fillLevelPct)
            if visibleIndex = = 0 and fillLevelPct then
                visibleIndex = 1 -- show at least one object if somethign is loaded
                end

                for j = 1 , #content.objects do
                    local object = content.objects[j]
                    local isActive = j < = visibleIndex
                    if object.isActive ~ = isActive then
                        local unloading = object.isActive and not isActive

                        if unloading then
                            if self.isClient then
                                g_soundManager:playSample(spec.samples.unload)
                            end
                        end

                        object.isActive = isActive
                        setVisibility(object.node, object.isActive)
                        self:setPalletTensionBeltNodesDirty()
                    end
                end
            end
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
function Pallet:onLoad(savegame)
    local spec = self.spec_pallet

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.pallet#fillUnitIndex" , 1 )
    spec.node = self.xmlFile:getValue( "vehicle.pallet#node" , nil , self.components, self.i3dMappings)
    if spec.node ~ = nil then
        if not getHasClassId(spec.node, ClassIds.SHAPE) then
            Logging.xmlWarning( self.xmlFile, "Pallet node must be a shape in 'vehicle.pallet#node'" )
            spec.node = nil
        end
    end

    spec.nodes = { spec.node }
    spec.tensionBeltNodes = { spec.node }

    spec.linkNodes = self.xmlFile:getValue( "vehicle.pallet#linkNode" , nil , self.components, self.i3dMappings, true )
    if #spec.linkNodes > 0 then
        spec.filename = self.xmlFile:getValue( "vehicle.pallet#filename" , "$data/objects/pallets/shared/euroPallet/euroPallet.i3d" , self.baseDirectory)
        if spec.filename ~ = nil then
            spec.sharedLoadRequestId = self:loadSubSharedI3DFile(spec.filename, true , true , self.onPalletI3DFileLoaded, self )
        end
    end

    spec.textures = { }
    for _, key in self.xmlFile:iterator( "vehicle.pallet.texture" ) do
        local texture = { }
        texture.diffuse = self.xmlFile:getValue(key .. "#diffuse" , nil , self.baseDirectory)
        if texture.diffuse ~ = nil then
            table.insert(spec.textures, texture)
        end
    end

    if savegame ~ = nil then
        spec.palletAge = savegame.xmlFile:getValue(savegame.key .. ".pallet#age" )
    end

    if spec.palletAge = = nil then
        if self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG then
            spec.palletAge = math.random()
        else
                spec.palletAge = 0
            end
        end

        spec.contents = { }
        for _, contentKey in self.xmlFile:iterator( "vehicle.pallet.content" ) do
            local content = { }
            content.objects = { }
            content.fillUnitIndex = self.xmlFile:getValue(contentKey .. "#fillUnitIndex" , spec.fillUnitIndex)

            for index, key in self.xmlFile:iterator(contentKey .. ".object" ) do
                local object = { }
                object.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                if object.node ~ = nil then
                    object.useAsTensionBeltMesh = self.xmlFile:getValue(key .. "#useAsTensionBeltMesh" , true )

                    if object.useAsTensionBeltMesh then
                        local tensionBeltNode = self.xmlFile:getValue(key .. "#tensionBeltNode" , nil , self.components, self.i3dMappings)

                        if tensionBeltNode ~ = nil then
                            if getShapeIsCPUMesh(tensionBeltNode) then
                                object.tensionBeltNode = tensionBeltNode
                            else
                                    Logging.xmlWarning( self.xmlFile, "Shape '%s' defined in '%s' does not have 'CPU-Mesh' flag set.Ignoring this node" , getName(tensionBeltNode), key .. "#tensionBeltNode" )
                                end
                            else
                                    -- node is default tension belt node if none is defined, check as well
                                        if not getShapeIsCPUMesh(object.node) then
                                            Logging.xmlWarning( self.xmlFile, "Shape '%s' defined in '%s' does not have 'CPU-Mesh' flag set.Either set the flag on the mesh or add a custom tension belt node using xml attribute '#tensionBeltNode'" , getName(object.node), key .. "#node" )
                                        end
                                    end
                                end

                                object.isActive = false
                                setVisibility(object.node, object.isActive)

                                table.insert(content.objects, object)
                            end
                        end

                        if #content.objects > 0 then
                            content.numObjects = #content.objects
                            table.insert(spec.contents, content)
                        end
                    end

                    spec.straps = { }
                    for _, key in self.xmlFile:iterator( "vehicle.pallet.straps.strap" ) do
                        local strap = { }
                        strap.startNode = self.xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
                        strap.endNode = self.xmlFile:getValue(key .. "#endNode" , nil , self.components, self.i3dMappings)
                        if strap.startNode ~ = nil and strap.endNode ~ = nil then
                            local tensionBeltType = self.xmlFile:getValue(key .. "#tensionBeltType" , "basic" )
                            strap.beltData = g_tensionBeltManager:getBeltData(tensionBeltType)
                            if strap.beltData ~ = nil then
                                strap.intersectionNodes = { }
                                for _, intersectionKey in self.xmlFile:iterator(key .. ".intersectionNode" ) do
                                    local intersectionNode = self.xmlFile:getValue(intersectionKey .. "#node" , nil , self.components, self.i3dMappings)
                                    if intersectionNode ~ = nil then
                                        table.insert(strap.intersectionNodes, intersectionNode)
                                    end
                                end

                                table.insert(spec.straps, strap)
                            else
                                    Logging.xmlWarning( self.xmlFile, "Invalid tension belt type '%s' defined for strap" , tensionBeltType)
                                    end
                                else
                                        Logging.xmlWarning( self.xmlFile, "Invalid strap definition.Both start and end node must be defined" )
                                    end
                                end
                                spec.strapMeshes = { }

                                spec.tensionBeltMeshes = { }
                                spec.tensionBeltMeshesDirty = true

                                if self.isClient then
                                    spec.samples = { }
                                    spec.samples.unload = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.pallet.sounds" , "unload" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                end

                                g_currentMission.slotSystem:addLimitedObject(SlotSystem.LIMITED_OBJECT_PALLET, self )

                                -- allow some movement of the joint in Y, otherwise the pallet will be pushed down to the fork permanently
                                -- this can cause issues in various situations and make the pallet and fork flying away(issue #50871)
                                -- joint is not fully free otherwise the pallet can fly away when the fork is raised fast
                                self.dynamicMountForkXLimit = 0.01
                                self.dynamicMountForkYLimit = 0.10
                            end

```

### onPostLoad

**Description**

> Called on post load

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Pallet:onPostLoad(savegame)
    local spec = self.spec_pallet

    if #spec.nodes > 0 then
        for _, node in ipairs(spec.nodes) do
            local materialId = getMaterial(node, 0 )
            local numTextures = #spec.textures
            if numTextures > 0 then
                if numTextures = = 1 then
                    materialId = setMaterialDiffuseMapFromFile(materialId, spec.textures[ 1 ].diffuse, true , true , false )
                else
                        local alpha = spec.palletAge * (numTextures - 1 )
                        local index1 = math.floor(alpha)
                        local index2 = math.ceil(alpha)

                        materialId = setMaterialDiffuseMapFromFile(materialId, spec.textures[index1 + 1 ].diffuse, true , true , false )
                        materialId = setMaterialCustomMapFromFile(materialId, spec.textures[index2 + 1 ].diffuse, "mCustomDiffuse" , true , true , false )
                        materialId = setMaterialCustomParameter(materialId, "blendScale" , alpha - index1, 0 , 0 , 0 , false )
                    end

                    setMaterial(node, materialId, 0 )
                end
            end
        end
    end

```

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Pallet:onPreLoad(savegame)
    self.isPallet = true
    self.allowsInput = false
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
function Pallet.prerequisitesPresent(specializations)
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
function Pallet.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , Pallet )
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Pallet )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Pallet )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Pallet )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Pallet )
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
function Pallet.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onPalletI3DFileLoaded" , Pallet.onPalletI3DFileLoaded)
    SpecializationUtil.registerFunction(vehicleType, "getInfoBoxTitle" , Pallet.getInfoBoxTitle)
    SpecializationUtil.registerFunction(vehicleType, "collectPalletTensionBeltNodes" , Pallet.collectPalletTensionBeltNodes)
    SpecializationUtil.registerFunction(vehicleType, "setPalletTensionBeltNodesDirty" , Pallet.setPalletTensionBeltNodesDirty)
    SpecializationUtil.registerFunction(vehicleType, "updatePalletStraps" , Pallet.updatePalletStraps)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function Pallet.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMeshNodes" , Pallet.getMeshNodes)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadComponentFromXML" , Pallet.loadComponentFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAutoLoadSize" , Pallet.getAutoLoadSize)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "autoLoad" , Pallet.autoLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShowInVehiclesOverview" , Pallet.getShowInVehiclesOverview)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeReset" , Pallet.getCanBeReset)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMapHotspotVisible" , Pallet.getIsMapHotspotVisible)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitEmptyOnReset" , Pallet.getFillUnitEmptyOnReset)
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
function Pallet:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_pallet
    xmlFile:setValue(key .. "#age" , spec.palletAge)
end

```

### setPalletTensionBeltNodesDirty

**Description**

**Definition**

> setPalletTensionBeltNodesDirty()

**Code**

```lua
function Pallet:setPalletTensionBeltNodesDirty()
    self.spec_pallet.tensionBeltMeshesDirty = true
end

```