EmploymentSystem = {}
local employmentSystem_mt = Class(EmploymentSystem)

table.insert(FinanceStats.statNames, "employmentIncome")
FinanceStats.statNameToIndex["employmentIncome"] = #FinanceStats.statNames

EmploymentSystem.DISTANCE_UPDATE_TICKS = 200


EmploymentSystem.CONFIG_FILENAME_TO_BUSINESS_TYPE = {
    ["tailorUS"] = "Tailor",
    ["tailorShop"] = "Tailor",
    ["tailor"] = "Tailor",
    ["cannedPackagedFactoryUS"] = "Canned Goods Factory",
    ["preservedFoodFactory"] = "Canned Goods Factory",
    ["cannedPackagedFactoryAS"] = "Canned Goods Factory",
    ["carpenterUS"] = "Carpenter",
    ["carpenterAS"] = "Carpenter",
    ["carpenter"] = "Carpenter",
    ["carpentry"] = "Carpenter",
    ["cementFactoryUS"] = "Cement Factory",
    ["cementFactory"] = "Cement Factory",
    ["cooperUS"] = "Cooper",
    ["dairyUS"] = "Dairy",
    ["dairyAS"] = "Dairy",
    ["dairy"] = "Dairy",
    ["laiterie"] = "Dairy",
    ["sellingStationRestaurant"] = "Restaurant",
    ["bakeryUS"] = "Bakery",
    ["bakeryAS"] = "Bakery",
    ["bakery"] = "Bakery",
    ["dredgingBoat"] = "Dredger",
    ["grainFlourMillUS"] = "Grain Mill",
    ["grainFlourMillAS"] = "Grain Mill",
    ["moulins"] = "Grain Mill",
    ["grainMill"] = "Grain Mill",
    ["oilPlantUS"] = "Oil Plant",
    ["oilPlantAS"] = "Oil Plant",
    ["paperMill"] = "Paper Mill",
    ["playgroundMakerHall"] = "Toy Maker",
    ["ropeMakerUS"] = "Ropery",
    ["sawmillUS"] = "Sawmill",
    ["sawmillAS"] = "Sawmill",
    ["sawmill"] = "Sawmill",
    ["sellingStationWood"] = "Sawmill",
    ["gasStation01"] = "Petrol Station",
    ["gasStation"] = "Petrol Station",
    ["sellingStationAnimalTrader"] = "Livestock Trader",
    ["animalTraderBarn01"] = "Livestock Trader",
    ["animalTraderBarn02"] = "Livestock Trader",
    ["animalTrader"] = "Livestock Trader",
    ["livestockMarket"] = "Livestock Trader",
    ["bga1mw_mixers"] = "Biogas Plant",
    ["bga99kw"] = "Biogas Plant",
    ["bga250kw"] = "Biogas Plant",
    ["bga500kw"] = "Biogas Plant",
    ["warehouseLogisticUS"] = "Warehouse",
    ["warehouseEU"] = "Warehouse",
    ["warehouseAS"] = "Warehouse",
    ["potatoProcessingPlant"] = "Potato Processing Plant",
    ["groceryStore"] = "Supermarket",
    ["cooperativeVosges"] = "Supermarket",
    ["cooperativeSoufflet"] = "Supermarket",
    ["generalStore"] = "Supermarket",
    ["sugarMillAS"] = "Sugar Mill"
}


