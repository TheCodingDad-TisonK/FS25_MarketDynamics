-- Name: RS_createInvoiceDialog
-- Author: DonQuacko
-- Purpose: Create service invoices (manual field no + size, auto pricing per ha or per 1000L for delivering)

RS_createInvoiceDialog = {}
local RS_createInvoiceDialog_mt = Class(RS_createInvoiceDialog, MessageDialog)

function RS_createInvoiceDialog.new(target, custom_mt, i18n)
    local self = MessageDialog.new(target, custom_mt or RS_createInvoiceDialog_mt)

    self.i18n = i18n
    self.callback = nil
    self.invoiceDialog = nil

    self.recipientFarmIds = {}
    self.activities = {}

    -- Fill types for delivery invoices
    self.fillTypeIndices = {}
    self.fillTypeTitles = {}

    -- Default rate suggestions by activity index
    -- Unit depends on activity:
    -- 1..4,6..7 = money per ha
    -- 5 = money per stem (wood felling)
    -- 7,21 = money per bale (bale pressing / bale wrapping)
    -- 8 = money per 1000L (delivering)
    self.activityRatePerUnit = {
        1850, -- plowing
        1500, -- cultivating
        1550, -- seeding (Sähen)
        1350,  -- harrow
        1350,  -- hoeing/harrowing (Hacken/Striegeln)
        3050, -- harvest
        85, -- bale pressing (Ballen pressen)
        1150,  -- wood felling (per stem)
        1450, -- liming
        1450,  -- fertilizing
        1500, -- vehicle/equipment renting (per day)
        0,  -- delivering (/1000L)
        1300,  -- spraying
        1450,  -- mowing
        1250,  -- tedding
        1250,  -- windrowing
        1300,  -- weeding
        1200,  -- rolling
        1500,  -- stone picking
        1350,  -- mulching
        85    -- bale wrapping (per bale)

    }
self.userEditedRate = false
    self.userEditedAmount = false

    return self
end

local function getCurrentFarmId()
    if g_currentMission ~= nil and g_currentMission.getFarmId ~= nil then
        local fid = g_currentMission:getFarmId()
        if fid ~= nil then
            return fid
        end
    end

    if g_farmManager ~= nil and g_currentMission ~= nil then
        local userId = g_currentMission.playerUserId
        if userId ~= nil then
            local farm = g_farmManager:getFarmByUserId(userId)
            if farm ~= nil then
                return farm.farmId
            end
        end
    end

    return 0
end

local function parseNumber(text)
    if text == nil then
        return nil
    end
    text = tostring(text)
    text = string.gsub(text, ",", ".")
    text = string.gsub(text, " ", "")
    if text == "" then
        return nil
    end
    return tonumber(text)
end


local function rsNormalizeAreaToHa(area)
    if area == nil then
        return nil
    end
    area = tonumber(area)
    if area == nil then
        return nil
    end

    -- Heuristic: if it's very large, it's probably m²; if it's small, it's probably already ha
    if area > 1000 then
        return area / 10000
    end
    return area
end

local function rsTry(fn, ...)
    if fn == nil then
        return nil
    end
    local ok, res = pcall(fn, ...)
    if not ok then
        return nil
    end
    return res
end

local function rsGetFieldSizeHa(fieldId)
    if fieldId == nil or fieldId <= 0 then
        return nil
    end


    -- RedTape-style lookup: many maps tie 'field numbers' to farmlands shown in Farmlands screen
    if g_farmlandManager ~= nil and g_farmlandManager.farmlands ~= nil then
        local farmland = g_farmlandManager.farmlands[fieldId]
        if farmland == nil then
            for _, f in pairs(g_farmlandManager.farmlands) do
                if f ~= nil and tonumber(f.id) == fieldId then
                    farmland = f
                    break
                end
            end
        end
        if farmland ~= nil and farmland.field ~= nil and farmland.field.getAreaHa ~= nil then
            local ha = tonumber(farmland.field:getAreaHa())
            if ha ~= nil and ha > 0 then
