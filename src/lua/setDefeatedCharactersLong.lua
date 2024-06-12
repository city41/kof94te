cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10f8d4

function on_memory_read(offset, data, mask)
	return 0xffff
end

mem_handler = mem:install_read_tap(address, address + 3, "reads", on_memory_read)