EmploymentSystem.BUSINESS_TYPE_TO_BUSINESS = {
    ["Tailor"] = {
        ["title"] = "Tailor",
        ["translationKey"] = "tailor",
        ["prosperity"] = 1.2,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 12
        }
    },
    ["Ropery"] = {
        ["title"] = "Ropery",
        ["translationKey"] = "ropery",
        ["prosperity"] = 1.08,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 22,
            [5] = 12
        }
    },
    ["Dairy"] = {
        ["title"] = "Dairy",
        ["translationKey"] = "dairy",
        ["prosperity"] = 0.9,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 5,
            [4] = 6
        }
    },
    ["Sawmill"] = {
        ["title"] = "Sawmill",
        ["translationKey"] = "sawmill",
        ["prosperity"] = 1.01,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 18,
            [4] = 19
        }
    },
    ["Grain Mill"] = {
        ["title"] = "Grain Mill",
        ["translationKey"] = "grain_mill",
        ["prosperity"] = 1.05,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 18,
            [4] = 19
        }
    },
    ["Paper Mill"] = {
        ["title"] = "Paper Mill",
        ["translationKey"] = "paper_mill",
        ["prosperity"] = 1.075,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 18,
            [4] = 19
        }
    },
    ["Canned Goods Factory"] = {
        ["title"] = "Canned Goods Factory",
        ["translationKey"] = "canned_goods_factory",
        ["prosperity"] = 0.97,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 5,
            [4] = 6
        }
    },
    ["Toy Maker"] = {
        ["title"] = "Toy Maker",
        ["translationKey"] = "toy_maker",
        ["prosperity"] = 1.07,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 25
        }
    },
    ["Carpenter"] = {
        ["title"] = "Carpenter",
        ["translationKey"] = "carpenter",
        ["prosperity"] = 1.05,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 7,
            [4] = 8,
            [5] = 12
        }
    },
    ["Cement Factory"] = {
        ["title"] = "Cement Factory",
        ["translationKey"] = "cement_factory",
        ["prosperity"] = 0.92,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 5,
            [4] = 6
        }
    },
    ["Restaurant"] = {
        ["title"] = "Restaurant",
        ["translationKey"] = "restaurant",
        ["prosperity"] = 1.5,
        ["jobs"] = {
            [1] = 1,
            [2] = 9,
            [3] = 11,
            [4] = 10,
            [5] = 12,
            [6] = 13
        }
    },
    ["Cooper"] = {
        ["title"] = "Cooper",
        ["translationKey"] = "cooper",
        ["prosperity"] = 1.03,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 7,
            [4] = 8,
            [5] = 12
        }
    },
    ["Bakery"] = {
        ["title"] = "Bakery",
        ["translationKey"] = "bakery",
        ["prosperity"] = 1.08,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 15,
            [5] = 12
        }
    },
    ["Dredger"] = {
        ["title"] = "Dredger",
        ["translationKey"] = "dredger",
        ["prosperity"] = 0.8,
        ["jobs"] = {
            [1] = 16,
            [2] = 17,
            [3] = 12
        }
    },
    ["Oil Plant"] = {
        ["title"] = "Oil Plant",
        ["translationKey"] = "oil_plant",
        ["prosperity"] = 1.17,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 20,
            [4] = 21
        }
    },
    ["Petrol Station"] = {
        ["title"] = "Petrol Station",
        ["translationKey"] = "petrol_station",
        ["prosperity"] = 1.24,
        ["jobs"] = {
            [1] = 1,
            [2] = 24,
            [3] = 3,
            [4] = 23,
            [5] = 12
        }
    },
    ["Livestock Trader"] = {
        ["title"] = "Livestock Trader",
        ["translationKey"] = "livestock_trader",
        ["prosperity"] = 1.3,
        ["jobs"] = {
            [1] = 1,
            [2] = 28,
            [3] = 27,
            [4] = 26
        }
    },
    ["Biogas Plant"] = {
        ["title"] = "Biogas Plant",
        ["translationKey"] = "biogas_plant",
        ["prosperity"] = 1.38,
        ["jobs"] = {
            [1] = 1,
            [2] = 29,
            [3] = 30,
            [4] = 31
        }
    },
    ["Warehouse"] = {
        ["title"] = "Warehouse",
        ["translationKey"] = "warehouse",
        ["prosperity"] = 0.98,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 23,
            [4] = 32,
            [5] = 34,
            [6] = 33,
            [7] = 35
        }
    },
    ["Potato Processing Plant"] = {
        ["title"] = "Potato Processing Plant",
        ["translationKey"] = "potato_processing_plant",
        ["prosperity"] = 1.14,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 5,
            [4] = 6,
            [5] = 35
        }
    },
    ["Supermarket"] = {
        ["title"] = "Supermarket",
        ["translationKey"] = "supermarket",
        ["prosperity"] = 1.34,
        ["jobs"] = {
            [1] = 1,
            [2] = 3,
            [3] = 23,
            [4] = 12,
            [5] = 13
        }
    },
    ["Sugar Mill"] = {
        ["title"] = "Sugar Mill",
        ["translationKey"] = "sugar_mill",
        ["prosperity"] = 1.09,
        ["jobs"] = {
            [1] = 1,
            [2] = 2,
            [3] = 18,
            [4] = 19
        }
    }
}


