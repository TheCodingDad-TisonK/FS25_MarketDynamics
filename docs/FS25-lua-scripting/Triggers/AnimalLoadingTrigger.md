## AnimalLoadingTrigger

**Description**

> class to handle the animal load triggers

**Functions**

- [delete](#delete)
- [getAnimals](#getanimals)
- [load](#load)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onCreate](#oncreate)
- [openAnimalMenu](#openanimalmenu)
- [registerXMLPaths](#registerxmlpaths)
- [setLoadingTrailer](#setloadingtrailer)
- [triggerCallback](#triggercallback)
- [updateActivatableObject](#updateactivatableobject)

### delete

**Description**

> Deletes instance

**Definition**

> delete()

**Code**

```lua
function AnimalLoadingTrigger:delete()
    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)

    if self.triggerNode ~ = nil then
        removeTrigger( self.triggerNode)
        self.triggerNode = nil
    end

    self.husbandry = nil
end

```

### getAnimals

**Description**

**Definition**

> getAnimals()

**Code**

```lua
function AnimalLoadingTrigger:getAnimals()
    return self.animalTypes
end

```

### load

**Description**

> Loads information from scenegraph node.

**Definition**

> load(integer id, )

**Arguments**

| integer | id        | nodeid that the trigger is created from |
|---------|-----------|-----------------------------------------|
| any     | husbandry |                                         |

**Code**

```lua
function AnimalLoadingTrigger:load(node, husbandry)
    self.husbandry = husbandry
    self.isDealer = Utils.getNoNil(getUserAttribute(node, "isDealer" ), false )

    if self.isDealer then
        local animalTypesString = getUserAttribute(node, "animalTypes" )
        if animalTypesString ~ = nil then
            local animalTypes = animalTypesString:split( " " )
            for _, animalTypeStr in pairs(animalTypes) do
                local animalTypeIndex = g_currentMission.animalSystem:getTypeIndexByName(animalTypeStr)
                if animalTypeIndex ~ = nil then
                    if self.animalTypes = = nil then
                        self.animalTypes = { }
                    end

                    table.insert( self.animalTypes, animalTypeIndex)
                else
                        Logging.warning( "Invalid animal type '%s' for animalLoadingTrigger '%s'!" , animalTypeStr, getName(node))
                        end
                    end
                end
            end

            self.triggerNode = node
            addTrigger( self.triggerNode, "triggerCallback" , self )

            self.title = g_i18n:getText( Utils.getNoNil(getUserAttribute(node, "title" ), "ui_farm" ), self.customEnvironment)
            self.isEnabled = true

            return true
        end

```

### loadFromXML

**Description**

> Loads information from a xml file

**Definition**

> loadFromXML(integer id, integer xmlFile, string key, )

**Arguments**

| integer | id          | nodeid that the trigger is created from |
|---------|-------------|-----------------------------------------|
| integer | xmlFile     | id of xml file                          |
| string  | key         | xml path to load from                   |
| any     | i3dMappings |                                         |

**Code**

```lua
function AnimalLoadingTrigger:loadFromXML(xmlFile, key, components, i3dMappings)
    self.triggerNode = xmlFile:getValue(key .. "#node" , nil , components, i3dMappings)
    if self.triggerNode = = nil then
        Logging.xmlWarning(xmlFile, "Missing trigger node for animalLoadingTrigger!" )
            return false
        end

        self.husbandry = nil
        self.isDealer = xmlFile:getValue(key .. "#isDealer" , false )

        if self.isDealer then
            local animalTypesString = xmlFile:getValue(key .. "#animalTypes" )
            if animalTypesString ~ = nil then
                local animalTypes = animalTypesString:split( " " )
                for _, animalTypeStr in pairs(animalTypes) do
                    local animalTypeIndex = g_currentMission.animalSystem:getTypeIndexByName(animalTypeStr)
                    if animalTypeIndex ~ = nil then
                        if self.animalTypes = = nil then
                            self.animalTypes = { }
                        end

                        table.insert( self.animalTypes, animalTypeIndex)
                    else
                            Logging.xmlWarning(xmlFile, "Invalid animal type '%s' for animalLoadingTrigger!" , animalTypeStr)
                            end
                        end
                    end
                end

                addTrigger( self.triggerNode, "triggerCallback" , self )

                self.title = g_i18n:convertText(xmlFile:getValue(key .. "#title" , "ui_farm" ), self.customEnvironment)
                self.isEnabled = true

                return true
            end

```

### new

**Description**

> Creates an instance of the class

**Definition**

> new(boolean isServer, boolean isClient)

**Arguments**

| boolean | isServer |
|---------|----------|
| boolean | isClient |

**Return Values**

| boolean | self | instance |
|---------|------|----------|

**Code**

```lua
function AnimalLoadingTrigger.new(isServer, isClient)
    local self = Object.new(isServer, isClient, AnimalLoadingTrigger _mt)

    self.customEnvironment = g_currentMission.loadingMapModName
    self.isDealer = false
    self.triggerNode = nil
    self.title = g_i18n:getText( "ui_farm" )

    self.animals = nil

    self.activatable = AnimalLoadingTriggerActivatable.new( self )
    self.isPlayerInRange = false

    self.isEnabled = false

    self.loadingVehicle = nil
    self.activatedTarget = nil

    return self
end

```

### onCreate

**Description**

> Callback of scenegraph object

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | nodeid that the trigger is created from |
|---------|----|-----------------------------------------|

**Code**

```lua
function AnimalLoadingTrigger:onCreate(id)
    local trigger = AnimalLoadingTrigger.new(g_server ~ = nil , g_client ~ = nil )
    if trigger ~ = nil then
        if trigger:load(id) then
            g_currentMission:addNonUpdateable(trigger)
        else
                trigger:delete()
            end
        end
    end

```

### openAnimalMenu

**Description**

**Definition**

> openAnimalMenu()

**Code**

```lua
function AnimalLoadingTrigger:openAnimalMenu()
    if self.husbandry = = nil then
        self:updateActivatableObject()
    end

    AnimalScreen.show( self.husbandry, self.loadingVehicle, self.isDealer)
    self.activatedTarget = self.loadingVehicle
end

```

### registerXMLPaths

**Description**

> Register xml paths

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function AnimalLoadingTrigger.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Trigger node of animal loading trigger" )
    schema:register(XMLValueType.BOOL, basePath .. "#isDealer" , "Is dealer or not" , false )
    schema:register(XMLValueType.STRING, basePath .. "#animalTypes" , "List of supported animal types(only for dealer)" )
        schema:register(XMLValueType.STRING, basePath .. "#title" , "Title to show in the UI" , "ui_farm" )
    end

```

### setLoadingTrailer

**Description**

> Sets the loading trailer

**Definition**

> setLoadingTrailer(table loadingVehicle)

**Arguments**

| table | loadingVehicle |
|-------|----------------|

**Code**

```lua
function AnimalLoadingTrigger:setLoadingTrailer(loadingVehicle)
    if self.loadingVehicle ~ = nil and self.loadingVehicle.setLoadingTrigger ~ = nil then
        self.loadingVehicle:setLoadingTrigger( nil )
    end

    self.loadingVehicle = loadingVehicle

    if self.loadingVehicle ~ = nil and self.loadingVehicle.setLoadingTrigger ~ = nil then
        self.loadingVehicle:setLoadingTrigger( self )
    end

    self:updateActivatableObject()
end

```

### triggerCallback

**Description**

> Callback when trigger changes state

**Definition**

> triggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId |
|---------|-----------|
| integer | otherId   |
| boolean | onEnter   |
| boolean | onLeave   |
| boolean | onStay    |

**Code**

```lua
function AnimalLoadingTrigger:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and(onEnter or onLeave) then
        local vehicle = g_currentMission.nodeToObject[otherId]
        if vehicle ~ = nil and vehicle.getSupportsAnimalType ~ = nil then
            if onEnter then
                self:setLoadingTrailer(vehicle)

                if Platform.gameplay.autoActivateTrigger and self.activatable:getIsActivatable() then
                    self.activatable:run()
                    local rootVehicle = vehicle.rootVehicle
                    if rootVehicle.brakeToStop ~ = nil then
                        rootVehicle:brakeToStop()
                    end

                    return
                end
            elseif onLeave then
                    if vehicle = = self.loadingVehicle then
                        self:setLoadingTrailer( nil )
                    end
                    if vehicle = = self.activatedTarget then
                        -- close dialog!
                        g_animalScreen:onVehicleLeftTrigger()
                    end
                end
            elseif g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
                    if onEnter then
                        self.isPlayerInRange = true

                        if Platform.gameplay.autoActivateTrigger and self.activatable:getIsActivatable() then
                            self.activatable:run()
                        end
                    else
                            self.isPlayerInRange = false
                        end
                        self:updateActivatableObject()
                    end
                end
            end

```

### updateActivatableObject

**Description**

> Adds or removes the trigger as an activable object to the mission

**Definition**

> updateActivatableObject()

**Code**

```lua
function AnimalLoadingTrigger:updateActivatableObject()
    if self.loadingVehicle ~ = nil or self.isPlayerInRange then
        g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
    elseif self.loadingVehicle = = nil and not self.isPlayerInRange then
            g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
        end
    end

```