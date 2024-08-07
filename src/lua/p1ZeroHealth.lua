cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

health_address = 0x108220
timer_address = 0x10882e

return_zero = true

function on_health_memory_read(offset, data, mask)
	if offset == health_address and return_zero then
		return 0
	end
end

--- sets the timer to 1 instead of 60
function on_timer_memory_write(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "PLAYER 1" and offset == timer_address and mask == 0xff00 and (data & mask) == 0x6000 and return_zero then
		print("returning 1")
		return 0x100
	end
end

health_mem_handler = mem:install_read_tap(health_address, health_address + 1, "read health", on_health_memory_read)
timer_mem_handler = mem:install_write_tap(timer_address, timer_address + 3, "write timer", on_timer_memory_write)

function on_pause()
	return_zero = not return_zero

	print("return zero?", return_zero)
end

emu.register_pause(on_pause, "pause")
