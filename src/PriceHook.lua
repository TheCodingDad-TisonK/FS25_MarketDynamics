-- PriceHook.lua
-- Hooks SellingStation to route sell prices through MDM's modifier stack and
-- to track crop deliveries against active futures contracts.
--
-- Installed at source() time. Uses a sentinel (_G.MDM_PriceHook_installed) so
-- re-sourcing is idempotent.
--
-- Why SellingStation, not EconomyManager:
--   SellingStation caches its fillTypeInfos at map load and then calls its own
--   getPricePerLiter() at sell time — it never calls back into EconomyManager
--   during gameplay.  Hooking EconomyManager.getPricePerLiter therefore has no
--   effect on prices the player actually sees at a selling station.
--
-- Price hook (SellingStation.getEffectiveFillTypePrice):
--   Dormant until g_MarketDynamics.isActive = true.
--   If coordinator.settings.pricesEnabled = false, passes through to vanilla.
--
-- Delivery hook (SellingStation.sellFillType):
--   On every accepted crop delivery, notifies FuturesMarket so partial/full
--   contract fulfillment is tracked without a separate polling loop.
--   Server-only; no-op on pure clients.
--
-- Public helper:
--   MDMGetVanillaPrice(economyManager, fillTypeIndex) → number | nil
--     Returns the vanilla sell price at neutral supply/demand (pressure = 0).
--     Used by MarketEngine:init() for base price snapshotting.
--     Reads directly from EconomyManager (never patched) so it is always safe.
--
-- Author: tison (dev-1)

if _G.MDM_PriceHook_installed then
    MDMLog.info("PriceHook: already installed, skipping")
    return
end
_G.MDM_PriceHook_installed = true

-- ---------------------------------------------------------------------------
-- EconomyManager reference — used only for MDMGetVanillaPrice, never patched.
-- ---------------------------------------------------------------------------

local origEconGetPrice = nil

if EconomyManager and EconomyManager.getPricePerLiter then
    origEconGetPrice = EconomyManager.getPricePerLiter
    MDMLog.info("PriceHook: EconomyManager.getPricePerLiter captured for vanilla snapshots")
else
    MDMLog.warn("PriceHook: EconomyManager.getPricePerLiter not found — MDMGetVanillaPrice will return nil")
end

-- ---------------------------------------------------------------------------
-- SellingStation price hook
-- ---------------------------------------------------------------------------

if SellingStation and SellingStation.getEffectiveFillTypePrice then
    local origSSGetPrice = SellingStation.getEffectiveFillTypePrice

    SellingStation.getEffectiveFillTypePrice = function(self, fillTypeIndex)
        local price = origSSGetPrice(self, fillTypeIndex)
        if type(price) ~= "number" or price <= 0 then return price end

        -- Dormant until MDM is fully initialized
        if not g_MarketDynamics or not g_MarketDynamics.isActive then
            return price
        end

        -- Respect the "Dynamic Prices" setting (ESC > Settings > Market Dynamics)
        if g_MarketDynamics.settings and not g_MarketDynamics.settings.pricesEnabled then
            return price
        end

        local mdmPrice = g_MarketDynamics.marketEngine:getPrice(fillTypeIndex)
        if mdmPrice and mdmPrice > 0 then
            return mdmPrice
        end

        -- Fallback: fillType not tracked by MDM (e.g. added by another mod)
        return price
    end

    MDMLog.info("PriceHook: SellingStation.getEffectiveFillTypePrice hooked")
else
    MDMLog.warn("PriceHook: SellingStation.getEffectiveFillTypePrice not found — price hook disabled")
end

-- ---------------------------------------------------------------------------
-- SellingStation delivery hook (futures contract tracking)
-- ---------------------------------------------------------------------------

if SellingStation and SellingStation.sellFillType then
    local origSellFillType = SellingStation.sellFillType

    SellingStation.sellFillType = function(self, farmId, fillDelta, fillTypeIndex, toolType, extraAttributes)
        local accepted = origSellFillType(self, farmId, fillDelta, fillTypeIndex, toolType, extraAttributes)

        -- Only track on server; only when MDM is active with a futures market
        if accepted and accepted > 0
            and g_currentMission and g_currentMission.isServer
            and g_MarketDynamics and g_MarketDynamics.isActive
            and g_MarketDynamics.futuresMarket then

            g_MarketDynamics.futuresMarket:onCropDelivered(farmId, fillTypeIndex, accepted)
        end

        return accepted
    end

    MDMLog.info("PriceHook: SellingStation.sellFillType hooked for futures tracking")
else
    MDMLog.warn("PriceHook: SellingStation.sellFillType not found — futures delivery tracking disabled")
end

-- ---------------------------------------------------------------------------
-- Public helper: vanilla price snapshot for MarketEngine:init()
-- ---------------------------------------------------------------------------

-- Returns the vanilla sell price for a fillType at neutral supply/demand (pressure = 0).
-- Reads from EconomyManager directly (never patched).
-- Returns nil if EconomyManager.getPricePerLiter was not captured.
function MDMGetVanillaPrice(economyManager, fillTypeIndex)
    if origEconGetPrice and economyManager then
        return origEconGetPrice(economyManager, fillTypeIndex, 0)
    end
    return nil
end