EmploymentSystem.JOB_INDEX_TO_JOB = {
    [1] = {
        ["index"] = 1,
        ["title"] = "Cleaner",
        ["translationKey"] = "cleaner",
        ["baseSalary"] = 9250,
        ["education"] = 0,
        ["hours"] = 10,
        ["experience"] = 0,
        ["subPromotionIndex"] = 1,
        ["partTimeAvailable"] = true
    },
    [2] = {
        ["index"] = 2,
        ["title"] = "Intern",
        ["translationKey"] = "intern",
        ["baseSalary"] = 13000,
        ["education"] = 1,
        ["hours"] = 8,
        ["experience"] = 1,
        ["subPromotionIndex"] = 0
    },
    [3] = {
        ["index"] = 3,
        ["title"] = "Cashier",
        ["translationKey"] = "cashier",
        ["baseSalary"] = 18500,
        ["education"] = 1,
        ["hours"] = 8,
        ["experience"] = 2,
        ["subPromotionIndex"] = 2,
        ["partTimeAvailable"] = true
    },
    [4] = {
        ["index"] = 4,
        ["title"] = "Tailor",
        ["translationKey"] = "tailor",
        ["baseSalary"] = 35000,
        ["education"] = 2,
        ["hours"] = 6,
        ["experience"] = 3,
        ["subPromotionIndex"] = 1
    },
    [5] = {
        ["index"] = 5,
        ["title"] = "Factory Worker",
        ["translationKey"] = "factory_worker",
        ["baseSalary"] = 24000,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 3,
        ["subPromotionIndex"] = 0
    },
    [6] = {
        ["index"] = 6,
        ["title"] = "Factory Supervisor",
        ["translationKey"] = "factory_supervisor",
        ["baseSalary"] = 38000,
        ["education"] = 2,
        ["hours"] = 8,
        ["experience"] = 5,
        ["subPromotionIndex"] = 2
    },
    [7] = {
        ["index"] = 7,
        ["title"] = "Labourer",
        ["translationKey"] = "labourer",
        ["baseSalary"] = 21000,
        ["education"] = 0,
        ["hours"] = 10,
        ["experience"] = 2,
        ["subPromotionIndex"] = 0,
        ["partTimeAvailable"] = true
    },
    [8] = {
        ["index"] = 8,
        ["title"] = "Carpenter",
        ["translationKey"] = "carpenter",
        ["baseSalary"] = 35000,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 5,
        ["subPromotionIndex"] = 1
    },
    [9] = {
        ["index"] = 9,
        ["title"] = "Waiter",
        ["translationKey"] = "waiter",
        ["baseSalary"] = 24000,
        ["education"] = 1,
        ["hours"] = 6,
        ["experience"] = 1,
        ["subPromotionIndex"] = 1,
        ["partTimeAvailable"] = true
    },
    [10] = {
        ["index"] = 10,
        ["title"] = "Chef",
        ["translationKey"] = "chef",
        ["baseSalary"] = 52000,
        ["education"] = 3,
        ["hours"] = 6,
        ["experience"] = 5,
        ["subPromotionIndex"] = 2
    },
    [11] = {
        ["index"] = 11,
        ["title"] = "Doorman",
        ["translationKey"] = "doorman",
        ["baseSalary"] = 35000,
        ["education"] = 2,
        ["hours"] = 6,
        ["experience"] = 3,
        ["subPromotionIndex"] = 0
    },
    [12] = {
        ["index"] = 12,
        ["title"] = "Manager",
        ["translationKey"] = "manager",
        ["baseSalary"] = 62500,
        ["education"] = 4,
        ["hours"] = 6,
        ["experience"] = 8,
        ["subPromotionIndex"] = 0
    },
    [13] = {
        ["index"] = 13,
        ["title"] = "Executive",
        ["translationKey"] = "executive",
        ["baseSalary"] = 125000,
        ["education"] = 5,
        ["hours"] = 6,
        ["experience"] = 15,
        ["subPromotionIndex"] = 3,
        ["baseSeniority"] = 1
    },
    [14] = {
        ["index"] = 14,
        ["title"] = "Cooper",
        ["translationKey"] = "cooper",
        ["baseSalary"] = 32500,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 5,
        ["subPromotionIndex"] = 1
    },
    [15] = {
        ["index"] = 15,
        ["title"] = "Baker",
        ["translationKey"] = "baker",
        ["baseSalary"] = 35000,
        ["education"] = 2,
        ["hours"] = 8,
        ["experience"] = 3,
        ["subPromotionIndex"] = 1
    },
    [16] = {
        ["index"] = 16,
        ["title"] = "Dredger",
        ["translationKey"] = "dredger",
        ["baseSalary"] = 28000,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 1,
        ["subPromotionIndex"] = 2
    },
    [17] = {
        ["index"] = 17,
        ["title"] = "Surveyor",
        ["translationKey"] = "surveyor",
        ["baseSalary"] = 45000,
        ["education"] = 3,
        ["hours"] = 6,
        ["experience"] = 4,
        ["subPromotionIndex"] = 1
    },
    [18] = {
        ["index"] = 18,
        ["title"] = "Miller",
        ["translationKey"] = "miller",
        ["baseSalary"] = 29500,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 2,
        ["subPromotionIndex"] = 0
    },
    [19] = {
        ["index"] = 19,
        ["title"] = "Mill Supervisor",
        ["translationKey"] = "mill_supervisor",
        ["baseSalary"] = 40000,
        ["education"] = 2,
        ["hours"] = 10,
        ["experience"] = 4,
        ["subPromotionIndex"] = 0
    },
    [20] = {
        ["index"] = 20,
        ["title"] = "Oil Processor",
        ["translationKey"] = "oil_processor",
        ["baseSalary"] = 35000,
        ["education"] = 1,
        ["hours"] = 12,
        ["experience"] = 2,
        ["subPromotionIndex"] = 0
    },
    [21] = {
        ["index"] = 21,
        ["title"] = "Oil Plant Supervisor",
        ["translationKey"] = "oil_plant_supervisor",
        ["baseSalary"] = 47500,
        ["education"] = 2,
        ["hours"] = 10,
        ["experience"] = 4,
        ["subPromotionIndex"] = 0
    },
    [22] = {
        ["index"] = 22,
        ["title"] = "Roper",
        ["translationKey"] = "roper",
        ["baseSalary"] = 33500,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 3,
        ["subPromotionIndex"] = 1
    },
    [23] = {
        ["index"] = 23,
        ["title"] = "Warehouse Operative",
        ["translationKey"] = "warehouse_operative",
        ["baseSalary"] = 25000,
        ["education"] = 1,
        ["hours"] = 8,
        ["experience"] = 2,
        ["subPromotionIndex"] = 1
    },
    [24] = {
        ["index"] = 24,
        ["title"] = "Refueler",
        ["translationKey"] = "refueler",
        ["baseSalary"] = 15000,
        ["education"] = 1,
        ["hours"] = 8,
        ["experience"] = 1,
        ["subPromotionIndex"] = 2
    },
    [25] = {
        ["index"] = 25,
        ["title"] = "Toy Maker",
        ["translationKey"] = "toy_maker",
        ["baseSalary"] = 48000,
        ["education"] = 3,
        ["hours"] = 7,
        ["experience"] = 4,
        ["subPromotionIndex"] = 1
    },
    [26] = {
        ["index"] = 26,
        ["title"] = "Herdsman",
        ["translationKey"] = "herdsman",
        ["baseSalary"] = 42500,
        ["education"] = 2,
        ["hours"] = 6,
        ["experience"] = 8,
        ["subPromotionIndex"] = 1
    },
    [27] = {
        ["index"] = 27,
        ["title"] = "Feedman",
        ["translationKey"] = "feedman",
        ["baseSalary"] = 34000,
        ["education"] = 1,
        ["hours"] = 10,
        ["experience"] = 5,
        ["subPromotionIndex"] = 0
    },
    [28] = {
        ["index"] = 28,
        ["title"] = "Livestock Trader",
        ["translationKey"] = "livestock_trader",
        ["baseSalary"] = 27500,
        ["education"] = 1,
        ["hours"] = 8,
        ["experience"] = 2,
        ["subPromotionIndex"] = 0
    },
    [29] = {
        ["index"] = 29,
        ["title"] = "Plant Engineer",
        ["translationKey"] = "plant_engineer",
        ["baseSalary"] = 78000,
        ["education"] = 5,
        ["hours"] = 8,
        ["experience"] = 7,
        ["subPromotionIndex"] = 3,
        ["baseSeniority"] = 1
    },
    [30] = {
        ["index"] = 30,
        ["title"] = "Plant Biochemist",
        ["translationKey"] = "plant_biochemist",
        ["baseSalary"] = 95000,
        ["education"] = 6,
        ["hours"] = 8,
        ["experience"] = 9,
        ["subPromotionIndex"] = 2
    },
    [31] = {
        ["index"] = 31,
        ["title"] = "Site Leader",
        ["translationKey"] = "site_leader",
        ["baseSalary"] = 125000,
        ["education"] = 5,
        ["hours"] = 6,
        ["experience"] = 14,
        ["subPromotionIndex"] = 0
    },
    [32] = {
        ["index"] = 32,
        ["title"] = "Safety Officer",
        ["translationKey"] = "safety_officer",
        ["baseSalary"] = 32000,
        ["education"] = 2,
        ["hours"] = 8,
        ["experience"] = 3,
        ["subPromotionIndex"] = 3,
        ["baseSeniority"] = 1
    },
    [33] = {
        ["index"] = 33,
        ["title"] = "Warehouse Supervisor",
        ["translationKey"] = "warehouse_supervisor",
        ["baseSalary"] = 52500,
        ["education"] = 3,
        ["hours"] = 6,
        ["experience"] = 5,
        ["subPromotionIndex"] = 2
    },
    [34] = {
        ["index"] = 34,
        ["title"] = "On-Site Engineer",
        ["translationKey"] = "on_site_engineer",
        ["baseSalary"] = 41000,
        ["education"] = 2,
        ["hours"] = 8,
        ["experience"] = 5,
        ["subPromotionIndex"] = 0
    },
    [35] = {
        ["index"] = 35,
        ["title"] = "Logistics Manager",
        ["translationKey"] = "logistics_manager",
        ["baseSalary"] = 85000,
        ["education"] = 4,
        ["hours"] = 6,
        ["experience"] = 10,
        ["subPromotionIndex"] = 0
    }
}


