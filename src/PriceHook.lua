-- PriceHook.lua
-- Monkeypatches EconomyManager.getPricePerLiter to route sell prices through
-- MDM's modifier stack at point of sale.
--
-- Installed at source() time. Uses a sentinel (_G.MDM_PriceHook_installed) so
-- re-sourcing is idempotent — the original function is only captured once.
--
-- Guard behaviour:
--   The hook is a no-op until g_MarketDynamics.isActive = true. This allows
--   MarketEngine:init() to call MDMGetVanillaPrice() safely during startup
--   (before MDM is active) and receive unmodified vanilla prices.
--
--   If coordinator.settings.pricesEnabled = false, the hook also passes through,
--   letting the player revert to vanilla prices without disabling the whole mod.
--
-- Public helper:
--   MDMGetVanillaPrice(economyManager, fillTypeIndex) → number | nil
--     Returns the vanilla sell price at neutral supply/demand (pressure = 0).
--     Used by MarketEngine:init() for base price snapshotting.
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

        -- Respect the "Dynamic Prices" setting (ESC > Settings > Market Dynamics)
        if g_MarketDynamics.settings and not g_MarketDynamics.settings.pricesEnabled then
            return price
        end

        local mdmPrice = g_MarketDynamics.marketEngine:getPrice(fillTypeIndex)
        if mdmPrice and mdmPrice > 0 then
            return mdmPrice
        end

        -- Fallback: fillType is not tracked by MDM (e.g. added by another mod)
        return price
    end

    MDMLog.info("PriceHook: EconomyManager.getPricePerLiter hooked")
else
    MDMLog.warn("PriceHook: EconomyManager.getPricePerLiter not found — price hook disabled")
end

-- ---------------------------------------------------------------------------
-- Public helper: vanilla price snapshot for MarketEngine:init()
-- ---------------------------------------------------------------------------

-- Returns the vanilla sell price for a fillType at neutral supply/demand pressure (0).
-- Safe to call before g_MarketDynamics.isActive because the hook guard above
-- passes through to origGetPrice while isActive is false.
-- Returns nil if origGetPrice was never captured (hook install failed).
function MDMGetVanillaPrice(economyManager, fillTypeIndex)
    if origGetPrice and economyManager then
        return origGetPrice(economyManager, fillTypeIndex, 0)
    end
    return nil
end
