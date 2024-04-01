cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

health_address = 0x108420
timer_address = 0x10882e

function on_health_memory_read(offset, data, mask)
	if offset == health_address then
		return 0
	end
end

timer_written = false

--- sets the timer to 1 instead of 60
function on_timer_memory_write(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if
		tag == "PLAYER 1"
		and offset == timer_address
		and mask == 0xff00
		and (data & mask) == 0x6000
		and not timer_written
	then
		-- only setting the first round to one second
		-- as winning the match by time out causes a different win sequence (opponent doesn't fall)
		timer_written = true
		print("returning one")
		return 0x100
	end
end

health_mem_handler = mem:install_read_tap(health_address, health_address + 1, "read health", on_health_memory_read)
timer_mem_handler = mem:install_write_tap(timer_address, timer_address + 3, "write timer", on_timer_memory_write)
