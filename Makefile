default: test

test:
	busted -m ./\?/init.lua engine/spec/systems/physics_spec.lua