return ha
            end
        end
    end

    -- 1) FieldUtil (often present and map-agnostic)
    if FieldUtil ~= nil then
        local a = rsTry(FieldUtil.getFieldArea, fieldId)
        local ha = rsNormalizeAreaToHa(a)
        if ha ~= nil and ha > 0 then
return ha
        end
        local a2 = rsTry(FieldUtil.getFieldHa, fieldId)
        local ha2 = rsNormalizeAreaToHa(a2)
        if ha2 ~= nil and ha2 > 0 then
return ha2
        end
    end

    -- 2) Mission fieldGroundSystem (some FS versions / maps)
    if g_currentMission ~= nil and g_currentMission.fieldGroundSystem ~= nil then
        local fgs = g_currentMission.fieldGroundSystem
        local a = rsTry(fgs.getFieldArea, fgs, fieldId)
        local ha = rsNormalizeAreaToHa(a)
        if ha ~= nil and ha > 0 then
return ha
        end

        local field = rsTry(fgs.getFieldById, fgs, fieldId)
        if field ~= nil then
            local ha2 = rsNormalizeAreaToHa(field.area or field.fieldArea or field.totalArea or field.fieldAreaSqm)
            if ha2 ~= nil and ha2 > 0 then
return ha2
            end
        end
    end

    -- 3) FieldManager APIs vary across versions/mods/maps
    if g_fieldManager ~= nil then
        local a = rsTry(g_fieldManager.getFieldArea, g_fieldManager, fieldId)
        local ha = rsNormalizeAreaToHa(a)
        if ha ~= nil and ha > 0 then
return ha
        end

        local field = rsTry(g_fieldManager.getFieldById, g_fieldManager, fieldId)
        if field == nil then
            field = rsTry(g_fieldManager.getField, g_fieldManager, fieldId)
        end
        if field == nil then
            field = rsTry(g_fieldManager.getFieldByIndex, g_fieldManager, fieldId)
        end

        if field ~= nil then
            local ha2 = rsNormalizeAreaToHa(field.fieldArea or field.area or field.totalArea or field.fieldAreaSqm)
            if ha2 ~= nil and ha2 > 0 then
return ha2
            end
            if field.getHa ~= nil then
                local v = tonumber(rsTry(field.getHa, field))
                if v ~= nil and v > 0 then
return v
                end
            end
        end

        if g_fieldManager.fields ~= nil then
            local f = g_fieldManager.fields[fieldId]
            if f == nil then
                -- scan list for matching id
                for _, ff in pairs(g_fieldManager.fields) do
                    local fid = ff and (ff.fieldId or ff.id or ff.fieldNumber or ff.number)
                    if tonumber(fid) == fieldId then
                        f = ff
                        break
                    end
                end
            end
            if f ~= nil then
                local ha3 = rsNormalizeAreaToHa(f.fieldArea or f.area or f.totalArea or f.fieldAreaSqm)
                if ha3 ~= nil and ha3 > 0 then
return ha3
                end
            end
        end
    end

    -- 4) Farmland manager fallback (some maps tie fields to farmlands)
    if g_farmlandManager ~= nil then
        local farmId = rsTry(g_farmlandManager.getFarmlandIdByField, g_farmlandManager, fieldId)
        if farmId ~= nil then
            local farmland = rsTry(g_farmlandManager.getFarmlandById, g_farmlandManager, farmId)
            if farmland ~= nil then
                local ha = rsNormalizeAreaToHa(farmland.area or farmland.totalArea)
                if ha ~= nil and ha > 0 then
return ha
                end
            end
        end
    end

    return nil
end

