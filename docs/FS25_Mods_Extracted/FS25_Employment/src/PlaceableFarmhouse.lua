Employment_PlaceableFarmhouse = {}


function Employment_PlaceableFarmhouse:farmhouseSleepingTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)

    if (onEnter or onLeave) and g_localPlayer ~= nil and otherActorId == g_localPlayer.rootNode then

        local employmentSystem = g_currentMission.employmentSystem

        if onEnter then

            if not employmentSystem.isShowingEducationInput then
                g_inputBinding:setActionEventTextVisibility(employmentSystem.educationEventId, true)
                employmentSystem.isShowingEducationInput = true
                employmentSystem:setCallbackPlayer(g_localPlayer.uniqueUserId)
            end

        end

        if onLeave and employmentSystem.isShowingEducationInput then
            g_inputBinding:setActionEventTextVisibility(employmentSystem.educationEventId, false)
            employmentSystem.isShowingEducationInput = false
            employmentSystem:setCallbackPlayer(nil)
        end

    end

end

PlaceableFarmhouse.farmhouseSleepingTriggerCallback = Utils.appendedFunction(PlaceableFarmhouse.farmhouseSleepingTriggerCallback, Employment_PlaceableFarmhouse.farmhouseSleepingTriggerCallback)