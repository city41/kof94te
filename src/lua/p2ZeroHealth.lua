cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

health_address = 0x108420
timer_address = 0x10882e

function on_health_memory_read(offset, data, mask)
	if offset == health_address then
		return 0
	end
end

--- sets the timer to 1 instead of 60
function on_timer_memory_write(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "PLAYER 1" and offset == timer_address and mask == 0xff00 and (data & mask) == 0x6000 then
		print("returning one")
		return 0x100
	end
end

health_mem_handler = mem:install_read_tap(health_address, health_address + 1, "read health", on_health_memory_read)
timer_mem_handler = mem:install_write_tap(timer_address, timer_address + 3, "write timer", on_timer_memory_write)

portrait_address = 0x10f94c

ret = 0

function on_portrait_memory_read(offset, data, mask)
	if offset == portrait_address then
		local r = data
		ret = ret + 10
		print(string.format("returning %d for terry, o: %x, d: %x, m: %x", r, offset, data, mask))
		return r
	end
end

portrait_mem_handler = mem:install_read_tap(portrait_address, portrait_address + 1, "read", on_portrait_memory_read)
