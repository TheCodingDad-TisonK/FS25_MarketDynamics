cmInGameMenuMapFrame = {}

function cmInGameMenuMapFrame:onClickSwitchWorker()
  if ContractorMod.debug then print("cmInGameMenuMapFrame:onClickSwitchWorker") end
	if self.currentHotspot ~= nil then
		if self.currentHotspot:isa(NPCHotspot) then
			local npc = self.currentHotspot:getNPC()
			if npc ~= nil then
				self.onClickBackCallback()
        local worker = ContractorMod:getWorkerFromNPC(npc)
        if worker ~= nil then
            ContractorMod:setCurrentContractorModWorker(worker.index)
        end
			end
		end
  end
	return true
end

function cmInGameMenuMapFrame:onClickActivateWorker()
  if ContractorMod.debug then print("cmInGameMenuMapFrame:onClickActivateWorker") end
	if self.currentHotspot ~= nil then
		if self.currentHotspot:isa(NPCHotspot) then
			local npc = self.currentHotspot:getNPC()
			if npc ~= nil then
				self.onClickBackCallback()
        local worker = ContractorMod:getWorkerFromNPC(npc)
        if worker ~= nil then
            worker:setActive(true)
        end
			end
		end
  end
	return true
end

function cmInGameMenuMapFrame:onClickDeactivateWorker()
  if ContractorMod.debug then print("cmInGameMenuMapFrame:onClickDeactivateWorker") end
	if self.currentHotspot ~= nil then
		if self.currentHotspot:isa(NPCHotspot) then
			local npc = self.currentHotspot:getNPC()
			if npc ~= nil then
				self.onClickBackCallback()
        local worker = ContractorMod:getWorkerFromNPC(npc)
        if worker ~= nil then
            worker:setActive(false)
        end
			end
		end
  end
	return true
end

function cmInGameMenuMapFrame:setMapInputContext(superfunc, canEnter, canReset, canSellVehicle, canVisit, canSetMarker, removeMarker, canBuy, canSell, canManage)  
  if ContractorMod.debug then print("cmInGameMenuMapFrame:setMapInputContext") end
  superfunc(self, canEnter, canReset, canSellVehicle, canVisit, canSetMarker, removeMarker, canBuy, canSell, canManage)
    self.contextActions[InGameMenuMapFrame.ACTIONS.SWITCH_WORKER].isActive = false
    self.contextActions[InGameMenuMapFrame.ACTIONS.ACTIVATE_WORKER].isActive = false
    self.contextActions[InGameMenuMapFrame.ACTIONS.DEACTIVATE_WORKER].isActive = false
    -- Enable SWITCH_WORKER only for NPCs
    if self.currentHotspot ~= nil and self.currentHotspot:isa(NPCHotspot) then
			local npc = self.currentHotspot:getNPC()
			if npc ~= nil then
        local worker = ContractorMod:getWorkerFromNPC(npc)
        if worker ~= nil then
          if ContractorMod.debug then print("Worker "..worker.name.." active: "..tostring(worker.active)) end
          self.contextActions[InGameMenuMapFrame.ACTIONS.SWITCH_WORKER].isActive = worker.active
          self.contextActions[InGameMenuMapFrame.ACTIONS.ACTIVATE_WORKER].isActive = worker.active == false
          self.contextActions[InGameMenuMapFrame.ACTIONS.DEACTIVATE_WORKER].isActive = worker.active
        end
      end
    end
end

InGameMenuMapFrame.setMapInputContext = Utils.overwrittenFunction(InGameMenuMapFrame.setMapInputContext, cmInGameMenuMapFrame.setMapInputContext)


function cmInGameMenuMapFrame:onLoadMapFinished(superFunc)
  if ContractorMod.debug then print("cmInGameMenuMapFrame:onLoadMapFinished") end
  superFunc(self)

  InGameMenuMapFrame.ACTIONS.SWITCH_WORKER = #self.contextActions + 1
  InGameMenuMapFrame.ACTIONS.ACTIVATE_WORKER = #self.contextActions + 2
  InGameMenuMapFrame.ACTIONS.DEACTIVATE_WORKER = #self.contextActions + 3
  
  self.contextActions[InGameMenuMapFrame.ACTIONS.SWITCH_WORKER] = { ["callback"] = cmInGameMenuMapFrame.onClickSwitchWorker, ["title"] = g_i18n:getText("action_ContractorMod_SWITCH"), ["isActive"] = false }
  self.contextActions[InGameMenuMapFrame.ACTIONS.ACTIVATE_WORKER] = { ["callback"] = cmInGameMenuMapFrame.onClickActivateWorker, ["title"] = g_i18n:getText("action_ContractorMod_ACTIVATE"), ["isActive"] = false }
  self.contextActions[InGameMenuMapFrame.ACTIONS.DEACTIVATE_WORKER] = { ["callback"] = cmInGameMenuMapFrame.onClickDeactivateWorker, ["title"] = g_i18n:getText("action_ContractorMod_DEACTIVATE"), ["isActive"] = false }
  
end
InGameMenuMapFrame.onLoadMapFinished = Utils.overwrittenFunction(InGameMenuMapFrame.onLoadMapFinished, cmInGameMenuMapFrame.onLoadMapFinished)