## PlaceablePalletBuyingStation

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
function PlaceablePalletBuyingStation:onDelete()
    local spec = self.spec_palletBuyingStation

    g_currentMission.storageSystem:removePalletBuyingStation( self )

    if spec.palletSpawner ~ = nil then
        spec.palletSpawner:delete()
    end

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
function PlaceablePalletBuyingStation:onLoad(savegame)
    local spec = self.spec_palletBuyingStation

    local key = "placeable.palletBuyingStation"

    spec.triggerNode = self.xmlFile:getValue(key .. "#triggerNode" , nil , self.components, self.i3dMappings)
    if spec.triggerNode = = nil then
        Logging.xmlError( self.xmlFile, "Missing triggerNode for pallet buying station %s" , key)
            return
        end

        addTrigger(spec.triggerNode, "onActivationTriggerCallback" , self )

        local palletSpawnerKey = key .. ".palletSpawner"
        if self.xmlFile:hasProperty(palletSpawnerKey) then
            spec.palletSpawner = PalletSpawner.new( self.baseDirectory)
            if not spec.palletSpawner:load( self.components, self.xmlFile, key .. ".palletSpawner" , self.customEnvironment, self.i3dMappings) then
                Logging.xmlError( self.xmlFile, "Unable to load pallet spawner %s" , palletSpawnerKey)
                return
            end
        end

        spec.pallets = { }
        spec.fillTypeIndexToPallet = { }

        local i = 0
        while true do
            local fillTypeKey = string.format(key .. ".fillType(%d)" , i)
            if not self.xmlFile:hasProperty(fillTypeKey) then
                break
            end

            local fillTypeStr = self.xmlFile:getValue(fillTypeKey .. "#name" )
            local fillType = g_fillTypeManager:getFillTypeByName(fillTypeStr)

            if fillType ~ = nil then
                local fillTypeIndex = fillType.index
                local palletFilename = fillType.palletFilename
                local storeItem = g_storeManager:getItemByXMLFilename(palletFilename)
                local priceScale = self.xmlFile:getValue(fillTypeKey .. "#priceScale" , 1.0 )

                local pallet = { }
                pallet.imageFilename = storeItem.imageFilename
                pallet.title = fillType.title
                pallet.price = MathUtil.round(storeItem.price * priceScale * EconomyManager.getPriceMultiplier(fillTypeIndex), 0 )
                pallet.fillTypeIndex = fillTypeIndex
                table.insert(spec.pallets, pallet)
                spec.fillTypeIndexToPallet[fillTypeIndex] = pallet
            end
            i = i + 1
        end

        local text = g_i18n:getText( self.xmlFile:getValue(key .. "#triggerText" , "palletShop_open" ), self.customEnvironment)
        spec.activatable = PalletBuyingStationActivatable.new( self , text)

        g_currentMission.storageSystem:addPalletBuyingStation( self )

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
function PlaceablePalletBuyingStation.prerequisitesPresent(specializations)
    return true
end

```