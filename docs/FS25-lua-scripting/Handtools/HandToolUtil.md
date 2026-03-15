## HandToolUtil

**Description**

> Util class for hand tools and anything relating to them.

**Functions**

- [addHandToolHolderTarget](#addhandtoolholdertarget)
- [linkAndTransformRelativeToParent](#linkandtransformrelativetoparent)

### addHandToolHolderTarget

**Description**

> Adds the default hand tool holder target, which allows a hand tool to target hand tool holders for taking and storing
> hand tools.

**Definition**

> addHandToolHolderTarget(PlayerTargeter playerTargeter, float? minDistance, float? maxDistance)

**Arguments**

| PlayerTargeter | playerTargeter | The player targeter to add to.                                         |
|----------------|----------------|------------------------------------------------------------------------|
| float?         | minDistance    | The optional minimum distance that a hand tool holder can be targeted. |
| float?         | maxDistance    | The optional maximum distance that a hand tool holder can be targeted. |

**Code**

```lua
function HandToolUtil.addHandToolHolderTarget(playerTargeter, minDistance, maxDistance)

    -- Default the distances.
    minDistance = minDistance or HandToolUtil.HOLDER_DEFAULT_MINIMUM_DISTANCE
    maxDistance = maxDistance or HandToolUtil.HOLDER_DEFAULT_MAXIMUM_DISTANCE

    -- Add the click box target and filter based on hand tool targeters.
    playerTargeter:addTargetType( HandToolHolder , HandToolUtil.CLICK_BOX_TARGET_MASK, minDistance, maxDistance)
    playerTargeter:addFilterToTargetType( HandToolHolder , function (hitNode, x, y, z)
        return hitNode ~ = nil and hitNode ~ = 0 and g_currentMission.handToolSystem:getHandToolHolderByClickBox(hitNode) ~ = nil
    end )
end

```

### linkAndTransformRelativeToParent

**Description**

> Links rootNode to be a child of parentNode, then transforms the root node so that the child node and parent node have
> the same translation and rotation.

**Definition**

> linkAndTransformRelativeToParent(integer rootNode, integer childNode, integer parentNode)

**Arguments**

| integer | rootNode   | The root node whose position and rotation are changed, and who will be made a child of parentNode.                                  |
|---------|------------|-------------------------------------------------------------------------------------------------------------------------------------|
| integer | childNode  | The node whose transform is used to transform the root node.                                                                        |
| integer | parentNode | The node whose orientation and translation will be used to match the given childNode. This node is not moved or rotated in any way. |

**Code**

```lua
function HandToolUtil.linkAndTransformRelativeToParent(rootNode, childNode, parentNode)

    -- Link the root node to the parent node.
    link(parentNode, rootNode)

    HandToolUtil.transformRelativeToParent(rootNode, childNode, parentNode)
end

```