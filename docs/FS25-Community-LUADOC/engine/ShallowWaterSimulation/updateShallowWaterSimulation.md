### updateShallowWaterSimulation

**Description**

> Requests the simulation to be updated by the given time amount. The internals automatically take care of running the
> correct number of iterations (based on the delta time set in shallowWaterSimulationSetParameters) per requested
> update.
> It's intended that you just forward the delta time from the script update function here, but you can also scale it to
> simulate fast forward or slow down of the simulation time.

**Definition**

> updateShallowWaterSimulation(entityId shallowWaterSimulation, float simulatedTime)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation |
|----------|------------------------|------------------------------------|
| float    | simulatedTime          | simulated time in seconds.         |