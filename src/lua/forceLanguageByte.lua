cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108836

function on_memory_read(offset, data, mask)
	return 0
end

mem_handler = mem:install_read_tap(address, address + 1, "reads", on_memory_read)
