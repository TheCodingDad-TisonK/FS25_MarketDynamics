-- by modelleicher (Farming Agency)
-- 
-- Version 1.0 for FS19 | 15.12.2018
-- Version 2.0 for FS22 | January 2022
-- Version 3.0 for FS25 | Novemnber 2024


removeFrontloaderAxleLocking = {}

function removeFrontloaderAxleLocking.prerequisitesPresent(specializations)
    return true
end;

function removeFrontloaderAxleLocking.registerEventListeners(vehicleType)
	SpecializationUtil.registerEventListener(vehicleType, "onLoad", removeFrontloaderAxleLocking)
	SpecializationUtil.registerEventListener(vehicleType, "onUpdate", removeFrontloaderAxleLocking)
end;

function removeFrontloaderAxleLocking:onUpdate(dt)

	if self:getIsActive() and self.spec_removeFrontloaderAxleLocking ~= nil then
		local rotLimitBackup = self.spec_removeFrontloaderAxleLocking.rotLimitBackup
		local rotLimit = self.componentJoints[self.spec_frontloaderAttacher.frontAxisJoint].rotLimit
		
		if rotLimit[3] ~= rotLimitBackup[3] then
			self:setComponentJointRotLimit(self.componentJoints[self.spec_frontloaderAttacher.frontAxisJoint], 3, -rotLimitBackup[3], rotLimitBackup[3])
		end;			
	end;
	
end;

function removeFrontloaderAxleLocking:onLoad(savegame)
	-- only run on SP or server, only run when frontloaderAttacher isn't nil, only run if it has a frontAxisJoint 
	if self.isServer and  self.spec_frontloaderAttacher ~= nil and self.spec_frontloaderAttacher.frontAxisJoint ~= nil then  -- only if FL attacher is there
		self.spec_removeFrontloaderAxleLocking = {}
		self.spec_removeFrontloaderAxleLocking.rotLimitBackup = {}
		self.spec_removeFrontloaderAxleLocking.rotLimitBackup[3] = self.componentJoints[self.spec_frontloaderAttacher.frontAxisJoint].rotLimit[3]					
	end;
end;


