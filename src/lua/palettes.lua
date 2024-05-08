-- Visualizes chosen palettes

cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]
vramdevice = emu.item(manager.machine.devices[":spritegen"].items["0/m_videoram"])

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

inUsePalettes = {}

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

function getPalette(data)
	return data >> 8
end

function on_vram_write(offset, data)
	if offset == REG_VRAMADDR then
		next_vram_index = data
	end

	if offset == REG_VRAMMOD then
		vram_index_mod = data
	end

	if offset == REG_VRAMRW then
		if getSpriteControlBlock() == "scb1/odd" then
			local pal = getPalette(data)
			inUsePalettes[pal] = true
		end

		next_vram_index = next_vram_index + vram_index_mod
	end
end

function spairs(t, order)
	-- collect the keys
	local keys = {}
	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a, b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function convert16to24(col16)
	local shadowBit = 1
	local darkBit = col16 >> 15

	local rLSB = (col16 >> 14) & 1
	local gLSB = (col16 >> 13) & 1
	local bLSB = (col16 >> 12) & 1

	local rMSB = (col16 >> 8) & 0xf
	local gMSB = (col16 >> 4) & 0xf
	local bMSB = col16 & 0xf

	local r = (rMSB << 4) | (rLSB << 3) | (darkBit << 2) | (shadowBit << 1)
	local g = (gMSB << 4) | (gLSB << 3) | (darkBit << 2) | (shadowBit << 1)
	local b = (bMSB << 4) | (bLSB << 3) | (darkBit << 2) | (shadowBit << 1)

	return (0xff << 24) | (r << 16) | (g << 8) | b
end

boxSize = 4
yOffset = boxSize

function draw_palette(pali, x)
	for i = 0, 15 do
		local pramVal = mem:read_u16(0x400000 + pali * 32 + (i * 2))
		local color = convert16to24(pramVal)
		screen:draw_box(x, i * boxSize + yOffset, x + boxSize, ((i + 1) * boxSize) + yOffset, 0, color)
	end
end

function visualize_palettes()
	-- local x = boxSize
	-- local palCount = 0

	-- for pali, _ in spairs(inUsePalettes) do
	-- 	draw_palette(pali, x)
	-- 	x = x + boxSize
	-- 	palCount = palCount + 1
	-- end

	draw_palette(0xa0, 16)
	-- screen:draw_box(boxSize - 1, yOffset - 1, boxSize * (palCount + 1) + 1, yOffset + boxSize * 16 + 1, 0xffff0000, 0)
end

function grab_fixPalettes()
	for i = FIX_LAYER, SCB2 - 1 do
		local fixword = vramdevice:read(i)
		local fixpal = fixword >> 12
		inUsePalettes[fixpal] = true
	end
end

function on_frame()
	grab_fixPalettes()
	visualize_palettes()

	inUsePalettes = {}
end

emu.register_frame_done(on_frame, "frame")

vram_handler = mem:install_write_tap(REG_VRAMADDR, REG_VRAMMOD + 1, "vram", on_vram_write)
