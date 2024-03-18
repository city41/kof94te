cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x102970
frame = 0

function on_write(offset, data, mask)
	print(string.format("%d:offset: %x, data: %x, mask: %x, pc: %s", frame, offset, data, mask, cpu.state["PC"]))
end

handler = mem:install_write_tap(address, address + 1, "write", on_write)

function on_frame()
	frame = frame + 1
end

emu.register_frame_done(on_frame, "frame")
