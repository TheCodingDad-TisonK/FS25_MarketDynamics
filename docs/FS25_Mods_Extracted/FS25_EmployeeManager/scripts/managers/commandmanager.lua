CommandManager = {}
local CommandManager_mt = Class(CommandManager)

function CommandManager:new()
    local self = setmetatable({}, CommandManager_mt)
    self.commands = {}
    return self
end

---Registers a command and stores metadata for help
---@param name string Command name (e.g. "emStatus")
---@param description string Brief description
---@param usage string Usage example (e.g. "emStatus <id>")
---@param funcName string Name of function on target (e.g. "consoleStatus")
---@param target table The object instance (self)
function CommandManager:add(name, description, usage, funcName, target)
    if self.commands[name] then
        CustomUtils:debug("[CommandManager] Command '%s' already registered, updating...", name)
    end

    self.commands[name] = {
        description = description,
        usage = usage
    }

    addConsoleCommand(name, description, funcName, target)
    CustomUtils:debug("[CommandManager] Registered command: %s", name)
end

function CommandManager:consoleHelp()
    print("--- Advanced Employee Manager Commands ---")
    
    local sortedNames = {}
    for name in pairs(self.commands) do
        table.insert(sortedNames, name)
    end
    table.sort(sortedNames)

    for _, name in ipairs(sortedNames) do
        local cmd = self.commands[name]
        print(string.format(" %s", name))
        print(string.format("   %s", cmd.description))
        if cmd.usage then
            print(string.format("   Usage: %s", cmd.usage))
        end
        print("")
    end
    return "End of help."
end

g_commandManager = CommandManager:new()

g_commandManager:add("emHelp", "Lists all available Employee Manager commands", "emHelp", "consoleHelp", g_commandManager)
