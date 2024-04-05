cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

min_address = 0x1029d8
max_address = 0x102dd8
addresses = { [min_address] = true, [0x102bd8] = true, [max_address] = true }
ret = 0x0100

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	-- print(string.format("tag: %s, offset: %x, data: %x, mask: %x", tag, offset, data, mask))

	if (tag == "P1MEMBER" or tag == "P1  TEAM") and addresses[offset] then
		return ret
	end
end

p1_mem_handler = mem:install_read_tap(min_address, max_address + 3, "reads", on_p1_memory_read)

byte_address = 0x1081d8

function on_byte_read(offset, data, mask)
	if offset == byte_address then
		print(string.format("byte----->offset: %x, data: %x, mask: %x", offset, data, mask))
		return 0x0100
	end
end

byte_mem_handler = mem:install_read_tap(byte_address, byte_address + 1, "byte", on_byte_read)
