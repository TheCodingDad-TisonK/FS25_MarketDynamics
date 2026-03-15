### buildNavMesh

**Description**

> Build the navigation mesh based on the specified world data

**Definition**

> buildNavMesh(entityId navMeshId, entityId worldNode, float cellSize, float cellHeight, float agentHeight, float
> agentRadius, float agentMaxClimb, float agentMaxSlope, float minRegionSize, float mergeRegionSize, float
> maxEdgeLength,
> float maxSimplificationError, integer navMeshBuildMask, entityId terrainDetail, string terrainCullInfoLayer, integer
> terrainCullInfoLayerChannels)

**Arguments**

| entityId | navMeshId                    | navMeshId                                                                                                                                       |
|----------|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| entityId | worldNode                    | node to start recursive search for shapes to generate nav mesh from, navMeshBuildMask on the shape has to match the 'navMeshBuildMask' argument |
| float    | cellSize                     | cellSize                                                                                                                                        |
| float    | cellHeight                   | cellHeight                                                                                                                                      |
| float    | agentHeight                  | agentHeight                                                                                                                                     |
| float    | agentRadius                  | agentRadius                                                                                                                                     |
| float    | agentMaxClimb                | agentMaxClimb                                                                                                                                   |
| float    | agentMaxSlope                | agentMaxSlope                                                                                                                                   |
| float    | minRegionSize                | minRegionSize                                                                                                                                   |
| float    | mergeRegionSize              | mergeRegionSize                                                                                                                                 |
| float    | maxEdgeLength                | maxEdgeLength                                                                                                                                   |
| float    | maxSimplificationError       | maxSimplificationError                                                                                                                          |
| integer  | navMeshBuildMask             | navMeshBuildMask                                                                                                                                |
| entityId | terrainDetail                | terrainDetail                                                                                                                                   |
| string   | terrainCullInfoLayer         | terrainCullInfoLayer                                                                                                                            |
| integer  | terrainCullInfoLayerChannels | terrainCullInfoLayerChannels                                                                                                                    |

**Return Values**

| boolean | success | success |
|---------|---------|---------|