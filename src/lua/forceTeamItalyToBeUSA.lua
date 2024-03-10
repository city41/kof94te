cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1081c0

function on_memory_write(offset, data)
	print(string.format("write, offset: %x -- %x", offset, data))
	if data == 0xf0f then
		return 0xa0a
	end
end

mem_handler = mem:install_write_tap(address, address + 1, "writes", on_memory_write)