EmploymentSystem.SUB_PROMOTION_INDEX_TO_SUB_PROMOTIONS = {
    [1] = {
        [1] = {
            ["title"] = "Senior",
            ["translationKey"] = "senior"
        },
        [2] = {
            ["title"] = "Head",
            ["translationKey"] = "head"
        }
    },
    [2] = {
        [1] = {
            ["title"] = "Lead",
            ["translationKey"] = "lead"
        }
    },
    [3] = {
        [1] = {
            ["title"] = "Junior",
            ["translationKey"] = "junior"
        },
        [2] = {
            ["title"] = "Chief",
            ["translationKey"] = "chief"
        }
    }
}


EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION = {
    [0] = {
        ["title"] = "None",
        ["translationKey"] = "none",
        ["difficulty"] = 0,
        ["hours"] = 0
    },
    [1] = {
        ["title"] = "High School",
        ["translationKey"] = "high_school",
        ["difficulty"] = 0.2,
        ["hours"] = 60
    },
    [2] = {
        ["title"] = "College",
        ["translationKey"] = "college",
        ["difficulty"] = 0.46,
        ["hours"] = 175
    },
    [3] = {
        ["title"] = "Foundation Degree",
        ["translationKey"] = "foundation_degree",
        ["difficulty"] = 0.6,
        ["hours"] = 200
    },
    [4] = {
        ["title"] = "Bachelor's Degree",
        ["translationKey"] = "bachelor_degree",
        ["difficulty"] = 0.76,
        ["hours"] = 300
    },
    [5] = {
        ["title"] = "Master's Degree",
        ["translationKey"] = "master_degree",
        ["difficulty"] = 0.91,
        ["hours"] = 500
    },
    [6] = {
        ["title"] = "Doctorate",
        ["translationKey"] = "doctorate",
        ["difficulty"] = 0.99,
        ["hours"] = 750
    }
}


