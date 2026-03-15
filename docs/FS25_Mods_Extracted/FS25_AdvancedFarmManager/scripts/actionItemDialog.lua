ActionItemDialog = {}
ActionItemDialog.modFolder = g_currentModDirectory
local ActionItemDialog_mt = Class(ActionItemDialog, YesNoDialog)

function ActionItemDialog.register()
    local instance = ActionItemDialog.new()
    g_gui:loadGui(ActionItemDialog.modFolder .. "gui/ActionItemDialog.xml", "ActionItemDialog", instance)
    ActionItemDialog.INSTANCE = instance
end

function ActionItemDialog:show(callback, target, item, price, storeItem, customArgs, headText, yesSound)
    if ActionItemDialog.INSTANCE ~= nil then
        local dialog = ActionItemDialog.INSTANCE
        dialog:setItem(item, price, storeItem, headText)
        dialog:setCallback(callback, target, customArgs)
        dialog:setButtonSounds(yesSound, nil)
        g_gui:showDialog("ActionItemDialog")
    end
end

function ActionItemDialog.new(self, custom_mt)
    local instance = YesNoDialog.new(self, custom_mt or ActionItemDialog_mt)
    instance.selectedFillType = nil
    instance.areButtonsDisabled = false
    return instance
end

function ActionItemDialog.createFromExistingGui(self, _)
    ActionItemDialog.register()
    local item = self.item
    local price = item.price
    local storeItem = self.storeItem
    local callbackFunc = self.callbackFunc
    local target = self.target
    local customArgs = self.customArgs
    local headText = self.headText
    ActionItemDialog.show(self, callbackFunc, target, item, price, storeItem, customArgs, headText)
end

function ActionItemDialog.setItem(self, item, price, storeItem, headText)

    local imageFilename = "dataS/menu/black.png"
    local itemName = "unknown"
    local formattedPrice = g_i18n:formatMoney(Utils.getNoNil(price, 0), 0, true, true)

    if item == nil then
        if storeItem ~= nil then
            imageFilename = storeItem.imageFilename
            itemName = storeItem.name
        end
    else
        storeItem = storeItem or g_storeManager:getItemByXMLFilename(item.configFileName)
        if storeItem ~= nil then
            imageFilename = storeItem.imageFilename
            itemName = storeItem.name
        end

        if item.getFullName ~= nil then
            itemName = item:getFullName()
        elseif item.getName ~= nil then
            itemName = item:getName()
        end

        if item.getImageFilename ~= nil then
            imageFilename = item:getImageFilename()
        end
    end

    self.dialogImageElement:setImageFilename(imageFilename)
    self.dialogItemNameElement:setText(itemName)
    self.dialogItemPriceElement:setVisible(true)
    self.headerText:setText(headText)
    self.dialogItemPriceElement:setText(formattedPrice)
    self.item = item
    self.storeItem = storeItem
    self.headText = headText
end
