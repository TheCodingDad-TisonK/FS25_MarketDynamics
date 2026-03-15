EmployeeRenderer = {}
EmployeeRenderer_mt = Class(EmployeeRenderer)

function EmployeeRenderer.new(menu)
    local self = setmetatable({}, EmployeeRenderer_mt)
    self.menu                 = menu
    self.data                 = nil
    self.selectedRow          = -1
    self.indexChangedCallback = nil
    return self
end

function EmployeeRenderer:setData(data)
    self.data = data
end

function EmployeeRenderer:getNumberOfSections()
    return 1
end

function EmployeeRenderer:getNumberOfItemsInSection(list, section)
    local menu = self.menu
    if menu == nil then return 0 end

    local selection = 1
    if menu.pageSwitcher ~= nil then
        selection = menu.pageSwitcher:getState()
    end

    if self.data == nil or self.data[selection] == nil then
        return 0
    end
    return #self.data[selection]
end

function EmployeeRenderer:getTitleForSectionHeader(list, section)
    return ""
end

function EmployeeRenderer:populateCellForItemInSection(list, section, index, cell)
    local menu = self.menu
    if menu == nil then return end

    local selection = 1
    if menu.pageSwitcher ~= nil then
        selection = menu.pageSwitcher:getState()
    end

    if self.data == nil or self.data[selection] == nil then return end
    local item = self.data[selection][index]
    if item == nil then return end

    local avatarEl = cell:getAttribute("avatar")
    local iconEl = cell:getAttribute("icon")

    if item.skills ~= nil then
        -- Employee item: show avatar, hide atlas icon
        if avatarEl ~= nil then
            avatarEl:setImageFilename(g_modDirectory .. "textures/assets/profil_male_1.png")
            avatarEl:setVisible(true)
        end
        if iconEl ~= nil then
            iconEl:setVisible(false)
        end

        cell:getAttribute("title"):setText(item.name)

        local hourlyWage = item.getHourlyWage and item:getHourlyWage() or 0
        local wageText = g_i18n:formatMoney(hourlyWage, 0, true, true) .. " /h"
        cell:getAttribute("subtitle"):setText(wageText)

    elseif item.area ~= nil then
        -- Field item: hide avatar, show atlas icon
        if avatarEl ~= nil then
            avatarEl:setVisible(false)
        end
        if iconEl ~= nil then
            iconEl:setVisible(true)
            iconEl:setImageSlice(g_gui.sharedGuiAtlas, "ingameMenu/tab_map")
        end

        cell:getAttribute("title"):setText(item.name)
        cell:getAttribute("subtitle"):setText(string.format("%.2f ha", item.area))

    else
        if avatarEl ~= nil then avatarEl:setVisible(false) end
        if iconEl ~= nil then iconEl:setVisible(true) end
        cell:getAttribute("title"):setText("?")
        cell:getAttribute("subtitle"):setText("")
    end
end

function EmployeeRenderer:onListSelectionChanged(list, section, index)
    self.selectedRow = index
    if self.indexChangedCallback ~= nil then
        self.indexChangedCallback(index)
    end
end
