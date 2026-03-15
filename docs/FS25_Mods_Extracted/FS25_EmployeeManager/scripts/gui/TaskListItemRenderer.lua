TaskListItemRenderer = {}
local TaskListItemRenderer_mt = Class(TaskListItemRenderer)

function TaskListItemRenderer.new(menu)
    local self = {}
    setmetatable(self, TaskListItemRenderer_mt)
    self.menu = menu
    self.list = {}
    return self
end

function TaskListItemRenderer:setData(dataList)
    self.list = dataList or {}
end

function TaskListItemRenderer:getNumberOfSections()
    return 1
end

function TaskListItemRenderer:getNumberOfItemsInSection(list, section)
    return #self.list
end

function TaskListItemRenderer:populateCellForItemInSection(list, section, index, cell)
    local item = self.list[index]
    if item then
        cell:getAttribute("title"):setText(item.label)
    end
end

function TaskListItemRenderer:onListSelectionChanged(list, section, index)
    -- Handled by menu
end
