RentIncome = {}
RentIncome.MOD_NAME = g_currentModName
RentIncome.MOD_DIR = g_currentModDirectory .. "scripts/" 

local RentIncome_mt = Class(RentIncome)

function RentIncome:new()
    local self = setmetatable({}, RentIncome_mt)
    self.isEnabled = true
    self.houses = {}
    self.lastPayDay = -1
    self.hasRunToday = false
    self.menuVisible = false
    self.editMode = nil
    self.inputBuffer = ""
    self.hoverButton = nil
    self.mouseX = 0
    self.mouseY = 0
    self.paymentHistory = {}
    self.scrollOffset = 0
    self.historyScrollOffset = 0
    return self
end

function RentIncome:loadMap(name)
    self.isClient = g_client ~= nil
    self.isServer = g_server ~= nil
    if g_currentMission and g_currentMission.environment then
        self.lastPayDay = g_currentMission.environment.currentDay or 0
    end
    self:loadSettings()
    
    -- Hook into game's save system
    if g_currentMission then
        FSBaseMission.saveSavegame = Utils.appendedFunction(FSBaseMission.saveSavegame, function()
            if g_rentIncome then
                g_rentIncome:saveSettings()
                print("RentIncome: Saved with game save")
            end
        end)
    end
end

function RentIncome:deleteMap()
    self:saveSettings()
end

function RentIncome:onWriteStream(streamId, connection)
    if self.isServer then
        self:saveSettings()
    end
end

function RentIncome:onReadStream(streamId, connection)
    self:loadSettings()
end

function RentIncome:getSavegameDirectory()
    if g_currentMission and g_currentMission.missionInfo and g_currentMission.missionInfo.savegameDirectory then
        return g_currentMission.missionInfo.savegameDirectory
    end
    return nil
end

