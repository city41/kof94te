cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
-- debug = cpu.debug

-- REG_P1CURRENT
address = 0x300000

frame = 0

-- if in how to play, return A is down to move to team select ASAP
function on_memory_read(offset, data, mask)
	local even = (frame & 1) == 0
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if even or tag ~= "P1SELECT" then
		return
	end

	print(string.format("returning A, frame: %d", frame))
	return 0xefef
end

mem_handler = mem:install_read_tap(address, address + 1, "read", on_memory_read)

function on_frame()
	frame = frame + 1
end

emu.register_frame_done(on_frame, "frame")

-- debug:wpset("program", "r", 0x300000, 1, "wpdata == ef", "{ trace traceCondensedLoops.txt; g }")
-- debug:bpset(0x37124, "", "{ trace off; g }")

-- debug:go()
