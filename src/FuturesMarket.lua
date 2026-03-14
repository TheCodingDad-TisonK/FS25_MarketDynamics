-- FuturesMarket.lua
-- Handles futures contract creation, tracking, and fulfillment.
-- Players lock in a price + quantity + delivery date.
-- On delivery date: if fulfilled → bonus; if defaulted → penalty.
--
-- Author: tison (dev-1)

FuturesMarket = {}
FuturesMarket.__index = FuturesMarket

-- Penalty for defaulting on a contract (fraction of contract value)
local DEFAULT_PENALTY = 0.15

function FuturesMarket.new()
    local self = setmetatable({}, FuturesMarket)

    -- { [contractId] = Contract }
    self.contracts  = {}
    self.nextId     = 1

    MDMLog.info("FuturesMarket initialized")
    return self
end

-- Create a new futures contract
-- params = { farmId, fillTypeIndex, fillTypeName, quantity, lockedPrice, deliveryTimeMs }
-- Returns contractId
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
        deliveryTime  = params.deliveryTimeMs, -- absolute game time
        delivered     = 0,                     -- liters delivered so far
        status        = "active",              -- active | fulfilled | defaulted
    }

    self.contracts[id] = contract
    MDMLog.info("FuturesMarket: contract #" .. id .. " created — " .. params.fillTypeName ..
        " x" .. params.quantity .. "L @ " .. params.lockedPrice)
    return id
end

-- Record a delivery toward a contract
-- Returns true if contract is now fulfilled
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

-- Check all active contracts for expiry — called from coordinator update
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

-- Returns all contracts for a given farm (for GUI display)
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

function FuturesMarket:_fulfillContract(id)
    local contract = self.contracts[id]
    if not contract then return end

    contract.status = "fulfilled"
    local payout = contract.quantity * contract.lockedPrice

    g_currentMission:addMoney(payout, contract.farmId, MoneyType.OTHER, true)
    MDMLog.info("FuturesMarket: contract #" .. id .. " FULFILLED — payout $" .. payout)
end

function FuturesMarket:_defaultContract(id)
    local contract = self.contracts[id]
    if not contract then return end

    contract.status = "defaulted"

    -- Partial payout for what was delivered, minus penalty on the unfulfilled portion
    local delivered     = contract.delivered
    local unfulfilled   = contract.quantity - delivered
    local partialPayout = delivered * contract.lockedPrice
    local penalty       = unfulfilled * contract.lockedPrice * DEFAULT_PENALTY

    local net = partialPayout - penalty
    if net ~= 0 then
        g_currentMission:addMoney(net, contract.farmId, MoneyType.OTHER, true)
    end

    MDMLog.warn("FuturesMarket: contract #" .. id .. " DEFAULTED — partial $" ..
        partialPayout .. " penalty -$" .. penalty .. " net $" .. net)
end
