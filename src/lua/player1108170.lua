cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108170

CHARACTER_ID = 0x6

function on_p1_memory_read(offset, data)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "PLAYER 1" and offset == address then
		return CHARACTER_ID
	end
end

p1_mem_handler = mem:install_read_tap(address, address + 1, "writes", on_p1_memory_read)
