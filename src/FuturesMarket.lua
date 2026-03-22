-- FuturesMarket.lua
-- Handles futures contract creation, tracking, and fulfillment.
-- Players lock in a price + quantity + delivery date.
-- On delivery date: if fulfilled → full locked-price payout;
--                   if defaulted → partial payout minus penalty on unfulfilled portion.
--
-- UPIntegration hooks:
--   onContractCreated   — notified when a new contract is written
--   onContractFulfilled — notified on full delivery (for credit score up)
--   onContractDefaulted — notified on default (for credit score down)
--   getPenaltyModifier  — scales DEFAULT_PENALTY per player credit score
--
-- Author: tison (dev-1)

FuturesMarket = {}
FuturesMarket.__index = FuturesMarket

-- Base penalty rate for defaulting on a contract (fraction of unfulfilled contract value).
-- UPIntegration.getPenaltyModifier() may scale this up or down based on credit score.
local DEFAULT_PENALTY = 0.15

function FuturesMarket.new()
    local self = setmetatable({}, FuturesMarket)

    -- { [contractId] = Contract }
    self.contracts  = {}
    self.nextId     = 1

    MDMLog.info("FuturesMarket initialized")
    return self
end

-- Create a new futures contract.
-- params = { farmId, fillTypeIndex, fillTypeName, quantity, lockedPrice, deliveryTimeMs }
-- Returns contractId.
function FuturesMarket:createContract(params)
    local id = self.nextId
    self.nextId = self.nextId + 1

    local contract = {
        id            = id,
        farmId        = params.farmId,
        fillTypeIndex = params.fillTypeIndex,
        fillTypeName  = params.fillTypeName,
        quantity      = params.quantity,       -- in liters
        lockedPrice   = params.lockedPrice,    -- per liter at contract creation
        deliveryTime  = params.deliveryTimeMs, -- absolute game time (ms)
        delivered     = 0,                     -- liters delivered so far
        status        = "active",              -- active | fulfilled | defaulted
    }

    self.contracts[id] = contract
    MDMLog.info("FuturesMarket: contract #" .. id .. " created — " .. params.fillTypeName ..
        " x" .. params.quantity .. "L @ " .. params.lockedPrice)

    -- Notify UPIntegration so it can register this as an external deal if UP mode is on.
    UPIntegration.onContractCreated(id, params.farmId, params)

    return id
end

-- Record a partial or full delivery toward an active contract.
-- Returns true if the contract is now fully fulfilled, false otherwise.
function FuturesMarket:recordDelivery(contractId, liters)
    local contract = self.contracts[contractId]
    if not contract or contract.status ~= "active" then return false end

    contract.delivered = contract.delivered + liters

    if contract.delivered >= contract.quantity then
        self:_fulfillContract(contractId)
        return true
    end
    return false
end

-- Check all active contracts for delivery deadline expiry.
-- Called every frame from MarketDynamics:update().
function FuturesMarket:checkExpiry()
    local now = g_currentMission and g_currentMission.time or 0

    for id, contract in pairs(self.contracts) do
        if contract.status == "active" and now >= contract.deliveryTime then
            if contract.delivered >= contract.quantity then
                self:_fulfillContract(id)
            else
                self:_defaultContract(id)
            end
        end
    end
end

-- Called from the SellingStation delivery hook on every accepted crop sale.
-- Routes liters to all active contracts matching this farm + fillType, oldest first.
-- Excess liters (beyond what contracts need) are silently ignored — normal selling.
function FuturesMarket:onCropDelivered(farmId, fillTypeIndex, liters)
    local remaining = liters
    for id, contract in pairs(self.contracts) do
        if remaining <= 0 then break end
        if contract.status == "active"
            and contract.farmId == farmId
            and contract.fillTypeIndex == fillTypeIndex then

            local needed   = contract.quantity - contract.delivered
            local applying = math.min(remaining, needed)
            self:recordDelivery(id, applying)
            remaining = remaining - applying
        end
    end