local function nilCallback() end


function EmploymentSystem.loadMap()
    removeModEventListener(EmploymentSystem)
    g_currentMission.employmentSystem = EmploymentSystem.new()
    g_currentMission.employmentSystem:loadFromXMLFile()
    g_currentMission.employmentSystem:initTranslations()
end


addModEventListener(EmploymentSystem)


function EmploymentSystem.new()

    local self = setmetatable({}, employmentSystem_mt)

    self.mission = g_currentMission
    self.eventId = Employment_PlayerInputComponent.EmploymentEventId
    self.educationEventId = Employment_PlayerInputComponent.EducationEventId
    self.isShowingInput = false
    self.isShowingEducationInput = false
    self.callbackPlaceable = nil
    self.callbackPlayer = nil
    self.players = {}
    self.isPlayerWorking = false
    self.isPlayerWorkingPartTime = false
    self.isPlayerStudying = false
    self.isPlayerTakingExam = false
    self.currentWork = nil
    self.currentStudy = nil
    self.currentExam = nil
    self.month = 1
    self.year = 1
    self.updateables = {}
    self.distanceUpdateTicks = EmploymentSystem.DISTANCE_UPDATE_TICKS - 1
    g_currentMission:addUpdateable(self)

    MoneyType.EMPLOYMENT_INCOME = MoneyType.register("employmentIncome", "employment_ui_employmentIncome")
    MoneyType.LAST_ID = MoneyType.LAST_ID + 1

    g_messageCenter:subscribe(MessageType.SLEEPING, self.onSleep, self)
    g_messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.onPeriodChanged, self)
    g_messageCenter:subscribe(MessageType.YEAR_CHANGED, self.onYearChanged, self)

    return self

end


function EmploymentSystem:delete()
    self = nil
end


function EmploymentSystem:initTranslations()

    for _, businessType in pairs(EmploymentSystem.BUSINESS_TYPE_TO_BUSINESS) do businessType.title = g_i18n:getText("employment_business_" .. businessType.translationKey) end

    for _, jobType in ipairs(EmploymentSystem.JOB_INDEX_TO_JOB) do jobType.title = g_i18n:getText("employment_job_" .. jobType.translationKey) end

    for _, educationType in ipairs(EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION) do educationType.title = g_i18n:getText("employment_education_" .. educationType.translationKey) end

    for _, subPromotionTypes in ipairs(EmploymentSystem.SUB_PROMOTION_INDEX_TO_SUB_PROMOTIONS) do
        for _, subPromotionType in ipairs(subPromotionTypes) do subPromotionType.title = g_i18n:getText("employment_subpromotion_" .. subPromotionType.translationKey) end
    end

end


function EmploymentSystem:update(_)

    if self.distanceUpdateTicks >= EmploymentSystem.DISTANCE_UPDATE_TICKS then

        self.distanceUpdateTicks = 0

        local state = g_localPlayer.stateMachine.currentState
        local isInVehicle = state.getIsInVehicle ~= nil and state:getIsInVehicle() or false

        if not isInVehicle then

            for _, placeable in pairs(self.updateables) do
                placeable:updateDistance()
            end

        else

            self.isShowingInput = false
            --self:setCallbackPlaceable(nil)
            --self:setCallbackPlayer(nil)
            --g_inputBinding:setActionEventTextVisibility(self.eventId, false)

        end

    end

    self.distanceUpdateTicks = self.distanceUpdateTicks + 1

