## NavigationMarker

**Functions**

- [render](#render)

### render

**Description**

**Definition**

> render()

**Code**

```lua
function NavigationMarker:render()
    if not self.isVisible then
        return
    end

    new2DLayer()

    local player = g_localPlayer
    if player = = nil then
        return
    end

    local x, y, z = g_localPlayer:getPosition()

    local distance = MathUtil.vector3Length( self.worldPosX - x, self.worldPosY - y, self.worldPosZ - z)
    if distance < self.minDistance then
        return
    end

    local diff = distance - self.minDistance
    local fadeFactor = MathUtil.lerp( 0 , 1 , math.min( 1 , diff))

    local camera = g_cameraManager:getActiveCamera()
    local cx, cy, cz = worldToLocal(camera, self.worldPosX, self.worldPosY, self.worldPosZ)

    local nClip = getNearClip(camera)
    if cz > - nClip then
        local b = - nClip
        local c = b / math.sin(getFovY(camera) * 0.5 )
        local a = math.sqrt( - b * b + c * c)

        cx = a * math.sign(cx)

        b = - nClip
        c = b / math.sin(getFovY(camera) * 0.5 * g_screenAspectRatio)
        a = math.sqrt( - b * b + c * c)

        cy = a * math.sign(cy)

        -- cx = math.clamp(cx, -5, 5)
        -- cy = math.clamp(cy, -5, 5)
    end

    cz = math.min(cz, - nClip)

    local wx, wy, wz = localToWorld(camera, cx, cy, cz)
    local sx, sy, _sz = project(wx, wy, wz)

    -- if sz > 1 then
        -- sx = sx * -1
        -- end

        local clampedX = sx
        local isClampedX = false
        if sx < self.borderX or sx > 1 - self.borderX then
            clampedX = math.clamp(sx, self.borderX, 1 - self.borderX)
            isClampedX = true
        end

        local clampedY = sy
        local isClampedY = false
        if sy < self.borderY or sy > 1 - self.borderY then
            clampedY = math.clamp(sy, self.borderY, 1 - self.borderY)
            isClampedY = true
        end

        -- if sx > -1 and sx < 2 and sy > -1 and sy < 2 then -- and sz < = 1
            --TODO fix positioning
            -- renderText(0.5, 0.5, 0.018, string.format("%.2f, %.2f, %.2f", sx, sy, sz))

            local alpha = MathUtil.lerp( 0.4 , 1.0 , math.abs( math.sin(g_ time / 400 )))
            self.overlayMarker:setColor( nil , nil , nil , alpha * fadeFactor)

            self.overlayMarker:setPosition(clampedX, clampedY)
            self.overlayMarker:render()

            local needArrow = isClampedX or isClampedY
            if needArrow then
                local dx, dy = MathUtil.vector2Normalize(sx - 0.5 , sy - 0.5 )
                local angle = - math.atan2(dx, dy) + math.pi * 0.5

                self.overlayMarkerArrow:setColor( nil , nil , nil , alpha * fadeFactor)
                self.overlayMarkerArrow:setRotation(angle, self.overlayMarkerArrow.width * 0.5 , self.overlayMarkerArrow.height * 0.5 )
                self.overlayMarkerArrow:setPosition(clampedX + dx * self.width * 0.7 , clampedY + dy * self.height * 0.7 )
                self.overlayMarkerArrow:render()
            end

            setTextColor( 1 , 1 , 1 , alpha * fadeFactor)
            setTextBold( true )
            setTextAlignment(RenderText.ALIGN_CENTER)
            setTextLineHeightScale( 0.8 )
            setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
            setTextWrapWidth( self.width * 0.1 , false )
            renderText(clampedX, clampedY, self.textSize, g_i18n:formatDistance(distance))

            setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
            setTextBold( false )
            setTextWrapWidth( 0 )
            setTextAlignment(RenderText.ALIGN_LEFT)
            setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
            -- end
        end

```