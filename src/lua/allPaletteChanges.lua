-- Visualizes all sprite bounding boxes
cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]

-- one palette is 16 words, 32 bytes
PALETTE_SIZE = 32
PALETTE_BASE_ADDRESS = 0x400000

function on_palette_write(offset, data, mask)
	if offset == 0x401ffe then
		return
	end

	print(string.format("o: %x, d: %x, m: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
end

palette_handler = mem:install_write_tap(
	PALETTE_BASE_ADDRESS,
	PALETTE_BASE_ADDRESS + PALETTE_SIZE * 256 + 1,
	"palette",
	on_palette_write
)
