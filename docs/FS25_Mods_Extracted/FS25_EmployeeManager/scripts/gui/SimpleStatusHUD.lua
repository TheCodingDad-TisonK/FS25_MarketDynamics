SimpleStatusHUD = {}
local SimpleStatusHUD_mt = Class(SimpleStatusHUD)

function SimpleStatusHUD.new()
    local self = setmetatable({}, SimpleStatusHUD_mt)
    self.isVisible = false
    self.bgOverlay = nil
    self.posX = 0.82
    self.posY = 0.6
    self.width = 0.17
    self.height = 0.3
    return self
end

function SimpleStatusHUD:load()
    self.bgOverlay = Overlay.new(g_baseUIFilename, self.posX, self.posY, self.width, self.height)
    self.bgOverlay:setUVs(GuiUtils.getUVs({0, 0, 1, 1}))
    self.bgOverlay:setColor(0, 0, 0, 0.75)
end

function SimpleStatusHUD:toggle()
    self.isVisible = not self.isVisible
end

function SimpleStatusHUD:draw()
    if not self.isVisible or g_gui.currentGuiName ~= nil then return end

    if self.bgOverlay then
        self.bgOverlay:render()
    end

    setTextBold(false)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextColor(1, 1, 1, 1)

    local x = self.posX + 0.005
    local y = self.posY + self.height - 0.025
    local lineHeight = 0.018

    setTextBold(true)
    renderText(x, y, 0.015, "EMPLOYEE MANAGER STATUS")
    y = y - (lineHeight * 1.5)
    setTextBold(false)

    if g_employeeManager then
        local employees = g_employeeManager.employees
        if employees then
            for _, emp in ipairs(employees) do
                if emp.isHired then
                    setTextColor(1, 1, 1, 1)
                    renderText(x, y, 0.012, string.format("[%d] %s", emp.id, emp.name))
                    
                    local status = "Idle"
                    local color = {0.7, 0.7, 0.7, 1}
                    
                    if emp.currentJob then
                        status = emp.currentJob.type or "Unknown"
                        if emp.currentJob.workType then
                            status = status .. ": " .. emp.currentJob.workType
                        end
                        color = {0, 1, 0, 1}
                    elseif emp.targetCrop then
                        status = "Auto: Waiting"
                        color = {1, 1, 0, 1}
                    end

                    if emp.currentJob then
                        local jobType = emp.currentJob.type
                        if jobType == "RETURN_TO_PARKING" then
                            status = g_i18n:getText("em_status_returning")
                            color = {0.5, 0.8, 1, 1}
                        elseif jobType == "DRIVING_TO_TOOL" then
                            status = g_i18n:getText("em_status_driving_to_tool")
                            color = {1, 0.8, 0.2, 1}
                        elseif jobType == "APPROACHING_TOOL" or jobType == "ATTACHING_TOOL" then
                            status = g_i18n:getText("em_status_attaching_tool")
                            color = {1, 0.8, 0.2, 1}
                        elseif jobType == "RETURNING_TOOL" then
                            status = g_i18n:getText("em_status_returning_tool")
                            color = {0.5, 0.8, 1, 1}
                        end
                    end

                    setTextColor(unpack(color))
                    renderText(x + 0.08, y, 0.012, status)

                    y = y - lineHeight

                    if emp.assignedVehicleId then
                        local v = g_employeeManager:getVehicleById(emp.assignedVehicleId)
                        if v then
                            setTextColor(0.8, 0.8, 0.8, 1)
                            renderText(x + 0.01, y, 0.010, "- " .. v:getName())
                            y = y - lineHeight
                        end
                    end

                    if emp.isOnBreak then
                        setTextColor(1, 1, 0, 1)
                        renderText(x + 0.01, y, 0.010, g_i18n:getText("em_status_on_break"))
                        y = y - lineHeight
                    elseif (emp.fatigueLevel or 0) >= 50 then
                        local fatigue = emp.fatigueLevel or 0
                        if fatigue >= 80 then
                            setTextColor(1, 0.2, 0.2, 1)
                        else
                            setTextColor(1, 0.7, 0, 1)
                        end
                        renderText(x + 0.01, y, 0.010, string.format("%s: %.0f%%", g_i18n:getText("em_stat_fatigue"), fatigue))
                        y = y - lineHeight
                    end

                    if emp.isUnpaid then
                        setTextColor(1, 0.2, 0.2, 1)
                        renderText(x + 0.01, y, 0.010, g_i18n:getText("em_status_unpaid"))
                        y = y - lineHeight
                    elseif (emp.pendingWages or 0) > 0 then
                        setTextColor(1, 1, 0, 1)
                        renderText(x + 0.01, y, 0.010, string.format("Pending: %s", g_i18n:formatMoney(emp.pendingWages, 0, true, false)))
                        y = y - lineHeight
                    end

                    y = y - (lineHeight * 0.5)
                end
            end
        end
    else
        renderText(x, y, 0.012, "Manager not loaded")
    end

    setTextColor(1, 1, 1, 1)
    setTextAlignment(RenderText.ALIGN_LEFT)
end

function SimpleStatusHUD:delete()
    if self.bgOverlay then
        self.bgOverlay:delete()
    end
end
