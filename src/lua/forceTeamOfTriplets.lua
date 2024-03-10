cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

local char1_address = 0x1081c1
local char2_address = 0x1081c2

function on_memory_write(offset, data)
	local CHARACTER_ID = 0x1b

	local tag = mem:read_range(0x108110, 0x108117, 8)

	print(string.format("tag: %s, offset: %x - %x", tag, offset, data))
	if tag == "P1MEMBER" and offset == 0x1081c0 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end

	if tag == "P1MEMBER" and offset == 0x1081c2 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end
end

mem_handler = mem:install_write_tap(char1_address - 1, char2_address + 1, "writes", on_memory_write)
