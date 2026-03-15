-- Name: RS_invoice
-- Author: DonQuacko

RS_invoice = {}
local RS_invoice_mt = Class(RS_invoice, Object)

InitObjectClass(RS_invoice, "RS_invoice")

function RS_invoice.new(isServer, isClient, customMt)
    local self = Object.new(isServer, isClient, customMt or RS_invoice_mt)

    self.invoiceDirtyFlag = self:getNextDirtyFlag()

    return self
end

-- Backwards compatible init:
-- farmId: legacy (used for old bookkeeping entries)
-- For service invoices, use issuerFarmId/recipientFarmId.
function RS_invoice:init(farmId, amount, moneyType, title, dateString, isCredit)
    self.farmId = farmId or 0 -- legacy
    self.amount = amount or 0
    self.moneyType = moneyType or MoneyType.RS_INVOICE_INCOME or MoneyType.OTHER
    self.title = title or ""
    self.dateString = dateString or ""
    self.isCredit = isCredit or false -- legacy display hint

    -- New invoice fields
    self.kind = self.kind or "booking" -- "booking" | "service"
    self.issuerFarmId = self.issuerFarmId or (farmId or 0)
    self.recipientFarmId = self.recipientFarmId or 0
    self.fieldId = self.fieldId or 0
    self.fieldName = self.fieldName or ""
    self.fillTypeIndex = self.fillTypeIndex or 0
    self.fillTypeTitle = self.fillTypeTitle or ""
    self.quantity = self.quantity or 0
    self.unitType = self.unitType or ""

    self.isPaid = self.isPaid or (self.kind == "booking")
    self.paidDateString = self.paidDateString or ""

    -- Optional: MwSt/Brutto/Zinsen
    self.netAmount = self.netAmount or nil
    self.vatAmount = self.vatAmount or nil
    self.grossAmount = self.grossAmount or nil
    self.creationTotalTimeMs = self.creationTotalTimeMs or nil
    self.interestAmount = self.interestAmount or 0

    -- Unique id for MP-safe identification
    if self.uid == nil or self.uid == "" then
        if g_currentMission ~= nil and g_currentMission.getIsServer ~= nil and g_currentMission:getIsServer() then
            self.uid = string.format("%d-%d", g_time or 0, math.random(1, 2147483647))
        else
            self.uid = ""
        end
    end
end

function RS_invoice:saveToXMLFile(xmlFile, key)
    -- legacy fields
    xmlFile:setInt(key .. "#farmId", self.farmId or 0)
    xmlFile:setInt(key .. "#amount", self.amount or 0)
    xmlFile:setInt(key .. "#moneyType", (self.moneyType and self.moneyType.id) and self.moneyType.id or (self.moneyType or MoneyType.OTHER.id))
    xmlFile:setString(key .. "#title", self.title or "")
    xmlFile:setString(key .. "#date", self.dateString or "")
    xmlFile:setBool(key .. "#isCredit", self.isCredit or false)

    -- new fields
    xmlFile:setString(key .. "#kind", self.kind or "booking")
    xmlFile:setInt(key .. "#issuerFarmId", self.issuerFarmId or 0)
    xmlFile:setInt(key .. "#recipientFarmId", self.recipientFarmId or 0)
    xmlFile:setInt(key .. "#fieldId", self.fieldId or 0)
    xmlFile:setString(key .. "#fieldName", self.fieldName or "")
    xmlFile:setString(key .. "#activity", self.activity or "")
    xmlFile:setInt(key .. "#fillTypeIndex", self.fillTypeIndex or 0)
    xmlFile:setString(key .. "#fillTypeTitle", self.fillTypeTitle or "")
    xmlFile:setFloat(key .. "#quantity", tonumber(self.quantity) or 0)
    xmlFile:setString(key .. "#unitType", self.unitType or "")
    xmlFile:setBool(key .. "#isPaid", self.isPaid or false)
    xmlFile:setString(key .. "#paidDate", self.paidDateString or "")
    xmlFile:setString(key .. "#uid", self.uid or "")

    -- optional financial details
    if self.netAmount ~= nil then xmlFile:setFloat(key .. "#netAmount", tonumber(self.netAmount) or 0) end
    if self.vatAmount ~= nil then xmlFile:setFloat(key .. "#vatAmount", tonumber(self.vatAmount) or 0) end
    if self.grossAmount ~= nil then xmlFile:setInt(key .. "#grossAmount", tonumber(self.grossAmount) or 0) end
    if self.creationTotalTimeMs ~= nil then xmlFile:setFloat(key .. "#creationTotalTimeMs", tonumber(self.creationTotalTimeMs) or 0) end
    xmlFile:setInt(key .. "#interestAmount", tonumber(self.interestAmount) or 0)
end

