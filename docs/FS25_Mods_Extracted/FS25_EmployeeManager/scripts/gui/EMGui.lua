EMGui = {}

local EMGui_mt = Class(EMGui, TabbedMenu)

function EMGui:new(messageCenter, l18n, inputManager)
    local self = TabbedMenu.new(nil, EMGui_mt, messageCenter, l18n, inputManager)

    self.messageCenter = messageCenter
    self.l18n          = l18n
    self.inputManager  = g_inputBinding

    return self
end

function EMGui:onGuiSetupFinished()
    EMGui:superClass().onGuiSetupFinished(self)

    self.clickBackCallback = self:makeSelfCallback(self.onButtonBack)

    self.pageEmployees:initialize()
    self.pageWorkflows:initialize()
    self.pageFields:initialize()
    self.pageVehicles:initialize()

    self:setupPages(self)
    self:setupMenuButtonInfo()
end

function EMGui:setupPages(gui)
    local pages = {
        gui.pageEmployees,
        gui.pageWorkflows,
        gui.pageFields,
        gui.pageVehicles,
    }

    for idx, page in ipairs(pages) do
        local iconSliceToFile = {
            EM_IconMenu     = "images/MenuIcon.dds",
            EM_IconEmployee = "images/EMEmployeeIcon.dds",
            EM_IconWorkflow = "images/EMWorkflowIcon.dds",
            EM_IconField    = "images/EMFieldIcon.dds",
            EM_IconVehicle  = "images/EMVehicleIcon.dds",
        }

        local iconPath = "images/MenuIcon.dds"
        local uvs = {0, 0, 1024, 1024}

        if page.MENU_ICON_SLICE_ID ~= nil and iconSliceToFile[page.MENU_ICON_SLICE_ID] ~= nil then
            iconPath = iconSliceToFile[page.MENU_ICON_SLICE_ID]
        end

        local fullPath = g_modDirectory .. iconPath
        gui:registerPage(page, idx)
        gui:addPageTab(page, fullPath, GuiUtils.getUVs(uvs))
    end

    gui:rebuildTabList()
end

function EMGui:setupMenuButtonInfo()
    local onButtonBackFunction = self.clickBackCallback

    self.defaultMenuButtonInfo = {
        {
            inputAction = InputAction.MENU_BACK,
            text        = g_i18n:getText("button_back"),
            callback    = onButtonBackFunction,
        },
    }

    self.defaultMenuButtonInfoByActions[InputAction.MENU_BACK] = self.defaultMenuButtonInfo[1]

    self.defaultButtonActionCallbacks = {
        [InputAction.MENU_BACK] = onButtonBackFunction,
    }
end

function EMGui:onOpen()
    EMGui:superClass().onOpen(self)
    self.pageEmployees:refresh()
    self.pageWorkflows:refresh()
    self.pageFields:refresh()
    self.pageVehicles:refresh()
end

function EMGui:onClose()
    CustomUtils:info("[EMGui] onClose()")
    EMGui:superClass().onClose(self)
end

function EMGui:onButtonBack()
    CustomUtils:info("[EMGui] onButtonBack()")
    self:exitMenu()
end

function EMGui:onClickBack()
    CustomUtils:info("[EMGui] onClickBack()")
    self:exitMenu()
end

function EMGui:exitMenu()
    self:changeScreen()
end
