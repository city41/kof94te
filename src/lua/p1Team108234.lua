cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108234

CHARACTER_ID = 0x6

function on_p1_memory_write(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "P1  TEAM" and offset == address then
		print(string.format("offset: %x, data: %x, mask: %x", offset, data, mask))
		return CHARACTER_ID
	end
end

p1_mem_handler = mem:install_write_tap(address, address + 1, "writes", on_p1_memory_write)
