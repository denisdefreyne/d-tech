# In-game debugger

The in-game debugger is meant to simple introspection and recreating potentially buggy situations. It has three main features:

1. [**DONE**] Inspecting entity state
1. [**DONE**] Pausing the game and stepping through frames
1. Moving the camera around to inspect non-visible parts

It uses some artwork by [Kenney](http://kenney.nl/assets).

## Using

Using the in-game debugger shoud be as easy as pushing a new debugger gamestate:

```lua
Gamestate.push(Debugger.Gamestate.new(self.arenaSpace.entities))
```

## What about an editor?

The original plan included having an in-game editor as well, but this takes too much work for what it’s worth.

## To do

Some things that are not yet done:

* Selecting and moving entities does not take the camera position into account
