## Gui

**Description**

> Graphical User Interface controller.
> Builds UI from configurations, provides dialog display and propagates UI input.

**Functions**

- [addFrame](#addframe)
- [addScreen](#addscreen)
- [assignPlaySampleCallback](#assignplaysamplecallback)
- [changeScreen](#changescreen)
- [closeAllDialogs](#closealldialogs)
- [closeDialog](#closedialog)
- [closeDialogByName](#closedialogbyname)
- [draw](#draw)
- [enterMenuContext](#entermenucontext)
- [getIsDialogVisible](#getisdialogvisible)
- [getIsGuiVisible](#getisguivisible)
- [getIsOverlayGuiVisible](#getisoverlayguivisible)
- [getProfile](#getprofile)
- [getScreenInstanceByClass](#getscreeninstancebyclass)
- [hasElementInputFocus](#haselementinputfocus)
- [initGuiLibrary](#initguilibrary)
- [keyEvent](#keyevent)
- [leaveMenuContext](#leavemenucontext)
- [loadGui](#loadgui)
- [loadGuiRec](#loadguirec)
- [loadMapData](#loadmapdata)
- [loadPresets](#loadpresets)
- [loadProfiles](#loadprofiles)
- [loadProfileSet](#loadprofileset)
- [loadTraits](#loadtraits)
- [makeChangeScreenClosure](#makechangescreenclosure)
- [makePlaySampleClosure](#makeplaysampleclosure)
- [makeToggleCustomInputContextClosure](#maketogglecustominputcontextclosure)
- [mouseEvent](#mouseevent)
- [new](#new)
- [notifyControls](#notifycontrols)
- [onMenuInput](#onmenuinput)
- [onReleaseInput](#onreleaseinput)
- [onReleaseMovement](#onreleasemovement)
- [registerGuiElement](#registerguielement)
- [registerGuiElementProcFunction](#registerguielementprocfunction)
- [registerMenuInput](#registermenuinput)
- [resolveFrameReference](#resolveframereference)
- [setClient](#setclient)
- [setCurrentMission](#setcurrentmission)
- [setServer](#setserver)
- [showDialog](#showdialog)
- [showGui](#showgui)
- [toggleCustomInputContext](#togglecustominputcontext)
- [touchEvent](#touchevent)
- [unloadMapData](#unloadmapdata)
- [update](#update)

### addFrame

**Description**

> Add the instance of a specific reusable GUI frame.

**Definition**

> addFrame()

**Arguments**

| any | frameController  |
|-----|------------------|
| any | frameRootElement |

**Code**

```lua
function Gui:addFrame(frameController, frameRootElement)
    -- TODO:switch to class keys like screens
    self.frames[frameController.name] = frameRootElement

    frameController:setChangeScreenCallback( self.changeScreenClosure)
    frameController:setInputContextCallback( self.toggleCustomInputContextClosure)
    frameController:setPlaySampleCallback( self.playSampleClosure)
end

```

### addScreen

**Description**

> Add the instance of a specific GUI screen.

**Definition**

> addScreen()

**Arguments**

| any | screenClass       |
|-----|-------------------|
| any | screenInstance    |
| any | screenRootElement |

**Code**

```lua
function Gui:addScreen(screenClass, screenInstance, screenRootElement)
    self.screens[screenClass] = screenRootElement
    self.screenControllers[screenClass] = screenInstance

    -- TODO:use the same pattern for dialog calling from screens
        screenInstance:setChangeScreenCallback( self.changeScreenClosure)
        screenInstance:setInputContextCallback( self.toggleCustomInputContextClosure)
        screenInstance:setPlaySampleCallback( self.playSampleClosure)
    end

```

### assignPlaySampleCallback

**Description**

> Assign the play sample closure to a GUI element which has the PlaySampleMixin included.

**Definition**

> assignPlaySampleCallback(table guiElement)

**Arguments**

| table | guiElement | GuiElement instance |
|-------|------------|---------------------|

**Return Values**

| table | The | GuiElement instance given in the guiElement parameter |
|-------|-----|-------------------------------------------------------|

**Code**

```lua
function Gui:assignPlaySampleCallback(guiElement)
    if guiElement:hasIncluded( PlaySampleMixin ) then
        guiElement:setPlaySampleCallback( self.playSampleClosure)
    end

    return guiElement
end

```

### changeScreen

**Description**

> Change the currently displayed screen.

**Definition**

> changeScreen(table? sourceScreen, table? screenClass, table? returnScreenClass)

**Arguments**

| table? | sourceScreen      | Source screen instance                                                                          |
|--------|-------------------|-------------------------------------------------------------------------------------------------|
| table? | screenClass       | Class table of the requested screen to change to or nil to close the GUI                        |
| table? | returnScreenClass | [optional] Class table of the screen which will be opened on a "back" action in the new screen. |

**Return Values**

| table? | Root | GuiElement instance of target screen |
|--------|------|--------------------------------------|

**Code**

```lua
function Gui:changeScreen(sourceScreen, screenClass, returnScreenClass)
    local screenController = self.screenControllers[screenClass]
    if screenClass ~ = nil and screenController = = nil then
        Logging.devWarning( "UI '%s' not found" , ClassUtil.getClassName(screenClass))
        return nil
    end

    self:closeAllDialogs()

    local isMenuOpening = not self:getIsGuiVisible()
    local screenElement = self.screens[screenClass]

    -- close given source or current gui if no source was given
        if sourceScreen ~ = nil then
            sourceScreen:onClose()
        elseif self.currentGui ~ = nil then
                self.currentGui:onClose()
            end

            local screenName = screenElement and screenElement.name or ""
            self.currentGui = screenElement
            self.currentGuiName = screenName
            self.currentListener = screenElement

            if screenElement ~ = nil and isMenuOpening then
                g_messageCenter:publish(MessageType.GUI_BEFORE_OPEN)
                self:enterMenuContext()
            end

            FocusManager:setGui(screenName)

            if screenElement ~ = nil and screenController ~ = nil then
                screenController:setReturnScreenClass(returnScreenClass or screenController.returnScreenClass) -- it's fine if its nil, the value is being checked
                    screenElement:onOpen()

                    if isMenuOpening then
                        g_messageCenter:publish(MessageType.GUI_AFTER_OPEN)
                    end
                end

                if not self:getIsGuiVisible() then
                    g_messageCenter:publish(MessageType.GUI_BEFORE_CLOSE)
                    -- clear input context if GUI is now completely closed(including dialogs)
                        self:leaveMenuContext()
                        g_messageCenter:publish(MessageType.GUI_AFTER_CLOSE)
                    end

                    g_adsSystem:setGroupActive(AdsSystem.OCCLUSION_GROUP.UI, self.currentGui ~ = nil )

                    return screenElement -- required by some screens to transfer state to the next view
                end

```

### closeAllDialogs

**Description**

> Close all open dialogs.

**Definition**

> closeAllDialogs()

**Code**

```lua
function Gui:closeAllDialogs()
    for _,v in ipairs( self.dialogs) do
        self:closeDialog(v)
    end
end

```

### closeDialog

**Description**

> Close a dialog identified by its root GuiElement.
> This is always called when a dialog is closed, usually by itself.

**Definition**

> closeDialog()

**Arguments**

| any | gui |
|-----|-----|

**Code**

```lua
function Gui:closeDialog(gui)
    for k,v in ipairs( self.dialogs) do
        if v = = gui then
            v:onClose()
            table.remove( self.dialogs, k)

            if gui.blurAreaActive then
                g_depthOfFieldManager:popArea()
                gui.blurAreaActive = false
            end

            if self.currentListener = = gui then
                if # self.dialogs > 0 then
                    self.currentListener = self.dialogs[# self.dialogs]
                else
                        if self.currentGui = = gui then
                            self.currentListener = nil
                            self.currentGui = nil
                        else
                                self.currentListener = self.currentGui
                            end
                        end

                        if self.currentListener ~ = nil then
                            FocusManager:setGui( self.currentListener.name)
                            if self.focusElements[ self.currentListener] ~ = nil then
                                FocusManager:setFocus( self.focusElements[ self.currentListener])
                                self.focusElements[ self.currentListener] = nil
                            end
                        end
                    end

                    if gui.target.needInput = = nil or gui.target.needInput = = true then
                        -- revert dialog input context
                        g_inputBinding:revertContext( false )
                    end

                    break
                end
            end

            if not self:getIsGuiVisible() then
                -- trigger close screen which dispatches required messages and adjusts input context:
                self:changeScreen( nil )
            end
        end

```

### closeDialogByName

**Description**

> Close a dialog identified by name.

**Definition**

> closeDialogByName()

**Arguments**

| any | guiName |
|-----|---------|

**Code**

```lua
function Gui:closeDialogByName(guiName)
    local gui = self.guis[guiName]
    if gui ~ = nil then
        self:closeDialog(gui)
    end
end

```

### draw

**Description**

> Draw the GUI.
> Propagates draw calls to all active UI elements.

**Definition**

> draw()

**Code**

```lua
function Gui:draw()
    if self.currentGui ~ = nil then
        -- self.currentGui:draw()
        if self.currentGui.target ~ = nil then
            if self.currentGui.target.draw ~ = nil then
                self.currentGui.target:draw()
            end
        end
    end

    for _,v in pairs( self.dialogs) do
        -- v:draw()
        if v.target ~ = nil then
            v.target:draw()
        end
    end

    if g_uiDebugEnabled then
        local item = FocusManager.currentFocusData.focusElement

        local function getGuiElementName(e, _)
            if e = = nil then
                return "none"
            else
                    return e.id or e.profile or e.name
                end
            end

            setTextAlignment(RenderText.ALIGN_CENTER)
            renderText( 0.5 , 0.94 , 0.02 , "Focused element: " .. getGuiElementName(item))
            if item ~ = nil then
                renderText( 0.5 , 0.92 , 0.02 , "Top element: " .. getGuiElementName( FocusManager:getNextFocusElement(item, FocusManager.TOP)))
                renderText( 0.5 , 0.90 , 0.02 , "Bottom element: " .. getGuiElementName( FocusManager:getNextFocusElement(item, FocusManager.BOTTOM)))
                renderText( 0.5 , 0.88 , 0.02 , "Left element: " .. getGuiElementName( FocusManager:getNextFocusElement(item, FocusManager.LEFT)))
                renderText( 0.5 , 0.86 , 0.02 , "Right element: " .. getGuiElementName( FocusManager:getNextFocusElement(item, FocusManager.RIGHT)))

                local xPixel = 3 * g_pixelSizeX
                local yPixel = 3 * g_pixelSizeY

                drawFilledRect(item.absPosition[ 1 ] - xPixel, item.absPosition[ 2 ] - yPixel, item.absSize[ 1 ] + 2 * xPixel, yPixel, 1 , 0.5 , 0 , 1 )
                drawFilledRect(item.absPosition[ 1 ] - xPixel, item.absPosition[ 2 ] + item.absSize[ 2 ], item.absSize[ 1 ] + 2 * xPixel, yPixel, 1 , 0.5 , 0 , 1 )
                drawFilledRect(item.absPosition[ 1 ] - xPixel, item.absPosition[ 2 ], xPixel, item.absSize[ 2 ], 1 , 0.5 , 0 , 1 )
                drawFilledRect(item.absPosition[ 1 ] + item.absSize[ 1 ], item.absPosition[ 2 ], xPixel, item.absSize[ 2 ], 1 , 0.5 , 0 , 1 )
            end
            setTextAlignment(RenderText.ALIGN_LEFT)
        end
    end

```

### enterMenuContext

**Description**

> Enter a new menu input context.
> Menu views which require special input should provide a context name to not collide with the base menu input scheme.

**Definition**

> enterMenuContext(string? contextName)

**Arguments**

| string? | contextName | [optional] Custom menu input context name |
|---------|-------------|-------------------------------------------|

**Code**

```lua
function Gui:enterMenuContext(contextName)
    g_inputBinding:setContext(contextName or Gui.INPUT_CONTEXT_MENU, true , false )
    self:registerMenuInput()
    self.isInputListening = true
end

```

### getIsDialogVisible

**Description**

> Determine if any dialog is visible.

**Definition**

> getIsDialogVisible()

**Code**

```lua
function Gui:getIsDialogVisible()
    return # self.dialogs > 0
end

```

### getIsGuiVisible

**Description**

> Determine if any menu or dialog is visible.

**Definition**

> getIsGuiVisible()

**Code**

```lua
function Gui:getIsGuiVisible()
    return self.currentGui ~ = nil or self:getIsDialogVisible()
end

```

### getIsOverlayGuiVisible

**Description**

> Determine if an overlaid UI view with regular game display is visible, e.g. placement or landscaping.

**Definition**

> getIsOverlayGuiVisible()

**Code**

```lua
function Gui:getIsOverlayGuiVisible()
    return false
end

```

### getProfile

**Description**

> Get a UI profile by name.

**Definition**

> getProfile()

**Arguments**

| any | profileName |
|-----|-------------|

**Code**

```lua
function Gui:getProfile(profileName)
    if profileName ~ = nil then
        local specialized = false

        local defaultProfileName = profileName
        for _, prefix in ipairs(Platform.guiPrefixes) do
            local customProfileName = prefix .. defaultProfileName
            if self.profiles[customProfileName] ~ = nil then
                profileName = customProfileName
                specialized = true
            end
        end

        if not specialized and Platform.isConsole then
            local consoleProfileName = "console_" .. profileName
            if self.profiles[consoleProfileName] ~ = nil then
                profileName = consoleProfileName
                specialized = true
            end
        end

        if not specialized and Platform.isMobile then
            local consoleProfileName = "mobile_" .. profileName
            if self.profiles[consoleProfileName] ~ = nil then
                profileName = consoleProfileName
                -- specialized = true
            end
        end
    end

    if not profileName or not self.profiles[profileName] then
        -- only warn if profile name is wrong, undefined is fine
            if profileName and profileName ~ = "" then
                Logging.warning( "Could not retrieve GUI profile '%s'.Using base reference profile instead." , tostring(profileName))
            end

            profileName = Gui.GUI_PROFILE_BASE
        end

        return self.profiles[profileName]
    end

```

### getScreenInstanceByClass

**Description**

> Get a screen controller instance by class for special cases.

**Definition**

> getScreenInstanceByClass(table screenClass)

**Arguments**

| table | screenClass | Class table of the requested screen |
|-------|-------------|-------------------------------------|

**Return Values**

| table | ScreenElement | descendant instance of the given class or nil if no such instance was registered |
|-------|---------------|----------------------------------------------------------------------------------|

**Code**

```lua
function Gui:getScreenInstanceByClass(screenClass)
    return self.screenControllers[screenClass]
end

```

### hasElementInputFocus

**Description**

> Determine if a given GuiElement has input focus.

**Definition**

> hasElementInputFocus()

**Arguments**

| any | element |
|-----|---------|

**Code**

```lua
function Gui:hasElementInputFocus(element)
    return self.currentListener ~ = nil and self.currentListener.target = = element
end

```

### initGuiLibrary

**Description**

> Source in UI modules.

**Definition**

> initGuiLibrary(string baseDir)

**Arguments**

| string | baseDir | Base scripts directory |
|--------|---------|------------------------|

**Code**

```lua
function Gui.initGuiLibrary(baseDir)
    source(baseDir .. "/base/GuiProfile.lua" )
    source(baseDir .. "/base/GuiUtils.lua" )
    source(baseDir .. "/base/GuiOverlay.lua" )

    source(baseDir .. "/base/GuiDataSource.lua" )

    source(baseDir .. "/base/GuiMixin.lua" )
    source(baseDir .. "/base/IndexChangeSubjectMixin.lua" )
    source(baseDir .. "/base/PlaySampleMixin.lua" )

    source(baseDir .. "/base/Tween.lua" )
    source(baseDir .. "/base/MultiValueTween.lua" )
    source(baseDir .. "/base/TweenSequence.lua" )

    source(baseDir .. "/elements/GuiElement.lua" )
    source(baseDir .. "/elements/FrameElement.lua" )
    source(baseDir .. "/elements/ScreenElement.lua" )
    source(baseDir .. "/elements/DialogElement.lua" )
    source(baseDir .. "/elements/BitmapElement.lua" )
    source(baseDir .. "/elements/ClearElement.lua" )
    source(baseDir .. "/elements/TextElement.lua" )
    source(baseDir .. "/elements/ButtonElement.lua" )
    source(baseDir .. "/elements/ToggleButtonElement.lua" )
    source(baseDir .. "/elements/ColorPickButtonElement.lua" ) -- not used anywhere
    source(baseDir .. "/elements/VideoElement.lua" )
    source(baseDir .. "/elements/SliderElement.lua" )
    source(baseDir .. "/elements/TextInputElement.lua" )
    source(baseDir .. "/elements/MultiTextOptionElement.lua" )
    source(baseDir .. "/elements/OptionSliderElement.lua" )
    source(baseDir .. "/elements/CheckedOptionElement.lua" )
    source(baseDir .. "/elements/BinaryOptionElement.lua" )
    source(baseDir .. "/elements/ListItemElement.lua" )
    source(baseDir .. "/elements/AnimationElement.lua" )
    source(baseDir .. "/elements/TimerElement.lua" ) -- not used anywhere
    source(baseDir .. "/elements/BoxLayoutElement.lua" )
    source(baseDir .. "/elements/PagingElement.lua" )
    source(baseDir .. "/elements/TableHeaderElement.lua" )
    source(baseDir .. "/elements/IngameMapElement.lua" )
    source(baseDir .. "/elements/IngameMapPreviewElement.lua" )
    source(baseDir .. "/elements/IndexStateElement.lua" )
    source(baseDir .. "/elements/FrameReferenceElement.lua" )
    source(baseDir .. "/elements/RenderElement.lua" )
    source(baseDir .. "/elements/BreadcrumbsElement.lua" )
    source(baseDir .. "/elements/ThreePartBitmapElement.lua" )
    source(baseDir .. "/elements/PictureElement.lua" )
    source(baseDir .. "/elements/ScrollingLayoutElement.lua" )
    source(baseDir .. "/elements/MultiOptionElement.lua" )
    source(baseDir .. "/elements/TextBackdropElement.lua" )
    source(baseDir .. "/elements/InputGlyphElementUI.lua" )
    source(baseDir .. "/elements/TerrainLayerElement.lua" )
    source(baseDir .. "/elements/SmoothListElement.lua" )
    source(baseDir .. "/elements/DynamicFadedBitmapElement.lua" )
    source(baseDir .. "/elements/PlatformIconElement.lua" )
    source(baseDir .. "/elements/OptionToggleElement.lua" )
    source(baseDir .. "/elements/RoundCornerElement.lua" )
    source(baseDir .. "/elements/SafeFrameElement.lua" )
end

```

### keyEvent

**Description**

> GUI key event hook.
> This is used for GuiElements which need to have direct access to raw key input, such as TextInputElement.

**Definition**

> keyEvent()

**Arguments**

| any | unicode  |
|-----|----------|
| any | sym      |
| any | modifier |
| any | isDown   |

**Code**

```lua
function Gui:keyEvent(unicode, sym, modifier, isDown)
    local eventUsed = false
    if self.currentListener ~ = nil then
        eventUsed = self.currentListener:keyEvent(unicode, sym, modifier, isDown)
    end

    if self.currentListener ~ = nil and self.currentListener.target ~ = nil and not eventUsed then
        if self.currentListener.target.keyEvent ~ = nil then
            self.currentListener.target:keyEvent(unicode, sym, modifier, isDown, eventUsed)
        end
    end
end

```

### leaveMenuContext

**Description**

> Leave a menu input context.
> This wraps the input context setting to check if the menu is actually active and the context should be reverted to
> the state before entering the menu (or a custom menu input context within the menu).

**Definition**

> leaveMenuContext()

**Code**

```lua
function Gui:leaveMenuContext()
    if self.isInputListening then
        g_inputBinding:revertContext( false )
        self.isInputListening = self:getIsGuiVisible() -- keep listening if still visible
        end
    end

```

### loadGui

**Description**

> Load a UI screen view's elements from an XML definition.

**Definition**

> loadGui(xmlFilename View, name Screen, controller FrameElement, isFrame? [optional,)

**Arguments**

| xmlFilename | View         | definition XML file path, relative to application root.                                          |
|-------------|--------------|--------------------------------------------------------------------------------------------------|
| name        | Screen       | name                                                                                             |
| controller  | FrameElement | instance which serves as the controller for loaded elements                                      |
| isFrame?    | [optional,   | default=false] If true, will interpret the loaded view as a frame to be used in multiple places. |

**Return Values**

| isFrame? | GuiElement | instance of loaded view or nil if the definition XML file could not be loaded. |
|----------|------------|--------------------------------------------------------------------------------|

**Code**

```lua
function Gui:loadGui(xmlFilename, name, controller, isFrame)
    local xmlFile = loadXMLFile( "Temp" , xmlFilename)

    local gui = nil
    if xmlFile ~ = nil and xmlFile ~ = 0 or self.currentlyReloading then
        self:loadProfileSet(xmlFile, "GUI.GuiProfiles" , self.presets)

        FocusManager:setGui(name)

        gui = GuiElement.new(controller)
        gui.name = name
        gui.xmlFilename = xmlFilename
        controller.name = name
        controller.xmlFilename = xmlFilename

        gui:loadFromXML(xmlFile, "GUI" )

        -- if the gui has a safe frame, we adjust the size and position of the gui.because other gui elements adjust their size according to their parents upon loading,
            -- other elements should automatically inherit these changes, if not, check those elements anchors
                if g_screenWidth ~ = g_unsafeScreenWidth or g_screenHeight ~ = g_unsafeScreenHeight then
                    gui:setPosition(g_safeFrameScreenOffsetX * g_pixelSizeX, g_safeFrameScreenOffsetY * g_pixelSizeY)
                    gui:setSize(g_screenWidth / g_unsafeScreenWidth, g_screenHeight / g_unsafeScreenHeight, true )
                end

                if isFrame then
                    controller.name = gui.name
                    gui.isFrame = true
                end

                self:loadGuiRec(xmlFile, "GUI" , gui, controller)

                controller:addElement(gui)

                if not isFrame then -- frames must only be scaled as part of screens, do not scale them on loading
                    controller:updateAbsolutePosition()
                end

                controller:exposeControlsAsFields(name)

                controller:onGuiSetupFinished()
                -- call onCreate of configuration root node --> targets onCreate on view
                gui:raiseCallback( "onCreateCallback" , gui, gui.onCreateArgs)

                if isFrame then
                    self:addFrame(controller, gui)
                else
                        self.guis[name] = gui
                        self.nameScreenTypes[name] = controller:class() -- TEMP, until showGui is replaced
                        -- store screen by its class for symbolic access
                            self:addScreen(controller:class(), controller, gui)
                        end

                        delete(xmlFile)
                    else
                            Logging.error( "Could not open gui-config '%s'!" , xmlFilename)
                            controller:delete()
                        end

                        return gui
                    end

```

### loadGuiRec

**Description**

> Recursively load and build a UI configuration.

**Definition**

> loadGuiRec(xmlFile Opened, xmlNodePath Current, parentGuiElement Current, target Target)

**Arguments**

| xmlFile          | Opened  | GUI configuration XML file     |
|------------------|---------|--------------------------------|
| xmlNodePath      | Current | XML node path                  |
| parentGuiElement | Current | parent GuiElement              |
| target           | Target  | of newly instantiated elements |

**Code**

```lua
function Gui:loadGuiRec(xmlFile, xmlNodePath, parentGuiElement, target)
    local numElements = getXMLNumOfChildren(xmlFile, xmlNodePath)

    for index = 0 , numElements - 1 do
        local typeName = getXMLElementName(xmlFile, string.format( "%s.*(%i)" , xmlNodePath, index))
        local currentXmlPath = string.format( "%s.*(%i)" , xmlNodePath, index)

        --we use uppercase names in mappings to avoid problems with camel case
        local upperCaseTypeName = string.upper(typeName)

        if upperCaseTypeName = = Gui.GUI_PROFILE_TYPE_NAME then
            continue
        end

        -- instantiate element and load attribute values
        local newGuiElement
        local elementClass = Gui.CONFIGURATION_CLASS_MAPPING[upperCaseTypeName]
        if elementClass then -- instantiate mapped class
            newGuiElement = elementClass.new(target)
        else
                Logging.xmlWarning(xmlFile, string.format( "Could not find type name %s in registered GUI element classes" , typeName))
                continue
            end
            newGuiElement.typeName = typeName

            parentGuiElement:addElement(newGuiElement)
            newGuiElement:loadFromXML(xmlFile, currentXmlPath)

            -- run any processing resolution functions for specific types:
                local processingFunction = Gui.ELEMENT_PROCESSING_FUNCTIONS[upperCaseTypeName]
                if processingFunction then
                    newGuiElement = processingFunction( self , newGuiElement)
                end

                -- recurse on children
                self:loadGuiRec(xmlFile, currentXmlPath, newGuiElement, target)

                -- raise callback after all child nodes have been processed
                newGuiElement:raiseCallback( "onCreateCallback" , newGuiElement, newGuiElement.onCreateArgs)
            end
        end

```

### loadMapData

**Description**

> Let the GUI (and its components) process map data when it's loaded.

**Definition**

> loadMapData(integer mapXmlFile, , )

**Arguments**

| integer | mapXmlFile    | Map configuration XML file handle, do not close, will be handled by caller. |
|---------|---------------|-----------------------------------------------------------------------------|
| any     | missionInfo   |                                                                             |
| any     | baseDirectory |                                                                             |

**Code**

```lua
function Gui:loadMapData(mapXmlFile, missionInfo, baseDirectory)
    if not Platform.isMobile then
        self.screenControllers[ShopConfigScreen]:loadMapData(mapXmlFile, missionInfo, baseDirectory)
        self.screenControllers[LicensePlateDialog]:loadMapData(mapXmlFile, missionInfo, baseDirectory)
        self.screenControllers[ ColorPickerDialog ]:loadMapData(mapXmlFile, missionInfo, baseDirectory)
    end

    if Platform.hasWardrobe then
        self.screenControllers[ WardrobeScreen ]:loadMapData(mapXmlFile, missionInfo, baseDirectory)
    end

    --TODO change to for loop an check if loadMapData func exists for controller in next major release.Cannot be changed now as it would break mods
    end

```

### loadPresets

**Description**

**Definition**

> loadPresets()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | rootKey |

**Code**

```lua
function Gui:loadPresets(xmlFile, rootKey)
    local presets = { }

    local i = 0
    while true do
        local key = string.format( "%s.Preset(%d)" , rootKey, i)
        if not hasXMLProperty(xmlFile, key) then
            break
        end

        local name = getXMLString(xmlFile, key .. "#name" )
        local value = getXMLString(xmlFile, key .. "#value" )
        if name ~ = nil and value ~ = nil then
            if value:startsWith( "$preset_" ) then
                local preset = string.gsub(value, "$preset_" , "" )
                if presets[preset] ~ = nil then
                    value = presets[preset]
                else
                        Logging.devWarning( "Preset '%s' is not defined in Preset!" , preset)
                    end
                end

                if self.presets[name] = = nil or self.currentlyReloading then
                    presets[name] = value
                    self.presets[name] = value
                else
                        Logging.xmlDevError(xmlFile, "GUI-Preset name '%s' already defined!" , name)
                    end
                end

                i = i + 1
            end

            return presets
        end

```

### loadProfiles

**Description**

> Load UI profile data from XML.

**Definition**

> loadProfiles(xmlFilename UI)

**Arguments**

| xmlFilename | UI | profiles definition XML file path, relative to application root. |
|-------------|----|------------------------------------------------------------------|

**Code**

```lua
function Gui:loadProfiles(xmlFilename)
    local xmlFile = loadXMLFile( "Temp" , xmlFilename)

    if xmlFile ~ = nil and xmlFile ~ = 0 then
        self:loadPresets(xmlFile, "GuiProfiles.Presets" )
        self:loadTraits(xmlFile, "GuiProfiles.Traits" , self.presets)
        self:loadProfileSet(xmlFile, "GuiProfiles" , self.presets)

        local i = 0
        while true do
            local key = string.format( "GuiProfiles.Category(%d)" , i)
            if not hasXMLProperty(xmlFile, key) then
                break
            end

            local categoryName = getXMLString(xmlFile, key .. "#name" )

            self:loadProfileSet(xmlFile, key, self.presets, categoryName)

            i = i + 1
        end

        delete(xmlFile)

        return true
    end

    Logging.error( "Could not open guiProfile-config '%s'!" , xmlFilename)

    return false
end

```

### loadProfileSet

**Description**

**Definition**

> loadProfileSet()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | rootKey      |
| any | presets      |
| any | categoryName |

**Code**

```lua
function Gui:loadProfileSet(xmlFile, rootKey, presets, categoryName)
    local i = 0
    while true do
        local profile = GuiProfile.new( self.profiles, self.traits)
        local key = rootKey .. ".Profile(" .. i .. ")"
        if not hasXMLProperty(xmlFile, key) then
            break
        end

        profile:loadFromXML(xmlFile, key, presets, false )

        if self.profiles[profile.name] = = nil or self.currentlyReloading then
            profile.category = categoryName -- for debugging
                self.profiles[profile.name] = profile

                -- Load variants
                local j = 0
                while true do
                    local k = rootKey .. ".Profile(" .. i .. ").Variant(" .. j .. ")"
                    if not hasXMLProperty(xmlFile, k) then
                        break
                    end

                    local variantName = getXMLString(xmlFile, k .. "#name" )
                    if variantName ~ = nil then
                        local variantProfile = GuiProfile.new( self.profiles, self.traits)
                        if not hasXMLProperty(xmlFile, k) then
                            break
                        end

                        variantProfile:loadFromXML(xmlFile, k, presets, false , true )

                        if variantProfile.parent = = nil then
                            variantProfile.parent = profile.name
                        end

                        variantProfile.category = categoryName
                        variantProfile.name = variantName .. "_" .. profile.name

                        if self.profiles[variantProfile.name] = = nil or self.currentlyReloading then
                            self.profiles[variantProfile.name] = variantProfile
                        else
                                Logging.xmlDevError(xmlFile, "GUI-Profile name '%s' already defined!" , variantProfile.name)
                            end
                        end

                        j = j + 1
                    end
                else
                        Logging.xmlDevError(xmlFile, "GUI-Profile name '%s' already defined!" , profile.name)
                    end

                    i = i + 1
                end
            end

```

### loadTraits

**Description**

**Definition**

> loadTraits()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | rootKey |
| any | presets |

**Code**

```lua
function Gui:loadTraits(xmlFile, rootKey, presets)
    local i = 0
    while true do
        local trait = GuiProfile.new( self.profiles, self.traits)
        local key = rootKey .. ".Trait(" .. i .. ")"
        if not hasXMLProperty(xmlFile, key) then
            break
        end

        trait:loadFromXML(xmlFile, key, presets, true )

        if self.traits[trait.name] = = nil or self.currentlyReloading then
            self.traits[trait.name] = trait
        else
                Logging.xmlDevError(xmlFile, "GUI-Trait name '%s' already defined!" , trait.name)
            end

            i = i + 1
        end
    end

```

### makeChangeScreenClosure

**Description**

> Make a change screen callback function which encloses the Gui self reference.
> This avoids passing the reference around as a parameter or global reference.

**Definition**

> makeChangeScreenClosure()

**Code**

```lua
function Gui:makeChangeScreenClosure()
    return function (source, screenClass, returnScreenClass)
        self:changeScreen(source, screenClass, returnScreenClass)
    end
end

```

### makePlaySampleClosure

**Description**

> Make a play sample function which encloses the Gui self reference.

**Definition**

> makePlaySampleClosure()

**Code**

```lua
function Gui:makePlaySampleClosure()
    return function (sampleName)
        self.guiSoundPlayer:playSample(sampleName)
    end
end

```

### makeToggleCustomInputContextClosure

**Description**

> Make a toggle custom input context function which encloses the Gui self reference.

**Definition**

> makeToggleCustomInputContextClosure()

**Code**

```lua
function Gui:makeToggleCustomInputContextClosure()
    return function (isActive, contextName)
        self:toggleCustomInputContext(isActive, contextName)
    end
end

```

### mouseEvent

**Description**

> GUI mouse event hook.
> This is used primarily for mouse location checks, as button inputs are handled by InputBinding.

**Definition**

> mouseEvent()

**Arguments**

| any | posX   |
|-----|--------|
| any | posY   |
| any | isDown |
| any | isUp   |
| any | button |

**Code**

```lua
function Gui:mouseEvent(posX, posY, isDown, isUp, button)
    local eventUsed = false

    if self.currentListener ~ = nil then
        eventUsed = self.currentListener:mouseEvent(posX, posY, isDown, isUp, button)
    end

    if not eventUsed and self.currentListener ~ = nil and self.currentListener.target ~ = nil then
        if self.currentListener.target.mouseEvent ~ = nil then
            self.currentListener.target:mouseEvent(posX, posY, isDown, isUp, button)
        end
    end
end

```

### new

**Description**

**Definition**

> new()

**Return Values**

| any | self |
|-----|------|

**Code**

```lua
function Gui.new()
    local self = setmetatable( { } , Gui _mt)

    -- input manager reference for event registration
        self.guiSoundPlayer = GuiSoundPlayer.new(g_soundManager)
        FocusManager:setSoundPlayer( self.guiSoundPlayer)

        self.screens = { } -- screen class -> screen root element
        self.screenControllers = { } -- screen class -> screen instance
        self.dialogs = { }
        self.profiles = { }
        self.traits = { }
        self.presets = { }
        self.focusElements = { }
        self.guis = { }
        self.nameScreenTypes = { }
        self.currentGuiName = ""

        self.currentlyReloading = false

        -- registered frame elements which can be referenced to be displayed in multiple places / on multiple screen views
        self.frames = { } -- frame name -> frame controller element

        -- state flag to check if the GUI input context is active(context can be multiple levels deep)
            self.isInputListening = false
            -- stores event IDs of GUI button/key actions(no movement)
            self.actionEventIds = { }
            -- current frame's input target, all inputs of one frame go to this target
            self.frameInputTarget = nil
            -- flag for handling of current frame's input, avoids reacting to multiple events per frame for double bindings(e.g.ESC on PC)
                self.frameInputHandled = false

                self.changeScreenClosure = self:makeChangeScreenClosure()
                self.toggleCustomInputContextClosure = self:makeToggleCustomInputContextClosure()
                self.playSampleClosure = self:makePlaySampleClosure()

                g_adsSystem:clearGroupRegion(AdsSystem.OCCLUSION_GROUP.UI)
                g_adsSystem:addGroupRegion(AdsSystem.OCCLUSION_GROUP.UI, 0 , 0 , 1 , 1 )
                g_adsSystem:setGroupActive(AdsSystem.OCCLUSION_GROUP.UI, false )

                return self
            end

```

### notifyControls

**Description**

> Notify controls of an action input with a value.

**Definition**

> notifyControls(action Action, value Action)

**Arguments**

| action | Action | name as defined by loaded actions, see also scripts/input/InputAction.lua |
|--------|--------|---------------------------------------------------------------------------|
| value  | Action | value [-1, 1]                                                             |

**Return Values**

| value | if | any control has consumed the action event |
|-------|----|-------------------------------------------|

**Code**

```lua
function Gui:notifyControls(action, value)
    local eventUsed = false

    -- Ensure that only one component receives input per frame, otherwise we risk some unwanted input handling chains
    -- when GUI current listeners(or similar) change.
    if self.frameInputTarget = = nil then
        self.frameInputTarget = self.currentListener
    end

    -- check with focus manager if it currently blocks this input
        local locked = FocusManager:isFocusInputLocked(action, value)

        if not locked then
            -- try notifying current listener element or its target(usually either of these is a ScreenElement)
            if not eventUsed and self.frameInputTarget ~ = nil then
                eventUsed = self.frameInputTarget:inputEvent(action, value)
            end

            if not eventUsed and self.frameInputTarget ~ = nil and self.frameInputTarget.target ~ = nil then
                eventUsed = self.frameInputTarget.target:inputEvent(action, value)
            end

            -- send input to the currently focused element if it's active
                local focusedElement = FocusManager:getFocusedElement()
                if not eventUsed and focusedElement ~ = nil and focusedElement:getIsActive() then
                    eventUsed = focusedElement:inputEvent(action, value)
                end

                -- always notify the focus manager, but pass in event usage information
                if not eventUsed then
                    eventUsed = FocusManager:inputEvent(action, value, eventUsed)
                end
            end

            -- lock down input for the current frame if we have reacted on the current input action
                self.frameInputHandled = eventUsed
            end

```

### onMenuInput

**Description**

> Event callback for menu input.

**Definition**

> onMenuInput()

**Arguments**

| any | actionName |
|-----|------------|
| any | inputValue |

**Code**

```lua
function Gui:onMenuInput(actionName, inputValue)
    if not self.frameInputHandled and self.isInputListening then
        self:notifyControls(actionName, inputValue)
    end
end

```

### onReleaseInput

**Description**

> Event callback for released movement menu input.

**Definition**

> onReleaseInput()

**Arguments**

| any | action |
|-----|--------|

**Code**

```lua
function Gui:onReleaseInput(action)
    if not self.frameInputHandled and self.isInputListening then
        -- check with focus manager if it currently blocks this input
            local locked = FocusManager:isFocusInputLocked(action)

            if not locked then
                -- try notifying current listener element or its target(usually either of these is a ScreenElement)
                if self.frameInputTarget ~ = nil then
                    self.frameInputTarget:inputReleaseEvent(action)
                end

                if self.frameInputTarget ~ = nil and self.frameInputTarget.target ~ = nil then
                    self.frameInputTarget.target:inputReleaseEvent(action)
                end

                -- send input to the currently focused element if it's active
                    local focusedElement = FocusManager:getFocusedElement()
                    if focusedElement ~ = nil and focusedElement:getIsActive() then
                        focusedElement:inputReleaseEvent(action)
                    end
                end
            end
        end

```

### onReleaseMovement

**Description**

> Event callback for released movement menu input.

**Definition**

> onReleaseMovement()

**Arguments**

| any | action |
|-----|--------|

**Code**

```lua
function Gui:onReleaseMovement(action)
    self:onReleaseInput(action)

    FocusManager:releaseMovementFocusInput(action)
end

```

### registerGuiElement

**Description**

> Adds a class to the Gui.CONFIGURATION\_CLASS\_MAPPING.

**Definition**

> registerGuiElement(string name, table class)

**Arguments**

| string | name  | name of the class                                 |
|--------|-------|---------------------------------------------------|
| table  | class | table containing all class functions, tables, etc |

**Code**

```lua
function Gui.registerGuiElement(name, class)
    name = string.upper(name)
    Gui.CONFIGURATION_CLASS_MAPPING[name] = class
end

```

### registerGuiElementProcFunction

**Description**

> Adds a class to the Gui.CONFIGURATION\_CLASS\_MAPPING.

**Definition**

> registerGuiElementProcFunction(string name, table class)

**Arguments**

| string | name  | name of the class                                 |
|--------|-------|---------------------------------------------------|
| table  | class | table containing all class functions, tables, etc |

**Code**

```lua
function Gui.registerGuiElementProcFunction(name, procFunction)
    name = string.upper(name)
    Gui.ELEMENT_PROCESSING_FUNCTIONS[name] = procFunction
end

```

### registerMenuInput

**Description**

> Register menu input.

**Definition**

> registerMenuInput()

**Code**

```lua
function Gui:registerMenuInput()
    self.actionEventIds = { }

    -- register the menu input event for all menu navigation actions on button up
        for _, actionName in ipairs( Gui.NAV_ACTIONS) do -- use ipairs to enforce action order
            local _, eventId = g_inputBinding:registerActionEvent(actionName, self , self.onMenuInput, false , true , false , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            if self.actionEventIds[actionName] = = nil then
                self.actionEventIds[actionName] = { }
            end
            table.addElement( self.actionEventIds[actionName], eventId)

            if actionName = = InputAction.MENU_PAGE_PREV or actionName = = InputAction.MENU_PAGE_NEXT then
                -- react to movement input stops("up" state), releases locks on focus manager input:
                _, eventId = g_inputBinding:registerActionEvent(actionName, self , self.onReleaseInput, true , false , false , true )
                g_inputBinding:setActionEventTextVisibility(eventId, false )
                table.addElement( self.actionEventIds[actionName], eventId)
            end
        end

        -- register input events for navigation movement actions for each input change
            for _, actionName in pairs( Gui.NAV_AXES) do
                -- react to any axis value changes:
                local _, eventId = g_inputBinding:registerActionEvent(actionName, self , self.onMenuInput, false , true , true , true )
                g_inputBinding:setActionEventTextVisibility(eventId, false )

                if self.actionEventIds[actionName] = = nil then
                    self.actionEventIds[actionName] = { }
                end
                table.addElement( self.actionEventIds[actionName], eventId)

                -- react to movement input stops("up" state), releases locks on focus manager input:
                _, eventId = g_inputBinding:registerActionEvent(actionName, self , self.onReleaseMovement, true , false , false , true )
                g_inputBinding:setActionEventTextVisibility(eventId, false )
                table.addElement( self.actionEventIds[actionName], eventId)
            end

            self.isInputListening = true
        end

```

### resolveFrameReference

**Description**

> Tries resolving a frame reference.
> If no frame has been loaded with the name given by the reference, then the reference element itself is returned.
> Otherwise, the registered frame is cloned and returned.

**Definition**

> resolveFrameReference(self Gui, frameRefElement FrameReferenceElement)

**Arguments**

| self            | Gui                   | instance            |
|-----------------|-----------------------|---------------------|
| frameRefElement | FrameReferenceElement | instance to resolve |

**Return Values**

| frameRefElement | FrameElement | instance or frameRefElement if resolution failed. |
|-----------------|--------------|---------------------------------------------------|

**Code**

```lua
function Gui:resolveFrameReference(frameRefElement)
    local refName = frameRefElement.referencedFrameName or ""
    local frame = self.frames[refName]

    if frame ~ = nil then
        local frameName = frameRefElement.name or refName
        -- "frame" is the artificial root GuiElement instance holding the frame,
        -- its parent is the controller FrameElement instance which needs to be cloned
        local frameController = frame.parent
        -- clone the controller, including element IDs and suppressing the onCreate callback for all elements
            local frameParent = frameRefElement.parent
            local controllerClone = frameController:clone(frameParent, true , true , true )
            controllerClone.name = frameName
            FocusManager:setGui(frameName) -- set focus data context

            -- re-size and re-orient frame controller and its root to fit the new parent element(required for resolution stability)
                controllerClone.positionOrigin = frameParent.positionOrigin
                controllerClone.screenAlign = frameParent.screenAlign
                controllerClone:setSize( unpack(frameParent.size))
                local cloneRoot = controllerClone:getRootElement()
                cloneRoot.positionOrigin = frameParent.positionOrigin
                cloneRoot.screenAlign = frameParent.screenAlign
                cloneRoot:setSize( unpack(frameParent.size))

                controllerClone:setTarget(controllerClone, frameController, true )

                local frameId = frameRefElement.id
                controllerClone.id = frameId -- swap ID

                if frameRefElement.target then
                    -- swap frame reference field value for clone frame controller
                        frameRefElement.target[frameId] = controllerClone
                    end

                    -- add cloned frame elements to focus system, would not support navigation otherwise
                    FocusManager:loadElementFromCustomValues(controllerClone, nil , nil , false , false )

                    -- safely discard reference element
                    frameRefElement:unlinkElement()
                    frameRefElement:delete()

                    return controllerClone
                else
                        return frameRefElement
                    end
                end

```

### setClient

**Description**

> Set the network client reference for GUI screens.

**Definition**

> setClient()

**Arguments**

| any | client |
|-----|--------|

**Code**

```lua
function Gui:setClient(client)
    for _, controller in pairs( self.screenControllers) do
        if controller.setClient ~ = nil then
            controller:setClient(client)
        end
    end
end

```

### setCurrentMission

**Description**

> Set the current mission reference for GUI screens.

**Definition**

> setCurrentMission()

**Arguments**

| any | currentMission |
|-----|----------------|

**Code**

```lua
function Gui:setCurrentMission(currentMission)
    for _, controller in pairs( self.screenControllers) do
        if controller.setCurrentMission ~ = nil then
            controller:setCurrentMission(currentMission)
        end
    end
end

```

### setServer

**Description**

> Set the network client reference for GUI screens.

**Definition**

> setServer()

**Arguments**

| any | server |
|-----|--------|

**Code**

```lua
function Gui:setServer(server)
    for _, controller in pairs( self.screenControllers) do
        if controller.setServer ~ = nil then
            controller:setServer(server)
        end
    end
end

```

### showDialog

**Description**

> Display a dialog identified by name.

**Definition**

> showDialog()

**Arguments**

| any | guiName        |
|-----|----------------|
| any | closeAllOthers |

**Return Values**

| any | GuiElement | of dialog or nil if the name did not match any known dialog. |
|-----|------------|--------------------------------------------------------------|

**Code**

```lua
function Gui:showDialog(guiName, closeAllOthers)
    local gui = self.guis[guiName]
    self.currentDialogName = guiName
    self.currentDialog = guiName

    if gui ~ = nil then
        if closeAllOthers then
            local list = self.dialogs
            for _,v in ipairs(list) do
                if v ~ = gui then
                    self:closeDialog(v)
                end
            end
        end

        local oldListener = self.currentListener
        if self.currentListener = = gui then
            return gui
        end

        if self.currentListener ~ = nil then
            self.focusElements[ self.currentListener] = FocusManager:getFocusedElement()
        end

        if gui.target.needInput = = nil or gui.target.needInput = = true then
            if not self:getIsGuiVisible() then
                self:enterMenuContext()
            end

            -- set distinct dialog context which can be reverted on dialog closing if we are in menu already
                self:enterMenuContext( Gui.INPUT_CONTEXT_DIALOG .. "_" .. tostring(guiName))
            end

            FocusManager:setGui(guiName)
            table.insert( self.dialogs, gui)
            gui:onOpen()
            self.currentListener = gui

            g_messageCenter:publish(MessageType.GUI_DIALOG_OPENED, guiName, oldListener ~ = nil and oldListener ~ = gui)

            gui.blurAreaActive = false
            if gui.target.getBlurArea ~ = nil then
                local x, y, width, height = gui.target:getBlurArea()
                if x ~ = nil then
                    gui.blurAreaActive = true
                    g_depthOfFieldManager:pushArea(x, y, width, height)
                end
            end
        end

        return gui
    end

```

### showGui

**Description**

> Display and return a screen identified by name.

**Definition**

> showGui()

**Arguments**

| any | guiName |
|-----|---------|

**Return Values**

| any | GuiElement | of screen or nil if the name did not match any known screen. |
|-----|------------|--------------------------------------------------------------|

**Code**

```lua
function Gui:showGui(guiName)
    -- TODO:replace all calls to this with Gui:changeScreen
    if guiName = = nil then
        guiName = ""
    end

    return self:changeScreen( self.guis[ self.currentGui], self.nameScreenTypes[guiName])
end

```

### toggleCustomInputContext

**Description**

> Toggle a custom menu input context for one of the managed frames or screens.

**Definition**

> toggleCustomInputContext()

**Arguments**

| any | isActive    |
|-----|-------------|
| any | contextName |

**Code**

```lua
function Gui:toggleCustomInputContext(isActive, contextName)
    if isActive then
        self:enterMenuContext(contextName)
    else
            self:leaveMenuContext()
        end
    end

```

### touchEvent

**Description**

> GUI touch event hook.
> This is used primarily for touch location checks, as button inputs are handled by InputBinding.

**Definition**

> touchEvent()

**Arguments**

| any | posX    |
|-----|---------|
| any | posY    |
| any | isDown  |
| any | isUp    |
| any | touchId |

**Code**

```lua
function Gui:touchEvent(posX, posY, isDown, isUp, touchId)
    local eventUsed = false

    if self.currentListener ~ = nil and self.currentListener.touchEvent ~ = nil then
        eventUsed = self.currentListener:touchEvent(posX, posY, isDown, isUp, touchId)
    end

    if not eventUsed and self.currentListener ~ = nil and self.currentListener.target ~ = nil then
        if self.currentListener.target.touchEvent ~ = nil then
            self.currentListener.target:touchEvent(posX, posY, isDown, isUp, touchId)
        end
    end
end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function Gui:unloadMapData()
    self.screenControllers[ InGameMenu ]:unloadMapData()
    self.screenControllers[ShopConfigScreen]:unloadMapData()
    self.screenControllers[LicensePlateDialog]:unloadMapData()
    self.screenControllers[ ColorPickerDialog ]:unloadMapData()

    if Platform.hasWardrobe then
        self.screenControllers[ WardrobeScreen ]:unloadMapData()
    end

    --TODO change to for loop an check if unloadMapData func exists for controller in next major release.Cannot be changed now as it would break mods
    end

```

### update

**Description**

> Update the GUI.
> Propagates update to all active UI elements.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Gui:update(dt)
    for _,v in pairs( self.dialogs) do
        -- v:update(dt)
        if v.target ~ = nil then
            v.target:update(dt)
        end
    end

    local currentGui = self.currentGui
    if currentGui ~ = nil then
        if currentGui.target ~ = nil and currentGui.target.preUpdate ~ = nil then
            currentGui.target:preUpdate(dt)
        end

        if currentGui = = self.currentGui then -- self.currentGui can change during update
            -- currentGui:update(dt)
            if currentGui = = self.currentGui then -- self.currentGui can change during update
                if currentGui.target ~ = nil and currentGui.target.update ~ = nil then
                    currentGui.target:update(dt)
                end
            end
        end
    end

    -- reset input fields for next frame
        self.frameInputTarget = nil
        self.frameInputHandled = false
    end

```