function RS_createInvoiceDialog:updateAmountSummary()
    if self.netValueText == nil or self.vatValueText == nil or self.interestValueText == nil or self.grossValueText == nil then
        return
    end

    local net = parseNumber(self.amountInput ~= nil and self.amountInput:getText() or nil) or 0
    -- FS money is integer
    net = math.max(0, math.floor(net + 0.5))
    local vatRate = 0.19
    if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings.getVatRate ~= nil then
        vatRate = g_rs_invoiceSettings:getVatRate()
    elseif g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
        local pct = tonumber(g_currentMission.rsInvoiceSettings.rsVatPercent)
        if pct ~= nil then
            vatRate = pct / 100
        end
    end

    local vat = math.floor(net * vatRate + 0.5)
    local interest = 0
    local gross = net + vat + interest

    if g_i18n ~= nil and g_i18n.formatMoney ~= nil then
        self.netValueText:setText(g_i18n:formatMoney(net, 0, true, true))
        self.vatValueText:setText(g_i18n:formatMoney(vat, 0, true, true))
        self.interestValueText:setText(g_i18n:formatMoney(interest, 0, true, true))
        self.grossValueText:setText(g_i18n:formatMoney(gross, 0, true, true))
    else
        self.netValueText:setText(tostring(net))
        self.vatValueText:setText(tostring(vat))
        self.interestValueText:setText(tostring(interest))
        self.grossValueText:setText(tostring(gross))
    end
end

function RS_createInvoiceDialog:isDelivering()
    return (self.activityOption ~= nil and self.activityOption:getState() == 12)
end

function RS_createInvoiceDialog:isBalePressing()
    local s = (self.activityOption ~= nil and self.activityOption:getState()) or 0
    return (s == 7 or s == 21)
end

function RS_createInvoiceDialog:isVehicleRenting()
    return (self.activityOption ~= nil and self.activityOption:getState() == 11)
end

function RS_createInvoiceDialog:isWoodFelling()
    return (self.activityOption ~= nil and self.activityOption:getState() == 8)
end


-- Compatibility helper: FS25 may not expose g_gui:showInfoDialog()
function RS_createInvoiceDialog:showInfo(text)
    if g_gui ~= nil then
        if g_gui.showInfoDialog ~= nil then
            g_gui:showInfoDialog({ text = text })
            return
        end

        if g_gui.showDialog ~= nil then
            local dialog = g_gui:showDialog("InfoDialog")
            if dialog ~= nil and dialog.setText ~= nil then
                dialog:setText(text)
                return
            end
        end
    end

    -- Fallback to console
    Logging.info("[RS] " .. tostring(text))
end

function RS_createInvoiceDialog:onOpen()
    RS_createInvoiceDialog:superClass().onOpen(self)

    self:buildRecipientOptions()
    self:buildActivityOptions()
    self:buildFillTypeOptions()

    if self.fieldNumberInput ~= nil then
        self.fieldNumberInput:setText("")
    end
    if self.sizeInput ~= nil then
        self.sizeInput:setText("")
    end

    self.amountInput:setText("")
    if self.pricePerHaInput ~= nil then
        self.pricePerHaInput:setText("")
    end

    self.userEditedRate = false
    self.userEditedAmount = false

    self:updateDynamicLabels()
    self:updateAutoPricing(true)
    self:updateAmountSummary()

    FocusManager:setFocus(self.amountInput)
end

function RS_createInvoiceDialog:buildFillTypeOptions()
    self.fillTypeIndices = {}
    self.fillTypeTitles = {}

    local texts = {}

    -- Build list from the game's fillTypeManager and filter by "showOnPriceTable".
    -- (Some versions/mods use "showOnPriceList"; we accept both for compatibility.)
    local entries = {}
    if g_fillTypeManager ~= nil and g_fillTypeManager.fillTypes ~= nil then
        for index, fillType in pairs(g_fillTypeManager.fillTypes) do
            if fillType ~= nil then
                local show = (fillType.showOnPriceTable == true) or (fillType.showOnPriceList == true)
                if show then
                    local title = nil
                    if g_fillTypeManager.getFillTypeTitleByIndex ~= nil then
                        title = g_fillTypeManager:getFillTypeTitleByIndex(index)
                    end
                    if title == nil or title == "" then
                        title = fillType.title or fillType.name or tostring(index)
                    end
                    table.insert(entries, { index = index, title = title })
                end
            end
        end
    end

    table.sort(entries, function(a, b)
        return tostring(a.title):lower() < tostring(b.title):lower()
    end)

    for _, e in ipairs(entries) do
        table.insert(self.fillTypeIndices, e.index)
        table.insert(self.fillTypeTitles, e.title)
        table.insert(texts, e.title)
    end

    if #texts == 0 then
        table.insert(self.fillTypeIndices, 0)
        table.insert(self.fillTypeTitles, "")
        table.insert(texts, self.i18n:getText("rs_ui_noProducts"))
    end

    if self.fillTypeOption ~= nil then
        self.fillTypeOption:setTexts(texts)
        self.fillTypeOption:setState(1, true)
    end
