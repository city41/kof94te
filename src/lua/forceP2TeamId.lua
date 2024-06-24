cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108431

function on_memory_read(offset, data, mask)
	print(string.format("read at o: %x, d: %x, m: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
	return 0x0202 & mask
end

mem_handler = mem:install_read_tap(address - 1, address, "reads", on_memory_read)
