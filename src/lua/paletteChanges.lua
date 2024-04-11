-- Visualizes all sprite bounding boxes
cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]

-- one palette is 16 words, 32 bytes
PALETTE_SIZE = 32
PALETTE_BASE_ADDRESS = 0x400000

-- the first palette used by chosen Athena avatar
PALETTE_OF_INTEREST = 0x4e
PALETTE_ADDRESS_OF_INTEREST = PALETTE_BASE_ADDRESS + (PALETTE_SIZE * PALETTE_OF_INTEREST)

function on_palette_write(offset, data, mask)
	print(string.format("o: %x, d: %x, m: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
end

palette_handler =
	mem:install_write_tap(PALETTE_ADDRESS_OF_INTEREST, PALETTE_ADDRESS_OF_INTEREST + 1, "palette", on_palette_write)