end

function RS_createInvoiceDialog:buildRecipientOptions()
    self.recipientFarmIds = {}
    local texts = {}

    local currentFarm = g_farmManager:getFarmByUserId(g_currentMission.playerUserId)
    local myFarmId = currentFarm ~= nil and currentFarm.farmId or 0

    -- List all other farms (skip empty names)
    if g_farmManager ~= nil and g_farmManager.farms ~= nil then
        for _, farm in pairs(g_farmManager.farms) do
            local farmId = farm.farmId or 0
            if farmId ~= 0 and farmId ~= myFarmId then
                local farmName = farm.name or farm.title
                if farmName == nil and farm.getName ~= nil then
                    farmName = farm:getName()
                end
                if farmName ~= nil then
                    farmName = tostring(farmName)
                end
                if farmName ~= nil and farmName ~= "" then
                    table.insert(self.recipientFarmIds, farmId)
                    table.insert(texts, farmName)
                end
            end
        end
    end

    -- If no other farms available, show a single informative item
    if #texts == 0 then
        table.insert(self.recipientFarmIds, 0)
        table.insert(texts, self.i18n:getText("rs_ui_noOtherFarms"))
    end

    self.farmerOption:setTexts(texts)
    self.farmerOption:setState(1, true)
end


function RS_createInvoiceDialog:buildActivityOptions()
    self.activities = {
        self.i18n:getText("rs_ui_activityPlowing"),
        self.i18n:getText("rs_ui_activityCultivating"),
        self.i18n:getText("rs_ui_activitySeeding"),
        self.i18n:getText("rs_ui_activityHarrow"),
        self.i18n:getText("rs_ui_activityHackenStriegeln"),
        self.i18n:getText("rs_ui_activityHarvest"),
        self.i18n:getText("rs_ui_activityBalePressing"),
        self.i18n:getText("rs_ui_activityWoodFelling"),
        self.i18n:getText("rs_ui_activityLiming"),
        self.i18n:getText("rs_ui_activityFertilizing"),
        self.i18n:getText("rs_ui_activityVehicleRent"),
        self.i18n:getText("rs_ui_activityDelivering"),
        self.i18n:getText("rs_ui_activitySpraying"),
        self.i18n:getText("rs_ui_activityMowing"),
        self.i18n:getText("rs_ui_activityTedding"),
        self.i18n:getText("rs_ui_activityWindrowing"),
        self.i18n:getText("rs_ui_activityWeeding"),
        self.i18n:getText("rs_ui_activityRolling"),
        self.i18n:getText("rs_ui_activityStonePicking"),
        self.i18n:getText("rs_ui_activityMulching"),
        self.i18n:getText("rs_ui_activityBaleWrapping")
}

    self.activityOption:setTexts(self.activities)
    self.activityOption:setState(1, true)
end

function RS_createInvoiceDialog:formatNumber(n)
    if n == nil then
        return ""
    end
    if math.abs(n - math.floor(n)) < 0.0001 then
        return tostring(math.floor(n + 0.5))
    end
    return string.format("%.2f", n)
end


