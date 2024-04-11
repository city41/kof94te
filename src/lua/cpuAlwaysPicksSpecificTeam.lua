cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

CPU_CURSOR_ADDRESS = 0x1083c0

ITALY = 0
CHINA = 0x100
JAPAN = 0x200
USA = 0x300
KOREA = 0x400
BRAZIL = 0x500
ENGLAND = 0x600
MEXICO = 0x700

function on_memory_read(offset, data, mask)
	return BRAZIL
end

mem_handler = mem:install_read_tap(CPU_CURSOR_ADDRESS, CPU_CURSOR_ADDRESS + 1, "read", on_memory_read)
