## BoxLayoutElement

**Description**

> Layout element which lays out child elements in regular rows or columns.
> Exceptions are elements whose "layoutIgnore" property is true.
> Used layers: "image" for a background image.

**Parent**

> [BitmapElement](?version=script&category=43&class=428)

**Functions**

- [addElement](#addelement)
- [applyCellPositions](#applycellpositions)
- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [focusLinkCells](#focuslinkcells)
- [getIsElementIncluded](#getiselementincluded)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [onFocusLeave](#onfocusleave)
- [onGuiSetupFinished](#onguisetupfinished)
- [removeElement](#removeelement)
- [updateAbsolutePosition](#updateabsoluteposition)
- [updateLayoutCells](#updatelayoutcells)

### addElement

**Description**

**Definition**

> addElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function BoxLayoutElement:addElement(element)
    BoxLayoutElement:superClass().addElement( self , element)

    -- reset element screen alignment to avoid interference with layouting
    element:setAnchor( 0 , 0 )
    element:setPivot( 0 , 0 )

    if self.autoValidateLayout then
        self:invalidateLayout()
    end
end

```

### applyCellPositions

**Description**

> Apply layout positions to all given cells' elements.

**Definition**

> applyCellPositions(integer offsetX, integer offsetX)

**Arguments**

| integer | offsetX | additional offsets in x-direction, used for example in ScrollingLayouts, defaults to 0 |
|---------|---------|----------------------------------------------------------------------------------------|
| integer | offsetX | additional offsets in y-direction, used for example in ScrollingLayouts, defaults to 0 |

**Code**

```lua
function BoxLayoutElement:applyCellPositions(offsetX, offsetY)
    local offsets = { offsetX or 0 , offsetY or 0 }
    local flowDirection = self.flowDirection = = BoxLayoutElement.FLOW_VERTICAL and 2 or 1
    local lateralDirection = self.flowDirection = = BoxLayoutElement.FLOW_VERTICAL and 1 or 2

    local flowOffset = self.alignment[lateralDirection] * ( self.absSize[lateralDirection] - self.totalLateralSize) + offsets[lateralDirection]

    local flowIndexStart, flowIndexEnd = 1 , # self.cells
    local flowDir = self.fillDirections[lateralDirection]

    -- swap values if negative direction:
        if flowDir = = - 1 then
            flowIndexStart, flowIndexEnd = flowIndexEnd, flowIndexStart
        end

        for flowIndex = flowIndexStart, flowIndexEnd, flowDir do
            local flow = self.cells[flowIndex]

            if flow = = nil or #flow = = 0 then
                break
            end

            local cellIndexStart, cellIndexEnd = 1 , #flow
            local cellDir = self.fillDirections[flowDirection]

            -- swap values if negative direction:
                if cellDir = = - 1 then
                    cellIndexStart, cellIndexEnd = cellIndexEnd, cellIndexStart
                end

                local cellOffset = self.alignment[flowDirection] * ( self.absSize[flowDirection] - self.flowSizes[flowIndex]) + offsets[flowDirection]

                for cellIndex = cellIndexStart, cellIndexEnd, cellDir do
                    local cell = flow[cellIndex]

                    if cell = = nil then
                        break
                    end

                    -- reset element screen alignment to avoid interference with layouting
                    cell:setAnchor( 0 , 0 )
                    cell:setPivot( 0 , 0 )

                    local cellLateralOffset = flowOffset
                    if self.fitFlowToElements then
                        local cellLateralSize = cell.absSize[lateralDirection] + cell.margin[lateralDirection] + cell.margin[lateralDirection + 2 ]
                        cellLateralOffset = flowOffset + self.alignment[lateralDirection] * ( self.lateralFlowSizes[flowIndex] - cellLateralSize)
                    end

                    local cellPos = { cellOffset, cellLateralOffset }

                    --add left and bottom margin to position
                    cell:setPosition(cellPos[flowDirection] + cell.margin[ 1 ], cellPos[lateralDirection] + cell.margin[ 4 ])

                    cellOffset = cellOffset + cell.absSize[flowDirection] + self.elementSpacing + cell.margin[flowDirection] + cell.margin[flowDirection + 2 ]
                end

                flowOffset = flowOffset + self.lateralFlowSizes[flowIndex]
            end
        end

```

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Code**

```lua
function BoxLayoutElement:canReceiveFocus()
    -- element can receive focus if any sub elements are ready to receive focus
        if self.handleFocus then
            for _, v in ipairs( self.elements) do
                if (v:canReceiveFocus()) then
                    return true
                end
            end
        end
        return false
    end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function BoxLayoutElement:copyAttributes(src)
    BoxLayoutElement:superClass().copyAttributes( self , src)

    self.alignment = table.clone(src.alignment)
    self.fillDirections = table.clone(src.fillDirections)

    self.autoValidateLayout = src.autoValidateLayout
    self.useFullVisibility = src.useFullVisibility
    self.layoutToleranceX = src.layoutToleranceX
    self.layoutToleranceY = src.layoutToleranceY

    self.flowDirection = src.flowDirection
    self.focusDirection = src.focusDirection
    self.numFlows = src.numFlows
    self.lateralFlowSize = src.lateralFlowSize
    self.fitFlowToElements = src.fitFlowToElements
    self.elementSpacing = src.elementSpacing

    self.wrapAround = src.wrapAround
    self.rememberLastFocus = src.rememberLastFocus
end

```

### focusLinkCells

**Description**

> Link layout cells' elements for focus navigation.

**Definition**

> focusLinkCells()

**Code**

```lua
function BoxLayoutElement:focusLinkCells()
    local prevElement = nil
    local firstElement = nil
    local lastElement = nil
    self.defaultFocusTarget = nil

    -- determine first and last elements:
    for _, flow in pairs( self.cells) do
        for _, cell in pairs(flow) do
            if not firstElement then
                firstElement = cell:findFirstFocusable( true )

                --we want the first element to actually be able to recieve focus, findFirstFocusable() returns the element itself if no child can be focused, and we cannot change that without further changes that are risky
                    if not firstElement:canReceiveFocus() then
                        firstElement = nil
                    else
                            self.defaultFocusTarget = firstElement
                        end
                    else
                            lastElement = cell:findFirstFocusable( true )
                        end
                    end
                end

                --we need to reset this here so self.incomingFocusTargets does not have references to deleted items if layout is now empty after being filled before
                    self.incomingFocusTargets = { }

                    -- link elements
                    for _, flow in pairs( self.cells) do
                        for _, cell in pairs(flow) do
                            local element = cell:findFirstFocusable( true )

                            if element:canReceiveFocus() then
                                self:focusLinkChildElement(element, prevElement, firstElement, lastElement)
                                prevElement = element
                            end
                        end
                    end
                end

```

### getIsElementIncluded

**Description**

**Definition**

> getIsElementIncluded()

**Arguments**

| any | element          |
|-----|------------------|
| any | ignoreVisibility |

**Code**

```lua
function BoxLayoutElement:getIsElementIncluded(element, ignoreVisibility)
    return not element.ignoreLayout and ignoreVisibility or(element:getIsVisibleNonRec() and self.useFullVisibility) or(element.visible and not self.useFullVisibility)
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function BoxLayoutElement:loadFromXML(xmlFile, key)
    BoxLayoutElement:superClass().loadFromXML( self , xmlFile, key)

    local alignmentX = getXMLString(xmlFile, key .. "#alignmentX" )
    if alignmentX ~ = nil then
        alignmentX = string.lower(alignmentX)
        if alignmentX = = "right" then
            self.alignment[ 1 ] = BoxLayoutElement.ALIGN_RIGHT
        elseif alignmentX = = "center" then
                self.alignment[ 1 ] = BoxLayoutElement.ALIGN_CENTER
            else
                    self.alignment[ 1 ] = BoxLayoutElement.ALIGN_LEFT
                end
            end

            local alignmentY = getXMLString(xmlFile, key .. "#alignmentY" )
            if alignmentY ~ = nil then
                alignmentY = string.lower(alignmentY)
                if alignmentY = = "bottom" then
                    self.alignment[ 2 ] = BoxLayoutElement.ALIGN_BOTTOM
                elseif alignmentY = = "middle" then
                        self.alignment[ 2 ] = BoxLayoutElement.ALIGN_MIDDLE
                    else
                            self.alignment[ 2 ] = BoxLayoutElement.ALIGN_TOP
                        end
                    end

                    local fillDirectionX = getXMLString(xmlFile, key .. "#fillDirectionX" )
                    if fillDirectionX ~ = nil then
                        if fillDirectionX = = "leftToRight" then
                            self.fillDirections[ 1 ] = BoxLayoutElement.FILL_DIRECTION_LEFT_TO_RIGHT
                        elseif fillDirectionX = = "rightToLeft" then
                                self.fillDirections[ 1 ] = BoxLayoutElement.FILL_DIRECTION_RIGHT_TO_LEFT
                            end
                        end

                        local fillDirectionY = getXMLString(xmlFile, key .. "#fillDirectionY" )
                        if fillDirectionY ~ = nil then
                            if fillDirectionY = = "topToBottom" then
                                self.fillDirections[ 2 ] = BoxLayoutElement.FILL_DIRECTION_TOP_TO_BOTTOM
                            elseif fillDirectionY = = "bottomToTop" then
                                    self.fillDirections[ 2 ] = BoxLayoutElement.FILL_DIRECTION_BOTTOM_TO_TOP
                                end
                            end

                            self.flowDirection = getXMLString(xmlFile, key .. "#flowDirection" ) or self.flowDirection
                            self.focusDirection = getXMLString(xmlFile, key .. "#focusDirection" ) or self.flowDirection -- use flow direction as default
                            self.numFlows = getXMLInt(xmlFile, key .. "#numFlows" ) or self.numFlows

                            local isXValue = self.flowDirection = = BoxLayoutElement.FLOW_HORIZONTAL
                            self.elementSpacing = GuiUtils.getNormalizedValue(getXMLString(xmlFile, key .. "#elementSpacing" ), isXValue) or self.elementSpacing
                            self.lateralFlowSize = GuiUtils.getNormalizedValue(getXMLString(xmlFile, key .. "#lateralFlowSize" ), not isXValue) or self.lateralFlowSize
                            self.fitFlowToElements = Utils.getNoNil(getXMLBool(xmlFile, key .. "#fitFlowToElements" ), self.lateralFlowSize = = 0 )

                            self.autoValidateLayout = Utils.getNoNil(getXMLBool(xmlFile, key .. "#autoValidateLayout" ), self.autoValidateLayout)
                            self.useFullVisibility = Utils.getNoNil(getXMLBool(xmlFile, key .. "#useFullVisibility" ), self.useFullVisibility)

                            self.wrapAround = Utils.getNoNil(getXMLBool(xmlFile, key .. "#wrapAround" ), self.wrapAround)
                            self.rememberLastFocus = Utils.getNoNil(getXMLBool(xmlFile, key .. "#rememberLastFocus" ), self.rememberLastFocus)
                        end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function BoxLayoutElement:loadProfile(profile, applyProfile)
    BoxLayoutElement:superClass().loadProfile( self , profile, applyProfile)

    local alignmentX = profile:getValue( "alignmentX" )
    if alignmentX ~ = nil then
        alignmentX = string.lower(alignmentX)
        if alignmentX = = "right" then
            self.alignment[ 1 ] = BoxLayoutElement.ALIGN_RIGHT
        elseif alignmentX = = "center" then
                self.alignment[ 1 ] = BoxLayoutElement.ALIGN_CENTER
            else
                    self.alignment[ 1 ] = BoxLayoutElement.ALIGN_LEFT
                end
            end

            local alignmentY = profile:getValue( "alignmentY" )
            if alignmentY ~ = nil then
                alignmentY = string.lower(alignmentY)
                if alignmentY = = "bottom" then
                    self.alignment[ 2 ] = BoxLayoutElement.ALIGN_BOTTOM
                elseif alignmentY = = "middle" then
                        self.alignment[ 2 ] = BoxLayoutElement.ALIGN_MIDDLE
                    else
                            self.alignment[ 2 ] = BoxLayoutElement.ALIGN_TOP
                        end
                    end

                    local fillDirectionX = profile:getValue( "fillDirectionX" )
                    if fillDirectionX ~ = nil then
                        if fillDirectionX = = "leftToRight" then
                            self.fillDirections[ 1 ] = BoxLayoutElement.FILL_DIRECTION_LEFT_TO_RIGHT
                        elseif fillDirectionX = = "rightToLeft" then
                                self.fillDirections[ 1 ] = BoxLayoutElement.FILL_DIRECTION_RIGHT_TO_LEFT
                            end
                        end

                        local fillDirectionY = profile:getValue( "fillDirectionY" )
                        if fillDirectionY ~ = nil then
                            if fillDirectionY = = "topToBottom" then
                                self.fillDirections[ 2 ] = BoxLayoutElement.FILL_DIRECTION_TOP_TO_BOTTOM
                            elseif fillDirectionY = = "bottomToTop" then
                                    self.fillDirections[ 2 ] = BoxLayoutElement.FILL_DIRECTION_BOTTOM_TO_TOP
                                end
                            end

                            self.autoValidateLayout = profile:getBool( "autoValidateLayout" , self.autoValidateLayout)
                            self.useFullVisibility = profile:getBool( "useFullVisibility" , self.useFullVisibility)

                            self.flowDirection = profile:getValue( "flowDirection" ) or self.flowDirection
                            self.focusDirection = profile:getValue( "focusDirection" , self.flowDirection)
                            self.numFlows = profile:getNumber( "numFlows" , self.numFlows)

                            local isXValue = self.flowDirection = = BoxLayoutElement.FLOW_HORIZONTAL
                            self.elementSpacing = GuiUtils.getNormalizedValue(profile:getValue( "elementSpacing" , self.elementSpacing), isXValue)
                            self.lateralFlowSize = GuiUtils.getNormalizedValue(profile:getValue( "lateralFlowSize" , self.lateralFlowSize), not isXValue)
                            self.fitFlowToElements = profile:getBool( "fitFlowToElements" , self.lateralFlowSize = = 0 )

                            self.wrapAround = profile:getBool( "wrapAround" , self.wrapAround)
                            self.rememberLastFocus = profile:getBool( "rememberLastFocus" , self.rememberLastFocus)
                        end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function BoxLayoutElement.new(target, custom_mt)
    if custom_mt = = nil then
        custom_mt = BoxLayoutElement _mt
    end
    local self = BitmapElement.new(target, custom_mt)

    self.autoValidateLayout = false
    self.useFullVisibility = true

    self.wrapAround = false
    self.alignment = { BoxLayoutElement.ALIGN_LEFT, BoxLayoutElement.ALIGN_TOP }
    self.flowDirection = BoxLayoutElement.FLOW_HORIZONTAL
    self.fillDirections = { BoxLayoutElement.FILL_DIRECTION_LEFT_TO_RIGHT, BoxLayoutElement.FILL_DIRECTION_TOP_TO_BOTTOM }
    self.numFlows = 1 -- number of flows(columns or rows, depending on flow direction)
    self.lateralFlowSize = 0 -- lateral size of flow(column width or row height, depending on flow direction)
    self.fitFlowToElements = true -- ignore lateral flow size and fit flows to element dimensions
    self.layoutToleranceX, self.layoutToleranceY = 0 , 0

    self.rememberLastFocus = false
    self.lastFocusElement = nil
    self.incomingFocusTargets = { }
    self.defaultFocusTarget = nil -- first focusable element of the current layout state

    self.cells = { } -- saved data for all cells in format [flowIndex][cell]
        self.flowSizes = { }
        self.lateralFlowSizes = { }
        self.totalLateralSize = 0
        self.maxFlowSize = 0
        self.elementSpacing = 0

        return self
    end

```

### onFocusLeave

**Description**

**Definition**

> onFocusLeave()

**Code**

```lua
function BoxLayoutElement:onFocusLeave()
    BoxLayoutElement:superClass().onFocusLeave( self )

    if self.rememberLastFocus then
        local lastFocus = FocusManager:getFocusedElement()
        if lastFocus:isChildOf( self ) then
            self.lastFocusElement = lastFocus
        end
    end
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function BoxLayoutElement:onGuiSetupFinished()
    BoxLayoutElement:superClass().onGuiSetupFinished( self )
    self.layoutToleranceX = BoxLayoutElement.LAYOUT_TOLERANCE * g_pixelSizeX
    self.layoutToleranceY = BoxLayoutElement.LAYOUT_TOLERANCE * g_pixelSizeY

    self:invalidateLayout()
end

```

### removeElement

**Description**

**Definition**

> removeElement()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function BoxLayoutElement:removeElement(element)
    BoxLayoutElement:superClass().removeElement( self , element)

    if self.autoValidateLayout then
        self:invalidateLayout()
    end
end

```

### updateAbsolutePosition

**Description**

**Definition**

> updateAbsolutePosition()

**Code**

```lua
function BoxLayoutElement:updateAbsolutePosition()
    BoxLayoutElement:superClass().updateAbsolutePosition( self )

    self:applyCellPositions()
end

```

### updateLayoutCells

**Description**

> Extract a flow / cell data table from this box layout's elements.
> Also save some values like flow sizes for later use

**Definition**

> updateLayoutCells(boolean ignoreVisibility)

**Arguments**

| boolean | ignoreVisibility | Visibility flag for element eligibility |
|---------|------------------|-----------------------------------------|

**Code**

```lua
function BoxLayoutElement:updateLayoutCells(ignoreVisibility)
    -- get property indices to match flow direction
    self.cells = { { } }
    local indices = BoxLayoutElement.FLOW_INDICES[ self.flowDirection]
    local lateralIndices = BoxLayoutElement.FLOW_INDICES[ BoxLayoutElement.FLOW_LATERAL_TABLE[ self.flowDirection]]

    local flowTolerance = self.layoutToleranceX
    local lateralTolerance = self.layoutToleranceY
    if self.flowDirection = = BoxLayoutElement.FLOW_VERTICAL then
        flowTolerance, lateralTolerance = lateralTolerance, flowTolerance
    end

    local currentFlowSize = 0
    local maxLateralSize = 0
    local currentFlow = 1
    local count = 1

    self.flowSizes = { }
    self.lateralFlowSizes = { }
    self.maxFlowSize = 0
    self.totalLateralSize = 0

    --we rebuild the whole layout, in case there were some changes to individual elements or values
    for i, element in ipairs( self.elements) do
        if self:getIsElementIncluded(element, ignoreVisibility) then
            local elementFlowSize = element.absSize[indices.ELEMENT_SIZE] + element.margin[indices.ELEMENT_MARGIN_LOWER] + element.margin[indices.ELEMENT_MARGIN_UPPER]
            local elementLateralSize = element.absSize[lateralIndices.ELEMENT_SIZE] + element.margin[lateralIndices.ELEMENT_MARGIN_LOWER] + element.margin[lateralIndices.ELEMENT_MARGIN_UPPER]

            --element would overflow, we start a new flow if possible(number of current flows < self.numFlows)
                if currentFlowSize + elementFlowSize + self.elementSpacing - flowTolerance > self.absSize[indices.LAYOUT_FLOW_SIZE] and( self.numFlows = = 0 or currentFlow < self.numFlows) then
                    currentFlow = currentFlow + 1
                    currentFlowSize = 0
                    maxLateralSize = 0
                    count = 1

                    table.insert( self.cells, { } )
                end

                self.cells[currentFlow][count] = element

                currentFlowSize = currentFlowSize + elementFlowSize
                self.flowSizes[currentFlow] = currentFlowSize
                currentFlowSize = currentFlowSize + self.elementSpacing
                self.maxFlowSize = math.max( self.maxFlowSize, currentFlowSize)

                --if self.fitFlowToElements is true, we save the biggest lateral size of an element in the flow, and the flow will be resized to that value.if not, we use self.lateralFlowSize
                    local lateralFlowSize = self.fitFlowToElements and elementLateralSize or self.lateralFlowSize
                    maxLateralSize = math.max(maxLateralSize, lateralFlowSize)
                    self.lateralFlowSizes[currentFlow] = maxLateralSize

                    count = count + 1
                end
            end

            -- we cannot do this calculation directly in the above loop, because we dont know what the maxLateralSize of a flow will be(a bigger element could be added later on)
                for _, size in pairs( self.lateralFlowSizes) do
                    self.totalLateralSize = self.totalLateralSize + size
                end
            end

```