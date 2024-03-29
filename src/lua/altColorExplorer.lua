cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

min_address = 0x1029d8
max_address = 0x102dd8
addresses = { [min_address] = true, [0x102bd8] = true, [max_address] = true }
ret = 0x0100

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	print(string.format("tag: %s, offset: %x, data: %x, mask: %x", tag, offset, data, mask))

	if (tag == "P1MEMBER" or tag == "P1  TEAM") and addresses[offset] then
		return ret
	end
end

p1_mem_handler = mem:install_read_tap(min_address, max_address + 3, "reads", on_p1_memory_read)
