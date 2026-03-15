---@class ModGui
ModGui = {}

local ModGui_mt = Class(ModGui)

local function addIngameMenuPage(frame, pageName, iconPath, uvs, position, predicateFunc)
    local targetPosition = 0
    local inGameMenu = g_gui.screenControllers[InGameMenu]
    if inGameMenu == nil then
        Logging.warning("addIngameMenuPage: InGameMenu not found.")
        return
    end

    if inGameMenu.pagingElement == nil or inGameMenu.pagingElement.elements == nil or inGameMenu.pagingElement.pages == nil or inGameMenu.pageFrames == nil then
        Logging.warning("addIngameMenuPage: InGameMenu is not fully initialized.")
        return
    end

    for k, v in pairs({ pageName }) do
        g_inGameMenu.controlIDs[v] = nil
    end

    if type(position) == "string" then
        for i = 1, #g_inGameMenu.pagingElement.elements do
            local child = g_inGameMenu.pagingElement.elements[i]
            if child == g_inGameMenu[position] then
                targetPosition = i + 1;
                break
            end
        end
    elseif type(position) == "number" then
        targetPosition = position
    else
        Logging.warning("addIngameMenuPage: Invalid position type. Must be string or number.")
        return
    end

    inGameMenu[pageName] = frame
    inGameMenu.pagingElement:addElement(inGameMenu[pageName])

    inGameMenu:exposeControlsAsFields(pageName)

    if position ~= nil then
        for i = #inGameMenu.pagingElement.elements, 1, -1 do
            local child = inGameMenu.pagingElement.elements[i]
            if child == inGameMenu[pageName] then
                table.remove(inGameMenu.pagingElement.elements, i)
                table.insert(inGameMenu.pagingElement.elements, targetPosition, child)
                break
            end
        end

        for i = #inGameMenu.pagingElement.pages, 1, -1 do
            local child = inGameMenu.pagingElement.pages[i]
            if child.element == inGameMenu[pageName] then
                table.remove(inGameMenu.pagingElement.pages, i)
                table.insert(inGameMenu.pagingElement.pages, targetPosition, child)
                break
            end
        end
    end

    inGameMenu.pagingElement:updateAbsolutePosition()
    inGameMenu.pagingElement:updatePageMapping()

    inGameMenu:registerPage(inGameMenu[pageName], nil, predicateFunc)

    local iconFileName = Utils.getFilename(iconPath, g_modDirectory)
    inGameMenu:addPageTab(inGameMenu[pageName], iconFileName, GuiUtils.getUVs(uvs))

    if position ~= nil then
        for i = 1, #g_inGameMenu.pageFrames do
            local child = inGameMenu.pageFrames[i]
            if child == inGameMenu[pageName] then
                table.remove(inGameMenu.pageFrames, i)
                table.insert(inGameMenu.pageFrames, targetPosition, child)
                break
            end
        end
    end

    inGameMenu:rebuildTabList()
end

function ModGui.new()
    CustomUtils:info("[ModGui] new()")
    local self = setmetatable({}, ModGui_mt)

    if g_client ~= nil then
        addConsoleCommand('emReloadGui', '', 'consoleReloadGui', self)
        addConsoleCommand('emGuiReloadFrames', '', 'consoleReloadFrames', self)
    end

    return self
end

function ModGui:load()
    if g_client == nil then
        return
    end

    g_gui:loadProfiles(g_modDirectory .. "xml/gui/guiProfiles.xml")

    if not self:loadMenuFrame(MenuEmployeeManager) then
        CustomUtils:debug('[MenuEmployeeManager] ModGui:load() MenuEmployeeManager already loaded')
    end

    self:loadTabbedMenu()
end

