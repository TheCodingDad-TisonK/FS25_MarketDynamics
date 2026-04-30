-- MDMEventSettingsDialog.lua
-- Event settings dialog: global toggles + per-event on/off + custom fill type editor.
--
-- Global section:
--   Events Enabled (on/off)
--   Event Frequency (Rare / Normal / Frequent)
--
-- Per-event section (10 rows, alphabetically sorted):
--   Event name | Enabled/Disabled toggle | Custom fill type count | [Edit] button
--   [Edit] opens MDMEventFillTypeDialog for that specific event.
--
-- All settings are applied immediately to g_MarketDynamics.settings and
-- persisted on the next game save via MarketSerializer.
--
-- Opened by MDMMarketScreen:onEventSettingsClick() from the Events tab.

MDMEventSettingsDialog = {}
local MDMEventSettingsDialog_mt = Class(MDMEventSettingsDialog, MessageDialog)

local MAX_EVENT_ROWS = 10
local FREQ_RARE      = 0.4
local FREQ_NORMAL    = 1.0
local FREQ_HIGH      = 2.0

function MDMEventSettingsDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or MDMEventSettingsDialog_mt)

    self.isOpen   = false
    self._onClose = nil

    -- Global section elements
    self.globalOffBg   = nil; self.globalOffBtn  = nil; self.globalOffTxt  = nil
    self.globalOnBg    = nil; self.globalOnBtn   = nil; self.globalOnTxt   = nil
    self.freqRareBg    = nil; self.freqRareBtn   = nil; self.freqRareTxt   = nil
    self.freqNormalBg  = nil; self.freqNormalBtn = nil; self.freqNormalTxt = nil
    self.freqHighBg    = nil; self.freqHighBtn   = nil; self.freqHighTxt   = nil

    -- Per-event row elements (indexed 0..9)
    self.rowNames     = {}
    self.rowTogBgs    = {}
    self.rowTogBtns   = {}
    self.rowTogTxts   = {}
    self.rowCounts    = {}
    self.rowEditBgs   = {}
    self.rowEditBtns  = {}
    self.rowEditTxts  = {}

    -- Sorted event list built at onOpen
    self._eventOrder = {}

    return self
end

function MDMEventSettingsDialog:setData(params)
    self._onClose = params and params.onClose
end

function MDMEventSettingsDialog:onCreate()
    local ok, err = pcall(function() MDMEventSettingsDialog:superClass().onCreate(self) end)
    if not ok then MDMLog.warn("MDMEventSettingsDialog:onCreate error: " .. tostring(err)) end
end

function MDMEventSettingsDialog:onGuiSetupFinished()
    MDMEventSettingsDialog:superClass().onGuiSetupFinished(self)

    -- Global elements
    self.globalOffBg  = self:getDescendantById("evtGlobalOffBg")
    self.globalOffBtn = self:getDescendantById("evtGlobalOffBtn")
    self.globalOffTxt = self:getDescendantById("evtGlobalOffTxt")
    self.globalOnBg   = self:getDescendantById("evtGlobalOnBg")
    self.globalOnBtn  = self:getDescendantById("evtGlobalOnBtn")
    self.globalOnTxt  = self:getDescendantById("evtGlobalOnTxt")

    self.freqRareBg    = self:getDescendantById("evtFreqRareBg")
    self.freqRareBtn   = self:getDescendantById("evtFreqRareBtn")
    self.freqRareTxt   = self:getDescendantById("evtFreqRareTxt")
    self.freqNormalBg  = self:getDescendantById("evtFreqNormalBg")
    self.freqNormalBtn = self:getDescendantById("evtFreqNormalBtn")
    self.freqNormalTxt = self:getDescendantById("evtFreqNormalTxt")
    self.freqHighBg    = self:getDescendantById("evtFreqHighBg")
    self.freqHighBtn   = self:getDescendantById("evtFreqHighBtn")
    self.freqHighTxt   = self:getDescendantById("evtFreqHighTxt")

    -- Per-event rows
    for i = 0, MAX_EVENT_ROWS - 1 do
        self.rowNames[i]    = self:getDescendantById("evtRowName"    .. i)
        self.rowTogBgs[i]   = self:getDescendantById("evtRowTogBg"   .. i)
        self.rowTogBtns[i]  = self:getDescendantById("evtRowTogBtn"  .. i)
        self.rowTogTxts[i]  = self:getDescendantById("evtRowTogTxt"  .. i)
        self.rowCounts[i]   = self:getDescendantById("evtRowCount"   .. i)
        self.rowEditBgs[i]  = self:getDescendantById("evtRowEditBg"  .. i)
        self.rowEditBtns[i] = self:getDescendantById("evtRowEditBtn" .. i)
        self.rowEditTxts[i] = self:getDescendantById("evtRowEditTxt" .. i)
    end
