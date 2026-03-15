## InputBinding

**Description**

> Input binding manager.
> Loads and saves action input bindings and provides action trigger information.
> Methods of note (see the documentation of the actual methods for more detailed descriptions):
> registerActionEvent() Register an event callback for an action (for action values, see InputAction.lua)
> removeActionEvent() Removes a previously registered event. Also see removeActionEventsByTarget().
> setActionEvent...() Group of methods to adjust event states, e.g. activity or input display hint parameters.
> Input event usage scenarios:
> 1. Long lifetime components / much interaction: Register event at creation of a component, modify event in component
     > update method depending on its state, remove event at component destruction
> 2. Short lifetime components / little interaction: Register event when necessary (e.g. when in range of an object),
     > remove again when no interaction is possible anymore
     > Player input settings are loaded from the file "inputBindings.xml" in their profile directory. If the file is not
     > present or corrupted whenever input is loaded, it will be restored from a suitable template. If a binding of a
     locked
     > action is changed directly on the file system, it will be overwritten with its template counterpart on the next
     > loading call to ensure that critical inputs are always available (e.g. menu navigation).

**Functions**

- [setContextEventsActive](#setcontexteventsactive)

### setContextEventsActive

**Description**

> Get a menu action event IDs by its name.
> Modify GUI action events with care, as they are globally defined for an entire session.

**Definition**

> setContextEventsActive()

**Arguments**

| any | contextName |
|-----|-------------|
| any | actionName  |
| any | isActive    |

**Code**

```lua
function InputBinding:setContextEventsActive(contextName, actionName, isActive)
    local context = self.contexts[contextName] or { }
    local action = self.nameActions[actionName]
    local actionEvents = context.actionEvents[action]

    for _, event in ipairs(actionEvents) do
        self:setEventActive(event, isActive)
    end
end

```