function RS_invoice:loadFromXMLFile(xmlFile, key)
    -- legacy
    self.farmId = xmlFile:getInt(key .. "#farmId") or 0
    self.amount = xmlFile:getInt(key .. "#amount") or 0
    local moneyTypeId = xmlFile:getInt(key .. "#moneyType") or MoneyType.OTHER.id
    self.moneyType = MoneyType.getMoneyTypeById(moneyTypeId) or MoneyType.OTHER
    self.title = xmlFile:getString(key .. "#title") or ""
    self.dateString = xmlFile:getString(key .. "#date") or ""
    self.isCredit = xmlFile:getBool(key .. "#isCredit") or false

    -- new (optional in older saves)
    self.kind = xmlFile:getString(key .. "#kind") or "booking"
    self.issuerFarmId = xmlFile:getInt(key .. "#issuerFarmId") or self.farmId or 0
    self.recipientFarmId = xmlFile:getInt(key .. "#recipientFarmId") or 0
    self.fieldId = xmlFile:getInt(key .. "#fieldId") or 0
    self.fieldName = xmlFile:getString(key .. "#fieldName") or ""
    self.activity = xmlFile:getString(key .. "#activity") or ""
    self.fillTypeIndex = xmlFile:getInt(key .. "#fillTypeIndex") or 0
    self.fillTypeTitle = xmlFile:getString(key .. "#fillTypeTitle") or ""
    self.quantity = xmlFile:getFloat(key .. "#quantity") or 0
    self.unitType = xmlFile:getString(key .. "#unitType") or ""
    local isPaid = xmlFile:getBool(key .. "#isPaid")
    if isPaid == nil then
        self.isPaid = (self.kind == "booking")
    else
        self.isPaid = isPaid
    end
    self.paidDateString = xmlFile:getString(key .. "#paidDate") or ""
    self.uid = xmlFile:getString(key .. "#uid") or self.uid or ""

    -- optional financial details
    local netAmount = xmlFile:getFloat(key .. "#netAmount")
    if netAmount ~= nil then self.netAmount = netAmount end
    local vatAmount = xmlFile:getFloat(key .. "#vatAmount")
    if vatAmount ~= nil then self.vatAmount = vatAmount end
    local grossAmount = xmlFile:getInt(key .. "#grossAmount")
    if grossAmount ~= nil then self.grossAmount = grossAmount end
    local creationTotalTimeMs = xmlFile:getFloat(key .. "#creationTotalTimeMs")
    if creationTotalTimeMs ~= nil then self.creationTotalTimeMs = creationTotalTimeMs end
    self.interestAmount = xmlFile:getInt(key .. "#interestAmount") or self.interestAmount or 0
end

function RS_invoice:writeStream(streamId, connection)
    RS_invoice:superClass().writeStream(self, streamId, connection)

    -- legacy
    streamWriteInt32(streamId, self.farmId or 0)
    streamWriteInt32(streamId, self.amount or 0)
    streamWriteInt32(streamId, (self.moneyType and self.moneyType.id) or MoneyType.OTHER.id)
    streamWriteString(streamId, self.title or "")
    streamWriteString(streamId, self.dateString or "")
    streamWriteBool(streamId, self.isCredit or false)

    -- new
    streamWriteString(streamId, self.kind or "booking")
    streamWriteInt32(streamId, self.issuerFarmId or 0)
    streamWriteInt32(streamId, self.recipientFarmId or 0)
    streamWriteInt32(streamId, self.fieldId or 0)
    streamWriteString(streamId, self.fieldName or "")
    streamWriteString(streamId, self.activity or "")
    streamWriteInt32(streamId, self.fillTypeIndex or 0)
    streamWriteString(streamId, self.fillTypeTitle or "")
    streamWriteFloat32(streamId, tonumber(self.quantity) or 0)
    streamWriteString(streamId, self.unitType or "")
    streamWriteBool(streamId, self.isPaid or false)
    streamWriteString(streamId, self.paidDateString or "")
    streamWriteString(streamId, self.uid or "")

    -- optional financial details (presence flags for backwards compatibility)
    streamWriteBool(streamId, self.netAmount ~= nil)
    if self.netAmount ~= nil then streamWriteFloat32(streamId, tonumber(self.netAmount) or 0) end

    streamWriteBool(streamId, self.vatAmount ~= nil)
    if self.vatAmount ~= nil then streamWriteFloat32(streamId, tonumber(self.vatAmount) or 0) end

    streamWriteBool(streamId, self.grossAmount ~= nil)
    if self.grossAmount ~= nil then streamWriteInt32(streamId, tonumber(self.grossAmount) or 0) end

    streamWriteBool(streamId, self.creationTotalTimeMs ~= nil)
    if self.creationTotalTimeMs ~= nil then streamWriteFloat32(streamId, tonumber(self.creationTotalTimeMs) or 0) end

    streamWriteInt32(streamId, tonumber(self.interestAmount) or 0)
end

function RS_invoice:readStream(streamId, connection)
    RS_invoice:superClass().readStream(self, streamId, connection)

    -- legacy
    self.farmId = streamReadInt32(streamId)
    self.amount = streamReadInt32(streamId)
    local moneyTypeId = streamReadInt32(streamId)
    self.moneyType = MoneyType.getMoneyTypeById(moneyTypeId) or MoneyType.OTHER
    self.title = streamReadString(streamId) or ""
    self.dateString = streamReadString(streamId) or ""
    self.isCredit = streamReadBool(streamId)

    -- new
    self.kind = streamReadString(streamId) or "booking"
    self.issuerFarmId = streamReadInt32(streamId)
    self.recipientFarmId = streamReadInt32(streamId)
    self.fieldId = streamReadInt32(streamId)
    self.fieldName = streamReadString(streamId) or ""
    self.activity = streamReadString(streamId) or ""
    self.fillTypeIndex = streamReadInt32(streamId)
    self.fillTypeTitle = streamReadString(streamId) or ""
    self.quantity = streamReadFloat32(streamId)
    self.unitType = streamReadString(streamId) or ""
    self.isPaid = streamReadBool(streamId)
    self.paidDateString = streamReadString(streamId) or ""
    self.uid = streamReadString(streamId) or self.uid or ""

    -- optional financial details (presence flags for backwards compatibility)
    if streamReadBool(streamId) then
        self.netAmount = streamReadFloat32(streamId)
    end
    if streamReadBool(streamId) then
        self.vatAmount = streamReadFloat32(streamId)
    end
    if streamReadBool(streamId) then
        self.grossAmount = streamReadInt32(streamId)
    end
    if streamReadBool(streamId) then
        self.creationTotalTimeMs = streamReadFloat32(streamId)
    end
    self.interestAmount = streamReadInt32(streamId)
end
