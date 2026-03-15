## SowMission

**Parent**

> [AbstractFieldMission](?version=script&category=35&class=412)

**Functions**

- [getPartitionCompletion](#getpartitioncompletion)

### getPartitionCompletion

**Description**

**Definition**

> getPartitionCompletion()

**Arguments**

| any | partitionIndex |
|-----|----------------|

**Code**

```lua
function SowMission:getPartitionCompletion(partitionIndex)
    self:setPartitionRegion(partitionIndex)

    if self.completionModifier ~ = nil then
        local sumPixels, area, totalArea = self.completionModifier:executeGet( self.completionFilter)

        return sumPixels, area, totalArea
    end

    return 0 , 0 , 0
end

```