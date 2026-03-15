## AnimationManager

**Description**

> Manages running animations

**Parent**

> [AbstractManager](?version=script&category=6&class=159)

**Functions**

- [areAnimationsRunning](#areanimationsrunning)
- [deleteAnimations](#deleteanimations)
- [getAnimationClass](#getanimationclass)
- [initDataStructures](#initdatastructures)
- [loadAnimations](#loadanimations)
- [new](#new)
- [registerAnimationClass](#registeranimationclass)
- [registerAnimationNodesXMLPaths](#registeranimationnodesxmlpaths)
- [resetAnimation](#resetanimation)
- [resetAnimations](#resetanimations)
- [setFillType](#setfilltype)
- [setPrevShaderParameter](#setprevshaderparameter)
- [startAnimation](#startanimation)
- [startAnimations](#startanimations)
- [stopAnimation](#stopanimation)
- [stopAnimations](#stopanimations)
- [update](#update)

### areAnimationsRunning

**Description**

**Definition**

> areAnimationsRunning()

**Arguments**

| any | animations |
|-----|------------|

### deleteAnimations

**Description**

**Definition**

> deleteAnimations()

**Arguments**

| any | animations |
|-----|------------|

### getAnimationClass

**Description**

**Definition**

> getAnimationClass()

**Arguments**

| any | className |
|-----|-----------|

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

### loadAnimations

**Description**

**Definition**

> loadAnimations()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | baseName          |
| any | rootNode          |
| any | parent            |
| any | i3dMapping        |
| any | maxUpdateDistance |

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

### registerAnimationClass

**Description**

**Definition**

> registerAnimationClass()

**Arguments**

| any | className      |
|-----|----------------|
| any | animationClass |

### registerAnimationNodesXMLPaths

**Description**

**Definition**

> registerAnimationNodesXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

### resetAnimation

**Description**

**Definition**

> resetAnimation()

**Arguments**

| any | animation |
|-----|-----------|

### resetAnimations

**Description**

**Definition**

> resetAnimations()

**Arguments**

| any | animations |
|-----|------------|

### setFillType

**Description**

**Definition**

> setFillType()

**Arguments**

| any | animations |
|-----|------------|
| any | fillType   |

### setPrevShaderParameter

**Description**

> Set shader parameter including the given prev shader parameter that is set one frame delayed with the same given
> values
> x,y,z,w can be nil to keep the existing values of the parameter

**Definition**

> setPrevShaderParameter(integer node, string parameterName, float? x, float? y, float? z, float? w, boolean shared,
> string parameterNamePrev)

**Arguments**

| integer | node              | node                       |
|---------|-------------------|----------------------------|
| string  | parameterName     | shader parameter name      |
| float?  | x                 | x                          |
| float?  | y                 | y                          |
| float?  | z                 | z                          |
| float?  | w                 | w                          |
| boolean | shared            | shared                     |
| string  | parameterNamePrev | prev shader parameter name |

### startAnimation

**Description**

**Definition**

> startAnimation()

**Arguments**

| any | animation |
|-----|-----------|

### startAnimations

**Description**

**Definition**

> startAnimations()

**Arguments**

| any | animations |
|-----|------------|

### stopAnimation

**Description**

**Definition**

> stopAnimation()

**Arguments**

| any | animation |
|-----|-----------|

### stopAnimations

**Description**

**Definition**

> stopAnimations()

**Arguments**

| any | animations |
|-----|------------|

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|