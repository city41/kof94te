cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10d01c

function on_memory_read(offset, data, mask)
	print(string.format("overriding, o: %x, d: %x, m: %x, r: %x", offset, data, mask, 0x100))
	return 0x100
	-- if data == 0x1010 then
	-- 	return 0x8080
	-- end
end

mem_handler = mem:install_read_tap(address, address + 1, "writes", on_memory_read)
