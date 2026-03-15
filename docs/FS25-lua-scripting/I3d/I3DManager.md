## I3DManager

**Description**

> This class provides tools for loading shared i3d files. Access using g\_i3DManager

**Functions**

- [cancelStreamI3DFile](#cancelstreami3dfile)
- [clearEntireSharedI3DFileCache](#clearentiresharedi3dfilecache)
- [consoleCommandPrintActiveLoadings](#consolecommandprintactiveloadings)
- [consoleCommandSetLoadingDelay](#consolecommandsetloadingdelay)
- [consoleCommandShowCache](#consolecommandshowcache)
- [init](#init)
- [loadI3DFile](#loadi3dfile)
- [loadI3DFileAsync](#loadi3dfileasync)
- [loadSharedI3DFile](#loadsharedi3dfile)
- [loadSharedI3DFileAsync](#loadsharedi3dfileasync)
- [loadSharedI3DFileAsyncFinished](#loadsharedi3dfileasyncfinished)
- [loadSharedI3DFileFinished](#loadsharedi3dfilefinished)
- [new](#new)
- [pinSharedI3DFileInCache](#pinsharedi3dfileincache)
- [releaseSharedI3DFile](#releasesharedi3dfile)
- [setLoadingDelay](#setloadingdelay)
- [unpinSharedI3DFileInCache](#unpinsharedi3dfileincache)

### cancelStreamI3DFile

**Description**

> Cancel an async i3d loading requested initated by loadI3DFileAsync

**Definition**

> cancelStreamI3DFile(integer loadingRequestId)

**Arguments**

| integer | loadingRequestId | load request to cancel |
|---------|------------------|------------------------|

**Code**

```lua
function I3DManager:cancelStreamI3DFile(loadingRequestId)
    if loadingRequestId ~ = nil then
        cancelStreamI3DFile(loadingRequestId)
    else
            Logging.error( "I3DManager:cancelStreamedI3dFile - loadingRequestId is nil" )
            printCallstack()
        end
    end

```

### clearEntireSharedI3DFileCache

**Description**

**Definition**

> clearEntireSharedI3DFileCache(boolean? verbose)

**Arguments**

| boolean? | verbose | print current state of the cache before clearing, default:false |
|----------|---------|-----------------------------------------------------------------|

**Code**

```lua
function I3DManager:clearEntireSharedI3DFileCache(verbose)
    if verbose = = true then
        local numSharedI3ds = getNumOfSharedI3DFiles()
        Logging.devInfo( "I3DManager:Deleting %s shared i3d files" , numSharedI3ds)
        for i = 0 , numSharedI3ds - 1 do
            local filename, numRefs = getSharedI3DFilesData(i)
            Logging.devWarning( " NumRef: %d - File: %s" , numRefs, filename)
        end
    end

    Logging.devInfo( "I3DManager:Deleted shared i3d files" )

    clearEntireSharedI3DFileCache()
end

```

### consoleCommandPrintActiveLoadings

**Description**

**Definition**

> consoleCommandPrintActiveLoadings()

**Code**

```lua
function I3DManager:consoleCommandPrintActiveLoadings()

    print( "Non-Shared loading tasks:" )
    local loadingRequestIds = getAllStreamI3DFileRequestIds()
    if #loadingRequestIds = = 0 then
        print( "none" )
    else
            for k, loadingRequestId in ipairs(loadingRequestIds) do
                local progress, timeSec, filename, callback, target, args = getStreamI3DFileProgressInfo(loadingRequestId)

                local text = string.format( "%03d:Progress: %s | Time %.3fs | File: %s | Callback: %s | Target: %s | Args: %s" , loadingRequestId, progress, timeSec, filename, callback, tostring(target), tostring(args))
                print(text)
            end
        end

        print( "" )
        print( "Shared loading tasks:" )

        local sharedLoadingRequestIds = getAllSharedI3DFileRequestIds()
        if #sharedLoadingRequestIds = = 0 then
            print( "none" )
        else
                for k, sharedLoadingRequestId in ipairs(sharedLoadingRequestIds) do
                    local progress, timeSec, filename, callback, target, args = getSharedI3DFileProgressInfo(sharedLoadingRequestId)

                    local text = string.format( "%03d:Progress: %s | Time %.3fs | File: %s | Callback: %s | Target: %s | Args: %s" , sharedLoadingRequestId, progress, timeSec, filename, callback, tostring(target), tostring(args))
                    print(text)
                end
            end
        end

```

### consoleCommandSetLoadingDelay

**Description**

**Definition**

> consoleCommandSetLoadingDelay(float? minDelaySec, float? maxDelaySec, float? minDelayCachedSec, float?
> maxDelayCachedSec)

**Arguments**

| float? | minDelaySec       |                      |
|--------|-------------------|----------------------|
| float? | maxDelaySec       | default: minDelaySec |
| float? | minDelayCachedSec | default: minDelaySec |
| float? | maxDelayCachedSec | default: maxDelaySec |

**Code**

```lua
function I3DManager:consoleCommandSetLoadingDelay(minDelaySec, maxDelaySec, minDelayCachedSec, maxDelayCachedSec)
    minDelaySec = tonumber(minDelaySec) or 0
    maxDelaySec = tonumber(maxDelaySec) or minDelaySec
    minDelayCachedSec = tonumber(minDelayCachedSec) or minDelaySec
    maxDelayCachedSec = tonumber(maxDelayCachedSec) or maxDelaySec

    self:setLoadingDelay(minDelaySec, maxDelaySec, minDelayCachedSec, maxDelayCachedSec)
end

```

### consoleCommandShowCache

**Description**

**Definition**

> consoleCommandShowCache()

**Code**

```lua
function I3DManager:consoleCommandShowCache()
    I3DManager.showCache = not I3DManager.showCache

    if g_debugManager ~ = nil then
        if I3DManager.showCache then
            g_debugManager:addDrawable( self )
        else
                g_debugManager:removeDrawable( self )
            end
        end

        print( "showCache = " .. tostring( I3DManager.showCache))
    end

```

### init

**Description**

**Definition**

> init()

**Code**

```lua
function I3DManager:init()
    local loadingDelay = tonumber(StartParams.getValue( "i3dLoadingDelay" ))
    if loadingDelay ~ = nil and loadingDelay > 0 then
        CaptionUtil.addText( "- I3D Delay(" .. loadingDelay .. "ms)" )
        self:setLoadingDelay(loadingDelay / 1000 )
    end

    if StartParams.getIsSet( "scriptDebug" ) then
        self:setupDebugLoading()
    end
end

```

### loadI3DFile

**Description**

> Load i3d file synchronously/blocking

**Definition**

> loadI3DFile(string filename, boolean? callOnCreate, boolean? addToPhysics)

**Arguments**

| string   | filename     | filepath of i3d to load |
|----------|--------------|-------------------------|
| boolean? | callOnCreate | default: false          |
| boolean? | addToPhysics | default: false          |

**Return Values**

| boolean? | node | 0 if loading failed |
|----------|------|---------------------|

**Code**

```lua
function I3DManager:loadI3DFile(filename, callOnCreate, addToPhysics)
    callOnCreate = Utils.getNoNil(callOnCreate, false )
    addToPhysics = Utils.getNoNil(addToPhysics, false )

    local node = loadI3DFile(filename, addToPhysics, callOnCreate, I3DManager.VERBOSE_LOADING)

    return node
end

```

### loadI3DFileAsync

**Description**

**Definition**

> loadI3DFileAsync(string filename, boolean? callOnCreate, boolean? addToPhysics, function asyncCallbackFunction, table?
> asyncCallbackObject, any asyncCallbackArguments)

**Arguments**

| string   | filename               |                                                                                                 |
|----------|------------------------|-------------------------------------------------------------------------------------------------|
| boolean? | callOnCreate           | if true "onCreate" script callbacks inside the loaded i3d file will be executed. default: false |
| boolean? | addToPhysics           | if true loaded i3d will be added to physics simulation. default: false                          |
| function | asyncCallbackFunction  | function(, nodeId, failedReason, asyncCallbackArguments)                                        |
| table?   | asyncCallbackObject    | object to run asyncCallbackFunction on                                                          |
| any      | asyncCallbackArguments | optional argument/table to pass into asyncCallbackFunction                                      |

**Return Values**

| any | loadRequestId | loadRequestId for cancelling the i3d loading using cancelStreamI3DFile() |
|-----|---------------|--------------------------------------------------------------------------|

**Code**

```lua
function I3DManager:loadI3DFileAsync(filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
    assert(filename ~ = nil , "I3DManager:loadI3DFileAsync - missing filename" )
    assert(asyncCallbackFunction ~ = nil , "I3DManager:loadI3DFileAsync - missing callback function" )
        assert( type(asyncCallbackFunction) = = "function" , "I3DManager:loadI3DFileAsync - Callback value is not a function" )

            callOnCreate = Utils.getNoNil(callOnCreate, false )
            addToPhysics = Utils.getNoNil(addToPhysics, false )

            local arguments = { }
            arguments.asyncCallbackFunction = asyncCallbackFunction
            arguments.asyncCallbackObject = asyncCallbackObject
            arguments.asyncCallbackArguments = asyncCallbackArguments
            --#profile arguments.asyncCallbackFilename = filename

            local loadRequestId = streamI3DFile(filename, "loadSharedI3DFileFinished" , self , arguments, addToPhysics, callOnCreate, I3DManager.VERBOSE_LOADING)

            return loadRequestId
        end

```

### loadSharedI3DFile

**Description**

> Loads an i3D file. A cache system is used for faster loading

**Definition**

> loadSharedI3DFile(string filename, boolean? callOnCreate, boolean? addToPhysics)

**Arguments**

| string   | filename     | filename                                                        |
|----------|--------------|-----------------------------------------------------------------|
| boolean? | callOnCreate | true if onCreate i3d callbacks should be called, default: false |
| boolean? | addToPhysics | true if collisions should be added to physics, default: false   |

**Return Values**

| boolean? | id                  | i3d rootnode        |
|----------|---------------------|---------------------|
| boolean? | sharedLoadRequestId | sharedLoadRequestId |
| boolean? | failedReason        | loading failed      |

**Code**

```lua
function I3DManager:loadSharedI3DFile(filename, callOnCreate, addToPhysics)
    -- always print all loading texts
    callOnCreate = Utils.getNoNil(callOnCreate, false )
    addToPhysics = Utils.getNoNil(addToPhysics, false )

    local node, sharedLoadRequestId, failedReason = loadSharedI3DFile(filename, addToPhysics, callOnCreate, I3DManager.VERBOSE_LOADING)

    return node, sharedLoadRequestId, failedReason
end

```

### loadSharedI3DFileAsync

**Description**

> Loads an i3D file async. A cache system is used for faster loading

**Definition**

> loadSharedI3DFileAsync(string filename, boolean? callOnCreate, boolean? addToPhysics, function asyncCallbackFunction,
> table asyncCallbackObject, table? asyncCallbackArguments)

**Arguments**

| string   | filename               | filename                                                        |
|----------|------------------------|-----------------------------------------------------------------|
| boolean? | callOnCreate           | true if onCreate i3d callbacks should be called, default: false |
| boolean? | addToPhysics           | true if collisions should be added to physics, default: false   |
| function | asyncCallbackFunction  | a callback function with parameters (node, failedReason, args)  |
| table    | asyncCallbackObject    | callback function target object                                 |
| table?   | asyncCallbackArguments | a list of arguments                                             |

**Return Values**

| table? | sharedLoadRequestId | sharedLoadRequestId |
|--------|---------------------|---------------------|

**Code**

```lua
function I3DManager:loadSharedI3DFileAsync(filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
    assert(filename ~ = nil , "I3DManager:loadSharedI3DFileAsync - missing filename" )
    assert(asyncCallbackFunction ~ = nil , "I3DManager:loadSharedI3DFileAsync - missing callback function" )
        assert( type(asyncCallbackFunction) = = "function" , "I3DManager:loadSharedI3DFileAsync - Callback value is not a function" )

            callOnCreate = Utils.getNoNil(callOnCreate, false )
            addToPhysics = Utils.getNoNil(addToPhysics, false )

            local arguments = {
            asyncCallbackFunction = asyncCallbackFunction,
            asyncCallbackObject = asyncCallbackObject,
            asyncCallbackArguments = asyncCallbackArguments,
            --#profile asyncCallbackFilename = filename
            }

            local sharedLoadRequestId = streamSharedI3DFile(filename, "loadSharedI3DFileAsyncFinished" , self , arguments, addToPhysics, callOnCreate, I3DManager.VERBOSE_LOADING)

            return sharedLoadRequestId
        end

```

### loadSharedI3DFileAsyncFinished

**Description**

> Called once i3d async loading is finished

**Definition**

> loadSharedI3DFileAsyncFinished(integer nodeId, integer failedReason, table arguments)

**Arguments**

| integer | nodeId       | i3d node id           |
|---------|--------------|-----------------------|
| integer | failedReason | fail reason enum type |
| table   | arguments    | a list of arguments   |

**Code**

```lua
function I3DManager:loadSharedI3DFileAsyncFinished(nodeId, failedReason, arguments)
    --#profile RemoteProfiler.zoneBeginN("I3DManager:loadSharedI3DFileAsyncFinished - " .. arguments.asyncCallbackFilename)
    local asyncCallbackFunction = arguments.asyncCallbackFunction
    local asyncCallbackObject = arguments.asyncCallbackObject
    local asyncCallbackArguments = arguments.asyncCallbackArguments

    asyncCallbackFunction(asyncCallbackObject, nodeId, failedReason, asyncCallbackArguments)
    --#profile RemoteProfiler.zoneEnd()
end

```

### loadSharedI3DFileFinished

**Description**

> Callback function for I3DManager:loadI3DFileAsync

**Definition**

> loadSharedI3DFileFinished(integer nodeId, integer failedReason, any arguments)

**Arguments**

| integer | nodeId       |                                 |
|---------|--------------|---------------------------------|
| integer | failedReason | one of LoadI3DFailedReason      |
| any     | arguments    | optional asyncCallbackArguments |

**Code**

```lua
function I3DManager:loadSharedI3DFileFinished(nodeId, failedReason, arguments)
    --#profile RemoteProfiler.zoneBeginN("I3DManager:loadSharedI3DFileFinished - " .. arguments.asyncCallbackFilename)
    local asyncCallbackFunction = arguments.asyncCallbackFunction
    local asyncCallbackObject = arguments.asyncCallbackObject
    local asyncCallbackArguments = arguments.asyncCallbackArguments

    asyncCallbackFunction(asyncCallbackObject, nodeId, failedReason, asyncCallbackArguments)
    --#profile RemoteProfiler.zoneEnd()
end

```

### new

**Description**

> Creating manager

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function I3DManager.new(customMt)
    local self = setmetatable( { } , customMt or I3DManager _mt)

    addConsoleCommand( "gsI3DLoadingDelaySet" , "Sets loading delay for i3d files" , "consoleCommandSetLoadingDelay" , self , "minDelaySec; [maxDelaySec]; [minDelayCachedSec]; [maxDelayCachedSec]" )
        addConsoleCommand( "gsI3DCacheShow" , "Show active i3d cache" , "consoleCommandShowCache" , self )
        addConsoleCommand( "gsI3DPrintActiveLoadings" , "Print active loadings" , "consoleCommandPrintActiveLoadings" , self )

        return self
    end

```

### pinSharedI3DFileInCache

**Description**

> Adds an i3d file to cache

**Definition**

> pinSharedI3DFileInCache(string filename)

**Arguments**

| string | filename | filename |
|--------|----------|----------|

**Code**

```lua
function I3DManager:pinSharedI3DFileInCache(filename)
    if filename ~ = nil then
        if getSharedI3DFileRefCount(filename) < 0 then
            --#debug log("pinSharedI3DFileInCache", filename)
            pinSharedI3DFileInCache(filename, true )
        end
    else
            Logging.error( "I3DManager:pinSharedI3DFileInCache - Filename is nil" )
            printCallstack()
        end
    end

```

### releaseSharedI3DFile

**Description**

> Releases one instance. If ref count <= 0 i3d will be removed from cache

**Definition**

> releaseSharedI3DFile(integer sharedLoadRequestId, boolean? warnIfInvalid)

**Arguments**

| integer  | sharedLoadRequestId | sharedLoadRequestId request id                                              |
|----------|---------------------|-----------------------------------------------------------------------------|
| boolean? | warnIfInvalid       | emit a warning if an invalid sharedLoadRequestId was passed, default: false |

**Code**

```lua
function I3DManager:releaseSharedI3DFile(sharedLoadRequestId, warnIfInvalid)
    if sharedLoadRequestId ~ = nil then
        warnIfInvalid = Utils.getNoNil(warnIfInvalid, false )

        if g_isDevelopmentVersion then
            -- always print warnings for invalid loading request ids in dev mode
                --warnIfInvalid = true
            end

            releaseSharedI3DFile(sharedLoadRequestId, warnIfInvalid)
        else
                Logging.error( "I3DManager:releaseSharedI3DFile - sharedLoadRequestId is nil" )
                printCallstack()
            end
        end

```

### setLoadingDelay

**Description**

> Set artifical minimum and maximum delays for async callbacks for testing purposes

**Definition**

> setLoadingDelay(float? minDelaySeconds, float? maxDelaySeconds, float? minDelayCachedSeconds, float?
> maxDelayCachedSeconds)

**Arguments**

| float? | minDelaySeconds       |                          |
|--------|-----------------------|--------------------------|
| float? | maxDelaySeconds       | default: minDelaySeconds |
| float? | minDelayCachedSeconds | default: minDelaySeconds |
| float? | maxDelayCachedSeconds | default: maxDelaySeconds |

**Code**

```lua
function I3DManager:setLoadingDelay(minDelaySeconds, maxDelaySeconds, minDelayCachedSeconds, maxDelayCachedSeconds)
    minDelaySeconds = minDelaySeconds or 0
    maxDelaySeconds = maxDelaySeconds or minDelaySeconds
    minDelayCachedSeconds = minDelayCachedSeconds or minDelaySeconds
    maxDelayCachedSeconds = maxDelayCachedSeconds or maxDelaySeconds

    setStreamI3DFileDelay(minDelaySeconds, maxDelaySeconds)
    setStreamSharedI3DFileDelay(minDelaySeconds, maxDelaySeconds, minDelayCachedSeconds, maxDelayCachedSeconds)

    Logging.info( "Set new loading delay.MinDelay: %.2fs, MaxDelay: %.2fs, MinDelayCached: %.2fs, MaxDelayCached: %.2fs" , minDelaySeconds, maxDelaySeconds, minDelayCachedSeconds, maxDelayCachedSeconds)
end

```

### unpinSharedI3DFileInCache

**Description**

> Removes an i3d file from cache

**Definition**

> unpinSharedI3DFileInCache(string filename)

**Arguments**

| string | filename | filename |
|--------|----------|----------|

**Code**

```lua
function I3DManager:unpinSharedI3DFileInCache(filename)
    if filename ~ = nil then
        --#debug log("unpinSharedI3DFileInCache", filename)
        unpinSharedI3DFileInCache(filename)
    else
            Logging.error( "I3DManager:unpinSharedI3DFileInCache - filename is nil" )
            printCallstack()
        end
    end

```