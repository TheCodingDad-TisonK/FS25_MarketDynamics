MenuEditContract = {}
local MenuEditContract_mt = Class(MenuEditContract, MessageDialog)

function MenuEditContract.new(target, custom_mt)
  local self = MessageDialog.new(target, custom_mt or MenuEditContract_mt)
  self.editContract = nil
  return self
end

function MenuEditContract:onCreate()
  MenuEditContract:superClass().onCreate(self)
end

function MenuEditContract:setContract(contract)
  self.editContract = contract
end

function MenuEditContract:onOpen()
  MenuEditContract:superClass().onOpen(self)

  self.editContract = g_currentMission.CustomContracts.editContract

  -- must have a contract to edit
  local contract = self.editContract
  if contract == nil then
    self:close()
    return
  end

  -- Fill work types
  local workTypeTexts = {}
  for _, workType in ipairs(CustomContractWorkTypes) do
    table.insert(workTypeTexts, workType.text)
  end
  self.workTypeSelector:setTexts(workTypeTexts)

  -- Fill owned fields
  local fieldIds = {}
  local farmId = g_currentMission:getFarmId()
  if farmId == nil then
    self:close()
    return
  end

  for _, field in pairs(g_fieldManager:getFields()) do
    if field:getOwner() == farmId then
      table.insert(fieldIds, field:getId())
    end
  end
  table.sort(fieldIds)

  self.fieldIds = fieldIds

  local fieldTexts = {}
  for _, fieldId in ipairs(fieldIds) do
    table.insert(fieldTexts, string.format(g_i18n:getText("cc_contract_list_field_label"), fieldId))
  end
  self.fieldSelector:setTexts(fieldTexts)

  -- Fill date options
  self:fillMonthMultiTextOption(self.startDateSelector, "startDateValues")
  self:fillMonthMultiTextOption(self.dueDateSelector, "dueDateValues")

  self.selectedStartDateIndex = 1
  self.selectedDueDateIndex   = 1

  -- Prefill from contract
  self:prefillFromContract(contract)
end

function MenuEditContract:prefillFromContract(contract)
  -- Field -> index
  self.selectedFieldIndex = CustomUtils:findIndex(self.fieldIds, contract.fieldId) or 1
  self.fieldSelector:setState(self.selectedFieldIndex, false)

  -- Worktype -> index (your contract stores text, not id)
  self.selectedWorkTypeIndex = CustomUtils:findWorkTypeIndexByText(contract.workType) or 1
  self.workTypeSelector:setState(self.selectedWorkTypeIndex, false)

  -- Inputs
  self.rewardInput:setText(tostring(contract.reward or ""))
  self.descriptionInput:setText(contract.description or "-")
end

function MenuEditContract:onFieldSelectChange(state)
  self.selectedFieldIndex = state
end

function MenuEditContract:onWorkTypeSelectChange(state)
  self.selectedWorkTypeIndex = state
end

function MenuEditContract:onStartDateSelectChange(state)
  self.selectedStartDateIndex = state
end

function MenuEditContract:onDueDateSelectChange(state)
  self.selectedDueDateIndex = state
end

-- XML onClick handlers
function MenuEditContract:onConfirm(sender)
  if g_client == nil then return end

  local old = self.editContract
  if old == nil then return end

  local fieldId = self.fieldIds[self.selectedFieldIndex or 0]
  local reward = tonumber(self.rewardInput:getText())
  local description = self.descriptionInput:getText()

  local index = self.selectedWorkTypeIndex or 1
  local workType = CustomContractWorkTypes[index].text

  if fieldId == nil or reward == nil or workType == nil then
    InfoDialog.show(g_i18n:getText("cc_dialog_create_validation_fields"))
    return
  end

  local startIdx = self.selectedStartDateIndex or 1
  local dueIdx   = self.selectedDueDateIndex or 1

  local startV   = self.startDateValues[startIdx]
  local dueV     = self.dueDateValues[dueIdx]

  if startV == nil or dueV == nil then
    InfoDialog.show(g_i18n:getText("cc_dialog_create_validation_fields_due_date"))
    return
  end

  if dueIdx < startIdx then
    InfoDialog.show(g_i18n:getText("cc_dialog_create_validation_fields_start_date"))
    return
  end

  local updated = {
    fieldId     = fieldId,
    workType    = workType,
    reward      = reward,
    description = description or "-",
    startPeriod = startV.period,
    startDay    = startV.day,
    duePeriod   = dueV.period,
    dueDay      = dueV.day
  }

  -- IMPORTANT: your event must support passing the updated data
  g_client:getServerConnection():sendEvent(
    EditContractEvent.new(old.id, updated, g_currentMission:getFarmId())
  )

  self:close()
end

function MenuEditContract:onCancel(sender)
  self:close()
end

function MenuEditContract:fillMonthMultiTextOption(multiTextOption, valuesFieldName)
  local texts, values = CustomUtils:buildMonthOptionData()

  self[valuesFieldName] = values

  multiTextOption:setTexts(texts)
  multiTextOption:setState(1, true)
end
