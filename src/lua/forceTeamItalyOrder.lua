cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

-- the first character, second is a byte after and third a byte after that
address = 0x108232

function on_memory_write(offset, data)
	print(string.format("offset: %x - %x", offset, data))
	if offset == 0x108232 then
		-- first character choice is being written
		-- force Joe
		-- return 0x11
	end

	if offset == 0x108233 then
		-- second character choice is being written
		-- force Terry
		-- return 0xf
	end

	if offset == 0x108234 then
		-- third character choice is being written
		-- force Andy
		-- return 0x10
	end
end

mem_handler = mem:install_write_tap(address, address + 3, "writes", on_memory_write)
