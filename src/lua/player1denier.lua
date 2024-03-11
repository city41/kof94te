cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10811a

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	local ret = 0

	if tag == "PLAYER 1" and offset == address and not denied then
		print(string.format("denying at %x (normally %x, returning %x)", offset, data, ret))
		return ret
	end
end

p1_mem_handler = mem:install_read_tap(address, address + 1, "writes", on_p1_memory_read)