function ModGui:loadTabbedMenu()
    CustomUtils:info("[ModGui] loadTabbedMenu()")

    local employeeFrame = EMEmployeeFrame:new()
    local workflowFrame = EMWorkflowFrame:new()
    local fieldFrame    = EMFieldFrame:new()
    local vehicleFrame  = EMVehicleFrame:new()

    g_emGui = EMGui:new(g_messageCenter, g_i18n, g_inputBinding)

    CustomUtils:info("[ModGui] Loading EMEmployeeFrame...")
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMEmployeeFrame.xml", "EMEmployeeFrame", employeeFrame, true)
    CustomUtils:info("[ModGui] Loading EMWorkflowFrame...")
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMWorkflowFrame.xml", "EMWorkflowFrame", workflowFrame, true)
    CustomUtils:info("[ModGui] Loading EMFieldFrame...")
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMFieldFrame.xml",    "EMFieldFrame",    fieldFrame,    true)
    CustomUtils:info("[ModGui] Loading EMVehicleFrame...")
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMVehicleFrame.xml",  "EMVehicleFrame",  vehicleFrame,  true)
    CustomUtils:info("[ModGui] Loading EMGui (TabbedMenu)...")
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMGui.xml",           "EMGui",           g_emGui)

    CustomUtils:info("[ModGui] Loading EMTrainingDialog...")
    g_emTrainingDialog = EMTrainingDialog.new()
    g_gui:loadGui(g_modDirectory .. "xml/gui/EMTrainingDialog.xml", "EMTrainingDialog", g_emTrainingDialog)

    CustomUtils:info("[ModGui] TabbedMenu loaded successfully")
end

function ModGui:loadMenuFrame(class)
    if class == nil then
        return false
    end

    local pageController = class.new()
    local pageName = class.MENU_PAGE_NAME

    if self[pageName] ~= nil then
        return false
    end

    if g_gui == nil or g_inGameMenu == nil then
        CustomUtils:info('[MenuEmployeeManager] g_gui or g_inGameMenu not ready, deferring menu load')
        return false
    end

    g_gui:loadGui(class.XML_FILENAME, class.CLASS_NAME, pageController, true)

    local iconSliceToFile = {
        EM_IconMenu     = "images/MenuIcon.dds",
        EM_IconEmployee = "images/EMEmployeeIcon.dds",
        EM_IconWorkflow = "images/EMWorkflowIcon.dds",
        EM_IconField    = "images/EMFieldIcon.dds",
        EM_IconVehicle  = "images/EMVehicleIcon.dds",
    }

    local iconPath = "images/MenuIcon.dds"
    local uvs = {0, 0, 1024, 1024}

    if class.MENU_ICON_SLICE_ID ~= nil and iconSliceToFile[class.MENU_ICON_SLICE_ID] ~= nil then
        iconPath = iconSliceToFile[class.MENU_ICON_SLICE_ID]
    end

    local position = "pageSettings"
    local predicate = function() return true end
    addIngameMenuPage(pageController, pageName, iconPath, uvs, position, predicate)

    if pageController.initialize ~= nil then
        pageController:initialize()
    end

    self[pageName] = pageController

    return true
end

function ModGui:deleteMenuFrame(class)
    local pageName = class.MENU_PAGE_NAME
    if self[pageName] == nil then
        return false
    end

    local pageController = self[pageName]

    g_inGameMenu:setPageEnabled(class, false)
    local _, _, pageRoot, _ = g_inGameMenu:unregisterPage(class)
    g_inGameMenu.pagingElement:removeElement(pageRoot)

    pageRoot:delete()
    pageController:delete()

    FocusManager:deleteGuiFocusData(class.CLASS_NAME)

    g_inGameMenu[pageName] = nil
    self[pageName] = nil

    return true
end

function ModGui:onMapLoaded()
    if g_client ~= nil then
        if g_inGameMenu ~= nil and g_inGameMenu.pagingTabList ~= nil then
            g_inGameMenu.pagingTabList.listItemAlignment = SmoothListElement.ALIGN_START
        end

        self:load()
    end
end

function ModGui:consoleReloadGui()
    if g_server ~= nil and not g_currentMission.missionDynamicInfo.isMultiplayer then
        self:load()
        return 'Reloaded GUI'
    end

    return 'Only available in single player'
end

function ModGui:consoleReloadFrames()
    if g_server ~= nil and not g_currentMission.missionDynamicInfo.isMultiplayer then        
        if self:deleteMenuFrame(MenuEmployeeManager) then
            g_gui.currentlyReloading = true
            self:loadMenuFrame(MenuEmployeeManager)
            g_gui.currentlyReloading = false
            g_inGameMenu:rebuildTabList()
            g_inGameMenu.pagingElement:updatePageMapping()

            g_gui:showGui("InGameMenu")
            return 'Reloaded MenuEmployeeManager'
        end
    end

    return 'Only available in single player'
end

g_modGui = ModGui.new()
