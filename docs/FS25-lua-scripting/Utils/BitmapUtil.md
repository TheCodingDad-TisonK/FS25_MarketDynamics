## BitmapUtil

**Description**

> Util for bitmap operations

**Functions**

- [writeBitmapToFile](#writebitmaptofile)
- [writeBitmapToFileFromIterator](#writebitmaptofilefromiterator)

### writeBitmapToFile

**Description**

> Saves a table of pixels into a portable anymap (pnm)

**Definition**

> writeBitmapToFile(table pixels, integer width, integer height, string filepath, integer imageFormat)

**Arguments**

| table   | pixels      | table of pixels, each pixel is a table |
|---------|-------------|----------------------------------------|
| integer | width       | image width in pixels                  |
| integer | height      | image height in pixels                 |
| string  | filepath    | filepath for pnm                       |
| integer | imageFormat | image format, one of BitmapUtil.FORMAT |

**Return Values**

| integer | success |
|---------|---------|

**Code**

```lua
function BitmapUtil.writeBitmapToFile(pixels, width, height, filepath, imageFormat)
    local maxBrightness = 255

    local pnmFormat = BitmapUtil.FORMAT_TO_PNM[imageFormat]

    if pnmFormat = = nil then
        Logging.error( "Invalid image format '%s'.Use one of BitmapUtil.FORMAT" , imageFormat)
        return false
    end

    filepath = string.format( "%s.%s" , filepath, pnmFormat.extension or "pnm" )
    local file = createFile(filepath, FileAccess.WRITE)
    if file = = 0 then
        Logging.error( "BitmapUtil.writeBitmapToFile():Unable to create file '%s'" , filepath)
        return false
    end

    -- Portable Anymap(PNM) Header
    fileWrite(file, pnmFormat.getHeader(width, height, maxBrightness))

    local pixelsToWrite = { }
    local concatFunc, clearFunc = table.concat , table.clear

    for pixelIndex = 1 , #pixels do
        pixelsToWrite[#pixelsToWrite + 1 ] = pnmFormat.getPixel(pixels[pixelIndex])
        if pixelIndex % 1025 = = 0 then
            fileWrite(file, concatFunc(pixelsToWrite))
            clearFunc(pixelsToWrite)
        end
    end

    if #pixelsToWrite > 0 then
        fileWrite(file, concatFunc(pixelsToWrite))
    end

    delete(file)

    Logging.info( "Wrote bitmap(width = %d, height = %d) to '%s'" , width, height, filepath)
    return true
end

```

### writeBitmapToFileFromIterator

**Description**

> Saves pixels into a portable anymap (pnm)

**Definition**

> writeBitmapToFileFromIterator(function iterator, integer width, integer height, string filepath, integer imageFormat)

**Arguments**

| function | iterator    | iterator function returning the next pixel |
|----------|-------------|--------------------------------------------|
| integer  | width       | image width in pixels                      |
| integer  | height      | image height in pixels                     |
| string   | filepath    | filepath for pnm                           |
| integer  | imageFormat | image format, one of BitmapUtil.FORMAT     |

**Return Values**

| integer | success |
|---------|---------|

**Code**

```lua
function BitmapUtil.writeBitmapToFileFromIterator(iterator, width, height, filepath, imageFormat)
    local pnmFormat = BitmapUtil.FORMAT_TO_PNM[imageFormat]

    if pnmFormat = = nil then
        Logging.error( "Invalid image format '%s'.Use one of BitmapUtil.FORMAT" , imageFormat)
        return false
    end

    filepath = string.format( "%s.%s" , filepath, pnmFormat.extension or "pnm" )
    local file = createFile(filepath, FileAccess.WRITE)
    if file = = 0 then
        Logging.error( "BitmapUtil.writeBitmapToFileFromIterator():Unable to create file '%s'" , filepath)
        return false
    end

    -- Portable Anymap(PNM) Header
    local maxBrightness = 255
    fileWrite(file, pnmFormat.getHeader(width, height, maxBrightness))

    local pixelsToWrite = { }
    local pixelIndex = 1
    local concatFunc, clearFunc = table.concat , table.clear

    for pixel in iterator() do
        pixelsToWrite[#pixelsToWrite + 1 ] = pnmFormat.getPixel(pixel)

        if pixelIndex % 1025 = = 0 then -- only write to file every 1024 pixels
            fileWrite(file, concatFunc(pixelsToWrite))
            clearFunc(pixelsToWrite)
        end

        pixelIndex = pixelIndex + 1
    end

    if #pixelsToWrite > 0 then
        fileWrite(file, concatFunc(pixelsToWrite))
    end

    delete(file)

    Logging.info( "Wrote bitmap(width = %d, height = %d) to '%s'" , width, height, filepath)
    return true
end

```