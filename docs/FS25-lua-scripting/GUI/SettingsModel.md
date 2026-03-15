## SettingsModel

**Description**

> Provides an interface model between game settings and the UI for re-use between several components. The model keeps
> a common, transient state until saved. When saving, the settings are applied to the global game settings and written
> to the player's configuration file.

**Functions**

- [addCloudShadowsQualitySetting](#addcloudshadowsqualitysetting)
- [addFoliageDrawDistanceSetting](#addfoliagedrawdistancesetting)
- [addFoliageLODDistanceSetting](#addfoliageloddistancesetting)
- [addFoliageShadowSetting](#addfoliageshadowsetting)
- [addLODDistanceSetting](#addloddistancesetting)
- [addManagedSettings](#addmanagedsettings)
- [addMaxTireTracksSetting](#addmaxtiretrackssetting)
- [addObjectDrawDistanceSetting](#addobjectdrawdistancesetting)
- [addSetting](#addsetting)
- [addShaderQualitySetting](#addshaderqualitysetting)
- [addShadingRateQualitySetting](#addshadingratequalitysetting)
- [addShadowDistanceQualitySetting](#addshadowdistancequalitysetting)
- [addShadowMapFilteringSetting](#addshadowmapfilteringsetting)
- [addShadowMaxLightsSetting](#addshadowmaxlightssetting)
- [addShadowQualitySetting](#addshadowqualitysetting)
- [addSoftShadowsSetting](#addsoftshadowssetting)
- [addSSAOQualitySetting](#addssaoqualitysetting)
- [addTerrainLODDistanceSetting](#addterrainloddistancesetting)
- [addTerrainQualitySetting](#addterrainqualitysetting)
- [addTextureResolutionSetting](#addtextureresolutionsetting)
- [addVolumeMeshTessellationSetting](#addvolumemeshtessellationsetting)
- [applyChanges](#applychanges)
- [applyCustomSettings](#applycustomsettings)
- [applyPerformanceClass](#applyperformanceclass)
- [createControlDisplayValues](#createcontroldisplayvalues)
- [getAreaUnitTexts](#getareaunittexts)
- [getAudioVolumeTexts](#getaudiovolumetexts)
- [getBrightnessTexts](#getbrightnesstexts)
- [getCameraSensitivityTexts](#getcamerasensitivitytexts)
- [getCurrentDeviceName](#getcurrentdevicename)
- [getCurrentDeviceSensitivityValue](#getcurrentdevicesensitivityvalue)
- [getDeadzoneTexts](#getdeadzonetexts)
- [getDeviceAxisDeadzoneValue](#getdeviceaxisdeadzonevalue)
- [getDeviceAxisSensitivityValue](#getdeviceaxissensitivityvalue)
- [getDeviceHasAxisDeadzone](#getdevicehasaxisdeadzone)
- [getDeviceHasAxisSensitivity](#getdevicehasaxissensitivity)
- [getDirectionChangeModeTexts](#getdirectionchangemodetexts)
- [getDistanceUnitTexts](#getdistanceunittexts)
- [getDRSTargetFPSTexts](#getdrstargetfpstexts)
- [getFoliageDrawDistanceTexts](#getfoliagedrawdistancetexts)
- [getFoliageLODDistanceTexts](#getfoliageloddistancetexts)
- [getForceFeedbackTexts](#getforcefeedbacktexts)
- [getFovYTexts](#getfovytexts)
- [getFrameLimitTexts](#getframelimittexts)
- [getFullscreenModeTexts](#getfullscreenmodetexts)
- [getGearShiftModeTexts](#getgearshiftmodetexts)
- [getHDRContrastTexts](#gethdrcontrasttexts)
- [getHDRPeakBrightnessTexts](#gethdrpeakbrightnesstexts)
- [getHeadTrackingSensitivityTexts](#getheadtrackingsensitivitytexts)
- [getHeadTrackingSensitivityValue](#getheadtrackingsensitivityvalue)
- [getHudSpeedGaugeTexts](#gethudspeedgaugetexts)
- [getInputHelpModeTexts](#getinputhelpmodetexts)
- [getIsDeviceMouse](#getisdevicemouse)
- [getIsLanguageDisabled](#getislanguagedisabled)
- [getLanguageTexts](#getlanguagetexts)
- [getLightsProfileTexts](#getlightsprofiletexts)
- [getLODDistanceTexts](#getloddistancetexts)
- [getMaxMirrorsTexts](#getmaxmirrorstexts)
- [getMaxTireTracksTexts](#getmaxtiretrackstexts)
- [getMoneyUnitTexts](#getmoneyunittexts)
- [getMouseSensitivityValue](#getmousesensitivityvalue)
- [getMPLanguageTexts](#getmplanguagetexts)
- [getNumDevices](#getnumdevices)
- [getObjectDrawDistanceTexts](#getobjectdrawdistancetexts)
- [getOverlayBrightnessTexts](#getoverlaybrightnesstexts)
- [getPerformanceClassTexts](#getperformanceclasstexts)
- [getPostProcessAAToolTip](#getpostprocessaatooltip)
- [getRadioModeTexts](#getradiomodetexts)
- [getRealBeaconLightBrightnessTexts](#getrealbeaconlightbrightnesstexts)
- [getRecordingVolumeTexts](#getrecordingvolumetexts)
- [getResolutionScale3dTexts](#getresolutionscale3dtexts)
- [getResolutionScaleTexts](#getresolutionscaletexts)
- [getResolutionTexts](#getresolutiontexts)
- [getSensitivityTexts](#getsensitivitytexts)
- [getShaderQualityTexts](#getshaderqualitytexts)
- [getShadingRateQualityTexts](#getshadingratequalitytexts)
- [getShadowDistanceQualityTexts](#getshadowdistancequalitytexts)
- [getShadowMapFilteringTexts](#getshadowmapfilteringtexts)
- [getShadowMapLightsTexts](#getshadowmaplightstexts)
- [getShadowQualityTexts](#getshadowqualitytexts)
- [getSoftShadowsTexts](#getsoftshadowstexts)
- [getSSAOQualityTexts](#getssaoqualitytexts)
- [getSteeringBackSpeedTexts](#getsteeringbackspeedtexts)
- [getTemperatureUnitTexts](#gettemperatureunittexts)
- [getTerraingQualityTexts](#getterraingqualitytexts)
- [getTerrainLODDistanceTexts](#getterrainloddistancetexts)
- [getTextureResolutionTexts](#gettextureresolutiontexts)
- [getUiScaleTexts](#getuiscaletexts)
- [getValue](#getvalue)
- [getVehicleArmSensitivityTexts](#getvehiclearmsensitivitytexts)
- [getVoiceInputSensitivityTexts](#getvoiceinputsensitivitytexts)
- [getVoiceModeTexts](#getvoicemodetexts)
- [getVolumeMeshTessalationTexts](#getvolumemeshtessalationtexts)
- [hasChanges](#haschanges)
- [hasDeviceChanges](#hasdevicechanges)
- [initDeviceSettings](#initdevicesettings)
- [initialize](#initialize)
- [needsProcessRestartToApplyChanges](#needsprocessrestarttoapplychanges)
- [needsRestartToApplyChanges](#needsrestarttoapplychanges)
- [new](#new)
- [nextDevice](#nextdevice)
- [refresh](#refresh)
- [refreshChangedValue](#refreshchangedvalue)
- [reset](#reset)
- [resetDeviceChanges](#resetdevicechanges)
- [saveChanges](#savechanges)
- [saveDeviceChanges](#savedevicechanges)
- [setDeviceDeadzoneValue](#setdevicedeadzonevalue)
- [setDeviceSensitivityValue](#setdevicesensitivityvalue)
- [setHeadTrackingSensitivity](#setheadtrackingsensitivity)
- [setMouseSensitivity](#setmousesensitivity)
- [setValue](#setvalue)

### addCloudShadowsQualitySetting

**Description**

**Definition**

> addCloudShadowsQualitySetting()

**Code**

```lua
function SettingsModel:addCloudShadowsQualitySetting()
    local function readValue()
        return getCloudShadowsQuality() = = 1
    end

    local function writeValue(value)
        setCloudShadowsQuality(value and 1 or 0 )
    end

    self:addSetting( SettingsModel.SETTING.CLOUD_SHADOWS_QUALITY, readValue, writeValue)
end

```

### addFoliageDrawDistanceSetting

**Description**

**Definition**

> addFoliageDrawDistanceSetting()

**Code**

```lua
function SettingsModel:addFoliageDrawDistanceSetting()
    local function readValue()
        return Utils.getValueIndex(getFoliageViewDistanceCoeff(), self.percentValues)
    end

    local function writeValue(value)
        setFoliageViewDistanceCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.FOLIAGE_DRAW_DISTANCE, readValue, writeValue)
end

```

### addFoliageLODDistanceSetting

**Description**

**Definition**

> addFoliageLODDistanceSetting()

**Code**

```lua
function SettingsModel:addFoliageLODDistanceSetting()
    local function readValue()
        return Utils.getValueIndex(getFoliageLODDistanceCoeff(), self.percentValues)
    end

    local function writeValue(value)
        setFoliageLODDistanceCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.FOLIAGE_LOD_DISTANCE, readValue, writeValue)
end

```

### addFoliageShadowSetting

**Description**

**Definition**

> addFoliageShadowSetting()

**Code**

```lua
function SettingsModel:addFoliageShadowSetting()
    local function readValue()
        return getAllowFoliageShadows()
    end

    local function writeValue(value)
        setAllowFoliageShadows(value)
    end

    self:addSetting( SettingsModel.SETTING.FOLIAGE_SHADOW, readValue, writeValue)
end

```

### addLODDistanceSetting

**Description**

**Definition**

> addLODDistanceSetting()

**Code**

```lua
function SettingsModel:addLODDistanceSetting()
    local function readValue()
        return Utils.getValueIndex(getLODDistanceCoeff(), self.percentValues)
    end

    local function writeValue(value)
        setLODDistanceCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.LOD_DISTANCE, readValue, writeValue)
end

```

### addManagedSettings

**Description**

> Add managed valid settings which receive their initial value from the loaded game settings or the engine.

**Definition**

> addManagedSettings()

**Code**

```lua
function SettingsModel:addManagedSettings()
    if not Platform.isConsole then
        --this should always be added first, otherwise it overwrites default values for other settings
            self:addPerformanceClassSetting()

            self:addEngineQualitySetting( SettingsModel.SETTING.ATMOSPHERE_QUALITY, AtmosphereQuality, getSupportsAtmosphereQuality, getAtmosphereQualityName, setAtmosphereQuality, getAtmosphereQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.DRS_QUALITY, DRSQuality, getSupportsDRSQuality, getDRSQualityName, setDRSQuality, getDRSQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.LENSFLARE_QUALITY, LensFlareQuality, getSupportsLensFlareQuality, getLensFlareQualityName, setLensFlareQuality, getLensFlareQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.VOLUMETRIC_FOG_QUALITY, VolumetricFogQuality, getSupportsVolumetricFogQuality, getVolumetricFogQualityName, setVolumetricFogQuality, getVolumetricFogQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.SCREEN_SPACE_REFLECTIONS, ScreenSpaceReflectionsQuality, getSupportsScreenSpaceReflectionsQuality, getScreenSpaceReflectionsQualityName, setScreenSpaceReflectionsQuality, getScreenSpaceReflectionsQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.SCREEN_SPACE_SHADOWS_QUALITY, ScreenSpaceShadowsQuality, getSupportsScreenSpaceShadowsQuality, getScreenSpaceShadowsQualityName, setScreenSpaceShadowsQuality, getScreenSpaceShadowsQuality)
            self:addEngineQualitySetting( SettingsModel.SETTING.TEXTURE_FILTERING, TEXTURE_FILTERING, nil , getTextureFilteringName, setTextureFiltering, getTextureFiltering, nil , nil , false )

            -- Upscalers need to disable other features
            self:addEngineQualitySetting( SettingsModel.SETTING.DLSS, DLSSQuality, getSupportsDLSSQuality, getDLSSQualityName, setDLSSQuality, getDLSSQuality, function (value, rawValue, hasChanged)
                if rawValue ~ = DLSSQuality.OFF then
                    self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE, SettingsModel.getScalingStateFromResolutionScaling( 1 ))
                    self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE_3D, SettingsModel.getScalingStateFromResolutionScaling( 1 ))

                    -- Disable MSAA, PPAA and FSR 1.0, FSR 2.0, XeSS, Valar
                    self:setRawValue( SettingsModel.SETTING.MSAA, MSAA.OFF)
                    self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality.OFF)
                    self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality.OFF)
                    self:setRawValue( SettingsModel.SETTING.XESS, XeSSQuality.OFF)
                    self:setRawValue( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing.OFF)
                else
                        self:setRawValue( SettingsModel.SETTING.DLSS_FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                    end
                end , true )
                self:addEngineQualitySetting( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality, getSupportsFidelityFxSRQuality, getFidelityFxSRQualityName, setFidelityFxSRQuality, getFidelityFxSRQuality, function (value, rawValue, hasChanged)
                    if rawValue ~ = FidelityFxSRQuality.OFF then
                        self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE, SettingsModel.getScalingStateFromResolutionScaling( 1 ))
                        self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE_3D, SettingsModel.getScalingStateFromResolutionScaling( 1 ))

                        -- Enable TAA by default when using FxSR(usually looks pretty bad if TAA is off)
                            -- disable DLSS, FSR 2.0, XeSS, Valar
                            self:setRawValue( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing.TAA)
                            self:setRawValue( SettingsModel.SETTING.DLSS, DLSSQuality.OFF)
                            self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality.OFF)
                            self:setRawValue( SettingsModel.SETTING.XESS, XeSSQuality.OFF)
                        end
                    end , true )
                    self:addEngineQualitySetting( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality, getSupportsFidelityFxSR30Quality, getFidelityFxSR30QualityName, setFidelityFxSR30Quality, getFidelityFxSR30Quality, function (value, rawValue, hasChanged)
                        if rawValue ~ = FidelityFxSR30Quality.OFF then
                            self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE, SettingsModel.getScalingStateFromResolutionScaling( 1 ))
                            self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE_3D, SettingsModel.getScalingStateFromResolutionScaling( 1 ))

                            -- disable DLSS, PostFX AA, FSR 1.0, XeSS, Valar
                            self:setRawValue( SettingsModel.SETTING.MSAA, MSAA.OFF)
                            self:setRawValue( SettingsModel.SETTING.DLSS, DLSSQuality.OFF)
                            self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality.OFF)
                            self:setRawValue( SettingsModel.SETTING.XESS, XeSSQuality.OFF)
                            self:setRawValue( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing.OFF)
                        else
                                self:setValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 _FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                            end
                        end , true )
                        self:addEngineQualitySetting( SettingsModel.SETTING.VALAR, ValarQuality, getSupportsValarQuality, getValarQualityName, setValarQuality, getValarQuality, function (value, rawValue, hasChanged)
                            if rawValue ~ = ValarQuality.OFF then
                                -- (TAA is currently incompatible with shading rate image-based techniques)
                                -- disable DLSS, disable PostFX AA, FSR 1.0, set MSAA to 1
                                g_settingsModel:setRawValue( SettingsModel.SETTING.MSAA, MSAA.OFF)
                            end
                        end )
                        self:addEngineQualitySetting( SettingsModel.SETTING.XESS, XeSSQuality, getSupportsXeSSQuality, getXeSSQualityName, setXeSSQuality, getXeSSQuality, function (value, rawValue, hasChanged)
                            if rawValue ~ = XeSSQuality.OFF then
                                self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE, SettingsModel.getScalingStateFromResolutionScaling( 1 ))
                                self:setRawValue( SettingsModel.SETTING.RESOLUTION_SCALE_3D, SettingsModel.getScalingStateFromResolutionScaling( 1 ))

                                -- disable DLSS, ostFX AA, FSR 1.0, FSR 2.0
                                self:setRawValue( SettingsModel.SETTING.MSAA, MSAA.OFF)
                                self:setRawValue( SettingsModel.SETTING.DLSS, DLSSQuality.OFF)
                                self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality.OFF)
                                self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality.OFF)
                                self:setRawValue( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing.OFF)
                            end
                        end , true )
                        self:addEngineQualitySetting( SettingsModel.SETTING.MSAA, MSAA, nil , getMSAAName, setMSAA, getMSAA, function (value, rawValue, hasChanged)
                            if rawValue ~ = MSAA.OFF then
                                self:setRawValue( SettingsModel.SETTING.DLSS, DLSSQuality.OFF)
                                self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality.OFF)
                                self:setRawValue( SettingsModel.SETTING.XESS, XeSSQuality.OFF)

                                --TAA is allowed together with MSAA, but no other PPAA mode is compatible with MSAA
                                if self:getRawValue( SettingsModel.SETTING.POST_PROCESS_AA) ~ = PostProcessAntiAliasing.TAA and self:getRawValue( SettingsModel.SETTING.POST_PROCESS_AA) ~ = PostProcessAntiAliasing.OFF then
                                    self:setRawValue( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing.OFF)
                                end
                            end
                        end )
                        self:addEngineQualitySetting( SettingsModel.SETTING.POST_PROCESS_AA, PostProcessAntiAliasing, getSupportsPostProcessAntiAliasing, getPostProcessAntiAliasingName, setPostProcessAntiAliasing, getPostProcessAntiAliasing, function (value, rawValue, hasChanged)
                            if rawValue ~ = PostProcessAntiAliasing.OFF then
                                -- Disable dlss, FSR 2.0, XeSS
                                self:setRawValue( SettingsModel.SETTING.DLSS, DLSSQuality.OFF)
                                self:setRawValue( SettingsModel.SETTING.DLSS_FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 , FidelityFxSR30Quality.OFF)
                                self:setRawValue( SettingsModel.SETTING.XESS, XeSSQuality.OFF)

                                if rawValue ~ = PostProcessAntiAliasing.FSR3 then
                                    self:setValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 _FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                end
                                if rawValue ~ = PostProcessAntiAliasing.XESS then
                                    self:setValue( SettingsModel.SETTING.XESS_FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                end
                                if rawValue ~ = PostProcessAntiAliasing.DLAA then
                                    self:setRawValue( SettingsModel.SETTING.DLSS_FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                end

                                if rawValue ~ = PostProcessAntiAliasing.TAA then
                                    self:setRawValue( SettingsModel.SETTING.MSAA, MSAA.OFF)
                                end

                                if rawValue = = PostProcessAntiAliasing.DLAA then
                                    self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality.OFF)
                                elseif rawValue = = PostProcessAntiAliasing.FSR3 then
                                        self:setRawValue( SettingsModel.SETTING.FIDELITYFX_SR, FidelityFxSRQuality.OFF)
                                    end
                                else
                                        self:setValue( SettingsModel.SETTING.FIDELITYFX_SR_ 30 _FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                        self:setValue( SettingsModel.SETTING.XESS_FRAME_GENERATION, FrameInterpolationMode.FRAME_INTERPOLATION_OFF)
                                    end
                                end )

                                self:addSetting( SettingsModel.SETTING.RESOLUTION, getScreenMode, setScreenMode, true )
                                self:addResolutionScaleSetting()
                                self:addResolutionScale3dSetting()
                                self:addFidelityFxSR30FrameGenerationSetting()
                                self:addXeSSFrameGenerationSetting()
                                self:addDLSSFrameGenerationSetting()
                                self:addTextureResolutionSetting()
                                self:addShadowQualitySetting()
                                self:addShadowDistanceQualitySetting()
                                self:addSoftShadowsSetting()
                                self:addShaderQualitySetting()
                                self:addShadowMapFilteringSetting()
                                self:addShadowMaxLightsSetting()
                                self:addTerrainQualitySetting()
                                self:addObjectDrawDistanceSetting()
                                self:addFoliageDrawDistanceSetting()
                                self:addFoliageShadowSetting()
                                self:addLODDistanceSetting()
                                self:addTerrainLODDistanceSetting()
                                self:addFoliageLODDistanceSetting()
                                self:addVolumeMeshTessellationSetting()
                                self:addMaxTireTracksSetting()
                                self:addLightsProfileSetting()
                                self:addMaxMirrorsSetting()

                                self:addDRSTargetFPSSetting()
                                self:addSharpnessSetting()
                                self:addShadingRateQualitySetting()
                                self:addSSAOQualitySetting()

                                self:addCloudShadowsQualitySetting()
                                self:addVSyncSetting()
                                self:addSetting( SettingsModel.SETTING.FULLSCREEN_MODE, getFullscreenMode, setFullscreenMode, true )
                            end

                            self:addPerformanceModeSetting()
                            self:addRealBeaconLightsSetting()

                            self:addLanguageSetting()
                            self:addMPLanguageSetting()
                            self:addInputHelpModeSetting()
                            self:addBrightnessSetting()
                            self:addFovYSetting()
                            self:addFovYPlayerFirstPersonSetting()
                            self:addFovYPlayerThirdPersonSetting()
                            self:addUIScaleSetting()
                            self:addMasterVolumeSetting()
                            self:addMusicVolumeSetting()
                            self:addEnvironmentVolumeSetting()
                            self:addVehicleVolumeSetting()
                            self:addRadioVolumeSetting()
                            self:addVolumeGUISetting()
                            self:addVolumeNoFocusSetting()
                            self:addVolumeCharacterSetting()
                            self:addVoiceVolumeSetting()
                            self:addVoiceInputVolumeSetting()
                            self:addVoiceModeSetting()
                            self:addVoiceInputSensitivitySetting()
                            self:addSteeringBackSpeedSetting()
                            self:addSteeringSensitivitySetting()
                            self:addCameraSensitivitySetting()
                            self:addVehicleArmSensitivitySetting()
                            self:addRealBeaconLightBrightnessSetting()
                            self:addActiveCameraSuspensionSetting()
                            self:addCamerCheckCollisionSetting()
                            self:addDirectionChangeModeSetting()
                            self:addGearShiftModeSetting()
                            self:addHudSpeedGaugeSetting()
                            self:addWoodHarvesterAutoCutSetting()
                            self:addForceFeedbackSetting()

                            if Platform.hasAdjustableFrameLimit then
                                self:addFrameLimitSetting()
                            end

                            if Platform.isMobile then
                                self:addGyroscopeSteeringSetting()
                                self:addHintsSetting()
                                self:addCameraTiltingSetting()
                            end

                            if getHdrAvailable() then
                                self:addHDRPeakBrightnessSetting()
                                self:addHDRContrastSetting()
                                self:addOverlayBrightnessSetting()
                                self:addHDREnabledSetting()
                            end

                            self:addDirectSetting( SettingsModel.SETTING.USE_COLORBLIND_MODE)
                            self:addDirectSetting( SettingsModel.SETTING.GAMEPAD_ENABLED)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_FIELD_INFO)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_HELP_MENU)
                            self:addDirectSetting( SettingsModel.SETTING.RADIO_IS_ACTIVE)
                            self:addDirectSetting( SettingsModel.SETTING.RESET_CAMERA)
                            self:addDirectSetting( SettingsModel.SETTING.RADIO_VEHICLE_ONLY)
                            self:addDirectSetting( SettingsModel.SETTING.IS_TRAIN_TABBABLE)
                            self:addDirectSetting( SettingsModel.SETTING.HEAD_TRACKING_ENABLED)
                            self:addDirectSetting( SettingsModel.SETTING.USE_FAHRENHEIT)
                            self:addDirectSetting( SettingsModel.SETTING.USE_WORLD_CAMERA)
                            self:addDirectSetting( SettingsModel.SETTING.MONEY_UNIT)
                            self:addDirectSetting( SettingsModel.SETTING.USE_ACRE)
                            self:addDirectSetting( SettingsModel.SETTING.EASY_ARM_CONTROL)
                            self:addDirectSetting( SettingsModel.SETTING.INVERT_Y_LOOK)
                            self:addDirectSetting( SettingsModel.SETTING.USE_MILES)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_TRIGGER_MARKER)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_MULTIPLAYER_NAMES)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_HELP_TRIGGER)
                            self:addDirectSetting( SettingsModel.SETTING.SHOW_HELP_ICONS)
                            self:addDirectSetting( SettingsModel.SETTING.CAMERA_BOBBING)

                            -- -- check for missing settings
                                -- for _, key in pairs(SettingsModel.SETTING) do
                                    -- if self.settings[key] = = nil then
                                        -- log(key)
                                        -- end
                                        -- end
                                    end

```

### addMaxTireTracksSetting

**Description**

**Definition**

> addMaxTireTracksSetting()

**Code**

```lua
function SettingsModel:addMaxTireTracksSetting()
    local function readValue()
        return Utils.getValueIndex(getTyreTracksSegmentsCoeff(), self.tireTracksValues)
    end

    local function writeValue(value)
        setTyreTracksSegmentsCoeff( self.tireTracksValues[value])
    end

    self:addSetting( SettingsModel.SETTING.MAX_TIRE_TRACKS, readValue, writeValue)
end

```

### addObjectDrawDistanceSetting

**Description**

**Definition**

> addObjectDrawDistanceSetting()

**Code**

```lua
function SettingsModel:addObjectDrawDistanceSetting()
    local function readValue()
        return Utils.getValueIndex(getViewDistanceCoeff(), self.percentValues)
    end

    local function writeValue(value)
        setViewDistanceCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.OBJECT_DRAW_DISTANCE, readValue, writeValue)
end

```

### addSetting

**Description**

> Add a setting to the model.
> Reader and writer functions need to be provided which transform display values (usually indices) to actual setting
> values and interact with the current game setting or engine states. Writer function can have side-effects, such as
> directly applying values to the engine state or modifying dependent sub-settings.

**Definition**

> addSetting(string gameSettingsKey, function readerFunction, function writerFunction, boolean restartRequired, , , , )

**Arguments**

| string   | gameSettingsKey | Key of the setting in GameSettings                                                                                   |
|----------|-----------------|----------------------------------------------------------------------------------------------------------------------|
| function | readerFunction  | Function which reads and processes the setting value identified by the key, signature: function(settingsKey)         |
| function | writerFunction  | Function which processes and writes the setting value identified by the key, signature: function(value, settingsKey) |
| boolean  | restartRequired | true if a restart is required to apply the setting                                                                   |
| any      | textFunction    |                                                                                                                      |
| any      | rawToValueFunc  |                                                                                                                      |
| any      | valueToRawFunc  |                                                                                                                      |
| any      | onChangeFunc    |                                                                                                                      |

**Code**

```lua
function SettingsModel:addSetting(gameSettingsKey, readerFunction, writerFunction, restartRequired, textFunction, rawToValueFunc, valueToRawFunc, onChangeFunc)
    local initialValue = readerFunction(gameSettingsKey)

    -- initial:the value of the settings when the screen was opened
    -- saved:the value that is currently set to the engine
    -- changed:the value that is currently set in the gui
    self.settings[gameSettingsKey] = { key = gameSettingsKey, initial = initialValue, saved = initialValue, changed = initialValue, restartRequired = restartRequired }
    self.settingReaders[gameSettingsKey] = readerFunction
    self.settingWriters[gameSettingsKey] = writerFunction
    self.settingTexts[gameSettingsKey] = textFunction
    self.settingsRawToValues[gameSettingsKey] = rawToValueFunc
    self.settingsValueToRaws[gameSettingsKey] = valueToRawFunc
    self.settingsOnChanges[gameSettingsKey] = onChangeFunc

    table.insert( self.sortedSettings, self.settings[gameSettingsKey])
end

```

### addShaderQualitySetting

**Description**

**Definition**

> addShaderQualitySetting()

**Code**

```lua
function SettingsModel:addShaderQualitySetting()
    local function readValue()
        return SettingsModel.getShaderQualityIndex(getShaderQuality())
    end

    local function writeValue(value)
        setShaderQuality( SettingsModel.getShaderQualityByIndex(value))
    end

    self:addSetting( SettingsModel.SETTING.SHADER_QUALITY, readValue, writeValue)
end

```

### addShadingRateQualitySetting

**Description**

**Definition**

> addShadingRateQualitySetting()

**Code**

```lua
function SettingsModel:addShadingRateQualitySetting()
    local function readValue()
        return getShadingRateQuality() + 1
    end

    local function writeValue(value)
        setShadingRateQuality( math.max(value - 1 , 0 ))
    end

    self:addSetting( SettingsModel.SETTING.SHADING_RATE_QUALITY, readValue, writeValue)
end

```

### addShadowDistanceQualitySetting

**Description**

**Definition**

> addShadowDistanceQualitySetting()

**Code**

```lua
function SettingsModel:addShadowDistanceQualitySetting()
    local function readValue()
        return getShadowDistanceQuality() + 1
    end

    local function writeValue(value)
        setShadowDistanceQuality( math.max(value - 1 , 0 ))
    end

    self:addSetting( SettingsModel.SETTING.SHADOW_DISTANCE_QUALITY, readValue, writeValue)
end

```

### addShadowMapFilteringSetting

**Description**

**Definition**

> addShadowMapFilteringSetting()

**Code**

```lua
function SettingsModel:addShadowMapFilteringSetting()
    local function readValue()
        return SettingsModel.getShadowMapFilterIndex(getShadowMapFilterSize())
    end

    local function writeValue(value)
        setShadowMapFilterSize( SettingsModel.getShadowMapFilterByIndex(value))
    end

    self:addSetting( SettingsModel.SETTING.SHADOW_MAP_FILTERING, readValue, writeValue)
end

```

### addShadowMaxLightsSetting

**Description**

**Definition**

> addShadowMaxLightsSetting()

**Code**

```lua
function SettingsModel:addShadowMaxLightsSetting()
    local function readValue()
        return getMaxNumShadowLights()
    end

    local function writeValue(value)
        setMaxNumShadowLights(value)
    end

    self:addSetting( SettingsModel.SETTING.MAX_LIGHTS, readValue, writeValue)
end

```

### addShadowQualitySetting

**Description**

**Definition**

> addShadowQualitySetting()

**Code**

```lua
function SettingsModel:addShadowQualitySetting()
    local function readValue()
        return SettingsModel.getShadowQualityIndex(getShadowQuality(), getHasShadowFocusBox())
    end

    local function writeValue(value)
        setShadowQuality( SettingsModel.getShadowQualityByIndex(value), SettingsModel.getHasShadowFocusBoxByIndex(value))
    end

    self:addSetting( SettingsModel.SETTING.SHADOW_QUALITY, readValue, writeValue)
end

```

### addSoftShadowsSetting

**Description**

**Definition**

> addSoftShadowsSetting()

**Code**

```lua
function SettingsModel:addSoftShadowsSetting()
    local function readValue()
        return getShadowFilterQuality() + 1
    end

    local function writeValue(value)
        setShadowFilterQuality( math.max(value - 1 , 0 ))
    end

    self:addSetting( SettingsModel.SETTING.SOFT_SHADOWS, readValue, writeValue)
end

```

### addSSAOQualitySetting

**Description**

**Definition**

> addSSAOQualitySetting()

**Code**

```lua
function SettingsModel:addSSAOQualitySetting()
    local function readValue()
        local index = getSSAOQuality()
        return index
    end

    local function writeValue(value)
        setSSAOQuality(value)
    end

    self:addSetting( SettingsModel.SETTING.SSAO_QUALITY, readValue, writeValue)
end

```

### addTerrainLODDistanceSetting

**Description**

**Definition**

> addTerrainLODDistanceSetting()

**Code**

```lua
function SettingsModel:addTerrainLODDistanceSetting()
    local function readValue()
        return Utils.getValueIndex(getTerrainLODDistanceCoeff(), self.percentValues)
    end

    local function writeValue(value)
        setTerrainLODDistanceCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.TERRAIN_LOD_DISTANCE, readValue, writeValue)
end

```

### addTerrainQualitySetting

**Description**

**Definition**

> addTerrainQualitySetting()

**Code**

```lua
function SettingsModel:addTerrainQualitySetting()
    local function readValue()
        return SettingsModel.getTerrainQualityIndex(getTerrainQuality())
    end

    local function writeValue(value)
        setTerrainQuality( SettingsModel.getTerrainQualityByIndex(value))
    end

    self:addSetting( SettingsModel.SETTING.TERRAIN_QUALITY, readValue, writeValue) -- restart needed to use correct shader cache
end

```

### addTextureResolutionSetting

**Description**

**Definition**

> addTextureResolutionSetting()

**Code**

```lua
function SettingsModel:addTextureResolutionSetting()
    local function readValue()
        return SettingsModel.getTextureResolutionIndex(getTextureResolution())
    end

    local function writeValue(value)
        setTextureResolution( SettingsModel.getTextureResolutionByIndex(value))
    end

    self:addSetting( SettingsModel.SETTING.TEXTURE_RESOLUTION, readValue, writeValue)
end

```

### addVolumeMeshTessellationSetting

**Description**

**Definition**

> addVolumeMeshTessellationSetting()

**Code**

```lua
function SettingsModel:addVolumeMeshTessellationSetting()
    local function readValue()
        return Utils.getValueIndex( SettingsModel.getVolumeMeshTessellationCoeff(), self.percentValues)
    end

    local function writeValue(value)
        SettingsModel.setVolumeMeshTessellationCoeff( self.percentValues[value])
    end

    self:addSetting( SettingsModel.SETTING.VOLUME_MESH_TESSELLATION, readValue, writeValue)
end

```

### applyChanges

**Description**

> Apply the currently held, transient settings to the game settings.

**Definition**

> applyChanges(boolean doSave)

**Arguments**

| boolean | doSave | If true, the changes will also be persisted to storage. |
|---------|--------|---------------------------------------------------------|

**Code**

```lua
function SettingsModel:applyChanges(settingClassesToSave)
    for _, setting in pairs( self.sortedSettings) do
        local settingsKey = setting.key
        local savedValue = self.settings[settingsKey].saved
        local changedValue = self.settings[settingsKey].changed

        if savedValue ~ = changedValue then
            local writeFunction = self.settingWriters[settingsKey]
            writeFunction(changedValue, settingsKey) -- write to game settings / engine

            self.settings[settingsKey].saved = changedValue
        end
        self.settings[settingsKey].initial = changedValue -- update initial value
    end

    if settingClassesToSave ~ = 0 then
        self:saveChanges(settingClassesToSave)
    end
end

```

### applyCustomSettings

**Description**

**Definition**

> applyCustomSettings()

**Code**

```lua
function SettingsModel:applyCustomSettings()
    for settingsKey in pairs( self.settings) do
        if settingsKey ~ = SettingsModel.SETTING.PERFORMANCE_CLASS then
            local changedValue = self.settings[settingsKey].changed
            if changedValue ~ = self.settings[settingsKey].saved then
                local writeFunction = self.settingWriters[settingsKey]
                writeFunction(changedValue, settingsKey)
                self.settings[settingsKey].saved = changedValue
            end
        end
    end
end

```

### applyPerformanceClass

**Description**

**Definition**

> applyPerformanceClass()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function SettingsModel:applyPerformanceClass(value)
    local settingsKey = SettingsModel.SETTING.PERFORMANCE_CLASS
    local writeFunction = self.settingWriters[settingsKey]
    writeFunction(value, settingsKey)
    self.settings[settingsKey].changed = value
    self.settings[settingsKey].saved = value

    self:refreshChangedValue()
end

```

### createControlDisplayValues

**Description**

> Populate value and string lists for control elements display.

**Definition**

> createControlDisplayValues()

**Code**

```lua
function SettingsModel:createControlDisplayValues()
    self.volumeTexts = { g_i18n:getText( "ui_off" ), "10%" , "20%" , "30%" , "40%" , "50%" , "60%" , "70%" , "80%" , "90%" , "100%" }
    self.recordingVolumeTexts = { g_i18n:getText( "ui_auto" ), "50%" , "60%" , "70%" , "80%" , "90%" , "100%" , "110%" , "120%" , "130%" , "140%" , "150%" }

    self.voiceModeTexts = {
    g_i18n:getText( "ui_off" ),
    g_i18n:getText( "ui_voiceActivity" ),
    }
    if Platform.supportsPushToTalk then
        table.insert( self.voiceModeTexts, g_i18n:getText( "ui_pushToTalk" ))
    end

    self.voiceInputThresholdTexts = { g_i18n:getText( "ui_auto" ), "0%" , "10%" , "20%" , "30%" , "40%" , "50%" , "60%" , "70%" , "80%" , "90%" , "100%" }

    for i = self.minBrightness, self.maxBrightness + 0.0001 , self.brightnessStep do -- add a little to max for floating point precision
        table.insert( self.brightnessTexts, string.format( "%.1f" , i))
    end

    local index = 1
    local min = math.deg(Platform.minFovY)
    local max = math.deg(Platform.maxFovY)
    for i = min , max do
        self.indexToFovYMapping[index] = i
        self.fovYToIndexMapping[i] = index
        table.insert( self.fovYTexts, string.format(g_i18n:getText( "setting_fovyDegree" ), i))

        index = index + 1
    end

    for i = 1 , 16 do
        table.insert( self.uiScaleTexts, string.format( "%d%%" , 50 + (i - 1 ) * 5 ))
    end

    for i = 0.5 , 2.1 , 0.1 do
        table.insert( self.resolutionScaleTexts, string.format( "%d%%" , MathUtil.round(i * 100 )))
    end

    for i = 0.5 , 2.1 , 0.1 do
        table.insert( self.resolutionScale3dTexts, string.format( "%d%%" , MathUtil.round(i * 100 )))
    end

    for i = 0.5 , 3 , self.cameraSensitivityStep do
        table.insert( self.cameraSensitivityStrings, string.format( "%d%%" , i * 100 ))
        table.insert( self.cameraSensitivityValues, i)
    end

    for i = 0.5 , 3 , self.vehicleArmSensitivityStep do
        table.insert( self.vehicleArmSensitivityStrings, string.format( "%d%%" , i * 100 ))
        table.insert( self.vehicleArmSensitivityValues, i)
    end

    for i = 0 , 1 , self.realBeaconLightBrightnessStep do
        if i > 0 then
            table.insert( self.realBeaconLightBrightnessStrings, string.format( "%d%%" , i * 100 + 0.5 ))
        else
                table.insert( self.realBeaconLightBrightnessStrings, g_i18n:getText( "setting_off" ))
            end
            table.insert( self.realBeaconLightBrightnessValues, i)
        end

        local steeringBackSpeedSettings = Platform.gameplay.steeringBackSpeedSettings
        for i = 1 , #steeringBackSpeedSettings do
            table.insert( self.steeringBackSpeedStrings, string.format( "%d%%" , steeringBackSpeedSettings[i] * 10 ))
            table.insert( self.steeringBackSpeedValues, steeringBackSpeedSettings[i])
        end

        for i = 0.5 , 3.1 , self.steeringSensitivityStep do
            table.insert( self.steeringSensitivityStrings, string.format( "%d%%" , i * 100 + 0.5 ))
            table.insert( self.steeringSensitivityValues, i)
        end

        self.moneyUnitTexts = { g_i18n:getText( "unit_euro" ), g_i18n:getText( "unit_dollar" ), g_i18n:getText( "unit_pound" ) }
        self.distanceUnitTexts = { g_i18n:getText( "unit_km" ), g_i18n:getText( "unit_miles" ) }
        self.temperatureUnitTexts = { g_i18n:getText( "unit_celsius" ), g_i18n:getText( "unit_fahrenheit" ) }
        self.areaUnitTexts = { g_i18n:getText( "unit_ha" ), g_i18n:getText( "unit_acre" ) }
        self.radioModeTexts = { g_i18n:getText( "setting_radioAlways" ), g_i18n:getText( "setting_radioVehicleOnly" ) }
        self.shadowQualityTexts = { g_i18n:getText( "setting_off" ), g_i18n:getText( "setting_medium" ), g_i18n:getText( "setting_high" ), g_i18n:getText( "setting_veryHigh" ) }
        self.shadowDistanceQualityTexts = { g_i18n:getText( "setting_low" ), g_i18n:getText( "setting_medium" ), g_i18n:getText( "setting_high" ) }
        self.softShadowsTexts = { g_i18n:getText( "ui_off" ), g_i18n:getText( "ui_on" ) }
        self.fourStateTexts = { g_i18n:getText( "setting_low" ), g_i18n:getText( "setting_medium" ), g_i18n:getText( "setting_high" ), g_i18n:getText( "setting_veryHigh" ) }
        self.fiveStateTexts = { g_i18n:getText( "setting_low" ), g_i18n:getText( "setting_medium" ), g_i18n:getText( "setting_high" ), g_i18n:getText( "setting_veryHigh" ), g_i18n:getText( "setting_ultra" ) }
        self.lowHighTexts = { g_i18n:getText( "setting_low" ), g_i18n:getText( "setting_high" ) }
        self.ssaoQualityTexts = { g_i18n:getText( "setting_low" ), g_i18n:getText( "setting_medium" ), g_i18n:getText( "setting_high" ), g_i18n:getText( "setting_veryHigh" ) }

        self.drsTargetFPSTexts = { }
        self.drsTargetFPSMapping = { }
        self.drsTargetFPSMappingReverse = { }
        for _, value in ipairs(g_gameSettings.frameLimitValues) do
            table.insert( self.drsTargetFPSTexts, tostring(value))
            self.drsTargetFPSMapping[value] = # self.drsTargetFPSTexts
            self.drsTargetFPSMappingReverse[# self.drsTargetFPSTexts] = value
        end
        for i = self.minSharpness, self.maxSharpness + 0.0001 , self.sharpnessStep do -- add a little to max for floating point precision
            table.insert( self.sharpnessTexts, string.format( "%.1f" , i))
        end

        self.scalingModeTexts = { g_i18n:getText( "setting_off" ) }
        for index, value in pairs(FidelityFxSRQuality) do
            if value ~ = FidelityFxSRQuality.OFF and value ~ = FidelityFxSRQuality.NUM and getSupportsFidelityFxSRQuality(value) then
                table.insert( self.scalingModeTexts, g_i18n:getText( "setting_fsr1" ))
                break
            end
        end
        for index, value in pairs(FidelityFxSR30Quality) do
            if value ~ = FidelityFxSR30Quality.OFF and value ~ = FidelityFxSR30Quality.NUM and getSupportsFidelityFxSR30Quality(value) then
                if getFidelityFxSuperResolutionVersion() = = 4 then
                    table.insert( self.scalingModeTexts, g_i18n:getText( "setting_fsr4" ))
                else
                        table.insert( self.scalingModeTexts, g_i18n:getText( "setting_fsr3" ))
                    end
                    break
                end
            end
            for index, value in pairs(DLSSQuality) do
                if value ~ = DLSSQuality.OFF and value ~ = DLSSQuality.NUM and getSupportsDLSSQuality(value) then
                    table.insert( self.scalingModeTexts, g_i18n:getText( "setting_DLSS" ))
                    break
                end
            end
            for index, value in pairs(XeSSQuality) do
                if value ~ = XeSSQuality.OFF and value ~ = XeSSQuality.NUM and getSupportsXeSSQuality(value) then
                    table.insert( self.scalingModeTexts, g_i18n:getText( "setting_xeSS" ))
                    break
                end
            end

            self.postProcessAntiAliasingToolTip = g_i18n:getText( "toolTip_ppaa" )
            if getSupportsPostProcessAntiAliasing(PostProcessAntiAliasing.TAA) then
                self.postProcessAntiAliasingToolTip = self.postProcessAntiAliasingToolTip .. " " .. g_i18n:getText( "toolTip_ppaa_taa" )
            end
            if getSupportsPostProcessAntiAliasing(PostProcessAntiAliasing.DLAA) then
                self.postProcessAntiAliasingToolTip = self.postProcessAntiAliasingToolTip .. " " .. g_i18n:getText( "toolTip_ppaa_dlaa" )
            end

            self.hdrPeakBrightnessValues = { }
            self.hdrPeakBrightnessTexts = { }
            self.hdrPeakBrightnessStep = 10
            for i = 0 , 95 do
                local value = ( 50 + i * self.hdrPeakBrightnessStep)
                table.insert( self.hdrPeakBrightnessTexts, string.format( "%d" , value))
                table.insert( self.hdrPeakBrightnessValues, value)
            end

            self.hdrContrastValues = { }
            self.hdrContrastTexts = { }
            for i = 0 , 120 do
                local value = ( 0.8 + i * self.hdrContrastStep)
                table.insert( self.hdrContrastTexts, string.format( "%.2f" , value))
                table.insert( self.hdrContrastValues, value)
            end

            self.overlayBrightnessValues = { }
            self.overlayBrightnessTexts = { }
            self.overlayBrightnessStep = 10
            for i = 0 , 95 do
                local value = ( 50 + i * self.overlayBrightnessStep)
                table.insert( self.overlayBrightnessTexts, string.format( "%d" , value))
                table.insert( self.overlayBrightnessValues, value)
            end

            self.shadowMapMaxLightsTexts = { }
            for i = 1 , 10 do
                table.insert( self.shadowMapMaxLightsTexts, string.format( "%d" , i))
            end

            self.percentValues = { }
            self.perentageTexts = { }
            self.percentStep = 0.05
            for i = 0 , 30 do
                table.insert( self.perentageTexts, string.format( "%.f%%" , ( 0.5 + i * self.percentStep) * 100 ))
                table.insert( self.percentValues, ( 0.5 + i * self.percentStep))
            end

            self.tireTracksValues = { }
            self.tireTracksTexts = { }
            self.tireTracksStep = 0.5
            for i = 0 , 4 , self.tireTracksStep do
                table.insert( self.tireTracksTexts, string.format( "%d%%" , i * 100 ))
                table.insert( self.tireTracksValues, i)
            end

            self.maxMirrorsTexts = { }
            for i = 0 , 7 do
                table.insert( self.maxMirrorsTexts, string.format( "%d" , i))
            end

            self.resolutionTexts = { }
            local numR = getNumOfScreenModes()
            for i = 0 , numR - 1 do
                local x, y = getScreenModeInfo(i)
                local aspect = x / y
                local aspectStr
                if aspect = = 1.25 then
                    aspectStr = "(5:4)"
                elseif aspect > 1.3 and aspect < 1.4 then
                        aspectStr = "(4:3)"
                    elseif aspect > 1.7 and aspect < 1.8 then
                            aspectStr = "(16:9)"
                        elseif aspect > 2.3 and aspect < 2.4 then
                                aspectStr = "(21:9)"
                            else
                                    aspectStr = string.format( "(%1.0f:10)" , aspect * 10 )
                                end

                                table.insert( self.resolutionTexts, string.format( "%dx%d %s" , x, y, aspectStr))
                            end

                            self.fullscreenModeTexts = { }
                            for i = 0 , FullscreenMode.NUM - 1 do
                                if i = = FullscreenMode.WINDOWED then
                                    table.insert( self.fullscreenModeTexts, g_i18n:getText( "ui_windowed" ))
                                elseif i = = FullscreenMode.WINDOWED_FULLSCREEN then
                                        table.insert( self.fullscreenModeTexts, g_i18n:getText( "ui_windowed_fullscreen" ))
                                    else
                                            -- FullscreenMode.EXCLUSIVE_FULLSCREEN
                                            table.insert( self.fullscreenModeTexts, g_i18n:getText( "ui_exclusive_fullscreen" ))
                                        end
                                    end

                                    self.mpLanguageTexts = { }
                                    local numL = getNumOfLanguages()
                                    for i = 0 , numL - 1 do
                                        table.insert( self.mpLanguageTexts, getLanguageName(i))
                                    end

                                    self.frameLimitMapping = { }
                                    self.frameLimitMappingReverse = { }
                                    self.frameLimitTexts = { }
                                    for _, value in ipairs(g_gameSettings.frameLimitValues) do
                                        table.insert( self.frameLimitTexts, tostring(value))
                                        self.frameLimitMapping[value] = # self.frameLimitTexts
                                        self.frameLimitMappingReverse[# self.frameLimitTexts] = value
                                    end

                                    self.inputHelpModeTexts = { g_i18n:getText( "ui_auto" ), g_i18n:getText( "ui_keyboard" ), g_i18n:getText( "ui_gamepad" ) }

                                    self.directionChangeModeTexts = {
                                    [ VehicleMotor.DIRECTION_CHANGE_MODE_AUTOMATIC] = g_i18n:getText( "ui_directionChangeModeAutomatic" ),
                                    [ VehicleMotor.DIRECTION_CHANGE_MODE_MANUAL] = g_i18n:getText( "ui_directionChangeModeManual" )
                                    }

                                    self.gearShiftModeTexts = {
                                    [ VehicleMotor.SHIFT_MODE_AUTOMATIC] = g_i18n:getText( "ui_gearShiftModeAutomatic" ),
                                    [ VehicleMotor.SHIFT_MODE_MANUAL] = g_i18n:getText( "ui_gearShiftModeManual" ),
                                    }
                                    -- Consoles are gamepad only, and we cannot properly map the clutch there
                                    if not Platform.isConsole then
                                        self.gearShiftModeTexts[ VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH] = g_i18n:getText( "ui_gearShiftModeManualClutch" )
                                    end

                                    self.hudSpeedGaugeTexts = {
                                    [ SpeedMeterDisplay.GAUGE_MODE_RPM] = g_i18n:getText( "ui_hudSpeedGaugeRPM" ),
                                    [ SpeedMeterDisplay.GAUGE_MODE_SPEED] = g_i18n:getText( "ui_hudSpeedGaugeSpeed" ),
                                    }

                                    self.deadzoneValues = { }
                                    self.deadzoneTexts = { }
                                    self.deadzoneStep = 0.01
                                    for i = 0 , 0.3 + 0.001 , self.deadzoneStep do
                                        table.insert( self.deadzoneTexts, string.format( "%d%%" , math.floor(i * 100 + 0.001 )))
                                        table.insert( self.deadzoneValues, i)
                                    end

                                    self.sensitivityValues = { }
                                    self.sensitivityTexts = { }
                                    self.sensitivityStep = 0.25
                                    for i = 0.5 , 2 , self.sensitivityStep do
                                        table.insert( self.sensitivityTexts, string.format( "%d%%" , i * 100 ))
                                        table.insert( self.sensitivityValues, i)
                                    end

                                    self.headTrackingSensitivityValues = { }
                                    self.headTrackingSensitivityTexts = { }
                                    self.headTrackingSensitivityStep = 0.05
                                    for i = 0 , 1 + 0.001 , self.headTrackingSensitivityStep do
                                        table.insert( self.headTrackingSensitivityTexts, string.format( "%d%%" , i * 100 + 0.001 ))
                                        table.insert( self.headTrackingSensitivityValues, i)
                                    end
                                end

```

### getAreaUnitTexts

**Description**

> Get valid area unit texts.

**Definition**

> getAreaUnitTexts()

**Code**

```lua
function SettingsModel:getAreaUnitTexts()
    return self.areaUnitTexts
end

```

### getAudioVolumeTexts

**Description**

> Get valid audio volume texts.

**Definition**

> getAudioVolumeTexts()

**Code**

```lua
function SettingsModel:getAudioVolumeTexts()
    return self.volumeTexts
end

```

### getBrightnessTexts

**Description**

> Get valid brightness option texts.

**Definition**

> getBrightnessTexts()

**Code**

```lua
function SettingsModel:getBrightnessTexts()
    return self.brightnessTexts
end

```

### getCameraSensitivityTexts

**Description**

> Get valid camera sensitivity texts.

**Definition**

> getCameraSensitivityTexts()

**Code**

```lua
function SettingsModel:getCameraSensitivityTexts()
    return self.cameraSensitivityStrings
end

```

### getCurrentDeviceName

**Description**

**Definition**

> getCurrentDeviceName()

**Code**

```lua
function SettingsModel:getCurrentDeviceName()
    local setting = self.deviceSettings[ self.currentDevice]
    if setting ~ = nil then
        return setting.device.deviceName
    end

    return ""
end

```

### getCurrentDeviceSensitivityValue

**Description**

**Definition**

> getCurrentDeviceSensitivityValue()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getCurrentDeviceSensitivityValue(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    if settings ~ = nil then
        return self.sensitivityValues[settings.sensitivities[axisIndex].current]
    end

    return nil
end

```

### getDeadzoneTexts

**Description**

**Definition**

> getDeadzoneTexts()

**Code**

```lua
function SettingsModel:getDeadzoneTexts()
    return self.deadzoneTexts
end

```

### getDeviceAxisDeadzoneValue

**Description**

**Definition**

> getDeviceAxisDeadzoneValue()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getDeviceAxisDeadzoneValue(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings.deadzones[axisIndex].current
end

```

### getDeviceAxisSensitivityValue

**Description**

**Definition**

> getDeviceAxisSensitivityValue()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getDeviceAxisSensitivityValue(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings.sensitivities[axisIndex].current
end

```

### getDeviceHasAxisDeadzone

**Description**

**Definition**

> getDeviceHasAxisDeadzone()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getDeviceHasAxisDeadzone(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings ~ = nil and settings.deadzones[axisIndex] ~ = nil
end

```

### getDeviceHasAxisSensitivity

**Description**

**Definition**

> getDeviceHasAxisSensitivity()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getDeviceHasAxisSensitivity(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings ~ = nil and settings.sensitivities[axisIndex] ~ = nil
end

```

### getDirectionChangeModeTexts

**Description**

**Definition**

> getDirectionChangeModeTexts()

**Code**

```lua
function SettingsModel:getDirectionChangeModeTexts()
    return self.directionChangeModeTexts
end

```

### getDistanceUnitTexts

**Description**

> Get valid distance unit texts.

**Definition**

> getDistanceUnitTexts()

**Code**

```lua
function SettingsModel:getDistanceUnitTexts()
    return self.distanceUnitTexts
end

```

### getDRSTargetFPSTexts

**Description**

**Definition**

> getDRSTargetFPSTexts()

**Code**

```lua
function SettingsModel:getDRSTargetFPSTexts()
    return self.drsTargetFPSTexts
end

```

### getFoliageDrawDistanceTexts

**Description**

**Definition**

> getFoliageDrawDistanceTexts()

**Code**

```lua
function SettingsModel:getFoliageDrawDistanceTexts()
    return self.perentageTexts
end

```

### getFoliageLODDistanceTexts

**Description**

**Definition**

> getFoliageLODDistanceTexts()

**Code**

```lua
function SettingsModel:getFoliageLODDistanceTexts()
    return self.perentageTexts
end

```

### getForceFeedbackTexts

**Description**

> Get valid audio volume texts.

**Definition**

> getForceFeedbackTexts()

**Code**

```lua
function SettingsModel:getForceFeedbackTexts()
    -- Same as volume texts:Off to 100%
    return self.volumeTexts
end

```

### getFovYTexts

**Description**

> Get valid FOV Y option texts.

**Definition**

> getFovYTexts()

**Code**

```lua
function SettingsModel:getFovYTexts()
    return self.fovYTexts
end

```

### getFrameLimitTexts

**Description**

**Definition**

> getFrameLimitTexts()

**Code**

```lua
function SettingsModel:getFrameLimitTexts()
    return self.frameLimitTexts
end

```

### getFullscreenModeTexts

**Description**

**Definition**

> getFullscreenModeTexts()

**Code**

```lua
function SettingsModel:getFullscreenModeTexts()
    return self.fullscreenModeTexts
end

```

### getGearShiftModeTexts

**Description**

**Definition**

> getGearShiftModeTexts()

**Code**

```lua
function SettingsModel:getGearShiftModeTexts()
    return self.gearShiftModeTexts
end

```

### getHDRContrastTexts

**Description**

**Definition**

> getHDRContrastTexts()

**Code**

```lua
function SettingsModel:getHDRContrastTexts()
    return self.hdrContrastTexts
end

```

### getHDRPeakBrightnessTexts

**Description**

**Definition**

> getHDRPeakBrightnessTexts()

**Code**

```lua
function SettingsModel:getHDRPeakBrightnessTexts()
    return self.hdrPeakBrightnessTexts
end

```

### getHeadTrackingSensitivityTexts

**Description**

**Definition**

> getHeadTrackingSensitivityTexts()

**Code**

```lua
function SettingsModel:getHeadTrackingSensitivityTexts()
    return self.headTrackingSensitivityTexts
end

```

### getHeadTrackingSensitivityValue

**Description**

**Definition**

> getHeadTrackingSensitivityValue()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getHeadTrackingSensitivityValue(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings.headTrackingSensitivity.current
end

```

### getHudSpeedGaugeTexts

**Description**

**Definition**

> getHudSpeedGaugeTexts()

**Code**

```lua
function SettingsModel:getHudSpeedGaugeTexts()
    return self.hudSpeedGaugeTexts
end

```

### getInputHelpModeTexts

**Description**

**Definition**

> getInputHelpModeTexts()

**Code**

```lua
function SettingsModel:getInputHelpModeTexts()
    return self.inputHelpModeTexts
end

```

### getIsDeviceMouse

**Description**

**Definition**

> getIsDeviceMouse()

**Code**

```lua
function SettingsModel:getIsDeviceMouse()
    local settings = self.deviceSettings[ self.currentDevice]
    return settings ~ = nil and settings.device.category = = InputDevice.CATEGORY.KEYBOARD_MOUSE
end

```

### getIsLanguageDisabled

**Description**

**Definition**

> getIsLanguageDisabled()

**Code**

```lua
function SettingsModel:getIsLanguageDisabled()
    return #g_availableLanguagesTable < = 1 or GS_IS_STEAM_VERSION
end

```

### getLanguageTexts

**Description**

**Definition**

> getLanguageTexts()

**Code**

```lua
function SettingsModel:getLanguageTexts()
    return g_availableLanguageNamesTable
end

```

### getLightsProfileTexts

**Description**

**Definition**

> getLightsProfileTexts()

**Code**

```lua
function SettingsModel:getLightsProfileTexts()
    return self.fiveStateTexts
end

```

### getLODDistanceTexts

**Description**

**Definition**

> getLODDistanceTexts()

**Code**

```lua
function SettingsModel:getLODDistanceTexts()
    return self.perentageTexts
end

```

### getMaxMirrorsTexts

**Description**

**Definition**

> getMaxMirrorsTexts()

**Code**

```lua
function SettingsModel:getMaxMirrorsTexts()
    return self.maxMirrorsTexts
end

```

### getMaxTireTracksTexts

**Description**

**Definition**

> getMaxTireTracksTexts()

**Code**

```lua
function SettingsModel:getMaxTireTracksTexts()
    return self.tireTracksTexts
end

```

### getMoneyUnitTexts

**Description**

> Get valid money unit (=currency) texts.

**Definition**

> getMoneyUnitTexts()

**Code**

```lua
function SettingsModel:getMoneyUnitTexts()
    return self.moneyUnitTexts
end

```

### getMouseSensitivityValue

**Description**

**Definition**

> getMouseSensitivityValue()

**Arguments**

| any | axisIndex |
|-----|-----------|

**Code**

```lua
function SettingsModel:getMouseSensitivityValue(axisIndex)
    local settings = self.deviceSettings[ self.currentDevice]
    return settings.mouseSensitivity.current
end

```

### getMPLanguageTexts

**Description**

**Definition**

> getMPLanguageTexts()

**Code**

```lua
function SettingsModel:getMPLanguageTexts()
    return self.mpLanguageTexts
end

```

### getNumDevices

**Description**

**Definition**

> getNumDevices()

**Code**

```lua
function SettingsModel:getNumDevices()
    return # self.deviceSettings
end

```

### getObjectDrawDistanceTexts

**Description**

**Definition**

> getObjectDrawDistanceTexts()

**Code**

```lua
function SettingsModel:getObjectDrawDistanceTexts()
    return self.perentageTexts
end

```

### getOverlayBrightnessTexts

**Description**

**Definition**

> getOverlayBrightnessTexts()

**Code**

```lua
function SettingsModel:getOverlayBrightnessTexts()
    return self.overlayBrightnessTexts
end

```

### getPerformanceClassTexts

**Description**

**Definition**

> getPerformanceClassTexts()

**Code**

```lua
function SettingsModel:getPerformanceClassTexts()
    local class, isCustom = getPerformanceClass()
    local _, isAuto = getAutoPerformanceClass()

    local texts = { }
    table.insert(texts, g_i18n:getText( "setting_veryLow" ))
    table.insert(texts, g_i18n:getText( "setting_low" ))
    table.insert(texts, g_i18n:getText( "setting_medium" ))
    table.insert(texts, g_i18n:getText( "setting_high" ))
    table.insert(texts, g_i18n:getText( "setting_veryHigh" ))
    table.insert(texts, g_i18n:getText( "setting_ultra" ))

    if not GS_IS_MOBILE_VERSION then
        local index = Utils.getPerformanceClassIndex(class)
        if isCustom then
            texts[index] = g_i18n:getText( "setting_custom" )
        elseif isAuto then
                texts[index] = g_i18n:getText( "setting_auto" )
            end
        end

        return texts, class, isCustom
    end

```

### getPostProcessAAToolTip

**Description**

**Definition**

> getPostProcessAAToolTip()

**Code**

```lua
function SettingsModel:getPostProcessAAToolTip()
    return self.postProcessAntiAliasingToolTip
end

```

### getRadioModeTexts

**Description**

> Get valid radio mode texts.

**Definition**

> getRadioModeTexts()

**Code**

```lua
function SettingsModel:getRadioModeTexts()
    return self.radioModeTexts
end

```

### getRealBeaconLightBrightnessTexts

**Description**

> Get valid real beacon light brightness texts.

**Definition**

> getRealBeaconLightBrightnessTexts()

**Code**

```lua
function SettingsModel:getRealBeaconLightBrightnessTexts()
    return self.realBeaconLightBrightnessStrings
end

```

### getRecordingVolumeTexts

**Description**

> Get valid recording volume texts.

**Definition**

> getRecordingVolumeTexts()

**Code**

```lua
function SettingsModel:getRecordingVolumeTexts()
    return self.recordingVolumeTexts
end

```

### getResolutionScale3dTexts

**Description**

**Definition**

> getResolutionScale3dTexts()

**Code**

```lua
function SettingsModel:getResolutionScale3dTexts()
    return self.resolutionScale3dTexts
end

```

### getResolutionScaleTexts

**Description**

**Definition**

> getResolutionScaleTexts()

**Code**

```lua
function SettingsModel:getResolutionScaleTexts()
    return self.resolutionScaleTexts
end

```

### getResolutionTexts

**Description**

**Definition**

> getResolutionTexts()

**Code**

```lua
function SettingsModel:getResolutionTexts()
    return self.resolutionTexts
end

```

### getSensitivityTexts

**Description**

**Definition**

> getSensitivityTexts()

**Code**

```lua
function SettingsModel:getSensitivityTexts()
    return self.sensitivityTexts
end

```

### getShaderQualityTexts

**Description**

**Definition**

> getShaderQualityTexts()

**Code**

```lua
function SettingsModel:getShaderQualityTexts()
    return self.fourStateTexts
end

```

### getShadingRateQualityTexts

**Description**

**Definition**

> getShadingRateQualityTexts()

**Code**

```lua
function SettingsModel:getShadingRateQualityTexts()
    return self.fourStateTexts
end

```

### getShadowDistanceQualityTexts

**Description**

**Definition**

> getShadowDistanceQualityTexts()

**Code**

```lua
function SettingsModel:getShadowDistanceQualityTexts()
    return self.shadowDistanceQualityTexts
end

```

### getShadowMapFilteringTexts

**Description**

**Definition**

> getShadowMapFilteringTexts()

**Code**

```lua
function SettingsModel:getShadowMapFilteringTexts()
    return self.lowHighTexts
end

```

### getShadowMapLightsTexts

**Description**

**Definition**

> getShadowMapLightsTexts()

**Code**

```lua
function SettingsModel:getShadowMapLightsTexts()
    return self.shadowMapMaxLightsTexts
end

```

### getShadowQualityTexts

**Description**

**Definition**

> getShadowQualityTexts()

**Code**

```lua
function SettingsModel:getShadowQualityTexts()
    return self.shadowQualityTexts
end

```

### getSoftShadowsTexts

**Description**

**Definition**

> getSoftShadowsTexts()

**Code**

```lua
function SettingsModel:getSoftShadowsTexts()
    return self.softShadowsTexts
end

```

### getSSAOQualityTexts

**Description**

**Definition**

> getSSAOQualityTexts()

**Code**

```lua
function SettingsModel:getSSAOQualityTexts()
    return self.ssaoQualityTexts
end

```

### getSteeringBackSpeedTexts

**Description**

> Get valid camera sensitivity texts.

**Definition**

> getSteeringBackSpeedTexts()

**Code**

```lua
function SettingsModel:getSteeringBackSpeedTexts()
    return self.steeringBackSpeedStrings
end

```

### getTemperatureUnitTexts

**Description**

> Get valid temperature unit texts.

**Definition**

> getTemperatureUnitTexts()

**Code**

```lua
function SettingsModel:getTemperatureUnitTexts()
    return self.temperatureUnitTexts
end

```

### getTerraingQualityTexts

**Description**

**Definition**

> getTerraingQualityTexts()

**Code**

```lua
function SettingsModel:getTerraingQualityTexts()
    return self.fourStateTexts
end

```

### getTerrainLODDistanceTexts

**Description**

**Definition**

> getTerrainLODDistanceTexts()

**Code**

```lua
function SettingsModel:getTerrainLODDistanceTexts()
    return self.perentageTexts
end

```

### getTextureResolutionTexts

**Description**

**Definition**

> getTextureResolutionTexts()

**Code**

```lua
function SettingsModel:getTextureResolutionTexts()
    return self.lowHighTexts
end

```

### getUiScaleTexts

**Description**

> Get valid UI scale texts.

**Definition**

> getUiScaleTexts()

**Code**

```lua
function SettingsModel:getUiScaleTexts()
    return self.uiScaleTexts
end

```

### getValue

**Description**

> Get a settings value.

**Definition**

> getValue(string settingKey, )

**Arguments**

| string | settingKey | Setting key, use one of the values in SettingsModel.SETTING. |
|--------|------------|--------------------------------------------------------------|
| any    | trueValue  |                                                              |

**Return Values**

| any | Currently | active (changed) settings value |
|-----|-----------|---------------------------------|

**Code**

```lua
function SettingsModel:getValue(settingKey, trueValue)
    if trueValue then
        return self.settingReaders[settingKey](settingKey)
    end
    if self.settings[settingKey] = = nil then -- resolution can be missing on consoles
        return 0
    end

    return self.settings[settingKey].changed
end

```

### getVehicleArmSensitivityTexts

**Description**

> Get valid camera sensitivity texts.

**Definition**

> getVehicleArmSensitivityTexts()

**Code**

```lua
function SettingsModel:getVehicleArmSensitivityTexts()
    return self.vehicleArmSensitivityStrings
end

```

### getVoiceInputSensitivityTexts

**Description**

> Get valid audio volume texts.

**Definition**

> getVoiceInputSensitivityTexts()

**Code**

```lua
function SettingsModel:getVoiceInputSensitivityTexts()
    return self.voiceInputThresholdTexts
end

```

### getVoiceModeTexts

**Description**

**Definition**

> getVoiceModeTexts()

**Code**

```lua
function SettingsModel:getVoiceModeTexts()
    return self.voiceModeTexts
end

```

### getVolumeMeshTessalationTexts

**Description**

**Definition**

> getVolumeMeshTessalationTexts()

**Code**

```lua
function SettingsModel:getVolumeMeshTessalationTexts()
    return self.perentageTexts
end

```

### hasChanges

**Description**

> Check if any setting has been changed in the model.

**Definition**

> hasChanges()

**Return Values**

| any | True | if any setting has been changed, false otherwise |
|-----|------|--------------------------------------------------|

**Code**

```lua
function SettingsModel:hasChanges()
    for _, setting in pairs( self.settings) do
        if setting.initial ~ = setting.changed or setting.initial ~ = setting.saved then
            return true
        end
    end

    return self:hasDeviceChanges()
end

```

### hasDeviceChanges

**Description**

**Definition**

> hasDeviceChanges()

**Code**

```lua
function SettingsModel:hasDeviceChanges()
    for _, settings in ipairs( self.deviceSettings) do
        for axisIndex, _ in pairs(settings.deadzones) do
            local deadzone = settings.deadzones[axisIndex]
            if deadzone.current ~ = deadzone.saved then
                return true
            end

            local sensitivity = settings.sensitivities[axisIndex]
            if sensitivity.current ~ = sensitivity.saved then
                return true
            end
        end

        if settings.device.category = = InputDevice.CATEGORY.KEYBOARD_MOUSE then
            local mouseSensitivity = settings.mouseSensitivity
            if mouseSensitivity.current ~ = mouseSensitivity.saved then
                return true
            end
        end

        local headTrackingSensitivity = settings.headTrackingSensitivity
        if headTrackingSensitivity.current ~ = headTrackingSensitivity.saved then
            return true
        end
    end

    return false
end

```

### initDeviceSettings

**Description**

**Definition**

> initDeviceSettings()

**Code**

```lua
function SettingsModel:initDeviceSettings()
    self.deviceSettings = { }
    self.currentDevice = 0

    for _, device in pairs(g_inputBinding.devicesByInternalId) do
        local deadzones = { }
        local sensitivities = { }
        local mouseSensitivity = { }
        local headTrackingSensitivity = { }
        table.insert( self.deviceSettings, { device = device, deadzones = deadzones, sensitivities = sensitivities, mouseSensitivity = mouseSensitivity, headTrackingSensitivity = headTrackingSensitivity } )

        for axisIndex = 0 , Input.MAX_NUM_AXES - 1 do
            if getHasGamepadAxis(axisIndex, device.internalId) then
                local deadzone = device:getDeadzone(axisIndex)
                local deadzoneValue = Utils.getValueIndex(deadzone, self.deadzoneValues)
                deadzones[axisIndex] = { current = deadzoneValue, saved = deadzoneValue }

                local sensitivity = device:getSensitivity(axisIndex)
                local sensitivityValue = Utils.getValueIndex(sensitivity, self.sensitivityValues)
                sensitivities[axisIndex] = { current = sensitivityValue, saved = sensitivityValue }
            end
        end

        if device.category = = InputDevice.CATEGORY.KEYBOARD_MOUSE then
            local scale, _ = g_inputBinding:getMouseMotionScale()
            local value = Utils.getValueIndex(scale, self.sensitivityValues)
            mouseSensitivity.current = value
            mouseSensitivity.saved = value
        end

        local value = Utils.getValueIndex(getCameraTrackingSensitivity(), self.headTrackingSensitivityValues)
        headTrackingSensitivity.current = value
        headTrackingSensitivity.saved = value

        self.currentDevice = 1
    end
end

```

### initialize

**Description**

> Initialize model.
> Read current configuration settings and populate valid display and configuration option values.

**Definition**

> initialize()

**Code**

```lua
function SettingsModel:initialize()
    self:createControlDisplayValues()
    self:addManagedSettings()
end

```

### needsProcessRestartToApplyChanges

**Description**

> Check if any setting has been changed in the model that needs a full (process) restart.

**Definition**

> needsProcessRestartToApplyChanges()

**Return Values**

| any | True | if any setting that needs a full restart has been changed, false otherwise |
|-----|------|----------------------------------------------------------------------------|

**Code**

```lua
function SettingsModel:needsProcessRestartToApplyChanges()
    if self:getSettingExists( SettingsModel.SETTING.RESOLUTION) then
        if g_settingsModel:getHasValueChanged( SettingsModel.SETTING.RESOLUTION) then
            return true
        end
    end
    if self:getSettingExists( SettingsModel.SETTING.FULLSCREEN_MODE) then
        if g_settingsModel:getHasValueChanged( SettingsModel.SETTING.FULLSCREEN_MODE) then
            return true
        end
    end

    return false
end

```

### needsRestartToApplyChanges

**Description**

> Check if any setting has been changed in the model.

**Definition**

> needsRestartToApplyChanges()

**Return Values**

| any | True | if any setting has been changed, false otherwise                   |
|-----|------|--------------------------------------------------------------------|
| any | True | if the restart needs to be a full process restart, false otherwise |

**Code**

```lua
function SettingsModel:needsRestartToApplyChanges()
    for _, setting in pairs( self.settings) do
        if (setting.initial ~ = setting.changed or setting.initial ~ = setting.saved) and setting.restartRequired then
            return true , self:needsProcessRestartToApplyChanges()
        end
    end

    return false , false
end

```

### new

**Description**

> Create a new instance.

**Definition**

> new(table l10n, table soundMixer)

**Arguments**

| table | l10n       | I18N reference for localized display string resolution         |
|-------|------------|----------------------------------------------------------------|
| table | soundMixer | SoundMixer reference for direct application of volume settings |

**Return Values**

| table | SettingsModel | instance |
|-------|---------------|----------|

**Code**

```lua
function SettingsModel.new()
    local self = setmetatable( { } , SettingsModel _mt)

    self.settings = { } -- previous and current settings, {[setting] -> {saved = value, changed = value}}
    self.sortedSettings = { } -- settings
    self.settingReaders = { } -- [settingKey] -> function
        self.settingWriters = { } -- [settingKey] -> function
            self.settingTexts = { } -- [settingKey] -> function
                self.settingsRawToValues = { } -- [settingKey] -> function
                    self.settingsValueToRaws = { } -- [settingKey] -> function
                        self.settingsOnChanges = { } -- [settingKey] -> function

                            self.defaultReaderFunction = self:makeDefaultReaderFunction()
                            self.defaultWriterFunction = self:makeDefaultWriterFunction()

                            self.volumeTexts = { }
                            self.voiceInputThresholdTexts = { }
                            self.recordingVolumeTexts = { }
                            self.voiceModeTexts = { }
                            self.brightnessTexts = { }
                            self.fovYTexts = { }
                            self.indexToFovYMapping = { }
                            self.fovYToIndexMapping = { }
                            self.uiScaleValues = { }
                            self.uiScaleTexts = { }
                            self.cameraSensitivityValues = { }
                            self.cameraSensitivityStrings = { }
                            self.cameraSensitivityStep = 0.25
                            self.vehicleArmSensitivityValues = { }
                            self.vehicleArmSensitivityStrings = { }
                            self.vehicleArmSensitivityStep = 0.25
                            self.realBeaconLightBrightnessValues = { }
                            self.realBeaconLightBrightnessStrings = { }
                            self.realBeaconLightBrightnessStep = 0.1
                            self.steeringBackSpeedValues = { }
                            self.steeringBackSpeedStrings = { }
                            self.steeringBackSpeedStep = 1
                            self.steeringSensitivityValues = { }
                            self.steeringSensitivityStrings = { }
                            self.steeringSensitivityStep = 0.1
                            self.moneyUnitTexts = { }
                            self.distanceUnitTexts = { }
                            self.temperatureUnitTexts = { }
                            self.areaUnitTexts = { }
                            self.radioModeTexts = { }
                            self.resolutionScaleTexts = { }
                            self.resolutionScale3dTexts = { }
                            self.drsTargetFPSTexts = { }
                            self.sharpnessTexts = { }
                            self.scalingModeTexts = { }

                            self.shadowQualityTexts = { }
                            self.shadowDistanceQualityTexts = { }
                            self.softShadowsTexts = { }
                            self.fourStateTexts = { }
                            self.lowHighTexts = { }
                            self.shadowMapMaxLightsTexts = { }
                            self.hdrPeakBrightnessValues = { }
                            self.hdrPeakBrightnessTexts = { }
                            self.hdrPeakBrightnessStep = 0.05
                            self.hdrContrastValues = { }
                            self.hdrContrastTexts = { }
                            self.hdrContrastStep = 0.01
                            self.overlayBrightnessValues = { }
                            self.overlayBrightnessTexts = { }
                            self.overlayBrightnessStep = 0.05
                            self.percentValues = { }
                            self.perentageTexts = { }
                            self.percentStep = 0.05
                            self.tireTracksValues = { }
                            self.tireTracksTexts = { }
                            self.tireTracksStep = 0.5
                            self.maxMirrorsTexts = { }
                            self.ssaoQualityTexts = { }

                            self.resolutionTexts = { }
                            self.fullscreenModeTexts = { }
                            self.mpLanguageTexts = { }
                            self.inputHelpModeTexts = { }
                            self.directionChangeModeTexts = { }
                            self.gearShiftModeTexts = { }
                            self.hudSpeedGaugeTexts = { }
                            self.frameLimitTexts = { }

                            self.intialValues = { }

                            self.deviceSettings = { }
                            self.currentDevice = { }

                            self.minBrightness = 0.5
                            self.maxBrightness = 2.0
                            self.brightnessStep = 0.1

                            self.minSharpness = 0.0
                            self.maxSharpness = 2.0
                            self.sharpnessStep = 0.1

                            self.qualityTexts = {
                            OFF = g_i18n:getText( "ui_off" ),
                            ON = g_i18n:getText( "ui_on" ),
                            LOW = g_i18n:getText( "setting_low" ),
                            MEDIUM = g_i18n:getText( "setting_medium" ),
                            HIGH = g_i18n:getText( "setting_high" ),
                            VERY_HIGH = g_i18n:getText( "setting_veryHigh" ),
                            ULTRA = g_i18n:getText( "setting_ultra" ),
                            MAX_QUALITY = g_i18n:getText( "setting_maxQuality" ),
                            BALANCED_PERFORMANCE = g_i18n:getText( "setting_balancedPerformance" ),
                            MAX_PERFORMANCE = g_i18n:getText( "setting_maxPerformance" ),
                            ULTRA_PERFORMANCE = g_i18n:getText( "setting_ultraPerformance" ),
                            ULTRA_QUALITY = g_i18n:getText( "setting_ultraQuality" ),
                            ULTRA_QUALITY_PLUS = g_i18n:getText( "setting_ultraQualityPlus" ),
                            QUALITY = g_i18n:getText( "setting_quality" ),
                            BALANCED = g_i18n:getText( "setting_balanced" ),
                            PERFORMANCE = g_i18n:getText( "setting_performance" )
                            }

                            self:initialize()

                            return self
                        end

```

### nextDevice

**Description**

**Definition**

> nextDevice()

**Code**

```lua
function SettingsModel:nextDevice()
    self.currentDevice = self.currentDevice + 1
    if self.currentDevice > # self.deviceSettings then
        self.currentDevice = 1
    end
end

```

### refresh

**Description**

> Refresh settings values from their reader functions.
> Use this when other components might have changed the settings state and the model needs to reflect those changes
> now.

**Definition**

> refresh()

**Code**

```lua
function SettingsModel:refresh()
    for settingsKey, setting in pairs( self.settings) do
        setting.initial = self.settingReaders[settingsKey](settingsKey)
        setting.changed = setting.initial
        setting.saved = setting.initial
    end
end

```

### refreshChangedValue

**Description**

> Refresh currently changed settings values from their reader functions. Calling reset will still reset to the old known
> values.
> Use this when other components might have changed the settings state and the model needs to reflect those changes
> now.

**Definition**

> refreshChangedValue()

**Code**

```lua
function SettingsModel:refreshChangedValue()
    for settingsKey, setting in pairs( self.settings) do
        setting.changed = self.settingReaders[settingsKey](settingsKey)
        setting.saved = setting.changed
    end
end

```

### reset

**Description**

> Reset all settings to the initial values since the last apply

**Definition**

> reset()

**Code**

```lua
function SettingsModel:reset()
    for _, setting in pairs( self.sortedSettings) do
        local hasChanged = setting.initial ~ = setting.changed or setting.initial ~ = setting.saved
        setting.changed = setting.initial
        setting.saved = setting.initial

        if hasChanged then
            local writeFunction = self.settingWriters[setting.key]
            writeFunction(setting.changed, setting.key)
        end
    end

    setUserConfirmScreenMode( true )

    self:resetDeviceChanges()
end

```

### resetDeviceChanges

**Description**

**Definition**

> resetDeviceChanges()

**Code**

```lua
function SettingsModel:resetDeviceChanges()
    for _, settings in ipairs( self.deviceSettings) do
        for axisIndex, _ in pairs(settings.deadzones) do
            local deadzone = settings.deadzones[axisIndex]
            deadzone.current = deadzone.saved

            local sensitivity = settings.sensitivities[axisIndex]
            sensitivity.current = sensitivity.saved
        end

        settings.mouseSensitivity.current = settings.mouseSensitivity.saved
        settings.headTrackingSensitivity.current = settings.headTrackingSensitivity.saved
    end
end

```

### saveChanges

**Description**

> Save the game settings which may have been modified by this model.
> This will not apply transient changes but only persist the currently applied game settings.

**Definition**

> saveChanges()

**Arguments**

| any | settingClassesToSave |
|-----|----------------------|

**Code**

```lua
function SettingsModel:saveChanges(settingClassesToSave)
    if bit32.band(settingClassesToSave, SettingsModel.SETTING_CLASS.SAVE_GAMEPLAY_SETTINGS) ~ = 0 then
        g_gameSettings:save()
    end

    self:saveDeviceChanges()

    if bit32.band(settingClassesToSave, SettingsModel.SETTING_CLASS.SAVE_ENGINE_QUALITY_SETTINGS) ~ = 0 then
        saveHardwareScalability()
        if GS_IS_CONSOLE_VERSION or GS_IS_MOBILE_VERSION then
            executeSettingsChange()
        end
    end
end

```

### saveDeviceChanges

**Description**

**Definition**

> saveDeviceChanges()

**Code**

```lua
function SettingsModel:saveDeviceChanges()
    local changedSettings = false
    for _, settings in ipairs( self.deviceSettings) do
        local device = settings.device
        for axisIndex, _ in pairs(settings.deadzones) do
            local deadzones = settings.deadzones[axisIndex]
            local deadzone = self.deadzoneValues[deadzones.current]
            deadzones.saved = deadzones.current
            device:setDeadzone(axisIndex, deadzone)

            local sensitivities = settings.sensitivities[axisIndex]
            local sensitivity = self.sensitivityValues[sensitivities.current]
            sensitivities.saved = sensitivities.current

            device:setSensitivity(axisIndex, sensitivity)
            changedSettings = true
        end
        if settings.device.category = = InputDevice.CATEGORY.KEYBOARD_MOUSE then
            local mouseSensitivity = settings.mouseSensitivity
            if mouseSensitivity.current ~ = mouseSensitivity.saved then
                g_inputBinding:setMouseMotionScale( self.sensitivityValues[mouseSensitivity.current])
                mouseSensitivity.saved = mouseSensitivity.current
                changedSettings = true
            end

            local headTrackingSensitivity = settings.headTrackingSensitivity
            if headTrackingSensitivity.current ~ = headTrackingSensitivity.saved then
                setCameraTrackingSensitivity( self.headTrackingSensitivityValues[headTrackingSensitivity.current])
                headTrackingSensitivity.saved = headTrackingSensitivity.current
                changedSettings = true
            end
        end
    end

    if changedSettings then
        g_inputBinding:applyGamepadDeadzones()
        g_inputBinding:saveToXMLFile()
    end
end

```

### setDeviceDeadzoneValue

**Description**

**Definition**

> setDeviceDeadzoneValue()

**Arguments**

| any | axisIndex |
|-----|-----------|
| any | value     |

**Code**

```lua
function SettingsModel:setDeviceDeadzoneValue(axisIndex, value)
    local settings = self.deviceSettings[ self.currentDevice]
    if settings ~ = nil then
        settings.deadzones[axisIndex].current = value
    end
end

```

### setDeviceSensitivityValue

**Description**

**Definition**

> setDeviceSensitivityValue()

**Arguments**

| any | axisIndex |
|-----|-----------|
| any | value     |

**Code**

```lua
function SettingsModel:setDeviceSensitivityValue(axisIndex, value)
    local settings = self.deviceSettings[ self.currentDevice]
    if settings ~ = nil then
        settings.sensitivities[axisIndex].current = value
    end
end

```

### setHeadTrackingSensitivity

**Description**

**Definition**

> setHeadTrackingSensitivity()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function SettingsModel:setHeadTrackingSensitivity(value)
    local settings = self.deviceSettings[ self.currentDevice]
    if settings ~ = nil then
        settings.headTrackingSensitivity.current = value
    end
end

```

### setMouseSensitivity

**Description**

**Definition**

> setMouseSensitivity()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function SettingsModel:setMouseSensitivity(value)
    local settings = self.deviceSettings[ self.currentDevice]
    if settings ~ = nil then
        settings.mouseSensitivity.current = value
    end
end

```

### setValue

**Description**

> Set a settings value.

**Definition**

> setValue(string settingKey, any value)

**Arguments**

| string | settingKey | Setting key, use one of the values in SettingsModel.SETTING. |
|--------|------------|--------------------------------------------------------------|
| any    | value      | New setting value                                            |

**Code**

```lua
function SettingsModel:setValue(settingKey, value)
    if self.settings[settingKey] = = nil then
        Logging.warning( "SettingsModel key %q is not registered" , settingKey)
        --#debug printCallstack()
        return
    end

    if value = = nil then
        --this can happen if we try to set a setting that is not supported, for example PPAA settings on Apple PCs
            return
        end

        local oldValue = self.settings[settingKey].changed
        self.settings[settingKey].changed = value

        local rawValue = value
        local func = self.settingsValueToRaws[settingKey]
        if func ~ = nil then
            rawValue = func(value)
        end

        local onChangedFunc = self.settingsOnChanges[settingKey]
        if onChangedFunc ~ = nil then
            onChangedFunc(value, rawValue, oldValue ~ = value)
        end
    end

```