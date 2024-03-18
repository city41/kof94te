vramdevice = emu.item(manager.machine.devices[":spritegen"].items["0/m_videoram"])

ROWS = 32
COLS = 40

FIX_LAYER = 0x7000
VRAM_SIZE = 0x8600

fix_ram = {}

function grab_fix_ram()
	for i = FIX_LAYER, VRAM_SIZE - 1 do
		fix_ram[i - FIX_LAYER] = vramdevice:read(i)
	end
end

function dump_fix()
	grab_fix_ram()

	for y = 0, ROWS - 1 do
		for x = 0, COLS - 1 do
			local val = fix_ram[x * ROWS + y] & 0xfff
			local sep = x == 0 and "" or "|"
			local vals = val == 0xf20 and " .. " or string.format("%04x", val)
			io.write(string.format("%s%s", sep, vals))
		end
		print()
	end
end

emu.register_pause(dump_fix, "pause")