end

function MDMEventSettingsDialog:onOpen()
    MDMEventSettingsDialog:superClass().onOpen(self)
    self.isOpen     = true
    self._isPending = false

    -- Build sorted event list
    self._eventOrder = {}
    if g_MarketDynamics and g_MarketDynamics.worldEvents then
        for id, ev in pairs(g_MarketDynamics.worldEvents.registry) do
            table.insert(self._eventOrder, { id = id, name = ev.name or id })
        end
        table.sort(self._eventOrder, function(a, b) return a.name < b.name end)
    end

    self:_refreshGlobal()
    self:_refreshEventRows()
end

function MDMEventSettingsDialog:onClose()
    self.isOpen     = false
    self._isPending = false
    MDMEventSettingsDialog:superClass().onClose(self)
    if self._onClose then self._onClose() end
end

function MDMEventSettingsDialog:onCloseClick()
    self:close()
end

-- ── Global section ────────────────────────────────────────────────────────────

function MDMEventSettingsDialog:_refreshGlobal()
    local s = g_MarketDynamics and g_MarketDynamics.settings
    if not s then return end

    local enabled = s.eventsEnabled ~= false
    local freq    = s.eventFrequency or FREQ_NORMAL

    -- Events enabled toggle
    self:_styleToggle(self.globalOffBg, self.globalOffTxt, not enabled, false)
    self:_styleToggle(self.globalOnBg,  self.globalOnTxt,  enabled,     true)

    -- Frequency
    local isRare   = math.abs(freq - FREQ_RARE)   < 0.05
    local isNormal = math.abs(freq - FREQ_NORMAL) < 0.05
    local isHigh   = not isRare and not isNormal

    self:_styleToggle(self.freqRareBg,   self.freqRareTxt,   isRare,   true)
    self:_styleToggle(self.freqNormalBg, self.freqNormalTxt, isNormal, true)
    self:_styleToggle(self.freqHighBg,   self.freqHighTxt,   isHigh,   true)
end

-- Active: MDM green bg + white text. Inactive: dim bg + dim text.
function MDMEventSettingsDialog:_styleToggle(bgEl, txtEl, isActive, isPositive)
    if bgEl then
        if isActive then
            local r, g, b = isPositive and 0.0 or 0.35, isPositive and 0.42 or 0.08, isPositive and 0.22 or 0.08
            bgEl:setImageColor(nil, r, g, b, 1.0)
        else
            bgEl:setImageColor(nil, 0.14, 0.14, 0.14, 0.9)
        end
    end
    if txtEl then
        if isActive then
            txtEl:setTextColor(1.0, 1.0, 1.0, 1.0)
        else
            txtEl:setTextColor(0.50, 0.50, 0.50, 1.0)
        end
    end
end

function MDMEventSettingsDialog:onGlobalOffClick()
    if not g_MarketDynamics then return end
    g_MarketDynamics.settings.eventsEnabled = false
    self:_refreshGlobal()
end

function MDMEventSettingsDialog:onGlobalOnClick()
    if not g_MarketDynamics then return end
    g_MarketDynamics.settings.eventsEnabled = true
    self:_refreshGlobal()
end

function MDMEventSettingsDialog:onFreqRareClick()
    if not g_MarketDynamics then return end
    g_MarketDynamics.settings.eventFrequency = FREQ_RARE
    self:_refreshGlobal()
end

function MDMEventSettingsDialog:onFreqNormalClick()
    if not g_MarketDynamics then return end
    g_MarketDynamics.settings.eventFrequency = FREQ_NORMAL
    self:_refreshGlobal()
end

function MDMEventSettingsDialog:onFreqHighClick()
    if not g_MarketDynamics then return end
    g_MarketDynamics.settings.eventFrequency = FREQ_HIGH
    self:_refreshGlobal()
end

-- ── Per-event rows ────────────────────────────────────────────────────────────

