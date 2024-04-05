cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10d01d

function on_memory_read(offset, data, mask)
	if offset == address then
		print(string.format("offset: %x, data: %x, mask: %x, returning 1", offset, data, mask))
		return 1
	end

	if offset == (address - 1) and mask == 0xffff then
		local ret = (data & 0xff00) | 1
		print(string.format("offset: %x, data: %x, mask: %x, returning: %x", offset, data, mask, ret))
		return ret
	end
end

mem_handler = mem:install_read_tap(address - 1, address, "reads", on_memory_read)
