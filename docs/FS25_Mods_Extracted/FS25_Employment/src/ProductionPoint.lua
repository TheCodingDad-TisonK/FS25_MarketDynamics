Employment_ProductionPoint = {}

function Employment_ProductionPoint:interactionTriggerCallback(_, otherId, onEnter, onLeave, onStay, otherShapeId)

    if (onEnter or onLeave) and g_localPlayer ~= nil and g_localPlayer.rootNode == otherId then

        local placeable = self.owningPlaceable
        if placeable.spec_employer == nil or self.activatableEmployer == nil then return end

        local employmentSystem = g_currentMission.employmentSystem

        if onEnter and not self.isOwned and not employmentSystem.isShowingInput then

            g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, true)
            employmentSystem.isShowingInput = true
            employmentSystem:setCallbackPlaceable(self.owningPlaceable)
            employmentSystem:setCallbackPlayer(g_localPlayer.uniqueUserId)

        end

        if (onLeave or self.isOwned) and employmentSystem.isShowingInput then

            g_inputBinding:setActionEventTextVisibility(employmentSystem.eventId, false)
            employmentSystem.isShowingInput = false
            employmentSystem:setCallbackPlaceable(nil)
            employmentSystem:setCallbackPlayer(nil)

        end

    end

end

ProductionPoint.interactionTriggerCallback = Utils.appendedFunction(ProductionPoint.interactionTriggerCallback, Employment_ProductionPoint.interactionTriggerCallback)