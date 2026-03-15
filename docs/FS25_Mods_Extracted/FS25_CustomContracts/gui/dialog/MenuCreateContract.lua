--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

MenuCreateContract = {}
local MenuCreateContract_mt = Class(MenuCreateContract, MessageDialog)

CustomContractWorkTypes = {
  { id = "CULTIVATE",     text = "Cultivate" },
  { id = "PLOW",          text = "Plow" },
  { id = "SEED",          text = "Seed" },
  { id = "FERTILIZE",     text = "Fertilize" },
  { id = "HARVEST",       text = "Harvest" },
  { id = "ROLL",          text = "Roll" },
  { id = "WEED",          text = "Weed" },
  { id = "LIME",          text = "Lime" },
  { id = "MULCH",         text = "Mulch" },
  { id = "STONEPICK",     text = "Stone Pick" },
  { id = "REMOVEFOLIAGE", text = "Remove Foliage" },
  { id = "MOW",           text = "Mowing" },
  { id = "TEDDING",       text = "Tedding" },
  { id = "WINDROWING",    text = "Windrowing" },
  { id = "BALING",        text = "Baling" },
  { id = "BALEWRAPPING",  text = "Bale Wrapping" },
  { id = "SPRAYING",      text = "Spraying" },
  { id = "OTHER",         text = "Other" }
}

function MenuCreateContract.new(target, custom_mt)
  local self = MessageDialog.new(target, custom_mt or MenuCreateContract_mt)
  return self
end

function MenuCreateContract:onCreate()
  MenuCreateContract:superClass().onCreate(self)
end

function MenuCreateContract:onGuiSetupFinished()
  MenuCreateContract:superClass().onGuiSetupFinished(self)
end

function MenuCreateContract:onOpen()
  MenuCreateContract:superClass().onOpen(self)

  local workTypeTexts = {}

  for _, workType in ipairs(CustomContractWorkTypes) do
    table.insert(workTypeTexts, workType.text)
  end

  self.workTypeSelector:setTexts(workTypeTexts)
  self.workTypeSelector:setState(1, false)

  local fieldIds = {}

  local farmId = g_currentMission:getFarmId()
  if farmId == nil then
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
  self.fieldSelector:setState(1, false)

  self:fillMonthMultiTextOption(self.startDateSelector, "startDateValues")
  self:fillMonthMultiTextOption(self.dueDateSelector, "dueDateValues")

  self.selectedStartDateIndex = 1
  self.selectedDueDateIndex   = 1

  self.selectedFieldIndex     = 1
end

function MenuCreateContract:onClose()
  MenuCreateContract:superClass().onClose(self)
end

function MenuCreateContract:onFieldSelectChange(state)
  self.selectedFieldIndex = state
end

function MenuCreateContract:onGroupSelectChange(state)
  self.selectedWorkTypeIndex = state
end

function MenuCreateContract:onStartDateSelectChange(state)
  self.selectedStartDateIndex = state
end

function MenuCreateContract:onDueDateSelectChange(state)
  self.selectedDueDateIndex = state
end

-- XML onClick handlers
function MenuCreateContract:onConfirm(sender)
  if g_client == nil then
    return
  end

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

  local startV   = self.startDateValues[self.selectedStartDateIndex or 1]
  local dueV     = self.dueDateValues[self.selectedDueDateIndex or 1]

  if startV == nil or dueV == nil then
    InfoDialog.show(g_i18n:getText("cc_dialog_create_validation_fields_due_date"))
    return
  end

  if dueIdx < startIdx then
    InfoDialog.show(g_i18n:getText("cc_dialog_create_validation_fields_start_date"))
    return
  end

  local contract = {
    fieldId     = fieldId,
    workType    = workType,
    reward      = reward,
    description = description or "-",
    startPeriod = startV.period,
    startDay    = startV.day,
    duePeriod   = dueV.period,
    dueDay      = dueV.day
  }

  g_client:getServerConnection():sendEvent(
    CreateContractEvent.new(contract, g_currentMission:getFarmId())
  )

  self:close()
end

function MenuCreateContract:onCancel(sender)
  self:close()
end

function MenuCreateContract:fillMonthMultiTextOption(multiTextOption, valuesFieldName)
  local texts, values = CustomUtils:buildMonthOptionData()

  self[valuesFieldName] = values

  multiTextOption:setTexts(texts)
  multiTextOption:setState(1, true)
end
