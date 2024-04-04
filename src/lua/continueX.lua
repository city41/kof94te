cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x45448

function on_p1_memory_read(offset, data, mask)
	return 0
end

p1_mem_handler = mem:install_read_tap(address, address + 1, "reads", on_p1_memory_read)