function MDMEventSettingsDialog:_refreshEventRows()
    local s        = g_MarketDynamics and g_MarketDynamics.settings
    local disabled = (s and s.disabledEvents)         or {}
    local cft      = (s and s.eventCustomFillTypes)   or {}

    for i = 0, MAX_EVENT_ROWS - 1 do
        local entry  = self._eventOrder[i + 1]
        local hasRow = entry ~= nil

        -- Visibility
        if self.rowNames[i]    then self.rowNames[i]:setVisible(hasRow)    end
        if self.rowTogBgs[i]   then self.rowTogBgs[i]:setVisible(hasRow)   end
        if self.rowTogBtns[i]  then self.rowTogBtns[i]:setVisible(hasRow)  end
        if self.rowTogTxts[i]  then self.rowTogTxts[i]:setVisible(hasRow)  end
        if self.rowCounts[i]   then self.rowCounts[i]:setVisible(hasRow)   end
        if self.rowEditBgs[i]  then self.rowEditBgs[i]:setVisible(hasRow)  end
        if self.rowEditBtns[i] then self.rowEditBtns[i]:setVisible(hasRow) end
        if self.rowEditTxts[i] then self.rowEditTxts[i]:setVisible(hasRow) end

        if hasRow then
            local id          = entry.id
            local isDisabled  = disabled[id] == true
            local customCount = cft[id] and #cft[id] or 0

            -- Name
            if self.rowNames[i] then
                self.rowNames[i]:setText(entry.name)
                if isDisabled then
                    self.rowNames[i]:setTextColor(0.45, 0.45, 0.45, 1.0)
                else
                    self.rowNames[i]:setTextColor(1.0, 1.0, 1.0, 1.0)
                end
            end

            -- Toggle button
            if self.rowTogBgs[i] then
                if isDisabled then
                    self.rowTogBgs[i]:setImageColor(nil, 0.35, 0.08, 0.08, 0.9)
                else
                    self.rowTogBgs[i]:setImageColor(nil, 0.05, 0.38, 0.20, 0.9)
                end
            end
            if self.rowTogTxts[i] then
                if isDisabled then
                    self.rowTogTxts[i]:setText("Disabled")
                    self.rowTogTxts[i]:setTextColor(0.85, 0.38, 0.38, 1.0)
                else
                    self.rowTogTxts[i]:setText("Enabled")
                    self.rowTogTxts[i]:setTextColor(0.25, 0.82, 0.48, 1.0)
                end
            end

            -- Custom fill type count badge
            if self.rowCounts[i] then
                if customCount > 0 then
                    self.rowCounts[i]:setText("+" .. customCount)
                    self.rowCounts[i]:setTextColor(0.25, 0.72, 0.48, 1.0)
                else
                    self.rowCounts[i]:setText("")
                end
            end
        end
    end
end

function MDMEventSettingsDialog:_handleToggle(rowIndex)
    local entry = self._eventOrder[rowIndex + 1]
    if not entry or not g_MarketDynamics then return end

    local s = g_MarketDynamics.settings
    s.disabledEvents = s.disabledEvents or {}

    if s.disabledEvents[entry.id] then
        s.disabledEvents[entry.id] = nil
        MDMLog.info("MDMEventSettingsDialog: enabled event '" .. entry.id .. "'")
    else
        s.disabledEvents[entry.id] = true
        MDMLog.info("MDMEventSettingsDialog: disabled event '" .. entry.id .. "'")
    end

    self:_refreshEventRows()
end

function MDMEventSettingsDialog:_handleEdit(rowIndex)
    local entry = self._eventOrder[rowIndex + 1]
    if not entry then return end

    MDMDialogLoader.show("MDMEventFillTypeDialog", "setData", {
        eventId   = entry.id,
        eventName = entry.name,
        onDone    = function()
            self:_refreshEventRows()
        end,
    })
end

-- ── Per-row click handlers ────────────────────────────────────────────────────

function MDMEventSettingsDialog:onToggle0() self:_handleToggle(0) end
function MDMEventSettingsDialog:onToggle1() self:_handleToggle(1) end
function MDMEventSettingsDialog:onToggle2() self:_handleToggle(2) end
function MDMEventSettingsDialog:onToggle3() self:_handleToggle(3) end
function MDMEventSettingsDialog:onToggle4() self:_handleToggle(4) end
function MDMEventSettingsDialog:onToggle5() self:_handleToggle(5) end
function MDMEventSettingsDialog:onToggle6() self:_handleToggle(6) end
function MDMEventSettingsDialog:onToggle7() self:_handleToggle(7) end
function MDMEventSettingsDialog:onToggle8() self:_handleToggle(8) end
function MDMEventSettingsDialog:onToggle9() self:_handleToggle(9) end

function MDMEventSettingsDialog:onEdit0() self:_handleEdit(0) end
function MDMEventSettingsDialog:onEdit1() self:_handleEdit(1) end
function MDMEventSettingsDialog:onEdit2() self:_handleEdit(2) end
function MDMEventSettingsDialog:onEdit3() self:_handleEdit(3) end
function MDMEventSettingsDialog:onEdit4() self:_handleEdit(4) end
function MDMEventSettingsDialog:onEdit5() self:_handleEdit(5) end
function MDMEventSettingsDialog:onEdit6() self:_handleEdit(6) end
function MDMEventSettingsDialog:onEdit7() self:_handleEdit(7) end
function MDMEventSettingsDialog:onEdit8() self:_handleEdit(8) end
function MDMEventSettingsDialog:onEdit9() self:_handleEdit(9) end
