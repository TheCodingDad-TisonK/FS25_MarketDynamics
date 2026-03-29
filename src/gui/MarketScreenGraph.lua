MDMMarketScreenGraph = {}

-- ---------------------------------------------------------------------------
-- Constants
-- ---------------------------------------------------------------------------

local SAMPLE_INTERVAL_MS = 20000
local MAX_SAMPLES        = 40

local COLOR_BG        = {0.05, 0.05, 0.08, 0.85}
local COLOR_GRID      = {0.25, 0.25, 0.30, 0.40}
local COLOR_LINE      = {0.20, 0.78, 0.85, 1.00}
local COLOR_AREA      = {0.0, 0.0, 0.0, 0.0}
local COLOR_DOT       = {1.00, 1.00, 1.00, 0.90}
local COLOR_LABEL     = {0.80, 0.80, 0.80, 0.90}

local GRID_LINES      = 6
local LINE_THICKNESS  = 3

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local _buffers     = {}
local _sampleTimer = 0

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

function MDMMarketScreenGraph.reset()
    _buffers     = {}
    _sampleTimer = 0
end

function MDMMarketScreenGraph.update(dt)
    if not g_MarketDynamics or not g_MarketDynamics.isActive then return end

    _sampleTimer = _sampleTimer + dt
    if _sampleTimer < SAMPLE_INTERVAL_MS then return end
    _sampleTimer = _sampleTimer - SAMPLE_INTERVAL_MS

    local engine = g_MarketDynamics.marketEngine
    if not engine then return end

    for fillTypeIndex, entry in pairs(engine.prices) do
        local buf = _buffers[fillTypeIndex]
        if not buf then
            buf = { samples = {}, head = 0, count = 0 }
            _buffers[fillTypeIndex] = buf
            MDMLog.info(string.format("MarketScreenGraph: seeded buffer for fillType %d with price %.2f", fillTypeIndex, entry.current))
        end

        buf.head = buf.head + 1
        if buf.head > MAX_SAMPLES then
            buf.head = 1
        end
        buf.samples[buf.head] = entry.current
        if buf.count < MAX_SAMPLES then
            buf.count = buf.count + 1
        end
    end
end

function MDMMarketScreenGraph.getSampleCount(fillTypeIndex)
    local buf = _buffers[fillTypeIndex]
    if not buf then return 0 end
    return buf.count
end

function MDMMarketScreenGraph.getGlobalSampleCount()
    local maxCount = 0
    for _, buf in pairs(_buffers) do
        if buf and buf.count and buf.count > maxCount then
            maxCount = buf.count
        end
    end
    return maxCount
end

-- ---------------------------------------------------------------------------
-- Extract ordered samples from a ring buffer
-- ---------------------------------------------------------------------------

