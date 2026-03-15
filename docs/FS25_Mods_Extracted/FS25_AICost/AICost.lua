AICost = {}; 
AICost.metadata = {
	interface = "FS25 ...", --convert ls22 to ls25
	title = "AICost",
	notes = "Senkt die Kosten der AI/Verbrauchsgüter",
	author = "(by HappyLooser)",
	version = "1.0.0.0",	
	build = 4,
	datum = "25.11.2021",
	update = "04.12.2024",
	web = "",
	info = "Link Freigabe,Änderungen,Kopien oder Code Benutzung ist ohne meine Zustimmung nicht erlaubt",
	"##Orginal Link Freigabe:"
};

--------------------------------------------------optional edit here--------------------------------------------------
AICost.reduce = {
	purchaseConsumable = true; --optional can Helper purchase Consumable (fertilizer.manure ...)
	purchaseConsumableCostPerLiter = 0.03;
	job = true;
	jobPricePerMs = 0.00005;
};
--------------------------------------------------optional edit here--------------------------------------------------

function AICost:loadMap(name)
	print("---loading ".. tostring(AICost.metadata.title).. " ".. tostring(AICost.metadata.version).. "(#".. tostring(AICost.metadata.build).. ") ".. tostring(AICost.metadata.author).. "---")		
end; 

if AICost.reduce.job then
	AIJob.getPricePerMs = Utils.overwrittenFunction(AIJob.getPricePerMs, AIJob.getPricePerMs);
	AIJobConveyor.getPricePerMs = Utils.overwrittenFunction(AIJobConveyor.getPricePerMs, AIJobConveyor.getPricePerMs);
	AIJobFieldWork.getPricePerMs = Utils.overwrittenFunction(AIJobFieldWork.getPricePerMs, AIJobFieldWork.getPricePerMs);
	AIJobDeliver.getPricePerMs = Utils.overwrittenFunction(AIJobDeliver.getPricePerMs, AIJobDeliver.getPricePerMs);
	AIJobGoTo.getPricePerMs = Utils.overwrittenFunction(AIJobGoTo.getPricePerMs, AIJobGoTo.getPricePerMs);
	AIJobLoadAndDeliver.getPricePerMs = Utils.overwrittenFunction(AIJobLoadAndDeliver.getPricePerMs, AIJobLoadAndDeliver.getPricePerMs);	
	function AIJob:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs;  --! default 0.0004 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
	function AIJobFieldWork:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs;  --! default 0.0005 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
	function AIJobDeliver:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs;  --! default 0.0004 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
	function AIJobGoTo:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs;  --! default 0.0004 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
	function AIJobLoadAndDeliver:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs;  --! default 0.0004 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
	function AIJobConveyor:getPricePerMs(superFunc)
		return AICost.reduce.jobPricePerMs/1.5;  --! default 0.00005 ! --> * difficulty (0.4,0.7,1)<-- 
	end;
end;

if AICost.reduce.purchaseConsumable then
	EconomyManager.getCostPerLiter = Utils.overwrittenFunction(EconomyManager.getCostPerLiter, EconomyManager.getCostPerLiter);
	function EconomyManager:getCostPerLiter(superFunc, ...)
	   return AICost.reduce.purchaseConsumableCostPerLiter; --> * damage * difficulty (3,1.8,1) <--
	end;
end;
addModEventListener(AICost);