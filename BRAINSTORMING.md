# Brainstorming

## To do

* Do not hardcode signal constants
* Allow getting entities by components efficiently

### Transparent game states

It is useful to have multiple game states in a stack rendered. For example, a pause state or an in-game menu state could still have the state below it rendered. The topmost state (e.g. pause, menu) should likely draw a full-screen semi-opaque black rectangle so that the underlying game is marked as inactive.

## Research material

* [Insanely Twisted Shadow Planet camera system explanation](https://www.youtube.com/watch?v=aAKwZt3aXQM)
