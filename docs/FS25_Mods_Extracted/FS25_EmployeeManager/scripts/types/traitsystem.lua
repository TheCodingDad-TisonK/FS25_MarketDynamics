---@class TraitSystem
--- Multi-trait support system. Employees can have up to 2 traits.
--- Multipliers from multiple traits are combined multiplicatively.
TraitSystem = {}

TraitSystem.MAX_TRAITS = 2

TraitSystem.TRAITS = {
    CAREFUL       = { nameKey = "em_trait_careful",       wearMult = 0.85 },
    RECKLESS      = { nameKey = "em_trait_reckless",      wearMult = 1.20, speedMult = 1.10 },
    FUEL_SAVER    = { nameKey = "em_trait_fuel_saver",    fuelMult = 0.85 },
    QUICK_LEARNER = { nameKey = "em_trait_quick_learner", xpMult = 1.50 },
    HARD_WORKER   = { nameKey = "em_trait_hard_worker",   speedMult = 1.10 },
    FRUGAL        = { nameKey = "em_trait_frugal",        wageMult = 0.90 },
}

---Computes the combined multiplier for a property across all traits
---@param traits table Array of trait keys, e.g. {"CAREFUL", "FRUGAL"}
---@param property string e.g. "wearMult", "fuelMult", "xpMult", "wageMult", "speedMult"
---@return number Combined multiplier (multiplicative)
function TraitSystem.getMultiplier(traits, property)
    if traits == nil or #traits == 0 then return 1.0 end

    local result = 1.0
    for _, traitKey in ipairs(traits) do
        local def = TraitSystem.TRAITS[traitKey]
        if def and def[property] then
            result = result * def[property]
        end
    end
    return result
end

---Returns localized names of the employee's traits
---@param traits table Array of trait keys
---@return string Comma-separated localized names, or nil if no traits
function TraitSystem.getTraitNames(traits)
    if traits == nil or #traits == 0 then return nil end

    local names = {}
    for _, traitKey in ipairs(traits) do
        local def = TraitSystem.TRAITS[traitKey]
        if def then
            table.insert(names, g_i18n:getText(def.nameKey))
        else
            table.insert(names, traitKey)
        end
    end
    return table.concat(names, ", ")
end

---Selects up to MAX_TRAITS random traits from a list of possible traits
---@param possibleTraits table Array of trait key strings
---@return table Array of selected trait keys
function TraitSystem.selectTraits(possibleTraits)
    if possibleTraits == nil or #possibleTraits == 0 then return {} end

    local pool = {}
    for _, t in ipairs(possibleTraits) do
        if TraitSystem.TRAITS[t] then
            table.insert(pool, t)
        end
    end

    local count = math.min(TraitSystem.MAX_TRAITS, #pool)
    if count == #pool then return pool end

    local selected = {}
    for _ = 1, count do
        local idx = math.random(#pool)
        table.insert(selected, pool[idx])
        table.remove(pool, idx)
    end
    return selected
end

---Serializes traits to a comma-separated string for save/stream
---@param traits table Array of trait keys
---@return string
function TraitSystem.serialize(traits)
    if traits == nil or #traits == 0 then return "" end
    return table.concat(traits, ",")
end

---Deserializes a comma-separated string to traits array
---@param str string Comma-separated trait keys, or single trait key (migration)
---@return table Array of trait keys
function TraitSystem.deserialize(str)
    if str == nil or str == "" then return {} end

    local traits = {}
    for trait in str:gmatch("[^,]+") do
        trait = trait:match("^%s*(.-)%s*$")
        if trait ~= "" and TraitSystem.TRAITS[trait] then
            table.insert(traits, trait)
        end
    end
    return traits
end

return TraitSystem
