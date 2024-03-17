cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x102970
value = 0x100000

function on_p1_memory_read(offset, data, mask)
	local tag = mem:read_range(0x102910, 0x102917, 8)

	if tag == "MEMBDISP" and offset == address then
		local highWord = value >> 16
		print(string.format("%x:forcing %x over %x, mask: %x", address, highWord, data, mask))
		return highWord
	end

	if tag == "MEMBDISP" and offset == address + 2 then
		local lowWord = value & 0xffff
		print(string.format("%x:forcing %x over %x, mask: %x", address, lowWord, data, mask))
		return lowWord
	end
end

p1_mem_handler = mem:install_read_tap(address, address + 3, "writes", on_p1_memory_read)
