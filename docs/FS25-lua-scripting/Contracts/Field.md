## Field

**Description**

> This class wraps all Field data

**Functions**

- [delete](#delete)
- [load](#load)
- [new](#new)

### delete

**Description**

> Delete field definition object

**Definition**

> delete()

**Code**

```lua
function Field:delete()
    g_messageCenter:unsubscribeAll( self )
end

```

### load

**Description**

> Load Field data from node

**Definition**

> load(integer id)

**Arguments**

| integer | id | ai field node id |
|---------|----|------------------|

**Return Values**

| integer | true | if loading was successful else false |
|---------|------|--------------------------------------|

**Code**

```lua
function Field:load(id)
    self.rootNode = id

    local name = getUserAttribute(id, "name" )
    if not string.isNilOrWhitespace(name) then
        self.name = g_i18n:convertText(name, g_currentMission.loadingMapModName)
    end

    for oldAttribute, newAttribute in pairs( Field.DEPRECATED_USER_ATTRIBUTES) do
        if getUserAttribute(id, oldAttribute) ~ = nil then
            Logging.warning( "User attribute '%s' is not supported anymore for field '%s'.Please use '%s' instead!" , oldAttribute, getName(id), newAttribute)
            end
        end

        local polygonIndex = getUserAttribute(id, "polygonIndex" )
        if polygonIndex = = nil then
            Logging.warning( "No polygonIndex defined for field '%s'!" , getName(id))
                return false
            end

            local polygonPointsRoot = I3DUtil.indexToObject(id, polygonIndex)
            if polygonPointsRoot = = nil then
                Logging.warning( "Could not resolve polygonIndex '%s' for field '%s'!" , polygonIndex, getName(id))
                    return false
                end

                for i = 0 , getNumOfChildren(polygonPointsRoot) - 1 do
                    local polygonPoint = getChildAt(polygonPointsRoot, i)
                    table.insert( self.polygonPoints, polygonPoint)
                end

                self.densityMapPolygon:updateFromNodes( self.polygonPoints)

                local sqm = MathUtil.getPolygon2DSize( self.polygonPoints)
                self.areaHa = sqm / 10000

                self.posX, self.posZ = MathUtil.getPolygonLabel( self.polygonPoints, 1 )

                self.nameIndicator = I3DUtil.indexToObject(id, getUserAttribute(id, "nameIndicatorIndex" )) -- this is where the field number appears on the ingamemap
                self.teleportNode = I3DUtil.indexToObject(id, getUserAttribute(id, "teleportIndicatorIndex" ))

                local angle = getUserAttribute(id, "angle" ) or 0
                local angleRad = math.rad(angle)
                self.angle = FSDensityMapUtil.convertToDensityMapAngle(angleRad, g_currentMission.fieldGroundSystem:getGroundAngleMaxValue())

                self.isMissionAllowed = Utils.getNoNil(getUserAttribute(id, "missionAllowed" ), true )
                self.grassMissionOnly = Utils.getNoNil(getUserAttribute(id, "missionOnlyGrass" ), false )

                return true
            end

```

### new

**Description**

> Create ai field definition object

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | Instance of object |
|-----|----------|--------------------|

**Code**

```lua
function Field.new(customMt)
    local self = setmetatable( { } , customMt or Field _mt)

    self.name = nil
    self.rootNode = nil
    self.densityMapPolygon = DensityMapPolygon.new()
    self.polygonPoints = { }
    self.angle = 0.0
    self.areaHa = 1.0
    self.farmland = nil
    self.currentMission = nil
    self.plannedFruitTypeIndex = FruitType.UNKNOWN
    self.isMissionAllowed = true
    self.grassMissionOnly = false
    self.posX = 0
    self.posZ = 0

    self.fieldState = FieldState.new()

    return self
end

```