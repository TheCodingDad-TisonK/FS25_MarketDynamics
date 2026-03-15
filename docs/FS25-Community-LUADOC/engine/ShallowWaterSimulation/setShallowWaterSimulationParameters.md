### setShallowWaterSimulationParameters

**Description**

> Sets various simulation parameters of the shallow water simulation

**Definition**

> setShallowWaterSimulationParameters(entityId shallowWaterSimulation, float deltaTime, float externalAcceleration,
> float velocityDampening)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                                                                                                                                                                  |
|----------|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| float    | deltaTime              | time step size for each iteration                                                                                                                                                                                   |
| float    | externalAcceleration   | external downwards accelerations (mostly gravity)                                                                                                                                                                   |
| float    | velocityDampening      | artificial dampening factor between 0 and 1 (default: 1.0) that slows down velocities over time and causes the water to calm. even high values (e.g. 0.999) will significantly reduce how turbulent the water looks |