cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x1083c0

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108310, 0x108317, 8)
	print(string.format("write, offset: %x -- %x (%x)", offset, data, mask))
	if tag == "P2MEMBER" and mask == 0xff00 then
		print(string.format("%s, returning Team Italy instead for cpu", tag))

		return 0x1f1f
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "writes", on_memory_read)
