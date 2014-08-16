# Engine

This directory contains the code for the engine, which hopefully is reusable enough for any future games I might write.

Third-party libraries used:

* [HUMP](http://vrld.github.io/hump/) for gamestate management and signaling
* [HardonCollider](http://vrld.github.io/HardonCollider/) for collision detection (I am sorry for the name)
* [SLAM](https://github.com/vrld/slam) for improved sound handling

## To do

* [**DONE**] Allow multiple sounds to be played at the same time
* Do not hardcode signal constants

## Brainstorming

What follows is a bunch of ideas on how to implement certain aspects of the game or the engine.

### Transparent game states

It is useful to have multiple game states in a stack rendered. For example, a pause state or an in-game menu state could still have the state below it rendered. The topmost state (e.g. pause, menu) should likely draw a full-screen semi-opaque black rectangle so that the underlying game is marked as inactive.

### Camera

Since the game world can extend past the boundaries of the screen, there will need to be a way to determine which portion of the world is being shown. Cameras are ideal for this. They can have position, rotation and scale components.

Having multiple cameras and being able to switch between cameras should be possible. For example:

* Having an editor camera which can move around freely to inspect the world. This camera starts with the same components as the game camera, but it is not the same entity as the game camera.

* Having multiple active cameras for split-screen gameplay.

* Having a window that tracks the selected entity.

Giving each space to optionally have a camera might help here. A split-screen setup would have three spaces, all with the same entities:

1. A space with physics, collision, … systems
2. A space with a renderering system and a camera for player A
3. A space with a renderering system and a camera for player B

The same issue happens for input: inputs come from different places for player A and B.

This setup requires a space to potentially manage two entity collections: a shared one (the game entities themselves) and a private one (input and camera).

A split screen view with multiple inputs is possible with only one space. For this to work, both cameras need to have a viewport defined (a component that is basically a rect in screen coordinates) and the input components are tied to different entities and have different keymaps.

Maybe the in-game editor case can be solved by remembering the initial camera state and restoring the state when exiting the editor. The drawback of this approach is that there is no way to leave the game running in a different viewport, and stepping the game is problematic because the camera might be modified.

Alternatively, we can duplicate the camera and disable the previous one. The drawback of this approach is not being able to leave the game running in a different viewport.

A camera could also have a shader! Distortion shader underwater, and perhaps a shake shader when hit.

Research material:

* [Insanely Twisted Shadow Planet camera system explanation](https://www.youtube.com/watch?v=aAKwZt3aXQM)

### Proper entity/component management

Giving each component its own type has several advantages:

1. Inspectors can show component values and possibly even edit them
2. Entity collections can keep track of entities per component, to speed up performance
3. Systems can declare which component types they need

To do:

1. [**DONE**] Use proper components everywhere (excluding renderers)
1. [**DONE**] Get components using `entity:get(Engine.Components.Z)`
1. [**DONE**] Define renderers

Optimisation:

1. [**DONE**] Allow getting all entities with certain components from an entity collection
1. [**DONE**] Let systems declare component types
1. Allow getting entities by components *efficiently*

### Relative passage of time

Some systems simply loop through all entities (with specific components) and update them, passing through the delta time that was received from all the way up.

Looping through these specific entities could be abstracted, so that only `updateEntity` needs to be implemented (that is part of the work to be done for proper entity/component management--see above).

This gives the system the power to pass through a *different* delta time. This gives the engine the power to make time pass slower or faster *per entity*. Think bullet time, or a “time bomb” that traps enemies in a time bubble.