function RS_createInvoiceDialog:getFillTypePricePer1000L(fillTypeIndex)
    -- Prefer the static base price from fillTypes.xml (via g_fillTypeManager),
    -- fallback to EconomyManager (dynamic market price) if not available.
    -- Returns money per 1000L.

    if fillTypeIndex == nil or fillTypeIndex == 0 then
        return 0
    end

    local pricePerLiter = 0

    -- 1) Static price from fillTypes.xml (most mods/base game expose this as pricePerLiter on the fillType)
    if g_fillTypeManager ~= nil then
        local ft = nil
        if g_fillTypeManager.getFillTypeByIndex ~= nil then
            ft = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        end
        if ft == nil and g_fillTypeManager.fillTypes ~= nil then
            ft = g_fillTypeManager.fillTypes[fillTypeIndex]
        end

        if ft ~= nil then
            -- try common attribute names
            pricePerLiter = ft.pricePerLiter or ft.literPrice or ft.price or 0
        end
    end

    -- 2) Fallback: EconomyManager (dynamic market price)
    if (pricePerLiter == nil or pricePerLiter == 0) and g_currentMission ~= nil and g_currentMission.economyManager ~= nil then
        local em = g_currentMission.economyManager
        if em.getPricePerLiter ~= nil then
            pricePerLiter = em:getPricePerLiter(fillTypeIndex) or 0
        elseif em.getPrice ~= nil then
            pricePerLiter = em:getPrice(fillTypeIndex) or 0
        end
    end

    -- 3) Fallback: PriceManager if present
    if (pricePerLiter == nil or pricePerLiter == 0) and g_priceManager ~= nil then
        if g_priceManager.getPricePerLiter ~= nil then
            pricePerLiter = g_priceManager:getPricePerLiter(fillTypeIndex) or 0
        end
    end

    pricePerLiter = tonumber(pricePerLiter) or 0
    if pricePerLiter <= 0 then
        return 0
    end

    return pricePerLiter * self:getEconomyDifficultyFactor() * 1000
end


function RS_createInvoiceDialog:getEconomyDifficultyFactor()
    -- Base prices in fillTypes.xml are defined for HARD and are multiplied by the economy difficulty factor.
    -- We try to read the multiplier directly first. If not possible, we map the economic difficulty enum.

    -- 1) Ask EconomyManager for a multiplier (most robust)
    if g_currentMission ~= nil and g_currentMission.economyManager ~= nil then
        local em = g_currentMission.economyManager

        if em.getEconomicDifficultyMultiplier ~= nil then
            local m = tonumber(em:getEconomicDifficultyMultiplier())
            if m ~= nil and m > 0 then return m end
        end
        if em.getDifficultyMultiplier ~= nil then
            local m = tonumber(em:getDifficultyMultiplier())
            if m ~= nil and m > 0 then return m end
        end

        -- some versions store it as a field
        local m = tonumber(em.economicDifficultyMultiplier or em.difficultyMultiplier)
        if m ~= nil and m > 0 then return m end
    end

    -- 2) Determine economic difficulty enum/value
    local diff = nil
    if g_currentMission ~= nil then
        if g_currentMission.getEconomicDifficulty ~= nil then
            diff = g_currentMission:getEconomicDifficulty()
        end
        if diff == nil and g_currentMission.missionInfo ~= nil then
            diff = g_currentMission.missionInfo.economicDifficulty
            if diff == nil then diff = g_currentMission.missionInfo.economyDifficulty end
            if diff == nil then diff = g_currentMission.missionInfo.difficultyEconomic end
        end
    end

    if diff == nil and g_gameSettings ~= nil then
        if g_gameSettings.getValue ~= nil then
            diff = g_gameSettings:getValue("economicDifficulty")
            if diff == nil then diff = g_gameSettings:getValue("economyDifficulty") end
        end
        if diff == nil and g_gameSettings.economicDifficulty ~= nil then
            diff = g_gameSettings.economicDifficulty
        end
    end

    -- 3) Map enum/value -> multiplier
    -- Prefer using the game's enum constants if available
    if type(diff) == "number" then
        -- If EconomicDifficulty enum exists, use it
        if EconomicDifficulty ~= nil then
            if diff == EconomicDifficulty.EASY then return 3.0 end
            if diff == EconomicDifficulty.NORMAL then return 1.8 end
            if diff == EconomicDifficulty.HARD then return 1.0 end
        end

        -- Otherwise, support common mappings:
        -- Mapping A: 0=Easy, 1=Normal, 2=Hard
        if diff == 0 then return 3.0 end
        if diff == 1 then return 1.8 end
        if diff == 2 then return 1.0 end

        -- Mapping B: 1=Easy, 2=Normal, 3=Hard
        if diff == 3 then return 1.0 end
        if diff == 2 then return 1.8 end
        if diff == 1 then return 3.0 end
    else
        local s = tostring(diff):lower()
        if s == "easy" or s == "newfarmer" or s == "low" then return 3.0 end
        if s == "normal" or s == "medium" then return 1.8 end
        if s == "hard" or s == "high" then return 1.0 end
    end

    -- Debug (one-time)
    if self._rsLoggedDifficulty == nil then
        self._rsLoggedDifficulty = true
        Logging.info("[RS] Economy difficulty mapping fallback (diff=%s). Using factor=1.0", tostring(diff))
        if EconomicDifficulty ~= nil then
            Logging.info("[RS] EconomicDifficulty enum: EASY=%s NORMAL=%s HARD=%s",
                tostring(EconomicDifficulty.EASY), tostring(EconomicDifficulty.NORMAL), tostring(EconomicDifficulty.HARD))
        end
    end

    return 1.0
