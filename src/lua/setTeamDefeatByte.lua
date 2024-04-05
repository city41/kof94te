cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1087de

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	-- print(string.format("%s: offset: %x, data: %x, mask: %x", tag, offset, data, mask))

	if address == offset and mask == 0xffff then
		local ret = (data & 0xff00) | 0xe8
		print(string.format("returing: %x, offset; %x, data: %x, mask: %x", ret, offset, data, mask))
		return ret
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "reads", on_memory_read)
