## NoteManager

**Description**

> This class handles creating and exporting note nodes at runtime

**Parent**

> [AbstractManager](?version=script&category=21&class=216)

**Functions**

- [initDataStructures](#initdatastructures)

### initDataStructures

**Description**

**Definition**

> initDataStructures()

**Code**

```lua
function NoteManager:initDataStructures()
    self.sessionDirectory = nil
    self.sessionTimestamp = nil
    self.mapTitle = nil
    self.currentNoteIndex = 1

    local colorWhite = { 1 , 1 , 1 , 1 }
    self.colors = { }
    table.insert( self.colors, { color = colorWhite } )
    for _, color in ipairs( DebugUtil.COLORS) do
        table.insert( self.colors, { color = { color[ 1 ], color[ 2 ], color[ 3 ], 1 } } )
    end
    self.lastColor = colorWhite

    if not self.initialized then
        addConsoleCommand( "gsNoteExport" , "Exports currently created note nodes as i3d file" , "consoleCommandExportNotes" , self )
        addConsoleCommand( "gsNoteList" , "Lists currently created note nodes in console/log" , "consoleCommandListNotes" , self )
        self.initialized = true
    end
end

```