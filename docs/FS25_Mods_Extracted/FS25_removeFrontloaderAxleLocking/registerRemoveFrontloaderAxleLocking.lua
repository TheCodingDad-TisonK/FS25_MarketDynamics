-- Register Specialization

-- add removeFrontloaderAxleLocking spec
g_specializationManager:addSpecialization("removeFrontloaderAxleLocking", "removeFrontloaderAxleLocking", g_currentModDirectory.."removeFrontloaderAxleLocking.lua")

registerRemoveFrontloaderAxleLocking = {}
registerRemoveFrontloaderAxleLocking.addingDone = false

function registerRemoveFrontloaderAxleLocking:register(name)

	if not registerRemoveFrontloaderAxleLocking.addingDone then -- use this to only run this once despite the typeManager being called twice (placeable and vehicles)
    
		for _, vehicle in pairs(g_vehicleTypeManager:getTypes()) do
			
			local frontloaderAttacher = false
			local removeFrontloaderAxleLocking = false
			
			for _, spec in pairs(vehicle.specializationNames) do
			
				if spec == "frontloaderAttacher" then -- check for frontloaderAttacher, only insert into frontloaderAttacher
					frontloaderAttacher = true
				end
				if spec == "removeFrontloaderAxleLocking" then -- don't insert if already inserted
					removeFrontloaderAxleLocking = true
				end
				
			end    
			if frontloaderAttacher and not removeFrontloaderAxleLocking then
				g_vehicleTypeManager:addSpecialization(vehicle.name, "FS25_removeFrontloaderAxleLocking.removeFrontloaderAxleLocking")
			end
		end
		
		print("FS22_frontloaderAxleLockRemover: Specialization added to all vehicles with frontloaderAttacher. Front-axles are not anymore limited by front-loaders :)")
		registerRemoveFrontloaderAxleLocking.addingDone = true
	end
end

TypeManager.finalizeTypes = Utils.prependedFunction(TypeManager.finalizeTypes, registerRemoveFrontloaderAxleLocking.register)




