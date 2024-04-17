cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]

vram = {}
next_vram_index = 0
vram_index_mod = 1

REG_VRAMADDR = 0x3c0000
REG_VRAMMOD = 0x3c0004
REG_VRAMRW = 0x3c0002

SCB1 = 0
FIX_LAYER = 0x7000
SCB2 = 0x8000
SCB3 = 0x8200
SCB4 = 0x8400
VRAM_SIZE = 0x8600

dumping = false

function getSpriteControlBlock()
	if next_vram_index < FIX_LAYER then
		if next_vram_index & 1 == 1 then
			return "scb1/odd"
		else
			return "scb1/even"
		end
	end

	if next_vram_index < SCB2 then
		return "fix"
	end

	if next_vram_index < SCB3 then
		return "scb2"
	end

	if next_vram_index < SCB4 then
		return "scb3"
	end

	return "scb4"
end

function getSpriteIndex()
	if next_vram_index < FIX_LAYER then
		return math.floor(next_vram_index / 64)
	end

	if next_vram_index < SCB3 then
		return next_vram_index - SCB2
	end

	if next_vram_index < SCB4 then
		return next_vram_index - SCB3
	end

	if next_vram_index < VRAM_SIZE then
		return next_vram_index - SCB4
	end

	-- in fix layer
	return -1
end

function getX(data)
	return data >> 7
end

function getY(data)
	return data >> 7
end

-- "emulate" vram to grab the data writes and store them in the vram table
function on_vram_write(offset, data)
	if offset == REG_VRAMADDR then
		next_vram_index = data
	end

	if offset == REG_VRAMMOD then
		vram_index_mod = data
	end

	if offset == REG_VRAMRW then
		if getSpriteControlBlock() == "scb3" then
			local y = getY(data)
			if y == 431 and dumping then
				print("looks like Andy is here, going to stop dumping")
				dumping = false
			end
		end

		vram[next_vram_index] = data
		next_vram_index = next_vram_index + vram_index_mod
	end
end

-- in lua it hits the cutscene twice, not sure why
hit_cutscene_init_count = 0

seen_addresses = {}

function on_rom_read(offset, data, mask)
	if offset == 0x350a8 then
		print("cutscene init")
		hit_cutscene_init_count = hit_cutscene_init_count + 1
		if hit_cutscene_init_count == 2 then
			print("starting to dump")
			dumping = true
		end
	end

	if dumping and offset < 0xfffff then
		local pc = tonumber(tostring(cpu.state["PC"]), 16)
		if offset ~= pc then
			if seen_addresses[offset] == nil then
				print(
					string.format(
						' { "address": "%x", "pc": "%x", "value": "%x", "mask": "%x"  },',
						offset,
						pc,
						data,
						mask
					)
				)
				seen_addresses[offset] = true
			end
		end
	end
end

vram_handler = mem:install_write_tap(REG_VRAMADDR, REG_VRAMMOD + 1, "vram", on_vram_write)
rom_handler = mem:install_read_tap(0, 0xfffff, "rom", on_rom_read)

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
		print("returning 1")
		return 0x100
	end
end

health_mem_handler = mem:install_read_tap(health_address, health_address + 1, "read health", on_health_memory_read)
timer_mem_handler = mem:install_write_tap(timer_address, timer_address + 3, "write timer", on_timer_memory_write)
