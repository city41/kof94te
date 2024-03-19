-- Visualizes all sprite bounding boxes
cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]

vram = {}
-- where vram will write to next
next_vram_index = 0
-- how much to move the index based on REG_VRAMMOD
vram_index_mod = 1

-- where the game wants to write in VRAM
REG_VRAMADDR = 0x3c0000
-- how much to move the index after a write
REG_VRAMMOD = 0x3c0004
-- a data write
REG_VRAMRW = 0x3c0002

SCB1 = 0
SCB2 = 0x8000
SCB3 = 0x8200
SCB4 = 0x8400
VRAM_SIZE = 0x8600
FIX_LAYER = 0x7000

-- toggle sprites/fix on/off
SHOW_SPRITES = true
SHOW_FIX_LAYER = true

-- "emulate" vram to grab the data writes and store them in the vram table
function on_vram_write(offset, data)
	if offset == REG_VRAMADDR then
		next_vram_index = data
	end

	if offset == REG_VRAMMOD then
		vram_index_mod = data
	end

	if offset == REG_VRAMRW then
		next_vram_index = next_vram_index + vram_index_mod

		if (not SHOW_FIX_LAYER) and next_vram_index >= FIX_LAYER and next_vram_index <= SCB2 then
			return 0xff
		end

		if (not SHOW_SPRITES) and next_vram_index >= SCB3 and next_vram_index <= SCB4 then
			if next_vram_index < SCB3 + 129 then
				return 0
			end

			if next_vram_index > SCB3 + 144 then
				return 0
			end
		end
	end
end

function isSticky(si, vr)
	local scb3Val = vr[SCB3 + si] or 0

	return scb3Val & 0x40 == 0x40
end

function getSpriteHeight(si, vr)
	if isSticky(si, vr) then
		return getSpriteHeight(si - 1, vr)
	end

	local scb3Val = vr[SCB3 + si] or 0
	return scb3Val & 0x3f
end

function dewrap(v, wrapBoundary)
	while v > wrapBoundary do
		v = v - 512
	end

	while v < -wrapBoundary do
		v = v + 512
	end

	return v
end

function getSpriteY(si, vr)
	if isSticky(si, vr) then
		return getSpriteY(si - 1, vr)
	end

	local scb3Val = vr[SCB3 + si] or 0

	local y = scb3Val >> 7

	-- handle 9 bit two's compliment
	if y > 256 then
		y = y - 512
	end

	y = 496 - y

	return y
end

-- TODO: support sprite scaling
function getSpriteX(si, vr)
	if isSticky(si, vr) then
		return getSpriteX(si - 1, vr) + 16
	end

	local scb4Val = vr[SCB4 + si] or 0

	x = scb4Val >> 7

	return x
end

function clamp(v, min, max)
	return math.min(max, math.max(min, v))
end

function isOnScreen(left, top, right, bottom)
	return not (right < 0 or bottom < 0 or left > 320 or top > 224)
end

RED = 0xffff0000
ORANGE = 0xffffaa00
PURPLE = 0xffaa00ff
WHITE = 0xffffffff

colors = { RED, ORANGE, PURPLE, WHITE }

function visualize_boundingBoxes()
	for i = 0, 380 do
		local ht = getSpriteHeight(i, vram)
		local hpx = ht * 16
		local x = dewrap(getSpriteX(i, vram), 320)
		local y = dewrap(getSpriteY(i, vram), 224)

		local left = x
		local top = y
		-- TODO: support sprite scaling
		local right = dewrap(x + 16, 320)
		-- TODO: support sprite scaling
		local bottom = y + hpx

		if bottom > 512 then
			-- sprite has wrapped back around to the top
			-- its visible portion starts at the top of the screen
			top = 0
			-- and this is the amount that has wrapped and become visible
			bottom = hpx - (512 - 224)
		end

		if right > 512 then
			-- sprite has wrapped back around to the left side
			-- its visible portion starts at the left of the screen
			left = 0
			-- and this is the amount that has wrapped and become visible
			right = 16 - (512 - 320)
		end

		if isOnScreen(left, top, right, bottom) then
			screen:draw_box(
				clamp(left, 0, 320),
				clamp(top, 0, 224),
				clamp(right, 0, 320),
				clamp(bottom, 0, 224),
				colors[i % 4],
				0
			)

			screen:draw_text(clamp(left, 0, 320), clamp(top, 0, 224), tostring(i), 0xffffffff, 0xff000000)
		end
	end
end

vramdevice = emu.item(manager.machine.devices[":spritegen"].items["0/m_videoram"])

function grab_vram()
	for i = 0, VRAM_SIZE - 1 do
		vram[i] = vramdevice:read(i)
	end
end

function on_frame()
	grab_vram()
	visualize_boundingBoxes()
end

function getSpriteScb1(si, vr, h)
	local words = {}

	local base = SCB1 + si * 64

	for i = 0, h - 1 do
		local word = {}
		word.evenWord = vr[base + i * 2] or 0
		word.oddWord = vr[base + i * 2 + 1] or 0

		table.insert(words, word)
	end

	return words
end

function dump_sprite_asm(si, ci)
	local h = getSpriteHeight(si, vram)

	local scb1Words = getSpriteScb1(si, vram, h)
	local scb3 = vram[SCB3 + si]
	local scb4 = vram[SCB4 + si]

	print(string.format(";;;;;;; column %d, %d tiles high ;;;;;;;", ci, h))
	print(";; SCB1 word pairs")
	for _, words in pairs(scb1Words) do
		print(string.format("dc.w $%x", words.evenWord))
		print(string.format("dc.w $%x", words.oddWord))
	end

	print("")
	print(";; SCB3 vertical position | sticky | size")
	print(string.format("dc.w $%x", scb3))

	print("")
	print(";; SCB4 horizontal position")
	print(string.format("dc.w $%x", scb4))
	print("")
	print("")
end

function on_pause()
	-- grab_vram()
	-- for i = 130, 143 do
	-- dump_sprite_asm(i, i - 130)
	-- end
	dump_sprite_asm(98, 0)
	dump_sprite_asm(99, 0)
end

emu.register_frame_done(on_frame, "frame")
emu.register_pause(on_pause, "pause")

vram_handler = mem:install_write_tap(REG_VRAMADDR, REG_VRAMMOD + 1, "vram", on_vram_write)