end


function EmploymentSystem:loadFromXMLFile()

    local savegameIndex = g_careerScreen.savegameList.selectedIndex
    local savegame = g_savegameController:getSavegame(savegameIndex)

    if savegame == nil or savegame.savegameDirectory == nil then return end

    local path = savegame.savegameDirectory .. "/employment.xml"

    local xmlFile = XMLFile.loadIfExists("employmentXML", path)
    if xmlFile == nil then return end

    local key = "employment"

    self.month = xmlFile:getInt(key .. "#month", 1)
    self.year = xmlFile:getInt(key .. "#year", 1)

    xmlFile:iterate(key .. ".players.player", function (_, playerKey)
        local id = xmlFile:getString(playerKey .. "#userId", nil)
        if id ~= nil then

            local player = {
                userId = id,
                education = xmlFile:getInt(playerKey .. "#education", 0),
                educationProgress = xmlFile:getFloat(playerKey .. "#educationProgress", 0),
                experience = xmlFile:getFloat(playerKey .. "#experience", 0)
            }

            local nextExamDay, nextExamTime = xmlFile:getInt(playerKey .. "#nextExamDay", nil), xmlFile:getInt(playerKey .. "#nextExamTime", nil)
            if nextExamDay ~= nil and nextExamTime ~= nil then
                player.nextExamDay = nextExamDay
                player.nextExamTime = nextExamTime
            end

            if xmlFile:hasProperty(playerKey .. ".job") then
                local job = {
                    index = xmlFile:getInt(playerKey .. ".job#index", 1),
                    seniority = xmlFile:getInt(playerKey .. ".job#seniority", 0),
                    placeableId = xmlFile:getString(playerKey .. ".job#placeableId", "1"),
                    salary = xmlFile:getFloat(playerKey .. ".job#salary", 10000),
                    workedHours = xmlFile:getFloat(playerKey .. ".job#workedHours", 0),
                    startMonth = xmlFile:getInt(playerKey .. ".job#startMonth", 1),
                    startYear = xmlFile:getInt(playerKey .. ".job#startYear", 1),
                    actionCooldown = xmlFile:getInt(playerKey .. ".job#actionCooldown", 0)
                }

                player.job = job
            end

            self.players[id] = player

        end
    end)

end


function EmploymentSystem:saveToXMLFile(path)

    if path == nil then return end

    local xmlFile = XMLFile.create("employmentXML", path, "employment")
    if xmlFile == nil then return end

    local key = "employment"

    xmlFile:setInt(key .. "#month", self.month or 1)
    xmlFile:setInt(key .. "#year", self.year or 1)

    xmlFile:setTable(key .. ".players.player", self.players, function (playerKey, player)

        xmlFile:setString(playerKey .. "#userId", player.userId)
        xmlFile:setInt(playerKey .. "#education", player.education or 0)
        xmlFile:setFloat(playerKey .. "#educationProgress", player.educationProgress or 0)
        xmlFile:setFloat(playerKey .. "#experience", player.experience or 0)

        if player.nextExamDay ~= nil and player.nextExamTime ~= nil then
            xmlFile:setInt(playerKey .. "#nextExamDay", player.nextExamDay)
            xmlFile:setInt(playerKey .. "#nextExamTime", player.nextExamTime)
        end

        if player.job ~= nil then
            xmlFile:setInt(playerKey .. ".job#index", player.job.index)
            xmlFile:setInt(playerKey .. ".job#seniority", player.job.seniority)
            xmlFile:setFloat(playerKey .. ".job#salary", player.job.salary)
            xmlFile:setString(playerKey .. ".job#placeableId", player.job.placeableId)
            xmlFile:setFloat(playerKey .. ".job#workedHours", player.job.workedHours)
            xmlFile:setInt(playerKey .. ".job#startMonth", player.job.startMonth)
            xmlFile:setInt(playerKey .. ".job#startYear", player.job.startYear)
            xmlFile:setInt(playerKey .. ".job#actionCooldown", player.job.actionCooldown or 0)
        end

    end)

    xmlFile:save(false, true)

end


function EmploymentSystem.inputCallback()

    local employmentSystem = g_currentMission.employmentSystem

    if not employmentSystem.isShowingInput then return end

    local placeable = employmentSystem:getCallbackPlaceable()
    local player = employmentSystem:getCallbackPlayer()

    EmploymentDialog.show(placeable, player)

end


