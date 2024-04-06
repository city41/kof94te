cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

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

TEAM_CHOICE_BUTTON = A_BUTTON

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

	if frame > 700 and press_to_choose_italy_frame == nil then
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
	-- if frame == press_to_choose_italy_frame then
	-- 	dump_memory()
	-- end
	frame = frame + 1
end

emu.register_frame_done(on_frame, "frame")

p1cnt_read_handler = mem:install_read_tap(REG_P1CNT, REG_P1CNT + 1, "REG_P1CNT", on_reg_p1cnt_read)
statusb_read_handler = mem:install_read_tap(REG_STATUS_B, REG_STATUS_B + 1, "REG_STATUS_B", on_statusb_read)

color_address = 0x10b9d3

should_overwrite = false

function on_memory_write(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	if not should_overwrite and tag == "P1MEMBER" then
		should_overwrite = true
	end

	if should_overwrite then
		if data == 0 then
			print(string.format("overriding, o: %x, d: %x, m: %x, r: %x", offset, data, mask, 0x8080))
			return 0x8080
		end
	end
end

color_mem_handler = mem:install_read_tap(color_address - 1, color_address, "writes", on_memory_write)
