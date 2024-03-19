cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10b9d2

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "P1  TEAM" and offset == address then
		print(string.format("offset: %x, data: %x, mask: %x", offset, data, mask))
		return 0x400
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "reads", on_memory_read)
