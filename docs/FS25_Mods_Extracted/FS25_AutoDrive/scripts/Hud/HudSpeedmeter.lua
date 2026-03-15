ADHudSpeedmeter = ADInheritsFrom(ADGenericHudElement)

function ADHudSpeedmeter:new(posX, posY, width, height, fieldSpeed)
    local o = ADHudSpeedmeter:create()
    o:init(posX, posY, width, height)
    o.primaryAction = "input_increaseSpeed"
    o.secondaryAction = "input_decreaseSpeed"
    o.image = "ad_gui.speedmeter"

    if fieldSpeed then
        o.primaryAction = "input_increaseFieldSpeed"
        o.secondaryAction = "input_decreaseFieldSpeed"
        o.image = "ad_gui.speedmeter_field"
    end

    o.layer = 5
    o.isFieldSpeed = fieldSpeed

    o.ov = g_overlayManager:createOverlay(o.image, o.position.x, o.position.y, o.size.width, o.size.height)

    return o
end

function ADHudSpeedmeter:onDraw(vehicle, uiScale)
    self.ov:render()

    if AutoDrive.pullDownListExpanded == 0 then
        local adFontSize = AutoDrive.FONT_SCALE * uiScale
        setTextColor(unpack(AutoDrive.currentColors.ad_color_hudTextDefault))
        setTextAlignment(RenderText.ALIGN_CENTER)
        local speed = 0
        if self.isFieldSpeed then
            speed = g_i18n:getSpeed(vehicle.ad.stateModule:getFieldSpeedLimit())
        else
            speed = g_i18n:getSpeed(vehicle.ad.stateModule:getSpeedLimit())
        end
        local text = string.format("%1d", speed)
        local posX = self.position.x + (self.size.width / 2)
        local posY = self.position.y + AutoDrive.Hud.gapHeight
        renderText(posX, posY, adFontSize, text)
    end
end

function ADHudSpeedmeter:act(vehicle, posX, posY, isDown, isUp, button)
    if button == 1 and isUp then
        ADInputManager:onInputCall(vehicle, self.primaryAction)
        return true
    elseif (button == 3 or button == 2) and isUp then
        ADInputManager:onInputCall(vehicle, self.secondaryAction)
        return true
    elseif button == 4 and isUp then
        ADInputManager:onInputCall(vehicle, self.primaryAction)
        AutoDrive.mouseWheelActive = true
        return true
    elseif button == 5 and isUp then
        ADInputManager:onInputCall(vehicle, self.secondaryAction)
        AutoDrive.mouseWheelActive = true
        return true
    elseif button == 4 and isUp then
        AutoDrive.mouseWheelActive = true
    elseif button == 5 and isUp then
        AutoDrive.mouseWheelActive = true
    end
    return false
end
