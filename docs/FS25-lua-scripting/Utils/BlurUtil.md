## BlurUtil

**Description**

> Helper functions for efficiently blurring data.
> Based off the StackBlur algorithm from Mario Klingemann:
> https://underdestruction.com/2004/02/25/stackblur-2004/

**Functions**

- [iterateStackBlur](#iteratestackblur)
- [recalculateBlurQueueAndSums](#recalculateblurqueueandsums)
- [stackBlurAsync](#stackblurasync)
- [stackBlurColumn](#stackblurcolumn)
- [stackBlurHorizontal](#stackblurhorizontal)
- [stackBlurRow](#stackblurrow)
- [stackBlurVertical](#stackblurvertical)

### iterateStackBlur

**Description**

> Handles a single datum (pixel) of the data, whether vertical or horizontal. This should not be used outside of this
> class.

**Definition**

> iterateStackBlur(function dataGetter, function dataSetter, table queue, integer kernelSize, integer stackSize, integer
> radius, float sum, float inSum, float outSum, integer queueCounter, integer x, integer y)

**Arguments**

| function | dataGetter   | The getter function to use to query the data. function(x, y)      |
|----------|--------------|-------------------------------------------------------------------|
| function | dataSetter   | The setter function to use to set the data. function(x, y, value) |
| table    | queue        | The current queue. This function modifies this table.             |
| integer  | kernelSize   | The size of the kernel. (radius * 2) + 1                          |
| integer  | stackSize    | The size of the stack. radius * (radius + 2) + 1                  |
| integer  | radius       | The radius of the blur.                                           |
| float    | sum          | The current sum.                                                  |
| float    | inSum        | The current incoming sum.                                         |
| float    | outSum       | The current outgoing sum.                                         |
| integer  | queueCounter | the current queueCounter.                                         |
| integer  | x            | The x position.                                                   |
| integer  | y            | The y position.                                                   |

**Return Values**

| integer | sum          | The new sum.           |
|---------|--------------|------------------------|
| integer | inSum        | The new incoming sum.  |
| integer | outSum       | The new outgoing sum.  |
| integer | queueCounter | The new queue counter. |

**Code**

```lua
function BlurUtil.iterateStackBlur(dataGetter, dataSetter, queue, kernelSize, stackSize, radius, sum, inSum, outSum, queueCounter, x, y)

    -- Divide the sum by the stack size to get the average of the sum.
    local averagedValue = sum / stackSize

    -- Set the data at this position to the averaged value.
    dataSetter(x, y, averagedValue)

    -- Set the queue position to use.This is based off the current queue counter and is wrapped to fit into the queue.
    local queuePosition = queueCounter + kernelSize - radius
    if queuePosition > = kernelSize then
        queuePosition = queuePosition - kernelSize
    end

    -- Remove the outgoing sum from the main sum, and remove the soon to be removed queue element from the outgoing sum.
    sum = sum - outSum
    outSum = outSum - queue[queuePosition + 1 ]

    -- Get the data at the current position.
    local currentDatum = dataGetter(x, y)

    -- Add the current datum to the queue and incoming sum, then add the incoming sum to the main sum.
    queue[queuePosition + 1 ] = currentDatum
    inSum = inSum + currentDatum
    sum = sum + inSum

    -- Increment the queue counter, wrapping around to 0.
    queueCounter = queueCounter + 1
    if queueCounter > = kernelSize then
        queueCounter = 0
    end

    -- Remove the element in the queue at the current queue position from the incoming sum, and add it to the outgoing sum.
    outSum = outSum + queue[queueCounter + 1 ]
    inSum = inSum - queue[queueCounter + 1 ]

    -- Return the iteration variables.
    return sum, inSum, outSum, queueCounter
end

```

### recalculateBlurQueueAndSums

**Description**

> Recalculates and returns the sum, incoming sum, and outgoing sum. Also handles initialising the given queue.

**Definition**

> recalculateBlurQueueAndSums(table queue, integer kernelSize, integer radius, float edgeValue)

**Arguments**

| table   | queue      | The current queue. This function modifies this table. |
|---------|------------|-------------------------------------------------------|
| integer | kernelSize | The size of the kernel. (radius * 2) + 1              |
| integer | radius     | The radius of the blur.                               |
| float   | edgeValue  | The value on the very edge of the data.               |

**Return Values**

| float | sum    | The calculated sum.          |
|-------|--------|------------------------------|
| float | inSum  | The calculated incoming sum. |
| float | outSum | The calculated outgoing sum. |

**Code**

```lua
function BlurUtil.recalculateBlurQueueAndSums(queue, kernelSize, radius, edgeValue)

    -- Create the sums.
    local sum = 0
    local inSum = 0
    local outSum = 0

    -- Go over each item in the queue.
    for i = 1 , kernelSize do

        -- The sum is a pyramid shape based on the queue.This means that the element in the middle of the queue is the tallest.
        -- Essentially, the multiplier for the edge value based on the index of the queue(i) looks like this, for a radius of 2:
            -- 1 2 3 2 1
            -- Also add the value to the out/in sum.
            if i < = radius + 1 then
                sum = sum + (edgeValue * i)
                outSum = outSum + edgeValue
            else
                    sum = sum + (edgeValue * ((kernelSize - i) + 1 ))
                    inSum = inSum + edgeValue
                end

                -- Add the value to the queue.
                queue[i] = edgeValue
            end

            -- Return the calculated values.
            return sum, inSum, outSum
        end

```

### stackBlurAsync

**Description**

> Asynchronously blurs the data defined by the given getter and setter. Each row and column are created as separate
> tasks, allowing for the data to be granularly blurred.

**Definition**

> stackBlurAsync(function dataGetter, function dataSetter, integer width, integer height, integer radius,
> AsyncTaskManager? asyncManager, function callback)

**Arguments**

| function          | dataGetter   | The getter function to use to query the data. function(x, y)           |
|-------------------|--------------|------------------------------------------------------------------------|
| function          | dataSetter   | The setter function to use to set the data. function(x, y, value)      |
| integer           | width        | The width of the data.                                                 |
| integer           | height       | The height of the data.                                                |
| integer           | radius       | The radius of the blur.                                                |
| AsyncTaskManager? | asyncManager | The async manager to use, defaulting to g_asyncTaskManager if nil.     |
| function          | callback     | The callback function that fires once the data has been fully blurred. |

**Code**

```lua
function BlurUtil.stackBlurAsync(dataGetter, dataSetter, width, height, radius, asyncManager, callback)

    -- Resolve the task manager.
    asyncManager = asyncManager or g_asyncTaskManager

    -- Add tasks for each row, then each column.
        for y = 1 , height do
            asyncManager:addTask( function ()

                -- Blur the row.
                BlurUtil.stackBlurRow(dataGetter, dataSetter, width, radius, y)
            end )
        end

        for x = 1 , width do
            asyncManager:addTask( function ()

                -- Blur the column.
                BlurUtil.stackBlurColumn(dataGetter, dataSetter, height, radius, x)

                -- If this is the very last column, call the callback function.
                    if x = = width then
                        callback()
                    end
                end )
            end
        end

```

### stackBlurColumn

**Description**

> Blurs a column at the given x position.

**Definition**

> stackBlurColumn(function dataGetter, function dataSetter, integer height, integer radius, integer x, table queue)

**Arguments**

| function | dataGetter | The getter function to use to query the data. function(x, y)      |
|----------|------------|-------------------------------------------------------------------|
| function | dataSetter | The setter function to use to set the data. function(x, y, value) |
| integer  | height     | The height of the data.                                           |
| integer  | radius     | The radius of the blur.                                           |
| integer  | x          | The x position.                                                   |
| table    | queue      | The current queue. If this is nil, one is created.                |

**Code**

```lua
function BlurUtil.stackBlurColumn(dataGetter, dataSetter, height, radius, x, queue)

    -- Calculate the size of the kernel.This is essentially the 2D diameter.
    local kernelSize = (radius * 2 ) + 1

    -- Calculate the stack size.The stack is a pyramid-shaped sum based on the radius.For example, a radius of 2 has a stack size of 9.
    local stackSize = radius * (radius + 2 ) + 1

    -- Resolve the queue, reusing any that was given.
    queue = queue or { }

    -- Recalculate the queue and sums.
    local edgeValue = dataGetter(x, 1 )
    local sum, inSum, outSum = BlurUtil.recalculateBlurQueueAndSums(queue, kernelSize, radius, edgeValue)

    -- Start the queue counter in the centre of the kernel.
    local queueCounter = radius

    -- Define the getter that clamps the y with the radius.
    local safeGetter = function (x, y)
        return dataGetter(x, math.min(y + radius, height))
    end

    -- Go along the height and average the data.
    for y = 1 , height do
        sum, inSum, outSum, queueCounter = BlurUtil.iterateStackBlur(safeGetter, dataSetter, queue, kernelSize, stackSize, radius, sum, inSum, outSum, queueCounter, x, y)
    end
end

```

### stackBlurHorizontal

**Description**

> Blurs the data horizontally.

**Definition**

> stackBlurHorizontal(function dataGetter, function dataSetter, integer width, integer height, integer radius)

**Arguments**

| function | dataGetter | The getter function to use to query the data. function(x, y)      |
|----------|------------|-------------------------------------------------------------------|
| function | dataSetter | The setter function to use to set the data. function(x, y, value) |
| integer  | width      | The width of the data.                                            |
| integer  | height     | The height of the data.                                           |
| integer  | radius     | The radius of the blur.                                           |

**Code**

```lua
function BlurUtil.stackBlurHorizontal(dataGetter, dataSetter, width, height, radius)

    -- Create the queue once.
    local queue = { }

    -- Horizontally blur the data.
    for y = 1 , height do
        BlurUtil.stackBlurRow(dataGetter, dataSetter, width, radius, y, queue)
    end
end

```

### stackBlurRow

**Description**

> Blurs a row at the given y position.

**Definition**

> stackBlurRow(function dataGetter, function dataSetter, integer width, integer radius, integer y, table queue)

**Arguments**

| function | dataGetter | The getter function to use to query the data. function(x, y)      |
|----------|------------|-------------------------------------------------------------------|
| function | dataSetter | The setter function to use to set the data. function(x, y, value) |
| integer  | width      | The width of the data.                                            |
| integer  | radius     | The radius of the blur.                                           |
| integer  | y          | The y position.                                                   |
| table    | queue      | The current queue. If this is nil, one is created.                |

**Code**

```lua
function BlurUtil.stackBlurRow(dataGetter, dataSetter, width, radius, y, queue)

    -- Calculate the size of the kernel.This is essentially the 2D diameter.
    local kernelSize = (radius * 2 ) + 1

    -- Calculate the stack size.The stack is a pyramid-shaped sum based on the radius.For example, a radius of 2 has a stack size of 9.
    local stackSize = radius * (radius + 2 ) + 1

    -- Resolve the queue, reusing any that was given.
    queue = queue or { }

    -- Recalculate the queue and sums.
    local edgeValue = dataGetter( 1 , y)
    local sum, inSum, outSum = BlurUtil.recalculateBlurQueueAndSums(queue, kernelSize, radius, edgeValue)

    -- Start the queue counter in the centre of the kernel.
    local queueCounter = radius

    -- Define the getter that clamps the x with the radius.
    local safeGetter = function (x, y)
        return dataGetter( math.min(x + radius, width), y)
    end

    -- Go along the width and average the data.
    for x = 1 , width do
        sum, inSum, outSum, queueCounter = BlurUtil.iterateStackBlur(safeGetter, dataSetter, queue, kernelSize, stackSize, radius, sum, inSum, outSum, queueCounter, x, y)
    end
end

```

### stackBlurVertical

**Description**

> Blurs the data vertically.

**Definition**

> stackBlurVertical(function dataGetter, function dataSetter, integer width, integer height, integer radius)

**Arguments**

| function | dataGetter | The getter function to use to query the data. function(x, y)      |
|----------|------------|-------------------------------------------------------------------|
| function | dataSetter | The setter function to use to set the data. function(x, y, value) |
| integer  | width      | The width of the data.                                            |
| integer  | height     | The height of the data.                                           |
| integer  | radius     | The radius of the blur.                                           |

**Code**

```lua
function BlurUtil.stackBlurVertical(dataGetter, dataSetter, width, height, radius)

    -- Create the queue once.
    local queue = { }

    -- Vertically blur the data.
    for x = 1 , width do
        BlurUtil.stackBlurColumn(dataGetter, dataSetter, height, radius, x, queue)
    end
end

```