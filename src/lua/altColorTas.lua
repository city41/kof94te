cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
debugger = cpu.debug

tracing = false

REG_P1CNT = 0x300000
REG_STATUS_B = 0x380000

press_start_to_title_frame = nil
press_start_to_play_frame = nil

START = 0x7e00

function on_statusb_read(offset, data, mask)
	if frame > 330 and press_start_to_title_frame == nil then
		press_start_to_title_frame = frame
		print(string.format("pressing start to enter title, o: %x, d: %x, m: %x", offset, data, mask))
		return START
	end

	if frame == press_start_to_title_frame then
		print(string.format("continuing to press start to enter title, o: %x, d: %x, m: %x", offset, data, mask))
		return START
	end

	if frame > 400 and press_start_to_play_frame == nil then
		press_start_to_play_frame = frame
		print(string.format("pressing start to play, o: %x, d: %x, m: %x", offset, data, mask))
		return START
	end

	if frame == press_start_to_play_frame then
		print(string.format("continuing to press start to play, o: %x, d: %x, m: %x", offset, data, mask))
		return START
	end
end

press_a_to_choose_team_play_frame = nil
press_a_to_choose_difficulty_frame = nil
press_a_to_skip_howtoplay_frame = nil
press_to_choose_italy_frame = nil

A_BUTTON = 0xef00
D_BUTTON = 0x7f00

TEAM_CHOICE_BUTTON = D_BUTTON

function on_reg_p1cnt_read(offset, data, mask)
	if frame > 450 and press_a_to_choose_team_play_frame == nil then
		press_a_to_choose_team_play_frame = frame
		print(string.format("pressing a to choose team play, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame == press_a_to_choose_team_play_frame then
		print(string.format("continuing to press a to choose team play, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame > 500 and press_a_to_choose_difficulty_frame == nil then
		press_a_to_choose_difficulty_frame = frame
		print(string.format("pressing a to choose difficulty, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame == press_a_to_choose_difficulty_frame then
		print(string.format("continuing to press a to choose difficulty, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame > 550 and press_a_to_skip_howtoplay_frame == nil then
		press_a_to_skip_howtoplay_frame = frame
		print(string.format("pressing a to skip how to play, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame == press_a_to_skip_howtoplay_frame then
		print(string.format("continuing to press a to skip how to play, o: %x, d: %x, m: %x", offset, data, mask))
		return A_BUTTON
	end

	if frame > 601 and press_to_choose_italy_frame == nil then
		press_to_choose_italy_frame = frame
		print(string.format("pressing to choose Italy, o: %x, d: %x, m: %x", offset, data, mask))
		return TEAM_CHOICE_BUTTON
	end

	if frame == press_to_choose_italy_frame then
		print(string.format("continuing to press to choose Italy, o: %x, d: %x, m: %x", offset, data, mask))
		return TEAM_CHOICE_BUTTON
	end
end

frame = 0

function dump_memory()
	for i = 0x100000, 0x10f2ff do
		local val = mem:read_u8(i)
		print(string.format("%x: %x", i, val))
	end
end

function on_frame()
	if press_to_choose_italy_frame ~= nil and frame == press_to_choose_italy_frame + 2 then
		manager.machine.debugger:command(
			'trace luatrace_alt.txt,,, { tracelog "D0=%x D1=%x D2=%x D3=%x D4=%x D5=%x D6=%x D7=%x A0=%x A1=%x A2=%x A3=%x A4=%x A5=%x A6=%x PC=%x -- ",d0,d1,d2,d3,d4,d6,d6,d7,a0,a1,a2,a3,a4,a5,a6,pc }'
		)
	end

	if press_to_choose_italy_frame ~= nil and frame == press_to_choose_italy_frame + 5 then
		manager.machine.debugger:command("trace off")
	end

	frame = frame + 1
end

emu.register_frame_done(on_frame, "frame")

p1cnt_read_handler = mem:install_read_tap(REG_P1CNT, REG_P1CNT + 1, "REG_P1CNT", on_reg_p1cnt_read)
statusb_read_handler = mem:install_read_tap(REG_STATUS_B, REG_STATUS_B + 1, "REG_STATUS_B", on_statusb_read)
