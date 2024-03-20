cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x10b9d2
frame = 0

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)
	local p2Index = mem:read_u8(0x1083c0)
	local timer = mem:read_u8(0x108655)

	if tag == "P1  TEAM" and offset == address and p2Index == 7 then
		print(string.format("%d:returning A is pressed, timer: %x", frame, timer))
		return 0x1000
	end
end

mem_handler = mem:install_read_tap(address, address + 1, "reads", on_memory_read)

function on_frame()
	frame = frame + 1
end

emu.register_frame_done(on_frame, "frame")
