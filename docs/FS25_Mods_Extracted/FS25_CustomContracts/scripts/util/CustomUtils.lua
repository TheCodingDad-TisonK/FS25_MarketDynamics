--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

CustomUtils = {}

CustomUtils.MONTH_NAMES = {
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
}

function CustomUtils.periodToMonth(period)
  return ((period + 1) % 12) + 1
end

function CustomUtils.wrapPeriod(period)
  if period == nil then return 1 end
  return ((period - 1) % 12) + 1
end

function CustomUtils.toOrdinal(period, day, daysPerPeriod)
  period = period or 1
  day = day or 1
  daysPerPeriod = daysPerPeriod or 1
  return (period - 1) * daysPerPeriod + (day - 1)
end

function CustomUtils.getCurrentPeriodDay()
  local env = g_currentMission and g_currentMission.environment
  local period = (env and env.currentPeriod) or 1
  local dpp = (env and env.daysPerPeriod) or 1

  local day = (env and (env.currentDayInPeriod or env.currentPeriodDay)) or 1
  day = math.max(1, math.min(day, dpp))

  return period, day, dpp
end

function CustomUtils.isPastDue(contract, curPeriod, curDay, dpp)
  if contract == nil then return false end
  if contract.duePeriod == nil or contract.duePeriod == -1 then return false end
  if contract.dueDay == nil or contract.dueDay == -1 then return false end

  dpp = dpp or 1
  curPeriod = curPeriod or 1
  curDay = curDay or 1

  local curOrd = CustomUtils.toOrdinal(curPeriod, curDay, dpp)
  local dueOrd = CustomUtils.toOrdinal(contract.duePeriod, contract.dueDay, dpp)

  local yearLen = 12 * dpp
  if (contract.dueYearOffset or 0) > 0 then
    dueOrd = dueOrd + yearLen
    if curPeriod <= contract.duePeriod then
      curOrd = curOrd + yearLen
    end
  end

  return curOrd > dueOrd
end

function CustomUtils.getMonthName(month)
  return CustomUtils.MONTH_NAMES[month] or tostring(month)
end

function CustomUtils:formatPeriodDay(period, day)
  if period == nil or period <= 0 then
    return "-"
  end

  local month = CustomUtils.periodToMonth(period)

  local monthName = CustomUtils.getMonthName(month) or tostring(month)

  local env = g_currentMission.environment
  local daysPerPeriod = (env and env.daysPerPeriod) or 1

  if daysPerPeriod > 1 then
    return string.format("%s %d", monthName, day or 1)
  end

  return monthName
end

function CustomUtils:retrieveFieldInfo(fieldId)
  local field = g_fieldManager:getFieldById(fieldId)

  if field == nil then
    return nil
  end
end

function CustomUtils:buildMonthOptionData()
  local env = g_currentMission.environment
  if env == nil then
    return {}, {}
  end

  local currentPeriod = env.currentPeriod

  local daysPerPeriod = env.daysPerPeriod or 1

  local texts = {}
  local values = {}

  for offset = 0, 11 do
    local period = CustomUtils.wrapPeriod(currentPeriod + offset)
    local month = CustomUtils.periodToMonth(period)

    if daysPerPeriod > 1 then
      for day = 1, daysPerPeriod do
        table.insert(texts,
          string.format("%s %d", CustomUtils.getMonthName(month), day)
        )
        table.insert(values, {
          period = period,
          month  = month,
          day    = day
        })
      end
    else
      table.insert(texts, CustomUtils.getMonthName(month))
      table.insert(values, {
        period = period,
        month  = month,
        day    = 1
      })
    end
  end

  return texts, values
end

function CustomUtils:findIndex(list, value)
  if list == nil then return nil end
  for i, v in ipairs(list) do
    if v == value then return i end
  end
  return nil
end

function CustomUtils:findWorkTypeIndexByText(text)
  if text == nil then return nil end
  for i, wt in ipairs(CustomContractWorkTypes) do
    if wt.text == text then
      return i
    end
  end
  return nil
end

function CustomUtils:findDateIndex(values, period, day)
  if values == nil or period == nil or day == nil then return nil end
  for i, v in ipairs(values) do
    if v.period == period and v.day == day then
      return i
    end
  end
  return nil
end
