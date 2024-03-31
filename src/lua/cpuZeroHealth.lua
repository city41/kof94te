cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108420

function on_memory_read(offset, data, mask)
	if offset == address then
		return 0
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "read", on_memory_read)
