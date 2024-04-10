cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1081d8
ret = 0x0100

function on_memory_read(offset, data, mask)
	if offset == address then
		print(string.format("offset: %x, data: %x, mask: %x", offset, data, mask))
		return ret
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "reads", on_memory_read)
