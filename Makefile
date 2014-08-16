default: test

test:
	busted -m ./\?/init.lua engine_spec