function EmploymentSystem.educationInputCallback()

    local employmentSystem = g_currentMission.employmentSystem

    if not employmentSystem.isShowingEducationInput then return end

    local player = employmentSystem:getCallbackPlayer()

    EducationDialog.show(player)

end


function EmploymentSystem:setCallbackPlaceable(placeable)
    self.callbackPlaceable = placeable
end


function EmploymentSystem:getCallbackPlaceable()
    return self.callbackPlaceable
end


function EmploymentSystem:setCallbackPlayer(player)
    self.callbackPlayer = player
end


function EmploymentSystem:getCallbackPlayer()
    return self.callbackPlayer
end


function EmploymentSystem:addPlayer(id)
    if id ~= nil and self.players[id] == nil then self.players[id] = { userId = id, education = 0, educationProgress = 0, experience = 0 } end
    return self.players[id]
end


function EmploymentSystem:getPlayer(id)
    return self.players[id] or self:addPlayer(id)
end


function EmploymentSystem:addPlayerJob(id, job)
    if self.players[id] == nil then self:addPlayer(id) end

    self.players[id].job = job
end


function EmploymentSystem:quitJob(id)

    if self.players[id] == nil then self:addPlayer(id) end

    self:paySalary(id)
    local placeable = self:getCallbackPlaceable()
    if placeable ~= nil and placeable.spec_employer ~= nil then placeable:quitJob() end

    self.players[id].job = nil

end


function EmploymentSystem:openWorkHoursDialog(id, callback, action, partTimeSalary, requiredHours)

    local player = self:getPlayer(id)

    WorkHoursDialog.show(player, callback, action, partTimeSalary, requiredHours)

end


function EmploymentSystem:work(id, targetTime, callback)

    local player = self.players[id]

    if player == nil then
        self:addPlayer(id)
        return
    end

    local job = player.job
    if job == nil then return end

    local currentTime = g_currentMission.environment:getMinuteOfDay() / 60
    targetTime = currentTime + (targetTime or EmploymentSystem.JOB_INDEX_TO_JOB[job.index].hours)

    self.isPlayerWorking = true
    self.currentWork = { userId = id, callback = callback or nilCallback, startHour = currentTime, startDay = g_currentMission.environment.currentMonotonicDay }
    g_sleepManager:startSleep(targetTime)

end


function EmploymentSystem:workPartTime(id, targetTime, callback, partTimeSalary, requiredHours)

    local player = self:getPlayer(id)

    if player == nil then return end

    local currentTime = g_currentMission.environment:getMinuteOfDay() / 60
    targetTime = currentTime + (targetTime or 4)

    self.isPlayerWorkingPartTime = true
    self.currentWork = { userId = id, callback = callback or nilCallback, startHour = currentTime, startDay = g_currentMission.environment.currentMonotonicDay, partTimeSalary = partTimeSalary, requiredHours = requiredHours }
    g_sleepManager:startSleep(targetTime)

end


function EmploymentSystem:study(id, targetTime, callback)

    local player = self:getPlayer(id)

    if player == nil then return end

    local currentTime = g_currentMission.environment:getMinuteOfDay() / 60
    targetTime = currentTime + (targetTime or 3)

    self.isPlayerStudying = true
    self.currentStudy = { userId = id, callback = callback or nilCallback, startHour = currentTime, startDay = g_currentMission.environment.currentMonotonicDay }
    g_sleepManager:startSleep(targetTime)

end


function EmploymentSystem:startExam(id, callback)

    local player = self:getPlayer(id)

    if player == nil then return end

    local currentTime = g_currentMission.environment:getMinuteOfDay() / 60

    self.isPlayerTakingExam = true
    self.currentExam = { userId = id, callback = callback or nilCallback }
    g_sleepManager:startSleep(currentTime + 3)

end


