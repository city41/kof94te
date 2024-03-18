cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

t1c1 = { address = 0x102970, value = 0x0000 }
t1c2 = { address = 0x102b70, value = 0x0007 }
t1c3 = { address = 0x102d70, value = 0x000a }
t2c1 = { address = 0x102f70, value = 0x0012 }
t2c2 = { address = 0x103170, value = 0x0008 }
t2c3 = { address = 0x103370, value = 0x0003 }

chars = { t1c1, t1c2, t1c3, t2c1, t2c2, t2c3 }

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x102910, 0x102917, 8)

	if tag ~= "MEMBDISP" then
		return
	end

	for _, char in pairs(chars) do
		if char.address == offset then
			return char.value
		end
	end
end

mem_handler = mem:install_read_tap(t1c1.address, t2c3.address + 1, "writes", on_memory_read)