end






function RS_createInvoiceDialog:getSuggestedRatePerUnit()
    local idx = self.activityOption:getState()

    -- Delivering: auto price from the selected product
    if self:isDelivering() and self.fillTypeOption ~= nil then
        local s = self.fillTypeOption:getState() or 1
        local fillTypeIndex = self.fillTypeIndices[s] or 0

        local p = self:getFillTypePricePer1000L(fillTypeIndex)
        if p > 0 then
            return p
        end
    end

    -- Default: static suggestion table
    local r = self.activityRatePerUnit[idx]
    return tonumber(r) or 0
end

function RS_createInvoiceDialog:getEnteredQuantity()
    if self.sizeInput == nil then
        return 0
    end
    local v = parseNumber(self.sizeInput:getText())
    return tonumber(v) or 0
end

function RS_createInvoiceDialog:updateDynamicLabels()
    local delivering = self:isDelivering()
    local balePressing = self.isBalePressing ~= nil and self:isBalePressing() or false
    local woodFelling = self:isWoodFelling()
    local vehicleRenting = self.isVehicleRenting ~= nil and self:isVehicleRenting() or false

    -- Product picker only for delivering
    if self.productLabel ~= nil then
        self.productLabel:setVisible(delivering)
    end
    if self.fillTypeOption ~= nil then
        self.fillTypeOption:setVisible(delivering)
    end

    -- Price label
    if self.unitPriceLabel ~= nil then
        if delivering then
            self.unitPriceLabel:setText(self.i18n:getText("rs_ui_invoicePricePer1000L"))
        elseif balePressing then
            self.unitPriceLabel:setText(self.i18n:getText("rs_ui_invoicePricePerBale"))
        elseif vehicleRenting then
            self.unitPriceLabel:setText(self.i18n:getText("rs_ui_invoicePricePerDay"))
        elseif woodFelling then
            self.unitPriceLabel:setText(self.i18n:getText("rs_ui_invoicePricePerStem"))
        else
            self.unitPriceLabel:setText(self.i18n:getText("rs_ui_invoicePricePerHa"))
        end
    end

    -- Quantity label
    if self.sizeLabel ~= nil then
        if delivering then
            self.sizeLabel:setText(self.i18n:getText("rs_ui_invoiceSize1000L"))
        elseif balePressing then
            self.sizeLabel:setText(self.i18n:getText("rs_ui_invoiceEnterBaleCount"))
        elseif vehicleRenting then
            self.sizeLabel:setText(self.i18n:getText("rs_ui_invoiceDays"))
        elseif woodFelling then
            self.sizeLabel:setText(self.i18n:getText("rs_ui_invoiceSizeStem"))
        else
            self.sizeLabel:setText(self.i18n:getText("rs_ui_invoiceSizeHa"))
        end
    end
end



