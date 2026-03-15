### buildNavMeshFromContour

**Description**

> Build the navigation mesh based on the provided contour

**Definition**

> buildNavMeshFromContour(entityId navMeshId, floatArray contourWorldPositions, entityId terrainNodeId, integer
> collisionMask, float cellSize, float cellHeight, float agentHeight, float agentRadius, float agentMaxClimb, float
> agentMaxSlope, float minRegionSize, float mergeRegionSize, float maxEdgeLength, float maxSimplificationError)

**Arguments**

| entityId   | navMeshId              |                        |
|------------|------------------------|------------------------|
| floatArray | contourWorldPositions  |                        |
| entityId   | terrainNodeId          |                        |
| integer    | collisionMask          |                        |
| float      | cellSize               | cellSize               |
| float      | cellHeight             | cellHeight             |
| float      | agentHeight            | agentHeight            |
| float      | agentRadius            | agentRadius            |
| float      | agentMaxClimb          | agentMaxClimb          |
| float      | agentMaxSlope          | agentMaxSlope          |
| float      | minRegionSize          | minRegionSize          |
| float      | mergeRegionSize        | mergeRegionSize        |
| float      | maxEdgeLength          | maxEdgeLength          |
| float      | maxSimplificationError | maxSimplificationError |

**Return Values**

| boolean | success |
|---------|---------|