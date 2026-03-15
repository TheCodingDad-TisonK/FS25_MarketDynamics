### addTerrainFillLayer

**Description**

> Add terrain fill layer to given terrain

**Definition**

> addTerrainFillLayer(entityId terrainId, string name, string diffuseTexture, string normalTexture, string
> heightTexture, string displacementTexture, float layerUnitSize, float displacementMaxHeight, float blendContrast,
> float
> noiseScale, float fillBlendStart, float porosityAtZeroRoughness, float porosityAtFullRoughness, float firmness, float
> viscosity, float firmnessWet)

**Arguments**

| entityId | terrainId               | terrainId                                                                      |
|----------|-------------------------|--------------------------------------------------------------------------------|
| string   | name                    | fill type name                                                                 |
| string   | diffuseTexture          | diffuse texture filename                                                       |
| string   | normalTexture           | normal texture filename                                                        |
| string   | heightTexture           | height texture filename                                                        |
| string   | displacementTexture     | displacement texture filename                                                  |
| float    | layerUnitSize           | size of texture in worldspace (4.0 is typical)                                 |
| float    | displacementMaxHeight   | maximum height (+ or -) for displacement texture, in meters                    |
| float    | blendContrast           | contrast value for blending (0.5 is typical)                                   |
| float    | noiseScale              | noise scale for blending (0.5 is typical)                                      |
| float    | fillBlendStart          | start of fill layer blending (1.0 means no blending, used for most layers)     |
| float    | porosityAtZeroRoughness | porosity when roughness is 0                                                   |
| float    | porosityAtFullRoughness | porosity when roughness is 1                                                   |
| float    | firmness                | firmness of the ground 0-1 (used by tyre tracks to determine max depression)   |
| float    | viscosity               | viscosity of the ground 0-1 (used by tyre tracks to determine rate of sinking) |
| float    | firmnessWet             | firmness of the ground when the terrain is wet 0-1                             |