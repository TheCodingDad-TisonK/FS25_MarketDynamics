## ColorPickerDialog

**Description**

> Color Picker Dialog
> Lets the player pick from a set of colors.

**Parent**

> [MessageDialog](?version=script&category=&class=)

**Functions**

- [onHorizontalCursorInput](#onhorizontalcursorinput)
- [onVerticalCursorInput](#onverticalcursorinput)
- [show](#show)

### onHorizontalCursorInput

**Description**

> Event function for horizontal cursor input bound to InputAction.AXIS\_PICK\_COLOR\_LEFTRIGHT.

**Definition**

> onHorizontalCursorInput()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function ColorPickerDialog:onHorizontalCursorInput(_, inputValue)
    self.accumHorizontalInput = self.accumHorizontalInput + inputValue
end

```

### onVerticalCursorInput

**Description**

> Event function for vertical cursor input bound to InputAction.AXIS\_PICK\_COLOR\_UPDOWN.

**Definition**

> onVerticalCursorInput()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function ColorPickerDialog:onVerticalCursorInput(_, inputValue)
    self.accumVerticalInput = self.accumVerticalInput + inputValue
end

```

### show

**Description**

> Opens a color picker dialog, which allows the player to pick from a selection of colors, or create a custom color and
> save some favorites.

**Definition**

> show(function callback, table target, table? args, table colors, integer? defaultColorIndex, string? defaultMaterial,
> table? customColor, boolean? customColorsEnabled, boolean? disableOpenSound, boolean? materialSelectionDisabled)

**Arguments**

| function | callback                  | Callback function                                                                                                                                                           |
|----------|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| table    | target                    | Callback target                                                                                                                                                             |
| table?   | args                      | Callback arguments                                                                                                                                                          |
| table    | colors                    | Table containing all colors, each color contains the linear sRGB value (value range is 0-1) as well as the material name                                                    |
| integer? | defaultColorIndex         | Index of the default color, which will be selected in the list. If nil, the first color will be chosen. The index refers to the index of the color in the material manager. |
| string?  | defaultMaterial           | Name of the default material, currently glossy, metallic and matte materials are supported, see ColorPickerDialog.MATERIAL_TEXTS for the exact names                        |
| table?   | customColor               | Table containing the linear sRGB values and material for a custom color. This parameter sets the color in the custom picker and opens that category instead of the list.    |
| boolean? | customColorsEnabled       | If false, the custom picker and favorites are not shown and only predefined color values can be chosen. Defaults to false                                                   |
| boolean? | disableOpenSound          | If true, no sound is played upon opening the dialog                                                                                                                         |
| boolean? | materialSelectionDisabled | If true, no material can be chosen and glossy material is used as the default                                                                                               |

**Code**

```lua
function ColorPickerDialog.show(callback, target, args, colors, defaultColorIndex, defaultMaterial, customColor, customColorsEnabled, disableOpenSound, materialSelectionDisabled)
    if ColorPickerDialog.INSTANCE ~ = nil then
        local dialog = ColorPickerDialog.INSTANCE

        dialog.dialogColors = colors
        dialog.dialogDefaultColorIndex = defaultColorIndex
        dialog.dialogCustomColor = customColor
        dialog.dialogDefaultMaterial = defaultMaterial

        dialog:setCustomOptionsEnabled(customColorsEnabled, materialSelectionDisabled)
        dialog:setCallback(callback, target, args)
        dialog:setDisableOpenSound(disableOpenSound)

        g_gui:showDialog( "ColorPickerDialog" )
    end
end

```