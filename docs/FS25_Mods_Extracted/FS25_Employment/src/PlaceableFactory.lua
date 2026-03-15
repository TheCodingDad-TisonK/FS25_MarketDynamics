Employment_PlaceableFactory = {}

function Employment_PlaceableFactory:playerTriggerCallback(_, otherId, onEnter, onLeave, _, _)

    if (onEnter or onLeave) and g_localPlayer ~= nil and g_localPlayer.rootNode == otherId then

        local spec = self.spec_factory
        if self.spec_employer == nil or spec.activatableEmployer == nil then return end

        local employmentSystem = g_currentMission.employmentSystem

        if onEnter and not employmentSystem.isShowingInput then
            g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, true)
            employmentSystem.isShowingInput = true
            employmentSystem:setCallbackPlaceable(self)
            employmentSystem:setCallbackPlayer(g_localPlayer.uniqueUserId)
        end

        if onLeave and employmentSystem.isShowingInput then
            g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, false)
            employmentSystem.isShowingInput = false
            employmentSystem:setCallbackPlaceable(nil)
            employmentSystem:setCallbackPlayer(nil)
        end

    end

end

PlaceableFactory.playerTriggerCallback = Utils.appendedFunction(PlaceableFactory.playerTriggerCallback, Employment_PlaceableFactory.playerTriggerCallback)