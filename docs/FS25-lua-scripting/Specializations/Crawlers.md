## Crawlers

**Description**

> Specialization for crawlers and tracks with rotating and/or scrolling elements

**Functions**

- [getCrawlerWheelMovedDistance](#getcrawlerwheelmoveddistance)
- [getShallowWaterParameters](#getshallowwaterparameters)
- [initSpecialization](#initspecialization)
- [loadCrawlerFromConfigFile](#loadcrawlerfromconfigfile)
- [loadCrawlerFromXML](#loadcrawlerfromxml)
- [onCrawlerI3DLoaded](#oncrawleri3dloaded)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onUpdate](#onupdate)
- [onWheelConfigurationChanged](#onwheelconfigurationchanged)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateCrawler](#updatecrawler)
- [validateWashableNode](#validatewashablenode)

### getCrawlerWheelMovedDistance

**Description**

> Returns min. rotation difference or moved distance from the crawler wheels that have ground contact

**Definition**

> getCrawlerWheelMovedDistance(table crawler, string lastName, boolean useOnlyRotation)

**Arguments**

| table   | crawler         | crawler                                                                                   |
|---------|-----------------|-------------------------------------------------------------------------------------------|
| string  | lastName        | name of last variable                                                                     |
| boolean | useOnlyRotation | if true only the rotation difference is returned, if false the moved distance is returned |

**Return Values**

| boolean | value | value |
|---------|-------|-------|

**Code**

```lua
function Crawlers:getCrawlerWheelMovedDistance(crawler, lastName, useOnlyRotation)
    local minMovedDistance = math.huge
    local direction = 1

    for i = 1 , #crawler.wheels do
        local wheelData = crawler.wheels[i]
        if wheelData.wheel.physics.contact ~ = WheelContactType.NONE or #crawler.wheels = = 1 then
            local newX, _, _ = getRotation(wheelData.wheel.driveNode)
            if wheelData[lastName] = = nil then
                wheelData[lastName] = newX
            end

            local lastRotation = wheelData[lastName]

            if newX - lastRotation < - math.pi then
                lastRotation = lastRotation - 2 * math.pi
            elseif newX - lastRotation > math.pi then
                    lastRotation = lastRotation + 2 * math.pi
                end

                local distance = wheelData.wheel.physics.radius * (newX - lastRotation)
                if math.abs(wheelData.wheel.physics.steeringAngle) > math.pi * 0.5 then
                    distance = - distance
                end

                if useOnlyRotation then
                    distance = newX - lastRotation
                end

                if distance < 0 then
                    if distance > - minMovedDistance then
                        minMovedDistance = - distance
                        direction = - 1
                    end
                else
                        if distance < minMovedDistance then
                            minMovedDistance = distance
                            direction = 1
                        end
                    end

                    wheelData[lastName] = newX
                end
            end

            if minMovedDistance ~ = math.huge then
                return minMovedDistance * direction
            end

            return 0
        end

```

### getShallowWaterParameters

**Description**

**Definition**

> getShallowWaterParameters()

**Arguments**

| any | crawler |
|-----|---------|

**Code**

```lua
function Crawlers.getShallowWaterParameters(crawler)
    local velocity = crawler.vehicle.lastSignedSpeed * 1000

    local ox, oz = 0 , 0
    -- add random factor if wheel is slipping
        if crawler.wheel.physics ~ = nil then
            local slip = crawler.wheel.physics.netInfo.slip
            if slip > 0.1 then
                ox, oz = math.random() * 2 - 1 * slip, math.random() * 2 - 1 * slip
            end
        end

        -- if wheel is not slipping add random factor if it is moving
            if ox = = 0 and math.abs(velocity) > 0.27 then
                ox, oz = math.random() * 2 - 1 , math.random() * 2 - 1
            end

            local dx, _, dz = localDirectionToWorld(crawler.linkNode, 0 , 0 , 1 )
            local yRot = MathUtil.getYRotationFromDirection(dx, dz)
            dx, dz = dx * velocity, dz * velocity
            return dx + ox, dz + oz, yRot
        end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Crawlers.initSpecialization()
    g_storeManager:addVRamUsageFunction( Crawlers.getVRamUsageFromXML)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Crawlers" )

    local crawlerKey = "vehicle.wheels.wheelConfigurations.wheelConfiguration(?).crawlers.crawler(?)"

    schema:register(XMLValueType.NODE_INDEX, crawlerKey .. "#linkNode" , "Link node" )
    schema:register(XMLValueType.NODE_INDICES, crawlerKey .. "#linkWheelNodes" , "Back and front wheels which are used to link the crawler.Wheels are also used for speed reference." )
        schema:register(XMLValueType.BOOL, crawlerKey .. "#isLeft" , "Is left crawler" , false )
        schema:register(XMLValueType.FLOAT, crawlerKey .. "#trackWidth" , "Track width" , 1 )
        schema:register(XMLValueType.BOOL, crawlerKey .. "#hasShallowWaterObstacle" , "Crawler has a shallow water obstacle between the defined wheels" )
        schema:register(XMLValueType.STRING, crawlerKey .. "#filename" , "Crawler filename" )
        schema:register(XMLValueType.VECTOR_TRANS, crawlerKey .. "#offset" , "Crawler position offset" )
        schema:register(XMLValueType.INT, crawlerKey .. "#wheelIndex" , "Speed reference wheel index" )
        schema:register(XMLValueType.VECTOR_N, crawlerKey .. "#wheelIndices" , "Multiple speed reference wheels.The average speed of the wheels WITH ground contact is used" )
        schema:register(XMLValueType.NODE_INDICES, crawlerKey .. "#wheelNodes" , "Multiple speed reference wheels(defined by any node of the wheel).The average speed of the wheels WITH ground contact is used" )
        schema:register(XMLValueType.NODE_INDEX, crawlerKey .. "#speedReferenceNode" , "Speed reference node" )
        schema:register(XMLValueType.FLOAT, crawlerKey .. "#fieldDirtMultiplier" , "Field dirt multiplier" , 75 )
        schema:register(XMLValueType.FLOAT, crawlerKey .. "#streetDirtMultiplier" , "Street dirt multiplier" , - 150 )
        schema:register(XMLValueType.FLOAT, crawlerKey .. "#waterWetnessFactor" , "Factor for crawler wetness while driving in water" , 20 )
            schema:register(XMLValueType.FLOAT, crawlerKey .. "#minDirtPercentage" , "Min.dirt while getting clean on non field ground" , 0.35 )
                schema:register(XMLValueType.FLOAT, crawlerKey .. "#maxDirtOffset" , "Max.dirt amount offset to global dirt node" , 0.5 )
                schema:register(XMLValueType.FLOAT, crawlerKey .. "#dirtColorChangeSpeed" , "Defines speed to change the dirt color(sec)" , 20 )
                VehicleMaterial.registerXMLPaths(schema, crawlerKey .. ".rimMaterial" )

                schema:setXMLSpecializationType()

                local crawlerSchema = XMLSchema.new( "crawler" )
                crawlerSchema:shareDelayedRegistrationFuncs(schema) -- share the same delayed registration funcs since we have AnimatedVehicle elements in crawler schema
                crawlerSchema:register(XMLValueType.STRING, "crawler.file#name" , "Crawler i3d filename" )
                crawlerSchema:register(XMLValueType.NODE_INDEX, "crawler.file#leftNode" , "Crawler left node in i3d" )
                crawlerSchema:register(XMLValueType.NODE_INDEX, "crawler.file#rightNode" , "Crawler right node in i3d" )

                crawlerSchema:register(XMLValueType.NODE_INDEX, "crawler.scrollerNodes.scrollerNode(?)#node" , "Scroller node" )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.scrollerNodes.scrollerNode(?)#scrollSpeed" , "Scroll speed" , 1 )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.scrollerNodes.scrollerNode(?)#scrollLength" , "Scroll length" , 1 )
                crawlerSchema:register(XMLValueType.STRING, "crawler.scrollerNodes.scrollerNode(?)#shaderParameterName" , "Shader parameter name" , "offsetUV" )
                crawlerSchema:register(XMLValueType.STRING, "crawler.scrollerNodes.scrollerNode(?)#shaderParameterNamePrev" , "Shader parameter name(Prev)" , "#shaderParameterName prefixed with 'prev'" )
                crawlerSchema:register(XMLValueType.INT, "crawler.scrollerNodes.scrollerNode(?)#shaderParameterComponent" , "Shader paramater component" , 1 )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.scrollerNodes.scrollerNode(?)#maxSpeed" , "Max.speed in m/s" , "unlimited" )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.scrollerNodes.scrollerNode(?)#isTrackPart" , "Is part of track(Track width is set as scale X)" )

                crawlerSchema:register(XMLValueType.NODE_INDEX, "crawler.rotatingParts.rotatingPart(?)#node" , "Rotating node" )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.rotatingParts.rotatingPart(?)#radius" , "Radius" )
                crawlerSchema:register(XMLValueType.FLOAT, "crawler.rotatingParts.rotatingPart(?)#speedScale" , "Speed scale" )

                crawlerSchema:register(XMLValueType.NODE_INDEX, "crawler.dirtNodes.dirtNode(?)#node" , "Nodes that act the same way as wheels and get dirty faster when on field.If not defined everything gets dirty faster." )

                crawlerSchema:register(XMLValueType.BOOL, "crawler.animations.animation(?)#isLeft" , "Load for left crawler" , false )
                    AnimatedVehicle.registerAnimationXMLPaths(crawlerSchema, "crawler.animations.animation(?)" )

                    ObjectChangeUtil.registerObjectChangeSingleXMLPaths(crawlerSchema, "crawler" )

                    Crawlers.xmlSchema = crawlerSchema
                end

```

### loadCrawlerFromConfigFile

**Description**

**Definition**

> loadCrawlerFromConfigFile()

**Arguments**

| any | crawler     |
|-----|-------------|
| any | xmlFilename |
| any | linkNode    |

**Code**

```lua
function Crawlers:loadCrawlerFromConfigFile(crawler, xmlFilename, linkNode)
    xmlFilename = Utils.getFilename(xmlFilename, self.baseDirectory)
    local xmlFile = XMLFile.load( "crawlerXml" , xmlFilename, Crawlers.xmlSchema)
    if xmlFile ~ = nil then
        local filename = xmlFile:getValue( "crawler.file#name" )
        if filename ~ = nil then
            local spec = self.spec_crawlers
            spec.xmlLoadingHandles[xmlFile] = true

            crawler.filename = Utils.getFilename(filename, self.baseDirectory)

            local arguments = {
            xmlFile = xmlFile,
            crawler = crawler
            }
            local sharedLoadRequestId = self:loadSubSharedI3DFile(crawler.filename, false , false , self.onCrawlerI3DLoaded, self , arguments)
            table.insert(spec.sharedLoadRequestIds, sharedLoadRequestId)
        else
                Logging.xmlWarning(xmlFile, "Failed to open crawler i3d file '%s' in '%s'" , filename, xmlFilename)
                xmlFile:delete()
            end
        else
                Logging.xmlWarning( self.xmlFile, "Failed to open crawler config file '%s'" , xmlFilename)
            end
        end

```

### loadCrawlerFromXML

**Description**

> Load crawlers from xml

**Definition**

> loadCrawlerFromXML(XMLFile xmlFile, )

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| any     | key     |                  |

**Code**

```lua
function Crawlers:loadCrawlerFromXML(xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#crawlerIndex" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#length" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#shaderParameterComponent" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#shaderParameterName" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#scrollLength" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#scrollSpeed" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , "Moved to external crawler config file" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".rotatingPart" , "Moved to external crawler config file" ) -- FS17 to FS19

    local crawler = { }
    crawler.vehicle = self
    crawler.wheels = { }

    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#linkIndex" , key .. "#linkNode" ) -- FS17 to FS19
    local linkNode = xmlFile:getValue(key .. "#linkNode" , nil , self.components, self.i3dMappings)

    local linkWheelNodes = xmlFile:getValue(key .. "#linkWheelNodes" , nil , self.components, self.i3dMappings, true )
    if linkWheelNodes ~ = nil then
        local numLinkWheelNodes = #linkWheelNodes
        if numLinkWheelNodes = = 2 then
            local backWheel = self:getWheelByWheelNode(linkWheelNodes[ 1 ])
            local frontWheel = self:getWheelByWheelNode(linkWheelNodes[ 2 ])
            if backWheel ~ = nil and frontWheel ~ = nil then
                if linkNode = = nil then
                    linkNode = createTransformGroup( "crawlerLinkNode" )
                end

                link(backWheel.repr, linkNode)
                setWorldTranslation(linkNode, getWorldTranslation(backWheel.driveNode))
                setWorldRotation(linkNode, getWorldRotation(backWheel.driveNode))

                crawler.positionReferenceNode = backWheel.driveNode
                crawler.referenceNode = frontWheel.driveNode
                crawler.referenceFrame = backWheel.repr

                -- if possible we use the first visual tire node as reference, as we might have a rimOffset
                    -- delayed to first frame when all external wheels have been loaded
                    crawler.positionReferenceWheel = backWheel
                    crawler.referenceWheel = frontWheel

                    table.insert(crawler.wheels, { wheel = backWheel } )
                    table.insert(crawler.wheels, { wheel = frontWheel } )
                else
                        Logging.xmlWarning( self.xmlFile, "Unknown link wheel nodes found in '%s'" , key)
                    end
                elseif numLinkWheelNodes ~ = 0 then
                        Logging.xmlWarning( self.xmlFile, "The 'linkWheelNodes' attribute in crawlers requires exactly two nodes! '%s'" , key)
                    end
                end

                if linkNode = = nil then
                    Logging.xmlWarning( self.xmlFile, "Missing link node for crawler '%s'" , key)
                        return
                    end

                    crawler.linkNode = linkNode
                    crawler.isLeft = xmlFile:getValue(key .. "#isLeft" , false )
                    crawler.trackWidth = xmlFile:getValue(key .. "#trackWidth" , 1 )

                    crawler.translationOffset = xmlFile:getValue(key .. "#offset" , "0 0 0" , true )

                    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#speedRefWheel" , key .. "#wheelIndex" ) -- FS17 to FS19
                    local wheelIndex = xmlFile:getValue(key .. "#wheelIndex" )
                    local wheelIndices = xmlFile:getValue(key .. "#wheelIndices" , nil , true )
                    local wheelNodes = xmlFile:getValue(key .. "#wheelNodes" , nil , self.components, self.i3dMappings, true )
                    if wheelIndex ~ = nil or wheelIndices ~ = nil or #wheelNodes > 0 then
                        if wheelIndex ~ = nil then
                            wheelIndices = wheelIndices or { }
                            table.insert(wheelIndices, wheelIndex)
                        end

                        if wheelIndices ~ = nil then
                            for _, wheelIndex in ipairs(wheelIndices) do
                                local wheel = self:getWheelFromWheelIndex(wheelIndex)
                                if wheel ~ = nil then
                                    table.insert(crawler.wheels, { wheel = wheel } )
                                end
                            end
                        end

                        if wheelNodes ~ = nil then
                            for _, wheelNode in ipairs(wheelNodes) do
                                local wheel = self:getWheelByWheelNode(wheelNode)
                                if wheel ~ = nil then
                                    table.insert(crawler.wheels, { wheel = wheel } )
                                end
                            end
                        end
                    end

                    local numWheels = #crawler.wheels
                    if numWheels > 0 then
                        local crawlerLength = 0
                        for _, wheelData in ipairs(crawler.wheels) do
                            for _, otherWheelData in ipairs(crawler.wheels) do
                                if wheelData ~ = otherWheelData then
                                    local distance = calcDistanceFrom(wheelData.wheel.driveNode, otherWheelData.wheel.driveNode)
                                    crawlerLength = math.max(crawlerLength, distance)
                                end
                            end
                        end

                        for wheelIndex, wheelData in ipairs(crawler.wheels) do
                            wheelData.wheel.syncContactState = true
                            wheelData.wheel.transRatio = 1
                            if wheelData.wheel.physics.showSteeringAngle = = nil then
                                wheelData.wheel.physics.showSteeringAngle = false
                            end

                            local hasWaterEffects = false
                            if numWheels > 1 then
                                if wheelIndex = = 1 then
                                    wheelData.wheel.effects.waterParticleDirection = - 1 -- back wheel
                                    hasWaterEffects = true
                                elseif wheelIndex = = 2 then
                                        wheelData.wheel.effects.waterParticleDirection = 1 -- front wheel
                                        hasWaterEffects = true
                                    end

                                    wheelData.wheel.effects.waterEffectReferenceRadius = math.min(crawlerLength * 0.5 , 1 )
                                else
                                        hasWaterEffects = true
                                    end

                                    if hasWaterEffects then
                                        if wheelData.wheel.effects.hasWaterParticles = = nil then
                                            wheelData.wheel.effects:addWaterEffectsToPhysicsData()
                                        end
                                    else
                                            wheelData.wheel.effects:removeWaterEffects()
                                        end

                                        if not wheelData.wheel.physics.isSynchronized then
                                            Logging.xmlWarning( self.xmlFile, "Wheel '%s' for crawler '%s' in not synchronized! It won't rotate on the client side." , getName(wheelData.wheel.repr), key)
                                            end
                                        end

                                        crawler.wheel = crawler.wheels[ 1 ].wheel

                                        crawler.hasShallowWaterObstacle = xmlFile:getValue(key .. "#hasShallowWaterObstacle" , true )
                                        if crawler.hasShallowWaterObstacle and self.propertyState ~ = VehiclePropertyState.SHOP_CONFIG then -- avoid interference with water planes while in shop under the map
                                            local minX, minY, minZ = math.huge, math.huge, math.huge
                                            local maxX, maxY, maxZ = - math.huge, - math.huge, - math.huge

                                            for _, wheelData in ipairs(crawler.wheels) do
                                                local wheel = wheelData.wheel
                                                local x1, y1, z1 = localToLocal(wheel.driveNode, linkNode, (wheel.physics.wheelShapeWidth * 0.5 ) + wheel.physics.wheelShapeWidthOffset, wheel.physics.radius, wheel.physics.radius)
                                                local x2, y2, z2 = localToLocal(wheel.driveNode, linkNode, - ((wheel.physics.wheelShapeWidth * 0.5 ) - wheel.physics.wheelShapeWidthOffset), - wheel.physics.radius, - wheel.physics.radius)

                                                minX, minY, minZ = math.min(minX, x1, x2), math.min(minY, y1, y2), math.min(minZ, z1, z2)
                                                maxX, maxY, maxZ = math.max(maxX, x1, x2), math.max(maxY, y1, y2), math.max(maxZ, z1, z2)
                                            end

                                            local sizeX, sizeY, sizeZ = maxX - minX, maxY - minY, maxZ - minZ
                                            local cx, cy, cz = (minX + maxX) * 0.5 , (minY + maxY) * 0.5 , (minZ + maxZ) * 0.5

                                            crawler.shallowWaterObstacle = g_currentMission.shallowWaterSimulation:addObstacle(linkNode, sizeX, sizeY, sizeZ, Crawlers.getShallowWaterParameters, crawler, { cx, cy, cz } )
                                        end
                                    end

                                    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, self.configFileName, key .. "#speedRefNode" , key .. "#speedReferenceNode" ) -- FS17 to FS19
                                    crawler.speedReferenceNode = xmlFile:getValue(key .. "#speedReferenceNode" , nil , self.components, self.i3dMappings)
                                    crawler.movedDistance = 0

                                    crawler.fieldDirtMultiplier = xmlFile:getValue(key .. "#fieldDirtMultiplier" , 75 )
                                    crawler.streetDirtMultiplier = xmlFile:getValue(key .. "#streetDirtMultiplier" , - 150 )
                                    crawler.waterWetnessFactor = xmlFile:getValue(key .. "#waterWetnessFactor" , 20 )
                                    crawler.minDirtPercentage = xmlFile:getValue(key .. "#minDirtPercentage" , 0.35 )
                                    crawler.maxDirtOffset = xmlFile:getValue(key .. "#maxDirtOffset" , 0.5 )
                                    crawler.dirtColorChangeSpeed = 1 / (xmlFile:getValue(key .. "#dirtColorChangeSpeed" , 20 ) * 1000 )

                                    local rimMaterial = VehicleMaterial.new( self.baseDirectory)
                                    if rimMaterial:loadFromXML(xmlFile, key .. ".rimMaterial" , self.customEnvironment) then
                                        crawler.rimMaterial = rimMaterial
                                    end

                                    local filename = xmlFile:getValue(key .. "#filename" )
                                    self:loadCrawlerFromConfigFile(crawler, filename, linkNode)
                                end

```

### onCrawlerI3DLoaded

**Description**

**Definition**

> onCrawlerI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function Crawlers:onCrawlerI3DLoaded(i3dNode, failedReason, args)
    local xmlFile = args.xmlFile
    local crawler = args.crawler
    local spec = self.spec_crawlers

    if i3dNode ~ = 0 then
        local leftRightKey = (crawler.isLeft and "leftNode" ) or "rightNode"
        crawler.loadedCrawler = xmlFile:getValue( "crawler.file#" .. leftRightKey, nil , i3dNode)
        if crawler.loadedCrawler ~ = nil then
            link(crawler.linkNode, crawler.loadedCrawler)

            if crawler.translationOffset ~ = nil then
                setTranslation(crawler.loadedCrawler, unpack(crawler.translationOffset))
            end

            setRotation(crawler.loadedCrawler, 0 , 0 , 0 )

            crawler.scrollerNodes = { }
            local j = 0
            while true do
                local key = string.format( "crawler.scrollerNodes.scrollerNode(%d)" , j)
                if not xmlFile:hasProperty(key) then
                    break
                end

                local entry = { }
                entry.node = xmlFile:getValue(key .. "#node" , nil , crawler.loadedCrawler)
                if entry.node ~ = nil then
                    entry.scrollSpeed = xmlFile:getValue(key .. "#scrollSpeed" , 1 )
                    entry.scrollLength = xmlFile:getValue(key .. "#scrollLength" , 1 )
                    entry.shaderParameterName = xmlFile:getValue(key .. "#shaderParameterName" , "offsetUV" )
                    entry.shaderParameterNamePrev = xmlFile:getValue(key .. "#shaderParameterNamePrev" )
                    if entry.shaderParameterNamePrev ~ = nil then
                        if not getHasShaderParameter(entry.node, entry.shaderParameterNamePrev) then
                            Logging.xmlWarning(xmlFile, "Node '%s' has no shader parameter '%s' (prev) for crawler node '%s'!" , getName(entry.node), entry.shaderParameterNamePrev, key)
                                return
                            end
                        else
                                local prevName = "prev" .. string.upper( string.sub(entry.shaderParameterName, 1 , 1 )) .. string.sub(entry.shaderParameterName, 2 ) -- uppercase first letter of parameter name
                                if getHasShaderParameter(entry.node, prevName) then
                                    entry.shaderParameterNamePrev = prevName
                                end
                            end

                            entry.nodes = { }
                            I3DUtil.getNodesByShaderParam(crawler.loadedCrawler, entry.shaderParameterName, entry.nodes)

                            entry.shaderParameterComponent = xmlFile:getValue(key .. "#shaderParameterComponent" , 1 )
                            entry.maxSpeed = xmlFile:getValue(key .. "#maxSpeed" , math.huge) / 1000
                            entry.scrollPosition = 0

                            if crawler.trackWidth ~ = 1 then
                                if xmlFile:getValue(key .. "#isTrackPart" , true ) then
                                    setScale(entry.node, crawler.trackWidth, 1 , 1 )
                                end
                            end

                            table.insert(crawler.scrollerNodes, entry)
                        end
                        j = j + 1
                    end

                    crawler.rotatingParts = { }
                    j = 0
                    while true do
                        local key = string.format( "crawler.rotatingParts.rotatingPart(%d)" , j)
                        if not xmlFile:hasProperty(key) then
                            break
                        end

                        local entry = { }
                        entry.node = xmlFile:getValue(key .. "#node" , nil , crawler.loadedCrawler)
                        if entry.node ~ = nil then
                            entry.radius = xmlFile:getValue(key .. "#radius" )
                            entry.speedScale = xmlFile:getValue(key .. "#speedScale" )
                            if entry.speedScale = = nil and entry.radius ~ = nil then
                                entry.speedScale = 1.0 / entry.radius
                            end

                            table.insert(crawler.rotatingParts, entry)
                        end

                        j = j + 1
                    end

                    crawler.hasDirtNodes = false
                    crawler.dirtNodes = { }
                    j = 0
                    while true do
                        local key = string.format( "crawler.dirtNodes.dirtNode(%d)" , j)
                        if not xmlFile:hasProperty(key) then
                            break
                        end

                        local node = xmlFile:getValue(key .. "#node" , nil , crawler.loadedCrawler)
                        if node ~ = nil then
                            crawler.dirtNodes[node] = node
                            crawler.hasDirtNodes = true
                        end

                        j = j + 1
                    end

                    crawler.objectChanges = { }
                    ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, "crawler" , crawler.objectChanges, crawler.loadedCrawler, self )
                    ObjectChangeUtil.setObjectChanges(crawler.objectChanges, true )

                    local i = 0
                    while true do
                        local key = string.format( "crawler.animations.animation(%d)" , i)
                        if not xmlFile:hasProperty(key) then
                            break
                        end

                        if crawler.isLeft = = xmlFile:getValue(key .. "#isLeft" , false ) then
                            local animation = { }
                            if self:loadAnimation(xmlFile, key, animation, crawler.loadedCrawler) then
                                self.spec_animatedVehicle.animations[animation.name] = animation
                            end
                        end

                        i = i + 1
                    end

                    table.insert( self.spec_crawlers.crawlers, crawler)
                end

                delete(i3dNode)
            else
                    if not( self.isDeleted or self.isDeleting) then
                        Logging.xmlWarning(xmlFile, "Failed to find crawler in i3d file '%s'" , crawler.filename)
                    end
                end

                xmlFile:delete()
                spec.xmlLoadingHandles[xmlFile] = nil
            end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Crawlers:onDelete()
    local spec = self.spec_crawlers
    if spec.xmlLoadingHandles ~ = nil then
        for xmlFile, _ in pairs(spec.xmlLoadingHandles) do
            xmlFile:delete()
        end
        table.clear(spec.xmlLoadingHandles)
    end

    if spec.crawlers ~ = nil then
        for _, crawler in pairs(spec.crawlers) do
            if crawler.shallowWaterObstacle ~ = nil then
                g_currentMission.shallowWaterSimulation:removeObstacle(crawler.shallowWaterObstacle)
                crawler.shallowWaterObstacle = nil
            end
        end
        table.clear(spec.crawlers)
    end

    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
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
function Crawlers:onLoad(savegame)
    local spec = self.spec_crawlers

    local wheelConfigId = Utils.getNoNil( self.configurations[ "wheel" ], 1 )
    local wheelKey = string.format( "vehicle.wheels.wheelConfigurations.wheelConfiguration(%d)" , wheelConfigId - 1 )

    spec.crawlers = { }
    spec.sharedLoadRequestIds = { }
    spec.xmlLoadingHandles = { }
    self.xmlFile:iterate(wheelKey .. ".crawlers.crawler" , function (_, key)
        self:loadCrawlerFromXML( self.xmlFile, key)
    end )
end

```

### onLoadFinished

**Description**

> Called on loading

**Definition**

> onLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Crawlers:onLoadFinished(savegame)
    local spec = self.spec_crawlers
    if #spec.crawlers = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , Crawlers )
    else
            for i, crawler in ipairs(spec.crawlers) do
                if crawler.rimMaterial ~ = nil then
                    crawler.rimMaterial:apply(crawler.loadedCrawler, "rim_inner_mat" )
                    crawler.rimMaterial:apply(crawler.loadedCrawler, "rim_outer_mat" )
                end

                self:updateCrawler(crawler, 999 )
            end
        end
    end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActive, boolean isActiveForInput, boolean isSelected)

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActive         | true if vehicle is active           |
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |

**Code**

```lua
function Crawlers:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_crawlers
    local updateCrawlers = self.currentUpdateDistance < Crawlers.MAX_UPDATE_DISTANCE
    for _, crawler in pairs(spec.crawlers) do
        if updateCrawlers then
            self:updateCrawler(crawler, dt)
        elseif crawler.lastPosition ~ = nil then
                crawler.lastPosition = nil
            end
        end
    end

```

### onWheelConfigurationChanged

**Description**

**Definition**

> onWheelConfigurationChanged()

**Code**

```lua
function Crawlers:onWheelConfigurationChanged()
    local spec = self.spec_crawlers
    for _, crawler in pairs(spec.crawlers) do
        local washableNode = self:getWashableNodeByCustomIndex(crawler)
        if washableNode ~ = nil then
            self:setNodeDirtAmount(washableNode, 0 , true )
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
function Crawlers.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Wheels , specializations)
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
function Crawlers.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Crawlers )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Crawlers )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Crawlers )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Crawlers )
    SpecializationUtil.registerEventListener(vehicleType, "onWheelConfigurationChanged" , Crawlers )
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
function Crawlers.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "updateCrawler" , Crawlers.updateCrawler)
    SpecializationUtil.registerFunction(vehicleType, "loadCrawlerFromXML" , Crawlers.loadCrawlerFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadCrawlerFromConfigFile" , Crawlers.loadCrawlerFromConfigFile)
    SpecializationUtil.registerFunction(vehicleType, "onCrawlerI3DLoaded" , Crawlers.onCrawlerI3DLoaded)
    SpecializationUtil.registerFunction(vehicleType, "getCrawlerWheelMovedDistance" , Crawlers.getCrawlerWheelMovedDistance)
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
function Crawlers.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "validateWashableNode" , Crawlers.validateWashableNode)
end

```

### updateCrawler

**Description**

**Definition**

> updateCrawler()

**Arguments**

| any | crawler |
|-----|---------|
| any | dt      |

**Code**

```lua
function Crawlers:updateCrawler(crawler, dt)
    crawler.movedDistance = 0

    --#profile RemoteProfiler.zoneBeginN("Crawlers-updateCrawler-updateLastPos")
    if crawler.speedReferenceNode ~ = nil then
        local newX, newY, newZ = getWorldTranslation(crawler.speedReferenceNode)
        if crawler.lastPosition = = nil then
            crawler.lastPosition = { newX, newY, newZ }
        end
        local dx, dy, dz = worldDirectionToLocal(crawler.speedReferenceNode, newX - crawler.lastPosition[ 1 ], newY - crawler.lastPosition[ 2 ], newZ - crawler.lastPosition[ 3 ])
        local movingDirection = 0
        if dz > 0.0001 then
            movingDirection = 1
        elseif dz < - 0.0001 then
                movingDirection = - 1
            end
            crawler.movedDistance = MathUtil.vector3Length(dx, dy, dz) * movingDirection
            crawler.lastPosition[ 1 ] = newX
            crawler.lastPosition[ 2 ] = newY
            crawler.lastPosition[ 3 ] = newZ
        else
                crawler.movedDistance = self:getCrawlerWheelMovedDistance(crawler, "lastRotationScroll" , false )
            end
            --#profile RemoteProfiler.zoneEnd()

            --#profile RemoteProfiler.zoneBeginN("Crawlers-updateCrawler-updateShader")
            for _, scrollerNode in pairs(crawler.scrollerNodes) do
                local movedDistance = crawler.movedDistance * scrollerNode.scrollSpeed
                local moveDirection = math.sign(movedDistance)
                movedDistance = math.min( math.abs(movedDistance), scrollerNode.maxSpeed) * moveDirection
                scrollerNode.scrollPosition = (scrollerNode.scrollPosition + movedDistance) % scrollerNode.scrollLength

                for _, node in pairs(scrollerNode.nodes) do
                    local x, y, z, w = getShaderParameter(node, scrollerNode.shaderParameterName)
                    if scrollerNode.shaderParameterComponent = = 1 then
                        x = scrollerNode.scrollPosition
                    else
                            y = scrollerNode.scrollPosition
                        end

                        if scrollerNode.shaderParameterNamePrev ~ = nil then
                            g_animationManager:setPrevShaderParameter(node, scrollerNode.shaderParameterName, x, y, z, w, false , scrollerNode.shaderParameterNamePrev)
                        else
                                setShaderParameter(node, scrollerNode.shaderParameterName, x, y, z, w, false )
                            end
                        end
                    end
                    --#profile RemoteProfiler.zoneEnd()

                    --#profile RemoteProfiler.zoneBeginN("Crawlers-updateCrawler-rotateNodes")
                    local rotationDifference = self:getCrawlerWheelMovedDistance(crawler, "lastRotationRot" , true )
                    for _, rotatingPart in pairs(crawler.rotatingParts) do
                        if crawler.wheel ~ = nil and rotatingPart.speedScale = = nil then
                            rotate(rotatingPart.node, rotationDifference, 0 , 0 )
                        elseif rotatingPart.speedScale ~ = nil then
                                rotate(rotatingPart.node, rotatingPart.speedScale * crawler.movedDistance, 0 , 0 )
                            end
                        end
                        --#profile RemoteProfiler.zoneEnd()

                        --#profile RemoteProfiler.zoneBeginN("Crawlers-updateCrawler-updateAlignment")
                        if crawler.referenceNode ~ = nil then
                            -- resolve the tires nodes on the first update, when the wheel mesh data has been loaded
                            if crawler.positionReferenceWheel ~ = nil then
                                crawler.positionReferenceNode = crawler.positionReferenceWheel:getFirstTireNode() or crawler.positionReferenceNode
                                crawler.positionReferenceWheel = nil
                            end
                            if crawler.referenceWheel ~ = nil then
                                crawler.referenceNode = crawler.referenceWheel:getFirstTireNode() or crawler.referenceNode
                                crawler.referenceWheel = nil
                            end

                            if self.currentUpdateDistance < Crawlers.MAX_UPDATE_DISTANCE_ALIGNMENT then
                                local x, y, z = getWorldTranslation(crawler.positionReferenceNode)
                                local refX, refY, refZ = getWorldTranslation(crawler.referenceNode)

                                local dx, dy, dz = MathUtil.vector3Normalize(refX - x, refY - y, refZ - z)
                                local upX, upY, upZ = localDirectionToWorld(crawler.referenceFrame, 0 , 1 , 0 )

                                setWorldTranslation(crawler.linkNode, x, y, z)
                                setWorldDirection(crawler.linkNode, dx, dy, dz, upX, upY, upZ)
                            end
                        end
                        --#profile RemoteProfiler.zoneEnd()
                    end

```

### validateWashableNode

**Description**

**Definition**

> validateWashableNode()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function Crawlers:validateWashableNode(superFunc, node)
    local spec = self.spec_crawlers
    for _, crawler in pairs(spec.crawlers) do
        if crawler.wheel ~ = nil then
            local crawlerNodes = crawler.dirtNodes
            if not crawler.hasDirtNodes then
                I3DUtil.getNodesByShaderParam(crawler.loadedCrawler, "scratches_dirt_snow_wetness" , crawlerNodes)
            end

            if crawler.crawlerMudMeshes = = nil then
                crawler.crawlerMudMeshes = { }
                I3DUtil.getNodesByShaderParam(crawler.loadedCrawler, "mudAmount" , crawler.crawlerMudMeshes)
            end

            if crawlerNodes[node] ~ = nil then
                local nodeData = { }
                nodeData.wheel = crawler.wheel
                nodeData.fieldDirtMultiplier = crawler.fieldDirtMultiplier
                nodeData.streetDirtMultiplier = crawler.streetDirtMultiplier
                nodeData.minDirtPercentage = crawler.minDirtPercentage
                nodeData.maxDirtOffset = crawler.maxDirtOffset
                nodeData.dirtColorChangeSpeed = crawler.dirtColorChangeSpeed
                nodeData.waterWetnessFactor = crawler.waterWetnessFactor
                nodeData.isSnowNode = true

                nodeData.loadFromSavegameFunc = function (xmlFile, key)
                    nodeData.wheel.physics.snowScale = xmlFile:getValue(key .. "#snowScale" , 0 )

                    local defaultColor, snowColor = g_currentMission.environment:getDirtColors()
                    local r, g, b = MathUtil.vector3ArrayLerp(defaultColor, snowColor, nodeData.wheel.physics.snowScale)
                    local washableNode = self:getWashableNodeByCustomIndex(crawler)
                    self:setNodeDirtColor(washableNode, r, g, b, true )
                end
                nodeData.saveToSavegameFunc = function (xmlFile, key)
                    xmlFile:setValue(key .. "#snowScale" , nodeData.wheel.physics.snowScale)
                end

                return false , self.updateWheelDirtAmount, crawler, nodeData
            end

            if crawler.crawlerMudMeshes[node] ~ = nil then
                local nodeData = { }
                nodeData.wheel = crawler.wheel
                nodeData.fieldDirtMultiplier = crawler.fieldDirtMultiplier
                nodeData.streetDirtMultiplier = crawler.streetDirtMultiplier
                nodeData.minDirtPercentage = crawler.minDirtPercentage
                nodeData.maxDirtOffset = crawler.maxDirtOffset
                nodeData.dirtColorChangeSpeed = crawler.dirtColorChangeSpeed
                nodeData.waterWetnessFactor = crawler.waterWetnessFactor
                nodeData.isSnowNode = true
                nodeData.cleaningMultiplier = 4

                return false , self.updateWheelMudAmount, crawler.crawlerMudMeshes, nodeData
            end
        end
    end

    return superFunc( self , node)
end

```