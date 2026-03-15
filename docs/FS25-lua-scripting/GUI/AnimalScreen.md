## AnimalScreen

**Description**

> Animal Buying Screen.

**Parent**

> [ScreenElement](?version=script&category=43&class=424)

**Functions**

- [delete](#delete)
- [new](#new)
- [onClickBack](#onclickback)
- [onClickSelect](#onclickselect)
- [onClose](#onclose)
- [onOpen](#onopen)
- [removeActionEvents](#removeactionevents)
- [setSelectionState](#setselectionstate)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function AnimalScreen:delete()
    for k, clone in pairs( self.sourceDotBox.elements) do
        clone:delete()
        self.sourceDotBox.elements[k] = nil
    end

    self.sourceDotTemplate:delete()

    AnimalScreen:superClass().delete( self )
end

```

### new

**Description**

> Constructor

**Definition**

> new(table custom\_mt)

**Arguments**

| table | custom_mt | metatable |
|-------|-----------|-----------|

**Return Values**

| table | self | instance |
|-------|------|----------|

**Code**

```lua
function AnimalScreen.new(custom_mt)
    local self = ScreenElement.new( nil , custom_mt or AnimalScreen _mt)

    self.isBuyMode = true
    self.isSourceSelected = true

    self.isOpen = false
    self.lastBalance = 0
    self.numAnimals = 0

    self.selectionState = nil
    self.sourceSelectorStateToAnimalType = { }

    return self
end

```

### onClickBack

**Description**

> Callback on click back

**Definition**

> onClickBack()

**Code**

```lua
function AnimalScreen:onClickBack()
    AnimalScreen:superClass().onClickBack( self )

    if Platform.isMobile or self.selectionState < = AnimalScreen.SELECTION_SOURCE then
        self:changeScreen( nil )
    else
            if self.isBuyMode then
                self:setSelectionState( self.selectionState - 1 )
            else
                    self:setSelectionState( self.selectionState - 2 )
                end
            end
        end

```

### onClickSelect

**Description**

> Callback on click cancel

**Definition**

> onClickSelect()

**Code**

```lua
function AnimalScreen:onClickSelect()
    if self.selectionState < AnimalScreen.SELECTION_AMOUNT then
        if self.isBuyMode then
            self:setSelectionState( self.selectionState + 1 )
        else
                self:setSelectionState( self.selectionState + 2 )
            end
        end

        return true
    end

```

### onClose

**Description**

> Callback on close

**Definition**

> onClose(table element)

**Arguments**

| table | element |
|-------|---------|

**Code**

```lua
function AnimalScreen:onClose(element)
    AnimalScreen:superClass().onClose( self )
    self.controller:reset()

    self:removeActionEvents()
    self:toggleCustomInputContext( false , AnimalScreen.INPUT_CONTEXT)

    g_currentMission:resetGameState()

    g_currentMission:showMoneyChange(MoneyType.NEW_ANIMALS_COST)
    g_currentMission:showMoneyChange(MoneyType.SOLD_ANIMALS)

    g_messageCenter:unsubscribeAll( self )
    g_inputBinding:removeActionEventsByTarget( self )

    self.isOpen = false
end

```

### onOpen

**Description**

> Callback on open

**Definition**

> onOpen()

**Code**

```lua
function AnimalScreen:onOpen()
    AnimalScreen:superClass().onOpen( self )
    self.isOpen = true

    g_gameStateManager:setGameState(GameState.MENU_ANIMAL_SHOP)

    self:onClickBuyMode( true )

    if self.sourceList:getItemCount() = = 0 then
        self:onClickSellMode( true )

        if self.sourceList:getItemCount() = = 0 then
            g_gui:changeScreen( nil )
            InfoDialog.show(g_i18n:getText( "ui_noAnimalsToSell" ))
            return
        end
    end

    self:onMoneyChange()
    g_messageCenter:subscribe(MessageType.MONEY_CHANGED, self.onMoneyChange, self )

    self:toggleCustomInputContext( true , AnimalScreen.INPUT_CONTEXT)
    self:registerActionEvents()
end

```

### removeActionEvents

**Description**

> Remove non-GUI input action events.

**Definition**

> removeActionEvents()

**Code**

```lua
function AnimalScreen:removeActionEvents()
    g_inputBinding:removeActionEventsByTarget( self )
end

```

### setSelectionState

**Description**

**Definition**

> setSelectionState()

**Arguments**

| any | state       |
|-----|-------------|
| any | forceUpdate |

**Code**

```lua
function AnimalScreen:setSelectionState(state, forceUpdate)
    if state = = AnimalScreen.SELECTION_TARGET and # self.targetSelector.texts = = 0 then
        --if no husbanry is available for the currently selected animal, we cant change selection state
            return false
        elseif state = = AnimalScreen.SELECTION_TARGET and # self.targetSelector.texts = = 1 and not self.targetSlider.needsSlider then
                --if there is only exactly one available husbandry, and its list can not be scrolled, so we skip the selection
                    if self.selectionState = = AnimalScreen.SELECTION_SOURCE then
                        self:setSelectionState( AnimalScreen.SELECTION_AMOUNT)
                    else
                            self:setSelectionState( AnimalScreen.SELECTION_SOURCE)
                        end

                        return
                    elseif state = = AnimalScreen.SELECTION_AMOUNT and not self.numAnimalsBox:getIsVisible() then
                            -- if the current husbandry is full, we cant change state
                                if # self.targetSelector.texts = = 1 and not self.targetSlider.needsSlider then
                                    self:setSelectionState( AnimalScreen.SELECTION_SOURCE)
                                else
                                        self:setSelectionState( AnimalScreen.SELECTION_TARGET)
                                    end

                                    return
                                end

                                self.sourceBoxBg:setSelected(state = = AnimalScreen.SELECTION_SOURCE, true )
                                self.sourceBoxArrow:setSelected(state = = AnimalScreen.SELECTION_SOURCE, true )
                                self.targetBoxBg:setSelected(state = = AnimalScreen.SELECTION_TARGET)
                                self.numAnimalsBoxBg:setSelected(state = = AnimalScreen.SELECTION_AMOUNT)

                                self.isAutoUpdatingList = true
                                if state = = AnimalScreen.SELECTION_SOURCE then
                                    if self.selectionState ~ = state then
                                        if self.sourceList:getItemCount() > 0 then
                                            FocusManager:setFocus( self.sourceList)
                                        else
                                                FocusManager:setFocus( self.sourceSelector)
                                            end
                                        end
                                    elseif state = = AnimalScreen.SELECTION_TARGET then
                                            if self.targetSlider.needsSlider then
                                                FocusManager:setFocus( self.targetSlider)

                                                FocusManager:linkElements( self.targetSlider, FocusManager.RIGHT, self.numAnimalsElement)
                                                FocusManager:linkElements( self.targetSlider, FocusManager.TOP, self.targetSelector)
                                                FocusManager:linkElements( self.targetSelector, FocusManager.BOTTOM, self.targetSlider)

                                                if # self.targetSelector.texts > 1 then
                                                    FocusManager:linkElements( self.targetSlider, FocusManager.LEFT, self.targetSelector)
                                                elseif self.sourceList:getItemCount() > 0 then
                                                        FocusManager:linkElements( self.targetSlider, FocusManager.LEFT, self.sourceList)
                                                    else
                                                            FocusManager:linkElements( self.targetSlider, FocusManager.TOP, self.sourceSelector)
                                                        end

                                                        if self.sourceList:getItemCount() > 0 then
                                                            FocusManager:linkElements( self.targetSelector, FocusManager.TOP, self.sourceList)
                                                        else
                                                                FocusManager:linkElements( self.targetSelector, FocusManager.TOP, self.sourceSelector)
                                                            end
                                                        else
                                                                FocusManager:setFocus( self.targetSelector)

                                                                FocusManager:linkElements( self.targetSelector, FocusManager.BOTTOM, self.numAnimalsElement)

                                                                if self.sourceList:getItemCount() > 0 then
                                                                    FocusManager:linkElements( self.targetSelector, FocusManager.TOP, self.sourceList)
                                                                else
                                                                        FocusManager:linkElements( self.targetSelector, FocusManager.TOP, self.sourceSelector)
                                                                    end
                                                                end
                                                                else --state = = AnimalScreen.SELECTION_AMOUNT
                                                                    FocusManager:setFocus( self.numAnimalsElement)

                                                                    if self.targetSlider.needsSlider then
                                                                        FocusManager:linkElements( self.numAnimalsElement, FocusManager.TOP, self.targetSlider)
                                                                        FocusManager:linkElements( self.numAnimalsElement, FocusManager.BOTTOM, self.targetSlider)
                                                                    elseif # self.targetSelector.texts > 1 then
                                                                            FocusManager:linkElements( self.numAnimalsElement, FocusManager.TOP, self.targetSelector)
                                                                            FocusManager:linkElements( self.numAnimalsElement, FocusManager.BOTTOM, self.targetSelector)
                                                                        else
                                                                                FocusManager:linkElements( self.numAnimalsElement, FocusManager.TOP, self.sourceList)
                                                                                FocusManager:linkElements( self.numAnimalsElement, FocusManager.BOTTOM, self.sourceList)
                                                                            end
                                                                        end
                                                                        self.isAutoUpdatingList = false

                                                                        self.selectionState = state

                                                                        if self.isBuyMode then
                                                                            if self.buttonApply ~ = nil then
                                                                                self.buttonApply:setText( self.controller:getSourceActionText())
                                                                            elseif self.buttonBuy ~ = nil then
                                                                                    self.buttonBuy:setText( self.controller:getSourceActionText())
                                                                                end
                                                                            else
                                                                                    if self.buttonApply ~ = nil then
                                                                                        self.buttonApply:setText( self.controller:getTargetActionText())
                                                                                    elseif self.buttonSell ~ = nil then
                                                                                            self.buttonSell:setText( self.controller:getTargetActionText())
                                                                                        end
                                                                                    end

                                                                                    self.noHusbandriesTextBox:setVisible(# self.targetSelector.texts = = 0 and self.isBuyMode)
                                                                                    self.targetListEmptyText:setVisible(# self.targetSelector.texts > 0 and self.targetList:getItemCount() = = 0 )
                                                                                    self.targetIcon:setVisible(# self.targetSelector.texts > 0 )
                                                                                    self.targetSelector:setVisible(# self.targetSelector.texts > 0 )
                                                                                    self.targetText:setVisible(# self.targetSelector.texts > 0 )
                                                                                    self.targetListContainer:setVisible( self.isBuyMode and( self.controller.husbandry = = nil or self.controller.trailer = = nil ))

                                                                                    self.buttonBuy:setVisible(state = = AnimalScreen.SELECTION_AMOUNT and self.isBuyMode)
                                                                                    self.buttonSell:setVisible(state = = AnimalScreen.SELECTION_AMOUNT and not self.isBuyMode)
                                                                                    self.buttonSelect:setVisible(state < AnimalScreen.SELECTION_AMOUNT and self.sourceList:getItemCount() > 0 and( self.targetContainer:getIsVisible() or not self.isBuyMode) and self.numAnimalsElement:getIsVisible())
                                                                                    self.buttonsPanel:invalidateLayout()

                                                                                    return true
                                                                                end

```