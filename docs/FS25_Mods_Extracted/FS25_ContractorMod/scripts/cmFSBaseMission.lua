cmFSBaseMission = {}

-- Change character name from wardrobe screen player nickname
function cmFSBaseMission:pre_setPlayerNickname(player, nickname, userId, noEventSend)
  if ContractorMod.debug then print("cmFSBaseMission:pre_setPlayerNickname "..tostring(nickname)) end
  if ContractorMod.workers then
    worker = ContractorMod.workers[ContractorMod.currentID]
    worker.name = nickname
    worker.npc.title = nickname
  end
end
FSBaseMission.setPlayerNickname = Utils.prependedFunction(FSBaseMission.setPlayerNickname, cmFSBaseMission.pre_setPlayerNickname)
