cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

local p1_char1_address = 0x1081c1
local p1_char2_address = 0x1081c2
local p2_char1_address = 0x1083c1
local p2_char2_address = 0x1083c2

CHARACTER_ID = 0x17

function on_p1_memory_write(offset, data)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag == "P1MEMBER" and offset == 0x1081c0 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end

	if tag == "P1MEMBER" and offset == 0x1081c2 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end
end

function on_p2_memory_write(offset, data)
	local tag = mem:read_range(0x108310, 0x108317, 8)

	if tag == "P2MEMBER" and offset == 0x1083c0 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end

	if tag == "P2MEMBER" and offset == 0x1083c2 then
		return CHARACTER_ID << 8 | CHARACTER_ID
	end
end

p1_mem_handler = mem:install_write_tap(p1_char1_address - 1, p1_char2_address + 1, "writes", on_p1_memory_write)
p2_mem_handler = mem:install_write_tap(p2_char1_address - 1, p2_char2_address + 1, "writes", on_p2_memory_write)
