-- AIHotspot:setAIHelperName(name)
cmAIHotspot = {}

-- Append character name when worker is active (not really visible)
function cmAIHotspot:setAIHelperName(superfunc, name)
    local currentWorker = ContractorMod.workers[ContractorMod.currentID]
    local _, textSize = getNormalizedScreenValues(0, 20)
    self.textSize = textSize
    self:setColor(unpack(currentWorker.color))
    self.name = name .. " (" .. currentWorker.name .. ")"
end
AIHotspot.setAIHelperName = Utils.overwrittenFunction(AIHotspot.setAIHelperName, cmAIHotspot.setAIHelperName);

