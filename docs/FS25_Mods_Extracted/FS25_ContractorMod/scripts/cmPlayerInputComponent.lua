cmPlayerInputComponent = {}

-- @doc Register action events for ContractorMod
PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerGlobalPlayerActionEvents, function()
    if ContractorMod.debug then print("ContractorMod:registerActionEvents()") end
    for _,actionName in pairs({ "ContractorMod_WORKER1",
                                "ContractorMod_WORKER2",
                                "ContractorMod_WORKER3",
                                "ContractorMod_WORKER4",
                                "ContractorMod_WORKER5",
                                "ContractorMod_WORKER6",
                                "ContractorMod_WORKER7",
                                "ContractorMod_WORKER8" }) do
      -- print("actionName "..actionName)
      local success, eventName, event, action = g_inputBinding:registerActionEvent(InputAction[actionName], ContractorMod, ContractorMod.activateWorker, false, true, false, true)
      if success then
        g_inputBinding:setActionEventTextPriority(eventName, GS_PRIO_NORMAL)
        g_inputBinding:setActionEventTextVisibility(eventName, false)
      end
    end
    
    if ContractorMod.useDebugCommands then
      print("ContractorMod:registerActionEvents() for DEBUG")
      for _,actionName in pairs({ "ContractorMod_DEBUG_MOVE_PASS_LEFT",
                                  "ContractorMod_DEBUG_MOVE_PASS_RIGHT",
                                  "ContractorMod_DEBUG_MOVE_PASS_TOP",
                                  "ContractorMod_DEBUG_MOVE_PASS_BOTTOM",
                                  "ContractorMod_DEBUG_MOVE_PASS_FRONT",
                                  "ContractorMod_DEBUG_MOVE_PASS_BACK",
                                  "ContractorMod_DEBUG_DUMP_PASS" }) do
        -- print("actionName "..actionName)
        local __, eventName, event, action = g_inputBinding:registerActionEvent(InputAction[actionName], ContractorMod, ContractorMod.debugCommands ,false ,true ,false ,true)
      end
    end
end)

-- @doc Replace switch vehicle by switch worker
function cmPlayerInputComponent:onInputSwitchVehicle(superfunc, action, direction)
  ContractorMod:onSwitchWorker(action)
end
PlayerInputComponent.onInputSwitchVehicle = Utils.overwrittenFunction(PlayerInputComponent.onInputSwitchVehicle, cmPlayerInputComponent.onInputSwitchVehicle)