function RS_createInvoiceDialog:updateAutoPricing(force)
    local delivering = self:isDelivering()
    local woodFelling = self:isWoodFelling()
    local vehicleRenting = self.isVehicleRenting ~= nil and self:isVehicleRenting() or false
    local quantity = self:getEnteredQuantity()

    -- info line
    if self.areaInfoText ~= nil then
        if quantity > 0 then
            local rate = self:getSuggestedRatePerUnit()
            local unitShort
            local qtyLabel
            if delivering then
                unitShort = self.i18n:getText("rs_ui_invoicePer1000LShort")
                qtyLabel = self.i18n:getText("rs_ui_invoiceQuantity1000L")
            elseif self:isBalePressing() then
                unitShort = "Stk"
                qtyLabel = self.i18n:getText("rs_ui_invoiceEnterBaleCount")
            elseif self:isVehicleRenting() then
                unitShort = self.i18n:getText("rs_ui_invoicePerDayShort")
                qtyLabel = self.i18n:getText("rs_ui_invoiceDays")
elseif woodFelling then
                unitShort = self.i18n:getText("rs_ui_invoicePerStemShort")
                qtyLabel = self.i18n:getText("rs_ui_invoiceStems")
            else
                unitShort = self.i18n:getText("rs_ui_invoicePerHaShort")
                qtyLabel = self.i18n:getText("rs_ui_invoiceAreaHa")
            end
            self.areaInfoText:setText(string.format("%s: %s | %s: %s/%s",
                qtyLabel,
                self:formatNumber(quantity),
                self.i18n:getText("rs_ui_invoiceSuggested"),
                self:formatNumber(rate),
                unitShort
            ))
        else
            self.areaInfoText:setText("")
        end
    end

    -- suggested unit price
    if self.pricePerHaInput ~= nil and (force or not self.userEditedRate) then
        local suggested = self:getSuggestedRatePerUnit()
        if suggested > 0 then
            self.pricePerHaInput:setText(self:formatNumber(suggested))
        else
            self.pricePerHaInput:setText("")
        end
    end

    -- auto-calc amount if quantity is provided
    if quantity > 0 and self.pricePerHaInput ~= nil and (force or not self.userEditedAmount) then
        local rate = parseNumber(self.pricePerHaInput:getText()) or 0
        if rate > 0 then
            local amount = rate * quantity
            self.amountInput:setText(self:formatNumber(amount))
        end
    end

    self:updateAmountSummary()
end

function RS_createInvoiceDialog:onActivityChanged()
    self.userEditedRate = false
    self.userEditedAmount = false
    self:updateDynamicLabels()
    self:updateAutoPricing(true)
end


function RS_createInvoiceDialog:onFillTypeChanged()
    -- When delivering, the selected product changes the suggested unit price.
    self.userEditedRate = false
    self.userEditedAmount = false
    self:updateAutoPricing(true)
end

function RS_createInvoiceDialog:onUnitPriceChanged()
    self.userEditedRate = true
    self.userEditedAmount = false
    self:updateAutoPricing(false)
    self:updateAmountSummary()
end

function RS_createInvoiceDialog:onSizeChanged()
    self.userEditedAmount = false
    self:updateAutoPricing(false)
    self:updateAmountSummary()
end

