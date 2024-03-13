cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
screen = manager.machine.screens[":screen"]

frame = 0
value = 0
address = 0xf6d18
go = false

function on_memory_read(offset, data, mask)
	go = true
	return value
end

mem_handler = mem:install_read_tap(address, address + 1, "read", on_memory_read)

function on_frame()
	if go then
		frame = frame + 1
		local index = math.floor(frame / 30)
		value = index << 12
	end
	screen:draw_text(10, 10, string.format("%x", value), 0xffffffff, 0xff000000)
end

function on_pause()
	go = false
end

emu.register_frame_done(on_frame, "frame")
emu.register_pause(on_pause, "pause")
