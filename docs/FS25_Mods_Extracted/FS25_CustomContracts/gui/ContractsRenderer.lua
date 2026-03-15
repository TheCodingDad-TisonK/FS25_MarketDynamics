--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

ContractsRenderer = {}
ContractsRenderer_mt = Class(ContractsRenderer)

function ContractsRenderer.new()
  local self = {}
  setmetatable(self, ContractsRenderer_mt)
  self.data = nil
  self.selectedRow = -1;
  self.indexChangedCallback = nil

  return self
end

function ContractsRenderer:setData(data)
  self.data = data
end

function ContractsRenderer:getNumberOfSections()
  return 1
end

function ContractsRenderer:getNumberOfItemsInSection(list, section)
  local menu = g_currentMission.CustomContracts.CustomContractsMenu
  local selection = menu.contractDisplaySwitcher:getState()
  return #self.data[selection]
end

function ContractsRenderer:getTitleForSectionHeader(list, section)
  return ""
end

function ContractsRenderer:populateCellForItemInSection(list, section, index, cell)
  local menu = g_currentMission.CustomContracts.CustomContractsMenu
  local selection = menu.contractDisplaySwitcher:getState()
  local contract = self.data[selection][index]

  local farm = g_farmManager:getFarmById(contract.creatorFarmId)

  cell:getAttribute("farmIcon"):setImageSlice(nil, farm:getIconSliceId())
  cell:getAttribute("field"):setText(string.format(g_i18n:getText("cc_contract_list_field_label"), contract.fieldId))
  cell:getAttribute("reward"):setText(g_i18n:formatMoney(contract.reward, 0, true, true))
end

function ContractsRenderer:onListSelectionChanged(list, section, index)
  self.selectedRow = index
  if self.indexChangedCallback ~= nil then
    self.indexChangedCallback(index)
  end
end
