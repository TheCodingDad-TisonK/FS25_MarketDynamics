cmShopOthersFrame = {}

-- @doc Set current worker style and display name in wardrobe screen
function cmShopOthersFrame:pre_onOpenWardrobeScreen()
  if ContractorMod.debug then print("cmShopOthersFrame:pre_onOpenWardrobeScreen") end

  --print("player"..tostring(g_localPlayer))
  --print("model "..tostring(g_localPlayer.model))
  --print("style "..tostring(g_localPlayer.model.style))
  --DebugUtil.printTableRecursively(g_localPlayer.model, " ", 1, 2)
  g_localPlayer:setStyleAsync(ContractorMod.workers[ContractorMod.currentID].playerStyle, false, nil, true)
  g_currentMission.playerNickname = ContractorMod.workers[ContractorMod.currentID].name
end
ShopOthersFrame.onOpenWardrobeScreen = Utils.prependedFunction(ShopOthersFrame.onOpenWardrobeScreen, cmShopOthersFrame.pre_onOpenWardrobeScreen)
