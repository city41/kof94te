cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

andy_address = 0x1081c1
joe_address = 0x1081c2

function on_memory_write(offset, data)
	print(string.format("offset: %x - %x", offset, data))
	if offset == 0x1081c0 and data == 0x1010 then
		return 0x1111
	end

	if offset == 0x1081c2 and data == 0x1111 then
		return 0x1010
	end
end

mem_handler = mem:install_write_tap(andy_address - 1, joe_address + 1, "writes", on_memory_write)