function RentIncome:saveSettings()
    local savegameDir = self:getSavegameDirectory()
    if not savegameDir then 
        print("RentIncome: Warning - No savegame directory found")
        return 
    end
    
    local filePath = savegameDir .. "/rentIncome.xml"
    local xmlFile = createXMLFile("rentIncomeXML", filePath, "rentIncome")
    
    if xmlFile and xmlFile ~= 0 then
        setXMLBool(xmlFile, "rentIncome.isEnabled", self.isEnabled)
        setXMLInt(xmlFile, "rentIncome.lastPayDay", self.lastPayDay)
        
        for i, house in ipairs(self.houses) do
            local key = string.format("rentIncome.houses.house(%d)", i - 1)
            setXMLString(xmlFile, key .. "#name", house.name)
            setXMLInt(xmlFile, key .. "#rent", house.rent)
            setXMLInt(xmlFile, key .. "#paymentInterval", house.paymentInterval)
            setXMLInt(xmlFile, key .. "#lastPaymentDay", house.lastPaymentDay)
        end
        
        for i, payment in ipairs(self.paymentHistory) do
            local key = string.format("rentIncome.history.payment(%d)", i - 1)
            setXMLInt(xmlFile, key .. "#day", payment.day)
            setXMLInt(xmlFile, key .. "#amount", payment.amount)
            setXMLInt(xmlFile, key .. "#properties", payment.properties)
        end
        
        local success = saveXMLFile(xmlFile)
        delete(xmlFile)
        
        if success then
            print(string.format("RentIncome: Saved %d houses and %d payment records", #self.houses, #self.paymentHistory))
        else
            print("RentIncome: Warning - Failed to save XML file")
        end
    else
        print("RentIncome: Error - Could not create XML file")
    end
end

function RentIncome:loadSettings()
    local savegameDir = self:getSavegameDirectory()
    if not savegameDir then 
        print("RentIncome: Warning - No savegame directory found for loading")
        return 
    end
    
    local filePath = savegameDir .. "/rentIncome.xml"
    if not fileExists(filePath) then 
        print("RentIncome: No save file found, starting fresh")
        return 
    end
    
    local xmlFile = loadXMLFile("rentIncomeXML", filePath)
    
    if xmlFile and xmlFile ~= 0 then
        self.isEnabled = Utils.getNoNil(getXMLBool(xmlFile, "rentIncome.isEnabled"), true)
        self.lastPayDay = Utils.getNoNil(getXMLInt(xmlFile, "rentIncome.lastPayDay"), -1)
        
        self.houses = {}
        local i = 0
        while true do
            local key = string.format("rentIncome.houses.house(%d)", i)
            if not hasXMLProperty(xmlFile, key) then break end
            
            local house = {
                name = getXMLString(xmlFile, key .. "#name") or "House " .. (i + 1),
                rent = getXMLInt(xmlFile, key .. "#rent") or 750,
                paymentInterval = getXMLInt(xmlFile, key .. "#paymentInterval") or 1,
                lastPaymentDay = getXMLInt(xmlFile, key .. "#lastPaymentDay") or -1
            }
            table.insert(self.houses, house)
            i = i + 1
        end
        
        self.paymentHistory = {}
        i = 0
        while true do
            local key = string.format("rentIncome.history.payment(%d)", i)
            if not hasXMLProperty(xmlFile, key) then break end
            
            local payment = {
                day = getXMLInt(xmlFile, key .. "#day") or 0,
                amount = getXMLInt(xmlFile, key .. "#amount") or 0,
                properties = getXMLInt(xmlFile, key .. "#properties") or 0
            }
            table.insert(self.paymentHistory, payment)
            i = i + 1
        end
        
        delete(xmlFile)
        print(string.format("RentIncome: Loaded %d houses and %d payment records", #self.houses, #self.paymentHistory))
    else
        print("RentIncome: Error - Could not load XML file")
    end
end

function RentIncome:addPaymentToHistory(day, amount, properties)
    table.insert(self.paymentHistory, 1, {
        day = day,
        amount = amount,
        properties = properties
    })
    
    while #self.paymentHistory > 50 do
        table.remove(self.paymentHistory)
    end
    
    self:saveSettings()
end

function RentIncome:closeMenu()
    self.menuVisible = false
    self.editMode = nil
    self.inputBuffer = ""
    self.hoverButton = nil
    self.scrollOffset = 0
    self.historyScrollOffset = 0
    g_inputBinding:setShowMouseCursor(false)
    -- Force save when closing menu
    self:saveSettings()
end

function RentIncome:resetHistory()
    self.paymentHistory = {}
    self:saveSettings()
end

function RentIncome:onOpenMenu()
    if self.menuVisible then
        self:closeMenu()
    else
        self.menuVisible = true
        g_inputBinding:setShowMouseCursor(true)
    end
end

function RentIncome:onToggleRentIncome()
    self.isEnabled = not self.isEnabled
    self:saveSettings()
end

function RentIncome:addNewHouse()
    local newHouse = {
        name = "House " .. (#self.houses + 1),
        rent = 750,
        paymentInterval = 1,
        lastPaymentDay = -1
    }
    table.insert(self.houses, newHouse)
    self:saveSettings()
end

function RentIncome:deleteHouse(index)
    if index > 0 and index <= #self.houses then
        table.remove(self.houses, index)
        self:saveSettings()
    end
end

function RentIncome:changeInterval(index, delta)
    if index > 0 and index <= #self.houses then
        local house = self.houses[index]
        house.paymentInterval = house.paymentInterval + delta
        if house.paymentInterval < 1 then house.paymentInterval = 1 end
        if house.paymentInterval > 30 then house.paymentInterval = 30 end
        self:saveSettings()
    end
end

function RentIncome:keyEvent(unicode, sym, modifier, isDown)
    if not self.menuVisible then return false end
    if not isDown then return true end
    
    if self.editMode then
        if sym == Input.KEY_escape then
            self.editMode = nil
            self.inputBuffer = ""
        elseif sym == Input.KEY_return or sym == Input.KEY_KP_enter then
            if self.editMode == "name" and #self.inputBuffer > 0 then
                self.houses[self.editMode_index].name = self.inputBuffer
                self:saveSettings()
            elseif self.editMode == "rent" then
                local value = tonumber(self.inputBuffer)
                if value and value >= 0 then
                    self.houses[self.editMode_index].rent = value
                    self:saveSettings()
                end
            elseif self.editMode == "interval" then
                local value = tonumber(self.inputBuffer)
                if value and value >= 1 and value <= 30 then
                    self.houses[self.editMode_index].paymentInterval = value
                    self:saveSettings()
                end
            end
            self.editMode = nil
            self.inputBuffer = ""
        elseif sym == Input.KEY_backspace then
            if #self.inputBuffer > 0 then
                self.inputBuffer = string.sub(self.inputBuffer, 1, -2)
            end
        elseif self.editMode == "name" then
            if unicode and unicode >= 32 and unicode <= 126 and #self.inputBuffer < 20 then
                self.inputBuffer = self.inputBuffer .. string.char(unicode)
            end
        elseif self.editMode == "rent" or self.editMode == "interval" then
            if unicode and unicode >= 48 and unicode <= 57 and #self.inputBuffer < 8 then
                self.inputBuffer = self.inputBuffer .. string.char(unicode)
            end
        end
        return true
    end
    
    return true
end

function RentIncome:mouseEvent(posX, posY, isDown, isUp, button)
    if not self.menuVisible then return false end
    
    self.mouseX = posX
    self.mouseY = posY
    
    if self.editMode then return true end
    
    -- Properties list scrolling
    if posX >= 0.03 and posX <= 0.96 and posY >= 0.35 and posY <= 0.78 then
        if button == Input.MOUSE_BUTTON_WHEEL_UP then
            self.scrollOffset = math.max(0, self.scrollOffset - 1)
            return true
        elseif button == Input.MOUSE_BUTTON_WHEEL_DOWN then
            local maxScroll = math.max(0, #self.houses - 8)
            self.scrollOffset = math.min(maxScroll, self.scrollOffset + 1)
            return true
        end
    end
    
    -- History scrolling
    if posX >= 0.03 and posX <= 0.96 and posY >= 0.06 and posY <= 0.27 then
        if button == Input.MOUSE_BUTTON_WHEEL_UP then
            self.historyScrollOffset = math.max(0, self.historyScrollOffset - 1)
            return true
        elseif button == Input.MOUSE_BUTTON_WHEEL_DOWN then
            local maxScroll = math.max(0, #self.paymentHistory - 5)
            self.historyScrollOffset = math.min(maxScroll, self.historyScrollOffset + 1)
            return true
        end
    end
    
    if not isDown or button ~= Input.MOUSE_BUTTON_LEFT then return true end
    
    -- Top bar buttons
    if posY >= 0.935 and posY <= 0.975 then
        if posX >= 0.83 and posX <= 0.905 then
            self.isEnabled = not self.isEnabled
            self:saveSettings()
            return true
        elseif posX >= 0.915 and posX <= 0.99 then
            self:addNewHouse()
            return true
        end
    end
    
    -- Reset history button
    if posY >= 0.280 and posY <= 0.315 then
        if posX >= 0.85 and posX <= 0.95 then
            self:resetHistory()
            return true
        end
    end
    
    -- Properties list
    local listTop = 0.76
    local rowHeight = 0.045
    
    for i = 1, math.min(8, #self.houses - self.scrollOffset) do
        local houseIndex = i + self.scrollOffset
        local rowY = listTop - ((i - 1) * rowHeight)
        
        if posY >= rowY - rowHeight + 0.005 and posY <= rowY + 0.005 then
            if posX >= 0.05 and posX <= 0.30 then
                self.editMode = "name"
                self.editMode_index = houseIndex
                self.inputBuffer = self.houses[houseIndex].name
            elseif posX >= 0.32 and posX <= 0.47 then
                self.editMode = "rent"
                self.editMode_index = houseIndex
                self.inputBuffer = tostring(self.houses[houseIndex].rent)
            elseif posX >= 0.49 and posX <= 0.60 then
                self.editMode = "interval"
                self.editMode_index = houseIndex
                self.inputBuffer = tostring(self.houses[houseIndex].paymentInterval)
            elseif posX >= 0.62 and posX <= 0.67 then
                self:changeInterval(houseIndex, -1)
            elseif posX >= 0.68 and posX <= 0.73 then
                self:changeInterval(houseIndex, 1)
            elseif posX >= 0.88 and posX <= 0.95 then
                self:deleteHouse(houseIndex)
            end
            return true
        end
    end
    
    -- Click outside closes menu
    if posX < 0.02 or posX > 0.98 or posY < 0.02 or posY > 0.98 then
        self:closeMenu()
    end
    
    return true
end

function RentIncome:updateHover()
    if not self.menuVisible or self.editMode then 
        self.hoverButton = nil
        return 
    end
    
    local posX = self.mouseX
    local posY = self.mouseY
    
    self.hoverButton = nil
    
    -- Top bar
    if posY >= 0.935 and posY <= 0.975 then
        if posX >= 0.83 and posX <= 0.905 then
            self.hoverButton = "enable"
        elseif posX >= 0.915 and posX <= 0.99 then
            self.hoverButton = "add"
        end
        return
    end
    
    -- Reset history button
    if posY >= 0.280 and posY <= 0.315 then
        if posX >= 0.85 and posX <= 0.95 then
            self.hoverButton = "reset_history"
        end
        return
    end
    
    -- Properties
    local listTop = 0.76
    local rowHeight = 0.045
    
    for i = 1, math.min(8, #self.houses - self.scrollOffset) do
        local houseIndex = i + self.scrollOffset
        local rowY = listTop - ((i - 1) * rowHeight)
        
        if posY >= rowY - rowHeight + 0.005 and posY <= rowY + 0.005 then
            if posX >= 0.05 and posX <= 0.30 then
                self.hoverButton = "name_" .. houseIndex
            elseif posX >= 0.32 and posX <= 0.47 then
                self.hoverButton = "rent_" .. houseIndex
            elseif posX >= 0.49 and posX <= 0.60 then
                self.hoverButton = "interval_" .. houseIndex
            elseif posX >= 0.62 and posX <= 0.67 then
                self.hoverButton = "minus_" .. houseIndex
            elseif posX >= 0.68 and posX <= 0.73 then
                self.hoverButton = "plus_" .. houseIndex
            elseif posX >= 0.88 and posX <= 0.95 then
                self.hoverButton = "delete_" .. houseIndex
            end
            return
        end
    end
end

function RentIncome:draw()
    if not self.menuVisible then return end
    
    self:updateHover()
    
    -- Fullscreen dark overlay
    drawFilledRect(0, 0, 1, 1, 0, 0, 0, 0.85)
    
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
    
    -- ===== TOP BAR =====
    drawFilledRect(0, 0.92, 1, 0.08, 0.08, 0.08, 0.08, 1)
    drawFilledRect(0, 0.915, 1, 0.005, 0.533, 0.729, 0.067, 1)
    
    -- Title with icon background (centered text)
    drawFilledRect(0.02, 0.935, 0.15, 0.04, 0.533, 0.729, 0.067, 1)
    setTextBold(true)
    setTextColor(0.05, 0.05, 0.05, 1)
    setTextAlignment(RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
    renderText(0.095, 0.955, 0.020, "RENT INCOME")
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextBold(false)
    
    -- Stats
    local dailyIncome = 0
    for _, house in ipairs(self.houses) do
        dailyIncome = dailyIncome + (house.rent / house.paymentInterval)
    end
    
    setTextColor(0.7, 0.7, 0.7, 1)
    renderText(0.20, 0.955, 0.014, "DAILY INCOME:")
    setTextColor(0.533, 0.729, 0.067, 1)
    setTextBold(true)
    renderText(0.33, 0.954, 0.016, string.format("$%s", self:formatNumber(math.floor(dailyIncome))))
    setTextBold(false)
    
    setTextColor(0.7, 0.7, 0.7, 1)
    renderText(0.47, 0.955, 0.014, "PROPERTIES:")
    setTextColor(1, 1, 1, 1)
    setTextBold(true)
    renderText(0.57, 0.955, 0.014, tostring(#self.houses))
    setTextBold(false)
    
    setTextColor(0.7, 0.7, 0.7, 1)
    renderText(0.63, 0.955, 0.014, "STATUS:")
    if self.isEnabled then
        setTextColor(0.533, 0.729, 0.067, 1)
        renderText(0.70, 0.955, 0.014, "ACTIVE")
    else
        setTextColor(1, 0.4, 0.4, 1)
        renderText(0.70, 0.955, 0.014, "INACTIVE")
    end
    
    -- Top buttons (centered text)
    local enableHover = self.hoverButton == "enable"
    drawFilledRect(0.83, 0.935, 0.075, 0.04, 0.9906, 0.4405, 0.0028, enableHover and 0.85 or 1)
    setTextColor(0.05, 0.05, 0.05, 1)
    setTextBold(true)
    setTextAlignment(RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
    renderText(0.8675, 0.955, 0.013, self.isEnabled and "DISABLE" or "ENABLE")
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextBold(false)
    
    local addHover = self.hoverButton == "add"
    drawFilledRect(0.915, 0.935, 0.075, 0.04, 0.9906, 0.4405, 0.0028, addHover and 0.85 or 1)
    setTextColor(0.05, 0.05, 0.05, 1)
    setTextBold(true)
    setTextAlignment(RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
    renderText(0.9525, 0.955, 0.013, "+ ADD")
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextBold(false)
    
    -- ===== MAIN CONTENT =====
    drawFilledRect(0.02, 0.04, 0.96, 0.86, 0.12, 0.12, 0.12, 0.98)
    
    -- Properties section header
    drawFilledRect(0.03, 0.79, 0.93, 0.09, 0.08, 0.08, 0.08, 1)
    drawFilledRect(0.03, 0.785, 0.93, 0.003, 0.9906, 0.4405, 0.0028, 1)
    
    setTextBold(true)
    setTextColor(1, 1, 1, 1)
    renderText(0.05, 0.805, 0.015, "PROPERTY NAME")
    renderText(0.32, 0.805, 0.015, "RENT AMOUNT")
    renderText(0.49, 0.805, 0.015, "INTERVAL")
    renderText(0.75, 0.805, 0.015, "ACTIONS")
    setTextBold(false)
    
    -- Properties list area with scrollbar
    local listTop = 0.76
    local rowHeight = 0.045
    local visibleRows = 8
    
    for i = 1, math.min(visibleRows, #self.houses - self.scrollOffset) do
        local houseIndex = i + self.scrollOffset
        local house = self.houses[houseIndex]
        local rowY = listTop - ((i - 1) * rowHeight)
        
        if i % 2 == 1 then
            drawFilledRect(0.04, rowY - rowHeight + 0.005, 0.91, rowHeight - 0.005, 0.15, 0.15, 0.15, 0.6)
        end
        
        -- Name
        if self.editMode == "name" and self.editMode_index == houseIndex then
            setTextColor(0.9906, 0.4405, 0.0028, 1)
            renderText(0.05, rowY - 0.015, 0.014, self.inputBuffer .. "|")
        else
            setTextColor(self.hoverButton == "name_" .. houseIndex and 0.9906 or 1, 
                         self.hoverButton == "name_" .. houseIndex and 0.4405 or 1, 
                         self.hoverButton == "name_" .. houseIndex and 0.0028 or 1, 1)
            renderText(0.05, rowY - 0.015, 0.014, house.name)
        end
        
        -- Rent
        if self.editMode == "rent" and self.editMode_index == houseIndex then
            setTextColor(0.9906, 0.4405, 0.0028, 1)
            renderText(0.32, rowY - 0.015, 0.014, "$" .. self.inputBuffer .. "|")
        else
            setTextColor(self.hoverButton == "rent_" .. houseIndex and 0.733 or 0.533, 
                         self.hoverButton == "rent_" .. houseIndex and 0.929 or 0.729, 
                         self.hoverButton == "rent_" .. houseIndex and 0.267 or 0.067, 1)
            renderText(0.32, rowY - 0.015, 0.014, string.format("$%s", self:formatNumber(house.rent)))
        end
        
        -- Interval
        if self.editMode == "interval" and self.editMode_index == houseIndex then
            setTextColor(0.9906, 0.4405, 0.0028, 1)
            renderText(0.49, rowY - 0.015, 0.014, self.inputBuffer .. " days |")
        else
            setTextColor(1, 1, 1, 1)
            renderText(0.49, rowY - 0.015, 0.014, string.format("%d days", house.paymentInterval))
        end
        
        -- Action buttons
        local btnY = rowY - 0.028
        
        -- Minus button (centered)
        drawFilledRect(0.62, btnY, 0.045, 0.028, 0.8, 0.3, 0.3, self.hoverButton == "minus_" .. houseIndex and 1 or 0.85)
        setTextColor(1, 1, 1, 1)
        setTextBold(true)
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
        renderText(0.6425, btnY + 0.014, 0.016, "-")
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextBold(false)
        
        -- Plus button (centered)
        drawFilledRect(0.68, btnY, 0.045, 0.028, 0.3, 0.8, 0.3, self.hoverButton == "plus_" .. houseIndex and 1 or 0.85)
        setTextColor(1, 1, 1, 1)
        setTextBold(true)
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
        renderText(0.7025, btnY + 0.014, 0.016, "+")
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextBold(false)
        
        -- Delete button (centered)
        drawFilledRect(0.88, btnY, 0.07, 0.028, 0.9906, 0.4405, 0.0028, self.hoverButton == "delete_" .. houseIndex and 0.85 or 1)
        setTextColor(0.05, 0.05, 0.05, 1)
        setTextBold(true)
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
        renderText(0.915, btnY + 0.014, 0.012, "DELETE")
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextBold(false)
    end
    
    -- Scrollbar for properties
    if #self.houses > visibleRows then
        local scrollbarX = 0.955
        local scrollbarY = 0.36
        local scrollbarHeight = 0.4
        local scrollbarWidth = 0.008
        
        -- Scrollbar background
        drawFilledRect(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, 0.2, 0.2, 0.2, 0.7)
        
        -- Scrollbar thumb
        local thumbHeight = (visibleRows / #self.houses) * scrollbarHeight
        local thumbY = scrollbarY + ((self.scrollOffset / (#self.houses - visibleRows)) * (scrollbarHeight - thumbHeight))
        drawFilledRect(scrollbarX, thumbY, scrollbarWidth, thumbHeight, 0.533, 0.729, 0.067, 1)
    end
    
    -- Scroll indicator text
    if #self.houses > visibleRows then
        setTextColor(0.6, 0.6, 0.6, 1)
        setTextAlignment(RenderText.ALIGN_CENTER)
        renderText(0.5, 0.345, 0.011, string.format("Showing %d-%d of %d properties", 
            self.scrollOffset + 1, 
            math.min(self.scrollOffset + visibleRows, #self.houses), 
            #self.houses))
        setTextAlignment(RenderText.ALIGN_LEFT)
    end
    
    -- ===== PAYMENT HISTORY =====
    drawFilledRect(0.03, 0.28, 0.93, 0.05, 0.08, 0.08, 0.08, 1)
    drawFilledRect(0.03, 0.325, 0.93, 0.003, 0.9906, 0.4405, 0.0028, 1)
    
    setTextBold(true)
    setTextColor(1, 1, 1, 1)
    renderText(0.05, 0.295, 0.015, "RECENT PAYMENTS")
    setTextBold(false)
    
    -- Reset history button
    local resetHover = self.hoverButton == "reset_history"
    drawFilledRect(0.85, 0.285, 0.10, 0.030, 0.9906, 0.4405, 0.0028, resetHover and 0.85 or 1)
    setTextColor(0.05, 0.05, 0.05, 1)
    setTextBold(true)
    setTextAlignment(RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
    renderText(0.90, 0.300, 0.011, "RESET HISTORY")
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextBold(false)
    
    -- Column headers
    setTextColor(0.7, 0.7, 0.7, 1)
    renderText(0.06, 0.265, 0.010, "DAY")
    renderText(0.25, 0.265, 0.010, "AMOUNT")
    renderText(0.60, 0.265, 0.010, "PROPERTIES")
    
    drawFilledRect(0.04, 0.06, 0.91, 0.21, 0.08, 0.08, 0.08, 0.95)
    
    if #self.paymentHistory > 0 then
        local histTop = 0.25
        local histHeight = 0.035
        local visibleHistory = 5
        
        for i = 1, math.min(visibleHistory, #self.paymentHistory - self.historyScrollOffset) do
            local historyIndex = i + self.historyScrollOffset
            local payment = self.paymentHistory[historyIndex]
            local entryY = histTop - ((i - 1) * histHeight)
            
            if i % 2 == 1 then
                drawFilledRect(0.045, entryY - histHeight + 0.002, 0.90, histHeight - 0.004, 0.15, 0.15, 0.15, 0.4)
            end
            
            setTextColor(0.8, 0.8, 0.8, 1)
            renderText(0.06, entryY - 0.014, 0.013, string.format("Day %d", payment.day))
            
            setTextColor(0.533, 0.729, 0.067, 1)
            setTextBold(true)
            renderText(0.25, entryY - 0.015, 0.014, string.format("$%s", self:formatNumber(payment.amount)))
            setTextBold(false)
            
            setTextColor(0.7, 0.7, 0.7, 1)
            renderText(0.60, entryY - 0.014, 0.013, string.format("%d propert%s", payment.properties, payment.properties == 1 and "y" or "ies"))
        end
        
        -- Scrollbar for history
        if #self.paymentHistory > visibleHistory then
            local scrollbarX = 0.945
            local scrollbarY = 0.065
            local scrollbarHeight = 0.18
            local scrollbarWidth = 0.008
            
            -- Scrollbar background
            drawFilledRect(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, 0.2, 0.2, 0.2, 0.7)
            
            -- Scrollbar thumb
            local thumbHeight = (visibleHistory / #self.paymentHistory) * scrollbarHeight
            local thumbY = scrollbarY + ((self.historyScrollOffset / (#self.paymentHistory - visibleHistory)) * (scrollbarHeight - thumbHeight))
            drawFilledRect(scrollbarX, thumbY, scrollbarWidth, thumbHeight, 0.9906, 0.4405, 0.0028, 1)
        end
        
        -- Scroll indicator
        if #self.paymentHistory > visibleHistory then
            setTextColor(0.6, 0.6, 0.6, 1)
            setTextAlignment(RenderText.ALIGN_CENTER)
            renderText(0.5, 0.052, 0.009, string.format("Showing %d-%d of %d payments", 
                self.historyScrollOffset + 1,
                math.min(self.historyScrollOffset + visibleHistory, #self.paymentHistory),
                #self.paymentHistory))
            setTextAlignment(RenderText.ALIGN_LEFT)
        end
    else
        setTextColor(0.5, 0.5, 0.5, 1)
        setTextAlignment(RenderText.ALIGN_CENTER)
        renderText(0.5, 0.15, 0.014, "No payment history yet")
        setTextAlignment(RenderText.ALIGN_LEFT)
    end
    
    -- ===== FOOTER =====
    drawFilledRect(0, 0, 1, 0.035, 0.08, 0.08, 0.08, 1)
    drawFilledRect(0, 0.035, 1, 0.003, 0.9906, 0.4405, 0.0028, 1)
    
    setTextColor(0.6, 0.6, 0.6, 1)
    if self.editMode then
        renderText(0.02, 0.012, 0.011, "ENTER to save")
    else
        renderText(0.02, 0.012, 0.011, "Click fields to edit - Scroll to view more")
    end
    
    setTextColor(0.9906, 0.4405, 0.0028, 1)
    setTextAlignment(RenderText.ALIGN_RIGHT)
    renderText(0.98, 0.012, 0.011, "SHIFT + ; to toggle menu")
    setTextAlignment(RenderText.ALIGN_LEFT)
end

function RentIncome:formatNumber(num)
    local formatted = tostring(num)
    local k
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function RentIncome:update(dt)
    if not self or not self.isServer then return end
    
    if g_currentMission and g_currentMission.environment then
        local currentDay = g_currentMission.environment.currentDay or 0
        local currentHour = g_currentMission.environment.currentHour or 0
        
        if currentDay ~= self.lastPayDay then
            self.hasRunToday = false
            self.lastPayDay = currentDay
            self:saveSettings() -- Save when day changes
        end
        
        if currentHour >= 10 and not self.hasRunToday then
            self:payRent()
            self.hasRunToday = true
        end
    end
end

function RentIncome:payRent()
    if not self.isEnabled then return end
    if #self.houses == 0 then return end
    
    local totalIncome = 0
    local farmId = g_currentMission:getFarmId()
    local currentDay = g_currentMission.environment.currentDay or 0
    local propertyCount = 0
    
    for _, house in ipairs(self.houses) do
        if house.lastPaymentDay == -1 then
            house.lastPaymentDay = currentDay
        end
        
        local daysSinceLastPayment = currentDay - house.lastPaymentDay
        
        if daysSinceLastPayment >= house.paymentInterval then
            totalIncome = totalIncome + house.rent
            house.lastPaymentDay = currentDay
            propertyCount = propertyCount + 1
        end
    end
    
    if totalIncome > 0 then
        g_currentMission:addMoney(totalIncome, farmId, MoneyType.PROPERTY_INCOME, true)
        g_currentMission:addGameNotification("Rent Income", 
            string.format("Received $%d from %d property(s)", totalIncome, propertyCount), "", nil, 5000)
        self:addPaymentToHistory(currentDay, totalIncome, propertyCount)
        self:saveSettings()
    end
end

g_rentIncome = RentIncome:new()

PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(
    PlayerInputComponent.registerGlobalPlayerActionEvents, 
    function()
        g_inputBinding:registerActionEvent("RENT_INCOME_MENU", g_rentIncome, RentIncome.onOpenMenu, 
            false, true, false, true, Input.KEY_semicolon, Input.KEY_lshift)
        g_inputBinding:registerActionEvent("RENT_INCOME_TOGGLE", g_rentIncome, RentIncome.onToggleRentIncome, 
            false, true, false, true)
    end
)

addModEventListener(g_rentIncome)