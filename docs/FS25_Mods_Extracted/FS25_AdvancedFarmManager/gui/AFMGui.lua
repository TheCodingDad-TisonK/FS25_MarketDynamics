--
-- AdvancedFarmManager - GUI Layout
--

AFMGui = {}

local AFMGui_mt = Class(AFMGui, TabbedMenu)

function AFMGui:new(messageCenter, l18n, inputManager)
    local self = TabbedMenu.new(nil, AFMGui_mt, messageCenter, l18n, inputManager)

    self.messageCenter = messageCenter
    self.l18n          = l18n
    self.inputManager  = g_inputBinding

    return self
end

function AFMGui:onGuiSetupFinished()
    AFMGui:superClass().onGuiSetupFinished(self)

    self.clickBackCallback = self:makeSelfCallback(self.onButtonBack)

    self.pageAFMVehicles:initialize()
    self.pageAFMImplements:initialize()
    self.pageAFMPlaceables:initialize()
    self.pageAFMFields:initialize()

    self:initData()

    self:setupPages(self)

    self:setupMenuButtonInfo()
end

function AFMGui:setupPages(gui)
    local pages = {
        {gui.pageAFMVehicles,   'afm_icon_vehicle.dds'},
        {gui.pageAFMImplements, 'afm_icon_attach.dds'},
        {gui.pageAFMPlaceables, 'afm_icon_placeable.dds'},
        {gui.pageAFMFields,     'afm_icon_field.dds'},
    }

    for idx, thisPage in ipairs(pages) do
        local page, icon = unpack(thisPage)
        local iconFileName = Utils.getFilename('icons/' .. icon, AdvancedFarmManager.modFolder)
        gui:registerPage(page, idx)
        gui:addPageTab(page, iconFileName, GuiUtils.getUVs({ 0, 0, 1024, 1024 }))
    end

    gui:rebuildTabList()
end

function AFMGui:initData()
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGui:initData")
    end
end

function AFMGui:setupMenuButtonInfo()
    local onButtonBackFunction = self.clickBackCallback;

    self.defaultMenuButtonInfo = {
        {
            inputAction = InputAction.MENU_BACK,
            text        = g_i18n:getText("button_back"),
            callback    = onButtonBackFunction
        },
        {
            inputAction = InputAction.MENU_ACTIVATE,
            text        = g_i18n:getText("button_back"),
            callback    = onButtonBackFunction
        }
    }

    self.defaultMenuButtonInfoByActions[InputAction.MENU_BACK]     = self.defaultMenuButtonInfo[1]

    self.defaultButtonActionCallbacks = {
        [InputAction.MENU_BACK] = onButtonBackFunction,
    }
end

function AFMGui:exitMenu()
    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGui:exitMenu")
    end
    self:initData()
    self:changeScreen()

    if AdvancedFarmManager.debug then
        -- Enable to be able to reload the xml stuffs in game.  Disable for production as it breaks things outside of the mod.  
        -- AdvancedFarmManager:reloadGui()
    end
end