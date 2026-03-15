## ConditionalAnimation

**Functions**

- [debugDraw](#debugdraw)
- [delete](#delete)
- [getParameter](#getparameter)
- [load](#load)
- [new](#new)
- [registerParameter](#registerparameter)
- [setParameter](#setparameter)
- [setSpecialParameterIds](#setspecialparameterids)
- [unload](#unload)
- [update](#update)

### debugDraw

**Description**

> Displays the debug information.

**Definition**

> debugDraw(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Return Values**

| float | y | The y position on the screen after the entire debug info was drawn. |
|-------|---|---------------------------------------------------------------------|

### delete

**Description**

**Definition**

> delete()

### getParameter

**Description**

**Definition**

> getParameter()

**Arguments**

| any | parameterId |
|-----|-------------|

### load

**Description**

**Definition**

> load()

**Arguments**

| any | skeletonNode |
|-----|--------------|
| any | xmlFilename  |
| any | xmlKey       |
| any | sourceNode   |

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

### registerParameter

**Description**

**Definition**

> registerParameter()

**Arguments**

| any | name      |
|-----|-----------|
| any | paramType |

### setParameter

**Description**

**Definition**

> setParameter()

**Arguments**

| any | parameterId |
|-----|-------------|
| any | value       |

### setSpecialParameterIds

**Description**

**Definition**

> setSpecialParameterIds()

**Arguments**

| any | distanceParameterId |
|-----|---------------------|
| any | angleParameterId    |

### unload

**Description**

**Definition**

> unload()

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|