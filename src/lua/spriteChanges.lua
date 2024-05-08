-- Visualizes all sprite bounding boxes
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

SPRITE_INDEX = 181

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

function getPalette(data)
	return data >> 8
end

-- "emulate" vram to grab the data writes and store them in the vram table
function on_vram_write(offset, data)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if offset == REG_VRAMADDR then
		next_vram_index = data
	end

	if offset == REG_VRAMMOD then
		vram_index_mod = data
	end

	if offset == REG_VRAMRW then
		if getSpriteControlBlock() == "scb1/even" and getSpriteIndex() == 181 and data == 0x3f90 then
			print(string.format("write at %s for si %d", cpu.state["PC"], getSpriteIndex()))
		end

		vram[next_vram_index] = data
		next_vram_index = next_vram_index + vram_index_mod
	end
end

vram_handler = mem:install_write_tap(REG_VRAMADDR, REG_VRAMMOD + 1, "vram", on_vram_write)

function on_frame()
	-- for a, b in pairs(cpu.state) do
	-- 	print("a", a)
	-- 	print("b", b)
	-- end
end

emu.register_frame_done(on_frame, "frame")
