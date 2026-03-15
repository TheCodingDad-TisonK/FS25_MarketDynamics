## SplitShapeManager

**Description**

> This class handles all stuff related to split shapes (split types, split shape access)

**Parent**

> [AbstractManager](?version=script&category=58&class=561)

**Functions**

- [addSplitType](#addsplittype)
- [getSplitTypeByIndex](#getsplittypebyindex)
- [getSplitTypeNameByIndex](#getsplittypenamebyindex)
- [initDataStructures](#initdatastructures)
- [loadMapData](#loadmapdata)
- [new](#new)

### addSplitType

**Description**

> Adds a new splitType

**Definition**

> addSplitType(string name, string l10nKey, integer splitTypeIndex, float pricePerLiter, float woodChipsPerLiter,
> boolean allowsWoodHarvester, string? customEnvironment, float? volumeToLiter, )

**Arguments**

| string  | name                       |
|---------|----------------------------|
| string  | l10nKey                    |
| integer | splitTypeIndex             |
| float   | pricePerLiter              |
| float   | woodChipsPerLiter          |
| boolean | allowsWoodHarvester        |
| string? | customEnvironment          |
| float?  | volumeToLiter              |
| any     | woodHarvesterAreaThreshold |

**Code**

```lua
function SplitShapeManager:addSplitType(name, l10nKey, splitTypeIndex, pricePerLiter, woodChipsPerLiter, allowsWoodHarvester, customEnvironment, volumeToLiter, woodHarvesterAreaThreshold)
    if self.typesByIndex[splitTypeIndex] ~ = nil then
        Logging.error( "SplitShapeManager:addSplitType():SplitTypeIndex '%d' is already in use for '%s'" , splitTypeIndex, name)
            return
        end

        name = string.upper(name)
        if self.typesByName[name] ~ = nil then
            Logging.error( "SplitShapeManager:addSplitType():SplitType name '%s' is already in use" , name)
            return
        end

        if type(woodHarvesterAreaThreshold) ~ = "number" then
            woodHarvesterAreaThreshold = nil
        end

        local desc = { }
        desc.name = name
        desc.title = g_i18n:getText(l10nKey, customEnvironment)
        desc.splitTypeIndex = splitTypeIndex
        desc.pricePerLiter = pricePerLiter
        desc.woodChipsPerLiter = woodChipsPerLiter
        desc.allowsWoodHarvester = allowsWoodHarvester
        desc.woodHarvesterAreaThreshold = woodHarvesterAreaThreshold or 4.5
        desc.volumeToLiter = volumeToLiter or 1000

        self.typesByIndex[splitTypeIndex] = desc
        self.typesByName[name] = desc
    end

```

### getSplitTypeByIndex

**Description**

> Returns split type table by given split type index provided by getSplitType()

**Definition**

> getSplitTypeByIndex(integer index)

**Arguments**

| integer | index | splitTypeIndex returned by getSplitType() |
|---------|-------|-------------------------------------------|

**Return Values**

| integer | splitTypeTable |
|---------|----------------|

**Code**

```lua
function SplitShapeManager:getSplitTypeByIndex(index)
    -- check each split type index has a registered split type
    --#debug if index ~ = 0 and self.typesByIndex[index] = = nil then
        --#debug Logging.warning("split type index '%d' has no split type registered", index)
        --#debug end

        return self.typesByIndex[index]
    end

```

### getSplitTypeNameByIndex

**Description**

> Returns split type name by given split type index provided by getSplitType()

**Definition**

> getSplitTypeNameByIndex(integer index)

**Arguments**

| integer | index | splitTypeIndex returned by getSplitType() |
|---------|-------|-------------------------------------------|

**Return Values**

| integer | split | type name |
|---------|-------|-----------|

**Code**

```lua
function SplitShapeManager:getSplitTypeNameByIndex(index)
    -- check each split type index has a registered split type
    --#debug if index ~ = nil and index ~ = 0 and self.typesByIndex[index] = = nil then
        --#debug Logging.warning("split type index '%d' has no split type registered", index)
        --#debug end
        local splitTypeData = self.typesByIndex[index]
        if splitTypeData ~ = nil then
            return splitTypeData.name
        end

        return "<NO_SPLIT_TYPE>"
    end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function SplitShapeManager:initDataStructures()
    self.typesByIndex = { }
    self.typesByName = { }

    self.activeYarders = { }
end

```

### loadMapData

**Description**

> Loads initial manager

**Definition**

> loadMapData()

**Return Values**

| integer | true | if loading was successful else false |
|---------|------|--------------------------------------|

**Code**

```lua
function SplitShapeManager:loadMapData()
    SplitShapeManager:superClass().loadMapData( self )

    self:addSplitType( "SPRUCE" , "treeType_spruce" , 1 , 0.7 , 3.0 , true , nil , 1000 , 6 ) -- density 0.47
    self:addSplitType( "PINE" , "treeType_pine" , 2 , 0.7 , 3.0 , true , nil , 1000 ) -- density 0.52
    self:addSplitType( "LARCH" , "treeType_larch" , 3 , 0.7 , 3.0 , true , nil , 1000 ) -- density 0.59
    self:addSplitType( "BIRCH" , "treeType_birch" , 4 , 0.85 , 3.2 , true , nil , 1000 ) -- density 0.65
    self:addSplitType( "BEECH" , "treeType_beech" , 5 , 0.9 , 3.4 , true , nil , 1000 ) -- density 0.69
    self:addSplitType( "MAPLE" , "treeType_maple" , 6 , 0.9 , 3.4 , true , nil , 1000 ) -- density 0.65
    self:addSplitType( "OAK" , "treeType_oak" , 7 , 0.9 , 3.4 , true , nil , 1000 ) -- density 0.67
    self:addSplitType( "ASH" , "treeType_ash" , 8 , 0.9 , 3.4 , true , nil , 1000 ) -- density 0.69
    self:addSplitType( "LOCUST" , "treeType_locust" , 9 , 1.0 , 3.8 , true , nil , 1000 ) -- density 0.73
    self:addSplitType( "MAHOGANY" , "treeType_mahogany" , 10 , 1.1 , 3.0 , true , nil , 1000 ) -- density 0.80
    self:addSplitType( "POPLAR" , "treeType_poplar" , 11 , 0.7 , 7.5 , true , nil , 1000 ) -- density 0.48
    self:addSplitType( "AMERICANELM" , "treeType_americanElm" , 12 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.57
    self:addSplitType( "CYPRESS" , "treeType_cypress" , 13 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.51
    self:addSplitType( "DOWNYSERVICEBERRY" , "treeType_downyServiceberry" , 14 , 0.7 , 3.5 , false , nil , 1000 ) -- density 0.63
    self:addSplitType( "PAGODADOGWOOD" , "treeType_pagodaDogwood" , 15 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.76
    self:addSplitType( "SHAGBARKHICKORY" , "treeType_shagbarkHickory" , 16 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.75
    self:addSplitType( "STONEPINE" , "treeType_stonePine" , 17 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.51
    self:addSplitType( "WILLOW" , "treeType_willow" , 18 , 0.7 , 3.5 , true , nil , 1000 ) -- density 0.50
    self:addSplitType( "OLIVETREE" , "treeType_oliveTree" , 19 , 0.6 , 3.5 , true , nil , 1000 ) -- density 0.45
    self:addSplitType( "GIANTSEQUOIA" , "treeType_giantSequoia" , 20 , 0.3 , 0.3 , true , nil , 1000 )
    self:addSplitType( "LODGEPOLEPINE" , "treeType_lodgepolePine" , 21 , 1.0 , 3.7 , true , nil , 1000 )
    self:addSplitType( "PONDEROSAPINE" , "treeType_ponderosaPine" , 22 , 1.0 , 3.7 , true , nil , 1000 )
    self:addSplitType( "DEADWOOD" , "treeType_deadwood" , 23 , 0.1 , 0.5 , true , nil , 1000 )
    self:addSplitType( "TRANSPORT" , "treeType_transport" , 24 , 0.1 , 0.3 , true , nil , 10 )
    self:addSplitType( "ASPEN" , "treeType_aspen" , 25 , 1.2 , 3.3 , true , nil , 1000 )
    self:addSplitType( "APPLE" , "treeType_apple" , 26 , 0.8 , 1.2 , false , nil , 1000 )
    self:addSplitType( "BETULAERMANII" , "treeType_betulaErmanii" , 27 , 0.6 , 3.5 , true , nil , 1000 )
    self:addSplitType( "BOXELDER" , "treeType_boxelder" , 28 , 0.9 , 3.4 , true , nil , 1000 )
    self:addSplitType( "CHERRY" , "treeType_cherry" , 29 , 1.0 , 3.8 , false , nil , 1000 )
    self:addSplitType( "CHINESEELM" , "treeType_chineseElm" , 30 , 0.7 , 3.5 , false , nil , 1000 )
    self:addSplitType( "GOLDENRAIN" , "treeType_goldenRain" , 31 , 0.6 , 3.5 , true , nil , 1000 )
    self:addSplitType( "JAPANESEZELKOVA" , "treeType_japaneseZelkova" , 32 , 0.7 , 3.5 , true , nil , 1000 )
    self:addSplitType( "NORTHERNCATALPA" , "treeType_northernCatalpa" , 33 , 0.7 , 3.0 , false , nil , 1000 )
    self:addSplitType( "TILIAAMURENSIS" , "treeType_tiliaAmurensis" , 34 , 0.9 , 3.4 , false , nil , 1000 )
    self:addSplitType( "RAVAGED" , "treeType_ravaged" , 35 , 0.4 , 3.0 , true , nil , 1000 )
    self:addSplitType( "PINUSTABULIFORMIS" , "treeType_pinusTabuliformis" , 36 , 0.9 , 3.5 , true , nil , 1000 )
    self:addSplitType( "PINUSSYLVESTRIS" , "treeType_pinusSylvestris" , 37 , 0.8 , 3.3 , true , nil , 1000 )
    self:addSplitType( "CHESTNUT" , "treeType_chestnut" , 38 , 0.85 , 3.3 , true , nil , 1000 )

    if g_isDevelopmentVersion then
        addConsoleCommand( "gsSplitTypesExport" , "Exports registered split types to xml files" , "exportToXML" , self )
    end

    return true
end

```

### new

**Description**

> Creating manager

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function SplitShapeManager.new(customMt)
    local self = AbstractManager.new(customMt or SplitShapeManager _mt)

    return self
end

```