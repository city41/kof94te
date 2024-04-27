cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10b8fc

function on_memory_writes(offset, data, mask)
	print(string.format("write--o: %x, d: %x, m: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
end

function on_memory_reads(offset, data, mask)
	print(string.format("read--o: %x, d: %x, m: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
end

write_mem_handler = mem:install_write_tap(address, address + 97, "writes", on_memory_writes)
read_mem_handler = mem:install_read_tap(address, address + 97, "reads", on_memory_reads)

health_address = 0x108220
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
		print("returning 1")
		return 0x100
	end
end

health_mem_handler = mem:install_read_tap(health_address, health_address + 1, "read health", on_health_memory_read)
timer_mem_handler = mem:install_write_tap(timer_address, timer_address + 3, "write timer", on_timer_memory_write)