end

-- Returns all contracts belonging to a given farm (for GUI display).
function FuturesMarket:getContractsForFarm(farmId)
    local result = {}
    for _, contract in pairs(self.contracts) do
        if contract.farmId == farmId then
            table.insert(result, contract)
        end
    end
    return result
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

-- Pay out the full locked-price value for a fulfilled contract.
-- Guard against double-pay: recordDelivery() and checkExpiry() can both
-- reach this function for the same contract on the same frame. The status
-- check ensures the payout only ever happens once.
function FuturesMarket:_fulfillContract(id)
    local contract = self.contracts[id]
    if not contract then return end
    if contract.status ~= "active" then return end  -- already settled; skip
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    contract.status = "fulfilled"
    local payout = contract.quantity * contract.lockedPrice

    g_currentMission:addMoney(payout, contract.farmId, MoneyType.OTHER, true)
    MDMLog.info("FuturesMarket: contract #" .. id .. " FULFILLED — payout $" .. payout)

    -- HUD notification (only show to the owning farm's local player)
    if g_localPlayer and g_localPlayer.farmId == contract.farmId then
        local msg = string.format("Contract fulfilled: %s — $%s paid out",
            contract.fillTypeName,
            g_i18n:formatMoney(math.floor(payout), 0, true, false))
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_OK, msg)
    end

    -- Notify UPIntegration for credit score reporting.
    UPIntegration.onContractFulfilled(id, contract.farmId, payout)
end

-- Settle a defaulted contract: partial payout for delivered portion, minus
-- a penalty on the unfulfilled portion.
--
-- Effective penalty rate = DEFAULT_PENALTY * UPIntegration.getPenaltyModifier()
--   Excellent credit (750+) → ~10% effective penalty
--   Normal credit           → ~15% effective penalty  (no UP or unknown score)
--   Poor credit    (<600)   → ~20% effective penalty
--
-- Net payout is floored at 0: the penalty never exceeds the partial payout,
-- so a default never results in a charge against the player's account.
function FuturesMarket:_defaultContract(id)
    local contract = self.contracts[id]
    if not contract then return end
    if contract.status ~= "active" then return end  -- already settled; skip
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    contract.status = "defaulted"

    local delivered   = contract.delivered
    local unfulfilled = contract.quantity - delivered

    local partialPayout = delivered * contract.lockedPrice

    -- Apply credit-score-based penalty scaling from UPIntegration.
    -- Returns 1.0 (no change) when UP is not active or score is unavailable.
    local penaltyRate = DEFAULT_PENALTY * UPIntegration.getPenaltyModifier(contract.farmId)
    local penalty     = unfulfilled * contract.lockedPrice * penaltyRate

    -- Floor net at 0: never drain the player's account for a default.
    local net = math.max(0, partialPayout - penalty)

    if net > 0 then
        g_currentMission:addMoney(net, contract.farmId, MoneyType.OTHER, true)
    end

    MDMLog.warn(string.format(
        "FuturesMarket: contract #%d DEFAULTED — delivered %dL/%dL  partial $%.2f  penalty -$%.2f  net $%.2f",
        id, delivered, contract.quantity, partialPayout, penalty, net))

    -- HUD notification (only show to the owning farm's local player)
    if g_localPlayer and g_localPlayer.farmId == contract.farmId then
        local msg
        if net > 0 then
            msg = string.format("Contract defaulted: %s — %dL/%dL delivered, $%s after penalty",
                contract.fillTypeName,
                delivered, contract.quantity,
                g_i18n:formatMoney(math.floor(net), 0, true, false))
        else
            msg = string.format("Contract defaulted: %s — %dL/%dL delivered, no payout",
                contract.fillTypeName,
                delivered, contract.quantity)
        end
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, msg)
    end

    -- Notify UPIntegration for credit score reporting.
    UPIntegration.onContractDefaulted(id, contract.farmId, penalty)
end
