cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1081c0

function on_memory_write(offset, data, mask)
	print(string.format("write, offset: %x -- %x (%x)", offset, data, mask))
	if data == 0xf0f then
		local tag = mem:read_range(0x108110, 0x108117, 8)
		print(string.format("%s, returning Team USA instead", tag))

		return 0xa0a
	end
end

mem_handler = mem:install_write_tap(address, address + 1, "writes", on_memory_write)
