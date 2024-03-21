cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1081d8
ret = 0x0000

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "P1MEMBER" and offset == address then
		print(string.format("%x:forcing %x over %x, mask: %x", address, ret, data, mask))
	end
end

p1_mem_handler = mem:install_read_tap(address, address + 3, "reads", on_p1_memory_read)
