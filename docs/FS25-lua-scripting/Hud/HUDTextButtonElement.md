## HUDTextButtonElement

**Description**

> A simple text button that can be used in the HUD. Use left-alt to release the mouse.

**Functions**

- [setText](#settext)

### setText

**Description**

> Set the text to display.

**Definition**

> setText(string text, float textSize, integer textAlignment, table textColor, boolean textBool)

**Arguments**

| string  | text          | Display text.                                   |              |               |
|---------|---------------|-------------------------------------------------|--------------|---------------|
| float   | textSize      | Text size in reference resolution pixels.       |              |               |
| integer | textAlignment | Text alignment as one of RenderText.[ALIGN_LEFT | ALIGN_CENTER | ALIGN_RIGHT]. |
| table   | textColor     | Text display color as an array {r, g, b, a}.    |              |               |
| boolean | textBool      | If true, will render the text in bold.          |              |               |

**Code**

```lua
function HUDTextButtonElement:setText(text, textSize, textAlignment, textColor, textBold)
    self.textDisplay:setText(text, textSize, textAlignment, textColor, textBold)
end

```