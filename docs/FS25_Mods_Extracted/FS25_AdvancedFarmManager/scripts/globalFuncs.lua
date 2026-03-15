---Simple debug function that does stuff with different types of vars.  
function afmDebug(data)
  local debug = false
  if debug then
    if data ~= nil then
      -- Run if data is table
      if type(data) == "table" then
        print("** AFM Debug - Table **")
        DebugUtil.printTableRecursively(data, "  tabledata : ", 0, 1)
      -- Run if data is boolean
      elseif type(data) == "boolean" then
        if data == true then 
          print("** AFM Debug - Boolean ** : true")
        else 
          print("** AFM Debug - Boolean ** : false")
        end
      -- Run if data is number
      elseif type(data) == "number" then
        print("** AFM Debug - Number ** : " .. data)
      -- Run if data is string
      elseif type(data) == "string" then
        print("** AFM Debug - String ** : " .. data)
      -- Run if data is function
      elseif type(data) == "function" then
        print("** AFM Debug - Function ** : ")
        print(data)
      -- Run if data is thread
      elseif type(data) == "thread" then
        print("** AFM Debug - Thread ** : ")
        print(data)
      -- Run if nothing else
      else
        print("** AFM Debug ** : " .. data)
      end
    else
      print("** AFM Debug ** : nil")
    end
  end
end

---Utility to safely resolve the local player's farm id in both single and multiplayer
-- situations. When the local player is not yet available we fall back to the
-- mission's farm id so that spectator/host contexts continue to behave
-- sensibly.
function afmGetPlayerFarmId()
  if g_localPlayer ~= nil and g_localPlayer.farmId ~= nil then
    return g_localPlayer.farmId
  end

  if g_currentMission ~= nil then
    if g_currentMission.player ~= nil and g_currentMission.player.farmId ~= nil then
      return g_currentMission.player.farmId
    end

    if g_currentMission.getFarmId ~= nil then
      return g_currentMission:getFarmId()
    end
  end

  return FarmManager ~= nil and FarmManager.SPECTATOR_FARM_ID or 0
end


function afmGetLocalUniqueUserId()
  if g_HotKeyVehicleSystem ~= nil then
    local storedUniqueUserId = g_HotKeyVehicleSystem:getLocalUniqueUserId()
    if storedUniqueUserId ~= nil then
      return storedUniqueUserId
    end
  end

  if g_localPlayer ~= nil then
    return g_currentMission.userManager:getUniqueUserIdByUserId(g_localPlayer.userId)
  end

  return nil
end


