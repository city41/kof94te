cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108654

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	local ret = 0

	if tag == "P1  TEAM" and offset == address then
		return 0x1000
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "writes", on_memory_read)
