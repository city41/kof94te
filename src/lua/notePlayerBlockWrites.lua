cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

p1_block_start = 0x108118
p1_block_end = 0x108310

writes = {}

function on_memory_write(offset, data)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if writes[tag] == nil then
		writes[tag] = {}
	end

	local tagWrites = writes[tag]

	if tagWrites[offset] == nil then
		tagWrites[offset] = 0
	end

	tagWrites[offset] = tagWrites[offset] + 1
end

mem_handler = mem:install_write_tap(p1_block_start, p1_block_end + 1, "writes", on_memory_write)

function get_keys(t)
	local keyset = {}
	local n = 0
	for k, v in pairs(t) do
		n = n + 1
		keyset[n] = k
	end

	return keyset
end

function dump_tag(tag)
	local tagWrites = writes[tag]
	local keys = get_keys(tagWrites)
	print(tag, #keys)
	for _, key in pairs(keys) do
		print(string.format("    %x", key))
	end
	print("")
end

function on_pause()
	print("paused")
	dump_tag("PLAYER1I")
	dump_tag("P1SELECT")
	dump_tag("P1  TEAM")
	dump_tag("P1MEMBER")
	dump_tag("PLAYER 1")
end

emu.register_pause(on_pause, "pause")