local function _extractOrdered(buf)
    local ordered = {}
    local count = buf.count
    local start = buf.head - count + 1
    if start < 1 then start = start + MAX_SAMPLES end

    for i = 0, count - 1 do
        local idx = ((start - 1 + i) % MAX_SAMPLES) + 1
        local p = buf.samples[idx]
        if p then
            ordered[#ordered + 1] = p
        end
    end
    return ordered
end

-- ---------------------------------------------------------------------------
-- Draw line chart for a single commodity
-- ---------------------------------------------------------------------------

function MDMMarketScreenGraph.draw(fillTypeIndex, gx, gy, gw, gh)
    local buf = _buffers[fillTypeIndex]
    if not buf or buf.count < 2 then return end

    local ordered = _extractOrdered(buf)
    if #ordered < 2 then return end

    MDMMarketScreenGraph._drawLineChart(ordered, gx, gy, gw, gh)
end

-- ---------------------------------------------------------------------------
-- Aggregated median fallback (when no commodity selected)
-- ---------------------------------------------------------------------------

function MDMMarketScreenGraph.drawAggregatedMedian(gx, gy, gw, gh)
    local arrays = {}
    local maxCount = 0
    for _, buf in pairs(_buffers) do
        if buf and buf.count and buf.count > 0 then
            local ordered = _extractOrdered(buf)
            arrays[#arrays + 1] = ordered
            if #ordered > maxCount then maxCount = #ordered end
        end
    end

    if #arrays == 0 or maxCount < 2 then return end

    local agg = {}
    for i = 1, maxCount do
        local vals = {}
        for _, arr in ipairs(arrays) do
            if arr[i] ~= nil then vals[#vals + 1] = arr[i] end
        end
        if #vals > 0 then
            table.sort(vals)
            local n = #vals
            if n % 2 == 1 then
                agg[#agg + 1] = vals[math.floor((n + 1) / 2)]
            else
                local m = math.floor(n / 2)
                agg[#agg + 1] = (vals[m] + vals[m + 1]) / 2
            end
        end
    end

    if #agg < 2 then return end

    MDMMarketScreenGraph._drawLineChart(agg, gx, gy, gw, gh)
end

-- ---------------------------------------------------------------------------
-- Circle approximation helper (horizontal scanline approach)
-- ---------------------------------------------------------------------------

local CIRCLE_SLICES = 8

local function _drawFilledCircle(cx, cy, r, cr, cg, cb, ca)
    local step = (2 * r) / CIRCLE_SLICES
    for s = 0, CIRCLE_SLICES - 1 do
        local dy = -r + (s + 0.25) * step
        local halfW = math.sqrt(math.max(r * r - dy * dy, 0))
        drawFilledRect(cx - halfW, cy + dy, halfW * 1.5, step, cr, cg, cb, ca)
    end
end

-- ---------------------------------------------------------------------------
-- Line chart renderer (core) — uses drawFilledRect + drawLine2D
-- ---------------------------------------------------------------------------

function MDMMarketScreenGraph._drawLineChart(series, gx, gy, gw, gh)
    local n = #series
    if n < 2 then return end

    -- Find min/max
    local minP = math.huge
    local maxP = -math.huge
    for _, p in ipairs(series) do
        if p < minP then minP = p end
        if p > maxP then maxP = p end
    end
    if minP == math.huge then return end

    -- Price range with 10% padding
    local priceRange = maxP - minP
    if priceRange < 0.01 then priceRange = 0.01 end
    local padding = priceRange * 0.10
    local yMin = minP - padding
    local yMax = maxP + padding
    local yRange = yMax - yMin

    -- Background
    drawFilledRect(gx, gy, gw, gh, COLOR_BG[1], COLOR_BG[2], COLOR_BG[3], COLOR_BG[4])

    -- Grid lines + Y-axis labels
    local gridLineH = gh / 200  -- thin line
    for i = 0, GRID_LINES do
        local frac = i / GRID_LINES
        local ly = gy + frac * gh
        drawFilledRect(gx, ly, gw, gridLineH, COLOR_GRID[1], COLOR_GRID[2], COLOR_GRID[3], COLOR_GRID[4])

        -- Y-axis label
        local price = yMin + frac * yRange
        setTextColor(COLOR_LABEL[1], COLOR_LABEL[2], COLOR_LABEL[3], COLOR_LABEL[4])
        setTextBold(false)
        setTextAlignment(RenderText.ALIGN_RIGHT)

        local labelSize = math.max(gh * 0.020, 0.003)
        local labelStr = string.format("$%.0f", price * 1000)
        -- Rotate only when price integer part has 5+ digits (price*1000 >= 10000)
        if price * 1000 >= 10000 then
            local labelX = gx - 0.005
            setTextRotation(math.rad(30), labelX, ly)
            renderText(labelX, ly, labelSize, labelStr)
            setTextRotation(0, 0, 0)
        else
            renderText(gx - 0.01, ly, labelSize, labelStr)
        end
    end
    setTextAlignment(RenderText.ALIGN_LEFT)

    -- Compute screen positions for each data point
    local points = {}
    for i = 1, n do
        points[i] = {
            x = gx + ((i - 1) / (n - 1)) * gw,
            y = gy + ((series[i] - yMin) / yRange) * gh,
        }
    end

    -- Area fill: thin vertical bars from baseline to each point
    local sliceW = math.max(gw / (n - 1), 0.001)
    for i = 1, n do
        local barH = points[i].y - gy
        if barH > 0 then
            drawFilledRect(points[i].x - sliceW * 0.5, gy, sliceW, barH,
                        COLOR_AREA[1], COLOR_AREA[2], COLOR_AREA[3], COLOR_AREA[4])
        end
    end

    -- Line segments (drawLine2D)
    local thick = math.max(LINE_THICKNESS / g_screenHeight, 0.002)
    for i = 1, n - 1 do
        drawLine2D(points[i].x, points[i].y, points[i+1].x, points[i+1].y,
                thick, COLOR_LINE[1], COLOR_LINE[2], COLOR_LINE[3], COLOR_LINE[4])
    end

    -- Data point dots (circle approximation)
    local dotR = thick * 1.8
    for i = 1, n do
        _drawFilledCircle(points[i].x, points[i].y, dotR,
                        COLOR_DOT[1], COLOR_DOT[2], COLOR_DOT[3], COLOR_DOT[4])
    end
end
