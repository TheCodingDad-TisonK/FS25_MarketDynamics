### buildNavMeshFromShapesAndContour

**Description**

> Build the navigation mesh based on the specified shapes and provided contour

**Definition**

> buildNavMeshFromShapesAndContour(entityId navMeshId, entityId shapesNodeId, integer shapesMask, floatArray
> contourWorldPositions, entityId terrainNodeId, integer collisionMask, float cellSize, float cellHeight, float
> agentHeight, float agentRadius, float agentMaxClimb, float agentMaxSlope, float minRegionSize, float mergeRegionSize,
> float maxEdgeLength, float maxSimplificationError)

**Arguments**

| entityId   | navMeshId              |
|------------|------------------------|
| entityId   | shapesNodeId           |
| integer    | shapesMask             |
| floatArray | contourWorldPositions  |
| entityId   | terrainNodeId          |
| integer    | collisionMask          |
| float      | cellSize               |
| float      | cellHeight             |
| float      | agentHeight            |
| float      | agentRadius            |
| float      | agentMaxClimb          |
| float      | agentMaxSlope          |
| float      | minRegionSize          |
| float      | mergeRegionSize        |
| float      | maxEdgeLength          |
| float      | maxSimplificationError |

**Return Values**

| boolean | success |
|---------|---------|