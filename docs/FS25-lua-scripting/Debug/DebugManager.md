## DebugManager

**Description**

> This class handles debug element rendering

**Parent**

> [AbstractManager](?version=script&category=21&class=205)

**Functions**

- [consoleCommandRemoveElements](#consolecommandremoveelements)
- [consoleCommandSplineToggleDebug](#consolecommandsplinetoggledebug)
- [drawPostUI](#drawpostui)
- [drawPreUI](#drawpreui)
- [initDataStructures](#initdatastructures)
- [unloadMapData](#unloadmapdata)

### consoleCommandRemoveElements

**Description**

**Definition**

> consoleCommandRemoveElements()

**Return Values**

| any | status |
|-----|--------|

**Code**

```lua
function DebugManager:consoleCommandRemoveElements()
    for element in pairs( self.elementToElementId) do
        if element.delete ~ = nil then
            element:delete()
        end
    end

    self.elementIdToElement = { }
    self.elementToElementId = { }
    self.groupIdToElements = { }
    self.elementsWithLifetime = { }

    return "Cleared all debug elements"
end

```

### consoleCommandSplineToggleDebug

**Description**

> traverses whole scene and toggles debug visualization for all splines

**Definition**

> consoleCommandSplineToggleDebug(string displayEPsStr)

**Arguments**

| string | displayEPsStr |
|--------|---------------|

**Return Values**

| string | status |
|--------|--------|

**Code**

```lua
function DebugManager:consoleCommandSplineToggleDebug(displayEPsStr)
    self.splineDebugEnabled = not self.splineDebugEnabled

    if self.splineDebugEnabled then
        local displayEPs = Utils.stringToBoolean(displayEPsStr)

        local debugMat = self:getDebugMat()

        local numAffectedNodes = 0

        local function checkNode(node)
            if I3DUtil.getIsSpline(node) then

                DebugUtil.setNodeEffectivelyVisible(node)
                local color = DebugUtil.getDebugColor(node)
                local r, g, b = color:unpack()
                setMaterial(node, debugMat, 0 )
                setShaderParameter(node, "color" , r, g, b, 0 , false )
                setShaderParameter(node, "alpha" , 1 , 0 , 0 , 0 , false )

                local debugSpline = DebugSpline.new()
                debugSpline:createWithNode(node, nil , nil , displayEPs):setColorRGBA(r,g,b):setClipDistance( 500 )
                g_debugManager:addElement(debugSpline, "splineDebug" )

                numAffectedNodes = numAffectedNodes + 1
            end
        end

        I3DUtil.iterateRecursively(getRootNode(), checkNode)
        return string.format( "Added debug visualization to %d splines" , numAffectedNodes)
    else
            g_debugManager:removeGroup( "splineDebug" )

            return string.format( "Removed spline debug elements" )
        end
    end

```

### drawPostUI

**Description**

**Definition**

> drawPostUI()

**Code**

```lua
function DebugManager:drawPostUI()
    -- draw drawables after UI so they can render things ontop
    for _, drawable in pairs( self.drawables) do
        drawable:drawDebug()
    end
end

```

### drawPreUI

**Description**

**Definition**

> drawPreUI()

**Code**

```lua
function DebugManager:drawPreUI()
    -- draw elements pre UI as they are usually in 3D space
    for groupId, groupElements in pairs( self.groupIdToElements) do
        if self.hiddenGroups[groupId] = = nil then
            for _, element in ipairs(groupElements) do
                if element.draw ~ = nil and(element.getShouldBeDrawn = = nil or element:getShouldBeDrawn()) then
                    element:draw()
                end
            end
        end
    end

    for i = # self.frameElements, 1 , - 1 do
        self.frameElements[i]:draw()
        table.remove( self.frameElements, i)
    end
end

```

### initDataStructures

**Description**

**Definition**

> initDataStructures()

**Code**

```lua
function DebugManager:initDataStructures()
    self.drawables = { }
    self.frameElements = { }

    self.elementIdToElement = { }
    self.elementToElementId = { }
    self.groupIdToElements = { }
    self.elementsWithLifetime = { }
    self.hiddenGroups = { }

    self.debugMaterial = nil
    if self.debugMaterialNode ~ = nil then
        delete( self.debugMaterialNode)
        self.debugMaterialNode = nil
    end

    self.splineDebugEnabled = false
    self.splineDebugElements = { }
    self.occluderDebugEnabled = false

    if not self.initialized then
        addConsoleCommand( "gsDebugManagerClearElements" , "Removes all permanent elements and functions from DebugManager" , "consoleCommandRemoveElements" , self )
        addConsoleCommand( "gsDebugManagerGroupsList" , "List all currently used debug element groups with visibility and number of elements" , "consoleCommandGroupsList" , self )
        addConsoleCommand( "gsDebugManagerGroupVisibilitySet" , "Toggle or set visibility of given group name" , "consoleCommandGroupVisibilitySet" , self , "groupId; [visibility]" )
        addConsoleCommand( "gsDebugManagerGroupRemove" , "Remove group and its debug elements" , "consoleCommandGroupRemove" , self )
        addConsoleCommand( "gsSplineDebug" , "Toggles debug visualization for all splines currently in the scene" , "consoleCommandSplineToggleDebug" , self , "[displayEPs]" )
            addConsoleCommand( "gsTerrainLayerDebug" , "Toggles debug visualization for terrain layers" , "consoleCommandLayerDebug" , self , "visualizeAttributeName" )
                self.initialized = true
            end
        end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function DebugManager:unloadMapData()
    self.loadedMapData = false
    self:initDataStructures()
end

```