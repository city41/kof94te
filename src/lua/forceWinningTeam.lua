cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

first_address = 0x108232
first_val = 0x404 -- force Sie
second_address = 0x108234
second_val = 0x404 -- force Sie

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	local timer = mem:read_u8(0x108655)

	if tag == "PLAYER 1" and offset == first_address then
		print(string.format("overriding: offset: %x, data; %x, mask: %x, with: %x", offset, data, mask, first_val))
		return first_val
	end

	if tag == "PLAYER 1" and offset == second_address then
		print(string.format("overriding: offset: %x, data; %x, mask: %x, with: %x", offset, data, mask, second_val))
		return second_val
	end
end

mem_handler = mem:install_read_tap(first_address, second_address + 1, "reads", on_memory_read)

cpu_health_address = 0x108420

function on_cpu_health_memory_read(offset, data, mask)
	if offset == cpu_health_address then
		return 0
	end
end

cpu_heatlh_mem_handler =
	mem:install_read_tap(cpu_health_address, cpu_health_address + 1, "read", on_cpu_health_memory_read)
