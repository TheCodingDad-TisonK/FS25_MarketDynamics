--
-- AdvancedFarmManager - Placeable Page
--

AFMGuiFieldFrame = {}

AFMGuiFieldFrame.COLUMN_FARMLANDS = 1
AFMGuiFieldFrame.COLUMN_OWNER = 2
AFMGuiFieldFrame.COLUMN_CROPS = 3
AFMGuiFieldFrame.COLUMN_CROP_STAGES = 4
AFMGuiFieldFrame.SORT_ORDER_DESC = 1
AFMGuiFieldFrame.SORT_ORDER_ASC = 2

local AFMGuiFieldFrame_mt = Class(AFMGuiFieldFrame, TabbedMenuFrameElement)

function AFMGuiFieldFrame:new(l10n)
    local self = TabbedMenuFrameElement.new(nil,AFMGuiFieldFrame_mt)

    self.messageCenter      = g_messageCenter
    self.l10n               = l10n
    self.fields             = {}
    self.sortByColumn       = AFMGuiFieldFrame.COLUMN_FARMLANDS
	  self.sortOrder          = AFMGuiFieldFrame.SORT_ORDER_ASC
    self.sortIcons          = {}
    self.isMPGame           = g_currentMission.missionDynamicInfo.isMultiplayer


    return self
end


function AFMGuiFieldFrame:copyAttributes(src)
    AFMGuiFieldFrame:superClass().copyAttributes(self, src)

    self.ui   = src.ui
    self.l10n = src.l10n
end


function AFMGuiFieldFrame:initialize()
    afmDebug("AFMGuiFieldFrame:initialize")
    self.backButtonInfo = {inputAction = InputAction.MENU_BACK}

    self.activateButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = self.l10n:getText("afm_warp_loc"),
        callback    = function ()
            self:onButtonWarpField()
        end
    }
    self.hotspotButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACCEPT,
        text        = self.l10n:getText("action_tag"),
        callback    = function ()
            self:onButtonHotspotField()
        end
    }
    self.hotspotButtonInfo2 = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACCEPT,
        text        = self.l10n:getText("action_untag"),
        callback    = function ()
            self:onButtonHotspotField()
        end
    }
end


function AFMGuiFieldFrame:onGuiSetupFinished()
    AFMGuiFieldFrame:superClass().onGuiSetupFinished(self)
    self.fieldsList:setDataSource(self)
    self.fieldsDetail:setDataSource(self)
end


function AFMGuiFieldFrame:delete()
    AFMGuiFieldFrame:superClass().delete(self)
    self.messageCenter:unsubscribeAll(self)
end


function AFMGuiFieldFrame:updateMenuButtons()
    local selectedIndex = self.fieldsList.selectedIndex
    if self.fields[selectedIndex] ~= nil and self.fields[selectedIndex].field ~= nil then 
        local field = self.fields[selectedIndex].field

        self.menuButtonInfo = {
            {
                inputAction = InputAction.MENU_BACK
            }
        }

        table.insert(self.menuButtonInfo, self.activateButtonInfo)

        if field ~= nil and g_currentMission.currentMapTargetHotspot ~= nil and field.farmland.mapHotspot ~= nil and g_currentMission.currentMapTargetHotspot == field.farmland.mapHotspot then
            table.insert(self.menuButtonInfo, self.hotspotButtonInfo2)
        else
            table.insert(self.menuButtonInfo, self.hotspotButtonInfo)
        end

        self:setMenuButtonInfoDirty()
    end
end


function AFMGuiFieldFrame:onFrameOpen()
    self.itemDetailsMap:setIngameMap(g_currentMission.hud:getIngameMap())
    AFMGuiFieldFrame:superClass().onFrameOpen(self)

    if AdvancedFarmManager.debug then
        print("~~ AdvancedFarmManager Debug ... AFMGuiFieldFrame:onFrameOpen")
    end

    self:rebuildTable()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.fieldsList)
    self:setSoundSuppressed(false)

    self:onMoneyChange()

    self.messageCenter:subscribe(MessageType.FARM_PROPERTY_CHANGED, self.onRefreshEvent, self) -- update when someone buys or sells farmland
    self.messageCenter:subscribe(MessageType.MONEY_CHANGED, self.onMoneyChange, self) -- Update anytime there is a money change
end


function AFMGuiFieldFrame:onRefreshEvent()
    self:rebuildTable()
end


function AFMGuiFieldFrame:onFrameClose()
    AFMGuiFieldFrame:superClass().onFrameClose(self)

    self.fields = {}
    self.itemDetailsMap:onClose()
    self.messageCenter:unsubscribeAll(self)
end


