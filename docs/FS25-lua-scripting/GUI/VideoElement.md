## VideoElement

**Description**

> Plays back a video.

**Parent**

> [GuiElement](?version=script&category=43&class=512)

**Functions**

- [changeVideo](#changevideo)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [disposeVideo](#disposevideo)
- [draw](#draw)
- [getIsActive](#getisactive)
- [keyEvent](#keyevent)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [loadSubtitles](#loadsubtitles)
- [mouseEvent](#mouseevent)
- [new](#new)
- [onEndVideo](#onendvideo)
- [playVideo](#playvideo)
- [stopVideo](#stopvideo)
- [update](#update)

### changeVideo

**Description**

**Definition**

> changeVideo()

**Arguments**

| any | newVideoFilename |
|-----|------------------|
| any | volume           |
| any | duration         |

**Code**

```lua
function VideoElement:changeVideo(newVideoFilename, volume, duration)
    self:disposeVideo()

    self.videoFilename = newVideoFilename
    if self.videoFilename ~ = nil then
        local videoFilename = string.gsub( self.videoFilename, "$l10nSuffix" , g_languageSuffix)
        self.overlay = createVideoOverlay(videoFilename, self.isLooping, volume or self.volume)

        self.duration = duration

        self:loadSubtitles(videoFilename)
    end
end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function VideoElement:copyAttributes(src)
    VideoElement:superClass().copyAttributes( self , src)

    self:changeVideo(src.videoFilename)
    self.volume = src.volume
    self.allowStop = src.allowStop
    self.isLooping = src.isLooping
    self.onEndVideoCallback = src.onEndVideoCallback
    self.subtitles = src.subtitles
    self.subtitleElementId = src.subtitleElementId
    self.playbackBarElementId = src.playbackBarElementId
    self.timeLeftElementId = src.timeLeftElementId
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function VideoElement:delete()
    self:disposeVideo()
    VideoElement:superClass().delete( self )
end

```

### disposeVideo

**Description**

**Definition**

> disposeVideo()

**Code**

```lua
function VideoElement:disposeVideo()
    if self.overlay ~ = nil then
        self:stopVideo()
        delete( self.overlay)
        self.overlay = nil
    end
    if self.subtitlesElement ~ = nil then
        self.subtitlesElement:setText( "" )
    end
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function VideoElement:draw(clipX1, clipY1, clipX2, clipY2)
    if self.overlay ~ = nil then
        if isVideoOverlayReadyToPlay( self.overlay) then
            if isVideoOverlayPlaying( self.overlay) then
                renderOverlay( self.overlay, self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ])
            end
        else
                setTextColor( 1 , 1 , 1 , 1 )
                setTextBold( true )
                setTextAlignment(RenderText.ALIGN_CENTER)
                local textSize = getCorrectTextSize( 0.02 )
                renderText( self.absPosition[ 1 ] + self.size[ 1 ] * 0.5 , self.absPosition[ 2 ] + self.size[ 2 ] * 0.5 , textSize, g_i18n:getText( "ui_loading" ))
                setTextBold( false )
                setTextAlignment(RenderText.ALIGN_LEFT)
            end
        end
        VideoElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
    end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Code**

```lua
function VideoElement:getIsActive()
    return self:getIsVisible()
end

```

### keyEvent

**Description**

**Definition**

> keyEvent()

**Arguments**

| any | unicode   |
|-----|-----------|
| any | sym       |
| any | modifier  |
| any | isDown    |
| any | eventUsed |

**Code**

```lua
function VideoElement:keyEvent(unicode, sym, modifier, isDown, eventUsed)
    if self:getIsActive() then
        VideoElement:superClass().keyEvent( self , unicode, sym, modifier, isDown, eventUsed)

        if isDown then
            if self.overlay ~ = nil then
                self:disposeVideo()
                self:onEndVideo()
            end
        end

        return true
    end

    return eventUsed
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function VideoElement:loadFromXML(xmlFile, key)
    VideoElement:superClass().loadFromXML( self , xmlFile, key)

    self.videoFilename = getXMLString(xmlFile, key .. "#videoFilename" ) or self.videoFilename
    self.volume = getXMLFloat(xmlFile, key .. "#volume" ) or self.volume
    self.allowStop = Utils.getNoNil(getXMLBool(xmlFile, key .. "#allowStop" ), self.allowStop)
    self.isLooping = Utils.getNoNil(getXMLBool(xmlFile, key .. "#isLooping" ), self.isLooping)
    self.subtitleElementId = getXMLString(xmlFile, key .. "#subtitleElementId" ) or self.subtitleElementId
    self.playbackBarElementId = Utils.getNoNil(getXMLString(xmlFile, key .. "#playbackBarElementId" ), self.playbackBarElementId)
    self.timeLeftElementId = Utils.getNoNil(getXMLString(xmlFile, key .. "#timeLeftElementId" ), self.timeLeftElementId)

    self:addCallback(xmlFile, key .. "#onEndVideo" , "onEndVideoCallback" )

    self:changeVideo( self.videoFilename)
end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function VideoElement:loadProfile(profile, applyProfile)
    VideoElement:superClass().loadProfile( self , profile, applyProfile)

    self.videoFilename = profile:getValue( "videoFilename" , self.videoFilename)
    self.volume = profile:getNumber( "volume" , self.volume)
    self.allowStop = profile:getBool( "allowStop" , self.allowStop)
    self.isLooping = profile:getBool( "isLooping" , self.isLooping)
    self.subtitleElementId = profile:getValue( "subtitleElementId" , self.subtitleElementId)
    self.playbackBarElementId = profile:getValue( "playbackBarElementId" , self.playbackBarElementId)
    self.timeLeftElementId = profile:getValue( "timeLeftElementId" , self.timeLeftElementId)
end

```

### loadSubtitles

**Description**

**Definition**

> loadSubtitles()

**Arguments**

| any | filename |
|-----|----------|

**Code**

```lua
function VideoElement:loadSubtitles(filename)
    if filename ~ = nil then
        local cleanName = Utils.getFilenameInfo( self.videoFilename)

        if cleanName ~ = nil then
            local xmlFile = XMLFile.loadIfExists( "Subtitles" , cleanName .. ".xml" )

            if xmlFile ~ = nil then
                self.subtitles = { }

                xmlFile:iterate( "Subtitles.Subtitle" , function (_, key)
                    local subtitle = { }

                    subtitle.startTime = xmlFile:getFloat(key .. "#startTime" )
                    subtitle.endTime = xmlFile:getFloat(key .. "#endTime" )
                    subtitle.text = g_i18n:convertText(xmlFile:getString(key .. "#text" ))

                    if subtitle.startTime ~ = nil and subtitle.endTime ~ = nil and subtitle.text ~ = nil then
                        table.insert( self.subtitles, subtitle)
                    end
                end )
            end
        end
    end
end

```

### mouseEvent

**Description**

**Definition**

> mouseEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | button    |
| any | eventUsed |

**Code**

```lua
function VideoElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        if VideoElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed) then
            eventUsed = true
        end

        if not eventUsed and self.allowStop then
            local ret = true

            if isDown then
                if self.overlay ~ = nil then
                    self:disposeVideo()
                    self:onEndVideo()
                end
            end

            return ret
        end
    end

    return eventUsed
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function VideoElement.new(target, custom_mt)
    local self = VideoElement:superClass().new(target, custom_mt or VideoElement _mt)

    self.videoFilename = nil
    self.allowStop = true
    self.isLooping = false
    self.volume = 1.0
    self.duration = 0

    self.subtitles = { }
    self.subtitlesElement = nil
    self.subtitleElementId = nil
    self.currentSubtitleIndex = 0

    self.playbackBarElement = nil
    self.playbackBarElementId = nil

    self.timeLeftElement = nil
    self.timeLeftElementId = nil

    return self
end

```

### onEndVideo

**Description**

**Definition**

> onEndVideo()

**Code**

```lua
function VideoElement:onEndVideo()
    if self.onEndVideoCallback ~ = nil then
        if self.target ~ = nil then
            self.onEndVideoCallback( self.target)
        else
                self.onEndVideoCallback()
            end
        end
    end

```

### playVideo

**Description**

**Definition**

> playVideo()

**Code**

```lua
function VideoElement:playVideo()
    if self.overlay ~ = nil then
        self.playPending = true
        self.currentSubtitleIndex = 0
    end
end

```

### stopVideo

**Description**

**Definition**

> stopVideo()

**Code**

```lua
function VideoElement:stopVideo()
    self.playPending = false
    if self.overlay ~ = nil and isVideoOverlayPlaying( self.overlay) then
        stopVideoOverlay( self.overlay)
    end
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function VideoElement:update(dt)
    VideoElement:superClass().update( self , dt)

    if self.overlay = = nil then
        return
    end

    if not isVideoOverlayReadyToPlay( self.overlay) then
        return
    end

    if self.playPending then
        playVideoOverlay( self.overlay)
        self.playPending = false
    end

    if isVideoOverlayPlaying( self.overlay) then
        updateVideoOverlay( self.overlay)

        if self.subtitlesElement ~ = nil then
            local videoCurrentTime = getVideoOverlayCurrentTime( self.overlay)
            local currentSubtitle = self.subtitles[ self.currentSubtitleIndex]

            if videoCurrentTime ~ = nil and currentSubtitle ~ = nil and videoCurrentTime > = currentSubtitle.endTime then
                self.subtitlesElement:setText( "" )
            end

            if currentSubtitle = = nil or videoCurrentTime > = currentSubtitle.endTime then
                for index = self.currentSubtitleIndex + 1 , # self.subtitles do
                    local subtitle = self.subtitles[index]

                    if videoCurrentTime > = subtitle.startTime and videoCurrentTime < = subtitle.endTime then
                        self.subtitlesElement:setText(subtitle.text)
                        self.currentSubtitleIndex = index
                        break
                    end
                end
            end
        end

        if self.playbackBarElement ~ = nil then
            local currentTime = getVideoOverlayCurrentTime( self.overlay) or 1
            local playbackTime = math.min(currentTime / self.duration, 1 )

            self.playbackBarElement.absSize[ 1 ] = self.playbackBarElement.size[ 1 ] * playbackTime
        end

        if self.timeLeftElement ~ = nil then
            local currentTime = getVideoOverlayCurrentTime( self.overlay) or 1
            local timeLeft = math.max( 0 , self.duration - currentTime)

            local timeLeftMinutes = math.floor(timeLeft / 60 )
            local timeLeftSeconds = timeLeft % 60

            self.timeLeftElement:setText( string.format( "-%02d:%02d" , timeLeftMinutes, timeLeftSeconds))
        end
    else
            self:disposeVideo()
            self:onEndVideo()
        end
    end

```