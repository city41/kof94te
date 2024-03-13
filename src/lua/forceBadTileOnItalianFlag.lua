cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0xf6d14

function on_memory_read(offset, data, mask)
	if data == 0xdcac then
		return 0x111
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "read", on_memory_read)
