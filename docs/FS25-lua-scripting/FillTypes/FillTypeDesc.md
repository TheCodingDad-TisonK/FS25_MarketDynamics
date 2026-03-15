## FillTypeDesc

**Description**

> FillType

**Functions**

- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function FillTypeDesc:loadFromXMLFile(xmlFile, key, baseDirectory, customEnvironment)
    self.name = xmlFile:getValue(key .. "#name" )
    if not ClassUtil.getIsValidIndexName( self.name) then
        Logging.warning( "'%s' is not a valid name for a fillType.Ignoring fillType!" , self.name)
            return false
        else
                self.name = string.upper( self.name)
            end

            self.title = xmlFile:getValue(key .. "#title" , self.title, customEnvironment)
            self.achievementName = xmlFile:getValue(key .. "#achievementName" , self.achievementName)

            self.showOnPriceTable = xmlFile:getValue(key .. "#showOnPriceTable" , self.showOnPriceTable)
            self.unitShort = xmlFile:getValue(key .. "#unitShort" , self.unitShort, customEnvironment)

            self.isBulkType = xmlFile:getValue(key .. "#isBulkType" , false )
            self.isPalletType = xmlFile:getValue(key .. "#isPalletType" , false )
            self.isBaleType = xmlFile:getValue(key .. "#isBaleType" , false )

            self.massPerLiter = xmlFile:getValue(key .. ".physics#massPerLiter" , self.massPerLiter * 1000 ) * 0.001
            self.maxPhysicalSurfaceAngle = Utils.getNoNilRad(xmlFile:getValue(key .. ".physics#maxPhysicalSurfaceAngle" ), self.maxPhysicalSurfaceAngle)

            self.hudOverlayFilename = xmlFile:getValue(key .. ".image#hud" , nil , baseDirectory) or self.hudOverlayFilename
            self.palletFilename = xmlFile:getValue(key .. ".pallet#filename" , nil , baseDirectory) or self.palletFilename

            self.pricePerLiter = xmlFile:getValue(key .. ".economy#pricePerLiter" , self.pricePerLiter)

            local economicCurve = { }
            xmlFile:iterate(key .. ".economy.factors.factor" , function (_, factorKey)
                local period = xmlFile:getValue(factorKey .. "#period" )
                local factor = xmlFile:getValue(factorKey .. "#value" )

                if period ~ = nil and factor ~ = nil then
                    economicCurve[period] = factor
                end
            end )

            for period = SeasonPeriod.EARLY_SPRING, SeasonPeriod.LATE_WINTER do
                self.economy.factors[period] = economicCurve[period] or self.economy.factors[period] or 1
                self.economy.history[period] = self.economy.factors[period] * self.pricePerLiter
            end

            self.layerTextures.diffuseMapFilename = xmlFile:getValue(key .. ".textures#diffuse" , nil , baseDirectory) or self.layerTextures.diffuseMapFilename
            self.layerTextures.normalMapFilename = xmlFile:getValue(key .. ".textures#normal" , nil , baseDirectory) or self.layerTextures.normalMapFilename
            self.layerTextures.heightMapFilename = xmlFile:getValue(key .. ".textures#height" , nil , baseDirectory) or self.layerTextures.heightMapFilename
            self.layerTextures.displacementMapFilename = xmlFile:getValue(key .. ".textures#displacement" , nil , baseDirectory) or self.layerTextures.displacementMapFilename
            self.layerTextures.distanceFilename = xmlFile:getValue(key .. ".textures#distance" , nil , baseDirectory) or self.layerTextures.distanceFilename
            self.layerTextures.isValid = self.layerTextures.diffuseMapFilename ~ = nil and self.layerTextures.normalMapFilename ~ = nil and self.layerTextures.heightMapFilename ~ = nil and self.layerTextures.displacementMapFilename ~ = nil

            self.layerParameters.unitSize = xmlFile:getValue(key .. ".textures#unitSize" , self.layerParameters.unitSize)
            self.layerParameters.displacementMaxHeight = xmlFile:getValue(key .. ".textures#displacementMaxHeight" , self.layerParameters.displacementMaxHeight)
            self.layerParameters.blendContrast = xmlFile:getValue(key .. ".textures#blendContrast" , self.layerParameters.blendContrast)
            self.layerParameters.noiseScale = xmlFile:getValue(key .. ".textures#noiseScale" , self.layerParameters.noiseScale)
            self.layerParameters.fillBlendStart = xmlFile:getValue(key .. ".textures#fillBlendStart" , self.layerParameters.fillBlendStart)
            self.layerParameters.porosityAtZeroRoughness = xmlFile:getValue(key .. ".textures#porosityAtZeroRoughness" , self.layerParameters.porosityAtZeroRoughness)
            self.layerParameters.porosityAtFullRoughness = xmlFile:getValue(key .. ".textures#porosityAtFullRoughness" , self.layerParameters.porosityAtFullRoughness)
            self.layerParameters.firmness = xmlFile:getValue(key .. ".textures#firmness" , self.layerParameters.firmness)
            self.layerParameters.viscosity = xmlFile:getValue(key .. ".textures#viscosity" , self.layerParameters.viscosity)
            self.layerParameters.firmnessWet = xmlFile:getValue(key .. ".textures#firmnessWet" , self.layerParameters.firmness) -- use the firmness as the default

            self.prioritizedEffectType = xmlFile:getValue(key .. ".effects#prioritizedEffectType" , self.prioritizedEffectType)
            self.fillSmokeColor = xmlFile:getValue(key .. ".effects#fillSmokeColor" , self.fillSmokeColor, true )
            self.fruitSmokeColor = xmlFile:getValue(key .. ".effects#fruitSmokeColor" , self.fruitSmokeColor, true )

            for _, particleKey in xmlFile:iterator(key .. ".effects.particle" ) do
                local particle = { }
                particle.particleType = xmlFile:getValue(particleKey .. "#particleType" )
                if particle.particleType ~ = nil then
                    particle.filename = xmlFile:getValue(particleKey .. "#filename" , nil , baseDirectory)
                    if particle.filename ~ = nil then
                        particle.useFillTexture = xmlFile:getValue(particleKey .. "#useFillTexture" , false )
                        particle.emitCountScale = xmlFile:getValue(particleKey .. "#emitCountScale" , 1 )
                        particle.spriteScaleX = xmlFile:getValue(particleKey .. "#spriteScaleX" )
                        particle.spriteScaleY = xmlFile:getValue(particleKey .. "#spriteScaleY" )

                        self.particles[particle.particleType] = particle
                    else
                            Logging.xmlWarning(xmlFile, "Missing filename in '%s'" , particleKey)
                        end

                    else
                            Logging.xmlWarning(xmlFile, "Missing particleType in '%s'" , particleKey)
                        end
                    end

                    self.alphaClip = { }
                    self.alphaClip.value = xmlFile:getValue(key .. ".effects.alphaClip#value" , self.alphaClip.value)
                    self.alphaClip.sharpness = xmlFile:getValue(key .. ".effects.alphaClip#sharpness" , self.alphaClip.sharpness)
                    self.alphaClip.gradientScale = xmlFile:getValue(key .. ".effects.alphaClip#gradientScale" , self.alphaClip.gradientScale)
                    self.alphaClip.alphaScale = xmlFile:getValue(key .. ".effects.alphaClip#alphaScale" , self.alphaClip.alphaScale)
                    self.alphaClip.beltAlphaScale = xmlFile:getValue(key .. ".effects.alphaClip#beltAlphaScale" , self.alphaClip.beltAlphaScale)

                    --#debug -- store the path to the xml file, so we can reload the data(debugging only)
                    --#debug if self.xmlFilename = = nil then
                        --#debug self.xmlFilename = xmlFile.filename
                        --#debug self.xmlKey = key
                        --#debug self.xmlBaseDirectory = baseDirectory
                        --#debug self.xmlCustomEnvironment = customEnvironment
                        --#debug end

                        return true
                    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function FillTypeDesc.new(customMt)
    local self = setmetatable( { } , customMt or FillTypeDesc _mt)

    self.index = nil -- set by FillTypeManager

    self.name = "UNKNOWN"
    self.title = "Unknown"

    self.unitShort = ""

    self.achievementName = nil
    self.showOnPriceTable = false

    self.pricePerLiter = 0
    self.massPerLiter = 0.001

    self.maxPhysicalSurfaceAngle = math.rad( 30 )

    self.hudOverlayFilename = nil

    self.textureArrayIndex = nil

    self.layerTextures = { }
    self.layerTextures.diffuseMapFilename = nil
    self.layerTextures.normalMapFilename = nil
    self.layerTextures.heightMapFilename = nil
    self.layerTextures.displacementMapFilename = nil
    self.layerTextures.distanceFilename = nil
    self.layerTextures.isValid = false

    self.layerParameters = { }
    self.layerParameters.unitSize = 4
    self.layerParameters.displacementMaxHeight = 0.2
    self.layerParameters.blendContrast = 0.5
    self.layerParameters.noiseScale = 0.5
    self.layerParameters.fillBlendStart = 1.0
    self.layerParameters.porosityAtZeroRoughness = 0
    self.layerParameters.porosityAtFullRoughness = 0
    self.layerParameters.firmness = 0.5
    self.layerParameters.viscosity = 0.5
    self.layerParameters.firmnessWet = 0.5

    self.hudFilename = nil
    self.palletFilename = nil

    self.previousHourPrice = 0
    self.startPricePerLiter = 0
    self.totalAmount = 0

    self.economy = { }
    self.economy.factors = { }
    self.economy.history = { }
    self.economy.sychronizeData = true

    self.prioritizedEffectType = "ShaderPlaneEffect"
    self.fillSmokeColor = nil
    self.fruitSmokeColor = nil
    self.particles = { }

    self.alphaClip = { }
    self.alphaClip.value = 0.5
    self.alphaClip.sharpness = 0.5
    self.alphaClip.gradientScale = 1.0
    self.alphaClip.alphaScale = 1.0
    self.alphaClip.beltAlphaScale = 1.0

    self.finalized = false

    return self
end

```