function AFMGuiFieldFrame:rebuildTable()
    self.fields = {}

    for _, field in ipairs(g_fieldManager:getFields()) do
        -- Put the field data together for display and sorting

        -- Build data for the details bar
        -- afmDebug("field data")
        -- afmDebug(field)

        local fieldFarmlandId   = field.farmland.id
        local x, z              = field:getCenterOfFieldWorldPosition()
        local fruitTypeIndexPos, growthState = FSDensityMapUtil.getFruitTypeIndexAtWorldPos(x, z)
        local fruitDesc         = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndexPos)
        local ownerFarmId       = g_farmlandManager:getFarmlandOwner(fieldFarmlandId)
        local farmName, farmColor = self:getFieldOwnerDisplay(ownerFarmId,fieldFarmlandId)
        local fillType          = nil

        local fieldInfo         = field.fieldState

        local fruitName         = "None"
        local showYieldData = false

        if fruitDesc ~= nil and fruitDesc.fillType ~= nil then
            fruitName = fruitDesc.fillType.title
            fillType = g_fillTypeManager:getFillTypeByIndex(fruitDesc.fillType.index)

            if fruitDesc:getIsGrowing(growthState) or fruitDesc:getIsPreparable(growthState) or fruitDesc:getIsHarvestable(growthState) then
                showYieldData = true
            end
        end

        -- afmDebug("fruitDesc")
        -- afmDebug(fruitDesc)

        -- Get Field Stage
        local getFieldStage, getWheelsInfo = AFMGuiFieldFrame:getFieldFruitStatusStage(fruitTypeIndexPos, growthState)
        if getFieldStage == nil then
            getFieldStage = g_i18n:getText("text_unknown")
        end

        -- Get field harvest potential
        local harvestMultiplier = field.fieldState:getHarvestScaleMultiplier()
        local fillType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(fruitTypeIndexPos)
        local massPerLiter = nil
        if fillType ~= nil and fillType.massPerLiter ~= nil then
          massPerLiter = fillType.massPerLiter
        end
        local potentialHarvestQty = nil
        local potentialYield = nil
        if fruitDesc ~= nil and fruitDesc.literPerSqm ~= nil and massPerLiter ~= nil then
          local literPerSqm = fruitDesc.literPerSqm
          potentialHarvestQty = literPerSqm * field.areaHa * harvestMultiplier * 10000 -- ha to sqm
          potentialYield = (potentialHarvestQty * massPerLiter) / g_i18n:getArea(field.areaHa)
        end

        local fieldEntry = {
          ["field"] = field,
          ["columns"] = {}
        }

        local fieldFarmland = fieldFarmlandId
        fieldEntry.columns[AFMGuiFieldFrame.COLUMN_FARMLANDS] = {
          ["text"] = fieldFarmland,
          ["value"] = fieldFarmland
        }

        local fieldOwner = farmName
        fieldEntry.columns[AFMGuiFieldFrame.COLUMN_OWNER] = {
          ["text"] = fieldOwner,
          ["value"] = fieldOwner
        }

        local fieldCrop = fruitName
        fieldEntry.columns[AFMGuiFieldFrame.COLUMN_CROPS] = {
          ["text"] = fieldCrop,
          ["value"] = fieldCrop
        }

        local fieldStage = getFieldStage
        fieldEntry.columns[AFMGuiFieldFrame.COLUMN_CROP_STAGES] = {
          ["text"] = fieldStage,
          ["value"] = fieldStage
        }

        -- Check to see what all needs loaded
        local rowIndexes = {}
        local curIndex = 0
        local detailText = {}
        local statusBar = {}
        local thisRawAmount = 0
        local icon = nil
        local iconProduct = nil
        local iconProfile = nil

        -- Display the farmland number
        if field.farmland ~= nil and field.farmland.id then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("fieldInfo_farmland"),
              level = field.farmland.id
            }
            iconProfile = "afm_icon_info2"
            table.insert(rowIndexes, {item = "farmlandId", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Display the land owners name
        if farmName ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_owner"),
              level = farmName
            }
            iconProfile = "afm_icon_ownership"
            table.insert(rowIndexes, {item = "owner", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Output the map compass location
        local vehicleCompassLocation = self:getCompassLocation(field)
        if vehicleCompassLocation ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_location"),
              level = vehicleCompassLocation
            }
            iconProfile = "afm_icon_dirt"
            table.insert(rowIndexes, {item = "compass", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Display the fields fruit type
        if fruitName ~= nil and fillType ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_cropType"),
              level = fruitName
            }
            if fillType ~= nil then
                iconProduct = fillType.hudOverlayFilename
            end
            table.insert(rowIndexes, {item = "type", rowIndex = curIndex, detailText = detailText, iconProduct = iconProduct})
        end

        -- Display the fields fruit type
        if showYieldData and fruitName ~= nil and field.fieldState ~= nil and fruitDesc ~= nil and type(growthState) == "number" and type(fruitDesc.numGrowthStates) == "number" then
            local curGrowthState = growthState
            local maxGrowthState = fruitDesc.numGrowthStates
            local growthPercentage = curGrowthState / maxGrowthState

            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_cropStage"),
              level = getFieldStage
            }
            statusBar = {
                value       = growthPercentage, 
                rawValue    = growthPercentage, 
                levelGood   = 1.1, 
                levelWarn   = 1.2
            }
            iconProfile = "afm_icon_time"
            table.insert(rowIndexes, {item = "stage", rowIndex = curIndex, detailText = detailText, statusBar = statusBar, iconProfile = iconProfile})
        end

        -- Display wheel type
        if getWheelsInfo ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_wheel_type"),
              level = getWheelsInfo
            }
            iconProfile = "afm_icon_tireName"
            table.insert(rowIndexes, {item = "wheel", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Display mission if one
        local playerFarmId    = afmGetPlayerFarmId()
        local currentMissions = g_missionManager:getMissionsByFarmId(playerFarmId)
        local missionDisplay = nil
        for _, thisMission in ipairs(currentMissions) do
            if thisMission.field ~= nil and thisMission.field.fieldId ~= nil and thisMission.field.fieldId == thisField.farmland.id then
                local missionType = g_i18n:getText("text_unknown")
                if thisMission.type.name == "fertilize" then
                    missionType = g_i18n:getText("fieldJob_jobType_fertilizing")
                elseif thisMission.type.name == "spray" then
                    missionType = g_i18n:getText("fieldJob_jobType_spraying")
                elseif thisMission.type.name == "cultivate" then
                    missionType = g_i18n:getText("fieldJob_jobType_cultivating")
                elseif thisMission.type.name == "sow" then
                    missionType = g_i18n:getText("fieldJob_jobType_sowing")
                elseif thisMission.type.name == "harvest" then
                    missionType = g_i18n:getText("fieldJob_jobType_harvesting")
                elseif thisMission.type.name == "mow_bale" then
                    missionType = g_i18n:getText("fieldJob_jobType_baling")
                elseif thisMission.type.name == "plow" then
                    missionType = g_i18n:getText("fieldJob_jobType_plowing")
                elseif thisMission.type.name == "weed" then
                    missionType = g_i18n:getText("fieldJob_jobType_weeding")
                end

                if thisMission.farmId == nil then
                    missionDisplay = string.format(g_i18n:getText("afm_contract_avail"), missionType)
                else
                    missionDisplay = string.format(g_i18n:getText("afm_contract_active"), missionType)
                end
            end
        end
        if missionDisplay ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_contract"),
              level = missionDisplay
            }
            iconProfile = "afm_icon_mission"
            table.insert(rowIndexes, {item = "mission", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Get the field area display
        if field.areaHa ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_fieldArea"),
              level = g_i18n:formatArea(field.areaHa, 2)
            }
            iconProfile = "afm_icon_info2"
            table.insert(rowIndexes, {item = "farmlandArea", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Get the field area display
        if field.farmland.areaInHa ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_farmlandArea"),
              level = g_i18n:formatArea(field.farmland.areaInHa, 2)
            }
            iconProfile = "afm_icon_info2"
            table.insert(rowIndexes, {item = "area", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Sell Value
        if field.farmland.price ~= nil then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_sellValue"),
              level = g_i18n:formatMoney(field.farmland.price, 0, true, true)
            }
            iconProfile = "afm_icon_cost"
            table.insert(rowIndexes, {item = "sellValue", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        if g_modIsLoaded.FS25_precisionFarming ~= nil then

            -- Need to figure out how to get data from PF for this.
            -- local fruitTypeIndex = fieldInfo.fruitTypeIndex
            -- local growthState = fieldInfo.growthState
            -- local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)

            -- if fruitType ~= nil then
            --     -- Determine the max state at which yield should be displayed
            --     local maxValidGrowthState = fruitType.minHarvestingGrowthState - 1
            --     if fruitType.minPreparingGrowthState >= 0 then
            --         maxValidGrowthState = math.min(maxValidGrowthState, fruitType.minPreparingGrowthState - 1)
            --     end

            --     local isValidState =
            --         (growthState > 0 and growthState <= maxValidGrowthState) or
            --         (fruitType.minPreparingGrowthState >= 0 and growthState >= fruitType.minPreparingGrowthState and growthState <= fruitType.maxPreparingGrowthState) or
            --         (growthState >= fruitType.minHarvestingGrowthState and growthState <= fruitType.maxHarvestingGrowthState)

            --     if isValidState then
            --         -- Get base yield scale values
            --         local _, nitrogenBonus, limeBonus, stubbleBonus, rollerBonus = fieldInfo:getHarvestScaleFactors()

            --         -- Base yield factor from bonuses
            --         local yieldFactor = 0
            --         yieldFactor = yieldFactor + nitrogenBonus * 0.1
            --         yieldFactor = yieldFactor + limeBonus * 0.15
            --         yieldFactor = yieldFactor + stubbleBonus * 0.025
            --         yieldFactor = yieldFactor + rollerBonus * 0.025

            --         local yieldPotential = nil
            --         local baseYieldTons = nil

            --         -- Add any yield changes from extensions
            --         for _, infoEntry in ipairs(self.fieldInfos) do
            --             if infoEntry.yieldChangeFunc ~= nil then
            --                 local change, multiplier, potential, tons = infoEntry.yieldChangeFunc(infoEntry.object, infoEntry)
            --                 yieldFactor = yieldFactor + change * multiplier
            --                 yieldPotential = potential or yieldPotential
            --                 baseYieldTons = tons or baseYieldTons
            --             end
            --         end

            --         -- Display expected yield if valid
            --         if yieldPotential ~= nil and yieldPotential > 0 then
            --             local totalYieldPercent = 50 + yieldFactor * 50
            --             local totalYieldFactor = math.ceil(totalYieldPercent) / 100
            --             local expectedYieldTons = totalYieldFactor * baseYieldTons

            --             local expectedYieldText = ""
            --             local expectedYieldLevel = ""
            --             local yieldPotentialText = ""
            --             local yieldPotentialLevel = ""

            --             if baseYieldTons ~= 0 then
            --                 expectedYieldText = g_i18n:getText("fieldInfo_expectedYield")
            --                 expectedYieldLevel = string.format("%d %% | %.1f to/ha", expectedYieldTons * 100, totalYieldFactor * baseYieldTons)
            --                 yieldPotentialText = g_i18n:getText("fieldInfo_yieldPotential")
            --                 yieldPotentialLevel = string.format("%d %% | %.1f to/ha", yieldPotential * 100, baseYieldTons)
            --             else
            --                 expectedYieldText = g_i18n:getText("fieldInfo_expectedYield")
            --                 expectedYieldLevel = string.format("%d %%", expectedYieldTons * 100)
            --                 yieldPotentialText = g_i18n:getText("fieldInfo_yieldPotential")
            --                 yieldPotentialLevel = string.format("%d %%", yieldPotential * 100)
            --             end

            --             curIndex = curIndex + 1
            --             detailText = {
            --               title = expectedYieldText,
            --               level = expectedYieldLevel
            --             }
            --             iconProfile = "afm_icon_info2"
            --             table.insert(rowIndexes, {item = "expectedYield", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})

            --             curIndex = curIndex + 1
            --             detailText = {
            --               title = yieldPotentialText,
            --               level = yieldPotentialLevel
            --             }
            --             iconProfile = "afm_icon_info2"
            --             table.insert(rowIndexes, {item = "yieldPotential", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})


            --         end
            --     end
            -- end

        else
          -- Harvest Potential
          if showYieldData and potentialHarvestQty ~= nil then
              curIndex = curIndex + 1
              detailText = {
                title = g_i18n:getText("afm_harvestPotential"),
                level = g_i18n:formatVolume(potentialHarvestQty, 0)
              }
              iconProfile = "afm_icon_info2"
              table.insert(rowIndexes, {item = "harvestPotential", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
          end

          -- Potential Yield
          if showYieldData and potentialYield ~= nil then
              curIndex = curIndex + 1
              detailText = {
                title = g_i18n:getText("afm_potentialYield"),
                level = string.format("%1.2f T/"..tostring(g_i18n:getAreaUnit()), potentialYield)
              }
              iconProfile = "afm_icon_info2"
              table.insert(rowIndexes, {item = "potentialYield", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
          end

          -- Yield bonus if applicable
          if showYieldData then
              local yieldBonus = MathUtil.round((fieldInfo:getHarvestScaleMultiplier() - 1) * 100)

              curIndex = curIndex + 1
              detailText = {
                title = g_i18n:getText("fieldInfo_yieldBonus"),
                level = string.format("+ %d %%", yieldBonus)
              }
              iconProfile = "afm_icon_info2"
              table.insert(rowIndexes, {item = "yieldBonus", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
          end

          -- Fertilization level
          if fieldInfo.sprayLevel >= 0 then
              local maxSpray = g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
              local sprayPercent = fieldInfo.sprayLevel / maxSpray * 100

              curIndex = curIndex + 1
              detailText = {
                title = g_i18n:getText("ui_growthMapFertilized"),
                level = string.format("%d %%", sprayPercent)
              }
              iconProfile = "afm_icon_info2"
              table.insert(rowIndexes, {item = "yieldBonus", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
          end

          -- Lime required
          if g_currentMission.missionInfo.limeRequired and fieldInfo.limeLevel == 0 then
              curIndex = curIndex + 1
              detailText = {
                title = g_i18n:getText("afm_lime"),
                level = g_i18n:getText("ui_growthMapNeedsLime")
              }
              iconProfile = "afm_icon_info2"
              table.insert(rowIndexes, {item = "needsLime", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
          end
        end

        -- Rolling required
        if fieldInfo.rollerLevel > 0 then
            curIndex = curIndex + 1
            detailText = {
              title = g_i18n:getText("afm_rolling"),
              level = g_i18n:getText("ui_growthMapNeedsRolling")
            }
            iconProfile = "afm_icon_info2"
            table.insert(rowIndexes, {item = "needsRolling", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
        end

        -- Weed information
        if g_modIsLoaded.FS25_precisionFarming ~= nil then
          -- Do this if precision farming is running
          if g_currentMission.missionInfo.weedsEnabled then
              local weedSystem = g_currentMission.weedSystem
              local weedStateLabels = weedSystem:getFieldInfoStates()
              local weedState = fieldInfo.weedState
              local destructionMethod

              if weedState > 0 then
                  local fruitType = fruitTypeIndexPos and g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndexPos) or nil

                  if Platform.gameplay.hasWeeder then
                      if (not fruitType or fruitType:getIsWeedable(growthState)) and
                          weedSystem:getWeederReplacements(false).weed.replacements[weedState] == 0 then
                          destructionMethod = g_i18n:getText("weed_destruction_weeder")
                      end

                      if not destructionMethod and (not fruitType or fruitType:getIsHoeable(growthState)) and
                          weedSystem:getWeederReplacements(true).weed.replacements[weedState] == 0 then
                          destructionMethod = g_i18n:getText("weed_destruction_hoe")
                      end
                  end

                  if not destructionMethod and (not fruitType or fruitType:getIsGrowing(growthState)) then
                      destructionMethod = g_i18n:getText("weed_destruction_herbicide")
                  end

                  local weedLabel = weedStateLabels[weedState]
                  if weedLabel then
                      curIndex = curIndex + 1
                      detailText = {
                        title = weedLabel,
                        level = destructionMethod
                      }
                      iconProfile = "afm_icon_info2"
                      table.insert(rowIndexes, {item = "needsRolling", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                  end
              end
          end
        else
          -- Do this if precision farming not running
          if g_currentMission.missionInfo.weedsEnabled then
              local weedSystem = g_currentMission.weedSystem
              local weedStates = weedSystem:getFieldInfoStates()
              local weedState = fieldInfo.weedState
              local weedMethod

              if weedState > 0 then
                  local fruitType = fruitTypeIndexPos and g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndexPos) or nil

                  if Platform.gameplay.hasWeeder then
                      if (not fruitType or fruitType:getIsWeedable(growthState)) and weedSystem:getWeederReplacements(false).weed.replacements[weedState] == 0 then
                          weedMethod = g_i18n:getText("weed_destruction_weeder")
                      elseif (not weedMethod and (not fruitType or fruitType:getIsHoeable(growthState))) and weedSystem:getWeederReplacements(true).weed.replacements[weedState] == 0 then
                          weedMethod = g_i18n:getText("weed_destruction_hoe")
                      end
                  end

                  if not weedMethod and (not fruitType or fruitType:getIsGrowing(growthState)) then
                      weedMethod = g_i18n:getText("weed_destruction_herbicide")
                  end

                  local weedLabel = weedStates[weedState]
                  if weedLabel then
                      curIndex = curIndex + 1
                      detailText = {
                        title = weedLabel,
                        level = weedMethod
                      }
                      iconProfile = "afm_icon_info2"
                      table.insert(rowIndexes, {item = "needsRolling", rowIndex = curIndex, detailText = detailText, iconProfile = iconProfile})
                  end
              end
          end
        end


        -- Add all of the rows for placeable details display
        field.rowIndexes = rowIndexes

        table.insert(self.fields, fieldEntry)
    end

    self.fieldsList:reloadData()

    if self.fields ~= nil and #self.fields > 0 then
        self:applySorting(self.sortByColumn, self.sortOrder)

        self.fieldsList:reloadData()
        self.fieldsDetail:reloadData()
    else
        -- No fields found.
        self.mainBox:setVisible(false)
        self.itemDetailsMap:setVisible(false)
        self.attributesLayout:setVisible(false)
        -- Show Empty Info
        self.mainBoxEmpty:setVisible(true)
    end
    self:updateView()

end

function AFMGuiFieldFrame:getNumberOfItemsInSection(list, section)
    local selectedIndex = self.fieldsList:getSelectedIndexInSection()
    if selectedIndex ~= nil then
        if list == self.fieldsList and self.fields ~= nil then
            return #self.fields
        elseif self.fields ~= nil and #self.fields > 0 and self.fields[selectedIndex] ~= nil and self.fields[selectedIndex].field ~= nil and self.fields[selectedIndex].field.rowIndexes ~= nil then
            -- Total number or rows for field details.
            return #self.fields[selectedIndex].field.rowIndexes
        else
            return 0
        end
    else
        return 0
    end
end

function AFMGuiFieldFrame:populateCellForItemInSection(list, section, index, cell)
    if list == self.fieldsList then
        local thisField         = self.fields[index].field
        if thisField ~= nil then
            local fieldFarmlandId   = thisField.farmland.id
            local x, z              = thisField:getCenterOfFieldWorldPosition()
            local fruitTypeIndexPos, growthState = FSDensityMapUtil.getFruitTypeIndexAtWorldPos(x, z)
            local fruitDesc         = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndexPos)
            local ownerFarmId       = g_farmlandManager:getFarmlandOwner(fieldFarmlandId)
            local farmName, farmColor = self:getFieldOwnerDisplay(ownerFarmId,fieldFarmlandId)
            local fieldFarmlandIdDisplay = string.format("F-%03d",fieldFarmlandId)

            local fruitName         = "None"
            if fruitDesc ~= nil and fruitDesc.fillType ~= nil then
                fruitName = fruitDesc.fillType.title
            end

            -- Get Field Stage
            local getFieldStage, getWheelsInfo = AFMGuiFieldFrame:getFieldFruitStatusStage(fruitTypeIndexPos, growthState)
            if getFieldStage == nil then
                getFieldStage = g_i18n:getText("text_unknown")
            end

            cell:getAttribute("dotBg").color = { 0.02956, 0.02956, 0.02956, 0.5 }
            cell:getAttribute("dot").color = farmColor
            cell:getAttribute("farmland"):setText(fieldFarmlandIdDisplay)
            cell:getAttribute("owner"):setText(farmName)            
            cell:getAttribute("stage"):setText(getFieldStage)

            cell:getAttribute("crop"):setText(fruitName)

            if fruitName == "None" then
              cell:getAttribute("crop"):applyProfile("afmMenuVehicleItemCropNone")
            else
              cell:getAttribute("crop"):applyProfile("afmMenuVehicleItemCrop")
            end

            if fruitDesc ~= nil and fruitDesc.fillType ~= nil and fruitDesc.fillType.hudOverlayFilename ~= nil then
              cell:getAttribute("cropIcon"):setImageFilename(fruitDesc.fillType.hudOverlayFilename)
              cell:getAttribute("cropIcon"):setVisible(true)
            else
              cell:getAttribute("cropIcon"):setVisible(false)
            end
            
        end
    else
        local selectedIndex    = self.fieldsList.selectedIndex
        local thisField        = self.fields[selectedIndex].field

        if thisField ~= nil then
            self.fieldsDetail:setVisible(true)
            self.afmInfoSubVeh:setVisible(true)

            local rowIndexes = thisField.rowIndexes

            -- Load up the placeable details display
            if rowIndexes ~= nil and rowIndexes[index] ~= nil then

                local nukeBar = true
                if rowIndexes[index].statusBar ~= nil and rowIndexes[index].statusBar.value ~= nil and rowIndexes[index].statusBar.rawValue ~= nil and rowIndexes[index].statusBar.levelGood ~= nil and rowIndexes[index].statusBar.levelWarn ~= nil then
                    self:setStatusBarValue(cell:getAttribute("detailBar"), rowIndexes[index].statusBar.value, rowIndexes[index].statusBar.rawValue, rowIndexes[index].statusBar.levelGood, rowIndexes[index].statusBar.levelWarn)
                    nukeBar = false
                end

                if rowIndexes[index].detailText ~= nil and rowIndexes[index].detailText.title ~= nil and rowIndexes[index].detailText.level ~= nil then
                    self:setDetailText(cell, nukeBar,rowIndexes[index].detailText.title,rowIndexes[index].detailText.level)
                end

                if rowIndexes[index].icon ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIcon")
                    cell:getAttribute("fillIcon"):setImageFilename(rowIndexes[index].icon)
                    cell:getAttribute("fillIcon"):setVisible(true)
                    cell:getAttribute("itemIcon"):setVisible(false)
                elseif rowIndexes[index].iconProfile ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIcon")
                    cell:getAttribute("itemIcon"):applyProfile(rowIndexes[index].iconProfile)
                    cell:getAttribute("itemIcon"):setVisible(true)
                    cell:getAttribute("fillIcon"):setVisible(false)
                elseif rowIndexes[index].iconProduct ~= nil then
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleIconProduct")
                    cell:getAttribute("fillIcon"):setImageFilename(rowIndexes[index].iconProduct)
                    cell:getAttribute("fillIcon"):applyProfile("afmMenuVehicleDetailIconNoBar")
                    cell:getAttribute("fillIcon"):setVisible(true)
                    cell:getAttribute("itemIcon"):setVisible(false)
                else
                    cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitle")
                    cell:getAttribute("fillIcon"):setVisible(false)
                    cell:getAttribute("itemIcon"):setVisible(false)
                end

                cell:setVisible(true)
            else
                -- Clear out any cells from previous selection
                cell:setVisible(false)
            end

        else
            -- hide UI, no placeable
            self.fieldsDetail:setVisible(false)
            self.afmInfoSubVeh:setVisible(false)
        end
    end
end

function AFMGuiFieldFrame:setDetailText(cell, nukeBar, title, level)
    cell:getAttribute("detailBarBG"):setVisible(true)
    cell:getAttribute("detailBar"):setVisible(true)

    if title == "" then
        cell:getAttribute("detailTitle"):setText("")
    else
        cell:getAttribute("detailTitle"):setText(title)
    end

    cell:getAttribute("detailLevel"):setText(level)

    if nukeBar then
        cell:getAttribute("detailLevel"):applyProfile("afmMenuVehicleDetailLevelNoBar")
        cell:getAttribute("detailTitle"):applyProfile("afmMenuVehicleDetailTitleNoBar")
        cell:getAttribute("detailBarBG"):setVisible(false)
        cell:getAttribute("detailBar"):setVisible(false)
    end
end

function AFMGuiFieldFrame:setStatusBarValue(statusBarElement, value, rawValue, levelGood, levelWarn)
    if levelGood ~= nil and levelWarn ~= nil then
      if rawValue < levelGood then
          statusBarElement:applyProfile("afmMenuVehicleDetailBar")
      elseif rawValue < levelWarn then
          statusBarElement:applyProfile("afmMenuVehicleDetailBarWarning")
      else
          statusBarElement:applyProfile("afmMenuVehicleDetailBarDanger")
      end
    else
        statusBarElement:applyProfile("afmMenuVehicleDetailBar")
    end

    local fullWidth = statusBarElement.parent.absSize[1] - statusBarElement.margin[1] * 2
    local minSize = 0

    if statusBarElement.startSize ~= nil then
        minSize = statusBarElement.startSize[1] + statusBarElement.endSize[1]
    end

    -- Clamp value to 1 (100%) max
    local clampedValue = math.max(0, math.min(1, value))

    statusBarElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function AFMGuiFieldFrame.updateView(self)
    local sortByColumn = self.sortByColumn
    local sortOrder = self.sortOrder

    -- Update sorting icons
    for columnIndex, iconSet in pairs(self.sortIcons) do
        local isCurrentSortColumn = columnIndex == sortByColumn
        local descendingIcon = iconSet[AFMGuiFieldFrame.SORT_ORDER_DESC]
        local showDescendingIcon

        if isCurrentSortColumn then
            showDescendingIcon = sortOrder == AFMGuiFieldFrame.SORT_ORDER_DESC
        else
            showDescendingIcon = false
        end

        descendingIcon:setVisible(showDescendingIcon)

        local ascendingIcon = iconSet[AFMGuiFieldFrame.SORT_ORDER_ASC]
        local showAscendingIcon = isCurrentSortColumn and sortOrder == AFMGuiFieldFrame.SORT_ORDER_ASC

        ascendingIcon:setVisible(showAscendingIcon)
    end

    -- Sort the field list
    table.sort(self.fields, function(fieldA, fieldB)
        local valueA = fieldA.columns[sortByColumn].value
        local valueB = fieldB.columns[sortByColumn].value

        if valueA == valueB then
            -- If primary sort values are equal, sort by name
            valueA = fieldA.columns[AFMGuiFieldFrame.COLUMN_FARMLANDS].value
            valueB = fieldB.columns[AFMGuiFieldFrame.COLUMN_FARMLANDS].value
            
            -- if valueA == valueB then
            --     -- If names are also equal, sort by a secondary value column
            --     valueA = fieldA.columns[AFMGuiFieldFrame.COLUMN_VALUE].value
            --     valueB = fieldB.columns[AFMGuiFieldFrame.COLUMN_VALUE].value
            -- end
        end

        if sortOrder == AFMGuiFieldFrame.SORT_ORDER_DESC then
            return valueB < valueA -- Descending order
        else
            return valueA < valueB -- Ascending order
        end
    end)

    -- Refresh the field list and UI elements
    self.fieldsList:reloadData()
    self.fieldsDetail:reloadData()
    self:updateMenuButtons()
end

function AFMGuiFieldFrame:getFieldFruitStatus(fruitTypeIndex,fruitGrowthState)
    if fruitTypeIndex == nil then
        return
    end
    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
    if fruitType ~= nil then
        local maxGrowingState = fruitType.minHarvestingGrowthState - 1
        if fruitType.minPreparingGrowthState >= 0 then
            maxGrowingState = math.min(maxGrowingState, fruitType.minPreparingGrowthState - 1)
        end
        local text = nil
        if fruitGrowthState == fruitType.cutState then
            text = g_i18n:getText("ui_growthMapCut")
        elseif fruitType:getIsWithered(fruitGrowthState) then
            text = g_i18n:getText("ui_growthMapWithered")
        elseif fruitGrowthState > 0 and fruitGrowthState <= maxGrowingState then
            text = g_i18n:getText("ui_growthMapGrowing")
        elseif fruitType.minPreparingGrowthState >= 0 and fruitType.minPreparingGrowthState <= fruitGrowthState and fruitGrowthState <= fruitType.maxPreparingGrowthState then
            text = g_i18n:getText("ui_growthMapReadyToPrepareForHarvest")
        elseif fruitType.minHarvestingGrowthState <= fruitGrowthState and fruitGrowthState <= fruitType.maxHarvestingGrowthState then
            text = g_i18n:getText("ui_growthMapReadyToHarvest")
        end
        if text ~= nil then
            return text
        else 
            return g_i18n:getText("text_unknown")
        end
    else
        return g_i18n:getText("text_unknown")
    end
end

function AFMGuiFieldFrame:getFieldFruitStatusStage(fruitTypeIndex,fruitGrowthState)
    -- rcDebug("FieldStats:getFieldFruitStatusStage")
    local fruitType
    if fruitTypeIndex == nil then
        fruitType = nil
    else
        fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
    end
    local growthState = g_i18n:getText("afm_none")
    local wheelsInfo = g_i18n:getText("afm_All_Wheels")
    -- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
    if (fruitType ~= nil and fruitGrowthState ~= nil) then
        local maxGrowthState = fruitType.numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
        -- Growth stage info
        if (fruitGrowthState ~= nil and fruitGrowthState > 0 and fruitGrowthState <= maxGrowthState) then
            -- Crop is in the one of the 'growing' states
            if fruitType.minForageGrowthState ~= 0 and fruitType.maxForageGrowthState ~= 0 and (fruitGrowthState >= fruitType.minForageGrowthState and fruitGrowthState <= fruitType.maxForageGrowthState) then
                -- Crop can be harvested by forage harvester already
                growthState = string.format("%s/%s (%s)", fruitGrowthState, maxGrowthState, g_i18n:getText("afm_Foragable"));
            else
                -- Crop cannot be harvested by forage harvester yet
                growthState =  string.format("%s/%s", fruitGrowthState, maxGrowthState);
            end
        elseif fruitType:getIsWithered(fruitGrowthState) then
            growthState = g_i18n:getText("ui_growthMapWithered")
        elseif fruitType.minHarvestingGrowthState <= fruitGrowthState and fruitGrowthState <= fruitType.maxHarvestingGrowthState then
            growthState = g_i18n:getText("ui_growthMapReadyToHarvest")
        end

        -- Wheel type info
        if (fruitGrowthState ~= nil and fruitType ~= nil and fruitType.minWheelDestructionState ~= nil and fruitType.maxWheelDestructionState ~= nil) then
            -- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
            local narrowWheelsRequired = fruitGrowthState >= fruitType.minWheelDestructionState 
                and fruitGrowthState <= fruitType.maxWheelDestructionState 
                and fruitGrowthState ~= fruitType.wheelDestructionState
            wheelsInfo = (narrowWheelsRequired and g_i18n:getText("afm_Narrow_Wheels")) or g_i18n:getText("afm_All_Wheels")
        end
    end
    return growthState, wheelsInfo
end

function AFMGuiFieldFrame:onListSelectionChanged(list, section, index)
    if list == self.fieldsList then
        if self.fields[index] ~= nil and self.fields[index].field ~= nil then

            local thisField = self.fields[index].field

            if thisField ~= nil then

                local centerX, centerZ = thisField:getCenterOfFieldWorldPosition()

                self.itemDetailsMap:setCenterToWorldPosition(centerX, centerZ)
                self.itemDetailsMap:setMapZoom(3)
                self.itemDetailsMap:setMapAlpha(1)

                self.fieldsDetail:reloadData()

            end
        end
    end
    self:updateMenuButtons()
end

function AFMGuiFieldFrame:getCompassLocation(thisPlace)
    local wx, _, wz = getWorldTranslation(thisPlace.nameIndicator)

    local thirdTerrainSize = g_currentMission.terrainSize / 6

    if wx == 0 and wz == 0 then
        return "--"
    end

    if math.abs(wx) < thirdTerrainSize and math.abs(wz) < thirdTerrainSize then
        return g_i18n:getText("afm_locate_center")
    end

    if math.abs(wx) < thirdTerrainSize then
        if wz < 1 then
            return g_i18n:getText("afm_locate_n")
        end
        return g_i18n:getText("afm_locate_s")
    end

    if math.abs(wz) < thirdTerrainSize then
        if wx < 1 then
            return g_i18n:getText("afm_locate_w")
        end
        return g_i18n:getText("afm_locate_e")
    end

    if wx < 1 then
        if wz < 1 then
            return(g_i18n:getText("afm_locate_nw"))
        end
        return g_i18n:getText("afm_locate_sw")
    end

    if wz < 1 then
        return g_i18n:getText("afm_locate_ne")
    end

    return g_i18n:getText("afm_locate_se")
end


function AFMGuiFieldFrame:onButtonWarpField()
    local dropHeight       = 1.2
    local thisPlace        = self.fields[self.fieldsList.selectedIndex].field
    local warpX, _,  warpZ = getWorldTranslation(thisPlace.teleportNode)

    local playerDropHeight = getTerrainHeightAtWorldPos(g_terrainNode, warpX, 0, warpZ) + dropHeight

    g_localPlayer:leaveVehicle()

    if not g_currentMission.controlPlayer and g_currentMission.controlledVehicle ~= nil then
        g_currentMission:onLeaveVehicle(warpX, playerDropHeight, warpZ, false, false)
    else
        g_localPlayer:teleportTo(warpX, playerDropHeight, warpZ, false, false)
    end

    g_gui:showGui("")
end

function AFMGuiFieldFrame:onButtonHotspotField()
    local thisPlace        = self.fields[self.fieldsList.selectedIndex].field
    local hotspot          = thisPlace.farmland.mapHotspot

    if hotspot == g_currentMission.currentMapTargetHotspot then
        g_currentMission:setMapTargetHotspot(nil)
    else
        g_currentMission:setMapTargetHotspot(hotspot)
    end

    self:rebuildTable()
end


function AFMGuiFieldFrame:getFieldOwnerDisplay(ownerFarmId,farmlandId)
    local farmName
    local farmColor = { 0, 0, 0, 1 }
    local playerFarmId = afmGetPlayerFarmId()
    if ownerFarmId == playerFarmId and ownerFarmId ~= FarmManager.SPECTATOR_FARM_ID then
      farmName = g_i18n:getText("fieldInfo_ownerYou")
      local farm = g_farmManager:getFarmById(ownerFarmId)
      farmColor = farm:getColor()
    elseif ownerFarmId == AccessHandler.EVERYONE or ownerFarmId == AccessHandler.NOBODY then
      local farmLand = g_farmlandManager:getFarmlandById(farmlandId)
      if farmLand == nil then
        farmName = g_i18n:getText("fieldInfo_ownerNobody")
      else
        local farmNPC = farmLand:getNPC()
        farmName = farmNPC ~= nil and farmNPC.title or g_i18n:getText("text_unknown")
      end
    else
      local farm = g_farmManager:getFarmById(ownerFarmId)
      if farm == nil then
        farmName = g_i18n:getText("text_unknown")
      else
        farmName = farm.name
        local farm = g_farmManager:getFarmById(ownerFarmId)
        farmColor = farm:getColor()
      end
    end
    return farmName, farmColor
end


function AFMGuiFieldFrame.applySorting(self, column, sortOrder)
    if sortOrder == nil then
        if self.sortByColumn == column and self.sortOrder ~= AFMGuiFieldFrame.SORT_ORDER_ASC then
            self.sortOrder = AFMGuiFieldFrame.SORT_ORDER_ASC
        else
            self.sortOrder = AFMGuiFieldFrame.SORT_ORDER_DESC
        end
    else
        self.sortOrder = sortOrder
    end
    self.sortByColumn = column
    self:updateView()
end

function AFMGuiFieldFrame.onClickButtonSortByFarmlands(self)
	  self:applySorting(AFMGuiFieldFrame.COLUMN_FARMLANDS)
end
function AFMGuiFieldFrame.onClickButtonSortByOwner(self)
	  self:applySorting(AFMGuiFieldFrame.COLUMN_OWNER)
end
function AFMGuiFieldFrame.onClickButtonSortByCrops(self)
	  self:applySorting(AFMGuiFieldFrame.COLUMN_CROPS)
end

function AFMGuiFieldFrame.onClickButtonSortByCropStage(self)
	  self:applySorting(AFMGuiFieldFrame.COLUMN_CROP_STAGES)
end

function AFMGuiFieldFrame.onCreateButtonSortByFarmlands(self, button)
    self.sortIcons[AFMGuiFieldFrame.COLUMN_FARMLANDS] = {
        [AFMGuiFieldFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiFieldFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiFieldFrame.onCreateButtonSortByOwner(self, button)
    self.sortIcons[AFMGuiFieldFrame.COLUMN_OWNER] = {
        [AFMGuiFieldFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiFieldFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiFieldFrame.onCreateButtonSortByCrops(self, button)
    self.sortIcons[AFMGuiFieldFrame.COLUMN_CROPS] = {
        [AFMGuiFieldFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiFieldFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiFieldFrame.onCreateButtonSortByCropStage(self, button)
    self.sortIcons[AFMGuiFieldFrame.COLUMN_CROP_STAGES] = {
        [AFMGuiFieldFrame.SORT_ORDER_ASC] = button:getDescendantByName("iconAscending"),
        [AFMGuiFieldFrame.SORT_ORDER_DESC] = button:getDescendantByName("iconDescending")
    }
end

function AFMGuiFieldFrame.onMoneyChange(self)
	if g_localPlayer ~= nil then
		local farm = g_farmManager:getFarmById(g_localPlayer.farmId)
		if farm.money <= -1 then
			self.currentBalanceText:applyProfile("afm_moneyNeg", nil, true)
		else
			self.currentBalanceText:applyProfile("afm_money", nil, true)
		end
		local moneyText = g_i18n:formatMoney(farm.money, 0, true, true)
		self.currentBalanceText:setText(moneyText)
		if self.moneyBox ~= nil then
			self.moneyBox:invalidateLayout()
			self.moneyBoxBg:setSize(self.moneyBox.flowSizes[1] + 50 * g_pixelSizeScaledX)
		end
	end
  self:rebuildTable()
end




