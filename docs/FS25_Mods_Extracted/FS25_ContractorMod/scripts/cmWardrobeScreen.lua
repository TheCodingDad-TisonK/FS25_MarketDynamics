cmWardrobeScreen = {}

function cmWardrobeScreen:app_onItemSelectionConfirmed()
  if ContractorMod.debug then print("cmWardrobeScreen:app_onItemSelectionConfirmed") end
  worker = ContractorMod.workers[ContractorMod.currentID]
  worker.playerStyle:copyFrom(self.currentPlayerStyle)
  worker.npc.playerGraphics:setStyleAsync(self.currentPlayerStyle, worker.npc.loadCharacterFinished, worker.npc, {})
end
WardrobeScreen.onItemSelectionConfirmed = Utils.appendedFunction(WardrobeScreen.onItemSelectionConfirmed, cmWardrobeScreen.app_onItemSelectionConfirmed)