function EmploymentSystem:onSleep(isStart)

    if isStart or (not self.isPlayerWorking and not self.isPlayerWorkingPartTime and self.currentWork == nil and not self.isPlayerStudying and self.currentStudy == nil and not self.isPlayerTakingExam and self.currentExam == nil) then return end

    if self.isPlayerWorking then

        self.isPlayerWorking = false

        local currentWork = self.currentWork

        local player = self.players[currentWork.userId]

        if player == nil then
            currentWork.callback()
            self.currentWork = nil
            return
        end

        local job = player.job
        local startHour = currentWork.startHour
        local startDay = currentWork.startDay
        local endHour = g_currentMission.environment:getMinuteOfDay() / 60
        local endDay = g_currentMission.environment.currentMonotonicDay

        if endDay > startDay then endHour = endHour + (endDay - startDay) * 24 end

        job.workedHours = math.max(job.workedHours + endHour - startHour, job.workedHours)

        currentWork.callback()
        self.currentWork = nil

    elseif self.isPlayerWorkingPartTime then

        self.isPlayerWorkingPartTime = false

        local currentWork = self.currentWork

        --local player = self.players[currentWork.userId]

        --if player == nil then
            --currentWork.callback()
            --self.currentWork = nil
            --return
        --end

        local partTimeSalary = currentWork.partTimeSalary or 0
        local requiredHours = currentWork.requiredHours or 10
        local startHour = currentWork.startHour
        local startDay = currentWork.startDay
        local endHour = g_currentMission.environment:getMinuteOfDay() / 60
        local endDay = g_currentMission.environment.currentMonotonicDay

        if endDay > startDay then endHour = endHour + (endDay - startDay) * 24 end

        --local hoursPerMonth = (g_currentMission.daysPerPeriod or 1) * 24

        --player.experience = player.experience + ((endHour - startHour) / hoursPerMonth) / 12

        local farm = g_farmManager:getFarmForUniqueUserId(currentWork.userId)

        local totalPay = (partTimeSalary / 12) * ((endHour - startHour) / requiredHours)

        g_currentMission:addMoneyChange(totalPay, farm:getId(), MoneyType.EMPLOYMENT_INCOME, true)
        farm:changeBalance(totalPay, MoneyType.EMPLOYMENT_INCOME)

        currentWork.callback()
        self.currentWork = nil

    elseif self.isPlayerStudying then

        self.isPlayerStudying = false

        local currentStudy = self.currentStudy

        local player = self.players[currentStudy.userId]

        if player == nil then
            currentStudy.callback()
            self.currentStudy = nil
            return
        end

        local startHour = currentStudy.startHour
        local startDay = currentStudy.startDay
        local endHour = g_currentMission.environment:getMinuteOfDay() / 60
        local endDay = g_currentMission.environment.currentMonotonicDay

        if endDay > startDay then endHour = endHour + (endDay - startDay) * 24 end

        local totalHours = endHour - startHour
        player.educationProgress = player.educationProgress + totalHours

        currentStudy.callback()
        self.currentStudy = nil

    elseif self.isPlayerTakingExam then

        self.isPlayerTakingExam = false

        local currentExam= self.currentExam

        local player = self.players[currentExam.userId]

        if player == nil then
            currentExam.callback()
            self.currentExam = nil
            return
        end

        local nextEducation = EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[player.education + 1]
        local success = false

        if nextEducation ~= nil then

            if math.random() >= nextEducation.difficulty then
                player.education = player.education + 1
                player.educationProgress = 0
                success = true
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, g_i18n:getText("employment_ui_exam_pass"))

            else
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, g_i18n:getText("employment_ui_exam_fail"))
            end

        end

        if not success then

            player.nextExamDay = g_currentMission.environment.currentMonotonicDay + 1
            player.nextExamTime = g_currentMission.environment:getMinuteOfDay()

        end

        currentExam.callback(success)
        self.currentExam = nil

    end

end


function EmploymentSystem:onPeriodChanged()

    self.month = self.month == 12 and 1 or (self.month + 1)
    local placeableSystem = g_currentMission.placeableSystem

    for playerId, player in pairs(self.players) do

        if player.job == nil then continue end

        local job = player.job

        if self.isPlayerWorking and self.currentWork ~= nil then

            job.workedHours = job.workedHours + 24 - self.currentWork.startHour
            self.currentWork.startHour = 0
            self.currentWork.startDay = g_currentMission.environment.currentMonotonicDay

        end

        player.experience = player.experience + 1 / 12

        self:paySalary(playerId)

        local placeable = placeableSystem:getPlaceableByUniqueId(job.placeableId)

        if placeable ~= nil and placeable.spec_employer ~= nil then

            placeable:updateJob(player)

        end

        if job ~= nil then job.workedHours = 0 end

    end

end


function EmploymentSystem:onYearChanged()

    self.year = self.year + 1

end


function EmploymentSystem:getCurrentMonth()
    return self.month
end


function EmploymentSystem:getCurrentYear()
    return self.year
end


function EmploymentSystem:paySalary(id)

    if self.players[id] == nil or self.players[id].job == nil then return end

    local job = self.players[id].job

    if job.workedHours == 0 then return end

    local basePay = job.salary / 12

    --local placeable = g_currentMission.placeableSystem:getPlaceableByUniqueId(job.placeableId)
    --if placeable ~= nil and placeable.spec_employer ~= nil then
        --local prosperity = placeable.spec_employer.prosperity or 1
        --basePay = basePay * 0.6 + basePay * 0.4 * prosperity
    --end

    local farm = g_farmManager:getFarmForUniqueUserId(id)
    local requiredHours = EmploymentSystem.JOB_INDEX_TO_JOB[job.index].hours

    g_currentMission:addMoneyChange(basePay * (job.workedHours / requiredHours), farm:getId(), MoneyType.EMPLOYMENT_INCOME, true)
    farm:changeBalance(basePay * (job.workedHours / requiredHours), MoneyType.EMPLOYMENT_INCOME)

end