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

tracing = false
turn_off_tracing = false

-- "emulate" vram to grab the data writes and store them in the vram table
function on_vram_write(offset, data)
	if turn_off_tracing then
		print("turned off tracing")
		manager.machine.debugger:command("trace off")
		turn_off_tracing = false
		tracing = false
	end

	if offset == REG_VRAMADDR then
		next_vram_index = data
	end

	if offset == REG_VRAMMOD then
		vram_index_mod = data
	end

	if offset == REG_VRAMRW then
		if getSpriteControlBlock() == "scb4" then
			local x = getX(data)
			if x == 114 and tracing then
				turn_off_tracing = true
				print(
					string.format(
						"looks like Andy is here, going to stop tracing, o: %x, d: %x at %s",
						offset,
						data,
						cpu.state["PC"]
					)
				)
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
	if offset == 0x66d66 and not tracing then
		print("starting to trace")
		tracing = true
		manager.machine.debugger:command(
			'trace cutsceneTrace.txt,,,{ tracelog "D0=%x D1=%x D2=%x D3=%x D4=%x D5=%x D6=%x D7=%x A0=%x A1=%x A2=%x A3=%x A4=%x A5=%x A6=%x A7=%x -- ",d0,d1,d2,d3,d4,d6,d6,d7,a0,a1,a2,a3,a4,a5,a6,a7 }'
		)
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
