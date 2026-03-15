## PlaySampleMixin

**Description**

> Play UI sound sample mixin.
> Add this mixin to a GuiElement to enable it to play UI sounds.
> Added methods:
> GuiElement:setPlaySampleCallback(callback): Set a callback for playing UI sound samples, signature: function(
> sampleName).
> GuiElement:playSample(index, count): Called by the decorated GuiElement to play a sound sample using a name from
> GuiSoundPlayer.SOUND\_SAMPLES.
> GuiElement:disablePlaySample(): Permanently disables playing samples for special cases (i.e. separate sound logic)

**Parent**

> [GuiMixin](?version=script&category=43&class=485)

**Functions**

- [addTo](#addto)
- [clone](#clone)
- [disablePlaySample](#disableplaysample)
- [new](#new)
- [playSample](#playsample)
- [setPlaySampleCallback](#setplaysamplecallback)

### addTo

**Description**

> See GuiMixin:addTo().

**Definition**

> addTo()

**Arguments**

| any | guiElement |
|-----|------------|

**Code**

```lua
function PlaySampleMixin:addTo(guiElement)
    if PlaySampleMixin:superClass().addTo( self , guiElement) then
        guiElement.setPlaySampleCallback = PlaySampleMixin.setPlaySampleCallback
        guiElement.playSample = PlaySampleMixin.playSample
        guiElement.disablePlaySample = PlaySampleMixin.disablePlaySample

        -- make sure an uninitialized call doesn't blow up by assigning an empty function:
            guiElement[ PlaySampleMixin ].playSampleCallback = NO_CALLBACK

            return true
        else
                return false
            end
        end

```

### clone

**Description**

> Clone this mixin's state from a source to a destination GuiElement instance.

**Definition**

> clone()

**Arguments**

| any | srcGuiElement |
|-----|---------------|
| any | dstGuiElement |

**Code**

```lua
function PlaySampleMixin:clone(srcGuiElement, dstGuiElement)
    dstGuiElement[ PlaySampleMixin ].playSampleCallback = srcGuiElement[ PlaySampleMixin ].playSampleCallback
end

```

### disablePlaySample

**Description**

> Permanently disable playing samples on the decorated GuiElement for special cases.

**Definition**

> disablePlaySample()

**Arguments**

| any | guiElement |
|-----|------------|

**Code**

```lua
function PlaySampleMixin.disablePlaySample(guiElement)
    guiElement[ PlaySampleMixin ].playSampleCallback = NO_CALLBACK
end

```

### new

**Description**

**Definition**

> new()

**Code**

```lua
function PlaySampleMixin.new()
    return GuiMixin.new( PlaySampleMixin _mt, PlaySampleMixin )
end

```

### playSample

**Description**

> Request playing a UI sound sample identified by name.

**Definition**

> playSample(table guiElement, string sampleName)

**Arguments**

| table  | guiElement | GuiElement instance                                   |
|--------|------------|-------------------------------------------------------|
| string | sampleName | Sample name, use one of GuiSoundPlayer.SOUND_SAMPLES. |

**Code**

```lua
function PlaySampleMixin.playSample(guiElement, sampleName)
    if not guiElement.soundDisabled then
        guiElement[ PlaySampleMixin ].playSampleCallback(sampleName)
    end
end

```

### setPlaySampleCallback

**Description**

> Set a callback to play a UI sound sample.

**Definition**

> setPlaySampleCallback(table guiElement, function callback)

**Arguments**

| table    | guiElement | GuiElement instance                                   |
|----------|------------|-------------------------------------------------------|
| function | callback   | Play sample callback, signature: function(sampleName) |

**Code**

```lua
function PlaySampleMixin.setPlaySampleCallback(guiElement, callback)
    guiElement[ PlaySampleMixin ].playSampleCallback = callback
end

```