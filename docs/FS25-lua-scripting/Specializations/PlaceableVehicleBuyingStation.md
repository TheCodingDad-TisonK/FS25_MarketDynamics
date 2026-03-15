## PlaceableVehicleBuyingStation

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
function PlaceableVehicleBuyingStation:onDelete()
    local spec = self.spec_vehicleBuyingStation

    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
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
function PlaceableVehicleBuyingStation:onLoad(savegame)
    local spec = self.spec_vehicleBuyingStation

    local key = "placeable.vehicleBuyingStation"

    spec.triggerNode = self.xmlFile:getNode(key .. ".trigger#node" , nil , self.components, self.i3dMappings)
    if spec.triggerNode = = nil then
        Logging.xmlError( self.xmlFile, "Missing triggerNode for vehicle buying station %s" , key)
            return
        end

        addTrigger(spec.triggerNode, "onVehicleBuyingStationTriggerCallback" , self )

        spec.storeItems = { }
        for _, storeItemKey in self.xmlFile:iterator(key .. ".storeItem" ) do
            local xmlFilename = self.xmlFile:getString(storeItemKey .. "#xmlFilename" )
            if string.isNilOrWhitespace(xmlFilename) then
                Logging.xmlError( self.xmlFile, "xmlFilename missing for vehicle buying station %s" , storeItemKey)
                    continue
                end

                local filename = Utils.getFilename(xmlFilename, self.baseDirectory)
                local storeItem = g_storeManager:getItemByXMLFilename(filename)
                if storeItem = = nil then
                    Logging.xmlError( self.xmlFile, "Could not find storeitem for xmlFilename '%s'" , filename)
                        continue
                    end

                    local imageFilename = storeItem.imageFilename
                    local price = self.xmlFile:getInt(storeItemKey .. "#price" , storeItem.price)
                    local transportCosts = self.xmlFile:getInt(storeItemKey .. "#transportCosts" , 15000 )

                    local data = {
                    storeItem = storeItem,
                    title = storeItem.name,
                    price = price,
                    imageFilename = imageFilename,
                    transportCosts = transportCosts
                    }

                    table.addElement(spec.storeItems, data)
                end

                spec.sendNumBits = MathUtil.getNumRequiredBits(#spec.storeItems)

                spec.usedPlaces = { }
                spec.spawnPlaces = { }

                for _, spawnPlaceKey in self.xmlFile:iterator(key .. ".spawnPlaces.spawnPlace" ) do
                    local spawnPlace = PlacementUtil.loadPlaceFromXML( self.xmlFile, spawnPlaceKey, self.components, self.i3dMappings)
                    table.insert(spec.spawnPlaces, spawnPlace)
                end

                if #spec.spawnPlaces = = 0 then
                    Logging.xmlError(spec.xmlFile, "No spawn place(s) defined for vehicle buying station %s%s" , key, ".spawnPlaces" )
                        return false
                    end

                    spec.vehicleBoughtMessage = self.xmlFile:getString(key .. ".message#bought" )
                    spec.vehicleBuyingFailedMessage = self.xmlFile:getString(key .. ".message#failed" )
                    spec.vehicleBuyingFailedNoSpaceMessage = self.xmlFile:getString(key .. ".message#noSpace" )
                    spec.vehicleBuyingFailedNoPermissionMessage = self.xmlFile:getString(key .. ".message#noPermission" )
                    spec.vehicleBuyingFailedNoMoneyMessage = self.xmlFile:getString(key .. ".message#noMoney" )

                    local title = g_i18n:convertText( self.xmlFile:getString(key .. "#title" , "$l10n_ui_vehicleShopTitle" ), self.customEnvironment)
                    local description = g_i18n:convertText( self.xmlFile:getString(key .. "#description" , "$l10n_ui_vehicleShopDescription" ), self.customEnvironment)

                    local text = g_i18n:convertText( self.xmlFile:getString(key .. ".trigger#text" , "$l10n_vehicleShop_open" ), self.customEnvironment)
                    local callbackFunc = function ()
                        if g_currentMission:getHasPlayerPermission( Farm.PERMISSION.BUY_VEHICLE) then

                            local spec = self.spec_vehicleBuyingStation
                            VehicleShopDialog.show( PlaceableVehicleBuyingStation.vehicleShopCallback, self , spec.storeItems, title, description)
                        else
                                InfoDialog.show(g_i18n:getText( "shop_messageNoPermissionGeneral" ))
                            end
                        end
                        spec.activatable = VehicleBuyingStationActivatable.new( self , callbackFunc, text)

                        return true
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
function PlaceableVehicleBuyingStation.prerequisitesPresent(specializations)
    return true
end

```