-- PriceHook.lua
-- Monkeypatches EconomyManager.getPricePerLiter to route sell prices
-- through MDM's modifier stack at point of sale.
--
-- Installed at source() time. Uses a sentinel so re-sourcing is idempotent.
-- The hook is a no-op until g_MarketDynamics.isActive = true, which means
-- MarketEngine:init() can safely call the vanilla economy to snapshot base prices.
--
-- Public helper: MDMGetVanillaPrice(economyManager, fillTypeIndex)
--   Returns the vanilla sell price at neutral supply/demand pressure (0).
--   Used by MarketEngine:init() for base price snapshotting.
--
-- Author: tison (dev-1)

if _G.MDM_PriceHook_installed then
    MDMLog.info("PriceHook: already installed, skipping")
    return
end
_G.MDM_PriceHook_installed = true

local origGetPrice = nil

if EconomyManager and EconomyManager.getPricePerLiter then
    origGetPrice = EconomyManager.getPricePerLiter

    EconomyManager.getPricePerLiter = function(self, fillTypeIndex, ...)
        local price = origGetPrice(self, fillTypeIndex, ...)
        if type(price) ~= "number" or price <= 0 then return price end

        -- Dormant until MDM is fully initialized
        if not g_MarketDynamics or not g_MarketDynamics.isActive then
            return price
        end

        -- Respect the "Dynamic Prices" setting (ESC > Settings > General)
        if g_MarketDynamics.settings and not g_MarketDynamics.settings.pricesEnabled then
            return price
        end

        local mdmPrice = g_MarketDynamics.marketEngine:getPrice(fillTypeIndex)
        if mdmPrice and mdmPrice > 0 then
            return mdmPrice
        end

        return price
    end

    MDMLog.info("PriceHook: EconomyManager.getPricePerLiter hooked")
else
    MDMLog.warn("PriceHook: EconomyManager.getPricePerLiter not found — price hook disabled")
end

-- ---------------------------------------------------------------------------
-- Public helper for MarketEngine:init() base price snapshot
-- Returns vanilla price at neutral supply/demand pressure.
-- Safe to call before g_MarketDynamics.isActive because the hook guard above
-- lets the vanilla result pass through.
-- ---------------------------------------------------------------------------
function MDMGetVanillaPrice(economyManager, fillTypeIndex)
    if origGetPrice and economyManager then
        return origGetPrice(economyManager, fillTypeIndex, 0)
    end
    return nil
end
