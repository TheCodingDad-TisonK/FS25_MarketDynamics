## PlaceableHeapSpawner

**Description**

> Specialization for placeables

**Functions**

- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerXMLPaths](#registerxmlpaths)

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function PlaceableHeapSpawner:onFinalizePlacement(savegame)
    if self.isServer then
        self:raiseActive()
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
function PlaceableHeapSpawner:onLoad(savegame)
    local spec = self.spec_heapSpawner

    local key = "placeable.heapSpawner"

    spec.spawnAreas = { }

    for _, areaKey in self.xmlFile:iterator(key .. ".spawnArea" ) do
        local startNode = self.xmlFile:getValue(areaKey .. ".area#startNode" , nil , self.components, self.i3dMappings)
        if startNode = = nil then
            Logging.xmlError( self.xmlFile, "Missing startNode for spawnArea '%s'" , areaKey)
                continue
            end

            local widthNode = self.xmlFile:getValue(areaKey .. ".area#widthNode" , nil , self.components, self.i3dMappings)
            if widthNode = = nil then
                Logging.xmlError( self.xmlFile, "Missing widthNode for spawnArea '%s'" , areaKey)
                    continue
                end

                local heightNode = self.xmlFile:getValue(areaKey .. ".area#heightNode" , nil , self.components, self.i3dMappings)
                if heightNode = = nil then
                    Logging.xmlError( self.xmlFile, "Missing heightNode for spawnArea '%s'" , areaKey)
                        continue
                    end

                    local fillTypeName = self.xmlFile:getValue(areaKey .. "#fillType" , "" )
                    local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                    if fillTypeIndex = = nil then
                        Logging.xmlError( self.xmlFile, "Missing or invalid fillType(%s) for spawnArea '%s'" , fillTypeName, areaKey)
                            continue
                        end

                        local litersPerHour = self.xmlFile:getValue(areaKey .. "#litersPerHour" , 150 )
                        if litersPerHour < = 0 then
                            Logging.xmlError( self.xmlFile, "litersPerHour may not be 0 or negative for spawnArea '%s'" , areaKey)
                                continue
                            end

                            local spawnArea = {
                            start = startNode,
                            width = widthNode,
                            height = heightNode,
                            fillTypeIndex = fillTypeIndex,
                            litersPerMs = litersPerHour / ( 1000 * 60 * 60 ),
                            amountToTip = 0 ,
                            lineOffset = 0
                            }

                            if self.isClient then
                                spawnArea.effects = g_effectManager:loadEffect( self.xmlFile, areaKey .. ".effectNodes" , self.components, self , self.i3dMappings)
                                g_effectManager:setEffectTypeInfo(spawnArea.effects, fillTypeIndex)
                                g_effectManager:startEffects(spawnArea.effects)

                                spawnArea.samples = { }
                                spawnArea.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, areaKey .. ".sounds" , "work" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                                spawnArea.samples.work2 = g_soundManager:loadSampleFromXML( self.xmlFile, areaKey .. ".sounds" , "work2" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                                spawnArea.samples.dropping = g_soundManager:loadSampleFromXML( self.xmlFile, areaKey .. ".sounds" , "dropping" , self.baseDirectory, self.components, 1 , AudioGroup.ENVIRONMENT, self.i3dMappings, self )
                                g_soundManager:playSample(spawnArea.samples.work, 0 )
                                g_soundManager:playSample(spawnArea.samples.work2, 0 )
                                g_soundManager:playSample(spawnArea.samples.dropping, 0 )

                                spawnArea.animationNodes = g_animationManager:loadAnimations( self.xmlFile, areaKey .. ".animationNodes" , self.components, self , self.i3dMappings)
                                g_animationManager:startAnimations(spawnArea.animationNodes)
                            end

                            table.insert(spec.spawnAreas, spawnArea)
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
function PlaceableHeapSpawner.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableHeapSpawner.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHeapSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableHeapSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onUpdateTick" , PlaceableHeapSpawner )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHeapSpawner )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableHeapSpawner.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "PlaceableHeapSpawner" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".heapSpawner.spawnArea(?).area#startNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".heapSpawner.spawnArea(?).area#widthNode" , "" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".heapSpawner.spawnArea(?).area#heightNode" , "" )
    schema:register(XMLValueType.STRING, basePath .. ".heapSpawner.spawnArea(?)#fillType" , "Spawn fill type" )
    schema:register(XMLValueType.FLOAT, basePath .. ".heapSpawner.spawnArea(?)#litersPerHour" , "Spawn liters per ingame hour" )
    EffectManager.registerEffectXMLPaths(schema, basePath .. ".heapSpawner.spawnArea(?).effectNodes" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".heapSpawner.spawnArea(?).sounds" , "work" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".heapSpawner.spawnArea(?).sounds" , "work2" )
    SoundManager.registerSampleXMLPaths(schema, basePath .. ".heapSpawner.spawnArea(?).sounds" , "dropping" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".heapSpawner.spawnArea(?).animationNodes" )
    schema:setXMLSpecializationType()
end

```