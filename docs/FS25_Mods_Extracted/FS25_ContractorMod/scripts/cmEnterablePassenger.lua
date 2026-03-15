cmEnterablePassenger = {}

function cmEnterablePassenger:onLoad(superFunc, savegame)
  if ContractorMod.debug then print("cmEnterablePassenger:onLoad") end
  superFunc(self, savegame)
  -- Force available to true if there are passenger seats (bypass multiplayer check)
  local spec = self.spec_enterablePassenger
  if spec ~= nil and #spec.passengerSeats > 0 and ContractorMod.enablePassenger then
      spec.available = true
      -- Subscribe to message center since available is now true
      if not spec.messageSubscribed then
          g_messageCenter:subscribe(MessageType.PLAYER_STYLE_CHANGED, self.onPassengerPlayerStyleChanged, self)
          spec.messageSubscribed = true
      end
  end
end
EnterablePassenger.onLoad = Utils.overwrittenFunction(EnterablePassenger.onLoad, cmEnterablePassenger.onLoad)

-- Leaving passenger don't leave vehicle leading to crash just after
function cmEnterablePassenger:setPassengerSeatCharacter(superfunc, seatIndex, playerStyle)
    if ContractorMod.debug then print(string.format("cmEnterablePassenger:setPassengerSeatCharacter seatIndex=%s playerStyle=%s", tostring(seatIndex), tostring(playerStyle))) end
    if ContractorMod.switching and playerStyle == nil then
        if ContractorMod.debug then print("switching so keep passenger seat character") end
    else
        if ContractorMod.debug then print("not switching so set passenger seat character") end
        local worker = ContractorMod.workers[ContractorMod.currentID]
        if playerStyle ~= nil then
          worker.currentSeat = seatIndex
        else
          worker.currentSeat = nil
        end
        superfunc(self, seatIndex, playerStyle)
    end
end
EnterablePassenger.setPassengerSeatCharacter = Utils.overwrittenFunction(EnterablePassenger.setPassengerSeatCharacter, cmEnterablePassenger.setPassengerSeatCharacter)

function cmEnterablePassenger:getIsInteractive(superfunc, superFunc)
--   if ContractorMod.debug then print("cmEnterablePassenger:getIsInteractive") end
    if ContractorMod.enablePassenger then
        return true
    else
        return superfunc(self, superFunc)
    end
end
EnterablePassenger.getIsInteractive = Utils.overwrittenFunction(EnterablePassenger.getIsInteractive, cmEnterablePassenger.getIsInteractive)

function cmEnterablePassenger:getDistanceToNode(superfunc, superFunc, node)
    local superDistance = superfunc(self, superFunc, node)
    -- quick debug:
    -- print(("cmEnterablePassenger called for vehicle=%s, superDistance=%.3f"):format(tostring(self:getName()), superDistance))
    local isControlledByWorker = ContractorMod and ContractorMod.isControlledByWorker and ContractorMod:isControlledByWorker(self)
    if self:getIsControlled() or self.spec_enterablePassenger.allowPassengerOnly or isControlledByWorker then
        local seatIndex, distance = self:getClosestSeatIndex(node)
        -- print(("seatIndex=%s distance=%.3f isControlledByWorker=%s"):format(tostring(seatIndex), distance or 0, tostring(isControlledByWorker)))
        if seatIndex ~= nil and distance < superDistance then
            self.interactionFlag = Vehicle.INTERACTION_FLAG_ENTERABLE_PASSENGER
            return distance
        end
    end
    return superDistance
end
EnterablePassenger.getDistanceToNode = Utils.overwrittenFunction(EnterablePassenger.getDistanceToNode, cmEnterablePassenger.getDistanceToNode)