function RS_createInvoiceDialog:onFieldNumberChanged()
    if self.fieldNumberInput == nil or self.sizeInput == nil then
        return
    end

    local raw = tostring(self.fieldNumberInput:getText() or "")
    -- allow lists like "12, 13" or "12 13" -> sum areas
    local ids = {}
    for num in string.gmatch(raw, "%d+") do
        local v = tonumber(num)
        if v ~= nil and v > 0 then
            ids[#ids+1] = math.floor(v + 0.5)
        end
    end

    if #ids == 0 then
        return
    end

    local totalHa = 0
    local foundAny = false
    for _, fieldId in ipairs(ids) do
        local ha = rsGetFieldSizeHa(fieldId)
        if ha ~= nil and ha > 0 then
            totalHa = totalHa + ha
            foundAny = true
        end
    end

    if not foundAny then
        return
    end

    -- Write with 2 decimals; in DE use comma for readability
    local txt = string.format("%.2f", totalHa)
    txt = string.gsub(txt, "%.", ",")

    self.userEditedAmount = false
    self.sizeInput:setText(txt)
    self:updateAutoPricing(false)
    self:updateAmountSummary()
end

function RS_createInvoiceDialog:onTextChanged()
    self.userEditedAmount = true
    self:updateAmountSummary()
end

function RS_createInvoiceDialog:onClickOk()
    local currentFarm = g_farmManager:getFarmByUserId(g_currentMission.playerUserId)
    local issuerFarmId = currentFarm ~= nil and currentFarm.farmId or 0

    local recipientIndex = self.farmerOption:getState()
    local recipientFarmId = self.recipientFarmIds[recipientIndex] or 0

    if recipientFarmId == 0 or recipientFarmId == issuerFarmId then
        InfoDialog.show(self.i18n:getText("rs_ui_errorChooseFarmer"))
        return
    end

    local activityIndex = self.activityOption:getState()
    local activity = self.activities[activityIndex] or ""

    -- optional: product for delivery
    local fillTypeIndex = 0
    local fillTypeTitle = ""
    if self:isDelivering() and self.fillTypeOption ~= nil then
        local s = self.fillTypeOption:getState() or 1
        fillTypeIndex = self.fillTypeIndices[s] or 0
        fillTypeTitle = self.fillTypeTitles[s] or ""
    end

    local amount = parseNumber(self.amountInput:getText())
    if amount == nil or amount <= 0 then
        self:showInfo(self.i18n:getText("rs_ui_errorAmount"))
        return
    end

    -- optional: field number
    local fieldId = 0
    local fieldName = ""
    if self.fieldNumberInput ~= nil then
        local f = parseNumber(self.fieldNumberInput:getText())
        if f ~= nil and f > 0 then
            fieldId = math.floor(f + 0.5)
            fieldName = string.format("%s %d", self.i18n:getText("rs_ui_field"), fieldId)
        end
    end

    -- quantity (unit depends on activity)
    local quantity = self:getEnteredQuantity()
    local unitType
    if self:isDelivering() then
        unitType = "1000L"
    elseif self:isWoodFelling() then
        unitType = "stems"
    elseif self:isBalePressing() then
        unitType = "bales"
    elseif self:isVehicleRenting() then
        unitType = "days"
    else
        unitType = "ha"
    end

    -- FS stores money as integer
    amount = math.floor(amount + 0.5)

    -- Safety: ensure manager exists (SP host / MP client edge cases)
    if g_rs_invoiceManager == nil and RS_invoiceManager ~= nil then
        g_rs_invoiceManager = RS_invoiceManager.new()
    end

    if g_rs_invoiceManager ~= nil then
        -- Block creation if issuer has too many open invoices (server-configurable)
        local maxOpen = (RS_invoiceManager ~= nil and RS_invoiceManager.MAX_OPEN_SERVICE) or 10
        if g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil and g_currentMission.rsInvoiceSettings.rsMaxOpenInvoices ~= nil then
            maxOpen = tonumber(g_currentMission.rsInvoiceSettings.rsMaxOpenInvoices) or maxOpen
        end
        if g_rs_invoiceManager.getOpenIssuedServiceCount ~= nil then
            local openIssued = g_rs_invoiceManager:getOpenIssuedServiceCount(issuerFarmId or 0)
            if openIssued >= maxOpen then
                self:showInfo(self.i18n:getText("rs_ui_errorMaxOpenInvoices"))
                return
            end
        end

        g_rs_invoiceManager:createServiceInvoice(issuerFarmId, recipientFarmId, amount, fieldId, activity, fieldName, nil, quantity, unitType, fillTypeIndex, fillTypeTitle)
    end

    if self.invoiceDialog ~= nil and self.invoiceDialog.onInvoiceCreated ~= nil then
        self.invoiceDialog:onInvoiceCreated()
    elseif self.target ~= nil and self.target.onInvoiceCreated ~= nil then
        self.target:onInvoiceCreated()
    end

    self:close()
end

function RS_createInvoiceDialog:onClickCancel()
    self:close()
end

function RS_createInvoiceDialog:onClickBack()
    self:close()
end
