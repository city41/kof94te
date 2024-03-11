cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

frame = 0

p1_block_start = 0x108118
p1_block_end = 0x108310

accesses = {}

function on_memory_write(offset, raw_data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag ~= "P1  TEAM" and tag ~= "P1MEMBER" then
		return
	end

	local data = raw_data

	if mask == 0xff00 then
		data = (raw_data & mask) >> 8
	else
		data = raw_data & mask
	end

	local access = {}
	access.frame = frame
	access.tag = tag
	access.type = "write"
	access.offset = offset
	access.data = data
	table.insert(accesses, access)
end

function on_memory_read(offset, raw_data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if tag ~= "P1  TEAM" and tag ~= "P1MEMBER" then
		return
	end

	local data = raw_data

	if mask == 0xff00 then
		data = (raw_data & mask) >> 8
	else
		data = raw_data & mask
	end

	local access = {}
	access.frame = frame
	access.tag = tag
	access.type = "read"
	access.offset = offset
	access.data = data
	table.insert(accesses, access)
end

write_handler = mem:install_write_tap(p1_block_start, p1_block_end + 1, "writes", on_memory_write)
read_handler = mem:install_read_tap(p1_block_start, p1_block_end + 1, "reads", on_memory_read)

function dump_accesses()
	for _, access in pairs(accesses) do
		print(string.format("%s (%d:%s) %x : %x", access.tag, access.frame, access.type, access.offset, access.data))
	end
end

function on_pause()
	dump_accesses()
end

function on_frame()
	frame = frame + 1
end

emu.register_pause(on_pause, "pause")
emu.register_frame_done(on_frame, "frame")
