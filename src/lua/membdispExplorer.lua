cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1029d8
value = 0x0100

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x102910, 0x102917, 8)

	if tag == "MEMBDISP" and offset == address then
		print(string.format("%x:forcing %x over %x, mask: %x", address, value, data, mask))
		return value
	end
end

p1_mem_handler = mem:install_read_tap(address, address + 3, "reads", on_p1_memory_read)
